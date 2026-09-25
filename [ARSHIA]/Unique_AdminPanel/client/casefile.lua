-- Unique_AdminPanel | client/casefile.lua
-- Client side of server/casefile.lua: opens the Case File / Global Search / Money Ledger /
-- Report Evidence panels (rendered by html/app.js) and relays their NUI callbacks.
-- Every request is re-checked on the server, so nothing here grants access by itself.

local function showPanel(kind, data)
    MenuV:CloseAll()
    SendNUIMessage({ type = kind, data = data })
    SetNuiFocus(true, true)
    InAdminNui = true
end

local function notify(msg) drawNotification(msg) end

-- ------------------------------------------------------------- openers ----

function OpenCaseFile(target)
    ESX.TriggerServerCallback('Unique_AdminPanel:GetCaseFile', function(data)
        if not data then notify('~r~Case file not available (no access or unknown player)') return end
        showPanel('casefile', data)
    end, target)
end

function OpenLedger(target, hours)
    ESX.TriggerServerCallback('Unique_AdminPanel:GetLedger', function(data)
        if not data then notify('~r~Ledger not available (level 2+ on duty required)') return end
        showPanel('ledger', data)
    end, target, hours or 24)
end

function OpenLedgerTop(hours)
    ESX.TriggerServerCallback('Unique_AdminPanel:GetLedgerTop', function(data)
        if not data then notify('~r~Ledger not available (level 2+ on duty required)') return end
        showPanel('ledgertop', data)
    end, hours or 24)
end

function OpenEvidence(reportId)
    ESX.TriggerServerCallback('Unique_AdminPanel:GetReportEvidence', function(data)
        if not data or (not data.chat and not data.nearby and not data.screenshot and not data.context) then
            notify('~y~No evidence stored for that report')
            return
        end
        showPanel('evidence', data)
    end, reportId)
end

function OpenGlobalSearch()
    showPanel('search', {})
end

-- ----------------------------------------------------------- NUI relays ----

RegisterNUICallback('globalSearch', function(payload, cb)
    cb('ok')
    ESX.TriggerServerCallback('Unique_AdminPanel:GlobalSearch', function(res)
        SendNUIMessage({ type = 'searchResults', data = res or { results = {} } })
    end, payload and payload.q or '')
end)

RegisterNUICallback('openCaseFile', function(payload, cb)
    cb('ok')
    if payload and payload.identifier then
        ESX.TriggerServerCallback('Unique_AdminPanel:GetCaseFile', function(data)
            if data then SendNUIMessage({ type = 'casefile', data = data }) end
        end, payload.identifier)
    end
end)

RegisterNUICallback('openLedger', function(payload, cb)
    cb('ok')
    if payload and payload.identifier then
        ESX.TriggerServerCallback('Unique_AdminPanel:GetLedger', function(data)
            if data then SendNUIMessage({ type = 'ledger', data = data }) end
        end, payload.identifier, payload.hours or 24)
    end
end)

RegisterNUICallback('openEvidence', function(payload, cb)
    cb('ok')
    if payload and payload.reportId then
        ESX.TriggerServerCallback('Unique_AdminPanel:GetReportEvidence', function(data)
            if data then SendNUIMessage({ type = 'evidence', data = data }) end
        end, payload.reportId)
    end
end)

RegisterNUICallback('revertLedger', function(payload, cb)
    cb('ok')
    if payload and payload.id then TriggerServerEvent('Unique_AdminPanel:RevertLedger', payload.id) end
end)

-- ------------------------------------------------------------- shortcut ----
-- Ctrl+K inside any open panel opens the search too (handled in html/app.js).
-- In-game hotkey: F11 (rebind in Settings > Key Bindings > FiveM).
-- FIX: was F6, which collided with other resources bound to that key.
RegisterCommand('uap_globalsearch', function()
    if aduty then OpenGlobalSearch() end
end, false)
RegisterKeyMapping('uap_globalsearch', 'Admin panel: Global search', 'keyboard', 'F11')
