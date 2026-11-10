-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local hWeapon = { -- shake camera
    [`WEAPON_STUNGUN`] = 0.01,
    [`WEAPON_FLAREGUN`] = 0.01,
    [`WEAPON_VINTAGEPISTOL`] = 0.036,
    [`WEAPON_PISTOL`] = 0.034,
    [`WEAPON_SNSPISTOL`] = 0.032,
    [`WEAPON_HEAVYPISTOL`] = 0.040,
    [`WEAPON_COMBATPISTOL`] = 0.035,
    [`WEAPON_PISTOL50`] = 0.044,
    [`WEAPON_MARKSMANPISTOL`] = 0.048,
    [`WEAPON_NAVYREVOLVER`] = 0.046,
    [`WEAPON_PISTOLXM3`] = 0.034,
    [`WEAPON_REVOLVER`] = 0.046,
    [`WEAPON_REVOLVER_MK2`] = 0.048,
    [`WEAPON_SNSPISTOL_MK2`] = 0.034,
    [`WEAPON_PISTOL_MK2`] = 0.036,
    [`WEAPON_DOUBLEACTION`] = 0.042,
    [`WEAPON_APPISTOL`] = 0.030,
    [`WEAPON_GADGETPISTOL`] = 0.048,
    [`WEAPON_CERAMICPISTOL`] = 0.038,
    [`WEAPON_COMPACTRIFLE`] = 0.036,
    [`WEAPON_BULLPUPRIFLE`] = 0.032,
    [`WEAPON_BULLPUPRIFLE_MK2`] = 0.034,
    [`WEAPON_CARBINERIFLE`] = 0.034,
    [`WEAPON_CARBINERIFLE_MK2`] = 0.036,
    [`WEAPON_ASSAULTRIFLE`] = 0.035,
    [`WEAPON_ASSAULTRIFLE_MK2`] = 0.037,
    [`WEAPON_ADVANCEDRIFLE`] = 0.033,
    [`WEAPON_SPECIALCARBINE`] = 0.034,
    [`WEAPON_SPECIALCARBINE_MK2`] = 0.036,
    [`WEAPON_MILITARYRIFLE`] = 0.035,
    [`WEAPON_TACTICALRIFLE`] = 0.034,
    [`WEAPON_HEAVYRIFLE`] = 0.036,
    [`WEAPON_DBSHOTGUN`] = 0.055,
    [`WEAPON_AUTOSHOTGUN`] = 0.048,
    [`WEAPON_PUMPSHOTGUN`] = 0.055,
    [`WEAPON_PUMPSHOTGUN_MK2`] = 0.058,
    [`WEAPON_ASSAULTSHOTGUN`] = 0.050,
    [`WEAPON_BULLPUPSHOTGUN`] = 0.052,
    [`WEAPON_SAWNOFFSHOTGUN`] = 0.058,
    [`WEAPON_COMBATSHOTGUN`] = 0.052,
    [`WEAPON_HEAVYSHOTGUN`] = 0.046,
    [`WEAPON_MUSKET`] = 0.060,
    [`WEAPON_MICROSMG`] = 0.028,
    [`WEAPON_MACHINEPISTOL`] = 0.030,
    [`WEAPON_MINISMG`] = 0.029,
    [`WEAPON_TECPISTOL`] = 0.029,
    [`WEAPON_SMG`] = 0.030,
    [`WEAPON_SMG_MK2`] = 0.032,
    [`WEAPON_ASSAULTSMG`] = 0.031,
    [`WEAPON_COMBATPDW`] = 0.033,
    [`WEAPON_GUSENBERG`] = 0.031,
    [`WEAPON_MG`] = 0.048,
    [`WEAPON_COMBATMG`] = 0.044,
    [`WEAPON_COMBATMG_MK2`] = 0.046,
    [`WEAPON_SNIPERRIFLE`] = 0.12,
    [`WEAPON_HEAVYSNIPER`] = 0.18,
    [`WEAPON_HEAVYSNIPER_MK2`] = 0.20,
    [`WEAPON_MARKSMANRIFLE`] = 0.06,
    [`WEAPON_MARKSMANRIFLE_MK2`] = 0.07,
    [`WEAPON_GRENADELAUNCHER`] = 0.08,
    [`WEAPON_HOMINGLAUNCHER`] = 0.50,
    [`WEAPON_MINIGUN`] = 0.035,
    [`WEAPON_RAILGUN`] = 0.60,
    [`WEAPON_COMPACTLAUNCHER`] = 0.08,
    [`WEAPON_FIREWORK`] = 0.30,
    [`WEAPON_HKUSP_CHR`] = 0.030,
    [`WEAPON_M27_CHR`] = 0.030,
    [`WEAPON_BERYL_762_CHR`] = 0.035,
    [`WEAPON_XM7_CHR`] = 0.035,
    [`WEAPON_BULLPUP_SMG_CHR`] = 0.034,
    [`WEAPON_FAMAS_CHR`] = 0.034,
    [`WEAPON_HK2002M_CHR`] = 0.034,
    [`WEAPON_L85_CHR`] = 0.034,
    [`WEAPON_VX_47_CHR`] = 0.034,
    [`WEAPON_GAU_5A_CHR`] = 0.034,
    [`WEAPON_HOWA_T20_CHR`] = 0.034,
    [`WEAPON_M16A1_CHR`] = 0.034,
    [`WEAPON_MK_PRISS_CHR`] = 0.034,
    [`WEAPON_MLTM4R_CHR`] = 0.034,
    [`WEAPON_MODULAR_RIFLE_CHR`] = 0.034,
    [`WEAPON_NVRIFLE_CHR`] = 0.034,
    [`WEAPON_R90_CHR`] = 0.034,
    [`WEAPON_M4_ARCW_CHR`] = 0.034,
    [`WEAPON_AK_47_CHR`] = 0.036,
    [`WEAPON_AR_15_CHR`] = 0.036,
    [`WEAPON_BZ_199_CHR`] = 0.036,
    [`WEAPON_HX_15_CHR`] = 0.036,
    [`WEAPON_SR_3M_CHR`] = 0.028,
    [`WEAPON_TACTICAL_VECTOR_CHR`] = 0.033,
    [`WEAPON_COMBATHP_CHR`] = 0.035,
    [`WEAPON_H05117_P_CHR`] = 0.035,
    [`WEAPON_DKS_101_CHR`] = 0.18,
    [`WEAPON_M270D_CHR`] = 0.030,
    [`WEAPON_DMRSNIPER_CHR`] = 0.07,
    [`WEAPON_MP5_CHR`] = 0.028,
    [`WEAPON_SPX_7_CHR`] = 0.028,
    [`WEAPON_VECOTR_CHR`] = 0.028,
    [`WEAPON_ZETA_19_CHR`] = 0.034,
    [`WEAPON_HM_PISTOL_CHR`] = 0.036,
    [`WEAPON_LSR_PISTOL_CHR`] = 0.036,
    [`WEAPON_SYS_PISTOL_CHR`] = 0.036,
    [`WEAPON_DESERT_EAGLE_CHR`] = 0.044,
    [`WEAPON_MPH_21_SG_CHR`] = 0.055,
    [`WEAPON_SPS_21_SG_CHR`] = 0.055,
    [`WEAPON_UMP_CHR`] = 0.030,
    [`WEAPON_VX_SCORPION_CHR`] = 0.032,
    [`WEAPON_SB_SD_CHR`] = 0.032,
    [`WEAPON_VERESK_CHR`] = 0.032,
}

local disableFire = {
    [`WEAPON_SNIPERRIFLE`] = true,
    [`WEAPON_HEAVYSNIPER_MK2`] = true,
    [`WEAPON_MINIGUN`] = true,
    [`WEAPON_RPG`] = true
}

local disableFireThread = false
local thread = false
local inPaintballFire = false

AddEventHandler('inPaintball', function(state)
    inPaintballFire = state and true or false
    if inPaintballFire then disableFireThread = false end
end)

local recoilDefaults = {
    baseRecoil = 0.5,
    baseVerticalRecoil = 0.15,
}

local recoilConfig = {
    [`WEAPON_VINTAGEPISTOL`] = { baseRecoil = 0.34, baseVerticalRecoil = 0.13 },
    [`WEAPON_PISTOL`] = { baseRecoil = 0.32, baseVerticalRecoil = 0.12 },
    [`WEAPON_SNSPISTOL`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.11 },
    [`WEAPON_HEAVYPISTOL`] = { baseRecoil = 0.38, baseVerticalRecoil = 0.14 },
    [`WEAPON_COMBATPISTOL`] = { baseRecoil = 0.33, baseVerticalRecoil = 0.12 },
    [`WEAPON_PISTOL50`] = { baseRecoil = 0.40, baseVerticalRecoil = 0.16 },
    [`WEAPON_MARKSMANPISTOL`] = { baseRecoil = 0.42, baseVerticalRecoil = 0.18 },
    [`WEAPON_NAVYREVOLVER`] = { baseRecoil = 0.42, baseVerticalRecoil = 0.17 },
    [`WEAPON_PISTOLXM3`] = { baseRecoil = 0.32, baseVerticalRecoil = 0.12 },
    [`WEAPON_REVOLVER`] = { baseRecoil = 0.42, baseVerticalRecoil = 0.17 },
    [`WEAPON_REVOLVER_MK2`] = { baseRecoil = 0.44, baseVerticalRecoil = 0.18 },
    [`WEAPON_SNSPISTOL_MK2`] = { baseRecoil = 0.32, baseVerticalRecoil = 0.12 },
    [`WEAPON_PISTOL_MK2`] = { baseRecoil = 0.34, baseVerticalRecoil = 0.13 },
    [`WEAPON_DOUBLEACTION`] = { baseRecoil = 0.38, baseVerticalRecoil = 0.15 },
    [`WEAPON_APPISTOL`] = { baseRecoil = 0.28, baseVerticalRecoil = 0.10 },
    [`WEAPON_GADGETPISTOL`] = { baseRecoil = 0.42, baseVerticalRecoil = 0.18 },
    [`WEAPON_CERAMICPISTOL`] = { baseRecoil = 0.36, baseVerticalRecoil = 0.14 },
    [`WEAPON_STUNGUN`] = { baseRecoil = 0.10, baseVerticalRecoil = 0.05 },
    [`WEAPON_FLAREGUN`] = { baseRecoil = 0.40, baseVerticalRecoil = 0.18 },
    [`WEAPON_COMPACTRIFLE`] = { baseRecoil = 0.34, baseVerticalRecoil = 0.11 },
    [`WEAPON_BULLPUPRIFLE`] = { baseRecoil = 0.28, baseVerticalRecoil = 0.09 },
    [`WEAPON_BULLPUPRIFLE_MK2`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_CARBINERIFLE`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_CARBINERIFLE_MK2`] = { baseRecoil = 0.34, baseVerticalRecoil = 0.11 },
    [`WEAPON_ASSAULTRIFLE`] = { baseRecoil = 0.32, baseVerticalRecoil = 0.10 },
    [`WEAPON_ASSAULTRIFLE_MK2`] = { baseRecoil = 0.35, baseVerticalRecoil = 0.11 },
    [`WEAPON_ADVANCEDRIFLE`] = { baseRecoil = 0.29, baseVerticalRecoil = 0.09 },
    [`WEAPON_SPECIALCARBINE`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_SPECIALCARBINE_MK2`] = { baseRecoil = 0.34, baseVerticalRecoil = 0.11 },
    [`WEAPON_MILITARYRIFLE`] = { baseRecoil = 0.32, baseVerticalRecoil = 0.10 },
    [`WEAPON_TACTICALRIFLE`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_HEAVYRIFLE`] = { baseRecoil = 0.34, baseVerticalRecoil = 0.11 },
    [`WEAPON_DBSHOTGUN`] = { baseRecoil = 0.50, baseVerticalRecoil = 0.28 },
    [`WEAPON_AUTOSHOTGUN`] = { baseRecoil = 0.44, baseVerticalRecoil = 0.20 },
    [`WEAPON_PUMPSHOTGUN`] = { baseRecoil = 0.50, baseVerticalRecoil = 0.26 },
    [`WEAPON_PUMPSHOTGUN_MK2`] = { baseRecoil = 0.52, baseVerticalRecoil = 0.28 },
    [`WEAPON_ASSAULTSHOTGUN`] = { baseRecoil = 0.46, baseVerticalRecoil = 0.22 },
    [`WEAPON_BULLPUPSHOTGUN`] = { baseRecoil = 0.48, baseVerticalRecoil = 0.24 },
    [`WEAPON_SAWNOFFSHOTGUN`] = { baseRecoil = 0.52, baseVerticalRecoil = 0.30 },
    [`WEAPON_COMBATSHOTGUN`] = { baseRecoil = 0.48, baseVerticalRecoil = 0.24 },
    [`WEAPON_HEAVYSHOTGUN`] = { baseRecoil = 0.42, baseVerticalRecoil = 0.18 },
    [`WEAPON_MUSKET`] = { baseRecoil = 0.55, baseVerticalRecoil = 0.32 },
    [`WEAPON_MICROSMG`] = { baseRecoil = 0.25, baseVerticalRecoil = 0.08 },
    [`WEAPON_MACHINEPISTOL`] = { baseRecoil = 0.27, baseVerticalRecoil = 0.09 },
    [`WEAPON_MINISMG`] = { baseRecoil = 0.26, baseVerticalRecoil = 0.09 },
    [`WEAPON_TECPISTOL`] = { baseRecoil = 0.26, baseVerticalRecoil = 0.08 },
    [`WEAPON_SMG`] = { baseRecoil = 0.27, baseVerticalRecoil = 0.09 },
    [`WEAPON_SMG_MK2`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_ASSAULTSMG`] = { baseRecoil = 0.28, baseVerticalRecoil = 0.09 },
    [`WEAPON_COMBATPDW`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_GUSENBERG`] = { baseRecoil = 0.28, baseVerticalRecoil = 0.09 },
    [`WEAPON_MG`] = { baseRecoil = 0.45, baseVerticalRecoil = 0.18 },
    [`WEAPON_COMBATMG`] = { baseRecoil = 0.42, baseVerticalRecoil = 0.16 },
    [`WEAPON_COMBATMG_MK2`] = { baseRecoil = 0.44, baseVerticalRecoil = 0.17 },
    [`WEAPON_SNIPERRIFLE`] = { baseRecoil = 0.40, baseVerticalRecoil = 0.25 },
    [`WEAPON_HEAVYSNIPER`] = { baseRecoil = 0.50, baseVerticalRecoil = 0.30 },
    [`WEAPON_HEAVYSNIPER_MK2`] = { baseRecoil = 0.52, baseVerticalRecoil = 0.32 },
    [`WEAPON_MARKSMANRIFLE`] = { baseRecoil = 0.28, baseVerticalRecoil = 0.16 },
    [`WEAPON_MARKSMANRIFLE_MK2`] = { baseRecoil = 0.32, baseVerticalRecoil = 0.18 },
    [`WEAPON_REMOTESNIPER`] = { baseRecoil = 0.60, baseVerticalRecoil = 0.35 },
    [`WEAPON_GRENADELAUNCHER`] = { baseRecoil = 0.50, baseVerticalRecoil = 0.25 },
    [`WEAPON_GRENADELAUNCHER_SMOKE`] = { baseRecoil = 0.50, baseVerticalRecoil = 0.25 },
    [`WEAPON_STINGER`] = { baseRecoil = 0.00, baseVerticalRecoil = 0.00 },
    [`WEAPON_HOMINGLAUNCHER`] = { baseRecoil = 0.00, baseVerticalRecoil = 0.00 },
    [`WEAPON_MINIGUN`] = { baseRecoil = 0.20, baseVerticalRecoil = 0.08 },
    [`WEAPON_RAILGUN`] = { baseRecoil = 0.70, baseVerticalRecoil = 0.40 },
    [`WEAPON_COMPACTLAUNCHER`] = { baseRecoil = 0.45, baseVerticalRecoil = 0.22 },
    [`WEAPON_HKUSP_CHR`] = { baseRecoil = 0.28, baseVerticalRecoil = 0.10 },
    [`WEAPON_M27_CHR`] = { baseRecoil = 0.28, baseVerticalRecoil = 0.10 },
    [`WEAPON_BERYL_762_CHR`] = { baseRecoil = 0.32, baseVerticalRecoil = 0.10 },
    [`WEAPON_XM7_CHR`] = { baseRecoil = 0.32, baseVerticalRecoil = 0.10 },
    [`WEAPON_BULLPUP_SMG_CHR`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_FAMAS_CHR`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_HK2002M_CHR`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_L85_CHR`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_VX_47_CHR`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_GAU_5A_CHR`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_HOWA_T20_CHR`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_M16A1_CHR`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_MK_PRISS_CHR`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_MLTM4R_CHR`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_MODULAR_RIFLE_CHR`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_NVRIFLE_CHR`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_R90_CHR`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_M4_ARCW_CHR`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_AK_47_CHR`] = { baseRecoil = 0.34, baseVerticalRecoil = 0.11 },
    [`WEAPON_AR_15_CHR`] = { baseRecoil = 0.34, baseVerticalRecoil = 0.11 },
    [`WEAPON_BZ_199_CHR`] = { baseRecoil = 0.34, baseVerticalRecoil = 0.11 },
    [`WEAPON_HX_15_CHR`] = { baseRecoil = 0.34, baseVerticalRecoil = 0.11 },
    [`WEAPON_SR_3M_CHR`] = { baseRecoil = 0.25, baseVerticalRecoil = 0.08 },
    [`WEAPON_TACTICAL_VECTOR_CHR`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_COMBATHP_CHR`] = { baseRecoil = 0.33, baseVerticalRecoil = 0.12 },
    [`WEAPON_H05117_P_CHR`] = { baseRecoil = 0.33, baseVerticalRecoil = 0.12 },
    [`WEAPON_DKS_101_CHR`] = { baseRecoil = 0.50, baseVerticalRecoil = 0.30 },
    [`WEAPON_M270D_CHR`] = { baseRecoil = 0.27, baseVerticalRecoil = 0.09 },
    [`WEAPON_DMRSNIPER_CHR`] = { baseRecoil = 0.32, baseVerticalRecoil = 0.18 },
    [`WEAPON_MP5_CHR`] = { baseRecoil = 0.25, baseVerticalRecoil = 0.08 },
    [`WEAPON_SPX_7_CHR`] = { baseRecoil = 0.25, baseVerticalRecoil = 0.08 },
    [`WEAPON_VECOTR_CHR`] = { baseRecoil = 0.25, baseVerticalRecoil = 0.08 },
    [`WEAPON_ZETA_19_CHR`] = { baseRecoil = 0.32, baseVerticalRecoil = 0.12 },
    [`WEAPON_HM_PISTOL_CHR`] = { baseRecoil = 0.34, baseVerticalRecoil = 0.13 },
    [`WEAPON_LSR_PISTOL_CHR`] = { baseRecoil = 0.34, baseVerticalRecoil = 0.13 },
    [`WEAPON_SYS_PISTOL_CHR`] = { baseRecoil = 0.34, baseVerticalRecoil = 0.13 },
    [`WEAPON_DESERT_EAGLE_CHR`] = { baseRecoil = 0.40, baseVerticalRecoil = 0.16 },
    [`WEAPON_MPH_21_SG_CHR`] = { baseRecoil = 0.50, baseVerticalRecoil = 0.26 },
    [`WEAPON_SPS_21_SG_CHR`] = { baseRecoil = 0.50, baseVerticalRecoil = 0.26 },
    [`WEAPON_UMP_CHR`] = { baseRecoil = 0.27, baseVerticalRecoil = 0.09 },
    [`WEAPON_VX_SCORPION_CHR`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_SB_SD_CHR`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
    [`WEAPON_VERESK_CHR`] = { baseRecoil = 0.30, baseVerticalRecoil = 0.10 },
}

local function getRecoilConfig(weapon)
    local config = recoilConfig[weapon]
    if config then
        return config
    end
    return recoilDefaults
end

Citizen.CreateThread(function()
    math.randomseed(GetGameTimer())
    waitForLoad()
    startRecoilThread()
end)

function ManageReticle(weapon)
    if not recoilConfig[weapon] then
        ShowHudComponentThisFrame(0)
    end
end

function startRecoilThread()
    AddEventHandler('onSelectWeapon', function(armed, model)
        if armed then
            local shouldBlock = disableFire[model] and not inPaintballFire
            if not disableFireThread then
                if shouldBlock then
                    disableFireThread = true
                    CreateThread(function()
                        while disableFireThread do
                            Wait(0)
                            disableFiring()
                        end
                    end)
                end
            elseif not shouldBlock then
                disableFireThread = false
            end
            if not thread then
                thread = true
                local scopeMode = false
                local hasScope = false
                local inVehicle = false
                local isFirstPerson = false
                local cachedConfig = recoilDefaults
                local lastWeapon = nil
                local scopeTypes = {'scope', 'small_scope', 'medium_scope', 'large_scope', 'zoom_scope', 'advanced_scope', 'nv_scope', 'mounted_scope'}
                Citizen.CreateThread(function()
                    local lastFov = GetGameplayCamFov()
                    while thread do
                        Wait(0)
                        local ped = SUN.ped
                        local weapon = SUN.CurrentWeaponModel
                        local currentFov = GetGameplayCamFov()
                        if SUN.vehicleClass ~= 15 then
                            if SUN.isArmed and SUN.isAiming and isFirstPerson then
                                scopeMode = hasScope
                            else
                                scopeMode = false
                            end
                            if SUN.isArmed then
                                DisableControlAction(1, 140, true)
                                DisableControlAction(1, 141, true)
                                DisableControlAction(1, 142, true)
                            end
                            DisplayAmmoThisFrame(true)
                            if IsPedShooting(ped) then
                                if hWeapon[weapon] then
                                    local shakeValue = hWeapon[weapon]
                                    if scopeMode then shakeValue = shakeValue * 0.3 end
                                    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', shakeValue)
                                end
                                if not isFirstPerson and cachedConfig.baseRecoil ~= 0 then
                                    local p = GetGameplayCamRelativePitch()
                                    local verticalRecoil = -cachedConfig.baseVerticalRecoil + (math.random(-1000, 200) / 1000)
                                    if inVehicle then verticalRecoil = -verticalRecoil end
                                    SetGameplayCamRelativePitch(p + verticalRecoil, 0.2)
                                    local h = GetGameplayCamRelativeHeading()
                                    local recoilValue = math.floor(cachedConfig.baseRecoil * 1000)
                                    local horizontalRecoil = math.random(-recoilValue, recoilValue) / 1000
                                    if not (math.abs(currentFov - lastFov) > 0.1) then
                                        SetGameplayCamRelativeHeading(h + horizontalRecoil)
                                    end
                                    lastFov = currentFov
                                end
                            end
                        else
                            Wait(2000)
                        end
                    end
                end)
                Citizen.CreateThread(function()
                    while thread do
                        Wait(250)
                        local ped = SUN.ped
                        local weapon = SUN.CurrentWeaponModel
                        inVehicle = IsPedInAnyVehicle(ped, false)
                        isFirstPerson = GetFollowPedCamViewMode() == 4
                        if weapon ~= lastWeapon then
                            lastWeapon = weapon
                            hasScope = false
                            cachedConfig = getRecoilConfig(weapon)
                            if weapon then
                                local weaponName = ESX.GetWeaponName(weapon)
                                if weaponName then
                                    for _, scopeType in ipairs(scopeTypes) do
                                        local comp = ESX.GetWeaponComponent(weaponName, scopeType)
                                        if comp and HasPedGotWeaponComponent(ped, weapon, comp.hash) then
                                            hasScope = true
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        elseif thread then
            thread = false
            disableFireThread = false
        end
    end)
end