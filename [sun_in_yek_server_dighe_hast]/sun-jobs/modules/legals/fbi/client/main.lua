-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local isback = nil
local cd = false
local hex = nil
local vehBlips = {}
local joblist = {
	"police",
	"sheriff",
	"mt",
	"mechanic",
	"taxi",
	"ambulance",
	"weazel",
	'fbi',
	'justice',
	'detective',
	--"open house",
}

local function OpenJobAccess(data)
	local List = {}
	local jobdata = data.data
	local grade = data.grade or 1
	for k , v in pairs(joblist) do
		local label = (jobdata[v] == true and "✔️" or "❌")
		table.insert(List,{
			img = 'SS_gold.png',
			text = v,
			text2 = label,
			callBack = function()
				if jobdata[v] then
					jobdata[v] = false
				else
					jobdata[v] = true
				end
				OpenJobAccess(data)
		end})
	end
	table.insert(List,{
		img = 'SS_gold.png',
		text = 'Grade : ' .. grade ,
		text2 = grade,
		callBack = function()
			ESX.UI.Menu.Open(
			'dialog',
			GetCurrentResourceName(),
			'grade',
			{
				title = "Grade ra vared konid"
			},
			function(data1,menu1)
				menu1.close()
				if tonumber(data1.value) and tonumber(data1.value) > 0 and tonumber(data1.value) <= 13 then
					data.grade = data1.value
					exports.icon_menu:ForceCloseMenu()
					OpenJobAccess(data)
				end
			end, function(data1,menu1)
				menu1.close()
			end)

	end})
	table.insert(List,{
		img = 'SS_gold.png',
		text = 'Submit ✔️',
		text2 = '',
		callBack = function()
			TriggerServerEvent('fbi:Update',data)
			exports.icon_menu:ForceCloseMenu()
			Citizen.Wait(1000)
			ExecuteCommand('fbimenu')
	end})
	table.insert(List,{
		img = 'SS_gold.png',
		text = 'Delete ❌',
		text2 = '',
		callBack = function()
			TriggerServerEvent('fbi:Delete',data)
			exports.icon_menu:ForceCloseMenu()
			Citizen.Wait(1000)
			ExecuteCommand('fbimenu')
	end})
	exports.icon_menu:OpenMenu(List)
end

local function AddFbi()
	local List = {}
	table.insert(List,{
		img = 'SS_gold.png',
		text = (hex == nil and 'Enter hex' or 'Hex : '.. hex),
		text2 = '',
		callBack = function()
			ESX.UI.Menu.Open(
			'dialog',
			GetCurrentResourceName(),
			'enterhex',
			{
				title = "Hex ra vared konid"
			},
			function(data1,menu1)
				menu1.close()
				if data1.value then
					hex = data1.value
				end
				exports.icon_menu:ForceCloseMenu()
				AddFbi()
			end, function(data1,menu1)
				menu1.close()
			end)
	end})
	table.insert(List,{
		img = 'SS_gold.png',
		text = 'Submit',
		text2 = '',
		callBack = function()
			if hex == nil then
				ESX.Alert('error','Shoma hich hexi ra vared nakardid',5000,'error')
			else
				--
				TriggerServerEvent('fbi:Add',hex)
				exports.icon_menu:ForceCloseMenu()
				hex = nil
			end
	end})
	exports.icon_menu:OpenMenu(List)
end

RegisterNetEvent('fbi:notifyp', function(message, passedJob,share)
    if ESX.PlayerData.job.name == passedJob then
        if share then
            TriggerEvent('chat:addMessage', { color = {0, 95, 254}, multiline = true, args = {"[DISPATCH SHARE]", message}}, 'dispatch')
        else
            TriggerEvent('chat:addMessage', { color = {0, 95, 254}, multiline = true, args = {"[DISPATCH]", message}}, 'dispatch')
        end
    end
end)

RegisterNetEvent('fbi:playSound', function(file, volume, passedJob,ext)
	if ext then ExecuteCommand("resp ".. ext) end
	if not passedJob then
		if ESX.PlayerData.job.name == "fbi" then
			TriggerEvent('InteractSound_CL:PlayOnOne', file, volume)
		end
	else
		if ESX.PlayerData.job.name == passedJob then
			TriggerEvent('InteractSound_CL:PlayOnOne', file, volume)
		end
	end
end)


RegisterNetEvent('fbi:respcall', function(source,data)
	if ESX.PlayerData.job.name == "fbi" then
		local ped = GetPlayerPed(GetPlayerFromServerId(source))
		if ped == PlayerPedId then return end
		--   local coords
		local color
		if DoesEntityExist(ped) then
			local coords = data.coords
			SetNewWaypoint(coords.x,coords.y)
			SetNewWaypoint(coords.x,coords.y)
		end
	end
end)

RegisterNetEvent('fbi:addback', function(source,data)
	if ESX.PlayerData.job.name == "fbi" then
		local ped = GetPlayerPed(GetPlayerFromServerId(source))
		if ped == PlayerPedId then return end
		--   local coords
		local color
		if DoesEntityExist(ped) then
			isback = data.coords
			Citizen.SetTimeout(17000,function()
				isback = nil
			end)
		end
	end
end)

AddEventHandler('KeyDown:e',function()
	if isback ~= nil then
		SetNewWaypoint(isback.x,isback.y)
		SetNewWaypoint(isback.x,isback.y)
	end
end)

RegisterNetEvent('OpenFbiMenu',function(data)
	local List = {}
	table.insert(List,{
		img = 'SS_gold.png',
		text = 'Add',
		text2 = '',
		callBack = function()
			exports.icon_menu:ForceCloseMenu()
			AddFbi()
	end})
	for k , v in pairs(data) do
		table.insert(List,{
			img = 'human.png',
			text = v.name,
			text2 = '',
			callBack = function()
				exports.icon_menu:ForceCloseMenu()
				OpenJobAccess(v)
		end})
	end
	exports.icon_menu:OpenMenu(List)
end)

RegisterNetEvent('findPlate',function(plate)
	if not cd then
		cd = true
		exports['sun-animmenu']:PlayEmote('tablet',true)
		TriggerEvent('mythic_progbar:client:progress', {
			name = 'findPlate',
			duration = 30000,
			label = '',
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
				ESX.TriggerServerEvent('findPlate',plate)
				Citizen.CreateThread(function()
					local try = 0
					while try < 12 do
						try = try + 1
						ESX.TriggerServerEvent('findPlate', plate, true)
						Wait(5000)
					end
				end)
			end
			cd = false
		end)
	end
end)

RegisterNetEvent('fbijob:addVehicleBlip',function(coords, plate)
	if vehBlips[plate] then
		ESX.removeBlip(vehBlips[plate])
	end
	local blip = ESX.AddBlipForCoord(coords, 1.0, 225, 1, plate)
	SetNewWaypoint(coords.x,coords.y)
	vehBlips[plate] = blip
	SetTimeout(60000,function()
		ESX.removeBlip(blip)
	end)
end)

RegisterNetEvent('findNumber',function(number)
	if not cd then
		cd = true
		exports['sun-animmenu']:PlayEmote('tablet',true)
		TriggerEvent('mythic_progbar:client:progress', {
			name = 'findNumber',
			duration = 3000,
			label = '',
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
				ESX.TriggerServerEvent('findNumber',number)
			end
			cd = false
		end)
	end
end)

RegisterNetEvent('fbijob:addNumberBlip',function(coords, number)
	local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 20.0)
    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 48)
    SetBlipAlpha(blip, 100)
    SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(number)
	EndTextCommandSetBlipName(blip)
	SetTimeout(60000,function()
		ESX.removeBlip(blip)
	end)
end)

RegisterNetEvent('fbi:showReg', function(gang)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'ask',
	{
		title 	 = 'Taghir name',
		align    = 'center',
		question = 'Aya mikhahid dar azaye 200TC ?',
		elements = {
			{label = 'Bale', value = 'yes'},
			{label = 'Kheir', value = 'no'},
		}
	}, function(data, menu)
		ESX.UI.Menu.CloseAll()
		ESX.TriggerServerEvent('fbi:reg', data.current.value == 'yes')
	end)
end)
