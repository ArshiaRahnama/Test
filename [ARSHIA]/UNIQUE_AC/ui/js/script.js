const NUI_RESOURCE = typeof GetParentResourceName === "function" ? GetParentResourceName() : "UNIQUE_AC";

let streamerMode = false;
function toggleStreamerMode() {
  streamerMode = !streamerMode;
  $("#streamer-toggle").toggleClass("is-on", streamerMode);
  if (typeof pageLoaders !== "undefined" && pageLoaders[currentView]) pageLoaders[currentView]();
}
function displayName(name, id) {
  return streamerMode ? `Player #${id ?? "?"}` : (name || `Player ${id ?? "?"}`);
}

function escapeHtml(value) {
  return String(value ?? "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function safeNumber(value, fallback = 0) {
  const number = Number(value);
  return Number.isFinite(number) ? number : fallback;
}

function formatTimeAgo(unixSeconds) {
  const seconds = safeNumber(unixSeconds);
  if (seconds <= 0) return "";
  const deltaSec = Math.max(0, Math.floor(Date.now() / 1000) - seconds);
  if (deltaSec < 60) return "just now";
  const deltaMin = Math.floor(deltaSec / 60);
  if (deltaMin < 60) return `${deltaMin}m ago`;
  const deltaHr = Math.floor(deltaMin / 60);
  if (deltaHr < 24) return `${deltaHr}h ago`;
  const deltaDay = Math.floor(deltaHr / 24);
  if (deltaDay < 30) return `${deltaDay}d ago`;
  return new Date(seconds * 1000).toLocaleDateString();
}

function normalizeSearch(value) {
  return String(value ?? "").toLowerCase().replace(/\s+/g, " ").trim();
}

function applySearchFilter(targetSelector) {
  const target = $(targetSelector);
  if (!target.length) return;
  const input = $(`.record-search[data-target="${targetSelector}"]`);
  const query = normalizeSearch(input.val());
  const rows = target.children("button, .record-row, .player-row, .access-player-row");
  let visible = 0;

  rows.each(function () {
    const row = $(this);
    const haystack = normalizeSearch(row.text());
    const match = !query || haystack.includes(query);
    row.toggle(match);
    if (match) visible += 1;
  });

  target.find(".search-empty").remove();
  if (rows.length && visible === 0) {
    target.append(`<div class="empty-state search-empty">No matching records found.</div>`);
  }
}

function applyAllSearchFilters() {
  $(".record-search").each(function () {
    applySearchFilter($(this).data("target"));
  });
}

function nuiPost(name, payload) {
  return $.post(`https://${NUI_RESOURCE}/${name}`, payload ? JSON.stringify(payload) : undefined);
}

let playerCoords = null;
let selectedPlayer = null;
let currentView = "home";
let cachedStats = { players: 0, vehicles: 0, props: 0, peds: 0, bans: 0, admins: 0, whitelist: 0, unban: 0, recentAdmins: [], recentBans: [] };

const pagedLists = {
  bans: { page: 1, pageSize: 25, total: 0, search: "" },
  admins: { page: 1, pageSize: 25, total: 0, search: "" },
  unban: { page: 1, pageSize: 25, total: 0, search: "" },
  whitelist: { page: 1, pageSize: 25, total: 0, search: "" },
};

const listTargets = {
  bans: "#ban-records",
  admins: "#admin-records",
  unban: "#unban-records",
  whitelist: "#whitelist-records",
};

const searchTimers = {};

function listPayload(scope) {
  const state = pagedLists[scope] || { page: 1, pageSize: 25, search: "" };
  return { page: state.page, pageSize: state.pageSize, search: state.search || "" };
}

function setListMeta(scope, meta) {
  if (!pagedLists[scope]) return;
  meta = meta || {};
  pagedLists[scope].page = Math.max(1, Number(meta.page) || pagedLists[scope].page || 1);
  pagedLists[scope].pageSize = Math.max(5, Math.min(100, Number(meta.pageSize) || pagedLists[scope].pageSize || 25));
  pagedLists[scope].total = Math.max(0, Number(meta.total) || 0);
  if (typeof meta.search === "string") pagedLists[scope].search = meta.search;
}

function renderPager(scope) {
  const state = pagedLists[scope];
  if (!state) return;
  const pagerId = scope === "bans" ? "ban-pager" : `${scope}-pager`;
  const pager = $(`#${pagerId}`);
  if (!pager.length) return;

  const pages = Math.max(1, Math.ceil((state.total || 0) / state.pageSize));
  const from = state.total === 0 ? 0 : ((state.page - 1) * state.pageSize) + 1;
  const to = Math.min(state.total, state.page * state.pageSize);

  pager.html(`
    <button type="button" ${state.page <= 1 ? "disabled" : ""} onclick="changeListPage('${scope}', -1)">Prev</button>
    <span>Page <b>${state.page}</b> / ${pages} · ${from}-${to} of ${state.total}</span>
    <button type="button" ${state.page >= pages ? "disabled" : ""} onclick="changeListPage('${scope}', 1)">Next</button>
  `);
}

function changeListPage(scope, delta) {
  const state = pagedLists[scope];
  if (!state) return;
  const pages = Math.max(1, Math.ceil((state.total || 0) / state.pageSize));
  state.page = Math.max(1, Math.min(pages, state.page + Number(delta || 0)));
  loadPagedList(scope);
}

function loadPagedList(scope) {
  if (scope === "bans") return getBanListData();
  if (scope === "admins") return getAdminListData();
  if (scope === "unban") return getUnbanAccessData();
  if (scope === "whitelist") return getWhitelistData();
}

const pageLoaders = {
  home: () => { refreshDashboard(); getAdminStatus(); getAdminCoords(); },
  admin: () => { getAdminStatus(); getAdminCoords(); },
  players: getPlayersData,
  server: refreshDashboard,
  teleport: getAdminCoords,
  vehicle: refreshDashboard,
  bans: getBanListData,
  admins: () => { getAdminListData(); refreshAccessPlayers("admins"); },
  unban: getUnbanAccessData,
  whitelist: () => { getWhitelistData(); refreshAccessPlayers("whitelist"); },
  quarantine: getQuarantineList,
  adminlog: getAdminLog,
  appeals: getAppeals,
  changelog: getChangelog,
};

$(function () {
  $(document).on("input", ".record-search", function () {
    const target = $(this).data("target");
    const scope = Object.keys(listTargets).find((key) => listTargets[key] === target);
    if (scope && pagedLists[scope]) {
      pagedLists[scope].search = String($(this).val() || "").trim();
      pagedLists[scope].page = 1;
      clearTimeout(searchTimers[scope]);
      searchTimers[scope] = setTimeout(() => loadPagedList(scope), 220);
      return;
    }
    applySearchFilter(target);
  });

  $(".uniqueac-body").on("wheel", function (event) {
    if (!$("#main-ui").is(":visible")) return;
    const original = event.originalEvent;
    const activeView = $(".view.is-active");
    if (!activeView.length) return;
    activeView[0].scrollTop += original.deltaY;
    this.scrollTop += original.deltaY;
  });

  window.addEventListener("message", function (event) {
    const data = event.data || {};
    if (data.action === "openUI") openUI();
    else if (data.action === "forceClose") hardCloseUI();
    else if (data.action === "updateAdminStatus") updateAdminStatus(data);
    else if (data.action === "updatePlayerCoords") updateAdminCoords(data.location);
    else if (data.action === "updatePlayerList") updatePlayerList(data.playerList || []);
    else if (data.action === "openPlayerActionMenu") openPlayerActionMenu(data.data);
    else if (data.action === "updateBanList") updateBanList(data.banList || [], data.meta || {});
    else if (data.action === "updateAdminData") updateAdminList(data.adminList || [], data.meta || {});
    else if (data.action === "updateUnbanAccess") updateUnbanAccess(data.unbanList || [], data.meta || {});
    else if (data.action === "updateWhiteList") updateWhiteList(data.whiteList || [], data.meta || {});
    else if (data.action === "updateQuarantineList") updateQuarantineList(data.quarantineList || []);
    else if (data.action === "updatePlayerProfile") updatePlayerProfile(data.profile || null);
    else if (data.action === "updateAdminLog") updateAdminLog(data.log || []);
    else if (data.action === "updateAppeals") updateAppeals(data.appeals || []);
    else if (data.action === "updateChangelog") updateChangelog(data.content || "");
    else if (data.action === "updateBranding") updateBranding(data.branding || {});
    else if (data.action === "updateAccessPlayers") updateAccessPlayers(data.scope, data.players || []);
    else if (data.action === "updateDashboardStats") updateDashboardStats(data.stats || {});
  });
});

function hardCloseUI() { $("#main-ui").stop(true, true).hide(); resetToHome(); }
function closeUI() { $("#main-ui").fadeOut(140, resetToHome); nuiPost("onCloseMenu"); }
function openUI() { $("#main-ui").fadeIn(140); resetToHome(); refreshDashboard(); getAdminStatus(); getAdminCoords(); }

function resetToHome() { openPage("home", true); }

function setActiveTab(page) {
  $(".tab-button").removeClass("is-active");
  $(`.tab-button[data-page="${page}"]`).addClass("is-active");
}

function openPage(page, skipLoader = false) {
  const view = document.getElementById(`view-${page}`);
  if (!view) return;
  selectedPlayer = null;
  currentView = page;
  $(".view").removeClass("is-active");
  $(`#view-${page}`).addClass("is-active");
  setActiveTab(page);
  $("#header-back").toggle(page !== "home");
  $("#title").text(view.dataset.title || "UNIQUE_AC");
  $("#breadcrumb").text(view.dataset.breadcrumb || "Dashboard");
  $(".playerAction").hide();
  $(".playerList").show();
  const loader = pageLoaders[page];
  $(".uniqueac-body, .view").scrollTop(0);
  if (!skipLoader && loader) loader();
}

function goBack() {
  if (currentView === "players" && $(".playerAction").is(":visible")) { closePlayerActionMenu(); return; }
  if (currentView !== "home") { resetToHome(); refreshDashboard(); return; }
  closeUI();
}

function refreshDashboard() { nuiPost("getDashboardStats"); }
function getAdminStatus() { nuiPost("getAdminStatus"); }
function getAdminCoords() { nuiPost("getPlayerCoords"); }
function getPlayersData() { nuiPost("getAllPlayersData"); }
function getBanListData() { nuiPost("getBanListData", listPayload("bans")); }
function getAdminListData() { nuiPost("getAdminListData", listPayload("admins")); }
function getUnbanAccessData() { nuiPost("getUnbanAccessData", listPayload("unban")); }
function getWhitelistData() { nuiPost("getWhitelistData", listPayload("whitelist")); }
function getQuarantineList() { nuiPost("getQuarantineList"); }
function getAdminLog() { nuiPost("getAdminLog"); }
function getAppeals() { nuiPost("getAppeals"); }
function getChangelog() { nuiPost("getChangelog"); }

function primaryName(row, fallback) {
  return row?.PLAYER_NAME || row?.player_name || row?.name || fallback || "Unknown";
}
function primaryLicense(row) { return row?.identifier || row?.LICENSE || row?.license || row?.DISCORD || "No identifier stored"; }

function renderOverviewList(selector, rows, kind) {
  const container = $(selector);
  container.empty();
  if (!Array.isArray(rows) || rows.length === 0) {
    container.append(`<div class="empty-state small">No records yet.</div>`);
    return;
  }
  rows.slice(0, 5).forEach((row) => {
    const name = escapeHtml(primaryName(row, kind === "ban" ? `Ban #${row.BANID || "N/A"}` : "Unknown"));
    const sub = kind === "ban"
      ? `Ban #${escapeHtml(row.BANID || "N/A")} · ${escapeHtml(row.REASON || "No reason")}`
      : escapeHtml(primaryLicense(row));
    container.append(`<div class="record-row static ${kind === "ban" ? "danger" : ""}"><span class="avatar">${kind === "ban" ? "⛔" : "🛡️"}</span><span class="row-main"><b>${name}</b><small>${sub}</small></span></div>`);
  });
}

function updateDashboardStats(stats) {
  cachedStats = {
    players: safeNumber(stats.players, cachedStats.players),
    vehicles: safeNumber(stats.vehicles, cachedStats.vehicles),
    props: safeNumber(stats.props ?? stats.objects, cachedStats.props),
    peds: safeNumber(stats.peds, cachedStats.peds),
    bans: safeNumber(stats.bans, cachedStats.bans),
    admins: safeNumber(stats.admins, cachedStats.admins),
    whitelist: safeNumber(stats.whitelist, cachedStats.whitelist),
    unban: safeNumber(stats.unban, cachedStats.unban),
    recentAdmins: Array.isArray(stats.recentAdmins) ? stats.recentAdmins : cachedStats.recentAdmins,
    recentBans: Array.isArray(stats.recentBans) ? stats.recentBans : cachedStats.recentBans,
  };
  const map = { "stat-players": cachedStats.players, "stat-vehicles": cachedStats.vehicles, "stat-props": cachedStats.props, "stat-peds": cachedStats.peds, "stat-bans": cachedStats.bans, "stat-admins": cachedStats.admins, "stat-whitelist": cachedStats.whitelist, "stat-unban": cachedStats.unban };
  Object.entries(map).forEach(([id, value]) => $(`#${id}`).text(value));
  $("#server-vehicles").text(`${cachedStats.vehicles} detected`);
  $("#server-props").text(`${cachedStats.props} detected`);
  $("#server-peds").text(`${cachedStats.peds} detected`);
  renderOverviewList("#overview-admins", cachedStats.recentAdmins, "admin");
  renderOverviewList("#overview-bans", cachedStats.recentBans, "ban");
}

function updateAdminStatus(state) {
  state = state || {};
  const godEnabled = Boolean(state.godmode);
  const invisibleEnabled = !Boolean(state.visible);
  const visionLabel = String(state.vision || "Normal");
  const visionEnabled = visionLabel.toLowerCase() !== "normal";
  const spectateEnabled = Boolean(state.spectate);
  const noclipEnabled = Boolean(state.noclip);
  const superjumpEnabled = Boolean(state.superjump);
  const fastrunEnabled = Boolean(state.fastrun);
  const playerBlipsEnabled = Boolean(state.playerBlips);
  const infiniteStaminaEnabled = Boolean(state.infiniteStamina);
  const noRagdollEnabled = Boolean(state.noRagdoll);

  $("#godmode").toggleClass("is-on", godEnabled);
  $("#invisible").toggleClass("is-on", invisibleEnabled);
  $("#status-card-godmode").toggleClass("is-on", godEnabled);
  $("#status-card-invisible").toggleClass("is-on", invisibleEnabled);
  $("#status-card-vision").toggleClass("is-on", visionEnabled);
  $("#status-card-spectate").toggleClass("is-on", spectateEnabled);
  $("#noclip").toggleClass("is-on", noclipEnabled);
  $("#superjump").toggleClass("is-on", superjumpEnabled);
  $("#fastrun").toggleClass("is-on", fastrunEnabled);
  $("#playerBlips").toggleClass("is-on", playerBlipsEnabled);
  $("#infiniteStamina").toggleClass("is-on", infiniteStaminaEnabled);
  $("#noRagdoll").toggleClass("is-on", noRagdollEnabled);

  $("#godmode-state, #status-godmode").text(godEnabled ? "ON" : "OFF");
  $("#invisible-state, #status-invisible").text(invisibleEnabled ? "ON" : "OFF");
  $("#status-vision").text(visionLabel);
  $("#status-spectate").text(spectateEnabled ? "ON" : "OFF");
  $("#noclip-state").text(noclipEnabled ? "ON" : "OFF");
  $("#superjump-state").text(superjumpEnabled ? "ON" : "OFF");
  $("#fastrun-state").text(fastrunEnabled ? "ON" : "OFF");
  $("#playerBlips-state").text(playerBlipsEnabled ? "ON" : "OFF");
  $("#infiniteStamina-state").text(infiniteStaminaEnabled ? "ON" : "OFF");
  $("#noRagdoll-state").text(noRagdollEnabled ? "ON" : "OFF");
}

function updateAdminCoords(location) {
  const x = Number(location?.x), y = Number(location?.y), z = Number(location?.z), w = Number(location?.w);
  if (![x, y, z, w].every(Number.isFinite)) return;
  playerCoords = `vector4(${x.toFixed(2)}, ${y.toFixed(2)}, ${z.toFixed(2)}, ${w.toFixed(2)})`;
  $(".coords-loaction").text(playerCoords);
}

function copyTextToClipboard(text) { const el = document.createElement("textarea"); el.value = text; document.body.appendChild(el); el.select(); document.execCommand("copy"); document.body.removeChild(el); }

function doAction(actionName) {
  if (actionName === "copyLiveCoords") { copyTextToClipboard(playerCoords || ""); $(".coords-loaction").text("Coords copied successfully!"); return; }
  nuiPost(actionName); setTimeout(getAdminStatus, 200);
}

function updatePlayerList(playersList) {
  const playerList = $(".playerList"); playerList.empty();
  cachedStats.players = Array.isArray(playersList) ? playersList.length : cachedStats.players;
  updateDashboardStats(cachedStats);
  if (!Array.isArray(playersList) || playersList.length === 0) { playerList.append(`<div class="empty-state">No online players found.</div>`); return; }
  playersList.forEach((playerData) => {
    const id = safeNumber(playerData.id); if (!Number.isInteger(id) || id <= 0) return;
    const name = escapeHtml(displayName(playerData.name, id));
    const identifier = streamerMode ? "hidden" : escapeHtml(playerData.identifier || "license not available yet");
    const initial = streamerMode ? "P" : escapeHtml(String(playerData.name || "?").trim().charAt(0).toUpperCase() || "?");
    const tags = `${playerData.isAdmin ? "ADMIN" : "PLAYER"}${playerData.isWhitelist ? " · WL" : ""}`;
    const risk = safeNumber(playerData.risk);
    const riskClass = risk >= 60 ? "risk-high" : risk >= 30 ? "risk-mid" : "risk-low";
    const riskBadge = risk > 0 ? `<span class="risk-badge ${riskClass}" title="Risk Score">${risk}</span>` : "";
    playerList.append(`<button class="player-row" onclick="openPlayerActionList(${id})"><span class="avatar">${initial}</span><span class="row-main"><b>${name}</b><small>ID ${id} · ${identifier}</small></span>${riskBadge}<span class="row-tag">${tags}</span></button>`);
  });
  applySearchFilter(".playerList");
}

function openPlayerActionList(id) { id = Number(id); if (Number.isInteger(id) && id > 0) nuiPost("getPlayerData", { playerId: id }); }
function openPlayerActionMenu(data) {
  const playerId = Number(data?.id); if (!Number.isInteger(playerId) || playerId <= 0) return;
  selectedPlayer = playerId;
  $(".playerList").fadeOut(120, function () {
    $("#playerName").text(displayName(data.name, playerId)); $("#playerId").text(playerId); $("#armourCount").text(safeNumber(data.armour)); $("#heartCount").text(safeNumber(data.health)); $(".playerAction").fadeIn(120);
    $("#moderation-reason").val(""); $("#moderation-confirm-name").val("").removeClass("input-error");
    $("#new-note-text").val("");
    $("#profile-notes-list").html(`<div class="empty-state small">Loading...</div>`);
    $("#profile-history-list").html(`<div class="empty-state small">Loading...</div>`);
    nuiPost("getPlayerProfile", { playerId });
  });
}
function closePlayerActionMenu() { $(".playerAction").fadeOut(120, function () { $(".playerList").fadeIn(120); }); }

function addPlayerNote() {
  const note = String($("#new-note-text").val() || "").trim();
  if (!note || Number(selectedPlayer) <= 0) return;
  nuiPost("addPlayerNote", { playerId: selectedPlayer, note });
  $("#new-note-text").val("");
}

function updatePlayerProfile(profile) {
  if (!profile || Number(profile.id) !== Number(selectedPlayer)) return;
  $("#profile-trust").text(safeNumber(profile.trust));
  $("#profile-risk").text(safeNumber(profile.risk));

  const notesList = $("#profile-notes-list"); notesList.empty();
  if (!Array.isArray(profile.notes) || profile.notes.length === 0) {
    notesList.append(`<div class="empty-state small">No notes yet.</div>`);
  } else {
    profile.notes.forEach((n) => {
      notesList.append(`<div class="note-row"><b>${escapeHtml(streamerMode ? "Staff" : (n.author_name || "Unknown"))}</b> <span>${formatTimeAgo(n.at)}</span>${escapeHtml(n.note || "")}</div>`);
    });
  }

  const historyList = $("#profile-history-list"); historyList.empty();
  if (!Array.isArray(profile.detections) || profile.detections.length === 0) {
    historyList.append(`<div class="empty-state small">No detections on record.</div>`);
  } else {
    profile.detections.forEach((d) => {
      const action = escapeHtml(d.action || "FLAG");
      historyList.append(`<div class="history-row action-${action}"><b>${action} · ${escapeHtml(d.reason || "Unknown")}</b> <span>${formatTimeAgo(d.at)}</span>${escapeHtml(d.details || "")}</div>`);
    });
  }

  renderSecuritySection(profile.security || null);
}

// EXPANSION: renders the "Account Security" box (Unique_Login username,
// suspicious-device lock state, recent device list) inside the player
// profile panel. `security` comes straight from Unique_Login's
// getDevicesForPlayer export — see profile.security in updatePlayerProfile.
function renderSecuritySection(security) {
  const emptyEl = $("#profile-security-empty");
  const bodyEl = $("#profile-security-body");

  if (!security || !security.username) {
    emptyEl.show();
    bodyEl.hide();
    return;
  }
  emptyEl.hide();
  bodyEl.show();

  $("#profile-security-username").text(streamerMode ? "Hidden" : security.username);

  const lockRow = $("#profile-security-lock-row");
  if (security.securityHold) {
    $("#profile-security-status").text("🔒 Locked").css("color", "var(--danger)");
    lockRow.show();
  } else {
    $("#profile-security-status").text("✅ Normal").css("color", "var(--accent)");
    lockRow.hide();
  }

  const devicesList = $("#profile-devices-list"); devicesList.empty();
  if (!Array.isArray(security.devices) || security.devices.length === 0) {
    devicesList.append(`<div class="empty-state small">No device history yet.</div>`);
  } else {
    security.devices.forEach((dev) => {
      const isCurrent = dev.device_license && dev.device_license === security.currentDeviceLicense;
      const label = isCurrent ? "CURRENT DEVICE" : (dev.action || "login").toUpperCase();
      devicesList.append(`<div class="device-row${isCurrent ? " device-current" : ""}"><b>${escapeHtml(label)}</b> <span>${formatTimeAgo(dev.created_at)}</span></div>`);
    });
  }
}

function clearSecurityHold() {
  if (Number(selectedPlayer) <= 0) return;
  if (!confirm("Clear this account's suspicious-activity lock? The player will be able to log in normally again.")) return;
  nuiPost("clearSecurityHold", { playerId: selectedPlayer });
}

function doActionOnTargetPlayer(actionName) {
  const allowed = new Set(["spectate", "ban", "addToAdmin", "addToWhiteList", "addToUnban", "gotoPlayer", "bringPlayer", "kickPlayer", "slapPlayer"]);
  if (!allowed.has(actionName) || Number(selectedPlayer) <= 0) return;

  const payload = { playerId: selectedPlayer };
  const reason = String($("#moderation-reason").val() || "").trim();

  if (actionName === "ban") {
    payload.reason = reason || "Banned by UNIQUE_AC admin menu";
    const confirmName = String($("#moderation-confirm-name").val() || "").trim();
    const targetName = String($("#playerName").text() || "").trim();
    if (!confirmName || confirmName.toLowerCase().replace(/\s+/g, "") !== targetName.toLowerCase().replace(/\s+/g, "")) {
      $("#moderation-confirm-name").addClass("input-error");
      return;
    }
    $("#moderation-confirm-name").removeClass("input-error");
    payload.confirmName = confirmName;
  } else if (actionName === "kickPlayer") {
    payload.reason = reason || "Kicked by UNIQUE_AC admin menu";
  }

  nuiPost(actionName, payload);
  if (actionName === "ban") $("#moderation-confirm-name").val("");
  if (["ban", "kickPlayer"].includes(actionName)) setTimeout(getPlayersData, 500);
}

function doOnServer(actionName) { const allowed = new Set(["delete_vehicles", "delete_objects", "delete_peds", "delete_all_entity"]); if (allowed.has(actionName)) { nuiPost(actionName); setTimeout(refreshDashboard, 500); } }
function teleportToWaypoint() { nuiPost("teleportToWaypoint"); }
function teleportToCoords() { const x = Number($("#x-coords").val()), y = Number($("#y-coords").val()), z = Number($("#z-coords").val()); if ([x, y, z].every(Number.isFinite)) nuiPost("teleportToCoords", { x, y, z }); }
function createRpZoneHere() { const radius = Number($("#zone-radius").val()); nuiPost("createRpZone", { radius: Number.isFinite(radius) && radius > 0 ? radius : 15 }); }
function clearMyRpZones() { nuiPost("clearMyRpZones"); }
function changeVisionView(visionType) { if (visionType === "night" || visionType === "thermal") { nuiPost(visionType); setTimeout(getAdminStatus, 250); } }
function spawnVehicleForSelf() { const vehicleName = String($("#vehicle-name-m").val() || "").trim(); if (vehicleName) nuiPost("spawnVehicleForSelf", { vehicleName }); }
function spawnVehicleOthers() { const vehicleName = String($("#vehicle-name-o").val() || "").trim(); const targetId = Number($("#target-player").val()); if (vehicleName && Number.isInteger(targetId) && targetId > 0) nuiPost("spawnVehicleOthers", { vehicleName, targetId }); }
function vehicleAction(actionName) { if (["repairVehicle", "cleanVehicle", "maxVehicleMods", "deleteCurrentVehicle"].includes(actionName)) nuiPost(actionName); }
function setVehicleColor() { const r = Number($("#veh-r").val()), g = Number($("#veh-g").val()), b = Number($("#veh-b").val()); if ([r,g,b].every(Number.isFinite)) nuiPost("setVehicleColor", { r, g, b }); }

function refreshAccessPlayers(scope) { if (scope !== "admins" && scope !== "whitelist") return; const target = scope === "admins" ? "#admin-online-picker" : "#whitelist-online-picker"; $(target).html(`<div class="empty-state small">Loading online players...</div>`); nuiPost("getAccessOnlinePlayers", { scope }); }
function updateAccessPlayers(scope, players) {
  if (scope !== "admins" && scope !== "whitelist") return;
  const target = scope === "admins" ? "#admin-online-picker" : "#whitelist-online-picker";
  const container = $(target); container.empty();
  if (!Array.isArray(players) || players.length === 0) { container.append(`<div class="empty-state small">No online players found.</div>`); return; }
  players.forEach((playerData) => {
    const id = safeNumber(playerData.id); if (!Number.isInteger(id) || id <= 0) return;
    const name = escapeHtml(displayName(playerData.name, id)); const identifier = streamerMode ? "hidden" : escapeHtml(playerData.identifier || "license not available yet");
    const initial = streamerMode ? "P" : escapeHtml(String(playerData.name || "?").trim().charAt(0).toUpperCase() || "?");
    const already = scope === "admins" ? Boolean(playerData.isAdmin) : Boolean(playerData.isWhitelist);
    const label = already ? (scope === "admins" ? "ADMIN" : "WHITELISTED") : (scope === "admins" ? "ADD ADMIN" : "ADD WHITELIST");
    const action = scope === "admins" ? "addToAdmin" : "addToWhiteList";
    const button = already ? `<button type="button" class="is-disabled" disabled>${label}</button>` : `<button type="button" onclick="addOnlineAccess('${scope}', '${action}', ${id})">${label}</button>`;
    container.append(`<div class="access-player-row ${already ? "is-existing" : ""}" data-search="${name} ${identifier} ${id} ${label}"><span class="avatar">${initial}</span><span class="row-main"><b>${name}</b><small>ID ${id} · ${identifier}</small></span>${button}</div>`);
  });
  applySearchFilter(target);
}
function addOnlineAccess(scope, actionName, playerId) { playerId = Number(playerId); if (!Number.isInteger(playerId) || playerId <= 0) return; nuiPost(actionName, { playerId }); setTimeout(() => { if (scope === "admins") getAdminListData(); else getWhitelistData(); refreshAccessPlayers(scope); refreshDashboard(); }, 350); }

function renderRecords(containerSelector, rows, options) {
  const container = $(containerSelector); container.empty();
  if (!Array.isArray(rows) || rows.length === 0) { container.append(`<div class="empty-state">No records found.</div>`); return; }
  rows.forEach((row) => {
    const id = Number.parseInt(row[options.idKey], 10); if (!Number.isSafeInteger(id) || id <= 0) return;
    const titleRaw = options.title(row);
    const subRaw = options.sub(row);
    const title = escapeHtml(titleRaw);
    const sub = escapeHtml(subRaw);
    const searchText = escapeHtml(Object.values(row || {}).join(" ") + " " + titleRaw + " " + subRaw);
    container.append(`<button class="record-row ${options.danger ? "danger" : ""}" data-search="${searchText}" onclick="${options.action}(${id})"><span class="avatar">${options.icon}</span><span class="row-main"><b>${title}</b><small>${sub}</small></span><span class="row-tag">${options.label}</span></button>`);
  });
  applySearchFilter(containerSelector);
}
function unbanSelectedPlayer(banID) { banID = Number.parseInt(banID, 10); if (!Number.isSafeInteger(banID) || banID <= 0) return; nuiPost("unbanSelectedPlayer", { banID }); setTimeout(() => { getBanListData(); refreshDashboard(); }, 350); }
function updateBanList(bannedPlayers, meta) {
  setListMeta("bans", meta);
  cachedStats.bans = Number(meta?.total) || (Array.isArray(bannedPlayers) ? bannedPlayers.length : cachedStats.bans);
  updateDashboardStats(cachedStats);
  renderRecords("#ban-records", bannedPlayers, { idKey: "BANID", icon: "⛔", label: "UNBAN", danger: true, action: "unbanSelectedPlayer", title: (row) => primaryName(row, `Ban #${row.BANID || "N/A"}`), sub: (row) => `Ban #${row.BANID || "N/A"} · ${row.LICENSE || row.DISCORD || "No identifier"} · ${row.REASON || "No reason"}` });
  renderPager("bans");
}
function removeSelectedAdmin(id) { nuiPost("removeSelectedAdmin", { id }); setTimeout(() => { getAdminListData(); refreshDashboard(); }, 350); }
function updateAdminList(adminList, meta) {
  setListMeta("admins", meta);
  cachedStats.admins = Number(meta?.total) || (Array.isArray(adminList) ? adminList.length : cachedStats.admins);
  updateDashboardStats(cachedStats);
  renderRecords("#admin-records", adminList, { idKey: "id", icon: "🛡️", label: "REMOVE", action: "removeSelectedAdmin", title: (row) => primaryName(row, "Unknown admin"), sub: (row) => row.identifier || `Record ID ${row.id || "N/A"}` });
  renderPager("admins");
}
function removeUnbanAccess(id) { nuiPost("removeUnbanAccess", { id }); setTimeout(() => { getUnbanAccessData(); refreshDashboard(); }, 350); }
function updateUnbanAccess(list, meta) {
  setListMeta("unban", meta);
  cachedStats.unban = Number(meta?.total) || (Array.isArray(list) ? list.length : cachedStats.unban);
  updateDashboardStats(cachedStats);
  renderRecords("#unban-records", list, { idKey: "id", icon: "🔓", label: "REMOVE", action: "removeUnbanAccess", title: (row) => primaryName(row, "Unknown user"), sub: (row) => row.identifier || `Record ID ${row.id || "N/A"}` });
  renderPager("unban");
}
function removeWhitelistUser(id) { nuiPost("removeWhitelistUser", { id }); setTimeout(() => { getWhitelistData(); refreshDashboard(); }, 350); }
function updateWhiteList(list, meta) {
  setListMeta("whitelist", meta);
  cachedStats.whitelist = Number(meta?.total) || (Array.isArray(list) ? list.length : cachedStats.whitelist);
  updateDashboardStats(cachedStats);
  renderRecords("#whitelist-records", list, { idKey: "id", icon: "✅", label: "REMOVE", action: "removeWhitelistUser", title: (row) => primaryName(row, "Unknown user"), sub: (row) => row.identifier || `Record ID ${row.id || "N/A"}` });
  renderPager("whitelist");
}

function quarantineApprove(id) { id = Number(id); if (!Number.isInteger(id) || id <= 0) return; nuiPost("quarantineApprove", { id }); setTimeout(getQuarantineList, 350); }
function quarantineRelease(id) { id = Number(id); if (!Number.isInteger(id) || id <= 0) return; nuiPost("quarantineRelease", { id }); setTimeout(getQuarantineList, 350); }
function updateQuarantineList(list) {
  const container = $("#quarantine-list"); const empty = $("#quarantine-empty");
  container.empty();
  const count = Array.isArray(list) ? list.length : 0;
  const badge = $("#quarantine-badge");
  if (count > 0) { badge.text(count).prop("hidden", false); } else { badge.prop("hidden", true); }

  if (count === 0) { empty.show(); return; }
  empty.hide();

  list.forEach((entry) => {
    const id = safeNumber(entry.id); if (!Number.isInteger(id) || id <= 0) return;
    const name = escapeHtml(displayName(entry.name, id));
    const reason = escapeHtml(entry.reason || "Unknown");
    const details = escapeHtml(entry.details || "");
    const action = escapeHtml(entry.action || "BAN");
    const initial = escapeHtml(String(entry.name || "?").trim().charAt(0).toUpperCase() || "?");
    container.append(`
      <div class="quarantine-row">
        <span class="avatar">${initial}</span>
        <span class="row-main">
          <b>${name} <small>(ID ${id})</small></b>
          <small>${reason} · pending action: ${action}</small>
          ${details ? `<small class="quarantine-details">${details}</small>` : ""}
        </span>
        <span class="quarantine-actions">
          <button type="button" class="qa-approve" onclick="quarantineApprove(${id})">Approve</button>
          <button type="button" class="qa-release" onclick="quarantineRelease(${id})">Release</button>
        </span>
      </div>
    `);
  });
}

function updateAdminLog(list) {
  const container = $("#adminlog-list"); const empty = $("#adminlog-empty");
  container.empty();
  const count = Array.isArray(list) ? list.length : 0;
  if (count === 0) { empty.show(); return; }
  empty.hide();

  list.forEach((entry) => {
    const admin = escapeHtml(streamerMode ? "Admin" : (entry.admin_name || "Unknown"));
    const action = escapeHtml(entry.action || "Unknown");
    const target = escapeHtml(streamerMode && entry.target_name && entry.target_name !== "-" ? "a player" : (entry.target_name || "-"));
    const reason = escapeHtml(entry.reason || "");
    const initial = escapeHtml(String(entry.admin_name || "?").trim().charAt(0).toUpperCase() || "?");
    container.append(`
      <div class="record-row static">
        <span class="avatar">${initial}</span>
        <span class="row-main">
          <b>${admin} <small>→ ${action} ${target !== "-" ? `· ${target}` : ""}</small></b>
          <small>${formatTimeAgo(entry.at)}${reason ? ` · ${reason}` : ""}</small>
        </span>
      </div>
    `);
  });
}

function reviewAppeal(id, approve) { id = Number(id); if (!Number.isInteger(id) || id <= 0) return; nuiPost("reviewAppeal", { appealId: id, approve }); setTimeout(getAppeals, 350); }
function updateAppeals(list) {
  const container = $("#appeals-list"); const empty = $("#appeals-empty");
  container.empty();
  const count = Array.isArray(list) ? list.length : 0;
  const badge = $("#appeals-badge");
  if (count > 0) { badge.text(count).prop("hidden", false); } else { badge.prop("hidden", true); }
  if (count === 0) { empty.show(); return; }
  empty.hide();

  list.forEach((entry) => {
    const id = safeNumber(entry.id); if (!Number.isInteger(id) || id <= 0) return;
    const name = escapeHtml(streamerMode ? "Appellant" : (entry.player_name || "Unknown"));
    const message = escapeHtml(entry.message || "");
    const initial = escapeHtml(String(entry.player_name || "?").trim().charAt(0).toUpperCase() || "?");
    container.append(`
      <div class="quarantine-row">
        <span class="avatar">${initial}</span>
        <span class="row-main">
          <b>${name} <small>${formatTimeAgo(entry.at)}</small></b>
          <small class="quarantine-details">${message}</small>
        </span>
        <span class="quarantine-actions">
          <button type="button" class="qa-release" onclick="reviewAppeal(${id}, true)">Approve</button>
          <button type="button" class="qa-approve" onclick="reviewAppeal(${id}, false)">Reject</button>
        </span>
      </div>
    `);
  });
}

function updateChangelog(content) {
  document.getElementById("changelog-box").textContent = content || "No changelog available.";
}

function updateBranding(branding) {
  if (branding.panelName) {
    const nameEl = document.getElementById("brand-name");
    if (nameEl) nameEl.textContent = branding.panelName; // plain text — replaces the styled split-span, which is fine for a custom brand
    const footerBrand = document.getElementById("footer-brand");
    if (footerBrand) footerBrand.textContent = `${branding.panelName} Hardened UI`;
    document.title = `${branding.panelName} Admin Control Center`;
  }
  if (branding.footerCredit) {
    const creditEl = document.getElementById("footer-credit");
    if (creditEl) creditEl.textContent = branding.footerCredit;
  }
  if (branding.version) {
    const versionEl = document.getElementById("footer-version");
    if (versionEl) versionEl.textContent = `V${branding.version}`.replace(/^VV/, "V");
  }
}

$(document).keydown(function (e) { if (e.key === "Escape") { if (currentView !== "home" || $(".playerAction").is(":visible")) goBack(); else closeUI(); } });
