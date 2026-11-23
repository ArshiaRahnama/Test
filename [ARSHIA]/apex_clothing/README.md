# Apex Clothing Studio

**An in-game clothing texture designer for FiveM.** Players open a full editor on
their own character, design a texture on a layer-based canvas (brush, text,
shapes, fills, patterns, images **and AI generation**), watch it update **live in
3D** on the ped, then export it as a real `.ytd`, a drop-in resource, or apply it
live to everyone on the server - **without OpenIV, CodeWalker or Blender**.

Works on **ESX Legacy, QBCore, QBox and standalone**. **No database required.**

---

## ✨ Features

- **Isolated 3D preview** - the garment renders in real time (three.js) and updates
  the instant you paint. Orbit with the mouse, scroll to zoom.
- **Layer-based 2D editor** - brush (with symmetry / spray / marker), eraser,
  text (curved + many fonts), shapes, fill, pattern, eyedropper, image upload &
  paste. Reorder, hide, lock, duplicate, opacity, shadow, precise positioning.
- **Region selection tool** - rectangle, ellipse, free lasso and a magic wand,
  with add/subtract, feather, grow/shrink, invert and select-all. Every tool
  obeys it: the brush and eraser are clipped to the region, and you can delete,
  fill, copy/cut to a layer, download it as a PNG or generate AI **inside** it.
- **Texture manager** - a garment's textures (A, B, C…) are now editable:
  **create** a blank one, **duplicate** the one you're on, **rename** it (the
  in-game `txn`) and **delete** it. Each texture keeps its own layer stack, and
  the catalog is written back to `templates.json` so it survives a restart.
- **AI texture generation** - describe what you want ("blue camo with flowers")
  and it generates straight onto the garment. Bring-your-own-key. Default provider
  is **Google Gemini (free tier)**; fal.ai / Together / OpenAI / custom supported.
  Three targets: the **whole garment**, **inside a selected region**, or a
  **free image/logo** you can move, scale and download as a PNG. Plus a negative
  prompt, seamless-tile and background-cutout options, prompt starter chips, a
  dice button and up to 4 variations per run.
- **Quick AI Fit** - one click applies a themed texture (graffiti, camo, monogram,
  synthwave, denim…). 17 built-in themes, fully editable in the config.
- **Projects & community gallery** - save designs, reopen them, share by code, or
  publish to an in-server gallery. Persisted as plain JSON - **no SQL**.
- **Three export modes** - see [Exporting](#-exporting-your-designs).
- **Framework aware** - auto-detects ESX / QBCore / QBox, falls back to standalone.
- **Access control** - five stackable methods: everyone, ACE, framework groups,
  jobs, or a hand-picked identifier list. `/clothingstudio_access` explains any
  denial.
- **Full i18n - 9 languages, all 100%** - English, Português (PT), Português
  (BR), Español, Français, Deutsch, Italiano, 日本語, Türkçe. Each player picks
  their own with `/clothingstudio_lang`.
- **Zero external dependencies at runtime** - three.js, the icon font and every
  web font are self-hosted, so the studio works behind a firewall.

---

## 📦 What's in the package

| Resource | Purpose | Ship it? |
|---|---|---|
| `apex_clothing` | The studio itself (editor, AI, **live + package export** - fully self-contained). | **Required** |

> **Live** exports need nothing else - they broadcast runtime textures to every
> client and persist inside `apex_clothing/data/`. **Package** exports generate a
> brand-new standalone resource under `exports/<name>/` that you drop into
> `resources/`. **.ytd** files you build can be streamed from `apex_clothing`'s
> own `stream/` folder (or any resource you like).

---

## ✅ Requirements

- FiveM server artifacts **build 5104+**.
- A framework (ESX / QBCore / QBox) **or** none (standalone works out of the box).
- **For importing your own clothing and building `.ytd` files:** [Node.js](https://nodejs.org)
  on the machine that runs the tools (any modern version). `curl` is used too - it
  ships with Windows 10+/11 and Linux. *You do not need Node on the game server - only on the PC where you run the `tools/` scripts.*
- **Nothing else.** No database, no oxmysql, no external web panel.

---

## 🚀 Installation

1. Drop `apex_clothing` into your server's `resources/` directory.
2. Add to `server.cfg` (order matters - after your framework):

   ```cfg
   ensure apex_clothing
   ensure apex_clothing_models      # created by tools/convert.js - see "Importing" below

   # (Optional) AI - get a FREE Gemini key at https://aistudio.google.com/apikey
   set apex_clothing_ai_key "AIza..."
   ```
3. Open the studio in-game with **`/clothingstudio`** (configurable).

> The resource ships **empty of garments** on purpose - the editor's Templates tab
> is blank until you import clothing (next section). This keeps the package clean
> and free of copyrighted game files.

---

## 👕 Importing your own clothing (Templates)

The browser can't read the game's `.ydd`, so each garment is converted once to a
web `.glb` (+ its texture `.png`). A bundled tool does it automatically, entirely on
your machine - **no OpenIV, no Blender, no login, no internet.**

1. Put your garment source files under **`templates/`**, e.g.
   `templates/models/female/jbib/mp_f_freemode_01^jbib_013_u.ydd`
   together with their texture `.ytd` files. (Naming: `<collection>^<drawable>`.)

   **Or keep them anywhere on your PC** and point the converter at that folder - nothing gets copied and the originals are never modified:

   ```bash
   node convert.js --src "C:\Users\me\Desktop\Roupa"
   ```

   To make a plain double-click of `convert.bat` find it every time, add the
   folder to **`tools/sources.txt`** (one path per line).
2. Run the converter on that machine:
   - **Windows:** double-click `tools/convert.bat`
   - **Linux/Mac:** `bash tools/convert.sh`
   - **Any OS:** `cd tools && node convert.js`
3. It reads each `.ydd`/`.ytd` directly, writes the `.glb` + texture `.png` into
   a **model pack** resource next to `apex_clothing` (`apex_clothing_models/`),
   and updates `templates.json`. Re-run any time to add more - already-converted
   items are skipped. (Only a file the reader cannot decode is sent to a hosted
   converter as a fallback; see `tools/README.md`.)
4. Upload `templates.json` **and the pack folder(s)** to the server (the pack
   goes in `resources/` next to `apex_clothing`), add `ensure apex_clothing_models`
   to `server.cfg`, then `refresh` + `ensure apex_clothing_models` +
   `restart apex_clothing`. The converter prints the exact lines.

> **Why separate "model pack" resources?** FXServer bundles everything in a
> resource's `files{}` into one archive per resource, and that archive cannot
> address anything past **2 GiB**. A whole clothing pack converted into one
> resource crossed it, the archive came out corrupt, and the **game client
> crashed** (`vfs-core.dll`) the moment the studio opened. Packs are capped at
> 1 GB each (`--pack-mb` to change); when one is full the converter starts
> `apex_clothing_models2`, and so on. Each pack is a plain resource with only a
> `fxmanifest.lua` and a `models/` folder - no scripts.
>
> **Upgrading from 2.1.5 or older?** Your models may still sit in
> `apex_clothing/stream/models/`. Run the converter once: it moves them into
> packs and rewrites `templates.json`. Nothing is re-converted. **Since 2.1.6
> that folder is no longer served to the studio at all** (2.1.5 still listed it
> in `files{}`, and one server's 3.9 GB of models in there corrupted the archive
> and crashed every client on open), so until you run the converter those
> garments show as "Could not load" and the server console tells you so on
> every start.
>
> **Why `templates/`?** The source `.ydd/.ytd` are **edit-only** and must **not**
> be streamed to players (they're identical to base-game files and would waste
> bandwidth). Only the web `.glb/.png` reach clients, through the pack's
> `files{}`, once, on join.

---

## 🎨 Exporting your designs

Open **Export** in the studio and pick a mode:

| Mode | What it does | Best for |
|---|---|---|
| **Resource** | Writes a complete standalone resource (runtime `AddReplaceTexture`). Install it on any server. | Keeping a design, or sharing it. |
| **Live** | Broadcasts the texture to every connected player instantly and persists it in `data/live.json` - survives restarts. | Applying a design to your own server right now. |

Both finish inside the studio. Neither needs another resource, a database, or
a tool run by hand - if an export says it is done, it *is* done.

### After a Resource export

The Export panel shows you the exact folder it wrote to, the resource name and
the `server.cfg` line, each with a Copy button, followed by the numbered steps.
The short version:

1. Make a folder named after your export inside `resources/`.
2. Move the `<name>__*` files from `apex_clothing/exports/` into it and drop the
   `<name>__` prefix from each name.
3. Add `ensure <name>` to `server.cfg` and restart (or `refresh` + `ensure`).

> **Why the manual move?** Having the server create the folder and write into it
> hard-crashed the FXServer process on Linux in two separate releases of our map
> builder - a native fault a `pcall` cannot catch. One drag-and-drop beats an
> export that can take the server down. If your host handles it, set
> `Config.export.createFolder = true` and the folder is made for you.

### Wearing it

The pack **replaces the texture of a garment that already exists** in the game.
It does **not** add a new clothing item - nothing new appears in a shop or
clothing menu. Put that same garment on with any clothing menu and it is wearing
your design, for everyone running the resource.

The garment is the one that was open in the studio, down to the variant: the
generated `README.md` spells it out (slot, drawable number, texture variant,
gender), and the server console prints the same thing as `replaces: <txd>/<txn>`
on every export. **A different drawable, a different variant, the other gender
or an addon copy of a similar-looking item is a different texture and the pack
will not touch it** - that is the number one cause of "I installed it and
nothing changed".

If the item is right and it still looks unchanged: check the client console (F8)
for `[<name>] applied N clothing texture replacement(s)`. No line = the resource
never started; a red line = the PNG is not where `client.lua` expects it (the
`<name>__` prefix was left on when the files were moved). The pack forces the
clothing to re-stream when it starts, but taking the item off and putting it
back on (or a relog) is the sure way to see the swap.

---

## 🧩 Frameworks & standalone

Auto-detected at runtime - **ESX Legacy**, **QBCore**, **QBox** (checked before
qb-core so a compatibility shim can't win), or **standalone**. Nothing to
configure and no database anywhere.

Standalone is a **first-class mode, not a degraded one**. These three things are
all a framework is ever asked for:

| What | Used for | Without a framework |
|---|---|---|
| A stable identifier | owning saved projects, rate-limiting AI | the Rockstar license |
| A character name | shown on saved projects | the player's Steam/FiveM name |
| A job | only the `jobs` access method | that one method is unavailable |

The editor, the 3D viewer, AI, live preview, both export modes and the whole
storage layer never touch a framework at all.

### Another framework (vRP, ND, a fork, your own core)

`shared/config.lua` → `Config.framework.custom` takes three small functions.
Fill in what you have; anything you leave out falls back to the standalone
behaviour above, so a half-filled adapter still works:

```lua
Config.framework.mode = 'custom'
Config.framework.custom.name   = 'vrp'
Config.framework.custom.detect = function()
    return GetResourceState('vrp') == 'started'
end
Config.framework.custom.getIdentifier = function(src)
    local ok, id = pcall(function() return exports.vrp:getUserId(src) end)
    if ok and id then return 'vrp:' .. tostring(id) end
    return nil          -- nil is fine: it falls back to the license
end
```

The config ships a commented, ready-to-use **vRP** recipe for both the export-based
builds and legacy Proxy/Tunnel vRP. An adapter that throws is caught and logged,
then ignored - a bad adapter degrades to standalone instead of taking the
resource down.

> Why a recipe instead of built-in vRP support? vRP has no single API across its
> versions and forks, and pulling vRP's own lib into this resource would stop it
> from starting on every server that does *not* run vRP. Three lines you paste
> once beats a hard dependency everyone else pays for.

Access control is independent of all this: `everyone`, `ace` and `identifiers`
need no framework at all, and `groups` falls back to plain aces
(`name`, `group.name`, `qbcore.name`, `qbx.name`), so it works on any server.
Only `jobs` genuinely requires one.

---

## 🔐 Access control

Five independent methods in `shared/config.lua` → `Config.access`, each with its
own switch. They **add up**: a player gets in as soon as the *first enabled*
method says yes, so turning one on never removes access from someone who already
had it.

| Method | Gives access to | Default |
|---|---|---|
| `everyone` | anyone at all | **on** |
| `ace` | an ACE permission | off |
| `groups` | a framework rank (owner/god/admin…) | off |
| `jobs` | a job, from a minimum grade up | off |
| `identifiers` | a hand-picked list of people | off |

> ⚠️ `everyone` ships **on** so nothing breaks on update, but it lets *any*
> player retexture your whole server. The console warns on every start while it
> is on - switch to `ace` before going live.

```lua
everyone = { enabled = false },
ace      = { enabled = true, permissions = { 'apex.clothing' } },
```
```cfg
add_ace group.admin apex.clothing allow
add_principal identifier.license:YOUR_LICENSE group.admin
```

- **`ace`** also accepts the aces every framework and txAdmin already grant the
  owner (`command`, `txadmin.everything`, `group.admin`), so a fresh install
  never locks out the person who just installed it. Set
  `acceptOwnerAces = false` to require exactly your own permissions.
- **`groups`** looks each name up in the ESX group, the QBCore/QBox permission
  system **and** the plain aces (`name`, `group.name`, `qbcore.name`,
  `qbx.name`) - so it works even with no framework.
- **`identifiers`** needs neither a framework nor an ace, which makes it the way
  back in when a server's permissions are broken.

⚠️ An `add_ace` written in `server.cfg` only takes effect when the cfg is read,
i.e. at server **start** - restarting the resource is not enough. Paste the two
lines into the live console to apply them immediately. This is by far the most
common cause of "I'm admin and it says I have no access".

### Locked out? `/clothingstudio_access`

Run it in game. The **server console** then prints each of the five methods and
whether it is on, that method's verdict for you and why, and **all of your
identifiers**, ready to paste into `identifiers.list`. Any player may run it - it only ever reports on themselves. From the console:
`clothingstudio_access <server id>`.

The gate is enforced **server-side on every open** - the command/keybind alone
never grants access. Configs written for the older single-`mode` format are
translated, not ignored, so they keep working exactly as before.

---

## 🤖 AI setup

Bring your own key. Nothing is sent anywhere until a key is configured, and the
studio marks an engine with no key as unavailable rather than failing when you
press Generate.

```cfg
set apex_clothing_ai_key       "AIza..."   # a GOOGLE GEMINI key. Creative engine + the help assistant
set apex_clothing_ai_key_fast  "..."       # a TOGETHER AI key. Fast engine. Optional
```

Get a **free** Gemini key at <https://aistudio.google.com/apikey>. One key is
enough to use the studio: with only the first one set, the Creative engine and
the assistant work and the Fast engine is simply greyed out in the picker.

**The two keys are not interchangeable.** They are keys for two different
companies, and an engine never borrows the other engine's key: a key for Google
is not a key for Together AI. Putting the same key in both lines does not enable
the second engine, it just makes it fail. Each engine is marked unavailable in
the studio until its own key is set, so you always see which one is missing.

> **Put the key in `server.cfg`, never in `shared/config.lua`.** That file is a
> `shared_script`, which means the server sends it to every player who connects,
> so a key written into `Config.ai.apiKey` can be read by anyone on your server.
> The convar is read only on the server. `Config.ai.apiKey` exists for backwards
> compatibility and the convar always wins.

### Two image engines

The AI pane lets the designer pick per generation:

| Engine | What it is good at |
|---|---|
| **Creative** | Understands what is already on the canvas, so it restyles a garment you started instead of replacing it. Backed by Gemini. |
| **Fast** | Answers in a couple of seconds. Best for generating a texture from scratch. Backed by Together AI (FLUX). |

Both are defined in `shared/config.lua` → `Config.ai.engines`. Each names a
provider adapter (`gemini`, `together`, `fal`, `openai` or `custom`) and its own
key convar, so a free tier can sit next to a paid one without sharing a bill.
Set `enabled = false` on one to show only the other.

### The help assistant

`Config.ai.support` adds a help desk inside the studio: the designer asks a
question and gets an answer **about this script**, in the language they are
reading the interface in. Five one-tap buttons cover what people actually ask
(installing an export, the difference between the export modes, granting access,
setting the AI key, changing the language).

It is a text model, so it costs very little, and it never sees anyone's design - only the question. It is also told the facts about this resource rather than left
to guess, so it cannot invent a command or a config key that does not exist; when
something falls outside what it knows, it says so and points at this README.

Turn it off with `Config.ai.support.enabled = false` and the whole block
disappears from the interface.
---

## 🧩 Developer exports

```lua
-- CLIENT
exports.apex_clothing:Open()              -- open the studio
exports.apex_clothing:Close()             -- close it (restores the outfit)
exports.apex_clothing:IsOpen()            -- boolean
exports.apex_clothing:Notify(msg, type)   -- 'success' | 'error' | 'info'

-- SERVER
exports.apex_clothing:OpenFor(src)        -- open it for a player (honours access)
exports.apex_clothing:IsAllowed(src)      -- boolean access check
```

Wire these to an admin menu, a job, or an `ox_target`/NPC zone.

---

## ⚙️ Config highlights (`shared/config.lua`)

| Option | Meaning |
|---|---|
| `Config.locale` | UI language: `en` `pt` `es` `fr` `de`. |
| `Config.command` | Chat command that opens the studio (`clothingstudio`). |
| `Config.keybind` | Optional default key (e.g. `'F7'`), rebindable in FiveM settings. |
| `Config.access` | `everyone` / `ace` / `jobs`. |
| `Config.stage.teleport` | Teleport to a clean backdrop while designing, or edit in place. |
| `Config.canvas.sizes` | Canvas sizes offered (512 → 2048). |
| `Config.ai` | Provider, key, cooldown, hourly cap, quick themes. |

---

## 🛠️ Troubleshooting

- **Templates tab is empty** → you haven't imported any clothing yet. See
  [Importing your own clothing](#-importing-your-own-clothing-templates).
- **"ACCESS DENIED" in console** → run `/clothingstudio_access`; the server console
  then names the method that would let you in and prints your identifiers.
  Remember that a `server.cfg` ace only applies at server **start**.
- **The live preview turns slow, and F8 says "DUI never reported ready"** → up to
  v2.1.3 the studio gave up on its live surface for the rest of the session the
  moment a second one was created (which happens whenever you open a template of
  a different size), and dropped to a mode that updates once every 1.5 seconds.
  Fixed in v2.1.4: the new surface gets its full time to start, and if it is
  slow the studio switches back by itself as soon as it answers.
- **Live export does nothing** → check the server console for `[apex_clothing]`
  errors; the design is broadcast to every client instantly and persisted in
  `apex_clothing/data/live.json` (no extra resource or permission needed).
- **An export (live or pack) changed nothing in the city** → you are almost
  certainly not wearing the exact garment it targets. The server console prints
  `replaces: mp_m_freemode_01/jbib_diff_000_a_uni` on every export: that is
  slot `jbib` (torso), drawable `000`, variant `a` (= 0), male ped. Put THAT on.
  Since 2.1.6 the studio compares the target with what **you are wearing** when
  you press Export and says so in the result panel (and in F8): wrong drawable,
  wrong gender, a texture variant the game does not have, or an addon
  collection that differs from the template's file name. **Wear the garment
  while you export** so that check can run.
- **My clothes are an addon pack and the export targets the base game** → the
  texture name comes from the file name you converted: `jbib_015_u.ydd` means
  base-game drawable 15, `mp_m_freemode_01_myshop^jbib_015_u.ydd` means
  drawable 15 *of the `myshop` collection*. Keep the `<collection>^` prefix on
  the files you drop in `templates/`, or set `Config.templates.collection`.
  From 2.1.6, if you are wearing the garment when you export, its collection is
  targeted as well, whatever the file was called.
- **I created texture "D" in the texture manager and the pack does not show it**
  → a pack can only *replace* a texture the game already streams. If the
  garment ships with A-C, there is no D to replace. Export it as A (or B/C), or
  build a real `.ytd` for the new variant with `tools/make_ytd` and stream it.
- **I want to edit the texture outside the studio and bring it back** → tick
  **Download PNG** in the Export panel: the full-size sheet is written on the
  machine the server runs on (the console prints the exact path; on a local
  server that is your Desktop, on a VPS it is `apex_clothing/exports/downloads/`).
  Edit it, then put it back with the **Image** tool (upload / Ctrl+V / URL): it
  lands as a layer with corner handles, so drag it to move and pull a corner to
  resize (Shift keeps the ratio). To make it the garment's new *base*, drop it
  in your model pack as the template's PNG (`<name>_a.png`) and press *Rescan*.
- **AI says no key** → set `apex_clothing_ai_key` in `server.cfg`.
- **Streamed `.ytd` doesn't change the clothing** → the file must keep its full
  `<collection>^<drawable>.ytd` name and live under a `stream/` folder.

---

## 📄 License / credits

Apex Clothing Studio - by **Apex Scriptz**. `shared/config.lua`,
`shared/framework.lua`, `shared/access.lua`, the locales, the bundled `tools/`
and your garment catalog stay open so you can configure, translate and import
freely.
