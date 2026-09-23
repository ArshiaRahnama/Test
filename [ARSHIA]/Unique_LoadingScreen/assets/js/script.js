document.addEventListener("DOMContentLoaded", () => {
  "use strict";

  // ----------------------
  // CONFIG
  // ----------------------

  const CONFIG = {
    audio: {
      defaultVolume: 0.5,
      outputMultiplier: 0.3,
      fadeDuration: 3000,
      fadeOutDuration: 900,
    },

    progress: {
      snapThreshold: 0.015,
      eventThreshold: 0.25,
      readySnap: 99.9,
    },

    cursor: {
      dotLerp: 0.72,
      ringLerp: 0.18,
      pulseDuration: 560,
    },
  };

  const ICONS = {
    volume: `
      <svg viewBox="0 0 24 24" aria-hidden="true">
        <path d="M3 9v6h4l5 5V4L7 9H3zM16.5 12c0-1.77-1-3.29-2.5-4.03v8.05c1.5-.73 2.5-2.25 2.5-4.02z" />
      </svg>
    `,

    muted: `
      <svg viewBox="0 0 24 24" aria-hidden="true">
        <path d="M16.5 12 20 8.5 18.5 7 15 10.5 11.5 7 10 8.5l3.5 3.5L10 15.5l1.5 1.5L15 13.5l3.5 3.5 1.5-1.5L16.5 12zM3 9v6h4l5 5V4L7 9H3z" />
      </svg>
    `,
  };

  const STAGES = {
    CONNECTING: {
      get label() { return UNIQUE.stage("CONNECTING").label; },
      max: 15,
      speed: 0.045,
      get hints() { return UNIQUE.stage("CONNECTING").hints; },
    },

    DOWNLOADING: {
      get label() { return UNIQUE.stage("DOWNLOADING").label; },
      max: 50,
      speed: 0.07,
      get hints() { return UNIQUE.stage("DOWNLOADING").hints; },
    },

    STREAMING: {
      get label() { return UNIQUE.stage("STREAMING").label; },
      max: 85,
      speed: 0.052,
      get hints() { return UNIQUE.stage("STREAMING").hints; },
    },

    FINALIZING: {
      get label() { return UNIQUE.stage("FINALIZING").label; },
      max: 100,
      speed: 0.028,
      get hints() { return UNIQUE.stage("FINALIZING").hints; },
    },

    READY: {
      get label() { return UNIQUE.stage("READY").label; },
      max: 100,
      speed: 0.08,
      get hints() { return UNIQUE.stage("READY").hints; },
    },

  };

  // ----------------------
  // ELEMENTS
  // ----------------------

  const el = {
    progressFill: document.getElementById("progressFill"),
    progressText: document.getElementById("progressPercent"),
    statusText: document.getElementById("statusText"),
    tipText: document.getElementById("tipText"),

    video: document.querySelector(".bg-video"),

    playBtn: document.getElementById("playBtn"),
    muteBtn: document.getElementById("muteBtn"),
    volume: document.getElementById("volumeSlider"),

    cursorDot: document.querySelector(".cursor-dot"),
    cursorRing: document.querySelector(".cursor-ring"),

    musicPlayer: document.querySelector(".music-player"),
    progressBar: document.querySelector(".progress-bar"),
  };

  const required = [
    ["progressFill", el.progressFill],
    ["progressPercent", el.progressText],
    ["statusText", el.statusText],
    ["tipText", el.tipText],
    ["bg-video", el.video],
    ["muteBtn", el.muteBtn],
    ["volumeSlider", el.volume],
  ];

  const missing = required.filter(([, node]) => !node);

  if (missing.length > 0) {
    console.error(
      "[Unique Loading] Missing required elements:",
      missing.map(([name]) => name).join(", "),
    );
    return;
  }

  // ----------------------
  // STATE
  // ----------------------

  const state = {
    progress: 0,
    targetProgress: 0,
    displayProgress: 0,
    lastServerProgress: 0,
    lastProgressEvent: 0,

    status: "CONNECTING",
    lastStatusText: "",

    muted: true,
    volume: CONFIG.audio.defaultVolume,
    playing: false,
    audioUnlocked: false,
    fadeFrame: null,

    hintTimer: null,
    lastHint: "",

    cursor: {
      enabled: false,
      mouseX: window.innerWidth / 2,
      mouseY: window.innerHeight / 2,
      dotX: window.innerWidth / 2,
      dotY: window.innerHeight / 2,
      ringX: window.innerWidth / 2,
      ringY: window.innerHeight / 2,
    },
  };

  // ----------------------
  // HELPERS
  // ----------------------

  function clamp(value, min, max) {
    return Math.min(Math.max(value, min), max);
  }

  function toNumber(value, fallback = 0) {
    const number = Number(value);
    return Number.isFinite(number) ? number : fallback;
  }

  function setButtonIcon(button, icon) {
    if (!button) return;
    button.innerHTML = icon;
  }

  function isTypingTarget(target) {
    const tag = target?.tagName?.toLowerCase();

    return (
      tag === "input" ||
      tag === "textarea" ||
      tag === "select" ||
      target?.isContentEditable
    );
  }

  function getStageFromProgress(progress) {
    if (progress >= 100) return "READY";
    if (progress < STAGES.CONNECTING.max) return "CONNECTING";
    if (progress < STAGES.DOWNLOADING.max) return "DOWNLOADING";
    if (progress < STAGES.STREAMING.max) return "STREAMING";
    return "FINALIZING";
  }

  function getProgressSpeed(progress) {
    const stage = getStageFromProgress(progress);
    return STAGES[stage]?.speed || 0.05;
  }

  // ----------------------
  // AUDIO SYSTEM
  // ----------------------

  function getTargetVolume() {
    return clamp(state.volume, 0, 1) * CONFIG.audio.outputMultiplier;
  }

  function applyVolume() {
    if (!state.muted) {
      el.video.volume = getTargetVolume();
    }

    if (el.volume) {
      el.volume.value = String(state.volume);
    }
  }

  function updateMuteUI() {
    el.muteBtn.classList.toggle("active", state.muted);
    el.muteBtn.setAttribute(
      "aria-label",
      state.muted ? "Unmute audio" : "Mute audio",
    );

    setButtonIcon(el.muteBtn, state.muted ? ICONS.muted : ICONS.volume);

    if (el.musicPlayer) {
      el.musicPlayer.classList.toggle("is-muted", state.muted);
      el.musicPlayer.classList.toggle("is-paused", false);
    }
  }

  function fadeInAudio() {
    if (state.fadeFrame) {
      cancelAnimationFrame(state.fadeFrame);
      state.fadeFrame = null;
    }

    if (state.muted) {
      el.video.volume = 0;
      return;
    }

    const startedAt = performance.now();
    const targetVolume = getTargetVolume();

    el.video.volume = 0;

    function tick(now) {
      const progress = clamp(
        (now - startedAt) / CONFIG.audio.fadeDuration,
        0,
        1,
      );

      const eased = progress * progress * (3 - 2 * progress);

      el.video.volume = targetVolume * eased;

      if (progress < 1 && !state.muted && state.playing) {
        state.fadeFrame = requestAnimationFrame(tick);
      } else {
        el.video.volume = state.muted ? 0 : targetVolume;
        state.fadeFrame = null;
      }
    }

    state.fadeFrame = requestAnimationFrame(tick);
  }

  function fadeOutAudio(onComplete) {
    if (state.fadeFrame) {
      cancelAnimationFrame(state.fadeFrame);
      state.fadeFrame = null;
    }

    const startedAt = performance.now();
    const startVolume = clamp(el.video.volume, 0, 1);

    function tick(now) {
      /*
      If user unmutes during fade-out, stop the fade-out immediately.
      This prevents an old fade-out frame from forcing volume back to 0.
    */
      if (!state.muted) {
        state.fadeFrame = null;
        return;
      }

      const progress = clamp(
        (now - startedAt) / CONFIG.audio.fadeOutDuration,
        0,
        1,
      );

      const eased = 1 - Math.pow(1 - progress, 3);

      el.video.volume = startVolume * (1 - eased);

      if (progress < 1) {
        state.fadeFrame = requestAnimationFrame(tick);
        return;
      }

      el.video.volume = 0;
      state.fadeFrame = null;

      if (state.muted && typeof onComplete === "function") {
        onComplete();
      }
    }

    state.fadeFrame = requestAnimationFrame(tick);
  }

  async function playVideoAudio() {
    try {
      await el.video.play();

      state.playing = true;

      if (el.musicPlayer) {
        el.musicPlayer.classList.remove("is-paused");
      }

      if (!state.muted) {
        fadeInAudio();
      }
    } catch (error) {
      state.playing = false;

      if (el.musicPlayer) {
        el.musicPlayer.classList.add("is-paused");
      }

      console.warn("[Unique Loading] Video/audio play was blocked:", error);
    }
  }

  function setMuted(nextMuted) {
    const shouldMute = Boolean(nextMuted);

    if (shouldMute === state.muted) return;

    state.muted = shouldMute;
    updateMuteUI();

    if (state.muted) {
      fadeOutAudio(() => {
        el.video.muted = true;
        el.video.volume = 0;
      });

      return;
    }

    state.audioUnlocked = true;

    if (state.fadeFrame) {
      cancelAnimationFrame(state.fadeFrame);
      state.fadeFrame = null;
    }

    el.video.muted = false;
    el.video.volume = 0;

    playVideoAudio();
  }

  function toggleMute() {
    setMuted(!state.muted);
  }

  function unlockAudio(event) {
    if (state.audioUnlocked) return;

    /*
    KeyM and Space are handled by handleKeyboard().
    This prevents first key press from toggling twice.
  */
    if (
      event?.type === "keydown" &&
      (event.code === "KeyM" || event.code === "Space")
    ) {
      return;
    }

    state.audioUnlocked = true;
    setMuted(false);
  }

  function initAudio() {
    el.video.loop = true;
    el.video.muted = true;
    el.video.volume = 0;

    let savedVol = null;
    try { savedVol = localStorage.getItem("unique_ls_volume"); } catch (e) {}
    if (savedVol !== null) el.volume.value = savedVol;
    state.volume = clamp(
      toNumber(el.volume.value, CONFIG.audio.defaultVolume),
      0,
      1,
    );

    state.muted = true;

    el.video.muted = true;
    el.video.volume = 0;

    updateMuteUI();
    applyVolume();

    if (el.playBtn) {
      el.playBtn.style.display = "none";
      el.playBtn.setAttribute("aria-hidden", "true");
      el.playBtn.setAttribute("tabindex", "-1");
    }

    el.video.play().catch(() => {
      console.warn("[Unique Loading] Silent video autoplay was blocked.");
    });

    document.addEventListener("pointerdown", unlockAudio, { once: true });
    document.addEventListener("keydown", unlockAudio, { once: true });

    el.video.addEventListener("play", () => {
      state.playing = true;

      if (el.musicPlayer) {
        el.musicPlayer.classList.remove("is-paused");
      }
    });

    el.video.addEventListener("pause", () => {
      state.playing = false;

      window.setTimeout(() => {
        el.video.play().catch(() => {});
      }, 250);
    });

    el.muteBtn.addEventListener("click", toggleMute);

    el.volume.addEventListener("input", (event) => {
      state.volume = clamp(
        toNumber(event.target.value, CONFIG.audio.defaultVolume),
        0,
        1,
      );

      try { localStorage.setItem("unique_ls_volume", String(state.volume)); } catch (e) {}
      if (state.volume <= 0) {
        setMuted(true);
      } else {
        if (state.muted) {
          setMuted(false);
        }

        applyVolume();
      }
    });
  }

  // ----------------------
  // STATUS SYSTEM
  // ----------------------

  function setStatus(nextStatus) {
    const normalized = String(nextStatus || "").trim();

    if (!normalized) return;

    const knownStage = STAGES[normalized];
    const text = knownStage ? knownStage.label : normalized;

    if (text === state.lastStatusText) return;

    if (knownStage) {
      state.status = normalized;
    }

    state.lastStatusText = text;
    el.statusText.style.opacity = "0";

    window.setTimeout(() => {
      el.statusText.textContent = text;
      el.statusText.style.opacity = "1";
      scheduleHintUpdate();
    }, 120);
  }

  function scheduleHintUpdate(delay = 520) {
    if (state.hintTimer) {
      clearTimeout(state.hintTimer);
    }

    state.hintTimer = window.setTimeout(updateHint, delay);
  }

  function updateHint() {
    const stage = STAGES[state.status] || STAGES.CONNECTING;
    const hints = stage.hints || [];

    if (hints.length === 0) return;

    let nextHint = hints[Math.floor(Math.random() * hints.length)];

    if (hints.length > 1) {
      let guard = 0;

      while (nextHint === state.lastHint && guard < 6) {
        nextHint = hints[Math.floor(Math.random() * hints.length)];
        guard += 1;
      }
    }

    state.lastHint = nextHint;
    el.tipText.style.opacity = "0";

    window.setTimeout(() => {
      el.tipText.textContent = nextHint;
      el.tipText.style.opacity = "1";
    }, 120);
  }

  // ----------------------
  // PROGRESS SYSTEM
  // ----------------------

  function renderProgress() {
    const speed = getProgressSpeed(state.displayProgress);
    const delta = state.targetProgress - state.displayProgress;

    state.displayProgress += delta * speed;

    if (Math.abs(delta) < CONFIG.progress.snapThreshold) {
      state.displayProgress = state.targetProgress;
    }

    if (
      state.targetProgress >= 100 &&
      state.displayProgress > CONFIG.progress.readySnap
    ) {
      state.displayProgress = 100;
    }

    const visualProgress = clamp(state.displayProgress, 0, 100);
    const percent = Math.floor(visualProgress);

    el.progressFill.style.width = `${visualProgress}%`;
    el.progressText.textContent = `${percent}%`;

    if (el.progressBar) {
      el.progressBar.setAttribute("aria-valuemin", "0");
      el.progressBar.setAttribute("aria-valuemax", "100");
      el.progressBar.setAttribute("aria-valuenow", String(percent));
    }

    requestAnimationFrame(renderProgress);
  }

  function setProgress(value) {
    const safeValue = clamp(toNumber(value, 0), 0, 100);

    if (safeValue < state.lastServerProgress) return;

    state.progress = safeValue;
    state.lastServerProgress = safeValue;
    state.targetProgress = safeValue;

    const nextStage = getStageFromProgress(safeValue);

    if (nextStage !== state.status) {
      setStatus(nextStage);
    }
  }

  // ----------------------
  // FIVEM HOOKS
  // ----------------------

  let lastLogAt = 0;

  // Shows the REAL loading log line from FiveM (throttled, sanitized).
  function showLogLine(raw) {
    const now = Date.now();
    if (now - lastLogAt < 700) return;

    const clean = String(raw).replace(/\^\d/g, "").replace(/\s+/g, " ").trim().slice(0, 64);
    if (!clean) return;

    lastLogAt = now;
    clearTimeout(state.hintTimer);
    el.tipText.textContent = clean;
    state.hintTimer = window.setTimeout(updateHint, 2600);
  }

  function handleFiveMMessage(event) {
    const data = event.data;

    if (!data || typeof data !== "object") return;

    if (data.eventName === "loadProgress") {
      const rawValue = toNumber(data.loadFraction, 0) * 100;
      const value = clamp(rawValue, 0, 100);

      const enoughChange =
        Math.abs(value - state.lastProgressEvent) >=
        CONFIG.progress.eventThreshold;

      if (enoughChange || value >= 100) {
        state.lastProgressEvent = value;
        setProgress(value);
      }

      return;
    }

    if (data.eventName === "onLogLine" && typeof data.message === "string") {
      showLogLine(data.message);
      return;
    }

    if (data.eventName === "unique:closing") {
      setProgress(100);
      document.body.classList.add("is-closing");
      return;
    }

    if (data.eventName === "status" && typeof data.message === "string") {
      const message = data.message.trim();

      if (message && message !== state.lastStatusText) {
        queueMicrotask(() => setStatus(message));
      }
    }
  }

  // ----------------------
  // KEYBOARD SHORTCUTS
  // ----------------------

  function handleKeyboard(event) {
    if (isTypingTarget(document.activeElement)) return;

    if (event.code === "KeyM" || event.code === "Space") {
      event.preventDefault();

      state.audioUnlocked = true;
      toggleMute();

      return;
    }

    if (event.code === "ArrowUp") {
      event.preventDefault();

      state.volume = clamp(state.volume + 0.05, 0, 1);

      if (state.volume > 0 && state.muted) {
        setMuted(false);
      }

      applyVolume();
      return;
    }

    if (event.code === "ArrowDown") {
      event.preventDefault();

      state.volume = clamp(state.volume - 0.05, 0, 1);

      if (state.volume <= 0) {
        setMuted(true);
      } else {
        applyVolume();
      }
    }
  }

  // ----------------------
  // SECURITY / UX LOCKS
  // ----------------------

  function initInteractionLocks() {
    document.addEventListener("selectstart", (event) => {
      event.preventDefault();
    });

    document.addEventListener("dragstart", (event) => {
      event.preventDefault();
    });

    document.addEventListener("contextmenu", (event) => {
      event.preventDefault();
    });
  }

  // ----------------------
  // CUSTOM CURSOR
  // ----------------------

  function initCursor() {
    const isTouchDevice = window.matchMedia(
      "(hover: none), (pointer: coarse)",
    ).matches;

    if (isTouchDevice) return;
    if (!el.cursorDot || !el.cursorRing) return;

    state.cursor.enabled = true;

    const hoverTargets = [
      "a",
      "button",
      "input",
      ".card",
      ".music-btn",
      ".social-item",
      ".logo img",
      ".loading-hud",
      ".progress-bar",
      ".music-player",
      ".volume-control",
      ".music-volume",
    ].join(",");

    function setCursorPosition(event) {
      state.cursor.mouseX = event.clientX;
      state.cursor.mouseY = event.clientY;

      document.body.classList.add("cursor-visible");
    }

    function animateCursor() {
      if (!state.cursor.enabled) return;

      state.cursor.dotX +=
        (state.cursor.mouseX - state.cursor.dotX) * CONFIG.cursor.dotLerp;
      state.cursor.dotY +=
        (state.cursor.mouseY - state.cursor.dotY) * CONFIG.cursor.dotLerp;

      state.cursor.ringX +=
        (state.cursor.mouseX - state.cursor.ringX) * CONFIG.cursor.ringLerp;
      state.cursor.ringY +=
        (state.cursor.mouseY - state.cursor.ringY) * CONFIG.cursor.ringLerp;

      el.cursorDot.style.transform = `translate3d(${state.cursor.dotX}px, ${state.cursor.dotY}px, 0) translate(-50%, -50%)`;

      el.cursorRing.style.transform = `translate3d(${state.cursor.ringX}px, ${state.cursor.ringY}px, 0) translate(-50%, -50%)`;

      requestAnimationFrame(animateCursor);
    }

    function createPulse(x, y) {
      const pulse = document.createElement("span");

      pulse.className = "cursor-pulse";
      pulse.style.left = `${x}px`;
      pulse.style.top = `${y}px`;

      document.body.appendChild(pulse);

      window.setTimeout(() => {
        pulse.remove();
      }, CONFIG.cursor.pulseDuration);
    }

    document.addEventListener("pointermove", setCursorPosition, {
      passive: true,
    });

    window.addEventListener("pointerenter", () => {
      document.body.classList.add("cursor-visible");
    });

    window.addEventListener("pointerleave", () => {
      document.body.classList.remove("cursor-visible");
      document.body.classList.remove("cursor-hover");
      document.body.classList.remove("cursor-down");
    });

    document.addEventListener("pointerover", (event) => {
      if (event.target.closest(hoverTargets)) {
        document.body.classList.add("cursor-hover");
      }
    });

    document.addEventListener("pointerout", (event) => {
      if (event.target.closest(hoverTargets)) {
        document.body.classList.remove("cursor-hover");
      }
    });

    document.addEventListener("pointerdown", (event) => {
      document.body.classList.add("cursor-down");
      createPulse(event.clientX, event.clientY);
    });

    document.addEventListener("pointerup", () => {
      document.body.classList.remove("cursor-down");
    });

    animateCursor();
  }

  // ----------------------
  // INIT
  // ----------------------

  function init() {
    initAudio();
    initCursor();
    initInteractionLocks();

    setStatus("CONNECTING");
    updateHint();
    renderProgress();

    window.UNIQUE.refreshStatus = () => {
      state.lastStatusText = "";
      setStatus(state.status);
      updateHint();
    };

    window.addEventListener("message", handleFiveMMessage);
    document.addEventListener("keydown", handleKeyboard);
  }

  init();
});
