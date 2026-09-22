# Unique_Event

One resource, one menu (`/uevent`), three battles: **Capture**, **GunGame**, **WarZone**.
Built for ESX (legacy `essentialmode`/`es_extended`-style) servers, on top of `oxmysql`.

This replaces `Unique_Capture`, `Unique_GunGame` and `WarZone` — do **not** run the old
resources alongside this one (duplicate commands/threads will conflict). Training/Academy
was intentionally left out of this build, per request.

> **Why `/uevent` and not `/event`?** This server's `Unique_AdminPanel` already owns the
> `/event` command (an older, unrelated "admin sets a TP point, players teleport to it"
> tool). Registering the same name here would silently fight with it depending on which
> resource starts last. `/uevent` (alias `/events`) avoids that collision entirely — the
> old `/event` command still works exactly as it did before, untouched.

---

## Install

1. Copy the `Unique_Event` folder into your `resources` directory.
2. Make sure `oxmysql` is started **before** this resource in `server.cfg`:
   ```
   ensure oxmysql
   ensure Unique_Event
   ```
3. Nothing else to run manually — every database table is created automatically
   (`CREATE TABLE IF NOT EXISTS`) the first time the resource starts. `sql/install.sql`
   is included only as a reference if you want to pre-provision the schema yourself.
4. Open `config.lua` and check the sections below — at minimum, review the Capture
   zone list, the WarZone/GunGame world coordinates, and the gang table/column names
   if your gang system isn't the default `gangs_data` table.
5. Open `sv_config.lua` and fill in Discord webhook URLs and cash rewards if you want them
   (everything works with these left blank/zero — logging and payouts are optional).

---

## Commands

| Command | Who | What it does |
|---|---|---|
| `/uevent` (or `/events`) | everyone | Opens the main hub — join/leave any event, see leaderboards, squad up, admin tools |
| `/eventfix` | everyone | Emergency reset: clears a stuck NUI focus/HUD if something ever goes wrong |
| `/spectate` | admin (level ≥ 11) | Free-camera spectate over any player currently in an event |

Every other action (joining Capture, starting a GunGame arena queue, dropping into
WarZone, starting/ending rounds, inviting to a WarZone squad, admin round control...)
is done from inside the `/uevent` menu — there are no other chat commands to memorize.

**Spectate controls:** `←`/`→` switch target, `TAB` toggles the player list, `BACKSPACE` leaves.

---

## Permission levels (`Config.Perm` in `config.lua`)

| Event | ESX `permission_level` required for admin actions |
|---|---|
| Capture round control (start/end/reset zones) | ≥ 11 |
| GunGame | ≥ 9 (no manual admin controls needed — arenas start automatically) |
| WarZone force-start/force-end | ≥ 16 |
| `/spectate` | ≥ 11 |

---

## How each event works

### Capture
Gangs fight over a configurable list of zones (`Config.Capture.DefaultZones`). Standing
alone — no rival gang member nearby — at a zone's capture point for
`Config.Capture.TimeToCaptureZone` seconds gives your gang that zone. The owning gang
scores a point every `Config.Capture.PointInterval` seconds. Kills, gang points and an
all-time weighted leaderboard (`Kills*2 + GangPoints*1 - Deaths*1` by default) are all
tracked and shown in `/uevent`. Zone ownership persists across restarts (`zones.json`).
An admin starts/ends rounds from the Admin tab in `/uevent`.

### GunGame
Queue up from `/uevent`. Once `Config.GunGame.PlayersPerArena` players are queued, a new
arena spins up automatically in its own isolated world. Every kill advances you one
weapon up `Config.GunGame.Weapons`; scoring a kill with the last weapon on the ladder
wins the match and shows an MVP screen to everyone in that arena.

### WarZone
Join the lobby from `/uevent`; once `Config.WarZone.MinPlayers` are in, a countdown
starts automatically. On match start everyone parachutes in, loots weapons from ground
crates, and fights inside a shrinking safe zone. Squad up beforehand with `/uevent`'s
WarZone tab (invite by server ID). Getting knocked out sends you to the **Gulag** — a
1v1 second chance — the first time it happens to you each match; win it and you're
dropped back into the fight, lose (or time out) and you're out for good. Last squad
standing wins and splits the win reward.

---

## What's actually different from the original three resources

This is a rewrite, not a copy-paste merge — every gameplay-affecting value (kills,
weapons, money, zone ownership, match results) is now decided and validated on the
**server**, not trusted from the client. Concretely, this fixes:

- **WarZone:** the old `setweapons`/kill/cash events trusted whatever the client sent
  (a straightforward exploit). Weapons, kills and cash are now server-authoritative.
- **WarZone:** revive previously called a non-existent `esx_ambulancejob:revive` event;
  it now calls the server's real `esx_ambulancejob:revivex`.
- **GunGame:** kills (and therefore weapon-ladder progress) were reported by the killer's
  own client. Kills are now resolved server-side from the game's own death event.
- **Capture:** zone ownership and the capture timer are now fully server-driven, so a
  modified client can no longer claim a zone it isn't actually standing in.
- Every match/arena/round now cleans up properly (routing buckets freed, timers
  stopped), so a resource restart is never required to run a new one back-to-back.

## What's intentionally simplified

To keep everything above actually working and bug-free rather than half-wired, a
handful of "nice-to-have" ideas from the original WarZone (battle pass, cosmetic shop,
world hazards, vehicle loot, buy stations) were left out of this build rather than
shipped as dead config. The core loop — loot, fight, shrinking zone, downed/revive,
Gulag, squads, leaderboards — is fully implemented. If you want any of the trimmed
features added back in, ask and they can be built properly rather than stubbed.

---

## Folder structure

```
Unique_Event/
├─ fxmanifest.lua
├─ config.lua          -- shared config (safe to fully customize)
├─ sv_config.lua        -- server-only: webhooks + cash rewards
├─ shared/shared.lua     -- small helpers used everywhere
├─ server/
│  ├─ core.lua          -- ESX bootstrap, DB helpers, permissions, one-event-at-a-time guard
│  ├─ hub.lua           -- /uevent data + action router + admin spectate
│  ├─ capture.lua
│  ├─ gungame.lua
│  └─ warzone.lua
├─ client/
│  ├─ core.lua          -- NUI bridge, generic menu/dialog/progress bar, interactions
│  ├─ hub.lua           -- /uevent command + spectate camera
│  ├─ capture.lua
│  ├─ gungame.lua
│  └─ warzone.lua
├─ html/                -- the /uevent NUI (index.html, style.css, app.js)
└─ sql/install.sql      -- reference schema (auto-created on first start)
```
