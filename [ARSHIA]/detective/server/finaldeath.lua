--[[
    kq_detective — final death blip.

    Mirrors Config_ambulance.BleedoutTimer (esx_uniquejobs/client/config_ambulance.lua)
    WITHOUT touching that resource: kq_detective already knows the instant a
    death is recorded (kq_detective:savePlayerInfo in server.lua populates
    playerDeathInfo[src]). If that same source is STILL recorded as dead once
    Config.finalDeath.bleedoutMs has passed, they were never revived in time —
    exactly the moment ambulance_main.lua's own timer force-respawns them at
    the hospital, i.e. genuinely no longer revivable. That's the signal this
    fires the blip on. No admin command involved anywhere in this flow.

    This just adds a SECOND handler on the same event server.lua already
    registers — FiveM supports multiple handlers per event, so server.lua
    itself needed no changes.
]]

local function Contains(list, value)
    for _, item in ipairs(list) do
        if item == value then return true end
    end
    return false
end

AddEventHandler('kq_detective:savePlayerInfo', function()
    if not Config.finalDeath.enabled then return end

    local src = source

    SetTimeout(Config.finalDeath.bleedoutMs, function()
        local info = playerDeathInfo[src]
        if not info then return end -- revived or disconnected in time
        if not info.coords then return end
        if not ESX then return end

        for _, playerId in ipairs(GetPlayers()) do
            local id = tonumber(playerId)
            local xTarget = ESX.GetPlayerFromId(id)

            if xTarget and Contains(Config.finalDeath.notifyJobs, xTarget.job.name) then
                TriggerClientEvent('kq_detective:finalDeathBlip', id, info.coords)
            end
        end

        if SendKQDetectiveLog then
            SendKQDetectiveLog('Player bled out',
                ('A body was left unattended and is no longer revivable (source #%d).'):format(src),
                15158332)
        end

        if KQ_AddDojNote and info.caseId then
            KQ_AddDojNote(info.caseId, 'note', 'Victim was not revived in time and is presumed dead.', 'kq_detective')
        end
    end)
end)

--[[
    SOLO TEST COMMAND — only exists while Config.debug = true. Broadcasts the
    blip immediately at YOUR current position instead of waiting 5 real
    minutes, so you can confirm DOJ/Law members actually see it. Remove/
    disable before going live.
]]
if Config.debug then
    Citizen.CreateThread(function()
        while ESX == nil do Citizen.Wait(0) end

        RegisterCommand('kqtestbleedout', function(source)
            local xSource = ESX.GetPlayerFromId(source)
            if not xSource then return end

            local ped = GetPlayerPed(source)
            local coords = GetEntityCoords(ped)
            local notified = 0

            for _, playerId in ipairs(GetPlayers()) do
                local id = tonumber(playerId)
                local xTarget = ESX.GetPlayerFromId(id)

                if xTarget and Contains(Config.finalDeath.notifyJobs, xTarget.job.name) then
                    TriggerClientEvent('kq_detective:finalDeathBlip', id, coords)
                    notified = notified + 1
                end
            end

            TriggerClientEvent('chat:addMessage', source, {
                args = { '[KQ TEST]', ('Blip broadcast to %d DOJ/Law member(s) online.'):format(notified) }
            })
        end, false)
    end)
end
