-- ================================================================= --
-- Auto migration — runs every time this resource starts.
-- ================================================================= --
-- Same pattern as Unique_LevelQuest's server/migrations.lua: checks
-- INFORMATION_SCHEMA before adding anything, so it's always safe to
-- run again on a database that already has the column. No manual
-- database.sql edits needed on servers that are already running.
--
-- Adds `items.weight` — the column the real item-weight fix in
-- server/common.lua (ESX.getItemWeight) and server/classes/player.lua
-- (inventory item stubs) reads from. Without this column the fix still
-- works (it falls back to Config.DefaultItemWeight for every item),
-- it just can't have PER-ITEM weights until this runs once.
-- ================================================================= --

local function columnExists(tableName, columnName, cb)
    MySQL.Async.fetchScalar([[
        SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = @t AND COLUMN_NAME = @c
    ]], { ['@t'] = tableName, ['@c'] = columnName }, function(count)
        cb(count ~= nil and count > 0)
    end)
end

local function ensureColumn(tableName, columnName, definitionSql)
    columnExists(tableName, columnName, function(exists)
        if exists then return end
        MySQL.Async.execute('ALTER TABLE `' .. tableName .. '` ADD COLUMN ' .. definitionSql, {}, function()
            print(('[essentialmode] migrated: added column %s.%s'):format(tableName, columnName))
        end)
    end)
end

local function ensureTable(tableName, createSql)
    MySQL.Async.execute('CREATE TABLE IF NOT EXISTS `' .. tableName .. '` (' .. createSql .. ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci', {})
end

CreateThread(function()
    ensureColumn('items', 'weight', "`weight` DECIMAL(10,3) NOT NULL DEFAULT 0.5")
    -- Which backpack (if any) a player currently has equipped - see
    -- Config.BackpackWeight / RecalculateMaxWeight below and the
    -- 'backpack' usable item in esx_inventory. NULL = none equipped.
    ensureColumn('users', 'equipped_backpack', "`equipped_backpack` VARCHAR(50) DEFAULT NULL")

    -- #1/#2/#15 — grid placement map: {"slot": {"name":..,"count":..}}.
    -- NULL for every existing player, which InitInventorySlots reads as
    -- "no map yet" and auto-places their whole inventory. So this is a
    -- zero-downtime migration: nobody loses anything, the first save
    -- after they log in writes their real layout.
    ensureColumn('users', 'invslots', "`invslots` LONGTEXT DEFAULT NULL")

    -- The three backpack items themselves (esx_inventory's
    -- server/custom/apps/backpack.lua RegisterUsableItem needs each one
    -- to already exist in ESX.Items, same as any other item). Safe to
    -- run every start - INSERT IGNORE only inserts a row the first time.
    MySQL.Async.execute([[
        INSERT IGNORE INTO items (name, label, `limit`, rare, can_remove, weight) VALUES
            ('backpack', 'Small Backpack', 1, 0, 1, 1.5),
            ('backpack_medium', 'Backpack', 1, 0, 1, 2),
            ('backpack_large', 'Large Backpack', 1, 0, 1, 3)
    ]], {})

    -- Vehicle glovebox storage (esx_inventory's server/custom/glovebox/glovebox.lua)
    ensureTable('lc_glovebox', "`plate` varchar(20) NOT NULL, `data` longtext DEFAULT NULL, PRIMARY KEY (`plate`)")
end)
