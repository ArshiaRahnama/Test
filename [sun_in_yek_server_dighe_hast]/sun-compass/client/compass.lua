-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = exports['essentialmode']:getObject()

local lastCompassHeading = "0"
local compassThread = false
local uiReady = false
RegisterNUICallback("uiReady", function()
    uiReady = true
end)

function showCompas()
    while not uiReady do
        Wait(1000)
    end
    if compassThread then return end
    compassThread = true
    SendNUIMessage({action = "open"})
    exports['sun-streetlabel']:setCompass(true)
    while compassThread do
        local camRot = GetGameplayCamRot(0)
        local heading = string.format("%.0f", (360.0 - ((camRot.z + 360.0) % 360.0)))
        if heading == '360' then heading = '0' end
        if lastCompassHeading ~= heading then
            SendNUIMessage({action = "update", heading = heading})
        end
        lastCompassHeading = heading
        Wait(20) -- recommended values 10-30
    end
    SendNUIMessage({action = "close"})
    exports['sun-streetlabel']:setCompass(false)
    compassThread = false
end

local function setCompass(state)
    if state then
        if not compassThread then
            showCompas()
        end
    else
        compassThread = false
    end
end


RegisterNetEvent('esx:playerLoaded', function()
    Wait(30000)
    setCompass(ESX.DoesHaveItem2('compass', 1))
end)

RegisterNetEvent('esx:updateInventory',function(label, count, name)
    Wait(1000)
    setCompass(ESX.DoesHaveItem2('compass', 1))
end)