-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

CreateThread(function()
    waitForLoad(10000)
    ESX.RegisterClientCallback('sim:alert', function(cb)
        exports['sun-inventory-hud']:closeInventory()
        local alert = lib.alertDialog({
            header = '⚠️تغییر شماره تلفن⚠️',
            content = 'با تایید این مورد شماره موبایل قبلی شما به صورت دائمی تغییر خواهد کرد و به هیچ وجه امکان بازگردانی آن وجود ندارد!',
            centered = true,
            cancel = true
        })
        cb(alert == 'confirm')
    end)
end)