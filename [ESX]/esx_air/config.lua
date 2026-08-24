Config               = {}

Config.Locale = 'en'

Config.LicenseEnable = false
Config.LicensePrice  = 50000

Config.MarkerType    = 1
Config.DrawDistance  = 15.0

Config.Marker = {
	r = 100, g = 204, b = 100,
	x = 1.0, y = 1.0, z = 1.0
}

Config.StoreMarker = {
	r = 255, g = 0, b = 0,
	x = 5.0, y = 5.0, z = 1.0
}

Config.Zones = {

	Garages = {







	},

	AirShops = {
		{
			Outside = vector3(-51.4241, -1094.91, 27.274),
			Inside = vector4(-1405.34, -3212.34, 13.944, 235.17)
		}
	}

}

Config.Vehicles = {
	{model = 'nimbus', label = 'Nimbus', price = 100000000},
	{model = 'vestra', label = 'Vestra', price = 70000000},
	{model = 'dodo', label = 'Dodo', price = 50000000},
	{model = 'mammatus', label = 'Mammatus', price = 30000000},
	{model = 'microlight', label = 'Microlight', price = 10000000},
}