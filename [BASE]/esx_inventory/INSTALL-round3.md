# Round 3 — install notes

Covers features **#1, #2, #3, #5, #7, #8, #13, #14, #15, #23** plus the
security holes found while reading the code.

---

## 1. Restart order — this one matters

```
restart essentialmode      <-- FIRST
restart esx_inventory      <-- SECOND
```

`esx_inventory` reads the slot layer off the player object. If you
restart it first, every player object still predates the layer and the
grid comes up empty. It prints a loud console line if that happens
rather than silently showing an empty inventory:

```
[esx_inventory/slots] player object has no slot layer — restart essentialmode
```

Safest on a live server: `stop esx_inventory` → `restart essentialmode`
→ `start esx_inventory`.

---

## 2. Database

Nothing to run by hand. `essentialmode/server/migrations.lua` adds the
one new column on boot, guarded by an `INFORMATION_SCHEMA` check, so
it's safe to start repeatedly:

| table   | column     | type              |
|---------|------------|-------------------|
| `users` | `invslots` | `LONGTEXT NULL`   |

`NULL` for every existing player, which the slot layer reads as "no map
yet" and auto-places their whole inventory. **Nobody loses anything on
upgrade** — the first save after they log in writes their real layout.

The three security tables (`inv_weapon_history`, `inv_stolen_weapons`,
`inv_item_notes`) came from round 1's `sql_security.sql`. If you never
ran that file, run it now — #5/#7/#8 need those tables.

---

## 3. New config keys

All have working defaults; set them only if you want different values.

```lua
-- essentialmode/config.lua  (or leave them, slots.lua defines defaults)
Config.InventorySlots    = 50   -- normal grid cells
Config.DefaultStackLimit = 50   -- per-slot cap when items.limit is unset
Config.BackpackSlotStart = 101  -- first cell of the #15 backpack band
Config.BackpackSlots = {        -- extra dedicated cells per pack
    ['backpack'] = 6, ['backpack_medium'] = 12, ['backpack_large'] = 20,
}
```

Per-item stack caps come from the **`items.limit` column you already
have**. `-1`/`0`/`NULL` there means "unset" and falls back to
`Config.DefaultStackLimit`. So you can tune stacking per item with plain
SQL, no config list to maintain:

```sql
UPDATE items SET `limit` = 10 WHERE name = 'lockpick';
```

```lua
-- esx_inventory/config/config.lua
Config.BackpackProps = { ... }  -- #13, prop model + bone offset per pack
Config.BriefcaseBonus = { [1] = 20, [2] = 30, [3] = 0 }  -- see §5
```

---

## 4. New commands

| command      | who      | what |
|--------------|----------|------|
| `/searchbag` | police jobs | #14 — search the nearest player's backpack. Read-only; taking things still goes through `/fouiller`. |

Context menu (right-click an item) gains **Description** (#5),
**History** (#7) and **Report stolen** (#8). History and the stolen
report only appear on weapons that actually have a serial.

---

## 5. ⚠ Breaking change: the `Malette` event is gone

It was an open net event any client could fire to hand itself +2000 kg
of carry capacity — no item check, no job check, no cooldown. It is now
a server-only export:

```lua
-- before (exploitable from any client)
TriggerServerEvent('Malette', 1)

-- after
exports.esx_inventory:grantBriefcase(source, 1)
```

Grep your other resources for `'Malette'` before going live. If nothing
calls it, nothing breaks.

The bonus values also moved from `2000`/`3000` to `20`/`30` — the whole
pack switched to kilograms in an earlier round, so the old numbers were
1000× too large and made the weight cap meaningless anyway.

---

## 6. Other behaviour changes worth knowing

- **`lgd:putToPlayer` now takes a `taking` flag.** The client half is
  already updated. If you have your OWN resource firing that event,
  add `taking = true` when pulling items *from* the other player.
- **Clothing/phone rows can only be deleted or transferred by their
  owner.** If some script of yours was moving `lc_clothes` rows on
  another player's behalf through these events, it will now no-op —
  do it with a direct SQL update instead.
- **Item giving is distance-checked server-side** (`Config.Security
  .transfer.maxDistance`, default 5 m). Set it to `0` to disable if you
  have a legitimate remote-give feature.
- **High-value transfers now actually prompt** (#22 was implemented in
  round 1 but never called). Tune `Config.Security.confirm`.

---

## 7. What the grid does and doesn't own

The grid owns **standard items only**. Weapons, clothing, accounts and
ID cards are rendered after it under an "Equipment" divider and are not
droppable into cells.

That's not laziness — those live in separate server-side stores
(`loadout`, `lc_clothes`, accounts) with no slot concept and nowhere to
persist one. Giving them fake slots would mean a layout that silently
resets on every relog.

**Overflow strip:** if the grid is full, extra items appear greyed out
under a "No free slot" divider. They still exist and still count toward
weight — they just have nowhere to sit. Hiding them would be
indistinguishable from losing them, which is why they're shown.

---

## 8. Test coverage

The slot layer was run against a real Lua interpreter, not just
syntax-checked:

- 20,000 random `move`/`split` calls with deliberately invalid slot
  numbers and counts (negative, out of range, oversized) — totals
  conserved exactly, stack limits never exceeded, nothing escaped into
  an invalid slot.
- 5,000 random gain/lose cycles — `placed + unplaced` always equals the
  real inventory total, no drift.
- Grid-full, backpack-band-on, backpack-band-off — nothing destroyed in
  any transition.
- A player's manual arrangement survives picking items up.

---

## 9. Still not done

| # | why |
|---|-----|
| 4 | Real 3D item preview is not possible with flat PNG icons — needs DUI + a render target + a separate prop model per item. The cursor tilt/parallax already shipped is the honest equivalent. |
| 6 | GTA has no native to write text onto a weapon mesh. Alternative: tint/livery + the serial shown in Inspect and in the #7 history panel. |

Everything else on the 23-item list is in.
