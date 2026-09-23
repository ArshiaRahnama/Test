-- Unique_AdminPanel | client/menuv_ui.lua
-- The F4 admin menu, rebuilt on MenuV (same look as esx_adminmenu):
-- right-side panel, red accent, emoji icons, item descriptions.
--
-- It replaces the old WarMenu immediate-mode loops (client/menu_ui.lua and
-- client/admin_tools_menu.lua). Every action still calls exactly the same
-- server events / commands as before, so all server-side permission checks,
-- button-permission levels (AButton ids), logging and confirmations are
-- unchanged. Only the drawing layer changed.
--
-- Text prompts use ox_lib's input dialog (already a dependency: lib.alertDialog
-- / lib.inputDialog are used elsewhere in this resource), which is friendlier
-- than the GTA on-screen keyboard and lets one dialog ask several questions.

local POSITION = 'centerright'
local COLOR_R, COLOR_G, COLOR_B = 255, 0, 66
local SIZE = 'size-125'

local Menus, Builders, JustBuilt = {}, {}, {}

-- ------------------------------------------------------------------ core ---

local function CreateMenu(key, subtitle, builder)
    local menu = MenuV:CreateMenu(false, subtitle, POSITION, COLOR_R, COLOR_G, COLOR_B, SIZE, 'none', 'menuv', 'uap_' .. key)
    Menus[key] = menu
    Builders[key] = builder

    -- Rebuild every time the menu is shown again (Backspace back from a
    -- submenu, list refreshed, button permissions changed...). The first
    -- open is already built by Go(), so that one is skipped.
    menu:On('open', function()
        if JustBuilt[key] then
            JustBuilt[key] = nil
            return
        end
        menu:ClearItems()
        Builders[key](menu)
    end)
    return menu
end

local function Go(key)
    local menu = Menus[key]
    if not menu then return end
    menu:ClearItems()
    Builders[key](menu)
    JustBuilt[key] = true
    MenuV:OpenMenu(menu)
end

function CloseAdminMenu()
    MenuV:CloseAll()
end

function ToggleAdminMenu()
    if not aduty then return end
    if MenuV.CurrentMenu ~= nil then
        MenuV:CloseAll()
    else
        -- re-read the level / button permissions first, so the menu is always up to date
        RefreshPermissions(function() Go('main') end)
    end
end

-- Runs a menu action in its own thread (dialogs / callbacks yield).
local function Button(menu, icon, label, description, fn)
    return menu:AddButton({
        icon = icon,
        label = label,
        description = description or '',
        select = function() CreateThread(fn) end,
    })
end

local function SubMenu(menu, icon, label, description, key)
    return Button(menu, icon, label .. '  ›', description, function() Go(key) end)
end


-- Server-side hard level floors (see AdminMinLevel in server/main.lua). The
-- menu hides what the server would refuse anyway.
local function Lvl(n) return (MyPermissionLevel or 0) >= n end

local function LButton(n, ...) if Lvl(n) then return Button(...) end end
local function LSubMenu(n, ...) if Lvl(n) then return SubMenu(...) end end

local function Checkbox(menu, icon, label, description, value, onChange)
    local item = menu:AddCheckbox({ icon = icon, label = label, description = description or '', value = value and true or false })
    item:On('change', function(_, now)
        CreateThread(function() onChange(now) end)
    end)
    return item
end

local function Allowed(id)
    return ButtonAllowed == nil or ButtonAllowed(id)
end

local function Notify(msg) drawNotification(msg) end

local function Confirm(header, content)
    return lib.alertDialog({ header = header, content = content, centered = true, cancel = true }) == 'confirm'
end

-- Ask one or more questions in a single dialog. Returns the answers or nil.
local function Ask(title, rows)
    return lib.inputDialog(title, rows, { allowCancel = true })
end

-- Close the MenuV panel before handing over to an NUI panel / ox_lib context
-- (they take input focus, and leaving both on screen looks broken).
local function Leave(fn)
    return function()
        MenuV:CloseAll()
        Wait(50)
        fn()
    end
end

local function target() return SelectedTargetId end

local function RefreshPlayers(cb)
    ESX.TriggerServerCallback('Admin_Menu:GetActivePlayers', function(players)
        PlayersCache = players or {}
        cb(PlayersCache)
    end)
end

local function SortedPlayerIds()
    local ids = {}
    for id in pairs(PlayersCache or {}) do ids[#ids + 1] = id end
    table.sort(ids)
    return ids
end

-- ---------------------------------------------------------------- MAIN -----

local showID2 = false

CreateMenu('main', 'Admin Menu', function(m)
    SubMenu(m, '🧍', 'My Abilities', 'Noclip, god mode, invisibility, blips and more', 'abilities')
    SubMenu(m, '👫', 'Player Tools', 'Pick a player, then punish / heal / investigate', 'select_target')
    SubMenu(m, '👀', 'Spectate Menu', 'Spectate any online player', 'spectate')
    Button(m, '📍', 'Teleport to Spectated', 'Teleport to the player you are currently spectating', function()
        if TargetSpectate then
            local id = TargetSpectate
            MenuV:CloseAll()
            teleportToPlayer(id)
            spec[id] = false
            InSpectatorMode = false
            lastspec = 0
            TargetSpectate = nil
        else
            Notify("~r~Spectate a player first (Spectate Menu), then use this to teleport to them.")
        end
    end)
    SubMenu(m, '🚗', 'Vehicle Tools', 'Spawn, repair, delete and give vehicles', 'vehicle_tools')
    SubMenu(m, '🌍', 'World Tools', 'Weather, time, traffic and teleports', 'world_tools')
    SubMenu(m, '🎮', 'Server Tools', 'Announcements, reports, logs and bulk actions', 'server_tools')
    SubMenu(m, '🔧', 'Developer Tools', 'Coordinates, entity view and vehicle info', 'dev_tools')
    -- Ticket System (new) - just runs /atickets (client/ticket_client.lua),
    -- so the permission check stays in exactly one place, same as every
    -- other command this menu wraps.
    Button(m, '🎫', 'Tickets', 'Open the ticket system (players, assigned admins, linked reports)', function()
        MenuV:CloseAll()
        if OpenTicketPanel then OpenTicketPanel() end
    end)
end)

-- ------------------------------------------------------------ ABILITIES ----

CreateMenu('abilities', 'My Abilities', function(m)
    Checkbox(m, '🎥', 'Noclip', 'Fly through the map', noclip, function() RequestNoclip() end)
    Checkbox(m, '👻', 'Invisible', 'Become invisible to other players', invisibility, function() RequestInvisibility() end)
    Checkbox(m, '🫥', 'Invisible 2', 'Semi-transparent version (you still see yourself)', invisibility2, function() RequestInvisibility2() end)
    Checkbox(m, '⚡', 'God Mode', 'You cannot take damage', godmode, function() RequestGodmode() end)
    Checkbox(m, '📍', 'Player Blips', 'Show every player on the map', blipdool, function() RequestBlip() end)
    Checkbox(m, '📋', 'Show IDs (ESP)', 'Names and IDs above players', showID2, function(now)
        showID2 = now
        ExecuteCommand('esp')
    end)
    Checkbox(m, '🦘', 'Super Jump', 'Jump much higher', superjump, function() RequestSuperjump() end)
    Checkbox(m, '🏃', 'Fast Run', 'Run faster', fastrun, function() RequestFastrun() end)
    LSubMenu(5, m, '🎁', 'Spawn Weapon (me)', 'Give yourself a weapon from the list', 'weapons_self')
end)

-- ------------------------------------------------------------ SPECTATE -----

CreateMenu('spectate', 'Spectate Players', function(m)
    RefreshPlayers(function()
        for _, i in ipairs(SortedPlayerIds()) do
            local name = PlayersCache[i]
            Checkbox(m, '👁️', ('[%s] %s'):format(i, name), 'Toggle spectating this player', spec[i], function(now)
                spec[i] = now
                if now then
                    if lastspec ~= 0 then spec[lastspec] = false end
                    lastspec = i
                    if not spectate(lastspec) then
                        Notify("~r~Fard mored nazar online nist.")
                        spec[i] = false
                        lastspec = 0
                    end
                else
                    lastspec = 0
                    resetNormalCamera()
                end
            end)
        end
    end)
end)

-- ------------------------------------------------------ PLAYER SELECTION ---

CreateMenu('select_target', 'Select Target Player', function(m)
    RefreshPlayers(function()
        for _, i in ipairs(SortedPlayerIds()) do
            Button(m, '👤', ('[%s] %s'):format(i, PlayersCache[i]), 'Open tools for this player', function()
                SelectedTargetId = i
                Go('player_tools')
            end)
        end
    end)
end)

CreateMenu('player_tools', 'Player Tools', function(m)
    if not SelectedTargetId then return end
    m:AddButton({
        icon = '🎯',
        label = ('Target: [%s] %s'):format(SelectedTargetId, PlayersCache[SelectedTargetId] or '?'),
        description = 'The player every action below applies to',
        select = function() end,
    })
    SubMenu(m, '⚡', 'Quick Actions', 'Teleport, bring, freeze, heal, revive, kill', 'player_quick')
    SubMenu(m, '🔨', 'Punishments', 'Kick, ban, warn, jail, community service, impound', 'player_punish')
    SubMenu(m, '🎛️', 'Player Control', 'Health, armor, god mode, cuff, mute, weapons', 'player_control')
    SubMenu(m, '💰', 'Economy & Job', 'Set job, give / remove money', 'player_econ')
    SubMenu(m, '🔎', 'Investigate', 'Inspect, notes, screenshot, flags, logs', 'player_investigate')
end)

CreateMenu('player_quick', 'Quick Actions', function(m)
    Button(m, '🔼', 'Teleport to Target', 'Go to this player', function()
        local id = target()
        MenuV:CloseAll()
        teleportToPlayer(id)
    end)
    LButton(2, m, '🔽', 'Bring Target to Me', 'Teleport the player to you', function()
        TriggerServerEvent('Unique_AdminPanel:BringTarget', target())
    end)
    LButton(2, m, '❄️', 'Freeze / Unfreeze', 'Toggle movement lock', function()
        TriggerServerEvent('Unique_AdminPanel:FreezePlayer', target())
    end)
    Button(m, '💊', 'Heal', 'Restore health', function()
        TriggerServerEvent('Unique_AdminPanel:HealPlayer', target())
    end)
    Button(m, '💉', 'Revive', 'Revive the player', function()
        TriggerServerEvent('Unique_AdminPanel:RevivePlayer', target())
    end)
    LButton(2, m, '☠️', 'Kill', 'Kill the player', function()
        if Confirm('Kill Player', ('Kill [%s] %s?'):format(target(), PlayersCache[target()] or '?')) then
            TriggerServerEvent('Unique_AdminPanel:SlayTarget', target())
        end
    end)
    LButton(2, m, '🚗', "Sit in Target's Vehicle", 'Get into a free seat of their vehicle', function()
        TriggerServerEvent('Unique_AdminPanel:IntoVehicle', target())
    end)
    LButton(2, m, '🚀', 'Launch Into Air', 'Throw the player upward', function()
        TriggerServerEvent('Unique_AdminPanel:LaunchTarget', target())
    end)
    LButton(2, m, '🕓', 'Clear New Life', 'Remove the New Life (NLR) restriction from this player', function()
        TriggerServerEvent('Unique_AdminPanel:ClearNewLife', target())
    end)
    Button(m, '👕', 'Open Clothing Menu', 'Opens the /skin menu on this player', function()
        ExecuteCommand('skin ' .. target())
    end)
end)

CreateMenu('player_punish', 'Punishments', function(m)
    if Allowed('btn_kick') then
        Button(m, '👢', 'Kick', 'Remove the player from the server', function()
            local r = Ask('Kick', { { type = 'input', label = 'Reason', required = true } })
            if not r then return end
            local id, reason = target(), r[1]
            ShowPunishmentConfirm(id, 'Kick', function() ExecuteCommand('akick ' .. id .. ' ' .. reason) end)
        end)
    end
    if Allowed('btn_ban') then
        Button(m, '⛔', 'Ban (minutes)', 'Timed or permanent ban', function()
            local r = Ask('Ban', {
                { type = 'input', label = 'Minutes (or type perm)', default = '60', required = true },
                { type = 'input', label = 'Reason', required = true },
            })
            if not r then return end
            local id, dur, reason = target(), r[1], r[2]
            ShowPunishmentConfirm(id, 'Ban', function() ExecuteCommand('aban ' .. id .. ' ' .. dur .. ' ' .. reason) end)
        end)
    end
    if Allowed('btn_ban_preset') then
        SubMenu(m, '📜', 'Ban (Common Reason)', 'Preset reasons with fixed durations', 'ban_presets')
    end
    Button(m, '⚠️', 'Warn', 'Add a warning', function()
        local r = Ask('Warn', { { type = 'input', label = 'Reason', required = true } })
        if r then ExecuteCommand('awarn ' .. target() .. ' ' .. r[1]) end
    end)
    if Allowed('btn_jail') then
        Button(m, '⛓️', 'Send to Jail', 'Jail with a countdown', function()
            local r = Ask('Send to Jail', {
                { type = 'number', label = 'Minutes', default = 10, min = 1, required = true },
                { type = 'input', label = 'Reason', required = true },
            })
            if not r then return end
            local id, dur, reason = target(), tonumber(r[1]) or 10, r[2]
            if reason == '' then reason = 'No reason specified' end
            ShowPunishmentConfirm(id, 'Jail', function()
                TriggerServerEvent('Unique_AdminPanel:RequestJail', id, dur, reason)
            end)
        end)
    end
    Button(m, '🔓', 'Release from Jail', 'End the jail sentence', function()
        TriggerServerEvent('arshia_jail:UnjailPlayer', target())
    end)
    if Allowed('btn_cs') then
        Button(m, '🧹', 'Send to Community Service', 'Assign community service actions', function()
            local r = Ask('Community Service', {
                { type = 'number', label = 'Actions count', default = 10, min = 1, required = true },
                { type = 'input', label = 'Reason', required = true },
            })
            if not r then return end
            local reason = r[2]
            if reason == '' then reason = 'No reason specified' end
            TriggerServerEvent('Unique_AdminPanel:RequestCS', target(), tonumber(r[1]) or 10, reason)
        end)
    end
    if Allowed('btn_impound') then
        Button(m, '🚧', 'Impound Vehicle', "Impound the player's current vehicle", function()
            local r = Ask('Impound Vehicle', { { type = 'input', label = 'Reason', required = true } })
            if not r then return end
            TriggerServerEvent('Unique_AdminPanel:ImpoundTarget', target(), r[1] ~= '' and r[1] or 'No reason specified')
        end)
    end
    if Allowed('btn_impound_yard') then
        Button(m, '🏭', 'Impound Yard (Search / Release)', 'Search and release impounded vehicles', Leave(OpenImpoundYard))
    end
end)

CreateMenu('ban_presets', 'Ban - Common Reason', function(m)
    ESX.TriggerServerCallback('Unique_AdminPanel:GetBanPresets', function(presets)
        if not presets then return end
        for _, p in ipairs(presets) do
            Button(m, '🔨', p.label, p.minutes == 0 and 'Permanent' or (p.minutes .. ' minutes'), function()
                local id = target()
                local durArg = p.minutes == 0 and 'perm' or tostring(p.minutes)
                ShowPunishmentConfirm(id, 'Ban - ' .. p.label, function()
                    ExecuteCommand('aban ' .. id .. ' ' .. durArg .. ' ' .. p.reason)
                end)
            end)
        end
    end)
end)

CreateMenu('player_control', 'Player Control', function(m)
    LButton(2, m, '❤️', 'Set Health %', 'Set the target health (0-100)', function()
        local r = Ask('Set Health', { { type = 'number', label = 'Health percent', default = 100, min = 0, max = 100, required = true } })
        if r then TriggerServerEvent('Unique_AdminPanel:SetHealth', target(), tonumber(r[1])) end
    end)
    LButton(2, m, '🛡️', 'Set Armor %', 'Set the target armor (0-100)', function()
        local r = Ask('Set Armor', { { type = 'number', label = 'Armor percent', default = 100, min = 0, max = 100, required = true } })
        if r then TriggerServerEvent('Unique_AdminPanel:SetArmor', target(), tonumber(r[1])) end
    end)
    if Allowed('btn_godmode') then
        Button(m, '⚡', 'Toggle God Mode (Target)', 'Make the target invincible / vulnerable', function()
            TriggerServerEvent('Unique_AdminPanel:ToggleTargetGodmode', target())
        end)
    end
    LButton(2, m, '🔗', 'Cuff / Uncuff', 'Toggle handcuffs', function()
        TriggerServerEvent('Unique_AdminPanel:ToggleCuff', target())
    end)
    LButton(2, m, '🔇', 'Mute Voice/Chat', '', function() TriggerServerEvent('Unique_AdminPanel:MuteTarget', target(), true) end)
    LButton(2, m, '🔊', 'Unmute Voice/Chat', '', function() TriggerServerEvent('Unique_AdminPanel:MuteTarget', target(), false) end)
    LSubMenu(5, m, '🎁', 'Give Weapon', 'Pick a weapon from the list', 'weapons_target')
    LButton(5, m, '➖', 'Remove Weapon', 'Remove a weapon by name', function()
        local r = Ask('Remove Weapon', { { type = 'input', label = 'Weapon name (without WEAPON_)', default = 'PISTOL', required = true } })
        if r then TriggerServerEvent('Unique_AdminPanel:RemoveWeaponTarget', target(), r[1]) end
    end)
    if Allowed('btn_clearinv') then
        Button(m, '🎒', 'Clear Inventory', 'Remove all items', function()
            if Confirm('Clear Inventory', 'Remove all items from this player?') then
                TriggerServerEvent('Unique_AdminPanel:ClearInventoryTarget', target())
            end
        end)
    end
    LButton(5, m, '🔫', 'Clear Loadout (Weapons)', 'Remove all weapons', function()
        if Confirm('Clear Loadout', 'Remove all weapons from this player?') then
            TriggerServerEvent('Unique_AdminPanel:ClearLoadoutTarget', target())
        end
    end)
end)

CreateMenu('player_econ', 'Economy & Job', function(m)
    LButton(8, m, '💼', 'Set Job/Grade', 'Change the player job', function()
        local r = Ask('Set Job', {
            { type = 'input', label = 'Job name (e.g. police)', required = true },
            { type = 'number', label = 'Grade', default = 0, min = 0, required = true },
        })
        if r then ExecuteCommand('asetjob ' .. target() .. ' ' .. r[1] .. ' ' .. tostring(r[2])) end
    end)
    local function moneyDialog(title, command)
        local r = Ask(title, {
            { type = 'select', label = 'Account', default = 'money', options = { { value = 'money', label = 'Cash' }, { value = 'bank', label = 'Bank' } } },
            { type = 'number', label = 'Amount', default = 1000, min = 1, required = true },
            { type = 'input', label = 'Reason', required = true },
        })
        if r then ExecuteCommand(('%s %s %s %s %s'):format(command, target(), r[1], math.floor(tonumber(r[2]) or 0), r[3])) end
    end
    if Allowed('btn_givemoney') then
        Button(m, '💵', 'Give Money', 'Add money to the player', function() moneyDialog('Give Money', 'agivemoney') end)
    end
    if Allowed('btn_setmoney') then
        Button(m, '💸', 'Remove Money', 'Take money from the player', function() moneyDialog('Remove Money', 'aremovemoney') end)
    end
end)

CreateMenu('player_investigate', 'Investigate', function(m)
    Button(m, '🗂️', 'Case File (Timeline)', 'Every note, warning, ban, jail, report and admin action on one timeline', function()
        OpenCaseFile(target())
    end)
    LButton(2, m, '💹', 'Money Ledger', 'Every cash/bank change and which resource caused it', function()
        OpenLedger(target(), 24)
    end)
    Button(m, '🪪', 'Inspect', 'Full profile: vehicles, warnings, money', function()
        local id = target()
        ESX.TriggerServerCallback('Unique_AdminPanel:InspectPlayer', function(data)
            if not data then Notify("~r~Could not inspect that player") return end
            MenuV:CloseAll()
            SendNUIMessage({ type = 'inspect', data = ResolveInspectVehicleLabels(data) })
            SetNuiFocus(true, true)
            InAdminNui = true
        end, id)
    end)
    Button(m, '📝', 'Add Note', 'Save a note on this player', function()
        local r = Ask('Add Note', { { type = 'textarea', label = 'Note', required = true, max = 200 } })
        if r and r[1] ~= '' then
            TriggerServerEvent('Unique_AdminPanel:AddNote', target(), r[1])
            Notify("~b~Note saved")
        end
    end)
    Button(m, '📸', 'Screenshot Player', 'Capture their screen', function()
        TriggerServerEvent('Unique_AdminPanel:ScreenshotTarget', target())
        Notify("~b~Requesting screenshot...")
    end)
    Button(m, '💬', 'Whisper Message', 'Private message to this player', function()
        local r = Ask('Whisper', { { type = 'input', label = 'Message', required = true, max = 150 } })
        if r then TriggerServerEvent('Unique_AdminPanel:WhisperTarget', target(), r[1]) end
    end)
    Button(m, '🚩', 'Flag Player', 'Remind all on-duty admins while they are online', function()
        local r = Ask('Flag Player', { { type = 'input', label = 'Flag reason', required = true, max = 200 } })
        if r then TriggerServerEvent('Unique_AdminPanel:SetFlag', target(), r[1]) end
    end)
    Button(m, '🏳️', 'Unflag Player', '', function()
        TriggerServerEvent('Unique_AdminPanel:ClearFlag', target())
    end)
    Button(m, '🎙️', 'Who Was In Voice Range?', 'Players near them recently', function()
        local r = Ask('Voice Range', { { type = 'number', label = 'Range (meters)', default = 20, min = 1, required = true } })
        if not r then return end
        ESX.TriggerServerCallback('Unique_AdminPanel:GetVoiceProximity', function(nearby)
            if #nearby == 0 then
                Notify("~y~No one else was tracked nearby (or no recent position data yet).")
                return
            end
            local lines = {}
            for _, p in ipairs(nearby) do
                lines[#lines + 1] = ("[%s] %s - %sm (%ss ago)"):format(p.id, p.name, p.distance, p.ageSeconds)
            end
            MenuV:CloseAll()
            SendNUIMessage({ type = 'proximity', data = { title = 'Voice Proximity Check', lines = lines } })
            SetNuiFocus(true, true)
            InAdminNui = true
        end, target(), tonumber(r[1]) or 20)
    end)
    Button(m, '🗂️', 'Chat Archive (Search)', 'Search their chat history', function()
        local r = Ask('Chat Archive', { { type = 'input', label = 'Search text (empty = recent 200)' } })
        if not r then return end
        ESX.TriggerServerCallback('Unique_AdminPanel:GetPlayerChatArchive', function(rows)
            local lines = {}
            for _, row in ipairs(rows) do lines[#lines + 1] = ("[%s] %s"):format(row.created_at, row.message) end
            MenuV:CloseAll()
            SendNUIMessage({ type = 'proximity', data = { title = 'Chat Archive', lines = lines } })
            SetNuiFocus(true, true)
            InAdminNui = true
        end, target(), r[1] or '')
    end)
end)

-- ---------------------------------------------------------- WEAPON LISTS ---

local weaponReceiver = nil -- server id that gets the weapon (target or self)

local function BuildWeaponCategories(m, nextKey)
    for _, cat in ipairs(WeaponCatalog or {}) do
        Button(m, '🔫', cat.category .. '  ›', #cat.items .. ' weapons', function()
            WeaponCategory = cat
            Go(nextKey)
        end)
    end
end

local function BuildWeaponList(m)
    local cat = WeaponCategory
    if not cat then return end
    for _, w in ipairs(cat.items) do
        if w[1]:find('^weapon_') then
            Button(m, '🎁', w[2], w[1], function()
                local r = Ask(w[2], { { type = 'number', label = 'Ammo', default = 250, min = 0, max = 9999, required = true } })
                if not r then return end
                TriggerServerEvent('Unique_AdminPanel:GiveWeaponTarget', weaponReceiver, w[1], tonumber(r[1]) or 250)
            end)
        end
    end
end

CreateMenu('weapons_target', 'Give Weapon', function(m)
    weaponReceiver = target()
    BuildWeaponCategories(m, 'weapon_list')
end)
CreateMenu('weapons_self', 'Spawn Weapon (me)', function(m)
    weaponReceiver = GetPlayerServerId(PlayerId())
    BuildWeaponCategories(m, 'weapon_list')
end)
CreateMenu('weapon_list', 'Weapons', BuildWeaponList)

-- ---------------------------------------------------------- VEHICLE TOOLS --

CreateMenu('vehicle_tools', 'Vehicle Tools', function(m)
    SubMenu(m, '🚙', 'Spawn & Give', 'Spawn vehicles, repair, give to a player', 'vehicle_spawn')
    SubMenu(m, '🛠️', 'Nearby Vehicle Actions', 'Lock, upgrade, delete nearby vehicles', 'vehicle_nearby')
    Button(m, '🪑', 'Get In Nearest Vehicle', '', function() GetIntoNearestVehicle() end)
    Button(m, '🎨', 'Set Current Vehicle Livery', '', function()
        local r = Ask('Livery', { { type = 'number', label = 'Livery number', default = 0, min = 0, required = true } })
        if r then SetCurrentVehicleLivery(tonumber(r[1]) or 0) end
    end)
end)

CreateMenu('vehicle_spawn', 'Spawn & Give', function(m)
    if Allowed('btn_spawnveh') then
        Button(m, '🚗', 'Spawn Vehicle', 'Type a model name', function()
            local r = Ask('Spawn Vehicle', {
                { type = 'input', label = 'Vehicle model name', default = 'adder', required = true },
                { type = 'input', label = 'Plate (optional)' },
            })
            if r and r[1] ~= '' then TriggerServerEvent('Unique_AdminPanel:SpawnVehicle', r[1], r[2] or '') end
        end)
        SubMenu(m, '🗃️', 'Spawn by Category', 'Browse vehicles by class (Sports, SUVs, Boats ...)', 'veh_categories')
    end
    Button(m, '🔧', 'Fix/Repair current vehicle', '', function() TriggerServerEvent('Unique_AdminPanel:VehicleAction', 'fix') end)
    Button(m, '🧽', 'Clean current vehicle', '', function() TriggerServerEvent('Unique_AdminPanel:VehicleAction', 'clean') end)
    LButton(20, m, '🎁', 'Give Vehicle to Target' .. (SelectedTargetId and (' [' .. SelectedTargetId .. ']') or ' (pick a target first)'),
        'Adds a vehicle to the target player', function()
            if not SelectedTargetId then Notify("~r~Pick a target in Player Tools first") return end
            local r = Ask('Give Vehicle', { { type = 'input', label = 'Vehicle model name', default = 'adder', required = true } })
            if r and r[1] ~= '' then TriggerServerEvent('Unique_AdminPanel:GiveVehicle', SelectedTargetId, r[1]) end
        end)
end)

local VehicleClassNames = {
    [0] = 'Compacts', 'Sedans', 'SUVs', 'Coupes', 'Muscle', 'Sports Classics', 'Sports', 'Super', 'Motorcycles',
    'Off-road', 'Industrial', 'Utility', 'Vans', 'Cycles', 'Boats', 'Helicopters', 'Planes', 'Service',
    'Emergency', 'Military', 'Commercial', 'Trains', 'Open Wheel',
}

local vehiclesByClass, vehicleClassLoaded = {}, false

local function LoadVehiclesByClass(cb)
    if vehicleClassLoaded then cb() return end
    ESX.TriggerServerCallback('Unique_AdminPanel:GetVehicleNames', function(names)
        vehiclesByClass = {}
        for model, label in pairs(names or {}) do
            local hash = GetHashKey(model)
            if IsModelInCdimage(hash) and IsModelAVehicle(hash) then
                local class = GetVehicleClassFromName(hash)
                vehiclesByClass[class] = vehiclesByClass[class] or {}
                table.insert(vehiclesByClass[class], { model = model, label = (label:gsub('%s+$', '')) })
            end
        end
        for _, list in pairs(vehiclesByClass) do
            table.sort(list, function(a, b) return a.label:lower() < b.label:lower() end)
        end
        vehicleClassLoaded = true
        cb()
    end)
end

CreateMenu('veh_categories', 'Vehicle Categories', function(m)
    LoadVehiclesByClass(function()
        for class = 0, 22 do
            local list = vehiclesByClass[class]
            if list and #list > 0 then
                Button(m, '🚘', VehicleClassNames[class] .. '  ›', #list .. ' vehicles', function()
                    VehicleClassChoice = class
                    Go('veh_models')
                end)
            end
        end
    end)
end)

CreateMenu('veh_models', 'Vehicle Models', function(m)
    local list = vehiclesByClass[VehicleClassChoice or -1]
    if not list then return end
    for _, v in ipairs(list) do
        Button(m, '🚗', v.label, v.model, function()
            TriggerServerEvent('Unique_AdminPanel:SpawnVehicle', v.model, '')
        end)
    end
end)

CreateMenu('vehicle_nearby', 'Nearby Vehicle Actions', function(m)
    Button(m, '📋', 'Nearby Vehicle List', '', Leave(OpenVehicleList))
    Button(m, '🔒', 'Lock/Unlock nearest vehicle', '', function() TriggerServerEvent('Unique_AdminPanel:VehicleAction', 'lock') end)
    Button(m, '⬆️', 'Max upgrade nearest vehicle', '', function() TriggerServerEvent('Unique_AdminPanel:VehicleAction', 'maxupgrade') end)
    Button(m, '🗑️', 'Delete nearest empty vehicle', '', function() TriggerServerEvent('Unique_AdminPanel:VehicleAction', 'deletenearest') end)
    Button(m, '💥', 'Delete Vehicles In Range', 'Deletes every vehicle around you', function()
        local r = Ask('Delete Vehicles In Range', { { type = 'number', label = 'Range (meters)', default = 50, min = 1, max = 500, required = true } })
        if r then DeleteVehiclesInRange(tonumber(r[1]) or 50) end
    end)
end)

-- ------------------------------------------------------------ WORLD TOOLS --

local WeatherPresets = { 'EXTRASUNNY', 'CLEAR', 'CLOUDS', 'OVERCAST', 'RAIN', 'THUNDER', 'SMOG', 'FOGGY', 'XMAS', 'SNOWLIGHT', 'BLIZZARD' }

CreateMenu('world_tools', 'World Tools', function(m)
    SubMenu(m, '🌦️', 'Weather, Time & Traffic', '', 'world_weather')
    SubMenu(m, '🧭', 'Teleport & Locations', '', 'world_teleport')
end)

CreateMenu('world_weather', 'Weather, Time & Traffic', function(m)
    if Allowed('btn_weather') then
        Button(m, '🌡️', 'Set Weather', 'Changes the weather for everyone', function()
            local options = {}
            for _, w in ipairs(WeatherPresets) do options[#options + 1] = { value = w, label = w } end
            local r = Ask('Set Weather', { { type = 'select', label = 'Weather', options = options, default = 'CLEAR', required = true } })
            if r then TriggerServerEvent('Unique_AdminPanel:SetWeather', tostring(r[1]):upper()) end
        end)
    end
    if Allowed('btn_time') then
        Button(m, '🕒', 'Set Time', 'Changes the time for everyone', function()
            local r = Ask('Set Time', {
                { type = 'number', label = 'Hour (0-23)', default = 12, min = 0, max = 23, required = true },
                { type = 'number', label = 'Minute (0-59)', default = 0, min = 0, max = 59, required = true },
            })
            if r then TriggerServerEvent('Unique_AdminPanel:SetTime', math.floor(r[1]), math.floor(r[2])) end
        end)
    end
    Button(m, '⏸️', 'Freeze/Resume Server Time', '', function() TriggerServerEvent('Unique_AdminPanel:ToggleFreezeTime') end)
    Button(m, '🚦', 'Traffic Density', '', function()
        local r = Ask('Traffic Density', { { type = 'select', label = 'Level', default = 'normal', options = {
            { value = 'off', label = 'Off' }, { value = 'low', label = 'Low' }, { value = 'normal', label = 'Normal' }, { value = 'high', label = 'High' } } } })
        if r then TriggerServerEvent('Unique_AdminPanel:SetTrafficDensity', tostring(r[1]):lower()) end
    end)
end)

CreateMenu('world_teleport', 'Teleport & Locations', function(m)
    Button(m, '📌', 'Teleport to Waypoint', 'Teleport to your map marker', function()
        local waypoint = GetFirstBlipInfoId(8)
        if DoesBlipExist(waypoint) then
            local coords = GetBlipInfoIdCoord(waypoint)
            local groundZ = getGroundZ(coords.x, coords.y, 1000.0)
            TriggerServerEvent('Unique_AdminPanel:TeleportCoords', coords.x, coords.y, groundZ > 0 and groundZ or coords.z)
        else
            Notify("~r~No waypoint set on the map")
        end
    end)
    Button(m, '🎯', 'Teleport to Coords', '', function()
        local r = Ask('Teleport to Coords', {
            { type = 'number', label = 'X', required = true }, { type = 'number', label = 'Y', required = true }, { type = 'number', label = 'Z', required = true } })
        if r then TriggerServerEvent('Unique_AdminPanel:TeleportCoords', r[1], r[2], r[3]) end
    end)
    Button(m, '💾', 'Save current location', '', function()
        local r = Ask('Save Location', { { type = 'input', label = 'Location name', required = true } })
        if r and r[1] ~= '' then
            local c = GetEntityCoords(PlayerPedId())
            TriggerServerEvent('Unique_AdminPanel:SaveLocation', r[1], c.x, c.y, c.z)
            SavedLocationsCache = {}
        end
    end)
    SubMenu(m, '🗺️', 'Saved Locations', '', 'saved_locations')
end)

CreateMenu('saved_locations', 'Saved Locations', function(m)
    ESX.TriggerServerCallback('Unique_AdminPanel:GetSavedLocations', function(rows)
        SavedLocationsCache = rows or {}
        for _, loc in ipairs(SavedLocationsCache) do
            Button(m, '📍', loc.name, 'Teleport here', function()
                TriggerServerEvent('Unique_AdminPanel:TeleportCoords', loc.x, loc.y, loc.z)
            end)
        end
        if #SavedLocationsCache == 0 then
            m:AddButton({ icon = 'ℹ️', label = 'No saved locations yet', description = 'Use "Save current location"', select = function() end })
        end
    end)
end)

-- ----------------------------------------------------------- SERVER TOOLS --

CreateMenu('server_tools', 'Server Tools', function(m)
    LButton(2, m, '🔎', 'Global Search', 'Name, identifier, phone, IBAN, plate  (hotkey F6, Ctrl+K in panels)', function() OpenGlobalSearch() end)
    SubMenu(m, '📢', 'Communication', 'Announcements and admin chat', 'server_comms')
    SubMenu(m, '📊', 'Reports & Logs', 'Reports, dashboards, history and audits', 'server_reports')
    if Allowed('btn_bulk') then
        SubMenu(m, '👥', 'Bulk Actions (All Players)', 'Affects everyone online', 'server_bulk')
    end
    if Allowed('btn_restart') then
        Button(m, '⚠️', 'Restart Resource', 'Requires ACE: command.arestart', function()
            local r = Ask('Restart Resource', { { type = 'input', label = 'Resource name', required = true } })
            if r and r[1] ~= '' then ExecuteCommand('arestart ' .. r[1]) end
        end)
    end
end)

CreateMenu('report_macros', 'Report Macros', function(m)
    Button(m, '➕', 'Add macro', 'Variables: {admin} {player} {id} {server}', function()
        local r = Ask('Add Report Macro', {
            { type = 'input', label = 'Button label', required = true, max = 60 },
            { type = 'textarea', label = 'Reply text', required = true, max = 500 },
            { type = 'checkbox', label = 'Also close the report after sending' },
        })
        if r then TriggerServerEvent('Unique_AdminPanel:AddMacro', r[1], r[2], r[3] and true or false) end
    end)
    ESX.TriggerServerCallback('Unique_AdminPanel:ListMacros', function(list)
        for _, mc in ipairs(list or {}) do
            local closes = (mc.close == 1 or mc.close == true)
            Button(m, closes and '✅' or '💬', mc.label, (closes and '[closes report] ' or '') .. mc.text, function()
                if Confirm('Delete macro', ('Delete "%s"?'):format(mc.label)) then
                    TriggerServerEvent('Unique_AdminPanel:DeleteMacro', mc.key)
                    Wait(400)
                    Go('report_macros')
                end
            end)
        end
    end)
end)

CreateMenu('server_bulk', 'Bulk Actions (All Players)', function(m)
    Button(m, '❄️', 'Freeze / Unfreeze ALL Players', '', function()
        if Confirm('Freeze/Unfreeze All', 'This toggles freeze for every player on the server. Continue?') then
            TriggerServerEvent('Unique_AdminPanel:BulkAction', 'freezeall')
        end
    end)
    Button(m, '💊', 'Heal ALL Players', '', function() TriggerServerEvent('Unique_AdminPanel:BulkAction', 'healall') end)
    Button(m, '💉', 'Revive ALL Players', '', function() TriggerServerEvent('Unique_AdminPanel:BulkAction', 'reviveall') end)
    Button(m, '👢', 'Kick ALL Players', 'Disconnects everyone', function()
        local r = Ask('Kick Everyone', { { type = 'input', label = 'Reason', default = 'Server maintenance', required = true } })
        if r and Confirm('Kick Everyone', 'This disconnects every player currently online. Continue?') then
            TriggerServerEvent('Unique_AdminPanel:BulkAction', 'kickall', r[1])
        end
    end)
    Button(m, '🧻', 'Clear Chat For Everyone', '', function() TriggerServerEvent('Unique_AdminPanel:BulkAction', 'clearall') end)
end)

CreateMenu('server_comms', 'Communication', function(m)
    Button(m, '📣', 'Announce to server', '', function()
        local r = Ask('Announcement', { { type = 'input', label = 'Announcement text', required = true, max = 120 } })
        if r and r[1] ~= '' then
            TriggerServerEvent('_chat:messageEntered', 'AdminAnnounce', {}, r[1])
            ExecuteCommand('aannounce ' .. r[1])
        end
    end)
    LButton(4, m, '🔔', 'Broadcast with Sound', '', function()
        local r = Ask('Broadcast', { { type = 'input', label = 'Announcement text', required = true, max = 120 } })
        if r and r[1] ~= '' then TriggerServerEvent('Unique_AdminPanel:AnnounceWithSound', r[1]) end
    end)
    Button(m, '💬', 'Admin Chat', 'Only visible to on-duty admins', function()
        local r = Ask('Admin Chat', { { type = 'input', label = 'Message', required = true, max = 150 } })
        if r and r[1] ~= '' then TriggerServerEvent('Unique_AdminPanel:AdminChat', r[1]) end
    end)
end)

CreateMenu('server_reports', 'Reports & Logs', function(m)
    Button(m, '📨', 'Report Queue', '', Leave(OpenReportsMenu))
    Button(m, '📎', 'Report Evidence', 'Chat, nearby players and screenshot saved when a report was accepted', function()
        local r = Ask('Report Evidence', { { type = 'number', label = 'Report ID', min = 1, required = true } })
        if r then OpenEvidence(math.floor(r[1])) end
    end)
    LButton(2, m, '📊', 'Top Money Gainers', 'Who gained the most money recently (find exploits)', function()
        local r = Ask('Top Money Gainers', { { type = 'select', label = 'Period', default = '24', options = {
            { value = '1', label = 'Last hour' }, { value = '6', label = 'Last 6 hours' }, { value = '24', label = 'Last 24 hours' }, { value = '168', label = 'Last 7 days' } } } })
        if r then OpenLedgerTop(tonumber(r[1]) or 24) end
    end)
    if Lvl(5) then SubMenu(m, '💬', 'Report Macros', 'Add / delete canned replies', 'report_macros') end
    Button(m, '🗒️', 'Chat Log', '', function()
        ESX.TriggerServerCallback('Unique_AdminPanel:GetChatLog', function(log)
            MenuV:CloseAll()
            SendNUIMessage({ type = 'chatlog', data = log })
            SetNuiFocus(true, true)
            InAdminNui = true
        end)
    end)
    Button(m, '⏱️', 'Online Players & Playtime', '', Leave(OpenOnlinePlayersPanel))
    Button(m, '🆕', 'New Players', '', Leave(OpenNewPlayersPanel))
    Button(m, '📈', 'Dashboard', '', Leave(OpenDashboardPanel))
    Button(m, '💹', 'Economy Health Chart', '', Leave(OpenEconomyChart))
    if MyPermissionLevel >= 5 then
        Button(m, '⚙️', 'Button Permissions', 'Choose which rank sees which button', Leave(OpenButtonPermsPanel))
    end
    if Allowed('btn_unban') then Button(m, '📖', 'Ban History Search', '', Leave(OpenBanSearch)) end
    if Allowed('btn_dutyhist') then Button(m, '🕰️', 'Duty History Search', '', Leave(OpenDutyHistory)) end
    if Allowed('btn_appeals') then Button(m, '📬', 'Review Ban Appeals', '', Leave(OpenBanAppeals)) end
    if Allowed('btn_transfer') then Button(m, '⚠️', 'Character Transfer (Support)', '', Leave(OpenCharacterTransfer)) end
    if Allowed('btn_faction') then Button(m, '🏦', 'Faction Treasury Audit', '', Leave(OpenFactionAudit)) end
end)

-- ------------------------------------------------------ DEVELOPER TOOLS ----

local devState = { coords = false, vehinfo = false }

CreateMenu('dev_tools', 'Developer Tools', function(m)
    Button(m, '📋', 'Copy vector2', 'Your position as vector2', function() DevTools.CopyCoords('vec2') end)
    Button(m, '📋', 'Copy vector3', 'Your position as vector3', function() DevTools.CopyCoords('vec3') end)
    Button(m, '📋', 'Copy vector4', 'Position + heading as vector4', function() DevTools.CopyCoords('vec4') end)
    Button(m, '🧭', 'Copy Heading', '', function() DevTools.CopyCoords('heading') end)
    Checkbox(m, '📍', 'Show Coordinates', 'Draw your coordinates on screen', devState.coords, function()
        devState.coords = DevTools.ToggleCoords()
    end)
    Checkbox(m, '🚘', 'Vehicle Info', 'Model, plate and health of your current vehicle', devState.vehinfo, function()
        devState.vehinfo = DevTools.ToggleVehicleInfo()
    end)
    SubMenu(m, '🔍', 'Entity View', 'Inspect peds, vehicles and objects', 'entity_view')
end)

CreateMenu('entity_view', 'Entity View Options', function(m)
    local EV = DevTools.EntityView
    local distItem = m:AddSlider({
        icon = '📏',
        label = 'View distance',
        description = 'How far the overlay scans (meters)',
        value = 1,
        values = (function()
            local v = {}
            for d = 5, 50, 5 do v[#v + 1] = { label = tostring(d), value = d, description = 'meters' } end
            return v
        end)(),
    })
    distItem:On('select', function(_, value) DevTools.SetEntityViewDistance(value) Notify(('~b~Entity view distance: %sm'):format(value)) end)

    Button(m, '📋', 'Copy Free-aim Entity Info', 'Copies model, hash, coords and rotation of the aimed entity', function()
        DevTools.CopyAimedEntityInfo()
    end)
    Checkbox(m, '🔫', 'Free-aim Entity', 'Aim at anything: info box, [E] delete, [G] freeze, [H] copy coords', EV.freeAim, function(now)
        DevTools.SetEntityView('freeAim', now)
    end)
    Checkbox(m, '🚗', 'Vehicles', 'Boxes around nearby vehicles', EV.vehicles, function(now) DevTools.SetEntityView('vehicles', now) end)
    Checkbox(m, '🧍', 'Peds', 'Boxes around nearby peds', EV.peds, function(now) DevTools.SetEntityView('peds', now) end)
    Checkbox(m, '📦', 'Objects', 'Boxes around nearby objects', EV.objects, function(now) DevTools.SetEntityView('objects', now) end)
end)

-- Leaving duty (or the menu state getting reset) shuts the overlays off too.
RegisterNetEvent('esx_aduty:ChangeMenuStatus')
AddEventHandler('esx_aduty:ChangeMenuStatus', function(status)
    if not status then
        devState.coords, devState.vehinfo = false, false
        DevTools.StopAll()
    end
end)
