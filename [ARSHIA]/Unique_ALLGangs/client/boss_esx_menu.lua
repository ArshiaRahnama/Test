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
                    {label = 'Manage Rank Access', value = 'rankaccess'},
                    {label = 'Gang Settings', value = 'settings'},
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
                    elseif data.current.value == 'rankaccess' then
                        menu.close()
                        OpenBossRankAccessMenu(gang)
                    elseif data.current.value == 'settings' then
                        menu.close()
                        OpenBossGangSettingsMenu(gang)
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
        ESX.TriggerServerCallback('FMGangsBoss:getblackmoney', function(blackmoney)
            local elements = {
                {label = ('Clean balance: <span style="color:green;">$%s</span>'):format(ESX.Math.GroupDigits(money or 0)), value = 'none'},
                {label = ('Dirty balance: <span style="color:salmon;">$%s</span>'):format(ESX.Math.GroupDigits(blackmoney or 0)), value = 'none2'},
                {label = 'Deposit Money', value = 'deposit'},
                {label = 'Withdraw Money', value = 'withdraw'},
                {label = 'Wash Money', value = 'wash'},
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
                elseif data.current.value == 'wash' then
                    menu.close()
                    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'boss_wash_amount_' .. gang, {
                        title = ('Amount to wash (%s%% cut)'):format(Config.WashMoneyCutPercent or 20)
                    }, function(data2, menu2)
                        local amount = tonumber(data2.value)
                        if not amount or amount <= 0 then
                            ESX.ShowNotification('Invalid amount')
                        else
                            menu2.close()
                            ESX.TriggerServerCallback('FMGangsBoss:washMoney', function(success, resultOrMsg)
                                if success then
                                    ESX.ShowNotification(('Washed into $%s clean'):format(ESX.Math.GroupDigits(resultOrMsg)))
                                else
                                    ESX.ShowNotification(resultOrMsg or 'Could not wash money')
                                end
                                OpenBossMoneyMenu(gang)
                            end, amount)
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
    end)
end

function OpenBossEmployeesMenu(gang)
    -- Wrapper menu (matches the pattern from the reference gang
    -- system you shared): "Employee List" + "Recruit", instead of
    -- jumping straight into the list.
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'manage_employees_' .. gang, {
        title    = 'MANAGE GANG MEMBERS',
        align    = 'top-left',
        elements = {
            {label = 'Employee List', value = 'list'},
            {label = 'Recruit',       value = 'recruit'},
        }
    }, function(data, menu)
        if data.current.value == 'list' then
            menu.close()
            OpenBossEmployeeListMenu(gang)
        elseif data.current.value == 'recruit' then
            menu.close()
            OpenBossRecruitMenu(gang)
        end
    end, function(data, menu)
        menu.close()
        OpenBossActionsMenu()
    end)
end

function OpenBossEmployeeListMenu(gang)
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
            OpenBossEmployeesMenu(gang)
        end)
    end)
end

-------------------------------------------------------------------
-- Recruit: lists online players not already in this gang (built
-- server-side, see server/boss.lua FMGangsBoss:GetRecruitablePlayers)
-- and confirms before hiring - much nicer than the old NUI panel's
-- plain "type in a server ID" text box, matching the picker-style
-- flow from the reference gang system you shared.
-------------------------------------------------------------------
function OpenBossRecruitMenu(gang)
    ESX.TriggerServerCallback('FMGangsBoss:GetRecruitablePlayers', function(players)
        local elements = {}
        for _, p in ipairs(players or {}) do
            table.insert(elements, { label = ('%s (ID: %s)'):format(p.name, p.source), value = tostring(p.source), name = p.name })
        end

        if #elements == 0 then
            ESX.ShowNotification('No recruitable players online')
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_recruit_' .. gang, {
            title    = 'RECRUIT',
            align    = 'top-left',
            elements = elements
        }, function(data, menu)
            local targetId   = tonumber(data.current.value)
            local targetName = data.current.name
            menu.close()
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_recruit_confirm_' .. gang, {
                title    = 'Recruit ' .. targetName .. '?',
                align    = 'top-left',
                elements = {
                    {label = 'Yes', value = 'yes'},
                    {label = 'No',  value = 'no'},
                }
            }, function(data2, menu2)
                menu2.close()
                if data2.current.value == 'yes' then
                    TriggerServerEvent('FMGangBoss:SetGang', targetId)
                end
                OpenBossRecruitMenu(gang)
            end, function(data2, menu2)
                menu2.close()
                OpenBossRecruitMenu(gang)
            end)
        end, function(data, menu)
            menu.close()
            OpenBossEmployeesMenu(gang)
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
            OpenBossEmployeeListMenu(gang)
        elseif data.current.value == 'promote' then
            menu.close()
            TriggerServerEvent('FMGangsBoss:server:GradeUpdate', { cid = member.Hex, grade = (member.grade_number or 1) + 1 })
            OpenBossEmployeeListMenu(gang)
        elseif data.current.value == 'demote' then
            menu.close()
            TriggerServerEvent('FMGangsBoss:server:GradeUpdate', { cid = member.Hex, grade = (member.grade_number or 1) - 1 })
            OpenBossEmployeeListMenu(gang)
        end
    end, function(data, menu)
        menu.close()
        OpenBossEmployeeListMenu(gang)
    end)
end

-------------------------------------------------------------------
-- Rank access management (requested: item/armory access, garage
-- access, etc. per rank) - wired to the same FMGangs:EditAccess
-- callback the old NUI panel's EDITACCESS button already used.
-------------------------------------------------------------------
function OpenBossRankAccessMenu(gang)
    ESX.TriggerServerCallback('FMGangs:GetGangDataFromName', function(gangData)
        if not gangData or not gangData.grades then
            ESX.ShowNotification('Could not load gang data')
            OpenBossActionsMenu()
            return
        end

        local elements = {}
        for gradeNum, gradeData in pairs(gangData.grades) do
            table.insert(elements, { label = gradeData.label .. ' (Grade ' .. gradeNum .. ')', value = tostring(gradeNum) })
        end
        table.sort(elements, function(a, b) return tonumber(a.value) < tonumber(b.value) end)

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_rank_access_' .. gang, {
            title    = 'SELECT RANK',
            align    = 'top-left',
            elements = elements
        }, function(data, menu)
            menu.close()
            OpenBossRankAccessToggleMenu(gang, tonumber(data.current.value))
        end, function(data, menu)
            menu.close()
            OpenBossActionsMenu()
        end)
    end, gang)
end

-- label/key pairs for every toggleable access flag on a grade
local RankAccessKeys = {
    { key = 'putitem',     label = 'Put Items (Armory)' },
    { key = 'takeitem',    label = 'Take Items (Armory)' },
    { key = 'garage',      label = 'Garage / Vehicle Access' },
    { key = 'setclothe',   label = 'Set Gang Clothes' },
    { key = 'heliANDBoat', label = 'Heli / Boat Access' },
    { key = 'crafting',    label = 'Crafting Access' },
    { key = 'bossaction',  label = 'Boss Actions' },
}

function OpenBossRankAccessToggleMenu(gang, gradeNumber)
    ESX.TriggerServerCallback('FMGangs:GetGangDataFromName', function(gangData)
        local gradeData = gangData and gangData.grades and gangData.grades[gradeNumber]
        if not gradeData then
            ESX.ShowNotification('Could not load that rank')
            OpenBossRankAccessMenu(gang)
            return
        end

        local access = gradeData.access or {}
        local elements = {}
        for _, a in ipairs(RankAccessKeys) do
            local state = access[a.key] and '<span style="color:lightgreen;">ON</span>' or '<span style="color:salmon;">OFF</span>'
            table.insert(elements, { label = a.label .. ': ' .. state, value = a.key })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_rank_access_toggle_' .. gang .. '_' .. gradeNumber, {
            title    = gradeData.label or ('Grade ' .. gradeNumber),
            align    = 'top-left',
            elements = elements
        }, function(data, menu)
            local key = data.current.value
            local newValue = not access[key]
            ESX.TriggerServerCallback('FMGangs:EditAccess', function()
                menu.close()
                OpenBossRankAccessToggleMenu(gang, gradeNumber)
            end, gang, gradeNumber, key, newValue)
        end, function(data, menu)
            menu.close()
            OpenBossRankAccessMenu(gang)
        end)
    end, gang)
end

-------------------------------------------------------------------
-- Gang settings (requested: set the gang's logo) - wired to the same
-- FMGangs:UpdateGang callback the old NUI panel's admin edit page
-- already used. UpdateGang requires label/expire(days)/logo/webhook
-- together, so this fetches the current values first and only
-- changes the logo.
-------------------------------------------------------------------
function OpenBossGangSettingsMenu(gang)
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_gang_settings_' .. gang, {
        title    = 'GANG SETTINGS',
        align    = 'top-left',
        elements = {
            { label = 'Set Gang Logo',    value = 'logo' },
            { label = 'Set Log Webhook',  value = 'webhook' },
            { label = 'Rename a Rank',    value = 'rename_rank' },
            { label = 'Set Rank Salary',  value = 'salary' },
        }
    }, function(data, menu)
        if data.current.value == 'logo' then
            menu.close()
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'boss_set_logo_' .. gang, {
                title = 'Paste the new logo image URL'
            }, function(data2, menu2)
                if not data2.value or data2.value == '' then
                    ESX.ShowNotification('Invalid URL')
                    return
                end
                menu2.close()
                ESX.TriggerServerCallback('FMGangs:GetGangDataFromName', function(gangData)
                    if not gangData then
                        ESX.ShowNotification('Could not load gang data')
                        OpenBossActionsMenu()
                        return
                    end
                    ESX.TriggerServerCallback('FMGangs:UpdateGang', function(success)
                        if success then
                            ESX.ShowNotification('Gang logo updated')
                        else
                            ESX.ShowNotification('Failed to update logo')
                        end
                        OpenBossActionsMenu()
                    end, gang, gangData.label, gangData.expire_day, data2.value, gangData.webhook)
                end, gang)
            end, function(data2, menu2)
                menu2.close()
                OpenBossGangSettingsMenu(gang)
            end)
        elseif data.current.value == 'webhook' then
            menu.close()
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'boss_set_webhook_' .. gang, {
                title = 'Paste the new Discord webhook URL'
            }, function(data2, menu2)
                if not data2.value or data2.value == '' then
                    ESX.ShowNotification('Invalid URL')
                    return
                end
                menu2.close()
                ESX.TriggerServerCallback('FMGangs:GetGangDataFromName', function(gangData)
                    if not gangData then
                        ESX.ShowNotification('Could not load gang data')
                        OpenBossActionsMenu()
                        return
                    end
                    ESX.TriggerServerCallback('FMGangs:UpdateGang', function(success)
                        if success then
                            ESX.ShowNotification('Webhook updated')
                        else
                            ESX.ShowNotification('Failed to update webhook')
                        end
                        OpenBossActionsMenu()
                    end, gang, gangData.label, gangData.expire_day, gangData.logo, data2.value)
                end, gang)
            end, function(data2, menu2)
                menu2.close()
                OpenBossGangSettingsMenu(gang)
            end)
        elseif data.current.value == 'rename_rank' then
            menu.close()
            OpenBossSelectRankMenu(gang, 'rename')
        elseif data.current.value == 'salary' then
            menu.close()
            OpenBossSelectRankMenu(gang, 'salary')
        end
    end, function(data, menu)
        menu.close()
        OpenBossActionsMenu()
    end)
end

-------------------------------------------------------------------
-- Rename Rank / Set Rank Salary - both reuse FMGangs:EditRank (the
-- same callback the old NUI panel's rank editor already used), which
-- updates label/name/salary together, so both flows fetch the
-- current values first and only change the one field being edited.
-------------------------------------------------------------------
function OpenBossSelectRankMenu(gang, mode)
    ESX.TriggerServerCallback('FMGangs:GetGangDataFromName', function(gangData)
        if not gangData or not gangData.grades then
            ESX.ShowNotification('Could not load gang data')
            OpenBossGangSettingsMenu(gang)
            return
        end

        local elements = {}
        for gradeNum, gradeData in pairs(gangData.grades) do
            table.insert(elements, { label = gradeData.label .. ' (Grade ' .. gradeNum .. ')', value = tostring(gradeNum) })
        end
        table.sort(elements, function(a, b) return tonumber(a.value) < tonumber(b.value) end)

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_select_rank_' .. mode .. '_' .. gang, {
            title    = 'SELECT RANK',
            align    = 'top-left',
            elements = elements
        }, function(data, menu)
            local gradeNumber = tonumber(data.current.value)
            menu.close()
            if mode == 'rename' then
                OpenBossRenameRankDialog(gang, gradeNumber)
            else
                OpenBossSalaryDialog(gang, gradeNumber)
            end
        end, function(data, menu)
            menu.close()
            OpenBossGangSettingsMenu(gang)
        end)
    end, gang)
end

function OpenBossRenameRankDialog(gang, gradeNumber)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'boss_rename_rank_' .. gang .. '_' .. gradeNumber, {
        title = 'New rank label'
    }, function(data, menu)
        if not data.value or data.value == '' then
            ESX.ShowNotification('Invalid label')
            return
        end
        menu.close()
        ESX.TriggerServerCallback('FMGangs:GetGangDataFromName', function(gangData)
            local gradeData = gangData and gangData.grades and gangData.grades[gradeNumber]
            if not gradeData then
                ESX.ShowNotification('Could not load that rank')
                OpenBossGangSettingsMenu(gang)
                return
            end
            ESX.TriggerServerCallback('FMGangs:EditRank', function()
                ESX.ShowNotification('Rank renamed')
                OpenBossGangSettingsMenu(gang)
            end, gang, gradeNumber, gradeData.name, data.value, gradeData.salary or 0)
        end, gang)
    end, function(data, menu)
        menu.close()
        OpenBossGangSettingsMenu(gang)
    end)
end

function OpenBossSalaryDialog(gang, gradeNumber)
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'boss_salary_' .. gang .. '_' .. gradeNumber, {
        title = 'New salary amount'
    }, function(data, menu)
        local amount = tonumber(data.value)
        if not amount or amount < 0 then
            ESX.ShowNotification('Invalid amount')
            return
        end
        menu.close()
        ESX.TriggerServerCallback('FMGangs:GetGangDataFromName', function(gangData)
            local gradeData = gangData and gangData.grades and gangData.grades[gradeNumber]
            if not gradeData then
                ESX.ShowNotification('Could not load that rank')
                OpenBossGangSettingsMenu(gang)
                return
            end
            ESX.TriggerServerCallback('FMGangs:EditRank', function()
                ESX.ShowNotification('Salary updated')
                OpenBossGangSettingsMenu(gang)
            end, gang, gradeNumber, gradeData.name, gradeData.label, amount)
        end, gang)
    end, function(data, menu)
        menu.close()
        OpenBossGangSettingsMenu(gang)
    end)
end
