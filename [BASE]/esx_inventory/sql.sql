CREATE TABLE `lc_clothes` (
  `id` int(11) NOT NULL,
  `type` varchar(60) NOT NULL,
  `identifier` varchar(60) DEFAULT NULL,
  `name` longtext DEFAULT NULL,
  `data` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `lc_trunk` (
  `info` longtext DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `lc_clothes`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `lc_clothes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

ALTER TABLE `lc_trunk`
  ADD UNIQUE KEY `id` (`id`);
COMMIT;

-- Generic shared-storage container (server/apps/system/stash.lua),
-- used e.g. by Unique_ALLGangs' gang armories via exports('stash', ...).
CREATE TABLE IF NOT EXISTS `stashs` (
  `stash` varchar(60) NOT NULL,
  `inventory` longtext DEFAULT NULL,
  PRIMARY KEY (`stash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
COMMIT;

-- Property (house) chest storage (server/custom/property/property.lua).
-- Previously this whole feature was a stub with nowhere to persist to;
-- this table is new.
CREATE TABLE IF NOT EXISTS `lc_property` (
  `property_id` varchar(60) NOT NULL,
  `data` longtext DEFAULT NULL,
  PRIMARY KEY (`property_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
COMMIT;

-- Vehicle glovebox storage (server/custom/glovebox/glovebox.lua) - a
-- small items-only container separate from the trunk. Also created
-- automatically by essentialmode/server/migrations.lua on server start,
-- this is just here for reference/manual installs.
CREATE TABLE IF NOT EXISTS `lc_glovebox` (
  `plate` varchar(20) NOT NULL,
  `data` longtext DEFAULT NULL,
  PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
COMMIT;

