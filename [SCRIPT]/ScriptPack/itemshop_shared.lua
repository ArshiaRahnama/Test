

-- FIX: esx_inventory isn't installed on this server at all (only
-- Unique_inventory is) - this 404'd for every single item image in
-- itemseller_config.lua. Pointed at Unique_inventory's real, existing
-- html/img/items/ icon folder (442 PNGs shipped there already) - some of
-- these custom item names (marijuana/cocaine/meth etc.) likely already have
-- a matching file, others (the animal-part names especially) probably
-- don't and will still show a broken image until someone adds them.
url = 'nui://Unique_inventory/html/img/items/'
