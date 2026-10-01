ESX = nil
Items = {}
local DataStoresIndex = {}
local DataStores = {}
local SharedDataStores = {}

local listPlate = TrunkConfig.VehiclePlate

TriggerEvent(
  "esx:getSharedObject",
  function(obj)
    ESX = obj
  end
)

-- FIX (bug #3): 'onMySQLReady' is never fired by oxmysql's compat shim (only
-- mysql-async fired that event; oxmysql exposes readiness as MySQL.ready(cb)
-- instead - see the identical fix already applied in trunk_main.lua). This
-- handler never ran, so the whole trunk_inventory table was never preloaded
-- at boot; every plate paid a lazy SELECT+INSERT on its first access instead.
MySQL.ready(function()
    local result = MySQL.Sync.fetchAll("SELECT * FROM trunk_inventory")
    local data = nil
    if #result ~= 0 then
      for i = 1, #result, 1 do
        local plate = result[i].plate
        local owned = result[i].owned
        local data = (result[i].data == nil and {} or json.decode(result[i].data))
        local dataStore = CreateDataStore(plate, owned, data)
        SharedDataStores[plate] = dataStore
      end
    end
end)

function loadInvent(plate)
  local result =
    MySQL.Sync.fetchAll(
    "SELECT * FROM trunk_inventory WHERE plate = @plate",
    {
      ["@plate"] = plate
    }
  )
  local data = nil
  if #result ~= 0 then
    for i = 1, #result, 1 do
      local plate = result[i].plate
      local owned = result[i].owned
      local data = (result[i].data == nil and {} or json.decode(result[i].data))
      local dataStore = CreateDataStore(plate, owned, data)
      SharedDataStores[plate] = dataStore
    end
  end
end

function getOwnedVehicule(plate)
  local found = false
  -- glovebox rows are stored as "GLOVE:<plate>"; ownership is of the real plate
  if type(plate) == "string" then
    plate = (plate:gsub("^" .. TrunkConfig.GlovePrefix, ""))
  end
  if listPlate then
    for k, v in pairs(listPlate) do
      if plate ~= nil and string.find(plate, v) ~= nil then
        found = true
        break
      end
    end
  end
  if not found then
    local result = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate",
    {
      ['@plate'] = plate
    })
    while result == nil do
      Wait(5)
    end
    if result ~= nil and #result > 0 then
      found = true
    end
  end
  return found
end

function MakeDataStore(plate)
  local data = {}
  local owned = getOwnedVehicule(plate)
  local dataStore = CreateDataStore(plate, owned, data)
  SharedDataStores[plate] = dataStore
  MySQL.Async.execute(
    "INSERT INTO trunk_inventory(plate,data,owned) VALUES (@plate,'{}',@owned)",
    {
      ["@plate"] = plate,
      ["@owned"] = owned
    }
  )
  loadInvent(plate)
end

function GetSharedDataStore(plate)
  if SharedDataStores[plate] == nil then
    MakeDataStore(plate)
  end
  return SharedDataStores[plate]
end

-------------------------------------------------------------------------
-- FIX (requested: hook every other resource's dead "qb-inventory"/
-- "ox_inventory"/"esx_inventory" trunk-reading calls up to the real,
-- working Unique_inventory trunk data instead). This is a PLAIN export
-- that returns a value immediately - not passing a callback function
-- across the resource boundary, which is the specific thing documented
-- elsewhere in this codebase as broken on this FXServer build. Any other
-- resource (e.g. esx_uniquejobs' K9 search, [JOB]/esx_uniquejobs/server/
-- k9/server_editable.lua) can call:
--
--     exports['Unique_inventory']:GetTrunkItems(plate)
--
-- and gets back { {name=..., count=...}, ... } - standard items only
-- (weapons aren't relevant to a K9 drug search). Safe to call for a plate
-- that has never been opened before - GetSharedDataStore lazily creates it.
-------------------------------------------------------------------------
exports('GetTrunkItems', function(plate)
    local store = GetSharedDataStore(plate)
    local coffre = store.get('coffre') or {}
    local items = {}
    for _, v in pairs(coffre) do
        items[#items + 1] = { name = v.name, count = v.count }
    end
    return items
end)

AddEventHandler(
  "esx_trunk:getSharedDataStore",
  function(plate, cb)
    cb(GetSharedDataStore(plate))
  end
)
