-- Per-rank options of an organisation. Every option is ALLOWED by default; the boss of an
-- organisation (or Government) switches an option off for the ranks that must not use it.
OrgOptionList = {   -- master list (every option that exists)
    { id = 'cad',     label = '/cad (MDT)',            desc = 'Baz kardan-e CAD / MDT' },
    { id = 'law',     label = '/law (ghanoon)',        desc = 'Menu-ye ghavanin' },
    { id = 'doj',     label = '/doj (dadgostari)',     desc = 'Menu-ye DOJ' },
    { id = 'robbery', label = '/acceptrob (robbery)',  desc = 'Ghabool-e robbery ha' },
    { id = 'dep',     label = '/dep (department)',     desc = 'Chat-e department' },
}

local function pick(ids)
    local out = {}
    for _, id in ipairs(ids) do
        for _, o in ipairs(OrgOptionList) do if o.id == id then out[#out + 1] = o end end
    end
    return out
end

-- the options that make sense for one organisation:
--   DOJ organisations      -> /cad /doj /acceptrob /dep   (NOT /law)
--   Law Enforcement        -> /cad /law /acceptrob /dep
--   everybody else         -> /dep
function OrgOptionsFor(job)
    if DojJobSet and DojJobSet[job] then return pick({ 'cad', 'doj', 'robbery', 'dep' }) end
    if LeJobSet and LeJobSet[job] then return pick({ 'cad', 'law', 'robbery', 'dep' }) end
    return pick({ 'dep' })
end
