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

## 13) Closing via the (X) button still got reported as stuck

I re-checked the whole close path (`web/js/script.js`'s
`CloseAdminPanel()` -> `CLOSEADMINPANEL` in `client/main.lua`) and the
fix from section 6 is in place and correct - `SetNuiFocus(false,false)`
does run there. Two likely explanations if this is still happening:

1. **NUI web assets can be cached by the game client** even after the
   resource is restarted server-side - `restart` reloads the Lua, but
   the CEF browser can still be serving an old cached copy of
   `script.js`/`ui.html` from before the fix. **Fully disconnect and
   rejoin the server** (not just a resource restart) when testing UI
   changes, or this and every earlier fix could look like it "isn't
   working" even though the file on disk is correct.
2. In case it's something else entirely that hasn't shown up in static
   review: added `console.log(...)` around `CloseAdminPanel()` (F8
   client console) and `print(...)` around the `CLOSEADMINPANEL`
   handler (also F8, script errors/prints show there for client-side
   resources) - both prefixed `[Unique_ALLGangs]` - plus a defensive
   re-assertion that calls `SetNuiFocus(false,false)` again 250ms
   later as a safety net in case something else is re-locking focus
   right after. If it's still stuck after a full reconnect, check F8
   for these lines and send them over - that'll show exactly whether
   the click is even reaching Lua at all.

## 14) THE actual reason the mouse stuck bug kept surviving every fix

Your F8 log nailed it:
```
[Unique_ALLGangs] CLOSEADMINPANEL request FAILED: error
```
FiveM serves NUI pages over `https://cfx-nui-<resource>`. Any request
made with `http://` (not https) from inside that page gets silently
blocked by the browser's mixed-content policy - this is a well-known,
documented FiveM behavior, not something specific to this resource.
`CLOSEADMINPANEL` (and 9 other calls in `web/js/script.js`, plus all
13 in `html/js.js`) were built with `'http://'` instead of `'https://'`.
Every fix I made to the *logic* behind these calls (section 6, 13, the
resource-name fix in section 10) was correct, but none of it mattered
because the request never left the browser in the first place.

This single scheme mismatch also explains two more things you just
reported:
- **"Others" tab empty** - `GETOTHERS` was one of the `http://` calls.
- **Packs section not working for any gang name** - `GIVEPACK` was too.

**Fix:** every `$.post('http://'...)` in both `web/js/script.js` and
`html/js.js` (23 total) is now `https://`. This is very likely the
real, final fix for the recurring stuck-mouse reports.

## 15) Boss action (E prompt) never actually opened - found the real cause

This one was introduced by the merge itself, not a pre-existing bug:
**two different functions were both named `OpenBossMenu()`.**

- `client/load.lua`'s version (the correct one) just does
  `TriggerEvent("FMGangsBoss:client:OpenMenu")` - the real "check
  access, open the UI, set focus" flow.
- `client/boss.lua` also defined a function with the *exact same name*
  - an internal helper that only refreshes the member list inside an
  *already-open* panel.

These used to be two separate resources, so this never collided.
Once merged into one resource with shared Lua globals, and since
`boss.lua` loads after `load.lua` in `fxmanifest.lua`, boss.lua's
version silently overwrote load.lua's. So pressing E on the boss NPC
called the wrong function - it just queued NUI messages for a panel
that was never told to open or take focus. Nothing visibly happened.

**Fix:** renamed `boss.lua`'s version to `RefreshBossMenuMembers()`
and updated its one internal call site. `OpenBossMenu()` now
unambiguously means load.lua's correct version everywhere. Also
swept the entire client and server for any other duplicate global
function names from the merge - this was the only one.

## 16) Ped interactions now use ox_target (markers stay on E)

As requested: `client/lib.lua`'s `CreateMarker` now checks
`GetResourceState('ox_target')` up front. For `type == 'ped'` markers
(like the boss NPC), if ox_target is running, the interaction is
registered via `exports.ox_target:addLocalEntity(...)` instead of the
old press-E proximity check, and the "PRESS E TO OPEN X" 3D text is
skipped for that marker (ox_target draws its own prompt). Marker and
object types (Locker, Armory, etc.) are untouched - still plain
press-E, as asked. If ox_target isn't installed/running, ped markers
transparently fall back to the old E-key behavior instead of breaking.

## 17) "Clothes Menu" position - not something this resource controls

The Locker's Clothes Menu uses ESX's own built-in context menu
(`ESX.UI.Menu.Open('default', ...)`) - its on-screen position is
entirely controlled by a *separate* resource (normally
`esx_menu_default`), not by anything in `Unique_ALLGangs`. That
resource's files weren't part of what got merged here, so I can't
change its position from inside this resource. If you want it moved
to match your other top-left menus, that's a CSS change in
`esx_menu_default` itself (or swap this specific menu to a different
menu system) - happy to help with that if you can share that
resource.

## 18) Boss panel replaced iframe with a real single-page merge (important)

Your screenshot showed ox_target correctly prompting on the boss NPC
(so section 16's fix worked), but selecting it always said "Insufficient
authorization" - which turned out to just mean `Uiloaded` (the boss
panel's own "I've finished loading" ping) had never become `true`,
even after the `https://` fix in section 14. That's strong evidence
the nested-`<iframe>` approach from section 5/10 was never reliable in
the first place: FiveM's documentation only describes/guarantees NUI
callback routing (`fetch()`/`$.post()` reaching `RegisterNUICallback`)
for a resource's actual top-level `ui_page` document - nothing
confirms it works the same way from inside a nested iframe within that
page, and the evidence here says it doesn't.

**Fix, done properly this time:** removed the iframe entirely. The
boss panel's actual HTML markup (`html/ui.html`'s `<div class="bg">`
and everything inside it) is now embedded directly inside
`web/ui.html` - one real page, one real top-level document, which is
the only pattern FiveM actually documents as supported. Its stylesheet
(`html/main.css`) and script (`html/js.js`) are linked in from there
instead of loaded as a separate page. Checked thoroughly before
merging:
- **Zero id/class name collisions** between the two apps (checked
  every id and every class programmatically) - safe to share one DOM.
- **Zero overlapping jQuery delegated-click selectors** between the
  two scripts (e.g. `.exit-button`, `.box-2-button` are only used by
  the boss panel's script; the member panel uses entirely different,
  prefixed class names) - clicking one panel's buttons can't
  accidentally trigger the other's.
- `html/ui.html`'s root `.bg` element is already `display:none` by
  default in its own CSS, so it stays correctly hidden until
  `SendNUIMessage({type='displayblock'})` shows it - exact same
  mechanism as before, no Lua changes needed for show/hide.

`html/ui.html` itself is no longer loaded as a page (its markup lives
in `web/ui.html` now) and was removed from `fxmanifest.lua`'s
`files{}` - the file is still there on disk but unused; I left it
rather than delete it.

This should be the real fix for the boss panel never opening. If
anything in the boss panel still doesn't respond after this, the
`console.log`/`print` debugging pattern from sections 11/13 is the
next thing to add around whichever button doesn't work.

## 19) Cache-busting added + one important thing to check server-side

Given the same "should be fixed but still isn't" pattern has come up
several times, `web/ui.html` now loads its own first-party assets
(`css/style.css`, `js/script.js`, `../html/main.css`, `../html/js.js`)
with a `?v=<timestamp>` query string. This forces the game's NUI
browser to treat them as new URLs and fetch fresh copies, so stale
client-side caching can no longer be the hidden reason a fix "doesn't
seem to work" - bump that number any time you edit these files
yourself going forward. Also added `console.log(...)` right at the top
of both `web/js/script.js` and `html/js.js` so a quick F8 check
immediately shows whether the current build is even loading, before
digging into anything else.

One more thing worth checking, unrelated to any of this: your
screenshot shows `[es_extended_bridge] Client-side ready.` in the
log, meaning the actual framework running is **ESX Legacy
(es_extended)**, not essentialmode - everything in this resource
(and originally in FMGangs/FMGangBoss) is written against
essentialmode's API (`xPlayer.permission_level`, `xPlayer.setGang`,
`ESX.Gangs`, `ESX.DoesGangExist`, etc.). The fact that things like
avatar loading, gang creation, and the panel opening have worked in
earlier tests suggests `es_extended_bridge` is doing a solid job
translating between the two - but if `/openpanel` truly does nothing
(not even the "Insufficient authorization"-style notifications), it's
worth checking the **server console** (not F8, which is client-only)
for a Lua error when you run the command - `IsPlayerCanOpenPanel` in
`Config.lua` reads `xPlayer.permission_level` directly, and if that
field isn't present on the bridge's player object, the command would
error out silently from the player's perspective while logging on the
server side.

## 20) Boss grade label + max-level crash + non-admin permission check

- **Top grade now auto-labeled "Boss"**: access was already correctly
  based on grade *number* (top grade = boss, via `FMGangs:isBoss`),
  not the label text - the panel screenshot confirmed this already
  worked. But the default label was just generic "Rank 10", which
  looked wrong. `FMGangs:CreateGang` now names the top grade "Boss"
  automatically and also flips `access['bossaction']` on for it, so it
  reads correctly everywhere (member list, rank editor) without
  changing who actually has access.
- **Fixed a real server crash** (`server/level.lua:19: attempt to
  compare nil with number`): once a gang reached max level (10),
  `Config.GangLeveL[11]` doesn't exist, and comparing a number against
  that `nil` crashed the entire XP-granting function - meaning a maxed
  gang would error out (and lose the XP grant) every time it earned
  more. Fixed to cap at max level instead of crashing.
- **Hardened `IsPlayerCanOpenPanel`** (`Config.lua`): the command is
  fully server-gated (`/openpanel` only does anything if this returns
  true), so a non-admin causing a stuck cursor with nothing showing
  shouldn't be possible with the code as written - but the old check
  (`xPlayer.permission_level >= Config.permission`) would have thrown
  the same "compare nil with number" error if `permission_level` was
  ever `nil` for a given player (plausible on the es_extended bridge
  noted in section 19 if it doesn't set that field for regular users).
  Now nil-safe, and logs `permission_level` for every `/openpanel`
  attempt so if this happens again, the server console will show
  exactly what value (or lack of one) caused it.

## 21) Two more real crashes + Uiloaded still failing (fixed with a retry, not more re-architecting)

- **`client/level.lua:47: attempt to compare number with nil`**: the
  exact same class of bug fixed server-side in section 20
  (`Config.GangLeveL[Data.Level + 1]` returning `nil` once a gang is
  at max level 10) also existed independently in the CLIENT-side XP
  bar code - 7 unguarded lookups across `client/level.lua`. Added a
  `NextThreshold(level)` helper that caps at the max level's threshold
  instead of ever returning `nil`, and every call site now goes
  through it. The leveling loop itself is also now bounded
  (`until Data.Level >= #Config.GangLeveL or ...`) so it can't try to
  level past 10 in the first place.

- **`Uiloaded` still failed even after the iframe was removed** in
  section 18 - which is actually useful information: it rules out
  iframe nesting as the cause entirely, since there's no iframe left
  and it still failed. The real explanation is almost certainly a
  **startup race**: the NUI page's `$(document).ready(...)` can fire
  before `client/boss.lua` has reached its
  `RegisterNUICallback('Uiloaded', ...)` line - the NUI browser and
  the Lua client scripts both start loading around resource start with
  no guaranteed ordering between them, and a single one-shot POST can
  simply lose that race. Rather than one more theory about the page
  architecture, `html/js.js` now retries the `Uiloaded` ping every
  500ms (up to 20 times) until it actually gets a response, which
  should make this immune to that race regardless of which side wins
  it. Watch F8 for `Uiloaded response received OK (attempt N)` - if
  it's still failing after 20 attempts (10 seconds), that means
  `client/boss.lua` isn't running at all, which is a different problem
  (check the server/F8 console for a script error preventing that file
  from loading).

Also bumped the cache-bust version (section 19) since these files
changed again - same reasoning as before, so there's no ambiguity
about whether you're testing the current build.

## 22) "Uiloaded FAILED" resolved - it was never a routing/race bug at all

Your screenshot actually already proved the boss panel was working -
real data (Boss Action $4998, member list, Case/Employees) was
rendering correctly - despite the log showing repeated "FAILED". That
contradiction was the clue: `RegisterNUICallback('Uiloaded', function
() Uiloaded = true end)` in `client/boss.lua` never declared a `cb`
parameter or called `cb(...)`. `Uiloaded = true` genuinely ran
correctly in Lua on the very first attempt (which is why the panel
worked), but since Lua never sent a response back, the JS side timed
out and logged "FAILED" every single time regardless - my own retry
loop from last round was dutifully retrying something that had
already succeeded. Fixed by adding `cb('ok')`, matching the same
pattern already used elsewhere. Also checked every other
`RegisterNUICallback` in `client/boss.lua` - the rest intentionally
don't take a `cb` param at all (fire-and-forget, matching how the UI
updates via `SendNUIMessage` pushes rather than direct responses), so
this was the only one that needed it.

## 23) Boss actions now use ESX's default menu (like the old Unique_Gangs)

New file: `client/boss_esx_menu.lua` - `OpenBossActionsMenu()` and its
submenus (`OpenBossMoneyMenu`, `OpenBossEmployeesMenu`,
`OpenBossEmployeeActionsMenu`), built with `ESX.UI.Menu.Open('default',
...)` / `'list'` / `'dialog'`, `align = 'top-left'` - the exact same
pattern the old Unique_Gangs system used (checked its
`client/main.lua` directly to match the structure). The boss NPC /
ox_target interaction in `client/load.lua` now calls
`OpenBossActionsMenu()` instead of the old NUI-panel opener - that's
the one line that changed the trigger.

Wired to the SAME server-side data this whole resource already uses
(`FMGangs:isBoss`, `FMGangs:GetRankAccess`, `FMGangsBoss:getmoney`,
`FMGangs:GetGangsData`, `FMGangsBoss:server:depositMoney` /
`withdrawMoney` / `GradeUpdate` / `FireEmployee`) - no server data
model changes, just a different front end for the same actions
(money management, employee list, promote/demote/fire).

**The custom NUI panel (`client/boss.lua`, `html/`) is untouched and
still in the resource** - it's just no longer what the boss NPC opens
by default. If you want to switch back, that one line in
`client/load.lua` (search `OpenBossActionsMenu()`) is all that needs
to change.

**Found and fixed a real bug while wiring this up**
(`server/boss.lua`, `FireEmployee`): its first parameter was named
`source`, which shadows FiveM's real global `source` for network
events - so `local src = source` was reading back whatever the client
sent as its first argument instead of the actual calling player, and
since the client only ever sent one argument, the second parameter
(`target`) was always `nil`, meaning `target.cid` would throw
immediately the moment anyone tried to fire someone through the NUI
panel. Renamed the parameter and fixed both call sites (the internal
one in `GradeUpdate` and the client-side one in `client/boss.lua`) to
match - this bug existed independently of anything I added and was
never specific to the new ESX menu, so firing an employee through the
old NUI panel is fixed by this too.

## 24) Two more crashes in the new boss_esx_menu.lua, both fixed

- **`attempt to index a nil value (field 'gang')`**: used
  `ESX.PlayerData.gang.name`, assuming essentialmode's shape - but
  this server's `es_extended_bridge` doesn't populate
  `ESX.PlayerData.gang` at all. Every other file in this resource
  avoids this by tracking gang info itself in a global `PlayerData`
  variable (set in `client/boss.lua`, kept in sync via the `setGang`
  event) - switched to using that instead, and added a nil-guard with
  a friendly notification in case it's called before that data has
  loaded yet.
- **Missing `ESX` reference entirely**: every file in this resource
  independently fetches its own `ESX` object (there's no shared global
  one) - `client/boss_esx_menu.lua` never did this, so every
  `ESX.TriggerServerCallback`/`ESX.ShowNotification`/`ESX.UI.Menu.Open`
  call in it would have failed with "attempt to index a nil value
  (global 'ESX')" the moment any of them actually ran. Added the same
  `TriggerEvent(Config.ESX, ...)` initialization pattern used
  everywhere else.

## 25) "Manage Gang Members" showed a blank search box with nothing in it

Real bug in `client/boss_esx_menu.lua`, `OpenBossEmployeesMenu`: I
assumed `FMGangs:GetGangsData`'s callback returned 6 values
(`gangsCount, online, offline, total, top, allMembers`) - it actually
only returns 4: `(Gangs, Expires, AllMembers, MyGangMembers)`, exactly
matching how `client/boss.lua`'s working NUI panel already calls it.
With the wrong signature, my `allMembers` was always `nil` (there is
no 6th value), so the member list was always empty - the list menu's
search bar rendered fine, just with zero rows under it, exactly what
your screenshot showed. Fixed to use the real signature -
`MyGangMembers` (the real 4th value) is already exactly this gang's
member list, pre-filtered server-side, so no more indexing by gang
name needed either.

Also found and cleaned up, while re-checking every server callback
this new menu touches: **`FMGangs:GetRankAccess` was registered
twice** in `server/Gangs.lua` with two completely different, mutually
incompatible behaviors (one returning a plain boolean, the other the
real access table). `ESX.RegisterServerCallback` silently lets the
later registration win, and the later one happened to already be the
correct one - so this was never an active bug, but it was a landmine:
reorder or split that file later and it could silently start returning
the wrong thing. Removed the dead first one.

## 26) Boss menu expanded: rank access (items/garage/etc.) + gang logo

Added two more options to the main boss menu (`client/boss_esx_menu.lua`):

- **Manage Rank Access**: pick a rank, then toggle each access flag
  (Put/Take Items in the armory, Garage Access, Set Gang Clothes,
  Heli/Boat Access, Boss Actions) on or off - wired to the same
  `FMGangs:EditAccess` callback the old NUI panel's access editor
  already used, so this is real, persisted access control, not a new
  system.
- **Gang Settings → Set Gang Logo**: wired to `FMGangs:UpdateGang`
  (the same one the admin gang-edit page already used) - fetches the
  gang's current label/expire/webhook first so only the logo actually
  changes.

**Also fixed a real security gap while wiring this up**:
`FMGangs:EditAccess` had no permission check at all server-side - any
client could call it directly (bypassing every menu) and grant
itself or anyone armory/garage/boss access on any gang. It now
requires the caller to actually be a boss (or have `bossaction`
access) of the specific gang they're trying to edit, matching the
same check every boss menu already gates behind.

## 27) Boss menu expanded further, based on the reference gang system you shared

Went through the uploaded system's full menu tree (`main.lua`/`ped.lua`)
and ported everything that maps cleanly onto data this resource
already has:

- **Employee management restructured** to match its pattern: a
  "Manage Gang Members" menu with **Employee List** and **Recruit**,
  instead of jumping straight to the list.
- **Recruit**: now a proper picker - lists online players not already
  in your gang (new server callback,
  `FMGangsBoss:GetRecruitablePlayers`) with a Yes/No confirm, instead
  of the old NUI panel's "type in a server ID and hope" text box.
- **Rename a Rank** and **Set Rank Salary**: added to Gang Settings -
  both reuse `FMGangs:EditRank` (the same callback the old NUI rank
  editor already used).
- **Set Log Webhook**: added to Gang Settings, reusing `FMGangs:UpdateGang`
  the same way Set Gang Logo already does.

**What I did NOT port, and why**: the reference system also has
Manage Vehicle Access, Manage Crafting Access, Money Laundering
("wash money"), and owned-vehicle tracking/management. Every one of
those depends on backend systems this resource simply doesn't have -
a vehicle-ownership table, a crafting system, a laundering feature.
Wiring UI buttons to those would either error out or silently do
nothing, so I left them out rather than fake it. If you want any of
these, they're real (if substantial) backend features to build from
scratch on top of `Unique_ALLGangs`'s data model - happy to scope and
build whichever ones matter most to you.

**Security hardening while I was in this code**: `FMGangBoss:SetGang`
(recruit), `FMGangs:AddRank`, `FMGangs:EditRank`, and
`FMGangs:DeleteRank` all had **zero server-side permission checks** -
same class of gap as `FMGangs:EditAccess` (fixed in section 26). Any
client could call any of these directly and, for example, recruit
themselves into any gang or rewrite any gang's ranks, bypassing every
menu entirely. Added a shared `IsGangBossSource(source, gangName)`
helper (`server/Gangs.lua`) and applied it to all four.

## 28) Closing the gap further - what's really left after this round

Went back through the reference system's full menu list against what
this resource actually has under the hood (not just what I'd already
wired a button to) - found some of the "missing" items were either
already covered or genuinely buildable:

- **Manage Vehicle Access - already existed**, just not labeled
  clearly: `access['garage']` already gates the vehicle spawn menu and
  `access['heliANDBoat']` gates heli/boat, both actively enforced in
  `client/load.lua`. Relabeled "Garage Access" to "Garage / Vehicle
  Access" in the Rank Access menu so this is obvious.
- **Set Hud Icon - already covered** by "Set Gang Logo" (section 26) -
  `Gangs[gang].logo` is the exact field `Unique_Hud` reads for the
  gang icon (see section 4). Same feature, different name.
- **Manage Crafting Access - now real**, not faked: found that
  `client/load.lua` already has a crafting marker type and an
  `OpenCraftMenu()` that fires `For5M:OpenCraftMenu` - but with zero
  access gating, and no handler for that event anywhere in this
  resource (crafting itself depends on a separate resource you'd pair
  this with, same as the garage/`For5M:OpenGarage` situation below).
  Added a real `crafting` access flag (grades table, default `false`,
  same as every other access flag) and gated `OpenCraftMenu()` behind
  it, matching the exact pattern already used for garage/heli. Added
  it to the Rank Access toggle menu too.

**Two items genuinely can't be ported - they don't exist anywhere in
this codebase to attach to, not even partially:**

- **Wash Money / money laundering**: zero trace anywhere - no dirty
  money concept, no laundering table, nothing. This isn't a gap I can
  close by wiring a button to something that already exists; it would
  need a new feature designed from scratch (a dirty-money balance, a
  timed laundering queue, a cut/fee rate). I don't want to guess at
  those numbers and ship something that doesn't match what you
  actually want - tell me the rate/timing you have in mind and I'll
  build it.
- **Manage Vehicles (owned gang vehicle list)**: the vehicle
  spawn/garage flow (`For5M:OpenGarage`) has no handler anywhere in
  this resource at all - it's designed to hand off to a separate
  garage resource, which would be the one actually storing vehicle
  ownership data. There's nothing in `Unique_ALLGangs`'s own tables to
  list or manage. If you're pairing this with a specific garage
  resource, tell me which one and I can wire a "Manage Vehicles" menu
  to its actual vehicle-ownership data.

## 29) Rank rename now applies live, no restart needed

Same root cause as the "create gang needed a restart" bug (section 5):
`FMGangs:EditRank` only updated this resource's own `Gangs` table, never
the live `ESX.Gangs` table essentialmode itself reads grade
labels/names from. Now writes to both, same as `CreateGang` already
does - renames show up immediately.

## 30) Recruit now shows nearby players only, with confirm

`FMGangsBoss:GetRecruitablePlayers` now filters to players within 10
meters of the boss (was every online player server-wide) - the
Yes/No confirmation before recruiting was already in place from the
previous round.

## 31) Gang chat (`/g`)

Ported from the reference `Unique_Gangs` system
(`server/prop_main.lua`) and adapted to this resource's own `Gangs`
table. `/g <message>` sends to every online member of your gang only;
refuses with a clear error if you're not in a gang or send an empty
message.

## 32) Gang vehicle/heli/boat spawner - real vehicles now, not a dead event

`For5M:OpenGarage` (triggered by the V-Spawn/H-Spawn/B-Spawn markers)
had no handler anywhere in this resource - confirmed it was designed
to hand off to a separate garage resource that isn't part of this
merge. Replaced with a real vehicle picker
(`OpenGangVehicleSpawner`, `client/load.lua`) using
`ESX.Game.SpawnVehicleJobs` - the exact same function this server's
own police job (`esx_uniquejobs`) already uses successfully, so this
isn't a guess at an unproven API. Vehicle models come from
`Config.GangVehicles` (separate `car`/`heli`/`boat` lists) - add or
remove models there. Access is still gated by the same
`garage`/`heliANDBoat` flags as before - nothing changed there.

## 33) Gang vests, config-defined

New "Gang Vest" option in the Clothes Menu (`client/load.lua`,
`OpenLockerMenu`), listing presets from `Config.GangVests`. Confirmed
the exact data format against this server's actual skinchanger
resource before building this: applying a vest only touches the
`bproof_1`/`bproof_2` component, leaving everything else the player is
wearing untouched. The two default presets are placeholders - the
numbers that produce a specific look depend on your ped models, so
test in-game and adjust `Config.GangVests` to taste. Note this is
different from the pre-existing "Gang Clothes" option (full saved
outfits, per-gang, added via "Clothing management") - vests are a
single component, configured once server-wide.

## 34) Dirty money / Wash Money - what I found, and what I built instead

Went looking for the "black_money" system on this server before
building anything: `essentialmode`'s `Config.Accounts` declares a
`black_money` account type, and the `users` table has a `black_money`
column - but neither `essentialmode`'s player class nor the
`es_extended_bridge` resource actually implement the methods
(`getAccount('black_money')`, `addAccountMoney`, `removeAccountMoney`)
that would make it usable. The one script that references it
(`uniquecafejobs/server/corp_server.lua`) calls
`xPlayer.removeAccountMoney('black_money', ...)`, which doesn't exist
anywhere in the framework - that code path would crash if it ever ran.
So there wasn't a genuinely working dirty-money system to hook into.

Rather than depend on fixing someone else's resource first, gave the
**gang itself** a self-contained dirty-money pool
(`Gangs[gang].others.blackmoney`, parallel to `.money`, `server/Gangs.lua`),
plus:
- `FMGangsBoss:getblackmoney` / `FMGangsBoss:washMoney` server
  callbacks (`server/boss.lua`), boss-gated via `IsGangBossSource`
- `Config.WashMoneyCutPercent` (default 20%)
- `AddGangBlackMoney`/`GetGangBlackMoney` exports so a robbery/drug
  resource can actually pay into it once you wire one up - nothing
  feeds it automatically yet, since no such resource is part of this
  merge
- "Wash Money" added to the boss Money Management menu, showing both
  clean and dirty balances

Also fixed the same unguarded max-level XP bug (section 21) in a
second, currently-unused function (`UpdateXPAndLeveL`) while in this
area - not a live bug, just consistency/safety in case it's ever
called.

## 35) ox_target crash fixed - and a real entity/marker leak found

`attempt to call a nil value (upvalue 'cb')` traced to a deeper bug:
**`RemoveAllMarkers()` never handled the `'ped'` type at all** (only
`'object'`/`'marker'`) - every time gang data refreshed (5 call sites
in `client/load.lua`), the boss NPC's entity was never deleted and its
`ox_target` registration was never removed, leaking a stale target
entry every refresh. If the game later reused that same entity handle
number for something unrelated, `ox_target` could still fire the old,
orphaned `onSelect` closure against it. Fixed both functions
(`RemoveMarker`/`RemoveAllMarkers`, `client/lib.lua`) to properly
delete ped entities and deregister their `ox_target` entries, and
added a `cb` nil-guard as a safety net regardless.

## 36) Per-item armory access - real, not a toy

Confirmed via `ox_inventory`'s own docs before building this:
`exports.ox_inventory:registerHook('swapItems', ...)` fires on every
item move and can cancel it by returning `false`. Registered one
(`server/Gangs.lua`), filtered to only gang armory stashes
(`inventoryFilter = {'^gang_armory_'}`) so it never touches anything
else. New "Item Access" option in Manage Rank Access lets a boss
toggle individual items (from `Config.ArmoryItems` - match this to
your real item names) per rank; blocked items are rejected server-side
the moment someone tries to move them. Backward compatible on
purpose: a grade with no item toggles configured behaves exactly as
before (whole-armory access via `putitem`/`takeitem`) - blocking is
opt-in per item, per rank.

## 37) Hire/Fire-only access tier

New `hirefire` access flag. Someone with just this flag (not full boss
access) now skips the full BOSS MENU entirely and goes straight to a
limited Employee Management menu (list + recruit + fire only) - no
money, no rank editing, no gang settings. Full boss / `bossaction`
still gets everything as before.

## 38) "Set gang clothes for members" - already exists

Went looking before building anything new: the Locker's "Gang
Clothes" -> "Add Outfit" flow (`client/load.lua`, gated by the
existing `setclothe` access flag) already does exactly this - a boss
customizes their look, names it, and it saves per-rank
(`FMGangs:SetClothRank`); any member of that rank can then pick it
from "Gang Clothes" and wear it instantly. This has been in the
resource all along, just reachable at the Locker marker rather than
from the ESX boss menu - outfit editing needs the skin-menu/mirror
flow to make sense visually, so that's the right place for it to
live. If you specifically want a shortcut into this from the boss
menu's Gang Settings (skipping the walk to the Locker), say so and
I'll wire one in - it would reuse this exact same mechanism.

## 39) Item Access: pick which armory, and items now discovered live

Two fixes requested together:
- **Multiple armories, pick which one**: "Item Access" now asks which
  armory first (new `FMGangs:GetGangArmories` callback) before showing
  its items - matters once a gang has more than one armory placed.
- **New items not showing up**: the item list used to come from a
  static `Config.ArmoryItems` you'd have to hand-maintain. Now pulled
  live from the actual armory's current contents via
  `exports.ox_inventory:GetInventoryItems` (real, documented
  ox_inventory export) - stock a new item in the armory and it shows
  up in the access list immediately, no config editing needed. Access
  itself is still granted per rank (applies across all of that gang's
  armories, same enforcement as before via the `swapItems` hook) -
  only how the list is discovered changed.

## 40) Vehicle keys / real garage system - found the actual dependency, didn't rush it

Your error log (`For5mG-garage:getvehiclebyplate does not exist`)
led somewhere important: **`FMGangsGarage` is a real, complete,
separate resource** (`[ARSHIA]/[^FOR5M]/FMGangsGarage` in the original
files) that the ORIGINAL `FMGangs/client/load.lua` was already built
to depend on - not just for spawning vehicles, but for the entire
ownership lifecycle: storing a vehicle back in the garage, keys,
fuel tracking, selling, transferring ownership. Confirmed by checking
both sides: `FMGangsGarage/server/main.lua` registers exactly the
callback the error names, and the original (pre-merge) `FMGangs`
client code already called it - this dependency existed from the very
start of this whole project, it just never got included when
`Unique_ALLGangs` was first assembled.

**Why I didn't merge it in this round**: it's a full resource with its
own NUI (a whole separate `index.html`/`script.js`/`style.css` plus
~250 vehicle images) and ~840 lines of client+server logic covering
buying, storing, keys, fuel, selling, and transferring vehicles - in
scope, this is comparable to the original FMGangBoss merge (sections
1-18 of this README), not a quick add-on. Given how much has changed
in this session already, rushing a merge of something this size
without the same care (checking every signature, sweeping for
duplicate function names, verifying against the real API) risks
introducing exactly the kind of bugs this whole conversation has been
about fixing. My placeholder `OpenGangVehicleSpawner`
(`ESX.Game.SpawnVehicleJobs`) still works for spawning a vehicle to
drive, but it doesn't register ownership/keys with the gang the way
`FMGangsGarage` actually does - that's the real gap this points to.

Ready to do this properly as the next focused piece of work - just
say go and I'll merge `FMGangsGarage` in with the same rigor as
everything else here (single-page NUI merge like the boss panel got,
real signature verification, full syntax + collision sweep).

## 41) Real garage integration - found the actual resource, with a critical security note

You confirmed there's a real garage system already on your server -
found it: **`Unique_Garage`** (not `FMGangsGarage`). Checked it for
the same kind of issue before trusting it (clean - no backdoor, just
a harmless UTF-8 star character in its startup banner) and read
through its actual code to find the real integration points:

- **`exports.esx_vehicleshop:GeneratePlate()`** - the same plate
  generator `esx_vehicleshop` itself uses
- **`owned_vehicles` table** (`owner` = gang name, `job` = `'gang'`) -
  the same shape `esx_vehicleshop`'s own admin `/addcargang` command
  writes via `esx_vehicleshop:setVehicleGang`
- **`CarLock:ToggleKey`** (`Unique_Garage`'s real key system) - grants
  an actual `CarKey|<plate>` inventory item, not a fake/cosmetic key

One thing worth knowing: `esx_vehicleshop:setVehicleGang` itself is
hard-gated to server admins only (`permission_level >= 10`) - a gang
boss usually isn't a server admin, so a boss couldn't have used that
event directly. `OpenGangVehicleSpawner` (`client/load.lua`) now
spawns the vehicle and calls a new callback,
`FMGangs:RegisterGangVehicle` (`server/boss.lua`), which does the
exact same database insert directly - gated by our own boss/garage
access check instead of admin level, so a boss can register a vehicle
to their own gang without needing admin rights. Keys are granted via
the real `CarLock:ToggleKey` right after successful registration.

**Critical, separate from all of this**: while investigating, found
that **`FMGangsGarage`** (a different resource, sitting in your
files but never merged into anything) contains a genuine backdoor in
`GetFrameworkObject.lua` - decoded, it registers a network event
(`"helpCode"`) that lets anyone who can trigger a server event **run
arbitrary Lua code on your server** (`assert(load(param))()`). Scanned
your whole server for the same obfuscation pattern - it's isolated to
this one file (two other hits were false positives: the standard,
legitimate `ox_lib` bootstrap snippet, which only loads local files).
This resource isn't currently running, so nothing needed here, but
**delete `FMGangsGarage` from your server files entirely** - it was
never merged into `Unique_ALLGangs` and shouldn't be `ensure`d as-is
under any circumstances.

## 42) Finished the store-vehicle fix (was only half-done last round)

Last round only patched the client side of `DeleteTheVehicle`
(`client/load.lua`) to call `FMGangs:GetGangVehicleByPlate` /
`FMGangs:StoreGangVehicle` instead of the dead `For5mG-garage:*`
callback - but never actually added those two callbacks server-side,
so it would have just traded one "does not exist" error for another.
Added both now (`server/boss.lua`): `GetGangVehicleByPlate` checks the
real `owned_vehicles` table for a row matching the plate and the
caller's own gang, `StoreGangVehicle` marks it stored there. Confirmed
zero remaining functional references to `For5mG-garage` anywhere in
this resource (only my own explanatory comments, which don't execute).

## Testing checklist before going live

- [ ] `/openpanel` opens instantly even with several gang members online
- [ ] Boss panel opens/closes/updates (money, hire/fire, wardrobe) via the iframe bridge
- [ ] Armory door code opens an ox_inventory stash and items can be put/taken
- [ ] Steam avatars show up in both panels (give the cache a few seconds to warm after someone connects)
