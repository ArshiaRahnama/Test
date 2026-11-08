// ============================================================================
// Discord v39 — profile card buttons for other people, like Discord:
//   friend -> Message; no relation -> Add Friend; they asked you -> Accept;
//   request sent -> Request Sent (disabled); blocked -> Unblock.
// Replaces the single Message button of v34. Loaded last.
// ============================================================================

DX_After("Discord_OpenMemberProfile", function(memberId) {
    var tries = 0;
    var t = setInterval(function() {
        tries++;
        var card = $("#discord-modal-profile-view");
        if ((card.length && card.hasClass("discord-modal-active") && card.find("#discord-pv-name").text().trim() !== "") || tries > 15) {
            clearInterval(t);
            var m = (DX.meta[Discord.currentServerId] || {})[String(memberId)] || {};
            var body = card.find(".discord-profile-body");
            body.find(".dxp34-actions, .dxv39-actions").remove();
            if (!body.length || !m.uid) return;
            if (window.DXD && DXD.me && m.uid === DXD.me.uid) return;   // not for yourself
            var rel = (window.DXD_RelationOf) ? DXD_RelationOf(m.uid) : "none";
            var btn = "";
            if (rel === "friend")        btn = '<div class="dxp34-btn" data-v39="message"><i class="fas fa-comment"></i> Message</div>';
            else if (rel === "incoming") btn = '<div class="dxp34-btn" data-v39="accept"><i class="fas fa-user-check"></i> Accept Friend Request</div>';
            else if (rel === "outgoing") btn = '<div class="dxp34-btn dxv39-off">Friend Request Sent</div>';
            else if (rel === "blocked")  btn = '<div class="dxp34-btn" data-v39="unblock"><i class="fas fa-unlock"></i> Unblock</div>';
            else                         btn = '<div class="dxp34-btn" data-v39="add"><i class="fas fa-user-plus"></i> Add Friend</div>';
            body.append('<div class="dxv39-actions" data-uid="' + m.uid + '">' + btn + "</div>");
        }
    }, 80);
});

$(document).on("click", ".dxv39-actions [data-v39]", function() {
    var uid = parseInt($(this).closest(".dxv39-actions").attr("data-uid"), 10);
    var act = $(this).attr("data-v39");
    if (act === "message") { if (window.Discord_CloseModals) Discord_CloseModals(); if (window.DXD_OpenDmByUid) DXD_OpenDmByUid(uid); return; }
    if (act === "accept")  { if (window.DXD_Act) DXD_Act("accept", uid); return; }
    if (act === "unblock") { if (window.DXD_Act) DXD_Act("unblock", uid); return; }
    if (act === "add") {
        DX_Post("DiscordExt_AddFriendByUid", { uid: uid }, function(r) {
            if (window.DX_Toast) DX_Toast(r && r.ok ? "Friend request sent." : "Could not send the request.", r && r.ok ? "success" : "error");
            $(".dxv39-actions").html('<div class="dxp34-btn dxv39-off">Friend Request Sent</div>');
        });
    }
});
