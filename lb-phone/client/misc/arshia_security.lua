if not Config.Arshia or not Config.Arshia.SecurityApp then return end

-- Arshia Phone: Security app (client side). Bridges NUI callbacks to server events.
local pending, nextId = {}, 0

local function ask(event, cb, ...)
    nextId = nextId + 1
    pending[nextId] = cb
    TriggerServerEvent(event, nextId, ...)
end

RegisterNetEvent("arshia_sec:response", function(reqId, data)
    local cb = pending[reqId]
    pending[reqId] = nil
    if cb then cb(data) end
end)

RegisterNUICallback("secInfo", function(_, cb) ask("arshia_sec:devices", cb) end)
RegisterNUICallback("secOtp", function(d, cb) ask("arshia_sec:otp", cb, d.oldPassword, d.newPassword) end)
RegisterNUICallback("secConfirm", function(d, cb) ask("arshia_sec:confirm", cb, d.code, d.newPassword) end)
RegisterNUICallback("secLogoutAll", function(_, cb) ask("arshia_sec:logoutAll", cb) end)
