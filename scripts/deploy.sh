#!/usr/bin/env bash
set -euo pipefail

TARGET_ORG="$1"
MODE="${2:-deploy}"

COMMAND=(
  sf project deploy start
  --target-org "$TARGET_ORG"
  --manifest manifest/package.xml
  --pre-destructive-changes manifest/destructiveChangesPre.xml
  --post-destructive-changes manifest/destructiveChangesPost.xml
  --test-level RunLocalTests
  --wait 30
)

if [ "$MODE" = "validate" ]; then
  COMMAND+=(--dry-run)
fi

echo "Running deployment command:"
printf '%q ' "${COMMAND[@]}"
echo

"${COMMAND[@]}"