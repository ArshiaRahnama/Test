ESX                           = nil
Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

local AnimationDuration = -1
local ChosenAnimation = ""
local ChosenDict = ""
local IsInAnimation = false
local MostRecentChosenAnimation = ""
local MostRecentChosenDict = ""
local MovementType = 0
local PlayerGender = "male"
local PlayerHasProp = false
local PlayerProps = {}
local PlayerParticles = {}
local SecondPropEmote = false
local lang = Config.MenuLanguage
local PtfxNotif = false
local PtfxPrompt = false
local PtfxWait = 500
local PtfxNoProp = false
active = true
Citizen.CreateThread(function()
  while true do

    if PtfxPrompt then
      if not PtfxNotif then
          SimpleNotify(PtfxInfo)
          PtfxNotif = true
      end
      if IsControlPressed(0, 47) then
        PtfxStart()
        Citizen.Wait(PtfxWait)
        PtfxStop()
      end
    else
      Citizen.Wait(10)
    end
    Citizen.Wait(10)
  end
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)
    if IsPedShooting(PlayerPedId()) and IsInAnimation then
      EmoteCancel()
    end
  end
end)

AddEventHandler("onKeyDown", function(key)
  if disableMenu then return end
  if key == "f3" and not ESX.GetPlayerData().IsDead then
    OpenEmoteMenu()
  elseif key == "x" then
    local ped = PlayerPedId()
    if IsPedFalling(ped) then return end
    EmoteCancel()
  end
end)

RegisterNetEvent('esx_dpemote:OpenEmoteMenu')
AddEventHandler("esx_dpemote:OpenEmoteMenu", function()
  OpenEmoteMenu()
end)

RegisterNetEvent('dpemote:enable')
AddEventHandler('dpemote:enable', function(state)
	active = state
	mainMenu:Visible(false)
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/e', 'Play an emote', {{ name="emotename", help="dance, camera, sit or any valid emote."}})
    TriggerEvent('chat:addSuggestion', '/e', 'Play an emote', {{ name="emotename", help="dance, camera, sit or any valid emote."}})
    TriggerEvent('chat:addSuggestion', '/emote', 'Play an emote', {{ name="emotename", help="dance, camera, sit or any valid emote."}})
    if Config.SqlKeybinding then
      TriggerEvent('chat:addSuggestion', '/emotebind', 'Bind an emote', {{ name="key", help="num4, num5, num6, num7. num8, num9. Numpad 4-9!"}, { name="emotename", help="dance, camera, sit or any valid emote."}})
      TriggerEvent('chat:addSuggestion', '/emotebinds', 'Check your currently bound emotes.')
    end
    TriggerEvent('chat:addSuggestion', '/emotemenu', 'Open dpemotes menu (F3) by default.')
    TriggerEvent('chat:addSuggestion', '/emotes', 'List available emotes.')
    TriggerEvent('chat:addSuggestion', '/walk', 'Set your walkingstyle.', {{ name="style", help="/walks for a list of valid styles"}})
    TriggerEvent('chat:addSuggestion', '/walks', 'List available walking styles.')
end)

RegisterCommand('e', function(source, args, raw)
  if not ESX.GetPlayerData().IsDead then
    EmoteCommandStart(source, args, raw)
  else
    TriggerEvent("chatMessage", "[ System ]", {255,0,0}, 'Shoma Dead Hastid')
  end
end)

RegisterCommand('emote', function(source, args, raw)

  if not ESX.GetPlayerData().IsDead then
    EmoteCommandStart(source, args, raw)
  else
    TriggerEvent("chatMessage", "[ System ]", {255,0,0}, 'Shoma Dead Hastid')
  end

end)
if Config.SqlKeybinding then
  RegisterCommand('emotebind', function(source, args, raw)

    if not ESX.GetPlayerData().IsDead then
      EmoteBindStart(source, args, raw)
    else
      TriggerEvent("chatMessage", "[ System ]", {255,0,0}, 'Shoma Dead Hastid')
    end
  end)
  RegisterCommand('emotebinds', function(source, args, raw)
    if not ESX.GetPlayerData().IsDead then
      EmoteBindsStart(source, args, raw)
    else
      TriggerEvent("chatMessage", "[ System ]", {255,0,0}, 'Shoma Dead Hastid')
    end

  end)
end
RegisterCommand('emotemenu', function(source, args, raw)

  if not ESX.GetPlayerData().IsDead then
    OpenEmoteMenu()
  else
    TriggerEvent("chatMessage", "[ System ]", {255,0,0}, 'Shoma Dead Hastid')
  end


end)
RegisterCommand('emotes', function(source, args, raw)

  if not ESX.GetPlayerData().IsDead then
    EmotesOnCommand()
  else
    TriggerEvent("chatMessage", "[ System ]", {255,0,0}, 'Shoma Dead Hastid')
  end


end)
RegisterCommand('walk', function(source, args, raw)

  if not ESX.GetPlayerData().IsDead then
    WalkCommandStart(source, args, raw)
  else
    TriggerEvent("chatMessage", "[ System ]", {255,0,0}, 'Shoma Dead Hastid')
  end

end)

RegisterCommand('walks', function(source, args, raw)

  if not ESX.GetPlayerData().IsDead then
    WalksOnCommand()
  else
    TriggerEvent("chatMessage", "[ System ]", {255,0,0}, 'Shoma Dead Hastid')
  end

end)

AddEventHandler('onResourceStop', function(resource)
  if resource == GetCurrentResourceName() then
    DestroyAllProps()
    ClearPedTasks(GetPlayerPed(-1))
    ResetPedMovementClipset(PlayerPedId())
  end
end)

function EmoteCancel()

  if ChosenDict == "MaleScenario" and IsInAnimation then
    ClearPedTasks(PlayerPedId())
    IsInAnimation = false
    DebugPrint("Forced scenario exit")
  elseif ChosenDict == "Scenario" and IsInAnimation then
    ClearPedTasks(PlayerPedId())
    IsInAnimation = false
    DebugPrint("Forced scenario exit")
  end

  PtfxNotif = false
  PtfxPrompt = false

  if IsInAnimation then
    PtfxStop()
    ClearPedTasks(GetPlayerPed(-1))
    DestroyAllProps()
    IsInAnimation = false
  end
end

function EmoteChatMessage(args)
  if args == display then
    TriggerEvent("chatMessage", "[ Help ]", {0,0,0}, string.format(""))
  else
    TriggerEvent("chatMessage", "[ Help ]", {0,0,0}, string.format(""..args..""))
  end
end

function DebugPrint(args)
  if Config.DebugDisplay then
    print(args)
  end
end

function PtfxStart()
    if PtfxNoProp then
      PtfxAt = PlayerPedId()
    else
      PtfxAt = prop
    end
    UseParticleFxAssetNextCall(PtfxAsset)
    Ptfx = StartNetworkedParticleFxLoopedOnEntityBone(PtfxName, PtfxAt, Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, GetEntityBoneIndexByName(PtfxName, "VFX"), 1065353216, 0, 0, 0, 1065353216, 1065353216, 1065353216, 0)
    SetParticleFxLoopedColour(Ptfx, 1.0, 1.0, 1.0)
    table.insert(PlayerParticles, Ptfx)
end

function PtfxStop()
  for a,b in pairs(PlayerParticles) do
    DebugPrint("Stopped PTFX: "..b)
    StopParticleFxLooped(b, false)
    table.remove(PlayerParticles, a)
  end
end

function EmotesOnCommand(source, args, raw)
  local EmotesCommand = ""
  for a in pairsByKeys(DP.Emotes) do
    EmotesCommand = EmotesCommand .. ""..a..", "
  end
  EmoteChatMessage(EmotesCommand)
  EmoteChatMessage(Config.Languages[lang]['emotemenucmd'])
end

function pairsByKeys (t, f)
    local a = {}
    for n in pairs(t) do
        table.insert(a, n)
    end
    table.sort(a, f)
    local i = 0
    local iter = function ()
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end

function EmoteMenuStart(args, hard)
    local name = args
    local etype = hard

    if etype == "dances" then
        if DP.Dances[name] ~= nil then
          if OnEmotePlay(DP.Dances[name]) then end
        end
    elseif etype == "props" then
        if DP.PropEmotes[name] ~= nil then
          if OnEmotePlay(DP.PropEmotes[name]) then end
        end
    elseif etype == "emotes" then
        if DP.Emotes[name] ~= nil then
          if OnEmotePlay(DP.Emotes[name]) then end
        else
          if name ~= "🕺 Dance Emotes" then end
        end
    elseif etype == "expression" then
        if DP.Expressions[name] ~= nil then
          if OnEmotePlay(DP.Expressions[name]) then end
        end
    end
end
local cancommand = true
function EmoteCommandStart(source, args, raw)
    if not active or IsPedInAnyVehicle(GetPlayerPed(-1),true) then return end
    if not cancommand then
      TriggerEvent('esx:showNotification', '~h~~r~Lotfan Spam Emote Nakonid!')
    else
      cancommand = false
      Citizen.SetTimeout(5000,function()
        cancommand = true
      end)
      if #args > 0 then
        local name = string.lower(args[1])
        if name == "c" then
            if IsInAnimation then
                EmoteCancel()
            else
                EmoteChatMessage(Config.Languages[lang]['nocancel'])
            end
          return
        elseif name == "help" then
          EmotesOnCommand()
        return end

        if DP.Emotes[name] ~= nil then
          if OnEmotePlay(DP.Emotes[name]) then end return
        elseif DP.Dances[name] ~= nil then
          if OnEmotePlay(DP.Dances[name]) then end return
        elseif DP.PropEmotes[name] ~= nil then
          if OnEmotePlay(DP.PropEmotes[name]) then end return
        else
          EmoteChatMessage("'"..name.."' "..Config.Languages[lang]['notvalidemote'].."")
        end
      end
    end
end

function LoadAnim(dict)
  while not HasAnimDictLoaded(dict) do
    RequestAnimDict(dict)
    Citizen.Wait(10)
  end
end

function LoadPropDict(model)
  while not HasModelLoaded(GetHashKey(model)) do
    RequestModel(GetHashKey(model))
    Citizen.Wait(10)
  end
end

function PtfxThis(asset)
  while not HasNamedPtfxAssetLoaded(asset) do
    RequestNamedPtfxAsset(asset)
    Citizen.Wait(10)
  end
  UseParticleFxAssetNextCall(asset)
end

function DestroyAllProps()
  for _,v in pairs(PlayerProps) do
    DeleteEntity(v)
  end
  PlayerHasProp = false
  DebugPrint("Destroyed Props")
end

function AddPropToPlayer(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
  local Player = PlayerPedId()
  local x,y,z = table.unpack(GetEntityCoords(Player))

  if not HasModelLoaded(prop1) then
    LoadPropDict(prop1)
  end

  prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  true,  true, true)
  AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
  table.insert(PlayerProps, prop)
  PlayerHasProp = true
  SetModelAsNoLongerNeeded(prop1)
end

function CheckGender()
  local hashSkinMale = GetHashKey("mp_m_freemode_01")
  local hashSkinFemale = GetHashKey("mp_f_freemode_01")

  if GetEntityModel(PlayerPedId()) == hashSkinMale then
    PlayerGender = "male"
  elseif GetEntityModel(PlayerPedId()) == hashSkinFemale then
    PlayerGender = "female"
  end
  DebugPrint("Set gender as = ("..PlayerGender..")")
end

AddEventHandler('xd_emote:PlayEmote', function(name)
  OnEmotePlay(DP.Emotes[name])
end)

AddEventHandler('xd_emote:PlayThisEmote', function(cb, dict, anim, p1, p2, duration, move)
  OnEmotePlay({dict, anim}, cb, p1, p2, duration, move)
end)

function OnEmotePlay(EmoteName)
  if IsPedArmed(GetPlayerPed(-1), 7) then
    TriggerEvent('esx:showNotification', '~h~~r~Shoma Nmitavanid Hengami Ke Aslahe Darid Az ~w~Emote~r~ Ha Estefade Konid!~s~')
   return
  end
  InVehicle = IsPedInAnyVehicle(PlayerPedId(), true)
  if not Config.AllowedInCars and InVehicle == 1 then
    return
  end

  if not DoesEntityExist(GetPlayerPed(-1)) then
    return false
  end

  if Config.DisarmPlayer then
    if IsPedArmed(GetPlayerPed(-1), 7) then
      SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey('WEAPON_UNARMED'), true)
    end
  end

  ChosenDict,ChosenAnimation,ename = table.unpack(EmoteName)
  AnimationDuration = -1

  if PlayerHasProp then
    DestroyAllProps()
  end

  if ChosenDict == "Expression" then
    SetFacialIdleAnimOverride(PlayerPedId(), ChosenAnimation, 0)
    return
  end

  if ChosenDict == "MaleScenario" or "Scenario" then
    CheckGender()
    if ChosenDict == "MaleScenario" then if InVehicle then return end
      if PlayerGender == "male" then
        ClearPedTasks(GetPlayerPed(-1))
        TaskStartScenarioInPlace(GetPlayerPed(-1), ChosenAnimation, 0, true)
        DebugPrint("Playing scenario = ("..ChosenAnimation..")")
        IsInAnimation = true
      else
        EmoteChatMessage(Config.Languages[lang]['maleonly'])
      end return
    elseif ChosenDict == "ScenarioObject" then if InVehicle then return end
      BehindPlayer = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0 - 0.5, -0.5);
      ClearPedTasks(GetPlayerPed(-1))
      TaskStartScenarioAtPosition(GetPlayerPed(-1), ChosenAnimation, BehindPlayer['x'], BehindPlayer['y'], BehindPlayer['z'], GetEntityHeading(PlayerPedId()), 0, 1, false)
      DebugPrint("Playing scenario = ("..ChosenAnimation..")")
      IsInAnimation = true
      return
    elseif ChosenDict == "Scenario" then if InVehicle then return end
      ClearPedTasks(GetPlayerPed(-1))
      TaskStartScenarioInPlace(GetPlayerPed(-1), ChosenAnimation, 0, true)
      DebugPrint("Playing scenario = ("..ChosenAnimation..")")
      IsInAnimation = true
    return end
  end

  LoadAnim(ChosenDict)

  if EmoteName.AnimationOptions then
    if EmoteName.AnimationOptions.EmoteLoop then
      MovementType = 1
    if EmoteName.AnimationOptions.EmoteMoving then
      MovementType = 51
  end

  elseif EmoteName.AnimationOptions.EmoteMoving then
    MovementType = 51
  elseif EmoteName.AnimationOptions.EmoteMoving == false then
    MovementType = 0
  elseif EmoteName.AnimationOptions.EmoteStuck then
    MovementType = 50
  end

  else
    MovementType = 0
  end

  if InVehicle == 1 then
    MovementType = 51
  end

  if EmoteName.AnimationOptions then
    if EmoteName.AnimationOptions.EmoteDuration == nil then
      EmoteName.AnimationOptions.EmoteDuration = -1
      AttachWait = 0
    else
      AnimationDuration = EmoteName.AnimationOptions.EmoteDuration
      AttachWait = EmoteName.AnimationOptions.EmoteDuration
    end

    if EmoteName.AnimationOptions.PtfxAsset then
      PtfxAsset = EmoteName.AnimationOptions.PtfxAsset
      PtfxName = EmoteName.AnimationOptions.PtfxName
      if EmoteName.AnimationOptions.PtfxNoProp then
        PtfxNoProp = EmoteName.AnimationOptions.PtfxNoProp
      else
        PtfxNoProp = false
      end
      Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, PtfxScale = table.unpack(EmoteName.AnimationOptions.PtfxPlacement)
      PtfxInfo = EmoteName.AnimationOptions.PtfxInfo
      PtfxWait = EmoteName.AnimationOptions.PtfxWait
      PtfxNotif = false
      PtfxPrompt = true
      PtfxThis(PtfxAsset)
    else
      DebugPrint("Ptfx = none")
      PtfxPrompt = false
    end
  end

  TaskPlayAnim(GetPlayerPed(-1), ChosenDict, ChosenAnimation, 2.0, 2.0, AnimationDuration, MovementType, 0, false, false, false)
  RemoveAnimDict(ChosenDict)
  IsInAnimation = true
  MostRecentDict = ChosenDict
  MostRecentAnimation = ChosenAnimation

  if EmoteName.AnimationOptions then
    if EmoteName.AnimationOptions.Prop then
        PropName = EmoteName.AnimationOptions.Prop
        PropBone = EmoteName.AnimationOptions.PropBone
        PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6 = table.unpack(EmoteName.AnimationOptions.PropPlacement)
        if EmoteName.AnimationOptions.SecondProp then
          SecondPropName = EmoteName.AnimationOptions.SecondProp
          SecondPropBone = EmoteName.AnimationOptions.SecondPropBone
          SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6 = table.unpack(EmoteName.AnimationOptions.SecondPropPlacement)
          SecondPropEmote = true
        else
          SecondPropEmote = false
        end
        Citizen.Wait(AttachWait)
        AddPropToPlayer(PropName, PropBone, PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6)
        if SecondPropEmote then
          AddPropToPlayer(SecondPropName, SecondPropBone, SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6)
        end
    end
  end
  return true
end

function PlayEmote(emote)
  OnEmotePlay(DP.Emotes[emote])
end
exports("PlayEmote", PlayEmote)
