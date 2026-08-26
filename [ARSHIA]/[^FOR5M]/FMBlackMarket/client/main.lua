ESX , QBCore = nil , nil
if CAS.Framework == "qb" then
    QBCore = exports["qb-core"]:GetCoreObject()
else
    CreateThread(function()
        while ESX == nil do
            TriggerEvent(Config.ESX, function(obj) ESX = obj end)
            Wait(0)
        end
    end)    
end
AddEventHandler('FMBlackMarket:openShop', function()

    CASFunctions.DisplayUI()
end)
CASFunctions = {
    DisplayUI = function()
        local Items = {}
        ESX.TriggerServerCallback("FMGangs:MyGangLevel", function(GangLevel)
            for i in pairs(CAS.Items) do
                if CAS.Items[i].level <= GangLevel then
                Items[#Items+1] = {
                    label = CAS.Items[i].label,
                    price = CAS.Items[i].price,
                    imageSrc = CAS.Items[i].imageSrc,
                    key = i,
                    type = CAS.Items[i].type
                }
                end
            end
            SendNUIMessage({
                action = "market",
                items = Items , 
                imgs = Config.inventoryimg ,
            })
            SetNuiFocus(true,true)
        end)
    end
}
RegisterNUICallback("EscapeFromJs", function()
    SetNuiFocus(false,false)
end)
RegisterNUICallback("CompleteOrder", function(data, cb)
    if not data.item or not data.price then return end
    if CAS.Framework == "qb" then
        QBCore.Functions.TriggerCallback("FMBlackMarket:BuyProducts",function(_)
            if (_) then
                Notify(CAS.CompleteText)
            end
            cb(_)
        end, data)
    elseif CAS.Framework == "esx" then
        ESX.TriggerServerCallback("FMBlackMarket:BuyProducts",function(_)
            if (_) then
                Notify(CAS.CompleteText)
            end
            cb(_)
        end,data)
    end
end)
function Notify(msg)
    if CAS.Framework == "esx" then
        ESX.ShowNotification(msg)
    end 
end 