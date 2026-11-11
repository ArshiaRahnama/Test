-- Quest giver NPCs: spawned only while the player is near, deleted when far.
local peds = {} -- [index] = ped

local function loadModel(hash)
    RequestModel(hash)
    local t = GetGameTimer()
    while not HasModelLoaded(hash) do
        if GetGameTimer() - t > 5000 then return false end
        Wait(10)
    end
    return true
end

local function spawn(i, npc)
    local hash = GetHashKey(npc.model)
    if not IsModelValid(hash) or not loadModel(hash) then return end
    local c = npc.coords
    local ped = CreatePed(4, hash, c.x, c.y, c.z - 1.0, c.h, false, false)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedFleeAttributes(ped, 0, false)
    FreezeEntityPosition(ped, true)
    SetModelAsNoLongerNeeded(hash)
    peds[i] = ped
end

local function remove(i)
    if peds[i] and DoesEntityExist(peds[i]) then DeletePed(peds[i]) end
    peds[i] = nil
end

CreateThread(function()
    for _, npc in ipairs(Config.QuestNPCs or {}) do
        if npc.blip then
            local b = AddBlipForCoord(npc.coords.x, npc.coords.y, npc.coords.z)
            SetBlipSprite(b, 280)
            SetBlipScale(b, 0.8)
            SetBlipAsShortRange(b, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(npc.label or 'Quest Giver')
            EndTextCommandSetBlipName(b)
        end
    end

    while true do
        local pcoords = GetEntityCoords(PlayerPedId())
        local sleep = 1500
        for i, npc in ipairs(Config.QuestNPCs or {}) do
            local d = #(pcoords - vector3(npc.coords.x, npc.coords.y, npc.coords.z))
            if d < 25.0 then
                sleep = 0
                -- floating marker above the NPC's head (bobs up and down)
                local bob = math.sin(GetGameTimer() / 400.0) * 0.08
                DrawMarker(0, npc.coords.x, npc.coords.y, npc.coords.z + 1.35 + bob, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    0.3, 0.3, 0.4, 124, 58, 237, 200, false, true, 2, true, nil, nil, false)
            end
            if d < 60.0 then
                if not (peds[i] and DoesEntityExist(peds[i])) then spawn(i, npc) end
                if d < (Config.QuestNPCDistance or 2.0) + 1.0 then
                    sleep = 0
                    BeginTextCommandDisplayHelp('STRING')
                    AddTextComponentSubstringPlayerName('Press ~INPUT_CONTEXT~ to view quests')
                    EndTextCommandDisplayHelp(0, false, true, -1)
                    if IsControlJustReleased(0, 38) then QuestNpcMode = true; ExecuteCommand('menu') end
                end
            elseif peds[i] then
                remove(i)
            end
        end
        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for i in pairs(peds) do remove(i) end
end)
