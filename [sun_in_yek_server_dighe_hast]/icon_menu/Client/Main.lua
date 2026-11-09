-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local List = {}
local openned = false

function OpenMenu(list, configs)
    local elements = {}

    for i,k in pairs(list) do
        local image = ""
        if not string.find(k.img, "http") and not string.find(k.img,'nui://') then
            image = "./img/"
        end

        table.insert(elements, {img = image .. k.img, text = k.text, text2 = k.text2})
    end

    List = list

    SendNUIMessage({
        elements = elements,
        configs = configs or config_default
    })

    openned = true
end

function ForceCloseMenu()
    SendNUIMessage({
        goBack = true
    })
    openned = false
end

CreateThread(function()
    Wait(5000)
    SendNUIMessage({
        config_default = config_default
    })
end)

-- CreateThread(function()
--     while true do
--         if openned then
--             DisableControlAction(0, config_keys.moveUP, true)
--             DisableControlAction(0, config_keys.moveDown, true)

--             if IsDisabledControlJustPressed(0,config_keys.moveUP) then 
--                 SendNUIMessage({
--                     upSelected = true
--                 })
--             elseif IsDisabledControlJustPressed(0,config_keys.moveDown) then
--                 SendNUIMessage({
--                     downSelected = true
--                 })
--             elseif IsControlJustPressed(0,config_keys.enter) then
--                 SendNUIMessage({
--                     enterSelected = true
--                 })
--             elseif IsControlJustPressed(0,config_keys.back) then
--                 ForceCloseMenu()
--             end
--         end

--         Wait(0)
--     end

-- end)

AddEventHandler('KeyDown:return',function()
    if openned then
        SendNUIMessage({
            enterSelected = true
        })
    end
end)

AddEventHandler('KeyDown:back',function()
    if openned then
        ForceCloseMenu()
    end
end)

AddEventHandler('KeyDown:up',function()
    if openned then
        SendNUIMessage({
            upSelected = true
        })
    end
end)
AddEventHandler('KeyDown:down',function()
    if openned then
        SendNUIMessage({
            downSelected = true
        })
    end
end)

RegisterNUICallback('enterSelected', function(data, cb)
    local selected = tonumber(data.selected)
    List[selected+1].callBack()

    cb('ok')
end)

exports("OpenMenu", OpenMenu)
exports("ForceCloseMenu", ForceCloseMenu)

exports("IsOpen",function()
    return openned
end)