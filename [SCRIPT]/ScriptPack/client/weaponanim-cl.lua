local ESX      	 = nil
local holstered  = true
local blocked	 = false
local PlayerData = {}
local lastWeapon
local BlockWheel = false
local inPaintball = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(50)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
	checkHolsters()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

AddEventHandler('esx_paintball:inPaintBall', function(toggle)
	inPaintball = toggle
end)

function checkHolsters()
	while not PlayerData.job do
		Wait(50)
	end

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(10)
			local ped = PlayerPedId()

			if inPaintball ~= true then

					if PlayerData.job.name == 'police' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'mt' then
						if not IsPedInAnyVehicle(ped, false) then
							if GetVehiclePedIsTryingToEnter (ped) == 0 and IsPedInParachuteFreeFall(ped) == false then
								local weapon = CheckWeapon(ped)
								if weapon then
									lastWeapon = weapon
									if holstered then
										blocked  = true
										if weapon == "light" then
											loadAnimDict("reaction@intimidation@cop@unarmed")
											TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "intro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
											Citizen.Wait(Config.Cooldowns.police.light)
											loadAnimDict("rcmjosh4")
											TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
											Citizen.Wait(400)
											ClearPedTasks(ped)
											ClearPedSecondaryTask(ped)
											holstered = false
										else
											loadAnimDict("anim@heists@ornate_bank@grab_cash")
											TaskPlayAnim(ped, "anim@heists@ornate_bank@grab_cash", "intro", 8.0, 2.0, -1, 48, 10, 0, 0, 0)
											Citizen.Wait(Config.Cooldowns.police.heavy)
											ClearPedTasks(ped)
											ClearPedSecondaryTask(ped)
											holstered = false
										end

									else
										blocked = false
									end

								else
									if not holstered then
										if lastWeapon == "heavy" then
											BlockWheel = true
											loadAnimDict("anim@heists@ornate_bank@grab_cash")
											TaskPlayAnim(ped, "anim@heists@ornate_bank@grab_cash", "exit", 8.0, 2.0, -1, 48, 10, 0, 0, 0)
											Citizen.Wait(Config.Cooldowns.police.heavy)
											ClearPedTasks(ped)
											ClearPedSecondaryTask(ped)
											holstered = true
											BlockWheel = false
										else
											BlockWheel = true
											TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
											Citizen.Wait(Config.Cooldowns.police.light)
											TaskPlayAnim(ped, "reaction@intimidation@cop@unarmed", "outro", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0 )
											Citizen.Wait(60)
											ClearPedTasks(ped)
											ClearPedSecondaryTask(ped)
											holstered = true
											BlockWheel = false
										end
									end
								end
							else
								SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
							end
						else
							holstered = true
						end
					else
						if not IsPedInAnyVehicle(ped, false) then
							if GetVehiclePedIsTryingToEnter(ped) == 0 and not IsPedInParachuteFreeFall (ped) then
								local weapon = CheckWeapon(ped)
								if weapon then
									lastWeapon = weapon
									if holstered then
										blocked   = true
										if weapon == "light" then
											loadAnimDict("reaction@intimidation@1h")
											TaskPlayAnim(ped, "reaction@intimidation@1h", "intro", 5.0, 1.0, -1, 50, 0, 0, 0, 0 )
											Citizen.Wait(Config.Cooldowns.civilian.light)
											ClearPedTasks(ped)
											ClearPedSecondaryTask(ped)
											holstered = false
										else
											loadAnimDict("anim@heists@ornate_bank@grab_cash")
											TaskPlayAnim(ped, "anim@heists@ornate_bank@grab_cash", "intro", 8.0, 2.0, -1, 48, 10, 0, 0, 0)
											Citizen.Wait(Config.Cooldowns.civilian.heavy)
											ClearPedTasks(ped)
											ClearPedSecondaryTask(ped)
											holstered = false
										end

										holstered = false
									else
										blocked = false
									end
								else
									if not holstered then
										if lastWeapon == "heavy" then
											BlockWheel = true
											loadAnimDict("anim@heists@ornate_bank@grab_cash")
											TaskPlayAnim(ped, "anim@heists@ornate_bank@grab_cash", "exit", 8.0, 2.0, -1, 48, 10, 0, 0, 0)
											Citizen.Wait(Config.Cooldowns.civilian.heavy)
											ClearPedTasks(ped)
											ClearPedSecondaryTask(ped)

											holstered = true
											BlockWheel = false
										else
											BlockWheel = true
											loadAnimDict("reaction@intimidation@1h")
											TaskPlayAnim(ped, "reaction@intimidation@1h", "outro", 8.0, 3.0, -1, 50, 0, 0, 0.125, 0 )
											Citizen.Wait(Config.Cooldowns.civilian.light)
											ClearPedTasks(ped)
											ClearPedSecondaryTask(ped)
											holstered = true
											BlockWheel = false
										end
									end
								end
							else
								SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
							end
						else
							holstered = true
						end
					end



			end
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if blocked then
			DisableControlAction(1, 25, true )
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)

			DisableControlAction(1, 37, true)
			DisableControlAction(0, 73, true)
			DisablePlayerFiring(ped, true)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local ped = PlayerPedId()
		if holstered == false and GetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED")) == false then
			blocked = false
		end
	end
end)

function CheckWeapon(ped)
	if IsEntityDead(ped) then
		blocked = false
		return false
	else
		local weapon = GetSelectedPedWeapon(ped)
		return Config.Weapons[weapon]
	end
end

function loadAnimDict(dict)
	while ( not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end

RegisterNetEvent("holsterweapon:FixTab")
AddEventHandler("holsterweapon:FixTab", function()
	EnableControlAction(1, 25, true)
	EnableControlAction(1, 140, true)
	EnableControlAction(1, 141, true)
	EnableControlAction(1, 142, true)

	EnableControlAction(1, 37, true)
	EnableControlAction(0, 73, true)
	DisablePlayerFiring(ped, false)
	blocked = false
end)

RegisterCommand("fixme", function(source)
	TriggerEvent("holsterweapon:FixTab", source)
	ESX.ShowNotification("~w~[~y~Tab~w~] ~g~Fix Shod")
end)
