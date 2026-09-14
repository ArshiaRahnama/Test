-- ============================================================
-- Unified Robbery Accept Menu (client)
-- Single /acceptrob command -> ox_lib context menu listing every
-- active, unaccepted dispatched robbery. Replaces the old
-- /acceptrob_police [code] and /acceptrob_marshal [code] commands.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local RESPONDER_JOBS = { police = true, sheriff = true, mt = true, fbi = true, marshal = true }

local function isResponder(jobname)
	return RESPONDER_JOBS[jobname] == true
end

local function formatAgo(seconds)
	if seconds < 60 then
		return seconds .. ' Sanie Pish'
	end
	return math.floor(seconds / 60) .. ' Daghighe Pish'
end

local function OpenAcceptRobMenu()
	ESX.TriggerServerCallback('esx_uniquejobs:getActiveRobs', function(robs)
		if not robs then
			TriggerEvent('chat:addMessage', { args = { '^1SYSTEM', 'Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid' } })
			return
		end

		local options = {}

		for _, rob in ipairs(robs) do
			options[#options + 1] = {
				title = rob.name,
				description = 'Gozaresh Shode: ' .. formatAgo(rob.secondsAgo),
				icon = 'money-bill-transfer',
				metadata = {
					{ label = 'Vaziat', value = 'Dar Entezare Accept' },
				},
				onSelect = function()
					local alert = lib.alertDialog({
						header = 'Accept Kardane Rob',
						content = 'Aya Mikhahid ^2' .. rob.name .. '^0 Ra Accept Konid?',
						centered = true,
						cancel = true,
					})
					if alert == 'confirm' then
						TriggerServerEvent('esx_uniquejobs:acceptRob', rob.code)
					end
				end,
			}
		end

		if #options == 0 then
			options[#options + 1] = { title = 'Hich Robberi Baraye Accept Vojod Nadarad', disabled = true, icon = 'circle-check' }
		end

		lib.registerContext({
			id = 'acceptrob_main',
			title = 'Robbery Haye Faal',
			options = options,
		})
		lib.showContext('acceptrob_main')
	end)
end

RegisterCommand('acceptrob', function()
	OpenAcceptRobMenu()
end, false)

RegisterNetEvent('esx_uniquejobs:robAlert')
AddEventHandler('esx_uniquejobs:robAlert', function(name)
	local playerData = ESX.GetPlayerData()
	if not playerData or not playerData.job or not isResponder(playerData.job.name) then return end

	TriggerEvent('chat:addMessage', {
		color = { 255, 60, 60 },
		multiline = true,
		args = { '[ Dispatch ]', 'Alarm Robbery Dar ^2' .. name .. '^0 -- Jahat Accept ^3/acceptrob^0 Ra Bezanid' },
	})
end)

RegisterNetEvent('esx_uniquejobs:robAccepted')
AddEventHandler('esx_uniquejobs:robAccepted', function(name, officerName, officerJob)
	local playerData = ESX.GetPlayerData()
	if not playerData or not playerData.job or not isResponder(playerData.job.name) then return end

	TriggerEvent('chat:addMessage', {
		color = { 0, 95, 254 },
		multiline = true,
		args = { '[ Dispatch ]', 'Robbery ^2' .. name .. '^0 Tavasote ^3' .. officerName .. '^0 (' .. officerJob .. ') Accept Shod' },
	})
end)
