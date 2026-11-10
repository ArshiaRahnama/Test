-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil
PlayerData = {}
local InRealWorld = true
local near = {active = false}
local canopen = false
local dis = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
    for k , v in ipairs(Config.coords) do
        ESX.RegisterPoint(v.coords,2,{
            Color = {R = 51,G = 204,B = 25,A = 255},
            DrawDistance = 5,
            Radius = 1.5,
            Type = 21,
            worldCheck = false,
        },{
            Notification = nil,
            DrawText = 'Dokme ~INPUT_CONTEXT~ jahat baz kardan menu portal',
            DrawTextRadius = 4,
            DrawTextCoords = v.coords,
            Key = 'e',
            CB = function()
                if not dis then
                    openmenu()
                end
            end,
        },{
            In = function()
                near = {active = true,key = k}
            end,
            Out = function()
                near = {active = false}
                ESX.UI.Menu.CloseAll()
            end,
        })
    end
end)

AddEventHandler('onKeyDown',function(key)
    if key == "e" and near.active then
        if near.key and canopen and not dis and (ESX.PlayerData.World == 0 or ESX.PlayerData.World == 90) then
            openmenu()
        end
    end
end)

local back = false

function openmenu()
    if ESX.PlayerData.World == 90 then
        local elements = {}
        table.insert(elements,{label = "Back to real world", value = "back"})
        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'buy2',
            {
            title    = 'Portal menu',
            align    = 'top-left',
            elements = elements,
            },
            function(data, menu)
                menu.close()
                if data.current.value == "back" then
                    local head = Config.coords[near.key].head
                    back = true
                    SetEntityHeading(PlayerPedId(),head)
                    TriggerServerEvent('portal:change','key')
                end
            end,
        function(data, menu)
            menu.close()
        end)
        return
    end
    ESX.TriggerServerCallback('portal:getcoupon',function(data)
        if data == 0 then
            local elements = {}
            table.insert(elements,{label = "❌Shoma dastresi be portal nadarid❌" , value = "kir"})
            table.insert(elements,{label = "💳Kharid dastresi💳" , value = "buy"})
            ESX.UI.Menu.Open(
                'default', GetCurrentResourceName(), 'menu',
                {
                title    = 'Portal menu',
                align    = 'top-left',
                elements = elements,
                },
                function(data, menu)         
                    if data.current.value == "buy" then 
                        menu.close()
                        local elements = {}
                        table.insert(elements,{label = "----- Info ----" , value = "kir"})
                        table.insert(elements,{label = "Tedad coupon : 15x" , value = "kir"})
                        table.insert(elements,{label = "Ravesh kharid khod ra entekhab konid :" , value = "kir"})
                        table.insert(elements,{label = "50x TC" , value = "tc"})
                        table.insert(elements,{label = "1x Token" , value = "token"})
                        table.insert(elements,{label = "1M $" , value = "ic"})
                        ESX.UI.Menu.Open(
                            'default', GetCurrentResourceName(), 'buy',
                            {
                            title    = 'Portal menu',
                            align    = 'top-left',
                            elements = elements,
                            },
                            function(data2, menu2)
                                if data2.current.value ~= "kir" then 
                                    menu2.close()
                                    local elements = {}
                                    table.insert(elements,{label = "Aya az kharid khod motmaeen hastid?" , value = "kir"})
                                    table.insert(elements,{label = "🤑Bale🤑" , value = "yes"})
                                    table.insert(elements,{label = "🗙Kheir🗙" , value = "no"})
                                    ESX.UI.Menu.Open(
                                        'default', GetCurrentResourceName(), 'buy2',
                                        {
                                        title    = 'Portal menu',
                                        align    = 'top-left',
                                        elements = elements,
                                        },
                                        function(data3, menu3)
                                            if data3.current.value == "yes" then    
                                                menu3.close()
                                                TriggerServerEvent('portal:buy',data2.current.value)
                                            elseif data3.current.value == "no" then      
                                                menu3.close()
                                            end
                                        end,
                                    function(data3, menu3)
                                            menu3.close()
                                    end)
                                end
                            end,
                        function(data2, menu2)
                                menu2.close()
                        end)
                    end
                end,
            function(data, menu)
                    menu.close()
            end)
        else
            ESX.TriggerServerCallback('portal:getservers',function(sv,world,coupon)
                if data then
                    if world == 0 then
                        elements = {}
                        table.insert(elements,{label = "Coupon left : " .. coupon, value = "kir"})
                        for k , v in pairs(sv) do
                            table.insert(elements,{label = "World " .. k , value = k })
                        end
                        ESX.UI.Menu.Open(
                            'default', GetCurrentResourceName(), 'buy2',
                            {
                            title    = 'Portal menu',
                            align    = 'top-left',
                            elements = elements,
                            },
                            function(data, menu)
                                if data.current.value ~= "kir" then
                                    menu.close()
                                    ESX.TriggerServerCallback('portal:getservers',function(sv,world)
                                        if world == 0 then
                                            if sv[data.current.value] then
                                                if LocalPlayer.state.adrenaline then
                                                    ESX.Alert('', 'Shoma nemitavanid ba adrenaline be portal beravid', 5000, 'error')
                                                else
                                                    local head = Config.coords[near.key].head
                                                    SetEntityHeading(PlayerPedId(),head)
                                                    TriggerServerEvent('portal:change',data.current.value)
                                                end
                                            end
                                        end
                                    end)
                                end
                            end,
                        function(data, menu)
                            menu.close()
                        end)
                    end
                end
            end)
        end 
    end)
end


RegisterNetEvent('portal:anim')
AddEventHandler('portal:anim',function(real)
    InRealWorld = real
    if not InRealWorld then
        TriggerEvent('esx:updatecoords',false)
        Citizen.CreateThread(function()
            while not InRealWorld do
                Wait(1000)
                if near.active then
                    local coords = Config.coords[near.key].coords
                    local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),coords)
                    if distance > 10 then
                        exports.essentialmode:disableallControl(true) 
                    else
                        exports.essentialmode:disableallControl(false) 
                    end
                else
                    exports.essentialmode:disableallControl(true)
                end
            end
        end)
        Citizen.CreateThread(function()
            while not InRealWorld do
                Wait(0)
                DisableControlAction(0,38,true)
            end
        end)
    else
        TriggerEvent('esx:updatecoords',true)
    end

    local loop = true
    SetTimeout(20000,function()
        loop = false
    end)
    SetTimeout(5000,function()             
        TriggerEvent('InteractSound_CL:PlayOnOne','portal',0.2)
    end)
    dis = true
    exports.essentialmode:disableallControl(true)                           
    Citizen.CreateThread(function()
        local aaa = 0.0
        exports['sun-animmenu']:PlayEmote("mindcontrol2",true)
        --ExecuteCommand('e mindcontrol2')
        TriggerEvent("dpemote:enable",false)
        while loop do
            Wait(200)
            aaa = aaa + 0.01
            StartParticleFxNonLoopedOnEntity('fire_script_petrol_trail_flames',PlayerPedId(),1.0,1.0,1.0,1.0,1.0,1.0,5,1.0,1.0,1.0)
            ESX.UI.Menu.CloseAll()
        end
    end)
    TriggerEvent("mythic_progbar:client:progress", {
    name = "process_robbery",
    duration = 20000,
    label = "",
    useWhileDead = false,
    canCancel = false,
    controlDisables = {
    disableMovement = true,
    disableCarMovement = true,
    disableMouse = false,
    disableCombat = true,
    }
    }, function(status)
        if not status then
            Citizen.CreateThread(function()
                local aaa = 1.0
                local loop2 = true
                SetTimeout(20000,function()
                    loop2 = false
                end)
                while loop2 do
                    Wait(200)
                    aaa = aaa - 0.01
                    ESX.UI.Menu.CloseAll()
                end
                SetEntityAlpha(PlayerPedId(), 1000, false)
            end)                        
            ClearPedTasksImmediately(PlayerPedId())    
            exports.essentialmode:disableallControl(false)
            TriggerEvent("dpemote:enable",true)
            dis = false
        end
    end)  
end)

RegisterNetEvent('esx:changeworld')
AddEventHandler('esx:changeworld',function(world)
	ESX.PlayerData.World = world
	if world == 0 then
        TriggerEvent('menu:break')
	end
    if back then
        back = false
        Wait(3000)
        ESX.Game.Teleport(PlayerPedId(), Config.coords[1].coords)
    end
end)