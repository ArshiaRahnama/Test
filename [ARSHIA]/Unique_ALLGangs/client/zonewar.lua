-------------------------------------------------------------------
-- GANG WAR - client side (see server/zonewar.lua + Config.ZoneWar)
--   * /zonewar  -> ox_lib menu (boss: declare / accept; members: roster)
--   * HUD       -> only for rostered players while the war is on
--   * Blips     -> a flashing red circle on EVERYONE's map over a zone
--                  that is currently at war, so bystanders stay away
-- The client only displays and asks; every rule is enforced on the server.
-------------------------------------------------------------------

if not Config.ZoneWar or not Config.ZoneWar.Enabled then return end

local Hud = nil               -- server-sent table for rostered players, nil otherwise
local HudReceivedAt = 0       -- GetGameTimer() when Hud arrived (timer counts down locally)
local BannerUntil = 0
local BannerText, BannerSub = '', ''
local WarBlips = {}           -- WarBlips[zoneKey] = { radius = blip, marker = blip }
local Gather = nil            -- arena mode: { hq = {x,y,z,radius}|nil, untilAt = gameTimer } while the roster walks to the gang HQ
local GatherBlip = nil

-------------------------------------------------------------------
-- War-zone blips (everyone)
-------------------------------------------------------------------
local function ClearBlips()
    for key, b in pairs(WarBlips) do
        if b.radius and DoesBlipExist(b.radius) then RemoveBlip(b.radius) end
        if b.marker and DoesBlipExist(b.marker) then RemoveBlip(b.marker) end
        WarBlips[key] = nil
    end
end

RegisterNetEvent('ZoneWar:Zones')
AddEventHandler('ZoneWar:Zones', function(zones)
    ClearBlips()
    for _, z in ipairs(zones or {}) do
        local radius = AddBlipForRadius(z.x + 0.0, z.y + 0.0, z.z + 0.0, (z.radius or 50.0) + 0.0)
        SetBlipColour(radius, 1)
        SetBlipAlpha(radius, 140)
        SetBlipFlashes(radius, true)

        local marker = AddBlipForCoord(z.x + 0.0, z.y + 0.0, z.z + 0.0)
        SetBlipSprite(marker, 436) -- crossed swords style icon
        SetBlipColour(marker, 1)
        SetBlipScale(marker, 1.0)
        SetBlipAsShortRange(marker, false)
        SetBlipFlashes(marker, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('GANG WAR - ' .. tostring(z.label or z.key))
        EndTextCommandSetBlipName(marker)

        WarBlips[z.key] = { radius = radius, marker = marker }
    end
end)

CreateThread(function()
    Wait(4000)
    ESX.TriggerServerCallback('ZoneWar:GetZones', function(zones)
        TriggerEvent('ZoneWar:Zones', zones or {})
    end)
end)

-------------------------------------------------------------------
-- Arena mode: roster gathers at the gang HQ before the paintball match
-------------------------------------------------------------------
local function ClearGather()
    Gather = nil
    if GatherBlip and DoesBlipExist(GatherBlip) then RemoveBlip(GatherBlip) end
    GatherBlip = nil
end

RegisterNetEvent('ZoneWar:Gather')
AddEventHandler('ZoneWar:Gather', function(hq, seconds)
    ClearGather()
    if not hq then return end
    Gather = { hq = hq, untilAt = GetGameTimer() + (tonumber(seconds) or 0) * 1000 }
    GatherBlip = AddBlipForRadius(hq.x + 0.0, hq.y + 0.0, hq.z + 0.0, (hq.radius or 80.0) + 0.0)
    SetBlipColour(GatherBlip, 2)
    SetBlipAlpha(GatherBlip, 120)
    SetNewWaypoint(hq.x + 0.0, hq.y + 0.0)
    BannerText, BannerSub = 'GANG WAR', 'Be gang bargard - arena baad az jam shodan'
    BannerUntil = GetGameTimer() + 6000
    PlaySoundFrontend(-1, 'CHECKPOINT_PERFECT', 'HUD_MINI_GAME_SOUNDSET', true)
end)

-------------------------------------------------------------------
-- HUD (rostered players)
-------------------------------------------------------------------
RegisterNetEvent('ZoneWar:Sync')
AddEventHandler('ZoneWar:Sync', function(data)
    Hud = data
    HudReceivedAt = GetGameTimer()
end)

RegisterNetEvent('ZoneWar:Banner')
AddEventHandler('ZoneWar:Banner', function(title, sub)
    BannerText, BannerSub = tostring(title or ''), tostring(sub or '')
    BannerUntil = GetGameTimer() + 6000
    PlaySoundFrontend(-1, 'CHECKPOINT_PERFECT', 'HUD_MINI_GAME_SOUNDSET', true)
end)

local function DrawTxt(text, x, y, scale, r, g, b, a, center)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextOutline()
    SetTextCentre(center and true or false)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

local function Clock(seconds)
    seconds = math.max(0, math.floor(seconds))
    return ('%02d:%02d'):format(math.floor(seconds / 60), seconds % 60)
end

CreateThread(function()
    while true do
        local now = GetGameTimer()
        if Hud or Gather or now < BannerUntil then
            Wait(0)

            if now < BannerUntil then
                DrawTxt(BannerText, 0.5, 0.20, 1.2, 255, 60, 60, 255, true)
                DrawTxt(BannerSub, 0.5, 0.27, 0.7, 255, 255, 255, 230, true)
            end

            if Gather then
                local left = (Gather.untilAt - now) / 1000.0
                if left < -15 then
                    ClearGather()
                else
                    DrawTxt('GANG WAR - be gang bargard (' .. Clock(left) .. ')', 0.5, 0.012, 0.5, 255, 255, 255, 230, true)
                    if Gather.hq then
                        local c = GetEntityCoords(PlayerPedId())
                        local d = #(c - vector3(Gather.hq.x + 0.0, Gather.hq.y + 0.0, Gather.hq.z + 0.0))
                        if d <= (Gather.hq.radius or 80.0) then
                            DrawTxt('DAR GANG HASTID - montazer-e baghie bashid', 0.5, 0.045, 0.45, 60, 255, 60, 255, true)
                        else
                            DrawTxt(('Fasele ta gang: %dm'):format(math.floor(d)), 0.5, 0.045, 0.45, 255, 200, 0, 255, true)
                        end
                    end
                end
            end

            if Hud then
                local elapsed = (now - HudReceivedAt) / 1000.0
                local remaining = (Hud.remaining or 0) - elapsed

                local title, timeLabel
                if Hud.phase == 'active' then
                    title = 'GANG WAR - ' .. tostring(Hud.label)
                    timeLabel = Clock(remaining)
                else
                    title = 'GANG WAR (shoroo dar ' .. Clock(remaining) .. ') - ' .. tostring(Hud.label)
                    timeLabel = ''
                end

                DrawTxt(title, 0.5, 0.012, 0.45, 255, 255, 255, 230, true)
                if Hud.phase == 'active' then
                    DrawTxt(('%s  %d  :  %d  %s'):format(tostring(Hud.mineName), Hud.mine or 0, Hud.theirs or 0, tostring(Hud.oppName)),
                        0.5, 0.036, 0.6, 255, 80, 80, 255, true)
                    DrawTxt(('%s   |   baraye bord: %d emtiaz   |   dar zone: %d vs %d'):format(timeLabel, Hud.toWin or 0, Hud.insideMine or 0, Hud.insideTheirs or 0),
                        0.5, 0.072, 0.38, 255, 255, 255, 220, true)

                    -- inside / outside indicator (only for the player themself; the server decides scoring)
                    if Hud.zone then
                        local c = GetEntityCoords(PlayerPedId())
                        local d = #(c - vector3(Hud.zone.x + 0.0, Hud.zone.y + 0.0, Hud.zone.z + 0.0))
                        local inside = d <= (Hud.zone.radius + (Hud.buffer or 0.0))
                        if inside then
                            DrawTxt('DAKHEL-E ZONE', 0.5, 0.095, 0.4, 60, 255, 60, 255, true)
                        else
                            DrawTxt('KHAREJ AZ ZONE - emtiaz nemigiri!', 0.5, 0.095, 0.4, 255, 200, 0, 255, true)
                        end
                    end
                end
            end
        else
            Wait(500)
        end
    end
end)

-------------------------------------------------------------------
-- Boss Menu > Gang War  (opened from client/boss_esx_menu.lua)
-- Same ESX default-menu style as the rest of the boss actions. The
-- defending boss accepts/declines here; the boss also picks the roster.
-------------------------------------------------------------------
local function Notify(msg)
    ESX.ShowNotification(msg)
end

local function Result(ok, msg)
    if msg then Notify((ok and '~g~' or '~r~') .. msg) end
end

local function Clock2(seconds)
    seconds = math.max(0, math.floor(seconds or 0))
    return ('%02d:%02d'):format(math.floor(seconds / 60), seconds % 60)
end

local function Confirm(gang, id, title, onYes)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'zonewar_confirm_' .. id, {
        title = title, align = 'top-left',
        elements = { { label = 'Yes', value = 'yes' }, { label = 'No', value = 'no' } },
    }, function(data, menu)
        menu.close()
        if data.current.value == 'yes' then onYes() else OpenZoneWarBossMenu(gang) end
    end, function(data, menu)
        menu.close()
        OpenZoneWarBossMenu(gang)
    end)
end

local function OpenRosterMenu(gang)
    ESX.TriggerServerCallback('ZoneWar:GetMembers', function(members)
        local elements = {}
        for _, m in ipairs(members or {}) do
            elements[#elements + 1] = {
                label = ('%s %s (ID %s)'):format(m.inRoster and '[IN] ' or '[   ]', m.name, m.src),
                value = m.src, inRoster = m.inRoster,
            }
        end
        if #elements == 0 then
            Notify('~r~Hich ozv-e online-i nist')
            return OpenZoneWarBossMenu(gang)
        end
        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'zonewar_roster', {
            title = 'GANG WAR - ROSTER', align = 'top-left', elements = elements,
        }, function(data, menu)
            menu.close()
            ESX.TriggerServerCallback('ZoneWar:Roster', function(ok, msg)
                Result(ok, msg)
                OpenRosterMenu(gang) -- refresh the list
            end, data.current.value, not data.current.inRoster)
        end, function(data, menu)
            menu.close()
            OpenZoneWarBossMenu(gang)
        end)
    end)
end

function OpenZoneWarBossMenu(gang)
    ESX.TriggerServerCallback('ZoneWar:GetMenu', function(m)
        if not m or not m.hasGang then return Notify('~r~Shoma dar gang nistid') end
        if not m.isBoss then return Notify('~r~Faghat boss mitoone Gang War ro modiriyat kone') end

        local elements, w = {}, m.war

        if m.incoming then
            elements[#elements + 1] = {
                label = ('<span style="color:orange;">Darkhast-e jang az "%s" - %s (mohlat %s)</span>'):format(m.incoming.from, m.incoming.hasZone and ('ZONE: ' .. m.incoming.zone) or 'FAGHAT POOL', Clock2(m.incoming.secondsLeft)),
                value = 'incoming',
            }
        end

        if w then
            local status
            if w.status == 'pending' then status = ('montazer-e pasokh (%s)'):format(Clock2(w.secondsToAccept))
            elseif w.status == 'accepted' then status = ('shoroo dar %s'):format(Clock2(w.secondsToStart))
            elseif w.status == 'gathering' then status = ('jam shodan dar gang - %s'):format(Clock2(w.secondsToGather))
            else status = ('%d : %d - %s baghi'):format(w.mine, w.theirs, Clock2(w.secondsLeft)) end
            elements[#elements + 1] = { label = ('Jang #%s: %s vs %s | %s | %s'):format(w.id, m.gang, w.opponent, w.hasZone and ('ZONE: ' .. w.zone) or 'FAGHAT POOL', status), value = 'none' }
            if w.status == 'accepted' then
                elements[#elements + 1] = { label = ('Roster (%d/%d) - entekhab-e jangju-ha'):format(w.rosterMine or 0, m.rosterMax or 0), value = 'roster' }
            end
            if w.status == 'active' then
                elements[#elements + 1] = { label = '<span style="color:red;">Taslim shodan</span>', value = 'surrender' }
            end
        elseif m.targets then
            if m.busy then elements[#elements + 1] = { label = 'Server por ast (hadaksar jang-e hamzaman)', value = 'none' } end
            elements[#elements + 1] = { label = ('Gang-haye online (hadaghal %d nafar) - shoma: %d online'):format(m.minOnline or 3, m.myOnline or 0), value = 'none' }
            for _, target in ipairs(m.targets) do
                if target.reason then
                    elements[#elements + 1] = { label = ('%s - %d online (%s)'):format(target.label, target.online, target.reason), value = 'none' }
                else
                    elements[#elements + 1] = { label = ('Elam-e jang be: %s - %d online ($%s)'):format(target.label, target.online, m.fee), value = 'pickgang', target = target }
                end
            end
            if #m.targets == 0 then elements[#elements + 1] = { label = ('Hich gang-i ba hadaghal %d nafar online nist'):format(m.minOnline or 3), value = 'none' } end
        end

        if #elements == 0 then elements[#elements + 1] = { label = 'Jang-e faal nist', value = 'none' } end

        ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'zonewar_boss', {
            title = 'GANG WAR', align = 'top-left', elements = elements,
        }, function(data, menu)
            local v = data.current.value
            if v == 'none' then return end
            menu.close()

            if v == 'incoming' then
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'zonewar_incoming', {
                    title = ('Jang az "%s" - %s'):format(m.incoming.from, m.incoming.hasZone and ('ZONE: ' .. m.incoming.zone) or 'FAGHAT POOL'), align = 'top-left',
                    elements = {
                        { label = ('Noe: %s'):format(m.incoming.hasZone and 'agar bebazid, zone az shoma migirad' or 'zone avaz nemishavad (pool va XP)'), value = 'none' },
                        { label = ('Ghabool - $%s az khazane'):format(m.incoming.fee), value = 'yes' },
                        { label = 'Rad', value = 'no' },
                    },
                }, function(data2, menu2)
                    if data2.current.value == 'none' then return end
                    menu2.close()
                    ESX.TriggerServerCallback('ZoneWar:Respond', function(ok, msg)
                        Result(ok, msg)
                        OpenZoneWarBossMenu(gang)
                    end, m.incoming.id, data2.current.value == 'yes')
                end, function(data2, menu2)
                    menu2.close()
                    OpenZoneWarBossMenu(gang)
                end)
            elseif v == 'roster' then
                OpenRosterMenu(gang)
            elseif v == 'surrender' then
                Confirm(gang, 'surrender', 'Taslim? Zone va hazine az dast mirad', function()
                    ESX.TriggerServerCallback('ZoneWar:Surrender', function(ok, msg) Result(ok, msg) end)
                end)
            elseif v == 'pickgang' then
                local target = data.current.target
                local stakes = { { label = 'Bedun-e zone (faghat pool-e pool)', value = 'nozone' } }
                for _, z in ipairs(target.zones or {}) do
                    if z.reason then
                        stakes[#stakes + 1] = { label = ('%s (%s)'):format(z.label, z.reason), value = 'none' }
                    else
                        stakes[#stakes + 1] = { label = ('Zone: %s (tier %s)'):format(z.label, z.tier or '?'), value = 'zone', key = z.key, zlabel = z.label }
                    end
                end
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'zonewar_stake', {
                    title = ('Jang ba %s - rooye chi?'):format(target.label), align = 'top-left', elements = stakes,
                }, function(data2, menu2)
                    if data2.current.value == 'none' then return end
                    menu2.close()
                    local zoneKey, zlabel = nil, 'faghat pool'
                    if data2.current.value == 'zone' then zoneKey, zlabel = data2.current.key, data2.current.zlabel end
                    Confirm(gang, 'declare', ('Elam-e jang be %s (%s) - $%s'):format(target.label, zlabel, m.fee), function()
                        ESX.TriggerServerCallback('ZoneWar:Declare', function(ok, msg)
                            Result(ok, msg)
                            OpenZoneWarBossMenu(gang)
                        end, target.gang, zoneKey)
                    end)
                end, function(data2, menu2)
                    menu2.close()
                    OpenZoneWarBossMenu(gang)
                end)
            end
        end, function(data, menu)
            menu.close()
            OpenBossActionsMenu()
        end)
    end)
end
