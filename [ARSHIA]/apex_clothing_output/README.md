# apex_clothing_output

The **live-export container** for [Apex Clothing Studio](../apex_clothing/README.md) (`apex_clothing`).

When a designer runs a **Live** export in the studio, `apex_clothing` writes the PNG(s) into `textures/`, adds a manifest entry to `data.json` and restarts this resource. On start, `client.lua` creates a runtime texture dictionary per outfit and remaps each image over the original game texture — instantly, server-wide, and persistently across restarts.

## Setup

```cfg
ensure apex_clothing
ensure apex_clothing_output
```

That is all. **Do not edit `data.json` or `textures/` by hand** — the studio manages both.

## Removing a design

Delete its entry from `data.json` (and its PNGs from `textures/`), then `restart apex_clothing_output`. All replacements are cleanly undone on stop and re-applied on start.
