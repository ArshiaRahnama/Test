# Apex Phone (apex_phone) v1.3.0

A full smartphone for FiveM with two complete operating systems in one resource:

- **PearOS 27** (iOS style) on the PearPhone 18 Pro Max and the PearPhone Fold
- **Nova UI 8.5** (Android style) on the NOVA S26 Ultra and the NOVA Fold8

The item a player uses decides which system opens. Apps, account, phone number, messages and calls are shared
between both systems, so a PearPhone player can call, text and video call a NOVA player normally.

Also included: AirBuds and Slate Buds earbuds (3D props on the head), eSIM cards with QR activation and up to 3
lines per phone, an in-world phone shop with a 3D product viewer, an in-game admin panel (`/phoneadmin`) with a
custom job app builder, and the Vera assistant (optional, Google Gemini).

---

## Requirements

| Resource | Required | Notes |
|---|---|---|
| `oxmysql` | **Yes** | The only hard dependency. |
| Framework | Auto | `qbx_core` (QBox), `qb-core` (QBCore) or `es_extended` (ESX), detected at start. Standalone mode is also available (`Config.Framework = 'standalone'`). |
| Voice | Optional | `pma-voice`, `saltychat` or `mumble-voip` for call audio (`Config.Voice = 'auto'`). Only pma-voice has been used in production; the other two follow their public APIs. |
| `ox_inventory` | Optional | Recommended. Items, metadata and the shop use it first. `qb-inventory` and the ESX / QB inventories also work through the framework. |
| `ox_target` | Optional | Phone shop interaction (`Config.Shop.interaction.mode = 'auto'` falls back to a key press). |
| `ox_lib` | Optional | Used for the confirmation dialog of `/phonewipe` when running. |
| `screenshot-basic` | Optional | Only for the Face Key face photo. The Camera app does not need it. |

Optional integrations, detected automatically when started: `qb-houses` (Home app), `qb-weathersync` (Weather app).

## Installation

1. Put the `apex_phone` folder in your `resources` folder.
2. In `server.cfg`, start it **after** `oxmysql`, your framework and your voice resource:
   ```
   ensure oxmysql
   ensure qb-core        # or qbx_core / es_extended
   ensure pma-voice
   ensure apex_phone
   ```
3. Stop any other phone resource (`qb-phone`, `esx_phone`, ...) so two phones do not fight over the same key.
4. **No SQL file is needed.** Every `apex_phone_*` table is created automatically on the first start
   (`CREATE TABLE IF NOT EXISTS` in the server files), and missing columns or indexes are added on later starts.
5. Add the items (see below), then restart the server or run `restart ox_inventory` and `restart apex_phone`.
6. Give your staff the admin permission (see **Admin permission**).

### Inventory items

By default the phone only opens with one of the device items in the inventory (`Config.RequireItem = true`).

- **ox_inventory:** copy every entry of [`inventory_items.lua`](inventory_items.lua) **inside** the `return { ... }`
  of `ox_inventory/data/items.lua`. The item images are served by this resource
  (`nui://Unique_Phone/inventory_images/<item>.png`), so you do not have to copy any PNG.
- **QBCore / QBox with qb-inventory (or ps-, lj-, qs-inventory):** paste the entries of
  [`installation/qb-core_items.lua`](installation/qb-core_items.lua) inside `QBShared.Items` of `qb-core/shared/items.lua`
  and restart qb-core. These inventories load an item's icon from **their own** `html/images/<image>` folder, so `image`
  must be a plain file name (`pear18_black.png`), never a `nui://` address. The phone checks this on every start
  (`Config.InventoryImages`): a PNG missing from the inventory's images folder is copied there from
  `inventory_images/` (run `restart qb-inventory` once afterwards), and the server console says exactly what is wrong
  (item not created, `useable = false`, image not a file name). `phoneitems` in the console repeats the check.
- **Other inventories:** create items with the same names (list in [`ITENS_OX_INVENTORY.md`](ITENS_OX_INVENTORY.md))
  and use the PNG files from `inventory_images/` as icons. Usable items are registered through the framework.

Full item guide: [`ITENS_OX_INVENTORY.md`](ITENS_OX_INVENTORY.md).

## Opening the phone

| Input | Action |
|---|---|
| `F1` (`Config.OpenKey`) | Open / close. Opens the first device in the inventory (or the last one used). Players can rebind it in the FiveM key settings. |
| Use a device item | Opens that device (its OS, frame colour and prop). Using the same item again closes it. |
| `Esc` | Close |
| `Config.Command` | Optional chat command to open (empty by default). |
| `Config.VeraKey` | Optional key for the Vera assistant with the phone closed (empty by default). Never use F2 with ox_inventory. |

## Commands

All commands below are admin only (or the server console).

| Command | What it does |
|---|---|
| `/phoneadmin` | In-game admin panel: phone settings, enabled apps, phone shop, custom job apps, webhooks and the change log. Everything saved there is stored in the database and overrides `config.lua`; "Reset" goes back to the config. |
| `/phonegive [id] [item]` | Gives one phone item to a player. |
| `/apexdevices [id]` | Gives every device and both earbuds (`Config.DeviceGrantCommand`, empty disables it). |
| `/phoneopen [id] [app]` | Opens a player's phone, optionally on an app. |
| `/phonenumber [id] [new]` | Shows or changes a player's number. |
| `/phonereset [id]` | Factory resets a player's phone account. |
| `/phonenotify <target> <app> <text>` | Sends a phone notification. |
| `/testnotif [id] [app]` | Sends a test notification. |
| `/phonepos` | Live editor for the phone position in the hand. |
| `/phonewipe` | Wipes **all** phone data of all players. Shows a summary and a 4 digit code; `/phonewipe confirm <code>` runs it. A backup copy of every table (`zbak_apexphone_<date>_*`) is made first unless you add `nobackup`; add `all` to also wipe the admin panel settings. `/phonewipe backups` lists backups, `/phonewipe dropbackup <stamp>` deletes one. Restart `apex_phone` afterwards. |
| `/phoneshowcase seed\|clear\|status` | Fills the server with English demo data (14 fictional people, chats, posts, bills...) for screenshots and videos; `clear` removes exactly what `seed` created. |
| `phoneshop_items` | Server console only: re-checks which shop items exist in the inventory. |
| `/givesim [id] [number]` | Gives a SIM card item (only with `Config.PhysicalSim.enabled = true`; `Config.PhysicalSim.giveCommand`). |
| `/phoneintegrations` | Prints to the server console which integration provider each category is using right now. |
| `phoneitems` | Console or admin (1.2.0): checks the phone items in `qb-core/shared/items.lua` and their PNGs in the inventory's images folder, copies missing PNGs there and prints what to fix. |
| `phonesounds` | Console or admin (1.2.0): the `Config.WorldSounds` state, who is listening to a speakerphone and how many phones are ringing. |
| `phonedelivery` | Console or admin: why the Garage delivery is on or off, the mode (valet / road), the key resources fed and the last attempt. |

Players can use `/camtest` to print a camera viewfinder diagnostic to the F8 console, `/phonevoice` to print
which voice system the phone detected, the active call channel and the pma-voice state (use it when someone reports
"no audio in calls"), and `/phonefix` (1.1.8) to reset a stuck phone on the spot: it closes the phone and any shop /
admin layer left open, releases the NUI focus and cursor, the camera and Face Key, leaves the voice channel of a call
that no longer exists, clears a pending device request and the hand pose. It never touches data. The F8 console lists
what it reset, so support can see what was stuck.

### Admin permission

Admin = the framework admin permission (QBCore `admin`/`god`, QBox `admin`, ESX group `admin`/`superadmin`)
**or** the ACE `apex_phone.admin`, for example in `server.cfg`:

```
add_ace group.admin apex_phone.admin allow
```

## Configuration

| File | What is in it |
|---|---|
| `config.lua` | Everything: framework, keys, scale and position on screen, default language and theme, devices, wallpapers, PIN rules, SIM and eSIM, calls and voice, camera, messages, media limits, maps, services, billing, marketplace, garages, social apps, music library, Eats restaurants, browser, Vera AI, admin panel, custom apps and the phone shop. |
| `config_recado.lua` | Limits of the Recado messenger app (pins, forwards, polls, channels, communities, GIF provider). |
| `shared/admin_schema.lua` | Which settings the admin panel is allowed to change. |
| `client/framework.lua`, `server/framework.lua` | Framework bridge (players, money, jobs, items, notifications). |
| `server/shop_bridge.lua` | Money and item bridge of the phone shop (ox_inventory first). |
| `server/ai_key.lua` | The Gemini API key for Vera (server side only). |
| `locales/*.lua` | In-game texts outside the phone (notifications, chat, command help, key names). |

Useful keys in `config.lua`:

- `Config.Framework = 'auto'`: forces `'qb'`, `'qbx'`, `'esx'` or `'standalone'` if you run more than one.
- `Config.DefaultLanguage = 'en'`: language of new accounts. 16 languages: `en`, `es`, `zh-Hans`, `zh-Hant`, `ja`,
  `fr`, `de`, `ru`, `pt`, `it`, `ko`, `nl`, `tr`, `pl`, `sv`, `da`. Each player can change it in Settings > General >
  Language & Region; accounts that already exist keep the language they chose. A code that is not in the list falls
  back to English (phone and in-game texts). See "Languages" below for adding your own language.
- `Config.Currency = { symbol = '$', position = 'before', thousands = ',', decimal = '.' }`: the currency shown in
  the whole phone (Wallet, Bills, Marketplace, Eats, Onion/crypto, work apps) and in server notifications. For euros:
  `{ symbol = '€', position = 'after', thousands = ' ', decimal = ',' }`. The phone shop starts from it too
  (`Config.Shop.currency`); a symbol saved in the admin panel's shop settings still wins for the shop.
  Number formatting inside the phone follows the player's language.
- `Config.OpenKey`, `Config.Scale`, `Config.Offset`, `Config.AllowWalking`, `Config.BlockWhenDead`.
- `Config.KeepVoice = true`: the push-to-talk keeps working while the phone or the phone shop is open (the game keeps
  the keyboard; every other game control is disabled frame by frame and the player stands still unless
  `Config.AllowWalking` is on). `false` restores the old behaviour, where nobody could talk with the phone open.
- `Config.LookKey = 'LMENU'`: hold left Alt with the phone open to look around with the mouse (the pointer hides
  while the key is held). Players can rebind it in Settings > Key Bindings > FiveM; `''` removes it. Since 1.2.0 the
  phone page listens for Alt itself too, so it works with the mouse over the phone and with `Config.AllowWalking` and
  `Config.KeepVoice` both off (before, the key only reached the game when the game had the keyboard).
- `Config.WorldSounds` (1.2.0): the ringtone, message / notification chimes and alarms of a phone are heard by the players
  around it, fading with distance (`range`, `volume`); a phone on silent makes no sound for anybody. `speaker = true`
  turns the call screen's "Speaker" button into a real speakerphone with pma-voice / mumble-voip: players within
  `speakerRange` metres of the phone are put on the call channel while they stay close (they hear the other side and are
  heard by it) and taken out when they walk away, when the speaker is turned off or when the call ends. Players already
  in a call of their own are never pulled in. `phonesounds` in the server console shows the state.
- `Config.InventoryImages` (1.2.0, QBCore / QBox without ox_inventory): on start the phone checks its items in
  `qb-core/shared/items.lua` and copies missing PNGs into the inventory's `html/images/` folder (see "Inventory items").
- Typing in any text field of the phone keeps the keyboard inside the phone: no letter reaches the game (walking,
  chat, inventory, other resources' keys) and the open/close key never closes the phone while a field is focused,
  even when another resource turns the game input back on. Esc leaves the field, a second Esc closes the phone.
- `Config.GarageDelivery`: "Request Delivery" in the Garage app brings a stored vehicle to the player with its keys
  (price, account, cooldown, distance, key resource). `mode = 'valet'` (1.2.0, default): a valet NPC drives it from a
  road `valet.minDistance`..`valet.maxDistance` metres away up to the player, gets out and walks off; the phone says
  "Your vehicle has arrived". If the valet cannot get there in `valet.timeout` seconds (blocked road, player kept moving,
  no road nearby) the vehicle is moved to the nearest free road next to the player and the phone says so. `mode = 'road'`
  = the 1.1.9 behaviour (the vehicle appears parked on the nearest free road). Needs OneSync; works with every supported
  garage (`integrations/README.md`, "Delivery"). `phonedelivery` in the server console says why it is on or off, the
  mode and the last attempt.
- `Config.Music.Search = true` (internal provider): players search any song on YouTube or paste a YouTube link in the
  Music app and the story music sticker, with no API key. `Config.Music.Library` stays as the Home shelves.
  `Search = false` keeps the curated Library only. `phonemusic` / `phonemusic <text>` in the server console checks it.
- `Config.Camera.VideoMaxSeconds`, `VideoBitrate`, `VideoHeight`, `VideoMaxBytes`, `VideoAudio`: limits of the videos
  recorded by the Camera app (see "Camera video").
- `Config.Wallpapers` (files in `html/img/wallpapers/` or image links) and `Config.WallpaperLinks` (players adding
  wallpapers from links / pasted images; see "Wallpapers from links").
- `Config.Devices` / `Config.DeviceOrder`: items, props, frame colour and OS of every device.
- `Config.NumberFormat = '555-####'`, `Config.SyncNumberToCharInfo`, `Config.Sim` (eSIM item, lines per phone).
- `Config.Voice = 'auto'`, `Config.CallTimeout`.
- `Config.Shop`: phone shop locations, vendors, blips, categories, products and prices. The map blip is named
  "Phone shop" in the player's phone language (key `Loja de telemóveis` of `locales/<code>.lua`); set
  `Config.Shop.blip.label = 'My text'` for one fixed name on every shop, or `blipLabel = '...'` in a shop entry (also in
  `/phoneadmin` > Shop > Locations). Blips and the vendor prompt are renamed on the spot when the player changes language.
- `Config.Music.Library`: songs of the built in music catalogue (YouTube video ids).
- `Config.WelcomeMail` / `Config.BillMail` / `Config.Sim.carrier`: carrier and system mail texts.
- `Config.Debug = false`: set to `true` for extra logs in the server console, F8 and the NUI.

Webhooks for the admin log and the custom job apps are set in `/phoneadmin` (stored in the database, never in the files).

## Languages

Every text a player can see is translatable from files that stay readable in the escrowed build:

| File | What it translates |
|---|---|
| `html/js/i18n-<code>.js` | Everything inside the phone (all apps, the setup assistant, the lock screen, the admin panel). One file per language, loaded only when the language is chosen. |
| `locales/<code>.lua` | Everything outside the phone: in-game notifications, chat messages, command help, key-binding names, the phone shop blip and vendor prompt, the console replies of the admin commands. Generated from the matching `i18n-<code>.js`. |

The **key** of every entry is the original Portuguese text as it appears in the code; the **value** is the translation.
Never change a key: an entry whose key was edited no longer matches anything and the original text shows up instead.
`%s` / `%d` in a key are values filled in at run time and must appear in the translation too (`%1$s`, `%2$s` reorder them).

Shipped: `en`, `es`, `zh-Hans`, `zh-Hant`, `ja`, `fr`, `de`, `ru`, `pt`, `it`, `ko`, `nl`, `tr`, `pl`, `sv` and, since
1.1.8, `da` (Danish). Every language has the complete set of keys (the game-side `locales/*.lua` files were regenerated
in 1.1.8: a few admin command replies were only translated to English before).

**Adding your own language** (no build file needs to change):

1. Copy `html/js/i18n-en.js` to `html/js/i18n-<code>.js`, change the code in `I18N.add("en", {` and translate the values.
2. Copy `locales/en.lua` to `locales/<code>.lua`, change `Locales["en"]` to `Locales["<code>"]` and translate the values.
3. Add `'locales/<code>.lua'` to `client_scripts` in `fxmanifest.lua` (right after `'locales/da.lua'`).
4. Add the language to `Config.ExtraLanguages` in `config.lua`, e.g. `{ { code = 'no', name = 'Norsk' } }`. It then
   appears in the setup assistant and in Settings > General > Language, and `Config.DefaultLanguage = 'no'` is valid.

`/phonelang` (F8) prints which language the client is using and where it came from (config, admin panel, the phone).

## Integrations (garage, bank, society, housing, billing, dispatch)

The Garage, Wallet, Home, Bills and Services apps can work with the scripts your server already runs
(for example jg-advancedgarages, Renewed-Banking, ps-housing, esx_billing and common dispatch / MDT resources).
Set them in `Config.Integrations` (`'auto'` by default: the first supported resource that is started, otherwise the
phone's built-in behaviour). Nothing is a hard dependency: a stopped or failing resource falls back to the built-in
behaviour with one console warning.

- Full guide, supported resources and the provider interface: [`integrations/README.md`](integrations/README.md).
- Your own adapter: `integrations/custom.lua` (open in the escrowed build).
- The known providers in `server/integrations/*.lua` are also open, so you can adapt them.
- `/phoneintegrations` (admin or console) prints the active provider per category to the server console.

## Stolen / borrowed phones (optional)

`Config.StolenPhones.enabled = true` gives every phone item an owner (saved in the item metadata the first time
it is used). Whoever uses someone else's phone opens the owner's phone behind the owner's lock screen (passcode
only, Face Key never works for another person). Money, account settings, passcode, eSIM lines and reset are always
blocked on someone else's phone; what else is allowed (messages, social, calls, routing of incoming calls/SMS,
owner notification) is set in the same section. Needs ox_inventory or qb-inventory (per-slot metadata). Off by default.

## Physical SIM cards (optional)

`Config.PhysicalSim.enabled = true` moves the phone number onto a `sim_card` item that sits in the phone's SIM tray.
Move the SIM to another phone and the number goes with it; a phone without a SIM shows "No SIM" but still opens.
Photos, notes and settings stay with the phone. Insert / eject in Settings or by using the SIM card item; admins can
give cards with `/givesim [id] [number]`. Existing characters keep their number (it becomes a SIM inside their phone).
Turns on phone ownership too. Needs ox_inventory, qb-inventory, ps-inventory or lj-inventory and
`Config.RequireItem = true`. Add the `sim_card` item from `inventory_items.lua`. Off by default (can also be switched
in `/phoneadmin`, then restart `apex_phone`). One SIM per phone: the number in the phone in your hand is the one in use.

- **Contacts on the SIM** (`contactsOnSim = true`, the default since 1.3.0): the contacts live on the card as well, so
  whoever has the card in a phone sees them, and they survive a lost phone and a re-issued card. The first time a card
  is used with this on, the contacts of the account it belongs to are copied onto it (the phone keeps its own copy).
  `false` = contacts stay with the phone (the device owner's account), exactly as in 1.2.0.
- **Lost or stolen number** (`recover`, 1.3.0): a number belongs to the character it was issued to (shop, migration,
  starter SIM, eSIM card, `/givesim`). When that card is not in the player's hands any more (phone stolen, lost or
  destroyed), Settings > Mobile Service (PearOS) / Connections > SIM manager (Nova UI) shows **Recover my number**: the
  carrier cancels the old card for good and hands out a new SIM card with the same number (messages, calls and the
  contacts on the card come back), put straight into the phone in hand when its tray is empty. Whoever still has the
  old card loses the number at once and inserting it says "cancelled by the carrier". `price` (bank money, default 100),
  `free = true` (never charge), `blockOld` (cancel the old card for good; table `apex_phone_sims_blocked`),
  `enabled = false` (no player option). Admins: `/givesim [id] [number]` re-issues a number that belongs to that
  character for free (a number the player already has is refused). Export `RecoverSimCard(src, number)`; server event
  `apex_phone:simRecovered (src, number, oldIccid, newIccid)`; RPCs `psim.recoverable` / `psim.recover`.

## Radio app

A walkie-talkie inside the phone (`Config.Radio`, on by default). Players tune a frequency and talk to everyone on it
through your voice resource (pma-voice; SaltyChat and mumble-voip follow their public APIs and were not tested in game).

- Talk modes (`talkMode`): `'ptt'` hold to talk, `'toggle'` press to start / press to stop, `'open'` open mic with a
  mute toggle. `allowPlayerMode = true` lets each player choose.
- Default talk key: Caps Lock (`pttKey`), rebindable in the FiveM key settings.
- Restricted frequency ranges per job (and duty / ACE), private channels locked with a code, presets, callsigns,
  member list, optional earbuds or item requirement, radio animation.
- Exports: server `GetRadioChannel`, `SetRadioChannel`, `GetChannelMembers`; client `GetRadioFrequency`,
  `IsRadioTransmitting`, `GetRadioTalkMode`.

## Contact sharing

Share your contact card with nearby players from the phone, or with ox_target / qb-target ("Share contact" and
"Ask for contact" on other players). The receiver accepts or declines; each player chooses who may send them cards
(Everyone / Contacts only / Off). Settings in `Config.ContactShare`. Exports: `ShareContact(src, target)`,
`RequestContact(src, target)`; server event `apex_phone:contactShared`.

## Camera walking

`Config.CameraWalk = true` lets players walk, run and jump with the Camera app open (even with
`Config.AllowWalking = false`); looking around stays on dragging in the viewfinder.

## Wallpapers from links ("upload image")

There is no file picker inside the FiveM NUI, so images come in as links or by pasting:

- **Players:** Settings > Wallpaper > **Add image from link** (also the **Link** category of "Add new wallpaper" and the
  **Link** tile in the lock screen editor). Paste a direct image link (Discord, Imgur, Fivemanage, ...) and the phone shows a
  preview; "Use as wallpaper" applies it to the lock screen and the home screen. A copied image can also be pasted with
  Ctrl+V in that field: it is reduced like a photo, saved to Photos and used as the wallpaper.
- **Server owners:** `Config.Wallpapers` accepts links next to the file names: `'https://i.imgur.com/xxxx.jpg'` or
  `{ url = 'https://…', name = 'Los Santos' }`. Linked wallpapers appear in the wallpaper lists of both systems.
- `Config.WallpaperLinks = { enabled, hosts, maxLength, paste }` turns the player option off, restricts the hosts
  (`hosts = { 'cdn.discordapp.com', 'media.discordapp.net', 'i.imgur.com' }`) or forbids pasted images.

⚠️ Discord attachment links (`cdn.discordapp.com/attachments/...?ex=...`) expire after about 24 hours: the wallpaper stops
loading and the player has to paste a new link. For permanent wallpapers use files in `html/img/wallpapers/` or a permanent
image host (Imgur, Fivemanage, your own CDN).

## Photos from links (1.3.0)

The same door, in the Photos app: **Library > Add from link** (PearOS: the link button in the header and in the empty
gallery; Nova UI: Images > "..." > **Add from link**, and the empty gallery). The player pastes a direct https image link
or a copied image (Ctrl+V); the link is only accepted once the image really loads, and it is saved as a photo of the
gallery, so it can be shared, posted on Tweeter / Instashot, used as a contact photo or as a wallpaper. The photo info
sheet marks such photos as "External link".

`Config.PhotoLinks = { enabled, hosts, maxLength, paste }` has the same options as `Config.WallpaperLinks` (an old
`config.lua` without this table uses the WallpaperLinks values). `enabled = false` removes the option from Photos. The
`hosts` list is enforced by the **server** too (`photos.add` refuses other hosts with `{ error = 'host' }`), and it applies
to every link saved into a gallery, including a mail attachment or a received photo that is itself a link; with both
`PhotoLinks.enabled` and `WallpaperLinks.enabled` false the server refuses every http(s) link (`{ error = 'disabled' }`).
Discord attachment links expire after about 24 hours here too.

## Wallet transfers by number, server ID or citizen ID (1.3.0)

"Send" in the Wallet accepts a phone number, the server ID of a player who is online or a citizen ID (online or not;
read from the framework database). Before confirming, the phone asks the server who that is (`bank.resolve`) and shows
the name and what matched ("Number 555-0142", "ID 12", "Citizen ABC12345"); the transfer itself resolves the typed text
again on the server, so nothing is trusted from the client. The "I transferred you ..." text message is only sent when
the receiver has a phone number. Banking integrations (`Config.Integrations.bank`) keep receiving the citizen id and
the number as before (the number is `nil` when the receiver was given by ID and has no phone).

## Camera video

The VIDEO and TIME-LAPSE modes of the Camera app record the viewfinder for real (WebM, no sound unless
`Config.Camera.VideoAudio = true` and the FiveM CEF grants the microphone). The video goes to the same gallery as the
photos, with a small cover image for the grid, and plays inside the Photos / Gallery app. Videos can be shared with
AirShare / Quick Share (the other player gets a copy); Messages, Mail, the social apps and wallpapers only take photos.
Limits in `Config.Camera`: `VideoMaxSeconds` (default 15, the recording stops by itself), `VideoBitrate` (500 kbit/s),
`VideoHeight` (640 px), `VideoMaxBytes` (1.6 M base64 characters in the database per video). A 15 s video is about
1 MB in the `apex_phone_photos` table; the `Config.MaxPhotos` prune applies to videos too. On an existing install the
new `poster` column is added automatically at start (the server prints "missing column added").

## Vera AI assistant (optional)

Vera Chat uses the Google Gemini API. Without a key the rest of the phone works normally; only the Vera chat
and voice requests fail with a "no key" error. To turn Vera off completely set `Config.AI.enabled = false`.

1. Create a free API key at Google AI Studio (https://aistudio.google.com/app/apikey).
2. Put it in `server.cfg` (recommended, use `set` and never `setr`):
   ```
   set apex_phone_gemini_key "YOUR_KEY_HERE"
   ```
   or in `server/ai_key.lua` (`Config.AI.ApiKey`). The convar wins over the file.
3. Restart `apex_phone`.

Never put the key in `config.lua`: it is a shared script and every player downloads it.
Vera answers in the language of the asking player's phone (English, Spanish, German, ...), whatever language the
question was typed in.
Tune it in `Config.AI` (models, limits per player, voice wake word, `serverName` and `serverInfo`, the text the
assistant knows about your server). The free Gemini tier has a daily request limit; `Config.AI.voice.perDay` is a
server wide cap.

## Custom apps (an app of your own inside the phone)

Any resource can add an app to the phone. The app is a normal web page of your resource, shown inside the phone in an
iframe, and it talks to the phone with `postMessage`. Nothing of the phone has to be edited.

```lua
-- server, when your resource starts (it is re-sent to players who join later)
exports['Unique_Phone']:RegisterApp({
    id = 'myapp',                               -- letters, digits, _ - . : (up to 64)
    name = 'My App',
    url = 'nui://myresource/html/index.html',   -- your page (list it in your fxmanifest `files`)
    icon = 'nui://myresource/html/icon.png',    -- or { label = 'MA', color = '#FF9F0A' }
    category = 'Utilities', description = 'What it does', author = 'You',
    defaultInstalled = true,                    -- false = the player installs it from the AppShop
    job = 'police', minGrade = 2,               -- optional: only players with the job see the icon
    statusBar = 'auto',                         -- 'light' | 'dark' | 'auto' (status bar text colour over your page)
    wide = false,                               -- 1.1.8: true = on foldables the app gets the whole inner screen
})
```

**Size of your app (the question everybody asks).** The phone is drawn at a logical size and then scaled as a whole
with a CSS `transform` (`Config.Scale`, and Settings › Display on each phone). Your iframe therefore always sees the
same CSS pixels, whatever the player's scale: you never have to read the scale. The container is the full screen of the
device (the status bar is drawn over the top 68 px, the home indicator over the bottom 34 px: keep your own padding there):

| Device | `wide = false` (default): what your page sees | `wide = true` |
|---|---|---|
| PearPhone 18, NOVA S26 (every normal phone) | 440 × 956 | 440 × 956 |
| NOVA Fold8 closed | 440 × 956, centred on the 670 px outer screen | 670 × 956 |
| NOVA Fold8 open | 440 × 956, centred on the inner screen | 1340 × 956 |
| PearPhone Fold closed (PearOS draws apps 1.45× larger on the outer screen) | 356 × 659 | 294 × 659 (the side rail is reserved) |
| PearPhone Fold open (apps drawn 1.25× larger) | 356 × 659 | 868 × 765 |

These are `window.innerWidth × innerHeight` inside your page, measured in 1.1.8. So: design for **440 × 956** with
relative units (`%`, `vw`/`vh`, flexbox/grid) inside your own page and let it breathe a little; do not use
`transform: scale()` on your side. With `wide = true`, lay out for a width that can change and listen to your own
`window` `resize` event (the iframe is resized when the phone folds or unfolds) or to the `size` message below.

**What your page receives** (`window.addEventListener('message', e => e.data.apexphone …)`):

- `init` when it opens: `{ theme, dark, accent, player, account: { username, phone, avatar }, app,
  screen: { w, h }, form: 'bar' | 'fold', foldOpen, os: 'ios' | 'android', model }` (`screen`, `form`, `foldOpen`,
  `os`, `model` since 1.1.8).
- `size` (1.1.8) whenever the container changes: `{ screen: { w, h }, form, foldOpen, os, model }`.
- `theme` `{ theme, dark, accent }`, `player` `{ player }`, `resume` and `pause` (switcher), `rpc` `{ id, result }`,
  `contacts` `{ list }`, `location` `{ coords }`, `auraCommand` (a Vera command you registered).

**What your page can send** (`window.parent.postMessage({ apexphone: '…', … }, '*')`):

- `notify { title, msg }`, `toast { msg }`, `close`, `openApp { id }`, `setWaypoint { x, y, name }`,
  `call { number, name }`, `message { number, name }`.
- `getPlayer`, `getContacts`, `getLocation` (the last two ask the player's permission the first time).
- `rpc { name, data, id }` for the server RPCs listed in `Config.ExternalApps.rpc` (`contacts.list`, `photos.list`,
  `messages.send`, `bank.info`, `player.get`, `services.list`); the sensitive ones need the player's consent, which the
  server records.
- `widget { id, name, size, template: 'stat' | 'list' | 'progress' | 'text', data }` for a home-screen widget, and
  `activity { op: 'start' | 'update' | 'stop', id, title, subtitle, icon, progress, eta, state }` for a live activity in
  the Dynamic Island.
- `vera { pattern, reply }` to answer a sentence said to Vera (up to 20 per app).
- `typing { on }` (1.2.0): tell the phone that a text field of your page got (`true`) or lost (`false`) the focus.

**Keyboard inside your app (1.2.0).** With `Config.AllowWalking` / `Config.KeepVoice` the game keeps receiving the
keyboard while the phone is open, so letters typed into a field of your page could also fire the game's key mappings
(T opened the chat, M closed the phone...). The phone cannot see inside your iframe (it is another origin), so by default
it locks the keyboard for the game **for as long as your iframe has the focus**: typing is safe, and walking resumes as
soon as the player taps outside your app or closes it. If you prefer the player to keep walking while your app is open,
send `typing` yourself from your page and the phone will lock the keyboard only while one of your fields is focused:

```js
const tell = on => window.parent.postMessage({ apexphone: 'typing', on }, '*');
const isField = el => el && (el.matches('input, textarea, select') || el.isContentEditable);
document.addEventListener('focusin',  e => { if (isField(e.target)) tell(true); });
document.addEventListener('focusout', () => setTimeout(() => tell(isField(document.activeElement)), 50));
```

The phone's own look (fonts, colours, radii) is not injected into your page: style it yourself, and use `init.dark` /
`init.accent` to follow the player's theme.

## Exports (short list)

Server:

```lua
exports['Unique_Phone']:SendMail(citizenidOrNumber, { sender = 'Fleeca', subject = 'Receipt', body = '...' })
exports['Unique_Phone']:CreateBill(citizenidOrNumber, { senderName = 'LSPD', amount = 350, reason = 'Fine', society = 'police' })
exports['Unique_Phone']:SendNotification(src, { app = 'bank', title = 'Bank', msg = 'Payment received' })
exports['Unique_Phone']:SendMessage(fromNumber, toNumber, 'text')
exports['Unique_Phone']:GetNumber(citizenid) / GetCitizenId(number) / GetSourceByNumber(number)
exports['Unique_Phone']:OpenApp(src, 'messages') / ClosePhone(src) / IsPhoneOpen(src)
exports['Unique_Phone']:RegisterApp({ id = 'myapp', name = 'My App', url = 'nui://myres/html/index.html', icon = { label = 'MA', color = '#FF9F0A' } })
exports['Unique_Phone']:GetFramework()   -- 'qb' | 'qbx' | 'esx' | 'standalone'
-- 1.1.8: another phone system / SIM database / billing next to the phone
exports['Unique_Phone']:SetNumber(citizenidOrSrc, '555-0123', 'my_system')   -- true | false, 'format'|'same'|'noaccount'|'taken'|'db'
exports['Unique_Phone']:GetDeviceSerial(src)        -- 'APX-XXXX-XXXX-XXXX' of the device in use (needs Config.StolenPhones or Config.PhysicalSim)
exports['Unique_Phone']:GetDeviceLocations(citizenid)   -- { { item, label, serial, x, y, z, open }, ... } devices of the character held by online players
exports['Unique_Phone']:GetPlayerLines(src) / GetPlayerSim(src) / GetSimInDevice(serial) / GiveSimCard(src, number)
```

Server events: `apex_phone:accountCreated` (cid, number, src), `apex_phone:numberChanged` (cid, old, new, by),
`apex_phone:callStarted` / `callAnswered` / `callEnded`, `apex_phone:messageSent`, `apex_phone:billPaid` / `billRefused`.
A new account's number can come from your own system: `integrations/custom.lua` → `Custom.number.assign(cid, src)`
(see `integrations/README.md`, section 9). Bills from your own billing script: `Custom.billing`.

Client:

```lua
exports['Unique_Phone']:OpenPhone() / ClosePhone() / IsPhoneOpen() / OpenApp(id)
exports['Unique_Phone']:GetPhoneNumber() / StartCall('555-1234') / SetWaypoint(x, y, name)
exports['Unique_Phone']:SendNotification(app, title, msg)
```

Item exports used by the inventory: `apex_phone.useDevice`, `apex_phone.useEarbuds`, `apex_phone.useSlateBuds`,
`apex_phone.useEsim`.

## Troubleshooting

- **Portuguese text shows up on my server (blip "Loja de telemóveis", a notification, a label):** the source language of
  the phone is Portuguese and a text falls back to it when the active language has no entry for it. Since 1.1.8 an
  unknown language code (`Config.DefaultLanguage = 'dk'`, an old account saved with a code that does not exist) falls
  back to English instead of Portuguese, the shop blip and the vendor prompt follow the phone language (and are renamed
  when it changes), every `locales/*.lua` carries the full key set, and Danish is included. If a Portuguese text still
  appears: it is a key missing from `html/js/i18n-<code>.js` (inside the phone) or `locales/<code>.lua` (in-game); add
  the Portuguese text as the key with your translation as the value, and tell us so we ship it. Never translate the
  keys themselves.
- **The phone does not open:** the player needs one of the device items (`Config.RequireItem = true`). Check the
  item names in your inventory match `Config.Devices`. Give one with `/phonegive`.
- **Old key still opens something else / F1 does nothing:** FiveM stores key binds per command name in each
  player's profile. The key can be changed in Settings > Key Bindings > FiveM.
- **No framework detected (console warning at start):** start `apex_phone` after your framework, or force `Config.Framework`.
  Since 1.1.5 the phone keeps waiting (up to 10 minutes, with a warning every minute) and attaches itself the moment
  the framework starts, so a wrong start order only delays the phone instead of leaving it without a framework.
- **The phone shows the setup assistant ("Hello") again after a restart, as if it had been reset:** fixed in 1.1.5.
  Right after a restart the database can be busy with the schema checks and the first `account.get` could time out;
  the phone read that as "no account" and opened the assistant. Finishing it never overwrote the real account (it was
  restored with a toast), but it looked like a reset. The phone now opens the assistant only when the server explicitly
  answers that the character has no account; a slow or missing answer makes it wait and retry. The start-up schema
  checks also run in two queries instead of about a hundred, so the database is ready much sooner.
- **Database errors on start:** make sure `oxmysql` starts first and the database user can `CREATE` and `ALTER` tables.
  The full schema is in `installation/apex_phone.sql` (reference / manual install): every statement is
  `CREATE TABLE IF NOT EXISTS`, so it is safe to run on an existing database. Running it is optional, the resource
  creates and migrates the tables by itself on start.
- **Tapping Instashot, Tweeter (or Match, Marketplace, Maps, Eats, Services, Weather, Recado) does nothing, no error:**
  before 1.1.7 those apps asked for their permissions (photos, camera, location, contacts) when opened, and one
  "Don't allow" was saved in the account and blocked the app from opening for good: the tap only showed a 2-second
  toast at the bottom ("No access to Photos. Turn it on in Settings > Privacy"), easy to miss, and on a foldable's
  cover screen even more so. Since 1.1.7 a refused permission never blocks the app (like a real phone: the app opens,
  only that feature is unavailable); the player can still change it in Settings › Privacy. Players already affected
  are unblocked by the update without doing anything.
- **Instashot / Tweeter / Reels show "Create account" again, "Name in use", or an empty feed with no error:** that was
  the phone hiding a server answer such as "database still starting" or "too many requests" (1.1.5 and older).
  Since 1.1.6 the apps show the reason with a retry button. If it keeps happening, open the server console: an RPC
  error is printed there in red with the SQL message.
- **No call audio:** check `Config.Voice` and that your voice resource starts before `apex_phone`. Type `/phonevoice`
  in game: it prints the detected voice system, the call channel and, with pma-voice, whether `voice_enableCalls` is on.
- **"At times the voice stops working" / a call has no sound once in a while (1.1.7 and older):** three causes, all
  fixed in 1.1.8. (1) The client kept an old call marked active when its "ended" message was lost, so every later call
  skipped the voice channel until the player relogged: the client now follows the server's call state (a watchdog
  compares both every 2 s and re-joins or leaves the channel; the server answers `calls.sync`). (2) pma-voice could
  ignore the `addPlayerToCall` request (sent before the player was ready, `voice_enableCalls` off): the phone now
  verifies the channel was taken and retries twice, then prints the reason in F8. (3) With `Config.KeepVoice` the game
  kept receiving the keyboard while the player typed in the phone, so letters reached the game's key mappings: `T`
  opened the chat, and the chat, when closed, took the NUI focus away from the phone (no ESC, no push-to-talk). The
  phone now tells the game when a text field is focused and takes its focus back if another resource drops it.
- **The phone sometimes does not open or does not close (cursor stuck):** usually the NUI focus was taken by another
  resource (see above), or the shop / admin layer stayed marked open after the page closed it. Both heal themselves in
  1.1.8 (focus watchdog, ghost-overlay reset when the phone is opened), and `/phonefix` resets everything at once.
- **Nobody can talk while the phone or the phone shop is open:** that is `Config.KeepVoice = false` (or a 1.1.3 or
  older build). With `Config.KeepVoice = true` (default since 1.1.4) the push-to-talk key keeps working with the
  phone and the shop open; the player just cannot move while the phone is open unless `Config.AllowWalking` is on.
- **Props invisible or the client freezes:** do not run another resource that streams the same models
  (`apex_pear18_*`, `apex_s26_*`, `apex_fold_*`, `apex_airpod_*`, `apex_slate_*`, `apex_esim_card`).
- **Map tiles do not load:** the Maps app downloads tiles from the internet (`Config.Map.tileUrl`); GPS and
  waypoints still work offline.
- **Vera does not answer:** set the Gemini key (see above) and check the server console for the API error.
- **Shop item missing:** run `phoneshop_items` in the server console; it lists catalogue items that do not exist
  in the inventory.
- **QBCore: the phone item shows its picture in the "item received" box but the inventory slot is blank:** qb-inventory
  (and ps-/lj-/qs-inventory) load the icon from their own `html/images/<image>`; a `nui://Unique_Phone/...` address or a
  PNG that was never copied there gives a blank slot. Run `phoneitems` in the server console: it names the item and the
  fix, and copies the missing PNGs itself (then `restart qb-inventory`). See "Inventory items".
- **Nobody hears a phone ringing / the speaker button does nothing:** `Config.WorldSounds` (1.2.0) must be enabled;
  the ringing phone must not be on silent. The speakerphone needs pma-voice or mumble-voip (SaltyChat keeps its own
  phone speaker). `phonesounds` in the server console shows the state and who is listening.
- **Alt does not look around:** since 1.2.0 the phone page itself listens for Alt, so it works whatever
  `Config.AllowWalking` / `Config.KeepVoice` say; if you changed `Config.LookKey` to another key, that key only works
  through the FiveM key mapping (Settings › Key Bindings) and only when the game receives the keyboard.
- Turn on `Config.Debug = true` and read the server console and F8 for details.

## Known limitations

- Videos are recorded without sound by default (`Config.Camera.VideoAudio`), are not sent through Messages, Mail or
  the social apps (only AirShare / Quick Share), and the game cursor can appear in the recording if it crosses the
  middle of the screen while recording.
- Voice messages depend on the FiveM CEF granting microphone access.
- Recado video calls are simulated and messages are not end to end encrypted (they are stored in the database).
- Fonts included in `html/fonts/` are licensed under the SIL Open Font License 1.1 (license files next to them).

## Changelog

### v1.3.0
- Fixed: "I can't post on Tweeter". Tweeter, Instashot and Reels sent the whole photo (100-260 KB of base64) inside a
  single `social.post` network event, which FiveM drops: the request never reached the server, the phone waited 10 s and
  said "Not posted". Only text posts worked. A post now references the gallery photo (`photoId`; the server copies the
  image from the player's own gallery, ownership checked), the response never carries the image back, and the feed
  keeps reading images in chunks as before. Clear messages for a photo that is no longer in the gallery, a video, or a
  server that did not answer.
- New: Photos > Library > **Add from link** on both systems (`Config.PhotoLinks`), with the host whitelist now enforced
  by the server as well (`photos.add`). See "Photos from links".
- New: Physical SIM — **Recover my number** (`Config.PhysicalSim.recover`): a lost or stolen number is re-issued on a new
  card, the old card is cancelled for good (`apex_phone_sims_blocked`), `/givesim [id] [number]` re-issues for the
  rightful owner, export `RecoverSimCard`, event `apex_phone:simRecovered`.
- New: Physical SIM — **contacts on the SIM** (`Config.PhysicalSim.contactsOnSim`, on by default): the contacts follow
  the card (and survive a re-issue); the account's contacts are copied onto the card the first time it is used.
- New: Wallet transfers accept a phone number, a server ID or a citizen ID, with the receiver's name shown before
  confirming (`bank.resolve`). See "Wallet transfers".
- Admin panel: the new Physical SIM options (contacts on SIM, recovery on/off, price, cancel old card).

### v1.2.0
- New: a valet brings the vehicle. "Request Delivery" in the Garage app (`Config.GarageDelivery.mode = 'valet'`, the
  default) creates the vehicle on a road out of sight and a valet NPC drives it up to the player, gets out and walks
  away; the phone announces the arrival. When the valet cannot reach the player (blocked road, no path, player kept
  moving) the vehicle is moved to the nearest free road and the phone says so. `mode = 'road'` keeps the 1.1.9
  behaviour. `phonedelivery` prints the mode.
- New: phones are heard around them (`Config.WorldSounds`). The ringtone, message / notification chimes and alarms of
  a phone play for the players nearby, fading with distance; a phone on silent makes no sound for anybody.
- New: real speakerphone. The "Speaker" button of a call (it was cosmetic) puts the players within
  `Config.WorldSounds.speakerRange` metres on the call channel while they stay close (pma-voice / mumble-voip), so they
  hear the other side and can answer; they are taken out when they walk away, when the speaker is turned off or when
  the call ends. Players already in a call are never pulled in. `phonesounds` shows who is listening.
- Fixed: the look-around key (`Config.LookKey`, Alt) did nothing while the mouse was over the phone or with
  `Config.AllowWalking` and `Config.KeepVoice` off: the key mapping only fires when the game receives the keyboard.
  The phone page now listens for Alt itself and both paths share the same logic.
- Fixed: typing in a custom app (an iframe registered with `RegisterApp`) reached the game's key mappings. The phone
  now locks the keyboard for the game while the iframe has the focus, and apps that send `{ apexphone: 'typing', on }`
  get fine-grained control (see "Custom apps").
- Fixed: QBCore without ox_inventory, blank item icons in the inventory. New `installation/qb-core_items.lua` (paste
  into `qb-core/shared/items.lua`), and on start the phone checks every item (exists, `useable`, `image` is a file
  name) and copies missing PNGs into the inventory's `html/images/` folder (`Config.InventoryImages`); `phoneitems`
  repeats the check and prints the fix for anything wrong.

### v1.1.9
- Fixed: "Post" in the Tweeter composer never published. The Photo / counter row of the composer used a class that is also
  the root of the admin panel (a hidden full-screen layer), so the tap never reached the button. Posts with accents or
  emojis are no longer refused by the database (text is cut by characters, not bytes), and a post is never reported as
  failed because its reply notification failed.
- Fixed: typing in a phone text field could reach the game (the open/close key closed the phone on "M", T opened the
  chat, WASD walked). Another resource re-enabling the game input no longer leaks keys; the open key is ignored while
  a field is focused (Esc still closes); the phone re-sends its typing state whenever it opens.
- Fixed: sheets with content under the text field (the Tweeter composer) hid that content behind the on-screen
  keyboard. A sheet now rises above the keyboard; a sheet taller than the space shrinks and scrolls.
- New: `Config.LookKey` (left Alt): hold it to look around with the mouse while the phone is open.
- Changed: `Config.AllowWalking` defaults to `true`; jumping no longer re-taps the last focused button.
- New: "Request Delivery" in the Garage app (`Config.GarageDelivery`): the stored vehicle is brought to the nearest free
  road with its keys, on ESX / QBCore / QBox and every supported garage (OneSync required). `phonedelivery` console
  command explains the state.
- New: open song search in the Music app and the story music sticker (`Config.Music.Search`): any YouTube song or a
  pasted link, no API key; a video that refuses to play outside YouTube is swapped for another version.
- Fixed: "ResizeObserver loop limit exceeded" and "ScriptProcessorNode is deprecated" lines in the F8 console.
- Changed: small phone tables (up to 5000 rows) created by older versions outside utf8mb4 are converted on start.

### v1.1.8
- New: Danish (`da`) as the 16th language, phone and in-game texts.
- New: `Config.ExtraLanguages` to add a language of your own with two readable files (see "Languages"). An unknown
  language code now falls back to English instead of Portuguese.
- Fixed: the phone shop blip could stay "Loja de telemóveis" (Portuguese) on a server in another language: it was
  named once, when the player joined, before the phone had said its language, and it ignored `Config.Shop.blip.label`
  / a shop's `blipLabel` only in the admin panel. The blip and the vendor prompt now follow the phone language, are
  renamed when it changes, and `Config.Shop.blip.label` is documented in `config.lua`.
- Fixed: the in-game dictionaries (`locales/*.lua`) of 14 languages lacked the replies of the `/phonewipe` admin
  command and a generic "Error: %s"; those came out in Portuguese. Regenerated with the complete key set.
- Fixed: system notifications of the social apps, Zapp, groups and Messages ("@ana replied to you", "liked your post",
  "started following you", "%s added you to the group", "Missed group call", "You've been invited to a group call",
  "%d unread messages in %d conversations"...) were never translated: those apps' notifications are treated as player
  content (names and message text), and the system phrases were excluded with them. The server now marks the system
  parts (`data.sys`) and the phone translates them in every language. The Eats and Marketplace "items delivered"
  notices and the `/phonewipe` chat lines are translatable too.
- Fixed: a few phrases were built in code and leaked Portuguese in every language: the alarm countdown ("in 13 hours
  **e** 4 minutes"), group names made from member names ("Ana, Rui **e** Mãe", "**e mais** 3") and "you" in group
  events; and the sample content a new phone starts with (two notes, three reminders, two calendar events and the
  07:30 alarm) was written in Portuguese and, being player content, never translated afterwards. It is now created in
  the phone's language.
- Fixed: calls that "at times" had no voice (ESX + pma-voice report). The client follows the server's call state
  (`apex_inCall` state bag, `calls.sync` RPC, 2 s watchdog) instead of trusting that every `callState` push arrives;
  an `addPlayerToCall` that pma-voice did not take is retried twice and then explained in F8; the voice session can no
  longer stay stuck if a native throws while the volumes of muted players are restored; a stuck "busy" line heals
  itself on the server.
- Fixed: typing in the phone reached the game's key mappings (chat, inventory...) because the page never sent the
  `typing` signal the client expected since 1.1.4 (`Config.KeepVoice`). The page now reports focused text fields (and
  fields removed while focused), and the phone restores its NUI focus when another resource drops it. A shop/admin
  layer left marked open no longer blocks the phone from opening.
- New: `/phonefix` for players and support: resets a stuck phone (layers, focus, camera, voice, pending device request,
  pose) without a restart, and lists what it reset in F8.
- New (custom apps): the `init` message carries the container size, form factor, fold state, OS and model, a `size`
  message follows every fold/unfold, and `RegisterApp({ wide = true })` gives the app the whole inner screen of a
  foldable. The README has a "Custom apps" section with the sizes and the full message list.
- Fixed: a post refused by the server on Instashot / Tweeter said only "Try again"; a missing profile on that network is
  now named, and the server's reason is printed in F8.
- New (integrations): `SetNumber(citizenidOrSrc, number, by)`, `GetDeviceSerial(src)`, the `number` integration category
  (`Custom.number.assign(cid, src)` in `integrations/custom.lua` gives a new account its number from your own system),
  server events `apex_phone:accountCreated` and `apex_phone:numberChanged`. `/phonenumber` uses the same code path.

### v1.1.7
- Fixed: "everything works except the social apps" / "the social apps don't work on the foldable". Instashot and
  Tweeter ask for their permissions (photos, and camera for Instashot) the first time they open; tapping "Don't allow"
  was saved in the account and from then on the app refused to open at all, with only a brief toast at the bottom of
  the screen. The same applied to every app with permissions (Match, Marketplace, Maps, Eats, Services, Weather,
  Recado). A refused permission no longer blocks opening the app: it opens, the player is told once per session which
  access is missing, and Settings › Privacy still controls it. Features that really need the access (camera for
  stories and DMs, microphone, a location request) keep asking when used.
- Verified on the PearPhone Fold and NOVA Fold8 (cover screen and open) with the browser harness: Instashot
  (feed, Reels, Messages, Explore, Profile, post detail, post menu, new message) and Tweeter (feeds, post detail,
  new post with keyboard, search, notifications, profile) render and respond like on the PearPhone 18; the CSS and JS
  were also swept for features newer than the game's Chromium 103 (none in use).

### v1.1.6
- New: `installation/apex_phone.sql`, the full schema (81 tables) generated from the server scripts, for people who
  want to review or run the SQL themselves. Optional: the resource keeps creating and migrating the tables on start.
- Fixed: the social apps (Instashot, Tweeter, Reels) treated a server error on `social.profile` or `social.feed`
  ("database still starting" right after a restart, "too many requests", an internal error) as "no profile" / "no
  posts": the player landed on "Create account", got "Name in use" when trying, or saw an empty feed, with nothing
  explaining why. They now show the reason and a retry button, and "Name in use" is only shown for a taken or
  invalid name.

### v1.1.5
- Fixed: "the phone keeps resetting after a restart" (reported on ESX, possible on every framework). After a restart
  the first `account.get` could come back empty (client timeout while the database was busy with the start-up schema
  checks, or the framework not resolving the player yet) and the phone treated "no answer" as "no account" and opened
  the setup assistant. Now the assistant opens only on an explicit "this character has no account" answer from the
  server; a timeout, `noplayer` or `db` answer makes the phone wait and retry (silently while the character is still
  loading, with the "No connection" sheet for real outages). The RPC timeout on the client is now reported as an
  error instead of an empty answer.
- Fixed: after a restart of `apex_phone` with players in game, the players already loaded got no `session` push and no
  account pre-load (only the standalone mode did that). Every framework now re-sends the sessions of the players who
  are already in game about 2 s after the start.
- Fixed: the framework detection gave up after 60 s. It now waits up to 10 minutes and also hooks `onResourceStart`
  of `qb-core` / `qbx_core` / `es_extended`, so a framework that starts after the phone (or is restarted while the
  phone is running) is picked up immediately; a restarted framework has its core object renewed instead of leaving
  dead function references.
- Performance: the start-up schema checks (missing columns, column widths, indexes, the PIN hash columns) read the
  `information_schema` once for all phone tables (two queries) instead of about a hundred single queries. On shared
  database hosts this took tens of seconds and was what made the first `account.get` time out.

### v1.1.4
- Fixed: the Camera app's VIDEO mode saved a single still frame, so "videos" showed up as photos in the gallery. The
  viewfinder is now recorded for real (WebM) and plays in the Photos / Gallery app; videos get a cover image in the
  grid, can be shared with AirShare / Quick Share and are kept out of the photo pickers. New `Config.Camera.Video*`
  limits and a new `poster` column in `apex_phone_photos` (added automatically on start).
- Fixed: no voice with the phone or the phone shop open. With `Config.AllowWalking = false` the NUI took the keyboard
  away from the game, so the push-to-talk key never reached pma-voice / SaltyChat / mumble-voip: players could not talk
  on a call while looking at the phone, nor while buying a phone. New `Config.KeepVoice = true`: the game keeps the
  keyboard for push-to-talk only (every other control is disabled while the phone or the shop is open).
- New: `/phonevoice` prints the detected voice system, the active call channel and the pma-voice state to F8.
- New: wallpapers from image links ("upload image"). Players can paste a direct link (Discord, Imgur, ...) or a copied
  image in Settings > Wallpaper > "Add image from link" (and in the wallpaper pickers); server owners can list links in
  `Config.Wallpapers`. `Config.WallpaperLinks` controls the option. See "Wallpapers from links".

### v1.1.3
- New: `Config.Currency` (symbol, position, separators). The phone no longer shows a fixed `€`: Wallet, Bills,
  Marketplace, Eats, Onion/crypto, work apps, the phone shop and the server notifications use the configured
  currency (default `$`). Existing shop settings saved in the admin panel are kept.
- Fixed: Vera Chat always answered in Portuguese. It now answers in the language of the player's phone, and its
  error messages ("wait a few seconds", "no key", ...) are shown in that language too.
- Fixed: server console and F8 diagnostic messages were in Portuguese; they are in English now. Admin command
  replies (`/phonereset`, `/testnotif`, `/phonewipe`, ...) print in English in the server console and are still
  translated into each player's language in game.
- Fixed: choosing interests in Match did not work when the phone was in another language (the chips were read
  back as translated text); the Recado pin icon had the same problem.

### v1.1.2
- Fixed: the language chosen in the admin panel ("Language of new accounts") did not reach the phone.
  The panel's choice is published to every client a moment after the resource starts, but the phone
  asked for its defaults before that and kept the `config.lua` value: a server whose `config.lua`
  says `'es'` and whose panel says `'en'` started every new phone in Spanish, and the in-game
  notifications followed. The phone now takes the panel's value at start and again whenever an admin
  changes it; a setup assistant that is already open switches to the new language unless the player
  has picked one.
- New: `/phonelang` in F8 prints which language this client uses and where it comes from (the phone's
  own setting, the value saved on this client, the admin panel, `config.lua`).

### v1.1.1
- Fixed: the Phone Shop panel (`/phoneadmin`) refused every save with "Valor inválido em
  categories[6].icon": the eSIM category that ships in `config.lua` uses an icon name the server's
  check did not know, so nothing in the shop (locations included) could be saved. Any short icon
  name is accepted now.
- Fixed: error messages coming from the server were shown in Portuguese whatever the panel's
  language. They are translated like the rest of the panel.
- Improved: text fields in the admin panel show the translation of the Portuguese defaults from
  `config.lua` (seller role and greeting, category names, taglines, blip labels) in the panel's
  language; the original is kept until the admin types something else.

### v1.1.0
- New: integrations layer for garage, bank, society accounts, housing, billing and dispatch / MDT resources, with a
  buyer adapter (`integrations/custom.lua`) and documentation (`integrations/README.md`).
- New: Radio app (walkie-talkie) with push-to-talk, toggle and open-mic modes, restricted and private frequencies.
- New: contact sharing between nearby players (phone share sheet and ox_target / qb-target).
- New: physical SIM cards (`sim_card` item, optional) and stolen / borrowed phone ownership (optional).
- New: walking with the Camera app open (`Config.CameraWalk`).
- Improved: performance and many fixes across the apps; translations updated in all 15 languages.

### v1.0.0
- First release.

(c) Apex Scripts. All rights reserved.
