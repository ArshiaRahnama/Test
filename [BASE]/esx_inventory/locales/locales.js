const TranslationSelected = config.Language;
const Translations = {}

// Translations in French
Translations['fr'] = {
    'inventory': 'Inventaire',

    'use': 'UTILISER',
    'give': 'DONNER',
    'rename': 'RENOMMER',
    'delete': 'SUPPRIMER',

    'accept': 'VALIDER',
    'watch': 'REGARDER',
    'show': 'MONTRER',

    'idcard_name': 'Nom',
    'idcard_dob': 'Naissance',
    'idcard_sex': 'Genre',
    'idcard_height': 'Taille',
    'idcard_signature': 'SIGNATURE',

    'help_interfaces': 'Interface lente: cochez la case \'NUI in-process GPU\' dans les paramètres du launcher Fivem Souris bloquée: changez la méthode d\'entrée dans les paramètres du jeu, catégorie clavier/souris',

    'drop': 'JETER',
    'inspect': 'INSPECTER',
    'sort_weight': 'Poids',
    'sort_name': 'Nom',
    'sort_rank': 'Rareté',
    'sort_category': 'Catégorie',
    'search_placeholder': 'Rechercher',
    'scan': 'SCANNER',
};

// Translations in English
Translations['en'] = {
    'inventory': 'Inventory',

    'use': 'USE',
    'give': 'GIVE',
    'rename': 'RENAME',
    'delete': 'DELETE',

    'accept': 'VALIDATE',
    'watch': 'WATCH',
    'show': 'SHOW',

    'idcard_name': 'Name',
    'idcard_dob': 'Date of Birth',
    'idcard_sex': 'Gender',
    'idcard_height': 'Height',
    'idcard_signature': 'SIGNATURE',

    'help_interfaces': 'Slow interface: Check the \'NUI in-process GPU\' option in the Fivem launcher settings Blocked mouse: Change the input method in the game settings, keyboard/mouse category',

    'drop': 'DROP',
    'inspect': 'INSPECT',
    'sort_weight': 'Weight',
    'sort_name': 'Name',
    'sort_rank': 'Rank',
    'sort_category': 'Category',
    'search_placeholder': 'Search',
    'scan': 'SCAN',
};

// Translations in Spanish
Translations['es'] = {
    'inventory': 'Inventario',

    'use': 'USAR',
    'give': 'DAR',
    'rename': 'RENOMBRAR',
    'delete': 'ELIMINAR',

    'accept': 'VALIDAR',
    'watch': 'VER',
    'show': 'MOSTRAR',

    'idcard_name': 'Nombre',
    'idcard_dob': 'Fecha de Nacimiento',
    'idcard_sex': 'Género',
    'idcard_height': 'Altura',
    'idcard_signature': 'Firma',

    'help_interfaces': 'Interfaz lenta: Marcar la opción "NUI in-process GPU" en la configuración del launcher de Fivem Ratón bloqueado: Cambiar el método de entrada en la configuración del juego, categoría teclado/ratón',

    'drop': 'SOLTAR',
    'inspect': 'INSPECCIONAR',
    'sort_weight': 'Peso',
    'sort_name': 'Nombre',
    'sort_rank': 'Rareza',
    'sort_category': 'Categoría',
    'search_placeholder': 'Buscar',
    'scan': 'ESCANEAR',
};


function _U(a) {
    if (Translations[TranslationSelected] && Translations[TranslationSelected][a]) {
        return Translations[TranslationSelected][a];
    }
    else return 'Translation not found..';
}

