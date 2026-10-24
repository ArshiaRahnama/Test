// ============================================================================
// Discord v21 — edit history (click "(edited)"), ban with reason from the
// member popup, and the server ban list with unban. Server: discord_v21.lua.
// ============================================================================

function DXH_CanModerate() {
    var p = (typeof DX2_Perms === "function" && DX2_Perms()) || {};
    return !!(p.manage_channels || p.administrator || p.kick_members);
}

// (3) edit history
$(document).on("click", ".discord-message-edited-tag", function(e) {
    e.stopPropagation();
    var id = parseInt($(this).closest(".discord-message").attr("data-messageid"), 10);
    if (!id) return;
    Discord_OpenModal("dxh-modal-history");
    $("#dxh-body").html('<div class="dxh-muted">Loading\u2026</div>');
    DX_Post("DiscordExt_GetEditHistory", { messageId: id }, function(h) {
        if (!h) { $("#dxh-body").html('<div class="dxh-muted">Could not load the history.</div>'); return; }
        var html = '<div class="dxh-ver dxh-cur"><div class="dxh-label">Current</div><div>' + DX_Esc(h.current) + "</div></div>";
        var list = h.versions || [];
        for (var i = list.length - 1; i >= 0; i--) {
            html += '<div class="dxh-ver"><div class="dxh-label">Before edit \u2022 ' + new Date(list[i].at * 1000).toLocaleString() + '</div><div>' + DX_Esc(list[i].text) + "</div></div>";
        }
        $("#dxh-body").html(html);
    });
});

// (7) ban from the member popup (moderators). The popup body is replaced after the
// server answers, so the box is added whenever the body is rendered.
function DXH_AddBanBox() {
    if (!DXH_CanModerate() || !DX.modTargetId) return;
    var body = $("#dx-mod-body");
    if (!body.length || body.find(".dxh-ban").length) return;
    body.append('<div class="dx-section dxh-ban"><h4>Ban from this server</h4>' +
        '<div class="dxh-muted">The person is removed and cannot join again until unbanned.</div>' +
        '<div class="dxh-row"><input type="text" class="dx-input" id="dxh-ban-reason" maxlength="160" placeholder="Reason (required)" dir="auto">' +
        '<div class="dx-btn dx-danger" id="dxh-ban-go">Ban</div></div></div>');
}
(function() {
    // the popup may be created after this script runs, so watch the page for its body
    if (window.MutationObserver) new MutationObserver(function() { if ($("#dx-mod-body").length) DXH_AddBanBox(); })
        .observe(document.body, { childList: true, subtree: true });
})();
DX_After("DX_LoadMod", function() { setTimeout(DXH_AddBanBox, 0); });

$(document).on("click", "#dxh-ban-go", function() {
    var reason = ($("#dxh-ban-reason").val() || "").trim();
    if (reason.length < 3) { if (window.DX_Toast) DX_Toast("Write a reason (at least 3 characters).", "warn"); return; }
    DX_Post("DiscordExt_BanMember", { serverId: Discord.currentServerId, memberId: DX.modTargetId, reason: reason }, function(r) {
        if (r && r.ok) { if (window.DX_Toast) DX_Toast("Banned.", "success"); Discord_CloseModals(); }
        else if (window.DX_Toast) DX_Toast({ NOT_ALLOWED: "You can't ban this person.", error: "Could not ban." }[r && r.error] || "Could not ban.", "error");
    });
});

// ban list (Server Settings)
DX_After("DX_RenderTools", function(info) {
    var body = $("#dx-tools-body");
    if (!info || !body.length || !DXH_CanModerate()) return;
    body.find(".dxh-bans-entry").remove();
    body.append('<div class="dx-section dxh-bans-entry" data-tab="safety"><h4>Bans</h4><div class="dxh-muted">People banned from this server, with their reason.</div>' +
                '<div class="dx-row" style="margin-top:8px"><div class="dx-btn" id="dxh-open-bans">Open ban list</div></div></div>');
    if (window.DXS_ApplySettingsTabs) DXS_ApplySettingsTabs();
});
$(document).on("click", "#dxh-open-bans", function() {
    Discord_OpenModal("dxh-modal-bans");
    $("#dxh-bans-body").html('<div class="dxh-muted">Loading\u2026</div>');
    DX_Post("DiscordExt_GetServerBans", { serverId: Discord.currentServerId }, function(list) {
        if (!list) { $("#dxh-bans-body").html('<div class="dxh-muted">You can\'t see the ban list here.</div>'); return; }
        if (!list.length) { $("#dxh-bans-body").html('<div class="dxh-muted">Nobody is banned.</div>'); return; }
        $("#dxh-bans-body").html(list.map(function(b) {
            return '<div class="dxh-ban-row"><div><b>' + DX_Esc(b.name || "Member") + '</b> <span class="dxh-muted">by ' + DX_Esc(b.by) + " \u2022 " + new Date(b.at * 1000).toLocaleDateString() + "</span>" +
                   '<div class="dxh-reason">' + DX_Esc(b.reason || "No reason") + '</div></div>' +
                   '<div class="dx-btn" data-unban="' + DX_Esc(b.identifier) + '">Unban</div></div>';
        }).join(""));
    });
});
$(document).on("click", "[data-unban]", function() {
    DX_Post("DiscordExt_UnbanMember", { serverId: Discord.currentServerId, identifier: $(this).attr("data-unban") }, function(r) {
        if (r && r.ok) { if (window.DX_Toast) DX_Toast("Unbanned.", "success"); $("#dxh-open-bans").trigger("click"); }
    });
});

$(function() {
    $("#discord-modal-overlay").append(
        '<div class="discord-modal dx-modal-wide" id="dxh-modal-history"><div class="discord-modal-title">Edit history</div><div id="dxh-body"></div>' +
        '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Close</div></div></div>' +
        '<div class="discord-modal dx-modal-wide" id="dxh-modal-bans"><div class="discord-modal-title">Ban list</div><div id="dxh-bans-body"></div>' +
        '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Close</div></div></div>');
});
