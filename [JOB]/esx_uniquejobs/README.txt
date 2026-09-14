K9 merged into esx_uniquejobs
==============================

What this does
---------------
Moves the standalone K9 script entirely into esx_uniquejobs. Every K9 file now
lives inside esx_uniquejobs and loads as part of that one resource. A "Spawn
Pet" option was added to the F6 menu of these 9 departments only:

  Police, Sheriff, FBI, CIA, DOA, CID, Marshal, MT, Ambulance

Clicking it opens the K9 menu directly. Every other department (Judge,
Mechanic, Taxi, Weazel) does NOT get this option.

Install steps
-------------
1. In your esx_uniquejobs resource folder, REPLACE these 9 existing files
   with the ones from this package's client/ folder:
     client/police_main.lua
     client/sheriff_main.lua
     client/doa_main.lua
     client/cid_main.lua
     client/marshal_main.lua
     client/mt_main.lua
     client/fbi_main.lua
     client/cia_main.lua
     client/ambulance_job.lua

2. COPY these new folders/files into esx_uniquejobs (they don't exist yet):
     client/k9/              (7 files)
     server/k9/               (2 files)
     shared/k9_config.lua

3. REPLACE esx_uniquejobs/fxmanifest.lua with the one in this package. It's
   your existing fxmanifest with these additions only (nothing removed):
     - 'shared/k9_config.lua'           added to shared_scripts
     - 'client/k9/*.lua' (7 files)      added to client_scripts
     - 'server/k9/*.lua' (2 files)      added to server_scripts
   If you've changed your fxmanifest since I last read it, diff it instead
   of overwriting — the only real requirement is those 9 new lines.

4. Run k9_sql.sql once against your database (creates the `k9` table K9
   needs to save registered dogs). Skip this if you already ran K9's own
   sql.sql before.

5. DELETE the standalone k9 resource folder entirely, and remove (or
   comment out) `ensure k9` from your server.cfg. Its job is now done by
   esx_uniquejobs.

6. Restart esx_uniquejobs (or the whole server).

What changed under the hood
----------------------------
- CFG.RESTRICTIONS.JOBS in shared/k9_config.lua was only 'police' and
  'ambulance'. I added the other 7 departments (grade 0-30, generous
  range) — otherwise "Spawn Pet" would show up in their F6 menu but
  immediately deny them.
- Every "Spawn Pet" click now runs the same HasAccess() job/grade check
  K9 already uses for its own chat commands, so someone can't bypass the
  restriction by using the menu instead of typing /k9.
- I checked every global name K9 defines (functions like SPAWN_K9,
  OPEN_K9_MENU, and variables like `data`, `dog_ent`, `action`, `CFG`)
  against all of esx_uniquejobs' client/server files before merging —
  no naming collisions, so nothing else in your job script is affected.
- Fixed a real bug while I was in there: the animation code's "is the dog
  busy" check was reading global variables (feeding, carry, etc.) that
  never actually existed — they're fields on the `action` table. It was
  silently doing nothing. Now reads action.feeding, action.carry, etc.,
  so animations correctly refuse to play while the dog is busy.

Limitations
-----------
- lc-inventory has no glovebox system (only trunk), so k9searchcar can
  only ever find items in a vehicle's trunk — this is a limitation of
  lc-inventory, not of K9. (Covered in the earlier lc-inventory patch,
  unrelated to this integration — merge that in separately if you
  haven't already.)
