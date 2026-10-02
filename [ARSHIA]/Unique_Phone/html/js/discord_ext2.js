// ============================================================================
// Discord v8 — front-end (loaded AFTER discord.js and discord_ext.js).
// Phase 1: real Markdown, slash commands, per-channel/server mute, unread
//          styling + "NEW MESSAGES" line, per-server nickname.
// Phase 2: roles + permissions (+ channel overrides, coloured names,
//          @role mentions), limited invites + vanity, welcome screen + rules,
//          stage channels, templates, server card, server folders.
// Same approach as discord_ext.js: wrap a few globals of discord.js, build
// extra modals at runtime, talk to the server through "DiscordExt_*" NUI
// callbacks (client/discord_ext.lua).
// ============================================================================

var DX2 = {
    mutes: { channels: {}, servers: {} }, mutesLoaded: false,
    folders: [], openFolders: {}, foldersLoaded: false,
    divider: null,
    curMsg: null,
    baseName: null,
    welcomeShown: {}, accepted: {},
    roles: null, roleSel: null,
    cp: null, cpChannel: null,
    speakerChannel: null,
    promptCb: null,
    slashSel: 0,
    holdTimer: null, holdStart: null, suppressClick: 0,
    cardTimer: null, cardHide: null,
    templateTarget: null,
    palette: ["#5865F2", "#EB459E", "#ED4245", "#FAA61A", "#57F287", "#3BA55D", "#00AFF4", "#9B59B6", "#E67E22", "#1ABC9C", "#95A5A6", "#FFFFFF"],
};

// Quote-safe escape (discord.js's Discord_Escape leaves " and ' alone, which is unsafe inside attributes).
window.DX_Esc = function(s) {
    s = (s == null) ? "" : String(s);
    return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;").replace(/'/g, "&#39;");
};

function DX2_Info(serverId) { return DX.info[serverId != null ? serverId : Discord.currentServerId] || null; }
function DX2_Perms() { var i = DX2_Info(); return (i && i.perms) || {}; }
function DX2_IsFull() { var p = DX2_Perms(); return !!p.administrator; }
function DX2_Until(ts) {
    if (!ts) return "never";
    var diff = ts - Math.floor(Date.now() / 1000);
    if (diff <= 0) return "expired";
    if (diff < 3600) return "in " + Math.ceil(diff / 60) + " min";
    if (diff < 86400) return "in " + Math.ceil(diff / 3600) + " h";
    return "in " + Math.ceil(diff / 86400) + " d";
}
function DX2_CopyText(text) {
    var temp = $("<input>").val(text).appendTo("body").select();
    try { document.execCommand("copy"); } catch (e) {}
    temp.remove();
}
function DX2_Backdrop() { return $("#discord-backdrop"); }

// ---------------------------------------------------------------------------
// Error texts for server refusals (also fixes the optimistic message staying on screen)
// ---------------------------------------------------------------------------

window.DX_ErrorText = function(result) {
    if (!result) return "Something went wrong.";
    switch (result.error) {
        case "TIMEOUT": return "You are timed out until " + DX_TimeLabel(result.untilAt) + ".";
        case "AUTOMOD": return "Your message was blocked by this server's auto-mod.";
        case "LOCKED": return "This channel is locked.";
        case "NO_PERMISSION": return "You don't have permission to send messages here.";
        case "STAGE": return "Only speakers can talk in a stage channel.";
        case "RULES": return "Accept the server rules before you can chat.";
        case "NO_ACCOUNT": return "Open Discord and sign in first.";
        case "BAD_URL": return "That image link can't be shared.";
    }
    return "Could not send that.";
};

(function() {
    var orig = window.Discord_Post;
    window.Discord_Post = function(endpoint, data, cb) {
        if (endpoint === "SendDiscordMessage") {
            return orig(endpoint, data, function(r) {
                if (r && r.error && r.error !== "LOCKED") {
                    // reuse discord.js's own "refused" path (removes the optimistic copy), then say why
                    if (cb) cb({ error: "LOCKED" });
                    $("#discord-typing-indicator").text(DX_ErrorText(r));
                    DX_Toast(DX_ErrorText(r), "warn");
                    if (r.error === "RULES") DX2_OpenWelcome(Discord.currentServerId, true);
                    return;
                }
                if (r && r.error === "LOCKED") { if (cb) cb(r); DX_Toast("This channel is locked.", "warn"); return; }
                if (cb) cb(r);
            });
        }
        if (endpoint === "JoinDiscordServer") {
            return orig(endpoint, data, function(r) {
                if (r && (r.error === "EXPIRED" || r.error === "FULL")) {
                    DX_Toast(r.error === "EXPIRED" ? "That invite has expired." : "That invite has reached its use limit.", "warn");
                    if (cb) cb({ error: "NOT_FOUND" });
                    return;
                }
                if (cb) cb(r);
            });
        }
        return orig(endpoint, data, cb);
    };
})();

// ---------------------------------------------------------------------------
// PHASE 1 — Markdown (replaces Discord_ProcessMessageText)
// ---------------------------------------------------------------------------

function DX2_RegexEsc(s) { return s.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"); }

function DX2_RoleMentionTargets(msg) {
    var out = [];
    if (!msg || !msg.roleMentions || !msg.roleMentions.length) return out;
    var info = DX2_Info(msg.serverId != null ? msg.serverId : undefined);
    var roles = (info && info.roles) || [];
    $.each(msg.roleMentions, function(i, id) {
        if (id === -1) { out.push({ id: -1, names: ["admin", "admins"], color: "#FAA61A" }); return; }
        $.each(roles, function(j, r) { if (r.id === id) out.push({ id: id, names: [r.name], color: r.color || "#99AAB5" }); });
    });
    return out;
}

function DX2_ProcessMessageText(rawText) {
    var raw = String(rawText == null ? "" : rawText).replace(/[\uE000-\uE001]/g, "");
    var tokens = [];
    var imageUrls = [];
    var isImage = new RegExp(DISCORD_IMAGE_RE.source, DISCORD_IMAGE_RE.flags.replace("g", ""));
    function tok(html) { tokens.push(html); return "\uE000" + (tokens.length - 1) + "\uE001"; }

    var text = raw.replace(/```([\s\S]+?)```/g, function(_, code) {
        return tok('<pre class="dx-codeblock">' + Discord_Escape(code.replace(/^\n/, "").replace(/\n$/, "")) + "</pre>");
    });
    text = text.replace(/`([^`\n]+?)`/g, function(_, code) { return tok('<code class="dx-code">' + Discord_Escape(code) + "</code>"); });
    text = text.replace(/(https?:\/\/[^\s<]+)/gi, function(url) {
        if (isImage.test(url)) imageUrls.push(url);
        return tok('<span class="discord-message-link">' + Discord_Escape(url) + "</span>");
    });

    var s = Discord_Escape(text);
    s = s.replace(/\|\|([\s\S]+?)\|\|/g, '<span class="dx-spoiler">$1</span>');
    s = s.replace(/\*\*\*([^\n]+?)\*\*\*/g, "<b><i>$1</i></b>");
    s = s.replace(/\*\*([^\n]+?)\*\*/g, "<b>$1</b>");
    s = s.replace(/__([^\n]+?)__/g, "<u>$1</u>");
    s = s.replace(/\*([^\s*][^\n*]*?)\*/g, "<i>$1</i>");
    s = s.replace(/(^|[\s(])_([^_\n]+?)_(?=$|[\s.,!?)])/g, "$1<i>$2</i>");
    s = s.replace(/~~([^\n]+?)~~/g, "<s>$1</s>");
    s = s.replace(/(^|\n)&gt;\s([^\n]*)/g, '$1<span class="dx-quote">$2</span>');

    // @everyone / @here
    s = s.replace(/@(everyone|here)\b/gi, function(full, word) {
        return tok('<span class="discord-mention-pill discord-mention-everyone">@' + word + "</span>");
    });

    // @role — only roles the server really pinged (msg.roleMentions)
    var targets = DX2_RoleMentionTargets(DX2.curMsg);
    $.each(targets, function(i, t) {
        $.each(t.names, function(j, name) {
            var esc = DX2_RegexEsc(Discord_Escape(name));
            var re = new RegExp("@" + esc + "(?![A-Za-z0-9_])", "ig");
            s = s.replace(re, function(full) {
                var c = t.color, rgb = DX_HexToRgb(c);
                var bg = rgb ? "rgba(" + rgb.join(",") + ",.2)" : "rgba(153,170,181,.2)";
                return tok('<span class="discord-mention-pill dx-role-mention" style="color:' + DX_Esc(c) + ";background:" + bg + '">' + full + "</span>");
            });
        });
    });

    // @Name
    s = s.replace(/@([A-Za-z\u00C0-\u024F\u0600-\u06FF]+(?:\s[A-Za-z\u00C0-\u024F\u0600-\u06FF]+)?)/g, function(full, name) {
        if (/^(everyone|here)$/i.test(name)) return full;
        var isSelf = Discord.myName && name.toLowerCase().indexOf(Discord.myName.split(/\s+/)[0].toLowerCase()) === 0;
        return '<span class="discord-mention-pill' + (isSelf ? " discord-mention-self" : "") + '">@' + name + "</span>";
    });

    s = s.replace(/\n/g, "<br>");
    s = s.replace(/\uE000(\d+)\uE001/g, function(_, i) { return tokens[parseInt(i, 10)] || ""; });

    var embedHtml = "";
    $.each(imageUrls, function(i, url) { embedHtml += '<img class="discord-message-embed-image" src="' + DX_Esc(url) + '" onerror="this.remove()">'; });
    return { textHtml: s, embedHtml: embedHtml };
}
window.Discord_ProcessMessageText = DX2_ProcessMessageText;

(function() {
    var origRender = window.Discord_RenderMessageInnerHTML;
    window.Discord_RenderMessageInnerHTML = function(msg) {
        var prev = DX2.curMsg;
        DX2.curMsg = msg;
        try { return origRender(msg); } finally { DX2.curMsg = prev; }
    };

    var origMM = window.Discord_MentionsMe;
    window.Discord_MentionsMe = function(rawText) {
        if (origMM(rawText)) return true;
        var m = DX2.curMsg;
        if (m && m.roleMentions && m.roleMentions.length) {
            var info = DX2_Info(m.serverId);
            var mine = (info && info.myRoleIds) || [];
            for (var i = 0; i < m.roleMentions.length; i++) if (mine.indexOf(m.roleMentions[i]) >= 0) return true;
        }
        return false;
    };

    var origIncoming = window.Discord_HandleIncomingMessage;
    window.Discord_HandleIncomingMessage = function(payload) {
        DX2.curMsg = payload;
        try { return origIncoming(payload); } finally { DX2.curMsg = null; }
    };

    var origSound = window.Discord_PlayNotificationSound;
    window.Discord_PlayNotificationSound = function() {
        var m = DX2.curMsg;
        if (m && DX2_Muted(m.channelId, m.serverId)) return;
        return origSound.apply(this, arguments);
    };
})();

$(document).on("click", ".dx-spoiler", function() { $(this).toggleClass("dx-revealed"); });

// ---------------------------------------------------------------------------
// PHASE 1 — Mute (channel / server) + unread styling
// ---------------------------------------------------------------------------

function DX2_ChMuted(cid) { return !!DX2.mutes.channels[cid]; }
function DX2_SvMuted(sid) { return !!DX2.mutes.servers[sid]; }
function DX2_Muted(cid, sid) { return DX2_ChMuted(cid) || DX2_SvMuted(sid); }

function DX2_LoadMutes(cb) {
    DX_Post("DiscordExt_GetMutes", {}, function(r) {
        DX2.mutes = { channels: {}, servers: {} };
        if (r && r.channels) $.each(r.channels, function(i, id) { DX2.mutes.channels[id] = true; });
        if (r && r.servers) $.each(r.servers, function(i, id) { DX2.mutes.servers[id] = true; });
        DX2.mutesLoaded = true;
        DX_ApplyUnreadUI();
        if (cb) cb();
    });
}

function DX2_SetMute(kind, id, on) {
    if (kind === "channel") { if (on) DX2.mutes.channels[id] = true; else delete DX2.mutes.channels[id]; }
    else { if (on) DX2.mutes.servers[id] = true; else delete DX2.mutes.servers[id]; }
    DX_ApplyUnreadUI();
    DX_Post("DiscordExt_SetMute", { kind: kind, targetId: id, on: on });
    DX_Toast((on ? "Muted " : "Unmuted ") + (kind === "channel" ? "this channel" : "this server") + ".", "info");
}

function DX2_ServerUnreadUnmuted(sid) {
    if (DX2_SvMuted(sid)) return 0;
    var n = 0;
    $.each(DX.unread, function(cid, u) { if (u.serverId === sid && !DX2_ChMuted(parseInt(cid, 10))) n += u.count; });
    return n;
}

window.DX_ApplyUnreadUI = function() {
    var total = 0;
    $.each(DX.unread, function(cid, u) { if (!DX2_Muted(parseInt(cid, 10), u.serverId)) total += u.count; });

    $(".dx-rail-badge").each(function() {
        var n = DX2_ServerUnreadUnmuted(parseInt($(this).attr("data-badgefor"), 10));
        $(this).text(n > 99 ? "99+" : n).toggleClass("dx-visible", n > 0);
    });
    $(".discord-rail-icon[data-serverid]").each(function() {
        $(this).toggleClass("dx-server-muted", DX2_SvMuted(parseInt($(this).attr("data-serverid"), 10)));
    });

    $(".discord-channel-item[data-channelid]").each(function() {
        var item = $(this);
        var cid = parseInt(item.attr("data-channelid"), 10);
        var u = DX.unread[cid];
        var muted = DX2_Muted(cid, Discord.currentServerId);
        item.find(".dx-channel-badge, .dx-muted-ico").remove();
        item.toggleClass("dx-unread", !!u && !muted);
        item.toggleClass("dx-muted", muted);
        if (muted) item.append('<i class="fas fa-bell-slash dx-muted-ico" title="Muted"></i>');
        else if (u) item.append('<span class="dx-channel-badge">' + (u.count > 99 ? "99+" : u.count) + "</span>");
    });

    $(".dx-folder").each(function() {
        var f = $(this), n = 0;
        $.each(DX2_FolderById(parseInt(f.attr("data-folderid"), 10)).servers || [], function(i, sid) { n += DX2_ServerUnreadUnmuted(sid); });
        f.find(".dx-folder-badge").text(n > 99 ? "99+" : n).toggleClass("dx-visible", n > 0 && !f.hasClass("dx-open"));
    });

    clearTimeout(DX.unreportTimer);
    DX.unreportTimer = setTimeout(function() { DX_Post("DiscordExt_SetUnread", { count: total }); }, 300);
};

DX_After("DX_SetUnreadFromServer", function() { if (!DX2.mutesLoaded) DX2_LoadMutes(); });
DX_After("Discord_Init", function(myName) {
    if (myName) DX2.baseName = myName;
    DX2_LoadMutes();
    DX2_LoadFolders();
});

// "Mark as read" for a whole server / one channel
function DX2_MarkServerRead(sid) {
    $.each(DX.unread, function(cid, u) {
        if (u.serverId === sid) { DX_Post("DiscordExt_EnterChannel", { channelId: parseInt(cid, 10) }); delete DX.unread[cid]; }
    });
    DX_ApplyUnreadUI();
}

// ---------------------------------------------------------------------------
// PHASE 1 — "NEW MESSAGES" divider
// ---------------------------------------------------------------------------

window.DX_MarkChannelSeen = function(channelId) {
    if (DX.unread[channelId]) { delete DX.unread[channelId]; DX_ApplyUnreadUI(); }
    DX2.divider = null;
    DX_Post("DiscordExt_EnterChannel", { channelId: channelId }, function(r) {
        if (Discord.currentChannelId !== channelId) return;
        if (r && r.lastSeen != null) {
            DX2.divider = { channelId: channelId, lastSeen: r.lastSeen, expires: Date.now() + 6000, done: false };
            DX2_PlaceDivider();
        }
    });
};

function DX2_PlaceDivider() {
    var d = DX2.divider;
    if (!d || d.done || Date.now() > d.expires || d.channelId !== Discord.currentChannelId) return;
    var first = null;
    $("#discord-chat-messages .discord-message[data-messageid]").each(function() {
        var id = parseInt($(this).attr("data-messageid"), 10);
        var m = Discord.messagesById[id];
        if (id > d.lastSeen && m && !m.isMine) { first = $(this); return false; }
    });
    if (!first) return;
    d.done = true;
    first.before('<div class="dx-new-divider" id="dx-new-divider"><span>NEW MESSAGES</span></div>');
    setTimeout(function() {
        var el = document.getElementById("dx-new-divider");
        if (el) el.scrollIntoView({ block: "center" });
    }, 40);
}
DX_After("DX_DecorateAll", DX2_PlaceDivider);

// ---------------------------------------------------------------------------
// PHASE 1 — Slash commands
// ---------------------------------------------------------------------------

var DX2_CMDS = [
    { name: "shrug", arg: "[message]", desc: "Appends \u00AF\\_(\u30C4)_/\u00AF to your message", transform: function(a) { return (a ? a + " " : "") + "\u00AF\\_(\u30C4)_/\u00AF"; } },
    { name: "tableflip", arg: "[message]", desc: "(\u256F\u00B0\u25A1\u00B0\uFF09\u256F\uFE35 \u253B\u2501\u253B", transform: function(a) { return (a ? a + " " : "") + "(\u256F\u00B0\u25A1\u00B0\uFF09\u256F\uFE35 \u253B\u2501\u253B"; } },
    { name: "unflip", arg: "[message]", desc: "\u252C\u2500\u252C \u30CE( \u309C-\u309C\u30CE)", transform: function(a) { return (a ? a + " " : "") + "\u252C\u2500\u252C \u30CE( \u309C-\u309C\u30CE)"; } },
    { name: "me", arg: "<action>", desc: "Say something in italics", transform: function(a) { return a ? "*" + a + "*" : null; } },
    { name: "spoiler", arg: "<text>", desc: "Hide the text behind a spoiler", transform: function(a) { return a ? "||" + a + "||" : null; } },
    { name: "nick", arg: "<name>", desc: "Change your nickname in this server", run: function(a) { DX2_ChangeNick(a); } },
    { name: "mute", desc: "Mute this channel", run: function() { if (Discord.currentChannelId != null) DX2_SetMute("channel", Discord.currentChannelId, true); } },
    { name: "unmute", desc: "Unmute this channel", run: function() { if (Discord.currentChannelId != null) DX2_SetMute("channel", Discord.currentChannelId, false); } },
    { name: "search", arg: "<text>", desc: "Search messages in this channel", run: function(a) {
        $("#dx-search-panel").addClass("dx-open");
        $("#dx-search-input").val(a).focus();
        DX_RunSearch();
    } },
    { name: "leaderboard", desc: "Show the XP leaderboard", run: function() { DX_OpenLeaderboard(); } },
    { name: "report", desc: "Report the message you are replying to", run: function() {
        var id = Discord.replyingToMessageId;
        if (id == null) { DX_Toast("Reply to a message first, then type /report.", "warn"); return; }
        DX.reportMessageId = id;
        Discord_OpenModal("dx-modal-report");
    } },
    { name: "rules", desc: "Show the welcome screen and rules", run: function() { DX2_OpenWelcome(Discord.currentServerId, true); } },
    { name: "invite", desc: "Manage invite links", when: function() { var i = DX2_Info(); return !!(i && i.canConfigure); }, run: function() { DX2_OpenInvites(); } },
    { name: "roles", desc: "Manage roles and permissions", when: function() { return !!DX2_Perms().manage_roles; }, run: function() { DX2_OpenRoles(); } },
];

function DX2_FindCmd(name) {
    name = String(name).toLowerCase();
    if (name === "rank") name = "leaderboard";
    var found = null;
    $.each(DX2_CMDS, function(i, c) { if (c.name === name && (!c.when || c.when())) found = c; });
    return found;
}

function DX2_HandleSlash(text) {
    var m = /^\/([A-Za-z]+)(?:\s+([\s\S]*))?$/.exec(text);
    if (!m) return null;
    var cmd = DX2_FindCmd(m[1]);
    if (!cmd) return null;
    var arg = (m[2] || "").trim();
    if (cmd.transform) {
        var t = cmd.transform(arg);
        if (t == null) { DX_Toast("Usage: /" + cmd.name + " " + (cmd.arg || ""), "warn"); return { handled: true }; }
        return { text: t };
    }
    cmd.run(arg);
    return { handled: true };
}

(function() {
    var origSend = window.Discord_SendMessage;
    window.Discord_SendMessage = function() {
        var input = $("#discord-message-input");
        var t = (input.val() || "").trim();
        if (t.charAt(0) === "/") {
            var r = DX2_HandleSlash(t);
            if (r && r.handled) { input.val(""); DX2_HideSlash(); return; }
            if (r && r.text) { input.val(r.text); DX2_HideSlash(); }
        }
        return origSend.apply(this, arguments);
    };
})();

function DX2_HideSlash() { $("#dx-slash-menu").removeClass("dx-open").empty(); }

function DX2_RefreshSlash() {
    var v = $("#discord-message-input").val() || "";
    var m = /^\/([A-Za-z]*)$/.exec(v);
    if (!m) { DX2_HideSlash(); return; }
    var prefix = m[1].toLowerCase(), html = "";
    $.each(DX2_CMDS, function(i, c) {
        if (c.when && !c.when()) return;
        if (c.name.indexOf(prefix) !== 0) return;
        html += '<div class="dx-slash-item" data-cmd="' + c.name + '"><b>/' + c.name + "</b> <span class=\"dx-slash-arg\">" + DX_Esc(c.arg || "") + '</span><span class="dx-slash-desc">' + DX_Esc(c.desc) + "</span></div>";
    });
    if (!html) { DX2_HideSlash(); return; }
    DX2.slashSel = 0;
    $("#dx-slash-menu").html(html).addClass("dx-open").find(".dx-slash-item").first().addClass("dx-sel");
}

$(document).on("input", "#discord-message-input", DX2_RefreshSlash);
$(document).on("mousedown", ".dx-slash-item", function(e) {
    e.preventDefault();
    $("#discord-message-input").val("/" + $(this).attr("data-cmd") + " ").focus();
    DX2_HideSlash();
});

document.addEventListener("keydown", function(e) {
    if (!e.target || e.target.id !== "discord-message-input") return;
    var menu = $("#dx-slash-menu");
    if (!menu.hasClass("dx-open")) return;
    var items = menu.find(".dx-slash-item");
    if (e.key === "ArrowDown" || e.key === "ArrowUp") {
        DX2.slashSel = (DX2.slashSel + (e.key === "ArrowDown" ? 1 : -1) + items.length) % items.length;
        items.removeClass("dx-sel").eq(DX2.slashSel).addClass("dx-sel");
        e.preventDefault(); e.stopPropagation();
    } else if (e.key === "Tab" || e.key === "Enter") {
        var sel = items.eq(DX2.slashSel);
        var typed = ($("#discord-message-input").val() || "").toLowerCase();
        if (sel.length && (e.key === "Tab" || typed !== "/" + sel.attr("data-cmd"))) {
            $("#discord-message-input").val("/" + sel.attr("data-cmd") + " ");
            DX2_HideSlash();
            e.preventDefault(); e.stopPropagation();
        }
    } else if (e.key === "Escape") {
        DX2_HideSlash();
        e.preventDefault(); e.stopPropagation();
    }
}, true);

// ---------------------------------------------------------------------------
// Generic prompt modal, context menu, small helpers
// ---------------------------------------------------------------------------

function DX2_Prompt(opts) {
    $("#dx-prompt-title").text(opts.title || "");
    $("#dx-prompt-label").text(opts.label || "");
    Discord_OpenModal("dx-modal-prompt");
    $("#dx-prompt-input").attr({ placeholder: opts.placeholder || "", maxlength: opts.max || 40 }).val(opts.value || "").focus();
    var colorEl = $("#dx-prompt-color");
    if (opts.color) colorEl.val(opts.color).show(); else colorEl.hide();
    DX2.promptCb = opts.cb;
    setTimeout(function() { $("#dx-prompt-input").focus(); }, 30);
}
function DX2_PromptSubmit() {
    var cb = DX2.promptCb;
    var val = $("#dx-prompt-input").val().trim();
    var color = $("#dx-prompt-color").is(":visible") ? $("#dx-prompt-color").val() : null;
    DX2.promptCb = null;
    Discord_CloseModals();
    if (cb) cb(val, color);
}
$(document).on("click", "#dx-prompt-ok", DX2_PromptSubmit);
$(document).on("keydown", "#dx-prompt-input", function(e) { if (e.key === "Enter") { e.preventDefault(); DX2_PromptSubmit(); } });

function DX2_HideCtx() { $("#dx-ctx").remove(); }
function DX2_Ctx(clientX, clientY, items) {
    DX2_HideCtx();
    DX2_HideCard();
    var bd = DX2_Backdrop(), rect = bd[0].getBoundingClientRect();
    var html = "";
    $.each(items, function(i, it) {
        if (it.sep) { html += '<div class="dx-ctx-sep"></div>'; return; }
        html += '<div class="dx-ctx-item' + (it.danger ? " dx-danger" : "") + '" data-i="' + i + '"><i class="fas ' + (it.icon || "fa-circle") + '"></i><span>' + DX_Esc(it.label) + "</span></div>";
    });
    var menu = $('<div id="dx-ctx">' + html + "</div>").appendTo(bd);
    var w = menu.outerWidth(), h = menu.outerHeight();
    var left = Math.min(Math.max(4, clientX - rect.left), rect.width - w - 4);
    var top = Math.min(Math.max(4, clientY - rect.top), rect.height - h - 4);
    menu.css({ left: left, top: top });
    menu.on("click", ".dx-ctx-item", function(e) {
        e.stopPropagation();
        var it = items[parseInt($(this).attr("data-i"), 10)];
        DX2_HideCtx();
        if (it && it.fn) it.fn();
    });
}
document.addEventListener("click", function(e) {
    if (DX2.suppressClick && Date.now() - DX2.suppressClick < 500) { e.stopPropagation(); e.preventDefault(); DX2.suppressClick = 0; return; }
    if (!$(e.target).closest("#dx-ctx").length) DX2_HideCtx();
    if (!$(e.target).closest("#dx-card").length) DX2_HideCard();
}, true);

// open a context menu on right-click or long-press
function DX2_BindContext(selector, handler) {
    $(document).on("contextmenu", selector, function(e) {
        e.preventDefault();
        handler($(this), e.clientX, e.clientY);
    });
    $(document).on("mousedown", selector, function(e) {
        if (e.which !== 1) return;
        var el = $(this), x = e.clientX, y = e.clientY;
        clearTimeout(DX2.holdTimer);
        DX2.holdStart = { x: x, y: y };
        DX2.holdTimer = setTimeout(function() { DX2.suppressClick = Date.now(); handler(el, x, y); }, 600);
    });
}
$(document).on("mouseup mouseleave", "#discord-backdrop", function() { clearTimeout(DX2.holdTimer); });
$(document).on("mousemove", "#discord-backdrop", function(e) {
    if (DX2.holdTimer && DX2.holdStart && (Math.abs(e.clientX - DX2.holdStart.x) > 8 || Math.abs(e.clientY - DX2.holdStart.y) > 8)) { clearTimeout(DX2.holdTimer); }
});

// ---------------------------------------------------------------------------
// Nickname (per server)
// ---------------------------------------------------------------------------

function DX2_ChangeNick(value) {
    var sid = Discord.currentServerId;
    if (sid == null) return;
    function apply(nick) {
        DX_Post("DiscordExt_SetNickname", { serverId: sid, memberId: 0, nickname: nick }, function(r) {
            if (!r || !r.ok) { DX_Toast("Could not change your nickname.", "error"); return; }
            var info = DX2_Info(sid);
            if (info) info.myNickname = r.nickname;
            if (sid === Discord.currentServerId) Discord.myName = r.nickname;
            DX_Toast("Nickname in this server: " + r.nickname, "success");
            Discord_LoadMembersSidebar();
        });
    }
    if (value) { apply(value); return; }
    var info = DX2_Info(sid);
    DX2_Prompt({ title: "Server nickname", label: "Only used in this server. Leave empty to use your character name.", value: (info && info.myNickname) || "", max: 32, cb: apply });
}

DX_After("DX_ApplyServerLook", function(info) {
    if (!info || info.serverId !== Discord.currentServerId) return;
    if (info.myNickname) Discord.myName = info.myNickname;
    else if (DX2.baseName) Discord.myName = DX2.baseName;
    Discord_UpdateComposerLock();
    if (info.showWelcome && !DX2.welcomeShown[info.serverId]) {
        DX2.welcomeShown[info.serverId] = true;
        DX2_OpenWelcome(info.serverId, false);
    }
});

// ---------------------------------------------------------------------------
// Composer lock (locked channels, stage channels, permissions, rules)
// ---------------------------------------------------------------------------

window.Discord_UpdateComposerLock = function() {
    var ch = Discord_FindChannel(Discord.currentChannelId);
    var info = DX2_Info();
    var locked = false, reason = null;
    if (ch) {
        if (ch.canSend === false) {
            locked = true;
            reason = ch.kind === "stage" ? "Stage channel \u2014 only speakers can talk (you can still react)"
                   : (ch.isLocked ? "This channel is locked" : "You don't have permission to send messages here");
        } else if (ch.canSend === undefined && ch.isLocked && !(Discord.currentServerIsOwner || Discord.currentServerIsAdmin || Discord.isStaff)) {
            locked = true; reason = "This channel is locked";
        }
    }
    if (!locked && info && info.mustAccept && !DX2.accepted[info.serverId]) { locked = true; reason = "Accept the server rules to chat (type /rules)"; }
    $(".discord-chat-input-row").toggleClass("discord-composer-locked", locked);
    $("#discord-message-input").prop("disabled", locked);
    if (locked) $("#discord-message-input").attr("placeholder", reason);
    else if (ch) $("#discord-message-input").attr("placeholder", "Message #" + ch.name + "  (type / for commands)");
};

// ---------------------------------------------------------------------------
// Channel list: stage icons; reload channels on permission changes
// ---------------------------------------------------------------------------

DX_After("Discord_RenderChannelList", function() {
    $(".discord-channel-item[data-channelid]").each(function() {
        var ch = Discord_FindChannel(parseInt($(this).attr("data-channelid"), 10));
        if (ch && ch.kind === "stage") {
            $(this).find("i.fa-hashtag").removeClass("fa-hashtag").addClass("fa-podcast");
            if (!$(this).find(".dx-stage-tag").length) $(this).find("span").first().after('<em class="dx-stage-tag">STAGE</em>');
        }
    });
    DX_ApplyUnreadUI();
});

function DX2_ReloadChannels() {
    var sid = Discord.currentServerId;
    if (sid == null) return;
    Discord_Post("GetDiscordChannels", { serverId: sid }, function(ch) {
        if (sid !== Discord.currentServerId) return;
        Discord.channels = (ch === false || !ch) ? [] : ch;
        Discord_RenderChannelList();
        Discord_UpdateComposerLock();
        if (!Discord_FindChannel(Discord.currentChannelId)) {
            if (Discord.channels.length) Discord_OpenChannel(Discord.channels[0].id, Discord.channels[0].name);
            else Discord_ShowChatColumnState("channel-empty");
        }
    });
}

window.addEventListener("message", function(event) {
    var d = event.data;
    if (!d || d.action !== "DiscordExtServerExtrasUpdated" || !d.data) return;
    if (d.data.serverId !== Discord.currentServerId) return;
    if (d.data.channels) setTimeout(DX2_ReloadChannels, 250);
    if (d.data.members) Discord_LoadMembersSidebar();
    setTimeout(Discord_UpdateComposerLock, 400);
});

// ---------------------------------------------------------------------------
// Role colours on names + badges (runs after every decoration pass)
// ---------------------------------------------------------------------------

DX_After("DX_DecorateAll", function() {
    var meta = DX.meta[Discord.currentServerId];
    if (!meta) return;
    $("#discord-chat-messages .discord-message-author[data-authorid]").each(function() {
        var m = meta[$(this).attr("data-authorid")];
        this.style.color = (m && m.color) ? m.color : "";
    });
    $("#discord-members-list .discord-member-item").each(function() {
        var m = meta[$(this).attr("data-memberrowid")];
        var nameEl = $(this).find(".discord-member-name")[0];
        if (nameEl) nameEl.style.color = (m && m.color) ? m.color : "";
    });
});

// ---------------------------------------------------------------------------
// UI that has to exist in the DOM
// ---------------------------------------------------------------------------

function DX2_BuildUI() {
    var overlay = $("#discord-modal-overlay");

    overlay.append(
        '<div class="discord-modal" id="dx-modal-prompt">' +
            '<div class="discord-modal-title" id="dx-prompt-title"></div>' +
            '<div class="dx-muted" id="dx-prompt-label" style="margin-bottom:8px"></div>' +
            '<div class="dx-row"><input type="text" id="dx-prompt-input" spellcheck="false" dir="auto" style="flex:1">' +
            '<input type="color" id="dx-prompt-color" style="display:none;width:36px;height:34px;border:none;background:none;padding:0"></div>' +
            '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Cancel</div>' +
            '<div class="discord-modal-btn discord-modal-confirm" id="dx-prompt-ok">OK</div></div></div>' +

        '<div class="discord-modal dx-modal-wide" id="dx-modal-roles"><div class="discord-modal-title">Roles &amp; Permissions</div><div id="dx-roles-body"></div>' +
            '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" id="dx-roles-back">Back</div>' +
            '<div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Close</div></div></div>' +

        '<div class="discord-modal dx-modal-wide" id="dx-modal-chperm"><div class="discord-modal-title" id="dx-chperm-title">Channel permissions</div><div id="dx-chperm-body"></div>' +
            '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Close</div></div></div>' +

        '<div class="discord-modal dx-modal-wide" id="dx-modal-invites"><div class="discord-modal-title">Invites</div><div id="dx-invites-body"></div>' +
            '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" id="dx-invites-back">Back</div>' +
            '<div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Close</div></div></div>' +

        '<div class="discord-modal dx-modal-wide" id="dx-modal-welcome"><div class="discord-modal-title" id="dx-welcome-title">Welcome!</div><div id="dx-welcome-body"></div>' +
            '<div class="discord-modal-buttons" id="dx-welcome-buttons"></div></div>' +

        '<div class="discord-modal dx-modal-wide" id="dx-modal-speakers"><div class="discord-modal-title" id="dx-speakers-title">Stage speakers</div><div id="dx-speakers-body"></div>' +
            '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Close</div></div></div>' +

        '<div class="discord-modal dx-modal-wide" id="dx-modal-templates"><div class="discord-modal-title">Server templates</div><div id="dx-templates-body"></div>' +
            '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Close</div></div></div>'
    );

    $(".discord-chat-column").append('<div id="dx-slash-menu"></div>');

    // join modal: longer codes (vanity names) and a hint
    $("#discord-join-code-input").attr({ maxlength: 40, placeholder: "Invite code or discord.gg/name" });

    // create server: "start from a template"
    $("#discord-modal-create-server .discord-modal-buttons").before('<div class="dx-link" id="dx-open-templates">Start from a template instead</div>');

    // create channel: stage toggle
    $("#discord-new-channel-name").after('<label class="dx-check" id="dx-stage-row"><input type="checkbox" id="dx-stage-check"> Stage channel <span class="dx-muted">(only speakers can talk, everyone can react)</span></label>');
}

// ---------------------------------------------------------------------------
// Server menu + Tools additions
// ---------------------------------------------------------------------------

DX_After("Discord_OpenServerMenu", function() {
    var info = DX2_Info();
    var btns = $("#discord-modal-server-menu .discord-modal-buttons");
    if (!$("#dx-nick-btn").length) btns.prepend('<div class="discord-modal-btn discord-modal-confirm" id="dx-nick-btn">Change nickname</div>');
    if (!$("#dx-menu-vanity").length) $("#discord-menu-invite-code").after('<div id="dx-menu-vanity" class="dx-muted"></div>');
    $("#dx-menu-vanity").text(info && info.vanity ? "discord.gg/" + info.vanity : "");
    $("#dx-menu-roles-btn").remove();
    if (info && (info.perms || {}).manage_roles) btns.prepend('<div class="discord-modal-btn discord-modal-confirm" id="dx-menu-roles-btn">Roles &amp; permissions</div>');
    // role-based managers (not the owner) also get "create channel"
    if (info && (info.perms || {}).manage_channels) $("#discord-create-channel-open-btn").css("display", "block");
});
$(document).on("click", "#dx-nick-btn", function() { DX2_ChangeNick(); });
$(document).on("click", "#dx-menu-roles-btn", function() { DX2_OpenRoles(); });

DX_After("DX_RenderTools", function(info) {
    var html = "", p = info.perms || {};
    if (p.manage_roles || p.administrator) {
        html += '<div class="dx-section"><h4>Roles &amp; permissions</h4><div class="dx-muted" style="margin-bottom:8px">Coloured roles, who can talk, pin, moderate... and per-channel overrides (right-click a channel).</div>' +
                '<div class="dx-btn dx-primary" id="dx-open-roles">Manage roles</div></div>';
    }
    if (info.canConfigure) {
        html += '<div class="dx-section"><h4>Invites</h4><div class="dx-muted" style="margin-bottom:8px">Limited-use / expiring links, and a vanity name once the server qualifies.</div>' +
                '<div class="dx-btn dx-primary" id="dx-open-invites">Manage invites</div></div>';
        html += '<div class="dx-section"><h4>Server profile &amp; welcome screen</h4>' +
                '<div class="dx-col"><input type="text" class="dx-input" id="dx-prof-desc" maxlength="200" placeholder="Server description (shown on the server card)" dir="auto">' +
                '<input type="text" class="dx-input" id="dx-prof-title" maxlength="60" placeholder="Welcome title" dir="auto">' +
                '<input type="text" class="dx-input" id="dx-prof-text" maxlength="400" placeholder="Welcome message" dir="auto">' +
                '<textarea class="dx-input dx-textarea" id="dx-prof-rules" maxlength="800" placeholder="Rules (one per line)" dir="auto"></textarea>' +
                '<label class="dx-check"><input type="checkbox" id="dx-prof-require"> New members must accept the rules before they can chat</label>' +
                '<div class="dx-btn dx-primary" id="dx-prof-save">Save</div></div></div>';
    }
    if (info.isOwner && !info.kind) {
        html += '<div class="dx-section"><h4>Template</h4><div class="dx-muted" style="margin-bottom:8px">Save this server\'s channels, roles and settings so anyone can copy it.</div>' +
                '<div class="dx-row"><input type="text" class="dx-input" id="dx-tpl-name" maxlength="40" placeholder="Template name" dir="auto">' +
                '<div class="dx-btn dx-primary" id="dx-tpl-save">Save as template</div></div>' +
                '<label class="dx-check"><input type="checkbox" id="dx-tpl-public" checked> Listed publicly</label></div>';
    }
    if (!html) return;
    $("#dx-tools-body").append(html);
    if (info.canConfigure) {
        var w = info.welcome || {};
        $("#dx-prof-desc").val(info.description || "");
        $("#dx-prof-title").val(w.title || "");
        $("#dx-prof-text").val(w.text || "");
        $("#dx-prof-rules").val(w.rules || "");
        $("#dx-prof-require").prop("checked", !!w.require);
    }
});
$(document).on("click", "#dx-open-roles", function() { DX2_OpenRoles(); });
$(document).on("click", "#dx-open-invites", function() { DX2_OpenInvites(); });
$(document).on("click", "#dx-prof-save", function() {
    DX_Post("DiscordExt_SetWelcome", {
        serverId: Discord.currentServerId, title: $("#dx-prof-title").val(), text: $("#dx-prof-text").val(), rules: $("#dx-prof-rules").val(),
        description: $("#dx-prof-desc").val(), require: $("#dx-prof-require").is(":checked"),
    }, function(ok) { DX_Toast(ok ? "Saved." : "Could not save.", ok ? "success" : "error"); if (ok) DX_LoadInfo(Discord.currentServerId); });
});
$(document).on("click", "#dx-tpl-save", function() {
    var name = $("#dx-tpl-name").val().trim();
    if (!name) { DX_Toast("Give the template a name.", "warn"); return; }
    DX_Post("DiscordExt_CreateTemplate", { serverId: Discord.currentServerId, name: name, description: "", isPublic: $("#dx-tpl-public").is(":checked") }, function(r) {
        if (r && r.ok) { DX2_CopyText(r.code); DX_Toast("Template saved. Code " + r.code + " (copied).", "success"); }
        else DX_Toast(r && r.error === "LIMIT" ? "You reached the template limit." : "Could not save the template.", "error");
    });
});

// ---------------------------------------------------------------------------
// ROLES modal
// ---------------------------------------------------------------------------

function DX2_OpenRoles() {
    if (Discord.currentServerId == null) return;
    Discord_OpenModal("dx-modal-roles");
    $("#dx-roles-body").html('<div class="dx-empty">Loading...</div>');
    DX2_LoadRoles();
}
function DX2_LoadRoles() {
    DX_Post("DiscordExt_GetRoles", { serverId: Discord.currentServerId }, function(r) {
        if (!r) { $("#dx-roles-body").html('<div class="dx-empty">You can\'t manage roles here.</div>'); return; }
        DX2.roles = r;
        var sel = null;
        $.each(r.roles, function(i, x) { if (x.id === DX2.roleSel) sel = x; });
        if (!sel) { DX2.roleSel = null; $.each(r.roles, function(i, x) { if (!x.isDefault && DX2.roleSel == null) DX2.roleSel = x.id; }); if (DX2.roleSel == null) DX2.roleSel = r.roles[0].id; }
        DX2_RenderRoles();
    });
}
function DX2_RoleById(id) { var f = null; $.each(DX2.roles.roles, function(i, r) { if (r.id === id) f = r; }); return f; }

function DX2_RenderRoles() {
    var R = DX2.roles, sel = DX2_RoleById(DX2.roleSel);
    var html = '<div class="dx-chips-row">';
    $.each(R.roles, function(i, r) {
        html += '<div class="dx-role-chip' + (r.id === DX2.roleSel ? " dx-sel" : "") + '" data-roleid="' + r.id + '"><span class="dx-dot" style="background:' + DX_Esc(r.color || "#99AAB5") + '"></span>' + DX_Esc(r.name) + "</div>";
    });
    html += '<div class="dx-role-chip dx-new" id="dx-role-new">+ New role</div></div>';

    if (sel) {
        var ro = !sel.editable;
        html += '<div id="dx-role-editor" data-color="' + DX_Esc(sel.color || "") + '" class="' + (ro ? "dx-readonly" : "") + '">';
        if (sel.isDefault) {
            html += '<div class="dx-muted" style="margin:8px 0">@everyone \u2014 the permissions every member has.</div>';
        } else {
            html += '<div class="dx-row" style="margin-top:10px"><input type="text" class="dx-input" id="dx-role-name" maxlength="32" value="' + DX_Esc(sel.name) + '" dir="auto"' + (ro ? " disabled" : "") + "></div>";
            html += '<div class="dx-swatches" style="margin:8px 0">';
            $.each(DX2.palette.slice(0, 11), function(i, c) { html += '<div class="dx-swatch' + (sel.color && sel.color.toLowerCase() === c.toLowerCase() ? " dx-selected" : "") + '" data-rolecolor="' + c + '" style="background:' + c + '"></div>'; });
            html += '<input type="color" id="dx-role-color-custom" value="' + (sel.color || "#99AAB5") + '" style="width:30px;height:26px;border:none;background:none;padding:0"><div class="dx-swatch dx-swatch-clear" data-rolecolor="" title="No colour">&times;</div></div>';
            html += '<label class="dx-check"><input type="checkbox" id="dx-role-mentionable"' + (sel.mentionable ? " checked" : "") + (ro ? " disabled" : "") + "> Anyone can @mention this role</label>";
        }
        html += '<h4 style="margin:12px 0 6px">Permissions</h4><div class="dx-perms">';
        $.each(R.permList, function(i, p) {
            html += '<label class="dx-perm' + (p.key === "administrator" ? " dx-perm-admin" : "") + '"><input type="checkbox" data-perm="' + p.key + '"' + (sel.perms[p.key] ? " checked" : "") + (ro ? " disabled" : "") + "> " + DX_Esc(p.label) + "</label>";
        });
        html += "</div>";
        if (!sel.isDefault) {
            var assigned = R.assign[String(sel.id)] || [];
            html += '<h4 style="margin:12px 0 6px">Members</h4><input type="text" class="dx-input" id="dx-role-member-search" placeholder="Search members" dir="auto" style="width:100%;margin-bottom:6px"><div class="dx-member-pick" id="dx-role-members">';
            $.each(R.members, function(i, m) {
                html += '<label class="dx-member-row" data-name="' + DX_Esc(m.nickname.toLowerCase()) + '"><input type="checkbox" data-memberid="' + m.id + '"' + (assigned.indexOf(m.id) >= 0 ? " checked" : "") + (ro ? " disabled" : "") + "> " + DX_Esc(m.nickname) + "</label>";
            });
            html += "</div>";
        }
        if (!ro) {
            html += '<div class="dx-row" style="margin-top:12px"><div class="dx-btn dx-primary" id="dx-role-save">Save</div>';
            if (!sel.isDefault) {
                html += '<div class="dx-btn dx-danger" id="dx-role-delete">Delete</div>';
                if (R.isFull) html += '<div class="dx-btn" id="dx-role-up" title="Higher rank">\u25B2</div><div class="dx-btn" id="dx-role-down" title="Lower rank">\u25BC</div>';
            }
            html += "</div>";
        } else {
            html += '<div class="dx-muted" style="margin-top:10px">This role is above yours \u2014 you can view it but not change it.</div>';
        }
        html += "</div>";
    }
    $("#dx-roles-body").html(html);
}

$(document).on("click", ".dx-role-chip[data-roleid]", function() { DX2.roleSel = parseInt($(this).attr("data-roleid"), 10); DX2_RenderRoles(); });
$(document).on("click", "#dx-roles-back", function() { DX_OpenTools(); });
$(document).on("click", "#dx-role-new", function() {
    DX2_Prompt({ title: "New role", label: "Name and colour", max: 32, color: "#5865F2", cb: function(name, color) {
        if (!name) return;
        DX_Post("DiscordExt_CreateRole", { serverId: Discord.currentServerId, name: name, color: color }, function(r) {
            if (r && r.ok) { DX2.roleSel = r.id; DX2_OpenRoles(); }
            else DX_Toast(r && r.error === "LIMIT" ? "Too many roles." : "Could not create the role.", "error");
        });
    } });
});
$(document).on("click", "[data-rolecolor]", function() {
    var c = $(this).attr("data-rolecolor");
    $("#dx-role-editor").attr("data-color", c);
    $("[data-rolecolor]").removeClass("dx-selected");
    $(this).addClass("dx-selected");
});
$(document).on("input change", "#dx-role-color-custom", function() { $("#dx-role-editor").attr("data-color", $(this).val()); $("[data-rolecolor]").removeClass("dx-selected"); });
$(document).on("input", "#dx-role-member-search", function() {
    var q = $(this).val().toLowerCase();
    $("#dx-role-members .dx-member-row").each(function() { $(this).toggle(!q || $(this).attr("data-name").indexOf(q) >= 0); });
});
$(document).on("click", "#dx-role-save", function() {
    var perms = {};
    $("#dx-role-editor [data-perm]").each(function() { if ($(this).is(":checked")) perms[$(this).attr("data-perm")] = true; });
    var data = { perms: perms };
    var sel = DX2_RoleById(DX2.roleSel);
    if (sel && !sel.isDefault) { data.name = $("#dx-role-name").val(); data.color = $("#dx-role-editor").attr("data-color") || ""; data.mentionable = $("#dx-role-mentionable").is(":checked"); }
    DX_Post("DiscordExt_UpdateRole", { serverId: Discord.currentServerId, roleId: DX2.roleSel, data: data }, function(r) {
        if (r && r.ok) { DX_Toast("Role saved.", "success"); DX2_LoadRoles(); }
        else DX_Toast(r && r.error === "CANT_GRANT" ? "You can't grant a permission you don't have." : "Could not save the role.", "error");
    });
});
$(document).on("click", "#dx-role-delete", function() {
    var btn = $(this);
    if (!btn.data("sure")) { btn.data("sure", true).text("Tap again to delete"); return; }
    DX_Post("DiscordExt_DeleteRole", { serverId: Discord.currentServerId, roleId: DX2.roleSel }, function(ok) {
        if (ok) { DX2.roleSel = null; DX2_LoadRoles(); } else DX_Toast("Could not delete the role.", "error");
    });
});
$(document).on("click", "#dx-role-up, #dx-role-down", function() {
    DX_Post("DiscordExt_MoveRole", { serverId: Discord.currentServerId, roleId: DX2.roleSel, dir: this.id === "dx-role-up" ? 1 : -1 }, function() { DX2_LoadRoles(); });
});
$(document).on("change", "#dx-role-members input[data-memberid]", function() {
    var cb = $(this), on = cb.is(":checked");
    DX_Post("DiscordExt_SetMemberRole", { serverId: Discord.currentServerId, memberId: parseInt(cb.attr("data-memberid"), 10), roleId: DX2.roleSel, on: on }, function(ok) {
        if (!ok) { cb.prop("checked", !on); DX_Toast("You can't change that member's roles.", "error"); return; }
        var key = String(DX2.roleSel), mid = parseInt(cb.attr("data-memberid"), 10), list = DX2.roles.assign[key] || [];
        if (on && list.indexOf(mid) < 0) list.push(mid);
        if (!on) list = list.filter(function(x) { return x !== mid; });
        DX2.roles.assign[key] = list;
    });
});

// ---------------------------------------------------------------------------
// Per-channel permission overrides
// ---------------------------------------------------------------------------

function DX2_OpenChannelPerms(channelId) {
    DX2.cpChannel = channelId;
    Discord_OpenModal("dx-modal-chperm");
    $("#dx-chperm-body").html('<div class="dx-empty">Loading...</div>');
    DX2_LoadChannelPerms();
}
function DX2_LoadChannelPerms() {
    DX_Post("DiscordExt_GetChannelPerms", { serverId: Discord.currentServerId, channelId: DX2.cpChannel }, function(r) {
        if (!r) { $("#dx-chperm-body").html('<div class="dx-empty">You can\'t edit this channel.</div>'); return; }
        DX2.cp = r;
        if (DX2.cpRole == null || !r.roles.some(function(x) { return x.id === DX2.cpRole; })) DX2.cpRole = r.roles[0].id;
        DX2_RenderChannelPerms();
    });
}
function DX2_RenderChannelPerms() {
    var r = DX2.cp;
    $("#dx-chperm-title").text("#" + r.channel.name + " \u2014 permissions");
    var html = '<div class="dx-muted" style="margin-bottom:6px">Overrides for this channel only. \u2715 deny \u00B7 \u2022 inherit \u00B7 \u2713 allow</div><div class="dx-chips-row">';
    $.each(r.roles, function(i, x) {
        html += '<div class="dx-role-chip' + (x.id === DX2.cpRole ? " dx-sel" : "") + '" data-cproleid="' + x.id + '"><span class="dx-dot" style="background:' + DX_Esc(x.color || "#99AAB5") + '"></span>' + DX_Esc(x.name) + "</div>";
    });
    html += "</div>";
    var o = r.overrides[String(DX2.cpRole)] || { allow: [], deny: [] };
    $.each(r.permList, function(i, p) {
        var st = o.allow.indexOf(p.key) >= 0 ? "allow" : (o.deny.indexOf(p.key) >= 0 ? "deny" : "inherit");
        html += '<div class="dx-tri-row"><span>' + DX_Esc(p.label) + '</span><span class="dx-tri" data-perm="' + p.key + '">' +
                '<b class="' + (st === "deny" ? "dx-on dx-no" : "") + '" data-state="deny">\u2715</b>' +
                '<b class="' + (st === "inherit" ? "dx-on" : "") + '" data-state="inherit">\u2022</b>' +
                '<b class="' + (st === "allow" ? "dx-on dx-yes" : "") + '" data-state="allow">\u2713</b></span></div>';
    });
    $("#dx-chperm-body").html(html);
}
$(document).on("click", ".dx-role-chip[data-cproleid]", function() { DX2.cpRole = parseInt($(this).attr("data-cproleid"), 10); DX2_RenderChannelPerms(); });
$(document).on("click", ".dx-tri b", function() {
    var perm = $(this).parent().attr("data-perm"), state = $(this).attr("data-state");
    var o = DX2.cp.overrides[String(DX2.cpRole)] || { allow: [], deny: [] };
    o = { allow: o.allow.filter(function(k) { return k !== perm; }), deny: o.deny.filter(function(k) { return k !== perm; }) };
    if (state === "allow") o.allow.push(perm);
    if (state === "deny") o.deny.push(perm);
    DX_Post("DiscordExt_SetChannelPerm", { serverId: Discord.currentServerId, channelId: DX2.cpChannel, roleId: DX2.cpRole, allow: o.allow, deny: o.deny }, function(ok) {
        if (!ok) { DX_Toast("Could not change that.", "error"); return; }
        if (o.allow.length || o.deny.length) DX2.cp.overrides[String(DX2.cpRole)] = o; else delete DX2.cp.overrides[String(DX2.cpRole)];
        DX2_RenderChannelPerms();
    });
});

// ---------------------------------------------------------------------------
// Invites + vanity
// ---------------------------------------------------------------------------

function DX2_OpenInvites() {
    if (Discord.currentServerId == null) return;
    Discord_OpenModal("dx-modal-invites");
    $("#dx-invites-body").html('<div class="dx-empty">Loading...</div>');
    DX2_LoadInvites();
}
function DX2_LoadInvites() {
    DX_Post("DiscordExt_ListInvites", { serverId: Discord.currentServerId }, function(r) {
        if (!r) { $("#dx-invites-body").html('<div class="dx-empty">You can\'t manage invites here.</div>'); return; }
        var html = '<div class="dx-section"><h4>Permanent code</h4><div class="dx-row dx-spread"><b style="letter-spacing:.1em">' + DX_Esc(r.main || "-") + '</b><div class="dx-btn" data-copy="' + DX_Esc(r.main) + '">Copy</div></div></div>';

        html += '<div class="dx-section"><h4>Vanity invite</h4>';
        if (r.vanityEligible) {
            html += '<div class="dx-row"><span class="dx-muted">discord.gg/</span><input type="text" class="dx-input" id="dx-vanity-input" maxlength="24" value="' + DX_Esc(r.vanity || "") + '" placeholder="mycity" spellcheck="false"><div class="dx-btn dx-primary" id="dx-vanity-save">Save</div></div>' +
                    '<div class="dx-muted" style="margin-top:4px">Letters, numbers and dashes, 3\u201324 characters. Leave empty to remove.</div>';
        } else {
            html += '<div class="dx-muted">Unlocks for verified servers and at boost level ' + r.vanityRule + '.</div>';
        }
        html += "</div>";

        html += '<div class="dx-section"><h4>Create a link</h4><div class="dx-row"><select class="dx-input" id="dx-inv-uses" style="flex:1">';
        $.each(r.maxUses, function(i, n) { html += '<option value="' + n + '">' + (n === 0 ? "Unlimited uses" : n + (n === 1 ? " use" : " uses")) + "</option>"; });
        html += '</select><select class="dx-input" id="dx-inv-exp" style="flex:1">';
        $.each(r.expireMinutes, function(i, m) { html += '<option value="' + m + '">' + (m === 0 ? "Never expires" : m < 1440 ? (m / 60) + " hour" + (m === 60 ? "" : "s") : (m / 1440) + " day" + (m === 1440 ? "" : "s")) + "</option>"; });
        html += '</select><div class="dx-btn dx-primary" id="dx-inv-create">Create</div></div></div>';

        html += '<div class="dx-section"><h4>Active links (' + r.invites.length + ")</h4>";
        if (!r.invites.length) html += '<div class="dx-muted">None yet.</div>';
        $.each(r.invites, function(i, inv) {
            var dead = (inv.expires_at && inv.expires_at <= r.now) || (inv.max_uses > 0 && inv.uses >= inv.max_uses);
            html += '<div class="dx-invite-row' + (dead ? " dx-dead" : "") + '"><b>' + DX_Esc(inv.code) + '</b><span class="dx-muted">' + inv.uses + "/" + (inv.max_uses || "\u221E") + " \u00B7 " +
                    (inv.expires_at ? DX2_Until(inv.expires_at) : "no expiry") + " \u00B7 " + DX_Esc(inv.created_by) + '</span><span class="dx-inv-actions"><i class="fas fa-copy" data-copy="' + DX_Esc(inv.code) + '" title="Copy"></i>' +
                    '<i class="fas fa-trash" data-revoke="' + inv.id + '" title="Revoke"></i></span></div>';
        });
        html += "</div>";
        $("#dx-invites-body").html(html);
    });
}
$(document).on("click", "#dx-invites-back", function() { DX_OpenTools(); });
$(document).on("click", "[data-copy]", function() { DX2_CopyText($(this).attr("data-copy")); DX_Toast("Copied.", "info"); });
$(document).on("click", "#dx-inv-create", function() {
    DX_Post("DiscordExt_CreateInvite", { serverId: Discord.currentServerId, maxUses: parseInt($("#dx-inv-uses").val(), 10), expireMinutes: parseInt($("#dx-inv-exp").val(), 10) }, function(r) {
        if (r && r.ok) { DX2_CopyText(r.code); DX_Toast("Invite " + r.code + " created and copied.", "success"); DX2_LoadInvites(); }
        else DX_Toast(r && r.error === "LIMIT" ? "Too many active invites." : "Could not create the invite.", "error");
    });
});
$(document).on("click", "[data-revoke]", function() {
    DX_Post("DiscordExt_RevokeInvite", { serverId: Discord.currentServerId, inviteId: parseInt($(this).attr("data-revoke"), 10) }, function() { DX2_LoadInvites(); });
});
$(document).on("click", "#dx-vanity-save", function() {
    DX_Post("DiscordExt_SetVanity", { serverId: Discord.currentServerId, code: $("#dx-vanity-input").val() }, function(r) {
        if (r && r.ok) { DX_Toast(r.vanity ? "Vanity link: discord.gg/" + r.vanity : "Vanity link removed.", "success"); DX_LoadInfo(Discord.currentServerId); DX2_LoadInvites(); }
        else DX_Toast(r && r.error === "TAKEN" ? "That name is taken." : r && r.error === "BAD_FORMAT" ? "Use 3\u201324 letters, numbers or dashes." : r && r.error === "NOT_ELIGIBLE" ? "This server can't use a vanity link yet." : "Could not set it.", "error");
    });
});

// ---------------------------------------------------------------------------
// Welcome screen + rules
// ---------------------------------------------------------------------------

function DX2_OpenWelcome(serverId, force) {
    var info = DX2_Info(serverId);
    if (!info) return;
    var w = info.welcome || {};
    if (!w.text && !w.rules) { if (force) DX_Toast("This server has no welcome screen.", "info"); return; }
    var server = Discord_FindServer(serverId);
    $("#dx-welcome-title").text(w.title || ("Welcome to " + (server ? server.name : "the server")));
    var html = "";
    if (w.text) html += '<div class="dx-welcome-text">' + DX_Esc(w.text) + "</div>";
    if (w.rules) {
        html += '<h4 style="margin:12px 0 6px">Rules</h4><ol class="dx-rules">';
        $.each(String(w.rules).split(/\n+/), function(i, line) { line = line.trim(); if (line) html += "<li>" + DX_Esc(line.replace(/^\d+[.)-]\s*/, "")) + "</li>"; });
        html += "</ol>";
    }
    var needsAccept = info.mustAccept && !DX2.accepted[serverId];
    var askAccept = info.showWelcome && !DX2.accepted[serverId];
    if (askAccept) html += '<label class="dx-check" style="margin-top:10px"><input type="checkbox" id="dx-welcome-check"> I have read and agree to the rules</label>';
    $("#dx-welcome-body").html(html);
    $("#dx-welcome-buttons").html(askAccept
        ? (needsAccept ? "" : '<div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Later</div>') + '<div class="discord-modal-btn discord-modal-confirm dx-disabled" id="dx-welcome-accept" data-serverid="' + serverId + '">Accept</div>'
        : '<div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Close</div>');
    Discord_OpenModal("dx-modal-welcome");
}
$(document).on("change", "#dx-welcome-check", function() { $("#dx-welcome-accept").toggleClass("dx-disabled", !$(this).is(":checked")); });
$(document).on("click", "#dx-welcome-accept", function() {
    if ($(this).hasClass("dx-disabled")) return;
    var sid = parseInt($(this).attr("data-serverid"), 10);
    DX_Post("DiscordExt_AcceptRules", { serverId: sid }, function(ok) {
        if (!ok) { DX_Toast("Could not save that.", "error"); return; }
        DX2.accepted[sid] = true;
        var info = DX2_Info(sid); if (info) info.showWelcome = false;
        Discord_CloseModals();
        Discord_UpdateComposerLock();
        DX_Toast("Welcome aboard!", "success");
    });
});

// ---------------------------------------------------------------------------
// Stage channels: create (checkbox in the create-channel modal) + speakers
// ---------------------------------------------------------------------------

document.addEventListener("click", function(e) {
    var btn = $(e.target).closest("#discord-confirm-create-channel");
    if (!btn.length || !$("#dx-stage-check").is(":checked")) return;
    e.stopPropagation(); e.preventDefault();
    var name = $("#discord-new-channel-name").val().trim();
    if (!name) { Discord_ShowModalError("discord-modal-create-channel", "Enter a channel name."); return; }
    DX_Post("DiscordExt_CreateStageChannel", { serverId: Discord.currentServerId, name: name }, function(r) {
        if (!r || !r.id) { Discord_ShowModalError("discord-modal-create-channel", "Could not create the channel."); return; }
        $("#dx-stage-check").prop("checked", false);
        Discord_CloseModals();
        DX2_ReloadChannels();
    });
}, true);

function DX2_OpenSpeakers(channelId) {
    DX2.speakerChannel = channelId;
    Discord_OpenModal("dx-modal-speakers");
    $("#dx-speakers-body").html('<div class="dx-empty">Loading...</div>');
    DX_Post("DiscordExt_GetSpeakers", { serverId: Discord.currentServerId, channelId: channelId }, function(r) {
        if (!r) { $("#dx-speakers-body").html('<div class="dx-empty">You can\'t manage speakers here.</div>'); return; }
        $("#dx-speakers-title").text("#" + r.channel.name + " \u2014 speakers");
        var html = '<div class="dx-muted" style="margin-bottom:8px">Owner and admins can always talk. Tick the people who may speak; everyone else can only react.</div><div class="dx-member-pick">';
        $.each(r.members, function(i, m) { html += '<label class="dx-member-row"><input type="checkbox" data-speaker="' + m.id + '"' + (m.speaker ? " checked" : "") + "> " + DX_Esc(m.nickname) + "</label>"; });
        $("#dx-speakers-body").html(html + "</div>");
    });
}
$(document).on("change", "[data-speaker]", function() {
    var cb = $(this), on = cb.is(":checked");
    DX_Post("DiscordExt_SetSpeaker", { serverId: Discord.currentServerId, channelId: DX2.speakerChannel, memberId: parseInt(cb.attr("data-speaker"), 10), on: on }, function(ok) {
        if (!ok) { cb.prop("checked", !on); DX_Toast("Could not change that.", "error"); }
    });
});

// ---------------------------------------------------------------------------
// Templates
// ---------------------------------------------------------------------------

function DX2_OpenTemplates() {
    Discord_OpenModal("dx-modal-templates");
    $("#dx-templates-body").html('<div class="dx-empty">Loading...</div>');
    DX_Post("DiscordExt_ListTemplates", {}, function(r) {
        if (!r) { $("#dx-templates-body").html('<div class="dx-empty">Could not load.</div>'); return; }
        function row(t, mine) {
            return '<div class="dx-tpl-row"><div><b>' + DX_Esc(t.name) + '</b><div class="dx-muted">' + DX_Esc(t.creator_name) + " \u00B7 " + t.uses + " use" + (t.uses === 1 ? "" : "s") + (t.description ? " \u00B7 " + DX_Esc(t.description) : "") +
                   '</div></div><div class="dx-row"><div class="dx-btn dx-primary" data-usetpl="' + DX_Esc(t.code) + '" data-tplname="' + DX_Esc(t.name) + '">Use</div>' +
                   (mine ? '<div class="dx-btn" data-copy="' + DX_Esc(t.code) + '" title="Copy code">' + DX_Esc(t.code) + '</div><div class="dx-btn dx-danger" data-deltpl="' + t.id + '"><i class="fas fa-trash"></i></div>' : "") + "</div></div>";
        }
        var html = '<div class="dx-section"><h4>Have a code?</h4><div class="dx-row"><input type="text" class="dx-input" id="dx-tpl-code" maxlength="10" placeholder="Template code" spellcheck="false"><div class="dx-btn dx-primary" id="dx-tpl-use-code">Use</div></div></div>';
        html += '<div class="dx-section"><h4>Your templates</h4>';
        html += r.mine.length ? r.mine.map(function(t) { return row(t, true); }).join("") : '<div class="dx-muted">You have none. Open a server you own \u2192 Tools \u2192 Save as template.</div>';
        html += '</div><div class="dx-section"><h4>Public templates</h4>';
        html += r.public.length ? r.public.map(function(t) { return row(t, false); }).join("") : '<div class="dx-muted">Nobody shared a template yet.</div>';
        $("#dx-templates-body").html(html + "</div>");
    });
}
$(document).on("click", "#dx-open-templates", DX2_OpenTemplates);
function DX2_UseTemplate(code, suggestedName) {
    DX2_Prompt({ title: "New server from template", label: "Name your server", value: suggestedName || "", max: 40, cb: function(name) {
        DX_Post("DiscordExt_UseTemplate", { code: code, name: name || suggestedName }, function(r) {
            if (!r || !r.id) { DX_Toast(r && r.error === "NOT_FOUND" ? "No template with that code." : "Could not create the server.", "error"); return; }
            Discord.servers.push(r);
            Discord_CloseModals();
            Discord_SelectServer(r.id);
            DX_Toast("Server created from template.", "success");
        });
    } });
}
$(document).on("click", "[data-usetpl]", function() { DX2_UseTemplate($(this).attr("data-usetpl"), $(this).attr("data-tplname")); });
$(document).on("click", "#dx-tpl-use-code", function() { var c = $("#dx-tpl-code").val().trim(); if (c) DX2_UseTemplate(c, ""); });
$(document).on("click", "[data-deltpl]", function() {
    DX_Post("DiscordExt_DeleteTemplate", { templateId: parseInt($(this).attr("data-deltpl"), 10) }, function() { DX2_OpenTemplates(); });
});

// ---------------------------------------------------------------------------
// Server card (hover / long press on a rail icon, click in Discover)
// ---------------------------------------------------------------------------

function DX2_HideCard() { clearTimeout(DX2.cardTimer); clearTimeout(DX2.cardHide); $("#dx-card").remove(); }

function DX2_ShowCard(serverId, anchorEl) {
    DX2_HideCard();
    DX_Post("DiscordExt_GetServerCard", { serverId: serverId }, function(c) {
        if (!c) return;
        DX2_HideCard();
        var bd = DX2_Backdrop(), rect = bd[0].getBoundingClientRect();
        var a = anchorEl && anchorEl[0] ? anchorEl[0].getBoundingClientRect() : { right: rect.left + 80, top: rect.top + 80, left: rect.left + 20, bottom: rect.top + 100 };
        var accent = c.theme || c.icon_color;
        var badges = "";
        if (c.isVerified) badges += '<span class="dx-card-tag"><i class="fas fa-check-circle"></i> Verified</span>';
        if (c.isFeatured) badges += '<span class="dx-card-tag dx-vip"><i class="fas fa-star"></i> VIP</span>';
        if (c.boostLevel > 0) badges += '<span class="dx-card-tag dx-boost"><i class="fas fa-gem"></i> BOOSTED L' + c.boostLevel + "</span>";
        if (c.kind) badges += '<span class="dx-card-tag">' + (c.kind === "gang" ? "Gang" : "Official") + "</span>";
        var buttons = "";
        if (c.isMember) {
            buttons += '<div class="dx-btn dx-primary" data-cardopen="' + c.id + '">Open</div>';
            if (c.canLeave) buttons += '<div class="dx-btn dx-danger" data-cardleave="' + c.id + '">Leave</div>';
        } else {
            buttons += '<div class="dx-btn dx-primary" data-cardjoin="' + c.id + '">Join</div>';
        }
        var html = '<div id="dx-card"><div class="dx-card-banner" style="background:linear-gradient(135deg,' + DX_Esc(accent) + ',' + DX_Esc(c.icon_color) + ')"></div>' +
                   '<div class="dx-card-icon" style="background:' + DX_Esc(c.icon_color) + '">' + DX_Esc(c.icon_text) + "</div>" +
                   '<div class="dx-card-body"><div class="dx-card-name">' + DX_Esc(c.name) + '</div><div class="dx-card-tags">' + badges + "</div>" +
                   '<div class="dx-card-desc">' + (c.description ? DX_Esc(c.description) : '<span class="dx-muted">No description yet.</span>') + "</div>" +
                   '<div class="dx-card-stats"><span><i class="fas fa-circle" style="color:#3ba55d;font-size:8px"></i> ' + c.onlineCount + ' online</span><span><i class="fas fa-circle" style="color:#747f8d;font-size:8px"></i> ' + c.memberCount + " member" + (c.memberCount === 1 ? "" : "s") + "</span></div>" +
                   (c.vanity ? '<div class="dx-muted" style="margin-top:4px">discord.gg/' + DX_Esc(c.vanity) + "</div>" : "") +
                   '<div class="dx-row" style="margin-top:10px">' + buttons + "</div></div></div>";
        var card = $(html).appendTo(bd);
        var w = card.outerWidth(), h = card.outerHeight();
        var left = Math.min(Math.max(4, a.right - rect.left + 8), rect.width - w - 4);
        var top = Math.min(Math.max(4, a.top - rect.top), rect.height - h - 4);
        card.css({ left: left, top: top });
        card.on("mouseenter", function() { clearTimeout(DX2.cardHide); });
        card.on("mouseleave", function() { DX2.cardHide = setTimeout(DX2_HideCard, 350); });
    });
}

$(document).on("mouseenter", "#discord-server-rail-list .discord-rail-icon[data-serverid]", function() {
    var el = $(this), sid = parseInt(el.attr("data-serverid"), 10);
    clearTimeout(DX2.cardTimer); clearTimeout(DX2.cardHide);
    DX2.cardTimer = setTimeout(function() { DX2_ShowCard(sid, el); }, 700);
});
$(document).on("mouseleave", "#discord-server-rail-list .discord-rail-icon[data-serverid]", function() {
    clearTimeout(DX2.cardTimer);
    DX2.cardHide = setTimeout(DX2_HideCard, 350);
});
$(document).on("click", ".discord-discover-icon, .discord-discover-name", function(e) {
    var item = $(this).closest(".discord-discover-item");
    var sid = parseInt(item.find(".discord-discover-join-btn").attr("data-serverid"), 10);
    if (sid) { e.stopPropagation(); DX2_ShowCard(sid, item.find(".discord-discover-icon")); }
});
$(document).on("click", "[data-cardopen]", function() {
    var sid = parseInt($(this).attr("data-cardopen"), 10);
    DX2_HideCard();
    if (sid !== Discord.currentServerId) Discord_SelectServer(sid);
});
$(document).on("click", "[data-cardleave]", function() {
    var btn = $(this), sid = parseInt(btn.attr("data-cardleave"), 10);
    if (!btn.data("sure")) { btn.data("sure", true).text("Tap again to leave"); return; }
    Discord_Post("LeaveDiscordServer", { serverId: sid });
    Discord.servers = Discord.servers.filter(function(s) { return s.id !== sid; });
    DX2_HideCard();
    if (Discord.currentServerId === sid) {
        if (Discord.servers.length > 0) Discord_SelectServer(Discord.servers[0].id); else Discord_HandleServerDeleted({ serverId: sid });
    } else Discord_RenderServerRail();
});
$(document).on("click", "[data-cardjoin]", function() {
    var sid = parseInt($(this).attr("data-cardjoin"), 10);
    Discord_Post("JoinDiscordPublicServer", { serverId: sid }, function(result) {
        if (!result || result.error) { DX_Toast(result && result.error === "ALREADY_MEMBER" ? "You are already in that server." : "Could not join.", "warn"); return; }
        Discord.servers.push(result);
        DX2_HideCard();
        Discord_CloseModals();
        Discord_SelectServer(result.id);
    });
});

// ---------------------------------------------------------------------------
// Server folders (server rail)
// ---------------------------------------------------------------------------

function DX2_FolderById(id) { var f = { servers: [] }; $.each(DX2.folders, function(i, x) { if (x.id === id) f = x; }); return f; }
function DX2_FolderOf(serverId) { var f = null; $.each(DX2.folders, function(i, x) { if (x.servers.indexOf(serverId) >= 0) f = x; }); return f; }

function DX2_LoadFolders() {
    DX_Post("DiscordExt_GetFolders", {}, function(list) { DX2.folders = list || []; DX2.foldersLoaded = true; Discord_RenderServerRail(); });
}
function DX2_SetFolders(list) { if (list) { DX2.folders = list; Discord_RenderServerRail(); } }

function DX2_ApplyFolders() {
    var list = $("#discord-server-rail-list");
    if (!list.length) return;
    list.find(".dx-folder").each(function() { $(this).find(".discord-rail-icon").insertBefore($(this)); $(this).remove(); });
    $.each(DX2.folders, function(i, f) {
        var icons = [];
        $.each(f.servers, function(j, sid) {
            var el = list.find('.discord-rail-icon[data-serverid="' + sid + '"]');
            if (el.length) icons.push(el);
        });
        if (!icons.length) return;
        var hasSel = icons.some(function(el) { return el.hasClass("selected-discord-server"); });
        var open = !!DX2.openFolders[f.id];
        var minis = "";
        $.each(icons.slice(0, 4), function(j, el) { minis += '<span class="dx-mini" style="background:' + DX_Esc(el.css("background-color")) + '">' + DX_Esc(el.clone().children().remove().end().text().trim().charAt(0)) + "</span>"; });
        var wrap = $('<div class="dx-folder' + (open ? " dx-open" : "") + (hasSel ? " dx-has-sel" : "") + '" data-folderid="' + f.id + '" style="--fc:' + DX_Esc(f.color) + '">' +
                     '<div class="dx-folder-head" title="' + DX_Esc(f.name) + '"><div class="dx-folder-minis">' + minis + '</div><i class="fas fa-folder-open dx-folder-ico"></i><div class="dx-folder-badge"></div></div>' +
                     '<div class="dx-folder-items"></div></div>');
        icons[0].before(wrap);
        $.each(icons, function(j, el) { el.appendTo(wrap.find(".dx-folder-items")); });
    });
    DX_ApplyUnreadUI();
}
DX_After("Discord_RenderServerRail", DX2_ApplyFolders);

$(document).on("click", ".dx-folder-head", function() {
    var f = $(this).closest(".dx-folder"), id = parseInt(f.attr("data-folderid"), 10);
    DX2.openFolders[id] = !DX2.openFolders[id];
    f.toggleClass("dx-open", !!DX2.openFolders[id]);
    DX_ApplyUnreadUI();
});

function DX2_NewFolderFor(serverId) {
    DX2_Prompt({ title: "New folder", label: "Name and colour", value: "", max: 24, color: "#5865F2", cb: function(name, color) {
        DX_Post("DiscordExt_CreateFolder", { name: name || "Folder", color: color, serverId: serverId }, function(list) {
            if (!list) { DX_Toast("Could not create the folder.", "error"); return; }
            DX2_SetFolders(list);
        });
    } });
}

DX2_BindContext("#discord-server-rail-list .discord-rail-icon[data-serverid]", function(el, x, y) {
    var sid = parseInt(el.attr("data-serverid"), 10), muted = DX2_SvMuted(sid), cur = DX2_FolderOf(sid);
    var items = [
        { label: "Server info", icon: "fa-id-card", fn: function() { DX2_ShowCard(sid, el); } },
        { label: muted ? "Unmute server" : "Mute server", icon: muted ? "fa-bell" : "fa-bell-slash", fn: function() { DX2_SetMute("server", sid, !muted); } },
        { label: "Mark as read", icon: "fa-check", fn: function() { DX2_MarkServerRead(sid); } },
        { sep: true },
    ];
    $.each(DX2.folders.slice(0, 8), function(i, f) {
        if (cur && cur.id === f.id) return;
        items.push({ label: "Move to \u201C" + f.name + "\u201D", icon: "fa-folder", fn: function() {
            DX_Post("DiscordExt_MoveToFolder", { serverId: sid, folderId: f.id }, DX2_SetFolders);
        } });
    });
    items.push({ label: "New folder\u2026", icon: "fa-folder-plus", fn: function() { DX2_NewFolderFor(sid); } });
    if (cur) items.push({ label: "Remove from folder", icon: "fa-folder-minus", fn: function() { DX_Post("DiscordExt_MoveToFolder", { serverId: sid, folderId: 0 }, DX2_SetFolders); } });
    DX2_Ctx(x, y, items);
});

DX2_BindContext(".dx-folder-head", function(el, x, y) {
    var id = parseInt(el.closest(".dx-folder").attr("data-folderid"), 10), f = DX2_FolderById(id);
    DX2_Ctx(x, y, [
        { label: "Rename / colour", icon: "fa-pen", fn: function() {
            DX2_Prompt({ title: "Edit folder", label: "Name and colour", value: f.name, max: 24, color: f.color, cb: function(name, color) {
                DX_Post("DiscordExt_EditFolder", { folderId: id, name: name, color: color }, DX2_SetFolders);
            } });
        } },
        { label: "Delete folder", icon: "fa-trash", danger: true, fn: function() { DX_Post("DiscordExt_DeleteFolder", { folderId: id }, DX2_SetFolders); } },
    ]);
});

DX2_BindContext(".discord-channel-item[data-channelid]", function(el, x, y) {
    var cid = parseInt(el.attr("data-channelid"), 10), ch = Discord_FindChannel(cid), muted = DX2_ChMuted(cid), p = DX2_Perms();
    var items = [
        { label: muted ? "Unmute channel" : "Mute channel", icon: muted ? "fa-bell" : "fa-bell-slash", fn: function() { DX2_SetMute("channel", cid, !muted); } },
        { label: "Mark as read", icon: "fa-check", fn: function() { if (DX.unread[cid]) { delete DX.unread[cid]; DX_ApplyUnreadUI(); } DX_Post("DiscordExt_EnterChannel", { channelId: cid }); } },
    ];
    if (p.manage_roles || p.manage_channels || p.administrator) {
        items.push({ sep: true });
        items.push({ label: "Edit permissions", icon: "fa-lock", fn: function() { DX2_OpenChannelPerms(cid); } });
        if (ch && ch.kind === "stage") items.push({ label: "Manage speakers", icon: "fa-microphone", fn: function() { DX2_OpenSpeakers(cid); } });
    }
    DX2_Ctx(x, y, items);
});

// ---------------------------------------------------------------------------
// Boot
// ---------------------------------------------------------------------------

$(function() { DX2_BuildUI(); });
