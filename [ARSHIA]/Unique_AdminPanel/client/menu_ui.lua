aduty = false
local OffDuty = nil
local infinite_stamina = false

invisibility = invisibility or false
invisibility2 = invisibility2 or false
local noRagDoll = false
noclip = false
superjump = false
fastrun = false
blipdool = false
PlayersCache = {}
lastspec = 0
godmode = false

RegisterNetEvent('Admin_Menu:GetGodeModes')
AddEventHandler('Admin_Menu:GetGodeModes', function(Toggle)
  godmode = Toggle
end)

RegisterNetEvent('esx_aduty:ChangeMenuStatus')
AddEventHandler('esx_aduty:ChangeMenuStatus', function(boolean)
  CloseAdminMenu()
  aduty = boolean
  if aduty and OffDuty == nil then
    AdminM()
  else
    OffDuty = true
  end
  if aduty then
    Infinity()
  end
end)

-- F4 toggles the admin menu (MenuV version - see client/menuv_ui.lua).
-- Closed -> opens the main menu. Open anywhere (even deep in a submenu) ->
-- closes everything in one step.
AddEventHandler("onKeyDown", function(key)
  if key ~= "f4" or not aduty then return end
  ToggleAdminMenu()
end)

function AdminM()
  ESX.TriggerServerCallback('Admin_Menu:GetActivePlayers', function(players)
    PlayersCache = {}
    PlayersCache = players
  end)
end

function GetLast(table)
  local last = 0
  for c in pairs(table) do
    if c > last then
      last = c
    end
  end
  return last
end

function Infinity()
  Citizen.CreateThread(function()
    while aduty do
      PlayersCache = {}
      ESX.TriggerServerCallback('Admin_Menu:GetActivePlayers', function(players)
        PlayersCache = players
      end)
      Citizen.Wait(5000)
    end
  end)
end

RegisterNetEvent('AdminMenu:SlapPlayers')
AddEventHandler('AdminMenu:SlapPlayers', function()
  ApplyForceToEntity(PlayerPedId(), 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, true, true, true, true, true)
end)

function invisibility2th2()
  Citizen.CreateThread(function()
    while invisibility2 do
      SetEntityVisible(PlayerPedId(), false, false)
      SetEntityLocallyVisible(PlayerPedId(), true)
      SetEntityAlpha(PlayerPedId(), 150)
      Citizen.Wait(1)
    end
    SetEntityVisible(PlayerPedId(), true, true)
    SetEntityAlpha(PlayerPedId(), 255)
  end)
end

-- (old immediate-mode render loop removed: replaced by client/menuv_ui.lua)

sp = 0
RegisterNetEvent('Admin_Menu:spec')
AddEventHandler('Admin_Menu:spec', function(id)
  if id and sp ~= id then
    sp = id
    if not spectate(id) then
      drawNotification("~r~Fard mored nazar online nist.")
      sp = 0
      return
    end
    TriggerEvent("Admin_Menu:SpectMenus", true)
  else
    sp = 0
    resetNormalCamera()
    TriggerEvent("Admin_Menu:SpectMenus", false)
  end
end)

function SuperJumpThread()
  Citizen.CreateThread(function()
      while superjump do
          Citizen.Wait(1)
          SetSuperJumpThisFrame(PlayerId())
      end
  end)
end

function FastRunThread()
  Citizen.CreateThread(function()
      while fastrun do
          Citizen.Wait(100)
          SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
          SetPedMoveRateOverride(PlayerPedId(), 5.0)
      end
      SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
      SetPedMoveRateOverride(PlayerPedId(), 0.0)
  end)
end

local blips = {}
function BlipThread()
    Citizen.CreateThread(function()
        while blipdool do
            Citizen.Wait(100)
            for src, blip in pairs(blips) do
                if not DoesEntityExist(GetPlayerPed(src)) then
                    RemoveBlip(blip)
                    blips[src] = nil
                else
                    local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(src, 0.0, 0.0, 0.0))
                    local head = GetEntityHeading(GetPlayerPed(src))
                    SetBlipCoords(blip, coords.x, coords.y, coords.z)
                    SetBlipRotation(blip, math.ceil(head))
                    SetBlipCategory(blip, 7)
                    SetBlipScale(blip, 0.7)
                end
            end
            for id, src in pairs(GetActivePlayers()) do
                src = tonumber(src)
                if DoesEntityExist(GetPlayerPed(src)) and not blips[src] and src ~= PlayerId() then
                    local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(src, 0.0, 0.0, 0.0))
                    local head = GetEntityHeading(GetPlayerPed(src))
                    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
                    SetBlipSprite(blip, 1)
                    ShowHeadingIndicatorOnBlip(blip, true)
                    SetBlipRotation(blip, math.ceil(head))
                    SetBlipScale(blip, 0.7)
                    SetBlipCategory(blip, 7)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentSubstringPlayerName(GetPlayerName(src))
                    EndTextCommandSetBlipName(blip)
                    blips[src] = blip
                end
            end
        end
        for src, blip in pairs(blips) do
            RemoveBlip(blip)
            blips[src] = nil
        end
    end)
end