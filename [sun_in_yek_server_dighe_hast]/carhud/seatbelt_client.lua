-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local isUiOpen = false
local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local vehData =  {active = false}

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

IsCar = function(veh)
    local vc = GetVehicleClass(veh)
    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 15 and vc <= 20)
end

Fwv = function (entity)
    local hr = GetEntityHeading(entity) + 90.0
    if hr < 0.0 then hr = 360.0 + hr end
    hr = hr * 0.0174533
    return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end


AddEventHandler("onKeyDown", function(key)
    if not vehData.active then
        return
    end
    if key == "l" and ESX.GetPlayerData()['IsDead'] ~= 1 then
        beltOn = not beltOn

        if beltOn then
            ESX.notification('inform', '!کمربند شما بسته شد')
            TriggerEvent('InteractSound_CL:PlayOnOne','buckle', 0.9)

            SendNUIMessage({
                displayWindow = 'false'
            })
            isUiOpen = true
        else
            speedBuffer  = {}
            velBuffer    = {}
            ESX.notification('inform', '!کمربند شما باز شد')
            TriggerEvent('InteractSound_CL:PlayOnOne','unbuckle', 0.9)

            SendNUIMessage({
                displayWindow = 'true'
            })
            isUiOpen = true
        end

    elseif key == "f" then
        if vehData.active and beltOn then
            DisableControlAction(0, 75, true)  -- Disable exit vehicle when stop
            DisableControlAction(27, 75, true) -- Disable exit vehicle when Driving
        end
    end
end)


RegisterNetEvent('seatbelt:beband')
AddEventHandler('seatbelt:beband', function(status)
    beltOn = true
    isUiOpen = true
    SendNUIMessage({
        displayWindow = 'false'
    })
    ESX.notification('inform', '!کمربند شما بسته شد')
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.9, 'buckle', 0.9)
end)



local blackList = {
    [GetHashKey("RIOT")]       = {smaller = -140, bigger = 100, passengerRestrict = true, fullRestrict = true},
    [GetHashKey("INSURGENT2")] = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("ZENTORNO")]   = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("VAGNER")]     = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("VISIONE")]    = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("TYRUS")]      = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("TYRANT")]     = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("TIGON")]      = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("TAIPAN")]     = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("T20")]        = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("SC1")]        = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("REAPER")]     = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("PROTOTIPO")]  = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("PFISTER811")] = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("LE7B")]       = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("KRIEGER")]    = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("INFERNUS")]   = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("ENTITYXF")]   = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("ENTITY2")]    = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("BULLET")]     = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("AUTARCH")]    = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("RMODLP750")]  = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("RMODLP770")]  = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("CHIRON17")]   = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("RMODLP750")]  = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("SHEAVA")]     = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("hellion")]    = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("rmodjesko")]  = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("laf")]        = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("rmodsian")]   = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("amgone")]     = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("fxxk")]       = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("p1")]         = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("eyd")]        = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("divo")]       = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("16ss")]       = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("mvisiongt")]  = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("918")]        = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("bc")]         = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("IKX3REZVANI")]= {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("lp670sv")]    = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("vip101")]     = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("zn20")]       = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("gt17")]       = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("rmodsvj")]    = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("DBcyber")]    = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("fer488beast")]  = {smaller = -140, bigger = 100, passengerRestrict = false },
    [GetHashKey("GODzPANDEMC8")] = {smaller = -140, bigger = 100, passengerRestrict = false },


    -- [GetHashKey("oldpeykan")]  = {smaller = -140, bigger = 100, passengerRestrict = false },
    -- [GetHashKey("bnz")]        = {smaller = -140, bigger = 100, passengerRestrict = false },
}



AddEventHandler('enterVehicle', function(vehicle)
    if IsCar(vehicle) then
        vehData =  {active = true, vehicle = vehicle}
        local ped = PlayerPedId()
        CreateThread(function()
            while vehData.active do
                Wait(0)
                if vehData.active and (vehData.blacklist and vehData.lookingBack) then
                    DisableControlAction(2, 25, true) -- Aim
                    DisableControlAction(2,24, true) -- INPUT_ATTACK
                    DisableControlAction(0,69, true) -- INPUT_VEH_ATTACK
                    DisableControlAction(0,70, true) -- INPUT_VEH_ATTACK2
                    DisableControlAction(0,68, true) -- Attack in car 3
                    DisableControlAction(0,66, true) -- Attack in car 4
                    DisableControlAction(0,67, true) -- Attack in car 5
                    DisableControlAction(2,257, true) -- Attack 2
                    DisableControlAction(0,92, true) -- INPUT_VEH_PASSENGER_ATTACK
                    DisableControlAction(0,114, true) -- INPUT_VEH_FLY_ATTACK
                    DisableControlAction(0,142, true)
                    DisableControlAction(0,257, true) -- INPUT_ATTACK2
                    DisableControlAction(0,331, true) -- INPUT_VEH_FLY_ATTACK2
                elseif beltOn then
                    DisableControlAction(0, 75, true)
                else
                    Wait(100)
                end
            end
        end)
    
        CreateThread(function()
            while vehData.active do
                Wait(500)
                local car = vehicle
                local isBlackList = blackList[GetEntityModel(car)] or {smaller = -140, bigger = 100, passengerRestrict = false }
                if IsCar(car) then
                    vehData.ped = ped
                    vehData.vehicle = car
                    vehData.blacklist = isBlackList
        
                    if vehData.blacklist then
        
                        if vehData.blacklist.passengerRestrict and GetPedInVehicleSeat(car, 0) == ped then
                            local camHeading = GetGameplayCamRelativeHeading()
                            if camHeading < vehData.blacklist.smaller or camHeading > vehData.blacklist.bigger or vehData.blacklist.fullRestrict then
                                vehData.lookingBack = true
                            else
                                vehData.lookingBack = false
                            end
                        elseif not vehData.blacklist.passengerRestrict or vehData.blacklist.fullRestrict then
                            local camHeading = GetGameplayCamRelativeHeading()
                            if camHeading < vehData.blacklist.smaller or camHeading > vehData.blacklist.bigger or vehData.blacklist.fullRestrict then
                                vehData.lookingBack = true
                            else
                                vehData.lookingBack = false
                            end
                        end
        
                    end
                else
                    vehData = {active = false}
                end
            end
        end)

        Citizen.CreateThread(function()
            while vehData.active do
                local speed = GetEntitySpeed(vehicle);
                if not beltOn and IsPedInAnyVehicle(ped, false) and (speed * 3.6) > 100 then
                    TriggerEvent('InteractSound_CL:PlayOnOne', 'seatbeltalarm', 0.5)
                    Wait(20000)
                end
                Wait(5000)
            end
        end)

        Citizen.CreateThread(function()
            while vehData.active do
                Wait(10)
                if isUiOpen == false then
                    SendNUIMessage({
                        displayWindow = 'true'
                    })
                    isUiOpen = true
                end
                if not beltOn then
                    speedBuffer[2] = speedBuffer[1]
                    speedBuffer[1] = GetEntitySpeed(vehData.vehicle)
                    if speedBuffer[2] ~= nil
                        and GetEntitySpeedVector(vehData.vehicle, true).y > 1.0
                        and speedBuffer[1] > 19.25
                        and (speedBuffer[2] - speedBuffer[1]) > (speedBuffer[1] * 0.255) then

                        local co = GetEntityCoords(vehData.ped)
                        local fw = Fwv(vehData.ped)
                        ESX.SetEntityCoords(vehData.ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
                        SetEntityVelocity(vehData.ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
                        Citizen.Wait(1)
                        exports['suncore']:canRagdoll(true, 1000)
                        SetPedToRagdoll(vehData.ped, 1000, 1000, 0, 0, 0, 0)
                    end

                    velBuffer[2] = velBuffer[1]
                    velBuffer[1] = GetEntityVelocity(vehData.vehicle)
                else
                    Citizen.Wait(500)
                end
            end
            if isUiOpen then
                SendNUIMessage({
                    displayWindow = 'false'
                })
                isUiOpen = false
            end
        end)
    end
end)

AddEventHandler('exitVehicle', function()
    beltOn = false
    speedBuffer[1], speedBuffer[2] = 0.0, 0.0
    vehData = {active = false}
end)