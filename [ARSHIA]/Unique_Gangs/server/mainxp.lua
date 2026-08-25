ESX= nil

TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

local GangLevels = {
    1000,
    2500,
    6000,
    9500,
    12000,
    15000,
    19500,
    24000,
    28500,
    33000,
    45000,
    56000,
    71000,
    89000,
    100000
}
GangLevels[0] = 0
local GangInfo = {}
local gangs = {}
local XPAmount = {
    ["Shop"]        = 200,
    ["Javahery"]    = 350,
    ["Bank"]        = 500,
    ["Bankc"]       = 650,
    ["Bime"]        = 600,
    ["Online Boodan Aza"] = 10,
    ["Admin"] = 10,
    ['ChopShop'] = 15,
    ["Capture"]     = 400
}

local LuaSocket = require("string")

RegisterCommand("addxpgang", function(source, args)
    if ESX.GetPlayerFromId(source).permission_level > 9 then
        if args[1] then
            if args[2] then
                UpdateXP(args[1], tonumber(args[2]), "Admin")
                Database(tonumber(args[2]), args[1])
            end
        end
    end
end)
RegisterCommand("removexpgang", function(source, args)
    if ESX.GetPlayerFromId(source).permission_level > 9 then
        if args[1] then
            if args[2] then
                UpdateXP2(args[1], tonumber(args[2]), "Admin")
                Database2(tonumber(args[2]), args[1])
            end
        end
    end
end)

AddEventHandler('esx:playerLoaded', function(source)
    CreateXPThread(tonumber(source))
end)

function CreateXPThread(ID)
    SetTimeout(3600000, function()
        if GetPlayerName(ID) then
            TriggerEvent("gangs:CollectXP", ID, "Online Boodan Aza", nil)
            CreateXPThread(ID)
        end
    end)
end

ESX.RegisterServerCallback("gangs:GetGangLevel_XP", function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM gangs_data WHERE gang_name = @gang_name',
	{
        ['@gang_name'] = ESX.GetPlayerFromId(source).gang.name,

    }, function(result)
        if result[1] then
            cb(tonumber(result[1].XP), tonumber(result[1].Level), result[1].blip)
            if GangInfo[ESX.GetPlayerFromId(source).gang.name] == nil then
                GangInfo[ESX.GetPlayerFromId(source).gang.name] = {
                    Pos = json.decode(result[1].blip)
                }
            end
        end
	end)
end)

AddEventHandler("gangs:DistanceThread", function(source, Method)
    DistanceThread(tonumber(source), Method, ESX.GetPlayerFromId(source).gang.name)
    TriggerClientEvent("gangs:CreateXPThread", source)
end)

function DistanceThread(src, Method, Name)
    SetTimeout(3000, function()
        if GetPlayerName(src) then
            if #(GetEntityCoords(GetPlayerPed(src)) - vector3(GangInfo[ESX.GetPlayerFromId(src).gang.name].Pos.x, GangInfo[ESX.GetPlayerFromId(src).gang.name].Pos.y, GangInfo[ESX.GetPlayerFromId(src).gang.name].Pos.z)) < 20.0 then
                TriggerEvent("gangs:CollectXP", tonumber(src), Method, Name)
                TriggerClientEvent("gangs:Arrived", src)
            else
                DistanceThread(src, Method, Name)
            end
        end
    end)
end

AddEventHandler("gangs:CollectXP", function(source, Method, gang)
    if Method ~= "Capture" then
        if ESX.GetPlayerFromId(source).gang.name ~= "nogang" then
            for k, v in pairs(XPAmount) do
                if k == Method then
                    UpdateXP(ESX.GetPlayerFromId(source).gang.name, v, Method)
                    Database(v, ESX.GetPlayerFromId(source).gang.name)
                    break
                end
            end
        end
    else
        UpdateXP(gang, 400, "Capture")
        Database(400, gang)
    end
end)

function Database(XP, gang)
    MySQL.Async.fetchAll('SELECT * FROM gangs_data WHERE gang_name = @gang_name',
	{
        ['@gang_name'] = gang,

    }, function(data)
        if data[1] then
            gangs[gang] = {
                Level = tonumber(data[1].Level),
                XP    = tonumber(data[1].XP)
            }
            if gangs[gang].XP + XP >= GangLevels[gangs[gang].Level + 1] then
                gangs[gang].XP = gangs[gang].XP + XP - GangLevels[gangs[gang].Level + 1]
                gangs[gang].Level = gangs[gang].Level + 1
            else
                gangs[gang].XP = gangs[gang].XP + XP
            end
            MySQL.Async.execute('UPDATE gangs_data SET XP = @XP, Level = @Level WHERE gang_name = @gang_name',
            {
                ['@XP']    = gangs[gang].XP,
                ['@Level']    = gangs[gang].Level,
                ['@gang_name'] = gang
            })
            gangs[gang] = nil
        end
	end)
end
function Database2(XP, gang)
    MySQL.Async.fetchAll('SELECT * FROM gangs_data WHERE gang_name = @gang_name',
	{
        ['@gang_name'] = gang,

    }, function(data)
        if data[1] then
            gangs[gang] = {
                Level = tonumber(data[1].Level),
                XP    = tonumber(data[1].XP)
            }
            if gangs[gang].XP - XP <= GangLevels[gangs[gang].Level - 1] then
                gangs[gang].XP = gangs[gang].XP - XP - GangLevels[gangs[gang].Level - 1]
                gangs[gang].Level = gangs[gang].Level - 1
            else
                gangs[gang].XP = gangs[gang].XP - XP
            end
            MySQL.Async.execute('UPDATE gangs_data SET XP = @XP, Level = @Level WHERE gang_name = @gang_name',
            {
                ['@XP']    = gangs[gang].XP,
                ['@Level']    = gangs[gang].Level,
                ['@gang_name'] = gang
            })
            gangs[gang] = nil
        end
	end)
end

function UpdateXP(gang, Add, MT)
    local xPlayers = ESX.GetPlayers()
    for k, v in pairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(v)
        if xPlayer.gang.name == gang then
            TriggerClientEvent("gangs:AddXPtoGang", xPlayer.source, Add)
            TriggerClientEvent('esx:showNotification', xPlayer.source, '~g~~h~Gang Shoma ~y~~h~'..Add.." XP~g~~h~ Az ~y~~h~"..MT.." ~g~~h~Daryaft Kard.")
        end
    end
end
function UpdateXP2(gang, Add, MT)
    local xPlayers = ESX.GetPlayers()
    for k, v in pairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(v)
        if xPlayer.gang.name == gang then
            TriggerClientEvent("gangs:RemoveXPtoGang", xPlayer.source, Add)
            TriggerClientEvent('esx:showNotification', xPlayer.source, '~g~~h~Gang Shoma ~y~~h~'..Add.." XP~g~~h~ Az ~y~~h~"..MT.." ~g~~h~Daryaft Kard.")
        end
    end
end

function UpdateXPALL(gang, Add)
    local xPlayers = ESX.GetPlayers()
    for k, v in pairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(v)
        if xPlayer.gang.name == gang then
            TriggerClientEvent("gangs:AddXPtoGang", xPlayer.source, Add)
        end
    end
end

-- SECURITY FIX: previously took the gang name AND the XP amount straight
-- from the client with zero validation -- any player could grant unlimited
-- XP to any gang (their own or a rival's) with a single event call. Now the
-- caller must actually belong to a gang (uses THEIR gang, not a client-
-- supplied name) and the amount is clamped to a sane per-call ceiling.
local MAX_XP_PER_CALL = 100

RegisterNetEvent("gangs:AddXpGang")
AddEventHandler('gangs:AddXpGang', function(gang2, Add2)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if not xPlayer or xPlayer.gang.name == "nogang" then
        print(('gangs:AddXpGang: %s attempted to call without a gang!'):format(xPlayer and xPlayer.identifier or _source))
        return
    end

    Add2 = tonumber(Add2)
    if not Add2 or Add2 <= 0 then return end
    if Add2 > MAX_XP_PER_CALL then Add2 = MAX_XP_PER_CALL end

    -- Ignore whatever gang name the client sent; only ever credit the
    -- caller's own, server-known gang.
    local gang = xPlayer.gang.name
    UpdateXPALL(gang, Add2)
    Database(Add2, gang)
end)