-- ============================================================
-- Unique_Hud / client / seatbelt.lua  (از carhud/seatbelt_client.lua سانست ادغام شد)
-- ============================================================
-- فیکس نسبت به نسخه‌ی اصلی سانست:
-- - pNotify نصب نیست روی این سرور → با ESX.ShowNotification (بومی خودتون)
--   جایگزین شد. بقیه (InteractSound_SV/CL، onKeyDown، صداهای buckle/unbuckle/
--   seatbeltalarm) عیناً با ریسورس‌های موجود خودتون (interact_sound،
--   ScriptPack/KeyManager.lua) چک و تأیید شد که سازگاره، چیزی عوض نشده.

local isUiOpen = false
local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false
local vehData =  {active = false}

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

Citizen.CreateThread(function()
  while true do
  Citizen.Wait(10)

    if vehData.active then
      wasInCar = true
      if isUiOpen == false and not IsPlayerDead(PlayerId()) then
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
            -- ✅ فیکس شد: ESX.SetEntityCoords تو essentialmode شما وجود نداره؛
            -- مستقیم از نیتیو خودِ بازی استفاده میشه
            SetEntityCoords(vehData.ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true, false)
            SetEntityVelocity(vehData.ped, velBuffer[2].x, velBuffer[2].y, velBuffer[2].z)
            Citizen.Wait(1)
            SetPedToRagdoll(vehData.ped, 1000, 1000, 0, 0, 0, 0)
        end

        velBuffer[2] = velBuffer[1]
        velBuffer[1] = GetEntityVelocity(vehData.vehicle)
      else
        Citizen.Wait(500)
      end

  elseif wasInCar then
    wasInCar = false
    beltOn = false
    speedBuffer[1], speedBuffer[2] = 0.0, 0.0
      if isUiOpen then
        SendNUIMessage({
          displayWindow = 'false'
        })
        isUiOpen = false
      end
  else
    Citizen.Wait(500)
  end

end
end)

AddEventHandler("onKeyDown", function(key)
if not vehData.active then
  return
end

if key == "l" and not IsPedDeadOrDying(PlayerPedId(), true) then
  beltOn = not beltOn

  if beltOn then
    ESX.ShowNotification('کمربند شما بسته شد!')
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.9, 'buckle', 0.9)

    SendNUIMessage({
      displayWindow = 'false'
      })
    isUiOpen = true
  else
    speedBuffer  = {}
    velBuffer    = {}
    ESX.ShowNotification('کمربند شما باز شد!')
    TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.9, 'unbuckle', 0.9)

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
  ESX.ShowNotification('کمربند شما بسته شد!')
  TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 0.9, 'buckle', 0.9)
end)

Citizen.CreateThread(function()
 while true do
  local player = GetPlayerPed(-1)
  local speed = GetEntitySpeed(player);
  local kmh = speed * 3.6;
  local car = GetVehiclePedIsIn(GetPlayerPed(-1))
  if beltOn == false and IsPedInAnyVehicle(PlayerPedId(), false) and kmh > 100 and car ~= 0 and (wasInCar or IsCar(car)) then
  TriggerEvent('InteractSound_CL:PlayOnOne','seatbeltalarm', 0.5)
   Wait(20000)
  end
  Wait(5000)
 end
end)

-- ماشین‌هایی که سوارشون کسی نمی‌تونه رو به عقب بدون کمربند تیراندازی کنه
-- (ضد drive-by از ماشین‌های خاص). عیناً از سانست نگه داشته شد.
local blackList = {
  [GetHashKey("RIOT")] = {smaller = -145, bigger = 100, passengerRestrict = true},
  [GetHashKey("INSURGENT2")] = {smaller = -150, bigger = 100, passengerRestrict = false},
  [GetHashKey("ZENTORNO")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("VAGNER")] = {smaller = -140, bigger = 170, passengerRestrict = false },
  [GetHashKey("VISIONE")] = {smaller = -165, bigger = 120, passengerRestrict = false },
  [GetHashKey("TYRUS")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("TYRANT")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("TIGON")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("TAIPAN")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("T20")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("SC1")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("REAPER")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("PROTOTIPO")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("PFISTER811")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("LE7B")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("KRIEGER")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("INFERNUS")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("ENTITYXF")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("ENTITY2")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("BULLET")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("AUTARCH")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("RMODLP750")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("RMODLP770")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("CHIRON17")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("SHEAVA")] = {smaller = -150, bigger = 100, passengerRestrict = false},
  [GetHashKey("hellion")] = {smaller = -150, bigger = 100, passengerRestrict = false},
  [GetHashKey("eyd")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("divo")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("16ss")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("mvisiongt")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("918")] = {smaller = -150, bigger = 100, passengerRestrict = false },
  [GetHashKey("hummer")] = {smaller = -150, bigger = 100, passengerRestrict = false },
}


Citizen.CreateThread(function()
  while true do
      Citizen.Wait(500)
      local ped = PlayerPedId()
      local car = GetVehiclePedIsIn(ped)
      local isBlackList = blackList[GetEntityModel(car)]

      if car ~= 0 and IsCar(car) then
        vehData.ped = ped
        vehData.vehicle = car
        vehData.blacklist = isBlackList

        if vehData.blacklist then

          if vehData.blacklist.passengerRestrict and GetPedInVehicleSeat(car, 0) == ped then
            local camHeading = GetGameplayCamRelativeHeading()
            if camHeading < vehData.blacklist.smaller or camHeading > vehData.blacklist.bigger then
              vehData.lookingBack = true
            else
              vehData.lookingBack = false
            end
          elseif not vehData.blacklist.passengerRestrict then
            local camHeading = GetGameplayCamRelativeHeading()
            if camHeading < vehData.blacklist.smaller or camHeading > vehData.blacklist.bigger then
              vehData.lookingBack = true
            else
              vehData.lookingBack = false
            end
          end

        end

        vehData.active = true

      else
        vehData = {active = false}
      end

  end
end)

Citizen.CreateThread(function()
  while true do
    if vehData.active and (vehData.blacklist and vehData.lookingBack) then
      Citizen.Wait(10)
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
    else
      Citizen.Wait(500)
    end
  end
end)
