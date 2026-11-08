// ============================================================================
// Discord v31 — the account ID (uid) on a profile card, with a copy button.
// Like Discord's "Copy User ID". Loaded last.
// ============================================================================

DX_After("Discord_OpenMemberProfile", function(memberId) {
    var tries = 0;
    var t = setInterval(function() {
        tries++;
        var card = $("#discord-modal-profile-view");
        if ((card.length && card.hasClass("discord-modal-active") && card.find("#discord-pv-name").text().trim() !== "") || tries > 15) {
            clearInterval(t);
            card.find(".dxv31-id").remove();
            var m = (DX.meta[Discord.currentServerId] || {})[String(memberId)] || {};
            if (!m.uid) return;
            card.find("#discord-pv-tag").after(
                '<div class="dxv31-id"><span>ID ' + DX_Esc(String(m.uid)) + '</span><span class="dxv31-copy" data-uid="' + DX_Esc(String(m.uid)) + '" title="Copy User ID"><i class="fas fa-copy"></i></span></div>');
        }
    }, 80);
});

$(document).on("click", ".dxv31-copy", function() {
    var uid = $(this).attr("data-uid");
    var tmp = $("<input>").val(uid).appendTo("body").select();
    try { document.execCommand("copy"); } catch (e) {}
    tmp.remove();
    if (window.DX_Toast) DX_Toast("User ID copied.", "success");
});
