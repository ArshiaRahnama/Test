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

if Config.qbSettings.enabled then
    if Config.qbSettings.useNewQBExport then
        QBCore = exports['qb-core']:GetCoreObject()
    end

    if QBCore.Functions.GetPlayerData() and QBCore.Functions.GetPlayerData().job then
        playerJob = QBCore.Functions.GetPlayerData().job.name
    end

    RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        playerJob = QBCore.Functions.GetPlayerData().job.name
    end)


    RegisterNetEvent('QBCore:Client:OnJobUpdate')
    AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
        playerJob = JobInfo.name
    end)
end
