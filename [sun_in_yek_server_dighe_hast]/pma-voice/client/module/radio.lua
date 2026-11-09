-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local radioChannel = 0
local radioNames = {}
local radioData2 = {}
local isVip = false;
--- event syncRadioData
--- syncs the current players on the radio to the client
---@param radioTable table the table of the current players on the radio
local blipThread = false
local nearBlips = {}
local __ = {
	['police'] = true,
	['sheriff'] = true,
	['mt'] = true,
	['fbi'] = true,
	['justice'] = true,
	['detective'] = true,
	['taxi'] = true,
	['weazel'] = true,
	['mechanic'] = true,
	['ambulance'] = true,
}
---@param localPlyRadioName string the local players name
function syncRadioData(radioTable, localPlyRadioName, _radioNames, _isVip)
	radioNames = _radioNames
	radioData = radioTable
	radioData2 = {}
	for k, v in pairs(radioData) do
		if k ~= ESX.src then
			radioData2[k] = {
				talking = v,
				name = radioNames[k]
			}
		end
	end

	logger.info('[radio] Syncing radio table.')
	if GetConvarInt('voice_debugMode', 0) >= 4 then
		print('-------- RADIO TABLE --------')
		tPrint(radioData)
		print('-----------------------------')
	end
	for tgt, enabled in pairs(radioTable) do
		if tgt ~= playerServerId then
			toggleVoice(tgt, enabled, 'radio')
		end
	end
	-- if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
	-- 	radioNames[playerServerId] = localPlyRadioName
	-- end
	isVip = _isVip
	exports['sun-ui']:updateIndicators("radio", radioData2, isVip)
end
RegisterNetEvent('pma-voice:syncRadioData', syncRadioData)

--- event setTalkingOnRadio
--- sets the players talking status, triggered when a player starts/stops talking.
---@param plySource number the players server id.
---@param enabled boolean whether the player is talking or not.
function setTalkingOnRadio(plySource, enabled)
	toggleVoice(plySource, enabled, 'radio')
	radioData[plySource] = enabled
	radioData2[plySource].talking = enabled
	playMicClicks(enabled)
	exports['sun-ui']:updateIndicators("radio", radioData2, isVip)
end
RegisterNetEvent('pma-voice:setTalkingOnRadio', setTalkingOnRadio)

--- event addPlayerToRadio
--- adds a player onto the radio.
---@param plySource number the players server id to add to the radio.
function addPlayerToRadio(plySource, plyRadioName)
	radioData[plySource] = false
	-- if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
	radioNames[plySource] = plyRadioName
	radioData2[plySource] = {talking = false, name = plyRadioName}
	-- end
	if radioPressed then
		logger.info('[radio] %s joined radio %s while we were talking, adding them to targets', plySource, radioChannel)
		playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
	else
		logger.info('[radio] %s joined radio %s', plySource, radioChannel)
	end
	if not ESX.militaryJobs2[ESX.GetPlayerData().job.name] then
		TriggerEvent('chatMessage',"[Radio]", {255, 215, 0}, " ^0".. plyRadioName .. "(".. plySource ..") be frq radio ^2join^0 shod!", 'plarms')
	end
	exports['sun-ui']:updateIndicators("radio", radioData2, isVip)
end
RegisterNetEvent('pma-voice:addPlayerToRadio', addPlayerToRadio)

--- event removePlayerFromRadio
--- removes the player (or self) from the radio
---@param plySource number the players server id to remove from the radio.
function removePlayerFromRadio(plySource)
	if plySource == playerServerId then
		logger.info('[radio] Left radio %s, cleaning up.', radioChannel)
		for tgt, _ in pairs(radioData) do
			if tgt ~= playerServerId then
				toggleVoice(tgt, false, 'radio')
			end
		end
		radioNames = {}
		radioData = {}
		radioData2 = {}
		playerTargets(MumbleIsPlayerTalking(PlayerId()) and callData or {})
	else
		toggleVoice(plySource, false)
		if radioPressed then
			logger.info('[radio] %s left radio %s while we were talking, updating targets.', plySource, radioChannel)
			playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
		else
			logger.info('[radio] %s has left radio %s', plySource, radioChannel)
		end
		radioData[plySource] = nil
		radioData2[plySource] = nil
		-- if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
		-- 	radioNames[plySource] = nil
		-- end
		if not ESX.militaryJobs2[ESX.GetPlayerData().job.name] then
			TriggerEvent('chatMessage',"[Radio]", {255, 215, 0}, " ^0".. radioNames[plySource] .. "(".. plySource ..") az frq radio ^1kharej^0 shod!", 'plarms')
		end
	end
	exports['sun-ui']:updateIndicators("radio", radioData2)
end
RegisterNetEvent('pma-voice:removePlayerFromRadio', removePlayerFromRadio)

--- function setRadioChannel
--- sets the local players current radio channel and updates the server
---@param channel number the channel to set the player to, or 0 to remove them.
function setRadioChannel(channel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	TriggerServerEvent('pma-voice:setPlayerRadio', channel)
end

--- exports setRadioChannel
--- sets the local players current radio channel and updates the server
---@param channel number the channel to set the player to, or 0 to remove them.
exports('setRadioChannel', setRadioChannel)
-- mumble-voip compatability
exports('SetRadioChannel', setRadioChannel)

--- exports removePlayerFromRadio
--- sets the local players current radio channel and updates the server
exports('removePlayerFromRadio', function()
	setRadioChannel(0)
end)

--- exports addPlayerToRadio
--- sets the local players current radio channel and updates the server
---@param radio number the channel to set the player to, or 0 to remove them.
exports('addPlayerToRadio', function(_radio)
	local radio = tonumber(_radio)
	if radio then
		setRadioChannel(radio)
	end
end)

--- check if the player is dead
--- seperating this so if people use different methods they can customize
--- it to their need as this will likely never be changed.
function isDead()
	if GetResourceState("pma-ambulance") ~= "missing" then
		if LocalPlayer.state.isDead then
			return true
		end
	elseif IsPlayerDead(PlayerId()) then
		return true
	end
end

AddEventHandler("onKeyDown", function(key)
	if key == "m" and not playerMuted and ESX.GetPlayerData()['IsDead'] ~= 1 then

	if not radioPressed and radioEnabled then
		if radioChannel > 0 then
			logger.info(('[radio] Start broadcasting, update targets and notify server.'))
			playerTargets(radioData, NetworkIsPlayerTalking(PlayerId()) and callData or {})
			TriggerServerEvent('pma-voice:setTalkingOnRadio', true)
			radioPressed = true
			playMicClicks(true)
			-- if GetConvarInt('voice_enableRadioAnim', 0) == 1 then
			-- 	RequestAnimDict('random@arrests')
			-- 	while not HasAnimDictLoaded('random@arrests') do
			-- 		Citizen.Wait(10)
			-- 	end
			-- 	TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0)
			-- end
			Citizen.CreateThread(function()
				TriggerEvent("pma-voice:radioActive", true)
				while radioPressed do
					Wait(0)
					SetControlNormal(0, 249, 1.0)
					SetControlNormal(1, 249, 1.0)
					SetControlNormal(2, 249, 1.0)
				end
			end)
		end
	end

   end
end)

AddEventHandler("onKeyUP", function(key)
	if key == "m" and radioPressed then
		radioPressed = false
		MumbleClearVoiceTargetPlayers(1)
		playerTargets(NetworkIsPlayerTalking(PlayerId()) and callData or {})
		TriggerEvent("pma-voice:radioActive", false)
		playMicClicks(false)
		-- if GetConvarInt('voice_enableRadioAnim', 0) == 1 then
		-- 	StopAnimTask(PlayerPedId(), "random@arrests", "generic_radio_enter", -4.0)
		-- end
		TriggerServerEvent('pma-voice:setTalkingOnRadio', false)
	end
end)


-- if gameVersion == 'fivem' then
-- 	RegisterKeyMapping('+radiotalk', 'Talk over Radio', 'keyboard', GetConvar('voice_defaultRadio', 'LMENU'))
-- end

--- event syncRadio
--- syncs the players radio, only happens if the radio was set server side.
---@param _radioChannel number the radio channel to set the player to.
function syncRadio(_radioChannel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	logger.info('[radio] radio set serverside update to radio %s', radioChannel)
	if _radioChannel ~= 0 then
		TriggerServerEvent('3dme:shareDisplay2', "Dastesho mibare be samte radio va freq ro avaz mikone", true)
	end
	radioChannel = _radioChannel
	if GetConvarInt('voice_enableUi', 1) == 1 then
		SendNUIMessage({
			radioChannel = _radioChannel,
			radioEnabled = radioEnabled
		})
	end
	if not __[ESX.GetPlayerData().job.name] then
		if _radioChannel == 0 then
			blipThread = false
			for k , v in pairs(nearBlips) do
				RemoveBlip(v.blip)
				nearBlips[k] = nil
			end
		elseif not blipThread then
			for k , v in pairs(nearBlips) do
				RemoveBlip(v.blip)
				nearBlips[k] = nil
			end
			blipThread = true
			blipStuff()
		end
	end
end
RegisterNetEvent('pma-voice:clSetPlayerRadio', syncRadio)


function blipStuff()
	Citizen.CreateThread(function()
		while blipThread do
			for k , v in pairs(nearBlips) do
				v.check = false
			end
			for k , v in pairs(GetActivePlayers()) do
				if v ~= PlayerId() then
					local id = GetPlayerServerId(v)
					if radioData[id] ~= nil then
						local ped = GetPlayerPed(v)
						if not nearBlips[id] then
							local blip = AddBlipForEntity(ped)
							SetBlipAlpha(blip, 180)
							SetBlipSprite(blip, 1)
							SetBlipScale(blip, 0.8)
							SetBlipShrink(blip, 1)
							SetBlipCategory(blip, 7)
							SetBlipDisplay(blip, 6)				
							SetBlipColour(blip, 1)
							BeginTextCommandSetBlipName("STRING")
							AddTextComponentString(GetPlayerName(v))
							EndTextCommandSetBlipName(blip)		
							nearBlips[id] = {}
							nearBlips[id].blip = blip
							nearBlips[id].entity = true
							nearBlips[id].check = true
						elseif DoesBlipExist(nearBlips[id].blip) then
							nearBlips[id].check = true
						end
					end
				end
			end
			for k , v in pairs(nearBlips) do
				if v.blip and not v.check then
					RemoveBlip(v.blip)
					nearBlips[k] = nil
				end
			end
			Citizen.Wait(5000)
		end
	end)
end

local TempBlip = {}
local ClearId = 0
AddEventHandler('radio:ShowGPS',function()
	if ESX.TableLength(radioData) == 0 then return ESX.Alert('Error','Bisim shoma khamush ast!',5000,'error') end
	for k , v in pairs(TempBlip) do
		RemoveBlip(v)
		TempBlip[k] = nil
	end
	ESX.ClearTimeout(ClearId)
	for k , v in pairs(radioData) do
		local id = k 
		if not nearBlips[k] and id ~= playerServerId then
			ESX.TriggerServerCallback('getplayercoords', function(coords)
				if coords ~= nil then
					blip = AddBlipForCoord(coords.x, coords.y, coords.z)
					SetBlipAlpha(blip, 180)
					SetBlipSprite(blip, 1)
					SetBlipScale(blip, 0.8)
					SetBlipShrink(blip, 1)
					SetBlipCategory(blip, 7)
					SetBlipDisplay(blip, 6)	
					SetBlipColour(blip, 1)
					-- BeginTextCommandSetBlipName("STRING")
					-- AddTextComponentString(tostring(id))
					-- BeginTextCommandSetBlipName("STRING")
					-- AddTextComponentString(tostring(id))
					-- EndTextCommandSetBlipName(blip)
					TempBlip[id] = blip
				end
			end,id)
		end
	end
	ClearId = ESX.SetTimeout(60000,function()
		for k , v in pairs(TempBlip) do
			RemoveBlip(v)
			TempBlip[k] = nil
		end
	end)
end)

local alertCD = false
AddEventHandler('radio:sendAlert',function()
	if ESX.TableLength(radioData) == 0 then return ESX.Alert('Error','Bisim shoma khamush ast!',5000,'error') end
	if ESX.GetPlayerData().IsDead or ESX.GetPlayerData().IsDead == 1 then return ESX.Alert('Error','Shoma nemitavanid in kar ra anjam dahid!',5000,'error') end
	if alertCD then return ESX.Alert('Spam','Spam nakonid!',5000,'warning') end
	alertCD = true
	SetTimeout(59000,function()
		alertCD = false
	end)
	ESX.TriggerServerEvent('radio:setAlarm',GetEntityCoords(PlayerPedId()))	
	exports['sunset_utils']:me('Dastesho be samte radio mibare va dokme alarm ro feshar mide')
end)

AddEventHandler('radio:gs',function()
	ExecuteCommand('gs')
end)

RegisterNetEvent('pma-voice:addAlert',function(coords,plySource,name)
	local AlarmBlip = AddBlipForCoord(coords)
	SetBlipSprite(AlarmBlip , 161)
	SetBlipScale(AlarmBlip , 2.0)
	SetBlipColour(AlarmBlip, 27)
	PulseBlip(AlarmBlip)
	SetTimeout(60000,function()
		RemoveBlip(AlarmBlip)
	end)
	TriggerEvent('chatMessage',"[Radio]", {255, 215, 0}, " ^0".. name .. "(".. plySource ..") Darkhast ^1poshtibani^0 kard!", 'plarms')
end)