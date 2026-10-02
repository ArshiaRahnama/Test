// ============================================================================
// Discord v7 — front-end extension. Loaded AFTER js/discord.js. It does not
// replace anything: it wraps a few of discord.js's global functions (so its
// own calls pick the wrappers up), builds its extra modals at runtime, and
// talks to client/discord_ext.lua through the "DiscordExt_*" NUI callbacks.
//
// Features here: per-server theme + boost look, boost/VIP/emoji/auto-mod
// "Server Tools", timeout + warn popup, leaderboard + level/badge decoration,
// message search, report button + staff Reports tab, numeric unread badges
// (rail, channels, phone icon), toasts, share-from-gallery sheet.
// ============================================================================

var DX = {
    info: {},          // serverId -> server info from the server (theme, boosts, perms ...)
    meta: {},          // serverId -> { memberRowId: { level, badges[] } }
    defs: {},          // badge key -> { icon, label }
    unread: {},        // channelId -> { serverId, count }
    infoFetching: {},
    seenTimer: null,
    unreportTimer: null,
    searchTimer: null,
    searchWholeServer: false,
    modTargetId: null,
    reportMessageId: null,
    themePalette: ["#5865F2", "#EB459E", "#ED4245", "#FAA61A", "#57F287", "#3BA55D", "#00AFF4", "#9B59B6", "#E67E22", "#1ABC9C"],
};

function DX_Esc(s) { return Discord_Escape(s == null ? "" : String(s)); }
function DX_Post(endpoint, data, cb) { Discord_Post(endpoint, data || {}, cb || function() {}); }
function DX_Money(n) { return "$" + Number(n || 0).toLocaleString(); }
function DX_CurrentInfo() { return DX.info[Discord.currentServerId] || null; }

function DX_Toast(text, kind) {
    if (!text) return;
    var box = $("#dx-toasts");
    if (!box.length) box = $('<div id="dx-toasts"></div>').appendTo("body");
    var el = $('<div class="dx-toast' + (kind ? " dx-" + kind : "") + '"></div>').text(text).appendTo(box);
    setTimeout(function() { el.fadeOut(250, function() { el.remove(); }); }, 4800);
}

function DX_TimeLabel(unixSeconds) {
    return new Date(unixSeconds * 1000).toLocaleString([], { hour: "2-digit", minute: "2-digit", day: "numeric", month: "short" });
}

function DX_ErrorText(result) {
    if (!result) return "Something went wrong.";
    if (result.error === "TIMEOUT") return "You are timed out until " + DX_TimeLabel(result.untilAt) + ".";
    if (result.error === "AUTOMOD") return "Your message was blocked by this server's auto-mod.";
    if (result.error === "LOCKED") return "This channel is locked.";
    if (result.error === "NO_ACCOUNT") return "Open Discord and sign in first.";
    if (result.error === "BAD_URL") return "That image link can't be shared.";
    return "Could not send that.";
}

// ---------------------------------------------------------------------------
// Function wrapping (discord.js calls these by global name, so wrappers apply)
// ---------------------------------------------------------------------------

function DX_After(name, fn) {
    var orig = window[name];
    if (typeof orig !== "function") return;
    window[name] = function() {
        var result = orig.apply(this, arguments);
        try { fn.apply(this, arguments); } catch (e) { if (window.console) console.error("[discord_ext] " + name, e); }
        return result;
    };
}
function DX_Before(name, fn) {
    var orig = window[name];
    if (typeof orig !== "function") return;
    window[name] = function() {
        try { fn.apply(this, arguments); } catch (e) { if (window.console) console.error("[discord_ext] " + name, e); }
        return orig.apply(this, arguments);
    };
}

DX_After("Discord_SelectServer", function(serverId) { DX_OnSelectServer(serverId); });
DX_After("Discord_RenderServerRail", function() { DX_DecorateRail(); DX_PrefetchInfos(); });
DX_After("Discord_RenderChannelList", function() { DX_ApplyUnreadUI(); });
DX_After("Discord_OpenChannel", function(channelId) { DX_MarkChannelSeen(channelId); });
DX_Before("Discord_HandleIncomingMessage", function(payload) { DX_OnIncoming(payload); });
DX_After("Discord_OpenServerMenu", function() { DX_AugmentServerMenu(); });
DX_After("Discord_OpenEmojiPicker", function(mode) { DX_AppendCustomEmojis(mode); });
DX_After("Discord_OpenStaffPanel", function() { DX_RefreshReportBadge(); });
DX_After("Discord_Init", function() { DX_RefreshUnread(); });
DX_After("Discord_StaffSwitchTab", function(tab) { if (tab === "reports") DX_LoadReports(); });

// Rich presence: show member.activity ("On duty · Police — Driving") under the name
(function() {
    var orig = window.Discord_RenderMemberGroup;
    if (typeof orig !== "function") return;
    window.Discord_RenderMemberGroup = function(label, members) {
        var html = orig(label, members);
        var withActivity = (members || []).filter(function(m) { return m.activity; });
        if (!withActivity.length) return html;
        var wrap = $("<div>").html(html);
        $.each(withActivity, function(i, m) {
            wrap.find('.discord-member-item[data-memberrowid="' + m.id + '"] .discord-member-text')
                .append('<span class="discord-member-activity">' + DX_Esc(m.activity) + "</span>");
        });
        return wrap.html();
    };
})();

// "Report" flag on other people's messages
(function() {
    var orig = window.Discord_RenderMessageActionsHTML;
    if (typeof orig !== "function") return;
    window.Discord_RenderMessageActionsHTML = function(msg) {
        var html = orig(msg);
        if (!msg.isMine && !msg.isAnnouncement) {
            html = html.replace(/<\/div>\s*$/, '<i class="fas fa-flag discord-action-danger" data-action="report" title="Report to staff"></i></div>');
        }
        return html;
    };
})();

// ---------------------------------------------------------------------------
// Server info, theme, boost look
// ---------------------------------------------------------------------------

function DX_LoadInfo(serverId, cb) {
    DX_Post("DiscordExt_GetServerInfo", { serverId: serverId }, function(info) {
        if (info && info.serverId != null) DX.info[serverId] = info;
        if (cb) cb(info || null);
    });
}

function DX_PrefetchInfos() {
    var queue = [];
    $.each(Discord.servers || [], function(i, s) { if (!DX.info[s.id] && !DX.infoFetching[s.id]) queue.push(s.id); });
    if (!queue.length) return;
    (function next() {
        var id = queue.shift();
        if (id == null) { DX_DecorateRail(); return; }
        DX.infoFetching[id] = true;
        DX_LoadInfo(id, function() { DX.infoFetching[id] = false; setTimeout(next, 120); });
    })();
}

function DX_HexToRgb(hex) {
    var m = /^#?([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})$/i.exec(hex || "");
    return m ? [parseInt(m[1], 16), parseInt(m[2], 16), parseInt(m[3], 16)] : null;
}

function DX_ApplyTheme(color) {
    var el = document.getElementById("discord-backdrop");
    var rgb = DX_HexToRgb(color);
    if (!rgb) {
        $("#discord-backdrop").removeClass("dx-themed");
        el.style.removeProperty("--dx-accent");
        el.style.removeProperty("--dx-accent-soft");
        el.style.removeProperty("--dx-accent-light");
        return;
    }
    var light = [0, 1, 2].map(function(i) { return Math.round(rgb[i] + (255 - rgb[i]) * 0.4); });
    el.style.setProperty("--dx-accent", color);
    el.style.setProperty("--dx-accent-soft", "rgba(" + rgb.join(",") + ",.22)");
    el.style.setProperty("--dx-accent-light", "rgb(" + light.join(",") + ")");
    $("#discord-backdrop").addClass("dx-themed");
}

function DX_ApplyServerLook(info) {
    if (!info || info.serverId !== Discord.currentServerId) return;
    DX_ApplyTheme(info.theme);
    $("#discord-backdrop").removeClass("dx-boost-1 dx-boost-2 dx-boost-3");
    if (info.boostLevel > 0) $("#discord-backdrop").addClass("dx-boost-" + info.boostLevel);
    $(".dx-gem").remove();
    if (info.boostLevel > 0) $("#discord-current-server-name").after('<i class="fas fa-gem dx-gem" title="Boosted server"></i>');
    DX_DecorateRail();
}

function DX_OnSelectServer(serverId) {
    $("#dx-search-panel").removeClass("dx-open");
    DX_LoadInfo(serverId, function(info) { DX_ApplyServerLook(info); });
    DX_LoadMeta(serverId);
}

function DX_DecorateRail() {
    $(".discord-rail-icon[data-serverid]").each(function() {
        var icon = $(this);
        var id = parseInt(icon.attr("data-serverid"), 10);
        var info = DX.info[id];
        icon.removeClass("dx-rail-boost-1 dx-rail-boost-2 dx-rail-boost-3");
        icon.find(".dx-rail-vip").remove();
        if (info) {
            if (info.boostLevel > 0) icon.addClass("dx-rail-boost-" + info.boostLevel);
            if (info.isFeatured) icon.append('<span class="dx-rail-vip" title="VIP server"><i class="fas fa-star" style="font-size:9px"></i></span>');
        }
        if (!icon.find(".dx-rail-badge").length) icon.append('<div class="dx-rail-badge" data-badgefor="' + id + '"></div>');
    });
    DX_ApplyUnreadUI();
}

// ---------------------------------------------------------------------------
// Unread counters (rail, channels, phone icon)
// ---------------------------------------------------------------------------

function DX_RefreshUnread() {
    DX_Post("DiscordExt_GetUnread", {}, function(rows) { DX_SetUnreadFromServer(rows); });
}

function DX_SetUnreadFromServer(rows) {
    DX.unread = {};
    $.each(rows || [], function(i, r) { if (r.cnt > 0) DX.unread[r.channelId] = { serverId: r.serverId, count: r.cnt }; });
    DX_ApplyUnreadUI();
}

function DX_ServerUnread(serverId) {
    var n = 0;
    $.each(DX.unread, function(cid, u) { if (u.serverId === serverId) n += u.count; });
    return n;
}

function DX_ApplyUnreadUI() {
    var total = 0;
    $.each(DX.unread, function(cid, u) { total += u.count; });

    $(".dx-rail-badge").each(function() {
        var n = DX_ServerUnread(parseInt($(this).attr("data-badgefor"), 10));
        $(this).text(n > 99 ? "99+" : n).toggleClass("dx-visible", n > 0);
    });

    $(".discord-channel-item[data-channelid]").each(function() {
        var item = $(this);
        var u = DX.unread[parseInt(item.attr("data-channelid"), 10)];
        item.find(".dx-channel-badge").remove();
        item.toggleClass("dx-unread", !!u);
        if (u) item.append('<span class="dx-channel-badge">' + (u.count > 99 ? "99+" : u.count) + "</span>");
    });

    // The number on the Discord icon of the phone's home screen
    clearTimeout(DX.unreportTimer);
    DX.unreportTimer = setTimeout(function() { DX_Post("DiscordExt_SetUnread", { count: total }); }, 300);
}

function DX_OnIncoming(payload) {
    if (!payload || payload.channelId == null) return;
    var viewing = $("#discord-backdrop").hasClass("discord-visible") && Discord.currentChannelId === payload.channelId;
    if (viewing) {
        clearTimeout(DX.seenTimer);
        DX.seenTimer = setTimeout(function() { DX_Post("DiscordExt_MarkSeen", { channelId: payload.channelId }); }, 1500);
        return;
    }
    var u = DX.unread[payload.channelId] || { serverId: payload.serverId, count: 0 };
    u.count++;
    DX.unread[payload.channelId] = u;
    DX_ApplyUnreadUI();
}

function DX_MarkChannelSeen(channelId) {
    if (DX.unread[channelId]) { delete DX.unread[channelId]; DX_ApplyUnreadUI(); }
    DX_Post("DiscordExt_MarkSeen", { channelId: channelId });
}

// ---------------------------------------------------------------------------
// Levels + badges decoration (messages and member list)
// ---------------------------------------------------------------------------

function DX_LoadMeta(serverId) {
    DX_Post("DiscordExt_GetMemberMeta", { serverId: serverId }, function(res) {
        if (!res || !res.meta) return;
        DX.meta[serverId] = res.meta;
        DX.defs = res.defs || DX.defs;
        $("[data-dx]").removeAttr("data-dx").find(".dx-badges, .dx-level").remove();
        DX_DecorateAll();
    });
}

function DX_BadgesHtml(m) {
    var icons = "";
    $.each(m.badges || [], function(i, key) {
        var d = DX.defs[key];
        if (d) icons += '<span class="dx-badge" title="' + DX_Esc(d.label) + '">' + d.icon + "</span>";
    });
    var out = icons ? '<span class="dx-badges">' + icons + "</span>" : "";
    if (m.level > 0) out += '<span class="dx-level" title="Server level">Lv ' + m.level + "</span>";
    return out;
}

function DX_DecorateAll() {
    var meta = DX.meta[Discord.currentServerId];
    if (!meta) return;
    var info = DX_CurrentInfo();

    $("#discord-chat-messages .discord-message-author[data-authorid]").each(function() {
        var el = $(this);
        if (el.attr("data-dx")) return;
        var m = meta[el.attr("data-authorid")];
        if (!m) return;
        el.attr("data-dx", "1");
        var html = DX_BadgesHtml(m);
        if (html) el.after(html);
    });

    $("#discord-members-list .discord-member-item").each(function() {
        var item = $(this);
        if (item.attr("data-dx")) return;
        var m = meta[item.attr("data-memberrowid")];
        item.attr("data-dx", "1");
        if (m) {
            var html = DX_BadgesHtml(m);
            if (html) item.find(".discord-member-name").first().append(html);
        }
        if (info && info.canModerate && !item.find(".discord-member-crown").length) {
            item.append('<i class="fas fa-gavel dx-mod-btn" title="Moderate"></i>');
        }
    });
}

(function() {
    var pending = false;
    function schedule() {
        if (pending) return;
        pending = true;
        requestAnimationFrame(function() { pending = false; DX_DecorateAll(); });
    }
    var obs = new MutationObserver(schedule);
    $(function() {
        var a = document.getElementById("discord-chat-messages");
        var b = document.getElementById("discord-members-list");
        if (a) obs.observe(a, { childList: true, subtree: true });
        if (b) obs.observe(b, { childList: true, subtree: true });
    });
})();

// ---------------------------------------------------------------------------
// Server menu additions + custom emoji in the reaction picker
// ---------------------------------------------------------------------------

function DX_AugmentServerMenu() {
    var btns = $("#discord-modal-server-menu .discord-modal-buttons");
    if (!$("#dx-open-tools-btn").length) {
        btns.prepend('<div class="discord-modal-btn discord-modal-confirm" id="dx-open-lb-btn">Leaderboard</div>');
        btns.prepend('<div class="discord-modal-btn discord-modal-confirm" id="dx-open-tools-btn">Boost &amp; Server Tools</div>');
    }
    var info = DX_CurrentInfo();
    if (info && info.kind) {
        $("#discord-leave-server-btn, #discord-delete-server-btn").hide();
    }
}

function DX_AppendCustomEmojis(mode) {
    if (mode !== "react") return;
    var info = DX_CurrentInfo();
    if (!info || !info.customEmojis || !info.customEmojis.length) return;
    var html = "";
    $.each(info.customEmojis, function(i, e) { html += '<div class="discord-emoji-picker-item" data-emoji="' + e + '">' + e + "</div>"; });
    $("#discord-emoji-picker").append(html);
}

// ---------------------------------------------------------------------------
// Modals built at runtime (they reuse .discord-modal so Discord_OpenModal works)
// ---------------------------------------------------------------------------

function DX_BuildUI() {
    var overlay = $("#discord-modal-overlay");

    overlay.append(
        '<div class="discord-modal dx-modal-wide" id="dx-modal-tools">' +
            '<div class="discord-modal-title" id="dx-tools-title">Server Tools</div>' +
            '<div id="dx-tools-body"></div>' +
            '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Close</div></div>' +
        "</div>" +
        '<div class="discord-modal dx-modal-wide" id="dx-modal-mod">' +
            '<div class="discord-modal-title" id="dx-mod-title">Moderate</div>' +
            '<div id="dx-mod-body"></div>' +
            '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Close</div></div>' +
        "</div>" +
        '<div class="discord-modal dx-modal-wide" id="dx-modal-lb">' +
            '<div class="discord-modal-title">Leaderboard</div>' +
            '<div id="dx-lb-body"></div>' +
            '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Close</div></div>' +
        "</div>" +
        '<div class="discord-modal" id="dx-modal-report">' +
            '<div class="discord-modal-title">Report message</div>' +
            '<div class="dx-muted" style="margin-bottom:8px">Game staff will review this message.</div>' +
            '<input type="text" id="dx-report-reason" placeholder="Reason (optional)" maxlength="150" spellcheck="false" dir="auto">' +
            '<div class="discord-modal-buttons">' +
                '<div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Cancel</div>' +
                '<div class="discord-modal-btn discord-modal-danger" id="dx-report-send">Report</div>' +
            "</div>" +
        "</div>"
    );

    // chat header: search / leaderboard / tools
    $(".discord-chat-header-actions").prepend(
        '<i class="fas fa-search dx-header-btn" id="dx-search-btn" title="Search messages"></i>' +
        '<i class="fas fa-trophy dx-header-btn" id="dx-lb-btn" title="Leaderboard"></i>' +
        '<i class="fas fa-gem dx-header-btn" id="dx-tools-btn" title="Boost &amp; Server Tools"></i>'
    );

    $(".discord-chat-column").append(
        '<div class="dx-search-panel" id="dx-search-panel">' +
            '<div class="dx-search-top">' +
                '<i class="fas fa-search dx-muted"></i>' +
                '<input type="text" id="dx-search-input" placeholder="Search messages" maxlength="40" spellcheck="false" dir="auto">' +
                '<span class="dx-search-scope" id="dx-search-scope">This channel</span>' +
            "</div>" +
            '<div class="dx-search-results" id="dx-search-results"><div class="dx-empty">Type at least 2 characters.</div></div>' +
        "</div>"
    );

    // staff panel: Reports tab
    $("#discord-staff-tabs").append('<div class="discord-staff-tab" data-stafftab="reports">Reports<span class="dx-tab-badge" id="dx-report-badge" style="display:none">0</span></div>');
    $("#discord-staffpane-audit").after('<div class="discord-staff-pane" id="discord-staffpane-reports"></div>');
}

// ---------------------------------------------------------------------------
// Server Tools modal (boost, theme, emoji slots, auto-mod, VIP)
// ---------------------------------------------------------------------------

function DX_OpenTools() {
    var serverId = Discord.currentServerId;
    if (serverId == null) return;
    Discord_OpenModal("dx-modal-tools");
    $("#dx-tools-body").html('<div class="dx-empty">Loading...</div>');
    DX_LoadInfo(serverId, function(info) {
        if (!info) { $("#dx-tools-body").html('<div class="dx-empty">Could not load.</div>'); return; }
        DX_ApplyServerLook(info);
        DX_RenderTools(info);
    });
}

function DX_RenderTools(info) {
    var server = Discord_FindServer(info.serverId);
    $("#dx-tools-title").text((server ? server.name : "Server") + " — Tools");
    var html = "";

    // --- Boost
    var nextLevel = info.levels[info.boostLevel] || null; // levels[i] = perks of level i+1
    var pct = nextLevel ? Math.min(100, Math.round(info.boostCount / nextLevel.boosts * 100)) : 100;
    html += '<div class="dx-section"><h4>Server Boost</h4>' +
            '<div class="dx-row dx-spread"><b>' + info.boostCount + " boost" + (info.boostCount === 1 ? "" : "s") +
            "</b><span>" + (info.boostLevel > 0 ? info.levels[info.boostLevel - 1].name : "No level yet") + "</span></div>" +
            '<div class="dx-progress"><div style="width:' + pct + '%"></div></div>' +
            '<div class="dx-muted">' + (nextLevel ? (nextLevel.boosts - info.boostCount) + " more boost(s) for " + DX_Esc(nextLevel.name) : "Max level reached") + "</div>" +
            '<ul class="dx-perk-list">';
    $.each(info.levels, function(i, L) {
        html += '<li class="' + (info.boostLevel >= i + 1 ? "dx-unlocked" : "") + '">' + DX_Esc(L.name) + " — " + L.boosts + " boosts: " + L.emojiSlots + " custom emoji slots" +
                (i === 0 ? ", pink server ring" : i === 1 ? ", gradient header" : ", gold ring + shimmer header") + "</li>";
    });
    html += "</ul>" +
            '<div class="dx-row" style="margin-top:10px"><div class="dx-btn dx-boost' + (info.myBoosts >= info.maxBoosts ? " dx-disabled" : "") + '" id="dx-boost-btn" data-price="' + info.boostPrice + '">' +
            "Boost this server — " + DX_Money(info.boostPrice) + " / " + info.boostDays + " days</div>" +
            '<span class="dx-muted">Your boosts here: ' + info.myBoosts + "/" + info.maxBoosts + "</span></div></div>";

    // --- Theme
    if (info.canConfigure) {
        html += '<div class="dx-section"><h4>Server colour</h4><div class="dx-swatches">';
        $.each(DX.themePalette, function(i, c) {
            html += '<div class="dx-swatch' + (info.theme && info.theme.toLowerCase() === c.toLowerCase() ? " dx-selected" : "") + '" data-theme="' + c + '" style="background:' + c + '"></div>';
        });
        html += '<input type="color" id="dx-theme-custom" value="' + (info.theme || "#5865F2") + '" title="Custom colour" style="width:30px;height:26px;border:none;background:none;padding:0;cursor:pointer">' +
                '<div class="dx-swatch dx-swatch-clear" data-theme="" title="Reset">&times;</div></div>' +
                '<div class="dx-muted" style="margin-top:6px">Everyone in this server sees the interface in this colour.</div></div>';
    }

    // --- Custom emoji
    if (info.canConfigure) {
        html += '<div class="dx-section"><h4>Custom reaction emoji (' + info.customEmojis.length + "/" + info.emojiSlots + ")</h4>";
        if (info.emojiSlots === 0) {
            html += '<div class="dx-muted">Unlock emoji slots with Level 1 boosts.</div>';
        } else {
            $.each(info.customEmojis, function(i, e) { html += '<span class="dx-chip">' + e + ' <i class="fas fa-times" data-removeemoji="' + e + '"></i></span>'; });
            if (info.customEmojis.length < info.emojiSlots) {
                html += '<div class="dx-emoji-grid">';
                $.each(info.emojiPool || [], function(i, e) { html += '<span data-addemoji="' + e + '">' + e + "</span>"; });
                html += "</div>";
            }
        }
        html += "</div>";
    }

    // --- Auto-mod
    if (info.canModerate) {
        html += '<div class="dx-section"><h4>Auto-mod — blocked words</h4>' +
                '<div class="dx-row"><input type="text" class="dx-input" id="dx-automod-input" placeholder="Add a word or phrase" maxlength="40" spellcheck="false" dir="auto">' +
                '<div class="dx-btn dx-primary" id="dx-automod-add">Add</div></div>' +
                '<div id="dx-automod-list" style="margin-top:8px"><span class="dx-muted">Loading...</span></div></div>';
    }

    // --- VIP
    if (info.vipPlans) {
        html += '<div class="dx-section"><h4>VIP listing</h4><div class="dx-muted">' +
                (info.isFeatured ? (info.vipUntil ? "VIP until " + DX_TimeLabel(info.vipUntil) : "VIP (set by staff)") : "Not VIP — VIP servers appear in the VIP tab of Discover.") +
                '</div><div class="dx-row" style="margin-top:8px">';
        $.each(info.vipPlans, function(i, p) {
            html += '<div class="dx-btn dx-primary" data-vipplan="' + p.id + '" data-price="' + p.price + '">' + DX_Esc(p.label) + " — " + DX_Money(p.price) + "</div>";
        });
        html += "</div></div>";
    }

    $("#dx-tools-body").html(html);
    if (info.canModerate) DX_LoadAutoMod();
}

function DX_LoadAutoMod() {
    DX_Post("DiscordExt_GetAutoMod", { serverId: Discord.currentServerId }, function(res) {
        var box = $("#dx-automod-list");
        if (!res) { box.html('<span class="dx-muted">Could not load.</span>'); return; }
        if (!res.words.length) { box.html('<span class="dx-muted">No words yet (' + res.max + " max).</span>"); return; }
        var html = "";
        $.each(res.words, function(i, w) { html += '<span class="dx-chip">' + DX_Esc(w) + ' <i class="fas fa-times" data-removeword="' + DX_Esc(w) + '"></i></span>'; });
        box.html(html);
    });
}

function DX_ToolsRefresh() {
    DX_LoadInfo(Discord.currentServerId, function(info) {
        if (info) { DX_ApplyServerLook(info); DX_RenderTools(info); }
    });
}

$(document).on("click", "#dx-tools-btn, #dx-open-tools-btn", function() { DX_OpenTools(); });

$(document).on("click", "#dx-boost-btn", function() {
    var btn = $(this);
    if (btn.hasClass("dx-disabled")) return;
    if (!btn.data("confirm")) {
        btn.data("confirm", true).text("Tap again to pay " + DX_Money(btn.attr("data-price")));
        setTimeout(function() { if (btn.length) DX_ToolsRefresh(); }, 4000);
        return;
    }
    btn.addClass("dx-disabled");
    DX_Post("DiscordExt_Boost", { serverId: Discord.currentServerId }, function(r) {
        if (r && r.ok) { DX_Toast("Thanks for boosting this server!", "success"); }
        else if (r && r.error === "NO_MONEY") { DX_Toast("Not enough money in your bank account.", "error"); }
        else if (r && r.error === "MAX") { DX_Toast("You already used all your boosts on this server.", "warn"); }
        else { DX_Toast("Boost failed.", "error"); }
        DX_ToolsRefresh();
    });
});

$(document).on("click", "[data-theme]", function() {
    var color = $(this).attr("data-theme");
    DX_Post("DiscordExt_SetTheme", { serverId: Discord.currentServerId, color: color }, function(ok) { if (ok) DX_ToolsRefresh(); else DX_Toast("Could not change the colour.", "error"); });
});
$(document).on("change", "#dx-theme-custom", function() {
    var color = $(this).val();
    DX_Post("DiscordExt_SetTheme", { serverId: Discord.currentServerId, color: color }, function(ok) { if (ok) DX_ToolsRefresh(); });
});

$(document).on("click", "[data-addemoji]", function() {
    DX_Post("DiscordExt_AddEmoji", { serverId: Discord.currentServerId, emoji: $(this).attr("data-addemoji") }, function(r) {
        if (r === true) DX_ToolsRefresh(); else DX_Toast(r && r.error === "NO_SLOTS" ? "No free emoji slots." : "Could not add it.", "warn");
    });
});
$(document).on("click", "[data-removeemoji]", function() {
    DX_Post("DiscordExt_RemoveEmoji", { serverId: Discord.currentServerId, emoji: $(this).attr("data-removeemoji") }, function() { DX_ToolsRefresh(); });
});

function DX_AddAutoModWord() {
    var input = $("#dx-automod-input");
    var word = input.val();
    if (!word || word.trim().length < 2) return;
    DX_Post("DiscordExt_AddAutoModWord", { serverId: Discord.currentServerId, word: word }, function(r) {
        if (r === true) { input.val(""); DX_LoadAutoMod(); }
        else DX_Toast(r && r.error === "FULL" ? "The word list is full." : "Could not add that word.", "warn");
    });
}
$(document).on("click", "#dx-automod-add", DX_AddAutoModWord);
$(document).on("keydown", "#dx-automod-input", function(e) { if (e.key === "Enter") DX_AddAutoModWord(); });
$(document).on("click", "[data-removeword]", function() {
    DX_Post("DiscordExt_RemoveAutoModWord", { serverId: Discord.currentServerId, word: $(this).attr("data-removeword") }, function() { DX_LoadAutoMod(); });
});

$(document).on("click", "[data-vipplan]", function() {
    var btn = $(this);
    if (!btn.data("confirm")) {
        btn.data("confirm", true).text("Tap again to pay " + DX_Money(btn.attr("data-price")));
        setTimeout(function() { if (btn.length) DX_ToolsRefresh(); }, 4000);
        return;
    }
    DX_Post("DiscordExt_BuyVIP", { serverId: Discord.currentServerId, planId: btn.attr("data-vipplan") }, function(r) {
        if (r && r.ok) DX_Toast("Your server is now VIP.", "success");
        else DX_Toast(r && r.error === "NO_MONEY" ? "Not enough money in your bank account." : "Could not buy VIP.", "error");
        DX_ToolsRefresh();
    });
});

// ---------------------------------------------------------------------------
// Moderation popup: warn history, warn, timeout
// ---------------------------------------------------------------------------

function DX_MinLabel(m) {
    if (m < 60) return m + " min";
    if (m < 1440) return (m / 60) + " h";
    return (m / 1440) + " d";
}

function DX_OpenMod(memberRowId) {
    DX.modTargetId = memberRowId;
    Discord_OpenModal("dx-modal-mod");
    $("#dx-mod-body").html('<div class="dx-empty">Loading...</div>');
    DX_LoadMod();
}

function DX_LoadMod() {
    DX_Post("DiscordExt_GetMemberMod", { serverId: Discord.currentServerId, memberId: DX.modTargetId }, function(r) {
        if (!r) { $("#dx-mod-body").html('<div class="dx-empty">You can\'t moderate this member.</div>'); return; }
        $("#dx-mod-title").text(r.nickname);
        var html = '<div class="dx-section"><h4>Warnings (' + r.warnCount + ")</h4>";
        if (!r.warns.length) html += '<div class="dx-muted">No warnings.</div>';
        $.each(r.warns, function(i, w) {
            html += '<div class="dx-warn-item">' + (w.reason ? DX_Esc(w.reason) : "<i>No reason</i>") +
                    "<small>" + DX_Esc(w.by_name) + " · " + DX_TimeLabel(w.created_at) + "</small></div>";
        });
        html += '<div class="dx-row" style="margin-top:8px"><input type="text" class="dx-input" id="dx-warn-reason" placeholder="Warn reason" maxlength="120" spellcheck="false" dir="auto">' +
                '<div class="dx-btn dx-danger" id="dx-warn-send">Warn</div>' +
                (r.warnCount > 0 ? '<div class="dx-btn" id="dx-warn-clear">Clear</div>' : "") + "</div></div>";

        html += '<div class="dx-section"><h4>Timeout</h4>' +
                (r.timeoutUntil ? '<div class="dx-muted" style="margin-bottom:6px">Timed out until ' + DX_TimeLabel(r.timeoutUntil) + "</div>" : '<div class="dx-muted" style="margin-bottom:6px">Blocks sending messages in this server only.</div>') +
                '<div class="dx-minutes">';
        $.each(r.minutes || [], function(i, m) { html += '<div class="dx-btn" data-timeout="' + m + '">' + DX_MinLabel(m) + "</div>"; });
        if (r.timeoutUntil) html += '<div class="dx-btn dx-primary" data-timeout="0">Remove timeout</div>';
        html += "</div></div>";
        $("#dx-mod-body").html(html);
    });
}

$(document).on("click", ".dx-mod-btn", function(e) {
    e.stopPropagation();
    DX_OpenMod(parseInt($(this).closest(".discord-member-item").attr("data-memberrowid"), 10));
});
$(document).on("click", "#dx-warn-send", function() {
    DX_Post("DiscordExt_Warn", { serverId: Discord.currentServerId, memberId: DX.modTargetId, reason: $("#dx-warn-reason").val() }, function(r) {
        if (r && r.ok) DX_Toast("Warning #" + r.count + " given" + (r.autoTimeout ? " — auto-timeout applied." : "."), "success");
        else DX_Toast("Could not warn this member.", "error");
        DX_LoadMod();
    });
});
$(document).on("click", "#dx-warn-clear", function() {
    DX_Post("DiscordExt_ClearWarns", { serverId: Discord.currentServerId, memberId: DX.modTargetId }, function() { DX_LoadMod(); });
});
$(document).on("click", "[data-timeout]", function() {
    var minutes = parseInt($(this).attr("data-timeout"), 10);
    DX_Post("DiscordExt_Timeout", { serverId: Discord.currentServerId, memberId: DX.modTargetId, minutes: minutes, reason: $("#dx-warn-reason").val() || "" }, function(r) {
        DX_Toast(r && r.ok ? (minutes > 0 ? "Member timed out." : "Timeout removed.") : "Could not change the timeout.", r && r.ok ? "success" : "error");
        DX_LoadMod();
    });
});

// ---------------------------------------------------------------------------
// Leaderboard
// ---------------------------------------------------------------------------

function DX_OpenLeaderboard() {
    if (Discord.currentServerId == null) return;
    Discord_OpenModal("dx-modal-lb");
    $("#dx-lb-body").html('<div class="dx-empty">Loading...</div>');
    DX_Post("DiscordExt_GetLeaderboard", { serverId: Discord.currentServerId }, function(r) {
        if (!r) { $("#dx-lb-body").html('<div class="dx-empty">Could not load.</div>'); return; }
        var pct = r.me.need > 0 ? Math.min(100, Math.round(r.me.into / r.me.need * 100)) : 0;
        var html = '<div class="dx-section"><div class="dx-row dx-spread"><b>Your level: ' + r.me.level + "</b><span class=\"dx-muted\">Rank #" + r.me.rank + " · " + r.me.messages + ' messages</span></div>' +
                   '<div class="dx-progress dx-xp"><div style="width:' + pct + '%"></div></div><div class="dx-muted">' + r.me.into + " / " + r.me.need + " XP to next level</div></div><div>";
        if (!r.list.length) html += '<div class="dx-empty">Nobody has earned XP yet. Start chatting!</div>';
        $.each(r.list, function(i, row) {
            html += '<div class="dx-lb-row' + (row.mine ? " dx-me" : "") + '"><div class="dx-lb-rank">' + row.rank + '</div><div class="dx-lb-name">' + DX_Esc(row.name) +
                    '</div><div class="dx-lb-meta">Lv ' + row.level + "<br>" + row.xp + " XP</div></div>";
        });
        $("#dx-lb-body").html(html + "</div>");
    });
}
$(document).on("click", "#dx-lb-btn, #dx-open-lb-btn", DX_OpenLeaderboard);

// ---------------------------------------------------------------------------
// Search
// ---------------------------------------------------------------------------

function DX_Highlight(text, query) {
    var safe = DX_Esc(text);
    var q = DX_Esc(query).replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    return q ? safe.replace(new RegExp("(" + q + ")", "ig"), "<mark>$1</mark>") : safe;
}

function DX_RunSearch() {
    var q = $("#dx-search-input").val().trim();
    var box = $("#dx-search-results");
    if (q.length < 2) { box.html('<div class="dx-empty">Type at least 2 characters.</div>'); return; }
    box.html('<div class="dx-empty">Searching...</div>');
    DX_Post("DiscordExt_Search", {
        serverId: Discord.currentServerId,
        channelId: DX.searchWholeServer ? 0 : Discord.currentChannelId,
        query: q,
    }, function(rows) {
        if (!rows || !rows.length) { box.html('<div class="dx-empty">No messages found.</div>'); return; }
        var html = "";
        $.each(rows, function(i, r) {
            html += '<div class="dx-search-hit" data-channelid="' + r.channel_id + '" data-channelname="' + DX_Esc(r.channel_name) + '" data-messageid="' + r.id + '">' +
                    '<div class="dx-hit-meta"><span><b>' + DX_Esc(r.author_name) + "</b> in #" + DX_Esc(r.channel_name) + "</span><span>" + DX_Esc(Discord_FormatTime(r.created_at)) + "</span></div>" +
                    '<div class="dx-hit-text">' + DX_Highlight(r.message, q) + "</div></div>";
        });
        box.html(html);
    });
}

function DX_JumpTo(channelId, channelName, messageId) {
    $("#dx-search-panel").removeClass("dx-open");
    if (Discord.currentChannelId !== channelId) Discord_OpenChannel(channelId, channelName);
    var tries = 0;
    var timer = setInterval(function() {
        var el = $('.discord-message[data-messageid="' + messageId + '"]');
        if (el.length) {
            clearInterval(timer);
            el[0].scrollIntoView({ block: "center" });
            el.addClass("dx-msg-flash");
            setTimeout(function() { el.removeClass("dx-msg-flash"); }, 2400);
        } else if (++tries > 14) {
            clearInterval(timer);
            DX_Toast("That message is older than the history loaded in the channel.", "warn");
        }
    }, 150);
}

$(document).on("click", "#dx-search-btn", function() {
    var panel = $("#dx-search-panel");
    panel.toggleClass("dx-open");
    if (panel.hasClass("dx-open")) setTimeout(function() { $("#dx-search-input").focus(); }, 30);
});
$(document).on("click", "#dx-search-scope", function() {
    DX.searchWholeServer = !DX.searchWholeServer;
    $(this).text(DX.searchWholeServer ? "Whole server" : "This channel");
    DX_RunSearch();
});
$(document).on("input", "#dx-search-input", function() { clearTimeout(DX.searchTimer); DX.searchTimer = setTimeout(DX_RunSearch, 350); });
$(document).on("click", ".dx-search-hit", function() {
    var h = $(this);
    DX_JumpTo(parseInt(h.attr("data-channelid"), 10), h.attr("data-channelname"), parseInt(h.attr("data-messageid"), 10));
});
// Esc closes the search panel first (capture phase so the window doesn't close too)
document.addEventListener("keydown", function(e) {
    if (e.key === "Escape" && $("#dx-search-panel").hasClass("dx-open")) {
        $("#dx-search-panel").removeClass("dx-open");
        e.stopPropagation();
    }
}, true);

// ---------------------------------------------------------------------------
// Report a message + staff "Reports" tab
// ---------------------------------------------------------------------------

$(document).on("click", '.discord-message-actions i[data-action="report"]', function() {
    var id = parseInt($(this).closest(".discord-message").attr("data-messageid"), 10);
    if (!id) return;
    DX.reportMessageId = id;
    Discord_OpenModal("dx-modal-report");
    $("#dx-report-reason").val("").focus();
});
$(document).on("click", "#dx-report-send", function() {
    DX_Post("DiscordExt_Report", { messageId: DX.reportMessageId, reason: $("#dx-report-reason").val() }, function(r) {
        Discord_CloseModals();
        if (r && r.ok) DX_Toast("Thanks — staff will review this message.", "success");
        else if (r && r.error === "DUP") DX_Toast("You already reported that message.", "warn");
        else if (r && r.error === "SELF") DX_Toast("You can't report your own message.", "warn");
        else if (r && r.error === "COOLDOWN") DX_Toast("Slow down — try again in a moment.", "warn");
        else DX_Toast("Could not send the report.", "error");
    });
});

function DX_RefreshReportBadge() {
    DX_Post("DiscordExt_StaffReports", { status: "pending" }, function(r) {
        var b = $("#dx-report-badge");
        if (r && r.pending > 0) b.text(r.pending).show(); else b.hide();
    });
}

function DX_LoadReports() {
    var pane = $("#discord-staffpane-reports");
    pane.html('<div class="discord-staff-empty">Loading...</div>');
    DX_Post("DiscordExt_StaffReports", { status: "pending" }, function(r) {
        if (!r) { pane.html('<div class="discord-staff-empty">Could not load.</div>'); return; }
        var b = $("#dx-report-badge");
        if (r.pending > 0) b.text(r.pending).show(); else b.hide();
        if (!r.reports.length) { pane.html('<div class="discord-staff-empty">The report queue is empty.</div>'); return; }
        var html = "";
        $.each(r.reports, function(i, x) {
            html += '<div class="dx-report"><div class="dx-muted">' + DX_Esc(x.server_name || "?") + " · #" + DX_Esc(x.channel_name || "?") + " · " + DX_TimeLabel(x.created_at) + "</div>" +
                    "<div><b>" + DX_Esc(x.author_name) + "</b> was reported by <b>" + DX_Esc(x.reporter_name) + "</b>" + (x.reason ? ": " + DX_Esc(x.reason) : "") + "</div>" +
                    '<div class="dx-report-text">' + DX_Esc(x.message_text) + "</div>" +
                    '<div class="dx-row" data-reportid="' + x.id + '">' +
                    '<div class="dx-btn" data-reportaction="dismiss">Dismiss</div>' +
                    '<div class="dx-btn dx-danger" data-reportaction="delete">Delete message</div>' +
                    '<div class="dx-btn dx-danger" data-reportaction="delete_warn">Delete + warn</div></div></div>';
        });
        pane.html(html);
    });
}
$(document).on("click", "[data-reportaction]", function() {
    var row = $(this).closest("[data-reportid]");
    DX_Post("DiscordExt_StaffResolveReport", { reportId: parseInt(row.attr("data-reportid"), 10), action: $(this).attr("data-reportaction") }, function(ok) {
        if (!ok) DX_Toast("Could not update that report.", "error");
        DX_LoadReports();
    });
});

// ---------------------------------------------------------------------------
// Share from the phone's Gallery -> a Discord channel
// ---------------------------------------------------------------------------

var DXShare = { targets: [] };

function DX_InitShare() {
    var box = $(".gallery-detailscreen .make-post-button");
    if (!box.length) return;
    box.prepend('<div id="dx-share-button" title="Share to Discord"><i class="fab fa-discord"></i></div>');
    $(".gallery-app").append(
        '<div class="dx-share-sheet" id="dx-share-sheet">' +
            "<h3>Share to Discord</h3>" +
            '<label>Server</label><select id="dx-share-server"></select>' +
            '<label>Channel</label><select id="dx-share-channel"></select>' +
            '<label>Message (optional)</label><input type="text" id="dx-share-caption" maxlength="200" spellcheck="false" dir="auto">' +
            '<div class="dx-share-msg" id="dx-share-msg"></div>' +
            '<div class="dx-share-actions"><div id="dx-share-cancel">Cancel</div><div class="dx-go" id="dx-share-send">Send</div></div>' +
        "</div>"
    );
}

function DX_ShareFillChannels() {
    var sid = parseInt($("#dx-share-server").val(), 10);
    var html = "";
    $.each(DXShare.targets, function(i, s) {
        if (s.id === sid) $.each(s.channels, function(j, c) { html += '<option value="' + c.id + '"># ' + DX_Esc(c.name) + "</option>"; });
    });
    $("#dx-share-channel").html(html);
}

$(document).on("click", "#dx-share-button", function(e) {
    e.preventDefault();
    $("#dx-share-msg").text("");
    $("#dx-share-caption").val("");
    $("#dx-share-sheet").addClass("dx-open");
    DX_Post("DiscordExt_GetShareTargets", {}, function(list) {
        DXShare.targets = list || [];
        if (!DXShare.targets.length) {
            $("#dx-share-server, #dx-share-channel").empty();
            $("#dx-share-msg").text("Join a Discord server first.");
            return;
        }
        var html = "";
        $.each(DXShare.targets, function(i, s) { html += '<option value="' + s.id + '">' + DX_Esc(s.name) + "</option>"; });
        $("#dx-share-server").html(html);
        DX_ShareFillChannels();
    });
});
$(document).on("change", "#dx-share-server", DX_ShareFillChannels);
$(document).on("click", "#dx-share-cancel", function() { $("#dx-share-sheet").removeClass("dx-open"); });
$(document).on("click", "#dx-share-send", function() {
    var channelId = parseInt($("#dx-share-channel").val(), 10);
    var url = $("#imagedata").attr("src");
    if (!channelId || !url) return;
    $("#dx-share-msg").text("Sending...");
    DX_Post("DiscordExt_ShareImage", { channelId: channelId, url: url, caption: $("#dx-share-caption").val() }, function(r) {
        if (r && r.ok) {
            $("#dx-share-sheet").removeClass("dx-open");
            DX_Toast("Photo shared on Discord.", "success");
        } else {
            $("#dx-share-msg").text(DX_ErrorText(r));
        }
    });
});

// ---------------------------------------------------------------------------
// Messages from client/discord_ext.lua
// ---------------------------------------------------------------------------

function DX_SoftReloadServers() {
    Discord_Post("GetDiscordServers", {}, function(servers) {
        Discord.servers = servers || [];
        if (Discord.currentServerId != null && !Discord_FindServer(Discord.currentServerId)) {
            Discord_LoadServers();
        } else {
            Discord_RenderServerRail();
        }
    });
}

window.addEventListener("message", function(event) {
    var d = event.data;
    if (!d || !d.action) return;
    switch (d.action) {
        case "DiscordExtNotice":
            DX_Toast(d.data && d.data.text, d.data && d.data.kind);
            break;
        case "DiscordExtServersChanged":
            DX.info = {};
            if ($("#discord-backdrop").hasClass("discord-visible")) DX_SoftReloadServers();
            else Discord_Post("GetDiscordServers", {}, function(s) { Discord.servers = s || []; });
            DX_RefreshUnread();
            break;
        case "DiscordExtServerExtrasUpdated":
            if (d.data && d.data.serverId != null) {
                DX_LoadInfo(d.data.serverId, function(info) {
                    if (info && info.serverId === Discord.currentServerId) {
                        DX_ApplyServerLook(info);
                        if ($("#dx-modal-tools").hasClass("discord-modal-active")) DX_RenderTools(info);
                    }
                    DX_DecorateRail();
                });
                if (d.data.serverId === Discord.currentServerId) DX_LoadMeta(d.data.serverId);
            }
            break;
        case "DiscordExtUnread":
            DX_SetUnreadFromServer(d.data);
            break;
    }
});

$(function() {
    DX_BuildUI();
    DX_InitShare();
});
