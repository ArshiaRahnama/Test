-------------------------------------------------------------------
-- TERRITORY CONTROL (add-on) - client half
-- ---------------------------------------------------------------
-- Pure presentation + presence reporting - every decision about who
-- owns what lives server-side (server/territory.lua). This file:
--   1) draws a radius + a named blip per zone, coloured by owner
--   2) while a gang member is physically inside a zone, pings the
--      server with their own coords (server re-validates the
--      distance itself - see Territory:Ping)
--   3) shows a small on-ground status line while standing in one
--
-- Relies on the global `PlayerData` set by client/boss.lua, the same
-- convention client/gangwar.lua already uses - loaded after boss.lua
-- in fxmanifest.lua so it's guaranteed to exist by the time this runs.
-------------------------------------------------------------------

local ZoneConfigByKey = {}
for _, z in ipairs((Config.Territory and Config.Territory.Zones) or {}) do
    ZoneConfigByKey[z.key] = z
end
if Config.Territory and Config.Territory.BossZone and Config.Territory.BossZone.Enabled then
    ZoneConfigByKey[Config.Territory.BossZone.key] = Config.Territory.BossZone
end

local ZoneState = {} -- ZoneState[zoneKey] = { owner, contested, vulnerable }
local ZoneBlips = {} -- ZoneBlips[zoneKey] = { radius = blip, marker = blip }
local GangColorCache = {}

local function ColorForGang(gang)
    if not gang or gang == 'nogang' or gang == '' then return 0 end -- white/neutral = unclaimed
    if GangColorCache[gang] then return GangColorCache[gang] end
    local hash = 0
    for i = 1, #gang do
        hash = (hash * 31 + string.byte(gang, i)) % 100000
    end
    local color = 1 + (hash % 60) -- stays inside FiveM's safe/usable blip colour range
    GangColorCache[gang] = color
    return color
end

local function RefreshBlip(zoneKey)
    local cfg = ZoneConfigByKey[zoneKey]
    if not cfg then return end
    local state = ZoneState[zoneKey] or {}
    local color = state.contested and 1 or ColorForGang(state.owner)

    local existing = ZoneBlips[zoneKey]
    if existing then
        if existing.radius and DoesBlipExist(existing.radius) then RemoveBlip(existing.radius) end
        if existing.marker and DoesBlipExist(existing.marker) then RemoveBlip(existing.marker) end
    end

    local radiusBlip = AddBlipForRadius(cfg.coord.x, cfg.coord.y, cfg.coord.z, cfg.radius + 0.0)
    SetBlipColour(radiusBlip, color)
    SetBlipAlpha(radiusBlip, 110)
    SetBlipAsShortRange(radiusBlip, true)

    local markerBlip = AddBlipForCoord(cfg.coord.x, cfg.coord.y, cfg.coord.z)
    SetBlipSprite(markerBlip, 84)
    SetBlipDisplay(markerBlip, 4)
    SetBlipScale(markerBlip, 0.9)
    SetBlipColour(markerBlip, color)
    SetBlipAsShortRange(markerBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Ghalamro: ' .. cfg.label .. (state.owner and (' | ' .. state.owner) or ' | Azad'))
    EndTextCommandSetBlipName(markerBlip)

    ZoneBlips[zoneKey] = { radius = radiusBlip, marker = markerBlip }
end

local function RefreshAllBlips()
    for zoneKey in pairs(ZoneConfigByKey) do RefreshBlip(zoneKey) end
end

-------------------------------------------------------------------
-- The server broadcasts this every tick (every few seconds) so
-- contest/vulnerable status stays live - but a blip only needs to be
-- torn down and recreated when its OWNER or CONTESTED colour actually
-- changes. Refreshing all of them unconditionally on every broadcast
-- would flicker every zone blip on everyone's map every few seconds.
-------------------------------------------------------------------
RegisterNetEvent('Territory:SyncState')
AddEventHandler('Territory:SyncState', function(state)
    for zoneKey, s in pairs(state) do
        local prev = ZoneState[zoneKey]
        local colourChanged = (not prev) or prev.owner ~= s.owner or prev.contested ~= s.contested
        ZoneState[zoneKey] = s
        if colourChanged then RefreshBlip(zoneKey) end
    end
end)

CreateThread(function()
    Wait(2000) -- let ESX/PlayerData settle first
    if not Config.Territory or not Config.Territory.Enabled then return end
    ESX.TriggerServerCallback('Territory:GetState', function(state)
        for zoneKey, s in pairs(state) do
            ZoneState[zoneKey] = { owner = s.owner, contested = s.contested, vulnerable = s.vulnerable }
        end
        RefreshAllBlips()
    end)
end)

-------------------------------------------------------------------
-- Presence loop: only busy-loops (Wait(0), for smooth on-ground text)
-- while the player is actually standing inside a zone; otherwise it
-- sleeps a full second to stay cheap.
-------------------------------------------------------------------
CreateThread(function()
    local lastPingByZone = {} -- per-zone throttle - a global one could starve a second zone if two ever overlapped

    while true do
        local sleep = 1000

        if Config.Territory and Config.Territory.Enabled
        and PlayerData and PlayerData.gang and PlayerData.gang.name
        and PlayerData.gang.name ~= 'nogang' then
            local coords = GetEntityCoords(PlayerPedId())

            for zoneKey, cfg in pairs(ZoneConfigByKey) do
                local dist = #(coords - cfg.coord)
                if dist <= cfg.radius then
                    sleep = 0

                    local now = GetGameTimer()
                    if now - (lastPingByZone[zoneKey] or 0) >= 3000 then
                        TriggerServerEvent('Territory:Ping', zoneKey, coords.x, coords.y, coords.z)
                        lastPingByZone[zoneKey] = now
                    end

                    local state = ZoneState[zoneKey] or {}
                    local statusText
                    if state.contested then
                        statusText = '~r~Dargiri faal - mantaghe morede monazee ast'
                    elseif state.owner == PlayerData.gang.name then
                        statusText = '~g~Ghalamro-ye gang-e shoma' .. (state.vulnerable and ' ~r~(hadafe hamle!)' or '')
                    elseif state.owner then
                        statusText = '~y~Motaalegh be: ' .. state.owner .. (state.vulnerable and ' ~r~(asib-pazir)' or '')
                    else
                        statusText = '~w~Azad - dar hale tasarrof...'
                    end

                    Draw3DText(cfg.coord.x, cfg.coord.y, cfg.coord.z + 1.0, cfg.label .. '\n' .. statusText, 4, 0.35, 0.35)
                end
            end
        end

        Wait(sleep)
    end
end)

-------------------------------------------------------------------
-- /territories - quick leaderboard of who controls how many zones
-- (now also shows each gang's Boss Zone title, if they hold one).
-------------------------------------------------------------------
RegisterCommand('territories', function()
    if not Config.Territory or not Config.Territory.Enabled then return end
    ESX.TriggerServerCallback('Territory:GetLeaderboard', function(list)
        if not list or #list == 0 then
            ESX.ShowNotification('Hanooz hich gangi ghalamroei tasarrof nakarde ast')
            return
        end

        local options = {}
        for i, row in ipairs(list) do
            local desc = row.zones .. ' قلمرو تحت کنترل'
            if row.title then desc = desc .. ' | لقب: ' .. row.title end
            options[#options + 1] = {
                title = i .. '. ' .. (row.label or row.gang),
                description = desc,
                disabled = true,
            }
        end

        lib.registerContext({ id = 'territory_leaderboard', title = 'رتبه‌بندی قلمروها', options = options })
        lib.showContext('territory_leaderboard')
    end)
end, false)

-------------------------------------------------------------------
-- Boss Action menu integration - everything that used to be chat
-- commands (upgrade/scout/sabotage/alliances) now lives as a
-- "Territory Control" entry inside the gang's existing Boss Menu
-- (client/boss_esx_menu.lua -> OpenBossActionsMenu), which already
-- gates on full boss access before it ever gets here - matches the
-- exact same server-side HasBossAccess() check for the actions that
-- need it, so nothing here is a new trust boundary, just a new front
-- end for what server/territory.lua already enforces.
-------------------------------------------------------------------
function OpenTerritoryBossMenu(gang)
    local options = {
        {
            title = 'رتبه‌بندی قلمروها',
            description = 'مشاهده‌ی اینکه کدوم گنگ چند قلمرو کنترل می‌کنه',
            icon = 'ranking-star',
            onSelect = function() OpenTerritoryLeaderboardMenu(gang) end,
        },
        {
            title = 'آپگرید قلمرو',
            description = 'سرمایه‌گذاری پول تمیز گنگ روی قلمروهایی که در اختیار دارید',
            icon = 'arrow-up',
            onSelect = function() OpenTerritoryUpgradePicker(gang) end,
        },
        {
            title = 'شناسایی قلمرو رقیب',
            description = 'باید فیزیکی داخل قلمرو هدف باشید',
            icon = 'binoculars',
            onSelect = function() OpenTerritoryTargetPicker(gang, 'scout') end,
        },
        {
            title = 'خرابکاری در قلمرو رقیب',
            description = 'باید فیزیکی داخل قلمرو هدف باشید - درآمدشون رو موقتاً کاهش می‌ده',
            icon = 'bomb',
            onSelect = function() OpenTerritoryTargetPicker(gang, 'sabotage') end,
        },
        {
            title = 'اتحادها',
            description = 'پیشنهاد، پذیرش یا لغو اتحاد با گنگ‌های دیگه',
            icon = 'handshake',
            onSelect = function() OpenTerritoryAllianceMenu(gang) end,
        },
        {
            title = '‹ بازگشت به منوی اصلی',
            icon = 'arrow-left',
            onSelect = function() OpenBossActionsMenu() end,
        },
    }

    lib.registerContext({ id = 'territory_boss_menu', title = 'کنترل قلمرو', options = options })
    lib.showContext('territory_boss_menu')
end

function OpenTerritoryLeaderboardMenu(gang)
    ESX.TriggerServerCallback('Territory:GetLeaderboard', function(list)
        local options = {}
        if not list or #list == 0 then
            options[1] = { title = 'هنوز هیچ گنگی قلمرویی تصرف نکرده', disabled = true }
        else
            for i, row in ipairs(list) do
                local desc = row.zones .. ' قلمرو تحت کنترل'
                if row.title then desc = desc .. ' | لقب: ' .. row.title end
                options[#options + 1] = { title = i .. '. ' .. (row.label or row.gang), description = desc, disabled = true }
            end
        end
        options[#options + 1] = { title = '‹ بازگشت', icon = 'arrow-left', onSelect = function() OpenTerritoryBossMenu(gang) end }

        lib.registerContext({ id = 'territory_leaderboard_menu', title = 'رتبه‌بندی قلمروها', options = options })
        lib.showContext('territory_leaderboard_menu')
    end)
end

-------------------------------------------------------------------
-- SYSTEM 1: UPGRADES - pick one of your gang's OWNED zones, then pick
-- an upgrade type. Server still re-checks ownership/boss-access/cost
-- regardless of what this menu shows.
-------------------------------------------------------------------
function OpenTerritoryUpgradePicker(gang)
    if not Config.Territory.Upgrades or not Config.Territory.Upgrades.Enabled then
        ESX.ShowNotification('Sisteme upgrade gheyrefaal ast')
        return OpenTerritoryBossMenu(gang)
    end

    local options = {}
    for zoneKey, cfg in pairs(ZoneConfigByKey) do
        local state = ZoneState[zoneKey] or {}
        if state.owner == gang then
            options[#options + 1] = {
                title = cfg.label,
                description = cfg.bossZone and 'قلمروی پادشاه' or ('تایر ' .. tostring(cfg.tier)),
                icon = 'flag',
                onSelect = function() OpenTerritoryUpgradeMenu(gang, zoneKey) end,
            }
        end
    end
    if #options == 0 then
        options[1] = { title = 'گنگ شما هیچ قلمرویی در اختیار نداره', disabled = true }
    end
    options[#options + 1] = { title = '‹ بازگشت', icon = 'arrow-left', onSelect = function() OpenTerritoryBossMenu(gang) end }

    lib.registerContext({ id = 'territory_upgrade_picker', title = 'انتخاب قلمرو برای آپگرید', options = options })
    lib.showContext('territory_upgrade_picker')
end

function OpenTerritoryUpgradeMenu(gang, zoneKey)
    local cfg = ZoneConfigByKey[zoneKey]
    local state = ZoneState[zoneKey] or {}

    local options = {}
    for upgradeType, upgradeCfg in pairs(Config.Territory.Upgrades) do
        if type(upgradeCfg) == 'table' and upgradeCfg.label then
            local level = (state.upgrades and state.upgrades[upgradeType]) or 0
            local nextCost = upgradeCfg.cost[level + 1]
            options[#options + 1] = {
                title = upgradeCfg.label .. ' (سطح ' .. level .. '/' .. upgradeCfg.maxLevel .. ')',
                description = nextCost and ('ارتقا به سطح بعد: $' .. nextCost) or 'حداکثر سطح',
                icon = 'circle-up',
                disabled = not nextCost,
                onSelect = function()
                    ESX.TriggerServerCallback('Territory:PurchaseUpgrade', function(ok, msg)
                        ESX.ShowNotification(msg, ok and 'success' or 'error')
                        OpenTerritoryUpgradeMenu(gang, zoneKey) -- refresh with the new level/cost
                    end, zoneKey, upgradeType)
                end,
            }
        end
    end
    options[#options + 1] = { title = '‹ بازگشت', icon = 'arrow-left', onSelect = function() OpenTerritoryUpgradePicker(gang) end }

    lib.registerContext({ id = 'territory_upgrade_menu', title = 'آپگرید: ' .. cfg.label, options = options })
    lib.showContext('territory_upgrade_menu')
end

-------------------------------------------------------------------
-- SYSTEM 2: ESPIONAGE - pick a RIVAL owned zone (the actual same-gang/
-- allied check happens server-side, this just hides your own zones).
-- Both scout and sabotage still require the server to find you
-- physically inside the target zone.
-------------------------------------------------------------------
function OpenTerritoryTargetPicker(gang, mode)
    local enabled = (mode == 'scout' and Config.Territory.Scout and Config.Territory.Scout.Enabled)
                 or (mode == 'sabotage' and Config.Territory.Sabotage and Config.Territory.Sabotage.Enabled)
    if not enabled then
        ESX.ShowNotification('In sisteme gheyrefaal ast')
        return OpenTerritoryBossMenu(gang)
    end

    local options = {}
    for zoneKey, cfg in pairs(ZoneConfigByKey) do
        local state = ZoneState[zoneKey] or {}
        if state.owner and state.owner ~= gang then
            options[#options + 1] = {
                title = cfg.label,
                description = 'متعلق به: ' .. state.owner .. ' - باید داخل این قلمرو باشید',
                icon = mode == 'scout' and 'binoculars' or 'bomb',
                onSelect = function()
                    if mode == 'scout' then
                        ESX.TriggerServerCallback('Territory:Scout', function(ok, err, report)
                            if not ok then
                                ESX.ShowNotification(err, 'error')
                                return OpenTerritoryTargetPicker(gang, mode)
                            end
                            OpenTerritoryScoutReport(gang, cfg.label, report)
                        end, zoneKey)
                    else
                        TriggerServerEvent('Territory:Sabotage', zoneKey)
                        OpenTerritoryBossMenu(gang)
                    end
                end,
            }
        end
    end
    if #options == 0 then
        options[1] = { title = 'هیچ قلمروی رقیبی برای هدف قرار دادن نیست', disabled = true }
    end
    options[#options + 1] = { title = '‹ بازگشت', icon = 'arrow-left', onSelect = function() OpenTerritoryBossMenu(gang) end }

    lib.registerContext({
        id = 'territory_target_picker',
        title = mode == 'scout' and 'انتخاب هدف شناسایی' or 'انتخاب هدف خرابکاری',
        options = options,
    })
    lib.showContext('territory_target_picker')
end

function OpenTerritoryScoutReport(gang, zoneLabel, report)
    local options = { { title = 'اعضای آنلاین', description = tostring(report.onlineMembers), disabled = true } }
    if report.vulnerable then
        options[#options + 1] = { title = 'وضعیت', description = 'این قلمرو در حال حاضر آسیب‌پذیره!', disabled = true }
    end
    if report.upgrades then
        for upgType, lvl in pairs(report.upgrades) do
            options[#options + 1] = { title = 'آپگرید: ' .. upgType, description = 'سطح ' .. lvl, disabled = true }
        end
    end
    options[#options + 1] = { title = '‹ بازگشت', icon = 'arrow-left', onSelect = function() OpenTerritoryTargetPicker(gang, 'scout') end }

    lib.registerContext({ id = 'territory_scout_report', title = 'گزارش شناسایی: ' .. zoneLabel, options = options })
    lib.showContext('territory_scout_report')
end

-------------------------------------------------------------------
-- SYSTEM 5: ALLIANCES
-------------------------------------------------------------------
function OpenTerritoryAllianceMenu(gang)
    local options = {
        {
            title = 'پیشنهاد اتحاد',
            description = 'اسم دقیق گنگ مقصد رو وارد کنید',
            icon = 'paper-plane',
            onSelect = function()
                local input = lib.inputDialog('پیشنهاد اتحاد', {
                    { type = 'input', label = 'نام گنگ مقصد' },
                })
                if not input or not input[1] or input[1] == '' then return OpenTerritoryAllianceMenu(gang) end
                ESX.TriggerServerCallback('Territory:ProposeAlliance', function(ok, msg)
                    ESX.ShowNotification(msg, ok and 'success' or 'error')
                    OpenTerritoryAllianceMenu(gang)
                end, input[1])
            end,
        },
        {
            title = 'پیشنهادهای در انتظار',
            description = 'پیشنهادهایی که گنگ‌های دیگه براتون فرستادن',
            icon = 'inbox',
            onSelect = function() OpenTerritoryPendingAlliancesMenu(gang) end,
        },
        {
            title = 'لغو اتحاد',
            description = 'قطع اتحاد با یکی از هم‌پیمانان فعلی',
            icon = 'link-slash',
            onSelect = function() OpenTerritoryBreakAllianceMenu(gang) end,
        },
        {
            title = 'مشاهده‌ی هم‌پیمانان',
            icon = 'people-group',
            onSelect = function() OpenTerritoryViewAlliesMenu(gang) end,
        },
        { title = '‹ بازگشت', icon = 'arrow-left', onSelect = function() OpenTerritoryBossMenu(gang) end },
    }
    lib.registerContext({ id = 'territory_alliance_menu', title = 'اتحادها', options = options })
    lib.showContext('territory_alliance_menu')
end

function OpenTerritoryPendingAlliancesMenu(gang)
    ESX.TriggerServerCallback('Territory:GetPendingAlliances', function(list)
        local options = {}
        if not list or #list == 0 then
            options[1] = { title = 'پیشنهاد در انتظاری وجود نداره', disabled = true }
        else
            for _, proposerGang in ipairs(list) do
                options[#options + 1] = {
                    title = proposerGang,
                    description = 'برای پذیرش انتخاب کنید',
                    icon = 'check',
                    onSelect = function()
                        ESX.TriggerServerCallback('Territory:AcceptAlliance', function(ok, msg)
                            ESX.ShowNotification(msg, ok and 'success' or 'error')
                            OpenTerritoryAllianceMenu(gang)
                        end, proposerGang)
                    end,
                }
            end
        end
        options[#options + 1] = { title = '‹ بازگشت', icon = 'arrow-left', onSelect = function() OpenTerritoryAllianceMenu(gang) end }

        lib.registerContext({ id = 'territory_pending_alliances', title = 'پیشنهادهای در انتظار', options = options })
        lib.showContext('territory_pending_alliances')
    end)
end

function OpenTerritoryBreakAllianceMenu(gang)
    ESX.TriggerServerCallback('Territory:GetAlliances', function(list)
        local options = {}
        if not list or #list == 0 then
            options[1] = { title = 'شما هیچ هم‌پیمانی ندارید', disabled = true }
        else
            for _, otherGang in ipairs(list) do
                options[#options + 1] = {
                    title = otherGang,
                    description = 'برای لغو اتحاد انتخاب کنید',
                    icon = 'link-slash',
                    onSelect = function()
                        ESX.TriggerServerCallback('Territory:BreakAlliance', function(ok, msg)
                            ESX.ShowNotification(msg, ok and 'success' or 'error')
                            OpenTerritoryAllianceMenu(gang)
                        end, otherGang)
                    end,
                }
            end
        end
        options[#options + 1] = { title = '‹ بازگشت', icon = 'arrow-left', onSelect = function() OpenTerritoryAllianceMenu(gang) end }

        lib.registerContext({ id = 'territory_break_alliance', title = 'لغو اتحاد', options = options })
        lib.showContext('territory_break_alliance')
    end)
end

function OpenTerritoryViewAlliesMenu(gang)
    ESX.TriggerServerCallback('Territory:GetAlliances', function(list)
        local options = {}
        if not list or #list == 0 then
            options[1] = { title = 'شما هیچ هم‌پیمانی ندارید', disabled = true }
        else
            for _, otherGang in ipairs(list) do
                options[#options + 1] = { title = otherGang, disabled = true }
            end
        end
        options[#options + 1] = { title = '‹ بازگشت', icon = 'arrow-left', onSelect = function() OpenTerritoryAllianceMenu(gang) end }

        lib.registerContext({ id = 'territory_view_allies', title = 'هم‌پیمانان شما', options = options })
        lib.showContext('territory_view_allies')
    end)
end

-------------------------------------------------------------------
-- SYSTEM 4 (cont.): BOSS ZONE guard peds - purely cosmetic difficulty,
-- spawned/despawned client-side off the server's open/close signal.
-- Only actually spawns them for a player once they get near the zone
-- (and despawns if they wander off or the window closes), so this
-- never runs for players who aren't anywhere near it.
-------------------------------------------------------------------
local BossZoneOpen = false
local BossZoneGuards = {}

local function DespawnBossZoneGuards()
    for _, ped in ipairs(BossZoneGuards) do
        if DoesEntityExist(ped) then DeleteEntity(ped) end
    end
    BossZoneGuards = {}
end

RegisterNetEvent('Territory:BossZoneState')
AddEventHandler('Territory:BossZoneState', function(open)
    BossZoneOpen = open
    if not open then DespawnBossZoneGuards() end
end)

if Config.Territory.BossZone and Config.Territory.BossZone.Enabled then
    -- Guarantee the guards are actually hostile regardless of whatever
    -- relationship groups other parts of the server may have set up -
    -- set once at resource start, not per-spawn.
    CreateThread(function()
        local hash = GetHashKey('AMBIENT_GANG_LOST')
        SetRelationshipBetweenGroups(5, hash, GetHashKey('PLAYER')) -- 5 = hate
        SetRelationshipBetweenGroups(5, GetHashKey('PLAYER'), hash)
    end)

    CreateThread(function()
        local bz = Config.Territory.BossZone
        while true do
            Wait(3000)
            if BossZoneOpen then
                local coords = GetEntityCoords(PlayerPedId())
                local dist = #(coords - bz.coord)
                if dist <= bz.radius + 50.0 and #BossZoneGuards == 0 then
                    for i = 1, (bz.guardCount or 4) do
                        local angle = (i / (bz.guardCount or 4)) * 2 * math.pi
                        local px = bz.coord.x + math.cos(angle) * (bz.radius * 0.5)
                        local py = bz.coord.y + math.sin(angle) * (bz.radius * 0.5)
                        local model = GetHashKey('g_m_y_lost_01')
                        RequestModel(model)
                        local waited = 0
                        while not HasModelLoaded(model) and waited < 3000 do Wait(50) waited = waited + 50 end
                        if HasModelLoaded(model) then
                            local ped = CreatePed(4, model, px, py, bz.coord.z, 0.0, true, true)
                            SetPedRelationshipGroupHash(ped, GetHashKey('AMBIENT_GANG_LOST'))
                            GiveWeaponToPed(ped, GetHashKey('WEAPON_MICROSMG'), 250, false, true)
                            SetPedCombatAttributes(ped, 46, true)
                            SetPedFleeAttributes(ped, 0, false)
                            SetPedAccuracy(ped, 35)
                            SetEntityAsMissionEntity(ped, true, true)
                            BossZoneGuards[#BossZoneGuards + 1] = ped
                        end
                        SetModelAsNoLongerNeeded(model)
                    end
                elseif dist > bz.radius + 150.0 and #BossZoneGuards > 0 then
                    DespawnBossZoneGuards() -- wandered off - despawn, will respawn fresh if they come back
                end
            end
        end
    end)
end

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DespawnBossZoneGuards()
    end
end)
