-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local Charset = {}
if IsDuplicityVersion() then
	math.randomseed(os.time())
end

for i = 48,  57 do table.insert(Charset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

local VehicleNames = json.decode(LoadResourceFile(GetCurrentResourceName(), 'shared/data/vehicle_names.json'))
CreateThread(function()
	for k, v in pairs(VehicleNames["names"]) do
		VehicleNames["hashes"][tostring(GetHashKey(k))] = v
	end
end)

ESX.VehicleLabels = ESX.VehicleLabels or { names = {}, hashes = {} }

ESX.GetVehicleLabelFromName = function(data)
	local name = data:lower()
	local uk = not IsDuplicityVersion() and (GetDisplayNameFromVehicleModel(GetHashKey(name)) or 'Unknown') or 'Unknown'
	if name and (VehicleNames["names"][name] or VehicleNames["names"][name:lower()]) then
		return VehicleNames["names"][name] or VehicleNames["names"][name:lower()] or uk
	elseif VehicleNames["hashes"][GetHashKey(name)] then
		return VehicleNames["hashes"][GetHashKey(name)] or uk
	end

	if ESX.VehicleLabels.names[name] then
		return ESX.VehicleLabels.names[name]
	elseif ESX.VehicleLabels.hashes[tostring(GetHashKey(name))] then
		return ESX.VehicleLabels.hashes[tostring(GetHashKey(name))]
	end

	return uk
end

ESX.GetVehicleLabelFromHash = function(data)
	local hash = tostring(data)
	local uk = not IsDuplicityVersion() and (GetDisplayNameFromVehicleModel(hash) or 'Unknown') or 'Unknown'
	if data and VehicleNames["hashes"][hash] then
		return VehicleNames["hashes"][hash]
	end

	if ESX.VehicleLabels.hashes[hash] then
		return ESX.VehicleLabels.hashes[hash]
	end

	return uk
end

if IsDuplicityVersion() then
	-- SERVER: label-haye mashin ro az site_items (type = 1) bekhoon
	MySQL.ready(function()
		local rows = MySQL.Sync.fetchAll('SELECT `name`, `label` FROM `site_items` WHERE `type` = 1', {})
		for _, row in ipairs(rows or {}) do
			if row.name and row.label and row.label ~= '' then
				local n = tostring(row.name):lower()
				ESX.VehicleLabels.names[n] = row.label
				ESX.VehicleLabels.hashes[tostring(GetHashKey(n))] = row.label
			end
		end
	end)

	-- vaghti player join mishe faghat name->label ro barash befrest (data nesf mishe)
	AddEventHandler('esx:playerLoaded', function(playerId)
		TriggerClientEvent('esx:syncVehicleLabels', playerId, ESX.VehicleLabels.names)
	end)
else
	-- CLIENT: faghat name->label miad, hash ro inja mohasebe mikonim
	RegisterNetEvent('esx:syncVehicleLabels', function(names)
		if not names then return end
		local hashes = {}
		for n, label in pairs(names) do
			hashes[tostring(GetHashKey(n))] = label
		end
		ESX.VehicleLabels = { names = names, hashes = hashes }
	end)
end

ESX.GetRandomString = function(length)
	if length > 0 then
		return ESX.GetRandomString(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

if IsDuplicityVersion() then
	ESX.GetRandomSerial = function(pas)
		local serial = (pas or 'UK') .. '-' .. math.random(1000000, 99999999)
		repeat
			serial = (pas or 'UK') .. '-' .. math.random(1000000, 99999999)
		until not exports['sun-inventory-hud']:getWeaponBySerial(serial)
		return serial
	end
end

ESX.GetConfig = function()
	return Config
end

ESX.GetWeaponList = function()
	return Config.Weapons
end


ESX.GetWeaponFromHash = function(weaponHash)
	return Config.weapons3[weaponHash]
end

ESX.GetWeaponLabel = function(weaponName)
	weaponName = string.upper(weaponName)

	for k,v in ipairs(Config.Weapons) do
		if v.name == weaponName then
			return v.label
		end
	end

	return nil
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

ESX.GetWeaponName2 = function(hash)
	return Config.weapons3[hash] and Config.weapons3[hash].name
end

ESX.GetWeaponComponent = function(weaponName, weaponComponent)
	weaponName = string.upper(weaponName)
	local weapons = Config.Weapons

	for k,v in ipairs(Config.Weapons) do
		if v.name == weaponName then
			for k2,v2 in ipairs(v.components) do
				if v2.name == weaponComponent then
					return v2
				end
			end
		end
	end
end

ESX.GetWeapon = function(weaponName)
	return Config.weapons2[weaponName] or Config.weapons2[weaponName:upper()]
	-- weaponName = string.upper(weaponName)

	-- for k,v in ipairs(Config.Weapons) do
	-- 	if v.name == weaponName then
	-- 		return k, v
	-- 	end
	-- end
end

ESX.DumpTable = function(table, nb)
	if nb == nil then
		nb = 0
	end

	if type(table) == 'table' then
		local s = ''
		for i = 1, nb + 1, 1 do
			s = s .. "    "
		end

		s = '{\n'
		for k,v in pairs(table) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			for i = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '['..k..'] = ' .. ESX.DumpTable(v, nb + 1) .. ',\n'
		end

		for i = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
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

	if type(table) == 'table' then
		local s = ''
		for i = 1, nb + 1, 1 do
			s = s .. "    "
		end

		s = '{\n'
		for k,v in pairs(table) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			for i = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '['..k..'] = ' .. ESX.dump(v, nb + 1) .. ',\n'
		end

		for i = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
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
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

ESX.CopyTable2 = function(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            if type(orig_value) == 'function' then
                copy[orig_key] = orig_value
            else
                copy[orig_key] = ESX.CopyTable(orig_value)
            end
        end
    else
        copy = orig
    end
    return copy
end

ESX.TableLength = function(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end
ESX.tableLength = ESX.TableLength

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

ESX.GetDistance = function(vec1,vec2)
	if vec1 and vec2 then
		return #(vec1 - vec2)
	end
end

ESX.toBool = function(number)
	return tonumber(number) ~= 0
end

ESX.splitString = function(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

ESX.zGround = function(pos)
	return vector3(pos.x,pos.y,pos.z - 1)
end

function ESX.tableFind(tbl,value)
	for k,v in pairs(tbl) do
		if v == value then
			return k
		end
	end
	return false
end

function ESX.getWeaponWeight(name, trunk)
	local weight = 0
	if name then
		name = name:upper()
		if Config.weapons2[name] then
			local weapon = Config.weapons2[name]
			weight = trunk and (weapon.weightTrunk or weapon.weight or 0) or (weapon.weight or 0)
		end
	end
	return weight
end

function ESX.getItemType(name)
	local itemType = 'item_standard'
    if name then
        if name:lower():find('weapon_') or name:lower():find('gadget_') then
            itemType = 'item_weapon'
        end
    else
        name = nil
    end
    return itemType
end

function ESX.getItemWeight(name, trunk)
    local weight = 0
    local type = ESX.getItemType(name)
    if type then
        if type == 'item_standard' then
            local item = ESX.getItem(name)
            if item then
                weight = trunk and (item.weightTrunk or item.weight or 0) or (item.weight or 0)
            end
        else
            weight = ESX.getWeaponWeight(name, trunk)
        end
    end
    return weight
end

function ESX.getItemLabel(name)
    local label = ''
    local type = ESX.getItemType(name)
    if type then
        if type == 'item_standard' then
            local item = ESX.getItem(name)
            if item then
                label = item.label
            end
        else
            label = ESX.GetWeaponLabel(name)
        end
    end
    return label
end

function ESX.getItemImage(name)
    return ('nui://sun-inventory-hud/ui/img/items/%s.png'):format(name)
end

function ESX.doesItemExist(name)
	if ESX.getItem(name) or ESX.GetWeaponLabel(name) or name:find('kif_') or name:find('pack_') then
		return true
	end
end

function ESX.tableRemove(tbl, value)
	for k = 1, #tbl do
		if tbl[k] == value then
			tbl[k] = nil
		end
	end
	local reIndex = {}
	local i = 1
	for k, v in pairs(tbl) do
		reIndex[i] = v
		i = i + 1
	end
	return reIndex
end

function ESX.tableRemove2(tbl, cb)
	for k = 1, #tbl do
		if cb(tbl[k]) then
			tbl[k] = nil
		end
	end
	local reIndex = {}
	local i = 1
	for k, v in pairs(tbl) do
		reIndex[i] = v
		i = i + 1
	end
	return reIndex
end


function ESX.replace(str, first, second)
	local str, str2 = str:gsub(first, second)
	return str
end

function ESX.firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function ESX.tableMerge(tbl1, tbl2, index)
	for k, v in pairs(tbl2) do
		if index then
			tbl1[k] = v
		else
			table.insert(tbl1, v)
		end
	end
	return tbl1
end

function ESX.pairsByKeys(t, f)
    local a = {}
    for n in pairs(t) do
        table.insert(a, n)
    end
    table.sort(a, f)
    local i = 0
    local iter = function ()
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end

function ESX.chance(chance, max)
	if math.random(1, max or 100) <= chance then
		return true
	end
	return false
end

function ESX.displayTime(time)
	local temprestante = (((time)/60)/60)/24
	floord = math.floor(temprestante)
	floorh = math.floor((temprestante-floord)*24)
	floorm = math.floor(((temprestante-floord)*24-floorh)*60)
	text = string.format("%sD : %sH : %sM",floord,floorh,floorm)
	return text
end

function ESX.displayTimeS(time)
	--30000
	local temprestante = (((time)/60)/60)/24
	floord = math.floor(temprestante)
	floorh = math.floor((temprestante-floord)*24)
	floorm = math.floor(((temprestante-floord)*24-floorh)*60)
	floors = math.floor((((temprestante - floord) * 24 - floorh) * 60 - floorm) * 60)
	text = string.format("%sH : %sM : %sS",floorh,floorm,floors)
	return text
end


function ESX.displayTS(ts)
	return os.date("%Y/%m/%d - %H:%M", ts)
end

function ESX.hasSpecialCharacters(str)
    return string.match(str, "[^%w_]") ~= nil
end

function ESX.repeatCode(cb, count, timeout)
	CreateThread(function()
		local i = 1
		repeat
			Wait(timeout)
			cb()
			i += 1
		until i > count
	end)
end

ESX.doesBlockedItem = function(name)
    return ESX.blockedItems[name] or ESX.blockedItems[name:lower()]
end

ESX.doesBlockedItemJob = function(name, jobName)
    local config = ESX.blockedItemsJob[name] or ESX.blockedItemsJob[name:lower()]
    return config and ESX.TableContainsValue(config, jobName:gsub('off', ''))
end

ESX.doesBlockedItemButCanGive = function(name)
    return ESX.blockedItemButCanGive[name] or ESX.blockedItemButCanGive[name:lower()]
end

ESX.addBlockedItem = function(name)
    ESX.blockedItems[name:lower()] = true
end

ESX.addBlockedButCanGiveItem = function(name)
    ESX.blockedItemButCanGive[name:lower()] = true
end

function ESX.isValidURL(url)
    local pattern = "^https?://[%w-_%.%?%.:/%+=&]+$"
    if type(url) == "string" and string.match(url, pattern) then
        return true
    else
        return false
    end
end

function ESX.timeAgo(timestamp)
    local current_time = IsDuplicityVersion() and os.time() or exports['sunset_utils']:GetServerOSTime()
    local diff = current_time - timestamp

    if diff < 0 then
        return "Timestamp is in the future!"
    end

    local seconds_in_minute = 60
    local seconds_in_hour = 60 * seconds_in_minute
    local seconds_in_day = 24 * seconds_in_hour

    if diff >= seconds_in_day then
        local days = math.floor(diff / seconds_in_day)
        return days .. " day(s) ago"
    elseif diff >= seconds_in_hour then
        local hours = math.floor(diff / seconds_in_hour)
        return hours .. " hour(s) ago"
    elseif diff >= seconds_in_minute then
        local minutes = math.floor(diff / seconds_in_minute)
        return minutes .. " minute(s) ago"
    else
        return diff .. " second(s) ago"
    end
end

function ESX.generateRandomNumber(digits)
    if digits < 1 then
        return nil
    end

    local min = 10^(digits - 1)
    local max = (10^digits) - 1

    return math.random(min, max)
end

local function isJSON(str)
    local success, result = pcall(function() return json.decode(str) end)
    return success and type(result) == "table"
end

local function sanitizeValue(value)
    local replacements = {
        ["<"] = "&lt;", [">"] = "&gt;", ['"'] = "&quot;",
        ["'"] = "&#x27;", ["%%("] = "&#40;", ["%%)"] = "&#41;",
        [";"] = "&#59;", [":"] = "&#58;", ["&"] = "&amp;",
        ["#"] = "&#35;", ["%%"] = "&#37;", ["/"] = "&#47;",
        ["\\"] = "&#92;", ["`"] = "&#96;", ["="] = "&#61;",
        [" "] = "&#32;", ["\n"] = "&#10;", ["\r"] = "&#13;",
        ["\t"] = "&#9;", ["\b"] = "&#8;", ["\f"] = "&#12;"
    }

    -- Replacing unsafe tags and attributes
    value = value:gsub("<script[^>]*>.*</script>", "")
    value = value:gsub("<iframe[^>]*>.*</iframe>", "")

    value = value:gsub("<(?!/?(html|head|body|p|br|div|span|a|ul|li|ol|table|tr|td|th|h1|h2|h3|h4|h5|h6|img|em|strong|b|i|u|hr)[^>]*>)", "&lt;%1&gt;")
    
    value = value:gsub("on[%w_]+=[\"'][^\"']+[\"']", "")
    value = value:gsub("javascript:[^\"'>]*", "")

    -- Encode characters
    for unsafe, safe in pairs(replacements) do
        value = string.gsub(value, unsafe, safe)
    end

    return value
end


local function sanitizeJSON(data)
    if type(data) == "table" then
        for key, value in pairs(data) do
            if type(value) == "string" then
                data[key] = sanitizeValue(value)
            elseif type(value) == "table" then
                sanitizeJSON(value)
            end
        end
    end
end

function ESX.sanitizeXSS(input)
    if type(input) == "table" then
        sanitizeJSON(input)
        return input
    elseif isJSON(input) then
        local jsonData = json.decode(input)
        sanitizeJSON(jsonData)
        return json.encode(jsonData)
    else
        return sanitizeValue(input)
    end
end


local patterns = {
    "<script", "</script>", "javascript:", "vbscript:", "mocha:", "livescript:",
    "expression%(", "eval%(", "alert%(", "prompt%(", "confirm%(", 
    "document%.cookie", "document%.write", "window%.location", "window%.name",
    "setTimeout%(", "setInterval%(", "import%(", "fetch%(", "XMLHttpRequest",
    "localStorage", "sessionStorage", "atob%(", "btoa%(", "crypto", "history%.",
    "window%.", "self%.", "top%.", "parent%.",

    "onabort", "onafterprint", "onanimationend", "onanimationiteration", "onanimationstart",
    "onbeforeprint", "onbeforeunload", "onblur", "oncancel", "oncanplay", "oncanplaythrough",
    "onchange", "onclick", "onclose", "oncontextmenu", "oncopy", "oncuechange", "oncut",
    "ondblclick", "ondrag", "ondragend", "ondragenter", "ondragexit", "ondragleave", 
    "ondragover", "ondragstart", "ondrop", "ondurationchange", "onemptied", "onended",
    "onerror", "onfocus", "onformdata", "onhashchange", "oninput", "oninvalid", "onkeydown",
    "onkeypress", "onkeyup", "onlanguagechange", "onload", "onloadeddata", "onloadedmetadata",
    "onloadstart", "onmessage", "onmessageerror", "onmousedown", "onmouseenter", "onmouseleave",
    "onmousemove", "onmouseout", "onmouseover", "onmouseup", "onoffline", "ononline", 
    "onpagehide", "onpageshow", "onpaste", "onpause", "onplay", "onplaying", "onpopstate",
    "onprogress", "onratechange", "onrejectionhandled", "onreset", "onresize", "onscroll",
    "onsearch", "onseeked", "onseeking", "onselect", "onshow", "onstalled", "onstorage",
    "onsubmit", "onsuspend", "ontimeupdate", "ontoggle", "ontransitionend", "onunhandledrejection",
    "onunload", "onvolumechange", "onwaiting", "onwheel", 

    "background=", "background-image=", "background-url=", "border-image=", 
    "behavior:", "-moz-binding", "filter:", "transition:", "transform:", "animation:", 
    "-webkit-animation:", "-moz-animation:", "-o-animation:", "clip-path:", "-webkit-clip-path:",

    "<!doctype", "<a", "<abbr", "<address", "<area", "<article", "<aside", "<audio",
    "<b", "<base", "<bdi", "<bdo", "<blockquote", "<body", "<br", "<button", "<canvas",
    "<caption", "<cite", "<code", "<col", "<colgroup", "<data", "<datalist", "<dd", 
    "<del", "<details", "<dfn", "<dialog", "<div", "<dl", "<dt", "<em", "<embed", 
    "<fieldset", "<figcaption", "<figure", "<footer", "<form", "<h1", "<h2", "<h3", 
    "<h4", "<h5", "<h6", "<head", "<header", "<hr", "<html", "<i", "<iframe", "<img", 
    "<input", "<ins", "<kbd", "<label", "<legend", "<li", "<link", "<main", "<map", 
    "<mark", "<meta", "<meter", "<nav", "<noscript", "<object", "<ol", "<optgroup", 
    "<option", "<output", "<p", "<param", "<picture", "<pre", "<progress", "<q", 
    "<rp", "<rt", "<ruby", "<samp", "<script", "<section", "<select", "<small", 
    "<source", "<strong", "<style", "<sub", "<summary", "<sup", "<svg", 
    "<table", "<tbody", "<td", "<template", "<textarea", "<tfoot", "<th", "<thead", 
    "<time", "<title", "<tr", "<track", "<u", "<ul", "<var", "<video", "<wbr",

    "src=", "href=", "action=", "formaction=", "data=", "xmlns=", "xlink:href",
    "poster=", "codebase=", "manifest=", "ping=", "target=", "download=", 
    "rel=", "referrerpolicy=", "integrity=", "sandbox=",

    "innerHTML", "outerHTML", "write%(", "writeln%(", "charCodeAt", "fromCharCode",
    "URLSearchParams", "Reflect%.apply", "Function%(", "constructor", "prototype",
    "__proto__", "toString%.constructor", "escape%(", "unescape%(", "`", "%${", "#{",
    "base64", "data:text/html", "data:text/javascript", "data:text/vbscript",
    "data:text/xml", "data:text/json", "data:text/plain", "data:application",
    "data:image/svg+xml", "data:image/x-icon", "data:image/png", "data:image/jpg",
    "data:image/gif", "data:image/webp"
}

function ESX.containsXSS(input)
    input = string.lower(input)
    for _, pattern in ipairs(patterns) do
        if string.match(input, pattern) then
            return true
        end
    end
    return false
end

function ESX.convertKeysToNumber(tbl)
    local newTable = {}
    for k, v in pairs(tbl) do
        local num_key = tonumber(k)
        if num_key then
            newTable[num_key] = v
        else
            newTable[k] = v
        end
    end
    return newTable
end

function ESX.isJson(str)
    return pcall(json.decode, str)
end

function ESX.isNumber(str)
    return tonumber(str) ~= nil
end

function ESX.roundCoords(coords)
    coords.x = math.floor(coords.x * 100 + 0.5) / 100
    coords.y = math.floor(coords.y * 100 + 0.5) / 100
    coords.z = math.floor(coords.z * 100 + 0.5) / 100
    return coords
end

function ESX.vec3ToString1(vec)
    local function r(v)
        return math.floor(v * 10 + 0.5) / 10
    end
    return string.format("(%.1f, %.1f, %.1f)", r(vec.x), r(vec.y), r(vec.z))
end

function ESX.hexToRGB(hex)
    hex = hex:gsub("#", "")

    if #hex == 3 then
        return tonumber(hex:sub(1,1)..hex:sub(1,1), 16),
               tonumber(hex:sub(2,2)..hex:sub(2,2), 16),
               tonumber(hex:sub(3,3)..hex:sub(3,3), 16)
    end

    return tonumber(hex:sub(1,2), 16),
           tonumber(hex:sub(3,4), 16),
           tonumber(hex:sub(5,6), 16)
end


function ESX.hexToFarsi(hex)
    hex = hex:gsub('#', ''):lower()

    local colors = {
        ['ff0000'] = 'قرمز',
        ['dc143c'] = 'قرمز زرشکی',
        ['b22222'] = 'قرمز آتشی',
        ['8b0000'] = 'قرمز تیره',
        ['cd5c5c'] = 'قرمز هندی',
        ['f08080'] = 'مرجانی روشن',
        ['fa8072'] = 'سالمونی',
        ['e9967a'] = 'سالمونی تیره',
        ['ff6347'] = 'گوجه‌ای',
        ['ff4500'] = 'قرمز نارنجی',
        ['ffa500'] = 'نارنجی',
        ['ff8c00'] = 'نارنجی تیره',
        ['ff7f50'] = 'مرجانی',
        ['e65100'] = 'نارنجی سوخته',
        ['ffff00'] = 'زرد',
        ['ffd700'] = 'طلایی',
        ['ffffe0'] = 'زرد روشن',
        ['fffacd'] = 'لیمویی',
        ['f0e68c'] = 'خاکی روشن',
        ['bdb76b'] = 'خاکی تیره',
        ['00ff00'] = 'سبز',
        ['008000'] = 'سبز تیره',
        ['006400'] = 'سبز خیلی تیره',
        ['90ee90'] = 'سبز روشن',
        ['98fb98'] = 'سبز کم‌رنگ',
        ['00fa9a'] = 'سبز بهاری',
        ['00ff7f'] = 'سبز بهاری روشن',
        ['3cb371'] = 'سبز دریایی',
        ['2e8b57'] = 'سبز دریایی تیره',
        ['228b22'] = 'سبز جنگلی',
        ['32cd32'] = 'سبز لیمویی',
        ['7cfc00'] = 'سبز چمنی',
        ['7fff00'] = 'سبز فسفری',
        ['adff2f'] = 'سبز زرد',
        ['556b2f'] = 'زیتونی تیره',
        ['6b8e23'] = 'زیتونی',
        ['808000'] = 'زیتونی',
        ['9acd32'] = 'سبز زرد',
        ['0000ff'] = 'آبی',
        ['00008b'] = 'آبی تیره',
        ['000080'] = 'سرمه‌ای',
        ['191970'] = 'آبی نیمه‌شب',
        ['4169e1'] = 'آبی سلطنتی',
        ['4682b4'] = 'آبی فولادی',
        ['1e90ff'] = 'آبی روشن',
        ['00bfff'] = 'آبی آسمانی',
        ['87ceeb'] = 'آبی آسمانی روشن',
        ['87cefa'] = 'آبی آسمانی کم‌رنگ',
        ['add8e6'] = 'آبی کم‌رنگ',
        ['b0e0e6'] = 'آبی پودری',
        ['00ffff'] = 'فیروزه‌ای',
        ['00ced1'] = 'فیروزه‌ای تیره',
        ['40e0d0'] = 'فیروزه‌ای روشن',
        ['48d1cc'] = 'فیروزه‌ای متوسط',
        ['20b2aa'] = 'سبز دریایی روشن',
        ['5f9ea0'] = 'آبی خاکستری',
        ['7fffd4'] = 'آکوامارین',
        ['66cdaa'] = 'آکوامارین متوسط',
        ['6495ed'] = 'آبی گل ذرت',
        ['800080'] = 'بنفش',
        ['8b008b'] = 'ارغوانی تیره',
        ['9932cc'] = 'ارکیده تیره',
        ['9400d3'] = 'بنفش تیره',
        ['ba55d3'] = 'ارکیده متوسط',
        ['da70d6'] = 'ارکیده',
        ['ee82ee'] = 'بنفش روشن',
        ['dda0dd'] = 'آلویی',
        ['d8bfd8'] = 'بنفش کم‌رنگ',
        ['e6e6fa'] = 'اسطوخودوسی',
        ['8a2be2'] = 'بنفش آبی',
        ['9370db'] = 'بنفش متوسط',
        ['7b68ee'] = 'بنفش آبی متوسط',
        ['6a5acd'] = 'بنفش تخته‌سنگی',
        ['483d8b'] = 'بنفش تخته‌سنگی تیره',
        ['4b0082'] = 'نیلی',
        ['ffc0cb'] = 'صورتی',
        ['ffb6c1'] = 'صورتی روشن',
        ['ff69b4'] = 'صورتی داغ',
        ['ff1493'] = 'صورتی پررنگ',
        ['db7093'] = 'بنفش صورتی',
        ['c71585'] = 'بنفش قرمز متوسط',
        ['ff00ff'] = 'سرخابی',
        ['a52a2a'] = 'قهوه‌ای',
        ['8b4513'] = 'قهوه‌ای زین اسبی',
        ['d2691e'] = 'شکلاتی',
        ['cd853f'] = 'قهوه‌ای روشن',
        ['deb887'] = 'کرم',
        ['f5deb3'] = 'گندمی',
        ['d2b48c'] = 'برنزه',
        ['bc8f8f'] = 'صورتی خاکستری',
        ['f4a460'] = 'قهوه‌ای شنی',
        ['b8860b'] = 'طلایی تیره',
        ['daa520'] = 'طلایی زرد',
        ['a0522d'] = 'قهوه‌ای سوخته',
        ['800000'] = 'خرمایی',
        ['808080'] = 'خاکستری',
        ['a9a9a9'] = 'خاکستری تیره',
        ['c0c0c0'] = 'نقره‌ای',
        ['d3d3d3'] = 'خاکستری روشن',
        ['dcdcdc'] = 'خاکستری خیلی روشن',
        ['696969'] = 'خاکستری کم‌نور',
        ['778899'] = 'خاکستری آبی',
        ['708090'] = 'خاکستری تخته‌سنگی',
        ['2f4f4f'] = 'خاکستری تخته‌سنگی تیره',
        ['ffffff'] = 'سفید',
        ['000000'] = 'مشکی',
        ['fffafa'] = 'سفید برفی',
        ['f5f5f5'] = 'سفید دودی',
        ['f0f0f0'] = 'سفید خاکستری',
        ['fffff0'] = 'عاجی',
        ['fffaf0'] = 'سفید گلی',
        ['faf0e6'] = 'کتانی',
        ['faebd7'] = 'سفید عتیقه',
        ['ffefd5'] = 'کرم پاپایا',
        ['ffe4c4'] = 'بادامی',
        ['ffdead'] = 'کرم ناواهو',
        ['ffe4b5'] = 'کرم موکاسین',
        ['f5f5dc'] = 'بژ',
        ['fff8dc'] = 'کرم ذرتی',
        ['fdf5e6'] = 'توری قدیمی',
    }

    if colors[hex] then
        return colors[hex]
    end

    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)

    local closestColor = 'نامشخص'
    local minDistance = math.huge

    for colorHex, colorName in pairs(colors) do
        local r2 = tonumber(colorHex:sub(1, 2), 16)
        local g2 = tonumber(colorHex:sub(3, 4), 16)
        local b2 = tonumber(colorHex:sub(5, 6), 16)

        local distance = math.sqrt(
            (r - r2)^2 +
            (g - g2)^2 +
            (b - b2)^2
        )

        if distance < minDistance then
            minDistance = distance
            closestColor = colorName
        end
    end

    return closestColor
end

function ESX.secondsToTimeComponents(totalSeconds)
    local days = math.floor(totalSeconds / 86400)  -- 86400 seconds in a day
    local remainingSeconds = totalSeconds % 86400

    local hours = math.floor(remainingSeconds / 3600)  -- 3600 seconds in an hour
    remainingSeconds = remainingSeconds % 3600

    local minutes = math.floor(remainingSeconds / 60)  -- 60 seconds in a minute
    local seconds = remainingSeconds % 60

    return days, hours, minutes, seconds
end

function ESX.isAlphaNumeric(str)
    return str:match("^[A-Za-z0-9]+$") ~= nil
end