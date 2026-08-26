// ─────────────────────────────────────────────────────────
// Job Manager — admin-only, deliberately simple: ONE form that either
// creates a new job or updates an existing one (matched by name). No big
// editable list — keeps this small and low-risk. The actual DB write
// (upsert) happens in Unique_Phone/server/main.lua.
// ─────────────────────────────────────────────────────────

var JobManagerBusy = false;

function jobManagerCheckAccess() {
    $.post('http://Unique_Phone/IsJobManagerAdmin', JSON.stringify({}), function (isAdmin) {
        if (isAdmin) $("#job-manager-gear").show();
    });
}

$(document).on('click', '#job-manager-gear', function (e) {
    e.preventDefault();
    $("#job-manager-overlay").removeClass("hidden");
});

$(document).on('click', '#job-manager-close', function (e) {
    e.preventDefault();
    $("#job-manager-overlay").addClass("hidden");
});

$(document).on('click', '#job-manager-add-btn', function (e) {
    e.preventDefault();
    if (JobManagerBusy) return;

    var name = $("#job-manager-new-name").val().trim().toLowerCase();
    var label = $("#job-manager-new-label").val().trim();
    var hasapp = $("#job-manager-new-hasapp").is(":checked");
    var msgEl = $("#job-manager-add-msg");

    msgEl.removeClass("jm-msg-ok jm-msg-error").text("");

    if (!name || !label) {
        msgEl.addClass("jm-msg-error").text("هر دو فیلد رو پر کن.");
        return;
    }
    if (!/^[a-z0-9_]+$/.test(name)) {
        msgEl.addClass("jm-msg-error").text("نام داخلی فقط انگلیسی و بدون فاصله (مثل: security).");
        return;
    }

    JobManagerBusy = true;
    $("#job-manager-add-btn").addClass("security-disabled");

    $.post('http://Unique_Phone/SaveJob', JSON.stringify({
        name: name,
        label: label,
        hasapp: hasapp
    }), function () {
        JobManagerBusy = false;
        $("#job-manager-add-btn").removeClass("security-disabled");
        msgEl.addClass("jm-msg-ok").text("جاب «" + label + "» ذخیره شد ✅ — اگه از قبل بود، آپدیت شد.");
        $("#job-manager-new-name, #job-manager-new-label").val("");
    });
});
