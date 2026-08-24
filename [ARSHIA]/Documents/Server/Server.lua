

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local function HasJob(xPlayer, list)
    if not xPlayer or not xPlayer.job then return false end
    for _, job in ipairs(list) do
        if xPlayer.job.name == job then return true end
    end
    return false
end

local function SafeDecode(str)
    if not str or str == '' then return {} end
    local ok, decoded = pcall(json.decode, str)
    if ok and decoded then return decoded end
    return {}
end

local function IsFlagTrue(v)
    return v == true or v == 1 or v == "1"
end

ESX.RegisterServerCallback('Documents:getLists', function(source, cb, docType, search)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb({}) return end

    local table_name = (docType == 'model') and 'sunset_doc_models' or 'sunset_documents'
    local sql = 'SELECT id, name'
        .. (docType == 'document' and ', closed, is_copy' or ', 0 as closed, 0 as is_copy')
        .. ' FROM ' .. table_name
        .. (docType == 'document' and ' WHERE owner IS NULL' or '')

    local params = {}
    if search and search ~= '' then
        sql = sql .. (docType == 'document' and ' AND ' or ' WHERE ') .. 'name LIKE @search'
        params['@search'] = '%' .. search .. '%'
    end
    sql = sql .. ' ORDER BY id DESC LIMIT 40'

    local rows = MySQL.Sync.fetchAll(sql, params) or {}
    cb(rows)
end)

ESX.RegisterServerCallback('Documents:openItem', function(source, cb, docType, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb(nil) return end

    local table_name = (docType == 'model') and 'sunset_doc_models' or 'sunset_documents'
    local rows = MySQL.Sync.fetchAll('SELECT * FROM ' .. table_name .. ' WHERE id = @id', { ['@id'] = id })
    local row = rows and rows[1]
    if not row then cb(nil) return end

    local infos_document = {
        date       = row.date or '',
        title      = row.title or '',
        text       = row.text or '',
        images     = SafeDecode(row.images),
        signatures = SafeDecode(row.signatures),
    }

    if docType == 'model' then


        infos_document.name = 'model'
    end

    cb({
        name          = row.name,
        model_id      = row.model_id,
        closed        = row.closed,
        infos_document = infos_document,
    })
end)

RegisterNetEvent('Documents:saveModel')
AddEventHandler('Documents:saveModel', function(id, name, infos_document)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not HasJob(xPlayer, jobs_SaveTemplate) then return end
    if type(infos_document) ~= 'table' then return end

    infos_document.name = nil

    local params = {
        ['@date']       = infos_document.date or '',
        ['@title']      = infos_document.title or '',
        ['@text']       = infos_document.text or '',
        ['@images']     = json.encode(infos_document.images or {}),
        ['@signatures'] = json.encode(infos_document.signatures or {}),
    }

    if id then
        params['@id'] = id
        MySQL.Sync.execute([[
            UPDATE sunset_doc_models
            SET date=@date, title=@title, text=@text, images=@images, signatures=@signatures
            WHERE id=@id
        ]], params)
        TriggerClientEvent('Documents:notify', src, translate.TR_UPDATED_TEMPLATE)
    else
        params['@name']    = name or 'Model'
        params['@creator'] = xPlayer.identifier
        MySQL.Sync.insert([[
            INSERT INTO sunset_doc_models (name, date, title, text, images, signatures, creator)
            VALUES (@name, @date, @title, @text, @images, @signatures, @creator)
        ]], params)
        TriggerClientEvent('Documents:notify', src, translate.TR_CREATED_TEMPLATE)
    end
end)

RegisterNetEvent('Documents:saveDocument')
AddEventHandler('Documents:saveDocument', function(id, name, modelId, infos_document)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not HasJob(xPlayer, jobs_CreateDocument) then return end
    if type(infos_document) ~= 'table' then return end

    local params = {
        ['@date']       = infos_document.date or '',
        ['@title']      = infos_document.title or '',
        ['@text']       = infos_document.text or '',
        ['@images']     = json.encode(infos_document.images or {}),
        ['@signatures'] = json.encode(infos_document.signatures or {}),
    }

    if id then
        params['@id'] = id
        MySQL.Sync.execute([[
            UPDATE sunset_documents
            SET date=@date, title=@title, text=@text, images=@images, signatures=@signatures, updated_at=NOW()
            WHERE id=@id AND owner IS NULL AND closed=0 AND is_copy=0
        ]], params)
        TriggerClientEvent('Documents:notify', src, translate.TR_UPDATED_DOCUMENT)
    else
        params['@name']     = name or 'Document'
        params['@model_id'] = modelId
        params['@creator']  = xPlayer.identifier
        MySQL.Sync.insert([[
            INSERT INTO sunset_documents (name, model_id, date, title, text, images, signatures, creator)
            VALUES (@name, @model_id, @date, @title, @text, @images, @signatures, @creator)
        ]], params)
        TriggerClientEvent('Documents:notify', src, translate.TR_CREATED_DOCUMENT)
    end
end)

RegisterNetEvent('Documents:closeDocument')
AddEventHandler('Documents:closeDocument', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not HasJob(xPlayer, jobs_CloseDocument) then return end

    MySQL.Sync.execute('UPDATE sunset_documents SET closed = 1 WHERE id = @id AND owner IS NULL AND is_copy = 0', { ['@id'] = id })
    TriggerClientEvent('Documents:notify', src, translate.TR_CLOSED_DOCUMENT)
end)

RegisterNetEvent('Documents:copyDocument')
AddEventHandler('Documents:copyDocument', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not HasJob(xPlayer, jobs_CopyDocument) then return end

    local rows = MySQL.Sync.fetchAll('SELECT * FROM sunset_documents WHERE id = @id AND owner IS NULL', { ['@id'] = id })
    local row = rows and rows[1]
    if not row then return end
    if IsFlagTrue(row.is_copy) then return end

    MySQL.Sync.insert([[
        INSERT INTO sunset_documents (name, model_id, date, title, text, images, signatures, closed, is_copy, creator)
        VALUES (@name, @model_id, @date, @title, @text, @images, @signatures, 1, 1, @creator)
    ]], {
        ['@name']       = translate.TR_COPY3 .. (row.name or ''),
        ['@model_id']   = row.model_id,
        ['@date']       = row.date,
        ['@title']      = row.title,
        ['@text']       = row.text,
        ['@images']     = row.images,
        ['@signatures'] = row.signatures,
        ['@creator']    = xPlayer.identifier,
    })

    TriggerClientEvent('Documents:notify', src, translate.TR_COPIED_DOCUMENT)
end)

RegisterNetEvent('Documents:giveDocument')
AddEventHandler('Documents:giveDocument', function(id, targetId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(targetId)
    if not HasJob(xPlayer, jobs_GiveDocument) or not xTarget then return end


    local srcPed, tgtPed = GetPlayerPed(src), GetPlayerPed(targetId)
    if srcPed == 0 or tgtPed == 0 then return end
    local dist = #(GetEntityCoords(srcPed) - GetEntityCoords(tgtPed))
    if dist > 4.0 then return end

    local rows = MySQL.Sync.fetchAll('SELECT * FROM sunset_documents WHERE id = @id AND owner IS NULL', { ['@id'] = id })
    local row = rows and rows[1]
    if not row then return end

    MySQL.Sync.insert([[
        INSERT INTO sunset_documents (name, model_id, date, title, text, images, signatures, closed, creator, owner)
        VALUES (@name, @model_id, @date, @title, @text, @images, @signatures, 1, @creator, @owner)
    ]], {
        ['@name']       = row.name,
        ['@model_id']   = row.model_id,
        ['@date']       = row.date,
        ['@title']      = row.title,
        ['@text']       = row.text,
        ['@images']     = row.images,
        ['@signatures'] = row.signatures,
        ['@creator']    = xPlayer.identifier,
        ['@owner']      = xTarget.identifier,
    })

    TriggerClientEvent('Documents:notify', src, translate.TR_GIVE_DOCUMENT)
    TriggerClientEvent('Documents:notifyReceived', targetId)
end)

RegisterNetEvent('Documents:deleteItem')
AddEventHandler('Documents:deleteItem', function(docType, id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not HasJob(xPlayer, jobs_DeleteDocument) then return end

    local table_name = (docType == 'model') and 'sunset_doc_models' or 'sunset_documents'
    local extra = (docType == 'document') and ' AND owner IS NULL' or ''
    MySQL.Sync.execute('DELETE FROM ' .. table_name .. ' WHERE id = @id' .. extra, { ['@id'] = id })

    TriggerClientEvent('Documents:notify', src, translate.TR_DELETED_DOCUMENT)
end)

ESX.RegisterServerCallback('Documents:getMyDocuments', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb({}) return end

    local rows = MySQL.Sync.fetchAll(
        'SELECT id, name FROM sunset_documents WHERE owner = @owner ORDER BY id DESC LIMIT 40',
        { ['@owner'] = xPlayer.identifier }
    ) or {}
    cb(rows)
end)

ESX.RegisterServerCallback('Documents:openMyDocument', function(source, cb, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb(nil) return end

    local rows = MySQL.Sync.fetchAll(
        'SELECT * FROM sunset_documents WHERE id = @id AND owner = @owner',
        { ['@id'] = id, ['@owner'] = xPlayer.identifier }
    )
    local row = rows and rows[1]
    if not row then cb(nil) return end

    cb({
        infos_document = {
            date       = row.date or '',
            title      = row.title or '',
            text       = row.text or '',
            images     = SafeDecode(row.images),
            signatures = SafeDecode(row.signatures),
        },
    })
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    print('^3Arshia Say :^7 [arshiahub.ir] Documents System Fix.')
end)

CreateThread(function()
    MySQL.Sync.execute([[
        CREATE TABLE IF NOT EXISTS `sunset_doc_models` (
            `id`         INT NOT NULL AUTO_INCREMENT,
            `name`       VARCHAR(100) NOT NULL,
            `date`       VARCHAR(50)  DEFAULT '',
            `title`      VARCHAR(150) DEFAULT '',
            `text`       LONGTEXT,
            `images`     LONGTEXT,
            `signatures` LONGTEXT,
            `creator`    VARCHAR(64)  DEFAULT NULL,
            `created_at` DATETIME     DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        )
    ]])

    MySQL.Sync.execute([[
        CREATE TABLE IF NOT EXISTS `sunset_documents` (
            `id`         INT NOT NULL AUTO_INCREMENT,
            `name`       VARCHAR(100) NOT NULL,
            `model_id`   INT          DEFAULT NULL,
            `date`       VARCHAR(50)  DEFAULT '',
            `title`      VARCHAR(150) DEFAULT '',
            `text`       LONGTEXT,
            `images`     LONGTEXT,
            `signatures` LONGTEXT,
            `closed`     TINYINT(1)   NOT NULL DEFAULT 0,
            `is_copy`    TINYINT(1)   NOT NULL DEFAULT 0,
            `creator`    VARCHAR(64)  DEFAULT NULL,
            `owner`      VARCHAR(64)  DEFAULT NULL,
            `created_at` DATETIME     DEFAULT CURRENT_TIMESTAMP,
            `updated_at` DATETIME     DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        )
    ]])



    local colCheck = MySQL.Sync.fetchAll([[
        SELECT COUNT(*) as cnt FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sunset_documents' AND COLUMN_NAME = 'is_copy'
    ]])
    local hasColumn = colCheck and colCheck[1] and tonumber(colCheck[1].cnt) == 1

    if not hasColumn then
        MySQL.Sync.execute("ALTER TABLE `sunset_documents` ADD COLUMN `is_copy` TINYINT(1) NOT NULL DEFAULT 0")

        local recheck = MySQL.Sync.fetchAll([[
            SELECT COUNT(*) as cnt FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'sunset_documents' AND COLUMN_NAME = 'is_copy'
        ]])
        if recheck and recheck[1] and tonumber(recheck[1].cnt) == 1 then
            print('[Documents] is_copy column added successfully.')
        else
            print('[Documents] ERROR: failed to add is_copy column! Run install.sql manually against your database.')
        end
    end

    MySQL.Sync.execute(
        "UPDATE `sunset_documents` SET `is_copy` = 1, `closed` = 1 WHERE `name` LIKE '%کپی برابر اصل%' AND `is_copy` = 0"
    )
end)
