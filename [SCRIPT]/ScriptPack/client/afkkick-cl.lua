-- AFK check for on-duty jobs.
-- Idle AFK.IdleSeconds (15 min) -> chat warning with a math question, answer with /afk <number>.
-- No/wrong answer in time -> automatic off-duty (esx_duty:setjob) + /f announcement. Nobody is kicked.
-- This replaces the old kick-based AFK here AND the AFK block that used to live in esx_uniquejobs/duty.

local AFK = {
    IdleSeconds   = 900,   -- 15 minutes without moving
    MoveDistance  = 2.0,   -- movement under this many meters counts as idle
    AnswerSeconds = 120,   -- time to answer after the warning
    WarnAt        = { [60] = true, [30] = true, [10] = true },
    MaxWrong      = 3,
    -- 'whitelist' = only AFK.Jobs are checked (safe: these have an off<job> variant).
    -- 'exclude'   = every job except AFK.Exclude.
    Mode          = 'whitelist',
    Jobs = {
        cid = true, cia = true, marshal = true, fbi = true, judge = true, doa = true,
        police = true, sheriff = true, mt = true,
        taxi = true, mechanic = true, ambulance = true, weazel = true,
    },
    Exclude = { nojob = true, resturan = true, wash = true, carbimeh = true },
}

local ESXobj = nil
CreateThread(function()
    while ESXobj == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESXobj = obj end)
        Wait(50)
    end
end)

local function newState()
    return { idle = 0, warned = false, timer = 0, a = 0, b = 0, result = 0, fail = 0 }
end
local state = newState()
local prevPos = nil
local running = false -- guards against double off-duty while the job change round-trips

local function say(msg)
    TriggerEvent('chatMessage', '[SYSTEM]', { 255, 0, 0 }, msg, 'plarms') -- 'plarms' = chat category (ignored by chats without categories)
end

local function isTracked(job)
    if not job or not job.name then return false end
    local name = job.name
    if name == 'nojob' or string.sub(name, 1, 3) == 'off' then return false end
    if AFK.Mode == 'whitelist' then
        return AFK.Jobs[name] == true
    end
    if AFK.Exclude[name] then return false end
    if name == 'fbi' and (tonumber(job.grade) or 0) >= 13 then return false end
    return true
end

local function isDeadNow(ped)
    if IsEntityDead(ped) then return true end
    local pd = ESXobj and ESXobj.GetPlayerData and ESXobj.GetPlayerData()
    return pd and pd['IsDead'] == 1 or false
end

local function warnText()
    return ("^0Shoma ^2%d ^0saniye digar be elaat ^1AFK ^0bodan off duty mishavid, lotfan az makan fe'eli khod ta hengami ke peygham afk ra daryaft konid jabeja shavid ya be soal robero javab dahid ^3/afk ^2%d^0+^4%d^0")
        :format(state.timer, state.a, state.b)
end

local function resetAFK(announce)
    if announce then
        say('^0Shoma digar be onvan karbar ^1AFK ^0hesab ^2nemishavid^0!')
    end
    state = newState()
    prevPos = nil
end

local function afkOffDuty(job)
    if running then return end
    running = true
    -- esx_duty:setjob is a toggle; isTracked() guarantees we are on duty right now.
    TriggerServerEvent('esx_duty:setjob', job.name)
    ExecuteCommand('f [Auto message] man be dalil afk off duty shodam.')
    state = newState()
    prevPos = nil
    SetTimeout(10000, function() running = false end)
end

CreateThread(function()
    while true do
        Wait(1000)
        local pd = ESXobj and ESXobj.GetPlayerData and ESXobj.GetPlayerData()
        local job = pd and pd.job
        if job and not running and isTracked(job) then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            if prevPos and #(pos - prevPos) <= AFK.MoveDistance and not isDeadNow(ped) then
                state.idle = state.idle + 1
                if state.idle >= AFK.IdleSeconds then
                    if not state.warned then
                        state.warned = true
                        state.timer = AFK.AnswerSeconds
                        state.a = math.random(1, 10)
                        state.b = math.random(1, 10)
                        state.result = state.a + state.b
                        say(warnText())
                    else
                        state.timer = state.timer - 1
                        if state.timer <= 0 then
                            afkOffDuty(job)
                        elseif AFK.WarnAt[state.timer] then
                            say(warnText())
                        end
                    end
                end
            else
                if state.warned then resetAFK(true) else state = newState() end
            end
            prevPos = pos
        else
            -- off duty / untracked job: accumulate nothing
            if state.warned or state.idle > 0 then state = newState() end
            prevPos = nil
        end
    end
end)

RegisterCommand('afk', function(_, args)
    if not state.warned then
        say('^0Shoma hich afk math acitivi nadarid!')
        return
    end
    if not args[1] then
        say('^0Shoma dar ghesmat javab chizi vared nakardid!')
        return
    end
    local input = tonumber(args[1])
    if not input then
        say('^0Shoma dar ghesmat javab faghat mitavanid adad vared konid!')
        return
    end
    if input == state.result then
        resetAFK(true)
        return
    end
    state.fail = state.fail + 1
    if state.fail >= AFK.MaxWrong then
        local pd = ESXobj and ESXobj.GetPlayerData and ESXobj.GetPlayerData()
        if pd and pd.job and isTracked(pd.job) then afkOffDuty(pd.job) end
        return
    end
    say(('^0Javab vared shode eshtebah bod, shoma ^2%d^0 bar digar ^3forsat^0 javab darid!'):format(AFK.MaxWrong - state.fail))
end, false)