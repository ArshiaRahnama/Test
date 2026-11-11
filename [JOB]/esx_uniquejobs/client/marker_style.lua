-- Uniform job marker style (same look for all 13 jobs).
-- Wraps DrawMarker for this resource only: boss, cloakroom/armory, vehicle garage,
-- helicopter garage and vehicle deleter markers get one shared look:
-- small green bobbing marker (size 0.5, rgba 0/255/0/100).
-- Every other marker type is passed through untouched.
-- Must be the FIRST client script in fxmanifest.lua so it is defined before any job file runs.

local nativeDrawMarker = DrawMarker
RawDrawMarker = nativeDrawMarker -- unstyled native, for resources/files that keep their own marker look (duty points)

MarkerStyle = {
    size  = { 0.5, 0.5, 0.5 },
    color = { 0, 255, 0, 100 },
    bob   = true,
    -- original marker type used by the job files -> shared marker type
    map = {
        [29] = 42, -- boss action
        [22] = 21, -- cloakroom / armory
        [21] = 21, -- cloakroom / generic action
        [36] = 36, -- vehicle garage
        [34] = 34, -- helicopter garage
        [24] = 24, -- vehicle deleter
    },
}

function DrawMarker(mType, x, y, z, dx, dy, dz, rx, ry, rz, sx, sy, sz, r, g, b, a, bob, face, p19, rotate, dict, name, drawOnEnts)
    local styled = MarkerStyle.map[mType]
    if styled then
        local s, c = MarkerStyle.size, MarkerStyle.color
        return nativeDrawMarker(styled, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            s[1], s[2], s[3], c[1], c[2], c[3], c[4],
            MarkerStyle.bob, false, 2, true, nil, nil, false)
    end
    return nativeDrawMarker(mType, x, y, z, dx, dy, dz, rx, ry, rz, sx, sy, sz, r, g, b, a, bob, face, p19, rotate, dict, name, drawOnEnts)
end
