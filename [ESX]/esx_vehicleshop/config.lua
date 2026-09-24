Config                            = {}
Config.DrawDistance               = 100.0
Config.MarkerColor                = { r = 120, g = 120, b = 240 }
Config.EnablePlayerManagement     = false
Config.EnableOwnedVehicles        = true
Config.EnableSocietyOwnedVehicles = false
Config.ResellPercentage           = 50

Config.EnableJobLogs              = true
Config.Locale                     = 'en'

Config.LicenseEnable = false

Config.PlateLetters  = 1
Config.PlateNumbers  = 1
Config.PlateUseSpace = true

-- ---------------------------------------------------------------------------
-- Modern showroom UI (new)
-- ---------------------------------------------------------------------------
Config.UseModernShopUI = true -- false = fall back to the old text menu (OpenShopMenu)

Config.TestDrive = {
	Enable       = true,
	Duration     = 120,  -- seconds the player gets to drive before it's recalled
	MaxDistance  = 350.0, -- driving further than this from the showroom ends the test drive early
	EndKey       = 177,   -- INPUT_FRONTEND_DELETE ("Backspace") - manually end the test drive
}

Config.Financing = {
	Enable                 = true,
	MinDownPaymentPercent  = 20,  -- % of the (post trade-in) price required up front
	InterestPercent        = 12,  -- added on top of the remaining balance
	Installments           = 4,   -- number of installments the remaining balance is split into
	PaymentIntervalHours   = 24,  -- real-time hours between each installment charge
	MaxMissedPayments      = 3,   -- consecutive missed installments before repossession
	CheckIntervalMinutes   = 15,  -- how often the server checks for due installments
}

Config.TradeIn = {
	Enable        = true,
	PayoutPercent = 50, -- % of the traded-in vehicle's catalog price credited toward the new one
}

Config.Zones = {

	ShopEntering = {
		Pos   = { x = -46.8820, y = -1095.86, z = 27.274 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
	    Type  = 36
	},

	ShopInside = {
		Pos     = { x = -74.66, y = -819.92, z = 285.0 },
		Size    = { x = 1.5, y = 1.5, z = 1.5 },
		Heading = 157.8,
		Type    = -1
	},

	ShopOutside = {
		Pos     = { x = -64.73, y = -1072.01, z = 27.14 },
		Size    = { x = 1.5, y = 1.5, z = 1.5 },
		Heading = 330.0,
		Type    = -1
	},

	BossActions = {
		Pos   = { x = -32.065, y = -1114.277, z = 25.422 },
		Size  = { x = 1.5, y = 1.5, z = 1.0 },
		Type  = -1
	},

	GiveBackVehicle = {
		Pos   = { x = -18.227, y = -1078.558, z = 25.675 },
		Size  = { x = 3.0, y = 3.0, z = 1.0 },
		Type  = (Config.EnablePlayerManagement and 1 or -1)
	},

	ResellVehicle = {
		Pos   = { x = -44.630, y = -1080.738, z = 10.0 },
		Size  = { x = 3.0, y = 3.0, z = 1.0 },
		Type  = 1
	},

	ResellVehicle2 = {
		Pos   = { x = -44.41, y =-1081.67, z = 25.68 },
		Size  = { x = 3.0, y = 3.0, z = 1.0 },
		Type  = 1
	}

}
