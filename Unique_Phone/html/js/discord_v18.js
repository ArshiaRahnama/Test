// ============================================================================
// Discord v18 — audit log viewer (owners / managers). Server: discord_v18.lua.
// ============================================================================

function DXA_CanView() {
    var p = (typeof DX2_Perms === "function" && DX2_Perms()) || {};
    return !!(p.manage_channels || p.manage_roles || p.administrator);
}

DX_After("DX_RenderTools", function(info) {
    var body = $("#dx-tools-body");
    if (!info || !body.length || !DXA_CanView()) return;
    body.find(".dxa-entry").remove();
    body.append('<div class="dx-section dxa-entry" data-tab="overview"><h4>Audit log</h4>' +
                '<div class="dxa-muted">Who changed what, and when: moderation, roles, channels, invites and appeals.</div>' +
                '<div class="dx-row" style="margin-top:8px"><div class="dx-btn dx-primary" id="dxa-open">Open audit log</div></div></div>');
    if (window.DXS_ApplySettingsTabs) DXS_ApplySettingsTabs();
});
$(document).on("click", "#dxa-open", function() { DXA_Open(); });

function DXA_Open() {
    if (!Discord.currentServerId) return;
    Discord_OpenModal("dxa-modal-audit");
    $("#dxa-body").html('<div class="dxa-muted">Loading\u2026</div>');
    DX_Post("DiscordExt_GetServerAudit", { serverId: Discord.currentServerId }, function(rows) {
        if (!rows) { $("#dxa-body").html('<div class="dxa-muted">You can\'t view the audit log here.</div>'); return; }
        if (!rows.length) { $("#dxa-body").html('<div class="dxa-muted">No admin actions yet.</div>'); return; }
        var html = '<div class="dxa-table">';
        $.each(rows, function(i, r) {
            html += '<div class="dxa-row"><span class="dxa-time">' + new Date(r.at * 1000).toLocaleString() + '</span>' +
                    '<b>' + DX_Esc(r.actor) + '</b><span class="dxa-action">' + DX_Esc(r.action) + '</span>' +
                    '<span class="dxa-target">' + DX_Esc(r.target || "") + "</span></div>";
        });
        $("#dxa-body").html(html + "</div>");
    });
}

$(function() {
    $("#discord-modal-overlay").append(
        '<div class="discord-modal dx-modal-wide" id="dxa-modal-audit"><div class="discord-modal-title">Audit log</div><div id="dxa-body"></div>' +
        '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Close</div></div></div>');
});
