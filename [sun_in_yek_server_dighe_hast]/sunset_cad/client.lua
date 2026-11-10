-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local ESX      	 = nil

local Serials = {
    ["CA"] = true,
    ["MB"] = true,
    ["CR"] = true,
    ["FB"] = true,
    ["SF"] = true,
    ["PD"] = true,
    ["AD"] = true,
    ["UK"] = true,
    ["LO"] = true,
    ["GS"] = true,
    ["JF"] = true,
    ["RV"] = true,
    ["BS"] = true,
    ["WF"] = true,
    ['MT'] = true,
    ['JC'] = true,
    ['DT'] = true,
}
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('cad:open')
AddEventHandler('cad:open',function()
    if ESX.militaryJobs2[ESX.GetPlayerData().job.name] == true then
        local access = true
        local p = promise.new()
        ESX.TriggerServerCallback('esx_society:doesHavePerm',function(cb)
            p:resolve(cb)
        end,'openCAD')
        access = Citizen.Await(p)
        if access then
            open()
        else
            ESX.chatMessage('Shoma be cad dastresi nadarid!', 'plarms')
        end
    end
end)

RegisterCommand('cad',function()
    if not ESX.GetPlayerData().IsDead and not ESX.GetPlayerData().IsInjure then
        TriggerEvent('cad:open')
    end
end)

function open()
    ESX.TriggerServerCallback('SSCAD:GetMeData',function(data)
        local table = {
            type = 'UpdatePlayerData',
            phone = data.phoneNumber,
            name = tostring(data.name:gsub("_"," ")),
            job = data.job.label,
            grade = data.job.grade,
            policeId = 1,
            callsign = 3,
            rank = data.job.grade_label,
        }
        Wait(1000)
        SendNUIMessage(table)
    end)
    ESX.TriggerServerCallback('SSCAD:GetWanted',function(data)
        users = {}
        for k , v in pairs(data) do
            local sex = nil
            if tonumber(v.gender) == 0 then
                sex = "male"
            else
                sex = "female"
            end
            table.insert(users,{
                name  = v.playerName:gsub("_"," "),
                identifier = v.identifier,
                age = 30,
                registered = 30,
                balance = v.bank,
                gender = sex,
                id = v.id ,
                isActive = true,
                phone = v.phone_number,
                picture = v.profilepicture,
                status = v.cad_status
                }
            )
        end
        Wait(1000)
        SendNUIMessage({type = 'WantedData',data = json.encode(users)})
    end)
    ESX.TriggerServerCallback('SSCAD:GetWeapons',function(data)
        Wait(1000)
        SendNUIMessage({type = 'WeaponData',data = json.encode(data)})
    end)
    -------------
    ESX.TriggerServerCallback('SSCAD:GetVehicleWanted',function(data)
        local num = 0
        local vehicles = {}
        for k ,v in pairs(data) do
            local vehdata = json.decode(v.vehicle)
            local vehmodel = vehdata.model
            local name = GetDisplayNameFromVehicleModel(vehmodel)
            if string.lower(tostring(GetLabelText(name))) == "null" then
                local newname = ESX.GetVehicleLabelFromName(name)
                if newname ~= "Unknown" then
                    name = newname
                end
            else
                name = GetLabelText(name)
            end
            local vehicleClassFromName = GetVehicleClassFromName(vehmodel)
            num = num + 1
            local Name = "Unknown"
            if v.userdata and v.userdata.playerName then
                Name = v.userdata.playerName:gsub("_"," ")
            end
            table.insert(vehicles,{
                carid = num,
                color = "badan",
                name = name,
                number = vehdata.plate,
                owner = v.owner,
                userdata = v.userdata,
                ownername = Name,
                sellerId = 0,
                status = v.cad_status,
                data = v.data,
            })
        end
        Wait(1000)
        SendNUIMessage({type = 'VehicleData',data = json.encode(vehicles)})
    end)
    Wait(200)
    SetNuiFocus(true,true)
    SendNUIMessage({type = 'OpenPoliceCad'})
end

RegisterNUICallback('CloseCad', function(data)
    SetNuiFocus(false,false)
    SendNUIMessage({type = 'ClosePoliceCad'})
end)

--KIRI CB


RegisterNUICallback('AddImageToPlayer', function(data)
    if not ESX.doesHaveJobPerm('addDataCAD') then return ESX.chatMessage('Shoma dastresi kafi nadarid!', 'plarms') end
    if data.identifier and data.image then
        if data.image == '' then
            ESX.Alert('Error','Shoma hich linki ra vared nakardid',10000,'error')
        else
            TriggerServerEvent('SSCAD:SaveProfilePicture',data)
        end
    end
end)

RegisterNUICallback('ChangePlayerStatus', function(data)
    if not ESX.doesHaveJobPerm('addDataCAD') then return ESX.chatMessage('Shoma dastresi kafi nadarid!', 'plarms') end
    if data.identifier and data.status then
        TriggerServerEvent('SSCAD:ChangePlayerStatus',data)
    end
end)

RegisterNUICallback('ChangeWeaponStatus', function(data)
    if not ESX.doesHaveJobPerm('addDataCAD') then return ESX.chatMessage('Shoma dastresi kafi nadarid!', 'plarms') end
    if data.serial and data.status then
        TriggerServerEvent('SSCAD:ChangeWeaponStatus',data)
    end
end)


--panic need

--get data from server

RegisterNetEvent('SSCAD:GetVehicleData')
AddEventHandler('SSCAD:GetVehicleData',function(data)
    local data = json.decode(data)
    local num = 0
    local vehicles = {}
    for k ,v in pairs(data) do
        local vehdata = json.decode(v.vehicle)
        local vehmodel = vehdata.model
        local name = GetDisplayNameFromVehicleModel(vehmodel)
        if string.lower(tostring(GetLabelText(name))) == "null" then
            local newname = ESX.GetVehicleLabelFromName(name)
            if newname ~= "Unknown" then
                name = newname
            end
        else
            name = GetLabelText(name)
        end
        local vehicleClassFromName = GetVehicleClassFromName(vehmodel)
        num = num + 1
        local Name = "Unknown"
        if v.userdata and v.userdata.playerName then
            Name = v.userdata.playerName:gsub("_"," ")
        end
        table.insert(vehicles,{
            carid = num,
            color = "badan",
            name = name,
            number = vehdata.plate,
            owner = v.owner,
            userdata = v.userdata,
            ownername = Name,
            sellerId = 0,
            status = v.cad_status,
            data = v.data,
        })
    end
Wait(1000)
SendNUIMessage({type = 'VehicleData',data = json.encode(vehicles)})
end)


RegisterNUICallback('GetUser', function(data,cb)
    ESX.TriggerServerCallback('SSCAD:GetUser',function(data,cad_data)
        local users = {}
        for k , v in pairs(data) do
            local sex = nil
            if tonumber(v.gender) == 0 then
                sex = "male"
            else
                sex = "female"
            end
            table.insert(users,{
                name  = v.playerName:gsub("_"," "),
                identifier = v.identifier,
                age = 30,
                registered = 30,
                balance = v.bank,
                gender = sex,
                id = v.id ,
                isActive = true,
                phone = v.phone_number,
                picture = v.profilepicture,
                status = v.cad_status
                }
            )
        end
        SendNUIMessage({type = 'UserData',data = json.encode(users)})
        if cad_data then
            SendNUIMessage({type = 'LoadTicket',data = json.encode(cad_data)})
        end
        cb(users)
        Wait(500)
        SendNUIMessage({type = 'StopWait'})
    end,data.value)
end)

RegisterNUICallback('GetWeapon', function(data,cb)
    local serial = data.value
    if string.len(serial) < 6 then
        ESX.Alert('Error','Shoma had aghal bayad 6 character ra vared konid',5000,'error')
        SendNUIMessage({type = 'StopWait'})
        return
    else
        
        local type = string.upper(string.sub(serial, 1, 2))
        if Serials[type] then
            ESX.TriggerServerCallback('SSCAD:GetWeapons',function(data)
                for k , v in pairs(data) do
                    v.label = ESX.GetWeaponLabel(v.name)
                end
                SendNUIMessage({type = 'WeaponData',data = json.encode(data)})
                -- if cad_data then
                --     SendNUIMessage({type = 'LoadTicket',data = json.encode(cad_data)})
                -- end
                cb(data)
                Wait(500)
                SendNUIMessage({type = 'StopWait'})
            end,data.value)
        else
            ESX.Alert('Error','Shoma vared shode na motabar mibashad',5000,'error')
            SendNUIMessage({type = 'StopWait'})
            return
        end
    end
end)

RegisterNUICallback('UpdateVehicleData', function(data)
    if not ESX.doesHaveJobPerm('addDataCAD') then return ESX.chatMessage('Shoma dastresi kafi nadarid!', 'plarms') end
    TriggerServerEvent('SSCAD:UpdateVehicleData',data)
end)

RegisterNetEvent('SSCAD:GetCadData')
AddEventHandler('SSCAD:GetCadData',function(data)
    if data then
        SendNUIMessage({type = 'LoadTicket',data = json.encode(data)})
        Wait(500)
        SendNUIMessage({type = 'StopWait'})
    end
end)


RegisterNUICallback('ChangeVehicleStatus', function(data)
    if not ESX.doesHaveJobPerm('addDataCAD') then return ESX.chatMessage('Shoma dastresi kafi nadarid!', 'plarms') end
    if data.status and data.plate then
        TriggerServerEvent('SSCAD:ChangeVehiclerStatus',data)
    end
end)

RegisterNUICallback('GetVehicle', function(data,cb)
    ESX.TriggerServerCallback('SSCAD:GetVehicle',function(data)
        local num = 0
        local vehicles = {}
        for k ,v in pairs(data) do
            local vehdata = json.decode(v.vehicle)
            local vehmodel = vehdata.model
            local name = GetDisplayNameFromVehicleModel(vehmodel)
            if string.lower(tostring(GetLabelText(name))) == "null" then
                local newname = ESX.GetVehicleLabelFromName(name)
                if newname ~= "Unknown" then
                    name = newname
                end
            else
                name = GetLabelText(name)
            end
            local vehicleClassFromName = GetVehicleClassFromName(vehmodel)
            num = num + 1
            local Name = "Unknown"
            if v.userdata and v.userdata.playerName then
                Name = v.userdata.playerName:gsub("_"," ")
            end
            table.insert(vehicles,{
                carid = num,
                color = "badan",
                name = name,
                number = vehdata.plate,
                owner = v.owner,
                userdata = v.userdata,
                ownername = Name,
                sellerId = 0,
                status = v.cad_status,
                data = v.data,
            })
        end
        Wait(1000)
        vehicles = json.encode(vehicles)
        cb(vehicles)
        Wait(500)
        SendNUIMessage({type = 'StopWait'})
    end,data.value)
end)

RegisterNUICallback('NewData', function(data)
    if not ESX.doesHaveJobPerm('addDataCAD') then return ESX.chatMessage('Shoma dastresi kafi nadarid!', 'plarms') end
    if data.text and data.identifier then
        TriggerServerEvent('SSCAD:AddPlayerData',data)
    end
end)

RegisterNUICallback('DeleteTicket', function(data)
    if not ESX.doesHaveJobPerm('removeDataCAD') then return ESX.chatMessage('Shoma dastresi kafi nadarid!', 'plarms') end
    if data.id then
        TriggerServerEvent('SSCAD:DeleteData',data)
    end
end)

RegisterNUICallback('ShowNotify', function(data)
    ESX.Alert(data.title,data.text,data.time,data.type)
end)

RegisterNUICallback('NewDataWeapon', function(data)
    if not ESX.doesHaveJobPerm('addDataCAD') then return ESX.chatMessage('Shoma dastresi kafi nadarid!', 'plarms') end
    Citizen.Wait(math.random(100,1000))
    if data.text and data.serial then
        TriggerServerEvent('SSCAD:AddWeaponData',data)
    end
end)
RegisterNetEvent('SSCAD:ReloadWeapon', function(data)
    SendNUIMessage({type = 'UpdateWeaponData',data = data})
    Wait(1000)
    SendNUIMessage({type = 'StopWait'})
end)
RegisterNUICallback('DeleteTicketWeapon', function(data)
    if not ESX.doesHaveJobPerm('removeDataCAD') then return ESX.chatMessage('Shoma dastresi kafi nadarid!', 'plarms') end
    if data.id then
        data.id = data.id + 1
        TriggerServerEvent('SSCAD:DeleteDataWeapon',data)
    end
end)