ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(1)
	end
end)

local isOpen = false

-- ============================================================================
-- باز/بسته‌کردن پنل
-- ============================================================================
RegisterNetEvent('LogPanel:client:Open')
AddEventHandler('LogPanel:client:Open', function(mode, job, jobLabel)
	if isOpen then return end
	isOpen = true
	SetNuiFocus(true, true)
	SendNUIMessage({
		action = 'open',
		mode = mode,       -- 'admin' یا 'boss'
		job = job,
		jobLabel = jobLabel,
	})
end)

local function ClosePanel()
	if not isOpen then return end
	isOpen = false
	SetNuiFocus(false, false)
	SendNUIMessage({ action = 'close' })
end

RegisterNUICallback('close', function(data, cb)
	ClosePanel()
	cb('ok')
end)

RegisterNUICallback('fetchLogs', function(data, cb)
	ESX.TriggerServerCallback('LogPanel:GetLogs', function(result)
		cb(result)
	end, data)
end)

RegisterNUICallback('fetchMeta', function(data, cb)
	ESX.TriggerServerCallback('LogPanel:GetMeta', function(result)
		cb(result)
	end)
end)

-- ============================================================================
-- کامندهای کلاینتی (میان‌بر مستقیم، جدا از کامند سروری که پرمیشن‌چک می‌کنه)
-- ============================================================================
RegisterCommand('adminlogs', function()
	TriggerServerEvent('LogPanel:OpenAdmin')
end, false)

RegisterCommand('myjoblogs', function()
	TriggerServerEvent('LogPanel:OpenForJob')
end, false)

-- برای وصل‌کردن به دکمه‌ی داخل باس‌منوی هر جاب: از همون‌جا این ایونت رو صدا بزن
-- TriggerEvent('LogPanel:OpenBossPanel')  -- (سمت کلاینت، همون سورسی که باس‌منو باز کرده)
RegisterNetEvent('LogPanel:OpenBossPanel')
AddEventHandler('LogPanel:OpenBossPanel', function()
	TriggerServerEvent('LogPanel:OpenForJob')
end)

-- بستن با ESC یا کلید بک‌اسپیس از داخل خودِ NUI مدیریت می‌شه (js)، ولی یه فال‌بک هم داریم:
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isOpen then
			if IsControlJustPressed(0, 200) then -- ESC
				ClosePanel()
			end
		else
			Citizen.Wait(200)
		end
	end
end)
