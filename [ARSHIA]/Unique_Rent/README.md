# Unique_Rent

Redesigned & maintained by **Arshia** — arshiahub.ir

**IMPORTANT**

- The resource folder must be named exactly `Unique_Rent` (matches the fxmanifest) or the resource won't start.
- Depends on **essentialmode** (this base's ESX-compatible framework, not `es_extended`) and on **ox_lib** — both are declared in `dependencies` in `fxmanifest.lua`. Make sure both `essentialmode` and `ox_lib` are `ensure`d before `Unique_Rent` in `server.cfg`.

**Menu, prompts & markers (ox_lib)**

- The vehicle picker, duration tiers and the "confirm before paying" step are all rendered by **ox_lib**'s own UI now (`lib.registerContext` / `lib.showContext` / `lib.alertDialog`), not by this resource's own HTML anymore.
- On-foot markers use `lib.marker` (nicer built-in shapes than a plain cylinder) and the `[E] Rent a Vehicle` / `[G] Return Vehicle` prompts use `lib.showTextUI`, both driven by `lib.points` zones — see `client/main.lua`.
- Each location's marker shape/color/icon is configurable per-location in `config.lua` under `Config.Locations[x].markers` (`oxType` is any name from ox_lib's `MarkerType` enum).
- This resource's bundled NUI (`html/*`) now only renders the rental countdown ring — everything else moved to ox_lib.

**Rental duration tiers**

- Edit `Config.Durations` in `config.lua` to add/remove/change duration tiers (30 Min / 1 Hour / 2 Hours by default). Each tier's `multiplier` is applied to a vehicle's base `price` in `Config.Vehicles` — the base price should represent the 1.0x tier.
- `Config.Options['time']` must stay `true` for the countdown timer (and therefore the duration tiers) to actually be enforced.

**Rent confirmation**

- Selecting a duration opens an ox_lib confirm dialog (vehicle, chosen duration, total price) before any money is deducted — no more accidental one-click charges.
