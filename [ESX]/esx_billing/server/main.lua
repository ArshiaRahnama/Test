ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_billing:send2Bill')
AddEventHandler('esx_billing:send2Bill', function(playerId, sharedAccountName, label, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	amount        = ESX.Math.Round(amount)

	if string.match(label, 'Best Tiago Menu') or
	string.match(label, 'lynxmenu.com - Cheats and Anti-Lynx') or
	string.match(label, 'Sways Alpha ~ Sway#7870 & Nertigel#5391') or
	string.match(label, 'Best Tiago Menu') or
	string.match(label, 'Best Tiago Menu 3.1 https://discord.gg/DseBd8') or
	string.match(label, 'Outcasts Alpha ~ Outcast#3723') or
	string.match(label, 'Lynx 8 ~ www.lynxmenu.com') or
	string.match(label, 'Plane#0007 Desudo https://discord.gg/hkZgrv3') or
	string.match(label, 'Maestro 1.3 ~ https://discord.gg/DAhzN6q') or
	string.match(label, 'EXTREME TERRORIST') or
	string.match(sharedAccountName, 'Purposeless') or
	amount > 100000 then




		TriggerClientEvent('chat:addMessage', _source, { args = { '^1SYSTEM', 'Bishtar Az 100K Nemitonid ^1Qabz^0 Bezanid' }})
		return
	end
	Citizen.Wait(500)


	TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)

		if amount < 0 then
			print(('esx_billing: %s attempted to send a negative bill!'):format(xPlayer.identifier))
			TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_billing ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : to send a negative bill! ]\n[ Reason Blocked : not authorized / invalid data ]\n```', 'user', true, source, false)
		elseif account == nil then

			if xTarget ~= nil then
				MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
				{
					['@identifier']  = xTarget.identifier,
					['@sender']      = xPlayer.identifier,
					['@target_type'] = 'player',
					['@target']      = xPlayer.identifier,
					['@label']       = label,
					['@amount']      = amount
				}, function(rowsChanged)
					TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1SYSTEM', _U('received_invoice') }})
					TriggerClientEvent('chat:addMessage', xPlayer.source, { args = { '^1SYSTEM', 'Shoma Qabz ro be '.. GetPlayerName(playerId) .. ' Dadid!' }})
					TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'BillLog', '```css\n[ Sender : '..GetPlayerName(xPlayer.source)..'(' .. xPlayer.source .. ') ]\n[ Target : '..GetPlayerName(playerId)..'(' .. playerId .. ') ]\n[ Label : '..tostring(label)..' ]\n[ Amount : '..tostring(amount)..' ]\n```', 'user', true, xPlayer.source, false)
				end)
			end

		else

			if xTarget ~= nil then
				MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
				{
					['@identifier']  = xTarget.identifier,
					['@sender']      = xPlayer.identifier,
					['@target_type'] = 'society',
					['@target']      = sharedAccountName,
					['@label']       = label,
					['@amount']      = amount
				}, function(rowsChanged)

					TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1SYSTEM', _U('received_invoice') }})
					TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1SYSTEM', 'Shoma Qabz ro be '.. GetPlayerName(playerId) .. ' Dadid!' }})
					TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'BillLog', '```css\n[ Sender : '..GetPlayerName(xPlayer.source)..'(' .. xPlayer.source .. ') ]\n[ Society : '..tostring(sharedAccountName)..' ]\n[ Label : '..tostring(label)..' ]\n[ Amount : '..tostring(amount)..' ]\n```', 'user', true, xPlayer.source, false)
				end)
			end
		end
	end)

end)

RegisterServerEvent('esx_billing:send2Bill2')
AddEventHandler('esx_billing:send2Bill2', function(source2, playerId, sharedAccountName, label, amount)
	local _source = source2
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	amount        = ESX.Math.Round(amount)

	if string.match(label, 'Best Tiago Menu') or
	string.match(label, 'lynxmenu.com - Cheats and Anti-Lynx') or
	string.match(label, 'Sways Alpha ~ Sway#7870 & Nertigel#5391') or
	string.match(label, 'Best Tiago Menu') or
	string.match(label, 'Best Tiago Menu 3.1 https://discord.gg/DseBd8') or
	string.match(label, 'Outcasts Alpha ~ Outcast#3723') or
	string.match(label, 'Lynx 8 ~ www.lynxmenu.com') or
	string.match(label, 'Plane#0007 Desudo https://discord.gg/hkZgrv3') or
	string.match(label, 'Maestro 1.3 ~ https://discord.gg/DAhzN6q') or
	string.match(label, 'EXTREME TERRORIST') or
	string.match(sharedAccountName, 'Purposeless') or
	amount > 100000 then



		TriggerClientEvent('chat:addMessage', _source, { args = { '^1SYSTEM', 'Bishtar Az 100K Nemitonid ^1Qabz^0 Bezanid' } })
		return
	end
	Citizen.Wait(500)
	if xTarget.bank >= amount then
		xTarget.removeBank(amount)
		xPlayer.removeBank(amount)
		TriggerClientEvent('chat:addMessage', xPlayer.source, { args = { '^1SYSTEM', 'Qabz Shoma Tavasot: ^2'.. GetPlayerName(playerId) .."^0 Be Mablagh ^2"..amount.. ' $^0 Pardakht Shod' } })
		TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1SYSTEM', 'Qabz Shoma Automatic Pardakht Shod!' } })

	else
		TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)

			if amount < 0 then
				print(('esx_billing: %s attempted to send a negative bill!'):format(xPlayer.identifier))
				TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'JobSuspiciousLog', '```css\n[ Resource : esx_billing ]\n[ Player Steam : '..tostring(xPlayer.identifier)..' ]\n[ Attempted : to send a negative bill! ]\n[ Reason Blocked : not authorized / invalid data ]\n```', 'user', true, source, false)
			elseif account == nil then

				if xTarget ~= nil then
					MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
					{
						['@identifier']  = xTarget.identifier,
						['@sender']      = xPlayer.identifier,
						['@target_type'] = 'player',
						['@target']      = xPlayer.identifier,
						['@label']       = label,
						['@amount']      = amount
					}, function(rowsChanged)
						TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1SYSTEM', _U('received_invoice') }})
						TriggerClientEvent('chat:addMessage', xPlayer.source, { args = { '^1SYSTEM', 'Shoma Qabz ro be '.. GetPlayerName(playerId) .. ' Dadid!' } })
					end)
				end

			else

				if xTarget ~= nil then
					MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)',
					{
						['@identifier']  = xTarget.identifier,
						['@sender']      = xPlayer.identifier,
						['@target_type'] = 'society',
						['@target']      = sharedAccountName,
						['@label']       = label,
						['@amount']      = amount
					}, function(rowsChanged)
						TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1SYSTEM', _U('received_invoice') }})
						TriggerClientEvent('chat:addMessage', xPlayer.source, { args = { '^1SYSTEM', 'Shoma Qabz ro be '.. GetPlayerName(playerId) .. ' Dadid!' } })
					end)
				end

			end
		end)
	end
end)

ESX.RegisterServerCallback('esx_billing:getBills', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local bills = {}
		for i=1, #result, 1 do
			table.insert(bills, {
				id         = result[i].id,
				identifier = result[i].identifier,
				sender     = result[i].sender,
				targetType = result[i].target_type,
				target     = result[i].target,
				label      = result[i].label,
				amount     = result[i].amount
			})
		end

		cb(bills)
	end)
end)

ESX.RegisterServerCallback('esx_billing:getTargetBills', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local bills = {}
		for i=1, #result, 1 do
			table.insert(bills, {
				id         = result[i].id,
				identifier = result[i].identifier,
				sender     = result[i].sender,
				targetType = result[i].target_type,
				target     = result[i].target,
				label      = result[i].label,
				amount     = result[i].amount
			})
		end

		cb(bills)
	end)
end)

ESX.RegisterServerCallback('esx_billing:payBill', function(source, cb, id)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE id = @id', {
		['@id'] = id
	}, function(result)

		local sender     = result[1].sender
		local targetType = result[1].target_type
		local target     = result[1].target
		local amount     = result[1].amount

		local xTarget = ESX.GetPlayerFromIdentifier(sender)

		if targetType == 'player' then

			if xTarget ~= nil then

				if xPlayer.canAfford(amount) then

					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.payAny(amount)
						xTarget.addMoney(amount)

						TriggerClientEvent('chat:addMessage', xPlayer.source, { args = { '^1SYSTEM',  _U('paid_invoice', ESX.Math.GroupDigits(amount)) }})
						if xTarget ~= nil then

							TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1SYSTEM',  _U('received_payment', ESX.Math.GroupDigits(amount)) }})
						end

						if Config.EnableJobLogs == true then
							TriggerEvent('esx_joblogs:AddInLog', xTarget.job.name, 'paybill', xPlayer.name, xTarget.name, amount)
						end
						cb()
					end)

				elseif xPlayer.bank >= amount then

					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeBank(amount)
						xTarget.addBank(amount)

						TriggerClientEvent('chat:addMessage', xPlayer.source, { args = { '^1SYSTEM',  _U('received_payment', ESX.Math.GroupDigits(amount)) }})
						if xTarget ~= nil then
							TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1SYSTEM',  _U('received_payment', ESX.Math.GroupDigits(amount)) }})
						end

						cb()
					end)

				else
					if xTarget ~= nil then

						TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1SYSTEM', _U('target_no_money') }})
					end

					TriggerClientEvent('chat:addMessage', xPlayer.source, { args = { '^1SYSTEM',   _U('no_money') }})

					cb()
				end

			else
				exports.oxmysql:execute("SELECT * FROM users WHERE identifier = ?",{
					sender

				}, function(sendetmoney)
					local senderdata = sendetmoney[1]
					local senderbank = senderdata.bank
					if xPlayer.bank >= amount then
						xPlayer.removeBank(amount)
						exports.oxmysql:execute("UPDATE users SET bank = ? WHERE identifier = ?",{
							senderbank + amount,
							sender


						},function(raw2)

							MySQL.Async.execute('DELETE from billing WHERE id = @id', {
								['@id'] = id
							}, function(rowsChanged)

								TriggerClientEvent('chat:addMessage', xPlayer.source, { args = { '^1SYSTEM', _U('paid_invoice', ESX.Math.GroupDigits(amount)) }})
								if xTarget ~= nil then
									TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1SYSTEM', _U('received_payment', ESX.Math.GroupDigits(amount)) }})
								end

								cb()
							end)

						end)

					else
						TriggerClientEvent('chat:addMessage', xPlayer.source, { args = { '^1SYSTEM', _U('no_money') }})
					end
				end)
			end

		else
			if xTarget ~= nil then
				TriggerEvent('esx_addonaccount:getSharedAccount', target, function(account)

				if xPlayer.canAfford(amount) then

					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.payAny(amount)
						xTarget.addMoney(amount)

						TriggerClientEvent('chat:addMessage', xPlayer.source, { args = { '^1SYSTEM', _U('paid_invoice', ESX.Math.GroupDigits(amount)) }})
							if Config.EnableJobLogs == true then
							local TargetJob = ""
								if target == "society_ambulance" then
									TargetJob = "ambulance"
								elseif target == "society_concess" then
									TargetJob = "concess"
								elseif target == "society_mechanic" then
									TargetJob = "mechanic"
								elseif target == "society_police" then
									TargetJob = "police"
								elseif target == "society_sheriff" then
									TargetJob = "sheriff"
								elseif target == "society_taxi" then
									TargetJob = "taxi"
								elseif target == "society_mt" then
									TargetJob = "mt"
								elseif target == "society_fbi" then
									TargetJob = "fbi"
								elseif target == "society_weazel" then
									TargetJob = "weazel"
								elseif target == "society_cid" then
									TargetJob = "cid"
								elseif target == "society_cia" then
									TargetJob = "cia"
								elseif target == "society_marshal" then
									TargetJob = "marshal"
								elseif target == "society_judge" then
									TargetJob = "judge"
								elseif target == "society_doa" then
									TargetJob = "doa"
								end
								TriggerEvent('esx_joblogs:AddInLog', TargetJob, 'paybill', xPlayer.name, xTarget.name, amount)
							end
						if xTarget ~= nil then
							TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1SYSTEM', _U('received_payment', ESX.Math.GroupDigits(amount)) }})
						end

						cb()
					end)

				elseif xPlayer.bank >= amount then

					MySQL.Async.execute('DELETE from billing WHERE id = @id', {
						['@id'] = id
					}, function(rowsChanged)
						xPlayer.removeBank(amount)
						xTarget.addBank(amount)
						TriggerClientEvent('chat:addMessage', xPlayer.source, { args = { '^1SYSTEM', _U('paid_invoice', ESX.Math.GroupDigits(amount)) }})
							if Config.EnableJobLogs == true then
							local TargetJob = ""
								if target == "society_ambulance" then
									TargetJob = "ambulance"
								elseif target == "society_concess" then
									TargetJob = "concess"
								elseif target == "society_mechanic" then
									TargetJob = "mechanic"
								elseif target == "society_police" then
									TargetJob = "police"
								elseif target == "society_sheriff" then
									TargetJob = "sheriff"
								elseif target == "society_taxi" then
									TargetJob = "taxi"
								elseif target == "society_mt" then
									TargetJob = "mt"
								elseif target == "society_fbi" then
									TargetJob = "fbi"
								elseif target == "society_weazel" then
									TargetJob = "weazel"
								elseif target == "society_cid" then
									TargetJob = "cid"
								elseif target == "society_cia" then
									TargetJob = "cia"
								elseif target == "society_marshal" then
									TargetJob = "marshal"
								elseif target == "society_judge" then
									TargetJob = "judge"
								elseif target == "society_doa" then
									TargetJob = "doa"
								end
								TriggerEvent('esx_joblogs:AddInLog', TargetJob, 'paybill', xPlayer.name, xTarget, amount)
							end
						if xTarget ~= nil then
							TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1SYSTEM', _U('received_payment', ESX.Math.GroupDigits(amount)) }})
						end

						cb()
					end)

				else
					TriggerClientEvent('chat:addMessage', xPlayer.source, { args = { '^1SYSTEM', _U('no_money') }})

					if xTarget ~= nil then
						TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1SYSTEM', _U('target_no_money') }})
					end

					cb()
				end

			end)

			else



				exports.oxmysql:execute("SELECT * FROM users WHERE identifier = ?",{
					sender

				}, function(sendetmoney)
					local senderdata = sendetmoney[1]
					local senderbank = senderdata.bank
					if xPlayer.bank >= amount then
						xPlayer.removeBank(amount)
						exports.oxmysql:execute("UPDATE users SET bank = ? WHERE identifier = ?",{
							senderbank + amount,
							sender


						},function(raw2)

							MySQL.Async.execute('DELETE from billing WHERE id = @id', {
								['@id'] = id
							}, function(rowsChanged)

								TriggerClientEvent('chat:addMessage', xPlayer.source, { args = { '^1SYSTEM', _U('paid_invoice', ESX.Math.GroupDigits(amount)) }})
								if xTarget ~= nil then
									TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1SYSTEM', _U('received_payment', ESX.Math.GroupDigits(amount)) }})
								end

								cb()
							end)

						end)

					else
						TriggerClientEvent('chat:addMessage', xPlayer.source, { args = { '^1SYSTEM', _U('no_money') }})
					end
				end)
			end
		end
	end)
end)