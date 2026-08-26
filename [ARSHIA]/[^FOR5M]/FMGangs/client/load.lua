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
                OpenBossMenu()
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
    TriggerEvent('For5M:OpenCraftMenu')
end 
function OpenShopMenu()
    if KeyPressedCD then return end 
    KeyPressedCD = true SetTimeout(1500, function() KeyPressedCD =false  end)
    TriggerEvent('FMBlackMarket:openShop')
end
function OpenVehicleMenu()
    if IsPedInAnyVehicle(PlayerPedId()) then return end 
    if KeyPressedCD then return end 
    KeyPressedCD = true SetTimeout(1500, function() KeyPressedCD =false  end)
    if next(MyGangData.vehspawn) then 
        local Distance , Key = GetNeaestrCoordsValueInTable(MyGangData.vehspawn)
        if Distance < 80.0 then 
            ESX.TriggerServerCallback('FMGangs:GetRankAccess', function(access)
                if access['garage'] then 
                    TriggerEvent('For5M:OpenGarage', PlayerData.gang.name, { x = MyGangData.vehspawn[Key].coord.x , y = MyGangData.vehspawn[Key].coord.y , z = MyGangData.vehspawn[Key].coord.z , h = MyGangData.vehspawn[Key].heading }, 'car') 
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
    if IsPedInAnyVehicle(PlayerPedId()) then return end 
    if KeyPressedCD then return end 
    KeyPressedCD = true SetTimeout(1500, function() KeyPressedCD =false  end)
    if next(MyGangData.helispawn) then 
        local Distance , Key = GetNeaestrCoordsValueInTable(MyGangData.helispawn)

        if Distance < 80.0 then 
            ESX.TriggerServerCallback('FMGangs:GetRankAccess', function(access)
                if access['heliANDBoat'] then
                    TriggerEvent('For5M:OpenGarage', PlayerData.gang.name, { x = MyGangData.helispawn[Key].coord.x , y = MyGangData.helispawn[Key].coord.y , z = MyGangData.helispawn[Key].coord.z , h = MyGangData.helispawn[Key].heading }, 'heli')  
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
    if IsPedInAnyVehicle(PlayerPedId()) then return end 
    if KeyPressedCD then return end 
    KeyPressedCD = true SetTimeout(1500, function() KeyPressedCD =false  end)
    if next(MyGangData.boatspawn) then 
        local Distance , Key = GetNeaestrCoordsValueInTable(MyGangData.boatspawn)
        if Distance < 80.0 then 
            ESX.TriggerServerCallback('FMGangs:GetRankAccess', function(access)
                if access['heliANDBoat'] then
                    TriggerEvent('For5M:OpenGarage', PlayerData.gang.name, { x = MyGangData.boatspawn[Key].coord.x , y = MyGangData.boatspawn[Key].coord.y , z = MyGangData.boatspawn[Key].coord.z , h = MyGangData.boatspawn[Key].heading }, 'boat') 
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
        ESX.TriggerServerCallback('For5mG-garage:getvehiclebyplate', function(gangveh) 
            if gangveh then 
                TriggerServerEvent('For5M:SendLog', GetPlayerServerId(PlayerId()) , 'Garage' , 'stored Vehicle '  )
                TriggerServerEvent('For5mG-garage:stored', GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId())) , 1)
                ESX.Game.DeleteVehicle(Vehicle)
            else 
                Notifiaction(' This Vehicle Its Not For This Gang  !!')
            end 
        end, GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId())))
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
