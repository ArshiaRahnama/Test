ESX = exports['essentialmode']:getSharedObject()

local Pickups = {}
local PickupId = 0
local Stashes = {}
local Searches = {}

ESX.RegisterServerCallback('IRV-inventory:getInventory', function(source, cb)
    cb(PlayerInventoryData(ESX.GetPlayerFromId(source)))
end)

AddEventHandler('esx:playerLoaded', function(src, xPlayer)
    TriggerClientEvent('IRV-inventory:loadPickups', src, Pickups)
end)

RegisterNetEvent('IRV-inventory:restoreLoadout', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    TriggerClientEvent('IRV-inventory:restoreLoadout', src, xPlayer.inventory)
end)

RegisterNetEvent('IRV-inventory:restoreEquiped', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local slots = {5,6,7}
    for i=1, #slots, 1 do
        local euiped = IsSlotEquiped(xPlayer.inventory, slots[i])
        if euiped then
            EquipItem(src, xPlayer.inventory[euiped], true)
        end
    end
end)

RegisterNetEvent('IRV-inventory:dropItem', function(data)
	local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    local index = data.index
    local count = data.count
    local coords = data.coords

    local item = xPlayer.inventory[index]

    if xPlayer.inventory[index].equiped then
        TriggerClientEvent('esx:showNotification', src, 'Item Shoma Equip Shode Ast', 'error')
        return
    end

    if xPlayer.removeInventoryItem(item.name, count, index) then
        TriggerClientEvent('IRV-inventory:pickupAnim', src)
        SetTimeout(2000, function()
            local pickupLabel = ('%s [~g~%s~w~]'):format(ESX.Items[item.name].label, count)
            CreatePickup(item, count, pickupLabel, ESX.Items[item.name].canPickup or false, coords)
        end)
    end
end)

RegisterNetEvent('IRV-inventory:onPickup', function(id)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local pickup = Pickups[id]
	if pickup then
        if pickup.canPickup then
            if pickup.item.name == 'bag' and pickup.item.info.bagid then
                local identifier = 'stash-'..pickup.item.info.bagid
                if Stashes[identifier] then
                    local weight = Stashes[identifier].weight
                    if weight > ESX.Items[pickup.item.name].weight then
                        pickup.item.weight = Stashes[identifier].initial
                    else
                        pickup.item.weight = ESX.Items[pickup.item.name].weight
                    end
                    TriggerClientEvent('IRV-inventory:closeInventory', src, identifier)
                end
            end
        end
		if xPlayer.addInventoryItem(pickup.item.name, pickup.count, nil, pickup.item.info, pickup.item.weight) then
			TriggerClientEvent('IRV-inventory:removePickup', -1, id)
			Pickups[id]	= nil
		else
			TriggerClientEvent('esx:showNotification', src, 'Shoma Fazaye Khali Nadarid', 'error')
		end
	end
end)

RegisterNetEvent('IRV-inventory:itemAction', function(index, key, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if key == 'use' then
        if index then
            if IsSlotEquiped(xPlayer.inventory, ESX.Items[xPlayer.inventory[index].name].eligableIndex) then
                return
            end
            xPlayer.inventory[index].equiped = ESX.Items[xPlayer.inventory[index].name].eligableIndex
            xPlayer.setInventoryItem(xPlayer.inventory)
            EquipItem(src, xPlayer.inventory[index], true)
        end
    elseif key == 'unuse' then
        if index then
            xPlayer.inventory[index].equiped = false
            xPlayer.setInventoryItem(xPlayer.inventory)
            EquipItem(src, xPlayer.inventory[index], false)
        end
    end
end)

RegisterNetEvent('IRV-inventory:NoMask', function(index)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.inventory[index].equiped = false
    xPlayer.setInventoryItem(xPlayer.inventory)
    SetTimeout(250, function()
        TriggerClientEvent('IRV-inventory:refreshInventory', src, PlayerInventoryData(ESX.GetPlayerFromId(src)), false)
    end)
end)

RegisterNetEvent('IRV-inventory:addMask', function(gender, model, texture)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.addInventoryItem('mask', 1, nil, {gender=gender,model=model,texture=texture})
end)

RegisterNetEvent('IRV-inventory:equipWeapon', function(index, equipIndex)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if IsSlotEquiped(xPlayer.inventory, equipIndex) then
        return
    end
    xPlayer.inventory[index].equiped = equipIndex
    xPlayer.setInventoryItem(xPlayer.inventory)
    TriggerClientEvent('IRV-inventory:addWeapon', src, xPlayer.inventory[index])
    SetTimeout(250, function()
        TriggerClientEvent('IRV-inventory:refreshInventory', src, PlayerInventoryData(ESX.GetPlayerFromId(src)), false)
    end)
end)

RegisterNetEvent('IRV-inventory:unEquipWeapon', function(index)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.inventory[index].equiped = false
    xPlayer.setInventoryItem(xPlayer.inventory)
    TriggerClientEvent('IRV-inventory:removeWeapon', src, xPlayer.inventory[index])
    SetTimeout(250, function()
        TriggerClientEvent('IRV-inventory:refreshInventory', src, PlayerInventoryData(ESX.GetPlayerFromId(src)), false)
    end)
end)

RegisterNetEvent('IRV-inventory:useAmmo', function(weaponIndex, itemIndex)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local weapon = xPlayer.inventory[weaponIndex]
    local item = xPlayer.inventory[itemIndex]
    if item.name == ESX.Items[weapon.name].ammo then
        local count = item.count
        local maxAmmo = ESX.Items[weapon.name].maxAmmo
        if weapon.info.ammo + count > maxAmmo then
            local must = (weapon.info.ammo + count) - maxAmmo
            count = count - must
        end
        local afterMinus = item.count - count
        if afterMinus > 0 then
            xPlayer.inventory[itemIndex].count = afterMinus
        else
            xPlayer.inventory[itemIndex] = nil
        end
        if weapon.equiped then
            xPlayer.setInventoryItem(xPlayer.inventory)
            SetTimeout(250, function()
                TriggerClientEvent('IRV-inventory:useAmmo', src, weapon.name, count)
                TriggerClientEvent('IRV-inventory:refreshInventory', src, PlayerInventoryData(xPlayer), false)
            end)
        else
            xPlayer.inventory[weaponIndex].info.ammo = weapon.info.ammo + count
            xPlayer.setInventoryItem(xPlayer.inventory)
            TriggerClientEvent('IRV-inventory:refreshInventory', src, PlayerInventoryData(xPlayer), false)
        end
    else
        TriggerClientEvent('esx:showNotification', src, ESX.Items[weapon.name].label..' Az Bullet type '..ESX.Items[item.name].label..' Poshtibani Nemikonad', 'error')
    end
end)

RegisterNetEvent('IRV-inventory:unloadAmmo', function(weapon, numAmmo)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local item = xPlayer.inventory[weapon.index]
    if item then
        local ammoType = ESX.Items[item.name].ammo
        if numAmmo > 0 then
            if item.info.ammo >= numAmmo then
                local newAmmo = item.info.ammo - numAmmo
                xPlayer.inventory[weapon.index].info.ammo = newAmmo
                xPlayer.setInventoryItem(xPlayer.inventory)
                SetTimeout(250, function()
                    TriggerClientEvent('IRV-inventory:setAmmo', src, weapon.name, newAmmo)
                    ESX.GetPlayerFromId(src).addInventoryItem(ammoType, numAmmo)
                end)
            else
                TriggerClientEvent('esx:showNotification', src, 'Shoma Be Meghdar Kafi Bullet Nadarid', 'error')
            end
        end
    end
end)

RegisterNetEvent('IRV-inventory:updateLoadout', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local changed = false
    for i=1, #data, 1 do
        if xPlayer.inventory[data[i].index].equiped then
            changed = true
            xPlayer.inventory[data[i].index].info.ammo = data[i].ammo
        end
    end
    if changed then
        xPlayer.setInventoryItem(xPlayer.inventory)
    end
end)

RegisterNetEvent('IRV-inventory:toggleComponent', function(index, component)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local weapon = xPlayer.inventory[index]
    if weapon and weapon.equiped then
        local has = false
        for i=1, #xPlayer.inventory[index].info.components, 1 do
            if xPlayer.inventory[index].info.components[i] == component then
                has = true
                table.remove(xPlayer.inventory[index].info.components, i)
                break
            end
        end
        if not has then
            table.insert(xPlayer.inventory[index].info.components, component)
        end
        xPlayer.setInventoryItem(xPlayer.inventory)
        SetTimeout(250, function()
            if has then
                TriggerClientEvent('IRV-inventory:removeWeaponComponent', src, string.upper(weapon.name), component)
                ESX.GetPlayerFromId(src).addInventoryItem(component, 1)
            else
                TriggerClientEvent('IRV-inventory:addWeaponComponent', src, string.upper(weapon.name), component)
                ESX.GetPlayerFromId(src).removeInventoryItem(component, 1)
            end
            TriggerClientEvent('IRV-inventory:refreshInventory', src, PlayerInventoryData(ESX.GetPlayerFromId(src)), false)
        end)
    end
end)

RegisterNetEvent('IRV-inventory:equipTint', function(index, tintName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local weapon = xPlayer.inventory[index]
    if weapon and weapon.equiped then
        if weapon.info.tint then
            TriggerClientEvent('esx:showNotification', src, 'Aslahe Shoma Tint Darad', 'error')
        else
            local tint = nil
            for i=1,7,1 do
                if Config.tintsIndex[i] and Config.tintsIndex[i] == tintName then
                    tint = i
                    break
                end
            end
            if tint then
                xPlayer.inventory[index].info.tint = tint
                xPlayer.setInventoryItem(xPlayer.inventory)
                SetTimeout(250, function()
                    TriggerClientEvent('IRV-inventory:setWeaponTint', src, string.upper(weapon.name), tint)
                    ESX.GetPlayerFromId(src).removeInventoryItem(tintName, 1)
                    TriggerClientEvent('IRV-inventory:refreshInventory', src, PlayerInventoryData(ESX.GetPlayerFromId(src)), false)
                end)
            end
        end
    end
end)

RegisterNetEvent('IRV-inventory:unEquipTint', function(index)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local weapon = xPlayer.inventory[index]
    if weapon and weapon.equiped then
        if weapon.info.tint then
            local tintName = Config.tintsIndex[weapon.info.tint]
            if tintName then
                xPlayer.inventory[index].info.tint = false
                xPlayer.setInventoryItem(xPlayer.inventory)
                SetTimeout(250, function()
                    TriggerClientEvent('IRV-inventory:setWeaponTint', src, string.upper(weapon.name), 0)
                    ESX.GetPlayerFromId(src).addInventoryItem(tintName, 1)
                    TriggerClientEvent('IRV-inventory:refreshInventory', src, PlayerInventoryData(ESX.GetPlayerFromId(src)), false)
                end)
            end
        else
            TriggerClientEvent('esx:showNotification', src, 'Aslahe Shoma Tint Nadarad', 'error')
        end
    end
end)

RegisterNetEvent('IRV-inventory:giveItem', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local Target = ESX.GetPlayerFromId(data.target)
    if Target then
        if data.type == 'item_money' then
            if xPlayer.money >= data.count then
                xPlayer.removeMoney(data.count)
                Target.addMoney(data.count)
                TriggerClientEvent("IRV-inventory:giveAnimation", src)
                TriggerClientEvent("IRV-inventory:giveAnimation", data.target)
                TriggerClientEvent('esx:showNotification', src, 'Shoma '..data.count..'$ be Player ('..data.target..') dadid', 'sucess')
                TriggerClientEvent('esx:showNotification', data.target, 'Shoma '..data.count..'$ az Player ('..src..') daryaft kardid', 'sucess')
            else
                TriggerClientEvent('esx:showNotification', src, 'Shoma Pool Kafi Nadarid', 'error')
            end
        else
            local item = xPlayer.inventory[data.index]
            if item.equiped then
                TriggerClientEvent('esx:showNotification', src, 'Item Shoma Equip Shode Ast', 'error')
                return
            end
            if data.count <= item.count then
                if xPlayer.removeInventoryItem(item.name, data.count, data.index) then
                    if Target.addInventoryItem(item.name, data.count, nil, item.info, item.weight) then
                        TriggerClientEvent("IRV-inventory:giveAnimation", src)
                        TriggerClientEvent("IRV-inventory:giveAnimation", data.target)
                    else
                        xPlayer.addInventoryItem(item.name, data.count, data.index, item.info, item.weight)
                        TriggerClientEvent('esx:showNotification', src, 'Inventory Fard Moghabel Full Ast', 'error')
                        TriggerClientEvent('esx:showNotification', data.target, 'Inventory Shoma Por Ast', 'error')
                    end
                else
                    TriggerClientEvent('esx:showNotification', src,  "You do not have enough of the item", "error")
                end
            else
                TriggerClientEvent('esx:showNotification', src, "Shoma Item Kafi Nadarid", 'error')
            end
        end
    else
        TriggerClientEvent('esx:showNotification', src, 'Player Mored Nazar Online Nist', 'error')
    end
end)

RegisterNetEvent('IRV-inventory:openBag', function(id)
    local src = source
    if Pickups[id] then
        TriggerClientEvent('IRV-inventory:openBag', src, Pickups[id].item)
    else
        TriggerClientEvent('IRV-inventory:openBag', src, false)
    end
end)

RegisterNetEvent('IRV-inventory:openSide', function(name, id, maxWeight, slot, reduction, label)
	local src = source
    if name and id then
        local secondInv = {}
        if name == "stash" then
            local ped = GetPlayerPed(src)
            local coords = GetEntityCoords(ped)
            local identifier = "stash-"..id
            if Stashes[identifier] then
                secondInv = Stashes[identifier]
            else
                secondInv.name = identifier
                secondInv.label = label or id
                secondInv.maxWeight = maxWeight or 50
                secondInv.weight = 0
                secondInv.slot = slot or 24
                secondInv.reduction = reduction or 0
                secondInv.inventory = {}
                secondInv.action = 'IRV-inventory:stashAction'
                secondInv.type = name
                secondInv.busy = false
                local stashItems = GetStash(identifier)
                if next(stashItems) then
                    secondInv.inventory = stashItems
                    secondInv.weight = ESX.GetTotalWeight(stashItems)
                end
                secondInv.initial = math.ceil(secondInv.weight * (100 - secondInv.reduction) / 100)
                Stashes[identifier] = secondInv
            end
            secondInv.handle = vector3(coords.x, coords.y, coords.z)
        elseif name == "trunk" then
            local vehicle = NetworkGetEntityFromNetworkId(id)
            if not vehicle and not DoesEntityExist(vehicle) then
                return
            end
            local plate = GetVehicleNumberPlateText(vehicle)
            local identifier = "trunk-"..plate
            if Stashes[identifier] then
                secondInv = Stashes[identifier]
            else
                secondInv.name = identifier
                secondInv.label = 'Trunk '..plate
                secondInv.maxWeight = maxWeight or 50
                secondInv.weight = 0
                secondInv.slot = slot or 24
                secondInv.reduction = 0
                secondInv.inventory = {}
                secondInv.action = 'IRV-inventory:stashAction'
                secondInv.type = name
                secondInv.busy = false
                local stashItems = GetStash(identifier)
                if next(stashItems) then
                    secondInv.inventory = stashItems
                    secondInv.weight = ESX.GetTotalWeight(stashItems)
                end
                if not IsVehicleOwned(plate) then
                    secondInv.dontSave = true
                end
                Stashes[identifier] = secondInv
            end
            secondInv.handle = id
        elseif name == "frisk" then
            local Target = ESX.GetPlayerFromId(id)
            if Target then
                secondInv = GetSearchedInventory(id, Target)
            else
                TriggerClientEvent('esx:showNotification', src, 'Player Mored Nazar Online Nist', 'error')
                return
            end
        end
        TriggerClientEvent("IRV-inventory:openInventory", src, secondInv)
    end
end)

RegisterNetEvent('IRV-inventory:stashAction', function(id, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local Done = false
    local index = data.index
    local count = data.count
    local stash = Stashes[id].inventory
    if Stashes[id].busy then
        TriggerClientEvent('esx:showNotification', src, 'Lotfan Spam Nakonid', 'error')
        TriggerClientEvent('IRV-inventory:refreshInventory', -1, nil, Stashes[id])
        return
    end
    if data.action == 'put' then
        local item = xPlayer.inventory[index]
        if not item then
            TriggerClientEvent('IRV-inventory:refreshInventory', -1, nil, Stashes[id])
            return
        end
        local itemInfo = ESX.Items[item.name]
        if not itemInfo then
            TriggerClientEvent('IRV-inventory:refreshInventory', -1, nil, Stashes[id])
            return
        end
        Stashes[id].busy = true
        if itemInfo.type == 'item_weapon' then
            count = 1
        end
        if item.equiped then
            TriggerClientEvent('esx:showNotification', src, 'Item Shoma Equip Shode Ast', 'error')
            TriggerClientEvent('IRV-inventory:refreshInventory', -1, nil, Stashes[id])
            Stashes[id].busy = false
            return
        end
        if (Stashes[id].weight + (item.weight * count)) <= Stashes[id].maxWeight then
            local slot = ESX.GetFirstSlotByItem(stash, itemInfo.name)
            if slot and stash[slot] and (stash[slot].name == itemInfo.name and not itemInfo.unique) then
                stash[slot].count = stash[slot].count + count
                Done = true
            else
                for i = 1, Stashes[id].slot, 1 do
                    if stash[i] == nil then
                        stash[i] = {name = itemInfo.name, count = count, info = item.info, slot = i, weight = item.weight}
                        Done = true
                        break
                    end
                end
            end
        end
        if Done then
            if xPlayer.removeInventoryItem(item.name, count, index) then
                Stashes[id].inventory = stash
                SaveStash(id, Stashes[id].inventory)
                Stashes[id].weight = ESX.GetTotalWeight(Stashes[id].inventory)
                Stashes[id].initial = math.ceil(Stashes[id].weight * (100 - Stashes[id].reduction) / 100)
            end
        end
    elseif data.action == 'get' then
        local item = stash[index]
        if not item then
            TriggerClientEvent('IRV-inventory:refreshInventory', -1, nil, Stashes[id])
            return
        end
        local itemInfo = ESX.Items[item.name]
        if not itemInfo then
            TriggerClientEvent('IRV-inventory:refreshInventory', -1, nil, Stashes[id])
            return
        end
        Stashes[id].busy = true
        if itemInfo.type == 'item_weapon' then
            count = 1
        end
        if stash[index].count > count then
            stash[index].count = stash[index].count - count
            Done = true
        elseif stash[index].count == count then
            stash[index] = nil
            Done = true
        end
        if Done then
            if xPlayer.addInventoryItem(item.name, count, item.slot, item.info, item.weight) then
                Stashes[id].inventory = stash
                SaveStash(id, Stashes[id].inventory)
                Stashes[id].weight = ESX.GetTotalWeight(Stashes[id].inventory)
                Stashes[id].initial = math.ceil(Stashes[id].weight * (100 - Stashes[id].reduction) / 100)
            end
        end
    end
    TriggerClientEvent('IRV-inventory:refreshInventory', -1, nil, Stashes[id])
    Stashes[id].busy = false
end)

RegisterNetEvent('IRV-inventory:friskAction', function(id, data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local Target = ESX.GetPlayerFromId(id)
    local index = data.index
    local count = data.count
    if not Target then
        TriggerClientEvent('esx:showNotification', src, 'Player Mored Nazar Online Nist', 'error')
        TriggerClientEvent('IRV-inventory:closeInventory', -1, id)
        if Searches[id] then
            Searches[id] = nil
        end
        return
    end
    if Searches[id] then
        TriggerClientEvent('esx:showNotification', src, 'Lotfan Spam Nakonid', 'error')
        TriggerClientEvent('IRV-inventory:refreshInventory', -1, nil, GetSearchedInventory(id, Target))
        return
    end
    if data.action == 'put' then
        local item = xPlayer.inventory[index]
        if not item then
            TriggerClientEvent('IRV-inventory:refreshInventory', -1, nil, GetSearchedInventory(id, Target))
            return
        end
        local itemInfo = ESX.Items[item.name]
        if not itemInfo then
            TriggerClientEvent('IRV-inventory:refreshInventory', -1, nil, GetSearchedInventory(id, Target))
            return
        end
        Searches[id] = true
        if itemInfo.type == 'item_weapon' then
            count = 1
        end
        if xPlayer.removeInventoryItem(item.name, count, item.slot) then
            if item.equiped then
                if itemInfo.type == 'item_weapon' then
                    TriggerClientEvent('IRV-inventory:removeWeapon', src, item)
                else
                    EquipItem(src, item, false)
                end
            end
            if not Target.addInventoryItem(item.name, count, nil, item.info, item.weight) then
                xPlayer.addInventoryItem(item.name, count, item.slot, item.info, item.weight)
            end
        end
    elseif data.action == 'get' then
        if not index then
            Searches[id] = true
            if Target.money >= count then
                Target.removeMoney(data.count)
                xPlayer.addMoney(data.count)
            end
        else
            local item = Target.inventory[index]
            if not item then
                TriggerClientEvent('IRV-inventory:refreshInventory', -1, nil, GetSearchedInventory(id, Target))
                return
            end
            local itemInfo = ESX.Items[item.name]
            if not itemInfo then
                TriggerClientEvent('IRV-inventory:refreshInventory', -1, nil, GetSearchedInventory(id, Target))
                return
            end
            Searches[id] = true
            if itemInfo.type == 'item_weapon' then
                count = 1
            end
            if Target.removeInventoryItem(item.name, count, item.slot) then
                if item.equiped then
                    if itemInfo.type == 'item_weapon' then
                        TriggerClientEvent('IRV-inventory:removeWeapon', id, item)
                    else
                        EquipItem(id, item, false)
                    end
                end
                if not xPlayer.addInventoryItem(item.name, count, nil, item.info, item.weight) then
                    Target.addInventoryItem(item.name, count, item.slot, item.info, item.weight)
                end
            end
        end
    end
    TriggerClientEvent('IRV-inventory:refreshInventory', -1, nil, GetSearchedInventory(id, ESX.GetPlayerFromId(id)))
    Searches[id] = nil
end)

function EquipItem(src, item, state)
    if item.name == 'mask' then
        TriggerClientEvent('IRV-inventory:ToggleMask', src, state, item)
    elseif item.name == 'radio' then
        TriggerClientEvent('IRV-inventory:ToggleRadio', src, state)
    elseif ESX.Items[item.name].eligableIndex and ESX.Items[item.name].eligableIndex == 6 then
        TriggerClientEvent('IRV-inventory:TogglePhone', src, state)
    end
end

function PlayerInventoryData(xPlayer)
    return {inventory = xPlayer.inventory, money = xPlayer.money, weight = ESX.GetTotalWeight(xPlayer.inventory), maxWeight = ESX.maxWeight, slot = 24, job = xPlayer.job.name}
end

function IsSlotEquiped(items, slot)
    for i=1, 24, 1 do
        if items[i] then
            if items[i].equiped == slot then
                return i
            end
        end
    end
    return nil
end
exports('IsSlotEquiped', IsSlotEquiped)

function GetSearchedInventory(id, Target)
    local TgInv = {}
    TgInv.name = id
    TgInv.maxWeight = ESX.maxWeight
    TgInv.slot = 25
    TgInv.reduction = 0
    TgInv.action = 'IRV-inventory:friskAction'
    TgInv.inventory = Target.inventory
    TgInv.money = Target.money
    TgInv.job = Target.job.name
    TgInv.type = 'player'
    TgInv.weight = ESX.GetTotalWeight(Target.inventory)
    TgInv.handle = id
    return TgInv
end

function GetStash(stashId)
	local items = {}
	local result = MySQL.Sync.fetchScalar('SELECT inventory FROM stashs WHERE stash = ?', {stashId})
	if result then
		local Items = json.decode(result)
		if Items then
			for k, item in pairs(Items) do
				local itemInfo = ESX.Items[item.name:lower()]
				if itemInfo then
					items[item.slot] = {
						name = item.name,
						count = tonumber(item.count),
						slot = item.slot,
                        info = item.info or {},
                        weight = item.weight or itemInfo.weight
					}
				end
			end
		end
	end
	return items
end

function SaveStash(stashId, inventory)
    if Stashes[stashId].dontSave then return end
    if inventory then
        MySQL.Async.insert('INSERT INTO stashs (stash, inventory) VALUES (:stash, :inventory) ON DUPLICATE KEY UPDATE inventory = :inventory', {
            ['stash'] = stashId,
            ['inventory'] = json.encode(inventory)
        })
    end
end

function IsVehicleOwned(plate)
    local result = MySQL.Sync.fetchScalar('SELECT 1 from owned_vehicles WHERE plate = ?', {plate})
    if result then return true else return false end
end

function CreatePickup(item, count, label, canPickup, coords)
	local pickupId = (PickupId == 65635 and 0 or PickupId + 1)
    local object = Config.Objects[item.name] or 'prop_money_bag_01'
	Pickups[pickupId] = {
		coords = coords,
        object = object,
		count = count,
		item = item,
        canPickup = canPickup,
        label = label
	}
	TriggerClientEvent('IRV-inventory:pickup', -1, pickupId, label, canPickup, object, coords)
	PickupId = pickupId
end

exports('HasItem', function(src, item, amount)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return false end
    local count = 0
    for i=1, 24, 1 do
        local slot = xPlayer.inventory[i]
        if slot then
            if slot.name == item then
                count = count + slot.count
            end
        end
    end
    if amount <= count then
        return true
    else
        return false
    end
end)