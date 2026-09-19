--[[
    sun-inventory — wardrobe/clothes-shop shared type table.

    Ground truth for every key here is [SCRIPT]/skinchanger/client/main.lua
    (GetMaxVals / ApplySkin) — NOT guessed. That resource is the only thing
    that actually paints these onto the ped and the only thing esx_skin
    persists across relog, so the type list here is deliberately limited to
    exactly what it supports:

      * component = a real clothing component. `pair` is the
        {drawable_key, texture_key} ApplySkin reads, except 'arms' which
        skinchanger stores as bare `arms` / `arms_2` (confirmed from actual
        `lc_clothes` data in database.sql, e.g. row 1: `"arms":15`).
      * prop = a GTA prop slot (helmet/ears/glasses) that supports -1 for
        "nothing equipped" (ApplySkin explicitly ClearPedProp()s these at
        -1; it does NOT do that for glasses, so glasses always renders
        *something* — same as the original resource's behaviour).

    NOT included: watches / bracelets. The new UI's client/clothe.lua lists
    them as slots, but [SCRIPT]/skinchanger has no matching keys in
    GetMaxVals/ApplySkin/Character at all — there is nothing on this server
    that paints or persists them. Wiring them up "session-only" via a raw
    SetPedPropIndex would silently revert on every relog with no error, which
    is worse than not having the tab. Left out on purpose; see the
    integration notes for what a real fix would need.
]]

WardrobeTypes = {
    tshirt  = { kind = 'component', pair = { 'tshirt_1', 'tshirt_2' } },
    torso   = { kind = 'component', pair = { 'torso_1', 'torso_2' } },
    arms    = { kind = 'component', pair = { 'arms', 'arms_2' } },
    decals  = { kind = 'component', pair = { 'decals_1', 'decals_2' } },
    pants   = { kind = 'component', pair = { 'pants_1', 'pants_2' } },
    shoes   = { kind = 'component', pair = { 'shoes_1', 'shoes_2' } },
    mask    = { kind = 'component', pair = { 'mask_1', 'mask_2' } },
    bproof  = { kind = 'component', pair = { 'bproof_1', 'bproof_2' } },
    chain   = { kind = 'component', pair = { 'chain_1', 'chain_2' } },
    bag     = { kind = 'component', pair = { 'bags_1', 'bags_2' } },
    ears    = { kind = 'prop', pair = { 'ears_1', 'ears_2' }, none = -1 },
    helmet  = { kind = 'prop', pair = { 'helmet_1', 'helmet_2' }, none = -1 },
    glasses = { kind = 'prop', pair = { 'glasses_1', 'glasses_2' } },
}

function WardrobeValueKey(componentType, value)
    if type(value) == 'string' then
        local ok, decoded = pcall(json.decode, value)
        if not ok or type(decoded) ~= 'table' then return nil end
        value = decoded
    end
    if type(value) ~= 'table' then return nil end
    local def = WardrobeTypes[componentType]
    if not def then return nil end
    local d, t = value[def.pair[1]], value[def.pair[2]]
    if d == nil then return nil end
    return tostring(d) .. '_' .. tostring(t)
end
