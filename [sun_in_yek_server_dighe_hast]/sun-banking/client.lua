-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

ESX = exports['essentialmode']:getObject()
local balanceChart = {}
local mobileBank = false
local mobileTransferCard = nil

local atms  = {
    --- default
    `prop_atm_01`,
	`prop_atm_02`,
	`prop_atm_03`,
    `prop_fleeca_atm`,
    --- addon
	`g1_atm_a`,
	`g2_atm_a`,
	`prop_atm_03`,
    `g10_atm_a`,
    `g11_atm_a`,
    `g19_atm_a`,
    `g34_atm_a`,
    `prop_atm_g35`,
    `g37_atm_a`,
    `g42_atm_a`,
    `g44_atm_a`,
    `g45_atm_a`,
    `g49_atm_a`,
	`prop_atm_g52`,
    `g55_atm_a`,
    `g65_atm_a`,
    `g69_atm_a`,
    `g70_atm_a`,
    `g72_atm_a`,
    `g84_atm_a`,
    `g86_atm_a`,
    `g87_atm_a`,
    `g100_atm_a`,
    `g104_atm_a`,
    `g105_atm_a`,
    `g111_atm_a`,
    `g112_atm_a`,
    `g113_atm_a`,
    `g114_atm_a`,
    `g115_atm_a`,
    `g116_atm_a`,
    `g117_atm_a`,
    `g118_atm_a`,
    `g119_atm_a`,
    `g120_atm_a`,
    `g121_atm_a`,
    `g122_atm_a`,
    `g123_atm_a`,
    `g124_atm_a`,
    `g125_atm_a`,
    `g126_atm_a`,
    `g127_atm_a`,
    `g128_atm_a`,
    `g129_atm_a`,
    `g130_atm_a`,
}

local banks = {
	{name="Bank", id = 0, x=150.266, y=-1040.203, z=29.374},
	-- {name="Bank", id = 108, x=-1212.980, y=-330.841, z=37.787},
	{name="Bank", id = 0, x=-1307.41, y=-826.29, z=17.15},
	{name="Bank", id = 0, x=-112.202, y=6469.295, z=31.626},
	-- {name="Bank", id = 108, x=314.187, y=-278.621, z=54.170},
	--{name="Bank", id = 108, x=-351.534, y=-49.529, z=49.042},
	-- {name="Bank", id = 108, x=1175.06, y=2706.64, z=38.0},
	{name="Bank", id = 0, x=237.25, y=217.87, z=106.29}
}

local boxZone = {
	vector3(150.266, -1040.203, 29.374),
	vector3(-112.202, 6469.295, 31.626),
}

Citizen.CreateThread(function()
	while not ESX do
		Wait(1000)
	end
	-- exports['ox_target']:addModel(atms, {
    --     {
    --         label = "🏧عابر بانک",
    --         onSelect = function(entity)
    --             if ESX.GetPlayerData()['IsDead'] ~= 1 then
    --                 openBank(true)
    --             end
    --         end,
    --     },
    -- })
	exports['ox_target']:addModel2(atms, {
        {
            label = "🏧عابر بانک",
            onSelect = function(entity)
                if ESX.GetPlayerData()['IsDead'] ~= 1 then
                    openBank(true)
                end
            end,
        },
    })
	for k, v in pairs(boxZone) do
		exports['ox_target']:addSphereZone({
            coords = v,
            radius = 5,
            options = {
                {
					label = "🏧عابر بانک",
					onSelect = function(entity)
						if ESX.GetPlayerData()['IsDead'] ~= 1 then
							openBank(true)
						end
					end,
				},
            }
        })
	end
    for i = 1, 30 do
        balanceChart[i] = 0
    end
end)

function openBank()
    ESX.TriggerServerEvent('bank:getChart')
end

function openBankHandler(state)
    SendNUIMessage({
        app = 'sun-banking',
        method = 'open',
        data = state
    })
    if state and mobileTransferCard then
        SendNUIMessage({
            app = 'sun-banking',
            method = 'prefillCardTransfer',
            data = mobileTransferCard
        })
    end
    SetNuiFocus(state, state)
    TriggerScreenblurFadeIn(1000)
end

-- RegisterCommand("show", function()
--     openBank()
-- end)

RegisterNUICallback('close', function(data, cb)
    TriggerScreenblurFadeOut(1000)
    SetNuiFocus(false, false)
    mobileBank = false
    mobileTransferCard = nil
    cb()
end)

RegisterNUICallback('getUserData', function(data, cb)
    ESX.PlayerData = ESX.GetPlayerData()
    local user = {
        name        = ESX.PlayerData.name:gsub('_', ' '),
        cash        = ESX.PlayerData.money,
        bank        = ESX.PlayerData.bank,
        card        = ESX.PlayerData.bankNumber,
        canTransfer = not mobileBank,
        dayArry     = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
            18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 },
        balanceArry = balanceChart,
    }
    cb(json.encode(user))
end)

RegisterNetEvent('bank:openChart', function(result)
    local resultCount = #result
    local identifier = ESX.GetPlayerData().identifier
    for i = 0, 29 do
        if result[resultCount - i] then
            if result[resultCount - i].identifier == identifier then
                balanceChart[30 - i] = result[resultCount - i].after_balance_source
            else
                balanceChart[30 - i] = result[resultCount - i].after_balance_target
            end
        else
            balanceChart[30 - i] = 0
        end
    end
    openBankHandler(true)
end)

------ Transfer
---
---
---

RegisterNUICallback('getTransferHistory', function(data, cb)
    ESX.TriggerServerCallback('bank:getTransferHistory', function(result)
        for k, v in pairs(result) do
            v.date = v.ts
            v.status = v.type
            v.next = v.after_balance_source
        end
        cb(json.encode(result))
    end, data.filter)
    -- local history = {
    --     {
    --         date = 1681996800000,
    --         amount = 800000,
    --         status = 0,
    --         next = 2000,
    --     },
    --     {
    --         date = 1681996800000,
    --         amount = 75000,
    --         status = 1,
    --         next = 2000,

    --     },
    -- }
end)


RegisterNUICallback("getCardByCardHistory", function(data, cb)
    local identifier = ESX.GetPlayerData().identifier
    -- print("update Hostory List  Card By Card" .. json.encode(data))
    -- local history = {
    --     {
    --         name = "AlireZa",
    --         date = 1681996800000,
    --         amount = 800000,
    --         status = 1,
    --         next = 50000,
    --         card = 444233,
    --     },
    --     {
    --         name = "Ali Mohammdi",
    --         date = 1681996800000,
    --         amount = 800000,
    --         status = 1,
    --         next = 50000,
    --         card = 444233,
    --     },
    -- }
    -- cb(json.encode(history))
    ESX.TriggerServerCallback('bank:getCardHistory', function(result)
        for k, v in pairs(result) do
            v.date = v.ts
            v.status = v.identifier ~= identifier and 1 or 2
            v.next = v.identifier == identifier and v.after_balance_source or v.after_balance_target
            v.card = v.identifier == identifier and v.bank_number_target or v.bank_number_source
            v.name = v.identifier == identifier and v.name_target or v.name_source
        end
        cb(json.encode(result))
    end, data.filter)
end)


RegisterNUICallback('getCardName', function(data, cb)
    local p = promise.new()
    if data.card and #tostring(data.card) < 6 then return end
    ESX.TriggerServerCallback('bank:getName', function(name)
        p:resolve(name)
    end, data.card)
    local name = Citizen.Await(p)
    cb(json.encode(name))
end)

RegisterNUICallback('handelCardByCard', function(data, cb)
    ESX.TriggerServerEvent('bank:transfer', data)
    Wait(2000)
    cb(true)
end)

RegisterNUICallback('handelWithdraw', function(data, cb)
    ESX.TriggerServerEvent('bank:withdraw', data)
    Wait(2000)
    cb(true)
end)

RegisterNUICallback('handelDeposit', function(data, cb)
    ESX.TriggerServerEvent('bank:deposit', data)
    Wait(2000)
    cb(true)
end)

RegisterNUICallback("sendNotif", function(data, cb)
    ESX.notification('warning', data.message)
    cb(true)
end)


AddEventHandler('bank:openMobileBank', function (data)
    mobileBank = true
    if type(data) == 'table' and data.card and tostring(data.card) ~= '' then
        mobileTransferCard = tostring(data.card)
    else
        mobileTransferCard = nil
    end
    openBank()
end)