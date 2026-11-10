-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

PlayersCache = {}
local fbiSpectCoords = {
    vector4(124.48,-733.18,242.15,10.05),   -- fbi 1
    vector4(2519.38,-435.93,106.91,10.05),	-- fbi 2
    vector4(-531.17,-190.16,43.37,6.05),  -- justic
    vector4(-2357.96, 3250.2, 101.45, 5.01), -- Army
}

lastspec = 0
perm = 0
local fbi = false

local godmode = false
local infinite_stamina = false
local invisibility = false
invisibility2 = false
local noRagDoll = false
noclip = false
local deletegun = false
blipdool = false
fastrun = false
superjump = false
godmode = true
searchText = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        perm = aperm
        if aperm >= 1 then
            ESX.TriggerServerCallback('ssadmin:GetActivePlayers', function(players)
                PlayersCache = players
                AdminMenu()
            end)
            isAdmin = true
            ESX.SetPlayerState('admin', true)
        end
        if aperm >= 1 or xPlayer.job.name == 'fbi' then
          fbi = true
          --FbiThread()
        end
        ESX.SetPlayerData('permission_level',aperm)
        if aperm >= 20 then
            CreateThread(function()
                while true do
                    Wait(5000)
                    if MumbleIsPlayerTalking(PlayerId()) == 1 then
                        exports['xsound']:PlayUrl("stalk", "./sounds/stop_talking.mp3", 0.1)
                    end
                end
            end)
        end
    end)
end)
RegisterNetEvent("esx:setJob")
AddEventHandler('esx:setJob', function(job)
    fbi = false
    cane = false
    Wait(1000)
    if job.name == 'fbi' then
        fbi = true
        --FbiThread()
    end
end)

-- local cane = false
-- function FbiThread()
--     Citizen.CreateThread(function()
--         while fbi do
--             local distance = #(GetEntityCoords(PlayerPedId()) - vector3(124,-733,242))
--             if distance < 3 then
--               ESX.ShowHelpNotification('Dokme E Jahat baz kardan cam')
--               cane = true
--             elseif cane then
--               cane = false
--               ESX.UI.Menu.CloseAll()
--             end
--             Wait(1)
--         end
--     end)
-- end

local joblist = {
    'fbi',
	"police",
	"sheriff",
    "mt",
    "justice",
	"mechanic",
	"taxi",
	"ambulance",
	"weazel",
    "justice",
    "detective",
	--"open house",
}
local addFBI = false

RegisterCommand('fbispect',function()
    if ESX.GetPlayerData().job.name ~= 'fbi' then return end
    -- local fullperm = exports['sun-society']:doesHavePerm('spectfbi')
    for k, v in pairs(fbiSpectCoords) do
        local distance = #(GetEntityCoords(PlayerPedId()) - v.xyz)
        if distance < 3 then
            exports["suncore"]:Whitelist(true)
            local elements = {}
            -- table.insert(elements, { label = 'police'})
            -- table.insert(elements, { label = 'sheriff'})
            -- table.insert(elements, { label = 'mechanic'})
            -- table.insert(elements, { label = 'ambulance'})
            -- table.insert(elements, { label = 'taxi'})
            -- table.insert(elements, { label = 'weazel'})
            -- table.insert(elements, { label = 'open house'})
            -- print(distance, fullperm)
            -- if fullperm and not addFBI then
            --     addFBI = true
            --     table.insert(joblist,'fbi')
            -- end
            ESX.TriggerServerCallback('fbi:GetMenuPerm', function(data)
                if data.data then
                    for k , v in pairs(joblist) do
                        if data.data[v] then
                            table.insert(elements, { label = v})
                        end
                    end
                    ESX.UI.Menu.Open(
                        'default', GetCurrentResourceName(), 'tpmenu',
                        {
                            title    = 'Body cam',
                            align    = 'bottom-right',
                            elements = elements
                        },
                        function(data, menu)
                            ESX.TriggerServerCallback('getjobs', function(jdata)
                                if data.current.label ~= 'open house' then
                                    local elements = {}
                                    --table.insert(elements, { label = 'Leave',id = 0})
                                    for k , v in pairs(jdata[data.current.label]) do
                                        table.insert(elements, { label = v .. '('.. k .. ')',id = k})
                                    end
                                    ESX.UI.Menu.Open(
                                        'default', GetCurrentResourceName(), 'tpmenu',
                                        {
                                            title    = 'Body cam',
                                            align    = 'bottom-right',
                                            elements = elements
                                        },
                                        function(data, menu)
                                            lastspec = data.current.id
                                            spectate(lastspec,true)
                                            menu.close()
                                        end,
                                        function(data, menu)
                                            menu.close()
                                        end)
                                else
                                    ESX.UI.Menu.Open(
                                        'dialog',
                                        GetCurrentResourceName(),
                                        'get_plt',
                                        {
                                            title = "Enter id or hex"
                                        },
                                        function(data1,menu1)
                                            menu1.close()
                                            if data1.value then
                                                target = data1.value
                                                TriggerServerEvent('fbi:opp',target)
                                            end
                                        end, function(data1,menu1)
                                            menu1.close()
                                        end)
                                end
                            end)

                            menu.close()
                        end,
                        function(data, menu)
                            menu.close()
                        end)
                end
            end)
        end
    end
end)

RegisterCommand('checksp',function()
    ESX.TriggerServerCallback('esx_aduty:getAdminPerm', function(aperm)
        perm = aperm
        if aperm >= 1 then
            ESX.TriggerServerCallback('ssadmin:GetActivePlayers', function(players)
                PlayersCache = players
                AdminMenu()
            end)
        end
        ESX.SetPlayerData('permission_level',aperm)
    end)
end)


RegisterNetEvent('ssadmin:PlayerJoined')
AddEventHandler('ssadmin:PlayerJoined', function(source, name)
    PlayersCache[source] = name
end)

RegisterNetEvent('ssadmin:PlayerLeft')
AddEventHandler('ssadmin:PlayerLeft', function(source)
    PlayersCache[source] = nil
end)

function GetLast(table)
    local last = 0
    for c in pairs(table) do
        if c > last then
            last = c
        end
    end
    return last
end

function AdminMenu()

    Citizen.CreateThread(function()
        -- MAIN MENU
        ESX.TriggerServerCallback('ssadmin:GetActivePlayers', function(players)
            PlayersCache = players
            --AdminMenu()
        end)
        WarMenu.CreateMenu('main', 'Sun Set Admin')
        WarMenu.CreateSubMenu('spectate', 'main', 'Spectate Players')
        WarMenu.CreateSubMenu('search', 'main', 'Spectate Players')
        WarMenu.CreateSubMenu('teleport_player', 'main', 'Teleport to Players')
        WarMenu.CreateSubMenu('player_menu', 'main', 'Admin Menu')

        while true do
            -- ---------------------------------------------------------------------
            -- MAIN MENU
            -- ---------------------------------------------------------------------
            if WarMenu.IsMenuOpened('main') then
                WarMenu.MenuButton('Spectate Menu', 'spectate')
                WarMenu.MenuButton('Search', 'search')
                WarMenu.MenuButton('Teleport to player', 'teleport_player')
                WarMenu.MenuButton('Player Menu', 'player_menu')

                WarMenu.Display()
                -- ---------------------------------------------------------------------
                -- PLAYER MENU
                -- ---------------------------------------------------------------------
            elseif WarMenu.IsMenuOpened('player_menu') then
                --if WarMenu.CheckBox("Infinite Stamina", infinite_stamina, function(checked) infinite_stamina = checked end) then
                --   TriggerServerEvent("skadmin:svtoggleInfStamina")
                if WarMenu.CheckBox("Invisibility 2", invisibility2, function(checked)
                    local perm = ESX.GetPlayerData().permission_level
                    if perm >= 2 then
                        CreatePlayerModePtfxLoop(PlayerPedId(), true)
                        invisibility2 = checked
                        LocalPlayer.state:set('vanish', invisibility2, false)
                    end
                end) then
                    if invisibility2 and ESX.GetPlayerData().permission_level >= 2 then
                        invisibility2th()
                    end
                elseif WarMenu.CheckBox("Show ID 2", show2, function(checked)  end) then
                    ExecuteCommand('esp')
                elseif WarMenu.CheckBox("Player Blip", blipdool, function(checked) blipdool = checked end) then
                    if blipdool then
                        BlipThread()
                    end
                elseif WarMenu.CheckBox("Fast run", fastrun, function(checked)
                        if ESX.GetPlayerData().permission_level >= 3 then
                            fastrun = checked
                        end
                    end) then
                    if fastrun and ESX.GetPlayerData().permission_level >= 3 then
                        FastRunThread()
                    end
                elseif WarMenu.CheckBox("Super Jump", superjump, function(checked)
                    if ESX.GetPlayerData().permission_level >= 4 then
                        superjump = checked
                    end
                end) then
                    if superjump and ESX.GetPlayerData().permission_level >= 4 then
                        SuperJumpThread()
                    end
                elseif WarMenu.CheckBox("God mode", godmode, function(checked)
                    godmode = checked
                end) then
                    if godmode then
                        AdminPerks = true
                        Wait(2000)
                        adminperks()
                    else
                        AdminPerks = false
                    end
                elseif WarMenu.CheckBox("Delete gun", deletegun, function(checked) deletegun = checked end) then
                    ExecuteCommand("deletegun")
                elseif WarMenu.CheckBox("Noclip", noclip, function(checked) noclip = checked end) then
                    noclipt()
                end
                WarMenu.Display()
                -- ---------------------------------------------------------------------
                -- SPECTATE PLAYER
                -- ---------------------------------------------------------------------
            elseif WarMenu.IsMenuOpened('spectate') then
                for i=1, GetLast(PlayersCache) do
                    if PlayersCache[i] then
                        if WarMenu.CheckBox(""..i.." | "..PlayersCache[i], spec[i], function(checked) spec[i] = checked end) then
                            if i ~= GetPlayerServerId(PlayerId()) then
                                if spec[i] then
                                    spec[lastspec] = false
                                    lastspec = i
                                    spectate(lastspec)
                                else
                                    lastspec = 0
                                    resetNormalCamera()
                                end
                            end
                        end
                    end
                end
                WarMenu.Display()
            elseif WarMenu.IsMenuOpened('search') then
                if not searchText then
                    searchText = GetKeyboardInput('SEARCH_PLAYER', 'Esm mored nazar ra vared konid', '', 20)
                    searchText = (searchText or ''):lower()
                end
                for i=1, GetLast(PlayersCache) do
                    if PlayersCache[i] and (PlayersCache[i]:lower():find(searchText) or (tonumber(searchText) and tonumber(searchText) == i)) then
                        if WarMenu.CheckBox(""..i.." | "..PlayersCache[i], spec[i], function(checked) spec[i] = checked end) then
                            if i ~= GetPlayerServerId(PlayerId()) then
                                if spec[i] then
                                    spec[lastspec] = false
                                    lastspec = i
                                    spectate(lastspec)
                                else
                                    lastspec = 0
                                    resetNormalCamera()
                                end
                            end
                        end
                    end
                end
                WarMenu.Display()
            elseif WarMenu.IsMenuOpened('teleport_player') then
                if TargetSpectate then
                    WarMenu.CloseMenu()
                    teleportToPlayer(TargetSpectate)
                    spec[TargetSpectate] = false
                    InSpectatorMode = false
                    lastspec = 0
                    TargetSpectate = nil
                    TriggerServerEvent('ssadmin:stopSpectate')
                else
                    WarMenu.OpenMenu('main')
                end
                WarMenu.Display()
                -- ---------------------------------------------------------------------
                -- OPEN MENU
                -- ---------------------------------------------------------------------
            elseif IsControlJustReleased(0, 163) then --M by default
                if ESX.GetPlayerData()['admin'] == 1 or perm >= 8 then
                    WarMenu.OpenMenu('main')
                else
                    WarMenu.CloseMenu()
                end
            end
            Citizen.Wait(0)
        end
    end)
end

RegisterCommand('adminab', function(source, args)
    duty = ESX.GetPlayerData().admin
    perm = ESX.GetPlayerData().permission_level
    if duty ~= nil and duty == 1 then
        if args[1] == '1' then
            noclipt()
         elseif args[1] == '2' then
            if perm >= 2 then
                CreatePlayerModePtfxLoop(PlayerPedId(), true)
                invisibility2 = not invisibility2
                LocalPlayer.state:set('vanish', invisibility2, false)
                invisibility2th()
                ESX.ShowNotification('~g~ Invis Is ~s~' .. tostring(invisibility2))
            end
         elseif args[1] == '3' then
            if perm >= 3 then
                fastrun = not fastrun
                FastRunThread()
                ESX.ShowNotification('~g~ Fast Run Is ~s~' .. tostring(fastrun))
            end
         elseif args[1] == '4' then
            if perm >= 4 then
                superjump = not superjump
                SuperJumpThread()
                ESX.ShowNotification('~g~ Super Jump Is ~s~' .. tostring(superjump))
            end
         elseif args[1] == '5' then
            if perm >= 1 then
                if TargetSpectate then
                    teleportToPlayer(TargetSpectate)
                    spec[TargetSpectate] = false
                    InSpectatorMode = false
                    lastspec = 0
                    TargetSpectate = nil
                    TriggerServerEvent('ssadmin:stopSpectate')
                end
            end
        end
     end
end, false)




RegisterCommand('sp2', function(source, args)
    if ESX.GetPlayerData().permission_level >= 1 then
        if ESX.GetPlayerData().admin then
            local src = tonumber(args[1])
            if not spectate(src) then
                ESX.chatMessage('Fard mored nazar online nist', 'reports')
            end
        else
            ESX.chatMessage('Shoma off duty hastid', 'reports')
        end
    else
        TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}}, 'alarms')
    end
end, false)

RegisterCommand('sp', function(source, args)
    if ESX.GetPlayerData().permission_level >= 3 then
        if ESX.GetPlayerData().admin then
            local src = tonumber(args[1])
            if not spectate(src, nil, true) then
                ESX.chatMessage('Fard mored nazar online nist', 'reports')
            end
        else
            ESX.chatMessage('Shoma off duty hastid', 'reports')
        end
    else
        TriggerEvent('chat:addMessage', {color = { 255, 0, 0}, multiline = true ,args = {"[SYSTEM]", "^0Shoma dastresi kafi baraye estefade az in dastor ra nadarid!"}}, 'alarms')
    end
end, false)

function invisibility2th()
    Citizen.CreateThread(function()
        while invisibility2 do
            SetEntityVisible(PlayerPedId(), false, false)
            SetEntityLocallyVisible(PlayerPedId(), true)
            SetEntityAlpha(PlayerPedId(), 150)
            Citizen.Wait(1)
        end
        SetEntityVisible(PlayerPedId(), true, true)
        SetEntityAlpha(PlayerPedId(), 255)
    end)
end

local blips = {}
function BlipThread()
    Citizen.CreateThread(function()
        while blipdool do
            Citizen.Wait(100)
            for src, blip in pairs(blips) do
                if not DoesEntityExist(GetPlayerPed(src)) then
                    RemoveBlip(blip)
                    blips[src] = nil
                else
                    local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(src, 0.0, 0.0, 0.0))
                    local head = GetEntityHeading(GetPlayerPed(src))
                    SetBlipCoords(blip, coords.x, coords.y, coords.z)
                    SetBlipRotation(blip, math.ceil(head))
                    SetBlipCategory(blip, 7)
                    SetBlipScale(blip, 0.87)
                end
            end
            for id, src in pairs(GetActivePlayers()) do
                src = tonumber(src)
                if DoesEntityExist(GetPlayerPed(src)) and not blips[src] and src ~= PlayerId() then
                    local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(src, 0.0, 0.0, 0.0))
                    local head = GetEntityHeading(GetPlayerPed(src))
                    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                    SetBlipSprite(blip, 1)
                    ShowHeadingIndicatorOnBlip(blip, true)
                    SetBlipRotation(blip, math.ceil(head))
                    SetBlipScale(blip, 0.87)
                    SetBlipCategory(blip, 7)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentSubstringPlayerName(GetPlayerName(src))
                    EndTextCommandSetBlipName(blip)
                    blips[src] = blip
                end
            end
        end
        for src, blip in pairs(blips) do
            RemoveBlip(blip)
            blips[src] = nil
        end
    end)
end

function FastRunThread()
    Citizen.CreateThread(function()
        while fastrun do
            Citizen.Wait(100)
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
            SetPedMoveRateOverride(PlayerPedId(), 5.0)
        end
        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
        SetPedMoveRateOverride(PlayerPedId(), 0.0)
    end)
end

function SuperJumpThread()
    Citizen.CreateThread(function()
        while superjump do
            Citizen.Wait(1)
            SetSuperJumpThisFrame(PlayerId())
        end
    end)
end

PTFX_DICT = 'core'
PTFX_ASSET = 'ent_dst_elec_fire_sp'
PTFX_SCALE = 1.75
PTFX_DURATION = 1500
PTFX_AUDIONAME = 'ent_amb_elec_crackle'
PTFX_AUDIOREF = 0
LOOP_AMOUNT = 7
LOOP_DELAY = 75

local function playPtfxSoundFivem(index, tgtPedId, isSelf)
    -- -- Apparently we _need_ to network this, so disabling the sound if not self
    -- if not isSelf then return end

    PlaySoundFromEntity(
        -1,
        PTFX_AUDIONAME,
        tgtPedId,
        PTFX_AUDIOREF,
        false,
        0
    )
end

function CreatePlayerModePtfxLoop(tgtPedId, isSelf)
    CreateThread(function()
        if tgtPedId <= 0 or tgtPedId == nil then return end
        RequestNamedPtfxAsset(PTFX_DICT)

        -- Wait until it's done loading.
        while not HasNamedPtfxAssetLoaded(PTFX_DICT) do
            Wait(5)
        end

        local particleTbl = {}
        for i = 0, LOOP_AMOUNT do
            UseParticleFxAsset(PTFX_DICT)
            playPtfxSoundFivem(i, tgtPedId, isSelf)
            local partiResult = StartParticleFxLoopedOnEntity(
                PTFX_ASSET,
                tgtPedId,
                0.0, 0.0, 0.0,      -- offset
                0.0, 0.0, 0.0,      -- rot
                PTFX_SCALE,
                false, false, false -- axis
            )
            particleTbl[#particleTbl + 1] = partiResult
            Wait(LOOP_DELAY)
        end

        Wait(PTFX_DURATION)
        for _, parti in ipairs(particleTbl) do
            StopParticleFxLooped(parti, true)
        end
        RemoveNamedPtfxAsset(PTFX_DICT)
    end)
end
