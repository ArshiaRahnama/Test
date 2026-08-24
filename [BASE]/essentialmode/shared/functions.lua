local Charset = {}

for i = 48, 57 do
    table.insert(Charset, string.char(i))
end
for i = 65, 90 do
    table.insert(Charset, string.char(i))
end
for i = 97, 122 do
    table.insert(Charset, string.char(i))
end

local VehicleNames = json.decode(LoadResourceFile(GetCurrentResourceName(), 'shared/data/vehicle_names.json'))

ESX.GetRandomString = function(length)
    math.randomseed(GetGameTimer())

    if length > 0 then
        return ESX.GetRandomString(length - 1) .. Charset[math.random(1, #Charset)]
    else
        return ""
    end
end

ESX.GetConfig = function()
    return Config
end

ESX.FirstToUpper = function(str)
    return (str:gsub("^%l", string.upper))
end

ESX.GetWeaponList = function()
    return Config.Weapons
end

ESX.GetVehicleLabelFromName = function(data)
	local name = data:lower()
	if name and VehicleNames["names"][name] then
		return VehicleNames["names"][name]
	end

	return "Unknown"
end

ESX.GetVehicleLabelFromHash = function(data)
	local hash = tostring(data)
	if data and VehicleNames["hashes"][hash] then
		return VehicleNames["hashes"][hash]
	end

	return "Unknown"
end

ESX.GetWeaponLabel = function(weaponName)
    if not weaponName then
        return "no name"
    end
    weaponName = string.upper(weaponName)
    local weapons = ESX.GetWeaponList()

    for i = 1, #weapons, 1 do
        if string.upper(weapons[i].name) == weaponName then
            return weapons[i].label
        end
    end
end

ESX.GetWeaponName = function(hash)
	local weapons = ESX.GetWeaponList()

	for i=1, #weapons, 1 do
		if weapons[i].hash == hash then
			return weapons[i].name, weapons[i].label, weapons[i].components or {}
		end
	end

	return "no_name", "no name"
end

ESX.GetWeaponComponent = function(weaponName, weaponComponent)
    weaponName = string.upper(weaponName)
    local weapons = ESX.GetWeaponList()

    for i = 1, #weapons, 1 do
        if string.upper(weapons[i].name) == weaponName then
            for j = 1, #weapons[i].components, 1 do
                if weapons[i].components[j].name == weaponComponent then
                    return weapons[i].components[j]
                end
            end
        end
    end
end

ESX.TableContainsValue = function(table, value)
    for k, v in pairs(table) do
        if v == value then
            return true
        end
    end

    return false
end

ESX.dump = function(table, nb)
    if nb == nil then
        nb = 0
    end

    if type(table) == "table" then
        local s = ""
        for i = 1, nb + 1, 1 do
            s = s .. "    "
        end

        s = "{\n"
        for k, v in pairs(table) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            for i = 1, nb, 1 do
                s = s .. "    "
            end
            s = s .. "[" .. k .. "] = " .. ESX.dump(v, nb + 1) .. ",\n"
        end

        for i = 1, nb, 1 do
            s = s .. "    "
        end

        return s .. "}"
    else
        return tostring(table)
    end
end

ESX.Round = function(value, numDecimalPlaces)
    return ESX.Math.Round(value, numDecimalPlaces)
end

ESX.CopyTable = function(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else
        copy = orig
    end
    return copy
end

ESX.TableConcat = function(t1,t2)
    for i=1, #t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

ESX.TableClone = function(table)
	local tempTable = {}
	for k,v in pairs(table) do
	 	tempTable[k] = v
	end
	return tempTable
end

ESX.GetWeaponFromHash = function(weaponHash)
	for k,v in ipairs(Config.Weapons) do
		if GetHashKey(v.name) == weaponHash then
			return v
		end
	end
end

ESX.GetWeapon = function(weaponName)
	weaponName = string.upper(weaponName)

	for k,v in ipairs(Config.Weapons) do
		if v.name == weaponName then
			return k, v
		end
	end
end