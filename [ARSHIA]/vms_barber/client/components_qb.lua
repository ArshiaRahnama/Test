if (Config.Core ~= 'QB-Core' or Config.SkinManager ~= 'qb-clothing') then
    return
end

Character_QB = {}

function qbcore_switcher(type, number)
    local number = tonumber(number)
    if type == "hair_1" then Character_QB['hair'].item = number
    elseif type == "hair_color_1" then Character_QB['hair'].texture = number
    elseif type == "beard_1" then Character_QB['beard'].item = number
    elseif type == "beard_3" then Character_QB['beard'].texture = number
    elseif type == "makeup_1" then Character_QB['makeup'].item = number
    elseif type == "makeup_3" then Character_QB['makeup'].texture = number
    elseif type == "lipstick_1" then Character_QB['lipstick'].item = number
    elseif type == "lipstick_3" then Character_QB['lipstick'].texture = number
    elseif type == "eye_color" then Character_QB['eye_color'].item = number
    elseif type == "eyebrows_1" then Character_QB['eyebrows'].item = number
    elseif type == "eyebrows_3" then Character_QB['eyebrows'].texture = number
    elseif type == "blush_1" then Character_QB['blush'].item = number
    elseif type == "blush_3" then Character_QB['blush'].texture = number
    end
    updateValue()
end

function updateValue()
    local myPed = PlayerPedId()
    SetPedComponentVariation(myPed, 2, Character_QB["hair"].item, 0, 0)
    SetPedHairColor(myPed, Character_QB["hair"].texture, Character_QB["hair"].texture)

    SetPedHeadOverlay(myPed, 1, Character_QB['beard'].item, 1.0)
    SetPedHeadOverlayColor(myPed, 1, 1, Character_QB['beard'].texture, 0)

    SetPedHeadOverlay(myPed, 8, Character_QB["lipstick"].item, 1.0)
    SetPedHeadOverlayColor(myPed, 8, 1, Character_QB["lipstick"].texture, 0)

    SetPedHeadOverlay(myPed, 4, Character_QB["makeup"].item, 1.0)
    SetPedHeadOverlayColor(myPed, 4, 1, Character_QB["makeup"].texture, 0)

    SetPedHeadOverlay(myPed, 2, Character_QB["eyebrows"].item, 1.0)
    SetPedHeadOverlayColor(myPed, 2, 1, Character_QB["eyebrows"].texture, 0)

    SetPedEyeColor(myPed, Character_QB['eye_color'].item)

    SetPedHeadOverlay(myPed, 5, Character_QB["blush"].item, 1.0)
    SetPedHeadOverlayColor(myPed, 5, 1, Character_QB["blush"].texture, 0)
end