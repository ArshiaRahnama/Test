// ============================================================================
// Discord v17 — bulk delete (staff selects messages, deletes them together) and
// "hide messages from this person" (only on this phone). Loaded last.
// Server: discord_v17.lua.
// ============================================================================

var DXB = { sel: {}, muteKey: null };

function DXB_CanBulk() {
    var p = (typeof DX2_Perms === "function" && DX2_Perms()) || {};
    return !!(p.manage_messages || p.manage_channels || p.administrator);
}
function DXB_Count() { return Object.keys(DXB.sel).length; }

function DXB_Render() {
    $(".dxb-sel").removeClass("dxb-sel");
    $.each(DXB.sel, function(id) { $('#discord-chat-messages .discord-message[data-messageid="' + id + '"]').addClass("dxb-sel"); });
    var n = DXB_Count();
    if (!n) { $("#dxb-bar").removeClass("dxb-show"); return; }
    if (!$("#dxb-bar").length) {
        $("body").append('<div id="dxb-bar"><span id="dxb-n"></span><div class="dxb-go" id="dxb-delete"><i class="fas fa-trash-alt"></i> Delete</div><div class="dxb-clear" id="dxb-clear">Cancel</div></div>');
    }
    $("#dxb-n").text(n + " selected");
    $("#dxb-bar").addClass("dxb-show");
}

// add the staff item to the message menu (wraps the same hook the featured-message code uses)
(function() {
    var origCtx = window.DX2_Ctx;
    if (typeof origCtx !== "function") return;
    window.DX2_Ctx = function(x, y, items) {
        var row = window.DXF && DXF.row;
        if (row && DXB_CanBulk()) {
            var id = parseInt(row.attr("data-messageid"), 10);
            var msg = Discord.messagesById && Discord.messagesById[id];
            if (msg && !msg.isAnnouncement) {
                items = (items || []).concat([{ sep: true }, {
                    label: DXB.sel[id] ? "Unselect for bulk delete" : "Select for bulk delete", icon: "fa-check-square",
                    fn: function() { if (DXB.sel[id]) delete DXB.sel[id]; else DXB.sel[id] = true; DXB_Render(); }
                }]);
            }
        }
        return origCtx.call(this, x, y, items);
    };
})();

$(document).on("click", "#dxb-clear", function() { DXB.sel = {}; DXB_Render(); });
$(document).on("click", "#dxb-delete", function() {
    var ids = Object.keys(DXB.sel).map(function(k) { return parseInt(k, 10); });
    if (!ids.length) return;
    DX_Post("DiscordExt_BulkDelete", { channelId: Discord.currentChannelId, ids: ids }, function(r) {
        if (r && r.ok) {
            $.each(r.ids || [], function(i, id) { $('#discord-chat-messages .discord-message[data-messageid="' + id + '"]').remove(); });
            DXB.sel = {}; DXB_Render();
            if (window.DX_Toast) DX_Toast("Deleted " + r.count + " message" + (r.count === 1 ? "" : "s") + ".", "success");
        } else if (window.DX_Toast) {
            DX_Toast({ NO_PERMISSION: "You can't delete messages here.", BAD_COUNT: "Select 1 to 50 messages.", BAD_LIST: "Something in the selection is wrong." }[r && r.error] || "Could not delete.", "error");
        }
    });
});

// clicking a selected message toggles it while the select bar is open
$(document).on("click", "#discord-chat-messages .discord-message.dxb-sel", function(e) {
    if ($(e.target).closest(".discord-message-actions, .discord-open-profile, a").length) return;
    var id = parseInt($(this).attr("data-messageid"), 10);
    delete DXB.sel[id];
    DXB_Render();
});
$(document).on("click", "#discord-chat-messages .discord-message", function(e) {
    if (DXB_Count() === 0) return;
    if ($(e.target).closest(".discord-message-actions, .discord-open-profile, a, .discord-reaction-pill").length) return;
    var id = parseInt($(this).attr("data-messageid"), 10);
    if (!id || !DXB_CanBulk()) return;
    DXB.sel[id] = true;
    DXB_Render();
});

// ---------------------------------------------------------------------------
// Hide one person's messages, only on this phone
// ---------------------------------------------------------------------------

function DXB_MuteList() {
    try { return JSON.parse(localStorage.getItem("dxm:" + Discord.currentServerId) || "[]"); } catch (e) { return []; }
}
function DXB_SaveMutes(list) {
    try { localStorage.setItem("dxm:" + Discord.currentServerId, JSON.stringify(list)); } catch (e) {}
    DXB_ApplyMutes();
}
function DXB_ApplyMutes() {
    var list = DXB_MuteList().map(String);
    $("#discord-chat-messages .discord-message").each(function() {
        var author = $(this).find(".discord-message-author[data-authorid], .discord-message-avatar[data-authorid]").first().attr("data-authorid");
        $(this).toggleClass("dxm-hidden", !!author && list.indexOf(String(author)) >= 0);
    });
}
DX_After("DX_DecorateAll", DXB_ApplyMutes);
DX_After("Discord_OpenChannel", function() { setTimeout(DXB_ApplyMutes, 60); });

// user menu on a name: add / remove "hide messages" (wraps the user-menu hook)
(function() {
    var origCtx = window.DX2_Ctx;
    if (typeof origCtx !== "function") return;
    window.DX2_Ctx = function(x, y, items) {
        var t = window.DXB && DXB.userPick;
        if (t) {
            DXB.userPick = null;
            var list = DXB_MuteList().map(String), on = list.indexOf(String(t.memberId)) >= 0;
            items = (items || []).concat([{ sep: true }, {
                label: on ? "Show this person's messages" : "Hide this person's messages (only for me)", icon: on ? "fa-eye" : "fa-eye-slash",
                fn: function() {
                    var l = DXB_MuteList().map(String), i = l.indexOf(String(t.memberId));
                    if (i >= 0) l.splice(i, 1); else l.push(String(t.memberId));
                    DXB_SaveMutes(l);
                    if (window.DX_Toast) DX_Toast(i >= 0 ? "Showing their messages again." : "Their messages are hidden on this phone.", "info");
                }
            }]);
        }
        return origCtx.call(this, x, y, items);
    };
})();
$(document).on("contextmenu", ".discord-open-profile[data-authorid], #discord-members-list .discord-member-item", function() {
    var id = $(this).attr("data-authorid") || $(this).attr("data-memberrowid");
    if (id) DXB.userPick = { memberId: id };
});
