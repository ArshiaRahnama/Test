

Config = {}

Config.UseRPName = true

Config.LetPlayersChangeVisibilityOfRadioList = true
Config.RadioListVisibilityCommand = "radiolist"

Config.LetPlayersSetTheirOwnNameInRadio = true
Config.ResetPlayersCustomizedNameOnExit = true
Config.RadioListChangeNameCommand = "nameinradio"

Config.RadioChannelsWithName = {
	["0"]   = "Admin",
	["1"]   = "Police",
	["2"]   = "Sheriff",
	["3"]   = "Fbi",
	["4"]   = "Dadgostari",
	["5"]   = "Ambulance",
	["29"]  = "Mechanic",
	["30"]  = "Artesh",
	["36"]  = "Taxi",
	["911"] = "Shared",
	["40"]  = "World (Public)",
	["41"]  = "World (Streamer)",
}

radioConfig = {
	Controls = {
		Activator = { Name = "INPUT_CELLPHONE_CANCEL", Key = 177 },
		Secondary = { Name = "INPUT_SPRINT", Key = 21, Enabled = false },
		Toggle    = { Name = "INPUT_CONTEXT", Key = 51 },
		Increase  = { Name = "INPUT_CELLPHONE_RIGHT", Key = 175, Pressed = false },
		Decrease  = { Name = "INPUT_CELLPHONE_LEFT", Key = 174, Pressed = false },
		Input     = { Name = "INPUT_FRONTEND_ACCEPT", Key = 201, Pressed = false },
		Broadcast = { Name = "INPUT_INTERACTION_MENU", Key = 244 },
		ToggleClicks = { Name = "INPUT_SELECT_WEAPON", Key = 37 },
	},
	Frequency = {
		Private = {
			[1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true,
			[8] = true, [9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [14] = true,
			[15] = true, [16] = true, [17] = true, [18] = true, [19] = true, [20] = true,
		},
		Current = 1,
		CurrentIndex = 1,
		Min = 1,
		Max = 1000,
		List = {},
		Access = {},
	},
	AllowRadioWhenClosed = true,
}

SI = {
	PrivateFrequency = {
		["police"]     = { 1, 901, 900, 911 },
		["sheriff"]    = { 2, 902, 900, 911 },
		["fbi"]        = { 3, 904, 900, 911 },
		["dadgostari"] = { 4, 912, 900, 911 },
		["ambulance"]  = { 5, 905, 911 },
		["mechanic"]   = { 29, 906 },
		["taxi"]       = { 36, 907 },
		["artesh"]     = { 30, 911 },


		["mt"]     = { 903, 900 },
		["cid"]    = { 909, 900 },
		["cia"]    = { 910, 900 },
		["marshal"] = { 911, 900 },
		["judge"]  = { 912, 900 },
		["doa"]    = { 913, 900 },
		["weazel"] = { 908 },
	}
}

for _, frequencies in pairs(SI.PrivateFrequency) do
	for _, frequency in pairs(frequencies) do
		radioConfig.Frequency.Private[frequency] = true
	end
end
