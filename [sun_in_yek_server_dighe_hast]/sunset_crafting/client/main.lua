-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118
}
local spam = false
ESX = exports['essentialmode']:getObject()

local labels = {}
local craftingQueue = {}
local currentGangInventoryId = 1
Citizen.CreateThread(function()

        while not ESX or not ESX.IsPlayerLoaded() do
            Wait(1000)
        end

        job = ESX.GetPlayerData().job.name
        grade = ESX.GetPlayerData().job.grade
        gang = ESX.GetPlayerData().gang.name
        for _, v in ipairs(Config.Workbenches) do
            if v.blip then
                local blip = AddBlipForCoord(v.coords)

                SetBlipSprite(blip, Config.BlipSprite)
                SetBlipScale(blip, 0.8)
                SetBlipColour(blip, Config.BlipColor)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(Config.BlipText)
                EndTextCommandSetBlipName(blip)
            end
        end
    end
)

RegisterNetEvent("esx:setJob",function(j)
    job = j.name
    grade = j.grade
end)

local coordscraft = nil
function isNearWorkbench()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local near = false

    for _, v in ipairs(Config.Workbenches) do
        local dst = #(coords - v.coords)
        if dst < v.radius then
            near = true
            coordscraft = v.coords
        end
    end

    if near then
        return true
    else
        return false
    end
end



local useginv = false
function openWorkbench(val, index)
    ESX.TriggerServerCallback("gangs:getGangData2",function(data)
        if data ~=nil then
            local level = data.level
            TriggerScreenblurFadeIn(1000)
            local inv = {}
            ESX.TriggerServerCallback('gangs:getgradecraft', function(perm)
                local grade = tostring(ESX.GetPlayerData().gang.grade)
                if not perm[grade] then
                    perm[grade] = {}
                end
                local useLocker = false
                if perm[grade]['craftwithinventory'] then
                    local p = promise.new()
                    ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'question',
                    {
                        title 	 = '',
                        align    = 'center',
                        question = 'Aya mikhahid az locker gang estefade konid?',
                        elements = {
                            {label = 'Bale', value = 'yes'},
                            {label = 'Kheir', value = 'no'},
                        }
                    }, function(data, menu)
                        menu.close()
                        p:resolve(data.current.value == 'yes')
                    end)
                    useLocker = Citizen.Await(p)
                end
                SetNuiFocus(true, true)
                if perm[grade]['craftwithinventory'] and useLocker then
                    currentGangInventoryId = type(perm[grade]['craftwithinventory']) == 'number' and perm[grade]['craftwithinventory'] or 1
                    for _, v in ipairs(exports['gangprop']:getGangInventory(currentGangInventoryId, true).items) do
                        if v.location == currentGangInventoryId then
                            inv[v.name] = v.count
                        end
                    end
                    wait = false
                    useginv = true
                    ESX.Alert('Warning','Shoma dar hal estefade az locker gang hastid',5000,'warning')
                else
                    for _, v in ipairs(ESX.GetPlayerData().inventory) do
                        inv[v.name] = v.count
                    end
                    ESX.Alert('Warning','Shoma dar hal estefade az locker shakhsi hastid',5000,'warning')
                    useginv = false
                end
                for _, v in ipairs(ESX.GetPlayerData().loadout) do
                    inv[v.name] = 1
                end
                local gang, job, jobGrade = ESX.GetPlayerData().gang.name, ESX.GetPlayerData().job.name, ESX.GetPlayerData().job.grade
                local craftConfig = ESX.CopyTable(Config.Recipes)
                for k , v in pairs(craftConfig) do
                    if not k:find('TEMP') then
                        v.name = k
                    end
                    if k:find('TEMP') then
                        labels[k] =  ('%s(TEMP %sD)'):format(ESX.getItemLabel(v.name), v.day)
                    else
                        labels[k] = ESX.getItemLabel(v.name)
                    end
                    for k2, v2 in pairs(v.Ingredients) do
                        labels[k2] = ESX.getItemLabel(k2)
                    end
                    if v.access and (not v.access[gang] and (not v.access[job] or jobGrade < v.access[job])) then
                        craftConfig[k] = nil
                    end
                    if v.location and not v.location.all and not v.location[index] then
                        craftConfig[k] = nil
                    end
                end

                local cost = 0

                if Config.gangscost[level] or Config.gangscost[data.gang_name] then
                    cost = Config.gangscost[data.gang_name] or Config.gangscost[level]
                end
                SendNUIMessage(
                    {
                        type = "open",
                        recipes = craftConfig,
                        names = labels,
                        level = level,
                        inventory = inv,
                        job = job,
                        grade = grade,
                        hidecraft = Config.HideWhenCantCraft,
                        categories = Config.Categories,
                        money = ESX.GetPlayerData().money ,
                        cost = cost,
                    }
                )
            end)
        end
    end)
end
local near = 0
local black = {
    ['Medics'] = true,
    ['Weazels'] = true,
    ['Army'] = true,
    ['TX'] = true,
    ['Mechanics'] = true,
    ['D_O_J'] = true,
    Admins = true,
}
Citizen.CreateThread(function()
    while ESX == nil or not ESX.IsPlayerLoaded() do
        Wait(5000)
    end
    for _, v in ipairs(Config.Workbenches) do
        if not v.access or v.access[job] or v.access[gang] then
            ESX.RegisterPoint(v.coords,2,{
                Color = v.color or {R = 51,G = 204,B = 25,A = 255},
                DrawDistance = v.drawDistance or 3,
                Radius = v.radius2 or 0.7,
                Type = v.type or 12,
                worldCheck = false,
            },{
                Notification = nil,
                DrawText = v.hideLabel and nil or 'Dokme ~INPUT_CONTEXT~ jahat baz kardan menu crafting',
                DrawTextRadius = v.drawTextRadius or 1.0,
                DrawTextCoords = v.coords,
                Key = 'e',
                CB = function()
                    if ESX.GetPlayerData().World == 0 or exports['gangs']:isInGangWorld() then
                        if black[ESX.GetPlayerData().gang.name] then return end
                        openWorkbench(v, _)
                    end
                end,
            },{
                In = nil,
                Out = ESX.UI.Menu.CloseAll
            })
        end
    end
end)

RegisterNetEvent("core_crafting:craftStart")
AddEventHandler("core_crafting:craftStart", function(item, count, craftId)
        local id = math.random(000, 999)
        local needstart = craftingQueue[1] == nil
        table.insert(craftingQueue, {time = Config.Recipes[item].Time, item = item, count = count, id = id, craftId = craftId})
        if needstart then
            Citizen.CreateThread(function()
                while craftingQueue[1] ~= nil do
                    Citizen.Wait(1000)
            
                    if craftingQueue[1] ~= nil then
                        if not Config.CraftingStopWithDistance or (Config.CraftingStopWithDistance and isNearWorkbench()) then
                            craftingQueue[1].time = craftingQueue[1].time - 1
            
                            SendNUIMessage(
                                {
                                    type = "addqueue",
                                    item = craftingQueue[1].item,
                                    time = craftingQueue[1].time,
                                    id = craftingQueue[1].id
                                }
                            )
            
                            if craftingQueue[1].time == 0 then
                                if craftingQueue[1].dischant then
                                    ESX.TriggerServerEvent("core_crafting:dischant2", craftingQueue[1].item)
                                else
                                    ESX.TriggerServerEvent("core_crafting:itemCrafted", craftingQueue[1].item, coordscraft, craftingQueue[1].craftId)
                                end
                                table.remove(craftingQueue, 1)
                            end
                        end
                    else
                        Citizen.Wait(4000)
                    end
                end
            end)
        end
        SendNUIMessage(
            {
                type = "crafting",
                item = item
            }
        )

        SendNUIMessage(
            {
                type = "addqueue",
                item = item,
                time = Config.Recipes[item].Time,
                id = id
            }
        )
    end
)

RegisterNetEvent("core_crafting:sendMessage")
AddEventHandler(
    "core_crafting:sendMessage",
    function(msg)
        SendTextMessage(msg)
    end
)

RegisterNUICallback(
    "close",
    function(data)
        TriggerScreenblurFadeOut(1000)
        SetNuiFocus(false, false)
    end
)

RegisterNUICallback(
    "craft",
    function(data)
        if spam then return end
        spam = true
        Citizen.SetTimeout(5000,function()
            spam = false
        end)
        local item = data["item"]
        local needlevel = Config.Recipes[item].Level
        ESX.TriggerServerCallback("gangs:getGangData2",function(data)
            if data ~=nil then
                local level = data.level
                if needlevel <= level then
                    ESX.TriggerServerCallback('gangs:getgradecraft', function(perm)
                        local cancraft = false
                        local grade = tostring(ESX.GetPlayerData().gang.grade)
                        if perm[grade] and (perm[grade][tostring(needlevel)] or perm[grade]['all'] or ESX.GetPlayerData().gang.grade >= exports['gangs']:getGradeCount()) then
                            cancraft = true
                        end
                        if cancraft then
                            if Config.Recipes[item].animation then
                                TriggerEvent('anim:play', Config.Recipes[item].animation)
                            end
                            ESX.TriggerServerEvent("core_crafting:craft", item, useginv, currentGangInventoryId)
                        else
                            ESX.Alert('Deny','Shoma dastresi craft in item ra nadarid',5000,'error')
                        end
                    end)
                end
            end
        end)
    end
)

RegisterNUICallback(
    "dischant",
    function(data)
        if spam then return end
        spam = true
        Citizen.SetTimeout(5000,function()
            spam = false
        end)
        local item = data["item"]
        ESX.TriggerServerEvent("core_crafting:dischant", item)
        
    end
)
RegisterNetEvent("dischant")
AddEventHandler(
    "dischant",
    function(item)
        local id = math.random(000, 999)
        local needstart = craftingQueue[1] == nil
        table.insert(craftingQueue, {time = 30, item = item, count = 1, id = id,dischant = true})
        if needstart then
            Citizen.CreateThread(function()
                while craftingQueue[1] ~= nil do
                    Citizen.Wait(1000)
            
                    if craftingQueue[1] ~= nil then
                        if not Config.CraftingStopWithDistance or (Config.CraftingStopWithDistance and isNearWorkbench()) then
                            craftingQueue[1].time = craftingQueue[1].time - 1
            
                            SendNUIMessage(
                                {
                                    type = "addqueue",
                                    item = craftingQueue[1].item,
                                    time = craftingQueue[1].time,
                                    id = craftingQueue[1].id
                                }
                            )
            
                            if craftingQueue[1].time == 0 then
                                if craftingQueue[1].dischant then
                                    ESX.TriggerServerEvent("core_crafting:dischant2", craftingQueue[1].item)
                                else
                                    ESX.TriggerServerEvent("core_crafting:itemCrafted", craftingQueue[1].item, coordscraft, craftingQueue[1].craftId)
                                end
                                table.remove(craftingQueue, 1)
                            end
                        end
                    else
                        Citizen.Wait(4000)
                    end
                end
            end)
        end
        SendNUIMessage(
            {
                type = "crafting",
                item = item
            }
        )

        SendNUIMessage(
            {
                type = "addqueue",
                item = item,
                time = 30,
                id = id
            }
        )
    end
)
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = ((2 / dist) * 2) * (0.5 / GetGameplayCamFov()) * 100

    if onScreen then
        SetTextColour(255, 255, 255, 255)
        SetTextScale(0.0 * scale, 0.35 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextCentre(true)

        SetTextDropshadow(1, 1, 1, 1, 255)

        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55 * scale, 4)
        local width = EndTextCommandGetWidth(4)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

RegisterCommand('under',function()
    if GetResourceKvpInt("offunder") == 1 then
        SetResourceKvpInt("offunder",0)
        ESX.ShowNotification('Halat Anti Uder on shod')
    else
        SetResourceKvpInt("offunder",1)
        ESX.ShowNotification('Halat Anti under off shod')
    end
end)
TriggerEvent('chat:addSuggestion', '/under', 'toggle anti under', {
})

local lastz = 100
Citizen.CreateThread(function()
    if GetResourceKvpInt("offunder") == nil then
        SetResourceKvpInt("offunder",0)
    end
    Citizen.Wait(1000)
    while true do
        ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped)
        if IsEntityDead(ped) or not DoesEntityExist(ped) or (not veh) or GetResourceKvpInt("offunder") == 1 then
            Citizen.Wait(1000) 
            goto next
        end
        if GetPedInVehicleSeat(veh,-1) == ped then
            local lastcoords = GetEntityCoords(veh)
            local lastz = lastcoords.z
            while not HasCollisionLoadedAroundEntity(ped) do
                local coords = GetEntityCoords(PlayerPedId())
                local newz = lastz - coords.z 
                if newz > 2 then
                    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
                    ESX.SetEntityCoordsNoOffset(veh,lastcoords)
                end
                Citizen.Wait(10)
            end
        end
        ::next::
        Citizen.Wait(100)
    end
end)