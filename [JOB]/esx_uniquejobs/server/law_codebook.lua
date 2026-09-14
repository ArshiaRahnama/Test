-- ============================================================
-- Law Codebook (persistent, judge-editable, categorized)
-- Judges can add/edit/delete entries from /doj; everyone with
-- police powers (LE + DOJ) can browse it read-only from /law or
-- /doj, grouped by category, and issue a real fine straight from
-- an entry. Requires law_and_cases.sql to be imported once.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Union of every DOJ + Law Enforcement job
local RESPONDER_JOBS = {
	police = true, sheriff = true, mt = true,
	cid = true, cia = true, marshal = true, fbi = true, judge = true, doa = true,
}

local function isResponder(jobname)
	return RESPONDER_JOBS[jobname] == true
end

local function isJudge(jobname)
	return jobname == 'judge'
end

local CATEGORIES = {
	traffic = { label = 'Ranandegi', icon = 'car' },
	property = { label = 'Amval', icon = 'house' },
	violent = { label = 'Khoshoonat', icon = 'hand-fist' },
	drug = { label = 'Mavad-e Mokhader', icon = 'pills' },
	weapons = { label = 'Salah', icon = 'gun' },
	other = { label = 'Sayer', icon = 'file-lines' },
}

-- Seed a starter codebook the first time the table is empty, so the
-- feature works out of the box. Judges can edit/delete/replace all of
-- this from the /doj menu afterwards.
local DEFAULT_LAWS = {
	{ code = '§1', title = 'Sor\'at-e Gheir-e Mojaz', category = 'traffic', fine = 500, jail = 0 },
	{ code = '§2', title = 'Ranandegi-e Khatarnak', category = 'traffic', fine = 1000, jail = 5 },
	{ code = '§3', title = 'Farar Az Police', category = 'traffic', fine = 2500, jail = 15 },
	{ code = '§4', title = 'Moghavemat Dar Barabar-e Dastgiri', category = 'violent', fine = 1500, jail = 10 },
	{ code = '§5', title = 'Hamle-ye Sadeh', category = 'violent', fine = 2000, jail = 10 },
	{ code = '§6', title = 'Hamle-ye Mosallahane', category = 'violent', fine = 5000, jail = 30 },
	{ code = '§7', title = 'Sereghat', category = 'property', fine = 3000, jail = 15 },
	{ code = '§8', title = 'Sereghat-e Mosallahane', category = 'property', fine = 7500, jail = 45 },
	{ code = '§9', title = 'Hamle-ye Dozdi (Grand Theft Auto)', category = 'property', fine = 6000, jail = 30 },
	{ code = '§10', title = 'Negah-dari-e Mavad-e Mokhader', category = 'drug', fine = 4000, jail = 20 },
	{ code = '§11', title = 'Ghachagh-e Mavad-e Mokhader', category = 'drug', fine = 10000, jail = 60 },
	{ code = '§12', title = 'Negah-dari-e Salah-e Gheir-e Mojaz', category = 'weapons', fine = 5000, jail = 25 },
}

CreateThread(function()
	MySQL.Async.fetchScalar('SELECT COUNT(*) FROM law_codebook', {}, function(count)
		if count and count > 0 then return end

		for _, law in ipairs(DEFAULT_LAWS) do
			MySQL.Async.execute('INSERT INTO law_codebook (code, title, category, fine, jail_minutes, updated_by, timestamp) VALUES (@code, @title, @category, @fine, @jail, @by, @ts)', {
				['@code'] = law.code,
				['@title'] = law.title,
				['@category'] = law.category,
				['@fine'] = law.fine,
				['@jail'] = law.jail,
				['@by'] = 'System (Default)',
				['@ts'] = os.time(),
			})
		end
	end)
end)

ESX.RegisterServerCallback('esx_uniquejobs:getCodebook', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isResponder(xPlayer.job.name) then cb(nil) return end

	MySQL.Async.fetchAll('SELECT id, code, title, category, fine, jail_minutes FROM law_codebook ORDER BY category, code', {}, function(rows)
		cb(rows, isJudge(xPlayer.job.name))
	end)
end)

RegisterServerEvent('esx_uniquejobs:judgeAddLaw')
AddEventHandler('esx_uniquejobs:judgeAddLaw', function(code, title, category, fine, jail)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isJudge(xPlayer.job.name) then return end

	if not code or code == '' or not title or title == '' then
		TriggerClientEvent('esx:showNotification', source, '~r~Code Va Onvan Ra Vared Konid')
		return
	end

	if not CATEGORIES[category] then category = 'other' end

	MySQL.Async.execute('INSERT INTO law_codebook (code, title, category, fine, jail_minutes, updated_by, timestamp) VALUES (@code, @title, @category, @fine, @jail, @by, @ts)', {
		['@code'] = code,
		['@title'] = title,
		['@category'] = category,
		['@fine'] = tonumber(fine) or 0,
		['@jail'] = tonumber(jail) or 0,
		['@by'] = xPlayer.name,
		['@ts'] = os.time(),
	}, function()
		TriggerClientEvent('esx:showNotification', source, '~g~Ghanoon-e Jadid Ezafe Shod')
	end)
end)

RegisterServerEvent('esx_uniquejobs:judgeEditLaw')
AddEventHandler('esx_uniquejobs:judgeEditLaw', function(lawId, title, fine, jail)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isJudge(xPlayer.job.name) then return end

	if not title or title == '' then
		TriggerClientEvent('esx:showNotification', source, '~r~Onvan Khali Nemitavanad Bashad')
		return
	end

	MySQL.Async.execute('UPDATE law_codebook SET title = @title, fine = @fine, jail_minutes = @jail, updated_by = @by, timestamp = @ts WHERE id = @id', {
		['@id'] = lawId,
		['@title'] = title,
		['@fine'] = tonumber(fine) or 0,
		['@jail'] = tonumber(jail) or 0,
		['@by'] = xPlayer.name,
		['@ts'] = os.time(),
	}, function()
		TriggerClientEvent('esx:showNotification', source, '~g~Ghanoon Virayesh Shod')
	end)
end)

RegisterServerEvent('esx_uniquejobs:judgeSetLawCategory')
AddEventHandler('esx_uniquejobs:judgeSetLawCategory', function(lawId, category)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isJudge(xPlayer.job.name) then return end
	if not CATEGORIES[category] then return end

	MySQL.Async.execute('UPDATE law_codebook SET category = @category, updated_by = @by, timestamp = @ts WHERE id = @id', {
		['@id'] = lawId, ['@category'] = category, ['@by'] = xPlayer.name, ['@ts'] = os.time(),
	}, function()
		TriggerClientEvent('esx:showNotification', source, '~g~Dastebandi Taghir Kard')
	end)
end)

RegisterServerEvent('esx_uniquejobs:judgeDeleteLaw')
AddEventHandler('esx_uniquejobs:judgeDeleteLaw', function(lawId)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isJudge(xPlayer.job.name) then return end

	MySQL.Async.execute('DELETE FROM law_codebook WHERE id = @id', { ['@id'] = lawId }, function()
		TriggerClientEvent('esx:showNotification', source, '~g~Ghanoon Hazf Shod')
	end)
end)

-- Issue a real fine straight from a codebook entry -- used by both
-- /law (police/sheriff/mt) and /doj (every DOJ job).
-- Writes to the `billing` table directly (same schema esx_billing uses)
-- instead of re-triggering esx_billing:send2Bill, since that handler
-- reads the ambient `source` global -- unsafe to rely on from inside
-- an async DB callback like the one below.
--
-- Also reads the citation aloud over dispatch to every online LE/DOJ
-- responder, radio-style, for the roleplay flavor.
RegisterServerEvent('esx_uniquejobs:issueTicketFromLaw')
AddEventHandler('esx_uniquejobs:issueTicketFromLaw', function(lawId, targetId)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not isResponder(xPlayer.job.name) then return end

	local xTarget = ESX.GetPlayerFromId(targetId)
	if not xTarget then
		TriggerClientEvent('esx:showNotification', source, '~r~Bazikon Peida Nashod')
		return
	end

	MySQL.Async.fetchAll('SELECT code, title, fine, jail_minutes FROM law_codebook WHERE id = @id', { ['@id'] = lawId }, function(rows)
		local law = rows[1]
		if not law then
			TriggerClientEvent('esx:showNotification', source, '~r~Ghanoon Peida Nashod')
			return
		end

		MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
			['@identifier'] = xTarget.identifier,
			['@sender'] = xPlayer.identifier,
			['@target_type'] = 'society',
			['@target'] = 'society_' .. xPlayer.job.name,
			['@label'] = 'Jarime (' .. law.code .. '): ' .. law.title,
			['@amount'] = law.fine,
		}, function()
			TriggerClientEvent('esx:showNotification', source, '~g~Jarime-ye $' .. law.fine .. ' Baraye ' .. xTarget.name .. ' Sader Shod')
			TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1SYSTEM', 'Shoma Jarime Shodid: ' .. law.title .. ' ($' .. law.fine .. ')' } })

			local citation = "^3" .. xPlayer.name .. "^7 Baraye ^3" .. xTarget.name .. "^7 Sabt Kard: ^1" ..
				law.code .. " " .. law.title .. "^7 -- Jarime: ^2$" .. law.fine ..
				(law.jail_minutes > 0 and ("^7, Zendan-e Pishnahadi: ^2" .. law.jail_minutes .. " Daghighe") or "")

			local xPlayers = ESX.GetPlayers()
			for i = 1, #xPlayers do
				local xResponder = ESX.GetPlayerFromId(xPlayers[i])
				if xResponder and isResponder(xResponder.job.name) then
					TriggerClientEvent('chatMessage', xResponder.source, "[ CITATION ]", {200, 160, 0}, citation)
				end
			end
		end)
	end)
end)
