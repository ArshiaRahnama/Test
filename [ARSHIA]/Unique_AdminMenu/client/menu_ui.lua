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
local show2 = false
PlayersCache = {}
lastspec = 0
godmode = false

RegisterNetEvent('Admin_Menu:GetGodeModes')
AddEventHandler('Admin_Menu:GetGodeModes', function(Toggle)
  godmode = Toggle
end)

RegisterNetEvent('esx_aduty:ChangeMenuStatus')
AddEventHandler('esx_aduty:ChangeMenuStatus', function(boolean)
  WarMenu.ForceCloseAll()
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

-- F4 toggles the admin menu. If we're already sitting at the top-level
-- 'main' menu, it closes fully. If we're closed, or deep inside a submenu,
-- it resets cleanly straight back to 'main' in one step. Previously this
-- called WarMenu.CloseMenu() (a two-step toggle meant for Backspace) and
-- then immediately reopened the menu, which could leave it flagged as
-- "about to close" - so the very next frame would silently close it again
-- right after opening (the open/close flicker). ForceCloseAll() closes
-- everything in one shot, so that can't happen anymore.
AddEventHandler("onKeyDown", function(key)
  if key ~= "f4" or not aduty then return end

  if WarMenu.CurrentMenu() == 'main' then
    WarMenu.ForceCloseAll()
  else
    WarMenu.ForceCloseAll()
    WarMenu.OpenMenu('main')
    AdminMenu()
  end
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

Citizen.CreateThread(function ()
  WarMenu.CreateMenu('main', 'Admin Menu')
  WarMenu.CreateSubMenu('spectate', 'main', 'Spectate Players')
  WarMenu.CreateSubMenu('teleport_player', 'main', 'Teleport to Spectated')
  WarMenu.CreateSubMenu('player_menu', 'main', 'My Abilities')
end)

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

function AdminMenu()
  local mOpen = false



  if WarMenu.IsMenuOpened('main') then
    mOpen = true

    -- Grouped so related tools sit together: player-facing tools first,
    -- then vehicle/world/server tools. Player Tools and Spectate Menu pull
    -- a fresh player list from the server the instant you open them, so
    -- the list always reflects who's actually online right now instead of
    -- whatever the last background refresh happened to catch.
    if WarMenu.MenuButton('» My Abilities', 'player_menu') then end
    if WarMenu.MenuButton('» Player Tools', 'select_target') then AdminM() end
    if WarMenu.MenuButton('» Spectate Menu', 'spectate') then AdminM() end
    WarMenu.MenuButton('» Teleport to Spectated', 'teleport_player')
    WarMenu.MenuButton('» Vehicle Tools', 'vehicle_tools')
    WarMenu.MenuButton('» World Tools', 'world_tools')
    WarMenu.MenuButton('» Server Tools', 'server_tools')

    WarMenu.Display()



  elseif WarMenu.IsMenuOpened('player_menu') then
    mOpen = true
    if WarMenu.CheckBox("Invis", invisibility, function(checked) end) then
      RequestInvisibility()
    elseif WarMenu.CheckBox("Invis2", invisibility2, function(checked) end) then
      RequestInvisibility2()
    elseif WarMenu.CheckBox("Player Blip", blipdool, function(checked) end) then
      RequestBlip()
    elseif WarMenu.CheckBox("superjump", superjump, function(checked) end) then
      RequestSuperjump()
    elseif WarMenu.CheckBox("Show ID 2", show2, function(checked) show2 = checked end) then
      ExecuteCommand('esp')
    elseif WarMenu.CheckBox("GodMode", godmode, function(checked) end) then
      RequestGodmode()
    elseif WarMenu.CheckBox("fast run", fastrun, function(checked) end) then
      RequestFastrun()
    elseif WarMenu.CheckBox("Noclip", noclip, function(checked) end) then
      RequestNoclip()
    end
    WarMenu.Display()



  elseif WarMenu.IsMenuOpened('spectate') then
    mOpen = true
    for i=1, GetLast(PlayersCache) do
      if PlayersCache[i] then
        if WarMenu.CheckBox("["..i.."] "..PlayersCache[i], spec[i], function(checked) spec[i] = checked end) then
          if spec[i] then
            spec[lastspec] = false
            lastspec = i
            spectate(lastspec)
          else
            lastspec = 0
            resetNormalCamera()
          end
        end
      end
    end
    WarMenu.Display()



  elseif WarMenu.IsMenuOpened('teleport_player') then
    mOpen = true
    if TargetSpectate then
      WarMenu.ForceCloseAll()
      teleportToPlayer(TargetSpectate)
      spec[TargetSpectate] = false
      InSpectatorMode = false
      lastspec = 0
      TargetSpectate = nil
    else
      drawNotification("~r~Spectate a player first (Spectate Menu), then use this to teleport to them.")
      WarMenu.OpenMenu('main')
    end
    WarMenu.Display()
  end
  if mOpen then
    SetTimeout(0, AdminMenu)
  end
end

sp = 0
RegisterNetEvent('Admin_Menu:spec')
AddEventHandler('Admin_Menu:spec', function(id)
  if id and sp ~= id then
    sp = id
    spectate(id)
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