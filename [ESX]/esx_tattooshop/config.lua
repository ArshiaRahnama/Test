Config = {}

Config.TattooCats = {
	{"ZONE_HEAD", "Head", {vec(0.0, 0.7, 0.7), vec(0.7, 0.0, 0.7), vec(0.0, -0.7, 0.7), vec(-0.7, 0.0, 0.7)}, vec(0.0, 0.0, 0.5)},
	{"ZONE_LEFT_LEG", "Left Leg", {vec(-0.2, 0.7, -0.7), vec(-0.7, 0.0, -0.7), vec(-0.2, -0.7, -0.7)}, vec(-0.2, 0.0, -0.6)},
	{"ZONE_LEFT_ARM", "Left Arm", {vec(-0.4, 0.5, 0.2), vec(-0.7, 0.0, 0.2), vec(-0.4, -0.5, 0.2)}, vec(-0.2, 0.0, 0.2)},
	{"ZONE_RIGHT_LEG", "Right Leg", {vec(0.2, 0.7, -0.7), vec(0.7, 0.0, -0.7), vec(0.2, -0.7, -0.7)}, vec(0.2, 0.0, -0.6)},
	{"ZONE_TORSO", "Torso", {vec(0.0, 0.7, 0.2), vec(0.0, -0.7, 0.2)}, vec(0.0, 0.0, 0.2)},
	{"ZONE_RIGHT_ARM", "Right Arm", {vec(0.4, 0.5, 0.2), vec(0.7, 0.0, 0.2), vec(0.4, -0.5, 0.2)}, vec(0.2, 0.0, 0.2)},
}

Config.Shops = {
	vec(1322.6, -1651.9, 51.2),
	vec(-1153.6, -1425.6, 4.0),
	vec(322.1, 180.4, 102.7),
	vec(1864.6, 3747.7, 32.0),
	vec(-293.7, 6200.0, 30.5)
}

Config.interiorIds = {}
for k, v in ipairs(Config.Shops) do
    Config.interiorIds[#Config.interiorIds + 1] = GetInteriorAtCoords(v)
end

-- Marker settings (matches the Sun Tattoo Shop look)
Config.DrawDistance = 5.0
Config.MarkerSize   = { x = 0.75, y = 0.75, z = 0.75 }
Config.MarkerColor  = { r = 0, g = 128, b = 255 }
Config.MarkerType   = 1