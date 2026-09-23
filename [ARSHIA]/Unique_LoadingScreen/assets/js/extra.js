/* Unique RP loading screen - dynamic content (i18n, cards, stats, lite mode) */
(function () {
  "use strict";
  const C = window.UNIQUE_CONFIG, U = window.UNIQUE;
  const $ = (id) => document.getElementById(id);
  let featIdx = 0, tipIdx = 0;

  const safeGet = (k) => { try { return localStorage.getItem(k); } catch (e) { return null; } };
  const safeSet = (k, v) => { try { localStorage.setItem(k, v); } catch (e) {} };

  function applyI18n() {
    const d = U.dict();
    document.querySelectorAll("[data-i18n]").forEach((n) => { if (d[n.dataset.i18n] != null) n.textContent = d[n.dataset.i18n]; });
    $("langBtn").textContent = U.lang === "fa" ? "EN" : "FA";
    renderFeature(false); renderTip(false);
    renderSocials();
    if (U.refreshStatus) U.refreshStatus();
  }

  function fade(el, fn) { el.style.opacity = "0"; setTimeout(() => { fn(); el.style.opacity = "1"; }, 250); }

  function renderFeature(animate = true) {
    const list = U.dict().features, f = list[featIdx % list.length];
    const box = document.querySelector(".showcase");
    const set = () => {
      $("featTitle").textContent = f[0]; $("featDesc").textContent = f[1];
      $("featDots").innerHTML = list.map((_, i) => `<i class="${i === featIdx % list.length ? "on" : ""}"></i>`).join("");
    };
    if (!animate) return set();
    box.classList.add("swap"); setTimeout(() => { set(); box.classList.remove("swap"); }, 300);
  }

  function renderTip(animate = true) {
    const list = U.dict().tipList, set = () => { $("tipCard").textContent = list[tipIdx % list.length]; };
    animate ? fade($("tipCard"), set) : set();
  }

  function renderSocials() {
    const L = C.links, d = U.dict(), items = [];
    if (L.teamspeak) items.push([L.teamspeak, "TeamSpeak", "_self"]);
    if (L.discord) items.push([L.discord, "Discord", "_blank"]);
    if (L.website) items.push([L.website, d.website, "_blank"]);
    $("socials").innerHTML = items.map(([h, t, tg]) => `<a class="social-item" href="${h}" target="${tg}" rel="noopener noreferrer">${t}</a>`).join("");
  }

  async function fetchJson(path) {
    const ctl = new AbortController(), t = setTimeout(() => ctl.abort(), 3000);
    try { const r = await fetch(`http://${C.statsHost}/${path}`, { signal: ctl.signal }); return await r.json(); }
    finally { clearTimeout(t); }
  }

  async function refreshStats() {
    if (!C.statsHost) return;
    try {
      const [players, info] = await Promise.all([fetchJson("players.json"), fetchJson("info.json")]);
      const max = (info && info.vars && info.vars.sv_maxClients) || "?";
      $("statsText").textContent = `${players.length}/${max}`;
      $("statsChip").hidden = false;
    } catch (e) { $("statsChip").hidden = true; }
  }

  function setLite(on) {
    document.body.classList.toggle("lite", on);
    $("liteBtn").classList.toggle("on", on);
    safeSet("unique_ls_lite", on ? "1" : "0");
  }

  function init() {
    U.onLang.push(applyI18n);
    $("langBtn").addEventListener("click", () => U.setLang(U.lang === "fa" ? "en" : "fa"));
    $("liteBtn").addEventListener("click", () => setLite(!document.body.classList.contains("lite")));
    document.addEventListener("keydown", (e) => { if (e.code === "KeyL") setLite(!document.body.classList.contains("lite")); });

    const saved = safeGet("unique_ls_lite");
    setLite(saved === null ? (navigator.hardwareConcurrency || 8) <= 4 : saved === "1");

    applyI18n();
    setInterval(() => { featIdx++; renderFeature(); }, C.showcaseMs);
    setInterval(() => { tipIdx++; renderTip(); }, C.tipsMs);
    refreshStats(); setInterval(refreshStats, C.statsRefreshMs);

    // stuck helper: if the bar hasn't moved for a long time, show a hint
    let last = "", lastChange = Date.now();
    setInterval(() => {
      const p = $("progressPercent").textContent;
      if (p !== last) { last = p; lastChange = Date.now(); return; }
      if (p !== "100%" && Date.now() - lastChange > C.stuckAfterMs) $("tipText").textContent = U.dict().stuck;
    }, 5000);
  }
  init();
})();
