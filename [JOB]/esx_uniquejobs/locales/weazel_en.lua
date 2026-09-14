-- FIX: weazel had no English locale file at all before this - only
-- weazel_fr.lua existed, so every _U() call in client/weazel_main.lua
-- always fell through to essentialmode's "Error [en_weazel][key] Be
-- Developer Elam Konid" fallback, since the server's active locale is
-- 'en' (essentialmode/locale.lua's Config.Locale). Wording below is
-- translated from weazel_fr.lua plus the two missing heli_* keys, copied
-- from the exact same English wording every other job in this resource
-- already uses for them.
Locales['en_weazel'] = Locales['en_weazel'] or {}
for k, v in pairs({

	['cloakroom'] = 'locker room',
	['citizen_wear'] = 'civilian outfit',
	['journaliste_outfit'] = 'trainee outfit',
	['journaliste_outfit_1'] = 'reporter outfit',
	['journaliste_outfit_2'] = 'investigator outfit',
	['journaliste_outfit_3'] = 'director outfit',
	['no_outfit'] = 'there\'s no uniform that fits you!',
	['open_cloackroom'] = 'press ~INPUT_CONTEXT~ to change ~y~clothes~s~.',

	['vehicle_menu'] = 'vehicle',
	['vehicle_out'] = 'there is already a car out of the garage',
	['heli_out'] = 'there is already a heli out of the garage',
	['vehicle_spawner'] = 'press ~INPUT_CONTEXT~ to take out a vehicle',
	['heli_spawner'] = 'press ~INPUT_CONTEXT~ to take out a heli',
	['store_vehicle'] = 'press ~INPUT_CONTEXT~ to store the vehicle',
	['service_max'] = 'service full: ',
	['spawn_point_busy'] = 'a vehicle is occupying the spawn point',

	['deposit_society'] = 'deposit money',
	['withdraw_society'] = 'withdraw company money',
	['boss_actions'] = 'boss actions',

	['invalid_amount'] = '~r~invalid amount',
	['open_menu'] = 'press ~INPUT_CONTEXT~ to open the menu',
	['deposit_amount'] = 'deposit amount',
	['money_withdraw'] = 'withdrawal amount',
	['extra_division'] = 'Extra Division',

	['get_weapon'] = 'withdraw Weapon',
	['put_weapon'] = 'deposit Weapon',
	['get_weapon_menu'] = 'vault - Withdraw Weapon',
	['put_weapon_menu'] = 'vault - Deposit Weapon',
	['get_object'] = 'withdraw Item',
	['put_object'] = 'deposit Item',
	['vault'] = 'vault',
	['open_vault'] = 'press ~INPUT_CONTEXT~ to access the vault',

	['take_company_money'] = 'withdraw Company Money',
	['deposit_money'] = 'deposit Money',
	['amount_of_withdrawal'] = 'amount of Withdrawal',
	['invalid_quantity'] = 'invalid quantity',
	['you_removed'] = 'you removed x',
	['you_added'] = 'you added x',
	['quantity'] = 'quantity',
	['inventory'] = 'inventory',
	['unicorn_stock'] = 'stock',
	['amount_of_deposit'] = 'amount of deposit',
	['open_bossmenu'] = 'press ~INPUT_CONTEXT~ to open the menu',

	['map_blip'] = 'Los Santos Informer',

	['billing'] = 'bill',
	['no_players_nearby'] = 'there is no player(s) nearby!',
	['billing_amount'] = 'bill amount',
	['amount_invalid'] = 'invalid amount',

}) do Locales['en_weazel'][k] = v end
