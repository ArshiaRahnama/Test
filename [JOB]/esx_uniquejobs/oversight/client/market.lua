-- ============================================================
-- Job Watch (oversight) -- live market ticker (read-only screen)
-- Shows the judge/marshal how the automatic market is moving on
-- top of their own manual tax/multiplier -- see server/market.lua.
-- ============================================================

local T = 'esx_uniquejobs:oversight:'

local function trendIcon(trend)
	if trend > 0.02 then return 'arrow-trend-up', 'green' end
	if trend < -0.02 then return 'arrow-trend-down', 'red' end
	return 'minus', nil
end

function Ov.OpenMarket()
	ESX.TriggerServerCallback(T .. 'getMarket', function(m)
		if not m then return end
		local o = {}
		o[#o + 1] = {
			title = 'Bazar-e Zende',
			description = 'Panjere-ye ' .. m.windowMinutes .. ' Daghighe-i -- Har Che Bishtar Foroukhte Beshe, Gheymat Kamtar Mishe',
			icon = 'chart-line', disabled = true,
		}
		for _, j in ipairs(m.jobs) do
			local icon, colour = trendIcon(j.trend)
			local desc = 'Zarib-e Bazar: x' .. string.format('%.2f', j.mult) .. ' | Hajm-e Foroush (' .. m.windowMinutes .. 'd): ' .. j.volume
			if j.suppliers then
				desc = desc .. ' | Vabaste Be: ' .. table.concat(j.suppliers, ', ')
			end
			o[#o + 1] = {
				title = j.label, description = desc, icon = icon, iconColor = colour, disabled = true,
			}
		end
		Ov.ShowMenu('ov_market', 'Bazar-e Zende', 'ov_main', o)
	end)
end
