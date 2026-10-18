-------------------------------------------------------------------
-- GANG HEISTS - client (menu NUI + claim countdown/GPS)
-- Boss Menu > Robbery calls exports['Unique_AllRobs']:OpenGangRobberyMenu().
-- The client only shows things and asks; every rule is enforced by
-- heist_server.lua.
-------------------------------------------------------------------

if not Config.Heist or not Config.Heist.Enabled then return end

-- ESX is a per-file local in this resource (client.lua / oilrig_client.lua each have
-- their own), so this file loads it itself. Without this the menu failed with
-- "attempt to index a nil value (global 'ESX')".
local ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

local MenuOpen = false
local CurrentKind = 'robbery'   -- which screen the page shows: robbery | gangwar | territory
local Claim = nil          -- { rob, name, x, y, z, untilAt = GetGameTimer() ms }
local ClaimBlip = nil

local function Notify(msg)
    if ESX and ESX.ShowNotification then ESX.ShowNotification(msg) else print(msg) end
end

local function WaitForESX()
    local tries = 0
    while ESX == nil and tries < 50 do Wait(100) tries = tries + 1 end
    return ESX ~= nil
end

-------------------------------------------------------------------
-- Menu
-------------------------------------------------------------------
local function Fetch(cb)
    if not ESX then return end
    ESX.TriggerServerCallback('Heist:GetData', function(data) cb(data) end)
end

function OpenGangRobberyMenu()
    if MenuOpen then return end
    if not ESX then
        -- first seconds after a resource start: ESX is still being fetched
        CreateThread(function()
            if WaitForESX() then OpenGangRobberyMenu() else Notify('~r~ESX load nashod') end
        end)
        return
    end
    Fetch(function(data)
        if not data or not data.hasGang then return Notify('~r~Shoma dar gang nistid') end
        CurrentKind = 'robbery'
        MenuOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'open', data = data })
    end)
end
exports('OpenGangRobberyMenu', OpenGangRobberyMenu)

local function CloseMenu()
    if not MenuOpen then return end
    MenuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

RegisterNUICallback('close', function(_, cb) CloseMenu() cb('ok') end)
-- (the robbery open function must also tell the page which system it is)

-- ===================================================================
-- ONE NUI, THREE SYSTEMS: robbery (purple), gang war (orange-red),
-- territory (green). The page switches by `kind`.
-- ===================================================================
local function GatherGangWar(cb)
    ESX.TriggerServerCallback('ZoneWar:GetMenu', function(m)
        if not m or not m.hasGang then return cb({ hasGang = false }) end
        local function finish(members)
            cb({
                hasGang = true, gang = m.gang, isBoss = m.isBoss, fee = m.fee, rosterMax = m.rosterMax,
                minOnline = m.minOnline, myOnline = m.myOnline, targets = m.targets, war = m.war,
                incoming = m.incoming, members = members or {}, allyHelp = m.allyHelp == true,
            })
        end
        local w = m.war
        if m.isBoss and w and (w.status == 'accepted' or w.status == 'gathering' or w.status == 'active') then
            ESX.TriggerServerCallback('ZoneWar:GetMembers', function(list) finish(list) end)
        else
            finish({})
        end
    end)
end

local function UpgradeConfig()
    local ok, cfg = pcall(function() return exports['Unique_ALLGangs']:GetUpgradeConfig() end)
    if ok and type(cfg) == 'table' then return cfg end
    return {}
end

local function GatherTerritory(cb)
    ESX.TriggerServerCallback('ZoneWar:GetMenu', function(m)
        ESX.TriggerServerCallback('Territory:GetState', function(zones)
            ESX.TriggerServerCallback('Territory:GetLeaderboard', function(board)
                cb({
                    hasGang = m and m.hasGang or false, gang = m and m.gang or nil, isBoss = m and m.isBoss or false,
                    zones = zones or {}, board = board or {}, upgradeCfg = UpgradeConfig(),
                })
            end)
        end)
    end)
end

local function GatherAllies(cb)
    ESX.TriggerServerCallback('Allies:Overview', function(d) cb(d or { hasGang = false }) end)
end

local function RefreshKind()
    if not MenuOpen then return end
    if CurrentKind == 'robbery' then
        Fetch(function(data) if data then SendNUIMessage({ action = 'update', data = data }) end end)
    elseif CurrentKind == 'gangwar' then
        GatherGangWar(function(d) SendNUIMessage({ action = 'updateKind', data = d }) end)
    elseif CurrentKind == 'allies' then
        GatherAllies(function(d) SendNUIMessage({ action = 'updateKind', data = d }) end)
    else
        GatherTerritory(function(d) SendNUIMessage({ action = 'updateKind', data = d }) end)
    end
end

function OpenKindMenu(kind)
    if MenuOpen then return end
    if not ESX then
        CreateThread(function() if WaitForESX() then OpenKindMenu(kind) end end)
        return
    end
    local gather = (kind == 'gangwar') and GatherGangWar or ((kind == 'allies') and GatherAllies or GatherTerritory)
    gather(function(data)
        if MenuOpen then return end
        CurrentKind = kind
        MenuOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'openKind', kind = kind, data = data })
    end)
end
exports('OpenGangWarMenu', function() OpenKindMenu('gangwar') end)
exports('OpenTerritoryMenu', function() OpenKindMenu('territory') end)
exports('OpenAlliesMenu', function() OpenKindMenu('allies') end)

RegisterNUICallback('refresh', function(_, cb)
    RefreshKind()
    cb('ok')
end)

local function KindAction(name, fn)
    RegisterNUICallback(name, function(body, cb)
        if not ESX then return cb('ok') end
        fn(body or {}, function(ok, msg)
            if msg then Notify((ok and '~g~' or '~r~') .. msg) end
            SendNUIMessage({ action = 'toast', ok = ok and true or false, text = msg })
            RefreshKind()
        end)
        cb('ok')
    end)
end

KindAction('zwDeclare', function(b, done) ESX.TriggerServerCallback('ZoneWar:Declare', done, b.gang, b.zone) end)
KindAction('zwRespond', function(b, done) ESX.TriggerServerCallback('ZoneWar:Respond', done, b.id, b.accept == true) end)
KindAction('zwRoster',  function(b, done) ESX.TriggerServerCallback('ZoneWar:Roster', done, b.src, b.add == true) end)
KindAction('zwSurrender', function(_, done) ESX.TriggerServerCallback('ZoneWar:Surrender', done) end)
KindAction('terBuy', function(b, done) ESX.TriggerServerCallback('Territory:PurchaseUpgrade', done, b.zone, b.type) end)
KindAction('zwAllyHelp', function(b, done) ESX.TriggerServerCallback('ZoneWar:SetAllyHelp', done, b.enabled == true) end)
KindAction('alPropose', function(b, done) ESX.TriggerServerCallback('Territory:ProposeAlliance', done, b.gang) end)
KindAction('alAccept',  function(b, done) ESX.TriggerServerCallback('Territory:AcceptAlliance', done, b.gang) end)
KindAction('alBreak',   function(b, done) ESX.TriggerServerCallback('Territory:BreakAlliance', done, b.gang) end)

-- switching between the three screens: close this one, open the target
RegisterNUICallback('nav', function(body, cb)
    cb('ok')
    local target = body and body.target
    CloseMenu()
    if target == 'robbery' then OpenGangRobberyMenu()
    elseif target == 'gangwar' then OpenKindMenu('gangwar')
    elseif target == 'territory' then OpenKindMenu('territory')
    elseif target == 'allies' then OpenKindMenu('allies') end
end)

RegisterNUICallback('claim', function(body, cb)
    if not ESX then return cb('ok') end
    ESX.TriggerServerCallback('Heist:Claim', function(ok, msg)
        if msg then Notify((ok and '~g~' or '~r~') .. msg) end
        SendNUIMessage({ action = 'toast', ok = ok and true or false, text = msg })
        Fetch(function(data) if MenuOpen and data then SendNUIMessage({ action = 'update', data = data }) end end)
    end, body and body.rob)
    cb('ok')
end)

RegisterNUICallback('ticket', function(body, cb)
    if not ESX then return cb('ok') end
    ESX.TriggerServerCallback('Heist:AddTicket', function(ok, msg)
        if msg then Notify((ok and '~g~' or '~r~') .. msg) end
        SendNUIMessage({ action = 'toast', ok = ok and true or false, text = msg })
        Fetch(function(data) if MenuOpen and data then SendNUIMessage({ action = 'update', data = data }) end end)
    end, body and body.rob)
    cb('ok')
end)

RegisterNUICallback('cancelClaim', function(_, cb)
    if not ESX then return cb('ok') end
    ESX.TriggerServerCallback('Heist:CancelClaim', function(ok, msg)
        if msg then Notify((ok and '~g~' or '~r~') .. msg) end
        SendNUIMessage({ action = 'toast', ok = ok and true or false, text = msg })
        Fetch(function(data) if MenuOpen and data then SendNUIMessage({ action = 'update', data = data }) end end)
    end)
    cb('ok')
end)

RegisterNUICallback('waypoint', function(_, cb)
    if Claim then SetNewWaypoint(Claim.x + 0.0, Claim.y + 0.0) Notify('~g~GPS roye robbery set shod') end
    cb('ok')
end)

-- never leave the cursor stuck if the resource restarts with the menu open
AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if MenuOpen then SetNuiFocus(false, false) end
    if ClaimBlip and DoesBlipExist(ClaimBlip) then RemoveBlip(ClaimBlip) end
end)

-------------------------------------------------------------------
-- The gang's claimed robbery: GPS + a countdown on screen
-------------------------------------------------------------------
local function ClearClaim()
    Claim = nil
    if ClaimBlip and DoesBlipExist(ClaimBlip) then RemoveBlip(ClaimBlip) end
    ClaimBlip = nil
end

RegisterNetEvent('Heist:ClaimStarted')
AddEventHandler('Heist:ClaimStarted', function(info)
    ClearClaim()
    Claim = { rob = info.rob, name = info.name, x = info.x, y = info.y, z = info.z, untilAt = GetGameTimer() + (info.seconds or 0) * 1000 }
    ClaimBlip = AddBlipForCoord(info.x + 0.0, info.y + 0.0, info.z + 0.0)
    SetBlipSprite(ClaimBlip, 161)
    SetBlipColour(ClaimBlip, 27)
    SetBlipScale(ClaimBlip, 1.0)
    SetBlipRoute(ClaimBlip, true)
    SetBlipRouteColour(ClaimBlip, 27)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Robbery: ' .. tostring(info.name))
    EndTextCommandSetBlipName(ClaimBlip)
    PlaySoundFrontend(-1, 'CHECKPOINT_PERFECT', 'HUD_MINI_GAME_SOUNDSET', true)
end)

RegisterNetEvent('Heist:ClaimEnded')
AddEventHandler('Heist:ClaimEnded', function(rob)
    if Claim and (not rob or Claim.rob == rob) then ClearClaim() end
end)

CreateThread(function()
    while true do
        if Claim then
            Wait(0)
            local left = (Claim.untilAt - GetGameTimer()) / 1000.0
            if left <= -5 then
                ClearClaim()
            else
                left = math.max(0, math.floor(left))
                SetTextFont(4)
                SetTextScale(0.45, 0.45)
                SetTextColour(190, 140, 255, 255)
                SetTextOutline()
                SetTextCentre(true)
                BeginTextCommandDisplayText('STRING')
                AddTextComponentSubstringPlayerName(('ROBBERY %s - bere shoroo konid: %d:%02d'):format(Claim.name, math.floor(left / 60), left % 60))
                EndTextCommandDisplayText(0.5, 0.955)
            end
        else
            Wait(1000)
        end
    end
end)
