--[[
    client/license-cl.lua

    Fixed/adapted version of the license menu you uploaded. Changes made to fit
    your actual ScriptPack, and why:

      - waitForLoad() doesn't exist anywhere in your pack -> replaced with the
        same "while ESX == nil do ... end" loop every other file in this pack
        uses (see client/barbershop-cl.lua, commands-client.lua, etc.).

      - exports['sun-society']:doesHavePerm(...) doesn't exist on your server
        (you have esx_society, which is unrelated - it only handles job/society
        bank accounts, not permission checks) -> removed. Access is now decided
        purely by the addAccess/viewAccess/removeAccess job tables already in
        license_config.lua, same style your existing givelicense-sv.lua uses
        (xPlayer.job.name checks).

      - ESX.selectPlayerMenu doesn't exist in your framework (not es_extended
        Legacy's API here, and not used anywhere else in your pack) -> removed
        entirely. openLicenseMenu(target) is exported instead, and is now
        called directly from the F6 "Manage License" button in each
        esx_uniquejobs job file (see the scriptpack_update overlay's job
        patches) - there is no separate command for staff anymore.

      - GetServerOSTime() is not a real FiveM native (I misremembered it) and
        ESX.displayTime doesn't exist anywhere in this framework either (it
        was in the file you originally uploaded, carried over without being
        checked). Both are gone now. All expiry math (expired?, remaining
        time, formatted dates) is now done server-side in
        server/licensemenu-sv.lua using os.time()/os.date(), which DO work
        server-side, and sent to the client as ready strings
        (v.expired, v.remainingString, v.expireString, v.startString). The
        client no longer needs "the current time" at all.
]]

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end
end)

local licenses = nil

local function fetchLicense()
    local p = promise.new()
    ESX.TriggerServerCallback('license:getData', function(_licenses)
        licenses = _licenses
        p:resolve()
    end)
    Citizen.Await(p)
end

RegisterCommand('license', function()
    if not licenses then
        fetchLicense()
    end

    local options = {}

    for k, v in pairs(licenses) do
        if licenseConfig.licenses[k] then
            if v.expired then
                table.insert(options, {
                    label = ('%s - Expired❌'):format(licenseConfig.licenses[k].label),
                    icon = 'x',
                    description = ('%s - %s'):format(v.from, v.description or '')
                })
            else
                table.insert(options, {
                    label = ('%s - %s'):format(licenseConfig.licenses[k].label, v.remainingString),
                    icon = 'id-card',
                    description = ('%s - %s'):format(v.from, v.description or '')
                })
            end
        end
    end

    if #options == 0 then
        table.insert(options, {label = 'Shoma licensi jahat namayesh nadarid!'})
    end

    lib.registerMenu({
        id = 'licenceMenu1',
        title = 'License haye shoma',
        options = options,
    }, function() end)

    lib.showMenu('licenceMenu1')
end, false)

RegisterNetEvent('license:update', function(_licenses)
    licenses = _licenses
end)

-------------------------------------------------------
-- icon per license type, for a nicer-looking menu
-------------------------------------------------------
local LICENSE_ICONS = {
    ['drive_1']       = 'car',
    ['drive_2']       = 'motorcycle',
    ['drive_3']       = 'truck',
    ['drive_4']       = 'id-card',
    ['drive_5']       = 'plane',
    ['drive_6']       = 'ship',
    ['drive_7']       = 'helicopter',
    ['hunt_l1']       = 'crosshairs',
    ['stepson_1']     = 'gavel',
    ['marriage_1']    = 'gavel',
    ['ceremony_1']    = 'gavel',
    ['mojavezgun_1']  = 'shield-halved',
    ['mojavezvest_1'] = 'shirt',
    ['salamateravan'] = 'heart-pulse',
}

local function LicenseIcon(key)
    return LICENSE_ICONS[key] or 'id-card'
end

-------------------------------------------------------
-- staff menu to view/add/remove a license for a target player
-- called from F6 (esx_uniquejobs "Manage License" button) via:
--   exports['ScriptPack']:openLicenseMenu(targetServerId)
-- (there is no standalone command for this - F6 is the only entry point)
-------------------------------------------------------
local function openViewMenu(target, targetName, _licenses)
    local options = {}

    for k, v in pairs(_licenses) do
        local config = licenseConfig.licenses[k]
        if config and (config.viewAccess.all or config.viewAccess[ESX.PlayerData.job.name]) then
            if v.expired then
                table.insert(options, {label = ('%s - Expired❌'):format(config.label), icon = 'x', args = {license = k}, description = ('%s - %s'):format(v.from, v.description or '')})
            else
                table.insert(options, {label = ('%s - %s'):format(config.label, v.remainingString), icon = LicenseIcon(k), args = {license = k}, description = ('%s - %s'):format(v.from, v.description or '')})
            end
        end
    end

    if #options == 0 then
        table.insert(options, {label = 'Licensi baraye namayesh vojud nadarad'})
    end

    lib.registerMenu({
        id = 'licenceViewMenu',
        title = ('📋 Licenses - %s'):format(targetName),
        options = options,
        onClose = function() lib.showMenu('licenceMainMenu') end,
    }, function(selected, scrollIndex, args)
        if not args then return end

        local lic = _licenses[args.license]
        if not lic then return end

        local subOptions = {}

        if lic.expired then
            table.insert(subOptions, {label = ('Expired❌ - %s'):format(lic.expireString), icon = 'x', description = ('%s - %s'):format(lic.from, lic.description or '')})
        else
            table.insert(subOptions, {label = ('%s - %s'):format(lic.startString, lic.remainingString), icon = LicenseIcon(args.license), description = ('%s - %s'):format(lic.from, lic.description or '')})
        end

        local config = licenseConfig.licenses[args.license]
        if config.removeAccess.all or config.removeAccess[ESX.PlayerData.job.name] then
            table.insert(subOptions, {label = '🗑️ Remove license', icon = 'delete-left', args = 'remove'})
        end

        lib.registerMenu({
            id = 'licenceViewDetail',
            title = config.label,
            options = subOptions,
            onClose = function() lib.showMenu('licenceViewMenu') end,
        }, function(selected2, scrollIndex2, subArgs)
            if subArgs == 'remove' then
                TriggerServerEvent('license:remove', target, args.license)
                lib.hideMenu()
            end
        end)
        lib.showMenu('licenceViewDetail')
    end)

    lib.showMenu('licenceViewMenu')
end

local function openAddMenu(target)
    local options = {}

    for k, v in pairs(licenseConfig.licenses) do
        if v.addAccess.all or v.addAccess[ESX.PlayerData.job.name] then
            table.insert(options, {label = v.label, icon = LicenseIcon(k), args = {license = k}})
        end
    end

    if #options == 0 then
        table.insert(options, {label = 'Shoma dastresi be add hich license nadarid'})
    end

    lib.registerMenu({
        id = 'licenceAddMenu',
        title = '➕ Add License',
        options = options,
        onClose = function() lib.showMenu('licenceMainMenu') end,
    }, function(selected, scrollIndex, args)
        if not args then return end

        local config = licenseConfig.licenses[args.license]
        local dialogOptions = {}

        table.insert(dialogOptions, {type = 'checkbox', label = 'Permanent', disabled = not config.timing.permanent})
        table.insert(dialogOptions, {type = 'number', label = ('License time (Day %s-%s)'):format(config.timing.time[1], config.timing.time[2]), icon = 'calendar-days', min = config.timing.time[1], max = config.timing.time[2], disabled = not config.timing.time})
        table.insert(dialogOptions, {type = 'input', label = 'Description', icon = 'keyboard', disabled = not config.description})

        local input = lib.inputDialog(config.label, dialogOptions)
        if input and (input[1] or input[2]) then
            if input[2] then
                input[2] = ESX.Math.Round(input[2])
            end

            local time = nil
            if input[1] then
                time = -1
            end

            TriggerServerEvent('license:add', target, args.license, time or input[2], input[3])
        end
    end)

    lib.showMenu('licenceAddMenu')
end

local function openLicenseMenu(target)
    if not target then
        return
    end

    ESX.UI.Menu.CloseAll()

    ESX.TriggerServerCallback('license:getData', function(_licenses, targetName)
        targetName = targetName or ('Player %d'):format(target)

        lib.registerMenu({
            id = 'licenceMainMenu',
            title = ('🪪 Manage License - %s'):format(targetName),
            options = {
                {label = '📋 View / Manage Licenses', icon = 'list-check', args = 'view'},
                {label = '➕ Add License',              icon = 'plus',      args = 'add'},
            },
        }, function(selected, scrollIndex, args)
            if args == 'view' then
                openViewMenu(target, targetName, _licenses)
            elseif args == 'add' then
                openAddMenu(target)
            end
        end)

        lib.showMenu('licenceMainMenu')
    end, target)
end

exports('openLicenseMenu', openLicenseMenu)
exports('getLicenseConfig', function()
    return licenseConfig
end)
