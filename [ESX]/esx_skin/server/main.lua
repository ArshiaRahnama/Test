ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)

  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer then return end

  exports.oxmysql:execute(
    'UPDATE users SET `skin` = @skin WHERE identifier = @identifier',
    {
      ['@skin']       = json.encode(skin),
      ['@identifier'] = xPlayer.identifier
    }
  )

end)

RegisterServerEvent('esx_skin:responseSaveSkin')
AddEventHandler('esx_skin:responseSaveSkin', function(skin)

  -- FIX: this used io.open('resources/[esx]/esx_skin/skins.txt') - a path relative
  -- to wherever the server was started, so on your server the file was nil
  -- ("attempt to index a nil value (local 'file')"). It is now written with
  -- SaveResourceFile, which always resolves inside this resource.
  -- It was also callable by ANY client (free disk writes), so only staff may use it.
  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer or (xPlayer.permission_level or 0) < 1 then return end
  if type(skin) ~= 'table' then return end

  local old = LoadResourceFile(GetCurrentResourceName(), 'skins.txt') or ''
  SaveResourceFile(GetCurrentResourceName(), 'skins.txt', old .. json.encode(skin) .. "\n\n", -1)

end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)

  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer then cb(nil, {}) return end

  exports.oxmysql:execute(
    'SELECT * FROM users WHERE identifier = @identifier',
    {
      ['@identifier'] = xPlayer.identifier
    },
    function(users)

      local user = users and users[1]
      if not user then cb(nil, {}) return end
      local skin = nil

      local jobSkin = {
        skin_male   = xPlayer.job.skin_male,
        skin_female = xPlayer.job.skin_female
      }

      if user.skin ~= nil then
        skin = json.decode(user.skin)
      end

      cb(skin, jobSkin)

    end
  )

end)

RegisterCommand('skin', function(source)

  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer.permission_level > 3 then

    TriggerClientEvent('esx_skin:openSaveableMenu', source)
    TriggerClientEvent('esx_skin:requestSaveSkin', source)

  else

    TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, " ^0Shoma dastresi kafi baraye esfade az in dastor ra nadarid!")

  end

end, false)

RegisterCommand('saveskin', function(source)

  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer.permission_level > 8 then

    TriggerClientEvent('esx_skin:requestSaveSkin', source)

  else

    TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, " ^0Shoma dastresi kafi baraye esfade az in dastor ra nadarid!")

  end

end, false)

RegisterCommand('changevest', function(source, args)

  local xPlayer = ESX.GetPlayerFromId(source)

      if xPlayer.permission_level > 8 then

        if args[1] and args[2] then

          if tonumber(args[1]) and tonumber(args[2]) then

            local skinone, skintwo = tonumber(args[1]), tonumber(args[2])

            TriggerClientEvent('esx_skin:changeVest', source, skinone, skintwo)

          else

            TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, " ^0shoma dar ghesmat value faghat mitavanid adad vared konid!")

          end

        else

          TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, " ^0Syntax vared shode eshbteh ast!")

        end

      else

        TriggerClientEvent('chatMessage', source, "[ System ] : ", {255, 0, 0}, " ^0Shoma dastresi kafi baraye esfade az in dastor ra nadarid!")

      end

end, false)