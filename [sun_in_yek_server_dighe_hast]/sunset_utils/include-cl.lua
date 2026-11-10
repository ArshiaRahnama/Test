-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

-- local whileList = {
--     ['sun-garage'] = true,
--     ['xsound'] = true,
--     ['sunset_phone'] = true,
-- }

-- local sanitizeWhileList = {
-- }

-- local resourceName = GetCurrentResourceName()

-- local orginalCallback = RegisterNUICallback
-- local orginalSendNuiMessage = SendNUIMessage

-- CreateThread(function()
--     Wait(5000)
--     if not ESX then
--         ESX = exports['essentialmode']:getObject()
--     end
-- end)

-- if not whileList[resourceName] then
--     function RegisterNUICallback(name, cb)
--         orginalCallback(name, function(data2, cb2)
--             local dataType = type(data2)
--             if dataType == 'string' then
--                 if ESX.containsXSS(data2) then
--                     TriggerServerEvent('discord:log3', data2)
--                     cb()
--                     return
--                 end
--             elseif dataType == 'table' then
--                 local jsonString = json.encode(data2)
--                 if jsonString and ESX.containsXSS(jsonString) then
--                     TriggerServerEvent('discord:log3', jsonString)
--                     cb()
--                     return
--                 end
--             end
--             cb(data2, cb2)
--         end)
--     end

--     -- function SendNUIMessage(data)
--     --     if sanitizeWhileList[resourceName] then
--     --         orginalSendNuiMessage(data)
--     --     else
--     --         orginalSendNuiMessage(ESX.sanitizeXSS(data))
--     --     end
--     -- end
-- end

SUN = SUN or {}
SUN.log = function(...)
    TriggerServerEvent('DiscordBot:ToDiscord', ...)
end

local oldGetPlayerName = GetPlayerName
function GetPlayerName(src, ic)
    if ESX then
        if ic then
            return (ESX.GetPlayerState(GetPlayerServerId(src), 'name2') or 'Unknown')
        else
            return 'U'.. (ESX.GetPlayerState(GetPlayerServerId(src), 'rawId') or 0)
        end
        -- end
    end
    return 'User '.. GetPlayerServerId(src)
end

local oldRegisterCommand = RegisterCommand

function RegisterCommand(name, cb, restricted)
    oldRegisterCommand(name, function(src, args, raw)
        cb(src, args, raw)
        if not string.match(name, "^[%+%-]") then
            TriggerServerEvent('log:chatLog', ('/%s %s'):format(name, table.concat(args, ' ')))
        end
    end, restricted)
end
