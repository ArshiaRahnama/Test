-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

local Ipls = {
   -- bike = {name = "bike", fuc = exports.bob74_ipl:GetBikerClubhouse2Object()},
   -- executive3 = {name = "executive3", fuc = exports.bob74_ipl:GetExecApartment3Object() },
   -- executive2 = {name = "executive2", fuc = exports.bob74_ipl:GetExecApartment2Object() },
   -- executive1 = {name = "executive1", fuc = exports.bob74_ipl:GetExecApartment1Object() }
}

ConfigTeleporter = {
------------------------------------------------ # police --------------------------------------------------------------------
    { -- Police Fast Teleporter
        positions = {
            { coords = vec(470.64, -984.93, 30.69, 91.31),    label = "[1] Mission Row"    },
            { coords = vec(625.12, -18.98, 82.78, 337.18),    label = "[2] Vinewood"       },
            { coords = vec(-48.23, -2512.5, 7.39, 234.2),     label = "[3] Shipping Yard"  },
            { coords = vec(-1085.9, -849.71, 4.88, 218.86),   label = "[4] Vespucci"       },
            { coords = vec(-564.47, -210.41, 42.7, 304.82),   label = "[5] justice"        },
            { coords = vec(1844.05, 3682.55, 34.33, 116.5),   label = "[1] Sandy Shores"   },
            { coords = vec(-435.31, 6008.83, 31.72, 127.59),  label = "[2] Paleto Bay"     },
            { coords = vec(-2360.91, 3249.16, 32.81, 333.0),  label = "[0] Army"           },
        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false, key = { ["police"] = 0, ["sheriff"] = 0, ["detective"] = 0, ["mt"] = 0, ["fbi"] = 5 }
    },
    { -- Police to robbery
        positions = {
            { coords = vec(317.91, 196.5, 104.47, 166.56),    label = "[1]  Central Bank"    },
            { coords = vec(-1094.63, -324.08, 38.09, 87.0),   label = "[2]  LifeInvader"     },
            { coords = vec(-1317.29, -816.6, 17.12, 221.6),   label = "[3]  Maze Bank"       },
            { coords = vec(-666.66, -171.89, 37.92, 34.12),   label = "[4]  Center Jewelry"  },
            { coords = vec(2704.94, 3455.36, 55.79, 60.08),   label = "[5]  Shams Jewelry"   },
            { coords = vec(-1033.5, -2745.1, 14.14, 235.29),  label = "[6]  AirPort"         },
            { coords = vec(843.3, -1992.79, 29.57, 266.6),    label = "[7]  Flat Jewelry"    },
            { coords = vec(-92.06, 6472.54, 31.58, 227.42),   label = "[8]  Paleto Bank"     },
            { coords = vec(-484.83, 6022.99, 31.58, 222.21),  label = "[9]  Cargo"           },
            { coords = vec(797.01, -2134.51, 29.63, 272.92),  label = "[10] Gun Shop"        },
            { coords = vec(-181.58, -1278.06, 31.34, 359.82), label = "[11] Benny"           },
            -- { coords = vec(1853.39, 3690.46, 34.33, 295.31),  label = "[10] Mythic"       },
            { coords = vec(-2351.71, 3252.14, 32.81, 331.63), label = "[0]  Army"            },
            { coords = vec(1132.66, -1550.23, 35.38, 356.79), label = "[0]  Medic station"   },
        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false, key = { ["police"] = 0, ["sheriff"] = 0, ["mt"] = 0, ["ambulance"] = 0  }
    },
    { -- Police Station 5 Asansor 1
        positions = {
            { coords = vec(-1096.15, -850.15, 38.24, 307.98), label = "[6] Ceiling"                },
            { coords = vec(-1096.33, -850.09, 34.36, 220.06), label = "[5] DB-Captain Office"      },
            { coords = vec(-1095.78, -850.78, 30.76, 219.22), label = "[4] OPS Center-Lt's Office" },
            { coords = vec(-1095.77, -850.76, 26.83, 308.95), label = "[3] Gym-Briefing Room"      },
            { coords = vec(-1095.93, -850.2, 23.04, 62.8),    label = "[2] Cafeteria"              },
            { coords = vec(-1096.06, -850.37, 19.0, 39.67),   label = "[1] Main Hall"              },
            { coords = vec(-1095.87, -850.64, 4.88, 35.21),   label = "[-1] Jail"                  },
            { coords = vec(-1095.75, -850.87, 10.28, 39.32),  label = "[-2] Lab-Evidence Room"     },
            { coords = vec(-1095.95, -850.48, 13.69, 36.53),  label = "[-3] Garage-Armory"         },
        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false, key = { ["police"] = 0, ["sheriff"] = 0, ["detective"] = 0, ["mt"] = 0, ["fbi"] = 5 }
    },
    { -- Police Station 5 Asansor 2
        positions = {
            { coords = vec(-1065.97, -833.77, 27.04, 313.32),  label = "[3] Gym-Briefing Room"  },
            { coords = vec(-1065.59, -834.07, 19.04, 312.44),  label = "[1] Main Hall"          },
            { coords = vec(-1065.98, -833.52, 5.48, 310.44),   label = "[-1] Jail"              },
            { coords = vec(-1065.7, -833.6, 11.04, 45.36),     label = "[-2] Lab-Evidence Room" },
            { coords = vec(-1065.58, -834.08, 14.88, 312.0),   label = "[-3] Garage-Armory"     },
        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false, key = { ["police"] = 0, ["sheriff"] = 0, ["detective"] = 0, ["mt"] = 0, ["fbi"] = 5 }
    },
    { -- Pd 2 Helli
        positions = {
            { coords = vec(641.34, 12.17, 82.79, 162.61), label = "Down" },
            { coords = vec(565.95, 4.88, 103.23, 268.69), label = "Up"   },
        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false, key = { ["police"] = 0, ["sheriff"] = 0, ["detective"] = 0, ["mt"] = 0, ["fbi"] = 5 }
    },
    { -- Pd 5 to meeting
        positions = {
            { coords = vec(-1042.47, -828.28, 10.88, 135.18), label = "[5] Vespucci" },
            { coords = vec(2154.62, 2920.91, -61.9, 86.27),   label = "Meeting"      },
        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false, key = { ["police"] = 0, ["sheriff"] = 0, ["detective"] = 0, ["mt"] = 0, ["fbi"] = 5 }
    },

------------------------------------------------ # FBI ------------------------------------------------------------------------
    { -- FBI Public Asansor
        positions = {
            { coords = vec(136.16, -761.89, 242.15, 162.37), label = "[1] FBI Office"  },
            { coords = vec(136.15, -761.69, 45.75, 162.26),  label = "[0] Main"        },
        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false
    },
    { -- FBI Public Asansor new
        positions = {
            { coords = vec(2504.26, -433.44, 106.91, 317.45), label = "[1] FBI Office" },
            { coords = vec(2504.26, -433.38, 99.11, 309.56),  label = "[0] Main"       },
        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false
    },
    { -- FBI Private Asansor
        positions = {
            { coords = vec(141.11, -735.78, 262.84, 161.42), label = "[3] Helli"       },
            { coords = vec(115.23, -741.36, 258.15, 334.9),  label = "[2] FBI Office2" },
            { coords = vec(138.98, -762.76, 45.75, 159.74),  label = "[0] Main"        },
        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false, key = { ["police"] = 0, ["sheriff"] = 0, ["detective"] = 0, ["mt"] = 0, ["fbi"] = 0 }
    },
    { -- FBI Private Asansor new
    positions = {
            { coords = vec(2512.18, -336.02, 115.59, 130.58), label = "[3] Helli"    },
            { coords = vec(2504.56, -341.95, 105.69, 129.6),  label = "[2] Jail"     },
            { coords = vec(2504.66, -341.91, 101.89, 136.51), label = "[1] 3 Floor"  },
            { coords = vec(2504.5, -342.09, 94.09, 137.6),    label = "[0] Main"     },
        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false, key = { ["police"] = 0, ["sheriff"] = 0, ["detective"] = 0, ["mt"] = 0, ["fbi"] = 0 }
    },
    { -- Army Asansor
    positions = {
            { coords = vec(-2361.13, 3248.69, 92.9, 325.24),   label = "[1] Up"    },
            { coords = vec(-2435.49, 3289.02, 34.89, 149.75),  label = "[2] Down"  }
        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false, key = { ["fbi"] = 5 }
    },
    { -- FBI Private Statins for fbi > 10
        positions = {
            { coords = vec(127.14, -729.11, 242.15, 68.33),     label = "FBI Statins 1"   },
            { coords = vec(2494.76, -347.19, 94.09, 316.05),    label = "FBI Statins 2"   },
            { coords = vec(-574.35, -213.9, 38.22, 295.61),     label = "FBI justic"      },
            { coords = vec(1127.21, -1570.45, 35.38, 283.16),   label = "FBI Medic 1"     },
            { coords = vec(-1825.24, -347.07, 49.25, 147.6),    label = "FBI Medic 2"     },
            { coords = vec(579.2, 601.67, 129.05, 298.04),      label = "FBI Mechanic 1"  },
            { coords = vec(463.24, -995.58, 30.03, 265.99),     label = "FBI PD 1"        },
            { coords = vec(627.06, -10.61, 82.78, 257.54),      label = "FBI PD 2"        },
            { coords = vec(-53.44, -2507.44, 7.39, 151.68),     label = "FBI PD 3"        },
            { coords = vec(-1062.76, -822.23, 27.03, 92.22),    label = "FBI PD 5"        },
            { coords = vec(368.01, -1586.63, 29.29, 223.67),    label = "FBI Taxi 1"      },
            { coords = vec(-818.46, -1353.17, 8.57, 279.93),    label = "FBI Taxi 2"      },
            { coords = vec(-565.29, -928.64, 33.34, 184.21),    label = "FBI Weazel"      },
            { coords = vec(1779.34, 3652.62, 35.64, 120.2),     label = "Administatior"   },
            { coords = vec(-2351.6, 3252.36, 92.9, 328.47),     label = "Army"            },
            { coords = vec(-579.42, -1059.36, 26.61, 262.34),   label = "Resturan"        },
        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false, key = { ["fbi"] = 10 }
    },

------------------------------------------------ # justic ---------------------------------------------------------------------
    { -- justice Statins
        positions = {
            { coords = vec(-555.96, -200.22, 42.7, 200.9),     label = "justic"          },
            { coords = vec(224.58, -426.74, 48.1, 246.85),     label = "justic 2"        },
            { coords = vec(1739.17, 3634.74, 35.64, 299.1),    label = "Administatior"   },

        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false, key = { ["fbi"] = 7, ["justice"] = 0 }
    },
    { -- justice asansor
    positions = {
            { coords = vec(-520.45, -189.47, 46.17, 209.19),   label = "[1] Up"    },
            { coords = vec(-516.99, -210.86, 38.17, 117.52),   label = "[2] Down"  },
        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false, key = { ["fbi"] = 0, ["justice"] = 0 }
    },
    { -- justice 2 asansor
    positions = {
            { coords = vec(244.86, -415.29, 60.27, 345.26),    label = "[1] Up"    },
            { coords = vec(234.4, -430.18, 48.1, 67.85),       label = "[2] Down"  },
        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false, key = { ["fbi"] = 0, ["justice"] = 0 }
    },

------------------------------------------------ # Ambulance (Medic) ----------------------------------------------------------
    { -- ambulance Fast Teleporter
        positions = {
            { coords = vec(1132.74, -1546.64, 35.38, 6.72),   label = "Station 1"        },
            { coords = vec(-1828.42,-358.77,49.25,51.16),     label = "Station 2"        },
            { coords = vec(-258.42, 6315.61, 32.43, 131.55),  label = "Station 4 Palato" },
            { coords = vec(1735.99, 3640.48, 35.64, 303.33),  label = "Administatior"    },
            { coords = vec(1775.53, 2552.04, 45.57, 87.12),   label = "Prison"           },
            { coords = vec(-1267.56, -2282.77, 14.14, 151.8), label = "Air Port"         },
            { coords = vec(-545.46, 5280.58, 74.3, 160.36),   label = "Shekar"           },
        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false,key = { ["ambulance"] = 0, ["fbi"] = 5 }
    },
------------------------------------------------ # Taxi -----------------------------------------------------------------------
    { -- Taxi Fast Teleporter
        positions = {
            { coords = vec(356.09, -1612.19, 29.29, 141.41),    label = "Station Main"     }, -- TX 1
            { coords = vec(-786.45, -1355.47, 5.15, 230.55),    label = "Taxi Area"        }, -- TX 2
            { coords = vec(-378.59, 6061.15, 31.46, 221.58),    label = "Palato"           },
            { coords = vec(-289.28, -1080.58, 23.03, 245.73),   label = "Job Center"       },
            { coords = vec(-425.09, 1224.22, 325.76, 349.19),   label = "Admin Area"       },
            { coords = vec(-297.17, 303.4, 90.72, 0.02),        label = "Vinewood"         }, -- balaye bank markazi
            { coords = vec(-2066.28, -312.77, 13.29, 356.92),   label = "Pacific"          }, -- nazdike md2
            { coords = vec(-1125.93, 2694.7, 18.8, 46.3),       label = "Zancudo"          }, -- gun shop 8
            { coords = vec(453.05, -607.7, 28.59, 263.54),      label = "Textile"          }, -- poshte md ghadim
            { coords = vec(1737.47, 3637.74, 35.64, 296.45),    label = "Administatior"    }, -- Administatior
            { coords = vec(885.84, -181.47, 73.6, 239.66),      label = "Trangerine"       }, -- tx Old
            { coords = vec(-1290.7, -3345.61, 13.95, 155.03),   label = "Air"              }, -- air
        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false, key = { ["taxi"] = 0, ["fbi"] = 5 }
    },

------------------------------------------------ # mechanic -------------------------------------------------------------------
    { -- mechanic Fast Teleporter
        positions = {
            { coords = vec(591.88, 616.28, 135.1, 231.83),     label = "Station 1 City"   },
            { coords = vec(1350.65, -773.89, 67.25, 110.59),   label = "Station 2 City"   },
            { coords = vec(1231.4, 2733.0, 38.22, 0.49),       label = "Station 3 Sandy"  },
            { coords = vec( 98.79, 6620.76, 32.44, 223.35),    label = "Station 4 Palato" },
            { coords = vec(-73.38, -2004.6, 18.28, 350.59),    label = "Car Dealer"       },
            { coords = vec(-1245.31, -2244.54, 14.14, 146.91), label = "Custom airplane"  },
            { coords = vec(-928.3, -1511.02, 5.18, 16.79),     label = "Custom Boat"      },
            { coords = vec(-1990.06, -325.38, 44.11, 55.74),   label = "Pacific Bluffs"   },
        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false, key = { ["mechanic"] = 0, ["car"] = 0, ["fbi"] = 5 }
    },

------------------------------------------------ # Jazire ----------------------------------------------------------------
    { -- teleporter jazire
        positions = {
            { coords = vec(3910.25, -4713.3, 4.4, 272.4),       label = "Safe 1" },
            { coords = vec(5579.03, -5207.37, 13.42, 42.28),    label = "Safe 2" },
            { coords = vec(4873.99, -5736.59, 26.86, 273.69),   label = "Safe 3" },
            { coords = vec(5487.09, -5861.94, 19.68, 32.15),    label = "Safe 4" },
            { coords = vec(5016.27, -5728.36, 17.68, 236.15),   label = "Safe 5" },
        },
        color = {r = 237, g = 228, b = 47}, scale = {p1 = 1.0, p2 = 1.0, p3 = 1.0}, vehicle = false
    },

}


local function selectHandler(location)
    local entity
    if location.vehicle then
       local ped = PlayerPedId()
       if IsPedInAnyVehicle(ped) then
            local vehicle = GetVehiclePedIsIn(ped)
            if GetPedInVehicleSeat(vehicle, -1) == ped then
                entity = vehicle
            else
                ESX.chatMessage("Shoma ranande mashin nistid!", 'plarms')
            end
       else
        entity = ped
       end
    else
        local ped = PlayerPedId()
        if IsPedOnFoot(ped) then
            entity = ped
        else
            ESX.chatMessage("Shoma nemitavanid ba vasile naghlie vared shavid!", 'plarms')
        end
    end

    return entity
end


local function CheckLock(location)
    if location.key then
        local access = true
        if ESX.PlayerData.job.name == 'sheriff' or ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'mt' or ESX.PlayerData.job.name == 'detective' then
            local p = promise.new()
            ESX.TriggerServerCallback('esx_society:doesHavePerm',function(cb)
                p:resolve(cb)
            end,'teleporter')
            access = Citizen.Await(p)
        end
        if location.key[ESX.PlayerData.job.name] and access then
            if ESX.PlayerData.job.grade < location.key[ESX.PlayerData.job.name] then
                return true
            else
                return false
            end
        elseif location.key[string.lower(ESX.PlayerData.gang.name)] then
            if ESX.PlayerData.gang.grade < location.key[string.lower(ESX.PlayerData.gang.name)] then
                return true
            else
                return false
            end
        else
            return true
        end
    else
        return false
    end
end


Citizen.CreateThread(function ()
    waitForLoad()

    for _,location in ipairs(ConfigTeleporter) do
        for __,position in ipairs(location.positions) do
            ESX.RegisterPoint(position.coords.xyz,1.5,{
                Color = {R = 0,G = 255,B = 0,A = 255},
                DrawDistance = 5,
                Radius = 0.5,
                Type = 21
            },{
                Notification = nil,
                DrawText = 'Dokme ~INPUT_CONTEXT~ Jahat Baz Kardan',
                DrawTextRadius = 2,
                DrawTextCoords = position.coords.xyz,
                Key = 'e',
                CB = function()
                    if LocalPlayer.state.blockTeleporter then return end
                    if not CheckLock(location) then

                        local options = {}
                        for k , v in ipairs(location.positions) do
                            if k ~= __ then
                                table.insert(options,{label = v.label, args = v})
                            end
                        end

                        lib.registerMenu({
                            id = 'elv_1',
                            title = 'Asansor',
                            options = options
                        }, function(selected, scrollIndex, args)
                            local entity = selectHandler(location)
                            if entity then
                                LocalPlayer.state.teleporting = true
                                if ESX.progressCircle(3000, true, true) then
                                    TriggerEvent('carry:GetData',function(data,drag)
                                        if data.InProgress or drag then
                                            TriggerEvent('onKeyDown','l')
                                            Citizen.Wait(500)
                                            -- ESX.TriggerServerEvent('ss_cs:csMe',300,'Bug abuse #2')
                                            ESX.Alert('', 'Shoma nemitavanid dar in halat az az asansor estefade konid!', 10000, 'error')
                                        else
                                            DoScreenFadeOut(0)

                                            ESX.Game.Teleport(entity,args.coords.xyz,function()
                                                SetEntityHeading(entity,args.coords.w)
                                            end)

                                            Citizen.Wait(500)
                                            DoScreenFadeIn(500)
                                        end
                                        LocalPlayer.state.teleporting = nil
                                    end)
                                else
                                    LocalPlayer.state.teleporting = nil
                                end
                            end
                        end)
                        lib.showMenu('elv_1')
                    else
                        ESX.chatMessage("Shoma dastresi be in teleporter ra nadarid!", 'plarms')
                    end

                end,
            },{
                In = nil,
                Out = function()
                    ESX.UI.Menu.CloseAll()
                    lib.hideMenu()
                end,
            })

        end

    end
end)

RegisterCommand('getint', function(source, args)
    local ped = GetPlayerPed(-1)
    local interior = GetInteriorFromEntity(ped)
    print(interior)
end, false)

local function interior(int, state)
    if Ipls[int] then
        intHandler(Ipls[int].name, state)
    end
end

local function intHandler(name, state)
    local interior = Ipls[name].fuc
    if name == "bike" then
        if state then
            interior.Ipl.Interior.Load()
            interior.LoadDefault()
        else
            interior.Ipl.Interior.Remove()
            interior.Walls.Clear(false)
            interior.Furnitures.Clear(false)
            interior.Decoration.Clear(false)
            interior.Mural.Clear(false)
            interior.GunLocker.Clear(false)
            interior.ModBooth.Clear(false)
            interior.Meth.Clear(false)
            interior.Cash.Clear(false)
            interior.Weed.Clear(false)
            interior.Coke.Clear(false)
            interior.Counterfeit.Clear(false)
            interior.Documents.Clear(false)
            RefreshInterior(interior.interiorId)
        end
    elseif name == "executive3" then
        if state then
            interior.LoadDefault()
        else
            interior.Style.Clear(false)
            interior.Strip.Enable({interior.Strip.A, interior.Strip.B, interior.Strip.C}, false)
            interior.Booze.Enable({interior.Booze.A, interior.Booze.B, interior.Booze.C}, false)
            interior.Smoke.Clear(true)
        end
    elseif name == "executive2" then
        if state then
           interior.LoadDefault()
        else
            interior.Style.Clear(false)
            interior.Strip.Enable({interior.Strip.A, interior.Strip.B, interior.Strip.C}, false)
            interior.Booze.Enable({interior.Booze.A, interior.Booze.B, interior.Booze.C}, false)
            interior.Smoke.Clear(true)
        end
    elseif name == "executive1" then
        if state then
            interior.LoadDefault()
        else
            interior.Style.Clear(false)
            interior.Strip.Enable({interior.Strip.A, interior.Strip.B, interior.Strip.C}, false)
            interior.Booze.Enable({interior.Booze.A, interior.Booze.B, interior.Booze.C}, false)
            interior.Smoke.Clear(true)
        end
    end
end
