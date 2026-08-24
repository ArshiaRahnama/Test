ESX = nil
local isFBI = false
local isSpectating = false
local spectatingTarget = nil
local markerCoords = vector3(124.6018, -733.215, 242.15)
local markerCoords2 = vector3(125.0708, -732.377, 242.15)

local spectateData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(200)
    end

    local playerLoaded = false
    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        playerLoaded = true
    end)

    while not playerLoaded do
        Citizen.Wait(200)
    end

    CheckPlayerJob_cia()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    isFBI = (job.name == "cia")
end)

function CheckPlayerJob_cia()
    if ESX.PlayerData and ESX.PlayerData.job then
        isFBI = (ESX.PlayerData.job.name == "cia")
    else
        ESX.TriggerServerCallback('checkPlayerJob', function(result)
            isFBI = result
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if ESX ~= nil and ESX.GetPlayerData().job ~= nil then
            CheckPlayerJob_cia()
            break
        end
    end

    while true do
        Citizen.Wait(0)

        if isFBI then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - markerCoords)

            if distance < 5.0 then
                DrawMarker(1, markerCoords.x, markerCoords.y, markerCoords.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, nil, nil, false)

                if distance < 1.5 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ Press to open job spectate menu.")

                    if IsControlJustReleased(0, 38) then
                        OpenJobSelectionMenu_cia()
                    end
                end
            end
        end
    end
end)

function OpenJobSelectionMenu_cia()
    ESX.TriggerServerCallback('getCiaRank', function(grade)
        local elements = {}

        if grade >= 9 then
            elements = {
                { label = "Police", value = "police" },
                { label = "Sheriff", value = "sheriff" },
                { label = "Ambulance", value = "ambulance" },
                { label = "Mechanic", value = "mechanic" },
                { label = "Taxi", value = "taxi" },
                { label = "Weazel", value = "weazel" },
                { label = "MT", value = "mt" },
                { label = "CID", value = "cid" },
                { label = "Marshal", value = "marshal" },
                { label = "FBI", value = "fbi" },
                { label = "Judge", value = "judge" },
                { label = "DOA", value = "doa" },
            }
        elseif grade == 8 then
            elements = {
                { label = "MT", value = "mt" },
                { label = "Sheriff", value = "sheriff" },
                { label = "Police", value = "police" },
            }
        elseif grade == 7 then
            elements = { { label = "MT", value = "mt" } }
        elseif grade == 6 then
            elements = { { label = "Police", value = "police" } }
        elseif grade == 5 then
            elements = { { label = "Sheriff", value = "sheriff" } }
        elseif grade == 4 then
            elements = { { label = "Ambulance", value = "ambulance" } }
        elseif grade == 3 then
            elements = { { label = "Mechanic", value = "mechanic" } }
        elseif grade == 2 then
            elements = { { label = "Taxi", value = "taxi" } }
        elseif grade == 1 then
            elements = { { label = "Weazel", value = "weazel" } }
			end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_menu',
            { title = "Select Job", align = "top-left", elements = elements },
            function(data, menu)
                FetchOnlinePlayersByJob_cia(data.current.value)
                menu.close()
            end,
            function(data, menu)
                menu.close()
            end
        )
    end)
end

function FetchOnlinePlayersByJob_cia(job)
    ESX.TriggerServerCallback('getOnlinePlayersByJob', function(players)
        local elements = {}

        for _, player in pairs(players) do
            table.insert(elements, { label = string.gsub(player.name, "_", " ") .. " - " .. player.id, value = player.id })
        end

        if #elements == 0 then
            ESX.ShowNotification("No players online in this job ❌")
            return
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_list',
            { title = "Online Players (" .. job .. ")", align = "top-left", elements = elements },
            function(data, menu)
                SpectatePlayer_cia(data.current.value)
                menu.close()
            end,
            function(data, menu)
                menu.close()
            end
        )
    end, job)
end

function SpectatePlayer_cia(targetId)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, markerCoords2.x, markerCoords2.y, markerCoords2.z)
    TriggerServerEvent('cia_spectate:startSpectate', targetId)
end

RegisterNetEvent('cia_spectate:spectate')
AddEventHandler('cia_spectate:spectate', function(targetId, inventory, weapons, money, PLCash, PLName, JobName, JobLabel, JobGrade, GangName, GangLabel, GangGrade)
    local playerPed = GetPlayerPed(GetPlayerFromServerId(targetId))
    if DoesEntityExist(playerPed) then
        NetworkSetInSpectatorMode(true, playerPed)
        ESX.ShowNotification("Spectating 🔍 " .. GetPlayerName(GetPlayerFromServerId(targetId)))
        isSpectating = true
        spectatingTarget = targetId

        spectateData = {
            inventory = inventory,
            weapons = weapons,
            money = money,
            PLCash = PLCash,
            PLName = PLName,
            JobName = JobName,
            JobLabel = JobLabel,
            JobGrade = JobGrade,
            GangName = GangName,
            GangLabel = GangLabel,
            GangGrade = GangGrade
        }
    else
        ESX.ShowNotification("Player not found ❌")
    end
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/fow', 'Open Chat Room', {
        { name="ID", help="ID player mored nazar" },
    })

    TriggerEvent('chat:addSuggestion', '/fcw', 'Close Chat Room', {
    })

    TriggerEvent('chat:addSuggestion', '/fw', 'Cia Chat', {
        { name="Text", help="Matn Morede Nazar" },
    })

    TriggerEvent('chat:addSuggestion', '/ciacsp', 'Quit Spect', {
    })

    while true do
        Citizen.Wait(0)
        if isSpectating and IsControlJustPressed(0, 73) and isSpectating then
            OpenSpectateMenu_cia()
        end

        if IsControlJustPressed(0, 177) and isSpectating then
            StopSpectate_cia()
        end
    end
end)

function OpenSpectateMenu_cia()
    if not isSpectating then return end
    local elements = {
        { label = "Name: " .. spectateData.PLName, value = nil },
        { label = "Bank: $" .. spectateData.money, value = nil },
        { label = "Cash: $" .. spectateData.PLCash, value = nil },
        { label = "Job: " .. spectateData.JobName.." | "..spectateData.JobLabel.." | "..spectateData.JobGrade, value = nil },
        { label = "Gang: ".. spectateData.GangName.." | "..spectateData.GangLabel.." | "..spectateData.GangGrade, value = nil },
        { label = "-------Inventory------", value = nil }
    }


    for _, item in pairs(spectateData.inventory) do
        if item.count ~= 0 then
            table.insert(elements, { label = item.count .. "x " .. item.label, value = nil })
        end
    end
    table.insert(elements, { label = "-------Weapons------", value = nil })

    for _, weapon in pairs(spectateData.weapons) do
        table.insert(elements, { label = weapon.label , value = nil })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spectate_menu',
        { title = "Player Info", align = "top-left", elements = elements },
        function(data, menu)
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function SpectatePlayer_cia(targetId)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, markerCoords2.x, markerCoords2.y, markerCoords2.z)


    SetEntityVisible(playerPed, false, false)
    SetEntityAlpha(playerPed, 0, false)


    TriggerServerEvent('cia_spectate:startSpectate', targetId)
end

function StopSpectate_cia()
    local playerPed = PlayerPedId()


    NetworkSetInSpectatorMode(false, playerPed)
    isSpectating = false
    spectatingTarget = nil


    SetEntityCoords(playerPed, markerCoords2.x, markerCoords2.y, markerCoords2.z)


    SetEntityVisible(playerPed, true, false)
    ResetEntityAlpha(playerPed)


    ESX.ShowNotification("Stopped Spectating ❌")
end

RegisterCommand("ciacsp", function(source, args, rawCommand)
    if isSpectating then
        StopSpectate_cia()
    else
        ESX.ShowNotification("❌ You are not spectating anyone!")
    end
end, false)

RegisterNetEvent('cia_chat:receiveMessage')
AddEventHandler('cia_chat:receiveMessage', function(senderName, message, isfbi)
    if isfbi then
        TriggerEvent('chatMessage', "[CIA] ", {255, 0, 0}, message)
    else
        TriggerEvent('chatMessage', "["..senderName.."] ", {255, 0, 0}, message)
    end
end)

