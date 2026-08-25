-- Temporary debug relay: prints what happens client-side when F2 is pressed
-- directly into the SERVER console, so it shows up in the log you paste here.
-- Safe to delete this file once the real problem is found and fixed.

RegisterNetEvent('ox_inventory:debugClientLoad')
AddEventHandler('ox_inventory:debugClientLoad', function(ok, msg)
    local src = source
    if ok then
        print(('^2[ox_inventory DEBUG] Player %s: client.lua loaded fine (lib present).^0'):format(src))
    else
        print(('^1[ox_inventory DEBUG] Player %s: client.lua FAILED to load — %s^0'):format(src, tostring(msg)))
    end
end)

RegisterNetEvent('ox_inventory:debugKeyPress')
AddEventHandler('ox_inventory:debugKeyPress', function()
    local src = source
    print(('^3[ox_inventory DEBUG] Player %s pressed F2 (inv keybind fired client-side).^0'):format(src))
end)

RegisterNetEvent('ox_inventory:debugKeyError')
AddEventHandler('ox_inventory:debugKeyError', function(err)
    local src = source
    print(('^1[ox_inventory DEBUG] Player %s got a client-side error opening inventory: %s^0'):format(src, tostring(err)))
end)
