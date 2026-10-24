-- Holding purchase: a NUI page (holding/html) through the Unique_ALLGangs router.
local function SendHoldingNUI(msg)
    SendNUIMessage({ __routeTo = 'holding', payload = msg })
end

local function HideHolding()
    SendNUIMessage({ __routeTo = 'holding', __hide = true })
end

RegisterNetEvent('holding_sale:openMenu')
AddEventHandler('holding_sale:openMenu', function()
    ESX.TriggerServerCallback('HoldingSale:Info', function(list)
        ESX.TriggerServerCallback('HoldingSale:MyGang', function(gang)
            SetNuiFocus(true, true)
            SendHoldingNUI({ type = 'open', list = list, gang = gang })
        end)
    end)
end)

RegisterNUICallback('holding_close', function(_, cb)
    SetNuiFocus(false, false)
    SendHoldingNUI({ type = 'close' })
    HideHolding()
    cb('ok')
end)

RegisterNUICallback('holding_bid', function(data, cb)
    ESX.TriggerServerCallback('HoldingSale:Bid', function(ok, msg)
        ESX.TriggerServerCallback('HoldingSale:Info', function(list)
            cb({ ok = ok, msg = msg, list = list })
        end)
    end, data.key, tonumber(data.amount))
end)

RegisterNetEvent('holding_sale:cyanide')
AddEventHandler('holding_sale:cyanide', function()
    SetEntityHealth(PlayerPedId(), 0)
end)
