-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local inTrade, readyCooldown = false, false

local function startTrade(target)
    if not inTrade then
        ESX.TriggerServerEvent('trade:start', target)
    end
end
exports('startTrade', startTrade)

local function blockedTradeItem(name, itemType)
    if type(name) ~= 'string' then return true end
    if name:find('key_') or name:find('pack_') then return true end
    if ESX.doesBlockedItem(name) and name ~= 'persuit_1' then return true end
    local job = ESX.GetPlayerData().job
    if job and ESX.doesBlockedItemJob(name, job.name) then return true end
    if itemType ~= 'weapon' and exports['sunset_clothe']:getClotheData(name) then return true end
    return false
end

local function tradeUICallback(data)
    if not inTrade or type(data) ~= 'table' then return end
    local key = data.key
    if key == 'money' then
        local v = tonumber(data.value)
        if v and v >= 0 then
            if v > ESX.GetPlayerData().bank then v = ESX.GetPlayerData().bank end
            ESX.TriggerServerEvent('trade:update', {type = 'money', amount = ESX.Math.Round(v)})
        end
    elseif key == 'cancel' then
        ESX.TriggerServerEvent('trade:cancel')
    elseif key == 'message' then
        TriggerServerEvent('trade:updateMessage', data.value)
    elseif key == 'ready' then
        if readyCooldown then return ESX.Alert('', 'Spam nakonid', 3000, 'warning') end
        readyCooldown = true
        SetTimeout(3000, function() readyCooldown = false end)
        ESX.TriggerServerEvent('trade:update', {type = 'ready'})
    elseif key == 'addItem' then
        if type(data.value) == 'table' and data.value.name then
            if blockedTradeItem(data.value.name, data.value.type) then
                return ESX.notification('error', 'این آیتم قابل معامله نیست')
            end
            ESX.TriggerServerEvent('trade:update', {type = 'addItem', data = data.value})
        end
    elseif key == 'removeItem' then
        if type(data.value) == 'table' then
            ESX.TriggerServerEvent('trade:update', {type = 'removeItem', data = data.value})
        end
    elseif key == 'itemCount' then
        local d = data.value
        if type(d) == 'table' then
            d.count = tonumber(d.count)
            if d.type == 'item' and d.count and d.count > 0 then
                ESX.TriggerServerEvent('trade:update', {type = 'itemCount', data = d})
            end
        end
    end
end
exports('tradeUICallback', tradeUICallback)

RegisterNetEvent('trade:enterTrade', function(target, targetName)
    inTrade = true
    exports['sun-inventory-hud']:openTrade(targetName or ('#' .. tostring(target)))
end)

RegisterNetEvent('trade:pendingTrade', function(owner, ownerName)
    inTrade = true
    local label = ownerName or ('#' .. tostring(owner))
    exports['sun-inventory-hud']:setPendingTrade(owner, label)
    ESX.Alert('معامله', ('درخواست معامله از «%s» — برای باز کردن میز F2 را بزنید'):format(label), 8000, 'info')
end)

RegisterNetEvent('trade:render', function(state)
    if type(state) == 'table' then
        exports['sun-inventory-hud']:tradeMessage(state)
    end
end)

RegisterNetEvent('trade:updateMessage', function(message)
    exports['sun-inventory-hud']:tradeMessage({message = message})
end)

RegisterNetEvent('trade:close', function()
    if inTrade then
        inTrade = false
        exports['sun-inventory-hud']:closeTrade()
    end
end)
