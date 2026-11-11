-- Builds the item tables from Config.clothe on BOTH client and server.
--   Clothes.byName[name]      every wearable item (inventory item name = this name)
--   Clothes.groups[type][sex] items sold in shops, grouped by drawable id (for the shop UI)
-- Item name format: <type>_<m|f>_<drawable>_<texture>   e.g. tshirt_m_12_3

Clothes = { byName = {}, groups = {} }

-- category -> skinchanger keys (note: bag -> bags_*, arms -> arms/arms_2)
Clothes.keys = {
    tshirt = { 'tshirt_1', 'tshirt_2' }, torso = { 'torso_1', 'torso_2' },
    pants = { 'pants_1', 'pants_2' },    shoes = { 'shoes_1', 'shoes_2' },
    mask = { 'mask_1', 'mask_2' },       bproof = { 'bproof_1', 'bproof_2' },
    helmet = { 'helmet_1', 'helmet_2' }, glasses = { 'glasses_1', 'glasses_2' },
    watches = { 'watches_1', 'watches_2' }, bracelets = { 'bracelets_1', 'bracelets_2' },
    bag = { 'bags_1', 'bags_2' },        ears = { 'ears_1', 'ears_2' },
    arms = { 'arms', 'arms_2' },         chain = { 'chain_1', 'chain_2' },
    decals = { 'decals_1', 'decals_2' },
}

local function build()
    local temp = {}
    for ctype, list in pairs(Config.clothe) do
        local keys = Clothes.keys[ctype]
        if keys then
            for _, e in ipairs(list) do
                local id, v = e.num[1], e.num[2]
                local from, to
                if type(v) == 'table' then from, to = v[1], v[2] else from, to = v, v end
                local buyable = (e.price or 0) > 0 and not e.personal and not e.access and not e.prime
                for variant = from, to do
                    local name = ('%s_%s_%d_%d'):format(ctype, e.sex == 0 and 'm' or 'f', id, variant)
                    if not Clothes.byName[name] then
                        local tlabel = Config.TypeLabels[ctype] or ctype
                        local item = {
                            name = name, type = ctype, sex = e.sex, id = id, variant = variant,
                            price = math.floor((e.price or 0) * Config.PriceMultiplier),
                            buyable = buyable,
                            label = ('%s %d (%d)'):format(tlabel, id, variant),
                            groupLabel = ('%s %d'):format(tlabel, id),
                            num = { [keys[1]] = id, [keys[2]] = variant },
                        }
                        Clothes.byName[name] = item
                        if buyable then
                            temp[ctype] = temp[ctype] or {}
                            temp[ctype][e.sex] = temp[ctype][e.sex] or {}
                            local g = temp[ctype][e.sex][id]
                            if not g then g = { id = id, variants = {} }; temp[ctype][e.sex][id] = g end
                            g.variants[#g.variants + 1] = item
                        end
                    end
                end
            end
        end
    end
    for ctype, sexes in pairs(temp) do
        Clothes.groups[ctype] = {}
        for sex, byId in pairs(sexes) do
            local arr = {}
            for _, g in pairs(byId) do
                table.sort(g.variants, function(a, b) return a.variant < b.variant end)
                arr[#arr + 1] = g
            end
            table.sort(arr, function(a, b) return a.id < b.id end)
            Clothes.groups[ctype][sex] = arr
        end
    end
end
build()
