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

ESX = nil

local labels = {}
local craftingQueue = {}

local job = ""
local grade = 0
local gang = ""
local ggrade = 0

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
		while ESX.GetPlayerData().gang == nil do
            Citizen.Wait(10)
        end

        job = ESX.GetPlayerData().job.name
        grade = ESX.GetPlayerData().job.grade
		gang = ESX.GetPlayerData().gang.name
        ggrade = ESX.GetPlayerData().gang.grade

        ESX.TriggerServerCallback(
            "AH_uwucafejob:getItemNames",
            function(info)
                labels = info
            end
        )

        for _, v in ipairs(ConfigCrafting.Workbenches) do
            if v.blip then
                local blip = AddBlipForCoord(v.coords)

                SetBlipSprite(blip, ConfigCrafting.BlipSprite)
                SetBlipScale(blip, 0.8)
                SetBlipColour(blip, ConfigCrafting.BlipColor)
                SetBlipAsShortRange(blip, true)

                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(ConfigCrafting.BlipText)
                EndTextCommandSetBlipName(blip)
            end
        end
    end
)

RegisterNetEvent("esx:setJob")
AddEventHandler(
    "esx:setJob",
    function(j)
        job = j.name
        grade = j.grade
    end
)

RegisterNetEvent("esx:setGang")
AddEventHandler(
    "esx:setGang",
    function(j)
        gang = j.name
        ggrade = j.grade
      
    end
)

function isNearWorkbench()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local near = false
    local WaitForIt = false

    for _, v in ipairs(ConfigCrafting.Workbenches) do
        local dst = #(coords - v.coords)
        if dst < v.radius then
            near = true
        end
    end
	
	while WaitForIt do Wait(1) end
    if near then
        return true
    else
        return false
    end
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000)

            if craftingQueue[1] ~= nil then
                if not ConfigCrafting.CraftingStopWithDistance or (ConfigCrafting.CraftingStopWithDistance and isNearWorkbench()) then
                    craftingQueue[1].time = craftingQueue[1].time - 1

                    SendCafeNUI(
                        {
                            type = "addqueue",
                            item = craftingQueue[1].item,
                            time = craftingQueue[1].time,
                            id = craftingQueue[1].id
                        }
                    )

                    if craftingQueue[1].time == 0 then
                        TriggerServerEvent("AH_uwucafejob:itemCrafted", craftingQueue[1].item, craftingQueue[1].count)
                        table.remove(craftingQueue, 1)
                    end
                end
            end
        end
    end
)





function openWorkbench(category)
    ESX.TriggerServerCallback(
        "AH_uwucafejob:getXP",
        function(xp, ranks)
            SetNuiFocus(true, true)
            TriggerScreenblurFadeIn(1000)

            local inv = {}
            for _, v in ipairs(ESX.GetPlayerData().inventory) do
            
                
                if v.name then 
                    inv[v.name] = v.count
                end
                
            end

            local recipes = {}
			
			
           
			recipes = ConfigCrafting.Recipes
        
		
            SendCafeNUI(
                {
                    type = "open",
                    recipes = recipes,
                    names = labels,
                    Level = ranks,
                    level = xp,
                    inventory = inv,
                    job = gang,
                    grade = ggrade,
                    hidecraft = ConfigCrafting.HideWhenCantCraft,
                    categories = ConfigCrafting.Categories,
					opencategory = category
                }
            )
        end
    )
end



RegisterNetEvent('AH_uwucafejob:OpenCraftingHamzan')
AddEventHandler('AH_uwucafejob:OpenCraftingHamzan', function()
    local myCafe = GetCafeForJob(PlayerData.job.name)
    if myCafe then
        openWorkbench(myCafe.MenuGroup .. 'Hamzan')
    end
end)

RegisterNetEvent('AH_uwucafejob:OpenCraftingGhahvesaz')
AddEventHandler('AH_uwucafejob:OpenCraftingGhahvesaz', function()
    local Pcoords = GetEntityCoords(PlayerPedId())
    local isOpen = true 

    for k,v in pairs(Cafes) do 
        local distance = GetDistanceBetweenCoords(v.Crafting_Ghahvesaz.Pos.x, v.Crafting_Ghahvesaz.Pos.y, v.Crafting_Ghahvesaz.Pos.z, Pcoords, false)
 
        if distance <= 1.2 then 
            isOpen = true
        else
            isOpen = false
        end
    end
    
    local myCafe = GetCafeForJob(PlayerData.job.name)
    if isOpen and myCafe then 
        openWorkbench(myCafe.MenuGroup .. 'Ghahvesaz')
    end
    
end)

RegisterNetEvent('AH_uwucafejob:OpenCraftingZarfShoe')
AddEventHandler('AH_uwucafejob:OpenCraftingZarfShoe', function()
    local Pcoords2 = GetEntityCoords(PlayerPedId())
    local isOpen2 = true 

    for k,v in pairs(Cafes) do 
        local distance2 = GetDistanceBetweenCoords(v.Crafting_ZarfShoe.Pos.x, v.Crafting_ZarfShoe.Pos.y, v.Crafting_ZarfShoe.Pos.z, Pcoords2, false)
    
        if distance2 <= 1.2 then 
            isOpen2 = true
        else
            isOpen2 = false
        end
    end
    
    local myCafe2 = GetCafeForJob(PlayerData.job.name)
    if isOpen2 and myCafe2 then 
        openWorkbench(myCafe2.MenuGroup .. 'ZarfShoe')
    end
    
end)

RegisterNetEvent('AH_uwucafejob:OpenCraftingGaz')
AddEventHandler('AH_uwucafejob:OpenCraftingGaz', function()
    local myCafeGaz = GetCafeForJob(PlayerData.job.name)
    if myCafeGaz then
        openWorkbench(myCafeGaz.MenuGroup .. 'Gaz')
    end
end)




RegisterNetEvent("AH_uwucafejob:craftStart")
AddEventHandler(
    "AH_uwucafejob:craftStart",
    function(item, count)
        local id = math.random(000, 999)
		local playerPed = PlayerPedId()
        table.insert(craftingQueue, {time = ConfigCrafting.Recipes[item].Time, item = item, count = 1, id = id})

        SendCafeNUI(
            {
                type = "crafting",
                item = item
            }
        )

        SendCafeNUI(
            {
                type = "addqueue",
                item = item,
                time = ConfigCrafting.Recipes[item].Time,
                id = id
            }
        )
		-- TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
		-- Wait((ConfigCrafting.Recipes[item].Time/4) *1000)
		-- ClearPedTasksImmediately(playerPed)
		-- TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_HAMMERING', 0, true)
		-- Wait((ConfigCrafting.Recipes[item].Time/4) *1000)
		-- ClearPedTasksImmediately(playerPed)
		-- TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
		-- Wait((ConfigCrafting.Recipes[item].Time/4) *1000)
		-- ClearPedTasksImmediately(playerPed)
		-- TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
		-- Wait((ConfigCrafting.Recipes[item].Time/4) *1000)
		-- ClearPedTasksImmediately(playerPed)
    end
)

RegisterNetEvent("AH_uwucafejob:sendMessage")
AddEventHandler(
    "AH_uwucafejob:sendMessage",
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
        local item = data["item"]
        TriggerServerEvent("AH_uwucafejob:craft", item, false)
    end
	
)

function DrawTexet3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = ((1 / dist) * 2) * (1 / GetGameplayCamFov()) * 100

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





