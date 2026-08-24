

ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
end)

local currentItemId    = nil
local currentItemType  = nil
local currentItemName  = nil
local currentModelId   = nil

local function ResetCurrentItem()
    currentItemId   = nil
    currentItemType = nil
    currentItemName = nil
    currentModelId  = nil
end

local function HasJob(list)
    if not ESX or not ESX.PlayerData or not ESX.PlayerData.job then return false end
    for _, job in ipairs(list) do
        if ESX.PlayerData.job.name == job then return true end
    end
    return false
end

local function IsFlagTrue(v)
    return v == true or v == 1 or v == "1"
end

local function KeyboardInput(title, default)




    IconMenu.ForceCloseMenu()

    default = default or ""
    AddTextEntry('DOC_KB_ENTRY', title)
    DisplayOnscreenKeyboard(1, 'DOC_KB_ENTRY', "", default, "", "", "", 128)

    local status = 0
    while status == 0 do
        status = UpdateOnscreenKeyboard()
        Wait(0)
    end



    Wait(300)

    if status == 1 then
        return GetOnscreenKeyboardResult()
    end
    return nil
end

local function GetClosestPlayer()
    local closestDistance = -1
    local closestPlayer   = -1
    local myCoords = GetEntityCoords(PlayerPedId())

    for _, player in ipairs(GetActivePlayers()) do
        if player ~= PlayerId() then
            local dist = #(myCoords - GetEntityCoords(GetPlayerPed(player)))
            if closestDistance == -1 or dist < closestDistance then
                closestDistance = dist
                closestPlayer   = player
            end
        end
    end

    return closestPlayer, closestDistance
end

RegisterNetEvent('Documents:notify')
AddEventHandler('Documents:notify', function(msg)
    ESX.ShowNotification(msg)
end)

local function PushConfigToNUI()
    SendNUIMessage({
        config       = true,
        translate    = translate,
        NameResource = GetCurrentResourceName(),
        logo         = logo,
    })
end

local function OpenNUI(kind, infos_document)
    IconMenu.ForceCloseMenu()
    SetNuiFocus(true, true)
    PushConfigToNUI()

    local msg = {}
    msg[kind] = true
    if infos_document ~= nil then
        msg.infos_document = infos_document
    end
    SendNUIMessage(msg)
end

RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    ResetCurrentItem()
    cb('ok')
end)

RegisterNUICallback('getdata', function(_, cb)
    local fullName = GetPlayerName(PlayerId())
    local jobLabel, gradeLabel = "", ""

    if ESX and ESX.PlayerData then
        if ESX.PlayerData.firstName then
            fullName = ESX.PlayerData.firstName .. " " .. (ESX.PlayerData.lastName or "")
        end
        if ESX.PlayerData.job then
            jobLabel   = ESX.PlayerData.job.label       or ""
            gradeLabel = ESX.PlayerData.job.grade_label or ""
        end
    end

    cb({
        name = fullName,
        job  = { label = jobLabel, grade_label = gradeLabel },
    })
end)

RegisterNUICallback('saveModel', function(data, cb)
    TriggerServerEvent('Documents:saveModel', currentItemId, currentItemName, data.infos_document)
    SetNuiFocus(false, false)
    ResetCurrentItem()
    cb('ok')
end)

RegisterNUICallback('saveDocument', function(data, cb)
    TriggerServerEvent('Documents:saveDocument', currentItemId, currentItemName, currentModelId, data.infos_document)
    SetNuiFocus(false, false)
    ResetCurrentItem()
    cb('ok')
end)

local function GiveDocument(docId)
    local player, distance = GetClosestPlayer()
    if player == -1 or distance > 3.0 then
        ESX.ShowNotification(translate.TR_NOONE)
        return
    end
    TriggerServerEvent('Documents:giveDocument', docId, GetPlayerServerId(player))
end

local function RequestOpen(docType, id, mode)
    ESX.TriggerServerCallback('Documents:openItem', function(res)
        if not res then
            ESX.ShowNotification(translate.TR_NOT_PERMISSION)
            return
        end

        currentItemId   = id
        currentItemType = docType
        currentItemName = res.name
        currentModelId  = res.model_id

        if mode == 'view' then
            OpenNUI('openViewDocument', res.infos_document)
        elseif docType == 'model' then
            OpenNUI('openEditModel', res.infos_document)
        else
            OpenNUI('openEditDocument', res.infos_document)
        end
    end, docType, id)
end

local OpenListMenu

local function PromptCreate(docType)
    if docType == 'model' then
        local name = KeyboardInput(translate.TR_CREATE4)
        if not name or name == '' then return end

        ResetCurrentItem()
        currentItemType = 'model'
        currentItemName = name

        OpenNUI('openCreateModel', nil)
        return
    end


    OpenListMenu('model', nil, function(modelRow)
        ESX.TriggerServerCallback('Documents:openItem', function(res)
            if not res then
                ESX.ShowNotification(translate.TR_NOT_PERMISSION)
                return
            end

            local name = KeyboardInput(translate.TR_CREATE4, modelRow.name)
            if not name or name == '' then return end

            ResetCurrentItem()
            currentItemType = 'document'
            currentItemName = name
            currentModelId  = modelRow.id

            res.infos_document.name = nil
            OpenNUI('openCreateDocument', res.infos_document)
        end, 'model', modelRow.id)
    end)
end

local function OpenItemActions(docType, row)
    local items = {}
    local isCopy = docType == 'document' and IsFlagTrue(row.is_copy)

    table.insert(items, {
        img = "document.png", text = translate.TR_OPEN, text2 = translate.TR_OPEN2 .. row.name,
        callBack = function() RequestOpen(docType, row.id, 'view') end,
    })

    if not isCopy then
        local canEdit = (docType == 'model' and HasJob(jobs_SaveTemplate))
            or (docType == 'document' and HasJob(jobs_CreateDocument))

        if canEdit and not IsFlagTrue(row.closed) then
            table.insert(items, {
                img = "edit.png",
                text = translate.TR_EDIT,
                text2 = (docType == 'model' and translate.TR_EDIT2 or translate.TR_EDIT3) .. row.name,
                callBack = function() RequestOpen(docType, row.id, 'edit') end,
            })
        end

        if docType == 'document' then
            if HasJob(jobs_CloseDocument) and not IsFlagTrue(row.closed) then
                table.insert(items, {
                    img = "close.png", text = translate.TR_CLOSE, text2 = translate.TR_CLOSE2 .. row.name,
                    callBack = function()
                        TriggerServerEvent('Documents:closeDocument', row.id)
                        OpenListMenu(docType)
                    end,
                })
            end

            if HasJob(jobs_CopyDocument) then
                table.insert(items, {
                    img = "copy.png", text = translate.TR_COPY, text2 = translate.TR_COPY2 .. row.name,
                    callBack = function()
                        TriggerServerEvent('Documents:copyDocument', row.id)
                        OpenListMenu(docType)
                    end,
                })
            end

            if HasJob(jobs_GiveDocument) then
                table.insert(items, {
                    img = "give.png", text = translate.TR_GIVE, text2 = translate.TR_GIVE2,
                    callBack = function() GiveDocument(row.id) end,
                })
            end
        end
    end

    if HasJob(jobs_DeleteDocument) then
        table.insert(items, {
            img = "delete.png",
            text = translate.TR_DELETE,
            text2 = (docType == 'model' and translate.TR_DELETE2 or translate.TR_DELETE3) .. row.name,
            callBack = function()
                TriggerServerEvent('Documents:deleteItem', docType, row.id)
                OpenListMenu(docType)
            end,
        })
    end

    table.insert(items, {
        img = "back.png", text = translate.TR_BACK, text2 = translate.TR_BACK3,
        isBack = true,
        callBack = function() OpenListMenu(docType) end,
    })

    IconMenu.OpenMenu(items)
end

OpenListMenu = function(docType, search, pickCallback)
    ESX.TriggerServerCallback('Documents:getLists', function(rows)
        local items = {}

        local canCreate = (docType == 'model' and HasJob(jobs_SaveTemplate))
            or (docType == 'document' and HasJob(jobs_CreateDocument))
        if canCreate then
            table.insert(items, {
                img = "create.png",
                text = (docType == 'model' and translate.TR_CREATE2 or translate.TR_CREATE3),
                text2 = "",
                callBack = function() PromptCreate(docType) end,
            })
        end

        table.insert(items, {
            img = "search.png", text = translate.TR_SEARCH, text2 = translate.TR_SEARCH2,
            callBack = function()
                local term = KeyboardInput(translate.TR_SEARCH_KEYBOARD, search or "")
                OpenListMenu(docType, term, pickCallback)
            end,
        })

        if #rows == 0 then
            table.insert(items, {
                img = "stop.png", text = translate.TR_NOT_DOCUMENTS, text2 = "",
                callBack = function() OpenListMenu(docType, search, pickCallback) end,
            })
        end

        for _, row in ipairs(rows) do
            local label = row.name
            if docType == 'document' and IsFlagTrue(row.closed) then
                label = label .. "  (" .. translate.TR_CLOSE .. ")"
            end
            table.insert(items, {
                img = "document.png", text = label, text2 = "",
                callBack = function()
                    if pickCallback then
                        pickCallback(row)
                    else
                        OpenItemActions(docType, row)
                    end
                end,
            })
        end

        table.insert(items, {
            img = "back.png", text = translate.TR_BACK, text2 = translate.TR_BACK2,
            isBack = true,
            callBack = function()
                if pickCallback then return end
                OpenRootMenu()
            end,
        })

        IconMenu.OpenMenu(items)
    end, docType, search)
end

function OpenRootMenu()
    IconMenu.OpenMenu({
        {
            img = "folder.png", text = translate.TR_VIEW_MODELS, text2 = translate.TR_VIEW_MODELS2,
            callBack = function() OpenListMenu('model') end,
        },
        {
            img = "archive.png", text = translate.TR_VIEW_DOCUMENTS, text2 = translate.TR_VIEW_DOCUMENTS2,
            callBack = function() OpenListMenu('document') end,
        },
    })
end

RegisterCommand('documents_openmenu', function()
    OpenRootMenu()
end, false)
RegisterKeyMapping('documents_openmenu', 'Open Official Documents Menu', 'keyboard', 'F9')

RegisterCommand('mydocuments', function()
    ESX.TriggerServerCallback('Documents:getMyDocuments', function(rows)
        if #rows == 0 then
            ESX.ShowNotification(translate.TR_NOT_DOCUMENTS)
            return
        end

        local items = {}
        for _, row in ipairs(rows) do
            table.insert(items, {
                img = "document.png", text = row.name, text2 = translate.TR_OPEN2 .. row.name,
                callBack = function()
                    ESX.TriggerServerCallback('Documents:openMyDocument', function(res)
                        if not res then return end
                        currentItemId   = row.id
                        currentItemType = 'document'
                        OpenNUI('openViewDocument', res.infos_document)
                    end, row.id)
                end,
            })
        end
        IconMenu.OpenMenu(items)
    end)
end, false)

RegisterNetEvent('Documents:notifyReceived')
AddEventHandler('Documents:notifyReceived', function()
    ESX.ShowNotification(translate.TR_RECEIVE)
end)
