local InStreet = false
local inVeh = false
local vehicle = 0
local lastveh = 0
local count = 0
AntiOffroad = false
AntiTireLimit = true
local limit = {
	[1] = 16.88,
	[2] = 8.46,
	[3] = 3.05,
	[4] = 1.0,
}
local whitelist = {
    [`raptor150`] = true,
    [`n17`] = true,
    [`TRX`] = true,
    [`dubsta3`] = true,
    [`Yosemite3`] = true,
    [`blazer`] = true,
    [`sanchez`] = true,
    [`sanchez2`] = true,
    [`manchez`] = true,
    [`bf400`] = true,
    [`bifta`] = true,
    [`brawler`] = true,
    [`caracara2`] = true,
    [`caracara`] = true,
    [`guardian`] = true,
    [`trophytruck2`] = true,
    [`frs`] = true,
    [`trophytruck`] = true,
    [`sandking`] = true,
    [`riata`] = true,
    [`rebel2`] = true,
    [`bfinjection`] = true,
    [`kamacho`] = true,
    [`mesa3`] = true,
    [`contender`] = true,
    [`so`] = true,
    [`pmso`] = true,
    [`polkch`] = true,
    [`shacara`] = true,
    [`Marauder`] = true,
    [`bodhi2`] = true,
    [`sunsetoffpride`] = true,
    [`enduro`] = true,
    [`faction3`] = true,
    [`Outlaw`] = true,
    [`Everon`] = true,

    [`youga`] = true,

    [`rubble`] = true,
    [`benson`] = true,
    [`youga2`] = true,

    [`riot`] = true,
    [`riot2`] = true,
    [`1200RT`] = true,
    [`Africat`] = true,
    [`insurgent2`] = true,
    [`policeb1`] = true,
    [`rumpo3`] = true,
    [`nh2r`] = true,
}

local semiOffroad = {

    [`fq2`] = 60,
    [`granger`] = 60,
    [`gresley`] = 60,
    [`huntley`] = 60,
    [`landstalker`] = 60,
    [`mesa`] = 60,
    [`patriot`] = 60,
    [`baller2`] = 60,
    [`baller3`] = 60,
    [`cavalcade2`] = 60,
    [`dubsta`] = 60,
    [`dubsta2`] = 60,
    [`radi`] = 60,
    [`rocoto`] = 60,
    [`seminole`] = 60,
    [`xls`] = 60,

    [`ruffian`] = 60,
    [`vader`] = 60,
    [`nemesis`] = 60,
    [`pcj`] = 60,
    [`urus`] = 60,
    [`g65`] = 60,
    [`lex`] = 60,
    [`bmwg07`] = 60,
    [`bison`] = 60,
    [`bobcatxl`] = 60,
    [`maz`] = 60,
    [`rmodx6`] = 60,
    [`rsq8m`] = 60,
    [`sclkuz`] = 60,
    [`Hellion`] = 60,
    [`novak`] = 60,
    [`toros`] = 60,
    [`Vagrant`] = 60,

    [`mdoff2`] = 60,
    [`POLREB`] = 60,
    [`POLROS`] = 60,
    [`taxio`] = 60,
    [`stelvio`] = 60,
    [`transmbv`] = 60,
    [`phantom`] = 60,
}

Citizen.CreateThread(function()
	local lastVehicle = nil
	local isDriver = false
	while true do
		Citizen.Wait(500)
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		local PlayerIsDriver = GetPedInVehicleSeat(vehicle, -1) == PlayerPedId()
		if DoesEntityExist(vehicle) then
			if lastVehicle ~= vehicle then
				lastVehicle = vehicle
				TriggerEvent('enterVehicle', vehicle, PlayerIsDriver)
				if PlayerIsDriver then
					isDriver = true
				end
			else
				if not isDriver and PlayerIsDriver then
					isDriver = true
					TriggerEvent('enterVehicle', vehicle, true)
				elseif isDriver and not PlayerIsDriver then
					TriggerEvent('exitVehicle', vehicle, true)
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
	end
end)

AddEventHandler('exitVehicle',function()
    inVeh = false
	SetPlayerCanDoDriveBy(PlayerId(), true)
end)

if AntiTireLimit then
	Citizen.CreateThread(function()
		while true do
			Wait(500)
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(ped, false)
			if vehicle ~= 0 then
				if GetPedInVehicleSeat(vehicle, -1) == ped then
					Citizen.CreateThread(function()
						while GetVehiclePedIsIn(ped, false) == vehicle do
							Wait(100)
							count = 0
							if IsVehicleTyreBurst(vehicle, 0, false) then
								count = count + 1
							end

							if IsVehicleTyreBurst(vehicle, 1, false)  then
								count = count + 1
							end

							if IsVehicleTyreBurst(vehicle, 4, false) then
								count = count + 1
							end

							if IsVehicleTyreBurst(vehicle, 5, false) then
								count = count + 1
							end
							if limit[count] then
								if ( count >= 1  ) then
									SetEntityMaxSpeed(vehicle, limit[count])
									if ( count == 4) then
										SetVehicleEngineOn(vehicle, false, false, true)
									end
								end
							end
						end
					end)
				end
			end
		end
	end)
end
AddEventHandler('enterVehicle',function(_,isDriver)
    vehicle = _
    if isDriver then
        if not inVeh then
            inVeh = true
			if AntiOffroad then
				Citizen.CreateThread(function()
					local speed = 100
					local changed = false
					local timer = 0
					local baseSpeed = 0
					local neg = 0
					local maxSpeed__ = getMaxSpeedInOffroad(GetEntityModel(vehicle))
					while inVeh do
						Citizen.Wait(1000)
						local materialId = GetVehicleWheelSurfaceMaterial(vehicle, 1)
						if materialId == 4 or materialId == 1 or materialId == 3 then
							timer = 0
							InStreet = true
							if changed then
								changed = false
								neg = 0
								baseSpeed = 0
								maxSpeed = GetVehicleHandlingFloat(vehicle,"CHandlingData","fInitialDriveMaxFlatVel")
								SetEntityMaxSpeed(vehicle,maxSpeed)
							end
						else
							InStreet = false
							if (not IsPedInAnyBoat(PlayerPedId()) and not IsPedInAnyPlane(PlayerPedId()) and not IsPedInAnyHeli(PlayerPedId())) and not whitelist[GetEntityModel(vehicle)] then
								if GetEntitySpeed(vehicle) * 3.6 >= 10 then
									if timer >= 2 then
										changed = true
										if baseSpeed == 0 then
											baseSpeed = GetEntitySpeed(vehicle) * 3.6
											neg = (baseSpeed / 10)
										end
										if baseSpeed > maxSpeed__ then
											baseSpeed = baseSpeed - neg
											if baseSpeed < maxSpeed__ then
												baseSpeed = maxSpeed__
											end
										else
											baseSpeed = maxSpeed__
										end
										if count >= 3 and InStreet == false then
											SetEntityMaxSpeed(vehicle, limit[count])
										else
											SetEntityMaxSpeed(vehicle,baseSpeed / 3.6)
										end
									else
										timer = timer + 1
									end
								end
							end
						end

					end
				end)
			end
        end
    end
	if isDriver then
		SetPlayerCanDoDriveBy(PlayerId(), false)
	end
end)

function getMaxSpeedInOffroad(hash)
    return whitelist[hash] and 1000 or semiOffroad[hash] or 25
end

exports('getMaxSpeedInOffroad', getMaxSpeedInOffroad)

