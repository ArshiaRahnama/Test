-- This Script Dump By FleeX Team  , discord.gg/2D79ZtUjxB

-- ESX is created in client/00_compat.lua (essentialmode has no getObject export)
local items = nil
settings = {}
local reservedSlot, reservedSlotByName = {}, {}
local weaponSlot, weaponSlot2 = {}, {}
local slotLoaded = false
local antiSpam = false
local mainInventoryData = {}
local otherInventoryData = {}
local secondTab = 'items'
local secondOpenWeapon = nil
local disableWeaponSwitch = false
local cachedItem, cachedType, cachedImage = {}, {}, {}
local previewPed = nil
local listWeaponToAdd = {}
local oldWeaponSlot = {}
local autoOpenBag = true
local playingAnim = false
isOpen = false
local tradeMode = false
local tradePartner = nil
local pendingTrade = nil
Citizen.CreateThread(function()
    -- if not GetResourceKvpString('inventory:setting') then
    --     settings = {
    --         blur = true,
    --     }
    --     SetResourceKvp('inventory:setting', json.encode(settings))
    -- end
    -- settings = json.decode(GetResourceKvpString('inventory:setting') or '{}')
    while ESX == nil do
        Wait(5000)
    end
    while items == nil do
        Wait(1000)
        items = ESX.getItems()
    end
    ESX.TriggerServerCallback('inventory:getSlots', function(result)
        result = result or { maxWeight = 24, normal = {}, maket = {} }
        mainInventoryData.maxWeight = result.maxWeight
        for k, v in pairs(result.normal or {}) do
            weaponSlot[tonumber(k)] = v
        end
        ApplyMaketSlots(result.maket)
        local tedadGunHa = {}
        local inSerialHaHast = {}
        for k, v in pairs(ESX.GetPlayerData().loadout) do
            inSerialHaHast[v.metadata.serial] = true
            if not tedadGunHa[v.name] then
                tedadGunHa[v.name] = 1
            else
                tedadGunHa[v.name] = tedadGunHa[v.name] + 1
            end
        end
        weaponSlot2 = {}
        for k, v in pairs(weaponSlot) do
            weaponSlot2[v.serial] = k
        end
        for k, v in ipairs(weaponSlot) do
            if not inSerialHaHast[v.serial] then
                removeWeaponSlot(v.serial)
            end
        end
        local tedadGunTuReservedSlot = {}
        for k, v in pairs(reservedSlot) do
            if v.name and (v.name:upper():find('WEAPON_') or v.name:upper():find('GADGET_')) then
                if not tedadGunTuReservedSlot[v.name] then
                    tedadGunTuReservedSlot[v.name] = 1
                else
                    tedadGunTuReservedSlot[v.name] =  tedadGunTuReservedSlot[v.name] + 1
                end
            end
        end

        for k, v in pairs(tedadGunTuReservedSlot) do
            if tedadGunHa[k] then
                if tedadGunHa[k] < v then
                    local tavafot = v - tedadGunHa[k]
                    for k2, v2 in pairs(reservedSlot) do
                        if v2 and v2.name and v2.name == k and tavafot > 0 then
                            reservedSlot[k2] = nil
                            tavafot = tavafot - 1
                        end
                    end
                end
            else
                for k2, v2 in pairs(reservedSlot) do
                    if v2 and v2.name and v2.name == k then
                        reservedSlot[k2] = nil
                    end
                end
            end
        end
        ESX.TriggerServerEvent('inventory:setReservedSlot', reservedSlot)
        slotLoaded = true
        SendNUIMessage({
            action = 'setPlayerStaticData',
            maxweight = mainInventoryData.maxWeight,
            name = ESX.GetPlayerData().name2 .. ' - ' .. ESX.src
        })
    end)
    Wait(5000)
    for k, v in pairs(ESX.GetPlayerData().inventory) do
        if v.name:find('kif_') and v.count > 0 then
            setBag()
            break
        end
    end
    bagId = nil
    for k, v in pairs(ESX.GetPlayerData().inventory) do
        if v.name:find('kif_') and v.count > 0 then
            doesHave = true
            local id = v.name:gsub('kif_', '')
            bagId = tonumber(id)
            break
        end
    end
    ESX.SetPlayerState('bag', bagId)
end)

function supapWeaponSlot()
    local tedadGunHa = {}
    local inSerialHaHast = {}
    for k, v in pairs(ESX.GetPlayerData().loadout) do
        inSerialHaHast[v.metadata.serial] = true
        if not tedadGunHa[v.name] then
            tedadGunHa[v.name] = 1
        else
            tedadGunHa[v.name] = tedadGunHa[v.name] + 1
        end
    end
    for k, v in ipairs(weaponSlot) do
        if not inSerialHaHast[v.serial] then
            removeWeaponSlot(v.serial)
        end
    end
    local tedadGunTuReservedSlot = {}
    for k, v in pairs(reservedSlot) do
        if v.name and (v.name:upper():find('WEAPON_') or v.name:upper():find('GADGET_')) then
            if not tedadGunTuReservedSlot[v.name] then
                tedadGunTuReservedSlot[v.name] = 1
            else
                tedadGunTuReservedSlot[v.name] =  tedadGunTuReservedSlot[v.name] + 1
            end
        end
    end

    for k, v in pairs(tedadGunTuReservedSlot) do
        if tedadGunHa[k] then
            if tedadGunHa[k] < v then
                local tavafot = v - tedadGunHa[k]
                for k2, v2 in pairs(reservedSlot) do
                    if v2 and v2.name and v2.name == k and tavafot > 0 then
                        reservedSlot[k2] = nil
                        tavafot = tavafot - 1
                    end
                end
            end
        else
            for k2, v2 in pairs(reservedSlot) do
                if v2 and v2.name and v2.name == k then
                    reservedSlot[k2] = nil
                end
            end
        end
    end
    ESX.TriggerServerEvent('inventory:setReservedSlot', reservedSlot)
end

function updateWeaponSlot2()
    weaponSlot2 = {}
    for k, v in pairs(weaponSlot) do
        weaponSlot2[v.serial] = k
    end
end

exports('getWeaponSlot', function()
    while not slotLoaded do
        Wait(100)
    end
    local mergedSlot, mergedSlot2 = {}, {}
    for k, v in pairs(weaponSlot) do
        mergedSlot[k] = v
        if v.serial then mergedSlot2[v.serial] = k end
    end
    for k, v in pairs(maketSlot or {}) do
        if type(v) == 'table' then
            local mk = (tonumber(k) or 0) + 100
            mergedSlot[mk] = v
            if v.serial then mergedSlot2[v.serial] = mk end
        end
    end
    return mergedSlot, mergedSlot2
end)

RegisterNetEvent('core:removeWeapon', function(name, serial)
    if weaponSlot2[serial] then
        removeWeaponSlot(serial)
    end
    local key
    local count = 0
    for k, v in pairs(oldWeaponSlot) do
        if v.serial == serial then
            if reservedSlot[k] then
                key = k
            end
        end
        if v.name == name then
            count = count + 1
        end
    end
    if key and count > 1 then
        reservedSlot[key] = nil
        ESX.TriggerServerEvent('inventory:setReservedSlot', reservedSlot)
    end
end)

RegisterNetEvent('core:addWeapon', function(name, serial)
    if listWeaponToAdd[serial] then
        local data = listWeaponToAdd[serial]
        ESX.TriggerServerEvent('inventory:setSlot', 'normal', data.droppedTo, serial, data.name)
        addWeaponSlot2(data.droppedTo, data.metadata.serial, data.name)
        listWeaponToAdd[serial] = nil
    end
end)

function addWeaponSlot(data)
    Wait(300)
    local have = false
    for k, v in pairs(ESX.GetPlayerData().loadout) do
        if v.metadata.serial == data.metadata.serial then
            have = true
            break
        end
    end
    if have then
        addWeaponSlot2(data.droppedTo, data.metadata.serial, data.name)
        SetCurrentPedWeapon(PlayerPedId(), data.name, true)
        ESX.TriggerServerEvent('inventory:setSlot', 'normal', data.droppedTo, data.metadata.serial, data.name)
    else
        listWeaponToAdd[serial] = true
    end
end

function addWeaponSlot2(slot, serial, name)
    for k, v in pairs(weaponSlot) do
        if v.serial == serial then
            weaponSlot[k] = nil
        end
    end
    weaponSlot[slot] = {serial = serial, name = name}
    TriggerEvent('core:client:giveWeapon', serial)
    updateWeaponSlot2()
end

function removeWeaponSlot(serial, name)
    ESX.TriggerServerEvent('inventory:removeSlot', 'normal', serial)
    local name
    for k, v in pairs(weaponSlot) do
        name = v.name
        if v.serial == serial then
            weaponSlot[k] = nil
            break
        end
    end
    TriggerEvent('core:client:removeWeapon', serial, name)
    updateWeaponSlot2()
end

local openCD = false
AddEventHandler('KeyDown:f2',function()
    if openCD then return end
    openCD = true
    SetTimeout(1000, function()
        openCD = false
    end)
    if isCuffed() or LocalPlayer.state.nui or exports['Unique_utils']:getHandupState() then return end
    if pendingTrade and not isOpen then
        local p = pendingTrade
        pendingTrade = nil
        tradeMode = true
        tradePartner = p.name
        openOtherPlayerInventory(p.owner)
        if not isOpen then
            openui(true, true)
        end
        SendNUIMessage({action = 'tradeOpen', partner = p.name})
        TriggerServerEvent('trade:joinTrade')
        return
    end
    openui(not isOpen)
end)

local function playPointdownEmote()
    local animDict = "gestures@f@standing@casual"
    local animName = "gesture_hand_down"

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(10)
    end

    TaskPlayAnim(PlayerPedId(), animDict, animName, 8.0, -8.0, -1, 48, 0, false, false, false)
end

function openui(state, disablePreviewPed)
    isOpen = state
    LocalPlayer.state.nui = state
    SetNuiFocus(state, state)
    if canPlayAnim() then
        CreateThread(function()
            playPointdownEmote()
        end)
        -- SetTimeout(700, function()
        --     ClearPedTasks(PlayerPedId())
        -- end)
    end
    if state then
        exports['ox_target']:disableTargeting(true)
        exports['ox_target']:disableTargeting(false)
        if IsPedInAnyVehicle(PlayerPedId()) and not otherInventoryData.type and not tradeMode then
            if not ((not exports['Unique_utils']:checkncz() or exports['Unique_utils']:canAccessToVehicle(GetVehiclePedIsIn(PlayerPedId()))) and openTrunk(GetVehiclePedIsIn(PlayerPedId()), true)) then
                SendNUIMessage({action = 'openInventory', isMale = IsPedMale(PlayerPedId()), data = exports['Unique_Clothe']:getUsedType(), disablePreviewPed = disablePreviewPed or tradeMode})
                loadPlayerInventory()
            end
        else
            local bagId
            for k, v in pairs(ESX.GetPlayerData().inventory) do
                if v.name:find('kif_') and v.count > 0 then
                    bagId = v.name
                    break
                end
            end
            if bagId and not disablePreviewPed and autoOpenBag and not tradeMode then
                ESX.TriggerServerEvent('esx:useItem', bagId)
            else
                SendNUIMessage({action = 'openInventory', isMale = IsPedMale(PlayerPedId()), data = exports['Unique_Clothe']:getUsedType(), disablePreviewPed = disablePreviewPed or tradeMode})
                loadPlayerInventory()
            end
        end
    else
        deletePedScreen()
        SendNUIMessage({action = 'hideInventory'})
        if otherInventoryData.type == 'custom' then
            otherInventoryData.cb({type = 'close'})
        end
        if tradeMode then
            tradeMode = false
            tradePartner = nil
            ESX.TriggerServerEvent('trade:cancel')
        end
        otherInventoryData = {}
    end
end

function closeInventory()
    deletePedScreen()
    if otherInventoryData.type == 'custom' then
        otherInventoryData.cb({type = 'close'})
        TriggerServerEvent('Unique_inventory:unsubscribe')
    end
    if tradeMode then
        tradeMode = false
        tradePartner = nil
        SendNUIMessage({action = 'tradeClose'})
        ESX.TriggerServerEvent('trade:cancel')
    end
    otherInventoryData = {}
    SendNUIMessage({action = 'hideInventory'})
    LocalPlayer.state.nui = nil
    isOpen = false
    SetNuiFocus(false, false)
end
exports('closeInventory', closeInventory)

exports('openTrade', function(partnerName)
    tradeMode = true
    tradePartner = partnerName
    SendNUIMessage({action = 'tradeOpen', partner = partnerName})
    if not isOpen then
        openui(true, true)
    end
end)

exports('tradeMessage', function(data)
    if type(data) ~= 'table' then return end
    data.action = 'updateTrade'
    SendNUIMessage(data)
end)

exports('closeTrade', function()
    tradeMode = false
    tradePartner = nil
    pendingTrade = nil
    SendNUIMessage({action = 'tradeClose'})
    if isOpen then
        openui(false)
    end
end)

exports('setPendingTrade', function(owner, name)
    pendingTrade = { owner = owner, name = name }
end)

RegisterNUICallback('trade:ui', function(data, cb)
    exports['Unique_utils']:tradeUICallback(data)
    cb({ ok = true })
end)

RegisterNUICallback('trade:startWith', function(data, cb)
    if otherInventoryData.type == 'player' and otherInventoryData.target then
        exports['Unique_utils']:startTrade(otherInventoryData.target)
    end
    cb({ ok = true })
end)

function loadPlayerInventory(doesReturn)
    local playerItems = {}
    local items = ESX.GetPlayerData().inventory
    local itemsName = {}
    local usedClothe = exports['Unique_Clothe']:getUsed()
    local usedClotheWeight = 0
    resolveBagTypes(items)
    for k, v in pairs(items) do
        if not usedClothe[v.name] or v.count > 1 then
            v.image = getImage(v.name)
            v.itemdata = {}
            if v.count > 0 then
                itemsName[v.name] = v
            end
        else
            usedClotheWeight = usedClotheWeight + (v.weight * v.count)
        end
    end
    local reservedShode = {}
    reservedSlotByName = {}
    reservedSlotByName2 = {}
    reservedSlotBySerial = {}
    oldWeaponSlot = {}
    for k, v in pairs(reservedSlot) do
        if k > reservedSlotForWeapon and v.name then
            if not playerItems[k] then
                local item = itemsName[v.name]
                if item and not reservedShode[v.name] then
                    reservedShode[v.name] = true
                    playerItems[k] = item
                end
                reservedSlotByName[v.name] = k
                if v.serial then
                    reservedSlotBySerial[v.serial] = {k = k, name = v.name}
                end
                if not reservedSlotByName2[v.name] then
                    reservedSlotByName2[v.name] = {}
                end
                reservedSlotByName2[v.name][k] = v
            end
        end
    end

    local loadout = ESX.GetPlayerData().loadout
    for k, v in pairs(loadout) do
        v.itemdata = {}
        v.image = getImage(v.name:upper(), v.metadata.expireTS)
        v.weight = getItemWeight(v.name)
        v.count = v.ammo
        v.realCount = 1
        if weaponSlot2[v.metadata.serial] then
            reservedShode[v.metadata.serial] = true
            playerItems[weaponSlot2[v.metadata.serial]] = v
            loadout[k] = nil
            oldWeaponSlot[weaponSlot2[v.metadata.serial]] = {serial = v.metadata.serial, name = v.name}
        elseif reservedSlotBySerial[v.metadata.serial] and not reservedShode[v.metadata.serial] then
            local slot
            for k2, v2 in pairs(reservedSlotByName2[v.name]) do
                if v2 and v2.serial == v.metadata.serial then
                    slot = k2
                    reservedSlotByName2[v.name][k2] = false
                    break
                end
            end
            if slot and not playerItems[slot] then
                reservedShode[v.name] = true
                reservedShode[v.metadata.serial] = true
                playerItems[slot] = v
                loadout[k] = nil
                oldWeaponSlot[slot] = {serial = v.metadata.serial, name = v.name}
            end
        end
    end

    for k, v in pairs(loadout) do
        if not reservedShode[v.metadata.serial] then
            for i = reservedSlotForWeapon+1, 100000 do
                if not playerItems[i] then
                    playerItems[i] = v
                    oldWeaponSlot[i] = {serial = v.metadata.serial, name = v.name}
                    break
                end
            end
        end
    end

    for k, v in pairs(items) do
        if not reservedShode[v.name] and itemsName[v.name] then
            if (not usedClothe[v.name] or v.count > 1) then
                for i = reservedSlotForWeapon+1, 100000 do
                    if not playerItems[i] then
                        playerItems[i] = v
                        break
                    end
                end
            else
                usedClotheWeight = usedClotheWeight + (v.weight * v.count)
            end
        end
    end

    if doesReturn then
        return playerItems
    end
    if isOpen then
        SendUIInventory(playerItems, usedClotheWeight, mainInventoryData.maxWeight)
    end
end

exports('loadPlayerInventory', function()
    if isOpen then
        loadPlayerInventory()
    end
end)

RegisterNetEvent('moneyUpdate', function(money)
    SendNUIMessage({
        action = 'updateMoney',
        money = money,
    })
end)

RegisterNUICallback('close',function()
    TriggerScreenblurFadeOut(1000)
    openui(false)
end)

local cachedBag = {}
function resolveBagTypes(targetItems)
    local wanted = {}
    local seen = {}
    for _, v in pairs(targetItems) do
        local n = v and v.name
        if n and n:find('kif') and not cachedBag[n] and not seen[n] then
            seen[n] = true
            wanted[#wanted + 1] = n
        end
    end
    if #wanted == 0 then return end
    local p = promise.new()
    ESX.TriggerServerCallback('bag:getBagTypes', function(result)
        p:resolve(result)
    end, wanted)
    local result = Citizen.Await(p)
    if type(result) == 'table' then
        for name, bagType in pairs(result) do
            if bagType then
                cachedBag[name] = bagType
            end
        end
    end
end

function getImage(name, temp)
    local clotheData = exports['Unique_Clothe']:getClotheData(name)
    if clotheData then
        return exports['Unique_Clothe']:getImageUrl(name)
    elseif string.find(name,'pack_') then
        return exports['Unique_Clothe']:getImageUrl(name)
    else
        if name:find('key_') then
            name = 'key'
        elseif name:find('kif') then
            if cachedBag[name] then
                name = cachedBag[name]
            else
                local bagType = nil
                local p = promise.new()
                ESX.TriggerServerCallback('bag:getBagType', function(bagType)
                    p:resolve(bagType)
                end, name)
                bagType = Citizen.Await(p)
                if bagType then
                    cachedBag[name] = bagType
                    name = cachedBag[name]
                else
                    name = 'kool1'
                end
            end
        elseif name:find('tokenxp') then
            name = 'xptoken'
        end
        if temp then
            name = ('%s_TEMP'):format(name)
        end
        return 'img/items/'.. name ..'.png'
    end
end

RegisterNUICallback('inventory:useItem', function(name)
    ESX.TriggerServerEvent('esx:useItem', name)
    Wait(500)
    -- loadPlayerInventory()
end)

RegisterNUICallback('inventory:throwItem', function(data)
    if ESX.militaryJobs2[ESX.GetPlayerData().job.name] or exports['Unique_robbery']:doesInRob() then
        if checkSomething(data.name, 1000) then return end
        if IsPedSittingInAnyVehicle(PlayerPedId()) then
            return
        end
        if isBlackList(data.name) then
            return ESX.Alert('', 'Shoma nemitavanid in item ra drop konid!', 6000, 'error')
        end
        local itemType = getItemType(data.name)
        if type(data.count) == 'number' and math.floor(data.count) == data.count then
            -- AlreadyDroped = AlreadyDroped + 1
            -- SetTimeout(120000, function()
            --     AlreadyDroped = AlreadyDroped - 1
            -- end)
            if data.inventoryType == 'second' then
                data.count = ESX.Math.Round(data.count)
                data.itemType = getItemType(data.name)
                if otherInventoryData.type == 'custom' then
                    otherInventoryData.cb({type = 'moveToMain', data = data})
                end
                Wait(1000)
            end
            local serial = itemType == 'item_weapon' and data.metadata.serial or nil
            ESX.TriggerServerEvent('core:dropItem', itemType, data.name, data.count, serial, GetEntityCoords(PlayerPedId()), GetEntityForwardVector(PlayerPedId()), exports['Unique_jobs']:notBlackListCoords(), ESX.Game.GetPlayersToSend(50), ESX.Game.GetPlayersToSend(150))
        end
    end
    -- loadPlayerInventory()
end)

RegisterNUICallback('inventory:deleteItem', function(data, cb)
    if cb then cb({ ok = true }) end
    if not data or not data.name then return end
    if config.NoDelete and config.NoDelete[data.name] then
        return ESX.notification('error', 'این آیتم قابل حذف نیست')
    end
    if IsPedSittingInAnyVehicle(PlayerPedId()) or ESX.isDead() or LocalPlayer.state.combat then
        return
    end
    if isBlackList(data.name) and not data.name:find('key_') then
        return ESX.Alert('', 'Shoma nemitavanid in item ra drop konid!', 6000, 'error')
    end
    if ESX.GetPlayerData().World ~= 0 then
        return ESX.notification('error', 'در این ورلد نمیتوانید این کار را انجام دهید')
    end
    local itemType = getItemType(data.name)

    if ESX.militaryJobs[ESX.GetPlayerData().job.name] then
        if type(data.count) ~= 'number' or math.floor(data.count) ~= data.count then return end
        local serial = itemType == 'item_weapon' and data.serial or nil
        if itemType == 'item_weapon' and not serial then return end
        ESX.TriggerServerEvent('core:dropItem', itemType, data.name, data.count, serial, GetEntityCoords(PlayerPedId()), GetEntityForwardVector(PlayerPedId()), exports['Unique_jobs']:notBlackListCoords(), ESX.Game.GetPlayersToSend(50), ESX.Game.GetPlayersToSend(150))
        return
    end

    if type(data.count) == 'number' and math.floor(data.count) == data.count and itemType == 'item_standard' then
        local recycleId = 'recycle:' .. getRandomRecycle()
        data.itemType = itemType
        data.delete = true
        local deleteDelete = false
        local coords = GetEntityCoords(PlayerPedId())
        for k, v in pairs(deleteCoords) do
            if #(coords - v.xyz) < v.w then
                deleteDelete = true
                break
            end
        end
        data.deleteDelete = deleteDelete or ESX.TableContainsValue(forceDelete, data.name) or data.name:find('key_')
        ESX.TriggerServerEvent('inventory-public:put', recycleId, data, 'delete')
    end
end)


function moveInsideHandler(data)
    if data.inventoryType == 'main' then
        local oldIndex = nil
        local itemType = getItemType(data.name)
        local itemType2 = nil
        local playerInventory = loadPlayerInventory(true)
        local oldIndex2
        local gunChangeShode = false
        local targetData = nil
        if itemType == 'item_weapon' then
            for k, v in pairs(playerInventory) do
                if v.metadata and v.metadata.serial == data.metadata.serial then
                    oldIndex2 = k
                end
            end
            for k, v in pairs(reservedSlot) do
                if v.serial == data.metadata.serial and k == oldIndex2 then
                    oldIndex = k
                    break
                end
            end
        else
            for k, v in pairs(reservedSlot) do
                if v.name and v.name == data.name then
                    oldIndex = k
                    break
                end
            end
            targetData = playerInventory[data.droppedTo]
        end
        if config.attachments[data.name] and data.droppedToData and data.droppedToData.metadata then
            ESX.TriggerServerEvent('item:use:' .. data.name, data.droppedToData.metadata.serial)
            return loadPlayerInventory()
        end
        if data.droppedTo > reservedSlotForWeapon or itemType == 'item_weapon' then
            if data.droppedToData and data.droppedToData.name and data.droppedToData.name:find('kif_') and not checkSomething(data.droppedFromData.name, 2000, 'bag') then
                data.droppedFromData.count = ESX.Math.Round(data.count)
                local bagId, _ = data.droppedToData.name:gsub('kif_', '')
                data.droppedFromData.itemType = getItemType(data.droppedFromData.name)
                ESX.TriggerServerEvent('inventory-bag:put', tonumber(bagId), data.droppedFromData)
            else
                if reservedSlot[data.droppedTo] and oldIndex and oldIndex > reservedSlotForWeapon and data.droppedTo > reservedSlotForWeapon then
                    reservedSlot[oldIndex] = reservedSlot[data.droppedTo]
                elseif data.droppedTo <= reservedSlotForWeapon and oldIndex2 and oldIndex2 <= reservedSlotForWeapon and weaponSlot[oldIndex2] then
                    if blackListWorldSwapWeapon[ESX.GetPlayerData().World] then return end
                    if doesMilitaryWeapon(data.metadata.serial) and not weaponSlot2[data.metadata.serial] then return ESX.chatMessage('In aslahe be dalil serial police budan ghabel estefade nist', 'plarms') end
                    if doesGangWeapon(data.metadata.serial) and not weaponSlot2[data.metadata.serial] then return ESX.chatMessage('In aslahe be dalil serial gang budan ghabel estefade nist', 'plarms') end
                    supapWeaponSlot()
                    local old = weaponSlot[oldIndex2]
                    weaponSlot[oldIndex2] = weaponSlot[data.droppedTo]
                    weaponSlot[data.droppedTo] = old
                    updateWeaponSlot2()
                    ESX.TriggerServerEvent('inventory:swapWeaponSlot', oldIndex, data.droppedTo)
                    gunChangeShode = true
                elseif oldIndex then
                    if itemType == 'item_standard' or (playerInventory[oldIndex] and playerInventory[oldIndex].metadata.serial == data.metadata.serial) then
                        reservedSlot[oldIndex] = nil
                    end
                end
                if data.droppedTo > reservedSlotForWeapon and (not oldIndex or oldIndex > reservedSlotForWeapon) then
                    reservedSlot[data.droppedTo] = {name = data.name, serial = data.droppedFromData and data.droppedFromData.metadata and data.droppedFromData.metadata.serial}
                    ESX.TriggerServerEvent('inventory:setReservedSlot', reservedSlot)
                end
                if itemType == 'item_weapon' and not gunChangeShode then
                    if blackListWorldSwapWeapon[ESX.GetPlayerData().World] then return end
                    if doesMilitaryWeapon(data.metadata.serial) and not weaponSlot2[data.metadata.serial] then return ESX.chatMessage('In aslahe be dalil serial police budan ghabel estefade nist', 'plarms') end
                    if doesGangWeapon(data.metadata.serial) and not weaponSlot2[data.metadata.serial] then return ESX.chatMessage('In aslahe be dalil serial gang budan ghabel estefade nist', 'plarms') end
                    supapWeaponSlot()
                    local have = false
                    for k, v in pairs(weaponSlot) do
                        if v.name == data.name then
                            have = true
                            break
                        end
                    end
                    if not have or not weaponSlot2[data.metadata.serial] then
                        if data.droppedTo <= reservedSlotForWeapon then
                            if (ESX.GetPlayerData().World ~= 0 and not exports['Unique_robbery']:doesInRob()) or playWeaponAnim(data.name) then
                                if weaponSlot[data.droppedTo] then
                                    removeWeaponSlot(weaponSlot[data.droppedTo].serial)
                                    Wait(1000)
                                end
                                addWeaponSlot(data)
                            end
                        end
                    elseif weaponSlot2[data.metadata.serial] then
                        if ESX.GetPlayerData().World ~= 0 or playWeaponAnim(data.name) then
                            removeWeaponSlot(data.metadata.serial)
                        end
                    end
                end
            end
            if isOpen then
                loadPlayerInventory()
            else
                isOpen = true
                LocalPlayer.state.nui = true
                SetNuiFocus(true, true)
                SendNUIMessage({action = 'openInventory', isMale = IsPedMale(PlayerPedId()), data = exports['Unique_Clothe']:getUsedType(), disablePreviewPed = false})
                loadPlayerInventory()
            end
        end
    else
        if otherInventoryData.type == 'custom' then
            otherInventoryData.cb({type = 'moveInside', data = data})
            Wait(500)
            pushSecondView()
        end
    end
end


RegisterNUICallback('inventory:moveInside', moveInsideHandler)
exports('moveInside', moveInsideHandler)

exports('reopenInventoryUI', function()
    if isOpen then
        loadPlayerInventory()
    else
        isOpen = true
        LocalPlayer.state.nui = true
        SetNuiFocus(true, true)
        SendNUIMessage({action = 'openInventory', isMale = IsPedMale(PlayerPedId()), data = exports['Unique_Clothe']:getUsedType(), disablePreviewPed = false})
        loadPlayerInventory()
    end
end)

function checkSomething(name, interval, type, type2)
    if antiSpam or (name and ((name:find('key_') and type ~= 'player' and (not otherInventoryData.type or not otherInventoryData.data.searchKey)) or (name:find('mythic') and (type2 ~= 'gang' and type ~= 'player')))) then
        return true
    else
        antiSpam = true
        SetTimeout(interval,function()
            antiSpam = false
        end)
    end
end

function isBlackList(name, _type)
    for k,v in pairs(blackListedItems) do
        if name == v or (name:find('key_') and _type ~= 'player' and (not otherInventoryData.type or not otherInventoryData.data.searchKey)) or (name:find('mythic') and _type ~= 'gang') then
            return true
        end
    end
    return false
end

function getItemType(name)
    local itemType = 'item_standard'
    if name then
        if name:lower():find('weapon_') or name:lower():find('gadget_') then
            itemType = 'item_weapon'
        end
    else
        name = nil
    end
    return itemType
end

AddEventHandler('onMultiplePress', function(keys)
    if keys['lmenu'] then
        if isCuffed() then return end
        local index = nil
        if keys['1'] then
            index = 1
        elseif keys['2'] then
            index = 2
        elseif keys['3'] then
            index = 3
        elseif keys['4'] then
            index = 4
        elseif keys['5'] then
            index = 5
        elseif keys['6'] then
            index = 6
        elseif keys['7'] then
            index = 7
        end
        if index then
            local items = loadPlayerInventory(true)
            local index = index+reservedSlotForWeapon
            if items[index] then
                if checkSomething(nil, 2000) then return end
                if ESX.DoesHaveItem2(items[index].name, 1) then
                    ESX.TriggerServerEvent('esx:useItem', items[index].name)
                end
            end
        end
    end
end)



function updateHandler()
    if isOpen then
        Wait(500)
        if not isOpen then return end
        loadPlayerInventory()
        if otherInventoryData.type == 'player' then
            openOtherPlayerInventory(otherInventoryData.target, otherInventoryData.admin)
        elseif otherInventoryData.type == 'custom' then
            pushSecondView()
        end
    end
end

RegisterNetEvent('esx:updateInventory', updateHandler)
RegisterNetEvent('esx:updateLoadout', updateHandler)

RegisterNetEvent('Unique_inventory:changed', function()
    if isOpen and otherInventoryData.type == 'custom' then
        pushSecondView()
    end
end)

RegisterNetEvent('inventory:updateMaxWeight', function(weight)
    mainInventoryData.maxWeight = weight
    SendNUIMessage({
        action = 'setPlayerStaticData',
        maxweight = mainInventoryData.maxWeight,
        name = ESX.GetPlayerData().name2 .. ' - ' .. ESX.src
    })
end)

function openOtherPlayerInventory(src, admin)
    if isCuffed() or ESX.isDead() then return end
    if ESX.Game.doesPlayerExist(src) or admin then
        local targetPed = GetPlayerPed(GetPlayerFromServerId(src))
        local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(targetPed))
        local job = ESX.GetPlayerData().job.name
        if distance < 5 or admin then
            local canSearch = false
            if (ESX.GetPlayerData().World == 0 or exports['Unique_robbery']:doesInRob() or exports['gangs']:isInGangWorld()) and not IsPedInAnyVehicle(targetPed) then
                if canSearchJob[job] then
                    canSearch = true
                elseif ESX.GetPlayerData().gang.name ~= 'nogang' then
                    local p = promise.new()
                    ESX.TriggerServerCallback('esx:checkemsstatus', function(data,data2)
                        ESX.TriggerServerCallback('citizen:cuffstatus', function(statuss, typee, admin)
                            p:resolve(IsEntityPlayingAnim(targetPed, "missfra1mcs_2_crew_react","handsup_standing_base", 3) or IsEntityPlayingAnim(targetPed, "missminuteman_1ig_2","handsup_base", 3) or data or data2 or statuss)
                        end, src)
                    end, src)
                    canSearch = Citizen.Await(p)
                end
            end
            if canSearch then
                exports['Unique_utils']:me('Eghdam be gashtan fard mikone', false)
            end
            if admin then
                canSearch = admin
            end
            otherInventoryData = {
                type = 'player',
                data  = {
                    timeout = math.random(1000, 1500),
                },
                canSearch = canSearch,
                admin = admin,
                target = src
            }
            openui(true, true)
            ESX.TriggerServerCallback('esx:getOtherPlayerData', function(data)
                local targetItems = {}
                if canSearch then
                    for k, v in pairs(data.loadout) do
                        if not isBlackList(v.name) and (not blackListJob[data.job.name] or militaryJobs[job]) and not data.protectedItems[v.name:lower()] and not ESX.blackListSearch[v.name:lower()] and data.permission_level == 0 or admin then
                            v.image = getImage(v.name:upper(), v.metadata.expireTS)
                            v.count = v.ammo
                            v.realCount = 1
                            v.itemdata = {}
                            table.insert(targetItems, v)
                        end
                    end
                    ESX.fetchListedItems(data.inventory)
                    for k, v in pairs(data.inventory) do
                        if not exports['Unique_Clothe']:getClotheData(v.name)
                        and not string.find(v.name,'pack_') and not data.protectedItems[v.name]
                        and not ESX.blackListSearch[v.name:lower()]
                        and (not ESX.doesBlockedItem(v.name) or ESX.doesBlockedItemButCanGive(v.name))
                        and (not ESX.doesBlockedItemJob(v.name, data.job.name))
                        and (not blackListJob[data.job.name] or militaryJobs[job])
                        and data.permission_level == 0 and v.count > 0 or admin then
                            v.image = getImage(v.name)
                            v.itemdata = {
                                description = '',
                            }
                            table.insert(targetItems, v)
                        end
                    end
                    if data.scMilitary then
                        local item = ESX.getItem('sc')
                        item.image = getImage(item.name)
                        item.itemdata = {
                            description = '',
                        }
                        table.insert(targetItems, item)
                    end
                end
                SendUISecondView(fillItems(targetItems), 'flat', nil, nil, ('جیب پلیر ' .. src), nil, 'player', canSearch, true)
            end, src)
        end
    end
end
exports('openOtherPlayerInventory', function(...)
    openOtherPlayerInventory(...)
    updateSecondThread()
end)

function updateSecondInventory(targetItems, label, maxWeight, type, first)
    if first then
        deletePedScreen()
    end
    SendNUIMessage({
        action = 'updateSecondInventory',
        inventory = targetItems,
        label = label,
        maxWeight = maxWeight,
        type = type,
        first = first,
    })
end

function localSecondView(items, mode, weaponName)
    items = items or {}
    if mode == 'groups' then
        local index, order = {}, {}
        for _, v in ipairs(items) do
            if type(v) == 'table' and v.name and v.name ~= 'empty' and v.name ~= 'locked' and getItemType(v.name) == 'item_weapon' then
                if not index[v.name] then
                    index[v.name] = { count = 0, locked = v.locked, locked2 = v.locked2 }
                    order[#order + 1] = v.name
                end
                index[v.name].count = index[v.name].count + 1
            end
        end
        local groups = {}
        for _, name in ipairs(order) do
            groups[#groups + 1] = { name = name, count = index[name].count, locked = index[name].locked, locked2 = index[name].locked2 }
        end
        return groups
    elseif mode == 'instances' then
        local out = {}
        for _, v in ipairs(items) do
            if type(v) == 'table' and v.name == weaponName then
                out[#out + 1] = v
            end
        end
        return out
    else
        local out = {}
        for _, v in ipairs(items) do
            if type(v) == 'table' and v.name and v.name ~= 'empty' and v.name ~= 'locked' and getItemType(v.name) ~= 'item_weapon' then
                out[#out + 1] = v
            end
        end
        return { items = out }
    end
end

function countSecondTabs(list)
    local items, guns, seenWeapon = 0, 0, {}
    for _, v in pairs(list or {}) do
        if type(v) == 'table' and v.name and v.name ~= 'empty' and v.name ~= 'locked' and not v.locked2 then
            if getItemType(v.name) == 'item_weapon' then
                if not seenWeapon[v.name] then
                    seenWeapon[v.name] = true
                    guns = guns + 1
                end
            else
                local count = tonumber(v.count) or 0
                if count > 0 then items = items + count end
            end
        end
    end
    return { items = items, guns = guns }
end

function pushSecondView(first, withLoading)
    if otherInventoryData.type ~= 'custom' then return end
    local d = otherInventoryData.data
    if first then
        deletePedScreen()
    end
    local mode = d.flat and 'flat' or (secondOpenWeapon and 'instances' or (secondTab == 'guns' and 'groups' or 'items'))
    if withLoading then
        SendNUIMessage({
            action = 'secondLoading',
            tab = secondTab,
            view = mode,
            openWeapon = secondOpenWeapon,
            label = d.label,
            maxWeight = d.maxWeight,
            kind = 'custom',
        })
    end
    local raw, tabCounts
    if d.fetch ~= nil then
        raw = d.fetch(mode, secondOpenWeapon)
    else
        local fresh = otherInventoryData.cb({ type = 'update' })
        local full = type(fresh) == 'table' and fresh or d.items
        raw = localSecondView(full, mode, secondOpenWeapon)
        tabCounts = countSecondTabs(full)
        if fresh and fresh.weight then
            raw.weight = fresh.weight
        end
    end
    SendUISecondView(raw, mode, secondTab, secondOpenWeapon, d.label, d.maxWeight, 'custom', nil, first, tabCounts)
end

RegisterNUICallback('inventory:secondTab', function(data, cb)
    if data and (data.tab == 'items' or data.tab == 'guns') then
        secondTab = data.tab
        secondOpenWeapon = nil
        pushSecondView(false, true)
    end
    cb({ ok = true })
end)

RegisterNUICallback('inventory:secondOpenWeapon', function(data, cb)
    if data and data.name then
        secondOpenWeapon = data.name
        pushSecondView(false, true)
    end
    cb({ ok = true })
end)

RegisterNUICallback('inventory:secondBack', function(_, cb)
    secondOpenWeapon = nil
    pushSecondView(false, true)
    cb({ ok = true })
end)

AddEventHandler('KeyDown:lmenu', function()
    if not disableWeaponSwitch then
        disableWeaponSwitch = true
        CreateThread(function()
            while disableWeaponSwitch do
                Wait(0)
                DisableControlAction(0, 157)
                DisableControlAction(0, 158)
                DisableControlAction(0, 160)
                DisableControlAction(0, 164)
                DisableControlAction(0, 165)
            end
        end)
    end
end)

AddEventHandler('KeyUP:lmenu', function()
    disableWeaponSwitch = false
end)

function howMuchFitsInSecond(name, count)
    local d = otherInventoryData.data
    if not d then return count end
    local raw
    if d.fetch ~= nil then
        raw = d.fetch('items')
    else
        raw = otherInventoryData.cb({type = 'update'})
    end
    if type(raw) ~= 'table' then return count end
    local list = raw.items or raw
    local fit = count
    local maxWeight = tonumber(d.maxWeight)
    local used = tonumber(raw.weight)
    if maxWeight and maxWeight > 0 and used then
        local unit = ESX.getItemWeight(name, d.type == 'trunk')
        if unit and unit > 0 then
            local byWeight = math.floor((maxWeight - used) / unit)
            if byWeight < fit then fit = byWeight end
        end
    end
    local item = d.itemLimit and ESX.getItem(name)
    if item and item.limit and item.limit >= 0 then
        local owned = 0
        for _, v in pairs(list) do
            if type(v) == 'table' and v.name == name then
                owned = owned + (tonumber(v.count) or 0)
            end
        end
        local byLimit = item.limit - owned
        if byLimit < fit then fit = byLimit end
    end
    if fit < 1 then fit = 1 end
    return fit
end

function moveToOtherHandler(data)
    if data.name then
        data.count = ESX.Math.Round(data.count)
        if checkSomething(data.name, otherInventoryData.data and otherInventoryData.data.timeout or 3000, otherInventoryData.type, otherInventoryData.data.type) then return end
        if canPlayAnim() then
            exports['Unique_animmenu']:PlayEmote('damn2', true)
        end
        data.itemType = getItemType(data.name)
        if data.itemType == 'item_standard' and otherInventoryData.type == 'custom' then
            local fit = howMuchFitsInSecond(data.name, data.count)
            if fit < data.count then data.count = fit end
        end
        if otherInventoryData.type == 'player' then
            giveItemToPlayer(data)
        elseif otherInventoryData.type == 'custom' then
            otherInventoryData.cb({type = 'moveToOther', data = data})
        end
    end
end

RegisterNUICallback('inventory:instantToSecond', moveToOtherHandler)
RegisterNUICallback('inventory:moveToSecond', moveToOtherHandler)

RegisterNUICallback('inventory:swapMoney', function(amount)
    amount = tonumber(amount)
    if type(amount) == 'number' and math.floor(amount) == amount then
        if checkSomething(nil, 3000) then return end
        if canPlayAnim() then
            exports['Unique_animmenu']:PlayEmote('damn2', true)
        end
        if otherInventoryData.type == 'player' and not otherInventoryData.admin then
            local src = otherInventoryData.target
            if ESX.Game.doesPlayerExist(src) then
                local targetPed = GetPlayerPed(GetPlayerFromServerId(src))
                local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(targetPed))
                if distance < 5 then
                    ESX.TriggerServerEvent('core:giveItem', src, 'item_money', nil, amount, nil, nil, ESX.Game.GetPlayersToSend(50))
                end
            end
        else
            if amount >= 1000 then
                ESX.TriggerServerEvent('core:dropItem', 'item_money', nil, amount, nil, GetEntityCoords(PlayerPedId()), GetEntityForwardVector(PlayerPedId()), nil, ESX.Game.GetPlayersToSend(50), ESX.Game.GetPlayersToSend(150))
            else
                ESX.Alert('', 'Had aghal meghdar drop 1k ast.', 7000, 'error')
            end
        end
    end
end)

function giveItemToPlayer(data)
    local src = otherInventoryData.target
    if ESX.Game.doesPlayerExist(src) or otherInventoryData.admin then
        local targetPed = GetPlayerPed(GetPlayerFromServerId(src))
        local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(targetPed))
        if distance < 5 or otherInventoryData.admin then
            local itemType = getItemType(data.name)
            if isBlackList(data.name) and not data.name:find('key_') and not otherInventoryData.admin then
                return ESX.Alert('', 'Shoma nemitavanid in item ra give konid!', 6000, 'error')
            end
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle ~= 0 then
                local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
                if data.name == "key_".. plate then
                    Citizen.CreateThread(function()
                        while GetVehiclePedIsIn(PlayerPedId(), false) == vehicle do
                            Wait(1)
                            SetVehicleEngineOn(vehicle,false,true,true)
                        end
                    end)
                end
            end
            local serial = nil
            if itemType == 'item_weapon' then
                serial = data.metadata.serial
            end
            if ESX.GetPlayerState(src, 'canGive') or otherInventoryData.admin then
                ESX.TriggerServerEvent('core:giveItem', src, itemType, data.name, data.ammo or data.count, serial, otherInventoryData.admin, ESX.Game.GetPlayersToSend(50))
            else
                ESX.chatMessage('Shoma nemitavanid be in fard chizi bedid!', 'plarms')
            end
        end
    end
end

function searchPlayer(data)
    local src = otherInventoryData.target
    if ESX.Game.doesPlayerExist(src) or otherInventoryData.admin then
        local targetPed = GetPlayerPed(GetPlayerFromServerId(src))
        local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(targetPed))
        if distance < 5 or otherInventoryData.admin then
            local itemType = getItemType(data.name)
            ESX.TriggerServerEvent('core:confiscatePlayerItem', src, itemType, data.name, data.count, itemType == 'item_weapon' and data.metadata.serial or nil, otherInventoryData.admin)
            if data.droppedTo then
                data.inventoryType = 'main'
                moveInsideHandler(data)
            end
        end
    end
end

function moveToMainHandler(data)
    if data.name then
        data.count = ESX.Math.Round(data.count)
        if checkSomething(data.name, otherInventoryData.data and otherInventoryData.data.timeout or 3000, otherInventoryData.type, otherInventoryData.data.type) then return end
        if canPlayAnim() then
            exports['Unique_animmenu']:PlayEmote('damn2', true)
        end
        data.itemType = getItemType(data.name)
        if data.itemType == 'item_standard' then
            local canCount = nil
            local p = promise.new()
            ESX.TriggerServerCallback('inventory:howMuchCanCarry', function(count)
                p:resolve(count)
            end, data.name)
            canCount = Citizen.Await(p)
            if canCount < data.count and canCount > 0 then
                data.count = canCount
            end
        end
        if otherInventoryData.type == 'player' then
            searchPlayer(data)
        elseif otherInventoryData.type == 'custom' then
            otherInventoryData.cb({type = 'moveToMain', data = data})
        end
    end
end

RegisterNUICallback('inventory:instantToMain', moveToMainHandler)
RegisterNUICallback('inventory:moveToMain', moveToMainHandler)

function fillItems(targetItems, _type)
    local ts = exports['Unique_utils']:GetServerOSTime()
    local trunk = _type == 'trunk'
    ESX.fetchListedItems(targetItems)
    resolveBagTypes(targetItems)
    for k, v in pairs(targetItems) do
        if v.name ~= 'locked' then
            local itemType = cachedType[v.name] or getItemType(v.name)
            local item
            if not cachedType[v.name] then
                cachedType[v.name] = itemType
            end
            if not v.itemdata then
                v.itemdata = {
                    description = '',
                }
            end
            if not v.image then
                v.image = cachedImage[v.name] or getImage(v.name, v.metadata and v.metadata.expireTS)
                if not cachedImage[v.image] then
                    cachedImage[v.image] = v.image
                end
            end
            if v.ammo then
                v.count = v.ammo
                v.realCount = 1
            end
            if not v.weight then
                v.weight = getItemWeight(v.name, trunk) or 0
            end
            if itemType == 'item_standard' then
                item = ESX.getItem(v.name)
                if item then
                    v.itemdata.description = item.description
                    v.difficulty = item.difficulty or 1
                    v.itemdata.description = ('%s\nWeight : %s , Veh : %sKG'):format(v.itemdata.description, item.weight, item.weightTrunk)
                else
                    print(v.name)
                end

            elseif itemType == 'item_weapon' then
                item = ESX.GetWeapon(v.name)
                v.difficulty = item.difficulty
                if not v.metadata then
                    v.metadata = {
                        serial = '0000000000'
                    }
                end
                if not v.itemdata.description then
                    local health = ESX.Math.Round(not item.maxShots and 100 or 100 - (v.metadata.shots or 0) * 100 / item.maxShots, 1)
                    if health < 0 then
                        health = 0
                    end
                    local expire = 'NEVER'
                    if v.metadata.expireTS then
                        if v.metadata.expireTS > ts then
                            expire = ESX.displayTime(v.metadata.expireTS - ts)
                        else
                            expire = 'Expired'
                        end
                    end
                    v.itemdata = {
                        description = ('Serial : %s\nWeight : %s , Veh : %sKG\nHealth : %s%% Expire : %s'):format(v.metadata.serial, item.weight, item.weightTrunk, health, expire)
                        -- description = ('Serial : %s\nWeight : %s , Veh : %sKG\nExpire : %s'):format(v.metadata.serial, item.weight, item.weightTrunk, expire)
                    }
                end
                local attachmentLine = false
                if v.components and type(v.components) == 'table' and #v.components > 0 then
                    attachmentLine = true
                    v.itemdata.description = v.itemdata.description .. '\nAttachments : '
                    for k2, v2 in pairs(v.components) do
                        v.itemdata.description = v.itemdata.description .. ESX.GetWeaponComponent(v.name, v2).label .. ', '
                    end
                end
                if v.tintIndex and v.tintIndex > 0 then
                    if not attachmentLine then
                        v.itemdata.description = v.itemdata.description .. '\nAttachments : '
                    end
                    v.itemdata.description = v.itemdata.description .. 'Skin '.. tintLabel[v.tintIndex].. ', '
                end
            end
            if not v.label then
                if itemType == 'item_standard' then
                    if v.data and v.data.label then
                        v.label = v.data.label
                    else
                        if item then
                            v.label = item.label
                        end
                    end

                elseif itemType == 'item_weapon' then
                    v.label = ESX.GetWeaponLabel(v.name)
                end
            end
            if itemType == 'item_weapon' and v.metadata.expireTS then
                v.label = v.label .. '(T)'
            end
            if not v.limit and item and item.limit then
                v.limit = item.limit
            end
        end
    end
    local maxIndex = 0
    for k, v in pairs(targetItems) do
        if k > maxIndex then
            maxIndex = k
        end
    end
    if maxIndex then
        for i=1, maxIndex do
            if not targetItems[i] then
                targetItems[i] = 'empty'
            end
        end
    end

    local itemLength = maxIndex
    for i= 1, (maxIndex < 90 and 100 or maxIndex + 20) do
        if not targetItems[i] then
            targetItems[i] = 'empty'
        end
    end
    return targetItems
end

function sortItems(data, type)
    local items = {}
    local reservedSlot = data.slots or {}
    local reservedSlotByName = {}
    local reservedShode = {}
    ESX.fetchListedItems(data.items)
    if data.items then
        local itemsName = {}
        for k, v in pairs(data.items) do
            if v.count > 0 then
                itemsName[v.name] = v
            end
        end
        for k, v in pairs(reservedSlot) do
            local item = itemsName[v]
            if item and not reservedShode[v] and not items[k] then
                reservedShode[v] = true
                items[k] = item
            end
            reservedSlotByName[v] = k
        end
        for k, v in pairs(data.items) do
            if not reservedShode[v.name] and itemsName[v.name] then
                for i = 1, 1000 do
                    if not items[i] then
                        items[i] = v
                        break
                    end
                end
            end
        end
    end
    if data.weapons then
        local loadout = data.weapons
        for k, v in pairs(loadout) do
            v.itemdata = {}
            if reservedSlotByName[v.name] and not reservedShode[v.name] and not items[reservedSlotByName[v.name]] then
                reservedShode[v.name] = true
                items[reservedSlotByName[v.name]] = v
                loadout[k] = nil
            end
        end
        for k, v in pairs(loadout) do
            -- if not reservedShode[v.name] then
                for i = 1, 100000 do
                    if not items[i] then
                        items[i] = v
                        break
                    end
                end
            -- end
        end
    end
    return fillItems(items, type)
end

exports('sortItems', sortItems)

function showNotif(name, count, label)
    if name then
        if count > 0 then
            count = '+' .. count
        end
        SendNUIMessage({
            action = 'itemNotification',
            name = name,
            image = getImage(name),
            label = label and name or (getItemType(name) == 'item_standard' and ESX.getItem(name).label or ESX.GetWeaponLabel(name)),
            count = count
        })
    end
end

RegisterNetEvent('inventory:showNotif', function(...)
    showNotif(...)
end)

exports('showNotif', showNotif)

function openOtherInventory(data, cb)
    if isCuffed() then return end
    if otherInventoryData.type == 'custom' then
        otherInventoryData.cb({type = 'close'})
        Wait(1000)
    end
    otherInventoryData = {}
    otherInventoryData = {
        type = 'custom',
        data = data,
        cb = cb,
    }
    openui(true, true)
    secondOpenWeapon = nil
    pushSecondView(true, true)
    updateSecondThread()
    if not data.disableExitCheck then
        ESX.registerExitPoint(5, function()
            if isOpen then
                openui(false)
                closeInventory()
            end
        end)
    end
end

function updateSecondThread()
    CreateThread(function()
        while otherInventoryData.type ~= nil do
            Wait(3000)
            if otherInventoryData.type == 'player' then
                openOtherPlayerInventory(otherInventoryData.target, otherInventoryData.admin)
            elseif otherInventoryData.type == 'custom' then
                if not (otherInventoryData.data and (otherInventoryData.data.fetch ~= nil or otherInventoryData.data.noPoll)) then
                    pushSecondView()
                end
            end
        end
    end)
end

function canPlayAnim()
    return not LocalPlayer.state.disableAnim and not playingAnim and not IsEntityPlayingAnim(PlayerPedId(), "missfra1mcs_2_crew_react","handsup_standing_base", 3) and not ESX.isDead() and GetSelectedPedWeapon(PlayerPedId()) == `weapon_unarmed`
end

exports('openOtherInventory', openOtherInventory)

function openSearchMenu()
    if isCuffed() or ESX.isDead() then return end
    ESX.UI.Menu.CloseAll()
    local drawPlayer = {}
    local coords = ESX.getCoords()
    local players = ESX.Game.GetPlayersInArea(coords, 3)
    local elements = {}
    for k, v in pairs(players) do
        local ped = GetPlayerPed(v)
        local distance = ESX.Math.Round(ESX.GetDistance(coords, GetEntityCoords(ped)), 1)
        local src = GetPlayerServerId(v)
        local canSearch = false
        if not blackListWorldSearch[ESX.GetPlayerData().World] and not IsPedInAnyVehicle(ped) then
            if canSearchJob[ESX.GetPlayerData().job.name] then
                canSearch = true
            elseif ESX.GetPlayerData().gang.name ~= 'nogang' then
                local p = promise.new()
                ESX.TriggerServerCallback('esx:checkemsstatus', function(data,data2)
                    ESX.TriggerServerCallback('citizen:cuffstatus', function(statuss, typee, admin)
                        p:resolve(IsEntityPlayingAnim(ped, "missfra1mcs_2_crew_react","handsup_standing_base", 3) or IsEntityPlayingAnim(ped, "missminuteman_1ig_2","handsup_base", 3) or data or data2 or statuss)
                    end, src)
                end, src)
                canSearch = Citizen.Await(p)
            end
        end
        if v == PlayerId() or not HasEntityClearLosToEntity(PlayerPedId(), ped, 17) or not canSearch then
            players[k] = nil
        else
            table.insert(elements, {
                label = distance .. 'm',
                distance = distance,
                id = v,
                ped = ped,
                src = src
            })
        end
    end
    table.sort(elements, function(a, b)
        return a.distance < b.distance
    end)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'search',
        {
            title    = 'Dast tu jib kodum fard konim?',
            align    = 'top-left',
            elements = elements,
        },
        function(data, menu)
            menu.close()
            openOtherPlayerInventory(data.current.src)
            updateSecondThread()
        end,
    function(data, menu)
        menu.close()
        drawPlayer = {}
    end,
    function(data, menu)
        drawPlayer = {}
        Wait(20)
        drawPlayer[data.current.ped] = true
        Citizen.CreateThread(function()
            while drawPlayer[data.current.ped] and ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'search') and ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(data.current.ped)) <= 5 do
                Wait(0)
                local coords = GetEntityCoords(data.current.ped)
                local distance = ESX.Math.Round(ESX.GetDistance(coords, GetEntityCoords(PlayerPedId())), 1)
                DrawMarker(1, coords.x, coords.y, coords.z - 1.0, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 1.5, 255, 0, 0, 50, 0, 0, 0, 0)
                ESX.Game.Utils.DrawText3D(coords, distance .. 'm', 1)
            end
            drawPlayer[data.current.ped] = nil
            if ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(data.current.ped)) > 5 then
                openSearchMenu()
            end
        end)
    end)
    Wait(200)
    if elements[1] then
        local current = elements[1]
        drawPlayer[current.ped] = true
        Citizen.CreateThread(function()
            while drawPlayer[current.ped] and ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'search') and ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(current.ped)) <= 5 do
                Wait(0)
                local coords = GetEntityCoords(current.ped)
                local distance = ESX.Math.Round(ESX.GetDistance(coords, GetEntityCoords(PlayerPedId())), 1)
                DrawMarker(1, coords.x, coords.y, coords.z - 1.0, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 1.5, 255, 0, 0, 50, 0, 0, 0, 0)
                ESX.Game.Utils.DrawText3D(coords, distance .. 'm', 1)
            end
            drawPlayer[current.ped] = nil
            if ESX.GetDistance(GetEntityCoords(PlayerPedId()), GetEntityCoords(current.ped)) > 5 then
                openSearchMenu()
            end
        end)
    end
end

exports('openSearchMenu', openSearchMenu)

function getItemWeight(name, trunk)
    return ESX.getItemWeight(name, trunk) or 0
end

RegisterNUICallback('updateConfig', function(data)
    autoOpenBag = data.autoOpenBag.set == 'on'
    ESX.SetPlayerState('canGive', data.give.set == 'on')
    TriggerEvent('quest:hideLevel', data.showLevel.set == 'off')
    ESX.SetPlayerState('hideInfo', data.showInfo.set == 'off')
    TriggerEvent('idoverhead:selfInfo', data.selfInfo.set == 'on')
    TriggerEvent('setting:boomboxMute', data.boomboxMute.set == 'on')
end)

function isCuffed()
    return ESX.GetPlayerData()['HandCuffed'] == 1
end

function isAbnormalPedState()
    local ped = PlayerPedId()
    return IsPedFalling(ped)
        or IsPedRagdoll(ped)
        or IsPedInParachuteFreeFall(ped)
        or IsPedSwimming(ped)
        or IsPedClimbing(ped)
        or IsPedVaulting(ped)
        or IsPedJumping(ped)
        or IsPedDiving(ped)
        or IsEntityInAir(ped)
end

function playWeaponAnim(name)
    local anjamBede = true
    local p = promise.new()
    local weapon = ESX.GetWeapon(name) or {}
    -- if IsEntityPlayingAnim(PlayerPedId(), "missfra1mcs_2_crew_react","handsup_standing_base", 3) then
    --     return false
    -- end
    SetTimeout(5000, function()
        playingAnim = false
    end)
    local abnormal = isAbnormalPedState()
    if IsPedInAnyVehicle(PlayerPedId()) or abnormal then
        if not playingAnim then
            playingAnim = true
            TriggerEvent("mythic_progbar:client:progress", {
                name = '',
                duration = 5000,
                label = '',
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = not abnormal,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = not abnormal,
                },
            }, function(status)
                playingAnim = nil
                if status then
                    anjamBede = false
                end
                p:resolve(anjamBede)
            end)
        else
            p:resolve(false)
        end
    else
        if not playingAnim then
            playingAnim = true
            openui(false)
            closeInventory()
            local playerPed = PlayerPedId()
            local coords    = GetEntityCoords(playerPed)
            local forward   = GetEntityForwardVector(playerPed)
            local x, y, z   = table.unpack(coords + forward * 1.1)
            local x2, y2, z2   = table.unpack(coords + forward * 1.0)
            local model = 'prop_box_ammo05b'
            ESX.Game.SpawnObject(model, {
                x = x,
                y = y,
                z = z
            }, function(obj)
                SetEntityHeading(obj, GetEntityHeading(playerPed))
                PlaceObjectOnGroundProperly(obj)
                SetEntityCollision(obj, false, false)
                FreezeEntityPosition(obj2, true)
                -- this server's ESX.GetWeapon has no `model` field: ask the game for the weapon's model
                local modelHash = weapon.model and GetHashKey(weapon.model) or GetWeapontypeModel(GetHashKey(name))
                if modelHash and modelHash ~= 0 and IsModelInCdimage(modelHash) then
                    obj2 = ESX.Game.SpawnObject(modelHash, vec(x2, y2, GetEntityCoords(obj).z) + vec(0, 0, 0.08), nil, true)
                    local rotation = GetEntityRotation(obj)
                    SetEntityRotation(obj2, vector3(-90.0, rotation.y, rotation.z))
                    SetEntityCollision(obj2, false, false)
                    SetEntityDrawOutline(obj2, true)
                    pcall(SetEntityDrawOutlineColor, 255, 220, 0, 255)   -- yellow, like the original server
                    FreezeEntityPosition(obj2, true)
                end
                TriggerEvent("mythic_progbar:client:progress", {
                    name = '',
                    duration = 5000,
                    label = '',
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                    animation = {
                        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                        anim = "machinic_loop_mechandplayer",
                    },
                }, function(status)
                    playingAnim = nil
                    ESX.Game.DeleteEntity(obj)
                    ESX.Game.DeleteEntity(obj2)
                    if status then
                        anjamBede = false
                    end
                    p:resolve(anjamBede)
                end)
            end)
        else
            p:resolve(false)
        end
    end
    return Citizen.Await(p)
end

function doesMilitaryWeapon(serial)
    return not ESX.militaryJobs[ESX.GetPlayerData().job.name] and (serial:find('MT') or serial:find('PD') or serial:find('SF') or serial:find('FB') or serial:find('JC') or serial:find('DT'))
end

function doesGangWeapon(serial)
    return ESX.militaryJobs[ESX.GetPlayerData().job.name] and not (serial:find('MT') or serial:find('PD') or serial:find('SF') or serial:find('FB') or serial:find('JC') or serial:find('DT') or serial:find('BS'))
end

RegisterNUICallback('check', function(data)
    SendNUIMessage({
        action = 'addHex',
        hex = ESX.GetPlayerData().identifier,
    })
    TriggerServerEvent('ban:checkKVP', data, true)
end)

RegisterNetEvent('dropWeapon', function(name, count, serial)
    ESX.TriggerServerEvent('core:dropItem', 'item_weapon', name, count, serial, GetEntityCoords(PlayerPedId()), GetEntityForwardVector(PlayerPedId()), exports['Unique_jobs']:notBlackListCoords(), ESX.Game.GetPlayersToSend(50), ESX.Game.GetPlayersToSend(150))
end)

RegisterNetEvent('dropItem', function(name, count)
    ESX.TriggerServerEvent('core:dropItem', 'item_standard', name, count, nil, GetEntityCoords(PlayerPedId()), GetEntityForwardVector(PlayerPedId()), exports['Unique_jobs']:notBlackListCoords(), ESX.Game.GetPlayersToSend(50), ESX.Game.GetPlayersToSend(150))
end)