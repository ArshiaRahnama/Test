// ============================================================================
// Discord v26 — message requests UI: the inbox row in the DM sidebar, the
// Accept / Decline bar in a request, and "Message request" on a profile card
// of someone who shares a server with you. Server: discord_v26.lua. Loaded last.
// ============================================================================

var DXR = { list: [], count: 0, dmId: null, state: null, byMe: false };

function DXR_Load() {
    DX_Post("DiscordExt_GetMessageRequests", {}, function(list) {
        DXR.list = (list && list.length !== undefined) ? list : [];
        DXR.count = DXR.list.length;
        DXR_RenderInbox();
    });
}
function DXR_RenderInbox() {
    $("#dxr-inbox").remove();
    if (!DXR.count) return;
    $("#dx-dm-list").before('<div class="dxr-inbox" id="dxr-inbox"><i class="fas fa-inbox"></i><span>Message requests</span><em class="dxr-count">' + DXR.count + "</em></div>");
}
DX_After("DXD_LoadSocial", DXR_Load);
DX_After("DXD_RenderDmList", DXR_RenderInbox);
$(document).on("click", "#dxr-inbox", function() {
    if (window.Discord_OpenModal) Discord_OpenModal("dxr-modal");
    var body = $("#dxr-body");
    if (!DXR.list.length) { body.html('<div class="dxr-muted">No message requests.</div>'); return; }
    body.html(DXR.list.map(function(r) {
        return '<div class="dxr-req"><div class="dxr-av" style="background:' + DX_Esc(r.user && r.user.avatar ? "#5865f2" : "#5865f2") + '">' + DX_Esc(Discord_Initials(r.user.name)) + "</div>" +
               '<div class="dxr-text"><b>' + DX_Esc(r.user.name) + '</b><div class="dxr-muted">' + DX_Esc(r.lastMessage) + '</div></div>' +
               '<div class="dx-btn dx-primary" data-req-accept="' + r.dmId + '">Accept</div><div class="dx-btn dx-danger" data-req-decline="' + r.dmId + '">Decline</div></div>';
    }).join(""));
});
$(document).on("click", "[data-req-accept]", function() {
    DXR_Act("DiscordExt_AcceptRequest", parseInt($(this).attr("data-req-accept"), 10), "Request accepted.");
});
$(document).on("click", "[data-req-decline]", function() {
    DXR_Act("DiscordExt_DeclineRequest", parseInt($(this).attr("data-req-decline"), 10), "Request declined.");
});
function DXR_Act(ep, dmId, okText) {
    DX_Post(ep, { dmId: dmId }, function(r) {
        if (r && r.ok) {
            if (window.DX_Toast) DX_Toast(okText, "success");
            if (window.Discord_CloseModals) Discord_CloseModals();
            DXR_Load();
            if (window.DXD_LoadSocial) DXD_LoadSocial();
        } else if (window.DX_Toast) DX_Toast("That didn't work.", "error");
    });
}

// the request bar and composer state, read from the history reply
(function() {
    var orig = window.DX_Post;
    if (typeof orig !== "function") return;
    window.DX_Post = function(endpoint, data, cb) {
        if (endpoint === "DiscordExt_GetDMMessages") {
            var wrapped = function(r) {
                if (r && typeof r === "object") { DXR.state = r.requestState || null; DXR.byMe = !!r.requestedByMe; DXR.dmId = data && data.dmId; }
                if (cb) cb(r);
                setTimeout(DXR_ApplyBar, 60);
            };
            return orig.call(this, endpoint, data, wrapped);
        }
        return orig.apply(this, arguments);
    };
})();
function DXR_ApplyBar() {
    $("#dxr-bar").remove();
    if (!DXD || DXD.mode !== "dm" || DXR.dmId !== DXD.dmId || DXR.state !== "pending") return;
    if (DXR.byMe) {
        $(".discord-chat-input-row").before('<div id="dxr-bar" class="dxr-bar">Waiting for them to accept. You can send up to 3 messages until then.</div>');
        return;
    }
    $(".discord-chat-input-row").before('<div id="dxr-bar" class="dxr-bar"><span>' + DX_Esc((DXD.dmUser && DXD.dmUser.name) || "They") + ' wants to message you.</span>' +
        '<div class="dx-btn dx-primary" id="dxr-acc">Accept</div><div class="dx-btn dx-danger" id="dxr-dec">Decline</div></div>');
    $("#discord-message-input").prop("disabled", true).attr("placeholder", "Accept the request to reply.");
}
$(document).on("click", "#dxr-acc", function() { DXR_Act("DiscordExt_AcceptRequest", DXR.dmId, "Request accepted."); DXD_OpenDmByUid(DXD.dmUser.uid); });
$(document).on("click", "#dxr-dec", function() { DXR_Act("DiscordExt_DeclineRequest", DXR.dmId, "Request declined."); DXD_EnterHome("dm"); });

// profile card: a request button for someone who is not your friend yet
DX_After("Discord_OpenMemberProfile", function(memberId) {
    var tries = 0;
    var t = setInterval(function() {
        tries++;
        var card = $("#discord-modal-profile-view");
        if ((card.length && card.hasClass("discord-modal-active") && card.find("#discord-pv-name").text().trim() !== "") || tries > 15) {
            clearInterval(t);
            card.find(".dxr-profile-btn").remove();
            var m = (DX.meta[Discord.currentServerId] || {})[String(memberId)];
            if (!m || !m.uid || (DXD && DXD.me && m.uid === DXD.me.uid)) return;
            if (DXD_RelationOf(m.uid) !== "none") return;
            card.find(".discord-profile-body").append('<div class="dx-btn dxr-profile-btn" data-reqdm="' + m.uid + '"><i class="fas fa-paper-plane"></i> Message request</div>');
        }
    }, 80);
});
$(document).on("click", "[data-reqdm]", function() {
    var uid = parseInt($(this).attr("data-reqdm"), 10);
    if (window.Discord_CloseModals) Discord_CloseModals();
    DXD_OpenDmByUid(uid);
});

$(function() {
    $("#discord-modal-overlay").append('<div class="discord-modal dx-modal-wide" id="dxr-modal"><div class="discord-modal-title">Message requests</div><div id="dxr-body"></div>' +
        '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Close</div></div></div>');
});
