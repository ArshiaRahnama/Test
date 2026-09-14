-- ============================================================
-- Unified Unit Manager (client)
-- Single /unit command -> ox_lib context menu, replaces every
-- old /createunit_X /delunit_X /renameunit_X /disbanunit_X
-- /units_X /joinunit_X /leaveunit_X command set.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function OpenUnitMenu()
	ESX.TriggerServerCallback('esx_uniquejobs:getUnitMenu', function(data)
		if not data then
			TriggerEvent('chat:addMessage', { args = { '^1SYSTEM', 'Shoma Dastresi Kafi Baraye Estefade Az In Dastor Ra Nadarid' } })
			return
		end

		local options = {}

		if data.myUnit then
			local unit = data.myUnit

			options[#options + 1] = {
				title = 'Vahed Man: ' .. unit.callsign,
				description = 'Leader: ' .. unit.ownerName .. ' | Members: ' .. #unit.members,
				disabled = true,
			}

			if unit.isOwner then
				options[#options + 1] = {
					title = 'Taghire Nam Unit',
					icon = 'pen',
					onSelect = function()
						local input = lib.inputDialog('Taghire Nam Unit', { { type = 'input', label = 'Esme Jadid', required = true, max = 20 } })
						if not input or not input[1] or input[1] == '' then
							lib.showContext('unit_main')
							return
						end
						TriggerServerEvent('esx_uniquejobs:renameUnit', input[1])
					end,
				}

				local memberOptions = {}
				for _, member in ipairs(unit.members) do
					memberOptions[#memberOptions + 1] = {
						title = member.name,
						description = 'Baraye Ekhraj Bezanid',
						icon = 'user-slash',
						onSelect = function()
							TriggerServerEvent('esx_uniquejobs:kickMember', member.identifier)
						end,
					}
				end
				if #memberOptions == 0 then
					memberOptions[#memberOptions + 1] = { title = 'Hich Ozvi Vojod Nadarad', disabled = true }
				end

				options[#options + 1] = {
					title = 'Modiriyate Azaa',
					icon = 'users',
					menu = 'unit_members',
				}
				lib.registerContext({ id = 'unit_members', title = 'Azaaye ' .. unit.callsign, menu = 'unit_main', options = memberOptions })

				options[#options + 1] = {
					title = 'Monhal Kardane Unit',
					icon = 'trash',
					onSelect = function()
						local alert = lib.alertDialog({
							header = 'Monhal Kardane Unit',
							content = 'Aya Mikhahid Vahede ' .. unit.callsign .. ' Monhal Shavad?',
							centered = true,
							cancel = true,
						})
						if alert == 'confirm' then
							TriggerServerEvent('esx_uniquejobs:disbandUnit')
						end
					end,
				}
			else
				options[#options + 1] = {
					title = 'Khoruj Az Unit',
					icon = 'right-from-bracket',
					onSelect = function()
						TriggerServerEvent('esx_uniquejobs:leaveUnit')
					end,
				}
			end
		else
			options[#options + 1] = {
				title = 'Sakhte Unit Jadid',
				icon = 'plus',
				onSelect = function()
					local input = lib.inputDialog('Sakhte Unit', { { type = 'input', label = 'Esme Unit', required = true, max = 20 } })
					if not input or not input[1] or input[1] == '' then
						lib.showContext('unit_main')
						return
					end
					TriggerServerEvent('esx_uniquejobs:createUnit', input[1])
				end,
			}

			local joinOptions = {}
			for _, unit in ipairs(data.allUnits) do
				joinOptions[#joinOptions + 1] = {
					title = unit.callsign,
					description = 'Leader: ' .. unit.ownerName .. ' | Members: ' .. unit.memberCount,
					icon = 'right-to-bracket',
					onSelect = function()
						TriggerServerEvent('esx_uniquejobs:joinUnit', unit.ownerIdentifier)
					end,
				}
			end
			if #joinOptions == 0 then
				joinOptions[#joinOptions + 1] = { title = 'Hich Vahedi Vojod Nadarad', disabled = true }
			end

			options[#options + 1] = {
				title = 'Peyvastan Be Unit',
				icon = 'right-to-bracket',
				menu = 'unit_join',
			}
			lib.registerContext({ id = 'unit_join', title = 'Peyvastan Be Unit', menu = 'unit_main', options = joinOptions })
		end

		local listOptions = {}
		for _, unit in ipairs(data.allUnits) do
			listOptions[#listOptions + 1] = {
				title = unit.callsign,
				description = 'Leader: ' .. unit.ownerName .. ' | Members: ' .. unit.memberCount,
				disabled = true,
			}
		end
		if #listOptions == 0 then
			listOptions[#listOptions + 1] = { title = 'Hich Vahedi Vojod Nadarad', disabled = true }
		end

		options[#options + 1] = {
			title = 'Liste Vahed Ha',
			icon = 'list',
			menu = 'unit_list',
		}
		lib.registerContext({ id = 'unit_list', title = data.deptLabel .. ' - Vahed Ha', menu = 'unit_main', options = listOptions })

		if data.canManage then
			local manageOptions = {}
			for _, unit in ipairs(data.allUnits) do
				manageOptions[#manageOptions + 1] = {
					title = unit.callsign,
					description = 'Leader: ' .. unit.ownerName .. ' | Members: ' .. unit.memberCount,
					icon = 'trash',
					onSelect = function()
						local alert = lib.alertDialog({
							header = 'Monhal Kardane Unit',
							content = 'Aya Mikhahid Vahede ' .. unit.callsign .. ' Monhal Shavad?',
							centered = true,
							cancel = true,
						})
						if alert == 'confirm' then
							TriggerServerEvent('esx_uniquejobs:forceDisbandUnit', unit.ownerIdentifier)
						end
					end,
				}
			end
			if #manageOptions == 0 then
				manageOptions[#manageOptions + 1] = { title = 'Hich Vahedi Vojod Nadarad', disabled = true }
			end

			options[#options + 1] = {
				title = 'Modiriyate Vahed Ha (Admin)',
				icon = 'shield',
				menu = 'unit_manage',
			}
			lib.registerContext({ id = 'unit_manage', title = 'Modiriyate Vahed Ha', menu = 'unit_main', options = manageOptions })
		end

		lib.registerContext({
			id = 'unit_main',
			title = data.deptLabel,
			options = options,
		})
		lib.showContext('unit_main')
	end)
end

RegisterCommand('unit', function()
	OpenUnitMenu()
end, false)

RegisterNetEvent('esx_uniquejobs:unitNotify')
AddEventHandler('esx_uniquejobs:unitNotify', function(deptId, message)
	local playerData = ESX.GetPlayerData()
	if not playerData or not playerData.job then return end

	local dept = GetDepartmentForJob(playerData.job.name)
	if dept and dept.id == deptId then
		TriggerEvent('chat:addMessage', { color = {0, 95, 254}, multiline = true, args = { "[ Dispatch ] (" .. dept.label .. ") : ", message } })
	end
end)
