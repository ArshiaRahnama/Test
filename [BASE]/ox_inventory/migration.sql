-- Run this once on your database before starting the server with ox_inventory.
-- ox_inventory (framework: esx) reads/writes vehicle trunk & glovebox contents
-- directly on `owned_vehicles`, but these columns don't exist yet on this server.

ALTER TABLE `owned_vehicles`
    ADD COLUMN IF NOT EXISTS `trunk` longtext DEFAULT NULL,
    ADD COLUMN IF NOT EXISTS `glovebox` longtext DEFAULT NULL;

-- Nothing to migrate from `trunk_inventories` / `trunk_inventory` — both are empty
-- on your current database, so there is no existing trunk data to carry over.
