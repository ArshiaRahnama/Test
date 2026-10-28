// ============================================================================
// Discord v38 — @ID mentions in message text get the same pill as @name.
// The ID is hidden behind a token before the normal processing (so "@arshia"
// is not split off as a name), and the pill is put back after it.
// ============================================================================

(function() {
    var orig = window.Discord_ProcessMessageText;
    if (typeof orig !== "function") return;
    window.Discord_ProcessMessageText = function(rawText) {
        var handles = {};
        $.each((DX.meta[Discord.currentServerId] || {}), function(k, m) { if (m && m.handle) handles[m.handle] = true; });
        if (Discord.myHandle) handles[Discord.myHandle] = true;
        var list = Object.keys(handles).sort(function(a, b) { return b.length - a.length; });
        var found = [];
        var text = String(rawText || "");
        list.forEach(function(h) {
            var re = new RegExp("@" + h.replace(/[.*+?^${}()|[\]\\]/g, "\\$&") + "(?![\\w.])", "gi");
            text = text.replace(re, function(m) { found.push({ text: m, self: h === Discord.myHandle }); return "qqidmention" + (found.length - 1) + "qqend"; });
        });
        var out = orig.call(this, text);
        if (!out || !out.textHtml || !found.length) return out;
        out.textHtml = out.textHtml.replace(/qqidmention(\d+)qqend/g, function(_, i) {
            var f = found[+i];
            return '<span class="discord-mention-pill' + (f.self ? ' discord-mention-self' : '') + '">' + DX_Esc(f.text) + "</span>";
        });
        return out;
    };
})();
