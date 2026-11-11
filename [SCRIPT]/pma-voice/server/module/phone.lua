

function removePlayerFromCall(source, callChannel)
	logger.verbose('[call] Removed %s from call %s', source, callChannel)

	callData[callChannel] = callData[callChannel] or {}
	for player, _ in pairs(callData[callChannel]) do
		TriggerClientEvent('pma-voice:removePlayerFromCall', player, source)
	end
	callData[callChannel][source] = nil
	voiceData[source] = voiceData[source] or defaultTable(source)
	voiceData[source].call = 0
end

function addPlayerToCall(source, callChannel)
	logger.verbose('[call] Added %s to call %s', source, callChannel)


	callData[callChannel] = callData[callChannel] or {}
	for player, _ in pairs(callData[callChannel]) do

		if player ~= source then
			TriggerClientEvent('pma-voice:addPlayerToCall', player, source)
		end
	end
	callData[callChannel][source] = true
	voiceData[source] = voiceData[source] or defaultTable(source)
	voiceData[source].call = callChannel
	TriggerClientEvent('pma-voice:syncCallData', source, callData[callChannel])
end

function setPlayerCall(source, _callChannel)
	if GetConvarInt('voice_enableCalls', 1) ~= 1 then return end
	voiceData[source] = voiceData[source] or defaultTable(source)
	local isResource = GetInvokingResource()
	local plyVoice = voiceData[source]
	local callChannel = tonumber(_callChannel)
	if not callChannel then

		if isResource then
			error(("'callChannel' expected 'number', got: %s"):format(type(_callChannel)))
		else
			return logger.warn("%s sent a invalid call, 'callChannel' expected 'number', got: %s", source,
				type(_callChannel))
		end
	end
	if isResource then


		TriggerClientEvent('pma-voice:clSetPlayerCall', source, callChannel)
	end

	Player(source).state.callChannel = callChannel

	if callChannel ~= 0 and plyVoice.call == 0 then
		addPlayerToCall(source, callChannel)
	elseif callChannel == 0 then
		removePlayerFromCall(source, plyVoice.call)
	elseif plyVoice.call > 0 then
		removePlayerFromCall(source, plyVoice.call)
		addPlayerToCall(source, callChannel)
	end
end

exports('setPlayerCall', setPlayerCall)

RegisterNetEvent('pma-voice:setPlayerCall', function(callChannel)
	setPlayerCall(source, callChannel)
end)
