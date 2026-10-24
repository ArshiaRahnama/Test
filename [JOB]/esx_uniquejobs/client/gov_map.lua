-- Government's map: blips of every on-duty organisation member (blue) and its own (black).
local blips = {}
local ownBlip = nil

local function isGov()
    return PlayerData and PlayerData.job and PlayerData.job.name == 'government'
end

CreateThread(function()
    while true do
        Wait(1000)
        if isGov() then
            if not ownBlip or not DoesBlipExist(ownBlip) then
                ownBlip = AddBlipForEntity(PlayerPedId())
                SetBlipSprite(ownBlip, 1)
                SetBlipColour(ownBlip, 40) -- black
                SetBlipScale(ownBlip, 0.9)
                SetBlipAsShortRange(ownBlip, false)
                BeginTextCommandSetBlipName('STRING')
                AddTextComponentString('Government (shoma)')
                EndTextCommandSetBlipName(ownBlip)
            end
        elseif ownBlip then
            if DoesBlipExist(ownBlip) then RemoveBlip(ownBlip) end
            ownBlip = nil
        end
    end
end)

RegisterNetEvent('gov_map:update')
AddEventHandler('gov_map:update', function(list)
UJLog('CLIENT', ('gov_map:update list=%s'):format(tostring(list)))
    if not isGov() then return end
    local me = GetPlayerServerId(PlayerId())
    local seen = {}
    for _, p in ipairs(list or {}) do
        if p.id ~= me then
            seen[p.id] = true
            local b = blips[p.id]
            if not b or not DoesBlipExist(b) then
                b = AddBlipForCoord(p.x, p.y, p.z)
                SetBlipSprite(b, 1)
                SetBlipColour(b, 3)
                SetBlipScale(b, 0.8)
                SetBlipAsShortRange(b, false)
                blips[p.id] = b
            end
            SetBlipCoords(b, p.x, p.y, p.z)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(('[%s] %s - %s'):format(p.label, p.name, p.grade))
            EndTextCommandSetBlipName(b)
        end
    end
    for id, b in pairs(blips) do
        if not seen[id] then
            if DoesBlipExist(b) then RemoveBlip(b) end
            blips[id] = nil
        end
    end
end)
