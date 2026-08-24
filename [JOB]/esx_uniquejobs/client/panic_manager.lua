-- ============================================================
-- Unified Panic / Backup Manager (client)
-- /pc (panic/distress) /bc (backup request) /resp <id> (respond,
-- server-side) /cresp (cancel own active response marker)
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function SendPanic(isDistress)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	TriggerServerEvent('esx_uniquejobs:sendPanic', coords.x, coords.y, isDistress)
end

RegisterCommand('pc', function()
	SendPanic(true)
end, false)

RegisterCommand('bc', function()
	SendPanic(false)
end, false)

local panicActive = true

RegisterCommand('cresp', function()
	panicActive = false
end, false)

RegisterNetEvent('esx_uniquejobs:markPanicLocation')
AddEventHandler('esx_uniquejobs:markPanicLocation', function(x, y, targetServerId)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(targetServerId))

	panicActive = true

	CreateThread(function()
		for _ = 1, 60 do
			if panicActive then
				local coords = GetEntityCoords(targetPed)
				x, y = coords.x, coords.y

				SetNewWaypoint(x, y)
				local blip = AddBlipForCoord(x, y, coords.z)
				SetBlipSprite(blip, 161)
				SetBlipScale(blip, 1.5)
				SetBlipColour(blip, 1)
				SetBlipAsShortRange(blip, false)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Panic Location")
				EndTextCommandSetBlipName(blip)

				Wait(5000)
				RemoveBlip(blip)
			else
				TriggerEvent('esx:showNotification', "~r~Panic Baste Shod.")
				return
			end
		end
	end)

	TriggerEvent('esx:showNotification', "~r~Panic location marked on map! Follow the route.")
end)
