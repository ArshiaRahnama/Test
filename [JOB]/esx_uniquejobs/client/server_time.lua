-- ============================================================
-- Client-side unix time helper
-- FIX: os.time()/os.date() do not exist on the FiveM client --
-- every menu that showed "X daghighe pish" (court_docket_menu,
-- case_timeline_menu, evidence_custody_menu, traffic_stop_menu)
-- was calling os.time() and crashing with
-- "attempt to index a nil value (global 'os')".
-- Fix: ask the server once for the real time, keep the offset from
-- GetGameTimer() (a real client native, ms since the client
-- started), and derive "now" from that everywhere instead. Synced
-- again automatically after any disconnect/reconnect.
-- ============================================================

local serverTimeOffset = 0
local synced = false

local function syncServerTime()
	if ESX == nil then return end
	ESX.TriggerServerCallback('esx_uniquejobs:getServerTime', function(serverTime)
		serverTimeOffset = serverTime - math.floor(GetGameTimer() / 1000)
		synced = true
	end)
end

Citizen.CreateThread(function()
	while ESX == nil do Citizen.Wait(200) end
	syncServerTime()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', syncServerTime)

-- Real unix seconds, usable anywhere client/*.lua needs "now" for a
-- timestamp that came from the server (os.time() there).
function GetServerUnixTime()
	return math.floor(GetGameTimer() / 1000) + serverTimeOffset
end
