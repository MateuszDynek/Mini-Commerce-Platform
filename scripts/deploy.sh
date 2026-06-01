#!/usr/bin/env bash
set -euo pipefail

TARGET_ORG="$1"
MODE="${2:-deploy}"

COMMAND=(
  sf project deploy start
  --target-org "$TARGET_ORG"
  --source-dir force-app
  --pre-destructive-changes manifest/destructiveChangesPre.xml
  --post-destructive-changes manifest/destructiveChangesPost.xml
  --test-level RunLocalTests
  --wait 30
)

if [ "$MODE" = "validate" ]; then
  COMMAND+=(--dry-run)
fi

"${COMMAND[@]}"