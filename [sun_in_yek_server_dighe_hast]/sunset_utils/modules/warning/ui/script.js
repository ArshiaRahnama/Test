const textEl = document.getElementById('warning-text');
const fillEl = document.getElementById('progress-fill');
const labelEl = document.getElementById('progress-label');
const durationEl = document.getElementById('duration-label');

function toPersianDigits(input) {
    return String(input).replace(/\d/g, function (d) {
        return '۰۱۲۳۴۵۶۷۸۹'[d];
    });
}

function applyInit(d) {
    if (typeof d.text === 'string') {
        textEl.textContent = d.text;
    }
    if (typeof d.duration === 'number') {
        durationEl.textContent = toPersianDigits(Math.round(d.duration));
    }
    fillEl.style.width = '0%';
    labelEl.textContent = '۰٪';
}

window.addEventListener('message', function (event) {
    const msg = event.data;
    if (!msg) return;

    if (msg.type === 'initData') {
        applyInit(msg.data || {});
    }

    if (msg.type === 'updateData') {
        const d = msg.data || {};
        if (typeof d.text === 'string') {
            textEl.textContent = d.text;
        }
        if (typeof d.duration === 'number') {
            durationEl.textContent = toPersianDigits(Math.round(d.duration));
        }
        if (typeof d.progress === 'number') {
            const pct = Math.max(0, Math.min(100, Math.round(d.progress * 100)));
            fillEl.style.width = pct + '%';
            labelEl.textContent = toPersianDigits(pct) + '٪';
        }
    }
});
