-- ============================================================
-- Robbery plan items (run once; safe to re-run).
-- Unique_AllRobs/config.lua -> Config.Rob.Plans uses these three items:
--   plan_bronze   : Minibank (FleeccE / Bank Saheli), Oil Rig      (3 needed)
--   plan_silver   : Jewelry (Jaw Shahr, Jaw BironShahr)            (2 needed)
--   plan_premium  : Insurance (Life Invader), Bank Pelato          (5 needed)
-- Gangs earn them from Territory captures (Unique_ALLGangs).
-- ============================================================
-- rob_token : handed to the robber when a plan robbery is WON. It has to be USED
--             (for the gang) within 30 minutes to count as a win, otherwise it
--             counts as a loss and stops working (Config.Heist.Token).
REPLACE INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`, `weight`) VALUES
	('plan_bronze',  'Plan Robbery Bronze',  -1, 0, 1, 0.100),
	('plan_silver',  'Plan Robbery Silver',  -1, 0, 1, 0.100),
	('plan_premium', 'Plan Robbery Premium', -1, 0, 1, 0.100),
	('rob_token',    'Robbery Token',        -1, 0, 1, 0.100);

-- The Gang Heist tables (gang_heist_stats / gang_heist_tokens / gang_heist_log) are
-- created automatically by Unique_AllRobs/heist_server.lua on first start.
