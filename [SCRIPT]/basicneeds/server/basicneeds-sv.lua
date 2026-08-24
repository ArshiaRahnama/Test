ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('bread', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('bread', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 50000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:ShowNotification', source, _U('used_bread'))
end)

ESX.RegisterUsableItem('macka', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('macka', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 500000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Sandwitch~w~ Khordid")
end)

ESX.RegisterUsableItem('burger', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('burger', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 50000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Burger~w~ Khordid")
end)

ESX.RegisterUsableItem('pizza', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('pizza', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 500000)
	TriggerClientEvent('esx_basicneeds:onEat', source)
	TriggerClientEvent('esx:ShowNotification', source, "Shoma Yek ~y~Pitza~w~ Khordid")
end)

ESX.RegisterUsableItem('water', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('water', 1)

	TriggerClientEvent('esx_status:add', source, 'thirst', 50000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	TriggerClientEvent('esx:ShowNotification', source, _U('used_water'))
end)

TriggerEvent('es:addAdminCommand', 'heal', 2, function(source, args, user)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.get('aduty') then


		if args[1] then
		local playerId = tonumber(args[1])


		if playerId then

			if GetPlayerName(playerId) then

				TriggerEvent('DiscordBot:ToDiscord', 'heal', "Healed By Admin", "```css\n[ Admin : " .. GetPlayerName(source) .. " Heal Player: "..playerId.." Full Kard ]\n```",'user', source, true, false)
				TriggerClientEvent('esx_basicneeds:healPlayer', playerId)
				TriggerClientEvent('chat:addMessage', source, { args = { '^5HEAL', 'You have been healed.' } })
			else
				TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Player not online.' } })
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Invalid player id.' } })
		end
	else

		TriggerClientEvent('esx_basicneeds:healPlayer', source)
		TriggerEvent('DiscordBot:ToDiscord', 'heal', "Healed By Admin", "```css\n[ Admin : " .. GetPlayerName(source) .. " Heal Player: Khod Ra Full Kard ]\n```",'user', source, true, false)
		TriggerClientEvent('chat:addMessage', source, { args = { '^5HEAL', 'You have been healed.' } })
	end

	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!")
	end
end, function(source, args, user)
	TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, {help = 'Heal a player, or yourself - restores thirst, hunger and health.', params = {{name = 'playerId', help = '(optional) player id'}}})

RegisterCommand("healrange", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.permission_level >= 2 then
        if xPlayer.get("aduty") then
            if not args[1] or tonumber(args[1]) == nil then
                TriggerClientEvent("chatMessage", source, "[SYSTEM]", {255, 0, 0}, " ^0Lotfan yek range dorost vared konid!")
                return
            end

            local range = tonumber(args[1])
            local playerPed = GetPlayerPed(source)
            local playerCoords = GetEntityCoords(playerPed)
            local healedCount = 0

            for _, playerId in ipairs(GetPlayers()) do
                if playerId ~= source then
                    local targetPed = GetPlayerPed(playerId)
                    local targetCoords = GetEntityCoords(targetPed)

                    if #(playerCoords - targetCoords) <= range then
                        TriggerClientEvent('esx_basicneeds:healPlayer', playerId)
                        healedCount = healedCount + 1
                        TriggerEvent('DiscordBot:ToDiscord', 'heal', "Healed By Admin", "```css\n[ Admin : " .. GetPlayerName(source) .. " Heal Player: " .. playerId .. " in Range ]\n```", 'user', source, true, false)

                        TriggerClientEvent(
                            'chat:addMessage',
                            playerId,
                            { args = { '^5HEAL', 'You have been healed by an admin.' } }
                        )
                    end
                end
            end

            if healedCount > 0 then
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {0, 255, 0},
                    " ^0Tedad ^2" .. healedCount .. " ^0nafar heal shodand!"
                )
            else
                TriggerClientEvent(
                    "chatMessage",
                    source,
                    "[SYSTEM]",
                    {255, 0, 0},
                    " ^0Hich kasi dar range mored nazar nist!"
                )
            end
        else
            TriggerClientEvent(
                "chatMessage",
                source,
                "[SYSTEM]",
                {255, 0, 0},
                " ^0Shoma nemitavanid dar halat ^1OffDuty ^0az command haye admini estefade konid!"
            )
        end
    else
        TriggerClientEvent(
            "chatMessage",
            source,
            "[SYSTEM]",
            {255, 0, 0},
            " ^0Shoma ^1Admin ^0nistid!"
        )
    end
end, false)
