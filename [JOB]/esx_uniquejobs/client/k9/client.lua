-- variables --
data = nil
--[[ 
{
    dogName,
    dogHash,
    dogBreed,
    stats = {
        health, armor,
        lvl, xp,
        hunger, thirst,
    }
}
]]

local ballObj, house = nil, nil -- entities
dog_ent = nil -- dog ent
dog_id, dogAmount = nil, 0

action = { -- all terms
    following = false, 
    attacking = false, 
    searching = false, 
    fetching = false, 
    feeding = false, 
    inHouse = false, 
    tracking = false, 
    carry = false, 
    hasCamera = false, 
    usingCamera = false, 
    hasBall = false
}

-- save tables
local status, lang = CFG.SETTINGS.STATUS, CFG.LANG

-- feeding system
local current_feedAmount = 0
local required_feedAmount = math.random(2, 3)
local peeing = false -- var is same for both actions

-- function variables --
local SetupScene, AddPedToScene, AddEntityToScene, AttachSyncedSceneToEntity = NetworkCreateSynchronisedScene, NetworkAddPedToSynchronisedScene, NetworkAddEntityToSynchronisedScene, NetworkAttachSynchronisedSceneToEntity
local StartScene, StopScene = NetworkStartSynchronisedScene, NetworkStopSynchronisedScene
local GetPosOfEntityBone, GetEntityBoneByName = GetWorldPositionOfEntityBone, GetEntityBoneIndexByName
local GetEntityHealth, GetPedArmour, GetEntityHeading, GetEntityCoords, GetEntityPlayerIsFreeAimingAt = GetEntityHealth, GetPedArmour, GetEntityHeading, GetEntityCoords, GetEntityPlayerIsFreeAimingAt

-- create groups
local ret, k9_group = AddRelationshipGroup('k9')
local ret, k9_owner = AddRelationshipGroup('k9_owner')

local looping = false -- loops

local tackled = false

-- if feeding or searching or following or fetching or attacking or IsEntityDead(dog_ent) or inHouse then return end

-- functions --
local function ADD_XP()
    if CFG.LVL_SYSTEM.DISABLE then return end

    local curLvl = data.stats.lvl
    local nextLvl = curLvl+1
    local maxLvl = #CFG.LVL_SYSTEM.LVLS

    if curLvl >= maxLvl then return end -- cannot go over max lvl

    local curXp = data.stats.xp
    local nextData = CFG.LVL_SYSTEM.LVLS[nextLvl]

    curXp += math.random(CFG.LVL_SYSTEM.XP_PER_ACTION.from, CFG.LVL_SYSTEM.XP_PER_ACTION.to)

    if curXp >= nextData.XP then
        curLvl += 1 -- add new lvl
        curXp = CFG.LVL_SYSTEM.LVLS[curLvl].XP
        if dog_ent and data then 
            TriggerServerEvent('sh-k9:sv:SaveDog', data, dog_id) 
        end
        Notify(string.format(lang.lvl_up, curLvl), 'success', 5000)
    end
    data.stats.xp, data.stats.lvl = curXp, curLvl
end

local function FAIL()
    if CFG.LVL_SYSTEM.DISABLE then return false end

    local curLvl = CFG.LVL_SYSTEM.LVLS[data.stats.lvl]
    local fail = curLvl.Fail
    local chance = math.random(1, 100)

    if chance < fail then return true end 
    return false
end

function DOG_FOLLOWS_ORDER()
    if CFG.LVL_SYSTEM.DISABLE then return true end

    if FAIL() then 
        Notify(string.format(lang.fail_command, data.dogName), 'error', 3500) 
        if math.random(100) < 30 then PlayAnimalVocalization(dog_ent, 3, 'bark') end
        return false 
    end 
    
    ADD_XP()
    return true
end

-- register dog --
function REGISTER_K9(breed, hash)
    ESX.UI.Menu.CloseAll()

    AddTextEntry('FMMC_KEY_TIP1', lang.name_dog)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", '', "", "", "", 20)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 

        -- if no framework
        if not CFG.FRAMEWORK then
            data = {
                dogName = result,
                dogHash = hash,
                dogBreed = breed,
                stats = {
                    health = status.maxHealth, armor = 0,
                    lvl = 1, xp = 0,
                    hunger = 100, thirst = 100
                }
            }
            OPEN_K9_MENU()
            return
        end

        -- if framework
        TriggerServerEvent('sh-k9:sv:RegisterDog', breed, hash, result)
    end
end

-- Spawns and Deletes K9
function SPAWN_K9(model, revive)

    -- despawn dog
    if dog_ent then
        REQUEST_CONTROL() -- try to request control but don't depend on the result
        data.health = GetEntityHealth(dog_ent)
        data.armor = GetPedArmour(dog_ent)
        DeleteEntity(dog_ent)
        dog_ent = nil
        return
    end

    -- spawn dog

    action = { -- reset certain actions
        following = false, 
        attacking = false, 
        searching = false, 
        fetching = false, 
        feeding = false, 
        inHouse = false, 
        tracking = false, 
        carry = false, 
        hasCamera = false, 
        usingCamera = false, 
    }

    local pos
    if revive then 
        pos = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 0.7, 0.0)
    else
        PlayAnimation(cache.ped, "taxi_hail", "hail_taxi", 51, 1300)
        pos = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 2.0, -0.3)
    end

    loadModel(model)
    dog_ent = CreatePed(28, model, pos.x, pos.y, pos.z, GetEntityHeading(cache.ped), true, true)

    LOAD_APPEARANCE() -- load saved appearance
    
    SetBlockingOfNonTemporaryEvents(dog_ent, true)
    SetPedFleeAttributes(dog_ent, 0, 0)

    SetPedCanRagdollFromPlayerImpact(dog_ent, false)
    SetPedCanRagdoll(dog_ent, false) -- pak mozna vypnout a zapni to na ostatnich mistech

    -- RELATIONSHIP
    -- ATTACKING PROBLEM FIX LATER
    --[[ SetPedRelationshipGroupHash(dog_ent, k9_group)
    SetPedRelationshipGroupHash(cache.ped, k9_owner)
    SetRelationshipBetweenGroups(0, k9_owner, k9_group)
    SetRelationshipBetweenGroups(0, k9_group, k9_owner) ]]

    GiveWeaponToPed(dog_ent, GetHashKey('WEAPON_ANIMAL'), 200, true, true)
    NetworkRegisterEntityAsNetworked(dog_ent)
    SetEntityAsMissionEntity(dog_ent, true, true)
        
    -- set health and armor
    if status.disable_hp_and_armor_saving then
        SetEntityHealth(dog_ent, status.maxHealth)
    else
        local hp = data.health or status.maxHealth
        local armor = data.armor or 0
        SetEntityHealth(dog_ent, tonumber(hp))
        SetPedArmour(dog_ent, tonumber(armor))
    end

    if not CFG.SETTINGS.INSTA_HEADSHOT then SetPedSuffersCriticalHits(dog_ent, false) end

    -- CREATE BLIP
    if CFG.SETTINGS.BLIP then
        local blip = AddBlipForEntity(dog_ent)
        SetBlipAsFriendly(blip, true)
        SetBlipSprite(blip, 442)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(tostring("K9: ".. data.dogName))
        EndTextCommandSetBlipName(blip)
    end

    if revive then
        PlayAnimation(dog_ent, 'creatures@rottweiler@getup', 'getup_l', 2)
        Wait(2000)
    end
    PlayAnimation(dog_ent, "missexile2", "fra0_ig_12_chop_waiting_a", 1)

    if CFG.TARGET then ADD_THIRD_EYE() end

    NetworkRegisterEntityAsNetworked(dog_ent)
    local netId = NetworkGetNetworkIdFromEntity(dog_ent)
    SetNetworkIdCanMigrate(netId, false)
    SetNetworkIdExistsOnAllMachines(true)
end

-- Check Dog --
function CHECK_DOG()
    if not data then return Notify(lang.not_loaded, 'error', 5000) end
    Notify(string.format(lang.status, GetEntityHealth(dog_ent), GetPedArmour(dog_ent), data.stats.hunger or 0, data.stats.thirst or 0, data.stats.lvl or 0, #CFG.LVL_SYSTEM.LVLS, data.stats.xp or 0), 'success', 4000)
end

-- Attack and Tackle
function TOGGLE_ATTACK(entity)
    if action.feeding or action.searching or action.fetching or action.attacking or IsEntityDead(dog_ent) or action.inHouse or action.carry then return end
    if not DOG_FOLLOWS_ORDER() then return end

    REQUEST_CONTROL()

    local target = entity
    if IsPedAPlayer(target) then
        local player = GetPlayerFromServerId(GetPlayerId(target))
        target = GetPlayerPed(player)
    end

    -- attack
    SetCanAttackFriendly(dog_ent, true, true)
    TaskPutPedDirectlyIntoMelee(dog_ent, target, 0.0, -1.0, 0.0, 0)

    action.attacking, action.following = true, false
    Notify(lang.attack, "success", 3000)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

    CreateThread(function()
        while action.attacking do
            local isAttacking = GetIsTaskActive(dog_ent, 128) -- is dog attacking
            if IsEntityDead(target) then
                if #(GetEntityCoords(dog_ent) - GetEntityCoords(target)) < 5.0 then
                    REQUEST_CONTROL()

                    SetEntityHeadingLookAt(dog_ent, target) 
                    Wait(500)
                    SetBlockingOfNonTemporaryEvents(dog_ent, true)
                    PlayAnimation(dog_ent, "creatures@rottweiler@tricks@", "sit_enter", 2)
                    action.attacking = false 
                end

            elseif isAttacking then
                if IsEntityPlayingAnim(target, 'combat@damage@writheidle_b', 'writhe_idle_d', 3) 
                or IsEntityPlayingAnim(target, 'missfra0_chop_find', 'fra_0_ig_chop_take_down_balla_victim', 3) 
                or IsEntityPlayingAnim(target, "mp_arresting", "idle", 3)
                or IsPedRagdoll(target) then
                    SetEntityHeadingLookAt(dog_ent, target) 
                    PlayAnimation(dog_ent, "creatures@rottweiler@amb@world_dog_barking@idle_a", "idle_a", 1)
                end

            elseif not isAttacking then
                if not (IsPedRagdoll(target) 
                or IsEntityPlayingAnim(target, 'missfra0_chop_find', 'fra_0_ig_chop_take_down_balla_victim', 3) 
                or IsEntityPlayingAnim(target, 'combat@damage@writheidle_b', 'writhe_idle_d', 3) ) then
                    Wait(300)
                    TaskPutPedDirectlyIntoMelee(dog_ent, target, 0.0, -1.0, 0.0, 0)
                end
            end

            if IsEntityPlayingAnim(target, "mp_arresting", "idle", 3) then
                REQUEST_CONTROL()
                ClearPedTasks(dog_ent)
                action.attacking = false 
            end

            Wait(100)
        end
    end)

    CreateThread(function()
        while action.attacking do
            Wait(500)
            if IsEntityDead(dog_ent) or not DoesEntityExist(dog_ent) then
                action.attacking = false 
            end
        end
    end)
end

-- Follow --
function FOLLOW()
    if action.feeding or action.searching or IsEntityDead(dog_ent) or action.carry then return end
    if not DOG_FOLLOWS_ORDER() then return end

    if action.inHouse then
        action.inHouse = false
        DetachEntity(dog_ent, true, true)
        ClearPedTasks(dog_ent)
    end

    local req_control = REQUEST_CONTROL()
    if not req_control then return end

    if not action.following then
        Notify(lang.follow.. '!', "success", 3000)

        if IsEntityPlayingAnim(dog_ent, "creatures@rottweiler@tricks@", "sit_enter", 3) then
            PlayAnimation(dog_ent, "creatures@rottweiler@tricks@", "sit_exit", 2)
            Wait(500)
        end

        TaskFollowToOffsetOfEntity(dog_ent, cache.ped, 0.5, 0.0, 0.0, 5.0, -1, 0.0, 1)
        SetPedKeepTask(dog_ent, true)
        action.following, action.attacking, action.fetching = true, false, false
    else
        SetPedKeepTask(dog_ent, false)
        ClearPedTasks(dog_ent)
        PlayAnimation(dog_ent, "missexile2", "fra0_ig_12_chop_waiting_a", 1)
        action.following = false
        Notify(lang.stop.. '!', "error", 3000)
    end
end

-- In and Out of Vehicle
--[[
    SF_FrontPassengerSide = 0, -- passenger
    SF_BackDriverSide = 1, -- behind driver
    SF_BackPassengerSide = 2, -- behind passenger

    VEH_EXT_DOOR_PSIDE_F = 2, -- passenger
    VEH_EXT_DOOR_DSIDE_R = 1, -- behind driver
    VEH_EXT_DOOR_PSIDE_R = 3, -- behind passenger
]]

local door, bone, seat, seatpos = nil, nil, nil, nil
function TOGGLE_VEHICLE()
    if action.feeding or action.searching or IsEntityDead(dog_ent) or action.inHouse or action.carry then return end

    local req_control = REQUEST_CONTROL()
    if not req_control then return end

    if IsPedInAnyVehicle(dog_ent) then -- if do in vehicle
        action.following = false
        Notify(lang.get_out..'!', "success", 3000)

        local veh = GetVehiclePedIsIn(dog_ent)
        local model = GetEntityModel(veh)
        if not IsThisModelACar(model) then 
            Notify(lang.veh_no_supported, "success", 3000)
            return 
        end

        local dict = "creatures@rottweiler@in_vehicle@std_car"
        local rot = 0.0
        if CFG.SETTINGS.VEHICLE_ENTERING.vans[model] then
            dict = "creatures@rottweiler@in_vehicle@van"
            if seat == 1 then
                rot = 0.0
            elseif seat == 2 then
                rot = 180.0
            end
        elseif seat == 1 then
            rot = 180.0
        end

        LoadAnimDict(dict)
        SetEntityInvincible(dog_ent, true) 
        SetVehicleDoorOpen(veh, door, false, true)

        if CFG.SETTINGS.VEHICLE_ENTERING.new then
            --ClearPedTasksImmediately(dog_ent) 
            --Wait(200)

            local scene = SetupScene(0.0, 0.0, 0.0, 0.0, 0.0, rot, 2, false, true, 1065353216, 0, 1.3)
            AttachSyncedSceneToEntity(scene, veh, GetEntityBoneByName(veh, bone))
            AddPedToScene(dog_ent, scene, dict, "get_out", 1000.0, -8.0, 10, 0, 1000.0, 0) -- 1.5, -4.0, 1, 16, 1148846080, 0)
            StartScene(scene)

            Wait(1600)
            StopScene(scene)
            TaskLeaveVehicle(dog_ent, veh, 16)
            Wait(1500)
        else
            TaskLeaveVehicle(dog_ent, veh, 16)
            Wait(1500)
        end

        SetVehicleDoorShut(veh, door, false)
        SetEntityInvincible(dog_ent, false) 
    else -- if dog is out
        local veh = nil
        if cache.vehicle then -- if player in veh
            veh = GetVehiclePedIsIn(cache.ped)
            if DoesEntityExist(veh) then
                local model = GetEntityModel(veh)
                if CFG.SETTINGS.VEHICLE_ENTERING.vans[model] then
                    if IsVehicleSeatFree(veh, 1) then
                        door, bone, seat, seatpos = 2, "seat_dside_r", 1, GetPosOfEntityBone(veh, GetEntityBoneByName(veh, "seat_dside_r"))
                    elseif IsVehicleSeatFree(veh, 2) then
                        door, bone, seat, seatpos = 3, "seat_pside_r", 2, GetPosOfEntityBone(veh, GetEntityBoneByName(veh, "seat_pside_r"))
                    elseif IsVehicleSeatFree(veh, 0) then
                        door, bone, seat, seatpos = 1, "seat_pside_f", 0, GetPosOfEntityBone(veh, GetEntityBoneByName(veh, "seat_pside_f"))
                    else
                        Notify(lang.all_seats_occupied, "error", 3500)
                        return
                    end
                else
                    if IsVehicleSeatFree(veh, 2) then
                        door, bone, seat, seatpos = 3, "seat_pside_r", 2, GetPosOfEntityBone(veh, GetEntityBoneByName(veh, "seat_pside_r"))
                    elseif IsVehicleSeatFree(veh, 1) then
                        door, bone, seat, seatpos = 2, "seat_dside_r", 1, GetPosOfEntityBone(veh, GetEntityBoneByName(veh, "seat_dside_r"))
                    elseif IsVehicleSeatFree(veh, 0) then
                        door, bone, seat, seatpos = 1, "seat_pside_f", 0, GetPosOfEntityBone(veh, GetEntityBoneByName(veh, "seat_pside_f"))
                    else
                        Notify(lang.all_seats_occupied, "error", 3500)
                        return
                    end
                end
            else
                Notify(lang.veh_no_found, "error", 3500)
            end
        else
            veh = GetVehicleAheadOfPlayer()
            door, bone, seat, seatpos = GetClosestVehicleDoor(veh)
        end

        if DoesEntityExist(veh) then
            if door then

                local model = GetEntityModel(veh)
                if not IsThisModelACar(model) then 
                    Notify(lang.veh_no_supported, "success", 3000)
                    return 
                end

                action.following = false
                Notify(lang.get_in..'!', "success", 3000)
                SetVehicleDoorOpen(veh, door, false, true)

                local dict = "creatures@rottweiler@in_vehicle@std_car"
                local wait, rot = 1600, 0.0
                if CFG.SETTINGS.VEHICLE_ENTERING.vans[model] then
                    dict = "creatures@rottweiler@in_vehicle@van"
                    if seat == 1 then
                        rot = 0.0
                    elseif seat == 2 then
                        rot = 180.0
                    end
                    wait = 1200
                elseif seat == 1 then
                    rot = 180.0
                end
                LoadAnimDict(dict)

                TaskEnterVehicle(dog_ent, veh, -1, seat, 2.0, 1, 0)
                while not GetIsTaskActive(dog_ent, 161) do 
                    Wait(0) 
                    if IsEntityDead(dog_ent) or not DoesEntityExist(dog_ent) then return end
                end 

                if CFG.SETTINGS.VEHICLE_ENTERING.new then
                    local scene = SetupScene(0.0, 0.0, 0.0, 0.0, 0.0, rot, 2, false, true, 1065353216, 0, 1.3)
                    AttachSyncedSceneToEntity(scene, veh, GetEntityBoneByName(veh, bone))
                    AddPedToScene(dog_ent, scene, dict, "get_in", 1000.0, -8.0, 10, 0, 1000.0, 0) -- 1.5, -4.0, 1, 16, 1148846080, 0)
                    StartScene(scene)

                    Wait(wait)

                    SetPedIntoVehicle(dog_ent, veh, seat)
                    TaskPlayAnim(dog_ent, dict, "sit", 8.0, -8.0, -1, 1, 0.0, false, false, false)
                else
                    TaskWarpPedIntoVehicle(dog_ent, veh, seat)
                    Wait(300)
                    TaskPlayAnim(dog_ent, dict, "sit", 8.0, -8.0, -1, 1, 0.0, false, false, false)
                end

                SetVehicleDoorShut(veh, door, false)
            else
                Notify(lang.all_seats_occupied, "error", 3500)
            end
        else
            Notify(lang.veh_no_found, "error", 3500)
        end
    end
end

-- feeding --
function FEED()
    local hasItem = lib.callback.await('sh-k9:CB:HAS_ITEM', false, status.feed.item)
    if not hasItem then 
        if CFG.FRAMEWORK == 'QBCore' or CFG.FRAMEWORK == 'QBX' then
            if CORE.Shared.Items[status.feed.item] then
                return Notify(string.format(lang.missing_item, CORE.Shared.Items[status.feed.item].label), 'error', 4000) 
            else
                return Notify(string.format(lang.missing_item, status.feed.item), 'error', 4000) 
            end
        else
            return Notify(string.format(lang.missing_item, status.feed.item), 'error', 4000) 
        end
    end

    if action.feeding or action.searching or action.fetching or action.attacking or IsEntityDead(dog_ent) or action.inHouse or action.carry then return end
    action.feeding, action.following = true, false

    local pcoords = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 0.75, 0.0)

    SetAudioFlag("DisableBarks", true)
    
    PlayAnimation(cache.ped, "random@domestic", "pickup_low", 51, 1200)
    Wait(600)
    local obj = CreateObject(status.feed.prop, pcoords.x, pcoords.y, pcoords.z, true, false)
    PlaceObjectOnGroundProperly(obj)

    Wait(1000)
    
    local req_control = REQUEST_CONTROL()
    if not req_control then
        DeleteObject(obj) 
        ClearPedTasks(dog_ent) 
        action.feeding = false
        SetAudioFlag("DisableBarks", false)
        return
    end

    TaskGoToEntity(dog_ent, obj, -1, 0.5, 3.0, 1073741824.0, 0)
    SetPedKeepTask(dog_ent, true)

    while action.feeding do
        local pcoords = GetEntityCoords(obj)
        local dogPos = GetEntityCoords(dog_ent)
        local dist = #(vec2(pcoords) - vec2(dogPos))
        if dist < 1.1 then
            ClearPedTasks(dog_ent)
            Wait(250)
            SetEntityHeadingLookAt(dog_ent, obj) 
            PlayAnimation(dog_ent, "creatures@rottweiler@indication@", "indicate_low", 1)
            break
        end

        ShowHelpNotification(lang.stop_activity) 
        if IsControlJustReleased(0, 47) then
            DeleteObject(obj) 
            ClearPedTasks(dog_ent) 
            action.feeding = false 
            return 
        end

        Wait(0)
    end

    Wait(4000) -- feeding delay

    if DoesEntityExist(dog_ent) then 
        TriggerServerEvent('sh-k9:sv:RemoveItem', status.feed.item)
        DeleteObject(obj) 
        ClearPedTasks(dog_ent) 
        Notify(lang.feeded, 'success', 3500) 
        data.stats.hunger, data.stats.thirst = 100, 100
        current_feedAmount += 1
    end
    SetAudioFlag("DisableBarks", false)

    action.feeding = false
end

-- revive / apply heal or armor --
function HEAL_OR_ARMOR(type)
    local item
    if type == 'heal' then
        item = status.heal.item
    else
        item = status.armor.item
    end

    local hasItem = lib.callback.await('sh-k9:CB:HAS_ITEM', false, item)
    if not hasItem then 
        if CFG.FRAMEWORK == 'QBCore' or CFG.FRAMEWORK == 'QBX' then
            if CORE.Shared.Items[item] then
                return Notify(string.format(lang.missing_item, CORE.Shared.Items[item].label), 'error', 4000) 
            else
                return Notify(string.format(lang.missing_item, item), 'error', 4000) 
            end
        else
            return Notify(string.format(lang.missing_item, item), 'error', 4000) 
        end 
    end

    if action.feeding or action.searching or action.fetching or action.attacking or action.inHouse or action.carry then return end
    action.following = false

    local req_control = REQUEST_CONTROL()
    if not req_control then return end

    -- dog is not close
    if #(GetEntityCoords(dog_ent) - GetEntityCoords(cache.ped)) > 1.5 then
        return Notify(lang.dog_not_close, 'error', 3500)
    end

    SetEntityHeadingLookAt(cache.ped, dog_ent) 

    -- heal or revive
    if type == 'heal' then

        -- start revive
        if IsEntityDead(dog_ent) then
            PlayAnimation(cache.ped, 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest', 1)
            Wait(1000 * status.heal.revive_timer)
            ClearPedTasks(cache.ped)

            data.health, data.armor = status.maxHealth, 0
            DeleteEntity(dog_ent)
            dog_ent = nil

            TriggerServerEvent('sh-k9:sv:RemoveItem', status.heal.item)
            SPAWN_K9(data.dogHash, true)
            return
        end 

        -- apply bandage
        SetEntityHeadingLookAt(dog_ent, cache.ped) 
        PlayAnimation(cache.ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1)
        Wait(1000 * status.heal.timer)
        ClearPedTasks(cache.ped)
        SetEntityHealth(dog_ent, GetEntityHealth(dog_ent) + math.random(status.heal.amount.from, status.heal.amount.to))
        if GetEntityHealth(dog_ent) > status.maxHealth then SetEntityHealth(dog_ent, status.maxHealth) end

        TriggerServerEvent('sh-k9:sv:RemoveItem', item)
    end

    -- armor
    if type == 'armor' then
        if IsEntityDead(dog_ent) then return end

        SetEntityHeadingLookAt(dog_ent, cache.ped) 
        PlayAnimation(cache.ped, "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1)
        Wait(1000 * status.armor.timer)
        ClearPedTasks(cache.ped)
        SetPedArmour(dog_ent, GetPedArmour(dog_ent) + math.random(status.armor.amount.from, status.armor.amount.to))
        if GetPedArmour(dog_ent) > status.maxArmor then SetPedArmour(dog_ent, status.maxArmor) end

        TriggerServerEvent('sh-k9:sv:RemoveItem', item)
    end
end

-- Search Player
function SEARCH_PLAYER()
    if action.feeding or action.searching or action.attacking or IsEntityDead(dog_ent) or action.inHouse or action.carry then return end

    local req_control = REQUEST_CONTROL()
    if not req_control then return end

    local foundTarget = false
    local playerId = nil
    local player, distance = nil, nil

    if IsPlayerFreeAiming(PlayerId()) then
        local bool, target = GetEntityPlayerIsFreeAimingAt(PlayerId())
        if bool then
            if IsEntityAPed(target) and IsPedAPlayer(target) then
                if not IsPedInAnyVehicle(target) then
                    foundTarget = true
                    player = GetPlayerFromServerId(GetPlayerId(target))
                    playerId = GetPlayerId(GetPlayerPed(player))
                    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
                end
            end
        end
    else 
        player, distance = GetClosestPlayer()
        if player ~= -1 and distance < 2.5 then
            playerId = GetPlayerServerId(player)
            if not IsPedInAnyVehicle(player) then
                foundTarget = true
                PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
            end
        else
            Notify(lang.nobody_close, 'error', 3000) 
        end
    end

    if not foundTarget then return end
    if not DOG_FOLLOWS_ORDER() then return end

    action.searching, action.following = true, false

    local found = lib.callback.await('sh-k9:CB:SEARCH_PLAYER', false, playerId)

    TaskFollowToOffsetOfEntity(dog_ent, GetPlayerPed(player), 0.0, 0.0, 0.0, 5.0, -1, 0.0, 1)
    SetPedKeepTask(dog_ent, true)

    while action.searching do
        if #(GetEntityCoords(dog_ent) - GetEntityCoords(GetPlayerPed(player))) < 2.5 then
            SetEntityHeadingLookAt(dog_ent, GetPlayerPed(player)) 
            ClearPedTasks(dog_ent)
            break
        end

        if IsEntityDead(dog_ent) or not DoesEntityExist(dog_ent) then searching = false return end
        Wait(0)
    end

    Notify(lang.search, 'success', 3000) 
    Wait(CFG.SETTINGS.SEARCH.search_player_time * 1000)

    local fail = FAIL()
    if fail or not found then -- fail or nothing found
        Notify(string.format(lang.search_not_found, data.dogName), 'error', 3000) 
    elseif found then -- found item
        Notify(string.format(lang.search_found, data.dogName), 'success', 3000) 

        local onSuccess = CFG.SETTINGS.SEARCH.onSuccess
        if onSuccess then
            if onSuccess == 'bark' then
                PlayAnimation(dog_ent, "creatures@rottweiler@amb@world_dog_barking@idle_a", "idle_a", 1)
            elseif onSuccess == 'sit' then
                PlayAnimation(dog_ent, "creatures@rottweiler@tricks@", "sit_enter", 2)
            elseif onSuccess == 'laydown' then
                PlayAnimation(dog_ent, "creatures@rottweiler@amb@sleep_in_kennel@", "sleep_in_kennel", 2)
            end
        end
    end

    SetEntityHeadingLookAt(dog_ent, GetPlayerPed(player)) 
    action.searching = false
end

-- SEARCH VEHICLE --
function SEARCH_VEHICLE()
    if action.feeding or action.searching or action.attacking or IsEntityDead(dog_ent) or action.inHouse or action.carry then return end
    if not DOG_FOLLOWS_ORDER() then return end

    local vehicle = GetVehicleAheadOfPlayer()
    if not DoesEntityExist(vehicle) then
        return Notify(lang.no_vehicle, "error", 5000) 
    end

    local carplate = GetPlate(vehicle)
    if not carplate then
        return Notify(lang.no_plate, "error", 5000) 
    end

    local found = lib.callback.await('sh-k9:CB:SEARCH_VEHICLE', false, carplate)
    action.searching, action.following = true, false
    Notify(lang.search, "success", 3000)
    
    if CFG.SETTINGS.SEARCH.open_doors then
        for i = 0, 7 do 
            SetVehicleDoorOpen(vehicle, i, 0, 0) 
        end
    end

    local offsets = {
        {x = 2.0, y = -2.0},
        {x = 2.0, y = 2.0},
        {x = -2.0, y = 2.0},
        {x = -2.0, y = -2.0}
    }

    for _, v in pairs(offsets) do
        if IsEntityDead(dog_ent) or not DoesEntityExist(dog_ent) then
            if CFG.SETTINGS.SEARCH.open_doors then SetVehicleDoorsShut(vehicle, 0) end
            searching = false 
            return 
        end

        local offset = GetOffsetFromEntityInWorldCoords(vehicle, v.x, v.y, 0.0)
        TaskGoToCoordAnyMeans(dog_ent, offset.x, offset.y, offset.z, 5.0, 0, 0, 1, 10.0)
        Wait(7000)
    end

    if CFG.SETTINGS.SEARCH.open_doors then SetVehicleDoorsShut(vehicle, 0) end

    if FAIL() or not found then
        Notify(string.format(lang.search_not_found, data.dogName), 'error', 3000) 
    elseif found then
        SetEntityHeadingLookAt(dog_ent, vehicle)  
        Notify(string.format(lang.search_found, data.dogName), 'success', 3000)

        if CFG.SETTINGS.SEARCH.onSuccess then
            if CFG.SETTINGS.SEARCH.onSuccess == 'bark' then
                PlayAnimation(dog_ent, "creatures@rottweiler@amb@world_dog_barking@idle_a", "idle_a", 1)
            elseif CFG.SETTINGS.SEARCH.onSuccess == 'sit' then
                PlayAnimation(dog_ent, "creatures@rottweiler@tricks@", "sit_enter", 2)
            elseif CFG.SETTINGS.SEARCH.onSuccess == 'laydown' then
                PlayAnimation(dog_ent, "creatures@rottweiler@amb@sleep_in_kennel@", "sleep_in_kennel", 2)
            end
        end
    end

    action.searching = false
end

-- GET BALL --
function GET_BALL()
    if action.fetching then return end

    if action.hasBall then 
        DeleteEntity(ballObj)
        action.hasBall = false
        return 
    end

    if not DoesEntityExist(ballObj) then
        local pcoords = GetEntityCoords(cache.ped)
        loadModel(`w_am_baseball`)
        ballObj = CreateObjectNoOffset(`w_am_baseball`, pcoords.x, pcoords.y, pcoords.z, true, false)
    end

    AttachEntityToEntity(ballObj, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.15, 0.0, -0.03, 0, 270.0, 60.0, true, true, false, true, 1, true)
    action.hasBall = true

    while action.hasBall do
        ShowHelpNotification(lang.throw_ball) 
        if IsControlJustReleased(0, 38) then
            local forwardVector, force = GetEntityForwardVector(cache.ped), 20.0
            local animDict, anim = "melee@unarmed@streamed_variations", "plyr_takedown_front_slap"
        
            LoadAnimDict(animDict)
            TaskPlayAnim(cache.ped, animDict, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
        
            Wait(500)
        
            DetachEntity(ballObj)
            ApplyForceToEntity(ballObj, 1, forwardVector.x*force, forwardVector.y*force + 5.0, forwardVector.z, 0, 0, 0, 0, false, true, true, false, true)
            NetworkRegisterEntityAsNetworked(ballObj)
            action.hasBall = false
        end
        Wait(0)
    end
end

-- FETCH --
function FETCH_BALL()
    if action.feeding or action.searching or action.fetching or action.attacking or IsEntityDead(dog_ent) or action.inHouse or action.carry or action.hasBall then return end
    if not DOG_FOLLOWS_ORDER() then return end

    action.fetching = true
    local pcoords = GetEntityCoords(dog_ent)

    if ballObj == nil or not DoesEntityExist(ballObj) then 
        Notify(lang.ball_not_found, 'error', 5000)
        action.fetching = false
        return 
    end

    action.following = false
    Notify(lang.fetch.."!", 'success', 3000)

    TaskFollowToOffsetOfEntity(dog_ent, ballObj, 0.0, 0.0, 0.0, 5.0, -1, 0.0, 1)
    SetPedKeepTask(dog_ent, true)

    CreateThread(function() -- ball check
        while action.fetching do
            Wait(1000)
            
            if not DoesEntityExist(ballObj) or IsEntityInWater(ballObj) then
                action.fetching = false
                Notify(lang.ball_lost, 'error', 5000)
                DeleteEntity(balObj) 
                ClearPedTasks(dog_ent)
            end
        end
    end)

    while action.fetching do
        local idle = 500

        local ballPos = GetEntityCoords(ballObj)
        local dogPos = GetEntityCoords(dog_ent)
        local dist = #(ballPos - dogPos)

        if dist < 1.5 then
            PlayAnimation(dog_ent, "creatures@rottweiler@move", "fetch_pickup", 2)
            SetEntityHeadingLookAt(dog_ent, ballObj) 
            Wait(500)
            AttachEntityToEntity(ballObj, dog_ent, GetPedBoneIndex(dog_ent, 31086),
                0.25, 0.0, -0.09, -- pos 
                0.0, 0.0, 0.0, -- rot
                false, false, false, false, false, true
            )
            break
        end
        Wait(idle)
    end

    while action.fetching do -- bring ball
        if IsControlJustReleased(0, 38) then
            PlayAnimation(cache.ped, "taxi_hail", "hail_taxi", 51, 1300)
            
            TaskFollowToOffsetOfEntity(dog_ent, cache.ped, 0.0, 0.0, 0.0, 5.0, -1, 0.0, 1)
            SetPedKeepTask(dog_ent, true)
            break
        end

        ShowHelpNotification(lang.call_dog) 
        if IsControlJustReleased(0, 47) then 
            action.fetching = false 
            DeleteObject(ballObj) 
        end
        Wait(0) 
    end

    while action.fetching do -- drop ball
        local pcoords = GetEntityCoords(cache.ped)
        local dogPos = GetEntityCoords(dog_ent)
        local dist = #(pcoords - dogPos)

        if dist < 1.5 then 
            PlayAnimation(dog_ent, "creatures@rottweiler@move", "fetch_drop", 2)
            Wait(400) 
            DetachEntity(ballObj, true, true) 

            if math.random(1, 100) < 25 then
                ADD_XP()
                SetEntityHeadingLookAt(dog_ent, cache.ped) 
                local dict, anim, anim2 = "creatures@rottweiler@tricks@", "beg_enter", "beg_loop"
                PlayAnimation(dog_ent, dict, anim, 2)
                Wait(500)
                PlayAnimation(dog_ent, dict, anim2, 1)
                Wait(1000)
                PlayAnimation(dog_ent, "creatures@rottweiler@amb@world_dog_sitting@idle_a", "idle_b", 2)
            end
            
            break 
        end

        ShowHelpNotification(lang.stop_activity) 
        if IsControlJustReleased(0, 47) then 
            action.fetching = false 
            DeleteObject(ballObj) 
        end
        Wait(0)
    end

    while action.fetching do -- pickup ball
        local pcoords = GetEntityCoords(cache.ped)
        local ballpos = GetEntityCoords(ballObj)
        local dist = #(pcoords - ballpos)

        if IsControlJustReleased(0, 38) then
            if dist < 1.5 then
                PlayAnimation(cache.ped, "random@domestic", "pickup_low", 51, 1200)
                Wait(300)
                action.fetching = false
                GET_BALL()
            else
                Notify(lang.ball_not_close, 'error', 3500)
            end
        end

        ShowHelpNotification(lang.pickup_ball) 
        if IsControlJustReleased(0, 47) then 
            action.fetching = false 
            DeleteObject(ballObj) 
        end
        Wait(0) 
    end
end

-- dog house --
function CREATE_HOUSE()
    if not DoesEntityExist(house) then
        local heading = GetEntityHeading(cache.ped) + 90.0

        PlayAnimation(cache.ped, 'pickup_object', 'putdown_low', 51, 1300)
        Wait(300)

        local pcoords = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 1.2, 0.0)
        local obj = CreateObject(`prop_doghouse_01`, pcoords, true, false)
        PlaceObjectOnGroundProperly(obj)
        SetEntityHeading(obj, heading)
        house = obj
    else
        if action.inHouse then GO_INTO_HOUSE() end
        DeleteEntity(house)
        house = nil
    end
end

-- go into house --
function GO_INTO_HOUSE()
    if action.feeding or action.searching or action.fetching or action.attacking or IsEntityDead(dog_ent) or action.carry then return end
    if not DoesEntityExist(house) then Notify(lang.missing_house, 'error', 5000) end
    action.following = false

    -- exit house
    if IsEntityAttachedToEntity(dog_ent, house) then
        action.inHouse = false
        DetachEntity(dog_ent, true, true)
        PlayAnimation(dog_ent, "creatures@rottweiler@amb@sleep_in_kennel@", "exit_kennel", 2)
        return
    end

    -- enter house
    Notify(lang.get_in.."!", 'success', 3000)
    TaskGoToEntity(dog_ent, house, -1, 0.0, 3.0, 1073741824.0, 0)
    SetPedKeepTask(dog_ent, true)

    while true do 
        if #(GetEntityCoords(dog_ent) - GetEntityCoords(house)) < 1.5 then break end 
        if IsEntityDead(dog_ent) or not DoesEntityExist(dog_ent) or not DoesEntityExist(house) then return end
        Wait(0) 
    end

    AttachEntityToEntity(dog_ent, house, 0, 
        -0.2, -0.15, 0.4, -- pos
        0.0, 0.0, 80.0, -- rot
        true, true, false, true, 1, true
    )
    PlayAnimation(dog_ent, "creatures@rottweiler@amb@sleep_in_kennel@", "sleep_in_kennel", 2)
    action.inHouse = true
end

-- Carry Dog --
function CARRY_DOG()
    if not DoesEntityExist(dog_ent) then return end
    if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
    
    ClearPedTasks(cache.ped) ClearPedTasks(dog_ent)

    -- stop carry
    if IsEntityAttachedToEntity(dog_ent, cache.ped) then
        DetachEntity(dog_ent, true, true)
        action.carry = false
        Wait(1000)
        SetEntityInvincible(dog_ent, false)
        return
    end

    -- not close
    if #(GetEntityCoords(dog_ent) - GetEntityCoords(cache.ped)) > 1.5 then
        return Notify(lang.dog_not_close, 'error', 3500)
    end

    -- start carry
    AttachEntityToEntity(dog_ent, cache.ped, 0, 
        0.0, 0.25, 0.5, -- pos
        0.0, 0.0, 80.0, -- rot
        true, true, false, true, 1, true
    )

    PlayAnimation(dog_ent, "creatures@rottweiler@amb@sleep_in_kennel@", "sleep_in_kennel", 2)
    PlayAnimation(cache.ped, "anim@heists@box_carry@", "idle", 51)
    action.carry = true

    SetEntityInvincible(dog_ent, true)

    CreateThread(function()
        while action.carry do
            if not IsEntityAttachedToEntity(dog_ent, cache.ped) or not DoesEntityExist(dog_ent) or IsEntityDead(dog_ent) then
                action.carry = false
            end

            if not IsEntityPlayingAnim(cache.ped, "anim@heists@box_carry@", "idle", 3) then 
                PlayAnimation(cache.ped, "anim@heists@box_carry@", "idle", 51)
            end

            ShowHelpNotification(lang.stop_carry) 
            if IsControlJustPressed(0, 47) then
                ClearPedTasks(cache.ped) ClearPedTasks(dog_ent)
                DetachEntity(dog_ent, true, true)
                action.carry = false
                Wait(1000)
                SetEntityInvincible(dog_ent, false)
            end

            Wait(0)
        end
    end)
end

-- TRACKING ONE PLAYER
function TRACKING_PLAYER(playerId)
    local settings = CFG.SETTINGS.TRACKING
    if not DoesEntityExist(dog_ent) or IsEntityDead(dog_ent) then return end
    if #(GetEntityCoords(dog_ent) - GetEntityCoords(cache.ped)) > 10.0 then return Notify(lang.dog_not_close, 'error', 3500) end

    if action.feeding or action.searching or action.fetching or action.attacking or action.inHouse then return end
    if action.tracking then return Notify(lang.tracking_cooldown, "error", 3500) end

    if not playerId then
        local input = lib.inputDialog(lang.track, {
            {type = 'number', label = lang.insert_id, description = '', icon = 'hashtag', required = true},
        })
        if not input or input[1] == nil then return end
        playerId = tonumber(input[1])
    end
 
    action.tracking, action.following = true, false

    PlayAnimation(dog_ent, "missfra0_chop_find", "fra0_ig_14_chop_sniff_fwds", 1)
    Wait(3000)
    ClearPedTasks(dog_ent)

    local player = GetPlayerFromServerId(playerId)
    if FAIL() or player == -1 or playerId == GetServerId() then 
        action.tracking = false
        return Notify(lang.dog_nothing_found, "error", 3500)
    end

    local playerped = GetPlayerPed(player)
    local pos = GetEntityCoords(playerped)
    TaskTurnPedToFaceCoord(dog_ent, pos.x, pos.y, pos.z, -1)

    while true do
        ShowHelpNotification(lang.track_player_action) 

        if IsControlJustPressed(0, 38) then -- E
            local speed = (not CFG.LVL_SYSTEM.DISABLE and CFG.LVL_SYSTEM.LVLS[data.stats.lvl].tracking_speed) or settings.speed
            local stopping_range = 5.0
            TaskFollowNavMeshToCoord(dog_ent, pos.x, pos.y, pos.z, speed, -1, stopping_range, true, 0)
            SetPedKeepTask(dog_ent, true)
            SetTimeout(settings.cooldown * 1000 * 60, function() action.tracking = false end)
            return
        elseif IsControlJustPressed(0, 47) then -- G
            action.tracking = false
            return
        end

        if IsEntityDead(dog_ent) or not DoesEntityExist(dog_ent) then return end
        
        Wait(0)
    end
end -- TRACKING_PLAYER(20)

-- TRACKING ALL PLAYERS IN SMELL RADIUS
function TRACKING_ALL()
    local settings = CFG.SETTINGS.TRACKING
    if not DoesEntityExist(dog_ent) or IsEntityDead(dog_ent) then return end
    if #(GetEntityCoords(dog_ent) - GetEntityCoords(cache.ped)) > 10.0 then return Notify(lang.dog_not_close, 'error', 3500) end

    if action.feeding or action.searching or action.fetching or action.attacking or action.inHouse then return end
    if action.tracking then return Notify(lang.tracking_cooldown, "error", 3500) end
    action.tracking, action.following = true, false

    local people = {}
    local dog_pos = GetEntityCoords(dog_ent)
    for k, index in pairs(GetActivePlayers()) do
        local player = GetPlayerPed(index)
        local pos = GetEntityCoords(player)
        local dist = #(dog_pos - pos)
        if dist < settings.radius then
            if not FAIL() then
                local playerId = GetPlayerId(player)
                if playerId ~= GetServerId() then
                    people[#people +1] = {playerId = playerId, pos = pos}
                end
            end
        end
    end

    PlayAnimation(dog_ent, "missfra0_chop_find", "fra0_ig_14_chop_sniff_fwds", 1)
    Wait(3000)
    ClearPedTasks(dog_ent)

    if not next(people) then 
        action.tracking = false
        return Notify(lang.dog_nothing_found, "error", 3500)
    end

    local selected = 1
    local max = #people
    local DEG2RAD, RAD2DEG = math.pi / 180.0, 180.0 / math.pi

    TaskTurnPedToFaceCoord(dog_ent, people[1].pos.x, people[1].pos.y, people[1].pos.z, -1)
    Notify(string.format(lang.dog_found_tracks, max), "success", 3500)

    while true do
        Wait(0)

        if not DoesEntityExist(dog_ent) or IsEntityDead(dog_ent) or IsEntityDead(cache.ped) or not action.tracking then
            return
        end
        
        local track = people[selected]
        if track then
            local dogpos = GetEntityCoords(dog_ent)

            local dir = track.pos - dogpos
            local yaw = math.atan2(-dir.x, dir.y)
            local final = yaw * RAD2DEG

            local compass = Compass(final)
            local far = math.floor(#(dogpos - track.pos))
            DrawText3D(dogpos.x, dogpos.y, dogpos.z + 1.0, string.format(lang.track_hint, selected, compass, far), true)

            ShowHelpNotification(lang.track_action) 
            if IsControlJustPressed(0, 174) then
                if selected == 1 then selected = max else selected -= 1 end
                track = people[selected]
                TaskTurnPedToFaceCoord(dog_ent, track.pos.x, track.pos.y, track.pos.z, -1)

            elseif IsControlJustPressed(0, 175) then
                if selected == #people then selected = 1 else selected += 1 end
                track = people[selected]
                TaskTurnPedToFaceCoord(dog_ent, track.pos.x, track.pos.y, track.pos.z, -1)

            elseif IsControlJustPressed(0, 38) then
                local speed = (not CFG.LVL_SYSTEM.DISABLE and CFG.LVL_SYSTEM.LVLS[data.stats.lvl].tracking_speed) or settings.speed
                local stopping_range = 5.0
                TaskFollowNavMeshToCoord(dog_ent, track.pos.x, track.pos.y, track.pos.z, speed, -1, stopping_range, true, 0)
                SetPedKeepTask(dog_ent, true)

                SetTimeout(settings.cooldown * 1000 * 60, function() action.tracking = false end)
                return
            end

            if IsEntityDead(dog_ent) or not DoesEntityExist(dog_ent) then action.tracking = false return end
        end
    end
end

-- change style --
function SET_RANDOM_COMPONENTS()
    if not DoesEntityExist(dog_ent) then return end
    SetPedRandomComponentVariation(dog_ent, 0)
    SetPedRandomProps(dog_ent)
end

-- get available appearance --
function GET_AVAILABLE_APPEARANCE()
    if not DoesEntityExist(dog_ent) then return end

    -- get total drawables from components and total textures of each drawable
    local componentIds = {0,1,2,3,4,5,6,7,8,9,10,11}
    local components = {}
    for k, id in pairs(componentIds) do
        local total = GetNumberOfPedDrawableVariations(dog_ent, id)
        if total > 0 then
            for drawable = total, 0, -1 do 
                local textures = GetNumberOfPedTextureVariations(dog_ent, id, drawable)
                if textures > 0 then
                    components[#components+1] = { 
                        componentId = id, 
                        drawableId = drawable,
                        totalTextures = textures,
                    }
                end
            end
        end
    end

    return components
end

function GET_CURRENT_APPEARANCE()
    if not DoesEntityExist(dog_ent) then return end

    local skin = {}
    local componentIds = {0,1,2,3,4,5,6,7,8,9,10,11}

    for _, id in pairs(componentIds) do
        local drawable = GetPedDrawableVariation(dog_ent, id)
        local texture = GetPedTextureVariation(dog_ent, id)
        local palette = GetPedPaletteVariation(dog_ent, id)
        skin[#skin+1] = {component = id, drawable = drawable, texture = texture, palette = palette}
    end

    return skin
end

function LOAD_APPEARANCE()
    if not data.appearance then return end
    for k, v in pairs(data.appearance) do
        SetPedComponentVariation(dog_ent, v.component, v.drawable, v.texture, v.palette)
    end
end

-- POO AND PEE
local function PEE()
    loadPtfxAsset("scr_amb_chop") UseParticleFxAssetNextCall("scr_amb_chop")
    PlayAnimation(dog_ent, "creatures@rottweiler@move", "pee_right_enter", 2)
    Wait(1500)
    local pfxW = StartParticleFxLoopedOnEntity("ent_anim_dog_peeing", dog_ent, 0.1, -0.32, -0.04, 0.0, 0.0, 30.0, 1.0, false, false, false)
    PlayAnimation(dog_ent, "creatures@rottweiler@move", "pee_right_idle", 2)
    Wait(1000 * math.random(3,6))
    PlayAnimation(dog_ent, "creatures@rottweiler@move", "pee_right_exit", 2)
    StopParticleFxLooped(pfxW, 0)
end

local function POO()
    loadPtfxAsset("scr_amb_chop") UseParticleFxAssetNextCall("scr_amb_chop")
    PlayAnimation(dog_ent, "creatures@rottweiler@move", "dump_enter", 2)
    Wait(6000)
    local pfxW = StartParticleFxLoopedOnEntity("ent_anim_dog_poo", dog_ent, 0.0, -0.15, -0.2, 0.0, 0.0, 0.0, 1.0, false, false, false)
    PlayAnimation(dog_ent, "creatures@rottweiler@move", "dump_loop", 2)
    Wait(3000)
    PlayAnimation(dog_ent, "creatures@rottweiler@move", "dump_exit", 2)
    StopParticleFxLooped(pfxW, 0)
end

-- CLEAR K9 STUFF COMPLETELY --
local function COMPLETE_CLEAN_UP()
    if DoesEntityExist(dog_ent) then DeleteEntity(dog_ent) end
    if DoesEntityExist(house) then DeleteEntity(house) end
    if DoesEntityExist(ballObj) then DeleteEntity(ballObj) end
    data, dog_id = nil, nil
    dog_ent, dog_id, house, ballObj = nil, nil, nil, nil
end

-- damage event check --
AddEventHandler('gameEventTriggered', function(event, eventData)
    if not dog_ent then return end
    if event ~= "CEventNetworkEntityDamage" then return end

    local victim, attacker, victim_died, weapon = eventData[1], eventData[2], eventData[6], eventData[7]
    --print(victim, attacker, victim_died, weapon)

    if victim == dog_ent and victim_died == 0 then -- IF DOG GETS ATTACKED
        if not NetworkHasControlOfEntity(dog_ent) then REQUEST_CONTROL() end
        
        local damageType = GetWeaponDamageType(weapon)
        if damageType == 2 then -- if meele attack
            if not attacking then
                if IsEntityAPed(attacker) then
                    if IsPedAPlayer(attacker) then
                        local player = GetPlayerFromServerId(GetPlayerId(attacker))
                        SetCanAttackFriendly(dog_ent, true, true)
                        TaskPutPedDirectlyIntoMelee(dog_ent, GetPlayerPed(player), 0.0, -1.0, 0.0, 0)
                    else
                        SetCanAttackFriendly(dog_ent, true, true)
                        TaskPutPedDirectlyIntoMelee(dog_ent, attacker, 0.0, -1.0, 0.0, 0)
                    end
                end
            end
        end
    elseif attacker == dog_ent then -- TACKLE LOGIC
        if not CFG.SETTINGS.TACKLE.enable or not action.attacking or victim_died ~= 0 then return end

        if IsEntityAPed(victim) and IsPedAPlayer(victim) then
            local chance = math.random(0, 100)
            local tackleChance = (not CFG.LVL_SYSTEM.DISABLE and CFG.LVL_SYSTEM.LVLS[data.stats.lvl].tackle_chance) or CFG.SETTINGS.TACKLE.chance

            --print(chance, tackleChance, chance >= tackleChance)
            if chance >= tackleChance then return end

            TriggerServerEvent('sh-k9:sv:TackleAction', GetPlayerId(victim), NetworkGetNetworkIdFromEntity(dog_ent))
            ADD_XP() -- for successful tackle

            Wait(2500) -- delay for ragdoll
            SetEntityHeadingLookAt(dog_ent, victim) 
            PlayAnimation(dog_ent, "creatures@rottweiler@amb@world_dog_barking@idle_a", "idle_a", 1)
        end
    end
end)

-- THREADS --
local function LOAD_LOOPS()
    if looping then return end
    looping = true

    -- ATTACK AND GO THREAD
    CreateThread(function()
        local delete = CFG.SETTINGS.DELETE_DOG
        while looping do
            local idle = 1500

            if DoesEntityExist(dog_ent) then
                idle = 0
                if IsControlJustPressed(0, CFG.CONTROLS.aim.attack) then
                    if not cache.vehicle and HasAccess() and not action.tracking then
                        if IsPlayerFreeAiming(PlayerId()) then
                            local bool, target = GetEntityPlayerIsFreeAimingAt(PlayerId())
                            if bool then
                                if IsEntityAPed(target) then
                                    if not IsEntityDead(target) and not IsPedInAnyVehicle(target) then
                                        TOGGLE_ATTACK(target)
                                    end
                                end
                            end
                        end
                    end
                end

                if IsControlJustPressed(0, CFG.CONTROLS.aim.go) then
                    if not cache.vehicle and HasAccess() and not action.tracking then
                        if IsPlayerFreeAiming(PlayerId()) then
                            local hit, coords, entity = RayCastGamePlayCamera(1000.0)
                            if hit then
                                if DOG_FOLLOWS_ORDER() then
                                    action.following, action.attacking = false, false

                                    local position = GetEntityCoords(cache.ped)
                                    DrawLine(position.x, position.y, position.z, coords.x, coords.y, coords.z, 255, 255, 255, 255)
                                    TaskFollowNavMeshToCoord(dog_ent, coords.x, coords.y, coords.z, 5.0, -1, 1.0, true, 0)
                                    SetPedKeepTask(dog_ent, true)
                                    Notify(lang.go, 'success', 3000)
                                end
                            end
                        end
                    end
                end

                -- DOG DELETATION, IF OWNER IS DEAD OR DOG IS DEAD
                if delete.dog_dead or delete.owner_dead then 
                    if (delete.dog_dead and IsEntityDead(dog_ent)) or (delete.owner_dead and IsEntityDead(cache.ped))  then 
                        Wait(1000)
                        SPAWN_K9(data.dogHash) 
                        Notify(lang.dog_died, 'error', 3500)
                    end 
                end
            end
            Wait(idle)
        end
    end)

    -- STATUS THREAD
    CreateThread(function()
        local feed_status = status.feed
        while looping do
            if DoesEntityExist(dog_ent) then

                if not IsEntityDead(dog_ent) then
                    local stats = data.stats
                    stats.thirst -= math.random(feed_status.thirst.from * 10, feed_status.thirst.to * 10) / 10
                    stats.hunger -= math.random(feed_status.hunger.from * 10, feed_status.hunger.to * 10) / 10 

                    if stats.hunger <= feed_status.warning then 
                        Notify(lang.starving, 'error', 3500) 
                        if feed_status.get_damaged then ApplyDamageToPed(dog_ent, math.random(1, 5), false) end
                    end

                    if stats.hunger <= feed_status.warning then 
                        Notify(lang.thirsty, 'error', 3500) 
                        if feed_status.get_damaged then ApplyDamageToPed(dog_ent, math.random(1, 5), false) end
                    end

                    if feed_status.peeing or feed_status.pooping then
                        if current_feedAmount >= required_feedAmount then
                            if not peeing then
                                if not (action.feeding or action.searching or action.fetching or action.attacking) then  

                                    if action.inHouse then
                                        GO_INTO_HOUSE() -- get out automatically
                                        Wait(3500)
                                    elseif action.following then
                                        action.following = false
                                    end

                                    current_feedAmount = 0
                                    peeing = true

                                    if feed_status.peeing and feed_status.pooping then
                                        if stats.thirst >= stats.hunger then 
                                            PEE() 
                                        else 
                                            POO() 
                                        end
                                    elseif feed_status.peeing then
                                        PEE()
                                    else
                                        POO()
                                    end
                                    peeing = false
                                end
                            end
                        end
                    end
                end
            end
            Wait(10000)
        end
    end)
end LOAD_LOOPS() -- load loops

--[[ CreateThread(function()
    while true do
        if DoesEntityExist(dog_ent) then
            print('go to coord - ', GetIsTaskActive(dog_ent, 224)) -- works

            --print('follow navmesh - ', GetIsTaskActive(dog_ent, 238))
        end
        Wait(250)
    end
end) ]]

-- COMMANDS --
local commands = CFG.COMMANDS
local keybinds = commands.BINDING_SYSTEM

if keybinds.enable then
    for _, v in pairs(keybinds.commands) do
        RegisterKeyMapping(v.command, v.label, 'keyboard', v.key)
    end
end

if not commands.disable then
    -- register new dog --
    RegisterCommand(commands['register_dog'], function()
        local result = lib.callback.await('sh-k9:CB:GET_DOGS', false)
        if result and next(result) then
            dogAmount = #result
            OPEN_REGISTRATION()
        end
    end)

    -- k9 menu --
    RegisterCommand(commands['main_menu'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        OPEN_K9_MENU()
    end)

    -- save --
    RegisterCommand(commands['save_dog'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        if not data then return end

        local appearance = GET_CURRENT_APPEARANCE()
        TriggerServerEvent('sh-k9:sv:SaveDog', data, dog_id, appearance) 
        Notify(lang.saved, 'success', 3000) 
    end)

    -- check dog --
    RegisterCommand(commands['check_dog'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        CHECK_DOG()
    end)

    -- spawn --
    RegisterCommand(commands['spawn'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        SPAWN_K9(data.dogHash) 
    end)

    -- follow --
    RegisterCommand(commands['follow'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        FOLLOW()
    end)

    -- track all --
    RegisterCommand(commands['track'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        TRACKING_ALL()
    end)

    -- track one -- 
    RegisterCommand(commands['track_player'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        TRACKING_PLAYER()
    end)

    -- getin --
    RegisterCommand(commands['vehicle'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        TOGGLE_VEHICLE()
    end)

    -- ball --
    RegisterCommand(commands['ball'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        GET_BALL()
    end)

    -- fetch --
    RegisterCommand(commands['fetch'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        FETCH_BALL()
    end)

    -- search player --
    RegisterCommand(commands['search_player'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        SEARCH_PLAYER()
    end)

    -- search vehicle --
    RegisterCommand(commands['search_car'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        SEARCH_VEHICLE()
    end)

    -- feed --
    RegisterCommand(commands['feed'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        FEED()
    end)

    -- heal --
    RegisterCommand(commands['heal'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        HEAL_OR_ARMOR('heal')
    end)

    -- armor --
    RegisterCommand(commands['armor'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        HEAL_OR_ARMOR('armor')
    end)

    -- reselect k9 --
    RegisterCommand(commands['reselect'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        if not data then return end

        ESX.UI.Menu.CloseAll()

        data.stats.thirst = round(data.stats.thirst, 1)
        data.stats.hunger = round(data.stats.hunger, 1)

        local appearance = GET_CURRENT_APPEARANCE()
        
        if dog_ent then SPAWN_K9(data.dogHash) end
        TriggerServerEvent('sh-k9:sv:SaveDog', data, dog_id, appearance)

        data, dog_id = nil, nil
        Wait(500) -- saving delay
        OPEN_K9_MENU()
    end)

    -- carry dog --
    RegisterCommand(commands['carry'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        CARRY_DOG()
    end)

    -- camera --
    if not CFG.SETTINGS.CAMERA.disable then
        RegisterCommand(commands['toggle_camera'], function()
            if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
            DOG_CAMERA()
        end)

        RegisterCommand(commands['mount_camera'], function(source, args)
            if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
            MOUNT_CAMERA()
        end)
    end

    -- animations --
    RegisterCommand(commands['animations'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        OPEN_ANIMATIONS()
    end)

    -- sit --
    RegisterCommand(commands['sit'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        PlayAnimation(dog_ent, "creatures@rottweiler@amb@world_dog_sitting@idle_a", "idle_b", 2)
    end)

    -- laydown --
    RegisterCommand(commands['laydown'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        PlayAnimation(dog_ent, "creatures@rottweiler@amb@sleep_in_kennel@", "sleep_in_kennel", 2)
    end)

    -- bark --
    RegisterCommand(commands['bark'], function()
        if not HasAccess() then return Notify(lang.required_job, 'error', 5000) end
        PlayAnimation(dog_ent, "creatures@rottweiler@amb@world_dog_barking@idle_a", "idle_a", 1)
    end)
end

-- EVENTS --
RegisterNetEvent('sh-k9:cl:TackleAction', function(netId)
    local settings = CFG.SETTINGS.TACKLE

    if not settings.enable or tackled then return end
    tackled = true

    local attacker = nil
    if netId and NetworkDoesEntityExistWithNetworkId(netId) then
        attacker = NetworkGetEntityFromNetworkId(netId)
    end

    CreateThread(function()
        while tackled do
            Wait(0)
            DisableControls()
        end
    end)

    CreateThread(function()
        if settings.type == 1 then
            ClearPedTasksImmediately(cache.ped)
            if DoesEntityExist(attacker) then SetEntityHeadingLookAt(cache.ped, GetEntityHeading(attacker) - 180.0) end 
            PlayAnimation(cache.ped, 'missfra0_chop_find', 'fra_0_ig_chop_take_down_balla_victim', 2)
        end

        while tackled do
            Wait(0)

            if settings.type == 2 then -- ragdoll
                SetPedToRagdoll(cache.ped, 500, 500, 0, 0, 0, 0)
                ResetPedRagdollTimer(cache.ped)
            end

            ShowHelpNotification(lang.get_up)
            if IsControlJustReleased(0, 38) then
                SetPedToRagdoll(cache.ped, 500, 500, 0, 0, 0, 0)
                ResetPedRagdollTimer(cache.ped)
                tackled = false
            end

            if IsEntityDead(cache.ped) then
                tackled = false
            end
        end
    end)

    -- ANIM CHECKS
    Wait(3500) -- anim delay
    CreateThread(function()
        while tackled do

            -- play downed anim
            if settings.type == 1 then
                if not IsEntityPlayingAnim(cache.ped, 'combat@damage@writheidle_b', 'writhe_idle_d', 3) then
                    ClearPedTasksImmediately(cache.ped)
                    PlayAnimation(cache.ped, 'combat@damage@writheidle_b', 'writhe_idle_d', 1)
                    if DoesEntityExist(attacker) then SetEntityHeadingLookAt(cache.ped, GetEntityHeading(attacker) - 90.0) end 
                end
            end

            if IsEntityPlayingAnim(cache.ped, "mp_arresting", "idle", 3) then
                if settings.type == 1 then
                    StopAnimTask(cache.ped, 'combat@damage@writheidle_b', 'writhe_idle_d', 3.0)
                end
                tackled = false
            end

            Wait(100)
        end
    end)
end)

RegisterNetEvent('sh-k9:cl:OpenK9', function() ExecuteCommand(commands['main_menu']) end)

AddEventHandler('onResourceStop', function(resource) 
    if resource ~= GetCurrentResourceName() then return end
    COMPLETE_CLEAN_UP()
end)

if CFG.FRAMEWORK == 'QBCore' or CFG.FRAMEWORK == 'QBX' then
    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
        if not data then return end
        COMPLETE_CLEAN_UP()
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        if not data then return end
        COMPLETE_CLEAN_UP()
    end)

elseif CFG.FRAMEWORK == 'ESX' or CFG.FRAMEWORK == 'ESXOLD' then
    RegisterNetEvent('esx:setJob', function(job)
        if not data then return end
        COMPLETE_CLEAN_UP()
    end)

    if CFG.FRAMEWORK == 'ESX' then
        RegisterNetEvent('esx:onPlayerLogout', function()
            if not data then return end
            COMPLETE_CLEAN_UP()
        end)
    end
end


-- EXPORTS --
exports('K9_MENU', function()
    OPEN_K9_MENU()
end)

exports('ATTACK', function(target)
    if not dog_ent then return end
    TOGGLE_ATTACK(target)
end)

exports('TOGGLE_CAMERA', function()
    if not dog_ent then return end
    DOG_CAMERA()
end)

exports('CLEAR_TASKS', function()
    if not dog_ent then return end
    action = { -- reset certain actions
        following = false, 
        attacking = false, 
        searching = false, 
        fetching = false, 
        feeding = false, 
        inHouse = false, 
        tracking = false, 
        carry = false, 
        hasCamera = false, 
        usingCamera = false, 
    }
    ClearPedTasks(dog_ent)
    --ClearPedTasksImmediately(dog_ent)
end)

exports('PLAY_ANIM', function(dict, anim, flags)
    if not dog_ent then return end
    PlayAnimation(dog_ent, dict, anim, flags)
end)

exports('PLAY_SOUND', function(name)
    if not dog_ent then return end
    -- bark GROWL SNARL BARK_SEQ 
    PlayAnimalVocalization(dog_ent, 3, name)
end)

exports('SET_MOOD', function(int)
    if not dog_ent then return end
    -- 0 normal, 1 tired/sad
    SetAnimalMood(dog_ent, int)
end)

exports('IS_TACKLED', function()
    return tackled
end)





-- DEV COMMANDS --

--[[ RegisterCommand('trysome', function(source, args)
    PlayAnimalVocalization(dog_ent, 3, args[1])
    -- bark GROWL SNARL BARK_SEQ 
end) ]]

--[[ RegisterCommand('trysome', function(source, args)
    SetAnimalMood(dog_ent, tonumber(args[1])) -- 0 or 1
    -- 1 worse mood
    -- 0 normal
end)
 ]]

--[[ RegisterCommand('trysome', function(source, args)
    
    -- creatures@rottweiler@amb@
    --     hump_enter_chop
    --     hump_enter_ladydog
    --     hump_exit_chop
    --     hump_exit_ladydog
    --     hump_loop_chop
    --     hump_loop_ladydog

    -- jumping animations
        -- missfra0_chop_fchase -- dict
        --     fra_0_chop_jumps_down
        --     fra_0_ig_10_chop_jumps_over_flatbed
        --     fra_0_ig_11_chop_jumps_through_boxcar
        --     fra_0_ig_8_p1_chop_jumps_under_fence
        --     fra_0_ig_9_chop_jump_over_car_hood
        
    -- "missfra0_chop_find" fra0_ig_14_chop_sniff_fwds -- track anim
    PlayAnimation(dog_ent, args[1], args[2], 2)
end) ]]

--[[ RegisterCommand('trysome', function(source, args)
    PlayAnimation(cache.ped, args[1], args[2], 2)
end)
 ]]

--[[ RegisterCommand('trysome', function(source, args)
    JUMP_UNDER()
end)

function JUMP_UNDER()
    PlayAnimation(dog_ent, 'missfra0_chop_fchase', 'fra_0_ig_8_p1_chop_jumps_under_fence', 2)
    Wait(2000)
    ClearPedTasks(dog_ent)
end
 ]]
