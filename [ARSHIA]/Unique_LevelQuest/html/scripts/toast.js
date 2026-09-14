document.addEventListener('DOMContentLoaded', () => {
  const stack = document.getElementById('toastStack');
  if (!stack) return;

  window.addEventListener('message', (event) => {
    const data = event.data;
    if (data.type !== 'achievementToast') return;

    const toast = document.createElement('div');
    toast.className = 'achievementToastCard';
    toast.innerHTML = `
      <div class="toastIcon"><i class="fa-solid fa-trophy"></i></div>
      <div class="toastText">
        <div class="toastTitle">${data.title || 'Achievement'}</div>
        <div class="toastDesc">${data.description || ''}</div>
      </div>
    `;
    stack.appendChild(toast);

    if (typeof playChime === 'function') playChime();

    setTimeout(() => {
      toast.classList.add('toastLeaving');
      setTimeout(() => toast.remove(), 350);
    }, 4000);
  });
});
