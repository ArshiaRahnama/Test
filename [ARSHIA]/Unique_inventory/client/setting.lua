-- This Script Dump By FleeX Team  , discord.gg/2D79ZtUjxB

function saveUISetting()
    SetResourceKvp('inventory:setting', json.encode(settings))
end

RegisterNUICallback('inventory:blurState', function(state)
    -- settings.blur = state == 'on'
    if state == 'on' then
        TriggerScreenblurFadeIn()
    else
        TriggerScreenblurFadeOut()
    end
    -- saveUISetting()
end)