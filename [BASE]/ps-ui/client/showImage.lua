

local function setDisplay(bool, img)
    DebugPrint("ShowImage called with " .. tostring(bool) .. " bool and " .. img .. " img")
    SendNUI("ShowImage", nil, {
        url = bool and img or nil,
        show = bool,
    }, true)
end

local function showImage(img)
    setDisplay(true, img)
end

RegisterNUICallback("showItemImage-callback", function(data, cb)
    setDisplay(false)
    SetNuiFocus(false, false)
    cb('ok')
end)

exports("ShowImage", showImage)