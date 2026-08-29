local PlayerData = {}
local Data = {}
Config.GangLeveL[0] = 0
local ESX = nil
-------------------------------------------------------------------
-- FIX (SCRIPT ERROR: attempt to compare number with nil, at
-- client/level.lua - the same class of bug fixed server-side in
-- server/level.lua): Config.GangLeveL only has thresholds for levels
-- 1-10. Every direct Config.GangLeveL[Data.Level + 1] lookup below
-- returned nil once a gang was already at level 10 (max), and either
-- comparing against it or arithmetic on it crashed this file. This
-- helper caps at the max level's threshold instead of ever returning
-- nil, and every call site below now goes through it.
-------------------------------------------------------------------
local function NextThreshold(level)
  if level >= #Config.GangLeveL then
    return Config.GangLeveL[#Config.GangLeveL]
  end
  return Config.GangLeveL[level + 1]
end
CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.ESX, function(obj) ESX = obj end)
    Wait(500)
	end
	PlayerData = ESX.GetPlayerData()
  ESX.TriggerServerCallback('FMGangs:GetPlayerData', function(data) 
      PlayerData = data
      if PlayerData.gang.name ~= 'nogang' then
        SetLeveLOfMyGang()
      end 
      ShowXPBar()
  end)

end)
RegisterNetEvent(Config.DefaultEvents['playerLoaded'])
AddEventHandler(Config.DefaultEvents['playerLoaded'], function(xPlayer)
    PlayerData = xPlayer
    if PlayerData.gang.name ~= 'nogang' then
      SetLeveLOfMyGang()
    end
end)

RegisterNetEvent(Config.DefaultEvents['setGang'])
AddEventHandler(Config.DefaultEvents['setGang'], function(gang)
    PlayerData.gang = gang
    if PlayerData.gang.name ~= 'nogang' then
      SetLeveLOfMyGang() 
    end
end)
RegisterNetEvent('For5M:AddXPtoGang')
AddEventHandler('For5M:AddXPtoGang', function(AddedXP)
  ESX.TriggerServerCallback("FMGangs:MyGangLevel", function( Level , XP )
      Data.XP = math.floor(XP)
      Data.Level = math.floor(Level) 
      if Data.Level < #Config.GangLeveL and Data.XP + AddedXP >= NextThreshold(Data.Level) then
        repeat
          CreateRankBar(0, NextThreshold(Data.Level), Data.XP, NextThreshold(Data.Level), Data.Level)
          Data.Level = Data.Level + 1
          AddedXP = Data.XP + AddedXP - Config.GangLeveL[Data.Level]
          Data.XP = 0
          TriggerEvent("RankUpMessage", "Gang Rank Up Complete", 1000)
        until Data.Level >= #Config.GangLeveL or Data.XP + AddedXP < NextThreshold(Data.Level)
          if AddedXP > 0 then
          Data.XP = Data.XP + AddedXP
          end
          CreateRankBar(0, NextThreshold(Data.Level), 0, Data.XP, Data.Level)
      else
        CreateRankBar(0, NextThreshold(Data.Level), Data.XP, Data.XP + AddedXP, Data.Level)
        Data.XP = Data.XP + AddedXP
      end
  end)
end)

function ShowXPBar()
    AddEventHandler('onKeyDown', function(key)
        if key == 'home' and  PlayerData.gang.name ~= 'nogang' then
            ESX.TriggerServerCallback("FMGangs:MyGangLevel", function( Level , XP )
                Data.XP = math.floor(XP)
                Data.Level = math.floor(Level) 
                CreateRankBar(0, NextThreshold(Data.Level), Data.XP, Data.XP, Data.Level)
            end)
        end
    end)
end

function CreateRankBar(XP_StartLimit_RankBar, XP_EndLimit_RankBar, playersPreviousXP, playersCurrentXP, CurrentPlayerLevel, TakingAwayXP)
    RankBarColor = TakingAwayXP and 6 or 116
    if not HasHudScaleformLoaded(19) then
          RequestHudScaleform(19)
      while not HasHudScaleformLoaded(19) do
        Wait(1)
      end
    end
      BeginScaleformMovieMethodHudComponent(19, "SET_COLOUR")
      PushScaleformMovieFunctionParameterInt(RankBarColor)
      EndScaleformMovieMethodReturn()
      BeginScaleformMovieMethodHudComponent(19, "SET_RANK_SCORES")
      PushScaleformMovieFunctionParameterInt(XP_StartLimit_RankBar)
      PushScaleformMovieFunctionParameterInt(XP_EndLimit_RankBar)
      PushScaleformMovieFunctionParameterInt(playersPreviousXP)
      PushScaleformMovieFunctionParameterInt(playersCurrentXP)
      PushScaleformMovieFunctionParameterInt(CurrentPlayerLevel)
      PushScaleformMovieFunctionParameterInt(100)
      EndScaleformMovieMethodReturn()
end

RegisterNetEvent('RankUpMessage')
AddEventHandler('RankUpMessage', function(MsgText, setCounter)
	local scaleform = RequestScaleformMovie("mp_big_message_freemode")
	while not HasScaleformMovieLoaded(scaleform) do
		Wait(0)
	end

	BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	BeginTextComponent("STRING")
	AddTextComponentString(MsgText)
	EndTextComponent()
	PopScaleformMovieFunctionVoid()	

	local counter = 0
	local maxCounter = (setCounter or 200)
	while counter < maxCounter do
		counter = counter + 1
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		Wait(0)
	end
end)
function SetLeveLOfMyGang()
  ESX.TriggerServerCallback("FMGangs:MyGangLevel", function( Level , XP )
      Data.XP = math.floor(XP)
      Data.Level = math.floor(Level) 
      CreateRankBar(0, NextThreshold(Data.Level), Data.XP, Data.XP, Data.Level)
  end)
end 
