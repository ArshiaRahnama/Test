-- ============================================================
-- Unified Unit Manager
-- Replaces the old per-job createunit_X / delunit_X / renameunit_X /
-- disbanunit_X / units_X / joinunit_X / leaveunit_X commands.
-- One system, scoped per department (see shared/departments.lua),
-- driven entirely through the /unit menu (client/unit_manager.lua).
-- ============================================================

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Units     = {} -- Units[deptId][ownerIdentifier]    = { callsign, ownerName, members = { [identifier] = name } }
local Callsigns = {} -- Callsigns[deptId][UPPER_CALLSIGN] = ownerIdentifier

local MANAGE_GRADE = 18 -- rank required to view/kick/disband units you don't own (mirrors the old admin threshold)

for _, dept in ipairs(Departments) do
	Units[dept.id] = {}
	Callsigns[dept.id] = {}
end

local function tableLength(t)
	local count = 0
	for _ in pairs(t) do count = count + 1 end
	return count
end

-- Returns ownerIdentifier, role ('owner' | 'member') for a player's current unit in a department, or nil
local function findUnitFor(deptId, identifier)
	if Units[deptId][identifier] then
		return identifier, 'owner'
	end

	for owner, unit in pairs(Units[deptId]) do
		if unit.members[identifier] then
			return owner, 'member'
		end
	end

	return nil, nil
end

-- Looks up a player's unit callsign across every department, regardless
-- of owner/member role. Returns nil if they're not in a unit.
-- Global (not local) so other files in this resource -- e.g. the panic/
-- backup dispatch system -- can call it directly to show which unit
-- is responding.
function GetPlayerUnitCallsign(identifier)
	for deptId in pairs(Units) do
		local ownerId = findUnitFor(deptId, identifier)
		if ownerId then
			return Units[deptId][ownerId].callsign
		end
	end
	return nil
end

local function setCallsignForIdentifier(identifier, callsign)
	local xTarget = ESX.GetPlayerFromIdentifier(identifier)
	if xTarget then
		TriggerClientEvent('esx:setcallsign', xTarget.source, callsign)
	end
end

local function notifyDept(deptId, message)
	TriggerClientEvent('esx_uniquejobs:unitNotify', -1, deptId, message)
end

local function notifySource(source, message)
	TriggerClientEvent('chatMessage', source, "[ System ] ", {255, 0, 0}, message)
end

local function cleanName(name)
	return string.gsub(name, "_", " ")
end

-- ============================================================
-- Menu data
-- ============================================================

ESX.RegisterServerCallback('esx_uniquejobs:getUnitMenu', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then cb(nil) return end

	local dept = GetDepartmentForJob(xPlayer.job.name)
	if not dept then cb(nil) return end

	local identifier = xPlayer.identifier
	local ownerId, role = findUnitFor(dept.id, identifier)

	local myUnit = nil
	if ownerId then
		local unit = Units[dept.id][ownerId]
		local members = {}
		for memberId, memberName in pairs(unit.members) do
			members[#members + 1] = { identifier = memberId, name = memberName }
		end

		myUnit = {
			callsign = unit.callsign,
			ownerName = unit.ownerName,
			ownerIdentifier = ownerId,
			isOwner = (role == 'owner'),
			members = members,
		}
	end

	local allUnits = {}
	for owner, unit in pairs(Units[dept.id]) do
		allUnits[#allUnits + 1] = {
			callsign = unit.callsign,
			ownerName = unit.ownerName,
			ownerIdentifier = owner,
			memberCount = tableLength(unit.members),
		}
	end

	cb({
		deptId = dept.id,
		deptLabel = dept.label,
		canManage = xPlayer.job.grade >= MANAGE_GRADE,
		myUnit = myUnit,
		allUnits = allUnits,
	})
end)

-- ============================================================
-- Create
-- ============================================================

RegisterServerEvent('esx_uniquejobs:createUnit')
AddEventHandler('esx_uniquejobs:createUnit', function(name)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not name or name == '' then return end

	local dept = GetDepartmentForJob(xPlayer.job.name)
	if not dept then notifySource(source, "Shoma Dastresi Kafi Nadarid") return end

	local identifier = xPlayer.identifier
	local ownerId = findUnitFor(dept.id, identifier)
	if ownerId then
		notifySource(source, "Shoma Dar Hale Hazer Unit Darid")
		return
	end

	local uCallsign = string.upper(name)
	if Callsigns[dept.id][uCallsign] then
		notifySource(source, "Callsign ^2" .. uCallsign .. "^0 Ghablan Sakhte Shode Ast!")
		return
	end

	Units[dept.id][identifier] = {
		callsign = uCallsign,
		ownerName = cleanName(xPlayer.name),
		members = {},
	}
	Callsigns[dept.id][uCallsign] = identifier

	TriggerClientEvent('esx:setcallsign', source, uCallsign)
	notifyDept(dept.id, " Vahed ^2" .. uCallsign .. "^0 Tavasot ^3" .. cleanName(xPlayer.name) .. "^0 Sakhte Shod!")
end)

-- ============================================================
-- Rename (owner only)
-- ============================================================

RegisterServerEvent('esx_uniquejobs:renameUnit')
AddEventHandler('esx_uniquejobs:renameUnit', function(newName)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not newName or newName == '' then return end

	local dept = GetDepartmentForJob(xPlayer.job.name)
	if not dept then return end

	local identifier = xPlayer.identifier
	local unit = Units[dept.id][identifier]
	if not unit then
		notifySource(source, "Shoma Saheb Hich Uniti Nistid")
		return
	end

	local uNewCallsign = string.upper(newName)
	if uNewCallsign == unit.callsign then
		notifySource(source, "Shoma Nemitavanid Callsign Ghabli Khod Ra Entekhab Konid!")
		return
	end

	if Callsigns[dept.id][uNewCallsign] then
		notifySource(source, "Callsign ^2" .. uNewCallsign .. "^0 Ghablan Sakhte Shode Ast!")
		return
	end

	local oldCallsign = unit.callsign
	Callsigns[dept.id][oldCallsign] = nil
	Callsigns[dept.id][uNewCallsign] = identifier
	unit.callsign = uNewCallsign

	TriggerClientEvent('esx:setcallsign', source, uNewCallsign)
	for memberId in pairs(unit.members) do
		setCallsignForIdentifier(memberId, uNewCallsign)
	end

	notifyDept(dept.id, " Vahed ^2" .. oldCallsign .. "^0 Be ^3" .. uNewCallsign .. "^0 Taghir Yaft!")
end)

-- ============================================================
-- Disband (owner, or manage-grade force-disbanding someone else's)
-- ============================================================

local function disbandUnit(deptId, ownerId, disbandedByName)
	local unit = Units[deptId][ownerId]
	if not unit then return end

	Callsigns[deptId][unit.callsign] = nil
	setCallsignForIdentifier(ownerId, nil)
	for memberId in pairs(unit.members) do
		setCallsignForIdentifier(memberId, nil)
	end

	Units[deptId][ownerId] = nil
	notifyDept(deptId, " Vahed ^2" .. unit.callsign .. "^0 Tavasot ^3" .. disbandedByName .. "^0 Monhal Shod!")
end

RegisterServerEvent('esx_uniquejobs:disbandUnit')
AddEventHandler('esx_uniquejobs:disbandUnit', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end

	local dept = GetDepartmentForJob(xPlayer.job.name)
	if not dept then return end

	local identifier = xPlayer.identifier
	if not Units[dept.id][identifier] then
		notifySource(source, "Shoma Saheb Hich Uniti Nistid")
		return
	end

	disbandUnit(dept.id, identifier, cleanName(xPlayer.name))
end)

RegisterServerEvent('esx_uniquejobs:forceDisbandUnit')
AddEventHandler('esx_uniquejobs:forceDisbandUnit', function(ownerIdentifier)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not ownerIdentifier then return end

	local dept = GetDepartmentForJob(xPlayer.job.name)
	if not dept then return end

	if xPlayer.job.grade < MANAGE_GRADE then
		notifySource(source, "Shoma Dastresi Kafi Baraye In Dastor Ra Nadarid")
		return
	end

	if not Units[dept.id][ownerIdentifier] then
		notifySource(source, "In Unit Vojod Nadarad")
		return
	end

	local disbandedCallsign = Units[dept.id][ownerIdentifier].callsign
	TriggerEvent('DiscordBot:ToDiscord', 'adminmenu', 'UnitLog', '```css\n[ Officer : '..GetPlayerName(source)..'(' .. source .. ') ]\n[ Action : FORCE DISBANDED UNIT ]\n[ Unit Callsign : '..tostring(disbandedCallsign)..' ]\n[ Owner Identifier : '..tostring(ownerIdentifier)..' ]\n```', 'user', true, source, false)
	disbandUnit(dept.id, ownerIdentifier, cleanName(xPlayer.name))
end)

-- ============================================================
-- Join / Leave
-- ============================================================

RegisterServerEvent('esx_uniquejobs:joinUnit')
AddEventHandler('esx_uniquejobs:joinUnit', function(ownerIdentifier)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not ownerIdentifier then return end

	local dept = GetDepartmentForJob(xPlayer.job.name)
	if not dept then return end

	local identifier = xPlayer.identifier
	if findUnitFor(dept.id, identifier) then
		notifySource(source, "Shoma Dar Hale Hazer Unit Darid!")
		return
	end

	local unit = Units[dept.id][ownerIdentifier]
	if not unit then
		notifySource(source, "In Unit Vojod Nadarad!")
		return
	end

	unit.members[identifier] = cleanName(xPlayer.name)
	TriggerClientEvent('esx:setcallsign', source, unit.callsign)
	notifyDept(dept.id, "^3" .. cleanName(xPlayer.name) .. "^0 Be Vahed ^2" .. unit.callsign .. "^0 Molhagh Shod!")
end)

RegisterServerEvent('esx_uniquejobs:leaveUnit')
AddEventHandler('esx_uniquejobs:leaveUnit', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return end

	local dept = GetDepartmentForJob(xPlayer.job.name)
	if not dept then return end

	local identifier = xPlayer.identifier
	local ownerId, role = findUnitFor(dept.id, identifier)

	if not ownerId then
		notifySource(source, "Shoma Dakhele Hich Uniti Nistid!")
		return
	end

	if role == 'owner' then
		notifySource(source, "Shoma Nemitavanid AzVahed Khod Kharej Shavid! (Disband Konid)")
		return
	end

	local unit = Units[dept.id][ownerId]
	unit.members[identifier] = nil
	TriggerClientEvent('esx:setcallsign', source, nil)
	notifyDept(dept.id, "^3" .. cleanName(xPlayer.name) .. "^0 AzVahed ^2" .. unit.callsign .. "^0 Kharej Shod!")
end)

-- ============================================================
-- Kick a member (owner of that unit, or manage-grade)
-- ============================================================

RegisterServerEvent('esx_uniquejobs:kickMember')
AddEventHandler('esx_uniquejobs:kickMember', function(memberIdentifier)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer or not memberIdentifier then return end

	local dept = GetDepartmentForJob(xPlayer.job.name)
	if not dept then return end

	local identifier = xPlayer.identifier
	local unit = Units[dept.id][identifier]

	if not unit then
		-- not an owner: allow if manage-grade, but need to find which unit the member belongs to
		if xPlayer.job.grade < MANAGE_GRADE then
			notifySource(source, "Shoma Dastresi Kafi Baraye In Dastor Ra Nadarid")
			return
		end

		local ownerId = select(1, findUnitFor(dept.id, memberIdentifier))
		if not ownerId then return end
		unit = Units[dept.id][ownerId]
	end

	if not unit.members[memberIdentifier] then return end

	local memberName = unit.members[memberIdentifier]
	unit.members[memberIdentifier] = nil
	setCallsignForIdentifier(memberIdentifier, nil)
	notifyDept(dept.id, "^3" .. memberName .. "^0 Az Vahed ^2" .. unit.callsign .. "^0 Ekhraj Shod!")
end)
