-- This Script Dump By FleeX Team  , discord.gg/2D79ZtUjxB

MaketWeapons = {
    'WEAPON_MINIGUN',
    'WEAPON_SNIPERRIFLE',
    'WEAPON_HEAVYSNIPER_MK2',
    'WEAPON_KATANA',
    'WEAPON_KATANA2',
    'WEAPON_LUCILLE'
}

local maketLookup = {}
for _, weaponName in ipairs(MaketWeapons) do
    maketLookup[string.upper(weaponName)] = true
end

function IsMaketWeapon(name)
    if not name then return false end
    return maketLookup[string.upper(name)] == true
end
