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

