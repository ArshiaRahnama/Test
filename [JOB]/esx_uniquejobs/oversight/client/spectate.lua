-- ============================================================
-- Job Watch (oversight) -- client spectate
-- Modelled on client/agent_speact.lua's spectate (invisible ped +
-- NetworkSetInSpectatorMode, info panel, message the target,
-- BACKSPACE / X keys) with what that one lacks:
--   * streaming-safe start: OneSync only syncs peds near you, so
--     the agent's own ped is moved next to the target first and
--     the spectator camera only attaches once the target ped exists
--   * follow loop keeps the target streamed in while they move
--   * returns you to exactly where you were (agent_speact drops
--     you at a fixed HQ marker)
--   * LEFT / RIGHT hops to the previous / next worker
--   * live shift-stats HUD, server-enforced time limit
-- ============================================================

local Cfg = Config_oversight

Ov.Spec = { active = false, preparing = false, target = nil, tPed = nil, origin = nil, info = nil, startedAt = 0, maxMin = 20 }
local Spec = Ov.Spec

local function findTargetPed(serverId)
	local pl = GetPlayerFromServerId(serverId)
	if pl and pl ~= -1 then
		local p = GetPlayerPed(pl)
		if p and p ~= 0 and DoesEntityExist(p) then return p end
	end
	return nil
end

local function hideSelf(ped)
	SetEntityVisible(ped, false, false)
	SetEntityAlpha(ped, 0, false)
	SetEntityInvincible(ped, true)
	SetEntityCollision(ped, false, false)
	FreezeEntityPosition(ped, true)
end

local function showSelf(ped)
	FreezeEntityPosition(ped, false)
	SetEntityCollision(ped, true, true)
	SetEntityInvincible(ped, false)
	SetEntityVisible(ped, true, false)
	ResetEntityAlpha(ped)
end

local function moveSelf(c)
	local ped = PlayerPedId()
	RequestCollisionAtCoord(c.x, c.y, c.z)
	SetEntityCoordsNoOffset(ped, c.x, c.y, c.z, false, false, false)
end

function Ov.StartSpectate(targetId)
	if Spec.preparing then return end
	local ped = PlayerPedId()
	if not Spec.active and IsPedInAnyVehicle(ped, false) then
		ESX.ShowNotification('~r~Aval Az Vasile-ye Naghliye Piyade Shavid')
		return
	end
	-- cheap client-side pre-check so the officer gets instant feedback
	-- instead of waiting on a round trip -- the server (server/spectate.lua)
	-- re-checks this for real regardless, this is purely UX.
	if not Spec.active and Cfg.Spectate.RequireZone.Enabled then
		local zone = Cfg.Spectate.RequireZone
		if #(GetEntityCoords(ped) - zone.Coords) > zone.Radius then
			ESX.ShowNotification('~r~Baraye Nezarat Bayad Dakhel-e Mahdoode-ye DOJ Bashid')
			return
		end
	end
	TriggerServerEvent('esx_uniquejobs:oversight:spectateStart', targetId)
end

RegisterNetEvent('esx_uniquejobs:oversight:spectateBegin')
AddEventHandler('esx_uniquejobs:oversight:spectateBegin', function(targetId, coords, info, maxMin)
	if Spec.preparing then return end
	Spec.preparing = true

	local ped = PlayerPedId()
	local fresh = not Spec.active

	if fresh then
		Spec.origin = { coords = GetEntityCoords(ped), heading = GetEntityHeading(ped) }
		Spec.startedAt = GetGameTimer()
	else
		NetworkSetInSpectatorMode(false, ped)
		SetMinimapInSpectatorMode(false, ped)
	end
	Spec.maxMin = maxMin or Cfg.Spectate.MaxMinutes

	DoScreenFadeOut(250)
	while not IsScreenFadedOut() do Wait(0) end

	hideSelf(ped)
	moveSelf(coords)

	-- wait for the target ped to stream in (re-asking where they are, they may be moving)
	local tPed
	for attempt = 1, 60 do
		tPed = findTargetPed(targetId)
		if tPed then break end
		if attempt % 10 == 0 then
			ESX.TriggerServerCallback('esx_uniquejobs:oversight:spectateCoords', function(c)
				if c and Spec.preparing then moveSelf(c) end
			end)
		end
		Wait(100)
	end

	if not tPed then
		Spec.preparing = false
		ESX.ShowNotification('~r~Bazikon Peida Nashod (Dar Dastres Nist)')
		Ov.StopSpectate(false, true) -- restores self, tells the server
		return
	end

	NetworkSetInSpectatorMode(true, tPed)
	SetMinimapInSpectatorMode(true, tPed)

	Spec.active = true
	Spec.target = targetId
	Spec.tPed = tPed
	Spec.info = info
	Spec.preparing = false
	DoScreenFadeIn(250)

	ESX.ShowNotification('Nezarat Bar ~b~' .. tostring(info and info.name or targetId) .. '~w~ | [X] Menu | [BACKSPACE] Payan')
end)

-- silent = skip the fade (used on failed starts / resource stop)
function Ov.StopSpectate(skipServer, silent)
	CreateThread(function()
		if not Spec.active and not Spec.origin then return end
		local ped = PlayerPedId()
		local origin = Spec.origin

		if not silent then
			DoScreenFadeOut(200)
			while not IsScreenFadedOut() do Wait(0) end
		end

		NetworkSetInSpectatorMode(false, ped)
		SetMinimapInSpectatorMode(false, ped)
		showSelf(ped)
		if origin then
			SetEntityCoordsNoOffset(ped, origin.coords.x, origin.coords.y, origin.coords.z, false, false, false)
			SetEntityHeading(ped, origin.heading)
		end

		Spec.active, Spec.preparing, Spec.target, Spec.tPed, Spec.origin, Spec.info = false, false, nil, nil, nil, nil
		DoScreenFadeIn(300)

		if not skipServer then
			TriggerServerEvent('esx_uniquejobs:oversight:spectateStop')
		end
		ESX.ShowNotification('Nezarat Payan Yaft')
	end)
end

RegisterNetEvent('esx_uniquejobs:oversight:spectateForceEnd')
AddEventHandler('esx_uniquejobs:oversight:spectateForceEnd', function(reason)
	local why = {
		timeout = 'Zaman-e Nezarat Tamam Shod',
		target_left = 'Bazikon Az Server Kharej Shod',
		role_lost = 'Dast Resi-ye Shoma Laghv Shod',
	}
	ESX.ShowNotification('~y~' .. (why[reason] or 'Nezarat Payan Yaft'))
	Ov.StopSpectate(true)
end)

-- hop to the previous (-1) / next (+1) worker
local lastHop = 0
local function cycle(dir)
	if GetGameTimer() - lastHop < 800 or Spec.preparing then return end
	lastHop = GetGameTimer()
	ESX.TriggerServerCallback('esx_uniquejobs:oversight:spectateList', function(ids)
		if not ids or #ids == 0 then return end
		local idx = 0
		for i, id in ipairs(ids) do
			if id == Spec.target then idx = i break end
		end
		local nextIdx = ((idx - 1 + dir) % #ids) + 1
		if ids[nextIdx] and ids[nextIdx] ~= Spec.target then
			TriggerServerEvent('esx_uniquejobs:oversight:spectateStart', ids[nextIdx])
		end
	end)
end

-- follow loop + info refresh
CreateThread(function()
	local missing, tick = 0, 0
	while true do
		Wait(500)
		if Spec.active then
			tick = tick + 1
			local ped = PlayerPedId()
			local tPed = findTargetPed(Spec.target)

			if tPed then
				missing = 0
				if tPed ~= Spec.tPed then -- target respawned / re-streamed: rebind the camera
					Spec.tPed = tPed
					NetworkSetInSpectatorMode(true, tPed)
					SetMinimapInSpectatorMode(true, tPed)
				end
				local c = GetEntityCoords(tPed)
				SetEntityCoordsNoOffset(ped, c.x, c.y, c.z, false, false, false)
			else
				missing = missing + 1
				ESX.TriggerServerCallback('esx_uniquejobs:oversight:spectateCoords', function(c)
					if c and Spec.active then moveSelf(c) end
				end)
				if missing > 20 then
					missing = 0
					ESX.ShowNotification('~r~Bazikon Az Dast Raft')
					Ov.StopSpectate(false)
				end
			end

			if tick % 6 == 0 then
				ESX.TriggerServerCallback('esx_uniquejobs:oversight:spectateInfo', function(info)
					if info and Spec.active then Spec.info = info end
				end)
			end
		else
			missing, tick = 0, 0
		end
	end
end)

local function drawTxt(x, y, text, scale, r, g, b)
	SetTextFont(4)
	SetTextScale(scale, scale)
	SetTextColour(r or 255, g or 255, b or 255, 255)
	SetTextOutline()
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(x, y)
end

local stateLabel = { working = '~g~Dar Hal-e Kar', ['break'] = '~y~Estefade Az Estrahat', idle = '~r~Bikar' }

-- HUD + keys
CreateThread(function()
	while true do
		if Spec.active then
			Wait(0)
			local info = Spec.info or {}

			if Cfg.Spectate.Hud then
				local remaining = math.max(0, Spec.maxMin * 60 - math.floor((GetGameTimer() - Spec.startedAt) / 1000))
				DrawRect(0.115, 0.215, 0.215, 0.235, 0, 0, 0, 150)
				drawTxt(0.015, 0.108, '~b~JOB WATCH ~w~-- NEZARAT', 0.42)
				drawTxt(0.015, 0.138, (info.name or '?'):gsub('_', ' ') .. ' ~c~[' .. tostring(Spec.target) .. ']', 0.4)
				drawTxt(0.015, 0.165, (info.jobLabel or '?') .. ' ~c~| ' .. (info.grade or '-') .. (info.offJob and ' ~r~(Kharej Az Shoghl)' or ''), 0.36)
				drawTxt(0.015, 0.192, (stateLabel[info.state] or '~c~?') .. (info.zone and (' ~c~@ ' .. tostring(info.zone)) or ''), 0.36)
				drawTxt(0.015, 0.219, 'Shift: ~y~' .. tostring(info.shiftMin or 0) .. 'm ~w~| Item: ~y~' .. tostring(info.items or 0), 0.36)
				drawTxt(0.015, 0.246, 'Daramad: ~g~$' .. tostring(info.income or 0) .. ' ~w~| Foroush: ~y~' .. tostring(info.sales or 0), 0.36)
				drawTxt(0.015, 0.273, 'Hoshdar: ' .. ((info.flags or 0) > 0 and ('~r~' .. info.flags) or '~g~0') .. ' ~w~| Zaman: ~y~' .. math.floor(remaining / 60) .. ':' .. string.format('%02d', remaining % 60), 0.36)
				drawTxt(0.015, 0.300, '~c~[<][>] Badi/Ghabli  [X] Menu  [BACKSPACE] Payan', 0.3)
			end

			if not IsNuiFocused() then
				if IsControlJustPressed(0, 177) then
					Ov.StopSpectate(false)
				elseif IsControlJustPressed(0, 73) then
					Ov.OpenSpectateMenu()
				elseif IsControlJustPressed(0, 174) then
					cycle(-1)
				elseif IsControlJustPressed(0, 175) then
					cycle(1)
				end
			end
		else
			Wait(500)
		end
	end
end)

-- if the resource restarts mid-spectate, never leave the agent invisible/frozen
AddEventHandler('onClientResourceStop', function(res)
	if res ~= GetCurrentResourceName() then return end
	if Spec.active or Spec.origin then
		local ped = PlayerPedId()
		NetworkSetInSpectatorMode(false, ped)
		SetMinimapInSpectatorMode(false, ped)
		showSelf(ped)
		if Spec.origin then
			SetEntityCoordsNoOffset(ped, Spec.origin.coords.x, Spec.origin.coords.y, Spec.origin.coords.z, false, false, false)
		end
		DoScreenFadeIn(0)
	end
end)

RegisterCommand('closewatch', function()
	if Spec.active then Ov.StopSpectate(false)
	else ESX.ShowNotification('~r~Shoma Dar Hal-e Nezarat Nistid') end
end, false)
