-- ============================================================
-- Unique_Hud / client / combat.lua  (کامبت‌مود کاربر ادغام شد)
-- ============================================================
-- بدون تغییر منتقل شد؛ این ماژول به هیچ ریسورس دیگه‌ای (pNotify و غیره)
-- وابسته نبود، فقط SendNUIMessage خام - پس چیزی برای فیکس نداشت.

RegisterNetEvent('sscombat:toggle', function(status, time)
    if status then
        SendNUIMessage({
            action = 'new',
            time = time
        })
    else
        SendNUIMessage({
            action = 'hide'
        })
    end
end)

