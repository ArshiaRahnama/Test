# Unique_GunGame

FiveM/ESX GunGame event script. Players queue up with a command, get grouped
automatically into small concurrent arenas, fight through a weapon ladder by
getting kills, and see a live scoreboard, countdown, and round timer on screen.

## Requirements

- ESX Legacy (or compatible fork exposing `esx:getSharedObject`)
- `esx_ambulancejob` (revive on death)
- `esx_skin` + `skinchanger` (outfit swap, restoring your normal skin after a match)
- `mythic_progbar` (respawn progress bar)

If your server doesn't have one of these resources, either install it or replace
the corresponding `TriggerEvent` call in `client.lua` with your server's equivalent.

## Install

1. Drop the `Unique_GunGame` folder into your server's `resources` directory.
2. Add `ensure Unique_GunGame` to your `server.cfg`.
3. Adjust `config.lua` to match your server (see below).
4. Restart the resource or the server.

## Commands

| Command | Who | Description |
|---|---|---|
| `/jgg` | everyone | Join the GunGame queue (only works after an admin runs `/gungame start`) |
| `/ggl` | everyone | Leave the queue (only while still waiting, not once in a running arena) |
| `/gungamestats` | everyone | Shows the top-10 all-time leaderboard (kills, wins, matches) — requires `Config.UseDatabase = true` |
| `/gungame start` | admin (`permission_level` ≥ `Config.PermissionLevel`) | Opens the event so players can `/jgg` |
| `/gungame stop` | admin (`permission_level` ≥ `Config.PermissionLevel`) | Closes the event, force-stops every running arena, and clears the queue |

## How arenas work

- The event is closed by default. An admin must run `/gungame start` before anyone can `/jgg`.
- Once open, players who run `/jgg` are added to a single waiting queue.
- As soon as `Config.PlayersPerArena` players are queued, that group is pulled out
  and starts its own independent arena (countdown, then the match) — the rest of
  the queue keeps waiting for the next group.
- Multiple arenas can run at the same time. Each one gets its own FiveM routing
  bucket, so players in different arenas are fully isolated from each other even
  if their `Config.Locations` coordinates are identical.
- Killing another player moves you up the `Config.Weapons` ladder every
  `Config.KillsPerLevel` kills. Reaching `Config.KillsToWin` total kills wins that arena.
- If `Config.RoundTimeLimit` is reached before anyone wins, whoever has the most
  kills in that arena is declared the winner.

## Persistent leaderboard (optional)

Set `Config.UseDatabase = true` and start `oxmysql` before this resource to
track all-time kills/wins/matches per player (identified by `xPlayer.identifier`).
The table is created automatically on first start; `install.sql` is included
for reference if you'd rather run the migration by hand. Leave it `false` and
the script runs exactly the same, just without a persistent leaderboard.

## Discord webhook (optional)

Set `Config.DiscordWebhook` to a webhook URL to post a short message to Discord
every time an arena is won. Leave it as `''` to disable.

## Exports

Other resources can check GunGame state without touching its internals:

```lua
exports['Unique_GunGame']:IsPlayerInGunGame(source) -- true/false
exports['Unique_GunGame']:GetQueueSize()            -- number currently waiting
```

## config.lua reference

- `Config.PlayersPerArena` – group size that triggers a new arena.
- `Config.MaxQueueSize` – hard cap on players in the queue + all running arenas combined.
- `Config.CountdownTime` – seconds between a group forming and the match starting.
- `Config.RoundTimeLimit` – seconds before a round is decided by kill count (0 disables the limit).
- `Config.KillstreakAnnouncements` – life-streak counts (resets on death) that trigger an in-arena chat announcement. Empty table disables it.
- `Config.QueueReminderInterval` – seconds between server-wide reminders that the queue needs more players (0 disables).
- `Config.RestrictedJobs` – jobs that can't queue while on duty.
- `Config.Locations` – array of `{ Lobby, Arena, Exit }` coordinate sets, assigned
  round-robin to new arenas. Safe to leave duplicated; isolation comes from
  routing buckets, not distance.
- `Config.Weapons` / `Config.WeaponAmmo` / `Config.KillsPerLevel` / `Config.KillsToWin`
  – the weapon progression ladder.
- `Config.ChangeOutfitOnJoin` / `Config.OutfitMale` / `Config.OutfitFemale` –
  optional cosmetic outfit swap while in a match.

## Files

```
Unique_GunGame/
├── fxmanifest.lua
├── config.lua
├── server.lua
├── client.lua
├── install.sql   (optional, see Config.UseDatabase)
└── html/
    ├── index.html
    ├── style.css
    └── script.js   (scoreboard / countdown / round-timer / kill-feed HUD)
```
