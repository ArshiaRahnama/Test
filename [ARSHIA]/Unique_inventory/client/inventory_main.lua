
_SendNUIMessage = SendNUIMessage
SendNUIMessage = function(data)
    if data.action == "openInventory" or data.action == "updateInventory" then
        TriggerEvent("handappstate", false)
        Citizen.SetTimeout(2000, function()
            TriggerEvent("handappstate", true)
        end)
    end
    _SendNUIMessage(data)
end

dPN = {}
PlayerData = nil
ESX = nil
AlreadyDroped = 0
event = nil
secondInventory = nil
AS = { count = 0, timer = GetGameTimer() }

NoTrunkClass = {
    [13] = true,
}

local MyData = {}

local trunkData = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    while ESX.GetPlayerData().gang == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
    
    
    ESX.TriggerServerCallback("esx_inventoryhud:GetData", function(data)
       
        MyData = data 
        print(json.encode(MyData))
    end)
end)



RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('esx:setGang')
AddEventHandler('esx:setGang', function(gang)
    PlayerData.gang = gang
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('HR_Coin:UpdateThatFuckinShit')
AddEventHandler('HR_Coin:UpdateThatFuckinShit', function(dCoin)
    ESX.PlayerData.Coin = dCoin
    PlayerData.Coin = dCoin
end)

RegisterNetEvent("nameUpdate")
AddEventHandler("nameUpdate", function(name)
    ESX.SetPlayerData("name", name)
    PlayerData.name = name
end)

RegisterNetEvent('bankUpdate')
AddEventHandler('bankUpdate', function(money)
    MyData.bank = money
end)

RegisterNetEvent('moneyUpdate')
AddEventHandler('moneyUpdate', function(money)
    MyData.money = money
end)

RegisterNetEvent('gcphone:setUiPhone')
AddEventHandler('gcphone:setUiPhone', function(money)
    PlayerData.bank = money
end)


RegisterNetEvent('esx_inventoryhud:OpenHouseInventory')
AddEventHandler('esx_inventoryhud:OpenHouseInventory', function(ID)
    houseID = ID or nil
    secondInventory = "house"
    event = "esx_inventoryhud:GetHouseItems"
    getEvent = "esx_inventoryhud:removeFromHouse"
    putEvent = "esx_property:putItem"
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    SetCursorLocation(0.5, 0.5)
    SendNUIMessage({
        action = "openInventory",
        secondAction = secondInventory,
        url = 'nui://Unique_inventory/html/img/items/'
    })
end)




RegisterNetEvent('esx_inventoryhud:OpenJobInventory1')
AddEventHandler('esx_inventoryhud:OpenJobInventory1', function(ID)
    houseID = ID or nil
    secondInventory = "house"
    event = "job1"
    getEvent = "esx_inventoryhud:removeFromHouse"
    putEvent = "esx_property:putItem"
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    SetCursorLocation(0.5, 0.5)
    SendNUIMessage({
        action = "openInventory",
        secondAction = secondInventory,
        url = 'nui://Unique_inventory/html/img/items/'
    })
end)

RegisterNetEvent('esx_inventoryhud:OpenJobInventory2')
AddEventHandler('esx_inventoryhud:OpenJobInventory2', function(ID)
    houseID = ID or nil
    secondInventory = "house"
    event = "job2"
    getEvent = "esx_inventoryhud:removeFromHouse"
    putEvent = "esx_property:putItem"
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    SetCursorLocation(0.5, 0.5)
    SendNUIMessage({
        action = "openInventory",
        secondAction = secondInventory,
        url = 'nui://Unique_inventory/html/img/items/'
    })
end)


RegisterNetEvent('esx_inventoryhud:OpenGangInventory')
AddEventHandler('esx_inventoryhud:OpenGangInventory', function(sec)
    second = sec
    secondInventory = "house"
    event = "esx_inventoryhud:getGangStorage"
    getEvent = "esx_inventoryhud:removeFromGang"
    putEvent = "gangs:addToInventory"
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    SetCursorLocation(0.5, 0.5)
    SendNUIMessage({
        action = "openInventory",
        secondAction = secondInventory,
        url = 'nui://Unique_inventory/html/img/items/'
    })
end)

RegisterNetEvent('esx_inventoryhud:AdminOpenPropertyInventory')
AddEventHandler('esx_inventoryhud:AdminOpenPropertyInventory', function(items, max, current, hex)
    tableItem = items
    maxWeight = max
    weight = current
    currentUser = hex
    AdminOpenning = true
    secondInventory = "house"
    event = "esx_inventoryhud:getHouseStorage"
    getEvent = "esx_inventoryhud:removeFromHouse"
    putEvent = "esx_property:putItem"
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    SetCursorLocation(0.5, 0.5)
    SendNUIMessage({
        action = "openInventory",
        secondAction = secondInventory,
        url = 'nui://Unique_inventory/html/img/items/'
    })
end)

RegisterNetEvent("esx:ItemGivedToPlayer")
AddEventHandler("esx:ItemGivedToPlayer", function(Target, Item, extraInfo)
    ExecuteCommand("me Be ("..Target..") "..Item.." Dad")
    local player = PlayerPedId()
    local dict = "mp_common"
    RequestAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do Citizen.Wait(0) end
    TaskPlayAnim(player, dict, "givetake1_a", 8.0, 2.0, -1, 48, 2, 0, 0, 0)
end)

AddEventHandler("openInventoryHud", function()
    if ESX.GetPlayerData().isSentenced then return SetNuiFocus(false, false) end
    --if ESX.isDead() then return end
    --if ESX.GetPlayerData().IsDead or ESX.GetPlayerData().IsDead == -1 then return end
    if IsPedFalling(PlayerPedId()) then return SetNuiFocus(false, false) end
    secondInventory = nil
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    SetCursorLocation(0.5, 0.5)
    SendNUIMessage({
        action = "openInventory",
        secondAction = secondInventory,
        url = 'nui://Unique_inventory/html/img/items/'
    })
end)
local inPaintBall = false

AddEventHandler('esx_paintball:inPaintBall', function(state)
    inPaintBall = state
end)

local NewLife = false

AddEventHandler('NewLife:NewLife', function(state)
    NewLife = state
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsControlPressed(0, 289) then
         
            if not inPaintBall then
                if not NewLife then
                    TriggerEvent('openInventoryHud')
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    SetNuiFocus(false, false)
    SetFrontendActive(false)
end)

local supportedKeys = {
    ["1"] = true,
    ["2"] = true,
    ["3"] = true,
    ["4"] = true,
    ["5"] = true
}

AddEventHandler("onKeyDown", function(key)
    local keyPressed = key
    if supportedKeys[keyPressed] then
        if SpamCheck() then return end
        AS.count = AS.count + 1
        TriggerEvent("handappstate", false)
        Citizen.SetTimeout(2000, function()
            TriggerEvent("handappstate", true)
        end)
        Citizen.Wait(500)
        TriggerServerEvent("esx_invenotryhud:KeyBindPressed", keyPressed)
    end
end)

RegisterNetEvent("esx_inventoryhud:KeyPressed")
AddEventHandler("esx_inventoryhud:KeyPressed", function(item)
    if item:find("WEAPON") then
        SetCurrentPedWeapon(PlayerPedId(), GetHashKey(item), true)
    else
        TriggerServerEvent("esx:useItem", item)
    end
end)

AddEventHandler("esx_inventoryhud:closeInventory", function()
    dPN.closeInventoryPlayer()
end)

AddEventHandler("onKeyUP",function(key)

	if key == "lmenu" then

		openmenuvehicle()

	end

end)

local function VehicleInFront()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 4.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, result = GetRaycastResult(rayHandle)
    return result
end

local VehicleLimit = {
    [0] = 30000, --Compact
    [1] = 40000, --Sedan
    [2] = 70000, --SUV
    [3] = 25000, --Coupes
    [4] = 30000, --Muscle
    [5] = 10000, --Sports Classics
    [6] = 5000, --Sports
    [7] = 5000, --Super
    [8] = 5000, --Motorcycles
    [9] = 180000, --Off-road
    [10] = 300000, --Industrial
    [11] = 70000, --Utility
    [12] = 100000, --Vans
    [13] = 0, --Cycles
    [14] = 5000, --Boats
    [15] = 20000, --Helicopters
    [16] = 0, --Planes
    [17] = 40000, --Service
    [18] = 40000, --Emergency
    [19] = 0, --Military
    [20] = 300000, --Commercial
    [21] = 0 --Trains
}

local CustomLimit = {
    {model = GetHashKey('lex570'), limit = 500000},
}

function openmenuvehicle(_)
    local playerPed = PlayerPedId()
    local vehicle   = VehicleInFront()
    -- vehicle = _
    print(vehicle)
    if vehicle == 0 then return end

    local locked    = GetVehicleDoorsLockedForPlayer(vehicle)
    local locked2 = GetVehicleDoorLockStatus(vehicle)
    local class     = GetVehicleClass(vehicle)
    local plate     = GetVehicleNumberPlateText(vehicle)
    if plate == nil then return end
    if NoTrunkClass[class] then return end
    if IsPedInAnyVehicle(playerPed) then return end
    --if Config.NoTrunkClass[class] then return end
  
    ESX.UI.Menu.CloseAll()
    if locked2 == 1 or locked2 == 0 then
        if not locked then
        if plate ~= nil or plate ~= "" or plate ~= " " or not ESX.GetPlayerData().isSentenced then

            
            CloseToVehicle = vehicle
            SetEntityDrawOutlineColor(255, 0, 66, 150)
            SetEntityDrawOutline(CloseToVehicle, true)
            ActiveVehicleDistanceChecker()
            -- if bone > 0 then
            --   PlayOpenTrunkSenario(vehicle, function()
            --     OpenCoffreInventoryMenu(plate, Limit)
            --   end)
            -- else
            local Limit = VehicleLimit[class]
            for k,v in pairs(CustomLimit) do
            if v.model == GetEntityModel(vehicle) then
                Limit = v.limit
            end
            end
            trunkData = {plate = plate, max = Limit, myVeh = vehicle}
            SetVehicleDoorOpen(vehicle, 5, false, false)
            secondInventory = "trunckChest"
            tableCar = {
                vehicle = vehicle,
                vnetid = vnetid,
                placa = plate,
                vname = vname,
                lock = lock,
                banned = banned,
                trunk = trunk
            }
            SetNuiFocus(true, true)
            TriggerScreenblurFadeIn(1000)
            SetCursorLocation(0.5, 0.5)
            SendNUIMessage({
                action = "openInventory",
                secondAction = "trunckChest",
                url = 'nui://Unique_inventory/html/img/items/'
            })
            -- end
        end
        else
        -- FIX: pNotify isn't installed on this server - would hard-error.
        ESX.ShowNotification('The car is locked')
        end
    else
        -- FIX: okokNotify isn't installed on this server either - this
        -- TriggerEvent was a silent no-op (nothing ever caught it, so
        -- nothing showed, but it didn't error since TriggerEvent on a
        -- name nothing listens for just does nothing).
        ESX.ShowNotification('The vehicle doors are locked')
    end
  end
  
function openTrunk(_)
    if ESX and not CloseToVehicle then
        openmenuvehicle(_)
    end
end

exports("openTrunk", openTrunk)
  
function ActiveVehicleDistanceChecker()
    Citizen.CreateThread(function()
        -- local bone = GetEntityBoneIndexByName(CloseToVehicle, 'boot')
        while CloseToVehicle do
            Citizen.Wait(500)
            local pos = GetEntityCoords(PlayerPedId())
            -- bone > 0 and GetWorldPositionOfEntityBone(CloseToVehicle, bone) or 
            local vehcoord = GetEntityCoords(CloseToVehicle)
          
            if GetDistanceBetweenCoords(pos, vehcoord, true) >= 5.0 then
                TriggerEvent("esx_inventoryhud:MenuClosed")
                SetNuiFocus(false, false)
                SendNUIMessage({
                    action = "closeInventory"
                })
                TransitionFromBlurred(1000)
                SetVehicleDoorShut(CloseToVehicle, 5, false)
                CloseToVehicle = false
                ESX.UI.Menu.CloseAll()
            end
        end
    end)
end
  
AddEventHandler('esx_inventoryhud:MenuClosed', function()
    if CloseToVehicle then
        ClearPedTasks(PlayerPedId())
        SetVehicleDoorShut(CloseToVehicle, 5, false)
        SetEntityDrawOutline(CloseToVehicle, false)
        CloseToVehicle = false
    end
end)

function dPN.updateInventory(s)
    SendNUIMessage({
        action = "updateInventory",
        secondAction = s or secondInventory
    })
end

RegisterNetEvent("esx_inventoryhud:RefreshCurrentInventory")
AddEventHandler("esx_inventoryhud:RefreshCurrentInventory", dPN.updateInventory)

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

local VIP = {
    bronze = true,
    silver = true,
    gold = true,
    premium = true
}



RegisterNUICallback("requsetIdentity", function(data, cb)
    -- FIX: MyData is only filled once the async "esx_inventoryhud:GetData"
    -- server callback returns (see the CreateThread above). If the player
    -- opens the inventory before that finishes, MyData.name is still nil
    -- and MyData.name:match(...) throws "attempt to index a nil value
    -- (field 'name')" on every open, so the identity card never receives
    -- real data. Fall back to safe defaults instead of erroring.
    local rawName = MyData.name or (PlayerData and PlayerData.name) or "Unknown_Citizen"

    local identityData = {
        nome = (rawName:match("([^/]+)_")) or rawName,
        sobrenome = (rawName:match("_([^/]+)")) or "",
        idade = MyData.steam or "N/A",
        id = GetPlayerServerId(PlayerId()),
        registro =  ESX.Math.GroupDigits(MyData.coin or 0),
        telefone = MyData.phone or "N/A",
        emprego = (PlayerData and PlayerData.job and (PlayerData.job.label..' - '..PlayerData.job.grade_label)) or "Unemployed",

        carteira = MyData.money or 0,
        banco = MyData.bank or 0,

        admin = false,
    }

    -- FIX: this field used to never be sent, so the front-end's
    -- (admin === true / === false) check never matched and the admin
    -- row stayed visible for every player. Uses the exact same
    -- permission check Unique_AdminPanel's own admin panel does
    -- (esx_aduty:checkAdmin -> xPlayer.permission_level > 1), so this
    -- card agrees with the real admin system instead of inventing its
    -- own threshold. A short timeout guards against esx_aduty not being
    -- started, so the identity card never hangs waiting on it.
    local replied = false
    local function finish()
        if replied then return end
        replied = true
        cb(identityData)
    end

    ESX.TriggerServerCallback("esx_aduty:checkAdmin", function(isAdmin)
        identityData.admin = isAdmin == true
        finish()
    end)

    SetTimeout(2000, finish)
end)

RegisterNUICallback("requestItens", function(data, cb)
    ESX.TriggerServerCallback("esx_inventoryhud:getPlayerInventory2323", function(data)
       
        cb({
            inventario = data.inventory,
            atualPeso = data.atualPeso or 0,
            maximoPeso = data.maximoPeso or 90,
            slot = 30,
            un = 30,
            slot2 = 30,
            slotsComrpavel = true,
            slotPrice = "500,000"
        })
    end)
end)

RegisterNetEvent("esx_inventoryhud:CargoInventory")
AddEventHandler("esx_inventoryhud:CargoInventory", function()
    secondInventory = "house"
    event = "esx_inventoryhud:getCargoStorage"
    getEvent = "esx_inventoryhud:removeFromCargo"
    putEvent = "esx_inventoryhud:PutInCargo"
    SetNuiFocus(true, true)
    TriggerScreenblurFadeIn(1000)
    SetCursorLocation(0.5, 0.5)
    SendNUIMessage({
        action = "openInventory",
        secondAction = secondInventory,
        url = 'nui://Unique_inventory/html/img/items/'
    })
end)



RegisterNUICallback("requestItemSecondInventory", function(data, cb)
    -- print(getTotalInventoryWeight(GetVehicleNumberPlateText(CloseToVehicle)), trunkData.max)
    local tipo = data.tipo
    if tipo then
        if tipo == "trunckChest" then 
            ESX.TriggerServerCallback('esx_trunk:getInventoryV', function(tableItem, maxWeight, weight)
                cb({
                    chest = "TrunckChest",
                    tableChest = tableItem.items,
                    slots = 120,
                    tamanhoChest = trunkData.max,
                    tamanhoMyInv = tableItem.weight,
                    nameCar = ESX.Math.Trim(GetVehicleNumberPlateText(CloseToVehicle))
                })
            end, GetVehicleNumberPlateText(CloseToVehicle))
        elseif tipo == "house" then
            -- if not AdminOpenning then
            if event == 'esx_inventoryhud:GetHouseItems' then
                ESX.TriggerServerCallback('Parzival:getHouseINV', function(tableItem)
                --         cb({
                --             chest = "house",
                --             tableChest = tableItem,
                --             slots = 120,
                --             tamanhoChest = tonumber(maxWeight),
                --             tamanhoMyInv = tonumber(weight),
                --             nameHouse = event == "esx_inventoryhud:getHouseStorage" and "House Inventory" or event == "esx_inventoryhud:getCargoStorage" and "Cargo Inventory" or "Gang Inventory"
                --         })
                --     end, second, houseID)
                -- else
                    cb({
                        chest = "house",
                        tableChest = tableItem,
                        slots = 600,
                        tamanhoChest = tonumber(20000),
                        tamanhoMyInv = tonumber(2000),
                        nameHouse = event == "esx_inventoryhud:GetHouseItems" and "کمد خانه" or event == "esx_inventoryhud:getCargoStorage" and "Cargo Inventory" or "کمد وسایل"
                    })
                -- end
                end)
            elseif event == 'job1' then
                ESX.TriggerServerCallback('Parzival:getJobINV1', function(tableItem)
                    --         cb({
                    --             chest = "house",
                    --             tableChest = tableItem,
                    --             slots = 120,
                    --             tamanhoChest = tonumber(maxWeight),
                    --             tamanhoMyInv = tonumber(weight),
                    --             nameHouse = event == "esx_inventoryhud:getHouseStorage" and "House Inventory" or event == "esx_inventoryhud:getCargoStorage" and "Cargo Inventory" or "Gang Inventory"
                    --         })
                    --     end, second, houseID)
                    -- else
                        cb({
                            chest = "house",
                            tableChest = tableItem,
                            slots = 600,
                            tamanhoChest = tonumber(20000),
                            tamanhoMyInv = tonumber(2000),
                            nameHouse = 'اسلحه خانه'
                        })
                    -- end
                    end)

                elseif event == 'job2' then
                    ESX.TriggerServerCallback('Parzival:getJobINV2', function(tableItem)
                        --         cb({
                        --             chest = "house",
                        --             tableChest = tableItem,
                        --             slots = 120,
                        --             tamanhoChest = tonumber(maxWeight),
                        --             tamanhoMyInv = tonumber(weight),
                        --             nameHouse = event == "esx_inventoryhud:getHouseStorage" and "House Inventory" or event == "esx_inventoryhud:getCargoStorage" and "Cargo Inventory" or "Gang Inventory"
                        --         })
                        --     end, second, houseID)
                        -- else
                            cb({
                                chest = "house",
                                tableChest = tableItem,
                                slots = 600,
                                tamanhoChest = tonumber(20000),
                                tamanhoMyInv = tonumber(2000),
                                nameHouse = 'کمد وسایل'
                            })
                        -- end
                        end)
            else
                ESX.TriggerServerCallback('Parzival:getGangINV', function(tableItem)
                    --         cb({
                    --             chest = "house",
                    --             tableChest = tableItem,
                    --             slots = 120,
                    --             tamanhoChest = tonumber(maxWeight),
                    --             tamanhoMyInv = tonumber(weight),
                    --             nameHouse = event == "esx_inventoryhud:getHouseStorage" and "House Inventory" or event == "esx_inventoryhud:getCargoStorage" and "Cargo Inventory" or "Gang Inventory"
                    --         })
                    --     end, second, houseID)
                    -- else
                        cb({
                            chest = "house",
                            tableChest = tableItem,
                            slots = 600,
                            tamanhoChest = tonumber(20000),
                            tamanhoMyInv = tonumber(2000),
                            nameHouse = event == "esx_inventoryhud:GetHouseItems" and "کمد خانه" or event == "esx_inventoryhud:getCargoStorage" and "Cargo Inventory" or "کمد وسایل"
                        })
                    -- end
                    end)
            end
        end
    end
end)

RegisterNUICallback("colocarItemTrunkInventory", function(data)
    local item = data.item
    if data.item then
        -- if (PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "forces" or PlayerData.job.name == "fbi") and data.item:find("gangcoin") then return end
        if data.item:find("money") then return end
        local type = item:find("WEAPON_") and "item_weapon" or item:find("cash") and "item_money" or "item_standard"
        -- TriggerServerEvent("esx_inventoryhud:AddItemToTrunk", item, data.oldSlot, data.newSlot, data.amount, data.chest)
        TriggerServerEvent("esx_trunk:putItem", trunkData.plate, type, item, data.amount, trunkData.max, trunkData.myVeh, item)
        dPN.closeInventoryPlayer()
                Wait(100)
                openmenuvehicle()
    end
end)

RegisterNUICallback("colocarItemHouse", function(data)
    local data = data
    local item = data.item

    if item:find("money") then return end
    -- if (PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "forces" or PlayerData.job.name == "fbi") and data.item:find("gangcoin") then return end
    -- if SpamCheck() then return end
    local type = item:find("WEAPON_") and "item_weapon" or "item_standard"
    name = item
    count = tonumber(data.amount)
    AS.count = AS.count + 1
    print(event)
    if event == 'esx_inventoryhud:GetHouseItems' then
        TriggerServerEvent("esx_property:putItem", PlayerData.identifier, type, name, count)
        dPN.closeInventoryPlayer()
        Wait(100)
        TriggerEvent('esx_inventoryhud:OpenHouseInventory')
    elseif event == 'job1' then
     
    

        if type == 'item_weapon' then
            TriggerServerEvent('Parzival:PutJobWeapon', name)
            dPN.closeInventoryPlayer()
            Wait(100)
            TriggerEvent('esx_inventoryhud:OpenJobInventory1')
        elseif type == 'item_standard' then
           

        end
        
    elseif event == 'job2' then
     
    

        if type == 'item_weapon' then
        
        elseif type == 'item_standard' then
            TriggerServerEvent('Parzival:PutJobItem', name, count)
            dPN.closeInventoryPlayer()
            Wait(100)
            TriggerEvent('esx_inventoryhud:OpenJobInventory2')
        end
        



    else
        TriggerServerEvent("gangs:addToInventory", type, name, count)
        dPN.closeInventoryPlayer()
        Wait(100)
        TriggerEvent('esx_inventoryhud:OpenGangInventory')
    end
    -- TriggerServerEvent(putEvent, currentUser or houseID or PlayerData.identifier, type, name, count, data.oldSlot, second)
    -- if AdminOpenning then
    --     Citizen.Wait(2000)
    --     ExecuteCommand("openproperty "..currentUser)
    -- end
end)

RegisterNUICallback("retirarItemTrunk", function(data)
    if data.item then
        local item = data.item
        --if (PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "forces" or PlayerData.job.name == "fbi") and data.item:find("gangcoin") then return end
        -- TriggerServerEvent("esx_inventoryhud:removeFromTrunk", data.item, data.oldSlot, data.newSlot, data.amount, data.chest)
        local type = item:find("WEAPON_") and "item_weapon" or "item_standard"
        TriggerServerEvent("esx_trunk:getItem", trunkData.plate, type, item, tonumber(data.amount), trunkData.max, trunkData.myVeh)
        dPN.closeInventoryPlayer()
                Wait(100)
                openmenuvehicle()
    end
end)

RegisterNUICallback("retirarItemHouse", function(data)
    if data.item then
        -- if (PlayerData.job.name == "police" or PlayerData.job.name == "sheriff" or PlayerData.job.name == "forces" or PlayerData.job.name == "fbi") and data.item:find("gangcoin") then return end
        -- if SpamCheck() then return end
        AS.count = AS.count + 1
        local item = string.upper(data.item)
        print(event)
        -- TriggerServerEvent(getEvent, currentUser or houseID or PlayerData.identifier, data.item, data.oldSlot, data.newSlot, data.amount, data.chest, second)
        local type = item:find("WEAPON_") and "item_weapon" or "item_standard"
        if event == 'esx_inventoryhud:GetHouseItems' then
            TriggerServerEvent("esx_property:getItem", PlayerData.identifier, type, item, tonumber(data.amount))
            dPN.closeInventoryPlayer()
            Wait(100)
            TriggerEvent('esx_inventoryhud:OpenHouseInventory')
        elseif event == 'job1' then
     
    

            if type == 'item_weapon' then
                TriggerServerEvent('Parzival:GetJobWeapon', item)
                dPN.closeInventoryPlayer()
                Wait(100)
                TriggerEvent('esx_inventoryhud:OpenJobInventory1')
            elseif type == 'item_standard' then
               
    
            end
        elseif event == 'job2' then
     
    

            if type == 'item_weapon' then
    
            elseif type == 'item_standard' then
                TriggerServerEvent('Parzival:GetJobItem', item, tonumber(data.amount))
                dPN.closeInventoryPlayer()
                Wait(100)
                TriggerEvent('esx_inventoryhud:OpenJobInventory2')
            end
        else
            TriggerServerEvent("gangs:getFromInventory", type, item, tonumber(data.amount))
            dPN.closeInventoryPlayer()
            Wait(100)
            TriggerEvent('esx_inventoryhud:OpenGangInventory')
        end
        -- if AdminOpenning then
        --     Citizen.Wait(2000)
        --     ExecuteCommand("openproperty "..currentUser)
        -- end
    end
end)

RegisterNUICallback("buySlot", function(cb)
    TriggerServerEvent('esx_inventoryhud:BuySlot')
end)

RegisterNUICallback("closeInventory", function(cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "closeInventory"
    })
    TransitionFromBlurred(1000)
    AdminOpenning = nil
    currentUser = nil
    cantOpen = true
    Wait(1000)
    cantOpen = false
    chestOpenReturn = nil
    TriggerEvent("esx_inventoryhud:MenuClosed")
    TriggerEvent('nation_hud:updateHud', true)
    secondInventory = nil
    SetEntityDrawOutline(CloseToVehicle, false)
    CloseToVehicle = nil
end)

function dPN.closeInventoryPlayer()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "closeInventory"
    })
    TransitionFromBlurred(1000)
    TriggerEvent("esx_inventoryhud:MenuClosed")
    AdminOpenning = nil
    currentUser = nil
    secondInventory = nil
    houseID = nil
    SetEntityDrawOutline(CloseToVehicle, false)
    CloseToVehicle = nil
    -- dPNserver.closeInventory(tableCar.vnetid, chestOpenReturn)
end

function SpamCheck()
    if GetGameTimer() - AS.timer < 6000 then
        if AS.count >= 3 then
            ESX.ShowNotification("Please do not spam")
            return true
        end
    else
        AS = { count = 0, timer = GetGameTimer() }
    end
    return false
end

RegisterNUICallback("usarItem", function(data)
    if data.item then
        if data.item:find("money") then return end
        if SpamCheck() then return end
        if ESX.GetPlayerData().isSentenced then return end
     
        TriggerServerEvent("esx:useItem", data.item)
        AS.count = AS.count + 1
    end
end)

RegisterNUICallback("enviarItem", function(data)
    if data.item then
        if SpamCheck() then return end
        if ESX.GetPlayerData().isSentenced then return end
      
        local type = nil
      
        if data.item:find("black_money") then 

            if PlayerData.black_money >= data.amount then
                type = "black_money"
            end
        elseif data.item:find("cash") then
            if MyData.money >= data.amount then 
                type = "item_money"
            end
        elseif data.item:find("WEAPON") then
            type = "item_weapon"
        else
            type = "item_standard"
        end
        if type == nil then return end
        dPN.closeInventoryPlayer()
        local aPlayers = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
        SelectPlayer(function(cP)
            print(GetPlayerServerId(cP))
            -- TriggerServerEvent("esx_inventoryhud:GiveItem", GetPlayerServerId(cP), data.item, data.amount, data.slot)
            TriggerServerEvent("esx:giveInventoryItem", GetPlayerServerId(cP), type, data.item, data.amount)
            AS.count = AS.count + 1
        end, aPlayers, data)
    end
end)

RegisterNUICallback("droparItem", function(data)
    if data.item and data.amount > 0 then
        local type = nil
      
        if data.item:find("black_money") then 

            if PlayerData.black_money >= data.amount then
                type = "black_money"
            end
        elseif data.item:find("cash") then
            if MyData.money >= data.amount then 
                type = "item_money"
            end
        elseif data.item:find("WEAPON") then
            type = "item_weapon"
        else
            type = "item_standard"
        end
        if type == nil then return end
        
        if AlreadyDroped >= 3 then
        -- FIX: pNotify isn't installed anywhere on this server - exports.pNotify:...
        -- would hard-error. Using the real ESX.ShowNotification instead.
        ESX.ShowNotification('You can drop a maximum of 3 items per 2 minutes, please wait')
            return
        end
        -- -- if SpamCheck() then return end
     
                TriggerServerEvent("esx:removeInventoryItem", type, data.item, data.amount)
                dPN.closeInventoryPlayer()
                Wait(100)
                TriggerEvent('openInventoryHud')
                AlreadyDroped = AlreadyDroped + 1
                SetTimeout(120000, function()
                    AlreadyDroped = AlreadyDroped - 1
                end)
         
    end
end)

RegisterNUICallback("moverItem", function(data)
    if data.item then
        if data.item:find("money") then return end
        if data.newSlot == 5 or data.newSlot == 6 or data.oldSlot == 5 or data.oldSlot== 6 then return end
        --if data.item:find("weapon") then return end
        if SpamCheck() then return end
        TriggerServerEvent("esx_inventoryhud:moveItem", data.item, data.oldSlot, data.newSlot, data.amount)
        AS.count = AS.count + 1
    end
end)

RegisterNetEvent("dope:inventory:close")
AddEventHandler("dope:inventory:close", function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "closeInventory"
    })
    secondInventory = nil
    SetEntityDrawOutline(CloseToVehicle, false)
    CloseToVehicle = nil
    TransitionFromBlurred(1000)
    dPNserver.closeInventory(tableCar.vnetid, chestOpenReturn)
end)

function GhadreMotlaq(number)
    if number < 0 then
        return number * -1
    else
        return number
    end
end

function SortPlayers(ply)
    local temp = {}
    for k, v in pairs(ply) do
        if PlayerId() ~= v then
            table.insert(temp, {dis = GhadreMotlaq(#(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(v)))), id = v})
        end
    end
    -- if #temp == 1 then return {[1] = temp[1].id} end
    table.sort(temp, function(a, b)
        return a.dis < b.dis
    end)
    return temp
end

function SelectPlayer(cb, Players, data)
    ESX.UI.Menu.CloseAll()
    Condition = false
    Current = nil
    Citizen.Wait(5)
    local Players = SortPlayers(Players)
    -- if #Players == 1 then
    --     if cb then
    --         cb(Players[1])
    --     end
      
    if #Players > 0 then
        local element = {}
        for k, v in pairs(Players) do
         
            if not Current then
                Current = v.id
                
            end
            table.insert(element, {label = ""..GetPlayerName(v.id), value = v.id})
        end
   
        Condition = true
        RunLoop(Players, data)
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'choose_person', {
            title    = 'Be Ki Mikhay Bedi?',
            align    = 'top-left',
            elements = element,
        }, function(data, menu)
            if GhadreMotlaq(#(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(data.current.value)))) < 1.5 then
                -- if cb then
                    cb(data.current.value)
                -- else
                --     closestPlayer = data.current.value
                --     TriggerServerEvent("esx_inventoryhud:GiveItem", GetPlayerServerId(closestPlayer), data.item, data.amount, data.slot)
                -- end
                menu.close()
                Condition = false
            else
                ESX.ShowNotification("You must be closer to give items", "error")
            end
        end, function(data, menu)
            Condition = false
            menu.close()
        end, function(data, menu)
            Current = data.current.value
        end, function()
            Condition = false
        end)
    else
        ESX.ShowNotification("No one is near you", "error")
    end
end

function RunLoop(players, data)
    Citizen.CreateThread(function()
        while Condition do
            Citizen.Wait(3)
            local Break = false
            if #players + 1 ~= #ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0) then Break = true end
            for k, v in pairs(players) do
                local diss = ESX.Math.Round(GhadreMotlaq(#(GetEntityCoords(PlayerPedId()) - GetEntityCoords(GetPlayerPed(v.id)))), 1)
                if diss <= 3.0 then
                    if Current and Current == v.id then
                        -- ESX.Game.Utils.DrawText3D(GetEntityCoords(GetPlayerPed(v.id)) - vector3(0.0, 0.0, 0.95), "~g~("..diss.." Meters)", 0.6)
                        DrawMarker(27, GetEntityCoords(GetPlayerPed(v.id)) - vector3(0.0, 0.0, 0.95), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 66, 150, false, true, 2, false, false, false, false)
                    else
                        -- ESX.Game.Utils.DrawText3D(GetEntityCoords(GetPlayerPed(v.id)) - vector3(0.0, 0.0, 0.95), "("..diss.." Meters)", 0.6)
                        DrawMarker(27, GetEntityCoords(GetPlayerPed(v.id)) - vector3(0.0, 0.0, 0.95), 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 150, false, true, 2, false, false, false, false)
                    end
                else
                    Break = true
                    break
                end
            end
            if Break then 
                local aPlayers = ESX.Game.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 3.0)
                ESX.UI.Menu.CloseAll()
                if #aPlayers > 1 then
                    SelectPlayer(nil, aPlayers, data)
                end
                break 
            end
        end
    end)
end

RegisterNUICallback("craftItemRemove", function(data)
    if PlayerData.gang.name == "nogang" or PlayerData.gang.name == "Military" then return end
    if #(GetGangCoords() - GetEntityCoords(PlayerPedId())) >= 50.0 then return ESX.ShowNotification("You must be near your gang") end
    TriggerServerEvent("esx_inventoryhud:removeItemForCraft", data)
end)

RegisterNUICallback("craftItemDbClick", function(data)
    if PlayerData.gang.name == "nogang" or PlayerData.gang.name == "Military" then return end
    if #(GetGangCoords() - GetEntityCoords(PlayerPedId())) >= 50.0 then return ESX.ShowNotification("You must be near your gang") end
    TriggerServerEvent("esx_inventoryhud:cancelCraft", data)
end)

RegisterNUICallback("updateCraft", function(data)
    if PlayerData.gang.name == "nogang" or PlayerData.gang.name == "Military" then return end
    if #(GetGangCoords() - GetEntityCoords(PlayerPedId())) >= 50.0 then return ESX.ShowNotification("You must be near your gang") end
    craftResult = nil 
    ESX.TriggerServerCallback('esx_inventoryhud:updateCraft', function(k)
        craftResult = k
    end, data)
end)

RegisterNUICallback("getResultCraft", function(data, cb)
    if PlayerData.gang.name == "nogang" or PlayerData.gang.name == "Military" then return end
    if #(GetGangCoords() - GetEntityCoords(PlayerPedId())) >= 50.0 then return ESX.ShowNotification("You must be near your gang") end
    while craftResult == nil do Citizen.Wait(100) end 
    cb({
        resultado = craftResult,
        quantidade = craftResult ~= "nada" and 1 or 0,
        index = craftResult
    })
end)

RegisterNUICallback("resgatarItem", function(data)
    if PlayerData.gang.name == "nogang" or PlayerData.gang.name == "Military" then return end
    if #(GetGangCoords() - GetEntityCoords(PlayerPedId())) >= 50.0 then return ESX.ShowNotification("You must be near your gang") end
    ESX.TriggerServerCallback("esx_inventoryhud:calculateCraft", function() 
        
    end, data)
end)

function GetGangCoords()
	local coord
	TriggerEvent("gangProp:GetInfo", "armory", function(crd)
		coord = crd
	end)
	while coord == nil do 
		Wait(100)
	end
	return vector3(coord.x, coord.y, coord.z)
end