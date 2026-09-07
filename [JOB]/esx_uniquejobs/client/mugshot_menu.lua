-- ============================================================
-- Mugshot menu (feature #8)
-- Reached from /law's main menu ("Mugshot"). If the screenshot-basic
-- resource is installed and running, "Sabt-e Aks" captures a live
-- screenshot of whoever the officer is aimed at/near and uploads it
-- automatically; otherwise it falls back to pasting a photo URL by
-- hand, so this still works on servers without that resource.
-- ============================================================

local function hasScreenshotBasic()
	return GetResourceState('screenshot-basic') == 'started'
end

local function captureAndSave(query)
	if hasScreenshotBasic() then
		exports['screenshot-basic']:requestScreenshotUpload(GetConvar('mugshot_upload_url', ''), 'files[]', {}, function(data)
			local ok, result = pcall(json.decode, data)
			local url = (ok and result and (result.url or result.link)) or nil
			if url then
				TriggerServerEvent('esx_uniquejobs:dojSaveMugshot', query, url)
			else
				ESX.ShowNotification("~r~Upload-e Aks Shekast Khord -- Baraye Vared Kardan-e Dasti URL Talash Konid")
			end
		end)
		return
	end

	local input = lib.inputDialog('Sabt-e Mugshot (Dasti)', { { type = 'input', label = 'URL-e Aks', required = true } })
	if input and input[1] then
		TriggerServerEvent('esx_uniquejobs:dojSaveMugshot', query, input[1])
	end
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
