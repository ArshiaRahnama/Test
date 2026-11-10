-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local isBusy = false
local ems = {}
local carblip = 0
local drawInD = false

exports('isBusyMedic', function()
	return isBusy
end)

local function openRequst(id)
	ESX.TriggerServerCallback('medic:getemslist', function(data)
		ems = data
		elements = {}
		emoji = "❌"
		if ems[id].accept then
			emoji = "✔️"
		end
		table.insert(elements,{label = "Id : ".. ems[id].source,value = "no"})
		table.insert(elements,{label = "Accept status : ".. emoji,value = "no"})
		if ems[id].robId then
			table.insert(elements,{label = ('Robbery : %s(%s)'):format(ems[id].robName, ems[id].robId),value = "no"})
		end
		if ems[id].accept then
			table.insert(elements,{label = "Accepted by : ".. ems[id].acceptername,value = "no"})
		else
			table.insert(elements,{label = "Accept",value = "accept"})
		end
		if ems[id].acceptersource == GetPlayerServerId(PlayerId()) then
			table.insert(elements,{label = "Carry",value = "carry"})
			table.insert(elements,{label = "Decline",value = "decline"})
		end
		table.insert(elements,{label = "Pin location",value = "pin"})
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list2', {
			title    = _U(Shared.ambulance.Locale, 'ems_menu_title'),
			align    = 'top-left',
			elements = elements
		}, function(data2, menu2)
			if data2.current.value == "accept" then
				local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
				TriggerServerEvent('medic:accept',id,mugshotStr)
				openRequst(id)
			elseif data2.current.value == "decline" then
				TriggerServerEvent('medic:decline',id)
				openRequst(id)
			elseif data2.current.value == "pin" then
				ESX.TriggerServerCallback('getplayercoords', function(coords)
					if coords ~= nil then
						SetNewWaypoint(coords.x,coords.y)
						SetNewWaypoint(coords.x,coords.y)
					end
				end,ems[id].source)
			elseif data2.current.value == "carry" then
				ESX.TriggerServerCallback('getplayercoords', function(coords)
					if coords ~= nil and not isBusy then
						local distance = ESX.GetDistance(coords,GetEntityCoords(PlayerPedId()))
						if distance < 50 then
							ESX.TriggerServerEvent('medic:carry',ems[id].source)
							Citizen.SetTimeout(1000,function()
								ExecuteCommand('carry')
							end)
						else
							ESX.ShowNotification('Fard mored nazar az shoma door ast!')
						end
					end
				end,ems[id].source)
			end
		end, function(data2, menu2)
			menu2.close()
			openMedicRequest()
		end)
	end)
end

function openMedicRequest()
	ESX.TriggerServerCallback('medic:getemslist', function(data)
		ems = data
		local lenth = CountTable(ems)
		if lenth == 0 then
			ESX.ShowNotification('Hich darkhasti vojoud nadarad')
		else
			elements = {}
			for k , v in ipairs(ems) do
				if v and v.show then
					emoji = "❌"
					if v.accept then
						emoji = '<span style="color:green;">' .. v.acceptersource .. '</span>'
					end
					table.insert(elements,{label = "Request id : ".. v.source .. " | Accept : ".. emoji .. ' | Distance : '.. ESX.Math.Round(ESX.GetDistance(GetEntityCoords(PlayerPedId()),v.coords)),value = k})
					wait = false
				end
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list', {
				title    = _U(Shared.ambulance.Locale, 'ems_menu_title'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu)
				menu.close()
				local id = tonumber(data2.current.value)
				openRequst(id)
			end, function(data2, menu)
				menu.close()
			end)
		end
	end)
end

RegisterNetEvent('medic:openAdmin',function()
	ESX.TriggerServerCallback('medic:getemslist', function(data)
		ems = data
		local lenth = CountTable(ems)
		if lenth == 0 then
			ESX.ShowNotification('Hich darkhasti vojoud nadarad')
		else
			elements = {}
			for k , v in ipairs(ems) do
				emoji = "❌"
				if v.accept then
					emoji = '<span style="color:green;">' .. v.acceptersource .. '</span>'
				end
				local wait = true
				ESX.TriggerServerCallback('getplayercoords', function(coords)
					table.insert(elements,{label = "Request id : ".. v.source .. " | Accept : ".. emoji .. ' | Distance : '.. ESX.Math.Round(ESX.GetDistance(GetEntityCoords(PlayerPedId()),coords)),value = k})
					wait = false
				end,v.source)
				while wait do Wait(10) end
			end
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ems_list', {
				title    = _U(Shared.ambulance.Locale, 'ems_menu_title'),
				align    = 'top-left',
				elements = elements
			}, function(data2, menu)
				menu.close()
				local id = tonumber(data2.current.value)
				openRequst(id)
			end, function(data2, menu)
				menu.close()
				openMedicRequest()
			end)
		end
	end)
end)

RegisterNetEvent('medic:addems',function(id,coords,mug,name)
	local id = id
	if carblip ~= 0 then
		RemoveBlip(carblip)
		carblip = 0
	end
	Wait(2000)
	carblip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(carblip, 198)
	SetBlipFlashes(carblip, true)
	SetBlipColour(carblip,1)
	SetBlipFlashTimer(carblip, 5000)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Ambulance nurse')
	EndTextCommandSetBlipName(carblip)
	while carblip ~= 0 do
		Wait(1000)
		ESX.TriggerServerCallback('getplayercoords', function(coords)
			if coords ~= nil then
				SetBlipCoords(carblip, coords.x, coords.y, coords.z)
			else
				RemoveBlip(carblip)
				carblip = 0
			end
		end,id)
		ESX.ShowAdvancedNotification(name, '~g~Dar rah ast~s~', 'Lotfan sabur bashid', mug, 7)
	end
end)

RegisterNetEvent('medic:deleteblip',function()
	if carblip ~= 0 then
		RemoveBlip(carblip)
		carblip = 0
	end
end)


RegisterNetEvent('medic:acceptq',function(id)
	local elements = {
		{label = 'Bale', value = true},
		{label = 'Kheyr', value = false},
	}
	ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'a' .. id,
	{
		title 	 = 'Darkhast jadid!',
		align    = 'center',
		question = 'Aya mayel be ghabul kardan darkhast hastid?',
		elements = elements
	}, function(data, menu)
		menu.close()
		if data.current.value then
			local mugshot, mugshotStr = ESX.Game.GetPedMugshot(PlayerPedId())
			TriggerServerEvent('medic:accept',id,mugshotStr)
			ExecuteCommand('f Darkhast ' .. id .. ' accept shod!')
		else
			ExecuteCommand('f Darkhast ' .. id .. ' reject shod!')
		end
	end)
	Citizen.SetTimeout(10000,function()
		if ESX.UI.Menu.IsOpen('question',GetCurrentResourceName(),'a' .. id) then
			ESX.UI.Menu.Close('question',GetCurrentResourceName(), 'a' .. id)
			ExecuteCommand('f Darkhast ' .. id .. ' be dalil AFK reject shod!')
		end
	end)
end)

RegisterNetEvent('medic:acceptKarde',function()
	if not drawInD then
		drawInD = true
		reqid = 0
		local robId
		Citizen.CreateThread(function()
			while drawInD do
				Citizen.Wait(0)
				if robId then
					ESX.ShowMissionText(('~y~Request in progress(%s - Robbery %s)'):format(reqid, robId))
				else
					ESX.ShowMissionText(('~y~Request in progress(%s)'):format(reqid))
				end
			end
		end)
		Citizen.CreateThread(function()
			while drawInD do
				local bedeBezanim = false
				ESX.TriggerServerCallback('medic:getemslist', function(data)
					ems = data
					for k , v in ipairs(ems) do
						if v.acceptersource and v.acceptersource == GetPlayerServerId(PlayerId()) then
							bedeBezanim = true
							reqid = v.source
							robId = v.robId
						end
					end
					if not bedeBezanim then
						drawInD = false
					end
				end)
				Citizen.Wait(10000)
			end
		end)
	end
end)

local function revive()
	ESX.selectPlayerMenu(function(src)
		local player = GetPlayerFromServerId(src)
		if ESX.GetPlayerState(src, 'reviving') then
			ESX.ShowNotification('Fard mored nazar dar hale revive ast')
		elseif not isBusy then
			isBusy = true
			if ESX.DoesHaveItem2('medikit', 1) then
				ESX.TriggerServerCallback('esx:checkemsstatus', function(isDead, isDead2)
					if isDead and not isDead2 then
						LocalPlayer.state.disableEye = true
						local chance = math.random(1,100)
						if chance <= exports['sunset_utils']:getSkillTime('revive_skill', 'success_revive') then
							TriggerServerEvent('medic:mord', src)
							ESX.ShowNotification('Fard mord')
							SUN.log('reviveambulance',"Revive",GetPlayerName(PlayerId()).." (".. GetPlayerServerId(PlayerId()) ..") Die kard : ".. GetPlayerName(player).. " (".. src ..")") 
							SUN.log('job_ambulance_revive',"Revive", GetPlayerName(PlayerId()).." (".. GetPlayerServerId(PlayerId()) ..") Die kard : ".. GetPlayerName(player).. " (".. src ..")") 
							isBusy = false
							LocalPlayer.state.disableEye = nil
						else
							ESX.UI.Menu.CloseAll()
							local ped = PlayerPedId()
							ESX.emoteMenu(false)
							TriggerServerEvent('medic:job:removeItem', 'medikit')
							exports['essentialmode']:disablecontrol('x', true)
							CreateThread(function()
								while isBusy do
									Wait(0)
									disableAction()
								end
							end)
							local inRob = exports['sun-robbery']:doesInRob()
							TriggerServerEvent('medic:job:syncAnim', src, inRob)
							if inRob then
								ESX.Streaming.RequestAnimDict('mini@cpr@char_a@cpr_def', function()
									TaskPlayAnim(ped, 'mini@cpr@char_a@cpr_def', 'cpr_intro', 8.0, 8.0, -1, 1, 0, false, false, false)
									Wait(10000)
									ClearPedTasks(ped)
									exports['essentialmode']:disablecontrol('x')
									TriggerServerEvent('medic:job:revive', src)
									isBusy = false
									LocalPlayer.state.disableEye = nil
									ESX.emoteMenu(true)
								end)
							else
								ESX.Streaming.RequestAnimDict(Shared.ambulance.config.anim.revive.sender.dict1)
								ESX.Streaming.RequestAnimDict(Shared.ambulance.config.anim.revive.sender.dict2, function()
									Wait(500)
									TaskPlayAnim(ped, Shared.ambulance.config.anim.revive.sender.dict1, Shared.ambulance.config.anim.revive.sender.anim1, 8.0, 8.0, -1, 0, 0, false, false, false)
									Wait(15800)
									TaskPlayAnim(ped, Shared.ambulance.config.anim.revive.sender.dict2, Shared.ambulance.config.anim.revive.sender.anim2, 8.0, 8.0, -1, 1, 0, false, false, false)
									Wait(5000)
									TaskPlayAnim(ped, Shared.ambulance.config.anim.revive.sender.dict2, Shared.ambulance.config.anim.revive.sender.anim3, 8.0, 8.0, -1, 0, 0, false, false, false)
									Wait(28600)
									ClearPedTasks(ped)
									exports['essentialmode']:disablecontrol('x')
									TriggerServerEvent('medic:job:revive', src)
									isBusy = false
									LocalPlayer.state.disableEye = nil
									ESX.emoteMenu(true)
								end)
							end

						end
					else
						ESX.ShowNotification('Farde mored nazar niazi be revive nadarad')
						isBusy = false
					end
				end, src)
			else
				ESX.ShowNotification('Shoma medikit nadarad!')
				isBusy = false
			end
		end
	end)
end

RegisterNetEvent('medic:syncAnim', function(sender, inRob)
	if ESX.Game.doesPlayerExist(sender) or DoesEntityExist(sender) then
		local senderPed = DoesEntityExist(sender) and sender or GetPlayerPed(GetPlayerFromServerId(sender))
		local ped = PlayerPedId()
		if isCrawling then
			isCrawling = false
			exports['sunset_utils']:toggleCrawl(true)
			Wait(2000)
		end
		ESX.SetPlayerState('reviving', true)
		if inRob then
			ESX.Streaming.RequestAnimDict('mini@cpr@char_b@cpr_def', function()
				medicPauseAnim = true
				ClearPedTasks(ped)
				AttachEntityToEntity(ped, senderPed, 28422, -0.1, 1.15, 0.0, 0.0, 0.0, 75.0, false, false, false, true, 2, true)
				Wait(500)
				TaskPlayAnim(ped, 'mini@cpr@char_b@cpr_def', 'cpr_intro', 8.0, 8.0, -1, 1, 0, false, false, false)
				Wait(10000)
				DetachEntity(ped, true, false)
				ClearPedTasks(ped)
				ESX.SetPlayerState('reviving', nil)
				medicPauseAnim = false
			end)
		else
			ESX.Streaming.RequestAnimDict(Shared.ambulance.config.anim.revive.reciver.dict1)
			ESX.Streaming.RequestAnimDict(Shared.ambulance.config.anim.revive.reciver.dict2, function()
				medicPauseAnim = true
				ClearPedTasks(ped)
				Wait(1000)
				AttachEntityToEntity(ped, senderPed, 28422, -0.1, 1.15, 0.0, 0.0, 0.0, 75.0, false, false, false, true, 2, true)
				TaskPlayAnim(ped, Shared.ambulance.config.anim.revive.reciver.dict1, Shared.ambulance.config.anim.revive.reciver.anim1, 8.0, 8.0, -1, 0, 0, false, false, false)
				Wait(800)
				DetachEntity(ped, true, false)
				Wait(15000)
				TaskPlayAnim(ped, Shared.ambulance.config.anim.revive.reciver.dict2, Shared.ambulance.config.anim.revive.reciver.anim2, 8.0, 8.0, -1, 1, 0, false, false, false)
				Wait(5000)
				TaskPlayAnim(ped, Shared.ambulance.config.anim.revive.reciver.dict2, Shared.ambulance.config.anim.revive.reciver.anim3, 8.0, 8.0, -1, 0, 0, false, false, false)
				Wait(28600)
				ClearPedTasks(ped)
				ESX.SetPlayerState('reviving', nil)
				medicPauseAnim = false
			end)
		end
	end
end)

local function collectVacium()
	local coords = GetEntityCoords(PlayerPedId())
	local body = GetClosestObjectOfType(coords.x, coords.y, coords.z, 5.0, `xm_prop_body_bag`, false)
	if DoesEntityExist(body) then
		ESX.TriggerServerCallback('medic:GetVaciumData',function(data)
			local coords = GetEntityCoords(PlayerPedId())
			local key = Entity(body).state.key
			if not key or not data[key] then
				ESX.Alert('Error','Hich jasadi dar atraf shoma nist',5000,'error')
			else
				ESX.UI.Menu.CloseAll()
				exports['sun-animmenu']:PlayEmote('medic',true)
				TriggerEvent("mythic_progbar:client:progress", {
					name = "vac",
					duration = math.random(10000,15000),
					label = "Dar hal bardashtan vacium",
					useWhileDead = false,
					canCancel = true,
					controlDisables = {
						disableMovement = true,
						disableCarMovement = true,
						disableMouse = false,
						disableCombat = true,
					},
					animation = nil,
					prop = nil
				}, function(status)
					if not status then
						ESX.TriggerServerEvent('medic:collectvacium',key)
					elseif status then
						ClearPedTasksImmediately(GetPlayerPed(-1))
					end
				end)
			end
		end)
	else
		ESX.Alert('Error','Hich jasadi dar atraf shoma nist',5000,'error')
	end
end

local function heal()
	local can = false
	for k, v in pairs(Shared.ambulance.healLocation) do
		if ESX.GetDistance(GetEntityCoords(PlayerPedId()), v.xyz) <= v.z then
			can = true
		end
	end
	if can then
		if ESX.DoesHaveItem2('bandage', 1) then
			ESX.selectPlayerMenu(function(src)
				ESX.TriggerServerCallback('esx:checkemsstatus', function(isDead, isDead2)
					if not isDead and not isDead2 then
						local player = GetPlayerFromServerId(src)
						local closestPlayerPed = GetPlayerPed(player)
						local health = GetEntityHealth(closestPlayerPed)
						if health > 0 then
							local playerPed = PlayerPedId()
							IsBusy = true
							ESX.ShowNotification('Dar hale bandage kardan...')
							--TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
							exports['sun-animmenu']:PlayEmote('mechanic1',true)
							ESX.emoteMenu(false)
							local canHeal = true
							local check = true
							Citizen.SetTimeout(10000,function()
								check = false
								ESX.emoteMenu(true)
							end)
							while check do
								local coords1 = GetEntityCoords(PlayerPedId())
								if not DoesEntityExist(closestPlayerPed) then return end
								local coords2 = GetEntityCoords(closestPlayerPed)
								if #(coords1 - coords2) > 2 then
									canHeal = false
									ClearPedTasks(PlayerPedId())
									check = false
									break
								end
								Wait(1)
							end
							ClearPedTasks(playerPed)
							if canHeal then
								TriggerServerEvent('medic:job:removeItem', 'bandage')
								TriggerServerEvent('medic:heal', src, 'small')
							end
							IsBusy = false
						else
							ESX.ShowNotification('Vaziat jesmani fard salem ast')
						end
					else
						ESX.ShowNotification('Shoma nemitavanid in fard ra heal konid')
					end
				end, src)
			end)
		else
			ESX.ShowNotification('Shoma bandage nadarid')
		end
	else
		ESX.Alert('','Baraye esteafe az bandage bayad dar nazdiki bimarestan bashid!',5000,'error')
	end
end

local menu2 = {--TODO
	{label = 'Revive', cb = revive},
	{label = 'Check body', cb = function()
		exports['sun-jobs']:GetClosetStat()
	end},
	{label = 'Collect vacium', cb = collectVacium},
	{label = 'Heal', cb = heal},
	{label = 'Jarahi Pelastic', cb = function()
		if exports['sun-society']:doesHavePerm('plasticSurgery') then
			exports['sun-jobs']:openPlasticSurgery()
		else
			ESX.chatMessage('Shoma dastresi jarahi ra nadarid', 'job')
		end
	end},
}
function openMedicEMS()
	local elements = {}
	for k, v in pairs(menu2) do
		table.insert(elements, {label = type(v.label) == 'string' and v.label or v.label(), k = k})
	end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'f62', {
		title    = 'Menu Job',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		if not isBusy then
			menu.close()
			menu2[data.current.k].cb()
		end
	end, function(data, menu)
		menu.close()
	end)
end