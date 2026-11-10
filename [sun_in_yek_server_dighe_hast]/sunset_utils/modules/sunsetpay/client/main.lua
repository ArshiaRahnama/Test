-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

RegisterCommand('sunsetpay',function()
    local elements = {
        {label = 'Poul(Bank)', value = 1},
        {label = 'TC', value = 2},
        {label = 'Token', value = 3},
    }
    ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'ask_type',
    {
        title 	 = 'Pay type',
        align    = 'center',
        question = 'Noe pardakht ra entekhab konid?',
        elements = elements
    }, function(data, menu)
        menu.close()
        local type = data.current.value
        ESX.UI.Menu.Open('dialog',GetCurrentResourceName(),'get_amount',
        {
            title = (type == 1 and 'Mablagh' or 'Tedad') .. ' ra vared konid'
        },
        function(data1,menu1)
            local amount = data1.value
            menu1.close()
            if tonumber(amount) and amount > 0 then
                if type == 1 and amount < 100000 then
                    return ESX.Alert('Error',(type == 1 and 'Mablagh' or 'Tedad') .. ' vared shoda bayad bishtar az 100k bashad!',7000,'error')
                end
                ESX.UI.Menu.Open('dialog',GetCurrentResourceName(),'get_reason',
                {
                    title = 'Dalil pardakht ra vared konid'
                },
                function(data2,menu2)
                    menu2.close()
                    local reason = data2.value or ''
                    local alert = lib.alertDialog({
                        header = 'Pardakht',
                        content = ('Tavajoh konid ke vajh pardakhti be hich onvan ghabel bargasht nistid, aya motmaen hastid?'):format(bet),
                        centered = true,
                        cancel = true
                    })
                    if alert == 'confirm' then
                        ESX.TriggerServerEvent('sunsetpay:pay',type,amount,reason)
                    end
                end, function(data2,mene2)
                    menu2.close()
                end)
            else
                ESX.Alert('Error',(type == 1 and 'Mablagh' or 'Tedad') .. ' vared shoda na motabar ast!',7000,'error')
            end
        end, function(data1,menu1)
            menu1.close()
        end)
    end,function(data, menu)
        menu.close()
    end)
end)

RegisterCommand('fbipay',function()
    local elements = {
        {label = 'Poul(Bank)', value = 1},
    }
    ESX.UI.Menu.Open('question', GetCurrentResourceName(), 'ask_type',
    {
        title 	 = 'Pay type',
        align    = 'center',
        question = 'Noe pardakht ra entekhab konid?',
        elements = elements
    }, function(data, menu)
        menu.close()
        local type = data.current.value
        ESX.UI.Menu.Open('dialog',GetCurrentResourceName(),'get_amount',
        {
            title = (type == 1 and 'Mablagh' or 'Tedad') .. ' ra vared konid'
        },
        function(data1,menu1)
            local amount = data1.value
            menu1.close()
            if tonumber(amount) and amount > 0 then
                if type == 1 and amount < 10000 then
                    return ESX.Alert('Error',(type == 1 and 'Mablagh' or 'Tedad') .. ' vared shoda bayad bishtar az 10k bashad!',7000,'error')
                end
                ESX.UI.Menu.Open('dialog',GetCurrentResourceName(),'get_reason',
                {
                    title = 'Dalil pardakht ra vared konid'
                },
                function(data2,menu2)
                    menu2.close()
                    local reason = data2.value or ''
                    local alert = lib.alertDialog({
                        header = 'Pardakht',
                        content = ('Tavajoh konid ke vajh pardakhti be hich onvan ghabel bargasht nistid, aya motmaen hastid?'):format(bet),
                        centered = true,
                        cancel = true
                    })
                    if alert == 'confirm' then
                        ESX.TriggerServerEvent('sunsetpay:pay',type, amount, reason, true)
                    end
                end, function(data2,mene2)
                    menu2.close()
                end)
            else
                ESX.Alert('Error',(type == 1 and 'Mablagh' or 'Tedad') .. ' vared shoda na motabar ast!',7000,'error')
            end
        end, function(data1,menu1)
            menu1.close()
        end)
    end,function(data, menu)
        menu.close()
    end)
end)