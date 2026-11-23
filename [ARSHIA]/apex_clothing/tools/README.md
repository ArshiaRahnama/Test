# tools/ - adding your clothes to the studio

**Read this first, it answers the two questions everybody asks.**

> **Does my server need to run this?** No. This runs on **your own PC**. Your
> server never runs it, never needs Node.js, and does not care what hosting you
> use. RocketNode, ZAP, FiveM Hosting, a Linux VPS, a box under your desk: all
> the same. You convert here, then upload two things.
>
> **Do I have to double-click this inside WinSCP?** No, and please do not.
> That is the single most common support ticket. See
> [Do not run it inside WinSCP](#do-not-run-it-inside-winscp).

The 3D viewer needs a web mesh (`.glb`) because the browser can't read the
game's `.ydd`. **This tool reads the `.ydd` and `.ytd` files itself** (`rage.js`,
a small reader for the game's resource format) and writes the `.glb` + the
texture `.png` into a **model pack** resource next to `apex_clothing`
(`apex_clothing_models/models/<gender>/<component>/`), then updates
`templates.json` so the studio shows the **real 3D shape with its real textures**.

**Requirements:** Node.js. That's it, **no internet, no account, no quota, no
Blender, no Sollumz, no CodeWalker.** A garment converts in well under a second.

---

## Do not run it inside WinSCP

This is the most common support ticket, and the error looks like a broken
script when it is not.

When you double-click a file on the **remote** side of WinSCP or FileZilla, the
program downloads **only that one file** into a temporary folder and runs it
there. Everything it needs is still on the server, so you get:

```
'"C:\Users\you\AppData\Local\Temp\scp34172\...\ensure_node.bat"' is not
recognized as an internal or external command
```

or

```
Error: Cannot find module 'C:\Users\you\AppData\Local\Temp\scp45577\...\convert.js'
```

**The giveaway is the folder in the message:** `AppData\Local\Temp\scp#####`.
That is not where the tool lives, it is a temporary copy.

**The fix:** drag the whole `apex_clothing` folder to your Desktop, then run
`tools\convert.bat` from the Desktop copy.

Recent versions notice this and say so themselves: instead of a raw error you
get a short message naming the folder it ran from and the four steps above.

---

## Step by step - first time, no experience needed

1. **Install Node.js** (once). Go to <https://nodejs.org>, download the **LTS**
   installer, run it, click *Next* until it finishes. (On Windows, `convert.bat`
   looks for Node on its own and offers to fetch a portable copy if there is none.)
2. **Find your clothing files.** A clothing addon ships each piece as a `.ydd`
   (the 3D shape, e.g. `mp_m_freemode_01^jbib_012_u.ydd`) plus one `.ytd` per
   texture variant (e.g. `mp_m_freemode_01^jbib_diff_012_a_uni.ytd`, `…_b_uni.ytd`).
   Keep the `.ydd` and its `.ytd` files **in the same folder** - that is how the
   converter pairs them.
3. **Copy them** into `apex_clothing/templates/male/` or `templates/female/`
   (any sub-folder is fine), e.g.

   ```
   apex_clothing/templates/male/jbib/mp_m_freemode_01^jbib_012_u.ydd
   apex_clothing/templates/male/jbib/mp_m_freemode_01^jbib_diff_012_a_uni.ytd
   apex_clothing/templates/male/jbib/mp_m_freemode_01^jbib_diff_012_b_uni.ytd
   ```

   Names starting `mp_f_…` are sorted as female automatically, whatever folder
   they are in.
4. **Run the converter:**
   - **Windows:** double-click `tools\convert.bat`
   - **Linux / macOS:** open a terminal in `tools/` and run `bash convert.sh`
5. **Read what it prints.** One block per piece:

   ```
   CONVERT: mp_m_freemode_01_jbib_012_u  (2 textures)
     · jbib_diff_012_a_uni  ... OK (2048x4096 DXT5)
     · jbib_diff_012_b_uni  ... OK (2048x4096 DXT5)
     · mesh  ... OK (13099 triangles, 1 mesh)
   ```

   `SKIP (exists)` means it was already converted - that's fine.
6. **Is your game server on another machine?** (Usually yes: you run this on your
   PC, the server is a Linux VPS.) Then upload these two things to the server,
   keeping the same layout - the pack folder goes **next to** `apex_clothing`:

   ```
   resources/.../apex_clothing/templates.json
   resources/.../apex_clothing_models/     (whole folder: fxmanifest.lua + models/)
   ```

   If the server IS this machine, there is nothing to upload.
7. Add `ensure apex_clothing_models` (and `_models2`... if the tool listed more)
   to `server.cfg`, then in the server console (txAdmin / F8): `refresh`,
   `ensure apex_clothing_models`, `restart apex_clothing`.
8. In game, open the studio (`/clothingstudio` by default - see `shared/config.lua`).
   Your pieces are in the **Templates** tab; pick one, pick a texture variant
   (A, B, …), design, then **Export**.

To add more pieces later: drop them under `templates/` and double-click again.
Already-converted pieces are skipped, so it only takes a second.

## Convert your clothes

Put your `.ydd` files (and their `.ytd` textures next to them) under:

```
apex_clothing/templates/male/<component>/
apex_clothing/templates/female/<component>/
```

…or leave them wherever they already are and point the converter at that folder
(see **Keeping your clothes elsewhere** below).

Then, from this `tools/` folder, **double-click `convert.bat`** (or run
`node convert.js`).

## ⚠ If your game server is a different machine

This is the normal setup: **the tool runs on your Windows PC, the server is a
Linux VPS.** The converter only writes to the copy of `apex_clothing` it is
sitting in - it has no idea your server exists. When it finishes it prints
exactly what it wrote; **upload those two things to the server copy**, keeping
the same folder layout:

```
resources/.../apex_clothing/templates.json
resources/.../apex_clothing_models/        (whole folder, NEXT TO apex_clothing)
```

Add `ensure apex_clothing_models` to `server.cfg` (once; the tool prints the
line, plus `_models2`... if it had to start another pack), then in the server
console:

```
refresh
ensure apex_clothing_models
restart apex_clothing
```

(or `/clothingtemplates` in game). Skip the upload and the studio on the server
will keep showing exactly what it showed before - nothing is broken, the new
files simply never left your PC. Skip the `ensure` and every garment says
"Could not load"; the server console tells you which pack is not started.

## Why a separate "model pack" folder?

FiveM packs everything a resource lists in `files{}` into one archive, and that
archive cannot address anything past **2 GiB**. A whole clothing pack converted
into `apex_clothing` itself crossed that line once, the archive came out corrupt
and every player's game **crashed** the moment the studio opened. So the models
now live in their own small resources: `apex_clothing_models` holds up to 1 GB,
then `apex_clothing_models2` is started, and so on (`--pack-mb` changes the
budget). Each pack is just a manifest and a `models/` folder.

**Coming from 2.1.4 or older** (models in `apex_clothing/stream/models/`)? Run
the tool once. It moves them into packs and fixes `templates.json`; nothing is
re-converted.

Note the `templates/` folder with the source `.ydd`/`.ytd` does **not** need to
be uploaded. Those are inputs to the converter, not server assets.

## Keeping your clothes elsewhere

Nothing has to be copied into the resource. Either:

- `node convert.js --src "C:\Users\me\Desktop\My clothes"` (repeatable), or
- list the folder, one per line, in `tools/sources.txt` - that file is read on
  every run, so a plain double-click of `convert.bat` picks it up.

The originals are only ever **read**; the `.glb`/`.png` go to the model packs.

## Options

- `--force` - reconvert even if a `.glb` / `.png` already exists.
- `--pack-mb <n>` - size budget of each model pack resource (default 1024,
  hard limit 2048).
- `--gender female` - gender for `.ydd` files that aren't inside a
  `female/` or `male/` folder (default `male`). Names starting `mp_f_freemode`
  / `mp_m_freemode` are sorted automatically and win over the folder.
- `--src <folder>` - also scan this folder (repeatable).
- `--no-api` - never contact the hosted fallback (fully offline).
- `--api <url>` - a different / self-hosted fallback converter.

## How it decides gender / component

- **Gender** - from the collection prefix in the file name first
  (`mp_f_freemode…` → female), then from a `female/` or `male/` folder, then
  `--gender`.
- **Component** - from the drawable part of the name (`jbib_…` → torso/top,
  `lowr_…` → legs, `feet_…` → shoes, etc.). GTA names look like
  `<collection>^<drawable>`; the component is in the part after the `^`.
- **Export target** (`txd`/`txn`) - derived from the name. An addon item keeps
  its own collection, so `Export → Live` targets the right in-game texture.

## Reading a failure

Every item prints one line per texture and one for the mesh. When something
is skipped the line says why, and the summary at the end explains the reasons:

| What you see | What it means | What to do |
|---|---|---|
| `unsupported texture format BC7 (…)` | that `.ytd` uses a format the reader does not decode yet | the garment still works: it opens on a blank sheet and exports to the correct texture name |
| `not an RSC7 resource` / `bad pointer` / `runs past the payload` | the file is damaged, or is not a GTA V (legacy) resource | re-export it from OpenIV / CodeWalker |
| `escrow-encrypted (FXAP)` | that file is the protected copy from a paid pack. Only the game can decrypt it, so nothing reads it outside the game, **including OpenIV** | use the readable originals from the pack. If OpenIV opens the item for you, point the converter at that folder with `--src` |
| `[STOP] You opened this from inside WinSCP` | exactly that | see the section near the top |
| `local reader failed (…)` then `hosted fallback … OK` | the reader could not decode that `.ydd`, so it was sent - mesh only - to the hosted converter | nothing; it worked |
| `http 429 - drawable conversion quota exceeded` | the hosted fallback allows **3 conversions per IP per 24 h** | re-run tomorrow (only items still missing a `.glb` are sent), or set a free key (below) |
| `http 422` / `http 400` | the hosted service could not process that file either | re-export the file |
| `http 000` | the connection dropped mid-upload | just re-run |

### The hosted fallback

Only a `.ydd` the local reader cannot decode is ever uploaded, and only once,
mesh only. Textures are **never** uploaded. The service (`gtax.dev`) meters
conversions per day, so the tool never retries a `429` and stops using the
fallback for the rest of the run after one. For 10 conversions a day instead of 3,
create a free key at <https://gtax.dev/api-keys> and set it before running:

```
set V_DRAWABLE_TO_GLB_API_KEY=<your key>       (Windows)
export V_DRAWABLE_TO_GLB_API_KEY=<your key>    (Linux/macOS)
node convert.js
```

`--no-api` disables the fallback entirely for fully offline use.

## Notes

- Formats decoded locally: meshes with float / half-float positions and UVs (every
  ped clothing layout seen so far); textures in DXT1 / DXT3 / DXT5 / A8R8G8B8 /
  A8B8G8R8 / L8 / A8. The mesh and pixels come out identical to what the hosted
  converter produced (verified element-by-element on 31 garments and 181
  textures).
- The `.glb` is only for the viewer's **shape**. To make the clothes actually
  **wearable in-game** (so `Export → Live` has something to retexture), stream
  the real addon (`.ydd`/`.ytd`/`.ymt`/`.meta`) - see `../stream/README.md`.

Credit for the fallback: the **gtax.dev** drawable→glb service
(github.com/gtax-dev/v-drawable-to-glb).
