--[[
	VMS businesses (barber shops + tattoo shops) registered into the holding system.

	All barber shops share ONE job ("barber") and ONE society ("society_barber").
	All tattoo shops share ONE job ("tattoo") and ONE society ("society_tattoo").
	Each type belongs to one holding (VmsHoldingOf below).

	Staff are given the job by the holding ("Manage Business Staff") and can then
	use every shop of that type.
]]

VmsHoldingOf = {
	barber = 'meridian', -- Gang 1
	tattoo = 'turfco',   -- Gang 2
}

local function plainPos(p)
	if not p then return nil end
	return { x = p.x, y = p.y, z = p.z }
end

VmsBusinesses = {}

-- One entry per type. The boss-action / freezer markers use the first shop of that type.
if Config_vmsbarber and Config_vmsbarber.Barbers then
	local first
	for _, b in pairs(Config_vmsbarber.Barbers) do
		if b.ownerJob and b.ownerJob ~= '' then first = b; break end
	end
	if first then
		local pos  = plainPos(first.position)
		local boss = plainPos(first.bossMenu and first.bossMenu.coords) or pos
		table.insert(VmsBusinesses, {
			Type = 'barber', MenuGroup = 'vms_barber', External = true,
			Job = 'barber', Society = 'barber', Label = 'Barber Shop',
			Holding = VmsHoldingOf.barber,
			Freezer = { Pos = pos, Name = 'Freezer', Icon = '' },
			PedShop = { Pos = pos, Name = 'Shop', Icon = '' },
			BossAction = { Pos = boss, Name = 'Boss Actions', Icon = 'fa-solid fa-gear' },
		})
	end
end

if Config_vmstattoo and Config_vmstattoo.Tattooshops and #Config_vmstattoo.Tattooshops > 0 then
	local pos = plainPos(Config_vmstattoo.Tattooshops[1].position)
	table.insert(VmsBusinesses, {
		Type = 'tattoo', MenuGroup = 'vms_tattoo', External = true,
		Job = 'tattoo', Society = 'tattoo', Label = 'Tattoo Shop',
		Holding = VmsHoldingOf.tattoo,
		Freezer = { Pos = pos, Name = 'Freezer', Icon = '' },
		PedShop = { Pos = pos, Name = 'Shop', Icon = '' },
		BossAction = { Pos = pos, Name = 'Boss Actions', Icon = 'fa-solid fa-gear' },
	})
end

-- Every business the holding system knows about: cafes + vms shops.
function AllBusinesses()
	local list = {}
	for _, c in pairs(Cafes) do table.insert(list, c) end
	for _, c in ipairs(VmsBusinesses) do table.insert(list, c) end
	return list
end

-- ─── Payment split and blip names ────────────────────────────────────────────
VmsConfig = {
	HoldingSharePercent = 40,
}

-- "Barber Shop - Gang 1"  /  "Tattoo Shop - Gang 2"  (owner rename wins, see customnames.lua)
function VmsDisplayName(job)
	local kind = tostring(job):match('^(%a+)')
	local shop = (kind == 'barber') and 'Barber Shop' or 'Tattoo Shop'

	local holding = (rawget(_G, 'HoldingOverrides') and HoldingOverrides[job])
	if not holding then
		local biz = GetBusinessForJob(job)
		holding = biz and biz.Holding
	end
	local hc = holding and GetHoldingConfig(holding)
	return shop .. ' - ' .. ((hc and hc.Label) or holding or 'No Holding')
end
