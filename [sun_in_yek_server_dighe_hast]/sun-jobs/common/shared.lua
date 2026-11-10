-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Shared = {
    drawDistance = 50.0,
    markers = {
        bossAction = {
            type = 42,
            color = {0, 255, 0, 100},
            size = {0.5, 0.5, 0.5},
            upDown = true,
            range = 1.0,
            label = '~INPUT_CONTEXT~ Boss Action',
        },
        cloakroom = {
            type = 21,
            color = {0, 255, 0, 100},
            size = {0.5, 0.5, 0.5},
            upDown = true,
            range = 1.0,
            label = '~INPUT_CONTEXT~ Komod lebas',
        },
        locker = {
            type = 40,
            color = {0, 255, 0, 100},
            size = {0.5, 0.5, 0.5},
            upDown = true,
            range = 1.0,
            label = '~INPUT_CONTEXT~ Anbar',
        },
        vehicles = {
            type = 36,
            color = {0, 255, 0, 100},
            size = {0.5, 0.5, 0.5},
            upDown = true,
            range = 1.0,
            label = '~INPUT_CONTEXT~ Garage Mashin',
        },
        helicopters = {
            type = 34,
            color = {0, 255, 0, 100},
            size = {0.5, 0.5, 0.5},
            upDown = true,
            range = 1.0,
            label = '~INPUT_CONTEXT~ Garage Helicopter',
        },
        vehicleDeleter = {
            type = 24,
            color = {0, 255, 0, 100},
            size = {0.5, 0.5, 0.5},
            upDown = true,
            range = 3.0,
            label = '~INPUT_CONTEXT~ Park Kardan',
        },
        startTaxiJob = {
            type = 21,
            color = {0, 255, 0, 100},
            size = {0.5, 0.5, 0.5},
            upDown = true,
            range = 1.0,
            label = '~INPUT_CONTEXT~ Shoroe mosafer keshi',
        },
        stopTaxiJob = {
            type = 21,
            color = {0, 255, 0, 100},
            size = {0.5, 0.5, 0.5},
            upDown = true,
            range = 1.0,
            label = '~INPUT_CONTEXT~ Payan mosafer keshi',
        },
    },
}
Locales = {}

local function _(locale, key, ...)
    -- Check locale actaully exist
    local thisLocale = Locales[locale]
    if not thisLocale then return print(('Locale %s does not exist'):format(locale)) end

    -- Check key does exist in target locale
    local localeText = thisLocale[key]
    if not localeText then return ('LocaleText [%s][%s] does not exist'):format(locale, key) end

    return string.format(localeText, ...)
end

function _U(locale, key, ...)
	return tostring(_(locale, key, ...):gsub("^%l", string.upper))
end

function generateRandomVehiclePlate(length)
	local upperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	local lowerCase = "abcdefghijklmnopqrstuvwxyz"
	local numbers = "0123456789"

	local characterSet = upperCase .. lowerCase .. numbers
	local output = ""

	for	i = 1, length do
		math.randomseed(GetGameTimer() + i)
		local rand = math.random(#characterSet)
		output = output .. string.sub(characterSet, rand, rand)
	end

	return output
end

function CountTable(object)
    local count = 0
    for k,v in pairs(object) do
        count = count + 1
    end

    return count
end

function disableAction()
    DisableControlAction(0, Keys['F1'],true)
    DisableControlAction(0, Keys['F2'],true)
    DisableControlAction(0, Keys['F3'],true)
    DisableControlAction(0, Keys['F5'],true)
    DisableControlAction(0, Keys['F6'],true)
    DisableControlAction(0, Keys['R'], true)
    DisableControlAction(0, Keys['W'],true)
    DisableControlAction(0, Keys['S'],true)
    DisableControlAction(0, Keys['A'],true)
    DisableControlAction(0, Keys['D'], true)
    DisableControlAction(0, Keys['SPACE'], true)
    DisableControlAction(0, Keys['TAB'], true)
    DisableControlAction(0, Keys['X'], true)
    DisableControlAction(0, Keys['M'], true)
    DisableControlAction(0, Keys['F'], true)
    DisableControlAction(0, 24, true) -- Attack
    DisableControlAction(0, 257, true) -- Attack 2
    DisableControlAction(0, 25, true) -- Right click
    DisableControlAction(0, 264, true) -- Disable melee
    DisableControlAction(0, 257, true) -- Disable melee
    DisableControlAction(0, 140, true) -- Disable melee
    DisableControlAction(0, 141, true) -- Disable melee
    DisableControlAction(0, 142, true) -- Disable melee
    DisableControlAction(0, 143, true) -- Disable melee
    DisableControlAction(0, 263, true) -- Melee Attack 1
    DisableControlAction(0, 27, true) -- Arrow up
    DisableControlAction(0, 30,  true) -- MoveLeftRight
    DisableControlAction(0, 31,  true) -- MoveUpDown
end