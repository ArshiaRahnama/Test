configYaghi = {}
configYaghi.props = {
    prop_sign_route_13 = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_06p = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_06i = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_03g = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_06g = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_interstate_01 = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_05z = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_05w = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_callbox = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_05k = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_06j = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_05d = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_05p = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_05c = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_01a = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_05l = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_06f = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_05u = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_05t = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_06h = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_06k = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
    prop_sign_road_03h = {
        animTime = 90,
        reward = {
            iron_piece = {10,30},
            gold_piece = {1,5}
        }
    },
}
configYaghi.entityTimeout = 45 * 60 * 1000
configYaghi.entityWeight = 100
configYaghi.meltingPos = vector3(1517.87,-2132.37,76.61)
configYaghi.deleteBlowtorchAfter = 5
configYaghi.alarmJob = {
    police = true,
    sheriff = true,
    fbi = true,
    mt = true,
    detective = true,
}

-- No matching 'sun-inventory-hud' vehicle-weight export exists on this
-- server, so vehicle capacity is now driven by vehicle class instead.
-- Key = GetVehicleClass() result, Value = max carrying capacity (same
-- units as configYaghi.entityWeight). Classes not listed can't be used.
-- 10 = Industrial, 11 = Utility, 12 = Van, 20 = Commercial
configYaghi.vehicleCapacityByClass = {
    [10] = 300,
    [11] = 300,
    [12] = 300,
    [20] = 500,
}

-- Optional list of zones where stealing/melting is blocked (replaces the
-- missing 'gangs':isInGreenZone() export). Empty by default.
-- Example: {coords = vector3(0,0,0), radius = 50.0}
configYaghi.noStealZones = {}

-- How close (in GTA units) a previous theft has to be for a sign to be
-- considered "on cooldown" server-side (paired with entityTimeout above).
configYaghi.stealCooldownRadius = 3.0