local show3DText = true

RegisterNetEvent("pixel_antiCL:show")
AddEventHandler("pixel_antiCL:show", function()
    if show3DText then
        show3DText = false
    else
        show3DText = true
        if Config.AutoDisableDrawing then
            if tonumber(Config.AutoDisableDrawing) then
                Citizen.Wait(Config.AutoDisableDrawingTime)
            else
                Citizen.Wait(15000)
            end
            show3DText = false
        end
    end
end)

RegisterNetEvent("pixel_anticl")
AddEventHandler("pixel_anticl", function(id, name, crds, identifier, reason)
    Display(id, name, crds, identifier, reason)
end)

function Display(id, name, crds, identifier, reason)
    local displaying = true

    Citizen.CreateThread(function()
        Wait(Config.DrawingTime)
        displaying = false
    end)




            local pcoords = GetEntityCoords(PlayerPedId())

            if #(vector3(crds.x, crds.y, crds.z) - vector3(pcoords.x, pcoords.y, pcoords.z)) < 40.0 then



                TriggerEvent("chatMessage", "^1[SYSTEM]^0", {0, 0, 0}, "^0Player ^2"..name.." ^0 ID: ^2"..id.. " ^0 Reason: ^1"..reason)



            end


end

function DrawText3DSecondAC(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.45, 0.45)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(Config.AlertTextColor.r, Config.AlertTextColor.g, Config.AlertTextColor.b, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

function DrawText3DAC(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.45, 0.45)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(Config.TextColor.r, Config.TextColor.g, Config.TextColor.b, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end