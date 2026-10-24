-- Business shops. Stock = the OWNER gang's armory; money = the gang's treasury.
local function bizCfg() return Config.BusinessSales end

local function ownerOfBiz(bkey)
    local h = BusinessHolding and BusinessHolding[bkey]
    return h and HoldingOwnerOf(h) or nil
end

local function armoryCount(gang, item)
    local ok, n = pcall(function() return exports['Unique_inventory']:GetGangArmoryItemCount(gang, item) end)
    return ok and tonumber(n) or 0
end

local function nearSalePoint(src, bkey)
    local cafe = Cafes and Cafes[bkey]
    if not cafe or not cafe.Menu_Sefaresh then return false end
    local p = cafe.Menu_Sefaresh.Pos
    local sp = vector3(p.x, p.y, p.z) + bizCfg().SalePointOffset
    return #(GetEntityCoords(GetPlayerPed(src)) - sp) <= 4.0
end

-- what the menu shows: products with the owner gang's current stock
ESX.RegisterServerCallback('BizSale:Info', function(source, cb, bkey)
    local b = bizCfg().Businesses[bkey]
    local owner = ownerOfBiz(bkey)
    if not b or not owner then return cb({ ok = false, reason = 'In kasb-o-kar sahebi nadarad.' }) end
    local products = {}
    for _, p in ipairs(b.products) do
        products[#products + 1] = { item = p.item, label = p.label, price = p.price, stock = armoryCount(owner, p.item) }
    end
    cb({ ok = true, label = b.label, owner = owner, products = products })
end)

-- buy: money from the buyer's bank, item from the owner gang's armory
ESX.RegisterServerCallback('BizSale:Buy', function(source, cb, bkey, item, count)
    local b = bizCfg().Businesses[bkey]
    local owner = ownerOfBiz(bkey)
    if not b or not owner then return cb(false, 'In kasb-o-kar sahebi nadarad.') end
    if not nearSalePoint(source, bkey) then return cb(false, 'Kheyli door hasti.') end

    local product
    for _, p in ipairs(b.products) do if p.item == item then product = p end end
    if not product then return cb(false, 'In mahsul ra nadarad.') end

    local n = math.floor(tonumber(count) or 0)
    if n < 1 or n > 100 then return cb(false, 'Tedad na-motabar.') end
    if armoryCount(owner, item) < n then return cb(false, 'Mojodi-ye anbar-e gang kafi nist.') end

    local total = product.price * n
    if (getBankMoney(source) or 0) < total then return cb(false, 'Pool-e bank-e shoma kafi nist.') end

    local ok = pcall(function() exports['Unique_inventory']:RemoveGangArmoryItem(owner, item, n) end)
    if not ok then return cb(false, 'Khata dar anbar.') end

    removeBankMoney(source, total)
    AddGangMoney(owner, total)
    local x = ESX.GetPlayerFromId(source)
    if x then x.addInventoryItem(item, n) end

    GangLog(owner, 'Business', ('%s sold %dx %s for $%d'):format(b.label, n, product.label, total), source)
    cb(true, ('%dx %s kharidid - $%d'):format(n, product.label, total))
end)
