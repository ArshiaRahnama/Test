if (Config.Core ~= 'QB-Core' or Config.SkinManager ~= 'qb-clothing') then
    return
end

Character_QB = {}

function qbcore_switcher(type, number)
    local number = tonumber(number)
    if type == "tshirt_1" then
        Character_QB['t-shirt'].item = number
    elseif type == "tshirt_2" then
        Character_QB['t-shirt'].texture = number
    elseif type == "torso_1" then
        Character_QB['torso2'].item = number
    elseif type == "torso_2" then
        Character_QB['torso2'].texture = number
    elseif type == "arms" then
        Character_QB['arms'].item = number
    elseif type == "arms_2" then
        Character_QB['arms'].texture = number
    elseif type == "pants_1" then
        Character_QB['pants'].item = number
    elseif type == "pants_2" then
        Character_QB['pants'].texture = number
    elseif type == "shoes_1" then
        Character_QB['shoes'].item = number
    elseif type == "shoes_2" then
        Character_QB['shoes'].texture = number
    elseif type == "bags_1" then
        Character_QB['bag'].item = number
    elseif type == "bags_2" then
        Character_QB['bag'].texture = number
    elseif type == "helmet_1" then
        Character_QB['hat'].item = number
    elseif type == "helmet_2" then
        Character_QB['hat'].texture = number
    elseif type == "mask_1" then
        Character_QB['mask'].item = number
    elseif type == "mask_2" then
        Character_QB['mask'].texture = number
    elseif type == "glasses_1" then
        Character_QB['glass'].item = number
    elseif type == "glasses_2" then
        Character_QB['glass'].texture = number
    elseif type == "watches_1" then
        Character_QB['watch'].item = number
    elseif type == "watches_2" then
        Character_QB['watch'].texture = number
    elseif type == "bracelets_1" then
        Character_QB['bracelet'].item = number
    elseif type == "bracelets_2" then
        Character_QB['bracelet'].texture = number
    elseif type == "decals_1" then
        Character_QB['decals'].item = number
    elseif type == "decals_2" then
        Character_QB['decals'].texture = number
    elseif type == "bproof_1" then
        Character_QB['vest'].item = number
    elseif type == "bproof_2" then
        Character_QB['vest'].texture = number
    elseif type == "ears_1" then
        Character_QB['ear'].item = number
    elseif type == "ears_2" then
        Character_QB['ear'].texture = number
    elseif type == "chain_1" then
        Character_QB['accessory'].item = number
    elseif type == "chain_2" then
        Character_QB['accessory'].texture = number
    end
    updateValue()
end

function updateValue()
    local myPed = PlayerPedId()

    SetPedComponentVariation(myPed, 1, Character_QB["mask"].item, 0, 2)
    SetPedComponentVariation(myPed, 1, Character_QB["mask"].item, Character_QB["mask"].texture, 0)

    SetPedComponentVariation(myPed, 3, Character_QB["arms"].item, 0, 2)
    SetPedComponentVariation(myPed, 3, Character_QB["arms"].item, Character_QB["arms"].texture, 0)

    SetPedComponentVariation(myPed, 4, Character_QB["pants"].item, 0, 2)
    SetPedComponentVariation(myPed, 4, Character_QB["pants"].item, Character_QB["pants"].texture, 0)

    SetPedComponentVariation(myPed, 5, Character_QB["bag"].item, 0, 2)
    SetPedComponentVariation(myPed, 5, Character_QB["bag"].item, Character_QB["bag"].texture, 0)

    SetPedComponentVariation(myPed, 6, Character_QB["shoes"].item, 0, 2)
    SetPedComponentVariation(myPed, 6, Character_QB["shoes"].item, Character_QB["shoes"].texture, 0)

    SetPedComponentVariation(myPed, 7, Character_QB["accessory"].item, 0, 2)
    SetPedComponentVariation(myPed, 7, Character_QB["accessory"].item, Character_QB["accessory"].texture, 0)

    SetPedComponentVariation(myPed, 8, Character_QB["t-shirt"].item, 0, 2)
    SetPedComponentVariation(myPed, 8, Character_QB["t-shirt"].item, Character_QB["t-shirt"].texture, 0)

    SetPedComponentVariation(myPed, 9, Character_QB["vest"].item, 0, 2)
    SetPedComponentVariation(myPed, 9, Character_QB["vest"].item, Character_QB["vest"].texture, 0)

    SetPedComponentVariation(myPed, 10, Character_QB["decals"].item, 0, 2)
    SetPedComponentVariation(myPed, 10, Character_QB["decals"].item, Character_QB["decals"].texture, 0)

    SetPedComponentVariation(myPed, 11, Character_QB["torso2"].item, 0, 2)
    SetPedComponentVariation(myPed, 11, Character_QB["torso2"].item, Character_QB["torso2"].texture, 0)

    if Character_QB["hat"].item ~= -1 and Character_QB["hat"].item ~= 0 then
        SetPedPropIndex(myPed, 0, Character_QB["hat"].item, Character_QB["hat"].texture, true)
    else
        ClearPedProp(myPed, 0)
    end

    if Character_QB["glass"].item ~= -1 and Character_QB["glass"].item ~= 0 then
        SetPedPropIndex(myPed, 1, Character_QB["glass"].item, Character_QB["glass"].texture, true)
    else
        ClearPedProp(myPed, 1)
    end

    if Character_QB["ear"].item ~= -1 and Character_QB["ear"].item ~= 0 then
        SetPedPropIndex(myPed, 2, Character_QB["ear"].item, Character_QB["ear"].texture, true)
    else
        ClearPedProp(myPed, 2)
    end

    if Character_QB["watch"].item ~= -1 and Character_QB["watch"].item ~= 0 then
        SetPedPropIndex(myPed, 6, Character_QB["watch"].item, Character_QB["watch"].texture, true)
    else
        ClearPedProp(myPed, 6)
    end

    if Character_QB["bracelet"].item ~= -1 and Character_QB["bracelet"].item ~= 0 then
        SetPedPropIndex(myPed, 7, Character_QB["bracelet"].item, Character_QB["bracelet"].texture, true)
    else
        ClearPedProp(myPed, 7)
    end
end