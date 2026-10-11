// ============================================================================
// Discord v16 — focus mode (only direct mentions ring in servers), channels from
// templates (built-in + saved), featured messages (staff stars). Loaded last.
// Server: discord_v16.lua.
// ============================================================================

var DXF = { row: null, suppress: false };

// ---------------------------------------------------------------------------
// 9) Focus mode: in servers, only messages that mention you ring
// ---------------------------------------------------------------------------

function DXF_On() { try { return localStorage.getItem("dxf_focus") === "1"; } catch (e) { return !!DXF.memOn; } }
function DXF_SetOn(v) { try { localStorage.setItem("dxf_focus", v ? "1" : "0"); } catch (e) { DXF.memOn = v; } }

(function() {
    var origIn = window.Discord_HandleIncomingMessage;
    if (typeof origIn !== "function") return;
    window.Discord_HandleIncomingMessage = function(payload) {
        var quiet = DXF_On() && payload && !payload.isMine && !payload.isAnnouncement && !(window.Discord_MentionsMe && Discord_MentionsMe(payload.message));
        DXF.suppress = !!quiet;
        try { return origIn.apply(this, arguments); } finally { DXF.suppress = false; }
    };
    var origSound = window.Discord_PlayNotificationSound;
    if (typeof origSound === "function") {
        window.Discord_PlayNotificationSound = function() {
            if (DXF.suppress) return;
            return origSound.apply(this, arguments);
        };
    }
})();

DX_After("Discord_OpenProfileEditor", function() {
    var m = $("#discord-modal-profile-edit");
    if (!m.length) return;
    m.find(".dxf-focus").remove();
    m.find(".discord-modal-buttons").before('<div class="dxf-focus"><label class="dxf-check"><input type="checkbox" id="dxf-focus-toggle"' + (DXF_On() ? " checked" : "") +
        '> Focus mode: in servers, only messages that mention me make a sound</label></div>');
});
$(document).on("change", "#dxf-focus-toggle", function() { DXF_SetOn($(this).is(":checked")); if (window.DX_Toast) DX_Toast($(this).is(":checked") ? "Focus mode on." : "Focus mode off.", "info"); });

// ---------------------------------------------------------------------------
// 21) Channels from templates
// ---------------------------------------------------------------------------

var DXT = { templates: [] };

(function() {
    var orig = window.Discord_OpenModal;
    window.Discord_OpenModal = function(id) {
        var r = orig.apply(this, arguments);
        if (id === "discord-modal-create-channel") setTimeout(DXT_BuildCreate, 0);
        if (id === "dx-modal-editchannel") setTimeout(DXT_BuildSave, 0);
        return r;
    };
})();

function DXT_BuildCreate() {
    var m = $("#discord-modal-create-channel");
    if (!m.length || m.find("#dxt-template").length) return;
    m.find("#discord-new-channel-name").before('<div class="dxt-row"><label class="dxt-lbl">Start from</label><select id="dxt-template" class="dx-input"><option value="">Blank channel</option></select></div>');
    DX_Post("DiscordExt_GetChannelTemplates", { serverId: Discord.currentServerId }, function(list) {
        DXT.templates = list || [];
        var opts = '<option value="">Blank channel</option>';
        $.each(DXT.templates, function(i, t) { opts += '<option value="' + DX_Esc(t.key) + '">' + DX_Esc(t.label) + "</option>"; });
        $("#dxt-template").html(opts);
    });
}

// with a template selected, the create button uses the template (the stage checkbox still works for blank channels)
document.addEventListener("click", function(e) {
    var btn = $(e.target).closest("#discord-confirm-create-channel");
    if (!btn.length) return;
    var key = $("#dxt-template").val();
    if (!key) return;
    e.stopPropagation(); e.preventDefault();
    var name = ($("#discord-new-channel-name").val() || "").trim();
    DX_Post("DiscordExt_CreateChannelFromTemplate", { serverId: Discord.currentServerId, key: key, name: name }, function(r) {
        if (r && r.ok) {
            $("#discord-new-channel-name").val("");
            $("#dxt-template").val("");
            Discord_CloseModals();
            if (window.DX2_ReloadChannels) DX2_ReloadChannels();
            if (window.DX_Toast) DX_Toast("Channel #" + r.name + " created from a template.", "success");
        } else {
            var msg = { LIMIT: "This server has too many channels.", BAD_NAME: "Give the channel a name.", BAD_TEMPLATE: "That template no longer exists." }[r && r.error] || "Could not create the channel.";
            if (window.Discord_ShowModalError) Discord_ShowModalError("discord-modal-create-channel", msg);
        }
    });
}, true);

function DXT_BuildSave() {
    var m = $("#dx-modal-editchannel");
    if (!m.length || m.find(".dxt-save").length) return;
    m.find(".discord-modal-buttons").before('<div class="dxt-save"><div class="dx-btn" id="dxt-save-tpl"><i class="fas fa-clone"></i> Save this channel as a template</div></div>');
}
$(document).on("click", "#dxt-save-tpl", function() {
    var cid = DXP && DXP.editChannel;
    if (!cid) return;
    DX_Post("DiscordExt_SaveChannelTemplate", { channelId: cid }, function(r) {
        if (r && r.ok) { if (window.DX_Toast) DX_Toast("Saved. You can use it when you create a channel.", "success"); }
        else if (window.DX_Toast) DX_Toast(r && r.error === "LIMIT" ? "You have too many saved templates (10 max)." : "Could not save the template.", "error");
    });
});

// ---------------------------------------------------------------------------
// 22) Featured messages: staff stars a message; everyone sees the star
// ---------------------------------------------------------------------------

function DXF_CanStar() {
    var p = (typeof DX2_Perms === "function" && DX2_Perms()) || {};
    return !!(p.manage_channels || p.manage_messages || p.administrator);
}

(function() {
    var origMenu = window.DXP_MessageMenu;
    if (typeof origMenu !== "function") return;
    window.DXP_MessageMenu = function(row) { DXF.row = row; return origMenu.apply(this, arguments); };
    var origCtx = window.DX2_Ctx;
    if (typeof origCtx !== "function") return;
    window.DX2_Ctx = function(x, y, items) {
        var row = DXF.row;
        DXF.row = null;
        if (row && DXF_CanStar()) {
            var id = parseInt(row.attr("data-messageid"), 10), msg = Discord.messagesById && Discord.messagesById[id];
            if (msg && !msg.isAnnouncement) {
                items = (items || []).concat([{ sep: true }, {
                    label: msg.isFeatured ? "Remove star" : "Star this message", icon: "fa-star",
                    fn: function() { DXF_Toggle(id); }
                }]);
            }
        }
        return origCtx.call(this, x, y, items);
    };
})();

function DXF_Toggle(id) {
    DX_Post("DiscordExt_ToggleFeatured", { messageId: id }, function(r) {
        if (!r || !r.ok) { if (window.DX_Toast) DX_Toast("Could not change the star.", "error"); return; }
        var msg = Discord.messagesById && Discord.messagesById[id];
        if (msg) msg.isFeatured = !!r.featured;
        DXF_Decorate();
    });
}

function DXF_Decorate() {
    $(".dxf-star").remove();
    $("#discord-chat-messages .discord-message[data-messageid]").each(function() {
        var id = parseInt($(this).attr("data-messageid"), 10), msg = Discord.messagesById && Discord.messagesById[id];
        if (msg && msg.isFeatured) {
            var top = $(this).find(".discord-message-top").first();
            if (top.length) top.append('<i class="fas fa-star dxf-star" title="Featured by staff"></i>');
            else $(this).find(".discord-message-text").first().before('<i class="fas fa-star dxf-star" title="Featured by staff"></i>');
        }
    });
}
DX_After("DX_DecorateAll", DXF_Decorate);
