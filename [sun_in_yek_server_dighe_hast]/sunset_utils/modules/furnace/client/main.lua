-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local createdMarker = {}
local currentZone

local function getHelpMenuConfig()
    local text = {}

    for k, v in pairs(furnaceConfig.locations[currentZone].itemsConfig) do
        local label = ''
        for k, v in pairs(v.needs) do
            label = ('%s%sx %s '):format(label, v, ESX.getItemLabel(k))
        end
        label = ('%s=> '):format(label)
        for k, v in pairs(v.give) do
            label = ('%s%sx %s '):format(label, v, ESX.getItemLabel(k))
        end
        if v.fuel then
            label = ('%s | %sx Sookht'):format(label, v.fuel)
        end
        table.insert(text, {
            text = label
        })
    end
    table.insert(text, {
        text = '--------سوخت ها--------'
    })
    for k, v in pairs(furnaceConfig.fuel) do
        local label = ''
        label = ('%s%s : %sx '):format(label, ESX.getItemLabel(v.name), v.count)
        table.insert(text, {
            text = label
        })
    end

    local config = {
        menu = {
            { id = 'furnace', title = 'راهنمای کوره', contentType = 'furnace', allowed = {} },
        },
        content = {
            furnace = {
                {
                    id = 'furnace',
                    title = 'کوره',
                    shortDis = 'لیست کوره',
                    icon = 'https://cdn.sunrp.ir/other/furnace.png',
                    video = false,
                    audio = false,
                    image = text,
                    allowed = {}
                },
            }
        }
    }
    local data = {
        app = 'sun-helpmenu',
        method = 'open',
        data = {
            allowed = {''},
            helpConfig = config,
        }
    }
    return data
end

local function openMenu()
    if ESX.checkCooldown('furnace', 2000) then
        ESX.TriggerServerCallback('furnace:getStatus', function(status, fuelCount, isOn)
            local options = {
                {label = 'Voroodi', args = 'input'},
                {label = 'Khorooji', args = 'output'},
                {label = isOn and 'Khamoosh kardan🌑' or 'Rooshan Kardan🌕', args = 'toggle'},
                {label = ('Vaziat : %s'):format(status or 'Nothing'), args = ''},
                {label = ('Sookht : %sx'):format(fuelCount or 0), args = ''},
                {label = 'Help', args = 'help'},
            }

            if furnaceConfig.locations[currentZone].owner[ESX.identifier] or ESX.tableFind(furnaceConfig.locations[currentZone].owner, ESX.identifier) then
                table.insert(options, {label = 'Tanzim Webhook', args = 'webhook'})
            end

            lib.registerMenu({
                id = 'furnace_1',
                title = 'Furnace',
                options = options
            }, function(selected, scrollIndex, args)
                if args == 'help' then
                    exports['sun-helpmenu']:open(getHelpMenuConfig())
                elseif args == 'input' then
                    exports['sun-inventory-hud']:openInventory('furnace:input:'.. currentZone)
                elseif args == 'output' then
                    if ESX.doesHaveGangPerm('furnaceWithdraw') then
                        exports['sun-inventory-hud']:openInventory('furnace:output:'.. currentZone)
                    else
                        ESX.Alert('', 'Dastresi kafi nadarid', 7000, 'error')
                    end
                elseif args == 'webhook' then
                    local input = lib.inputDialog('Webhook ra vared konid', {
                        {type = 'input', label = 'Webhook'},
                    })
                    if input and input[1] then
                        if ESX.isValidURL(input[1]) then
                            ESX.TriggerServerEvent('furnace:setWebhook', currentZone, input[1])
                        else
                            ESX.Alert('', 'Link vared shode eshtebah ast', 7000, 'error')
                        end
                    end
                elseif args == 'toggle' then
                    ESX.TriggerServerEvent('furnace:toggle', currentZone)
                    Wait(500)
                    openMenu()
                end
            end)
            lib.showMenu('furnace_1')
        end, currentZone)
    end
end

local function loadMarkers()
    for k, v in pairs(furnaceConfig.locations) do
        if not createdMarker[k] and v.access[ESX.PlayerData.gang.name] then
            createdMarker[k] = true
            for k2, v2 in pairs(v.coords) do
                ESX.RegisterPoint(v2 - vec(0, 0, 1), 3,{
                    Color = {R = 255,G = 0,B = 0,A = 255},
                    DrawDistance = 5,
                    Radius = 1.0,
                    Type = 5
                },{
                    Notification = '~INPUT_CONTEXT~ jahat baz kardan kooreh',
                    Key = 'e',
                    CB = function()
                        if v.access[ESX.PlayerData.gang.name] then
                            currentZone = k
                            openMenu()
                        end
                    end,
                },{
                    In = nil,
                    Out = function()
                        ESX.closeAll()
                    end
                })
            end
        end
    end
end

RegisterNetEvent('esx:setGang', function()
    Wait(1000)
    loadMarkers()
end)

CreateThread(function()
    waitForLoad()
    loadMarkers()
end)