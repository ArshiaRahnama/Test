// ============================================================================
// Discord v45 — channel categories you create yourself.
//  * server menu: "Create Category"
//  * the channel list shows your categories (collapsible); channels inside move there
//  * channel right-click: "Move to Category" (also back to "No category")
//  * category header: trash icon (managers) deletes the category; channels are kept
// Server: discord_v45.lua. Needs the manage-channels permission.
// ============================================================================

var DXC = { cache: {}, last: {}, ctxChannel: null, delId: null, moveCh: null };

function DXC_Can() { var p = (window.DX2_Perms && DX2_Perms()) || {}; return !!(p.manage_channels || p.administrator); }

function DXC_Err(code) {
    return ({ NOT_CREATOR: "Only creators can create categories.", NO_PERMISSION: "You need the Manage Channels permission.",
              BAD_NAME: "Give the category a name.", TAKEN: "A category with that name already exists.",
              LIMIT: "A server can have up to 10 categories." })[code] || "Something went wrong.";
}

// ---------- load + draw ----------
function DXC_Fetch(force) {
    var sid = Discord.currentServerId;
    if (!sid) return;
    var now = Date.now();
    if (!force && DXC.last[sid] && now - DXC.last[sid] < 3000) return;
    DXC.last[sid] = now;
    DX_Post("DiscordExt_GetCategories", { serverId: sid }, function(r) {
        if (!r || !r.categories) return;
        var changed = JSON.stringify(r) !== JSON.stringify(DXC.cache[sid]);
        DXC.cache[sid] = r;
        if (changed && sid === Discord.currentServerId && window.Discord_RenderChannelList) Discord_RenderChannelList();
    });
}

function DXC_Apply() {
    var sid = Discord.currentServerId, d = DXC.cache[sid], list = $("#discord-channel-list");
    if (!list.length || !d || !d.categories || !d.categories.length) return;
    if (list.find(".dxc-cat").length) return;
    var can = DXC_Can();
    $.each(d.categories, function(i, c) {
        var key = "u" + c.id, collapsed = !!(window.DXS && DXS.catCollapsed[sid + ":" + key]);
        var head = $('<div class="dx-category dxc-cat' + (collapsed ? " dx-collapsed" : "") + '" data-cat="' + key + '" data-catid="' + c.id + '"><i class="fas fa-chevron-down dx-cat-chev"></i><span>' +
                     DX_Esc(c.name) + "</span>" + (can ? '<i class="fas fa-trash-alt dxc-del" title="Delete Category"></i>' : "") + "</div>");
        var body = $('<div class="dx-category-body' + (collapsed ? " dx-collapsed" : "") + '"></div>');
        list.append(head).append(body);
        $.each(d.channels || {}, function(chId, catId) {
            if (catId === c.id) body.append(list.find('.discord-channel-item[data-channelid="' + chId + '"]'));
        });
    });
    // default groups that lost all their channels disappear
    list.children(".dx-category").not(".dxc-cat").each(function() {
        var b = $(this).next(".dx-category-body");
        if (!b.children().length) { b.remove(); $(this).remove(); }
    });
}

DX_After("Discord_RenderChannelList", function() { DXC_Apply(); DXC_Fetch(false); });

// ---------- modals ----------
function DXC_Build() {
    var ov = $("#discord-modal-overlay");
    if (!ov.length || $("#dxc-modal-create").length) return;
    ov.append(
        '<div class="discord-modal" id="dxc-modal-create"><div class="discord-modal-title">Create Category</div>' +
        '<div class="discord-settings-label">CATEGORY NAME</div><input type="text" id="dxc-name" maxlength="30" autocomplete="off" spellcheck="false" placeholder="New Category">' +
        '<div class="dxc-err" id="dxc-err"></div>' +
        '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Cancel</div>' +
        '<div class="discord-modal-btn discord-modal-confirm" id="dxc-create-go">Create Category</div></div></div>' +
        '<div class="discord-modal" id="dxc-modal-move"><div class="discord-modal-title">Move to Category</div><div id="dxc-move-list"></div>' +
        '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Cancel</div></div></div>' +
        '<div class="discord-modal" id="dxc-modal-delete"><div class="discord-modal-title">Delete Category</div>' +
        '<div class="dxc-text" id="dxc-del-text"></div>' +
        '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Cancel</div>' +
        '<div class="discord-modal-btn dxc-danger" id="dxc-del-go">Delete Category</div></div></div>');
}
$(function() { setTimeout(DXC_Build, 60); });

function DXC_OpenCreate() {
    DXC_Build();
    $("#dxc-name").val(""); $("#dxc-err").text("");
    Discord_OpenModal("dxc-modal-create");
    setTimeout(function() { $("#dxc-name").focus(); }, 60);
}
$(document).on("click", "#dxc-create-go", function() {
    var name = ($("#dxc-name").val() || "").trim();
    $("#dxc-err").text("");
    if (!name) { $("#dxc-err").text(DXC_Err("BAD_NAME")); return; }
    DX_Post("DiscordExt_CreateCategory", { serverId: Discord.currentServerId, name: name }, function(r) {
        if (!r || r.error || r === false) { $("#dxc-err").text(DXC_Err(r && r.error)); return; }
        if (window.Discord_CloseModals) Discord_CloseModals();
        if (window.DX_Toast) DX_Toast("Category created.", "success");
        DXC_Fetch(true);
    });
});
$(document).on("keydown", "#dxc-name", function(e) { if (e.key === "Enter") $("#dxc-create-go").trigger("click"); });

// ---------- server menu: "Create Category" ----------
$(document).on("click", ".dxm42-item[data-act='category']", function() {
    if (window.Discord_CloseModals) Discord_CloseModals();
    DXC_OpenCreate();
});

// ---------- channel right-click: "Move to Category" ----------
$(document).on("contextmenu mousedown", ".discord-channel-item[data-channelid]", function() { DXC.ctxChannel = parseInt($(this).attr("data-channelid"), 10); });
(function() {
    var orig = window.DX2_Ctx;
    if (typeof orig !== "function") return;
    window.DX2_Ctx = function(x, y, items) {
        if (DXC.ctxChannel != null && items && items.length && /Mute channel|Unmute channel/.test(items[0].label) && DXC_Can()) {
            var cid = DXC.ctxChannel;
            items = items.concat([{ sep: true }, { label: "Move to Category", icon: "fa-folder", fn: function() { DXC_OpenMove(cid); } }]);
        }
        DXC.ctxChannel = null;
        return orig.call(this, x, y, items);
    };
})();

function DXC_OpenMove(channelId) {
    DXC_Build();
    DXC.moveCh = channelId;
    var d = DXC.cache[Discord.currentServerId] || { categories: [], channels: {} };
    var cur = (d.channels || {})[String(channelId)] || 0;
    var rows = [{ id: 0, name: "No category" }].concat(d.categories || []);
    $("#dxc-move-list").html(rows.map(function(c) {
        return '<div class="dxc-move-row' + (c.id === cur ? " dxc-cur" : "") + '" data-catid="' + c.id + '"><i class="fas ' + (c.id === 0 ? "fa-ban" : "fa-folder") + '"></i><span>' + DX_Esc(c.name) + "</span>" + (c.id === cur ? '<i class="fas fa-check dxc-tick"></i>' : "") + "</div>";
    }).join(""));
    Discord_OpenModal("dxc-modal-move");
}
$(document).on("click", ".dxc-move-row", function() {
    var catId = parseInt($(this).attr("data-catid"), 10) || 0;
    DX_Post("DiscordExt_SetChannelCategory", { serverId: Discord.currentServerId, channelId: DXC.moveCh, categoryId: catId }, function(r) {
        if (window.Discord_CloseModals) Discord_CloseModals();
        if (!r || r.error) { if (window.DX_Toast) DX_Toast(DXC_Err(r && r.error), "error"); return; }
        DXC_Fetch(true);
    });
});

// ---------- delete a category ----------
document.addEventListener("click", function(e) {
    var t = e.target;
    if (!t || !t.classList || !t.classList.contains("dxc-del")) return;
    e.stopPropagation();
    var head = $(t).closest(".dxc-cat");
    DXC.delId = parseInt(head.attr("data-catid"), 10);
    DXC_Build();
    $("#dxc-del-text").text("Delete \u201C" + head.children("span").first().text() + "\u201D? The channels inside are not deleted; they move back to the main list.");
    Discord_OpenModal("dxc-modal-delete");
}, true);
$(document).on("click", "#dxc-del-go", function() {
    DX_Post("DiscordExt_DeleteCategory", { serverId: Discord.currentServerId, categoryId: DXC.delId }, function(r) {
        if (window.Discord_CloseModals) Discord_CloseModals();
        if (!r || r.error) { if (window.DX_Toast) DX_Toast(DXC_Err(r && r.error), "error"); return; }
        DXC_Fetch(true);
    });
});
