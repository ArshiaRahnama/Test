-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

CreateThread(function()
    waitForLoad()
    ESX.RegisterCommand('openlog', function()
        if SUN.permission > 0 then
            local options = {}
            for k, v in pairs(logViewerConfig.list) do
                if SUN.permission >= v.permission then
                    table.insert(options, {label = v.label, value = v.key})
                end
            end

            local input = lib.inputDialog('Search dar log', {
                {type = 'input', label = 'Search context'},
                {type = 'select', label = 'Channel', options = options},
            })

            if input and input[1] and input[2] then
                TriggerServerEvent('logviewer:search', input[2], input[1])
            end
        end
    end, {help = 'baz kardan menu log'})
end)

RegisterNetEvent('logviewer:open', function(result)
    local elements = {
        head = {'TS','Date','Content'},
        rows = {}
    }
    for k, v in pairs(result) do
        table.insert(elements.rows, {
            ts = v.ts,
            cols = {
                v.ts,
                v.time,
                v.content,
            }
        })
    end
    table.sort(elements.rows, function(a, b)
        return a.ts > b.ts
    end)
    ESX.UI.Menu.Open('list2', GetCurrentResourceName(), 'loglsit', elements, function(data, menu)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end)