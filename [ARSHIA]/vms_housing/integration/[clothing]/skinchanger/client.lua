-- VMS Housing - skinchanger integration
if Config.Clothing ~= 'skinchanger' then return end

function OpenWardrobe()
    -- skinchanger UI رو با TriggerEvent باز میکنه
    TriggerEvent('skinchanger:openMenu')
end
