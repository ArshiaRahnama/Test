if (Config.SkinManager ~= 'illenium-appearance') then
    return
end

function appearance_switcher(type, number)
    local number = tonumber(number)
    if type == "hair_1" then Character_AP['hair'].style = number;
    elseif type == "hair_2" then Character_AP['hair'].texture = number;
    elseif type == "hair_color_1" then Character_AP['hair'].color = number;
    elseif type == "hair_color_2" then Character_AP['hair'].highlight = number;
    elseif type == "beard_1" then Character_AP['headOverlays'].beard.style = number;
    elseif type == "beard_2" then Character_AP['headOverlays'].beard.opacity = (number / 10) + 0.0;
    elseif type == "beard_3" then Character_AP['headOverlays'].beard.color = number;
    elseif type == "beard_4" then Character_AP['headOverlays'].beard.secondColor = number;
    elseif type == "eyebrows_1" then Character_AP['headOverlays'].eyebrows.style = number;
    elseif type == "eyebrows_2" then Character_AP['headOverlays'].eyebrows.opacity = (number / 10) + 0.0;
    elseif type == "eyebrows_3" then Character_AP['headOverlays'].eyebrows.color = number;
    elseif type == "makeup_1" then Character_AP['headOverlays'].makeUp.style = number;
    elseif type == "makeup_2" then Character_AP['headOverlays'].makeUp.opacity = (number / 10) + 0.0;
    elseif type == "makeup_3" then Character_AP['headOverlays'].makeUp.color = number;
    elseif type == "makeup_4" then Character_AP['headOverlays'].makeUp.secondColor = number;
    elseif type == "lipstick_1" then Character_AP['headOverlays'].lipstick.style = number;
    elseif type == "lipstick_2" then Character_AP['headOverlays'].lipstick.opacity = (number / 10) + 0.0;
    elseif type == "lipstick_3" then Character_AP['headOverlays'].lipstick.color = number;
    elseif type == "eye_color" then Character_AP['eyeColor'] = number;
    elseif type == "blush_1" then Character_AP['headOverlays'].blush.style = number;
    elseif type == "blush_2" then Character_AP['headOverlays'].blush.opacity = (number / 10) + 0.0;
    elseif type == "blush_3" then Character_AP['headOverlays'].blush.color = number;
    end
    Character_ESX[type] = tonumber(number)
    updateValue()
end

function updateValue()
    local myPed = PlayerPedId()

    SetPedComponentVariation(myPed, 2, Character_AP['hair'].style, Character_AP['hair'].texture, 2)
    SetPedHairColor(myPed, Character_AP['hair'].color, Character_AP['hair'].highlight)
    
    SetPedHeadOverlay(myPed, 1, Character_AP['headOverlays'].beard.style, Character_AP['headOverlays'].beard.opacity + 0.0)
    SetPedHeadOverlayColor(myPed, 1, 1, Character_AP['headOverlays'].beard.color, Character_AP['headOverlays'].beard.secondColor)

    SetPedHeadOverlay(myPed, 8, Character_AP['headOverlays'].lipstick.style, Character_AP['headOverlays'].lipstick.opacity + 0.0)
    SetPedHeadOverlayColor(myPed, 8, 2, Character_AP['headOverlays'].lipstick.color, Character_AP['headOverlays'].lipstick.secondColor)

    SetPedHeadOverlay(myPed, 4, Character_AP['headOverlays'].makeUp.style, Character_AP['headOverlays'].makeUp.opacity)
    SetPedHeadOverlayColor(myPed, 4, 2, Character_AP['headOverlays'].makeUp.color, Character_AP['headOverlays'].makeUp.secondColor)

	SetPedEyeColor(myPed, Character_AP['eyeColor'])

    SetPedHeadOverlay(myPed, 2, Character_AP['headOverlays'].eyebrows.style, Character_AP['headOverlays'].eyebrows.opacity + 0.0)
    SetPedHeadOverlayColor(myPed, 2, 1, Character_AP['headOverlays'].eyebrows.color, Character_AP['headOverlays'].eyebrows.secondColor)

    SetPedHeadOverlay(myPed, 5, Character_AP['headOverlays'].blush.style, Character_AP['headOverlays'].blush.opacity + 0.0)
	SetPedHeadOverlayColor(myPed, 5, 2,	Character_AP['headOverlays'].blush.color, Character_AP['headOverlays'].blush.secondColor)

end