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
local pointed = nil
local impound = {busy = false, vehicle = 0}
local time = 0
local DesiredVehicle

local engineoff = false
local IsEngineOn = true
local saved = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local authorizedVehicles = {
	police = {
		1912215274,
		335384930,
		-1046437422,
		1561926939,
		-1574893700,
		-283186696,
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
		1915122717,
		2071877360,
		1811562607,
		-1083357304,
		-1760183916,
		-1145771600
	},

	sheriff = {
		1912215274,
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
		1915122717,
		2071877360,
		1811562607,
		-1083357304,
		-1760183916,
		-1145771600
	},

	ambulance = {
		-574837267,
		-1860923259,
		-1800062819,
		-963528616,
		353883353,
		-1661555510,
		281000465,
		-2111081553,
		-1647941228,
		-974922913,
		1500677296
	},

	mechanic = {
		1353720154,
		-1323100960,
		-442313018
	},

	taxi = {
		156252959,
		1123216662,
		-1008861746,
		-511601230,
		-956048545,
		-2030171296
	},

	government = {
		-532475078,
		104532066,
		-834607087,
		83136452,
		-1004039245,
		-1760183916,
		-888242983,
		1811562607,
		353883353,
		610904671
	},

	doc = {
		65352125,
		-2007026063,
		-189953307,
		1100039869,
		-1382290102,
		-920994759,
		1802309334
	},

	weazel = {
		1162065741
	},

	food = {
		1663218586,
		1951180813,
		-1289178744
	},

	nightclub = {
		86520421,
		-1908948564
	},

	coffee = {
		1951180813
	}
}

RegisterCommand("gethash", function(source)
	ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)
        if isAdmin then
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsIn(ped)
				local model = GetEntityModel(vehicle)
				print("This is model: " .. tostring(model))
				TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Vehicle Hash :" ..tostring(model))
			end
        end
    end)
end, false)

RegisterCommand("getmodel", function(source)
	ESX.TriggerServerCallback('esx_aduty:checkAdmin', function(isAdmin)
        if isAdmin then
			local ped = PlayerPedId()
			if IsPedInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsIn(ped)
				local model = GetEntityModel(vehicle)
				print("This is spawn name: " .. tostring(GetDisplayNameFromVehicleModel(model)))
				TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Vehicle Hash :" ..tostring(GetDisplayNameFromVehicleModel(model)))
			end
        end
    end)
end, false)

RegisterNetEvent("esx_vehiclecontol:toggleLock")
AddEventHandler("esx_vehiclecontol:toggleLock",function(vehicle)
	if authorizedVehicles[PlayerData.job.name] then
		local vehicle = vehicle
		local islocked = GetVehicleDoorLockStatus(vehicle)
		local NetId = NetworkGetNetworkIdFromEntity(vehicle)

		if (islocked == 1 or islocked == 0) then
			TriggerServerEvent("esx_vehiclecontrol:sync", NetId, true)
			TriggerServerEvent("esx_vehiclecontrol:lights", NetId)
			ESX.ShowNotification("Shoma ~y~" .. GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) .. "~w~ ra ~r~ghofl ~w~kardid.")
			local dict = "anim@mp_player_intmenu@key_fob@"
			RequestAnimDict(dict)
			while not HasAnimDictLoaded(dict) do
				Citizen.Wait(1)
			end
			if not IsPedInAnyVehicle(PlayerPedId(), true) then
				TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
			end
			SetVehicleDoorShut(vehicle, 0, false)
			SetVehicleDoorShut(vehicle, 1, false)
			SetVehicleDoorShut(vehicle, 2, false)
			SetVehicleDoorShut(vehicle, 3, false)
			SetVehicleDoorShut(vehicle, 4, false)
			SetVehicleDoorShut(vehicle, 5, false)
			PlayVehicleDoorCloseSound(vehicle, 1)
			TriggerServerEvent("InteractSirrpound_SV:PlayWitirrphinDistance", 10, "lock", 0.5)

		elseif islocked == 2 then
			TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false)
			TriggerServerEvent("esx_vehiclecontrol:lights", NetId)
			ESX.ShowNotification("Shoma ~y~" .. GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) .. "~w~ ra ~g~baaz ~w~kardid.")
			local dict = "anim@mp_player_intmenu@key_fob@"
			RequestAnimDict(dict)
			while not HasAnimDictLoaded(dict) do
				Citizen.Wait(1)
			end
			if not IsPedInAnyVehicle(PlayerPedId(), true) then
				TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
			end
			PlayVehicleDoorCloseSound(vehicle, 1)
			TriggerServerEvent("InteractSirrpound_SV:PlayWitirrphinDistance", 10, "unlock", 0.5)
		end

	end
end)

RegisterNetEvent("esx_vehiclecontol:lockLights")
AddEventHandler("esx_vehiclecontol:lockLights", function(veh)
	if not NetworkDoesNetworkIdExist(veh) then
		return
	end

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

RegisterNetEvent("esx_vehiclecontrol:AlarmStete")
AddEventHandler("esx_vehiclecontrol:AlarmStete", function(NetId, state)
	if not NetworkDoesNetworkIdExist(NetId) then
		return
	end

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
        TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Hich mashini nazdik shoma nist!")
        return
	  end

	HiJackVehicle(vehicle)
end)

function DoesHaveAccess(model, table)
	for k,v in pairs(table) do
		if v == model then
			return true
		end
	end

	return false
end

function GetVehicles(department)
	return authorizedVehicles[department]
end

function IsAnyPedInVehicle(veh)
	return (GetVehicleNumberOfPassengers(veh)+(IsVehicleSeatFree(veh,-1) and 0 or 1))>0
end

function Repair(vehicle)
	NetworkRequestControlOfEntity(vehicle)

	local timeout = 2000
	while timeout > 0 and not NetworkHasControlOfEntity(vehicle) do
		Wait(100)
		timeout = timeout - 100
	end

	SetVehicleFixed(vehicle)
	exports.LegacyFuel:fixVehicle(vehicle)
end

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
	TriggerServerEvent("esx_vehiclecontrol:sync", NetId, false)
end

function ImpoundPolice(vehicle)
	if not impound.busy then

		local plate = GetVehicleNumberPlateText(vehicle)
		impound.busy = true
		impound.vehicle = vehicle
		TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
		TriggerEvent("mythic_progbar:client:progress", {
			name = "police_impound",
			duration = 15000,
			label = "Dar hale impound kardan mashin",
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

				ClearPedTasksImmediately(PlayerPedId())
				TriggerServerEvent('esx_advancedgarage:policeImpound', plate)
				TriggerServerEvent('esx_policejob:DeleteEntity', NetworkGetNetworkIdFromEntity(vehicle))

				impound.busy = false
				impound.vehicle = 0

			elseif status then
				ClearPedTasksImmediately(PlayerPedId())
				impound.busy = false
				impound.vehicle = 0
			end

		end)

	end
end

function Impoundsheriff(vehicle)
	if not impound.busy then

		local plate = GetVehicleNumberPlateText(vehicle)
		impound.busy = true
		impound.vehicle = vehicle
		TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
		TriggerEvent("mythic_progbar:client:progress", {
			name = "police_impound",
			duration = 15000,
			label = "Dar hale impound kardan mashin",
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

				ClearPedTasksImmediately(PlayerPedId())
				TriggerServerEvent('esx_advancedgarage:policeImpound', plate)
				TriggerServerEvent('esx_sheriffjob:DeleteEntity', NetworkGetNetworkIdFromEntity(vehicle))

				impound.busy = false
				impound.vehicle = 0

			elseif status then
				ClearPedTasksImmediately(PlayerPedId())
				impound.busy = false
				impound.vehicle = 0
			end

		end)

	end
end

function DeleteVehicles(vehicle)
	if not impound.busy then

		impound.busy = true
		impound.vehicle = vehicle
		TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
		TriggerEvent("mythic_progbar:client:progress", {
			name = "mechanic_impound",
			duration = 15000,
			label = "Dar hale impound kardan mashin",
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
				ESX.Game.DeleteVehicle(vehicle)
				ClearPedTasksImmediately(PlayerPedId())
				TriggerServerEvent('esx_policejob:DeleteEntity', NetworkGetNetworkIdFromEntity(vehicle))

				impound.busy = false
				impound.vehicle = 0

			elseif status then
				ClearPedTasksImmediately(PlayerPedId())
				impound.busy = false
				impound.vehicle = 0
			end

		end)

	end
end

function RepairVehicle(vehicle)
	if not impound.busy then

		impound.busy = true
		impound.vehicle = vehicle
		exports.dpemotes:PlayEmote("mechanic")
		TriggerEvent("mythic_progbar:client:progress", {
			name = "mechanic_repair",
			duration = 10000,
			label = "Dar hale tamir kardan mashin",
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

				ClearPedTasksImmediately(PlayerPedId())
				Repair(vehicle)

				impound.busy = false
				impound.vehicle = 0

			elseif status then
				ClearPedTasksImmediately(PlayerPedId())
				impound.busy = false
				impound.vehicle = 0
			end

		end)

	end
end

function CleanVehicle(vehicle)
	if not impound.busy then

		impound.busy = true
		impound.vehicle = vehicle
		TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_MAID_CLEAN", 0, true)
		TriggerEvent("mythic_progbar:client:progress", {
			name = "mechanic_clean",
			duration = 5000,
			label = "Dar hale tamiz kardan mashin",
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

				ClearPedTasksImmediately(PlayerPedId())
				Clean(vehicle)

				impound.busy = false
				impound.vehicle = 0

			elseif status then
				ClearPedTasksImmediately(PlayerPedId())
				impound.busy = false
				impound.vehicle = 0
			end

		end)

	end
end

function HiJackVehicle(vehicle)
	if not impound.busy then

		if GetVehicleDoorLockStatus(vehicle) == 2 then

			TriggerServerEvent('esx_customItems:remove', 'picklock')
			impound.busy = true
			impound.vehicle = vehicle
			local plate = GetVehicleNumberPlateText(vehicle)
			local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
			local NetId = NetworkGetNetworkIdFromEntity(vehicle)
			TriggerServerEvent('esx_vehiclecontrol:syncAlarm', NetId, true)
			TriggerEvent("mythic_progbar:client:progress", {
				name = "vehicle_hijack",
				duration = 30000,
				label = "Dar hale lockpick kardan mashin",
				useWhileDead = false,
				canCancel = true,
				controlDisables = {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				},
				animation = {
					animDict = "missheistdockssetup1clipboard@idle_a",
					anim = "idle_a",
				},
			}, function(status)

				if not status then

					impound.busy = false
					impound.vehicle = 0

					local number = math.random(1, 3)

					if number % 2 == 0 then
						HiJack(vehicle)
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Mashin ba movafaghiat ^1picklock ^0shod!")
						TriggerServerEvent('esx_vehiclecontrol:syncAlarm', NetId, false)
					else
						TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0PickLock shoma ^1shekast!")
						TriggerServerEvent('esx_vehiclecontrol:NotifyOwner', plate, model)
						Citizen.CreateThread(function()
							Citizen.Wait(5000)
							TriggerServerEvent('esx_vehiclecontrol:syncAlarm', NetId, false)
						end)
					end

				elseif status then
					impound.busy = false
					impound.vehicle = 0
					TriggerServerEvent('esx_vehiclecontrol:NotifyOwner', plate, model)
					Citizen.CreateThread(function()
						Citizen.Wait(5000)
						TriggerServerEvent('esx_vehiclecontrol:syncAlarm', NetId, false)
					end)
				end

			end)

		else
			TriggerEvent("chatMessage", "[SYSTEM]", {255, 0, 0}, "^0Dare mashin mored nazar ghofl nist!")
		end

	end
end

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(1000)

	  if impound.busy and impound.vehicle ~= 0 then

		local coords = GetEntityCoords(PlayerPedId())

		if not DoesEntityExist(impound.vehicle) then
			TriggerEvent("mythic_progbar:client:cancel")
			impound.busy = false
			impound.vehicle = 0
		end

		local vcoords = GetEntityCoords(impound.vehicle)
		local distance = #(coords.xy - vcoords.xy)

		if IsAnyPedInVehicle(impound.vehicle) then
			ESX.ShowNotification("~h~Shakhsi vared mashin shod!")
			TriggerEvent("mythic_progbar:client:cancel")
			impound.busy = false
			impound.vehicle = 0
		end

		if distance > 4 then
			ESX.ShowNotification("Mashin mored nazar az shoma ~r~door ~s~shod!")
			TriggerEvent("mythic_progbar:client:cancel")
			impound.busy = false
			impound.vehicle = 0
		end

	  end

	end
end)

exports("GetVehicles", GetVehicles)
exports("ImpoundPolice", ImpoundPolice)
exports("Impoundsheriff", Impoundsheriff)
exports("DeleteVehicle", DeleteVehicles)
exports("RepairVehicle", RepairVehicle)
exports("CleanVehicle", CleanVehicle)

interactionDistance = 3.5
lockDistance = 25
local timer = 0

ESX = nil
Citizen.CreateThread(
	function()
		while ESX == nil do
			TriggerEvent(
				"esx:getSharedObject",
				function(obj)
					ESX = obj
				end
			)
			Citizen.Wait(50)
			PlayerData = ESX.GetPlayerData()
		end
	end
)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
	"esx:playerLoaded",
	function(xPlayer)
		PlayerData = xPlayer
	end
)

RegisterNetEvent("esx:setJob")
AddEventHandler(
	"esx:setJob",
	function(job)
		PlayerData.job = job
	end
)

saved = false
controlsave_bool = false

RegisterNetEvent("lockLights")
AddEventHandler("lockLights", function(vehicle)
		local vehicle = vehicle
		SetVehicleLights(vehicle, 2)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 0)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 2)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 0)
	end)

RegisterNetEvent("lock")
AddEventHandler("lock",function()

	local vehicle = {}
	local name = nil
	if PlayerData.job.name == "police" then

		vehicles = {
			949403409,
			335384930,
			1912215274,
			-1046437422,
			1561926939,
			-1574893700,
			-283186696,
			-2007026063,
			2046537925,
			-1627000575,
			456714581,
			-1323100960,
			2071877360,
			831758577,
			699188170,
			1341474454,
			-1674384553,
			-1973172295,
			1127131465,
			-1647941228,
			-34623805,
			-1683328900,
			1922257928,
			-305727417,
			-304857564,
			-1176401295,
			1624609239,
			-1661555510,
			1663218586,
			353883353,
			-982610657,
			-1083357304,
			1496279100,
			-1959382956,
			-834607087,
			-1631996672,
			653331214,
			38057582
		}
		name = "police"

	elseif PlayerData.job.name == "sheriff" then

		vehicles = {
			949403409,
			1912215274,
			-2007026063,
			2046537925,
			-1627000575,
			456714581,
			-1323100960,
			2071877360,
			831758577,
			699188170,
			1341474454,
			-1674384553,
			-1973172295,
			1127131465,
			-1647941228,
			-34623805,
			-1683328900,
			1922257928,
			-305727417,
			-304857564,
			-1176401295,
			1624609239,
			-1661555510,
			1663218586,
			353883353,
			-982610657,
			-1083357304,
			1496279100,
			-1959382956,
			-834607087,
			-1631996672,
			653331214,
			38057582
		}
		name = "sheriff"

	elseif PlayerData.job.name == "ambulance" then

		vehicles = {
			745926877,
			-726768679,
			1171614426,
			469291905,
			-1647941228,
			353883353,
			-1860923259,
			-574837267,
			-974922913,
			-1800062819
		}
		name = "ambulance"

	elseif PlayerData.job.name == "food" then

		vehicles = {
			1663218586,
			1951180813,
			-1289178744
		}
		name = "sandwitchi"

	elseif PlayerData.job.name == "nightclub" then

		vehicles = {
			86520421,
			-1908948564

		}
		name = "nightclub"
	elseif PlayerData.job.name == "mechanic" then

		vehicles = {
			-1349095620,
			-1323100960,
			2132890591,
			1119641113,
			-442313018,
			1353720154
		}
		name = "mechanic"
	elseif PlayerData.job.name == "fisherman" then

		vehicles = {
			2053223216
		}
		name = "mahigir"
	elseif PlayerData.job.name == "fueler" then

		vehicles = {
			-2137348917
		}
		name = "sherkat naft"
	elseif PlayerData.job.name == "lumberjack" then

		vehicles = {
			-2137348917
			}
		name = "choob bor"
	elseif PlayerData.job.name == "miner" then

		vehicles = {
			-1705304628
		}
		name = "Madanchi"
	elseif PlayerData.job.name == "slaughterer" then

		vehicles = {
			2053223216
		}
		name = "Ghasab"
	elseif PlayerData.job.name == "tailor" then

		vehicles = {
			1026149675
		}
		name = "Khayat"

	elseif PlayerData.job.name == "weazel" then

		vehicles = {
			1162065741
		}
		name = "Weazel"
	elseif PlayerData.job.name == "taxi" then

		vehicles = {
			156252959,
			1123216662,
			-1008861746,
			-511601230,
			-956048545,
			-2030171296
		}
		name = "taxi"

	else


		return

	end

		if IsPedSittingInAnyVehicle(PlayerPedId()) then

			local player = PlayerPedId()
			local vehicle = GetVehiclePedIsUsing(player)
			local islocked = GetVehicleDoorLockStatus(vehicle)
			if DoesEntityExist(vehicle) then


				local function contains(table, val)
					for i = 1, #table do
						if table[i] == val then
							return true
						end
					end
					return false
				end
				if contains(vehicles, GetEntityModel(vehicle)) then

						if (islocked == 1 or islocked == 0) then
							SetVehicleDoorsLocked(vehicle, 2)
							VehControl_ShowNotification(
								"Shoma ~y~" ..
									GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) .. "~w~ ra ~r~ghofl ~w~kardid."
							)
							TriggerEvent("lockLights", vehicle)
							local dict = "anim@mp_player_intmenu@key_fob@"
							RequestAnimDict(dict)
							while not HasAnimDictLoaded(dict) do
								Citizen.Wait(1)
							end
							if not IsPedInAnyVehicle(PlayerPedId(), true) then
								TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
							end
							SetVehicleDoorShut(vehicle, 0, false)
							SetVehicleDoorShut(vehicle, 1, false)
							SetVehicleDoorShut(vehicle, 2, false)
							SetVehicleDoorShut(vehicle, 3, false)
							SetVehicleDoorShut(vehicle, 4, false)
							SetVehicleDoorShut(vehicle, 5, false)
							PlayVehicleDoorCloseSound(vehicle, 1)
							TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "lock", 0.5)
							ESX.TriggerServerCallback('esx_policejob:getIcName', function(PlayerName)

								if PlayerName ~= nil then
									local PlayerName = GetPlayerName(PlayerId())
									local text = '* ' .. PlayerName .. ' vasile naghlie ro ghofl mikone *'


									TriggerServerEvent('3dme:shareDisplay', text, false)

								end

							end)


						elseif islocked == 2 then
							SetVehicleDoorsLocked(vehicle, 1)
							VehControl_ShowNotification(
								"Shoma ~y~" ..
									GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) .. "~w~ ra ~g~baaz ~w~kardid."
							)
							TriggerEvent("lockLights", vehicle)
							local dict = "anim@mp_player_intmenu@key_fob@"
							RequestAnimDict(dict)
							while not HasAnimDictLoaded(dict) do
								Citizen.Wait(1)
							end
							if not IsPedInAnyVehicle(PlayerPedId(), true) then
								TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
							end
							PlayVehicleDoorCloseSound(vehicle, 1)
							TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "unlock", 0.5)
							ESX.TriggerServerCallback('esx_policejob:getIcName', function(PlayerName)

								if PlayerName ~= nil then
									local PlayerName = GetPlayerName(PlayerId())
									local text = '* ' .. PlayerName .. ' vasile naghlie ro baz mikone *'


									TriggerServerEvent('3dme:shareDisplay', text, false)

								end

							end)

						end



				end
			else
				VehControl_ShowNotification("~r~~h~Hich mashini nazdik shoma nist.")
			end



		else

			local player = PlayerPedId()
			local vehicle = ESX.Game.GetVehicleInDirection(4)
			local islocked = GetVehicleDoorLockStatus(vehicle)
			local distanceToVeh = #(GetEntityCoords(player) - GetEntityCoords(vehicle))
			if DoesEntityExist(vehicle) then


				local function contains(table, val)
					for i = 1, #table do
						if table[i] == val then
							return true
						end
					end
					return false
				end
				if contains(vehicles, GetEntityModel(vehicle)) then

						if (islocked == 1 or islocked == 0) then
							SetVehicleDoorsLocked(vehicle, 2)
							VehControl_ShowNotification(
								"Shoma ~y~" ..
									GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) .. "~w~ ra ~r~ghofl ~w~kardid."
							)
							TriggerEvent("lockLights", vehicle)
							local dict = "anim@mp_player_intmenu@key_fob@"
							RequestAnimDict(dict)
							while not HasAnimDictLoaded(dict) do
								Citizen.Wait(1)
							end
							if not IsPedInAnyVehicle(PlayerPedId(), true) then
								TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
							end
							SetVehicleDoorShut(vehicle, 0, false)
							SetVehicleDoorShut(vehicle, 1, false)
							SetVehicleDoorShut(vehicle, 2, false)
							SetVehicleDoorShut(vehicle, 3, false)
							SetVehicleDoorShut(vehicle, 4, false)
							SetVehicleDoorShut(vehicle, 5, false)
							PlayVehicleDoorCloseSound(vehicle, 1)
							TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "lock", 0.5)
							ESX.TriggerServerCallback('esx_policejob:getIcName', function(PlayerName)

								if PlayerName ~= nil then

									local text = '* ' .. PlayerName .. ' vasile naghlie ro ghofl mikone *'


									TriggerServerEvent('3dme:shareDisplay', text, false)

								end

							end)

						elseif islocked == 2 then
							SetVehicleDoorsLocked(vehicle, 1)
							VehControl_ShowNotification(
								"Shoma ~y~" ..
									GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) .. "~w~ ra ~g~baaz ~w~kardid."
							)
							TriggerEvent("lockLights", vehicle)
							local dict = "anim@mp_player_intmenu@key_fob@"
							RequestAnimDict(dict)
							while not HasAnimDictLoaded(dict) do
								Citizen.Wait(1)
							end
							if not IsPedInAnyVehicle(PlayerPedId(), true) then
								TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
							end
							PlayVehicleDoorCloseSound(vehicle, 1)
							TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "unlock", 0.5)
							ESX.TriggerServerCallback('esx_policejob:getIcName', function(PlayerName)

								if PlayerName ~= nil then

									local text = '* ' .. PlayerName .. ' vasile naghlie ro baz mikone *'


									TriggerServerEvent('3dme:shareDisplay', text, false)

								end

							end)

						end

				else
					VehControl_ShowNotification("~r~~h~In yek mashin " .. name .. " nist")
				end
			else

				local player = PlayerPedId()
				local vehicle = saveVehicle
				local islocked = GetVehicleDoorLockStatus(vehicle)
				local distanceToVeh = #(GetEntityCoords(player) - GetEntityCoords(vehicle))
				if DoesEntityExist(vehicle) then
						if distanceToVeh <= lockDistance then
							if (islocked == 1 or islocked == 0) then
								SetVehicleDoorsLocked(vehicle, 2)
								VehControl_ShowNotification(
									"Shoma ~y~" ..
										GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) .. "~w~ ra ~r~ghofl ~w~kardid."
								)
								TriggerEvent("lockLights", vehicle)
								local dict = "anim@mp_player_intmenu@key_fob@"
							RequestAnimDict(dict)
							while not HasAnimDictLoaded(dict) do
								Citizen.Wait(1)
							end
							if not IsPedInAnyVehicle(PlayerPedId(), true) then
								TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
							end
							SetVehicleDoorShut(vehicle, 0, false)
							SetVehicleDoorShut(vehicle, 1, false)
							SetVehicleDoorShut(vehicle, 2, false)
							SetVehicleDoorShut(vehicle, 3, false)
							SetVehicleDoorShut(vehicle, 4, false)
							SetVehicleDoorShut(vehicle, 5, false)
							PlayVehicleDoorCloseSound(vehicle, 1)
							TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "lock", 0.5)
								ESX.TriggerServerCallback('esx_policejob:getIcName', function(PlayerName)

									if PlayerName ~= nil then

										local PlayerName = GetPlayerName(PlayerId())
										local text = '* ' .. PlayerName .. ' vasile naghlie ro ghofl mikone *'


										TriggerServerEvent('3dme:shareDisplay', text, false)

									end

								end)

							elseif islocked == 2 then
								SetVehicleDoorsLocked(vehicle, 1)
								VehControl_ShowNotification(
									"Shoma ~y~" ..
										GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) .. "~w~ ra ~g~baaz ~w~kardid."
								)
								TriggerEvent("lockLights", vehicle)
								local dict = "anim@mp_player_intmenu@key_fob@"
							RequestAnimDict(dict)
							while not HasAnimDictLoaded(dict) do
								Citizen.Wait(1)
							end
							if not IsPedInAnyVehicle(PlayerPedId(), true) then
								TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
							end
							PlayVehicleDoorCloseSound(vehicle, 1)
							TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "unlock", 0.5)
								ESX.TriggerServerCallback('esx_policejob:getIcName', function(PlayerName)

									if PlayerName ~= nil then
										local PlayerName = GetPlayerName(PlayerId())

										local text = '* ' .. PlayerName .. ' vasile naghlie ro baz mikone *'


										TriggerServerEvent('3dme:shareDisplay', text, false)

									end

								end)

							end
						else
							VehControl_ShowNotification("~r~Shoma nazdik mashin nistid.")
						end
				else
					VehControl_ShowNotification("~r~~h~Shoma Mashin save shodeyi nadarid.")
				end

			end

		end
end)

function VehControl_ShowNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

RegisterNetEvent("save")
AddEventHandler("save",function(pelak)

	local player = PlayerPedId()
	if (IsPedSittingInAnyVehicle(player)) then

		if PlayerData.job.name == "police" then
			local vehicles = {
				949403409,
				335384930,
				-1046437422,
				1561926939,
				-1574893700,
				1912215274,
				-283186696,
				-2007026063,
				2046537925,
				-1627000575,
				456714581,
				-1323100960,
				2071877360,
				831758577,
				699188170,
				1341474454,
				-1674384553,
				-1973172295,
				1127131465,
				-1647941228,
				-34623805,
				-1683328900,
				1922257928,
				-305727417,
				-304857564,
				-1176401295,
				1624609239,
				-1661555510,
				1663218586,
				353883353,
				-982610657,
				-1083357304,
				1496279100,
				-1959382956,
				-834607087,
				-1631996672,
				653331214,
				38057582
			}

			local function contains(table, val)
				for i = 1, #table do
					if table[i] == val then
						return true
					end
				end
				return false
			end
			if contains(vehicles, GetEntityModel(GetVehiclePedIsIn(player))) then
				if saved == true then

					saveVehicle = nil
					RemoveBlip(targetBlip)
					VehControl_ShowNotification("Mashin ~g~save~w~ shode shoma ~r~hazf~w~ shod.")
					saved = false
				elseif saved == false then
					RemoveBlip(targetBlip)
					saveVehicle = GetVehiclePedIsIn(player, true)
					local vehicle = saveVehicle
					targetBlip = AddBlipForEntity(vehicle)
					SetBlipSprite(targetBlip, 41)
					SetBlipDisplay(targetBlip, 4)
					SetBlipScale(targetBlip, 0.7)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(pelak)
					EndTextCommandSetBlipName(targetBlip)
					SetVehicleNumberPlateText(vehicle, pelak)
					VehControl_ShowNotification(
						"~y~" ..
							GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) ..
								"~w~ Be onvan mashin shoma ~g~save ~w~Shod."
					)
					saved = true
				end
			else
				VehControl_ShowNotification("~r~~h~Shoma Faghat Ghader be save kardan mashin haye police hastid")
			end

		elseif PlayerData.job.name == "sheriff" then
			local vehicles = {
				949403409,
				1912215274,
				-2007026063,
				2046537925,
				-1627000575,
				456714581,
				-1323100960,
				2071877360,
				831758577,
				699188170,
				1341474454,
				-1674384553,
				-1973172295,
				1127131465,
				-1647941228,
				-34623805,
				-1683328900,
				1922257928,
				-305727417,
				-304857564,
				-1176401295,
				1624609239,
				-1661555510,
				1663218586,
				353883353,
				-982610657,
				-1083357304,
				1496279100,
				-1959382956,
				-834607087,
				-1631996672,
				653331214,
				38057582
			}

			local function contains(table, val)
				for i = 1, #table do
					if table[i] == val then
						return true
					end
				end
				return false
			end
			if contains(vehicles, GetEntityModel(GetVehiclePedIsIn(player))) then
				if saved == true then

					saveVehicle = nil
					RemoveBlip(targetBlip)
					VehControl_ShowNotification("Mashin ~g~save~w~ shode shoma ~r~hazf~w~ shod.")
					saved = false
				elseif saved == false then
					RemoveBlip(targetBlip)
					saveVehicle = GetVehiclePedIsIn(player, true)
					local vehicle = saveVehicle
					targetBlip = AddBlipForEntity(vehicle)
					SetBlipSprite(targetBlip, 41)
					SetBlipDisplay(targetBlip, 4)
					SetBlipScale(targetBlip, 0.7)
					SetBlipColour(targetBlip, 10)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(pelak)
					EndTextCommandSetBlipName(targetBlip)
					SetVehicleNumberPlateText(vehicle, pelak)
					VehControl_ShowNotification(
						"~y~" ..
							GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) ..
								"~w~ Be onvan mashin shoma ~g~save ~w~Shod."
					)
					saved = true
				end
			else
				VehControl_ShowNotification("~r~~h~Shoma Faghat Ghader be save kardan mashin haye sheriff hastid")
			end

		elseif PlayerData.job.name == "mechanic" then

			local vehicles = {
				-1349095620,
				-1323100960,
				2132890591,
				1119641113,
				-442313018,
				1353720154
			}

			local function contains(table, val)
				for i = 1, #table do
					if table[i] == val then
						return true
					end
				end
				return false
			end
			if contains(vehicles, GetEntityModel(GetVehiclePedIsIn(player))) then
				if saved == true then

					saveVehicle = nil
					RemoveBlip(targetBlip)
					VehControl_ShowNotification("Mashin ~g~save~w~ shode shoma ~r~hazf~w~ shod.")
					saved = false
				elseif saved == false then
					RemoveBlip(targetBlip)
					saveVehicle = GetVehiclePedIsIn(player, true)
					local vehicle = saveVehicle
					targetBlip = AddBlipForEntity(vehicle)
					SetBlipSprite(targetBlip, 225)
					SetBlipColour(targetBlip, 81)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(pelak)
					EndTextCommandSetBlipName(targetBlip)
					SetVehicleNumberPlateText(vehicle, pelak)
					VehControl_ShowNotification(
						"~y~" ..
							GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) ..
								"~w~ Be onvan mashin shoma ~g~save ~w~Shod."
					)
					saved = true
				end
			else
				VehControl_ShowNotification("~r~~h~Shoma Faghat Ghader be save kardan mashin haye mechanici hastid")
			end

		elseif PlayerData.job.name == "ambulance" then

			local vehicles = {
				745926877,
				-726768679,
				-974922913,
				1171614426,
				469291905,
				-1647941228,
				353883353,
				-1860923259,
				-574837267,
				-1800062819
			}

			local function contains(table, val)
				for i = 1, #table do
					if table[i] == val then
						return true
					end
				end
				return false
			end
			if contains(vehicles, GetEntityModel(GetVehiclePedIsIn(player))) then
				if saved == true then

					saveVehicle = nil
					RemoveBlip(targetBlip)
					VehControl_ShowNotification("Mashin ~g~save~w~ shode shoma ~r~hazf~w~ shod.")
					saved = false
				elseif saved == false then
					RemoveBlip(targetBlip)
					saveVehicle = GetVehiclePedIsIn(player, true)
					local vehicle = saveVehicle
					targetBlip = AddBlipForEntity(vehicle)
					SetBlipSprite(targetBlip, 225)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(pelak)
					SetBlipColour(targetBlip, 1)
					EndTextCommandSetBlipName(targetBlip)
					SetVehicleNumberPlateText(vehicle, pelak)
					VehControl_ShowNotification(
						"~y~" ..
							GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) ..
								"~w~ Be onvan mashin shoma ~g~save ~w~Shod."
					)
					saved = true
				end
			else
				VehControl_ShowNotification("~r~~h~Shoma Faghat Ghader be save kardan mashin haye medic hastid")
			end

		elseif PlayerData.job.name == "food" then

			local vehicles = {
				1663218586,
				1951180813,
				-1289178744
			}

			local function contains(table, val)
				for i = 1, #table do
					if table[i] == val then
						return true
					end
				end
				return false
			end
			if contains(vehicles, GetEntityModel(GetVehiclePedIsIn(player))) then
				if saved == true then

					saveVehicle = nil
					RemoveBlip(targetBlip)
					VehControl_ShowNotification("Mashin ~g~save~w~ shode shoma ~r~hazf~w~ shod.")
					saved = false
				elseif saved == false then
					RemoveBlip(targetBlip)
					saveVehicle = GetVehiclePedIsIn(player, true)
					local vehicle = saveVehicle
					targetBlip = AddBlipForEntity(vehicle)
					SetBlipSprite(targetBlip, 225)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(pelak)
					EndTextCommandSetBlipName(targetBlip)
					SetVehicleNumberPlateText(vehicle, pelak)
					VehControl_ShowNotification(
						"~y~" ..
							GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) ..
								"~w~ Be onvan mashin shoma ~g~save ~w~Shod."
					)
					saved = true
				end
			else
				VehControl_ShowNotification("~r~~h~Shoma Faghat Ghader be save kardan mashin haye sandwitchi hastid")
			end

			elseif PlayerData.job.name == "nightclub" then

			local vehicles = {
				86520421,
				-1908948564

			}

			local function contains(table, val)
				for i = 1, #table do
					if table[i] == val then
						return true
					end
				end
				return false
			end
			if contains(vehicles, GetEntityModel(GetVehiclePedIsIn(player))) then
				if saved == true then

					saveVehicle = nil
					RemoveBlip(targetBlip)
					VehControl_ShowNotification("Mashin ~g~save~w~ shode shoma ~r~hazf~w~ shod.")
					saved = false
				elseif saved == false then
					RemoveBlip(targetBlip)
					saveVehicle = GetVehiclePedIsIn(player, true)
					local vehicle = saveVehicle
					targetBlip = AddBlipForEntity(vehicle)
					SetBlipSprite(targetBlip, 225)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(pelak)
					EndTextCommandSetBlipName(targetBlip)
					SetVehicleNumberPlateText(vehicle, pelak)
					VehControl_ShowNotification(
						"~y~" ..
							GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) ..
								"~w~ Be onvan mashin shoma ~g~save ~w~Shod."
					)
					saved = true
				end
			else
				VehControl_ShowNotification("~r~~h~Shoma Faghat Ghader be save kardan mashin haye nightclub hastid")
			end

		elseif PlayerData.job.name == "fisherman" then

			local vehicles = {
					2053223216
			}

			local function contains(table, val)
				for i = 1, #table do
					if table[i] == val then
						return true
					end
				end
				return false
			end
			if contains(vehicles, GetEntityModel(GetVehiclePedIsIn(player))) then
				if saved == true then

					saveVehicle = nil
					RemoveBlip(targetBlip)
					VehControl_ShowNotification("Mashin ~g~save~w~ shode shoma ~r~hazf~w~ shod.")
					saved = false
				elseif saved == false then
					RemoveBlip(targetBlip)
					saveVehicle = GetVehiclePedIsIn(player, true)
					local vehicle = saveVehicle
					targetBlip = AddBlipForEntity(vehicle)
					SetBlipSprite(targetBlip, 225)
					SetVehicleNumberPlateText(vehicle, 'Mahigiri')
					VehControl_ShowNotification(
						"~y~" ..
							GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) ..
								"~w~ Be onvan mashin shoma ~g~save ~w~Shod."
					)
					saved = true
				end
			else
				VehControl_ShowNotification("~r~~h~Shoma Faghat Ghader be save kardan mashin haye Mahigiri hastid")
			end

		elseif PlayerData.job.name == "fueler" then

			local vehicles = {
				-2137348917
			}

			local function contains(table, val)
				for i = 1, #table do
					if table[i] == val then
						return true
					end
				end
				return false
			end
			if contains(vehicles, GetEntityModel(GetVehiclePedIsIn(player))) then
				if saved == true then

					saveVehicle = nil
					RemoveBlip(targetBlip)
					VehControl_ShowNotification("Mashin ~g~save~w~ shode shoma ~r~hazf~w~ shod.")
					saved = false
				elseif saved == false then
					RemoveBlip(targetBlip)
					saveVehicle = GetVehiclePedIsIn(player, true)
					local vehicle = saveVehicle
					targetBlip = AddBlipForEntity(vehicle)
					SetBlipSprite(targetBlip, 225)
					SetVehicleNumberPlateText(vehicle, 'sherkatnaft')
					VehControl_ShowNotification(
						"~y~" ..
							GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) ..
								"~w~ Be onvan mashin shoma ~g~save ~w~Shod."
					)
					saved = true
				end
			else
				VehControl_ShowNotification("~r~~h~Shoma Faghat Ghader be save kardan mashin haye Sherkat Naft hastid")
			end

		elseif PlayerData.job.name == "lumberjack" then

			local vehicles = {
				-2137348917
			}

			local function contains(table, val)
				for i = 1, #table do
					if table[i] == val then
						return true
					end
				end
				return false
			end
			if contains(vehicles, GetEntityModel(GetVehiclePedIsIn(player))) then
				if saved == true then

					saveVehicle = nil
					RemoveBlip(targetBlip)
					VehControl_ShowNotification("Mashin ~g~save~w~ shode shoma ~r~hazf~w~ shod.")
					saved = false
				elseif saved == false then
					RemoveBlip(targetBlip)
					saveVehicle = GetVehiclePedIsIn(player, true)
					local vehicle = saveVehicle
					targetBlip = AddBlipForEntity(vehicle)
					SetBlipSprite(targetBlip, 225)
					SetVehicleNumberPlateText(vehicle, 'Choob Bor')
					VehControl_ShowNotification(
						"~y~" ..
							GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) ..
								"~w~ Be onvan mashin shoma ~g~save ~w~Shod."
					)
					saved = true
				end
			else
				VehControl_ShowNotification("~r~~h~Shoma Faghat Ghader be save kardan mashin haye Choob Bor hastid")
			end

		elseif PlayerData.job.name == "tailor" then

			local vehicles = {
				1026149675
			}

			local function contains(table, val)
				for i = 1, #table do
					if table[i] == val then
						return true
					end
				end
				return false
			end
			if contains(vehicles, GetEntityModel(GetVehiclePedIsIn(player))) then
				if saved == true then

					saveVehicle = nil
					RemoveBlip(targetBlip)
					VehControl_ShowNotification("Mashin ~g~save~w~ shode shoma ~r~hazf~w~ shod.")
					saved = false
				elseif saved == false then
					RemoveBlip(targetBlip)
					saveVehicle = GetVehiclePedIsIn(player, true)
					local vehicle = saveVehicle
					targetBlip = AddBlipForEntity(vehicle)
					SetBlipSprite(targetBlip, 225)
					SetVehicleNumberPlateText(vehicle, 'Khayat')
					VehControl_ShowNotification(
						"~y~" ..
							GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) ..
								"~w~ Be onvan mashin shoma ~g~save ~w~Shod."
					)
					saved = true
				end
			else
				VehControl_ShowNotification("~r~~h~Shoma Faghat Ghader be save kardan mashin haye Khayati hastid")
			end

		elseif PlayerData.job.name == "miner" then

			local vehicles = {
				-1705304628
			}

			local function contains(table, val)
				for i = 1, #table do
					if table[i] == val then
						return true
					end
				end
				return false
			end
			if contains(vehicles, GetEntityModel(GetVehiclePedIsIn(player))) then
				if saved == true then

					saveVehicle = nil
					RemoveBlip(targetBlip)
					VehControl_ShowNotification("Mashin ~g~save~w~ shode shoma ~r~hazf~w~ shod.")
					saved = false
				elseif saved == false then
					RemoveBlip(targetBlip)
					saveVehicle = GetVehiclePedIsIn(player, true)
					local vehicle = saveVehicle
					targetBlip = AddBlipForEntity(vehicle)
					SetBlipSprite(targetBlip, 225)
					SetVehicleNumberPlateText(vehicle, 'Madanchi')
					VehControl_ShowNotification(
						"~y~" ..
							GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) ..
								"~w~ Be onvan mashin shoma ~g~save ~w~Shod."
					)
					saved = true
				end
			else
				VehControl_ShowNotification("~r~~h~Shoma Faghat Ghader be save kardan mashin haye Madanchi hastid")
			end

		elseif PlayerData.job.name == "slaughterer" then

			local vehicles = {
				2053223216
			}

			local function contains(table, val)
				for i = 1, #table do
					if table[i] == val then
						return true
					end
				end
				return false
			end
			if contains(vehicles, GetEntityModel(GetVehiclePedIsIn(player))) then
				if saved == true then

					saveVehicle = nil
					RemoveBlip(targetBlip)
					VehControl_ShowNotification("Mashin ~g~save~w~ shode shoma ~r~hazf~w~ shod.")
					saved = false
				elseif saved == false then
					RemoveBlip(targetBlip)
					saveVehicle = GetVehiclePedIsIn(player, true)
					local vehicle = saveVehicle
					targetBlip = AddBlipForEntity(vehicle)
					SetBlipSprite(targetBlip, 225)
					SetVehicleNumberPlateText(vehicle, 'Ghasab')
					VehControl_ShowNotification(
						"~y~" ..
							GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) ..
								"~w~ Be onvan mashin shoma ~g~save ~w~Shod."
					)
					saved = true
				end
			else
				VehControl_ShowNotification("~r~~h~Shoma Faghat Ghader be save kardan mashin haye Ghasab hastid")
			end

			elseif PlayerData.job.name == "weazel" then

			local vehicles = {
				1162065741
			}

			local function contains(table, val)
				for i = 1, #table do
					if table[i] == val then
						return true
					end
				end
				return false
			end
			if contains(vehicles, GetEntityModel(GetVehiclePedIsIn(player))) then
				if saved == true then

					saveVehicle = nil
					RemoveBlip(targetBlip)
					VehControl_ShowNotification("Mashin ~g~save~w~ shode shoma ~r~hazf~w~ shod.")
					saved = false
				elseif saved == false then
					RemoveBlip(targetBlip)
					saveVehicle = GetVehiclePedIsIn(player, true)
					local vehicle = saveVehicle
					targetBlip = AddBlipForEntity(vehicle)
					SetBlipSprite(targetBlip, 225)
					SetVehicleNumberPlateText(vehicle, 'Ghasab')
					VehControl_ShowNotification(
						"~y~" ..
							GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) ..
								"~w~ Be onvan mashin shoma ~g~save ~w~Shod."
					)
					saved = true
				end
			else
				VehControl_ShowNotification("~r~~h~Shoma Faghat Ghader be save kardan mashin haye Weazel News hastid")
			end

		elseif PlayerData.job.name == "taxi" then

			local vehicles = {
			156252959,
			1123216662,
			-1008861746,
			-511601230,
			-956048545,
			-2030171296
			}

			local function contains(table, val)
				for i = 1, #table do
					if table[i] == val then
						return true
					end
				end
				return false
			end
			if contains(vehicles, GetEntityModel(GetVehiclePedIsIn(player))) then
				if saved == true then

					saveVehicle = nil
					RemoveBlip(targetBlip)
					VehControl_ShowNotification("Mashin ~g~save~w~ shode shoma ~r~hazf~w~ shod.")
					saved = false
				elseif saved == false then
					RemoveBlip(targetBlip)
					saveVehicle = GetVehiclePedIsIn(player, true)
					local vehicle = saveVehicle
					targetBlip = AddBlipForEntity(vehicle)
					SetBlipSprite(targetBlip, 225)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(pelak)
					SetBlipColour(targetBlip, 46)
					EndTextCommandSetBlipName(targetBlip)
					SetVehicleNumberPlateText(vehicle, pelak)
					VehControl_ShowNotification(
						"~y~" ..
							GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))) ..
								"~w~ Be onvan mashin shoma ~g~save ~w~Shod."
					)
					saved = true
				end
			else
				VehControl_ShowNotification("~r~~h~Shoma Faghat Ghader be save kardan mashin haye taxi hastid")
			end

		else



		end
	end

end)

RegisterNetEvent("controlsave")
AddEventHandler(
	"controlsave",
	function()
		if controlsave_bool == false then
			controlsave_bool = true
			if saveVehicle == nil then
				VehControl_ShowNotification("~r~No saved vehicle.")
			else
				VehControl_ShowNotification(
					"You are no longer controlling your ~y~" ..
						GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(saveVehicle)))
				)
			end
		else
			controlsave_bool = false
			if saveVehicle == nil then
				VehControl_ShowNotification("~r~No saved vehicle.")
			else
				VehControl_ShowNotification(
					"You are no longer controlling your ~y~" ..
						GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(saveVehicle)))
				)
			end
		end
	end
)

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(1)

		if IsControlJustReleased(0, 178) then

			if GetGameTimer() - 2000  > timer then

				TriggerEvent('engine')

				timer = GetGameTimer()

			else

				timer = GetGameTimer()
				ESX.ShowNotification("~r~Lotfan spam nakonid")

			end


	end

		if IsControlJustReleased(0, 246) then

			if GetGameTimer() - 2000  > timer then

				TriggerEvent('lock')

				timer = GetGameTimer()

			else

				timer = GetGameTimer()
				ESX.ShowNotification("~r~Lotfan spam nakonid")

			end

		end

    end
end )

RegisterNetEvent("engine")
AddEventHandler(
	"engine",
	function()
		local player = PlayerPedId()
		if (IsPedSittingInAnyVehicle(player)) then
			local vehicle = GetVehiclePedIsIn(player, false)
			local plate = GetVehicleNumberPlateText(vehicle)
			ESX.TriggerServerCallback('CarLock:haskey', function(haskey)
				if  haskey then
					if GetPedInVehicleSeat(vehicle, -1) == player then
						if IsEngineOn == true then
							IsEngineOn = false
							ESX.ShowNotification("Engine ~r~Off~s~.")
							SetVehicleEngineOn(vehicle, false, false, false)
							if GetGameTimer() - 2000  > timer then
								local PlayerName = GetPlayerName(PlayerId())
								local text = '* ' .. PlayerName .. ' motore vasile naghlie ro khamosh mikone *'

								TriggerServerEvent('3dme:shareDisplay', text, false)

								timer = GetGameTimer()
							end

						else
							IsEngineOn = true
							ESX.ShowNotification("Engine ~g~On~s~.")
							SetVehicleUndriveable(vehicle, false)
							SetVehicleEngineOn(vehicle, true, false, false)
							if GetGameTimer() - 2000  > timer then
								local PlayerName = GetPlayerName(PlayerId())

								local text = '* ' .. PlayerName .. ' motore vasile naghlie ro roshan mikone *'

								TriggerServerEvent('3dme:shareDisplay', text, false)

								timer = GetGameTimer()
							end
						end
					end

					while (IsEngineOn == false) do
						SetVehicleUndriveable(vehicle, true)
						Citizen.Wait(1)
					end
				end
			end, plate)
		end
	end
)

RegisterNetEvent("engineoff")
AddEventHandler(
	"engineoff",
	function()
		local player = PlayerPedId()

		if (IsPedSittingInAnyVehicle(player)) then
			local vehicle = GetVehiclePedIsIn(player, false)
			engineoff = true
			ESX.ShowNotification("Engine ~r~off~s~.")
			while (engineoff) do
				SetVehicleEngineOn(vehicle, false, false, false)
				SetVehicleUndriveable(vehicle, true)
				Citizen.Wait(1)
			end
		end
	end
)

RegisterNetEvent("engineon")
AddEventHandler(
	"engineon",
	function()
		local player = PlayerPedId()

		if (IsPedSittingInAnyVehicle(player)) then
			local vehicle = GetVehiclePedIsIn(player, false)
			engineoff = false
			SetVehicleUndriveable(vehicle, false)
			SetVehicleEngineOn(vehicle, true, false, false)
			ESX.ShowNotification("Engine ~g~on~s~.")
		end
	end
)

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/engine', 'On / Off Kardan Engine', {})
			RegisterCommand('engine', function()
				toggleEngine()
			end, false)
		while true do
			Citizen.Wait(1)
			local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

			if (IsControlJustReleased(0, 178) or IsDisabledControlJustReleased(0, 178)) and vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
				toggleEngine()
			end

		end
	end)
	function toggleEngine()
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
			SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
		end
	end

	exports("EngineHandler", EngineHandler)

	TriggerEvent('chat:addSuggestion', '/save', 'Save Or Remove Vehicle', {

})

