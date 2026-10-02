--[[ ===========================================================================
    esx_uniquejobs | client/unit_plate_helper.lua

    ---------------------------------------------------------------------------
    چرا این فایل لازم بود (درخواست شده)
    ---------------------------------------------------------------------------
    هر کدوم از ۱۳ فایل جاب (police/fbi/sheriff/marshal/cia/doa/judge/mt/cid/
    ambulance/taxi/mechanic/weazel) موقع گرفتن ماشین از گاراژ سازمانی یه
    `lib.inputDialog('Enter Vehicle Plate', ...)` نشون می‌داد و بازیکن باید
    دستی ۶ کاراکتر پلاک وارد می‌کرد. درخواست شد این به سیستم یونیت
    (client/unit_manager.lua, server/unit_manager.lua) وصل بشه: اگه بازیکن
    یونیت نداره بگه اول یونیت بساز (/unit)، و اگه داره، پلاک خودکار از روی
    callsign یونیتش ساخته بشه (مثلاً یونیت "STAFF-1" → پلاک "STAFF1"،
    دقیقاً همون چیزی که تو اسکرین‌شات‌های گزارش‌شده دیده شد).

    ---------------------------------------------------------------------------
    نحوه‌ی استفاده (جایگزین مستقیم lib.inputDialog)
    ---------------------------------------------------------------------------
    هر جای کد قبلاً این بود:
        local plate = lib.inputDialog('Enter Vehicle Plate', {'Plate (6 characters)'}, {max = 6})

    الان اینه:
        local plate = GetUnitPlateOrWarn()

    خروجی دقیقاً همون شکلیه که lib.inputDialog برمی‌گردوند (یه جدول با یه
    رشته‌ی ۱ تا ۶ کاراکتری تو ایندکس ۱، یا nil اگه چیزی برنگشت) - پس همه‌ی
    کد پایین‌دستی (چک `if plate and plate[1] then ...`, فراخوانی
    checkPlateInServer و اضافه‌کردن پیشوند سازمان) دقیقاً همونطوری که بود
    کار می‌کنه، بدون نیاز به تغییر دیگه‌ای.
=========================================================================== ]]

function GetUnitPlateOrWarn()
    local result = nil
    local done = false

    ESX.TriggerServerCallback('esx_uniquejobs:getUnitMenu', function(unitData)
        if unitData and unitData.myUnit and unitData.myUnit.callsign and unitData.myUnit.callsign ~= '' then
            -- Plates are alphanumeric only and capped at 6 characters here
            -- (matches the old manual-entry dialog's {max = 6}) - strip
            -- anything else (the dash in "STAFF-1", spaces, etc.) and
            -- truncate. A short callsign (e.g. "A1") is left as-is; GTA
            -- plates don't need to be exactly 6 characters.
            local callsign = string.upper(unitData.myUnit.callsign):gsub('[^%w]', '')
            if #callsign > 6 then
                callsign = string.sub(callsign, 1, 6)
            end
            if #callsign > 0 then
                result = { callsign }
            end
        end
        done = true
    end)

    while not done do
        Citizen.Wait(0)
    end

    if not result then
        ESX.ShowNotification('You must create a unit first (type /unit) before taking out a vehicle')
    end

    return result
end
