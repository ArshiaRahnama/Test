-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local MODULE_NAME = 'warning'
local DEFAULT_DURATION = 10.0

local activeText = nil
local activeDuration = DEFAULT_DURATION
local held = 0.0
local threadRunning = false

local function startHoldThread()
    if threadRunning then return end
    threadRunning = true

    CreateThread(function()
        while SUN.IsUIOpen(MODULE_NAME) do
            Wait(0)
            DisableControlAction(0, 22, true) -- INPUT_JUMP (Space)

            if IsDisabledControlPressed(0, 22) then
                held = held + GetFrameTime()
            end

            local progress = math.min(held / activeDuration, 1.0)
            SUN.SendUIData(MODULE_NAME, { progress = progress })

            if held >= activeDuration then
                SUN.CloseUI(MODULE_NAME)
                break
            end
        end
        threadRunning = false
        held = 0.0
    end)
end

RegisterNetEvent('sunset_utils:warning:show')
AddEventHandler('sunset_utils:warning:show', function(text, duration)
    activeText = text or ''
    activeDuration = tonumber(duration) or DEFAULT_DURATION

    if SUN.IsUIOpen(MODULE_NAME) then
        held = 0.0
        SUN.SendUIData(MODULE_NAME, {
            text = activeText,
            duration = activeDuration,
            progress = 0.0
        })
        return
    end

    held = 0.0
    SUN.OpenUI(MODULE_NAME, {
        text = activeText,
        duration = activeDuration
    }, { type = 'overlay', focus = false, cursor = false })

    startHoldThread()
end)

AddEventHandler('sunset_utils:uiClosed', function(moduleName)
    if moduleName == MODULE_NAME then
        held = 0.0
        activeText = nil
    end
end)
