-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = exports['essentialmode']:getObject()
local isShowMenu = false


---@param Profile table
---@param Questions table
function OpenMenu(Profile, Questions)
    if not Profile then return end
    SendNUIMessage({
        app = 'sun-quiz',
        method = 'open',
        data = {
            profile = Profile,
            quiz = Questions
        }
    })
    SetNuiFocus(true, true)
end

function CloseMenu()
    SendNUIMessage({
        app = 'sun-quiz',
        method = 'close'
    })
    SetNuiFocus(false, false)
end

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb()
end)


RegisterNUICallback('onFinish', function(data, cb)
    SetNuiFocus(false, false)
    print(json.encode(data))
    isShowMenu = false
    cb()
end)


RegisterNetEvent("sun-quiz:showMenu")
AddEventHandler("sun-quiz:showMenu", function(p, q)
    OpenMenu(p, q)
    isShowMenu = true
end)

RegisterNetEvent("sun-quiz:hideMenu")
AddEventHandler("sun-quiz:hideMenu", function()
    CloseMenu()
    isShowMenu = false
end)
