ESX = nil 
TriggerEvent(Config.ESX, function(obj) ESX = obj end)

Gangs = {}
local Members = {}
function DataBase(sql)
    if true then 
        if sql == 'gangs' then 
            local Data = MySQL.Sync.fetchAll('SELECT * FROM gangs')
            return Data
        elseif sql == 'gangs_data' then 
            local Data = MySQL.Sync.fetchAll('SELECT * FROM gangs_data')
            return Data
        elseif sql == 'gang_grades' then 
            local Data = MySQL.Sync.fetchAll('SELECT * FROM gang_grades')
            return Data
        elseif sql == 'users' then 
            local Data = MySQL.Sync.fetchAll('SELECT * FROM users')
            return Data
        end
    end 
end 
-------------------------
----- Load Gangs
-------------------------
MySQL.ready(function()
	local GetGangsTable = DataBase('gangs')
    for i=1, #GetGangsTable, 1 do
        if GetGangsTable[i].name ~= 'nogang' then
            if GetGangsTable[i].logo == "" then 
                GetGangsTable[i].logo = Config.DefaultAvatar 
            end  
            Gangs[GetGangsTable[i].name] = {}
            Gangs[GetGangsTable[i].name].label = GetGangsTable[i].label
            Gangs[GetGangsTable[i].name].webhook = GetGangsTable[i].webhook
            Gangs[GetGangsTable[i].name].logo = GetGangsTable[i].logo 
            Gangs[GetGangsTable[i].name].expire = GetGangsTable[i].expire
            Gangs[GetGangsTable[i].name].expire_day = GetGangsTable[i].expire_day
            Gangs[GetGangsTable[i].name].name = GetGangsTable[i].name
            Gangs[GetGangsTable[i].name].level = GetGangsTable[i].level
            Gangs[GetGangsTable[i].name].xp = GetGangsTable[i].xp
            Gangs[GetGangsTable[i].name].disband = GetGangsTable[i].disband
            Gangs[GetGangsTable[i].name].Vehicles = {}
            Gangs[GetGangsTable[i].name].grades = {}
            MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner',{
                ['@owner'] = GetGangsTable[i].name
            }, function(vehResult)
                for j=1, #vehResult do
                    Gangs[GetGangsTable[i].name].Vehicles[j] = json.decode(vehResult[j].vehicle)
                end
            end)
        end
    end
  

    local GetGangsGradesTable = DataBase('gang_grades')

    for i=1, #GetGangsGradesTable, 1 do
        if GetGangsGradesTable[i].gang_name ~= 'nogang' then
            Gangs[GetGangsGradesTable[i].gang_name].grades[tonumber(GetGangsGradesTable[i].grade)] = GetGangsGradesTable[i]
            Gangs[GetGangsGradesTable[i].gang_name].grades[tonumber(GetGangsGradesTable[i].grade)].clothes = json.decode(GetGangsGradesTable[i].clothes) or {}
            Gangs[GetGangsGradesTable[i].gang_name].grades[tonumber(GetGangsGradesTable[i].grade)].access = json.decode(GetGangsGradesTable[i].access) or {}
            Gangs[GetGangsGradesTable[i].gang_name].grades[tonumber(GetGangsGradesTable[i].grade)].salary = GetGangsGradesTable[i].salary or 0
        end
    end
    

    local GetGangsDataTable = DataBase('gangs_data')
    for i=1, #GetGangsDataTable, 1 do
        Gangs[GetGangsDataTable[i].gang_name].blip = json.decode(GetGangsDataTable[i].blip)
        Gangs[GetGangsDataTable[i].gang_name].boss = json.decode(GetGangsDataTable[i].boss)
        Gangs[GetGangsDataTable[i].gang_name].locker = json.decode(GetGangsDataTable[i].locker)
        Gangs[GetGangsDataTable[i].gang_name].armory = json.decode(GetGangsDataTable[i].armory)
        Gangs[GetGangsDataTable[i].gang_name].veh = json.decode(GetGangsDataTable[i].veh)
        Gangs[GetGangsDataTable[i].gang_name].vehspawn = json.decode(GetGangsDataTable[i].vehspawn)
        Gangs[GetGangsDataTable[i].gang_name].heli = json.decode(GetGangsDataTable[i].heli)
        Gangs[GetGangsDataTable[i].gang_name].helispawn = json.decode(GetGangsDataTable[i].helispawn)
        Gangs[GetGangsDataTable[i].gang_name].boat = json.decode(GetGangsDataTable[i].boat)
        Gangs[GetGangsDataTable[i].gang_name].boatspawn = json.decode(GetGangsDataTable[i].boatspawn)
        Gangs[GetGangsDataTable[i].gang_name].deletecars = json.decode(GetGangsDataTable[i].deletecars)
        Gangs[GetGangsDataTable[i].gang_name].craft = json.decode(GetGangsDataTable[i].craft)
        Gangs[GetGangsDataTable[i].gang_name].shop = json.decode(GetGangsDataTable[i].shop)
        Gangs[GetGangsDataTable[i].gang_name].flag = json.decode(GetGangsDataTable[i].flag)
        Gangs[GetGangsDataTable[i].gang_name].bots = json.decode(GetGangsDataTable[i].bots)
        Gangs[GetGangsDataTable[i].gang_name].others = json.decode(GetGangsDataTable[i].others)
    end

    Members = DataBase('users')
    TriggerEvent('For5M:SetGangs' ,Gangs )
end)

RegisterServerEvent('For5M:SetXPAndLevel')
AddEventHandler('For5M:SetXPAndLevel', function(gang, Level, XP)
    if Gangs[gang] ~= nil then
        Gangs[gang].level = Level
        Gangs[gang].xp = XP
    end
end)

RegisterServerEvent('For5M:SetGang')
AddEventHandler('For5M:SetGang', function(gang, grade)
    local xPlayer = ESX.GetPlayerFromId(source)
    for i=1, #Members, 1 do
        if Members[i].identifier == xPlayer.identifier then
            Members[i].gang = gang
            Members[i].gang_grade = grade
        end
    end
end)

ESX.RegisterServerCallback('FMGangs:GetGangDataFromName', function(source, cb, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    if name then
      
        if Gangs[name] ~= nil then
            cb(Gangs[name])
      
        end
    end
end)



ESX.RegisterServerCallback('FMGangs:isBoss', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local LastRank = CountTable(Gangs[xPlayer.gang.name].grades)
    if xPlayer.gang.grade == LastRank then
        cb(true , Gangs[xPlayer.gang.name].logo )
    else
        cb(false , Gangs[xPlayer.gang.name].logo )
    end
end)
ESX.RegisterServerCallback('FMGangs:GetRankAccess', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local LastRank = CountTable(Gangs[xPlayer.gang.name].grades)
    if xPlayer.gang.grade == LastRank then
        cb(true , Gangs[xPlayer.gang.name].logo )
    else
        cb(false)
    end
end)
ESX.RegisterServerCallback('FMGangs:GetMyGangLogo', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if Gangs[xPlayer.gang.name] ~= nil then
        cb( Gangs[ xPlayer.gang.name ].logo ,  GetAvatar(source) )
    else 
        cb('')
    end
end)


ESX.RegisterServerCallback('FMGangs:GetCoordDataFromName', function(source, cb, name, option)
    local xPlayer = ESX.GetPlayerFromId(source)
    if name and option then
        if Gangs[name] ~= nil then
            if Gangs[name][option] == nil then
                Gangs[name][option] = {}
                cb(Gangs[name][option])
            else
                local SendData = {}
                local SendedData = Gangs[name][option]
                for k,v in pairs( SendedData ) do 
                    table.insert(SendData, v)
                end
                cb(SendData)
            end
       
        end
    end
end)
ESX.RegisterServerCallback('FMGangs:GetAllGangs', function(source, cb)
    cb( Gangs )
end)    
ESX.RegisterServerCallback('For5M:GetGangData', function(source, cb, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    if name then
        if Gangs[name] ~= nil then
            local Expire = Gangs[name].expire
            local Expire_Day = Gangs[name].expire_day
            local Disband = Gangs[name].disband
            local UnixExpire = (Expire- os.time()) / 86400
            local Az100 = 100 / Expire_Day * UnixExpire
            if Az100 > 0 and Disband == 0 then
                cb(true, Gangs[name])
            else
                cb(false, nil)
            end
      
        end
    end
end)

ESX.RegisterServerCallback('FMGangs:CreateGang', function(source, cb, data)
    local xPlayer = ESX.GetPlayerFromId(source)
    if data.name and data.label and data.expire and data.logo then
        if Gangs[data.name] == nil then
            Gangs[data.name] = {}
            Gangs[data.name].label = data.label
            Gangs[data.name].logo = data.logo
            Gangs[data.name].expire = (data.expire * 86400) + os.time()
            Gangs[data.name].expire_day = data.expire
            Gangs[data.name].name = data.name
            Gangs[data.name].webhook = data.webhook 
            Gangs[data.name].level = 0
            Gangs[data.name].xp = 0
            Gangs[data.name].disband = 0
            Gangs[data.name].Vehicles = {}
            Gangs[data.name].grades = {}
            Gangs[data.name].others = {
                ['money'] = 5000 ,
                ['gps'] = 0 ,
                ['basealaram'] = 0 , 
                ['clothe'] = 4 , 
                ['armor'] = 50 , 
                ['cuff'] = 1 , 
                ['lockpick'] = 1 , 
                ['search'] = 1 , 
                ['slot'] = 20 , 
            }
            CreateGangs(data.name, data.label, data.logo, (data.expire * 86400) + os.time(), data.expire ,data.webhook  )
            local Ranks_Data = Config.DefaultRanks
           
            for i=1, #Ranks_Data, 1 do
                Gangs[data.name].grades[tonumber(Ranks_Data[i].Grade)] = {gang_name = data.name, grade = Ranks_Data[i].Grade, label = Ranks_Data[i].Label, name = Ranks_Data[i].Name, clothes = {} , access =  {['putitem'] = false ,['takeitem'] = false ,['garage']   = false ,['setclothe'] = false ,['heliANDBoat'] = false ,  ['bossaction'] = false ,} , salary = 0 }
                MySQL.Async.execute('INSERT INTO gang_grades (gang_name, grade, label, name , access , salary) VALUES (@gang_name, @grade, @label, @name , @access ,@salary )', 
                {
                    ['@gang_name']  = data.name,
                    ['@grade']  = Ranks_Data[i].Grade,
                    ['@label'] 	= Ranks_Data[i].Label,
                    ['@name'] 	= Ranks_Data[i].Name , 
                    ['@access'] 	=  json.encode( {
                        ['putitem'] = false ,
                        ['takeitem'] = false ,
                        ['garage']   = false ,
                        ['setclothe'] = false ,
                        ['heliANDBoat'] = false ,
                        ['bossaction'] = false ,
                    }) , 
                    ['@salary'] 	= 0 
                })
            end
            TriggerEvent('For5M:SetGangs' ,Gangs )
            cb(true, 'gang sakhe shod')
        else
            cb(false, 'in gang vojood darad')
        end
    else
        cb(false, 'etelaat ro kamel vared kon')
    end
end)


-------------------------
----- Create Gangs
-------------------------

function CreateGangs(Name, Label, Logo, Expire, Expire_Day , webhook )

    if Name and Label and Logo and Expire then 
   
            MySQL.Async.execute('INSERT INTO gangs (name, label, logo, expire, level ,xp ,disband, expire_day ,webhook) VALUES (@name, @label, @logo, @expire, @level, @xp, @disband, @expire_day , @webhook)',
            {
                ['@name']   = Name,
                ['@label']  = Label,
                ['@logo'] 	= Logo,
                ['@expire'] = Expire,
                ['@level'] = 0,
                ['@xp'] = 0,
                ['@disband'] = 0,
                ['@expire_day'] = Expire_Day, 
                ['@webhook'] = webhook,

            })
            MySQL.Async.execute('INSERT INTO gangs_data (gang_name, others) VALUES (@gang_name, @others)',
            {
                ['@gang_name']   = Name,
                ['@others']   = json.encode({
                    ['money'] = 5000 ,
                    ['gps'] = 0 ,
                    ['basealaram'] = 0 , 
                    ['clothe'] = 4 , 
                    ['armor'] = 50 , 
                    ['cuff'] = 1 , 
                    ['search'] = 1 , 
                    ['lockpick'] = 1 ,
                    ['slot'] = 20 , 
                }),

            })
            
 
    end
end


function UpdateGangsData(Name, Type, Data)
    if Type == 'blip' then
        if Data ~= nil and Name then
            MySQL.Async.execute('UPDATE gangs_data SET blip = @blip WHERE gang_name = @gang_name', 
            {
                ['@blip'] = json.encode(Data),
                ['@gang_name'] = Name
            }, function(result)
                Gangs[Name].blip = Data
            end)
        end
    elseif Type == 'boss' then
        if Data ~= nil and Name then
            MySQL.Async.execute('UPDATE gangs_data SET boss = @boss WHERE gang_name = @gang_name', 
            {
                ['@boss'] = json.encode(Data),
                ['@gang_name'] = Name
            }, function(result)
                Gangs[Name].boss = Data
            end)
        end
    elseif Type == 'locker' then
        if Data ~= nil and Name then
            MySQL.Async.execute('UPDATE gangs_data SET locker = @locker WHERE gang_name = @gang_name', 
            {
                ['@locker'] = json.encode(Data),
                ['@gang_name'] = Name
            }, function(result)
                Gangs[Name].locker = Data
            end)
        end
    elseif Type == 'armory' then
        if Data ~= nil and Name then
            MySQL.Async.execute('UPDATE gangs_data SET armory = @armory WHERE gang_name = @gang_name', 
            {
                ['@armory'] = json.encode(Data),
                ['@gang_name'] = Name
            }, function(result)
                Gangs[Name].armory = Data
            end)
        end
    elseif Type == 'vehicle' then
        if Data ~= nil and Name then
            MySQL.Async.execute('UPDATE gangs_data SET vehicle = @vehicle WHERE gang_name = @gang_name', 
            {
                ['@vehicle'] = json.encode(Data),
                ['@gang_name'] = Name
            }, function(result)
                Gangs[Name].vehicle = Data
            end)
        end
    elseif Type == 'heli' then
        if Data ~= nil and Name then
            MySQL.Async.execute('UPDATE gangs_data SET heli = @heli WHERE gang_name = @gang_name', 
            {
                ['@heli'] = json.encode(Data),
                ['@gang_name'] = Name
            }, function(result)
                Gangs[Name].heli = Data
            end)
        end
    elseif Type == 'boat' then
        if Data ~= nil and Name then
            MySQL.Async.execute('UPDATE gangs_data SET boat = @boat WHERE gang_name = @gang_name', 
            {
                ['@boat'] = json.encode(Data),
                ['@gang_name'] = Name
            }, function(result)
                Gangs[Name].boat = Data
            end)
        end
    elseif Type == 'craft' then
        if Data ~= nil and Name then
            MySQL.Async.execute('UPDATE gangs_data SET craft = @craft WHERE gang_name = @gang_name', 
            {
                ['@craft'] = json.encode(Data),
                ['@gang_name'] = Name
            }, function(result)
                Gangs[Name].craft = Data
            end)
        end
    elseif Type == 'shop' then
        if Data ~= nil and Name then
            MySQL.Async.execute('UPDATE gangs_data SET shop = @shop WHERE gang_name = @gang_name', 
            {
                ['@shop'] = json.encode(Data),
                ['@gang_name'] = Name
            }, function(result)
                Gangs[Name].shop = Data
            end)
        end
    elseif Type == 'flag' then
        if Data ~= nil and Name then
            MySQL.Async.execute('UPDATE gangs_data SET flag = @flag WHERE gang_name = @gang_name', 
            {
                ['@flag'] = json.encode(Data),
                ['@gang_name'] = Name
            }, function(result)
                Gangs[Name].flag = Data
            end)
        end
    elseif Type == 'bots' then
        if Data ~= nil and Name then
            MySQL.Async.execute('UPDATE gangs_data SET bots = @bots WHERE gang_name = @gang_name', 
            {
                ['@bots'] = json.encode(Data),
                ['@gang_name'] = Name
            }, function(result)
                Gangs[Name].bots = Data
            end)
        end
    elseif Type == 'others' then
        if Data ~= nil and Name then
            MySQL.Async.execute('UPDATE gangs_data SET others = @others WHERE gang_name = @gang_name', 
            {
                ['@others'] = json.encode(Data),
                ['@gang_name'] = Name
            }, function(result)
                Gangs[Name].others = Data
            end)
        end
    end
end

ESX.RegisterServerCallback('FMGangs:AddRank', function(source, cb, Name, Label, GradeName , salary)
    if Label and GradeName then
        local GangGrades = Gangs[Name].grades
        local NewGrade = #GangGrades + 1
        MySQL.Async.execute('INSERT INTO gang_grades (gang_name, grade, label, name , access , salary) VALUES (@gang_name, @grade, @label, @name , @access , @salary)',
        {
            ['@gang_name']  = Name,
            ['@grade']  = NewGrade,
            ['@label'] 	= Label,
            ['@name'] 	= GradeName , 
            ['@access'] 	= json.encode( {
                ['putitem'] = false ,
                ['takeitem'] = false ,
                ['garage']   = false ,
                ['setclothe'] = false ,
                ['heliANDBoat'] = false ,
                ['bossaction'] = false ,
            } ), 
            ['@salary'] 	= salary , 
        })
        Gangs[Name].grades[tonumber(NewGrade)] = {gang_name = Name, grade = NewGrade, label = Label, name = GradeName, clothes = {} , access = {['putitem'] = false ,['takeitem'] = false , ['garage']   = false ,['setclothe'] = false ,['heliANDBoat'] = false ,['bossaction'] = false , } , }
        TriggerEvent('For5M:SetGangs' ,Gangs ) 
        local xPlayer = ESX.GetPlayerFromId(source)
        local LastRank = CountTable(Gangs[Name].grades) 
        UpdateRankOfPlayersUP(Name  , LastRank - 1    )
        cb(Gangs[Name].grades)
    else
        cb(Gangs[Name].grades)
    end
end)

ESX.RegisterServerCallback('FMGangs:EditRank', function(source, cb, GangName, GradeNumber, GradeName, GradeLabel , salary )
    MySQL.Async.execute('UPDATE gang_grades SET label = @label, name = @name  , salary = @salary WHERE gang_name = @gang_name  AND grade = @grade' , 
        {
            ['@label'] = GradeLabel,
            ['@name'] = GradeName,
            ['@gang_name'] = GangName,
            ['@grade'] = GradeNumber,
            ['@salary'] = salary,
        }, function(result)
            Gangs[GangName].grades[tonumber(GradeNumber)].label = GradeLabel
            Gangs[GangName].grades[tonumber(GradeNumber)].name = GradeName
            Gangs[GangName].grades[tonumber(GradeNumber)].salary = salary
            TriggerEvent('For5M:SetGangs' ,Gangs ) 
            cb(Gangs[GangName].grades)
        end)
   
end)

ESX.RegisterServerCallback('FMGangs:DeleteRank', function(source, cb, GangName, GradeNumber)
    local xPlayer = ESX.GetPlayerFromId(source)
    local FinalRank = CountTable(Gangs[GangName].grades)
    if FinalRank == 1 then 
        TriggerClientEvent(Config.showNotification , source , 'You Can`t Delete Last Rank') 
        cb(Gangs[GangName].grades) 
        return
    end 
    MySQL.Async.execute('DELETE FROM gang_grades WHERE grade = @grade AND gang_name = @gang_name', { ['@grade'] = GradeNumber, ['@gang_name'] = GangName })
    local GradesData = Gangs[GangName].grades
    Gangs[GangName].grades = {}
    local FirstNum = 0
    for i ,v in pairs(GradesData) do 
        if tonumber(GradesData[i].grade) ~= tonumber(GradeNumber) then
            FirstNum = FirstNum + 1
            local ThisGrade = FirstNum
            Gangs[GangName].grades[tonumber(ThisGrade)] = {gang_name = GradesData[i].gang_name, grade = ThisGrade, label = GradesData[i].label, name = GradesData[i].name, clothes = GradesData[i].clothes , access = GradesData[i].access }
            MySQL.Async.execute('UPDATE gang_grades SET grade = @grade WHERE gang_name = @gang_name AND name = @name', 
            {
                ['@grade'] = ThisGrade,
                ['@gang_name'] = GangName,
                ['@name'] = GradesData[i].name
            }, function(result)
                UpdateRankOfPlayers(GangName  , FinalRank   ) 
                TriggerEvent('For5M:SetGangs' ,Gangs ) 
            end)
        end
    end

    cb(Gangs[GangName].grades)
end)
ESX.RegisterServerCallback('FMGangs:EditAccess', function(source, cb, GangName, GradeNumber,  accesskey , value )
    Gangs[GangName].grades[tonumber(GradeNumber)].access[accesskey] = value
    MySQL.Async.execute('UPDATE gang_grades SET access = @access WHERE gang_name = @gang_name  AND grade = @grade' , 
    {
        ['@gang_name'] = GangName ,
        ['@grade'] = GradeNumber ,
        ['@access'] = json.encode( Gangs[GangName].grades[tonumber(GradeNumber)].access ) ,
        
    }, function(result)
        cb(value)
    end)
end)

ESX.RegisterServerCallback('FMGangs:GetRankCloths', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(Gangs[tostring(xPlayer.gang.name)].grades[xPlayer.gang.grade]['clothes'] or {})
end)

ESX.RegisterServerCallback('FMGangs:GetRankClothsByRank', function(source, cb, rank)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    cb( Gangs[tostring(xPlayer.gang.name)].grades[tonumber(rank)]['clothes'])
end)

ESX.RegisterServerCallback('FMGangs:SetClothRank', function(source, cb, rank, outfit, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    table.insert(Gangs[tostring(xPlayer.gang.name)].grades[tonumber(rank)].clothes, {name = name, outfit = json.encode(outfit)})
    MySQL.Async.execute('UPDATE gang_grades SET clothes = @clothes WHERE gang_name = @gang_name AND grade = @grade', 
    {
        ['@clothes'] = json.encode(Gangs[xPlayer.gang.name].grades[tonumber(rank)].clothes),
        ['@gang_name'] = xPlayer.gang.name,
        ['@grade'] = rank,
    }, function(result)
        cb(true)
    end)
end)

ESX.RegisterServerCallback('FMGangs:SetClothRank2', function(source, cb, rank, outfit, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    for k,v in pairs(Gangs[xPlayer.gang.name].grades[tonumber(rank)].clothes) do 
        if v.name == name then
            Gangs[xPlayer.gang.name].grades[tonumber(rank)].clothes[k] = { name = name, outfit = json.encode(outfit) }
            break
        end
    end
    MySQL.Async.execute('UPDATE gang_grades SET clothes = @clothes WHERE gang_name = @gang_name AND grade = @grade', 
    {
        ['@clothes'] = json.encode(Gangs[xPlayer.gang.name].grades[tonumber(rank)].clothes),
        ['@gang_name'] = xPlayer.gang.name,
        ['@grade'] = rank,
    }, function(result)
        cb(true)
    end)
end)

ESX.RegisterServerCallback('FMGangs:DelClothRank', function(source, cb, rank, name)
    local xPlayer = ESX.GetPlayerFromId(source)
    for k,v in pairs(Gangs[xPlayer.gang.name].grades[tonumber(rank)].clothes) do 
        if v.name == name then
            table.remove(Gangs[xPlayer.gang.name].grades[tonumber(rank)].clothes, k)
            break
        end
    end
    MySQL.Async.execute('UPDATE gang_grades SET clothes = @clothes WHERE gang_name = @gang_name AND grade = @grade', 
    {
        ['@clothes'] = json.encode(Gangs[xPlayer.gang.name].grades[tonumber(rank)].clothes),
        ['@gang_name'] = xPlayer.gang.name,
        ['@grade'] = rank,
    }, function(result)
        cb(true)
    end)
end)

ESX.RegisterServerCallback('FMGangs:DeleteGang', function(source, cb, GangName)
    if GangName then 
        local GradesData = Gangs[GangName].grades
        for i=1, #GradesData, 1 do
            MySQL.Async.execute('DELETE FROM gang_grades WHERE grade = @grade AND gang_name = @gang_name', { ['@grade'] = GradesData[i].grade, ['@gang_name'] = GangName })
        end
        MySQL.Async.execute('DELETE FROM gangs_data WHERE gang_name = @gang_name', { ['@gang_name'] = GangName })
        MySQL.Async.execute('DELETE FROM gangs WHERE name = @name', { ['@name'] = GangName })
        for i ,v in pairs(Members) do 
            if Members[i].gang == GangName then
           
                local xPlayer = ESX.GetPlayerFromIdentifier(Members[i].identifier)
                if xPlayer then
           
                    xPlayer.setGang("nogang", 0)
                else
                 
                    MySQL.Async.execute('UPDATE users SET gang = @gang, gang_grade = @gang_grade WHERE identifier = @identifier', 
                    {
                        ['@gang'] = 'nogang',
                        ['@gang_grade'] = 0,
                        ['@identifier'] = Members[i].identifier
                    }, function(result)
                    
                    end)
                end
            end
        end
        local NewGangs = {}
        for k,v in pairs(Gangs) do 
            if k ~= GangName then 
                NewGangs[k] = v   
            end 
        end 
        Wait(50)
        Gangs = NewGangs
        TriggerEvent('For5M:SetGangs' ,Gangs ) 
        cb(true)
    end
end)

ESX.RegisterServerCallback('FMGangs:DisbandGang', function(source, cb, GangName)
    if GangName then 
        local state = 1
        if Gangs[GangName].disband == 1 then state = 0 end 
        MySQL.Async.execute('UPDATE gangs SET disband = @disband WHERE name = @gang_name', 
        {
            ['@disband'] = state,
            ['@gang_name'] = GangName
        }, function(result)
            Gangs[GangName].disband = state
            cb(true)
        end)

    end
end)

ESX.RegisterServerCallback('FMGangs:TeleportToGang', function(source, cb, GangName)
    if GangName then 
        if Gangs[GangName] ~= nil then
            if Gangs[GangName].boss[1] ~= nil then
                if Gangs[GangName].boss[1].coord ~= nil then
                    TriggerClientEvent('For5M:TpToCoord', source, Gangs[GangName].boss[1].coord)
                end
            end
        end
    end
end)

ESX.RegisterServerCallback('FMGangs:DeleteMarker', function(source, cb, GangName, Type, ActionID)
    if GangName and ActionID and Type then
        DeleteAction(GangName, ActionID, Type)
        TriggerClientEvent('For5M:UpdateMyGang' , -1 ,GangName )
        cb(true)
    end
end)

function DeleteAction(GangName, ActionID, Type)
    if GangName and ActionID and Type then
        local Data = Gangs[GangName][Type]
        for i , v in pairs(Data) do
            if Data[i].code == ActionID then
                Data[i] = nil 
                break
            end
        end
        MySQL.Async.execute('UPDATE gangs_data SET '..Type..' = @type WHERE gang_name = @gang_name', 
        {
            ['@type'] = json.encode(Gangs[GangName][Type]),
            ['@gang_name'] = GangName
        }, function(result)
            Gangs[GangName][Type] = Data
        end)
    end
end

ESX.RegisterServerCallback('FMGangs:EditMarker', function(source, cb, GangName, Option, Code, NewData)
    if GangName and Code and NewData then 
        EditAction(GangName, Code, Option, NewData)
        TriggerClientEvent('For5M:UpdateMyGang' , -1 ,GangName )
        cb(true)
    end
end)

function EditAction(GangName, ActionID, Type, NewData)
    if GangName and ActionID and Type and NewData then
        local Data = Gangs[GangName][Type]
        for i , v in pairs(Data) do
            if Data[i].code == ActionID then
                Gangs[GangName][Type][i].coord = { x = NewData.coord.x, y = NewData.coord.y, z = NewData.coord.z }
                Gangs[GangName][Type][i].heading = NewData.heading
                MySQL.Async.execute('UPDATE gangs_data SET '..Type..' = @type WHERE gang_name = @gang_name', 
                {
                    ['@type'] = json.encode(Gangs[GangName][Type]),
                    ['@gang_name'] = GangName
                }, function(result)
                end)
                break
            end
        end
    end
end

ESX.RegisterServerCallback('FMGangs:UpdateOthers', function(source, cb, GangName, Type, Amount)
    if GangName and Type and Amount then
        UpdateOthers(GangName, Type, Amount, false ) 
        cb(true)
    end
end)

function UpdateOthers(GangName, Type, Amount, remove_or_add)
    if GangName and Type and Amount then
        if Type == 'money' then
            if remove_or_add == 'add' then
                local Data = Gangs[GangName].others[Type]
                local NewData = Data + Amount
                Gangs[GangName].others[Type] = NewData
            elseif remove_or_add == 'remove' then
                local Data = Gangs[GangName].others[Type]
                if Data >= Amount then
                    local NewData = Data - Amount
                    Gangs[GangName].others[Type] = NewData
                end
            end
        else
           Gangs[GangName].others[Type] = Amount
        end
        MySQL.Async.execute('UPDATE gangs_data SET others = @others WHERE gang_name = @gang_name', 
        {
            ['@others'] = json.encode(Gangs[GangName].others),
            ['@gang_name'] = GangName
        }, function(result)
            TriggerClientEvent('For5M:UpdateMyGangOthersData' , -1 , GangName  , Gangs[GangName].others )
        end)
    end
end

function UpdateXPAndLeveL(GangName, Type, Amount)
    if GangName and Type and Amount then
        if Type == 'xp' then
            if Gangs[GangName].xp + Amount >= Config.GangLeveL[Gangs[GangName].level + 1] then
                Gangs[GangName].xp = Gangs[GangName].xp + Amount - Config.GangLeveL[Gangs[GangName].level + 1]
                Gangs[GangName].level = Gangs[GangName].level + 1
            else
                Gangs[GangName].xp = Gangs[GangName].xp + Amount
            end
        elseif Type == 'level' then
            Gangs[GangName].level = Gangs[GangName].level + Amount
        end
        MySQL.Async.execute('UPDATE gangs SET xp = @xp AND level = @level WHERE name = @name', 
        {
            ['@xp'] = Gangs[GangName].xp,
            ['@level'] = Gangs[GangName].level,
            ['@name'] = Name
        }, function(result)
        end)
    end
end 

ESX.RegisterServerCallback('FMGangs:UpdateGang', function(source, cb, gangname, label, expire, logo , webhook)
    if label and expire and logo then
        local DayToSecond = (expire * 86400) + os.time()
        MySQL.Async.execute('UPDATE gangs SET expire = @expire, expire_day = @expire_day, label = @label, logo = @logo , webhook = @webhook WHERE name = @name', 
        {
            ['@expire'] = DayToSecond,
            ['@expire_day'] = expire,
            ['@label'] = label,
            ['@logo'] = logo,
            ['@name'] = gangname ,
            ['@webhook'] = webhook , 
            
        }, function(result)
                Gangs[gangname].expire = DayToSecond
                Gangs[gangname].expire_day = expire
                Gangs[gangname].label = label
                Gangs[gangname].logo = logo
                Gangs[gangname].webhook = webhook
            cb(true)
        end)
    end
end)

ESX.RegisterServerCallback('FMGangs:AddOption', function(source, cb, GangName, Type, Data)
    if GangName and Type and Data then
        
        local OldData = Gangs[GangName][Type]
        if Type == 'blip' then
            table.insert(OldData, { type = Data.type , marker = Data.marker , color = Data.color , coord  = { x = Data.coord.x, y = Data.coord.y, z = Data.coord.z } , heading = 0 ,  code = CountTable(OldData) + 1    } )
        elseif Type == 'boss' then
            table.insert(OldData, { coord = { x = Data.coord.x, y = Data.coord.y, z = Data.coord.z }, type = Data.type , code = CountTable(OldData) + 1 , marker = Data.marker , heading = Data.heading , size  = Data.size , color = Data.color   })
        elseif Type == 'locker' then
            table.insert(OldData, { coord = { x = Data.coord.x, y = Data.coord.y, z = Data.coord.z }, type = Data.type , code = CountTable(OldData) + 1 , marker = Data.marker , heading = Data.heading , size  = Data.size , color = Data.color })
        elseif Type == 'armory' then
            table.insert(OldData, { coord = { x = Data.coord.x, y = Data.coord.y, z = Data.coord.z }, type = Data.type , code = CountTable(OldData) + 1 , marker = Data.marker , heading = Data.heading , size  = Data.size , color = Data.color, armory = {}  })
        elseif Type == 'veh' then
            table.insert(OldData, { coord = { x = Data.coord.x, y = Data.coord.y, z = Data.coord.z }, type = Data.type , code = CountTable(OldData) + 1 , marker = Data.marker , heading = Data.heading , size  = Data.size , color = Data.color   })
        elseif Type == 'deletecars' then
            table.insert(OldData, { coord = { x = Data.coord.x, y = Data.coord.y, z = Data.coord.z }, type = Data.type , code = CountTable(OldData) + 1 , marker = Data.marker , heading = Data.heading , size  = Data.size , color = Data.color   })
        elseif Type == 'vehspawn' then
            table.insert(OldData, { coord = { x = Data.coord.x, y = Data.coord.y, z = Data.coord.z }, type = Data.type , code = CountTable(OldData) + 1 , marker = Data.marker , heading = Data.heading , size  = Data.size , color = Data.color   })
        elseif Type == 'heli' then
            table.insert(OldData, { coord = { x = Data.coord.x, y = Data.coord.y, z = Data.coord.z }, type = Data.type , code = CountTable(OldData) + 1 , marker = Data.marker , heading = Data.heading , size  = Data.size , color = Data.color   })
        elseif Type == 'helispawn' then
            table.insert(OldData, { coord = { x = Data.coord.x, y = Data.coord.y, z = Data.coord.z }, type = Data.type , code = CountTable(OldData) + 1 , marker = Data.marker , heading = Data.heading , size  = Data.size , color = Data.color   })
        elseif Type == 'boat' then
            table.insert(OldData, { coord = { x = Data.coord.x, y = Data.coord.y, z = Data.coord.z }, type = Data.type , code = CountTable(OldData) + 1 , marker = Data.marker , heading = Data.heading , size  = Data.size , color = Data.color   })
         elseif Type == 'boatspawn' then
            table.insert(OldData, { coord = { x = Data.coord.x, y = Data.coord.y, z = Data.coord.z }, type = Data.type , code = CountTable(OldData) + 1 , marker = Data.marker , heading = Data.heading , size  = Data.size , color = Data.color   })
        elseif Type == 'craft' then
            table.insert(OldData, { coord = { x = Data.coord.x, y = Data.coord.y, z = Data.coord.z }, type = Data.type , code = CountTable(OldData) + 1 , marker = Data.marker , heading = Data.heading , size  = Data.size , color = Data.color   })
        elseif Type == 'shop' then
            table.insert(OldData, { coord = { x = Data.coord.x, y = Data.coord.y, z = Data.coord.z }, type = Data.type , code = CountTable(OldData) + 1 , marker = Data.marker , heading = Data.heading , size  = Data.size , color = Data.color   })
        elseif Type == 'flag' then
            table.insert(OldData, { coord = { x = Data.coord.x, y = Data.coord.y, z = Data.coord.z } ,type = 'flag', marker = Data.marker ,heading = Data.heading, code = CountTable(OldData) + 1  })
        elseif Type == 'bots' then
            table.insert(OldData, { coord = { x = Data.coord.x, y = Data.coord.y, z = Data.coord.z } ,type = 'ped', marker = Data.marker ,heading = Data.heading, code = CountTable(OldData) + 1  })
        end
        MySQL.Async.execute('UPDATE gangs_data SET '..Type..' = @type WHERE gang_name = @gang_name', 
        {
            ['@type'] = json.encode(OldData),
            ['@gang_name'] = GangName
        }, function(result)
            Gangs[GangName][Type] = OldData
            TriggerClientEvent('For5M:UpdateMyGang' , -1 ,GangName )
        end)
    end 
end)

-------------------
--- Get Data
-------------------

ESX.RegisterServerCallback('FMGangs:GetPanelData', function(source, cb)
    local TopGangs = {}
    local AllMembers = {}
    local OnlinePLayers = 0 
    local OfflinePLayers = 0 
   
    for k,v in pairs(Gangs) do 

        local UnixExpire = (v.expire - os.time()) / 86400
        local Az100 = 100 / v.expire_day * UnixExpire
        table.insert(TopGangs, { Name = v.name, Level = v.level , XP = v.xp , Expire = v.expire_day, ExpirationDP = Az100 , logo = v.logo })
        AllMembers[v.name] = {}
        AllMembers[v.name]['online'] = {} 
        AllMembers[v.name]['offline'] = {} 
     
    end
    table.sort(TopGangs, function(a, b)
		return a.Level > b.Level
	end)
    for i ,v in pairs(Members) do 
        if Members[i].gang ~= nil  and  Members[i].gang ~= 'nogang' then
            local xPlayer = ESX.GetPlayerFromIdentifier(Members[i].identifier)
            if xPlayer then
                OnlinePLayers  = OnlinePLayers + 1 
               table.insert(AllMembers[Members[i].gang]['online'] ,  { Name = Members[i].playerName, Grade = Gangs[Members[i].gang].grades[tonumber(Members[i].gang_grade)].label, Hex = Members[i].identifier, Avatar = GetAvatar(xPlayer.source) })
            else
                OfflinePLayers  = OfflinePLayers + 1 
                table.insert( AllMembers[Members[i].gang]['offline'] , { Name = Members[i].playerName, Grade = Gangs[Members[i].gang].grades[tonumber(Members[i].gang_grade)].label, Hex = Members[i].identifier, Avatar = Config.DefaultAvatar })
            end
        end
    end

   cb( CountTable(Gangs), OnlinePLayers, OfflinePLayers, OnlinePLayers + OfflinePLayers, TopGangs,  AllMembers )
end)

ESX.RegisterServerCallback('FMGangs:GetOthersFromGang', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local name = xPlayer.gang.name 
    if name then
        local PlayersOfGang = 0
        for i ,v in pairs(Members) do 
            if Members[i].gang ~= nil and  Members[i].gang == name then
                PlayersOfGang = PlayersOfGang + 1  
            end
        end
        if Gangs[name] ~= nil then
            cb(Gangs[name].others, PlayersOfGang)
        end
    end
end)

function CountTable(tab)
    local C = 0 
    for k,v in pairs(tab) do 
        C = C + 1  
    end 
    return C 
end 
ESX.RegisterServerCallback('FMGangs:GetGangsData', function(source, cb)
    local Expires = {}
    local AllMembers = {}
    for k,v in pairs(Gangs) do 
        local UnixExpire = (v.expire - os.time()) / 86400
        local Az100 = 100 / v.expire_day * UnixExpire
        Expires[v.name] = Az100
        AllMembers[v.name] = {}
        AllMembers[v.name]['online'] = {} 
        AllMembers[v.name]['offline'] = {} 
    end
    for i=1, #Members, 1 do
        if Members[i].gang ~= 'nogang' then
            local xPlayer = ESX.GetPlayerFromIdentifier(Members[i].identifier)
            if xPlayer then          
                table.insert( AllMembers[Members[i].gang]['online'] ,  { Name = Members[i].playerName, Grade = Gangs[Members[i].gang].grades[tonumber(Members[i].gang_grade)].label, Hex = Members[i].identifier, Avatar = GetAvatar(xPlayer.source), status = 'online', gang = Members[i].gang, grade_number = tonumber(Members[i].gang_grade), ID = xPlayer.source })           
            else
                table.insert( AllMembers[Members[i].gang]['offline'], { Name = Members[i].playerName, Grade = Gangs[Members[i].gang].grades[tonumber(Members[i].gang_grade)].label, Hex = Members[i].identifier, Avatar = Config.DefaultAvatar, status = 'offline', gang = Members[i].gang, grade_number = tonumber(Members[i].gang_grade) })
            end
        end
    end
    cb(Gangs , Expires , AllMembers  , AllMembers[ESX.GetPlayerFromId(source).gang.name] ) 
end)

ESX.RegisterServerCallback('FMGangs:GetGangGps', function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then 
        local playergang = xPlayer.gang.name
        if playergang ~= 'nogang' then 
            if Gangs[playergang] and tonumber(Gangs[playergang].others['gps']) == 1 then
                cb(true)
            else
                cb(false)
            end
        else 
            cb(false)
        end 
    end 
end)
local dutyTable = {}
CreateThread(function()
    while true do
        local sendTable = {}
        for k, v in pairs(dutyTable) do
            local coords = GetEntityCoords(GetPlayerPed(k))
            local tempVar = v
            tempVar.playerId = k
            tempVar.coords = coords
            table.insert(sendTable, tempVar)
        end
        for player, kekw in pairs(dutyTable) do
            TriggerClientEvent('For5MGBlip:receiveData', player, player, sendTable , ESX.GetPlayerFromId(player).gang.name )
        end
        Wait(3500)
    end
end)

RegisterNetEvent('For5MGBlip:setDuty')
AddEventHandler('For5MGBlip:setDuty', function(onDuty)
    local src = source
    if onDuty then
        local xPlayer = ESX.GetPlayerFromId(src)
        local playergangname = xPlayer.gang.name
        local playergang = xPlayer.gang
        if tonumber(Gangs[playergangname].others['gps']) == 1 then
            dutyTable[src] = {
                gang = playergang.name,
                name = string.gsub(xPlayer.name, "_", " "),
                prefix = nil,
            }
        end
    else
        if dutyTable[src] then
            dutyTable[src] = nil
            for k, v in pairs(dutyTable) do
                TriggerClientEvent('For5MGBlip:removeUser', k, src)
            end
        end
    end
end)


AddEventHandler('playerDropped', function(reason)
    local src = source
    if dutyTable[src] then
        dutyTable[src] = nil
        for k, v in pairs(dutyTable) do
            TriggerClientEvent('For5MGBlip:removeUser', k, src)
        end
    end
end)
RegisterNetEvent('For5MGBlip:toggleSiren')
AddEventHandler('For5MGBlip:toggleSiren', function(isOn)
    local src = source
    local playergang = ESX.GetPlayerFromId(src).gang
    if isOn then
        dutyTable[src].siren = true
        dutyTable[src].flashColors = 1
    else
        dutyTable[src].siren = false
        dutyTable[src].flashColors = nil
    end
end)
local PlayersOGInventory = {}
ESX.RegisterServerCallback('For5M:OpenInventory', function(source , cb  , code )
    PlayersOGInventory[source] = code 
    local playergang = ESX.GetPlayerFromId(source).gang.name
    local armory  , key  =   GetArmoryByCode( playergang , code )
    if key == 0 then return cb(false) end 
    local items = armory['items'] or {}
    local weapons = armory['weapons'] or {}
    TriggerClientEvent(Config.OpenInventory , source, { items =  items  , weapons = weapons } )
    cb(true)
end)
RegisterNetEvent(Config.AddItemToInventory)
AddEventHandler(Config.AddItemToInventory, function(type ,name , count )
    local playergang = ESX.GetPlayerFromId(source).gang.name
    local armory =   GetArmoryByCode( playergang ,  PlayersOGInventory[source] )
    local items = armory['items'] or {}
    local weapons = armory['weapons'] or {}
    local xPlayer = ESX.GetPlayerFromId(source)
    if  not Gangs[ playergang ].grades[ xPlayer.gang.grade ].access['putitem'] then return  TriggerClientEvent(Config.showNotification , source , 'You Dont Have Access To put Item') end 
    if type == 'item_standard'  then 
        table.insert( items , {name = name, count =count , label = name })
        xPlayer.removeInventoryItem(name, count)
        TriggerEvent('For5M:SendLog', source , 'Inventory' , ' Put item ' .. name .. ' | count : ' .. count )
        
    else 
        table.insert( weapons , {name = name, ammo =count })
        xPlayer.removeWeapon(name)
        TriggerEvent('For5M:SendLog', source , 'Inventory' , ' Put weapon ' .. name .. ' | ammo : ' .. count )
    end 
    armory['items'] =  items
    armory['weapons'] =  weapons
    UpdateGangsData(playergang, 'armory', Gangs[playergang]['armory'])
    TriggerClientEvent(Config.OpenInventory , source, { items = items , weapons = weapons  } )
end)
RegisterNetEvent(Config.TakeItemEvent )
AddEventHandler(Config.TakeItemEvent , function(type ,name , count ) -- take
    local playergang = ESX.GetPlayerFromId(source).gang.name
    local armory , key =   GetArmoryByCode( playergang ,  PlayersOGInventory[source] )
    local items = armory['items'] or {}
    local weapons = armory['weapons'] or {}
    local xPlayer = ESX.GetPlayerFromId(source)
    if  not Gangs[ playergang ].grades[ xPlayer.gang.grade ].access['takeitem'] then return TriggerClientEvent(Config.showNotification , source , 'You Dont Have Access To Take Item') end 
    if type == 'item_standard'  then 
        for k,v in pairs( items ) do 
            if v.name == name  and v.count>= count then 
                items[k]['count'] = items[k]['count'] - count 
                xPlayer.addInventoryItem(v.name , count)
                TriggerEvent('For5M:SendLog', source , 'Inventory' , ' Take item ' .. v.name .. ' |  ' .. count )
                break 
            end 
        end 
    else 
        for k,v in pairs( weapons ) do 
            if v.name == name  then 
                xPlayer.addWeapon(v.name , v.ammo ) 
                weapons[k] = nil 
                TriggerEvent('For5M:SendLog', source , 'Inventory' , ' Take weapon ' .. v.name .. ' | ammo : ' .. v.ammo )
                break 
            end 
        end 
    end 
    Wait(50)
    armory['items'] =  items
    armory['weapons'] =  weapons
    UpdateGangsData(playergang, 'armory', Gangs[playergang]['armory'])
    TriggerClientEvent(Config.OpenInventory , xPlayer.source, { items =  armory['items']  , weapons = armory['weapons']  }  )

end)
RegisterNetEvent('For5M:itemPacks')
AddEventHandler('For5M:itemPacks', function ( gang, name ) 
    if type(Gangs[gang]) ~= 'table'or type(Gangs[gang]['armory']) ~= 'table' then return end 
    for k,v in pairs( Gangs[gang]['armory'] ) do 
        local items = v['items'] or {}
        local weapons = v['weapons'] or {}
        for k,v in pairs( Config.Packs[name] ) do
            if name == 'itempack' or name == 'attchmentpack'  then
                table.insert( items , {name = k, count =v , label = k })
            else  
                for i=1,  v.Count , 1 do
                    table.insert( weapons , {name = k, ammo =v.ammo })
                end
            end 
        end 
        v['items'] = items
        v['weapons'] = weapons
        break 
    end
    UpdateGangsData(gang, 'armory', Gangs[gang]['armory'])
end)

function GetArmoryByCode( playergang , code )
    local key  = 0
    if not  Gangs[playergang]  or not Gangs[playergang]['armory'] then return {} , 0 end 
    for k,v in pairs( Gangs[playergang]['armory'] ) do 
        if v.code == code then 
            key = k 
        end 
    end 
    if key > 0 then 
        return Gangs[playergang]['armory'][key]  , key
    end 
end 
ESX.RegisterServerCallback('FMGangs:MyGangLevel', function(source, cb)
    local playergang = ESX.GetPlayerFromId(source).gang.name
    if Gangs[playergang] ~= nil then 
        cb( Gangs[playergang].level , Gangs[playergang].xp   )
    else 
        cb(0)
    end 

 end)
 ESX.RegisterServerCallback('FMGangs:GetRankAccess', function(source, cb)
    local playergang = ESX.GetPlayerFromId(source).gang.name
    local GradeNumber =  ESX.GetPlayerFromId(source).gang.grade
    if Gangs[playergang] ~= nil then 
        cb( Gangs[playergang].grades[tonumber(GradeNumber)].access )
    else 
        cb({})
    end 
 end) 
 ESX.RegisterServerCallback('FMGangs:GetPlayerData', function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    cb(player , GetAvatar(source) )

 end)
 exports("GetMoneyOfGang", function(playergang) 
    if Gangs[playergang] ~= nil then 
        return Gangs[playergang].others.money 
    else 
        return 0 
    end 
end) 
exports("AddGangMoney", function(playergang , Amount ) 
    if Gangs[playergang] ~= nil then 
        UpdateOthers(playergang, 'money', Amount, 'add') 
        return  true 
    else 
        return false  
    end 
end) 
exports("RemoveGangMoney", function(playergang , Amount ) 
    if Gangs[playergang] ~= nil then 
        if  Gangs[playergang].others.money >= Amount then 
            UpdateOthers(playergang, 'money', Amount, 'remove') 
            return  true 
        else 
            return false  
        end 
    else 
        return false  
    end 
end) 
function GangPayCheck() 
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        local gang	  = xPlayer.gang.name

        if gang ~= 'nogang' and Gangs[gang] ~= nil  then 
        	local BossMoney  = Gangs[gang].others.money  
            local gsalary =   Gangs[gang].grades[xPlayer.gang.grade].salary
            if gsalary and type(gsalary) == 'number' and  tonumber(gsalary) and  BossMoney >= gsalary then
                xPlayer.addBank(gsalary)
                UpdateOthers(gang, 'money', gsalary, 'remove') 
                TriggerClientEvent(Config.showAdvancedNotification , xPlayer.source, '~h~Gang House', '~h~Payame Daryafte Hoghogh', '~h~Mablaqe Daryafti: '.. gsalary, 'CHAR_MP_DETONATEPHONE', 9)
            end
        end 

    end 

end 

CreateThread(function()
    Wait(3000)
    UpdatePayCheck()
end)
function UpdatePayCheck()
    SetTimeout( Config.TimeToPay * 60000, function()
        GangPayCheck() 
        UpdatePayCheck()
    end)
end 
function UpdateRankOfPlayers(GangName  , FinalRank   )
    for i ,v in pairs(Members) do 
        if Members[i].gang == GangName then
       
            local xPlayer = ESX.GetPlayerFromIdentifier(Members[i].identifier)
            if xPlayer  then
                if xPlayer.gang.grade == FinalRank then 
                    xPlayer.setGang(GangName, FinalRank - 1 )
                end 
            else
             
                MySQL.Async.execute('UPDATE users SET gang_grade = @gang_grade WHERE identifier = @identifier AND gang = @gang  AND gang_grade = @gang_gradef  ', 
                {
                    ['@gang'] = GangName ,
                    ['@gang_gradef'] = FinalRank ,
                    ['@gang_grade'] = FinalRank - 1 ,
                    ['@identifier'] = Members[i].identifier
                }, function(result)
                
                end)
            end
        end
    end
end 
function UpdateRankOfPlayersUP(GangName  , FinalRank   )
    for i ,v in pairs(Members) do 
        if Members[i].gang == GangName then
       
            local xPlayer = ESX.GetPlayerFromIdentifier(Members[i].identifier)
            if xPlayer  then
                if xPlayer.gang.grade == FinalRank then 
                    xPlayer.setGang(GangName, FinalRank + 1 )
                end 
            else
             
                MySQL.Async.execute('UPDATE users SET gang_grade = @gang_grade WHERE identifier = @identifier AND gang = @gang  AND gang_grade = @gang_gradef  ', 
                {
                    ['@gang'] = GangName ,
                    ['@gang_gradef'] = FinalRank ,
                    ['@gang_grade'] = FinalRank + 1 ,
                    ['@identifier'] = Members[i].identifier
                }, function(result)
                
                end)
            end
        end
    end
end 