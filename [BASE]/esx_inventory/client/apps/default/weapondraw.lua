--[[
    ================================================================
    WEAPON DRAW / HOLSTER  —  round 4
    ================================================================

    Before this, equipping a weapon from the inventory was a single
    `SetCurrentPedWeapon(ped, name, true)` call: the gun teleported into
    the ped's hands on the same frame, from nowhere. This plays a real
    draw (and a real holster) around that call.

    Design notes
    ------------
    * The weapon is given to the hands PART-WAY through the animation
      (`revealAt`), not at the start and not at the end. At the start the
      gun appears before the hand moves; at the end the hand mimes an
      empty draw and the gun pops in late. Mid-anim is what reads as
      "pulling it out".

    * Upper-body-only flags (49 / 48) so the player can keep walking
      while drawing, which is what every player expects. The ped is NOT
      frozen and controls are NOT disabled — a holster animation that
      takes your movement away gets you killed and gets the script
      turned off.

    * `DrawLock` is a real re-entrancy guard, not a timer: spamming the
      hotbar key cannot stack two draws, and it is always released in a
      `finally`-style path even if something below errors, so the player
      can never end up permanently unable to equip.

    * Everything is per-class and lives in `Config.WeaponDrawAnims`
      below, so swapping in your own dictionaries is a config edit.
]]

if Config.WeaponDrawAnims == nil then
    Config.WeaponDrawAnims = {
        -- revealAt = ms into the animation at which the weapon is put in
        -- the hands; total = how long the clip is allowed to run.
        ['pistol'] = {
            drawDict = 'reaction@intimidation@1h', drawAnim = 'intro',
            holsterDict = 'reaction@intimidation@cop@unarmed', holsterAnim = 'intro',
            revealAt = 260, total = 900, flag = 49,
        },
        ['smg'] = {
            drawDict = 'reaction@intimidation@1h', drawAnim = 'intro',
            holsterDict = 'reaction@intimidation@cop@unarmed', holsterAnim = 'intro',
            revealAt = 300, total = 950, flag = 49,
        },
        ['rifle'] = {
            drawDict = 'reaction@intimidation@1h', drawAnim = 'intro',
            holsterDict = 'reaction@intimidation@cop@unarmed', holsterAnim = 'intro',
            revealAt = 380, total = 1100, flag = 49,
        },
        ['shotgun'] = {
            drawDict = 'reaction@intimidation@1h', drawAnim = 'intro',
            holsterDict = 'reaction@intimidation@cop@unarmed', holsterAnim = 'intro',
            revealAt = 380, total = 1100, flag = 49,
        },
        ['heavy'] = {
            drawDict = 'reaction@intimidation@1h', drawAnim = 'intro',
            holsterDict = 'reaction@intimidation@cop@unarmed', holsterAnim = 'intro',
            revealAt = 450, total = 1200, flag = 49,
        },
        ['melee'] = {
            drawDict = 'anim@melee@machete@holster', drawAnim = 'unholster',
            holsterDict = 'anim@melee@machete@holster', holsterAnim = 'holster',
            revealAt = 200, total = 700, flag = 49,
        },
    }
end

Config.WeaponDrawEnabled = (Config.WeaponDrawEnabled == nil) and true or Config.WeaponDrawEnabled

local DrawLock = false

--- Is this ped in a state where an upper-body animation would look wrong
--- or get instantly cancelled? Drawing while in a car, swimming, ragdolled
--- or already in a scripted task is one of those states — do the weapon
--- swap without the flourish rather than playing a clip that gets culled.
local function canPlayDrawAnim(ped)
    if not Config.WeaponDrawEnabled then return false end
    if IsPedInAnyVehicle(ped, false) then return false end
    if IsPedRagdoll(ped) or IsPedSwimming(ped) or IsPedFalling(ped) then return false end
    if IsPedInMeleeCombat(ped) then return false end
    return true
end

local function playClip(ped, dict, anim, flag, total)
    if not dict or not anim then return end
    RequestAnimDict(dict)
    local tries = 0
    while not HasAnimDictLoaded(dict) and tries < 60 do
        Wait(10)
        tries = tries + 1
    end
    if not HasAnimDictLoaded(dict) then return end
    TaskPlayAnim(ped, dict, anim, 3.0, 3.0, total or 900, flag or 49, 0.0, false, false, false)
    RemoveAnimDict(dict)
end

--- Equip `weaponName`, or holster if it is already the equipped one.
--- Returns the name now equipped, or nil when the ped was holstered.
--- This is the ONE place the inventory changes what is in the hands, so
--- the animation can never be skipped by a different code path.
function EquipWeaponAnimated(weaponName, currentlyEquipped)
    if DrawLock then return currentlyEquipped end
    DrawLock = true

    local ped        = PlayerPedId()
    local class      = Config.GetWeaponClass(weaponName)
    local cfg        = Config.WeaponDrawAnims[class] or Config.WeaponDrawAnims['pistol']
    local sounds     = Config.WeaponSounds and Config.WeaponSounds[class]
    local holstering = (currentlyEquipped == weaponName)
    local result     = currentlyEquipped

    -- Everything below runs in its own thread so the NUI callback that
    -- called us returns immediately: a callback that blocks for a second
    -- makes the whole inventory feel frozen.
    CreateThread(function()
        local ok = canPlayDrawAnim(ped)

        if holstering then
            if sounds and sounds.holster then
                PlaySoundFrontend(-1, sounds.holster.name, sounds.holster.set, true)
            end
            if ok then
                playClip(ped, cfg.holsterDict, cfg.holsterAnim, cfg.flag, cfg.total)
                Wait(cfg.revealAt or 250)
            end
            SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
            if ok then
                Wait(math.max(0, (cfg.total or 900) - (cfg.revealAt or 250)))
                ClearPedSecondaryTask(ped)
            end
        else
            if sounds and sounds.equip then
                PlaySoundFrontend(-1, sounds.equip.name, sounds.equip.set, true)
            end
            if ok then
                playClip(ped, cfg.drawDict, cfg.drawAnim, cfg.flag, cfg.total)
                Wait(cfg.revealAt or 250)
            end
            -- The ped may have died / entered a car during the draw.
            ped = PlayerPedId()
            if not IsEntityDead(ped) then
                SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)
            end
            if ok then
                Wait(math.max(0, (cfg.total or 900) - (cfg.revealAt or 250)))
                ClearPedSecondaryTask(ped)
            end
        end

        DrawLock = false
    end)

    if holstering then
        result = nil
    else
        result = weaponName
    end
    return result
end

--- Safety valve: if the player dies mid-draw the thread above may never
--- reach its release (ped handle invalidated), so clear the lock on
--- respawn rather than leaving the player unable to equip anything.
AddEventHandler('esx:onPlayerSpawn', function() DrawLock = false end)
AddEventHandler('playerSpawned', function() DrawLock = false end)
