-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Config_RPS = {
	AntiSpamTime = 10 * 60 * 1000,
	ReportCats = {
		{"REPORT_COMBAT_LOGOUT", "Combat Logout"},
		{"REPORT_KOS", "K.O.S"},
		{"REPORT_NCZ_SAFEZONE", "N.C.Z & Safe Zone"},
		{"REPORT_POWER_GAMING", "Power Gaming"},
		{"REPORT_VDM", "VDM"},
		{"REPORT_FEAR_RP", "Fear Rp"},
		{"REPORT_SEARCH", "Search"},
		{"REPORT_META_GAMING", "Meta Gaming"},
		{"REPORT_MIX_IC_OOC", "MIX IC OOC"},
		{"REPORT_FAHASHI", "Fahashi"},
		{"REPORT_BUG_GLITCH", "Bug & Glitch"},
		{"HELP", "Soal"},
		{"REPORT_MORE", "More"},
		{"REPORT_NEW_PLAYER", "New Player", true},
	}
}

local AntiSpamReport = false

local pendingRatingData = nil

local function buildQueueCategories()
	local categories = {}
	for k, v in ipairs(Config_RPS.ReportCats) do
		table.insert(categories, { key = v[1], label = v[2] })
	end
	return categories
end

local function buildSubmitCategories()
	local categories = {}
	for k, v in ipairs(Config_RPS.ReportCats) do
		if not v[3] then
			table.insert(categories, { key = v[1], label = v[2] })
		end
	end
	return categories
end

AddEventHandler('sundl:requestCategories', function()
	TriggerEvent('sundl:provideCategories', buildQueueCategories())
end)

AddEventHandler('esx:playerLoaded', function(xPlayer)
	if xPlayer and (xPlayer.permission_level or 0) >= 1 then
		TriggerEvent('sundl:provideCategories', buildQueueCategories())
	end
end)

local function OpenReportPanel()
	if AntiSpamReport then
		ESX.ShowNotification("Shoma Dar Har ~r~".. ESX.Math.Round((Config_RPS.AntiSpamTime / 1000) / 60) .." Daghighe~s~ Faghat Mitavanid 1 ~r~Report~s~ Ersal Konid!")
		return
	end

	ESX.TriggerServerCallback('report:checkPendingRating', function(result)
		if result.hasPending then
			pendingRatingData = result
			TriggerEvent('chat:openRatingDirect', result.adminName, result.reportId)
		else
			TriggerEvent('chat:openReportSubmit', buildSubmitCategories())
		end
	end)
end

RegisterCommand('report', OpenReportPanel)

Citizen.CreateThread(function()
	while ESX == nil do Citizen.Wait(1) end
	ESX.TriggerServerCallback('sunset_main:GetReportTimeOut', function(timeout)
		if timeout ~= nil and timeout > 0 then
			Config_RPS.AntiSpamTime = timeout * 60 * 1000
		end
	end)
	ESX.TriggerServerCallback('report:getSelfCancelAllowed', function(allowed)
		TriggerEvent('chat:setTicketCancelAllowed', allowed and true or false)
	end)
end)

AddEventHandler('chat:reportSubmitted', function(message, category)
	if AntiSpamReport then return end

	if category == "Soal" then
		ESX.TriggerServerCallback('helper:findNumber', function(cb)
			if not cb then
				TriggerServerEvent('SendReport', message, category)
				sendScreenshot()
			end
		end)
	else
		TriggerServerEvent('SendReport', message, category)
		sendScreenshot()
	end

	AntiSpamReport = true
	SetTimeout(Config_RPS.AntiSpamTime, function()
		AntiSpamReport = false
	end)
end)

RegisterNetEvent('ReportCoolown', function(min)
	ESX.ShowNotification("Shoma ta ~r~".. min .. " daghighe~s~ digar nemitavanid ~r~report~s~ ersal konid!")
end)

RegisterNetEvent('report:resetCooldown', function()
	AntiSpamReport = false
end)

RegisterNetEvent('SetReportCoolown', function(min)
	Config_RPS.AntiSpamTime = min * 60 * 1000
end)

RegisterNetEvent('CancelReport', function(min)
	Wait(2000)
	ExecuteCommand('cancelreport')
end)

local reports = {}
local isMenuOpen = false
local isInDetails = false

function updateReports(unvar)
	local p = promise.new()
	ESX.TriggerServerCallback('report:getReports', function(cb)
		p:resolve(cb)
	end, unvar)
	reports = Citizen.Await(p)
end

function openReportMenu(state)
	SetNuiFocus(state, state)
	if state then
		SendNUIMessage({
			action = "updateReportList",
			reportList = reports
		})
		SendNUIMessage({
			action = "openReportList",
		})
	end
end

function sendScreenshot()
	ESX.TriggerServerCallback('report:getWebhook', function(hook)
		if hook then
			exports['screenshot-basic']:requestScreenshotUpload(hook, "files[]", function(data)
				local image = json.decode(data)
				TriggerServerEvent('report:setPhoto', image.attachments[1].proxy_url)
			end)
		end
	end)
end

RegisterNUICallback("action", function(data)
	local action = data.action
	if action ~= "solvedreport" and action ~= "morebutton" and action ~= "morebuttonback" then
		SetNuiFocus(false, false)
		isMenuOpen = false
	end

	if action == "closeReport" then
		ExecuteCommand('cr '.. data.id)
	elseif action == 'teleport' then
		ExecuteCommand('goto '.. data.id)
	elseif action == 'spectate' then
		ExecuteCommand('sp '.. data.id)
	elseif action == "morebuttonback" then
		isInDetails = false
	elseif action == "morebutton" then
		isInDetails = true
	end
end)

local rpPanelOpen = false

function rpFetchReports(unvar)
	local p = promise.new()
	ESX.TriggerServerCallback('report:getReports', function(cb)
		p:resolve(cb)
	end, unvar)
	return Citizen.Await(p)
end

function rpFetchClosedReports()
	local p = promise.new()
	ESX.TriggerServerCallback('report:getClosedReports', function(cb)
		p:resolve(cb)
	end)
	return Citizen.Await(p)
end

RegisterNetEvent('chat:openReportPanel', function(unvar)
	if rpPanelOpen then
		TriggerEvent('chat:rpHidePanel')
		rpPanelOpen = false
		return
	end
	rpPanelOpen = true
	local data = rpFetchReports(unvar)
	local closed = rpFetchClosedReports()
	TriggerEvent('chat:rpShowPanel', data, closed)
	Citizen.CreateThread(function()
		while rpPanelOpen do
			Citizen.Wait(3000)
			if rpPanelOpen then
				local freshData = rpFetchReports(unvar)
				local freshClosed = rpFetchClosedReports()
				TriggerEvent('chat:rpUpdatePanel', freshData, freshClosed)
			end
		end
	end)
end)

AddEventHandler('chat:rpActionFromNUI', function(action, id)
	if action == "spectate" and tonumber(id) then
		ExecuteCommand('sp ' .. tonumber(id))
	elseif action == "acall" and tonumber(id) then
		ExecuteCommand('acall ' .. tonumber(id))
	end
end)

RegisterNetEvent('report:statusUpdate', function(data)
	if data.status == "open" then
		TriggerEvent('chat:ticketStatusUpdate', "open", nil, data.cat, data.message, data.time)
	elseif data.status == "pending" then
		TriggerEvent('chat:ticketStatusUpdate', "pending", data.adminName)
	elseif data.status == "hide" then
		TriggerEvent('chat:ticketHide')
	end
end)

RegisterNetEvent('report:closed', function(data)
	TriggerEvent('chat:ticketStatusUpdate', "closed", data.adminName, nil, nil, nil, data.reportId)
end)

AddEventHandler('chat:ratingSubmitted', function(reportId, rating, comment)
	TriggerServerEvent('report:submitRating', reportId, rating, comment)
	if pendingRatingData then
		pendingRatingData = nil
		Citizen.Wait(500)
		TriggerEvent('chat:openReportSubmit', buildSubmitCategories())
	end
end)

AddEventHandler('chat:ratingSkipped', function(reportId)
	TriggerServerEvent('report:submitRating', reportId, 5, "skip")
	if pendingRatingData then
		pendingRatingData = nil
		Citizen.Wait(500)
		TriggerEvent('chat:openReportSubmit', buildSubmitCategories())
	end
end)
