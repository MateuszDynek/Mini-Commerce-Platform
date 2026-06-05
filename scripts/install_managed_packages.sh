#!/usr/bin/env bash
set -euo pipefail

TARGET_ORG="${1:-}"
DEPENDENCIES_FILE="${2:-config/package-dependencies.txt}"

if [ -z "$TARGET_ORG" ]; then
  echo "Usage: scripts/install_managed_packages.sh <target-org> [dependencies-file]"
  exit 1
fi

if [ ! -f "$DEPENDENCIES_FILE" ]; then
  echo "Dependencies file not found: $DEPENDENCIES_FILE"
  exit 1
fi

echo "Target org: $TARGET_ORG"
echo "Dependencies file: $DEPENDENCIES_FILE"

sf package installed list --target-org "$TARGET_ORG" || true

while IFS= read -r PACKAGE_ALIAS || [ -n "$PACKAGE_ALIAS" ]; do
  if [ -z "$PACKAGE_ALIAS" ] || [[ "$PACKAGE_ALIAS" =~ ^# ]]; then
    continue
  fi

  echo "Installing package dependency: $PACKAGE_ALIAS"

  set +e
  INSTALL_OUTPUT=$(sf package install \
    --package "$PACKAGE_ALIAS" \
    --target-org "$TARGET_ORG" \
    --wait 30 \
    --publish-wait 30 \
    --no-prompt \
    2>&1)
  INSTALL_EXIT_CODE=$?
  set -e

  echo "$INSTALL_OUTPUT"

  if [ "$INSTALL_EXIT_CODE" -ne 0 ]; then
    if echo "$INSTALL_OUTPUT" | grep -qiE "already installed|is already installed|previously installed"; then
      echo "Package $PACKAGE_ALIAS is already installed. Continuing."
    else
      echo "Failed to install package: $PACKAGE_ALIAS"
      exit "$INSTALL_EXIT_CODE"
    fi
  fi
done < "$DEPENDENCIES_FILE"

sf package installed list --target-org "$TARGET_ORG" || true