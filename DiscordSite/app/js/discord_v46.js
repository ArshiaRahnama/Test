// ============================================================================
// Discord v46 — Notification Settings for a server (like Discord's server menu item):
//   * All Messages / Only @mentions / Nothing
//   * Suppress @everyone and @here
//   * Mute Server (the same mute the rest of the app uses)
// The choice is kept on this device. It decides whether a new message in that
// server plays a sound and shows a banner (unread counters still count).
// ============================================================================

function DXN46_Get(sid) {
    var level = "all", noEveryone = false;
    try { level = localStorage.getItem("dxn46_level_" + sid) || "all"; noEveryone = localStorage.getItem("dxn46_noevery_" + sid) === "1"; } catch (e) {}
    return { level: level, noEveryone: noEveryone };
}

// a mention of YOU by name or ID, not counting @everyone / @here
function DXN46_Direct(text) {
    var t = text || "", names = [];
    if (Discord.myName && Discord.myName !== "You") names.push(String(Discord.myName).split(/\s+/)[0]);
    if (Discord.myHandle) names.push(String(Discord.myHandle));
    return names.some(function(n) {
        var re = new RegExp("@" + n.replace(/[.*+?^${}()|[\]\\]/g, "\\$&") + "(?![\\w.])", "i");
        return re.test(t);
    });
}

// true = stay quiet for this message
window.DXN_Silenced = function(payload, mention) {
    var sid = payload && payload.serverId;
    if (!sid) return false;
    if (window.DX2_SvMuted && DX2_SvMuted(sid)) return true;
    var st = DXN46_Get(sid);
    var direct = DXN46_Direct(payload.message);
    var counts = st.noEveryone ? direct : !!mention;
    if (st.level === "none") return true;
    if (st.level === "mentions") return !counts;
    return false;            // all messages
};

function DXN46_Build() {
    var ov = $("#discord-modal-overlay");
    if (!ov.length || $("#dxn46-modal").length) return;
    ov.append(
        '<div class="discord-modal" id="dxn46-modal"><div class="discord-modal-title">Notification Settings</div>' +
        '<div class="dxn46-server" id="dxn46-server"></div>' +
        '<div class="discord-settings-label">SERVER NOTIFICATION SETTINGS</div>' +
        '<div class="dxn46-opt" data-level="all"><span class="dxn46-radio"></span>All Messages</div>' +
        '<div class="dxn46-opt" data-level="mentions"><span class="dxn46-radio"></span>Only @mentions</div>' +
        '<div class="dxn46-opt" data-level="none"><span class="dxn46-radio"></span>Nothing</div>' +
        '<div class="dxn46-sep"></div>' +
        '<div class="dxn46-row" id="dxn46-noevery"><span>Suppress @everyone and @here</span><span class="dxn46-sw"></span></div>' +
        '<div class="dxn46-row" id="dxn46-mute"><span>Mute Server</span><span class="dxn46-sw"></span></div>' +
        '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-confirm" data-discordmodalclose="1">Done</div></div></div>');
}
$(function() { setTimeout(DXN46_Build, 80); });

function DXN46_Render() {
    var sid = Discord.currentServerId, st = DXN46_Get(sid);
    var sv = (Discord.servers || []).filter(function(s) { return s.id === sid; })[0];
    $("#dxn46-server").text(sv ? sv.name : "");
    $("#dxn46-modal .dxn46-opt").each(function() { $(this).toggleClass("dxn46-on", $(this).attr("data-level") === st.level); });
    $("#dxn46-noevery").toggleClass("dxn46-on", st.noEveryone);
    $("#dxn46-mute").toggleClass("dxn46-on", !!(window.DX2_SvMuted && DX2_SvMuted(sid)));
}
function DXN46_Open() { DXN46_Build(); DXN46_Render(); Discord_OpenModal("dxn46-modal"); }

$(document).on("click", "#dxn46-modal .dxn46-opt", function() {
    try { localStorage.setItem("dxn46_level_" + Discord.currentServerId, $(this).attr("data-level")); } catch (e) {}
    DXN46_Render();
});
$(document).on("click", "#dxn46-noevery", function() {
    var sid = Discord.currentServerId, on = !DXN46_Get(sid).noEveryone;
    try { localStorage.setItem("dxn46_noevery_" + sid, on ? "1" : "0"); } catch (e) {}
    DXN46_Render();
});
$(document).on("click", "#dxn46-mute", function() {
    var sid = Discord.currentServerId;
    if (window.DX2_SetMute) DX2_SetMute("server", sid, !DX2_SvMuted(sid));
    DXN46_Render();
});

// the server dropdown (v42) opens this
$(document).on("click", ".dxm42-item[data-act='notify']", function() {
    if (window.Discord_CloseModals) Discord_CloseModals();
    DXN46_Open();
});
