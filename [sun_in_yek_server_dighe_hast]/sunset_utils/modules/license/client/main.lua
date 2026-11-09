-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local licenses = nil
local function fetchLicense()
    local p = promise.new()
    ESX.TriggerServerCallback('license:getData', function(_licenses)
        licenses = _licenses
        p:resolve()
    end)
    Citizen.Await(p)
end

CreateThread(function()
    waitForLoad()
    ESX.registerCommand('license', function()
        if not licenses then
            fetchLicense()
        end
        local options = {}
        local ts = GetServerOSTime()
        for k, v in pairs(licenses) do
            if licenseConfig.licenses[k] then
                local expired = v.expire > 0 and ts > v.expire
                if expired then
                    table.insert(options, {label = ('%s - Expired❌'):format(licenseConfig.licenses[k].label), icon = 'x', description = ('%s - %s'):format(v.from, v.description or '')})
                else
                    table.insert(options, {label = ('%s - %s'):format(licenseConfig.licenses[k].label, v.expire > 0 and ESX.displayTime(v.expire - ts) or 'Permanent'), icon = 'id-card', description = ('%s - %s'):format(v.from, v.description or '')})
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
        }, function()
        end)
        lib.showMenu('licenceMenu1')
    end, {help = 'Namayesh license haye khod'})
end)

RegisterNetEvent('license:update', function(_licenses)
    licenses = _licenses
end)

local function openLicenseMenu()
    ESX.UI.Menu.CloseAll()
    ESX.selectPlayerMenu(function(src)
        ESX.TriggerServerCallback('license:getData', function(_licenses)
            local options = {}
            local ts = GetServerOSTime()
            for k, v in pairs(_licenses) do
                local config = licenseConfig.licenses[k]
                if config.viewAccess and (config.viewAccess.all or config.viewAccess[ESX.PlayerData.job.name]) and exports['sun-society']:doesHavePerm('view_license_'.. k) then
                    local expired = v.expire > 0 and ts > v.expire
                    if expired then
                        table.insert(options, {label = ('%s - Expired❌'):format(config.label), icon = 'x', args = {type = 'viewLicense', license = k}, description = ('%s - %s'):format(v.from, v.description or '')})
                    else
                        table.insert(options, {label = ('%s - %s'):format(config.label, v.expire > 0 and ESX.displayTime(v.expire - ts) or 'Pearmanet'), icon = 'id-card', args = {type = 'viewLicense', license = k}, description = ('%s - %s'):format(v.from, v.description or '')})
                    end
                end
            end
            if #options == 0 then
                table.insert(options, {label = 'Licensi baraye namayesh vojud nadarad'})
            end
            for k, v in pairs(licenseConfig.licenses) do
                if (v.addAccess.all or v.addAccess[ESX.PlayerData.job.name]) and exports['sun-society']:doesHavePerm('add_license_'.. k) then
                    table.insert(options, {label = 'Add '.. v.label, icon = 'plus', args = {type = 'add', license = k}})
                end
            end
            lib.registerMenu({
                id = 'licenceMenu1',
                title = 'License',
                options = options,
            }, function(selected, scrollIndex, args)
                local options = {}
                if args.type == 'viewLicense' then
                    if _licenses[args.license] then
                        local expired = _licenses[args.license].expire > 0 and ts > _licenses[args.license].expire
                        if expired then
                            table.insert(options, {label = ('Expired❌ - %s'):format(_licenses[args.license].expireString), icon = 'x', description = ('%s - %s'):format(_licenses[args.license].from, _licenses[args.license].description or '')})
                        else
                            table.insert(options, {label = ('%s - %s'):format(_licenses[args.license].startString, _licenses[args.license].expire > 0 and ESX.displayTime(_licenses[args.license].expire - ts) or 'Pearmanet'), icon = 'id-card', description = ('%s - %s'):format(_licenses[args.license].from, _licenses[args.license].description or '')})
                        end
                        if (licenseConfig.licenses[args.license].removeAccess.all or licenseConfig.licenses[args.license].removeAccess[ESX.PlayerData.job.name]) and exports['sun-society']:doesHavePerm('remove_license_'.. args.license) then
                            table.insert(options, {label = 'Remove license', icon = 'delete-left', args = 'remove'})
                        end
                    end
                    lib.registerMenu({
                        id = 'licenseMenu2',
                        title = 'License',
                        options = options,
                    }, function(selected, scrollIndex, _args)
                        if _args == 'remove' then
                            ESX.TriggerServerEvent('license:remove', src, args.license)
                        end
                    end)
                    lib.showMenu('licenseMenu2')
                elseif args.type == 'add' then
                    local config = licenseConfig.licenses[args.license]
                    -- if config.timing.permanent then
                        table.insert(options, {type = 'checkbox', label = 'Permanent', disabled = not config.timing.permanent})
                    -- end
                    -- if config.timing.time then
                        table.insert(options, {type = 'number', label = ('License time(Day %s- %s)'):format(config.timing.time[1], config.timing.time[2]), icon = 'calendar-days', min = config.timing.time[1], max = config.timing.time[2], disabled = not config.timing.time})
                    -- end
                    -- if config.description then
                        table.insert(options, {type = 'input', label = 'Description', icon = 'keyboard', disabled = not config.description})
                    -- end
                    local input = lib.inputDialog('License time', options)
                    if input and (input[1] or input[2]) then
                        if input[2] then
                            input[2] = ESX.Math.Round(input[2])
                        end
                        if input[1] or (input[2] >= config.timing.time[1] and input[2] <= config.timing.time[2]) then
                            local time = nil
                            if input[1] then
                                time = -1
                            end
                            ESX.TriggerServerEvent('license:add', src, args.license, time or input[2], input[3])
                        end
                    end
                end
            end)
            lib.showMenu('licenceMenu1')
        end, src)
    end, 5)
end

exports('openLicenseMenu', openLicenseMenu)
exports('getLicenseConfig', function()
    return licenseConfig
end)

function doesHaveLicense(name)
    local ts = GetServerOSTime()
    return licenses and licenses[name] and licenses[name].expire > 0 and ts < v.expire
end