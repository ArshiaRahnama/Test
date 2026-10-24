-- ================================================================= --
-- ZONE ARMORY / WORKSHOP: a marker on each territory zone.
-- Stand on it and press E to open that zone's armory + workshop
-- (screen lives in Unique_AllRobs NUI). Only the zone's owner gang
-- can use it; everybody else sees the zone's status.
-- ================================================================= --

local DRAW_RANGE = 30.0
local USE_RANGE  = 2.2
local zones = {}

CreateThread(function()
    while Config == nil or Config.Territory == nil or Config.Territory.Zones == nil do Wait(500) end
    for key, z in pairs(Config.Territory.Zones) do
        if Config.Territory.ZoneArmory ~= false and not z.bossZone and z.coord and z.armory ~= false then
            zones[#zones + 1] = { key = key, label = z.label or key, coord = z.coord }
        end
    end
    table.sort(zones, function(a, b) return a.label < b.label end)
end)

local function OpenZoneArmory(key, label)
    local ok, err = pcall(function() exports['Unique_AllRobs']:OpenZoneArmoryMenu(key, label) end)
    if not ok then
        print('[Unique_ALLGangs] Zone armory: ' .. tostring(err))
        ESX.ShowNotification('~r~Kargah-e zone dar dastres nist (Unique_AllRobs roshan nist)')
    end
end

CreateThread(function()
    while true do
        local wait = 1000
        if #zones > 0 then
            local ped = PlayerPedId()
            local pc = GetEntityCoords(ped)
            local near
            for _, z in ipairs(zones) do
                local d = #(pc - z.coord)
                if d < DRAW_RANGE then
                    wait = 0
                    DrawMarker(1, z.coord.x, z.coord.y, z.coord.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                        1.8, 1.8, 0.5, 251, 191, 36, 140, false, true, 2, false, nil, nil, false)
                end
                if d <= USE_RANGE then near = z end
            end
            if near then
                wait = 0
                BeginTextCommandDisplayHelp('STRING')
                AddTextComponentSubstringPlayerName('~INPUT_CONTEXT~ Armory-e gang: ~y~' .. near.label)
                EndTextCommandDisplayHelp(0, false, true, -1)
                if IsControlJustReleased(0, 38) then OpenZoneArmory(near.key, near.label) end
            end
        end
        Wait(wait)
    end
end)
