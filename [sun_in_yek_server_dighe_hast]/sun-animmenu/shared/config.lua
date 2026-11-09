-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Config = {
    ServerCallbacks = {}, -- Don't edit or change
    MenuAlign = "left", -- left, right
    MenuKey = {
        KeyMapping = {
            Enable = true,
            Key = 'F4'
        },
        NormalKey = {
            Enable = false,
            Key = 170 -- https://gist.github.com/FlokiTV/8372476722453cfb0ceabe9334204070
        },
        CloseKey = 27 -- https://www.toptal.com/developers/keycode
    },
    CanOpenMenu = function()
        if IsPedDeadOrDying(PlayerPedId(), true) or ESX.isDeadOrCuff() or not ESX.isEmoteMenuActive() or not canPlayEmote or LocalPlayer.state.reviveThread or LocalPlayer.state.lowFood then
            return false
        end
        return true
    end,
    PropTimeout = 2000,
    AllowMovement = true, -- By activating this, you enable the player to move while the menu is open.
    MaxDistanceForAnimPos = 15.0,
    CancelWalk = true, -- Resets movement type when using the /e c command
    EnableXtoCancel = true,  -- Set this to false if you have something else on X (default X), and then just use /e c to cancel emotes.
    CancelEmote = {
        KeyMapping = {
            Enable = true,
            Key = 'X' -- Get the button string here https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
        },
        NormalKey = {
            Enable = false,
            Key = 73 -- https://gist.github.com/FlokiTV/8372476722453cfb0ceabe9334204070
        }
    },
    EnableCloseButton = true,
    AllowedInCars = false, -- Set this if you really wanna disable emotes in cars, as of 1.7.2 they only play the upper body part if in vehicle
    -- Pointing
    Pointing = {
        Enable = false,
        KeyMapping = {
            Enable = true,
            Key = 'B' -- Get the button string here https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
        },
        NormalKey = {
            Enable = false,
            Key = 29 -- https://gist.github.com/FlokiTV/8372476722453cfb0ceabe9334204070
        }
    },
    -- Crouching
    CrouchingEnabled = true, -- Default Key (Left CTRL)
    -- Ragdoll
    Ragdoll = {
        Enable = false,
        KeyMapping = {
            Enable = true,
            Key = 'U' -- Get the button string here https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
        },
        NormalKey = {
            Enable = false,
            Key = 303 -- https://gist.github.com/FlokiTV/8372476722453cfb0ceabe9334204070
        }
    },
    Notify = function(text, length, type)
        ESX.notification('info', text)
    end,
    -- Hands Up (Hands Up key is same with CancelEmoteKey)
    EnableHandsUp = false,
    CanHandsup = function()
        -- Example usage for qb-policejob
        if GetResourceState('qb-policejob') == "started" then
            if exports['qb-policejob']:IsHandcuffed() then return false end
        end
        return true
    end,
    HandsupDisableControls = function()
        -- Example usage for qb-smallresources
        if GetResourceState('qb-smallresources') == "started" then
            exports['qb-smallresources']:addDisableControls({24, 25, 47, 58, 59, 63, 64, 71, 72, 75, 140, 141, 142, 143, 257, 263, 264})
        end
    end,
    HandsupEnableControls = function()
        -- Example usage for qb-smallresources
        if GetResourceState('qb-smallresources') == "started" then
            exports['qb-smallresources']:removeDisableControls({24, 25, 47, 58, 59, 63, 64, 71, 72, 75, 140, 141, 142, 143, 257, 263, 264})
        end
    end,
    -- Text UI Functions
    Create3DTextUIOnPlayer = function(name, data)
        exports['sun-textui']:create3DTextUIOnPlayers(name, data)
    end,
    Delete3DTextUIOnPlayer = function(name)
        exports['sun-textui']:delete3DTextUIOnPlayers(name, data)
    end,
    ShowTextUI = function(name, key)
        exports["sun-textui"]:displayTextUI(name, key)
    end,
    HideTextUI = function()
        exports["sun-textui"]:hideTextUI()
    end,
    EnablePlacedAnims = false,
    EnableERPAnims = false,
    EnableSyncedEmote = false,
    EnableAnimalAnims = false,
    AnimalPeds = {
        "a_c_boar",
        "a_c_cat_01",
        "a_c_chickenhawk",
        "a_c_chimp",
        "a_c_chop",
        "a_c_cormorant",
        "a_c_cow",
        "a_c_coyote",
        "a_c_crow",
        "a_c_deer",
        "a_c_dolphin",
        "a_c_fish",
        "a_c_hen",
        "a_c_humpback",
        "a_c_husky",
        "a_c_killerwhale",
        "a_c_mtlion",
        "a_c_pig",
        "a_c_pigeon",
        "a_c_poodle",
        "a_c_pug",
        "a_c_rabbit_01",
        "a_c_rat",
        "a_c_retriever",
        "a_c_rhesus",
        "a_c_rottweiler",
        "a_c_seagull",
        "a_c_sharkhammer",
        "a_c_sharktiger",
        "a_c_shepherd",
        "a_c_stingray",
        "a_c_westy"
    }
}