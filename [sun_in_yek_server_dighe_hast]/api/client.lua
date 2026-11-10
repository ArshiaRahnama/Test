-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	TriggerEvent('chat:addSuggestion', '/getcode', 'Daryaft code verify site **mohem! in code ra be kasi nadid**', {
	})
end)
local coords = vector3(407.16,-587.12,28.71)
local coords2 = vector3(-40.31,-1098.51,26.42)
local starttimer = 0
local run = false
local typecoords = {
	["car"] = {coords = vector3(407.16,-587.12,28.71), head = 327.32},
	["heli"] = {coords = vector3(-75.1,-818.81,326.18), head = 327.32},
	["boat"] = {coords = vector3(-774.92,-1410.7,0), head = 143.22},
	["aircraft"] = {coords = vector3(-997.19,-3340.12,13.94), head = 58.56},
}
local tId = 0
RegisterNetEvent('testveh')
AddEventHandler('testveh',function(name,mcar,type)
	ESX.Game.Teleport(PlayerPedId(),typecoords[type].coords)
	ESX.Game.SpawnLocalVehicle(name, typecoords[type].coords, typecoords[type].head , function(vehicle)
		_vehicle = vehicle
		ESX.setVehicleFuel(vehicle,200.0)
		local colors = {a = 0, b = 0, c = 0}
		TaskWarpPedIntoVehicle(PlayerPedId(),  vehicle, -1)
		if mcar then
			 SetVehicleMaxMods(vehicle, true, colors)
		end
		TriggerEvent('esx:createvehiclekey')
		run = true
		tId = ESX.SetTimeout(120000,function()
			if not run then return end
			ESX.Game.DeleteVehicle(_vehicle)
			ESX.Game.Teleport(PlayerPedId(),coords2)
			TriggerServerEvent('api:backme')
			ESX.ClearTimeout(tId)
			starttimer = 0
			run = false
		end)
		starttimer = 120
		Citizen.CreateThread(function()
			while run do
				Wait(0)
				if not IsPedInAnyVehicle(PlayerPedId(),_vehicle) and run then
					run = false
					ESX.Game.DeleteVehicle(_vehicle)
					ESX.Game.Teleport(PlayerPedId(),coords2)
					TriggerServerEvent('api:backme')
					Wait(5000)
					TriggerEvent('medic:revive')
					ESX.ClearTimeout(tId)
					starttimer = 0
					break
				end
				if starttimer ~= 0 then
					Draw('End test : '.. starttimer.. 's',255,0,0,0.01,0.4)
				else	
					break
				end
			end
		end)
		timer()
	end)
end)

function timer()
	Citizen.CreateThread(function()
		while starttimer > 0 and run do
			Wait(1000)
			starttimer = starttimer - 1
		end
	end)
end

function SetVehicleMaxMods(vehicle, turbo, colors)

        local props = {
            modEngine       =   3,
            modBrakes       =   2,
            windowTint      =   1,
            modArmor        =   4,
            modTransmission =   2,
            modSuspension   =   -1,
            modTurbo        =   turbo,
            modXenon     = true,
            color1 = colors.a,
            color2 = colors.b,
            pearlescentColor = colors.c
        }
            
    ESX.Game.SetVehicleProperties(vehicle, props)
	ESX.Game.SetVehicleProperties(vehicle, {
        modSuspension =  GetNumVehicleMods(vehicle, 15)-1,
    })

end
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

