-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

PaintballUtil = {}

function PaintballUtil.getMode(mode)
    return paintballConfig.gameModes[mode]
end

function PaintballUtil.modeEnabled(mode)
    local cfg = paintballConfig.gameModes[mode]
    return cfg and cfg.enabled
end

function PaintballUtil.getMap(name)
    return paintballConfig.maps[name]
end

function PaintballUtil.getCoopMap(name)
    return paintballConfig.coopMaps[name]
end

function PaintballUtil.weaponClass(model)
    for _, w in ipairs(paintballConfig.weapons) do
        if w.model == model then
            return w.class, w.label, w.icon
        end
    end
    return 'unknown', model, ''
end

function PaintballUtil.shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

function PaintballUtil.tableLength(t)
    local n = 0
    if type(t) ~= 'table' then return 0 end
    for _ in pairs(t) do n = n + 1 end
    return n
end

function PaintballUtil.getEnabledModes()
    local list = {}
    for k, v in pairs(paintballConfig.gameModes) do
        if v.enabled then
            list[#list + 1] = {
                key = k,
                priority = v.priority or 0,
                label = v.label,
                teamCount = v.teamCount,
                teamSize = v.teamSize,
                comingSoon = v.comingSoon and true or false,
                configurable = v.configurable or {weapon = true, rounds = true, timer = true, armor = true, headshot = true},
                rounds = v.rounds,
                roundTime = v.roundTime,
                matchTime = v.matchTime,
                survivorTime = v.survivorTime,
                escortTime = v.escortTime,
            }
        end
    end
    table.sort(list, function(a, b)
        if a.comingSoon ~= b.comingSoon then return not a.comingSoon end
        if (a.priority or 0) ~= (b.priority or 0) then return (a.priority or 0) > (b.priority or 0) end
        return a.label < b.label
    end)
    return list
end

function PaintballUtil.isModeAvailable(modeKey)
    local m = paintballConfig.gameModes[modeKey]
    if not m or not m.enabled then return false end
    if m.comingSoon then return false end
    return true
end

function PaintballUtil.getMapList(mode)
    local cfg = paintballConfig.gameModes[mode]
    local needsBomb = mode == 'bombplant'
    local src = (mode == 'coop' or mode == 'wavedefense' or mode == 'survival') and paintballConfig.coopMaps or paintballConfig.maps
    local list = {}
    for k, v in pairs(src) do
        if not needsBomb or (v.bombSites and #v.bombSites > 0) then
            list[#list + 1] = {key = k, label = v.label, image = v.image, priority = v.priority or 0}
        end
    end
    table.sort(list, function(a, b)
        if (a.priority or 0) ~= (b.priority or 0) then return (a.priority or 0) > (b.priority or 0) end
        return a.label < b.label
    end)
    return list
end

function PaintballUtil.attachmentForWeapon(weaponModel, group)
    local cat = paintballConfig.attachmentCatalog[group]
    if not cat then return nil end
    if cat.components then
        return cat.components[weaponModel]
    end
    return nil
end

function PaintballUtil.allowedAttachmentsForWeapon(mode, weaponModel)
    local cfg = paintballConfig.gameModes[mode]
    if not cfg or not cfg.allowAttachments or not cfg.attachmentGroups then return {} end
    local result = {}
    for _, group in ipairs(cfg.attachmentGroups) do
        local cat = paintballConfig.attachmentCatalog[group]
        if cat then
            if group == 'tint' then
                result[#result + 1] = {group = group, label = cat.label, type = cat.type, hash = cat.tintIndex or 1}
            else
                local hash = cat.components and cat.components[weaponModel]
                if hash then
                    result[#result + 1] = {group = group, label = cat.label, type = cat.type, hash = hash}
                end
            end
        end
    end
    return result
end
