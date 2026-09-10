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
	TriggerServerEvent('LogPanel:PanelClosed')
end

-- اطلاع‌رسانی زنده‌ی لاگ جدید (وقتی پنل بازه) — سرور بهمون میگه چندتا لاگ جدید اومده
RegisterNetEvent('LogPanel:client:NewLogs')
AddEventHandler('LogPanel:client:NewLogs', function(count)
	if not isOpen then return end
	SendNUIMessage({ action = 'newLogs', count = count })
	-- یه بوق کوتاه UI به‌عنوان اعلان، بدون نیاز به فایل صوتی اضافه
	PlaySoundFrontend(-1, 'CHAT_MESSAGE_RECEIVED', 'GTAO_FM_EVENTS_SOUNDSET', true)
end)

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

RegisterNUICallback('fetchStats', function(data, cb)
	ESX.TriggerServerCallback('LogPanel:GetStats', function(result)
		cb(result)
	end, data)
end)

RegisterNUICallback('exportLogs', function(data, cb)
	ESX.TriggerServerCallback('LogPanel:ExportLogs', function(result)
		cb(result)
	end, data)
end)

RegisterNUICallback('deleteLog', function(data, cb)
	ESX.TriggerServerCallback('LogPanel:DeleteLog', function(result)
		cb(result)
	end, data)
end)

RegisterNUICallback('togglePin', function(data, cb)
	ESX.TriggerServerCallback('LogPanel:TogglePin', function(result)
		cb(result)
	end, data)
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

-- ============================================================================
-- پاک‌کردن خودکار کیبایند F9 که تو نسخه‌ی قبلی این اسکریپت (با RegisterKeyMapping)
-- ثبت شده بود. FiveM بایندها رو سمت کلاینت خودِ بازیکن ذخیره می‌کنه، پس فقط حذف‌کردن
-- RegisterKeyMapping از کد کافی نیست — کسی که قبلاً وصل شده، F9 هنوز روش بایند مونده
-- (چون کامند myjoblogs هنوز وجود داره). این خط، همون بایند قدیمی رو خودکار پاک می‌کنه.
Citizen.CreateThread(function()
	Citizen.Wait(1000) -- یه‌کم صبر تا سیستم کیبایند بازی کامل لود بشه
	ExecuteCommand('unbind keyboard f9 myjoblogs')
	ExecuteCommand('unbind keyboard F9 myjoblogs')
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

-- اگه ریسورس ری‌استارت/استاپ بشه درحالی‌که پنل بازه، فوکوس رو برگردون تا کاربر گیر نکنه
AddEventHandler('onResourceStop', function(resourceName)
	if resourceName == GetCurrentResourceName() and isOpen then
		SetNuiFocus(false, false)
	end
end)
