MI = {}
MI.Phone = {}
MI.Screen = {}
MI.Phone.Functions = {}
MI.Phone.Animations = {}
MI.Phone.Notifications = {}
MI.Phone.LangData = {};
MI.Phone.ContactColors = {
    0: "#9b59b6",
    1: "#3498db",
    2: "#e67e22",
    3: "#e74c3c",
    4: "#1abc9c",
    5: "#9c88ff",
}

MI.Phone.Data = {
    currentApplication: null,
    PlayerData: {},
    Applications: {},
    IsOpen: false,
    CallActive: false,
    MetaData: {},
    PlayerJob: {},
    AnonymousCall: false,
    AnonymousCallfly: false,
}

OpenedChatData = {
    number: null,
}

var CanOpenApp = true;

function IsAppJobBlocked(joblist, myjob) {
    var retval = false;
    if (joblist.length > 0) {
        $.each(joblist, function(i, job){
            if (job == myjob) {
                retval = true;
            }
        });
    }
    return retval;
}

// EXPANSION: `app.job` only ever supported ONE allowed job name. MEOS
// needs to be visible to several (Police, Sheriff, MT, FBI, CID, CIA,
// Marshal, Judge, DOA — see Config.MeosAccessJobs) at once, so this is a
// new, separate check: if `allowedjobs` is set and non-empty, the icon
// only shows for jobs in that list; if unset/empty, everyone can see it
// (same as not having this field at all — existing apps are unaffected).
function IsAppJobAllowed(allowedjobs, myjob) {
    if (!allowedjobs || allowedjobs.length === 0) {
        return true;
    }
    return allowedjobs.indexOf(myjob) !== -1;
}




MI.Phone.Functions.SetupApplications = function(data) {
    MI.Phone.Data.Applications = data.applications;
    $.each(data.applications, function(i, app){
        var applicationSlot = $(".phone-applications").find('[data-appslot="'+app.slot+'"]');
        var blockedapp = IsAppJobBlocked(app.blockedjobs, MI.Phone.Data.PlayerJob.name);
        $(applicationSlot).html("");
        $(applicationSlot).css({"background-color":"transparent"});
        $(applicationSlot).prop('title', "");
        $(applicationSlot).removeData('app');

        if (app.tooltipPos !== undefined) {
            $(applicationSlot).removeData('placement');
        }

        if ((!app.job || app.job === MI.Phone.Data.PlayerJob.name) && !blockedapp && IsAppJobAllowed(app.allowedjobs, MI.Phone.Data.PlayerJob.name)) {
            $(applicationSlot).css({"background-color":app.color});
            var icon = '<i class="ApplicationIcon '+app.icon+'" style="'+app.style+'"></i>';
            $(applicationSlot).html(icon+'<div class="app-unread-alerts">0</div>');

           
            if (app.tooltipText) {
                $(applicationSlot).prop('title', app.tooltipText);
            }

            $(applicationSlot).data('app', app.app);

            if (app.tooltipPos !== undefined) {
                $(applicationSlot).data('placement', app.tooltipPos);
            }
        }
    });

    $('[data-toggle="tooltip"]').tooltip();
}


MI.Phone.Functions.SetupAppWarnings = function(AppData) {
    $.each(AppData, function(i, app){
        var AppObject = $(".phone-applications").find("[data-appslot='"+app.slot+"']").find('.app-unread-alerts');
       
        if (app.Alerts > 0) {
            $(AppObject).html(app.Alerts);
            $(AppObject).css({"display":"block"});
        } else {
            $(AppObject).css({"display":"none"});
        }
    });
}

MI.Phone.Functions.IsAppHeaderAllowed = function(app) {
    var retval = true;
    $.each(Config.HeaderDisabledApps, function(i, blocked){
        if (app == blocked) {
            retval = false;
        }
    });
    return retval;
}

$(document).on('click', '.phone-application', function(e){
    e.preventDefault();
    var PressedApplication = $(this).data('app');
    var AppObject = $("."+PressedApplication+"-app");

    if (AppObject.length !== 0) {
        if (CanOpenApp) {
            if (MI.Phone.Data.currentApplication == null) {
                MI.Phone.Animations.TopSlideDown('.phone-application-container', 300, 0);
                MI.Phone.Functions.ToggleApp(PressedApplication, "block");
                
                if (MI.Phone.Functions.IsAppHeaderAllowed(PressedApplication) && !PressedApplication == 'twitter') {
                    MI.Phone.Functions.HeaderTextColor("black", 300);
                }
    
                MI.Phone.Data.currentApplication = PressedApplication;
    
                if (PressedApplication == "settings") {
                    var rawPhone = MI.Phone.Data.PlayerData.charinfo.phone;
                    $("#myPhoneNumber").text(formatPhoneDisplay(rawPhone)).attr("data-raw", rawPhone);
                } else if (PressedApplication == "twitter") {
                    $.post('http://Unique_Phone/GetMentionedTweets', JSON.stringify({}), function(MentionedTweets){
                        MI.Phone.Notifications.LoadMentionedTweets(MentionedTweets)
                    })
                    $.post('http://Unique_Phone/GetHashtags', JSON.stringify({}), function(Hashtags){
                        MI.Phone.Notifications.LoadHashtags(Hashtags)
                    })
                    $.post('http://Unique_Phone/GetSelfTweets', JSON.stringify({}), function (selfTweets) {
                        MI.Phone.Notifications.LoadSelfTweets(selfTweets)
                    })
                    if (MI.Phone.Data.IsOpen) {
                        $.post('http://Unique_Phone/GetTweets', JSON.stringify({}), function(Tweets){
                            MI.Phone.Notifications.LoadTweets(Tweets);
                        });
                    }
                    
                    MI.Phone.Functions.HeaderTextColor("white", 300);

                    
                } else if (PressedApplication == "bank") {
                    $.post('http://Unique_Phone/GetBankData', JSON.stringify({}), function(data){
                        MI.Phone.Functions.DoBankOpen(data);
                    });
                    $.post('http://Unique_Phone/GetBankContacts', JSON.stringify({}), function(contacts){
                        MI.Phone.Functions.LoadContactsWithNumber(contacts);
                    });
                    $.post('http://Unique_Phone/GetInvoices', JSON.stringify({}), function(invoices){
                        MI.Phone.Functions.LoadBankInvoices(invoices);
                    });
                } else if (PressedApplication == "whatsapp") {
                    $.post('http://Unique_Phone/GetWhatsappChats', JSON.stringify({}), function(chats){
                        MI.Phone.Functions.LoadWhatsappChats(chats);
                    });
                } else if (PressedApplication == "phone") {
                    $.post('http://Unique_Phone/GetMissedCalls', JSON.stringify({}), function(recent){
                        MI.Phone.Functions.SetupRecentCalls(recent);
                    });
                    $.post('http://Unique_Phone/GetSuggestedContacts', JSON.stringify({}), function(suggested){
                        MI.Phone.Functions.SetupSuggestedContacts(suggested);
                    });
                    $.post('http://Unique_Phone/ClearGeneralAlerts', JSON.stringify({
                        app: "phone"
                    }));
                } else if (PressedApplication == "mail") {
                    $.post('http://Unique_Phone/GetMails', JSON.stringify({}), function(mails){
                        MI.Phone.Functions.SetupMails(mails);
                    });
                    $.post('http://Unique_Phone/ClearGeneralAlerts', JSON.stringify({
                        app: "mail"
                    }));
                } else if (PressedApplication == "advert") {
                    $.post('http://Unique_Phone/LoadAdverts', JSON.stringify({}), function(Adverts){
                        MI.Phone.Functions.RefreshAdverts(Adverts);
                    })
                } else if (PressedApplication == "garage") {
                    $.post('http://Unique_Phone/SetupGarageVehicles', JSON.stringify({}), function(Vehicles){
                        SetupGarageVehicles(Vehicles);
                    })
                } else if (PressedApplication == "crypto") {
                    $.post('http://Unique_Phone/GetCryptoData', JSON.stringify({
                        crypto: "qbit",
                    }), function(CryptoData){
                        SetupCryptoData(CryptoData);
                    })

                    $.post('http://Unique_Phone/GetCryptoTransactions', JSON.stringify({}), function(data){
                        RefreshCryptoTransactions(data);
                    })
                } else if (PressedApplication == "racing") {
                    $.post('http://Unique_Phone/GetAvailableRaces', JSON.stringify({}), function(Races){
                        SetupRaces(Races);
                    });
                } else if (PressedApplication == "houses") {
                    $.post('http://Unique_Phone/GetPlayerHouses', JSON.stringify({}), function(Houses){
                        SetupPlayerHouses(Houses);
                    });
                } else if (PressedApplication == "meos") {
                    SetupMeosHome();
                }  else if (PressedApplication == "polices") {
                    $.post('http://Unique_Phone/GetCurrentpolices', JSON.stringify({}), function(data){
                        Setuppolices(data);
                    });
                    jobManagerCheckAccess();
                }else if (PressedApplication == "gallery") {
                    $.post('https://Unique_Phone/GetGalleryData', JSON.stringify({}), function(data){
                        setUpGalleryData(data);
                    });
                }  else if (PressedApplication == "camera") {
                    $.post('https://Unique_Phone/TakePhoto', JSON.stringify({}),function(url){
                        setUpCameraApp(url)
                    })
                    MI.Phone.Functions.Close();
                } else if (PressedApplication == "security") {
                    $.post('http://Unique_Phone/GetSecurityDevices', JSON.stringify({}), function(data){
                        SetupSecurityDevices(data);
                    })
                } else if (PressedApplication == "browser") {
                    if (typeof SetupBrowserApp === "function") { SetupBrowserApp(); }
                }
            }
        }
    } else {
        MI.Phone.Notifications.Add("fas fa-exclamation-circle", MI.Phone.Functions.Lang("NUI_SYSTEM"), MI.Phone.Data.Applications[PressedApplication].tooltipText+" "+MI.Phone.Functions.Lang("NUI_NOT_AVAILABLE"))
    }
    
});

$(document).on('click', '.phone-home-container', function(event){
    event.preventDefault();

    if (MI.Phone.Data.currentApplication === null) {
        MI.Phone.Functions.Close();
    } else {
        MI.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
        MI.Phone.Animations.TopSlideUp('.'+MI.Phone.Data.currentApplication+"-app", 400, -160);
        CanOpenApp = false;
        setTimeout(function(){
            MI.Phone.Functions.ToggleApp(MI.Phone.Data.currentApplication, "none");
            CanOpenApp = true;
        }, 400)
        MI.Phone.Functions.HeaderTextColor("white", 300);

        if (MI.Phone.Data.currentApplication == "whatsapp") {
            if (OpenedChatData.number !== null) {
                setTimeout(function(){
                    $(".whatsapp-chats").css({"display":"block"});
                    $(".whatsapp-chats").animate({
                        left: 0+"vh"
                    }, 1);
                    $(".whatsapp-openedchat").animate({
                        left: -30+"vh"
                    }, 1, function(){
                        $(".whatsapp-openedchat").css({"display":"none"});
                    });
                    OpenedChatPicture = null;
                    OpenedChatData.number = null;
                }, 450);
            }
        } else if (MI.Phone.Data.currentApplication == "bank") {
            if (CurrentTab == "invoices") {
                setTimeout(function(){
                    $(".bank-app-invoices").animate({"left": "30vh"});
                    $(".bank-app-invoices").css({"display":"none"})
                    $(".bank-app-accounts").css({"display":"block"})
                    $(".bank-app-accounts").css({"left": "0vh"});
    
                    var InvoicesObjectBank = $(".bank-app-header").find('[data-headertype="invoices"]');
                    var HomeObjectBank = $(".bank-app-header").find('[data-headertype="accounts"]');
    
                    $(InvoicesObjectBank).removeClass('bank-app-header-button-selected');
                    $(HomeObjectBank).addClass('bank-app-header-button-selected');
    
                    CurrentTab = "accounts";
                }, 400)
            }
        } else if (MI.Phone.Data.currentApplication == "meos") {
            $(".meos-alert-new").remove();
            setTimeout(function(){
                $(".meos-recent-alert").removeClass("noodknop");
                $(".meos-recent-alert").css({"background-color":"#004682"}); 
            }, 400)
        }

        MI.Phone.Data.currentApplication = null;
    }
});

MI.Phone.Functions.Open = function(data) {
    // EXPANSION: show the lock screen fresh every time the phone opens.
    $("#phone-lockscreen").removeClass("lockscreen-hidden");

    // EXPANSION: smoother open — start invisible, then fade in while the
    // existing slide-up runs (double rAF makes sure the browser paints the
    // opacity:0 starting state before we transition it, otherwise the
    // fade can get skipped/batched away).
    $('.container').addClass('phone-fade-out');
    MI.Phone.Animations.BottomSlideUp('.container', 300, 0);
    requestAnimationFrame(function() {
        requestAnimationFrame(function() {
            $('.container').removeClass('phone-fade-out');
        });
    });
    MI.Phone.Notifications.LoadTweets(data.Tweets);
    MI.Phone.Data.IsOpen = true;
}

MI.Phone.Functions.ToggleApp = function(app, show) {
    $("."+app+"-app").css({"display":show});
}

MI.Phone.Functions.Close = function() {

    if (MI.Phone.Data.currentApplication == "whatsapp") {
        setTimeout(function(){
            MI.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
            MI.Phone.Animations.TopSlideUp('.'+MI.Phone.Data.currentApplication+"-app", 400, -160);
            $(".whatsapp-app").css({"display":"none"});
            MI.Phone.Functions.HeaderTextColor("white", 300);
    
            if (OpenedChatData.number !== null) {
                setTimeout(function(){
                    $(".whatsapp-chats").css({"display":"block"});
                    $(".whatsapp-chats").animate({
                        left: 0+"vh"
                    }, 1);
                    $(".whatsapp-openedchat").animate({
                        left: -30+"vh"
                    }, 1, function(){
                        $(".whatsapp-openedchat").css({"display":"none"});
                    });
                    OpenedChatData.number = null;
                }, 450);
            }
            OpenedChatPicture = null;
            MI.Phone.Data.currentApplication = null;
        }, 500)
    } else if (MI.Phone.Data.currentApplication == "meos") {
        $(".meos-alert-new").remove();
        $(".meos-recent-alert").removeClass("noodknop");
        $(".meos-recent-alert").css({"background-color":"#004682"}); 
    }

    // EXPANSION: smoother close — fade out in parallel with the existing
    // slide-down (the slide-down's own callback still hides display:none
    // afterward, so nothing double-fires).
    $('.container').addClass('phone-fade-out');
    MI.Phone.Animations.BottomSlideDown('.container', 300, -70);
    $.post('http://Unique_Phone/Close');
    MI.Phone.Data.IsOpen = false;
    for(let i = 0; i < photos.length; i++){
        photos[i].remove()
    }
     clicked = false;

}

MI.Phone.Functions.HeaderTextColor = function(newColor, Timeout) {
    $(".phone-header").animate({color: newColor}, Timeout);
}

MI.Phone.Animations.BottomSlideUp = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        bottom: Percentage+"%",
    }, Timeout);
}

MI.Phone.Animations.BottomSlideDown = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        bottom: Percentage+"%",
    }, Timeout, function(){
        $(Object).css({'display':'none'});
    });
}

MI.Phone.Animations.TopSlideDown = function(Object, Timeout, Percentage) {
    $(Object).css({'display':'block'}).animate({
        top: Percentage+"%",
    }, Timeout);
}

MI.Phone.Animations.TopSlideUp = function(Object, Timeout, Percentage, cb) {
    $(Object).css({'display':'block'}).animate({
        top: Percentage+"%",
    }, Timeout, function(){
        $(Object).css({'display':'none'});
    });
}

MI.Phone.Notifications.Add = function(icon, title, text, color, timeout) {
    if (PhoneDoNotDisturb) return;
    $.post('http://Unique_Phone/HasPhone', JSON.stringify({}), function(HasPhone){
        if (HasPhone) {
            if (timeout == null && timeout == undefined) {
                timeout = 6000;
            }
            if (MI.Phone.Notifications.Timeout == undefined || MI.Phone.Notifications.Timeout == null) {
                if (color != null || color != undefined) {
                    $(".notification-icon").css({"color":color});
                    $(".notification-title").css({"color":color});
                } else if (color == "default" || color == null || color == undefined) {
                    $(".notification-icon").css({"color":"#e74c3c"});
                    $(".notification-title").css({"color":"#e74c3c"});
                }
                MI.Phone.Animations.TopSlideDown(".phone-notification-container", 200, 8);
                // FIX: was a special-case for icon === "politie" that
                // rendered a missing image file (./img/politie.png,
                // which never existed in this project — a leftover from
                // the original Dutch-language template this phone was
                // based on). meos.js now passes a real Font Awesome class
                // like everything else, so this branch is gone entirely.
                $(".notification-icon").html('<i class="'+icon+'"></i>');
                $(".notification-title").html(title);
                $(".notification-text").html(text);
                if (MI.Phone.Notifications.Timeout !== undefined || MI.Phone.Notifications.Timeout !== null) {
                    clearTimeout(MI.Phone.Notifications.Timeout);
                }
                MI.Phone.Notifications.Timeout = setTimeout(function(){
                    MI.Phone.Animations.TopSlideUp(".phone-notification-container", 200, -8);
                    MI.Phone.Notifications.Timeout = null;
                }, timeout);
            } else {
                if (color != null || color != undefined) {
                    $(".notification-icon").css({"color":color});
                    $(".notification-title").css({"color":color});
                } else {
                    $(".notification-icon").css({"color":"#e74c3c"});
                    $(".notification-title").css({"color":"#e74c3c"});
                }
                $(".notification-icon").html('<i class="'+icon+'"></i>');
                $(".notification-title").html(title);
                $(".notification-text").html(text);
                if (MI.Phone.Notifications.Timeout !== undefined || MI.Phone.Notifications.Timeout !== null) {
                    clearTimeout(MI.Phone.Notifications.Timeout);
                }
                MI.Phone.Notifications.Timeout = setTimeout(function(){
                    MI.Phone.Animations.TopSlideUp(".phone-notification-container", 200, -8);
                    MI.Phone.Notifications.Timeout = null;
                }, timeout);
            }
        }
    });
}

MI.Phone.Functions.LoadPhoneData = function(data) {
    MI.Phone.Data.PlayerData = data.PlayerData;
    MI.Phone.Data.PlayerJob = data.PlayerJob;
    MI.Phone.Data.MetaData = data.PhoneData.MetaData;

    // EXPANSION: appearance option lists (rendered as pickers in Settings —
    // see renderThemeAndCasePickers in settings.js) + persisted one-hand
    // mode preference.
    PhoneThemesConfig = data.phoneThemes || [];
    PhoneCasesConfig = data.phoneCases || [];
    applyOneHandMode(!!data.oneHandMode);
    renderThemeAndCasePickers();

    MI.Phone.Functions.LoadMetaData(data.PhoneData.MetaData);
    MI.Phone.Functions.LoadContacts(data.PhoneData.Contacts);

    // EXPANSION: restore the persisted Do Not Disturb state so the toggle
    // (and actual notification suppression) reflect what the player set
    // last time, instead of always resetting to Off on relog.
    PhoneDoNotDisturb = !!data.doNotDisturb;
    $(".dnd-box").prop("checked", PhoneDoNotDisturb);
    $("#donotdisturb > p").html(PhoneDoNotDisturb ? 'On' : 'Off');
    $(".onehand-box").prop("checked", PhoneOneHandMode);
    $("#onehandmode > p").html(PhoneOneHandMode ? 'On' : 'Off');

    setTimeout(function() {
       
        MI.Phone.Functions.SetupApplications(data);
        
    }, 1000);
   

    $.post('http://Unique_Phone/GetLangData', JSON.stringify({}), function(langs){
        MI.Phone.LangData = langs.table[langs.current];
    });
}

MI.Phone.Functions.Lang = function(item) {    
    if (MI.Phone.LangData[item]) {
        return MI.Phone.LangData[item];
    } else {
        return item;
    }
}

MI.Phone.Functions.UpdateTime = function(data) {    
    var NewDate = new Date();
    
    
    var TehranOffset = 3.5 * 60 * 60 * 1000; 
    var TehranTime = new Date(NewDate.getTime() + TehranOffset);
    
    var NewHour = TehranTime.getUTCHours(); 
    var NewMinute = TehranTime.getUTCMinutes(); 
    
    var Minutessss = NewMinute;
    var Hourssssss = NewHour;
    
    if (NewHour < 10) {
        Hourssssss = "0" + Hourssssss;
    }
    if (NewMinute < 10) {
        Minutessss = "0" + NewMinute;
    }
    
    var MessageTime = Hourssssss + ":" + Minutessss;
    $("#phone-time").html(MessageTime);

    // EXPANSION: mirror the same clock onto the lock screen, and stamp a
    // date alongside it (the date only really needs to change once a
    // day, but re-setting it every tick is cheap and keeps this simple).
    $("#lockscreen-clock").html(MessageTime);
    var weekday = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"][TehranTime.getUTCDay()];
    var monthName = ["January","February","March","April","May","June","July","August","September","October","November","December"][TehranTime.getUTCMonth()];
    $("#lockscreen-date").html(weekday + ", " + monthName + " " + TehranTime.getUTCDate());
}

var NotificationTimeout = null;

// EXPANSION: Do Not Disturb — set from the persisted KVP in LoadPhoneData,
// toggled live from Settings (see settings.js). When true, both
// notification functions below skip showing anything (but MEOS alerts
// still land inside the MEOS app itself — that path never goes through
// either of these, so on-duty officers with DND on won't silently miss a
// dispatch, only the passive slide-down popups for other stuff).
var PhoneDoNotDisturb = false;

// EXPANSION: appearance customization — accent theme, phone case, and
// one-hand mode. Config lists come down once in LoadPhoneData; current
// selections are applied via CSS classes/variables so no per-app CSS file
// had to be touched to support them.
var PhoneThemesConfig = [];
var PhoneCasesConfig = [];
var PhoneOneHandMode = false;

function applyPhoneTheme(themeId) {
    var theme = null;
    $.each(PhoneThemesConfig, function(i, t) { if (t.id === themeId) theme = t; });
    if (!theme) return;
    document.documentElement.style.setProperty('--phone-accent', theme.color);
    $(".theme-swatch").removeClass("theme-swatch-active");
    $(".theme-swatch[data-theme='" + themeId + "']").addClass("theme-swatch-active");
}

function applyPhoneCase(caseId) {
    var phoneCase = null;
    $.each(PhoneCasesConfig, function(i, c) { if (c.id === caseId) phoneCase = c; });

    if (phoneCase && phoneCase.color && phoneCase.color !== "transparent") {
        $(".phone-container").css({
            "border-color": phoneCase.color,
            "border-width": "0.5vh"
        }).addClass("phone-has-case");
    } else {
        // "None" (or unknown) case — remove the inline override so the
        // subtle default glass border (set in the base .phone-container
        // rule) shows through instead of a colored case frame.
        $(".phone-container").css({ "border-color": "", "border-width": "" }).removeClass("phone-has-case");
    }

    $(".case-swatch").removeClass("case-swatch-active");
    $(".case-swatch[data-case='" + caseId + "']").addClass("case-swatch-active");
}

function applyOneHandMode(enabled) {
    PhoneOneHandMode = enabled;
    $(".phone-container").toggleClass("phone-onehand", enabled);
}

// EXPANSION: purely cosmetic display formatter (0911XXXXXXX -> 0911-XXX-XXXX).
// The underlying stored/looked-up value is never touched — see
// copyMyPhoneNumber() for how the raw digits are preserved for copy/paste.
function formatPhoneDisplay(rawPhone) {
    if (!rawPhone) return rawPhone;
    var digits = String(rawPhone).replace(/\D/g, "");
    if (digits.length !== 11) return rawPhone; // unexpected format, show as-is
    return digits.slice(0, 4) + "-" + digits.slice(4, 7) + "-" + digits.slice(7);
}

MI.Screen.Notification = function(title, content, icon, timeout, color) {
    if (PhoneDoNotDisturb) return;
    $.post('http://Unique_Phone/HasPhone', JSON.stringify({}), function(HasPhone){
        if (HasPhone) {
            if (color != null && color != undefined) {
                $(".screen-notifications-container").css({"background-color":color});
            }
            $(".screen-notification-icon").html('<i class="'+icon+'"></i>');
            $(".screen-notification-title").text(title);
            $(".screen-notification-content").text(content);
            $(".screen-notifications-container").css({'display':'block'}).animate({
                right: 5+"vh",
            }, 200);
        
            if (NotificationTimeout != null) {
                clearTimeout(NotificationTimeout);
            }
        
            NotificationTimeout = setTimeout(function(){
                $(".screen-notifications-container").animate({
                    right: -35+"vh",
                }, 200, function(){
                    $(".screen-notifications-container").css({'display':'none'});
                });
                NotificationTimeout = null;
            }, timeout);
        }
    });
}


$(document).ready(function(){
    window.addEventListener('message', function(event) {
        switch(event.data.action) {
            case "open":
                MI.Phone.Functions.Open(event.data);
                MI.Phone.Functions.SetupAppWarnings(event.data.AppData);
                MI.Phone.Functions.SetupCurrentCall(event.data.CallData);
                MI.Phone.Data.IsOpen = true;
                MI.Phone.Data.PlayerData = event.data.PlayerData;
                break;
            case "LoadPhoneData":
                MI.Phone.Functions.LoadPhoneData(event.data);
                break;
            case "UpdateTime":
                MI.Phone.Functions.UpdateTime(event.data);
                break;

            case "updateTest":
                    MI.Phone.Notifications.LoadSelfTweets(event.data.selftTweets)
                    break;
                
            case "updateTweets":
                MI.Phone.Notifications.LoadTweets(event.data.tweets)
                MI.Phone.Notifications.LoadSelfTweets(event.data.selfTweets)

                break;
            case "Notification":
                MI.Screen.Notification(event.data.NotifyData.title, event.data.NotifyData.content, event.data.NotifyData.icon, event.data.NotifyData.timeout, event.data.NotifyData.color);
                break;
            case "PhoneNotification":
                MI.Phone.Notifications.Add(event.data.PhoneNotify.icon, event.data.PhoneNotify.title, event.data.PhoneNotify.text, event.data.PhoneNotify.color, event.data.PhoneNotify.timeout);
                break;
            case "RefreshAppAlerts":
                MI.Phone.Functions.SetupAppWarnings(event.data.AppData);                
                break;
            case "UpdateMentionedTweets":
                MI.Phone.Notifications.LoadMentionedTweets(event.data.Tweets);                
                break;
            case "UpdateBank":
                $(".bank-app-account-balance").html("&euro; "+event.data.NewBalance);
                $(".bank-app-account-balance").data('balance', event.data.NewBalance);
                break;
            case "UpdateChat":
                if (MI.Phone.Data.currentApplication == "whatsapp") {
                    if (OpenedChatData.number !== null && OpenedChatData.number == event.data.chatNumber) {
                      
                        MI.Phone.Functions.SetupChatMessages(event.data.chatData);
                    } else {
                      
                        MI.Phone.Functions.LoadWhatsappChats(event.data.Chats);
                    }
                }
                break;
            case "UpdateHashtags":
                MI.Phone.Notifications.LoadHashtags(event.data.Hashtags);
                break;
            case "RefreshWhatsappAlerts":
                MI.Phone.Functions.ReloadWhatsappAlerts(event.data.Chats);
                break;
            case "CancelOutgoingCall":
                $.post('http://Unique_Phone/HasPhone', JSON.stringify({}), function(HasPhone){
                    if (HasPhone) {
                        CancelOutgoingCall();
                    }
                });
                break;
            case "IncomingCallAlert":
                $.post('http://Unique_Phone/HasPhone', JSON.stringify({}), function(HasPhone){
                    if (HasPhone) {
                        IncomingCallAlert(event.data.CallData, event.data.Canceled, event.data.AnonymousCall);
                    }
                });
                break;
            case "SetupHomeCall":
                MI.Phone.Functions.SetupCurrentCall(event.data.CallData);
                break;
            case "AnswerCall":
                MI.Phone.Functions.AnswerCall(event.data.CallData);
                break;
            case "UpdateCallTime":
                var CallTime = event.data.Time;
                var date = new Date(null);
                date.setSeconds(CallTime);
                var timeString = date.toISOString().substr(11, 8);

                if (!MI.Phone.Data.IsOpen) {
                    if ($(".call-notifications").css("right") !== "52.1px") {
                        $(".call-notifications").css({"display":"block"});
                        $(".call-notifications").animate({right: 5+"vh"});
                    }
                    $(".call-notifications-title").html("In conversation ("+timeString+")");
                    $(".call-notifications-content").html("On the phone with "+event.data.Name);
                    $(".call-notifications").removeClass('call-notifications-shake');
                } else {
                    $(".call-notifications").animate({
                        right: -35+"vh"
                    }, 400, function(){
                        $(".call-notifications").css({"display":"none"});
                    });
                }

                $(".phone-call-ongoing-time").html(timeString);
                $(".phone-currentcall-title").html("In gesprek ("+timeString+")");
                break;
            case "CancelOngoingCall":
                $(".call-notifications").animate({right: -35+"vh"}, function(){
                    $(".call-notifications").css({"display":"none"});
                });
                MI.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                setTimeout(function(){
                    MI.Phone.Functions.ToggleApp("phone-call", "none");
                    $(".phone-application-container").css({"display":"none"});
                }, 400)
                MI.Phone.Functions.HeaderTextColor("white", 300);
    
                MI.Phone.Data.CallActive = false;
                MI.Phone.Data.currentApplication = null;
                break;
            case "RefreshContacts":
                MI.Phone.Functions.LoadContacts(event.data.Contacts);
                break;
            case "UpdateMails":
                MI.Phone.Functions.SetupMails(event.data.Mails);
                break;
            case "RefreshAdverts":
                if (MI.Phone.Data.currentApplication == "advert") {
                    MI.Phone.Functions.RefreshAdverts(event.data.Adverts);
                }
                break;
            case "AddPoliceAlert":
                AddPoliceAlert(event.data)
                break;
            case "UpdateWeather":
                UpdateWeatherWidget(event.data.weather);
                break;
            case "UpdateApplications":
                
                setTimeout(function() {
                    
                    MI.Phone.Data.PlayerJob = event.data.JobData;
                    MI.Phone.Functions.SetupApplications(event.data);
                    
                }, 1000);
                break;
            case "UpdateTransactions":
                RefreshCryptoTransactions(event.data);
                break;
            case "UpdateRacingApp":
                $.post('http://Unique_Phone/GetAvailableRaces', JSON.stringify({}), function(Races){
                    SetupRaces(Races);
                });
                break;
            case "calltojobs":
                
                
                cData = {
                    number: event.data.PhoneNumber,
                    name: event.data.name
                }
                
                
                $.post('http://Unique_Phone/CallContactJobs', JSON.stringify({
                    ContactData: cData,
                    Anonymous: MI.Phone.Data.AnonymousCall,
                    
                }), function(status){

                    MI.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                    MI.Phone.Animations.TopSlideUp('.'+MI.Phone.Data.currentApplication+"-app", 400, -160);

                    setTimeout(function(){

                        if (cData.number !== MI.Phone.Data.PlayerData.charinfo.phone) {
                            if (status.IsOnline) {
                            
                                if (status.CanCall) {
                                    
                                    if (!status.InCall) {
                                        
                                        $(".phone-call-outgoing").css({"display":"block"});
                                        $(".phone-call-incoming").css({"display":"none"});
                                        $(".phone-call-ongoing").css({"display":"none"});
                                        $(".phone-call-outgoing-caller").html(cData.name);
                                        MI.Phone.Functions.HeaderTextColor("white", 400);
                                        MI.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                                        setTimeout(function(){
                                            $(".phone-app").css({"display":"none"});
                                            MI.Phone.Animations.TopSlideDown('.phone-application-container', 400, 0);
                                            MI.Phone.Functions.ToggleApp("phone-call", "block");
                                        }, 450);
                    
                                        CallData.name = cData.name;
                                        CallData.number = cData.number;
                                        
                                    
                                        MI.Phone.Data.currentApplication = "phone-call";
                                    } else {
                                        MI.Phone.Notifications.Add("fas fa-phone-volume", MI.Phone.Functions.Lang("PHONE_TITLE"), MI.Phone.Functions.Lang("PHONE_BUSY"));
                                    }
                                } else {
                                    MI.Phone.Notifications.Add("fas fa-phone-volume", MI.Phone.Functions.Lang("PHONE_TITLE"), MI.Phone.Functions.Lang("PHONE_PERSON_TALKING"));
                                }
                            } else {
                                MI.Phone.Notifications.Add("fas fa-phone-volume", MI.Phone.Functions.Lang("PHONE_TITLE"), MI.Phone.Functions.Lang("PHONE_PERSON_UNAVAILABLE"));
                            }
                        } else {
                            MI.Phone.Notifications.Add("fas fa-phone-volume", MI.Phone.Functions.Lang("PHONE_TITLE"), MI.Phone.Functions.Lang("PHONE_YOUR_NUMBER"));
                        }
                    
                     
                    }, 1500)
                });
                  
            case "calltoAdmin":
                
                
                cData = {
                    number: event.data.PhoneNumber,
                    name: event.data.name,
                    id: event.data.id
                }
                
                $.post('http://Unique_Phone/CallContactAdmins', JSON.stringify({
                    ContactData: cData,
                    Anonymous: MI.Phone.Data.AnonymousCall,
                    
                }), function(status){

                    MI.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                    MI.Phone.Animations.TopSlideUp('.'+MI.Phone.Data.currentApplication+"-app", 400, -160);

                    setTimeout(function(){

                        if (cData.number !== MI.Phone.Data.PlayerData.charinfo.phone) {
                            if (status.IsOnline) {
                            
                                if (status.CanCall) {
                                    
                                    if (!status.InCall) {
                                        
                                        $(".phone-call-outgoing").css({"display":"block"});
                                        $(".phone-call-incoming").css({"display":"none"});
                                        $(".phone-call-ongoing").css({"display":"none"});
                                        $(".phone-call-outgoing-caller").html(cData.name);
                                        MI.Phone.Functions.HeaderTextColor("white", 400);
                                        MI.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                                        setTimeout(function(){
                                            $(".phone-app").css({"display":"none"});
                                            MI.Phone.Animations.TopSlideDown('.phone-application-container', 400, 0);
                                            MI.Phone.Functions.ToggleApp("phone-call", "block");
                                        }, 450);
                    
                                        CallData.name = cData.name;
                                        CallData.number = cData.number;
                                        
                                    
                                        MI.Phone.Data.currentApplication = "phone-call";
                                    } else {
                                        MI.Phone.Notifications.Add("fas fa-phone-volume", MI.Phone.Functions.Lang("PHONE_TITLE"), MI.Phone.Functions.Lang("PHONE_BUSY"));
                                    }
                                } else {
                                    MI.Phone.Notifications.Add("fas fa-phone-volume", MI.Phone.Functions.Lang("PHONE_TITLE"), MI.Phone.Functions.Lang("PHONE_PERSON_TALKING"));
                                }
                            } else {
                                MI.Phone.Notifications.Add("fas fa-phone-volume", MI.Phone.Functions.Lang("PHONE_TITLE"), MI.Phone.Functions.Lang("PHONE_PERSON_UNAVAILABLE"));
                            }
                        } else {
                            MI.Phone.Notifications.Add("fas fa-phone-volume", MI.Phone.Functions.Lang("PHONE_TITLE"), MI.Phone.Functions.Lang("PHONE_YOUR_NUMBER"));
                        }
                    
                     
                    }, 1500)
                });
                  
                    
        }
    })
});



$(document).on('keydown', function(event) { 
    

    switch (event.key) {
        case "Escape": 
            MI.Phone.Functions.Close(); 
            break;
    }
});


copyMyPhoneNumber = () =>{
    var copyText = document.getElementById("myPhoneNumber");

    let elem = document.createElement("textarea");
    let success = false;

    // FIX: this used to copy the DISPLAYED text directly. Now that the
    // display is formatted with dashes for readability (0911-345-6789),
    // copying the displayed text would give people a number that doesn't
    // exactly match what's actually stored/looked-up elsewhere (contacts,
    // calling, search-by-number all compare against the raw digit string).
    // `data-raw` (set alongside the formatted text above) always holds the
    // real, unformatted number, so copy/paste still works everywhere.
    elem.value = copyText.getAttribute("data-raw") || copyText.innerHTML;
    document.body.appendChild(elem);
  
    elem.focus();
    elem.select();
  
    try { success = !!document.execCommand("copy"); }
    catch (err) {}
  
    document.body.removeChild(elem);
  
    MI.Phone.Notifications.Add("fas fa-clipboard", "Copy Phone Number", "Success", "#93BFCF", 5000);
}
// EXPANSION: tap/click anywhere on the lock screen to dismiss it and
// reveal the home screen underneath.
$(document).on('click', '#phone-lockscreen', function() {
    $(this).addClass('lockscreen-hidden');
});

// EXPANSION: weather widget (lock screen) — see client/main.lua, which
// listens for vSync's own broadcast event and forwards it here. No
// changes were made to vSync itself; this only listens to what it
// already announces.
var WEATHER_ICON_MAP = {
    EXTRASUNNY: "fas fa-sun",
    CLEAR:      "fas fa-sun",
    CLEARING:   "fas fa-cloud-sun",
    CLOUDS:     "fas fa-cloud",
    OVERCAST:   "fas fa-cloud",
    RAIN:       "fas fa-cloud-rain",
    THUNDER:    "fas fa-bolt",
    FOGGY:      "fas fa-smog",
    SMOG:       "fas fa-smog",
    SNOW:       "fas fa-snowflake",
    BLIZZARD:   "fas fa-snowflake",
    SNOWLIGHT:  "fas fa-snowflake",
    XMAS:       "fas fa-snowflake",
    HALLOWEEN:  "fas fa-cloud-moon",
};

function UpdateWeatherWidget(weatherType) {
    var icon = WEATHER_ICON_MAP[weatherType] || "fas fa-cloud-sun";
    var label = weatherType ? weatherType.charAt(0) + weatherType.slice(1).toLowerCase() : "Unknown";
    $("#lockscreen-weather-icon").attr("class", icon);
    $("#lockscreen-weather-label").text(label);
    $("#lockscreen-weather").css("display", "flex");
}
