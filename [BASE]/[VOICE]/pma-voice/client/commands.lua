local wasProximityDisabledFromOverride = false
disableProximityCycle = false
RegisterCommand('setvoiceintent', function(source, args)
	if GetConvarInt('voice_allowSetIntent', 1) == 1 then
		local intent = args[1]
		if intent == 'speech' then
			MumbleSetAudioInputIntent(`speech`)
		elseif intent == 'music' then
			MumbleSetAudioInputIntent(`music`)
		end
		LocalPlayer.state:set('voiceIntent', intent, true)
	end
end)
TriggerEvent('chat:addSuggestion', '/setvoiceintent', 'Sets the players voice intent', {
	{
		name = "intent",
		help = "speech is default and enables noise suppression & high pass filter, music disables both of these."
	},
})

RegisterCommand('vol', function(_, args)
	if not args[1] then return end
	setVolume(tonumber(args[1]))
end)
TriggerEvent('chat:addSuggestion', '/vol', 'Sets the radio/phone volume', {
	{ name = "volume", help = "A range between 1-100 on how loud you want them to be" },
})

exports('setAllowProximityCycleState', function(state)
	type_check({ state, "boolean" })
	disableProximityCycle = state
end)

function setProximityState(proximityRange, isCustom)
	local voiceModeData = Cfg.voiceModes[mode]

	MumbleSetAudioInputDistance(proximityRange + 150.0)
	MumbleSetTalkerProximity(proximityRange + 0.0)
	LocalPlayer.state:set('proximity', {
		index = mode,
		distance = proximityRange,
		mode = isCustom and "Custom" or voiceModeData[2],
	}, true)
	sendUIMessage({

		voiceMode = isCustom and #Cfg.voiceModes or mode -1
	})
end

exports("overrideProximityRange", function(range, disableCycle)
	type_check({ range, "number" })
	setProximityState(range, true)
	if disableCycle then
		disableProximityCycle = true
		wasProximityDisabledFromOverride = true
	end
end)

exports("EnableMegaPhone", function(vol)
    EnableMegaPhone(vol)
end)

function EnableMegaPhone(vol)
    voiceMode = 4
    MumbleSetAudioInputDistance(vol + 0.0)

    mode = voiceMode
    LocalPlayer.state:set('proximity', {
        index = voiceMode,
        distance = vol,
        mode = "MegaPhone",
    }, GetConvarInt('voice_syncData', 1) == 1)
    SendNUIMessage({voiceMode = voiceMode - 1 })
    TriggerEvent('pma-voice:setTalkingMode', voiceMode)
end

function DisableMegaPhone()
    voiceMode = 2
    local voiceModeData = Cfg.voiceModes[voiceMode]
    MumbleSetAudioInputDistance(voiceModeData[1] + 0.0)
    mode = voiceMode
    LocalPlayer.state:set('proximity', {
        index = voiceMode,
        distance =  voiceModeData[1],
        mode = voiceModeData[2],
    }, GetConvarInt('voice_syncData', 1) == 1)
    SendNUIMessage({
        voiceMode = voiceMode - 1
    })
    TriggerEvent('pma-voice:setTalkingMode', voiceMode)
end

exports('DisableMegaPhone', DisableMegaPhone)

exports("clearProximityOverride", function()
	local voiceModeData = Cfg.voiceModes[mode]
	setProximityState(voiceModeData[1], false)
	MumbleSetAudioInputDistance(voiceModeData[1] + 0.0)
	if wasProximityDisabledFromOverride then
		disableProximityCycle = false
	end
end)

RegisterCommand('cycleproximity', function()

	if GetConvarInt('voice_enableProximityCycle', 1) ~= 1 or disableProximityCycle then return end
	local newMode = mode + 1


	if newMode <= #Cfg.voiceModes then
		mode = newMode
	else
		mode = 1
	end

	setProximityState(Cfg.voiceModes[mode][1], false)
	TriggerEvent('pma-voice:setTalkingMode', mode)
end, false)
if gameVersion == 'fivem' then
	RegisterKeyMapping('cycleproximity', 'Cycle Proximity', 'keyboard', GetConvar('voice_defaultCycle', 'F11'))
end
