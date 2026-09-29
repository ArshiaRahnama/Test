--=====================================================================
--  Core / Globals
--=====================================================================

-- Core object (framework export)
Core = Config.CoreExport()

-- In-memory caches (populated on resource init)
Properties        = {}   -- [propertyIdString] = houseRow
Furniture         = {}   -- [model] = furnitureRow
PendingDeliveries = {}   -- array of { propertyId, furnitureId, deliveryTime }
IsDataLoaded      = false -- set to true after DB load completes

--=====================================================================
--  Furniture catalog persistence helper
--=====================================================================
-- SaveFurniture(action, payload)
--  action:
--    "insert" -> payload = { "modelA", "modelB", ... }  (models must already exist in Furniture cache)
--    "update" -> payload = "model"
--    "delete" -> payload = "model"
--
-- NOTE: All DB writes here are ASYNC (fire-and-forget).
function SaveFurniture(action, payload)
    if action == "insert" then
        if type(payload) ~= "table" then
            return
        end

        for _, model in ipairs(payload) do
            local item = Furniture[model]
            if not item then
                -- Matches original behavior: abort the entire insert batch if any model is missing
                return
            end

            local metadataJson = nil
            if item.metadata then
                metadataJson = json.encode(item.metadata) or nil
            end

            -- ASYNC DB WRITE
            MySQL.execute([[
                INSERT INTO `houses_furniture_list` (
                    `model`,
                    `label`,
                    `price`,
                    `deliverySize`,
                    `tag`,
                    `isOutdoor`,
                    `isIndoor`,
                    `interactableName`,
                    `metadata`
                )
                VALUES (@model, @label, @price, @deliverySize, @tag, @isOutdoor, @isIndoor, @interactableName, @metadata)
            ]], {
                ["@model"]            = model,
                ["@label"]            = item.label,
                ["@price"]            = item.price,
                ["@deliverySize"]     = item.deliverySize,
                ["@tag"]              = item.tag,
                ["@isOutdoor"]        = item.isOutdoor,
                ["@isIndoor"]         = item.isIndoor,
                ["@interactableName"] = item.interactableName,
                ["@metadata"]         = metadataJson,
            })
        end

    elseif action == "update" then
        local model = payload
        local item = Furniture[model]
        if not item then
            return
        end

        local metadataJson = nil
        if item.metadata then
            metadataJson = json.encode(item.metadata) or nil
        end

        -- ASYNC DB WRITE
        MySQL.execute([[
            UPDATE `houses_furniture_list` SET
                `label` = @label,
                `price` = @price,
                `deliverySize` = @deliverySize,
                `tag` = @tag,
                `isOutdoor` = @isOutdoor,
                `isIndoor` = @isIndoor,
                `interactableName` = @interactableName,
                `metadata` = @metadata
            WHERE `model` = @model
        ]], {
            ["@model"]            = model,
            ["@label"]            = item.label,
            ["@price"]            = item.price,
            ["@deliverySize"]     = item.deliverySize,
            ["@tag"]              = item.tag,
            ["@isOutdoor"]        = item.isOutdoor,
            ["@isIndoor"]         = item.isIndoor,
            ["@interactableName"] = item.interactableName,
            ["@metadata"]         = metadataJson,
        })

    elseif action == "delete" then
        local model = payload

        -- ASYNC DB WRITE
        MySQL.execute([[
            DELETE FROM `houses_furniture_list` WHERE `model` = @model
        ]], {
            ["@model"] = model
        })
    end
end

--=====================================================================
--  Database init / Resource boot
--=====================================================================

MySQL.ready(function()
    ------------------------------------------------------------------
    -- Optional: auto-create tables
    -- (All calls below are ASYNC DB WRITES)
    ------------------------------------------------------------------
    if Config.AutoExecuteQuery then
        MySQL.execute([[
            CREATE TABLE IF NOT EXISTS `houses` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `type` varchar(50) DEFAULT NULL,
                `object_id` int(11) DEFAULT NULL,
                `owner` varchar(120) DEFAULT NULL,
                `owner_name` varchar(80) DEFAULT NULL,
                `renter` varchar(120) DEFAULT NULL,
                `renter_name` varchar(80) DEFAULT NULL,
                `name` longtext DEFAULT '',
                `description` longtext DEFAULT NULL,
                `region` varchar(70) DEFAULT NULL,
                `address` varchar(50) DEFAULT NULL,
                `keys` longtext NOT NULL DEFAULT '[]',
                `permissions` longtext DEFAULT '[]',
                `metadata` longtext NOT NULL DEFAULT '[]',
                `sale` longtext DEFAULT '[]',
                `rental` longtext DEFAULT '[]',
                `last_enter` int(11) DEFAULT NULL,
                `creator` varchar(120) DEFAULT NULL,
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
        ]])

        MySQL.execute([[
            CREATE TABLE IF NOT EXISTS `houses_bills` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `house_id` int(11) NOT NULL,
                `period` varchar(50) NOT NULL DEFAULT '',
                `type` varchar(50) DEFAULT NULL,
                `total` float DEFAULT 0,
                `paid` tinyint(1) DEFAULT 0,
                `details` longtext NOT NULL,
                PRIMARY KEY (`id`),
                UNIQUE KEY `unique_period_per_house_type` (`house_id`,`period`,`type`)
            ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
        ]])

        MySQL.execute([[
            CREATE TABLE IF NOT EXISTS `houses_furniture` (
                `id` int(11) NOT NULL AUTO_INCREMENT,
                `house_id` int(11) NOT NULL,
                `position` longtext DEFAULT NULL,
                `model` varchar(70) DEFAULT NULL,
                `stored` int(11) DEFAULT 0,
                `metadata` longtext DEFAULT NULL,
                PRIMARY KEY (`id`)
            ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
        ]])

        MySQL.execute([[
            CREATE TABLE IF NOT EXISTS `houses_furniture_list` (
                `model` varchar(80) NOT NULL,
                `label` varchar(80) DEFAULT NULL,
                `price` int(11) DEFAULT 0,
                `deliverySize` int(11) DEFAULT 1,
                `tag` varchar(50) DEFAULT NULL,
                `isOutdoor` int(11) DEFAULT 1,
                `isIndoor` int(11) DEFAULT 1,
                `interactableName` varchar(50) DEFAULT NULL,
                `metadata` longtext DEFAULT NULL,
                PRIMARY KEY (`model`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
        ]])
    end

    ------------------------------------------------------------------
    -- Main init thread
    ------------------------------------------------------------------
    Citizen.CreateThread(function()
        local initStartMs = GetGameTimer()
        local nowUnix      = os.time()
        local monthPeriod  = os.date("%m:%Y", nowUnix)  -- current monthly billing period
        local weekPeriod   = GetWeekPeriod()            -- weekly rent period (if enabled)

        ------------------------------------------------------------------
        -- Optional table optimization
        -- ASYNC DB MAINTENANCE
        ------------------------------------------------------------------
        if Config.OptimizeBillsTable then
            MySQL.prepare(string.format(
                "DELETE FROM houses_bills WHERE `paid` = 1 AND `period` != '%s'",
                monthPeriod
            ), {})
        end

        ------------------------------------------------------------------
        -- Load all required data
        -- These are AWAIT calls (block this init thread until results arrive)
        ------------------------------------------------------------------
        local furnitureListRows   = MySQL.query.await("SELECT * FROM `houses_furniture_list`", {})
        local housesRows          = MySQL.query.await("SELECT * FROM `houses`", {})
        local billsRows           = MySQL.query.await("SELECT * FROM `houses_bills` ORDER BY id DESC", {})
        local placedFurnitureRows = MySQL.query.await("SELECT * FROM `houses_furniture`", {})

        ------------------------------------------------------------------
        -- Build Furniture catalog cache
        ------------------------------------------------------------------
        if furnitureListRows then
            for i = 1, #furnitureListRows do
                local row = furnitureListRows[i]

                if row.metadata then
                    row.metadata = json.decode(row.metadata)
                end

                Furniture[row.model] = row
            end
        end

        ------------------------------------------------------------------
        -- Build Properties cache & initialize per-house runtime fields
        ------------------------------------------------------------------
        for i = 1, #housesRows do
            local house = housesRows[i]
            local propertyId = tostring(house.id)

            -- Decode JSON fields
            -- nil-safe decode (MySQL قدیمی longtext DEFAULT رو نادیده می‌گیره)
            house.metadata = house.metadata and json.decode(house.metadata) or {}
            house.sale     = house.sale     and json.decode(house.sale)     or {}
            house.rental   = house.rental   and json.decode(house.rental)   or {}

            -- Extra per-house init (skip for building/motel types)
            if house.type ~= "building" and house.type ~= "motel" then
                house.permissions = house.permissions and json.decode(house.permissions) or {}
                house.bills          = {}
                house.unpaidBills    = 0
                house.unpaidRentBills = 0
                house.furniture      = {}

                -- Default door lock state if doors state is not persisted
                if not Config.SaveDoorsState then
                    if house.type == "mlo" then
                        if house.metadata and house.metadata.doors then
                            for _, door in pairs(house.metadata.doors) do
                                door.locked = Config.DefaultDoorsLocked
                            end
                        end
                    else
                        house.metadata.locked = Config.DefaultDoorsLocked
                    end
                end

                -- City hall taxes: cadastral tax (if enabled)
                local taxCfg = Config.CityHallTaxes
                    and Config.CityHallTaxes.PropertyCadastralTax
                    and Config.CityHallTaxes.PropertyCadastralTax.Enabled

                if taxCfg and house.owner then
                    local lastPeriod = house.metadata and house.metadata.lastCadastralPeriod
                    if lastPeriod ~= monthPeriod then
                        -- SERVER / MODULE CALL: generate and register tax for this owner
                        local added = SV.AddTax(
                            house.owner,
                            house.owner_name,
                            house.name,
                            house.address,
                            "property_cadastral_tax",
                            house.sale and house.sale.defaultPrice
                        )

                        if added then
                            house.metadata.lastCadastralPeriod = monthPeriod

                            -- ASYNC DB WRITE (positional parameters)
                            MySQL.prepare(
                                "UPDATE `houses` SET metadata = ? WHERE id = ?",
                                { json.encode(house.metadata), tonumber(house.id) }
                            )
                        end
                    end
                end

                -- House storage registration (if configured in metadata)
                if house.metadata and house.metadata.storage and house.metadata.storage.x then
                    -- SERVER / MODULE CALL: register a stash/storage
                    library.RegisterStorage({
                        id     = ("house_storage-%s"):format(house.id),
                        slots  = house.metadata.storage.slots,
                        weight = house.metadata.storage.weight
                    })
                end
            end

            -- Store in global cache
            Properties[propertyId] = house

            -- Yield occasionally to avoid hitching on big datasets
            if (i % 100) == 0 then
                Citizen.Wait(10)
            end
        end

        -- Mark data as fully loaded (prevents sv:fetchData race condition)
        IsDataLoaded = true

        ------------------------------------------------------------------
        -- Attach placed furniture to properties, track deliveries, register storages
        ------------------------------------------------------------------
        if placedFurnitureRows then
            for i = 1, #placedFurnitureRows do
                local f = placedFurnitureRows[i]
                f.position = json.decode(f.position)
                f.metadata  = json.decode(f.metadata)

                local propertyId = tostring(f.house_id)
                local house = Properties[propertyId]
                if house then
                    -- Delivery tracking: furniture with deliveryTime becomes pending
                    if f.metadata and f.metadata.deliveryTime then
                        table.insert(PendingDeliveries, {
                            propertyId   = propertyId,
                            furnitureId  = f.id,
                            deliveryTime = f.metadata.deliveryTime
                        })
                    end

                    -- If this furniture has storage metadata (weight present), register it
                    if f.position and f.metadata and next(f.metadata) and f.metadata.weight ~= nil then
                        -- SERVER / MODULE CALL
                        library.RegisterStorage(f.metadata)
                    end

                    -- Attach to house furniture list
                    table.insert(house.furniture, f)
                end
            end
        end

        ------------------------------------------------------------------
        -- Attach bills to properties and update unpaid counters
        ------------------------------------------------------------------
        if billsRows then
            for i = 1, #billsRows do
                local bill = billsRows[i]
                local propertyId = tostring(bill.house_id)
                local house = Properties[propertyId]

                if house and house.type ~= "building" and house.type ~= "motel" then
                    if not bill.paid then
                        if bill.type == "rent" then
                            house.unpaidRentBills = (house.unpaidRentBills or 0) + 1
                        else
                            if Config.UseServiceBills and bill.period ~= monthPeriod then
                                house.unpaidBills = (house.unpaidBills or 0) + 1
                            end
                        end
                    end

                    table.insert(house.bills, bill)
                end
            end

            ------------------------------------------------------------------
            -- Post-processing per property:
            --  - ensure monthly service bill exists (if enabled)
            --  - handle light shutoff if too many unpaid bills
            --  - ensure rent bill exists (if renter & missing)
            --  - terminate rental if conditions met
            ------------------------------------------------------------------
            for propertyId, house in pairs(Properties) do
                if house.type ~= "building" and house.type ~= "motel" then
                    local hasServiceBillThisMonth = false
                    local hasRentBillForCycle     = false

                    -- Determine rent period key (weekly vs monthly)
                    local rentPeriod = monthPeriod
                    if house.rental and house.rental.cycle == "weekly" and weekPeriod then
                        rentPeriod = weekPeriod
                    end

                    -- Scan existing bills
                    local bills = house.bills or {}
                    for _, bill in ipairs(bills) do
                        if bill.period == monthPeriod then
                            if bill.type == "services" then
                                hasServiceBillThisMonth = true
                            end
                        else
                            if bill.period == rentPeriod and bill.type == "rent" and house.renter then
                                hasRentBillForCycle = true
                            end
                        end

                        -- Early exit similar to original logic
                        if hasServiceBillThisMonth then
                            if (not house.renter) or hasRentBillForCycle then
                                break
                            end
                        end
                    end

                    -- Create monthly service bill if needed
                    if Config.UseServiceBills and not hasServiceBillThisMonth then
                        -- SERVER / MODULE CALL: creates bill row (likely also persists)
                        local newBill = library.GenerateMonthlyBill(propertyId, monthPeriod)
                        if newBill then
                            table.insert(house.bills, 1, newBill)
                        end
                    end

                    -- Light shutoff logic when unpaid bills exceed limit
                    if Config.UseServiceBills and house.unpaidBills then
                        if house.unpaidBills >= Config.AllowedUnpaidBills then
                            if house.metadata and house.metadata.lightState then
                                -- SERVER / MODULE CALL
                                library.HandleLightStateMonthOverlap(propertyId)

                                house.metadata.lightState = false
                                house.metadata.lightStartTime = nil

                                -- ASYNC DB WRITE
                                MySQL.prepare(
                                    "UPDATE `houses` SET metadata = ? WHERE id = ?",
                                    { json.encode(house.metadata), tonumber(propertyId) }
                                )
                            end
                        end
                    end

                    -- Rent bill creation + rental termination checks
                    if house.renter then
                        if not hasRentBillForCycle then
                            -- SERVER / MODULE CALL: creates rent bill row (likely also persists)
                            local rentBill = library.GenerateRentBill(propertyId, rentPeriod)
                            if rentBill then
                                table.insert(house.bills, 1, rentBill)
                                house.unpaidRentBills = (house.unpaidRentBills or 0) + 1
                            end
                        end

                        local unpaidRent = house.unpaidRentBills or 0
                        local mustTerminate =
                            (unpaidRent >= Config.AllowedUnpaidRentBills) or
                            (house.rental and house.rental.terminateAtPeriod == monthPeriod)

                        if mustTerminate then
                            ------------------------------------------------------------------
                            -- Rental termination
                            -- This section performs:
                            --  - DB cleanup (bills, furniture if configured)
                            --  - state resets (keys/permissions/metadata)
                            --  - updates `houses` row
                            --
                            -- NOTE: Final DB update is ASYNC (MySQL.execute).
                            ------------------------------------------------------------------
                            local updateQuery = ""
                            local renterIdentifier = house.renter

                            if house.owner then
                                -- House has an owner: end renter only (keep sale data intact)
                                updateQuery = [[
                                    UPDATE `houses`
                                        SET
                                            `renter` = NULL,
                                            `renter_name` = NULL,
                                            `permissions` = @permissions,
                                            `keys` = @keys,
                                            `metadata` = @metadata,
                                            `rental` = @rental
                                    WHERE id = @id
                                ]]

                                -- Optionally remove keys when rent ends
                                if Config.RemoveKeysOnRentEnd then
                                    house.keys = json.encode({})
                                end

                                -- Reset rent counters and remove unpaid rent bills from DB
                                house.unpaidRentBills = nil

                                MySQL.prepare(
                                    "DELETE FROM houses_bills WHERE `house_id` = ? AND `type` = ? AND `paid` = 0",
                                    { tonumber(propertyId), "rent" }
                                )

                                -- Remove unpaid rent bills from in-memory list (paid == 0 or paid == false)
                                for idx = #house.bills, 1, -1 do
                                    local b = house.bills[idx]
                                    if b.type == "rent" and (b.paid == 0 or b.paid == false) then
                                        table.remove(house.bills, idx)
                                    end
                                end

                                -- Lock and turn off lights
                                house.metadata.locked = true
                                house.metadata.lightState = false
                                house.metadata.lightStartTime = nil

                                -- Remove renter permissions entry
                                if house.permissions then
                                    house.permissions[renterIdentifier] = nil
                                end
                            else
                                -- No owner: treat as generic rental unit reset (also resets sale/rental actives)
                                updateQuery = [[
                                    UPDATE `houses`
                                        SET
                                            `renter` = NULL,
                                            `renter_name` = NULL,
                                            `keys` = @keys,
                                            `permissions` = @permissions,
                                            `metadata` = @metadata,
                                            `sale` = @sale,
                                            `rental` = @rental,
                                            `last_enter` = NULL
                                    WHERE id = @id
                                ]]

                                -- Always remove keys
                                house.keys = json.encode({})

                                -- Restore default sale/rental active states
                                if house.sale then
                                    house.sale.active = house.sale.defaultActive
                                end
                                if house.rental then
                                    house.rental.active = house.rental.defaultActive
                                end

                                -- Reset metadata flags
                                house.metadata.locked = true
                                house.metadata.contact_number = nil
                                house.metadata.lightState = false
                                house.metadata.lightStartTime = nil

                                -- Optional: remove all placed furniture on rent end
                                if Config.RemoveFurnitureOnRentEnd then
                                    house.furniture = {}

                                    MySQL.prepare(
                                        "DELETE FROM houses_furniture WHERE house_id = ?",
                                        { tonumber(propertyId) }
                                    )
                                end

                                -- Clear bills/permissions and clean DB
                                house.bills = {}
                                house.unpaidBills = 0
                                house.unpaidRentBills = nil

                                MySQL.prepare(
                                    "DELETE FROM houses_bills WHERE house_id = ?",
                                    { tonumber(propertyId) }
                                )

                                house.permissions = {}
                            end

                            -- Common cleanup
                            house.renter = nil
                            house.renter_name = nil
                            if house.rental then
                                house.rental.startTime = nil
                                house.rental.terminateAtPeriod = nil
                            end

                            -- Final ASYNC DB WRITE (uses named parameters)
                            MySQL.execute(updateQuery, {
                                ["@keys"]        = house.keys,
                                ["@permissions"] = json.encode(house.permissions),
                                ["@metadata"]    = json.encode(house.metadata),
                                ["@sale"]        = json.encode(house.sale),
                                ["@rental"]      = json.encode(house.rental),
                                ["@id"]          = tonumber(propertyId),
                            })
                        end
                    end
                end
            end
        end

        ------------------------------------------------------------------
        -- Debug output
        ------------------------------------------------------------------
        library.Debug(("^2VMS Housing init completed in %d ms^7"):format(GetGameTimer() - initStartMs))
        library.Debug(("Loaded %d Properies, %d Bills, %d Furniture"):format(
            #housesRows,
            billsRows and #billsRows or 0,
            placedFurnitureRows and #placedFurnitureRows or 0
        ))
    end)
end)

--=====================================================================
--  Pending deliveries worker
--=====================================================================
-- Runs only if DeliveryType is 2 or 3, periodically processing up to 200.
CreateThread(function()
    while true do
        local deliveryType = Config.DeliveryType
        if deliveryType ~= 2 and deliveryType ~= 3 then
            break
        end

        Citizen.Wait(8000)

        if next(PendingDeliveries) then
            -- SERVER / MODULE CALL
            ProcessPendingDeliveries(200)
        end

        -- Original code used Wait() here (kept to match behavior/env)
        Wait(30000)
    end
end)