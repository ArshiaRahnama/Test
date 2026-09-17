# Government job checks consolidated into shared/departments.lua

## What this was

"Is this player's job DOJ?" / "...LE?" / "...government at all?" used to be
re-answered independently in ~20 different places across client/, server/,
and cad/ -- either as its own local hardcoded table:

```lua
local DOJ_JOBS = { marshal = true, judge = true, cia = true, cid = true, fbi = true, doa = true }
```

(verbatim, in 9 separate files), or as an inline
`job.name == "police" or job.name == "sheriff" or ... or job.name == "doa"`
chain (11 more places). Nothing forced these copies to stay in sync with
each other, or with the one real definition of what DOJ/LE actually are
(`Departments` in `shared/departments.lua`, already used to build the
`/doj` and `/law` menus themselves).

## What actually went wrong because of that

- **`server/marshal_main.lua`'s `esx_marshaljob:requestrelease`** (the
  handler behind the "Shoma Nemitavanid Dast Band Organ Nezami Ra Baz
  Konid" message) had its own copy of the government-job list that was
  missing `cid`/`judge`/`doa` -- ones the near-identical
  `server/police_main.lua` copy of the exact same feature *did* have. A
  CID, judge, or DOA officer standing next to a cuffed suspect could
  release them through the police menu's uncuff flow but not through
  marshal's. Both now read `IsGovernmentJob(xPlayer.job.name)`, so they
  can't drift apart again. The `xPlayer.gang.name ~= "nogang"` clause next
  to it (lets a gang member release their own) is untouched -- that's
  separate, deliberate logic, not a job-list bug.
- Several of the copies (both `requestrelease` handlers included) checked
  against a job named `'forces'` that doesn't exist anywhere in
  `Departments` -- dead weight from before this resource's jobs were
  renamed/consolidated. Gone now, since it's simply not in the real list.
- **Update (this pass):** `esx_cia_job:requestrelease` / `esx_fbi_job:requestrelease`
  (in `server/cia_main.lua` / `server/fbi_main.lua`) were own-job-only.
  Per your call to connect these more rather than restrict them, opened up to
  `IsGovernmentJob()` too, matching police/sheriff/mt/marshal -- releasing a
  cuffed suspect now works the same everywhere, no matter which department's
  menu you do it from.
- **New bugs found in this pass -- real missing-job-check holes, worse than
  the `requestrelease` one above:** `esx_policejob:drag` / `putInVehicle` /
  `OutVehicle` and their `esx_marshaljob:` twins had **no job check at
  all**. Any connected player, any job, could drag a cuffed player around
  or shove them into/out of a vehicle just by knowing the event name. All 6
  now require `IsGovernmentJob(source's job)` first, same pattern as
  everything else here.
- **Not fixed, flagged for a decision:** `esx_policejob:SetCuffStatus` /
  `esx_marshaljob:SetCuffStatus` trust whatever `status` value the calling
  client sends, with no job check and no server-side proof a release
  actually happened -- a cuffed player can call
  `TriggerServerEvent('esx_..job:SetCuffStatus', false)` directly and
  self-uncuff, skipping the officer entirely. This is stock ESX
  `esx_policejob` design (both department copies inherited it), not
  something this pass introduced. Left alone because a real fix means
  restructuring how a release gets authorized server-side -- bigger and
  riskier than the drop-in job checks above. Want me to take that on next?

## What changed (pure de-duplication, zero behavior change except the two fixes above)

Added to `shared/departments.lua`, computed once from the existing
`Departments` table: `DojJobSet`, `LeJobSet`, `GovernmentJobSet` (DOJ + LE),
`ResponderJobs` (LE + fbi + marshal, for robbery response), and three
lookup functions `IsDojJob(job)` / `IsLeJob(job)` / `IsGovernmentJob(job)`.
Every file below now reads from these instead of its own copy:

- **DOJ_JOBS -> `DojJobSet`**: `server/case_timeline.lua`,
  `server/stats_dashboard.lua`, `server/evidence_custody.lua`,
  `server/officer_performance.lua`, `server/doj_manager.lua`,
  `server/doj_cases.lua`, `server/court_docket.lua`,
  `client/court_docket_menu.lua`, `client/doj_menu.lua`.
- **LE_JOBS -> `LeJobSet`**: `server/mugshot_manager.lua`,
  `server/stats_dashboard.lua`, `server/traffic_stop_manager.lua`,
  `server/officer_performance.lua`, `client/law_menu.lua`.
- **AGENT_JOBS -> `AgentJobs`** (this one already existed shared, just
  wasn't used): `server/wiretap_manager.lua`, `server/agent_speact.lua`.
- **RESPONDER_JOBS -> `ResponderJobs`**: `server/rob_manager.lua` and
  `client/rob_manager.lua` were two independent hardcoded copies of the
  same table; now one shared definition.
- **ALLOWED_CAD_JOBS -> `GovernmentJobSet`**: `cad/server/main.lua`.
- **Inline OR-chains -> `IsDojJob()`**: `client/teleport_taxi.lua`,
  `client/teleport_ambulance.lua`, `client/teleport_mechanic.lua`,
  `client/teleport_weazel.lua` (each kept its own job in the `or`, only the
  DOJ part was replaced -- these were never LE-accessible and still aren't).
- **Inline OR-chains -> `IsGovernmentJob()`**: `client/teleport_police.lua`
  (both spots), `cad/client/main.lua` (both spots, `DuckMdt.PoliceJob`
  check kept separate since that's its own config value, not a department),
  `client/police_main.lua` (both spots), `server/police_main.lua` and
  `server/marshal_main.lua`'s `requestrelease` handlers (see the bug fix
  above).

All 27 touched files (plus `shared/departments.lua` itself) syntax-checked
clean with `luac5.4 -p`. No file was moved, no `fxmanifest.lua` change was
needed -- every edit was in place.

## Round 2: cross-department event-name collisions (the big one)

Every department main file was originally built by copying another
department's `client/*_main.lua` + `server/*_main.lua` as a template. The
`esx_<job>job:`-prefixed gameplay events were properly renamed per
department when that happened -- but 26 lower-level logging/webhook events
were NOT, and still shared their literal event name with the department they
were copied from:

- **police copied from marshal**: `PdBillingWebhook`, `PdJailWebhook`,
  `esx:requestarrestpd`, `logpdBuyItem`, `logpdBuyWeapon`, `logpdGetItem`,
  `logpdGetWeapon`, `logpdPutItem`, `logpdPutWeapon`, `logpdVehicleSpawn`
  (10 events) -- registered by BOTH `server/police_main.lua` AND
  `server/marshal_main.lua` under the exact same name.
- **doa and judge copied from sheriff**: `ShBillingWebhook`,
  `ShJailWebhook`, `logshBuyItem`, `logshBuyWeapon`, `logshGetItem`,
  `logshGetWeapon`, `logshPutItem`, `logshPutWeapon`, `logshVehicleSpawn`
  (9 events) -- registered by THREE files (`server/sheriff_main.lua`,
  `server/doa_main.lua`, `server/judge_main.lua`) under the same name.
- **cid copied from mt**: `logMTBuyItem`, `logMTBuyWeapon`, `logMTGetItem`,
  `logMTGetWeapon`, `logMTPutItem`, `logMTPutWeapon`, `logMTVehicleSpawn`
  (7 events) -- registered by both `server/cid_main.lua` and
  `server/mt_main.lua`.

**Why this actually mattered, not just untidy naming**: FiveM calls every
handler bound to an event name, regardless of which resource/file
registered it. So every single time e.g. a police officer bought an item,
`TriggerServerEvent('logpdBuyItem', ...)` fired BOTH police's own handler
*and* marshal's -- posting a second, mislabeled Discord log entry (using
police's data but marshal's embed labels) into whichever channel marshal's
copy was configured to post to. Same for every other one of the 26 -- every
department's jailing, billing, and inventory logging was silently
double-logged into a sibling department's channel with the wrong labels.
Confirmed concretely for the jail webhooks: `server/police_main.lua` and
`server/marshal_main.lua`'s `PdJailWebhook` handlers were textually
identical except the embed said "Police ID"/"Marshal ID" respectively --
so a real police jailing produced two Discord messages, one correctly
labeled and one saying "Marshal ID" with the officer's actual (police) name
and hex next to it.

**Fix**: kept the "owner" department's name (`police`/`sheriff`/`mt`, the
one whose abbreviation is literally in the shared name -- Pd/Sh/MT) and
renamed the copied-from department's version in both its `client/*` and
`server/*` file: `Marshal*`, `Doa*`/`Judge*`, `logCID*` respectively. 113
occurrences renamed across 8 files (both registration and every
`TriggerServerEvent` call site). Re-scanned afterward: zero
`RegisterServerEvent` names now shared across any two department files.
All 8 touched files syntax-checked clean.

**Found but deliberately not touched -- a server.cfg / Discord config
question, not a code bug**: several of these (and other, non-duplicate-named
webhook calls elsewhere in the same files) read Discord webhook URLs from a
convar that names a *different* department than the file it's in --
e.g. `server/police_main.lua` never reads a `unique_police_main_*` convar
at all, only `unique_marshal_main_*` ones (same for sheriff/judge all only
reading `unique_doa_main_*`, and `mt_main.lua` only reading
`unique_cid_main_*`). This might be fully intentional (one shared
Discord channel per convar slot, deliberately), or it might mean
police/sheriff/mt have never actually had their own separate log channel.
I can't tell which from the code alone -- didn't want to guess and either
silently break logging (by pointing it at a convar you haven't set) or
leave a real misconfiguration in place without flagging it. Let me know
which it is and I'll wire up department-specific convars if you want them.

## Round 2 also: arrests from every department now update the rap sheet

`server/records_manager.lua`'s `LogCriminalRecord(...)` (rap sheet entries,
and the arrest counts `server/officer_performance.lua` and the CAD
leaderboard read) was previously only ever called from
`server/cid_main.lua`'s own `CidJailWebhook`. Every other department's jail
webhook handler (`PdJailWebhook`, `MarshalJailWebhook`, `ShJailWebhook`,
`DoaJailWebhook`, `JudgeJailWebhook`, `MtJailWebhook`) already computed
everything `LogCriminalRecord` needs (target identifier, reason, officer
name/identifier, jail time) but never called it -- so an arrest made by
police, marshal, sheriff, doa, judge, or mt never showed up on the suspect's
rap sheet or the arresting officer's performance stats, only a CID arrest
did. Added the same `LogCriminalRecord('arrest', ...)` call to all 6,
mirroring CID's own pattern exactly. (FBI and CIA don't have a jail
mechanism at all -- they investigate and hand off rather than book -- so
there's nothing to hook there.)

## Round 3: how CAD's "Cases" tabs actually work (answering a direct question)

CAD's 📂 Cases / ❄️ Cold Cases / 🎯 Wanted Board tabs (the ones that show up
for DOJ jobs, `cad/html/app.js` line 223's `isDoj` check) are **not** the
same thing as the real `/doj` menu's case system, even though they look
like it. Here's the actual chain:

1. Clicking a tab in `cad/html/index.html` calls e.g.
   `DuckMdt.TabSelected('CS_Cases')`.
2. `cad/html/app.js` sends an NUI callback `CS_GetCases`.
3. `cad/client/main.lua` catches that with `RegisterNUICallback('CS_GetCases', ...)`
   and calls `ESX.TriggerServerCallback('CrimeScene:getCases', ...)`.
4. `cad/server/crimescene.lua` answers it by querying a table called
   **`doj_cases`** (its own -- created in `server/db_migrations.lua` right
   after `dept_cases`, with an explicit comment: *"Deliberately named
   differently from crimescene's doj_cases/doj_case_notes/doj_case_suspects
   below -- both independently used the doj_ prefix with incompatible
   schemas; these were renamed to avoid the collision. The two case systems
   are separate and don't share data."*).
5. `cad/client/main.lua` sends the result back as `SendNuiMessage({type = 'CS_Cases', ...})`.

So there are genuinely **two unrelated case systems** in this resource:

- **`dept_cases`** -- the real investigation case file (`server/doj_cases.lua`,
  `server/doj_manager.lua`, `server/case_timeline.lua`, the `/doj` menu,
  and everything evidence auto-creates via `CreateExternalCase`).
- **`doj_cases`** (note: singular table name collision with the concept,
  but a totally different schema -- `rob_name`, `warrant_status`, `coords_x/y/z`)
  -- CAD's own robbery/warrant tracker, fed by `server/rob_manager.lua`
  and shown in CAD's Cases/Cold Cases/Wanted Board tabs.

This was a deliberate, already-documented split from an earlier session
(the comment above), not something new -- a "case" here means a specific
robbery incident with a warrant status, which is a narrower, faster-moving
thing than a full DOJ investigation with notes/charges/suspects/timeline.
Nothing evidence creates via `CreateExternalCase`, nothing filed through
`/doj`, and nothing in `case_timeline` shows up in CAD's tabs, and vice
versa -- an officer working a DOJ case in `/doj` sees none of it in `/cad`.

Also worth knowing: `cad/server/crimescene.lua` has its **own** separate
`IsDOJJob`/`IsLawEnforcementJob`/`IsReferralJob` helpers reading from
`Config_cs.DOJJobs`/`LawEnforcementJobs`/`ReferralJobs` (`cad/config_crimescene.lua`)
-- a fourth independent copy of the same department-job concept, alongside
the `DOJ_JOBS`/`LE_JOBS` tables Round 1 already consolidated and the real
`Departments` table in `shared/departments.lua`. Left as-is for now since
it's reading Lua config rather than duplicating a literal hardcoded list,
and merging it into `shared/departments.lua` would mean touching every
`Config_cs.DOJJobs` reference throughout `cad/server/crimescene.lua` and
`cad/client/crimescene.lua` -- want me to do that consolidation too, and/or
actually wire the two case systems together (e.g. CAD's Cases tab also
listing `dept_cases`, or a robbery case optionally linking to a real DOJ
case)?

## Round 3 also: ActivateTask() crash, all 7 departments

`^1SCRIPT ERROR: ...client/marshal_main.lua:4040: attempt to call a nil
value (global 'ActivateTask')^7` -- checked every `client/*_main.lua` and
every other file in the resource: `ActivateTask` is called (with zero
arguments, right after an ESX help notification when a player sits in a
vehicle's driver seat) in **all 7** department client files
(`police`, `marshal`, `sheriff`, `mt`, `cid`, `doa`, `judge`) and is never
defined anywhere -- guaranteed 100%-reproducible script error every time
*any* government-job player got in a driver's seat, in every version of
this resource, not something introduced by this pass. Removed the dead
call in all 7 (the help notification right before it already did this
block's only real, visible job). All 7 syntax-checked clean.

## Round 4: actually connecting CAD's case system to the real DOJ cases

Following up on Round 3's finding -- added a real link between the two,
without merging their schemas (too risky to rewrite either one wholesale):

- **`doj_cases` gets a new column**: `linked_dept_case_id` (self-healing,
  via `EnsureColumn` in `server/db_migrations.lua`, same as everything
  else in this resource).
- **New action, `cad/server/crimescene.lua`'s `CrimeScene:openDojCase`**:
  from a robbery/warrant case's detail view in `/cad`, a DOJ-job officer
  can now click **"📂 Open DOJ Case"**. First click creates a real
  `dept_cases` row via the same global `CreateExternalCase` evidence uses
  -- title, the case's suspect (if any), and an evidence note summarizing
  the warrant status -- and stores its id back onto the `doj_cases` row.
  Once linked, the case detail view shows **"🔗 DOJ Case #X"** instead of
  the button, and clicking it again (or anyone else opening that case)
  just confirms the existing link rather than creating a second one.
- Wired end-to-end: `cad/html/app.js` (button + status line) ->
  `cad/client/main.lua` (`CS_OpenDojCase` NUI callback) ->
  `cad/server/crimescene.lua` (the new event, using the already-existing
  `CrimeScene:refreshCase` round-trip every other case action here uses)
  -> `server/doj_cases.lua`'s `CreateExternalCase`.
- **Also consolidated**: `cad/config_crimescene.lua`'s `Config_cs.DOJJobs` /
  `Config_cs.LawEnforcementJobs` were their own hardcoded copies of the
  exact same 6/3 jobs already in `shared/departments.lua`'s `Departments`
  table (a *fifth* copy of this list, on top of the ones Round 1 fixed).
  Now both just point at `GetDepartmentById('doj').jobs` /
  `GetDepartmentById('le').jobs` directly -- same array object, so
  `cad/server/crimescene.lua`'s and `cad/client/crimescene.lua`'s own
  `IsDOJJob`/`IsLawEnforcementJob` loop-over-array helpers didn't need to
  change at all, they just read the canonical array now.
  (`Config_cs.ReferralJobs = { 'judge', 'cia', 'fbi' }` was left alone --
  it's a genuinely different, narrower concept: which DOJ jobs a case can
  be escalated *to*, not "is this job DOJ", so it doesn't map onto
  anything in `Departments`.)

All 4 touched files (`server/db_migrations.lua`, `cad/server/crimescene.lua`,
`cad/client/main.lua`, `cad/config_crimescene.lua`) syntax-checked clean
with `luac5.4 -p`; `cad/html/app.js` checked clean with `node --check`.
A full resource-wide re-sweep afterward still shows only the same 2
pre-existing K9 files failing (untouched, unrelated to any of this work).

## Round 5: "❌ Shoma Ozve DOJ Nistid!" even though you ARE fbi

Reported live: player's job was changed to `fbi` (grade 8, confirmed by the
`SYSTEM: Shoma Job Ya Grade Ra Eshtebah Vared Kardid! / Shoma Job GD (1) Ra
Be fbi (8) Taghir Dadid` chat message and the HUD correctly showing
"FBI | General"), but `/doj` still said "Shoma Ozve DOJ Nistid!" (not a
DOJ member).

**Root cause**: `client/doj_menu.lua` (and, same bug, `client/court_docket_menu.lua`,
`client/law_menu.lua`, `client/agent_speact.lua`) each keep their own local
cached variable (`dojJob` / `leJob` / `agentJob`) that's only refreshed by
their own `esx:setJob` client event handler. The player's job was changed
through whatever the admin panel tool uses (the "SYSTEM:" chat messages in
the screenshot are that tool's own output, not a normal ESX notification),
and that path evidently doesn't fire the client-side `esx:setJob` event --
so `ESX.PlayerData.job` (what the HUD reads, and what the server itself
checks for every real permission check in this resource) was already
correctly `fbi`, but these four menus' own separate cached copies never
got the memo and stayed stale until the player relogged.

**Fix**: `OpenDojMenu()` and `OpenAgentMenu()` already had unused
`CheckDojJob()` / `CheckAgentJob()` helpers sitting right there for exactly
this -- just added the one missing call at the top of each. `OpenDocketMenu()`
and `OpenLawMenu()` didn't have that helper, so re-derive their cached
variable fresh from `ESX.PlayerData.job` inline instead. All four now
re-check against live `ESX.PlayerData.job` every time the menu is opened,
so none of them can be wrong about the player's own current job regardless
of how it last changed. All 4 files syntax-checked clean.

## Round 6: load-order crash I introduced in Round 1 -- sorry, this one was on me

Your server log showed `shared/departments.lua:30: attempt to call a nil
value (global 'GetJobSetForDepartment')`, and a cascade of "attempt to
call/index a nil value" errors right after it in `cad/config_crimescene.lua`,
`radar/config.lua`, `client/teleport_*.lua`, `client/doj_menu.lua`,
`client/court_docket_menu.lua`, `cad/server/main.lua`, and
`cad/server/crimescene.lua`'s `Config_cs.ColdCaseSweepIntervalMinutes`.

**Root cause, and it's a real mistake on my end**: in Round 1, I added the
`DojJobSet = GetJobSetForDepartment('doj')` block (and everything after it)
*above* `GetJobSetForDepartment`'s own `function ... end` definition further
down the same file. `luac5.4 -p` only checks syntax, not execution order, so
it happily passed every time I ran it -- but Lua runs a file top-to-bottom,
so the moment `shared/departments.lua` actually *loaded* on your server, line
30 tried to call a global that didn't exist yet and the whole file's
execution stopped right there. That meant everything below line 30 in that
file -- `GetDepartmentById`, `GetJobSetForDepartment` themselves, all the
`exports()` calls -- never ran either, which is why every other file that
depends on any of them (all listed above) also errored as soon as it loaded.

**Fix**: moved the `DojJobSet`/`LeJobSet`/`GovernmentJobSet`/`IsDojJob`/
`IsLeJob`/`IsGovernmentJob`/`ResponderJobs`/their `exports()` calls to
*after* `GetDepartmentForJob`/`GetDepartmentJobSet`/`GetDepartmentById`/
`GetJobSetForDepartment`'s own definitions in the same file. Verified this
time by actually *executing* the file (not just `luac5.4 -p`, which can't
catch this class of bug) with a stub `exports()`/`vector3()`, in the exact
order `fxmanifest.lua`'s `shared_scripts` loads them
(`shared/departments.lua` -> `cad/config_crimescene.lua` -> `radar/config.lua`)
-- all three now load clean end to end, and `Config_cs.DOJJobs`/
`Config_cs.ColdCaseSweepIntervalMinutes` (the ones downstream errors pointed
at) both come out correct.
