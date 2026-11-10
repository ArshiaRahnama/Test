-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

-- English
local Translations = {
    menu = {
        title = "منوی انیمیشن",
        description = "میتوانید از این منو به تمامی انیمیشن ها دسترسی داشته باشید",
        exit = "خروج"
    },
    notifications = {
        request_cancelled = "درخواست لغو شد",
        request_timed_out = "مهلت درخواست به پایان رسید",
        no_players_nearby = "کسی کنار شما نیست",
        no_emote_to_cancel = "انیمیشنی برای کنسل نیست",
        quick_slot_empty = "No anim found on slot %{slot}.",
        waiting_for_a_decision = "منتظر تصمیم هستیم",
        already_playing_anim = "شما درحال حاضر دارید یک انیمیشن اجرا میکنید",
        walk_style_is_set_default = "نوع راه رفتن شما عادی شد",
        just_animals = "Only animal characters can use this animation.",
        expression_reset = "احساسات به حالت پیش فرض بازنشانی شد",
        walk_reset = "نوع راه رفتن به حالت پیش فرض بازنشانی شد"
    },
    categories = {
        all = "کل",
        favorites = "مورد علاقه",
        general = "کاربردی",
        dances = "رقص ها",
        expressions = "احساسات",
        walks = "نوع راه رفتن",
        placedemotes = "مکان خاص",
        syncedemotes = "دو نفره",
        propemotes = "آبجکت دار",
        erpemotes = "سکسی",
        animalemotes = "حیوانات"
    },
    keybinds = {
        toggle_point_description = "Toggles Point",
        ragdoll_description = "Ragdoll",
        play_quick_emote = "Play quick emote"
    },
    animations = {
        smoke = "Press ~y~G~w~ to smoke.",
        vape = "Press ~y~G~w~ to vape.",
        cut = "Press ~y~G~w~ to cut",
        makeitrain = "Press ~y~G~w~ to make it rain.",
        camera = "Press ~y~G~w~ to use camera flash.",
        spraychamp = "Hold ~y~G~w~ to spray champagne",
        useleafblower = "Press ~y~G~w~ to use the leaf blower.",
        poop = "Press ~y~G~w~ to poop",
        puke = "Press ~y~G~w~ to puke",
        firework = "Press ~y~G~w~ to use the firework",
        pee = "Hold ~y~G~w~ to pee."
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})