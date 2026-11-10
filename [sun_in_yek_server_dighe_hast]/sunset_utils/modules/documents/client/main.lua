-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local MODULE = 'documents'

local panelOpen = false
local lastMenuSettings = nil

local menuCallbacks = {}
local activeSearch = nil
local confirmCallbacks = {}
local confirmSeq = 0

local documentsCache = nil
local archiveCache = nil
local archivePagination = { page = 1, totalPages = 0, total = 0, search = '' }

local navStack = {}
local loadArchivePage
local screenMain
local screenBlacklist

local function inList(list, value)
    if not list then return false end
    for i = 1, #list do
        if list[i] == value then return true end
    end
    return false
end

local function buildConfig()
    return {
        translate    = DocumentsConfig.Translate,
        NameResource = GetCurrentResourceName(),
        logo         = DocumentsConfig.Logo,
        header       = DocumentsConfig.Translate.TR_HEADER,
        subheader    = DocumentsConfig.Translate.TR_SUBHEADER,
        watermark    = DocumentsConfig.WatermarkText,
        menuSettings = lastMenuSettings,
    }
end

local function sendToUI(msg)
    if not panelOpen then
        panelOpen = true
        SUN.OpenUI(MODULE, { config = buildConfig(), msg = msg }, { type = 'panel' })
    else
        SUN.SendUIData(MODULE, msg)
    end
end

local function closeAll()
    menuCallbacks = {}
    activeSearch = nil
    navStack = {}
    if panelOpen then
        panelOpen = false
        SUN.CloseUI(MODULE)
    end
end

AddEventHandler('sunset_utils:uiClosed', function(name)
    if name == MODULE then
        panelOpen = false
        menuCallbacks = {}
        activeSearch = nil
        navStack = {}
    end
end)

AddEventHandler('sun_menu:settings', function(settings)
    lastMenuSettings = settings
    if panelOpen then
        SUN.SendUIData(MODULE, { action = 'setMenuSettings', settings = settings })
    end
end)

local function pdata()
    return ESX.GetPlayerData() or {}
end

local function isAdmin()
    return pdata().admin == 1
end

local function jobName()
    local d = pdata()
    return d.job and d.job.name or 'nojob'
end

local function jobGrade()
    local d = pdata()
    return d.job and d.job.grade or 0
end

local function isJusticeChief()
    if isAdmin() then return true end
    if jobName() ~= DocumentsConfig.JusticeJob then return false end
    return jobGrade() >= DocumentsConfig.JusticeChiefGrade
end

local function isJusticeJob()
    if isAdmin() then return true end
    if jobName() ~= DocumentsConfig.JusticeJob then return false end
    return jobGrade() >= (DocumentsConfig.JusticeMinGrade or 0)
end

local function justicePerm(key)
    if (pdata().job and pdata().job.grade_name) == 'boss' then return true end
    return exports['sun-society']:doesHavePerm(key) and true or false
end

local function canCreateTemplate()
    if isAdmin() then return true end
    if jobName() == DocumentsConfig.JusticeJob then return justicePerm('docTemplate') end
    if jobGrade() >= DocumentsConfig.ModelEditorMinGrade then return true end
    return inList(DocumentsConfig.Jobs.SaveTemplate, jobName())
end

local function canCreateJobDoc()
    if isAdmin() then return true end
    if not inList(DocumentsConfig.Jobs.CreateDocument, jobName()) then return false end
    if jobName() == DocumentsConfig.JusticeJob then return justicePerm('docCreate') end
    return true
end

local function canDeleteDoc()
    if isAdmin() then return true end
    if not inList(DocumentsConfig.Jobs.DeleteDocument, jobName()) then return false end
    if jobName() == DocumentsConfig.JusticeJob then return justicePerm('docDelete') end
    return true
end

local function canPublishTemplate()
    if isAdmin() then return true end
    if jobName() ~= DocumentsConfig.JusticeJob then return false end
    return justicePerm('docPublicTemplate')
end

local function canSeal()
    if isAdmin() then return true end
    if jobName() ~= DocumentsConfig.JusticeJob then return false end
    return justicePerm('docSeal')
end

local function canManageBlacklist()
    if not DocumentsConfig.Blacklist or not DocumentsConfig.Blacklist.Enabled then return false end
    return isJusticeChief()
end

local function canAccessArchive()
    if isJusticeChief() then return true end
    if jobName() == DocumentsConfig.JusticeJob then return justicePerm('docArchive') end
    return false
end

local function formatTimestamp(unix)
    if not unix or unix == 0 then return '-' end
    local now = GetCloudTimeAsInt()
    if not now or now == 0 then return '-' end
    local diff = now - unix
    if diff < 0 then return '-' end
    if diff < 60 then return ('%d ثانیه پیش'):format(diff) end
    if diff < 3600 then return ('%d دقیقه پیش'):format(math.floor(diff / 60)) end
    if diff < 86400 then return ('%d ساعت پیش'):format(math.floor(diff / 3600)) end
    return ('%d روز پیش'):format(math.floor(diff / 86400))
end

local function decodeDoc(k)
    k.images = type(k.images) == 'string' and json.decode(k.images) or k.images or {}
    k.signatures = type(k.signatures) == 'string' and json.decode(k.signatures) or k.signatures or {}
    k.text = k.scope
    return k
end

local function trimScope(scope)
    if scope and #scope > 60 then
        return string.sub(scope, 1, 60) .. '...'
    end
    return scope or ''
end

local function showMenu(opts)
    menuCallbacks = {}
    activeSearch = opts.onSearch
    local displayItems = {}

    for i, item in ipairs(opts.items or {}) do
        menuCallbacks[i] = item.callBack
        displayItems[i] = {
            id = i,
            icon = item.icon or 'document',
            text = item.text or '',
            text2 = item.text2 or '',
            badge = item.badge,
            variant = item.variant or 'default',
        }
    end

    sendToUI({
        action = 'showMenu',
        title = opts.title or DocumentsConfig.Translate.TR_MENU_MAIN,
        subtitle = opts.subtitle,
        items = displayItems,
        showSearch = opts.showSearch and true or false,
        searchPlaceholder = opts.searchPlaceholder or DocumentsConfig.Translate.TR_SEARCH_PLACEHOLDER,
        emptyText = opts.emptyText or DocumentsConfig.Translate.TR_NO_RESULTS,
    })
end

local function showLoading()
    showMenu({
        title = DocumentsConfig.Translate.TR_LOADING,
        subtitle = DocumentsConfig.Translate.TR_LOADING2,
        items = {
            { icon = 'loading', text = DocumentsConfig.Translate.TR_LOADING, text2 = DocumentsConfig.Translate.TR_LOADING2, variant = 'loading' }
        }
    })
end

local function navRender()
    local fn = navStack[#navStack]
    if fn then fn() end
end

local function navTo(fn)
    navStack[#navStack + 1] = fn
    fn()
end

local function navRoot(fn)
    navStack = { fn }
    fn()
end

local function navBack()
    if #navStack > 1 then
        navStack[#navStack] = nil
        navRender()
    else
        closeAll()
    end
end

local function backItem(label2)
    return {
        icon = 'back',
        text = DocumentsConfig.Translate.TR_BACK,
        text2 = label2 or DocumentsConfig.Translate.TR_BACK2,
        variant = 'back',
        callBack = navBack,
    }
end

local function openEditor(payload)
    local d = pdata()
    local job = d.job or {}
    payload.me = {
        name = (d.name or ''):gsub('_', ' '),
        identifier = d.identifier,
        job = { label = job.label, grade_label = job.grade_label },
    }
    payload.canPublish = canPublishTemplate()
    payload.isJustice = canSeal()
    menuCallbacks = {}
    sendToUI({ action = 'hideMenu' })
    sendToUI(payload)
end

local function askConfirm(message, onYes)
    confirmSeq = confirmSeq + 1
    local token = confirmSeq
    confirmCallbacks[token] = onYes
    sendToUI({ action = 'confirm', message = message, token = token })
end

local function giveDocument(doc)
    local payload = decodeDoc(doc)
    closeAll()
    ESX.selectPlayerMenu(function(targetSrc)
        if not targetSrc then return end
        ESX.TriggerServerEvent('Documents:GiveDocument', targetSrc, payload)
    end, DocumentsConfig.GiveRadius)
end

local function returnHome()
    navRoot(screenMain)
end

local function afterAction()
    showLoading()
    SetTimeout(1200, returnHome)
end

screenMain = function()
    local items = {}

    items[#items + 1] = {
        icon = 'archive',
        text = DocumentsConfig.Translate.TR_VIEW_DOCUMENTS,
        text2 = DocumentsConfig.Translate.TR_VIEW_DOCUMENTS2,
        callBack = function()
            showLoading()
            ESX.TriggerServerEvent('Documents:viewDocuments')
        end
    }

    items[#items + 1] = {
        icon = 'public',
        text = DocumentsConfig.Translate.TR_PUBLIC_CREATE,
        text2 = DocumentsConfig.Translate.TR_PUBLIC_CREATE_DESC,
        variant = 'gold',
        callBack = function()
            showLoading()
            ESX.TriggerServerEvent('Documents:loadPublicModels')
        end
    }

    if canCreateJobDoc() then
        items[#items + 1] = {
            icon = 'add-file',
            text = DocumentsConfig.Translate.TR_CREATE,
            text2 = DocumentsConfig.Translate.TR_CREATE3,
            variant = 'gold',
            callBack = function()
                showLoading()
                ESX.TriggerServerEvent('Documents:loadModels')
            end
        }
    end

    if canCreateTemplate() then
        items[#items + 1] = {
            icon = 'create',
            text = DocumentsConfig.Translate.TR_CREATE,
            text2 = DocumentsConfig.Translate.TR_CREATE2,
            badge = DocumentsConfig.Translate.TR_NEW_BADGE,
            variant = 'primary',
            callBack = function()
                openEditor({ openTemplateChooser = true })
            end
        }
        items[#items + 1] = {
            icon = 'folder',
            text = DocumentsConfig.Translate.TR_MANAGE_MODELS,
            text2 = DocumentsConfig.Translate.TR_MANAGE_MODELS_DESC,
            callBack = function()
                showLoading()
                ESX.TriggerServerEvent('Documents:viewModels2')
            end
        }
    end

    if canAccessArchive() then
        items[#items + 1] = {
            icon = 'archive-vault',
            text = DocumentsConfig.Translate.TR_MENU_ARCHIVE,
            text2 = DocumentsConfig.Translate.TR_MENU_ARCHIVE_DESC,
            variant = 'gold',
            callBack = function()
                loadArchivePage(1, '')
            end
        }
    end

    if canManageBlacklist() then
        items[#items + 1] = {
            icon = 'shield',
            text = DocumentsConfig.Translate.TR_MENU_BLACKLIST_MGMT,
            text2 = DocumentsConfig.Translate.TR_MENU_BLACKLIST_MGMT_DESC,
            variant = 'danger',
            callBack = function()
                navTo(screenBlacklist)
            end
        }
    end

    showMenu({
        title = DocumentsConfig.Translate.TR_MENU_MAIN,
        subtitle = DocumentsConfig.Translate.TR_TITLE,
        items = items,
    })
end

local function renderDocOptions(doc)
    local options = { backItem(DocumentsConfig.Translate.TR_BACK5) }
    local displayName = (doc.name or '') .. ' '

    if doc.isopen == 1 then
        options[#options + 1] = {
            icon = 'edit', text = DocumentsConfig.Translate.TR_EDIT, text2 = displayName .. DocumentsConfig.Translate.TR_EDIT3, variant = 'primary',
            callBack = function()
                openEditor({ openEditDocument = true, infos_document = decodeDoc(doc) })
            end
        }
        options[#options + 1] = {
            icon = 'close', text = DocumentsConfig.Translate.TR_CLOSE, text2 = displayName .. DocumentsConfig.Translate.TR_CLOSE2, variant = 'gold',
            callBack = function()
                askConfirm(DocumentsConfig.Translate.TR_CONFIRM_CLOSE, function()
                    ESX.TriggerServerEvent('Documents:CloseDocument', decodeDoc(doc))
                    afterAction()
                end)
            end
        }
    else
        options[#options + 1] = {
            icon = 'document', text = DocumentsConfig.Translate.TR_OPEN, text2 = displayName .. DocumentsConfig.Translate.TR_OPEN2, variant = 'primary',
            callBack = function()
                openEditor({ openViewDocument = true, infos_document = decodeDoc(doc) })
            end
        }

        if doc.name and not doc.name:find(DocumentsConfig.Translate.TR_COPY3) then
            options[#options + 1] = {
                icon = 'copy', text = DocumentsConfig.Translate.TR_COPY, text2 = displayName .. DocumentsConfig.Translate.TR_COPY2,
                callBack = function()
                    local src = decodeDoc(doc)
                    local copy = {}
                    for key, val in pairs(src) do copy[key] = val end
                    copy.name = DocumentsConfig.Translate.TR_COPY3 .. (copy.name or '')
                    ESX.TriggerServerEvent('Documents:CreateCopyDocument', copy)
                    afterAction()
                end
            }
        end
    end

    options[#options + 1] = {
        icon = 'give', text = DocumentsConfig.Translate.TR_GIVE, text2 = DocumentsConfig.Translate.TR_GIVE2 .. displayName, variant = 'gold',
        callBack = function()
            giveDocument(doc)
        end
    }

    if canDeleteDoc() then
        options[#options + 1] = {
            icon = 'delete', text = DocumentsConfig.Translate.TR_DELETE, text2 = displayName .. DocumentsConfig.Translate.TR_DELETE3, variant = 'danger',
            callBack = function()
                askConfirm(DocumentsConfig.Translate.TR_CONFIRM_DELETE, function()
                    ESX.TriggerServerEvent('Documents:DeleteDocument', doc)
                    afterAction()
                end)
            end
        }
    end

    showMenu({
        title = DocumentsConfig.Translate.TR_MENU_OPTIONS,
        subtitle = doc.name,
        items = options,
    })
end

local function buildDocItems(models, filter)
    local items = { backItem(DocumentsConfig.Translate.TR_BACK2) }
    local lowerFilter = filter and filter:lower() or nil

    for _, k in ipairs(models or {}) do
        local doc = k
        local include = true
        if lowerFilter and doc.name then
            include = string.find(doc.name:lower(), lowerFilter, 1, true) ~= nil
        end
        if include then
            items[#items + 1] = {
                icon = (doc.isopen == 1) and 'file' or 'document-closed',
                text = doc.name or '',
                text2 = doc.title or '',
                variant = (doc.isopen == 0) and 'closed' or 'default',
                callBack = function()
                    navTo(function() renderDocOptions(doc) end)
                end
            }
        end
    end

    return items
end

local function renderOwnDocs(filter)
    showMenu({
        title = DocumentsConfig.Translate.TR_MENU_DOCUMENTS,
        subtitle = DocumentsConfig.Translate.TR_VIEW_DOCUMENTS2,
        items = buildDocItems(documentsCache, filter),
        showSearch = true,
        searchPlaceholder = DocumentsConfig.Translate.TR_SEARCH_PLACEHOLDER,
        emptyText = DocumentsConfig.Translate.TR_NOT_DOCUMENTS,
        onSearch = function(q) renderOwnDocs(q) end,
    })
end

RegisterNetEvent('Documents:viewDocuments')
AddEventHandler('Documents:viewDocuments', function(models)
    documentsCache = models or {}
    navTo(function() renderOwnDocs(nil) end)
end)

local function renderTemplatePick(models, public)
    local items = { backItem(DocumentsConfig.Translate.TR_BACK2) }

    for _, k in ipairs(models or {}) do
        local model = k
        items[#items + 1] = {
            icon = 'product',
            text = model.title or '',
            text2 = trimScope(model.scope),
            callBack = function()
                local name = (pdata().name or ''):gsub('_', ' ')
                if not name or #name <= 1 then return end
                local doc = decodeDoc(model)
                doc.name = name
                openEditor({ openCreateDocument = true, infos_document = doc, sourcePublic = public and true or false })
            end
        }
    end

    showMenu({
        title = public and DocumentsConfig.Translate.TR_PUBLIC_MENU_TITLE or DocumentsConfig.Translate.TR_MENU_TEMPLATES,
        subtitle = DocumentsConfig.Translate.TR_CREATE3,
        items = items,
        emptyText = public and DocumentsConfig.Translate.TR_PUBLIC_EMPTY or DocumentsConfig.Translate.TR_NO_RESULTS,
    })
end

RegisterNetEvent('Documents:loadModels')
AddEventHandler('Documents:loadModels', function(models)
    navTo(function() renderTemplatePick(models, false) end)
end)

RegisterNetEvent('Documents:loadPublicModels')
AddEventHandler('Documents:loadPublicModels', function(models)
    navTo(function() renderTemplatePick(models, true) end)
end)

local function renderModelOptions(model)
    local options = {
        backItem(DocumentsConfig.Translate.TR_BACK3),
        { icon = 'edit', text = DocumentsConfig.Translate.TR_EDIT, text2 = DocumentsConfig.Translate.TR_EDIT2 .. (model.title or ''), variant = 'primary',
            callBack = function()
                openEditor({ openEditModel = true, infos_document = decodeDoc(model) })
            end },
        { icon = 'delete', text = DocumentsConfig.Translate.TR_DELETE, text2 = DocumentsConfig.Translate.TR_DELETE2 .. (model.title or ''), variant = 'danger',
            callBack = function()
                askConfirm(DocumentsConfig.Translate.TR_CONFIRM_DELETE, function()
                    ESX.TriggerServerEvent('Documents:DeleteDocument', model)
                    afterAction()
                end)
            end },
    }
    showMenu({
        title = DocumentsConfig.Translate.TR_MENU_OPTIONS,
        subtitle = model.title,
        items = options,
    })
end

local function renderManageModels(models)
    local items = { backItem(DocumentsConfig.Translate.TR_BACK2) }
    for _, k in ipairs(models or {}) do
        local model = k
        items[#items + 1] = {
            icon = 'product',
            text = model.title or '',
            text2 = trimScope(model.scope),
            callBack = function()
                navTo(function() renderModelOptions(model) end)
            end
        }
    end
    showMenu({
        title = DocumentsConfig.Translate.TR_MENU_MODELS,
        subtitle = DocumentsConfig.Translate.TR_VIEW_MODELS2,
        items = items,
    })
end

RegisterNetEvent('Documents:viewModels')
AddEventHandler('Documents:viewModels', function(models)
    navTo(function() renderManageModels(models) end)
end)

local function renderArchiveOptions(doc)
    local options = {
        backItem(DocumentsConfig.Translate.TR_MENU_ARCHIVE_TITLE),
        { icon = 'document', text = DocumentsConfig.Translate.TR_OPEN, text2 = (doc.name or '') .. ' ' .. DocumentsConfig.Translate.TR_OPEN2, variant = 'primary',
            callBack = function()
                showLoading()
                ESX.TriggerServerCallback('Documents:getDocument', function(full)
                    if full then
                        openEditor({ openViewDocument = true, infos_document = decodeDoc(full) })
                    else
                        returnHome()
                    end
                end, doc.id)
            end },
        { icon = 'void', text = DocumentsConfig.Translate.TR_VOID, text2 = DocumentsConfig.Translate.TR_VOID2 .. (doc.name or ''), variant = 'danger',
            callBack = function()
                askConfirm(DocumentsConfig.Translate.TR_CONFIRM_VOID, function()
                    ESX.TriggerServerEvent('Documents:VoidDocument', decodeDoc(doc))
                    afterAction()
                end)
            end },
    }
    showMenu({
        title = DocumentsConfig.Translate.TR_MENU_OPTIONS,
        subtitle = doc.name,
        items = options,
    })
end

local function renderArchive()
    local items = { backItem(DocumentsConfig.Translate.TR_BACK2) }
    local page = archivePagination.page
    local totalPages = archivePagination.totalPages

    if totalPages > 1 then
        if page > 1 then
            items[#items + 1] = {
                icon = 'page-prev', text = DocumentsConfig.Translate.TR_PREV_PAGE,
                text2 = ('%s %d %s %d'):format(DocumentsConfig.Translate.TR_PAGE, page - 1, DocumentsConfig.Translate.TR_OF, totalPages),
                variant = 'gold',
                callBack = function() loadArchivePage(page - 1, archivePagination.search) end
            }
        end
        if page < totalPages then
            items[#items + 1] = {
                icon = 'page-next', text = DocumentsConfig.Translate.TR_NEXT_PAGE,
                text2 = ('%s %d %s %d'):format(DocumentsConfig.Translate.TR_PAGE, page + 1, DocumentsConfig.Translate.TR_OF, totalPages),
                variant = 'gold',
                callBack = function() loadArchivePage(page + 1, archivePagination.search) end
            }
        end
    end

    for _, k in ipairs(archiveCache or {}) do
        local doc = k
        items[#items + 1] = {
            icon = 'document-closed', text = doc.name or '', text2 = doc.title or '', variant = 'closed',
            callBack = function()
                navTo(function() renderArchiveOptions(doc) end)
            end
        }
    end

    local subtitle = ('%s | %s: %d'):format(DocumentsConfig.Translate.TR_MENU_ARCHIVE_DESC, DocumentsConfig.Translate.TR_TOTAL_ITEMS, archivePagination.total)
    if totalPages > 1 then
        subtitle = ('%s | %s %d %s %d'):format(subtitle, DocumentsConfig.Translate.TR_PAGE, page, DocumentsConfig.Translate.TR_OF, totalPages)
    end

    showMenu({
        title = DocumentsConfig.Translate.TR_MENU_ARCHIVE_TITLE,
        subtitle = subtitle,
        items = items,
        showSearch = true,
        searchPlaceholder = DocumentsConfig.Translate.TR_SEARCH_PLACEHOLDER,
        emptyText = DocumentsConfig.Translate.TR_ARCHIVE_EMPTY,
        onSearch = function(q) loadArchivePage(1, q) end,
    })
end

loadArchivePage = function(page, search)
    showLoading()
    ESX.TriggerServerCallback('Documents:getArchivePage', function(result)
        result = result or {}
        archiveCache = result.items or {}
        archivePagination = {
            page = result.page or 1,
            totalPages = result.totalPages or 0,
            total = result.total or 0,
            search = search or '',
        }
        if navStack[#navStack] ~= renderArchive then
            navTo(renderArchive)
        else
            renderArchive()
        end
    end, page or 1, search or '')
end

local blacklistData = {}

local function renderBlacklistEntry(target)
    local options = {
        backItem(DocumentsConfig.Translate.TR_MENU_BLACKLIST_TITLE),
        { icon = 'delete', text = DocumentsConfig.Translate.TR_BLACKLIST_REMOVE_CONFIRM, text2 = target.name or target.identifier, variant = 'primary',
            callBack = function()
                askConfirm(DocumentsConfig.Translate.TR_BLACKLIST_REMOVE_CONFIRM, function()
                    ESX.TriggerServerEvent('Documents:RemoveBlacklist', target.identifier)
                    showLoading()
                    SetTimeout(900, navBack)
                end)
            end },
    }
    showMenu({
        title = DocumentsConfig.Translate.TR_BLACKLIST_REMOVE_CONFIRM,
        subtitle = target.name or target.identifier,
        items = options,
    })
end

local function renderBlacklistList()
    local items = {
        backItem(DocumentsConfig.Translate.TR_BACK2),
        { icon = 'user-add', text = DocumentsConfig.Translate.TR_BLACKLIST_ADD, text2 = DocumentsConfig.Translate.TR_BLACKLIST_ADD_DESC, variant = 'primary',
            callBack = function()
                sendToUI({ action = 'openBlacklistAdd' })
            end },
    }

    for _, entry in ipairs(blacklistData) do
        local target = entry
        local subtitle = ('%s: %s | %s: %s'):format(
            DocumentsConfig.Translate.TR_BLACKLIST_REASON_LABEL,
            target.reason ~= '' and target.reason or '-',
            DocumentsConfig.Translate.TR_BLACKLIST_DATE_LABEL,
            formatTimestamp(target.bannedAt)
        )
        items[#items + 1] = {
            icon = 'shield-x', text = target.name or target.identifier, text2 = subtitle, variant = 'danger',
            callBack = function()
                navTo(function() renderBlacklistEntry(target) end)
            end
        }
    end

    showMenu({
        title = DocumentsConfig.Translate.TR_MENU_BLACKLIST_TITLE,
        subtitle = DocumentsConfig.Translate.TR_MENU_BLACKLIST_MGMT_DESC,
        items = items,
        emptyText = DocumentsConfig.Translate.TR_BLACKLIST_EMPTY,
    })
end

screenBlacklist = function()
    showLoading()
    ESX.TriggerServerCallback('Documents:getBlacklist', function(list)
        blacklistData = list or {}
        renderBlacklistList()
    end)
end

RegisterNetEvent('Documents:OpenMenu')
AddEventHandler('Documents:OpenMenu', function()
    navRoot(screenMain)
end)

RegisterNetEvent('Documents:ShowBlacklist')
AddEventHandler('Documents:ShowBlacklist', function()
    navStack = {}
    showMenu({
        title = DocumentsConfig.Translate.TR_MENU_BLACKLIST,
        subtitle = DocumentsConfig.Translate.TR_BLACKLISTED,
        items = {},
        emptyText = DocumentsConfig.Translate.TR_BLACKLISTED_HELP,
    })
end)

TriggerEvent('chat:addSuggestion', '/' .. DocumentsConfig.GiveRequest.AcceptCommand, 'Jahate taeed va daryafte sanad')

RegisterCommand(DocumentsConfig.Command, function()
    TriggerServerEvent('Documents:OpenMenu')
end, false)

AddEventHandler('KeyDown:' .. DocumentsConfig.OpenKey, function()
    TriggerServerEvent('Documents:OpenMenu')
end)

AddEventHandler('sunset_utils:uiCallback:' .. MODULE, function(action, data)
    data = data or {}

    if action == 'menuSelect' then
        local id = tonumber(data.id)
        if id and menuCallbacks[id] then
            menuCallbacks[id]()
        end

    elseif action == 'menuSearch' then
        if activeSearch then
            activeSearch(data.query or '')
        end

    elseif action == 'navBack' then
        navBack()

    elseif action == 'menuClose' or action == 'close' or action == 'escape' then
        closeAll()

    elseif action == 'editorBack' then
        navRender()

    elseif action == 'editorSaved' then
        SetTimeout(300, returnHome)

    elseif action == 'confirmResult' then
        local token = tonumber(data.token)
        if data.ok and token and confirmCallbacks[token] then
            local fn = confirmCallbacks[token]
            confirmCallbacks[token] = nil
            fn()
        elseif token then
            confirmCallbacks[token] = nil
        end

    elseif action == 'blacklistAddPlayer' then
        local target = data.target
        local reason = data.reason or ''
        if target and tostring(target):gsub('%s+', '') ~= '' and reason ~= '' then
            ESX.TriggerServerEvent('Documents:AddBlacklistMenu', target, reason)
            SetTimeout(900, function()
                if navStack[#navStack] == screenBlacklist then
                    navRender()
                end
            end)
        end

    elseif action == 'saveModel' then
        ESX.TriggerServerEvent('Documents:SaveModel', data)

    elseif action == 'saveDocument' then
        ESX.TriggerServerEvent('Documents:SaveDocument', data)

    elseif action == 'savePublicDocument' then
        ESX.TriggerServerEvent('Documents:SavePublicDocument', data)

    elseif action == 'applyJusticeSeal' then
        local id = tonumber(data.id)
        if id then
            ESX.TriggerServerEvent('Documents:ApplyJusticeSeal', id, data.date)
        end
    end
end)
