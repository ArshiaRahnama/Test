Config = {}

Config.Options = {
    ['time'] = false,
    ['time_rent'] = 3600,
    ['delete_vehicle'] = false,
    ['delete_time'] = 60,

    ['time_finished'] = 'Your rental time is up, thank you.',
    ['spawnpoint_blocked'] = 'Another vehicle is taking the spawn place.',
    ['no_money'] = 'You dont have enought money to rent the vehicle.',
    ['return_success'] = 'Successfully returned the vehicle, thank you!',
    ['return_error'] = 'You need to be in the vehicle you rented.',
    ['cant_rent'] = 'You already rented a vehicle',
}

Config.Locations = {
    ['lossantosavenue'] = {
        coords = vector3(-296.583, -993.327, 31.081),
        spawn_coords = {x = -301.066, y = -988.584, z = 31.081, h= 336.02},
        return_coords = vector3(-297.731, -979.305, 31.081),
        markers = {
            spawn = {
                key = 38,
                type = 2,
                size  = {x = 0.3, y = 0.3, z = 0.3},
                color = {r = 255, g = 255, b = 255},
                text = '[ ~g~E~w~ ] Rent Vehicle',
                text = '[ ~g~E~w~ ] Rent Vehicle'
            },
            return_spot = {
                key = 47,
                type = 2,
                size  = {x = 0.3, y = 0.3, z = 0.3},
                color = {r = 255, g = 0, b = 0},
                text = '[ ~r~G~w~ ] Return Vehicle'
            }
        },
        blips = {
            spawn = {
                name = 'Rent Vehicle',
                sprite = 523,
                scale = 0.7,
                color = 2
            },
            return_spot = {
                name = 'Return rented Vehicle',
                sprite = 523,
                scale = 0.7,
                color = 4
            }

        }
    },

}

Config.Vehicles = {
    [1] = {
        model = 'neon',
        label = 'Neon',
        description = 'For 60min',
        image_name = 'neon',



        price = 7000,
        type = 'car'
    },
    [2] = {
        model = 'bf400',
        label = 'Bf400',
        description = 'For 60min',
        image_name = 'bf400',
        price = 5000,
        type = 'bike'
    },
    [3] = {
        model = 'bmx',
        label = 'BMX',
        description = 'For 60min',
        image_name = 'bmx',
        price = 5000,
        type = 'bicycle'
    },
}

