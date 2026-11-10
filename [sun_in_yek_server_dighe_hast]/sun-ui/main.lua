-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(500)
    end
end)
local focusList = {}
local callbackList = {}
function changeDisplay(id, state, focus)
    SendNUIMessage({
        id = id,
        display = state,
    })
    if state and focus then
        focusList[id] = true
        SetNuiFocus(true, true)
    elseif focusList[id] then
        SetNuiFocus(false, false)
    end
end

function sendMessage(data)
    SendNUIMessage(data)
    if data.display ~= nil then
        if data.display and data.focus then
            focusList[data.id] = true
            SetNuiFocus(true, true)
        elseif focusList[data.id] then
            focusList[data.id] = nil
            SetNuiFocus(false, false)
        end
    end
end

exports('changeDisplay', changeDisplay)
exports('sendMessage', sendMessage)
exports('registerUICallback', function(id, callback)
    callbackList[id] = callback
end)

RegisterNUICallback('close', function(id)
    SetNuiFocus(false, false)
    TriggerEvent('ui:menuClosed', id)
end)

RegisterNuiCallback('callback', function(data)
    if callbackList[data.id] then
        callbackList[data.id](data)
    end
end)