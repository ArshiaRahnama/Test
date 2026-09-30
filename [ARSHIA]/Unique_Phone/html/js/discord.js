// ============================================================================
// Discord — full-screen desktop-style UI (see index.html's .discord-backdrop,
// a body-level sibling of .container). Opened via client/main.lua's
// OpenExternalDiscord NUI callback the same way Bank opens new_banking's UI:
// the phone closes itself, then this shows. Talks to the same
// "Unique_Phone:server:Discord:*" server callbacks/events the rest of the
// phone already uses (see client/main.lua and server/main.lua).
//
// NOTE: the message dispatch ("Discord_Open", "DiscordNewMessage", etc.)
// lives in js/app.js's single central `window.addEventListener('message', ...)`
// switch, not here — keeping exactly one listener avoids double-handling the
// same SendNUIMessage.
// ============================================================================

var Discord = {
    servers: [],
    channels: [],
    currentServerId: null,
    currentChannelId: null,
    currentServerIsOwner: false,
    currentServerIsAdmin: false,
    myProfile: null,
    isStaff: false,
    profileDraft: { status: "online", bannerColor: "#5865F2" },
    replyingToMessageId: null,
    typingUsers: {}, // name -> timeout handle, for the "X is typing..." line
    lastTypingSentAt: 0,
    lastMessageAuthor: null,
    myName: "You",

    // in-memory registry of every message currently rendered in the open
    // channel, keyed by id — lets edits/pins/reactions patch just that one
    // message's DOM node instead of reloading the whole list.
    messagesById: {},
    pendingSentMessages: [], // FIFO queue of {node} for optimistic sends awaiting a real id from the server

    emojiPickerMode: null,       // "compose" | "react"
    emojiPickerTargetMessageId: null,

    iconPalette: ["#5865F2", "#EB459E", "#ED4245", "#FAA61A", "#57F287", "#3BA55D", "#00AFF4"],
    reactionEmojis: ["👍", "❤️", "😂", "😮", "😢", "🔥", "🎉", "👀"], // must match server's DiscordAllowedEmoji
    composeEmojis: ["😀","😂","😅","😊","😍","😘","😜","🤔","😎","😴","😢","😭","😡","👍","👎","👏","🙏","💪","🔥","🎉","❤️","💯","👀","🤝","🙌","😱","🥳","😇","🤗","👋"],
};

function Discord_Escape(str) {
    return $('<div>').text(str == null ? "" : String(str)).html();
}

function Discord_FormatTime(unixSeconds) {
    var d = new Date(unixSeconds * 1000);
    var h = d.getHours().toString().padStart(2, "0");
    var m = d.getMinutes().toString().padStart(2, "0");
    return h + ":" + m;
}

function Discord_Initials(name) {
    var parts = (name || "").trim().split(/\s+/).filter(Boolean);
    if (parts.length >= 2) return (parts[0][0] + parts[1][0]).toUpperCase();
    if (parts.length == 1) return parts[0].substring(0, 2).toUpperCase();
    return "?";
}

var DiscordAvatarPalette = ["#5865F2", "#EB459E", "#ED4245", "#FAA61A", "#57F287", "#3BA55D", "#00AFF4"];
function Discord_ColorFor(name) {
    var hash = 0;
    for (var i = 0; i < (name || "").length; i++) hash = (hash * 31 + name.charCodeAt(i)) >>> 0;
    return DiscordAvatarPalette[hash % DiscordAvatarPalette.length];
}

function Discord_Post(endpoint, data, cb) {
    $.post('http://Unique_Phone/' + endpoint, JSON.stringify(data || {}), cb);
}

function Discord_VerifiedBadge(flag) {
    return flag ? ' <i class="fas fa-check-circle discord-verified-badge" title="Verified"></i>' : '';
}

function Discord_SetServerHeader(server) {
    $("#discord-current-server-name").html(Discord_Escape(server.name) + Discord_VerifiedBadge(server.isVerified));
}

function Discord_FindChannel(channelId) {
    var found = null;
    $.each(Discord.channels, function(i, c) { if (c.id === channelId) found = c; });
    return found;
}

// Locked channels are read-only unless you own/admin the server or are staff.
function Discord_UpdateComposerLock() {
    var ch = Discord_FindChannel(Discord.currentChannelId);
    var locked = !!(ch && ch.isLocked) && !(Discord.currentServerIsOwner || Discord.currentServerIsAdmin || Discord.isStaff);
    $(".discord-chat-input-row").toggleClass("discord-composer-locked", locked);
    $("#discord-message-input").prop("disabled", locked);
    if (locked) $("#discord-message-input").attr("placeholder", "This channel is locked");
    else if (ch) $("#discord-message-input").attr("placeholder", "Message #" + ch.name);
}

var DiscordAudioCtx = null;
function Discord_PlayNotificationSound() {
    try {
        DiscordAudioCtx = DiscordAudioCtx || new (window.AudioContext || window.webkitAudioContext)();
        var ctx = DiscordAudioCtx;
        var osc = ctx.createOscillator();
        var gain = ctx.createGain();
        osc.type = "sine";
        osc.frequency.setValueAtTime(740, ctx.currentTime);
        osc.frequency.setValueAtTime(950, ctx.currentTime + 0.08);
        gain.gain.setValueAtTime(0.08, ctx.currentTime);
        gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 0.25);
        osc.connect(gain);
        gain.connect(ctx.destination);
        osc.start();
        osc.stop(ctx.currentTime + 0.25);
    } catch (e) { /* audio not available — silently skip */ }
}

// ---------------------------------------------------------------------------
// Open / close
// ---------------------------------------------------------------------------

function Discord_Init(myName) {
    Discord.myName = myName || "You";
    $("#discord-my-name").text(Discord.myName);
    $("#discord-my-avatar").css("background-color", Discord_ColorFor(Discord.myName)).text(Discord_Initials(Discord.myName));

    $("#discord-backdrop").addClass("discord-visible");
    Discord_CloseModals();
    Discord_CloseEmojiPicker();
    Discord_ResetChatColumn();

    $("#discord-banned-screen").removeClass("discord-visible");

    // Profile first: it tells us if this account is banned (then nothing else
    // loads) and gives the server-side display name + staff status.
    Discord_Post('GetDiscordMyProfile', {}, function(profile) {
        if (profile && profile.banned) { Discord_ShowBanned(profile); return; }
        if (profile) Discord_ApplyMyProfile(profile);

        Discord_Post('GetDiscordAccountStatus', {}, function(status) {
            if (!status || !status.loggedIn) { Discord_ShowLoginScreen(status); return; }
            $("#discord-login-screen").removeClass("discord-visible");
            Discord_LoadServers();
        });
    });
}

// ---------------------------------------------------------------------------
// Discord account — mailbox + code login (arshiahub.ir/mail), required the
// first time someone opens Discord and again after logging out.
// ---------------------------------------------------------------------------

function Discord_ShowLoginScreen(status) {
    var siteUrl = (status && status.siteUrl) || "arshiahub.ir/mail";
    var siteLabel = siteUrl.replace(/^https?:\/\//, "");
    $("#discord-login-site-link, #discord-login-site-link-2").text(siteLabel);

    var hasAccount = status && status.hasAccount;
    $("#discord-login-title").text(hasAccount ? "Log back in to Discord" : "Create your Discord account");
    $("#discord-login-mailbox-input").val(hasAccount && status.mailbox ? status.mailbox : "");

    clearInterval(DiscordResendCooldownTimer);
    $("#discord-login-resend-btn").removeClass("discord-secondary-disabled").text("Resend code");
    $("#discord-login-step-code").hide();
    $("#discord-login-step-mailbox").show();
    $("#discord-login-mailbox-error, #discord-login-code-error").removeClass("discord-error-visible").text("");
    $("#discord-login-screen").addClass("discord-visible");
}

function Discord_LoginError(step, text) {
    $("#discord-login-" + step + "-error").text(text).addClass("discord-error-visible");
    $(".discord-login-box").addClass("discord-shake");
    setTimeout(function() { $(".discord-login-box").removeClass("discord-shake"); }, 400);
}

function Discord_SetBtnLoading(btnId, loading, label) {
    var btn = $(btnId);
    if (loading) { btn.data('label', btn.text()).text(label || "...").addClass("discord-btn-loading"); }
    else { btn.text(btn.data('label') || btn.text()).removeClass("discord-btn-loading"); }
}

var DiscordResendCooldownTimer = null;
function Discord_StartResendCooldown(seconds) {
    var btn = $("#discord-login-resend-btn");
    btn.addClass("discord-secondary-disabled");
    clearInterval(DiscordResendCooldownTimer);

    var remaining = seconds;
    var tick = function() {
        if (remaining <= 0) {
            clearInterval(DiscordResendCooldownTimer);
            btn.removeClass("discord-secondary-disabled").text("Resend code");
        } else {
            btn.text("Resend code (" + remaining + "s)");
            remaining--;
        }
    };
    tick();
    DiscordResendCooldownTimer = setInterval(tick, 1000);
}

function Discord_RequestLoginCode() {
    var mailbox = $("#discord-login-mailbox-input").val().trim();
    $("#discord-login-mailbox-error").removeClass("discord-error-visible").text("");

    if (mailbox === "") { Discord_LoginError("mailbox", "Enter a mailbox name."); return; }

    Discord_SetBtnLoading("#discord-login-send-code-btn", true, "Sending...");

    Discord_Post('RequestDiscordLoginCode', { mailbox: mailbox }, function(result) {
        Discord_SetBtnLoading("#discord-login-send-code-btn", false);

        if (!result || result.error) {
            var messages = {
                INVALID_MAILBOX: "That mailbox name isn't valid (letters, numbers, . _ - only).",
                COOLDOWN: "Please wait " + ((result && result.retryIn) || 60) + "s before requesting another code.",
                MAILBOX_TAKEN: "That mailbox is already linked to another account.",
                MAIL_SEND_FAILED: "Couldn't send the code right now — try again shortly.",
            };
            Discord_LoginError("mailbox", (result && messages[result.error]) || "Something went wrong.");
            return;
        }

        $("#discord-login-code-mailbox").text(mailbox);
        $("#discord-login-step-mailbox").hide();
        $("#discord-login-step-code").show();
        $("#discord-login-code-input").val("").focus();
        Discord_StartResendCooldown(60);
    });
}

function Discord_ResendLoginCode() {
    if ($("#discord-login-resend-btn").hasClass("discord-secondary-disabled")) return;
    var mailbox = $("#discord-login-code-mailbox").text();
    if (!mailbox) return;

    Discord_Post('RequestDiscordLoginCode', { mailbox: mailbox }, function(result) {
        if (!result || result.error) {
            Discord_LoginError("code", "Couldn'''t resend — try again in a moment.");
            return;
        }
        Discord_StartResendCooldown(60);
    });
}

function Discord_VerifyLoginCode() {
    var code = $("#discord-login-code-input").val().trim();
    $("#discord-login-code-error").removeClass("discord-error-visible").text("");

    if (code === "") { Discord_LoginError("code", "Enter the code."); return; }

    Discord_SetBtnLoading("#discord-login-verify-btn", true, "Verifying...");

    Discord_Post('VerifyDiscordLoginCode', { code: code }, function(result) {
        Discord_SetBtnLoading("#discord-login-verify-btn", false);

        if (!result || result.error) {
            var messages = {
                NO_PENDING_CODE: "Request a new code first.",
                CODE_EXPIRED: "That code expired — request a new one.",
                TOO_MANY_ATTEMPTS: "Too many wrong attempts — request a new code.",
                WRONG_CODE: "Wrong code" + (result && result.attemptsLeft != null ? " (" + result.attemptsLeft + " attempts left)" : "") + ".",
            };
            Discord_LoginError("code", (result && messages[result.error]) || "Something went wrong.");
            $("#discord-login-code-input").val("").focus();
            return;
        }

        clearInterval(DiscordResendCooldownTimer);
        $("#discord-login-screen").removeClass("discord-visible");
        Discord_LoadServers();
    });
}

function Discord_LogoutAccount() {
    Discord_Post('LogoutDiscordAccount', {}, function(result) {
        if (!result) return;
        Discord_CloseModals();
        Discord_ResetChatColumn();
        Discord.servers = [];
        Discord_RenderServerRail();
        Discord_ShowLoginScreen({ hasAccount: true, siteUrl: (Discord.myProfile && Discord.myProfile.siteUrl) });
    });
}


function Discord_LoadServers() {
    Discord_Post('GetDiscordServers', {}, function(servers) {
        Discord.servers = servers || [];

        if (Discord.servers.length > 0) {
            Discord_SelectServer(Discord.servers[0].id);
        } else {
            Discord.currentServerId = null;
            Discord.channels = [];
            $("#discord-current-server-name").text("Discord");
            $("#discord-channel-list").empty();
            $("#discord-add-channel-btn").hide();
            Discord_ShowChatColumnState("empty");
        }

        Discord_RenderServerRail();
    });
}

function Discord_ShowBanned(info) {
    $("#discord-banned-reason").text(info.reason ? "Reason: " + info.reason : "");
    var meta = info.expiresAt ? "Your access returns on " + new Date(info.expiresAt * 1000).toLocaleString() + "." : "This ban is permanent.";
    if (info.bannedBy) meta = "Banned by " + info.bannedBy + ". " + meta;
    $("#discord-banned-meta").text(meta);
    $("#discord-banned-screen").addClass("discord-visible");
    $("#discord-staff-btn").hide();
}

function Discord_HandleBanned(payload) {
    Discord_CloseModals();
    Discord_ShowBanned(payload || {});
}

function Discord_Close() {
    $("#discord-backdrop").removeClass("discord-visible");
    Discord_Post('Discord_Close', {});
}

$(document).on('keydown', function(e) {
    if (e.key === "Escape" && $("#discord-backdrop").hasClass("discord-visible")) {
        if ($("#discord-emoji-picker").hasClass("discord-visible")) {
            Discord_CloseEmojiPicker();
        } else if ($("#discord-modal-overlay").hasClass("discord-modal-open")) {
            Discord_CloseModals();
        } else {
            Discord_Close();
        }
    }
});

// ---------------------------------------------------------------------------
// Chat column state (empty / channel-empty / active)
// ---------------------------------------------------------------------------

function Discord_ShowChatColumnState(state) {
    $("#discord-empty-state").removeClass("discord-visible");
    $("#discord-channel-empty").removeClass("discord-visible");
    $("#discord-chat-active").removeClass("discord-visible");

    if (state === "empty") $("#discord-empty-state").addClass("discord-visible");
    else if (state === "channel-empty") $("#discord-channel-empty").addClass("discord-visible");
    else if (state === "active") $("#discord-chat-active").addClass("discord-visible");
}

function Discord_ResetChatColumn() {
    Discord.currentChannelId = null;
    Discord.lastMessageAuthor = null;
    Discord.messagesById = {};
    Discord.pendingSentMessages = [];
    $("#discord-chat-messages").empty();
}

// ---------------------------------------------------------------------------
// Server rail
// ---------------------------------------------------------------------------

function Discord_RenderServerRail() {
    var html = "";

    $.each(Discord.servers, function(i, server) {
        var selected = (server.id === Discord.currentServerId) ? "selected-discord-server" : "";
        html += '<div class="discord-rail-icon ' + selected + '" data-serverid="' + server.id + '" ' +
                'style="background-color:' + Discord_Escape(server.icon_color) + '" title="' + Discord_Escape(server.name) + '">' +
                Discord_Escape(server.icon_text) +
                (server.isVerified ? '<i class="fas fa-check-circle discord-verified-badge" title="Verified"></i>' : '') +
                '<div class="discord-rail-unread-dot" data-unreadfor="' + server.id + '"></div>' +
                '</div>';
    });

    $("#discord-server-rail-list").html(html);
}

function Discord_FindServer(serverId) {
    var found = null;
    $.each(Discord.servers, function(i, s) { if (s.id === serverId) found = s; });
    return found;
}

function Discord_SelectServer(serverId) {
    Discord.currentServerId = serverId;
    Discord_ResetChatColumn();
    Discord_CloseEmojiPicker();
    $(".discord-rail-unread-dot[data-unreadfor='" + serverId + "']").removeClass("discord-unread-visible");

    var server = Discord_FindServer(serverId);
    if (server) {
        Discord_SetServerHeader(server);
        Discord.currentServerIsOwner = !!server.isOwner;
        Discord.currentServerIsAdmin = !!server.isAdmin;
        var canManageChannels = Discord.currentServerIsOwner || Discord.currentServerIsAdmin;
        $("#discord-add-channel-btn").css("display", canManageChannels ? "flex" : "none");
    }

    Discord_RenderServerRail();
    Discord_ShowChatColumnState("channel-empty");

    Discord_Post('GetDiscordChannels', { serverId: serverId }, function(channels) {
        if (channels === false) channels = [];
        Discord.channels = channels;
        Discord_RenderChannelList();

        if (Discord.channels.length > 0) {
            Discord_OpenChannel(Discord.channels[0].id, Discord.channels[0].name);
        }
    });
}

// ---------------------------------------------------------------------------
// Channel list
// ---------------------------------------------------------------------------

function Discord_RenderChannelList() {
    var html = "";

    $.each(Discord.channels, function(i, channel) {
        var selected = (channel.id === Discord.currentChannelId) ? "selected-discord-channel" : "";
        html += '<div class="discord-channel-item ' + selected + '" data-channelid="' + channel.id + '" data-channelname="' + Discord_Escape(channel.name) + '">' +
                '<i class="fas fa-hashtag"></i><span>' + Discord_Escape(channel.name) + '</span>' +
                Discord_VerifiedBadge(channel.isVerified) +
                (channel.isLocked ? '<i class="fas fa-lock discord-channel-lock" title="Locked"></i>' : '') +
                '</div>';
    });

    $("#discord-channel-list").html(html);
}

// ---------------------------------------------------------------------------
// Chat — message text processing (mentions + link/image embeds)
// ---------------------------------------------------------------------------

var DISCORD_URL_RE = /(https?:\/\/[^\s<]+)/gi;
var DISCORD_IMAGE_RE = /\.(png|jpe?g|gif|webp)(\?\S*)?$/i;

function Discord_MentionsMe(rawText) {
    if (/@(everyone|here)\b/i.test(rawText)) return true;
    if (!Discord.myName) return false;
    var firstName = Discord.myName.split(/\s+/)[0];
    var re = new RegExp("@" + firstName.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"), "i");
    return re.test(rawText);
}

function Discord_ProcessMessageText(rawText) {
    var escaped = Discord_Escape(rawText);
    var imageUrls = [];

    // @everyone / @here get a distinct gold pill and count as mentioning
    // every viewer (checked separately above in Discord_MentionsMe).
    escaped = escaped.replace(/@(everyone|here)\b/gi, function(full, word) {
        return '<span class="discord-mention-pill discord-mention-everyone">@' + word + '</span>';
    });

    // Highlight @mentions (anything shaped like "@Word" or "@Word Word").
    escaped = escaped.replace(/@([A-Za-z\u00C0-\u024F\u0600-\u06FF]+(?:\s[A-Za-z\u00C0-\u024F\u0600-\u06FF]+)?)/g, function(full, name) {
        if (/^(everyone|here)$/i.test(name)) return full; // already handled above
        var isSelf = Discord.myName && name.toLowerCase().indexOf(Discord.myName.split(/\s+/)[0].toLowerCase()) === 0;
        return '<span class="discord-mention-pill' + (isSelf ? ' discord-mention-self' : '') + '">@' + name + '</span>';
    });

    // Links: image URLs get pulled out into embeds below the text; other
    // URLs just get styled (not turned into clickable/navigable anchors —
    // this is a game overlay, not a browser).
    escaped = escaped.replace(DISCORD_URL_RE, function(url) {
        if (DISCORD_IMAGE_RE.test(url)) {
            imageUrls.push(url);
            return '<span class="discord-message-link">' + url + '</span>';
        }
        return '<span class="discord-message-link">' + url + '</span>';
    });

    var embedHtml = "";
    $.each(imageUrls, function(i, url) {
        embedHtml += '<img class="discord-message-embed-image" src="' + url + '" onerror="this.remove()">';
    });

    return { textHtml: escaped, embedHtml: embedHtml };
}

// ---------------------------------------------------------------------------
// Chat — rendering messages
// ---------------------------------------------------------------------------

function Discord_OpenChannel(channelId, channelName) {
    Discord.currentChannelId = channelId;
    Discord.lastMessageAuthor = null;
    Discord.messagesById = {};
    Discord.pendingSentMessages = [];
    Discord_CloseEmojiPicker();
    Discord_CancelReply();
    $("#discord-typing-indicator").empty();

    var openedChannel = Discord_FindChannel(channelId);
    $("#discord-chat-channel-name").html(Discord_Escape(channelName) + Discord_VerifiedBadge(openedChannel && openedChannel.isVerified));
    $("#discord-message-input").attr("placeholder", "Message #" + channelName).val("");
    $("#discord-chat-messages").html('<div class="discord-chat-empty">Loading messages...</div>');

    Discord_RenderChannelList();
    Discord_ShowChatColumnState("active");
    Discord_UpdateComposerLock();
    Discord_LoadMembersSidebar();

    Discord_Post('GetDiscordMessages', { channelId: channelId }, function(messages) {
        if (Discord.currentChannelId !== channelId) return;

        $("#discord-chat-messages").empty();
        Discord.lastMessageAuthor = null;
        Discord.messagesById = {};

        if (!messages || messages.length === 0) {
            $("#discord-chat-messages").html('<div class="discord-chat-empty">No messages yet. Say hi! \uD83D\uDC4B</div>');
        } else {
            $.each(messages, function(i, msg) {
                Discord_AppendMessage(msg);
            });
        }

        Discord_ScrollMessagesToBottom();
    });
}

function Discord_RenderMessageActionsHTML(msg) {
    var canManageChannels = Discord.currentServerIsOwner || Discord.currentServerIsAdmin;
    var canEdit = !!msg.isMine;
    var canDelete = !!msg.isMine || Discord.currentServerIsOwner || Discord.isStaff;
    var canPin = canManageChannels || Discord.isStaff;

    var html = '<div class="discord-message-actions">';
    html += '<i class="fas fa-reply" data-action="reply" title="Reply"></i>';
    html += '<i class="far fa-smile" data-action="react" title="Add Reaction"></i>';
    if (canPin) html += '<i class="fas fa-thumbtack' + (msg.is_pinned ? ' discord-action-active' : '') + '" data-action="pin" title="' + (msg.is_pinned ? "Unpin" : "Pin") + '"></i>';
    if (canEdit) html += '<i class="fas fa-pen" data-action="edit" title="Edit"></i>';
    html += '<i class="fas fa-copy" data-action="copy" title="Copy Text"></i>';
    if (canDelete) html += '<i class="fas fa-trash discord-action-danger" data-action="delete" title="Delete"></i>';
    html += '</div>';
    return html;
}

function Discord_RenderReactionsHTML(reactions) {
    if (!reactions || reactions.length === 0) return '<div class="discord-message-reactions"></div>';

    var html = '<div class="discord-message-reactions">';
    $.each(reactions, function(i, r) {
        html += '<div class="discord-reaction-pill' + (r.reacted ? ' discord-reaction-mine' : '') + '" data-emoji="' + r.emoji + '">' +
                r.emoji + ' <span>' + r.count + '</span></div>';
    });
    html += '<div class="discord-reaction-add-pill" title="Add reaction"><i class="far fa-smile"></i></div>';
    html += '</div>';
    return html;
}

function Discord_FullDateTime(unixSeconds) {
    var d = new Date(unixSeconds * 1000);
    return d.toLocaleString();
}

function Discord_RenderReplyQuoteHTML(replyPreview) {
    if (!replyPreview) return "";
    return '<div class="discord-message-reply-quote"><i class="fas fa-reply"></i><b>' + Discord_Escape(replyPreview.author_name) + '</b><span>' + Discord_Escape(replyPreview.message) + '</span></div>';
}

function Discord_RenderMessageInnerHTML(msg) {
    var processed = Discord_ProcessMessageText(msg.message);
    var editedTag = msg.edited_at ? '<span class="discord-message-edited-tag">(edited)</span>' : '';
    var replyQuote = Discord_RenderReplyQuoteHTML(msg.replyPreview);

    var authorClass = msg.isMine ? "discord-message-author-me" : "";
    var color = Discord_ColorFor(msg.author_name);
    var time = Discord_FormatTime(msg.created_at);
    var fullTime = Discord_FullDateTime(msg.created_at);
    var badge = Discord_VerifiedBadge(msg.authorVerified);

    var mentionsMe = !msg.isMine && Discord_MentionsMe(msg.message);

    // Staff announcements get their own look and are never grouped.
    if (msg.isAnnouncement) {
        return '<div class="discord-message discord-message-announcement" data-messageid="' + msg.id + '">' +
               '<div class="discord-message-avatar discord-announcement-avatar"><i class="fas fa-bullhorn"></i></div>' +
               '<div class="discord-message-body">' +
               '<div class="discord-message-top"><span class="discord-message-author">Discord Staff</span>' + badge +
               '<span class="discord-announcement-tag">Announcement</span>' +
               '<span class="discord-message-time" title="' + fullTime + '">' + time + '</span></div>' +
               '<div class="discord-message-text">' + processed.textHtml + '</div>' + processed.embedHtml +
               Discord_RenderReactionsHTML(msg.reactions) +
               '</div>' + Discord_RenderMessageActionsHTML(msg) + '</div>';
    }

    var profileAttrs = ' data-authorid="' + (msg.authorMemberId || "") + '" data-mine="' + (msg.isMine ? 1 : 0) + '"';

    var html = '<div class="discord-message' + (mentionsMe ? ' discord-message-mentions-me' : '') + '" data-messageid="' + msg.id + '">';

    if (msg._grouped) {
        html += '<div class="discord-message-avatar" style="visibility:hidden;"></div>';
        html += '<div class="discord-message-body">';
        html += replyQuote;
        html += '<div class="discord-message-text">' + processed.textHtml + editedTag + '</div>';
        html += processed.embedHtml;
    } else {
        html += '<div class="discord-message-avatar discord-open-profile"' + profileAttrs + ' style="background-color:' + color + '">' + Discord_Escape(Discord_Initials(msg.author_name)) + '</div>';
        html += '<div class="discord-message-body">';
        html += replyQuote;
        html += '<div class="discord-message-top"><span class="discord-message-author discord-open-profile ' + authorClass + '"' + profileAttrs + '>' + Discord_Escape(msg.author_name) + '</span>' + badge + '<span class="discord-message-time" title="' + fullTime + '">' + time + '</span></div>';
        html += '<div class="discord-message-text">' + processed.textHtml + editedTag + '</div>';
        html += processed.embedHtml;
    }

    html += Discord_RenderReactionsHTML(msg.reactions);
    html += '</div>'; // .discord-message-body
    html += Discord_RenderMessageActionsHTML(msg);
    html += '</div>'; // .discord-message

    return html;
}

function Discord_AppendMessage(msg) {
    var container = $("#discord-chat-messages");
    if (container.find(".discord-chat-empty").length) container.empty();

    msg._grouped = (Discord.lastMessageAuthor === msg.author_name) && !msg.replyPreview && !msg.isAnnouncement;
    msg.reactions = msg.reactions || [];

    if (msg.id != null) Discord.messagesById[msg.id] = msg;

    container.append(Discord_RenderMessageInnerHTML(msg));
    Discord.lastMessageAuthor = msg.author_name;
}

function Discord_ScrollMessagesToBottom() {
    var el = document.getElementById("discord-chat-messages");
    if (el) el.scrollTop = el.scrollHeight;
}

function Discord_SendMessage() {
    var input = $("#discord-message-input");
    var text = input.val();
    if (!text) return;
    text = text.trim();
    if (text === "" || Discord.currentChannelId === null) return;

    input.val("");

    var replyToId = Discord.replyingToMessageId;
    var replyPreview = null;
    if (replyToId != null && Discord.messagesById[replyToId]) {
        var repliedMsg = Discord.messagesById[replyToId];
        replyPreview = { author_name: repliedMsg.author_name, message: repliedMsg.message.substring(0, 80) };
    }
    Discord_CancelReply();

    var optimisticMsg = {
        id: null,
        author_name: Discord.myName,
        message: text,
        created_at: Math.floor(Date.now() / 1000),
        isMine: true,
        edited_at: null,
        is_pinned: false,
        reactions: [],
        replyPreview: replyPreview,
    };

    Discord_AppendMessage(optimisticMsg);
    Discord_ScrollMessagesToBottom();

    var node = $("#discord-chat-messages .discord-message").last();
    Discord.pendingSentMessages.push({ node: node, msg: optimisticMsg });

    var channelAtSendTime = Discord.currentChannelId;

    Discord_Post('SendDiscordMessage', { channelId: channelAtSendTime, message: text, replyToId: replyToId }, function(result) {
        if (result && result.error === "LOCKED") {
            // Server refused it — take the optimistic copy back out.
            var lockedPending = Discord.pendingSentMessages.shift();
            if (lockedPending) lockedPending.node.remove();
            $("#discord-typing-indicator").text("This channel is locked.");
            return;
        }
        if (!result || !result.id) return;

        var pending = Discord.pendingSentMessages.shift();
        if (!pending) return;

        // Only patch the DOM if we're still looking at the same channel —
        // if the player switched channels mid-send, the node is long gone.
        pending.msg.id = result.id;
        pending.msg.created_at = result.created_at;
        Discord.messagesById[result.id] = pending.msg;

        if (Discord.currentChannelId === channelAtSendTime) {
            pending.node.attr("data-messageid", result.id);
        }
    });
}

function Discord_StartReply(messageId) {
    var msg = Discord.messagesById[messageId];
    if (!msg) return;

    Discord.replyingToMessageId = messageId;
    $("#discord-reply-preview-name").text(msg.author_name);
    $("#discord-reply-preview-bar").css("display", "flex");
    $("#discord-message-input").focus();
}

function Discord_CancelReply() {
    Discord.replyingToMessageId = null;
    $("#discord-reply-preview-bar").hide();
}

// ---------------------------------------------------------------------------
// Message actions: react / edit / delete / pin
// ---------------------------------------------------------------------------

function Discord_ToggleReaction(messageId, emoji) {
    if (messageId == null) return;
    Discord_Post('ToggleDiscordReaction', { messageId: messageId, emoji: emoji });
}

function Discord_StartEditMessage(messageId) {
    var msg = Discord.messagesById[messageId];
    if (!msg) return;

    var node = $('.discord-message[data-messageid="' + messageId + '"] .discord-message-text');
    if (node.length === 0) return;

    var html = '<div class="discord-message-edit-box">' +
               '<textarea class="discord-message-edit-input" rows="1">' + Discord_Escape(msg.message) + '</textarea>' +
               '<div class="discord-message-edit-hint">Enter to save · Esc to cancel</div>' +
               '</div>';

    node.replaceWith(html);

    var textarea = $('.discord-message[data-messageid="' + messageId + '"] .discord-message-edit-input');
    textarea.focus();
    textarea[0].setSelectionRange(textarea.val().length, textarea.val().length);

    textarea.on('keydown', function(e) {
        if (e.key === "Enter" && !e.shiftKey) {
            e.preventDefault();
            Discord_SaveEditMessage(messageId, textarea.val().trim());
        } else if (e.key === "Escape") {
            e.preventDefault();
            Discord_CancelEditMessage(messageId);
        }
    });
}

function Discord_CancelEditMessage(messageId) {
    var msg = Discord.messagesById[messageId];
    if (!msg) return;
    var box = $('.discord-message[data-messageid="' + messageId + '"] .discord-message-edit-box');
    var processed = Discord_ProcessMessageText(msg.message);
    var editedTag = msg.edited_at ? '<span class="discord-message-edited-tag">(edited)</span>' : '';
    box.replaceWith('<div class="discord-message-text">' + processed.textHtml + editedTag + '</div>');
}

function Discord_SaveEditMessage(messageId, newText) {
    if (newText === "") { Discord_CancelEditMessage(messageId); return; }

    Discord_Post('EditDiscordMessage', { messageId: messageId, message: newText }, function(result) {
        if (!result) Discord_CancelEditMessage(messageId); // server rejected it — just revert visually, the broadcast never comes
    });
}

function Discord_DeleteMessageAction(messageId) {
    Discord_Post('DeleteDiscordMessage', { messageId: messageId });
}

function Discord_TogglePinAction(messageId) {
    Discord_Post('TogglePinDiscordMessage', { messageId: messageId });
}

function Discord_OpenPinnedMessages() {
    if (Discord.currentChannelId === null) return;

    $("#discord-pinned-list").html('<div class="discord-pinned-empty">Loading...</div>');
    Discord_OpenModal('discord-modal-pinned-messages');

    Discord_Post('GetDiscordPinnedMessages', { channelId: Discord.currentChannelId }, function(pinned) {
        if (!pinned || pinned === false || pinned.length === 0) {
            $("#discord-pinned-list").html('<div class="discord-pinned-empty">No pinned messages yet.</div>');
            return;
        }

        var html = "";
        $.each(pinned, function(i, msg) {
            var processed = Discord_ProcessMessageText(msg.message);
            html += '<div class="discord-pinned-item">' +
                    '<div class="discord-pinned-item-top"><span class="discord-pinned-item-author">' + Discord_Escape(msg.author_name) + '</span>' +
                    '<span class="discord-pinned-item-time">' + Discord_FormatTime(msg.created_at) + '</span></div>' +
                    '<div class="discord-pinned-item-text">' + processed.textHtml + '</div>' +
                    processed.embedHtml +
                    '</div>';
        });
        $("#discord-pinned-list").html(html);
    });
}

function Discord_LoadDiscoverList() {
    $("#discord-discover-list").html('<div class="discord-discover-empty">Loading...</div>');

    Discord_Post('GetDiscordPublicServers', {}, function(servers) {
        if (!servers || servers.length === 0) {
            $("#discord-discover-list").html('<div class="discord-discover-empty">No public servers to join right now.</div>');
            return;
        }

        var html = "";
        $.each(servers, function(i, server) {
            html += '<div class="discord-discover-item">' +
                    '<div class="discord-discover-icon" style="background-color:' + Discord_Escape(server.icon_color) + '">' + Discord_Escape(server.icon_text) + '</div>' +
                    '<div class="discord-discover-info">' +
                    '<div class="discord-discover-name">' + Discord_Escape(server.name) + Discord_VerifiedBadge(server.is_verified == 1 || server.is_verified === true) + '</div>' +
                    '<div class="discord-discover-members">' + server.memberCount + ' member' + (server.memberCount == 1 ? '' : 's') + '</div>' +
                    '</div>' +
                    '<div class="discord-btn discord-btn-primary discord-btn-small discord-discover-join-btn" data-serverid="' + server.id + '">Join</div>' +
                    '</div>';
        });
        $("#discord-discover-list").html(html);
    });
}

function Discord_LoadVIPList() {
    $("#discord-vip-list").html('<div class="discord-discover-empty">Loading...</div>');

    Discord_Post('GetDiscordVIPServers', {}, function(servers) {
        if (!servers || servers.length === 0) {
            $("#discord-vip-list").html('<div class="discord-discover-empty">No VIP servers right now.</div>');
            return;
        }

        var html = "";
        $.each(servers, function(i, server) {
            html += '<div class="discord-discover-item">' +
                    '<div class="discord-discover-icon" style="background-color:' + Discord_Escape(server.icon_color) + '">' + Discord_Escape(server.icon_text) + '</div>' +
                    '<div class="discord-discover-info">' +
                    '<div class="discord-discover-name">' + Discord_Escape(server.name) + Discord_VerifiedBadge(server.isVerified) + ' <i class="fas fa-gem" style="color:#b491ff;font-size:11px;"></i></div>' +
                    '<div class="discord-discover-members">' + server.memberCount + ' member' + (server.memberCount == 1 ? '' : 's') + '</div>' +
                    '</div>' +
                    '<div class="discord-btn discord-btn-primary discord-btn-small discord-vip-join-btn" data-serverid="' + server.id + '">Join</div>' +
                    '</div>';
        });
        $("#discord-vip-list").html(html);
    });
}

// ---------------------------------------------------------------------------
// Emoji picker (shared between "insert into composer" and "react")
// ---------------------------------------------------------------------------

function Discord_OpenEmojiPicker(mode, messageId) {
    Discord.emojiPickerMode = mode;
    Discord.emojiPickerTargetMessageId = messageId || null;

    var list = (mode === "react") ? Discord.reactionEmojis : Discord.composeEmojis;
    var html = "";
    $.each(list, function(i, emoji) {
        html += '<div class="discord-emoji-picker-item" data-emoji="' + emoji + '">' + emoji + '</div>';
    });

    $("#discord-emoji-picker").html(html).addClass("discord-visible");
}

function Discord_CloseEmojiPicker() {
    $("#discord-emoji-picker").removeClass("discord-visible");
    Discord.emojiPickerMode = null;
    Discord.emojiPickerTargetMessageId = null;
}

// ---------------------------------------------------------------------------
// Members sidebar (always visible, independent of channel)
// ---------------------------------------------------------------------------

function Discord_LoadMembersSidebar() {
    if (Discord.currentServerId === null) { $("#discord-members-list").empty(); return; }

    $("#discord-members-list").html('<div class="discord-chat-empty">Loading...</div>');

    Discord_Post('GetDiscordMembers', { serverId: Discord.currentServerId }, function(members) {
        if (!members || members === false) { $("#discord-members-list").html('<div class="discord-chat-empty">Could not load members.</div>'); return; }

        $("#discord-members-header").text("Members — " + members.length);

        var online = members.filter(function(m) { return m.isOnline; });
        var offline = members.filter(function(m) { return !m.isOnline; });

        var html = Discord_RenderMemberGroup("Online — " + online.length, online) +
                   Discord_RenderMemberGroup("Offline — " + offline.length, offline);

        $("#discord-members-list").html(html);
    });
}

function Discord_RenderMemberGroup(label, members) {
    if (members.length === 0) return "";

    var html = '<div class="discord-members-group-label">' + Discord_Escape(label) + '</div>';
    $.each(members, function(i, member) {
        var color = Discord_ColorFor(member.nickname);
        var statusClass = (member.status && member.status !== "offline") ? "discord-status-" + member.status : "";
        var nameClass = member.isOwner ? "discord-member-owner" : "";
        var showKick = Discord.currentServerIsOwner && !member.isOwner;
        var showAdminToggle = Discord.currentServerIsOwner && !member.isOwner;

        html += '<div class="discord-member-item" data-memberrowid="' + member.id + '">' +
                '<div class="discord-member-avatar" style="background-color:' + color + '">' + Discord_Escape(Discord_Initials(member.nickname)) +
                '<div class="discord-member-status-dot ' + statusClass + '"></div>' +
                '</div>' +
                '<div class="discord-member-text">' +
                '<span class="discord-member-name ' + nameClass + '">' + Discord_Escape(member.nickname) +
                Discord_VerifiedBadge(member.isVerified) +
                (member.isOwner ? ' <i class="fas fa-crown discord-member-crown"></i>' : '') +
                (member.isAdmin ? ' <span class="discord-member-admin-badge">Admin</span>' : '') +
                '</span>' +
                (member.customStatus ? '<span class="discord-member-custom-status">' + Discord_Escape(member.customStatus) + '</span>' : '') +
                '</div>' +
                (showAdminToggle ? '<i class="fas fa-shield-alt discord-member-admin-btn' + (member.isAdmin ? ' discord-admin-active' : '') + '" title="' + (member.isAdmin ? "Remove admin" : "Make admin") + '"></i>' : '') +
                (showKick ? '<i class="fas fa-user-slash discord-member-kick-btn" title="Kick"></i>' : '') +
                '</div>';
    });
    return html;
}

function Discord_KickMemberAction(memberRowId) {
    if (Discord.currentServerId === null) return;
    Discord_Post('KickDiscordMember', { serverId: Discord.currentServerId, memberId: memberRowId }, function(result) {
        if (result) Discord_LoadMembersSidebar();
    });
}

function Discord_ToggleAdminAction(memberRowId) {
    if (Discord.currentServerId === null) return;
    Discord_Post('ToggleDiscordAdmin', { serverId: Discord.currentServerId, memberId: memberRowId }, function(result) {
        if (result) Discord_LoadMembersSidebar();
    });
}

// ---------------------------------------------------------------------------
// Discord account / profile (with in-game info)
// ---------------------------------------------------------------------------

var DiscordStatusLabels = { online: "Online", idle: "Idle", dnd: "Do Not Disturb", invisible: "Invisible", offline: "Offline" };

function Discord_LoadMyProfile() {
    Discord_Post('GetDiscordMyProfile', {}, function(profile) {
        if (profile) Discord_ApplyMyProfile(profile);
    });
}

function Discord_ApplyMyProfile(profile) {
    Discord.myProfile = profile;

    if (profile.displayName) {
        Discord.myName = profile.displayName;
        $("#discord-my-name").html(Discord_Escape(Discord.myName) + Discord_VerifiedBadge(profile.verified));
        $("#discord-my-avatar").css("background-color", Discord_ColorFor(Discord.myName)).text(Discord_Initials(Discord.myName));
    }
    if (profile.isStaff !== undefined) {
        Discord.isStaff = !!profile.isStaff;
        $("#discord-staff-btn").css("display", Discord.isStaff ? "flex" : "none");
    }

    var dot = $("#discord-my-status-dot");
    dot.removeClass("discord-status-online discord-status-idle discord-status-dnd");
    if (profile.status !== "invisible") dot.addClass("discord-status-" + profile.status);

    $("#discord-my-tag").text(profile.customStatus ? profile.customStatus : DiscordStatusLabels[profile.status] || "Online");
}

function Discord_FormatDate(unixSeconds) {
    if (!unixSeconds) return "—";
    return new Date(unixSeconds * 1000).toLocaleDateString();
}

function Discord_InfoRow(label, value, hidden) {
    var valueHtml = hidden ? '<span class="discord-profile-info-hidden">Hidden</span>' : Discord_Escape(value);
    return '<div class="discord-profile-info-row"><span>' + label + '</span><span>' + valueHtml + '</span></div>';
}

function Discord_OpenMyProfile() {
    Discord_Post('GetDiscordMyProfile', {}, function(profile) {
        if (!profile) return;
        Discord_ApplyMyProfile(profile);
        profile.nickname = Discord.myName;
        Discord_RenderProfileView(profile);
    });
}

function Discord_OpenMemberProfile(memberRowId) {
    if (Discord.currentServerId === null) return;
    Discord_Post('GetDiscordProfile', { serverId: Discord.currentServerId, memberId: memberRowId }, function(profile) {
        if (profile) Discord_RenderProfileView(profile);
    });
}

function Discord_RenderProfileView(p) {
    var name = p.nickname || Discord.myName;
    var info = p.info || {};
    var status = p.status || "offline";

    $("#discord-pv-banner").css("background-color", p.bannerColor || "#5865F2");
    $("#discord-pv-avatar").css("background-color", Discord_ColorFor(name)).text(Discord_Initials(name));

    var dot = $("#discord-pv-status-dot");
    dot.removeClass("discord-status-online discord-status-idle discord-status-dnd");
    if (status !== "offline" && status !== "invisible") dot.addClass("discord-status-" + status);

    var badges = "";
    if (p.isOwner) badges += '<span class="discord-profile-badge discord-profile-badge-owner">Owner</span>';
    if (p.isAdmin) badges += '<span class="discord-profile-badge discord-profile-badge-admin">Admin</span>';
    $("#discord-pv-badges").html(badges);

    $("#discord-pv-name").html(Discord_Escape(name) + Discord_VerifiedBadge(p.verified));
    $("#discord-pv-tag").text(name.replace(/\s+/g, "").toLowerCase() + " #" + (p.discriminator || "0000"));

    var customLine = (DiscordStatusLabels[status] || "") + (p.customStatus ? " — " + p.customStatus : "");
    $("#discord-pv-custom-status").text(customLine);

    if (p.bio) { $("#discord-pv-bio").text(p.bio); $("#discord-pv-bio-section").show(); }
    else { $("#discord-pv-bio-section").hide(); }

    var infoHtml = "";
    infoHtml += Discord_InfoRow("Full name", info.fullName || name, false);
    infoHtml += Discord_InfoRow("Phone", info.phone, !info.phone);
    infoHtml += Discord_InfoRow("Job", info.jobLabel ? (info.jobLabel + (info.gradeLabel ? " · " + info.gradeLabel : "")) : "", !info.jobLabel);
    if (info.gender) infoHtml += Discord_InfoRow("Gender", info.gender, false);
    if (info.birthdate) infoHtml += Discord_InfoRow("Birth date", info.birthdate, false);
    $("#discord-pv-info").html(infoHtml);

    var datesHtml = "";
    if (p.memberSince) datesHtml += Discord_InfoRow("Member of this server since", Discord_FormatDate(p.memberSince), false);
    datesHtml += Discord_InfoRow("On Discord since", Discord_FormatDate(p.discordSince), false);
    if (p.isSelf && p.serverCount != null) datesHtml += Discord_InfoRow("Servers", String(p.serverCount), false);
    $("#discord-pv-dates").html(datesHtml);

    $("#discord-pv-edit-btn").css("display", p.isSelf ? "block" : "none");
    $("#discord-pv-logout-btn").css("display", p.isSelf ? "block" : "none");

    Discord_OpenModal("discord-modal-profile-view");
}

function Discord_OpenProfileEditor() {
    Discord_Post('GetDiscordMyProfile', {}, function(profile) {
        if (!profile) return;

        Discord.profileDraft = { status: profile.status || "online", bannerColor: profile.bannerColor || Discord.iconPalette[0] };

        $(".discord-status-option").removeClass("discord-status-selected");
        $('.discord-status-option[data-status="' + Discord.profileDraft.status + '"]').addClass("discord-status-selected");

        $("#discord-pe-custom-status").val(profile.customStatus || "");
        $("#discord-pe-bio").val(profile.bio || "");
        $("#discord-pe-show-phone").toggleClass("discord-toggle-on", !!profile.showPhone);
        $("#discord-pe-show-job").toggleClass("discord-toggle-on", !!profile.showJob);
        Discord_RenderBannerPalette(Discord.profileDraft.bannerColor);

        Discord_OpenModal("discord-modal-profile-edit");
        // OpenModal doesn't clear inputs, but CloseModals does — values set above stay.
    });
}

function Discord_RenderBannerPalette(selected) {
    var html = "";
    $.each(Discord.iconPalette, function(i, color) {
        html += '<div class="discord-banner-swatch' + (color === selected ? ' discord-swatch-selected' : '') + '" data-color="' + color + '" style="background-color:' + color + '"></div>';
    });
    $("#discord-pe-banner-palette").html(html);
}

function Discord_SaveProfile() {
    var data = {
        status: Discord.profileDraft.status,
        bannerColor: Discord.profileDraft.bannerColor,
        customStatus: $("#discord-pe-custom-status").val().trim(),
        bio: $("#discord-pe-bio").val().trim(),
        showPhone: $("#discord-pe-show-phone").hasClass("discord-toggle-on"),
        showJob: $("#discord-pe-show-job").hasClass("discord-toggle-on"),
    };

    Discord_Post('UpdateDiscordMyProfile', data, function(profile) {
        if (!profile) { Discord_ShowModalError('discord-modal-profile-edit', 'Could not save your profile.'); return; }
        Discord_ApplyMyProfile(profile);
        Discord_LoadMembersSidebar();
        Discord_CloseModals();
    });
}

function Discord_HandleProfileUpdated(payload) {
    if (payload.serverId === Discord.currentServerId) Discord_LoadMembersSidebar();
}

// ---------------------------------------------------------------------------
// Modals
// ---------------------------------------------------------------------------

function Discord_OpenModal(modalId) {
    $(".discord-modal").removeClass("discord-modal-active");
    $(".discord-modal-error").removeClass("discord-error-visible").text("");
    $("#" + modalId).addClass("discord-modal-active");
    $("#discord-modal-overlay").addClass("discord-modal-open");
}

function Discord_CloseModals() {
    $("#discord-modal-overlay").removeClass("discord-modal-open");
    $(".discord-modal").removeClass("discord-modal-active");
    $(".discord-modal input[type='text']").val("");
    $(".discord-modal-error").removeClass("discord-error-visible").text("");
}

function Discord_ShowModalError(modalId, text) {
    var errorEl = $("#" + modalId + " .discord-modal-error");
    if (errorEl.length === 0) {
        errorEl = $('<div class="discord-modal-error"></div>');
        $("#" + modalId + " input").after(errorEl);
    }
    errorEl.text(text).addClass("discord-error-visible");
}

function Discord_OpenServerMenu() {
    if (Discord.currentServerId === null) return;
    var server = Discord_FindServer(Discord.currentServerId);
    if (!server) return;

    $("#discord-menu-server-name").text(server.name);
    $("#discord-menu-invite-code").text(server.invite_code || "-------");
    $("#discord-create-channel-open-btn").css("display", Discord.currentServerIsOwner ? "block" : "none");
    $("#discord-open-settings-btn").css("display", Discord.currentServerIsOwner ? "block" : "none");
    $("#discord-delete-server-btn").css("display", Discord.currentServerIsOwner ? "block" : "none");
    $("#discord-leave-server-btn").css("display", Discord.currentServerIsOwner ? "none" : "block");

    Discord_OpenModal("discord-modal-server-menu");
}

function Discord_OpenServerSettings() {
    var server = Discord_FindServer(Discord.currentServerId);
    if (!server) return;

    $("#discord-settings-name-input").val(server.name);
    $("#discord-settings-invite-code").text(server.invite_code || "-------");
    Discord_RenderIconPalette(server.icon_color);
    $("#discord-public-toggle-switch").toggleClass("discord-toggle-on", !!server.isPublic);

    Discord_OpenModal("discord-modal-server-settings");
}

function Discord_RenderIconPalette(selectedColor) {
    var html = "";
    $.each(Discord.iconPalette, function(i, color) {
        var selected = (color === selectedColor) ? "discord-swatch-selected" : "";
        html += '<div class="discord-icon-swatch ' + selected + '" data-color="' + color + '" style="background-color:' + color + '"></div>';
    });
    $("#discord-icon-palette").html(html);
}

// ---------------------------------------------------------------------------
// Live push handlers — called from js/app.js's central message switch (see
// its "Discord*" cases), which forward what client/main.lua sends via the
// "Unique_Phone:client:Discord:*" net events.
// ---------------------------------------------------------------------------

function Discord_HandleIncomingMessage(payload) {
    if (Discord.currentChannelId === payload.channelId) {
        Discord_AppendMessage({
            id: payload.id,
            author_name: payload.author_name,
            authorMemberId: payload.authorMemberId,
            authorVerified: payload.authorVerified,
            isAnnouncement: payload.isAnnouncement,
            message: payload.message,
            created_at: payload.created_at,
            isMine: false,
            edited_at: null,
            is_pinned: false,
            reactions: [],
            replyPreview: payload.replyPreview,
        });
        Discord_ScrollMessagesToBottom();
        if (payload.isAnnouncement) Discord_PlayNotificationSound();
    } else {
        $(".discord-rail-unread-dot[data-unreadfor='" + payload.serverId + "']").addClass("discord-unread-visible");
        Discord_PlayNotificationSound();
    }
}

function Discord_HandleNewChannel(payload) {
    if (payload.serverId === Discord.currentServerId) {
        Discord.channels.push(payload.channel);
        Discord_RenderChannelList();
    }
}

function Discord_HandleServerDeleted(payload) {
    Discord.servers = Discord.servers.filter(function(s) { return s.id !== payload.serverId; });

    if (Discord.currentServerId === payload.serverId) {
        if (Discord.servers.length > 0) {
            Discord_SelectServer(Discord.servers[0].id);
        } else {
            Discord.currentServerId = null;
            Discord.channels = [];
            Discord_ResetChatColumn();
            $("#discord-current-server-name").text("Discord");
            $("#discord-channel-list").empty();
            $("#discord-add-channel-btn").hide();
            $("#discord-members-list").empty();
            Discord_ShowChatColumnState("empty");
            Discord_RenderServerRail();
        }
    } else {
        Discord_RenderServerRail();
    }
}

function Discord_HandleChannelDeleted(payload) {
    if (payload.serverId !== Discord.currentServerId) return;

    Discord.channels = Discord.channels.filter(function(c) { return c.id !== payload.channelId; });
    Discord_RenderChannelList();

    if (Discord.currentChannelId === payload.channelId) {
        if (Discord.channels.length > 0) {
            Discord_OpenChannel(Discord.channels[0].id, Discord.channels[0].name);
        } else {
            Discord_ResetChatColumn();
            Discord_ShowChatColumnState("channel-empty");
        }
    }
}

function Discord_HandleReactionsUpdated(payload) {
    if (payload.serverId !== Discord.currentServerId) return;
    var msg = Discord.messagesById[payload.messageId];
    if (!msg) return;

    msg.reactions = payload.reactions || [];
    $('.discord-message[data-messageid="' + payload.messageId + '"] .discord-message-reactions').replaceWith(Discord_RenderReactionsHTML(msg.reactions));
}

function Discord_HandleMessageEdited(payload) {
    if (payload.serverId !== Discord.currentServerId) return;
    var msg = Discord.messagesById[payload.messageId];
    if (!msg) return;

    msg.message = payload.message;
    msg.edited_at = payload.edited_at;

    var processed = Discord_ProcessMessageText(msg.message);
    var editedTag = '<span class="discord-message-edited-tag">(edited)</span>';
    var messageNode = $('.discord-message[data-messageid="' + payload.messageId + '"]');
    messageNode.find('.discord-message-text, .discord-message-edit-box').replaceWith('<div class="discord-message-text">' + processed.textHtml + editedTag + '</div>');
    messageNode.find('.discord-message-embed-image').remove();
    messageNode.find('.discord-message-text').after(processed.embedHtml);
}

function Discord_HandleMessageDeleted(payload) {
    if (payload.serverId !== Discord.currentServerId) return;
    delete Discord.messagesById[payload.messageId];
    $('.discord-message[data-messageid="' + payload.messageId + '"]').remove();
}

function Discord_HandleMessagePinToggled(payload) {
    if (payload.serverId !== Discord.currentServerId) return;
    var msg = Discord.messagesById[payload.messageId];
    if (msg) msg.is_pinned = payload.isPinned;

    var pinIcon = $('.discord-message[data-messageid="' + payload.messageId + '"] .discord-message-actions i[data-action="pin"]');
    pinIcon.toggleClass("discord-action-active", !!payload.isPinned);
    pinIcon.attr("title", payload.isPinned ? "Unpin" : "Pin");
}

function Discord_RenderTypingIndicator() {
    var names = Object.keys(Discord.typingUsers);
    if (names.length === 0) { $("#discord-typing-indicator").empty(); return; }
    if (names.length === 1) { $("#discord-typing-indicator").text(names[0] + " is typing..."); return; }
    if (names.length === 2) { $("#discord-typing-indicator").text(names[0] + " and " + names[1] + " are typing..."); return; }
    $("#discord-typing-indicator").text("Several people are typing...");
}

function Discord_HandleTyping(payload) {
    if (payload.channelId !== Discord.currentChannelId) return;
    if (payload.name === Discord.myName.split(/\s+/)[0]) return;

    if (Discord.typingUsers[payload.name]) clearTimeout(Discord.typingUsers[payload.name]);

    Discord.typingUsers[payload.name] = setTimeout(function() {
        delete Discord.typingUsers[payload.name];
        Discord_RenderTypingIndicator();
    }, 4000);

    Discord_RenderTypingIndicator();
}

function Discord_HandleMemberKicked(payload) {
    if (payload.serverId === Discord.currentServerId) Discord_LoadMembersSidebar();
}

function Discord_HandleYouWereKicked(payload) {
    Discord_HandleServerDeleted({ serverId: payload.serverId });
}

function Discord_HandleMemberAdminToggled(payload) {
    if (payload.serverId === Discord.currentServerId) Discord_LoadMembersSidebar();
}

function Discord_HandleChannelUpdated(payload) {
    if (payload.serverId !== Discord.currentServerId) return;
    var ch = Discord_FindChannel(payload.channelId);
    if (!ch) return;
    if (payload.isVerified !== undefined) ch.isVerified = payload.isVerified;
    if (payload.isLocked !== undefined) ch.isLocked = payload.isLocked;
    Discord_RenderChannelList();
    if (payload.channelId === Discord.currentChannelId) {
        $("#discord-chat-channel-name").html(Discord_Escape(ch.name) + Discord_VerifiedBadge(ch.isVerified));
        Discord_UpdateComposerLock();
    }
}

function Discord_HandleServerUpdated(payload) {
    var server = Discord_FindServer(payload.serverId);
    if (server) {
        if (payload.name !== undefined) server.name = payload.name;
        if (payload.icon_text !== undefined) server.icon_text = payload.icon_text;
        if (payload.icon_color !== undefined) server.icon_color = payload.icon_color;
        if (payload.isVerified !== undefined) server.isVerified = payload.isVerified;
    }

    Discord_RenderServerRail();
    if (Discord.currentServerId === payload.serverId) {
        if (server) Discord_SetServerHeader(server);
    }
}

// ---------------------------------------------------------------------------
// Event bindings
// ---------------------------------------------------------------------------

$(document).ready(function() {

    $(document).on('click', '#discord-close-btn, #discord-banned-close-btn', function() { Discord_Close(); });

    $(document).on('click', '#discord-login-send-code-btn', function() { Discord_RequestLoginCode(); });
    $(document).on('keydown', '#discord-login-mailbox-input', function(e) { if (e.key === "Enter") Discord_RequestLoginCode(); });

    $(document).on('click', '#discord-login-verify-btn', function() { Discord_VerifyLoginCode(); });
    $(document).on('keydown', '#discord-login-code-input', function(e) { if (e.key === "Enter") Discord_VerifyLoginCode(); });

    $(document).on('input', '#discord-login-code-input', function() {
        var digitsOnly = $(this).val().replace(/\D/g, "").slice(0, 6);
        $(this).val(digitsOnly);
        if (digitsOnly.length === 6) Discord_VerifyLoginCode();
    });

    $(document).on('click', '#discord-login-resend-btn', function() { Discord_ResendLoginCode(); });

    $(document).on('click', '#discord-login-back-btn', function() {
        $("#discord-login-step-code").hide();
        $("#discord-login-step-mailbox").show();
    });

    $(document).on('click', '#discord-pv-logout-btn', function() { Discord_LogoutAccount(); });

    // ----- profile -----

    $(document).on('click', '#discord-user-footer', function() { Discord_OpenMyProfile(); });

    $(document).on('click', '.discord-member-item', function() {
        Discord_OpenMemberProfile(parseInt($(this).data('memberrowid')));
    });

    $(document).on('click', '.discord-open-profile', function() {
        if (parseInt($(this).data('mine')) === 1) { Discord_OpenMyProfile(); return; }
        var authorId = parseInt($(this).data('authorid'));
        if (!isNaN(authorId)) Discord_OpenMemberProfile(authorId);
    });

    $(document).on('click', '#discord-pv-edit-btn', function() { Discord_OpenProfileEditor(); });

    $(document).on('click', '.discord-status-option', function() {
        Discord.profileDraft.status = $(this).data('status');
        $(".discord-status-option").removeClass("discord-status-selected");
        $(this).addClass("discord-status-selected");
    });

    $(document).on('click', '.discord-banner-swatch', function() {
        Discord.profileDraft.bannerColor = $(this).data('color');
        $(".discord-banner-swatch").removeClass("discord-swatch-selected");
        $(this).addClass("discord-swatch-selected");
    });

    $(document).on('click', '#discord-pe-show-phone, #discord-pe-show-job', function() {
        $(this).toggleClass("discord-toggle-on");
    });

    $(document).on('click', '#discord-pe-save-btn', function() { Discord_SaveProfile(); });

    $(document).on('click', '#discord-server-rail-list .discord-rail-icon', function() {
        var serverId = parseInt($(this).data('serverid'));
        if (serverId !== Discord.currentServerId) Discord_SelectServer(serverId);
    });

    $(document).on('click', '.discord-channel-item', function() {
        var channelId = parseInt($(this).data('channelid'));
        var channelName = $(this).data('channelname');
        if (channelId !== Discord.currentChannelId) Discord_OpenChannel(channelId, channelName);
    });

    $(document).on('click', '#discord-chat-members-toggle', function() {
        $("#discord-members-sidebar").toggleClass("discord-hidden");
    });

    $(document).on('click', '#discord-chat-pins-btn', function() { Discord_OpenPinnedMessages(); });

    $(document).on('click', '#discord-send-message-btn', function() { Discord_SendMessage(); });

    $(document).on('keydown', '#discord-message-input', function(e) {
        if (e.which === 13 || e.keyCode === 13) {
            e.preventDefault();
            Discord_SendMessage();
        }
    });

    $(document).on('input', '#discord-message-input', function() {
        if (Discord.currentChannelId === null) return;
        var now = Date.now();
        if (now - Discord.lastTypingSentAt > 2500) {
            Discord.lastTypingSentAt = now;
            Discord_Post('SendDiscordTyping', { channelId: Discord.currentChannelId });
        }
    });

    $(document).on('click', '#discord-reply-cancel-btn', function() { Discord_CancelReply(); });

    $(document).on('click', '.discord-message-actions i[data-action="reply"]', function() {
        var messageId = parseInt($(this).closest('.discord-message').data('messageid'));
        Discord_StartReply(messageId);
    });

    $(document).on('click', '.discord-message-actions i[data-action="copy"]', function() {
        var messageId = parseInt($(this).closest('.discord-message').data('messageid'));
        var msg = Discord.messagesById[messageId];
        if (!msg) return;
        var temp = $('<textarea>').val(msg.message).appendTo('body').select();
        try { document.execCommand('copy'); } catch (e) {}
        temp.remove();
    });

    // ----- emoji picker -----

    $(document).on('click', '#discord-emoji-btn', function(e) {
        e.stopPropagation();
        if (Discord.emojiPickerMode === "compose" && $("#discord-emoji-picker").hasClass("discord-visible")) {
            Discord_CloseEmojiPicker();
        } else {
            Discord_OpenEmojiPicker("compose");
        }
    });

    $(document).on('click', '.discord-message-actions i[data-action="react"]', function(e) {
        e.stopPropagation();
        var messageId = parseInt($(this).closest('.discord-message').data('messageid'));
        Discord_OpenEmojiPicker("react", messageId);
    });

    $(document).on('click', '.discord-reaction-add-pill', function(e) {
        e.stopPropagation();
        var messageId = parseInt($(this).closest('.discord-message').data('messageid'));
        Discord_OpenEmojiPicker("react", messageId);
    });

    $(document).on('click', '.discord-emoji-picker-item', function() {
        var emoji = $(this).data('emoji');
        if (Discord.emojiPickerMode === "react" && Discord.emojiPickerTargetMessageId != null) {
            Discord_ToggleReaction(Discord.emojiPickerTargetMessageId, emoji);
        } else {
            var input = $("#discord-message-input");
            input.val(input.val() + emoji);
            input.focus();
        }
        Discord_CloseEmojiPicker();
    });

    $(document).on('click', function(e) {
        if ($("#discord-emoji-picker").hasClass("discord-visible") &&
            !$(e.target).closest('#discord-emoji-picker, #discord-emoji-btn, [data-action="react"], .discord-reaction-add-pill').length) {
            Discord_CloseEmojiPicker();
        }
    });

    // ----- message actions -----

    $(document).on('click', '.discord-message-actions i[data-action="edit"]', function() {
        var messageId = parseInt($(this).closest('.discord-message').data('messageid'));
        Discord_StartEditMessage(messageId);
    });

    $(document).on('click', '.discord-message-actions i[data-action="delete"]', function() {
        var messageId = parseInt($(this).closest('.discord-message').data('messageid'));
        Discord_DeleteMessageAction(messageId);
    });

    $(document).on('click', '.discord-message-actions i[data-action="pin"]', function() {
        var messageId = parseInt($(this).closest('.discord-message').data('messageid'));
        Discord_TogglePinAction(messageId);
    });

    $(document).on('click', '.discord-reaction-pill', function() {
        var messageId = parseInt($(this).closest('.discord-message').data('messageid'));
        var emoji = $(this).data('emoji');
        Discord_ToggleReaction(messageId, emoji);
    });

    // ----- members / kick -----

    $(document).on('click', '.discord-member-kick-btn', function(e) {
        e.stopPropagation();
        var memberRowId = parseInt($(this).closest('.discord-member-item').data('memberrowid'));
        Discord_KickMemberAction(memberRowId);
    });

    $(document).on('click', '.discord-member-admin-btn', function(e) {
        e.stopPropagation();
        var memberRowId = parseInt($(this).closest('.discord-member-item').data('memberrowid'));
        Discord_ToggleAdminAction(memberRowId);
    });

    // ----- server rail actions -----

    $(document).on('click', '#discord-add-server-btn, #discord-empty-create-btn', function() {
        Discord_OpenModal('discord-modal-create-server');
    });

    $(document).on('click', '#discord-join-server-btn, #discord-empty-join-btn', function() {
        $(".discord-modal-tab").removeClass("discord-modal-tab-active");
        $('.discord-modal-tab[data-tab="invite"]').addClass("discord-modal-tab-active");
        $(".discord-modal-tab-pane").removeClass("discord-modal-tab-pane-active");
        $("#discord-tab-invite").addClass("discord-modal-tab-pane-active");
        Discord_OpenModal('discord-modal-join-server');
    });

    $(document).on('click', '.discord-modal-tab', function() {
        var tab = $(this).data('tab');
        $(".discord-modal-tab").removeClass("discord-modal-tab-active");
        $(this).addClass("discord-modal-tab-active");
        $(".discord-modal-tab-pane").removeClass("discord-modal-tab-pane-active");
        $("#discord-tab-" + tab).addClass("discord-modal-tab-pane-active");

        if (tab === "discover") Discord_LoadDiscoverList();
        else if (tab === "vip") Discord_LoadVIPList();
    });

    $(document).on('click', '#discord-server-menu-btn', function() { Discord_OpenServerMenu(); });

    $(document).on('click', '#discord-add-channel-btn, #discord-create-channel-open-btn', function() {
        Discord_OpenModal('discord-modal-create-channel');
    });


    $(document).on('click', '#discord-open-settings-btn', function() { Discord_OpenServerSettings(); });

    // ----- modal confirm/cancel -----

    $(document).on('click', '[data-discordmodalclose="1"]', function() { Discord_CloseModals(); });

    $(document).on('click', '#discord-modal-overlay', function(e) {
        if (e.target.id === 'discord-modal-overlay') Discord_CloseModals();
    });

    $(document).on('click', '#discord-confirm-create-server', function() {
        var name = $("#discord-new-server-name").val().trim();
        if (name === "") { Discord_ShowModalError('discord-modal-create-server', 'Enter a server name.'); return; }

        Discord_Post('CreateDiscordServer', { name: name }, function(result) {
            if (!result || !result.id) { Discord_ShowModalError('discord-modal-create-server', 'Could not create the server.'); return; }
            Discord.servers.push(result);
            Discord_CloseModals();
            Discord_SelectServer(result.id);
        });
    });

    $(document).on('click', '.discord-vip-join-btn', function() {
        var serverId = parseInt($(this).data('serverid'));

        Discord_Post('JoinDiscordVIPServer', { serverId: serverId }, function(result) {
            if (!result || result.error) return;
            Discord.servers.push(result);
            Discord_CloseModals();
            Discord_SelectServer(result.id);
        });
    });

    $(document).on('click', '.discord-discover-join-btn', function() {
        var serverId = parseInt($(this).data('serverid'));
        var btn = $(this);

        Discord_Post('JoinDiscordPublicServer', { serverId: serverId }, function(result) {
            if (!result || result.error) return;
            Discord.servers.push(result);
            Discord_CloseModals();
            Discord_SelectServer(result.id);
        });
    });

    $(document).on('click', '#discord-confirm-join-server', function() {
        var code = $("#discord-join-code-input").val().trim();
        if (code === "") { Discord_ShowModalError('discord-modal-join-server', 'Enter an invite code.'); return; }

        Discord_Post('JoinDiscordServer', { inviteCode: code }, function(result) {
            if (!result || result.error === "NOT_FOUND") { Discord_ShowModalError('discord-modal-join-server', 'No server found with that code.'); return; }
            if (result.error === "ALREADY_MEMBER") { Discord_ShowModalError('discord-modal-join-server', 'You are already in that server.'); return; }
            Discord.servers.push(result);
            Discord_CloseModals();
            Discord_SelectServer(result.id);
        });
    });

    $(document).on('click', '#discord-confirm-create-channel', function() {
        var name = $("#discord-new-channel-name").val().trim();
        if (name === "") { Discord_ShowModalError('discord-modal-create-channel', 'Enter a channel name.'); return; }
        if (Discord.currentServerId === null) return;

        Discord_Post('CreateDiscordChannel', { serverId: Discord.currentServerId, name: name }, function(result) {
            if (!result || !result.id) { Discord_ShowModalError('discord-modal-create-channel', 'Could not create the channel.'); return; }
            Discord.channels.push(result);
            Discord_RenderChannelList();
            Discord_CloseModals();
        });
    });

    $(document).on('click', '#discord-copy-invite', function() {
        var code = $("#discord-menu-invite-code").text();
        var temp = $('<input>').val(code).appendTo('body').select();
        try { document.execCommand('copy'); } catch (e) {}
        temp.remove();
    });

    $(document).on('click', '#discord-leave-server-btn', function() {
        if (Discord.currentServerId === null) return;
        var serverId = Discord.currentServerId;

        Discord_Post('LeaveDiscordServer', { serverId: serverId });
        Discord.servers = Discord.servers.filter(function(s) { return s.id !== serverId; });
        Discord_CloseModals();

        if (Discord.servers.length > 0) Discord_SelectServer(Discord.servers[0].id);
        else Discord_HandleServerDeleted({ serverId: serverId });
    });

    $(document).on('click', '#discord-delete-server-btn', function() {
        if (Discord.currentServerId === null) return;
        var serverId = Discord.currentServerId;

        Discord_Post('DeleteDiscordServer', { serverId: serverId }, function(result) {
            if (!result) return;
            Discord_CloseModals();
            Discord_HandleServerDeleted({ serverId: serverId });
        });
    });

    // ----- server settings -----

    $(document).on('click', '.discord-icon-swatch', function() {
        $(".discord-icon-swatch").removeClass("discord-swatch-selected");
        $(this).addClass("discord-swatch-selected");
    });

    $(document).on('click', '#discord-public-toggle-switch', function() {
        $(this).toggleClass("discord-toggle-on");
    });

    $(document).on('click', '#discord-regenerate-invite-btn', function() {
        if (Discord.currentServerId === null) return;

        Discord_Post('UpdateDiscordServerSettings', { serverId: Discord.currentServerId, regenerateInvite: true }, function(result) {
            if (!result) return;
            $("#discord-settings-invite-code").text(result.invite_code);
            var server = Discord_FindServer(Discord.currentServerId);
            if (server) server.invite_code = result.invite_code;
        });
    });

    $(document).on('click', '#discord-confirm-server-settings', function() {
        if (Discord.currentServerId === null) return;

        var name = $("#discord-settings-name-input").val().trim();
        var color = $(".discord-icon-swatch.discord-swatch-selected").data('color');
        var isPublic = $("#discord-public-toggle-switch").hasClass("discord-toggle-on");

        Discord_Post('UpdateDiscordServerSettings', { serverId: Discord.currentServerId, name: name, iconColor: color, isPublic: isPublic }, function(result) {
            if (!result) { Discord_ShowModalError('discord-modal-server-settings', 'Could not save changes.'); return; }
            var server = Discord_FindServer(Discord.currentServerId);
            if (server) server.isPublic = result.isPublic;
            Discord_CloseModals();
        });
    });

});

// ---------------------------------------------------------------------------
// Staff panel (game admins only — server re-checks this on every action,
// see server/main.lua's Discord_IsStaff + the DiscordStaffActions table)
// ---------------------------------------------------------------------------

function Discord_Staff(action, payload, cb) {
    Discord_Post('DiscordStaff', { action: action, payload: payload || {} }, cb);
}

function Discord_OpenStaffPanel() {
    $(".discord-staff-tab").removeClass("discord-staff-tab-active");
    $('.discord-staff-tab[data-stafftab="overview"]').addClass("discord-staff-tab-active");
    $(".discord-staff-pane").removeClass("discord-staff-pane-active");
    $("#discord-staffpane-overview").addClass("discord-staff-pane-active");

    Discord_OpenModal("discord-modal-staff");
    Discord_StaffLoadOverview();
}

function Discord_StaffSwitchTab(tab) {
    $(".discord-staff-tab").removeClass("discord-staff-tab-active");
    $('.discord-staff-tab[data-stafftab="' + tab + '"]').addClass("discord-staff-tab-active");
    $(".discord-staff-pane").removeClass("discord-staff-pane-active");
    $("#discord-staffpane-" + tab).addClass("discord-staff-pane-active");

    if (tab === "overview") Discord_StaffLoadOverview();
    else if (tab === "servers") Discord_StaffLoadServers("");
    else if (tab === "accounts") Discord_StaffLoadAccounts("");
    else if (tab === "bans") Discord_StaffLoadBans();
    else if (tab === "announce") Discord_StaffLoadAnnounceForm();
    else if (tab === "audit") Discord_StaffLoadAudit();
}

function Discord_StaffLoadOverview() {
    var el = $("#discord-staffpane-overview");
    el.html('<div class="discord-staff-empty">Loading...</div>');

    Discord_Staff("Overview", {}, function(r) {
        if (!r) { el.html('<div class="discord-staff-empty">Could not load.</div>'); return; }

        function stat(value, label) {
            return '<div class="discord-staff-stat"><div class="discord-staff-stat-value">' + value + '</div><div class="discord-staff-stat-label">' + label + '</div></div>';
        }

        el.html('<div class="discord-staff-stats">' +
            stat(r.servers, "Servers (" + r.verifiedServers + " verified)") +
            stat(r.channels, "Channels") +
            stat(r.accounts, "Discord accounts (" + r.verifiedAccounts + " verified)") +
            stat(r.messages, "Messages total") +
            stat(r.messagesToday, "Messages (24h)") +
            stat(r.bans, "Active bans") +
            '</div>');
    });
}

function Discord_StaffLoadServers(query) {
    var list = $("#discord-staff-server-list");
    list.html('<div class="discord-staff-empty">Loading...</div>');

    Discord_Staff("Servers", { query: query }, function(rows) {
        if (!rows || rows.length === 0) { list.html('<div class="discord-staff-empty">No servers found.</div>'); return; }

        var html = "";
        $.each(rows, function(i, s) {
            html += '<div class="discord-staff-row" data-serverid="' + s.id + '">' +
                    '<div class="discord-staff-row-main">' +
                    '<div class="discord-staff-row-icon" style="background-color:' + s.icon_color + '">' + Discord_Escape(s.icon_text) + '</div>' +
                    '<div class="discord-staff-row-info">' +
                    '<div class="discord-staff-row-title">' + Discord_Escape(s.name) + Discord_VerifiedBadge(s.isVerified) +
                    (s.isPublic ? '<span class="discord-staff-flag discord-staff-flag-public">Public</span>' : '') + '</div>' +
                    '<div class="discord-staff-row-sub">' + s.memberCount + ' members · ' + s.channelCount + ' channels · owner: ' + Discord_Escape(s.ownerName || "?") + ' · code ' + Discord_Escape(s.invite_code) + '</div>' +
                    '</div>' +
                    '<div class="discord-staff-row-actions">' +
                    '<div class="discord-staff-btn discord-staff-btn-blue discord-staff-toggle-server-verified" data-serverid="' + s.id + '">' + (s.isVerified ? 'Unverify' : 'Verify') + '</div>' +
                    '<div class="discord-staff-btn discord-staff-toggle-server-featured" data-serverid="' + s.id + '" style="background-color:#b491ff;"><i class="fas fa-gem"></i> ' + (s.isFeatured ? 'Unfeature' : 'Feature (VIP)') + '</div>' +
                    '<div class="discord-staff-btn discord-staff-btn-danger discord-staff-delete-server" data-serverid="' + s.id + '">Delete</div>' +
                    '<div class="discord-staff-btn discord-staff-toggle-server-channels" data-serverid="' + s.id + '">Channels</div>' +
                    '</div></div>' +
                    '<div class="discord-staff-channels" id="discord-staff-channels-' + s.id + '" style="display:none;"></div>' +
                    '</div>';
        });
        list.html(html);
    });
}

function Discord_StaffToggleChannels(serverId) {
    var box = $("#discord-staff-channels-" + serverId);
    if (box.is(":visible")) { box.hide(); return; }

    box.html('<div class="discord-staff-empty">Loading...</div>').show();
    Discord_Staff("ServerChannels", { serverId: serverId }, function(rows) {
        if (!rows || rows.length === 0) { box.html('<div class="discord-staff-empty">No channels.</div>'); return; }

        var html = "";
        $.each(rows, function(i, c) {
            html += '<div class="discord-staff-channel-row"><i class="fas fa-hashtag"></i> ' + Discord_Escape(c.name) + Discord_VerifiedBadge(c.isVerified) +
                    (c.isLocked ? ' <i class="fas fa-lock" title="Locked"></i>' : '') +
                    '<div class="discord-staff-row-actions">' +
                    '<div class="discord-staff-btn discord-staff-btn-blue discord-staff-toggle-channel-verified" data-channelid="' + c.id + '" data-serverid="' + serverId + '">' + (c.isVerified ? 'Unverify' : 'Verify') + '</div>' +
                    '<div class="discord-staff-btn discord-staff-toggle-channel-locked" data-channelid="' + c.id + '" data-serverid="' + serverId + '">' + (c.isLocked ? 'Unlock' : 'Lock') + '</div>' +
                    '<div class="discord-staff-btn discord-staff-btn-danger discord-staff-delete-channel" data-channelid="' + c.id + '" data-serverid="' + serverId + '">Delete</div>' +
                    '</div></div>';
        });
        box.html(html);
    });
}

function Discord_StaffLoadAccounts(query) {
    var list = $("#discord-staff-account-list");
    list.html('<div class="discord-staff-empty">Loading...</div>');

    Discord_Staff("Accounts", { query: query }, function(rows) {
        if (!rows || rows.length === 0) { list.html('<div class="discord-staff-empty">No accounts found.</div>'); return; }

        var html = "";
        $.each(rows, function(i, a) {
            html += '<div class="discord-staff-row">' +
                    '<div class="discord-staff-row-main">' +
                    '<div class="discord-staff-row-icon" style="background-color:' + Discord_ColorFor(a.name) + '">' + Discord_Escape(Discord_Initials(a.name)) + '</div>' +
                    '<div class="discord-staff-row-info">' +
                    '<div class="discord-staff-row-title">' + Discord_Escape(a.name) + Discord_VerifiedBadge(a.isVerified) +
                    (a.isOnline ? '<span class="discord-staff-flag discord-staff-flag-online">Online</span>' : '') +
                    (a.isBanned ? '<span class="discord-staff-flag discord-staff-flag-banned">Banned</span>' : '') + '</div>' +
                    '<div class="discord-staff-row-sub">' + Discord_Escape(a.phone || "no phone") + ' · #' + Discord_Escape(a.discriminator || "0000") + ' · ' + a.serverCount + ' server(s)' + '</div>' +
                    '</div>' +
                    '<div class="discord-staff-row-actions">' +
                    '<div class="discord-staff-btn discord-staff-btn-blue discord-staff-toggle-account-verified" data-identifier="' + a.identifier + '">' + (a.isVerified ? 'Unverify' : 'Verify') + '</div>' +
                    (a.isBanned
                        ? '<div class="discord-staff-btn discord-staff-btn-green discord-staff-unban" data-identifier="' + a.identifier + '">Unban</div>'
                        : '<div class="discord-staff-btn discord-staff-btn-danger discord-staff-open-ban" data-identifier="' + a.identifier + '" data-name="' + Discord_Escape(a.name) + '">Ban</div>') +
                    '</div></div>' +
                    '<div class="discord-staff-banform" id="discord-staff-banform-' + a.identifier.replace(/[^a-zA-Z0-9]/g, "") + '" style="display:none;"></div>' +
                    '</div>';
        });
        list.html(html);
    });
}

function Discord_StaffOpenBanForm(identifier, name) {
    var safeId = identifier.replace(/[^a-zA-Z0-9]/g, "");
    var box = $("#discord-staff-banform-" + safeId);
    if (box.is(":visible")) { box.hide(); return; }

    box.html(
        '<input type="text" class="discord-staff-input" placeholder="Reason" data-role="reason" dir="auto">' +
        '<select class="discord-staff-select" data-role="hours" style="margin:0;">' +
        '<option value="0">Permanent</option><option value="1">1 hour</option><option value="24">24 hours</option><option value="168">7 days</option><option value="720">30 days</option>' +
        '</select>' +
        '<label><input type="checkbox" data-role="purge"> Delete their messages</label>' +
        '<div class="discord-staff-btn discord-staff-btn-danger discord-staff-confirm-ban" data-identifier="' + identifier + '">Confirm Ban</div>'
    ).show();
}

function Discord_StaffLoadBans() {
    var list = $("#discord-staff-ban-list");
    list.html('<div class="discord-staff-empty">Loading...</div>');

    Discord_Staff("Bans", {}, function(rows) {
        if (!rows || rows.length === 0) { list.html('<div class="discord-staff-empty">No one is banned.</div>'); return; }

        var html = "";
        $.each(rows, function(i, b) {
            var expires = b.expires_at ? new Date(b.expires_at * 1000).toLocaleString() : "Permanent";
            html += '<div class="discord-staff-row">' +
                    '<div class="discord-staff-row-main">' +
                    '<div class="discord-staff-row-icon" style="background-color:' + Discord_ColorFor(b.name) + '">' + Discord_Escape(Discord_Initials(b.name)) + '</div>' +
                    '<div class="discord-staff-row-info">' +
                    '<div class="discord-staff-row-title">' + Discord_Escape(b.name) + '</div>' +
                    '<div class="discord-staff-row-sub">' + Discord_Escape(b.reason) + ' — by ' + Discord_Escape(b.banned_by) + ' · expires: ' + expires + '</div>' +
                    '</div>' +
                    '<div class="discord-staff-row-actions"><div class="discord-staff-btn discord-staff-btn-green discord-staff-unban" data-identifier="' + b.identifier + '">Unban</div></div>' +
                    '</div></div>';
        });
        list.html(html);
    });
}

function Discord_StaffLoadAnnounceForm() {
    Discord_Staff("Servers", { query: "" }, function(rows) {
        var serverSelect = $("#discord-announce-server").empty();
        $.each(rows || [], function(i, s) { serverSelect.append('<option value="' + s.id + '">' + Discord_Escape(s.name) + '</option>'); });

        var channelSelect = $("#discord-announce-channel").empty();
        if (rows && rows[0]) Discord_StaffPopulateChannelSelect(rows[0].id);
    });
}

function Discord_StaffPopulateChannelSelect(serverId) {
    Discord_Staff("ServerChannels", { serverId: serverId }, function(rows) {
        var sel = $("#discord-announce-channel").empty();
        $.each(rows || [], function(i, c) { sel.append('<option value="' + c.id + '">#' + Discord_Escape(c.name) + '</option>'); });
    });
}

function Discord_StaffLoadAudit() {
    var list = $("#discord-staff-audit-list");
    list.html('<div class="discord-staff-empty">Loading...</div>');

    Discord_Staff("Audit", {}, function(rows) {
        if (!rows || rows.length === 0) { list.html('<div class="discord-staff-empty">No actions logged yet.</div>'); return; }

        var html = "";
        $.each(rows, function(i, a) {
            html += '<div class="discord-staff-row">' +
                    '<div class="discord-staff-row-title">' + Discord_Escape(a.action) + '</div>' +
                    '<div class="discord-staff-row-sub">' + Discord_Escape(a.target) + ' — ' + Discord_Escape(a.staff_name) + ' · ' + new Date(a.created_at * 1000).toLocaleString() + '</div>' +
                    '</div>';
        });
        list.html(html);
    });
}

// ---------------------------------------------------------------------------
// Staff panel event bindings
// ---------------------------------------------------------------------------

$(document).ready(function() {

    $(document).on('click', '#discord-staff-btn', function() { Discord_OpenStaffPanel(); });
    $(document).on('click', '.discord-staff-tab', function() { Discord_StaffSwitchTab($(this).data('stafftab')); });

    var serverSearchTimer = null;
    $(document).on('input', '#discord-staff-server-search', function() {
        var q = $(this).val();
        clearTimeout(serverSearchTimer);
        serverSearchTimer = setTimeout(function() { Discord_StaffLoadServers(q); }, 300);
    });

    var acctSearchTimer = null;
    $(document).on('input', '#discord-staff-account-search', function() {
        var q = $(this).val();
        clearTimeout(acctSearchTimer);
        acctSearchTimer = setTimeout(function() { Discord_StaffLoadAccounts(q); }, 300);
    });

    $(document).on('click', '.discord-staff-toggle-server-verified', function() {
        var id = parseInt($(this).data('serverid'));
        Discord_Staff("ToggleServerVerified", { serverId: id }, function() { Discord_StaffLoadServers($("#discord-staff-server-search").val()); });
    });

    $(document).on('click', '.discord-staff-toggle-server-featured', function() {
        var id = parseInt($(this).data('serverid'));
        Discord_Staff("ToggleServerFeatured", { serverId: id }, function() { Discord_StaffLoadServers($("#discord-staff-server-search").val()); });
    });

    $(document).on('click', '.discord-staff-delete-server', function() {
        var id = parseInt($(this).data('serverid'));
        Discord_Staff("DeleteServer", { serverId: id }, function(r) {
            if (r) {
                Discord_StaffLoadServers($("#discord-staff-server-search").val());
                if (Discord.currentServerId === id) Discord_HandleServerDeleted({ serverId: id });
            }
        });
    });

    $(document).on('click', '.discord-staff-toggle-server-channels', function() {
        Discord_StaffToggleChannels(parseInt($(this).data('serverid')));
    });

    $(document).on('click', '.discord-staff-toggle-channel-verified', function() {
        var cid = parseInt($(this).data('channelid')), sid = parseInt($(this).data('serverid'));
        Discord_Staff("ToggleChannelVerified", { channelId: cid }, function() { Discord_StaffToggleChannels(sid); Discord_StaffToggleChannels(sid); });
    });

    $(document).on('click', '.discord-staff-toggle-channel-locked', function() {
        var cid = parseInt($(this).data('channelid')), sid = parseInt($(this).data('serverid'));
        Discord_Staff("ToggleChannelLocked", { channelId: cid }, function() { Discord_StaffToggleChannels(sid); Discord_StaffToggleChannels(sid); });
    });

    $(document).on('click', '.discord-staff-delete-channel', function() {
        var cid = parseInt($(this).data('channelid')), sid = parseInt($(this).data('serverid'));
        Discord_Staff("DeleteChannel", { channelId: cid }, function(r) {
            if (r) Discord_StaffToggleChannels(sid), Discord_StaffToggleChannels(sid);
        });
    });

    $(document).on('click', '.discord-staff-toggle-account-verified', function() {
        var id = $(this).data('identifier');
        Discord_Staff("ToggleAccountVerified", { identifier: id }, function() { Discord_StaffLoadAccounts($("#discord-staff-account-search").val()); });
    });

    $(document).on('click', '.discord-staff-open-ban', function() {
        Discord_StaffOpenBanForm($(this).data('identifier'), $(this).data('name'));
    });

    $(document).on('click', '.discord-staff-confirm-ban', function() {
        var identifier = $(this).data('identifier');
        var form = $(this).closest('.discord-staff-banform');
        var reason = form.find('[data-role="reason"]').val();
        var hours = form.find('[data-role="hours"]').val();
        var purge = form.find('[data-role="purge"]').is(':checked');

        Discord_Staff("Ban", { identifier: identifier, reason: reason, hours: hours, purge: purge }, function(r) {
            Discord_StaffLoadAccounts($("#discord-staff-account-search").val());
        });
    });

    $(document).on('click', '.discord-staff-unban', function() {
        var id = $(this).data('identifier');
        Discord_Staff("Unban", { identifier: id }, function() {
            Discord_StaffLoadAccounts($("#discord-staff-account-search").val());
            Discord_StaffLoadBans();
        });
    });

    $(document).on('change', '#discord-announce-scope', function() {
        var scope = $(this).val();
        $("#discord-announce-server").toggle(scope === "server" || scope === "channel");
        $("#discord-announce-channel").toggle(scope === "channel");
        if (scope === "channel") Discord_StaffPopulateChannelSelect($("#discord-announce-server").val());
    });

    $(document).on('change', '#discord-announce-server', function() {
        if ($("#discord-announce-scope").val() === "channel") Discord_StaffPopulateChannelSelect($(this).val());
    });

    $(document).on('click', '#discord-announce-send-btn', function() {
        var scope = $("#discord-announce-scope").val();
        var text = $("#discord-announce-text").val().trim();
        if (text === "") return;

        Discord_Staff("Announce", {
            scope: scope,
            serverId: parseInt($("#discord-announce-server").val()) || null,
            channelId: parseInt($("#discord-announce-channel").val()) || null,
            text: text,
        }, function(r) {
            if (r && r.posted) {
                $("#discord-announce-result").text("Sent to " + r.posted + " channel(s).");
                $("#discord-announce-text").val("");
            } else {
                $("#discord-announce-result").text("Failed to send.");
            }
        });
    });

});
