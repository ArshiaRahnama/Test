#!/usr/bin/env bash
# ============================================================
#  Apex Clothing Studio - PNG to .ytd  (Linux / macOS)
#  Run after exporting from the studio:
#     bash make_ytd.sh
#  or make it executable once:  chmod +x make_ytd.sh
#  It reads every PNG in tools/ytd_in/ and writes a real .ytd
#  (using the matching original as a template) into tools/ytd_out/.
#  No OpenIV / CodeWalker / GUI needed - works headless over SSH.
# ============================================================
cd "$(dirname "$0")" || exit 1

# APEX_SIBLING_GUARD: running this straight out of an sftp client's temporary
# folder copies only this file, so make_ytd.js is not beside it. Say so plainly
# instead of letting node print a stack trace.
if [ ! -f "make_ytd.js" ]; then
    echo "  [STOP] make_ytd.js is not next to this script."
    echo "  It ran from: $(pwd)"
    echo
    echo "  This usually means the script was opened from inside an FTP/SFTP"
    echo "  client, which downloads only the file you clicked."
    echo "  Download the whole apex_clothing folder, then run tools/make_ytd.sh from it."
    exit 1
fi

if ! command -v node >/dev/null 2>&1; then
    echo "[ERROR] Node.js is not installed or not on PATH."
    echo "Install it:  https://nodejs.org  (or 'apt install nodejs' / 'nvm install --lts')"
    exit 1
fi

node make_ytd.js --auto
