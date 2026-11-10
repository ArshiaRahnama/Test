-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local blips = {
    {title="Mahi foroushi", colour=26, id=317, coords = vector3(-1649.65,150.58, 62.17)},
}

local item = {
    { name = 'mahi_sardine', label = "Mahi Sardine" , price = 435 },
    { name = 'mahi_sangsar', label = "Mahi Sangsar" , price = 560 },
    { name = 'mahi_ordak', label = "Ordak Mahi", price = 570 },
    { name = 'mahi_ghezel', label = "Mahi Ghezel" , price = 585 },
    { name = 'mahi_hamoor', label = "Mahi Hamoor" , price = 600 },
    { name = 'mahi_sorkhoo', label = "Mahi Sorkhoo" , price = 610 },
    { name = 'mahi_salmon', label = "Mahi Salmon" , price = 625 },
    { name = 'mahi_shooride', label = "Mahi Shooride" , price = 640 },
    { name = 'mahi_tilapia', label = "Mahi Tilapia" , price = 660 },
    { name = 'mahi_sefid', label = "Mahi Sefid", price = 680 },
    { name = 'mahi_shir', label = "Shir Mahi" , price = 700 },
    { name = 'mahi_meygoo', label = "Meygoo" , price = 720 },
    { name = 'jolbak', label = "Jolbak", price = 100 },
}



Citizen.CreateThread(function()
	waitForLoad()
end)

local grab = nil
local PlayerProps = {}
local inv = nil
local fishing = false
local tOut = 0
local memeh = false

local spam = false
local canFishing = 0
RegisterNetEvent('fishing:start', function()
    if ESX.GetPlayerData().World ~= 0 then return end
    if spam then return ESX.ShowNotification('Spam nakonid!') end
    spam = true
    Citizen.SetTimeout(5000,function()
        spam = false
    end)

    if not fishing then

        local coords = GetEntityCoords(PlayerPedId()) 
        
        local inwater , waterheight = GetWaterHeight(
            ESX.Math.Round(coords.x, 1),
            ESX.Math.Round(coords.y, 1),
            ESX.Math.Round(coords.z, 1)
        )

        if inwater == 1 then
            if IsPedSwimmingUnderWater(PlayerPedId()) or IsPedSwimming(PlayerPedId()) then return ESX.Alert('Error','Shoma nemitavanid dar in halat mahigir konid!',5000,'error') end
            if IsPedInAnyVehicle(PlayerPedId(), true) then return ESX.Alert('Error','Shoma nemitavanid dar mashin mahigir konid!',5000,'error')  end
            fishing = true
            TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_STAND_FISHING', looped2, true)
            local rand = exports['sunset_utils']:getSkillTime('fishing_skill', 'grab_fish')
            tOut = ESX.SetTimeout(rand,function()
                exports['xsound']:PlayUrl("fishbob", "./sounds/fishbob.ogg", 0.2)
                memeh = true
                Citizen.CreateThread(function()
                    local time = 2
                    ESX.showTextUI('[E] Jahat bardasht mahi '.. time .. 's')
                    function low()
                        if time > 0 and memeh and fishing then
                            time = time - 1
                            if time > 0 then
                                local color = 'lightgreen'
                                if time == 3 then
                                    color = 'lightblue'
                                elseif time == 2 then
                                    color = 'lightred'
                                elseif time == 1 then
                                    color = 'lightgrey'
                                end
                                ESX.showTextUI('[E] Jahat bardasht mahi '.. time .. 's')
                            end
                        else
                            return
                        end
                        Citizen.SetTimeout(1000,low)
                    end
                    Citizen.SetTimeout(1000,low)
                end)
                Citizen.Wait(4000)
                if memeh then
                    memeh = false
                    endHandler()
                end
            end)
            TriggerEvent("mythic_progbar:client:progress", {
                name = "fishing",
                duration = 25000,
                label = "Dar hale mahi giri",
                useWhileDead = false,
                canCancel = true,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }
            },endHandler)
        else
            ESX.Alert('Error','Shoma dar nazdiki ab nistid!',5000,'error')
        end
    end
end)

local trackedEntities = {
    GetHashKey('prop_fishing_rod_01'),
    GetHashKey('prop_fishing_rod_02')
}

function removeFishingRod()
    for k , v in pairs(ESX.Game.GetObjects()) do
        if DoesEntityExist(v) then
            local model = GetEntityModel(v)
            if model == `prop_fishing_rod_01` or model == `prop_fishing_rod_02` then
                ESX.Game.DeleteObject(v)
            end
        end
    end
end

local dropOffPoint = vector3(-41.83, 228.18, 106.95)

Citizen.CreateThread(function()
    -- for _, info in pairs(blips) do
    --     info.blip = AddBlipForCoord(info.coords.x, info.coords.y, info.coords.z)
    --     SetBlipSprite(info.blip, info.id)
    --     SetBlipDisplay(info.blip, 4)
    --     SetBlipScale(info.blip, 1.0)
    --     SetBlipColour(info.blip, info.colour)
    --     SetBlipAsShortRange(info.blip, true)
    --     BeginTextCommandSetBlipName("STRING")
    --     AddTextComponentString(info.title)
    --     EndTextCommandSetBlipName(info.blip)
    -- end
end)
  
function endHandler()
    fishing = false
    memeh = false
    removeFishingRod()
    ClearPedTasksImmediately(PlayerPedId())
    TriggerEvent('mythic_progbar:client:cancel')
    ESX.ClearTimeout(tOut)
    ESX.hideTextUI()
    Citizen.Wait(1500)
    ESX.hideTextUI()
end

--AddEventHandler('KeyDown:x',endHandler)
-- function(status)
--     -- if not status then
--     --     fishing = false
--     --     removeFishingRod()
--     --     ClearPedTasksImmediately(PlayerPedId())
--     --     
--     -- elseif status then
--     --     removeFishingRod()
--     --     fishing = false
--     --     ClearPedTasksImmediately(PlayerPedId())
--     -- end
--     removeFishingRod()
--     fishing = false
--     ClearPedTasksImmediately(PlayerPedId())
-- end
local game

AddEventHandler('KeyDown:e',function()
    if fishing then
        if memeh then
            endHandler()
            if canFishing <= 0 then
                if game then
                    if ESX.playMiniGame(4, 3) then
                        canFishing = 20
                        game = ESX.chance(50)
                    end
                else
                    local success = lib.skillCheck({'easy', 'easy'}, {'1', '2', '3'})
                    if success then
                        canFishing = 20
                        game = ESX.chance(50)
                    end
                end
            end
            if canFishing > 0 then
                canFishing = canFishing - 1
                ESX.TriggerServerEvent('fishing:done')
            end
        else
            endHandler()
        end
    else
        if ESX.DoesHaveItem('gholab',1,nil,nil,false) then
            local coords = GetEntityCoords(PlayerPedId()) 
            local inwater , waterheight = GetWaterHeight(
                ESX.Math.Round(coords.x, 1),
                ESX.Math.Round(coords.y, 1),
                ESX.Math.Round(coords.z, 1)
            )
            if inwater and ESX.GetPlayerData().World == 0 then
                if IsPedSwimmingUnderWater(PlayerPedId()) or IsPedSwimming(PlayerPedId()) then return end
                if IsPedInAnyVehicle(PlayerPedId(), true) then return end
                TriggerEvent('fishing:start')
            end
        end
    end
end)