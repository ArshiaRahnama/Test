ESX                = nil
local ads = {}
local cads = 1
local news = "https://discord.com/api/webhooks/945701270059098132/3mYhrX9Q7rK9elVPS-PFKi89FYwwSg6B8Guc1dTe8kuMxEmJdNkyXn0aiAMFum-EdCY3"
local communtiylogo = "nil"
local adcost = 50000

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config_weazel.MaxInService ~= -1 then
  TriggerEvent('esx_service:activateService', 'weazel', Config_weazel.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'weazel', "Moshtari", true, true)
TriggerEvent('esx_society:registerSociety', 'weazel', 'weazel', 'society_weazel', 'society_weazel', 'society_weazel', {type = 'private'})

RegisterCommand('tabligh', function(source, args)
  local identifier = GetPlayerIdentifier(source)
  local xPlayer =  ESX.GetPlayerFromId(source)
  if not DoesHaveAds_weazel(identifier) then
    if  xPlayer.bank >= adcost then
      if not args[1] then
        SendMessage_weazel(source, "Shoma dar ghesmat matn tabligh chizi vared nakardid!")
        return
      end

      local message = table.concat(args, " ")

      ads[cads] = {message = message, owner = identifier, name = string.gsub(exports.essentialmode:IcName(source), "_", " "), created = os.time()}
      NotifyJob_weazel("Yek tabligh jadid tavasot ^3" .. ads[cads].name .. " ^0sabt shod shomare tabligh ^4(" .. cads .. ")")
      cads = cads + 1
      SendMessage_weazel(source, "Tabligh shoma ba movafaghiat sabt shod lotfan ta baresi an shakiba bashid!")

    else
      SendMessage_weazel(source, "Shoma Baraye Tabligh Bayad ^150k ^0Poll Dar Bank Khod Dashte Bashid!")
    end
  else
    SendMessage_weazel(source, "Shoma dar hale hazer yek ^1tabligh ^0darid!")
  end
end, false)

RegisterCommand('ads', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.job.name == "weazel" and xPlayer.job.grade >= 1 then

    if Count_weazel(ads) > 0 then

      TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "^0====== List Tablighat Faal ======")
      for k,v in pairs(ads) do

        TriggerClientEvent('chatMessage', source, "", {255, 0, 0}, "^3[^1" .. k  .. "^3]^0 Owner: ^2" .. v.name.."\nMessage: ^0"..v.message)
      end

    else
      SendMessage_weazel(source, "Tablighi baraye namayesh vojod nadarad!")
    end

  else
    SendMessage_weazel(source, "Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
  end
end, false)

RegisterCommand("ad_weazel", function(source, args)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.job.name == "weazel" and xPlayer.job.grade >= 1 then

    if not args[1] then
      SendMessage_weazel(source, "Shoma dar ghesmat ID tabligh chizi vared nakardid!")
      return
    end

    if not tonumber(args[1]) then
      SendMessage_weazel(source, "Shoma dar ghesmat ID tabligh faghat mitavanid adad vared konid!")
      return
    end

    if not args[2] then
      SendMessage_weazel(source, "Shoma dar ghesmat action chizi vared nakardid!")
      return
    end

    local adid = tonumber(args[1])
    local action = string.lower(args[2])
    local author = string.gsub(xPlayer.name, "_", " ")

    if ads[adid] then

      local ad = ads[adid]
      if action == "view" then
        SendMessage_weazel(source, "^2" .. ad.name .. ":^0 " .. ad.message)
      elseif action == "accept" then
        local zPlayer = ESX.GetPlayerFromIdentifier(ad.owner)
        if zPlayer then
            if zPlayer.bank >= adcost then
              zPlayer.removeBank(adcost)
              xPlayer.addBank(adcost)
              ads[adid] = nil
              NotifyJob_weazel("Tabligh ^3" .. adid .. "^0 tavasot ^2" .. author .. "^0 ghabol shod!")
              SendMessage_weazel(zPlayer.source, "Tabligh shoma tavasot ^3" .. author .. "^0 ghabol shod va mablagh ^2" .. adcost .. "$^0 az hesab shoma kam shod!")
              SendAD_weazel(ad)
              Feed_weazel(author, ad)
            else
              SendMessage_weazel(source, "Shakhs mored nazar pol kafi baraye pardakht hazine tabligh ra nadarad!")
            end
        else
          SendMessage_weazel(source, "Shakhsi ke in tabligh ra ferestade dar shahr nist!")
        end
      elseif action == "decline" then

        if not args[3] then
          SendMessage_weazel(source, "Shoma dar ghesmat dalil baste shodan tabligh chizi vared nakardid!")
          return
        end

        local reason = table.concat(args, " ", 3)
        local zPlayer = ESX.GetPlayerFromIdentifier(ad.owner)
        ads[adid] = nil
        NotifyJob_weazel("Tabligh ^3" .. adid .. "^0 tavasot ^2" .. author .. "^0 baste shod be dalile: ^1" .. reason)
        if zPlayer then SendMessage_weazel(zPlayer.source, "Tabligh shoma tavasot ^2" .. author .. "^0 Baste shod be dalile: ^3" .. reason) end

      else
        SendMessage_weazel(source, "Action vared shode eshtebah ast!")
      end

    else
      SendMessage_weazel(source, "Id tabligh vared shode eshtebah ast!")
    end

  else
    SendMessage_weazel(source, "Shoma dastresi kafi baraye estefade az in dastor ra nadarid!")
  end
end, false)

function DoesHaveAds_weazel(identifer)
  for k,v in pairs(ads) do
    if v.owner == identifer then
        return true
    end
  end

  return false
end

function Count_weazel(object)
  local count = 0
  for k,v in pairs(object) do
    count = count + 1
  end

  return count
end

function NotifyJob_weazel(message)
  TriggerClientEvent('esx_weazel:notify', -1, message)
end

function SendMessage_weazel(target, message)
  TriggerClientEvent('chatMessage', target, "[Weazel News]", {255, 0, 0}, message)
end

function SendAD_weazel(ad)
  TriggerClientEvent('chat:addMessage', -1, {
    template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(40, 42, 49, 0.77); border-radius: 3px;"><i class="far fa-newspaper"></i> <p style="padding-bottom: 2px; font-family: serif;">📣 <span style="font-size: 20px;">Weazel News</span> ❗️</p> <p style = "margin-left: 10px;">{1}</p></br><p style="text-align: right; font-size: 12pt; font-style: italic;">📌{0}</p></div>',
    args = {ad.name, ad.message}
  })
end

function Feed_weazel(intern, ad)
  local details = {
      {
          ["color"] = "2868934",
          ["title"] = "Feed_weazel Details",
          ["description"] = "**Intern:** " .. intern .. "\n**Author:** " .. ad.name .. "\n**Feed_weazel:** " .. ad.message ,
          ["footer"] = {
              ["text"] = "Feed_weazel Details",
              ["icon_url"] = communtiylogo,
          },
      }
  }

  PerformHttpRequest(news, function(err, text, headers) end, 'POST', json.encode({username = "Weazel News", embeds = details}), { ['Content-Type'] = 'application/json' })
end

RegisterCommand('news', function(source, args)
  local xPlayer = ESX.GetPlayerFromId(source)
  local author = string.gsub(xPlayer.name, "_", " ")

  if xPlayer.job.name == 'weazel' then

    if args[1] then
      ad ={name = author, message = table.concat(args, " ")}
      Wait(50)
      SendAD_weazel(ad)

    else
      SendMessage_weazel(source, "Shoma Matni Wared Nakardid!")
    end
  end
end)

RegisterCommand('newstime', function(source, args)
  local xPlayer = ESX.GetPlayerFromId(source)
  local author = string.gsub(xPlayer.name, "_", " ")

  if xPlayer.job.name == 'weazel' then

    if args[1] and args[2] and args[3] then
      if tonumber(args[2]) >= 60 then
        local messageParts = {}

        for i = 3, #args do
            table.insert(messageParts, args[i])
        end

        ad = {name = author, message = table.concat(messageParts, " ")}
        Wait(50)

        SendMsgTimer_weazel(ad, args[2], args[1])
      else
        SendMessage_weazel(source, "Zaman Bayad Bishtar Az ^159 ^0Sanie Bashad!!")
      end
    else
      SendMessage_weazel(source, "Shoma Matni Wared Nakardid!")
    end
  end
end)

function SendMsgTimer_weazel(ad, time, tedad)
  tonumber(tedad)
  for i=1, tonumber(tedad) do
    SendAD_weazel(ad)
    Citizen.Wait(tonumber(time) *60 *1000)
  end

end

function CheckADS_weazel()

  for k,v in pairs(ads) do
    if os.time() - v.created >= 600 then

      NotifyJob_weazel("Tabligh ^4" .. k .. "^0 be elat ^3adam pasokhgoyi^0 dar zaman mogharar ^1baste^0 shod!")

      local xPlayer = ESX.GetPlayerFromIdentifier(v.owner)
      if xPlayer then
        SendMessage_weazel(xPlayer.source, "Tabligh shoma be elat adam pasokhgoyi az samte ^2Weazel News ^1baste ^0 shod!")
      end

      ads[k] = nil

    end
  end

SetTimeout(15000, CheckADS_weazel)
end

CheckADS_weazel()

ESX.RegisterServerCallback("esx_weazeljob:GetIdTabligh", function(source, cb)
  local element = {}
  if Count_weazel(ads) > 0 then
    for k,v in pairs(ads) do

      table.insert(element, {
        idt     = k,
        name    = v.name,
        message = v.message

      })

    end
  else
    cb(false)
    return
  end
  cb(element)
end)

