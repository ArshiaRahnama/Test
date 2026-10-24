// ============================================================================
// Discord v42 — the server dropdown uses Discord's own list and order.
// Only items that really work in this app are shown (no fake entries):
//   Server Boost, Invite to Server, Server Settings, Create Channel,
//   Edit Per-server Profile,
//   Copy Server ID, Leave Server (members), Delete Server (owner).
// Items Discord has that this app does not implement yet are left out on purpose
// (Show All Channels and Hide Muted Channels need a mute flag in the channel list first).
// ============================================================================

function DXM42_Items() {
    var owner = !!Discord.currentServerIsOwner;
    var list = [
        { label: "Server Boost",            icon: "fa-gem",          act: "boost" },
        { label: "Invite to Server",        icon: "fa-user-plus",    act: "invite" },
        { label: "Server Settings",         icon: "fa-cog",          act: "settings", owner: true },
        { label: "Create Channel",          icon: "fa-plus-circle",  act: "channel", owner: true },
        { label: "Create Category",         icon: "fa-folder-plus",  act: "category", owner: true },
        { sep: true },
        { label: "Notification Settings",   icon: "fa-bell",         act: "notify" },
        { label: "Privacy Settings",        icon: "fa-shield-alt",   act: "privacy" },
        { label: "Edit Per-server Profile", icon: "fa-id-card",      act: "nick" },
        { sep: true },
        { label: "Security Actions",        icon: "fa-lock",         act: "security", manage: true, danger: true },
        { label: "Copy Server ID",          icon: "fa-copy",         act: "copyid" },
        { label: "Leave Server",            icon: "fa-sign-out-alt", act: "leave", danger: true, member: true },
        { label: "Delete Server",           icon: "fa-trash",        act: "delete", danger: true, owner: true }
    ];
    return list.filter(function(it) {
        if (it.sep) return true;
        if (it.manage) { var p = (window.DX2_Perms && DX2_Perms()) || {}; return owner || !!p.manage_server || !!p.administrator; }
        if (it.owner && !owner) return false;
        if (it.member && owner) return false;
        return true;
    });
}

function DXM42_Render() {
    var box = $("#discord-modal-server-menu");
    if (!box.length) return;
    var items = DXM42_Items(), html = '<div class="dxm42">';
    items.forEach(function(it) {
        if (it.sep) { html += '<div class="dxm42-sep"></div>'; return; }
        var on = it.check ? (localStorage.getItem(it.key) === "1") : false;
        html += '<div class="dxm42-item' + (it.danger ? " dxm42-danger" : "") + '" data-act="' + it.act + '">' +
                '<i class="fas ' + it.icon + '"></i><span>' + DX_Esc(it.label) + "</span>" +
                (it.check ? '<span class="dxm42-check">' + (on ? "\u2713" : "") + "</span>" : "") + "</div>";
    });
    html += "</div>";
    box.find(".dxm42").remove();
    box.find(".discord-modal-title").after(html);
}

(function() {
    var orig = window.Discord_OpenServerMenu;
    if (typeof orig !== "function") return;
    window.Discord_OpenServerMenu = function() {
        var r = orig.apply(this, arguments);
        DXM42_Render();
        return r;
    };
})();

$(document).on("click", ".dxm42-item", function() {
    var act = $(this).attr("data-act");
    var sid = Discord.currentServerId;
    var close = function() { if (window.Discord_CloseModals) Discord_CloseModals(); };
    if (act === "boost")     { close(); if (window.DX_OpenTools) DX_OpenTools(); return; }
    if (act === "invite")    { close(); if (window.DX_OpenTools) DX_OpenTools(); return; }
    if (act === "settings")  { close(); Discord_OpenServerSettings(); return; }
    if (act === "channel")   { close(); $("#discord-create-channel-open-btn").trigger("click"); return; }
    if (act === "nick")      { close(); if (window.DX_OpenNickname) DX_OpenNickname(sid); return; }
    if (act === "copyid")    {
        var tmp = $("<input>").val(String(sid)).appendTo("body").select();
        try { document.execCommand("copy"); } catch (e) {}
        tmp.remove();
        if (window.DX_Toast) DX_Toast("Server ID copied.", "success");
        return;
    }
    if (act === "leave")     { close(); Discord_Post("LeaveDiscordServer", { serverId: sid }); return; }
    if (act === "delete")    { close(); $("#discord-delete-server-btn").trigger("click"); return; }
    if (act === "showall" || act === "hidemuted") {
        var key = act === "showall" ? "dxm42-showall" : "dxm42-hidemuted";
        localStorage.setItem(key, localStorage.getItem(key) === "1" ? "0" : "1");
        if (act === "hidemuted") $("body").toggleClass("dxm42-hide-muted", localStorage.getItem(key) === "1");
        DXM42_Render();
    }
});
