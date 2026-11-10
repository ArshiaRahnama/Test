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
ESX = exports['essentialmode']:getObject()
local maxLimit = 260 / 3.6
inVeh = false
local PlayerData = {}
local impound = {busy = false, vehicle = 0}
local DesiredVehicle
local world = 0
local decorlist = {
	"PD",
	"SF",
	"MT",
	"MD",
	"MC",
	"WZ",
	"FBI",
	"TX",
	"JC",
	"DT",
}
local JobAccess = {
    ["police"] = {
        ["PD"] = true,
        ["SF"] = true,
		["MT"] = true,
		["DT"] = true,
        -- ["MD"] = true,
        -- ["TX"] = true,
        -- ["MC"] = true,
        -- ["WZ"] = true,
    },
    ["sheriff"] = {
        ["SF"] = true,
        ["PD"] = true,
		["MT"] = true,
		["DT"] = true,
    },
	["mt"] = {
        ["SF"] = true,
        ["PD"] = true,
		["MT"] = true,
		["DT"] = true,
    },
	["detective"] = {
        ["SF"] = true,
        ["PD"] = true,
		["MT"] = true,
		["DT"] = true,
    },
    ["fbi"] = {
        ["FBI"] = true,
        -- ["PD"] = true,
        -- ["SF"] = true,
        -- ["MD"] = true,
        -- ["TX"] = true,
        -- ["MC"] = true,
        -- ["WZ"] = true,
		-- ["MT"] = true,
    },
	["justice"] = {
        ["JC"] = true,
    },
    ["ambulance"] = {
        ["MD"] = true,
    },
    ["taxi"] = {
        ["TX"] = true,
    },
    ["mechanic"] = {
        ["MC"] = true,
    },
    ["weazel"] = {
        ["WZ"] = true,
    },
}

local worldForCarLock = {
	[0] = true,
	[1] = true,
	[2] = true,
	[3] = true,
	[4] = true,
	[5] = true,
}
for i = 31, 89 do
	worldForCarLock[i] = true
end

local fixLoc = {
	vec(1335.03, -760.97, 67.12, 25),	-- mc 1
	vec(666.35, 648.01, 128.92, 90),	-- mc 2
	vec(1228.93, 2716.59, 38.01, 30),	-- mc sandy
	vec(-1232.54, -2267.62, 13.94, 50), -- air port
	vec(-940.28, -1471.48, -0.47, 25)	-- Ghayegh
}

--  V A R I A B L E S | REGARDING TO ASSETS --
local engineoff = false
local saved = false
-- E N G I N E --
local IsEngineOn = true

local realworld  = true

RegisterNetEvent('esx:changeworld')
AddEventHandler('esx:changeworld',function(_)
	if _ == 0 then
		realworld = true
	else
		realworld = false
	end
	world = _
end)

Citizen.CreateThread(function()
	while ESX == nil do
		Wait(10000)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	if ESX.serverNum == 2 then
        maxLimit = 331 / 3.6
    end
	PlayerData = ESX.GetPlayerData()
	for k , v in pairs(decorlist) do
		DecorRegister(v,2)
	end
	TriggerEvent('chat:addSuggestion', '/engine', 'On / Off Kardan Engine', {})
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local authorizedVehicles = {
    fbi = {
		1949211328,
		-1530607804,
		1127131465,
		-1647941228,
		-1973172295,
		198223837,
		-1953971833,
		1268785103,
		611662121,
		-1693015116,
		1198094127,
	},
	police = {
		1912215274,
		1534316032,
		-725902531,
		1264341792,
		-1627000575,
		2046537925,
		-186537451,
		456714581,
		-34623805,
		-2007026063,
		831758577,
		-1973172295,
		949403409,
		-305727417,
		2071877360,
		1624609239,
		1127131465,
		-1647941228,
		-1917086021,
		-188151185,
		-1693015116,
		-982610657,
		-1083357304,
		-1205689942,
		2100335611,
		353883353,
		-834607087,
		-1661555510,
		-1683328900,
		1922257928,
		1747439474,
		2099668667,
		699188170,
		1002258198,
		-1145771600,
		-1530607804,
		-1965686528,
		244681512,
		-868574549,
		-371055712,
		-635488668,
		-1619710167,
		-1543585645,
		684713414,
		436299151,
		198223837,
		1230579450,
		-1953971833,
		1268785103,
		611662121,
		741586030,
		1198094127
	},

	sheriff = {
		-1683328900,
		353883353,
		1922257928,
		-1647941228,
		1127131465,
		2071877360,
		-1205689942,
		281000465,
		-2111081553,
		-1647941228,
		1002258198,
		-1965686528,
		-1530607804,
		-1771131952,
		-1145771600,
		684713414,
		-1973172295,
		244681512,
		-8688574549,
		-371055712,
		-635488668,
		-1619710167,
		741586030,
		-1543585645,
		436299151,
		198223837,
		1230579450,
		-1953971833,
		1268785103,
		611662121,
		1198094127,
	},

	weazel = {
		1162065741,
		744705981,
		760189077,
		20059254,
		-1124637697,
		-736486717,
		-771538046,
		1268785103,
		611662121,
		1198094127,
	},
	taxi = {
		1158859293,
		902761240,
		1941029835,
		2005502477,
		736902334,
		1123216662,
		-511601230,
		-1008861746,
		-2030171296,
		-956048545,
		-497458178,
		760189077,
		1047274985,
		-736486717,
		-713569950,
		-771538046,
		1268785103,
		611662121,
		1198094127,
	},
	ambulance = {
		831758577,
		1171614426,
		1230579450,
		-2089623200,
		1463616320,
		-113113216,
		353883353,
		-1468262987,
		1002258198,
		-1965686528,
		-821619709,
		684713414,
		-442313018,
		1268785103,
		611662121,
		1198094127,
	},
	mechanic = {
		1353720154,
		-1323100960,
		-1532697517,
		1119641113,
		143643855,
		-1526806709,
		2015368679,
		-1771131952,
		1047274985,
		-736486717,
		-771538046,
		-1045911276,
		1230579450,
		684713414,
		-442313018,
		1268785103,
		611662121,
		1198094127,
	}
}
local cooldown = false

RegisterCommand("gethash", function(source,args)
	if ESX.GetPlayerData().permission_level > 0 then
		local ped = GetPlayerPed(-1)
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)
			local model = GetEntityModel(vehicle)
			print("This is model: " .. tostring(model))
		end
	end
end, false)

RegisterCommand("getmodel", function(source)
        if ESX.GetPlayerData().permission_level > 0 then
			local ped = GetPlayerPed(-1)
			if IsPedInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsIn(ped)
				local model = GetEntityModel(vehicle)
				print("This is spawn name: " .. tostring(GetDisplayNameFromVehicleModel(model)))
			end
        end
end, false)

RegisterCommand("livery", function(source,args)
	if ESX.GetPlayerData().permission_level > 0 or exports['sunset_admin']:world99Check() then
		local ped = GetPlayerPed(-1)
		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)
			SetVehicleLivery(vehicle,tonumber(args[1]))
		end
	end
end, false)

-- Server side sync
RegisterNetEvent("esx_vehiclecontol:ClientSync")
AddEventHandler("esx_vehiclecontol:ClientSync", function(NetId, state)
	local vehicle = NetworkGetEntityFromNetworkId(NetId)
	if DoesEntityExist(vehicle) then
		if state then
			SetVehicleDoorsLocked(vehicle, 2) -- lock the door
		else
			SetVehicleDoorsLocked(vehicle, 1) -- unlcok the door
		end
	end
end)


RegisterNetEvent("esx_vehiclecontol:lockLights")
AddEventHandler("esx_vehiclecontol:lockLights", function(veh)
	local vehicle = NetworkGetEntityFromNetworkId(veh)
	if DoesEntityExist(vehicle) then
		SetVehicleLights(vehicle, 2)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 0)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 2)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 0)
	end

end)

--####################### VEHICLE ASSETS Commands #############################

-- RegisterCommand('hood', function(source)
-- 	TriggerEvent('hood')
-- end, false)

-- RegisterCommand('lfdoor', function(source)
-- 	TriggerEvent('lfdoor')
-- end, false)

-- RegisterCommand('rfdoor', function(source)
-- 	TriggerEvent('rfdoor')
-- end, false)

-- RegisterCommand('lrdoor', function(source)
-- 	TriggerEvent('lrdoor')
-- end, false)

-- RegisterCommand('rrdoor', function(source)
-- 	TriggerEvent('rrdoor')
-- end, false)

-- RegisterCommand('alldoors', function(source)
-- 	TriggerEvent('alldoors')
-- end, false)

-- RegisterCommand('allwindowsdown', function(source)
-- 	TriggerEvent('allwindowsdown')
-- end, false)

-- RegisterCommand('allwindowsup', function(source)
-- 	TriggerEvent('allwindowsup')
-- end, false)

-- Left Front Door --
RegisterNetEvent("lfdoor")
AddEventHandler("lfdoor",function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		local frontLeftDoor = GetEntityBoneIndexByName(vehicle, "door_dside_f")
		if frontLeftDoor ~= -1 then
			if GetVehicleDoorAngleRatio(vehicle, 0) > 0.0 then
				SetVehicleDoorShut(vehicle, 0, false)
			else
				SetVehicleDoorOpen(vehicle, 0, false)
			end
		else
			ESX.ShowNotification("This vehicle does not have a front driver-side door.")
		end
	else
		ESX.ShowNotification("You must be the driver of a vehicle to use this.")
	end
end)

-- Right Front Door --
RegisterNetEvent("rfdoor")
AddEventHandler("rfdoor",function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		local frontRightDoor = GetEntityBoneIndexByName(vehicle, "door_pside_f")
		if frontRightDoor ~= -1 then
			if GetVehicleDoorAngleRatio(vehicle, 1) > 0.0 then
				SetVehicleDoorShut(vehicle, 1, false)
			else
				SetVehicleDoorOpen(vehicle, 1, false)
			end
		else
			ESX.ShowNotification("This vehicle does not have a front passenger-side door.")
		end
	else
		ESX.ShowNotification("You must be the driver of a vehicle to use this.")
	end
end)

-- Left Rear Door --
RegisterNetEvent("lrdoor")
AddEventHandler("lrdoor",function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		local rearLeftDoor = GetEntityBoneIndexByName(vehicle, "door_dside_r")
		if rearLeftDoor ~= -1 then
			if GetVehicleDoorAngleRatio(vehicle, 2) > 0.0 then
				SetVehicleDoorShut(vehicle, 2, false)
			else
				SetVehicleDoorOpen(vehicle, 2, false)
			end
		else
			ESX.ShowNotification("This vehicle does not have a rear driver-side door.")
		end
	else
		ESX.ShowNotification("You must be the driver of a vehicle to use this.")
	end
end)

-- Left Rear Door --
RegisterNetEvent("rrdoor")
AddEventHandler("rrdoor",function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		local rearRightDoor = GetEntityBoneIndexByName(vehicle, "door_pside_r")
		if rearRightDoor ~= -1 then
			if GetVehicleDoorAngleRatio(vehicle, 3) > 0.0 then
				SetVehicleDoorShut(vehicle, 3, false)
			else
				SetVehicleDoorOpen(vehicle, 3, false)
			end
		else
			ESX.ShowNotification("This vehicle does not have a rear passenger-side door.")
		end
	else
		ESX.ShowNotification("You must be the driver of a vehicle to use this.")
	end
end)

-- All Doors --
RegisterNetEvent("alldoors")
AddEventHandler("alldoors",function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		if GetVehicleDoorAngleRatio(vehicle, 0) > 0.0 then
			SetVehicleDoorShut(vehicle, 0, false)
			SetVehicleDoorShut(vehicle, 1, false)
			SetVehicleDoorShut(vehicle, 2, false)
			SetVehicleDoorShut(vehicle, 3, false)
			SetVehicleDoorShut(vehicle, 4, false)
			SetVehicleDoorShut(vehicle, 5, false)
		else
			SetVehicleDoorOpen(vehicle, 0, false)
			SetVehicleDoorOpen(vehicle, 1, false)
			SetVehicleDoorOpen(vehicle, 2, false)
			SetVehicleDoorOpen(vehicle, 3, false)
			SetVehicleDoorOpen(vehicle, 4, false)
			SetVehicleDoorOpen(vehicle, 5, false)
		end
	else
		ESX.ShowNotification("You must be the driver of a vehicle to use this.")
	end
end)

-- all windows down --
RegisterNetEvent("allwindowsdown")
AddEventHandler("allwindowsdown", function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		local frontLeftWindow = GetEntityBoneIndexByName(vehicle, "window_lf")
		local frontRightWindow = GetEntityBoneIndexByName(vehicle, "window_rf")
		local rearLeftWindow = GetEntityBoneIndexByName(vehicle, "window_lr")
		local rearRightWindow = GetEntityBoneIndexByName(vehicle, "window_rr")
		local frontMiddleWindow = GetEntityBoneIndexByName(vehicle, "window_lm")
		local rearMiddleWindow = GetEntityBoneIndexByName(vehicle, "window_rm")
		if
			frontLeftWindow ~= -1 or frontRightWindow ~= -1 or rearLeftWindow ~= -1 or rearRightWindow ~= -1 or
				frontMiddleWindow ~= -1 or
				rearMiddleWindow ~= -1
			then
			RollDownWindow(vehicle, 0)
			RollDownWindow(vehicle, 1)
			RollDownWindow(vehicle, 2)
			RollDownWindow(vehicle, 3)
			RollDownWindow(vehicle, 4)
			RollDownWindow(vehicle, 5)
		else
			ESX.ShowNotification("This vehicle has no windows.")
		end
	else
		ESX.ShowNotification("You must be the driver of a vehicle to use this.")
	end
end)

-- all windows up --
RegisterNetEvent("allwindowsup")
AddEventHandler("allwindowsup", function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	if vehicle ~= nil and vehicle ~= 0 then
		local frontLeftWindow = GetEntityBoneIndexByName(vehicle, "window_lf")
		local frontRightWindow = GetEntityBoneIndexByName(vehicle, "window_rf")
		local rearLeftWindow = GetEntityBoneIndexByName(vehicle, "window_lr")
		local rearRightWindow = GetEntityBoneIndexByName(vehicle, "window_rr")
		local frontMiddleWindow = GetEntityBoneIndexByName(vehicle, "window_lm")
		local rearMiddleWindow = GetEntityBoneIndexByName(vehicle, "window_rm")
		if
			frontLeftWindow ~= -1 or frontRightWindow ~= -1 or rearLeftWindow ~= -1 or rearRightWindow ~= -1 or
				frontMiddleWindow ~= -1 or
				rearMiddleWindow ~= -1
			then
			RollUpWindow(vehicle, 0)
			RollUpWindow(vehicle, 1)
			RollUpWindow(vehicle, 2)
			RollUpWindow(vehicle, 3)
			RollUpWindow(vehicle, 4)
			RollUpWindow(vehicle, 5)
		else
			ESX.ShowNotification("This vehicle has no windows.")
		end
	else
		ESX.ShowNotification("You must be the driver of a vehicle to use this.")
	end
end)

-- H O O D --
RegisterNetEvent("hood")
AddEventHandler("hood", function()
	local player = GetPlayerPed(-1)
	local vehicle = ESX.Game.GetVehicleInDirection(4)
	if vehicle == 0 then
		 vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	end

	local isopen = GetVehicleDoorAngleRatio(vehicle, 4)

		if (isopen == 0) then
			SetVehicleDoorOpen(vehicle, 4, 0, 0)
		else
			SetVehicleDoorShut(vehicle, 4, 0)
		end
end)

RegisterNetEvent("esx_vehiclecontrol:AlarmStete")
AddEventHandler("esx_vehiclecontrol:AlarmStete", function(NetId, state)
	local vehicle = NetworkGetEntityFromNetworkId(NetId)
	if DoesEntityExist(vehicle) then
		if state then
			SetVehicleAlarm(vehicle, true)
			SetVehicleAlarmTimeLeft(vehicle, 30000)
		else
			SetVehicleAlarm(vehicle, false)
			SetVehicleAlarmTimeLeft(vehicle, 0)
		end
	end
end)

RegisterNetEvent("esx_vehiclecontrol:HiJack")
AddEventHandler("esx_vehiclecontrol:HiJack", function()
	local vehicle = ESX.Game.GetVehicleInDirection(4)
      if vehicle == 0 then
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!", 'plarms')
        return
	  end

	HiJackVehicle(vehicle)
end)

--############# END OF VEHICLE ASSETS #################

function DoesHaveAccess(model, table)
	if not table then return false end
	for k,v in pairs(table) do
		if v == model then
			return true
		end
	end
	return false
end
function IsGOV(vehicle)
	local job = PlayerData.job.name
	local vehiclejob = nil
	local kJob = Entity(vehicle).state.kJob
	for k , v in pairs(decorlist) do
		if kJob == v then
			vehiclejob = v
			break
		end
	end
	if vehiclejob then
		return true
	else
		return false
	end
end
function GetVehicles(department)
	return authorizedVehicles[department]
end

function IsAnyPedInVehicle(veh)
	return (GetVehicleNumberOfPassengers(veh)+(IsVehicleSeatFree(veh,-1) and 0 or 1))>0
end

function Repair(vehicle)
	ESX.TriggerServerEvent('esx_vehiclecontol:fixcar', VehToNet(vehicle),GetVehicleEngineHealth(vehicle)<=400,ESX.Game.GetPlayersToSend(400))
end
exports('repair', Repair)
RegisterNetEvent('esx_vehiclecontol:fixcarcl')
AddEventHandler('esx_vehiclecontol:fixcarcl', function(net)
	local vehicle = NetToVeh(net)
	if vehicle ~= 0 then
		ESX.SetVehicleFixed(vehicle)
		SetVehicleDeformationFixed(vehicle)
		SetVehicleUndriveable(vehicle, false)
		SetVehicleEngineOn(vehicle, true, true)
	end
end)


function Clean(vehicle)
	NetworkRequestControlOfEntity(vehicle)

	local timeout = 2000
	while timeout > 0 and not NetworkHasControlOfEntity(vehicle) do
		Wait(100)
		timeout = timeout - 100
	end

	SetVehicleDirtLevel(vehicle, 0)
end

function HiJack(vehicle)
	SetVehicleDoorsLocked(vehicle, 1)
	local NetId = NetworkGetNetworkIdFromEntity(vehicle)
	TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false,players)
end

function ImpoundPolice(vehicle,timee)
	if not impound.busy then

		local plate = GetVehicleNumberPlateText(vehicle)
		impound.busy = true
		impoundBusyThread()
		impound.vehicle = vehicle
		TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
		if ESX.progressCircle(15000, true, true) then
			ClearPedTasksImmediately(GetPlayerPed(-1))
			TriggerServerEvent('garage:setpdimpound', plate,timee)
			local model, coords, heading, gov, level, plate, ownerHex = GetEntityModel(vehicle), GetEntityCoords(vehicle), GetEntityHeading(vehicle),  exports["esx_vehiclecontrol"]:IsGOV(vehicle), Entity(vehicle).state.ownerLevel, ESX.GetPlate(vehicle), Entity(vehicle).state.ownerHex
			-- ESX.Game.DeleteVehicle(vehicle)
			impound.busy = false
			impound.vehicle = 0
			if not gov then
				ESX.TriggerServerEvent('mechanic:impound:startImpoundSession', NetworkGetNetworkIdFromEntity(vehicle), exports['esx_vehiclecontrol']:IsGOV(vehicle))
				ESX.removeCarKey(vehicle)
			else
				ESX.Game.DeleteVehicle(vehicle)
			end
		else
			ClearPedTasksImmediately(GetPlayerPed(-1))
			impound.busy = false
			impound.vehicle = 0
		end
	end
end


function DeleteVehicle(vehicle)
	if not impound.busy then

		impound.busy = true
		impoundBusyThread()
		impound.vehicle = vehicle
		TaskStartScenarioInPlace(GetPlayerPed(-1), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
		if ESX.progressCircle(15000, true, true) then
			ClearPedTasksImmediately(GetPlayerPed(-1))
			ESX.Game.DeleteVehicle(vehicle)

			impound.busy = false
			impound.vehicle = 0
		else
			ClearPedTasksImmediately(GetPlayerPed(-1))
			impound.busy = false
			impound.vehicle = 0
		end
	end
end

function RepairVehicle(vehicle,_, useInsurance)
	if not impound.busy then
		local p = promise.new()
		impound.busy = true
		impoundBusyThread()
		impound.vehicle = vehicle
		exports['sun-animmenu']:PlayEmote("mechanic1")
		if ESX.progressCircle(10000, true, true) then
			ClearPedTasksImmediately(GetPlayerPed(-1))
			if _ then
				if not ESX.DoesHaveItem('kit100',1,nil,nil,false) then
					return
				else
					TriggerServerEvent('items:remove','kit100',1)
				end
			end
			if useInsurance and GetVehicleEngineHealth(vehicle) <= 600 then
				ESX.TriggerServerCallback('vehicle-insurance:useInsurance', function(bimeUsed)
					p:resolve(bimeUsed)
				end, ESX.GetPlate(vehicle), vehicle)
			else
				p:resolve(false)
			end
			Repair(vehicle)

			impound.busy = false
			impound.vehicle = 0
		else
			ClearPedTasksImmediately(GetPlayerPed(-1))
			impound.busy = false
			impound.vehicle = 0
		end
		return Citizen.Await(p)
	end
end

function RepairVehicle2(vehicle)
	local can = false
	for k , v in pairs(fixLoc) do
		if ESX.GetDistance(GetEntityCoords(PlayerPedId()),v.xyz) <= v.w then
			can = true
		end
	end
	if can then
		if not impound.busy then
			ESX.UI.Menu.CloseAll()
			ESX.TriggerServerCallback('chopshop:server:getEngineLevel',function(engine)
				if engine == 0 then
					--[[impound.busy = true
					impound.vehicle = vehicle
					exports['sun-animmenu']:PlayEmote("mechanic1")
					TriggerEvent("mythic_progbar:client:progress", {
						name = "mechanic_repair",
						duration = 30000,
						label = "Dar hale tamir kardan engine mashin",
						useWhileDead = false,
						canCancel = true,
						controlDisables = {
							disableMovement = true,
							disableCarMovement = true,
							disableMouse = false,
							disableCombat = true,
						}
					}, function(status)

						if not status then
							ClearPedTasksImmediately(GetPlayerPed(-1))
							TriggerServerEvent('chopshop:server:fixVehicle',GetVehicleNumberPlateText(vehicle),VehToNet(vehicle),GetEntityModel(vehicle))
							Repair(vehicle)

							impound.busy = false
							impound.vehicle = 0

						elseif status then
							ClearPedTasksImmediately(GetPlayerPed(-1))
							impound.busy = false
							impound.vehicle = 0
						end
					end)]]
					ESX.ShowNotification('In mashin niaz be engine nadare')
				else
					ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'ask',
					{
					title 	 = 'Ta\'mir engine',
					align    = 'center',
					question = 'Aya mikhahid engine in mashin ra ta\'amir konid?(Engine X'.. engine ..')',
					elements = {
						{label = 'Bale', value = 'yes'},
						{label = 'Kheir', value = 'no'},
					}
					}, function(data, menu)
						ESX.UI.Menu.CloseAll()
						if data.current.value == 'yes' then
							local item = 'engine'..engine
							local enginecount = 0
							local PlayerData = ESX.GetPlayerData()
							for i=1, #PlayerData.inventory do
								if PlayerData.inventory[i].name == item then
									enginecount = PlayerData.inventory[i].count
								end
							end
							if enginecount < 1 then
								ESX.ShowNotification('Shoma niaz be yek Engine X'.. engine ..' darid')
							else
								local time = 30000
								time = time + engine * 5000
								impound.busy = true
								impoundBusyThread()
								impound.vehicle = vehicle
								exports['sun-animmenu']:PlayEmote("mechanic1")
								if ESX.progressCircle(time, true, true) then
									ClearPedTasksImmediately(GetPlayerPed(-1))
									TriggerServerEvent('chopshop:server:fixVehicle',GetVehicleNumberPlateText(vehicle),VehToNet(vehicle),GetEntityModel(vehicle))
									Repair(vehicle)

									impound.busy = false
									impound.vehicle = 0
								else
									ClearPedTasksImmediately(GetPlayerPed(-1))
									impound.busy = false
									impound.vehicle = 0
								end
							end
						elseif data.current.value == 'no' then
							menu.close()
							ESX.UI.Menu.CloseAll()
						end
					end)
				end
			end,GetEntityModel(vehicle))
		end
	else
		ESX.Alert('','Baraye estefade az engine bayad dar nazdiki mechanici bashid!',5000,'error')
	end
end

function CleanVehicle(vehicle)
	if not impound.busy then

		impound.busy = true
		impoundBusyThread()
		impound.vehicle = vehicle
		TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_MAID_CLEAN", 0, true)
		if ESX.progressCircle(5000, true, true) then
			ClearPedTasksImmediately(GetPlayerPed(-1))
			Clean(vehicle)

			impound.busy = false
			impound.vehicle = 0
		else
			ClearPedTasksImmediately(GetPlayerPed(-1))
			impound.busy = false
			impound.vehicle = 0
		end
	end
end

function HiJackVehicle(vehicle)
	if not impound.busy then

		if GetVehicleDoorLockStatus(vehicle) == 2 then

			TriggerServerEvent('esx_customItems:remove', 'picklock')
			impound.busy = true
			impoundBusyThread()
			impound.vehicle = vehicle
			local plate = GetVehicleNumberPlateText(vehicle)
			local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
			local NetId = NetworkGetNetworkIdFromEntity(vehicle)
			TriggerServerEvent('esx_vehiclecontrol:syncAlarm', NetId, true)
			if ESX.progressCircle(30000, true, true) then
				impound.busy = false
				impound.vehicle = 0

				local number = math.random(1, 3)

				if number % 2 == 0 then
					HiJack(vehicle)
					TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Mashin ba movafaghiat ^1picklock ^0shod!", 'plarms')
					TriggerServerEvent('esx_vehiclecontrol:syncAlarm', NetId, false)
				else
					TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0PickLock shoma ^1shekast!", 'plarms')
					TriggerServerEvent('esx_vehiclecontrol:NotifyOwner', plate, model)
					Citizen.CreateThread(function()
						Citizen.Wait(5000)
						TriggerServerEvent('esx_vehiclecontrol:syncAlarm', NetId, false)
					end)
				end
			else
				impound.busy = false
				impound.vehicle = 0
				TriggerServerEvent('esx_vehiclecontrol:NotifyOwner', plate, model)
				Citizen.CreateThread(function()
					Citizen.Wait(5000)
					TriggerServerEvent('esx_vehiclecontrol:syncAlarm', NetId, false)
				end)
			end
		else
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Dare mashin mored nazar ghofl nist!", 'plarms')
		end

	end
end

function impoundBusyThread()
	Citizen.CreateThread(function()
		while impound.busy do
		  Citizen.Wait(10)

		  if impound.busy and impound.vehicle ~= 0 then

			local coords = GetEntityCoords(GetPlayerPed(-1))

			if not DoesEntityExist(impound.vehicle) then
				lib.cancelProgress()
				impound.busy = false
				impound.vehicle = 0
			end

			local vcoords = GetEntityCoords(impound.vehicle)
			local distance = GetDistanceBetweenCoords(coords, vcoords, false)

			if IsAnyPedInVehicle(impound.vehicle) then
				ESX.ShowNotification("~h~Mashin ranande darad!")
				Wait(1000)
				lib.cancelProgress()
				impound.busy = false
				impound.vehicle = 0
			end

			if distance > 4 then
				ESX.ShowNotification("Mashin mored nazar az shoma ~r~door ~s~shod!")
				lib.cancelProgress()
				impound.busy = false
				impound.vehicle = 0
			end

		  end

		end
	end)
end

AddEventHandler('KeyDown:delete',function()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	if (vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0)) then
		toggleEngine()
	end
end)

function toggleEngine()
	local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
	if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
		if exports['sunset_utils']:canAccessToVehicle(vehicle) or HaveAccess(vehicle) then
			SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
		end
	end
end
RegisterNetEvent('toggleengine',toggleEngine)

local lastveh = 0
local limit = {
	[1] = 16.88,
	[2] = 8.46,
	[3] = 3.05,
	[4] = 1.52,
}
local threadoff = false
local drawThread = false
local hotwire = {}
local alarmSend = false

local accessChecked = false
RegisterNetEvent('esx:updateInventory', function ()
	accessChecked = false
end)

local freeLockWorld = {
	[90] = true,
	[97] = true,
}

local currentVehicleMaxSpeed
local currentVehicleTempMaxSpeed = {}
exports('setVehicleTempSpeed', function(k, v)
	currentVehicleTempMaxSpeed[k] = v
end)

local offLoop = true
local currentVehicle = 0
function inVehThread(vehicle)
	offLoop = true
	SetVehicleEngineOn(vehicle, false, true, true)
	CreateThread(function()
		while offLoop and currentVehicle == vehicle do
			Wait(0)
			-- DisableControlAction(2, 71, true)
			if GetIsVehicleEngineRunning(vehicle) then
                SetVehicleEngineOn(vehicle, false, false, true)
            end
		end
		Wait(100)
		if inVeh then
			SetVehicleEngineOn(vehicle, true, false, false)
		end
	end)
	Wait(100)
	accessChecked = false
	CreateThread(function()
		local model = GetEntityModel(vehicle)
		local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
		local class = GetVehicleClass(vehicle)
		currentVehicleMaxSpeed = (customSpeedLimitLevelBased[model] and customSpeedLimitLevelBased[model][playerLevel] and customSpeedLimitLevelBased[model][playerLevel] / 3.6) or GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
		local lastSpeed
		local haveAccess = false
		local thread2 = false
		while inVeh do
			Wait(500)
			if not accessChecked and not haveAccess then
				accessChecked = true
				if exports['sunset_utils']:canAccessToVehicle(vehicle) or HaveAccess(vehicle) or hotwire[vehicle] or freeLockWorld[world] or GetVehicleClass(vehicle) == 13 then
					haveAccess = true
				end
			end
			if haveAccess then
				drawThread = false
				offLoop = false
				local placedEntity = Entity(vehicle).state.placedEntity
				local yaghi = placedEntity and placedEntity > 0
				lastveh = vehicle
				local maxoffSpeed = exports['sunset_utils']:getMaxSpeedInOffroad(model)
				SetEntityMaxSpeed(vehicle, currentVehicleMaxSpeed)
				if not thread2 then
					thread2 = true
					CreateThread(function()
						while inVeh and thread2 do
							Wait(500)
							local count = 0
							if IsVehicleTyreBurst(vehicle, 0, false) then
								count = count + 1
							end
							--Right Front
							if IsVehicleTyreBurst(vehicle, 1, false)  then
								count = count + 1
							end
							--Left Rear
							if IsVehicleTyreBurst(vehicle, 4, false) then
								count = count + 1
							end
							--Right Rear
							if IsVehicleTyreBurst(vehicle, 5, false) then
								count = count + 1
							end
							local choped = Entity(vehicle).state.choped
							local InStreet = exports['sunset_utils']:getVar('InStreet')
							if choped and count < 2 then
								currentVehicleTempMaxSpeed['chop'] = 12.26
							else
								currentVehicleTempMaxSpeed['chop'] = nil
							end
							if limit[count] then
								if (not choped or count >= 2) then
									if limit[count] * 3.6 < maxoffSpeed or InStreet then
										currentVehicleTempMaxSpeed['tire'] = limit[count]
									end
								end
							else
								currentVehicleTempMaxSpeed['tire'] = nil
							end
							if yaghi then
								currentVehicleTempMaxSpeed['yaghi'] = 55.35
							else
								currentVehicleTempMaxSpeed['yaghi'] = nil
							end
							if class ~= 16 and class ~= 15 then
								if GetEntitySpeed(vehicle) > maxLimit then
									currentVehicleTempMaxSpeed['maxLimit'] = maxLimit
								end
							end
							local speed = currentVehicleMaxSpeed
							for k, v in pairs(currentVehicleTempMaxSpeed) do
								if not speed or v < speed then
									speed = v
								end
							end
							-- if speed ~= lastSpeed then
								SetVehicleMaxSpeed(vehicle, speed or currentVehicleMaxSpeed)
								lastSpeed = speed
							-- end
							if GetEntitySpeed(vehicle) > 5 then
								local isOpen = GetVehicleDoorAngleRatio(vehicle, 4) > 0.0
								if isOpen then
									SetVehicleDoorShut(vehicle, 4, false)
								end
							end
						end
					end)
				end
			else
				if not drawThread then
					drawThread = true
					CreateThread(function()
						while drawThread do
							Wait(0)
							local vehpos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 2.0, 1.0)
							ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z),"[H] Hotwire",2)
							if (GetEntitySpeed(vehicle) * 3.6) > 15 and not alarmSend then
								Wait(7000)
								if (GetEntitySpeed(vehicle) * 3.6) > 15 then
									if not alarmSend then
										alarmSend = true
										SetTimeout(30000, function()
											alarmSend = false
										end)
										ESX.alarm('Force engine')
									end
								end
							end
							if IsControlJustPressed(0, Keys["H"]) and not IsGOV(vehicle) then
								local can = false
								if ESX.serverNum == 2 then
									local isTaxiOnline = false
									local p = promise.new()
									ESX.TriggerServerCallback('scoreboard:getInfo', function(cb)
										p:resolve(cb.taxi >= 1)
									end)
									isTaxiOnline = Citizen.Await(p)
									can = GetEntityPopulationType(vehicle) == 7 or not isTaxiOnline
								else
									can = true
								end
								if can then
									if exports['sunset_utils']:isInGangBase() then
										return
									end
									ESX.TriggerServerCallback('chopshop:server:usePich',function(cb)
										local data = exports['sunset_utils']:checkncz()
										if data and cb then
											if data.punish == 1 then
												--TriggerServerEvent("sc:adminalarm",'Man darhale '..data.reason .. ' hastam lotfan be dadam beresin')
											end
										elseif data then
											if data.punish == 1 then
												ESX.ShowNotification('Shoma nemitavanid dar in makan dozdi konid')
											end
										else
											if cb then
												if Hotwire() then
													accessChecked = false
													drawThread = false
													offLoop = false
												end
											end
										end
									end)
								else
									ESX.Alert('', 'Be dalile online budan taxi emkan serghat in mashin vojud nadarad', 10000, 'warning')
								end
							end
						end
					end)
				end
			end
		end
		offLoop = false
		drawThread = false
	end)
end

function inVehThreadMini(vehicle)
	CreateThread(function()
		local model = GetEntityModel(vehicle)
		local plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
		local class = GetVehicleClass(vehicle)
		currentVehicleMaxSpeed = (customSpeedLimitLevelBased[model] and customSpeedLimitLevelBased[model][playerLevel] and customSpeedLimitLevelBased[model][playerLevel] / 3.6) or GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
		local lastSpeed
		local haveAccess = false
		local thread2 = false
		while inVeh do
			Wait(500)
			local placedEntity = Entity(vehicle).state.placedEntity
			local yaghi = placedEntity and placedEntity > 0
			lastveh = vehicle
			local maxoffSpeed = exports['sunset_utils']:getMaxSpeedInOffroad(model)
			SetEntityMaxSpeed(vehicle, currentVehicleMaxSpeed)
			if not thread2 then
				thread2 = true
				CreateThread(function()
					while inVeh and thread2 do
						Wait(500)
						local count = 0
						local choped = Entity(vehicle).state.choped
						local InStreet = exports['sunset_utils']:getVar('InStreet')
						if choped and count < 2 then
							currentVehicleTempMaxSpeed['chop'] = 12.26
						else
							currentVehicleTempMaxSpeed['chop'] = nil
						end
						if limit[count] then
							if (not choped or count >= 2) then
								if limit[count] * 3.6 < maxoffSpeed or InStreet then
									currentVehicleTempMaxSpeed['tire'] = limit[count]
								end
							end
						else
							currentVehicleTempMaxSpeed['tire'] = nil
						end
						if yaghi then
							currentVehicleTempMaxSpeed['yaghi'] = 55.35
						else
							currentVehicleTempMaxSpeed['yaghi'] = nil
						end
						if class ~= 16 and class ~= 15 then
							if GetEntitySpeed(vehicle) > maxLimit then
								currentVehicleTempMaxSpeed['maxLimit'] = maxLimit
							end
						end
						local speed = currentVehicleMaxSpeed
						for k, v in pairs(currentVehicleTempMaxSpeed) do
							if not speed or v < speed then
								speed = v
							end
						end
						-- if speed ~= lastSpeed then
							SetVehicleMaxSpeed(vehicle, speed or currentVehicleMaxSpeed)
							lastSpeed = speed
						-- end
					end
				end)
			end
		end
	end)
end


AddEventHandler('enterVehicle',function(vehicle,isDriver)
	if isDriver and not inVeh then
		inVeh = true
		currentVehicle = vehicle
		if worldForCarLock[world] then
			inVehThread(vehicle)
		else
			inVehThreadMini(vehicle)
		end
	end
end)

AddEventHandler('exitVehicle',function(vehicle, isDriver)
	lastveh = 0
	currentVehicle = 0
	inVeh = false
	offLoop = false
	currentVehicleTempMaxSpeed = {}
end)

AddEventHandler('hotwire:add', function(vehicle)
	hotwire[vehicle] = true
end)

function Hotwire()
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), true)
	local hotwireShod = false
	if vehicle ~= nil and vehicle ~= 0 then
		if GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1) then
			IsHotwiring = true

			local dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
			local anim = "machinic_loop_mechandplayer"
			TaskPlayAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer' ,1.0, 4.0, -1, 49, 0, false, false, false)

			RequestAnimDict(dict)
			while not HasAnimDictLoaded(dict) do
				RequestAnimDict(dict)
				Citizen.Wait(100)
			end

			if taskBar(3000 - (exports['sun-jobs']:getVehicleInsuranceData(vehicle) and 1000 or 0),math.random(10,20)) ~= 100 then
				StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
				ESX.ShowNotification('Pich goushti shekast!')
				hotwireShod = false
				IsHotwiring = false
				return
			end

			if taskBar(2500 - (exports['sun-jobs']:getVehicleInsuranceData(vehicle) and 1000 or 0),math.random(10,20)) ~= 100 then
				StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
				ESX.ShowNotification('Pich goushti shekast!')
				hotwireShod = false
				IsHotwiring = false
				return
			end

			if taskBar(2000 - (exports['sun-jobs']:getVehicleInsuranceData(vehicle) and 1000 or 0),math.random(5,15)) ~= 100 then
				StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
				HasKey = false
				ESX.ShowNotification('Pich goushti shekast!')
				hotwireShod = false
				return
			end
			StopAnimTask(GetPlayerPed(-1), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0)
			IsHotwiring = false
			threadoff = false
			ESX.ShowNotification('Baraye Roshan Shodan W ra bezanid!')
			hotwire[vehicle] = true
			Wait(2000)
			hotwireShod = true
			SetVehicleEngineOn(vehicle,true,false,true)
			Wait(1000)
			ESX.TriggerServerCallback('chopshop:server:isChopped',function(choped)
				if choped then
					currentVehicleTempMaxSpeed['chop'] = 12.26
					ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(vehicle), 'choped', true)
					TriggerEvent('exitVehicle')
					Wait(500)
					TriggerEvent('enterVehicle', vehicle, true)
				end
			end, ESX.GetPlate(vehicle))
			return hotwireShod
		end
	end
end


exports("GetVehicles", GetVehicles)
exports("ImpoundPolice", ImpoundPolice)
exports("DeleteVehicle", DeleteVehicle)
exports("RepairVehicle", RepairVehicle)
exports("RepairVehicle2", RepairVehicle2)
exports("CleanVehicle", CleanVehicle)
exports("IsGOV", IsGOV)

local speakerjobaccess = {
	['police'] = true,
	['sheriff'] = true,
	['fbi'] = true,
	['mt'] = true,
	['justice'] = true,
	['detective'] = true,
}

local speaker_active = false
local cooldown = false
AddEventHandler('KeyDown:lcontrol',function()
	if cooldown then return end
	cooldown = true
	SetTimeout(5000,function()
		cooldown = false
	end)
	local veh = GetVehiclePedIsIn(PlayerPedId())
	if veh ~= 0 and IsGOV(veh) then
		if speakerjobaccess[ESX.GetPlayerData().job.name] then
			if not speaker_active then
				TriggerServerEvent('JobSpeaker',true, ESX.GetPlayersToSend(150))
				ESX.Alert('Speaker','Speaker active shod',5000,'success')
				speaker_active = true
				Citizen.CreateThread(function()
					while speaker_active do
						Wait(100)
						local veh = GetVehiclePedIsIn(PlayerPedId())
						if veh == 0 then
							speaker_active = false
							TriggerServerEvent('JobSpeaker',false)
							--TriggerServerEvent('JobSpeaker',false)
							ESX.Alert('Speaker','Speaker disable shod',5000,'error')
						end
					end
				end)
			end
		end
	end
end)

AddEventHandler('KeyUP:lcontrol',function()
	if speakerjobaccess[ESX.GetPlayerData().job.name] then
		if speaker_active then
			speaker_active = false
			ESX.Alert('Speaker','Speaker disable shod',5000,'error')
			Wait(2000)
			TriggerServerEvent('JobSpeaker',false)
			--TriggerServerEvent('JobSpeaker',false)
		end
	end
end)

function SetDecor(vehicle, key)
	if DoesEntityExist(vehicle) then
		ESX.TriggerServerEvent('setEntityState', NetworkGetNetworkIdFromEntity(vehicle), 'kJob', key)
	end
end

exports("SetDecor", SetDecor)

function HaveAccess(vehicle)
	local job = PlayerData.job.name:gsub('off','')
	local vehiclejob = nil
	local kJob = Entity(vehicle).state.kJob
	for k , v in pairs(decorlist) do
		if kJob == v then
			vehiclejob = v
			break
		end
	end
	if vehiclejob then
		if JobAccess[job] and JobAccess[job][vehiclejob] then
			return true
		else
			return false
		end
	else
		return false
	end
end
exports("HaveAccess", HaveAccess)

function getVehicleJob(vehicle)
	local vehiclejob = nil
	local kJob = Entity(vehicle).state.kJob
	for k , v in pairs(decorlist) do
		if kJob == v then
			vehiclejob = v
			break
		end
	end
	return vehiclejob
end
exports("getVehicleJob", getVehicleJob)

function flip(vehicle)
	local try = 0
	CreateThread(function()
		while try < 5 do
			try = try + 1
			local roll = GetEntityRoll(vehicle)
			if (roll > 75.0 or roll < -75.0) then
				NetworkRequestControlOfEntity(vehicle)
				SetVehicleOnGroundProperly(vehicle)
				local roatation = GetEntityRotation(vehicle)
				ESX.TriggerServerEvent('core:setEntityRotation', NetworkGetNetworkIdFromEntity(vehicle), 0.0, 0.0, roatation.z)
			else
				break
			end
			Wait(1000)
		end
	end)
end
exports('flip', flip)

function unflip(vehicle)
	NetworkRequestControlOfEntity(vehicle)
	local rotation = GetEntityRotation(vehicle)
	SetEntityRotation(vehicle, rotation.x, rotation.y + 180.0, rotation.z, 2, true)
end

exports('unflip', unflip)


exports('isNearGarage', function()
	local can = false
	for k , v in pairs(fixLoc) do
		if ESX.GetDistance(GetEntityCoords(PlayerPedId()),v.xyz) <= v.w then
			can = true
		end
	end
	return can
end)