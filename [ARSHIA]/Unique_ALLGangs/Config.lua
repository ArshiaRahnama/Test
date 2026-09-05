Config = {}
Config.ESX = 'esx:getSharedObject'
Config.inventoryimg  = "nui://lc-inventory/src/html/assets/images" -- item icon path (was IRV-inventory, before that ox_inventory, before that esx_inventoryhud) -- NOTE: not actually referenced anywhere else in this resource right now
Config.permission = 1
-- Percentage cut taken when washing gang dirty money into clean gang
-- money (see server/boss.lua, FMGangsBoss:washMoney). 20 means
-- washing $1000 dirty yields $800 clean.
Config.WashMoneyCutPercent = 20

-------------------------------------------------------------------
-- Vehicles selectable from the gang vehicle/heli/boat spawn points
-- (see client/load.lua, OpenVehicleMenu/OpenHeliMenu/OpenBoatMenu).
-- Uses ESX.Game.SpawnVehicleJobs, the same function the server's own
-- police job (esx_uniquejobs) already uses for its vehicle spawner -
-- add/remove models per category as needed.
-------------------------------------------------------------------
Config.GangVehicles = {
    car  = { 'sultan', 'sultanrs', 'kuruma', 'issi2' },
    heli = { 'maverick', 'buzzard2' },
    boat = { 'jetmax', 'suntrap' },
}

-------------------------------------------------------------------
-- Server-wide gang vest presets, selectable from the Clothes Menu's
-- new "Gang Vest" option (client/load.lua, OpenLockerMenu) - applies
-- ONLY the vest/bulletproof component (esx_skin's bproof_1/bproof_2),
-- leaving the rest of whatever the player is currently wearing
-- untouched. Confirmed this component naming against this server's
-- actual skinchanger resource before using it. bproof_1 = 0 means no
-- vest; the numbers below are placeholders - test in-game and adjust
-- to match how you want each preset to actually look.
-------------------------------------------------------------------
Config.GangVests = {
    { name = 'Light Vest', bproof_1 = 1, bproof_2 = 0 },
    { name = 'Heavy Vest', bproof_1 = 2, bproof_2 = 0 },
}

-------------------------------------------------------------------
-- Items selectable in the "Item Access" rank-access submenu (per-item
-- armory restriction). Enforced server-side via lc-inventory's
-- registerStashAccessCheck hook, wired up in server/Gangs.lua's
-- EnsureArmoryStash. Toggling these in the boss menu now actually
-- locks/unlocks that item for that rank in-game.
-------------------------------------------------------------------
Config.ArmoryItems = {
    'WEAPON_PISTOL', 'WEAPON_COMBATPISTOL', 'WEAPON_SMG', 'WEAPON_MICROSMG',
    'WEAPON_ASSAULTRIFLE', 'WEAPON_CARBINERIFLE', 'WEAPON_PUMPSHOTGUN',
    'ammo-9', 'ammo-rifle', 'ammo-shotgun', 'bandage', 'armour',
}
---
Config.OPENPANELCMD = 'openpanel'
Config.ADDXPCMD = 'addgangxp'
Config.REMOVEXPCMD = 'removegangxp'
----
Config.Skin = 'esx_skin'
Config.skinchanger = 'skinchanger'
Config.SteamWebApiKey = '2E63E55937A74CF716E31D90A420ED57'
Config.DefaultAvatar = "img/gangicon.png"
Config.MenuSkintrigger = 'esx_skin:openRestrictedMenu' 
--- chatMessage event / showNotification event
Config.chatMessage = 'chatMessage'
Config.showNotification = 'esx:showNotification' 
Config.showAdvancedNotification = 'esx:showAdvancedNotification'
---- inventory (armory -> IRV-inventory `stashs` table, see server/Gangs.lua EnsureArmoryStash)
-- Config.OpenInventory / TakeItemEvent / AddItemToInventory are no longer
-- used: the armory now opens through IRV-inventory's own stash UI
-- (client's exported `stash()` function), replacing the old
-- esx_inventoryhud custom NUI flow entirely.
----
Config.TimeToPay = 15 -- min 
----
function IsPlayerCanOpenPanel(source) 
    local xPlayer = ESX.GetPlayerFromId(source) 
    if not xPlayer then
        print('[Unique_ALLGangs] IsPlayerCanOpenPanel: no xPlayer for source ' .. tostring(source) .. ' - denying')
        return false
    end
    local level = tonumber(xPlayer.permission_level)
    print('[Unique_ALLGangs] IsPlayerCanOpenPanel: source=' .. tostring(source) .. ' permission_level=' .. tostring(xPlayer.permission_level) .. ' (Config.permission=' .. tostring(Config.permission) .. ')')
    if level and level >= Config.permission then  
        return true 
    else 
        return false 
    end 
end 
function GetAdminName(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    return xPlayer.name 
end 

function GetAdminRank(source) 
    local xPlayer = ESX.GetPlayerFromId(source)
    local GetRankLabeL = {
        [1] =  'Helper'    , 
        [2] =  'Helper'    , 
        [3] =  'Helper'    , 
        [4] =  'ADMIN'     , 
        [5] =  'ADMIN'     , 
        [6] =  'ADMIN'     , 
        [7] =  'HEADADMIN' , 
        [8] =  'HEADADMIN' , 
        [9] =  'HEADADMIN' , 
        [10] = 'DEVELOPER' , 
        [11] = 'DEVELOPER' , 
        [12] = 'GAMEMASTER' , 
    }
    local RankName = GetRankLabeL[ xPlayer.permission_level ] or 'GAMEMASTER'
    return RankName
end 
function Notifiaction(text)
    ESX.ShowNotification(text)
end 

Config.GangLeveL = {
    [1] = 1000,
    [2] = 2000,
    [3] = 3000,
    [4] = 4000,
    [5] = 5000,
    [6] = 6000,
    [7] = 7000,
    [8] = 8000,
    [9] = 9000,
    [10] = 10000,
}

Config.LevelReward = {
    [1] = 1000,
    [2] = 2000,
    [3] = 3000,
    [4] = 4000,
    [5] = 5000,
    [6] = 6000,
    [7] = 7000,
    [8] = 8000,
    [9] = 9000,
    [10] = 10000,
}

Config.DefaultRanks = {
   {
    Grade = 1, 
    Label = 'Rank 1',
    Name  = 'Rank1'
   },
   {
    Grade = 2, 
    Label = 'Rank 2',
    Name  = 'Rank2'
   },
   {
    Grade = 3, 
    Label = 'Rank 3',
    Name  = 'Rank3'
   },
   {
    Grade = 4, 
    Label = 'Rank 4',
    Name  = 'Rank4'
   },
   {
    Grade = 5, 
    Label = 'Rank 5',
    Name  = 'Rank5'
   },
   {
    Grade = 6, 
    Label = 'Rank 6',
    Name  = 'Rank6'
   },
   {
    Grade = 7, 
    Label = 'Rank 7',
    Name  = 'Rank7'
   },
   {
    Grade = 8, 
    Label = 'Rank 8',
    Name  = 'Rank8'
   },
   {
    Grade = 9, 
    Label = 'Rank 9',
    Name  = 'Rank9'
   },
   {
    Grade = 10, 
    Label = 'Rank 10',
    Name  = 'Rank10'
   },

}
Config.markers = {
  [0] = 0, 
  1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43
}
Config.peds = {
    [0] ='a_m_m_beach_01' ,
    'cs_dreyfuss' ,
    'csb_jackhowitzer' ,
    'g_m_m_chicold_01' ,
    'g_m_y_ballaorig_01' ,
    'g_m_y_ballasout_01' ,
    'g_m_y_famca_01' ,
    'g_m_y_famdnf_01' ,
    'g_m_y_lost_01' ,
    'g_m_y_lost_02' ,
    'g_m_y_salvagoon_01' ,
}
Config.blip = {
    [0] =1,
    8,16,36,38,40,43,47,50,72,84,85,303
}
Config.object = {
    [0] ='imp_prop_impexp_boxpile_01' ,
    'imp_prop_impexp_boxpile_02' ,
    'imp_prop_impexp_boxwood_01' ,
    'prop_box_ammo03a_set2' ,
    'prop_box_wood02a_mws' , 
    'prop_box_wood02a_pu' , 
    'prop_toolchest_04' , 
    'xm_prop_crates_weapon_mix_01a' , 


}
Config.flag = {
    [0] = 'apa_prop_flag_china' , 
    'prop_flag_japan' , 
    'prop_flag_lsservices' , 
}

Config.NeedHandsup = {
    ['Search'] = false,
    ['Cuff'] = false,
}
Config.Animations = {
    ['handsup_anim'] = 'missminuteman_1ig_2',
    ['handsup_anim_dict'] = 'handsup_enter',
    ['dead_anim'] = 'dead',
    ['dead_anim_dict'] = 'dead_a',
}
Config.DefaultEvents = {
    ['Cuff'] = 'For5M:Cuff',
    ['UnCuff'] = 'For5M:UnCuff',
    ['Drag'] = 'For5M:Drag',
    ['PutInVeh'] = 'For5M:PutInVeh',
    ['PutOutVeh'] = 'For5M:PutOutVeh',
    ['LockPick'] = 'For5M:LockPick',
    ['confiscatePlayerItem'] = 'esx:confiscatePlayerItem',
    ['onPlayerDeath'] = 'esx:onPlayerDeath',
    ['playerSpawned'] = 'playerSpawned',
    ['playerLoaded'] = 'esx:playerLoaded',
    ['setGang'] = 'esx:setGang',
    ['DataCard'] = 'esx:getOtherPlayerDataCard',
}
Config.Packs = {
    ['pistolpack'] = {
        --- Name  
        ['WEAPON_APPISTOL'] = { Count = 1 , ammo = 250  } ,
        ['WEAPON_PISTOL'] = { Count = 5 , ammo = 250  } ,
        ['WEAPON_PISTOL50'] = { Count = 3 , ammo = 250  } ,
        ['WEAPON_PISTOL_MK2'] = { Count = 8 , ammo = 250  } ,
        ['WEAPON_SNSPISTOL']= { Count = 10 , ammo = 250  } ,
        ['WEAPON_SNSPISTOL_MK2']= { Count = 5 , ammo = 250  } ,
    } , 
    ['riflepack'] = {
        --- Name  
        ['WEAPON_SNSPISTOL_MK2'] = { Count = 1 , ammo = 250  } ,
        ['WEAPON_ASSAULTRIFLE_MK2'] = { Count = 1 , ammo = 250  } ,
        ['WEAPON_ASSAULTSHOTGUN'] = { Count = 1 , ammo = 250  } ,
        ['WEAPON_ASSAULTSMG'] = { Count = 5 , ammo = 250  } ,
        ['WEAPON_ADVANCEDRIFLE']= { Count = 1 , ammo = 250  } ,
        ['WEAPON_CARBINERIFLE']= { Count = 3 , ammo = 250  } ,
    } , 
    ['moneypack'] =  1000000,  -- > Add To Boss Action
    ['xppack'] =  20000,
    ['itempack'] ={
        ['iron'] = 10 ,
        ['gold'] = 20 ,
    } , 
    ['attchmentpack'] = {
        --- Name   , count
        ['grip'] = 10 ,
        ['clip'] = 20 ,
       
    }, 

}


function getVehicleCategory(vehicle) 
    if not vehicle or vehicle == nil then 
        return "car" 
    end 
    local model = GetEntityModel(vehicle) 
    local modelName = GetDisplayNameFromVehicleModel(model) 
    local class = GetVehicleClass(vehicle) 
    if class == 14 then -- HELICOPTERS 
        return "heli" 
    elseif class == 15 then -- PLANES 
        return "heli" 
    elseif class == 8 then -- BOATS 
        return "boat" 
    else 
        return "car" 
    end 
end 