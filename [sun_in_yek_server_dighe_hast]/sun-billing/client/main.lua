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

ESX          = nil
local openCD = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local billingColor = GetResourceKvpString('sun_billing_color') or '#4fd2ff'
local ghabzOpen    = false

AddEventHandler('sun_menu:settings', function(s)
	if type(s) == 'table' and s.ghabz and s.ghabz.color then
		billingColor = s.ghabz.color
		SetResourceKvp('sun_billing_color', billingColor)
		if ghabzOpen then
			SendNUIMessage({ action = 'setColor', color = billingColor })
		end
	end
end)

function ShowBillsMenu()

	ESX.TriggerServerCallback('esx_billing:getBills', function(bills)
		ESX.UI.Menu.CloseAll()
		local elements = {}

		for i=1, #bills, 1 do
			table.insert(elements, {
				label  = ('%s - <span style="color:white;">%s</span>'):format(bills[i].label, _U('invoices_item', ESX.Math.GroupDigits(bills[i].amount))),
				billID = bills[i].id
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'billing',
		{
			title    = _U('invoices'),
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)
			menu.close()

			ESX.TriggerServerCallback('billing:payBill', function()
				ShowBillsMenu()
			end, data.current.billID)
		end, function(data, menu)
			menu.close()
		end)
	end)

end


local closeThread = false
RegisterNetEvent('billing:question', function(fineData, fastPay)
	closeThread = true
	Citizen.CreateThread(function()
		while closeThread do
			Wait(1000)
			if not ESX.UI.Menu.IsOpen('question', GetCurrentResourceName(), 'ask') and closeThread then
				closeThread = false
				ESX.TriggerServerEvent('billing:decline', fineData)
				break
			end
		end
	end)
	ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'ask',
	{
		title 	 = 'Taeed ghabz',
		align    = 'center',
		question = 'Aya yek ghabz ba mablaghe '.. ESX.Math.GroupDigits(fineData.amount) .. ' be dalile "'.. fineData.label .. '" ghabul mikonid?',
		elements = {
			{label = 'Bale', value = 'yes'},
			{label = 'Kheir', value = 'no'},
		}
	}, function(data, menu)
		closeThread = false
		ESX.UI.Menu.CloseAll()
		if data.current.value == 'yes' or data.current.value == 'yes2' then
			ESX.TriggerServerEvent('billing:accept', fineData)
				Wait(1000)
				ESX.TriggerServerCallback('billing:payBill', function()
				end, fineData.id, true)
		else
			ESX.TriggerServerEvent('billing:decline', fineData)
		end
	end)
end)

function openMenu(reason, accountName)
	exports['sunset_utils']:me('Ghabz ro az jibesh dar miare', true)
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
		title = 'Mablagh ghabz ra varedk konid.'
	}, function(data, menu)

		local amount = tonumber(data.value)
		if amount == nil then
			ESX.ShowNotification('Mablagh vared shode eshtebah ast')
		else
			ESX.UI.Menu.CloseAll()
			ESX.selectPlayerMenu(function(src)
				if amount == nil or amount < 0 or amount > 50000 then
					ESX.ShowNotification('Mablagh vared shode eshtebah ast')
				else
					ESX.TriggerServerEvent('esx_billing:send2Bill', src, accountName or '', reason or '', amount)
					ESX.ShowNotification('Ghabz ba movafaghiat ersal shod.')
				end
			end)
		end

	end, function(data, menu)
		menu.close()
	end)
end

exports('openMenu', openMenu)

AddEventHandler("KeyDown:f7", function()
	if ESX.GetPlayerData()['IsDead'] ~= 1 and not ESX.UI.Menu.IsOpen('default', GetCurrentResourceName(), 'billing') and (not openCD or openCD < GetGameTimer()) then
		openCD = GetGameTimer() + 10000
		ShowBillsMenu()
	end
end)

local currentGhabz = nil

function openGhabzMenu(job)
	if not job then
		local pd = ESX.GetPlayerData and ESX.GetPlayerData()
		job = pd and pd.job and pd.job.name
	end
	local jobData = Config.suggestionghabz and Config.suggestionghabz[job]
	if not jobData then
		ESX.ShowNotification(('Baraye shoghle shoma (~y~%s~s~) hich ghabze pishnahadi tarif nashode'):format(job or 'nameshakhs'))
		return
	end
	ESX.selectPlayerMenu(function(src)
		ESX.UI.Menu.CloseAll()
		currentGhabz = {
			account   = jobData.account ~= nil and jobData.account or ('society_' .. job),
			maxAmount = jobData.maxAmount or 50000,
			targetSrc = src,
		}
		ghabzOpen = true
		SetNuiFocus(true, true)
		SendNUIMessage({
			action = 'open',
			job    = job,
			color  = billingColor,
			list   = jobData.list,
		})
	end, 5)
end
exports('openGhabzMenu', openGhabzMenu)

RegisterNUICallback('ghabzPick', function(data, cb)
	ghabzOpen = false
	SetNuiFocus(false, false)
	cb('ok')
	TriggerEvent('KeyDown:f6')
	local g = currentGhabz
	if not g then return end
	local reason = data.reason
	local amount = tonumber(data.amount)
	if reason == nil or reason == '' or amount == nil or amount <= 0 then
		ESX.ShowNotification('Ghabz namoatabar ast')
		return
	end
	if amount > g.maxAmount then
		ESX.ShowNotification(('Mablagh bayad kamtar az %s$ bashad'):format(ESX.Math.GroupDigits(g.maxAmount)))
		return
	end
	local tgt    = GetPlayerFromServerId(g.targetSrc)
	local tgtPed = tgt ~= -1 and GetPlayerPed(tgt) or 0
	if tgtPed == 0 or not DoesEntityExist(tgtPed) or #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(tgtPed)) > 20.0 then
		ESX.ShowNotification('Fard kheyli dur ast (bishtar az 20 metr)')
		return
	end
	exports['sunset_utils']:me('Ghabz ro az jibesh dar miare', true)
	ESX.TriggerServerEvent('esx_billing:send2Bill', g.targetSrc, g.account, reason, amount)
	ESX.ShowNotification('Ghabz ba movafaghiat ersal shod.')
end)

RegisterNUICallback('ghabzClose', function(data, cb)
	ghabzOpen = false
	SetNuiFocus(false, false)
	cb('ok')
end)