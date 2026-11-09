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
ESX = nil

local labels = {}
local craftingQueue = {}
local job2 = nil
local currentJob
Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(0)
        end

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

        job = ESX.GetPlayerData().job.name
        grade = ESX.GetPlayerData().job.grade
        ESX.TriggerServerCallback('jobcraft:getCoords', function(data)
            for k, v in pairs(data) do
                Config.Workbenches[k].coords = v
            end
            for _, v in pairs(Config.Workbenches) do
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
            for _, v in pairs(Config.Workbenches) do
                if v.eye then
                    exports['ox_target']:addSphereZone({
                        coords = v2,
                        radius = v.eyeRange,
                        options = {
                            {
                                label = 'Craft🔧',
                                onSelect = function()
                                    if v.job[job] or v.job[job2] then
                                        if v.job[job] then
                                            currentJob = job
                                        end
                                        if v.job[job2] then
                                            currentJob = job2
                                        end
                                        openWorkbench(v, _)
                                    end
                                end,
                            },
                        }})
                else
                    ESX.RegisterPoint(v.coords,v.range or 2,{
                        Color = v.color or {R = 51,G = 204,B = 25,A = 255},
                        DrawDistance = v.drawDistance or 5,
                        Radius = v.radius2 or 0.7,
                        Type =  v.type or 12,
                        world = 0,
                        permission_level = 8,
                    },{
                        Notification = nil,
                        DrawText = v.hideLabel and nil or 'Dokme ~INPUT_CONTEXT~ jahat baz kardan menu crafting',
                        DrawTextRadius = v.drawTextRadius or 4,
                        DrawTextCoords = v.coords,
                        Key = 'e',
                        CB = function()
                            if v.job[job] or v.job[job2] then
                                if v.job[job] then
                                    currentJob = job
                                end
                                if v.job[job2] then
                                    currentJob = job2
                                end
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
    end
)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob",function(j)
    job = j.name
    grade = j.grade
end)

RegisterNetEvent('core:setJobClothe', function(job)
    job2 = job
end)

local coordscraft = nil
function isNearWorkbench()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local near = false

    for _, v in pairs(Config.Workbenches) do
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
function openWorkbench(val, key)
    --local level = data.level
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    local inv = {}
    --ESX.TriggerServerCallback('gangs:getgradecraft', function(perm)
        --local grade = tostring(ESX.GetPlayerData().gang.grade)
        -- if perm[grade]['craftwithinventory'] then
        --     local wait = true
        --     ESX.TriggerServerCallback('gangs:getPropertyInventory3',function(data)
        --         for _, v in ipairs(data.items) do
        --             inv[v.name] = v.count
        --         end
        --         wait = false
        --     end,ESX.GetPlayerData().gang.name)
        --     while wait do Wait(100) end
        --     useginv = true
        --     ESX.Alert('Warning','Shoma dar hal estefade az locker gang hastid',5000,'warning')
        -- else
            for _, v in ipairs(ESX.GetPlayerData().inventory) do
                inv[v.name] = v.count
            end
           -- ESX.Alert('Warning','Shoma dar hal estefade az locker shakhsi hastid',5000,'warning')
            --useginv = false
        -- end
        for k , v in pairs(Config.Weapons) do
            labels[v.name] = ESX.getItemLabel(v.name)
        end
        local cost = 0 

        -- if Config.gangscost[level] or Config.gangscost[data.gang_name] then
        --     cost = Config.gangscost[data.gang_name] or Config.gangscost[level]
        -- end
        local resp = {}
        for k , v in pairs(Config.Recipes) do
            if (v.job[job] == true or v.job[job] == key) or (v.job2 and (v.job2[job2] == true or v.job2[job2] == key)) then
                resp[k] = v
            end
            labels[k] = ESX.getItemLabel(k)
            for k2, v2 in pairs(v.Ingredients) do
                labels[k2] = ESX.getItemLabel(k2)
            end
        end
        SendNUIMessage(
            {
                type = "open",
                recipes = resp,
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
    --end)		
end
local near = 0

-- Citizen.CreateThread(function()
--     while ESX == nil do 
--         Citizen.Wait(2000)
--     end
--     for _, v in pairs(Config.Workbenches) do
--         ESX.RegisterPoint(v.coords,2,{
--             Color = {R = 51,G = 204,B = 25,A = 255},
--             DrawDistance = 5,
--             Radius = 0.7,
--             Type = 12,
--             world = 0,
--             permission_level = 8,
--         },{
--             Notification = nil,
--             DrawText = 'Dokme ~INPUT_CONTEXT~ jahat baz kardan menu crafting',
--             DrawTextRadius = 4,
--             DrawTextCoords = v.coords,
--             Key = 'e',
--             CB = function()
--                 if v.job[job] or v.job[job2] then
--                     openWorkbench(v, _)
--                 end
--             end,
--         },{
--             In = nil,
--             Out = ESX.UI.Menu.CloseAll
--         })
--     end
-- end)

RegisterNetEvent("core_crafting2:craftStart")
AddEventHandler(
    "core_crafting2:craftStart",
    function(item, count)
        local id = math.random(000, 999)
        local needstart = craftingQueue[1] == nil
        table.insert(craftingQueue, {time = Config.Recipes[item].Time, item = item, count = count, id = id})
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
                                ESX.TriggerServerEvent("core_crafting2:itemCrafted", craftingQueue[1].item, coordscraft, currentJob)
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

RegisterNetEvent("core_crafting2:sendMessage")
AddEventHandler(
    "core_crafting2:sendMessage",
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
        if Config.Recipes[item].animation then
            TriggerEvent('anim:play', Config.Recipes[item].animation)
        end
        ESX.TriggerServerEvent("core_crafting2:craft", item, currentJob)
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
