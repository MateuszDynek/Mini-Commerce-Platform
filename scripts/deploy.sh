#!/usr/bin/env bash
set -euo pipefail

TARGET_ORG="$1"
MODE="${2:-validate}"

FORCE_APP_DIR="force-app"
DESTRUCTIVE_DIR=".deploy/destructive"
PRE_DESTRUCTIVE_XML="manifest/destructiveChangesPre.xml"
POST_DESTRUCTIVE_XML="manifest/destructiveChangesPost.xml"
DESTRUCTIVE_PACKAGE_XML="manifest/destructive-package.xml"

has_types() {
  local file="$1"

  if [ ! -f "$file" ]; then
    return 1
  fi

  grep -q "<types>" "$file"
}

run_command() {
  echo "Running command:"
  printf '%q ' "$@"
  echo
  "$@"
}

echo "Target org: $TARGET_ORG"
echo "Mode: $MODE"

if [ -d "$FORCE_APP_DIR" ]; then
  APP_COMMAND=(
    sf project deploy start
    --target-org "$TARGET_ORG"
    --source-dir "$FORCE_APP_DIR"
    --test-level RunLocalTests
    --wait 30
  )

  if [ "$MODE" = "validate" ]; then
    APP_COMMAND+=(--dry-run)
  fi

  echo "Deploying application source from $FORCE_APP_DIR"
  run_command "${APP_COMMAND[@]}"
else
  echo "Directory $FORCE_APP_DIR does not exist. Skipping application source deployment."
fi

if has_types "$PRE_DESTRUCTIVE_XML" || has_types "$POST_DESTRUCTIVE_XML"; then
  echo "Destructive changes detected. Preparing Metadata API destructive deployment."

  rm -rf "$DESTRUCTIVE_DIR"
  mkdir -p "$DESTRUCTIVE_DIR"

  cp "$DESTRUCTIVE_PACKAGE_XML" "$DESTRUCTIVE_DIR/package.xml"

  if has_types "$PRE_DESTRUCTIVE_XML"; then
    cp "$PRE_DESTRUCTIVE_XML" "$DESTRUCTIVE_DIR/destructiveChangesPre.xml"
  fi

  if has_types "$POST_DESTRUCTIVE_XML"; then
    cp "$POST_DESTRUCTIVE_XML" "$DESTRUCTIVE_DIR/destructiveChangesPost.xml"
  fi

  DESTRUCTIVE_COMMAND=(
    sf project deploy start
    --target-org "$TARGET_ORG"
    --metadata-dir "$DESTRUCTIVE_DIR"
    --test-level RunLocalTests
    --wait 30
  )

  if [ "$MODE" = "validate" ]; then
    DESTRUCTIVE_COMMAND+=(--dry-run)
  fi

  echo "Deploying destructive changes from $DESTRUCTIVE_DIR"
  run_command "${DESTRUCTIVE_COMMAND[@]}"
else
  echo "No destructive changes found. Skipping destructive deployment."
fi