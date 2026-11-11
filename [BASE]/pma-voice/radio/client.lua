-- Unique radio (merged into pma-voice) - handheld radio modelled on the Sunset rp_radio.
-- Everything here is local on purpose: this file shares a Lua VM with pma-voice.

local ESX = nil
local Radio = {
    Open = false, On = false, Frequency = Config.MinFrequency, Clicks = true,
    Prop = nil, Busy = false, Toggling = false, InputOpen = false,
}
local Access = UniqueRadio.BuildDefaultAccess()   -- replaced by the server's copy
local List = {}                                   -- [serverId] = { name = '', talking = false }
local ListVisible = GetResourceKvpString('unique_radio_list') ~= '0'
local lastToggle, lastFreq = -100000, -100000
local memberBlips, gpsBlips, alertBlips = {}, {}, {}
local menuOpen = false

local PROP_MODEL = joaat('prop_cs_hand_radio')
local UNARMED = joaat('weapon_unarmed')
local DIGIT_CONTROLS = { 157, 158, 160, 164, 165, 159, 161, 162 }   -- keys 1..8

---------------------------------------------------------------------------
-- helpers
---------------------------------------------------------------------------
local function now() return GetGameTimer() end

local function notify(msg)
    if ESX and ESX.ShowNotification then
        ESX.ShowNotification(msg)
    else
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostTicker(false, false)
    end
end

local function chat(text)
    TriggerEvent('chat:addMessage', { color = { 255, 215, 0 }, multiline = true, args = { '[Radio]', text } })
end

local function nui(data)
    data.uniqueRadio = true
    SendNUIMessage(data)
end

local function isDead()
    local ped = PlayerPedId()
    return IsEntityDead(ped) or IsPedFatallyInjured(ped)
end

local function playerJobGang()
    local data = ESX and ESX.GetPlayerData and ESX.GetPlayerData() or nil
    if not data then return nil end
    local gang = data.gang or {}
    return data.job and data.job.name or nil, gang.name, gang.grade
end

local function restricted()
    local job, gangName = playerJobGang()
    return UniqueRadio.IsRestricted(job, gangName)
end

local function canAccess(freq)
    local job, gangName, gangGrade = playerJobGang()
    return UniqueRadio.CanAccess(Access, freq, job, gangName, gangGrade)
end

local function freqLabel(freq)
    local name = Config.FrequencyNames[freq]
    if name then return ('%d (%s)'):format(freq, name) end
    return tostring(freq)
end

local function loadAnim(dict)
    if HasAnimDictLoaded(dict) then return true end
    RequestAnimDict(dict)
    local limit = now() + 3000
    while not HasAnimDictLoaded(dict) and now() < limit do Wait(10) end
    return HasAnimDictLoaded(dict)
end

local function loadModel(model)
    if HasModelLoaded(model) then return true end
    RequestModel(model)
    local limit = now() + 3000
    while not HasModelLoaded(model) and now() < limit do Wait(10) end
    return HasModelLoaded(model)
end

local function holdDict(ped)
    if IsPedInAnyVehicle(ped, false) then return 'anim@cellphone@in_car@ps' end
    return 'cellphone@'
end

local function voice(property, value)
    exports['pma-voice']:setVoiceProperty(property, value)
end

---------------------------------------------------------------------------
-- radio list (NUI)
---------------------------------------------------------------------------
local function sendList()
    local arr = {}
    for id, entry in pairs(List) do
        arr[#arr + 1] = { id = id, name = entry.name, talking = entry.talking == true }
    end
    table.sort(arr, function(a, b) return a.id < b.id end)
    nui({ action = 'list', list = arr, showNames = Config.ShowNamesInList, visible = ListVisible })
end

local function clearList()
    List = {}
    sendList()
end

---------------------------------------------------------------------------
-- prop + animation
---------------------------------------------------------------------------
local function removeProp()
    local prop = Radio.Prop
    Radio.Prop = nil
    if prop and DoesEntityExist(prop) then
        DetachEntity(prop, true, true)
        DeleteEntity(prop)
    end
end

local function playHoldAnim(ped)
    local dict = holdDict(ped)
    if loadAnim(dict) then
        TaskPlayAnim(ped, dict, 'cellphone_text_in', 3.0, -1.0, -1, 50, 0, false, false, false)
    end
end

-- instant = true: no put-away animation (death, resource stop, forced off)
local function closeRadio(instant)
    if not Radio.Open then return end
    Radio.Open = false
    Radio.Toggling = true
    CreateThread(function()
        local ped = PlayerPedId()
        if not instant and not isDead() then
            local dict = holdDict(ped)
            if loadAnim(dict) then
                TaskPlayAnim(ped, dict, 'cellphone_text_out', 3.0, -1.0, -1, 48, 0, false, false, false)
                Wait(450)
            end
        end
        ped = PlayerPedId()
        StopAnimTask(ped, 'cellphone@', 'cellphone_text_in', 2.0)
        StopAnimTask(ped, 'anim@cellphone@in_car@ps', 'cellphone_text_in', 2.0)
        StopAnimTask(ped, 'cellphone@', 'cellphone_text_out', 2.0)
        StopAnimTask(ped, 'anim@cellphone@in_car@ps', 'cellphone_text_out', 2.0)
        removeProp()
        Radio.Toggling = false
    end)
end

---------------------------------------------------------------------------
-- on / off / frequency
---------------------------------------------------------------------------
local function joinChannel(freq)
    exports['pma-voice']:setRadioChannel(freq)
    TriggerServerEvent('3dme:shareDisplay', 'Dastesho mibare be samte radio va freq ro avaz mikone', true)
end

local function turnOff()
    if not Radio.On then return end
    Radio.On = false
    Radio.Busy = false
    nui({ action = 'sound', name = 'off', volume = 0.5 })
    voice('radioEnabled', false)
    exports['pma-voice']:setRadioChannel(0)
    clearList()
end

local function turnOn()
    if Radio.On then return end
    Radio.On = true
    nui({ action = 'sound', name = 'on', volume = 0.3 })
    voice('radioEnabled', true)
    voice('micClicks', Radio.Clicks)
    joinChannel(Radio.Frequency)
end

local function toggleOn()
    if now() - lastToggle < Config.ToggleCooldown then
        return notify('Spam nakonid!')
    end
    if restricted() then
        return notify('Shoma nemitavanid az radio estefade konid!')
    end
    if Radio.On then
        lastToggle = now()
        return turnOff()
    end
    if not canAccess(Radio.Frequency) then
        return notify('Shoma dastresi be in frequency nadarid!')
    end
    lastToggle = now()
    turnOn()
end

local function setFrequency(raw)
    local f = UniqueRadio.ParseFrequency(raw)
    if not f then
        notify(('Frequency bayad beyn %d ta %d bashad!'):format(Config.MinFrequency, Config.MaxFrequency))
        return false
    end
    if restricted() then
        notify('Shoma nemitavanid az radio estefade konid!')
        return false
    end
    if not canAccess(f) then
        notify('Shoma dastresi be in frequency nadarid!')
        return false
    end
    if Radio.On and f == Radio.Frequency then
        notify(('Shoma hamin alan roye frq %s hastid!'):format(freqLabel(f)))
        return false
    end
    if now() - lastFreq < Config.FrequencyCooldown then
        notify('Spam nakonid!')
        return false
    end
    lastFreq = now()
    Radio.Frequency = f
    if Radio.On then joinChannel(f) end
    notify(('Shoma be frq ~g~%s~s~ join dadid!'):format(freqLabel(f)))
    return true
end

local FORCE_REASONS = {
    item = 'Shoma radio nadarid!',
    restricted = 'Shoma nemitavanid az radio estefade konid!',
    access = 'Dastresi shoma be in frequency lagv shod!',
    range = 'Frequency namotabar ast!',
}

local function forceOff(reason)
    Radio.Busy = false
    closeRadio(true)
    local wasOn = Radio.On
    turnOff()
    if wasOn and FORCE_REASONS[reason] then notify(FORCE_REASONS[reason]) end
end

---------------------------------------------------------------------------
-- frequency prompt
---------------------------------------------------------------------------
local function promptFrequency()
    if Radio.InputOpen then return end
    Radio.InputOpen = true
    AddTextEntry('UNIQUE_RADIO_INPUT', ('Frequency (%d-%d)'):format(Config.MinFrequency, Config.MaxFrequency))
    DisplayOnscreenKeyboard(1, 'UNIQUE_RADIO_INPUT', '', tostring(Radio.Frequency), '', '', '', 5)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    local result = nil
    if UpdateOnscreenKeyboard() == 1 then result = GetOnscreenKeyboardResult() end
    Wait(300)
    Radio.InputOpen = false
    if result and result ~= '' then setFrequency(result) end
end

---------------------------------------------------------------------------
-- open radio (item use): prop + help text + keys
---------------------------------------------------------------------------
AddTextEntry('UNIQUE_RADIO_HELP_OFF',
    '~INPUT_CELLPHONE_CANCEL~ to hide.~n~~INPUT_CONTEXT~ to turn radio ~g~on~s~.~n~~INPUT_FRONTEND_ACCEPT~ to choose frequency~n~~INPUT_SELECT_WEAPON~ to ~a~ mic clicks~n~Frequency: ~1~ MHz')
AddTextEntry('UNIQUE_RADIO_HELP_ON',
    '~INPUT_CELLPHONE_CANCEL~ to hide.~n~~INPUT_CONTEXT~ to turn radio ~r~off~s~.~n~~INPUT_FRONTEND_ACCEPT~ to choose frequency~n~~INPUT_SELECT_WEAPON~ to ~a~ mic clicks~n~Frequency: ~1~ MHz')

local function openLoop()
    while Radio.Open do
        Wait(0)
        local ped = PlayerPedId()
        if isDead() then
            forceOff('dead')
            break
        end

        if GetSelectedPedWeapon(ped) ~= UNARMED then
            SetCurrentPedWeapon(ped, UNARMED, true)
        end

        if not Radio.Busy then
            local dict = holdDict(ped)
            if HasAnimDictLoaded(dict) then
                if not IsEntityPlayingAnim(ped, dict, 'cellphone_text_in', 3) then playHoldAnim(ped) end
            else
                RequestAnimDict(dict)
            end
        end

        BeginTextCommandDisplayHelp(Radio.On and 'UNIQUE_RADIO_HELP_ON' or 'UNIQUE_RADIO_HELP_OFF')
        AddTextComponentSubstringPlayerName(Radio.Clicks and '~r~disable~s~' or '~g~enable~s~')
        AddTextComponentInteger(Radio.Frequency)
        EndTextCommandDisplayHelp(0, false, false, -1)

        DisableControlAction(0, 37, true)   -- weapon wheel (TAB)
        if not Radio.InputOpen then
            if IsControlJustPressed(0, 177) then
                closeRadio(false)
                break
            elseif IsControlJustPressed(0, 51) then
                toggleOn()
            elseif IsDisabledControlJustPressed(0, 37) then
                Radio.Clicks = not Radio.Clicks
                if Radio.On then voice('micClicks', Radio.Clicks) end
                notify(Radio.Clicks and 'Mic clicks ~g~roshan~s~ shod.' or 'Mic clicks ~r~khamush~s~ shod.')
            elseif IsControlJustPressed(0, 201) then
                CreateThread(promptFrequency)
            elseif not Radio.On and IsControlJustPressed(0, 174) then
                Radio.Frequency = Radio.Frequency <= Config.MinFrequency and Config.MaxFrequency or Radio.Frequency - 1
            elseif not Radio.On and IsControlJustPressed(0, 175) then
                Radio.Frequency = Radio.Frequency >= Config.MaxFrequency and Config.MinFrequency or Radio.Frequency + 1
            end
        end
    end
end

local function openRadio()
    if Radio.Open or Radio.Toggling or isDead() then return end
    Radio.Toggling = true
    local ped = PlayerPedId()
    if not loadModel(PROP_MODEL) or not loadAnim(holdDict(ped)) then
        Radio.Toggling = false
        return notify('Radio load nashod, dobare emtehan konid.')
    end
    SetCurrentPedWeapon(ped, UNARMED, true)
    local c = GetEntityCoords(ped)
    local prop = CreateObject(PROP_MODEL, c.x, c.y, c.z + 0.2, true, true, false)
    SetModelAsNoLongerNeeded(PROP_MODEL)
    if prop and prop ~= 0 then
        AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, false, false, false, 2, true)
        Radio.Prop = prop
    end
    Radio.Open = true
    Radio.Toggling = false
    playHoldAnim(ped)
    CreateThread(openLoop)
end

RegisterNetEvent('Unique_Radio:client:toggle', function()
    if Radio.Open then
        closeRadio(false)
    else
        openRadio()
    end
end)

RegisterCommand('radio', function()
    if Radio.Open then
        closeRadio(false)
    else
        TriggerServerEvent('Unique_Radio:server:requestOpen')
    end
end, false)

---------------------------------------------------------------------------
-- broadcasting animation (pma-voice fires radioActive on push-to-talk)
---------------------------------------------------------------------------
AddEventHandler('pma-voice:radioActive', function(active)
    local selfId = GetPlayerServerId(PlayerId())
    if List[selfId] then
        List[selfId].talking = active == true
        sendList()
    end
    if not active then
        Radio.Busy = false
        return
    end
    if Radio.Busy or not Radio.On or isDead() then return end
    Radio.Busy = true
    CreateThread(function()
        local job = playerJobGang()
        local chatter = job ~= nil and Config.ChatterJobs[job] == true
        local dict = chatter and 'random@arrests' or 'cellphone@str'
        local anim = chatter and 'generic_radio_chatter' or 'cellphone_call_listen_a'
        loadAnim(dict)
        while Radio.Busy do
            local ped = PlayerPedId()
            if isDead() then break end
            if HasAnimDictLoaded(dict) and not IsEntityPlayingAnim(ped, dict, anim, 3) then
                TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 49, 0, false, false, false)
            end
            DisableControlAction(2, 24, true)
            DisableControlAction(2, 257, true)
            DisableControlAction(2, 25, true)
            DisableControlAction(2, 263, true)
            DisableControlAction(2, 45, true)
            DisableControlAction(2, 37, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)
            Wait(0)
        end
        Radio.Busy = false
        local ped = PlayerPedId()
        StopAnimTask(ped, dict, anim, 2.0)
        RemoveAnimDict(dict)
    end)
end)

---------------------------------------------------------------------------
-- Shift + 1..8 quick channels (only while the radio is on)
---------------------------------------------------------------------------
local function quickList()
    local job = playerJobGang()
    return job and Config.QuickChannels[job] or nil
end

CreateThread(function()
    while true do
        local list = Radio.On and quickList() or nil
        if list and #list > 0 then
            Wait(0)
            if IsControlPressed(0, 21) then
                local count = math.min(#list, #DIGIT_CONTROLS)
                for i = 1, count do DisableControlAction(0, DIGIT_CONTROLS[i], true) end
                for i = 1, count do
                    if IsDisabledControlJustPressed(0, DIGIT_CONTROLS[i]) then
                        setFrequency(list[i])
                    end
                end
            end
        else
            Wait(500)
        end
    end
end)

---------------------------------------------------------------------------
-- server events: roster, access, denial
---------------------------------------------------------------------------
local function quiet()
    local job = playerJobGang()
    return job ~= nil and Config.QuietJobs[job] == true
end

RegisterNetEvent('Unique_Radio:client:roster', function(_, roster)
    List = {}
    for _, member in ipairs(roster or {}) do
        List[member.id] = { name = member.name, talking = false }
    end
    sendList()
end)

RegisterNetEvent('Unique_Radio:client:memberJoined', function(id, name)
    List[id] = { name = name, talking = false }
    sendList()
    if not quiet() then chat(('%s(%d) be frq radio join shod!'):format(name, id)) end
end)

RegisterNetEvent('Unique_Radio:client:memberLeft', function(id)
    local entry = List[id]
    List[id] = nil
    sendList()
    if entry and not quiet() then chat(('%s(%d) az frq radio kharej shod!'):format(entry.name, id)) end
end)

RegisterNetEvent('Unique_Radio:client:memberRenamed', function(id, name)
    if List[id] then
        List[id].name = name
        sendList()
    end
end)

RegisterNetEvent('Unique_Radio:client:clear', clearList)

RegisterNetEvent('pma-voice:setTalkingOnRadio', function(id, talking)
    if List[id] then
        List[id].talking = talking == true
        sendList()
    end
end)

RegisterNetEvent('Unique_Radio:client:syncAccess', function(raw)
    Access = UniqueRadio.NormalizeAccess(raw)
end)

RegisterNetEvent('Unique_Radio:client:denied', function(reason)
    if Radio.On then turnOff() end
    notify(FORCE_REASONS[reason] or 'Shoma dastresi be in frequency nadarid!')
end)

RegisterNetEvent('Unique_Radio:client:forceOff', function(reason)
    forceOff(reason)
end)

RegisterNetEvent('Unique_Radio:client:setClicks', function(value)
    Radio.Clicks = value == true
end)

-- pma-voice rejected our join (server said no): make sure we are not stuck "on"
RegisterNetEvent('pma-voice:radioChangeRejected', function()
    if Radio.On then turnOff() end
end)

---------------------------------------------------------------------------
-- teammate blips, GPS, panic
---------------------------------------------------------------------------
local function removeBlip(blip)
    if blip and DoesBlipExist(blip) then RemoveBlip(blip) end
end

local function clearMemberBlips()
    for id, entry in pairs(memberBlips) do
        removeBlip(entry.blip)
        memberBlips[id] = nil
    end
end

local function nameBlip(blip, text)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandSetBlipName(blip)
end

CreateThread(function()
    while true do
        local job = playerJobGang()
        local active = Radio.On and next(List) ~= nil and not (job and Config.NoBlipJobs[job])
        if not active then
            clearMemberBlips()
            Wait(1500)
        else
            for id, entry in pairs(memberBlips) do
                if not List[id] then
                    removeBlip(entry.blip)
                    memberBlips[id] = nil
                end
            end
            for id, member in pairs(List) do
                local player = GetPlayerFromServerId(id)
                local ped = player ~= -1 and GetPlayerPed(player) or 0
                local entry = memberBlips[id]
                if ped ~= 0 and DoesEntityExist(ped) then
                    if not entry or entry.ped ~= ped or not DoesBlipExist(entry.blip) then
                        if entry then removeBlip(entry.blip) end
                        local blip = AddBlipForEntity(ped)
                        SetBlipSprite(blip, 1)
                        SetBlipColour(blip, 1)
                        SetBlipScale(blip, 0.8)
                        SetBlipAlpha(blip, 180)
                        SetBlipCategory(blip, 7)
                        SetBlipDisplay(blip, 6)
                        ShowHeadingIndicatorOnBlip(blip, true)
                        nameBlip(blip, ('%s(%d)'):format(member.name or '', id))
                        memberBlips[id] = { blip = blip, ped = ped }
                    end
                elseif entry then
                    removeBlip(entry.blip)
                    memberBlips[id] = nil
                end
            end
            Wait(5000)
        end
    end
end)

local function showTimedBlip(store, key, coords, sprite, colour, scale, label, duration, pulse)
    removeBlip(store[key])
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, colour)
    SetBlipScale(blip, scale)
    SetBlipAsShortRange(blip, false)
    if pulse then PulseBlip(blip) end
    nameBlip(blip, label)
    store[key] = blip
    SetTimeout(duration, function()
        if store[key] == blip then
            removeBlip(blip)
            store[key] = nil
        end
    end)
end

RegisterNetEvent('Unique_Radio:client:gps', function(list)
    for _, member in ipairs(list or {}) do
        showTimedBlip(gpsBlips, member.id, member, 1, 2, 0.9, ('%s(%d)'):format(member.name or '', member.id), Config.GPSDuration, false)
    end
    notify('Mokhtasat afrad radio roye map neshan dade shod.')
end)

RegisterNetEvent('Unique_Radio:client:alert', function(coords, id, name)
    if type(coords) ~= 'table' then return end
    showTimedBlip(alertBlips, id, coords, 161, 27, 2.0, ('Poshtibani: %s(%d)'):format(name or '', id), Config.AlertDuration, true)
    PlaySoundFrontend(-1, 'Beep_Red', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', true)
    chat(('%s(%d) Darkhast poshtibani kard!'):format(name or '', id))
end)

local function requestGPS()
    if isDead() then return end
    if not Radio.On then return notify('Radio shoma khamush ast!') end
    TriggerServerEvent('Unique_Radio:server:gps')
end

local function requestPanic()
    if isDead() then return end
    if not Radio.On then return notify('Radio shoma khamush ast!') end
    TriggerServerEvent('Unique_Radio:server:panic')
end

RegisterNetEvent('radio:ShowGPS', requestGPS)
RegisterNetEvent('radio:sendAlert', requestPanic)
RegisterCommand('radiogps', requestGPS, false)
RegisterCommand('radiopanic', requestPanic, false)

---------------------------------------------------------------------------
-- commands
---------------------------------------------------------------------------
RegisterCommand('freq', function(_, args)
    if not Radio.On then return notify('Radio shoma khamush ast!') end
    if not args[1] then return notify(('Estefade: /freq [%d-%d]'):format(Config.MinFrequency, Config.MaxFrequency)) end
    setFrequency(args[1])
end, false)

RegisterCommand('myfreq', function()
    chat(('Frequency shoma: %s ^7(radio %s)'):format(freqLabel(Radio.Frequency), Radio.On and 'roshan' or 'khamush'))
end, false)

RegisterCommand('radiolist', function()
    ListVisible = not ListVisible
    SetResourceKvp('unique_radio_list', ListVisible and '1' or '0')
    sendList()
    notify(ListVisible and 'List radio ~g~namayesh~s~ dade mishavad.' or 'List radio ~r~makhfi~s~ shod.')
end, false)

---------------------------------------------------------------------------
-- frequency manager (admin)
---------------------------------------------------------------------------
RegisterNetEvent('Unique_Radio:client:openMenu', function(access)
    menuOpen = true
    SetNuiFocus(true, true)
    nui({ action = 'openMenu', access = access, min = Config.MinFrequency, max = Config.MaxFrequency })
end)

RegisterNUICallback('uniqueRadio:close', function(_, cb)
    menuOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('uniqueRadio:setFreq', function(data, cb)
    if type(data) == 'table' then
        TriggerServerEvent('Unique_Radio:server:setFreq', data.freq, data.access)
    end
    cb('ok')
end)

---------------------------------------------------------------------------
-- lifecycle
---------------------------------------------------------------------------
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        if ESX == nil then Wait(200) end
    end
    while true do
        local data = ESX.GetPlayerData()
        if data and data.job then break end
        Wait(200)
    end
    TriggerServerEvent('Unique_Radio:server:requestAccess')
end)

-- state watchdog: death, lost item, job change
CreateThread(function()
    local ticks = 0
    while true do
        Wait(500)
        if Radio.On or Radio.Open then
            if isDead() then
                forceOff('dead')
            else
                ticks = ticks + 1
                if ticks >= 14 then
                    ticks = 0
                    TriggerServerEvent('Unique_Radio:server:verify')
                end
                if Radio.On and restricted() then forceOff('restricted') end
            end
        else
            ticks = 0
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    Radio.Open, Radio.Busy = false, false
    removeProp()
    clearMemberBlips()
    for _, store in ipairs({ gpsBlips, alertBlips }) do
        for key, blip in pairs(store) do
            removeBlip(blip)
            store[key] = nil
        end
    end
    ClearPedTasks(PlayerPedId())
    if menuOpen then SetNuiFocus(false, false) end
end)
