-- --------------------------------------------------------
-- Territory Control add-on for Unique_ALLGangs
-- Run this once against the SAME database as database.sql.
-- Zones themselves are defined in Config.Territory.Zones (Config.lua);
-- these tables only store the dynamic state (who owns what, and a
-- history log) so it survives restarts.
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `gang_territories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zone_key` varchar(50) NOT NULL,
  `owner_gang` varchar(254) DEFAULT NULL,
  `captured_at` int(255) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `zone_key` (`zone_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `gang_territory_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zone_key` varchar(50) DEFAULT NULL,
  `gang` varchar(254) DEFAULT NULL,
  `action` varchar(20) DEFAULT NULL, -- 'captured' | 'lost'
  `ts` int(255) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------
-- Everything below backs the 6 expansion systems (upgrades,
-- espionage, boss zone title, alliances). All optional - each is
-- gated by its own Config.Territory.<X>.Enabled switch.
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `gang_territory_upgrades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zone_key` varchar(50) NOT NULL,
  `upgrade_type` varchar(20) NOT NULL, -- 'alarm' | 'production' | 'fortify'
  `level` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `zone_upgrade` (`zone_key`, `upgrade_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `gang_alliances` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gang_a` varchar(254) NOT NULL,
  `gang_b` varchar(254) NOT NULL,
  `status` varchar(20) DEFAULT 'pending', -- 'pending' | 'active'
  PRIMARY KEY (`id`),
  UNIQUE KEY `pair` (`gang_a`, `gang_b`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE IF NOT EXISTS `gang_territory_titles` (
  `gang` varchar(254) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `earned_at` int(255) DEFAULT 0,
  PRIMARY KEY (`gang`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_persian_ci ROW_FORMAT=DYNAMIC;
