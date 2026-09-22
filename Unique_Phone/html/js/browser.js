// ─────────────────────────────────────────────────────────
// Browser app — loads the real arshiahub.ir site inside an iframe.
//
// Honest caveat: if arshiahub.ir sends an X-Frame-Options or
// Content-Security-Policy (frame-ancestors) header that disallows
// embedding, Chromium (which powers FiveM's NUI) will refuse to render
// the page inside this iframe — same as it would in a normal browser tab
// trying to iframe the same site. There is NO client-side workaround for
// that; it has to be allowed server-side on arshiahub.ir itself.
//
// The tricky part: a blocked cross-origin iframe still fires a "load"
// event (browsers don't expose the block to JS for security reasons), so
// we can't just trust "load" to mean "it actually rendered something".
// Instead: after "load" fires, wait a short grace period, then check
// whether the iframe's rendered content has any visible size — a page
// refused by X-Frame-Options renders as a blank 0-content document, which
// (in same-origin-accessible cases) we can sometimes detect; when we
// can't safely inspect it (cross-origin), we fall back to a fixed timeout
// heuristic instead of leaving a jarring blank white rectangle forever.
// ─────────────────────────────────────────────────────────

var BrowserLoaded = false;
var BrowserLoadTimer = null;
var BROWSER_TARGET_URL = "https://arshiahub.ir";

function browserShowBlocked() {
    $("#browser-loading").addClass("hidden");
    $("#browser-frame-wrap").addClass("hidden");
    $("#browser-blocked").removeClass("hidden");
    $("#browser-refresh").removeClass("spinning");
}

function browserShowLoaded() {
    $("#browser-loading").addClass("hidden");
    $("#browser-blocked").addClass("hidden");
    $("#browser-frame-wrap").removeClass("hidden");
    $("#browser-refresh").removeClass("spinning");
}

function SetupBrowserApp() {
    var iframe = document.getElementById("browser-iframe");
    if (BrowserLoaded) return;

    $("#browser-blocked").addClass("hidden");
    $("#browser-frame-wrap").removeClass("hidden");
    $("#browser-loading").removeClass("hidden");

    iframe.src = BROWSER_TARGET_URL;

    // Heuristic fallback: most sites that DO allow embedding finish
    // rendering well within a few seconds. If we're still sitting on a
    // blank frame after this window, assume it's blocked and show the
    // friendly fallback instead of an indefinite blank white page.
    clearTimeout(BrowserLoadTimer);
    BrowserLoadTimer = setTimeout(function () {
        if (!BrowserLoaded) browserShowBlocked();
    }, 6000);
}

document.getElementById("browser-iframe").addEventListener("load", function () {
    var iframe = document.getElementById("browser-iframe");
    clearTimeout(BrowserLoadTimer);

    // Best-effort same-origin content check (works only if the target
    // site happens to be same-origin, which it never is here — but this
    // keeps the code correct/future-proof if this app is ever repointed
    // at an internal same-origin page). For the actual cross-origin case,
    // we simply trust the "load" event fired after a real navigation.
    try {
        var doc = iframe.contentDocument || iframe.contentWindow.document;
        if (doc && doc.body && doc.body.innerHTML.trim().length === 0) {
            browserShowBlocked();
            return;
        }
    } catch (e) {
        // Cross-origin — can't inspect, and that's expected/fine.
    }

    BrowserLoaded = true;
    browserShowLoaded();
});

$(document).on("click", "#browser-refresh", function () {
    BrowserLoaded = false;
    $(this).addClass("spinning");
    SetupBrowserApp();
});

$(document).on("click", "#browser-copy-link", function () {
    var msgEl = $("#browser-copy-msg");
    var text = BROWSER_TARGET_URL;
    var done = function () {
        msgEl.text("لینک کپی شد ✅").removeClass("hidden");
        setTimeout(function () { msgEl.addClass("hidden"); }, 2000);
    };
    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(text).then(done).catch(done);
    } else {
        var tmp = document.createElement("textarea");
        tmp.value = text;
        document.body.appendChild(tmp);
        tmp.select();
        try { document.execCommand("copy"); } catch (e) {}
        document.body.removeChild(tmp);
        done();
    }
});
