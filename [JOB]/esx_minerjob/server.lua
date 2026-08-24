ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local PLayersOnduty = {}
RegisterNetEvent('Miner:SetDuty')
AddEventHandler('Miner:SetDuty',function(status)
local xPlayer = ESX.GetPlayerFromId(source)
	PLayersOnduty[xPlayer.identifier] = status
end)
ESX.RegisterServerCallback('Miner:SetDuty', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	cb(PLayersOnduty[xPlayer.identifier])
end)
function MineManager()
	local self = {}
	self.get = function(k)
		return self[k]
	end

	self.regen	= function()
		self.gold	= math.random(500, 600)
		self.iron		= math.random(400, 500)
		TriggerClientEvent('esx_miner:getPrice', -1, {
			{name = 'gold' 	, price = self.gold},
			{name = 'iron'  , price = self.iron},
		})
	end

	return self
end

function getInventoryWeight(inventory)
  local weight = 0
  local itemWeight = 0
  if inventory ~= nil then
    for i = 1, #inventory, 1 do
      if inventory[i] ~= nil then
        itemWeight = 1000
        weight = weight + (itemWeight * (inventory[i].count or 1))
      end
    end
  end
  return weight
end

function getTotalInventoryWeight(plate)
  local total
  TriggerEvent(
    "esx_trunk:getSharedDataStore",
    plate,
    function(store)
      local W_coffre = getInventoryWeight(store.get("coffre") or {})
     total = W_coffre
    end)
  return total
end

RegisterServerEvent('mining:PutStoneInVehicle')
AddEventHandler('mining:PutStoneInVehicle', function(plate, minerSkill)
	local count = 1
	if minerSkill == 100 then
		count = 2
	end

	local item = "stone"
	TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
		local found = false
		local coffre = (store.get("coffre") or {})

		for i = 1, #coffre, 1 do
			if coffre[i].name == item then
				coffre[i].count = coffre[i].count + count
				found = true
			end
		end
		if not found then
			table.insert(coffre, {
				name = item,
				count = count
			})
		end

		if (getTotalInventoryWeight(plate) + 1000 * count) > 300000 then
			TriggerClientEvent('esx:showNotification', source, 'Kamion Por Shode Be Mahal ShosteShu Sang Beravid!')
		else
			store.set("coffre", coffre)
			TriggerClientEvent('esx:showNotification', source,
				'~b~' .. count .. ' ~w~Sang Dakhele Kamion Gozashte Shod | Sang Haye Dakhele Mashin : ~b~' ..
				math.ceil(getTotalInventoryWeight(plate)/1000)
			)
			TriggerClientEvent("TaskSystem:FarmSang", source)
		end
	end)
end)

RegisterServerEvent('mining:SellStone')
AddEventHandler('mining:SellStone', function(plate)
	local Tedad = 0
	local Src = source
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
	local coffre = (store.get("coffre") or {})
		for i = 1, #coffre, 1 do
			if coffre[i].name == "stone_piece" then
				if coffre[i].count ~= nil then
					Tedad = coffre[i].count
				end
			end
		end
		if Tedad >= 20 then
			TriggerClientEvent('TaskSystem:FroshAjor', Src)
		end
	end)

	xPlayer.addMoney(Tedad*500)
	local poull = Tedad*500
	TriggerClientEvent('esx:showNotification', source, 'Shoma ~g~'..poull..'~w~ Pool Az Frosh Ajor Daryaft Kardid')
	TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
		local coffre = (store.get("coffre") or {})
		for i = 1, #coffre, 1 do
		  if coffre[i].name == "stone_piece" then
			if (coffre[i].count >= Tedad and Tedad > 0) then
			  if (coffre[i].count - Tedad) == 0 then
				table.remove(coffre, i)
			  else
				coffre[i].count = coffre[i].count - Tedad
			  end

			  break
			end
		  end
		end
		store.set("coffre", coffre)
		local blackMoney = 0
		local items = {}
		local weapons = {}
		weapons = {}
		local coffre = (store.get("coffre") or {})
		for i = 1, #coffre, 1 do
		  table.insert(items, {name = coffre[i].name, count = coffre[i].count, label = ESX.GetItemLabel(coffre[i].name)})
		end
		local weight = getTotalInventoryWeight(plate)
		text = "--"
		data = {plate = plate, max = 300000, myVeh = 0, text = text}
		TriggerClientEvent("esx_inventoryhud:refreshTrunkInventory", source, data, blackMoney, items, weapons)
	  end
	)
end)

RegisterServerEvent('mining:WashStonePieces')
AddEventHandler('mining:WashStonePieces', function(plate)

	local Tedad = 0
	local Src = source
	TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
	local coffre = (store.get("coffre") or {})

	for i = 1, #coffre, 1 do
		if coffre[i].name == "stone" then
			if coffre[i].count ~= nil then
				Tedad = coffre[i].count
			end
		end
	end

	if Tedad >=290 then
		TriggerClientEvent('TaskSystem:GharbaleSang', Src)

		exports['Unique_Skills']:UpdateSkill(Src, "Miner", 1.000)
	end

	end)
	if Tedad == 0 then return end
		TriggerClientEvent('mining:WashStonePieces_cl' , source )


		TriggerClientEvent("esx_miner:Gharbale", source)
	if Tedad >= 200 or Tedad <= 300 then
        TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
            local coffre = (store.get("coffre") or {})
            for i = 1, #coffre, 1 do
              if coffre[i].name == "stone" then
                if (coffre[i].count >= Tedad and Tedad > 0) then
                  if (coffre[i].count - Tedad) == 0 then
                    table.remove(coffre, i)
                  else
                    coffre[i].count = coffre[i].count - Tedad
                  end

                  break
                end
              end
            end
            store.set("coffre", coffre)
            local blackMoney = 0
            local items = {}
            local weapons = {}
            weapons = {}
            local coffre = (store.get("coffre") or {})
            for i = 1, #coffre, 1 do
              table.insert(items, {name = coffre[i].name, count = coffre[i].count, label = ESX.GetItemLabel(coffre[i].name)})
            end
            local weight = getTotalInventoryWeight(plate)
            text = "--"
            data = {plate = plate, max = 300000, myVeh = 0, text = text}
            TriggerClientEvent("esx_inventoryhud:refreshTrunkInventory", source, data, blackMoney, items, weapons)
          end
        )

	local count1 = math.random(5, 60)
	local count2 = math.random(5, 50)
	local count3 = math.random(5, 40)
	local count4 = math.random(0, 7)
	local random = math.random(1, 20)

	local item1 = "stone_piece"
	local item2 = "iron_piece"
	local item3 = "gold_piece"
	local item4 = "diamond"

	TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
		local found = false
		local coffre = (store.get("coffre") or {})
		for i = 1, #coffre, 1 do
			if coffre[i].name == item1 then
			coffre[i].count = coffre[i].count + count1
			found = true
			end
			if coffre[i].name == item2 then
			coffre[i].count = coffre[i].count + count2
			found = true
			end
			if coffre[i].name == item3 then
			coffre[i].count = coffre[i].count + count3
			found = true
			end

			if coffre[i].name == item4 then
			coffre[i].count = coffre[i].count + count4
			found = true
			end
		end
		if not found then
		  table.insert(
			coffre,
			{
			  name = item1,
			  count = count1
			}
		  )
		  table.insert(
			coffre,
			{
			  name = item2,
			  count = count2
			}
		  )
		  table.insert(
			coffre,
			{
			  name = item3,
			  count = count3
			}
		  )

			table.insert(
			coffre,
			{
				name = item4,
				count = count4
			}
			)

		end

		store.set("coffre", coffre)
		MySQL.Async.execute("UPDATE trunk_inventory SET owned = @owned WHERE plate = @plate", {["@plate"] = plate, ["@owned"] = owned })

    end)
	TriggerClientEvent("esx_miner:Gharbale", source)


	else
		if Tedad ~= 0 then
		TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
            local coffre = (store.get("coffre") or {})
            for i = 1, #coffre, 1 do
              if coffre[i].name == "stone" then
                if (coffre[i].count >= Tedad and Tedad > 0) then
                  if (coffre[i].count - Tedad) == 0 then
                    table.remove(coffre, i)
                  else
                    coffre[i].count = coffre[i].count - Tedad
                  end

                  break
                end
              end
            end
            store.set("coffre", coffre)
            local blackMoney = 0
            local items = {}
            local weapons = {}
            weapons = {}
            local coffre = (store.get("coffre") or {})
            for i = 1, #coffre, 1 do
              table.insert(items, {name = coffre[i].name, count = coffre[i].count, label = ESX.GetItemLabel(coffre[i].name)})
            end
            local weight = getTotalInventoryWeight(plate)
            text = "--"
            data = {plate = plate, max = 300000, myVeh = 0, text = text}
            TriggerClientEvent("esx_inventoryhud:refreshTrunkInventory", source, data, blackMoney, items, weapons)
          end
        )

	local count1 = math.random(5, 60)
	local count2 = math.random(5, 35)
	local count3 = math.random(5, 35)
	local count4 = math.random(0, 7)



	local item1 = "stone_piece"
	local item2 = "iron_piece"
	local item3 = "gold_piece"
	local item4 = "diamond"

	TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
		local found = false
		local coffre = (store.get("coffre") or {})
		for i = 1, #coffre, 1 do
		  if coffre[i].name == item1 then
			coffre[i].count = coffre[i].count + count1
			found = true
		  end
		  if coffre[i].name == item2 then
			coffre[i].count = coffre[i].count + count2
			found = true
		  end
		  if coffre[i].name == item3 then
			coffre[i].count = coffre[i].count + count3
			found = true
		  end
		  if coffre[i].name == item4 then
			coffre[i].count = coffre[i].count + count4
			found = true
		  end
		end
		if not found then
		    table.insert(
			coffre,
			{
			  name = item1,
			  count = count1
			}
		  )
		  table.insert(
			coffre,
			{
			  name = item2,
			  count = count2
			}
		  )
		  table.insert(
			coffre,
			{
			  name = item4,
			  count = count4
			}
		  )
		  table.insert(coffre, {name = item3, count = count3 })
			end
				store.set("coffre", coffre)
				MySQL.Async.execute("UPDATE trunk_inventory SET owned = @owned WHERE plate = @plate", {["@plate"] = plate, ["@owned"] = owned })
			end)
		end
	end
end)

RegisterServerEvent('mining:MeltItems')
AddEventHandler('mining:MeltItems', function(type)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem("washed_stone")
	if type == "gold_piece" then
        xPlayer.addInventoryItem('gold', 1)
		xPlayer.removeInventoryItem('gold_piece', 20)
	elseif type == "iron_piece" then
        xPlayer.addInventoryItem('iron', 1)
		xPlayer.removeInventoryItem('iron_piece', 20)
    end
end)



