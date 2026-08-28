-- ============================================================
-- /law -- quick codebook reference + ticket issuing for
-- police/sheriff/mt. Reads the same persistent, judge-editable
-- law_codebook table /doj uses, so both stay in sync.
-- ============================================================

ESX = nil

local LE_JOBS = { police = true, sheriff = true, mt = true }
local leJob = nil

local CODEBOOK_CATEGORIES = {
	traffic = { label = 'Ranandegi', icon = 'car' },
	property = { label = 'Amval', icon = 'house' },
	violent = { label = 'Khoshoonat', icon = 'hand-fist' },
	drug = { label = 'Mavad-e Mokhader', icon = 'pills' },
	weapons = { label = 'Salah', icon = 'gun' },
	other = { label = 'Sayer', icon = 'file-lines' },
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(200)
	end

	local playerLoaded = false
	RegisterNetEvent('esx:playerLoaded')
	AddEventHandler('esx:playerLoaded', function(xPlayer)
		playerLoaded = true
	end)

	while not playerLoaded do
		Citizen.Wait(200)
	end

	CheckLeJob()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	leJob = LE_JOBS[job.name] and job.name or nil
end)

function CheckLeJob()
	if ESX.PlayerData and ESX.PlayerData.job then
		leJob = LE_JOBS[ESX.PlayerData.job.name] and ESX.PlayerData.job.name or nil
	end
end

local function lawLine(law)
	return 'Jarime: $' .. law.fine .. (law.jail_minutes > 0 and (' | Zendan: ' .. law.jail_minutes .. ' Daghighe') or ' | Bedoon-e Zendan')
end

local function issueOption(law)
	return {
		title = law.code .. ' -- ' .. law.title,
		description = lawLine(law),
		icon = 'gavel',
		onSelect = function()
			local input = lib.inputDialog('Sodoor Jarime -- ' .. law.title, { { type = 'number', label = 'ID Bazikon', required = true } })
			if input and input[1] then
				TriggerServerEvent('esx_uniquejobs:issueTicketFromLaw', law.id, input[1])
			end
		end,
	}
end

function OpenLawMenu()
	if not leJob then
		ESX.ShowNotification("❌ Shoma Police, Sheriff Ya MT Nistid!")
		return
	end

	ESX.TriggerServerCallback('esx_uniquejobs:getCodebook', function(laws)
		laws = laws or {}
		local options = {
			{
				title = 'Jostoju Dar Ghanoon-name',
				icon = 'magnifying-glass',
				onSelect = function()
					local input = lib.inputDialog('Jostoju', { { type = 'input', label = 'Code Ya Onvan', required = true } })
					if input and input[1] then
						local query = string.lower(input[1])
						local results = {}
						for _, law in ipairs(laws) do
							if string.find(string.lower(law.title), query, 1, true) or string.find(string.lower(law.code), query, 1, true) then
								results[#results + 1] = issueOption(law)
							end
						end
						if #results == 0 then
							results[#results + 1] = { title = 'Chizi Peida Nashod', disabled = true, icon = 'circle-info' }
						end
						lib.registerContext({ id = 'law_search', title = 'Natije-ye Jostoju', menu = 'law_main', options = results })
						lib.showContext('law_search')
					end
				end,
			},
		}

		for key, cat in pairs(CODEBOOK_CATEGORIES) do
			local catOptions = {}
			for _, law in ipairs(laws) do
				if law.category == key then
					catOptions[#catOptions + 1] = issueOption(law)
				end
			end

			if #catOptions > 0 then
				options[#options + 1] = {
					title = cat.label .. ' (' .. #catOptions .. ')',
					icon = cat.icon,
					menu = 'law_cat_' .. key,
				}
				lib.registerContext({ id = 'law_cat_' .. key, title = cat.label, menu = 'law_main', options = catOptions })
			end
		end

		if #options == 1 then
			options[#options + 1] = { title = 'Ghanoon-name Khali Ast', disabled = true, icon = 'circle-info' }
		end

		lib.registerContext({ id = 'law_main', title = 'Ghanoon-name', options = options })
		lib.showContext('law_main')
	end)
end

RegisterCommand('law', function()
	OpenLawMenu()
end, false)
