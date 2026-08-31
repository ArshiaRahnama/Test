MI.Phone.Settings = {};
MI.Phone.Settings.Background = "background-1";
MI.Phone.Settings.OpenedTab = null;
MI.Phone.Settings.Backgrounds = {
    'background-1': {
        label: "Standard"
    }
};

var PressedBackground = null;
var PressedBackgroundObject = null;
var OldBackground = null;
var IsChecked = null;

$(document).on('click', '.settings-app-tab', function(e){
    e.preventDefault();
    var PressedTab = $(this).data("settingstab");

    if (PressedTab == "background") {
        MI.Phone.Animations.TopSlideDown(".settings-"+PressedTab+"-tab", 200, 0);
        MI.Phone.Settings.OpenedTab = PressedTab;
    } else if (PressedTab == "profilepicture") {
        MI.Phone.Animations.TopSlideDown(".settings-"+PressedTab+"-tab", 200, 0);
        MI.Phone.Settings.OpenedTab = PressedTab;
    } else if (PressedTab == "numberrecognition") {
        var checkBoxes = $(".numberrec-box");
        MI.Phone.Data.AnonymousCall = !checkBoxes.prop("checked");
        checkBoxes.prop("checked", MI.Phone.Data.AnonymousCall);

        if (!MI.Phone.Data.AnonymousCall) {
            $("#numberrecognition > p").html('Off');
        } else {
            $("#numberrecognition > p").html('On');
        }
    } else if (PressedTab == "donotdisturb") {
        // EXPANSION: Do Not Disturb — persisted client-side via a resource
        // KVP (survives relogs/restarts, doesn't need a DB round trip for
        // something this low-stakes). See client/main.lua ToggleDoNotDisturb.
        var dndBoxes = $(".dnd-box");
        PhoneDoNotDisturb = !dndBoxes.prop("checked");
        dndBoxes.prop("checked", PhoneDoNotDisturb);
        $("#donotdisturb > p").html(PhoneDoNotDisturb ? 'On' : 'Off');
        $.post('http://Unique_Phone/ToggleDoNotDisturb', JSON.stringify({ enabled: PhoneDoNotDisturb }));
    } else if (PressedTab == "onehandmode") {
        var oneHandBoxes = $(".onehand-box");
        var enabled = !oneHandBoxes.prop("checked");
        applyOneHandMode(enabled);
        oneHandBoxes.prop("checked", enabled);
        $("#onehandmode > p").html(enabled ? 'On' : 'Off');
        $.post('http://Unique_Phone/ToggleOneHandMode', JSON.stringify({ enabled: enabled }));
    }
});

$(document).on('click', '.settings-app-tabfly', function(e){
    e.preventDefault();
    var PressedTab = $(this).data("settingstab");

    if (PressedTab == "havapyma") {
        var checkBoxesfly = $(".numberrec-boxfly");
        MI.Phone.Data.fly = !checkBoxesfly.prop("checked");
        checkBoxesfly.prop("checked", MI.Phone.Data.fly);



        if (!MI.Phone.Data.fly) {
            $("#havapyma > p").html('Off');
            MI.Phone.Data.AnonymousCallfly = false
            console.log(MI.Phone.Data.AnonymousCallfly)
        } else {
            $("#havapyma > p").html('On');
            MI.Phone.Data.AnonymousCallfly = true
            console.log(MI.Phone.Data.AnonymousCallfly)
        }

        $.post('https://Unique_Phone/SetFlyMode', JSON.stringify({
            toggle:  MI.Phone.Data.AnonymousCallfly,
        }))
    }
});

$(document).on('click', '#accept-background', function(e){
    e.preventDefault();
    var hasCustomBackground = MI.Phone.Functions.IsBackgroundCustom();

    if (hasCustomBackground === false) {
        MI.Phone.Notifications.Add("fas fa-paint-brush", MI.Phone.Functions.Lang("SETTINGS_TITLE"), MI.Phone.Settings.Backgrounds[MI.Phone.Settings.Background].label+" is ingesteld!")
        MI.Phone.Animations.TopSlideUp(".settings-"+MI.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+MI.Phone.Settings.Background+".png')"})
    } else {
        MI.Phone.Notifications.Add("fas fa-paint-brush", MI.Phone.Functions.Lang("SETTINGS_TITLE"), MI.Phone.Functions.Lang("BACKGROUND_SET"))
        MI.Phone.Animations.TopSlideUp(".settings-"+MI.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $(".phone-background").css({"background-image":"url('"+MI.Phone.Settings.Background+"')"});
    }

    $.post('http://Unique_Phone/SetBackground', JSON.stringify({
        background: MI.Phone.Settings.Background,
    }))
});

MI.Phone.Functions.LoadMetaData = function(MetaData) {
    if (MetaData.background !== null && MetaData.background !== undefined) {
        MI.Phone.Settings.Background = MetaData.background;
    } else {
        MI.Phone.Settings.Background = "background-1";
    }

    var hasCustomBackground = MI.Phone.Functions.IsBackgroundCustom();

    if (!hasCustomBackground) {
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+MI.Phone.Settings.Background+".png')"})
    } else {
        $(".phone-background").css({"background-image":"url('"+MI.Phone.Settings.Background+"')"});
    }

    if (MetaData.profilepicture == "default" && MetaData.profilepicture !== null && MetaData.profilepicture !== undefined) {
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="./img/default.png">');
    } else {
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="'+MetaData.profilepicture+'">');
    }

    // EXPANSION: restore saved accent theme + phone case.
    applyPhoneTheme(MetaData.phone_accentcolor || "aqua");
    applyPhoneCase(MetaData.phone_case || "none");
}

$(document).on('click', '#cancel-background', function(e){
    e.preventDefault();
    MI.Phone.Animations.TopSlideUp(".settings-"+MI.Phone.Settings.OpenedTab+"-tab", 200, -100);
});

MI.Phone.Functions.IsBackgroundCustom = function() {
    var retval = true;
    $.each(MI.Phone.Settings.Backgrounds, function(i, background){
        if (MI.Phone.Settings.Background == i) {
            retval = false;
        }
    });
    return retval
}

$(document).on('click', '.background-option', function(e){
    e.preventDefault();
    PressedBackground = $(this).data('background');
    PressedBackgroundObject = this;
    OldBackground = $(this).parent().find('.background-option-current');
    IsChecked = $(this).find('.background-option-current');

    if (IsChecked.length === 0) {
        if (PressedBackground != "custom-background") {
            MI.Phone.Settings.Background = PressedBackground;
            $(OldBackground).fadeOut(50, function(){
                $(OldBackground).remove();
            });
            $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            MI.Phone.Animations.TopSlideDown(".background-custom", 200, 13);
        }
    }
});

$(document).on('click', '#accept-custom-background', function(e){
    e.preventDefault();

    MI.Phone.Settings.Background = $(".custom-background-input").val();
    $(OldBackground).fadeOut(50, function(){
        $(OldBackground).remove();
    });
    $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
    MI.Phone.Animations.TopSlideUp(".background-custom", 200, -23);
});

$(document).on('click', '#cancel-custom-background', function(e){
    e.preventDefault();

    MI.Phone.Animations.TopSlideUp(".background-custom", 200, -23);
});

// Profile Picture

var PressedProfilePicture = null;
var PressedProfilePictureObject = null;
var OldProfilePicture = null;
var ProfilePictureIsChecked = null;

$(document).on('click', '#accept-profilepicture', function(e){
    e.preventDefault();
    var ProfilePicture = MI.Phone.Data.MetaData.profilepicture;
    if (ProfilePicture === "default") {
        MI.Phone.Notifications.Add("fas fa-paint-brush", MI.Phone.Functions.Lang("SETTINGS_TITLE"), MI.Phone.Functions.Lang("POFILE_DEFAULT"))
        MI.Phone.Animations.TopSlideUp(".settings-"+MI.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="./img/default.png">');
    } else {
        MI.Phone.Notifications.Add("fas fa-paint-brush", MI.Phone.Functions.Lang("SETTINGS_TITLE"), MI.Phone.Functions.Lang("PROFILE_SET"))
        MI.Phone.Animations.TopSlideUp(".settings-"+MI.Phone.Settings.OpenedTab+"-tab", 200, -100);
      
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="'+ProfilePicture+'">');
    }
    $.post('http://Unique_Phone/UpdateProfilePicture', JSON.stringify({
        profilepicture: ProfilePicture,
    }));
});

$(document).on('click', '#accept-custom-profilepicture', function(e){
    e.preventDefault();
    MI.Phone.Data.MetaData.profilepicture = $(".custom-profilepicture-input").val();
    $(OldProfilePicture).fadeOut(50, function(){
        $(OldProfilePicture).remove();
    });
    $(PressedProfilePictureObject).append('<div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>');
    MI.Phone.Animations.TopSlideUp(".profilepicture-custom", 200, -23);
});

$(document).on('click', '.profilepicture-option', function(e){
    e.preventDefault();
    PressedProfilePicture = $(this).data('profilepicture');
    PressedProfilePictureObject = this;
    OldProfilePicture = $(this).parent().find('.profilepicture-option-current');
    ProfilePictureIsChecked = $(this).find('.profilepicture-option-current');
    if (ProfilePictureIsChecked.length === 0) {
        if (PressedProfilePicture != "custom-profilepicture") {
            MI.Phone.Data.MetaData.profilepicture = PressedProfilePicture
            $(OldProfilePicture).fadeOut(50, function(){
                $(OldProfilePicture).remove();
            });
            $(PressedProfilePictureObject).append('<div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            MI.Phone.Animations.TopSlideDown(".profilepicture-custom", 200, 13);
        }
    }
});

$(document).on('click', '#cancel-profilepicture', function(e){
    e.preventDefault();
    MI.Phone.Animations.TopSlideUp(".settings-"+MI.Phone.Settings.OpenedTab+"-tab", 200, -100);
});


$(document).on('click', '#cancel-custom-profilepicture', function(e){
    e.preventDefault();
    MI.Phone.Animations.TopSlideUp(".profilepicture-custom", 200, -23);
});
// ─────────────────────────────────────────────────────────
// EXPANSION: accent theme + phone case pickers (Settings app).
// ─────────────────────────────────────────────────────────

function renderThemeAndCasePickers() {
    var themeRow = $("#theme-swatch-row");
    var caseRow = $("#case-swatch-row");
    if (themeRow.length === 0 || caseRow.length === 0) return;

    themeRow.html("");
    $.each(PhoneThemesConfig, function(i, theme) {
        themeRow.append(
            '<div class="theme-swatch" data-theme="' + theme.id + '" title="' + theme.label + '" ' +
                'style="background-color:' + theme.color + ';"></div>'
        );
    });

    caseRow.html("");
    $.each(PhoneCasesConfig, function(i, phoneCase) {
        var priceTag = phoneCase.price > 0 ? '<span class="case-price">$' + phoneCase.price + '</span>' : '';
        caseRow.append(
            '<div class="case-swatch" data-case="' + phoneCase.id + '" data-price="' + (phoneCase.price || 0) + '" title="' + phoneCase.label + '">' +
                '<div class="case-swatch-color" style="background-color:' + phoneCase.color + ';"></div>' +
                '<span class="case-swatch-label">' + phoneCase.label + '</span>' +
                priceTag +
            '</div>'
        );
    });

    // Re-apply active-state highlighting for whatever's currently selected
    // (applyPhoneTheme/applyPhoneCase already ran once in LoadPhoneData
    // before these rows existed, so their "active" class never landed —
    // find the current CSS var/border instead of re-deriving state twice).
    var currentAccent = getComputedStyle(document.documentElement).getPropertyValue('--phone-accent').trim();
    $.each(PhoneThemesConfig, function(i, theme) {
        if (theme.color.toLowerCase() === currentAccent.toLowerCase()) {
            $(".theme-swatch[data-theme='" + theme.id + "']").addClass("theme-swatch-active");
        }
    });
    if ($(".phone-container").hasClass("phone-has-case")) {
        var currentBorder = $(".phone-container").css("border-color");
        $.each(PhoneCasesConfig, function(i, c) {
            // Cheap-but-good-enough match: compare against the swatch's own
            // rendered color via a throwaway element (avoids needing a
            // hex<->rgb conversion helper just for this highlight).
            var probe = $('<div style="display:none;background-color:' + c.color + ';"></div>').appendTo('body');
            var probeColor = probe.css('background-color');
            probe.remove();
            if (probeColor === currentBorder) {
                $(".case-swatch[data-case='" + c.id + "']").addClass("case-swatch-active");
            }
        });
    } else {
        $(".case-swatch[data-case='none']").addClass("case-swatch-active");
    }
}

$(document).on('click', '.theme-swatch', function() {
    var themeId = $(this).data('theme');
    applyPhoneTheme(themeId);
    $.post('http://Unique_Phone/SaveMetaData', JSON.stringify({ column: 'phone_accentcolor', data: themeId }));
});

$(document).on('click', '.case-swatch', function() {
    var caseId = $(this).data('case');
    var price = parseInt($(this).data('price'), 10) || 0;
    var msgEl = $("#case-purchase-msg");
    msgEl.removeClass("case-msg-error case-msg-ok").text("");

    if (price === 0) {
        applyPhoneCase(caseId);
        $.post('http://Unique_Phone/BuyPhoneCase', JSON.stringify({ caseId: caseId }));
        return;
    }

    if (!confirm("خرید این کیس $" + price + " هزینه داره. مطمئنی؟")) return;

    $.post('http://Unique_Phone/BuyPhoneCase', JSON.stringify({ caseId: caseId }), function(result) {
        if (result && result.success) {
            applyPhoneCase(caseId);
            msgEl.addClass("case-msg-ok").text("کیس با موفقیت خریداری و اعمال شد ✅");
        } else if (result && result.reason === "not_enough_money") {
            msgEl.addClass("case-msg-error").text("پول کافی نداری.");
        } else {
            msgEl.addClass("case-msg-error").text("خطایی پیش اومد.");
        }
    });
});
