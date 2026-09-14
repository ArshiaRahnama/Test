-- Only the countdown timer still lives in this resource's own NUI (the
-- vehicle picker / confirm step moved to ox_lib's context menu + alert
-- dialog -- see functions/main.lua). This callback fires when the timer's
-- JS counts down to 0.
RegisterNUICallback("finish", function(data, cb)
    finish()
    cb(1)
end)
