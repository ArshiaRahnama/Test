if not Config.Arshia or not Config.Arshia.SecurityApp then return end

-- Arshia Phone: Security app (server side).
-- Thin wrapper over Unique_Login exports, which own login_users / login_audit.
-- Requests come from the phone client with a reqId; answers go back with
-- arshia_sec:response. Passwords are never logged here.

local function reply(src, reqId, data)
    TriggerClientEvent("arshia_sec:response", src, reqId, data)
end

local function loginReady()
    return GetResourceState("Unique_Login") == "started"
end

RegisterNetEvent("arshia_sec:devices", function(reqId)
    local src = source
    if not loginReady() then return reply(src, reqId, { devices = {}, error = "unavailable" }) end
    exports.Unique_Login:getDevicesForPlayer(src, function(info)
        reply(src, reqId, info or { devices = {} })
    end)
end)

RegisterNetEvent("arshia_sec:otp", function(reqId, oldPassword, newPassword)
    local src = source
    if not loginReady() then return reply(src, reqId, { ok = false, reason = "unavailable" }) end
    if type(oldPassword) ~= "string" or type(newPassword) ~= "string" then
        return reply(src, reqId, { ok = false, reason = "invalid" })
    end
    exports.Unique_Login:requestPasswordChangeOtp(src, oldPassword, function(ok, reason)
        reply(src, reqId, { ok = ok == true, reason = reason })
    end)
end)

RegisterNetEvent("arshia_sec:confirm", function(reqId, code, newPassword)
    local src = source
    if not loginReady() then return reply(src, reqId, { ok = false, reason = "unavailable" }) end
    if type(code) ~= "string" or type(newPassword) ~= "string" then
        return reply(src, reqId, { ok = false, reason = "invalid" })
    end
    exports.Unique_Login:confirmPasswordChange(src, code, newPassword, function(ok, reason)
        reply(src, reqId, { ok = ok == true, reason = reason })
    end)
end)

RegisterNetEvent("arshia_sec:logoutAll", function(reqId)
    local src = source
    if not loginReady() then return reply(src, reqId, { ok = false, reason = "unavailable" }) end
    exports.Unique_Login:logoutAllDevices(src)
    reply(src, reqId, { ok = true })
end)
