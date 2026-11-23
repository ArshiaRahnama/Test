#!/usr/bin/env bash
# Apex Clothing Studio - convert all your .ydd clothes to .glb (Linux/macOS).
# Run:  bash convert.sh        (needs Node.js only; reads .ydd/.ytd locally)
# Works headless over SSH - no GUI needed.
cd "$(dirname "$0")" || exit 1

# APEX_SIBLING_GUARD: running this straight out of an sftp client's temporary
# folder copies only this file, so convert.js is not beside it. Say so plainly
# instead of letting node print a stack trace.
if [ ! -f "convert.js" ]; then
    echo "  [STOP] convert.js is not next to this script."
    echo "  It ran from: $(pwd)"
    echo
    echo "  This usually means the script was opened from inside an FTP/SFTP"
    echo "  client, which downloads only the file you clicked."
    echo "  Download the whole apex_clothing folder, then run tools/convert.sh from it."
    exit 1
fi

if ! command -v node >/dev/null 2>&1; then
    echo "[ERROR] Node.js is not installed or not on PATH."
    echo "Install it:  https://nodejs.org  (or 'apt install nodejs' / 'nvm install --lts')"
    exit 1
fi

node convert.js "$@"
