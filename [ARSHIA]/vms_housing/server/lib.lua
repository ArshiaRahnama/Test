--=====================================================================
--  VMS Housing - Server Utility Library (Deobfuscated / Clean)
--=====================================================================
-- This file defines a shared `library` table with helper utilities used
-- by the housing system:
--   - Debug / Dump / Round
--   - Notifications (server -> client)
--   - Framework callback registration (ESX / QB)
--   - Permissions + key checks
--   - Service bills helpers (monthly bill generation, light/water usage)
--   - Region detection
--
-- It also exports a few helpers for other resources to call.
--=====================================================================

-- Prevent repeating the "missing inventory" warning spam
local hasWarnedMissingInventory = false

-- Library table (module-style)
library = library or {}

--=====================================================================
--  Debug helpers
--=====================================================================

---Print debug messages when Config.Debug is true.
---level: nil | "error" | "warn"
function library.Debug(message, level)
    if not Config.Debug then
        return
    end

    if level == "error" then
        error(message)
    elseif level == "warn" then
        warn(message)
    else
        print(message)
    end
end

---Pretty JSON dump for tables (indent enabled).
function library.Dump(value)
    return json.encode(value, { indent = true })
end

---Round a number to `decimals` decimal places (default 0).
function library.Round(value, decimals)
    decimals = decimals or 0
    local multiplier = 10 ^ decimals
    return math.floor(value * multiplier + 0.5) / multiplier
end

--=====================================================================
--  Notifications
--=====================================================================
-- SERVER -> CLIENT event:
--   "vms_housing:notification" (playerSrc, title, message, type)
function library.Notification(playerSrc, title, message, notifType)
    TriggerClientEvent("vms_housing:notification", playerSrc, title, message, notifType)
end

--=====================================================================
--  Framework callbacks (ESX / QB)
--=====================================================================
-- Highlights:
--   ESX:      Core.RegisterServerCallback(name, cb, ...)
--   QB-Core:  Core.Functions.CreateCallback(name, cb, ...)
function library.RegisterCallback(name, cb, ...)
    if Config.Core == "ESX" then
        Core.RegisterServerCallback(name, cb, ...)
    elseif Config.Core == "QB-Core" then
        Core.Functions.CreateCallback(name, cb, ...)
    end
end

--=====================================================================
--  Creator permissions
--=====================================================================

---Returns true if player has the required permissionlevel for Housing Creator.
-- هم src (integer) هم xPlayer object رو قبول میکنه
function library.HasCreatorPermissions(playerOrSrc)
    local xPlayer
    if type(playerOrSrc) == "number" then
        xPlayer = SV.GetPlayer(playerOrSrc)
    else
        xPlayer = playerOrSrc  -- already an xPlayer object
    end
    if not xPlayer then return false end
    local level = tonumber(xPlayer.permission_level) or 0
    local required = (Config.HousingCreator and Config.HousingCreator.RequiredPermissionLevel) or 5
    return level >= required
end

--=====================================================================
--  Random chance helper
--=====================================================================
-- Input is a percent chance (0-100). Returns true if passed.
function library.DrawChance(chancePercent)
    if not chancePercent or not tonumber(chancePercent) then
        return false
    end

    local roll = math.random() * 100
    return chancePercent > roll
end

--=====================================================================
--  Keys
--=====================================================================
-- HasKeys(playerSrc, identifier, propertyId, keySerialMaybe)
-- Two modes depending on Config.UseKeysOnItem:
--   1) true: checks physical inventory items "house_key" with metadata.keySerialNumber
--   2) false: checks owner/renter/keys-string contains identifier
function library.HasKeys(playerSrc, identifier, propertyId, keySerialMaybe)
    local property = Properties[propertyId]
    if not property then
        return false
    end

    -- Mode 1: keys are inventory items
    if Config.UseKeysOnItem then
        local player = SV.GetPlayer(playerSrc)

        -- If a specific serial is provided, validate it belongs to this property and exists in inventory.
        if keySerialMaybe then
            -- serial format expected: "<propertyId>-<serialPart>"
            local serialPropertyId, serialPart = string.match(keySerialMaybe, "^(.-)%-(.+)$")
            if tostring(propertyId) ~= tostring(serialPropertyId) then
                return false
            end

            -- property.keys is stored as a string; original code uses string.find on it
            if string.find(property.keys, serialPart) then
                -- INVENTORY LOOKUP (server-side helper)
                local hasItem = SV.GetItem(
                    playerSrc,
                    player,
                    "house_key",
                    { keySerialNumber = keySerialMaybe },
                    "key"
                )
                if hasItem then
                    return true
                end
            end

        else
            -- No serial provided: try all keys registered on the property
            local keyList = json.decode(property.keys)

            for i = 1, #keyList do
                local serial = keyList[i]

                -- INVENTORY LOOKUP (server-side helper)
                local hasItem = SV.GetItem(
                    playerSrc,
                    player,
                    "house_key",
                    { keySerialNumber = serial },
                    "key"
                )
                if hasItem then
                    return true
                end
            end
        end

        return false
    end

    -- Mode 2: classic identifier-based access
    if property.owner == identifier then
        return true
    end
    if property.renter == identifier then
        return true
    end
    if property.keys and string.find(property.keys, identifier) then
        return true
    end

    return false
end

--=====================================================================
--  Key serial generation (when keys are items)
--=====================================================================
-- Generates "<propertyId>-<random4digits><AAA><random3digits>"
-- Ensures uniqueness against existing keys for that property by recursion.
function library.GenerateKeySerialNumber(propertyId)
    if not Config.UseKeysOnItem then
        return
    end

    -- local helper: random uppercase letter
    local function randomLetter()
        local letters = {
            "A","B","C","D","E","F","G","H","I","J","K","L","M",
            "N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
        }
        return letters[math.random(#letters)]
    end

    -- Build candidate serial
    local serial = tostring(propertyId)
        .. "-"
        .. tostring(math.random(1000, 9999))
        .. randomLetter() .. randomLetter() .. randomLetter()
        .. tostring(math.random(100, 999))

    -- Original behavior: check uniqueness by searching within encoded keys
    local encodedKeys = json.encode(Properties[propertyId].keys)
    if string.find(encodedKeys, serial) then
        return library.GenerateKeySerialNumber(propertyId)
    end

    return serial
end

--=====================================================================
--  Inventory integration (storage registration)
--=====================================================================
-- If a compatible inventory export isn't present, warn once.
function library.RegisterStorage(storageData)
    if RegisterStorage then
        RegisterStorage(storageData)
        return
    end

    if not hasWarnedMissingInventory then
        hasWarnedMissingInventory = true
        warn("Compatible Inventory is missing!")
        print("Adjust it on ^5vms_housing/integration/[inventory]^7")
    end
end

--=====================================================================
--  Bills: Light usage month overlap handling
--=====================================================================
-- This compensates electricity usage when lights were turned on in a previous month,
-- and the month changed (so we move usage into the previous month's services bill).
--
-- IMPORTANT: Uses AWAIT DB update (MySQL.update.await) inside.
function library.HandleLightStateMonthOverlap(propertyId)
    if not Config.UseServiceBills then
        return
    end

    local property = GetProperty(propertyId)
    if not property then
        return
    end

    local metadata = property.metadata or {}
    if not (metadata.lightState and metadata.lightStartTime) then
        return
    end

    local now = os.time()
    local lightStart = metadata.lightStartTime

    -- Extract month/year for now and for start time
    local nowMonth  = tonumber(os.date("%m", now))
    local nowYear   = tonumber(os.date("%Y", now))
    local startMonth = tonumber(os.date("%m", lightStart))
    local startYear  = tonumber(os.date("%Y", lightStart))

    -- Same month/year => nothing to do
    if nowMonth == startMonth and nowYear == startYear then
        return
    end

    -- Start of current month (00:00:00 day 1)
    local startOfCurrentMonth = os.time({
        day = 1, month = nowMonth, year = nowYear,
        hour = 0, min = 0, sec = 0
    })

    -- If start time isn't before start-of-month, nothing to move
    if lightStart >= startOfCurrentMonth then
        return
    end

    local overlapSeconds = startOfCurrentMonth - lightStart
    if overlapSeconds <= 0 then
        return
    end

    -- Determine previous month period string "%m:%Y"
    local prevMonth = nowMonth - 1
    local prevYear = nowYear
    if prevMonth <= 0 then
        prevMonth = 12
        prevYear = prevYear - 1
    end
    local prevPeriod = string.format("%02d:%04d", prevMonth, prevYear)

    -- Find previous period "services" bill in property.bills
    local bills = property.bills or {}
    local prevServicesBill = nil
    for i = 1, #bills do
        local bill = bills[i]
        if bill.period == prevPeriod and bill.type == "services" then
            prevServicesBill = bill
            break
        end
    end

    if prevServicesBill then
        local details = json.decode(prevServicesBill.details or "{}")

        local regionCfg = Config.Regions[property.region] or Config.NoRegion

        -- Update usage and cost
        details.electricityUsage = (details.electricityUsage or 0) + overlapSeconds
        details.electricity      = (details.electricity or 0) + (overlapSeconds * regionCfg.electricity.rate)

        -- Recompute total (electricity + water + internet)
        local electricity = details.electricity or 0
        local water       = details.water or 0
        local internet    = details.internet or 0
        prevServicesBill.total = electricity + water + internet

        prevServicesBill.details = json.encode(details)

        -- AWAIT DB UPDATE
        MySQL.update.await(
            "UPDATE houses_bills SET details = ?, total = ? WHERE id = ? AND type = ?",
            { json.encode(details), prevServicesBill.total, prevServicesBill.id, "services" }
        )
    end

    -- Move lightStartTime to beginning of current month (so new usage counts in this month)
    metadata.lightStartTime = startOfCurrentMonth
end

--=====================================================================
--  Bills: Generate monthly services bill
--=====================================================================
-- Inserts a "services" bill (water + internet, electricity starts at 0 usage).
-- Uses pcall around INSERT to handle unique constraint conflicts.
--
-- IMPORTANT: Uses AWAIT DB insert/select.
function library.GenerateMonthlyBill(propertyId, period)
    if not Config.UseServiceBills then
        return
    end

    local property = GetProperty(propertyId)
    if not property then
        return nil
    end

    local metadata = property.metadata or {}
    local waterUsage = metadata.waterUsage or 0

    local regionCfg = Config.Regions[property.region] or Config.NoRegion

    local baseElectricity = 0
    local waterCost = waterUsage * regionCfg.water.rate
    local internetCost = regionCfg.internet.flatRate
    local total = baseElectricity + waterCost + internetCost

    local detailsTable = {
        electricityUsage = 0,
        electricity      = baseElectricity,
        waterUsage       = waterUsage,
        water            = waterCost,
        internet         = internetCost,
        rateInfo         = {
            electricity = library.Round(regionCfg.electricity.rate, 5),
            water       = library.Round(regionCfg.water.rate, 5),
            internet    = library.Round(regionCfg.internet.flatRate, 5),
        }
    }
    local detailsJson = json.encode(detailsTable)

    -- AWAIT DB INSERT (protected)
    local ok, insertId = pcall(function()
        return MySQL.insert.await([[
            INSERT INTO houses_bills (house_id, period, type, total, paid, details)
            VALUES (?, ?, ?, ?, ?, ?)
        ]], { tonumber(propertyId), period, "services", total, 0, detailsJson })
    end)

    if ok and insertId then
        -- Reset usage in-memory (matches original intent)
        metadata.waterUsage = 0

        return {
            id      = insertId,
            house_id = propertyId,
            period  = period,
            type    = "services",
            total   = total,
            paid    = 0,
            paid_at = nil,
            details = detailsJson,
        }
    end

    -- Conflict fallback: fetch existing record
    return MySQL.single.await([[
        SELECT * FROM houses_bills WHERE house_id = ? AND period = ? AND type = ?
    ]], { tonumber(propertyId), period, "services" })
end

--=====================================================================
--  Bills: Generate rent bill
--=====================================================================
-- Inserts "rent" bill with details { rent = <price> }.
-- paidFlag: nil/false => unpaid, true => paid immediately.
--
-- IMPORTANT: Uses AWAIT DB insert/select.
function library.GenerateRentBill(propertyId, period, paidFlag)
    local property = GetProperty(propertyId)
    if not (property and property.renter) then
        return nil
    end

    local rentPrice = (property.rental and property.rental.price) or 0
    if rentPrice <= 0 then
        return nil
    end

    local detailsJson = json.encode({ rent = rentPrice })

    local ok, insertId = pcall(function()
        return MySQL.insert.await([[
            INSERT INTO houses_bills (house_id, period, type, total, paid, details)
            VALUES (?, ?, ?, ?, ?, ?)
        ]], {
            tonumber(propertyId),
            period,
            "rent",
            rentPrice,
            (paidFlag and 1 or 0),
            detailsJson
        })
    end)

    if ok and insertId then
        return {
            id      = insertId,
            house_id = propertyId,
            period  = period,
            type    = "rent",
            total   = rentPrice,
            paid    = (paidFlag and 1 or 0),
            paid_at = (paidFlag and os.time() or nil),
            details = detailsJson,
        }
    end

    return MySQL.single.await([[
        SELECT * FROM houses_bills WHERE house_id = ? AND period = ? AND type = ?
    ]], { tonumber(propertyId), period, "rent" })
end

--=====================================================================
--  Bills: Get or create bills for property (monthly services + rent)
--=====================================================================
-- paidRentFlag passed through to GenerateRentBill.
function library.GetOrCreateBills(propertyId, paidRentFlag)
    local property = GetProperty(propertyId)
    if not property then
        return {}
    end

    -- Ensure previous-month overlap is handled before creating/reading this month
    library.HandleLightStateMonthOverlap(propertyId)

    local currentMonthPeriod = os.date("%m:%Y")
    local weeklyPeriod = GetWeekPeriod()

    -- Determine rent period by rental.cycle
    local rentPeriod = currentMonthPeriod
    if property.rental and property.rental.cycle == "weekly" and weeklyPeriod then
        rentPeriod = weeklyPeriod
    end

    local hasServices = false
    local hasRent = false

    for _, bill in ipairs(property.bills or {}) do
        if bill.period == currentMonthPeriod and bill.type == "services" then
            hasServices = true
        end
        if bill.period == rentPeriod and bill.type == "rent" and property.renter then
            hasRent = true
        end
    end

    if not hasServices then
        local newServices = library.GenerateMonthlyBill(propertyId, currentMonthPeriod)
        if newServices then
            table.insert(property.bills, 1, newServices)

            -- Original code increments unpaidBills if bill period != currentMonthPeriod (rare),
            -- kept as-is for parity.
            if newServices.period ~= currentMonthPeriod then
                property.unpaidBills = (property.unpaidBills or 0) + 1
            end
        end
    end

    if not hasRent then
        local newRent = library.GenerateRentBill(propertyId, rentPeriod, paidRentFlag)
        if newRent then
            table.insert(property.bills, 1, newRent)
            if not paidRentFlag then
                property.unpaidRentBills = (property.unpaidRentBills or 0) + 1
            end
        end
    end

    return property.bills
end

--=====================================================================
--  Bills: Apply current light usage (electricity) to this month's services bill
--=====================================================================
-- Updates details + total, updates DB, and sets metadata.lightStartTime to A1_2.
-- If shouldPersistPropertyMeta is true, also updates `houses.metadata` in DB.
--
-- IMPORTANT: Uses AWAIT DB updates.
function library.ApplyCurrentLightUsage(propertyId, newLightStartTime, shouldPersistPropertyMeta)
    if not Config.UseServiceBills then
        return
    end

    local property = GetProperty(propertyId)
    if not property then
        return false
    end

    if not (property.metadata and property.metadata.lightState and property.metadata.lightStartTime) then
        return false
    end

    local now = os.time()
    local previousStart = property.metadata.lightStartTime
    local secondsUsed = now - previousStart
    if secondsUsed <= 0 then
        return false
    end

    local period = os.date("%m:%Y", now)
    local regionCfg = Config.Regions[property.region] or Config.NoRegion
    local electricityRate = regionCfg.electricity.rate

    -- Find current period services bill or create it
    local servicesBill = nil
    for _, bill in ipairs(property.bills or {}) do
        if bill.period == period and bill.type == "services" then
            servicesBill = bill
            break
        end
    end

    if not servicesBill then
        servicesBill = library.GenerateMonthlyBill(propertyId, period)
        table.insert(property.bills, 1, servicesBill)
    end

    local details = json.decode(servicesBill.details or "{}")

    details.electricityUsage = (details.electricityUsage or 0) + secondsUsed
    details.electricity = library.Round((details.electricity or 0) + (secondsUsed * electricityRate), 6)

    -- Recompute total with rounded components (matches original approach)
    local electricity = library.Round(details.electricity or 0, 3)
    local water       = library.Round(details.water or 0, 3)
    local internet    = library.Round(details.internet or 0, 3)
    servicesBill.total = electricity + water + internet

    servicesBill.details = json.encode(details)

    -- AWAIT DB UPDATE
    MySQL.update.await(
        "UPDATE houses_bills SET details = ?, total = ? WHERE id = ? AND type = ?",
        { servicesBill.details, servicesBill.total, servicesBill.id, "services" }
    )

    -- Update metadata lightStartTime in memory
    property.metadata.lightStartTime = newLightStartTime

    if shouldPersistPropertyMeta then
        -- AWAIT DB UPDATE
        MySQL.update.await(
            "UPDATE houses SET metadata = ? WHERE id = ?",
            { json.encode(property.metadata), tonumber(propertyId) }
        )
    end

    return true
end

--=====================================================================
--  Bills: Apply water usage reading to this month's services bill
--=====================================================================
-- A1_2 is a raw reading (original code divides by 1000).
--
-- IMPORTANT: Uses AWAIT DB update.
function library.ApplyWaterUsage(propertyId, rawUsage)
    if not Config.UseServiceBills then
        return
    end

    local property = GetProperty(propertyId)
    if not property then
        return false
    end

    if not rawUsage or rawUsage <= 0 then
        return false
    end

    local now = os.time()
    local period = os.date("%m:%Y", now)

    local regionCfg = Config.Regions[property.region] or Config.NoRegion
    local waterRate = regionCfg.water.rate

    -- Find current period bill (original code didn't check type here, kept behavior)
    local billForPeriod = nil
    for _, bill in ipairs(property.bills or {}) do
        if bill.period == period then
            billForPeriod = bill
            break
        end
    end

    if not billForPeriod then
        billForPeriod = library.GenerateMonthlyBill(propertyId, period)
        table.insert(property.bills, 1, billForPeriod)
    end

    local details = json.decode(billForPeriod.details or "{}")

    local usage = rawUsage / 1000
    details.waterUsage = (details.waterUsage or 0) + usage
    details.water = library.Round((details.water or 0) + (usage * waterRate), 6)

    local electricity = library.Round(details.electricity or 0, 3)
    local water       = library.Round(details.water or 0, 3)
    local internet    = library.Round(details.internet or 0, 3)
    billForPeriod.total = electricity + water + internet

    billForPeriod.details = json.encode(details)

    -- AWAIT DB UPDATE
    MySQL.update.await(
        "UPDATE houses_bills SET details = ?, total = ? WHERE id = ? AND type = ?",
        { billForPeriod.details, billForPeriod.total, billForPeriod.id, "services" }
    )

    return true
end

--=====================================================================
--  Permissions
--=====================================================================

---Returns true if identifier is owner or has specific permission flag.
function library.HasPermissions(propertyId, identifier, permissionKey)
    local property = GetProperty(propertyId)
    if property and property.owner == identifier then
        return true
    end

    local perms = property and property.permissions
    if perms and perms[identifier] and perms[identifier][permissionKey] then
        return true
    end

    return false
end

---Returns true if identifier is owner OR has any permission entry at all.
function library.HasAnyPermission(propertyId, identifier)
    local property = GetProperty(propertyId)
    if property and property.owner == identifier then
        return true
    end

    local perms = property and property.permissions
    if perms and perms[identifier] then
        return true
    end

    return false
end

--=====================================================================
--  Regions
--=====================================================================

---Returns region key for a coordinate point if inside a configured polygon, otherwise nil.
function library.GetCurrentRegion(coords)
    for regionKey, regionData in pairs(Config.Regions) do
        if regionData.zone then
            if isPointInPolygon(coords, regionData.zone) then
                return regionKey
            end
        end
    end
    return nil
end

--=====================================================================
--  Exports (other resources can call these)
--=====================================================================
exports("HasKeys", library.HasKeys)
exports("GenerateKeySerialNumber", library.GenerateKeySerialNumber)
exports("HasPermissions", library.HasPermissions)
exports("HasAnyPermission", library.HasAnyPermission)

-- `library` is intentionally global (used by server/main.lua and modules).
