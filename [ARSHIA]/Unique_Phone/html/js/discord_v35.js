// ============================================================================
// Discord v35 — after a correct code, the player chooses their ID (handle).
// Server: discord_v35.lua. Called from Discord_VerifyLoginCode (discord.js).
// ============================================================================

function DXID_Start() {
    var box = $("#discord-login-screen .discord-login-box");
    if (!box.length) return;
    $("#discord-login-step-mailbox, #discord-login-step-code").hide();
    $("#dxid-step").remove();
    box.append('<div id="dxid-step">' +
        '<div class="dxid-help">Choose your ID. This is how people find you, like <b>name</b>#1234.</div>' +
        '<label class="dxid-lbl" for="dxid-input">ID</label>' +
        '<input type="text" id="dxid-input" maxlength="20" autocomplete="off" spellcheck="false" placeholder="e.g. arshia.mtz">' +
        '<div class="dxid-rules">3 to 20 characters: letters, numbers, _ and .</div>' +
        '<div class="dxid-err" id="dxid-err"></div>' +
        '<div class="dxid-btn" id="dxid-go">Continue</div></div>');
    setTimeout(function() { $("#dxid-input").focus(); }, 40);
    // the steps tracker: step 3 is the current one (set after the step observer runs)
    setTimeout(function() {
        $("#dxl-steps .dxl-step").addClass("dxl-on").removeClass("dxl-now");
        $("#dxl-steps .dxl-step[data-step='3']").addClass("dxl-now");
        $("#dxl-steps .dxl-line").addClass("dxl-on");
    }, 60);
}

$(document).on("click", "#dxid-go", function() {
    var v = ($("#dxid-input").val() || "").trim().toLowerCase();
    $("#dxid-err").text("");
    if (!/^[a-z0-9_.]{3,20}$/.test(v)) { $("#dxid-err").text("Use 3 to 20 letters, numbers, _ or ."); return; }
    $("#dxid-go").text("Saving...");
    Discord_Post("DiscordExt_SetHandle", { handle: v }, function(r) {
        $("#dxid-go").text("Continue");
        if (!r || r.error) {
            var msg = { TAKEN: "That ID is already taken. Try another.", BAD_HANDLE: "Use 3 to 20 letters, numbers, _ or .", NOT_LOGGED_IN: "Log in first." };
            $("#dxid-err").text((r && msg[r.error]) || "Could not save the ID.");
            return;
        }
        $("#dxid-step").remove();
        $("#discord-login-screen").removeClass("discord-visible");
        if (window.Discord_LoadServers) Discord_LoadServers();
    });
});
$(document).on("keydown", "#dxid-input", function(e) { if (e.key === "Enter") $("#dxid-go").trigger("click"); });
