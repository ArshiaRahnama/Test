// ============================================================================
// Discord v41 — "Mutual Servers" on the profile card: the servers you share.
// ============================================================================

DX_After("Discord_OpenMemberProfile", function(memberId) {
    var tries = 0;
    var t = setInterval(function() {
        tries++;
        var card = $("#discord-modal-profile-view");
        if ((card.length && card.hasClass("discord-modal-active") && card.find("#discord-pv-name").text().trim() !== "") || tries > 15) {
            clearInterval(t);
            var body = card.find(".discord-profile-body");
            body.find(".dxv41").remove();
            var m = (DX.meta[Discord.currentServerId] || {})[String(memberId)] || {};
            if (!body.length || !m.uid || (window.DXD && DXD.me && m.uid === DXD.me.uid)) return;
            var box = $('<div class="dxv41"><div class="dxv41-title">MUTUAL SERVERS</div><div class="dxv41-list">Loading…</div></div>');
            body.find(".dxv39-actions").before(box);
            DX_Post("DiscordExt_GetMutualServers", { uid: m.uid }, function(list) {
                list = list || [];
                box.find(".dxv41-list").html(list.length ? list.map(function(s) {
                    return '<div class="dxv41-row"><span class="dxv41-ico">' + DX_Esc((s.name || "?").charAt(0).toUpperCase()) + "</span>" + DX_Esc(s.name || "") + "</div>";
                }).join("") : '<div class="dxv41-none">No servers in common.</div>');
            });
        }
    }, 80);
});
