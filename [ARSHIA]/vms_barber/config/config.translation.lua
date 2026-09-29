-- ▀█▀ █▀▄ ▄▀▄ █▄ █ ▄▀▀ █   ▄▀▄ ▀█▀ ██▀
--  █  █▀▄ █▀█ █ ▀█ ▄██ █▄▄ █▀█  █  █▄▄
Config.Language = 'EN' -- 'EN' / 'CZ' /  'DE' / 'FR' / 'ES' / 'PT' / 'PL'

Config.Translate = {
    ['EN'] = {
        ["blip.barber"] = "Barber",
        
        ["target.barber_chair"] = "Chair",

        ["help.take_a_sit"] = "Press ~INPUT_CONTEXT~ to take a sit",
        ["textui.take_a_sit"] = "[E] Take a sit",

        ["help.open_barber"] = "Press ~INPUT_CONTEXT~ to attend to the customer",
        ["textui.open_barber"] = "[E] Attend to the customer",

        ["help.boss_menu"] = "Press ~INPUT_CONTEXT~ to open boss menu",
        ["textui.boss_menu"] = "[E] Boss Menu",
        ['target.boss_menu'] = "Boss Menu",

        ["help.get_up"] = "Press ~INPUT_VEH_DUCK~ to get up",
        ["textui.get_up"] = "[E] Get up",

        ["notify.paid"] = "You paid %s$ for a service.",
        ["notify.nomoney"] = "You don't have enough money.",
        ["notify.you_started_cutting_customer"] = "You're cutting the customer hair",
        ["notify.started_cutting_hair_by_employee"] = "The hairdresser started cutting you",
        ["notify.dont_have_hair_clipper"] = "You don't have a hair clipper.",
        ['notify.you_sent_bill'] = "You have passed the bill for payment to the customer",
        ['notify.you_are_not_owner'] = "You are not owner of this barber, you can't do it.",

        ['notify.employees:no_players_around'] = "No players around.",
        ['notify.employees:player_is_offline'] = "You can't do it, the player is not available.",
        ['notify.employees:player_is_too_far_away'] = "The player is too far away to be employed",
        ['notify.employees:player_is_already_employed'] = "This player is already an employee at this barber shop.",
        ['notify.employees:player_is_not_employed'] = "This player is not an employee at this barber shop.",
        ['notify.employees:must_be_unemployed'] = "This player is already employed somewhere.",
        ['notify.employees:you_employee_hired'] = "A new employee has been hired!",
        ['notify.employees:awarded_bonus'] = "You awarded a $%s bonus to an employee.",
        ['notify.employees:received_bonus'] = "Received a bonus of $%s from the barber you work at.",
    
        ['notify.balance:withdraw'] = "You withdrew $%s from the company's funds",
        ['notify.balance:deposit'] = "You have deposited $%s into the company safe.",
        ['notify.balance:you_dont_have_that_money'] = "You don't have that much money...",
        ['notify.balance:store_dont_have_that_money'] = "Barber shop doesn't have that much money...",

        ['announcement.cityhall'] = "Cityhall"
    },
    ['CZ'] = {
        ["blip.barber"] = "Holič",

        ["target.barber_chair"] = "Židle",

        ["help.take_a_sit"] = "Stiskněte ~INPUT_CONTEXT~ pro sezení",
        ["textui.take_a_sit"] = "[E] Sednout si",

        ["help.open_barber"] = "Stiskněte ~INPUT_CONTEXT~ pro obsluhu zákazníka",
        ["textui.open_barber"] = "[E] Obsloužit zákazníka",

        ["help.boss_menu"] = "Stiskněte ~INPUT_CONTEXT~ pro otevření menu šéfa",
        ["textui.boss_menu"] = "[E] Menu šéfa",
        ['target.boss_menu'] = "Menu šéfa",

        ["help.get_up"] = "Stiskněte ~INPUT_VEH_DUCK~ pro vstání",
        ["textui.get_up"] = "[E] Vstát",

        ["notify.paid"] = "Zaplatili jste %s$ za službu.",
        ["notify.nomoney"] = "Nemáte dost peněz.",
        ["notify.you_started_cutting_customer"] = "Stříháte zákazníkovi vlasy",
        ["notify.started_cutting_hair_by_employee"] = "Holič začal s vaším stříháním",
        ["notify.dont_have_hair_clipper"] = "Nemáte holičské nůžky.",
        ['notify.you_sent_bill'] = "Poslali jste fakturu k zaplacení zákazníkovi",
        ['notify.you_are_not_owner'] = "Nejste majitel této holičství, nemůžete to udělat.",

        ['notify.employees:no_players_around'] = "Žádní hráči kolem.",
        ['notify.employees:player_is_offline'] = "Nemůžete to udělat, hráč není k dispozici.",
        ['notify.employees:player_is_too_far_away'] = "Hráč je příliš daleko, aby byl zaměstnán",
        ['notify.employees:player_is_already_employed'] = "Tento hráč už je zaměstnán v této holičství.",
        ['notify.employees:player_is_not_employed'] = "Tento hráč není zaměstnán v této holičství.",
        ['notify.employees:must_be_unemployed'] = "Tento hráč už pracuje někde jinde.",
        ['notify.employees:you_employee_hired'] = "Byl zaměstnán nový zaměstnanec!",
        ['notify.employees:awarded_bonus'] = "Udělili jste bonus $%s zaměstnanci.",
        ['notify.employees:received_bonus'] = "Obdrželi jste bonus $%s od holiče, kde pracujete.",

        ['notify.balance:withdraw'] = "Vybrali jste $%s z firemních fondů",
        ['notify.balance:deposit'] = "Vložili jste $%s do trezoru firmy.",
        ['notify.balance:you_dont_have_that_money'] = "Nemáte tolik peněz...",
        ['notify.balance:store_dont_have_that_money'] = "Holičství nemá tolik peněz...",

        ['announcement.cityhall'] = "Radnice"
    },
    ['DE'] = {
        ["blip.barber"] = "Friseur",
        
        ["target.barber_chair"] = "Stuhl",

        ["help.take_a_sit"] = "Drücken Sie ~INPUT_CONTEXT~, um Platz zu nehmen",
        ["textui.take_a_sit"] = "[E] Platz nehmen",

        ["help.open_barber"] = "Drücken Sie ~INPUT_CONTEXT~, um den Kunden zu bedienen",
        ["textui.open_barber"] = "[E] Kunden bedienen",

        ["help.boss_menu"] = "Drücken Sie ~INPUT_CONTEXT~, um das Boss-Menü zu öffnen",
        ["textui.boss_menu"] = "[E] Boss-Menü",
        ['target.boss_menu'] = "Boss-Menü",

        ["help.get_up"] = "Drücken Sie ~INPUT_VEH_DUCK~, um aufzustehen",
        ["textui.get_up"] = "[E] Aufstehen",

        ["notify.paid"] = "Sie haben %s$ für einen Service bezahlt.",
        ["notify.nomoney"] = "Sie haben nicht genug Geld.",
        ["notify.you_started_cutting_customer"] = "Sie schneiden dem Kunden die Haare",
        ["notify.started_cutting_hair_by_employee"] = "Der Friseur hat begonnen, Ihnen die Haare zu schneiden",
        ["notify.dont_have_hair_clipper"] = "Sie haben keinen Haarschneider.",
        ['notify.you_sent_bill'] = "Sie haben dem Kunden die Rechnung zur Zahlung übergeben",
        ['notify.you_are_not_owner'] = "Sie sind nicht der Besitzer dieses Friseurs, Sie können es nicht tun.",

        ['notify.employees:no_players_around'] = "Keine Spieler in der Nähe.",
        ['notify.employees:player_is_offline'] = "Sie können es nicht tun, der Spieler ist nicht verfügbar.",
        ['notify.employees:player_is_too_far_away'] = "Der Spieler ist zu weit entfernt, um angestellt zu werden",
        ['notify.employees:player_is_already_employed'] = "Dieser Spieler ist bereits Angestellter in diesem Friseursalon.",
        ['notify.employees:player_is_not_employed'] = "Dieser Spieler ist kein Angestellter in diesem Friseursalon.",
        ['notify.employees:must_be_unemployed'] = "Dieser Spieler ist bereits irgendwo angestellt.",
        ['notify.employees:you_employee_hired'] = "Ein neuer Angestellter wurde eingestellt!",
        ['notify.employees:awarded_bonus'] = "Sie haben einem Angestellten einen Bonus von $%s gewährt.",
        ['notify.employees:received_bonus'] = "Erhalten Sie einen Bonus von $%s vom Friseur, bei dem Sie arbeiten.",
    
        ['notify.balance:withdraw'] = "Sie haben $%s aus den Firmengeldern abgehoben",
        ['notify.balance:deposit'] = "Sie haben $%s in den Unternehmenssafe eingezahlt.",
        ['notify.balance:you_dont_have_that_money'] = "Sie haben nicht so viel Geld...",
        ['notify.balance:store_dont_have_that_money'] = "Der Friseursalon hat nicht so viel Geld...",

        ['announcement.cityhall'] = "Rathaus"
    },
    ['FR'] = {
        ["blip.barber"] = "Coiffeur",
        
        ["target.barber_chair"] = "Chaise",

        ["help.take_a_sit"] = "Appuyez sur ~INPUT_CONTEXT~ pour vous asseoir",
        ["textui.take_a_sit"] = "[E] S'asseoir",

        ["help.open_barber"] = "Appuyez sur ~INPUT_CONTEXT~ pour accueillir le client",
        ["textui.open_barber"] = "[E] Accueillir le client",

        ["help.boss_menu"] = "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu du patron",
        ["textui.boss_menu"] = "[E] Menu du patron",
        ['target.boss_menu'] = "Menu du patron",

        ["help.get_up"] = "Appuyez sur ~INPUT_VEH_DUCK~ pour vous lever",
        ["textui.get_up"] = "[E] Se lever",

        ["notify.paid"] = "Vous avez payé %s$ pour un service.",
        ["notify.nomoney"] = "Vous n'avez pas assez d'argent.",
        ["notify.you_started_cutting_customer"] = "Vous coupez les cheveux du client",
        ["notify.started_cutting_hair_by_employee"] = "Le coiffeur a commencé à vous couper les cheveux",
        ["notify.dont_have_hair_clipper"] = "Vous n'avez pas de tondeuse à cheveux.",
        ['notify.you_sent_bill'] = "Vous avez envoyé la facture au client pour paiement",
        ['notify.you_are_not_owner'] = "Vous n'êtes pas le propriétaire de ce salon de coiffure, vous ne pouvez pas le faire.",

        ['notify.employees:no_players_around'] = "Aucun joueur autour.",
        ['notify.employees:player_is_offline'] = "Vous ne pouvez pas le faire, le joueur n'est pas disponible.",
        ['notify.employees:player_is_too_far_away'] = "Le joueur est trop loin pour être employé",
        ['notify.employees:player_is_already_employed'] = "Ce joueur est déjà employé dans ce salon de coiffure.",
        ['notify.employees:player_is_not_employed'] = "Ce joueur n'est pas un employé de ce salon de coiffure.",
        ['notify.employees:must_be_unemployed'] = "Ce joueur est déjà employé ailleurs.",
        ['notify.employees:you_employee_hired'] = "Un nouvel employé a été embauché !",
        ['notify.employees:awarded_bonus'] = "Vous avez attribué une prime de %s$ à un employé.",
        ['notify.employees:received_bonus'] = "Vous avez reçu une prime de %s$ du salon de coiffure où vous travaillez.",
    
        ['notify.balance:withdraw'] = "Vous avez retiré %s$ des fonds de l'entreprise",
        ['notify.balance:deposit'] = "Vous avez déposé %s$ dans le coffre de l'entreprise.",
        ['notify.balance:you_dont_have_that_money'] = "Vous n'avez pas autant d'argent...",
        ['notify.balance:store_dont_have_that_money'] = "Le salon de coiffure n'a pas autant d'argent...",

        ['announcement.cityhall'] = "Hôtel de ville"
    },
    ['ES'] = {
        ["blip.barber"] = "Barbero",
        
        ["target.barber_chair"] = "Silla",

        ["help.take_a_sit"] = "Presiona ~INPUT_CONTEXT~ para sentarte",
        ["textui.take_a_sit"] = "[E] Sentarse",

        ["help.open_barber"] = "Presiona ~INPUT_CONTEXT~ para atender al cliente",
        ["textui.open_barber"] = "[E] Atender al cliente",

        ["help.boss_menu"] = "Presiona ~INPUT_CONTEXT~ para abrir el menú del jefe",
        ["textui.boss_menu"] = "[E] Menú del jefe",
        ['target.boss_menu'] = "Menú del jefe",

        ["help.get_up"] = "Presiona ~INPUT_VEH_DUCK~ para levantarte",
        ["textui.get_up"] = "[E] Levantarse",

        ["notify.paid"] = "Has pagado %s$ por un servicio.",
        ["notify.nomoney"] = "No tienes suficiente dinero.",
        ["notify.you_started_cutting_customer"] = "Estás cortando el pelo al cliente",
        ["notify.started_cutting_hair_by_employee"] = "El peluquero empezó a cortarte el pelo",
        ["notify.dont_have_hair_clipper"] = "No tienes una cortadora de pelo.",
        ['notify.you_sent_bill'] = "Has pasado la factura para que el cliente pague",
        ['notify.you_are_not_owner'] = "No eres dueño de esta barbería, no puedes hacerlo.",

        ['notify.employees:no_players_around'] = "No hay jugadores cerca.",
        ['notify.employees:player_is_offline'] = "No puedes hacerlo, el jugador no está disponible.",
        ['notify.employees:player_is_too_far_away'] = "El jugador está demasiado lejos para ser empleado",
        ['notify.employees:player_is_already_employed'] = "Este jugador ya es empleado en esta barbería.",
        ['notify.employees:player_is_not_employed'] = "Este jugador no es empleado en esta barbería.",
        ['notify.employees:must_be_unemployed'] = "Este jugador ya está empleado en otro lugar.",
        ['notify.employees:you_employee_hired'] = "¡Se ha contratado un nuevo empleado!",
        ['notify.employees:awarded_bonus'] = "Has otorgado un bono de $%s a un empleado.",
        ['notify.employees:received_bonus'] = "Has recibido un bono de $%s de la barbería en la que trabajas.",
    
        ['notify.balance:withdraw'] = "Has retirado $%s de los fondos de la empresa",
        ['notify.balance:deposit'] = "Has depositado $%s en la caja fuerte de la empresa.",
        ['notify.balance:you_dont_have_that_money'] = "No tienes tanto dinero...",
        ['notify.balance:store_dont_have_that_money'] = "La barbería no tiene tanto dinero...",
        
        ['announcement.cityhall'] = "Ayuntamiento"
    },
    ['PT'] = {
        ["blip.barber"] = "Barbeiro",
        
        ["target.barber_chair"] = "Cadeira",

        ["help.take_a_sit"] = "Pressione ~INPUT_CONTEXT~ para sentar",
        ["textui.take_a_sit"] = "[E] Sentar",

        ["help.open_barber"] = "Pressione ~INPUT_CONTEXT~ para atender o cliente",
        ["textui.open_barber"] = "[E] Atender o cliente",

        ["help.boss_menu"] = "Pressione ~INPUT_CONTEXT~ para abrir o menu do chefe",
        ["textui.boss_menu"] = "[E] Menu do chefe",
        ['target.boss_menu'] = "Menu do chefe",

        ["help.get_up"] = "Pressione ~INPUT_VEH_DUCK~ para levantar",
        ["textui.get_up"] = "[E] Levantar",

        ["notify.paid"] = "Você pagou %s$ por um serviço.",
        ["notify.nomoney"] = "Você não tem dinheiro suficiente.",
        ["notify.you_started_cutting_customer"] = "Você está cortando o cabelo do cliente",
        ["notify.started_cutting_hair_by_employee"] = "O cabeleireiro começou a cortar seu cabelo",
        ["notify.dont_have_hair_clipper"] = "Você não tem um cortador de cabelo.",
        ['notify.you_sent_bill'] = "Você passou a conta para o cliente pagar",
        ['notify.you_are_not_owner'] = "Você não é proprietário deste barbeiro, você não pode fazer isso.",

        ['notify.employees:no_players_around'] = "Não há jogadores por perto.",
        ['notify.employees:player_is_offline'] = "Você não pode fazer isso, o jogador não está disponível.",
        ['notify.employees:player_is_too_far_away'] = "O jogador está muito longe para ser contratado",
        ['notify.employees:player_is_already_employed'] = "Este jogador já é um funcionário nesta barbearia.",
        ['notify.employees:player_is_not_employed'] = "Este jogador não é um funcionário nesta barbearia.",
        ['notify.employees:must_be_unemployed'] = "Este jogador já está empregado em outro lugar.",
        ['notify.employees:you_employee_hired'] = "Um novo funcionário foi contratado!",
        ['notify.employees:awarded_bonus'] = "Você concedeu um bônus de $%s a um funcionário.",
        ['notify.employees:received_bonus'] = "Recebeu um bônus de $%s da barbearia em que trabalha.",

        ['notify.balance:withdraw'] = "Você retirou $%s dos fundos da empresa",
        ['notify.balance:deposit'] = "Você depositou $%s no cofre da empresa.",
        ['notify.balance:you_dont_have_that_money'] = "Você não tem tanto dinheiro...",
        ['notify.balance:store_dont_have_that_money'] = "A barbearia não tem tanto dinheiro...",

        ['announcement.cityhall'] = "Prefeitura"
    },
    ['PL'] = {
        ["blip.barber"] = "Barber",
        
        ["target.barber_chair"] = "Fotel",

        ["help.take_a_sit"] = "Naciśnij ~INPUT_CONTEXT~ aby zająć miejsce",
        ["textui.take_a_sit"] = "[E] Zajmij miejsce",

        ["help.open_barber"] = "Press ~INPUT_CONTEXT~ to attend to the customer",
        ["textui.open_barber"] = "[E] Attend to the customer",
	
        ["help.boss_menu"] = "Naciśnij ~INPUT_CONTEXT~ aby otworzyć menu",
        ["textui.boss_menu"] = "[E] Menu",
        ['target.boss_menu'] = "Menu",

        ["help.get_up"] = "Naciśnij ~INPUT_VEH_DUCK~ aby wstać",
        ["textui.get_up"] = "[E] Wstań",

        ["notify.paid"] = "Zapłaciłeś %s$ za usługę.",
        ["notify.nomoney"] = "Nie masz wystarczająco pieniędzy.",
        ["notify.you_started_cutting_customer"] = "Obcinasz włosy klientowi",
        ["notify.started_cutting_hair_by_employee"] = "Fryzjer zaczął cię strzyc",
        ["notify.dont_have_hair_clipper"] = "Nie masz maszynki do strzyżenia włosów.",
        ['notify.you_sent_bill'] = "Przekazałeś rachunek do zapłaty klientowi",
        ['notify.you_are_not_owner'] = "Nie jesteś właścicielem tego salonu fryzjerskiego, nie możesz tego zrobić.",

        ['notify.employees:no_players_around'] = "Brak graczy w pobliżu.",
        ['notify.employees:player_is_offline'] = "Nie możesz tego zrobić, gracz nie jest dostępny.",
        ['notify.employees:player_is_too_far_away'] = "Gracz jest zbyt daleko, by go zatrudnić",
        ['notify.employees:player_is_already_employed'] = "Ten gracz jest już pracownikiem tego salonu fryzjerskiego.",
        ['notify.employees:player_is_not_employed'] = "Ten gracz nie jest pracownikiem tego salonu fryzjerskiego.",
        ['notify.employees:must_be_unemployed'] = "Ten gracz jest już gdzieś zatrudniony.",
        ['notify.employees:you_employee_hired'] = "Zatrudniono nowego pracownika!",
        ['notify.employees:awarded_bonus'] = "Przyznałeś pracownikowi premię w wysokości $%s.",
        ['notify.employees:received_bonus'] = "Otrzymałeś premię w wysokości $%s od fryzjera, u którego pracujesz..",
    
        ['notify.balance:withdraw'] = "Wypłaciłeś $% z funduszy firmy",
        ['notify.balance:deposit'] = "Zdeponowałeś $%s w firmowym sejfie.",
        ['notify.balance:you_dont_have_that_money'] = "Nie masz tyle pieniędzy...",
        ['notify.balance:store_dont_have_that_money'] = "Zakład fryzjerski nie ma tyle pieniędzy...",

        ['announcement.cityhall'] = "Urząd Skarbowy"
    }
}

TRANSLATE = function(name, ...)
    if Config.Translate[Config.Language] then
        if ... then
            return Config.Translate[Config.Language][name]:format(...)
        else
            return Config.Translate[Config.Language][name]
        end
    else
        if ... then
            return Config.Translate['EN'][name]:format(...)
        else
            return Config.Translate['EN'][name]
        end
    end
end