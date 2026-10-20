-- Unique_Crafting (client). The page lives in the Unique_ALLGangs router (frame "crafting").

local ESX = nil
local craftingQueue = {}
-- every bench the player can use: public (config) + owned gun shops (server)
local Benches = CraftConfig.Workbenches
local menuOpen = false

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(100)
    end
end)

-- every message goes to the crafting frame; "silent" keeps the frame hidden
local function SendCraftNUI(msg, silent)
    -- the router wants { __routeTo, payload }: the page only ever sees `payload`
    SendNUIMessage({ __routeTo = 'crafting', payload = msg, __silent = silent and true or nil })
end

local function HideCraftFrame()
    SendNUIMessage({ __routeTo = 'crafting', __hide = true })
end

local function nearWorkbench()
    local coords = GetEntityCoords(PlayerPedId())
    for _, v in ipairs(Benches) do
        if #(coords - v.coords) < (v.radius or 3.0) then return true end
    end
    return false
end

-- blips
CreateThread(function()
    for _, v in ipairs(CraftConfig.Workbenches) do
        if v.blip then
            local blip = AddBlipForCoord(v.coords)
            SetBlipSprite(blip, CraftConfig.BlipSprite)
            SetBlipScale(blip, 0.7)
            SetBlipColour(blip, CraftConfig.BlipColor)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString('Gun Sazi')
            EndTextCommandSetBlipName(blip)
        end
    end
end)

local function openMenu()
    ESX.TriggerServerCallback('Unique_Crafting:open', function(res)
        if not res or not res.ok then
            return ESX.ShowNotification(res and res.reason or 'Error', 'error')
        end
        ESX.TriggerServerCallback('Unique_Crafting:getItemNames', function(names)
            menuOpen = true
            SetNuiFocus(true, true)
            TriggerScreenblurFadeIn(1000)

            -- shop benches show the GANG ARMORY counts, public ones the player's own bag
            local inv = res.inventory
            if not inv then
                inv = {}
                local pdata = ESX.GetPlayerData() or {}
                for _, v in ipairs(pdata.inventory or {}) do
                    if v and v.name then inv[v.name] = v.count or 0 end
                end
            end

            SendCraftNUI({
                type = 'open',
                recipes = res.recipes,
                names = names,
                rank = res.rank,
                level = 0,
                inventory = inv,
                job = '',
                grade = 0,
                hidecraft = CraftConfig.HideWhenCantCraft,
                categories = res.categories,
            })
        end)
    end)
end

-- refresh the list of benches (owned gun shops change hands)
CreateThread(function()
    while ESX == nil do Wait(200) end
    while true do
        ESX.TriggerServerCallback('Unique_Crafting:benches', function(list)
            local out = {}
            for _, b in ipairs(list or {}) do
                out[#out + 1] = { coords = vec3(b.coords.x, b.coords.y, b.coords.z), radius = b.radius or 3.0, public = b.public }
            end
            Benches = out
        end)
        Wait(10000)
    end
end)

-- E near a workbench
CreateThread(function()
    while true do
        local sleep = 500
        local coords = GetEntityCoords(PlayerPedId())
        for _, v in ipairs(Benches) do
            local d = #(coords - v.coords)
            local radius = v.radius or 3.0
            if d < radius + 3.0 then
                sleep = 1
                CR_DrawTexet3D(v.coords.x, v.coords.y, v.coords.z - 0.3, 'Press [E] For Craft')
                DrawMarker(6, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.6, 0.6, 0.6, 0, 213, 255, 100, false, true, 2, false, false, true, false)
                if d < radius + 1.0 and not menuOpen and IsControlJustReleased(0, 38) then
                    openMenu()
                end
            end
        end
        Wait(sleep)
    end
end)

-- queue timer: counts down only while the player stays at the bench
CreateThread(function()
    while true do
        Wait(1000)
        local first = craftingQueue[1]
        if first and (not CraftConfig.CraftingStopWithDistance or nearWorkbench()) then
            first.time = first.time - 1
            SendCraftNUI({ type = 'addqueue', item = first.item, time = first.time, id = first.id }, true)
            if first.time <= 0 then
                TriggerServerEvent('Unique_Crafting:itemCrafted', first.item, first.count)
                table.remove(craftingQueue, 1)
            end
        end
    end
end)

RegisterNetEvent('Unique_Crafting:craftStart', function(item, time)
    local id = math.random(1000, 9999)
    local count = 1
    table.insert(craftingQueue, { time = time, item = item, count = count, id = id })
    SendCraftNUI({ type = 'crafting', item = item }, true)
    SendCraftNUI({ type = 'addqueue', item = item, time = time, id = id }, true)
end)

RegisterNetEvent('Unique_Crafting:sendMessage', function(msg)
    ESX.ShowNotification(msg)
end)

local function CloseCraftMenu()
    menuOpen = false
    TriggerScreenblurFadeOut(1000)
    SetNuiFocus(false, false)
    HideCraftFrame()
end

RegisterNUICallback('qc_close', function(_, cb)
    CloseCraftMenu()
    cb('ok')
end)

-- Safety net: ESC always closes the menu and returns the mouse.
CreateThread(function()
    while true do
        if menuOpen then
            Wait(0)
            if IsControlJustPressed(0, 322) or IsControlJustPressed(0, 200) then CloseCraftMenu() end
        else
            Wait(250)
        end
    end
end)

RegisterNUICallback('qc_craft', function(data, cb)
    TriggerServerEvent('Unique_Crafting:craft', data and data.item)
    cb('ok')
end)

function CR_DrawTexet3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    local scale = ((1 / dist) * 2) * (1 / GetGameplayCamFov()) * 100
    if onScreen then
        SetTextColour(255, 255, 255, 255)
        SetTextScale(0.0 * scale, 0.35 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextCentre(true)
        SetTextDropshadow(1, 1, 1, 1, 255)
        SetTextEntry('STRING')
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
    end
end
