-- Run this once on your database before starting the server with ox_inventory.
-- ox_inventory (framework: esx) reads/writes vehicle trunk & glovebox contents
-- directly on `owned_vehicles`, but these columns don't exist yet on this server.

ALTER TABLE `owned_vehicles`
    ADD COLUMN IF NOT EXISTS `trunk` longtext DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS `glovebox` longtext DEFAULT NULL;

-- ox_inventory's real, per-slot player inventory save now lives in its own
-- column (see modules/mysql/server.lua) instead of `users`.`inventory`,
-- because essentialmode's own periodic/disconnect save also writes to
-- `inventory` with a completely different (non-slotted) format and was
-- overwriting ox_inventory's saved slot positions every time it ran.
ALTER TABLE `users`
    ADD COLUMN IF NOT EXISTS `ox_inventory_data` longtext DEFAULT NULL;

-- Nothing to migrate from `trunk_inventories` / `trunk_inventory` — both are empty
-- on your current database, so there is no existing trunk data to carry over.
