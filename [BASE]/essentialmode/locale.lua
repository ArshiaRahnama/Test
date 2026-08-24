Locales = {}
local Config = {}
Config.Locale = "en"
function _(str, ...)
    if Locales[Config.Locale] ~= nil then
        if Locales[Config.Locale][str] ~= nil then
            return string.format(Locales[Config.Locale][str], ...)
        else
            return "Error [" .. Config.Locale .. "][" .. str .. "] Be Developer Elam Konid"
        end
    else
        return "Error [" .. Config.Locale .. "] Be Developer Elam Konid"
    end
end

function _U(str, ...)
    return tostring(_(str, ...):gsub("^%l", string.upper))
end
