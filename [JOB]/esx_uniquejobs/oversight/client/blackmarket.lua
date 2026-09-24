-- ============================================================
-- Job Watch (oversight) -- black market ("the fence") client side
-- Worker-facing: Config_oversight.BlackMarket.Command (default
-- /fence) opens a sell menu IF the fence happens to be open right
-- now -- there's no map marker or NPC to spot; it's a phone-call
-- style contact, deliberately with nothing to see until you try.
-- Admin-facing: a small read-only status screen for judge/marshal
-- from the Job Watch main menu (does not spoil anything for workers
-- since they never see this menu).
-- ============================================================

local Cfg = Config_oversight
local T = 'esx_uniquejobs:oversight:'

if Cfg.BlackMarket.Enabled and Cfg.BlackMarket.Command then
	RegisterCommand(Cfg.BlackMarket.Command, function()
		ESX.TriggerServerCallback(T .. 'blackmarketList', function(list)
			if not list then
				ESX.ShowNotification('~r~...Hich Kasi Javab Nemide')
				return
			end
			if #list == 0 then
				ESX.ShowNotification('~y~Chizi Baraye Forush Nadarid')
				return
			end

			local options = {}
			for _, it in ipairs(list) do
				options[#options + 1] = {
					title = it.label .. ' (' .. it.count .. ' Adad)',
					description = 'Forush Be Forushande-ye Siah -- Bedoon-e Maliat, Bedoon-e Rasid',
					icon = 'user-secret',
					onSelect = function()
						local input = lib.inputDialog(it.label, {
							{ type = 'number', label = 'Chand Adad?', default = math.min(it.count, Cfg.BlackMarket.MaxSellPerCall), min = 1, max = math.min(it.count, Cfg.BlackMarket.MaxSellPerCall), required = true },
						})
						if input then
							TriggerServerEvent(T .. 'blackmarketSell', it.name, input[1])
						end
					end,
				}
			end

			lib.registerContext({ id = 'ov_fence', title = 'Tamas-e Namashakhas', options = options })
			lib.showContext('ov_fence')
		end)
	end, false)
end

-- read-only admin screen: current open/closed state. Reachable from
-- the Job Watch main menu (client/menu.lua), gated there on the
-- 'flags' permission the same way the Flags list is.
function Ov.OpenBlackMarketInfo()
	ESX.TriggerServerCallback(T .. 'getBlackMarketStatus', function(status)
		if not status then return end
		local o = {
			{
				title = status.open and '~g~Bazar-e Siah: BAZ~s~' or '~r~Bazar-e Siah: BASTE~s~',
				description = status.open and 'Alan Mitavanand Forush Konand (Bedoon-e Ettela-e Khodkar Be Karegaran)' or 'Alan Kasi Javab Nemide',
				icon = status.open and 'unlock' or 'lock', disabled = true,
			},
			{
				title = 'Farmande-ye Karegar', description = 'Dastoor: /' .. Cfg.BlackMarket.Command,
				icon = 'phone', disabled = true,
			},
		}
		Ov.ShowMenu('ov_blackmarket', 'Bazar-e Siah (Etela\'at)', 'ov_main', o)
	end)
end
