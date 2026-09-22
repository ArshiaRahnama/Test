ESX = nil
local arrayWeight = TrunkConfig.localWeight
local VehicleList = {}
local VehicleInventory = {}

-- Glovebox rows are keyed "GLOVE:<plate>". Their capacity is enforced HERE:
-- the `max` argument comes from the client and can't be trusted.
local function clampMax(plate, max)
  local prefix = TrunkConfig.GlovePrefix
  if type(plate) == "string" and plate:sub(1, #prefix) == prefix then
    return TrunkConfig.GloveboxLimit
  end
  return max
end

local function normPlate(p)
  local s = tostring(p or ""):gsub("%s+", "")
  return s:upper()
end

local warnedNoVehicles = false

-- Server-side "are you really at this vehicle?" check. Before this, any
-- client could read/put/take from ANY vehicle's trunk by plate, from anywhere
-- on the map (the plate is just a string in the event). Now:
--   trunk    -> a vehicle with that plate must be within TrunkAccessDistance
--   glovebox -> a vehicle with that plate must be within GloveboxAccessDistance
--               (i.e. you are sitting in it)
-- Needs OneSync (GetAllVehicles). If it isn't available the check is skipped
-- (fail-open, with one console warning) so the trunk never breaks entirely.
-- Turn off with TrunkConfig.ServerProximityCheck = false.
local function canAccessStorage(src, key)
  if not TrunkConfig.ServerProximityCheck then return true end
  if type(key) ~= "string" or key == "" then return false end

  local prefix = TrunkConfig.GlovePrefix
  local isGlove = key:sub(1, #prefix) == prefix
  local want = normPlate(isGlove and key:sub(#prefix + 1) or key)
  if want == "" then return false end

  local ped = GetPlayerPed(src)
  if not ped or ped == 0 then return false end
  local pcoords = GetEntityCoords(ped)

  local ok, vehicles = pcall(GetAllVehicles)
  if not ok or type(vehicles) ~= "table" then
    if not warnedNoVehicles then
      warnedNoVehicles = true
      print("^3[Unique_inventory]^0 GetAllVehicles unavailable (OneSync off?) - trunk proximity check disabled")
    end
    return true
  end

  local maxDist = isGlove and TrunkConfig.GloveboxAccessDistance or TrunkConfig.TrunkAccessDistance
  for _, veh in ipairs(vehicles) do
    if normPlate(GetVehicleNumberPlateText(veh)) == want then
      if #(pcoords - GetEntityCoords(veh)) <= maxDist then
        return true
      end
    end
  end
  return false
end

local function tooFar(src)
  TriggerClientEvent("esx:showNotification", src, "You are too far from the vehicle")
end

TriggerEvent(
  "esx:getSharedObject",
  function(obj)
    ESX = obj
  end
)

-- FIX: 'onMySQLReady' is never fired by oxmysql's compat shim (only mysql-async
-- fired that event; oxmysql exposes readiness as MySQL.ready(cb) instead), so
-- this cleanup query never ran. Using the real readiness API now.
MySQL.ready(function()
    MySQL.Async.execute("DELETE FROM `trunk_inventory` WHERE `owned` = 0", {})
end)

RegisterServerEvent("esx_trunk_inventory:getOwnedVehicule")
AddEventHandler(
  "esx_trunk_inventory:getOwnedVehicule",
  function()
    local vehicules = {}
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    MySQL.Async.fetchAll(
      "SELECT * FROM owned_vehicles WHERE owner = @owner",
      {
        ["@owner"] = xPlayer.identifier
      },
      function(result)
        if result ~= nil and #result > 0 then
          for _, v in pairs(result) do
            local vehicle = json.decode(v.vehicle)
            table.insert(vehicules, {plate = vehicle.plate})
          end
        end
        TriggerClientEvent("esx_trunk_inventory:setOwnedVehicule", _source, vehicules)
      end
    )
  end
)

function getItemWeight(item)
  local weight = 0
  local itemWeight = 0
  if item ~= nil then
    itemWeight = TrunkConfig.DefaultWeight
    if arrayWeight[item] ~= nil then
      itemWeight = arrayWeight[item]
    end
  end
  return itemWeight
end

function getInventoryWeight(inventory)
  local weight = 0
  local itemWeight = 0
  if inventory ~= nil then
    for i = 1, #inventory, 1 do
      if inventory[i] ~= nil then
        itemWeight = TrunkConfig.DefaultWeight
        if arrayWeight[inventory[i].name] ~= nil then
          itemWeight = arrayWeight[inventory[i].name]
        end
        weight = weight + (itemWeight * (inventory[i].count or 1))
      end
    end
  end
  return weight
end

function getTotalInventoryWeight(plate)
  local total
  if not plate then
    return
  end
  TriggerEvent(
    "esx_trunk:getSharedDataStore",
    plate,
    function(store)
      local W_weapons = getInventoryWeight(store.get("weapons") or {})
      local W_coffre = getInventoryWeight(store.get("coffre") or {})
      local W_blackMoney = 0
      local blackAccount = (store.get("black_money")) or 0
      if blackAccount ~= 0 then
        W_blackMoney = blackAccount[1].amount / 10
      end
      total = W_weapons + W_coffre + W_blackMoney
    end
  )
  return total
end

RegisterServerCallbackSafe(
  "esx_trunk:getInventoryV",
  function(source, cb, plate)
    if not plate then
      return
    end
    if not canAccessStorage(source, plate) then
      tooFar(source)
      return cb({blackMoney = 0, items = {}, weapons = {}, weight = 0})
    end
    TriggerEvent(
      "esx_trunk:getSharedDataStore",
      plate,
      function(store)
        local blackMoney = 0
        local items = {}
        local weapons = {}
        weapons = (store.get("weapons") or {})

        

        local coffre = (store.get("coffre") or {})
        for i = 1, #coffre, 1 do
          -- peso = weight of ONE unit in kg. The NUI computes peso * count for the card;
          -- without it the card showed "NaNkg".
          table.insert(items, {name = coffre[i].name, count = coffre[i].count, label = ESX.GetItemLabel(coffre[i].name), filter = 'food', peso = getItemWeight(coffre[i].name) / 1000})
        end
       
        for k,v in pairs(weapons) do
          table.insert(items, {
            type = 'item_weapon',
            name = v.name,
            label = ESX.GetWeaponLabel(v.name),
            count = v.ammo,
            filter = 'arma',
            peso = getItemWeight(v.name) / 1000, -- a weapon weighs its own weight once (count = ammo)
            serial = v.serial or ''
          })
        end
      


        local weight = getTotalInventoryWeight(plate)
        cb(
          {
            blackMoney = blackMoney,
            items = items,
            weapons = weapons,
            weight = weight
          }
        )
      end
    )
  end
)



RegisterServerEvent("esx_trunk:getItem")
AddEventHandler(
  "esx_trunk:getItem",
  function(plate, type, item, count, max, owned, serial)
    local _source = source
    if serial == "" or serial == false then serial = nil end
    max = clampMax(plate, max)
    if not canAccessStorage(_source, plate) then return tooFar(_source) end
    count = tonumber(count) or 0
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not plate then
      return
    end
    if type == "item_standard" then
      local targetItem = xPlayer.getInventoryItem(item)
      if targetItem.limit == -1 or ((targetItem.count + count) <= targetItem.limit) then
        TriggerEvent(
          "esx_trunk:getSharedDataStore",
          plate,
          function(store)
            local coffre = (store.get("coffre") or {})
            for i = 1, #coffre, 1 do
              if coffre[i].name == item then
                if (coffre[i].count >= count and count > 0) then
                  xPlayer.addInventoryItem(item, count)
                  if (coffre[i].count - count) == 0 then
                    table.remove(coffre, i)
                  else
                    coffre[i].count = coffre[i].count - count
                  end

                  break
                else
                  TriggerClientEvent("esx:showNotification", _source, _U("invalid_quantity"))
                end
              end
            end

            store.set("coffre", coffre)

            local blackMoney = 0
            local items = {}
            local weapons = {}
            weapons = (store.get("weapons") or {})

            local blackAccount = (store.get("black_money")) or 0
            if blackAccount ~= 0 then
              blackMoney = blackAccount[1].amount
            end

            local coffre = (store.get("coffre") or {})
            for i = 1, #coffre, 1 do
              table.insert(items, {name = coffre[i].name, count = coffre[i].count, label = ESX.GetItemLabel(coffre[i].name)})
            end

            local weight = getTotalInventoryWeight(plate)

            text = _U("trunk_info", plate, (weight / 1000), (max / 1000))
            data = {plate = plate, max = max, myVeh = owned, text = text}
            TriggerClientEvent("esx_inventoryhud:refreshTrunkInventory", _source, data, blackMoney, items, weapons)
          end
        )
      else
        TriggerClientEvent("esx:showNotification", _source, _U("player_inv_no_space"))
      end
    end

    if type == "item_account" then
      TriggerEvent(
        "esx_trunk:getSharedDataStore",
        plate,
        function(store)
          local blackMoney = store.get("black_money")
          if (blackMoney[1].amount >= count and count > 0) then
            blackMoney[1].amount = blackMoney[1].amount - count
            store.set("black_money", blackMoney)
            xPlayer.addAccountMoney(item, count)

            local blackMoney = 0
            local items = {}
            local weapons = {}
            weapons = (store.get("weapons") or {})

            local blackAccount = (store.get("black_money")) or 0
            if blackAccount ~= 0 then
              blackMoney = blackAccount[1].amount
            end

            local coffre = (store.get("coffre") or {})
            for i = 1, #coffre, 1 do
              table.insert(items, {name = coffre[i].name, count = coffre[i].count, label = ESX.GetItemLabel(coffre[i].name)})
            end

            local weight = getTotalInventoryWeight(plate)

            text = _U("trunk_info", plate, (weight / 1000), (max / 1000))
            data = {plate = plate, max = max, myVeh = owned, text = text}
            TriggerClientEvent("esx_inventoryhud:refreshTrunkInventory", _source, data, blackMoney, items, weapons)
          else
            TriggerClientEvent("esx:showNotification", _source, _U("invalid_amount"))
          end
        end
      )
    end

    if type == "item_weapon" then
      TriggerEvent(
        "esx_trunk:getSharedDataStore",
        plate,
        function(store)
          local storeWeapons = store.get("weapons")

          if storeWeapons == nil then
            storeWeapons = {}
          end

          local weaponName, ammo, takenSerial = nil, nil, nil

          for i = 1, #storeWeapons, 1 do
            -- `serial` (from the UI) picks the exact copy when several are stored
            if storeWeapons[i].name == item and (not serial or storeWeapons[i].serial == serial) then
              weaponName = storeWeapons[i].name
              ammo = storeWeapons[i].ammo
              takenSerial = storeWeapons[i].serial -- keep the weapon's serial number
              table.remove(storeWeapons, i)

              break
            end
          end

          -- FIX: used to call addWeapon(nil, nil) (script error) when the
          -- weapon wasn't in the trunk.
          if not weaponName then return end

          store.set("weapons", storeWeapons)

          xPlayer.addWeapon(weaponName, ammo, takenSerial)

          local blackMoney = 0
          local items = {}
          local weapons = {}
          weapons = (store.get("weapons") or {})

          local blackAccount = (store.get("black_money")) or 0
          if blackAccount ~= 0 then
            blackMoney = blackAccount[1].amount
          end

          local coffre = (store.get("coffre") or {})
          for i = 1, #coffre, 1 do
            table.insert(items, {name = coffre[i].name, count = coffre[i].count, label = ESX.GetItemLabel(coffre[i].name)})
          end

          local weight = getTotalInventoryWeight(plate)

          text = _U("trunk_info", plate, (weight / 1000), (max / 1000))
          data = {plate = plate, max = max, myVeh = owned, text = text}
          TriggerClientEvent("esx_inventoryhud:refreshTrunkInventory", _source, data, blackMoney, items, weapons)
        end
      )
    end
  end
)

RegisterServerEvent("esx_trunk:putItem")
AddEventHandler(
  "esx_trunk:putItem",
  function(plate, type, item, count, max, owned, label, serial)
    local _source = source
    if serial == "" or serial == false then serial = nil end
    max = clampMax(plate, max)
    if not canAccessStorage(_source, plate) then return tooFar(_source) end
    count = tonumber(count) or 0
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)
    if not plate then
      return
    end
    if type == "item_standard" then
      local playerItemCount = xPlayer.getInventoryItem(item).count

      if (playerItemCount >= count and count > 0) then
        TriggerEvent(
          "esx_trunk:getSharedDataStore",
          plate,
          function(store)
            -- FIX (dupe): the old code raised coffre[i].count / inserted the
            -- item FIRST and checked the capacity afterwards. store.get()
            -- returns the live table, so when the trunk was full the player
            -- got "insufficient space" but the item was ALREADY in the store
            -- (and still in their pockets) - the next save persisted it.
            -- Check the capacity first; only then touch anything.
            if (getTotalInventoryWeight(plate) + (getItemWeight(item) * count)) > max then
              TriggerClientEvent("esx:showNotification", _source, _U("insufficient_space"))
              return
            end

            local found = false
            local coffre = (store.get("coffre") or {})

            for i = 1, #coffre, 1 do
              if coffre[i].name == item then
                coffre[i].count = coffre[i].count + count
                found = true
              end
            end
            if not found then
              table.insert(
                coffre,
                {
                  name = item,
                  count = count
                }
              )
            end

            -- Checks passed, storing the item.
            store.set("coffre", coffre)
            xPlayer.removeInventoryItem(item, count)

            MySQL.Async.execute(
              "UPDATE trunk_inventory SET owned = @owned WHERE plate = @plate",
              {
                ["@plate"] = plate,
                ["@owned"] = owned
              }
            )
          end
        )
      else
        TriggerClientEvent("esx:showNotification", _source, _U("invalid_quantity"))
      end
    end

    if type == "item_account" then
      local playerAccountMoney = xPlayer.getAccount(item).money

      if (playerAccountMoney >= count and count > 0) then
        TriggerEvent(
          "esx_trunk:getSharedDataStore",
          plate,
          function(store)
            local blackMoney = (store.get("black_money") or nil)
            local oldAmount = (blackMoney ~= nil and blackMoney[1] and blackMoney[1].amount) or 0
            local newAmount = oldAmount + count

            -- capacity first (the total weight already counts oldAmount / 10)
            if (getTotalInventoryWeight(plate) - oldAmount / 10 + newAmount / 10) > max then
              TriggerClientEvent("esx:showNotification", _source, _U("insufficient_space"))
              return
            end

            if blackMoney ~= nil and blackMoney[1] then
              blackMoney[1].amount = newAmount
            else
              blackMoney = {{amount = newAmount}}
            end

            -- Checks passed. Storing the item.
            xPlayer.removeAccountMoney(item, count)
            store.set("black_money", blackMoney)

            MySQL.Async.execute(
              "UPDATE trunk_inventory SET owned = @owned WHERE plate = @plate",
              {
                ["@plate"] = plate,
                ["@owned"] = owned
              }
            )
          end
        )
      else
        TriggerClientEvent("esx:showNotification", _source, _U("invalid_amount"))
      end
    end

    if type == "item_weapon" then
      -- `serial` = the exact copy the player picked in the UI (several copies are allowed)
      local carried = xPlayer.hasWeapon(item, serial)
      if not carried then return end

      TriggerEvent(
        "esx_trunk:getSharedDataStore",
        plate,
        function(store)
          local storeWeapons = store.get("weapons")

          if storeWeapons == nil then
            storeWeapons = {}
          end

          -- FIX (dupe): capacity is checked BEFORE the weapon is added to the
          -- (live) store table, not after.
          if (getTotalInventoryWeight(plate) + getItemWeight(item)) > max then
            TriggerClientEvent("esx:showNotification", _source, _U("insufficient_space"))
            return
          end

          table.insert(
            storeWeapons,
            {
              name = item,
              label = label,
              ammo = carried.ammo,
              serial = carried.serial -- serial number travels with the weapon
            }
          )
          store.set("weapons", storeWeapons)
          xPlayer.removeWeapon(item, nil, carried.serial)

          MySQL.Async.execute(
            "UPDATE trunk_inventory SET owned = @owned WHERE plate = @plate",
            {
              ["@plate"] = plate,
              ["@owned"] = owned
            }
          )
        end
      )
    end

    TriggerEvent(
      "esx_trunk:getSharedDataStore",
      plate,
      function(store)
        local blackMoney = 0
        local items = {}
        local weapons = {}
        weapons = (store.get("weapons") or {})

        local blackAccount = (store.get("black_money")) or 0
        if blackAccount ~= 0 then
          blackMoney = blackAccount[1].amount
        end

        local coffre = (store.get("coffre") or {})
        for i = 1, #coffre, 1 do
          table.insert(items, {name = coffre[i].name, count = coffre[i].count, label = ESX.GetItemLabel(coffre[i].name)})
        end

        local weight = getTotalInventoryWeight(plate)

        text = _U("trunk_info", plate, (weight / 1000), (max / 1000))
        data = {plate = plate, max = max, myVeh = owned, text = text}
        -- TriggerClientEvent("esx_inventoryhud:refreshTrunkInventory", _source, data, blackMoney, items, weapons)
      end
    )
  end
)

RegisterServerCallbackSafe(
  "esx_trunk:getPlayerInventory",
  function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local blackMoney = xPlayer.getAccount("black_money").money
    local items = xPlayer.inventory

    cb(
      {
        blackMoney = blackMoney,
        items = items
      }
    )
  end
)

function all_trim(s)
  if s then
    return s:match "^%s*(.*)":match "(.-)%s*$"
  else
    return "noTagProvided"
  end
end








