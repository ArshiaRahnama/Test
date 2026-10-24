// ============================================================================
// Discord v44 — the ID row in "My Discord Profile": shows your ID and lets you
// change it (3-20 characters, letters/numbers/_/., unique). Same rules as sign-up.
// ============================================================================

$(function() {
    var box = $("#discord-modal-profile-edit");
    if (!box.length || box.find(".dxv44").length) return;
    box.find(".discord-modal-title").after(
        '<div class="dxv44"><div class="discord-settings-label">ID</div>' +
        '<div class="dxv44-row"><span class="dxv44-id" id="dxv44-id">@\u2026</span>' +
        '<div class="dxv44-btn" id="dxv44-change">Change</div></div>' +
        '<div class="dxv44-edit" id="dxv44-edit" style="display:none">' +
        '<input type="text" id="dxv44-input" maxlength="20" autocomplete="off" spellcheck="false" placeholder="e.g. arshia.mtz">' +
        '<div class="dxv44-save" id="dxv44-save">Save ID</div></div>' +
        '<div class="dxv44-err" id="dxv44-err"></div></div>');
    dxv44Load();
});

function dxv44Load() {
    DX_Post("DiscordExt_GetMyDiscord", {}, function(r) {
        var h = r && r.handle;
        $("#dxv44-id").text(h ? "@" + h : "No ID yet");
        $("#dxv44-input").val(h || "");
    });
}

$(document).on("click", "#dxv44-change", function() {
    $("#dxv44-edit").toggle();
    $("#dxv44-input").focus();
});

$(document).on("click", "#dxv44-save", function() {
    var v = ($("#dxv44-input").val() || "").trim().toLowerCase();
    $("#dxv44-err").text("");
    if (!/^[a-z0-9_.]{3,20}$/.test(v)) { $("#dxv44-err").text("Use 3 to 20 letters, numbers, _ or ."); return; }
    DX_Post("DiscordExt_SetHandle", { handle: v }, function(r) {
        if (!r || r.error) {
            var msg = { TAKEN: "That ID is already taken.", BAD_HANDLE: "Use 3 to 20 letters, numbers, _ or .", NOT_LOGGED_IN: "Log in first." };
            $("#dxv44-err").text((r && msg[r.error]) || "Could not save the ID.");
            return;
        }
        $("#dxv44-edit").hide();
        dxv44Load();
        if (window.DX_Toast) DX_Toast("Your ID was saved.", "success");
    });
});
