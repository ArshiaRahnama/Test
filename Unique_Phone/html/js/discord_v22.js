// ============================================================================
// Discord v22 — server tags (Discover) and role icons. Loaded last.
// Server: discord_v22.lua.
// ============================================================================

// tags are saved from the Discover section (the tags box is added there)
$(document).on("click", "#dxd-set-save", function() {
    var raw = $("#dxd-set-tags").val() || "";
    DX_Post("DiscordExt_SetServerTags", { serverId: Discord.currentServerId, tags: raw }, function(r) {
        if (r && r.ok) { if (window.DX_Toast) DX_Toast("Tags saved.", "success"); }
        else if (window.DX_Toast) DX_Toast({ BAD_TAG: "Use only the tags from the list.", TOO_MANY: "Up to 4 tags." }[r && r.error] || "Could not save the tags.", "error");
    });
});

// role icon: a small field under the role editor
DX_After("DX2_RenderRoles", function() {
    var box = $("#dx-roles-body");
    if (!box.length || !DX2.roleSel) return;
    box.find(".dxv-icon-row").remove();
    box.find(".dx-roles-right").append('<div class="dxv-icon-row"><div class="discord-settings-label">Role icon (one emoji, empty to remove)</div>' +
        '<div class="dxv-icon-line"><input type="text" id="dxv-icon-input" maxlength="8" placeholder="\uD83D\uDEE1\uFE0F" dir="ltr">' +
        '<div class="dx-btn dx-primary" id="dxv-icon-save">Save icon</div></div></div>');
});
$(document).on("click", "#dxv-icon-save", function() {
    DX_Post("DiscordExt_SetRoleIcon", { serverId: Discord.currentServerId, roleId: DX2.roleSel, icon: ($("#dxv-icon-input").val() || "").trim() }, function(r) {
        if (r && r.ok) { if (window.DX_Toast) DX_Toast("Role icon saved.", "success"); }
        else if (window.DX_Toast) DX_Toast(r && r.error === "BAD_ICON" ? "That is not a single emoji." : "Could not save the icon.", "error");
    });
});

// member profile: a role's icon in front of its name
DX_After("Discord_OpenMemberProfile", function(memberId) {
    var tries = 0;
    var t = setInterval(function() {
        tries++;
        var card = $("#discord-modal-profile-view");
        if ((card.length && card.hasClass("discord-modal-active") && card.find("#discord-pv-name").text().trim() !== "") || tries > 15) {
            clearInterval(t);
            var m = (DX.meta[Discord.currentServerId] || {})[String(memberId)] || {};
            var byName = {};
            $.each(m.roles || [], function(i, r) { if (r.icon) byName[r.name] = r.icon; });
            card.find(".dx-role-pill").each(function() {
                var name = $(this).text().trim();
                if (byName[name]) $(this).find("i").replaceWith('<span class="dxv-role-icon">' + DX_Esc(byName[name]) + "</span>");
            });
        }
    }, 80);
});
