// ============================================================================
// Discord v11 — front-end: avatars (image URLs / gallery), uploaded server emoji,
// Home with Friends + Direct Messages. Loaded AFTER discord_skin.js.
// Server side: server/discord_ext4.lua, NUI bridges: client/discord_ext.lua.
// ============================================================================

var DXD = {
    mode: "server",            // server | home | dm
    tab: "online",             // friends tabs: online | all | pending | blocked | add
    social: null,              // last GetSocial reply
    me: { uid: null, avatar: null },
    dmId: null, dmUser: null, dmCanSend: true,
    dmOldest: null, dmHasMore: false,
    dmState: { lastDay: null, lastTs: 0, lastAuthor: null },
    dmMsgs: {},
    prevServer: null,
    socialTimer: null,
    pickCb: null,
    addMsg: null,
};

// ---------------------------------------------------------------------------
// Avatars
// ---------------------------------------------------------------------------

function DXD_Initials(name) { return Discord_Initials(name || "?"); }
function DXD_Img(url) { return url ? ';background-image:url(&quot;' + DX_Esc(url) + '&quot;)' : ''; }

function DXD_AvatarHtml(user, cls) {
    var name = user.name || "?";
    return '<div class="dx-av ' + (cls || "") + (user.avatar ? " dx-img" : "") + '" style="background-color:' + Discord_ColorFor(name) + DXD_Img(user.avatar) + '">' +
           DX_Esc(DXD_Initials(name)) +
           (user.status ? '<span class="discord-member-status-dot' + (user.status !== "offline" ? " discord-status-" + user.status : "") + '"></span>' : "") + "</div>";
}

function DXD_SetBg(el, url, color) {
    if (!el) return;
    if (url) { el.style.backgroundImage = 'url("' + url.replace(/"/g, "%22") + '")'; el.classList.add("dx-img"); }
    else { el.style.backgroundImage = ""; el.classList.remove("dx-img"); }
    if (color) el.style.backgroundColor = color;
}

function DXD_MetaOf(memberId) { var m = DX.meta[Discord.currentServerId]; return m ? m[String(memberId)] : null; }

// messages: the avatar comes from the member meta
(function() {
    var orig = window.Discord_RenderMessageInnerHTML;
    window.Discord_RenderMessageInnerHTML = function(msg) {
        if (!msg._dm && msg.authorMemberId != null) {
            var m = DXD_MetaOf(msg.authorMemberId);
            msg._avatarUrl = (m && m.avatar) || null;
        }
        return orig(msg);
    };
})();

DX_After("DX_DecorateAll", function() {
    var meta = DX.meta[Discord.currentServerId];
    if (!meta || DXD.mode !== "server") return;
    $("#discord-chat-messages .discord-message-avatar[data-authorid]").each(function() {
        var m = meta[$(this).attr("data-authorid")];
        DXD_SetBg(this, m && m.avatar);
    });
    $("#discord-members-list .discord-member-item").each(function() {
        var m = meta[$(this).attr("data-memberrowid")];
        var av = $(this).find(".discord-member-avatar")[0];
        if (av) DXD_SetBg(av, m && m.avatar);
    });
});

function DXD_ApplyMyAvatar() {
    DXD_SetBg(document.getElementById("discord-my-avatar"), DXD.me.avatar);
    var el = document.getElementById("discord-my-avatar");
    if (el) { el.classList.toggle("dx-img", !!DXD.me.avatar); if (DXD.me.avatar) el.style.color = "transparent"; else el.style.color = ""; }
}

function DXD_LoadMe(cb) {
    DX_Post("DiscordExt_GetMyDiscord", {}, function(r) {
        if (r && typeof r === "object") { DXD.me = { uid: r.uid, avatar: r.avatar, discriminator: r.discriminator }; DXD_ApplyMyAvatar(); }
        if (cb) cb();
    });
}

// server icons on the rail
function DXD_DecorateRailIcons() {
    $(".discord-rail-icon[data-serverid]").each(function() {
        var info = DX.info[parseInt($(this).attr("data-serverid"), 10)];
        var url = info && info.iconUrl;
        DXD_SetBg(this, url);
        this.classList.toggle("dx-icon-img", !!url);
    });
}
DX_After("DX_DecorateRail", DXD_DecorateRailIcons);
DX_After("DX_LoadInfo", DXD_DecorateRailIcons);
DX_After("Discord_RenderServerRail", DXD_DecorateRailIcons);
(function() {
    var orig = window.DX_LoadInfo;
    window.DX_LoadInfo = function(serverId, cb) {
        return orig(serverId, function(info) { try { DXD_DecorateRailIcons(); } catch (e) {} if (cb) cb(info); });
    };
})();

// ---------------------------------------------------------------------------
// Gallery picker (for avatar / server icon / emoji)
// ---------------------------------------------------------------------------

function DXD_PickImage(cb) {
    DXD.pickCb = cb;
    Discord_OpenModal("dx-modal-gallery");
    $("#dx-gallery-grid").html('<div class="dx-empty">Loading...</div>');
    DX_Post("DiscordExt_GetGalleryImages", {}, function(list) {
        if (!list || !list.length) { $("#dx-gallery-grid").html('<div class="dx-empty">Your phone gallery has no photos yet. Take one with the camera, or paste an image link instead.</div>'); return; }
        var html = "";
        $.each(list, function(i, url) { html += '<div class="dx-gal-item" data-url="' + DX_Esc(url) + '" style="background-image:url(&quot;' + DX_Esc(url) + '&quot;)"></div>'; });
        $("#dx-gallery-grid").html(html);
    });
}
$(document).on("click", ".dx-gal-item", function() {
    var url = $(this).attr("data-url"), cb = DXD.pickCb;
    DXD.pickCb = null;
    Discord_CloseModals();
    if (cb) cb(url);
});

var DXD_URL_ERR = "That link isn't allowed. Use a direct https image link or pick a photo from your gallery.";

// ---- profile editor: avatar section
DX_After("Discord_OpenProfileEditor", function() {
    var m = $("#discord-modal-profile-edit");
    if (!m.length) return;
    m.find(".dx-avatar-edit").remove();
    var box = $('<div class="dx-avatar-edit"><div class="discord-settings-label">Avatar</div>' +
                '<div class="dx-avatar-row"><div class="dx-av dx-av-lg' + (DXD.me.avatar ? " dx-img" : "") + '" id="dx-avatar-preview" style="background-color:' + Discord_ColorFor(Discord.myName || "?") + DXD_Img(DXD.me.avatar) + '">' + DX_Esc(DXD_Initials(Discord.myName)) + "</div>" +
                '<div class="dx-avatar-controls"><input type="text" id="dx-avatar-url" maxlength="400" placeholder="https://… image link" spellcheck="false" value="' + DX_Esc(DXD.me.avatar || "") + '">' +
                '<div class="dx-row"><div class="dx-btn dx-primary" id="dx-avatar-save">Save</div><div class="dx-btn" id="dx-avatar-gallery"><i class="fas fa-images"></i> Gallery</div>' +
                '<div class="dx-btn" id="dx-avatar-remove">Remove</div></div></div></div></div>');
    m.find(".discord-modal-title").after(box);
});
function DXD_SaveAvatar(url) {
    DX_Post("DiscordExt_SetAvatar", { url: url }, function(r) {
        if (!r || !r.ok) { DX_Toast(r && r.error === "BAD_URL" ? DXD_URL_ERR : "Could not save your avatar.", "error"); return; }
        DXD.me.avatar = r.avatar || null;
        DXD_ApplyMyAvatar();
        DXD_SetBg(document.getElementById("dx-avatar-preview"), DXD.me.avatar);
        $("#dx-avatar-url").val(DXD.me.avatar || "");
        DX_Toast(DXD.me.avatar ? "Avatar updated." : "Avatar removed.", "success");
    });
}
$(document).on("click", "#dx-avatar-save", function() { DXD_SaveAvatar($("#dx-avatar-url").val().trim()); });
$(document).on("click", "#dx-avatar-remove", function() { DXD_SaveAvatar(""); });
$(document).on("click", "#dx-avatar-gallery", function() {
    DXD_PickImage(function(url) {
        DXD_SaveAvatar(url);
        setTimeout(function() { Discord_OpenProfileEditor(); }, 150);
    });
});

// ---------------------------------------------------------------------------
// Settings: server icon + uploaded emoji
// ---------------------------------------------------------------------------

DX_After("DX_RenderTools", function(info) {
    var body = $("#dx-tools-body");
    if (!info || !body.length) return;
    if (info.canConfigure) {
        var server = Discord_FindServer(info.serverId) || {};
        body.append('<div class="dx-section" data-tab="overview"><h4>Server icon</h4><div class="dx-avatar-row">' +
                    '<div class="dx-av dx-av-lg dx-square' + (info.iconUrl ? " dx-img" : "") + '" style="background-color:' + DX_Esc(server.icon_color || "#5865F2") + DXD_Img(info.iconUrl) + '">' + DX_Esc(server.icon_text || "") + "</div>" +
                    '<div class="dx-avatar-controls"><input type="text" class="dx-input" id="dx-icon-url" maxlength="400" placeholder="https://… image link" spellcheck="false" value="' + DX_Esc(info.iconUrl || "") + '">' +
                    '<div class="dx-row"><div class="dx-btn dx-primary" id="dx-icon-save">Save</div><div class="dx-btn" id="dx-icon-gallery"><i class="fas fa-images"></i> Gallery</div><div class="dx-btn" id="dx-icon-remove">Remove</div></div></div></div></div>');
        var slots = info.emojiSlots || 0, used = (info.customEmojis || []).length + (info.emojiImages || []).length;
        var html = '<div class="dx-section" data-tab="emoji"><h4>Uploaded emoji (' + (info.emojiImages || []).length + ')</h4>';
        if (slots === 0) html += '<div class="dx-muted">Unlock emoji slots with Level 1 boosts.</div>';
        else {
            html += '<div class="dx-muted" style="margin-bottom:8px">Use them in chat as <b>:name:</b>. Slots used: ' + used + "/" + slots + ".</div>";
            html += '<div class="dx-emoji-list">';
            $.each(info.emojiImages || [], function(i, e) { html += '<div class="dx-emoji-card"><img class="dx-emoji" src="' + DX_Esc(e.url) + '"><span>:' + DX_Esc(e.name) + ':</span><i class="fas fa-times" data-delimg="' + DX_Esc(e.name) + '"></i></div>'; });
            html += "</div>";
            if (used < slots) {
                html += '<div class="dx-row" style="margin-top:10px"><input type="text" class="dx-input" id="dx-emj-name" maxlength="12" placeholder="name (a-z, 0-9, _)" style="max-width:150px" spellcheck="false">' +
                        '<input type="text" class="dx-input" id="dx-emj-url" maxlength="400" placeholder="https://… image link" spellcheck="false"></div>' +
                        '<div class="dx-row" style="margin-top:8px"><div class="dx-btn dx-primary" id="dx-emj-add">Upload</div><div class="dx-btn" id="dx-emj-gallery"><i class="fas fa-images"></i> Pick from gallery</div></div>';
            } else html += '<div class="dx-muted" style="margin-top:8px">All emoji slots are used.</div>';
        }
        body.append(html + "</div>");
    }
    if (window.DXS_ApplySettingsTabs) DXS_ApplySettingsTabs();
});

function DXD_IconSave(url) {
    DX_Post("DiscordExt_SetServerIcon", { serverId: Discord.currentServerId, url: url }, function(r) {
        if (r && r.ok) { DX_Toast("Server icon saved.", "success"); DX_LoadInfo(Discord.currentServerId, function(info) { if (info) DX_RenderTools(info); DXD_DecorateRailIcons(); }); }
        else DX_Toast(r && r.error === "BAD_URL" ? DXD_URL_ERR : "Could not save the icon.", "error");
    });
}
$(document).on("click", "#dx-icon-save", function() { DXD_IconSave($("#dx-icon-url").val().trim()); });
$(document).on("click", "#dx-icon-remove", function() { DXD_IconSave(""); });
$(document).on("click", "#dx-icon-gallery", function() { DXD_PickImage(function(url) { DXD_IconSave(url); }); });

function DXD_AddEmoji(url) {
    var name = ($("#dx-emj-name").val() || "").trim().toLowerCase();
    if (!/^[a-z0-9_]{2,12}$/.test(name)) { DX_Toast("Give the emoji a name: 2-12 letters, numbers or _.", "warn"); return; }
    DX_Post("DiscordExt_AddImageEmoji", { serverId: Discord.currentServerId, name: name, url: url }, function(r) {
        if (r && r.ok) { DX_Toast("Emoji :" + name + ": added.", "success"); DX_ToolsRefresh(); }
        else DX_Toast(r && r.error === "BAD_URL" ? DXD_URL_ERR : r && r.error === "TAKEN" ? "That name is already used." : r && r.error === "NO_SLOTS" ? "No free emoji slots." : "Could not add the emoji.", "error");
    });
}
$(document).on("click", "#dx-emj-add", function() { DXD_AddEmoji(($("#dx-emj-url").val() || "").trim()); });
$(document).on("click", "#dx-emj-gallery", function() {
    var name = $("#dx-emj-name").val();
    DXD_PickImage(function(url) { setTimeout(function() { $("#dx-emj-name").val(name); DXD_AddEmoji(url); }, 50); });
});
$(document).on("click", "[data-delimg]", function() {
    DX_Post("DiscordExt_RemoveImageEmoji", { serverId: Discord.currentServerId, name: $(this).attr("data-delimg") }, function() { DX_ToolsRefresh(); });
});

// emoji picker: "This server" row, reactions with :name:, composer autocomplete
DX_After("Discord_OpenEmojiPicker", function() {
    var info = DX2_Info(), list = (info && info.emojiImages) || [];
    if (!list.length || DXD.mode !== "server") return;
    var html = '<div class="dx-picker-label">This server</div>';
    $.each(list, function(i, e) { html += '<div class="discord-emoji-picker-item dx-img-emoji" data-emoji=":' + DX_Esc(e.name) + ':" title=":' + DX_Esc(e.name) + ':"><img class="dx-emoji" src="' + DX_Esc(e.url) + '"></div>'; });
    html += '<div class="dx-picker-label">Default</div>';
    $("#discord-emoji-picker").prepend(html);
});
(function() {
    var orig = window.Discord_RenderReactionsHTML;
    window.Discord_RenderReactionsHTML = function(reactions) {
        var html = orig(reactions);
        return html.replace(/(data-emoji="(:[a-z0-9_]{2,12}:)">)(:[a-z0-9_]{2,12}:)( <span>)/gi, function(full, a, token, text, b) {
            var url = DX2_EmojiUrl(token.slice(1, -1));
            return url ? a + '<img class="dx-emoji" src="' + DX_Esc(url) + '" alt="' + DX_Esc(token) + '">' + b : full;
        });
    };
})();

// (:name: / @mention autocomplete lives in discord_polish.js)

// ---------------------------------------------------------------------------
// Social data
// ---------------------------------------------------------------------------

function DXD_Counts() {
    var s = DXD.social || {};
    return { dm: s.dmUnread || 0, pending: (s.incoming || []).length };
}
window.DXD_ExtraUnread = function() { var c = DXD_Counts(); return c.dm + c.pending; };

function DXD_UpdateBadges() {
    var c = DXD_Counts(), n = c.dm + c.pending;
    $("#dx-home-badge").text(n > 99 ? "99+" : n).toggleClass("dx-visible", n > 0);
    $("#dx-nav-pending").text(c.pending).toggle(c.pending > 0);
    if (window.DX_ApplyUnreadUI) DX_ApplyUnreadUI();
}

function DXD_LoadSocial(cb) {
    DX_Post("DiscordExt_GetSocial", {}, function(r) {
        if (r && typeof r === "object") DXD.social = r;
        DXD_UpdateBadges();
        if (DXD.mode === "home" || DXD.mode === "dm") { DXD_RenderDmList(); if (DXD.mode === "home") DXD_RenderFriends(); }
        if (cb) cb();
    });
}
function DXD_LoadSocialSoon() { clearTimeout(DXD.socialTimer); DXD.socialTimer = setTimeout(DXD_LoadSocial, 250); }

function DXD_FindUser(uid) {
    var s = DXD.social || {}, found = null;
    $.each([].concat(s.friends || [], s.incoming || [], s.outgoing || [], s.blocked || []), function(i, u) { if (u && u.uid === uid) { found = u; return false; } });
    if (!found) $.each(s.dms || [], function(i, d) { if (d.user && d.user.uid === uid) { found = d.user; return false; } });
    return found;
}
function DXD_RelationOf(uid) {
    var s = DXD.social || {}, rel = "none";
    $.each(s.friends || [], function(i, u) { if (u.uid === uid) rel = "friend"; });
    $.each(s.incoming || [], function(i, u) { if (u.uid === uid) rel = "incoming"; });
    $.each(s.outgoing || [], function(i, u) { if (u.uid === uid) rel = "outgoing"; });
    $.each(s.blocked || [], function(i, u) { if (u.uid === uid) rel = "blocked"; });
    return rel;
}

// ---------------------------------------------------------------------------
// Layout: Home button, Home sidebar, Friends page
// ---------------------------------------------------------------------------

function DXD_BuildUI() {
    var rail = $(".discord-rail");
    if (!rail.length || $("#dx-home-btn").length) return;
    rail.prepend('<div class="discord-rail-icon dx-home-btn" id="dx-home-btn" title="Direct Messages"><i class="fab fa-discord"></i><div class="dx-home-badge" id="dx-home-badge"></div></div>' +
                 '<div class="discord-rail-divider" id="dx-home-divider"></div>');

    $(".discord-channel-sidebar").prepend(
        '<div id="dx-home-sidebar">' +
            '<div class="dx-home-search"><input type="text" id="dx-dm-filter" placeholder="Find a conversation" spellcheck="false" dir="auto"></div>' +
            '<div class="dx-home-scroll">' +
                '<div class="dx-nav-item" id="dx-nav-friends"><i class="fas fa-user-friends"></i><span>Friends</span><em class="dx-nav-badge" id="dx-nav-pending" style="display:none">0</em></div>' +
                '<div class="dx-category-lite">Direct Messages</div>' +
                '<div id="dx-dm-list"></div>' +
            "</div>" +
        "</div>");

    $(".discord-chat-column").prepend(
        '<div id="dx-friends-page">' +
            '<div class="dx-friends-head"><div class="dx-fh-title"><i class="fas fa-user-friends"></i> Friends</div><div class="dx-fh-sep"></div>' +
            '<div class="dx-ftab" data-ftab="online">Online</div><div class="dx-ftab" data-ftab="all">All</div>' +
            '<div class="dx-ftab" data-ftab="pending">Pending<em class="dx-nav-badge" id="dx-tab-pending" style="display:none">0</em></div>' +
            '<div class="dx-ftab" data-ftab="blocked">Blocked</div><div class="dx-ftab dx-ftab-add" data-ftab="add">Add Friend</div></div>' +
            '<div class="dx-friends-body" id="dx-friends-body"></div>' +
        "</div>");

    $("#discord-modal-overlay").append(
        '<div class="discord-modal dx-modal-wide" id="dx-modal-gallery"><div class="discord-modal-title">Choose a photo</div><div class="dx-gal-grid" id="dx-gallery-grid"></div>' +
        '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Cancel</div></div></div>');

    $(".discord-chat-column").append('<div id="dx-emoji-menu"></div>');
}

function DXD_SetMode(mode) {
    DXD.mode = mode;
    var w = $(".discord-window");
    w.toggleClass("dx-home-mode", mode === "home" || mode === "dm");
    w.toggleClass("dx-dm-mode", mode === "dm");
    w.toggleClass("dx-friends-mode", mode === "home");
    $("#dx-home-btn").toggleClass("selected-discord-server", mode !== "server");
    if (mode !== "server") $(".discord-rail-icon[data-serverid]").removeClass("selected-discord-server");
}

function DXD_EnterHome(tab) {
    if (DXD.mode === "server") DXD.prevServer = Discord.currentServerId;
    DXD.dmId = null;
    Discord.currentServerId = null;
    Discord.currentChannelId = null;
    DXD_SetMode("home");
    if (tab) DXD.tab = tab;
    $("#discord-chat-active, #discord-empty-state, #discord-channel-empty").removeClass("discord-visible");
    DXD_RenderDmList();
    DXD_RenderFriends();
    DXD_LoadSocial();
}
function DXD_LeaveHome() {
    if (DXD.mode === "server") return;
    DXD_SetMode("server");
    DXD.dmId = null;
    DXD.dmMsgs = {};
    $(".discord-chat-hash").text("#").removeClass("dx-dm-at");
    $(".dx-dm-status").remove();
    $("#discord-chat-messages").empty();
    $(".discord-chat-input-row").removeClass("discord-composer-locked");
    $("#discord-message-input").prop("disabled", false);
}
$(document).on("click", "#dx-home-btn", function() { if (DXD.mode !== "home") DXD_EnterHome(); });
$(document).on("click", "#dx-nav-friends", function() { DXD_EnterHome(); });

(function() {
    var orig = window.Discord_SelectServer;
    window.Discord_SelectServer = function(serverId) {
        if (DXD.mode !== "server") DXD_LeaveHome();
        return orig.apply(this, arguments);
    };
    var origSend = window.Discord_SendMessage;
    window.Discord_SendMessage = function() {
        if (DXD.mode === "dm") return DXD_SendDM();
        return origSend.apply(this, arguments);
    };
})();

// ---------------------------------------------------------------------------
// DM list (sidebar)
// ---------------------------------------------------------------------------

function DXD_Snippet(text) { return String(text || "").replace(/\s+/g, " ").slice(0, 40); }

function DXD_RenderDmList() {
    var s = DXD.social || { dms: [] }, q = ($("#dx-dm-filter").val() || "").toLowerCase();
    var html = "";
    $.each(s.dms || [], function(i, d) {
        if (!d.user) return;
        if (q && d.user.name.toLowerCase().indexOf(q) < 0) return;
        html += '<div class="dx-dm-row' + (DXD.dmId === d.id ? " dx-sel" : "") + (d.unread > 0 ? " dx-unread" : "") + '" data-dmid="' + d.id + '" data-uid="' + d.user.uid + '">' +
                DXD_AvatarHtml(d.user, "dx-av-sm") +
                '<div class="dx-dm-text"><div class="dx-dm-name">' + DX_Esc(d.user.name) + "</div>" +
                '<div class="dx-dm-sub">' + (d.lastMine ? "You: " : "") + DX_Esc(DXD_Snippet(d.lastMessage)) + "</div></div>" +
                (d.unread > 0 ? '<span class="dx-channel-badge">' + (d.unread > 99 ? "99+" : d.unread) + "</span>" : "") + "</div>";
    });
    if (!html) html = '<div class="dx-dm-empty">' + (q ? "No matches." : "No conversations yet. Add a friend and say hi!") + "</div>";
    $("#dx-dm-list").html(html);
    $("#dx-nav-friends").toggleClass("dx-sel", DXD.mode === "home");
}
$(document).on("input", "#dx-dm-filter", DXD_RenderDmList);
$(document).on("click", ".dx-dm-row", function() { DXD_OpenDmByUid(parseInt($(this).attr("data-uid"), 10)); });

// ---------------------------------------------------------------------------
// Friends page
// ---------------------------------------------------------------------------

function DXD_FriendRow(u, actions, sub) {
    return '<div class="dx-frow" data-uid="' + u.uid + '">' + DXD_AvatarHtml(u, "") +
           '<div class="dx-ftext"><div class="dx-fname">' + DX_Esc(u.name) + '<span class="dx-ftag">' + DX_Esc(u.name.replace(/\s+/g, "").toLowerCase()) + " #" + DX_Esc(u.discriminator || "0000") + "</span></div>" +
           '<div class="dx-fsub">' + DX_Esc(sub) + '</div></div><div class="dx-factions">' + actions + "</div></div>";
}
function DXD_StatusLabel(u) {
    if (u.activity) return u.activity;
    if (u.customStatus) return u.customStatus;
    return ({ online: "Online", idle: "Idle", dnd: "Do Not Disturb", offline: "Offline" })[u.status] || "Offline";
}

function DXD_RenderFriends() {
    var s = DXD.social || { friends: [], incoming: [], outgoing: [], blocked: [] };
    var c = DXD_Counts();
    $("#dx-tab-pending").text(c.pending).toggle(c.pending > 0);
    $(".dx-ftab").each(function() { $(this).toggleClass("dx-sel", $(this).attr("data-ftab") === DXD.tab); });
    var body = $("#dx-friends-body"), html = "";
    var msgBtn = '<div class="dx-fbtn" data-act="message" title="Message"><i class="fas fa-comment"></i></div>';
    var moreBtn = '<div class="dx-fbtn" data-act="more" title="More"><i class="fas fa-ellipsis-v"></i></div>';

    if (DXD.tab === "online" || DXD.tab === "all") {
        var list = (s.friends || []).filter(function(u) { return DXD.tab === "all" || u.status !== "offline"; });
        html += '<div class="dx-flabel">' + (DXD.tab === "online" ? "Online" : "All friends") + " \u2014 " + list.length + "</div>";
        if (!list.length) html += '<div class="dx-fempty"><i class="fas fa-user-friends"></i><p>' + (DXD.tab === "online" ? "No one is around to play with Wumpus." : "You have no friends yet. Use \u201CAdd Friend\u201D to send a request.") + "</p></div>";
        $.each(list, function(i, u) { html += DXD_FriendRow(u, msgBtn + moreBtn, DXD_StatusLabel(u)); });
    } else if (DXD.tab === "pending") {
        var total = (s.incoming || []).length + (s.outgoing || []).length;
        html += '<div class="dx-flabel">Pending \u2014 ' + total + "</div>";
        if (!total) html += '<div class="dx-fempty"><i class="fas fa-hourglass-half"></i><p>There are no pending friend requests.</p></div>';
        $.each(s.incoming || [], function(i, u) { html += DXD_FriendRow(u, '<div class="dx-fbtn dx-yes" data-act="accept" title="Accept"><i class="fas fa-check"></i></div><div class="dx-fbtn dx-no" data-act="decline" title="Ignore"><i class="fas fa-times"></i></div>', "Incoming Friend Request"); });
        $.each(s.outgoing || [], function(i, u) { html += DXD_FriendRow(u, '<div class="dx-fbtn dx-no" data-act="cancel" title="Cancel"><i class="fas fa-times"></i></div>', "Outgoing Friend Request"); });
    } else if (DXD.tab === "blocked") {
        html += '<div class="dx-flabel">Blocked \u2014 ' + (s.blocked || []).length + "</div>";
        if (!(s.blocked || []).length) html += '<div class="dx-fempty"><i class="fas fa-ban"></i><p>You can\'t unblock the Wumpus.</p></div>';
        $.each(s.blocked || [], function(i, u) { html += DXD_FriendRow(u, '<div class="dx-fbtn dx-no" data-act="unblock" title="Unblock"><i class="fas fa-user-slash"></i></div>', "Blocked"); });
    } else {
        var tag = DXD.me.discriminator ? (Discord.myName || "").replace(/\s+/g, "").toLowerCase() + " #" + DXD.me.discriminator : "";
        html += '<div class="dx-addfriend"><h2>Add Friend</h2><p>You can add friends with their Discord tag, like <b>sam carter #1234</b>.' + (tag ? " Yours is <b>" + DX_Esc(tag) + "</b>." : "") + "</p>" +
                '<div class="dx-addrow"><input type="text" id="dx-add-tag" maxlength="60" placeholder="You can add friends with their Discord tag." spellcheck="false" dir="auto"><div class="dx-btn dx-primary" id="dx-add-send">Send Friend Request</div></div>' +
                '<div class="dx-addmsg" id="dx-add-msg"></div></div>';
    }
    body.html(html);
    if (DXD.tab === "add" && DXD.addMsg) $("#dx-add-msg").text(DXD.addMsg.text).addClass(DXD.addMsg.ok ? "dx-ok" : "dx-bad");
}
$(document).on("click", ".dx-ftab", function() { DXD.tab = $(this).attr("data-ftab"); DXD.addMsg = null; DXD_RenderFriends(); });

var DXD_ADD_ERR = {
    NOT_FOUND: "Hm, didn't work. Double check that the tag is correct.", SELF: "You can't add yourself.", ALREADY: "You are already friends.",
    PENDING: "You already sent this person a request.", LIMIT: "Your friend list is full.", LIMIT_PENDING: "You have too many pending requests.",
    BAD_TAG: "Use the format  name #1234.", NO_ACCOUNT: "Open Discord and sign in first.",
};
function DXD_SendAdd() {
    var tag = ($("#dx-add-tag").val() || "").trim();
    if (!tag) return;
    DX_Post("DiscordExt_AddFriendByTag", { tag: tag }, function(r) {
        if (r && r.ok) {
            DXD.addMsg = { ok: true, text: r.status === "accepted" ? "You are now friends with " + tag + "!" : "Success! Your friend request to " + tag + " was sent." };
            DXD_LoadSocial();
        } else DXD.addMsg = { ok: false, text: DXD_ADD_ERR[r && r.error] || "Something went wrong." };
        DXD_RenderFriends();
    });
}
$(document).on("click", "#dx-add-send", DXD_SendAdd);
$(document).on("keydown", "#dx-add-tag", function(e) { if (e.key === "Enter") DXD_SendAdd(); });

function DXD_Act(act, uid) {
    var map = {
        accept: ["DiscordExt_RespondFriend", { uid: uid, accept: true }], decline: ["DiscordExt_RespondFriend", { uid: uid, accept: false }],
        cancel: ["DiscordExt_RemoveFriend", { uid: uid }], remove: ["DiscordExt_RemoveFriend", { uid: uid }],
        block: ["DiscordExt_BlockUser", { uid: uid }], unblock: ["DiscordExt_UnblockUser", { uid: uid }],
    };
    if (!map[act]) return;
    DX_Post(map[act][0], map[act][1], function(ok) {
        if (!ok) DX_Toast("That didn't work.", "error");
        if (act === "remove" || act === "block") { if (DXD.mode === "dm" && DXD.dmUser && DXD.dmUser.uid === uid) { DXD.dmCanSend = false; DXD_ApplyDmComposer(); } }
        DXD_LoadSocial();
    });
}
$(document).on("click", ".dx-fbtn", function(e) {
    e.stopPropagation();
    var row = $(this).closest(".dx-frow"), uid = parseInt(row.attr("data-uid"), 10), act = $(this).attr("data-act");
    if (act === "message") { DXD_OpenDmByUid(uid); return; }
    if (act === "more") { var r = this.getBoundingClientRect(); DXD_UserMenu(uid, r.left - 150, r.bottom); return; }
    DXD_Act(act, uid);
});
$(document).on("click", ".dx-frow", function() {
    var uid = parseInt($(this).attr("data-uid"), 10);
    if (DXD_RelationOf(uid) === "friend") DXD_OpenDmByUid(uid);
});

function DXD_UserMenu(uid, x, y) {
    var rel = DXD_RelationOf(uid), items = [];
    if (rel === "friend") {
        items.push({ label: "Message", icon: "fa-comment", fn: function() { DXD_OpenDmByUid(uid); } });
        items.push({ sep: true });
        items.push({ label: "Remove Friend", icon: "fa-user-minus", danger: true, fn: function() { DXD_Act("remove", uid); } });
    }
    if (rel !== "blocked") items.push({ label: "Block", icon: "fa-ban", danger: true, fn: function() { DXD_Act("block", uid); } });
    else items.push({ label: "Unblock", icon: "fa-user-slash", fn: function() { DXD_Act("unblock", uid); } });
    DX2_Ctx(x, y, items);
}
DX2_BindContext(".dx-frow, .dx-dm-row", function(el, x, y) { DXD_UserMenu(parseInt(el.attr("data-uid"), 10), x, y); });

// ---------------------------------------------------------------------------
// Direct message chat
// ---------------------------------------------------------------------------

function DXD_DmActionsHTML(msg) {
    var html = '<div class="discord-message-actions">';
    html += '<i class="fas fa-copy" data-dmaction="copy" title="Copy text"></i>';
    if (msg.isMine) html += '<i class="fas fa-pen" data-dmaction="edit" title="Edit"></i><i class="fas fa-trash discord-action-danger" data-dmaction="delete" title="Delete"></i>';
    return html + "</div>";
}
window.DXD_DmActionsHTML = DXD_DmActionsHTML;

function DXD_OpenDmByUid(uid) {
    DX_Post("DiscordExt_OpenDM", { uid: uid }, function(r) {
        if (!r || !r.dmId) { DX_Toast(r && r.error === "NOT_FRIENDS" ? "You can only message friends." : (r && r.error === "DMS_CLOSED" ? "This person is not accepting direct messages from server members." : (r && r.error === "TOO_MANY_REQUESTS" ? "You have too many pending message requests." : "Could not open that conversation.")), "warn"); return; }
        DXD_OpenDm(r.dmId, r.user);
    });
}

function DXD_OpenDm(dmId, user) {
    if (DXD.mode === "server") DXD.prevServer = Discord.currentServerId;
    Discord.currentServerId = null;
    Discord.currentChannelId = null;
    DXD.dmId = dmId; DXD.dmUser = user; DXD.dmMsgs = {};
    DXD_SetMode("dm");
    $("#discord-empty-state, #discord-channel-empty").removeClass("discord-visible");
    Discord_ShowChatColumnState("active");
    $("#discord-chat-messages").empty();
    DXD.dmState = { lastDay: null, lastTs: 0, lastAuthor: null };
    DXD_RenderDmHeader();
    DXD_RenderDmList();

    DX_Post("DiscordExt_GetDMMessages", { dmId: dmId }, function(r) {
        if (!r || DXD.dmId !== dmId) return;
        if (r.user) { DXD.dmUser = r.user; DXD_RenderDmHeader(); }
        DXD.dmCanSend = r.canSend !== false;
        DXD_ApplyDmComposer();
        var box = $("#discord-chat-messages");
        DXD.dmOldest = r.messages.length ? r.messages[0].id : null;
        DXD.dmHasMore = !!r.hasMore;
        box.empty();
        if (DXD.dmHasMore) box.append('<div class="dx-load-older" id="dx-load-older">Load older messages</div>');
        if (!r.messages.length) DXD_DmIntro(); 
        var dividerDone = false;
        $.each(r.messages, function(i, m) {
            if (!dividerDone && r.lastSeen != null && m.id > r.lastSeen && !m.isMine) {
                box.append('<div class="dx-new-divider"><span>NEW MESSAGES</span></div>');
                DXD.dmState.lastAuthor = null; dividerDone = true;
            }
            DXD_AppendDM(m, box, DXD.dmState);
        });
        box.scrollTop(box[0].scrollHeight);
        var s = DXD.social;
        if (s) { $.each(s.dms || [], function(i, d) { if (d.id === dmId && d.unread) { s.dmUnread = Math.max(0, (s.dmUnread || 0) - d.unread); d.unread = 0; } }); DXD_UpdateBadges(); DXD_RenderDmList(); }
        $("#discord-message-input").focus();
    });
}

function DXD_DmIntro() {
    var u = DXD.dmUser || {};
    $("#discord-chat-messages").append('<div class="dx-intro">' + DXD_AvatarHtml(u, "dx-av-xl") + "<h1>" + DX_Esc(u.name || "") + "</h1><p>This is the beginning of your direct message history with <b>" + DX_Esc(u.name || "") + "</b>.</p></div>");
}

function DXD_RenderDmHeader() {
    var u = DXD.dmUser || {};
    $(".discord-chat-hash").html('<i class="fas fa-at"></i>').addClass("dx-dm-at");
    $("#discord-chat-channel-name").text(u.name || "");
    $(".dx-dm-status").remove();
    if (u.status) $("#discord-chat-channel-name").after('<span class="dx-dm-status"><span class="discord-member-status-dot ' + (u.status !== "offline" ? "discord-status-" + u.status : "") + '"></span> ' + DX_Esc(({ online: "Online", idle: "Idle", dnd: "Do Not Disturb", offline: "Offline" })[u.status] || "") + "</span>");
    DXD_ApplyDmComposer();
}

function DXD_ApplyDmComposer() {
    if (DXD.mode !== "dm") return;
    var u = DXD.dmUser || {}, ok = DXD.dmCanSend;
    $(".discord-chat-input-row").toggleClass("discord-composer-locked", !ok);
    $("#discord-message-input").prop("disabled", !ok).attr("placeholder", ok ? "Message @" + (u.name || "") : "You can no longer message this person.");
}

function DXD_AppendDM(m, container, st) {
    var day = DXS_DayKey(m.created_at), newDay = st.lastDay !== day;
    if (newDay) container.append('<div class="dx-day-divider"><span>' + DXS_DayLabel(m.created_at) + "</span></div>");
    var u = m.isMine ? { avatar: DXD.me.avatar } : (DXD.dmUser || {});
    var msg = {
        id: m.id, author_name: m.author_name, message: m.message, created_at: m.created_at, edited_at: m.edited_at, isMine: m.isMine,
        _dm: true, _avatarUrl: u.avatar || null, reactions: [], authorVerified: false,
        _grouped: !newDay && st.lastAuthor === m.author_name && (m.created_at - st.lastTs) <= 420,
    };
    DXD.dmMsgs[m.id] = msg;
    container.append(Discord_RenderMessageInnerHTML(msg));
    st.lastDay = day; st.lastTs = m.created_at; st.lastAuthor = m.author_name;
}

function DXD_SendDM() {
    var input = $("#discord-message-input"), text = (input.val() || "").trim();
    if (!text || !DXD.dmId) return;
    var dmId = DXD.dmId;
    input.val("").trigger("input");
    DX_Post("DiscordExt_SendDM", { dmId: dmId, text: text }, function(r) {
        if (!r || !r.ok) {
            input.val(text);
            var map = { COOLDOWN: "You're sending messages too fast.", AUTOMOD: "Your message was blocked by auto-mod.", NOT_FRIENDS: "You can only message friends." };
            DX_Toast(map[r && r.error] || "Message not sent.", "warn");
            if (r && r.error === "NOT_FRIENDS") { DXD.dmCanSend = false; DXD_ApplyDmComposer(); }
            return;
        }
        if (DXD.dmId !== dmId) return;
        $("#discord-chat-messages .dx-intro").remove();
        DXD_AppendDM({ id: r.id, author_name: Discord.myName, message: r.message, created_at: r.created_at, isMine: true }, $("#discord-chat-messages"), DXD.dmState);
        var el = document.getElementById("discord-chat-messages"); el.scrollTop = el.scrollHeight;
        DXD_LoadSocialSoon();
    });
}

$(document).on("click", "#dx-load-older", function() {
    var dmId = DXD.dmId, before = DXD.dmOldest;
    if (!before) return;
    DX_Post("DiscordExt_GetDMMessages", { dmId: dmId, beforeId: before }, function(r) {
        if (!r || DXD.dmId !== dmId) return;
        var box = $("#discord-chat-messages"), el = box[0], prevH = el.scrollHeight;
        var tmp = $("<div></div>"), st = { lastDay: null, lastTs: 0, lastAuthor: null };
        $.each(r.messages, function(i, m) { DXD_AppendDM(m, tmp, st); });
        if (r.messages.length) DXD.dmOldest = r.messages[0].id;
        DXD.dmHasMore = !!r.hasMore;
        if (!DXD.dmHasMore) $("#dx-load-older").remove();
        $("#dx-load-older").after(tmp.children());
        el.scrollTop = el.scrollHeight - prevH;
    });
});

// toolbar actions (edit / delete / copy)
$(document).on("click", "[data-dmaction]", function(e) {
    e.stopPropagation();
    var el = $(this), act = el.attr("data-dmaction"), row = el.closest(".discord-message");
    var id = parseInt(row.attr("data-messageid"), 10), msg = DXD.dmMsgs[id];
    if (!msg) return;
    if (act === "copy") { DX2_CopyText(msg.message); DX_Toast("Copied.", "info"); return; }
    if (act === "edit") {
        DX2_Prompt({ title: "Edit message", label: "", value: msg.message, max: 500, cb: function(text) {
            if (!text || text === msg.message) return;
            DX_Post("DiscordExt_EditDM", { messageId: id, text: text }, function(r) {
                if (!r || !r.ok) { DX_Toast("Could not edit that message.", "error"); return; }
                msg.message = r.message; msg.edited_at = r.edited_at; DXD_RerenderDm(id);
            });
        } });
        return;
    }
    if (act === "delete") {
        if (!el.data("sure")) { el.data("sure", true).css("color", "#f23f43").attr("title", "Click again to delete"); setTimeout(function() { el.data("sure", false).css("color", ""); }, 2500); return; }
        DX_Post("DiscordExt_DeleteDM", { messageId: id }, function(ok) { if (ok) DXD_RemoveDm(id); else DX_Toast("Could not delete that message.", "error"); });
    }
});
function DXD_RerenderDm(id) {
    var msg = DXD.dmMsgs[id], row = $('#discord-chat-messages .discord-message[data-messageid="' + id + '"]');
    if (msg && row.length) row.replaceWith(Discord_RenderMessageInnerHTML(msg));
}
function DXD_RemoveDm(id) {
    $('#discord-chat-messages .discord-message[data-messageid="' + id + '"]').remove();
    delete DXD.dmMsgs[id];
    DXD_LoadSocialSoon();
}

// ---------------------------------------------------------------------------
// Live events
// ---------------------------------------------------------------------------

window.addEventListener("message", function(event) {
    var d = event.data;
    if (!d || !d.action) return;
    var p = d.data || {};
    switch (d.action) {
        case "DiscordExtSocial":
            DXD_LoadSocialSoon();
            break;
        case "DiscordExtDMNew":
            if (DXD.mode === "dm" && DXD.dmId === p.dmId && $("#discord-backdrop").hasClass("discord-visible")) {
                var box = $("#discord-chat-messages"), el = box[0], atBottom = el.scrollHeight - el.scrollTop - el.clientHeight < 80;
                box.find(".dx-intro").remove();
                DXD_AppendDM(p.message, box, DXD.dmState);
                if (atBottom) el.scrollTop = el.scrollHeight;
                DX_Post("DiscordExt_MarkDMSeen", { dmId: p.dmId });
                DXD_LoadSocialSoon();
            } else {
                var s = DXD.social, found = false;
                if (s) {
                    $.each(s.dms || [], function(i, dm) { if (dm.id === p.dmId) { dm.unread = (dm.unread || 0) + 1; dm.lastMessage = p.message.message; dm.lastMine = false; found = true; } });
                    s.dmUnread = (s.dmUnread || 0) + 1;
                }
                DXD_UpdateBadges();
                DXD_RenderDmList();
                if (!found) DXD_LoadSocialSoon();
                DX_Toast((p.from && p.from.name ? p.from.name : "New message") + ": " + DXD_Snippet(p.message.message), "info");
                if (window.Discord_PlayNotificationSound) Discord_PlayNotificationSound();
            }
            break;
        case "DiscordExtDMEdited":
            if (DXD.mode === "dm" && DXD.dmId === p.dmId && DXD.dmMsgs[p.messageId]) { DXD.dmMsgs[p.messageId].message = p.message; DXD.dmMsgs[p.messageId].edited_at = p.edited_at; DXD_RerenderDm(p.messageId); }
            else DXD_LoadSocialSoon();
            break;
        case "DiscordExtDMDeleted":
            if (DXD.mode === "dm" && DXD.dmId === p.dmId) DXD_RemoveDm(p.messageId); else DXD_LoadSocialSoon();
            break;
        case "DiscordExtServerExtrasUpdated":
            if (p.serverId != null && DXD.mode === "server") setTimeout(DXD_DecorateRailIcons, 400);
            break;
    }
});

// ---------------------------------------------------------------------------
// Profile card: avatar + Message / Add Friend
// ---------------------------------------------------------------------------

DX_After("Discord_OpenMemberProfile", function(memberId) {
    var tries = 0;
    var t = setInterval(function() {
        tries++;
        var card = $("#discord-modal-profile-view");
        if ((card.length && card.hasClass("discord-modal-active") && card.find("#discord-pv-name").text().trim() !== "") || tries > 15) {
            clearInterval(t);
            var m = DXD_MetaOf(memberId) || {};
            DXD_SetBg(document.getElementById("discord-pv-avatar"), m.avatar);
            card.find(".dx-social-actions").remove();
            var uid = m.uid;
            if (!uid || uid === DXD.me.uid) return;
            var rel = DXD_RelationOf(uid), html = "";
            if (rel === "friend") html = '<div class="dx-btn dx-primary" data-pact="message">Send Message</div>';
            else if (rel === "incoming") html = '<div class="dx-btn dx-primary" data-pact="accept">Accept Friend Request</div>';
            else if (rel === "outgoing") html = '<div class="dx-btn dx-disabled">Friend Request Sent</div>';
            else if (rel === "blocked") html = '<div class="dx-btn" data-pact="unblock">Unblock</div>';
            else html = '<div class="dx-btn dx-primary" data-pact="add">Add Friend</div>';
            if (rel !== "blocked") html += '<div class="dx-btn dx-danger" data-pact="block" title="Block">Block</div>';
            var box = $('<div class="dx-social-actions" data-uid="' + uid + '">' + html + "</div>");
            card.find(".discord-profile-body").prepend(box);
        }
    }, 80);
});
$(document).on("click", "[data-pact]", function() {
    var act = $(this).attr("data-pact"), uid = parseInt($(this).closest(".dx-social-actions").attr("data-uid"), 10);
    if (act === "message") { Discord_CloseModals(); DXD_OpenDmByUid(uid); return; }
    if (act === "add") {
        var btn = $(this);
        DX_Post("DiscordExt_AddFriendByUid", { uid: uid }, function(r) {
            if (r && r.ok) { btn.replaceWith('<div class="dx-btn dx-disabled">' + (r.status === "accepted" ? "Friends" : "Friend Request Sent") + "</div>"); DXD_LoadSocial(); }
            else DX_Toast(DXD_ADD_ERR[r && r.error] || "Could not send the request.", "warn");
        });
        return;
    }
    if (act === "block" && !$(this).data("sure")) { $(this).data("sure", true).text("Click again to block"); return; }
    DXD_Act(act, uid);
    Discord_CloseModals();
});

// own profile (footer click) shows the avatar too
DX_After("Discord_RenderProfileView", function(p) {
    if (p && p.isSelf) DXD_SetBg(document.getElementById("discord-pv-avatar"), DXD.me.avatar);
});

// ---------------------------------------------------------------------------
// Boot
// ---------------------------------------------------------------------------

DX_After("Discord_Init", function() { DXD_LoadMe(); DXD_LoadSocial(); });
DX_After("Discord_Close", function() { DX2_HideCtx && DX2_HideCtx(); });
$(function() { setTimeout(function() { DXD_BuildUI(); }, 0); });
