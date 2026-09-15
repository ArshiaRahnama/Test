# evidence merged into esx_uniquejobs

## What this does

Moves the standalone `evidence` resource entirely into `esx_uniquejobs`. Every
evidence file now lives inside `esx_uniquejobs/evidence/` and loads as part of
that one resource, the same way `cad/` and `detective/` already do. There's
nothing left to install separately and nothing left to `ensure` on its own --
delete the old standalone `evidence` folder from your server and remove (or
comment out) `ensure evidence` from `server.cfg` if you had one; its job is
now done by `esx_uniquejobs`.

## Layout

```
esx_uniquejobs/evidence/
  config.lua        -- was evidence/config.lua, global renamed Config -> Config_evidence
  client/main.lua    -- unchanged except the renames below
  server/main.lua    -- unchanged except the DOJ-integration call below
  html/               -- form.html, css.css, script.js, jquery, img/
  install.sql          -- kept as schema documentation only, see below
```

## What changed under the hood

- **`Config` -> `Config_evidence`.** `taximeter/config.lua` already defines a
  global table named `Config` in this resource. Evidence's own `config.lua`
  used the same bare name -- loading both would have made one silently
  overwrite the other (Lua globals are last-write-wins). Renamed every
  `Config.` reference in `client/main.lua` and `server/main.lua` (91
  occurrences) to `Config_evidence.`, matching the `Config_detective` /
  `Config_cs` naming already used by this resource's other modules.
- **`DrawText3D` -> `Evidence_DrawText3D`.** `client/k9/client_editable.lua`
  already defines a *different* global `DrawText3D(x, y, z, text, rect)`,
  used by `client/k9/client.lua`'s tracking hint. Evidence's own
  `DrawText3D(x, y, z, text)` (4 args, no `rect`) would have loaded after K9
  in `fxmanifest.lua` and silently replaced it, breaking K9 tracking.
  Renamed all 13 call sites in `evidence/client/main.lua`.
- **DOJ integration is now a direct call, not an export.** `server/main.lua`
  used to reach across resources with
  `exports['esx_uniquejobs']:CreateExternalCase(...)`, gated behind
  `GetResourceState("esx_uniquejobs") == "started"`. Now that it *is*
  esx_uniquejobs, it calls `CreateExternalCase(...)` directly as the plain
  global function `server/doj_cases.lua` already defines -- no export
  round-trip, and the "is it running?" check is gone since that's no longer
  a meaningful question. `evidence/server/main.lua` is listed after
  `server/doj_cases.lua` in `fxmanifest.lua`'s `server_scripts` for clarity,
  though load order only matters here in that `CreateExternalCase` must
  exist by the time a report is actually filed at runtime, not at parse time.
- **`evidence_storage` table + the `uvlight` item are now self-healing.**
  Both used to require running `evidence/install.sql` by hand. Added
  `evidence_storage` (same schema) to `server/db_migrations.lua`'s
  `CREATE TABLE IF NOT EXISTS` list, and the `uvlight` items row as an
  idempotent `REPLACE INTO` right after it -- same "no manual SQL" guarantee
  this resource already gives every other table. `install.sql` is kept only
  as human-readable schema documentation, exactly like this resource's other
  `*.sql` files.
- **NUI merged into the shared `ui.html`.** Evidence used to be its own
  `ui_page 'html/form.html'`. `esx_uniquejobs` can only have one `ui_page`
  (`ui.html`), which already relays messages to five other NUI apps via
  iframes (see the comment at the top of `ui.html`). Added a sixth:
  `#frame_evidence` pointing at `evidence/html/form.html`. It's permanently
  `pointer-events: none`, same as the bodydamage HUD and taximeter meter --
  evidence's own `#main_container` is `display:none` until a report is
  shown, and even then `evidence/client/main.lua` never calls `SetNuiFocus`
  (closing is BACKSPACE/ESC only), so its on-screen close button was never
  actually mouse-reachable to begin with; nothing needed to change there.
  Evidence's own NUI callback route (`/closeReport`, via
  `GetParentResourceName()`) already targets the resource dynamically, so it
  keeps working unchanged now that the resource is `esx_uniquejobs` instead
  of `evidence`.
- I checked every global name evidence defines (`DrawText3D`,
  `SendTextMessage`, `StartAnalysis`, `GenerateReport`, `OpenArchive`,
  `OpenArchiveEntry`, `getWeaponName`, the `SetIgnoreBullets` export, the
  `/evidencetest` and `/evidencecoords` commands, every `evidence:*`
  event) against the rest of `esx_uniquejobs` before merging -- `DrawText3D`
  was the only real collision (fixed above); nothing else in your job script
  is affected.

## Nothing else changed

The evidence gameplay loop itself (flashlight-only reveal, UV Light
fingerprints, analysis desk, archive, DOJ case + CAD wanted-level push,
`/evidencetest` debug flow) is byte-for-byte the same logic as before, just
relocated. `Config_evidence.Debug = true` still ships on -- turn it off
before this goes live, same as always.

All touched/added files syntax-checked clean with `luac5.4 -p`.
