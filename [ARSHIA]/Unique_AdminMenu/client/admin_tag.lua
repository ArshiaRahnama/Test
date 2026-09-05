-- Floating name tag over on-duty admins, adapted from the uploaded
-- admintag.lua. The source list comes from the server (server/admin_tag.lua)
-- which re-derives it from IsOnDutyAdmin, so clients can't fake an entry.

local AdminTagSources = {}

RegisterNetEvent('Unique_AdminMenu:SyncAdminTags')
AddEventHandler('Unique_AdminMenu:SyncAdminTags', function(tags)
    AdminTagSources = tags or {}
end)

-- Tell the server whenever our own duty state flips, so it can recompute
-- and rebroadcast the list, and log the persistent duty session
-- (server/duty_log.lua).
AddEventHandler('esx_aduty:ChangeMenuStatus', function(isOnDuty)
    Citizen.SetTimeout(0, function()
        TriggerServerEvent('Unique_AdminMenu:UpdateAdminTag')
        TriggerServerEvent('Unique_AdminMenu:DutyLogToggle', isOnDuty and true or false)
    end)
end)

local function DrawText3D(x, y, z, text, r, g, b)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then return end

    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, true)
    local scale = (1 / dist) * 2 * ((1 / GetGameplayCamFov()) * 100)

    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(r, g, b, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(#AdminTagSources > 0 and 0 or 500)

        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)

        for _, tag in ipairs(AdminTagSources) do
            local playerIndex = GetPlayerFromServerId(tag.source)
            if playerIndex ~= -1 and playerIndex ~= PlayerId() then
                local ped = GetPlayerPed(playerIndex)
                if DoesEntityExist(ped) then
                    local coords = GetEntityCoords(ped)
                    local distance = #(myCoords - coords)
                    if distance < 80.0 and IsEntityVisible(ped) then
                        DrawText3D(coords.x, coords.y, coords.z + 1.1, GetPlayerName(playerIndex), 255, 215, 0)
                    end
                end
            end
        end
    end
end)
