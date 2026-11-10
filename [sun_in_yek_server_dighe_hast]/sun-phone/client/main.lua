-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

DebugPrint("^2========================================")
DebugPrint("^2[SUN-PHONE] Client script loading...")
DebugPrint("^2========================================")

PlayerJob = {}
Profile = {}
CachedData = {
    contacts = nil,
    photos = nil,
    emails = nil,
    call_history = nil,
    isLoaded = false
}
PhoneData = {
    SignalZone = Config.Signal.DefaultSignalZones,
    MetaData = {},
    isOpen = false,
    PlayerData = nil,
    AnimationData = {
        lib = nil,
        anim = nil,
    },
    CallData = {
        InCall = false,
        CallId = nil,
        AnsweredCall = false
    },
    overlayOpen = false,
}


local isTyping = false
local reopenCooldownExpiresAt = nil
local REOPEN_COOLDOWN_MS = 1000

-- Unarmed weapon hash, resolved ONCE at load — never call GetHashKey inside a
-- per-frame loop (it's expensive). GetSelectedPedWeapon returns this same hash
-- to compare against cheaply.
local UNARMED_HASH = GetHashKey("WEAPON_UNARMED")

RegisterNUICallback('typing-start', function(_, cb)
    isTyping = true
    SetNuiFocusKeepInput(false)
    cb('ok')
end)

RegisterNUICallback('typing-end', function(_, cb)
    isTyping = false
    SetNuiFocusKeepInput(true)
    cb('ok')
end)

RegisterNUICallback('overlay-state', function(body, cb)
    PhoneData.overlayOpen = body and body.open and true or false
    cb('ok')
end)

function InitializePhoneData(callback)
    ESX.TriggerServerCallback('sun-phone:server:InitPhoneData', function(data)
        if data then
            Profile = data.profile or {}
            CachedData.contacts = data.contacts or {}
            CachedData.photos = data.photos or {}
            CachedData.emails = nil
            CachedData.call_history = data.call_history or {}
            CachedData.isLoaded = true
            DebugPrint("^2[sun-phone] Phone data initialized (cached: " .. tostring(data.cached) .. ")^0")
        else
            DebugPrint("^1[sun-phone] Failed to initialize phone data^0")
        end
        if callback then callback(data) end
    end)
end

function RefreshPhoneData(dataType)
    ESX.TriggerServerCallback('sun-phone:server:RefreshData', function(success)
        if success then
            if dataType == 'contacts' then
                CachedData.contacts = nil
            elseif dataType == 'photos' then
                CachedData.photos = nil
            elseif dataType == 'emails' then
                CachedData.emails = nil
            elseif dataType == 'profile' then
                Profile = {}
            elseif dataType == 'all' then
                CachedData = {
                    contacts = nil,
                    photos = nil,
                    emails = nil,
                    call_history = nil,
                    isLoaded = false
                }
                Profile = {}
            end
            DebugPrint("^2[sun-phone] Data refreshed: " .. dataType .. "^0")
        end
    end, dataType)
end

exports('RefreshPhoneData', RefreshPhoneData)
exports('GetCachedContacts', function() return CachedData.contacts end)
exports('GetCachedPhotos', function() return CachedData.photos end)
exports('GetCachedEmails', function() return CachedData.emails end)
exports('GetProfile', function() return Profile end)

-- Compat export for sun-jobs medic (old sunset_phone had it). The real EMS
-- dispatch (blip + coords to on-duty medics) happens in sun-jobs' own
-- medic:sendems server event — this export exists so the medic client can
-- call it plainly without erroring.
exports('SendLocationEMS', function() end)

function GetStreetName()
    local pos = GetEntityCoords(PlayerPedId())
    local s1, s2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local street1 = GetStreetNameFromHashKey(s1)
    local street2 = GetStreetNameFromHashKey(s2)
    local streetLabel = street1
    if street2 ~= nil then
        streetLabel = streetLabel .. ' ' .. street2
    end

    return streetLabel
end

local function DisablePhoneControls()
    DisableControlAction(0, 1, true)
    DisableControlAction(0, 2, true)
    DisableControlAction(0, 24, true)
    DisableControlAction(0, 25, true)
    DisableControlAction(0, 47, true)
    DisableControlAction(0, 58, true)
    DisableControlAction(0, 59, true)
    DisableControlAction(0, 73, true)
    DisableControlAction(0, 140, true)
    DisableControlAction(0, 141, true)
    DisableControlAction(0, 142, true)
    DisableControlAction(0, 143, true)
    DisableControlAction(0, 257, true)
    DisableControlAction(0, 263, true)
    DisableControlAction(0, 264, true)
    DisableControlAction(0, 245, true)
    DisableControlAction(0, 37, true)
    DisableControlAction(0, 200, true)
    DisableControlAction(27, 75, true)
end

local function InputControlLoop()
    CreateThread(function()
        while PhoneData.isOpen do
            Wait(0)
            -- Selective control lock (the original behaviour): block only the
            -- pause menu / map keys, mouse-look and weapon wheel. Movement,
            -- voice (N), and the camera keys stay ENABLED so they keep working.
            DisableControlAction(0, 199, true) -- FrontendPauseAlternate
            DisableControlAction(0, 200, true) -- FrontendPause (Esc)
            DisableControlAction(0, 202, true) -- FrontendCancel
            DisableControlAction(0, 322, true) -- Esc

            DisableControlAction(0, 1, true)   -- LookLeftRight
            DisableControlAction(0, 2, true)   -- LookUpDown
            DisableControlAction(0, 24, true)  -- Attack
            DisableControlAction(0, 25, true)  -- Aim

            DisableControlAction(0, 12, true)  -- WeaponWheelUpDown
            DisableControlAction(0, 13, true)  -- WeaponWheelLeftRight
            DisableControlAction(0, 14, true)  -- WeaponWheelNext
            DisableControlAction(0, 15, true)  -- WeaponWheelPrev
            DisableControlAction(0, 16, true)  -- SelectNextWeapon
            DisableControlAction(0, 17, true)  -- SelectPrevWeapon
            DisableControlAction(0, 37, true)  -- SelectWeapon (TAB)
            DisableControlAction(0, 99, true)  -- VehicleSelectNextWeapon
            DisableControlAction(0, 100, true) -- VehicleSelectPrevWeapon
            DisableControlAction(0, 115, true) -- SelectNextWeapon (alt)
            DisableControlAction(0, 116, true) -- SelectPrevWeapon (alt)
            DisableControlAction(0, 261, true) -- VehicleCinCam
            DisableControlAction(0, 262, true)
            DisableControlAction(2, 14, true)  -- WeaponWheel (mouse)
            DisableControlAction(2, 15, true)
            DisableControlAction(2, 16, true)
            DisableControlAction(2, 17, true)

            DisableControlAction(0, 81, true)
            DisableControlAction(0, 82, true)
            DisableControlAction(0, 83, true)
            DisableControlAction(0, 84, true)
            DisableControlAction(0, 85, true)
            DisableControlAction(2, 81, true)
            DisableControlAction(2, 82, true)

            -- Esc closes the phone. It's a DISABLED control above so it never
            -- reaches the pause menu, and we close from Lua (closing via the NUI
            -- left a 1-frame gap where the released Esc opened the map).
            if IsDisabledControlJustReleased(0, 200)
                or IsDisabledControlJustReleased(0, 202)
                or IsDisabledControlJustReleased(0, 322) then
                -- An overlay (fullscreen video, image lightbox) owns Esc first:
                -- it closes itself and the phone stays open.
                if PhoneData.overlayOpen then
                    SendNUIMessage({ event = 'sun-phone', closeOverlay = true })
                else
                    ClosePhoneFully()
                end
            end
        end
    end)
end

-- Gun + open phone must NEVER coexist. Light guard that only runs WHILE the
-- phone is open: if a weapon somehow ends up in hand (a script/job force-equips
-- one), we DON'T close the phone — we just switch the ped back to unarmed and
-- keep the phone open. GetSelectedPedWeapon is a cheap hash read (compared to
-- the pre-resolved UNARMED_HASH, no GetHashKey per frame); the loop sleeps
-- 100ms so it stays effectively free.
local function DisarmWhileOpenLoop()
    CreateThread(function()
        while PhoneData.isOpen do
            local ped = PlayerPedId()
            if GetSelectedPedWeapon(ped) ~= UNARMED_HASH then
                SetCurrentPedWeapon(ped, UNARMED_HASH, true)
            end
            Wait(100)
        end
    end)
end

function OpenPhone()
    if PhoneData.ArcadePending then return end
    if PhoneData.isOpen or IsNuiFocused() or LocalPlayer.state.nui then return end

    local hasWeapon, weaponHash = GetCurrentPedWeapon(PlayerPedId(), true)
    if weaponHash ~= UNARMED_HASH then
        ESX.Alert('', "Cannot open phone!", 3000, 'error')
        return
    end

    if not (ESX.DoesHaveItem2('phone', 1) or HasTempPhone) then
        ESX.Alert('', "You don't have a phone", 3000, 'error')
        return
    end

    local ply = ESX.GetPlayerData()
    if ply then
        PhoneData.PlayerData = {
            identifier = ply.identifier
        }
    end

    if not CachedData.isLoaded then
        local p = promise.new()
        InitializePhoneData(function()
            p:resolve()
        end)
        Citizen.Await(p)
    end

    ESX.closeAll()
    LocalPlayer.state.nui = true

        exports['ox_target']:disableTargeting(true)
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)
        SendNUIMessage({
            event = 'sun-phone',
            isOpen = true,
            profile = Profile,
            cachedData = CachedData
        })

    PhoneData.isOpen = true

    exports['essentialmode']:disableallControl(true)
    InputControlLoop()
    DisarmWhileOpenLoop()

    if not PhoneData.CallData.InCall then
        DoPhoneAnimation('cellphone_text_in')
    else
        DoPhoneAnimation('cellphone_call_to_text')
    end

    SetTimeout(250, function()
        newPhoneProp()
    end)
end

-- Fully close the phone: hide the NUI, release focus, play the put-away
-- animation, and delete the phone prop. Exported as `close` so external
-- resources can dismiss the phone before opening their own menu. This is
-- the sun-phone equivalent of the old `exports['sunset_phone']:close()`
-- that the taxi job menu (sun-jobs/modules/taxi) relies on — when a player
-- requests a taxi from the phone, the taxi system closes the phone first,
-- then shows its request menu.
function ClosePhoneFully()
    exports['ox_target']:disableTargeting(false)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    isTyping = false
    PhoneData.isOpen = false
    PhoneData.overlayOpen = false
    LocalPlayer.state.nui = nil
    reopenCooldownExpiresAt = GetGameTimer() + REOPEN_COOLDOWN_MS
    exports['essentialmode']:disableallControl(false)
    SendNUIMessage({
        event = 'sun-phone',
        isOpen = false,
    })
    if not PhoneData.CallData.InCall then
        DoPhoneAnimation('cellphone_text_out')
        SetTimeout(400, function()
            StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
            deletePhone()
            PhoneData.AnimationData.lib = nil
            PhoneData.AnimationData.anim = nil
        end)
    end
end
exports('close', ClosePhoneFully)

-- If the resource is stopped/restarted while the phone is open, the core's
-- input block would stay latched on (muting F1/F10 menus etc). Release it.
AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    exports['essentialmode']:disableallControl(false)
    exports['ox_target']:disableTargeting(false)
    LocalPlayer.state.nui = nil
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
end)

local phoneKey = string.lower(Config.OpenPhone)

AddEventHandler('KeyDown:' .. phoneKey, function()
    local PlayerData = ESX.GetPlayerData()
    if not PlayerData then return end

    if PhoneData.isOpen then
        ClosePhoneFully()
        return
    end

    if PlayerData.IsDead or PlayerData.HandCuffed == 1 then return end
    if reopenCooldownExpiresAt and reopenCooldownExpiresAt > GetGameTimer() then return end

    OpenPhone()
end)

AddEventHandler('KeyDown2:' .. phoneKey, function()
    if PhoneData.isOpen then
        ClosePhoneFully()
    end
end)

RegisterNUICallback('close-phone', function(_, cb)
    ClosePhoneFully()
    cb('ok')
end)

RegisterNUICallback('get-profile', function(_, cb)
    cb(Profile)
end)

-- Authoritative contacts push: the server sends the FULL fresh list after
-- every mutation (delete/save/update/favourite/block/airdrop). Pin it to the
-- local cache and forward it to the NUI. `count` rides along because an
-- EMPTY Lua table json-encodes as {} (an object, not an array) — React uses
-- count to distinguish "empty list" from "no payload".
local lastContactsPushSeq = 0
RegisterNetEvent('sun-phone:client:ContactsPushed', function(contacts, seq)
    -- Drop out-of-order pushes: a slow (Redis-gated) build from an older
    -- mutation must not overwrite the list from a newer one.
    if seq then
        if seq <= lastContactsPushSeq then return end
        lastContactsPushSeq = seq
    end
    contacts = contacts or {}
    CachedData.contacts = contacts
    SendNUIMessage({
        event = 'sun-phone:RefreshContacts',
        contacts = contacts,
        count = #contacts
    })
end)

-- Legacy pull-based refresh — kept as a fallback for any external caller.
-- The cache is only replaced AFTER a non-empty result arrives.
RegisterNetEvent('sun-phone:client:RefreshContacts', function()
    ESX.TriggerServerCallback('sun-phone:server:GetContacts', function(result)
        if result and #result > 0 then
            CachedData.contacts = result
            SendNUIMessage({
                event = 'sun-phone:RefreshContacts',
                contacts = result,
                count = #result
            })
        end
    end)
end)

-- Get cached contacts (no server call if already cached)
RegisterNUICallback('get-cached-contacts', function(_, cb)
    if CachedData.contacts then
        cb(CachedData.contacts)
    else
        ESX.TriggerServerCallback('sun-phone:server:GetContacts', function(result)
            CachedData.contacts = result
            cb(result)
        end)
    end
end)

-- Get cached photos (no server call if already cached)
RegisterNUICallback('get-cached-photos', function(_, cb)
    if CachedData.photos then
        cb(CachedData.photos)
    else
        ESX.TriggerServerCallback('sun-phone:server:GetPhotos', function(result)
            CachedData.photos = result
            cb(result)
        end)
    end
end)

-- Get cached emails (no server call if already cached)
RegisterNUICallback('get-cached-emails', function(_, cb)
    if CachedData.emails then
        cb(CachedData.emails)
    else
        ESX.TriggerServerCallback('sun-phone:server:GetEmails', function(result)
            CachedData.emails = result
            cb(result)
        end)
    end
end)

RegisterNUICallback('close', function(_, cb)
    exports['ox_target']:disableTargeting(false)
    PhoneData.isOpen = false
    PhoneData.overlayOpen = false
    LocalPlayer.state.nui = nil
    reopenCooldownExpiresAt = GetGameTimer() + REOPEN_COOLDOWN_MS
    exports['essentialmode']:disableallControl(false)
    if not PhoneData.CallData.InCall then
        DoPhoneAnimation('cellphone_text_out')
        SetTimeout(400, function()
            StopAnimTask(PlayerPedId(), PhoneData.AnimationData.lib, PhoneData.AnimationData.anim, 2.5)
            deletePhone()
            PhoneData.AnimationData.lib = nil
            PhoneData.AnimationData.anim = nil
        end)
    else
        PhoneData.AnimationData.lib = nil
        PhoneData.AnimationData.anim = nil
        DoPhoneAnimation('cellphone_text_to_call')
    end
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    isTyping = false -- Reset typing state when closing phone

    local position = GetEntityCoords(PlayerPedId(), false)
	local object = GetClosestObjectOfType(position.x, position.y, position.z, 5.0, GetHashKey("prop_amb_phone"), false, false, false)
    if object ~= 0 then
		DeleteObject(object)
	end

    cb('ok')
end)

RegisterNUICallback('open-phone', function(_, cb)
    if not PhoneData.isOpen then
        OpenPhone()
    end
    cb('ok')
end)
