local webhook = "https://discord.com/api/webhooks/1197226578812354640/44qT1YVTnDPhWYb_AzdjdHyqoUHpsWC-jSHJSOH9sLkQFItN_smA6XTZ3cYOmeD97Zyz"

function DiscordMessage()
    local date = os.date('*t')
    print("Server Is Online")
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    local date = (''..date.day .. '.' .. date.month .. '.' .. date.year .. ' - ' .. date.hour .. ':' .. date.min .. ':' .. date.sec..'')
    local embeds = {
        {
            ["title"] = "Server Restarted ✅",
            ["type"]="rich",
            ["color"] = "3066993",
            ["description"] = "**Server Run Shod Mitonid Join Beshid**\nIP : `000.000.000.000`",
            ["footer"]=  {
                ["icon_url"] = "https://cdn.discordapp.com/icons/912968863359045632/268e4c311455fe8751077c417f698bff.png",
                ["text"]= "Start At : " ..date.."",
            },
        }
    }
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({ username = "Black Band RP",content = '@everyone',embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		local sleep = 2000
		Wait(sleep)
		DiscordMessage()
	end
end)