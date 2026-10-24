// ============================================================================
// Discord login / sign-up screen (mailbox + code). Loaded after discord_discover.js.
// Keeps every id and handler of the original screen; adds: step tracker,
// 6 code boxes (paste supported), code expiry countdown, resend countdown,
// copy-the-site button and tips. The server contract is unchanged.
// ============================================================================

var DXL = { expireTimer: null, expireAt: 0, codeTtl: 600 };

function DXL_Build() {
    var box = $(".discord-login-box");
    if (!box.length || $("#dxl-steps").length) return;

    box.prepend('<div id="dxl-steps"><div class="dxl-step dxl-on" data-step="1"><span>1</span>Mailbox</div>' +
                '<div class="dxl-line"></div><div class="dxl-step" data-step="2"><span>2</span>Code</div>' +
                '<div class="dxl-line"></div><div class="dxl-step" data-step="3"><span>3</span>Done</div></div>');

    $("#discord-login-step-mailbox").prepend('<div class="dxl-help">Choose a name for your mailbox. Your login code will be delivered there.</div>');
    $("#discord-login-step-mailbox").append(
        '<div class="dxl-tips"><div><i class="fas fa-shield-alt"></i> One mailbox belongs to one character.</div>' +
        '<div><i class="fas fa-clock"></i> Codes are valid for 10 minutes.</div>' +
        '<div><i class="fas fa-inbox"></i> Not in the inbox? Check spam or junk.</div></div>');

    var code = $("#discord-login-step-code");
    code.prepend('<div class="dxl-boxes" id="dxl-boxes">' +
        [0,1,2,3,4,5].map(function(i) { return '<input class="dxl-box" maxlength="1" inputmode="numeric" autocomplete="off" data-i="' + i + '">'; }).join("") +
        '</div><div class="dxl-expiry" id="dxl-expiry"></div>');
    $("#discord-login-code-input").addClass("dxl-hidden");

    $("#discord-login-site-link-2").after(' <span class="dxl-copy" id="dxl-copy" title="Copy the address"><i class="fas fa-copy"></i></span>');
    $("#discord-login-site-link").after(' <span class="dxl-copy" id="dxl-copy1" title="Copy the address"><i class="fas fa-copy"></i></span>');
    code.append('<div class="dxl-tips"><div><i class="fas fa-inbox"></i> Open the mailbox page above and read the newest message.</div></div>');
}

function DXL_SetStep(n) {
    $("#dxl-steps .dxl-step").each(function() {
        var s = parseInt($(this).attr("data-step"), 10);
        $(this).toggleClass("dxl-on", s <= n).toggleClass("dxl-now", s === n);
    });
    $("#dxl-steps .dxl-line").each(function(i) { $(this).toggleClass("dxl-on", i + 1 < n); });
}

function DXL_Compact() {
    return $("#dxl-boxes .dxl-box").map(function() { return ($(this).val() || "").replace(/\D/g, ""); }).get().join("");
}
function DXL_SyncBoxes() {
    var hidden = ($("#discord-login-code-input").val() || "").replace(/\D/g, "");
    if (hidden === DXL_Compact()) return; // already the same: never move the user's cursor or gaps
    var digits = hidden.split("");
    $("#dxl-boxes .dxl-box").each(function(i) { $(this).val(digits[i] || ""); });
}
function DXL_Push() { $("#discord-login-code-input").val(DXL_Compact()).trigger("input"); }
function DXL_Fill(start, digits) {
    $("#dxl-boxes .dxl-box").each(function(i) {
        if (i >= start && i - start < digits.length) $(this).val(digits.charAt(i - start));
    });
    DXL_Push();
    var next = Math.min(start + digits.length, 5);
    $("#dxl-boxes .dxl-box").eq(next).focus();
}

function DXL_StartExpiry() {
    clearInterval(DXL.expireTimer);
    DXL.expireAt = Date.now() + DXL.codeTtl * 1000;
    $("#discord-login-verify-btn").removeClass("dxl-disabled");
    var tick = function() {
        var left = Math.max(0, Math.round((DXL.expireAt - Date.now()) / 1000));
        var m = Math.floor(left / 60), s = left % 60;
        if (left <= 0) {
            clearInterval(DXL.expireTimer);
            $("#dxl-expiry").addClass("dxl-expired").text("This code has expired. Request a new one.");
            $("#discord-login-verify-btn").addClass("dxl-disabled");
            return;
        }
        $("#dxl-expiry").removeClass("dxl-expired").text("Code expires in " + m + ":" + (s < 10 ? "0" : "") + s);
    };
    tick();
    DXL.expireTimer = setInterval(tick, 1000);
}

$(function() {
    DXL_Build();

    // step changes follow the original screen's show/hide
    var mb = document.getElementById("discord-login-step-mailbox"), cd = document.getElementById("discord-login-step-code");
    if (window.MutationObserver && mb && cd) {
        new MutationObserver(function() {
            var codeOn = $(cd).css("display") !== "none";
            DXL_SetStep(codeOn ? 2 : 1);
            if (codeOn) { DXL_SyncBoxes(); DXL_StartExpiry(); setTimeout(function() { $("#dxl-boxes .dxl-box").first().focus(); }, 30); }
        }).observe(mb, { attributes: true, attributeFilter: ["style"] });
        new MutationObserver(function() { DXL_SetStep(2); }).observe(cd, { attributes: true, attributeFilter: ["style"] });
    }
    $(document).on("click", "#discord-login-back-btn", function() { clearInterval(DXL.expireTimer); DXL_SetStep(1); });

    // the server clears the hidden field after a wrong code without an input event: keep the boxes in step
    setInterval(function() { if ($("#discord-login-step-code").css("display") !== "none") DXL_SyncBoxes(); }, 120);

    // the screen opens at step 1
    DX_After("Discord_ShowLoginScreen", function() { clearInterval(DXL.expireTimer); DXL_SetStep(1); });

    // 6 boxes <-> the real input (boxes keep their positions; the hidden field is their digits)
    $(document).on("input", "#dxl-boxes .dxl-box", function() {
        var i = parseInt($(this).attr("data-i"), 10);
        var d = ($(this).val() || "").replace(/\D/g, "");
        if (d.length > 1) { DXL_Fill(i, d); return; }
        $(this).val(d);
        DXL_Push();
        if (d && i < 5) $("#dxl-boxes .dxl-box").eq(i + 1).focus();
    });
    $(document).on("keydown", "#dxl-boxes .dxl-box", function(e) {
        var i = parseInt($(this).attr("data-i"), 10);
        if (e.key === "Backspace" && !$(this).val() && i > 0) {
            e.preventDefault();
            $("#dxl-boxes .dxl-box").eq(i - 1).val("").focus();
            DXL_Push();
        }
        if (e.key === "ArrowLeft" && i > 0) $("#dxl-boxes .dxl-box").eq(i - 1).focus();
        if (e.key === "ArrowRight" && i < 5) $("#dxl-boxes .dxl-box").eq(i + 1).focus();
    });
    $(document).on("paste", "#dxl-boxes .dxl-box", function(e) {
        var txt = (e.originalEvent.clipboardData || window.clipboardData).getData("text") || "";
        var digits = txt.replace(/\D/g, "").slice(0, 6);
        if (!digits) return;
        e.preventDefault();
        $("#dxl-boxes .dxl-box").val(""); // a paste replaces the whole code
        DXL_Fill(0, digits);
    });

    // copy the mailbox site address
    $(document).on("click", "#dxl-copy, #dxl-copy1", function() {
        var t = $("#discord-login-site-link").text() || "arshiahub.ir/mail";
        var tmp = $("<input>").val("https://" + t).appendTo("body").select();
        try { document.execCommand("copy"); } catch (e) {}
        tmp.remove();
        if (window.DX_Toast) DX_Toast("Address copied: " + t, "success");
    });
});
