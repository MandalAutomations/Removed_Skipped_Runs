#!/bin/bash

NUM_TO_DELETE=$1
if [ -z "$NUM_TO_DELETE" ]; then
  NUM_TO_DELETE=500
fi

n=1
while read run_id; do
  echo "Deleting skipped workflow run with ID: $run_id"
  gh api --method DELETE repos/$SIPHON_REPO/actions/runs/$run_id
  n=$((n + 1))
  if [ $n -gt $NUM_TO_DELETE ]; then
    break
  fi
done < <(gh api repos/$SIPHON_REPO/actions/runs --paginate \
  --jq '.workflow_runs[] | .id')

echo "Deleted $((n - 1)) skipped workflow runs."
