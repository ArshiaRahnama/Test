Config = {}

Config.Options = {
    -- Turned on by default now: rentals are tracked with a countdown timer,
    -- which is what actually makes the duration tiers below mean anything.
    ['time'] = true,
    ['delete_vehicle'] = false,
    ['delete_time'] = 60,

    ['time_finished'] = 'Your rental time is up, thank you.',
    ['spawnpoint_blocked'] = 'Another vehicle is taking the spawn place.',
    ['no_money'] = 'You dont have enought money to rent the vehicle.',
    ['return_success'] = 'Successfully returned the vehicle, thank you!',
    ['return_error'] = 'You need to be in the vehicle you rented.',
    ['cant_rent'] = 'You already rented a vehicle',
}

-- Rental duration tiers, picked in the UI at rent time. `multiplier` is
-- applied to each vehicle's base `price` in Config.Vehicles below (that
-- base price represents the 1.0x / standard tier, i.e. the "1 Hour" one).
-- This must stay a plain sequential array ([1], [2], [3], ...) since the
-- order here is the order the tiers are shown in the UI.
Config.Durations = {
    [1] = { seconds = 1800, label = '30 Minutes', multiplier = 0.65 },
    [2] = { seconds = 3600, label = '1 Hour',      multiplier = 1.0  },
    [3] = { seconds = 7200, label = '2 Hours',     multiplier = 1.8  },
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

-- `price` below is the BASE price, for the 1 Hour / 1.0x duration tier.
-- The actual charge is base price × the chosen duration's multiplier
-- (see Config.Durations above), recomputed server-side.
Config.Vehicles = {
    [1] = {
        model = 'neon',
        label = 'Neon',
        description = 'Sleek city cruiser',
        image_name = 'neon',
        price = 7000,
        type = 'car'
    },
    [2] = {
        model = 'bf400',
        label = 'Bf400',
        description = 'Off-road dirt bike',
        image_name = 'bf400',
        price = 5000,
        type = 'bike'
    },
    [3] = {
        model = 'bmx',
        label = 'BMX',
        description = 'Eco-friendly pedal power',
        image_name = 'bmx',
        price = 5000,
        type = 'bicycle'
    },
}
