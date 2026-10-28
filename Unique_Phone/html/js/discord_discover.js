// ============================================================================
// Discord v13 — Discover (search, categories, featured) + Discover category
// setting in Server Settings + activity card on member profiles.
// Loaded after discord_polish.js. Server: server/discord_ext4.lua.
// ============================================================================

var DXD2 = { cat: "all", q: "", timer: null, list: [] };

var DXD2_CATS = [
    ["all", "All", "fa-compass"], ["gaming", "Gaming", "fa-gamepad"], ["roleplay", "Roleplay", "fa-theater-masks"],
    ["gangs", "Gangs", "fa-user-secret"], ["jobs", "Jobs", "fa-briefcase"], ["community", "Community", "fa-users"], ["other", "Other", "fa-ellipsis-h"],
];

function DXD2_Initials(name) { return Discord_Initials(name || "?"); }

function DXD2_BuildBar() {
    var list = $("#discord-discover-list");
    if (!list.length || $("#dxd-bar").length) return;
    var chips = "";
    $.each(DXD2_CATS, function(i, c) {
        chips += '<div class="dxd-chip' + (c[0] === DXD2.cat ? " dxd-sel" : "") + '" data-cat="' + c[0] + '"><i class="fas ' + c[2] + '"></i>' + DX_Esc(c[1]) + "</div>";
    });
    list.before('<div id="dxd-bar"><div class="dxd-search"><i class="fas fa-search"></i><input type="text" id="dxd-q" placeholder="Search for servers" maxlength="40" spellcheck="false" autocomplete="off" dir="auto" value="' + DX_Esc(DXD2.q) + '"></div>' +
                '<div class="dxd-chips" id="dxd-chips">' + chips + "</div></div>");
}

function DXD2_Card(s, featured) {
    var grad = "linear-gradient(135deg," + DX_Esc(s.icon_color || "#5865F2") + ",#1e1f22)";
    var icon = s.icon_url ? ' dx-img" style="background-color:' + DX_Esc(s.icon_color || "#5865F2") + DXD_Img(s.icon_url) : '" style="background-color:' + DX_Esc(s.icon_color || "#5865F2");
    var btn = s.isMember
        ? '<div class="dxd-btn dxd-open" data-open="' + s.id + '">Open</div>'
        : '<div class="discord-btn discord-btn-primary discord-btn-small discord-discover-join-btn dxd-join" data-serverid="' + s.id + '">Join</div>';
    return '<div class="dxd-card' + (featured ? " dxd-feat" : "") + '" data-sid="' + s.id + '">' +
           '<div class="dxd-banner" style="background:' + grad + '"></div>' +
           '<div class="dxd-av' + icon + '">' + DX_Esc(s.icon_url ? "" : (s.icon_text || DXD2_Initials(s.name))) + "</div>" +
           '<div class="dxd-body"><div class="dxd-name"><span class="dxd-nt">' + DX_Esc(s.name) + "</span>" + (s.isVerified ? '<i class="fas fa-check-circle dxd-ver" title="Verified"></i>' : "") + (s.isFeatured ? '<i class="fas fa-gem dxd-vip" title="VIP"></i>' : "") + "</div>" +
           '<div class="dxd-desc">' + DX_Esc(s.description || "No description yet.") + "</div>" +
           (s.tags ? '<div class="dxd-tags">' + String(s.tags).split(",").map(function(t) { return '<span class="dxd-tag">' + DX_Esc(t) + "</span>"; }).join("") + "</div>" : "") +
           '<div class="dxd-stats"><span class="dxd-online"><i class="fas fa-circle"></i>' + (s.onlineCount || 0) + ' online</span><span>' + (s.memberCount || 0) + " member" + (s.memberCount === 1 ? "" : "s") + "</span></div></div>" +
           '<div class="dxd-foot">' + btn + "</div></div>";
}

function DXD2_Render() {
    var list = $("#discord-discover-list");
    DXD2_BuildBar();
    $("#dxd-chips .dxd-chip").removeClass("dxd-sel").filter('[data-cat="' + DXD2.cat + '"]').addClass("dxd-sel");
    var servers = DXD2.list || [];
    if (!servers.length) {
        var msg = DXD2.q ? "No server matches \u201C" + DXD2.q + "\u201D." : (DXD2.cat === "all" ? "No public servers yet. Owners can list a server under Server Settings \u2192 Overview." : "No servers in this category yet.");
        list.html('<div class="dxd-empty"><i class="fas fa-compass"></i><p>' + DX_Esc(msg) + "</p></div>");
        return;
    }
    var html = "";
    var feat = servers.filter(function(s) { return s.isFeatured; });
    var rest = servers.filter(function(s) { return !s.isFeatured; });
    if (feat.length && !DXD2.q && DXD2.cat === "all") {
        html += '<div class="dxd-sec"><i class="fas fa-gem"></i> Featured</div><div class="dxd-row dxd-feat-row">';
        $.each(feat, function(i, s) { html += DXD2_Card(s, true); });
        html += "</div>";
    }
    html += '<div class="dxd-sec">' + (DXD2.q ? "Results" : (DXD2.cat === "all" ? "All public servers" : DX_Esc((DXD2_CATS.filter(function(c) { return c[0] === DXD2.cat; })[0] || [])[1] || ""))) + " \u2014 " + servers.length + "</div>";
    html += '<div class="dxd-row">';
    $.each(DXD2.cat === "all" && !DXD2.q ? rest : servers, function(i, s) { html += DXD2_Card(s, false); });
    html += "</div>";
    list.html(html);
}

function DXD2_Load() {
    var list = $("#discord-discover-list");
    DXD2_BuildBar();
    if (!DXD2.list.length) list.html('<div class="dxd-empty dxd-loading"><i class="fas fa-circle-notch fa-spin"></i><p>Loading servers\u2026</p></div>');
    var req = ++DXD2.req;
    DX_Post("GetDiscordDiscover", { query: DXD2.q, category: DXD2.cat === "all" ? "" : DXD2.cat }, function(res) {
        if (req !== DXD2.req) return;
        DXD2.list = (res && res.length !== undefined) ? res : [];
        DXD2_Render();
    });
}
DXD2.req = 0;

window.Discord_LoadDiscoverList = function() { DXD2_Load(); };

$(document).on("click", "#dxd-chips .dxd-chip", function() {
    DXD2.cat = $(this).attr("data-cat");
    DXD2.list = [];
    DXD2_Load();
});
$(document).on("input", "#dxd-q", function() {
    DXD2.q = ($(this).val() || "").trim();
    clearTimeout(DXD2.timer);
    DXD2.timer = setTimeout(DXD2_Load, 280);
});
$(document).on("click", ".dxd-open", function(e) {
    e.stopPropagation();
    var sid = parseInt($(this).attr("data-open"), 10);
    Discord_CloseModals();
    Discord_SelectServer(sid);
});
$(document).on("click", ".dxd-card .dxd-body, .dxd-card .dxd-banner, .dxd-card .dxd-av", function(e) {
    var sid = parseInt($(this).closest(".dxd-card").attr("data-sid"), 10);
    if (sid) DX2_ShowCard(sid, $(this).closest(".dxd-card"));
});

// ---------------------------------------------------------------------------
// Server Settings: Discover category + listing toggle
// ---------------------------------------------------------------------------

DX_After("DX_RenderTools", function(info) {
    var body = $("#dx-tools-body");
    if (!info || !body.length || info.kind || !info.canConfigure || !info.discover) return;
    if (!(info.isOwner || (info.perms || {}).manage_server)) return;
    body.find(".dxd-settings").remove();
    var opts = "";
    $.each(DXD2_CATS.slice(1), function(i, c) { opts += '<option value="' + c[0] + '"' + (info.discover.category === c[0] ? " selected" : "") + ">" + DX_Esc(c[1]) + "</option>"; });
    body.append('<div class="dx-section dxd-settings" data-tab="overview"><h4>Discover</h4>' +
                '<div class="dxd-set-row"><span class="dxd-set-lbl">Tags</span><input class="dx-input" id="dxd-set-tags" maxlength="80" placeholder="roleplay, police (up to 4)" value="' + DX_Esc(info.tags || "") + '"></div>' +
                '<div class="dxd-set-row"><label class="dx-check"><input type="checkbox" id="dxd-set-public"' + (info.discover.isPublic ? " checked" : "") + "> List this server on Discover (anyone can join)</label></div>" +
                '<div class="dxd-set-row"><span class="dxd-set-lbl">Category</span><select class="dx-input" id="dxd-set-cat">' + opts + "</select></div>" +
                '<div class="dxd-set-row"><div class="dx-btn dx-primary" id="dxd-set-save">Save</div></div></div>');
    if (window.DXS_ApplySettingsTabs) DXS_ApplySettingsTabs();
});
$(document).on("click", "#dxd-set-save", function() {
    DX_Post("DiscordExt_SetDiscoverCategory", { serverId: Discord.currentServerId, category: $("#dxd-set-cat").val(), isPublic: $("#dxd-set-public").is(":checked") }, function(r) {
        if (r && r.ok) { DX_Toast("Discover settings saved.", "success"); DX_LoadInfo(Discord.currentServerId); }
        else DX_Toast(r && r.error === "AUTO" ? "Official servers can't be listed." : "Could not save.", "error");
    });
});

// ---------------------------------------------------------------------------
// Activity card on a member's profile (structured: place / vehicle / duty)
// ---------------------------------------------------------------------------

function DXD2_ActivityHtml(act) {
    var color = act.color || "#5865F2";
    var mins = Math.floor((act.elapsed || 0) / 60), since = mins < 1 ? "just now" : mins < 60 ? mins + " min" : Math.floor(mins / 60) + " h " + (mins % 60) + " min";
    return '<div class="dxd-act"><div class="dxd-act-head">Activity</div>' +
           '<div class="dxd-act-card"><div class="dxd-act-ico" style="background:' + DX_Esc(color) + '"><i class="fas ' + DX_Esc(act.icon || "fa-circle") + '"></i></div>' +
           '<div class="dxd-act-text"><div class="dxd-act-title">' + DX_Esc(act.title || "") + '</div>' +
           (act.subtitle ? '<div class="dxd-act-sub">' + DX_Esc(act.subtitle) + "</div>" : "") +
           '<div class="dxd-act-time"><span data-since="' + DX_Esc(String(act.elapsed || 0)) + '" data-at="' + Date.now() + '">for ' + since + "</span></div></div></div></div>";
}

DX_After("Discord_OpenMemberProfile", function(memberId) {
    var tries = 0;
    var t = setInterval(function() {
        tries++;
        var card = $("#discord-modal-profile-view");
        if (((card.length && card.hasClass("discord-modal-active") && card.find("#discord-pv-name").text().trim() !== "") || tries > 15)) {
            clearInterval(t);
            card.find(".dxd-act").remove();
            var m = (DX.meta[Discord.currentServerId] || {})[String(memberId)];
            if (!m || !m.act) return;
            card.find(".discord-profile-body").prepend(DXD2_ActivityHtml(m.act));
        }
    }, 80);
});
// keep the "for N min" text ticking while the card is open
setInterval(function() {
    $(".dxd-act-time span").each(function() {
        var el = $(this), base = parseInt(el.attr("data-since"), 10) || 0, at = parseInt(el.attr("data-at"), 10) || Date.now();
        var mins = Math.floor((base + (Date.now() - at) / 1000) / 60);
        el.text("for " + (mins < 1 ? "just now" : mins < 60 ? mins + " min" : Math.floor(mins / 60) + " h " + (mins % 60) + " min"));
    });
}, 15000);
