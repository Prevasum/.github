#!/usr/bin/env bash
# Checks that deliver.yml's build gives one image digest per commit, using the
# build args read from the workflow. Two control builds without them must
# differ, or the check can't see the build time at all.
#
# Run from the repo root. Needs docker with buildx, jq, and mikefarah's yq v4.

set -euo pipefail

workflow=.github/workflows/deliver.yml
tmp=$(mktemp -d)
builder="deliver-reproducible-$$"
trap 'docker buildx rm --force "$builder" >/dev/null 2>&1 || true; rm -rf "$tmp"' EXIT

step() { yq -e ".jobs.build.steps[] | select(.id == \"$1\") | $2" "$workflow"; }

GITHUB_OUTPUT=$tmp/output bash -euo pipefail -c "$(step source-date-epoch .run)"
epoch=$(sed -n 's/^epoch=//p' "$tmp/output")
if ! [[ "$epoch" =~ ^[0-9]+$ ]]; then
  echo "::error::The source-date-epoch step gave '$epoch', not a time in seconds."
  exit 1
fi

sha=$(git rev-parse HEAD)
deliver_args=()
# shellcheck disable=SC2016
while IFS= read -r arg; do
  [ -n "$arg" ] || continue
  arg=${arg//'${{ github.sha }}'/$sha}
  arg=${arg//'${{ steps.source-date-epoch.outputs.epoch }}'/$epoch}
  if [[ "$arg" == *'${{'* ]]; then
    echo "::error::This check can't fill in the build arg '$arg'. Teach it the expression."
    exit 1
  fi
  deliver_args+=(--build-arg "$arg")
done < <(step push '.with["build-args"]')

mkdir "$tmp/context"
# COPY keeps a file's mtime, so a fixed one keeps the layer's digest fixed.
echo "a file the image copies" >"$tmp/context/file"
touch -d @0 "$tmp/context/file"
cat >"$tmp/context/Dockerfile" <<'DOCKERFILE'
FROM scratch
ARG GIT_SHA
LABEL git-sha=$GIT_SHA
COPY file /file
DOCKERFILE

# Each build starts in a later second than the last one ended, since two
# builds in one second could match without SOURCE_DATE_EPOCH.
ended=0
build() {
  local name=$1
  shift
  while [ "$(date +%s)" -le "$ended" ]; do sleep 0.1; done
  echo "==> Building $name $*"
  docker buildx create --name "$builder" --driver docker-container >/dev/null
  if ! docker buildx build --builder "$builder" --provenance=false --sbom=false "$@" \
      --metadata-file "$tmp/$name.json" --output "type=oci,dest=$tmp/$name.tar" \
      "$tmp/context" 2>"$tmp/$name.log"; then
    cat "$tmp/$name.log"
    exit 1
  fi
  docker buildx rm --force "$builder" >/dev/null 2>&1
  ended=$(date +%s)
  jq -er '.["containerimage.digest"]' "$tmp/$name.json" >"$tmp/$name.digest"
}

build plain-1 --build-arg "GIT_SHA=$sha"
build plain-2 --build-arg "GIT_SHA=$sha"
build deliver-1 "${deliver_args[@]}"
build deliver-2 "${deliver_args[@]}"

plain1=$(<"$tmp/plain-1.digest") plain2=$(<"$tmp/plain-2.digest")
deliver1=$(<"$tmp/deliver-1.digest") deliver2=$(<"$tmp/deliver-2.digest")
echo "Without SOURCE_DATE_EPOCH: $plain1 then $plain2"
echo "With deliver.yml's build args (SOURCE_DATE_EPOCH=$epoch): $deliver1 then $deliver2"

if [ "$plain1" = "$plain2" ]; then
  echo "::error::Two builds without SOURCE_DATE_EPOCH gave one digest, so this check can't tell whether deliver.yml's args fix the build time."
  exit 1
fi
if [ "$deliver1" != "$deliver2" ]; then
  echo "::error::Two builds with deliver.yml's build args gave different digests, so every run of one commit pushes a new image."
  exit 1
fi
echo "==> deliver.yml's build args give one digest per commit: $deliver1"
