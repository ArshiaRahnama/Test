--[[ ===========================================================================
    Unique_inventory | client/vehicle_target.lua

    ox_target: aim at a vehicle while standing next to its trunk ->
    "باز کردن صندوق عقب". (ox_target must be started before this resource - it
    already is in server.cfg.) How close you must be: TrunkConfig.TrunkReach;
    cars with the storage in the FRONT: TrunkConfig.FrontTrunkModels
    (both in config_trunk.lua). The inventory-key-in-vehicle glovebox lives in
    client/inventory_main.lua (OpenGlovebox).
=========================================================================== ]]

local Cfg = {
    label = 'باز کردن صندوق عقب',
    icon  = 'fas fa-box-open',
}

local OPTION_NAME = 'unique_inventory:trunk'
local registered  = false

local function register()
    if registered then return end
    registered = true

    -- NOTE: no `bones = { 'boot' }` here. ox_target only shows a bone option when
    -- the crosshair is within ~1m of that exact bone, AND within `distance` of the
    -- player - so the option was practically invisible unless you stood right behind
    -- the car and aimed precisely at the boot (aiming at a door only ever showed
    -- "Toggle door"). Instead the option shows on any part of the vehicle and
    -- canInteract checks how far the PLAYER is from the trunk.
    exports.ox_target:addGlobalVehicle({
        {
            name     = OPTION_NAME,
            icon     = Cfg.icon,
            label    = Cfg.label,
            distance = TrunkConfig.TrunkReach, -- player -> crosshair hit point (anywhere on the car)
            canInteract = function(entity)
                if IsPedInAnyVehicle(PlayerPedId(), false) then return false end
                if CloseToVehicle then return false end -- a trunk is already open
                if NoTrunkClass and NoTrunkClass[GetVehicleClass(entity)] then return false end
                return true -- shows from anywhere on the car now, not just near the boot
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
