Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
  }
ESX = nil
local count = 0
local price = {}
LastZone                = nil
CurrentAction           = nil
CurrentActionMsg        = ''
CurrentActionData       = {}
HasAlreadyEnteredMarker = false
local menuOpen = false

-- Shared by weed.lua / meth.lua / crack.lua / heroine.lua / mushroom.lua (loaded after this
-- file, so this is available to them as a global): captures a forensic snapshot of whoever is
-- harvesting right now, sent along with the pickedUp* event so DOA's evidence report can show
-- clothing, skin tone, and vehicle/plate -- not just a name and a count.
function GetForensicSnapshot()
    local playerPed = PlayerPedId()

    local gender = 'Mard'
    local okModel, model = pcall(GetEntityModel, playerPed)
    if okModel and model == GetHashKey('mp_f_freemode_01') then
        gender = 'Zan'
    end

    local skinTone = 'Namoshakhas'
    -- GetPedHeadBlendData returns raw multi-values here (success, shapeFirst..., skinMix, ...),
    -- not a table -- capture them positionally instead of indexing a table that doesn't exist.
    local okBlend, success, _, _, _, _, _, _, _, skinMix = pcall(GetPedHeadBlendData, playerPed) -- success(1) shapeFirst(2) shapeSecond(3) shapeThird(4) skinFirst(5) skinSecond(6) skinThird(7) shapeMix(8) skinMix(9)
    if okBlend and success and type(skinMix) == 'number' then
        if skinMix < 0.33 then
            skinTone = 'Roshan'
        elseif skinMix < 0.66 then
            skinTone = 'Motevaset'
        else
            skinTone = 'Tireh'
        end
    end

    local top = GetPedDrawableVariation(playerPed, 11)
    local legs = GetPedDrawableVariation(playerPed, 4)
    local shoes = GetPedDrawableVariation(playerPed, 6)

    local vehicleLabel = 'Piade (bedoone vasile naghlie)'
    local plate = 'N/A'
    if IsPedInAnyVehicle(playerPed, false) then
        local veh = GetVehiclePedIsIn(playerPed, false)
        local okLabel, label = pcall(function()
            return GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(veh)))
        end)
        if okLabel and label and label ~= 'NULL' and label ~= '' then
            vehicleLabel = label
        end
        plate = GetVehicleNumberPlateText(veh)
    end

    return {
        gender  = gender,
        skin    = skinTone,
        top     = top,
        legs    = legs,
        shoes   = shoes,
        vehicle = vehicleLabel,
        plate   = plate,
    }
end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    ESX.TriggerServerCallback('getDrugPrices', function(data)
        price = data
    end)

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

-- Server broadcasts new prices every 10 minutes (server/main.lua -> loop() -> DrugDealerItems.regen()).
-- Keep the local price table in sync so the dealer menu always shows the current price.
RegisterNetEvent('esx_jk_drugs:getPrice')
AddEventHandler('esx_jk_drugs:getPrice', function(data)
    price = data
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if menuOpen then
            ESX.UI.Menu.CloseAll()
        end
    end
end)

function CreateBlipCircle(coords, text, radius, color, sprite)
    local blip = AddBlipForRadius(coords, radius)

    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 1)
    SetBlipAlpha (blip, 128)
    SetBlipAsShortRange(blip, true)


    blip = AddBlipForCoord(coords)

    SetBlipHighDetail(blip, true)
    SetBlipSprite (blip, sprite)
    SetBlipScale(blip, 1.0)
    SetBlipColour (blip, color)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
    while true do

        Citizen.Wait(0)

        if Config.ShowMarkers then

            local coords = GetEntityCoords(GetPlayerPed(-1))

			for k,v in pairs(Config.FieldZones) do
                if GetDistanceBetweenCoords(coords, v.coords, true) < Config.DrawDistance then
                    DrawMarker(Config.MarkerType, v.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                end
            end

            for k,v in pairs(Config.ProcessZones) do
                if GetDistanceBetweenCoords(coords, v.coords, true) < Config.DrawDistance then
                    DrawMarker(Config.MarkerType, v.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()

    if Config.ShowBlips then
		for k,v in pairs(Config.FieldZones) do
            CreateBlipCircle(v.coords, v.name, v.radius, v.color, v.sprite)
        end

        for k,v in pairs(Config.ProcessZones) do
            CreateBlipCircle(v.coords, v.name, v.radius, v.color, v.sprite)
        end

        if Config.CircleZones.DrugDealer then
            CreateBlipCircle(Config.CircleZones.DrugDealer.coords, Config.CircleZones.DrugDealer.name, Config.CircleZones.DrugDealer.radius, Config.CircleZones.DrugDealer.color, Config.CircleZones.DrugDealer.sprite)
        end

    end
end)

Citizen.CreateThread(function()
    for k,v in pairs(Config.Peds) do
        RequestModel(v.ped)
        while not HasModelLoaded(v.ped) do
            Wait(1)
        end


        local seller = CreatePed(1, v.ped, v.x, v.y, v.z, v.h, false, true)
        SetBlockingOfNonTemporaryEvents(seller, true)
        SetPedDiesWhenInjured(seller, false)
        SetPedCanPlayAmbientAnims(seller, true)
        SetPedCanRagdollFromPlayerImpact(seller, false)
        SetEntityInvincible(seller, true)
        FreezeEntityPosition(seller, true)
        TaskStartScenarioInPlace(seller, "WORLD_HUMAN_CLIPBOARD", 0, true)
    end
end)

----------------------------------------
----------- DRUG DEALER ----------------
----------------------------------------
-- Ground marker + interaction prompt for the generic drug dealer (Config.CircleZones.DrugDealer).
-- Sells whatever the local `price` table lists, using the same 'esx_drugs:sellDrug' server event
-- and DrugDealerItems pricing that server/main.lua already implements.
Citizen.CreateThread(function()
    local wait = 600
    while true do
        Citizen.Wait(wait)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local distance = #(coords - Config.CircleZones.DrugDealer.coords)

        if not menuOpen and distance <= Config.CircleZones.DrugDealer.radius then
            DrawMarker(1, Config.CircleZones.DrugDealer.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 0, 0, 100, false, true, 2, false, false, false, false)
            wait = 5
        end

        if distance < 1.5 then
            if not menuOpen then
                ESX.ShowHelpNotification(_U('dealer_prompt'))

                if IsControlJustReleased(0, Keys['E']) then
                    OpenDrugShop()
                end
            end
        else
            if menuOpen then
                menuOpen = false
                ESX.UI.Menu.CloseAll()
            end
            wait = 600
        end
    end
end)

function OpenDrugShop()
    ESX.UI.Menu.CloseAll()
    local elements = {}
    menuOpen = true

    local playerInventory = ESX.GetPlayerData().inventory

    if Config.Delivery.Enabled then
        table.insert(elements, {
            label = 'Mamoriate Mahmooleh (Delivery)',
            action = 'delivery'
        })
    end

    for i=1, #price, 1 do
        for k, item in pairs(playerInventory) do
            if item.name == price[i].name and item.count > 0 then
                local dealerPrice = ESX.Math.Round(price[i].price * Config.DealerSellBonus)
                table.insert(elements, {
                    label = ('%s - <span style="color:green;">%s</span>'):format(item.label, _U('dealer_item', ESX.Math.GroupDigits(dealerPrice))),
                    name  = item.name,
                    price = dealerPrice,
                    max   = item.count
                })
            end
        end
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'drug_shop', {
        title    = _U('dealer_title'),
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.action == 'delivery' then
            menu.close()
            menuOpen = false
            TriggerServerEvent('esx_drugs:requestDelivery')
            return
        end

        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'drug_shop_amount', {
            title = _U('dealer_item', ESX.Math.GroupDigits(data.current.price))
        }, function(data1, menu1)
            menu1.close()
            local amount = tonumber(data1.value)

            if amount and amount > 0 then
                if amount <= data.current.max then
                    TriggerServerEvent('esx_drugs:sellDrug', data.current.name, amount)
                    OpenDrugShop()
                else
                    ESX.ShowNotification(_U('dealer_notenough'))
                end
            end
        end, function(data1, menu1)
            menu1.close()
        end)
    end, function(data, menu)
        menu.close()
        menuOpen = false
    end)
end

-- Shows the seller their current dealer "heat" level after every sale (server: Config.Heat)
RegisterNetEvent('esx_drugs:updateHeat')
AddEventHandler('esx_drugs:updateHeat', function(heat, maxHeat)
    local percent = math.floor((heat / maxHeat) * 100)
    local color = '~g~'

    if percent >= 70 then
        color = '~r~'
    elseif percent >= 40 then
        color = '~y~'
    end

    ESX.ShowNotification(('Garmiye Forosh: %s%s%%~s~'):format(color, percent))
end)

----------------------------------------
------- DELIVERY / ESCORT (carrier) -----
----------------------------------------
local activeDelivery = nil -- {label, amount, reward, dropCoords, dropName, endTime}
local deliveryBlip = nil

RegisterNetEvent('esx_drugs:startDelivery')
AddEventHandler('esx_drugs:startDelivery', function(data)
    activeDelivery = {
        label      = data.label,
        amount     = data.amount,
        reward     = data.reward,
        dropCoords = vector3(data.dropCoords.x, data.dropCoords.y, data.dropCoords.z),
        dropName   = data.dropName,
        endTime    = GetGameTimer() + data.duration,
    }

    if deliveryBlip then RemoveBlip(deliveryBlip) end
    deliveryBlip = AddBlipForCoord(activeDelivery.dropCoords)
    SetBlipSprite(deliveryBlip, 1)
    SetBlipColour(deliveryBlip, 5)
    SetBlipRoute(deliveryBlip, true)
    SetBlipRouteColour(deliveryBlip, 5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(activeDelivery.dropName)
    EndTextCommandSetBlipName(deliveryBlip)

    ESX.ShowNotification(_U('delivery_started', data.amount, data.label, data.dropName))

    Citizen.CreateThread(function()
        local myDelivery = activeDelivery

        while activeDelivery == myDelivery and GetGameTimer() < myDelivery.endTime do
            Citizen.Wait(0)

            local coords = GetEntityCoords(PlayerPedId())
            local distance = #(coords - myDelivery.dropCoords)
            local remaining = math.max(0, myDelivery.endTime - GetGameTimer())
            local minutes = math.floor(remaining / 60000)
            local seconds = math.floor((remaining % 60000) / 1000)

            DrawRect(0.5, 0.88, 0.15, 0.045, 0, 60, 0, 160)
            SetTextFont(4)
            SetTextScale(0.45, 0.45)
            SetTextColour(255, 255, 255, 255)
            SetTextCentre(true)
            SetTextOutline()
            BeginTextCommandDisplayText("STRING")
            AddTextComponentSubstringPlayerName(('Mahmooleh: ~g~~h~%02d:%02d~h~~s~'):format(minutes, seconds))
            EndTextCommandDisplayText(0.5, 0.858)

            if distance < 5.0 then
                ESX.ShowHelpNotification(_U('delivery_pickup_prompt'))

                if IsControlJustReleased(0, Keys['E']) then
                    TriggerServerEvent('esx_drugs:completeDelivery')
                end
            end
        end

        if activeDelivery == myDelivery then
            activeDelivery = nil
            if deliveryBlip then RemoveBlip(deliveryBlip); deliveryBlip = nil end
        end
    end)
end)

RegisterNetEvent('esx_drugs:endDelivery')
AddEventHandler('esx_drugs:endDelivery', function()
    activeDelivery = nil
    if deliveryBlip then RemoveBlip(deliveryBlip); deliveryBlip = nil end
end)

----------------------------------------
------- DOA: DELIVERY INTEL (chaser) ----
----------------------------------------
-- Only meaningful for DOA (server only sends this to doa-job players), but harmless for anyone
-- else since it just draws blips.
local doaDeliveryBlips = {}

RegisterNetEvent('esx_drugs:doaDeliveryIntel')
AddEventHandler('esx_drugs:doaDeliveryIntel', function(startCoords, endCoords, waypoints, duration)
    for i=1, #doaDeliveryBlips, 1 do
        if DoesBlipExist(doaDeliveryBlips[i]) then RemoveBlip(doaDeliveryBlips[i]) end
    end
    doaDeliveryBlips = {}

    local function addIntelBlip(coords, sprite, colour, label)
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, sprite)
        SetBlipColour(blip, colour)
        SetBlipScale(blip, 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(label)
        EndTextCommandSetBlipName(blip)
        table.insert(doaDeliveryBlips, blip)
        return blip
    end

    addIntelBlip(startCoords, 1, 1, 'Mabda Ehtemali (Report)')
    addIntelBlip(endCoords, 1, 1, 'Maghsad Ehtemali (Report)')

    for i=1, #waypoints, 1 do
        addIntelBlip(waypoints[i], 8, 46, 'Masire Ehtemali')
    end

    ESX.ShowNotification('~y~Gozareshe DOA:~s~ ye mahmooleh dar hale enteghal ast, masire ehtemali rooye naghshe eshareh shod.')

    Citizen.SetTimeout(duration, function()
        for i=1, #doaDeliveryBlips, 1 do
            if DoesBlipExist(doaDeliveryBlips[i]) then RemoveBlip(doaDeliveryBlips[i]) end
        end
        doaDeliveryBlips = {}
    end)
end)

-- DOA-only stop-and-search: press E near any other player to attempt a cargo seizure.
-- DOA can't see who's actually carrying from range -- this is a bluffable stop, not a detector.
Citizen.CreateThread(function()
    local wait = 500
    while true do
        Citizen.Wait(wait)
        wait = 500

        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'doa' then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local closestPlayer, closestDistance = nil, Config.Delivery.InterceptRadius

            for _, playerId in ipairs(GetActivePlayers()) do
                local targetPed = GetPlayerPed(playerId)
                if targetPed ~= playerPed then
                    local dist = #(coords - GetEntityCoords(targetPed))
                    if dist < closestDistance then
                        closestPlayer, closestDistance = playerId, dist
                    end
                end
            end

            if closestPlayer then
                wait = 0
                ESX.ShowHelpNotification(_U('delivery_search_prompt'))

                if IsControlJustReleased(0, Keys['E']) then
                    TriggerServerEvent('esx_drugs:seizeDelivery', GetPlayerServerId(closestPlayer))
                end
            end
        end
    end
end)

----------------------------------------
------- DOA: EVIDENCE COLLECTION --------
----------------------------------------
-- Persistent, aggregated per-field cases (server: EvidenceSites). The map blip's count keeps
-- climbing with every harvest at that field until DOA collects it or it times out server-side.
-- Newly-connecting/newly-transferred DOA get these synced automatically (server: esx:playerLoaded
-- / esx:setJob -> SyncEvidenceToPlayer), so nothing is ever missed.
--
-- Collection itself happens at a permanent "field investigator" ped standing next to each farm
-- (Config.EvidencePeds). Regular players can target the ped but get no options at all; DOA sees
-- a collect-evidence option there. This replaces walking to an invisible spot and mashing E.
local evidenceBlips = {} -- [fieldKey] = {blip = ..., coords = ..., label = ..., count = ...}

RegisterNetEvent('esx_drugs:newEvidenceSite')
AddEventHandler('esx_drugs:newEvidenceSite', function(data)
    local coords = vector3(data.coords.x, data.coords.y, data.coords.z)

    if evidenceBlips[data.id] and DoesBlipExist(evidenceBlips[data.id].blip) then
        RemoveBlip(evidenceBlips[data.id].blip)
    end

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 501)
    SetBlipColour(blip, 46)
    SetBlipScale(blip, 0.85)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(('Madrak: %s (x%s)'):format(data.label, data.count))
    EndTextCommandSetBlipName(blip)

    evidenceBlips[data.id] = {blip = blip, coords = coords, label = data.label, count = data.count}
end)

RegisterNetEvent('esx_drugs:removeEvidenceSite')
AddEventHandler('esx_drugs:removeEvidenceSite', function(fieldKey)
    if evidenceBlips[fieldKey] then
        if DoesBlipExist(evidenceBlips[fieldKey].blip) then RemoveBlip(evidenceBlips[fieldKey].blip) end
        evidenceBlips[fieldKey] = nil
    end
end)

-- Spawns the permanent investigator ped for every field zone and wires ox_target to it.
-- Each field is wrapped in pcall: if ox_target (or anything else) throws for one field, the
-- other fields still get their ped + target registered instead of the whole thread dying
-- silently on the first error (this bit us before with Unique_Skills -- same failure shape).
Citizen.CreateThread(function()
    while ESX == nil do Citizen.Wait(100) end

    for fieldKey, pedCfg in pairs(Config.EvidencePeds) do
        local ok, err = pcall(function()
            local fieldZone = Config.FieldZones[fieldKey]
            if not fieldZone then return end

            local coords = fieldZone.coords + pedCfg.offset
            local model = GetHashKey(pedCfg.model)

            RequestModel(model)
            local attempts = 0
            while not HasModelLoaded(model) and attempts < 100 do
                Citizen.Wait(10)
                attempts = attempts + 1
            end

            if not HasModelLoaded(model) then
                print(('[esx_drugs] Evidence ped for %s: model "%s" never loaded, skipping.'):format(fieldKey, pedCfg.model))
                return
            end

            local ped = CreatePed(4, model, coords.x, coords.y, coords.z - 1.0, pedCfg.heading, false, true)
            SetEntityHeading(ped, pedCfg.heading)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_BINOCULARS", 0, true)
            SetModelAsNoLongerNeeded(model)

            exports.ox_target:addLocalEntity(ped, {
                {
                    name = 'esx_drugs:collectEvidence_' .. fieldKey,
                    icon = 'fa-solid fa-magnifying-glass',
                    label = 'Barresi va Jam-avari Madarek',
                    distance = 2.5,
                    canInteract = function()
                        -- ESX.GetPlayerData() (a function call) instead of the cached
                        -- ESX.PlayerData table, and pcall-guarded: if job is ever nil for a
                        -- moment (job transition edge case), this must not silently error out
                        -- inside ox_target and make the option just never render.
                        local ok, jobName = pcall(function() return ESX.GetPlayerData().job.name end)
                        return ok and jobName == 'doa'
                    end,
                    onSelect = function()
                        if not evidenceBlips[fieldKey] then
                            ESX.ShowNotification(_U('evidence_expired'))
                            return
                        end

                        local playerPed = PlayerPedId()
                        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, true)

                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "collect_evidence",
                            duration = Config.Evidence.CollectAnimDuration,
                            label = "Dar hale barresi va sabte madarek...",
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                        }, function(cancelled)
                            ClearPedTasksImmediately(playerPed)
                            if not cancelled then
                                -- Street name has to be resolved client-side: GetStreetNameAtCoord /
                                -- GetStreetNameFromHashKey are client-only natives, not available on the server.
                                local pCoords = GetEntityCoords(playerPed)
                                local streetHash = GetStreetNameAtCoord(pCoords.x, pCoords.y, pCoords.z)
                                local streetName = GetStreetNameFromHashKey(streetHash)
                                TriggerServerEvent('esx_drugs:collectEvidence', fieldKey, streetName)
                            end
                        end)
                    end
                }
            })
        end)

        if not ok then
            print(('[esx_drugs] Evidence ped/target setup failed for %s: %s'):format(fieldKey, tostring(err)))
        end
    end
end)

-- Full suspect breakdown for the officer who just collected a case: name, gang, how many times
-- each person farmed there (worst offender first), plus a forensic snapshot per suspect
-- (vehicle/plate, skin tone, rough clothing, last-seen time). Rendered with ox_lib's context
-- menu so each entry gets a proper metadata card instead of a flat text list.
RegisterNetEvent('esx_drugs:showEvidenceReport')
AddEventHandler('esx_drugs:showEvidenceReport', function(report)
    local options = {}

    for i, suspect in ipairs(report.suspects) do
        local f = suspect.forensics
        local metadata = {
            {label = 'Gang', value = suspect.gang},
            {label = 'Tedade Farm', value = suspect.count},
            {label = 'Akharin Roeyat', value = suspect.seenAt or 'Namoshakhas'},
        }

        if f then
            table.insert(metadata, {label = 'Vasile Naghlie', value = f.vehicle or 'N/A'})
            table.insert(metadata, {label = 'Pelak', value = f.plate or 'N/A'})
            table.insert(metadata, {label = 'Jensiyat', value = f.gender or 'N/A'})
            table.insert(metadata, {label = 'Range Poost', value = f.skin or 'Namoshakhas'})
            table.insert(metadata, {label = 'Lebas (Bala/Payin/Kafsh)', value = ('%s / %s / %s'):format(f.top or '?', f.legs or '?', f.shoes or '?')})
        end

        table.insert(options, {
            title       = (i == 1) and ('Bishtarin Mozanne: ' .. suspect.name) or suspect.name,
            description = ('Gang: %s | %sx farm'):format(suspect.gang, suspect.count),
            icon        = (i == 1) and 'skull-crossbones' or 'user',
            iconColor   = (i == 1) and '#ff4d4d' or nil,
            metadata    = metadata,
            disabled    = true,
        })
    end

    if #options == 0 then
        table.insert(options, {title = 'Hich sarnakhi peida nashod.', disabled = true})
    end

    lib.registerContext({
        id      = 'esx_drugs_evidence_report',
        title   = ('Parvande: %s - %s (%sx)'):format(report.label, report.street, report.total),
        options = options,
    })

    lib.showContext('esx_drugs_evidence_report')
end)

----------------------------------------
------- DOA: FIELD INTERROGATION --------
----------------------------------------
-- General-purpose roleplay tool, not tied to any specific mechanic: lets a DOA officer engage
-- with ANY nearby player instead of the job being just "walk to a spot, target it, get paid".
-- Reuses this server's own /me convention (3dme:shareDisplay -> floating text + chat, see
-- 3dme-cl.lua) so it looks and feels native, not like a bolted-on esx_drugs popup.
Citizen.CreateThread(function()
    while ESX == nil do Citizen.Wait(100) end

    local ok, err = pcall(function()
        exports.ox_target:addGlobalPlayer({
            {
                name = 'esx_drugs:interrogate',
                icon = 'fa-solid fa-comments',
                label = 'Bazjooyi (Soal Kardan)',
                distance = 2.5,
                canInteract = function()
                    local okJob, jobName = pcall(function() return ESX.GetPlayerData().job.name end)
                    return okJob and jobName == 'doa'
                end,
                onSelect = function()
                    local playerPed = PlayerPedId()
                    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_COP_IDLES", 0, true)
                    Citizen.SetTimeout(2500, function()
                        ClearPedTasksImmediately(playerPed)
                    end)
                    TriggerServerEvent('3dme:shareDisplay', '*az in fard darbareye faaliat-haye akhirash soal mikonad*', true)
                end
            }
        })
    end)

    if not ok then
        print(('[esx_drugs] Interrogation target setup failed (is ox_target running?): %s'):format(tostring(err)))
    end
end)

RegisterNetEvent('esx_drugs:Cartel')
AddEventHandler('esx_drugs:Cartel', function(itemName)


            if itemName == 'desomorphine' then
                local lib, anim = 'anim@mp_player_intcelebrationmale@face_palm', 'face_palm'
                local playerPed = PlayerPedId()
                ESX.ShowNotification('~o~Shoma ~g~Desomorphine ~o~Masraf Kardid ~r~(50% Armor)')
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 10000, 32, 0, false, false, false)
                    Citizen.Wait(500)
                    while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                        Citizen.Wait(0)
                        DisableAllControlActions(0)
                    end
                    local lastArmor = GetPedArmour(playerPed)
                    local incrArmor = 50
                    local newArmor = lastArmor + incrArmor
                    if newArmor > 100 then
                        incrArmor = incrArmor - (newArmor - 100)
                    end
                    SetPedArmour(playerPed, newArmor)
                    SetTimeout(1000*60*30, function()
                        local poolBack = GetPedArmour(PlayerPedId()) - incrArmor
                        SetPedArmour(PlayerPedId(), poolBack)
                    end)
                end)
            elseif itemName == 'lsd' then
                local lib, anim = 'anim@mp_player_intcelebrationmale@face_palm', 'face_palm'
                local playerPed = PlayerPedId()
                ESX.ShowNotification('~o~Shoma ~g~LSD ~o~Masraf Kardid ~r~(Recoil Gun Shoma Kam Shod)')
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 10000, 32, 0, false, false, false)
                    Citizen.Wait(500)
                    while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                        Citizen.Wait(0)
                        DisableAllControlActions(0)
                    end
                    TriggerEvent('weaponry:ReduceRecoil')
                end)
            elseif itemName == 'ecstasy' then
                local lib, anim = 'anim@mp_player_intcelebrationmale@face_palm', 'face_palm'
                local playerPed = PlayerPedId()
                ESX.ShowNotification('~o~Shoma ~g~Stasy ~o~Masraf Kardid ~r~(Sorat Rah Raftan Bishtar)')
                ESX.Streaming.RequestAnimDict(lib, function()
                    TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 10000, 32, 0, false, false, false)
                    Citizen.Wait(500)
                    while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                        Citizen.Wait(0)
                        DisableAllControlActions(0)
                    end
                    Citizen.CreateThread(function()
                        local timer = true
                        SetTimeout(1000*20, function()
                            timer = false
                        end)
                        SetPedMoveRateOverride(PlayerId(), 10.0)
                        SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
                        while timer do
                            Citizen.Wait(0)
                            RestorePlayerStamina(PlayerPedId(), 1.0)
                        end
                        SetPedMoveRateOverride(PlayerId(), 0.0)
                        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                    end)
                end)
            end




end)

RegisterNetEvent('esx_jk_drugs:useItem')
AddEventHandler('esx_jk_drugs:useItem', function(itemName)
    ESX.UI.Menu.CloseAll()

    if itemName == 'marijuana' then
        local lib, anim = 'amb@world_human_smoking_pot@male@base', 'base'
        local playerPed = PlayerPedId()

        ESX.ShowNotification(_U('weed_use'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:onPot')
        end)

    elseif itemName == 'cocaine' then
        local lib, anim = 'anim@mp_player_intcelebrationmale@face_palm', 'face_palm'
        local playerPed = PlayerPedId()

        ESX.ShowNotification(_U('cocaine_use'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:cokedOut')
        end)

    elseif itemName == 'meth' then
        local lib, anim = 'mp_weapons_deal_sting', 'crackhead_bag_loop'
        local playerPed = PlayerPedId()

        ESX.ShowNotification(_U('meth_use'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:icedOut')
        end)

    elseif itemName == 'crack' then
        local lib, anim = 'mp_weapons_deal_sting', 'crackhead_bag_loop'
        local playerPed = PlayerPedId()

        ESX.ShowNotification(_U('crack_use'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:crackedOut')
        end)

    elseif itemName == 'heroine' then
        local lib, anim = 'rcmpaparazzo1ig_4', 'miranda_shooting_up'
        local playerPed = PlayerPedId()

        ESX.ShowNotification(_U('heroine_use'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 10000, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:noddinOut')
        end)

    elseif itemName == 'drugtest' then
        local lib, anim = 'misscarsteal2peeing', 'peeing_intro'
        local playerPed = PlayerPedId()

        ESX.ShowNotification(_U('drug_test'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:testing')
        end)

    elseif itemName == 'fakepee' then

        ESX.ShowNotification(_U('fake_pee'))
        TriggerEvent('esx_jk_drugs:fakePee')

    elseif itemName == 'beer' then
        local lib, anim = 'amb@world_human_drinking@beer@male@idle_a', 'idle_a'
        local playerPed = PlayerPedId()

        ESX.ShowNotification(_U('beer'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 5000, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:buzzin')
        end)

    elseif itemName == 'tequila' then
        local lib, anim = 'amb@world_human_drinking@beer@male@idle_a', 'idle_a'
        local playerPed = PlayerPedId()

        ESX.ShowNotification(_U('tequila'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 5000, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:drunk')
        end)

    elseif itemName == 'vodka' then
        local lib, anim = 'amb@world_human_drinking@beer@male@idle_a', 'idle_a'
        local playerPed = PlayerPedId()

        ESX.ShowNotification(_U('vodka'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 5000, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:drunk')
        end)
    elseif itemName == 'whiskey' then
        local lib, anim = 'amb@world_human_drinking@beer@male@idle_a', 'idle_a'
        local playerPed = PlayerPedId()

        ESX.ShowNotification(_U('whiskey'))
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 5000, 32, 0, false, false, false)

            Citizen.Wait(500)
            while IsEntityPlayingAnim(playerPed, lib, anim, 3) do
                Citizen.Wait(0)
                DisableAllControlActions(0)
            end

            TriggerEvent('esx_jk_drugs:drunk')
        end)
    elseif itemName == 'breathalyzer' then

        ESX.ShowNotification(_U('forced'))
        TriggerEvent('esx_jk_drugs:breathalyzer')
    end
end)

RegisterNetEvent('esx_jk_drugs:onPot')
AddEventHandler('esx_jk_drugs:onPot', function()
    RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
    while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
        Citizen.Wait(0)
    end
    onDrugs = true
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(GetPlayerPed(-1), true)
    SetPedMovementClipset(GetPlayerPed(-1), "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
    SetPedIsDrunk(GetPlayerPed(-1), true)
    DoScreenFadeIn(1000)
    Citizen.Wait(600000)
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(GetPlayerPed(-1), 0)
    SetPedIsDrunk(GetPlayerPed(-1), false)
    SetPedMotionBlur(GetPlayerPed(-1), false)
    ESX.ShowNotification(_U('comin_down'))
    onDrugs = false

end)

RegisterNetEvent('esx_jk_drugs:cokedOut')
AddEventHandler('esx_jk_drugs:cokedOut', function()
    RequestAnimSet("move_m@hurry_butch@a")
    while not HasAnimSetLoaded("move_m@hurry_butch@a") do
        Citizen.Wait(0)
    end
    onDrugs = true
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetPedMotionBlur(GetPlayerPed(-1), true)
    SetPedMovementClipset(GetPlayerPed(-1), "move_m@hurry_butch@a", true)
    SetPedRandomProps(GetPlayerPed(-1), true)
    SetRunSprintMultiplierForPlayer(GetPlayerPed(-1), 2.5)
    DoScreenFadeIn(1000)
    Citizen.Wait(300000)
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    ResetPedMovementClipset(GetPlayerPed(-1), 0)
    SetPedRandomProps(GetPlayerPed(-1), false)
    ClearAllPedProps(GetPlayerPed(-1), true)
    SetRunSprintMultiplierForPlayer(GetPlayerPed(-1), 1.0)
    SetPedMotionBlur(GetPlayerPed(-1), false)
    ESX.ShowNotification(_U('comin_down'))
    onDrugs = false

end)

RegisterNetEvent('esx_jk_drugs:icedOut')
AddEventHandler('esx_jk_drugs:icedOut', function()
    RequestAnimSet("move_m@hurry_butch@b")
    while not HasAnimSetLoaded("move_m@hurry_butch@b") do
        Citizen.Wait(0)
    end
    onDrugs = true
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetPedMotionBlur(GetPlayerPed(-1), true)
    SetPedMovementClipset(GetPlayerPed(-1), "move_m@hurry_butch@b", true)
    DoScreenFadeIn(1000)
	repeat
		TaskJump(GetPlayerPed(-1), false, true, false)
		Citizen.Wait(60000)
		count = count  + 1
	until count == 5
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    ResetPedMovementClipset(GetPlayerPed(-1), 0)
    ClearAllPedProps(GetPlayerPed(-1), true)
    SetPedMotionBlur(GetPlayerPed(-1), false)
    ESX.ShowNotification(_U('comin_down'))
    onDrugs = false

end)

RegisterNetEvent('esx_jk_drugs:noddinOut')
AddEventHandler('esx_jk_drugs:noddinOut', function()
    RequestAnimSet("move_m@hurry_butch@c")
    while not HasAnimSetLoaded("move_m@hurry_butch@c") do
        Citizen.Wait(0)
    end
    onDrugs = true
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetPedMotionBlur(GetPlayerPed(-1), true)
    SetPedMovementClipset(GetPlayerPed(-1), "move_m@hurry_butch@c", true)
    DoScreenFadeIn(1000)
    repeat
		DoScreenFadeOut(1000)
		SetPedToRagdoll(GetPlayerPed(-1), 5000, 0, 0, false, false, false)
		Citizen.Wait(5000)
		DoScreenFadeIn(1000)
		count = count + 1
	until count == 5
    ClearTimecycleModifier()
    ResetPedMovementClipset(GetPlayerPed(-1), 0)
    SetPedMotionBlur(GetPlayerPed(-1), false)
    ESX.ShowNotification(_U('comin_down'))
    onDrugs = false

end)

RegisterNetEvent('esx_jk_drugs:buzzin')
AddEventHandler('esx_jk_drugs:buzzin', function()
    RequestAnimSet("move_m@buzzed")
    while not HasAnimSetLoaded("move_m@buzzed") do
        Citizen.Wait(0)
    end
    onBeer = true
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetPedMotionBlur(GetPlayerPed(-1), true)
    SetPedMovementClipset(GetPlayerPed(-1), "move_m@buzzed", true)
    DoScreenFadeIn(1000)
    Citizen.Wait(150000)
    ClearTimecycleModifier()
    ResetPedMovementClipset(GetPlayerPed(-1), 0)
    SetPedMotionBlur(GetPlayerPed(-1), false)
    ESX.ShowNotification(_U('wearin_off'))
    onBeer = false

end)

RegisterNetEvent('esx_jk_drugs:drunk')
AddEventHandler('esx_jk_drugs:drunk', function()
    RequestAnimSet("move_m@drunk@moderatedrunk")
    while not HasAnimSetLoaded("move_m@drunk@moderatedrunk") do
        Citizen.Wait(0)
    end
    onLiquor = true
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetPedMotionBlur(GetPlayerPed(-1), true)
    SetPedMovementClipset(GetPlayerPed(-1), "move_m@drunk@moderatedrunk", true)
    SetPedIsDrunk(GetPlayerPed(-1), true)
    DoScreenFadeIn(1000)
    Citizen.Wait(600000)
    ClearTimecycleModifier()
    ResetPedMovementClipset(GetPlayerPed(-1), 0)
    SetPedMotionBlur(GetPlayerPed(-1), false)
    SetPedIsDrunk(GetPlayerPed(-1), false)
    ESX.ShowNotification(_U('wearin_off'))
    onLiquor = false

end)

RegisterNetEvent('esx_jk_drugs:testing')
AddEventHandler('esx_jk_drugs:testing', function()
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    if onDrugs then
        ESX.ShowNotification(_U('drug_fail'))
        TriggerServerEvent('esx_jk_drugs:testResultsFail')
    else
        ESX.ShowNotification(_U('drug_pass'))
        TriggerServerEvent('esx_jk_drugs:testResultsPass')
    end
end)

RegisterNetEvent('esx_jk_drugs:fakePee')
AddEventHandler('esx_jk_drugs:fakePee', function()
    local wasDrugged = false
    if onDrugs then
        ESX.ShowNotification(_U('fake_clean'))
        wasDrugged = true
        onDrugs = false
    else
        ESX.ShowNotification(_U('not_needed'))
    end
    Citizen.Wait(60000)
    if wasDrugged then
        onDrugs = true
    end
end)

RegisterNetEvent('esx_jk_drugs:breathalyzer')
AddEventHandler('esx_jk_drugs:breathalyzer', function()

    if onBeer then
        ESX.ShowNotification(_U('fail_tipsy'))
        TriggerServerEvent('esx_jk_drugs:testResultsFailTipsy')
    elseif onLiquor then
        ESX.ShowNotification(_U('fail_drunk'))
        TriggerServerEvent('esx_jk_drugs:testResultsFailDrunk')
    else
        ESX.ShowNotification(_U('bca_pass'))
        TriggerServerEvent('esx_jk_drugs:testResultsPassBCA')
    end
end)

RegisterNetEvent('esx_jk_drugs:crackedOut')
AddEventHandler('esx_jk_drugs:crackedOut', function()
    RequestAnimSet("move_m@hurry_butch@a")
    while not HasAnimSetLoaded("move_m@hurry_butch@a") do
        Citizen.Wait(0)
    end
    onDrugs = true
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    SetPedMotionBlur(GetPlayerPed(-1), true)
    SetPedMovementClipset(GetPlayerPed(-1), "move_m@hurry_butch@a", true)
    SetPedRandomProps(GetPlayerPed(-1), true)
    SetRunSprintMultiplierForPlayer(GetPlayerPed(-1), 1.49)
    DoScreenFadeIn(1000)
   repeat
		TaskJump(GetPlayerPed(-1), false, true, false)
		Citizen.Wait(60000)
		count = count  + 1
	until count == 5
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    ResetPedMovementClipset(GetPlayerPed(-1), 0)
    SetPedRandomProps(GetPlayerPed(-1), false)
    ClearAllPedProps(GetPlayerPed(-1), true)
    SetRunSprintMultiplierForPlayer(GetPlayerPed(-1), 1.0)
    SetPedMotionBlur(GetPlayerPed(-1), false)
    ESX.ShowNotification(_U('comin_down'))
    onDrugs = false

end)

RegisterNetEvent('esx_jk_drugs:selling')
AddEventHandler('esx_jk_drugs:selling', function()

    local playerPed = PlayerPedId()
    PedPosition        = GetEntityCoords(playerPed)
    local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }

    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local plyPos = GetEntityCoords(GetPlayerPed(-1),  true)
    local streetName, crossing = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
    local streetName, crossing = GetStreetNameAtCoord(x, y, z)
    streetName = GetStreetNameFromHashKey(streetName)
    crossing = GetStreetNameFromHashKey(crossing)

	if Config.UseESXPhone then
        if crossing ~= nil then

            local coords      = GetEntityCoords(GetPlayerPed(-1))

            TriggerServerEvent('esx_phone:send', "police", "Some shady prick is selling drugs on " .. streetName .. " and " .. crossing, true, {
                x = coords.x,
                y = coords.y,
                z = coords.z
            })
        else
            TriggerServerEvent('esx_phone:send', "police", "Some shady prick is selling drugs on " .. streetName, true, {
                x = coords.x,
                y = coords.y,
                z = coords.z
            })
        end
    elseif Config.UseGCPhone then
        if crossing ~= nil then
            local coords      = GetEntityCoords(GetPlayerPed(-1))

            TriggerServerEvent('esx_addons_gcphone:startCall', 'police', "Some shady prick is selling drugs on " .. streetName .. " and " .. crossing, PlayerCoords, {
                PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
            })
        else
            TriggerServerEvent('esx_addons_gcphone:startCall', "police", "Some shady prick is selling drugs on " .. streetName, PlayerCoords, {
                PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
            })
        end
    else
		TriggerServerEvent('esx_jk_drugs:policeAlert')
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'mt' or ESX.PlayerData.job.name == 'fbi' or ESX.PlayerData.job.name == 'cid' or ESX.PlayerData.job.name == 'cia' or ESX.PlayerData.job.name == 'marshal' or ESX.PlayerData.job.name == 'judge' or ESX.PlayerData.job.name == 'doa') then

            local coords = GetEntityCoords(GetPlayerPed(-1))

            if GetDistanceBetweenCoords(coords, 461.6, -979.56, 30.69, true) < 15 then
                DrawMarker(21, 461.6, -979.56, 30.69, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.5, 50, 50, 204, 100, true, true, 2, false, false, false, false)
            end

            if GetDistanceBetweenCoords(coords, 461.6, -979.56, 30.69, true) < 1 then
                ESX.ShowNotification("You grabbed some test kits")
                TriggerServerEvent('esx_jk_drugs:giveItem', 'drugtest')
                TriggerServerEvent('esx_jk_drugs:giveItem', 'breathalyzer')
                Citizen.Wait(10000)
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)

		local coords      = GetEntityCoords(PlayerPedId())
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone                = currentZone
			TriggerEvent('esx_drugs:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_drugs:hasExitMarker', LastZone)
		end

		if not isInMarker then
			Citizen.Wait(500)
		end

	end
end)

Citizen.CreateThread(function()
	while true do
	 	Citizen.Wait(0)
		local coords = GetEntityCoords(PlayerPedId())
		local canSleep = true

		for k,v in pairs(Config.Zones) do
			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				canSleep = false
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
			end
		end

		if canSleep then
			Citizen.Wait(500)
		end
end
end)

AddEventHandler('esx_drugs:hasEnteredMarker', function(zone)
	print(zone)
	if zone == "drug_1" then
		CurrentAction     = 'crack_menu'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ ro feshar bedid ta ~g~Crack ~w~besazid'
		CurrentActionData = {}
	elseif zone == "drug_2" then
		CurrentAction     = 'cocke_menu'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ ro feshar bedid ta ~g~Cocaine ~w~besazid'
		CurrentActionData = {}
	elseif zone == "drug_3" then
		CurrentAction     = 'marijuana_menu'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ ro feshar bedid ta ~g~Marijuana ~w~besazid'
        CurrentActionData = {}
    elseif zone == "drug_4" then
		CurrentAction     = 'ephedrine_menu'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ ro feshar bedid ta ~g~Ephedrine ~w~besazid'
        CurrentActionData = {}
    elseif zone == "drug_5" then
		CurrentAction     = 'poppy_menu'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ ro feshar bedid ta ~g~Teryak ~w~besazid'
        CurrentActionData = {}
    elseif zone == "drug_6" then
		CurrentAction     = 'opium_menu'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ ro feshar bedid ta ~g~Heroine ~w~besazid'
        CurrentActionData = {}
    elseif zone == "drug_7" then
		CurrentAction     = 'meth_menu'
		CurrentActionMsg  = 'Dokme ~INPUT_CONTEXT~ ro feshar bedid ta ~g~Shishe ~w~besazid'
        CurrentActionData = {}
	end
end)

AddEventHandler('esx_drugs:hasExitMarker', function(zone)
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction ~= nil then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, Keys['E']) then

                if CurrentAction == 'cocke_menu' then
                    ESX.DoesHaveItem('coca', 5, function()
                        SetEntityHeading(GetPlayerPed(-1), 332.93)

                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "process_cocaine",
                            duration = 7000,
                            label = "Dar hale sakhtane Cocaine",
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            animation = {
                                animDict = "amb@prop_human_bum_bin@idle_a",
                                anim = "idle_a",
                                }
                        }, function(status)
                            if not status then

                                TriggerServerEvent('esx_jk_drugs:processCocaPlant')

                            elseif status then

                                ClearPedTasksImmediately(playerPed)

                            end
                        end)
                    end, 'Tokhmn Cocaine')

                elseif CurrentAction == 'crack_menu' then

                    ESX.DoesHaveItem('cocaine', 2, function()
                        SetEntityHeading(GetPlayerPed(-1), 161.77)

                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "process_crack",
                            duration = 14000,
                            label = "Dar hale sakhtane Crack",
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            animation = {
                                animDict = "amb@prop_human_bum_bin@idle_a",
                                anim = "idle_a",
                                }
                        }, function(status)
                            if not status then

                                TriggerServerEvent('esx_jk_drugs:processCoke')

                            elseif status then

                                ClearPedTasksImmediately(playerPed)

                            end
                        end)
                    end)

                elseif CurrentAction == "marijuana_menu" then
                    ESX.DoesHaveItem('cannabis', 5, function()

                        SetEntityHeading(GetPlayerPed(-1), 150.32)

                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "process_marijuana",
                            duration = 10000,
                            label = "Dar hale sakhtane Marijuana",
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            animation = {
                                animDict = "amb@prop_human_bum_bin@idle_a",
                                anim = "idle_a",
                                }
                        }, function(status)
                            if not status then

                                TriggerServerEvent('esx_jk_drugs:processCannabis')
                                TriggerClientEvent("esx_drugs:MarijuanaProg", _source, amount, Item.name)

                            elseif status then

                                ClearPedTasksImmediately(playerPed)

                            end
                        end)
                    end, 'Barge Shahdane')

                elseif CurrentAction == "ephedrine_menu" then
                    ESX.DoesHaveItem('ephedra', 1, function()

                        SetEntityHeading(GetPlayerPed(-1), 216.87)

                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "process_ephedrine",
                            duration = 10000,
                            label = "Dar hale sakhtane Ephedrine",
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            animation = {
                                animDict = "amb@prop_human_bum_bin@idle_a",
                                anim = "idle_a",
                                }
                        }, function(status)
                            if not status then

                                TriggerServerEvent('esx_jk_drugs:processEphedra')

                            elseif status then

                                ClearPedTasksImmediately(playerPed)

                            end
                        end)
                    end)

                elseif CurrentAction == "poppy_menu" then
                    ESX.DoesHaveItem('poppy', 1, function()

                        SetEntityHeading(GetPlayerPed(-1), 164.56)
                        local TimeOut = 8000

                        local ChekSkills = 0
                        if GetResourceState('Unique_Skills') == 'started' then
                        	local ok, result = pcall(function() return exports['Unique_Skills']:CheckSkill('Heroine') end)
                        	if ok then ChekSkills = result end
                        end
						if ChekSkills == 100 then
							TimeOut = TimeOut / 2
						else
							TimeOut = TimeOut
						end


                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "process_opium",
                            duration = TimeOut,
                            label = "Dar hale sakhtane Teryak",
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            animation = {
                                animDict = "amb@prop_human_bum_bin@idle_a",
                                anim = "idle_a",
                                }
                        }, function(status)
                            if not status then
                                ClearPedTasksImmediately(playerPed)
                                TriggerServerEvent('esx_jk_drugs:processPoppy')

                            elseif status then

                                ClearPedTasksImmediately(playerPed)

                            end
                        end)
                    end, 'Khash-Khaash')

                elseif CurrentAction == "opium_menu" then
                    ESX.DoesHaveItem('opium', 10, function()

                        SetEntityHeading(GetPlayerPed(-1), 295.5)

                        local TimeOut = 12000

                        local ChekSkills = 0
                        if GetResourceState('Unique_Skills') == 'started' then
                        	local ok, result = pcall(function() return exports['Unique_Skills']:CheckSkill('Heroine') end)
                        	if ok then ChekSkills = result end
                        end
						if ChekSkills == 100 then
							TimeOut = TimeOut / 2
						else
							TimeOut = TimeOut
						end

                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "process_opium",
                            duration = TimeOut,
                            label = "Dar hale sakhtane Heroine",
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            animation = {
                                animDict = "amb@prop_human_bum_bin@idle_a",
                                anim = "idle_a",
                                }
                        }, function(status)
                            if not status then

                                TriggerServerEvent('esx_jk_drugs:processOpium')

                            elseif status then

                                ClearPedTasksImmediately(playerPed)

                            end
                        end)
                    end, 'Teryak')

                elseif CurrentAction == "meth_menu" then
                    ESX.DoesHaveItem('ephedrine', 5, function()

                        SetEntityHeading(GetPlayerPed(-1), 108.86)

                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "process_meth",
                            duration = 20000,
                            label = "Dar hale sakhtane Shishe",
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            animation = {
                                animDict = "amb@prop_human_bum_bin@idle_a",
                                anim = "idle_a",
                                }
                        }, function(status)
                            if not status then

                                TriggerServerEvent('esx_jk_drugs:processEphedrine')

                            elseif status then

                                ClearPedTasksImmediately(playerPed)

                            end
                        end)
                    end)

				end

			end
		else
			Citizen.Wait(500)
		end
	end
end)
