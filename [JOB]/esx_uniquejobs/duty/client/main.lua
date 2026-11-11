-- On/off duty points.
-- Every point in Config_duty.Zones (one per job) and Config_duty.Locations (several per job,
-- each with the list of jobs allowed to use it) is drawn as a marker. Press E on a point
-- that your job is allowed to use to toggle on/off duty (15s anti-spam between toggles).
-- The AFK check lives in [SCRIPT]/ScriptPack/client/afkkick-cl.lua (single AFK system).

ESX = nil

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(50)
    end
end)

local typeMap = { info = 'inform', information = 'inform' }

RegisterNetEvent('esx_duty:sendnot')
AddEventHandler('esx_duty:sendnot', function(msg, type, timeout)
    lib.notify({
        description = msg,
        type = typeMap[type] or type or 'inform',
        position = 'bottom',
        duration = timeout or 5000
    })
end)

-- marker_style.lua wraps DrawMarker for the job zones; duty points keep their own colours.
local drawMarker = RawDrawMarker or DrawMarker

local points = {}
local spam = false

local function say(msg)
    TriggerEvent('chatMessage', '[SYSTEM]', { 255, 0, 0 }, msg, 'plarms')
end

local function toggleDuty(point)
    local pd = ESX and ESX.GetPlayerData and ESX.GetPlayerData()
    local jobName = pd and pd.job and pd.job.name
    if not jobName or jobName == 'nojob' then
        TriggerEvent('esx_duty:sendnot', 'Shoma nemitavanid az in location estefade konid', 'error', 5000)
        return
    end

    -- "offpolice" -> "police" (anchored, so a job that merely contains "off" is never touched)
    local base = jobName:gsub('^off', '')
    if not point.jobs[base] then
        TriggerEvent('esx_duty:sendnot', 'Shoma nemitavanid az in location estefade konid', 'error', 5000)
        return
    end

    if spam then
        say('Spam nakonid!')
        return
    end
    spam = true
    SetTimeout(Config_duty.Cooldown or 15000, function() spam = false end)

    -- The server decides on/off from the job the player really has (it is a toggle).
    TriggerServerEvent('esx_duty:setjob', base)
end

CreateThread(function()
    local nextRebuild = 0
    local drawDistance = Config_duty.DrawDistance or 10.0
    local interact = Config_duty.InteractRadius or 2.0

    while true do
        local sleep = 500
        local now = GetGameTimer()

        -- Rebuild now and then: the job manager can move Config_duty.Zones while the server runs.
        if now >= nextRebuild then
            points = Config_duty.BuildPoints()
            nextRebuild = now + 5000
        end

        local coords = GetEntityCoords(PlayerPedId())
        local inRange = nil

        for i = 1, #points do
            local p = points[i]
            local dx, dy, dz = coords.x - p.x, coords.y - p.y, coords.z - p.z
            local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
            if dist < drawDistance then
                sleep = 0
                local c, s = p.Color, p.Size
                drawMarker(p.Type or 20, p.x, p.y, p.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    s.x, s.y, s.z, c.r, c.g, c.b, 100, false, true, 2, false, nil, nil, false)
                if dist < interact then inRange = p end
            end
        end

        if inRange then
            BeginTextCommandDisplayHelp('STRING')
            AddTextComponentSubstringPlayerName('Dokme ~INPUT_CONTEXT~ jahat on/off duty')
            EndTextCommandDisplayHelp(0, false, true, -1)
            if IsControlJustReleased(0, 38) then
                toggleDuty(inRange)
            end
        end

        Wait(sleep)
    end
end)
