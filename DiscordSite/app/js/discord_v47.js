// ============================================================================
// Discord v47 — Security Actions (server menu): Pause Invites.
// While paused for 24 hours nobody new can join with an invite, vanity link,
// Discover or VIP. Members already inside are not affected.
// Server: discord_v47.lua. Shown to the owner, admins and "Manage server".
// ============================================================================

var DXS47 = { until: null };

function DXS47_Build() {
    var ov = $("#discord-modal-overlay");
    if (!ov.length || $("#dxs47-modal").length) return;
    ov.append(
        '<div class="discord-modal" id="dxs47-modal"><div class="discord-modal-title">Security Actions</div>' +
        '<div class="dxs47-text">Quick actions to protect your server from raids and spam.</div>' +
        '<div class="dxs47-card"><div class="dxs47-head"><i class="fas fa-user-lock"></i><b>Pause Invites</b></div>' +
        '<div class="dxs47-sub" id="dxs47-sub">Stop new people from joining through invites for 24 hours. Members already in the server are not affected.</div>' +
        '<div class="dxs47-status" id="dxs47-status"></div>' +
        '<div class="dxs47-btn" id="dxs47-toggle">Pause Invites</div></div>' +
        '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Close</div></div></div>');
}
$(function() { setTimeout(DXS47_Build, 80); });

function DXS47_Fmt(ts) {
    var d = new Date(ts * 1000);
    var two = function(n) { return (n < 10 ? "0" : "") + n; };
    return two(d.getHours()) + ":" + two(d.getMinutes());
}

function DXS47_Render() {
    var paused = !!DXS47.until;
    $("#dxs47-status").text(paused ? "Invites are paused until " + DXS47_Fmt(DXS47.until) + "." : "").toggle(paused);
    $("#dxs47-toggle").text(paused ? "Resume Invites" : "Pause Invites").toggleClass("dxs47-resume", paused);
}

function DXS47_Open() {
    DXS47_Build();
    DXS47.until = null;
    DXS47_Render();
    Discord_OpenModal("dxs47-modal");
    DX_Post("DiscordExt_GetSecurity", { serverId: Discord.currentServerId }, function(r) {
        if (r && !r.error) { DXS47.until = r.invitesPausedUntil || null; DXS47_Render(); }
    });
}

$(document).on("click", "#dxs47-toggle", function() {
    var turnOn = !DXS47.until;
    DX_Post("DiscordExt_SetInvitesPaused", { serverId: Discord.currentServerId, on: turnOn }, function(r) {
        if (!r || r.error) { if (window.DX_Toast) DX_Toast("You need the Manage Server permission.", "error"); return; }
        DXS47.until = r.invitesPausedUntil || null;
        DXS47_Render();
        if (window.DX_Toast) DX_Toast(turnOn ? "Invites paused for 24 hours." : "Invites resumed.", "success");
    });
});

$(document).on("click", ".dxm42-item[data-act='security']", function() {
    if (window.Discord_CloseModals) Discord_CloseModals();
    DXS47_Open();
});
