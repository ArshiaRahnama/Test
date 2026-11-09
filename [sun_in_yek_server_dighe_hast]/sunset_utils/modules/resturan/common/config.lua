-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

configResturan = {
    jobName = 'resturan',
    positions = {
        bossAction = {
            coords = {
                vec(-1656.2,165.19,61.73),
                vec(-577.38,-1067.64,26.61),
            },
            label = 'Boss action',
            cb = function()
                local elements = {
                    {label = 'Boss action', value = 'bossAction'},
                }
                if ESX.PlayerData.job.grade_name == 'boss' then
                    table.insert(elements, {label = 'Kharid Item', value = 'buyItem'})
                end
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss',
                {
                    title    = 'Boss action',
                    align    = 'top-left',
                    elements = elements,
                }, function(data, menu)
                    menu.close()
                    if data.current.value == 'bossAction' then
                        TriggerEvent('esx_society:openbossss', 'resturan', function(data, menu)
                            menu.close()
                        end)
                    elseif data.current.value == 'buyItem' then
                        buyItemResturan()
                    end
                end, function(data, menu)
                    menu.close()
                end)
            end
        },
        cloakRoom = {
            coords = {
                vec(-1658.91,158.18,61.73), -- shams
                vec(-587.09,-1050.33,22.34), -- owo
                vec(-1353.06,-1065.97,7.39), -- b
            },
            label = 'Komod lebas',
            cb = function()
                local elements = {
                    {label = 'Lebas Shakhsi', value = 'citizen_wear'},
                }
                table.insert(elements, {label = 'Lebas Kar'})
                ESX.UI.Menu.CloseAll()
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',
                {
                    title    = 'Komod Lebas',
                    align    = 'top-left',
                    elements = elements,
                },
                function(data, menu)
                    if data.current.value == 'citizen_wear' then
                        exports['sunset_clothe']:removeStuffJob()
                        Citizen.Wait(1000)
                        exports['sunset_clothe']:loadUsed()
                    else
                        ESX.TriggerServerCallback('esx_society:getPlayerSkin', function(skin, jobSkin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                            else
                                TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                            end
                        end)
                    end
                end,
                function(data, menu)
                    menu.close()
                end)
            end
        },
        locker = {
            coords = {
                vec(-1651.75,159.69,61.73), -- shams
                vec(-585.17,-1056.31,22.34), -- owo
                vec(-595.8,-1062.95,22.34), -- owo2
                vec(-1351.09,-1059.76,3.89), -- b
            },
            label = 'Locker',
            cb = function()
                local elements = {
                    {label = 'Anbar 🎒', value = 'locker'},
                }
                ESX.UI.Menu.CloseAll()
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'locker',
                {
                    title    = 'Locker',
                    align    = 'top-left',
                    elements = elements,
                },
                function(data, menu)
                    if data.current.value == 'locker' then
                        exports['sun-inventory-hud']:openJobInventory('resturan')
                    end
                end,
                function(data, menu)
                    menu.close()
                end)     
            end
        },
    },
    craft = {
        items = {
            {
                label = 'Kababe goraz',
                give = {'boar_kebab',8},
                need = {
                    {'boar_meat', 1},
                    {'bread', 2},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Soupe Goraz',
                give = {'boar_soup',8},
                need = {
                    {'boar_meat', 1},
                    {'water', 3},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Kababe Ahu',
                give = {'deer_kebab',6},
                need = {
                    {'deer_meat', 1},
                    {'bread', 3},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Soupe Ahu',
                give = {'deer_soup',6},
                need = {
                    {'deer_meat', 1},
                    {'water', 3},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Kababe Khuk',
                give = {'pig_kebab',6},
                need = {
                    {'pig_meat', 1},
                    {'bread', 3},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Soupe Khuk',
                give = {'pig_soup',6},
                need = {
                    {'pig_meat', 1},
                    {'water', 3},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Kababe Khargush',
                give = {'rabbit_kebab',23},
                need = {
                    {'rabbit_meat', 1},
                    {'bread', 3},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Soupe Khargush',
                give = {'rabbit_soup',23},
                need = {
                    {'rabbit_meat', 1},
                    {'water', 3},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Kotlet',
                give = {'kotlet_kebab',23},
                need = {
                    {'pigeon_meat', 1},
                    {'bread', 3},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Soupe Kabutar',
                give = {'pigeon_soup',23},
                need = {
                    {'pigeon_meat', 1},
                    {'bread', 3},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Khorake Sardine',
                give = {'sardine_kebab',10},
                need = {
                    {'mahi_sardine', 14},
                    {'bread', 2},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Ghalie Mahi',
                give = {'sangsar_kebab',10},
                need = {
                    {'mahi_sangsar', 11},
                    {'bread', 2},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Khorake OrdakMahi',
                give = {'ordak_kebab',10},
                need = {
                    {'mahi_ordak', 11},
                    {'bread', 2},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Ghezelala Sukhari',
                give = {'ghezel_kebab',10},
                need = {
                    {'mahi_ghezel', 10},
                    {'bread', 2},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Hamoor sorkh shode',
                give = {'hamoor_kebab',10},
                need = {
                    {'mahi_hamoor', 10},
                    {'bread', 2},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Sorkhoo Kababi',
                give = {'sorkhoo_kebab',10},
                need = {
                    {'mahi_sorkhoo', 10},
                    {'bread', 2},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Mahi Salmon Tanuri',
                give = {'salmon_kebab',10},
                need = {
                    {'mahi_salmon', 10},
                    {'bread', 2},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'shooride sorkh shode',
                give = {'shooride_kebab',10},
                need = {
                    {'mahi_shooride', 10},
                    {'bread', 1},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Sandwich Tilapia',
                give = {'tilapia_kebab',10},
                need = {
                    {'mahi_tilapia', 10},
                    {'bread', 1},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Mahi Sefid Kababi',
                give = {'sefid_kebab',10},
                need = {
                    {'mahi_sefid', 9},
                    {'bread', 2},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Mahi Shir sorkh shode',
                give = {'shir_kebab',10},
                need = {
                    {'mahi_shir', 9},
                    {'bread', 1},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Meygoo Sukhari',
                give = {'meygoo_kebab',10},
                need = {
                    {'mahi_meygoo', 8},
                    {'bread', 4},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Morghe Sorkh karde',
                give = {'chicken_kebab',10},
                need = {
                    {'slaughtered_chicken', 6},
                    {'bread', 3},
                    {'petrol', 1},
                },
                time = 20
            },
            {
                label = 'Jooje Kabab',
                give = {'jooje_kebab',10},
                need = {
                    {'packaged_chicken', 24},
                    {'bread', 3},
                    {'petrol', 1},
                },
                time = 20
            }
        },
        coords = {
            vec(-590.42, -1056.52, 22.36), -- owo
            vec(-1338.95, -1061.35, 7.39), -- b
            vec(-1660.64, 175.81, 61.73), -- shams

        },
        cb = function(key,data)
            local p = promise.new()
            ESX.TriggerServerCallback('esx_society:doesHavePerm',function(cb)
                p:resolve(cb)
            end,'craftWithLocker')
            local craftWithLocker = Citizen.Await(p)
            local canCraft = true
            local need = data.need
            if craftWithLocker then
                local p = promise.new()
                ESX.TriggerServerCallback('resturan:getInventory', function(inventory)
                    p:resolve(inventory)
                end)
                local inventory = Citizen.Await(p)
                local items = inventory.items
                if #items == 0 then canCraft = false end
                local can = false
                for k, v in pairs(need) do
                    local breakBool = false
                    local find = false
                    for k2, v2 in pairs(items) do
                        if v2.name == v[1] then
                            if v2.count >= v[2] then
                                can = true
                                find = true
                            else
                                can = false
                                breakBool = true
                                break
                            end
                        end
                    end
                    if breakBool or not find then break end
                end
                canCraft = can
            else
                for k,v in pairs(need) do
                    if not ESX.DoesHaveItem2(v[1],v[2]) then
                        canCraft = false
                        break
                    end
                end
            end
            if canCraft then
                exports['sun-animmenu']:PlayEmote('bbq',true)
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "resturan",
                    duration = data.time * 1000,
                    label = "",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    },
                    animation = data.anim,
                }, function(status)
                    if not status then
                        ClearPedTasksImmediately(PlayerPedId())
                        ESX.TriggerServerEvent('resturan:craft', key,craftWithLocker)
                    end
                end)
            else
                ESX.chatMessage('Item haye mored niaz baraye craft : ', 'plarms')
                for k,v in pairs(need) do
                    ESX.chatMessage(ESX.getItem(v[1]).label .. ' ' .. v[2] .. 'x', 'plarms')
                end
                ESX.Alert('','Shoma material haye lazem ra nadarid!',5000,'error')
            end
        end
    },

    itemShop = {
        water = {count = 100, price = 40000},
        bread = {count = 100, price = 45000},
        radio = {count = 10,  price = 60000},
    },

    items = {
        {'boar_kebab','Kababe goraz',20, 'sandwichEat'},
        {'boar_soup','Soupe Goraz',20, 'soupEat'},
        {'deer_kebab','Kababe Ahu',20, 'sandwichEat'},
        {'deer_soup','Soupe Ahu',20, 'soupEat'},
        {'pig_kebab','Kababe Khuk',20, 'sandwichEat'},
        {'pig_soup','Soupe Khuk',20, 'soupEat'},
        {'rabbit_kebab','Kababe Khargush',20, 'sandwichEat'},
        {'rabbit_soup','Soupe Khargush',20, 'soupEat'},
        {'kotlet_kebab','Kotlet',20, 'burgerEat'},
        {'pigeon_soup','Soupe Kabutar',20, 'soupEat'},
        {'sardine_kebab','Khorake Sardine',20, 'sandwichEat'},
        {'sangsar_kebab','Ghalie Mahi',20, 'sandwichEat'},
        {'ordak_kebab','Khorake OrdakMahi',20, 'sandwichEat'},
        {'ghezel_kebab','Ghezelala Sukhari',20, 'burgerEat'},
        {'hamoor_kebab','Hamoor sorkh shode',20, 'sandwichEat'},
        {'salmon_kebab','Mahi Salmon Tanuri',20, 'burgerEat'},
        {'shooride_kebab','Shooride sorkh shode',20, 'sandwichEat'},
        {'tilapia_kebab','Sandwich Tilapia',20, 'sandwichEat'},
        {'sefid_kebab','Mahi Sefid Kababi',20, 'sandwichEat'},
        {'shir_kebab','Mahi Shir sorkh shode',20, 'sandwichEat'},
        {'meygoo_kebab','Meygoo Sukhari',20, 'sandwichEat'},
        {'chicken_kebab','Morghe Sorkh karde',20, 'sandwichEat'},
        {'jooje_kebab','Jooje Kabab',20, 'sandwichEat'},
        {'sorkhoo_kebab','Sorkhoo Kababi',20, 'sandwichEat'},
    },
    drinks = {
        {
            name = 'juice_beer',
            animName = 'beerDrink',
        },
        {
            name = 'juice_orange',
            animName = 'animDrink',
        },
        {
            name = 'juice_grape',
            animName = 'cupDrink',
        },
        {
            name = 'juice_apple',
            animName = 'animDrink',
        },
    },
    drinks2 = {
        {
            name = 'vodka2',
            animName = 'wineDrink',
            effect = {
                name = 'spectator5', -- 584
                strength = 0.4,
                time = 120000,
            },
            vomitChance = 10,
            illusionChance = 10,
        },
        {
            name = 'whisky2',
            animName = 'whiskyDrink',
            effect = {
                name = 'hud_def_blur', -- 152
                strength = 0.4,
                time = 120000,
            },
            vomitChance = 10,
            illusionChance = 10,
        },
        {
            name = 'absolut2',
            animName = 'wineDrink',
            effect = {
                name = 'drug_wobbly', -- 74
                strength = 0.4,
                time = 120000,
            },
            vomitChance = 10,
            illusionChance = 10,
        },
        {
            name = 'cider2',
            animName = 'wineDrink',
            effect = {
                name = 'drunk', -- 75
                strength = 0.4,
                time = 120000,
            },
            vomitChance = 10,
            illusionChance = 10,
        },
        {
            name = 'wine2',
            animName = 'wineDrink',
            effect = {
                name = 'drug_gas_huffin', -- 73
                strength = 0.4,
                time = 120000,
            },
            vomitChance = 10,
            illusionChance = 10,
        },
        {
            name = 'sake2',
            animName = 'wineDrink',
            effect = {
                name = 'drug_deadman_blend', -- 67
                strength = 0.4,
                time = 120000,
            },
            vomitChance = 10,
            illusionChance = 10,
        },
    },
    drinks3 = {
        {
            name = 'juice_caffee',
            animName = 'cupDrink',
            effect = {
                name = 'drug_gas_huffin', -- 67
                strength = 0.1,
                time = 20000,
            },
            vomitChance = 1,
            illusionChance = 1,
        },
    },
    breadEat1 = {
        {
            name = 'bread',
            animName = 'breadEat',
        },
    },
    waterEat1 = {
        {
            name = 'water',
            animName = 'waterEat',
        },
    },
    doodiEat1 = {
        {
            name = 'morgh_doodi',
            animName = 'doodiEat',
        },
        {
            name = 'meat_doodi',
            animName = 'doodiEat',
        },
        {
            name = 'mahi_doodi',
            animName = 'doodiEat',
        },
    },
    drugSmoking = {
        {
            name = 'marijuana',
            animName = 'smokingDrug',
            effect = {
                name = 'drug_gas_huffin', -- 67
                strength = 0.3,
                time = 30000,
            },
            vomitChance = 1,
            illusionChance = 20,
        },
        {
            name = 'cocaine',
            animName = 'smokingDrug',
            effect = {
                name = 'drug_gas_huffin', -- 67
                strength = 0.3,
                time = 30000,
            },
            vomitChance = 1,
            illusionChance = 20,
        },
        {
            name = 'crack',
            animName = 'smokingDrug',
            effect = {
                name = 'drug_gas_huffin', -- 67
                strength = 0.3,
                time = 30000,
            },
            vomitChance = 1,
            illusionChance = 20,
        },
        {
            name = 'meth',
            animName = 'smokingDrug',
            effect = {
                name = 'drug_gas_huffin', -- 67
                strength = 0.3,
                time = 30000,
            },
            vomitChance = 1,
            illusionChance = 20,
        },
        {
            name = 'heroine',
            animName = 'smokingDrug',
            effect = {
                name = 'drug_gas_huffin', -- 67
                strength = 0.3,
                time = 30000,
            },
            vomitChance = 1,
            illusionChance = 20,
        },
    },
}
