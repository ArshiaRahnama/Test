#!/usr/bin/env bash
# UNIQUE_AC — Migration Tool
# Moves UNIQUE_AC's own tables (bans, whitelist, admins, trust, notes, detections,
# admin log, appeals) from one MySQL database to another — e.g. when switching hosts.
#
# This wraps mysqldump/mysql directly rather than reinventing table copying in Lua —
# they're the battle-tested tools for exactly this job, and this way the migration
# works even if the old server is already offline (you only need DB access, not a
# running FiveM process).
#
# Usage:
#   ./migrate.sh export  <db_user> <db_pass> <db_name> <db_host> > uniqueac_export.sql
#   ./migrate.sh import  <db_user> <db_pass> <db_name> <db_host> < uniqueac_export.sql

set -euo pipefail

UNIQUE_AC_TABLES="uniqueac_admin uniqueac_banlist uniqueac_unban uniqueac_whitelist uniqueac_trust uniqueac_notes uniqueac_admin_log uniqueac_detections uniqueac_appeals"

usage() {
    echo "Usage:"
    echo "  $0 export <db_user> <db_pass> <db_name> [db_host=127.0.0.1] > export.sql"
    echo "  $0 import <db_user> <db_pass> <db_name> [db_host=127.0.0.1] < export.sql"
    exit 1
}

MODE="${1:-}"
DB_USER="${2:-}"
DB_PASS="${3:-}"
DB_NAME="${4:-}"
DB_HOST="${5:-127.0.0.1}"

[ -z "$MODE" ] && usage
[ -z "$DB_USER" ] && usage
[ -z "$DB_NAME" ] && usage

case "$MODE" in
  export)
    echo "-- UNIQUE_AC export — generated $(date -u '+%Y-%m-%d %H:%M:%S UTC')" >&2
    mysqldump --user="$DB_USER" --password="$DB_PASS" --host="$DB_HOST" \
      --no-create-info --complete-insert --skip-add-locks \
      "$DB_NAME" $UNIQUE_AC_TABLES
    echo "Export complete." >&2
    ;;
  import)
    echo "This will INSERT into existing UNIQUE_AC tables on the target database." >&2
    echo "Make sure database.sql has already been run once on the target so the tables exist." >&2
    read -p "Continue? [y/N] " -n 1 -r REPLY
    echo
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
        echo "Aborted." >&2
        exit 1
    fi
    mysql --user="$DB_USER" --password="$DB_PASS" --host="$DB_HOST" "$DB_NAME"
    echo "Import complete." >&2
    ;;
  *)
    usage
    ;;
esac
