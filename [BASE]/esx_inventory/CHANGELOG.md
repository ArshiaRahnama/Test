# Round 8 — Sunset skin + layout fixes
# Round 9 — pickup notification fix + sort button removed
# Round 10 — open animation + background

Three files changed in total. Nothing else in this resource was
touched.

- `src/html/assets/css/sunset.css` — new file (round 8), edited again
  in rounds 9 and 10.
- `src/html/ui.html` — **one `<link>` added**, right before `</head>`,
  after `config.css`. That's the only diff; every line above it is
  original.
- `server/custom/drop/drop.lua` — **one line changed** (round 9). The
  only Lua/JS edit in the whole package.

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
