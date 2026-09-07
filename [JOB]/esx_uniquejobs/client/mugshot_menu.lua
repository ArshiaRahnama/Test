-- ============================================================
-- Mugshot menu (feature #8)
-- Reached from /law's main menu ("Mugshot"). If the screenshot-basic
-- resource is installed, running, AND the `mugshot_upload_url` convar
-- is set (server.cfg: `setr mugshot_upload_url "https://..."`, e.g. a
-- Discord webhook URL or any image-host upload endpoint), "Sabt-e Aks"
-- captures a live screenshot of whoever the officer is aimed at/near
-- and uploads it automatically. If ANY of those three things is
-- missing, it falls back to pasting a photo URL by hand instead of
-- silently doing nothing -- and says exactly which one is missing.
-- ============================================================

local function hasScreenshotBasic()
	return GetResourceState('screenshot-basic') == 'started'
end

-- Pulls a usable image URL out of either response shape:
--  - screenshot-basic's own upload.php-style response: { url: "..." } / { link: "..." }
--  - a raw Discord webhook response (screenshot-basic just relays
--    whatever the endpoint returns): { attachments: [ { url: "..." } ] }
local function extractPhotoUrl(result)
	if not result then return nil end
	if result.url then return result.url end
	if result.link then return result.link end
	if result.attachments and result.attachments[1] and result.attachments[1].url then
		return result.attachments[1].url
	end
	return nil
end

local function manualPhotoUrlPrompt(query)
	local input = lib.inputDialog('Sabt-e Mugshot (Dasti)', { { type = 'input', label = 'URL-e Aks', required = true } })
	if input and input[1] then
		TriggerServerEvent('esx_uniquejobs:dojSaveMugshot', query, input[1])
	end
end

local function captureAndSave(query)
	if not hasScreenshotBasic() then
		ESX.ShowNotification("~y~Resource-e screenshot-basic Nasb/Roshan Nist -- URL-e Aks Ra Dasti Vared Konid")
		manualPhotoUrlPrompt(query)
		return
	end

	local uploadUrl = GetConvar('mugshot_upload_url', '')
	if uploadUrl == '' then
		ESX.ShowNotification("~y~convar mugshot_upload_url Tanzim Nashode (server.cfg) -- URL-e Aks Ra Dasti Vared Konid")
		manualPhotoUrlPrompt(query)
		return
	end

	exports['screenshot-basic']:requestScreenshotUpload(uploadUrl, 'files[]', {}, function(data)
		local ok, result = pcall(json.decode, data)
		local url = ok and extractPhotoUrl(result) or nil
		if url then
			TriggerServerEvent('esx_uniquejobs:dojSaveMugshot', query, url)
		else
			ESX.ShowNotification("~r~Upload-e Aks Shekast Khord (Pasokh-e Server-e Upload Namotabar Bood) -- Baraye Vared Kardan-e Dasti URL Talash Konid")
			manualPhotoUrlPrompt(query)
		end
	end)
end

function OpenMugshotMenu()
	local input = lib.inputDialog('Mugshot', { { type = 'input', label = 'ID Ya Esm-e Shahrvand', required = true } })
	if not input or not input[1] then return end
	local query = input[1]

	ESX.TriggerServerCallback('esx_uniquejobs:dojGetMugshot', function(record)
		if not record then
			ESX.ShowNotification("~r~Shahrvand Peida Nashod")
			return
		end

		local options = {
			{
				title = record.name,
				description = record.photo_url and 'Aks Mojood Ast' or 'Hanooz Aksi Sabt Nashode',
				icon = 'id-card',
				disabled = true,
			},
		}

		if record.photo_url then
			options[#options + 1] = {
				title = 'Namayesh-e Aks',
				description = record.photo_url,
				icon = 'image',
				onSelect = function()
					lib.alertDialog({ header = record.name, content = ('![mugshot](%s)'):format(record.photo_url), centered = true })
				end,
			}
		end

		options[#options + 1] = {
			title = record.photo_url and 'Jaygozin Kardan-e Aks' or 'Sabt-e Aks-e Jadid',
			icon = 'camera',
			onSelect = function()
				captureAndSave(query)
			end,
		}

		options[#options + 1] = {
			title = 'Rap Sheet-e Kamel',
			description = 'Karte Shenasaee + Sabeghe-ye Kayfari-ye Kamel',
			icon = 'id-card-clip',
			onSelect = function()
				OpenRapSheetMenu(query)
			end,
		}

		lib.registerContext({ id = 'law_mugshot', title = 'Mugshot', menu = 'law_main', options = options })
		lib.showContext('law_mugshot')
	end, query)
end

-- ============================================================
-- Rap Sheet
-- ============================================================

local SEX_LABELS = { m = 'Mard', f = 'Zan' }

local function formatRecordLine(r)
	local kind = r.type == 'arrest' and 'Dastgiri' or 'Etteham'
	local extra = r.jail_time and (' (' .. r.jail_time .. ' Daghighe)') or ''
	return kind .. ': ' .. r.reason .. extra .. ' -- Afsar: ' .. r.officer_name
end

function OpenRapSheetMenu(query)
	ESX.TriggerServerCallback('esx_uniquejobs:dojGetRapSheet', function(sheet)
		if not sheet then
			ESX.ShowNotification("~r~Shahrvand Peida Nashod")
			return
		end

		local options = {
			{
				title = sheet.name,
				description = (sheet.sex and (SEX_LABELS[sheet.sex] or sheet.sex) or 'Namoshakhas')
					.. ' | Tavallod: ' .. (sheet.dateofbirth or 'Namoshakhas')
					.. ' | Ghad: ' .. (sheet.height and (sheet.height .. 'cm') or 'Namoshakhas'),
				icon = 'id-card',
				disabled = true,
			},
			{
				title = 'Akharin Mahal-e Shenakhte Shode',
				description = sheet.lastLocation or 'Sabt Nashode (Az Tavaghof-haye Tarafiki Gerefte Mishavad)',
				icon = 'location-dot',
				disabled = true,
			},
			{
				title = sheet.arrests .. ' Dastgiri | ' .. sheet.charges .. ' Etteham',
				description = 'Majmoo-e Sabeghe-ye Kayfari',
				icon = 'handcuffs',
				disabled = true,
			},
		}

		if sheet.photoUrl then
			options[#options + 1] = {
				title = 'Namayesh-e Aks',
				icon = 'image',
				onSelect = function()
					lib.alertDialog({ header = sheet.name, content = ('![mugshot](%s)'):format(sheet.photoUrl), centered = true })
				end,
			}
		end

		if #sheet.records == 0 then
			options[#options + 1] = { title = 'Sabeghe-i Sabt Nashode', disabled = true, icon = 'circle-info' }
		else
			for _, r in ipairs(sheet.records) do
				options[#options + 1] = { title = formatRecordLine(r), disabled = true, icon = r.type == 'arrest' and 'handcuffs' or 'scale-unbalanced' }
			end
		end

		options[#options + 1] = { title = 'Parvande-haye CAD', icon = 'folder-open', disabled = true }
		if #sheet.cadCases == 0 then
			options[#options + 1] = { title = 'Parvande-i Dar CAD Nist', disabled = true, icon = 'circle-info' }
		else
			for _, c in ipairs(sheet.cadCases) do
				options[#options + 1] = {
					title = '#' .. c.id .. ' -- ' .. c.rob_name .. ' ' .. c.rob_family,
					description = 'Vaziat: ' .. c.status,
					icon = 'folder-open',
					disabled = true,
				}
			end
		end

		options[#options + 1] = { title = 'Sabeghe-ye Booking-e CAD', icon = 'book', disabled = true }
		if #sheet.cadRecords == 0 then
			options[#options + 1] = { title = 'Booking-i Dar CAD Nist', disabled = true, icon = 'circle-info' }
		else
			for _, r in ipairs(sheet.cadRecords) do
				options[#options + 1] = {
					title = r.charges,
					description = 'Jarime: $' .. r.fine .. ' | Zendan: ' .. r.jail_minutes .. ' Daghighe | Afsar: ' .. (r.booked_by_name or 'Namoshakhas'),
					icon = 'handcuffs',
					disabled = true,
				}
			end
		end

		options[#options + 1] = {
			title = 'Namayesh-e Motn-e Kamel (Baraye Chap)',
			icon = 'print',
			onSelect = function()
				local lines = {
					'# Rap Sheet -- ' .. sheet.name,
					'',
					'**Jensiat:** ' .. (sheet.sex and (SEX_LABELS[sheet.sex] or sheet.sex) or 'Namoshakhas'),
					'**Tarikh-e Tavallod:** ' .. (sheet.dateofbirth or 'Namoshakhas'),
					'**Ghad:** ' .. (sheet.height and (sheet.height .. ' cm') or 'Namoshakhas'),
					'**Akharin Mahal-e Shenakhte Shode:** ' .. (sheet.lastLocation or 'Namoshakhas'),
					'**Majmoo:** ' .. sheet.arrests .. ' Dastgiri, ' .. sheet.charges .. ' Etteham',
					'',
					'## Sabeghe-ye Kayfari',
				}
				if #sheet.records == 0 then
					lines[#lines + 1] = '_Sabeghe-i Sabt Nashode_'
				else
					for _, r in ipairs(sheet.records) do
						lines[#lines + 1] = '- ' .. formatRecordLine(r)
					end
				end

				lines[#lines + 1] = ''
				lines[#lines + 1] = '## Parvande-haye CAD'
				if #sheet.cadCases == 0 then
					lines[#lines + 1] = '_Parvande-i Dar CAD Nist_'
				else
					for _, c in ipairs(sheet.cadCases) do
						lines[#lines + 1] = '- #' .. c.id .. ' ' .. c.rob_name .. ' ' .. c.rob_family .. ' (' .. c.status .. ')'
					end
				end

				lines[#lines + 1] = ''
				lines[#lines + 1] = '## Sabeghe-ye Booking-e CAD'
				if #sheet.cadRecords == 0 then
					lines[#lines + 1] = '_Booking-i Dar CAD Nist_'
				else
					for _, r in ipairs(sheet.cadRecords) do
						lines[#lines + 1] = '- ' .. r.charges .. ' -- $' .. r.fine .. ', ' .. r.jail_minutes .. ' Daghighe (Afsar: ' .. (r.booked_by_name or 'Namoshakhas') .. ')'
					end
				end

				if sheet.photoUrl then
					lines[#lines + 1] = ''
					lines[#lines + 1] = ('![mugshot](%s)'):format(sheet.photoUrl)
				end

				lib.alertDialog({ header = 'Rap Sheet', content = table.concat(lines, '\n'), centered = true, size = 'lg' })
			end,
		}

		lib.registerContext({ id = 'law_rap_sheet', title = 'Rap Sheet', menu = 'law_mugshot', options = options })
		lib.showContext('law_rap_sheet')
	end, query)
end
