ESX = nil
local saff = 0
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

-- SECURITY FIX: AH_uwucafejob:itemCrafted (below) used to grant the crafted
-- item/weapon purely on the (item, count) the CLIENT sent, with no check
-- that this player had actually gone through craft() and paid the
-- ingredients/tax first -- any player could TriggerServerEvent it directly
-- for a free item. This tracks what was legitimately started server-side so
-- itemCrafted can verify (and consume) it before granting anything.
local PendingCrafts = {} -- source -> { item = string, expiresAt = os.time() }

function setCraftingLevel(identifier, level)
	local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
	-- TriggerEvent("GangXPSystem:setXP", xPlayer.gang.name, level)
end

function getCraftingLevel(identifier)	
	local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
    -- return tonumber( MySQL.Sync.fetchScalar( "SELECT `XP` FROM gangs_data WHERE gang_name = @gang_name ", {["@gang_name"] = xPlayer.gang.name} ) )
	return 150
end

function getCraftingRank(identifier)	
	local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
    -- return tonumber( MySQL.Sync.fetchScalar( "SELECT `Level` FROM gangs_data WHERE gang_name = @gang_name ", {["@gang_name"] = xPlayer.gang.name}) )
	return 20
end

local tx = nil
local ty = nil
local tz = nil
ESX.RegisterServerCallback('coordscraft', function(source, cb, cx, cy, cz)
    salam = true 
    cb(salam)
    tx = cx
    ty = cy
    tz = cz


end)
local gangaccses = false


RegisterServerEvent('sendPlayerDataToServer')
AddEventHandler('sendPlayerDataToServer', function(permchek)
  
    gangaccses = permchek
    
    
end)


function craft(src, item, retrying)

  
	local xPlayer = ESX.GetPlayerFromId(src)

	local cancraft = true

	local count = ConfigCrafting.Recipes[item].Amount

	if not IsCafeJob(xPlayer.job.name) then
		return TriggerClientEvent('esx:showNotification', src, "Shoma Dastresi Az Estefade Az Crafting Ra Nadarid!")
	end

	if not retrying then
		for k, v in pairs(ConfigCrafting.Recipes[item].Ingredients) do
			if tonumber(xPlayer.getInventoryItem(k).count) < v then
				cancraft = false
			end
		end
		if ConfigCrafting.Recipes[item].Level > getCraftingRank(xPlayer.identifier) then
			return TriggerClientEvent('esx:showNotification', src, _U("no_access_bylevel"))
		end
	end

	if ConfigCrafting.Recipes[item].isGun then
		if cancraft then
			
		
			for k, v in pairs(ConfigCrafting.Recipes[item].Ingredients) do
				if not ConfigCrafting.PermanentItems[k] then
					xPlayer.removeInventoryItem(k, v)
				end
			end

			TriggerClientEvent("AH_uwucafejob:craftStart", src, item, count)
			PendingCrafts[src] = { item = item, expiresAt = os.time() + 120 }
			
			
		else
			TriggerClientEvent('esx:showNotification', src, _U("not_enough_ingredients"))
			-- TriggerClientEvent('okokNotify:Alert', src, "", _U("you_cant_hold_item"), 5000, 'warning')            
		end
	else
		if ConfigCrafting.UseLimitSystem then
			local xItem = xPlayer.getInventoryItem(item)

			-- if xItem.count + count <= xItem.limit then
				if cancraft then
                    if  saff <= 4 then
                        local Maliat = 2000
                        local RemoveMaliat = false
                        local xBank  = xPlayer.bank
                        local xMoney = xPlayer.money
                        if xMoney >= Maliat or xBank >= Maliat then 
                            TriggerEvent('esx_addonaccount:getSharedAccount', 'society_uwucafe', function(account)

                                if xMoney >= Maliat then 
                                    xPlayer.removeMoney(Maliat)
                                    account.addMoney(1500)
                                    RemoveMaliat = true
                                elseif xBank >= Maliat then 
                                    xPlayer.removeBank(Maliat)
                                    account.addMoney(1500)
                                    RemoveMaliat = true
                                else
                                    RemoveMaliat = false
                                end

                                if RemoveMaliat then 
                                    saff = saff + 1
                                    for k, v in pairs(ConfigCrafting.Recipes[item].Ingredients) do
                                        xPlayer.removeInventoryItem(k, v)
                                    end

                                    TriggerClientEvent("AH_uwucafejob:craftStart", src, item, count)
                                    PendingCrafts[src] = { item = item, expiresAt = os.time() + 120 }
                                else
                                    TriggerClientEvent('esx:showNotification', src, 'Shoma Pol Kafi Nadarid')
                                end
                            end)
                        else
                            TriggerClientEvent('esx:showNotification', src, 'Shoma Pol Kafi Nadarid')
                        end   
                    else
                        TriggerClientEvent('esx:showNotification', src, 'Shoma Bishtar Az 5 Item Nemitavanid Dar Saaf Bezarid')
                    end   
				else
					TriggerClientEvent('esx:showNotification', src, _U("not_enough_ingredients"))
				end
			-- else
				
			--     TriggerClientEvent("AH_uwucafejob:sendMessage", src, _U("you_cant_hold_item"))
			-- end
		else
			local xItem = xPlayer.getInventoryItem(item)

			if xItem.count + count <= xItem.limit then
				if cancraft then
					for k, v in pairs(ConfigCrafting.Recipes[item].Ingredients) do
						xPlayer.removeInventoryItem(k, v)
					end

					TriggerClientEvent("AH_uwucafejob:craftStart", src, item, count)
					PendingCrafts[src] = { item = item, expiresAt = os.time() + 120 }
				else
					TriggerClientEvent('esx:showNotification', src, _U("not_enough_ingredients"))
				end
			else
				-- TriggerClientEvent('okokNotify:Alert', src, "", _U("you_cant_hold_item"), 5000, 'warning')   
			end
		end
	end
   
end

RegisterServerEvent("AH_uwucafejob:itemCrafted")
AddEventHandler(
"AH_uwucafejob:itemCrafted",
function(item, count)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    -- SECURITY FIX: require a matching, unexpired pending craft (see
    -- PendingCrafts above) -- i.e. this player must have actually gone
    -- through craft() and paid for the ingredients -- before granting
    -- anything. Consumed on use so it can't be replayed.
    local pending = PendingCrafts[src]
    if not pending or pending.item ~= item or os.time() > pending.expiresAt then
        return
    end
    PendingCrafts[src] = nil

    if ConfigCrafting.Recipes[item].SuccessRate > math.random(0, ConfigCrafting.Recipes[item].SuccessRate) then
        if ConfigCrafting.UseLimitSystem then


            if ConfigCrafting.Recipes[item].isGun then
                local jibgan = true
                local weapon = xPlayer.loadout
                for t,r in pairs(weapon) do 
                    if r.name == item then 
                        jibgan = false
                        break 
                    else
                        jibgan = true
                        
                    end
                    
                end

                if jibgan then 
            
                    xPlayer.addWeapon(item, ConfigCrafting.Recipes[item].Amount)
                    
                else
                    local ammo =  ConfigCrafting.Recipes[item].Amount
                    local components = xPlayer.hasWeapon(item).components
                    local weaponLabel = ESX.GetWeaponLabel(item)
                    ESX.CreatePickupCrafting("item_weapon", string.upper(item), {ammo = ammo, components = components}, weaponLabel, tx, ty, tz)
                    TriggerClientEvent('esx:showNotification', src, _U("item_crafted"))
                end


            else

                local xItem = xPlayer.getInventoryItem(item)
                local itemcount = ConfigCrafting.Recipes[item].Amount

                if xItem.count + itemcount <= xItem.limit then
                    if not ConfigCrafting.Recipes[item].isGun then
                        xPlayer.addInventoryItem(item, ConfigCrafting.Recipes[item].Amount)
                        saff = saff - 1
                    end
                    TriggerClientEvent('esx:showNotification', src, _U("item_crafted"))
                    -- giveCraftingLevel(xPlayer.identifier, ConfigCrafting.ExperiancePerCraft)
                else
                    saff = saff - 1
                    ESX.CreatePickup("item_standard", xItem.name, itemcount, xItem.label, source)
                    -- TriggerEvent("AH_uwucafejob:craft", item, nil, src)
                    TriggerClientEvent('esx:showNotification', src, _U("inv_limit_exceed"))
                end
            end
        else
            if ConfigCrafting.Recipes[item].isGun then
				local xItem = xPlayer.getInventoryItem(item)

				if xItem.count + count <= xItem.limit then
					xPlayer.addWeapon(item, count)
					TriggerClientEvent('esx:showNotification', src, _U("item_crafted"))
					
				end
            else
				local xItem = xPlayer.getInventoryItem(item)
				local weight,slots = ESX.GetTotalWeight(xPlayer.inventory)
				if weight + xItem.weight <= ESX.maxWeight and slots < ESX.maxSlot and xItem.count + count <= xItem.limit then

                    xPlayer.addInventoryItem(item, count)
                    TriggerClientEvent('esx:showNotification', src, _U("item_crafted"))
                   
                else
                    TriggerClientEvent('esx:showNotification', src, _U("inv_limit_exceed"))
                end
            end
        end
    else
        TriggerClientEvent('esx:showNotification', src, _U("crafting_failed"))
    end
end
)

RegisterServerEvent("AH_uwucafejob:craft")
AddEventHandler(
    "AH_uwucafejob:craft",
    function(item, retrying)

        craft(source, item, retrying)
    end
)




ESX.RegisterServerCallback(
    "AH_uwucafejob:getXP",
    function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        cb(getCraftingLevel(xPlayer.identifier), getCraftingRank(xPlayer.identifier))
    end
)

ESX.RegisterServerCallback(
    "AH_uwucafejob:getItemNames",
    function(source, cb)
        local names = {}

        MySQL.Async.fetchAll(
            "SELECT * FROM items WHERE 1",
            {},
            function(info)
                for _, v in ipairs(info) do 
					names[v.name] = v.label
                end

                cb(names)
            end
        )
    end
)