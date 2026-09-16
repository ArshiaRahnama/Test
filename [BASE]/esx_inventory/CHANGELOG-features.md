# esx_inventory — Feature additions

New, self-contained features added on top of the existing resource. Nothing
existing was removed; everything below is additive and follows the same
coding conventions (framework-agnostic helpers, `Config.*`, `Locales[...]`)
already used throughout the project.

## 1. Ground drop system
- `server/custom/drop/drop.lua` (new) — validates & removes the item from
  the dropping player using the same `RemoveItem`/`removeWeapon`/`removeMoney`
  helpers used everywhere else, stores the drop, and re-validates distance
  server-side on pickup (never trusts the client).
- `client/custom/drop/drop.lua` (new) — renders a local decorative prop +
  `[E] Pick up` marker/prompt for nearby drops, and the NUI `dropItem` hook.
- New **DROP** button next to Use/Give/Rename/Delete, and a **Drop** option
  in the new right-click context menu.
- Configure in `config/config.lua` → `Config.Drop` (prop model, pickup
  distance, despawn time, max drops on the ground at once).
- Clothes / ID card / phone are intentionally NOT ground-droppable (same
  reasoning as `Config.ItemNoGive`/`Config.WeaponNoGive` — they're
  per-character DB records, not stackable items).

## 2. Item rank/quality (colored glow)
- `Config.ItemRanks`, `Config.DefaultItemRank`, `Config.RankOrder`,
  `Config.GetItemRank(name)` in `config/config.lua` — map any item/weapon
  name to `common | uncommon | rare | epic | legendary`.
- Mirrored on the JS side in `config/config.js` (`RANK_ORDER`, `RANK_COLORS`)
  for the border/glow colors.
- Every item sent to the NUI (standard items, weapons, accounts, clothes,
  ID card, phone, in both the normal list and the category-filtered view,
  for both the ESX and QB code paths) now carries a `rank` field.
- **You need to fill in `Config.ItemRanks`** with your own item names —
  only two example weapons are pre-filled; anything not listed falls back
  to `common` (no glow).

## 3. Weight bar color (warning/danger)
- `updateWeightBarColor()` in `inventory.js` — turns the bar amber at 75%
  capacity and pulsing red at 90%, for both the player and trunk weight bars.

## 4. Search + sort
- Existing search box is now paired with 4 sort buttons (weight / name /
  rank / category) — `sortInventory()` in `inventory.js`, toggles
  ascending/descending on repeated clicks, empty slots always sink last.

## 5. Hover "3D-ish" preview
- Item icons are flat 2D PNGs, not 3D models, so a true rotating 3D preview
  isn't possible inside this NUI. Implemented instead: a cursor-driven
  tilt/parallax effect (`perspective()/rotateX()/rotateY()` on mousemove)
  that gives a comparable "inspecting the item" feel.

## 6. Loot-open animation
- `.form-inv` now fades + scales in/out instead of a flat `fadeIn/fadeOut`.
- A short "lid pop" animation plays on top of that when opening a corpse
  or another player's loot (`lootAnim = true` passed in the `open:Inv` NUI
  message from `client/apps/system/corpse.lua` / `loot.lua`). Any other
  system (stash, property, trunk) can opt into the same animation by
  adding `lootAnim = true` to its own `open:Inv` message.

## 7. Right-click context menu
- Use / Give / Drop / Inspect, positioned at the cursor, with menu options
  hidden automatically when they don't apply to the clicked item's type.

## 8. Weight/size on each slot
- Small "X.Xkg" tag in the corner of every populated slot.

## 9. Inspect modal
- Big icon, label, rank, quantity, and total weight, opened from the
  context menu.

## New/changed files
```
config/config.lua                      (Config.Drop, Config.ItemRanks, ranks helper)
config/config.js                       (RANK_ORDER, RANK_COLORS)
locales/locales.lua                    (drop_full_ground, pickup_item, sort_*, etc.)
locales/locales.js                     (drop/inspect/sort/search strings, all 3 languages)
fxmanifest.lua                         (registers the new drop folders)
server/custom/drop/drop.lua            (NEW)
client/custom/drop/drop.lua            (NEW)
client/main.lua                        (rank field attached to every item sent to NUI)
client/apps/system/corpse.lua          (lootAnim flag)
client/apps/system/loot.lua            (lootAnim flag)
src/html/ui.html                       (drop button, sort row, context menu, inspect modal)
src/html/assets/css/extras.css         (NEW — all new styling)
src/html/assets/css/button.css         (drop button sizing)
src/html/assets/js/inventory.js        (rank styling, sort, context menu, inspect, tilt hover,
                                         weight-bar color, fade+scale open/close)
```

## Known pre-existing limitation (not introduced by this changeset)
The QBCore adapter (`server/custom/framework/qb.lua`) is missing several
functions the rest of the resource already calls unconditionally on every
system (`getWeight`, `removeMoney`, `GetItemLabel`) — this was true before
these changes and affects stash/trunk/property/glovebox/corpse equally, not
just the new drop system. Fixing QB parity properly is a separate, larger
task outside the scope of this feature set.

## Round 2: Weapons + Clothes

### Weapons
- **Legal/Illegal + police scan**: `Config.WeaponLegality`, `Config.PoliceJobs`.
  New "Scan Serial" context-menu action on any weapon → server event
  `esx_inventory:scanWeapon` (`server/custom/weaponscan/weaponscan.lua`).
  Server-authoritative: a civilian client gets "you don't have the
  equipment", only an actual police-job player gets the real legal/illegal
  answer - the legality string is never sent to a non-police client, so it
  can't be read out of network traffic or memory either.
- **Per-weapon-class equip/holster sound**: `Config.WeaponClasses` +
  `Config.WeaponSounds`, wired into the existing weapon-toggle code in
  `client/main.lua`'s `useItem` handler, using `PlaySoundFrontend` with
  GTA's built-in sound sets (no extra audio files needed - swap the
  name/set pairs for your own if you want a different feel).
- ⚠️ `client/apps/default/weapon.lua` (527 lines) is **entirely commented
  out** in this build - it does nothing right now. The real, live
  equip/holster code path is in `client/main.lua`, which is what got
  hooked here.

### Clothes
- **Luxury/brand rank + glow**: `Config.ClothesRanks[type][key]` reuses the
  same rank/glow system as weapons/items. `key` is built by the new
  `Config.ClotheValueKey(type, value)` from the item's stored
  `{[type_1]=drawable, [type_2]=texture}` table - e.g. `"5_0"`.
- **Limited Edition**: `Config.LimitedClothes[type][key] = true` blocks the
  purchase server-side (`server/apps/system/clothes.lua`, both save paths).
  Only way in: `exports.esx_inventory:grantLimitedCloth(source, type,
  drawable, texture, label)`, meant to be called from your event/reward
  script.
- **Faction-locked**: `Config.ClothesFactionLock[type][key] = {'police',...}`
  blocks the purchase server-side AND blocks wearing it client-side (job
  re-checked at equip time via `PlayerData.job.name`, so it still applies
  even to something already saved to a character before a job change).
- **"New" tag**: `Config.NewClothes[type][key]` (timestamp or `true`) → a
  green "NEW" ribbon on the item in the inventory grid for
  `Config.NewClothesDays` days.
- **Dynamic color-tinted icon**: since icons are flat 2D images (there's no
  per-garment art for every color), the inventory now applies a CSS
  hue-rotate to the icon derived from the item's actual stored texture/
  color index, so different colors of the same garment visibly look
  different instead of using one static icon for the whole category.
- **Real mugshot instead of a fixed Discord URL**: this already existed in
  the codebase, fully wired, just switched off (`Config.ActiveMugShot =
  false`, with a comment saying it had been turned off on request). Turned
  it back on and made the `MugShotBase64` export call fail-safe (falls
  back to `Config.PictureIdCard` if that resource isn't installed/started,
  instead of erroring).
- ⚠️ Important UX reality check: the clothes **shop** itself
  (`client/apps/system/clothes.lua`) isn't a catalog of named items - it's
  a live RageUI slider over GTA's numeric drawable/texture variation slots
  (browse drawable 0..N, color 0..30, etc). There's no discrete "shop item"
  to put a New/Limited/Faction badge on while browsing. What's implemented
  instead, which is the meaningful/enforceable version of these features
  for this kind of shop: the checks apply at **save time** (when the
  browsed combo gets written to `lc_clothes`/the player's inventory), and
  the rank glow / New badge / color tint show up on the **saved, owned**
  clothing item afterwards.
