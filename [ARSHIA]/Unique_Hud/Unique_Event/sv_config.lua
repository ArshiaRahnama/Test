--[[
    Unique_Event - SERVER-ONLY configuration.
    Loaded on the server only, so secrets (webhook URLs, payouts) never reach clients.
]]

SvConfig = {}

-- ============================================================
-- Discord logging (categories fall back to Default when left as '')
-- Categories used by the code: Capture, GunGame, WarZone, Admin
-- ============================================================
SvConfig.LogEnabled = true
SvConfig.LogUsername = 'Unique Event'
SvConfig.LogAvatarUrl = ''
SvConfig.Webhooks = {
    Default = '',
    Capture = '',
    GunGame = '',
    WarZone = '',
    Admin   = '',
}

-- ============================================================
-- Payouts (server side only, so clients can never tamper with them)
-- ============================================================
SvConfig.Rewards = {
    WarZoneWinPerPlayer = 5000,
    WarZoneKillCash     = 500,
    GunGameWin          = 0,     -- 0 = no cash reward, bragging rights only
    CaptureSeasonWinner = 0,     -- 0 = manual prizes, like the original resource
}
