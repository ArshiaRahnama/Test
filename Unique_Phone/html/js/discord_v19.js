// ============================================================================
// Discord v19 — reply pings: the reply bar has a "Ping" switch (default on) that
// sends the person you answer a notice. Join alerts arrive as normal notices.
// Server: discord_v19.lua. Loaded last.
// ============================================================================

var DXP19 = { ping: true };

function DXP19_BuildToggle() {
    var bar = $("#discord-reply-preview-bar");
    if (!bar.length || bar.find("#dxp-ping").length) return;
    bar.append('<label class="dxp-ping" title="Send the person you reply to a notice"><input type="checkbox" id="dxp-ping"' + (DXP19.ping ? " checked" : "") + '> Ping</label>');
}
$(function() {
    DXP19_BuildToggle();
    var bar = document.getElementById("discord-reply-preview-bar");
    if (bar && window.MutationObserver) new MutationObserver(DXP19_BuildToggle).observe(bar, { childList: true });
});
$(document).on("change", "#dxp-ping", function() { DXP19.ping = $(this).is(":checked"); });

// the send call carries the switch; only meaningful when a reply is being sent
(function() {
    var orig = window.Discord_Post;
    if (typeof orig !== "function") return;
    window.Discord_Post = function(endpoint, data, cb) {
        if (endpoint === "SendDiscordMessage" && data) {
            data.replyPing = !!(data.replyToId != null && DXP19.ping);
        }
        return orig.apply(this, arguments);
    };
})();

// a reply ping from the game or the website
window.addEventListener("message", function(event) {
    var d = event.data;
    if (!d || d.action !== "DiscordReplyPing" || !d.data) return;
    var p = d.data;
    if (window.DX_Toast) DX_Toast((p.from || "Someone") + " replied to you: " + (p.text || ""), "info");
    if (window.Discord_PlayNotificationSound) Discord_PlayNotificationSound();
});
