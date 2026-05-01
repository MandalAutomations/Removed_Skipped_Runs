# Removed Skipped Runs

A GitHub composite action that bulk-deletes workflow runs from a repository using the `gh` CLI. Useful for cleaning out skipped or stale runs that pile up in a repo's Actions history.

## Usage

```yaml
- name: Delete workflow runs
  uses: MandalAutomations/Removed_Skipped_Runs@main
  with:
    repo: my-org/my-repo
    num_to_delete: '500'
    github_token: ${{ secrets.GH_TOKEN }}
```

## Inputs

| Input          | Required | Default | Description                                                                                              |
|----------------|----------|---------|----------------------------------------------------------------------------------------------------------|
| `repo`         | Yes      | —       | Repository in `owner/repo` form (e.g. `my-org/my-repo`).                                                 |
| `num_to_delete`| No       | `500`   | Maximum number of workflow runs to delete in one invocation.                                             |
| `github_token` | Yes      | —       | A token used to authenticate the `gh` CLI. Needs `actions:write` on the target repo.                     |

## How it works

The action runs `scripts/delete_runs.sh`, which uses the `gh` CLI to list and delete workflow runs from the configured repository up to `num_to_delete` runs per invocation. Schedule it on a cron (e.g. nightly) to keep your Actions history tidy.

## Example workflow

```yaml
name: Cleanup workflow runs

on:
  schedule:
    - cron: '0 3 * * *'   # 03:00 UTC daily
  workflow_dispatch:

jobs:
  cleanup:
    runs-on: ubuntu-latest
    steps:
      - uses: MandalAutomations/Removed_Skipped_Runs@main
        with:
          repo: ${{ github.repository }}
          num_to_delete: '200'
          github_token: ${{ secrets.GH_TOKEN }}
```
