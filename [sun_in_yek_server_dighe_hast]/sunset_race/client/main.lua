-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local PlayerData = {}
local lobbies = {}
local lasthp = 0
local lastveh = 0
map = nil
roundcount = 0
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    if ESX.GetPlayerData() == nil then
        Citizen.Wait(500)
    end

    PlayerData = ESX.GetPlayerData()
end)

local secmap = ''

Draw = function(text,r,g,b,x,y)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.50, 0.50)
    SetTextColour( r,g,b, 255 )
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

local MyTeam  = nil
local MatchId = 0
local Teamate = {}
local spectate = false
local ShowText = false
local NotifiText = ""
local UIOpen    = false
local LocationIndex = 0

Config = {
    Join = {
        {
            -- coords = vector3(-253.74,-1992.31,29.15),
            coords = vec(-382.78, 1240.43, 36.48),
            access = {
                ["all"] = true
            }
        },
    },
    color = {
        {r = 255,g = 255, b = 255},
        {r = 255,g = 127, b = 80},
        {r = 255,g = 0, b = 0},
    },
    Clothe = {
    {
        male = {
        ['tshirt_1'] = 127,
        ['tshirt_2'] = 0,
        ['torso_1'] = 324,
        ['torso_2'] = 4,
        ['decals_1'] = 0,
        ['decals_2'] = 0,
        ['arms'] = 100,
        ['arms_2'] = 8,
        ['pants_1'] = 125,
        ['pants_2'] = 4,
        ['shoes_1'] = 61,
        ['shoes_2'] = 0,
        ['helmet_1'] = -1,
        ['helmet_2'] = 0,
        ['chain_1'] = 1,
        ['chain_2'] = 0,
        ['ears_1'] = -1,
        ['ears_2'] = -1,
        ['mask_1'] = 125,
        ['mask_2'] = 21,
        ['bags_1'] = 0,
        ['bags_2'] = 0,
        },
        female = {
        ['tshirt_1'] = 157,
        ['tshirt_2'] = 0,
        ['torso_1'] = 336,
        ['torso_2'] = 4,
        ['decals_1'] = 0,
        ['decals_2'] = 0,
        ['arms'] = 121,
        ['arms_2'] = 8,
        ['pants_1'] = 131,
        ['pants_2'] = 4,
        ['shoes_1'] = 64,
        ['shoes_2'] = 0,
        ['helmet_1'] = -1,
        ['helmet_2'] = 0,
        ['chain_1'] = 1,
        ['chain_2'] = 0,
        ['ears_1'] = -1,
        ['ears_2'] = -1,
        ['mask_1'] = 125,
        ['mask_2'] = 21,
        ['bags_1'] = 0,
        ['bags_2'] = 0,
        },
    },
    {
    male = {
        ['tshirt_1'] = 127,
        ['tshirt_2'] = 2,
        ['torso_1'] = 324,
        ['torso_2'] = 7,
        ['decals_1'] = 0,
        ['decals_2'] = 0,
        ['arms'] = 100,
        ['arms_2'] = 1,
        ['pants_1'] = 125,
        ['pants_2'] = 7,
        ['shoes_1'] = 61,
        ['shoes_2'] = 4,
        ['helmet_1'] = -1,
        ['helmet_2'] = 0,
        ['chain_1'] = 1,
        ['chain_2'] = 0,
        ['ears_1'] = -1,
        ['ears_2'] = -1,
        ['mask_1'] = 125,
        ['mask_2'] = 5,
        ['bags_1'] = 0,
        ['bags_2'] = 0,
    },
        female = {
        ['tshirt_1'] = 157,
        ['tshirt_2'] = 2,
        ['torso_1'] = 336,
        ['torso_2'] = 7,
        ['decals_1'] = 0,
        ['decals_2'] = 0,
        ['arms'] = 121,
        ['arms_2'] = 1,
        ['pants_1'] = 131,
        ['pants_2'] = 7,
        ['shoes_1'] = 64,
        ['shoes_2'] = 4,
        ['helmet_1'] = -1,
        ['helmet_2'] = 0,
        ['chain_1'] = 1,
        ['chain_2'] = 0,
        ['ears_1'] = -1,
        ['ears_2'] = -1,
        ['mask_1'] = 125,
        ['mask_2'] = 5,
        ['bags_1'] = 0,
        ['bags_2'] = 0,
        }, 
    }
    }
}

local Maps = {
    keshti = {
		limit = 11,
        radius = 200.0,
        hideMarker = false,
        markerCoords = vector3(3044.76,-4692.46,15.26),
        TDM = true,
        DM = true,
        locations = {
            {
                vector4(3077.52,-4762.85,15.26,17.47),
                vector4(3071.32,-4764.85,15.26,16.78),
                vector4(3083.54,-4761.03,15.26,16.52),
                vector4(3065.22,-4766.71,15.26,18.1),
                vector4(3090.69,-4759.16,15.26,16.10),
                vector4(3059.31,-4768.74,15.26,16.55),
                vector4(3083.75,-4772.67,15.26,17.16),
                vector4(3077.53,-4774.74,15.26,16.09),
                vector4(3090.28,-4770.52,15.26,15.78),
                vector4(3070.94,-4777.1,15.26,17.53),
                vector4(3098.05,-4768.57,15.26,17.11),
            },
            {
                vector4(3030.96,-4604.72,15.26,195.21),
                vector4(3037.25,-4602.69,15.26,202.38),
                vector4(3024.11,-4605.8,15.26,195.45),
                vector4(3043.37,-4600.65,15.26,200.94),
                vector4(3016.87,-4607.46,15.26,195.2),
                vector4(3049.29,-4599.05,15.26,195.33),
                vector4(3030.99,-4591.68,15.26,194.07),
                vector4(3037.57,-4589.58,15.26,195.92),
                vector4(3023.98,-4593.03,15.26,197.91),
                vector4(3043.62,-4587.46,15.26,197.42),
                vector4(3017.12,-4594.94,15.26,197.72),
            }
        },
    },
	air = {
		limit = 11,
        radius = 200.0,
        hideMarker = false,
        markerCoords = vector3(-1430.82,-2989.71,13.96),
        TDM = true,
        DM = true,
        locations = {
            {
                vector4(-1336.11,-3044.12,13.94,60.18),
                vector4(-1339.03,-3049.51,13.94,58.53),
                vector4(-1333.14,-3038.83,13.94,58.89),
                vector4(-1342.41,-3054.79,13.94,60.15),
                vector4(-1329.82,-3033.85,13.94,58.96),
                vector4(-1327.71,-3052.31,13.94,61.48),
                vector4(-1324.93,-3047.34,13.94,57.1),
                vector4(-1330.68,-3058.12,13.94,59.24),
                vector4(-1321.48,-3042.45,13.94,57.08),
                vector4(-1333.48,-3063.41,13.94,63.01),
                vector4(-1317.99,-3037.36,13.94,55.83),
            },
            {
                vector4(-1526.08,-2934.53,13.94,239.40),
                vector4(-1523.34,-2929.7,13.94,241.47),
                vector4(-1528.94,-2939.6,13.94,239.93),
                vector4(-1520.67,-2924.75,13.95,238.55),
                vector4(-1532.14,-2944.43,13.94,237.7),
                vector4(-1534.54,-2926.6,13.94,240.87),
                vector4(-1537.33,-2931.3,13.94,238.01),
                vector4(-1532.22,-2921.35,13.94,242.05),
                vector4(-1540.55,-2936.32,13.94,240.17),
                vector4(-1529.65,-2916.43,14.27,244.23),
                vector4(-1543.47,-2941.2,14.28,237.75),
            }
        },
    }
}

RegisterNUICallback('GetMaps', function(data, cb)
    cb(Maps)
end)

-- Register Events
local toggle = false
local cangive = false

RegisterNetEvent('esx:changeworld')
AddEventHandler('esx:changeworld',function(world)
    if world ~= 0 then
        cangive = true
    else
        cangive = false
    end
end)

local disnext = false
local t1c = 0
local t2c = 0
local matchdata = nil
local selectedtime = 120000
local thread = false
local lastData = {}
local Score = {}
RegisterNetEvent('sunset_race:Start')
AddEventHandler('sunset_race:Start', function(Team, Map, vehicle, Id,rc,t1,t2,data,key,scorelist)
	if lasthp == 0 then
		lasthp = GetEntityHealth(PlayerPedId())
	end
    thread = false
    DoScreenFadeOut(500)
	Citizen.Wait(500)
    PlayerPed = PlayerPedId()
    if t1 then
        t1c = t1
        t2c = t2
    end
    if rc then
        roundcount = rc
    end
	if data then
        matchdata = data
    end
    if not matchdata then 
        TriggerServerEvent('backme')
        DoScreenFadeIn(0)
        return
    end

	if scorelist then
		Score = {}
		for k , v in pairs(scorelist) do
			if ESX.Game.PlayerExist(k) then
				table.insert(Score,{name = GetPlayerName(GetPlayerFromServerId(k)),score = v})
			end
		end
		table.sort(Score, function(a,b)
			return a.score > b.score
		end)
	end
	
    if disnext then return end
    disnext = true
    Citizen.SetTimeout(5000,function()
        disnext = false
    end)
    TriggerEvent('esx_inventoryhud:br',true)
    exports["suncore"]:Whitelist(true)
    PaintBallMenu(false)
    spectate = false
    map = Map
    MyTeam = nil
    MyTeam = Team
    MatchId = Id
	RespawnPed(GetEntityCoords(PlayerPedId()), 206.36)	
    TriggerEvent('skinchanger:getSkin', function(skin)
        if tonumber(skin.sex) == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, Config.Clothe[MyTeam].male)
        else
            TriggerEvent('skinchanger:loadClothes', skin, Config.Clothe[MyTeam].female)
        end
    end)
    TriggerDisableControl()
    TriggerEvent('esx:updatecoords',false)
    TriggerEvent('event', true)
    RemoveAllPedWeapons(PlayerPed, false)
    NetworkSetInSpectatorMode(false, 0)
    local spawnpoint = nil
	if matchdata.type == 'sdm' then
		local locs = {}
		for k , v in pairs(Maps[Map].locations) do
			for k2 , v2 in pairs(v) do
				table.insert(locs,v2)
			end
		end
		spawnpoint = locs[key]
		ESX.SetEntityCoords(PlayerPed, spawnpoint.xyz)
	else
		if toggle then
			toggle = false
			local loc = 0
			if MyTeam == 1 then
				loc = 2
			else
				loc = 1
			end
			spawnpoint = Maps[Map].locations[loc][key]
			ESX.SetEntityCoords(PlayerPed, Maps[Map].locations[loc][key].xyz)
		else
			toggle = true
			spawnpoint = Maps[Map].locations[MyTeam][key]
			ESX.SetEntityCoords(PlayerPed, Maps[Map].locations[MyTeam][key].xyz)
		end
	end
    
    while not cangive do Wait(10) end
    TriggerEvent('es_admin:freezePlayer', true)
    while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
		Citizen.Wait(0)
	end
    TriggerEvent('es_admin:freezePlayer', false)
    exports.suncore:SetPlayerVisible(true)
	if DoesEntityExist(lastveh) then
        ESX.Game.DeleteVehicle(lastveh)
    end
    ESX.Game.SpawnVehicle(vehicle, spawnpoint.xyz, spawnpoint.w, function(vehicle)
        lastveh = vehicle
        if matchdata.type == 'sdm' then 
            ESX.Game.SetVehicleProperties(vehicle,{
                IsPrimaryCustomColor = 1,
                PrimaryCustomColor = Config.color[3]
            })
        else
            ESX.Game.SetVehicleProperties(vehicle,{
                IsPrimaryCustomColor = 1,
                PrimaryCustomColor = Config.color[MyTeam]
            })
        end
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        WashDecalsFromVehicle(vehicle, 1.0)
        SetVehicleDirtLevel(vehicle)
        Citizen.CreateThread(function()
			while GetVehiclePedIsIn(PlayerPedId()) ~= vehicle or not GetIsVehicleEngineRunning(lastveh) do Citizen.Wait(100) end
            ESX.setVehicleFuel(GetVehiclePedIsIn(PlayerPedId()), 100.0)
            if matchdata.type == 'tdm' or matchdata.type == 'sdm' then
                thread = true
                Citizen.CreateThread(function()
                    while thread do
                        Citizen.Wait(1)
                        if not DoesEntityExist(lastveh)  or not GetIsVehicleEngineRunning(lastveh) or GetVehicleEngineHealth(lastveh) < 1 or GetVehiclePedIsIn(PlayerPedId()) ~= vehicle then
                            ESX.Game.DeleteVehicle(vehicle)
                            if MyTeam then
                                TriggerServerEvent('sunset_race:OnPlayerDeath', MatchId, MyTeam)
                                spectate = true
                                SpectateCitizen()
                            end
                            break
                        end
                    end
                end)
            end
            Citizen.SetTimeout(2000,function()
                TriggerEvent("seatbelt:beband")
            end)
        end)
	end)
    if Maps[map].radius >  0 then
        Citizen.CreateThread(function()
            thread = true
            while thread do
                Citizen.Wait(1)
                local coords = GetEntityCoords(PlayerPedId())
                if not Maps[map].hideMarker then
                    DrawMarker(28,Maps[map].markerCoords, 0, 0, 0, 0, 0, 0, Maps[map].radius, Maps[map].radius, Maps[map].radius, 255, 0, 0, 50, 0, 0, 0, 0, 0, 0, 0)
                end
                if Vdist(Maps[map].markerCoords.x,Maps[map].markerCoords.y,0,coords.x,coords.y,0) >= Maps[map].radius then
                    ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                end
            end
        end)
    end
	if matchdata.type == 'sdm' then
		Citizen.CreateThread(function()
			thread = true
			while thread do
				Citizen.Wait(1)
				local t = 1
				drawTxt(1.42, 0.9 + (t * 0.030), 1.0,1.0,0.4,"~g~".. roundcount ..  " Round~w~", 255, 255, 255, 255)
				for k , v in pairs(Score) do
					t = t + 1
					local color = "~w~"
					if t == 2 then
						color = "~y~"
					elseif t == 3 then
						color = "~c~"
					elseif t == 4 then
						color = "~r~"
					end
					drawTxt(1.42, 0.9 + (t * 0.030), 1.0,1.0,0.4,color .. v.name .. "~w~(".. v.score ..  ")", 255, 255, 255, 255)
				end
			end
		end)
	end

    
    if matchdata.type == 'tdm' then
        SendNUIMessage({
            type = 'start',
            time = selectedtime,
            round = roundcount,
        })
        Wait(500)
        if t1c ~= 0 then
            SendNUIMessage({
                type = 'updatealive1',
                t1 = t1c,
            })
            SendNUIMessage({
                type = 'updatealive2',
                t2 = t2c,
            })
        end
    end
    -- if matchdata then
    --   local armor = tonumber(matchdata["armor"])
    --   if armor > 98 then
    --     armor = 98
    --   end
    --   local head = tonumber(matchdata["head"])
    --   selectedtime = tonumber(matchdata["timer"])
    --   ESX.SetPedArmour(PlayerPedId(),armor)
    --   if head == 0 then
    --     SetPedSuffersCriticalHits(GetPlayerPed(-1), false)
    --   end
    -- end
    --PaintBallUI(true)
    -- if t1c ~= 0 then
    --   SendNUIMessage({
    --     type = 'updatealive1',
    --     t1 = t1c,
    --   })
    --   SendNUIMessage({
    --     type = 'updatealive2',
    --     t2 = t2c,
    --   })
    -- end
	
    DoScreenFadeIn(2000)
end)

RegisterNetEvent('sunset_race:MyTeamate')
AddEventHandler('sunset_race:MyTeamate', function(teamate)
    for player in pairs(teamate) do
        table.insert(Teamate, teamate[player].source)
    end
end)

RegisterNetEvent('sunset_race:startsp')
AddEventHandler('sunset_race:startsp', function(map,t1,t2,rc,data)
    if rc then
        roundcount = rc
    end
    if data then
        matchdata = data
    end
    --selectedtime = tonumber(matchdata["timer"])
    local coords = vector3(Maps[map][3].x,Maps[map][3].y,Maps[map][3].z + 30)
    radius = Maps[map][4]
    markercoords = Maps[map][3]
    ESX.SetEntityCoords(PlayerPedId(), coords)
    exports.suncore:Whitelist(true)
    exports.suncore:SetPlayerVisible(false)
    TriggerEvent('es_admin:freezePlayer', true)
    PaintBallMenu(false)
    Wait(6000)
    spectate = true
    PaintBallUI(true)
    if t1 then
        t1c = t1
        t2c = t2
    end
    SendNUIMessage({
        type = 'updatealive1',
        t1 = t1c,
    })
    SendNUIMessage({
        type = 'updatealive2',
        t2 = t2c,
    })
    Wait(1000)
    SpectateCitizen()
    timer = 0
    kiri = false
    losehp = false
    Wait(1000)
    kiri = true
    timer = selectedtime
    timerthread()
end)

RegisterNetEvent('sunset_race:UpdatePlayer')
AddEventHandler('sunset_race:UpdatePlayer', function(LobbyId, source, team, string)
    TriggerEvent('sunset_race:UserLeftTeam', LobbyId, team, source)
    TriggerEvent('sunset_race:UserJoinTeam', LobbyId, string, team)
end)

-- AddEventHandler('esx:onPlayerDeath', function(data)
--     if MyTeam then
-- 		ESX.Game.DeleteVehicle(vehicle)
--         TriggerServerEvent('sunset_race:OnPlayerDeath', MatchId, MyTeam,data)
--         spectate = true
--         SpectateCitizen()
--     end
-- end)

RegisterNetEvent('sunset_race:CloseLobby')
AddEventHandler('sunset_race:CloseLobby', function()
    PaintBallMenu(false)
end)

RegisterNetEvent('sunset_race:SetTeamCount')
AddEventHandler('sunset_race:SetTeamCount', function(UTeam, Count)
    if MyTeam == UTeam then
        ESX.ShowNotification('Az Team Shoma~r~ '.. Count ..' ~s~nafar Zende ast')
    else
        ESX.ShowNotification('Az Team ~y~('.. UTeam ..')~g~ '.. Count ..' ~s~nafar Zende ast')
    end
    if UTeam == 1 then
        SendNUIMessage({
            type = 'updatealive1',
            t1 = Count,
        })
    else
        SendNUIMessage({
            type = 'updatealive2',
            t2 = Count,
        })
    end
end)

RegisterNetEvent('sunset_race:RoundWinner')
AddEventHandler('sunset_race:RoundWinner', function(MyTeam, Winner)
    if MyTeam == Winner then
        ShowText   = true
        NotifiText = "~g~You Won This Round~s~"
    else
        ShowText   = true
        NotifiText = ("~r~Team %s Won Round~s~"):format(Winner)
    end
    Wait(5000)
    ShowText   = false
end)

RegisterNetEvent('sunset_race:RoundWinner2')
AddEventHandler('sunset_race:RoundWinner2', function(Winner)
    ShowText = true
    NotifiText = ("~r~%s Won Round~s~"):format(Winner)
    Wait(5000)
    ShowText   = false
end)

RegisterNetEvent('sunset_race:UserJoinTeam')
AddEventHandler('sunset_race:UserJoinTeam', function(lobby, value, team)
    SendNUIMessage({
        action = 'JoinTeam',
        team = team,
        value = value
    })
end)

RegisterNetEvent('sunset_race:UserLeftTeam')
AddEventHandler('sunset_race:UserLeftTeam', function(lobby, team, player)
    SendNUIMessage({
        action = 'LeftTeam',
        team = team,
        player = player
    })
end)

RegisterNetEvent('sunset_race:End')
AddEventHandler('sunset_race:End', function(myTeam, Winner,tamam,sdm)
	DoScreenFadeOut(100)
	Citizen.Wait(100)
	if DoesEntityExist(lastveh) then
        ESX.Game.DeleteVehicle(lastveh)
    end
	thread = false
    FreezeEntityPosition(PlayerPedId(),false)
    matchdata = nil
    ESX.SetPedArmour(PlayerPedId(),0)
    if not spectate then
        TriggerEvent('es_admin:freezePlayer', false)
    else
        SetTimeout(3000,function()
            TriggerEvent('es_admin:freezePlayer', false)
        end)
    end
    Teamate = {}
    MatchId = 0
    ShowText   = true
    timer = 0
    kiri = false
	if sdm then
		NotifiText = ("~r~%s Won Match~s~"):format(Winner)
	else
		if myTeam == Winner then
			NotifiText = "~g~You Won This Match~s~"
		else
			NotifiText = ("~r~Team %s Won Match~s~"):format(Winner)
		end
	end
    Wait(500)
	RespawnPed(GetEntityCoords(PlayerPedId()), 206.36)	
	TriggerEvent('medic:revive', true)
    NetworkSetInSpectatorMode(false, 0)
    Wait(500)
    exports['sunset_clothe']:removeStuffJob()
    Citizen.Wait(1000)
    exports['sunset_clothe']:loadUsed()
    local PlayerPed = GetPlayerPed(-1)
    TriggerEvent('event', false)
    SendNUIMessage({
        type = 'show',
        show = false
    })
    MyTeam     = nil
    Wait(500)
    RemoveAllPedWeapons(PlayerPed, false)
    TriggerEvent('esx:restoreLoadout')
    TriggerEvent('esx:stateweaponcheck', true)
    TriggerEvent('esx:updatecoords',true)
    Wait(1500)
    ESX.SetEntityCoords(PlayerPed, Config.Join[LocationIndex].coords.x, Config.Join[LocationIndex].coords.y, Config.Join[LocationIndex].coords.z + 3.0)
    Wait(5000)
    ShowText   = false
    exports.suncore:SetPlayerVisible(true)
    exports["suncore"]:Whitelist(false)
    TriggerEvent('esx_inventoryhud:br',false)
    TriggerServerEvent('backme')
    toggle = false
    Wait(1500)
    losehp = false
    kiri = false
    NetworkSetInSpectatorMode(false, 0)
    PaintBallUI(false)
    TriggerEvent('status:setupdate',true)
    if tamam and lasthp ~= 0 then
        ESX.SetEntityHealth(PlayerPedId(),lasthp)
        lasthp = 0
    end
	DoScreenFadeIn(2000)
end)

-- Register NUI Callbacks
RegisterNUICallback('CreateLobby', function(data, cb)
    ESX.TriggerServerCallback('sunset_race:createLobby', function(lobid)
        cb(lobid)
    end, data)
	secmap = data.mapName
end)


RegisterNUICallback('JoinLobby', function(data, cb)
    ESX.TriggerServerCallback('sunset_race:GetLobbyPlayers', function(Team,_)
        local newData = {
            LobbyId = data.LobbyId,
            Source = GetPlayerServerId(PlayerId()),
            Name = GetPlayerName(PlayerId()),
            Team = 0
        }
		secmap = _.data.mapName
        TriggerServerEvent('sunset_race:JoinLobby', newData)
        local element = {
            [0] = {},
            [1] = {},
            [2] = {},
			type = _.data.type,
        };
        for k,v in pairs(Team) do
            for k2,v2 in pairs(v) do
                table.insert(element[k], {id = v2.source, value = v2.value})
            end
        end
        cb(json.encode(element))
    end, data.LobbyId)
end)

RegisterNUICallback('LobbyList', function(data, cb)
    ESX.TriggerServerCallback('sunset_race:GetActiveLobbies', function(lbs)
        cb(json.encode(lbs))
    end)
end)

RegisterNUICallback('GetLobbyPassword', function(data, cb)
    local lobbyid = data.LobbyId
    local pass = 1111111111
    ESX.TriggerServerCallback('sunset_race:GetActiveLobbies', function(lobbies)
        for k , v in ipairs(lobbies) do
            if tonumber(v.LobbyId) == tonumber(lobbyid) then
                pass = v.pass
                break
            end
        end
        cb(pass)
    end)
end)

RegisterNUICallback('ToggleReadyPlayer', function(data, cb)
    TriggerServerEvent('sunset_race:Ready', data)
end)

RegisterNUICallback('JoinTeam', function(data)
    TriggerServerEvent('sunset_race:JoinTeam', data)
end)

RegisterNUICallback('LeftTeam', function(data)
    TriggerServerEvent('sunset_race:LeftTeam', data)
end)

RegisterNUICallback('SwitchTeam', function(data, cb)
    ESX.TriggerServerCallback('sunset_race:SwitchTeamCheck', function(limited)
        if not limited then
            cb(true)
            TriggerServerEvent('sunset_race:SwitchTeam', data)
        end
    end, data,Maps[secmap].limit)
end)

RegisterNUICallback('StartMatch', function(data)
    TriggerServerEvent('sunset_race:StartMatch', {LobbyId = data.LobbyId})
end)

RegisterNUICallback('QuitLobby', function(data)
    TriggerServerEvent('sunset_race:QuitLobby', data)
    PaintBallMenu(false)
end)

RegisterNetEvent('QuitLobby')
AddEventHandler('QuitLobby', function()
    PaintBallMenu(false)
end)

RegisterNUICallback('QuitFromMenu', function(data)
    PaintBallMenu(false)
end)

function Initialize(scale, text)
    local scaleform = RequestScaleformMovie(scale)

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
    PushScaleformMovieFunctionParameterString(text)
    PopScaleformMovieFunctionVoid()
    return scaleform
end

lastcoords = {}
function TriggerDisableControl()
    Citizen.CreateThread(function()
        while MyTeam do
            Citizen.Wait(0)
            DisableControlAction(2, Keys['F2'], true)
            DisableControlAction(2, Keys['F6'], true)
            DisableControlAction(2, Keys['G'], true)
            DisableControlAction(2, Keys['E'], true)
            DisableControlAction(2, Keys['K'], true)
            DisableControlAction(2, Keys['PAGEUP'], true)
            DisableControlAction(0,75,true)
            DisableControlAction(27,75,true)
        end
    end)

    Citizen.CreateThread(function()
        while MyTeam do
            Citizen.Wait(0)
            if ShowText then
                local scaleform = Initialize("mp_big_message_freemode", NotifiText)
                DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            end
        end
    end)
    -- Citizen.CreateThread(function()
    --   while MyTeam do
    --     Citizen.Wait(1000)
    --     if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),Maps[map][3],false) > Maps[map][4] then
    --   if lastcoords ~= {} then
    --       SetEntityCoords(PlayerPedId(),lastcoords)
    --   end
    --     else
    --       lastcoords = GetEntityCoords(PlayerPedId())
    --     end
    --   end
    -- end)
end

function SpectateCitizen()
    exports["suncore"]:Whitelist(true)
    local currect = 1
    local Target  = GetPlayerFromServerId(Teamate[currect])
    local TPed    = GetPlayerPed(Target)

    local function spec()
        NetworkSetInSpectatorMode(false, 0)
        NetworkSetInSpectatorMode(true, TPed)
    end

    local function increase()
        currect = currect + 1
        if currect > #Teamate then
            currect = 1
        end
        Target = GetPlayerFromServerId(Teamate[currect])
        TPed = GetPlayerPed(Target)
        spec()
    end

    local function decrease()
        currect = currect - 1
        if currect > #Teamate then
            currect = #Teamate
        end
        Target = GetPlayerFromServerId(Teamate[currect])
        TPed = GetPlayerPed(Target)
        spec()
    end

    local function alowToSpec()
        return NetworkIsPlayerActive(Target) and not IsPedDeadOrDying(TPed, true) and not (Target == PlayerId())
    end

    local function GetAlivePlayers()
        local count = 0
        for _,p in pairs(Teamate) do
            local Target = GetPlayerFromServerId(p)
            local TPed   = GetPlayerPed(Target)
            if NetworkIsPlayerActive(Target) and not IsPedDeadOrDying(TPed, true) and Target ~= PlayerId() then
                count = count + 1
            end
        end
        return count
    end

    Citizen.CreateThread(function()
        spec()
        while spectate and GetAlivePlayers() > 0 do
            DisableControlAction(0, 37, true)
            Wait(0)
            if not alowToSpec() then
                increase()
            end
            if IsControlJustPressed(1, 40) then
                increase()
            elseif IsControlJustPressed(1, 39) then
                decrease()
            end
            if DoesEntityExist(TPed) then
                local text = {}
                table.insert(text,"ID: "..GetPlayerServerId(Target))
                table.insert(text,"Steam Name: "..GetPlayerName(Target))
                table.insert(text,"Vehicle health: ".. ESX.Math.Round(GetEntityHealth(GetVehiclePedIsIn(TPed)) / 10) .."/100")
                table.insert(text,"Armor: "..GetPedArmour(TPed))
                for i, theText in pairs(text) do
                    SetTextFont(0)
                    SetTextProportional(1)
                    SetTextScale(0.0, 0.30)
                    SetTextDropshadow(0, 0, 0, 0, 255)
                    SetTextEdge(1, 0, 0, 0, 255)
                    SetTextDropShadow()
                    SetTextOutline()
                    SetTextEntry("STRING")
                    AddTextComponentString(theText)
                    EndTextCommandDisplayText(0.03, 0.4+(i/30))
                end
            end
        end
    end)
end

function PaintBallMenu(display)
    MenuOpen = display
    SetNuiFocus(display, display)
    SendNUIMessage({
        type = 'show',
        show = display,
        create = true
    })
end

function PaintBallUI(display)
    if display then
        SendNUIMessage({
            type = 'start2',
            time = selectedtime,
            round = roundcount,
        })
    else
        SendNUIMessage({
            type = 'stop'
        })
    end
end

function UITIME()
    SendNUIMessage({
        type = 'time',
        time = selectedtime
    })
end

RegisterNetEvent('sunset_race:setteamwin')
AddEventHandler('sunset_race:setteamwin',function(t1,t2)
    local game = {}
    Wait(3000)
    SendNUIMessage({
        type = 'update',
        t1 = t1,
        t2 = t2,
    })
end)

RegisterNetEvent('sunset_race:setteamwin2')
AddEventHandler('sunset_race:setteamwin2',function(t1,t2)
    PaintBallMenu(false)
    Wait(1000)
    PaintBallUI(true)
    Wait(3000)
    SendNUIMessage({
        type = 'update',
        t1 = t1,
        t2 = t2,
    })
    SendNUIMessage({
        type = 'updatealive1',
        t1 = t1c,
    })
    SendNUIMessage({
        type = 'updatealive2',
        t2 = t2c,
    })
    timer = 0
    kiri = false
    losehp = false
    Wait(1000)
    timer = 0
    kiri = false
    losehp = false
    Wait(1000)
    kiri = true
    timer = selectedtime
    timerthread()
end)

-- function CreateBlip(coords, name)
--     local blip = AddBlipForCoord(coords)
--     SetBlipSprite  (blip, 38)
--     SetBlipDisplay (blip, 4)
--     SetBlipScale   (blip, 1.2)
--     SetBlipCategory(blip, 3)
--     SetBlipColour  (blip, 69)
--     SetBlipAsShortRange(blip, true)

--     BeginTextCommandSetBlipName("STRING")
--     AddTextComponentString(name)
--     EndTextCommandSetBlipName(blip)
-- end

Citizen.CreateThread(function()
    -- CreateBlip(Config.Join[1].coords, 'Race')
    SetNuiFocus(false,false)
    NetworkSetInSpectatorMode(false, 0)
    while true do
        Wait(0)
        local PlayerPed = GetPlayerPed(-1)
        local coords    = GetEntityCoords(PlayerPed)
        for k , v in pairs(Config.Join) do
            if GetDistanceBetweenCoords(coords, v.coords, false) < 100.0 then
                DrawMarker(1, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 10.0, 10.0, 2.0, 0, 0, 0, 100, false, true, 2, false, false, false, false)
                if GetDistanceBetweenCoords(coords, v.coords, false) < 6.0 then
                    LocationIndex = k
                    if not UIOpen then
                        ESX.ShowHelpNotification('~INPUT_CONTEXT~ Baz Kardan Menu Race')
                    end
                    if IsControlJustPressed(1, Keys['E']) then
                        if v.access['all'] == true or v.access[PlayerData.job.name] == true then
                            if (PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "detective" or PlayerData.job.name == "justice" or PlayerData.job.name == "mt" or PlayerData.job.name == "fbi" or PlayerData.job.name == "mechanic" or PlayerData.job.name == "taxi") and not v.access[PlayerData.job.name] then
                                ESX.ShowNotification('Baraye Play Dar Race Bayad Dar Job Khodeton Off-Duty Konid')
                            else
                                UIOpen = true
                                PaintBallMenu(true)
                            end
                        end
                    end
                elseif UIOpen then
                    UIOpen = false
                    PaintBallMenu(false)
                end
            end
        end
    end
end)

Drawtext = function(text)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.50, 0.50)
    SetTextColour( 255,0,0, 255 )
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.8, 0.95)
end

function RespawnPed(coords, heading)
    ped = GetPlayerPed(-1)
    ESX.SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
    SetPlayerInvincible(ped, false)
    ESX.SetEntityHealth(ped, 200)
    ESX.SetPedArmour(ped, 0)
    TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
    ClearPedBloodDamage(ped)
    ESX.UI.Menu.CloseAll()
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

-- Citizen.CreateThread(function()
-- 	thread = true
-- 	while thread do
-- 		Citizen.Wait(1)
-- 		local t = 1
-- 		drawTxt(1.42, 0.9 + (t * 0.030), 1.0,1.0,0.4,"~g2 Round~w~", 255, 255, 255, 255)
-- 	end
-- end)