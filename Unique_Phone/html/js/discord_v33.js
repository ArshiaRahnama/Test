// ============================================================================
// Discord v33 — Server Settings opens the full-page settings (left menu with
// Overview / Roles / Emoji / Server Boost / Invites / Safety Setup), like Discord.
// The small pop-up settings window is no longer used. Loaded last.
// ============================================================================

window.Discord_OpenServerSettings = function() {
    if (typeof DX_OpenTools === "function") return DX_OpenTools();
};
$(document).on("click", "#discord-open-settings-btn", function(e) {
    e.stopImmediatePropagation();
    if (typeof DX_OpenTools === "function") DX_OpenTools();
});
