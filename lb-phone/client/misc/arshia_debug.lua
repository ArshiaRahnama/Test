-- Arshia Phone: diagnostic logger (Config.Arshia.Debug = true).
-- Logs every access to a MISSING key on Config / ESX tables, which is what
-- "attempt to call a nil value (field '?')" in protected code usually means.
-- Look in F8 for lines starting with [ArshiaDbg].
if not Config.Arshia or not Config.Arshia.Debug then return end

local function log(...) print("^3[ArshiaDbg]^7", ...) end
local seen = {}
local reportedAll = {}

local function watch(tbl, name, depth)
    if type(tbl) ~= "table" or depth > 4 or seen[tbl] then return end
    seen[tbl] = true
    if getmetatable(tbl) == nil then
        local reported = reportedAll
        setmetatable(tbl, { __index = function(_, k)
            local key = name .. "." .. tostring(k)
            if not reported[key] then
                reported[key] = true
                local info = debug.getinfo and debug.getinfo(2, "Sl")
                log("MISSING key accessed:", key, info and (info.short_src .. ":" .. tostring(info.currentline)) or "")
            end
            return nil
        end })
    end
    for k, v in pairs(tbl) do
        if type(v) == "table" then watch(v, name .. "." .. tostring(k), depth + 1) end
    end
end

log("Phone starting. Flags:", json.encode(Config.Arshia))
log("Resource name:", GetCurrentResourceName(), "| Framework:", tostring(Config.Framework))
log("PhoneNumber:", json.encode(Config.PhoneNumber))
local n = 0 for _ in pairs(Config.Companies and Config.Companies.Services or {}) do n = n + 1 end
log("Companies services:", n)
for id, app in pairs(Config.CustomApps or {}) do
    log("CustomApp:", id, json.encode(app))
end
for name, value in pairs(Config) do
    if type(value) == "function" then log("Config function:", name) end
end

watch(Config, "Config", 0)

CreateThread(function()
    while not ESX do Wait(500) end
    watch(ESX, "ESX", 0)
    log("ESX ready. PlayerLoaded:", tostring(ESX.PlayerLoaded), "identifier:", ESX.PlayerData and tostring(ESX.PlayerData.identifier) or "nil")
    for _, fn in ipairs({ "GetPlayerData", "TriggerServerCallback", "SearchInventory", "Game", "RegisterCommand" }) do
        reportedAll["ESX." .. fn] = nil
        log("ESX." .. fn, rawget(ESX, fn) ~= nil and "present" or "MISSING")
    end
end)

AddEventHandler("onClientResourceStart", function(res)
    if res == GetCurrentResourceName() then log("resource started") end
end)

RegisterNetEvent("arshia:dbg", function() end)

-- also watch the standard libs and globals for missing members/functions
watch(table, "table", 3)
watch(string, "string", 3)
watch(math, "math", 3)
if getmetatable(_G) == nil then
    local rep = {}
    setmetatable(_G, { __index = function(_, k)
        if type(k) == "string" and not rep[k] then
            rep[k] = true
            local info = debug.getinfo and debug.getinfo(2, "Sl")
            log("MISSING global:", k, info and (info.short_src .. ":" .. tostring(info.currentline)) or "")
        end
        return nil
    end })
end

-- log when the UI asks for phone data, so the error can be matched to it
RegisterNetEvent("arshia:dbg:mark", function() log("--- mark ---") end)
CreateThread(function()
    Wait(1000)
    for _, name in ipairs({ "FetchPhone", "LogOut", "OnDeath", "HasPhoneItem", "GetJob", "GetJobGrade", "GetCompanyData", "FormatNumber", "ToggleOpen", "SendReactMessage", "table.contains" }) do
        local v = name == "table.contains" and table.contains or _G[name]
        log("function", name, type(v))
    end
end)

-- ===== automatic bisect =====
-- Calls the phone's getPhoneData NUI callback directly with different parts of the config switched
-- on/off, and prints which combination fails. Result lines: [ArshiaDbg] BISECT ...
-- Also available later as the F8 command:  arshia_bisect
local function callPhoneData()
    local done, ok = false, false
    TriggerEvent("__cfx_nui:getPhoneData", {}, function() done = true ok = true end)
    local t = GetGameTimer() + 3000
    while not done and GetGameTimer() < t do Wait(50) end
    return ok
end

local function runBisect()
    local sec = Config.CustomApps and Config.CustomApps.arshia_security
    local services = Config.Companies and Config.Companies.Services
    local extra = {}
    if services then
        for i = #services, 5, -1 do extra[#extra + 1] = table.remove(services, i) end
    end
    local num = { Format = Config.PhoneNumber.Format, Prefixes = Config.PhoneNumber.Prefixes }

    local function apply(s, j, n)
        if Config.CustomApps then Config.CustomApps.arshia_security = s and sec or nil end
        if services then
            while #services > 4 do table.remove(services) end
            if j then for i = #extra, 1, -1 do services[#services + 1] = extra[i] end end
        end
        if n then Config.PhoneNumber.Format, Config.PhoneNumber.Prefixes = num.Format, num.Prefixes
        else Config.PhoneNumber.Format, Config.PhoneNumber.Prefixes = "({3}) {3}-{4}", { "205", "907", "480", "520", "602" } end
    end

    local tests = {
        { "all OFF (baseline)", false, false, false },
        { "only Security app", true, false, false },
        { "only extra jobs", false, true, false },
        { "only 0911 numbers", false, false, true },
        { "ALL ON", true, true, true },
    }
    log("BISECT start (errors below are expected while testing)")
    for _, t in ipairs(tests) do
        apply(t[2], t[3], t[4])
        local ok = callPhoneData()
        log("BISECT", t[1], ok and "=> OK" or "=> FAILED")
        Wait(500)
    end
    apply(Config.Arshia.SecurityApp, Config.Arshia.ExtraCompanies, Config.Arshia.PhoneNumber0911)
    log("BISECT done")
end

RegisterCommand("arshia_bisect", function() CreateThread(runBisect) end, false)
CreateThread(function()
    Wait(15000)
    runBisect()
end)
