-- Optional: remove ownership/upgrade/log rows left over from the old city zones.
DELETE FROM gang_territories         WHERE zone_key IN ('grove_street','vespucci_beach','la_mesa_industrial','del_perro_pier','sandy_shores','paleto_bay');
DELETE FROM gang_territory_upgrades  WHERE zone_key IN ('grove_street','vespucci_beach','la_mesa_industrial','del_perro_pier','sandy_shores','paleto_bay');
