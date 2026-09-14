const CONFETTI_COLORS = ['#ff8c1a', '#ffc56d', '#1fd34b', '#6dc9ff', '#ffffff'];

function spawnConfetti(originEl) {
  if (!originEl) return;
  const rect = originEl.getBoundingClientRect();
  const originX = rect.left + rect.width / 2;
  const originY = rect.top + rect.height / 2;

  const container = document.createElement('div');
  container.className = 'confettiContainer';
  document.body.appendChild(container);

  const particleCount = 40;
  for (let i = 0; i < particleCount; i++) {
    const particle = document.createElement('div');
    particle.className = 'confettiParticle';

    const angle = Math.random() * Math.PI * 2;
    const distance = 90 + Math.random() * 140;
    const dx = Math.cos(angle) * distance;
    const dy = Math.sin(angle) * distance - 60; // bias upward
    const rotation = Math.random() * 720 - 360;
    const size = 5 + Math.random() * 5;
    const color = CONFETTI_COLORS[Math.floor(Math.random() * CONFETTI_COLORS.length)];
    const duration = 0.8 + Math.random() * 0.6;

    particle.style.left = `${originX}px`;
    particle.style.top = `${originY}px`;
    particle.style.width = `${size}px`;
    particle.style.height = `${size * 0.6}px`;
    particle.style.background = color;
    particle.style.setProperty('--dx', `${dx}px`);
    particle.style.setProperty('--dy', `${dy}px`);
    particle.style.setProperty('--rot', `${rotation}deg`);
    particle.style.animationDuration = `${duration}s`;

    container.appendChild(particle);
  }

  setTimeout(() => container.remove(), 1600);
}
