local function Content(source,data)
    local retval = false
    local items = data.item
    local price = data.price
    local method = data.method
    local xPlayer = GetPlayer(source)
    if not xPlayer then print("Player Not Found") return end
    for i,j in pairs(items) do
        for k in pairs(CAS.Items) do
            if j.name == CAS.Items[k].label then
                local checkMoney = RemoveMoney(source, method, price)
                if checkMoney then 

                    if CAS.Items[k].type ~= 'weapon' then 
                        AddItem(source, k, j.count) retval = true
                    else 
                        AddWeapon(source, k, j.count) retval = true
                    end 
                    TriggerEvent('For5M:SendLog', source , 'GANG BLACK MARKET' , 'bought a ' .. CAS.Items[k].label  )
                 end
            end
        end
    end
    return retval
end

if CAS.Framework == "qb" then
    QBCore.Functions.CreateCallback("FMBlackMarket:BuyProducts",function(source,cb,data) 
        local check = Content(source, data)
        cb(check)
    end)
elseif CAS.Framework == "esx" then
    ESX.RegisterServerCallback("FMBlackMarket:BuyProducts",function(source,cb,data) 
        local check = Content(source, data)
        cb(check)
    end)
end

