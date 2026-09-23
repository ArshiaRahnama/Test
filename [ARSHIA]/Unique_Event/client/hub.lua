--[[
    Unique_Event - client hub
    Opens /uevent, fetches data from the server, and forwards hub button clicks.
]]

local hubOpen = false

local function openHub()
    if hubOpen then return end
    if not ESX then return UE.Notify('Still loading, try again in a second.', 'error') end
    hubOpen = true
    UE.UI.Set('hub', true)
    UE.Send('hubOpen', {})
    ESX.TriggerServerCallback('ue:hub:get', function(data)
        UE.Send('hubData', data)
    end)
end

local function closeHub()
    if not hubOpen then return end
    hubOpen = false
    UE.UI.Set('hub', false)
    UE.Send('hubClose', {})
end

UE.Command(Config.Hub.Command, function() openHub() end, false)
for _, alias in ipairs(Config.Hub.Aliases or {}) do
    RegisterCommand(alias, function() openHub() end, false)
end
if Config.Hub.Key then RegisterKeyMapping(Config.Hub.Command, 'Unique Event: open /uevent menu', 'keyboard', Config.Hub.Key) end

RegisterNUICallback('hub:close', function(_, cb) closeHub() cb('ok') end)
RegisterNUICallback('hub:refresh', function(_, cb)
    if not ESX then return cb('ok') end
    ESX.TriggerServerCallback('ue:hub:get', function(data) UE.Send('hubData', data) end)
    cb('ok')
end)
RegisterNUICallback('hub:page', function(data, cb)
    if not ESX then return cb('ok') end
    ESX.TriggerServerCallback('ue:hub:page', function(page) UE.Send('hubPage', { event = data.event, page = page }) end, data.event)
    cb('ok')
end)
RegisterNUICallback('hub:action', function(data, cb)
    TriggerServerEvent('ue:hub:action', data.event, data.action, data.payload or {})
    cb('ok')
end)

AddEventHandler('ue:stateChanged', function(eventName)
    -- if the player joins an event while the hub happens to be open, close it so the HUD is visible
    if eventName and hubOpen then closeHub() end
end)

