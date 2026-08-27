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

## Testing checklist before going live

- [ ] `/openpanel` opens instantly even with several gang members online
- [ ] Boss panel opens/closes/updates (money, hire/fire, wardrobe) via the iframe bridge
- [ ] Armory door code opens an ox_inventory stash and items can be put/taken
- [ ] Steam avatars show up in both panels (give the cache a few seconds to warm after someone connects)
