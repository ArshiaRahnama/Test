// ============================================================================
// Discord v12 — polish. Loaded LAST (after discord_social.js, needs
// discord_emoji_data.js for the emoji picker).
//   * real tooltips (CEF shows no native title="" bubbles)
//   * message toolbar like Discord + right-click menus on messages / people
//   * full emoji picker (search, categories, recents, server emoji)
//   * multi-line composer (Shift+Enter), @mention + :emoji: autocomplete
//   * profile popout next to the clicked name, status popout on the user panel
//   * "N new messages" bar, "Jump to present", no more yanking while reading
//   * channel topics + edit channel, Ctrl+K quick switcher, themes
//   * Up-arrow edits your last message, typing dots, inline edit hint
// ============================================================================

var DXP = {
    tipTimer: null, anchor: null, recents: [], theme: "dark",
    acSel: 0, acKind: null, acItems: [],
    emojiHtml: null, emojiMode: null,
    keepPos: false, newBelow: 0, bar: null,
    switcher: { items: [], sel: 0 },
};
try { DXP.recents = JSON.parse(localStorage.getItem("dxp_recent") || "[]").slice(0, 24); } catch (e) {}
try { DXP.theme = localStorage.getItem("dxp_theme") || "dark"; } catch (e) {}

function DXP_Bd() { return $("#discord-backdrop"); }

// ---------------------------------------------------------------------------
// Tooltips
// ---------------------------------------------------------------------------

function DXP_HideTip() { clearTimeout(DXP.tipTimer); $("#dx-tip").removeClass("dx-show"); }

$(document).on("mouseover", "#discord-backdrop [title], #discord-backdrop [data-dxtip]", function(e) {
    var el = $(e.target).closest("[title],[data-dxtip]")[0];
    if (!el || el === DXP.tipEl) return;
    var text = el.getAttribute("data-dxtip") || el.getAttribute("title");
    if (!text) return;
    if (el.hasAttribute("title")) { el.setAttribute("data-dxtip", text); el.removeAttribute("title"); }
    DXP.tipEl = el;
    clearTimeout(DXP.tipTimer);
    DXP.tipTimer = setTimeout(function() { DXP_ShowTip(el, text); }, 280);
});
$(document).on("mouseout", "#discord-backdrop [data-dxtip]", function(e) {
    if ($(e.relatedTarget).closest("[data-dxtip]")[0] === DXP.tipEl) return;
    DXP.tipEl = null; DXP_HideTip();
});
$(document).on("mousedown click scroll", "#discord-backdrop", function() { DXP.tipEl = null; DXP_HideTip(); });

function DXP_ShowTip(el, text) {
    if (!document.body.contains(el)) return;
    var bd = DXP_Bd(), tip = $("#dx-tip");
    if (!tip.length) tip = $('<div id="dx-tip"><div class="dx-tip-arrow"></div><div class="dx-tip-text"></div></div>').appendTo(bd);
    tip.find(".dx-tip-text").text(text);
    var side = el.getAttribute("data-dxtip-pos") || ($(el).closest(".discord-rail").length ? "right" : $(el).closest(".discord-chat-header, .discord-user-footer").length ? ($(el).closest(".discord-user-footer").length ? "top" : "bottom") : "top");
    tip.attr("data-side", side).addClass("dx-show").css({ left: 0, top: 0 });
    var r = el.getBoundingClientRect(), b = bd[0].getBoundingClientRect(), tw = tip.outerWidth(), th = tip.outerHeight(), gap = 10;
    var x, y;
    if (side === "right") { x = r.right - b.left + gap; y = r.top - b.top + r.height / 2 - th / 2; }
    else if (side === "bottom") { x = r.left - b.left + r.width / 2 - tw / 2; y = r.bottom - b.top + gap; }
    else { x = r.left - b.left + r.width / 2 - tw / 2; y = r.top - b.top - th - gap; }
    x = Math.max(6, Math.min(x, b.width - tw - 6)); y = Math.max(6, Math.min(y, b.height - th - 6));
    tip.css({ left: x, top: y });
    var ax = Math.max(10, Math.min(tw - 10, r.left - b.left + r.width / 2 - x));
    tip.find(".dx-tip-arrow").css(side === "right" ? { top: Math.max(8, th / 2 - 5), left: "" } : { left: ax - 5, top: "" });
}

// rail icons get their server name as tooltip
DX_After("Discord_RenderServerRail", function() {
    $(".discord-rail-icon[data-serverid]").each(function() {
        var s = Discord_FindServer(parseInt($(this).attr("data-serverid"), 10));
        if (s) $(this).attr("data-dxtip", s.name).removeAttr("title");
    });
});

// ---------------------------------------------------------------------------
// Message toolbar + context menus
// ---------------------------------------------------------------------------

(function() {
    var orig = window.Discord_RenderMessageActionsHTML;
    window.Discord_RenderMessageActionsHTML = function(msg) {
        var html = orig(msg);
        // keep every original icon (their handlers keep working) but show only Discord's set;
        // the rest is reached through "More" / the right-click menu.
        html = html.replace(/<div class="discord-message-actions">/, '<div class="discord-message-actions">' +
            '<i class="dx-quick" data-dxquick="1" data-dxtip="' + DX_Esc(DXP.recents[0] || "\uD83D\uDC4D") + '">' + DX_Esc(DXP.recents[0] || "\uD83D\uDC4D") + '</i>');
        html = html.replace(/<\/div>\s*$/, '<i class="fas fa-ellipsis-h" data-dxmore="1" title="More"></i></div>');
        return html;
    };
})();

function DXP_MsgActions(row) {
    var map = {};
    row.find(".discord-message-actions i[data-action]").each(function() { map[$(this).attr("data-action")] = $(this); });
    return map;
}
function DXP_Fire(row, action) {
    var el = row.find('.discord-message-actions i[data-action="' + action + '"]');
    if (el.length) el.trigger("click");
}

function DXP_MessageMenu(row, x, y, fromBar) {
    var id = parseInt(row.attr("data-messageid"), 10), msg = Discord.messagesById[id];
    if (!msg || row.hasClass("discord-message-announcement") && !msg) return;
    var acts = DXP_MsgActions(row), items = [];
    if (acts.react) items.push({ label: "Add Reaction", icon: "fa-smile", fn: function() { acts.react.trigger("click"); } });
    if (acts.edit) items.push({ label: "Edit Message", icon: "fa-pen", fn: function() { acts.edit.trigger("click"); } });
    if (acts.pin) items.push({ label: msg.is_pinned ? "Unpin Message" : "Pin Message", icon: "fa-thumbtack", fn: function() { acts.pin.trigger("click"); } });
    if (acts.reply) items.push({ label: "Reply", icon: "fa-reply", fn: function() { acts.reply.trigger("click"); } });
    items.push({ label: "Copy Text", icon: "fa-copy", fn: function() { DX2_CopyText(msg.message); DX_Toast("Text copied to clipboard.", "info"); } });
    var extra = [];
    if (!msg.isMine && !msg.isAnnouncement) extra.push({ label: "Report Message", icon: "fa-flag", danger: true, fn: function() { DXP_Fire(row, "report"); } });
    if (acts["delete"]) extra.push({ label: "Delete Message", icon: "fa-trash-alt", danger: true, fn: function() { acts["delete"].trigger("click"); } });
    if (extra.length) { items.push({ sep: true }); items = items.concat(extra); }
    DX2_Ctx(x, y, items);
}

$(document).on("click", "[data-dxmore]", function(e) {
    e.stopPropagation();
    var r = this.getBoundingClientRect();
    DXP_MessageMenu($(this).closest(".discord-message"), r.right - 188, r.bottom + 4);
});
$(document).on("click", "[data-dxquick]", function(e) {
    e.stopPropagation();
    var id = parseInt($(this).closest(".discord-message").attr("data-messageid"), 10);
    Discord_ToggleReaction(id, DXP.recents[0] || "\uD83D\uDC4D");
});
$(document).on("contextmenu", "#discord-chat-messages .discord-message", function(e) {
    if ($(e.target).closest(".discord-open-profile, a, .discord-message-link").length) return;
    if ($(this).hasClass("discord-message-announcement") && !Discord.messagesById[parseInt($(this).attr("data-messageid"), 10)]) return;
    e.preventDefault();
    DXP_MessageMenu($(this), e.clientX, e.clientY);
});

// right-click a name / avatar / member
function DXP_UserMenu(memberId, name, x, y) {
    var m = (DX.meta[Discord.currentServerId] || {})[String(memberId)] || {};
    var items = [{ label: "Profile", icon: "fa-user", fn: function() { DXP.anchor = DXP.lastRect; Discord_OpenMemberProfile(memberId); } }];
    items.push({ label: "Mention", icon: "fa-at", fn: function() { var i = $("#discord-message-input"); i.val((i.val() ? i.val() + " " : "") + "@" + name + " ").focus().trigger("input"); } });
    if (m.uid && m.uid !== DXD.me.uid) {
        var rel = DXD_RelationOf(m.uid);
        items.push({ sep: true });
        if (rel === "friend") items.push({ label: "Message", icon: "fa-comment", fn: function() { DXD_OpenDmByUid(m.uid); } });
        else if (rel === "none") items.push({ label: "Add Friend", icon: "fa-user-plus", fn: function() { DX_Post("DiscordExt_AddFriendByUid", { uid: m.uid }, function(r) { DX_Toast(r && r.ok ? "Friend request sent." : "Could not send the request.", r && r.ok ? "success" : "warn"); DXD_LoadSocial(); }); } });
        else if (rel === "incoming") items.push({ label: "Accept Friend Request", icon: "fa-user-check", fn: function() { DXD_Act("accept", m.uid); } });
        if (rel !== "blocked") items.push({ label: "Block", icon: "fa-ban", danger: true, fn: function() { DXD_Act("block", m.uid); } });
    }
    DX2_Ctx(x, y, items);
}
$(document).on("contextmenu", ".discord-open-profile[data-authorid], #discord-members-list .discord-member-item", function(e) {
    e.preventDefault(); e.stopPropagation();
    var el = $(this), id = el.attr("data-authorid") || el.attr("data-memberrowid");
    var name = el.hasClass("discord-member-item") ? el.find(".discord-member-name").first().clone().children().remove().end().text().trim() : el.closest(".discord-message").find(".discord-message-author").first().text().trim();
    DXP.lastRect = this.getBoundingClientRect();
    DXP_UserMenu(parseInt(id, 10), name, e.clientX, e.clientY);
});

// Up arrow in an empty composer edits your last message
document.addEventListener("keydown", function(e) {
    if (e.key !== "ArrowUp" || !e.target || e.target.id !== "discord-message-input" || DXD.mode !== "server") return;
    if (e.target.value !== "" || $("#dx-slash-menu").hasClass("dx-open") || $("#dx-ac-menu").hasClass("dx-open")) return;
    var last = null;
    $("#discord-chat-messages .discord-message").each(function() {
        var m = Discord.messagesById[parseInt($(this).attr("data-messageid"), 10)];
        if (m && m.isMine && !m.isAnnouncement) last = m;
    });
    if (last) { e.preventDefault(); Discord_StartEditMessage(last.id); }
}, true);

// edit box: Discord's hint
DX_After("Discord_StartEditMessage", function(id) {
    var box = $('.discord-message[data-messageid="' + id + '"] .discord-message-edit-hint');
    box.html('escape to <a data-dxedit="cancel">cancel</a> \u2022 enter to <a data-dxedit="save">save</a>');
});
$(document).on("mousedown", "[data-dxedit]", function(e) {
    e.preventDefault();
    var id = parseInt($(this).closest(".discord-message").attr("data-messageid"), 10);
    if ($(this).attr("data-dxedit") === "cancel") Discord_CancelEditMessage(id);
    else Discord_SaveEditMessage(id, $(this).closest(".discord-message").find(".discord-message-edit-input").val().trim());
});

// typing indicator with dots
(function() {
    var obs = new MutationObserver(function() {
        var el = document.getElementById("discord-typing-indicator");
        if (!el || el.querySelector(".dx-dots")) return;
        var t = el.textContent;
        var m = /^(.+?) (is|are) typing\.\.\.$/.exec(t);
        if (m) el.innerHTML = '<span class="dx-dots"><i></i><i></i><i></i></span><b>' + DX_Esc(m[1]) + "</b> " + m[2] + " typing...";
        else if (/^Several people/.test(t)) el.innerHTML = '<span class="dx-dots"><i></i><i></i><i></i></span><b>Several people</b> are typing...';
    });
    $(function() { var el = document.getElementById("discord-typing-indicator"); if (el) obs.observe(el, { childList: true, characterData: true, subtree: true }); });
})();

// ---------------------------------------------------------------------------
// Emoji picker (search + categories + recents + this server)
// ---------------------------------------------------------------------------

function DXP_PushRecent(emoji) {
    DXP.recents = [emoji].concat(DXP.recents.filter(function(e) { return e !== emoji; })).slice(0, 24);
    try { localStorage.setItem("dxp_recent", JSON.stringify(DXP.recents)); } catch (e) {}
}
function DXP_EmojiName(emoji) {
    for (var g = 0; g < DXE_DATA.length; g++) for (var i = 0; i < DXE_DATA[g].e.length; i++) if (DXE_DATA[g].e[i][0] === emoji) return DXE_DATA[g].e[i][1];
    return "";
}
function DXP_Item(emoji, name) { return '<div class="discord-emoji-picker-item" data-emoji="' + DX_Esc(emoji) + '" data-name="' + DX_Esc(name) + '">' + DX_Esc(emoji) + "</div>"; }

function DXP_BuildEmojiBody() {
    if (DXP.emojiHtml) return DXP.emojiHtml;
    var h = "";
    $.each(DXE_DATA, function(gi, g) {
        h += '<div class="dx-ep-sec" data-sec="g' + gi + '"><div class="dx-ep-label">' + DX_Esc(g.n) + '</div><div class="dx-ep-grid">';
        $.each(g.e, function(i, e) { h += DXP_Item(e[0], e[1]); });
        h += "</div></div>";
    });
    DXP.emojiHtml = h;
    return h;
}

window.Discord_OpenEmojiPicker = function(mode, messageId) {
    Discord.emojiPickerMode = mode;
    Discord.emojiPickerTargetMessageId = messageId || null;
    DXP.emojiMode = mode;
    var info = DX2_Info(), imgs = (info && info.emojiImages) || [], uni = (info && info.customEmojis) || [];
    var cats = '';
    var hasServer = imgs.length || uni.length;
    if (DXP.recents.length) cats += '<i class="fas fa-clock" data-sec="recent" data-dxtip="Frequently Used"></i>';
    if (hasServer && DXD.mode === "server") cats += '<i class="fas fa-star" data-sec="server" data-dxtip="This server"></i>';
    $.each(DXE_DATA, function(gi, g) { cats += '<i class="' + g.i + '" data-sec="g' + gi + '" data-dxtip="' + DX_Esc(g.n) + '"></i>'; });

    var body = '';
    if (DXP.recents.length) {
        body += '<div class="dx-ep-sec" data-sec="recent"><div class="dx-ep-label">Frequently Used</div><div class="dx-ep-grid">';
        $.each(DXP.recents, function(i, e) { body += DXP_Item(e, DXP_EmojiName(e)); });
        body += "</div></div>";
    }
    if (hasServer && DXD.mode === "server") {
        var server = Discord_FindServer(Discord.currentServerId) || {};
        body += '<div class="dx-ep-sec" data-sec="server"><div class="dx-ep-label">' + DX_Esc(server.name || "This server") + '</div><div class="dx-ep-grid">';
        $.each(imgs, function(i, e) { body += '<div class="discord-emoji-picker-item dx-img-emoji" data-emoji=":' + DX_Esc(e.name) + ':" data-name="' + DX_Esc(e.name) + '"><img class="dx-emoji" src="' + DX_Esc(e.url) + '"></div>'; });
        if (mode === "react") $.each(uni, function(i, e) { body += DXP_Item(e, DXP_EmojiName(e)); });
        body += "</div></div>";
    }
    body += DXP_BuildEmojiBody();

    var el = $("#discord-emoji-picker");
    el.html('<div class="dx-ep-head"><input type="text" id="dx-ep-search" placeholder="Find the perfect emoji" spellcheck="false" autocomplete="off"><i class="fas fa-search"></i></div>' +
            '<div class="dx-ep-body"><div class="dx-ep-cats">' + cats + '</div><div class="dx-ep-scroll" id="dx-ep-scroll">' + body + "</div></div>" +
            '<div class="dx-ep-foot"><span class="dx-ep-prev" id="dx-ep-prev"></span><span class="dx-ep-pname" id="dx-ep-pname">Pick an emoji</span></div>');
    el.addClass("discord-visible");
    DXP_PlacePicker(mode);
    setTimeout(function() { var i = document.getElementById("dx-ep-search"); if (i) i.focus({ preventScroll: true }); }, 30);
};

function DXP_PlacePicker(mode) {
    var el = $("#discord-emoji-picker"), host = el.offsetParent()[0] || DXP_Bd()[0], b = host.getBoundingClientRect();
    el.css({ right: "auto", bottom: "auto", left: 0, top: 0 });
    var w = 352, h = 420, x, y;
    if (mode === "react" && DXP.pickerAnchor) {
        var a = DXP.pickerAnchor;
        x = a.left - b.left - w - 8; if (x < 8) x = a.right - b.left + 8;
        y = a.top - b.top - 40;
    } else {
        var btn = document.getElementById("discord-emoji-btn");
        var r = btn ? btn.getBoundingClientRect() : { right: b.right - 16, top: b.bottom - 60 };
        x = r.right - b.left - w; y = r.top - b.top - h - 10;
    }
    x = Math.max(8, Math.min(x, b.width - w - 8)); y = Math.max(8, Math.min(y, b.height - h - 8));
    el.css({ left: x, top: y });
}
$(document).on("mousedown", '.discord-message-actions i[data-action="react"], .discord-reaction-add-pill, [data-dxquick]', function() { DXP.pickerAnchor = this.getBoundingClientRect(); });
$(document).on("mousedown", '.dx-ctx-item', function() { if (DXP.lastMsgRect) DXP.pickerAnchor = DXP.lastMsgRect; });
$(document).on("contextmenu", "#discord-chat-messages .discord-message", function() { DXP.lastMsgRect = this.getBoundingClientRect(); DXP.pickerAnchor = { left: this.getBoundingClientRect().right - 40, right: this.getBoundingClientRect().right, top: this.getBoundingClientRect().top }; });

$(document).on("input", "#dx-ep-search", function() {
    var q = $(this).val().toLowerCase().trim().replace(/\s+/g, "_");
    var sc = $("#dx-ep-scroll"), res = $("#dx-ep-results");
    if (!q) { res.remove(); sc.children().show(); return; }
    var out = "", n = 0;
    $.each(DXE_DATA, function(gi, g) { $.each(g.e, function(i, e) { if (n < 120 && e[1].indexOf(q) >= 0) { out += DXP_Item(e[0], e[1]); n++; } }); });
    var info = DX2_Info();
    $.each((info && info.emojiImages) || [], function(i, e) { if (e.name.indexOf(q) >= 0) out = '<div class="discord-emoji-picker-item dx-img-emoji" data-emoji=":' + DX_Esc(e.name) + ':" data-name="' + DX_Esc(e.name) + '"><img class="dx-emoji" src="' + DX_Esc(e.url) + '"></div>' + out; });
    sc.children().not("#dx-ep-results").hide();
    res.remove();
    sc.prepend('<div id="dx-ep-results"><div class="dx-ep-label">Search results</div>' + (out ? '<div class="dx-ep-grid">' + out + "</div>" : '<div class="dx-ep-none">No emoji found.</div>') + "</div>");
});
$(document).on("mouseover", "#discord-emoji-picker .discord-emoji-picker-item", function() {
    var name = $(this).attr("data-name") || "";
    $("#dx-ep-prev").html($(this).html());
    $("#dx-ep-pname").text(name ? ":" + name + ":" : "");
});
$(document).on("click", ".dx-ep-cats i", function() {
    var sec = $('#dx-ep-scroll .dx-ep-sec[data-sec="' + $(this).attr("data-sec") + '"]');
    $("#dx-ep-search").val("").trigger("input");
    if (sec.length) $("#dx-ep-scroll")[0].scrollTop = sec[0].offsetTop - 4;
});
$(document).on("scroll", "#dx-ep-scroll", function() {
    var top = this.scrollTop + 20, active = null;
    $(this).children(".dx-ep-sec").each(function() { if (this.offsetTop <= top) active = $(this).attr("data-sec"); });
    $(".dx-ep-cats i").removeClass("dx-sel").filter('[data-sec="' + active + '"]').addClass("dx-sel");
});
// remember what was picked (the stock handler inserts / reacts)
$(document).on("click", ".discord-emoji-picker-item", function() {
    var e = $(this).attr("data-emoji");
    if (e && e.charAt(0) !== ":") DXP_PushRecent(e);
});

// ---------------------------------------------------------------------------
// Composer: textarea (Shift+Enter), auto-grow, autocomplete
// ---------------------------------------------------------------------------

function DXP_BuildComposer() {
    var old = document.getElementById("discord-message-input");
    if (!old || old.tagName === "TEXTAREA") return;
    var ta = document.createElement("textarea");
    ta.id = "discord-message-input"; ta.rows = 1; ta.maxLength = 1000; ta.spellcheck = false; ta.setAttribute("dir", "auto");
    ta.placeholder = old.placeholder; ta.setAttribute("autocomplete", "off");
    old.parentNode.replaceChild(ta, old);
    $("<div id=\"dx-ac-menu\"></div>").appendTo(".discord-chat-column");
}
function DXP_Autosize() {
    var ta = document.getElementById("discord-message-input");
    if (!ta) return;
    ta.style.height = "auto";
    ta.style.height = Math.min(ta.scrollHeight, 200) + "px";
}
$(document).on("input", "#discord-message-input", DXP_Autosize);
DX_After("Discord_SendMessage", function() { setTimeout(DXP_Autosize, 0); });
DX_After("Discord_OpenChannel", function() { setTimeout(DXP_Autosize, 0); });

// Shift+Enter = new line (stops discord.js's Enter-to-send handler)
document.addEventListener("keydown", function(e) {
    if (e.key === "Enter" && e.shiftKey && e.target && e.target.id === "discord-message-input") { e.stopPropagation(); }
}, true);

function DXP_CaretText() {
    var ta = document.getElementById("discord-message-input");
    return ta ? ta.value.slice(0, ta.selectionStart) : "";
}
function DXP_MemberCandidates(q) {
    var out = [], seen = {};
    q = q.toLowerCase();
    $("#discord-members-list .discord-member-item").each(function() {
        var name = $(this).find(".discord-member-name").first().clone().children().remove().end().text().trim();
        if (!name || seen[name] || (q && name.toLowerCase().indexOf(q) < 0)) return;
        seen[name] = 1;
        var av = $(this).find(".discord-member-avatar")[0];
        var meta = (DX.meta[Discord.currentServerId] || {})[$(this).attr("data-memberrowid")] || {};
        out.push({ kind: "user", insert: "@" + name, name: name, color: meta.color, avatar: meta.avatar, bg: av ? av.style.backgroundColor : null });
    });
    var info = DX2_Info();
    $.each((info && info.roles) || [], function(i, r) { if (!q || r.name.toLowerCase().indexOf(q) >= 0) out.push({ kind: "role", insert: "@" + r.name, name: r.name, color: r.color }); });
    $.each(["everyone", "here"], function(i, n) { if (!q || n.indexOf(q) === 0) out.push({ kind: "special", insert: "@" + n, name: n }); });
    return out.slice(0, 8);
}
function DXP_EmojiCandidates(q) {
    var out = [];
    q = q.toLowerCase();
    var info = DX2_Info();
    $.each((info && info.emojiImages) || [], function(i, e) { if (e.name.indexOf(q) === 0) out.push({ kind: "img", insert: ":" + e.name + ": ", name: e.name, url: e.url }); });
    for (var g = 0; g < DXE_DATA.length && out.length < 8; g++)
        for (var i = 0; i < DXE_DATA[g].e.length && out.length < 8; i++) { var e = DXE_DATA[g].e[i]; if (e[1].indexOf(q) === 0 || (q.length > 2 && e[1].indexOf(q) > 0 && out.length < 6)) out.push({ kind: "uni", insert: e[0] + " ", name: e[1], glyph: e[0] }); }
    return out.slice(0, 8);
}
function DXP_Autocomplete() {
    var menu = $("#dx-ac-menu"), text = DXP_CaretText(), m, items = [], kind = null, head = "";
    if (DXD.mode === "server" && (m = /(^|\s)@([^\s@]{0,24})$/.exec(text))) { kind = "@"; items = DXP_MemberCandidates(m[2]); head = "Members"; DXP.acRe = /@[^\s@]{0,24}$/; }
    else if ((m = /(^|\s):([a-z0-9_]{2,})$/i.exec(text))) { kind = ":"; items = DXP_EmojiCandidates(m[2]); head = "Emoji matching :" + m[2]; DXP.acRe = /:[a-z0-9_]{2,}$/i; }
    if (!kind || !items.length) { menu.removeClass("dx-open").empty(); DXP.acItems = []; return; }
    DXP.acKind = kind; DXP.acItems = items; DXP.acSel = 0;
    var html = '<div class="dx-ac-head">' + DX_Esc(head) + "</div>";
    $.each(items, function(i, it) {
        var left = "";
        if (it.kind === "user") left = '<span class="dx-ac-av' + (it.avatar ? " dx-img" : "") + '" style="background-color:' + DX_Esc(it.bg || "#5865F2") + DXD_Img(it.avatar) + '">' + DX_Esc(Discord_Initials(it.name)) + "</span>";
        else if (it.kind === "role") left = '<span class="dx-ac-role" style="background:' + DX_Esc(it.color || "#99AAB5") + '"></span>';
        else if (it.kind === "special") left = '<span class="dx-ac-role" style="background:#5865F2"></span>';
        else if (it.kind === "img") left = '<img class="dx-emoji" src="' + DX_Esc(it.url) + '">';
        else left = '<span class="dx-ac-glyph">' + DX_Esc(it.glyph) + "</span>";
        html += '<div class="dx-ac-item' + (i === 0 ? " dx-sel" : "") + '" data-i="' + i + '">' + left + '<b' + (it.color ? ' style="color:' + DX_Esc(it.color) + '"' : "") + ">" + DX_Esc(it.kind === "uni" || it.kind === "img" ? ":" + it.name + ":" : it.name) + "</b></div>";
    });
    menu.html(html).addClass("dx-open");
}
function DXP_AcPick(i) {
    var it = DXP.acItems[i], ta = document.getElementById("discord-message-input");
    if (!it || !ta) return;
    var before = ta.value.slice(0, ta.selectionStart), after = ta.value.slice(ta.selectionStart);
    before = before.replace(DXP.acRe, it.insert.charAt(0) === "@" ? it.insert + " " : it.insert);
    ta.value = before + after;
    ta.selectionStart = ta.selectionEnd = before.length;
    $("#dx-ac-menu").removeClass("dx-open").empty(); DXP.acItems = [];
    $(ta).focus().trigger("input");
}
$(document).on("input click", "#discord-message-input", function() { setTimeout(DXP_Autocomplete, 0); });
$(document).on("mousedown", ".dx-ac-item", function(e) { e.preventDefault(); DXP_AcPick(parseInt($(this).attr("data-i"), 10)); });
document.addEventListener("keydown", function(e) {
    if (!e.target || e.target.id !== "discord-message-input" || !$("#dx-ac-menu").hasClass("dx-open")) return;
    var n = DXP.acItems.length;
    if (e.key === "ArrowDown" || e.key === "ArrowUp") {
        DXP.acSel = (DXP.acSel + (e.key === "ArrowDown" ? 1 : -1) + n) % n;
        $("#dx-ac-menu .dx-ac-item").removeClass("dx-sel").eq(DXP.acSel).addClass("dx-sel");
        e.preventDefault(); e.stopPropagation();
    } else if (e.key === "Tab" || e.key === "Enter") {
        DXP_AcPick(DXP.acSel); e.preventDefault(); e.stopPropagation();
    } else if (e.key === "Escape") {
        $("#dx-ac-menu").removeClass("dx-open").empty(); e.preventDefault(); e.stopPropagation();
    }
}, true);

// ---------------------------------------------------------------------------
// Profile popout next to the clicked name / avatar / member
// ---------------------------------------------------------------------------

$(document).on("mousedown", "#discord-chat-messages .discord-open-profile, #discord-members-list .discord-member-item", function() {
    DXP.anchor = this.getBoundingClientRect();
    DXP.anchorSide = $(this).closest("#discord-members-list").length ? "left" : "right";
});
DX_After("Discord_OpenMemberProfile", function() { DXP_PlaceProfile(); });
function DXP_PlaceProfile() {
    var a = DXP.anchor;
    if (!a) return;
    var ov = $("#discord-modal-overlay"), card = $("#discord-modal-profile-view"), b = DXP_Bd()[0].getBoundingClientRect();
    ov.addClass("dx-popout");
    var attempts = 0;
    (function place() {
        var w = card.outerWidth() || 340, h = card.outerHeight() || 420;
        var x = DXP.anchorSide === "left" ? a.left - b.left - w - 10 : a.right - b.left + 10;
        if (x < 8) x = a.right - b.left + 10;
        if (x + w > b.width - 8) x = a.left - b.left - w - 10;
        var y = a.top - b.top - 8;
        x = Math.max(8, Math.min(x, b.width - w - 8)); y = Math.max(8, Math.min(y, b.height - h - 8));
        card.css({ position: "absolute", left: x, top: y, margin: 0 });
        if (++attempts < 4) setTimeout(place, 120);
    })();
    DXP.anchor = null;
}
(function() {
    var origOpen = window.Discord_OpenModal;
    window.Discord_OpenModal = function(id) {
        var ov = $("#discord-modal-overlay");
        if (id !== "discord-modal-profile-view") { ov.removeClass("dx-popout"); $("#discord-modal-profile-view").css({ position: "", left: "", top: "", margin: "" }); }
        DXP_HideTip();
        return origOpen.apply(this, arguments);
    };
    var origClose = window.Discord_CloseModals;
    window.Discord_CloseModals = function() {
        $("#discord-modal-overlay").removeClass("dx-popout dx-dropdown");
        $("#discord-modal-profile-view").css({ position: "", left: "", top: "", margin: "" });
        return origClose.apply(this, arguments);
    };
})();

// ---------------------------------------------------------------------------
// User panel: status popout
// ---------------------------------------------------------------------------

function DXP_StatusPopout() {
    $("#dx-status-pop").remove();
    DX_Post("GetDiscordMyProfile", {}, function(p) {
        if (!p) return;
        var foot = document.getElementById("discord-user-footer"), fr = foot.getBoundingClientRect(), b = DXP_Bd()[0].getBoundingClientRect();
        var cur = p.status || "online";
        function opt(key, label, sub) {
            return '<div class="dx-st-opt' + (cur === key ? " dx-sel" : "") + '" data-st="' + key + '"><span class="discord-member-status-dot ' + (key === "invisible" ? "" : "discord-status-" + key) + '"></span><div><b>' + label + "</b>" + (sub ? "<small>" + sub + "</small>" : "") + "</div></div>";
        }
        var av = DXD.me.avatar ? " dx-img" : "";
        var html = '<div id="dx-status-pop"><div class="dx-st-banner" style="background:' + DX_Esc(p.bannerColor || "#5865F2") + '"></div>' +
                   '<div class="dx-st-head"><div class="dx-av dx-av-md' + av + '" style="background-color:' + Discord_ColorFor(Discord.myName || "?") + DXD_Img(DXD.me.avatar) + '">' + DX_Esc(Discord_Initials(Discord.myName)) + '<span class="discord-member-status-dot discord-status-' + (cur === "invisible" ? "offline" : cur) + '"></span></div>' +
                   '<div class="dx-st-name">' + DX_Esc(Discord.myName || "") + "</div></div>" +
                   '<div class="dx-st-body"><div class="dx-st-custom"><i class="far fa-smile"></i><input type="text" id="dx-st-custom" maxlength="60" placeholder="Set a custom status" value="' + DX_Esc(p.customStatus || "") + '" spellcheck="false"></div>' +
                   '<div class="dx-st-sep"></div>' + opt("online", "Online") + opt("idle", "Idle") + opt("dnd", "Do Not Disturb", "You will not receive desktop notifications") + opt("invisible", "Invisible", "You will appear offline") +
                   '<div class="dx-st-sep"></div><div class="dx-st-opt" data-st="edit"><i class="fas fa-user-edit"></i><div><b>Edit Profile</b></div></div></div></div>';
        var el = $(html).appendTo(DXP_Bd());
        el.css({ left: Math.max(8, fr.left - b.left + 8), top: Math.max(8, fr.top - b.top - el.outerHeight() - 8) });
        el.data("profile", p);
    });
}
function DXP_SetStatus(patch) {
    var p = $("#dx-status-pop").data("profile");
    if (!p) return;
    var data = {
        status: patch.status || p.status || "online", bannerColor: p.bannerColor, customStatus: patch.customStatus != null ? patch.customStatus : (p.customStatus || ""),
        bio: p.bio || "", showPhone: !!p.showPhone, showJob: !!p.showJob,
    };
    DX_Post("UpdateDiscordMyProfile", data, function(r) {
        if (!r) { DX_Toast("Could not update your status.", "error"); return; }
        Discord_ApplyMyProfile(r);
        Discord_LoadMembersSidebar();
        $("#dx-status-pop").remove();
    });
}
document.addEventListener("click", function(e) {
    var t = $(e.target);
    if (t.closest("#dx-status-pop").length) return;
    if (t.closest("#discord-user-footer .discord-user-avatar-wrap, #discord-user-footer .discord-user-info").length) {
        e.stopPropagation(); e.preventDefault();
        if ($("#dx-status-pop").length) $("#dx-status-pop").remove(); else DXP_StatusPopout();
        return;
    }
    $("#dx-status-pop").remove();
}, true);
$(document).on("click", ".dx-st-opt", function() {
    var st = $(this).attr("data-st");
    if (st === "edit") { $("#dx-status-pop").remove(); Discord_OpenProfileEditor(); return; }
    DXP_SetStatus({ status: st });
});
$(document).on("keydown", "#dx-st-custom", function(e) { if (e.key === "Enter") DXP_SetStatus({ customStatus: $(this).val().trim() }); });

// settings gear opens the full editor (incl. theme + avatar) instead of the profile card
document.addEventListener("click", function(e) {
    if ($(e.target).closest("#discord-user-footer .discord-user-settings-icon").length) {
        e.stopPropagation(); e.preventDefault();
        Discord_OpenProfileEditor();
    }
}, true);

// ---------------------------------------------------------------------------
// Scrolling: stay where you are while reading history; "Jump to present"
// ---------------------------------------------------------------------------

function DXP_NearBottom() {
    var el = document.getElementById("discord-chat-messages");
    return !el || (el.scrollHeight - el.scrollTop - el.clientHeight) < 140;
}
(function() {
    var origIn = window.Discord_HandleIncomingMessage;
    window.Discord_HandleIncomingMessage = function(payload) {
        var viewing = Discord.currentChannelId === payload.channelId;
        DXP.keepPos = viewing && !DXP_NearBottom();
        if (DXP.keepPos) DXP.newBelow++;
        try { return origIn.apply(this, arguments); } finally { DXP.keepPos = false; DXP_UpdateJump(); }
    };
    var origScroll = window.Discord_ScrollMessagesToBottom;
    window.Discord_ScrollMessagesToBottom = function() {
        if (DXP.keepPos) return;
        DXP.newBelow = 0;
        return origScroll.apply(this, arguments);
    };
})();
function DXP_UpdateJump() {
    var el = document.getElementById("discord-chat-messages");
    var bar = $("#dx-jump");
    if (!el) return;
    var far = (el.scrollHeight - el.scrollTop - el.clientHeight) > 380;
    if (!far) { DXP.newBelow = 0; bar.removeClass("dx-show"); return; }
    bar.find(".dx-jump-text").text(DXP.newBelow > 0 ? DXP.newBelow + " new message" + (DXP.newBelow > 1 ? "s" : "") : "You're viewing older messages");
    bar.addClass("dx-show");
}
$(document).on("scroll", "#discord-chat-messages", function() { DXP_UpdateJump(); });
$(document).on("click", "#dx-jump", function() {
    DXP.newBelow = 0;
    var el = document.getElementById("discord-chat-messages");
    el.scrollTop = el.scrollHeight; $("#dx-jump").removeClass("dx-show");
});

// "N new messages since 09:12" bar when you open a channel with unread messages
(function() {
    var orig = window.DX2_PlaceDivider;
    window.DX2_PlaceDivider = function() {
        orig.apply(this, arguments);
        var d = $("#dx-new-divider");
        if (!d.length || $("#dx-unread-bar").data("for") === Discord.currentChannelId) return;
        var next = d.nextAll(".discord-message");
        if (!next.length) return;
        var first = Discord.messagesById[parseInt(next.first().attr("data-messageid"), 10)];
        $("#dx-unread-bar").data("for", Discord.currentChannelId)
            .find(".dx-ub-text").text(next.length + " new message" + (next.length > 1 ? "s" : "") + " since " + (first ? DXS_Clock(first.created_at) : ""))
            .end().addClass("dx-show");
    };
})();
$(document).on("click", "#dx-unread-bar .dx-ub-text", function() { var d = document.getElementById("dx-new-divider"); if (d) d.scrollIntoView({ block: "start" }); });
$(document).on("click", "#dx-unread-bar .dx-ub-mark", function() { $("#dx-unread-bar").removeClass("dx-show").removeData("for"); $("#dx-new-divider").remove(); });
DX_After("Discord_OpenChannel", function() { $("#dx-unread-bar").removeClass("dx-show").removeData("for"); DXP.newBelow = 0; $("#dx-jump").removeClass("dx-show"); });

// ---------------------------------------------------------------------------
// Channel topic + edit channel
// ---------------------------------------------------------------------------

function DXP_ApplyTopic() {
    $(".dx-chat-topic").remove();
    if (DXD.mode !== "server") return;
    var ch = Discord_FindChannel(Discord.currentChannelId);
    if (ch && ch.topic) $("#discord-chat-channel-name").after('<span class="dx-chat-topic" data-dxtip="' + DX_Esc(ch.topic) + '" data-dxtip-pos="bottom">' + DX_Esc(ch.topic) + "</span>");
}
DX_After("Discord_OpenChannel", function() { setTimeout(DXP_ApplyTopic, 0); });
DX_After("Discord_RenderChannelList", function() { DXP_ApplyTopic(); DXP_ChannelGears(); });
function DXP_ChannelGears() {
    var can = DX2_Perms().manage_channels || DX2_Perms().administrator || Discord.currentServerIsOwner || Discord.currentServerIsAdmin;
    $(".discord-channel-item[data-channelid]").each(function() {
        $(this).children(".dx-ch-gear").remove();
        if (can) $(this).append('<i class="fas fa-cog dx-ch-gear" data-dxtip="Edit Channel" data-dxtip-pos="top"></i>');
    });
}
DX_After("DX_ApplyServerLook", function() { DXP_ChannelGears(); });
function DXP_OpenEditChannel(cid) {
    var ch = Discord_FindChannel(cid);
    if (!ch) return;
    DXP.editChannel = cid;
    $("#dx-ec-name").val(ch.name); $("#dx-ec-topic").val(ch.topic || "");
    Discord_OpenModal("dx-modal-editchannel");
}
$(document).on("click", ".dx-ch-gear", function(e) { e.stopPropagation(); DXP_OpenEditChannel(parseInt($(this).closest(".discord-channel-item").attr("data-channelid"), 10)); });
$(document).on("click", "#dx-ec-save", function() {
    DX_Post("DiscordExt_SetChannelInfo", { serverId: Discord.currentServerId, channelId: DXP.editChannel, name: $("#dx-ec-name").val(), topic: $("#dx-ec-topic").val() }, function(r) {
        if (r && r.ok) { Discord_CloseModals(); DX_Toast("Channel updated.", "success"); }
        else DX_Toast("Could not update the channel.", "error");
    });
});
$(document).on("input", "#dx-ec-topic", function() { $("#dx-ec-count").text($(this).val().length + "/200"); });
// the context menu of channels gets an "Edit Channel" item
(function() {
    var origCtx = window.DX2_Ctx;
    window.DX2_Ctx = function(x, y, items) {
        if (DXP.ctxChannel != null && items && items.length && /Mute channel|Unmute channel/.test(items[0].label)) {
            var cid = DXP.ctxChannel, can = DX2_Perms().manage_channels || DX2_Perms().administrator;
            if (can) items = items.slice(0, 2).concat([{ sep: true }, { label: "Edit Channel", icon: "fa-cog", fn: function() { DXP_OpenEditChannel(cid); } }]).concat(items.slice(2).filter(function(i) { return !i.sep; }));
        }
        DXP.ctxChannel = null;
        return origCtx(x, y, items);
    };
})();
$(document).on("contextmenu mousedown", ".discord-channel-item[data-channelid]", function() { DXP.ctxChannel = parseInt($(this).attr("data-channelid"), 10); });

// ---------------------------------------------------------------------------
// Quick switcher (Ctrl+K)
// ---------------------------------------------------------------------------

function DXP_SwitcherItems(q) {
    var items = [], raw = q.trim(), mode = null;
    if (/^[#@*]/.test(raw)) { mode = raw.charAt(0); raw = raw.slice(1).trim(); }
    var lq = raw.toLowerCase();
    function match(s) { return !lq || s.toLowerCase().indexOf(lq) >= 0; }
    if (!mode || mode === "#") $.each(Discord.channels || [], function(i, c) { if (match(c.name)) items.push({ type: "Channel", icon: c.kind === "stage" ? "fa-podcast" : "fa-hashtag", label: c.name, sub: (Discord_FindServer(Discord.currentServerId) || {}).name, fn: function() { if (DXD.mode !== "server") return; Discord_OpenChannel(c.id, c.name); } }); });
    if (!mode || mode === "*") $.each(Discord.servers || [], function(i, s) { if (match(s.name)) items.push({ type: "Server", icon: "fa-server", label: s.name, fn: function() { Discord_SelectServer(s.id); } }); });
    if (!mode || mode === "@") {
        var soc = DXD.social || {}, seen = {};
        $.each([].concat((soc.dms || []).map(function(d) { return d.user; }), soc.friends || []), function(i, u) {
            if (!u || seen[u.uid] || !match(u.name)) return; seen[u.uid] = 1;
            items.push({ type: "User", avatar: u, label: u.name, sub: "#" + (u.discriminator || ""), fn: function() { DXD_OpenDmByUid(u.uid); } });
        });
    }
    return items.slice(0, 12);
}
function DXP_OpenSwitcher() {
    if (!$("#discord-backdrop").hasClass("discord-visible")) return;
    $("#dx-sw-input").val("");
    Discord_OpenModal("dx-modal-switcher");
    $("#discord-modal-overlay").addClass("dx-switch");
    DXP_RenderSwitcher();
    setTimeout(function() { $("#dx-sw-input").focus(); }, 30);
}
function DXP_RenderSwitcher() {
    var items = DXP_SwitcherItems($("#dx-sw-input").val() || "");
    DXP.switcher = { items: items, sel: 0 };
    var html = "";
    $.each(items, function(i, it) {
        var left = it.avatar ? DXD_AvatarHtml(it.avatar, "dx-av-sm") : '<i class="fas ' + it.icon + '"></i>';
        html += '<div class="dx-sw-item' + (i === 0 ? " dx-sel" : "") + '" data-i="' + i + '"><span class="dx-sw-ico">' + left + "</span><b>" + DX_Esc(it.label) + "</b>" + (it.sub ? "<small>" + DX_Esc(it.sub) + "</small>" : "") + '<em>' + it.type + "</em></div>";
    });
    $("#dx-sw-list").html(html || '<div class="dx-sw-none">Nothing found. Try # for channels, @ for people, * for servers.</div>');
}
function DXP_SwitcherGo(i) {
    var it = DXP.switcher.items[i];
    if (!it) return;
    Discord_CloseModals();
    it.fn();
}
$(document).on("input", "#dx-sw-input", DXP_RenderSwitcher);
$(document).on("click", ".dx-sw-item", function() { DXP_SwitcherGo(parseInt($(this).attr("data-i"), 10)); });
$(document).on("keydown", "#dx-sw-input", function(e) {
    var n = DXP.switcher.items.length;
    if (e.key === "ArrowDown" || e.key === "ArrowUp") { DXP.switcher.sel = (DXP.switcher.sel + (e.key === "ArrowDown" ? 1 : -1) + n) % Math.max(1, n); $(".dx-sw-item").removeClass("dx-sel").eq(DXP.switcher.sel).addClass("dx-sel"); e.preventDefault(); }
    else if (e.key === "Enter") { DXP_SwitcherGo(DXP.switcher.sel); e.preventDefault(); }
});
document.addEventListener("keydown", function(e) {
    if ((e.ctrlKey || e.metaKey) && (e.key === "k" || e.key === "K") && $("#discord-backdrop").hasClass("discord-visible")) { e.preventDefault(); e.stopPropagation(); DXP_OpenSwitcher(); }
}, true);
$(document).on("click", "#dx-search-btn", function() { /* search pill keeps opening the panel */ });

// ---------------------------------------------------------------------------
// Themes (Dark / Ash / Onyx / Light) in Edit Profile
// ---------------------------------------------------------------------------

function DXP_ApplyTheme(t) {
    DXP.theme = t;
    try { localStorage.setItem("dxp_theme", t); } catch (e) {}
    $("#discord-backdrop").attr("data-dxtheme", t);
    $(".dx-theme-opt").removeClass("dx-sel").filter('[data-theme-opt="' + t + '"]').addClass("dx-sel");
}
DX_After("Discord_OpenProfileEditor", function() {
    var m = $("#discord-modal-profile-edit");
    m.find(".dx-theme-edit").remove();
    var html = '<div class="dx-theme-edit"><div class="discord-settings-label">Theme</div><div class="dx-theme-row">';
    $.each([["dark", "Dark", "#313338"], ["ash", "Ash", "#36373d"], ["onyx", "Onyx", "#0e0e10"], ["light", "Light", "#ffffff"]], function(i, t) {
        html += '<div class="dx-theme-opt' + (DXP.theme === t[0] ? " dx-sel" : "") + '" data-theme-opt="' + t[0] + '"><span style="background:' + t[2] + '"></span>' + t[1] + "</div>";
    });
    m.find(".dx-avatar-edit").length ? m.find(".dx-avatar-edit").after(html + "</div></div>") : m.find(".discord-modal-title").after(html + "</div></div>");
});
$(document).on("click", ".dx-theme-opt", function() { DXP_ApplyTheme($(this).attr("data-theme-opt")); });

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

function DXP_Build() {
    DXP_BuildComposer();
    var col = $(".discord-chat-column");
    col.append('<div id="dx-jump"><span class="dx-jump-text"></span><span class="dx-jump-go">Jump To Present <i class="fas fa-arrow-down"></i></span></div>');
    col.append('<div id="dx-unread-bar"><span class="dx-ub-text"></span><span class="dx-ub-mark">Mark As Read <i class="fas fa-check-double"></i></span></div>');
    $("#discord-modal-overlay").append(
        '<div class="discord-modal" id="dx-modal-switcher"><input type="text" id="dx-sw-input" placeholder="Where would you like to go?" spellcheck="false" autocomplete="off"><div id="dx-sw-list"></div>' +
        '<div class="dx-sw-foot"><b>PROTIP:</b> start with <code>#</code> channels, <code>@</code> people, <code>*</code> servers</div></div>' +
        '<div class="discord-modal" id="dx-modal-editchannel"><div class="discord-modal-title">Edit Channel</div>' +
        '<div class="discord-settings-label">Channel name</div><input type="text" id="dx-ec-name" maxlength="30" spellcheck="false">' +
        '<div class="discord-settings-label">Channel topic <span id="dx-ec-count" class="dx-muted">0/200</span></div><textarea id="dx-ec-topic" maxlength="200" rows="3" spellcheck="false" dir="auto"></textarea>' +
        '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Cancel</div><div class="discord-modal-btn discord-modal-confirm" id="dx-ec-save">Save Changes</div></div></div>');
    DXP_ApplyTheme(DXP.theme);
}
$(function() { setTimeout(DXP_Build, 20); });

// links: open in the real browser (FiveM) or copy the address
$(document).on("click", ".discord-message-link", function(e) {
    e.stopPropagation();
    var url = $(this).attr("data-url") || $(this).text();
    if (!/^https?:\/\//i.test(url)) return;
    if (window.invokeNative) { try { window.invokeNative("openUrl", url); return; } catch (err) {} }
    DX2_CopyText(url); DX_Toast("Link copied to clipboard.", "info");
});
