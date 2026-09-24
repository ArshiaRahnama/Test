GetESX = function()
  while not ESX do
    TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
    Wait(1)
  end
  while not ESX.IsPlayerLoaded() do Wait(1); end
end

GetFramework = function()
  if HousingConfig.UsingESX then
    GetESX()
  else
    -- NON-ESX USERS ADD HERE
  end
end

GetPlayerData = function()
  if HousingConfig.UsingESX then
    return ESX.GetPlayerData()
  else
    -- NON-ESX USERS ADD HERE
  end
end

SetPlayerData = function(data)
  PlayerData = data
end

SetPlayerJob = function(job)
  PlayerData = (PlayerData or GetPlayerData())
  if type(PlayerData) ~= "table" then
    --print("SetPlayerJob() Failed")
  else
    PlayerData.job = job
  end
end

GetPlayerCash = function()
  PlayerData = GetPlayerData()
  return (PlayerData and PlayerData.money) or 0
end

GetPlayerBank = function()
  PlayerData = GetPlayerData()
  -- NOTE: this server's essentialmode does not include "bank" in the
  -- client-side esx:playerLoaded payload, so PlayerData.bank is never
  -- actually populated client-side. This is only used as a client-side
  -- pre-check anyway (money is always deducted/validated server-side),
  -- so falling back to 0 here is safe rather than crashing.
  return (PlayerData and PlayerData.bank) or 0
end

CheckForLockpick = function()
    PlayerData = GetPlayerData()
    for k,v in pairs(PlayerData.inventory) do
      if v.name == HousingConfig.LockpickItem then
        return (v.count and v.count > 0 and true or false)
      end
    end
    return false
end

GetPlayerJobName = function()
    return PlayerData.job.name
end

GetPlayerJobRank = function()
  if HousingConfig.UsingESX then
    PlayerData = GetPlayerData()
    return PlayerData.job.grade
  else
    -- NON-ESX USERS ADD HERE
  end
end

GetPlayerIdentifier = function()
  if HousingConfig.UsingESX then
    if HousingConfig.UsingKashacters then 
      return KashIdentifier
    else
      PlayerData = GetPlayerData()
      return PlayerData.identifier
    end
  else
    -- NON-ESX USERS ADD HERE
  end
end

CanPlayerAfford = function(value)
  --print("Can player afford?",GetPlayerCash(),value)
  if GetPlayerCash() >= value then
    return true
  elseif GetPlayerBank() >= value then
    return true
  else
    return false
  end
end

GetNearbyPlayers = function(pos,radius)
  if HousingConfig.UsingESX then
    return ESX.Game.GetPlayersInArea((pos or GetEntityCoords(GetPlayerPed(-1))),(radius or 20.0))
  else
    -- NON-ESX USERS ADD HERE
  end
end

NotifyJob = function(job,msg,pos)
  local jobName = GetPlayerJobName()
  if jobName and jobName == job then
    if pos then
      Citizen.CreateThread(function()
        local start = GetGameTimer()
        ShowNotification(Labels["InteractDrawText"]..Labels["TrackMessage"].."\n"..msg)
        while GetGameTimer() - start < 10000 do
          if IsControlJustPressed(0,47) then
            SetNewWaypoint(pos.x,pos.y)
            return
          end
          Wait(1)
        end
      end)
    else
      ShowNotification(msg)
    end
  end
end

RegisterNetEvent("Allhousing:NotifyJob")
AddEventHandler("Allhousing:NotifyJob",NotifyJob)

RegisterNetEvent("esx:updatePlayerData")
AddEventHandler("esx:updatePlayerData",SetPlayerData)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob",SetPlayerJob)