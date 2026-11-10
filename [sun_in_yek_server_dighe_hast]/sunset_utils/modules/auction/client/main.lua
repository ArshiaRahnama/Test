-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local MODULE = 'auction'
local panelOpen = false

local function getMyGangLevel()
    local gang = ESX.PlayerData and ESX.PlayerData.gang
    if not gang or not gang.name or gang.name == 'nogang' then return 0 end
    local ok, lvl = pcall(function() return exports['gangprop']:getGangLevel() end)
    if ok and type(lvl) == 'number' then return lvl end
    return 0
end

local function computeMinNext(cfg, key, currentBid)
    local currentValue = currentBid
    local currentValueDefault = false
    if not currentValue then
        if cfg.list[key].min then
            currentValue = cfg.list[key].min
            currentValueDefault = true
        end
    end
    local miniumBid = 0
    local loopCount = 0
    if not currentValueDefault then
        for k, v in pairs(cfg.range) do
            loopCount = loopCount + 1
            if currentValue < k or loopCount == ESX.tableLength(cfg.range) then
                miniumBid = v
                break
            end
        end
    end
    return (currentValue or 0) + miniumBid
end

local function buildBundle(result, active, configName, cfg, remaining, money, gangLevel, adminData)
    local isAdmin = (SUN and SUN.permission or 0) >= AuctionConfig.AdminLevel
    local myGang = ESX.PlayerData.gang and ESX.PlayerData.gang.name
    local inGang = myGang and myGang ~= 'nogang'

    local bundle = {
        isAdmin = isAdmin,
        adminLevel = AuctionConfig.AdminLevel,
        activeName = (active and configName) or nil,
        admin = adminData,
    }

    if inGang then
        bundle.gang = {
            name = myGang,
            grade = ESX.PlayerData.gang.grade,
            level = gangLevel or 0,
            money = money or 0,
        }
    end

    if active and configName and cfg then
        local elig
        if not inGang then
            elig = { ok = false, reason = 'noGang' }
        elseif ESX.TableContainsValue(cfg.blackList, myGang) then
            elig = { ok = false, reason = 'blacklist' }
        elseif #cfg.allowList > 0 and not ESX.TableContainsValue(cfg.allowList, myGang) then
            elig = { ok = false, reason = 'notAllowed' }
        elseif (gangLevel or 0) < (cfg.gangLevel or 0) then
            elig = { ok = false, reason = 'level', need = cfg.gangLevel }
        else
            elig = { ok = true }
        end
        bundle.eligible = elig

        local items = {}
        local anyOpen = false
        for k, it in ipairs(cfg.list) do
            local bid = result and result.list and result.list[k]
            local reserved = (it.gang and #it.gang > 0) and it.gang or nil
            local canBid = elig.ok
            if reserved then
                canBid = false
                if inGang then
                    for _, g in ipairs(reserved) do
                        if g == myGang then
                            canBid = true
                            break
                        end
                    end
                end
            end
            if canBid then anyOpen = true end
            items[#items + 1] = {
                key = k,
                label = it.label,
                currentBid = (bid and bid.amount) or 0,
                currentGang = (bid and bid.gang) or nil,
                minNextBid = computeMinNext(cfg, k, bid and bid.amount or nil),
                mine = (bid and inGang and bid.gang == myGang) or false,
                reserved = reserved,
                canBid = canBid,
            }
        end
        bundle.anyOpen = anyOpen
        bundle.active = {
            configName = configName,
            label = cfg.label or configName,
            remaining = remaining or 0,
            extendTime = cfg.extendTime or 2,
            items = items,
        }
    else
        bundle.eligible = { ok = false, reason = 'noAuction' }
    end

    return bundle
end

local function fetchAndBuild(cb)
    local isAdmin = (SUN and SUN.permission or 0) >= AuctionConfig.AdminLevel
    ESX.TriggerServerCallback('auction:getList', function(result, active, configName, cfg, remaining)
        local gangLevel = getMyGangLevel()
        local myGang = ESX.PlayerData.gang and ESX.PlayerData.gang.name
        local inGang = myGang and myGang ~= 'nogang'

        local function finish(money, adminData)
            cb(buildBundle(result, active, configName, cfg, remaining, money, gangLevel, adminData), active, isAdmin)
        end
        local function afterMoney(money)
            if isAdmin then
                ESX.TriggerServerCallback('auction:getAdminData', function(ad) finish(money, ad) end)
            else
                finish(money, nil)
            end
        end

        if inGang then
            ESX.TriggerServerCallback('gangs:getGangMoney', function(m) afterMoney(m or 0) end)
        else
            afterMoney(0)
        end
    end)
end

local function openPanel()
    if panelOpen then return end
    fetchAndBuild(function(bundle, active, isAdmin)
        if not active and not isAdmin then
            return ESX.chatMessage('Mozayede fa\'al nist', 'gang')
        end
        panelOpen = true
        SUN.OpenUI(MODULE, bundle, { type = 'panel' })
    end)
end

local function closePanel()
    if not panelOpen then return end
    panelOpen = false
    SUN.CloseUI(MODULE)
end

local function refreshPanel()
    if not panelOpen then return end
    fetchAndBuild(function(bundle)
        SUN.SendUIData(MODULE, { type = 'bundle', data = bundle })
    end)
end

AddEventHandler('auction:open', function()
    openPanel()
end)

RegisterCommand(AuctionConfig.AdminCommand, function()
    openPanel()
end, false)
TriggerEvent('chat:addSuggestion', '/' .. AuctionConfig.AdminCommand, 'Baz kardane panel mozayede')

AddEventHandler('sunset_utils:uiCallback:' .. MODULE, function(action, data)
    data = data or {}
    if action == 'submitBid' then
        if data.configName and data.key and data.amount then
            ESX.TriggerServerEvent('auction:submit', data.configName, tonumber(data.key), tonumber(data.amount))
            SetTimeout(500, refreshPanel)
        end
    elseif action == 'adminStart' then
        ESX.TriggerServerEvent('auction:adminStart', data.configName, tonumber(data.minutes))
        SetTimeout(300, refreshPanel)
    elseif action == 'adminStop' then
        ESX.TriggerServerEvent('auction:adminStop', data.configName)
        SetTimeout(300, refreshPanel)
    elseif action == 'adminFinish' then
        ESX.TriggerServerEvent('auction:adminFinish', data.configName)
        SetTimeout(300, refreshPanel)
    elseif action == 'adminAddGang' then
        ESX.TriggerServerEvent('auction:adminListAdd', data.configName, data.which, data.gang)
        SetTimeout(300, refreshPanel)
    elseif action == 'adminRemoveGang' then
        ESX.TriggerServerEvent('auction:adminListRemove', data.configName, data.which, data.gang)
        SetTimeout(300, refreshPanel)
    elseif action == 'adminBulkAddGangs' then
        ESX.TriggerServerEvent('auction:adminListBulkAdd', data.configName, data.which, data.text or data.gangs)
        SetTimeout(300, refreshPanel)
    elseif action == 'adminClearList' then
        ESX.TriggerServerEvent('auction:adminListClear', data.configName, data.which)
        SetTimeout(300, refreshPanel)
    elseif action == 'adminConfigAdd' then
        ESX.TriggerServerEvent('auction:adminConfigAdd', data.label)
        SetTimeout(400, refreshPanel)
    elseif action == 'adminConfigRemove' then
        ESX.TriggerServerEvent('auction:adminConfigRemove', data.configName)
        SetTimeout(400, refreshPanel)
    elseif action == 'adminConfigSave' then
        ESX.TriggerServerEvent('auction:adminConfigSave', data.configName, data.patch)
        SetTimeout(300, refreshPanel)
    elseif action == 'adminResetLists' then
        ESX.TriggerServerEvent('auction:adminListReset', data.configName)
        SetTimeout(300, refreshPanel)
    elseif action == 'refresh' then
        refreshPanel()
    elseif action == 'close' or action == 'escape' then
        closePanel()
    end
end)

AddEventHandler('sunset_utils:uiClosed', function(name)
    if name == MODULE then
        panelOpen = false
    end
end)
