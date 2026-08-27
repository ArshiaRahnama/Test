// EXPANSION: replaced the old "one section per job" layout (Police,
// Sheriff, Taxi, Ambulance, Mechanic, UwU Cafe, Weazel News as 7 separate
// sections) with 3 broader organizations, each grouping several jobs
// together and listing every online person within it. The click-to-call
// logic further down is untouched — it already routes by the person's
// REAL job (typejob), not by which category they're grouped under here.
var JOB_CATEGORIES = [
    {
        title: "Department Of Justice",
        color: "rgb(90, 60, 140)",
        icon: "fas fa-scale-balanced",
        jobs: ["cid", "cia", "marshal", "fbi", "judge", "doa"]
    },
    {
        title: "Law Enforcement",
        color: "rgb(43, 43, 43)",
        icon: "fas fa-shield-halved",
        jobs: ["police", "sheriff", "mt"]
    },
    {
        title: "Organ Services",
        color: "rgb(0, 150, 120)",
        icon: "fas fa-briefcase-medical",
        jobs: ["taxi", "mechanic", "ambulance", "weazel"]
    }
];

var JOB_ICON_IMAGES = {
    police: "pd.png",
    sheriff: "sh.png",
    taxi: "tx.png",
    mechanic: "mc.png",
    ambulance: "md.png",
    weazel: "wz.png"
};

var JOB_ICON_FALLBACK = {
    fbi: "fa-user-secret",
    cid: "fa-magnifying-glass",
    cia: "fa-user-ninja",
    marshal: "fa-gavel",
    judge: "fa-scale-balanced",
    doa: "fa-file-signature",
    mt: "fa-shield-halved"
};

function jobIconHtml(jobName) {
    if (JOB_ICON_IMAGES[jobName]) {
        return '<img src="./img/jobs/' + JOB_ICON_IMAGES[jobName] + '" alt="' + jobName + '" style="width:100%; height:100%; object-fit:contain;">';
    }
    var icon = JOB_ICON_FALLBACK[jobName] || "fa-briefcase";
    return '<i class="fas ' + icon + '" style="color:#fff; font-size:1.4vh;"></i>';
}

Setuppolices = function(data) {
    $(".polices-list").html("");
    data = data || [];

    var jobToCategory = {};
    $.each(JOB_CATEGORIES, function(i, cat) {
        $.each(cat.jobs, function(j, jobName) {
            jobToCategory[jobName] = cat;
        });
    });

    var grouped = {};
    $.each(JOB_CATEGORIES, function(i, cat) { grouped[cat.title] = []; });
    // Anything with jobs.hasapp = 1 that isn't in one of the 3 categories
    // above (e.g. uwucafe, or any newly-added job) still shows up here
    // instead of silently disappearing.
    var otherEntries = [];

    $.each(data, function(i, police) {
        var cat = jobToCategory[police.typejob];
        if (cat) {
            grouped[cat.title].push(police);
        } else {
            otherEntries.push(police);
        }
    });

    function renderRow(rowId, police, bgColor) {
        var el =
            '<div class="police-list" id="' + rowId + '">' +
                '<div class="police-list-firstletter" style="background-color: ' + bgColor + ';">' + jobIconHtml(police.typejob) + '</div>' +
                '<div class="police-list-fullname">' + police.name + ' <span class="police-list-jobtag">(' + (police.jobLabel || police.typejob) + ')</span></div>' +
                '<div class="police-list-call"><i class="fas fa-phone"></i></div>' +
            '</div>';
        $(".polices-list").append(el);
        $("#" + rowId).data('policeData', police);
    }

    $.each(JOB_CATEGORIES, function(i, cat) {
        var entries = grouped[cat.title];
        $(".polices-list").append(
            '<h1 class="police-section-header" style="background-color: ' + cat.color + ';">'
                + '<span><i class="' + cat.icon + '"></i> ' + cat.title + '</span>'
                + '<span>' + entries.length + '</span></h1>'
        );

        if (entries.length === 0) {
            $(".polices-list").append('<div class="police-list"><div class="no-polices">No one from ' + cat.title + ' is online.</div></div>');
        } else {
            $.each(entries, function(idx, police) {
                renderRow("police-row-" + i + "-" + idx, police, cat.color);
            });
        }
        $(".polices-list").append('<br>');
    });

    if (otherEntries.length > 0) {
        $(".polices-list").append(
            '<h1 class="police-section-header" style="background-color: rgb(80, 90, 110);">'
                + '<span><i class="fas fa-briefcase"></i> Other Services</span>'
                + '<span>' + otherEntries.length + '</span></h1>'
        );
        $.each(otherEntries, function(idx, police) {
            renderRow("police-row-other-" + idx, police, "rgb(80, 90, 110)");
        });
    }
}
var lastRequestTime = 0;
var cooldownTime = 5 * 60 * 1000; 


$(document).on('click', '.police-list-call', function(e) {
    e.preventDefault();

    var policeData = $(this).parent().data('policeData');
    
    var cData = {
        number: policeData.phone,
        name: policeData.name,
        job: policeData.typejob
    };


    if (policeData.typejob === "uwucafe" || policeData.typejob === "weazel") {
 
        $.post('https://Unique_Phone/CallContact', JSON.stringify({
            ContactData: cData,
            Anonymous: MI.Phone.Data.AnonymousCall,
        }), function(status) {
            if (cData.number !== MI.Phone.Data.PlayerData.charinfo.phone) {
                if (status.IsOnline) {
                    if (status.CanCall) {
                        if (!status.InCall) {
                            if (MI.Phone.Data.AnonymousCall) {
                                MI.Phone.Notifications.Add("fas fa-phone", "Phone", "You started an anonymous call!");
                            }
                            $(".phone-call-outgoing").css({"display":"block"});
                            $(".phone-call-incoming").css({"display":"none"});
                            $(".phone-call-ongoing").css({"display":"none"});
                            $(".phone-call-outgoing-caller").html(cData.name);
                            MI.Phone.Functions.HeaderTextColor("white", 400);
                            MI.Phone.Animations.TopSlideUp('.phone-application-container', 400, -160);
                            setTimeout(function() {
                                $(".polices-app").css({"display":"none"});
                                MI.Phone.Animations.TopSlideDown('.phone-application-container', 400, 0);
                                MI.Phone.Functions.ToggleApp("phone-call", "block");
                            }, 450);

                            CallData.name = cData.name;
                            CallData.number = cData.number;
                        
                            MI.Phone.Data.currentApplication = "phone-call";
                        } else {
                            MI.Phone.Notifications.Add("fas fa-phone", "Phone", "You are already connected to a call!");
                        }
                    } else {
                        MI.Phone.Notifications.Add("fas fa-phone", "Phone", "This person is already in a call");
                    }
                } else {
                    MI.Phone.Notifications.Add("fas fa-phone", "Phone", "This person is not available!");
                }
            } else {
                MI.Phone.Notifications.Add("fas fa-phone", "Phone", "You can't call your own number!");
            }
        });
    } else {

        if (policeData.typejob === "mechanic" || policeData.typejob === "taxi") {
            $.post('https://Unique_Phone/Unique_Phone:RequestToJobs', JSON.stringify({
                contactData: policeData.typejob
            }), function(response) {
                
            
                if (response) {
                    if (response) {
                        
                        MI.Phone.Functions.Close(); 
                    }
                }
               
            });
        } else {
            if (Date.now() - lastRequestTime < cooldownTime) {
                var timeLeft = cooldownTime - (Date.now() - lastRequestTime);
                var minutes = Math.floor(timeLeft / 60000); 
                var seconds = Math.ceil((timeLeft % 60000) / 1000); 
                MI.Phone.Notifications.Add(
                    "fas fa-phone", 
                    "Phone", 
                    "Lotfan ( <span style='color:red; font-size:15px; font-weight:bold;'>" + minutes + " : " + seconds + "</span> ) Saniye Sabr Konid"
                );
                
                return;
            } else {
                lastRequestTime = Date.now();
                // FIX: this used to only handle police/sheriff/ambulance —
                // clicking call on any OTHER job (fbi/cid/cia/marshal/judge/
                // doa were already allow-listed server-side before, and any
                // newly-added job now too) fell through and did NOTHING at
                // all. Now anything not already handled above (uwucafe/
                // weazel/mechanic/taxi) gets this same message+location
                // dispatch.
                //
                // IMPORTANT: ChatNumber MUST be built from the real job
                // NAME (policeData.typejob), not the display label —
                // server-side SendJobMessage matches it against
                // xPlayer.job.name after stripping " Deparment" and
                // lowercasing. Using the label here (e.g. "Metropolitan"
                // for job name "mt") would silently never match anyone and
                // the dispatch would go nowhere. jobLabel is only used
                // below for the human-readable notification text.
                var jobNameCapitalized = policeData.typejob.charAt(0).toUpperCase() + policeData.typejob.slice(1);
                var Number = jobNameCapitalized + " Deparment";
                var displayLabel = policeData.jobLabel || jobNameCapitalized;
                var message = "Man Be " + displayLabel + " Niyaz Daram";

                $.post('http://Unique_Phone/SendMessageToJobs', JSON.stringify({
                    ChatNumber: Number,
                    ChatDate: GetCurrentDateKey(),
                    ChatMessage: message,
                    ChatTime: FormatMessageTime(),
                    ChatType: "message",
                }));
        
                $.post('http://Unique_Phone/SendMessageToJobs', JSON.stringify({
                    ChatNumber: Number,
                    ChatDate: GetCurrentDateKey(),
                    ChatMessage: "Shared Location",
                    ChatTime: FormatMessageTime(),
                    ChatType: "location",
                
                }));

                MI.Phone.Notifications.Add("fas fa-user", "Request Sended (" + displayLabel + ") Wait 15m", " ", "#93BFCF", 7000);
            }
        }
    }
});




