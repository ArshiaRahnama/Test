function showPromotionCinematic(level) {
  const windowEl = document.querySelector('.window');
  if (!windowEl) return;

  const overlay = document.createElement('div');
  overlay.className = 'promotionOverlay';
  overlay.innerHTML = `
    <div class="promotionText">
      <div class="promotionLabel">PROMOTED TO</div>
      <div class="promotionLevel">LEVEL ${level}</div>
    </div>
  `;
  windowEl.appendChild(overlay);

  // Matches the CSS animation timeline (fade in, hold, fade out).
  setTimeout(() => overlay.remove(), 2600);
}
