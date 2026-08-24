return {
	['testburger'] = {
		label = 'Test Burger',
		weight = 220,
		degrade = 60,
		client = {
			image = 'burger_chicken.png',
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			export = 'ox_inventory_examples.testburger'
		},
		server = {
			export = 'ox_inventory_examples.testburger',
			test = 'what an amazingly delicious burger, amirite?'
		},
		buttons = {
			{
				label = 'Lick it',
				action = function(slot)
					print('You licked the burger')
				end
			},
			{
				label = 'Squeeze it',
				action = function(slot)
					print('You squeezed the burger :(')
				end
			},
			{
				label = 'What do you call a vegan burger?',
				group = 'Hamburger Puns',
				action = function(slot)
					print('A misteak.')
				end
			},
			{
				label = 'What do frogs like to eat with their hamburgers?',
				group = 'Hamburger Puns',
				action = function(slot)
					print('French flies.')
				end
			},
			{
				label = 'Why were the burger and fries running?',
				group = 'Hamburger Puns',
				action = function(slot)
					print('Because they\'re fast food.')
				end
			}
		},
		consume = 0.3
	},

	['bandage'] = {
		label = 'Bandage',
		weight = 115,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
		}
	},

	['black_money'] = {
		label = 'Dirty Money',
	},

	['burger'] = {
		label = 'Burger',
		weight = 220,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'You ate a delicious burger'
		},
	},

	['sprunk'] = {
		label = 'Sprunk',
		weight = 350,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_can_01`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'You quenched your thirst with a sprunk'
		}
	},

	['parachute'] = {
		label = 'Parachute',
		weight = 8000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},

	['garbage'] = {
		label = 'Garbage',
	},

	['paperbag'] = {
		label = 'Paper Bag',
		weight = 1,
		stack = false,
		close = false,
		consume = 0
	},

	['identification'] = {
		label = 'Identification',
		client = {
			image = 'card_id.png'
		}
	},

	['panties'] = {
		label = 'Knickers',
		weight = 10,
		consume = 0,
		client = {
			status = { thirst = -100000, stress = -25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
			usetime = 2500,
		}
	},

	['lockpick'] = {
		label = 'Lockpick',
		weight = 160,
	},

	['phone'] = {
		label = 'Phone',
		weight = 190,
		stack = false,
		consume = 0,
		client = {
			add = function(total)
				if total > 0 then
					pcall(function() return exports.npwd:setPhoneDisabled(false) end)
				end
			end,

			remove = function(total)
				if total < 1 then
					pcall(function() return exports.npwd:setPhoneDisabled(true) end)
				end
			end
		}
	},

	['money'] = {
		label = 'Money',
	},

	['mustard'] = {
		label = 'Mustard',
		weight = 500,
		client = {
			status = { hunger = 25000, thirst = 25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'You.. drank mustard'
		}
	},

	['water'] = {
		label = 'Water',
		weight = 500,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'You drank some refreshing water'
		}
	},

	['radio'] = {
		label = 'Radio',
		weight = 1000,
		stack = false,
		allowArmed = true
	},

	['armour'] = {
		label = 'Bulletproof Vest',
		weight = 3000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 3500
		}
	},

	['clothing'] = {
		label = 'Clothing',
		consume = 0,
	},

	['mastercard'] = {
		label = 'Fleeca Card',
		stack = false,
		weight = 10,
		client = {
			image = 'card_bank.png'
		}
	},

	['scrapmetal'] = {
		label = 'Scrap Metal',
		weight = 80,
	},

	["aard"] = {
		label = "Aard",
		weight = 0,
		stack = true,
		close = true,
	},

	["abporteghal"] = {
		label = "Ab Porteghal",
		weight = 0,
		stack = true,
		close = true,
	},

	["air_freshener_pine"] = {
		label = "Air Freshener Pine",
		weight = 0,
		stack = true,
		close = true,
	},

	["alive_chicken"] = {
		label = "ElÃ¤vÃ¤ kana",
		weight = 0,
		stack = true,
		close = true,
	},

	["armor"] = {
		label = "Armor",
		weight = 0,
		stack = true,
		close = true,
	},

	["bakingpowder"] = {
		label = "Baking Powder",
		weight = 0,
		stack = true,
		close = true,
	},

	["bastani"] = {
		label = "Bastani",
		weight = 0,
		stack = true,
		close = true,
	},

	["beer"] = {
		label = "Beer",
		weight = 0,
		stack = true,
		close = true,
	},

	["berenj_sushi"] = {
		label = "Berenj Sushi",
		weight = 0,
		stack = true,
		close = true,
	},

	["blackmoney"] = {
		label = "Black Money",
		weight = 0,
		stack = true,
		close = true,
	},

	["blowpipe"] = {
		label = "Chalumeaux",
		weight = 0,
		stack = true,
		close = true,
	},

	["blowtorch"] = {
		label = "Blowtorch",
		weight = 0,
		stack = true,
		close = true,
	},

	["bobal_tea_matcha"] = {
		label = "Bobal Tea Matcha",
		weight = 0,
		stack = true,
		close = true,
	},

	["bobal_tea_tamshak"] = {
		label = "Bobal Tea Tamshak",
		weight = 0,
		stack = true,
		close = true,
	},

	["boba_milk_tea_caramel"] = {
		label = "Boba Milk Tea Caramel",
		weight = 0,
		stack = true,
		close = true,
	},

	["boba_milk_tea_matcha"] = {
		label = "Boba Milk Tea Matcha",
		weight = 0,
		stack = true,
		close = true,
	},

	["bread"] = {
		label = "Bread",
		weight = 0,
		stack = true,
		close = true,
	},

	["breathalyzer"] = {
		label = "Test Alchol",
		weight = 0,
		stack = true,
		close = true,
	},

	["bubbletetotfarangi"] = {
		label = "Bubblete Totfarangi",
		weight = 0,
		stack = true,
		close = true,
	},

	["cakebastani"] = {
		label = "Cake Bastani",
		weight = 0,
		stack = true,
		close = true,
	},

	["cakebastanivanili"] = {
		label = "Cake Bastani Vanili",
		weight = 0,
		stack = true,
		close = true,
	},

	["caketotfarangi"] = {
		label = "Cake Totfarangi",
		weight = 0,
		stack = true,
		close = true,
	},

	["cake_bastani_vanili"] = {
		label = "Cake Bastani Vanili",
		weight = 0,
		stack = true,
		close = true,
	},

	["cake_limoii"] = {
		label = "Cake Limoii",
		weight = 0,
		stack = true,
		close = true,
	},

	["calzone"] = {
		label = "Calzone",
		weight = 0,
		stack = true,
		close = true,
	},

	["cannabis"] = {
		label = "Hashish",
		weight = 0,
		stack = true,
		close = true,
	},

	["carokit"] = {
		label = "Kit carosserie",
		weight = 0,
		stack = true,
		close = true,
	},

	["carotool"] = {
		label = "outils carosserie",
		weight = 0,
		stack = true,
		close = true,
	},

	["ceramic_coat"] = {
		label = "Ceramic Coat",
		weight = 0,
		stack = true,
		close = true,
	},

	["chaee"] = {
		label = "Chaee",
		weight = 0,
		stack = true,
		close = true,
	},

	["clip"] = {
		label = "Clip",
		weight = 0,
		stack = true,
		close = true,
	},

	["clothe"] = {
		label = "Vaate",
		weight = 0,
		stack = true,
		close = true,
	},

	["coca"] = {
		label = "Tokhm Kokayin",
		weight = 0,
		stack = true,
		close = true,
	},

	["cocaine"] = {
		label = "Kokayin",
		weight = 0,
		stack = true,
		close = true,
	},

	["coin"] = {
		label = "Coin",
		weight = 0,
		stack = true,
		close = true,
	},

	["cookie_shekari"] = {
		label = "Cookie Shekari",
		weight = 0,
		stack = true,
		close = true,
	},

	["copper"] = {
		label = "Kupari",
		weight = 0,
		stack = true,
		close = true,
	},

	["crack"] = {
		label = "Crack",
		weight = 0,
		stack = true,
		close = true,
	},

	["croissant_kareii"] = {
		label = "Croissant Kareii",
		weight = 0,
		stack = true,
		close = true,
	},

	["cupcake"] = {
		label = "Cup Cake",
		weight = 0,
		stack = true,
		close = true,
	},

	["cupcake_shokolati"] = {
		label = "Cupcake Shokolati",
		weight = 0,
		stack = true,
		close = true,
	},

	["customcoupon"] = {
		label = "Coupon",
		weight = 0,
		stack = true,
		close = true,
	},

	["cutted_wood"] = {
		label = "Pilkottu Puu",
		weight = 0,
		stack = true,
		close = true,
	},

	["dabs"] = {
		label = "Dabs",
		weight = 0,
		stack = true,
		close = true,
	},

	["daneghahve"] = {
		label = "Dane Ghahve",
		weight = 0,
		stack = true,
		close = true,
	},

	["delester"] = {
		label = "Delester",
		weight = 0,
		stack = true,
		close = true,
	},

	["diamond"] = {
		label = "Timantti",
		weight = 0,
		stack = true,
		close = true,
	},

	["dooghbg"] = {
		label = "Doogh Bozorg",
		weight = 0,
		stack = true,
		close = true,
	},

	["dooghg"] = {
		label = "Doogh Kuchak",
		weight = 0,
		stack = true,
		close = true,
	},

	["drugtest"] = {
		label = "Test Mavad",
		weight = 0,
		stack = true,
		close = true,
	},

	["eaglemeet"] = {
		label = "Eagle Meat",
		weight = 0,
		stack = true,
		close = true,
	},

	["ebitenrol"] = {
		label = "Ebi Tenrol",
		weight = 0,
		stack = true,
		close = true,
	},

	["eclip"] = {
		label = "Extended Clip",
		weight = 0,
		stack = true,
		close = true,
	},

	["egg"] = {
		label = "Tokhm Morgh",
		weight = 0,
		stack = true,
		close = true,
	},

	["energy_mix"] = {
		label = "Energy Mix",
		weight = 0,
		stack = true,
		close = true,
	},

	["engine"] = {
		label = "Engine",
		weight = 0,
		stack = true,
		close = true,
	},

	["engine1"] = {
		label = "Engine Scrap X1",
		weight = 0,
		stack = true,
		close = true,
	},

	["engine2"] = {
		label = "Engine Scrap X2",
		weight = 0,
		stack = true,
		close = true,
	},

	["engine3"] = {
		label = "Engine Scrap X3",
		weight = 0,
		stack = true,
		close = true,
	},

	["engine4"] = {
		label = "Engine Scrap X4",
		weight = 0,
		stack = true,
		close = true,
	},

	["engine5"] = {
		label = "Engine Scrap X5",
		weight = 0,
		stack = true,
		close = true,
	},

	["engine6"] = {
		label = "Engine Scrap X6",
		weight = 0,
		stack = true,
		close = true,
	},

	["ephedra"] = {
		label = "Ephedra",
		weight = 0,
		stack = true,
		close = true,
	},

	["ephedrine"] = {
		label = "Ephedrine",
		weight = 0,
		stack = true,
		close = true,
	},

	["eskenas"] = {
		label = "Eskenas",
		weight = 0,
		stack = true,
		close = true,
	},

	["essence"] = {
		label = "PolttoÃ¶ljy",
		weight = 0,
		stack = true,
		close = true,
	},

	["fabric"] = {
		label = "Kangas",
		weight = 0,
		stack = true,
		close = true,
	},

	["fakepee"] = {
		label = "Fake Pee",
		weight = 0,
		stack = true,
		close = true,
	},

	["fenjon"] = {
		label = "Fenjon",
		weight = 0,
		stack = true,
		close = true,
	},

	["fenjonkasif"] = {
		label = "Fenjon Kasif",
		weight = 0,
		stack = true,
		close = true,
	},

	["fish"] = {
		label = "Kala",
		weight = 0,
		stack = true,
		close = true,
	},

	["fishingrod"] = {
		label = "Fishing Rod",
		weight = 0,
		stack = true,
		close = true,
	},

	["fixkit"] = {
		label = "Kit rÃ©paration",
		weight = 0,
		stack = true,
		close = true,
	},

	["fixtool"] = {
		label = "outils rÃ©paration",
		weight = 0,
		stack = true,
		close = true,
	},

	["fountain"] = {
		label = "Fountain Firework",
		weight = 0,
		stack = true,
		close = true,
	},

	["froyo_mango"] = {
		label = "Froyo Mango",
		weight = 0,
		stack = true,
		close = true,
	},

	["fruit_punch"] = {
		label = "Fruit Punch",
		weight = 0,
		stack = true,
		close = true,
	},

	["garlic_bread"] = {
		label = "Garlic Bread",
		weight = 0,
		stack = true,
		close = true,
	},

	["gazbottle"] = {
		label = "bouteille de gaz",
		weight = 0,
		stack = true,
		close = true,
	},

	["gazellemeet"] = {
		label = "Gazelle Meat",
		weight = 0,
		stack = true,
		close = true,
	},

	["ghahve100"] = {
		label = "Ghahve 100",
		weight = 0,
		stack = true,
		close = true,
	},

	["ghahve50"] = {
		label = "Ghahve 50",
		weight = 0,
		stack = true,
		close = true,
	},

	["ghahve80"] = {
		label = "Ghahve 80",
		weight = 0,
		stack = true,
		close = true,
	},

	["gold"] = {
		label = "Kulta",
		weight = 0,
		stack = true,
		close = true,
	},

	["goshteaho"] = {
		label = "Goshte Aho",
		weight = 0,
		stack = true,
		close = true,
	},

	["goshtecougar"] = {
		label = "Goshte Cougar",
		weight = 0,
		stack = true,
		close = true,
	},

	["goshtecoyote"] = {
		label = "Goshte Coyote",
		weight = 0,
		stack = true,
		close = true,
	},

	["goshtehusky"] = {
		label = "Goshte Husky",
		weight = 0,
		stack = true,
		close = true,
	},

	["goshtekhargush"] = {
		label = "Goshte Khargush",
		weight = 0,
		stack = true,
		close = true,
	},

	["goshteoghab"] = {
		label = "Goshte Oghab",
		weight = 0,
		stack = true,
		close = true,
	},

	["goshtepig"] = {
		label = "Goshte Pig",
		weight = 0,
		stack = true,
		close = true,
	},

	["goshterottweiler"] = {
		label = "Goshte Rottweiler",
		weight = 0,
		stack = true,
		close = true,
	},

	["grip"] = {
		label = "Grip",
		weight = 0,
		stack = true,
		close = true,
	},

	["headeaho"] = {
		label = "Heade Aho",
		weight = 0,
		stack = true,
		close = true,
	},

	["headecougar"] = {
		label = "Heade Cougar",
		weight = 0,
		stack = true,
		close = true,
	},

	["headecoyote"] = {
		label = "Heade Coyote",
		weight = 0,
		stack = true,
		close = true,
	},

	["headehusky"] = {
		label = "Heade Husky",
		weight = 0,
		stack = true,
		close = true,
	},

	["headekhargush"] = {
		label = "Heade Khargush",
		weight = 0,
		stack = true,
		close = true,
	},

	["heademorgh"] = {
		label = "Heade Morgh",
		weight = 0,
		stack = true,
		close = true,
	},

	["headeoghab"] = {
		label = "Heade Oghab",
		weight = 0,
		stack = true,
		close = true,
	},

	["headepig"] = {
		label = "Heade Pig",
		weight = 0,
		stack = true,
		close = true,
	},

	["headerottweiler"] = {
		label = "Heade Rottweiler",
		weight = 0,
		stack = true,
		close = true,
	},

	["henmeat"] = {
		label = "Hen Meat",
		weight = 0,
		stack = true,
		close = true,
	},

	["heroine"] = {
		label = "Heroine",
		weight = 0,
		stack = true,
		close = true,
	},

	["hifi"] = {
		label = "HiFi",
		weight = 0,
		stack = true,
		close = true,
	},

	["hotwire"] = {
		label = "Pich Goshti",
		weight = 0,
		stack = true,
		close = true,
	},

	["hot_chocolate"] = {
		label = "Hot Chocolate",
		weight = 0,
		stack = true,
		close = true,
	},

	["icecream_chocolate_cone"] = {
		label = "Icecream Chocolate Cone",
		weight = 0,
		stack = true,
		close = true,
	},

	["icecream_sandwich"] = {
		label = "Icecream Sandwich",
		weight = 0,
		stack = true,
		close = true,
	},

	["icecream_vanilla_cone"] = {
		label = "Icecream Vanilla Cone",
		weight = 0,
		stack = true,
		close = true,
	},

	["ice_coffee_matcha"] = {
		label = "Ice Coffee Matcha",
		weight = 0,
		stack = true,
		close = true,
	},

	["ice_tea_special"] = {
		label = "Ice Tea Special",
		weight = 0,
		stack = true,
		close = true,
	},

	["interior_cleaner"] = {
		label = "Interior Cleaner Kit",
		weight = 0,
		stack = true,
		close = true,
	},

	["iron"] = {
		label = "Rauta",
		weight = 0,
		stack = true,
		close = true,
	},

	["joje"] = {
		label = "Joje",
		weight = 0,
		stack = true,
		close = true,
	},

	["kabab"] = {
		label = "Kabab",
		weight = 0,
		stack = true,
		close = true,
	},

	["kare"] = {
		label = "Kare",
		weight = 0,
		stack = true,
		close = true,
	},

	["kase"] = {
		label = "Kase",
		weight = 0,
		stack = true,
		close = true,
	},

	["kasekasif"] = {
		label = "Kase Kasif",
		weight = 0,
		stack = true,
		close = true,
	},

	["keik_shokolat"] = {
		label = "Keik Shokolat",
		weight = 0,
		stack = true,
		close = true,
	},

	["khame"] = {
		label = "Khame",
		weight = 0,
		stack = true,
		close = true,
	},

	["khame_yakhi"] = {
		label = "Khame Yakhi",
		weight = 0,
		stack = true,
		close = true,
	},

	["khamir_pizza"] = {
		label = "Khamir Pizza",
		weight = 0,
		stack = true,
		close = true,
	},

	["khamir_shirini"] = {
		label = "Khamir Shirini",
		weight = 0,
		stack = true,
		close = true,
	},

	["laptophack"] = {
		label = "Hacking Laptop",
		weight = 0,
		stack = true,
		close = true,
	},

	["lasheaho"] = {
		label = "Lashe Aho",
		weight = 0,
		stack = true,
		close = true,
	},

	["lashecougar"] = {
		label = "Lashe Cougar",
		weight = 0,
		stack = true,
		close = true,
	},

	["lashecoyote"] = {
		label = "Lashe Coyote",
		weight = 0,
		stack = true,
		close = true,
	},

	["lashehusky"] = {
		label = "Lashe Husky",
		weight = 0,
		stack = true,
		close = true,
	},

	["lashekhargush"] = {
		label = "Lashe Khargush",
		weight = 0,
		stack = true,
		close = true,
	},

	["lashemorgh"] = {
		label = "Lashe Morgh",
		weight = 0,
		stack = true,
		close = true,
	},

	["lashemorgh.png"] = {
		label = "Lashe Morgh",
		weight = 0,
		stack = true,
		close = true,
	},

	["lasheoghab"] = {
		label = "Lashe Oghab",
		weight = 0,
		stack = true,
		close = true,
	},

	["lashepig"] = {
		label = "Lashe Pig",
		weight = 0,
		stack = true,
		close = true,
	},

	["lasherottweiler"] = {
		label = "Lashe Rottweiler",
		weight = 0,
		stack = true,
		close = true,
	},

	["latte"] = {
		label = "Latte",
		weight = 0,
		stack = true,
		close = true,
	},

	["lighter"] = {
		label = "Lighter",
		weight = 0,
		stack = true,
		close = true,
	},

	["limo"] = {
		label = "Limo",
		weight = 0,
		stack = true,
		close = true,
	},

	["lsd"] = {
		label = "LSD",
		weight = 0,
		stack = true,
		close = true,
	},

	["maahi_khaam"] = {
		label = "Maahi Khaam",
		weight = 0,
		stack = true,
		close = true,
	},

	["mahighezel"] = {
		label = "Mahi Ghezel",
		weight = 0,
		stack = true,
		close = true,
	},

	["mahigolip"] = {
		label = "Mahi Golip",
		weight = 0,
		stack = true,
		close = true,
	},

	["mahihamoor"] = {
		label = "Mahi Hamoor",
		weight = 0,
		stack = true,
		close = true,
	},

	["marijuana"] = {
		label = "Marijuana",
		weight = 0,
		stack = true,
		close = true,
	},

	["medikit"] = {
		label = "Medikit",
		weight = 0,
		stack = true,
		close = true,
	},

	["meth"] = {
		label = "Meth",
		weight = 0,
		stack = true,
		close = true,
	},

	["microfiber_cloth"] = {
		label = "Microfiber Cloth",
		weight = 0,
		stack = true,
		close = true,
	},

	["milkshake"] = {
		label = "Milk Shake",
		weight = 0,
		stack = true,
		close = true,
	},

	["milkshake_strawberry"] = {
		label = "Milkshake Strawberry",
		weight = 0,
		stack = true,
		close = true,
	},

	["milk_shake_shokolati"] = {
		label = "Milk Shake Shokolati",
		weight = 0,
		stack = true,
		close = true,
	},

	["miso_soup"] = {
		label = "Miso Soup",
		weight = 0,
		stack = true,
		close = true,
	},

	["mive_mix"] = {
		label = "Mive Mix",
		weight = 0,
		stack = true,
		close = true,
	},

	["mocktail_mojito"] = {
		label = "Virgin Mojito",
		weight = 0,
		stack = true,
		close = true,
	},

	["mocktail_pinacolada"] = {
		label = "Virgin Pina Colada",
		weight = 0,
		stack = true,
		close = true,
	},

	["mufchocolate"] = {
		label = "Mufchocolate",
		weight = 0,
		stack = true,
		close = true,
	},

	["muffin_tamshak"] = {
		label = "Muffin Tamshak",
		weight = 0,
		stack = true,
		close = true,
	},

	["mushroom"] = {
		label = "Mushroom",
		weight = 0,
		stack = true,
		close = true,
	},

	["narcan"] = {
		label = "Narcan",
		weight = 0,
		stack = true,
		close = true,
	},

	["net_cracker"] = {
		label = "Net Cracker",
		weight = 0,
		stack = true,
		close = true,
	},

	["nodel"] = {
		label = "Nodel",
		weight = 0,
		stack = true,
		close = true,
	},

	["nodel_kham"] = {
		label = "Nodel Kham",
		weight = 0,
		stack = true,
		close = true,
	},

	["non_baget"] = {
		label = "Non Baget",
		weight = 0,
		stack = true,
		close = true,
	},

	["noodles"] = {
		label = "Noodles",
		weight = 0,
		stack = true,
		close = true,
	},

	["nori"] = {
		label = "Nori",
		weight = 0,
		stack = true,
		close = true,
	},

	["noshab"] = {
		label = "Noshabe",
		weight = 0,
		stack = true,
		close = true,
	},

	["nutela"] = {
		label = "Nutela",
		weight = 0,
		stack = true,
		close = true,
	},

	["opium"] = {
		label = "Teryak",
		weight = 0,
		stack = true,
		close = true,
	},

	["oreo"] = {
		label = "Oreo",
		weight = 0,
		stack = true,
		close = true,
	},

	["packaged_chicken"] = {
		label = "Kananfilee",
		weight = 0,
		stack = true,
		close = true,
	},

	["packaged_plank"] = {
		label = "Paketoitu Lankku",
		weight = 0,
		stack = true,
		close = true,
	},

	["painkiller"] = {
		label = "Painkiller",
		weight = 0,
		stack = true,
		close = true,
	},

	["panir_pizza"] = {
		label = "Panir Pizza",
		weight = 0,
		stack = true,
		close = true,
	},

	["pankik"] = {
		label = "Pankik",
		weight = 0,
		stack = true,
		close = true,
	},

	["pankik_nutella"] = {
		label = "Pankik Nutella",
		weight = 0,
		stack = true,
		close = true,
	},

	["pankik_oreo"] = {
		label = "Pankik Oreo",
		weight = 0,
		stack = true,
		close = true,
	},

	["pcp"] = {
		label = "PCP",
		weight = 0,
		stack = true,
		close = true,
	},

	["petrol"] = {
		label = "Ã–ljy",
		weight = 0,
		stack = true,
		close = true,
	},

	["petrol_raffin"] = {
		label = "Prosessoitu Ã–ljy",
		weight = 0,
		stack = true,
		close = true,
	},

	["pizzama"] = {
		label = "Pizza Ma",
		weight = 0,
		stack = true,
		close = true,
	},

	["pizzamo"] = {
		label = "Pizza Mo",
		weight = 0,
		stack = true,
		close = true,
	},

	["pizza_bbq_chicken"] = {
		label = "Pizza BBQ Chicken",
		weight = 0,
		stack = true,
		close = true,
	},

	["pizza_margherita"] = {
		label = "Pizza Margherita",
		weight = 0,
		stack = true,
		close = true,
	},

	["pizza_mushroom"] = {
		label = "Pizza Mushroom",
		weight = 0,
		stack = true,
		close = true,
	},

	["pizza_pepperoni"] = {
		label = "Pizza Pepperoni",
		weight = 0,
		stack = true,
		close = true,
	},

	["podrcacao"] = {
		label = "Podr Cacao",
		weight = 0,
		stack = true,
		close = true,
	},

	["poppy"] = {
		label = "KhashKhaash",
		weight = 0,
		stack = true,
		close = true,
	},

	["posteaho"] = {
		label = "Poste Aho",
		weight = 0,
		stack = true,
		close = true,
	},

	["postecougar"] = {
		label = "Poste Cougar",
		weight = 0,
		stack = true,
		close = true,
	},

	["postecoyote"] = {
		label = "Poste Coyote",
		weight = 0,
		stack = true,
		close = true,
	},

	["postehusky"] = {
		label = "Poste Husky",
		weight = 0,
		stack = true,
		close = true,
	},

	["postekhargush"] = {
		label = "Poste Khargush",
		weight = 0,
		stack = true,
		close = true,
	},

	["postepig"] = {
		label = "Poste Pig",
		weight = 0,
		stack = true,
		close = true,
	},

	["poster"] = {
		label = "Poster",
		weight = 0,
		stack = true,
		close = true,
	},

	["posterottweiler"] = {
		label = "Poste Rottweiler",
		weight = 0,
		stack = true,
		close = true,
	},

	["powdr_matcha"] = {
		label = "Powdr Matcha",
		weight = 0,
		stack = true,
		close = true,
	},

	["premium_wax"] = {
		label = "Premium Wax",
		weight = 0,
		stack = true,
		close = true,
	},

	["rabbitmeat"] = {
		label = "Rabbit Meat",
		weight = 0,
		stack = true,
		close = true,
	},

	["rim_polish"] = {
		label = "Rim Polish",
		weight = 0,
		stack = true,
		close = true,
	},

	["roll_darchin"] = {
		label = "Roll Darchin",
		weight = 0,
		stack = true,
		close = true,
	},

	["scope"] = {
		label = "Scope",
		weight = 0,
		stack = true,
		close = true,
	},

	["sf"] = {
		label = "SF",
		weight = 0,
		stack = true,
		close = true,
	},

	["sh"] = {
		label = "SH",
		weight = 0,
		stack = true,
		close = true,
	},

	["shahkelid"] = {
		label = "Shah Kelid",
		weight = 0,
		stack = true,
		close = true,
	},

	["shekar"] = {
		label = "Shekar",
		weight = 0,
		stack = true,
		close = true,
	},

	["shir"] = {
		label = "Shir",
		weight = 0,
		stack = true,
		close = true,
	},

	["shirini_khamei"] = {
		label = "Shirini Khamei",
		weight = 0,
		stack = true,
		close = true,
	},

	["shokolat"] = {
		label = "Shokolat",
		weight = 0,
		stack = true,
		close = true,
	},

	["shotburst"] = {
		label = "Shotburst Firework",
		weight = 0,
		stack = true,
		close = true,
	},

	["sianor"] = {
		label = "Sianor",
		weight = 0,
		stack = true,
		close = true,
	},

	["sibp"] = {
		label = "Sib Zamini",
		weight = 0,
		stack = true,
		close = true,
	},

	["silencer"] = {
		label = "Silencer",
		weight = 0,
		stack = true,
		close = true,
	},

	["slaughtered_chicken"] = {
		label = "Teurastettu kana",
		weight = 0,
		stack = true,
		close = true,
	},

	["sm"] = {
		label = "SM",
		weight = 0,
		stack = true,
		close = true,
	},

	["soap_foam"] = {
		label = "Soap Foam",
		weight = 0,
		stack = true,
		close = true,
	},

	["soda_lime"] = {
		label = "Soda Lime",
		weight = 0,
		stack = true,
		close = true,
	},

	["soda_water"] = {
		label = "Soda Water",
		weight = 0,
		stack = true,
		close = true,
	},

	["sos_gojeh"] = {
		label = "Sos Gojeh",
		weight = 0,
		stack = true,
		close = true,
	},

	["ss"] = {
		label = "SS",
		weight = 0,
		stack = true,
		close = true,
	},

	["starburst"] = {
		label = "Starburst Firework",
		weight = 0,
		stack = true,
		close = true,
	},

	["stone"] = {
		label = "Kivi",
		weight = 0,
		stack = true,
		close = true,
	},

	["sundae_caramel"] = {
		label = "Sundae Caramel",
		weight = 0,
		stack = true,
		close = true,
	},

	["suop"] = {
		label = "Suop",
		weight = 0,
		stack = true,
		close = true,
	},

	["sushi_california"] = {
		label = "Sushi California",
		weight = 0,
		stack = true,
		close = true,
	},

	["sushi_dragon_roll"] = {
		label = "Sushi Dragon Roll",
		weight = 0,
		stack = true,
		close = true,
	},

	["sushi_salmon_nigiri"] = {
		label = "Sushi Salmon Nigiri",
		weight = 0,
		stack = true,
		close = true,
	},

	["sushi_spicy_tuna"] = {
		label = "Sushi Spicy Tuna",
		weight = 0,
		stack = true,
		close = true,
	},

	["sushi_veggie_roll"] = {
		label = "Sushi Veggie Roll",
		weight = 0,
		stack = true,
		close = true,
	},

	["tamshak"] = {
		label = "Tamshak",
		weight = 0,
		stack = true,
		close = true,
	},

	["tequila"] = {
		label = "Tequila",
		weight = 0,
		stack = true,
		close = true,
	},

	["tiramisuye_toot_farangi"] = {
		label = "Tiramisuye TotFarangi",
		weight = 0,
		stack = true,
		close = true,
	},

	["tire_shine"] = {
		label = "Tire Shine",
		weight = 0,
		stack = true,
		close = true,
	},

	["totfarangi"] = {
		label = "Tot Farangi",
		weight = 0,
		stack = true,
		close = true,
	},

	["trailburst"] = {
		label = "Trailburst Firework",
		weight = 0,
		stack = true,
		close = true,
	},

	["unagieelroll"] = {
		label = "Unagi Eel Roll",
		weight = 0,
		stack = true,
		close = true,
	},

	["vafel_nutella"] = {
		label = "Vafel Nutella",
		weight = 0,
		stack = true,
		close = true,
	},

	["vanil"] = {
		label = "Vanil",
		weight = 0,
		stack = true,
		close = true,
	},

	["vodka"] = {
		label = "Vodka",
		weight = 0,
		stack = true,
		close = true,
	},

	["washed_stone"] = {
		label = "Puhdistettu Kivi",
		weight = 0,
		stack = true,
		close = true,
	},

	["whiskey"] = {
		label = "Whiskey",
		weight = 0,
		stack = true,
		close = true,
	},

	["whool"] = {
		label = "Wolle",
		weight = 0,
		stack = true,
		close = true,
	},

	["wood"] = {
		label = "Puu",
		weight = 0,
		stack = true,
		close = true,
	},

	["wool"] = {
		label = "Villa",
		weight = 0,
		stack = true,
		close = true,
	},

	["xpbank"] = {
		label = "XP Bank Card",
		weight = 0,
		stack = true,
		close = true,
	},

	["xpshop"] = {
		label = "XP Shop Card",
		weight = 0,
		stack = true,
		close = true,
	},

	["yakh"] = {
		label = "Yakh",
		weight = 0,
		stack = true,
		close = true,
	},
}