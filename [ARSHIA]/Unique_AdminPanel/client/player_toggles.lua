

-- godmode / invisibility / invisibility2 are declared once, safely, in
-- client/menu_ui.lua (using `X = X or false` so an already-set value
-- survives) - this file used to re-declare them unconditionally right
-- after, which happened to still net out to `false` either way (harmless)
-- but was a duplicate of the same default. Removed; both files now share
-- the one declaration.
local infStamina = false
local noRagDoll = false

local function RequestToggle(feature)
  TriggerServerEvent('Unique_AdminPanel:RequestToggle', feature)
end

RegisterNetEvent('Unique_AdminPanel:ApplyToggle')
AddEventHandler('Unique_AdminPanel:ApplyToggle', function(feature, newValue)
  if feature == 'godmode' then
    godmode = newValue



    SetPlayerInvincible(PlayerId(), godmode)
    SetEntityInvincible(PlayerPedId(), godmode)
    drawNotification(godmode and "~b~God mode activated" or "~r~God mode deactivated")

  elseif feature == 'infstamina' then
    infStamina = newValue
    ActiveStamina()
    drawNotification(infStamina and "~b~Infinite Stamina activated" or "~r~Infinite Stamina deactivated")

  elseif feature == 'invisibility' then
    invisibility = newValue
    SetEntityVisible(PlayerPedId(), not invisibility, 0)
    SetForcePedFootstepsTracks(invisibility)
    if invisibility then
      drawNotification("~b~Invisibility activated")
      TriggerServerEvent("Admin_Menu:SpectStatus", true)
    else
      drawNotification("~r~Invisibility deactivated")
      TriggerServerEvent("Admin_Menu:SpectStatus", false)
    end

  elseif feature == 'invisibility2' then
    invisibility2 = newValue
    if invisibility2 then
      drawNotification("~b~Invisibility activated")
      TriggerServerEvent("Admin_Menu:SpectStatus", true)
      SetEntityAlpha(PlayerPedId(), 160, false)
      SetEntityVisible(PlayerPedId(), true, false)
      invisibility2th2()
    else
      ResetEntityAlpha(PlayerPedId())
      SetEntityVisible(PlayerPedId(), true, true)
      drawNotification("~r~Invisibility deactivated")
      TriggerServerEvent("Admin_Menu:SpectStatus", false)
    end

  elseif feature == 'noragdoll' then
    noRagDoll = newValue
    SetPedCanRagdoll(PlayerPedId(), not noRagDoll)
    drawNotification(noRagDoll and "~b~No Rag Doll activated" or "~r~No Rag Doll deactivated")

  elseif feature == 'noclip' then
    IsNoclipActive = newValue
    noclip = newValue
    if IsNoclipActive then
      NoClipThread()
    end

  elseif feature == 'superjump' then
    superjump = newValue
    if superjump then SuperJumpThread() end

  elseif feature == 'fastrun' then
    fastrun = newValue
    if fastrun then FastRunThread() end

  elseif feature == 'blip' then
    blipdool = newValue
    if blipdool then BlipThread() end
  end
end)

function RequestGodmode() RequestToggle('godmode') end
function RequestInfStamina() RequestToggle('infstamina') end
function RequestInvisibility() RequestToggle('invisibility') end
function RequestInvisibility2() RequestToggle('invisibility2') end
function RequestNoRagDoll() RequestToggle('noragdoll') end
function RequestNoclip() RequestToggle('noclip') end
function RequestSuperjump() RequestToggle('superjump') end
function RequestFastrun() RequestToggle('fastrun') end
function RequestBlip() RequestToggle('blip') end

function ActiveStamina()
  Citizen.CreateThread(function()
    while infStamina and aduty do
      Citizen.Wait(0)
      RestorePlayerStamina(PlayerPedId(), 1.0)
    end
    infStamina = not aduty and false or infStamina
  end)
end

-- God mode set on us by an admin (Player Control > Toggle God Mode). Done here on
-- the client instead of with the server-side native, which could crash FXServer.
RegisterNetEvent('Unique_AdminPanel:ApplyTargetGodmode')
AddEventHandler('Unique_AdminPanel:ApplyTargetGodmode', function(state)
  SetPlayerInvincible(PlayerId(), state and true or false)
  SetEntityInvincible(PlayerPedId(), state and true or false)
end)
