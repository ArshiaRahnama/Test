if Config.Inventory ~= 'tgiann-inventory' then
    return
end

function OpenStorage(metadata)
    exports["tgiann-inventory"]:OpenInventory("stash", metadata.id, { maxweight = metadata.weight, slots = metadata.slots })
end