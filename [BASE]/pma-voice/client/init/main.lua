local mutedPlayers = {}

local volumes = {

	['radio'] = GetConvarInt('voice_defaultRadioVolume', 60) / 100,
	['call'] = GetConvarInt('voice_defaultCallVolume', 60) / 100,
	['click_on'] = GetConvarInt('voice_onClickVolume', 10) / 100,
	['click_off'] = GetConvarInt('voice_offClickVolume', 3) / 100,
}

radioEnabled, radioPressed, mode = true, false, GetConvarInt('voice_defaultVoiceMode', 2)
radioData = {}
callData = {}
submixIndicies = {}

function setVolume(volume, volumeType)
	type_check({ volume, "number" })
	local volumeFraction = volume / 100

	if volumeType then
		local volumeTbl = volumes[volumeType]
		if volumeTbl then
			LocalPlayer.state:set(volumeType, volume, true)
			volumes[volumeType] = volumeFraction
			resyncVolume(volumeType, volumeFraction)
		else
			error(('setVolume got a invalid volume type %s'):format(volumeType))
		end
	else
		for volumeType, _ in pairs(volumes) do
			volumes[volumeType] = volumeFraction
			LocalPlayer.state:set(volumeType, volume, true)
		end
		resyncVolume("all", volumeFraction)
	end
end

exports('setRadioVolume', function(vol)
	setVolume(vol, 'radio')
end)
exports('getRadioVolume', function()
	return volumes['radio'] * 100
end)
exports("setCallVolume", function(vol)
	setVolume(vol, 'call')
end)
exports('getCallVolume', function()
	return volumes['call'] * 100
end)

local radioEffectId = CreateAudioSubmix('Radio')
SetAudioSubmixEffectRadioFx(radioEffectId, 0)

SetAudioSubmixEffectParamInt(radioEffectId, 0, GetHashKey('default'), 1)
SetAudioSubmixOutputVolumes(
	radioEffectId,
	0,
	1.0 ,
	0.25 ,
	0.0 ,
	0.0 ,
	1.0 ,
	1.0
)
AddAudioSubmixOutput(radioEffectId, 0)
submixIndicies['radio'] = radioEffectId

local callEffectId = CreateAudioSubmix('Call')
SetAudioSubmixOutputVolumes(
	callEffectId,
	1,
	0.10 ,
	0.50 ,
	0.0 ,
	0.0 ,
	1.0 ,
	1.0
)
AddAudioSubmixOutput(callEffectId, 1)
submixIndicies['call'] = callEffectId

exports("registerCustomSubmix", function(callback)
	local submixTable = callback()
	type_check({ submixTable, "table" })
	local submixName, submixId = submixTable[1], submixTable[2]
	type_check({ submixName, "string" }, { submixId, "number" })
	logger.info("Creating submix %s with submixId %s", submixName, submixId)
	submixIndicies[submixName] = submixId
end)
TriggerEvent("pma-voice:registerCustomSubmixes")

exports("setEffectSubmix", function(type, effectId)
	type_check({ type, "string" }, { effectId, "number" })
	if submixIndicies[type] then
		submixIndicies[type] = effectId
	end
end)

function restoreDefaultSubmix(plyServerId)
	local submix = Player(plyServerId).state.submix
	local submixEffect = submixIndicies[submix]
	if not submix or not submixEffect then
		MumbleSetSubmixForServerId(plyServerId, -1)
		return
	end
	MumbleSetSubmixForServerId(plyServerId, submixEffect)
end

local disableSubmixReset = {}

function toggleVoice(plySource, enabled, moduleType)
	if mutedPlayers[plySource] then return end
	logger.verbose('[main] Updating %s to talking: %s with submix %s', plySource, enabled, moduleType)
	local distance = currentTargets[plySource]
	if enabled and (not distance or distance > 4.0) then
		print(volumes[moduleType])
		MumbleSetVolumeOverrideByServerId(plySource, enabled and volumes[moduleType])
		if GetConvarInt('voice_enableSubmix', 1) == 1 then
			if moduleType then
				disableSubmixReset[plySource] = true
				if submixIndicies[moduleType] then
					MumbleSetSubmixForServerId(plySource, submixIndicies[moduleType])
				end
			else
				restoreDefaultSubmix(plySource)
			end
		end
	elseif not enabled then
		if GetConvarInt('voice_enableSubmix', 1) == 1 then

			disableSubmixReset[plySource] = nil
			SetTimeout(250, function()
				if not disableSubmixReset[plySource] then
					restoreDefaultSubmix(plySource)
				end
			end)
		end
		MumbleSetVolumeOverrideByServerId(plySource, -1.0)
	end
end

local function updateVolumes(voiceTable, override)
	for serverId, talking in pairs(voiceTable) do
		if serverId == playerServerId then goto skip_iter end
		MumbleSetVolumeOverrideByServerId(serverId, talking and override or -1.0)
		::skip_iter::
	end
end

function resyncVolume(volumeType, newVolume)
	if volumeType == "all" then
		resyncVolume("radio", newVolume)
		resyncVolume("call", newVolume)
	elseif volumeType == "radio" then
		updateVolumes(radioData, newVolume)
	elseif volumeType == "call" then
		updateVolumes(callData, newVolume)
	end
end

function addVoiceTargets(...)
	local targets = { ... }
	local addedPlayers = {
		[playerServerId] = true
	}

	for i = 1, #targets do
		for id, _ in pairs(targets[i]) do

			if addedPlayers[id] and id ~= playerServerId then
				logger.verbose('[main] %s is already target don\'t re-add', id)
				goto skip_loop
			end
			if not addedPlayers[id] then
				logger.verbose('[main] Adding %s as a voice target', id)
				addedPlayers[id] = true
				MumbleAddVoiceTargetPlayerByServerId(voiceTarget, id)
			end
			::skip_loop::
		end
	end
end

function playMicClicks(clickType)
	if micClicks ~= 'true' then return logger.verbose("Not playing mic clicks because client has them disabled") end

	sendUIMessage({
		sound = (clickType and "audio_on" or "audio_off"),
		volume = (clickType and volumes['click_on'] or volumes['click_off'])
	})
end

exports('isPlayerMuted', function(source)
	return mutedPlayers[source]
end)

exports('getMutedPlayers', function()
	return mutedPlayers
end)

function toggleMutePlayer(source)
	if mutedPlayers[source] then
		mutedPlayers[source] = nil
		MumbleSetVolumeOverrideByServerId(source, -1.0)
	else
		mutedPlayers[source] = true
		MumbleSetVolumeOverrideByServerId(source, 0.0)
	end
end

exports('toggleMutePlayer', toggleMutePlayer)

function setVoiceProperty(type, value)
	if type == "radioEnabled" then
		radioEnabled = value
		handleRadioEnabledChanged(value)
		sendUIMessage({
			radioEnabled = value
		})
	elseif type == "micClicks" then
		local val = tostring(value)
		micClicks = val
		SetResourceKvp('pma-voice_enableMicClicks', val)
	end
end

exports('setVoiceProperty', setVoiceProperty)

exports('SetMumbleProperty', setVoiceProperty)
exports('SetTokoProperty', setVoiceProperty)

local externalAddress = ''
local externalPort = 0
CreateThread(function()
	while true do
		Wait(500)

		if GetConvar('voice_externalAddress', '') ~= externalAddress or GetConvarInt('voice_externalPort', 0) ~= externalPort then
			externalAddress = GetConvar('voice_externalAddress', '')
			externalPort = GetConvarInt('voice_externalPort', 0)
			MumbleSetServerAddress(GetConvar('voice_externalAddress', ''), GetConvarInt('voice_externalPort', 0))
		end
	end
end)

if gameVersion == 'redm' then
	CreateThread(function()
		while true do
			if IsControlJustPressed(0, 0xA5BDCD3C ) then
				ExecuteCommand('cycleproximity')
			end
			if IsControlJustPressed(0, 0x430593AA ) then
				ExecuteCommand('+radiotalk')
			elseif IsControlJustReleased(0, 0x430593AA ) then
				ExecuteCommand('-radiotalk')
			end

			Wait(0)
		end
	end)
end

function handleRadioAndCallInit()
	for tgt, enabled in pairs(radioData) do
		if tgt ~= playerServerId then
			toggleVoice(tgt, enabled, 'radio')
		end
	end

	for tgt, enabled in pairs(callData) do
		if tgt ~= playerServerId then
			toggleVoice(tgt, true, 'call')
		end
	end
end
