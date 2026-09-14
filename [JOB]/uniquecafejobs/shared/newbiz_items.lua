--[[
	The 30 new items for the 5 new business types (bakery/bar/pizza/icecream/sushi),
	confirmed with you. Each one is consumable via a single GENERIC eat/drink
	handler (server/newbiz_items.lua + client/newbiz_items.lua) instead of 30
	hand-written duplicate blocks like the original cafe items - same visual
	result (prop attaches to hand, plays the same idle-drink/eat animation),
	just far less code to maintain. Add a 31st item by adding one line here.
]]

NewBizItems = {
	{ name = 'croissant_kareii', label = 'Croissant Kareii', prop = 'prop_cs_burger_01' },
	{ name = 'non_baget', label = 'Non Baget', prop = 'prop_cs_baguette' },
	{ name = 'keik_shokolat', label = 'Keik Shokolat', prop = 'prop_cs_cake_slice' },
	{ name = 'shirini_khamei', label = 'Shirini Khamei', prop = 'prop_food_cupcake' },
	{ name = 'cookie_shekari', label = 'Cookie Shekari', prop = 'prop_donut_01' },
	{ name = 'roll_darchin', label = 'Roll Darchin', prop = 'prop_cs_burger_01' },
	{ name = 'mocktail_mojito', label = 'Virgin Mojito', prop = 'prop_cs_cocktail' },
	{ name = 'mocktail_pinacolada', label = 'Virgin Pina Colada', prop = 'prop_cs_cocktail' },
	{ name = 'soda_lime', label = 'Soda Lime', prop = 'prop_ecola_can' },
	{ name = 'energy_mix', label = 'Energy Mix', prop = 'prop_ecola_can' },
	{ name = 'fruit_punch', label = 'Fruit Punch', prop = 'prop_cs_cocktail' },
	{ name = 'ice_tea_special', label = 'Ice Tea Special', prop = 'prop_plastic_cup_02' },
	{ name = 'pizza_margherita', label = 'Pizza Margherita', prop = 'prop_pizza_box_01' },
	{ name = 'pizza_pepperoni', label = 'Pizza Pepperoni', prop = 'prop_pizza_box_01' },
	{ name = 'pizza_mushroom', label = 'Pizza Mushroom', prop = 'prop_pizza_box_01' },
	{ name = 'calzone', label = 'Calzone', prop = 'prop_cs_burger_01' },
	{ name = 'garlic_bread', label = 'Garlic Bread', prop = 'prop_cs_baguette' },
	{ name = 'pizza_bbq_chicken', label = 'Pizza BBQ Chicken', prop = 'prop_pizza_box_01' },
	{ name = 'icecream_vanilla_cone', label = 'Icecream Vanilla Cone', prop = 'prop_choc_ice_01' },
	{ name = 'icecream_chocolate_cone', label = 'Icecream Chocolate Cone', prop = 'prop_choc_ice_01' },
	{ name = 'milkshake_strawberry', label = 'Milkshake Strawberry', prop = 'prop_milkshake_cup' },
	{ name = 'sundae_caramel', label = 'Sundae Caramel', prop = 'prop_choc_ice_01' },
	{ name = 'icecream_sandwich', label = 'Icecream Sandwich', prop = 'prop_cs_burger_01' },
	{ name = 'froyo_mango', label = 'Froyo Mango', prop = 'prop_milkshake_cup' },
	{ name = 'sushi_california', label = 'Sushi California', prop = 'prop_cs_dish_02' },
	{ name = 'sushi_salmon_nigiri', label = 'Sushi Salmon Nigiri', prop = 'prop_cs_dish_02' },
	{ name = 'sushi_dragon_roll', label = 'Sushi Dragon Roll', prop = 'prop_cs_dish_02' },
	{ name = 'sushi_spicy_tuna', label = 'Sushi Spicy Tuna', prop = 'prop_cs_dish_02' },
	{ name = 'miso_soup', label = 'Miso Soup', prop = 'prop_food_bowl_01' },
	{ name = 'sushi_veggie_roll', label = 'Sushi Veggie Roll', prop = 'prop_cs_dish_02' },
	{ name = 'premium_wax', label = 'Premium Wax', prop = 'prop_cs_spray_can' },
	{ name = 'interior_cleaner', label = 'Interior Cleaner Kit', prop = 'prop_cleaning_bottle' },
	{ name = 'rim_polish', label = 'Rim Polish', prop = 'prop_cs_spray_can' },
	{ name = 'air_freshener_pine', label = 'Air Freshener Pine', prop = 'prop_air_freshner_01' },
	{ name = 'ceramic_coat', label = 'Ceramic Coat', prop = 'prop_cs_spray_can' },
	{ name = 'tire_shine', label = 'Tire Shine', prop = 'prop_cleaning_bottle' },
}
