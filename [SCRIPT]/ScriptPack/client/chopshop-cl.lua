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

ESX                           = nil
local near = {active = false}
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	DecorRegister("chop",2)
	DecorRegister("choped",2)
	_RequestModel(ChopConfig.craftped)
	local ped = CreatePed(4, ChopConfig.craftped,ChopConfig.craftcoords.coords, ChopConfig.craftcoords.head)
	SetEntityAsMissionEntity(ped)
	SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
	SetModelAsNoLongerNeeded(ChopConfig.craftped)
end)

_RequestModel = function(hash)
    if type(hash) == "string" then hash = GetHashKey(hash) end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
end

Citizen.CreateThread(function()










	for k ,v in ipairs(ChopConfig.Chopshops) do
		local blip = AddBlipForCoord(v)
		SetBlipSprite (blip, 89)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.7)
		SetBlipColour (blip, 57)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Chop shop')
		EndTextCommandSetBlipName(blip)
	end
end)

local craft = false
local chop = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if near.active then
			local coords = GetEntityCoords(PlayerPedId())
			if near.chie == 'craft' then
				if Vdist(ChopConfig.craftcoords.coords, coords) < 2.0 then
					craft = true
					ESX.ShowHelpNotification('Dokme ~INPUT_CONTEXT~ jahat craft lockpick')
				elseif craft then
					craft = false
					ESX.UI.Menu.CloseAll()
				end
			elseif near.chie == 'chop' then
				DrawMarker(near.type, near.coords.x, near.coords.y, near.coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, near.size.x, near.size.y, near.size.z, near.color.r, near.color.g, near.color.b, 100, false, true, 2, false, false, false, false)
				if Vdist(near.coords,coords) < 2.0 then
					chop = true
					ESX.ShowHelpNotification('Dokme ~INPUT_CONTEXT~ jahat shoroe chop shop')
				elseif chop then
					chop = false
					ESX.UI.Menu.CloseAll()
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function NearAny()
    local coords = GetEntityCoords(PlayerPedId())
	if Vdist(ChopConfig.craftcoords.coords, coords) < ChopConfig.DrawDistance then
		near = {active = true, chie = 'craft' , coords = vector3(ChopConfig.craftcoords.coords.x, ChopConfig.craftcoords.coords.y, ChopConfig.craftcoords.coords.z + 2.5), type = 32, size = ChopConfig.MarkerSize2, color = ChopConfig.MarkerColor }
		return
	end
	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(ped, false)
	if vehicle ~= 0 then
		if GetPedInVehicleSeat(vehicle, -1) == ped then
			local coords = GetEntityCoords(PlayerPedId())
			for k , v in ipairs(ChopConfig.Chopshops) do
				local distance = Vdist(v, coords)
				if distance < 50 then
					near = {active = true, chie = 'chop' , coords = v, type = 6, size = ChopConfig.MarkerSize, color = ChopConfig.MarkerColor }
					return
				end
			end
		end
	end
	craft = false
	chop = false
    near = {active = false}
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        NearAny()
    end
end)

AddEventHandler('onKeyDown',function(key)
	if key == "e" then
		if craft then
			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'menu',
				{
					title = 'Craft',
					align = 'top-left',
					elements = {
						{label = '⛏️Craft menu',  value = 'craftmenu'},
						{label = '💸Buy menu',  value = 'buymenu'},
						{label = '💰Sell menu',  value = 'sellmenu'},
					}
				},
				function(data, menu)
					menu.close()
					if data.current.value == 'craftmenu' then
						craftmenu()
					elseif data.current.value == 'buymenu' then
						buymenu()
					elseif data.current.value == 'sellmenu' then
						sellmenu()
					end
			end, function(data, menu)
				menu.close()
			end)
		elseif chop then
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(ped, false)
			if vehicle ~= 0 then
				if ESX.GetPlayerData().World == 97 then return ESX.ShowNotification('Shoma nemitavanid dar in world chop shop konid!') end
				if GetPedInVehicleSeat(vehicle, -1) == ped then
					local plate = GetVehicleNumberPlateText(vehicle)
					ESX.TriggerServerCallback('carlock:isVehicleowned',function(can)
						if can then
							ESX.TriggerServerCallback('choped',function(choped)
								if choped then
									ESX.ShowNotification('In mashin ghablan oragh shode ast')
								else
									if DecorGetBool(vehicle,"chop") then return end
									ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'ask',
									{
									title 	 = 'Oragh kardan',
									align    = 'center',
									question = 'Aya mikhahid in mashin oragh shavad?',
									elements = {
										{label = 'Bale', value = 'yes'},
										{label = 'Kheir', value = 'no'},
									}
									}, function(data, menu)
										if data.current.value == 'yes' then
											local near = false
											local coords = GetEntityCoords(PlayerPedId())
											for k , v in ipairs(ChopConfig.Chopshops) do
												local distance = Vdist(v, coords)
												if distance < 10 then
													near = true
												end
											end
											if not near then
												return menu.close()
											end

											ESX.UI.Menu.CloseAll()
											DecorSetBool(vehicle,"chop",true)
											FreezeEntityPosition(vehicle,true)
											TaskLeaveVehicle(GetPlayerPed(-1), vehicle, 0)


											local time = ChopConfig.choptime
											if GetResourceState('sun-jobs') == 'started' then
												local ok, hasInsurance = pcall(function()
													return exports['sun-jobs']:getVehicleInsuranceData(vehicle)
												end)
												if ok and hasInsurance then
													time = 240
												end
											end
											Citizen.CreateThread(function()
												while time > 0 do
													Wait(1)
													local vehpos = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 0.0, 2.0)
													ESX.Game.Utils.DrawText3D(vector3(vehpos.x, vehpos.y, vehpos.z),"~r~Time left : ".. time,2)
													local lock = GetVehicleDoorLockStatus(vehicle)
													if lock == 1 or lock == 0 then
														local NetId = NetworkGetNetworkIdFromEntity(vehicle)
														TriggerServerEvent("esx_vehiclecontrol:sync", NetId, true)
													end
												end
											end)
											TriggerServerEvent('startchop',VehToNet(vehicle))
											while time > 0 do
												Wait(1000)
												time = time - 1
												if time == 170 then
													SetVehicleBodyHealth(vehicle,0.0)
													SmashVehicleWindow(vehicle, 0)
												elseif time == 150 then
													SmashVehicleWindow(vehicle, 1)
												elseif time == 130 then
													SmashVehicleWindow(vehicle, 2)
												elseif time == 100 then
													SmashVehicleWindow(vehicle, 3)
													SmashVehicleWindow(vehicle, 4)
													SmashVehicleWindow(vehicle, 5)
													SmashVehicleWindow(vehicle, 6)
													SmashVehicleWindow(vehicle, 7)
												elseif time == 80 then
													for i = 0, GetNumberOfVehicleDoors(vehicle) do
														Wait(1000)
														time = time - 1
														SetVehicleDoorBroken(vehicle, i, false)
													end
												elseif time == 20 then
													SetVehicleTyreBurst(vehicle, 0, true, 1000.0)
												elseif time == 25 then
													SetVehicleTyreBurst(vehicle,1, true, 1000.0)
												elseif time == 15 then
													SetVehicleTyreBurst(vehicle, 4, true, 1000.0)
												elseif time == 10 then
													SetVehicleTyreBurst(vehicle, 5, true, 1000.0)
												end
											end



											local finishPlate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))
											TriggerServerEvent('chop:finish', VehToNet(vehicle), finishPlate)
											DecorSetBool(vehicle,"chop",nil)
											SetEntityAsMissionEntity(vehicle, true, true)
											DeleteVehicle(vehicle)
											DeleteEntity(vehicle)
										elseif data.current.value == 'no' then
											menu.close()
											ESX.UI.Menu.CloseAll()
										end
									end)
								end
							end,plate)
						else
							ESX.ShowNotification('In mashin dar takhasos ma nist!')
						end
					end,plate)
				else
					ESX.ShowNotification('Shoma bayad ranande mashin bashid')
				end
			else
				ESX.ShowNotification('Shoma bayad savare mashin bashid')
			end
		end
	end
end)

function craftmenu()
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'craftm',
	{
		title = 'Craft menu',
		align = 'top-left',
		elements = {
			{label = 'Lockpick',  value = 'lock'},
			{label = 'Engine',  value = 'engine'},
		}
	},
	function(data, menu)
		menu.close()
		if data.current.value == 'lock' then
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'craft',
			{
				title = 'Craft lockpick',
				align = 'top-left',
				elements = {
					{label = 'Requirements : ',  value = 'kir'},
					{label = '1x Shah kelid',  value = 'kir'},
					{label = '1x Iron',  value = 'kir'},
					{label = '1x BlowTorch',  value = 'kir'},
					{label = '⛏️Craft!🔑',  value = 'craft'},
				}
			},
			function(data, menu)
				menu.close()
				if data.current.value == 'craft' then
					TriggerServerEvent('chop:craft')
				end
			end, function(data, menu)
				menu.close()
			end)
		elseif data.current.value == 'engine' then
			local elements = {}
			table.insert(elements,{label = 'Select engine model',value = 'kir'})
			table.insert(elements,{label = 'Engine X',name = 'engine',value = 1,type = 'slider',min = 1 , max = 6})
			ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'craft',
			{
				title = 'Craft engine',
				align = 'top-left',
				elements = elements
			},
			function(data, menu)
				menu.close()
				if data.current.name == 'engine' then
					local elements = {}
					local key = data.current.value
					local need = ChopConfig.craftengine[key]
					table.insert(elements,{label = 'Requirements : ',value = 'kir'})
					for k , v in ipairs(need) do
						if v.type == 'money' then
							table.insert(elements,{label = v.count .. '$',value = 'kir'})
						else
							table.insert(elements,{label = v.name .. ' '.. v.count .. 'x',value = 'kir'})
						end
					end
					table.insert(elements,{label = 'Confirm craft',value = 'craft'})
					ESX.UI.Menu.Open(
					'default', GetCurrentResourceName(), 'craft',
					{
						title = 'Craft',
						align = 'top-left',
						elements = elements
					},
					function(data, menu)
						if data.current.value == 'craft' then
							menu.close()
							TriggerServerEvent('chop:craftengine',key)
						end
					end, function(data, menu)
						menu.close()
					end)
				end
			end, function(data, menu)
				menu.close()
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

function buymenu()
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'buy',
	{
		title = 'Craft lockpick',
		align = 'top-left',
		elements = {
			{label = '1x Pich gousti(5000$)',  value = 'pich'},
		}
	},
	function(data, menu)

		if data.current.value == 'pich' then
			TriggerServerEvent('chop:buypich')
		end
	end, function(data, menu)
		menu.close()
	end)
end

function sellmenu()
	local elements = {}
	for k , v in ipairs(ChopConfig.sell) do
		local item = 'engine'..k
		local count = 0
		local PlayerData = ESX.GetPlayerData()
		for i=1, #PlayerData.inventory do
			if PlayerData.inventory[i].name == item then
				count = PlayerData.inventory[i].count
			end
		end
		if count > 0 then
			table.insert(elements,{label = 'Engine X'.. k,value = k})
		end
	end
	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'sell',
	{
		title = 'Sell',
		align = 'top-left',
		elements = elements
	},
	function(data, menu)
		menu.close()
		local key = data.current.value
		local data = ChopConfig.sell[key]
		local elements = {}
		table.insert(elements,{label = 'You get',value = 'kir'})
		for k , v in ipairs(data) do
			if v.type == 'money' then
				table.insert(elements,{label = v.count .. '$',value = 'kir'})
			else
				table.insert(elements,{label = v.name .. ' '.. v.count .. 'x',value = 'kir'})
			end
		end
		table.insert(elements,{label = 'Confirm sell',value = 'sell'})
		ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'sell',
		{
			title = 'Sell',
			align = 'top-left',
			elements = elements
		},
		function(data, menu)
			if data.current.value == 'sell' then
				menu.close()
				TriggerServerEvent('chop:sell',key)
			end
		end, function(data, menu)
			menu.close()
		end)
	end, function(data, menu)
		menu.close()
	end)
end