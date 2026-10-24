// ============================================================================
// Discord v25 — avatar effects: none / ring / glow / pulse / rainbow, chosen in
// Edit profile and shown on every avatar of that person. Loaded last.
// Server: discord_v25.lua; effect data comes from member meta (discord_ext.lua).
// ============================================================================

var DXE = { mine: null };

function DXE_Apply() {
    $("[data-dxe]").removeAttr("data-dxe");
    $.each(DX.meta[Discord.currentServerId] || {}, function(memberRowId, m) {
        var eff = m && m.effect;
        var sel = '.discord-message-avatar[data-authorid="' + memberRowId + '"], .discord-member-avatar';
        if (!eff) return;
        $('.discord-message-avatar[data-authorid="' + memberRowId + '"]').attr("data-dxe", eff);
        $('#discord-members-list .discord-member-item[data-memberrowid="' + memberRowId + '"] .discord-member-avatar').attr("data-dxe", eff);
    });
    if (DXE.mine && DXE.mine !== "none") $("#discord-my-avatar").attr("data-dxe", DXE.mine);
}
DX_After("DX_DecorateAll", DXE_Apply);

// Edit profile: effect choice
DX_After("Discord_OpenProfileEditor", function() {
    var m = $("#discord-modal-profile-edit");
    if (!m.length) return;
    m.find(".dxe-row").remove();
    var opts = [["none", "None"], ["ring", "Ring"], ["glow", "Glow"], ["pulse", "Pulse"], ["rainbow", "Rainbow"]];
    var html = '<div class="dxe-row"><div class="discord-settings-label">Avatar effect</div><div class="dxe-opts">';
    $.each(opts, function(i, o) {
        html += '<div class="dxe-opt' + ((DXE.mine || "none") === o[0] ? " dxe-sel" : "") + '" data-dxe-pick="' + o[0] + '"><span class="dxe-demo" data-dxe="' + o[0] + '"></span>' + o[1] + "</div>";
    });
    m.find(".discord-modal-buttons").before(html + "</div></div>");
});
$(document).on("click", "[data-dxe-pick]", function() {
    var eff = $(this).attr("data-dxe-pick");
    DX_Post("DiscordExt_SetAvatarEffect", { effect: eff }, function(r) {
        if (r && r.ok) {
            DXE.mine = eff === "none" ? null : eff;
            $(".dxe-opt").removeClass("dxe-sel").filter('[data-dxe-pick="' + eff + '"]').addClass("dxe-sel");
            DXE_Apply();
            if (window.DX_Toast) DX_Toast("Avatar effect: " + eff, "success");
        } else if (window.DX_Toast) DX_Toast("Could not change the effect.", "error");
    });
});

// the footer avatar: remember your own effect when the app opens
DX_After("Discord_Init", function() {
    DX_Post("DiscordExt_GetMyDiscord", {}, function(r) { DXE.mine = (r && r.effect) || null; DXE_Apply(); });
});
