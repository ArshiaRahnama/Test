-- Floating admin tag over on-duty admins - Unique version of Sunset's admintag.lua:
--   [ logo badge ]   <- Unique logo (runtime DUI texture, tinted with the rank colour)
--   Rank             <- from Config_Shared.Rank (Helper / Admin / Head Admin ...)
--   Admin name       <- gold
-- The source list (+ each admin's permission level) comes from the server (server/admin_tag.lua),
-- which re-derives it from IsOnDutyAdmin, so clients can't fake an entry.
-- An admin who is spectating (/sp2, /sp, report eye) is invisible, so the tag disappears with them.

local AdminTagSources = {}

RegisterNetEvent('Unique_AdminPanel:SyncAdminTags')
AddEventHandler('Unique_AdminPanel:SyncAdminTags', function(tags)
    AdminTagSources = tags or {}
end)

-- Tell the server whenever our own duty state flips, so it can recompute
-- and rebroadcast the list, and log the persistent duty session
-- (server/duty_log.lua).
AddEventHandler('esx_aduty:ChangeMenuStatus', function(isOnDuty)
    Citizen.SetTimeout(0, function()
        TriggerServerEvent('Unique_AdminPanel:UpdateAdminTag')
        TriggerServerEvent('Unique_AdminPanel:DutyLogToggle', isOnDuty and true or false)
    end)
end)

-- ---------------------------------------------------------------- ranks ---
local function rankLabel(level)
    local ranks = Config_Shared and Config_Shared.Rank or {}
    if ranks[level] then return ranks[level] end
    local best, bestKey = nil, -1                       -- unknown level: use the closest lower rank
    for k, v in pairs(ranks) do
        if k <= level and k > bestKey then best, bestKey = v, k end
    end
    return best or 'SUPPORT'
end

-- colour per rank NAME tier (Sunset names): support/helpers = green, admins = blue,
-- executive/management/moderator/manager = purple, owner = gold, developer = red
local TIER = {
    ['SUPPORT'] = 1, ['HELPER'] = 1, ['SENIOR HELPER'] = 1, ['HEAD HELPER'] = 1,
    ['ADMIN'] = 2, ['SENIOR ADMIN'] = 2, ['HEAD ADMIN'] = 2,
    ['EXECUTIVE ADMIN'] = 3, ['ADMIN MANAGEMENT'] = 3, ['MODERATOR'] = 3, ['MANAGER'] = 3,
    ['OWNER'] = 4, ['DEVELOPER'] = 5,
}
local TIER_COLOR = {
    [1] = { 120, 220, 140 }, [2] = { 101, 174, 255 }, [3] = { 190, 130, 255 },
    [4] = { 255, 196, 60 },  [5] = { 255, 99, 99 },
}
local function rankColor(level)
    local c = TIER_COLOR[TIER[rankLabel(level)] or 1]
    return c[1], c[2], c[3]
end

-- ----------------------------------------------------------------- logo ---
-- html/admintag/logo.html rendered into a runtime texture (no .ytd file needed)
local TXD, TEX = 'uq_admintag', 'badge'
local logoReady = false
CreateThread(function()
    local ok = pcall(function()
        local dui = CreateDui(('https://cfx-nui-%s/html/admintag/logo.html'):format(GetCurrentResourceName()), 256, 256)
        local txd = CreateRuntimeTxd(TXD)
        CreateRuntimeTextureFromDuiHandle(txd, TEX, GetDuiHandle(dui))
    end)
    if ok then
        Wait(1500)                                   -- let the page render once
        logoReady = true
    end
end)

-- ----------------------------------------------------------------- draw ---
local function text3D(x, y, z, str, r, g, b, size, font)
    local onScreen, sx, sy = World3dToScreen2d(x, y, z)
    if not onScreen then return end
    local cx, cy, cz = table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(cx, cy, cz) - vector3(x, y, z))
    local scale = (1 / dist) * 2 * ((1 / GetGameplayCamFov()) * 100)

    SetTextScale(0.0 * scale, size * scale)
    SetTextFont(font or 0)
    SetTextProportional(1)
    SetTextColour(r, g, b, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(str)
    DrawText(sx, sy)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(#AdminTagSources > 0 and 0 or 500)

        local myCoords = GetEntityCoords(PlayerPedId())
        local ratio = GetAspectRatio(true)
        local camPos, fov = GetFinalRenderedCamCoord(), GetFinalRenderedCamFov()

        for _, tag in ipairs(AdminTagSources) do
            local playerIndex = GetPlayerFromServerId(tag.source)
            if playerIndex ~= -1 and playerIndex ~= PlayerId() then
                local ped = GetPlayerPed(playerIndex)
                if DoesEntityExist(ped) and IsEntityVisible(ped) then
                    local coords = GetEntityCoords(ped)
                    if #(myCoords - coords) < 80.0 then
                        local level = tonumber(tag.level) or 1
                        local r, g, b = rankColor(level)

                        text3D(coords.x, coords.y, coords.z + 1.10, GetPlayerName(playerIndex), 255, 215, 0, 0.55)
                        text3D(coords.x, coords.y, coords.z + 1.27, rankLabel(level), r, g, b, 0.42, 4)

                        if logoReady then
                            local scale = (1.0 / #(camPos - coords)) * (1.0 / fov) * 10.0
                            SetDrawOrigin(coords.x, coords.y, coords.z + 1.52, 0)
                            DrawSprite(TXD, TEX, 0.0, 0.0, scale * 0.75, scale * 0.75 * ratio, 0.0, r, g, b, 255)
                            ClearDrawOrigin()
                        end
                    end
                end
            end
        end
    end
end)
