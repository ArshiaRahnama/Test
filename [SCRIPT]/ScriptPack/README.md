# License Menu — Final ScriptPack Integration

This is a drop-in overlay for your existing `[SCRIPT]/ScriptPack` resource — it
does **not** touch any of your other scripts (chopshop, boombox, synsit, etc.)
and does **not** break your existing `/givelicense`, `/removelicense`, or the
`esx_license:*` events in `server/license-sv.lua`. Both systems now share the
same `user_licenses` table.

## What changed from what you originally uploaded, and why

| Original assumption | Reality in your ScriptPack | Fix |
|---|---|---|
| `sun-society` export for permissions | You don't have that resource — `esx_society` is a different thing (job/society bank accounts only) | Removed. Access is decided purely by the `addAccess`/`viewAccess`/`removeAccess` job tables in `license_config.lua`, same style as your existing `givelicense-sv.lua` (`xPlayer.job.name` checks) |
| `waitForLoad()` | Doesn't exist anywhere in your pack | Replaced with the `while ESX == nil do ... end` loop every other file here uses |
| `ESX.selectPlayerMenu(...)` | Doesn't exist in your framework | Removed; `openLicenseMenu(target)` is exported and called from the F6 "Manage License" button instead (see below) |
| New `user_licenses` schema (expire/description/etc.) | Your existing table only has `type` + `owner` | `install_license_menu.sql` **adds** the extra columns (nullable/defaulted) — nothing existing is renamed or removed |

## Files in this overlay
```
license_config.lua              -> [SCRIPT]/ScriptPack/ (license type definitions)
client/license-cl.lua           -> [SCRIPT]/ScriptPack/client/ (picked up automatically by the client/*.lua glob)
server/licensemenu-sv.lua       -> [SCRIPT]/ScriptPack/server/ (picked up automatically by the server/*.lua glob)
install_license_menu.sql        -> run once against your database
fxmanifest.lua                  -> [SCRIPT]/ScriptPack/fxmanifest.lua, with ONE addition in each script list:
                                    'license_config.lua' added right before 'client/*.lua'
                                    and right before 'server/*.lua'
uniquejobs_patch/client/*.lua   -> [JOB]/esx_uniquejobs/client/ (9 files, one line changed each -
                                    see "F6 Manage License" section below)
```

## Install steps
1. Run `install_license_menu.sql` against your database.
2. Copy `license_config.lua` into `[SCRIPT]/ScriptPack/` (root, next to `config.lua`).
3. Copy `client/license-cl.lua` into `[SCRIPT]/ScriptPack/client/`.
4. Copy `server/licensemenu-sv.lua` into `[SCRIPT]/ScriptPack/server/`.
5. Replace `[SCRIPT]/ScriptPack/fxmanifest.lua` with the one in this overlay
   (it's your original file with just the two `license_config.lua` lines
   added — nothing else was touched).
6. Copy the 9 files from `uniquejobs_patch/client/` over the matching files
   in `[JOB]/esx_uniquejobs/client/`.
7. Restart `ScriptPack`, then restart `esx_uniquejobs`.

## Commands
- `/license` — any player views their own licenses.
- Staff no longer use a command — they open F6 → Citizen Interaction →
  Manage License on the target player (see the F6 section below).

## Job names (updated to match your real departments)
Per `notejobserver.txt`:
- **Law Enforcement** → `police`, `sheriff`, `mt`
- **Department Of Justice** → `cid`, `cia`, `marshal`, `fbi`, `judge`, `doa`
- **Organ Services** → `taxi`, `mechanic`, `medic`, `weazel`

`license_config.lua` has been remapped accordingly:
- old `detective` → `mt` (the third Law Enforcement job)
- old `ambulance` → `medic`
- old `justice` → `judge` (marriage/custody/ceremony treated as court functions)

All Department Of Justice jobs (`cid`, `cia`, `marshal`, `fbi`, `doa`, `judge`)
now have full add/view/remove access on **every license type except
`salamateravan`** (which stays `medic`-only), per your last message. The
`'firstaid'` license type has been removed entirely.

`weazel` still has no access to anything — it's a news job, nothing in the
list looked relevant to it. If you want it added to a specific license,
tell me which one.

## About "Manage License" in the F6 menu
You asked me to add a unique-job "Manage License" entry (`license_check` /
`license_revoke`) to the F6 menu for DOJ jobs. I checked `esx_uniquejobs` and
**it's already there** — fully wired, for all of CID, Marshal, DOA, Judge,
FBI, CIA, Police, Sheriff and MT. Every one of those job files already has:
- the `Manage License` button in F6 → Citizen Interaction
- a `ShowPlayerLicense_<job>` function that lists a target's licenses and
  lets staff click one to revoke it
- the `license_check` / `license_revoke` locale strings you pasted — they're
  already in every job's locale file, word for word

So there was nothing to build there. **What I did fix**: that F6 feature
reads labels from a separate small `licenses` table (only 5 rows: dmv, drive,
drive_bike, drive_truck, weapon) that's unrelated to `license_config.lua`.
Since it shares the same `user_licenses` table as our new system, a staff
member opening F6 → Manage License on a player holding one of our new
license types would hit a crash (no label found for that type). Updated
`install_license_menu.sql` now also seeds that table with every new
type/label so that doesn't happen.

One real functional gap that used to exist: F6 → Manage License could only
**view and revoke**, with no "add" option and no expiry/description for the
newer licenses. That's now fixed — see the next section.

## F6 "Manage License" now opens the NEW system (no more separate command)
Per your latest message: clicking "Manage License" in F6 (any job) now opens
our ox_lib menu directly — the one with add/view/remove, expiry and
description — instead of the old view/revoke-only panel. The `/managelicense`
command has been removed from `client/license-cl.lua`; F6 is the only way
staff open it now. `/license` (self-view) is unchanged.

**Files:** `uniquejobs_patch/client/<job>_main.lua` for all 9 jobs (`police`,
`sheriff`, `mt`, `cid`, `marshal`, `doa`, `judge`, `cia`, `fbi`). Each is your
original file with exactly one line changed — the `Manage License` click
handler now calls:
```lua
exports['ScriptPack']:openLicenseMenu(GetPlayerServerId(closestPlayer))
```
instead of `ShowPlayerLicense_<job>(closestPlayer)`. Nothing else in those
files was touched (the old `ShowPlayerLicense_<job>` functions are still
defined, just no longer called from that button — harmless dead code, left
in case you want to revert).

**Install:** copy the 9 files in `uniquejobs_patch/client/` over the matching
files in `[JOB]/esx_uniquejobs/client/`, then restart `esx_uniquejobs`.

Note: `exports['ScriptPack']:...` assumes your `ScriptPack` folder is still
the resource name FXServer sees (the folder itself is named `ScriptPack`,
not renamed). If you ever rename that folder, this export call needs to
match.

## Disable `/givelicense` and `/removelicense`
Per your latest message, everything should live in F6 now. These two old
commands (in `server/givelisence-sv.lua`) are police-only, only handle 6 old
types (weapon/dmv/drive/truck/bike/fly), and have nothing to do with
`license_config.lua`. I didn't delete the file — just **rename it** so
`ScriptPack`'s `server/*.lua` glob stops picking it up:
```
server/givelisence-sv.lua  ->  server/givelisence-sv.lua.disabled
```
(any extension other than `.lua` works — `.disabled`, `.bak`, `.txt`, doesn't
matter, as long as it's not `.lua`). Restart `ScriptPack` after renaming.
This doesn't touch `server/license-sv.lua` (the `esx_license:*` events) —
those stay, since other scripts in your pack may still fire those events.

## Redesigned F6 menu — two clean options
Per your latest message ("چند تا... یک دو گزینه", "خفن باشه"): the F6 "Manage
License" panel is no longer one long flat list mixing view/remove and add
together. It now opens to two options:
- **📋 View / Manage Licenses** — the target's current licenses, click one to
  see details and remove it
- **➕ Add License** — every license type your job can add, opens the
  time/description dialog

Other polish:
- The menu title now shows the target's actual name (`🪪 Manage License -
  <name>`), fetched server-side (`GetPlayerName` needs a server id there —
  on the client it only works with a local player index, confirmed by how
  the rest of your pack calls it, e.g. `combat_vdm_client.lua`)
- Each license type has its own icon (car/motorcycle/truck/plane/ship/
  helicopter for the driving ones, crosshairs for hunting, gavel for the
  justice ones, a shield for the weapon permit, a heart for the medical one)
- Pressing Escape/Backspace on a submenu takes you back a level instead of
  just closing everything

No new files for this — it's all inside `client/license-cl.lua` and
`server/licensemenu-sv.lua` (the server change: the callback now also sends
back the target's name alongside their licenses).



