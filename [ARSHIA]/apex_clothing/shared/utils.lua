--[[
    Apex Clothing Studio - shared utilities (client + server)
    Clean rewrite: same behaviour as the original, readable names.

    Utils.Log / Warn / Err   console logging (Log only prints when Config.debug is true)
    Utils.ActiveLocale()     language in use ('en', 'pt', ...)
    L(key, fallback, ...)    translate a key (global helper, string.format arguments allowed)
    Utils.Trim / Slug / Round / Clamp / TableCount
    Utils.B64Encode / B64Decode
    Utils.RandomCode(length) random code without look-alike characters
]]

Utils = Utils or {}

----------------------------------------------------------------------
-- Logging
----------------------------------------------------------------------
local function joinArguments(...)
    local parts = {}
    for index = 1, select('#', ...) do
        parts[index] = tostring((select(index, ...)))
    end
    return table.concat(parts, ' ')
end

function Utils.Log(...)
    if not (Config and Config.debug) then return end
    print('^5[apex_clothing]^7 ' .. joinArguments(...))
end

function Utils.Warn(...)
    print('^3[apex_clothing]^7 ' .. joinArguments(...))
end

function Utils.Err(...)
    print('^1[apex_clothing]^7 ' .. joinArguments(...))
end

----------------------------------------------------------------------
-- Language
----------------------------------------------------------------------
--- Server: Config.locale. Client: the player's own choice (/clothingstudio_lang)
--- when it names a language that exists, otherwise Config.locale.
function Utils.ActiveLocale()
    local default = 'en'
    if Config and type(Config.locale) == 'string' and Config.locale ~= '' then
        default = Config.locale
    end

    if IsDuplicityVersion() then return default end

    local chosen = GetResourceKvpString('apex_clothing_lang')
    if type(chosen) == 'string' and chosen ~= '' and chosen ~= 'auto'
        and Locales and Locales[chosen] then
        return chosen
    end
    return default
end

--- Translates `key`. If a second argument is given it is used as the text
--- instead (this is how the original behaved). Missing keys fall back to
--- the English text, then to the key itself. Extra arguments go through
--- string.format.
function L(key, fallback, ...)
    local text = nil

    if Locales then
        local dictionary = Locales[Utils.ActiveLocale()]
        if dictionary and dictionary[key] ~= nil then
            text = dictionary[key]
        end
        if text == nil and Locales.en then
            text = Locales.en[key]
        end
    end

    text = fallback or text
    if text == nil and not fallback then
        text = key
    end

    if select('#', ...) > 0 then
        local ok, formatted = pcall(string.format, text, ...)
        if ok then return formatted end
    end
    return text
end

----------------------------------------------------------------------
-- Strings and numbers
----------------------------------------------------------------------
function Utils.Trim(text)
    if type(text) ~= 'string' then return '' end
    return (text:gsub('^%s+', ''):gsub('%s+$', ''))
end

--- "My Cool Shirt!" -> "my_cool_shirt" (letters, digits, underscore; max 40)
function Utils.Slug(text)
    if type(text) ~= 'string' then return '' end
    local slug = text:lower()
    slug = slug:gsub('[%s%-%.]+', '_')
    slug = slug:gsub('[^a-z0-9_]', '')
    slug = slug:gsub('_+', '_')
    slug = slug:sub(1, 40)
    slug = slug:gsub('^_+', '')
    slug = slug:gsub('_+$', '')
    return slug
end

function Utils.Round(value, decimals)
    value = tonumber(value) or 0
    decimals = tonumber(decimals) or 0
    if decimals <= 0 then
        return math.floor(value + 0.5)
    end
    local factor = 10 ^ decimals
    return math.floor(value * factor + 0.5) / factor
end

function Utils.Clamp(value, minimum, maximum)
    value = tonumber(value) or 0
    if minimum > value then return minimum end
    if maximum < value then return maximum end
    return value
end

function Utils.TableCount(tbl)
    if type(tbl) ~= 'table' then return 0 end
    local count = 0
    for _ in pairs(tbl) do count = count + 1 end
    return count
end

----------------------------------------------------------------------
-- Base64
----------------------------------------------------------------------
local ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local PAD = string.byte('=')

local encodeChar = {}   -- 0..63  -> byte
local decodeChar = {}   -- byte  -> 0..63
for index = 1, 64 do
    local byte = ALPHABET:byte(index)
    encodeChar[index - 1] = byte
    decodeChar[byte] = index - 1
end

function Utils.B64Encode(data)
    if type(data) ~= 'string' then return nil end

    local out = {}
    local length = #data
    local fullBlocks = length - (length % 3)

    for i = 1, fullBlocks, 3 do
        local a, b, c = data:byte(i, i + 2)
        local n = (a << 16) | (b << 8) | c
        out[#out + 1] = string.char(
            encodeChar[(n >> 18) & 63], encodeChar[(n >> 12) & 63],
            encodeChar[(n >> 6) & 63],  encodeChar[n & 63])
    end

    local remainder = length % 3
    if remainder == 1 then
        local n = data:byte(length) << 16
        out[#out + 1] = string.char(encodeChar[(n >> 18) & 63], encodeChar[(n >> 12) & 63]) .. '=='
    elseif remainder == 2 then
        local a, b = data:byte(length - 1, length)
        local n = (a << 16) | (b << 8)
        out[#out + 1] = string.char(
            encodeChar[(n >> 18) & 63], encodeChar[(n >> 12) & 63], encodeChar[(n >> 6) & 63]) .. '='
    end

    return table.concat(out)
end

--- Returns the decoded string, or nil when the input is not valid base64.
function Utils.B64Decode(text)
    if type(text) ~= 'string' then return nil end
    text = text:gsub('%s', '')
    if text == '' then return '' end

    local length = #text
    if length % 4 ~= 0 then return nil end

    local out = {}
    for i = 1, length, 4 do
        local c1, c2, c3, c4 = text:byte(i, i + 3)
        local v1, v2 = decodeChar[c1], decodeChar[c2]
        if not v1 or not v2 then return nil end

        if c4 == PAD then
            if length > i + 3 then return nil end            -- padding only in the last block
            if c3 == PAD then
                out[#out + 1] = string.char(((v1 << 2) | (v2 >> 4)) & 255)
            else
                local v3 = decodeChar[c3]
                if not v3 then return nil end
                out[#out + 1] = string.char(
                    ((v1 << 2) | (v2 >> 4)) & 255,
                    (((v2 & 15) << 4) | (v3 >> 2)) & 255)
            end
        else
            if c3 == PAD then return nil end
            local v3, v4 = decodeChar[c3], decodeChar[c4]
            if not v3 or not v4 then return nil end
            out[#out + 1] = string.char(
                ((v1 << 2) | (v2 >> 4)) & 255,
                (((v2 & 15) << 4) | (v3 >> 2)) & 255,
                (((v3 & 3) << 6) | v4) & 255)
        end
    end
    return table.concat(out)
end

----------------------------------------------------------------------
-- Random codes (no 0/O/1/I so they can be read out loud)
----------------------------------------------------------------------
local CODE_CHARS = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'

function Utils.RandomCode(length)
    length = tonumber(length) or 8
    if length < 1 then length = 1 end

    local chars = {}
    for index = 1, length do
        local pick = math.random(1, #CODE_CHARS)
        chars[index] = CODE_CHARS:sub(pick, pick)
    end
    return table.concat(chars)
end