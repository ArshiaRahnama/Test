// ============================================================================
// Discord v36 — the chosen ID shows on the profile card (as @id), like a username.
// Server: discord_ext4.lua / discord_ext.lua send `handle` in the member data.
// ============================================================================

DX_After("Discord_OpenMemberProfile", function(memberId) {
    var tries = 0;
    var t = setInterval(function() {
        tries++;
        var card = $("#discord-modal-profile-view");
        if ((card.length && card.hasClass("discord-modal-active") && card.find("#discord-pv-name").text().trim() !== "") || tries > 15) {
            clearInterval(t);
            var m = (DX.meta[Discord.currentServerId] || {})[String(memberId)] || {};
            if (m.handle) card.find("#discord-pv-tag").text("@" + m.handle);
        }
    }, 80);
});
