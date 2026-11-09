-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = nil
local selfInfo = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    ESX.SetPlayerState('level',1)
end)

RegisterNetEvent('idoverhead:selfInfo', function(state)
    selfInfo = state
end)

playersInfo = {}
local mpGamerTags = {}
local mpGamerTagSettings = {}
local NewBiePlayer = {}
local ShowPlayersId = false
local fatmaList = {}
local twList = {}
local talkBanList = {}

-- AddStateBagChangeHandler('fatmaState', nil, function(bagName, key, value)
--     if not bagName:match('player:') then return end
--     local player = tonumber(bagName:gsub('player:', ''), 10)
--     fatmaList[player] = value
-- end)

AddStateBagChangeHandler('TW', nil, function(bagName, key, value)
    if not bagName:match('player:') then return end
    local player = tonumber(bagName:gsub('player:', ''), 10)
    twList[player] = value
end)

AddStateBagChangeHandler('talkBan', nil, function(bagName, _, value)
    if not bagName:match('player:') then return end
    local player = tonumber(bagName:gsub('player:', ''), 10)
    talkBanList[player] = value
end)

local gtComponent = {
    GAMER_NAME = 0,
    CREW_TAG = 1,
    healthArmour = 2,
    BIG_TEXT = 3,
    AUDIO_ICON = 4,
    MP_USING_MENU = 5,
    MP_PASSIVE_MODE = 6,
    WANTED_STARS = 7,
    MP_DRIVER = 8,
    MP_CO_DRIVER = 9,
    MP_TAGGED = 10,
    GAMER_NAME_NEARBY = 11,
    ARROW = 12,
    MP_PACKAGES = 13,
    INV_IF_PED_FOLLOWING = 14,
    RANK_TEXT = 15,
    MP_TYPING = 16
}

local function makeSettings()
    return {
        nameTag = nil,
        colors = {},
        toggle = false,
    }
end

function updatePlayerNames()
    
    -- re-run this function the next frame
    SetTimeout(100, updatePlayerNames)

    -- get local coordinates to compare to
    local localCoords = GetEntityCoords(PlayerPedId())
    local myserverId = GetPlayerServerId(PlayerId())
    -- for each valid player index
    for _, i in ipairs(GetActivePlayers()) do
        -- get their ped
        local ped = GetPlayerPed(i)
        local serverId = GetPlayerServerId(i)

        local pedCoords = GetEntityCoords(ped)

        -- make a new settings list if needed
        if not mpGamerTagSettings[serverId] then
            mpGamerTagSettings[serverId] = makeSettings()
        end

        if not mpGamerTagSettings[serverId].nameTag then
           if (i == PlayerId() and not selfInfo) or playersInfo[i] == nil then goto skip_this end
           if  playersInfo[i] == nil then goto skip_this end
        end

        -- check the ped, because changing player models may recreate the ped
        -- also check gamer tag activity in case the game deleted the gamer tag
        if not mpGamerTags[serverId] or mpGamerTags[serverId].ped ~= ped or not IsMpGamerTagActive(mpGamerTags[serverId].tag) then
            local nameTag = "["..serverId.."]"
            -- remove any existing tag
            if mpGamerTags[serverId] then
                RemoveMpGamerTag(mpGamerTags[serverId].tag)
            end

            -- store the new tag
            mpGamerTags[serverId] = {
                tag = CreateFakeMpGamerTag(GetPlayerPed(i), nameTag, false, false, '', 0),
                ped = ped
            }
        end

        -- store the tag in a local
        local tag = mpGamerTags[serverId].tag

        -- check distance
        local distance = playersInfo[i].info["distance"]
        local fatma = fatmaList[serverId]
        local tw = twList[serverId]
        local talkBan = talkBanList[serverId]
        -- show/hide based on nearbyness/line-of-sight
        -- nearby checks are primarily to prevent a lot of LOS checks
        if (distance < 20 or (mpGamerTagSettings[serverId].distance and distance <= mpGamerTagSettings[serverId].distance)) and playersInfo[i].info["cansee"] and HasEntityClearLosToEntity(PlayerPedId(), ped, 17) and not mpGamerTagSettings[serverId].toggle then
            SetMpGamerTagVisibility(tag, gtComponent.MP_TYPING, ESX.GetPlayerState(serverId,'typing'))
            if ShowPlayersId or NetworkIsPlayerTalking(i) or mpGamerTagSettings[serverId].nameTag then
                -- SetMpGamerTagVisibility(tag, gtComponent.WANTED_STARS, true)
                local color = ESX.GetPlayerState(serverId,'pColor') or 180
                -- SetMpGamerTagColour(tag, gtComponent.WANTED_STARS, color)
                local level = ESX.GetPlayerState(serverId,'level') or 1
                SetMpGamerTagVisibility(tag, gtComponent[fatma and 'MP_USING_MENU' or 'AUDIO_ICON'], NetworkIsPlayerTalking(i) or (ShowPlayersId and (fatma or tw)))
                SetMpGamerTagAlpha(tag, gtComponent[fatma and 'MP_USING_MENU' or 'AUDIO_ICON'], 255)
                SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, true)
                SetMpGamerTagVisibility(tag, gtComponent.MP_PASSIVE_MODE, tw or (ShowPlayersId and talkBan))
                if mpGamerTagSettings[serverId] and mpGamerTagSettings[serverId].nameTag then
                    if mpGamerTagSettings[myserverId] and mpGamerTagSettings[myserverId].nameTag then
                        SetMpGamerTagName(tag, "["..serverId.."] " .. mpGamerTagSettings[serverId].nameTag)
                    else
                        SetMpGamerTagName(tag, "["..serverId.."] " .. mpGamerTagSettings[serverId].nameTag)
                    end
                else
                    if level == -1 then
                        SetMpGamerTagName(tag, "["..serverId.."]")
                    else
                        SetMpGamerTagName(tag, "["..serverId.."] ".. "| lvl : ".. level )
                    end
                end
                for k,v in pairs(mpGamerTagSettings[serverId].colors) do
                    SetMpGamerTagColour(tag, gtComponent[k], v)
                end
                if mpGamerTagSettings[serverId].nameTag then
                    SetMpGamerTagColour(tag, gtComponent.GAMER_NAME, 6)
                end
                if tw then
                    SetMpGamerTagColour(tag, gtComponent.MP_PASSIVE_MODE, 6)
                end
                if ShowPlayersId and talkBan then
                    SetMpGamerTagColour(tag, gtComponent.MP_PASSIVE_MODE, 6)
                end
            else
                --SetMpGamerTagVisibility(tag, gtComponent.MP_TYPING, false)
                SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, false)
                SetMpGamerTagVisibility(tag, gtComponent[fatma and 'MP_USING_MENU' or 'AUDIO_ICON'], false)
                SetMpGamerTagVisibility(tag, gtComponent.MP_PASSIVE_MODE, false)
                SetMpGamerTagVisibility(tag, gtComponent.WANTED_STARS, false)
            end
        else
            SetMpGamerTagVisibility(tag, gtComponent.MP_TYPING, false)
            SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, false)
            SetMpGamerTagVisibility(tag, gtComponent[fatma and 'MP_USING_MENU' or 'AUDIO_ICON'], false)
            SetMpGamerTagVisibility(tag, gtComponent.MP_PASSIVE_MODE, false)
            SetMpGamerTagVisibility(tag, gtComponent.WANTED_STARS, false)
        end

        ::skip_this::
    end
end

AddEventHandler('onResourceStop', function(name)
    if name == GetCurrentResourceName() then
        for _, v in pairs(mpGamerTags) do
            RemoveMpGamerTag(v.tag)
        end
    end
end)

RegisterNetEvent('pname:changePlayerSetting')
AddEventHandler('pname:changePlayerSetting', function(id, key, value)
    if not mpGamerTagSettings[id] then
        mpGamerTagSettings[id] = makeSettings()
    end

    if mpGamerTags[id] then
        RemoveMpGamerTag(mpGamerTags[id].tag)
    end

    mpGamerTagSettings[id][key] = value
end)

Citizen.CreateThread(function()
    while true do
        for _, player in ipairs(GetActivePlayers()) do

            local coords = GetEntityCoords(GetPlayerPed(-1))
            local coords2 = GetEntityCoords(GetPlayerPed(player))
            local distance = math.floor(Vdist2(coords.x, coords.y, coords.z, coords2.x, coords2.y, coords2.z))
            playersInfo[player] = {}
            playersInfo[player]["info"] = {}
            playersInfo[player].info["distance"] = distance
            playersInfo[player].info["cansee"] = IsEntityVisible(GetPlayerPed(player))
        end
        Citizen.Wait(2000)
    end
end)


ShowPlayersId = false

AddEventHandler('onKeyUP',function(key)
	if key == "numpad7" then
        if not ShowPlayersId then
            ShowPlayersId = true
            TriggerServerEvent("3dme:shareDisplay2", GetPlayerServerId(PlayerId()) .. " Be id ha negah kard", true)
            SetTimeout(5000, function()
                ShowPlayersId = false
            end)
        end
	end
end)

RegisterNetEvent('id7')
AddEventHandler('id7', function(source)
  if not ESX.Game.PlayerExist(source) then return end
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(source)
  if pid == myId then
    TriggerEvent('chatMessage', "" , {255, 0, 0},"(( ".. source .. " )) Be id ha negah kard", 'plarms')
  elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 20.999 then
    TriggerEvent('chatMessage', "" , {255, 0, 0},"(( ".. source .. " )) Be id ha negah kard", 'plarms')
  end
end)

updatePlayerNames()