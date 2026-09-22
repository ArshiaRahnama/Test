// ─────────────────────────────────────────────────────────
// Security app — shows recent login devices (from Unique_Login's
// login_audit table) and lets the player force-logout every device,
// including the current one, if they suspect their account is compromised.
// ─────────────────────────────────────────────────────────

var SecurityBusy = false;
var SecurityChangeBusy = false;

function timeAgoFa(dateStr) {
    if (!dateStr) return "نامشخص";
    var then = new Date(dateStr.replace(' ', 'T'));
    var now = new Date();
    var diffSec = Math.floor((now - then) / 1000);
    if (isNaN(diffSec)) return dateStr;
    if (diffSec < 60) return "چند لحظه پیش";
    if (diffSec < 3600) return Math.floor(diffSec / 60) + " دقیقه پیش";
    if (diffSec < 86400) return Math.floor(diffSec / 3600) + " ساعت پیش";
    return Math.floor(diffSec / 86400) + " روز پیش";
}

function actionIcon(action) {
    if (action === "register") return "fa-user-plus";
    if (action === "new_device") return "fa-triangle-exclamation";
    return "fa-right-to-bracket";
}

function actionLabelFa(action) {
    if (action === "register") return "ثبت‌نام";
    if (action === "new_device") return "دستگاه جدید";
    return "ورود";
}

function memberSinceFa(unixSeconds) {
    if (!unixSeconds) return "-";
    var d = new Date(unixSeconds * 1000);
    var diffDays = Math.floor((Date.now() - d.getTime()) / 86400000);
    if (diffDays < 1) return "امروز";
    if (diffDays < 30) return diffDays + " روز پیش";
    if (diffDays < 365) return Math.floor(diffDays / 30) + " ماه پیش";
    return Math.floor(diffDays / 365) + " سال پیش";
}

// EXPANSION: cosmetic-but-motivating "security score" — not a real risk
// model, just a friendly gauge built from three signals we already have:
// no active lock, more than one trusted device seen, and account age.
// Circle circumference = 2*pi*42 ≈ 264 (matches stroke-dasharray in CSS).
var SECURITY_SCORE_CIRCUMFERENCE = 264;

function renderSecurityScore(data) {
    var score = 40; // baseline just for having an account at all
    if (!data.securityHold) score += 40;
    if (Array.isArray(data.devices) && data.devices.length >= 1) score += 10;
    if (data.createdAtUnix && (Date.now() / 1000 - data.createdAtUnix) > 86400 * 7) score += 10;
    score = Math.max(0, Math.min(100, score));

    var color = "#00e0bb";
    var label = "حساب شما امن به‌نظر می‌رسه";
    if (data.securityHold) {
        color = "#ff6b6b";
        label = "اکانت قفل امنیتی داره — با «فراموشی رمز» بازش کن";
    } else if (score < 70) {
        color = "#ffb020";
        label = "بد نیست یه بار دستگاه‌های اخیر رو چک کنی";
    }

    var offset = SECURITY_SCORE_CIRCUMFERENCE - (score / 100) * SECURITY_SCORE_CIRCUMFERENCE;
    $("#security-score-fill").css({ "stroke": color, "stroke-dashoffset": offset });
    $("#security-score-value").text(score);
    $("#security-score-label").text(label);

    $("#security-stat-username").text(data.username || "-");
    $("#security-stat-member-since").text(memberSinceFa(data.createdAtUnix));
    $("#security-stat-device-count").text(
        (Array.isArray(data.devices) ? data.devices.length : 0) + " دستگاه ثبت‌شده"
    );
}

SetupSecurityDevices = function (data) {
    $("#security-devices").html("");

    if (!data || !data.devices) {
        $("#security-account-summary").html('<span>خطا در دریافت اطلاعات.</span>');
        return;
    }

    renderSecurityScore(data);

    var statusBadge = data.securityHold
        ? '<span class="security-status-badge status-locked"><i class="fas fa-lock"></i> قفل امنیتی</span>'
        : '<span class="security-status-badge status-ok"><i class="fas fa-check"></i> عادی</span>';

    $("#security-account-summary").html(
        '<span>' + (data.username || "-") + '</span>' + statusBadge
    );

    if (data.devices.length === 0) {
        $("#security-devices").html('<div class="security-empty"><i class="fas fa-inbox"></i><br>هنوز هیچ دستگاهی ثبت نشده.</div>');
        return;
    }

    $.each(data.devices, function (i, device) {
        var isCurrent = device.device_license === data.currentDeviceLicense;
        var tag = isCurrent ? '<span class="device-row-current-tag">همین دستگاه</span>' : '';

        var el =
            '<div class="device-row' + (isCurrent ? ' device-current' : '') + '">' +
                '<div class="device-row-icon"><i class="fas ' + actionIcon(device.action) + '"></i></div>' +
                '<div class="device-row-info">' +
                    '<b>دستگاه #' + (i + 1) + '</b>' +
                    '<span>' + actionLabelFa(device.action) + ' · ' + timeAgoFa(device.created_at) + '</span>' +
                '</div>' +
                tag +
            '</div>';

        $("#security-devices").append(el);
    });
};

$(document).on('click', '#security-logout-all', function (e) {
    e.preventDefault();
    if (SecurityBusy) return;
    $("#security-confirm-overlay").css({ display: "block" });
});

$(document).on('click', '#security-confirm-cancel', function (e) {
    e.preventDefault();
    $("#security-confirm-overlay").css({ display: "none" });
});

$(document).on('click', '#security-confirm-yes', function (e) {
    e.preventDefault();
    if (SecurityBusy) return;
    SecurityBusy = true;

    $("#security-confirm-overlay").css({ display: "none" });
    $("#security-logout-all").addClass("security-disabled").html('<i class="fas fa-spinner fa-spin"></i> در حال خروج...');

    $.post('http://Unique_Phone/LogoutAllDevices', JSON.stringify({}), function (result) {
        // The player gets dropped server-side right after this — nothing
        // else to do here, but reset the button state just in case the
        // drop is delayed for any reason.
        setTimeout(function () {
            SecurityBusy = false;
            $("#security-logout-all").removeClass("security-disabled")
                .html('<i class="fas fa-power-off"></i> خروج از همه‌ی دستگاه‌ها');
        }, 4000);
    });
});

// ── Change password (two-step: current password -> SMS OTP) ───────────
var securityPendingNewPassword = null;

function securityResetStep1() {
    $("#security-old-password, #security-new-password, #security-confirm-password").val("");
    $("#security-step1-msg").removeClass("security-msg-error security-msg-ok").text("");
}

function securityShowStep1() {
    securityPendingNewPassword = null;
    $("#security-pw-step2").hide();
    $("#security-pw-step1").show();
    $("#security-otp-code").val("");
    $("#security-step2-msg").removeClass("security-msg-error security-msg-ok").text("");
}

function securityShowStep2(maskedPhone) {
    $("#security-masked-phone").text(maskedPhone || "شماره‌ی ثبت‌شده");
    $("#security-pw-step1").hide();
    $("#security-pw-step2").show();
    $("#security-otp-code").val("").focus();
}

$(document).on('click', '#security-request-otp-btn', function (e) {
    e.preventDefault();
    if (SecurityChangeBusy) return;

    var oldPassword = $("#security-old-password").val() || "";
    var newPassword = $("#security-new-password").val() || "";
    var confirmPassword = $("#security-confirm-password").val() || "";
    var msgEl = $("#security-step1-msg");

    msgEl.removeClass("security-msg-error security-msg-ok").text("");

    if (!oldPassword || !newPassword || !confirmPassword) {
        msgEl.addClass("security-msg-error").text("همه‌ی فیلدها رو پر کن.");
        return;
    }
    if (newPassword.length < 6) {
        msgEl.addClass("security-msg-error").text("رمز جدید باید حداقل ۶ کاراکتر باشه.");
        return;
    }
    if (newPassword !== confirmPassword) {
        msgEl.addClass("security-msg-error").text("رمز جدید و تکرارش یکسان نیست.");
        return;
    }

    SecurityChangeBusy = true;
    $("#security-request-otp-btn").addClass("security-disabled").html('<i class="fas fa-spinner fa-spin"></i> در حال بررسی...');

    $.post('http://Unique_Phone/RequestPasswordChangeOtp', JSON.stringify({
        oldPassword: oldPassword
    }), function (result) {
        SecurityChangeBusy = false;
        $("#security-request-otp-btn").removeClass("security-disabled").html('<i class="fas fa-paper-plane"></i> ارسال کد تأیید');

        if (result && result.success) {
            securityPendingNewPassword = newPassword;
            securityShowStep2(result.maskedPhone);
        } else if (result && result.reason === "wrong_old_password") {
            msgEl.addClass("security-msg-error").text("رمز فعلی اشتباه است.");
        } else if (result && result.reason === "rate_limited") {
            msgEl.addClass("security-msg-error").text("تعداد درخواست‌ها زیاده، کمی بعد دوباره تلاش کن.");
        } else {
            msgEl.addClass("security-msg-error").text("خطا در ارسال کد. دوباره تلاش کن.");
        }
    });
});

$(document).on('click', '#security-back-to-step1', function (e) {
    e.preventDefault();
    if (SecurityChangeBusy) return;
    securityShowStep1();
    securityResetStep1();
});

$(document).on('click', '#security-resend-otp', function (e) {
    e.preventDefault();
    // Re-sending just means going through step 1 again with the same
    // old/new password already typed — simplest way to reuse the same
    // rate-limited SendSMSCode path server-side without duplicating logic.
    var el = $(this);
    if (el.hasClass("security-disabled")) return;
    el.addClass("security-disabled");
    setTimeout(function () { el.removeClass("security-disabled"); }, 15000);
    $("#security-request-otp-btn").trigger("click");
});

$(document).on('click', '#security-confirm-otp-btn', function (e) {
    e.preventDefault();
    if (SecurityChangeBusy) return;

    var code = $("#security-otp-code").val() || "";
    var msgEl = $("#security-step2-msg");
    msgEl.removeClass("security-msg-error security-msg-ok").text("");

    if (!/^\d{6}$/.test(code)) {
        msgEl.addClass("security-msg-error").text("کد باید ۶ رقم باشه.");
        return;
    }
    if (!securityPendingNewPassword) {
        msgEl.addClass("security-msg-error").text("نشست منقضی شد، از اول امتحان کن.");
        securityShowStep1();
        return;
    }

    SecurityChangeBusy = true;
    $("#security-confirm-otp-btn").addClass("security-disabled").html('<i class="fas fa-spinner fa-spin"></i> در حال تأیید...');

    $.post('http://Unique_Phone/ConfirmPasswordChange', JSON.stringify({
        code: code,
        newPassword: securityPendingNewPassword
    }), function (result) {
        SecurityChangeBusy = false;
        $("#security-confirm-otp-btn").removeClass("security-disabled").html('<i class="fas fa-check"></i> تأیید و تغییر رمز');

        if (result && result.success) {
            msgEl.addClass("security-msg-ok").text("رمز عبور با موفقیت تغییر کرد ✅");
            setTimeout(function () {
                securityShowStep1();
                securityResetStep1();
            }, 1500);
        } else if (result && result.reason === "wrong_code") {
            msgEl.addClass("security-msg-error").text("کد تأیید اشتباه است.");
        } else if (result && result.reason === "expired") {
            msgEl.addClass("security-msg-error").text("کد منقضی شده، از اول امتحان کن.");
            setTimeout(securityShowStep1, 1500);
        } else {
            msgEl.addClass("security-msg-error").text("خطایی پیش اومد، دوباره تلاش کن.");
        }
    });
});

// ── password visibility toggle (👁) ─────────────────────────────
$(document).on("click", ".security-toggle-eye", function () {
    var targetId = $(this).data("target");
    var input = document.getElementById(targetId);
    if (!input) return;

    if (input.type === "password") {
        input.type = "text";
        $(this).removeClass("fa-eye").addClass("fa-eye-slash");
    } else {
        input.type = "password";
        $(this).removeClass("fa-eye-slash").addClass("fa-eye");
    }
});
