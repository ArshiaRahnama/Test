Locales['en'] = Locales['en'] or {}
for k, v in pairs({

  ['cloakroom'] = 'cloakroom',
  ['citizen_wear'] = 'Civil outfit',
  ['cia_wear'] = 'cia outfit',
  ['bullet_wear'] = 'bullet proof vest',
  ['no_outfit'] = 'there\'s is no uniform at your size...',
  ['open_cloackroom'] = 'press ~INPUT_CONTEXT~ to change ~y~clothes~s~.',


  ['elevator'] = 'elevator',
  ['elevator_top'] = 'go to the offices',
  ['elevator_down'] = 'go to the ground floor',
  ['elevator_parking'] = 'Goto The Heli Park',
  ['open_elevator'] = 'press ~INPUT_CONTEXT~ to take the elevator',


  ['remove_object'] = 'withdraw object',
  ['deposit_object'] = 'deposit object',
  ['get_weapon'] = 'withdraw weapon',
  ['put_weapon'] = 'deposit weapon',
  ['buy_weapons'] = 'buy weapons',
  ['armory'] = 'armory',
  ['open_armory'] = 'press ~INPUT_CONTEXT~ to access the armory',


  ['vehicle_menu'] = 'vehicle',
  ['vehicle_blocked'] = 'there is already a vehicle out',
  ['vehicle_spawner'] = 'press ~INPUT_CONTEXT~ to take out a vehicle',
  ['heli_spawner'] = 'press ~INPUT_CONTEXT~ to take out a heli',
  ['store_vehicle'] = 'press ~INPUT_CONTEXT~ to store the vehicle',

  ['heli_out'] = 'there is already a heli out of the garage',


  ['service_max'] = 'you cannot enter service, max officers in service: %s/%s',
  ['service_not'] = 'you have not entered service! You\'ll have to get changed first.',
  ['service_anonunce'] = 'service information',
  ['service_in'] = 'you\'ve entered service, welcome!',
  ['service_in_announce'] = 'agent ~y~%s~s~ has entered service!',
  ['service_out'] = 'you have left service.',
  ['service_out_announce'] = 'agent ~y~%s~s~ has left their service.',


  ['cia_actions'] = 'cia',
  ['citizen_interaction'] = 'citizen Interaction',
  ['vehicle_interaction'] = 'vehicle Interaction',
  ['object_spawner'] = 'object Spawner',
  ['id_card'] = 'ID Card',
  ['search'] = 'search',
  ['handcuff'] = 'Cuff',
  ['uncuff'] = 'Uncuff',
  ['drag'] = 'escort',
  ['put_in_vehicle'] = 'put in Vehicle',
  ['out_the_vehicle'] = 'drag out from vehicle',
  ['fine'] = 'fine',
  ['unpaid_bills'] = 'manage unpaid bills',
  ['license_check'] = 'manage license',
  ['license_revoke'] = 'revoke license',
  ['license_revoked'] = 'your ~b~%s~s~ has been ~y~revoked~s~!',
  ['licence_you_revoked'] = 'you revoked a ~b~%s~s~ which belonged to ~y~%s~s~',
  ['no_players_nearby'] = 'there is no player(s) nearby!',
  ['being_searched'] = 'you are being ~y~searched~s~ by the ~b~cia~s~',


  ['vehicle_info'] = 'vehicle Info',
  ['pick_lock'] = 'lockpick Vehicle',
  ['vehicle_unlocked'] = 'vehicle ~g~Unlocked~s~',
  ['no_vehicles_nearby'] = 'there is no vehicles nearby',
  ['impound'] = 'impound vehicle',
  ['impound_prompt'] = 'press ~INPUT_CONTEXT~ to cancel the ~y~impound~s~',
  ['impound_canceled'] = 'you canceled the impound',
  ['impound_canceled_moved'] = 'the impound has been canceled because the vehicle moved',
  ['impound_successful'] = 'you have impounded the vehicle',
  ['search_database'] = 'vehicle information',
  ['search_database_title'] = 'vehicle information - search with registration number',
  ['search_database_error_invalid'] = 'that is ~r~not~s~ a ~y~valid~s~ registration number',
  ['search_database_error_not_found'] = 'that ~y~registration number~s~ is ~r~not~s~ registered to an vehicle!',
  ['search_database_found'] = 'the vehicle is ~y~registered~s~ to ~b~%s~s~',


  ['traffic_interaction'] = 'interaction Traffic',
  ['cone'] = 'cone',
  ['barrier'] = 'barrier',
  ['spikestrips'] = 'spikestrips',
  ['box'] = 'box',


  ['name'] = 'name: %s',
  ['job'] = 'job: %s',
  ['sex'] = 'sex: %s',
  ['dob'] = 'DOB: %s',
  ['height'] = 'height: %s',
  ['id'] = 'ID: %s',
  ['bac'] = 'BAC: %s',
  ['unknown'] = 'unknown',
  ['male'] = 'male',
  ['female'] = 'female',


  ['guns_label'] = '--- Guns ---',
  ['inventory_label'] = '--- Inventory ---',
  ['license_label'] = ' --- Licenses ---',
  ['confiscate'] = 'confiscate %s',
  ['confiscate_weapon'] = 'confiscate %s with %s bullets',
  ['confiscate_inv'] = 'confiscate %sx %s',
  ['confiscate_dirty'] = 'confiscate dirty money: <span style="color:red;">$%s</span>',
  ['you_confiscated'] = 'you confiscated ~y~%sx~s~ ~b~%s~s~ from ~b~%s~s~',
  ['got_confiscated'] = '~y~%sx~s~ ~b~%s~s~ were confiscated by ~y~%s~s~',
  ['you_confiscated_account'] = 'you confiscated ~g~$%s~s~ (%s) from ~b~%s~s~',
  ['got_confiscated_account'] = '~g~$%s~s~ (%s) was confiscated by ~y~%s~s~',
  ['you_confiscated_weapon'] = 'you confiscated ~b~%s~s~ from ~b~%s~s~ with ~o~%s~s~ bullets',
  ['got_confiscated_weapon'] = 'your ~b~%s~s~ with ~o~%s~s~ bullets was confiscated by ~y~%s~s~',
  ['traffic_offense'] = 'traffic Offense',
  ['minor_offense'] = 'minor Offense',
  ['average_offense'] = 'average Offense',
  ['major_offense'] = 'major Offense',
  ['fine_total'] = 'fine: %s',


  ['plate'] = 'n°: %s',
  ['owner_unknown'] = 'owner: Unknown',
  ['owner'] = 'owner: %s',


  ['get_weapon_menu'] = 'armory - Withdraw Weapon',
  ['put_weapon_menu'] = 'armory - Deposit Weapon',
  ['buy_weapon_menu'] = 'armory - Buy Guns',
  ['not_enough_money'] = 'you do not have enough money',


  ['take_company_money'] = 'withdraw Company Money',
  ['deposit_money'] = 'deposit Money',
  ['amount_of_withdrawal'] = 'amount of Withdrawal',
  ['invalid_amount'] = 'amount invalid',
  ['amount_of_deposit'] = 'amount of deposit',
  ['open_bossmenu'] = 'press ~INPUT_CONTEXT~ to open the menu',
  ['quantity_invalid'] = 'invalid quantity',
  ['have_withdrawn'] = 'you have withdrawn ~y~%sx~s~ ~b~%s~s~',
  ['have_deposited'] = 'you have deposited ~y~%sx~s~ ~b~%s~s~',
  ['quantity'] = 'quantity',
  ['inventory'] = 'inventory',
  ['cia_stock'] = 'cia Stock',


  ['remove_prop'] = 'press ~INPUT_CONTEXT~ to delete the object',
  ['map_blip'] = 'cia',
  ['unrestrained_timer'] = 'you feel your handcuffs slowly losing grip and fading away.',


  ['alert_cia'] = 'cia alert',
  ['phone_cia'] = 'cia',
}) do Locales['en'][k] = v end
