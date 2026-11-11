local radioChannel = 0
local radioNames = {}
local disableRadioAnim = false

function isRadioEnabled()
	return radioEnabled and LocalPlayer.state.disableRadio == 0
end

function syncRadioData(radioTable, localPlyRadioName)
	radioData = radioTable
	logger.info('[radio] Syncing radio table.')
	if GetConvarInt('voice_debugMode', 0) >= 4 then
		print('-------- RADIO TABLE --------')
		tPrint(radioData)
		print('-----------------------------')
	end

	local isEnabled = isRadioEnabled()

	if isEnabled then
		handleRadioAndCallInit()
	end

	sendUIMessage({
		radioChannel = radioChannel,
		radioEnabled = isEnabled
	})
	if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
		radioNames[playerServerId] = localPlyRadioName
	end
end

RegisterNetEvent('pma-voice:syncRadioData', syncRadioData)

function setTalkingOnRadio(plySource, enabled)
	radioData[plySource] = enabled

	if not isRadioEnabled() then return logger.info("[radio] Ignoring setTalkingOnRadio. radioEnabled: %s disableRadio: %s", radioEnabled, LocalPlayer.state.disableRadio) end

	local enabled = enabled or callData[plySource]
	toggleVoice(plySource, enabled, 'radio')
	playMicClicks(enabled)
end
RegisterNetEvent('pma-voice:setTalkingOnRadio', setTalkingOnRadio)

function addPlayerToRadio(plySource, plyRadioName)
	radioData[plySource] = false
	if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
		radioNames[plySource] = plyRadioName
	end
	logger.info('[radio] %s joined radio %s %s', plySource, radioChannel,
		radioPressed and " while we were talking, adding them to targets" or "")
	if radioPressed then
		addVoiceTargets(radioData, callData)
	end
end
RegisterNetEvent('pma-voice:addPlayerToRadio', addPlayerToRadio)

function removePlayerFromRadio(plySource)
	if plySource == playerServerId then
		logger.info('[radio] Left radio %s, cleaning up.', radioChannel)
		for tgt, _ in pairs(radioData) do
			if tgt ~= playerServerId then
				toggleVoice(tgt, false, 'radio')
			end
		end
		sendUIMessage({
			radioChannel = 0,
			radioEnabled = radioEnabled
		})
		radioNames = {}
		radioData = {}
		addVoiceTargets(callData)
	else
		toggleVoice(plySource, false, 'radio')
		if radioPressed then
			logger.info('[radio] %s left radio %s while we were talking, updating targets.', plySource, radioChannel)
			addVoiceTargets(radioData, callData)
		else
			logger.info('[radio] %s has left radio %s', plySource, radioChannel)
		end
		radioData[plySource] = nil
		if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
			radioNames[plySource] = nil
		end
	end
end

RegisterNetEvent('pma-voice:removePlayerFromRadio', removePlayerFromRadio)

RegisterNetEvent('pma-voice:radioChangeRejected', function()
	logger.info("The server rejected your radio change.")
	radioChannel = 0
end)

function setRadioChannel(channel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	type_check({ channel, "number" })
	TriggerServerEvent('pma-voice:setPlayerRadio', channel)
	radioChannel = channel
end

exports('setRadioChannel', setRadioChannel)

exports('SetRadioChannel', setRadioChannel)

exports('removePlayerFromRadio', function()
	setRadioChannel(0)
end)

exports('addPlayerToRadio', function(_radio)
	local radio = tonumber(_radio)
	if radio then
		setRadioChannel(radio)
	end
end)

exports('toggleRadioAnim', function()
	disableRadioAnim = not disableRadioAnim
	TriggerEvent('pma-voice:toggleRadioAnim', disableRadioAnim)
end)

exports("setDisableRadioAnim", function(shouldDisable)
	disableRadioAnim = shouldDisable
end)

exports('getRadioAnimState', function()
	return disableRadioAnim
end)

function isDead()
	if LocalPlayer.state.isDead then
		return true
	elseif IsPlayerDead(PlayerId()) then
		return true
	end
	return false
end

function isRadioAnimEnabled()
	if
		GetConvarInt('voice_enableRadioAnim', 1) == 1
		and not (GetConvarInt('voice_disableVehicleRadioAnim', 0) == 1
			and IsPedInAnyVehicle(PlayerPedId(), false))
		and not disableRadioAnim then
		return true
	end
	return false
end

RegisterCommand('+radiotalk', function()
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	if isDead() then return end
	if not isRadioEnabled() then return end
	if not radioPressed then
		if radioChannel > 0 then
			logger.info('[radio] Start broadcasting, update targets and notify server.')
			addVoiceTargets(radioData, callData)
			TriggerServerEvent('pma-voice:setTalkingOnRadio', true)
			radioPressed = true
			local shouldPlayAnimation = isRadioAnimEnabled()
			playMicClicks(true)
			if shouldPlayAnimation then
				RequestAnimDict('random@arrests')
			end
			CreateThread(function()
				TriggerEvent("pma-voice:radioActive", true)
				LocalPlayer.state:set("radioActive", true, true);
				local checkFailed = false
				while radioPressed do
					if radioChannel < 0 or isDead() or not isRadioEnabled() then
						checkFailed = true
						break
					end
					if shouldPlayAnimation and HasAnimDictLoaded("random@arrests") then





					end
					SetControlNormal(0, 249, 1.0)
					SetControlNormal(1, 249, 1.0)
					SetControlNormal(2, 249, 1.0)
					Wait(0)
				end

				if checkFailed then
					logger.info("Canceling radio talking as the checks have failed.")
					ExecuteCommand("-radiotalk")
				end
				if shouldPlayAnimation then
					RemoveAnimDict('random@arrests')
				end
			end)
		else
			logger.info("Player tried to talk but was not on a radio channel")
		end
	end
end, false)

RegisterCommand('-radiotalk', function()
	if radioChannel > 0 and radioPressed then
		radioPressed = false
		MumbleClearVoiceTargetPlayers(voiceTarget)
		addVoiceTargets(callData)
		TriggerEvent("pma-voice:radioActive", false)
		LocalPlayer.state:set("radioActive", false, true);
		playMicClicks(false)
		if GetConvarInt('voice_enableRadioAnim', 1) == 1 then
			StopAnimTask(PlayerPedId(), "random@arrests", "generic_radio_enter", -4.0)
		end
		TriggerServerEvent('pma-voice:setTalkingOnRadio', false)
	end
end, false)
if gameVersion == 'fivem' then
	RegisterKeyMapping('+radiotalk', 'Talk over Radio', 'keyboard', GetConvar('voice_defaultRadio', 'M'))
end

function syncRadio(_radioChannel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	logger.info('[radio] radio set serverside update to radio %s', radioChannel)
	radioChannel = _radioChannel
end
RegisterNetEvent('pma-voice:clSetPlayerRadio', syncRadio)

function handleRadioEnabledChanged(wasRadioEnabled)
	if wasRadioEnabled then
		syncRadioData(radioData, "")
	else
		removePlayerFromRadio(playerServerId)
	end
end

local function addRadioDisableBit(bit)
	local curVal = LocalPlayer.state.disableRadio or 0
	curVal = curVal | bit
	LocalPlayer.state:set("disableRadio", curVal, true)
end
exports("addRadioDisableBit", addRadioDisableBit)

local function removeRadioDisableBit(bit)
	local curVal = LocalPlayer.state.disableRadio or 0
	curVal = curVal & (~bit)
	LocalPlayer.state:set("disableRadio", curVal, true)
end
exports("removeRadioDisableBit", removeRadioDisableBit)

