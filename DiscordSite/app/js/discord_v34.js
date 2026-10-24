// ============================================================================
// Discord v34 — profile card like Discord: a Roles section with coloured chips,
// and a Message button for other people. Loaded last.
// ============================================================================

DX_After("Discord_OpenMemberProfile", function(memberId) {
    var tries = 0;
    var t = setInterval(function() {
        tries++;
        var card = $("#discord-modal-profile-view");
        if ((card.length && card.hasClass("discord-modal-active") && card.find("#discord-pv-name").text().trim() !== "") || tries > 15) {
            clearInterval(t);
            card.find(".dxp34").remove();
            var m = (DX.meta[Discord.currentServerId] || {})[String(memberId)] || {};
            var body = card.find(".discord-profile-body");
            if (!body.length) return;
            var html = "";

            var roles = (m.roles || []).filter(function(r) { return r && r.name; });
            if (roles.length) {
                html += '<div class="dxp34 dxp34-sec"><div class="dxp34-title">ROLES</div><div class="dxp34-chips">' +
                        roles.map(function(r) {
                            return '<span class="dxp34-chip"><i style="background:' + DX_Esc(r.color || "#99aab5") + '"></i>' + DX_Esc(r.name) + "</span>";
                        }).join("") + "</div></div>";
            }

            var isSelf = !!(window.DXD && DXD.me && m.uid && m.uid === DXD.me.uid);
            if (!isSelf && m.uid) {
                html += '<div class="dxp34 dxp34-actions"><div class="dxp34-btn dxp34-msg" data-dxp34-msg="' + DX_Esc(String(m.uid)) + '"><i class="fas fa-comment"></i> Message</div></div>';
            }
            if (html) body.append(html);
        }
    }, 80);
});

$(document).on("click", "[data-dxp34-msg]", function() {
    var uid = parseInt($(this).attr("data-dxp34-msg"), 10);
    if (window.Discord_CloseModals) Discord_CloseModals();
    if (window.DXD_OpenDmByUid && uid) DXD_OpenDmByUid(uid);
});
