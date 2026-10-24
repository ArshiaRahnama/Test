-- Pawnshop points: E at the business' menu point opens the shop's own list.
local function openPawn(k)
    local shop = Config.Pawnshops[k]
    local elements = {}
    for _, it in ipairs(shop.items) do
        table.insert(elements, { label = ('%s - $%d'):format(it.label, it.price), value = it.name, item = it })
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pawnshop_' .. k, {
        title = shop.label, align = 'top-left', elements = elements,
    }, function(data, menu)
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pawnshop_amount_' .. k, {
            title = 'Tedad baraye forooshtan',
        }, function(d2, m2)
            m2.close()
            TriggerServerEvent('pawnshop:sell', k, data.current.value, tonumber(d2.value))
        end, function(_, m2) m2.close() end)
    end, function(_, menu) menu.close() end)
end

CreateThread(function()
    local points = { crimson = 'crimson', nightjar = 'nightjar' }
    while true do
        local sleep = 800
        local pc = GetEntityCoords(PlayerPedId())
        for k in pairs(points) do
            local b = Cafes and Cafes[k]
            if b and b.Menu_Sefaresh then
                local p = b.Menu_Sefaresh.Pos
                local pos = vector3(p.x, p.y, p.z)
                local d = #(pc - pos)
                if d < 15.0 then
                    sleep = 0
                    DrawMarker(1, pos.x, pos.y, pos.z - 1.0, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.4, 255, 190, 0, 150, false, true, 2, false, nil, nil, false)
                    if d < 2.0 then
                        BeginTextCommandDisplayHelp('STRING')
                        AddTextComponentSubstringPlayerName(('%s ~INPUT_CONTEXT~'):format(Config.Pawnshops[k].label))
                        EndTextCommandDisplayHelp(0, false, false, -1)
                        if IsControlJustReleased(0, 38) then openPawn(k) end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)
