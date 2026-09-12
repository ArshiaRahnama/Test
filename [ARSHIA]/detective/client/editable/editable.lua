--MMMMMMMM               MMMMMMMMIIIIIIIIII   SSSSSSSSSSSSSSS TTTTTTTTTTTTTTTTTTTTTTT
--M:::::::M             M:::::::MI::::::::I SS:::::::::::::::ST:::::::::::::::::::::T
--M::::::::M           M::::::::MI::::::::IS:::::SSSSSS::::::ST:::::::::::::::::::::T
--M:::::::::M         M:::::::::MII::::::IIS:::::S     SSSSSSST:::::TT:::::::TT:::::T
--M::::::::::M       M::::::::::M  I::::I  S:::::S            TTTTTT  T:::::T  TTTTTT
--M:::::::::::M     M:::::::::::M  I::::I  S:::::S                    T:::::T        
--M:::::::M::::M   M::::M:::::::M  I::::I   S::::SSSS                 T:::::T        
--M::::::M M::::M M::::M M::::::M  I::::I    SS::::::SSSSS            T:::::T        
--M::::::M  M::::M::::M  M::::::M  I::::I      SSS::::::::SS          T:::::T        
--M::::::M   M:::::::M   M::::::M  I::::I         SSSSSS::::S         T:::::T        
--M::::::M    M:::::M    M::::::M  I::::I              S:::::S        T:::::T        
--M::::::M     MMMMM     M::::::M  I::::I              S:::::S        T:::::T        
--M::::::M               M::::::MII::::::IISSSSSSS     S:::::S      TT:::::::TT      
--M::::::M               M::::::MI::::::::IS::::::SSSSSS:::::S      T:::::::::T      
--M::::::M               M::::::MI::::::::IS:::::::::::::::SS       T:::::::::T      
--MMMMMMMM               MMMMMMMMIIIIIIIIII SSSSSSSSSSSSSSS         TTTTTTTTTTT 

-- This function is responsible for drawing all the 3d texts ('Press [E] to prepare for an engine swap' e.g)
function Draw3DText(x, y, z, textInput, fontId, scaleX, scaleY)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, true)
    local scale = (1 / dist) * 20
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    SetTextScale(scaleX * scale, scaleY * scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end
