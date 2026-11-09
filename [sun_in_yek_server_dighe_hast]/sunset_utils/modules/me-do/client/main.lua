-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local color = { r = 255, g = 255, b = 255, alpha = 255 } -- Color of the text
local font = 0 -- Font of the text
local time = 10000 -- Duration of the display of the text : 1000ms = 1sec
local background = {
    enable = false,
    color = { r = 153, g = 0, b = 153, alpha = 255 },
}
local dropShadow = false

local mainCD = false
local lasttext = nil
local function cdStuff()
    mainCD = true
    Citizen.SetTimeout(5000,function()
        mainCD = false
    end)
end 

local nbrDisplaying = 1
local function send(text,force, cmd)
    if text and (lasttext ~= text or force) then
        lasttext = text
        ESX.TriggerServerEvent('3dme:shareDisplay', text,ESX.Game.GetPlayersToSend(50), cmd)
    end
end

local function DrawText3D(x,y,z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    local scale = ((1/dist)*2)*(1/GetGameplayCamFov())*100

    if onScreen then

        -- Formalize the text
        SetTextColour(color.r, color.g, color.b, color.alpha)
        SetTextScale(0.0*scale, 0.7*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextCentre(true)
        if dropShadow then
            SetTextDropshadow(10, 100, 100, 100, 255)
        end

        -- Calculate width and height
        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55*scale, font)
        local width = EndTextCommandGetWidth(font)

        -- Diplay the text
        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)

        if background.enable then
            DrawRect(_x, _y+scale/45, width, height, background.color.r, background.color.g, background.color.b , background.color.alpha)
        end
    end
end

local function Display(mePlayer, text, offset,src)
    local displaying = true

    local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
    local coords = GetEntityCoords(PlayerPedId(), false)
    local dist = Vdist2(coordsMe, coords)

    if dist < 50 then
        TriggerEvent('chat:addMessage', {
            color = { 104, 50, 168 },
            multiline = true,
            args = { '(' .. src .. ') : ' ..text}
        }, 'me')

    end

    Citizen.CreateThread(function()
        Wait(time)
        displaying = false
    end)
    Citizen.CreateThread(function()
        nbrDisplaying = nbrDisplaying + 1
        while displaying do
            Wait(0)
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist2(coordsMe, coords)
            if dist < 50 then
                DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']+offset, text)
            end
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end

local function DisplayDo(mePlayer, text, offset,src)
    local displaying = true

    -- Chat message

    local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
    local coords = GetEntityCoords(PlayerPedId(), false)
    local dist = Vdist2(coordsMe, coords)

    if dist < 50 then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0 },
            multiline = true,
            args = { '(' .. src .. ') : ' ..text}
        }, 'do')

    end

end



RegisterNetEvent('3dme:send')
AddEventHandler('3dme:send', function(text,force)
    if mainCD and not force then return end
    cdStuff()
    send(text,force)
end)

exports('me',send)

RegisterCommand('me', function(source, args, user)
    if not ESX then return end
    if ESX.GetPlayerData().World ~= 0 and not exports['sun-robbery']:doesInRob() then return end
    if ESX.GetPlayerData().IsDead then
        return ESX.chatMessage('Dar halate dead nemitavanid az in command estefade konid', 'plarms')
    end
    if mainCD then return ESX.Alert('Spam','Spam nakonid!',5000,'warning') end
    cdStuff()
    if args[1] == nil then return end
    local text = table.concat(args, " ")
    send(text, nil, true)
end)

RegisterCommand('do', function(source, args, user)
    if not ESX then return end
    if ESX.GetPlayerData().World ~= 0 and not exports['sun-robbery']:doesInRob() then return end
    if ESX.GetPlayerData().IsDead then
        return ESX.chatMessage('Dar halate dead nemitavanid az in command estefade konid', 'plarms')
    end
    if mainCD then return ESX.Alert('Spam','Spam nakonid!',5000,'warning') end
    cdStuff()
    if args[1] == nil then return end
    local text = table.concat(args, " ")
    ESX.TriggerServerEvent('3dme:shareDisplayDo', text,ESX.Game.GetPlayersToSend(50))
end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source)
    if not ESX then return end
    if not ESX.Game.PlayerExist(source) then return end
    local offset = 1 + (nbrDisplaying*0.1)
    Display(GetPlayerFromServerId(source), text, offset,source)
end)

RegisterNetEvent('3dme:triggerDisplayDo')
AddEventHandler('3dme:triggerDisplayDo', function(text, source)
    if not ESX then return end
    if not ESX.Game.PlayerExist(source) then return end
    local offset = 1 + (nbrDisplaying*0.1)
    DisplayDo(GetPlayerFromServerId(source), text, offset,source)
end)
