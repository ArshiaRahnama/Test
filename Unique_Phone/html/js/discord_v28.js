// ============================================================================
// Discord v28 — staff panel "Creators" tab: switch "only creators can create
// servers and channels", the creators list, and grant / revoke by name search.
// Server: main.lua (DiscordStaffActions.Creators / SetCreator / SetCreationRestricted).
// ============================================================================

function DXC_Load() {
    var pane = $("#discord-staffpane-creators");
    pane.html('<div class="discord-staff-empty">Loading\u2026</div>');
    Discord_Staff("Creators", {}, function(r) {
        if (!r) { pane.html('<div class="discord-staff-empty">Could not load.</div>'); return; }
        var rows = (r.creators || []).map(function(c) {
            return '<div class="dxc-row"><div><b>' + DX_Esc(c.name || "Player") + '</b> <span class="dxc-muted">#' + DX_Esc(c.discriminator || "0000") +
                   " \u2022 granted by " + DX_Esc(c.grantedBy || "staff") + '</span></div>' +
                   '<div class="discord-staff-btn dxc-revoke" data-creator="' + DX_Esc(c.identifier) + '">Remove</div></div>';
        }).join("");
        pane.html(
            '<div class="dxc-switch"><label><input type="checkbox" id="dxc-restricted"' + (r.restricted ? " checked" : "") + '> Only creators can create servers and channels</label>' +
            '<div class="dxc-muted">Staff can always create. Turn this off to let everyone create again.</div></div>' +
            '<div class="dxc-section-title">Creators (' + (r.creators || []).length + ')</div>' +
            (rows || '<div class="discord-staff-empty">No creators yet.</div>') +
            '<div class="dxc-section-title">Give access</div>' +
            '<input type="text" class="discord-staff-search" id="dxc-search" placeholder="Search by name or phone number">' +
            '<div id="dxc-results"></div>');
    });
}

$(document).on("change", "#dxc-restricted", function() {
    Discord_Staff("SetCreationRestricted", { on: $(this).is(":checked") }, function(r) {
        if (window.DX_Toast) DX_Toast(r && r.ok ? "Saved." : "Could not save.", r && r.ok ? "success" : "error");
    });
});
$(document).on("click", ".dxc-revoke", function() {
    Discord_Staff("SetCreator", { identifier: $(this).attr("data-creator"), on: false }, function() { DXC_Load(); });
});
var dxcTimer = null;
$(document).on("input", "#dxc-search", function() {
    var q = $(this).val();
    clearTimeout(dxcTimer);
    dxcTimer = setTimeout(function() {
        Discord_Staff("Accounts", { query: q }, function(rows) {
            var list = (rows || []).slice(0, 15);
            $("#dxc-results").html(list.length ? list.map(function(a) {
                return '<div class="dxc-row"><div><b>' + DX_Esc(a.name || a.identifier) + '</b> <span class="dxc-muted">' + DX_Esc(a.identifier) + "</span></div>" +
                       '<div class="discord-staff-btn dxc-grant" data-creator="' + DX_Esc(a.identifier) + '">Grant</div></div>';
            }).join("") : '<div class="discord-staff-empty">No one found.</div>');
        });
    }, 250);
});
$(document).on("click", ".dxc-grant", function() {
    Discord_Staff("SetCreator", { identifier: $(this).attr("data-creator"), on: true }, function() {
        if (window.DX_Toast) DX_Toast("Access granted.", "success");
        DXC_Load();
    });
});

$(function() {
    var tab = $('.discord-staff-tab[data-stafftab="accounts"]');
    if (tab.length && !$('.discord-staff-tab[data-stafftab="creators"]').length) {
        tab.after('<div class="discord-staff-tab" data-stafftab="creators">Creators</div>');
        $("#discord-staffpane-accounts").after('<div class="discord-staff-pane" id="discord-staffpane-creators"></div>');
    }
});
DX_After("Discord_StaffSwitchTab", function(t) { if (t === "creators") DXC_Load(); });
