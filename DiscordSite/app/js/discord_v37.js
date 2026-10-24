// ============================================================================
// Discord v37 — the chosen ID everywhere:
//  * a message that says @<your ID> notifies you (like @name)
//  * the member list shows @ID under each name
//  * the own profile knows its ID (Discord.myHandle)
// Server: discord_ext4 (handle in GetMyDiscord), discord_v20 (from:<ID> search).
// ============================================================================

DX_Post("DiscordExt_GetMyDiscord", {}, function(r) {
    Discord.myHandle = (r && r.handle) || null;
});

// notifications: @everyone / @here, @<first name> and @<ID> — each must be a whole word
window.Discord_MentionsMe = function(rawText) {
    var t = rawText || "";
    if (/@(everyone|here)\b/i.test(t)) return true;
    var names = [];
    if (Discord.myName && Discord.myName !== "You") names.push(String(Discord.myName).split(/\s+/)[0]);
    if (Discord.myHandle) names.push(String(Discord.myHandle));
    return names.some(function(n) {
        var re = new RegExp("@" + n.replace(/[.*+?^${}()|[\]\\]/g, "\\$&") + "(?![\\w.])", "i");
        return re.test(t);
    });
};

// member list: the ID under each name
function DXV37_Handles() {
    $(".discord-member-item").each(function() {
        var id = $(this).attr("data-memberrowid");
        var m = (DX.meta[Discord.currentServerId] || {})[String(id)] || {};
        var t = $(this).find(".discord-member-text");
        t.find(".dxv37-handle").remove();
        if (m.handle) t.append('<span class="dxv37-handle">@' + DX_Esc(m.handle) + "</span>");
    });
}
// the list is filled after a server call, so add the IDs right after it is drawn
DX_After("Discord_LoadMembersSidebar", function() {
    setTimeout(DXV37_Handles, 250);
    setTimeout(DXV37_Handles, 900);
});
