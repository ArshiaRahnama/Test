// ============================================================================
// Discord v29 — better notifications: a different sound for mentions, direct
// messages and replies; a slide-in banner for new messages; and a "Catch up"
// summary of unread messages. Same files run in the game and on the website.
// ============================================================================

var DXN = { ctx: null, kind: null, catchTimer: null };

// ---------- sounds ----------
DXN.audio = function() {
    if (!DXN.ctx) {
        try { DXN.ctx = new (window.AudioContext || window.webkitAudioContext)(); } catch (e) { return null; }
    }
    if (DXN.ctx && DXN.ctx.state === "suspended" && DXN.ctx.resume) DXN.ctx.resume();
    return DXN.ctx;
};
DXN.tone = function(ctx, freq, start, dur, type, vol) {
    var o = ctx.createOscillator(), g = ctx.createGain(), t = ctx.currentTime + start;
    o.type = type; o.frequency.setValueAtTime(freq, t);
    g.gain.setValueAtTime(0.0001, t);
    g.gain.exponentialRampToValueAtTime(vol, t + 0.012);
    g.gain.exponentialRampToValueAtTime(0.0001, t + dur);
    o.connect(g); g.connect(ctx.destination);
    o.start(t); o.stop(t + dur + 0.02);
};
DXN.play = function(kind) {
    var ctx = DXN.audio();
    if (!ctx) return;
    if (kind === "mention") {           // bright rising three-note chime
        DXN.tone(ctx, 660, 0.00, 0.16, "triangle", 0.20);
        DXN.tone(ctx, 880, 0.10, 0.16, "triangle", 0.20);
        DXN.tone(ctx, 1320, 0.20, 0.30, "triangle", 0.22);
    } else if (kind === "dm") {         // soft bell with an overtone
        DXN.tone(ctx, 987, 0.00, 0.55, "sine", 0.22);
        DXN.tone(ctx, 1975, 0.00, 0.30, "sine", 0.06);
    } else {                            // the normal short blip
        DXN.tone(ctx, 740, 0.00, 0.12, "sine", 0.12);
    }
};
// the game and the website call this one; focus mode (v16) can silence it
// which event is being handled right now (works whatever order the listeners run in)
DXN.kindFromEvent = function() {
    var e = window.event, a = e && e.data && e.data.action;
    if (a === "DiscordExtDMNew") return "dm";
    if (a === "DiscordReplyPing") return "mention";
    return null;
};
window.Discord_PlayNotificationSound = function(kind) {
    if (window.DXF && DXF.suppress) return;
    DXN.play(kind || DXN.kind || DXN.kindFromEvent() || "message");
};

// ---------- banner ----------
DXN.banner = function(o) {
    if (!$("#dxn-stack").length) $("body").append('<div id="dxn-stack"></div>');
    var stack = $("#dxn-stack");
    stack.children().slice(0, Math.max(0, stack.children().length - 2)).remove();
    var letter = (o.title || "?").replace(/^[#@\s]+/, "").charAt(0).toUpperCase() || "?";
    var el = $('<div class="dxn-banner dxn-' + (o.kind || "message") + '"></div>');
    el.html('<div class="dxn-av">' + DX_Esc(letter) + '</div><div class="dxn-txt"><div class="dxn-title">' + DX_Esc(o.title || "") +
            '</div><div class="dxn-body">' + DX_Esc(o.body || "") + '</div></div><div class="dxn-x">\u00D7</div>');
    el.on("click", function(e) { if ($(e.target).hasClass("dxn-x")) { e.stopPropagation(); el.remove(); return; } el.remove(); if (o.onClick) o.onClick(); });
    stack.append(el);
    setTimeout(function() { el.addClass("dxn-out"); setTimeout(function() { el.remove(); }, 350); }, 5200);
};

function DXN_Snippet(t) { t = String(t || "").replace(/\s+/g, " "); return t.length > 90 ? t.slice(0, 90) + "\u2026" : t; }

// server messages: a banner for other channels and for mentions (not while focus mode hides them)
(function() {
    var orig = window.Discord_HandleIncomingMessage;
    if (typeof orig !== "function") return;
    window.Discord_HandleIncomingMessage = function(payload) {
        var mention = !!(payload && !payload.isAnnouncement && window.Discord_MentionsMe && Discord_MentionsMe(payload.message || ""));
        DXN.kind = mention ? "mention" : null;
        try {
            var r = orig.apply(this, arguments);
            if (payload && !payload.isMine && (payload.channelId !== Discord.currentChannelId || mention) && !(window.DXF_On && DXF_On() && !mention)) {
                var ch = (Discord.channels || []).filter(function(c) { return c.id === payload.channelId; })[0];
                DXN.banner({
                    kind: mention ? "mention" : "message",
                    title: (mention ? "You were mentioned \u2022 " : "") + (ch ? "#" + ch.name : "New message"),
                    body: (payload.author_name || "Someone") + ": " + DXN_Snippet(payload.message),
                    onClick: function() {
                        if (payload.serverId && payload.serverId !== Discord.currentServerId && window.Discord_SelectServer) Discord_SelectServer(payload.serverId);
                        if (window.Discord_OpenChannel) Discord_OpenChannel(payload.channelId, ch ? ch.name : "");
                    }
                });
            }
            return r;
        } finally { DXN.kind = null; }
    };
})();

// DMs and reply pings arrive as window messages; their sound kind is set just before the other handlers run
window.addEventListener("message", function(event) {
    var d = event.data;
    if (!d || !d.action) return;
    if (d.action === "DiscordExtDMNew" && d.data && d.data.from) {
        DXN.kind = "dm";
        setTimeout(function() { DXN.kind = null; }, 0);
    }
    if (d.action === "DiscordReplyPing") {
        DXN.kind = "mention";
        setTimeout(function() { DXN.kind = null; }, 0);
    }
}, true);
window.addEventListener("message", function(event) {
    var d = event.data;
    if (!d || !d.action) return;
    if (d.action === "DiscordExtDMNew" && d.data && d.data.from) {
        var p = d.data, open = window.DXD && DXD.mode === "dm" && DXD.dmId === p.dmId && $("#discord-backdrop").hasClass("discord-visible");
        if (!open) DXN.banner({ kind: "dm", title: "\u2709 " + (p.from.name || "Direct message"), body: DXN_Snippet(p.message && p.message.message),
            onClick: function() { if (window.DXD_OpenDmByUid && p.from.uid) DXD_OpenDmByUid(p.from.uid); } });
    }
    if (d.action === "DiscordReplyPing" && d.data) {
        var q = d.data;
        DXN.banner({ kind: "mention", title: "\u21A9 " + (q.from || "Someone") + " replied to you", body: DXN_Snippet(q.text),
            onClick: function() { if (q.serverId && window.Discord_SelectServer && q.serverId !== Discord.currentServerId) Discord_SelectServer(q.serverId); if (window.Discord_OpenChannel && q.channelId) Discord_OpenChannel(q.channelId, ""); } });
    }
});

// ---------- catch up ----------
DXN.unread = { total: 0, rows: [], dm: 0 };
function DXN_Refresh() {
    DX_Post("DiscordExt_GetUnread", {}, function(rows) {
        rows = (rows && rows.length !== undefined) ? rows : [];
        DXN.unread.rows = rows;
        DXN.unread.total = rows.reduce(function(n, r) { return n + (r.cnt || 0); }, 0);
        DXN.unread.dm = (window.DXD && DXD.social && DXD.social.dmUnread) || 0;
        DXN_RenderPill();
    });
}
function DXN_RenderPill() {
    var n = DXN.unread.total + DXN.unread.dm;
    $("#dxn-catchup").remove();
    if (!n) return;
    $("body").append('<div id="dxn-catchup"><i class="fas fa-inbox"></i> Catch up <b>' + (n > 99 ? "99+" : n) + "</b></div>");
}
$(document).on("click", "#dxn-catchup", function() {
    if (!window.Discord_OpenModal) return;
    Discord_OpenModal("dxn-modal-catchup");
    var names = {};
    (Discord.servers || []).forEach(function(s) { names[s.id] = s.name; });
    var byServer = {};
    DXN.unread.rows.forEach(function(r) { byServer[r.serverId] = (byServer[r.serverId] || 0) + (r.cnt || 0); });
    var html = '<div class="dxn-sum"><div><b>' + DXN.unread.total + '</b><span>unread in servers</span></div><div><b>' + DXN.unread.dm + '</b><span>unread DMs</span></div></div>';
    html += Object.keys(byServer).map(function(sid) {
        return '<div class="dxn-row" data-catch-server="' + sid + '"><div class="dxn-av">' + DX_Esc((names[sid] || "S").charAt(0)) + '</div><div class="dxn-txt"><div class="dxn-title">' +
               DX_Esc(names[sid] || "Server " + sid) + '</div><div class="dxn-body">' + byServer[sid] + " new messages</div></div><div class=\"dxn-go\">Open</div></div>";
    }).join("");
    if (!html.match(/dxn-row/)) html += '<div class="dxn-body">You are all caught up.</div>';
    $("#dxn-catch-body").html(html);
});
$(document).on("click", "[data-catch-server]", function() {
    var sid = parseInt($(this).attr("data-catch-server"), 10);
    if (window.Discord_CloseModals) Discord_CloseModals();
    if (window.Discord_SelectServer) Discord_SelectServer(sid);
});

$(function() {
    $("#discord-modal-overlay").append('<div class="discord-modal dx-modal-wide" id="dxn-modal-catchup"><div class="discord-modal-title">Catch up</div><div id="dxn-catch-body"></div>' +
        '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Close</div></div></div>');
    DXN_Refresh();
    DXN.catchTimer = setInterval(DXN_Refresh, 20000);
});
DX_After("Discord_OpenChannel", function() { setTimeout(DXN_Refresh, 800); });
