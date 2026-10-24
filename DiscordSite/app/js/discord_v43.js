// ============================================================================
// Discord v43 — the Roles section of server settings lists the roles (colour,
// name, how many permissions each one has, and the role members count when the
// server sends it), like Discord's "Roles" page. Clicking a role opens it.
// ============================================================================

function DXV43_Render(r) {
    var roles = (r && r.roles) || [];
    var rows = roles.filter(function(x) { return !x.isDefault; }).map(function(x) {
        var n = 0; $.each(x.perms || {}, function(k, v) { if (v) n++; });
        var members = (x.memberCount !== undefined) ? x.memberCount : (x.members !== undefined ? x.members : null);
        return '<div class="dxv43-row" data-roleid="' + x.id + '">' +
               '<span class="dxv43-dot" style="background:' + DX_Esc(x.color || "#99aab5") + '"></span>' +
               '<span class="dxv43-name">' + DX_Esc(x.name || "") + "</span>" +
               '<span class="dxv43-meta">' + (members !== null ? members + " members \u2022 " : "") + n + " permissions</span>" +
               '<i class="fas fa-chevron-right dxv43-go"></i></div>';
    }).join("");
    var everyone = roles.filter(function(x) { return x.isDefault; })[0];
    var html = '<div class="dxv43"><div class="dxv43-title">ROLES \u2014 ' + roles.length + "</div>" +
               (everyone ? '<div class="dxv43-row dxv43-default" data-roleid="' + everyone.id + '"><span class="dxv43-dot" style="background:#99aab5"></span><span class="dxv43-name">@everyone</span><span class="dxv43-meta">Default permissions</span><i class="fas fa-chevron-right dxv43-go"></i></div>' : "") +
               (rows || '<div class="dxv43-none">No roles yet.</div>') + "</div>";
    $("#dx-open-roles").closest(".dx-section").find(".dxv43").remove();
    $("#dx-open-roles").closest(".dx-section").append(html);
}

DX_After("DX_OpenTools", function() {
    var tries = 0;
    var t = setInterval(function() {
        tries++;
        if ($("#dx-open-roles").length || tries > 20) {
            clearInterval(t);
            if (!$("#dx-open-roles").length) return;
            DX_Post("DiscordExt_GetRoles", { serverId: Discord.currentServerId }, function(r) { if (r) DXV43_Render(r); });
        }
    }, 100);
});

$(document).on("click", ".dxv43-row", function() {
    var id = parseInt($(this).attr("data-roleid"), 10);
    if (window.DX2) DX2.roleSel = id;
    if (window.DX2_OpenRoles) DX2_OpenRoles();
});
