-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa


eu = false
AddEventHandler('onClientResourceStart', function(resource)
	if resource ~= GetCurrentResourceName() then
		return
	end
	print('Starting script initialization')
	eu = GetResourceKvpInt('vreg') == 1
	-- Some people modify pma-voice and mess up the resource Kvp, which means that if someone
	-- joins another server that has pma-voice, it will error out, this will catch and fix the kvp.
	local success = pcall(function()
		local micClicksKvp = GetResourceKvpString('pma-voice_enableMicClicks')
		if not micClicksKvp then
			SetResourceKvp('pma-voice_enableMicClicks', "true")
		else
			if micClicksKvp ~= 'true' and micClicksKvp ~= 'false' then
				error('Invalid Kvp, throwing error for automatic fix')
			end
			micClicks = micClicksKvp
		end
	end)

	if not success then
		logger.warn('Failed to load resource Kvp, likely was inappropriately modified by another server, resetting the Kvp.')
		SetResourceKvp('pma-voice_enableMicClicks', "true")
		micClicks = 'true'
	end
	sendUIMessage({
		uiEnabled = GetConvarInt("voice_enableUi", 1) == 1,
		voiceModes = json.encode(Cfg.voiceModes),
		voiceMode = mode - 1
	})

	local radioChannel = LocalPlayer.state.radioChannel or 0
	local callChannel = LocalPlayer.state.callChannel or 0

	-- Reinitialize channels if they're set.
	if radioChannel ~= 0 then
		setRadioChannel(radioChannel)
	end

	if callChannel ~= 0 then
		setCallChannel(callChannel)
	end

	print('Script initialization finished.')
	local try = 0
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(math.random(5000, 20000))
			if not MumbleIsConnected() and getServerIp() ~= '' then
				print('Reset voice')
				MumbleSetServerAddress(getServerIp(), GetConvarInt('voice_externalPort', 30120))
				try = try + 1
				if try > 2 then
					ESX.notification('error', 'اتصال صدا به مشکل خورده است, در حال تلاش برای اتصال')
					TriggerServerEvent('pma:reset')
					Wait(math.random(GetConvarInt('voice_externalTimeout', 40000), GetConvarInt('voice_externalTimeout2', 150000)))
				end
			else
				try = 0
			end
			if MumbleGetTalkerProximity() > 55 then
				ESX.alarm('sound range modifier ' + MumbleGetTalkerProximity())
			end
		end
	end)
end)

function getServerIp()
	-- if eu then
	-- 	return GetConvar('voice_externalAddressPr', '')
	-- else
	-- 	return GetConvar('voice_externalAddress', '')
	-- end
	return GetConvar('voice_externalAddress', '')
end