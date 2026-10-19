--[[
	Owner renames: a holding's Boss can rename the holding, and any holding can
	rename a business it owns (e.g. "Cafe - Arshia"). Names are stored in
	CustomNames and synced to every client.
]]

-- entity_job -> custom label (nil = still using the default)
CustomNames = {}

function GetDisplayLabel(entityJob, defaultLabel)
	return CustomNames[entityJob] or defaultLabel
end

-- ─── Blips (client only) ─────────────────────────────────────────────────────
-- BusinessBlips[job] = { default = "Cafe", blips = { handle, handle, ... } }
BusinessBlips = {}

if not IsDuplicityVersion() then
	-- Call once for every blip created for a business.
	function TrackBusinessBlip(job, blip, defaultLabel)
		local entry = BusinessBlips[job]
		if not entry then
			entry = { default = defaultLabel, blips = {} }
			BusinessBlips[job] = entry
		end
		table.insert(entry.blips, blip)
	end

	local function applyName(blip, job, defaultLabel)
		if not DoesBlipExist(blip) then return end
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(GetDisplayLabel(job, defaultLabel))
		EndTextCommandSetBlipName(blip)
	end

	local function refreshJob(job)
		local entry = BusinessBlips[job]
		if not entry then return end
		for _, blip in ipairs(entry.blips) do applyName(blip, job, entry.default) end
	end

	RegisterNetEvent('uniquecafejobs:corp:syncCustomNames', function(names)
		for k, v in pairs(names or {}) do CustomNames[k] = v end
		for job in pairs(BusinessBlips) do refreshJob(job) end
	end)

	RegisterNetEvent('uniquecafejobs:corp:businessRenamed', function(job, newName)
		CustomNames[job] = newName
		refreshJob(job)
	end)

	CreateThread(function()
		Wait(3000)
		TriggerServerEvent('uniquecafejobs:corp:requestCustomNames')
	end)
end

-- ─── Menu helpers (client) ───────────────────────────────────────────────────
function MenuSection(title)
	return { label = '--- ' .. title .. ' ---', value = 'noop', disabled = true }
end
function MenuInfo(text)
	return { label = text, value = 'noop', disabled = true }
end
