-- ============================================================
-- Unique_VehicleSeatFix / client.lua
-- ============================================================
-- این ریسورس برای دور زدن یه باگ شناخته‌شده‌ی FiveM هست: بعضی وقتا وقتی
-- بازیکن به روش غیرعادی (نه با کلید معمولی خروج) از ماشین جدا می‌شه، صندلی
-- ماشین تو دیتای داخلی بازی هنوز "اشغال‌شده" باقی می‌مونه (یه رفرنس رهاشده)
-- با اینکه ظاهراً خالیه، و بازی دیگه اجازه‌ی سوار شدن نمی‌ده - انگار داری
-- از کنار ماشین رد می‌شی.
--
-- این اسکریپت وقتی نزدیک یه ماشینه و دکمه‌ی سوار شدن (E) رو نگه می‌داری ولی
-- سوار نمی‌شی، بعد از یه تاخیر کوتاه بازیکن رو مستقیم با SetPedIntoVehicle
-- (که برخلاف TaskEnterVehicle، اجازه‌ی سوار شدن رو "زوری" می‌ده و به وضعیت
-- قبلیِ صندلی کاری نداره) وارد صندلی می‌کنه.
--
-- توجه: این یه دور-زدنِ (workaround) این باگ خاصه، نه فیکسِ ریشه‌ای. اگه علت
-- اصلی از یه چیز خارج از این ریپو (مثلاً ریسورس CarLock که این‌جا نیست، یا
-- یه ابزار خارجی) باشه، ریشه‌ش رفع نمی‌شه - ولی بازیکن دیگه گیر نمی‌کنه.

local FORCE_ENTER_HOLD_MS = 800

Citizen.CreateThread(function()
    local holdStart = nil
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped, false) then
            local vehicle, seat = GetClosestVehicleAndFreeSeat(ped)
            if vehicle then
                DisplayHelpTextThisFrame("~INPUT_CONTEXT~ Baraye Sovar Shodane Zoori (Age Mashin Bag Dare)")
                if IsControlPressed(0, 51) then -- E / INPUT_CONTEXT
                    if not holdStart then holdStart = GetGameTimer() end
                    if GetGameTimer() - holdStart > FORCE_ENTER_HOLD_MS then
                        SetPedIntoVehicle(ped, vehicle, seat)
                        holdStart = nil
                    end
                else
                    holdStart = nil
                end
            else
                holdStart = nil
            end
        else
            holdStart = nil
        end
    end
end)

function GetClosestVehicleAndFreeSeat(ped)
    local pedCoords = GetEntityCoords(ped)
    local vehicle = GetClosestVehicle(pedCoords.x, pedCoords.y, pedCoords.z, 3.0, 0, 70)
    if vehicle == 0 or not DoesEntityExist(vehicle) then return nil end
    -- فقط وقتی واقعاً به نظر بازی صندلی‌ها "اشغاله" ولی ظاهراً کسی توش نیست
    -- (سناریوی همون باگ)، این گزینه رو نشون بده.
    for seat = -1, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
        if not IsVehicleSeatFree(vehicle, seat) then
            local occupant = GetPedInVehicleSeat(vehicle, seat)
            if occupant == 0 or not DoesEntityExist(occupant) then
                return vehicle, seat
            end
        end
    end
    return nil
end

function DisplayHelpTextThisFrame(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end