-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local function openQuestionMenu()
    local input = lib.inputDialog('CHAT GPT', {
        {
            label = 'Soal',
            type = 'textarea',
            required = true,
            max = 4,
        }
    })
    if input[1] then
        CreateThread(function()
            lib.progressCircle({
                duration = 30000,
                position = 'middle',
                useWhileDead = false,
                canCancel = false,
                allowRagdoll = true,
                allowFalling = true,
                disable = {
                    car = true,
                    move = true,
                    combat = true,
                },
            })
        end)
        ESX.TriggerServerCallback('gpt:execPrompt', function(answer)
            if lib.progressActive() then
                lib.cancelProgress()
            end
            local alert = lib.alertDialog({
                header = 'Javab :',
                content = answer,
                centered = true,
            })
        end, input[1])
    end
end

CreateThread(function()
    waitForLoad()
    -- for k, v in pairs(buddhaConfig.coords) do
    --     createLocalPed(4, buddhaConfig.model, v - vec(0, 0, 1, 0), function(ped)
    --         SetEntityAsMissionEntity(ped)
    --         SetBlockingOfNonTemporaryEvents(ped, true)
    --         FreezeEntityPosition(ped, true)
    --         SetEntityInvincible(ped, true)
    --         ESX.Streaming.RequestAnimDict('rcmepsilonism3')
    --         TaskPlayAnim(ped, 'rcmepsilonism3', 'ep_3_rcm_marnie_meditating', 8.0, 8.0, -1, 1, 0.0)
    --         exports['sunset_target']:addTargetEntity({ped},{
    --             options = {{
    --                 icon = '',
    --                 label = '❓',
    --                 cb = function()
    --                     openQuestionMenu()
    --                 end,
    --             }},
    --             job = {'all'},
    --             distance = 2.5
    --         })
    --     end, function(ped)
    --         exports['sunset_target']:removeTargetEntity(ped)
    --     end)
    -- end
end)