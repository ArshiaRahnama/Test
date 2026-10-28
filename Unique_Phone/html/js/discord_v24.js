// ============================================================================
// Discord v24 — "Seen" under your last direct message the other person has read.
// Server: discord_v24.lua (adds otherSeen to the DM history reply).
// ============================================================================

var DXS24 = { otherSeen: 0, dmId: null };

(function() {
    var orig = window.DX_Post;
    if (typeof orig !== "function") return;
    window.DX_Post = function(endpoint, data, cb) {
        if (endpoint === "DiscordExt_GetDMMessages") {
            var dmId = data && data.dmId;
            var wrapped = function(r) {
                if (r && typeof r === "object") {
                    DXS24.otherSeen = r.otherSeen || 0;
                    DXS24.dmId = dmId;
                }
                if (cb) cb(r);
                setTimeout(DXS24_Apply, 60);
            };
            return orig.call(this, endpoint, data, wrapped);
        }
        return orig.apply(this, arguments);
    };
})();

function DXS24_Apply() {
    $(".dxs-seen").remove();
    if (!DXD || DXD.mode !== "dm" || DXS24.dmId !== DXD.dmId) return;
    var lastMine = null;
    $.each(DXD.dmMsgs || {}, function(id, m) {
        if (m.isMine && parseInt(id, 10) <= DXS24.otherSeen && (lastMine === null || parseInt(id, 10) > lastMine)) lastMine = parseInt(id, 10);
    });
    if (lastMine === null) return;
    var row = $('#discord-chat-messages .discord-message[data-messageid="' + lastMine + '"]');
    if (row.length) row.find(".discord-message-text").first().after('<div class="dxs-seen"><i class="fas fa-check-double"></i> Seen</div>');
}
