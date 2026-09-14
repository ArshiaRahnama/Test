ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- The old '/mp' command that used to live in this file is gone -- '[SCRIPT]/ScriptPack/server/rpchat-sv.lua'
-- already registers its own '/mp' (proximity-based, covers the same jobs), and two resources
-- registering the same command silently shadow each other (whichever loads last wins), so this
-- was a straight duplicate, not a second feature. sendToSet/SendDeptMessage below are kept --
-- they're a different thing: a server-side export other resources call directly (no slash
-- command, no player typing anything), used e.g. by esx_drugs to post a convoy/raid alert
-- straight into DOA's in-game chat instead of only Discord.
local function sendToSet(jobSet, tag, color, senderName, senderGradeLabel, message)
	local xPlayers = ESX.GetPlayers()
	for i = 1, #xPlayers do
		local xTarget = ESX.GetPlayerFromId(xPlayers[i])
		if xTarget and jobSet[xTarget.job.name] then
			TriggerClientEvent('chatMessage', xPlayers[i], '', color,
				('[%s | %s] %s: %s'):format(tag, senderGradeLabel, senderName, message))
		end
	end
end

function SendDeptMessage(jobName, tag, color, senderName, senderGradeLabel, message)
	sendToSet({ [jobName] = true }, tag, color, senderName, senderGradeLabel or '-', message)
end

exports('SendDeptMessage', SendDeptMessage)
