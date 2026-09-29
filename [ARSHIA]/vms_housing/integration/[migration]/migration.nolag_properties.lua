Migration = Migration or {}

local DefaultShell = 'standardmotel_shell' -- Default shell for properties without a specific shell type
local ShellsList = {
    -- K4MB1:
    ['Standard Motel']          = "standardmotel_shell",
    ['Modern Hotel']            = "modernhotel_shell",
    ['Apartment Furnished']     = "shell_v16mid", 
    ['Apartment Unfurnished']   = "shell_v16mid",
    ['Apartment 2 Unfurnished'] = "shell_v16low",
    ['Garage']                  = "shell_garagem",
    ['Container']               = "container_shell",
    ['2 Floor House']           = "shell_michael",
    ['House 1']                 = "shell_frankaunt",
    ['House 2']                 = "shell_v16mid",          -- By default: 'shell_ranch'
    ['House 3']                 = "shell_v16mid",          -- By default: 'shell_lester'
    ['House 4']                 = "shell_trevor",
    ['Trailer']                 = "shell_trailer",

    -- DC Customz:
    ['DC Apartment 1'] = "bk_apartmentone",
    ['DC Apartment 2'] = "bk_apartmenttwo",
    ['DC Apartment 3'] = "dc_apartmentthree",
    ['DC Apartment 4'] = "dc_apartmentfour",
    ['DC House 1'] = "bk_houseone",
    ['DC House 2'] = "dc_housetwoshell",
    ['DC House 3'] = "dc_housethree",
    ['DC House 4'] = "dc_housefour",
    ['DC House 5'] = "dc_housefive",
    ['DC House 6'] = "dc_housesix",
    ['DC House 7'] = "dc_houseseven",
    ['DC Townhouse One (Dirty)'] = "dc_townhouseone",
    ['DC Trap 1'] = "dc_trapshellone",
    ['DC Trap 2'] = "dc_trapshelltwo",
    ['DC Trap 3'] = "dc_trapshellthree",
    ['DC Hotel Shell'] = "dchotel_shell",

    -- Envi:
    ['envi_shell_01_empty'] = "envi_shell_01_empty",
    ['envi_shell_02_empty'] = "envi_shell_02_empty",
    ['envi_shell_03_empty'] = "envi_shell_03_empty",
}

local DefaultIPL = 'apa_v_mp_h_01_a'
local IPLSList = {
    ['ExecApartment1'] = 'apa_v_mp_h_01_a',
    ['FinanceOffice1'] = 'ex_dt1_02_office_02b',
}

local MigrationCounter = 0

Migration['nolag_properties'] = function()
    local HOUSES = MySQL.query.await('SELECT * FROM `properties`', {})

    for k, v in pairs(HOUSES) do
        local allowRegister = false
        local metadata = json.decode(v.metadata)

        if metadata then
            local _property = {
                type = v.type,
                name = v.label,
                address = v.address,
                region = library.GetCurrentRegion(metadata.yardZone.points[1]) or 'None',
                description = metadata.description or '',
                keys = {},
                permissions = {},
                metadata = {
                    zone = {
                        points = {},
                        minZ = 0.0,
                        maxZ = 300.0,
                        area = metadata.yardZone.area or 0,
                    },
                    enter = metadata.enterData,
                    exit = metadata.exitCoords,

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

            for _, data in pairs(metadata.yardZone.points) do
                if data then
                    table.insert(_property.metadata.zone.points, { x = data.x,y = data.y })
                end
            end

            if v.type == 'shell' and metadata.shellType then
                _property.metadata.shell = ShellsList[metadata.shellType] or DefaultShell
                
                allowRegister = true
                
            elseif v.type == 'ipl' then
                _property.metadata.ipl = IPLSList[metadata.iplName] or DefaultIPL

                allowRegister = true
            end

            if allowRegister then
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
    end

    print('^2Successful migration ^7'.. MigrationCounter .. '/' .. #HOUSES ..' properties.')
    if #HOUSES - MigrationCounter >= 1 then
        print('^1Failed migration ^7'.. #HOUSES - MigrationCounter ..' for properties.')
    end
end