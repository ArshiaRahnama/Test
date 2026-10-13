// ============================================================================
// Discord v40 — the "More" button on a profile card opens the same user menu
// as right-clicking a member (Profile, Mention, Add/Message, Block, ...).
// Loaded last.
// ============================================================================

DX_After("Discord_OpenMemberProfile", function(memberId) {
    var tries = 0;
    var t = setInterval(function() {
        tries++;
        var card = $("#discord-modal-profile-view");
        if ((card.length && card.hasClass("discord-modal-active") && card.find("#discord-pv-name").text().trim() !== "") || tries > 15) {
            clearInterval(t);
            var body = card.find(".discord-profile-body");
            body.find(".dxv40-more").remove();
            var m = (DX.meta[Discord.currentServerId] || {})[String(memberId)] || {};
            if (!body.length || !m.uid || (window.DXD && DXD.me && m.uid === DXD.me.uid)) return;
            body.find(".dxv39-actions").append('<div class="dxp34-btn dxv40-more" data-memberid="' + memberId + '" title="More"><i class="fas fa-ellipsis-h"></i></div>');
        }
    }, 80);
});

$(document).on("click", ".dxv40-more", function(e) {
    var id = $(this).attr("data-memberid");
    var name = $("#discord-pv-name").text().trim();
    var r = this.getBoundingClientRect();
    if (window.DXP_UserMenu) DXP_UserMenu(parseInt(id, 10), name, r.left, r.bottom);
    e.stopPropagation();
});
