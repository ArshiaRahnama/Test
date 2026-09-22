-- ============================================================
--  Society Pay  -  client  (NUI: wizard-e pardakht, panel-e Boss, pardakht-haye man)
-- ============================================================
local C = Config.Pay
local L = C.Locale
local uiOpen = false

local function notify(ntype, description)
    lib.notify({ type = ntype, description = description, duration = C.NotifyDuration })
end

local function openUI(action, data)
    if uiOpen then return end
    uiOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = action, data = data, config = { sounds = C.Sounds, autoRefresh = C.AutoRefresh } })
end

local function closeUI()
    if not uiOpen then return end
    uiOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

-- ============================================================
--  NUI callbacks
-- ============================================================
RegisterNUICallback('close', function(_, cb)
    closeUI()
    cb('ok')
end)

RegisterNUICallback('pay', function(d, cb)
    d = d or {}
    cb(lib.callback.await('esx_society:pay:pay', false, d.dept, d.org, d.type, d.amount, d.purpose, d.note)
        or { ok = false, error = L.err_generic })
end)

RegisterNUICallback('bossList', function(d, cb)
    cb(lib.callback.await('esx_society:pay:bossList', false, d or {}) or { ok = false, error = L.err_generic })
end)

RegisterNUICallback('bossReport', function(d, cb)
    cb(lib.callback.await('esx_society:pay:bossReport', false, d and d.days) or { ok = false, error = L.err_generic })
end)

RegisterNUICallback('myList', function(d, cb)
    cb(lib.callback.await('esx_society:pay:myList', false, d and d.page) or { ok = false, error = L.err_generic })
end)

-- ============================================================
--  /pay  (wizard: DOJ/LAW -> ordan -> jozeeyat)
-- ============================================================
RegisterCommand(C.Command, function()
    CreateThread(function()
        if uiOpen then return end
        local data = lib.callback.await('esx_society:pay:open', false)
        if not data then return notify('error', L.err_generic) end
        openUI('openPay', data)
    end)
end, false)
TriggerEvent('chat:addSuggestion', '/' .. C.Command, 'پرداخت به ارگان‌های DOJ و Law Enforcement')

-- /paylog
if C.HistoryCommand then
    RegisterCommand(C.HistoryCommand, function()
        openUI('openMine', {})
    end, false)
    TriggerEvent('chat:addSuggestion', '/' .. C.HistoryCommand, 'پرداخت‌های من')
end

-- ============================================================
--  Boss Action (client/main.lua -> OpenBossMenu az in tabe-ha estefade mikone)
-- ============================================================
function OpenPayBossPanel()
    CreateThread(function()
        if uiOpen then return end
        local res = lib.callback.await('esx_society:pay:bossList', false, { status = 'open', type = 'all', page = 1 })
        if not res or not res.ok then
            return notify('error', res and res.error or L.err_generic)
        end
        openUI('openBoss', res)
    end)
end

-- true = in job ye ordan-e DOJ ya LAW hast
function PayIsPayJob(job)
    return Pay.findOrg(job) ~= nil
end

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then SetNuiFocus(false, false) end
end)
