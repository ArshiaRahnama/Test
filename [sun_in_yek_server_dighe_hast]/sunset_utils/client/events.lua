-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa


local lastVehicle = nil
local isDriver = false
local lastWeapon = nil

Citizen.CreateThread(function()
	local unarmed = `weapon_unarmed`
	TriggerEvent('chat:addSuggestion', '/autolock', 'Jahat on/off kardan halat auto lock', {
    })
	while true do
		waitForLoad()
		Citizen.Wait(100)
		local vehicle = SUN.VehiclePlayerIsIn
		if DoesEntityExist(vehicle) then
			if lastVehicle ~= vehicle then
				TriggerEvent('exitVehicle', lastVehicle, true)
				Wait(50)
				lastVehicle = vehicle
				TriggerEvent('enterVehicle', SUN.VehiclePlayerIsIn, SUN.PlayerIsDriver)
				if SUN.PlayerIsDriver then
					isDriver = true
				end
			else
				if not isDriver and SUN.PlayerIsDriver then
					isDriver = true
					TriggerEvent('enterVehicle', SUN.VehiclePlayerIsIn, true)
				elseif isDriver and not SUN.PlayerIsDriver then
					TriggerEvent('exitVehicle', SUN.VehiclePlayerIsIn, true)
					isDriver = false
				end
			end
		else
			if lastVehicle then
				TriggerEvent('exitVehicle', lastVehicle,isDriver)
				if isDriver then
					isDriver = false
				end
				lastVehicle = nil
			end
		end

		--select weapon
		if SUN.CurrentWeaponModel ~= lastWeapon then
			TriggerEvent('onSelectWeapon', SUN.CurrentWeaponModel ~= unarmed, SUN.CurrentWeaponModel, ESX.GetWeaponName2(SUN.CurrentWeaponModel), lastWeapon)
			lastWeapon = SUN.CurrentWeaponModel
		end
	end
end)

local wThread = false
AddEventHandler('enterVehicle',function(vehicle,iD)
	if iD and GetResourceKvpInt("disableAutoLock") == 0 then
		wThread = true
		local gerefte = 0
		while wThread do
			Citizen.Wait(1000)
			local lock = GetVehicleDoorLockStatus(vehicle)
			if lock == 1 or lock == 0 then
				if IsControlPressed(0,32) then
					gerefte = gerefte + 1
				end
				if gerefte >= 3 then
					gerefte = 0
					exports['sunset_utils']:ManageLock()
					Citizen.Wait(1000)
					local lock = GetVehicleDoorLockStatus(vehicle)
					if lock == 1 or lock == 0 then
						break
					else
						Citizen.Wait(2000)
					end
				end
			end
		end
	end
end)

AddEventHandler('exitVehicle',function(vehicle,iD)
	wThread = false
end)

RegisterCommand('autolock',function()
    if GetResourceKvpInt("disableAutoLock") == 0 then
        SetResourceKvpInt("disableAutoLock",1)
        ESX.ShowNotification('Halat auto lock off shod')
    else
        SetResourceKvpInt("disableAutoLock",0)
        ESX.ShowNotification('Halat auto lock on shod')
    end
end)