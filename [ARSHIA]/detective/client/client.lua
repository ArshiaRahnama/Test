--[[
    kq_detective — main client loop, cleaned up + fixed for this server.

    See client/functions.lua header for the whitelist bug fix and the
    ESX dead-player fix. This file wires up death reporting for ESX
    (this server's framework) alongside the original QB path.
]]

local Keys = {
    ESC = 322, F1 = 288, F2 = 289, F3 = 170, F5 = 166, F6 = 167, F7 = 168, F8 = 169,
    F9 = 56, F10 = 57, ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164,
    ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83,
    BACKSPACE = 177, TAB = 37, Q = 44, W = 32, E = 38, R = 45, T = 245, Y = 246, U = 303,
    P = 199, ['['] = 39, [']'] = 40, ENTER = 18, CAPS = 137, A = 34, S = 8, D = 9, F = 23,
    G = 47, H = 74, K = 311, L = 182, LEFTSHIFT = 21, Z = 20, X = 73, C = 26, V = 0, B = 29,
    N = 249, M = 244, [','] = 82, ['.'] = 81, LEFTCTRL = 36, LEFTALT = 19, SPACE = 22,
    RIGHTCTRL = 70, HOME = 213, PAGEUP = 10, PAGEDOWN = 11, DELETE = 178, LEFT = 174,
    RIGHT = 175, TOP = 27, DOWN = 173, NENTER = 201, N4 = 108, N5 = 60, N6 = 107,
    ['N+'] = 96, ['N-'] = 97, N7 = 117, N8 = 61, N9 = 118,
}

playerJob = nil
lastPed = nil
lastTime = nil
deadPeds = {}
targetted = {}
menuOpen = false

-- Rescan nearby dead peds (NPCs and players alike) every 5s.
Citizen.CreateThread(function()
    while true do
        local myCoords = GetEntityCoords(PlayerPedId())
        local nearbyDead = {}

        for _, ped in pairs(GetGamePool('CPed')) do
            if #(GetEntityCoords(ped) - myCoords) < 30.0 and IsDead(ped) and ped ~= PlayerPedId() then
                table.insert(nearbyDead, ped)
            end
        end

        deadPeds = nearbyDead
        Citizen.Wait(5000)
    end
end)

-- Prompt / targeting loop for whichever dead ped is nearest.
Citizen.CreateThread(function()
    Citizen.Wait(500)

    while true do
        local wait = 5000
        local myPed = PlayerPedId()
        local blocked = not CanInvestigate() or IsPedInAnyVehicle(myPed) or IsPedRagdoll(myPed) or IsDead(myPed)

        if #deadPeds > 0 and not blocked then
            wait = 1000

            local myCoords = GetEntityCoords(myPed)
            local closestPed, closestDist = nil, 9999.9

            for _, ped in pairs(deadPeds) do
                local dist = #(GetEntityCoords(ped) - myCoords)
                if dist < 1.5 and IsDead(ped) and dist < closestDist then
                    closestPed = ped
                    closestDist = dist
                end
            end

            if closestPed and not menuOpen then
                if not Config.target.enabled then
                    local coords = GetEntityCoords(closestPed)
                    wait = 0
                    local prompt = L('~w~[~y~{INVESTIGATE_KEYBIND}~w~] to investigate')
                        :gsub('{INVESTIGATE_KEYBIND}', Config.keybinds.investigate)
                    Draw3DText(coords.x, coords.y, coords.z, prompt, 4, 0.035, 0.035)

                    if IsControlJustReleased(0, Keys[Config.keybinds.investigate]) then
                        StartInvestigatePed(closestPed)
                    end
                elseif not Contains(targetted, closestPed) then
                    AddPedToTargetting(closestPed)
                    table.insert(targetted, closestPed)
                end
            end
        end

        Citizen.Wait(wait)
    end
end)

-- Shared: report this player's own death to the server, regardless of framework.
-- `eventData` is only populated on the ESX path (essentialmode passes its own
-- death payload, which includes `distance` — see PlayerKilledByPlayer in
-- essentialmode/client/modules/death.lua); the QB event handlers below call
-- this with no arguments, which is fine, `distance` just stays nil for them.
function UploadDeathInfo(eventData)
    Citizen.CreateThread(function()
        Citizen.Wait(3)

        local ped = PlayerPedId()
        local killerNetId = NetworkGetNetworkIdFromEntity(GetPedSourceOfDeath(ped))
        local cause = GetPedCauseOfDeath(ped)
        local _, bone = GetPedLastDamageBone(ped)
        local distance = eventData and eventData.distance or nil

        TriggerServerEvent('kq_detective:savePlayerInfo', killerNetId, cause, bone, distance)
    end)
end

RegisterNetEvent('kq_detective:investigatePlayer')
AddEventHandler('kq_detective:investigatePlayer', function(data, ped)
    local killerEntity = NetworkGetEntityFromNetworkId(data.source)

    local function DoInvestigate()
        InvestigatePed(ped, data.sinceDeath, killerEntity, data.cause, data.bone)
    end

    -- Coroner/ambulance minigame — only when this was a murdered player with
    -- a recorded shot distance (essentialmode only reports `distance` for
    -- killed-by-player deaths). See client/forensics.lua.
    if Config.autopsy.enabled and data.distance and Contains(Config.autopsy.jobs, playerJob) then
        RunAutopsyMinigame(data.distance, data.sinceDeath, DoInvestigate)
    else
        DoInvestigate()
    end
end)

if Config.qbSettings.enabled then
    AddEventHandler('baseevents:onPlayerDied', UploadDeathInfo)
    AddEventHandler('baseevents:onPlayerKilled', UploadDeathInfo)
    AddEventHandler('baseevents:onPlayerWasted', UploadDeathInfo)
end

if Config.esxSettings.enabled then
    -- essentialmode/client/modules/death.lua fires this locally
    -- (TriggerEvent('esx:onPlayerDeath', data)) the moment IsPedFatallyInjured
    -- becomes true, which is exactly the hook this server needs.
    RegisterNetEvent('esx:onPlayerDeath')
    AddEventHandler('esx:onPlayerDeath', UploadDeathInfo)
end
