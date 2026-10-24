-- Business shop points (ox_target), 2.5 m from each business menu point.
local function bizPoint(bkey)
    local cafe = Cafes and Cafes[bkey]
    if not cafe or not cafe.Menu_Sefaresh then return nil end
    local p = cafe.Menu_Sefaresh.Pos
    return vector3(p.x, p.y, p.z) + Config.BusinessSales.SalePointOffset
end

local function openBizSale(bkey)
    ESX.TriggerServerCallback('BizSale:Info', function(data)
        if not data.ok then return ESX.ShowNotification(data.reason) end
        local elements = {}
        for _, p in ipairs(data.products) do
            table.insert(elements, { label = ('%s - $%d (anbar: %d)'):format(p.label, p.price, p.stock), value = p.item, info = p })
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'biz_sale_' .. bkey, {
            title = data.label, align = 'top-left', elements = elements,
        }, function(d, m)
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'biz_sale_amount_' .. bkey, {
                title = 'Tedad',
            }, function(d2, m2)
                m2.close()
                ESX.TriggerServerCallback('BizSale:Buy', function(ok, msg)
                    ESX.ShowNotification(msg or (ok and 'OK' or 'Khata'))
                end, bkey, d.current.value, tonumber(d2.value))
            end, function(_, m2) m2.close() end)
        end, function(_, m) m.close() end)
    end, bkey)
end

CreateThread(function()
    while Cafes == nil or Config.BusinessSales == nil do Wait(500) end
    for bkey in pairs(Config.BusinessSales.Businesses) do
        local pos = bizPoint(bkey)
        if pos then
            pcall(function() exports.ox_target:addBoxZone({
                coords = pos,
                size = vector3(1.2, 1.2, 1.5),
                rotation = 0.0,
                debug = false,
                options = {
                    {
                        name = 'biz_sale_' .. bkey,
                        icon = 'fa-solid fa-store',
                        label = 'Forooshgah',
                        onSelect = function() openBizSale(bkey) end,
                    },
                },
            }) end)
        end
    end
end)
