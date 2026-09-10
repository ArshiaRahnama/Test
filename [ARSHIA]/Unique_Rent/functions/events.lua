RegisterNUICallback("rent",function(data)
    local model = data.model
    local duration = data.duration
    local location = data.location
    rent_vehicle(model, duration, location)
end)

RegisterNUICallback("finish",function(data)
    finish()

end)

RegisterNUICallback("CloseUI",function()
    close_ui()
end)
