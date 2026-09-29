ESX = nil
Citizen.CreateThread(function()
    while not ESX do
        TriggerEvent(HubConfig.ESX, function(obj) ESX = obj end)
        Citizen.Wait(5)
    end
end)

local menuOpen = false

local function BuildEventsPayload(permLevel)
    local events = {}
    for _, ev in ipairs(HubConfig.Events) do
        events[#events + 1] = {
            id        = ev.id,
            name      = ev.name,
            nameEn    = ev.nameEn,
            desc      = ev.desc,
            icon      = ev.icon,
            color     = ev.color,
            colorSoft = ev.colorSoft,
            canStart  = permLevel >= (ev.permDisplay or 9999),
            hasPanel  = ev.panelCmd ~= nil,
            joinCmd   = ev.joinCmd,
            startCmd  = ev.startCmd,
            panelCmd  = ev.panelCmd or ev.statsCmd,
            statsCmd  = ev.statsCmd,
        }
    end
    return events
end

local function OpenEventsMenu()
    if menuOpen then return end

    ESX.TriggerServerCallback('Unique_Event:getAccess', function(access)
        menuOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'hubOpen',
            events = BuildEventsPayload((access and access.permission_level) or 0),
        })
    end)
end

local function CloseEventsMenu()
    menuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hubClose' })
end

RegisterCommand(HubConfig.EventCommand, function()
    if menuOpen then
        CloseEventsMenu()
    else
        OpenEventsMenu()
    end
end, false)

RegisterNUICallback('closeMenu', function(_, cb)
    CloseEventsMenu()
    cb('ok')
end)

-- data.cmd همیشه یکی از کامندهای ثابتِ HubConfig.Events هست (joinCmd/startCmd/panelCmd/statsCmd)
-- که مستقیم از ماژول‌های warzone/gungame/capture میاد؛ چیزی اینجا ساخته نمیشه.
RegisterNUICallback('runCommand', function(data, cb)
    cb('ok')
    if data and data.cmd and type(data.cmd) == 'string' and data.cmd ~= '' then
        -- Release NUI focus / hide the hub FIRST. Some target commands (e.g. /warzone,
        -- /capture) open their own NUI and take focus; closing afterwards would kill it.
        CloseEventsMenu()
        local cmd = data.cmd
        SetTimeout(100, function() ExecuteCommand(cmd) end)
    end
end)

RegisterNUICallback('getStats', function(data, cb)
    local eventId = data and data.id
    if not eventId then
        cb({ cols = {}, rows = {} })
        return
    end
    ESX.TriggerServerCallback('Unique_Event:getStats', function(result)
        cb(result)
    end, eventId)
end)
