// ============================================================================
// Discord v32 — Friends page like Discord: the "Active Now" panel on the right,
// Discord's empty-state wording, and the green "Add Friend" button. Loaded last.
// ============================================================================

DX_After("DXD_RenderFriends", function() {
    var page = $("#dx-friends-page");
    if (!page.length) return;

    // empty state wording as in Discord
    page.find(".dx-fempty p").text("There are no friends online at this time. Check back later!");

    // right-hand "Active Now" panel
    if (!page.find("#dx-active-now").length) {
        page.append('<div id="dx-active-now"><div class="dxa-title">Active Now</div><div id="dxa-list"></div></div>');
    }
    var s = (window.DXD && DXD.social) || {};
    var active = (s.friends || []).filter(function(u) { return u.status !== "offline" && (u.activity || u.platform === "web"); });
    var html = "";
    if (!active.length) {
        html = '<div class="dxa-quiet"><div class="dxa-q1">It\'s quiet for now...</div>' +
               '<div class="dxa-q2">When a friend starts an activity — like playing a game or hanging out on voice — we\'ll show it here!</div></div>';
    } else {
        $.each(active, function(i, u) {
            html += '<div class="dxa-card"><div class="dxa-av">' + DX_Esc((u.name || "?").charAt(0).toUpperCase()) + '</div>' +
                    '<div class="dxa-txt"><div class="dxa-name">' + DX_Esc(u.name || "") + '</div>' +
                    '<div class="dxa-act">' + DX_Esc(u.activity || "Online") + "</div></div></div>";
        });
    }
    page.find("#dxa-list").html(html);
});
