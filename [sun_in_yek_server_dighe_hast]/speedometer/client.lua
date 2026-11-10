-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local ind = {l = false, r = false}
local ped = PlayerPedId()
local vehData = {handler = false}

Citizen.CreateThread(function()
	while true do
		if vehData.handler and not vehData.pause then
				SendNUIMessage({
					showfuel = true,
					fuel = vehData.fuel
				})

				-- Lights
				_,feuPosition,feuRoute = vehData.lights
				if(feuPosition == 1 and feuRoute == 0) then
					SendNUIMessage({
						feuPosition = true
					})
				else
					SendNUIMessage({
						feuPosition = false
					})
				end

				if(feuPosition == 1 and feuRoute == 1) then
					SendNUIMessage({
						feuRoute = true
					})
				else
					SendNUIMessage({
						feuRoute = false
					})
				end

				-- Turn signal
				-- SetVehicleIndicatorLights (1 left -- 0 right)
				local VehIndicatorLight = vehData.indicator

				if(VehIndicatorLight == 0) then
					SendNUIMessage({
						clignotantGauche = false,
						clignotantDroite = false,
					})
				elseif(VehIndicatorLight == 1) then
					SendNUIMessage({
						clignotantGauche = true,
						clignotantDroite = false,
					})
				elseif(VehIndicatorLight == 2) then
					SendNUIMessage({
						clignotantGauche = false,
						clignotantDroite = true,
					})
				elseif(VehIndicatorLight == 3) then
					SendNUIMessage({
						clignotantGauche = true,
						clignotantDroite = true,
					})
				end
		else
			SendNUIMessage({
				showhud = false
			})
		end

		Citizen.Wait(1000)

	end
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped)
		if vehicle > 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
			vehData = {
				handler = vehicle,
				fuel = exports.sunset_utils:GetFuel(vehicle),
				lights = GetVehicleLightsState(vehicle),
				indicator = GetVehicleIndicatorLights(vehicle),
				pause = IsPauseMenuActive()
			}
		else
			vehData = {handler = false}
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		if vehData.handler and not vehData.pause then
			Citizen.Wait(250)
			carSpeed = math.ceil(GetEntitySpeed(vehData.handler) * 3.6)
			SendNUIMessage({
				showhud = true,
				speed = carSpeed
			})
		else
			Citizen.Wait(1000)
		end
	end
end)