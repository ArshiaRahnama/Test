ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local boomboxes = {}

local function getSoundId(src)
    return 'boombox_' .. src
end

local function getIdentifier(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return nil end
    return xPlayer.identifier
end

local function kvpKey(identifier)
    return 'boombox_data_' .. identifier
end

local function loadPlayerData(identifier)
    local raw = GetResourceKvpString(kvpKey(identifier))
    if not raw then
        return { history = {}, playlists = {} }
    end
    local ok, data = pcall(json.decode, raw)
    if not ok or type(data) ~= 'table' then
        return { history = {}, playlists = {} }
    end
    data.history = data.history or {}
    data.playlists = data.playlists or {}
    return data
end

local function savePlayerData(identifier, data)
    SetResourceKvp(kvpKey(identifier), json.encode(data))
end

local function addToHistory(identifier, link)
    local data = loadPlayerData(identifier)



    for i = #data.history, 1, -1 do
        if data.history[i].link == link then
            table.remove(data.history, i)
        end
    end

    table.insert(data.history, 1, { link = link, addedAt = os.time() })

    while #data.history > BoomConfig.MaxHistory do
        table.remove(data.history)
    end

    savePlayerData(identifier, data)
    return data
end

ESX.RegisterServerCallback('Im0ArSaBoom:getData', function(source, cb)
    local identifier = getIdentifier(source)
    if not identifier then return cb({ history = {}, playlists = {} }) end
    cb(loadPlayerData(identifier))
end)

ESX.RegisterServerCallback('Im0ArSaBoom:createPlaylist', function(source, cb, name)
    local identifier = getIdentifier(source)
    if not identifier then return cb(false, 'Error') end

    name = tostring(name or ''):sub(1, BoomConfig.MaxPlaylistNameLength):gsub('^%s+', ''):gsub('%s+$', '')
    if name == '' then return cb(false, 'Esm Khali !') end

    local data = loadPlayerData(identifier)
    if #data.playlists >= BoomConfig.MaxPlaylists then
        return cb(false, 'Tedad Playlist Ha Bishtar Az Had Ast !')
    end
    for _, pl in ipairs(data.playlists) do
        if pl.name == name then
            return cb(false, 'In Esm Ghablan Sakhte Shode !')
        end
    end

    table.insert(data.playlists, { name = name, songs = {} })
    savePlayerData(identifier, data)
    cb(true, data)
end)

ESX.RegisterServerCallback('Im0ArSaBoom:addToPlaylist', function(source, cb, playlistName, link)
    local identifier = getIdentifier(source)
    if not identifier then return cb(false, 'Error') end
    if not link or link == '' then return cb(false, 'Link Khali Ast !') end

    local data = loadPlayerData(identifier)
    for _, pl in ipairs(data.playlists) do
        if pl.name == playlistName then
            if #pl.songs >= BoomConfig.MaxPlaylistSongs then
                return cb(false, 'In Playlist Por Ast !')
            end
            table.insert(pl.songs, link)
            savePlayerData(identifier, data)
            return cb(true, data)
        end
    end
    cb(false, 'Playlist Peida Nashod !')
end)

ESX.RegisterServerCallback('Im0ArSaBoom:removeFromPlaylist', function(source, cb, playlistName, songIndex)
    local identifier = getIdentifier(source)
    if not identifier then return cb(false, 'Error') end

    local data = loadPlayerData(identifier)
    for _, pl in ipairs(data.playlists) do
        if pl.name == playlistName then
            if pl.songs[songIndex] then
                table.remove(pl.songs, songIndex)
                savePlayerData(identifier, data)
            end
            return cb(true, data)
        end
    end
    cb(false, 'Playlist Peida Nashod !')
end)

ESX.RegisterServerCallback('Im0ArSaBoom:deletePlaylist', function(source, cb, playlistName)
    local identifier = getIdentifier(source)
    if not identifier then return cb(false, 'Error') end

    local data = loadPlayerData(identifier)
    for i, pl in ipairs(data.playlists) do
        if pl.name == playlistName then
            table.remove(data.playlists, i)
            savePlayerData(identifier, data)
            return cb(true, data)
        end
    end
    cb(false, 'Playlist Peida Nashod !')
end)

ESX.RegisterUsableItem(BoomConfig.ItemName, function(source)
    TriggerClientEvent('Im0ArSaBoom:use', source)
end)

RegisterServerEvent('Im0ArSaBoom:playMusic')
AddEventHandler('Im0ArSaBoom:playMusic', function(link, coords, volume, distance)
    local src = source
    local soundId = getSoundId(src)
    boomboxes[src] = { soundId = soundId, link = link, coords = coords, volume = volume, distance = distance }
    TriggerClientEvent('Im0ArSaBoom:playMusic', -1, soundId, link, coords, volume, distance)

    local identifier = getIdentifier(src)
    if identifier then
        addToHistory(identifier, link)
    end
end)

RegisterServerEvent('Im0ArSaBoom:setVolume')
AddEventHandler('Im0ArSaBoom:setVolume', function(volume, distance)
    local src = source
    local soundId = getSoundId(src)
    if boomboxes[src] then
        boomboxes[src].volume = volume
        boomboxes[src].distance = distance
    end
    TriggerClientEvent('Im0ArSaBoom:setVolume', -1, soundId, volume, distance)
end)

RegisterServerEvent('Im0ArSaBoom:setDistance')
AddEventHandler('Im0ArSaBoom:setDistance', function(distance)
    local src = source
    local soundId = getSoundId(src)
    if boomboxes[src] then
        boomboxes[src].distance = distance
    end
    TriggerClientEvent('Im0ArSaBoom:setDistance', -1, soundId, distance)
end)

RegisterServerEvent('Im0ArSaBoom:stopMusic')
AddEventHandler('Im0ArSaBoom:stopMusic', function()
    local src = source
    local soundId = getSoundId(src)
    TriggerClientEvent('Im0ArSaBoom:stopMusic', -1, soundId)
    boomboxes[src] = nil
end)

RegisterServerEvent('Im0ArSaBoom:updatePosition')
AddEventHandler('Im0ArSaBoom:updatePosition', function(coords)
    local src = source
    local soundId = getSoundId(src)
    if boomboxes[src] then
        boomboxes[src].coords = coords
    end
    TriggerClientEvent('Im0ArSaBoom:updatePosition', -1, soundId, coords)
end)

AddEventHandler('playerDropped', function()
    local src = source
    if boomboxes[src] then
        TriggerClientEvent('Im0ArSaBoom:stopMusic', -1, getSoundId(src))
        boomboxes[src] = nil
    end
end)
