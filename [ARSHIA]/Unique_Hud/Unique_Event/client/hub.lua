--[[
    Unique_Event - client hub
    Opens /uevent, fetches data from the server, forwards hub button clicks, and drives the
    admin spectate camera.
]]

local hubOpen = false

local function openHub()
    if hubOpen then return end
    if not ESX then return UE.Notify('Still loading, try again in a second.', 'error') end
    hubOpen = true
    UE.UI.Set('hub', true)
    UE.Send('hubOpen', {})
    ESX.TriggerServerCallback('ue:hub:get', function(data)
        UE.Send('hubData', data)
    end)
end

local function closeHub()
    if not hubOpen then return end
    hubOpen = false
    UE.UI.Set('hub', false)
    UE.Send('hubClose', {})
end

UE.Command(Config.Hub.Command, function() openHub() end, false)
for _, alias in ipairs(Config.Hub.Aliases or {}) do
    RegisterCommand(alias, function() openHub() end, false)
end
if Config.Hub.Key then RegisterKeyMapping(Config.Hub.Command, 'Unique Event: open /uevent menu', 'keyboard', Config.Hub.Key) end

RegisterNUICallback('hub:close', function(_, cb) closeHub() cb('ok') end)
RegisterNUICallback('hub:refresh', function(_, cb)
    if not ESX then return cb('ok') end
    ESX.TriggerServerCallback('ue:hub:get', function(data) UE.Send('hubData', data) end)
    cb('ok')
end)
RegisterNUICallback('hub:page', function(data, cb)
    if not ESX then return cb('ok') end
    ESX.TriggerServerCallback('ue:hub:page', function(page) UE.Send('hubPage', { event = data.event, page = page }) end, data.event)
    cb('ok')
end)
RegisterNUICallback('hub:action', function(data, cb)
    TriggerServerEvent('ue:hub:action', data.event, data.action, data.payload or {})
    cb('ok')
end)

AddEventHandler('ue:stateChanged', function(eventName)
    -- if the player joins an event while the hub happens to be open, close it so the HUD is visible
    if eventName and hubOpen then closeHub() end
end)

-- ============================================================
-- Admin spectate
-- ============================================================
local Spec = { active = false, target = nil, list = {}, cam = nil, listVisible = false }

local function specRefreshList()
    if not ESX then return end
    ESX.TriggerServerCallback('ue:spec:targets', function(list)
        Spec.list = list
        UE.Send('specList', { players = list, current = Spec.target })
    end)
end

RegisterNetEvent('ue:spec:start')
AddEventHandler('ue:spec:start', function()
    Spec.active = true
    UE.Send('specShow', { show = true })
    specRefreshList()
end)

RegisterNetEvent('ue:spec:forceLeave')
AddEventHandler('ue:spec:forceLeave', function()
    Spec.active = false
    Spec.target = nil
    if Spec.cam then RenderScriptCams(false, true, 500, true, true) DestroyCam(Spec.cam, false) Spec.cam = nil end
    UE.Send('specShow', { show = false })
end)

RegisterNetEvent('ue:spec:locked')
AddEventHandler('ue:spec:locked', function(target)
    Spec.target = target
    UE.Send('specListToggle', { show = false })
end)

RegisterNUICallback('spec:select', function(data, cb)
    TriggerServerEvent('ue:spec:select', data.source)
    cb('ok')
end)

UE.BindKey('TAB', 'Unique Event: spectate player list', 'spectate', function()
    Spec.listVisible = not Spec.listVisible
    if Spec.listVisible then specRefreshList() end
    UE.Send('specListToggle', { show = Spec.listVisible })
end)

UE.BindKey('BACK', 'Unique Event: leave spectate', 'spectate', function()
    TriggerServerEvent('ue:spec:leave')
    Spec.active = false
    if Spec.cam then RenderScriptCams(false, true, 500, true, true) DestroyCam(Spec.cam, false) Spec.cam = nil end
    UE.Send('specShow', { show = false })
end)

local function cycleTarget(dir)
    if #Spec.list == 0 then return end
    local idx = 1
    for i, p in ipairs(Spec.list) do if p.source == Spec.target then idx = i break end end
    idx = idx + dir
    if idx < 1 then idx = #Spec.list end
    if idx > #Spec.list then idx = 1 end
    TriggerServerEvent('ue:spec:select', Spec.list[idx].source)
end
UE.BindKey('LEFT', 'Unique Event: spectate previous player', 'spectate', function() cycleTarget(-1) end)
UE.BindKey('RIGHT', 'Unique Event: spectate next player', 'spectate', function() cycleTarget(1) end)

CreateThread(function()
    while true do
        Wait(0)
        if Spec.active and Spec.target then
            local target = GetPlayerFromServerId(Spec.target)
            if target ~= -1 then
                local ped = GetPlayerPed(target)
                if ped ~= 0 and DoesEntityExist(ped) then
                    if not Spec.cam then
                        Spec.cam = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', GetEntityCoords(ped), vector3(0, 0, 0), 60.0)
                        SetCamActive(Spec.cam, true)
                        RenderScriptCams(true, true, 500, true, true)
                    end
                    AttachCamToEntity(Spec.cam, ped, 0.0, -3.5, 1.6, true)
                    PointCamAtEntity(Spec.cam, ped, 0.0, 0.0, 0.4, true)
                    local hp = math.max(0, GetEntityHealth(ped) - 100)
                    local label = '-'
                    for _, p in ipairs(Spec.list) do if p.source == Spec.target then label = p.label break end end
                    UE.Send('specCard', {
                        name = GetPlayerName(target) or '-', sub = label,
                        hp = hp, armor = GetPedArmour(ped), event = label,
                    })
                end
            else
                Spec.target = nil
                if Spec.cam then RenderScriptCams(false, true, 300, true, true) DestroyCam(Spec.cam, false) Spec.cam = nil end
            end
        else
            Wait(400)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(4000)
        if Spec.active and Spec.listVisible then specRefreshList() end
    end
end)
