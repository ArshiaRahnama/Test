// ============================================================================
// Discord v48 — Privacy Settings (server menu): "Allow direct messages from server members".
// If it is off in every server you share with a stranger, they cannot send you a
// message request. Friends and conversations that already exist are not affected.
// Server: discord_v48.lua.
// ============================================================================

function DXP48_Build() {
    var ov = $("#discord-modal-overlay");
    if (!ov.length || $("#dxp48-modal").length) return;
    ov.append(
        '<div class="discord-modal" id="dxp48-modal"><div class="discord-modal-title">Privacy Settings</div>' +
        '<div class="dxp48-server" id="dxp48-server"></div>' +
        '<div class="dxp48-row" id="dxp48-dms"><div class="dxp48-txt"><b>Direct Messages</b>' +
        '<span>Allow direct messages from server members. If you turn this off in every server you share with someone, they cannot send you a message request.</span></div>' +
        '<span class="dxp48-sw"></span></div>' +
        '<div class="dxp48-note">Friends and conversations you already have are not affected.</div>' +
        '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-confirm" data-discordmodalclose="1">Done</div></div></div>');
}
$(function() { setTimeout(DXP48_Build, 80); });

function DXP48_Paint(on) { $("#dxp48-dms").toggleClass("dxp48-on", !!on); }

function DXP48_Open() {
    DXP48_Build();
    var sv = (Discord.servers || []).filter(function(s) { return s.id === Discord.currentServerId; })[0];
    $("#dxp48-server").text(sv ? sv.name : "");
    DXP48_Paint(true);
    Discord_OpenModal("dxp48-modal");
    DX_Post("DiscordExt_GetPrivacy", { serverId: Discord.currentServerId }, function(r) {
        if (r && typeof r.allowDms === "boolean") DXP48_Paint(r.allowDms);
    });
}

$(document).on("click", "#dxp48-dms", function() {
    var turnOn = !$(this).hasClass("dxp48-on");
    DX_Post("DiscordExt_SetPrivacy", { serverId: Discord.currentServerId, allowDms: turnOn }, function(r) {
        if (!r || r.error) { if (window.DX_Toast) DX_Toast("Could not save that.", "error"); return; }
        DXP48_Paint(r.allowDms);
    });
});

$(document).on("click", ".dxm42-item[data-act='privacy']", function() {
    if (window.Discord_CloseModals) Discord_CloseModals();
    DXP48_Open();
});
