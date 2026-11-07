-- Only the window. All logic (reading / editing the organisation points) is in
-- esx_uniquejobs/client/job_manager.lua, which talks to this resource through
-- exports + the local event 'ujjob:nui'.
local isOpen = false

local function close()
    if not isOpen then return end
    isOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ type = 'close' })
    TriggerEvent('ujjob:closed')
end

exports('Open', function(payload)
    isOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ type = 'open', data = payload })
end)
exports('Update', function(payload) if isOpen then SendNUIMessage({ type = 'update', data = payload }) end end)
exports('Close', close)
exports('IsOpen', function() return isOpen end)

RegisterNUICallback('close', function(_, cb) close() cb('ok') end)
RegisterNUICallback('action', function(data, cb) TriggerEvent('ujjob:nui', data) cb('ok') end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() and isOpen then SetNuiFocus(false, false) end
end)
