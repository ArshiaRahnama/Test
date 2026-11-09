-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local State = {
    inQueue      = false,
    currentOffer = nil,
}

AddEventHandler('sundl:smallmenu:joinQueue', function(cats)
    TriggerServerEvent('dispatch:queue:join', cats)
end)

AddEventHandler('sundl:smallmenu:leaveQueue', function()
    TriggerServerEvent('dispatch:queue:leave')
end)

AddEventHandler('sundl:smallmenu:lostPick', function(reportId)
    TriggerServerEvent('dispatch:lost:pick', reportId)
end)

RegisterNetEvent('dispatch:queue:joined', function(cats)
    State.inQueue = type(cats) == 'table' and #cats > 0
    if ESX and ESX.ShowNotification then
        ESX.ShowNotification(ConfigDispatch.Text.JoinedQueues)
    end
end)

RegisterNetEvent('dispatch:queue:left', function()
    State.inQueue = false
    if ESX and ESX.ShowNotification then
        ESX.ShowNotification(ConfigDispatch.Text.LeftQueue)
    end
end)

RegisterNetEvent('dispatch:queue:membership', function(data)
    local cats = (data and data.cats) or {}
    State.inQueue = #cats > 0
    TriggerEvent('sundl:smallmenu:membershipChanged', cats, data and data.manager, data and data.count)
end)

RegisterNetEvent('dispatch:queue:count', function(count)
    TriggerEvent('sundl:smallmenu:queueCount', count)
end)

RegisterNetEvent('dispatch:queue:err', function(err)
    local function notify(msg, kind)
        if lib and lib.notify then
            lib.notify({ title = 'Dispatch', description = msg, type = kind or 'error', position = 'top', duration = 3500 })
        elseif ESX and ESX.ShowNotification then
            ESX.ShowNotification(msg)
        end
    end
    if err == 'already' then
        notify(ConfigDispatch.Text.AlreadyInQueue, 'inform')
    elseif err == 'noperm' then
        notify(ConfigDispatch.Text.NoPermission, 'error')
    elseif err == 'busy' then
        notify(ConfigDispatch.Text.Busy, 'error')
    elseif err == 'spam' then
        notify(ConfigDispatch.Text.Spam or 'Spam nakon!', 'error')
    elseif type(err) == 'string' and err:sub(1, 9) == 'cooldown:' then
        local remain = tonumber(err:sub(10)) or ConfigDispatch.RejoinCooldown
        notify(string.format(ConfigDispatch.Text.Cooldown, remain), 'error')
    end
end)

RegisterNetEvent('dispatch:notify', function(msg)
    if ESX and ESX.ShowNotification then ESX.ShowNotification(msg) end
end)

RegisterNetEvent('dispatch:offer', function(data)
    if not data or not data.id then return end
    State.currentOffer = data.id
    TriggerEvent('InteractSound_CL:PlayOnOne', "pdj", 0.1)
    TriggerEvent('sundl:offer:show', data)
end)

RegisterNetEvent('dispatch:offer:result', function(data)
    State.currentOffer = nil
    TriggerEvent('sundl:offer:hide')
    if not data then return end

    if data.ok then
        if ESX and ESX.ShowNotification then
            ESX.ShowNotification(string.format('Pasokh: /ar %s', tostring(data.id)))
        end
        if data.withSpectate and data.targetId then
            ExecuteCommand('sp ' .. tostring(data.targetId))
            TriggerEvent('sundl:offer:armAR', tostring(data.targetId))
        end
    end
end)

AddEventHandler('sundl:offer:userAccept', function(reportId)
    TriggerServerEvent('dispatch:offer:accept', reportId)
    State.currentOffer = nil
end)

AddEventHandler('sundl:offer:userAcceptSpectate', function(reportId)
    TriggerServerEvent('dispatch:offer:acceptSpectate', reportId)
    State.currentOffer = nil
end)

local State_MySrc = nil
local function myServerId()
    if not State_MySrc or State_MySrc <= 0 then
        State_MySrc = GetPlayerServerId(PlayerId())
    end
    return State_MySrc or 0
end

local function processHiddenSet(items)
    local me = myServerId()
    local toHide = {}
    local mine   = {}
    for _, it in ipairs(items or {}) do
        if it and it.id then
            local owner = tonumber(it.owner) or 0
            if owner == me then
                mine[#mine+1] = it.id
            else
                toHide[#toHide+1] = it.id
            end
        end
    end
    TriggerEvent('dispatch:hidden:fromServer', toHide, mine)
end

RegisterNetEvent('dispatch:hidden:set', function(items)
    processHiddenSet(items or {})
end)


local function offerActive() return State.currentOffer ~= nil end

local function sendOfferAction(action)
    if not ESX or not ESX.GetPlayerData then return end
    local xPlayer = ESX.GetPlayerData()
    if not xPlayer or (xPlayer.permission_level or 0) < ConfigDispatch.Perm.Admin then return end
    if not offerActive() then return end
    TriggerEvent('sundl:offer:command', action)
end

RegisterCommand('arq', function()
    sendOfferAction('accept')
end, false)

RegisterCommand('ars', function()
    sendOfferAction('acceptSpectate')
end, false)


RegisterCommand('eq', function()
    if not ESX or not ESX.GetPlayerData then return end
    local xPlayer = ESX.GetPlayerData()
    if not xPlayer or (xPlayer.permission_level or 0) < ConfigDispatch.Perm.Admin then return end
    if State.inQueue then
        TriggerServerEvent('dispatch:queue:leave')
    else
        TriggerEvent('sundl:smallmenu:openJoin')
    end
end, false)

AddEventHandler('esx:playerLoaded', function(xPlayer)
    if not xPlayer or (xPlayer.permission_level or 0) < ConfigDispatch.Perm.Admin then return end

    TriggerEvent('chat:addSuggestion', '/eq', 'Vared/khoroj az safe dispatch (admin)')
    TriggerEvent('chat:addSuggestion', '/arq', 'Ghabool kardan offer popup (Command — ghabel-e bind)')
    TriggerEvent('chat:addSuggestion', '/ars', 'Ghabool va spectate az offer popup (Command — ghabel-e bind)')
    SetTimeout(2000, function()
        ESX.TriggerServerCallback('dispatch:hidden:fetch', function(items)
            processHiddenSet(items or {})
        end)
    end)
end)