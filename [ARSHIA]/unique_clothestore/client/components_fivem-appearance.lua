if (Config.SkinManager ~= 'fivem-appearance' and Config.SkinManager ~= 'illenium-appearance') then
    return
end

Character_AP = {}

function appearance_switcher(type, number)
    if type == "tshirt_1" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 8 then
                v.drawable = tonumber(number)
            end
        end
    elseif type == "tshirt_2" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 8 then
                v.texture = tonumber(number)
            end
        end
    elseif type == "torso_1" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 11 then
                v.drawable = tonumber(number)
            end
        end
    elseif type == "torso_2" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 11 then
                v.texture = tonumber(number)
            end
        end
    elseif type == "arms" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 3 then
                v.drawable = tonumber(number)
            end
        end
    elseif type == "arms_2" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 3 then
                v.texture = tonumber(number)
            end
        end
    elseif type == "pants_1" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 4 then
                v.drawable = tonumber(number)
            end
        end
    elseif type == "pants_2" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 4 then
                v.texture = tonumber(number)
            end
        end
    elseif type == "shoes_1" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 6 then
                v.drawable = tonumber(number)
            end
        end
    elseif type == "shoes_2" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 6 then
                v.texture = tonumber(number)
            end
        end
    elseif type == "decals_1" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 10 then
                v.drawable = tonumber(number)
            end
        end
    elseif type == "decals_2" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 10 then
                v.texture = tonumber(number)
            end
        end
    elseif type == "decals_1" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 10 then
                v.drawable = tonumber(number)
            end
        end
    elseif type == "decals_2" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 10 then
                v.texture = tonumber(number)
            end
        end
    elseif type == "arms" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 3 then
                v.drawable = tonumber(number)
            end
        end
    elseif type == "arms_2" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 3 then
                v.texture = tonumber(number)
            end
        end
    elseif type == "mask_1" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 1 then
                v.drawable = tonumber(number)
            end
        end
    elseif type == "mask_2" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 1 then
                v.texture = tonumber(number)
            end
        end
    elseif type == "bproof_1" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 9 then
                v.drawable = tonumber(number)
            end
        end
    elseif type == "bproof_2" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 9 then
                v.texture = tonumber(number)
            end
        end
    elseif type == "chain_1" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 7 then
                v.drawable = tonumber(number)
            end
        end
    elseif type == "chain_2" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 7 then
                v.texture = tonumber(number)
            end
        end
    elseif type == "bags_1" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 5 then
                v.drawable = tonumber(number)
            end
        end
    elseif type == "bags_2" then
        for k, v in pairs(Character_AP['components']) do
            if v.component_id == 5 then
                v.texture = tonumber(number)
            end
        end
    elseif type == "helmet_1" then
        for k, v in pairs(Character_AP['props']) do
            if v.prop_id == 0 then
                v.drawable = tonumber(number)
            end
        end
    elseif type == "helmet_2" then
        for k, v in pairs(Character_AP['props']) do
            if v.prop_id == 0 then
                v.texture = tonumber(number)
            end
        end
    elseif type == "glasses_1" then
        for k, v in pairs(Character_AP['props']) do
            if v.prop_id == 1 then
                v.drawable = tonumber(number)
            end
        end
    elseif type == "glasses_2" then
        for k, v in pairs(Character_AP['props']) do
            if v.prop_id == 1 then
                v.texture = tonumber(number)
            end
        end
    elseif type == "ears_1" then
        for k, v in pairs(Character_AP['props']) do
            if v.prop_id == 2 then
                v.drawable = tonumber(number)
            end
        end
    elseif type == "ears_2" then
        for k, v in pairs(Character_AP['props']) do
            if v.prop_id == 2 then
                v.texture = tonumber(number)
            end
        end
    elseif type == "watches_1" then
        for k, v in pairs(Character_AP['props']) do
            if v.prop_id == 6 then
                v.drawable = tonumber(number)
            end
        end
    elseif type == "watches_2" then
        for k, v in pairs(Character_AP['props']) do
            if v.prop_id == 6 then
                v.texture = tonumber(number)
            end
        end
    elseif type == "bracelets_1" then
        for k, v in pairs(Character_AP['props']) do
            if v.prop_id == 7 then
                v.drawable = tonumber(number)
            end
        end
    elseif type == "bracelets_2" then
        for k, v in pairs(Character_AP['props']) do
            if v.prop_id == 7 then
                v.texture = tonumber(number)
            end
        end
    end
    updateValue()
end

function updateValue()
    local myPed = PlayerPedId()
    for i=1, #Character_AP.components, 1 do
        if Character_AP.components[i].component_id ~= 2 then
            SetPedComponentVariation(myPed, Character_AP.components[i].component_id, Character_AP.components[i].drawable, 0, 2)
            SetPedComponentVariation(myPed, Character_AP.components[i].component_id, Character_AP.components[i].drawable, Character_AP.components[i].texture, 0)
        end
    end
    for i=1, #Character_AP.props, 1 do
        if Character_AP.props[i].drawable ~= -1 then
            SetPedPropIndex(myPed, Character_AP.props[i].prop_id, Character_AP.props[i].drawable, 0, true)
            SetPedPropIndex(myPed, Character_AP.props[i].prop_id, Character_AP.props[i].drawable, Character_AP.props[i].texture, true)
        else
            ClearPedProp(myPed, Character_AP.props[i].prop_id)
        end
    end
end