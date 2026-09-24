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

  const fmt = (t) => t.replace(/`([^`]+)`/g, '<code class="cmd">$1</code>');

  function fade(el, fn) { el.style.opacity = "0"; setTimeout(() => { fn(); el.style.opacity = "1"; }, 250); }

  function renderFeature(animate = true) {
    const list = U.dict().features, f = list[featIdx % list.length];
    const box = document.querySelector(".showcase");
    const set = () => {
      $("featTitle").textContent = f[0]; $("featDesc").innerHTML = fmt(f[1]);
      $("featDots").innerHTML = list.map((_, i) => `<i class="${i === featIdx % list.length ? "on" : ""}"></i>`).join("");
    };
    if (!animate) return set();
    box.classList.add("swap"); setTimeout(() => { set(); box.classList.remove("swap"); }, 300);
  }

  function renderTip(animate = true) {
    const list = U.dict().tipList, set = () => { $("tipCard").innerHTML = fmt(list[tipIdx % list.length]); };
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

  // Near the end FiveM is busy streaming the world: strip everything heavy so the game thread isn't starved.
  function boost() {
    if (document.body.classList.contains("is-boosted")) return;
    document.body.classList.add("lite", "is-boosted");
    document.dispatchEvent(new Event("unique:boost"));
  }

  function init() {
    window.addEventListener("message", (e) => {
      const d = e.data;
      if (!d || typeof d !== "object") return;
      if (d.eventName === "loadProgress" && Number(d.loadFraction) >= (C.boostAt || 0.85)) boost();
      if (d.eventName === "unique:closing") boost();
    });
    U.onLang.push(applyI18n);
    $("langBtn").addEventListener("click", () => U.setLang(U.lang === "fa" ? "en" : "fa"));
    $("liteBtn").addEventListener("click", () => setLite(!document.body.classList.contains("lite")));
    document.addEventListener("keydown", (e) => { if (e.code === "KeyL") setLite(!document.body.classList.contains("lite")); });

    const saved = safeGet("unique_ls_lite");
    setLite(saved === null ? (navigator.hardwareConcurrency || 8) <= 4 : saved === "1");

    applyI18n();

    const t0 = Date.now();
    setInterval(() => {
      const sec = Math.floor((Date.now() - t0) / 1000);
      $("timer").textContent = String((sec / 60) | 0).padStart(2, "0") + ":" + String(sec % 60).padStart(2, "0");
    }, 1000);

    const G = C.gallery || [];
    if (G.length) {
      const g = $("gallery");
      g.innerHTML = G.map((src, i) => `<img src="${src}" alt="" class="${i ? "" : "on"}">`).join("");
      let gi = 0;
      setInterval(() => {
        const old = g.children[gi];
        old.classList.remove("on"); old.classList.add("prev");
        setTimeout(() => old.classList.remove("prev"), 1900);
        gi = (gi + 1) % G.length; g.children[gi].classList.add("on");
      }, C.galleryMs || 8000);
    }

    const stepFeat = (d) => { featIdx = (featIdx + d + 1000 * U.dict().features.length) ; renderFeature(); };
    document.querySelector(".showcase").addEventListener("click", () => stepFeat(1));
    $("tipCard").parentElement.addEventListener("click", () => { tipIdx++; renderTip(); });
    document.addEventListener("keydown", (e) => {
      if (e.code === "ArrowRight") stepFeat(1);
      if (e.code === "ArrowLeft") stepFeat(-1);
    });

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
