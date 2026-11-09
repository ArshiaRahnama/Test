-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

function initMenu()
    lib.registerRadial({
        id = 'prime_menu',
        items = {
            {
                label = 'منوی انیمیشن ها',
                icon = 'face-smile-wink',
                onSelect = function()
                    exports['sun-animmenu']:openMenu(true)
                end
            },
            {
                label = 'تغییر رنگ بج',
                icon = 'star',
                onSelect = function()
                    openBadgeColorMenu()
                end
            },
        }
    })

    lib.addRadialItem({
        id = 'prime',
        icon = 'crown',
        label = 'پرایم',
        menu = 'prime_menu'
    })

    local primeColor = GetResourceKvpInt('prime:color')
    if primeColor and primeColor > 0 then
        ESX.SetPlayerState('pColor', primeColor)
    end
end

function openBadgeColorMenu()
    local options = {}
    for k, v in pairs(primeConfig.badgeColors) do
        if v.point >= point then
            table.insert(options, {label = v.label, args = v.color})
        end
    end
    lib.registerMenu({
        id = 'prime_color',
        title = 'رنگ بدج',
        options = options
    }, function (selected, scrollIndex, args, checked)
        ESX.SetPlayerState('pColor', args)
        SetResourceKvpInt('prime:color', args)
        ESX.notification('success', 'تغییر کرد')
    end)
    lib.showMenu('prime_color')
end

function updateMenu(update)
    local data = {
        point = point,
        endTime = {},
    }

    if isPrimeActive() then
        local ts = exports['sunset_utils']:GetServerOSTime()
        local d, h, m, s = ESX.secondsToTimeComponents(primeEndTS - ts)
        data.endTime = {
            day = d,
            hour = h,
            minute = m,
            second = s
        }
    end

    data.rewards = primeConfig.rewards
    for k, v in pairs(data.rewards) do
        if primeReward[v.key] then
            v.received = true
        end
    end
    SendNUIMessage({
        app = 'sun-prime',
        method = update and 'update' or 'open',
        data = {
            config = data,
        }
    })
end
function openPrimeMenu()
    updateMenu()
    SetNuiFocus(true, true)
end

RegisterCommand('prime', function()
    if ESX.permission_level >= 20 then
        openPrimeMenu()
    end
end)


RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    cb()
end)

RegisterNUICallback('GetReward', function(data, cb)
    ESX.TriggerServerEvent('prime:getReward', data.reward.key)
    Wait(3000)
    updateMenu(true)
    cb('ok')
end)