# Round 8 — Sunset skin + layout fixes

Two files changed. Nothing else in this resource was touched — no Lua,
no JS.

- `src/html/assets/css/sunset.css` — **new file.**
- `src/html/ui.html` — **one `<link>` added**, right before `</head>`,
  after `config.css`. That's the only diff; every line above it is
  original.

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
