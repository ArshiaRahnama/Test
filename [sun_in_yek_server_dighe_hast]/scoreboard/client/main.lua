-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

-- Sunset RP Scoreboard Client
ESX = exports['essentialmode']:getObject()

local visible = false
local siteViewerOpen = false
local openCD = nil
local IsPaused = false

-- F10 to open scoreboard
AddEventHandler('KeyDown:f10', function()
    if (not openCD or openCD < GetGameTimer()) or visible then
        openCD = GetGameTimer() + 10000
        ToggleScoreBoard()
        TriggerEvent('InteractSound_CL:PlayOnOne', 'scoreboard', 0.1)
    end
end)

-- ESC to close scoreboard or site viewer
AddEventHandler('KeyDown:escape', function()
    if siteViewerOpen then
        CloseSiteViewer()
    elseif visible then
        CloseScoreBoard()
    end
end)

-- Backspace to close site viewer only
AddEventHandler('KeyDown:backspace', function()
    if siteViewerOpen then
        CloseSiteViewer()
    end
end)

function ToggleScoreBoard()
    visible = not visible
    SendNUIMessage({action = 'toggle'})

    if visible then
        -- Show with cursor
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)

        -- Control loop - disable camera, enable WASD (same as phone)
        Citizen.CreateThread(function()
            while visible do
                Citizen.Wait(0)

                if not siteViewerOpen then
                    -- Disable all controls
                    DisableControlAction(0, 1, true) -- disable mouse look
                    DisableControlAction(0, 2, true) -- disable mouse look
                    DisableControlAction(0, 3, true) -- disable mouse look
                    DisableControlAction(0, 4, true) -- disable mouse look
                    DisableControlAction(0, 5, true) -- disable mouse look
                    DisableControlAction(0, 6, true) -- disable mouse look
                    DisableControlAction(0, 263, true) -- disable melee
                    DisableControlAction(0, 264, true) -- disable melee
                    DisableControlAction(0, 257, true) -- disable melee
                    DisableControlAction(0, 140, true) -- disable melee
                    DisableControlAction(0, 141, true) -- disable melee
                    DisableControlAction(0, 142, true) -- disable melee
                    DisableControlAction(0, 143, true) -- disable melee
                    DisableControlAction(0, 177, true) -- disable escape
                    DisableControlAction(0, 200, true) -- disable escape
                    DisableControlAction(0, 202, true) -- disable escape
                    DisableControlAction(0, 322, true) -- disable escape
                    DisableControlAction(0, 245, true) -- disable chat
                end
            end
        end)

        Citizen.CreateThread(function()
            while visible do
                ESX.TriggerServerCallback('scoreboard:getInfo', function(data, dutyCount, mtBusy)
                    local orig_police = data.police or 0
                    local orig_sheriff = data.sheriff or 0
                    local orig_mt = data.mt or 0

                    data.police = orig_police + orig_sheriff + orig_mt
                    data.detail_police = orig_police
                    data.detail_sheriff = orig_sheriff

                    data.mt = orig_mt
                    data.mt_total = orig_mt
                    data.mt_ready = dutyCount
                    data.mt_busy = mtBusy or 0

                    SendNUIMessage({action = 'getdata', data = data})
                end)
                Citizen.Wait(15000)
            end
        end)

        -- Pause menu check
        Citizen.CreateThread(function()
            while visible do
                Citizen.Wait(500)
                if IsPauseMenuActive() and not IsPaused then
                    IsPaused = true
                    CloseScoreBoard()
                elseif not IsPauseMenuActive() and IsPaused then
                    IsPaused = false
                end
            end
        end)
    else
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
    end
end

function CloseScoreBoard()
    if visible then
        visible = false
        siteViewerOpen = false
        SendNUIMessage({action = 'hide'})
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
    end
end

-- Site viewer opened callback
RegisterNUICallback('siteViewerOpened', function(_, cb)
    siteViewerOpen = true
    -- Full focus for website (no WASD, for scrolling)
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)
    cb('ok')
end)

-- Site viewer closed callback
RegisterNUICallback('siteViewerClosed', function(_, cb)
    siteViewerOpen = false
    -- Back to scoreboard mode
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
    cb('ok')
end)

-- Close scoreboard from X button
RegisterNUICallback('close', function(_, cb)
    CloseScoreBoard()
    cb('ok')
end)

-- Close site viewer function
function CloseSiteViewer()
    if siteViewerOpen then
        siteViewerOpen = false
        SendNUIMessage({action = 'closeSiteViewer'})
        -- Back to scoreboard mode
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)
    end
end

RegisterNUICallback('requestSiteLogin', function(_, cb)
    ESX.TriggerServerCallback('scoreboard:getSiteLoginToken', function(token)
        cb({ token = token })
    end)
end)

-- Anti-cheat callback
RegisterNUICallback(GetCurrentResourceName(), function()
    TriggerServerEvent(GetCurrentResourceName())
    TriggerServerEvent("sc:adminalarm", "Open nui dev tools(dumper)")
end)
