-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local ALLOWED_DATA <const> = {
    ['title'] = {type = 'string', required = true, min = Config.DefaultValues.title.min, max = Config.DefaultValues.title.max},
    ['maxPlayers'] = {type = 'number', required = true, min = Config.DefaultValues.maxPlayers.min, max = Config.DefaultValues.maxPlayers.max},
    ['fee'] = {type = 'number', required = true, min = Config.DefaultValues.fee.min, max = Config.DefaultValues.fee.max},
    ['privacy'] = {type = 'string', required = true, onlyAllow = Config.PrivacyList},
    ['checkPoints'] = {type = 'table', required = true, dataType = 'vector3'},
    ['collision'] = {type = 'boolean', required = true},
    ['class'] = {type = 'number', required = false},
}

-- [[VALIDATION STUFF]]
local function doesTableContain(tbl, value)
    for i = 1, #tbl do
        local thisValue = tbl[i]
        if thisValue == value then
            return true
        end
    end
    return false
end

function trimDataByAllowed(data)
    local newData <const> = {}
    for key, value in pairs(data) do
        if ALLOWED_DATA[key] then
            newData[key] = value
        end
    end

    return newData
end

function singleValidate(key, value)
    local validation = ALLOWED_DATA[key]
    if not validation then return false end

    local thisDataType <const> = type(value)

    -- If data must exist and type is not same as validation then it not valid
    if validation.required and thisDataType ~= validation.type then
        return false
        -- If data is not require but if exist and type is not same as validation then its not valid
    elseif not validation.required and thisDataType ~= "nil" and thisDataType ~= validation.type then
        return false
    end

    -- If data has min and max it we should do checks depending on data type
    if validation.min then
        -- It's less than min value so we should return
        if (thisDataType == 'number' and value or value:len()) < validation.min then
            return false
        end
    end
    if validation.max then
        -- It's more than max value so we should return
        if (thisDataType == 'number' and value or value:len()) > validation.max then
            return false
        end
    end

    if validation.dataType and thisDataType == "table" then
        -- The table must be array not key and value, it's table of for example vector3 it should not contain key and value
        if table.type(value) ~= 'array' then return false end
        for i = 1, #value do
            local thisData = value[i]
            -- If value inside that array table it not equal to validation data type then the data is not valid
            if type(thisData) ~= validation.dataType then
                return false
            end
        end
    end

    -- Table does not contain this data so it's not valid
    if validation.onlyAllow and not doesTableContain(validation.onlyAllow, value) then
        return false
    end

    return true
end

function validateRaceData(data)
    for key, validation in pairs(ALLOWED_DATA) do
        local dataValue <const> = data[key]
        if not singleValidate(key, dataValue) then
            return false
        end
    end

    return true
end