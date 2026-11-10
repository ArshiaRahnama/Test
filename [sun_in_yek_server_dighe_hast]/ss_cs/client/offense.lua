-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

RegisterNetEvent('cs:openOffenseMenu', function(...)
    openOffenseMenu(...)
end)

function openOffenseMenu(identifier, name, data, src, search)
    local ts = exports['sunset_utils']:GetServerOSTime()
    local options = {
        {label = ('%s %s'):format(identifier, name)},
        {label = ('Id : %s'):format(src or 'Offline')},
        {label = '-----Punishments-----'},
    }
    for k, v in pairs(Config.offense) do
        if not search or v.label:lower():find(search:lower()) then
            local count = 0
            for k2, v2 in pairs(data) do
                if v2.key == v.key and v2.expire > ts then
                    count = count + 1
                end
            end
            table.insert(options, {label = ('%s(%s)'):format(v.label, count), args = v})
        end
    end
    lib.registerMenu({
        id = 'cso_1',
        title = name,
        options = options
    }, function(selected, scrollIndex, args)
        if args then
            local offenseConfig = args
            local options = {
                {label = '🆕New🆕', args = 'new'}
            }
            local count = 0
            table.sort(data, function(a, b)
                return a.expire > b.expire
            end)
            for k2, v2 in pairs(data) do
                if v2.key == offenseConfig.key and v2.expire > ts then
                    count = count + 1
                    table.insert(options, {label = ('%s x%s %s %s'):format(v2.reason, v2.count, v2.sourceName, ESX.timeAgo(v2.start)), args = v2})
                end
            end
            lib.registerMenu({
                id = 'cso_2',
                title = offenseConfig.label,
                options = options,
                onClose = function()
                    lib.showMenu('cso_1')
                end
            }, function(selected, scrollIndex, args)
                if type(args) == 'string' and args == 'new' then
                    if count == 0 then
                        count = 1
                    elseif count < #offenseConfig.counts then
                        count = count + 1
                    end
                    local input = lib.inputDialog('Tedad va reason ra vared konid', {
                        {type = 'input', label = 'Reason'},
                        {type = 'number', label = 'Tedad', min = offenseConfig.min or 0, icon = 'hashtag', required = true, default = offenseConfig.counts[math.min(count, #offenseConfig.counts)]},
                    })
                    if input and input[1] and input[2] then
                        local reason, count = input[1], input[2]
                        TriggerServerEvent('cs:registerOffense', identifier, offenseConfig.key, reason, count)
                    end
                else
                    local alert = lib.alertDialog({
                        header = 'Hazf offense',
                        content = 'Aya az hazf offense etminan darid',
                        centered = true,
                        cancel = true
                    })
                    if alert == 'confirm' then
                        TriggerServerEvent('cs:removeOffense', identifier, args)
                    end
                end
            end)
            lib.showMenu('cso_2')
        end
    end)
    lib.showMenu('cso_1')
end

RegisterCommand('offense', function()
    if ESX.checkCooldown('offense', 5000) then
        ESX.TriggerServerCallback('cs:getOffense', function(result)
            showOffense(result)
        end)
    else
        ESX.chatMessage('Spam nakonid', 'plarms')
    end
end)

function showOffense(result)
    local options = {}
    if #result == 0 then
        table.insert(options, {label = 'offensi vojood nadarad👌'})
    else
        table.sort(result, function(a, b)
            return a.expire > b.expire
        end)
        local ts = exports['sunset_utils']:GetServerOSTime()
        for k, v in pairs(result) do
            if v.expire > ts then
                -- count = count + 1
                local label = ''
                for k2, v2 in pairs(Config.offense) do
                    if v.key == v2.key then
                        label = v2.label
                    end
                end
                table.insert(options, {label = ('%s(%s) x%s %s'):format(label, v.reason, v.count, ESX.timeAgo(v.start))})
            end
        end
    end
    lib.registerMenu({
        id = 'cso_3',
        title = 'List offense ha',
        options = options,
    }, function(selected, scrollIndex, args)
        
    end)
    lib.showMenu('cso_3')
end

RegisterNetEvent('cs:showOffense', function(result)
    showOffense(result)
end)

RegisterNetEvent('cs:offenseAlarm', function()
    local warnText = [[
/offense شما یک آفنس پانیشمنت دارید، جهت مشاهده لیست آفنس ها بزنید و آفنس خود را مشاهده کنید
]]
    TriggerEvent('txcl:showWarning','System',warnText, nil, true)
end)