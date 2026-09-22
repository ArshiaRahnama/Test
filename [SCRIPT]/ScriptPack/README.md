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
shopseller_config.lua           -> [SCRIPT]/ScriptPack/ (adds the Permits gun-shop category)
fxmanifest.lua                  -> [SCRIPT]/ScriptPack/fxmanifest.lua (full replacement)
install_license_menu.sql        -> run once against your database

client/license-cl.lua           -> [SCRIPT]/ScriptPack/client/
client/ncz-cl.lua               -> [SCRIPT]/ScriptPack/client/
client/shop-cl.lua              -> [SCRIPT]/ScriptPack/client/

server/licensemenu-sv.lua       -> [SCRIPT]/ScriptPack/server/
server/shop-sv.lua              -> [SCRIPT]/ScriptPack/server/

html/index.html                 -> [SCRIPT]/ScriptPack/html/ (the NUI shell - full replacement)
html/ncz_hud/*                  -> [SCRIPT]/ScriptPack/html/ncz_hud/ (new folder - the gold/black badge)

uniquejobs_patch/client/*.lua   -> [JOB]/esx_uniquejobs/client/ (9 files, one line changed each -
                                    see "F6 Manage License" section below)
```

## Install steps
1. Run `install_license_menu.sql` against your database.
2. Copy `license_config.lua` and `shopseller_config.lua` into `[SCRIPT]/ScriptPack/` (root).
3. Copy `client/license-cl.lua`, `client/ncz-cl.lua`, `client/shop-cl.lua` into `[SCRIPT]/ScriptPack/client/`.
4. Copy `server/licensemenu-sv.lua`, `server/shop-sv.lua` into `[SCRIPT]/ScriptPack/server/`.
5. Copy `html/index.html` into `[SCRIPT]/ScriptPack/html/` (replaces the existing shell).
6. Copy the whole `html/ncz_hud/` folder into `[SCRIPT]/ScriptPack/html/ncz_hud/` (new folder).
7. Replace `[SCRIPT]/ScriptPack/fxmanifest.lua` with the one in this overlay.
8. Copy the 9 files from `uniquejobs_patch/client/` over the matching files
   in `[JOB]/esx_uniquejobs/client/`.
9. Restart `ScriptPack`, then restart `esx_uniquejobs`.

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




## Test command
Added a temporary `/testlicense` command so you can debug without needing to
be near a player or match a job in F6:
- `/testlicense` — opens the menu targeting yourself
- `/testlicense <id>` — opens it targeting another player's server id
  (same server-side rule as F6: you only see their licenses if your job has
  add/view/remove access to at least one license type)

It goes through the exact same server code as F6 (`license:getData`,
`license:add`, `license:remove`), so anything you find with it is a real
bug, not a test-command artifact. It's marked in `client/license-cl.lua` as
temporary — delete that `RegisterCommand('testlicense', ...)` block once
you're done testing.

## Bug fix: menu "scrolling glitches"
This was Lua's `pairs()` having no guaranteed order over the license table -
every menu could list items in a different order each time it opened, which
looks like a scrolling/reordering bug. Fixed by adding `licenseConfig.order`
(a plain numbered list) in `license_config.lua` and switching every menu in
`client/license-cl.lua` to iterate that with `ipairs()` instead of
`pairs(licenseConfig.licenses)`. Order is now always identical.
**If you add a new license type, add its key to `licenseConfig.order` too**,
or it won't show up in any menu.

## New: DYS permit (fire a suppressed weapon inside the NCZ)
Added exactly what you described, built on top of what your pack already has:

- **License type**: `dys` in `license_config.lua`. Not staff-grantable (empty
  `addAccess`) - only obtainable by buying it. LE/DOJ can still view it on a
  player and revoke it (abuse).
- **Where it's enforced**: `client/ncz-cl.lua` - this is your existing "No
  Combat Zone" script (the `zone` table = the small enforcement zones like
  the police station, parking lots, etc.; `DisablePlayerFiring` +
  `SetCurrentPedWeapon(..., WEAPON_UNARMED, ...)` strip anyone not in
  `WhitelistJobs` of their weapon and firing ability). A player with the
  `dys` license AND a suppressor attached to their currently equipped
  weapon is now exempted from that - they keep their weapon and can fire.
  Suppressor detection checks all 4 known suppressor component hashes
  (`COMPONENT_AT_PI_SUPP`, `COMPONENT_AT_PI_SUPP_02`, `COMPONENT_AT_AR_SUPP`,
  `COMPONENT_AT_AR_SUPP_02`) against whatever weapon is equipped via
  `HasPedGotWeaponComponent` - it just returns false for a component that
  doesn't fit the weapon, so this is safe without a full per-weapon map.
- **Notifications**: if they don't have the license at all, `Shoma mojavez
  DYS nadarid`. If they have the license but no suppressor equipped, a
  different message telling them to attach one. Each shown once per zone
  entry (not spammed every tick).
- **Gun Shop**: `shopseller_config.lua` has a new "📜 Permits" category with
  `dys_permit` at $150,000. `server/shop-sv.lua` has the new
  `gunshop_item:buy_permit` handler (checks they don't already have it,
  checks funds, charges them, inserts a permanent `user_licenses` row, then
  asks `licensemenu-sv.lua` to push the update to their client so it takes
  effect immediately without a relog). `client/shop-cl.lua` routes that new
  item type to a buy-confirm dialog, same as the existing melee weapons.

**⚠️ One thing I need to flag, not guessed around:** the "big green circle"
on your map (`zoneMap.Base`, radius 1500) is currently **only a visual blip**
in `ncz-cl.lua` - it draws the circle but the actual firing-restriction check
only runs against the `zone` table's small named zones (police station,
parking lots, Paintball, etc.), not that big circle. So right now, shooting
is already allowed almost everywhere except those small zones - the DYS
permit doesn't change anything outside them, because nothing was restricted
there to begin with. If you actually want the big circle itself to block
firing (and the DYS permit to be the way through it), that's a different,
bigger change - tell me and I'll wire the big-circle radius into the same
enforcement loop.

## DYS / NCZ follow-up - finished per your last message
Four corrections to the DYS work above:

1. **Small NCZ zones reverted to absolute** - the `zone` table (police
   station, parking lots, Paintball, etc.) in `client/ncz-cl.lua` is back to
   exactly your original behavior: anyone not in `WhitelistJobs` cannot fire
   or even hold a weapon there, full stop. The DYS permit does **not** apply
   there anymore.

2. **DYS now applies to the big circle instead** (`zoneMap.Base`) - a
   separate check reads `zoneMap.Base.radius` directly (whatever number is
   there is the zone, per your message - nothing hardcoded), independent
   from the small-zone logic above and skipped entirely while inside one of
   those. Inside the big circle only: no permit -> can't fire, permit but no
   suppressor -> can't fire (different notification), permit + suppressor ->
   can fire normally.

3. **Killing someone revokes it** - `client/ncz-cl.lua` listens for
   `gameEventTriggered` / `CEventNetworkEntityDamage`; if you (while holding
   the `dys` license) kill another player, it immediately calls a new
   server event, `license:dysKillRevoke` (added to
   `server/licensemenu-sv.lua`), which deletes your own `dys` row and
   notifies you. I scoped this to **any kill while holding the license**,
   not just kills inside the Base zone, since your message didn't mention a
   zone restriction on this part - say so if you meant it narrower.

4. **LE can grant it free via F6 too** - `license_config.lua`'s `dys` entry
   now has `addAccess = police/sheriff/mt` (your `WhitelistJobs`, the
   "military organizations"), so it shows up under F6 -> Add License for
   them. Buying it at the Gun Shop for $150,000 still works too - both paths
   write the same row.

## NCZ badge - merged INTO ScriptPack (not a separate resource)
Originally built this as its own `ncz_hud` resource, but ScriptPack can only
declare one `ui_page` (`html/index.html`), and it already uses one - as an
iframe-relay shell for headbag/BabiczHandlingEditor/changwinwood/Syn_Sit,
since a FiveM resource is limited to a single `ui_page` no matter how many
separate HTML tools it needs. So the badge is now one more iframe in that
same shell, following the exact pattern already used for those four:

- `html/ncz_hud/` - the badge's own `index.html`/`style.css`/`script.js` and
  your two fonts, untouched from the standalone version (gold-on-black,
  pulsing glow/shine, using `abtin` = HeadingNowTrial-67Extrabold for the
  title and `atlanta` = AtlantaCollege for the subtitle - the `higha`/
  `Merich.otf` font-face from your original upload was dropped since that
  file was never provided and nothing referenced it)
- `html/index.html` - the shell - gained a 5th iframe (`#ncz-frame`) and one
  more relay rule (payloads shaped `{action: 'enable'|'disable'}`, distinct
  from BabiczHandlingEditor's `'show'/'hide'` so they don't collide)
- `fxmanifest.lua` - the `files {}` list under `ui_page` now includes the 5
  new `html/ncz_hud/*` files. No more `dependency 'ncz_hud'` line (removed -
  nothing to depend on anymore, it's all one resource)
- `client/ncz-cl.lua` - `UpdateHudVisibility()` now calls plain
  `SendNUIMessage({action='enable'|'disable'})` directly instead of
  `exports['ncz_hud']:...` - same resource now, no export needed

Shows automatically whenever you enter or leave **either** a small named NCZ
zone **or** the big `zoneMap.Base` circle - stays up the whole time either
restriction is active. Nothing to install separately - it's part of the same
`ScriptPack` file set below.

If you'd rather this badge say something different, use a different icon, or
a different layout, it's all in `html/ncz_hud/` - tell me what to change.


## Bug fix: could still fire without the DYS permit
Root cause: `DisablePlayerFiring`'s real signature is `DisablePlayerFiring(Player player, BOOL toggle)` - it
takes a **Player** handle (`PlayerId()`), not a **Ped** handle
(`PlayerPedId()`). Your original `ncz-cl.lua` was already passing the ped
handle everywhere (`DisablePlayerFiring(playerPed, ...)`), which silently
does nothing for actual firing - it just never showed up as a bug in the
small NCZ zones because those *also* strip the weapon entirely
(`SetCurrentPedWeapon(..., WEAPON_UNARMED, ...)`), so no gun = can't shoot
regardless of whether the firing-disable itself worked. My new Base-zone
(DYS) logic doesn't strip the weapon (see the earlier explanation of why),
so it relies on `DisablePlayerFiring` alone - and that's where the no-op
became visible as "I can still shoot without a permit."

Fixed by switching every `DisablePlayerFiring(playerPed, ...)` in
`client/ncz-cl.lua` to `DisablePlayerFiring(PlayerId(), ...)`. Also fixed
`SetPlayerInvincible` the same way (`Player`, not `Ped`, per its real
signature too) - not reported broken, but same category of bug and safe to
correct alongside it.

## Bug fix: SCRIPT ERROR in server/license-sv.lua (nil index)
The error `@ScriptPack/server/license-sv.lua:62: attempt to index a nil
value` was the exact compatibility issue flagged earlier: that file looks up
each license type's label in the separate `licenses` table, and `install_license_menu.sql`
originally seeded every NEW type EXCEPT `dys` - because `dys` was added to
`license_config.lua` in a later message, after that SQL file was already
written. The moment a player actually had a `dys` row (bought or granted),
`license-sv.lua` crashed trying to look up its label. Fixed: `dys` added to
the seed list. **Re-run the updated `install_license_menu.sql`** (it's a
`REPLACE INTO`, safe to run again even though the other rows already
exist).

## Confirming: NCZ badge show/hide (re: your note on the appearance)
To be explicit about this, since you flagged that I should not skip past
it: the gold/black badge (design as built, not reverted) already does
exactly what you described - `client/ncz-cl.lua`'s `UpdateHudVisibility()`
shows it the instant you enter either a small named NCZ zone or the big
`zoneMap.Base` circle, and hides it the instant you leave both. That part
needed no further change; your screenshot from two messages ago already
showed it working (the badge visible with "NO COMBAT ZONE / Silencer + DYS
Permit Required" while you were inside the zone). And to close the loop on
the earlier "could still shoot" report: that was your own police job being
in `WhitelistJobs` (police/sheriff/fbi/mt are always exempt, by design,
same as the small zones) - not a bug.

## Bug fix: SCRIPT ERROR ncz-cl.lua:161 (nil field 'job')
Race condition between this file's two threads: the enforcement loop starts
on its own `Citizen.CreateThread` and begins reading the global `PlayerData`
almost immediately, while a SEPARATE thread is the one responsible for
waiting on ESX and actually setting `PlayerData` - both threads start at
basically the same moment when the resource loads, so the enforcement loop
can (and, especially right after a resource restart, often does) run its
first pass before `PlayerData` exists yet, crashing on `PlayerData.job.name`.
This was likely always latent in the original file, just surfaced now from
restarting `ScriptPack` repeatedly while testing.

Fixed by wrapping the entire enforcement loop body in
`if PlayerData and PlayerData.job then ... end` - it simply skips that tick
(does nothing, waits 1ms, tries again) until the other thread has finished
setting it up, instead of crashing.

## Debugging: HUD badge not showing at all
Re-verified everything on my end (the iframe, the relay rule in
`html/index.html`, the files{} list in `fxmanifest.lua`, `html/ncz_hud/`
itself) - all correct and consistent. The most likely explanation is that
the `html/` files weren't actually copied to the live server - these are a
new file type compared to the `.lua` files you've been swapping so far, easy
to miss:

**Exact checklist - all 3 of these are required, not just the .lua files:**
1. `[SCRIPT]/ScriptPack/html/index.html` replaced (the shell - gained the
   5th iframe + relay rule)
2. `[SCRIPT]/ScriptPack/html/ncz_hud/` - this whole folder copied in as a
   new folder (5 files: `index.html`, `style.css`, `script.js`, and the 2
   font files)
3. `[SCRIPT]/ScriptPack/fxmanifest.lua` replaced (has the 5 new
   `html/ncz_hud/*` lines in the `files {}` block under `ui_page`)

Added `/testncz` to `client/ncz-cl.lua` - toggles the badge on/off directly,
completely bypassing zone detection. Run it anywhere:
- **Shows the badge** -> the NUI/html wiring is fine, so the real problem is
  in the zone detection itself (wrong coordinates, wrong radius, etc.) -
  come back with what you tried and I'll dig into that instead.
- **Shows nothing** -> confirms it's the file checklist above - go through
  those 3 items again.

Remove the `RegisterCommand('testncz', ...)` block once this is sorted.

## NCZ badge reverted to your original purple design
Per your latest message, `html/ncz_hud/index.html`, `style.css` and
`script.js` are now exactly the files you uploaded (purple "You Are In NCZ"
badge) - my gold/black reskin from earlier is gone. Removed the now-unused
`AtlantaCollegeRegular-1Gva2.ttf` reference from `fxmanifest.lua`'s
`files {}` list too, since the original CSS never used it. The
`HeadingNowTrial-67Extrabold.ttf` font stays (your CSS's `abtin` font-face
uses it); the `higha`/`Merich.otf` font-face in your CSS still points at a
file that's never been uploaded in this whole conversation, so that one
font-face just silently fails to load - same as it would on its own, not
something I introduced.

The message contract between `client/ncz-cl.lua` and this HTML didn't
change (still `{action: 'enable'|'disable'}`), so no other file needed
touching for this part.

## All DOJ + Law Enforcement jobs now fire freely without DYS
`WhitelistJobs` in `client/ncz-cl.lua` was only `police`/`sheriff`/`fbi`/`mt`.
Expanded to the full list from your message:
- **Law Enforcement**: `police`, `sheriff`, `mt`
- **Department Of Justice**: `cid`, `cia`, `marshal`, `fbi`, `judge`, `doa`

All 9 now bypass the DYS/suppressor requirement entirely inside the big
`zoneMap.Base` circle, exactly like they already did in the small named NCZ
zones.

## Color changed back to gold (kept your original layout/structure)
`html/ncz_hud/style.css` - only the colors changed (purple `rgb(88,0,170)`
-> gold `rgb(212,175,55)`, badge background now dark/black with a gold
border for contrast, text gold). Same `#hud`/`#batman`/`#matn` structure and
layout as your uploaded files - this is a recolor, not a redesign.

## About "doesn't disappear when leaving NCZ"
Before changing anything here, worth checking first: the badge is tied to
`coords.label` (small zones) **or** `inBaseZone` (the big `zoneMap.Base`
circle) - and `zoneMap.Base`'s radius is 1500 units, which covers most of
downtown LS. Re-checked the exit logic in `client/ncz-cl.lua` line by line -
it's correct (`inBaseZone` does get set back to `false` the moment you're
actually outside that 1500-unit radius). So walking to a different street
that's still within 1500 units of the Base center (`-115.583, -919.272`)
will never make the badge disappear - only traveling far enough out of the
city core will.

Added `/nczdebug` to `client/ncz-cl.lua` to settle this for certain - it
prints your live distance to the Base center vs. the radius, and the
current `inBaseZone`/`coords.label` state. Run it wherever you are:
- If it says `INSIDE` and the badge is showing - that's correct behavior,
  not a bug. If you actually wanted a smaller zone, tell me the radius (or
  coordinates) you want and I'll change `zoneMap.Base` itself.
- If it says `outside` and the badge is still showing - that IS a real bug,
  and different from what I checked above; come back with what it printed
  and I'll dig further.

Remove both `/testncz` and `/nczdebug` once this is sorted.

## Badge now only shows for NCZ (the small zones), not the Base safe zone
Confirmed per your message: `zone` (Police, PoliceVienwood, Paintball,
ParkingMarkazi, ParkingMarkazi2, Medic, Sheriff1, Mechanic, UWUCafe,
Sheriff2) is "NCZ"; `zoneMap.Base` (the 1500-radius circle) is a separate
"safe zone" concept for the DYS permit, not NCZ. That's exactly why the
badge looked like it "wouldn't go away" - it was tied to both. Fixed:
`UpdateHudVisibility()` in `client/ncz-cl.lua` now only shows the badge for
`coords.label` (the small zones) - the Base zone no longer affects it at
all. The DYS/suppressor firing logic for the Base zone itself is unchanged,
only the badge's trigger condition changed.

## DYS: no more permanent, kill-revoke scoped to the safe zone, live notifications
Per your latest message, three changes:

1. **Not permanent anymore.** `license_config.lua`'s `dys` entry is now
   `timing = { permanent = false, time = {1, 7} }` - this disables the
   "Permanent" checkbox in F6's add flow entirely (already wired to
   `config.timing.permanent`), so staff can only grant 1-7 days. The Gun
   Shop purchase (`server/shop-sv.lua`) now grants a flat **7 days** instead
   of forever - controlled by `local DYS_PERMIT_DAYS = 7` right above the
   `buy_permit` handler, change that one number for a different duration.

2. **Kill-revoke scoped to the safe zone.** Earlier this revoked on ANY
   kill anywhere while holding the license; per your message ("وقتی یکی رو
   تو سیف زون میکشی") it's now scoped to kills that happen **while you're
   inside `zoneMap.Base`** (`client/ncz-cl.lua`'s `gameEventTriggered`
   handler now checks `inBaseZone` too).

3. **Live "no permit" notifications on weapon draw.** Previously the
   notification only fired once per zone visit. Now `client/ncz-cl.lua`
   tracks the currently-equipped weapon and resets the notification the
   moment it changes - so drawing a weapon (or switching weapons) while
   lacking the permit/suppressor tells you immediately, every time, instead
   of only the first time you drew a gun after entering the zone. No
   notification while unarmed (holstered), since there's nothing to warn
   about yet.

## All licenses now support up to 30 days
Only `dys` was capped lower (`{1, 7}`) - every other license type already
allowed `{1, 30}`. Brought `dys` up to match: `license_config.lua`'s time
range is now `{1, 30}` for it too (F6 staff can grant 1-30 days), and the
Gun Shop purchase (`server/shop-sv.lua`'s `DYS_PERMIT_DAYS`) now grants a
flat 30 days instead of 7, so the purchase matches F6's new max.
