ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand("cam", function(source, args, raw)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.job.name == "weazel" and xPlayer.job.grade >= 1 then
    TriggerClientEvent("Cam:ToggleCam", source)
    -- `source` passed explicitly as a 4th arg here (and read explicitly by
    -- Unique_LevelQuest's bridge) because this is a RegisterCommand
    -- handler: unlike a RegisterServerEvent handler, the ambient global
    -- `source` is never set for it, so a listener relying on that global
    -- would always see the wrong player -- same class of bug as the
    -- Unique_Punishment /cs command fix.
    TriggerEvent('esx_society:logAction', 'weazel', 'Camera Toggled', {
      {["name"] = "Player", ["value"] = xPlayer.name, ["inline"] = false},
    }, source)
  else
    SendMessage_weazelcam(source, "Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
  end
end)

RegisterCommand("bmic", function(source, args, raw)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.job.name == "weazel" and xPlayer.job.grade >= 1 then
    TriggerClientEvent("Mic:ToggleBMic", source)
    TriggerEvent('esx_society:logAction', 'weazel', 'Boom Mic Toggled', {
      {["name"] = "Player", ["value"] = xPlayer.name, ["inline"] = false},
    })
  else
    SendMessage_weazelcam(source, "Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
  end
end)

RegisterCommand("mic", function(source, args, raw)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.job.name == "weazel" and xPlayer.job.grade >= 1 then
    TriggerClientEvent("Mic:ToggleMic", source)
    TriggerEvent('esx_society:logAction', 'weazel', 'Mic Toggled', {
      {["name"] = "Player", ["value"] = xPlayer.name, ["inline"] = false},
    })
  else
    SendMessage_weazelcam(source, "Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
  end
end)

function SendMessage_weazelcam(target, message)
    TriggerClientEvent('chatMessage', target, "[Weazel News]", {255, 0, 0}, message)
end