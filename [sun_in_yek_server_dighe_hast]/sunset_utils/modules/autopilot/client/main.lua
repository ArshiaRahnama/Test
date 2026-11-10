-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local speed = 2000.0                  -- GetVehicleModelMaxSpeed(model) / 2 -- vehicle's speed

local access = {
    [GetHashKey("btaxi")] = true,
    [GetHashKey("taxi1")] = true,
    [GetHashKey("ptaxi")] = true,
    -- new car shop vip
    [GetHashKey("rmodmustang")] = true,
    [GetHashKey("urus")] = true,
    [GetHashKey("i8")] = true,
    [GetHashKey("i82")] = true,
    [GetHashKey("lex")] = true,
    [GetHashKey("bmwg07")] = true,
    [GetHashKey("19raptor")] = true,
}

local autopilotActive = false
local blipX = 0.0
local blipY = 0.0
local blipZ = 0.0
RegisterNetEvent("autopilot:start")
AddEventHandler("autopilot:start", function(source)
    local player = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(player,false)
    local model = GetEntityModel(vehicle)
    local displaytext = GetDisplayNameFromVehicleModel(model)
    if vehicle == 0 then return ESX.ShowNotification('Shoma savar hich mashini nistid') end
    local plate = GetVehicleNumberPlateText(vehicle)
    local blip = GetFirstBlipInfoId(8)
    local choped = Entity(vehicle).state.choped
    if choped then
        return ESX.Alert('','Baraye estefade az auto pilot niaz be engine darid!', 7000, 'error')
    end
    ESX.TriggerServerCallback("carlock:getveh",function(data)
        local canuse = false
        if data == nil then
            if access[model] then
                canuse = true
            end
        else
            if data.ap == 1 or access[model] then
                canuse = true
            end
        end
        if canuse then
            if autopilotActive then return ESX.ShowNotification('Auto pilot dar hal hazer faal ast!') end
            if (blip ~= nil and blip ~= 0) then
                local coord = GetBlipCoords(blip)
                blipX = coord.x
                blipY = coord.y
                blipZ = coord.z
                TaskVehicleDriveToCoordLongrange(player, vehicle, blipX, blipY, blipZ, GetVehicleModelMaxSpeed(model), 447, 2.0)
                autopilotActive = true
                Citizen.CreateThread(function()
                    while autopilotActive do
                        Citizen.Wait(200)
                        local coords = GetEntityCoords(GetPlayerPed(-1))
                        local blip = GetFirstBlipInfoId(8)
                        local dist = Vdist(coords.x, coords.y, coords.z, blipX, blipY, coords.z)
                        if dist <= 10 then
                            local player = GetPlayerPed(-1)
                            local vehicle = GetVehiclePedIsIn(player,false)
                            ClearPedTasks(player)
                            SetVehicleForwardSpeed(vehicle,19.0)
                            Citizen.Wait(200)
                            SetVehicleForwardSpeed(vehicle,15.0)
                            Citizen.Wait(200)
                            SetVehicleForwardSpeed(vehicle,11.0)
                            Citizen.Wait(200)
                            SetVehicleForwardSpeed(vehicle,6.0)
                            Citizen.Wait(200)
                            SetVehicleForwardSpeed(vehicle,0.0)
                            ESX.ShowNotification("Shoma be maghasd residid")
                            autopilotActive = false
                        end
                    end
                end)

                Citizen.CreateThread(function()
                    while autopilotActive do
                        ESX.ShowHelpNotification("Dokme ~INPUT_MP_TEXT_CHAT_TEAM~ jahat cancel kardan auto pilot")
                        Citizen.Wait(10)
                    end
                end)

            else
                ESX.ShowNotification("Shoma hich makani ra dar gps pin nakardid")
            end
        else
            ESX.ShowNotification('in mashin ghabeliat auto pilot ra nadarad')
        end
    end,plate)
end)

AddEventHandler('onKeyDown',function(key)
    if key == "y" then
        if autopilotActive then
            ClearPedTasks(PlayerPedId())
            autopilotActive = false
        end
    end
end)

RegisterCommand("ap", function()
    TriggerEvent("autopilot:start")
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/ap', 'Auto pilot')
end)
