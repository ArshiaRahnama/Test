-------------------------------------------------------------------
-- Boss actions, styled like the old Unique_Gangs system: ESX's own
-- default menu (ESX.UI.Menu.Open('default', ...), top-left aligned)
-- instead of the custom NUI panel in client/boss.lua / html/.
--
-- This is what the boss NPC / ox_target interaction opens now (see
-- client/load.lua, where the marker's callback was changed from
-- OpenBossMenu() - the NUI panel opener - to OpenBossActionsMenu()
-- below). The NUI panel's code is untouched and still in the
-- resource if you ever want to switch back - just change that one
-- callback in load.lua.
--
-- Wired to the SAME server events/callbacks the NUI panel already
-- used (server/boss.lua, server/Gangs.lua) - no server-side data
-- model changes, just a different front end.
-------------------------------------------------------------------

-- Every other client file here independently obtains its own ESX
-- reference (there's no shared global one provided by the
-- framework/bridge) - this file needs the same, since it wasn't
-- getting one at all before and every ESX.* call below would have
-- failed with "attempt to index a nil value (global 'ESX')".
local ESX = nil
CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.ESX, function(obj) ESX = obj end)
        Wait(200)
    end
end)

function OpenBossActionsMenu()
    -- FIX (attempt to index a nil value 'gang'): ESX.PlayerData.gang
    -- isn't populated by this server's es_extended_bridge (only
    -- essentialmode natively guarantees that shape). This resource
    -- already tracks gang info itself in a global `PlayerData` (set
    -- in client/boss.lua, kept in sync via the setGang event) - use
    -- that instead, matching how every other file here already does.
    if not PlayerData or not PlayerData.gang then
        ESX.ShowNotification('Still loading your data, try again in a moment')
        return
    end
    local gang = PlayerData.gang.name
    if not gang or gang == 'nogang' then
        ESX.ShowNotification('You are not in a gang')
        return
    end

    ESX.TriggerServerCallback('FMGangs:isBoss', function(isBoss, logo)
        ESX.TriggerServerCallback('FMGangs:GetRankAccess', function(access)
            if not isBoss and not (access and access['bossaction']) then
                ESX.ShowNotification('Insufficient authorization')
                return
            end

            ESX.TriggerServerCallback('FMGangsBoss:getmoney', function(money)
                local elements = {
                    {label = ('Money: <span style="color:green;">$%s</span>'):format(ESX.Math.GroupDigits(money or 0)), value = 'money'},
                    {label = 'Manage Gang Members', value = 'employees'},
                }

                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_actions_' .. gang, {
                    title    = 'BOSS MENU',
                    align    = 'top-left',
                    elements = elements
                }, function(data, menu)
                    if data.current.value == 'money' then
                        menu.close()
                        OpenBossMoneyMenu(gang)
                    elseif data.current.value == 'employees' then
                        menu.close()
                        OpenBossEmployeesMenu(gang)
                    end
                end, function(data, menu)
                    menu.close()
                end)
            end)
        end)
    end)
end

function OpenBossMoneyMenu(gang)
    ESX.TriggerServerCallback('FMGangsBoss:getmoney', function(money)
        local elements = {
            {label = ('Current balance: <span style="color:green;">$%s</span>'):format(ESX.Math.GroupDigits(money or 0)), value = 'none'},
            {label = 'Deposit Money', value = 'deposit'},
            {label = 'Withdraw Money', value = 'withdraw'},
        }

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_money_' .. gang, {
            title    = 'MONEY MANAGEMENT',
            align    = 'top-left',
            elements = elements
        }, function(data, menu)
            if data.current.value == 'deposit' then
                menu.close()
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'boss_deposit_amount_' .. gang, {
                    title = 'Deposit amount'
                }, function(data2, menu2)
                    local amount = tonumber(data2.value)
                    if not amount or amount <= 0 then
                        ESX.ShowNotification('Invalid amount')
                    else
                        menu2.close()
                        TriggerServerEvent('FMGangsBoss:server:depositMoney', amount)
                        OpenBossMoneyMenu(gang)
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            elseif data.current.value == 'withdraw' then
                menu.close()
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'boss_withdraw_amount_' .. gang, {
                    title = 'Withdraw amount'
                }, function(data2, menu2)
                    local amount = tonumber(data2.value)
                    if not amount or amount <= 0 then
                        ESX.ShowNotification('Invalid amount')
                    else
                        menu2.close()
                        TriggerServerEvent('FMGangsBoss:server:withdrawMoney', amount)
                        OpenBossMoneyMenu(gang)
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            end
        end, function(data, menu)
            menu.close()
            OpenBossActionsMenu()
        end)
    end)
end

function OpenBossEmployeesMenu(gang)
    -- FIX (member list always empty - showed just the search bar with
    -- nothing below it): FMGangs:GetGangsData's real callback
    -- signature is cb(Gangs, Expires, AllMembers, MyGangMembers) -
    -- only 4 values, not the 6 this used to assume. That mismatch
    -- meant `allMembers` here was always nil (there is no 6th value),
    -- so myMembers always fell through to `{}` - an empty list every
    -- time, regardless of how many members the gang actually had.
    -- MyGangMembers (the real 4th value) is already exactly this
    -- gang's member list, pre-filtered server-side - no need to index
    -- by gang name at all.
    ESX.TriggerServerCallback('FMGangs:GetGangsData', function(Gangs, Expires, AllMembers, MyGangMembers)
        local myMembers = MyGangMembers or {}
        local elements = {
            head = {'Name', 'Grade', 'Status'},
            rows = {}
        }

        for _, m in pairs(myMembers.online or {}) do
            table.insert(elements.rows, {data = m, cols = {m.Name, m.Grade, 'Online'}})
        end
        for _, m in pairs(myMembers.offline or {}) do
            table.insert(elements.rows, {data = m, cols = {m.Name, m.Grade, 'Offline'}})
        end

        if #elements.rows == 0 then
            ESX.ShowNotification('No gang members found')
        end

        ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'boss_employees_' .. gang, elements, function(data, menu)
            local member = data.data
            menu.close()
            OpenBossEmployeeActionsMenu(gang, member)
        end, function(data, menu)
            menu.close()
            OpenBossActionsMenu()
        end)
    end)
end

function OpenBossEmployeeActionsMenu(gang, member)
    local myGrade = PlayerData.gang.grade
    local elements = {}

    if (member.grade_number or 0) < myGrade then
        table.insert(elements, {label = 'Promote', value = 'promote'})
        if (member.grade_number or 0) > 1 then
            table.insert(elements, {label = 'Demote', value = 'demote'})
        end
        table.insert(elements, {label = 'Fire', value = 'fire'})
    else
        table.insert(elements, {label = '(no actions - equal or higher grade)', value = 'none'})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_employee_actions_' .. gang, {
        title    = member.Name,
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'fire' then
            menu.close()
            TriggerServerEvent('FMGangsBoss:server:FireEmployee', { cid = member.Hex })
            ESX.ShowNotification('Employee fired')
            OpenBossEmployeesMenu(gang)
        elseif data.current.value == 'promote' then
            menu.close()
            TriggerServerEvent('FMGangsBoss:server:GradeUpdate', { cid = member.Hex, grade = (member.grade_number or 1) + 1 })
            OpenBossEmployeesMenu(gang)
        elseif data.current.value == 'demote' then
            menu.close()
            TriggerServerEvent('FMGangsBoss:server:GradeUpdate', { cid = member.Hex, grade = (member.grade_number or 1) - 1 })
            OpenBossEmployeesMenu(gang)
        end
    end, function(data, menu)
        menu.close()
        OpenBossEmployeesMenu(gang)
    end)
end
