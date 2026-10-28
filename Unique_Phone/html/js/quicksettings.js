// ═══════════════════════════════════════════════════════════
// EXPANSION: Quick Settings panel.
//
// Dragging down on the status bar (.phone-header) reveals a small panel
// with two tiles — Do Not Disturb, Airplane Mode — that
// toggle instantly via the shared setDoNotDisturb()/
// setFlyMode() functions in app.js (the same ones the Settings app
// switches use), so no trip into the Settings app is needed for a quick
// toggle.
//
// A plain click on the header (movement below a small pixel threshold, so
// it isn't mistaken for a drag) also toggles the panel open/closed — this
// is the primary, always-reliable interaction; the live drag-follow below
// is the polish on top of it. Clicking the backdrop or the handle closes
// the panel.
// ═══════════════════════════════════════════════════════════

var qsPanelOpen = false;
var qsDragActive = false;
var qsDragStartY = 0;
var qsDragMoved = false;
var qsLastProgress = 0;

function qsClientY(e) {
    var oe = e.originalEvent || e;
    if (oe.touches && oe.touches.length) return oe.touches[0].clientY;
    if (oe.changedTouches && oe.changedTouches.length) return oe.changedTouches[0].clientY;
    return e.clientY;
}

// progress: 0 (fully hidden) .. 100 (fully open)
function qsSetProgress(progress) {
    progress = Math.max(0, Math.min(100, progress));
    qsLastProgress = progress;
    $("#phone-quicksettings").css({ display: "block", top: (progress - 100) + "%" });
    $("#phone-quicksettings-backdrop").css({ display: progress > 0 ? "block" : "none" });
}

function qsOpenPanel() {
    qsPanelOpen = true;
    MI.Phone.Animations.TopSlideDown("#phone-quicksettings", 180, 0);
    $("#phone-quicksettings-backdrop").css({ display: "block" });
}

function qsClosePanel() {
    qsPanelOpen = false;
    MI.Phone.Animations.TopSlideUp("#phone-quicksettings", 180, -100);
    $("#phone-quicksettings-backdrop").css({ display: "none" });
}

$(document).on('mousedown touchstart', '.phone-header', function(e) {
    if (qsPanelOpen) return;
    qsDragActive = true;
    qsDragMoved = false;
    qsDragStartY = qsClientY(e);
});

$(document).on('mousemove touchmove', function(e) {
    if (!qsDragActive) return;
    var delta = qsClientY(e) - qsDragStartY;
    if (Math.abs(delta) > 4) qsDragMoved = true;
    if (delta < 0) delta = 0;

    var panelHeightPx = $("#phone-quicksettings").outerHeight() || ($(".phone-container").outerHeight() * 0.36);
    qsSetProgress((delta / panelHeightPx) * 100);
});

$(document).on('mouseup touchend', function(e) {
    if (!qsDragActive) return;
    qsDragActive = false;

    if (qsDragMoved) {
        if (qsLastProgress > 30) {
            qsOpenPanel();
        } else {
            qsClosePanel();
        }
    } else {
        // Plain tap on the header, no real drag — just toggle.
        if (qsPanelOpen) {
            qsClosePanel();
        } else {
            qsOpenPanel();
        }
    }
});

$(document).on('click', '#phone-quicksettings-backdrop, #phone-quicksettings-handle', function(e) {
    e.preventDefault();
    qsClosePanel();
});

$(document).on('click', '.qs-tile', function(e) {
    e.preventDefault();
    var which = $(this).data('qs');

    if (which === 'dnd') {
        setDoNotDisturb(!PhoneDoNotDisturb);
    } else if (which === 'flymode') {
        setFlyMode(!PhoneFlyMode);
    }
});
