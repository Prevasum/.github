# Triage Labels

The skills speak in terms of canonical triage roles. This file maps those roles to what this repo's issue tracker actually uses.

## Category roles

Categories are GitHub issue types, set on the Prevasum org, not labels. Set one with `gh issue edit <n> --type <type>`.

| Triage role   | Issue type                                                             |
| ------------- | ---------------------------------------------------------------------- |
| `bug`         | `fix`                                                                  |
| `enhancement` | `feat`, or the closer fit of `chore`, `perf`, `refactor`, `docs`, `ci`, `build`, `test`, `style` |

## State roles

| Triage role       | Label in our tracker      | Meaning                                  |
| ----------------- | ------------------------- | ---------------------------------------- |
| `needs-triage`    | `status: needs-triage`    | Maintainer needs to evaluate this issue  |
| `needs-info`      | `status: needs-info`      | Waiting on reporter for more information |
| `ready-for-agent` | `status: ready-for-agent` | Fully specified, ready for an AFK agent  |
| `ready-for-human` | `status: ready-for-human` | Requires human implementation            |
| `wontfix`         | `status: wontfix`         | Will not be actioned. Also close the issue with `--reason "not planned"` |

State labels share the `status:` prefix, matching the repos' other prefixed labels (`api:`, `cloud:`, `service:`). An issue carries exactly one. Quote the name in commands, since it contains a space: `gh issue edit 42 --add-label "status: ready-for-agent"`.

When a skill mentions a role (e.g. "apply the AFK-ready triage label"), use the corresponding label string from this table.

## Area labels

This repo also has area labels (for example `fota`, `api: device`, `cloud: firestore`). When triaging, suggest the ones that fit from `gh label list`. Don't invent new ones.
