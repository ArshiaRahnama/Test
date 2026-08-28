// EXPANSION: rows are now one-per-JOB (not one-per-online-PERSON) — a
// growing list of individual player names as the server fills up was
// causing real lag in this app. Now the number of rows is always fixed
// (one per known job), just the count number changes. Clicking a job row
// still dispatches the message+location to EVERY online member of that
// job (SendMessageToJobs already broadcasts to the whole job group
// server-side, not just one person) — nobody stops getting the alert.
var JOB_CATEGORIES = [
    {
        title: "Department Of Justice",
        color: "rgb(90, 60, 140)",
        icon: "fas fa-scale-balanced",
        jobs: [
            { name: "cid", label: "CID" },
            { name: "cia", label: "CIA" },
            { name: "marshal", label: "Marshal" },
            { name: "fbi", label: "FBI" },
            { name: "judge", label: "Judge" },
            { name: "doa", label: "DOA" }
        ]
    },
    {
        title: "Law Enforcement",
        color: "rgb(43, 43, 43)",
        icon: "fas fa-shield-halved",
        jobs: [
            { name: "police", label: "Police" },
            { name: "sheriff", label: "Sheriff" },
            { name: "mt", label: "MT" }
        ]
    },
    {
        title: "Organ Services",
        color: "rgb(0, 150, 120)",
        icon: "fas fa-briefcase-medical",
        jobs: [
            { name: "taxi", label: "Taxi" },
            { name: "mechanic", label: "Mechanic" },
            { name: "ambulance", label: "Medic" },
            { name: "weazel", label: "Weazel" }
        ]
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

    // Count online people + grab a real label per job (from whoever's
    // actually online with that job — falls back to the static label
    // above when nobody is, e.g. jobs.label from the DB).
    var countByJob = {};
    var labelByJob = {};
    var knownJobNames = {};
    $.each(JOB_CATEGORIES, function(i, cat) {
        $.each(cat.jobs, function(j, job) {
            knownJobNames[job.name] = true;
        });
    });

    $.each(data, function(i, police) {
        countByJob[police.typejob] = (countByJob[police.typejob] || 0) + 1;
        if (police.jobLabel) labelByJob[police.typejob] = police.jobLabel;
    });

    function renderJobRow(job, color) {
        var count = countByJob[job.name] || 0;
        var label = labelByJob[job.name] || job.label;
        var rowId = "police-row-" + job.name;

        var el =
            '<div class="police-list" id="' + rowId + '">' +
                '<div class="police-list-firstletter" style="background-color: ' + color + ';">' + jobIconHtml(job.name) + '</div>' +
                '<div class="police-list-fullname">' + label + ' <span class="police-list-jobtag">(' + count + ' online)</span></div>' +
                '<div class="police-list-call"><i class="fas fa-phone"></i></div>' +
            '</div>';
        $(".polices-list").append(el);
        // Representative object for the generic click handler below — it
        // only needs typejob (for routing) and jobLabel (for the
        // notification text), same shape as a real online-person entry.
        $("#" + rowId).data('policeData', { typejob: job.name, jobLabel: label, name: label });
    }

    // EXPANSION: only jobs with someone ACTUALLY online get a row now —
    // no more dimmed/disabled rows for empty jobs cluttering the list.
    $.each(JOB_CATEGORIES, function(i, cat) {
        var onlineJobs = cat.jobs.filter(function(job) { return (countByJob[job.name] || 0) > 0; });
        var totalOnline = 0;
        $.each(onlineJobs, function(j, job) { totalOnline += countByJob[job.name]; });

        $(".polices-list").append(
            '<h1 class="police-section-header" style="background-color: ' + cat.color + ';">'
                + '<span><i class="' + cat.icon + '"></i> ' + cat.title + '</span>'
                + '<span>' + totalOnline + '</span></h1>'
        );

        if (onlineJobs.length === 0) {
            $(".polices-list").append('<div class="police-list-empty-note">No one from ' + cat.title + ' is online.</div>');
        } else {
            $.each(onlineJobs, function(j, job) {
                renderJobRow(job, cat.color);
            });
        }
        $(".polices-list").append('<br>');
    });

    // Anything with jobs.hasapp = 1 that isn't in one of the 3 categories
    // above (e.g. uwucafe, or any newly-added job) still gets its own row
    // here instead of silently disappearing — grouped by job, same as
    // everything else, not by individual person. Already online-only by
    // construction (built straight from `data`, which only contains
    // currently-connected people).
    var otherCounts = {};
    var otherLabels = {};
    $.each(data, function(i, police) {
        if (!knownJobNames[police.typejob]) {
            otherCounts[police.typejob] = (otherCounts[police.typejob] || 0) + 1;
            otherLabels[police.typejob] = police.jobLabel || police.typejob;
        }
    });

    var otherJobNames = Object.keys(otherCounts);
    if (otherJobNames.length > 0) {
        $(".polices-list").append(
            '<h1 class="police-section-header" style="background-color: rgb(80, 90, 110);">'
                + '<span><i class="fas fa-briefcase"></i> Other Services</span>'
                + '<span>' + otherJobNames.length + '</span></h1>'
        );
        $.each(otherJobNames, function(i, jobName) {
            renderJobRow({ name: jobName, label: otherLabels[jobName] }, "rgb(80, 90, 110)");
        });
    }
}
var lastRequestTime = 0;
var cooldownTime = 5 * 60 * 1000; 


$(document).on('click', '.police-list-call', function(e) {
    e.preventDefault();

    var rowEl = $(this).parent();
    var policeData = rowEl.data('policeData');

    // EXPANSION: rows are per-job aggregates now (see Setuppolices) — no
    // individual person/phone number to target. Don't waste a dispatch
    // (and the 15-min cooldown) on a job nobody's currently working.
    if (rowEl.hasClass('police-list-empty')) {
        MI.Phone.Notifications.Add("fas fa-user-slash", "Phone", "No one from " + (policeData.jobLabel || policeData.typejob) + " is online right now.");
        return;
    }

    if (policeData.typejob === "mechanic" || policeData.typejob === "taxi") {
        $.post('https://Unique_Phone/Unique_Phone:RequestToJobs', JSON.stringify({
            contactData: policeData.typejob
        }), function(response) {
            if (response) {
                MI.Phone.Functions.Close();
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
            // FIX: this used to only handle police/sheriff/ambulance, and
            // separately handled uwucafe/weazel with a real 1-to-1 phone
            // call (which needed a specific person's phone number — no
            // longer available now that rows are per-job counts, not
            // individual people). Every job (including uwucafe/weazel)
            // now uses the same message+location dispatch, which already
            // broadcasts to EVERY online member of that job server-side —
            // not just one person.
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
});




