document.addEventListener('DOMContentLoaded', () => {
  const exportBtn = document.getElementById('exportCardBtn');
  const cardTarget = document.querySelector('.headerName');
  if (!exportBtn || !cardTarget) return;

  exportBtn.addEventListener('click', () => {
    if (typeof html2canvas !== 'function') return;

    exportBtn.disabled = true;
    exportBtn.classList.add('exporting');

    html2canvas(cardTarget, {
      backgroundColor: '#0d0f13',
      scale: 2,
      useCORS: true,
    }).then(canvas => {
      const link = document.createElement('a');
      link.download = 'profile-card.png';
      link.href = canvas.toDataURL('image/png');
      link.click();
    }).catch(() => {
      // silently ignore — export is a nice-to-have, never block the UI
    }).finally(() => {
      exportBtn.disabled = false;
      exportBtn.classList.remove('exporting');
    });
  });
});
