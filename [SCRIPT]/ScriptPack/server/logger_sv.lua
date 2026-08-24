ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local alogs 		= "https:// arshiahub.ir/changeme/1219998148894654474/MXIY_O4nnv7d7KfFQIkJ8xRd3pKQTexL2DBDeUNZr_m3qOCvAW_fPyGJICnCPHjADsyb"
local infologs 		= "https:// arshiahub.ir/changeme/1217536908209557705/1KtYLoI-Q7RmbBGcK4tpiRJCW54eCb8_ITzpyPyrLLow8plODz1L2xQDNzSGW54DSCmu"
local ganglog 		= "https:// arshiahub.ir/changeme/1219998040014848095/FJTWwEyGBq7yU52f649nEoLxbqSRBIHzkirbRh09inP386SeFW5p4p0FEQrRAti4H9Iv"
local homelog 		= "https:// arshiahub.ir/changeme/1217534722633105568/oqsN6J3IslcQ8ZGQRQ1RmaJy3DgqJGeBQ_GZuYnAuaqdPFg0CAE87k2N_WpwmWx7BFum"
local trunklog 		= "https:// arshiahub.ir/changeme/1219997766701289502/iWHlBEjEnvPvjE0jR8NGguOezPRvgxy14CrEC-i4dahKmJtevODYxLGd8sG5JKQyQW9r"
local atmlog 		= "https:// arshiahub.ir/changeme/1217533571456176148/nZcYY6TfrIOUhmkA0XBwGiUNEU4e_LDc6fdwrN5scNCwyXNyw7H8a5yZoy1xT0lzb64h"
local roblog 		= "https:// arshiahub.ir/changeme/1217532268373872650/IWPsgUJmxQt_-6VVPm_c5pY5IlpSy2JEW5xsv9B1sTFKFFAx20C0QE_cTq6FQumrRdl1"
local pedlog 		= ""
local proplog 		= ""
local vehlog 		= ""
local Rewardalllog  = 'https:// arshiahub.ir/changeme/1219997168694333470/AcP0KZnOvBhhxUcsABzQbs-yrLg4Ueq6yprxSdDQ24aWizGI5Ef_wZ8l5CXrzAZvWoII'
local communityname = "Server Test"
local communtiylogo = "https://media.discordapp.net/attachments/669926392921849875/939876376784273458/ServerTest.png"

RegisterServerEvent("esx_logger:log")
AddEventHandler("esx_logger:log", function(src, reason)

    local source = src
    local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer == nil then
		Wait(10)
		return
	end
    local name = GetPlayerName(source)
    local ip = GetPlayerEndpoint(source)
    local ping = GetPlayerPing(source)
    local steamhex = xPlayer.identifier

    local disconnect = {
            {
                ["color"] = "16711680",
                ["title"] = "Cheat has been detected",
                ["description"] = "**Player:** ".. name .." | " .. exports.essentialmode:IcName(source) .. " (" .. GetDiscord(source) .. ") **[" .. source .."]**\nReason: **"..reason.."**\nIP: **"..ip.."**\nID: **" .. source .. "**\nSteam Hex: **"..steamhex.."**\n**Discord:** " .. GetDiscord(source) .. "",
                ["footer"] = {
                    ["text"] = "ServerTest Log",
                    ["icon_url"] = communtiylogo,
                },
            }
        }

    PerformHttpRequest(alogs, function(err, text, headers) end, 'POST', json.encode({username = "ServerTest  Log", embeds = disconnect}), { ['Content-Type'] = 'application/json' })

end)

RegisterServerEvent("esx_logger:log2")
AddEventHandler("esx_logger:log2", function(src, info)
    local source = src
    local name = GetPlayerName(source)

    local disconnect = {
            {
                ["color"] = "16711680",
                ["title"] = "Purge Details",
                ["description"] = info.iniator .. " has been requested by **".. name .."** (" .. GetDiscord(source) .. ")\n Weapon: **" .. info.weapon.. "**\nTotal users: **"..info.utotal.."**, Total users had that weapon: **" .. info.udtotal .. "**\nTotal vehicles: **"..info.vtotal.."**, Total vehicles had that weapon: **" .. info.vdtotal .. "**\nTotal properties: **"..info.ptotal.."**, Total properties had that weapon: **" .. info.pdtotal .. "**\nTotal gangs: **"..info.gtotal.."**, Total gangs had that weapon: **" .. info.gdtotal .. "**\nTotal weapons: **" .. info.dtotal .."**",
                ["footer"] = {
                    ["text"] = "ServerTest Log",
                    ["icon_url"] = communtiylogo,
                },
            }
        }

    PerformHttpRequest(infologs, function(err, text, headers) end, 'POST', json.encode({username = "Purge Handler", embeds = disconnect}), { ['Content-Type'] = 'application/json' })

end)

RegisterServerEvent("esx_logger:log3")
AddEventHandler("esx_logger:log3", function(src, info)
    local source = src
    local name = GetPlayerName(source)

    local disconnect = {
            {
                ["color"] = "16711680",
                ["title"] = "Purge Details",
                ["description"] = "Count wave has been requested by **".. name .."** (" .. GetDiscord(source) .. ")\n Type: " .. info.type .. "\n Owner: " .. info.owner,
                ["footer"] = {
                    ["text"] = "ServerTest Log",
                    ["icon_url"] = communtiylogo,
                },
            }
        }

    PerformHttpRequest(infologs, function(err, text, headers) end, 'POST', json.encode({username = "Purge Handler", embeds = disconnect}), { ['Content-Type'] = 'application/json' })

end)

RegisterServerEvent("esx_logger:log4")
AddEventHandler("esx_logger:log4", function(src, info, d)
    local source = src
    local name = GetPlayerName(source)

    local disconnect = {
            {
                ["color"] = "16711680",
                ["title"] = "StarterPackCollected",
                ["description"] = "```css\n[ Identifier : "..info.identifier.." ]\n[ Name : "..name.." ]\n[ Add Bank = 95000 ]\n[ Add Money : 5000 ]\n[ Money : "..info.money.." ]\n[ Bank : "..info.bank.." ]\n```",
                ["footer"] = {
                    ["text"] = "AZ :)",
                    ["icon_url"] = communtiylogo,
                },
            }
        }

    PerformHttpRequest(d, function(err, text, headers) end, 'POST', json.encode({username = "AZ", embeds = disconnect}), { ['Content-Type'] = 'application/json' })

end)

RegisterServerEvent("esx_logger:log5")
AddEventHandler("esx_logger:log5", function(src, info, d)
    local source = src
    local name = GetPlayerName(source)

    local disconnect = {
            {
                ["color"] = "16711680",
                ["title"] = "StarterPackCollected",
                ["description"] = "```css\n("..GetPlayerName(info.source).."|"..info.source..")\n Change_Discord_Id\n("..GetPlayerName(info.targetid).."|"..info.targetid..")\n Discord_Id =="..info.dsid.."\n```",
                ["footer"] = {
                    ["text"] = "AZ :)",
                    ["icon_url"] = communtiylogo,
                },
            }
        }

    PerformHttpRequest(d, function(err, text, headers) end, 'POST', json.encode({username = "AZ", embeds = disconnect}), { ['Content-Type'] = 'application/json' })

end)

function GangLog(info)
    local source = tonumber(info.source)
    local name = GetPlayerName(info.source)

    local color
    if info.type == "Gozasht" then color = "51712" elseif info.type == "Bardasht" then color = "15852071" end

    local details = {
            {
                ["color"] = color,
                ["title"] = "Gang Log",
                ["description"] = "**Person:** ".. name ..", " .. info.icname .. " (" .. GetDiscord(source) .. ") **[" .. source .."]**\n **Gang:** " .. info.gang  .."\n **Type:** " .. info.type .. "\n **Esm:** " .. info.name .. "\n **Tedad:** " .. info.count,
                ["footer"] = {
                    ["text"] = "Action Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }

    PerformHttpRequest(ganglog, function(err, text, headers) end, 'POST', json.encode({username = "Gang Log", embeds = details}), { ['Content-Type'] = 'application/json' })
end

function HomeLog(info)
    local source = tonumber(info.source)
    local name = GetPlayerName(info.source)

    local color
    if info.type == "Gozasht" then color = "51712" elseif info.type == "Bardasht" then color = "15852071" end

    local details = {
            {
                ["color"] = color,
                ["title"] = "Home Log",
                ["description"] = "**Person:** ".. name ..", " .. info.icname .. " (" .. GetDiscord(source) .. ") **[" .. source .."]**\n **Type:** " .. info.type .. "\n **Esm:** " .. info.name .. "\n **Tedad:** " .. info.count,
                ["footer"] = {
                    ["text"] = "Action Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }

    PerformHttpRequest(homelog, function(err, text, headers) end, 'POST', json.encode({username = "Home Log", embeds = details}), { ['Content-Type'] = 'application/json' })
end

function TrunkLog(info)
    local source = tonumber(info.source)
    local name = GetPlayerName(info.source)

    local color
    if info.type == "Gozasht" then color = "51712" elseif info.type == "Bardasht" then color = "15852071" end

    local details = {
            {
                ["color"] = color,
                ["title"] = "Trunk Log",
                ["description"] = "**Person:** ".. name .." | " .. info.icname .. " (" .. GetDiscord(source) .. ") **[" .. source .."]**\n **Type:** " .. info.type .. "\n**Plate:** " .. info.plate .. "\n**Esm:** " .. info.name .. "\n **Tedad:** " .. info.count,
                ["footer"] = {
                    ["text"] = "Action Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }

    PerformHttpRequest(trunklog, function(err, text, headers) end, 'POST', json.encode({username = "Trunk Log", embeds = details}), { ['Content-Type'] = 'application/json' })
end

function TransActionLog(info)
    local source = tonumber(info.source)
    local name = GetPlayerName(info.source)

    local color
    if info.type == "Variz" then color = "51712" elseif info.type == "Bardasht" then color = "15852071" end

    local details = {
            {
                ["color"] = color,
                ["title"] = "Transaction Log",
                ["description"] = "**Type:** " .. info.type .. "\n**Person:** ".. name .." | " .. exports.essentialmode:IcName(source) .. " (" .. GetDiscord(source) .. ") **[" .. source .."]**\n**Amount:** " .. info.amount .. "$\n**Identifier:** " .. GetPlayerIdentifier(source),
                ["footer"] = {
                    ["text"] = "Action Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }

    PerformHttpRequest(atmlog, function(err, text, headers) end, 'POST', json.encode({username = "Transaction Log", embeds = details}), { ['Content-Type'] = 'application/json' })
end

function RewardAll(info)
    local source = tonumber(info.source)
    local name = GetPlayerName(info.source)


    local details = {
            {
                ["color"] = 15852071,
                ["title"] = "Rewardall Log",
                ["description"] = "**Person:** ".. name .." | " .. exports.essentialmode:IcName(source) .. " (" .. GetDiscord(source) .. ") **[" .. source .."]**\n**Amount:** " .. info.amount .. "$\n**Identifier:** " .. GetPlayerIdentifier(source)..'\n Ids = \n ```css\n'..json.encode(info.ids)..'\n```',
                ["footer"] = {
                    ["text"] = "Action Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }

    PerformHttpRequest(Rewardalllog, function(err, text, headers) end, 'POST', json.encode({username = "RewardAll", embeds = details}), { ['Content-Type'] = 'application/json' })
end

function TransferLog(info)
    local source = tonumber(info.source)
    local name = GetPlayerName(info.source)
    local target = tonumber(info.target)
    local tname = GetPlayerName(info.target)

    local details = {
            {
                ["color"] = "2868934",
                ["title"] = "Transaction Log",
                ["description"] = "**Type:** " .. info.type .. "\n**Person:** ".. name .." | " .. exports.essentialmode:IcName(source) .. " (" .. GetDiscord(source) .. ") **[" .. source .."]**\n**Target:** ".. tname .." | " .. exports.essentialmode:IcName(target) .. " (" .. GetDiscord(target) .. ") **[" .. target .."]**\n**Amount:** " .. info.amount .. "$\n**Identifier:** " .. GetPlayerIdentifier(source) .. "\n**Tidentifier:** " .. GetPlayerIdentifier(target),
                ["footer"] = {
                    ["text"] = "Action Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }

    PerformHttpRequest(atmlog, function(err, text, headers) end, 'POST', json.encode({username = "Transaction Log", embeds = details}), { ['Content-Type'] = 'application/json' })
end

function RobLog(info)
    local source = tonumber(info.source)
    local name = GetPlayerName(info.source)

    local color
    if info.type == "Shop" then color = "1883948" elseif info.type == "Jewels" then color = "14610984" elseif info.type == "Bank" then color = "16187398" end
    local amount
    if info.amount then amount = "\n **Amount:** " .. info.amount .. "$" else amount = "" end

    local details = {
            {
                ["color"] = color,
                ["title"] = "Rob Log",
                ["description"] = "**Person:** ".. name .." | " .. exports.essentialmode:IcName(source) .. " (" .. GetDiscord(source) .. ") **[" .. source .."]**\n **Type:** " .. info.type .. "\n**Action:** " .. info.action .. "\n**Location:** " .. info.location .. "\n**Time:** " .. Date() .. amount,
                ["footer"] = {
                    ["text"] = "Action Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }

    PerformHttpRequest(roblog, function(err, text, headers) end, 'POST', json.encode({username = "Rob Log", embeds = details}), { ['Content-Type'] = 'application/json' })
end

AddPed = function(info)

    local name = GetPlayerName(info.source)
    local ip = GetPlayerEndpoint(info.source)
    local ping = GetPlayerPing(info.source)
    local steamhex = GetPlayerIdentifier(info.source)

    local details = {
            {
                ["color"] = 16187398,
                ["title"] = "EntityCreating_Ped",
                ["description"] = "**Player:** ".. name .." | " .. exports.essentialmode:IcName(info.source) .. " (" .. GetDiscord(info.source) .. ") **[" .. info.source .."]**\nPed: **"..info.prop.." | Type : "..info.type.." | Network ID : "..info.netid.."**\nIP: **"..ip.."**\nID: **" .. source .. "**\nSteam Hex: **"..steamhex.."**\n**Discord:** " .. GetDiscord(source) .. "",
                ["footer"] = {
                    ["text"] = "Action Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }

    PerformHttpRequest(pedlog, function(err, text, headers) end, 'POST', json.encode({username = "Rob Log", embeds = details}), { ['Content-Type'] = 'application/json' })
end
AddProp = function(info)

    local name = GetPlayerName(info.source)
    local ip = GetPlayerEndpoint(info.source)
    local ping = GetPlayerPing(info.source)
    local steamhex = GetPlayerIdentifier(info.source)

    local details = {
            {
                ["color"] = 16187398,
                ["title"] = "EntityCreating_ProP",
                ["description"] = "**Player:** ".. name .." | " .. exports.essentialmode:IcName(info.source) .. " (" .. GetDiscord(info.source) .. ") **[" .. info.source .."]**\nProp: **"..info.prop.." | Type : "..info.type.." | Network ID : "..info.netid.."**\nIP: **"..ip.."**\nID: **" .. source .. "**\nSteam Hex: **"..steamhex.."**\n**Discord:** " .. GetDiscord(source) .. "",
                ["footer"] = {
                    ["text"] = "Action Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }

    PerformHttpRequest(proplog, function(err, text, headers) end, 'POST', json.encode({username = "Rob Log", embeds = details}), { ['Content-Type'] = 'application/json' })
end
AddVehicle = function(info)

    local name = GetPlayerName(info.source)
    local ip = GetPlayerEndpoint(info.source)
    local ping = GetPlayerPing(info.source)
    local steamhex = GetPlayerIdentifier(info.source)

    local details = {
            {
                ["color"] = 16187398,
                ["title"] = "EntityCreating_Vehicle",
                ["description"] = "**Player:** ".. name .." | " .. exports.essentialmode:IcName(info.source) .. " (" .. GetDiscord(info.source) .. ") **[" .. info.source .."]**\nProp: **"..info.prop.." | Type : "..info.type.." | Network ID : "..info.netid.."**\nIP: **"..ip.."**\nID: **" .. source .. "**\nSteam Hex: **"..steamhex.."**\n**Discord:** " .. GetDiscord(source) .. "",
                ["footer"] = {
                    ["text"] = "Action Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }

    PerformHttpRequest(vehlog, function(err, text, headers) end, 'POST', json.encode({username = "Rob Log", embeds = details}), { ['Content-Type'] = 'application/json' })
end

function RobLogF(info)
    local color
    if info.type == "Shop" then color = "1883948" elseif info.type == "Jewels" then color = "14610984" elseif info.type == "Bank" then color = "16187398" end

    local details = {
            {
                ["color"] = color,
                ["title"] = "Rob Log",
                ["description"] = "**Person:** ".. info.name .." | " .. info.icname .. " (" .. info.discord .. ") **[" .. info.source .."]**\n **Type:** " .. info.type .. "\n**Action:** " .. info.action .. "\n**Location:** " .. info.location .. "\n**Time:** " .. Date(),
                ["footer"] = {
                    ["text"] = "Action Description",
                    ["icon_url"] = communtiylogo,
                },
            }
        }

    PerformHttpRequest(roblog, function(err, text, headers) end, 'POST', json.encode({username = "Rob Log", embeds = details}), { ['Content-Type'] = 'application/json' })
end

function Date()
    local date = os.date('*t')

	if date.day < 10 then date.day = '0' .. tostring(date.day) end
	if date.month < 10 then date.month = '0' .. tostring(date.month) end
	if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
	if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end

    return '`' .. date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec .. '`'
end

function GetDiscord(target)
    local discord
    for k,v in ipairs(GetPlayerIdentifiers(target)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = string.gsub(v, "discord:", "")
           return "<@" .. discord .. ">"
        end
    end

    return "N/A"
end