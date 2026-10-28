// ============================================================================
// Discord v14 — front-end: typing in the member list, channel drag & drop,
// announcement channels + follows, server health, mutual friends, appeals,
// private staff notes. Loaded after discord_login.js. Server: discord_v14.lua.
// ============================================================================

var DXV = { typing: {}, drag: null, editChannel: null, health: null };

function DXV_Perms() { return (typeof DX2_Perms === "function" && DX2_Perms()) || {}; }
function DXV_CanStaff() { var p = DXV_Perms(); return !!(p.manage_channels || p.administrator || p.manage_roles); }
function DXV_Notice(text, kind) { if (window.DX_Toast) DX_Toast(text, kind); }
function DXV_Esc(s) { return (typeof DX_Esc === "function") ? DX_Esc(s) : String(s == null ? "" : s); }

// ---------------------------------------------------------------------------
// 4) "X is typing" next to the person in the member list
// ---------------------------------------------------------------------------

function DXV_ApplyTyping() {
    $(".dxv-typing").remove();
    var now = Date.now();
    $.each(DXV.typing, function(memberId, rec) {
        if (rec.channelId !== Discord.currentChannelId || rec.until < now) return;
        var item = $('#discord-members-list .discord-member-item[data-memberrowid="' + memberId + '"]');
        if (item.length) item.find(".discord-member-text").first().append('<span class="dxv-typing">\u270F\uFE0F typing\u2026</span>');
    });
}

(function() {
    var orig = window.Discord_HandleTyping;
    window.Discord_HandleTyping = function(payload) {
        if (orig) orig.apply(this, arguments);
        if (!payload || payload.memberId == null || payload.channelId !== Discord.currentChannelId) return;
        var key = String(payload.memberId);
        DXV.typing[key] = { channelId: payload.channelId, until: Date.now() + 4000 };
        DXV_ApplyTyping();
        setTimeout(function() { DXV_ApplyTyping(); }, 4100);
    };
})();
DX_After("DX_DecorateAll", DXV_ApplyTyping);

// ---------------------------------------------------------------------------
// 8) Channel order: drag the grip (owners / managers)
// ---------------------------------------------------------------------------

function DXV_AddGrips() {
    $(".dxv-grip").remove();
    if (!DXV_CanStaff()) return;
    $(".discord-channel-item[data-channelid]").each(function() {
        $(this).prepend('<i class="fas fa-grip-vertical dxv-grip" title="Drag to reorder"></i>');
    });
}
DX_After("Discord_RenderChannelList", DXV_AddGrips);
DX_After("DX_ApplyServerLook", DXV_AddGrips);

$(document).on("mousedown", ".dxv-grip", function(e) {
    if (e.which !== 1) return;
    e.preventDefault(); e.stopPropagation();
    var item = $(this).closest(".discord-channel-item");
    DXV.drag = { el: item, startY: e.clientY, moved: false };
    $("body").addClass("dxv-dragging");
});
$(document).on("mousemove", function(e) {
    var d = DXV.drag;
    if (!d) return;
    if (!d.moved && Math.abs(e.clientY - d.startY) < 4) return;
    d.moved = true;
    d.el.addClass("dxv-lifted");
    var list = $(".discord-channel-item[data-channelid]").not(d.el);
    var target = null, before = true;
    list.each(function() {
        var r = this.getBoundingClientRect();
        if (e.clientY < r.top + r.height / 2) { target = $(this); before = true; return false; }
        target = $(this); before = false;
    });
    $(".dxv-drop").removeClass("dxv-drop");
    if (target) target.addClass("dxv-drop").attr("data-dxv-before", before ? "1" : "0");
});
$(document).on("mouseup", function() {
    var d = DXV.drag;
    DXV.drag = null;
    $("body").removeClass("dxv-dragging");
    if (!d) return;
    d.el.removeClass("dxv-lifted");
    if (!d.moved) return;
    var t = $(".dxv-drop");
    $(".dxv-drop").removeClass("dxv-drop");
    if (!t.length) return;
    var before = t.attr("data-dxv-before") === "1";
    if (before) t.before(d.el); else t.after(d.el);
    var ids = $(".discord-channel-item[data-channelid]").map(function() { return parseInt($(this).attr("data-channelid"), 10); }).get();
    DX_Post("DiscordExt_SetChannelOrder", { serverId: Discord.currentServerId, ids: ids }, function(r) {
        if (r && r.ok) { DXV_Notice("Channel order saved.", "success"); if (window.DX2_ReloadChannels) DX2_ReloadChannels(); }
        else DXV_Notice(r && r.error === "NO_PERMISSION" ? "You can't reorder channels here." : "Could not save the order.", "error");
    });
});

// ---------------------------------------------------------------------------
// 11) Announcement channels + follows (Edit Channel modal)
// ---------------------------------------------------------------------------

function DXV_BuildFollowSection() {
    var m = $("#dx-modal-editchannel");
    if (!m.length) return;
    m.find(".dxv-follow").remove();
    var ch = Discord_FindChannel(DXP.editChannel);
    var html = '<div class="dxv-follow"><div class="discord-settings-label">Announcements</div>';
    if (DXV_CanStaff()) {
        html += '<label class="dxv-check"><input type="checkbox" id="dxv-ann-toggle"' + (ch && ch.isAnnouncement ? " checked" : "") + '> Announcement channel: members of other servers can follow it</label>';
    }
    html += '<div id="dxv-follow-list" class="dxv-muted">Loading follows\u2026</div>';
    if (DXV_CanStaff()) {
        html += '<div class="dxv-row"><select id="dxv-follow-pick" class="dx-input"><option value="">Loading announcement channels\u2026</option></select>' +
                '<div class="dx-btn dx-primary" id="dxv-follow-go">Follow</div></div>';
    }
    html += "</div>";
    m.find(".discord-modal-buttons").before(html);
    DX_Post("DiscordExt_GetFollows", { serverId: Discord.currentServerId }, function(list) {
        var mine = (list || []).filter(function(f) { return f.targetChannelId === DXP.editChannel; });
        $("#dxv-follow-list").html(mine.length
            ? mine.map(function(f) { return '<div class="dxv-follow-row">Following <b>' + DXV_Esc(f.sourceName) + "</b> from " + DXV_Esc(f.sourceServer) +
                '<span class="dxv-unfollow" data-target="' + DXP.editChannel + '">Unfollow</span></div>'; }).join("")
            : "Not following any announcement channel.");
    });
    if (DXV_CanStaff()) {
        DX_Post("DiscordExt_GetAnnouncementChannels", {}, function(list) {
            var opts = '<option value="">Choose an announcement channel</option>';
            $.each(list || [], function(i, c) { opts += '<option value="' + c.id + '">' + DXV_Esc(c.serverName) + " \u2014 #" + DXV_Esc(c.name) + "</option>"; });
            $("#dxv-follow-pick").html(opts);
        });
    }
}
(function() {
    var orig = window.Discord_OpenModal;
    window.Discord_OpenModal = function(id) {
        var r = orig.apply(this, arguments);
        if (id === "dx-modal-editchannel") setTimeout(DXV_BuildFollowSection, 0);
        return r;
    };
})();
$(document).on("change", "#dxv-ann-toggle", function() {
    var on = $(this).is(":checked");
    DX_Post("DiscordExt_SetAnnouncementChannel", { channelId: DXP.editChannel, on: on }, function(r) {
        if (r && r.ok) { DXV_Notice(on ? "This channel is now an announcement channel." : "Announcement mode off.", "success"); DX2_ReloadChannels(); }
        else DXV_Notice("Could not change this.", "error");
    });
});
$(document).on("click", "#dxv-follow-go", function() {
    var src = parseInt($("#dxv-follow-pick").val(), 10);
    if (!src) { DXV_Notice("Choose a channel first.", "warn"); return; }
    DX_Post("DiscordExt_FollowChannel", { targetChannelId: DXP.editChannel, sourceChannelId: src }, function(r) {
        if (r && r.ok) { DXV_Notice("Following. New announcements will appear here.", "success"); DXV_BuildFollowSection(); }
        else DXV_Notice({ NOT_ANNOUNCEMENT: "That channel is not an announcement channel.", NOT_PUBLIC: "That server is not public.", SAME_SERVER: "Pick a channel from another server.", NO_PERMISSION: "You can't do this here." }[r && r.error] || "Could not follow.", "error");
    });
});
$(document).on("click", ".dxv-unfollow", function() {
    DX_Post("DiscordExt_UnfollowChannel", { targetChannelId: parseInt($(this).attr("data-target"), 10) }, function() { DXV_BuildFollowSection(); });
});

// ---------------------------------------------------------------------------
// 12) Server health dashboard (owners / managers)
// ---------------------------------------------------------------------------

function DXV_Bars(values, labels, max) {
    var mx = Math.max(1, max || 0, Math.max.apply(null, values.concat([0])));
    var html = '<div class="dxv-bars">';
    $.each(values, function(i, v) {
        html += '<div class="dxv-bar" title="' + DXV_Esc(labels[i]) + ": " + v + '"><span style="height:' + Math.round(v / mx * 100) + '%"></span><em>' + DXV_Esc(labels[i]) + "</em></div>";
    });
    return html + "</div>";
}

function DXV_OpenHealth() {
    if (!DXV_CanStaff()) return;
    Discord_OpenModal("dxv-modal-health");
    $("#dxv-health-body").html('<div class="dxv-muted">Loading\u2026</div>');
    DX_Post("DiscordExt_GetHealth", { serverId: Discord.currentServerId }, function(h) {
        if (!h) { $("#dxv-health-body").html('<div class="dxv-muted">Could not load the health report.</div>'); return; }
        var dayLabels = [], now = new Date();
        for (var d = 6; d >= 0; d--) { var dt = new Date(now.getTime() - d * 86400000); dayLabels.push((dt.getMonth() + 1) + "/" + dt.getDate()); }
        var hourLabels = []; for (var hh = 0; hh < 24; hh++) hourLabels.push(hh % 6 === 0 ? String(hh) : "");
        var maxCh = h.channels.length ? h.channels[0].count : 0;
        var html = '<div class="dxv-stats">' +
            '<div><b>' + h.totalMessages + "</b><span>messages (7 days)</span></div>" +
            '<div><b>' + h.totalMembers + "</b><span>members</span></div>" +
            '<div><b>+' + h.newMembers + "</b><span>new this week</span></div></div>";
        html += '<div class="discord-settings-label">Messages per day</div>' + DXV_Bars(h.days, dayLabels);
        html += '<div class="discord-settings-label">Busiest hours (server time)</div>' + DXV_Bars(h.hours, hourLabels);
        html += '<div class="discord-settings-label">Channels</div>';
        $.each(h.channels, function(i, c) {
            var pct = maxCh ? Math.round(c.count / maxCh * 100) : 0;
            html += '<div class="dxv-chrow"><span>#' + DXV_Esc(c.name) + '</span><div class="dxv-chbar"><i style="width:' + pct + '%"></i></div><b>' + c.count + "</b></div>";
        });
        $("#dxv-health-body").html(html);
    });
}
DX_After("DX_RenderTools", function(info) {
    var body = $("#dx-tools-body");
    if (!info || !body.length || !DXV_CanStaff()) return;
    body.find(".dxv-health-entry").remove();
    body.append('<div class="dx-section dxv-health-entry" data-tab="overview"><h4>Server health</h4><div class="dxv-muted">Messages per day and hour, channel activity and new members (last 7 days).</div>' +
                '<div class="dx-row" style="margin-top:8px"><div class="dx-btn dx-primary" id="dxv-open-health">Open report</div></div></div>');
    if (window.DXS_ApplySettingsTabs) DXS_ApplySettingsTabs();
});
$(document).on("click", "#dxv-open-health", DXV_OpenHealth);

// ---------------------------------------------------------------------------
// 7) Mutual friends on a profile card
// ---------------------------------------------------------------------------

DX_After("Discord_OpenMemberProfile", function(memberId) {
    var tries = 0;
    var t = setInterval(function() {
        tries++;
        var card = $("#discord-modal-profile-view");
        if ((card.length && card.hasClass("discord-modal-active") && card.find("#discord-pv-name").text().trim() !== "") || tries > 15) {
            clearInterval(t);
            card.find(".dxv-mutual").remove();
            var m = (DX.meta[Discord.currentServerId] || {})[String(memberId)];
            if (!m || !m.uid || m.uid === (DXD && DXD.me && DXD.me.uid)) return;
            DX_Post("DiscordExt_GetMutualFriends", { uid: m.uid }, function(r) {
                if (!r || !r.count) return;
                card.find(".discord-profile-body").prepend('<div class="dxv-mutual">\uD83D\uDC65 ' + r.count + " mutual friend" + (r.count === 1 ? "" : "s") + "</div>");
            });
        }
    }, 80);
});

// ---------------------------------------------------------------------------
// 5) Appeals: members appeal a timeout or a warning; staff review them in a tab
// ---------------------------------------------------------------------------

DX_After("Discord_OpenServerMenu", function() {
    if (!$("#dxv-appeal-btn").length) $("#discord-modal-server-menu .discord-modal-buttons").prepend('<div class="discord-modal-btn discord-modal-confirm" id="dxv-appeal-btn">Appeal a punishment</div>');
});
$(document).on("click", "#dxv-appeal-btn", function() { DXV_OpenAppeal(); });

function DXV_OpenAppeal() {
    Discord_OpenModal("dxv-modal-appeal");
    $("#dxv-appeal-body").html('<div class="dxv-muted">Loading\u2026</div>');
    DX_Post("DiscordExt_GetMyPunishments", { serverId: Discord.currentServerId }, function(p) {
        if (!p) { $("#dxv-appeal-body").html('<div class="dxv-muted">Nothing to appeal here.</div>'); return; }
        var pending = (p.pending || []).map(function(x) { return x.kind + ":" + x.ref_id; });
        var html = "";
        if (p.timeoutUntil) {
            var isPend = pending.indexOf("timeout:0") >= 0;
            html += '<div class="dxv-punish"><b>Timeout</b> until ' + new Date(p.timeoutUntil * 1000).toLocaleString() + "" +
                    (isPend ? '<div class="dxv-muted">Appeal sent \u2014 waiting for staff.</div>' : '<div class="dx-btn dx-primary" data-appeal="timeout" data-ref="0">Appeal this timeout</div>') + "</div>";
        }
        $.each(p.warns || [], function(i, w) {
            var isPend = pending.indexOf("warn:" + w.id) >= 0;
            html += '<div class="dxv-punish"><b>Warning #' + (p.warns.length - i) + "</b> \u2014 " + DXV_Esc(w.reason || "No reason given") +
                    (isPend ? '<div class="dxv-muted">Appeal sent \u2014 waiting for staff.</div>' : '<div class="dx-btn dx-primary" data-appeal="warn" data-ref="' + w.id + '">Appeal this warning</div>') + "</div>";
        });
        if (!html) html = '<div class="dxv-muted">You have no timeouts or warnings in this server.</div>';
        $("#dxv-appeal-body").html(html + '<div id="dxv-appeal-form"></div>');
    });
}
$(document).on("click", "[data-appeal]", function() {
    var kind = $(this).attr("data-appeal"), ref = parseInt($(this).attr("data-ref"), 10) || 0;
    $("#dxv-appeal-form").html('<div class="discord-settings-label">Explain why this should be reviewed (10\u2013500 characters)</div>' +
        '<textarea id="dxv-appeal-text" maxlength="500" rows="4" dir="auto"></textarea>' +
        '<div class="dx-row" style="margin-top:8px"><div class="dx-btn dx-primary" id="dxv-appeal-send" data-kind="' + kind + '" data-ref="' + ref + '">Send appeal</div></div>');
});
$(document).on("click", "#dxv-appeal-send", function() {
    var text = ($("#dxv-appeal-text").val() || "").trim();
    if (text.length < 10) { DXV_Notice("Write at least 10 characters.", "warn"); return; }
    DX_Post("DiscordExt_SubmitAppeal", { serverId: Discord.currentServerId, kind: $(this).attr("data-kind"), warnId: parseInt($(this).attr("data-ref"), 10) || 0, text: text }, function(r) {
        if (r && r.ok) { DXV_Notice("Appeal sent. Staff will review it.", "success"); DXV_OpenAppeal(); }
        else DXV_Notice({ ALREADY_PENDING: "You already sent an appeal for this.", TOO_SHORT: "Write at least 10 characters.", NO_PUNISHMENT: "That punishment is no longer active." }[r && r.error] || "Could not send the appeal.", "error");
    });
});

// staff queue: a tab next to Reports
DX_After("Discord_OpenStaffPanel", function() {
    if (!$('.discord-staff-tab[data-stafftab="appeals"]').length && $("#discord-staff-tabs").length) {
        $("#discord-staff-tabs").append('<div class="discord-staff-tab" data-stafftab="appeals">Appeals<span class="dxv-tab-count" id="dxv-appeals-count" style="display:none">0</span></div>');
        $("#discord-staffpane-reports").after('<div class="discord-staff-pane" id="discord-staffpane-appeals"></div>');
    }
});
DX_After("Discord_StaffSwitchTab", function(tab) { if (tab === "appeals") DXV_LoadAppeals(); });
function DXV_LoadAppeals() {
    var pane = $("#discord-staffpane-appeals");
    pane.html('<div class="discord-staff-empty">Loading\u2026</div>');
    DX_Post("DiscordExt_GetAppeals", { serverId: Discord.currentServerId }, function(list) {
        if (!list) { pane.html('<div class="discord-staff-empty">You can\'t review appeals here.</div>'); return; }
        $("#dxv-appeals-count").text(list.length).toggle(list.length > 0);
        if (!list.length) { pane.html('<div class="discord-staff-empty">No open appeals.</div>'); return; }
        pane.html(list.map(function(a) {
            return '<div class="dxv-appeal" data-id="' + a.id + '"><div class="dxv-muted">' + DXV_Esc(a.name) + " \u2022 " + (a.kind === "timeout" ? "timeout" : "warning") + " \u2022 " + new Date(a.createdAt * 1000).toLocaleString() + "</div>" +
                   (a.reason ? '<div class="dxv-muted">Reason: ' + DXV_Esc(a.reason) + "</div>" : "") +
                   '<div class="dxv-appeal-text">' + DXV_Esc(a.text) + '</div><div class="dx-row"><div class="dx-btn dx-primary" data-appeal-do="1" data-accept="1">Accept &amp; lift</div><div class="dx-btn dx-danger" data-appeal-do="1" data-accept="0">Decline</div></div></div>';
        }).join(""));
    });
}
$(document).on("click", "[data-appeal-do]", function() {
    var id = parseInt($(this).closest(".dxv-appeal").attr("data-id"), 10), accept = $(this).attr("data-accept") === "1";
    DX_Post("DiscordExt_ResolveAppeal", { appealId: id, accept: accept }, function(ok) {
        if (ok) { DXV_Notice(accept ? "Appeal accepted." : "Appeal declined.", "success"); DXV_LoadAppeals(); }
        else DXV_Notice("Could not update this appeal.", "error");
    });
});

// ---------------------------------------------------------------------------
// 22) Private staff notes (inside the moderation popup; staff only)
// ---------------------------------------------------------------------------

DX_After("DX_LoadMod", function() {
    if (!DXV_CanStaff() || !DX.modTargetId) return;
    $("#dx-mod-body .dxv-notes").remove();
    $("#dx-mod-body").append('<div class="dx-section dxv-notes"><h4>Staff notes <span class="dxv-private"><i class="fas fa-lock"></i> private</span></h4><div id="dxv-notes-list" class="dxv-muted">Loading\u2026</div>' +
        '<div class="dxv-row" style="margin-top:8px"><input type="text" class="dx-input" id="dxv-note-text" maxlength="500" placeholder="Write a note only staff can see" dir="auto"><div class="dx-btn dx-primary" id="dxv-note-add">Add</div></div></div>');
    DXV_LoadNotes();
});
function DXV_LoadNotes() {
    DX_Post("DiscordExt_GetStaffNotes", { serverId: Discord.currentServerId, memberId: DX.modTargetId }, function(list) {
        if (!list) { $(".dxv-notes").remove(); return; }
        $("#dxv-notes-list").html(list.length ? list.map(function(n) {
            return '<div class="dxv-note"><div class="dxv-muted">' + DXV_Esc(n.author) + " \u2022 " + new Date(n.createdAt * 1000).toLocaleString() + "</div><div>" + DXV_Esc(n.text) + "</div>" +
                   (n.mine ? '<span class="dxv-note-del" data-note="' + n.id + '">Delete</span>' : "") + "</div>";
        }).join("") : "No notes yet.");
    });
}
$(document).on("click", "#dxv-note-add", function() {
    var text = ($("#dxv-note-text").val() || "").trim();
    if (text.length < 2) return;
    DX_Post("DiscordExt_AddStaffNote", { serverId: Discord.currentServerId, memberId: DX.modTargetId, text: text }, function(r) {
        if (r && r.ok) { $("#dxv-note-text").val(""); DXV_LoadNotes(); } else DXV_Notice("Could not save the note.", "error");
    });
});
$(document).on("click", ".dxv-note-del", function() {
    DX_Post("DiscordExt_DeleteStaffNote", { noteId: parseInt($(this).attr("data-note"), 10) }, function() { DXV_LoadNotes(); });
});

$(function() {
    // the health and appeal dialogs live in the same overlay as the other modals
    $("#discord-modal-overlay").append(
        '<div class="discord-modal dx-modal-wide" id="dxv-modal-health"><div class="discord-modal-title">Server health</div><div id="dxv-health-body"></div>' +
        '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Close</div></div></div>' +
        '<div class="discord-modal dx-modal-wide" id="dxv-modal-appeal"><div class="discord-modal-title">Appeal a punishment</div><div id="dxv-appeal-body"></div>' +
        '<div class="discord-modal-buttons"><div class="discord-modal-btn discord-modal-cancel" data-discordmodalclose="1">Close</div></div></div>');
});
