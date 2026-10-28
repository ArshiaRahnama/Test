// ============================================================================
// Discord v15 — offline drafts (per channel / DM, kept on this phone) and
// profile banner images (URL or gallery). Loaded after discord_v14.js.
// ============================================================================

var DXW = { mem: {}, prevDraftKey: null };

// ---------------------------------------------------------------------------
// 28) Drafts: an unsent message stays when you switch channel or close the phone
// ---------------------------------------------------------------------------

function DXW_Store() {
    try { return window.localStorage; } catch (e) { return null; }
}
function DXW_Key() {
    if (DXD && DXD.mode === "dm" && DXD.dmId) return "dxdraft:dm:" + DXD.dmId;
    if (Discord.currentChannelId) return "dxdraft:ch:" + Discord.currentChannelId;
    return null;
}
function DXW_Get(key) {
    var s = DXW_Store();
    if (s) { try { return s.getItem(key) || ""; } catch (e) {} }
    return DXW.mem[key] || "";
}
function DXW_Set(key, val) {
    if (!val) { DXW_Del(key); return; }
    val = String(val).slice(0, 2000);
    var s = DXW_Store();
    if (s) { try { s.setItem(key, val); return; } catch (e) {} }
    DXW.mem[key] = val;
}
function DXW_Del(key) {
    var s = DXW_Store();
    if (s) { try { s.removeItem(key); } catch (e) {} }
    delete DXW.mem[key];
}
function DXW_Restore() {
    var key = DXW_Key();
    var input = $("#discord-message-input");
    if (!key || !input.length || input.prop("disabled")) return;
    if (input.val()) return;
    var saved = DXW_Get(key);
    if (saved) { input.val(saved).trigger("input"); }
}

$(document).on("input", "#discord-message-input", function() {
    var key = DXW_Key();
    if (!key) return;
    DXW_Set(key, $(this).val());
});
DX_After("Discord_OpenChannel", function() { setTimeout(DXW_Restore, 60); });
// a sent message must not come back as a draft: after a send, an empty box clears the saved text
DX_After("Discord_SendMessage", function() {
    var key = DXW_Key();
    setTimeout(function() {
        if (key && !$("#discord-message-input").val()) DXW_Del(key);
    }, 200);
});
DX_After("Discord_OpenMemberProfile", function() {});
(function() {
    var orig = window.DXD_OpenDm;
    if (typeof orig !== "function") return;
    window.DXD_OpenDm = function() {
        var r = orig.apply(this, arguments);
        setTimeout(DXW_Restore, 80);
        return r;
    };
})();

// ---------------------------------------------------------------------------
// 26) Profile banner: a picture for your profile card (URL or gallery)
// ---------------------------------------------------------------------------

function DXW_ApplyBanner(el, url, color) {
    if (!el) return;
    if (url) {
        el.style.backgroundImage = 'url("' + String(url).replace(/"/g, "%22") + '")';
        el.style.backgroundSize = "cover";
        el.style.backgroundPosition = "center";
    } else {
        el.style.backgroundImage = "";
    }
    if (color) el.style.backgroundColor = color;
}

// the profile popout: show the member's banner
DX_After("Discord_OpenMemberProfile", function(memberId) {
    var tries = 0;
    var t = setInterval(function() {
        tries++;
        var card = $("#discord-modal-profile-view");
        if ((card.length && card.hasClass("discord-modal-active") && card.find("#discord-pv-name").text().trim() !== "") || tries > 15) {
            clearInterval(t);
            var m = (DX.meta[Discord.currentServerId] || {})[String(memberId)] || {};
            DXW_ApplyBanner(card.find(".discord-profile-banner")[0], m.banner);
        }
    }, 80);
});

// the editor: banner row next to the avatar row
DX_After("Discord_OpenProfileEditor", function() {
    var m = $("#discord-modal-profile-edit");
    if (!m.length) return;
    m.find(".dxw-banner").remove();
    m.find(".discord-modal-title").after(
        '<div class="dxw-banner"><div class="discord-settings-label">Profile banner</div>' +
        '<div class="dxw-banner-preview" id="dxw-banner-preview"></div>' +
        '<div class="dxw-banner-row"><input type="text" id="dxw-banner-url" maxlength="400" placeholder="https://\u2026 image link" spellcheck="false">' +
        '<div class="dx-btn dx-primary" id="dxw-banner-save">Save</div>' +
        '<div class="dx-btn" id="dxw-banner-gallery"><i class="fas fa-images"></i> Gallery</div>' +
        '<div class="dx-btn" id="dxw-banner-remove">Remove</div></div></div>');
    DX_Post("DiscordExt_GetMyDiscord", {}, function(r) {
        DXW.myBanner = (r && r.banner) || null;
        DXW_ApplyBanner(document.getElementById("dxw-banner-preview"), DXW.myBanner, "#5865F2");
    });
});
function DXW_SaveBanner(url) {
    DX_Post("DiscordExt_SetBanner", { url: url }, function(r) {
        if (!r || !r.ok) { if (window.DX_Toast) DX_Toast(r && r.error === "BAD_URL" ? "That link isn't allowed. Use a direct https image link or a gallery photo." : "Could not save the banner.", "error"); return; }
        DXW.myBanner = r.banner || null;
        DXW_ApplyBanner(document.getElementById("dxw-banner-preview"), DXW.myBanner, "#5865F2");
        $("#dxw-banner-url").val(DXW.myBanner || "");
        if (window.DX_Toast) DX_Toast(DXW.myBanner ? "Banner updated." : "Banner removed.", "success");
    });
}
$(document).on("click", "#dxw-banner-save", function() { DXW_SaveBanner(($("#dxw-banner-url").val() || "").trim()); });
$(document).on("click", "#dxw-banner-remove", function() { DXW_SaveBanner(""); });
$(document).on("click", "#dxw-banner-gallery", function() {
    if (typeof DXD_PickImage !== "function") return;
    DXD_PickImage(function(url) { DXW_SaveBanner(url); });
});
