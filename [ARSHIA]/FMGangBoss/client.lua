local totalplayer = 0
local onlineplayer = 0
local offlineplayer = 0
local shownBossMenu = false 
local OpenUi = false
local PlayerADDUI = {}
local Uiloaded= false 
local ESX = nil
PlayerData = {}
CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.ESX, function(obj) ESX = obj end)
        Wait(200)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent(Config.DefaultEvents['playerLoaded'])
AddEventHandler(Config.DefaultEvents['playerLoaded'], function(xplayer)
    PlayerData = xplayer
end)


RegisterNetEvent(Config.DefaultEvents['setGang'])
AddEventHandler(Config.DefaultEvents['setGang'], function(gang)
    PlayerData.gang = gang
end)

-- UTIL
local function CloseMenuFull()
    shownBossMenu = false
end

local function comma_value(amount)
    local formatted = amount
    while true do
        local k
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k == 0) then
            break
        end
    end
    return formatted
end
RegisterNUICallback('Uiloaded', function ()
    Uiloaded = true 

end)

RegisterNUICallback('close', function ()
    SetNuiFocus(false,false)
    OpenUi = false
    PlayerADDUI = {}
end)

RegisterNUICallback('back', function ()
    TriggerEvent('FMGangsBoss:client:OpenMenu')
end)

RegisterNUICallback('stash', function ()
    SetNuiFocus(false,false)
    OpenUi = false
    PlayerADDUI = {}
    ESX.TriggerServerCallback('FMGangs:GetPlayerData', function(data , Prof ) 
        TriggerEvent('For5M:OpenBossPanel' , { Name = data.name  , Rank = data.gang.grade_name , Profile = Prof } , data.gang.name)
    end)

end)

RegisterNUICallback('otf', function ()
    TriggerEvent('FMGangsBoss:client:Wardrobe')
    SetNuiFocus(false,false)
    OpenUi = false
    PlayerADDUI = {}
    SendNUIMessage({type = 'displaynone'})
    SendNUIMessage({type = 'clear'})
end)


RegisterNUICallback('money', function ()
    SendNUIMessage({type = 'moneypage'})
    ESX.TriggerServerCallback('FMGangsBoss:getmoney', function(cb)
        SendNUIMessage({
            type='editle',
            totalmoney=comma_value(cb)
        })
    end)
end)

RegisterNUICallback('witmoney', function (data)
    moneywit = tonumber(data.para)
    SetNuiFocus(false, false)
    OpenUi = false 
    PlayerADDUI = {}
    TriggerServerEvent("FMGangsBoss:server:withdrawMoney", moneywit)
  
    ESX.TriggerServerCallback('FMGangsBoss:getmoney', function(money)
        money = money
     ESX.TriggerServerCallback('FMGangBoss:getname', function(name , gang )
         SendNUIMessage({
             type = "changename",
             name = name,
             jobname = gang ,
             dec = 'Boss Action' ,
             money = money
         })
     end)
    end)
end)

RegisterNUICallback('deposit', function (data)
    money = tonumber(data.para)
    SetNuiFocus(false, false)
    OpenUi = false 
    PlayerADDUI = {}
    TriggerServerEvent("FMGangsBoss:server:depositMoney", money)
    ESX.TriggerServerCallback('FMGangsBoss:getmoney', function(money)
        money = money
        ESX.TriggerServerCallback('FMGangBoss:getname', function(name , gang )
            SendNUIMessage({
                type = "changename",
                name = name,
                jobname = gang  ,
                dec = 'Boss Action' ,
                money = money
            })       
        end)
    end)
end)
    
RegisterNUICallback('addrutbe', function (data)
    SetNuiFocus(false, false)
    OpenUi = false
    PlayerADDUI = {}
   
    ESX.TriggerServerCallback('FMGangs:GetGangsData', function(gangs,expire, Allmembers , MyGangMembers )
        for _, v in pairs(MyGangMembers['online']) do
            meslek = v.grade_number
           
            if tonumber(data.id )== tonumber(v.ID) then    
                data = {
                    cid = v.Hex,
                    grade = v.grade_number+1,
                    gradename = v.Name
                }
                TriggerServerEvent('FMGangsBoss:server:GradeUpdate',data)                 
            end
        end
    end)
end)

meslek = nil
RegisterNUICallback('removerutbe', function (data)
  
    SetNuiFocus(false, false)
    OpenUi = false
    PlayerADDUI = {}
  
    ESX.TriggerServerCallback('FMGangs:GetGangsData', function(gangs,expire, Allmembers , MyGangMembers )
  
        for _, v in pairs(MyGangMembers['online']) do
            meslek = v.grade_number

            if tonumber(data.id )== tonumber(v.ID) then     

                if  v.grade_number > 1 then
                    data = {
                        cid = v.Hex,
                        grade =  v.grade_number-1,
                        gradename = v.Name
                    }
                    TriggerServerEvent('FMGangsBoss:server:GradeUpdate',data)
                else 
                    TriggerEvent(Config.showNotification , 'grade Number can not be lowver then 1' )
                end 
            end
        end
    end)
end)

RegisterNUICallback('fireplayer', function (data)
    SetNuiFocus(false, false)
    OpenUi = false
    PlayerADDUI = {}
    TriggerServerEvent('FMGangsBoss:server:FireEmployee',GetPlayerServerId(PlayerId()) , data )
end)


function OpenBossMenu()
    ESX.TriggerServerCallback('FMGangs:GetGangsData', function(gangs,expire, Allmembers , MyGangMembers)

        for _, v in pairs(MyGangMembers['online']) do
            if PlayerADDUI[v.Hex] == nil then
                PlayerADDUI[v.Hex] = true
                totalplayer = totalplayer +1
                onlineplayer = onlineplayer +1
           
                SendNUIMessage({
                    type = 'add',
                    name = v.Name,
                    jobname = v.grade_number,
                    id = v.ID
                })
                SendNUIMessage({
                    type = "player",
                    total = totalplayer,
                    offlineplayer = offlineplayer,
                    onlineplayer = onlineplayer
                })
            end
        end
        for _, v in pairs(MyGangMembers['offline']) do
            if PlayerADDUI[v.Hex] == nil then
                PlayerADDUI[v.Hex] = true
                totalplayer = totalplayer +1
                offlineplayer = offlineplayer +1
                SendNUIMessage({
                    type = 'add-offline',
                    name = v.Name,
                    jobname = v.grade_number,
                    id = v.Hex 
                })
                SendNUIMessage({
                    type = "player",
                    total = totalplayer,
                    offlineplayer = offlineplayer,
                    onlineplayer = onlineplayer
                })
            end
        end
    end)
end
RegisterNetEvent('FMGangsBoss:client:OpenMenu', function()
    if Uiloaded then 
        if not OpenUi then
            ESX.TriggerServerCallback('FMGangs:isBoss', function(isBoss , logo)
                ESX.TriggerServerCallback('FMGangs:GetRankAccess', function(access)
                    if access['bossaction'] or isBoss  then
                        OpenUi = true
                        totalplayer = 0
                        onlineplayer = 0
                        offlineplayer = 0
                        OpenBossMenu()
                        namechange()
                        SendNUIMessage({
                            type = 'displayblock' , 
                            logo = logo ,
                    })
                        SetNuiFocus(true, true)
                    else
                        ESX.ShowNotification("Dont Have Access")
                    end
                end)
            end)
        end
    else
        ESX.ShowNotification("Insufficient authorization")
    end
end)

function namechange()
    ESX.TriggerServerCallback('FMGangsBoss:getmoney', function(money)
       money = money
    ESX.TriggerServerCallback('FMGangBoss:getname', function(name , gang )
        SendNUIMessage({
            type = "changename",
            name = name,
            jobname = gang ,
            dec = 'Boss Action' ,
            money = money
        })
    end)
end)

end






function DrawTexet3D(x, y, z, text)
	SetTextScale(0.30, 0.30)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawTexet(0.0, 0.0)
    local factor = (string.len(text)) / 250
    DrawRecet(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNUICallback("opencase", function ()
    ESX.TriggerServerCallback('FMGangsBoss:getmoney', function(money)
            SendNUIMessage({
                type = "case-update",
                case = money
            })
    end)
end)

RegisterNUICallback("openrecruit", function ()
    ESX.TriggerServerCallback('FMGangs:GetGangsData', function(gangs,expire, Allmembers , MyGangMembers )
        for _, v in pairs(MyGangMembers['online']) do
            SendNUIMessage({
                type = 'add-2',
                name = v.Name,
                jobname = v.grade_number,
                id = v.ID ,
                Hex = v.Hex
            })
        end
        for _, v in pairs(MyGangMembers['offline']) do
            SendNUIMessage({
                type = 'add-offline-2',
                name = v.Name,
                jobname = v.grade_number,
                id = v.Hex,
                Hex = v.Hex , 
            })
        end
    end)
end)

RegisterNUICallback("givejob", function (data)
    ESX.TriggerServerCallback('FMGangs:GetOthersFromGang', function(OthersData, Members) 
        if Members < OthersData.slot then
            id = tonumber(data.id)
            TriggerServerEvent("FMGangBoss:SetGang", id)
            SetNuiFocus(false, false)
            OpenUi = false
            PlayerADDUI = {}
        else
            SetNuiFocus(false, false)
            OpenUi = false
            PlayerADDUI = {}
            ESX.ShowNotification("Your Gang Slot is Full")
        end
    end)
end)

-------------------------
--- Settings (ported from Unique_Gangs boss menu: rank access, rank
--- names, log webhook) -- reuses ESX's native list menu, same as
--- Unique_Gangs did, and calls straight into FMGangs' own server
--- callbacks (already used by the FMGangs admin/create-gang panel)
--- so there's a single source of truth for gang/grade data.
-------------------------
local AccessKeys = {
    { key = 'garage',      label = 'Vehicle Garage' },
    { key = 'heliANDBoat', label = 'Heli / Boat Garage' },
    { key = 'putitem',     label = 'Put Item In Armory' },
    { key = 'takeitem',    label = 'Take Item From Armory' },
    { key = 'setclothe',   label = 'Set Gang Outfit' },
    { key = 'bossaction',  label = 'Boss Actions' },
}

RegisterNUICallback('opensettings', function()
    SetNuiFocus(false, false)
    OpenUi = false
    PlayerADDUI = {}
    OpenGangSettingsMenu()
end)

function OpenGangSettingsMenu()
    local elements = {
        { label = 'Manage Rank Access', value = 'manage_access' },
        { label = 'Manage Rank Names',  value = 'manage_grades' },
        { label = 'Set Log Webhook',    value = 'set_webhook' },
    }
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gangboss_settings', {
        title = 'Gang Settings', align = 'top-left', elements = elements
    }, function(data, menu)
        menu.close()
        if data.current.value == 'manage_access' then
            OpenManageAccessGradeList()
        elseif data.current.value == 'manage_grades' then
            OpenManageGradesList()
        elseif data.current.value == 'set_webhook' then
            OpenSetWebhookMenu()
        end
    end, function(data, menu)
        menu.close()
    end)
end

function OpenManageAccessGradeList()
    ESX.TriggerServerCallback('FMGangs:GetGangsData', function(gangs)
        local gang = gangs[PlayerData.gang.name]
        local elements = {}
        for gradeNum, gradeData in pairs(gang.grades) do
            table.insert(elements, { label = gradeData.label .. ' (Grade ' .. gradeNum .. ')', value = gradeNum })
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gangboss_access_grades', {
            title = 'Pick a Rank', align = 'top-left', elements = elements
        }, function(data, menu)
            menu.close()
            OpenManageAccessToggles(data.current.value)
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function OpenManageAccessToggles(gradeNum)
    ESX.TriggerServerCallback('FMGangs:GetGangsData', function(gangs)
        local grade = gangs[PlayerData.gang.name].grades[tonumber(gradeNum)]
        local elements = {}
        for _, a in ipairs(AccessKeys) do
            local current = (grade.access and grade.access[a.key]) and true or false
            table.insert(elements, { label = a.label .. ': ' .. (current and '~g~ON' or '~r~OFF'), value = a.key, current = current })
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gangboss_access_toggles', {
            title = grade.label, align = 'top-left', elements = elements
        }, function(data, menu)
            menu.close()
            local newValue = not data.current.current
            ESX.TriggerServerCallback('FMGangs:EditAccess', function()
                OpenManageAccessToggles(gradeNum)
            end, PlayerData.gang.name, gradeNum, data.current.value, newValue)
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function OpenManageGradesList()
    ESX.TriggerServerCallback('FMGangs:GetGangsData', function(gangs)
        local gang = gangs[PlayerData.gang.name]
        local elements = {}
        for gradeNum, gradeData in pairs(gang.grades) do
            table.insert(elements, { label = gradeData.label .. ' (Grade ' .. gradeNum .. ')', value = gradeNum })
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gangboss_grades_list', {
            title = 'Pick a Rank to Rename', align = 'top-left', elements = elements
        }, function(data, menu)
            menu.close()
            local gradeNum = data.current.value
            local grade = gang.grades[tonumber(gradeNum)]
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'gangboss_rename_grade', {
                title = 'New name for ' .. grade.label
            }, function(data2, menu2)
                menu2.close()
                local newLabel = data2.value
                if newLabel and newLabel ~= '' then
                    ESX.TriggerServerCallback('FMGangs:EditRank', function()
                        ESX.ShowNotification('Rank renamed')
                    end, PlayerData.gang.name, gradeNum, grade.name, newLabel, grade.salary or 0)
                end
            end, function(data2, menu2)
                menu2.close()
            end)
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function OpenSetWebhookMenu()
    ESX.TriggerServerCallback('FMGangs:GetGangsData', function(gangs)
        local gang = gangs[PlayerData.gang.name]
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'gangboss_set_webhook', {
            title = 'Discord Webhook URL'
        }, function(data, menu)
            menu.close()
            ESX.TriggerServerCallback('FMGangs:UpdateGang', function(ok)
                if ok then ESX.ShowNotification('Webhook updated') end
            end, PlayerData.gang.name, gang.label, gang.expire_day, gang.logo, data.value)
        end, function(data, menu)
            menu.close()
        end)
    end)
end

