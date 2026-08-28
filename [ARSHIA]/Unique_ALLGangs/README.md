# Unique_ALLGangs

Merged resource: `FMGangs` (member/gang panel, `openpanel`) + `FMGangBoss`
(boss panel) combined into a single resource, converted to `ox_inventory`,
and with the `openpanel` lag bug fixed.

## Install

1. `ensure ox_lib` and `ensure ox_inventory` **before** this resource in
   `server.cfg`, then `ensure Unique_ALLGangs`.
2. Import `database.sql` (gangs / gangs_data / gang_grades tables - same
   as the original FMGangs).
3. `insertme_boss.sql` from the old FMGangBoss is **not required** - it
   creates an unrelated `qbtoesx`/`management_funds` table that nothing
   in this resource's code actually reads from (gang money comes from
   `gangs_data`, via `GetMoneyOfGang`/etc. in `server/Gangs.lua`). Left
   in the zip only in case you use it for something else.
4. Set `Config.SteamWebApiKey` in `Config.lua` to your own Steam Web API
   key (a placeholder key from the original files is currently there).

## 1) The `openpanel` lag - root cause and fix

Found it in `server/main.lua` / `server/Gangs.lua`: the old `GetAvatar()`
made a **synchronous** Steam API call - it fired `PerformHttpRequest` and
then sat in a `while data == nil do Wait(10) end` loop for up to **5
full seconds**, per player. `GetPanelData` (called every time the member
panel opens) looped over every **online gang member** and called this
once per member. Open a panel with 10 online members and, in the worst
case, that's 10x5s = 50 seconds of blocking, and even on a good day it's
one full network round-trip to Steam per member, done serially, every
single time someone presses the button. The boss panel had the same
problem via `FMGangs:GetPlayerData`.

**Fix (`server/main.lua`):** avatars are now fetched asynchronously in
the background and cached per Steam identifier. The cache is warmed
automatically on `playerConnecting` and `playerLoaded`, well before
anyone could open a panel. `GetAvatar(source)` now just reads the cache
and returns immediately - it never blocks, and Steam is never called
mid-panel-open. Net effect: panel open time no longer depends on Steam's
API latency or on how many gang members are online.

## 2) Merge: FMGangs + FMGangBoss -> one resource

These were already designed as companions - `FMGangBoss` imported
`FMGangs`' `Config.lua` and called `exports.FMGangs:GetMoneyOfGang(...)`
etc. across resources, and both used shared event names
(`For5M:OpenBossPanel`, `For5M:SendLog`). Merging them means:

- Single `fxmanifest.lua`, single `Config.lua`.
- `server/boss.lua` (was `FMGangBoss/server.lua`) now calls
  `GetMoneyOfGang` / `AddGangMoney` / `RemoveGangMoney` **directly** as
  global functions instead of `exports.FMGangs:...` - those exports only
  existed because it used to be a separate resource; calling across
  resources for something now living in the same one would just fail
  silently the moment someone renamed anything.
- `client/main.lua` (member panel) and `client/boss.lua` (boss panel,
  was `FMGangBoss/client.lua`) both load in the same resource. The boss
  actions (hire/fire, promote, withdraw/deposit, wardrobe) are
  unchanged from FMGangBoss - only how they reach the gang's money
  changed (direct call instead of cross-resource export).

### NUI: two panels, one resource

This is the one part I want to flag clearly rather than pretend it's a
guaranteed drop-in: a FiveM resource can only declare **one** `ui_page`.
The member panel (`web/ui.html`) is the primary page. The boss panel
(`html/ui.html`) is now loaded as a hidden `<iframe>` inside
`web/ui.html`, shown/hidden and fed messages via a small bridge script
I added at the bottom of `web/ui.html` (search for "MERGE BRIDGE").
`RegisterNUICallback` calls from the boss panel's JS keep working
because NUI callback routing is per-resource, not per-frame - but I
have not been able to visually test this in a running FiveM client. If
the boss panel doesn't show/hide correctly, that bridge script is the
first place to look.

## 3) ox_inventory conversion

Only one real inventory touchpoint existed: the gang **armory** (weapon
lockers accessed by a door code), which used to push a custom NUI event
`esx_inventoryhud:openGangInventory` - an event that only exists inside
`esx_inventoryhud` and does nothing at all on a server that doesn't have
it installed (which is presumably exactly why it looked "broken" to you).

**Fix (`server/Gangs.lua`, see `EnsureArmoryStash`):** each armory
station is now registered as a real `ox_inventory` stash
(`exports.ox_inventory:RegisterStash`), seeded once from whatever was
in the old JSON blob, and opened via
`TriggerClientEvent('ox_inventory:openInventory', src, 'stash', stashId)`.
ox_inventory's own UI/weight/stacking/anti-dupe logic takes over from
there, so the old hand-rolled `AddItemToInventory` / `TakeItemEvent`
server handlers (which manually mutated the JSON blob) were removed -
they're not needed anymore and nothing on the client called them
directly (they were only ever triggered from the old NUI panel).

**Behavior change to be aware of:** the old code enforced separate
`putitem` vs `takeitem` grade permissions *inside* the panel (you could
open it but have "put" blocked while "take" was allowed, or vice
versa). ox_inventory doesn't support that split out of the box - I
gated it to "needs putitem OR takeitem to open the stash at all", which
is close but not identical. If you need the exact old put/take split
enforced, that requires a custom `ox_inventory` `openInventory` hook -
happy to add it if you want that back exactly as it was.

`Config.inventoryimg` (item icon path) now points at
`nui://ox_inventory/web/images` instead of `esx_inventoryhud`.

## What I did NOT change

- The boss panel's actual feature set (hire/fire, promote, wardrobe,
  withdraw/deposit) - it's the original FMGangBoss logic, just rewired
  to live in one resource. I did not attempt to reproduce
  `Unique_Gangs`' much larger feature set (armory/garage/heli/boat
  access toggles, Discord webhook logs, vehicle permissions, etc.) -
  that's a genuinely large amount of additional work on top of this
  merge. Tell me which of those specific features you want ported over
  and I'll build them into this resource next.
- Everything client-side that wasn't touching inventory or the merge
  (gps.lua, lib.lua, load.lua, level.lua) is untouched from the
  original FMGangs.

## 4) `gangs:getGangData` console error (Unique_Hud compat)

`Unique_Hud/client/main.lua` still calls the **old Unique_Gangs**
callback name `gangs:getGangData` to fetch a gang's icon for the HUD.
Since the gang system running now is this resource (not the old
`Unique_Gangs`), that callback didn't exist and essentialmode logged
`TriggerServerCallback => [gangs:getGangData] does not exist` every
time the HUD tried to refresh. Added a small compatibility callback in
`server/Gangs.lua` under the same name, backed by this resource's own
`Gangs` table, so `Unique_Hud` keeps working unmodified.

## 5) Creating a gang required a server restart to actually work

Root cause: `essentialmode` only loads its live `ESX.Gangs` table from
the `gangs` / `gang_grades` tables **once**, on resource start
(`essentialmode/server/common.lua`). `xPlayer.setGang(name, grade)`
refuses to do anything for a gang that isn't in `ESX.Gangs`
(`ESX.DoesGangExist` check) - so a gang created through the panel was
invisible to `setGang` until essentialmode was restarted and re-read
the database. On top of that, **nothing ever called `setGang` for the
gang's creator in the first place** - so even after a restart, the
creator wasn't automatically put in the gang they'd just made.

**Fix (`server/Gangs.lua`, `FMGangs:CreateGang`):** `ESX` is the same
shared table both resources hold, so the new gang and its grades are
now written directly into `ESX.Gangs` at creation time - no restart
needed, it's live immediately. Right after that, the creator is placed
into their new gang at the top grade via `xPlayer.setGang(name, #grades)`,
matching the same "top grade number = boss" rule `FMGangs:isBoss`
already uses elsewhere.

## 6) Mouse/cursor gets stuck when the panel is open

The only way to close the panel and release the mouse (`SetNuiFocus`)
was clicking the in-UI (X) button. Pressing **Escape** - the first
thing anyone tries - did nothing, so the cursor stayed locked on
screen with no way back except relogging.

**Fix:** `client/main.lua` now has an Escape-key fallback (control 322)
that closes the panel and releases focus exactly like the (X) button
does, and also tells the UI to hide itself - I added a small `CLOSEPANEL`
message handler in `web/js/script.js` for this, since Lua had no way to
trigger the existing `CloseAdminPanel()` JS function on its own. This
also closes the boss-panel iframe if it was open.

## 7) Home/Gangs tabs stayed empty (even with a real gang created)

Real bug, found in `server/Gangs.lua`, three places (`GetPanelData`,
`GetGangsData`, `GetGangData`): each one loops over every gang in the
`Gangs` table and computes `100 / v.expire_day` for an expiration
percentage. The special `nogang` entry - which is **always** in that
table, seeded permanently in `database.sql` - has `expire_day = 0`.
Dividing by zero produces `inf`, and `inf` can't be represented in
JSON, so the callback's response to the NUI silently failed to
serialize. The panel's `fetch()` for Home/Gangs data just hung
forever with no response - it wasn't an empty-state, it never actually
got data at all, gang or no gang. Fixed by guarding all three: skip
the percentage calculation (default to `0`) whenever `expire_day` is
`0` or missing.

## 8) Boss panel staying visually stuck on screen

Every boss-panel action (withdraw, deposit, promote, demote, fire,
recruit, wardrobe, the main close button) released NUI focus
(`SetNuiFocus(false,false)`) when done, but only the wardrobe
(`otf`) action actually told the UI to hide the panel afterward
(`SendNUIMessage({type='displaynone'})`). Every other action left the
boss-panel iframe sitting on screen, fully unresponsive (focus already
released, so clicks do nothing) with no way to dismiss it short of
relogging - this is almost certainly what "mouse/panel gets stuck"
was describing. Added the missing `displaynone` message to every one
of those action handlers in `client/boss.lua`, and to the main panel's
close handler in `client/main.lua` too (it was only being sent on the
Escape-key path, not the normal (X)-button close).

## 9) "Create" button did nothing

Real, reproducible bug in `client/main.lua`. `CREATEGANG` and 6 other
buttons (`EDITRANK`, `EDITACCESS`, `DELETERANK`, `ADDRANK`,
`UPDATEGANG`, `ADDOPTIONS`) all share **one single global** 1-second
cooldown flag (`UIColdDown`). If any of those had fired in the last
second, the guarded callback did `return` **without ever calling
`cb(...)`** - the NUI `fetch()`/`$.post()` on the JS side never
resolves, so the button just does nothing: no error, no success, no
feedback of any kind. On top of that, neither success nor failure ever
showed a notification anywhere, so even a Create that *did* work
looked identical to one that silently failed - there was no way to
tell them apart.

**Fix:** all 7 callbacks now always call `cb(...)` even when the
cooldown blocks them (with a "please wait a moment" notification
instead of silence), and `CREATEGANG` specifically now shows a clear
success ("Gang created") or failure notification (with the actual
reason from the server - e.g. "a gang with that name already exists")
every time, so you can always tell what happened.

## 10) THE root cause of "nothing happens" across the whole panel

Found it, and this explains basically every "does nothing" / "stuck"
symptom reported so far in one shot.

FiveM routes every NUI callback by URL: `https://<resource-name>/<callback-name>`
- the resource name in that URL **has to match the actual running
resource** (FiveM's official docs use `GetParentResourceName()` for
exactly this reason). Both of the original UIs hardcoded the OLD,
pre-merge resource names instead:

- `web/js/script.js` (member panel): `window.ResourceName = 'FMGangs'`
- `html/js.js` (boss panel): every single `$.post(...)` had
  `'http://FMGangBoss/...'` hardcoded directly into the URL string (13
  places)

Since this is all one resource now (`Unique_ALLGangs`), **every NUI
request from both panels was posting to a resource name that no
longer exists** and silently failing with no response ever coming
back - no error shown anywhere, because neither script has a `.fail()`
handler on these requests. This is why Home/Gangs stayed empty, why
Create did nothing, and almost certainly why the boss panel
(withdraw/deposit/promote/fire/recruit/close - literally every button)
never worked either: none of those clicks were ever reaching the Lua
side to release `SetNuiFocus` in the first place.

**Fix:** both files now use `GetParentResourceName()` (FiveM's
built-in JS function that always returns the actual current resource
name) instead of a hardcoded string, so this can never drift out of
sync again even if the resource gets renamed later.

One caveat I want to flag honestly: the boss panel now lives in a
nested `<iframe>` (see section on the NUI merge above). I'm confident
`GetParentResourceName()` and NUI callback routing work correctly from
within that iframe based on how FiveM's NUI injection works, but I
have not been able to verify this visually in a running game client -
if the boss panel's buttons still don't respond after this fix
specifically (as opposed to the member panel, which isn't nested and
should be unaffected by this caveat), that's the next thing to
investigate.

## 11) Debug logging added for this round of testing

Added `print(...)` statements around the gang-creation flow (both
`server/Gangs.lua` and `client/main.lua`) so if anything is still
wrong, the server console and F8 client console will show exactly
which branch ran and what data was involved - look for lines starting
with `[Unique_ALLGangs]`.

## 12) Mouse stuck / can't aim while placing a Ped, Object, Vehicle, etc.

Confirmed real (`client/lib.lua`, `SetMarkerCoord`): this function runs
while the gang panel's NUI focus is still active from opening the
panel. The instructional buttons (Rotate/Place/Cancel) drew fine
because those are a HUD overlay, unaffected by NUI focus - but actual
camera-look (needed to aim where the placement raycast points) was
blocked the whole time, since the mouse was still locked in on-screen
UI-pointer mode. This affected every option type equally (Ped, Object,
Vehicle, Flag) - Marker likely just looked "fine" at a glance since it
doesn't need camera aim as much to look reasonable.

**Fix:** `SetNuiFocus(false, false)` now runs at the very start of
`SetMarkerCoord`, before anything is spawned, handing camera control
back for the whole placement phase. On a successful placement the
panel already reopens afterward (`ExecuteCommand(Config.OPENPANELCMD)`
in `client/main.lua`), which restores focus naturally. On Cancel (Q),
you're left in normal game control with no panel open - that's a
pre-existing minor UX gap (not something newly introduced), not the
"stuck" bug itself; open the panel again from the action menu if you
want to try placing again.

## Final audit (full sweep, requested explicitly)

Went through the whole resource specifically hunting for any other
"mouse stuck" / dead-click bugs before calling this done:

- **Every `SetNuiFocus(true, ...)` in the resource now has a matching
  release path.** Inventoried all of them (`client/main.lua`,
  `client/boss.lua`, `client/lib.lua`) - each "open" (panel open, boss
  menu open, placement mode start) has a corresponding "close" that
  actually runs (button, Escape, or successful completion).
- **No other hardcoded old resource names anywhere.** Swept every
  `.js`/`.html`/`.css` file in `web/` and `html/` for leftover
  `FMGangs`/`FMGangBoss` references - none left except my own comments
  explaining the fix.
- **Every CSS `url(...)` and image path resolves to a real file** that
  actually exists in this resource and is included in `fxmanifest.lua`'s
  `files{}` - checked file-by-file, nothing missing.
- **Every `RegisterNUICallback` that takes a `cb` parameter actually
  calls it** - swept both `client/main.lua` and `client/boss.lua`
  programmatically, no dangling ones left.
- Confirmed the boss panel's `Uiloaded` ready-ping (`html/js.js` ->
  `client/boss.lua`) was ALSO broken by the same hardcoded-URL bug from
  section 10 - meaning the boss panel could never even open before
  that fix (it would have shown "Insufficient authorization" every
  time, regardless of actual permission). Fixing section 10 fixed this
  too.
- Found one pre-existing (not introduced by this merge) piece of dead
  code: `client/boss.lua`'s `money`/`moneypage`/`editle`/`clear`
  messages have no corresponding button in `html/js.js` that ever
  triggers them, and no listener for `moneypage`/`editle` either.
  Doesn't affect anything currently in use (nothing calls it), so I
  left it as-is rather than build a whole feature that wasn't asked
  for - flagging it here in case you intended a dedicated "money page"
  that never got wired up on the UI side.

Nothing else turned up. This is the version I'd consider ready for
real testing.

## Testing checklist before going live

- [ ] `/openpanel` opens instantly even with several gang members online
- [ ] Boss panel opens/closes/updates (money, hire/fire, wardrobe) via the iframe bridge
- [ ] Armory door code opens an ox_inventory stash and items can be put/taken
- [ ] Steam avatars show up in both panels (give the cache a few seconds to warm after someone connects)
