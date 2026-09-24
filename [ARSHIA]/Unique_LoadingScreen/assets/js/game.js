/* Unique Catcher - tiny mini-game for long loads. Toggle with G. */
(function () {
  "use strict";
  const U = window.UNIQUE, $ = (id) => document.getElementById(id);
  const box = $("game"), cv = $("gameCv"), ctx = cv.getContext("2d"), W = cv.width, H = cv.height;
  let run = false, raf = 0, px = W / 2, items = [], score = 0, lives = 3, t = 0, last = 0, over = false, best = 0;
  try { best = Number(localStorage.getItem("unique_ls_best")) || 0; } catch (e) {}

  function reset() { items = []; score = 0; lives = 3; t = 0; over = false; }
  function end() {
    over = true;
    if (score > best) { best = score; try { localStorage.setItem("unique_ls_best", String(best)); } catch (e) {} }
  }

  function draw() {
    ctx.clearRect(0, 0, W, H);
    ctx.fillStyle = "#0b0b0b"; ctx.fillRect(0, 0, W, H);
    ctx.font = "700 15px sans-serif"; ctx.textAlign = "left"; ctx.fillStyle = "#f5b642";
    ctx.fillText("Score " + score + "   Best " + best, 12, 24);
    ctx.textAlign = "right"; ctx.fillStyle = "#ff5c5c"; ctx.fillText("♥".repeat(Math.max(lives, 0)), W - 12, 24);
    items.forEach((i) => {
      ctx.beginPath(); ctx.arc(i.x, i.y, 13, 0, 7);
      ctx.fillStyle = i.bomb ? "#5a1414" : "#f5b642"; ctx.fill();
      ctx.lineWidth = 2; ctx.strokeStyle = i.bomb ? "#ff5c5c" : "#e89628"; ctx.stroke();
      ctx.fillStyle = i.bomb ? "#ff9b9b" : "#7a4a10"; ctx.textAlign = "center"; ctx.fillText(i.bomb ? "✕" : "U", i.x, i.y + 5);
    });
    ctx.fillStyle = "#f5b642"; ctx.beginPath(); ctx.roundRect(px - 44, H - 34, 88, 14, 7); ctx.fill();
    if (over) {
      ctx.fillStyle = "rgba(0,0,0,.65)"; ctx.fillRect(0, 0, W, H);
      ctx.fillStyle = "#fff"; ctx.textAlign = "center"; ctx.font = "800 22px sans-serif"; ctx.fillText("GAME OVER  " + score, W / 2, H / 2);
      ctx.font = "600 13px sans-serif"; ctx.fillStyle = "#f5b642"; ctx.fillText("click to retry", W / 2, H / 2 + 26);
    }
  }

  function loop(ts) {
    if (!run) return;
    const dt = Math.min(0.05, (ts - last) / 1000 || 0); last = ts;
    if (!over) {
      t += dt;
      if (Math.random() < dt * (1.4 + t / 40)) items.push({ x: 20 + Math.random() * (W - 40), y: -16, v: 130 + Math.random() * 90 + t * 3, bomb: Math.random() < 0.22 });
      items = items.filter((i) => {
        i.y += i.v * dt;
        if (i.y > H - 46 && i.y < H - 16 && Math.abs(i.x - px) < 44) { if (i.bomb) { if (--lives <= 0) end(); } else score++; return false; }
        return i.y < H + 20;
      });
    }
    draw(); raf = requestAnimationFrame(loop);
  }

  function toggle(on) {
    if (document.body.classList.contains("is-boosted")) on = false;
    run = on === undefined ? !run : on;
    box.hidden = !run;
    cancelAnimationFrame(raf);
    if (run) { reset(); $("gameHint").textContent = U.dict().gameHint; last = performance.now(); raf = requestAnimationFrame(loop); }
    $("gameBtn").classList.toggle("on", run);
  }

  cv.addEventListener("mousemove", (e) => { const r = cv.getBoundingClientRect(); px = Math.min(W - 44, Math.max(44, (e.clientX - r.left) * (W / r.width))); });
  cv.addEventListener("click", () => { if (over) reset(); });
  $("gameBtn").addEventListener("click", () => toggle());
  document.addEventListener("keydown", (e) => { if (e.code === "KeyG") toggle(); });
  window.addEventListener("message", (e) => { if (e.data && e.data.eventName === "unique:closing") toggle(false); });
  document.addEventListener("unique:boost", () => toggle(false));
  U.onLang.push(() => { if (run) $("gameHint").textContent = U.dict().gameHint; });
})();
