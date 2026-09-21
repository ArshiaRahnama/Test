--[[ ===========================================================================
    Unique_inventory | client/vehicle_target.lua

    ox_target: aim at the BOOT of any vehicle -> "باز کردن صندوق عقب".
    (ox_target must be started before this resource - it already is in
    server.cfg.) The inventory-key-in-vehicle glovebox lives in
    client/inventory_main.lua (OpenGlovebox).
=========================================================================== ]]

local Cfg = {
    label    = 'باز کردن صندوق عقب',
    icon     = 'fas fa-box-open',
    distance = 2.0,
}

local OPTION_NAME = 'unique_inventory:trunk'
local registered  = false

local function register()
    if registered then return end
    registered = true

    exports.ox_target:addGlobalVehicle({
        {
            name     = OPTION_NAME,
            icon     = Cfg.icon,
            label    = Cfg.label,
            bones    = { 'boot' },
            distance = Cfg.distance,
            canInteract = function(entity)
                if IsPedInAnyVehicle(PlayerPedId(), false) then return false end
                if CloseToVehicle then return false end -- a trunk is already open
                if NoTrunkClass and NoTrunkClass[GetVehicleClass(entity)] then return false end
                return true
            end,
            onSelect = function(data)
                -- locked / sentenced / limits are all checked inside openmenuvehicle
                openTrunk(data.entity)
            end,
        },
    })
end

CreateThread(function()
    -- wait until ox_target is up (and re-register if it restarts)
    while GetResourceState('ox_target') ~= 'started' do Wait(500) end
    register()
end)

AddEventHandler('onClientResourceStart', function(res)
    if res == 'ox_target' then
        registered = false
        Wait(500)
        register()
    end
end)

AddEventHandler('onClientResourceStop', function(res)
    if res == GetCurrentResourceName() and GetResourceState('ox_target') == 'started' then
        exports.ox_target:removeGlobalVehicle(OPTION_NAME)
    end
end)
