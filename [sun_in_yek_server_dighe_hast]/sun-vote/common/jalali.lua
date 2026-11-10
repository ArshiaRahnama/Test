-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

-- Jalali (Solar Hijri) calendar conversion utilities for Lua
-- Based on the Jalaali algorithm by Kazimierz M. Borkowski
-- Ported from jalaali-js

JalaliUtil = {}

-- Jalali month names in Persian
JalaliUtil.MonthNames = {
    'فروردین', 'اردیبهشت', 'خرداد',
    'تیر', 'مرداد', 'شهریور',
    'مهر', 'آبان', 'آذر',
    'دی', 'بهمن', 'اسفند',
}

local function div(a, b)
    return math.floor(a / b)
end

local function mod(a, b)
    return a - div(a, b) * b
end

-- Jalaali years starting the 2820-year cycle
local breaks = {
    -61, 9, 38, 199, 426, 686, 756, 818, 1111, 1181,
    1210, 1635, 2060, 2097, 2192, 2262, 2324, 2394, 2456, 3178,
}

local function jalCal(jy)
    local bl = #breaks
    local gy = jy + 621
    local leapJ = -14
    local jp = breaks[1]

    if jy < jp or jy >= breaks[bl] then
        error('Invalid Jalaali year ' .. jy)
    end

    local jump
    for i = 2, bl do
        local jm2 = breaks[i]
        jump = jm2 - jp
        if jy < jm2 then
            break
        end
        leapJ = leapJ + div(jump, 33) * 8 + div(mod(jump, 33), 4)
        jp = jm2
    end

    local n = jy - jp

    leapJ = leapJ + div(n, 33) * 8 + div(mod(n, 33) + 3, 4)

    if mod(jump, 33) == 4 and (jump - n) == 4 then
        leapJ = leapJ + 1
    end

    local leapG = div(gy, 4) - div((div(gy, 100) + 1) * 3, 4) - 150
    local march = 20 + leapJ - leapG

    if (jump - n) < 6 then
        n = n - jump + div(jump + 4, 33) * 33
    end

    local leap = mod(mod(n + 1, 33) - 1, 4)
    if leap == -1 then leap = 4 end

    return leap, gy, march
end

-- Check if a Jalaali year is leap
function JalaliUtil.isLeapYear(jy)
    local leap = jalCal(jy)
    return leap == 0
end

-- Convert Jalaali to Gregorian: returns gy, gm, gd
function JalaliUtil.toGregorian(jy, jm, jd)
    local _, gy, march = jalCal(jy)
    local g_d_m = { 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 }
    local gDayOfMarch = jd
    if jm <= 6 then
        gDayOfMarch = gDayOfMarch + (jm - 1) * 31
    else
        gDayOfMarch = gDayOfMarch + 6 * 31 + (jm - 7) * 30
    end
    -- find Gregorian date
    local gd, gm
    local gy2 = gy
    if gDayOfMarch > (march + 10) then
        -- past March 20
        local gdm = gDayOfMarch - march
        -- simple lookup
        for i = 12, 1, -1 do
            if gdm > g_d_m[i] then
                gm = i
                gd = gdm - g_d_m[i]
                break
            end
        end
    else
        -- still in March
        local gdm = gDayOfMarch + (365 - march)
        -- prev year
        gy2 = gy - 1
        -- check leap for prev year
        local isLeapG = (mod(gy2, 4) == 0 and mod(gy2, 100) ~= 0) or (mod(gy2, 400) == 0)
        if isLeapG then gdm = gdm + 1 end
        for i = 12, 1, -1 do
            local v = g_d_m[i]
            if i > 2 and isLeapG then v = v + 1 end
            if gdm > v then
                gm = i
                gd = gdm - v
                break
            end
        end
    end
    return gy2, gm or 3, gd or (gDayOfMarch - march + 1)
end

-- Convert Gregorian to Jalaali: returns jy, jm, jd
function JalaliUtil.toJalaali(gy, gm, gd)
    local g_d_m = { 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 }
    local gy2 = gm > 2 and gy or (gy - 1)
    local isLeapG = (mod(gy2, 4) == 0 and mod(gy2, 100) ~= 0) or (mod(gy2, 400) == 0)
    local days = 355666 + 365 * gy + div(gy2, 4) - div(gy2, 100) + div(gy2, 400) + g_d_m[gm] + gd
    if gm > 2 and isLeapG then days = days + 1 end
    -- subtract Jalaali epoch
    local jy = -1595 + 33 * div(days - 1, 12053)
    days = mod(days - 1, 12053)
    jy = jy + 4 * div(days, 1461)
    days = mod(days, 1461)
    if days > 365 then
        jy = jy + div(days - 1, 365)
        days = mod(days - 1, 365)
    end
    local jm, jd
    if days < 186 then
        jm = 1 + div(days, 31)
        jd = 1 + mod(days, 31)
    else
        jm = 7 + div(days - 186, 30)
        jd = 1 + mod(days - 186, 30)
    end
    return jy, jm, jd
end

-- Parse a Jalali datetime string "YYYY-MM-DD HH:MM" and return os.time() timestamp
function JalaliUtil.parseJalaliDateTime(str)
    if not str or str == '' then return nil end
    local year, month, day, hour, min = str:match('(%d+)-(%d+)-(%d+)%s+(%d+):(%d+)')
    if not year then return nil end
    local jy = tonumber(year)
    local jm = tonumber(month)
    local jd = tonumber(day)
    local gy, gm, gd = JalaliUtil.toGregorian(jy, jm, jd)
    return os.time({
        year = gy,
        month = gm,
        day = gd,
        hour = tonumber(hour),
        min = tonumber(min),
        sec = 0,
    })
end

-- Convert a Unix timestamp to Jalali datetime string "YYYY-MM-DD HH:MM"
function JalaliUtil.formatJalali(timestamp)
    if not timestamp or timestamp <= 0 then return '' end
    local t = os.date('*t', timestamp)
    local jy, jm, jd = JalaliUtil.toJalaali(t.year, t.month, t.day)
    return string.format('%04d-%02d-%02d %02d:%02d', jy, jm, jd, t.hour, t.min)
end

-- No return needed - JalaliUtil is a global table loaded via shared_scripts
