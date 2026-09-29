-- ============================================================
-- DOJ court-processing fee (added per request): every time police, sheriff
-- or mt fines a citizen (esx_billing:send2Bill into their own society
-- account), DOJ also bills that SAME citizen a separate, smaller invoice
-- into society_doj - representing the court's own cut for processing the
-- case that fine is attached to.
--
-- Registers its own handler directly on esx_billing:send2Bill. FXServer
-- calls every handler bound to an event name regardless of which resource
-- registered it, so this coexists safely with Unique_LevelQuest's own hook
-- on the same event (server/bridges.lua, which awards the officer's
-- Coin/XP quest reward) without either file needing to know about the
-- other - same reasoning documented there for why multiple hooks on one
-- event name is the established, safe pattern on this server.
--
-- IMPORTANT: this does NOT re-trigger esx_billing:send2Bill itself for the
-- DOJ cut. Doing that would re-run every handler on that event a second
-- time for what the officer experiences as one fine - including
-- bridges.lua's own hook, which would then award a second, unearned
-- quest-<job>:fine Coin/XP reward. Instead this inserts directly into the
-- same `billing` table esx_billing itself writes to, producing a second,
-- independent invoice with none of that event's other side effects.
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local CUT_JOBS = { police = true, sheriff = true, mt = true }

AddEventHandler('esx_billing:send2Bill', function(target, society, label, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if not xPlayer or not CUT_JOBS[xPlayer.job.name] then return end
	if society == 'society_doj' then return end -- a judge's own fine already goes straight to DOJ - don't cut it again

	local percent = (Config_judge and Config_judge.CourtProcessingCutPercent) or 0
	if percent <= 0 then return end

	local cut = ESX.Math.Round((tonumber(amount) or 0) * (percent / 100))
	if cut <= 0 then return end

	local xTarget = ESX.GetPlayerFromId(target)
	if not xTarget then return end

	MySQL.Async.execute('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (@identifier, @sender, @target_type, @target, @label, @amount)', {
		['@identifier']  = xTarget.identifier,
		['@sender']      = xPlayer.identifier,
		['@target_type'] = 'society',
		['@target']      = 'society_doj',
		['@label']       = 'Docket Processing Fee',
		['@amount']      = cut,
	}, function()
		TriggerClientEvent('chat:addMessage', xTarget.source, { args = { '^1SYSTEM', 'You received an invoice.' } })
	end)
end)
