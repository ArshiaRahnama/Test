Migration = Migration or {}

local DefaultShell = 'standardmotel_shell' -- Default shell for properties without a specific shell type
local ShellsList = {
    ['Standard Motel'] = 'standardmotel_shell',
    ['Modern Hotel'] = 'modernhotel_shell',
    ['Apartment Furnished'] = 'shell_v16mid', -- By default: 'furnitured_midapart'
    ['Apartment Unfurnished'] = 'shell_v16mid',
    ['Apartment 2 Unfurnished'] = 'shell_v16low',
    ['Garage'] = 'shell_garagem',
    ['Office'] = 'shell_v16mid',           -- By default: 'shell_office1'
    ['Store'] = 'shell_v16mid',           -- By default: 'shell_store1'
    ['Warehouse'] = 'shell_warehouse1',
    ['Container'] = 'container_shell',
    ['2 Floor House'] = 'shell_michael',
    ['House 1'] = 'shell_frankaunt',
    ['House 2'] = 'shell_v16mid',          -- By default: 'shell_ranch'
    ['House 3'] = 'shell_v16mid',          -- By default: 'shell_lester'
    ['House 4'] = 'shell_trevor',
    ['Trailer'] = 'shell_trailer',
}

local MigrationCounter = 0

Migration['ps-housing'] = function()
    local HOUSES = MySQL.query.await('SELECT * FROM `properties`', {})

    for k, v in pairs(HOUSES) do
        local allowRegister = false
        local zone_data = json.decode(v.zone_data) or {}

        local _property = {
            type = 'shell',
            owner_name = '',
            owner = v.owner_citizenid,
            name = 'Property ' .. v.property_id,
            address = v.street,
            region = zone_data and zone_data.points and library.GetCurrentRegion(zone_data.points[1]) or 'None',
            description = v.description or '',
            keys = {},
            permissions = {},
            metadata = {
                zone = {
                    points = {},
                    minZ = zone_data.points[1].z - 5.0,
                    maxZ = zone_data.points[1].z + 30.0,
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
                active = v.for_sale == 0 and false or true,
                defaultPrice = v.price or 99999999,
                price = v.price or 99999999,
            },
            rental = {
                defaultActive = false,
                active = false,
                defaultPrice = 0,
                price = 99999999,
            },
            creator = 'Migrator',
        }


        local propertyType = 'shell'
        if v.shell ~= 'mlo' then
            local door_data = json.decode(v.door_data) or {}

            propertyType = 'shell'
            _property.metadata.enter = { x = door_data.x, y = door_data.y, z = door_data.z + 1.0, w = door_data.h or 0 }
            _property.metadata.exit = { x = door_data.x, y = door_data.y, z = door_data.z, w = door_data.h or 0 }
            _property.metadata.shell = ShellsList[v.shell] or DefaultShell

            allowRegister = true
        end
        _property.type = propertyType

        if allowRegister then
            for _, data in pairs(zone_data.points) do
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