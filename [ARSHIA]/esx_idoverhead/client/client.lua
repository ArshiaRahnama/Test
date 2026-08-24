ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

playersInfo = {}
local mpGamerTags = {}
local mpGamerTagSettings = {}
local NewBiePlayer = {}
local ShowPlayersId = false
local alias = {}
local isDead = false

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

local DatPlayerLevel = {}
local requestedRank = {}

local function getCachedRank(serverId)
    if DatPlayerLevel[serverId] then
        return DatPlayerLevel[serverId]
    end
    if not requestedRank[serverId] then
        requestedRank[serverId] = true
        ESX.TriggerServerCallback('XP_System:getRank', function(rank)
            if rank and rank > 0 then
                DatPlayerLevel[serverId] = rank
            end
        end, serverId)
    end
    return DatPlayerLevel[serverId] or '?'
end

RegisterNetEvent('pname:clearRankCache')
AddEventHandler('pname:clearRankCache', function(serverId)
    DatPlayerLevel[serverId] = nil
    requestedRank[serverId] = nil
end)

local function makeSettings()
    return {
        nameTag = nil,
        colors = {},
        toggle = false,
    }
end

function updatePlayerNames()
    SetTimeout(100, updatePlayerNames)
    local localCoords = GetEntityCoords(PlayerPedId())
    for _, i in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(i)
        local serverId = GetPlayerServerId(i)
        local myserverId = GetPlayerServerId(PlayerId())
        local pedCoords = GetEntityCoords(ped)
        if serverId ~=  myserverId then
            if not mpGamerTagSettings[serverId] then
                mpGamerTagSettings[serverId] = makeSettings()
            end

            if not mpGamerTagSettings[serverId].nameTag then
            if i == PlayerId() or playersInfo[i] == nil then goto skip_this end
            if  playersInfo[i] == nil then goto skip_this end
            end

            if not mpGamerTags[serverId] or mpGamerTags[serverId].ped ~= ped or not IsMpGamerTagActive(mpGamerTags[serverId].tag) then
                local nameTag = "["..serverId.."]"
                if mpGamerTags[serverId] then
                    RemoveMpGamerTag(mpGamerTags[serverId].tag)
                end

                mpGamerTags[serverId] = {
                    tag = CreateFakeMpGamerTag(GetPlayerPed(i), nameTag, false, false, '', 0),
                    ped = ped
                }
            end
            local tag = mpGamerTags[serverId].tag
            local distance = playersInfo[i].info["distance"]

            if (distance < 20 or (mpGamerTagSettings[serverId].distance and distance <= mpGamerTagSettings[serverId].distance)) and playersInfo[i].info["cansee"] and HasEntityClearLosToEntity(PlayerPedId(), ped, 17) and not mpGamerTagSettings[serverId].toggle then
                local isTyping = DecorGetInt(GetPlayerPed(i), 'typing')
                SetMpGamerTagVisibility(tag, gtComponent.MP_TYPING, isTyping)
                if ShowPlayersId or NetworkIsPlayerTalking(i) or mpGamerTagSettings[serverId].nameTag then
                    local level = getCachedRank(serverId)

                    SetMpGamerTagVisibility(tag, gtComponent.AUDIO_ICON, NetworkIsPlayerTalking(i))
                    SetMpGamerTagAlpha(tag, gtComponent.AUDIO_ICON, 255)
                    SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, true)

                    if DecorGetBool(GetPlayerPed(i), "megafan_active") then
                        SetMpGamerTagColour(tag, gtComponent.GAMER_NAME, 6)
                        SetMpGamerTagName(tag, "[" .. serverId .. "] Speaker")
                    else
                        if not isTyping then
                            SetMpGamerTagColour(tag, gtComponent.GAMER_NAME, 2)
                        else
                            SetMpGamerTagColour(tag, gtComponent.GAMER_NAME, 0)
                        end
                        SetMpGamerTagName(tag, "["..serverId.."] ".. "| lvl : ".. level )
                    end
                else
                    SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, false)
                    SetMpGamerTagVisibility(tag, gtComponent.AUDIO_ICON, false)
                end
            else
                SetMpGamerTagVisibility(tag, gtComponent.MP_TYPING, false)
                SetMpGamerTagVisibility(tag, gtComponent.GAMER_NAME, false)
                SetMpGamerTagVisibility(tag, gtComponent.AUDIO_ICON, false)
            end
        end
        ::skip_this::
    end
end

function DrawText3Dido(x, y, z, text, r, g, b)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = Vdist(px, py, pz, x, y, z, 1)
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetDrawOrigin(x, y, z, 0);
        ClearDrawOrigin()
        SetTextScale(0.0 * scale, 0.7 * scale)
        SetTextFont(6)
        SetTextProportional(0)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()
    if IsPlayerSwitchInProgress() then
        Wait(2000)
    end
    local id = GetPlayerServerId(PlayerId())
    TriggerServerEvent('esx_idoverhead:checkTimePlay', id)
end)

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
            TriggerServerEvent("idoverhead:7")
            SetTimeout(5000, function()
                ShowPlayersId = false
            end)
        end
	end
end)

local spam = false
function showId()
    if spam then return lib.notify({ position = 'center-right', title = '', description = 'لطفاً اسپم نکنید!', type = 'error', duration = 3000 }) end
    spam = true
    showidpress = true
    TriggerServerEvent('ido:ShowID')
    Citizen.SetTimeout(5000, function()
        showidpress = false
        spam = false
    end)
end

AddEventHandler("onKeyDown", function(key)
    if key == "numpad7" then
        showId()
    end
end)

updatePlayerNames()