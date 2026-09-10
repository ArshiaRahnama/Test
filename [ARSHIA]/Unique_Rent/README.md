# Unique_Rent

Redesigned & maintained by **Arshia** — arshiahub.ir

**IMPORTANT**

- The resource folder must be named exactly `Unique_Rent` (matches the NUI callback URLs and fxmanifest) or the menu won't work.
- For best results use 310x250 pixel vehicle images in `html/assets/`.

**Rental duration tiers**

- Edit `Config.Durations` in `config.lua` to add/remove/change duration tiers (30 Min / 1 Hour / 2 Hours by default). Each tier's `multiplier` is applied to a vehicle's base `price` in `Config.Vehicles` — the base price should represent the 1.0x tier.
- If only one tier is defined, the duration selector is hidden automatically and that single tier is used for every rental.
- `Config.Options['time']` must stay `true` for the countdown timer (and therefore the duration tiers) to actually be enforced.

**Rent confirmation**

- Clicking a vehicle now opens a confirmation step (image, chosen duration, total price) before any money is deducted — no more accidental one-click charges.
