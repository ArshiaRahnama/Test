-- ============================================================
-- Job Watch (oversight) -- client main
-- /jobwatch command, rendering the live blips a judge/marshal can
-- turn on, and the toast + sound that fires when a flag comes in.
-- ============================================================

local Cfg = Config_oversight
local T = 'esx_uniquejobs:oversight:'

local function clean_(name) return (tostring(name or '?'):gsub('_', ' ')) end

RegisterCommand('jobwatch', function()
	Ov.OpenMainMenu()
end, false)
RegisterKeyMapping('jobwatch', 'Baz Kardan-e Job Watch (Ghazi/Marshal)', 'keyboard', '')

-- ---- flag popups for judge/marshal ----
Ov.LastAlert = nil

local function toast(title, desc, icon, colour)
	lib.notify({ title = title, description = desc, icon = icon, iconColor = colour, position = 'top', duration = 8000 })
	PlaySoundFrontend(-1, 'Menu_Accept', 'Phone_SoundSet_Default', true)
end

RegisterNetEvent('esx_uniquejobs:oversight:alert')
AddEventHandler('esx_uniquejobs:oversight:alert', function(data)
	Ov.LastAlert = data
	toast(data.label, (data.jobLabel or data.job) .. ' -- ' .. clean_(data.name) .. ': ' .. tostring(data.detail), 'triangle-exclamation', 'orange')
end)


-- ---- live worker blips (toggled from the menu) ----
local blips = {}

RegisterNetEvent('esx_uniquejobs:oversight:blipData')
AddEventHandler('esx_uniquejobs:oversight:blipData', function(list)
	local seen = {}
	for _, w in ipairs(list or {}) do
		seen[w.id] = true
		local b = blips[w.id]
		if not b then
			b = AddBlipForCoord(w.x, w.y, w.z)
			SetBlipSprite(b, 1)
			SetBlipAsShortRange(b, true)
			blips[w.id] = b
		else
			SetBlipCoords(b, w.x, w.y, w.z)
		end
		SetBlipScale(b, 0.75)
		SetBlipColour(b, w.colour or 0)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName(clean_(w.name) .. ' -- ' .. tostring(w.job) .. ' (' .. tostring(w.state) .. ')')
		EndTextCommandSetBlipName(b)
	end
	for id, b in pairs(blips) do
		if not seen[id] then
			if DoesBlipExist(b) then RemoveBlip(b) end
			blips[id] = nil
		end
	end
end)

AddEventHandler('onClientResourceStop', function(res)
	if res ~= GetCurrentResourceName() then return end
	for _, b in pairs(blips) do
		if DoesBlipExist(b) then RemoveBlip(b) end
	end
end)
