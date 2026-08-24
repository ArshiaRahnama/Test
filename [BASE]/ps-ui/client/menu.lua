local storedData = {}

local function createMenu(menuData)
    for _, item in ipairs(menuData) do
        storedData[item.id] = item
        if item.subMenu then
            for _, subItem in ipairs(item.subMenu) do
                storedData[subItem.id] = subItem
            end
        end
    end

    SendNUI("ShowMenu", nil, {
        menuData = menuData
    }, true)
end

RegisterNetEvent("ps-ui:CreateMenu", function(menuData)
    if not menuData then
        return
    end

    createMenu(menuData)
end)

local function hideMenu()
    SendNUI("HideMenu", nil, {}, false)
    storedData = {}
end

RegisterNUICallback('menuClose', function(data, cb)
    SetNuiFocus(false, false)
    storedData = {}
    cb('ok')
end)

RegisterNUICallback('MenuSelect', function(data, cb)
    local menuData = storedData[data.data.id]
    if menuData then
        if menuData.server then
            TriggerServerEvent(menuData.event, table.unpack(menuData.args))
        else
            TriggerEvent(menuData.event, table.unpack(menuData.args))
        end

        SetNuiFocus(false, false)
        storedData = {}
    end
    cb('ok')
end)

exports("CreateMenu", createMenu)
exports("HideMenu", hideMenu)