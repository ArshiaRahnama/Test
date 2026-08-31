

do
local ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- Was called in 3 places (hostage blip, pursuit blip, robbery blip) but never defined,
-- which threw "attempt to call a nil value (global 'PulseBlip')" whenever those blips spawned.
-- Gives the blip a soft breathing scale animation until it's removed.
function PulseBlip(blip)
	Citizen.CreateThread(function()
		while blip and DoesBlipExist(blip) do
			for i = 1, 20 do
				if not DoesBlipExist(blip) then break end
				SetBlipScale(blip, 0.6 + (i / 40))
				Citizen.Wait(30)
			end
			for i = 20, 1, -1 do
				if not DoesBlipExist(blip) then break end
				SetBlipScale(blip, 0.6 + (i / 40))
				Citizen.Wait(30)
			end
		end
	end)
end

RegisterNetEvent('DarkPhone:OpenMenu')
AddEventHandler('DarkPhone:OpenMenu', function()
	ESX.UI.Menu.CloseAll()
    local elements = {}
    table.insert(elements, {label = "Gerogan Giri", value = 'Hostage'})
    table.insert(elements, {label = "Shorooe Pursuit", value = 'Pursuit'})
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'DarkPhone_Menu', {
		title    = 'Dark Phone Menu',
		align    = 'left',
		elements = elements
	}, function(data, menu)
		menu.close()
		local action = data.current.value
		if action == "Hostage" then
            local coords = GetEntityCoords(PlayerPedId())
            TriggerServerEvent("DarkPhone:StartHostage",coords)
        elseif  action == "Pursuit" then
            local coords = GetEntityCoords(PlayerPedId())
            TriggerServerEvent("DarkPhone:StartPursuit",coords)
        end
	end, function(data, menu)
		menu.close()
	end)
end)

local hostageblip = nil
RegisterNetEvent('DarkPhone:killBlipHostage')
AddEventHandler('DarkPhone:killBlipHostage', function()
	RemoveBlip(hostageblip)
    hostageblip = nil
end)

RegisterNetEvent('DarkPhone:setBlipHostage')
AddEventHandler('DarkPhone:setBlipHostage', function(position)
    hostageblip = AddBlipForCoord(position.x, position.y, position.z)
	SetBlipSprite(hostageblip, 161)
	SetBlipScale(hostageblip, 0.7)
	SetBlipColour(hostageblip, 15)

	PulseBlip(hostageblip)
end)

RegisterNetEvent('DarkPhone:CheckDistance')
AddEventHandler('DarkPhone:CheckDistance', function(coords)
    local canceled = false
    local timer = Config.DarkPhone.Hostage.SuccessTime * 1000
    Citizen.CreateThread(function()
        while timer > 0 do
            Citizen.Wait(1000)
            local playerPos = GetEntityCoords(PlayerPedId(), true)
            local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, coords.x, coords.y, coords.z)
            if distance > Config.DarkPhone.Hostage.CancelDistance then
                canceled = true
                TriggerServerEvent("DarkPhone:CancelHostage")
                timer = 0
            end
            timer = timer - 1000
        end
        if not canceled then
            TriggerServerEvent("DarkPhone:SuccessHostage")
        end
    end)
end)

local PursuitBlip = nil

RegisterNetEvent('DarkPhone:setBlipPursuit')
AddEventHandler('DarkPhone:setBlipPursuit', function(position,id)
    PursuitBlip = AddBlipForCoord(position.x, position.y, position.z)
	SetBlipSprite(PursuitBlip, 225)
	SetBlipScale(PursuitBlip, 0.7)
	SetBlipColour(PursuitBlip, 1)
	PulseBlip(PursuitBlip)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Pursuit Car')
	EndTextCommandSetBlipName(PursuitBlip)
    while PursuitBlip do
        Citizen.Wait(2000)
        ESX.TriggerServerCallback('DarkPhone:getcoord', function(coords)
            if coords ~= nil then
                SetBlipCoords(PursuitBlip,coords)
            else
                RemoveBlip(PursuitBlip)
                PursuitBlip = nil
            end
        end,id)
    end
end)

RegisterNetEvent('DarkPhone:killBlipPursuit')
AddEventHandler('DarkPhone:killBlipPursuit', function()
	RemoveBlip(PursuitBlip)
    PursuitBlip = nil
end)

RegisterNetEvent('DarkPhone:StartProgressBar')
AddEventHandler('DarkPhone:StartProgressBar', function()
    TriggerEvent('mythic_progbar:client:progress', {
        name = 'Pursuit',
        duration = Config.DarkPhone.Pursuit.SuccessTime * 1000,
        label = 'Pursuit',
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = false,
        }
    }, function(status)
        if not status then
            TriggerServerEvent('DarkPhone:SuccessPursuit')
        end
    end)
end)
end

do
local ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

TriggerEvent('chat:addSuggestion', '/party', 'Menu Party', {
})

TriggerEvent('chat:addSuggestion', '/tchat', 'Chate Azaye Team', {
    { name="Matn", help="Matne Payam" }
})

TriggerEvent('chat:addSuggestion', '/tinvite', 'Invite Player To Team', {
    { name="ID", help="Player ID" }
})

RegisterNetEvent('TeamSystem:OpenMenu')
AddEventHandler('TeamSystem:OpenMenu', function(InTeam,id,team,teamid)
    local elements = {}

    if not InTeam then
        table.insert(elements, {
            img = "create.png", text = "Create New Team", text2 = "Start a new team",
            callBack = function()
                TriggerServerEvent('TeamSystem:CreateTeam')
                Citizen.Wait(200)
                ExecuteCommand("party")
            end
        })
    else
        table.insert(elements, {
            img = "human.png", text = team[id].name, text2 = "Rank: " .. team[id].rank
        })

        if team[id].rank == "Leader" then
            table.insert(elements, {
                img = "give.png", text = "Invite Player", text2 = "Use /tinvite [ID]",
                callBack = function()
                    TriggerEvent('chat:addMessage', {args = {"^1[Team]", "Baraye Da'vat Az ^2/tinvite [ID] ^0Estefade Konid"}})
                end
            })
        end

        table.insert(elements, {
            img = "stop.png",
            text = (team[id].rank == "Leader") and "Disband Team" or "Leave Team",
            text2 = (team[id].rank == "Leader") and "Deletes the team for everyone" or "Leave this team",
            callBack = function()
                if team[id].rank == "Leader" then
                    TriggerServerEvent('TeamSystem:DeleteTeam', teamid)
                else
                    TriggerServerEvent('TeamSystem:LeaveTeam', teamid)
                end
            end
        })

        for playerid,details in pairs(team) do
            if playerid ~= id then
                table.insert(elements, {
                    img = "human.png", text = details.name, text2 = details.rank,
                    callBack = function()
                        if team[id].rank == "Leader" then
                            OpenMemberMenu(playerid, details, team, teamid, id)
                        end
                    end
                })
            end
        end
    end

    exports.icon_menu:OpenMenu(elements, {
        positionX   = "90%",
        positionY   = "50%",
        size        = "0.9",
        maxHeight   = "80vh",
    })
end)

function OpenMemberMenu(playerid, details, team, teamid, id)
    local elements = {
        {
            img = "back.png", text = "Back", text2 = "Return to team menu", isBack = true,
            callBack = function()
                TriggerEvent('TeamSystem:OpenMenu', true, id, team, teamid)
            end
        },
        {
            img = "level.png", text = "Promote To Leader", text2 = details.name,
            callBack = function()
                TriggerServerEvent('TeamSystem:Promote', teamid, playerid)
                Citizen.Wait(200)
                ExecuteCommand("party")
            end
        },
        {
            img = "delete.png", text = "Kick", text2 = details.name,
            callBack = function()
                TriggerServerEvent('TeamSystem:Kick', teamid, playerid)
                Citizen.Wait(200)
                ExecuteCommand("party")
            end
        },
    }

    exports.icon_menu:OpenMenu(elements, {
        positionX   = "90%",
        positionY   = "50%",
        size        = "0.9",
        maxHeight   = "80vh",
    })
end

RegisterNetEvent('TeamSystem:AskForInvite')
AddEventHandler('TeamSystem:AskForInvite', function(Invitename,InvitedTeamID)
    local elements = {
        {
            img = "quest.png", text = "Accept Invite", text2 = "From " .. Invitename,
            callBack = function()
                TriggerEvent('chat:addMessage', {args = {"^1[Team] ", "Shoma join team shodid jahate didane etelaat az ^2/party ^0estefade konid !"}})
                TriggerServerEvent('TeamSystem:JoinToTeam', InvitedTeamID)
            end
        },
        {
            img = "close.png", text = "Decline", text2 = "From " .. Invitename,
            callBack = function()
                exports.icon_menu:ForceCloseMenu()
            end
        },
    }

    exports.icon_menu:OpenMenu(elements, {
        positionX   = "90%",
        positionY   = "50%",
        size        = "0.9",
        maxHeight   = "80vh",
    })
end)

RegisterCommand('tinvite', function(source, args)
    local InvitedID = tonumber(args[1])
    if not InvitedID then
        TriggerEvent('chat:addMessage', {args = {"^1[Team]", "Estefade: /tinvite [ID]"}})
        return
    end
    TriggerServerEvent('TeamSystem:RequestInvite', InvitedID)
end)
end

do
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
local blipRobbery ={}
local RobsBlip ={}
local ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    for name,things in pairs(Config.Rob.Robs) do
        RobsBlip[name] = AddBlipForCoord(things.position.x, things.position.y, things.position.z)

        SetBlipSprite (RobsBlip[name], Config.Rob.RobTypes[Config.Rob.Robs[name].type].blipsprite)
        SetBlipDisplay(RobsBlip[name], 4)
        SetBlipScale(RobsBlip[name], 0.7)
        SetBlipColour (RobsBlip[name], 2)
        SetBlipAsShortRange(RobsBlip[name], true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Rob.Robs[name].type)
        EndTextCommandSetBlipName(RobsBlip[name])
    end
end)

Citizen.CreateThread(function()
	while true do
        for name,things in pairs(Config.Rob.Robs) do
            if Config.Rob.Robs[name].available then
                SetBlipColour (RobsBlip[name], 2)
            else
                SetBlipColour (RobsBlip[name], 1)
            end
        end
		Citizen.Wait(1000)
	end
end)

RegisterNetEvent('Morphy_RobSystem:SetMarker')
AddEventHandler('Morphy_RobSystem:SetMarker', function (name, state)
    Config.Rob.Robs[name].available = state
end)

RegisterNetEvent('Morphy_RobSystem:killBlip')
AddEventHandler('Morphy_RobSystem:killBlip', function(name)
	RemoveBlip(blipRobbery[name])
    blipRobbery[name] = nil
end)

RegisterNetEvent('Morphy_RobSystem:setBlip')
AddEventHandler('Morphy_RobSystem:setBlip', function(name,position)

    blipRobbery[name] = AddBlipForCoord(position.x, position.y, position.z)
	SetBlipSprite(blipRobbery[name], 161)
	SetBlipScale(blipRobbery[name], 0.7)
	SetBlipColour(blipRobbery[name], 15)

	PulseBlip(blipRobbery[name])
end)

----------------------------------------
------- SHARED POLICE ALERT (export) ----
----------------------------------------
-- Fired by server.lua's AlertPolice() export -- callable from ANY resource, e.g.:
--   exports['Unique_AllRobs']:AlertPolice(coords, 'Yek Nafar Dare Mavad Mifroshe', 4*60*1000)
-- Shows a flashing red blip + a live on-screen countdown to whichever cop-job players receive it.
local sharedAlertBlip, sharedAlertRadiusBlip

RegisterNetEvent('Unique_AllRobs:policeAlert')
AddEventHandler('Unique_AllRobs:policeAlert', function(coords, label, duration, radius)
    coords   = vector3(coords.x, coords.y, coords.z)
    duration = duration or (4 * 60 * 1000)
    label    = label or 'Hoshdare Police'
    radius   = radius or 60.0

    if sharedAlertBlip then RemoveBlip(sharedAlertBlip) end
    if sharedAlertRadiusBlip then RemoveBlip(sharedAlertRadiusBlip) end

    sharedAlertRadiusBlip = AddBlipForRadius(coords, radius)
    SetBlipColour(sharedAlertRadiusBlip, 1)
    SetBlipAlpha(sharedAlertRadiusBlip, 90)
    SetBlipAsShortRange(sharedAlertRadiusBlip, false)

    sharedAlertBlip = AddBlipForCoord(coords)
    SetBlipSprite(sharedAlertBlip, 161)
    SetBlipScale(sharedAlertBlip, 1.2)
    SetBlipColour(sharedAlertBlip, 1)
    SetBlipAsShortRange(sharedAlertBlip, false)
    SetBlipFlashes(sharedAlertBlip, true)
    SetBlipFlashInterval(sharedAlertBlip, 300)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(sharedAlertBlip)

    PlaySoundFrontend(-1, "Text_Arrive_Tone", "Phone_SoundSet_Default", true)

    local myBlip  = sharedAlertBlip
    local endTime = GetGameTimer() + duration

    Citizen.CreateThread(function()
        while GetGameTimer() < endTime and sharedAlertBlip == myBlip do
            Citizen.Wait(0)

            local remaining = math.max(0, endTime - GetGameTimer())
            local minutes   = math.floor(remaining / 60000)
            local seconds   = math.floor((remaining % 60000) / 1000)
            local pulse     = math.abs(math.sin(GetGameTimer() / 200.0))

            DrawRect(0.5, 0.94, 0.17, 0.05, 100, 0, 0, 140 + math.floor(pulse * 80))
            SetTextFont(4)
            SetTextScale(0.5, 0.5)
            SetTextColour(255, 255, 255, 255)
            SetTextCentre(true)
            SetTextOutline()
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringPlayerName(('%s ~r~~h~%02d:%02d~h~~s~'):format(label, minutes, seconds))
            EndTextCommandDisplayText(0.5, 0.915)
        end

        if sharedAlertBlip == myBlip then
            if sharedAlertBlip then RemoveBlip(sharedAlertBlip) end
            if sharedAlertRadiusBlip then RemoveBlip(sharedAlertRadiusBlip) end
            sharedAlertBlip, sharedAlertRadiusBlip = nil, nil
        end
    end)
end)

RegisterNetEvent('Morphy_RobSystem:StartProgressBar')
AddEventHandler('Morphy_RobSystem:StartProgressBar', function(name,RobberyCode)
    local timer = Config.Rob.RobTypes[Config.Rob.Robs[name].type].successtime * 1000
    Citizen.CreateThread(function()
        while timer > 0 do
            Citizen.Wait(1000)
            local playerPos = GetEntityCoords(PlayerPedId(), true)
            local robpos = Config.Rob.Robs[name].position
            local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, robpos.x, robpos.y, robpos.z)
            if distance > Config.Rob.RobTypes[Config.Rob.Robs[name].type].cancelDistance then
                TriggerEvent("mythic_progbar:client:cancel")
                timer = 0
                TriggerServerEvent('Morphy_RobSystem:robberyCancel', name)
            end
            timer = timer - 1000
        end
    end)
	TriggerEvent('mythic_progbar:client:progress', {
        name = 'Robbery',
        duration = Config.Rob.RobTypes[Config.Rob.Robs[name].type].successtime * 1000,
        label = 'Robbery',
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = false,
        }
    }, function(status)
        if not status then
            TriggerServerEvent('Morphy_RobSystem:robberySuccess', name,RobberyCode)
        end
    end)
end)

RegisterNetEvent('Morphy_RobSystem:StartHack')
AddEventHandler('Morphy_RobSystem:StartHack', function(robname,hacktype)
    if hacktype == 1 then
        exports['ps-ui']:VarHack(function(success)
            if success then
                TriggerServerEvent('Morphy_RobSystem:robberyStarted', robname)
            else
                TriggerServerEvent('Morphy_RobSystem:robberyHackFail', robname)
            end
        end, 5, 20)
    elseif hacktype == 2 then
        exports['ps-ui']:Scrambler(function(success)
            if success then
                TriggerServerEvent('Morphy_RobSystem:robberyStarted', robname)
            else
                TriggerServerEvent('Morphy_RobSystem:robberyHackFail', robname)
            end
        end, "alphanumeric", 30, 0)
    else
        TriggerServerEvent('Morphy_RobSystem:robberyStarted', robname)
    end

end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local playerPos = GetEntityCoords(PlayerPedId(), true)

		for k,v in pairs(Config.Rob.Robs) do
			local robpos = v.position
			local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, robpos.x, robpos.y, robpos.z)

			if distance < Config.Rob.Marker.DrawDistance then
                if v.available then
                    DrawMarker(Config.Rob.Marker.Type, robpos.x, robpos.y, robpos.z , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Rob.Marker.x, Config.Rob.Marker.y, Config.Rob.Marker.z, Config.Rob.Marker.r, Config.Rob.Marker.g, Config.Rob.Marker.b, Config.Rob.Marker.a, false, true, 2, false, false, false, false)
                else
                    DrawMarker(Config.Rob.Marker.Type, robpos.x, robpos.y, robpos.z , 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Rob.Marker.x, Config.Rob.Marker.y, Config.Rob.Marker.z, 255, 0, 0, Config.Rob.Marker.a, false, true, 2, false, false, false, false)
                end
                if distance < 0.5 then
                    ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ To ~o~Rob~s~ ~b~'..v.nameofrob..'~s~')

                    if IsControlJustReleased(0, Keys['E']) then
                        if IsPedArmed(PlayerPedId(), 4) then
                            TriggerServerEvent('Morphy_RobSystem:robberyNeeds', k)
                        else
                            ESX.ShowNotification("Shoma Aslahe Dar Dast Nadarid !",'error')
                        end
                    end
                end
			end
		end
	end
end)
end

