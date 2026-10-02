local cam, cameraOffset = nil
local lastSkin = nil
local isMenuOpened = false
local handsup = false
local gender = nil

if Config.Core == "ESX" then
    ESX = Config.CoreExport()
elseif Config.Core == "QB-Core" then
    QBCore = Config.CoreExport()

    AddEventHandler('qb-menu:client:menuClosed', function()
        isMenuOpened = false
        if Config.UseQSInventory then
            exports[Config.QSInventoryName]:setInClothing(false)
        end
    end)
end

Citizen.CreateThread(function()
    Citizen.Wait(250)
    if Config.Menu == "ox_lib" then
        local import = LoadResourceFile('ox_lib', 'init.lua')
        local chunk = assert(load(import, '@@ox_lib/init.lua'))
        chunk()
    end
end)

RegisterNUICallback('buyClothes', function(data)
    if Config.Core == "ESX" then
        ESX.TriggerServerCallback('vms_clothestore:payForClothes', function(callback)
            if callback then
                DeleteSkinCam()
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if Config.SkinManager == "esx_skin" then
                        TriggerServerEvent('esx_skin:save', skin)
                    elseif Config.SkinManager == "fivem-appearance" then
                        TriggerEvent('fivem-appearance:setOutfit', Character_AP)
                        TriggerServerEvent('fivem-appearance:save', Character_AP)
                    elseif Config.SkinManager == "illenium-appearance" then
                        TriggerServerEvent('illenium-appearance:server:saveAppearance', Character_AP)
                    end
                    openSaveMenu()
                end)
                if Config.SoundsEffects then
                    PlaySoundFrontend(-1, 'PURCHASE', 'HUD_LIQUOR_STORE_SOUNDSET', 1)
                end
            else
                if Config.SoundsEffects then
                    PlaySoundFrontend(-1, 'ERROR', 'HUD_LIQUOR_STORE_SOUNDSET', 1)
                end
            end
        end, data.price, data.type)
    elseif Config.Core == "QB-Core" then
        QBCore.Functions.TriggerCallback('vms_clothestore:payForClothes', function(callback)
            if callback then
                DeleteSkinCam()
                if Config.SkinManager == 'qb-clothing' then
                    local model = GetEntityModel(PlayerPedId()) == GetHashKey('mp_m_freemode_01') and GetHashKey('mp_m_freemode_01') or GetHashKey('mp_f_freemode_01')
                    local character_encode = json.encode(Character_QB)
                    TriggerServerEvent("qb-clothing:saveSkin", model, character_encode)
                    openSaveMenu()
                elseif Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
                    local playerPed = PlayerPedId()
                    local appearance = exports[Config.SkinManager]:getPedAppearance(playerPed)
                    TriggerServerEvent(Config.SkinManager..':server:saveAppearance', appearance)
                    openSaveMenu()
                end
                if Config.SoundsEffects then
                    PlaySoundFrontend(-1, 'PURCHASE', 'HUD_LIQUOR_STORE_SOUNDSET', 1)
                end
            else
                if Config.SoundsEffects then
                    PlaySoundFrontend(-1, 'ERROR', 'HUD_LIQUOR_STORE_SOUNDSET', 1)
                end
            end
        end, data.price, data.type)
    end
end)

RegisterNUICallback('cancelClothes', function(data)
    if Config.Core == "ESX" then
        TriggerEvent('skinchanger:loadSkin', lastSkin)
    elseif Config.Core == "QB-Core" then
        if Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
            TriggerEvent(Config.SkinManager..':client:reloadSkin')
        elseif Config.SkinManager == "qb-clothing" then
            TriggerServerEvent("qb-clothes:loadPlayerSkin")
            TriggerServerEvent("qb-clothing:loadPlayerSkin")
        end
    end
    DeleteSkinCam()
end)

RegisterNUICallback("change", function(data)
    Character_ESX[data.type] = data.new
    if Config.Core == "ESX" then
        if Config.SkinManager == "esx_skin" then
            TriggerEvent('skinchanger:change', data.type, data.new)
        elseif Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
            appearance_switcher(data.type, data.new)
        end
    elseif Config.Core == "QB-Core" then
        if Config.SkinManager == "qb-clothing" then
            qbcore_switcher(data.type, data.new)
        elseif Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
            appearance_switcher(data.type, data.new)
        end
    end
    local secondItem, secondValue = GetMaxVal(data.type)
    if secondItem and secondValue then
        SendNUIMessage({
            action = 'updateSecondValue',
            secondItem = secondItem,
            secondValue = secondValue
        })
        if Config.Core == "ESX" then
            if Config.SkinManager == "esx_skin" then
                TriggerEvent('skinchanger:change', secondItem, 0)
            elseif Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
                appearance_switcher(secondItem, 0)
            end
        elseif Config.Core == "QB-Core" then
            if Config.SkinManager == "qb-clothing" then
                qbcore_switcher(secondItem, 0)
            elseif Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
                appearance_switcher(secondItem, 0)
            end
        end
    end
    if Config.SoundsEffects then
        PlaySoundFrontend(-1, "NAV_LEFT_RIGHT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    end
end)

RegisterNUICallback("change_camera", function(data)
    if cam and data.type then
        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)
        local newCamPos = Config.CameraHeight[data.type]
        SetCamCoord(cam, cameraOffset.x, cameraOffset.y, cameraOffset.z + newCamPos.z_height)
        PointCamAtCoord(cam, myCoords.x, myCoords.y, myCoords.z + newCamPos.z_height)
        SetCamFov(cam, newCamPos.fov)
        SendNUIMessage({
            action = 'updateInputs',
            fov = math.floor(newCamPos.fov)
        })
    end
end)

RegisterNUICallback("change_distance", function(data)
    if cam and data.distance then
        local myPed = PlayerPedId()
        local camFov = GetCamFov(cam)
        SetCamFov(cam, tonumber(data.distance)+.0)
    end
end)

RegisterNUICallback("change_rotate", function(data)
    if data.rotate then
        local myPed = PlayerPedId()
        local myHeading = tonumber(math.floor(GetEntityHeading(myPed))+.0)
        local newHeading = tonumber(math.floor(data.rotate)+.0)
        if myHeading ~= newHeading then
            SetEntityHeading(myPed, newHeading)
        end
    end
end)

RegisterNUICallback("hands_up", function(data)
    local myPed = PlayerPedId()
    if handsup then
        ClearPedTasksImmediately(myPed)
        RequestAnimDict(Config.ClothingPedAnimation[1])
        while not HasAnimDictLoaded(Config.ClothingPedAnimation[1]) do
            Wait(1)
        end
        TaskPlayAnim(myPed, Config.ClothingPedAnimation[1], Config.ClothingPedAnimation[2], 8.0, 0.0, -1, 1, 0, 0, 0, 0)
        handsup = false
    elseif not handsup then
        RequestAnimDict(Config.HandsUpAnimation[1])
        while not HasAnimDictLoaded(Config.HandsUpAnimation[1]) do
            Wait(1)
        end
        TaskPlayAnim(myPed, Config.HandsUpAnimation[1], Config.HandsUpAnimation[2], 8.0, 0.0, -1, Config.HandsUpAnimation[3], 0, 0, 0, 0)
        handsup = true
    end
end)

function OpenManage()
    if Config.Core == "ESX" then
        if Config.Menu == "esx_context" then
            ESX.TriggerServerCallback("vms_clothestore:getPlayerDressing", function(dressing)
                local elements = {{unselectable = true, icon = Config.Translate['manage_header'].icon, title = Config.Translate['manage_header'].name}}
                if Config.SkinManager == "esx_skin" then
                    for i = 1, #dressing, 1 do
                        elements[#elements + 1] = {title = dressing[i]}
                    end
                elseif Config.SkinManager == "fivem-appearance" then
                    for i = 1, #dressing, 1 do
                        elements[#elements + 1] = {title = dressing[i].name}
                    end
                elseif Config.SkinManager == "illenium-appearance" then
                    for i = 1, #dressing, 1 do
                        elements[#elements + 1] = {title = dressing[i].outfitname}
                    end
                end
                ESX.OpenContext(Config.ESXContext_Align, elements, function(menu, element)
                    local elements2 = {
                        {unselectable = true, title = (Config.Translate['title_remove'].name):format(element.title), icon = Config.Translate['title_remove'].icon},
                        {title = Config.Translate['remove_yes'].name, icon = Config.Translate['remove_yes'].icon, value = "yes", id = element.title},
                        {title = Config.Translate['remove_no'].name, icon = Config.Translate['remove_no'].icon, value = "no"}
                    }
                    ESX.OpenContext(Config.ESXContext_Align, elements2, function(menu2, element2)
                        if element2.value == "yes" and element2.id then
                            TriggerServerEvent('vms_clothestore:removeClothe', element2.id)
                            ESX.CloseContext()
                        else
                            OpenManage()
                        end
                    end, function(menu)
                        isMenuOpened = false
                    end)
                end, function(menu)
                    isMenuOpened = false
                end)
            end)
        elseif Config.Menu == "esx_menu_default" then
           ESX.TriggerServerCallback("vms_clothestore:getPlayerDressing", function(dressing)
               local elements = {}
               if Config.SkinManager == "esx_skin" then
                   for i = 1, #dressing, 1 do
                       elements[#elements + 1] = {label = dressing[i]}
                   end
               elseif Config.SkinManager == "fivem-appearance" then
                   for i = 1, #dressing, 1 do
                       elements[#elements + 1] = {label = dressing[i].name}
                   end
                elseif Config.SkinManager == "illenium-appearance" then
                    for i = 1, #dressing, 1 do
                        elements[#elements + 1] = {label = dressing[i].outfitname}
                    end
                end
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'select_option', {
                    title = Config.Translate['manage_header'].name, 
                    elements = elements, 
                    align = Config.ESXMenuDefault_Align
                }, function(data, menu)
                    if data.current.label then
                        local elements2 = {
                            {label = Config.Translate['remove_yes'].name, value = "yes", id = data.current.label},
                            {label = Config.Translate['remove_no'].name, value = "no"}
                        }
                        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'select_option2', {
                            title = (Config.Translate['title_remove'].name):format(data.current.label), 
                            elements = elements2, 
                            align = Config.ESXMenuDefault_Align
                        }, function(data2, menu2)
                            if data2.current.value == "yes" and data2.current.id then
                                TriggerServerEvent('vms_clothestore:removeClothe', data2.current.id)
                                menu2.close()
                                isMenuOpened = false
                            else
                                menu2.close()
                                OpenManage()
                            end
                        end, function(data2, menu2)
                            menu2.close()
                            isMenuOpened = false
                        end)
                        menu.close()
                    end
                end, function(data, menu)
                    isMenuOpened = false
                    menu.close()
                end)
            end)
        elseif Config.Menu == "ox_lib" then
            ESX.TriggerServerCallback("vms_clothestore:getPlayerDressing", function(dressing)
                local elements = {}
                if Config.SkinManager == "esx_skin" then
                    for i = 1, #dressing, 1 do
                        elements[#elements + 1] = {
                            title = dressing[i], 
                            onSelect = function()
                                local elements2 = {
                                    {
                                        icon = Config.Translate['remove_yes'].icon,
                                        title = Config.Translate['remove_yes'].name, 
                                        onSelect = function()
                                            TriggerServerEvent('vms_clothestore:removeClothe', dressing[i])
                                            isMenuOpened = false
                                        end,
                                        onExit = function()
                                            isMenuOpened = false
                                        end
                                    },
                                    {
                                        icon = Config.Translate['remove_no'].icon,
                                        title = Config.Translate['remove_no'].name, 
                                        onSelect = function()
                                            OpenManage()
                                        end,
                                        onExit = function()
                                            isMenuOpened = false
                                        end
                                    },
                                }
                                lib.registerContext({
                                    id = "clothestore-manageclothe",
                                    title = (Config.Translate['title_remove'].name):format(dressing[i]),
                                    options = elements2,
                                    onExit = function()
                                        isMenuOpened = false
                                    end
                                })
                                lib.showContext('clothestore-manageclothe')
                            end,
                            onExit = function()
                                isMenuOpened = false
                            end
                        }
                    end
                elseif Config.SkinManager == "fivem-appearance" then
                    for i = 1, #dressing, 1 do
                        elements[#elements + 1] = {
                            title = dressing[i].name, 
                            onSelect = function()
                                local elements2 = {
                                    {
                                        icon = Config.Translate['remove_yes'].icon,
                                        title = Config.Translate['remove_yes'].name, 
                                        onSelect = function()
                                            TriggerServerEvent('vms_clothestore:removeClothe', dressing[i].name)
                                            isMenuOpened = false
                                        end,
                                        onExit = function()
                                            isMenuOpened = false
                                        end
                                    },
                                    {
                                        icon = Config.Translate['remove_no'].icon,
                                        title = Config.Translate['remove_no'].name, 
                                        onSelect = function()
                                            OpenManage()
                                        end,
                                        onExit = function()
                                            isMenuOpened = false
                                        end
                                    },
                                }
                                lib.registerContext({
                                    id = "clothestore-manageclothe",
                                    title = (Config.Translate['title_remove'].name):format(dressing[i].name),
                                    options = elements2,
                                    onExit = function()
                                        isMenuOpened = false
                                    end
                                })
                                lib.showContext('clothestore-manageclothe')
                            end,
                            onExit = function()
                                isMenuOpened = false
                            end
                        }
                    end
                elseif Config.SkinManager == "illenium-appearance" then
                    for i = 1, #dressing, 1 do
                        elements[#elements + 1] = {
                            title = dressing[i].outfitname, 
                            onSelect = function()
                                local elements2 = {
                                    {
                                        icon = Config.Translate['remove_yes'].icon,
                                        title = Config.Translate['remove_yes'].name, 
                                        onSelect = function()
                                            TriggerServerEvent('vms_clothestore:removeClothe', dressing[i].outfitname)
                                            isMenuOpened = false
                                        end,
                                        onExit = function()
                                            isMenuOpened = false
                                        end
                                    },
                                    {
                                        icon = Config.Translate['remove_no'].icon,
                                        title = Config.Translate['remove_no'].name, 
                                        onSelect = function()
                                            OpenManage()
                                        end,
                                        onExit = function()
                                            isMenuOpened = false
                                        end
                                    },
                                }
                                lib.registerContext({
                                    id = "clothestore-manageclothe",
                                    title = (Config.Translate['title_remove'].name):format(dressing[i].outfitname),
                                    options = elements2,
                                    onExit = function()
                                        isMenuOpened = false
                                    end
                                })
                                lib.showContext('clothestore-manageclothe')
                            end,
                            onExit = function()
                                isMenuOpened = false
                            end
                        }
                    end
                end
                lib.registerContext({
                    id = "clothestore-manage",
                    title = Config.Translate['menu.your_market'],
                    options = elements,
                    onExit = function()
                        isMenuOpened = false
                    end
                })
                lib.showContext('clothestore-manage')
            end)
        end
    elseif Config.Core == "QB-Core" then
        if Config.SkinManager == "qb-clothing" then
            if Config.Menu == "qb-menu" then
                QBCore.Functions.TriggerCallback('qb-clothing:server:getOutfits', function(result)
                    local elements = {{
                        header = Config.Translate['manage_header'].name,
                        icon = Config.Translate['manage_header'].icon,
                        isMenuHeader = true,
                    }}
                    for k, v in pairs(result) do
                        elements[#elements+1] = {
                            header = v.id,
                            txt = v.outfitname,
                            icon = "fas fa-shirt",
                            params = {
                                isAction = true,
                                event = function()
                                    local elements2 = {
                                        {
                                            header = (Config.Translate['title_remove'].name):format(v.outfitname),
                                            icon = Config.Translate['title_remove'].icon,
                                            isMenuHeader = true,
                                        },
                                        {
                                            header = Config.Translate['remove_yes'].name,
                                            icon = Config.Translate['remove_yes'].icon,
                                            params = {
                                                isAction = true,
                                                event = function()
                                                    TriggerServerEvent('vms_clothestore:removeClothe', v.outfitId)
                                                    isMenuOpened = false
                                                end
                                            }
                                        },
                                        {
                                            header = Config.Translate['remove_no'].name,
                                            icon = Config.Translate['remove_no'].icon,
                                            params = {
                                                isAction = true,
                                                event = function()
                                                    OpenManage()
                                                end
                                            }
                                        },
                                    }
                                    exports['qb-menu']:openMenu(elements2)
                                end,
                            }
                        }
                    end
                    exports['qb-menu']:openMenu(elements)
                end)
            elseif Config.Menu == "ox_lib" then
                QBCore.Functions.TriggerCallback('qb-clothing:server:getOutfits', function(result)
                    local elements = {}
                    for k, v in pairs(result) do
                        elements[#elements + 1] = {
                            title = Config.Translate['manage_header'].name, 
                            onSelect = function()
                                local elements2 = {
                                    {
                                        icon = Config.Translate['remove_yes'].icon,
                                        title = Config.Translate['remove_yes'].name, 
                                        onSelect = function()
                                            TriggerServerEvent('vms_clothestore:removeClothe', v.outfitId)
                                            isMenuOpened = false
                                        end,
                                        onExit = function()
                                            isMenuOpened = false
                                        end
                                    },
                                    {
                                        icon = Config.Translate['remove_no'].icon,
                                        title = Config.Translate['remove_no'].name, 
                                        onSelect = function()
                                            OpenManage()
                                        end,
                                        onExit = function()
                                            isMenuOpened = false
                                        end
                                    },
                                }
                                lib.registerContext({
                                    id = "clothestore-manageclothe",
                                    title = (Config.Translate['title_remove'].name):format(v.outfitname),
                                    options = elements2,
                                    onExit = function()
                                        isMenuOpened = false
                                    end
                                })
                                lib.showContext('clothestore-manageclothe')
                            end,
                            onExit = function()
                                isMenuOpened = false
                            end
                        }
                    end
                    lib.registerContext({
                        id = "clothestore-manage",
                        title = Config.Translate['menu.your_market'],
                        options = elements,
                        onExit = function()
                            isMenuOpened = false
                        end
                    })
                    lib.showContext('clothestore-manage')
                end)
            end
        elseif Config.SkinManager == "illenium-appearance" then
            if Config.Menu == "qb-menu" then
                QBCore.Functions.TriggerCallback('vms_clothestore:getPlayerDressing', function(result)
                    local elements = {{
                        header = Config.Translate['manage_header'].name,
                        icon = Config.Translate['manage_header'].icon,
                        isMenuHeader = true,
                    }}
                    for k, v in pairs(result) do
                        elements[#elements+1] = {
                            header = v.id,
                            txt = v.outfitname,
                            icon = "fas fa-shirt",
                            params = {
                                isAction = true,
                                event = function()
                                    local elements2 = {
                                        {
                                            header = (Config.Translate['title_remove'].name):format(v.outfitname),
                                            icon = Config.Translate['title_remove'].icon,
                                            isMenuHeader = true,
                                        },
                                        {
                                            header = Config.Translate['remove_yes'].name,
                                            icon = Config.Translate['remove_yes'].icon,
                                            params = {
                                                isAction = true,
                                                event = function()
                                                    TriggerServerEvent('vms_clothestore:removeClothe', v.id)
                                                    isMenuOpened = false
                                                end
                                            }
                                        },
                                        {
                                            header = Config.Translate['remove_no'].name,
                                            icon = Config.Translate['remove_no'].icon,
                                            params = {
                                                isAction = true,
                                                event = function()
                                                    OpenManage()
                                                end
                                            }
                                        },
                                    }
                                    exports['qb-menu']:openMenu(elements2)
                                end,
                            }
                        }
                    end
                    exports['qb-menu']:openMenu(elements)
                end)
            elseif Config.Menu == "ox_lib" then
                QBCore.Functions.TriggerCallback('vms_clothestore:getPlayerDressing', function(result)
                    local elements = {}
                    for k, v in pairs(result) do
                        elements[#elements + 1] = {
                            title = v.outfitname, 
                            onSelect = function()
                                local elements2 = {
                                    {
                                        icon = Config.Translate['remove_yes'].icon,
                                        title = Config.Translate['remove_yes'].name, 
                                        onSelect = function()
                                            TriggerServerEvent('vms_clothestore:removeClothe', v.id)
                                            isMenuOpened = false
                                        end,
                                        onExit = function()
                                            isMenuOpened = false
                                        end
                                    },
                                    {
                                        icon = Config.Translate['remove_no'].icon,
                                        title = Config.Translate['remove_no'].name, 
                                        onSelect = function()
                                            OpenManage()
                                        end,
                                        onExit = function()
                                            isMenuOpened = false
                                        end
                                    },
                                }
                                lib.registerContext({
                                    id = "clothestore-manageclothe",
                                    title = (Config.Translate['title_remove'].name):format(v.outfitname),
                                    options = elements2,
                                    onExit = function()
                                        isMenuOpened = false
                                    end
                                })
                                lib.showContext('clothestore-manageclothe')
                            end,
                            onExit = function()
                                isMenuOpened = false
                            end
                        }
                    end
                    lib.registerContext({
                        id = "clothestore-manage",
                        title = Config.Translate['manage_header'].name,
                        options = elements,
                        onExit = function()
                            isMenuOpened = false
                        end
                    })
                    lib.showContext('clothestore-manage')
                end)
            end
        end
    end
end

function OpenWardrobe()
    if Config.UseQSInventory then
        exports[Config.QSInventoryName]:setInClothing(true)
    end
    if Config.Core == "ESX" then
        if Config.Menu == "esx_context" then
            if Config.SkinManager == "esx_skin" then
                ESX.TriggerServerCallback("vms_clothestore:getPlayerDressing", function(dressing)
                    local elements = {{unselectable = true, icon = Config.Translate['wardrobe_header'].icon, title = Config.Translate['wardrobe_header'].name}}
                    for i = 1, #dressing, 1 do
                        elements[#elements + 1] = {title = dressing[i], value = i}
                    end
                    ESX.OpenContext(Config.ESXContext_Align, elements, function(menu, element)
                        TriggerEvent("skinchanger:getSkin", function(skin)
                            ESX.TriggerServerCallback("vms_clothestore:getPlayerOutfit", function(clothes)
                                TriggerEvent("skinchanger:loadClothes", skin, clothes)
                                TriggerEvent("esx_skin:setLastSkin", skin)
                                TriggerEvent('skinchanger:getSkin', function(skin)
                                    TriggerServerEvent('esx_skin:save', skin)
                                end)
                            end, element.value)
                        end)
                    end, function(menu)
                        isMenuOpened = false
                        if Config.UseQSInventory then
                            exports[Config.QSInventoryName]:setInClothing(false)
                        end
                    end)
                end)
            elseif Config.SkinManager == "fivem-appearance" then
                ESX.TriggerServerCallback("vms_clothestore:getPlayerDressing", function(dressing)
                    local elements = {{unselectable = true, icon = Config.Translate['wardrobe_header'].icon, title = Config.Translate['wardrobe_header'].name}}
                    for i = 1, #dressing, 1 do
                        elements[#elements + 1] = {
                            title = dressing[i].name, 
                            value = {
                                ped = dressing[i].ped,
                                components = dressing[i].components,
                                props = dressing[i].props
                            }
                        }
                    end
                    ESX.OpenContext(Config.ESXContext_Align, elements, function(menu, element)
                        TriggerEvent('fivem-appearance:setOutfit', element.value)
                    end, function(menu)
                        isMenuOpened = false
                        if Config.UseQSInventory then
                            exports[Config.QSInventoryName]:setInClothing(false)
                        end
                    end)
                end)
            elseif Config.SkinManager == "illenium-appearance" then
                ESX.TriggerServerCallback("vms_clothestore:getPlayerDressing", function(dressing)
                    local elements = {{unselectable = true, icon = Config.Translate['wardrobe_header'].icon, title = Config.Translate['wardrobe_header'].name}}
                    for i = 1, #dressing, 1 do
                        elements[#elements + 1] = {
                            title = dressing[i].outfitname, 
                            value = {
                                model = dressing[i].model,
                                components = dressing[i].components,
                                props = dressing[i].props
                            }
                        }
                    end
                    ESX.OpenContext(Config.ESXContext_Align, elements, function(menu, element)
                        TriggerEvent('illenium-appearance:client:changeOutfit', element.value)
                    end, function(menu)
                        isMenuOpened = false
                        if Config.UseQSInventory then
                            exports[Config.QSInventoryName]:setInClothing(false)
                        end
                    end)
                end)
            end
        elseif Config.Menu == "esx_menu_default" then
            if Config.SkinManager == "esx_skin" then
                ESX.TriggerServerCallback("vms_clothestore:getPlayerDressing", function(dressing)
                    local elements = {}
                    for i = 1, #dressing, 1 do
                        elements[#elements + 1] = {label = dressing[i], value = i}
                    end
                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'select_option', {title = Config.Translate['wardrobe_header'].name, elements = elements, align = Config.ESXMenuDefault_Align}, function(data, menu)
                        if data.current.value then
                            TriggerEvent("skinchanger:getSkin", function(skin)
                                ESX.TriggerServerCallback("vms_clothestore:getPlayerOutfit", function(clothes)
                                    TriggerEvent("skinchanger:loadClothes", skin, clothes)
                                    TriggerEvent("esx_skin:setLastSkin", skin)
                                    TriggerEvent('skinchanger:getSkin', function(skin)
                                        TriggerServerEvent('esx_skin:save', skin)

                                    end)
                                end, data.current.value) 
                            end)
                        end
                    end, function(data, menu)
                        isMenuOpened = false
                        if Config.UseQSInventory then
                            exports[Config.QSInventoryName]:setInClothing(false)
                        end
                        menu.close()
                    end)
                end)
            elseif Config.SkinManager == "fivem-appearance" then
                ESX.TriggerServerCallback("vms_clothestore:getPlayerDressing", function(dressing)
                    local elements = {}
                    for i = 1, #dressing, 1 do
                        elements[#elements + 1] = {
                            label = dressing[i].name, 
                            value = {
                                ped = dressing[i].ped,
                                components = dressing[i].components,
                                props = dressing[i].props
                            }
                        }
                    end
                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'select_option', {title = Config.Translate['wardrobe_header'].name, elements = elements, align = Config.ESXMenuDefault_Align}, function(data, menu)
                        if data.current.value then
                            TriggerEvent('fivem-appearance:setOutfit', data.current.value)
                        end
                    end, function(data, menu)
                        isMenuOpened = false
                        if Config.UseQSInventory then
                            exports[Config.QSInventoryName]:setInClothing(false)
                        end
                        menu.close()
                    end)
                end)
            elseif Config.SkinManager == "illenium-appearance" then
                ESX.TriggerServerCallback("vms_clothestore:getPlayerDressing", function(dressing)
                    local elements = {}
                    for i = 1, #dressing, 1 do
                        elements[#elements + 1] = {
                            label = dressing[i].outfitname, 
                            value = {
                                model = dressing[i].model,
                                components = dressing[i].components,
                                props = dressing[i].props
                            }
                        }
                    end
                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'select_option', {title = Config.Translate['wardrobe_header'].name, elements = elements, align = Config.ESXMenuDefault_Align}, function(data, menu)
                        if data.current.value then
                            TriggerEvent('illenium-appearance:client:changeOutfit', data.current.value)
                        end
                    end, function(data, menu)
                        isMenuOpened = false
                        if Config.UseQSInventory then
                            exports[Config.QSInventoryName]:setInClothing(false)
                        end
                        menu.close()
                    end)
                end)
            end
        elseif Config.Menu == "ox_lib" then
            local elements = {}
            if Config.SkinManager == "esx_skin" then
                ESX.TriggerServerCallback("vms_clothestore:getPlayerDressing", function(dressing)
                    for i = 1, #dressing, 1 do
                        elements[#elements + 1] = {
                            title = dressing[i], 
                            onSelect = function()
                                TriggerEvent("skinchanger:getSkin", function(skin)
                                    ESX.TriggerServerCallback("vms_clothestore:getPlayerOutfit", function(clothes)
                                        TriggerEvent("skinchanger:loadClothes", skin, clothes)
                                        TriggerEvent("esx_skin:setLastSkin", skin)
                                        TriggerEvent('skinchanger:getSkin', function(skin)
                                            TriggerServerEvent('esx_skin:save', skin)
                                        end)
                                        if Config.UseQSInventory then
                                            exports[Config.QSInventoryName]:setInClothing(false)
                                        end
                                        isMenuOpened = false
                                    end, i)
                                end)
                            end,
                            onExit = function()
                                if Config.UseQSInventory then
                                    exports[Config.QSInventoryName]:setInClothing(false)
                                end
                                isMenuOpened = false
                            end
                        }
                    end
                    lib.registerContext({
                        id = "clothestore-wardrobe",
                        title = Config.Translate['wardrobe_header'].name,
                        options = elements,
                        onExit = function()
                            if Config.UseQSInventory then
                                exports[Config.QSInventoryName]:setInClothing(false)
                            end
                            isMenuOpened = false
                        end
                    })
                    lib.showContext('clothestore-wardrobe')
                end)
            elseif Config.SkinManager == "fivem-appearance" then
                ESX.TriggerServerCallback("vms_clothestore:getPlayerDressing", function(dressing)
                    for i = 1, #dressing, 1 do
                        elements[#elements + 1] = {
                            title = dressing[i].name, 
                            onSelect = function()
                                TriggerEvent('fivem-appearance:setOutfit', {
                                    ped = dressing[i].ped,
                                    components = dressing[i].components,
                                    props = dressing[i].props
                                })
                                if Config.UseQSInventory then
                                    exports[Config.QSInventoryName]:setInClothing(false)
                                end
                                isMenuOpened = false
                            end,
                            onExit = function()
                                if Config.UseQSInventory then
                                    exports[Config.QSInventoryName]:setInClothing(false)
                                end
                                isMenuOpened = false
                            end
                        }
                    end
                    lib.registerContext({
                        id = "clothestore-wardrobe",
                        title = Config.Translate['wardrobe_header'].name,
                        options = elements,
                        onExit = function()
                            if Config.UseQSInventory then
                                exports[Config.QSInventoryName]:setInClothing(false)
                            end
                            isMenuOpened = false
                        end
                    })
                    lib.showContext('clothestore-wardrobe')
                end)
            elseif Config.SkinManager == "illenium-appearance" then
                ESX.TriggerServerCallback("vms_clothestore:getPlayerDressing", function(dressing)
                    for i = 1, #dressing, 1 do
                        elements[#elements + 1] = {
                            title = dressing[i].outfitname, 
                            onSelect = function()
                                TriggerEvent('illenium-appearance:client:changeOutfit', {
                                    model = dressing[i].model,
                                    components = dressing[i].components,
                                    props = dressing[i].props
                                })
                                if Config.UseQSInventory then
                                    exports[Config.QSInventoryName]:setInClothing(false)
                                end
                                isMenuOpened = false
                            end,
                            onExit = function()
                                if Config.UseQSInventory then
                                    exports[Config.QSInventoryName]:setInClothing(false)
                                end
                                isMenuOpened = false
                            end
                        }
                    end
                    lib.registerContext({
                        id = "clothestore-wardrobe",
                        title = Config.Translate['wardrobe_header'].name,
                        options = elements,
                        onExit = function()
                            if Config.UseQSInventory then
                                exports[Config.QSInventoryName]:setInClothing(false)
                            end
                            isMenuOpened = false
                        end
                    })
                    lib.showContext('clothestore-wardrobe')
                end)
            end
        end
    elseif Config.Core == "QB-Core" then
        if Config.Menu == "qb-menu" then
            if Config.SkinManager == "fivem-appearance" then
                TriggerEvent('qb-clothing:client:openOutfitMenu')
                isMenuOpened = false
                if Config.UseQSInventory then
                    exports[Config.QSInventoryName]:setInClothing(false)
                end
            elseif Config.SkinManager == "qb-clothing" then
                QBCore.Functions.TriggerCallback('qb-clothing:server:getOutfits', function(result)
                    local elements = {
                        {
                            header = Config.Translate['select_option'].name,
                            icon = Config.Translate['select_option'].icon,
                            isMenuHeader = true,
                        },
                    }
                    for k, v in pairs(result) do
                        elements[#elements+1] = {
                            header = v.id,
                            txt = v.outfitname,
                            icon = "fas fa-shirt",
                            params = {
                                isAction = true,
                                event = function()
                                    TriggerEvent('qb-clothing:client:loadOutfit', {outfitData = v.skin, outfitId = v.outfitId})
                                    TriggerServerEvent("qb-clothing:saveSkin", v.model, json.encode(v.skin))
                                    if Config.UseQSInventory then
                                        exports[Config.QSInventoryName]:setInClothing(false)
                                    end
                                    isMenuOpened = false
                                end,
                            }
                        }
                    end
                    exports['qb-menu']:openMenu(elements)
                end)
            elseif Config.SkinManager == "illenium-appearance" then
                QBCore.Functions.TriggerCallback('vms_clothestore:getPlayerDressing', function(dressing)
                    local elements = {
                        {
                            header = Config.Translate['select_option'].name,
                            icon = Config.Translate['select_option'].icon,
                            isMenuHeader = true,
                        },
                    }
                    for k, v in pairs(dressing) do
                        local value = {
                            model = v.model,
                            components = v.components,
                            props = v.props
                        }
                        elements[#elements + 1] = {
                            header = v.outfitname, 
                            icon = "fas fa-shirt",
                            params = {
                                isAction = true,
                                event = function()
                                    TriggerEvent('illenium-appearance:client:changeOutfit', value)
                                    if Config.UseQSInventory then
                                        exports[Config.QSInventoryName]:setInClothing(false)
                                    end
                                    isMenuOpened = false
                                end,
                            },
                        }
                    end
                    exports['qb-menu']:openMenu(elements)
                end)
            end
        elseif Config.Menu == "ox_lib" then
            local elements = {}
            if Config.SkinManager == "fivem-appearance" then
                TriggerEvent('qb-clothing:client:openOutfitMenu')
                if Config.UseQSInventory then
                    exports[Config.QSInventoryName]:setInClothing(false)
                end
                isMenuOpened = false
            elseif Config.SkinManager == "qb-clothing" then
                QBCore.Functions.TriggerCallback('qb-clothing:server:getOutfits', function(result)
                    for k, v in pairs(result) do
                        elements[#elements + 1] = {
                            title = v.outfitname, 
                            onSelect = function()
                                TriggerEvent('qb-clothing:client:loadOutfit', {outfitData = v.skin, outfitId = v.outfitId})
                                TriggerServerEvent("qb-clothing:saveSkin", v.model, json.encode(v.skin))
                                if Config.UseQSInventory then
                                    exports[Config.QSInventoryName]:setInClothing(false)
                                end
                                isMenuOpened = false
                            end,
                            onExit = function()
                                if Config.UseQSInventory then
                                    exports[Config.QSInventoryName]:setInClothing(false)
                                end
                                isMenuOpened = false
                            end
                        }
                    end
                    lib.registerContext({
                        id = "clothestore-wardrobe",
                        title = Config.Translate['wardrobe_header'].name,
                        options = elements,
                        onExit = function()
                            if Config.UseQSInventory then
                                exports[Config.QSInventoryName]:setInClothing(false)
                            end
                            isMenuOpened = false
                        end
                    })
                    lib.showContext('clothestore-wardrobe')
                end)
            elseif Config.SkinManager == "illenium-appearance" then
                QBCore.Functions.TriggerCallback('vms_clothestore:getPlayerDressing', function(dressing)
                    for k, v in pairs(dressing) do
                        elements[#elements + 1] = {
                            title = v.outfitname, 
                            onSelect = function()
                                TriggerEvent('illenium-appearance:client:changeOutfit', {
                                    model = v.model,
                                    components = v.components,
                                    props = v.props
                                })
                                if Config.UseQSInventory then
                                    exports[Config.QSInventoryName]:setInClothing(false)
                                end
                                isMenuOpened = false
                            end,
                            onExit = function()
                                if Config.UseQSInventory then
                                    exports[Config.QSInventoryName]:setInClothing(false)
                                end
                                isMenuOpened = false
                            end
                        }
                    end
                    lib.registerContext({
                        id = "clothestore-wardrobe",
                        title = Config.Translate['wardrobe_header'].name,
                        options = elements,
                        onExit = function()
                            if Config.UseQSInventory then
                                exports[Config.QSInventoryName]:setInClothing(false)
                            end
                            isMenuOpened = false
                        end
                    })
                    lib.showContext('clothestore-wardrobe')
                end)
            end
        end
    end
end

function SelectCategory(store)
    if Config.Menu == "esx_context" then
        local elements = {
            {unselectable = true,  title = Config.Translate['select_option'].name},
            { title = Config.Translate['open_wardrobe'].name, value = "wardrobe"},
            { title = Config.Translate['open_manage'].name, value = "manage"},
            { title = Config.Translate['open_store'].name, value = "store"},
        }
        ESX.OpenContext(Config.ESXContext_Align, elements, function(menu, element)
            if element.value == "wardrobe" then
                ESX.CloseContext()
                OpenWardrobe()
                isMenuOpened = true
            elseif element.value == "store" then
                ESX.CloseContext()
                OpenClothestore(store)
                isMenuOpened = true
            elseif element.value == "manage" then
                ESX.CloseContext()
                OpenManage()
                isMenuOpened = true
            end
        end, function(menu)
            isMenuOpened = false
        end)
    elseif Config.Menu == "esx_menu_default" then
        local elements = {
            {icon = Config.Translate['open_wardrobe'].icon, label = Config.Translate['open_wardrobe'].name, value = "wardrobe"},
            {icon = Config.Translate['open_manage'].icon, label = Config.Translate['open_manage'].name, value = "manage"},
            {icon = Config.Translate['open_store'].icon, label = Config.Translate['open_store'].name, value = "store"},
        }
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'select_option', {title = Config.Translate['select_option'].name, elements = elements, align = Config.ESXMenuDefault_Align}, function(data, menu)
            if data.current.value == 'wardrobe' then
                menu.close()
                OpenWardrobe()
                isMenuOpened = true
            elseif data.current.value == 'store' then
                menu.close()
                OpenClothestore(store)
                isMenuOpened = true
            elseif data.current.value == "manage" then
                menu.close()
                OpenManage()
                isMenuOpened = true
            end
        end, function(data, menu)
            isMenuOpened = false
            menu.close()
        end)
    elseif Config.Menu == "qb-menu" then
        if Config.SkinManager == 'qb-clothing' or Config.SkinManager == "illenium-appearance" then
            exports['qb-menu']:openMenu({
                {
                    header = Config.Translate['select_option'].name,
                    icon = Config.Translate['select_option'].icon,
                    isMenuHeader = true,
                },
                {
                    header = "",
                    txt = Config.Translate['open_wardrobe'].name,
                    icon = Config.Translate['open_wardrobe'].icon,
                    params = {
                        isAction = true,
                        event = function()
                            OpenWardrobe()
                            isMenuOpened = true
                        end,
                    }
                },
                {
                    header = "",
                    txt = Config.Translate['open_manage'].name,
                    icon = Config.Translate['open_manage'].icon,
                    params = {
                        isAction = true,
                        event = function()
                            OpenManage()
                            isMenuOpened = true
                        end,
                    }
                },
                {
                    header = "",
                    txt = Config.Translate['open_store'].name,
                    icon = Config.Translate['open_store'].icon,
                    params = {
                        isAction = true,
                        event = function()
                            OpenClothestore(store)
                            isMenuOpened = true
                        end,
                    }
                },
            })
        elseif Config.SkinManager == 'fivem-appearance' then
            exports['qb-menu']:openMenu({
                {
                    header = Config.Translate['select_option'].name,
                    icon = Config.Translate['select_option'].icon,
                    isMenuHeader = true,
                },
                {
                    header = "",
                    txt = Config.Translate['open_wardrobe'].name,
                    icon = Config.Translate['open_wardrobe'].icon,
                    params = {
                        isAction = true,
                        event = function()
                            OpenWardrobe()
                            isMenuOpened = true
                        end,
                    }
                },
                {
                    header = "",
                    txt = Config.Translate['open_store'].name,
                    icon = Config.Translate['open_store'].icon,
                    params = {
                        isAction = true,
                        event = function()
                            OpenClothestore(store)
                            isMenuOpened = true
                        end,
                    }
                },
            })
        end
    elseif Config.Menu == "ox_lib" then
        local elements = {}
        if Config.Core == "QB-Core" and Config.SkinManager == 'fivem-appearance' then
            elements = {
                {
                    icon = Config.Translate['open_wardrobe'].icon, 
                    title = Config.Translate['open_wardrobe'].name,
                    onSelect = function()
                        OpenWardrobe()
                        isMenuOpened = true
                    end,
                    onExit = function()
                        isMenuOpened = false
                    end
                },
                {
                    icon = Config.Translate['open_store'].icon, 
                    title = Config.Translate['open_store'].name,
                    onSelect = function()
                        OpenClothestore(store)
                        isMenuOpened = true
                    end,
                    onExit = function()
                        isMenuOpened = false
                    end
                },
            }
        else
            elements = {
                {
                    icon = Config.Translate['open_wardrobe'].icon, 
                    title = Config.Translate['open_wardrobe'].name,
                    onSelect = function()
                        OpenWardrobe()
                        isMenuOpened = true
                    end,
                    onExit = function()
                        isMenuOpened = false
                    end
                },
                {
                    icon = Config.Translate['open_manage'].icon, 
                    title = Config.Translate['open_manage'].name,
                    onSelect = function()
                        OpenManage()
                        isMenuOpened = true
                    end,
                    onExit = function()
                        isMenuOpened = false
                    end
                },
                {
                    icon = Config.Translate['open_store'].icon, 
                    title = Config.Translate['open_store'].name,
                    onSelect = function()
                        OpenClothestore(store)
                        isMenuOpened = true
                    end,
                    onExit = function()
                        isMenuOpened = false
                    end
                },
            }
        end
        lib.registerContext({
            id = "clothestore-select",
            title = Config.Translate['select_option'].name,
            options = elements,
            onExit = function()
                isMenuOpened = false
            end
        })
        lib.showContext('clothestore-select')
    end
end

function openSaveMenu()
    if not Config.SaveClothesMenu then
        return
    end
    isMenuOpened = true
    if Config.Core == "ESX" then
        ESX.TriggerServerCallback('vms_clothestore:checkPropertyDataStore', function(foundStore)
            if foundStore then
                if Config.Menu == "esx_context" then
                    local elements = {
                        {unselectable = true, icon = Config.Translate['menu:header'].icon, title = Config.Translate['menu:header'].name},
                        {icon = Config.Translate['menu:yes'].icon, title = Config.Translate['menu:yes'].name, value = "yes"},
                        {icon = Config.Translate['menu:no'].icon, title = Config.Translate['menu:no'].name, value = "no"},
                    }
                    ESX.OpenContext(Config.ESXContext_Align, elements, function(menu, element)
                        if element.value == "yes" then
                            local elements2 = {
                                {unselectable = true, title = Config.Translate['esx_context:title'].name, icon = Config.Translate['esx_context:title'].icon},
                                {title = Config.Translate['esx_context:placeholder_title'], input = true, inputType = "text", inputPlaceholder = Config.Translate['esx_context:placeholder']},
                                {title = Config.Translate['esx_context:confirm'].name, icon = Config.Translate['esx_context:confirm'].icon, value = "confirm"}
                            }
                            ESX.OpenContext(Config.ESXContext_Align, elements2, function(menu2,element2)
                                if string.len(menu2.eles[2].inputValue) < 1 then
                                    return Config.Notification('name_is_too_short', 3500, 'error')
                                end
                                if Config.SkinManager == "esx_skin" then
                                    TriggerEvent('skinchanger:getSkin', function(skin)
                                        TriggerServerEvent('vms_clothestore:saveOutfit', menu2.eles[2].inputValue, skin)
                                    end)
                                elseif Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
                                    local playerPed = PlayerPedId()
                                    local pedModel = exports[Config.SkinManager]:getPedModel(playerPed)
                                    local pedComponents = exports[Config.SkinManager]:getPedComponents(playerPed)
                                    local pedProps = exports[Config.SkinManager]:getPedProps(playerPed)
                                    if Config.SkinManager == "fivem-appearance" then
                                        TriggerServerEvent('fivem-appearance:saveOutfit', menu2.eles[2].inputValue, pedModel, pedComponents, pedProps)
                                    elseif Config.SkinManager == "illenium-appearance" then
                                        TriggerServerEvent('illenium-appearance:server:saveOutfit', menu2.eles[2].inputValue, pedModel, pedComponents, pedProps)
                                    end
                                end
                                isMenuOpened = false
                                ESX.CloseContext()
                            end, function(menu2)
                                isMenuOpened = false
                            end)
                        elseif element.value == "no" then
                            isMenuOpened = false
                            ESX.CloseContext()
                        end
                    end, function(menu)
                        isMenuOpened = false
                    end)
                elseif Config.Menu == "esx_menu_default" then
                    local elements = {
                        {label = Config.Translate['menu:yes'].name, value = 'yes'},
                        {label = Config.Translate['menu:no'].name, value = 'no'},
                    }
                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop', {title = Config.Translate['menu:header'].name, elements = elements, align = Config.ESXMenuDefault_Align}, function(data, menu)
                        if data.current.value == 'yes' then
                            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'input_name', {title = Config.Translate['esx_menu_default:header']}, function(data2, menu2)
                                if string.len(data2.value) < 1 then
                                    return Config.Notification('name_is_too_short', 3500, 'error')
                                end
                                if data2.value then
                                    if Config.SkinManager == "esx_skin" then
                                        TriggerEvent('skinchanger:getSkin', function(skin)
                                            TriggerServerEvent('vms_clothestore:saveOutfit', data2.value, skin)
                                        end)
                                    elseif Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
                                        local playerPed = PlayerPedId()
                                        local pedModel = exports[Config.SkinManager]:getPedModel(playerPed)
                                        local pedComponents = exports[Config.SkinManager]:getPedComponents(playerPed)
                                        local pedProps = exports[Config.SkinManager]:getPedProps(playerPed)
                                        if Config.SkinManager == "fivem-appearance" then
                                            TriggerServerEvent('fivem-appearance:saveOutfit', data2.value, pedModel, pedComponents, pedProps)
                                        elseif Config.SkinManager == "illenium-appearance" then
                                            TriggerServerEvent('illenium-appearance:server:saveOutfit', data2.value, pedModel, pedComponents, pedProps)
                                        end
                                    end
                                    menu2.close()
                                    menu.close()
                                    isMenuOpened = false
                                end
                            end, function(data2, menu2)
                                menu2.close()
                            end)
                        elseif data.current.value == 'no' then
                            isMenuOpened = false
                            menu.close()
                        end
                    end, function(data, menu)
                        isMenuOpened = false
                        menu.close()
                    end)
                elseif Config.Menu == "ox_lib" then
                    local elements = {
                        {
                            icon = Config.Translate['menu:yes'].icon, 
                            title = Config.Translate['menu:yes'].name,
                            onSelect = function()
                                isMenuOpened = true
                                local input = lib.inputDialog('', {
                                    {type = 'textarea', label = Config.Translate['esx_context:title'].name, required = true}
                                })
                                if not input then return end
                                if input[1] then
                                    if Config.SkinManager == "esx_skin" then
                                        TriggerEvent('skinchanger:getSkin', function(skin)
                                            TriggerServerEvent('vms_clothestore:saveOutfit', input[1], skin)
                                        end)
                                        isMenuOpened = false
                                    elseif Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
                                        local playerPed = PlayerPedId()
                                        local pedModel = exports[Config.SkinManager]:getPedModel(playerPed)
                                        local pedComponents = exports[Config.SkinManager]:getPedComponents(playerPed)
                                        local pedProps = exports[Config.SkinManager]:getPedProps(playerPed)
                                        if Config.SkinManager == "fivem-appearance" then
                                            TriggerServerEvent('fivem-appearance:saveOutfit', input[1], pedModel, pedComponents, pedProps)
                                        elseif Config.SkinManager == "illenium-appearance" then
                                            TriggerServerEvent('illenium-appearance:server:saveOutfit', input[1], pedModel, pedComponents, pedProps)
                                        end
                                        isMenuOpened = false
                                    end
                                end
                            end,
                            onExit = function()
                                isMenuOpened = false
                            end
                        },
                        {
                            icon = Config.Translate['menu:no'].icon, 
                            title = Config.Translate['menu:no'].name,
                            onSelect = function()
                                isMenuOpened = false
                            end,
                            onExit = function()
                                isMenuOpened = false
                            end
                        },
                    }
                    lib.registerContext({
                        id = "clothestore-save",
                        title = Config.Translate['menu:header'].name,
                        options = elements,
                        onExit = function()
                            isMenuOpened = false
                        end
                    })
                    lib.showContext('clothestore-save')
                end
            end
        end)
    elseif Config.Core == "QB-Core" then
        if Config.SkinManager == "fivem-appearance" then
            TriggerEvent('fivem-appearance:client:saveOutfit')
            isMenuOpened = false
        elseif Config.SkinManager == 'qb-clothing' or Config.SkinManager == "illenium-appearance" then
            if Config.Menu == "qb-menu" then
                exports['qb-menu']:openMenu({
                    {
                        header = Config.Translate['menu:header'].name,
                        icon = Config.Translate['menu:header'].icon,
                        isMenuHeader = true,
                    },
                    {
                        header = "",
                        txt = Config.Translate['menu:yes'].name,
                        icon = Config.Translate['menu:yes'].icon,
                        params = {
                            isAction = true,
                            event = function()
                                local keyboard = exports['qb-input']:ShowInput({
                                    header = Config.Translate['qb-input:header'],
                                    submitText = Config.Translate['qb-input:submitText'],
                                    inputs = {{
                                        text = Config.Translate['qb-input:text'],
                                        name = "input",
                                        type = "text",
                                        isRequired = true
                                    }}
                                })
                                if keyboard ~= nil then
                                    if Config.SkinManager == 'qb-clothing' then
                                        local ped = PlayerPedId()
                                        local model = GetEntityModel(ped)
                                        TriggerServerEvent('qb-clothes:saveOutfit', keyboard.input, model, Character_QB)
                                    elseif Config.SkinManager == "illenium-appearance" then
                                        local playerPed = PlayerPedId()
                                        local pedModel = exports[Config.SkinManager]:getPedModel(playerPed)
                                        local pedComponents = exports[Config.SkinManager]:getPedComponents(playerPed)
                                        local pedProps = exports[Config.SkinManager]:getPedProps(playerPed)
                                        TriggerServerEvent('illenium-appearance:server:saveOutfit', keyboard.input, pedModel, pedComponents, pedProps)
                                    end
                                    isMenuOpened = false
                                end
                            end,
                        }
                    },
                    {
                        header = "",
                        txt = Config.Translate['menu:no'].name,
                        icon = Config.Translate['menu:no'].icon,
                        params = {
                            isAction = true,
                            event = function()
                                isMenuOpened = false
                            end
                        }
                    },
                })
            elseif Config.Menu == "ox_lib" then
                local elements = {
                    {
                        icon = Config.Translate['menu:yes'].icon, 
                        title = Config.Translate['menu:yes'].name,
                        onSelect = function()
                            isMenuOpened = true
                            local input = lib.inputDialog('', {
                                {type = 'textarea', label = Config.Translate['esx_context:title'].name, required = true}
                            })
                            if not input then return end
                            if input[1] then
                                if Config.SkinManager == 'qb-clothing' then
                                    local ped = PlayerPedId()
                                    local model = GetEntityModel(ped)
                                    TriggerServerEvent('qb-clothes:saveOutfit', input[1], model, Character_QB)
                                    isMenuOpened = false
                                elseif Config.SkinManager == "illenium-appearance" then
                                    local playerPed = PlayerPedId()
                                    local pedModel = exports[Config.SkinManager]:getPedModel(playerPed)
                                    local pedComponents = exports[Config.SkinManager]:getPedComponents(playerPed)
                                    local pedProps = exports[Config.SkinManager]:getPedProps(playerPed)
                                    TriggerServerEvent('illenium-appearance:server:saveOutfit', input[1], pedModel, pedComponents, pedProps)
                                    isMenuOpened = false
                                end
                            end
                        end,
                        onExit = function()
                            isMenuOpened = false
                        end
                    },
                    {
                        icon = Config.Translate['menu:no'].icon, 
                        title = Config.Translate['menu:no'].name,
                        onSelect = function()
                            isMenuOpened = false
                        end,
                        onExit = function()
                            isMenuOpened = false
                        end
                    },
                }
                lib.registerContext({
                    id = "clothestore-save",
                    title = Config.Translate['menu:header'].name,
                    options = elements,
                    onExit = function()
                        isMenuOpened = false
                    end
                })
                lib.showContext('clothestore-save')
            end
        end
    end
end

function OpenClothestore(store)
    if Config.Core == "ESX" then
        if Config.SkinManager == "esx_skin" or Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
            TriggerEvent('skinchanger:getSkin', function(skin)
                if Config.SkinManager == "esx_skin" then
                    gender = skin.sex == 0 and 'male' or 'female'
                else
                    gender = skin.model == 'mp_m_freemode_01' and 'male' or 'female'
                end
                lastSkin = skin
            end)
            while not gender do
                Citizen.Wait(20)
            end
        end
        if Config.SkinManager == "esx_skin" then
            refreshValues()
        end
    end
    local data = {}
    local hasSkin = false
    local components, maxVals = getMaxValues()
    for i=1, #components, 1 do
        data[components[i].name] = {
            value = components[i].value,
            min = components[i].min,
        }
        for k,v in pairs(maxVals) do
            if k == components[i].name then
                data[k].max = v
                break
            end
        end
    end

    if Config.SkinManager == "esx_skin" then
        TriggerEvent('skinchanger:getData', function(comp, max)
            for k, v in pairs(comp) do
                if data[v.name] then
                    data[v.name].value = tonumber(v.value)
                end
            end
            hasSkin = true
        end)
    elseif Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
        Character_AP = exports[Config.SkinManager]:getPedAppearance(PlayerPedId())
        if Config.Core == "QB-Core" then
            gender = QBCore.Functions.GetPlayerData().charinfo.gender == 0 and 'male' or 'female'
        end
        hasSkin = true
    elseif Config.SkinManager == "qb-clothing" then
        QBCore.Functions.TriggerCallback('vms_clothestore:getCurrentSkin', function(skin)
            Character_QB = json.decode(skin)
            gender = QBCore.Functions.GetPlayerData().charinfo.gender == 0 and 'male' or 'female'
            lastSkin = Character_QB
            hasSkin = true
        end)
    end

    while not hasSkin do
        Citizen.Wait(125)
    end

    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end

    local myPed = PlayerPedId()
    local myCoords = GetEntityCoords(myPed)
    local myHeading = GetEntityHeading(myPed)
    cameraOffset = GetOffsetFromEntityInWorldCoords(myPed, 0.0, 0.0 + Config.DefaultCamDistance, 0.0)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)

    SetCamCoord(cam, cameraOffset.x, cameraOffset.y, cameraOffset.z+0.65)
    PointCamAtCoord(cam, myCoords.x, myCoords.y, myCoords.z+0.65)
    SetCamFov(cam, 30.0)
    if Config.BlurBehindPlayer then
        SetTimecycleModifier('MP_corona_heist_DOF')
        SetTimecycleModifierStrength(1.0)
    end
    RequestAnimDict(Config.ClothingPedAnimation[1])
    while not HasAnimDictLoaded(Config.ClothingPedAnimation[1]) do
        Wait(1)
    end
    TaskPlayAnim(myPed, Config.ClothingPedAnimation[1], Config.ClothingPedAnimation[2], 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    Config.Hud:Disable()
    if Config.UseQSInventory then
        exports[Config.QSInventoryName]:setInClothing(true)
    end
    local BlockedClothes = store.blockedClothes and store.blockedClothes[gender] or {}
    SendNUIMessage({
        action = 'openClothestore',
        disabledValues = BlockedClothes,
        handsUpKey = Config.HandsUpKey,
        enableHandsUpButton = Config.EnableHandsUpButtonUI,
        categories = store.categories,
        price = store.price,
        data = data,
        currentRotate = myHeading,
        currentDistance = 30,
    })
    SetNuiFocus(true, true)
end

function DeleteSkinCam()
    FreezeEntityPosition(PlayerPedId(), false)
    ClearPedTasks(PlayerPedId())
    ClearPedTasksImmediately(PlayerPedId())
    SetCamActive(cam, false)
    cam = nil
    RenderScriptCams(false, true, 500, true, true)
    if Config.BlurBehindPlayer then
        ClearTimecycleModifier()
    end
    SetNuiFocus(false, false)
    SendNUIMessage({action = 'close'})
    ClearPedTasks(PlayerPedId())
    isMenuOpened = false
    Config.Hud:Enable()
    if Config.UseQSInventory then
        exports[Config.QSInventoryName]:setInClothing(false)
    end
end

Citizen.CreateThread(function()
	for k, v in pairs(Config.Stores) do
        if v and v.blip then
		    local blip = AddBlipForCoord(v.coords)
		    SetBlipSprite(blip, v.blip.sprite)
		    SetBlipDisplay(blip, v.blip.display)
		    SetBlipScale(blip, v.blip.scale)
		    SetBlipColour(blip, v.blip.color)
		    SetBlipAsShortRange(blip, true)
		    BeginTextCommandSetBlipName("STRING")
		    AddTextComponentString(v.blip.name)
		    EndTextCommandSetBlipName(blip)
        end
	end
end)

RegisterNetEvent('vms_clothestore:openMenu', function(data)
    local cData = data.data

    if Config.ChangeClothes then
        SelectCategory(cData)
    else
        OpenClothestore(cData)
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.Stores) do
        local modelHash = GetHashKey("a_m_y_indian_01")
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Wait(10)
        end
        local ped = CreatePed(4, modelHash, v.coords.x, v.coords.y, v.coords.z, v.coords.heading, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityAsMissionEntity(ped, true, true)
        SetEntityInvincible(ped, true)

        exports['ox_target']:addLocalEntity(ped, {
            {
                name = 'vms_clothestore:openMenu',
                event = 'vms_clothestore:openMenu',
                icon = 'fa-solid fa-shirt',
                label = "Open store",
                data = v,
                canInteract = function(entity)
                    return #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(entity)) <= 3.0
                end
            }
        })
    end
end)

RegisterNetEvent('vms_clothestore:open')
AddEventHandler('vms_clothestore:open', function(storeId)
    local store = Config.Stores[storeId]
    OpenClothestore(store)
end)

RegisterNetEvent('vms_clothestore:notification')
AddEventHandler('vms_clothestore:notification', function(message, time, type)
    Config.Notification(message, time, type)
end)

exports('OpenManage', OpenManage)
exports('OpenWardrobe', OpenWardrobe)

-------------------------------------------------------------------
-- FIX (requested): lets another resource (esx_society's boss "manage
-- uniform" menu) open this same clothing-store UI in an unrestricted mode
-- instead of esx_skin's bare editor - see Config.ManagementStore in
-- config.lua for what "unrestricted" means here (every category, no
-- blockedClothes, free). IsMenuOpened lets the caller poll for when the
-- player has finished/cancelled, the exact same way esx_society already
-- polled ESX.UI.Menu.IsOpen(...) for the old esx_skin editor.
-------------------------------------------------------------------
exports('OpenManagementStore', function()
    -- isMenuOpened is normally set by SelectCategory right after it calls
    -- OpenClothestore - bypassing that menu here, so set it ourselves (every
    -- closing path - buyClothes, cancelClothes, etc. - already sets it back
    -- to false on its own).
    isMenuOpened = true
    OpenClothestore(Config.ManagementStore)
end)
exports('IsMenuOpened', function()
    return isMenuOpened
end)