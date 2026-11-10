-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

Citizen.CreateThread(function()
    repeat Wait(100) until ESX ~= nil
    local sended = {}
    while true do
        Wait(3000)
        for k,v in ipairs(ESX.GetPlayerData().loadout) do
            if v.metadata and v.metadata.serial and not sended[v.metadata.serial] then
                sended[v.metadata.serial] = true
                ESX.TriggerServerEvent('serial:new',v)
            end
        end
    end
end)

local ignore_weapon = {
    [`weapon_unarmed`] = true,
}

AddEventHandler('esx:onPlayerDeath',function(data)
    if ESX.GetPlayerData().World == 0 then
        if data.killedByPlayer  then
            if data.deathCause and not ignore_weapon[data.deathCause] then
                if data.killerServerId and data.killerServerId ~= GetPlayerServerId(PlayerId()) then
                    local weaponname = ESX.GetWeaponName(data.deathCause)
                    if weaponname and weaponname ~= 'no_name' then
                        ESX.TriggerServerEvent('medic:SetSerial',data.killerServerId,weaponname or 'nil')
                    end
                else
                    ESX.TriggerServerEvent('medic:ClearSerial')
                end
            else
                ESX.TriggerServerEvent('medic:ClearSerial')
            end
        elseif not ESX.GetPlayerData().IsDead and not ESX.GetPlayerData().IsInjure then 
            ESX.TriggerServerEvent('medic:ClearSerial')
        end
    end
end)

RegisterNetEvent('CopyCurrentWeaponSerial',function()
    local _ , __ = GetCurrentPedWeapon(PlayerPedId())
    if __ ~= `weapon_unarmed` then
        for k,v in ipairs(ESX.GetPlayerData().loadout) do
            if GetHashKey(v.name) == __ then
                exports['esx_carjob']:SetClipboard(v.metadata.serial)
                ESX.Alert('OK','Copy shod!',5000,'success')
                return
            end
        end
    else
        ESX.Alert('Error','Hich guni dar dast shoma nist!',5000,'error')
    end
end)

function OpenMenu(src)
    ESX.TriggerServerCallback('medic:GetSerial',function(data)
        List = {}
        if data then
            table.insert(List,{
                img = data.name:upper() .. '.PNG',
                text = data.label, 
                text2 = '', 
                callBack = function()
                  
            end})
            table.insert(List,{
                img = 'SSwhite.png',
                text = data.serial, 
                text2 = '', 
                callBack = function()
                    exports.esx_carjob:SetClipboard(data.serial)
                    ESX.Alert('Success','Serial gun dar clipboard copy shod!',5000,'success')
            end})
        else
            table.insert(List,{
                img = 'SSwhite.png',
                text = 'Etela\'ati yaft nashod', 
                text2 = '', 
                callBack = function()
            end})
        end
        if DecorGetBool(GetPlayerPed(GetPlayerFromServerId(src)),'IsDead') then
            -- table.insert(List,{
            --     img = 'SSwhite.png',
            --     text = 'Vacium kardan jasad', 
            --     text2 = '', 
            --     callBack = function()
            --         exports.icon_menu:ForceCloseMenu()
            --         exports['sun-animmenu']:PlayEmote('medic',true)
            --         TriggerEvent("mythic_progbar:client:progress", {
            --             name = "vac",
            --             duration = math.random(10000,15000),
            --             label = "Dar hal vacium kardan",
            --             useWhileDead = false,
            --             canCancel = true,
            --             controlDisables = {
            --                 disableMovement = true,
            --                 disableCarMovement = true,
            --                 disableMouse = false,
            --                 disableCombat = true,
            --             },
            --             animation = nil,
            --             prop = {
            --                 model = "hei_prop_heist_binbag",
            --             }
            --         }, function(status)
            --             if not status then
            --                 ESX.TriggerServerEvent('medic:vaciumplayer',src)
            --             elseif status then
            --                 ClearPedTasksImmediately(GetPlayerPed(-1))
            --             end
            --         end)
            -- end})
        end
        exports.icon_menu:OpenMenu(List)
    end,src)
end

function OpenMenuWithData(data,alldata)
    List = {}
    if data then
        table.insert(List,{
            img = data.name:upper() .. '.PNG',
            text = data.label, 
            text2 = '', 
            callBack = function()
                
        end})
        table.insert(List,{
            img = 'SSwhite.png',
            text = data.serial, 
            text2 = '', 
            callBack = function()
                exports.esx_carjob:SetClipboard(data.serial)
                ESX.Alert('Success','Serial gun dar clipboard copy shod!',5000,'success')
        end})
    else
        table.insert(List,{
            img = 'SSwhite.png',
            text = 'Etela\'ati yaft nashod', 
            text2 = '', 
            callBack = function()
        end})
    end
    if exports['sun-society']:doesHavePerm('vacium') then
        table.insert(List,{
            img = 'SSwhite.png',
            text = 'Vacium kardan jasad', 
            text2 = '', 
            callBack = function()
                exports.icon_menu:ForceCloseMenu()
                exports['sun-animmenu']:PlayEmote('medic',true)
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "vac",
                    duration = math.random(10000,15000),
                    label = "Dar hal vacium kardan",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                    animation = nil,
                    prop = {
                        model = "hei_prop_heist_binbag",
                    }
                }, function(status)
                    if not status then
                        ESX.TriggerServerEvent('medic:vaciumped',alldata)
                    elseif status then
                        ClearPedTasksImmediately(GetPlayerPed(-1))
                    end
                end)
        end})
    end
    exports.icon_menu:OpenMenu(List)
end


function GetClosestSerial()
    local players = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()),5.0)
    local check = {}
    for k , v in pairs(players) do
        local player = GetPlayerServerId(v)
        if v ~= PlayerId() and (ESX.GetPlayerState(player, 'isInjure') or ESX.GetPlayerState(player, 'isDead')) then
            table.insert(check,{src = GetPlayerServerId(v),type = 'player'})
        end
    end
    local wait = true
    ESX.TriggerServerCallback('medic:GetData',function(data)
        local coords = GetEntityCoords(PlayerPedId())
        for k , v in pairs(data) do
            local distance = ESX.GetDistance(coords,v.coords)
            if distance <= 5 then
                v.type = 'ped'
                table.insert(check,v)
            end
        end
        wait = false
    end)
    while wait do Wait(100) end
    if #check == 0 then
        ESX.Alert('Error','Kasi dar kenar shoma nist',5000,'error')
    elseif #check == 1 then
        local data = check[1]
        if data.type == 'ped' then
            OpenMenuWithData(data.killerdata,data)
        else
            OpenMenu(data.src)
        end
    else
        List = {}
        for k , v in pairs(check) do
            if v.type == 'ped' then
                local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),v.coords)
                table.insert(List,{
                    img = '',
                    text = 'ID : ' .. v.src,
                    text2 = 'Distance : ' .. ESX.Math.Round(distance),
                    callBack = function()
                        OpenMenuWithData(v.killerdata,v)
                end})
            else
                local distance = ESX.GetDistance(GetEntityCoords(PlayerPedId()),GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(v.src))))
                table.insert(List,{
                    img = '',
                    text = 'ID : ' .. v.src, 
                    text2 = 'Distance : ' .. ESX.Math.Round(distance),
                    callBack = function()
                        OpenMenu(v.src)
                end})
            end
        end
        exports.icon_menu:OpenMenu(List)
    end
end

exports('GetClosestSerial',GetClosestSerial)

RegisterNetEvent('medic:killped',function(ped)
    local ped = NetToPed(ped)
    if DoesEntityExist(ped) then
        ESX.Game.RequestControl(ped)
        ESX.SetEntityHealth(ped,0)
    end
    -- local try = 0
    -- while GetEntityHealth(ped) > 100 do
    --     Wait(100)
    --     ESX.SetEntityHealth(ped,0)
    --     try = try + 1
    --     if try > 100 then
    --         break
    --     end
    -- end
end)

local blipdata = {}
local blipdatavacban = {} --har har
local blipdata2 = {} -- har har after 6 mah
local showjob = {
    ['police'] = true,
    ['sheriff'] = true,
    ['fbi'] = true,
    ['detective'] = true,
}

local showjobvacium = {
    ['ambulance'] = true,
}

RegisterNetEvent('medic:addbodyblip',function(key,coords)
    if blipdata[key] then
        RemoveBlip(blipdata[key])
    end
    if showjob[ESX.GetPlayerData().job.name] then
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 480)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 1)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Body')
        EndTextCommandSetBlipName(blip)	
        --table.insert(blipdata,{coords = coords , blip = blip})
        blipdata[key] = blip
    end
end)

RegisterNetEvent('medic:addvaciumblip',function(key,coords)
    if blipdatavacban[key] then
        RemoveBlip(blipdatavacban[key])
    end
    if showjobvacium[ESX.GetPlayerData().job.name] then
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        blipdatavacban[key] = blip
        SetBlipSprite(blip, 480)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 2)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Body')
        EndTextCommandSetBlipName(blip)		
        --table.insert(blipdatavacban,{coords = coords , blip = blip})	
    end
end)

RegisterNetEvent('medic:removebodyblip',function(key)
    -- for k , v in pairs(blipdata) do
    --     local distance = ESX.GetDistance(v.coords,coords)
    --     if distance < 8 then
    --         RemoveBlip(v.blip)
    --         table.remove(blipdata,k)
    --     end
    --     break
    -- end
    if blipdata[key] then
        RemoveBlip(blipdata[key])
        blipdata[key] = nil
    end
end)

RegisterNetEvent('medic:removevacblip',function(key)
    if blipdatavacban[key] then
        RemoveBlip(blipdatavacban[key])
        blipdatavacban[key] = nil
    end
    -- for k , v in pairs(blipdatavacban) do
    --     local distance = ESX.GetDistance(v.coords,coords)
    --     if distance < 8 then
    --         RemoveBlip(v.blip)
    --         table.remove(blipdatavacban,k)
    --     end
    --     break
    -- end
end)

RegisterNetEvent('medic:setbagobject',function(object)
    local object = NetToObj(object)
    if DoesEntityExist(object) then
        PlaceObjectOnGroundProperly(object)
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    for k , v in pairs(blipdata) do
        RemoveBlip(v.blip)
        table.remove(blipdata,k)
    end    
    for k , v in pairs(blipdatavacban) do
        RemoveBlip(v.blip)
        table.remove(blipdatavacban,k)
    end     
end)

AddStateBagChangeHandler('killMe', nil, function(bagName, k, v)
    local ped = GetEntityFromStateBagName(bagName)
    if ped ~= 0 and v then
		ESX.Game.RequestControl(ped)
        SetEntityHealth(ped, 0)
	end
end)

AddStateBagChangeHandler('placeOnGround', nil, function(bagName, k, v)
    local entity = GetEntityFromStateBagName(bagName)
    if entity ~= 0 and v then
		PlaceObjectOnGroundProperly(entity)
	end
end)

AddStateBagChangeHandler('disableCollision', nil, function(bagName, k, v)
    local entity = GetEntityFromStateBagName(bagName)
    if entity ~= 0 and v then
		SetEntityCollision(entity, false, true)
	end
end)