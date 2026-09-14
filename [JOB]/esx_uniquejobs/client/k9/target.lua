local lang = CFG.LANG

-- ADD TARGET OPTIONS
-- Quick-access menu when targeting the dog itself with ox_target/qb-target/
-- qtarget - covers the same actions as the F6 K9 menu, minus the ones that
-- don't make sense to trigger by targeting an already-spawned dog
-- (Register, Reselect, full Appearance editor - those stay in the F6 menu).
function ADD_THIRD_EYE()
    local third_eye_options = {
        {
            icon = "fas fa-paw",
            label = lang.follow ..' | '.. lang.stop,
            distance = 2.0,
            action = function(entity) FOLLOW() end,
            onSelect = function(entity) FOLLOW() end,
            canInteract = function(entity)
                if IsEntityDead(dog_ent) then return false end
                return true
            end,
        },
        {
            icon = "fas fa-car",
            label = lang.get_in ..' | '.. lang.get_out,
            distance = 2.0,
            action = function(entity) TOGGLE_VEHICLE() end,
            onSelect = function(entity) TOGGLE_VEHICLE() end,
            canInteract = function(entity)
                if IsEntityDead(dog_ent) then return false end
                return true
            end,
        },
        {
            icon = "fas fa-route",
            label = lang.track,
            distance = 2.0,
            action = function(entity) TRACKING_ALL() end,
            onSelect = function(entity) TRACKING_ALL() end,
            canInteract = function(entity)
                if IsEntityDead(dog_ent) then return false end
                return true
            end,
        },
        {
            icon = "fas fa-crosshairs",
            label = lang.track_player,
            distance = 2.0,
            action = function(entity) TRACKING_PLAYER() end,
            onSelect = function(entity) TRACKING_PLAYER() end,
            canInteract = function(entity)
                if IsEntityDead(dog_ent) then return false end
                return true
            end,
        },
        {
            icon = "fas fa-user-secret",
            label = lang.search_ped,
            distance = 2.0,
            action = function(entity) SEARCH_PLAYER() end,
            onSelect = function(entity) SEARCH_PLAYER() end,
            canInteract = function(entity)
                if IsEntityDead(dog_ent) then return false end
                return true
            end,
        },
        {
            icon = "fas fa-car-side",
            label = lang.search_veh,
            distance = 2.0,
            action = function(entity) SEARCH_VEHICLE() end,
            onSelect = function(entity) SEARCH_VEHICLE() end,
            canInteract = function(entity)
                if IsEntityDead(dog_ent) then return false end
                return true
            end,
        },
        {
            icon = "fas fa-heartbeat",
            label = lang.check_dog,
            distance = 2.0,
            action = function(entity) CHECK_DOG() end,
            onSelect = function(entity) CHECK_DOG() end,
            canInteract = function(entity)
                if IsEntityDead(dog_ent) then return false end
                return true
            end,
        },
        {
            icon = "fas fa-bone",
            label = lang.feed_dog,
            distance = 2.0,
            action = function(entity) FEED() end,
            onSelect = function(entity) FEED() end,
            canInteract = function(entity)
                if IsEntityDead(dog_ent) then return false end
                return true
            end,
        },
        {
            icon = "fas fa-band-aid",
            label = lang.heal_dog,
            distance = 2.0,
            action = function(entity) HEAL_OR_ARMOR('heal') end,
            onSelect = function(entity) HEAL_OR_ARMOR('heal') end,
            canInteract = function(entity)
                if IsEntityDead(dog_ent) then return false end
                return true
            end,
        },
        {
            icon = "fas fa-shield-alt",
            label = lang.armor_dog,
            distance = 2.0,
            action = function(entity) HEAL_OR_ARMOR('armor') end,
            onSelect = function() HEAL_OR_ARMOR('armor') end,
            canInteract = function(entity)
                if IsEntityDead(dog_ent) then return false end
                return true
            end,
        },
        {
            icon = "fas fa-hand-holding-heart",
            label = lang.carry,
            distance = 2.0,
            action = function(entity) CARRY_DOG() end,
            onSelect = function(entity) CARRY_DOG() end,
            canInteract = function(entity)
                if IsEntityDead(dog_ent) then return false end
                return true
            end,
        },
        {
            icon = "fas fa-video",
            label = lang.animations,
            distance = 2.0,
            action = function(entity) OPEN_ANIMATIONS() end,
            onSelect = function(entity) OPEN_ANIMATIONS() end,
            canInteract = function(entity)
                if IsEntityDead(dog_ent) then return false end
                return true
            end,
        },
        {
            icon = "fas fa-dice",
            label = lang.dog_style,
            distance = 2.0,
            action = function(entity) SET_RANDOM_COMPONENTS() end,
            onSelect = function(entity) SET_RANDOM_COMPONENTS() end,
            canInteract = function(entity)
                if IsEntityDead(dog_ent) then return false end
                return true
            end,
        },
        {
            icon = "fas fa-paw",
            label = lang.spawn,
            distance = 2.0,
            action = function(entity) SPAWN_K9(data.dogHash) end,
            onSelect = function(entity) SPAWN_K9(data.dogHash) end,
            canInteract = function(entity)
                return true
            end,
        },
    }

    if not CFG.SETTINGS.CAMERA.disable then
        third_eye_options[#third_eye_options + 1] = {
            icon = "fas fa-camera",
            label = lang.mount_camera,
            distance = 2.0,
            action = function(entity) MOUNT_CAMERA() end,
            onSelect = function(entity) MOUNT_CAMERA() end,
            canInteract = function(entity)
                if IsEntityDead(dog_ent) then return false end
                return true
            end,
        }
    end

    if CFG.TARGET == 'qb-target' then
        exports['qb-target']:AddTargetEntity(dog_ent, {
            options = third_eye_options,
            distance = 2.0
        })
    elseif CFG.TARGET == 'qtarget' then
        exports['qtarget']:AddTargetEntity(dog_ent, {
            options = third_eye_options,
            distance = 2.0
        })
    elseif CFG.TARGET == 'ox_target' then
        exports.ox_target:addLocalEntity({
			entities = dog_ent,
			options = third_eye_options,
		})
    end
end
