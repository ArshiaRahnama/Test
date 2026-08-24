ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("esx_vehiclecontrol:sync")
AddEventHandler("esx_vehiclecontrol:sync", function(netid, state)
    TriggerClientEvent("esx_vehiclecontol:ClientSync", -1, netid, state)
end)

RegisterServerEvent("esx_vehiclecontrol:syncAlarm")
AddEventHandler("esx_vehiclecontrol:syncAlarm", function(netid, state)
    TriggerClientEvent("esx_vehiclecontrol:AlarmStete", -1, netid, state)
end)

RegisterServerEvent("esx_vehiclecontrol:lights")
AddEventHandler("esx_vehiclecontrol:lights", function(veh)
    TriggerClientEvent("esx_vehiclecontol:lockLights", -1, veh)
end)

RegisterServerEvent("esx_vehiclecontrol:NotifyOwner")
AddEventHandler("esx_vehiclecontrol:NotifyOwner", function(plate, model)
    MySQL.Async.fetchScalar('SELECT `owner` FROM `owned_vehicles` WHERE plate = @plate',{
        ["@plate"] = plate
      }, function(owner)

        if owner then
            local xPlayer = ESX.GetPlayerFromIdentifier(owner)
            if xPlayer then
                TriggerClientEvent('esx:showAdvancedNotification', xPlayer.source, 'Insurance', 'Notification', "~r~Azhir ~g~" .. model .. "~w~ shoma be seda daramad!", 'CHAR_MP_MORS_MUTUAL', 2)
            end
        end

    end)
end)

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
AddEventHandler('chatMessage', function(s, n, m)
  local message = string.lower(m)

  if message == "/engine off" then
    CancelEvent()

    TriggerClientEvent('engineoff', s)
  elseif message == "/engine on" then
    CancelEvent()

    TriggerClientEvent('engineon', s)
  elseif message == "/engine" then
    CancelEvent()

    TriggerClientEvent('engine', s)

  elseif message == "/trunk" then
    CancelEvent()

    TriggerClientEvent('trunk', s)

  elseif message == "/lfdoor" then
    CancelEvent()

    TriggerClientEvent('lfdoor', s)

  elseif message == "/rfdoor" then
    CancelEvent()

    TriggerClientEvent('rfdoor', s)

  elseif message == "/lrdoor" then
    CancelEvent()

    TriggerClientEvent('lrdoor', s)

  elseif message == "/rrdoor" then
    CancelEvent()

    TriggerClientEvent('rrdoor', s)

  elseif message == "/alldoors" then
    CancelEvent()

    TriggerClientEvent('alldoors', s)

  elseif message == "/allwindowsdown" then
    CancelEvent()

    TriggerClientEvent('allwindowsdown', s)

  elseif message == "/allwindowsup" then
    CancelEvent()

    TriggerClientEvent('allwindowsup', s)

  elseif message == "/hood" then
    CancelEvent()

    TriggerClientEvent('hood', s)

  elseif message == "/lock" then
    CancelEvent()

    TriggerClientEvent('lock', s)

  elseif message == "/sveh" then
    CancelEvent()

    TriggerClientEvent('controlsave', s)
  end
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

RegisterCommand("save", function(source, args)

  if args[2] == nil then
    if args[1] then

		local a = math.random(1, 2)
		local xPlayer = ESX.GetPlayerFromId(source)
        local licenseplate = string.upper(args[1])

        TriggerClientEvent('save', source, licenseplate)

    else
      TriggerClientEvent('save', source, math.random(111111, 999999))
    end

  else
    TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, " ^0Lotfan tamami matn pelak ra faghat dar ghesmat aval vared konid")
  end
end)
