function saveUISetting()
    SetResourceKvp('inventory:setting', json.encode(settings))
end

RegisterNUICallback('inventory:blurState', function(state, cb)
    -- settings.blur = state == 'on'
    if state == 'on' then
        TriggerScreenblurFadeIn()
    else
        TriggerScreenblurFadeOut()
    end
    -- saveUISetting()
    cb('ok')
end)