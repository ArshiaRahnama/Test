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

if Config.esxSettings.enabled then
    ESX = nil

    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj)
                ESX = obj
            end)
            Citizen.Wait(0)
        end

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

        ESX.PlayerData = ESX.GetPlayerData()
        playerJob = ESX.PlayerData.job.name
    end)

    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        ESX.PlayerData.job = job
        playerJob = job.name
    end)
end
