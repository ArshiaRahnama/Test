// ============================================================================
// Discord skin (v10) — DOM pieces real Discord has. Loaded AFTER discord_ext2.js.
// Only presentation: message layout (grouping by 7 minutes, day dividers, reply
// connector, "Today at" times), channel categories, role-grouped member list,
// header with search pill, "+" button in the composer, headphone button in the
// user panel, empty-channel intro, roles on the profile card.
// Nothing here changes what is sent to / received from the server.
// ============================================================================

var DXS = { catCollapsed: {}, deafened: false, lastDay: null, lastTs: 0 };
try { DXS.deafened = localStorage.getItem('dxs_deaf') === '1'; } catch (e) {}

function DXS_Pad(n) { return n < 10 ? "0" + n : "" + n; }
function DXS_DayKey(ts) { var d = new Date(ts * 1000); return d.getFullYear() * 10000 + (d.getMonth() + 1) * 100 + d.getDate(); }
function DXS_Clock(ts) { var d = new Date(ts * 1000); return DXS_Pad(d.getHours()) + ":" + DXS_Pad(d.getMinutes()); }
function DXS_HeaderTime(ts) {
    var key = DXS_DayKey(ts), now = new Date(), today = DXS_DayKey(Math.floor(now.getTime() / 1000));
    var y = new Date(now.getTime() - 86400000), yesterday = DXS_DayKey(Math.floor(y.getTime() / 1000));
    if (key === today) return "Today at " + DXS_Clock(ts);
    if (key === yesterday) return "Yesterday at " + DXS_Clock(ts);
    var d = new Date(ts * 1000);
    return DXS_Pad(d.getMonth() + 1) + "/" + DXS_Pad(d.getDate()) + "/" + d.getFullYear();
}
var DXS_MONTHS = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
function DXS_DayLabel(ts) { var d = new Date(ts * 1000); return DXS_MONTHS[d.getMonth()] + " " + d.getDate() + ", " + d.getFullYear(); }

// ---------------------------------------------------------------------------
// Messages
// ---------------------------------------------------------------------------

function DXS_RenderMessage(msg) {
    var processed = Discord_ProcessMessageText(msg.message);
    var editedTag = msg.edited_at ? '<span class="discord-message-edited-tag">(edited)</span>' : '';
    var fullTime = DX_Esc(Discord_FullDateTime(msg.created_at));
    var badge = Discord_VerifiedBadge(msg.authorVerified);
    var mentionsMe = !msg.isMine && Discord_MentionsMe(msg.message);
    var reactions = msg._dm ? '' : Discord_RenderReactionsHTML(msg.reactions);
    var actions = msg._dm ? DXD_DmActionsHTML(msg) : Discord_RenderMessageActionsHTML(msg);

    if (msg.isAnnouncement) {
        var author = msg.author_name && msg.author_name !== "Discord Staff" ? msg.author_name : "Discord Staff";
        var tag = /staff/i.test(author) ? "Staff" : "App";
        return '<div class="discord-message discord-message-announcement" data-messageid="' + msg.id + '">' +
               '<div class="discord-message-avatar discord-announcement-avatar"><i class="fas fa-bullhorn"></i></div>' +
               '<div class="discord-message-body">' +
               '<div class="discord-message-top"><span class="discord-message-author">' + DX_Esc(author) + '</span>' +
               '<span class="discord-announcement-tag">' + tag + '</span>' +
               '<span class="discord-message-time" title="' + fullTime + '">' + DXS_HeaderTime(msg.created_at) + '</span></div>' +
               '<div class="discord-message-text">' + processed.textHtml + '</div>' + processed.embedHtml + reactions +
               '</div>' + actions + '</div>';
    }

    var profileAttrs = ' data-authorid="' + (msg.authorMemberId || "") + '" data-mine="' + (msg.isMine ? 1 : 0) + '"';
    var reply = "";
    if (msg.replyPreview) {
        var rn = msg.replyPreview.author_name || "";
        reply = '<div class="discord-message-reply-quote dx-reply"><span class="dx-reply-av" style="background:' + Discord_ColorFor(rn) + '">' +
                DX_Esc(Discord_Initials(rn).charAt(0)) + '</span><span class="dx-reply-name">@' + DX_Esc(rn) + '</span><span class="dx-reply-text">' +
                DX_Esc(msg.replyPreview.message || "") + '</span></div>';
    }
    var cls = 'discord-message' + (mentionsMe ? ' discord-message-mentions-me' : '') + (msg._grouped ? ' dx-grouped' : '') + (msg.replyPreview ? ' dx-has-reply' : '');
    var html = '<div class="' + cls + '" data-messageid="' + msg.id + '">';
    if (msg._grouped) {
        html += '<span class="dx-gutter-time" title="' + fullTime + '">' + DXS_Clock(msg.created_at) + '</span>';
        html += '<div class="discord-message-body">' + reply +
                '<div class="discord-message-text">' + processed.textHtml + editedTag + '</div>' + processed.embedHtml;
    } else {
        var avUrl = msg._avatarUrl ? ';background-image:url(&quot;' + DX_Esc(msg._avatarUrl) + '&quot;)' : '';
        html += '<div class="discord-message-avatar discord-open-profile' + (avUrl ? ' dx-img' : '') + '"' + profileAttrs + ' style="background-color:' + Discord_ColorFor(msg.author_name) + avUrl + '">' +
                DX_Esc(Discord_Initials(msg.author_name)) + '</div>';
        html += '<div class="discord-message-body">' + reply +
                '<div class="discord-message-top"><span class="discord-message-author discord-open-profile' + (msg.isMine ? ' discord-message-author-me' : '') + '"' + profileAttrs + '>' +
                DX_Esc(msg.author_name) + '</span>' + badge + '<span class="discord-message-time" title="' + fullTime + '">' + DXS_HeaderTime(msg.created_at) + '</span></div>' +
                '<div class="discord-message-text">' + processed.textHtml + editedTag + '</div>' + processed.embedHtml;
    }
    html += reactions + '</div>' + actions + '</div>';
    return html;
}

window.Discord_RenderMessageInnerHTML = function(msg) {
    var prev = DX2.curMsg;
    DX2.curMsg = msg;
    try { return DXS_RenderMessage(msg); } finally { DX2.curMsg = prev; }
};

window.Discord_AppendMessage = function(msg) {
    var container = $("#discord-chat-messages");
    container.find(".dx-intro").remove();
    if (container.find(".discord-chat-empty").length) container.empty();
    if (!container.children().length) { DXS.lastDay = null; DXS.lastTs = 0; Discord.lastMessageAuthor = null; }

    var day = DXS_DayKey(msg.created_at);
    var newDay = DXS.lastDay !== day;
    if (newDay) container.append('<div class="dx-day-divider" data-day="' + day + '"><span>' + DXS_DayLabel(msg.created_at) + '</span></div>');

    msg._grouped = !newDay && !msg.isAnnouncement && !msg.replyPreview &&
                   Discord.lastMessageAuthor === msg.author_name && (msg.created_at - DXS.lastTs) <= 420;
    msg.reactions = msg.reactions || [];
    if (msg.id != null) Discord.messagesById[msg.id] = msg;

    container.append(Discord_RenderMessageInnerHTML(msg));
    Discord.lastMessageAuthor = msg.isAnnouncement ? "\u0000announcement" : msg.author_name;
    DXS.lastDay = day;
    DXS.lastTs = msg.created_at;
};

// "NEW MESSAGES" divider (discord_ext2.js): the message after it must show its header
(function() {
    var orig = window.DX2_PlaceDivider;
    window.DX2_PlaceDivider = function() {
        orig.apply(this, arguments);
        var d = $("#dx-new-divider");
        if (!d.length) return;
        var next = d.next(".discord-message.dx-grouped");
        if (next.length) {
            var id = parseInt(next.attr("data-messageid"), 10), m = Discord.messagesById[id];
            if (m) { m._grouped = false; next.replaceWith(Discord_RenderMessageInnerHTML(m)); }
        }
    };
})();

// ---------------------------------------------------------------------------
// Channel list: categories, per-channel icons, "+" in the category header
// ---------------------------------------------------------------------------

DX_After("Discord_RenderChannelList", function() {
    var list = $("#discord-channel-list");
    if (!list.length || list.find(".dx-category").length) return;
    var items = list.children(".discord-channel-item");
    if (!items.length) return;

    var text = [], stage = [];
    items.each(function() {
        var ch = Discord_FindChannel(parseInt($(this).attr("data-channelid"), 10));
        var name = (ch && ch.name || "").toLowerCase();
        var icon = $(this).children("i").first();
        if (ch && ch.kind === "stage") { stage.push(this); icon.attr("class", "fas fa-podcast"); }
        else {
            text.push(this);
            if (/^(announcements?|news|city-news|updates)$/.test(name)) icon.attr("class", "fas fa-bullhorn");
            else icon.attr("class", "fas fa-hashtag");
        }
    });

    var sid = Discord.currentServerId;
    function cat(key, label, nodes, withAdd) {
        if (!nodes.length) return;
        var collapsed = !!DXS.catCollapsed[sid + ":" + key];
        var head = $('<div class="dx-category' + (collapsed ? ' dx-collapsed' : '') + '" data-cat="' + key + '"><i class="fas fa-chevron-down dx-cat-chev"></i><span>' + label + '</span>' +
                     (withAdd ? '<i class="fas fa-plus dx-cat-add" title="Create Channel"></i>' : '') + '</div>');
        var body = $('<div class="dx-category-body' + (collapsed ? ' dx-collapsed' : '') + '"></div>');
        list.append(head).append(body);
        $.each(nodes, function(i, n) { body.append(n); });
    }
    var addBtn = document.getElementById("discord-add-channel-btn");
    var canAdd = addBtn && addBtn.style.display !== "none";
    cat("text", "Text Channels", text, canAdd);
    cat("stage", "Stage Channels", stage, false);
    $("#discord-add-channel-btn").addClass("dx-hidden");
});
$(document).on("click", ".dx-category", function(e) {
    if ($(e.target).hasClass("dx-cat-add")) { $("#discord-add-channel-btn").trigger("click"); return; }
    var key = Discord.currentServerId + ":" + $(this).attr("data-cat");
    DXS.catCollapsed[key] = !DXS.catCollapsed[key];
    $(this).toggleClass("dx-collapsed", !!DXS.catCollapsed[key]).next(".dx-category-body").toggleClass("dx-collapsed", !!DXS.catCollapsed[key]);
});

// ---------------------------------------------------------------------------
// Rail: tiny white pill for servers that have unread messages
// ---------------------------------------------------------------------------

DX_After("DX_ApplyUnreadUI", function() {
    $(".discord-rail-icon[data-serverid]").each(function() {
        var sid = parseInt($(this).attr("data-serverid"), 10);
        $(this).toggleClass("dx-has-unread", DX2_ServerUnreadUnmuted(sid) > 0);
    });
});

// ---------------------------------------------------------------------------
// Header: search pill, order, members toggle state
// ---------------------------------------------------------------------------

function DXS_BuildChrome() {
    var actions = $(".discord-chat-header-actions");
    // search icon -> pill
    var searchIcon = $("#dx-search-btn");
    if (searchIcon.length && !searchIcon.hasClass("dx-search-pill")) {
        searchIcon.replaceWith('<div class="dx-search-pill" id="dx-search-btn" title="Search messages"><span>Search</span><i class="fas fa-search"></i></div>');
    }
    // order like Discord: tools, leaderboard, pins, members, search
    var order = ["#dx-tools-btn", "#dx-lb-btn", "#discord-chat-pins-btn", "#discord-chat-members-toggle", "#dx-search-btn"];
    $.each(order, function(i, sel) { var el = $(sel); if (el.length) actions.append(el); });
    $("#discord-chat-members-toggle").addClass("dx-active");

    // composer "+" and typed state
    var row = $(".discord-chat-input-row");
    if (row.length && !$("#dx-plus-btn").length) {
        row.prepend('<div class="dx-plus-btn" id="dx-plus-btn" title="Commands &amp; mentions"><i class="fas fa-plus"></i></div>');
        // order: [+] [input] [send] [emoji]
        $("#discord-emoji-btn").appendTo(row);
    }

    // user panel: headphones (silences Discord notification sounds)
    var foot = $("#discord-user-footer");
    if (foot.length && !$("#dx-deaf-btn").length) {
        $('<div class="dx-user-btn" id="dx-deaf-btn" title="Deafen (mute notification sounds)"><i class="fas fa-headphones"></i></div>').insertBefore(foot.find(".discord-user-settings-icon"));
        DXS_ApplyDeaf();
    }

    // search/footers use real quote-safe text
    $("#discord-message-input").attr("autocomplete", "off");
}

function DXS_ApplyDeaf() {
    var b = $("#dx-deaf-btn");
    b.toggleClass("dx-off", DXS.deafened).find("i").attr("class", DXS.deafened ? "fas fa-deaf" : "fas fa-headphones");
    if (DXS.deafened) b.html('<i class="fas fa-volume-mute"></i>'); else b.html('<i class="fas fa-headphones"></i>');
}
$(document).on("click", "#dx-deaf-btn", function(e) {
    e.stopPropagation();
    DXS.deafened = !DXS.deafened;
    try { localStorage.setItem('dxs_deaf', DXS.deafened ? '1' : '0'); } catch (err) {}
    DXS_ApplyDeaf();
    DX_Toast(DXS.deafened ? "Notification sounds are muted." : "Notification sounds are back on.", "info");
});
(function() {
    var orig = window.Discord_PlayNotificationSound;
    window.Discord_PlayNotificationSound = function() {
        if (DXS.deafened) return;
        return orig.apply(this, arguments);
    };
})();

$(document).on("click", "#discord-chat-members-toggle", function() {
    var t = $(this);
    setTimeout(function() { t.toggleClass("dx-active", !$("#discord-members-sidebar").hasClass("discord-hidden") && $("#discord-members-sidebar").css("display") !== "none"); }, 0);
});
$(document).on("input", "#discord-message-input", function() { $(".discord-chat-input-row").toggleClass("dx-typed", $(this).val().length > 0); });
DX_After("Discord_SendMessage", function() { $(".discord-chat-input-row").toggleClass("dx-typed", ($("#discord-message-input").val() || "").length > 0); });
$(document).on("click", "#dx-plus-btn", function(e) {
    var r = this.getBoundingClientRect();
    DX2_Ctx(r.left, r.top - 96, [
        { label: "Use a slash command", icon: "fa-terminal", fn: function() { $("#discord-message-input").val("/").focus().trigger("input"); } },
        { label: "Mention someone", icon: "fa-at", fn: function() { $("#discord-message-input").val(($("#discord-message-input").val() || "") + "@").focus(); } },
    ]);
});

// ---------------------------------------------------------------------------
// Member list: group by hoisted role, then Online / Offline (like Discord)
// ---------------------------------------------------------------------------

function DXS_RegroupMembers() {
    var list = $("#discord-members-list");
    if (!list.length) return;
    var meta = DX.meta[Discord.currentServerId] || {};

    var entries = [], current = null;
    list.children().each(function() {
        var el = $(this);
        if (el.hasClass("discord-members-group-label")) { current = /offline/i.test(el.text()) ? "offline" : "online"; return; }
        if (el.hasClass("discord-member-item")) entries.push({ el: el, online: current !== "offline", id: el.attr("data-memberrowid") });
    });
    if (!entries.length) return;

    var sig = entries.map(function(e) { var m = meta[e.id] || {}; return e.id + (e.online ? "1" : "0") + (m.hoist || ""); }).join("|");
    // skip only when the DOM still is the arrangement we built (a re-render creates fresh, unmarked items)
    var fresh = false;
    $.each(entries, function(i, e) { if (e.el.data("dxs") !== sig) { fresh = true; return false; } });
    if (!fresh) return;

    var groups = {}, order = [], online = [], offline = [];
    $.each(entries, function(i, e) {
        var m = meta[e.id] || {};
        e.el.toggleClass("dx-offline", !e.online);
        if (!e.online) { offline.push(e); return; }
        if (m.hoist) {
            if (!groups[m.hoist]) { groups[m.hoist] = { pos: m.hoistPos || 0, items: [] }; order.push(m.hoist); }
            groups[m.hoist].items.push(e);
        } else online.push(e);
    });
    order.sort(function(a, b) { return groups[b].pos - groups[a].pos; });

    list.children().detach();
    function section(label, items) {
        if (!items.length) return;
        list.append('<div class="discord-members-group-label">' + DX_Esc(label) + " \u2014 " + items.length + "</div>");
        $.each(items, function(i, e) { e.el.data("dxs", sig); list.append(e.el); });
    }
    $.each(order, function(i, name) { section(name, groups[name].items); });
    section("Online", online);
    section("Offline", offline);
}
DX_After("DX_DecorateAll", function() { DXS_RegroupMembers(); DXS_Intro(); });

// ---------------------------------------------------------------------------
// Empty channel intro
// ---------------------------------------------------------------------------

function DXS_Intro() {
    var box = $("#discord-chat-messages");
    var empty = box.find(".discord-chat-empty");
    if (!empty.length || box.find(".dx-intro").length) return;
    var ch = Discord_FindChannel(Discord.currentChannelId);
    if (!ch) return;
    empty.replaceWith('<div class="dx-intro"><div class="dx-intro-ico"><i class="fas ' + (ch.kind === "stage" ? "fa-podcast" : "fa-hashtag") + '"></i></div>' +
                      '<h1>Welcome to #' + DX_Esc(ch.name) + '!</h1><p>This is the start of the #' + DX_Esc(ch.name) + ' channel.</p></div>');
}
DX_After("Discord_OpenChannel", function() { setTimeout(DXS_Intro, 350); });

// ---------------------------------------------------------------------------
// Profile card: role chips + member since (data comes from GetMemberMeta)
// ---------------------------------------------------------------------------

DX_After("Discord_OpenMemberProfile", function(memberId) {
    var tries = 0;
    var t = setInterval(function() {
        tries++;
        var card = $("#discord-modal-profile-view");
        if ((card.length && card.find("#discord-pv-name").text().trim() !== "") || tries > 12) {
            clearInterval(t);
            var m = (DX.meta[Discord.currentServerId] || {})[String(memberId)];
            card.find(".dx-roles-section").remove();
            if (!m || !m.roles || !m.roles.length) return;
            var chips = "";
            $.each(m.roles, function(i, r) { chips += '<span class="dx-role-pill"><i style="background:' + DX_Esc(r.color || "#99AAB5") + '"></i>' + DX_Esc(r.name) + "</span>"; });
            var section = $('<div class="discord-profile-section dx-roles-section"><div class="discord-profile-section-title">Roles</div><div class="dx-role-chips">' + chips + "</div></div>");
            var anchor = card.find(".discord-profile-body .discord-profile-section").first();
            if (anchor.length) anchor.before(section); else card.find(".discord-profile-body").append(section);
        }
    }, 80);
});

$(function() { setTimeout(DXS_BuildChrome, 0); });

// ---------------------------------------------------------------------------
// Server menu -> dropdown under the server name (like Discord)
// ---------------------------------------------------------------------------

(function() {
    var origOpen = window.Discord_OpenModal;
    window.Discord_OpenModal = function(id) {
        DX2_HideCard(); DX2_HideCtx();
        $("#discord-modal-overlay").removeClass("dx-dropdown");
        return origOpen.apply(this, arguments);
    };
})();

var DXS_MENU_ICONS = {
    "dx-open-tools-btn": ["fa-gem", "Server Boost"], "dx-open-lb-btn": ["fa-trophy", "Leaderboard"], "dx-menu-roles-btn": ["fa-shield-alt", "Roles & Permissions"],
    "discord-create-channel-open-btn": ["fa-plus-circle", "Create Channel"], "discord-open-settings-btn": ["fa-cog", "Server Settings"],
    "dx-nick-btn": ["fa-id-badge", "Edit Server Nickname"], "discord-leave-server-btn": ["fa-sign-out-alt", "Leave Server"], "discord-delete-server-btn": ["fa-trash-alt", "Delete Server"],
};
DX_After("Discord_OpenServerMenu", function() {
    var menu = $("#discord-modal-server-menu");
    if (!menu.length) return;
    $("#discord-modal-overlay").addClass("dx-dropdown");
    if (!$("#dx-invite-item").length) {
        menu.find(".discord-modal-buttons").prepend('<div class="discord-modal-btn" id="dx-invite-item"><span>Invite People</span><i class="fas fa-user-plus"></i></div>');
    }
    $.each(DXS_MENU_ICONS, function(id, def) {
        var b = $("#" + id);
        if (!b.length) return;
        b.html("<span>" + def[1] + "</span><i class=\"fas " + def[0] + "\"></i>");
    });
    var hdr = document.querySelector(".discord-server-header");
    if (hdr) {
        var r = hdr.getBoundingClientRect();
        menu.css({ left: Math.round(r.left + 10) + "px", top: Math.round(r.bottom + 6) + "px", width: Math.max(200, Math.round(r.width - 20)) + "px" });
    }
});
$(document).on("click", "#dx-invite-item", function() {
    var info = DX2_Info(), server = Discord_FindServer(Discord.currentServerId);
    var link = info && info.vanity ? info.vanity : (server && server.invite_code) || "";
    if (link) { DX2_CopyText(link); DX_Toast("Invite code copied: " + link, "success"); }
});

// ---------------------------------------------------------------------------
// Server settings: the Tools modal becomes a full "Server Settings" screen
// ---------------------------------------------------------------------------

var DXS_TABS = [
    { key: "overview", label: "Overview",     icon: "fa-info-circle" },
    { key: "roles",    label: "Roles",        icon: "fa-shield-alt" },
    { key: "emoji",    label: "Emoji",        icon: "fa-smile" },
    { key: "boost",    label: "Server Boost", icon: "fa-gem" },
    { key: "invites",  label: "Invites",      icon: "fa-link" },
    { key: "safety",   label: "Safety Setup", icon: "fa-user-shield" },
];
var DXS_SECTION_TABS = [
    ["server boost", "boost"], ["vip listing", "boost"], ["server colour", "overview"], ["server profile", "overview"], ["template", "overview"],
    ["custom reaction emoji", "emoji"], ["uploaded emoji", "emoji"], ["server icon", "overview"], ["auto-mod", "safety"], ["roles", "roles"], ["invites", "invites"],
];
DXS.setTab = "overview";

function DXS_BuildSettings() {
    var m = $("#dx-modal-tools");
    if (!m.length || m.hasClass("dx-settings")) return;
    m.addClass("dx-settings");
    var body = $("#dx-tools-body").detach(), title = $("#dx-tools-title").detach().hide();
    m.empty().append(title);
    m.append('<div class="dx-set-nav"><div class="dx-set-server" id="dx-set-server"></div><div id="dx-set-tabs"></div></div>' +
             '<div class="dx-set-main"><div class="dx-set-head"><h2 id="dx-set-heading"></h2>' +
             '<div class="dx-set-esc" data-discordmodalclose="1" title="Close (ESC)"><i class="fas fa-times"></i><span>ESC</span></div></div></div>');
    m.find(".dx-set-main").append(body);
}

function DXS_ApplySettingsTabs() {
    var body = $("#dx-tools-body");
    var present = {};
    body.children(".dx-section").each(function() {
        var h = $(this).children("h4").first().text().toLowerCase();
        var tab = "overview";
        $.each(DXS_SECTION_TABS, function(i, p) { if (h.indexOf(p[0]) === 0) { tab = p[1]; return false; } });
        $(this).attr("data-tab", tab);
        present[tab] = true;
    });
    var server = Discord_FindServer(Discord.currentServerId);
    $("#dx-set-server").text(server ? server.name : "Server");
    var html = '<div class="dx-set-label">' + DX_Esc(server ? server.name : "Server") + "</div>";
    var firstPresent = null;
    $.each(DXS_TABS, function(i, t) {
        if (!present[t.key] && t.key !== "boost") return;
        if (!firstPresent) firstPresent = t.key;
        html += '<div class="dx-set-tab' + (DXS.setTab === t.key ? " dx-sel" : "") + '" data-settab="' + t.key + '"><i class="fas ' + t.icon + '"></i><span>' + t.label + "</span></div>";
    });
    $("#dx-set-tabs").html(html);
    if (!present[DXS.setTab] && DXS.setTab !== "boost") DXS.setTab = firstPresent || "overview";
    DXS_ShowTab(DXS.setTab);
}
function DXS_ShowTab(key) {
    DXS.setTab = key;
    $("#dx-tools-body").attr("data-active", key);
    $("#dx-tools-body > .dx-section").each(function() { $(this).toggle($(this).attr("data-tab") === key); });
    $(".dx-set-tab").removeClass("dx-sel").filter('[data-settab="' + key + '"]').addClass("dx-sel");
    var def = DXS_TABS.filter(function(t) { return t.key === key; })[0];
    $("#dx-set-heading").text(def ? def.label : "");
}
DX_After("DX_RenderTools", DXS_ApplySettingsTabs);
$(document).on("click", ".dx-set-tab", function() { DXS_ShowTab($(this).attr("data-settab")); });
$(document).on("keydown", function(e) {
    if (e.key === "Escape" && $("#dx-modal-tools").hasClass("discord-modal-active")) { /* discord.js closes modals on Esc */ }
});

// ---------------------------------------------------------------------------
// Roles: list on the left, editor on the right
// ---------------------------------------------------------------------------

DX_After("DX2_RenderRoles", function() {
    var body = $("#dx-roles-body");
    if (!body.length || body.find(".dx-roles-wrap").length) return;
    var chips = body.children(".dx-chips-row").detach();
    var editor = body.children("#dx-role-editor").detach();
    body.empty().append($('<div class="dx-roles-wrap"></div>').append($('<div class="dx-roles-left"></div>').append(chips)).append($('<div class="dx-roles-right"></div>').append(editor)));
});

$(function() { setTimeout(DXS_BuildSettings, 0); });
