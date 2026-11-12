--[[ Unique RP - spectate HUD (Sunset-style info, drawn on the RIGHT side of the screen)
    Called every frame from client/aduty_spectate.lua while spectating.
    Keys: [X] player control menu   [~] leave spectate (same keys as before)
]]

local ACC = { r = 101, g = 174, b = 255 }                 -- Unique accent (matches the chat / panels)
local lastSpeed, lastAccel, lastTick = 0, 0, 0

local function txt(str, x, y, scale, r, g, b, right)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextScale(0.0, scale)
    SetTextColour(r or 255, g or 255, b or 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextOutline()
    if right then
        SetTextRightJustify(true)
        SetTextWrap(0.0, x)
    end
    SetTextEntry('STRING')
    AddTextComponentString(str)
    EndTextCommandDisplayText(right and 0.0 or x, y)
end

local function onOff(v, good)       -- coloured value (green = fine, red = suspicious)
    return (v == good) and '~g~' or '~r~'
end

function UniqueDrawSpectateHud(serverId, playerIdx, ped, keys)
    keys = keys or {}
    local rows = {}
    local pd = PlayerData or {}
    local icName = (pd.name and tostring(pd.name):gsub('_', ' ')) or GetPlayerName(playerIdx) or '?'

    rows[#rows + 1] = { 'ID',     tostring(serverId) }
    rows[#rows + 1] = { 'Name',   icName }
    rows[#rows + 1] = { 'Health', ('%d/%d'):format(math.max(GetEntityHealth(ped) - 100, 0), math.max(GetEntityMaxHealth(ped) - 100, 0)) }
    rows[#rows + 1] = { 'Armor',  tostring(GetPedArmour(ped)) }

    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= 0 then
        local speed = math.floor(GetEntitySpeed(veh) * 3.6)
        if GetGameTimer() - lastTick > 1000 then               -- acceleration = km/h change per second
            lastAccel, lastSpeed, lastTick = speed - lastSpeed, speed, GetGameTimer()
        end
        rows[#rows + 1] = { 'Vehicle Speed',  speed .. ' km/h' }
        rows[#rows + 1] = { 'Vehicle Health', tostring(GetEntityHealth(veh)) }
        rows[#rows + 1] = { 'Engine Health',  tostring(math.floor(GetVehicleEngineHealth(veh))) }
        rows[#rows + 1] = { 'Acceleration',   tostring(lastAccel) }
    end

    local talking = NetworkIsPlayerTalking(playerIdx)
    rows[#rows + 1] = { 'Talking', (talking and '~g~True' or '~r~False') }

    -- cheat indicators kept from the old HUD
    local god = GetPlayerInvincible(playerIdx)
    rows[#rows + 1] = { 'Godmode', god and '~r~Found' or '~g~Not Found' }
    if not CanPedRagdoll(ped) and veh == 0 and (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0)
        and not IsPedInParachuteFreeFall(ped) then
        rows[#rows + 1] = { 'Anti-Ragdoll', '~r~Found' }
    end

    -- layout (right side)
    local RIGHT, W = 0.985, 0.175
    local X0 = RIGHT - W                       -- left edge
    local TOP, LH = 0.305, 0.028
    local h = 0.034 + (#rows * LH) + 0.014 + (#keys * 0.024)     -- header + rows + key hints
    DrawRect(X0 + W / 2, TOP + h / 2, W, h, 10, 12, 18, 205)
    DrawRect(X0 + W / 2, TOP + 0.0015, W, 0.003, ACC.r, ACC.g, ACC.b, 255)           -- accent bar

    txt('SPECTATING', RIGHT - 0.008, TOP + 0.007, 0.34, ACC.r, ACC.g, ACC.b, true)
    for i, r in ipairs(rows) do
        local y = TOP + 0.034 + (i - 1) * LH
        txt(r[1], X0 + 0.008, y, 0.30, 190, 198, 212, false)                          -- label (left of the card)
        txt(r[2], RIGHT - 0.008, y, 0.30, 255, 255, 255, true)                        -- value (right aligned)
    end
    local ky = TOP + 0.034 + #rows * LH + 0.010
    DrawRect(X0 + W / 2, ky - 0.004, W - 0.016, 0.0012, 255, 255, 255, 40)            -- divider
    for i, k in ipairs(keys) do
        local y = ky + (i - 1) * 0.024
        txt(k[1], X0 + 0.008, y, 0.28, ACC.r, ACC.g, ACC.b, false)
        txt(k[2], RIGHT - 0.008, y, 0.27, 190, 198, 212, true)
    end
end

-- Draw every frame (this file's natives must run each frame or the HUD flickers); the spectate loop in
-- aduty_spectate.lua only refreshes UniqueSpec, and the HUD vanishes by itself ~200 ms after spectating stops.
CreateThread(function()
    while true do
        local sp = UniqueSpec
        if sp and (GetGameTimer() - sp.t) < 200 and DoesEntityExist(sp.ped) then
            UniqueDrawSpectateHud(sp.id, sp.idx, sp.ped, sp.keys)
            Wait(0)
        else
            Wait(250)
        end
    end
end)
