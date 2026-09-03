isInInventory = false

local controlDisabled = {1, 2, 3, 4, 5, 6, 18, 24, 25, 37, 69, 70, 111, 117, 118, 182, 199, 200, 257}

local alwaysDisabled = {157, 158, 159, 160, 161, 162, 163, 164, 165}


clonedPed = false

actualFilter = "all"

VaultCache = {}

fastItems = {}

searchFilters = {
    ["inventory"] = "",
    ["vault"] = ""
}

ClothesInfo = {
    ["helmet"] = 0,
    ["tshirt"] = 0,
    ["bproof"] = 0,
    ["bags"] = 0,
    ["pants"] = 0,
    ["shoes"] = 0,
    ["mask"] = 0,
    ["glasses"] = 0,
    ["ears"] = -1,
    ["chain"] = -1,
}

local Accounts = {
	black_money = "Argent Sale",
	money = "Liquide",
}


InventoryCache = {}

function OpenInventory(sort)
    SetNuiFocus(true, true)
    ESX.ShowNotification("Vous avez ouvert votre inventaire.")
    isInInventory = true
    RefreshInventoryContent(sort, searchFilters["inventory"], true)
    
    Citizen.CreateThread(function()
        while isInInventory do
            Citizen.Wait(5)
            SetMouseCursorVisibleInMenus(false)
        end
    end)
end

function CloseInventory()
    SetNuiFocus(false, false)
    isInInventory = false
    ESX.ShowNotification("Vous avez fermé votre inventaire.")
    DestroyPedInMenu()
    SendNUIMessage({
        action = "close"
    })
    VaultCache = {}
end

local clothesDataListByKey = {}

function GetAllClothesFromPack(pack)
    local clothes = {}
    for k,v in pairs(pack) do
        if string.find(k, "_1") then
            if v ~= 0 then
                local namewithout = k:gsub("%_1", "")
                clothes[namewithout] = {}
                clothes[namewithout][k] = v
                if pack[namewithout .. "_2"] then
                    clothes[namewithout][namewithout .. "_2"] = pack[namewithout .. "_2"]
                end
                if pack[namewithout .. "_3"] then
                    clothes[namewithout][namewithout .. "_3"] = pack[namewithout .. "_3"]
                end
            end
        elseif not string.find(k, "_") then
            clothes[k] = {}
            clothes[k][k] = v
        end
    end
    return clothes
end

function RefreshInventoryContent(sort, search, loadPed)
    if isInInventory then
        local playerPed = PlayerPedId()
        local itemsCount = 0
        local rowsToSend = {}
        local rowsCount = 0
        local rowsToAdd = 0
        local fastToSend = {}
        local fastAdd = 5
        if not search then
            search = ""
        end
        local ValidItemsList = {}
        for k,v in pairs(ESX.PlayerData.inventory) do
            if v.count > 0 then
                itemsCount = itemsCount + v.count
                ValidItemsList[string.lower(v.name)] = true
                if (sort == "all" or sort == "items") and string.find(string.lower(v.label), string.lower(search)) then
                    table.insert(rowsToSend, {label = v.label, name = v.name, image = "./assets/img/items/" .. v.name .. ".png", count = v.count, itemType = 'item', canRemove = v.canRemove, usable = v.usable})
                    rowsCount = rowsCount + 1
                end
            end
        end
        if sort == "all" or sort == "weapons" then
            for k,v in pairs(ESX.PlayerData.loadout) do
                local weaponHash = GetHashKey(v.name)
                local label = ESX.GetWeaponLabel(v.name) or "Unknown Weapon"
                if HasPedGotWeapon(playerPed, weaponHash, false) then
                    ValidItemsList[string.lower(v.name)] = true
                    if string.find(string.lower(label), string.lower(search)) then
                        local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)
                        if ammo then
                            ammo = ammo
                        else
                            ammo = 0
                        end
                        table.insert(rowsToSend, {label = label, name = v.name, image = "./assets/img/weapons/" .. string.upper(v.name) .. ".png", count = ammo, itemType = 'weapon', canRemove = (v.permanent and "0") or "1", usable = "false"})
                        rowsCount = rowsCount + 1
                    end
                end
            end
        end
        if sort == "all" or sort == "clothes" then
            for i=1, #Dressing, 1 do
                local dressingData = Dressing[i]
                
                if dressingData.selected and string.find(dressingData.label, search) then
                    clothesDataListByKey[tostring(i) .. '-' .. "pack"] = {label = dressingData.label, type = "pack", data = dressingData.skin}
                    ValidItemsList[tostring(i) .. '-' .. "pack"] = true
                    table.insert(rowsToSend, {label = dressingData.label, name = tostring(i) .. '-' .. "pack", image = "./assets/img/items/pack.png", count = 1, itemType = 'clothe', canRemove = "0", usable = "false"})
                    rowsCount = rowsCount + 1
                    local clothesList = GetAllClothesFromPack(dressingData.skin)
                    for k, v in pairs(clothesList) do
                        if k ~= "arms" then
                            clothesDataListByKey[tostring(i) .. '-' .. k] = {label = dressingData.label, type = k, data = v}
                            ValidItemsList[tostring(i) .. '-' .. k] = true
                            table.insert(rowsToSend, {label = dressingData.label, name = tostring(i) .. '-' .. k, image = "./assets/img/items/" .. k .. ".png", count = 1, itemType = 'clothe', canRemove = "0", usable = "false"})
                            rowsCount = rowsCount + 1
                        end
                    end
                end
            end
        end
        if sort == "all" or sort == "accounts" then
            for k,v in pairs(ESX.PlayerData.accounts) do
                if Accounts[string.lower(v.name)] then
                    ValidItemsList[string.lower(v.name)] = true
                    local label = Accounts[string.lower(v.name)]
                    if string.find(string.lower(label), string.lower(search)) then
                        table.insert(rowsToSend, {label = label, name = v.name, image = "./assets/img/accounts/" .. string.lower(v.name) .. ".png", count = v.money, itemType = 'account', canRemove = "1", usable = "false"})
                        rowsCount = rowsCount + 1
                    end
                end
            end
        end
        for k,v in pairs(fastItems) do
            if v then
                if ValidItemsList[string.lower(tostring(v.name))] then
                    fastAdd = fastAdd - 1
                    table.insert(fastToSend, v)
                else
                    fastItems[k] = nil
                end
            end
        end
        table.sort(fastToSend, function (k1, k2) return k1.place < k2.place end)
        SendNUIMessage({
            action = "populateInventory",
            maxCapacity = ESX.PlayerData.maxWeight,
            rows = rowsToSend,
            rowsCount = rowsCount,
            itemsCount = itemsCount,
            selectedCategory = sort,
            fastItems = fastToSend or {},
            fastAdd = fastAdd,
        })
        if loadPed then
            CreatePedInMenu(true)
        end
    end
end

AddEventHandler("coffre:loadCoffre", function(vault)
    actualFilter = "all"
    RefreshVaultContent(actualFilter, vault, false, searchFilters["vault"])
end)

RegisterCommand('VaultExemple', function()
    TriggerEvent('coffre:loadCoffre', {type = 1})
end)

function RefreshVaultContent(sort, vault, usecache, searchfilter)
    local itemsCount = 0
    local rows = {}
    local rowsCount = 0
    local rowsToAdd = 0
    local VaultTitle = "Coffre"
    local inInv = isInInventory
    local vaulttype = (usecache and VaultCache.vault.type) or vault.type
    local search = searchfilter
    local eventprefix = "society"
    if not search then
        search = ""
    end
    if vaulttype == 1 or vaulttype == 2 or vaulttype == 3 then
        if vaulttype == 1 then
            VaultTitle = "Coffre Entreprise"
        elseif vaulttype == 2 then
            VaultTitle = "Coffre Organisation"
        elseif vaulttype == 3 then
            VaultTitle = "Coffre d'habitation"
            eventprefix = "housing"
        end
        if usecache then
            for k, v in pairs(VaultCache.rows or {}) do 
                if v.count > 0 and string.find(string.lower(v.label), string.lower(search)) then
                    if sort == "all" or (v.itemType .. "s" == sort) then
                        table.insert(rows, v)
                        rowsCount = rowsCount + 1
                    end
                end
            end
            SendNUIMessage({
                action = "populateVault",
                maxCapacity = VaultCache.maxCapacity,
                rows = rows or {},
                rowsCount = rowsCount,
                itemsCount = VaultCache.itemsCount,
                selectedCategory = sort,
                vault = VaultCache.vault,
                title = VaultTitle
            })
        else
            local maxWeight = 0
            local weight = 0
            ESX.TriggerServerCallback(eventprefix .. ":getStockItems", function(data)
                for k, item in pairs(data.items) do
                    local itemtype = 'item'
                    if item.count > 0 then
                        itemsCount = itemsCount + item.count
                        table.insert(rows, {label = (item.label or "Unknown"), name = item.name, image = "./assets/img/items/" .. item.name .. ".png", count = item.count, itemType = 'item', canRemove = "0"})
                        rowsCount = rowsCount + 1
                    end
                end
                maxWeight = data.maxWeight
                weight = data.weight
                if data.money then
                    local item = data.money
                    table.insert(rows, {label = (item.label or "Unknown"), name = item.name, image = "./assets/img/accounts/" .. item.name .. ".png", count = item.count, itemType = 'account', canRemove = "0"})
                    rowsCount = rowsCount + 1
                end
                ESX.TriggerServerCallback(eventprefix .. ":getArmoryWeapons", function(weapons)
                    for i=1, #weapons, 1 do
                        local v = weapons[i]
                        local label = ESX.GetWeaponLabel(v.name) or "Unknown Weapon"
                        table.insert(rows, {label = label, name = v.name, image = "./assets/img/weapons/" .. string.upper(v.name) .. ".png", count = v.ammo, itemType = 'weapon', canRemove = "0"})
                        rowsCount = rowsCount + 1
                    end
                    VaultCache = {
                        maxCapacity = maxWeight,
                        rows = rows,
                        itemsCount = weight,
                        rowsCount = rowsCount,
                        selectedCategory = sort,
                        vault = vault,
                        title = VaultTitle,
                    }
                    rowsCount = 0
                    local rowsToSend = {}
                    for k, v in pairs(VaultCache.rows or {}) do 
                        if v.count >= 0 and string.find(string.lower(v.label), string.lower(search)) then
                            if sort == "all" or (v.itemType .. "s" == sort) then
                                table.insert(rowsToSend, v)
                                rowsCount = rowsCount + 1
                            end
                        end
                    end
                    SendNUIMessage({
                        action = "populateVault",
                        maxCapacity = VaultCache.maxCapacity,
                        rows = rowsToSend,
                        rowsCount = rowsCount,
                        itemsCount = VaultCache.itemsCount,
                        selectedCategory = sort,
                        vault = VaultCache.vault,
                        title = VaultTitle
                    })
                    if not inInv then
                        OpenInventory(actualFilter)
                    end
                end, vaulttype)
            end, vaulttype)
        end
    end
end

local cooldowns = {}

Citizen.CreateThread(function()
    local slot = 1
    while slot <= 5 do
        cooldowns[slot] = 0
        slot = slot + 1
    end
end)

Citizen.CreateThread(function()
    local slot = 1
    while slot <= 5 do
        Wait(0)
        local _slot = slot
        RegisterCommand('+fastitem' .. _slot, function()
            local currentTime = GetGameTimer()
            local lastUsedTime = cooldowns[_slot]
            if currentTime - lastUsedTime >= 5000 then
                UseFastSlot(_slot)
                cooldowns[_slot] = currentTime
            end
        end)
        RegisterKeyMapping('+fastitem' .. _slot, "Utiliser l'objet n°" .. _slot .. " de la sélection rapide", "keyboard", tostring(_slot))
        slot = slot + 1
    end
end)


RegisterNetEvent('useItem')
AddEventHandler("useItem", function(name)
    TriggerServerEvent("esx:useItem", name)
end)

function UseFastSlot(slot)
    local SlotData = fastItems[tostring(slot)]
    if SlotData and not isInInventory then
        if SlotData.type == "item" then
            TriggerEvent("useItem", SlotData.name)
        elseif SlotData.type == "weapon" then
            local playerPed = PlayerPedId()
            local weapon = SlotData.name
            if GetSelectedPedWeapon(playerPed) == GetHashKey(weapon) then
                SetCurrentPedWeapon(playerPed, "WEAPON_UNARMED",true)
            else
                SetCurrentPedWeapon(playerPed, weapon, true)
            end
        elseif SlotData.type == "clothe" then
            local clotheData = clothesDataListByKey[SlotData.name]
            if clotheData then
                TriggerEvent("skinchanger:getSkin", function(skin)
                    TriggerEvent("skinchanger:loadClothes", skin, clotheData.data)
                end)
            end
        end
    end
end

RegisterNetEvent('esx:updateSkin')
AddEventHandler("esx:updateSkin", function(newskin)
	if newskin then
	    skin = newskin
	end
end)

function setUniform(value)
    local ped = PlayerPedId()
      TriggerEvent("skinchanger:getSkin", function(skina)
      if value == "total" then
        TriggerEvent("skinchanger:loadSkin", ESX.PlayerData.skin)
      elseif value == 'tshirt' then
          ClearPedTasks(ped)
  
          if skin.torso_1 ~= skina.torso_1 then
              TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = skin.torso_1, ['torso_2'] = skin.torso_2, ['tshirt_1'] = skin.tshirt_1, ['tshirt_2'] = skin.tshirt_2, ['arms'] = skin.arms})
          else
              TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})
          end
      elseif value == 'pants' then
          if skin.pants_1 ~= skina.pants_1 then
              TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = skin.pants_1, ['pants_2'] = skin.pants_2})
          else
              if skin.sex == 0 then
                  TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 21, ['pants_2'] = 0})
              else
                  TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 15, ['pants_2'] = 0})
              end
          end
      elseif value == 'shoes' then
          if skin.shoes_1 ~= skina.shoes_1 then
              TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = skin.shoes_1, ['shoes_2'] = skin.shoes_2})
          else
              if skin.sex == 0 then
                  TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 34, ['shoes_2'] = 0})
              else
                  TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 47, ['shoes_2'] = 0})
              end
          end
      elseif value == "mask" then
        ClearPedTasks(ped)
        if skin.mask_1 ~= skina.mask_1 then
          TriggerEvent("skinchanger:loadClothes", skina, {["mask_1"] = skin.mask_1, ["mask_2"] = skin.mask_2})
        else
          TriggerEvent("skinchanger:loadClothes", skina, {["mask_1"] = 0})
        end
      elseif value == "helmet" then
        ClearPedTasks(ped)
        if skin.helmet_1 ~= skina.helmet_1 then
          TriggerEvent("skinchanger:loadClothes", skina, {["helmet_1"] = skin.helmet_1, ["helmet_2"] = skin.helmet_2})
        else
          TriggerEvent("skinchanger:loadClothes", skina, {["helmet_1"] = -1})
        end
    elseif ClothesInfo[value] then
        ClearPedTasks(ped)
        if skin[value .. "_1"] ~= skina[value .. "_1"] then
          TriggerEvent("skinchanger:loadClothes", skina, {[value .. "_1"] = skin[value .. "_1"], [value .. "_2"] = skin[value .. "_2"]})
        else
          TriggerEvent("skinchanger:loadClothes", skina, {[value .. "_1"] = ClothesInfo[value]})
        end
      end
      if ClothesInfo[value] then
        RefreshPedScreen()
      end
    end)
end

RegisterNUICallback('setClothe', function(data, cb)
    local _data = data
    local clotheData = clothesDataListByKey[_data.item]
    if clotheData then
        TriggerEvent("skinchanger:getSkin", function(skin)
            TriggerEvent("skinchanger:loadClothes", skin, clotheData.data)
            Citizen.Wait(500)
            RefreshPedScreen()
        end)
    end
end)

RegisterNUICallback('ManageClotheSlot', function(data, cb)
    setUniform(data.part)
end)

RegisterNUICallback('refresh', function(data, cb)
    CloseInventory()
end)

RegisterNUICallback('close', function(data, cb)
    CloseInventory()
end)

RegisterNUICallback('use', function(data, cb)
    TriggerServerEvent("esx:useItem", data.item)
    CloseInventory()
end)

RegisterNUICallback('search', function(data, cb)
    searchFilters[data.type] = data.value
    if data.type == "inventory" then
        RefreshInventoryContent(actualFilter, searchFilters[data.type])
    elseif VaultCache and VaultCache.vault then
        RefreshVaultContent(actualFilter, VaultCache.vault.type, true, searchFilters[data.type])
    end
end)

RegisterNUICallback('give', function(data, cb)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer == -1 or closestDistance >= 2.0 then ESX.ShowNotification("Personne à proximité.") return end
    if data.type == "weapon" then
        TriggerServerEvent("esx:giveInventoryItem", GetPlayerServerId(closestPlayer), "item_weapon", data.item, nil)
    elseif data.type == "item" then
        TriggerServerEvent("esx:giveInventoryItem", GetPlayerServerId(closestPlayer), "item_standard", data.item, tonumber(data.count))
    elseif data.type == "account" then
        TriggerServerEvent("esx:giveInventoryItem", GetPlayerServerId(closestPlayer), "item_account", data.item, tonumber(data.count))
    end
    CloseInventory()
end)


RegisterNUICallback('drop', function(data, cb)
    if data.type == "weapon" then
        TriggerServerEvent("esx:removeInventoryItem", "item_weapon", data.item, tonumber(data.count))
    elseif data.type == "item" then
        TriggerServerEvent("esx:removeInventoryItem", "item_standard", data.item, tonumber(data.count))
    elseif data.type == "account" then
        TriggerServerEvent("esx:removeInventoryItem", "item_account", data.item, tonumber(data.count))
    else 
        ESX.ShowNotification("Impossible de jeter cet objet.")
    end

    CloseInventory()
end)

RegisterNUICallback('setFast', function(data, cb)
    fastItems[tostring(data.place)] = {name = data.item, label = data.label, type = data.type, place = data.place, icon = ((data.type == "clothe" and clothesDataListByKey[data.item]) and ("./assets/img/items/" .. clothesDataListByKey[data.item].type) .. ".png")}
    RefreshInventoryContent(actualFilter, searchFilters["inventory"])
end)

RegisterNUICallback('removeFast', function(data, cb)
    fastItems[tostring(data.place)] = nil
    RefreshInventoryContent(actualFilter, searchFilters["inventory"])
end)
RegisterNUICallback('getFromVault', function(data, cb)
    local eventprefix = "society"
    if tonumber(data.vault) == 3 then
        eventprefix = "housing"
    end
    if data.type == "weapon" then
        if eventprefix == "housing" then
            ESX.TriggerServerCallback(eventprefix .. ":removeArmoryWeapon", function()
                CloseInventory()
            end, data.item, 1, tonumber(data.vault))
        else
            ESX.TriggerServerCallback(eventprefix .. ":removeArmoryWeapon", function()
                CloseInventory()
            end, data.item, 0, tonumber(data.vault))
        end
    elseif data.type == "item" or data.type == "account" then
        TriggerServerEvent(eventprefix .. ":getStockItem", data.item, tonumber(data.count), tonumber(data.vault), data.type)
        CloseInventory()
    end
end)

RegisterNUICallback('putInVault', function(data, cb)
    local eventprefix = "society"
    if tonumber(data.vault) == 3 then
        eventprefix = "housing"
    end
    if data.type == "weapon" then
        if eventprefix == "housing" then
            ESX.TriggerServerCallback(eventprefix .. ":addArmoryWeapon", function()
                CloseInventory()
            end, data.item, 1, tonumber(data.vault))
        else
            ESX.TriggerServerCallback(eventprefix .. ":addArmoryWeapon", function()
                CloseInventory()
            end, data.item, tonumber(data.vault))
        end
    elseif data.type == "item" or data.type == "account" then
        TriggerServerEvent(eventprefix .. ":putStockItems", data.item, tonumber(data.count), tonumber(data.vault), data.type)
        CloseInventory()
    end
end)

RegisterNUICallback('load', function(data, cb)
    actualFilter = data.filter
    RefreshInventoryContent(actualFilter, searchFilters["inventory"])
    if VaultCache.vault then
        RefreshVaultContent(data.filter, {type = VaultCache.vault.type}, true, searchFilters["vault"])
    end
end)

RegisterCommand("+openinv", function()
    OpenInventory(actualFilter)
end)

RegisterKeyMapping('+openinv', "Ouvrir l'inventaire", "keyboard", "i")


Citizen.CreateThread(function()
    while true do
        Wait(5)
        if IsControlPressed(0, 37) then
            for _,v in pairs(alwaysDisabled) do
                DisableControlAction(0, v, false)
                BlockWeaponWheelThisFrame()
                BlockWeaponWheelThisFrame()
            HideHudComponentThisFrame(19)
            HideHudComponentThisFrame(20)
            HideHudComponentThisFrame(17)
            DisableControlAction(0, 37, true)
            end
        else
            for _,v in pairs(alwaysDisabled) do
                DisableControlAction(0, v, false)
                BlockWeaponWheelThisFrame()
                BlockWeaponWheelThisFrame()
            HideHudComponentThisFrame(19)
            HideHudComponentThisFrame(20)
            HideHudComponentThisFrame(17)
            DisableControlAction(0, 37, true)
            end
        end
        if isInInventory then
            for _,v in pairs(controlDisabled) do
                DisableControlAction(0, v, true)
                BlockWeaponWheelThisFrame()
                BlockWeaponWheelThisFrame()
            HideHudComponentThisFrame(19)
            HideHudComponentThisFrame(20)
            HideHudComponentThisFrame(17)
            DisableControlAction(0, 37, true)
            end
        end
    end
end)


function CreatePedInMenu(firstTime)
    local menuType = "FE_MENU_VERSION_EMPTY_NO_BACKGROUND"
    ActivateFrontendMenu(GetHashKey(menuType), false, -1)
    Wait(100)
    clonedPed = ClonePed(PlayerPedId(), 0, false, false)
    local x, y, z = table.unpack(GetEntityCoords(clonedPed))
    SetEntityCoords(clonedPed, x, y, z - 10)
    FreezeEntityPosition(clonedPed, true)
    N_0x4668d80430d6c299(clonedPed)
    GivePedToPauseMenu(clonedPed, 1)
    SetPauseMenuPedLighting(true)
    SetPauseMenuPedSleepState(true)
    RequestScaleformMovie("PAUSE_MP_MENU_PLAYER_MODEL")
    ReplaceHudColourWithRgba(117, 0, 0, 0, 0)
    if firstTime then
        SetPauseMenuPedSleepState(false)
        Wait(1000)
        SetPauseMenuPedSleepState(true)
    else
        SetPauseMenuPedSleepState(true)
    end
end

function DestroyPedInMenu()
    if DoesEntityExist(clonedPed) then
        DeleteEntity(clonedPed)
    end
    SetFrontendActive(false)
    ReplaceHudColourWithRgba(117, 0, 0, 0, 186)
end

function RefreshPedScreen()
    if DoesEntityExist(clonedPed) then
        DestroyPedInMenu()
        Wait(500)
        if isInInventory then
            CreatePedInMenu(false)
        end
    end
end

RegisterCommand('invdebug', function()
    DestroyPedInMenu()
end)