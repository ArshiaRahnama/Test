

ESX = nil
local price = {
  hen =  5000 ,
  rabbit = 7000 ,
  gazelle = 4000 ,
  eagle = 9000 ,
}
local time = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('Hunt:killed')
AddEventHandler('Hunt:killed', function(Animal)
  local xPlayer = ESX.GetPlayerFromId(source)
  local Src = xPlayer.source

  if time[Src] then
    if time[Src] >= os.time() then
      return
    end
  end

  time[Src] = os.time() + 5
  if Animal == 'a_c_deer' then
    if xPlayer.getInventoryItem('lasheaho').limit >= (xPlayer.getInventoryItem('lasheaho').count + 1) then

      xPlayer.addInventoryItem('lasheaho', 1)
    else
      TriggerClientEvent('esx:showNotification', Src, "Shoma Fazae Kafi Post Nadarid")
    end
  elseif Animal == 'a_c_rabbit_01' then
    if xPlayer.getInventoryItem('lashekhargush').limit >= (xPlayer.getInventoryItem('lashekhargush').count + 1) then

      xPlayer.addInventoryItem('lashekhargush', 1)
    else
      TriggerClientEvent('esx:showNotification', Src, "Shoma Fazae Kafi Post Nadarid")
    end
  elseif Animal == 'a_c_hen' then
    if xPlayer.getInventoryItem('lashemorgh').limit >= (xPlayer.getInventoryItem('lashemorgh').count + 1) then

      xPlayer.addInventoryItem('lashemorgh', 1)
    else
      TriggerClientEvent('esx:showNotification', Src, "Shoma Fazae Kafi Post Nadarid")
    end
  elseif Animal == 'a_c_chickenhawk' then
    if xPlayer.getInventoryItem('lasheoghab').limit >= (xPlayer.getInventoryItem('lasheoghab').count + 1) then

      xPlayer.addInventoryItem('lasheoghab', 1)
    else
      TriggerClientEvent('esx:showNotification', Src, "Shoma Fazae Kafi Post Nadarid")
    end
  elseif Animal == 'a_c_chop' then
    if xPlayer.getInventoryItem('lasherottweiler').limit >= (xPlayer.getInventoryItem('lasherottweiler').count + 1) then

      xPlayer.addInventoryItem('lasherottweiler', 1)
    else
      TriggerClientEvent('esx:showNotification', Src, "Shoma Fazae Kafi Post Nadarid")
    end
  elseif Animal == 'a_c_coyote' then
    if xPlayer.getInventoryItem('lashecoyote').limit >= (xPlayer.getInventoryItem('lashecoyote').count + 1) then

      xPlayer.addInventoryItem('lashecoyote', 1)
    else
      TriggerClientEvent('esx:showNotification', Src, "Shoma Fazae Kafi Post Nadarid")
    end
  elseif Animal == 'a_c_husky' then
    if xPlayer.getInventoryItem('lashehusky').limit >= (xPlayer.getInventoryItem('lashehusky').count + 1) then

      xPlayer.addInventoryItem('lashehusky', 1)
    else
      TriggerClientEvent('esx:showNotification', Src, "Shoma Fazae Kafi Post Nadarid")
    end
  elseif Animal == 'a_c_mtlion' then
    if xPlayer.getInventoryItem('lashecougar').limit >= (xPlayer.getInventoryItem('lashecougar').count + 1) then

      xPlayer.addInventoryItem('lashecougar', 1)
    else
      TriggerClientEvent('esx:showNotification', Src, "Shoma Fazae Kafi Post Nadarid")
    end
  elseif Animal == 'a_c_pig' then
    if xPlayer.getInventoryItem('lashepig').limit >= (xPlayer.getInventoryItem('lashepig').count + 1) then

      xPlayer.addInventoryItem('lashepig', 1)
    else
      TriggerClientEvent('esx:showNotification', Src, "Shoma Fazae Kafi Post Nadarid")
    end
  else

  end

end)

RegisterServerEvent('Hunt:slaughterhouse')
AddEventHandler('Hunt:slaughterhouse', function(Animal2)
  local xPlayer = ESX.GetPlayerFromId(source)
  local Animal = Animal2
  local tekrar = 4
  local Src = source
  if Animal == Config_HUNT.ItemsTabdil[Animal].name then
    local Aho =  xPlayer.getInventoryItem(Config_HUNT.ItemsTabdil[Animal].name).count
    local DataItem = xPlayer.getInventoryItem(Config_HUNT.ItemsTabdil[Animal].name)
    local itemcout = xPlayer.getInventoryItem(Config_HUNT.ItemsTabdil[Animal].name).count

    if itemcout >= 1 then
      if Aho == 0 then return end
      local kg = math.random(1 , 3)
      local heads = math.random(0 ,8)
      local posts = math.random(0 ,4)
      local All = 1  * kg  - 1
      if All == 0 then
        All = 1
      end

      if xPlayer.getInventoryItem(Config_HUNT.ItemsTabdil[Animal].gosht).limit >= (xPlayer.getInventoryItem(Config_HUNT.ItemsTabdil[Animal].gosht).count + tonumber(All)) then
        if xPlayer.getInventoryItem(Config_HUNT.ItemsTabdil[Animal].head).limit >= (xPlayer.getInventoryItem(Config_HUNT.ItemsTabdil[Animal].head).count + 1) then

          if Config_HUNT.ItemsTabdil[Animal].post == "" or xPlayer.getInventoryItem(Config_HUNT.ItemsTabdil[Animal].post).limit >= (xPlayer.getInventoryItem(Config_HUNT.ItemsTabdil[Animal].post).count + 1) then
            TriggerClientEvent("HUNT:ChekCraft", Src, false)
            TriggerClientEvent("mythic_progbar:client:progress", Src, {name = "Hunt",duration = 4000,label = 'Dar Hal Tabdil Kardan ',useWhileDead = true,canCancel = false,controlDisables = {disableMovement = true,disableCarMovement = true,disableMouse = false,disableCombat = true,}})

            SetTimeout(4100, function()
              xPlayer.addInventoryItem(Config_HUNT.ItemsTabdil[Animal].gosht,  All)
              xPlayer.removeInventoryItem(Config_HUNT.ItemsTabdil[Animal].name, 1)
              if heads == 2 and Config_HUNT.ItemsTabdil[Animal].post ~= '' then
                xPlayer.addInventoryItem(Config_HUNT.ItemsTabdil[Animal].post,  1)
              end
              if posts == 2 and Config_HUNT.ItemsTabdil[Animal].head ~= '' then
                xPlayer.addInventoryItem(Config_HUNT.ItemsTabdil[Animal].head,  1)
              end
              TriggerClientEvent("HUNT:ChekCraft", Src, true)
            end)
          else
            TriggerClientEvent('esx:showNotification', Src, "Shoma Fazae Kafi Post Nadarid")
          end
        else
          TriggerClientEvent('esx:showNotification', Src, "Shoma Fazae Kafi Head Nadarid")
        end
      else
        TriggerClientEvent('esx:showNotification', Src, "Shoma Fazae Kafi Baraye Gosht Nadarid")
      end
    end
  end
end)

RegisterServerEvent('Hunt:Sellmeat')
AddEventHandler('Hunt:Sellmeat', function(Animal)
  local xPlayer = ESX.GetPlayerFromId(source)
  local soldMeat, earned = nil, 0
 if Animal == 'morgh' then
    local Oghab =  xPlayer.getInventoryItem('henmeat').count
    if Oghab == 0 then return end
    local All = Oghab  * price.hen
    xPlayer.addMoney(All)
    xPlayer.removeInventoryItem('henmeat', Oghab)
    soldMeat, earned = 'henmeat x' .. Oghab, All
    elseif  Animal == 'khargush' then
        local Oghab =  xPlayer.getInventoryItem('rabbitmeat').count
        if Oghab == 0 then return end
        local All = Oghab  * price.rabbit
        xPlayer.addMoney(All)
        -- BUG FIX: was removing 'gazellemeet' instead of the meat actually
        -- being paid for ('rabbitmeat') -- let players sell rabbit meat for
        -- money while keeping the rabbit meat (and losing unrelated gazelle
        -- meat, or nothing at all if they had none).
        xPlayer.removeInventoryItem('rabbitmeat', Oghab)
        soldMeat, earned = 'rabbitmeat x' .. Oghab, All
   elseif  Animal == 'Aho' then
    local Oghab =  xPlayer.getInventoryItem('gazellemeet').count
    if Oghab == 0 then return end
    local All = Oghab  * price.gazelle
    xPlayer.addMoney(All)
    xPlayer.removeInventoryItem('gazellemeet', Oghab)
    soldMeat, earned = 'gazellemeet x' .. Oghab, All
 elseif  Animal == 'Oghab' then
    local Oghab =  xPlayer.getInventoryItem('eaglemeet').count
    if Oghab == 0 then return end
    local All = Oghab  * price.eagle
    xPlayer.addMoney(All)
    xPlayer.removeInventoryItem('eaglemeet', Oghab)
    soldMeat, earned = 'eaglemeet x' .. Oghab, All
    end

  if soldMeat then
    TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Sold : '..soldMeat..' (hunting) ]\n[ Earned : '..tostring(earned)..' ]\n```', 'user', true, source, false)
  end
end)

ESX.RegisterServerCallback("HUNT:GetInventoryKnife", function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  cb(xPlayer.hasWeapon('WEAPON_KNIFE'))
end)

ESX.RegisterServerCallback("HUNT:GetInventoryKnife&Musket", function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  cb(xPlayer.hasWeapon('WEAPON_KNIFE'))
end)

ESX.RegisterServerCallback("HUNT:GetInventory", function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer then
    cb(xPlayer.inventory)
  else
    cb(false)
  end

end)

if Config_Megaphone.Framework == 'qb-core' then
    local QBCore = exports['qb-core']:GetCoreObject()

    QBCore.Functions.CreateUseableItem('megaphone', function(source)
        TriggerClientEvent('megaphone:use', source)
    end)
elseif Config_Megaphone.Framework == 'esx' then
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

    ESX.RegisterUsableItem('capsul', function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            TriggerClientEvent('megaphone:use', source)
        end
    end)
end

RegisterNetEvent('megaphone:applySubmix', function(bool)
    TriggerClientEvent('megaphone:updateSubmixStatus', -1, bool, source)
end)

RegisterCommand('megaphone', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.permission_level >= 1 then
        if args[1] then
            TriggerClientEvent('Megaphone:UseCommand', tonumber(args[1]))
        else
            TriggerClientEvent('chat:addMessage', source, { args = { '^8[SYSTEM]', 'Shoma Dar Ghesmat Id Chizi Vared Nakardi!' } })
        end
    else
        TriggerClientEvent('chat:addMessage', source, { args = { '^8[SYSTEM]', 'Shoma Dasresi Kafi Nadarid' } })
    end
end)

do
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function debugPrint(msg)
    if GetConvar('sv_environment', 'production') ~= 'production' then
        print("[EngineSystem] " .. msg)
    end
end

ESX.RegisterServerCallback('engine:checkEngineStatus', function(source, cb, plate)
    exports.oxmysql:execute('SELECT engine FROM owned_vehicles WHERE plate = ?', {
        plate
    }, function(result)
        if not result or #result == 0 then
            cb(nil)
            return
        end

        local engineValue = result[1].engine
        local status = false




        if type(engineValue) == "number" then
            status = engineValue > 0
        elseif type(engineValue) == "string" then
            status = (tonumber(engineValue) or 0) > 0
        elseif type(engineValue) == "boolean" then
            status = engineValue
        else


            status = true
        end

        cb(status)
    end)
end)

ESX.RegisterServerCallback('engine:checkVehicleOwnership', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not plate then cb(false) return end

    exports.oxmysql:scalar('SELECT owner FROM owned_vehicles WHERE plate = ?', {
        plate
    }, function(owner)
        if not owner then
            cb(false)
        else
            local isOwner = owner == xPlayer.identifier or (xPlayer.gang and owner == xPlayer.gang.name)
            cb(isOwner)
        end
    end)
end)

local ENGINE_INSTALL_PRICE = {
    [1] = 100000,
    [2] = 180000,
    [3] = 260000,
    [4] = 340000,
    [5] = 420000,
    [6] = 500000,
}

local function getOwnedEngineTier(xPlayer)
    for tier = 1, 6 do
        local item = xPlayer.getInventoryItem('engine' .. tier)
        if item and item.count > 0 then
            return tier
        end
    end
    return nil
end

ESX.RegisterServerCallback('engine:checkEngineItem', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local tier = getOwnedEngineTier(xPlayer)
    if not tier then
        cb(false)
        return
    end
    cb(true, tier, ENGINE_INSTALL_PRICE[tier])
end)

ESX.RegisterServerCallback('engine:checkMoney', function(source, cb, tier)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = ENGINE_INSTALL_PRICE[tier]
    if not price then
        cb(false)
        return
    end
    cb(xPlayer.bank >= price)
end)

RegisterNetEvent('engine:payForRepair')
AddEventHandler('engine:payForRepair', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeBank(15000)
    TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Paid For : Full Engine Repair ]\n[ Amount : 15000 ]\n```', 'user', true, source, false)
end)

RegisterNetEvent('engine:payForEngine')
AddEventHandler('engine:payForEngine', function(tier)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = ENGINE_INSTALL_PRICE[tier]
    if price then
        xPlayer.removeBank(price)
        TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Paid For : Engine Install (tier '..tostring(tier)..') ]\n[ Amount : '..tostring(price)..' ]\n```', 'user', true, source, false)
    end
end)

RegisterNetEvent('engine:removeEngine')
AddEventHandler('engine:removeEngine', function(plate)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not plate then return end

    exports.oxmysql:execute('UPDATE owned_vehicles SET engine = 0 WHERE plate = ?', {
        plate
    })

    debugPrint("Engine removed from vehicle: " .. plate)
    if GetResourceState('Unique_Skills') == 'started' then
        pcall(function() exports['Unique_Skills']:UpdateSkill(src, "ChopShop", 5.000) end)
    end
end)

RegisterNetEvent('engine:giveEngineItemToPlayer')
AddEventHandler('engine:giveEngineItemToPlayer', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem('engine', 1)
end)

RegisterNetEvent('engine:installEngine')
AddEventHandler('engine:installEngine', function(plate, tier)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not plate then return end





    local ownedTier = getOwnedEngineTier(xPlayer)
    if not ownedTier then
        TriggerClientEvent('esx:showNotification', src, "Shoma Item Engine Nadarid!")
        return
    end

    exports.oxmysql:execute('UPDATE owned_vehicles SET engine = 1000 WHERE plate = ?', {
        plate
    })

    xPlayer.removeInventoryItem('engine' .. ownedTier, 1)
    TriggerClientEvent('esx:showNotification', src, "Shoma Engine Mashin ra Nasb Kardid!")
end)

RegisterCommand("addengine", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.permission_level >= 1 then

        local ped = GetPlayerPed(source)
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle == 0 then
            TriggerClientEvent('esx:showNotification', source, "❌ شما باید داخل یک ماشین باشید.")
            return
        end

        local plate = GetVehicleNumberPlateText(vehicle)

        if not plate or plate == "" then
            TriggerClientEvent('esx:showNotification', source, "⛔ شماره پلاک نامعتبر است.")
            return
        end


        exports.oxmysql:execute('UPDATE owned_vehicles SET engine = 1000 WHERE plate = ?', {
        plate
    })

        TriggerClientEvent('esx:showNotification', source, "✅ انجین با موفقیت روی ماشین نصب شد.")
    else
        TriggerClientEvent('esx:showNotification', source, "⛔ شما اجازه استفاده از این دستور را ندارید.")
    end
end)

ESX.RegisterServerCallback('engine:isMechanicOnline', function(source, cb)
    local xPlayers = ESX.GetPlayers()
    local mechanicOnline = false

    for _, playerId in ipairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer and xPlayer.job and xPlayer.job.name == 'mechanic' then
            mechanicOnline = true
            break
        end
    end

    cb(mechanicOnline)
end)

RegisterNetEvent('engine:createEngineItemAllClients')
AddEventHandler('engine:createEngineItemAllClients', function()
    TriggerClientEvent('engine:createEngineItemClient', -1)
end)
end

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('trailburst', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('fireworks:box', source)
	xPlayer.removeInventoryItem('trailburst', 1)
end)

ESX.RegisterUsableItem('fountain', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('fireworks:cone', source)
	xPlayer.removeInventoryItem('fountain', 1)
end)

ESX.RegisterUsableItem('shotburst', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('fireworks:cylinder', source)
	xPlayer.removeInventoryItem('shotburst', 1)
end)

ESX.RegisterUsableItem('starburst', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('fireworks:rocket', source)
	xPlayer.removeInventoryItem('starburst', 1)
end)

RegisterServerEvent("syncbad1")
AddEventHandler("syncbad1", function(x, y, z)
    TriggerClientEvent("syncbad_cl1", -1, x, y, z)
end)
RegisterServerEvent("syncbad2")
AddEventHandler("syncbad2", function(x, y, z)
    TriggerClientEvent("syncbad_cl2", -1, x, y, z)
end)
RegisterServerEvent("syncbad3")
AddEventHandler("syncbad3", function(x, y, z)
    TriggerClientEvent("syncbad_cl3", -1, x, y, z)
end)
RegisterServerEvent("syncbad4")
AddEventHandler("syncbad4", function(x, y, z)
    TriggerClientEvent("syncbad_cl4", -1, x, y, z)
end)

ESX = nil
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

local FightBans = {}
AddEventHandler("esx:playerLoaded", function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local BannedAlready = false
	for a, b in pairs(FightBans) do
		for c, d in pairs(b) do
			if d.Steam == xPlayer.identifier then
				if os.time() < tonumber(d.Expire) then
					BannedAlready = true
					break
				else
					break
				end
			end
		end
	end
	if BannedAlready then
		FightBan(source)
	end
end)

function FightBan(source)
	TriggerClientEvent("Unique_Scripts_FightBan:Notif", source, true)
end

function UnFightBan(Steam)
	local Steam = Steam

    exports.oxmysql:execute("SELECT * FROM fightbans WHERE Steam = ?", {
        Steam
    }, function(data)
        if data[1] then
            exports.oxmysql:execute("DELETE FROM fightbans WHERE Steam = ?", {
                Steam
            })

            SetTimeout(5000, function()
                ReloadBans()
            end)
        end
end)

if ESX.GetPlayerFromIdentifier(Steam) then
    TriggerClientEvent("Unique_Scripts_FightBan:Notif", (ESX.GetPlayerFromIdentifier(Steam)).source, false)
end

end

function CreatheFightBan(target, day, source)
	local xPlayer = ESX.GetPlayerFromId(tonumber(target))
	local time = os.time() + day * 86400

    if xPlayer then
        exports.oxmysql:execute("INSERT INTO fightbans (Steam, isBnaned, Expire) VALUES (?, ?, ?)", {
            xPlayer.identifier,
            1,
            time
        }, function(rowsChanged)

        end)

        TriggerClientEvent("chat:addMessage", tonumber(target), {
            args = {
                "^1SYSTEM",
                "Shoma Be Modat ^1" .. day .. "^0 Rooz Fight Ban Shodid!"
            }
        })

        TriggerClientEvent("chat:addMessage", source, {
            args = {
                "^1SYSTEM",
                "Player: ^1"..xPlayer.name.."^0 Be Modat ^1" .. day .. "^0 Rooz Fight Ban Shod!"
            }
        })

        TriggerClientEvent("Unique_Scripts_FightBan:Notif", tonumber(target), true)

    else
        exports.oxmysql:execute("INSERT INTO fightbans (Steam, isBnaned, Expire) VALUES (?, ?, ?)", {
            tostring(target),
            1,
            time
        }, function(rowsChanged)

        end)

        exports.oxmysql:execute('SELECT playerName FROM users WHERE identifier = ?', {
            tostring(target)
        }, function(playerName)

        local targetName = (playerName[1] and playerName[1].playerName) or tostring(target)
        TriggerClientEvent("chat:addMessage", source, {
            args = {
                "^1SYSTEM",
                "Player: ^1"..targetName.."^0 Be Modat ^1" .. day .. "^0 Rooz Fight Ban Shod!"
            }
        })

        end)
    end
end

function ReloadBans()
	CreateThread(function()
		FightBans = {}
		exports.oxmysql:execute("SELECT * FROM fightbans", {}, function(info)
			for i = 1, #info do
				if info[i].isBnaned == 1 then
					Wait(2)
					table.insert(FightBans, {
						info[i]
					})
				end
			end
		end)
	end)
end

ReloadBans()
TriggerEvent("es:addAdminCommand", "fightban", 7, function(source, args, user)
	if tostring(args[1]) and tonumber(args[2]) then
		CreatheFightBan(tostring(args[1]), tonumber(args[2]), source)
		TriggerClientEvent("chat:addMessage", source, {
			args = {
				"^1SYSTEM",
				"Player Fight Ban Shod."
			}
		})
	end
end, function(source, args, user)
	TriggerClientEvent("chat:addMessage", source, {
		args = {
			"^1SYSTEM",
			"Insufficient Permissions."
		}
	})
end, {
	help = "Fight Ban Player",
	params = {
		{
			name = "Player ID/Hes",
			help = "ID Ra Vared Konid "
		},
		{
			name = "Day",
			help = "Teadad Rozi ke Player Fight Ban Shavd"
		}
	}
})

TriggerEvent("es:addAdminCommand", "unfightban", 7, function(source, args, user)
	if tostring(args[1]) then
		UnFightBan(tostring(args[1]))
		TriggerClientEvent("chat:addMessage", source, {
			args = {
				"^1SYSTEM",
				"Player Ba Steam hex : " .. tostring(args[1]) .. " unfight ban shod"
			}
		})
	end
end, function(source, args, user)
	TriggerClientEvent("chat:addMessage", source, {
		args = {
			"^1SYSTEM",
			"Insufficient Permissions."
		}
	})
end, {
	help = "Fight Ban Player",
	params = {
		{
			name = "Steam Hex",
			help = "Steam Hex Ra Vared Konid "
		}
	}
})

TriggerEvent("es:addAdminCommand", "reloadfightban", 7, function(source, args, user)
	ReloadBans()
end, function(source, args, user)
	TriggerClientEvent("chat:addMessage", source, {
		args = {
			"^1SYSTEM",
			"Insufficient Permissions."
		}
	})
end, {
	help = " ReloadFight Bans ",
	params = {}
})

TriggerEvent("es:addCommand", "checkfightban", function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    local steamIdentifier = xPlayer.identifier

    exports.oxmysql:execute("SELECT Expire FROM fightbans WHERE Steam = ?", {
        steamIdentifier
    }, function(data)
        if data[1] then
            local remainingTime = tonumber(data[1].Expire) - os.time()
            if tonumber(remainingTime) > 0 then
                local days = math.floor(remainingTime / 86400)
                local hours = math.floor((remainingTime % 86400) / 3600)
                local minutes = math.floor((remainingTime % 3600) / 60)

                TriggerClientEvent("chat:addMessage", source, {
                    args = {
                        "^1SYSTEM",
                        "Shoma Fight Ban Hastid. Zaman Baqi Mande: ^1" .. days .. "^0 Ruz, ^1" .. hours .. "^0 Saat, ^1" .. minutes .. "^0 Daghighe"
                    }
                })
            else
                TriggerClientEvent("chat:addMessage", source, {
                    args = {
                        "^1SYSTEM",
                        "Shoma Fight Ban Nistid ya Fight Ban Shoma Khateme Yafte Ast."
                    }
                })
            end
        else
            TriggerClientEvent("chat:addMessage", source, {
                args = {
                    "^1SYSTEM",
                    "Shoma Fight Ban Nistid."
                }
            })
        end
    end)
end, {
    help = "Check Remaining Fight Ban Time",
    params = {}
})

TriggerEvent("es:addAdminCommand", "acheckfightban", 2, function(source, args, user)
    if args[1] then
        local steamIdentifier
        if tonumber(args[1]) then
            local targetPlayer = ESX.GetPlayerFromId(tonumber(args[1]))
            if targetPlayer then
                steamIdentifier = targetPlayer.identifier
            else
                TriggerClientEvent("chat:addMessage", source, {
                    args = {
                        "^1SYSTEM",
                        "Player ID Vared Shode Eshtebah Ast."
                    }
                })
                return
            end
        else
            steamIdentifier = tostring(args[1])
        end

        exports.oxmysql:execute("SELECT Expire FROM fightbans WHERE Steam = ?", {
            steamIdentifier
        }, function(data)
            if data[1] then
                local remainingTime = tonumber(data[1].Expire) - os.time()
                if remainingTime > 0 then
                    local days = math.floor(remainingTime / 86400)
                    local hours = math.floor((remainingTime % 86400) / 3600)
                    local minutes = math.floor((remainingTime % 3600) / 60)

                    TriggerClientEvent("chat:addMessage", source, {
                        args = {
                            "^1SYSTEM",
                            "Player Ba Steam Hex: " .. steamIdentifier .. " Fight Ban Ast. Zaman Baqi Mande: ^1" .. days .. "^0 Ruz, ^1" .. hours .. "^0 Saat, ^1" .. minutes .. "^0 Daghighe"
                        }
                    })
                else
                    TriggerClientEvent("chat:addMessage", source, {
                        args = {
                            "^1SYSTEM",
                            "Player Fight Ban Nistid ya Fight Ban Be Payan Resid."
                        }
                    })
                end
            else
                TriggerClientEvent("chat:addMessage", source, {
                    args = {
                        "^1SYSTEM",
                        "Player Fight Ban Nist."
                    }
                })
            end
        end)
    else
        TriggerClientEvent("chat:addMessage", source, {
            args = {
                "^1SYSTEM",
                "Lotfan Steam Hex Ra Vared Konid."
            }
        })
    end
end, {
    help = "Admin Check Fight Ban Time for a Player",
    params = {
        {
            name = "Steam Hex",
            help = "Steam Hex Ra Vared Konid."
        }
    }
})

ESX = nil

TriggerEvent("esx:getSharedObject",function(obj)
    ESX = obj
end)

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('joblist', function(source, args, rawCommand)
    local zPlayer = ESX.GetPlayerFromId(source)
    local playerSteamHex = zPlayer.identifier
    local hasPermission = zPlayer.permission_level > 0
    local allowedJobs = {}
    if hasPermission or (zPlayer.job.name == 'fbi' and zPlayer.job.grade > 15) then
        allowedJobs = {police = {}, mt = {}, ambulance = {}, sheriff = {}, metropolitan = {}, mechanic = {}, weazel = {}, fbi = {}, taxi = {}, cid = {}, cia = {}, marshal = {}, judge = {}, doa = {}}
    else
        TriggerClientEvent('chat:addMessage', source, {args = {"^1[System]", "^3 Perm Nadary !"}})
        return
    end

    local Players = GetPlayers()
    local Jobs = {
        police = {},
        mt = {},
        ambulance = {},
        sheriff = {},
        metropolitan = {},
        mechanic = {},
        weazel = {},
        fbi = {},
        taxi = {},
        cid = {},
        cia = {},
        marshal = {},
        judge = {},
        doa = {},
    }

    for _, PlayerID in ipairs(Players) do
        local xPlayer = ESX.GetPlayerFromId(PlayerID)
        if xPlayer then
            local job = xPlayer.job
            if Jobs[job.name] and allowedJobs[job.name] then
                table.insert(Jobs[job.name], {name = xPlayer.name, grade = job.grade, id = PlayerID})
            end
        end
    end

    for jobName, jobList in pairs(Jobs) do
        table.sort(jobList, function(a, b) return a.grade > b.grade end)
    end

    TriggerClientEvent('ArSa:showJobMenu', source, Jobs)
end, false)

RegisterNetEvent('ArSa:GoToSp')
AddEventHandler('ArSa:GoToSp', function(TargetID)
    local _source = source
    TriggerClientEvent('esx_spectate:spectatexxxx', _source, TargetID)
end)

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('pedshop:buyPed')
AddEventHandler('pedshop:buyPed', function(pedModel)



    local _source = source

    local xPlayer = ESX.GetPlayerFromId(_source)
    local pedExpire, pedPrice = nil, nil

    local found = false
    for _, ped in ipairs(Config_PedShop.AvailablePedsMale) do
        if ped.model == pedModel then
            pedExpire = ped.expire
            pedPrice = ped.price
            found = true
            break
        end
    end

    if not found then
        for _, ped in ipairs(Config_PedShop.AvailablePedsFemale) do
            if ped.model == pedModel then
                pedExpire = ped.expire
                pedPrice = ped.price
                found = true
                break
            end
        end
    end

    if not pedExpire or not pedPrice then
        TriggerClientEvent('esx:showNotification', _source, "Ped Yaft Nashod!")
        return
    end

    exports.oxmysql:execute('SELECT ped_model FROM owned_peds WHERE identifier = ?', {
        xPlayer.identifier
    }, function(result)
        for _, ped in ipairs(result) do
            if ped.ped_model == pedModel then
                TriggerClientEvent('esx:showNotification', _source, "Shoma In Ped ra Ghablan Kharidari Kardid")
                return
            end
        end

        if xPlayer.canAfford(pedPrice) then
            xPlayer.payAny(pedPrice)
            local expiryTime = os.time() + (pedExpire * 86400)

            exports.oxmysql:execute('INSERT INTO owned_peds (identifier, ped_model, ped_expiry) VALUES (?, ?, FROM_UNIXTIME(?))', {
                xPlayer.identifier, pedModel, expiryTime
            })

            TriggerClientEvent('esx:showNotification', _source, "Shoma Ped Kharidid Expire: " .. pedExpire .. " Day")
            TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(_source)..'(' .. _source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Bought : Ped Model "'..tostring(pedModel)..'" ]\n[ Price : '..tostring(pedPrice)..' ]\n[ Expires In : '..tostring(pedExpire)..' days ]\n```', 'user', true, _source, false)
        else
            TriggerClientEvent('esx:showNotification', _source, "Poul Shoma Kasfi Nist!")
        end
    end)
end)

RegisterServerEvent('pedshop:getOwnedPeds')
AddEventHandler('pedshop:getOwnedPeds', function(source)



    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    exports.oxmysql:execute('SELECT ped_model, UNIX_TIMESTAMP(ped_expiry) AS expiry FROM owned_peds WHERE identifier = ?', {
        xPlayer.identifier
    }, function(result)
        local validPeds = {}

        for _, row in ipairs(result) do
            if os.time() < row.expiry then
                table.insert(validPeds, {model = row.ped_model})
            end
        end

        TriggerClientEvent('pedshop:showOwnedPeds', _source, validPeds)
    end)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        exports.oxmysql:execute('SELECT identifier, UNIX_TIMESTAMP(ped_expiry) AS expiry FROM owned_peds', {}, function(users)
            for _, user in ipairs(users) do
                if os.time() > user.expiry then
                    exports.oxmysql:execute('DELETE FROM owned_peds WHERE identifier = ? AND UNIX_TIMESTAMP(ped_expiry) = ?', { user.identifier, user.expiry })
                end
            end
        end)
    end
end)

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('esx:getPlayerData', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then
        local bank = xPlayer.bank
        local job = xPlayer.job

        cb({
            bank = bank,
            job = job
        })
    else
        cb(nil)
    end
end)

RegisterServerEvent("esx:removeBank")
AddEventHandler("esx:removeBank", function(amount)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    amount = tonumber(amount)
    -- FIX: previously any amount (including negative) was trusted from the
    -- client, so calling this with a negative number silently ADDED money to
    -- the player's bank via removeBank(). Now we require a positive integer
    -- that does not exceed the player's current bank balance.
    if not amount or amount <= 0 or amount % 1 ~= 0 or amount > xPlayer.bank then
        TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Event : esx:removeBank ]\n[ Rejected amount : '..tostring(amount)..' ]\n[ ⚠ Invalid/negative/over-balance amount blocked - possible exploit attempt ]\n```', 'user', true, source, false)
        return
    end

    xPlayer.removeBank(amount)
    TriggerEvent('DiscordBot:ToDiscord', 'amoney', 'AMoneyLog', '```css\n[ Player : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Player Steam : '..xPlayer.identifier..' ]\n[ Event : esx:removeBank ]\n[ Amount : '..tostring(amount)..' ]\n```', 'user', true, source, false)
end)

RegisterServerEvent("pase:addXP")
AddEventHandler("pase:addXP", function(playerId, xp)

end)

RegisterServerEvent("esx_ambulancejob:revivex")
AddEventHandler("esx_ambulancejob:revivex", function(playerId)

end)

ESX.RegisterServerCallback('Unique_Scripts_NPC_Doctor:chekmedic', function(source, cb)
    local Players = GetPlayers()
    local xPlayer = nil
    local dutyambulance = 0

    for i=1, #Players do
        xPlayer = ESX.GetPlayerFromId(Players[i])
        if xPlayer then
            if xPlayer.job.name == 'ambulance' then
                dutyambulance = dutyambulance + 1
            end
        end
    end

    if dutyambulance == 0 then
        cb(true)
    else
        cb(false)
    end

end)

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('jobmenu:checkPermission')
AddEventHandler('jobmenu:checkPermission', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifiers = GetPlayerIdentifiers(src)
    local steamhex = nil

    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, 'steam:') then
            steamhex = identifier
            break
        end
    end

    if not steamhex then
        return
    end


    if Config_Switchjob.AllowedJobs[steamhex] then
        TriggerClientEvent('jobmenu:openMenu', src, Config_Switchjob.AllowedJobs[steamhex])
    else
        xPlayer.showNotification('~r~Shoma Datrasi Kafi Braye in Kar Ra Ndarid!')
    end
end)

RegisterServerEvent('jobmenu:setJob')
AddEventHandler('jobmenu:setJob', function(jobData)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local identifiers = GetPlayerIdentifiers(src)
    local steamhex = nil

    for _, identifier in ipairs(identifiers) do
        if string.find(identifier, 'steam:') then
            steamhex = identifier
            break
        end
    end

    if not steamhex then
        return
    end


    if not Config_Switchjob.AllowedJobs[steamhex] then
        return
    end


    local allowed = false
    for _, job in ipairs(Config_Switchjob.AllowedJobs[steamhex]) do
        if job.name == jobData.name and job.grade == jobData.grade then
            allowed = true
            break
        end
    end

    if not allowed then
        xPlayer.showNotification('~r~Shoma Datrasi Kafi Braye in Kar Ra Ndarid!')
        return
    end


    xPlayer.setJob(jobData.name, jobData.grade)
    xPlayer.showNotification(('~g~Job Shoma Be ~y~%s~g~ Ba Rank ~b~%s~g~ Taghir Yaft!'):format(jobData.label or jobData.name, jobData.grade))
end)

RegisterCommand(Config_Switchjob.MenuCommand, function(source)
    TriggerClientEvent('jobmenu:checkPermission', source)
end, false)

ESX.RegisterServerCallback('jobmenu:getPlayerJob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb({
        name = xPlayer.job.name,
        grade = xPlayer.job.grade
    })
end)

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('vehicle:getVehicleDamage', function(source, cb, plate)
    exports.oxmysql:scalar('SELECT damage FROM owned_vehicles WHERE plate = ?', {
        plate
    }, function(damage)
        if damage then
            cb(damage)
        else
            cb(100)
        end
    end)
end)

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('checkEskenasAmount', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local eskenasCount = xPlayer.getInventoryItem('eskenas').count

    if eskenasCount >= 50000 then
        cb(true)
    else
        cb(false)
    end
end)

-- SECURITY FIX: the amount removed from inventory (itemcount) came straight
-- from the client and had NO relation to the fixed 30000 payout -- sending
-- itemcount = 0 paid out 30000 for free, repeatedly, without ever losing
-- any 'eskenas'. The removed amount is now a fixed, server-defined constant
-- that matches the requirement check, so the exchange is always 50000
-- eskenas -> 30000 cash, and the client-supplied itemcount is ignored.
local POOLKASIF_REQUIRED_ESKENAS = 50000
local POOLKASIF_PAYOUT = 30000

RegisterServerEvent('poolkasif')
AddEventHandler('poolkasif', function(itemcount)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer then return end

    if xPlayer.getInventoryItem('eskenas').count >= POOLKASIF_REQUIRED_ESKENAS then
        xPlayer.removeInventoryItem('eskenas', POOLKASIF_REQUIRED_ESKENAS)
        xPlayer.addMoney(POOLKASIF_PAYOUT)
    else
        TriggerClientEvent('esx:showNotification', _source, "شما باید 50K پول کثیف داشته باشید!")
    end
end)

ESX.RegisterServerCallback('checkJobAndBucket', function(source, cb)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local forbiddenJobs = {
        "police", "offpolice",
        "sheriff", "offsheriff",
        "mt", "offmt",
        "fbi", "offfbi",
        "cid", "offcid",
        "cia", "offcia",
        "marshal", "offmarshal",
        "judge", "offjudge",
        "doa", "offdoa",
        "taxi", "mechanic",
        "ambulance", "weazel"
    }

    if xPlayer and xPlayer.job then

        for _, job in ipairs(forbiddenJobs) do
            if xPlayer.job.name == job then
                cb(false)
                return
            end
        end

        local playerBucket = GetPlayerRoutingBucket(_source)
        if playerBucket > 0 then
            cb(false)
            return
        end
    end

    cb(true)
end)

RegisterServerEvent('notifyPolice')
AddEventHandler('notifyPolice', function(location)
    local _source = source
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        local jobName = xPlayer.job.name
        if jobName == 'police' or jobName == 'sheriff' or jobName == 'fbi' or jobName == 'mt'
            or jobName == 'cid' or jobName == 'cia' or jobName == 'marshal' or jobName == 'judge' or jobName == 'doa' then
            TriggerClientEvent('esx:showNotification', xPlayers[i], "یک نفر در حال پول‌شویی است!")
            TriggerClientEvent('createPoliceBlip', xPlayers[i], location.x, location.y, location.z)
        end
    end
end)

RegisterServerEvent('removePoliceBlip')
AddEventHandler('removePoliceBlip', function()
    local xPlayers = ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        local jobName = xPlayer.job.name
        if jobName == 'police' or jobName == 'sheriff' or jobName == 'fbi' or jobName == 'mt'
            or jobName == 'cid' or jobName == 'cia' or jobName == 'marshal' or jobName == 'judge' or jobName == 'doa' then
            TriggerClientEvent('removePoliceBlip', xPlayers[i])
        end
    end
end)

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('tires', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('Unique_Scripts_item_mc:Use', source)
end)

RegisterServerEvent('Unique_Scripts_item_mc:Used')
AddEventHandler('Unique_Scripts_item_mc:Used', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('tires', 1)
end)

ESX.RegisterUsableItem('carjack', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('Unique_Scripts_item_mc:flipp', source)
end)

RegisterNetEvent('Unique_Scripts_item_mc:removeitemss')
AddEventHandler('Unique_Scripts_item_mc:removeitemss', function(cant)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('carjack', cant)
end)

ESX.RegisterUsableItem('cleaner', function(source)
	local _source = source
	TriggerClientEvent('Unique_Scripts_item_mc:cleann', _source)
end)

RegisterNetEvent('Unique_Scripts_item_mc:removeitemssclean')
AddEventHandler('Unique_Scripts_item_mc:removeitemssclean', function(cant)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('cleaner', cant)
end)

do
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('Weapon_On_Back:GetBossGang', function(source, cb, gangname, jobname)
    if gangname ~= 'nogang' and jobname ~= "nojob" then
        cb(true)
        return
    elseif jobname ~= "nojob" then
        cb(true)
        return
    elseif jobname == "nojob" and gangname == "nogang" then
        cb(false)
        return
    elseif gangname ~= 'nogang' then
        exports.oxmysql:execute('SELECT boss FROM gangs_data WHERE gang_name = ?', {
            gangname
        }, function(result)
            if result[1] and result[1].boss then
                local bosscoords = json.decode(result[1].boss)
                cb(bosscoords)
            else
                cb(false)
            end
        end)
    end
end)

RegisterNetEvent('Weapon_On_back:SaveData')
AddEventHandler('Weapon_On_back:SaveData', function(steam1, slotsData)


    local LocadData = LoadResourceFile(GetCurrentResourceName(), 'client/SaveData.json')
    local Data      = json.decode(LocadData) or {}
    Data[steam1] = slotsData
    Wait(500)
    SaveResourceFile(GetCurrentResourceName(), 'client/SaveData.json', json.encode(Data, {indent = true}), -1)
end)

RegisterNetEvent('WeaponPlayerLoaded')
AddEventHandler('WeaponPlayerLoaded', function(source)
    Wait(5000)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local LocadData = LoadResourceFile(GetCurrentResourceName(), 'client/SaveData.json')
    local Data      = json.decode(LocadData) or {}

    if Data[xPlayer.identifier] then
        TriggerClientEvent('Weapon_On_back:PlayerSpawned', source, Data[xPlayer.identifier])
    end
end)

ESX.RegisterServerCallback("Weapon_On_Back:GetWeaponComponent", function(source, cb, WeaponName)
    local xPlayer = ESX.GetPlayerFromId(source)
    for k,v in pairs(xPlayer.loadout) do
        if v.name == WeaponName then
            cb(v.components)
            return
        end
    end

    cb({})
end)
end

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local team1 = {}
local team2 = {}
local alivePlayers = {}

RegisterServerEvent('boxing:invitePlayer')
AddEventHandler('boxing:invitePlayer', function(targetId, team)
    TriggerClientEvent('boxing:receiveInvite', targetId, source, team)
end)

RegisterServerEvent('boxing:acceptInvite')
AddEventHandler('boxing:acceptInvite', function(inviterId, team)
    local src = source
    for i=#team1,1,-1 do if team1[i] == src then table.remove(team1, i) end end
    for i=#team2,1,-1 do if team2[i] == src then table.remove(team2, i) end end

    if team == 1 then
        table.insert(team1, src)
    elseif team == 2 then
        table.insert(team2, src)
    end
end)

ESX.RegisterServerCallback('boxing:getTeams', function(source, cb)
    local players1, players2 = {}, {}

    for _, id in pairs(team1) do
        local xPlayer = ESX.GetPlayerFromId(id)
        if xPlayer then
            table.insert(players1, {id = id, name = xPlayer.name})
        end
    end

    for _, id in pairs(team2) do
        local xPlayer = ESX.GetPlayerFromId(id)
        if xPlayer then
            table.insert(players2, {id = id, name = xPlayer.name})
        end
    end

    cb(players1, players2)
end)

RegisterServerEvent('boxing:startFight')
AddEventHandler('boxing:startFight', function()

    for _, id in pairs(team1) do
        TriggerClientEvent('esx_ambulancejob:revivex', id)
        TriggerClientEvent('boxing:teleportToZone', id)
        TriggerClientEvent('boxing:startFightClient', id)
    end
    for _, id in pairs(team2) do
        TriggerClientEvent('esx_ambulancejob:revivex', id)
        TriggerClientEvent('boxing:teleportToZone', id)
        TriggerClientEvent('boxing:startFightClient', id)
    end

    Citizen.CreateThread(function()
        while true do
            alivePlayers = {}

            for _, id in pairs(team1) do
                TriggerClientEvent('boxing:checkAlive', id)
            end
            for _, id in pairs(team2) do
                TriggerClientEvent('boxing:checkAlive', id)
            end

            Citizen.Wait(3000)

            if #alivePlayers == 1 then
                local winnerId = alivePlayers[1]
                local xPlayer = ESX.GetPlayerFromId(winnerId)
                if xPlayer then
                    TriggerClientEvent('boxing:announceWinner', -1, xPlayer.name)
                    TriggerClientEvent('boxing:displayWinnerText', -1, string.gsub(xPlayer.name, "_", " "))
                end

                for _, id in pairs(team1) do
                    TriggerClientEvent('boxing:returnToMarker', id)
                end
                for _, id in pairs(team2) do
                    TriggerClientEvent('boxing:returnToMarker', id)
                end

                TriggerClientEvent('boxing:matchEnded', -1)

                team1 = {}
                team2 = {}

                break
            end

            Citizen.Wait(3000)
        end
    end)
end)

RegisterServerEvent('boxing:checkAliveResult')
AddEventHandler('boxing:checkAliveResult', function(isAlive)
    if isAlive then
        table.insert(alivePlayers, source)
    end
end)

RegisterNetEvent('Unique_Boxing:ended')
AddEventHandler('Unique_Boxing:ended', function()
    local winnerId = alivePlayers[1]
    local xPlayer = ESX.GetPlayerFromId(winnerId)
    Wait(5000)
    if xPlayer then
        TriggerClientEvent('boxing:announceWinner', -1, xPlayer.name)
        TriggerClientEvent('boxing:displayWinnerText', -1, xPlayer.name)
    end

    for _, id in pairs(team1) do
        TriggerClientEvent('boxing:returnToMarker', id)
    end
    for _, id in pairs(team2) do
        TriggerClientEvent('boxing:returnToMarker', id)
    end

    TriggerClientEvent('boxing:matchEnded', -1)

    team1 = {}
    team2 = {}
end)