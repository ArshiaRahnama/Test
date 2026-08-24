#!/usr/bin/env bash
# UNIQUE_AC — Git Auto-Tagging
# Creates a git tag matching whatever's currently in VERSION, if that tag doesn't
# already exist. Safe to run any time — it's a no-op if nothing changed.
#
# Recommended use: call this from a git hook so it happens automatically. Two ways:
#
# 1) Manual / CI step — just run it whenever you want:
#      ./tools/git-tag-version.sh
#
# 2) Automatic on every commit — install as a post-commit hook:
#      cp tools/git-tag-version.sh .git/hooks/post-commit
#      chmod +x .git/hooks/post-commit
#
# It only creates LOCAL tags — push them yourself with:
#      git push --tags

set -euo pipefail

cd "$(git rev-parse --show-toplevel 2>/dev/null || echo .)"

if [ ! -f VERSION ]; then
    echo "[git-tag-version] No VERSION file found — skipping." >&2
    exit 0
fi

VERSION_VALUE="$(tr -d '[:space:]' < VERSION)"
TAG_NAME="v${VERSION_VALUE}"

if [ -z "$VERSION_VALUE" ]; then
    echo "[git-tag-version] VERSION file is empty — skipping." >&2
    exit 0
fi

if git rev-parse "$TAG_NAME" >/dev/null 2>&1; then
    # Tag already exists — nothing to do, this is the normal case for most commits.
    exit 0
fi

git tag -a "$TAG_NAME" -m "UNIQUE_AC ${TAG_NAME}"
echo "[git-tag-version] Created tag ${TAG_NAME}. Run 'git push --tags' to publish it." >&2
