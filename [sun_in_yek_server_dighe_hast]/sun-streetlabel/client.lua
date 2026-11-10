-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil
local hud = true
local world = 0
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

AddEventHandler('core:updateHud', function(state)
	hud = state
end)

-- Variables
local directions = {
  N = 360, 0,
  NE = 315,
  E = 270,
  SE = 225,
  S = 180,
  SW = 135,
  W = 90,
  NW = 45
  --  N = 0, <= will result in the HUD breaking above 315deg
}
local isLoaded = false
local streetHash1, streetHash2, playerDirection;
local isHide = false
local id = GetPlayerServerId(PlayerId())
local ts = 0

function changeGpsStatus(status)
	isGpsOn = status
	SendNUIMessage({
		type = 'displayaddress',
		active = isGpsOn
	});
end

exports('setCompass', function(state)
	isLoaded = state and 1 or 0
end)

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/gps', 'Toggle street label', {
	})
	changeGpsStatus(true)
	Citizen.Wait(10000)
	local svID = GetPlayerServerId(PlayerId())
	local rawId = ESX.GetPlayerData().rawid

	while true do
		local ped = PlayerPedId();

		local paused = IsPauseMenuActive();
		local coords = GetEntityCoords(ped);
		local zone = GetNameOfZone(coords.x, coords.y, coords.z);
		local zoneLabel = GetLabelText(zone);
		if isGpsOn then
			local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
			streetHash1 = GetStreetNameFromHashKey(var1);
			streetHash2 = GetStreetNameFromHashKey(var2);
			playerDirection = GetEntityHeading(ped);

			for k, v in pairs(directions) do
				if (math.abs(playerDirection - v) < 22.5) then
					playerDirection = k;

					if (playerDirection == 1) then
						playerDirection = 'N';
						break;
					end

					break;
				end
			end

			street2 = '';
			if (streetHash2 == '') then
				street2 = zoneLabel;
			else
				street2 = streetHash2..', '..zoneLabel;
			end
		end
		SendNUIMessage({
			type = 'streetLabel:MSG',
			active = isLoaded,
			direction = playerDirection,
			zone = streetHash1,
			street = street2,
			time = GetClockHours() .. ':' .. GetClockMinutes(),
			ts = ts .. ' | ' .. rawId .. ' | W'.. world .. ' | ID : ',
			src = svID,
			server = ESX.serverNum == 1 and '*' or '**',
			hud = hud,
		});
		-- Wait for half a second.
		Citizen.Wait(1000);
	end
end)

function tsUpdate()
	ts = exports['sunset_utils']:GetServerOSTime()
	Citizen.SetTimeout(1000,tsUpdate)
end
Citizen.SetTimeout(30000,tsUpdate)

RegisterNetEvent('esx:changeworld', function(_)
	world = _
end)