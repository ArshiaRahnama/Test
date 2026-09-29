-- VMS Housing - Unique_inventory client integration
if Config.Inventory ~= 'Unique_inventory' then return end

function OpenStorage(metadata)
    -- Unique_inventory از TriggerServerEvent استاندارد ESX استفاده میکنه
    -- باز کردن استش/storage خانه
    TriggerServerEvent('esx_addoninventory:openInventory', metadata.id)
end
