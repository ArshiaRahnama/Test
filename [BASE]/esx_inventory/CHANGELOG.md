# Round 8  — Sunset skin + layout fixes
# Round 9  — pickup notification fix + sort button removed
# Round 10 — open animation + background
# Round 11 — fixed a bug round 10 itself introduced
# Round 12 — client crash: `PlayerData.job = job` unguarded
# Round 13 — client crash: `TriggerServerCallback` not defined yet
# Round 14 — Equipment label hidden, empty ground title hidden,
#            right-click menu now closes with the inventory

Five files changed in total. Nothing else in this resource was
touched.

- `src/html/assets/css/sunset.css` — new file (round 8), edited again
  in rounds 9, 10, 11 and 14.
- `src/html/ui.html` — **one `<link>` added**, right before `</head>`,
  after `config.css`. That's the only diff; every line above it is
  original.
- `src/html/assets/js/inventory.js` — **one line added** (round 14,
  see below).
- `server/custom/drop/drop.lua` — **one line changed** (round 9).
- `client/custom/framework/esx.lua` — edited twice: round 12 (one
  event handler), round 13 (four function definitions moved and
  hardened).

## Round 14

**1. "EQUIPMENT" divider hidden.** `grid.js` gives three different band
dividers the exact same `.grid-band-label` class - "Backpack",
"Equipment" (weapons/clothes/accounts/cards with no normal slot
number), and an overflow warning - distinguishable only by which
FontAwesome icon each one carries. Targeted the Equipment one
specifically with `.grid-band-label:has(.fa-layer-group)`, so
"Backpack" still marks where backpack slots start and the overflow
warning - deliberately never hidden anywhere in this file, per
grid.js's own comment: an invisible-but-still-owned item looks exactly
like item loss - is untouched. The items themselves are unaffected,
they just no longer sit under a heading.

**2. "ON THE GROUND" title hidden when there's nothing there.** `#plate`
is a shared title slot - ground items, a trunk, a stash, a property, a
corpse all put their own text in the same element. `renderGround()`
(ground.js) is the only one of them that can leave `#right-inventory`
holding just a single `.ground-empty` ("Nothing nearby") message with
nothing else in it; every other panel type pads empty slots with blank
grid cells instead, so they always have real contents to title.
`#right-part:has(+ #right-inventory > .ground-empty:only-child)` hides
the title (and its empty weight bar) in exactly that one state - the
title reappears the moment an item is actually lying there, and
nothing else that uses this same slot is affected.

**3. Right-click item menu now closes with the inventory.**
`#itemContextMenu` is a sibling of `.form-inv` in `ui.html`, not a
child of it - appended straight to `<body>` so its own stacking order
never gets clipped by whichever panel it was opened over. That also
meant `.form-inv`'s own `display:none` on close never reached it:
right-click an item, then close the inventory (Esc, walking away,
anything that fires `close:Inv`) before picking a menu option, and the
menu was left floating over the game world with nothing open to attach
it to - reported screenshot showed exactly that, third-person view
with the menu still up. `close:Inv`'s handler in `inventory.js` now
also runs `$('#itemContextMenu').removeClass('visible')` - the exact
same call the menu's own "pick an option" / "click elsewhere" paths
already use, just wired into the inventory's own close as well.


## Round 12 — `SCRIPT ERROR: attempt to index a nil value (global 'PlayerData')`

**Symptom reported:** repeated console error at
`client/custom/framework/esx.lua:36`.

**Cause.** The `esx:setJob` handler wrote `PlayerData.job = job`
unconditionally. `PlayerData` is a plain global, set once by
`esx:playerLoaded` on login and re-seeded by this same file's own
`onClientResourceStart` handler after a resource restart - but neither
of those is guaranteed to have run yet by the time `esx:setJob` fires.
In particular: restarting `esx_inventory` alone (`restart
esx_inventory`, a crash-and-auto-restart, a resource update) while a
player stays connected resets the `PlayerData` local to `nil`, and
`esx:playerLoaded` is not re-triggered just because one resource
restarted - it fires on login. If a job change arrives in that window,
`PlayerData` is still `nil` and indexing `.job` on it throws exactly
the reported error.

This file already had a large fix for a related restart scenario (the
`onClientResourceStart` block below, itself documented inline) - this
was the one call site that fix didn't cover, because it targets a
*different* trigger (`esx:setJob`, an event) rather than the resource
starting.

**Fix.** Before assigning, the handler now checks whether `PlayerData`
is still unset and, if so, tries to recover it immediately via
`ESX.GetPlayerData()` - the exact same recovery call the
`onClientResourceStart` thread a few lines below already trusts -
`pcall`-wrapped so a still-not-ready `ESX` object can't throw a second
error here. Only then does it write `.job`, and only if `PlayerData`
resolved to something. A job change arriving in the gap now lands
instead of either crashing or silently vanishing.

**Audited, not just this one line:** every `PlayerData.` access in the
whole client codebase was greped and checked. `client/main.lua`'s
`money.cash` and `charinfo.*` accesses are unguarded too, but both sit
inside `elseif Config.Framework == "qb" then` branches - dead code on
an ESX server (`Config.Framework == "esx"` here), so left untouched;
`client/apps/system/loot.lua` and `client/apps/system/slot.lua` were
already guarded (`PlayerData and PlayerData.job and ...` /
`if PlayerData and PlayerData.loadout then`) before this round. This
was the one live, unguarded call site.

## Round 13 — `SCRIPT ERROR: attempt to call a nil value (global 'TriggerServerCallback')`

**Symptom reported:** console error at `client/main.lua:623`
(`loadPlayerInventory`), reached from `openInventory` (line 23),
reached from a bound command (`ref`, line 226) - i.e. the player
pressed the `inventory` key (F2) and the call chain hit a function
that didn't exist.

**Cause - same family as round 12, different call site.** This
server's config is `Config.esxVersion = 'old'` (essentialmode).
`TriggerServerCallback`, `GetPlayerIdentifier`, `GetClosestPlayer` and
`GetClosestVehicle` were all defined *after* the ESX-resolution block:

```lua
elseif Config.esxVersion == 'old' then
    ESX = nil
    while not ESX do
        TriggerEvent(Config.Trigger["getSharedObject"], function(obj) ESX = obj end)
        Wait(500)
    end
end
-- TriggerServerCallback etc. were defined down here
```

That `while` loop *blocks this file's own execution* until
essentialmode responds to the handshake - nothing after it runs until
it does. But `client/main.lua` doesn't wait for any of that: it
registers the `inventory` command (bound to F2) on its own top-level
run, which happens independently and can be triggered by the player
the instant the resource has started. Press F2 in the first second or
two after connecting - or right after a `restart esx_inventory` /
`restart essentialmode` sequence, before the handshake finishes - and
the game calls straight into a global function that this file hasn't
reached the definition of yet. A nil-check *inside* the function
wouldn't help; the function itself didn't exist to be called into.

**Fix.** All four functions now get defined unconditionally at the top
of the file, before ESX resolution even starts, so the globals always
exist from the resource's very first tick. Each one internally waits
(bounded to 10s, the same budget the file already uses elsewhere) for
`ESX` to actually be ready before touching it - so a call arriving
during that startup window now waits briefly and then proceeds
normally, instead of crashing. A call arriving any time after start-up
behaves exactly as it always did: same function bodies, just moved
earlier and made patient about the one dependency they have.

15 other client files call one or more of these four functions
(`client/main.lua`, every `client/apps/*` module, `client/custom/backpack`,
`client/custom/drop`, `client/custom/slots`) - all of them were
exposed to the identical race before this fix and are all covered by
it now, not just the specific call site in the report.

## Round 11 — fixing round 10

Round 10's open animation broke the layout: the left panel (header,
search, grid) landed on top of the centre column and the ped instead
of sitting at the left edge of the screen.

**Root cause.** `.inventory` is centred by ui.css with
`left:51%; transform:translate(-50%,-50%)`, and `.center-part` is
centred by middle.css the same way with
`left:50%; transform:translate(-74%,-50%)`. Round 10 added an open
animation to both elements that also set `transform` (a
`translateY()+scale()` for the rise-in motion). A CSS `animation`
**replaces** the whole `transform` property rather than adding to
whatever was already there — it doesn't know or care that
`translate(-50%,-50%)` was doing load-bearing centring work. With
`animation-fill-mode: both`, that replacement doesn't end when the
0.34s animation finishes either: it's held for as long as `.visible`
is set, i.e. the entire time the inventory is open. Both elements lost
their centring transform completely and rendered from their raw
`left:` corner instead, which is why everything ended up shifted right
and stacked on the ped.

**Fix.** `.inventory` and `.center-part` now get their own dedicated
keyframes (`sunOpenInventory`, `sunOpenCenterCol`) with the original
centring translate baked into every frame — `from` and `to` both start
with `translate(-50%,-50%)` / `translate(-74%,-50%)` before the
animation's own `translateY()+scale()`. The three elements that never
had a base transform to begin with (`.categorys`,
`.loading-bar-kg-left-part`, `#right-part`) keep using the simple
shared keyframe (`sunOpenPanels`) — they were never affected by this,
this round only touches the two that were.

If a future custom animation gets added to any element in this file:
**check what `transform` that element already carries elsewhere in the
cascade first** (`grep -n transform` across the other CSS files for
that selector). Animating `transform` on an element that's already
positioned with a static `transform` will silently eat that
positioning the same way — this class of bug doesn't throw an error,
it just looks like everything moved for no reason.

## Round 10

1. **Background.** The whole screen behind the UI was one uniform
   `rgba(10,10,10,0.55)` wash — the corners nobody looks at were just
   as dark as the centre, where the ped and both panels actually sit.
   Replaced with a vignette anchored to the same point `.inventory`
   itself is anchored to (50% / 46%): lighter over the panels, darker
   toward the edges, plus one soft warm glow high and centred — the
   one accent colour back there, a nod to "Sunset" without turning the
   backdrop into a second design element. Still no `backdrop-filter`:
   the game already blurs the world behind this UI.

2. **Open sequence.** The old motion was a single flat fade+scale on
   the entire `.form-inv` — background, panels, ped and hud all
   arriving as one rigid block. The backdrop's own scale is
   neutralised now (it only fades — it's the stage, not part of the
   move); the arrival moved to the content instead: both grids rise
   into place on an ease-out-expo curve, the centre column (ped +
   action buttons) follows ~50ms behind so it reads as the panels
   closing in around the player rather than everything landing at
   once. `.inventory.loot-opening` (corpses/loot containers) keeps its
   own existing lid-pop flourish untouched — excluded with `:not()`
   rather than overridden. `prefers-reduced-motion` disables all of
   it, same as every other animation in this file.

## Round 9

1. **Wrong notification text on a failed ground pickup.**
   `server/custom/drop/drop.lua`, the `esx_inventory:pickupDrop`
   handler: when the picking-up player's own inventory has no room,
   it showed the locale key `give_error_weight` — *"The person's
   inventory is full"* — which describes someone ELSE's inventory
   being full. That's the correct message for the GIVE flow
   (`server/main.lua`, unchanged), but backwards here: this is the
   player's own pocket, not another player's. Every sibling call site
   that checks `getWeight()` for a self-pickup — `property.lua`,
   `corpse.lua`, `glovebox.lua`, `stash.lua` — already used
   `trunk_weight_player_max`, *"You have no more space on you"*, for
   exactly this situation; `drop.lua` was the one that hadn't been
   brought in line. Fixed to match its siblings. No locale file
   changed — the key already existed and is already translated
   wherever `locales.lua` has a language block.

2. **The "Name" sort button next to search, removed.**
   `.sort-one { display: none !important; }` in `sunset.css`. The
   sort feature itself (`grid.js`) is untouched — this only hides the
   button, so deleting that one rule brings it back if it's ever
   wanted. The search box now fills the row it used to share
   (`.item-search-box { width: 100% !important; }`), matching
   Sunset's own reference screenshots, which show a bare search box
   with nothing beside it.

## Revert

Delete the `sunset.css` `<link>` from `ui.html` (or delete the file)
and the UI returns to exactly what it was before this round.

## What this fixes

1. **Right panel header floated 3.17vw off from its own panel.**
   `#right-part` was positioned with `float:left; left: 34.375vw`,
   while `#right-inventory` is `float:right`. A left-anchored box and a
   right-anchored box have no reason to line up, and didn't — that's
   the "ON THE GROUND" title hanging off the side of the panel in the
   original bug report. Fixed by taking `#right-part` out of the float
   flow and anchoring it to the *same* right edge `#right-inventory`
   uses (`position: absolute; right: 0.15vw`), so the two can't
   disagree anymore.

2. **Bottom row of both grids sliced in half.** The panel height was a
   hard `27.2vw`/`27.9vw` against a row pitch (cell + gap) that didn't
   divide into it evenly. Fixed by deriving cell size *and* panel
   height from one set of CSS custom properties (`--inv-cell`,
   `--inv-grid-h` in `sunset.css`), so the panel is a whole number of
   rows by construction. Change `--inv-rows` and it still lands clean.

3. **`.item-info:hover` never fired inside the grid.** The base cell
   rule in `v4.css`/`grid.css` is ID-qualified
   (`#left-inventory .item-info[data-slot]`), which has higher CSS
   specificity than a bare `.item-info:hover`. The hover rule was
   silently losing every time inside `#left-inventory`. Fixed by
   listing the ID-qualified hover selectors explicitly.

## What changed visually

Reskinned to match the Sunset/esx_inventoryhud look: flat two-stop
gradient cells (`--sun-cell-1` / `--sun-cell-2` in `sunset.css`,
recolour the whole UI from those two lines), item names as plain
centred text instead of a dark strip, stack count bottom-right, a
hairline quality bar instead of a coloured halo, bare headers with
small-caps names, and a flat square weight bar. Full rationale for
every rule is in the comments inside `sunset.css`.

## Known limits, on purpose

- Clothing-slot column position (left/right of the ped) was **not**
  moved — those slots are aligned to where the game renders the
  character model, so shifting them would put empty boxes over the
  ped.
- Per-item weight tags are hidden in the grid (`.item-weight-tag {
  display: none }`) because Sunset doesn't show them. Delete that one
  rule in `sunset.css` to bring them back; the positioning is still
  correct underneath.
- `getPercentage`-style divide-by-zero (a `0 kg` max weight producing
  a full bar) is an **esx_inventoryhud (Vue) bug**, not an
  `esx_inventory` bug — this resource's own `setWeightBar()` already
  guards `maxWeight > 0`, so it doesn't apply here. Flagging it in
  case the same server also runs the Vue-based hud.
