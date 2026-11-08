// ============================================================================
// Discord v27 — private role channels (Edit Channel modal) and super reactions
// (a second, highlighted reaction per person per message). Loaded last.
// ============================================================================

// (10) Edit Channel: "Private" + the roles allowed to see it
(function() {
    var orig = window.Discord_OpenModal;
    window.Discord_OpenModal = function(id) {
        var r = orig.apply(this, arguments);
        if (id === "dx-modal-editchannel") setTimeout(DXP27_BuildPrivate, 0);
        return r;
    };
})();
function DXP27_BuildPrivate() {
    var m = $("#dx-modal-editchannel");
    if (!m.length || !DXV_CanStaff()) return;
    m.find(".dxp27").remove();
    m.find(".discord-modal-buttons").before('<div class="dxp27"><div class="discord-settings-label">Private channel</div>' +
        '<label class="dxp27-check"><input type="checkbox" id="dxp27-on"> Only the roles below can see this channel</label>' +
        '<div id="dxp27-roles" class="dxp27-roles dxv-muted">Loading roles\u2026</div>' +
        '<div class="dx-row" style="margin-top:8px"><div class="dx-btn dx-primary" id="dxp27-save">Save privacy</div></div></div>');
    DX_Post("DiscordExt_GetRoles", { serverId: Discord.currentServerId }, function(r) {
        var roles = ((r && r.roles) || []).filter(function(x) { return !x.isDefault; });
        var html = roles.map(function(x) { return '<label class="dxp27-check"><input type="checkbox" class="dxp27-role" value="' + x.id + '"> ' + DX_Esc(x.name) + "</label>"; }).join("");
        $("#dxp27-roles").html(html || '<span class="dxv-muted">Create a role first.</span>');
    });
}
$(document).on("click", "#dxp27-save", function() {
    var ids = $(".dxp27-role:checked").map(function() { return parseInt($(this).val(), 10); }).get();
    var on = $("#dxp27-on").is(":checked");
    DX_Post("DiscordExt_SetChannelPrivate", { serverId: Discord.currentServerId, channelId: DXP.editChannel, roleIds: ids, on: on }, function(r) {
        if (r && r.ok) { if (window.DX_Toast) DX_Toast(on ? "Channel is private." : "Channel is public.", "success"); if (window.DX2_ReloadChannels) DX2_ReloadChannels(); }
        else if (window.DX_Toast) DX_Toast("Could not change this channel's privacy.", "error");
    });
});

// (11) super reactions: shown as their own highlighted pills
(function() {
    var orig = window.Discord_RenderReactionsHTML;
    if (typeof orig !== "function") return;
    window.Discord_RenderReactionsHTML = function(reactions) {
        var normal = (reactions || []).filter(function(r) { return !r.super; });
        var supers = (reactions || []).filter(function(r) { return r.super; });
        var html = orig(normal);
        $.each(supers, function(i, r) {
            html += '<span class="discord-reaction-pill dxs-super' + (r.reacted ? " discord-reaction-mine" : "") + '" data-emoji="' + DX_Esc(r.emoji) + '" title="Super reaction">' +
                    '<span class="dxs-spark">\u2728</span>' + DX_Esc(r.emoji) + ' <span>' + r.count + "</span></span>";
        });
        return html;
    };
})();
// clicking a super pill (or shift+clicking the quick reaction) sends one
$(document).on("click", ".dxs-super", function(e) {
    e.stopPropagation();
    var mid = parseInt($(this).closest(".discord-message").attr("data-messageid"), 10);
    DXP27_Super(mid, $(this).attr("data-emoji"));
});
$(document).on("click", "[data-dxquick]", function(e) {
    if (!e.shiftKey) return;
    e.stopImmediatePropagation(); e.stopPropagation();
    var mid = parseInt($(this).closest(".discord-message").attr("data-messageid"), 10);
    DXP27_Super(mid, (typeof DXP !== "undefined" && DXP.recents && DXP.recents[0]) || "\uD83D\uDC4D");
});
function DXP27_Super(mid, emoji) {
    if (!mid || !emoji) return;
    DX_Post("DiscordExt_SuperReact", { messageId: mid, emoji: emoji }, function(r) {
        if (r && r.ok) { if (window.DX_Toast) DX_Toast(r.removed ? "Super reaction removed." : "Super reaction sent!", "info"); if (window.Discord_OpenChannel && Discord.currentChannelId) Discord_OpenChannel(Discord.currentChannelId, (Discord_FindChannel(Discord.currentChannelId) || {}).name); }
        else if (window.DX_Toast) DX_Toast("You can only give one super reaction per message.", "warn");
    });
}
