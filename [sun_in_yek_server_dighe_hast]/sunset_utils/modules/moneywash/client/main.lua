-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local coords = moneywashCoords

Citizen.CreateThread(function()
    while ESX == nil do Wait(10) end
    for k , v in pairs(coords) do
        ESX.RegisterPoint(v.xyz,2,{
            Color = {R = 255,G = 0,B = 0,A = 255},
            DrawDistance = 20,
            Radius = 0.5,
            Type = 15
        },{
            Notification = nil,
            DrawText = 'Dokme ~INPUT_CONTEXT~ jahat shosteshuye poul',
            DrawTextRadius = 4,
            DrawTextCoords = v.xyz,
            Key = 'e',
            CB = function()
                if ESX.GetPlayerData().World ~= 0 then return end
                SetEntityHeading(PlayerPedId(),v.w)
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "wash",
                    duration = 20000,
                    label = "",
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
                        ESX.TriggerServerEvent('moneywash:wash',GetClockHours())
                    elseif status then
                        ClearPedTasksImmediately(GetPlayerPed(-1))
                    end
                end)
            end,
        },{
            In = nil,
            Out = ESX.UI.Menu.CloseAll
        })
    end
end)

local dirtyBlips = {}

RegisterNetEvent('moneywash:dirtycop',function(id, coords, message)
    TriggerEvent('chatMessage', "^4[Dispatch]^7", {255, 0, 0}, ' ' .. message, 'dispatch')
    TriggerEvent('InteractSound_CL:PlayOnOne', 'dirtycop', 0.3)
    if dirtyBlips[id] then
        RemoveBlip(dirtyBlips[id])
    end
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, 51)
    PulseBlip(blip)
    dirtyBlips[id] = blip
    ESX.ShowNotification('~r~Yek mamur dar hal poul shuee ast!~w~')
end)

RegisterNetEvent('moneywash:dirtycopPos',function(id, coords)
    if dirtyBlips[id] then
        SetBlipCoords(dirtyBlips[id], coords.x, coords.y, coords.z)
    end
end)

RegisterNetEvent('moneywash:dirtycopEnd',function(id)
    if dirtyBlips[id] then
        RemoveBlip(dirtyBlips[id])
        dirtyBlips[id] = nil
    end
end)

RegisterNetEvent('moneywash:alarm',function(coords)
    local alpha = 250
    local blip = AddBlipForRadius(coords.x, coords.y, coords.z, 50.0)

    SetBlipHighDetail(blip, true)
    SetBlipColour(blip, 5)
    SetBlipAlpha(blip, alpha)
    SetBlipAsShortRange(blip, true)
    ESX.ShowNotification('~r~Poul shuee tu ruze roshan :| ! ~w~')
    while alpha ~= 0 do
        Citizen.Wait(20 * 4)
        alpha = alpha - 1
        SetBlipAlpha(blip, alpha)

        if alpha == 0 then
            RemoveBlip(blip)
            return
        end
    end
end)