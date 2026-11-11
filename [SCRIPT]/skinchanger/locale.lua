Locales = {}

-- Translate a string. Falls back to the English locale when the active
-- locale (or one of its keys) is missing, instead of showing an error string.
function _(str, ...)
  local active   = Locales[Config.Locale]
  local fallback = Locales['en']

  local text = (active and active[str]) or (fallback and fallback[str])

  if text == nil then
    if active == nil and fallback == nil then
      return 'Locale [' .. tostring(Config.Locale) .. '] does not exists'
    end
    return 'Translation [' .. tostring(Config.Locale) .. '][' .. tostring(str) .. '] does not exists'
  end

  return string.format(text, ...)
end

function _U(str, ...)
  return (tostring(_(str, ...)):gsub("^%l", string.upper))
end
