# Discord bridge (/doj, /law, /cad  <->  Unique_Phone)

Everything here is optional: if `Unique_Phone` is not started, all of it silently does nothing.
Settings: `shared/discord_bridge_config.lua`. Code: `server/discord_bridge.lua`, `client/discord_bridge_menu.lua`,
plus small hooks in `doj_manager.lua`, `court_docket.lua`, `panic_manager.lua`, `cad/server/main.lua`.
Phone side: `Unique_Phone/server/discord_ext3.lua` (exports) and `sql/discord_v8.sql`.

## Court hearings (/doj -> Court docket)
Scheduling, rescheduling, cancelling and recording a verdict post a message into the **judge** official server,
channel `#court-docket` (read-only, created automatically). Defendants, the case opener, the lead officer and
online judges also get a Discord toast + a chat line. A reminder goes out 10 minutes before and at the start.

## Search warrants
* Police / sheriff / MT (and cid / fbi / cia) request a **search** warrant: `/law -> Hokm-e Bazresi & Discord`.
  It appears for the judge / marshal (grade 18+) under `/doj -> Hokm-ha`, exactly like DOJ-made warrants.
* Approve / deny / revoke is announced in `#court-docket` and in the requesting department's `#warrants`.
* An approved warrant is valid `WarrantTTLMinutes` (default 180) and can be used `MaxExportsPerWarrant` times.
  Warrants live in memory (existing design), so a restart clears them.

## Exporting chats as evidence
`/law -> Hokm-e Bazresi & Discord -> Estekhraj-e Chat-haye Discord` (or a case in `/doj -> Madarek-e Discord`):
pick an approved warrant and a case (or a new one). The suspect's non-announcement messages from the last
`Config.DiscordExt.Gov.ExportDays` days (max `ExportMaxMessages`) are copied into the case:
* a summary line becomes an `evidence` note (so evidence custody / transfer works on it),
* the full transcript is stored in `dept_discord_evidence` (readable by DOJ jobs and by the officer who exported it),
* a checksum is stored with it, and the export is written to the phone's staff audit + `phone_discord_evidence_log`,
* a content-free line ("export under warrant #N by X") is posted to `#court-docket` and the department `#warrants`.
The suspect is not notified.

## CAD
Wanted-level changes made in the CAD, and panic / backup requests, are mirrored into every LE department's
`#dispatch` channel.
