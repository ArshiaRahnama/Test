Config = {}
Config.Locale = "en"

Config.Accounts = {"bank", "black_money"}
Config.AccountLabels = {bank = _U("bank"), black_money = _U("black_money")}
Config.TargetDistance = 4

Config.EnableSocietyPayouts = true
Config.ShowDotAbovePlayer = false
Config.DisableWantedLevel = true
Config.EnableHud = false

Config.PaycheckInterval = 15 * 60000
Config.MaxPlayers = GetConvarInt("sv_maxclients", 64)

Config.EnableDebug = false

Config.DefaultMaxWeight = 24000
