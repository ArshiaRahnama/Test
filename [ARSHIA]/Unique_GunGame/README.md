# Unique_GunGame

FiveM/ESX GunGame event script. Players queue up with a command, get grouped
automatically into small concurrent arenas, fight through a long weapon ladder
(ending in a forced melee finish) by getting kills, and see a live scoreboard,
countdown, round timer, kill feed, and a Call-of-Duty-style MVP screen on win.

## Requirements

- ESX Legacy (or compatible fork exposing `esx:getSharedObject`)
- `esx_ambulancejob` (revive on death)
- `esx_skin` + `skinchanger` (outfit swap, restoring your normal skin after a match)
- `mythic_progbar` (respawn progress bar)

If your server doesn't have one of these resources, either install it or replace
the corresponding `TriggerEvent` call in `client.lua` with your server's equivalent.

## Features

- Concurrent arenas with an admin-gated queue (`/gungame start` / `stop`)
- 30-weapon ladder (classic 1-kill-per-weapon GunGame rule), ending on a melee
  weapon for a forced knife-fight finish
- Multiple random spawn points per arena (`Config.Locations[i].ArenaPoints`), so
  the same corner doesn't get camped every round
- An arena leash that pulls wandering players back toward the fight
- Live scoreboard (top N + your own row), round timer, countdown, and kill feed
- Kill-streak announcements and an optional persistent database leaderboard
- Player blips on the minimap for everyone else currently in your arena
- A Call-of-Duty-style MVP screen with kills, name, and an optional calling-card
  image, plus a fireworks effect at the winner's position
- Optional sound effects (kill / match start / match win)
- An optional physical NPC players can walk up to and press E on to join
- Discord webhook announcements on arena wins
- Exports for other resources to query GunGame state

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

## Winner MVP screen

When an arena is won, everyone in it sees a Call-of-Duty-style MVP screen (name,
kill count, and a calling-card image) for `Config.WinnerCameraSeconds`, plus a
fireworks effect at the winner's position (`Config.WinnerFireworks`). Calling-card
images are optional — drop your own into `html/callingcards/` and list the
filenames in `Config.CallingCards`; leave it empty and the screen just shows a
plain star badge instead. This is a delivery/teleport delay, not extra combat time
— the round is already decided.

## Sound effects (optional)

`Config.Sounds.Kill` / `MatchStart` / `MatchWin` reference files under
`html/sounds/`, e.g. `Config.Sounds.Kill = 'sounds/kill.ogg'`. Leave any of them
`nil` (the default) to skip that sound entirely — no audio files are required to
use the script. `Config.SoundVolume` controls playback volume (0–1) for all of them.

## Player blips & arena leash

While in a match, every other player in that same arena shows up as a blip on
your minimap (`Config.ShowPlayerBlips`, `Config.PlayerBlipSprite/Color`) — blips
are scoped per-arena, so other concurrent arenas never show up on your map.
`Config.ArenaLeashRadius` automatically pulls a player back to a random arena
point if they stray further than that from the arena's `Center` — set it to `0`
to disable.

## Physical join point (optional)

In addition to `/jgg`, you can place an NPC in the world for players to walk up
to and press E on. It's off by default (`Config.JoinPed.Enabled = false`) since
`Config.JoinPed.Coords` needs to be a real spot on your map first — set the
coordinates, flip `Enabled` to `true`, and the NPC (model, interact distance,
and prompt label all configurable) will call `/jgg` for anyone who interacts.

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

## Testing solo on a local server

Set `Config.TestMode = true` and a single `/jgg` will immediately form its own
arena instead of waiting for `Config.PlayersPerArena` people. Turn it back to
`false` before going live — with it on, every player forms their own 1-person
arena instead of the real group size.

## Framework compatibility

This script avoids depending on ESX's inventory events specifically, since heavily
customized servers often replace them, while keeping spawn and revive on the same
classic flow most ESX ambulance-job setups already use:
- Weapons and the parachute are given with the `GiveWeaponToPed` native directly,
  not `esx:addWeapon` — so it works even if your server's inventory system doesn't
  listen for that event.
- Arena entry and respawns use a scripted camera (like a normal ESX spawn-select
  screen) rather than anything fancier.
- Revive triggers `Config.ReviveEvent` (default `esx_ambulancejob:revive`) and waits
  on `ESX.GetPlayerData().IsDead` to know when the player is actually back up, exactly
  like a stock ESX ambulance-job revive. If your server's revive event has a different
  name, change `Config.ReviveEvent` to match it. If your server also doesn't keep
  `IsDead` in sync with vanilla ESX, the wait loop won't resolve correctly — in that
  case let me know what does track your player's dead state and the wait condition can
  be swapped to match it.

## config.lua reference

- `Config.PlayersPerArena` – group size that triggers a new arena.
- `Config.MaxQueueSize` – hard cap on players in the queue + all running arenas combined.
- `Config.CountdownTime` – seconds between a group forming and the match starting.
- `Config.RoundTimeLimit` – seconds before a round is decided by kill count (0 disables the limit).
- `Config.TestMode` – lets a single player form their own arena, for solo local testing.
- `Config.Locations` – array of `{ Lobby, Center, ArenaPoints, Exit }` sets, assigned
  round-robin to new arenas. `ArenaPoints` is a list of spawn points inside that
  arena; a random one is picked on every spawn/respawn. `Center` is the reference
  point for `Config.ArenaLeashRadius`. Safe to leave duplicated across sets;
  isolation between concurrent arenas comes from routing buckets, not distance.
- `Config.ArenaLeashRadius` – auto-recall distance from `Center` (0 disables it).
- `Config.Weapons` / `Config.WeaponAmmo` / `Config.KillsPerLevel` / `Config.KillsToWin`
  – the weapon progression ladder (30 weapons by default, 1 kill per level, ending
  in a melee weapon).
- `Config.ChangeOutfitOnJoin` / `Config.OutfitMale` / `Config.OutfitFemale` –
  optional cosmetic outfit swap while in a match.
- `Config.WinnerCameraSeconds` / `Config.WinnerFireworks` / `Config.CallingCards` –
  the MVP win screen; see above.
- `Config.Sounds` / `Config.SoundVolume` – optional sound effects; see above.
- `Config.ShowPlayerBlips` / `Config.PlayerBlipSprite` / `Config.PlayerBlipColor` –
  minimap blips for other players in your arena.
- `Config.JoinPed` – optional physical join NPC; see above.
- `Config.KillstreakAnnouncements` – life-streak counts (resets on death) that trigger an in-arena chat announcement. Empty table disables it.
- `Config.QueueReminderInterval` – seconds between server-wide reminders that the queue needs more players (0 disables).
- `Config.ScoreboardTopCount` – the live scoreboard HUD shows this many top rows; if a player isn't in it, their own row is appended after so they can always see their standing (0 shows everyone).
- `Config.ReviveEvent` – the event triggered to ask your server to revive a dead player; see Framework compatibility above.
- `Config.RestrictedJobs` – jobs that can't queue while on duty.
- `Config.UseDatabase` / `Config.DiscordWebhook` – optional persistent leaderboard and Discord announcements; see above.

## Files

```
Unique_GunGame/
├── fxmanifest.lua
├── config.lua
├── server.lua
├── client.lua
├── install.sql          (optional, see Config.UseDatabase)
└── html/
    ├── index.html
    ├── style.css
    ├── script.js         (HUD + MVP screen + sound playback)
    ├── callingcards/      (optional images, see Config.CallingCards)
    └── sounds/            (optional audio, see Config.Sounds)
```
