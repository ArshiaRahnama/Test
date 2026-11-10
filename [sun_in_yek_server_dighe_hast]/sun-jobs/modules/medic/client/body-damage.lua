-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

--config
local scale = '1.0'
local pos_x = '65%'
local pos_y = '25%'
local command_nui = 'health'
local command_nui_dist_ped = 'diagnosis'
local disable_closed_nui_mouse_right = true
local max_health = 200

local OpenClose_nui_automatically = false
local notify_attacker = false

local text_death_shots = 'زخمی شده با سلاح گرم'
local text_death_cuts = 'زخمی شده با سلاح سرد'
local text_death_punch = 'لت و پار شده'
local text_dead = '[وضعیت وخیم]'

local texts_nui = {
    "وضعیت",
    "جراحات : ",
    "گلوله ها : ",
    "زخم ها : ",
    "کبودی ها : ",
    "دلیل",
}

local reasons_death = {
    { death = -1553120962, reason = "زیر گرشته شده" },
    { death = 133987706, reason = "زیر گرشته شده" },
    { death = -100946242, reason = "گاز گرفته شده توسط حیوان" },
    { death = 148160082, reason = "گاز گرفته شده توسط حیوان" },
    { death = -842959696, reason = "سقوط از ارتفاع" },
    { death = -1169823560, reason = "انفجار", all_bruises = true },
    { death = -1420407917, reason = "انفجار", all_bruises = true },
    { death = -1568386805, reason = "انفجار", all_bruises = true },
    { death = 1305664598, reason = "انفجار", all_bruises = true },
    { death = -1312131151, reason = "انفجار", all_bruises = true },
    { death = 375527679, reason = "انفجار", all_bruises = true },
    { death = 324506233, reason = "انفجار", all_bruises = true },
    { death = 1752584910, reason = "انفجار", all_bruises = true },
    { death = -1813897027, reason = "انفجار", all_bruises = true },
    { death = 741814745, reason = "انفجار", all_bruises = true },
    { death = -37975472, reason = "انفجار", all_bruises = true },
    { death = 539292904, reason = "انفجار", all_bruises = true },
    { death = 341774354, reason = "انفجار", all_bruises = true },
    { death = -1090665087, reason = "انفجار", all_bruises = true },
    { death = 615608432, reason = "سوختگی", all_bruises = true },
    { death = 883325847, reason = "سوختگی", all_bruises = true },
    { death = -544306709, reason = "سوختگی", all_bruises = true },
    { death = -10959621, reason = "غرق شده" },
    { death = 1936677264, reason = "غرق شده" },
}
--
local opened = false
local cause_death = ''
local punch = 0
local shots = 0
local cuts = 0
local bruises = 0

local body = {
    ['2e28'] = {body = "Pelvis", bruised = false, shots = false, cuts = false, punch = false},  
    ['e39f'] = {body = "L_Thigh", bruised = false, shots = false, cuts = false, punch = false},  
    ['f9bb'] = {body = "L_Calf", bruised = false, shots = false, cuts = false, punch = false},  
    ['3779'] = {body = "L_Foot", bruised = false, shots = false, cuts = false, punch = false},  
    ['fedd'] = {body = "L_Foot", bruised = false, shots = false, cuts = false, punch = false},  
    ['e175'] = {body = "L_Foot", bruised = false, shots = false, cuts = false, punch = false},  
    ['b3fe'] = {body = "L_Knee", bruised = false, shots = false, cuts = false, punch = false},  
    ['ca72'] = {body = "R_Thigh", bruised = false, shots = false, cuts = false, punch = false},  
    ['9000'] = {body = "R_Calf", bruised = false, shots = false, cuts = false, punch = false},  
    ['cc4d'] = {body = "R_Foot", bruised = false, shots = false, cuts = false, punch = false},  
    ['8aae'] = {body = "R_Foot", bruised = false, shots = false, cuts = false, punch = false},  
    ['60e6'] = {body = "R_Foot", bruised = false, shots = false, cuts = false, punch = false},  
    ['3fcf'] = {body = "R_Knee", bruised = false, shots = false, cuts = false, punch = false},  
    ['5c57'] = {body = "L_ThighRoll", bruised = false, shots = false, cuts = false, punch = false},  
    ['192a'] = {body = "R_ThighRoll", bruised = false, shots = false, cuts = false, punch = false},  
    ['e0fd'] = {body = "Spine_Root", bruised = false, shots = false, cuts = false, punch = false},  
    ['5c01'] = {body = "Spine0", bruised = false, shots = false, cuts = false, punch = false},  
    ['60f0'] = {body = "Spine1", bruised = false, shots = false, cuts = false, punch = false},  
    ['60f1'] = {body = "Spine2", bruised = false, shots = false, cuts = false, punch = false},  
    ['60f2'] = {body = "Spine3", bruised = false, shots = false, cuts = false, punch = false},  
    ['fcd9'] = {body = "L_Clavicle", bruised = false, shots = false, cuts = false, punch = false},  
    ['b1c5'] = {body = "L_UpperArm", bruised = false, shots = false, cuts = false, punch = false},  
    ['eeeb'] = {body = "L_Forearm", bruised = false, shots = false, cuts = false, punch = false},  
    ['49d9'] = {body = "L_Hand", bruised = false, shots = false, cuts = false, punch = false},  
    ['67f2'] = {body = "L_Finger00", bruised = false, shots = false, cuts = false, punch = false},  
    ['ff9'] = {body = "L_Finger01", bruised = false, shots = false, cuts = false, punch = false},  
    ['ffa'] = {body = "L_Finger02", bruised = false, shots = false, cuts = false, punch = false},  
    ['67f3'] = {body = "L_Finger10", bruised = false, shots = false, cuts = false, punch = false},  
    ['1049'] = {body = "L_Finger11", bruised = false, shots = false, cuts = false, punch = false},  
    ['104a'] = {body = "L_Finger12", bruised = false, shots = false, cuts = false, punch = false},  
    ['67f4'] = {body = "L_Finger20", bruised = false, shots = false, cuts = false, punch = false},  
    ['1059'] = {body = "L_Finger21", bruised = false, shots = false, cuts = false, punch = false},  
    ['105a'] = {body = "L_Finger22", bruised = false, shots = false, cuts = false, punch = false},  
    ['67f5'] = {body = "L_Finger30", bruised = false, shots = false, cuts = false, punch = false},  
    ['1029'] = {body = "L_Finger31", bruised = false, shots = false, cuts = false, punch = false},  
    ['102a'] = {body = "L_Finger32", bruised = false, shots = false, cuts = false, punch = false},  
    ['67f6'] = {body = "L_Finger40", bruised = false, shots = false, cuts = false, punch = false},  
    ['1039'] = {body = "L_Finger41", bruised = false, shots = false, cuts = false, punch = false},  
    ['103a'] = {body = "L_Finger42", bruised = false, shots = false, cuts = false, punch = false},  
    ['eb95'] = {body = "L_Hand", bruised = false, shots = false, cuts = false, punch = false},  
    ['8cbd'] = {body = "L_Hand", bruised = false, shots = false, cuts = false, punch = false},  
    ['ee4f'] = {body = "L_ForeArmRoll", bruised = false, shots = false, cuts = false, punch = false},  
    ['1470'] = {body = "L_ArmRoll", bruised = false, shots = false, cuts = false, punch = false},  
    ['58b7'] = {body = "L_Elbow", bruised = false, shots = false, cuts = false, punch = false},  
    ['29d2'] = {body = "R_Clavicle", bruised = false, shots = false, cuts = false, punch = false},  
    ['9d4d'] = {body = "R_UpperArm", bruised = false, shots = false, cuts = false, punch = false},  
    ['6e5c'] = {body = "R_Forearm", bruised = false, shots = false, cuts = false, punch = false},  
    ['dead'] = {body = "R_Hand", bruised = false, shots = false, cuts = false, punch = false},  
    ['e5f2'] = {body = "R_Finger00", bruised = false, shots = false, cuts = false, punch = false},  
    ['fa10'] = {body = "R_Finger01", bruised = false, shots = false, cuts = false, punch = false},  
    ['fa11'] = {body = "R_Finger02", bruised = false, shots = false, cuts = false, punch = false},  
    ['e5f3'] = {body = "R_Finger10", bruised = false, shots = false, cuts = false, punch = false},  
    ['fa60'] = {body = "R_Finger11", bruised = false, shots = false, cuts = false, punch = false},  
    ['fa61'] = {body = "R_Finger12", bruised = false, shots = false, cuts = false, punch = false},  
    ['e5f4'] = {body = "R_Finger20", bruised = false, shots = false, cuts = false, punch = false},  
    ['fa70'] = {body = "R_Finger21", bruised = false, shots = false, cuts = false, punch = false},  
    ['fa71'] = {body = "R_Finger22", bruised = false, shots = false, cuts = false, punch = false},  
    ['e5f5'] = {body = "R_Finger30", bruised = false, shots = false, cuts = false, punch = false},  
    ['fa40'] = {body = "R_Finger31", bruised = false, shots = false, cuts = false, punch = false},  
    ['fa41'] = {body = "R_Finger32", bruised = false, shots = false, cuts = false, punch = false},  
    ['e5f6'] = {body = "R_Finger40", bruised = false, shots = false, cuts = false, punch = false},  
    ['fa50'] = {body = "R_Finger41", bruised = false, shots = false, cuts = false, punch = false},  
    ['fa51'] = {body = "R_Finger42", bruised = false, shots = false, cuts = false, punch = false},  
    ['6f06'] = {body = "R_Hand", bruised = false, shots = false, cuts = false, punch = false},  
    ['188e'] = {body = "R_Hand", bruised = false, shots = false, cuts = false, punch = false},  
    ['ab22'] = {body = "R_ForeArmRoll", bruised = false, shots = false, cuts = false, punch = false},  
    ['90ff'] = {body = "R_ArmRoll", bruised = false, shots = false, cuts = false, punch = false},  
    ['bb0'] = {body = "R_Elbow", bruised = false, shots = false, cuts = false, punch = false},  
    ['9995'] = {body = "Neck_1", bruised = false, shots = false, cuts = false, punch = false},  
    ['796e'] = {body = "Head", bruised = false, shots = false, cuts = false, punch = false},  
    ['322c'] = {body = "Head", bruised = false, shots = false, cuts = false, punch = false},  
    ['fe2c'] = {body = "FACIAL_facialRoot", bruised = false, shots = false, cuts = false, punch = false},  
    ['e3db'] =  {body = "FB_L_Brow_Out_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['b2b6'] = {body = "FB_L_Lid_Upper_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['62ac'] = {body = "FB_L_Eye_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['542e'] = {body = "FB_L_CheekBone_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['74ac'] = {body = "FB_L_Lip_Corner_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['aa10'] = {body = "FB_R_Lid_Upper_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['6b52'] = {body = "FB_R_Eye_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['4b88'] = {body = "FB_R_CheekBone_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['54c'] = {body = "FB_R_Brow_Out_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['2ba6'] = {body = "FB_R_Lip_Corner_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['9149'] = {body = "FB_Brow_Centre_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['4ed2'] = {body = "FB_UpperLipRoot_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['f18f'] = {body = "FB_UpperLip_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['4f37'] = {body = "FB_L_Lip_Top_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['4537'] = {body = "FB_R_Lip_Top_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['b4a0'] = {body = "FB_Jaw_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['4324'] = {body = "FB_LowerLipRoot_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['508f'] = {body = "FB_LowerLip_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['b93b'] = {body = "FB_L_Lip_Bot_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['c33b'] = {body = "FB_R_Lip_Bot_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['b987'] = {body = "FB_Tongue_000", bruised = false, shots = false, cuts = false, punch = false},  
    ['8b93'] = {body = "Neck_1", bruised = false, shots = false, cuts = false, punch = false}, 
}

local weapon_list = {
    { name = "weapon_unarmed"},
    { name = "weapon_knuckle"},

    { name = "weapon_dagger"},
    { name = "weapon_bat"},
    { name = "weapon_bottle"},
    { name = "weapon_crowbar"},
    { name = "weapon_flashlight"},
    { name = "weapon_golfclub"},
    { name = "weapon_hammer"},
    { name = "weapon_hatchet"},
    { name = "weapon_knife"},
    { name = "weapon_machete"},
    { name = "weapon_switchblade"},
    { name = "weapon_nightstick"},
    { name = "weapon_wrench"},
    { name = "weapon_battleaxe"},
    { name = "weapon_poolcue"},
    { name = "weapon_stone_hatchet"},

    { name = "weapon_pistol"},
    { name = "weapon_pistol_mk2"},
    { name = "weapon_combatpistol"},
    { name = "weapon_appistol"},
    { name = "weapon_stungun"},
    { name = "weapon_pistol50"},
    { name = "weapon_snspistol"},
    { name = "weapon_snspistol_mk2"},
    { name = "weapon_heavypistol"},
    { name = "weapon_vintagepistol"},
    { name = "weapon_flaregun"},
    { name = "weapon_marksmanpistol"},
    { name = "weapon_revolver"},
    { name = "weapon_revolver_mk2"},
    { name = "weapon_doubleaction"},
    { name = "weapon_raypistol"},
    { name = "weapon_ceramicpistol"},
    { name = "weapon_navyrevolver"},

    { name = "weapon_microsmg"},
    { name = "weapon_smg"},
    { name = "weapon_smg_mk2"},
    { name = "weapon_assaultsmg"},
    { name = "weapon_combatpdw"},
    { name = "weapon_machinepistol"},
    { name = "weapon_minismg"},
    { name = "weapon_raycarbine"},

    { name = "weapon_pumpshotgun"},
    { name = "weapon_pumpshotgun_mk2"},
    { name = "weapon_sawnoffshotgun"},
    { name = "weapon_assaultshotgun"},
    { name = "weapon_bullpupshotgun"},
    { name = "weapon_musket"},
    { name = "weapon_heavyshotgun"},
    { name = "weapon_dbshotgun"},
    { name = "weapon_autoshotgun"},

    { name = "weapon_assaultrifle"},
    { name = "weapon_assaultrifle_mk2"},
    { name = "weapon_carbinerifle"},
    { name = "weapon_carbinerifle_mk2"},
    { name = "weapon_advancedrifle"},
    { name = "weapon_specialcarbine"},
    { name = "weapon_specialcarbine_mk2"},
    { name = "weapon_bullpuprifle"},
    { name = "weapon_bullpuprifle_mk2"},
    { name = "weapon_compactrifle"},

    { name = "weapon_mg"},
    { name = "weapon_combatmg"},
    { name = "weapon_combatmg_mk2"},
    { name = "weapon_gusenberg"},

    { name = "weapon_sniperrifle"},
    { name = "weapon_heavysniper"},
    { name = "weapon_heavysniper_mk2"},
    { name = "weapon_marksmanrifle"},
    { name = "weapon_marksmanrifle_mk2"},

    { name = "weapon_rpg"},
    { name = "weapon_grenadelauncher"},
    { name = "weapon_grenadelauncher_smoke"},
    { name = "weapon_minigun"},
    { name = "weapon_firework"},
    { name = "weapon_railgun"},
    { name = "weapon_hominglauncher"},
    { name = "weapon_compactlauncher"},
    { name = "weapon_rayminigun"},

    { name = "weapon_grenade"},
    { name = "weapon_bzgas"},
    { name = "weapon_smokegrenade"},
    { name = "weapon_flare"},
    { name = "weapon_molotov"},
    { name = "weapon_stickybomb"},
    { name = "weapon_proxmine"},
    { name = "weapon_snowball"},
    { name = "weapon_pipebomb"},
    { name = "weapon_ball"},

    { name = "weapon_petrolca"},
    { name = "weapon_fireextinguisher"},
    { name = "weapon_parachute"},
    { name = "weapon_hazardcan"},
}

local function GetModel()
    local body_model = "male"
    local model_ped = GetEntityModel(PlayerPedId())
    if model_ped == GetHashKey("mp_f_freemode_01") then
        body_model = "female"
    end
    return body_model
end

local function GetPlayers()
	local Players = {}
	for Index = 0, 255 do
		if NetworkIsPlayerActive(Index) then
			table.insert(Players, Index)
		end
	end
    return Players
end

local function GetClosestPlayer()
    local Players = GetPlayers()
    local closestdist = -1
    local closestplayer = -1
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped, false)
    
    for Index = 1, #Players do
    	local targetped = GetPlayerPed(Players[Index])
    	if ped ~= targetped then
    		local targetpos = GetEntityCoords(targetped, false)
    		local dist = #(pos - targetpos)

    		if closestdist == -1 or closestdist > dist then
    			closestplayer = Players[Index]
    			closestdist = dist
    		end
    	end
    end
    
    return closestplayer, closestdist
end

exports('GetClosetStat',function()
    local id,dist = GetClosestPlayer()

    if id ~= -1 and dist ~= -1 then
        if dist < 3.0 then
            local serverid = GetPlayerServerId(id)
            TriggerServerEvent("GetDiagnosis", serverid)
        end
    end
end)

local function Close()
    if opened then
        opened = false
        SendNUIMessage({
            NuiOpen = false,
        })
    end
end
AddEventHandler('KeyDown:escape',Close)
AddEventHandler('KeyDown:back',Close)

-- Open Nui
RegisterNetEvent("OpenBodyDamage")
AddEventHandler("OpenBodyDamage", function(m_body, m_body_model, m_punch, m_shots, m_cuts, m_bruises, m_cause_death)
    opened = true
    SendNUIMessage({
        NuiOpen = true,
        conditions_m = m_body,
        scale = scale, x = pos_x, y = pos_y,
        body = m_body_model,
        cause_death = m_cause_death,
        punch = m_punch, shots = m_shots, cuts = m_cuts, bruises = m_bruises,
        texts_nui = texts_nui,
    }) 
end)

-- Get information from another player
RegisterNetEvent("PassDiagnosis")
AddEventHandler("PassDiagnosis", function()
    TriggerServerEvent("PassDiagnosis", body, GetModel(), punch, shots, cuts, bruises, cause_death)
end)

-- Closes the NUI
CreateThread(function()
    local prev_health = max_health
    while true do
        if opened then
            if IsPauseMenuActive() then
                Close()
            end
        end

        local ped = PlayerPedId()
        local bool, bone = GetPedLastDamageBone(ped)
        local body_id = string.format("%x", bone)
        local dead = nil

        local player = PlayerId()
        SetPlayerHealthRechargeMultiplier(player, 0.0)

        ClearEntityLastWeaponDamage(ped)
        ClearPedLastWeaponDamage(ped)
        ClearPedLastDamageBone(ped)

        if IsPedDeadOrDying(ped, true) or IsEntityDead(ped) then
            dead = GetPedCauseOfDeath(ped)
        end

        local health = GetEntityHealth(ped)
        if health < prev_health then
            if body_id ~= 0 then
                for i, k in pairs(body) do
                    if i == body_id then
                        k.bruised = true
                        bruises = bruises + 1

                        for a,b in pairs(weapon_list) do
                            if HasPedBeenDamagedByWeapon(ped, b.name, 0) then
                                if a ~= 0 then
                                    if a >= 19 then
                                        k.shots = true
                                        shots = shots + 1
                                    elseif a > 2 and a < 19 then
                                        k.cuts = true 
                                        cuts = cuts + 1
                                    elseif a <= 2 then
                                        k.punch = true
                                        punch = punch + 1
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if dead then
                local res_death = false

                for a,b in pairs(weapon_list) do
                    if HasPedBeenDamagedByWeapon(ped, b.name, 0) then
                        if a ~= 0 then
                            if a >= 19 then
                                if shots >= 4 then
                                    cause_death = text_death_shots .. " " .. text_dead
                                else
                                    cause_death = text_death_shots
                                end
                            elseif a > 2 and a < 19 then
                                if cuts >= 4 then
                                    cause_death = text_death_cuts .. " " .. text_dead
                                else
                                    cause_death = text_death_cuts
                                end
                            elseif a <= 2 then
                                cause_death = text_death_punch
                            end
                            res_death = true
                        end
                    end
                end
        
                local random_reason_death = math.random(1,5)
                for i, k in pairs(reasons_death) do
                    if dead == k.death then
                        if random_reason_death == 3 then
                            cause_death = k.reason .. " " .. text_dead
                        else
                            cause_death = k.reason
                        end
                        res_death = true

                        if k.all_bruises ~= nil and k.all_bruises then
                            for h,j in pairs(body) do
                                j.bruised = true 
                                bruises = bruises + 1
                            end
                        end
                    end
                end

                if not res_death then
                    cause_death = "Unknown death"
                end

                -- Automatically
                if OpenClose_nui_automatically then
                    SetTimeout(250, function()
                        TriggerEvent("OpenBodyDamage", body, GetModel(), punch, shots, cuts, bruises, cause_death)
                    end)
                end

            end
        elseif health >= max_health and health > prev_health then
            for i,k in pairs(body) do
                k.bruised = false 
                k.shots = false 
                k.punch = false
                k.cuts = false 
            end

            punch = 0
            shots = 0
            cuts = 0
            bruises = 0
            cause_death = ''

            if opened and OpenClose_nui_automatically then
                Close()
            end
        end
        prev_health = health

        Wait(500)
    end
end)