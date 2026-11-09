-- apex_phone items for the ESX `items` table (essentialmode / Unique_inventory). Run ONCE.
-- Same columns/values style as the existing ('phone', 'Goshi', -1, 0, 1, 0.500) row. INSERT IGNORE = safe to re-run.
-- The generic `phone` item you already have keeps working (Config.PhoneItem = 'phone').
-- Item icons: copy apex_phone/inventory_images/*.png into your inventory's images folder.
INSERT IGNORE INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`, `weight`) VALUES
    ('airpods', 'AirBuds Pro', -1, 0, 1, 0.100),
    ('slate_buds', 'Slate Buds', -1, 0, 1, 0.100),
    ('esim', 'eSIM Card', -1, 0, 1, 0.010),
    ('sim_card', 'SIM Card', -1, 0, 1, 0.010),
    ('pear18_black', 'PearPhone 18 Pro Max Black', -1, 0, 1, 0.500),
    ('pear18_white', 'PearPhone 18 Pro Max White', -1, 0, 1, 0.500),
    ('pear18_ice', 'PearPhone 18 Pro Max Ice Blue', -1, 0, 1, 0.500),
    ('pear18_wine', 'PearPhone 18 Pro Max Burgundy', -1, 0, 1, 0.500),
    ('s26_black', 'NOVA S26 Ultra Black', -1, 0, 1, 0.500),
    ('s26_white', 'NOVA S26 Ultra White', -1, 0, 1, 0.500),
    ('s26_violet', 'NOVA S26 Ultra Violet', -1, 0, 1, 0.500),
    ('s26_sky', 'NOVA S26 Ultra Sky Blue', -1, 0, 1, 0.500),
    ('pearfold_night', 'PearPhone Fold Midnight Blue', -1, 0, 1, 0.500),
    ('pearfold_star', 'PearPhone Fold Star White', -1, 0, 1, 0.500),
    ('novaflip_lavender', 'NOVA Fold8 Lavender', -1, 0, 1, 0.500),
    ('novaflip_grey', 'NOVA Fold8 Grey', -1, 0, 1, 0.500),
    ('novaflip_cream', 'NOVA Fold8 Cream', -1, 0, 1, 0.500),
    ('novaflip_pistachio', 'NOVA Fold8 Pistachio', -1, 0, 1, 0.500);
