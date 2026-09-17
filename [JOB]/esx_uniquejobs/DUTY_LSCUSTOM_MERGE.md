# esx_duty and esx_lscustom merged into esx_uniquejobs

Both standalone resources are gone -- delete them from your server and
remove any `ensure esx_duty` / `ensure esx_lscustom` lines from
`server.cfg` if you had them (none were found in this repo's own
`[BASE]/server.cfg`, and nothing else in the repo referenced either
resource by name, so this should be a clean drop-in).

## Layout

```
esx_uniquejobs/duty/
  config.lua        -- was esx_duty/config.lua, global renamed Config -> Config_duty
  client/main.lua
  server/main.lua
  db.sql             -- kept only for schema reference, see below

esx_uniquejobs/lscustom/
  config.lua        -- was esx_lscustom/config.lua, global renamed Config -> Config_lscustom
  client/main.lua
  client/colorPicker.lua
  server/main.lua
  locales/en.lua
  html/              -- index.html, style.css, colorpicker.js
```

## duty/ -- what changed

- **`Config` -> `Config_duty`.** `taximeter/config.lua` already owns the bare
  `Config` name in this resource (same reasoning as every other merge here).
- **Real bug: undefined variables in the AFK-kick Discord webhook.**
  `playerID`, `steamIdentifier`, `steamName`, `playerName`, `timestamp`, and
  `unixTime` were referenced inside the AFK-timeout auto-off-duty
  `PerformHttpRequest` call but never defined anywhere in that scope -- every
  AFK-triggered off-duty webhook posted `nil` for all six fields to Discord.
  Now computed properly (same as the manual `esx_duty:setjob` handler right
  above it already does).
- **Real bug: `lastPlayerPosition[source]` losing its index.** One line read
  `lastPlayerPosition = GetEntityCoords(GetPlayerPed(source))` -- no
  `[source]`, so it replaced the *entire* per-player position-tracking table
  with a single player's raw vector3. Every other player's (and that same
  player's, next cycle) `lastPlayerPosition[source]` lookup then came back
  nil, which fell through to the "just moved" branch and reset their AFK
  timer to 0 -- meaning the 15-minute AFK auto-off-duty essentially never
  actually fired for anyone. Fixed to `lastPlayerPosition[source] = ...`.
- **Dead code removed**: `esx_duty:setjob2` was triggered from the client in
  two places; grepped the entire repo, no server (or any) handler for it
  exists anywhere -- pure no-op. Removed both call sites.
- **De-duplicated a 33-job hardcoded OR-chain** (`zone == "police" or zone
  == "ambulance" or ...`, covering every esx_uniquejobs department plus 21
  jobs from the separate `uniquecafejobs` resource) that appeared twice --
  once client-side (`hasEnteredMarker`), once server-side (the 5-minute
  AFK-logging loop). Both now just check `Config_duty.Zones[zone]` /
  `Config_duty.Zones[JobName]` -- the same table that already has to list
  every one of these jobs to place their duty-toggle markers in the first
  place, so it can't drift from that list again, and a new zone added there
  automatically works in both places.
- `db.sql` is kept only as schema documentation (like every other `*.sql` in
  this resource) -- `duty_logs` isn't a table this resource's
  self-healing migrations create today (unlike `evidence_storage` etc. from
  the evidence merge); this one still needs a one-time manual import on a
  fresh install if you don't already have the table from running the
  standalone esx_duty before. Said so explicitly since it's a behavior gap
  worth knowing about, not silently glossed over.

## lscustom/ -- what changed

- **`Config` -> `Config_lscustom`.** Same reasoning as `duty/` above.
- **Real bug: missing `local` on `xPlayer`** in the `PayVehicleOrders`
  server callback -- was leaking a global that any concurrent call to the
  same callback (from a different player) could stomp on mid-flight. Added
  `local`.
- **Real, resource-merge-specific bug: two resources both overwriting the
  same locale table.** `lscustom/locales/en.lua` did `Locales['en'] = {
  ... }` -- a full table overwrite. `taximeter/shared/locales/en.lua`
  (already part of this resource) does the exact same thing to the exact
  same bare `'en'` key. Merged into one resource, whichever loaded last
  would have completely wiped out the other's translations. Checked for
  key-name overlap between the two first (zero -- 16 taximeter keys, 244
  lscustom keys, no shared names), then switched lscustom's file to the same
  additive-merge pattern esx_uniquejobs' own department locale files already
  use (`Locales['en'] = Locales['en'] or {}` + a `for k,v in pairs(...) do
  Locales['en'][k] = v end` loop) instead of a flat overwrite.
- **Real, more serious bug found while merging: `lscustom/html/index.html`'s
  message handler.** It was `if (this[item.type]) { this[item.type](item);
  }` -- on receiving any postMessage, call whatever global JS function is
  named exactly like the message's `type` field. Harmless as long as
  nothing else could ever message this iframe, which was true when it was
  its own standalone `ui_page` -- but merged into the shared `ui.html`
  (`GOVERNMENT_JOBS_CONSOLIDATION.md` and the evidence merge cover why:
  every merged app's `SendNuiMessage` gets broadcast to *every* iframe, each
  one responsible for ignoring what isn't its own), this iframe now also
  receives every message cad/doj/detective/evidence/radar/bodydamage/
  taximeter send -- so any of their `type` values happening to match a
  reachable global function name would have called it. Whitelisted to
  the exact three types this file's own `colorpicker.js` actually defines
  (`ON_SHOW`, `ON_COLOR_CHANGED`, `ON_HIGHLIGHT` -- checked against the
  actual `function ON_...` definitions there) instead of the open pattern.
- Confirmed safe to merge as a **permanently click-through** iframe (no
  `SetNuiFocus` anywhere in `client/colorPicker.lua` -- the whole picker is
  D-pad/controller-driven via `IncrementFocus()`/`DecrementFocus()` bound to
  controls 174/175, never mouse-driven, and its `#container` starts
  `display:none` besides), same as evidence's report and the bodydamage/
  taximeter overlays.
- Checked every global name both `duty/` and `lscustom/` define (functions,
  top-level variables) against the rest of esx_uniquejobs, and against each
  other -- zero collisions found, nothing else needed renaming.
- Dropped the redundant `'@mysql-async/lib/MySQL.lua'` require from the
  merge -- esx_uniquejobs already loads `'@oxmysql/lib/MySQL.lua'` (which
  provides the same `MySQL.Async`/`MySQL.Sync` compatibility surface) once,
  resource-wide.

## Not touched, flagged for you

While tracing how `_U()` resolves strings for this merge's locale work, I
noticed esx_uniquejobs' own existing department locale files (e.g.
`locales/fbi_en.lua`) write into `Locales['en_fbi']`, but `_U()`/`_()`
(`@essentialmode/locale.lua`) only ever read `Locales['en']` (hardcoded,
not namespaced). That looks like it could mean those namespaced keys are
never actually reachable through `_U()`. This predates today's merge
entirely and isn't something either `esx_duty` or `esx_lscustom` touches --
flagging it here since I found it in the course of this work, not fixing it
now since it's a separate, potentially resource-wide investigation of its
own.

All touched/added Lua files syntax-checked clean with `luac5.4 -p`; both JS
files (`colorpicker.js` and `index.html`'s inline script) checked clean
with `node --check`. A full resource-wide re-sweep afterward still shows
only the same 2 pre-existing K9 files failing (untouched by any of this).
