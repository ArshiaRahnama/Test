local ESX = nil
local PlayerData , MyGangData  = {} , {} 
local isDead = false
local IsHandcuffed = false
local DragStatus = {}
DragStatus.IsDragged = false
local fol = false
local Draging = false
local KeyPressedCD = false 
CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.ESX, function(obj) ESX = obj end)
		Wait(500)
	end
	PlayerData = ESX.GetPlayerData()

end)
-----------------------------
--- ESX
-----------------------------
RegisterNetEvent(Config.DefaultEvents['setGang'])
AddEventHandler(Config.DefaultEvents['setGang'], function(gang)
	PlayerData.gang = gang
    RemveoAllZones()
    RemoveAllMarkers()

    LoadZoneOfGangOptions()
    if PlayerData.gang.name ~= 'nogang' then
      LoadMyGangOptions()
    end
 
end)
RegisterNetEvent(Config.DefaultEvents['playerLoaded'])
AddEventHandler(Config.DefaultEvents['playerLoaded'], function(xPlayer)
  PlayerData = xPlayer
  RemveoAllZones()
  RemoveAllMarkers()

  LoadZoneOfGangOptions()
  LoadMyGangOptions()


end)
RegisterNetEvent('For5M:UpdateMyGang')
AddEventHandler('For5M:UpdateMyGang', function(GangName)
    RemveoAllZones()
    if PlayerData.gang.name == GangName then
        RemoveAllMarkers()

        LoadMyGangOptions()
    end 
    LoadZoneOfGangOptions()
end)
RegisterNetEvent('For5M:UpdateMyGangOthersData')
AddEventHandler('For5M:UpdateMyGangOthersData', function(GangName , OthersData )
    if PlayerData.gang.name == GangName then
        MyGangData.others = OthersData 
    end 
end)
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    Wait(1000)
    while ESX == nil do Wait(500) end 
    ESX.TriggerServerCallback('FMGangs:GetPlayerData', function(data) 
        PlayerData = data
        RemveoAllZones()
        RemoveAllMarkers()
        
        LoadMyGangOptions()
        LoadZoneOfGangOptions()
    end)
  end)
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    RemveoAllZones()
    RemoveAllMarkers()
end)
-----------------------------
-- Load Zone For All 
-----------------------------
function LoadZoneOfGangOptions()
    ESX.TriggerServerCallback('FMGangs:GetAllGangs', function(data)   
        for k,v in pairs(data) do 
            if type(data[k].blip) == 'table' then 
                for key,blip in pairs(data[k].blip) do
                    MakeZoneForRadius(vector3( blip.coord.x , blip.coord.y ,blip.coord.z ), 50.0 , 73 )
                end 
            end
            if type(data[k].flag) == 'table' then 
                for key,flag in pairs(data[k].flag) do
                    flag.label = false  
                    CreateMarker( 'flag' .. '-' .. key, flag)
                end 
            end 
            if type(data[k].bots) == 'table' then 
                for key,bots in pairs(data[k].bots) do
                    bots.label = false 
                    CreateMarker( 'bots' .. '-' .. key, bots)
                end 
            end
            
        end
    end)
end 
-----------------------------
--- load Functions
-----------------------------
function LoadMyGangOptions()
  ESX.TriggerServerCallback('For5M:GetGangData', function(Active,data)
        MyGangData = {}
    if  Active then 
        MyGangData.gang_name =  data.label
        MyGangData.Active = true 
        MyGangData.others =  data.others
        MyGangData.grades =  data.grades
        ----------------------
        MyGangData.blip =  data.blip or {}

        for k ,blip in pairs( MyGangData.blip ) do 
            CreateBlip( MyGangData.gang_name , blip  )
        end 
        ----------------------
        MyGangData.boss =  data.boss   or {}
        for k ,boss in pairs( MyGangData.boss ) do  
            boss.label = 'boss' 
            CreateMarker( 'boss' .. '-' .. k, boss  , function(KeyPressed)  
                -- switched from the custom NUI panel (OpenBossMenu(),
                -- still defined below / client/boss.lua) to the
                -- ESX-default-menu boss actions (client/boss_esx_menu.lua),
                -- matching the old Unique_Gangs style as requested.
                OpenBossActionsMenu()
            end)
        end 
        ---------------------
        MyGangData.locker =  data.locker  or {}
        for k ,locker in pairs( MyGangData.locker ) do  
            locker.label = 'locker'   
            CreateMarker( 'locker' .. '-' .. k, locker  , function(KeyPressed)  
                OpenLockerMenu(MyGangData.others)
            end)
        end 
        ---------------------
        MyGangData.armory =  data.armory or {} 
        for k ,armory in pairs( MyGangData.armory ) do  
            armory.label = 'armory'   
            CreateMarker( 'armory' .. '-' .. k, armory  , function(KeyPressed)  
                OpenArmoryMenu(armory.code)
            end)
        end 
        ---------------------
        MyGangData.craft =  data.craft or {}
        for k ,craft in pairs( MyGangData.craft ) do  
            craft.label = 'craft'   
            CreateMarker( 'craft' .. '-' .. k, craft  , function(KeyPressed)  
                OpenCraftMenu()
            end)
        end
        ---------------------
        MyGangData.shop =  data.shop or {}
        for k ,shop in pairs( MyGangData.shop ) do
            shop.label = 'Shop'   
            CreateMarker( 'shop' .. '-' .. k, shop  , function(KeyPressed)  
                OpenShopMenu()
            end)
        end  
        ---------------------
        MyGangData.veh =  data.veh or {}
        for k ,veh in pairs( MyGangData.veh ) do
            veh.label = 'vehicle'   
            CreateMarker( 'veh' .. '-' .. k, veh  , function(KeyPressed)  
                OpenVehicleMenu()
            end)
        end  
        ---------------------
        MyGangData.vehspawn =  data.vehspawn or {}
        ---------------------
        MyGangData.heli =  data.heli or {}
        for k ,heli in pairs( MyGangData.heli ) do
            heli.label = 'heli'   
            CreateMarker( 'heli' .. '-' .. k, heli  , function(KeyPressed)  
                OpenHeliMenu()
            end)
        end
        ---------------------
        MyGangData.helispawn =  data.helispawn or {}
        ---------------------
        MyGangData.boat =  data.boat or {}
        for k ,boat in pairs( MyGangData.boat ) do
            boat.label = 'boat'   
            CreateMarker( 'boat' .. '-' .. k, boat  , function(KeyPressed)  
                OpenBoatMenu()
            end)
        end
        ---------------------
        MyGangData.boatspawn =  data.boatspawn or {}
        ---------------------
        MyGangData.delete =  data.deletecars or {}
        for k ,delete in pairs( MyGangData.delete ) do
            delete.label = 'delete'   
            CreateMarker( 'delete' .. '-' .. k, delete  , function(KeyPressed)  
            
                DeleteTheVehicle()
            end)
        end 
        ---------------------
    else 
        Notifiaction('Your Gang Is Not Active')
    end 
  end, PlayerData.gang.name)
end 
----------------------
--- Options
----------------------
function OpenBossMenu()
    TriggerEvent("FMGangsBoss:client:OpenMenu")
end 
function OpenLockerMenu(GangOthers) 
    local elements1 = {}
ESX.TriggerServerCallback('FMGangs:GetRankAccess', function(access)
  
    table.insert(elements1, { label ='Citizen Clothes',  value = 'self' })
    table.insert(elements1, { label = 'Gang Clothes', value = 'list' }) 
    table.insert(elements1, { label = 'Gang Armour', value = 'Armour' }) 
    table.insert(elements1, { label = 'Gang Vest', value = 'vest' })
    if access['setclothe'] then
        table.insert(elements1, { label = 'Clothing management', value = 'manage' }) 
    end


    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Lebas_menu',
    {
        title    = 'Clothes Menu',
        align    = 'center',
        elements = elements1
    },
    function(data, menu)
        if data.current.value == 'self' then
            ESX.TriggerServerCallback(Config.Skin .. ':'.. 'getPlayerSkin', function(skin)
                TriggerEvent(Config.skinchanger .. ':'.. 'loadSkin', skin)
            end)
        elseif data.current.value == 'Armour' then 
            SetPedArmour(PlayerPedId(), MyGangData.others.armor) 
        elseif data.current.value == 'vest' then
            -- FIX/FEATURE (requested: config-defined gang vests,
            -- selectable from the Clothes Menu): Config.GangVests
            -- lists presets; applying one only touches the vest
            -- component (bproof_1/bproof_2), so whatever else the
            -- player is wearing stays exactly as it was.
            if not Config.GangVests or #Config.GangVests == 0 then
                Notifiaction('No gang vests configured')
            else
                local vestElements = {}
                for _, vest in ipairs(Config.GangVests) do
                    table.insert(vestElements, { label = vest.name, value = vest })
                end
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_vest_menu', {
                    title    = 'Gang Vest',
                    align    = 'center',
                    elements = vestElements
                }, function(vdata, vmenu)
                    vmenu.close()
                    local vest = vdata.current.value
                    ESX.TriggerServerCallback(Config.Skin .. ':'.. 'getPlayerSkin', function(skin)
                        TriggerEvent(Config.skinchanger .. ':loadClothes', skin, { bproof_1 = vest.bproof_1, bproof_2 = vest.bproof_2 })
                    end)
                end, function(vdata, vmenu)
                    vmenu.close()
                end)
            end
        elseif data.current.value == 'list' then 
            local elements2 = {}
            ESX.TriggerServerCallback('FMGangs:GetRankCloths', function(Dataa)
   
                if Dataa[1] == nil then  return Notifiaction('Lebasi Set Nashode') end 
                for k,v in pairs(Dataa) do 
                    table.insert(elements2, { label = v.name, value = json.decode(v.outfit) })
                end

                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Lebas_menu2',
                {
                    title    = 'Clothes Menu',
                    align    = 'center',
                    elements = elements2
                },
                function(data2, menu2)
                    ESX.TriggerServerCallback(Config.Skin .. ':'.. 'getPlayerSkin', function(skin)             
						TriggerEvent(Config.skinchanger .. ':loadClothes', skin, data2.current.value)
					end)
                end, function(data2, menu2)
                    menu2.close()
                end)
            end)
        elseif data.current.value == 'manage' then
            SelectRank(MyGangData.grades, function(grade)
                local FirstClothesSkin = {}
                ESX.TriggerServerCallback(Config.Skin .. ':'.. 'getPlayerSkin', function(myskin)
                    FirstClothesSkin = myskin
                end)
                ESX.TriggerServerCallback('FMGangs:GetRankClothsByRank', function(Outfitss)
                    local elements3 = {}
                    for k,v in pairs(Outfitss) do 
                        table.insert(elements3, { label = v.name, value = k, fulldata = v })
                    end       
                    table.insert(elements3, { label = 'Add Outfit', value = 'add' })
                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Lebas_menu22212',
                    {
                        title    = 'Clothes Menu',
                        align    = 'center',
                        elements = elements3
                    },
                    function(data44, menu44)
                        
                        if data44.current.value == 'add' then
                            TriggerEvent(Config.MenuSkintrigger,function(skindata, skinmenu)
                                skinmenu.close()
                                ESX.UI.Menu.CloseAll()
                                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'lebas_name', {
                                    title = 'OutfitName'
                                }, function(savedata, savemenu)
                                    local name = savedata.value
                                    if name == nil then   ESX.ShowNotification('Lotfam Esm Ra Vared Konid') else
                                        ESX.UI.Menu.CloseAll()
                                        ESX.TriggerServerCallback(Config.Skin .. ':'.. 'getPlayerSkin', function(myskin)
                                            TriggerEvent(Config.skinchanger .. ':'.. 'getSkin', function(skin)
                                                ESX.TriggerServerCallback('FMGangs:SetClothRank', function()
                                                    TriggerServerEvent('For5M:SendLog', GetPlayerServerId(PlayerId()) , 'Locker' , 'New Clothe Add To Locker  | ' .. name  )
                                                end, grade, skin, name)
                                            end)
                                            TriggerEvent(Config.skinchanger .. ':'.. 'loadSkin', FirstClothesSkin)
                                            Wait(tonumber(1000))
                                            TriggerServerEvent(Config.Skin .. ':'.. 'save', FirstClothesSkin)
                                            Wait(tonumber(1000))
                                            ESX.TriggerServerCallback(Config.Skin .. ':'.. 'getPlayerSkin', function(skin, jobSkin)
                                                TriggerEvent(Config.skinchanger .. ':'.. 'loadSkin', skin)
                                            end)
                                        end)
                                    end 
                                end, function(savedata, savemenu)
                                    savemenu.close()
                                end)
                            
                            end,
                            function(skindata, skinmenu)
                                skinmenu.close()
                            end,
                            {
                                "tshirt_1",
                                "tshirt_2",
                                "torso_1",
                                "torso_2",
                                "decals_1",
                                "decals_2",
                                "arms",
                                "mask_1",
                                "mask_2",
                                "pants_1",
                                "pants_2",
                                "shoes_1",
                                "shoes_2",
                                "chain_1",
                                "chain_2",
                                "helmet_1",
                                "helmet_2",
                                "glasses_1",
                                "glasses_2",
                                "bags_1",
                                "bags_2",
                                "bproof_1",
                                "bproof_2",
                            }, function(name, value)
                            
                            end)
                        else
                            local elements4 = {}
                            table.insert(elements4, { label ='Edit Clothe',  value = 'edit'  , fulldata = data44.current.fulldata  })
                            table.insert(elements4, { label = 'Delete Clothe', value = 'del', fulldata = data44.current.fulldata }) 
                            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Lebas_menu4',
                            {
                                title    = 'Clothes Menu',
                                align    = 'center',
                                elements = elements4
                            },
                            function(data4, menu4)
                                if data4.current.value == 'edit' then         
                                    ESX.TriggerServerCallback(Config.Skin .. ':'.. 'getPlayerSkin', function(skin)             
                                        TriggerEvent(Config.skinchanger .. ':loadClothes', skin, json.decode(data44.current.fulldata.outfit) )
                                    end)                     
                                    TriggerEvent(Config.MenuSkintrigger,function(skindata, skinmenu)
                                        skinmenu.close()
                                        Wait(1000)
                                        ESX.TriggerServerCallback(Config.Skin .. ':'.. 'getPlayerSkin', function(myskin)
                                            TriggerServerEvent(Config.Skin .. ':'.. 'save', myskin)
                                            TriggerEvent(Config.skinchanger .. ':'.. 'getSkin', function(skin)
                                                ESX.UI.Menu.CloseAll()
                                                ESX.TriggerServerCallback('FMGangs:SetClothRank2', function()
                                                    TriggerServerEvent('For5M:SendLog', GetPlayerServerId(PlayerId()) , 'Locker' , ' Edit Clothe | ' .. data44.current.fulldata.name  )
                                             
                                                end, grade, skin, data44.current.fulldata.name )
                                            end)        
                                            TriggerEvent(Config.skinchanger .. ':'.. 'loadSkin', myskin)
                                            Wait(tonumber(1000))
                                            TriggerServerEvent(Config.Skin .. ':'.. 'save', myskin)
                                            Wait(tonumber(1000))
                                            ESX.TriggerServerCallback(Config.Skin .. ':'.. 'getPlayerSkin', function(skin, jobSkin)
                                               TriggerEvent(Config.skinchanger .. ':'.. 'loadSkin', skin)
                                            end)
                                        end)    
                                    end,
                                    function(skindata, skinmenu)
                                        skinmenu.close()
                                    end,
                                    {
                                        "tshirt_1",
                                        "tshirt_2",
                                        "torso_1",
                                        "torso_2",
                                        "decals_1",
                                        "decals_2",
                                        "arms",
                                        "mask_1",
                                        "mask_2",
                                        "pants_1",
                                        "pants_2",
                                        "shoes_1",
                                        "shoes_2",
                                        "chain_1",
                                        "chain_2",
                                        "helmet_1",
                                        "helmet_2",
                                        "glasses_1",
                                        "glasses_2",
                                        "bags_1",
                                        "bags_2",
                                        "bproof_1",
                                        "bproof_2",
                                    }, function(name, value)
                                    
                                    end)
                                elseif data4.current.value == 'del' then
                                    ESX.TriggerServerCallback('FMGangs:DelClothRank', function()
                                        ESX.UI.Menu.CloseAll()      
                                    end, grade, data4.current.fulldata.name)
                                end
                            end, function(data4, menu4)
                                menu4.close()
                            end)
                        end
                        
                    end, function(data44, menu44)
                        menu44.close()
                    end)
                end, grade)
            end)
        end
    end, function(data, menu)
        menu.close()
    end)
end)
end 
function SelectRank(Ranks , cb)
    local elements = {}
    for k,v in pairs(Ranks ) do 
        table.insert(elements, { label = v.label,  value = v.grade })
    end 
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Lebas_menu2',
    {
        title    = 'Select Rank',
        align    = 'center',
        elements = elements
    },
    function(data2, menu2)
        cb(data2.current.value)
    end, function(data2, menu2)
        menu2.close()
    end)
end 

function OpenArmoryMenu(armory)
    if KeyPressedCD then return end 
    KeyPressedCD = true SetTimeout(1500, function() KeyPressedCD =false  end)
    ESX.TriggerServerCallback('For5M:OpenInventory', function(open)
        if not open then 
            
           Notifiaction('Can`t Open Armory , try again ')
        end 
     end , armory )
end 
function OpenCraftMenu()
    if KeyPressedCD then return end 
    KeyPressedCD = true SetTimeout(1500, function() KeyPressedCD =false  end)
    -------------------------------------------------------------------
    -- Now gated behind a real access flag ('crafting'), matching the
    -- same pattern already used for garage/heli/boat access. Note:
    -- this only controls WHO can trigger 'For5M:OpenCraftMenu' - the
    -- actual crafting UI/logic that event is meant to open isn't part
    -- of this resource (no handler for it exists anywhere here), so
    -- it depends on whatever separate crafting resource you pair this
    -- with actually listening for that event.
    -------------------------------------------------------------------
    ESX.TriggerServerCallback('FMGangs:GetRankAccess', function(access)
        if access['crafting'] then
            TriggerEvent('For5M:OpenCraftMenu')
        else
            Notifiaction('You Dont Have Access To Crafting')
        end
    end)
end 
function OpenShopMenu()
    if KeyPressedCD then return end 
    KeyPressedCD = true SetTimeout(1500, function() KeyPressedCD =false  end)
    TriggerEvent('FMBlackMarket:openShop')
end
-------------------------------------------------------------------
-- FIX: For5M:OpenGarage was only ever triggered, never handled
-- anywhere in this resource (dead event - depends on a separate
-- garage resource that isn't part of this merge). Replaced with a
-- real vehicle picker using ESX.Game.SpawnVehicleJobs, the exact same
-- function this server's own police job (esx_uniquejobs) already
-- uses successfully - confirmed it exists in essentialmode's client
-- functions before relying on it. Models come from
-- Config.GangVehicles (car/heli/boat lists).
-------------------------------------------------------------------
function OpenGangVehicleSpawner(spawnPoint, category, vehicleAccess)
    local models = Config.GangVehicles[category] or {}
    if #models == 0 then
        Notifiaction('No vehicles configured for this spawn point')
        return
    end

    vehicleAccess = vehicleAccess or {}
    local elements = {}
    for _, model in ipairs(models) do
        -- Per-rank vehicle access (client-side filter - not the real
        -- trust boundary, see FMGangs:RegisterGangVehicle below/
        -- server/boss.lua for the actual enforcement). unset (nil)
        -- means "allowed", same default as itemAccess.
        if vehicleAccess[model] ~= false then
            table.insert(elements, { label = GetLabelText(GetDisplayNameFromVehicleModel(GetHashKey(model))) or model, value = model })
        end
    end
    if #elements == 0 then
        Notifiaction('Your rank does not have access to any vehicle in this category')
        return
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_vehicle_spawner', {
        title    = 'SELECT VEHICLE',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        menu.close()
        local model = data.current.value
        -------------------------------------------------------------
        -- Real integration with Unique_Garage (requested: "connect
        -- it to the garage system, give them keys to their gang's
        -- vehicle"). Confirmed the exact mechanism by reading
        -- Unique_Garage/esx_vehicleshop's own code before wiring
        -- this, the same way as everywhere else in this resource:
        --   - exports.esx_vehicleshop:GeneratePlate() - the same
        --     plate generator esx_vehicleshop itself uses
        --   - ownership is stored in the shared `owned_vehicles`
        --     table (owner = gang name, job = 'gang') - same shape
        --     esx_vehicleshop's own admin /addcargang command uses,
        --     via 'esx_vehicleshop:setVehicleGang'
        --   - real keys via CarLock:ToggleKey (Unique_Garage's own
        --     key item system, CarKey|<plate> in the player's
        --     inventory) - not a fake/cosmetic key
        --
        -- 'esx_vehicleshop:setVehicleGang' itself is admin-only
        -- server-side (permission_level >= 10) - a boss isn't
        -- necessarily a server admin, so this doesn't route through
        -- that event. Instead FMGangs:RegisterGangVehicle
        -- (server/boss.lua) does the same INSERT directly, gated by
        -- our own boss/access check instead of admin level - the
        -- correct way to let a boss do this without needing admin
        -- rights.
        -------------------------------------------------------------
        local plate = exports.esx_vehicleshop:GeneratePlate()
        ESX.Game.SpawnVehicleJobs(model, vector3(spawnPoint.x, spawnPoint.y, spawnPoint.z), spawnPoint.h, function(vehicle)
            SetVehicleNumberPlateText(vehicle, plate)
            SetVehicleEngineHealth(vehicle, 1000.0)
            SetVehicleBodyHealth(vehicle, 1000.0)
            SetVehicleFixed(vehicle)
            SetVehicleDeformationFixed(vehicle)
            SetVehicleEngineOn(vehicle, true, true, false)
            local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
            vehicleProps.plate = plate

            ESX.TriggerServerCallback('FMGangs:RegisterGangVehicle', function(success)
                if success then
                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    TriggerServerEvent('CarLock:ToggleKey', true, plate)
                    Notifiaction('Vehicle registered to the gang - keys given')
                    -- FEATURE (requested: full detail on spawn logs too):
                    -- same detail level as the store log below - model,
                    -- plate, fuel/engine/body, since it's a brand-new
                    -- vehicle these are always full/100% but logging the
                    -- real read values (not just hardcoded "100%") keeps
                    -- this consistent if SetVehicleFixed/EngineHealth
                    -- above ever changes.
                    local ok, fuel = pcall(function() return exports['LegacyFuel']:GetFuel(vehicle) end)
                    local fuelPercent = (ok and fuel) and math.floor(fuel + 0.5) or math.floor(GetVehicleFuelLevel(vehicle) + 0.5)
                    local engineHealth = GetVehicleEngineHealth(vehicle)
                    local bodyPercent = math.floor((GetVehicleBodyHealth(vehicle) / 1000.0) * 100)
                    local displayName = GetLabelText(GetDisplayNameFromVehicleModel(model)) or model
                    TriggerServerEvent('For5M:SendLog', GetPlayerServerId(PlayerId()), 'Garage',
                        ('Spawned New Vehicle | %s | Plate: %s | Fuel: %d%% | Engine: %s | Body: %d%%'):format(
                            displayName, plate, fuelPercent, (engineHealth > 0 and 'Yes' or 'No'), bodyPercent))
                else
                    Notifiaction('Could not register this vehicle to the gang')
                end
            end, vehicleProps, model, category)
        end)
    end, function(data, menu)
        menu.close()
    end)
end

-------------------------------------------------------------------
-- FIX (requested: "why do two things come up, it should just be with
-- the garage look and show the car like the picture" - the popup
-- asking existing-vs-new before every single garage visit): pressing
-- E at a gang vehicle/heli/boat spawn point now goes straight into
-- Unique_Garage's own real UI (client.lua's OpenMenuG('gang', ...)),
-- exactly like a personal garage - no intermediate choice. Registering
-- a brand-new vehicle (a rarer, higher-permission action - still uses
-- OpenGangVehicleSpawner above, unchanged) moved to its own command,
-- /getfreecargang, below - reuses the exact same nearest-spawn-point
-- + access-check logic as OpenVehicleMenu/OpenHeliMenu/OpenBoatMenu so
-- it only works standing at one of those same spots.
-------------------------------------------------------------------
RegisterCommand('getfreecargang', function()
    if not PlayerData.gang or PlayerData.gang.name == 'nogang' then return end
    if IsPedInAnyVehicle(PlayerPedId()) then return end
    if KeyPressedCD then return end
    KeyPressedCD = true SetTimeout(1500, function() KeyPressedCD = false end)

    local spawnGroups = {
        { data = MyGangData.vehspawn,  category = 'car',  accessKey = 'garage' },
        { data = MyGangData.helispawn, category = 'heli', accessKey = 'heliANDBoat' },
        { data = MyGangData.boatspawn, category = 'boat', accessKey = 'heliANDBoat' },
    }
    local best = nil
    for _, group in ipairs(spawnGroups) do
        if group.data and next(group.data) then
            local Distance, Key = GetNeaestrCoordsValueInTable(group.data)
            if Distance < 80.0 and (not best or Distance < best.Distance) then
                best = { Distance = Distance, Key = Key, data = group.data, category = group.category, accessKey = group.accessKey }
            end
        end
    end
    if not best then
        Notifiaction('You are not near any gang vehicle spawn point')
        return
    end

    ESX.TriggerServerCallback('FMGangs:GetRankAccess', function(access)
        if access[best.accessKey] then
            OpenGangVehicleSpawner({ x = best.data[best.Key].coord.x, y = best.data[best.Key].coord.y, z = best.data[best.Key].coord.z, h = best.data[best.Key].heading }, best.category, access.vehicleAccess)
        else
            Notifiaction('You do not have access to the garage here')
        end
    end)
end, false)

-------------------------------------------------------------------
-- FEATURE (requested: gang member drives their own vehicle to the
-- gang's spawn point, presses E while in it, gets an English Yes/No
-- confirmation - "Are you sure you want to donate this vehicle to the
-- gang?" - and on Yes it becomes the gang's, immediately manageable
-- from Boss Action > Vehicle Access like any other gang vehicle).
-- Real trust boundary is server-side (FMGangs:DonateVehicleToGang,
-- server/boss.lua) - verifies the plate is actually this player's
-- vehicle before touching ownership, not just whatever they're
-- sitting in.
-------------------------------------------------------------------
function OfferDonateVehicleToGang(category)
    if not PlayerData.gang or PlayerData.gang.name == 'nogang' then return end
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if not DoesEntityExist(vehicle) then return end
    if GetPedInVehicleSeat(vehicle, -1) ~= PlayerPedId() then
        Notifiaction('Only the driver can donate this vehicle')
        return
    end
    local plate = GetVehicleNumberPlateText(vehicle)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_donate_vehicle_confirm', {
        title    = 'Are you sure you want to donate this vehicle to the gang?',
        align    = 'top-left',
        elements = {
            { label = 'Yes', value = true },
            { label = 'No',  value = false },
        }
    }, function(data, menu)
        menu.close()
        if not data.current.value then return end
        local model = GetEntityModel(vehicle)
        local modelName = string.lower(GetDisplayNameFromVehicleModel(model) or '')
        local displayName = GetLabelText(GetDisplayNameFromVehicleModel(model)) or 'Unknown'
        ESX.TriggerServerCallback('FMGangs:DonateVehicleToGang', function(success)
            if success then
                Notifiaction('Vehicle donated to the gang')
                TriggerServerEvent('For5M:SendLog', GetPlayerServerId(PlayerId()), 'Garage',
                    ('Vehicle Donated To Gang | %s | Plate: %s'):format(displayName, plate))
                ESX.Game.DeleteVehicle(vehicle)
            else
                Notifiaction('Could not donate this vehicle - is it actually registered to you?')
            end
        end, PlayerData.gang.name, plate, category, modelName)
    end, function(data, menu)
        menu.close()
    end)
end

function OpenVehicleMenu()
    if KeyPressedCD then return end 
    KeyPressedCD = true SetTimeout(1500, function() KeyPressedCD =false  end)
    if next(MyGangData.vehspawn) then 
        local Distance , Key = GetNeaestrCoordsValueInTable(MyGangData.vehspawn)
        if Distance < 80.0 then 
            -------------------------------------------------------------
            -- FEATURE (requested: a member drives their own car here,
            -- presses E while in it, gets asked to confirm donating it
            -- to the gang - see OfferDonateVehicleToGang below). Only
            -- takes this branch when actually near a real gang spawn
            -- point, same as everything else here.
            -------------------------------------------------------------
            if IsPedInAnyVehicle(PlayerPedId()) then
                OfferDonateVehicleToGang('car')
                return
            end
            ESX.TriggerServerCallback('FMGangs:GetRankAccess', function(access)
                if access['garage'] then 
                    -------------------------------------------------
                    -- FIX (requested: E should go straight into the
                    -- real garage UI, not a plain popup asking
                    -- existing/new first - see /getfreecargang
                    -- below for registering a brand-new vehicle)
                    -------------------------------------------------
                    TriggerEvent('Unique_Garage:OpenGangGarage', PlayerData.gang.name, { x = MyGangData.vehspawn[Key].coord.x , y = MyGangData.vehspawn[Key].coord.y , z = MyGangData.vehspawn[Key].coord.z , h = MyGangData.vehspawn[Key].heading }, 'car')
                else 
                    Notifiaction('You Does Not Have Access To Open Garage !!')
                end 
            end)
        else
            Notifiaction(' This Gang  Does not Have Any Vehicle Spawn Point Near You !!')
        end 
    else 
        Notifiaction(' This Gang Does not Have Any Vehicle Spawn Point !!')
    end 
end
function OpenHeliMenu()
    if KeyPressedCD then return end 
    KeyPressedCD = true SetTimeout(1500, function() KeyPressedCD =false  end)
    if next(MyGangData.helispawn) then 
        local Distance , Key = GetNeaestrCoordsValueInTable(MyGangData.helispawn)

        if Distance < 80.0 then 
            if IsPedInAnyVehicle(PlayerPedId()) then
                OfferDonateVehicleToGang('heli')
                return
            end
            ESX.TriggerServerCallback('FMGangs:GetRankAccess', function(access)
                if access['heliANDBoat'] then
                    TriggerEvent('Unique_Garage:OpenGangGarage', PlayerData.gang.name, { x = MyGangData.helispawn[Key].coord.x , y = MyGangData.helispawn[Key].coord.y , z = MyGangData.helispawn[Key].coord.z , h = MyGangData.helispawn[Key].heading }, 'heli')
                else 
                    Notifiaction('You Does Not Have Access To Open Heli Garage !!')
                end 
            end)
        else
            Notifiaction(' This Gang  Does not Have Any Heli Spawn Point  Near You !!')
        end 
    else 
        Notifiaction(' This Gang Does not Have Any Heli Spawn Point !!')
    end 
end
function OpenBoatMenu()
    if KeyPressedCD then return end 
    KeyPressedCD = true SetTimeout(1500, function() KeyPressedCD =false  end)
    if next(MyGangData.boatspawn) then 
        local Distance , Key = GetNeaestrCoordsValueInTable(MyGangData.boatspawn)
        if Distance < 80.0 then 
            if IsPedInAnyVehicle(PlayerPedId()) then
                OfferDonateVehicleToGang('boat')
                return
            end
            ESX.TriggerServerCallback('FMGangs:GetRankAccess', function(access)
                if access['heliANDBoat'] then
                    TriggerEvent('Unique_Garage:OpenGangGarage', PlayerData.gang.name, { x = MyGangData.boatspawn[Key].coord.x , y = MyGangData.boatspawn[Key].coord.y , z = MyGangData.boatspawn[Key].coord.z , h = MyGangData.boatspawn[Key].heading }, 'boat')
                else 
                    Notifiaction('You Does Not Have Access To Open Boat Garage !!')
                end 
            end)
       else
            Notifiaction(' This Gang  Does not Have Any Boat Spawn Point Near You !!')
        end 
    else 
        Notifiaction(' This Gang Does not Have Any Boat Spawn Point !!')
    end 
end
function DeleteTheVehicle(type)
    if KeyPressedCD then return end 
    local Vehicle =  GetVehiclePedIsIn(PlayerPedId())
    if DoesEntityExist(Vehicle) then 
        -------------------------------------------------------------
        -- FIX (essentialmode: TriggerServerCallback =>
        -- [For5mG-garage:getvehiclebyplate] does not exist): this
        -- called a callback that was only ever meant to be provided
        -- by FMGangsGarage - a resource that was never merged in (and
        -- turned out to contain a backdoor, see README - never merge
        -- it). Now checks ownership directly against the real
        -- owned_vehicles table (the same one
        -- FMGangs:RegisterGangVehicle writes to when a gang vehicle
        -- is spawned), and marks it stored there instead of the dead
        -- 'For5mG-garage:stored' event.
        -------------------------------------------------------------
        local plate = GetVehicleNumberPlateText(Vehicle)
        -------------------------------------------------------------
        -- FEATURE (requested: full detail in the log when a vehicle is
        -- parked - engine on/off, health %, all of it) + bonus fix:
        -- read the real condition BEFORE the vehicle gets deleted below,
        -- and persist it the same way Unique_Garage's own UI does
        -- (SetVehState, job='Gang' branch, server.lua) instead of only
        -- flipping `stored`. Previously FMGangs:StoreGangVehicle only
        -- ever set stored=1 - fuel/engine/body were never saved, so a
        -- vehicle always came back at whatever state it was created in
        -- regardless of how it was actually left. SetVehState already
        -- has the correct query for this (same table Unique_Garage's
        -- own take-out flow reads/writes), so this reuses it instead of
        -- reinventing another column update.
        -------------------------------------------------------------
        local vehicleProps = ESX.Game.GetVehicleProperties(Vehicle)
        local ok, fuel = pcall(function() return exports['LegacyFuel']:GetFuel(Vehicle) end)
        local fuelPercent = (ok and fuel) and math.floor(fuel + 0.5) or math.floor(GetVehicleFuelLevel(Vehicle) + 0.5)
        local engineHealth = GetVehicleEngineHealth(Vehicle)
        local bodyHealth = GetVehicleBodyHealth(Vehicle)
        local bodyPercent = math.floor((bodyHealth / 1000.0) * 100)
        if bodyPercent < 0 then bodyPercent = 0 end
        if bodyPercent > 100 then bodyPercent = 100 end
        local displayName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(Vehicle))) or 'Unknown'

        ESX.TriggerServerCallback('FMGangs:GetGangVehicleByPlate', function(gangveh) 
            if gangveh then 
                TriggerServerEvent('For5M:SendLog', GetPlayerServerId(PlayerId()) , 'Garage' ,
                    ('Stored Vehicle | %s | Plate: %s | Fuel: %d%% | Engine: %s | Body: %d%%'):format(
                        displayName, plate, fuelPercent, (engineHealth > 0 and 'Yes' or 'No'), bodyPercent))
                TriggerServerEvent('SetVehState', 1, plate, { fuel = fuelPercent, engine = engineHealth, body = bodyHealth, props = vehicleProps }, 'Gang', PlayerData.gang.name)
                ESX.Game.DeleteVehicle(Vehicle)
            else 
                Notifiaction(' This Vehicle Its Not For This Gang  !!')
            end 
        end, plate)
    end 
end

-------------------------
--- Gang Menu
-------------------------
AddEventHandler('onKeyDown',function(key)
    if key == 'f5' and PlayerData.gang.name ~= 'nogang' and  next(MyGangData) and MyGangData.Active then 
        OpenGangMenu(MyGangData)
    end
end)
function OpenGangMenu(MyGangData)
    local elements = {}
    if tonumber(MyGangData.others.search) == 1 then
        table.insert(elements, { label = 'Search', value = 'search' })
    end
    if tonumber(MyGangData.others.cuff) == 1 then
        table.insert(elements, { label = 'Cuff',   value = 'cuff' })
        table.insert(elements, { label = 'UnCuff', value = 'uncuff' })
        table.insert(elements, { label = 'Drag', value = 'drag' })
        table.insert(elements, { label = 'Put in Veh', value = 'putin' })
        table.insert(elements, { label = 'Put out Veh', value = 'putout' })
    end
    if tonumber(MyGangData.others.lockpick) == 1 then
    table.insert(elements, { label = 'LockPick', value = 'lock' })
    end 
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gang_menu',
    {
        title    = 'Action Menu',
        align    = 'right',
        elements = elements
    },
    function(data, menu)
        if data.current.value == 'search' then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer ~= -1 and closestDistance <= 3.0 then
                local isCan = GetPlayerHandsup(closestPlayer, 'Search')
                if isCan then
                    OpenBodySearchMenu(closestPlayer)
                else
                    Notifiaction('Daste Fard Bala Nist')
                end
            else
                Notifiaction('Playeri Nazdike Shoma Nis')
            end
        elseif data.current.value == 'cuff' then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer ~= -1 and closestDistance <= 3.0 then
                local isCan = GetPlayerHandsup(closestPlayer, 'Search')
                if isCan then
                    TriggerEvent(Config.DefaultEvents['Cuff'])
                else
                    Notifiaction('Daste Fard Bala Nist')
                end
            else
                Notifiaction('Playeri Nazdike Shoma Nis')
            end
        elseif data.current.value == 'uncuff' then
            TriggerEvent(Config.DefaultEvents['UnCuff'])
        elseif data.current.value == 'drag' then
            TriggerEvent(Config.DefaultEvents['Drag'])
        elseif data.current.value == 'putin' then
            TriggerEvent(Config.DefaultEvents['PutInVeh'])
        elseif data.current.value == 'putout' then
            TriggerEvent(Config.DefaultEvents['PutOutVeh'])
        elseif data.current.value == 'lock' then
            TriggerEvent(Config.DefaultEvents['LockPick'])
        end
    end, function(data, menu)
        menu.close()
    end)
end 

function OpenBodySearchMenu(player)
	ESX.TriggerServerCallback(Config.DefaultEvents['DataCard'], function(data)
		local elements = {}
		  table.insert(elements, {label = "----- Cash -----", value = nil})
		  table.insert(elements, {
			  label = 'Pool : $' .. ESX.Math.GroupDigits(data.money),
			  value = 'money',
			  itemType = 'item_money',
			  amount = money
		  })	  

		  table.insert(elements, {label = '--- Guns ---', value = nil})
		  for i=1, #data.weapons, 1 do
			  table.insert(elements, {
				  label    = 'confiscate '..ESX.GetWeaponLabel(data.weapons[i].name)..' with '..data.weapons[i].ammo..' bullets',
				  value    = data.weapons[i].name,
				  itemType = 'item_weapon',
				  amount   = data.weapons[i].ammo
			  })
		  end
		  table.insert(elements, {label = '--- Inventory ---', value = nil})
		  for i=1, #data.inventory, 1 do
			  if data.inventory[i].count > 0 then
				  table.insert(elements, {
				  label    = 'confiscate '..data.inventory[i].count..'x '..data.inventory[i].label,
				  value    = data.inventory[i].name,
				  itemType = 'item_standard',
				  amount   = data.inventory[i].count
				  })
			  end
		  end
		  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search',
		  {
			  title    = 'Search',
			  align    = 'right',
			  elements = elements,
		  },
		  function(data, menu)
			  	local itemType = data.current.itemType
			  	local itemName = data.current.value
			  	local amount   = data.current.amount
			  	if data.current.value ~= nil then
					Wait(math.random(0, 500))
					local coords = GetEntityCoords(GetPlayerPed(-1))
					local coords2 = GetEntityCoords(GetPlayerPed(player))
					if math.floor(Vdist2(coords.x, coords.y, coords.z, coords2.x, coords2.y, coords2.z)) < 4 then
						TriggerServerEvent(Config.DefaultEvents['confiscatePlayerItem'], GetPlayerServerId(player), itemType, itemName, amount)   
						OpenBodySearchMenu(player, can_see)
					else
						Notifiaction('Playeri Nazdike Shoma Nist')
					end
				end
		  	end, function(data, menu)
			  	menu.close()
		  	end)
	end, GetPlayerServerId(player))
end

AddEventHandler(Config.DefaultEvents['onPlayerDeath'], function(data)
	isDead = true
	IsHandcuffed = false
	DragStatus.IsDragged = false
	Draging = false
end)

AddEventHandler(Config.DefaultEvents['playerSpawned'], function(spawn)
	isDead = false
	IsHandcuffed = false
	DragStatus.IsDragged = false
	Draging = false
end)

RegisterNetEvent('For5M:Cuff')
AddEventHandler("For5M:Cuff", function()
    local target, distance = ESX.Game.GetClosestPlayer()
    playerheading = GetEntityHeading(GetPlayerPed(-1))
    playerlocation = GetEntityForwardVector(PlayerPedId())
    playerCoords = GetEntityCoords(GetPlayerPed(-1))
    local target_id = GetPlayerServerId(target)
    if distance <= 2.0 then
        TriggerServerEvent('For5M:cuff', target_id, playerheading, playerCoords, playerlocation)
    else
        Notifiaction('Kasi Nazdik Shoma Nist!')
    end
end)

RegisterNetEvent('For5M:LockPick')
AddEventHandler("For5M:LockPick", function()
    local vehicle = ESX.Game.GetVehicleInDirection(4)
    if DoesEntityExist(vehicle) then
        local playerPed = GetPlayerPed(-1)
        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_WELDING", 0, true)
        SetVehicleAlarm(vehicle, true)
        StartVehicleAlarm(vehicle)
        SetVehicleAlarmTimeLeft(vehicle, 20000)
        TriggerEvent("mythic_progbar:client:progress", {
            name = "lockpicking_veh",
            duration = 10000,
            label = "Dar Hal Baaz Kardan Mashin...",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = {
                animDict = "",
                anim = "",
                }
        }, function(status)
            if not status then
                SetVehicleDoorsLocked(vehicle, 1)
                SetVehiceleDoorsLockedForAllPlayers(vehicle, false)
                ClearPedTasksImmediately(playerPed)
                Notifiaction("Mashin Baz Shd", 'suc')
            elseif status then
                ClearPedTasksImmediately(playerPed)
            end
        end)
    else
        Notifiaction("Mashini Nazdiket Ni")
    end
end)

RegisterNetEvent('For5M:UnCuff')
AddEventHandler("For5M:UnCuff", function()
    local target, distance = ESX.Game.GetClosestPlayer()
    playerheading = GetEntityHeading(GetPlayerPed(-1))
    playerlocation = GetEntityForwardVector(PlayerPedId())
    playerCoords = GetEntityCoords(GetPlayerPed(-1))
    local target_id = GetPlayerServerId(target)
    if distance <= 2.0 then
        TriggerServerEvent('For5M:uncuff', target_id, playerheading, playerCoords, playerlocation)
    else
        Notifiaction('Kasi Nazdik Shoma Nist!')
    end
end)

RegisterNetEvent('For5M:Drag')
AddEventHandler("For5M:Drag", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 2.0 then
        TriggerServerEvent('For5M:drag', GetPlayerServerId(closestPlayer))
    else
        Notifiaction('Kasi Nazdik Shoma Nist!')
    end
end)

RegisterNetEvent('For5M:PutInVeh')
AddEventHandler("For5M:PutInVeh", function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 2.0 then
		TriggerServerEvent('F5M:putInVehicle', GetPlayerServerId(closestPlayer))
    else
        Notifiaction('Kasi Nazdik Shoma Nist!')
    end
end)

RegisterNetEvent('For5M:PutOutVeh')
AddEventHandler("For5M:PutOutVeh", function()
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 8.0 then
        TriggerServerEvent('For5M:OutVehicle', GetPlayerServerId(closestPlayer))
    else
        Notifiaction('Kasi Nazdik Shoma Nist!')
    end
end)

RegisterNetEvent('For5M:Actions:draging')
AddEventHandler('For5M:Actions:draging', function(copID)
	Draging = not Draging
	if Draging then
		loadanimdict('switch@trevor@escorted_out')
		TaskPlayAnim(PlayerPedId(), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 8.0, 9.0, -1, 49, 0, 0, 0, 0)
	else
		StopAnimTask(PlayerPedId(), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 1.0)
		ClearPedSecondaryTask(PlayerPedId())
	end
end)

RegisterNetEvent('For5M:Actions:getarrested')
AddEventHandler('For5M:Actions:getarrested', function(playerheading, playercoords, playerlocation, target)
	ESX.UI.Menu.CloseAll()
	if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))) >= 5.0 then return end
	playerPed = GetPlayerPed(-1)
	IsHandcuffed = true
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	local x, y, z = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
	TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'cuff', 1.0)
	Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'crook_p2_back_right', 8.0, -8, 3750 , 2, 0, 0, 0, 0)
	Wait(3760)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
end)

RegisterNetEvent('For5M:Actions:doarrested')
AddEventHandler('For5M:Actions:doarrested', function()
	ESX.UI.Menu.CloseAll()
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	Wait(250)
	loadanimdict('mp_arrest_paired')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8,3750, 2, 0, 0, 0, 0)
	Wait(3000)
end)

RegisterNetEvent('For5M:Actions:getuncuffed')
AddEventHandler('For5M:Actions:getuncuffed', function(playerheading, playercoords, playerlocation, target)
	ESX.UI.Menu.CloseAll()
	if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(target)))) >= 5.0 then return end
	local x, y, z   = table.unpack(playercoords + playerlocation * 1.0)
	SetEntityCoords(GetPlayerPed(-1), x, y, z)
	SetEntityHeading(GetPlayerPed(-1), playerheading)
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 5.0, 'uncuff', 1.0)
	Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'b_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Wait(5500)
	IsHandcuffed = false
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('For5M:Actions:douncuffing')
AddEventHandler('For5M:Actions:douncuffing', function()
	ESX.UI.Menu.CloseAll()
	SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
	Wait(250)
	loadanimdict('mp_arresting')
	TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'a_uncuff', 8.0, -8,-1, 2, 0, 0, 0, 0)
	Wait(5500)
	ClearPedTasks(GetPlayerPed(-1))
end)

RegisterNetEvent('For5M:drag')
AddEventHandler('For5M:drag', function(copID)
	if IsHandcuffed or isDead then
		DragStatus.IsDragged = not DragStatus.IsDragged
		DragStatus.CopId = tonumber(copID)
	end
end)

RegisterNetEvent('For5M:putInVehicleS')
AddEventHandler('For5M:putInVehicleS', function()
	if Draging then
		Draging = false
		StopAnimTask(PlayerPedId(), 'switch@trevor@escorted_out', '001215_02_trvs_12_escorted_out_idle_guard2', 1.0)
		ClearPedSecondaryTask(PlayerPedId())
	end
end)
RegisterNetEvent('F5M:putInVehicle')
AddEventHandler('F5M:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if not IsHandcuffed then
		return
	end

	if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
		local vehicle = ESX.Game.GetClosestVehicle(coords)
		if DoesEntityExist(vehicle) then

			local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
			local freeSeat = nil

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat ~= nil then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
				TriggerEvent('seatbelt:beband', true)
				DragStatus.IsDragged = false
			end

		end

	end
end)

RegisterNetEvent('For5M:putInVehicle')
AddEventHandler('For5M:putInVehicle', function(vehicle)
	if IsHandcuffed or isDead then
		local veh = NetworkGetEntityFromNetworkId(vehicle)
		local ped = GetPlayerPed(-1)
		if IsVehicleSeatFree(veh, 1) then
			TaskWarpPedIntoVehicle(ped, veh, 1)
			DragStatus.IsDragged = false
			TriggerEvent('seatbelt:beband', true)
		elseif IsVehicleSeatFree(veh, 2) then
			TaskWarpPedIntoVehicle(ped, veh, 2)
			DragStatus.IsDragged = false
			TriggerEvent('seatbelt:beband', true)
		end
	end
end)

RegisterNetEvent('For5M:OutVehicle')
AddEventHandler('For5M:OutVehicle', function()
	local playerPed = PlayerPedId()

	if not (IsPedSittingInAnyVehicle(playerPed) and IsHandcuffed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
	SetTimeout(1000, function()
		loadanimdict('mp_arresting')
		TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
	end)
end)

CreateThread(function()
    while true do
        Wait(0)
        if IsHandcuffed then
            DisableControlAction(2, 24, true)
            DisableControlAction(0, 69, true)
            DisableControlAction(0, 70, true)
            DisableControlAction(0, 68, true)
            DisableControlAction(0, 66, true)
            DisableControlAction(0, 167, true)
            DisableControlAction(0, 67, true)
            DisableControlAction(2, 257, true)
            DisableControlAction(2, 25, true)
            DisableControlAction(2, 263, true)
            DisableControlAction(0, 29,  true)
            DisableControlAction(0, 74,  true)
            DisableControlAction(0, 71,  true)
            DisableControlAction(0, 72,  true)
            DisableControlAction(0, 63,  true)
            DisableControlAction(0, 64,  true)
            DisableControlAction(2, Keys['R'], true)
            DisableControlAction(2, Keys['LEFTSHIFT'], true)
            DisableControlAction(2, Keys['TOP'], true)
            DisableControlAction(2, Keys['SPACE'], true)
            DisableControlAction(2, Keys['Q'], true)
            DisableControlAction(2, Keys['TAB'], true)
            DisableControlAction(2, Keys['F'], true)
            DisableControlAction(2, Keys['F1'], true)
            DisableControlAction(2, Keys['F2'], true)
            DisableControlAction(2, Keys['F3'], true)
            DisableControlAction(2, Keys['V'], true)
            DisableControlAction(2, Keys['X'], true)
            DisableControlAction(2, Keys['P'], true)
            DisableControlAction(2, Keys['L'], true)
            DisableControlAction(2, Keys['Z'], true)
            DisableControlAction(2, 59, true)
            DisableControlAction(2, Keys['LEFTCTRL'], true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 264, true)
            DisableControlAction(0, 257, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 143, true)
            DisableControlAction(0, 75, true)
            DisableControlAction(27, 75, true)
            DisableControlAction(0, 107, true)
            DisableControlAction(0, 108, true)
            DisableControlAction(0, 109, true)
            DisableControlAction(0, 110, true)
            DisableControlAction(0, 111, true)
            DisableControlAction(0, 112, true)
            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey('WEAPON_UNARMED'), true)
            if not IsEntityPlayingAnim(GetPlayerPed(-1), "mp_arresting", "idle", 1) then
              TaskPlayAnim(GetPlayerPed(-1), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
            end
        else
            Wait(1000)
        end
    end
end)

CreateThread(function()
    local playerPed
    local targetPed
    while true do
        Wait(500)
        if IsHandcuffed or isDead then
            playerPed = PlayerPedId()
            if DragStatus.IsDragged then
                targetPed = GetPlayerPed(GetPlayerFromServerId(DragStatus.CopId))
                if not IsPedSittingInAnyVehicle(targetPed) then
                    AttachEntityToEntity(playerPed, targetPed, 11816, 0.1, 0.6, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                else
                    DragStatus.IsDragged = false
                    DetachEntity(playerPed, true, false)
                end
            else
                DetachEntity(playerPed, true, false)
            end
        else
            Wait(500)
        end
    end
end)

function loadanimdict(dictname)
    if not HasAnimDictLoaded(dictname) then
        RequestAnimDict(dictname)
        while not HasAnimDictLoaded(dictname) do
            Wait(1)
        end
    end
end
