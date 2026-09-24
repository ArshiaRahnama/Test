-- ============================================================
-- Job Watch (oversight) -- black market ("the fence") client side
-- A single physical ped (Config_oversight.BlackMarket.Ped) instead
-- of a command: walk up, target him (ox_target -- already a
-- dependency of this resource, same pattern esx_jobs' admin uniform
-- pads use), and a small marker + label above his head tells you
-- open or closed BEFORE you even talk to him -- his idle animation
-- changes too (relaxed and smoking when open, arms-crossed checking
-- the time when closed). The marker only renders within
-- MarkerDistance, so this never spoils anything map-wide; you have
-- to actually find him.
--
-- Admin-facing: a small read-only status screen for judge/marshal
-- from the Job Watch main menu (does not spoil anything for workers
-- since they never see this menu) -- unchanged from before.
-- ============================================================

local Cfg = Config_oversight
local T = 'esx_uniquejobs:oversight:'
local PedCfg = Cfg.BlackMarket.Ped

local fencePed = nil
local isOpenCache = nil   -- nil = not polled yet, true/false once known
local currentScenario = nil
local lastPoll = 0

local function Draw3DText(x, y, z, text, r, g, b)
	local onScreen, sx, sy = World3dToScreen2d(x, y, z)
	if not onScreen then return end
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(r or 255, g or 255, b or 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(2, 0, 0, 0, 200)
	SetTextOutline()
	SetTextCentre(true)
	SetTextEntry('STRING')
	AddTextComponentString(text)
	DrawText(sx, sy)
end

local function setScenario(name)
	if not fencePed or not DoesEntityExist(fencePed) then return end
	if currentScenario == name then return end
	currentScenario = name
	ClearPedTasks(fencePed)
	TaskStartScenarioInPlace(fencePed, name, 0, true)
end

local function pollOpenState()
	ESX.TriggerServerCallback(T .. 'blackmarketIsOpen', function(open)
		isOpenCache = open
		setScenario(open and PedCfg.ScenarioOpen or PedCfg.ScenarioClosed)
	end)
end

local function sellFlow()
	ESX.TriggerServerCallback(T .. 'blackmarketList', function(list)
		if not list then
			ESX.ShowNotification('~r~"Emrooz Chizi Nist... Bad-an Bia."')
			return
		end
		if #list == 0 then
			ESX.ShowNotification('~y~Chizi Baraye Forush Nadarid')
			return
		end

		PlaySoundFrontend(-1, 'Menu_Accept', 'Phone_SoundSet_Default', true)
		local options = {}
		for _, it in ipairs(list) do
			options[#options + 1] = {
				title = it.label .. ' (' .. it.count .. ' Adad)',
				description = 'Forush Be Forushande-ye Siah -- Bedoon-e Maliat, Bedoon-e Rasid',
				icon = 'user-secret',
				onSelect = function()
					local input = lib.inputDialog(it.label, {
						{ type = 'number', label = 'Chand Adad?', default = math.min(it.count, Cfg.BlackMarket.MaxSellPerCall), min = 1, max = math.min(it.count, Cfg.BlackMarket.MaxSellPerCall), required = true },
					})
					if input then
						TriggerServerEvent(T .. 'blackmarketSell', it.name, input[1])
					end
				end,
			}
		end

		lib.registerContext({ id = 'ov_fence', title = 'Tamas-e Namashakhas', options = options })
		lib.showContext('ov_fence')
	end)
end

local function spawnFencePed()
	if not Cfg.BlackMarket.Enabled or fencePed then return end
	local c = PedCfg.Coords

	local foundGround, groundZ = GetGroundZFor_3dCoord(c.x, c.y, c.z + 5.0, false)
	local spawnZ = foundGround and groundZ or c.z

	local model = GetHashKey(PedCfg.Model)
	RequestModel(model)
	local timeout = 0
	while not HasModelLoaded(model) and timeout < 200 do
		Wait(10)
		timeout = timeout + 1
	end
	if not HasModelLoaded(model) then return end

	fencePed = CreatePed(4, model, c.x, c.y, spawnZ, c.w, false, false)
	SetEntityInvincible(fencePed, true)
	SetBlockingOfNonTemporaryEvents(fencePed, true)
	FreezeEntityPosition(fencePed, true)
	SetEntityAsMissionEntity(fencePed, true, true)
	SetModelAsNoLongerNeeded(model)
	TaskStartScenarioInPlace(fencePed, PedCfg.ScenarioClosed, 0, true)
	currentScenario = PedCfg.ScenarioClosed

	exports.ox_target:addLocalEntity(fencePed, {
		{
			label = 'Sohbat Ba Forushande',
			icon = 'fas fa-user-secret',
			onSelect = function() sellFlow() end,
		},
	})
end

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(200)
	end
	spawnFencePed()
end)

-- distance-gated marker/label + periodic open-state poll. Cheap Wait(500)
-- loop while far away; only switches to a smooth Wait(0) loop once the
-- player is actually close enough for the marker to matter.
CreateThread(function()
	local c = PedCfg.Coords
	local pedCoords = vector3(c.x, c.y, c.z)
	while true do
		if not fencePed or not DoesEntityExist(fencePed) then
			Wait(1000)
		else
			local dist = #(GetEntityCoords(PlayerPedId()) - pedCoords)
			if dist > PedCfg.MarkerDistance then
				Wait(500)
			else
				local now = GetGameTimer()
				if now - lastPoll > Cfg.BlackMarket.Ped.PollSeconds * 1000 then
					lastPoll = now
					pollOpenState()
				end

				local headZ = pedCoords.z + 1.05
				if isOpenCache == nil then
					DrawMarker(1, pedCoords.x, pedCoords.y, headZ + 0.35, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.18, 0.18, 0.18, 180, 180, 180, 120, false, true, 2, false, nil, nil, false)
					Draw3DText(pedCoords.x, pedCoords.y, headZ + 0.6, '...', 200, 200, 200)
				elseif isOpenCache then
					DrawMarker(1, pedCoords.x, pedCoords.y, headZ + 0.35, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.18, 0.18, 0.18, 60, 220, 90, 160, true, true, 2, false, nil, nil, false)
					Draw3DText(pedCoords.x, pedCoords.y, headZ + 0.6, '~g~Baz Hastam', 60, 220, 90)
				else
					DrawMarker(1, pedCoords.x, pedCoords.y, headZ + 0.35, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.18, 0.18, 0.18, 200, 60, 60, 110, false, true, 2, false, nil, nil, false)
					Draw3DText(pedCoords.x, pedCoords.y, headZ + 0.6, '~r~Emrooz Na', 200, 90, 90)
				end

				Wait(0)
			end
		end
	end
end)

AddEventHandler('onClientResourceStop', function(res)
	if res ~= GetCurrentResourceName() then return end
	if fencePed and DoesEntityExist(fencePed) then
		exports.ox_target:removeLocalEntity(fencePed)
		DeleteEntity(fencePed)
	end
end)

-- read-only admin screen: current open/closed state. Reachable from
-- the Job Watch main menu (client/menu.lua), gated there on the
-- 'flags' permission the same way the Flags list is.
function Ov.OpenBlackMarketInfo()
	ESX.TriggerServerCallback(T .. 'getBlackMarketStatus', function(status)
		if not status then return end
		local o = {
			{
				title = status.open and '~g~Bazar-e Siah: BAZ~s~' or '~r~Bazar-e Siah: BASTE~s~',
				description = status.open and 'Alan Mitavanand Forush Konand (Bedoon-e Ettela-e Khodkar Be Karegaran)' or 'Alan Kasi Javab Nemide',
				icon = status.open and 'unlock' or 'lock', disabled = true,
			},
			{
				title = 'Forushande', description = 'Yek Ped-e Fizikie -- Bayad Peydash Konand Va Target Konand (Bedoon-e Command)',
				icon = 'user-secret', disabled = true,
			},
		}
		Ov.ShowMenu('ov_blackmarket', 'Bazar-e Siah (Etela\'at)', 'ov_main', o)
	end)
end
