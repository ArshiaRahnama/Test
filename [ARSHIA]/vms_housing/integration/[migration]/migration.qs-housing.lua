Migration = Migration or {}

local DefaultShell = 'standardmotel_shell' -- Default shell for properties without a specific shell type
local ShellsList = {
    [1] = 'standardmotel_shell',
    [2] = 'modernhotel_shell',
    [3] = 'shell_v16mid',           -- By default: 'furnitured_midapart'
    [4] = 'shell_garagem',
    [5] = 'shell_v16mid',           -- By default: 'shell_office1'
    [6] = 'shell_v16mid',           -- By default: 'shell_store1'
    [7] = 'shell_warehouse1',
    [8] = 'container_shell',
    [9] = 'shell_michael',
    [10] = 'shell_frankaunt',
    [11] = 'shell_v16mid',          -- By default: 'shell_ranch'
    [12] = 'shell_trailer',
    [13] = 'shell_v16mid',          -- By default: 'shell_lester'
    [14] = 'shell_v16mid',
    [15] = 'shell_trevor',
    [16] = 'shell_v16low',
}

local DefaultIPL = 'apa_v_mp_h_01_a'
local IPLSList = {
    ['apa_v_mp_h_07_a'] = 'apa_v_mp_h_01_a',
    ['ex_dt1_02_office_01a'] = 'ex_dt1_02_office_02b',
}

local MigrationCounter = 0

Migration['qs-housing'] = function()
    local HOUSES = MySQL.query.await('SELECT * FROM `houselocations`', {})

    for k, v in pairs(HOUSES) do
        local allowRegister = false
        local coords = json.decode(v.coords) or {}

        local _property = {
            type = 'shell',
            name = v.name,
            address = v.label,
            region = coords and coords.PolyZone and library.GetCurrentRegion(coords.PolyZone.points[1]) or 'None',
            description = v.description or '',
            keys = {},
            permissions = {},
            metadata = {
                zone = {
                    points = {},
                    minZ = coords.PolyZone.points[1].z - 5.0,
                    maxZ = coords.PolyZone.points[1].z + 30.0,
                    area = 0,
                },

                lightState = false,

                allowFurnitureOutside = true,
                allowFurnitureInside = true,

                locked = true,
                upgrades = {}
            },
            sale = {
                defaultActive = true,
                active = true,
                defaultPrice = 0,
                price = 99999999,
            },
            rental = {
                defaultActive = true,
                active = true,
                defaultPrice = 0,
                price = 99999999,
            },
            creator = 'Migrator',
        }


        local propertyType = 'shell'
        if v.ipl then
            local ipl = json.decode(v.ipl) or {}
            propertyType = 'ipl'
            _property.metadata.enter = { x = coords.enter.x, y = coords.enter.y, z = coords.enter.z + 1.0, w = coords.enter.h or 0 }
            _property.metadata.exit = { x = coords.enter.x, y = coords.enter.y, z = coords.enter.z, w = coords.enter.h or 0 }
            _property.metadata.ipl = ipl.theme and IPLSList[ipl.theme.ipl] or DefaultIPL

            allowRegister = true
        elseif not v.mlo then
            propertyType = 'shell'
            _property.metadata.enter = { x = coords.enter.x, y = coords.enter.y, z = coords.enter.z + 1.0, w = coords.enter.h or 0 }
            _property.metadata.exit = { x = coords.enter.x, y = coords.enter.y, z = coords.enter.z, w = coords.enter.h or 0 }
            _property.metadata.shell = ShellsList[v.tier] or DefaultShell

            allowRegister = true
        end
        _property.type = propertyType

        if allowRegister then
            for _, data in pairs(coords.PolyZone.points) do
                if data then
                    table.insert(_property.metadata.zone.points, { x = data.x,y = data.y })
                end
            end
    
            local id = MySQL.insert.await('INSERT INTO `houses` (`type`, `name`, `region`, `address`, `metadata`, `sale`, `rental`, `description`, `creator`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', {
                _property.type,
                _property.name,
                _property.region,
                _property.address,
                json.encode(_property.metadata),
                json.encode(_property.sale),
                json.encode(_property.rental),
                _property.description,
                _property.creator
            })
    
            MigrationCounter = MigrationCounter + 1
            Properties[id] = _property
        end
    end

    print('^2Successful migration ^7'.. MigrationCounter .. '/' .. #HOUSES ..' properties.')
    if #HOUSES - MigrationCounter >= 1 then
        print('^1Failed migration ^7'.. #HOUSES - MigrationCounter ..' for properties.')
    end
end