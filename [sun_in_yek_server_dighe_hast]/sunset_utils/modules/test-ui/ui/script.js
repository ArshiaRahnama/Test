const msgEl = document.getElementById('message');
const serverIdEl = document.getElementById('server-id');
const jobEl = document.getElementById('job');
const inputEl = document.getElementById('input-text');
const responseEl = document.getElementById('response');

window.addEventListener('message', function (event) {
    const msg = event.data;

    if (msg.type === 'initData') {
        const d = msg.data;
        msgEl.textContent = d.message || 'UI baz shod!';
        serverIdEl.textContent = d.serverId || '-';
        jobEl.textContent = d.job || '-';
    }

    if (msg.type === 'updateData') {
        const d = msg.data;
        if (d.response) {
            responseEl.textContent = d.response;
            responseEl.classList.add('show');
        }
        if (d.message) {
            msgEl.textContent = d.message;
        }
    }
});

document.getElementById('btn-close').addEventListener('click', function () {
    window.parent.postMessage({ type: 'closeUI' }, '*');
});

document.getElementById('btn-send').addEventListener('click', function () {
    const text = inputEl.value.trim();
    if (!text) return;
    window.parent.postMessage({
        type: 'nuiCallback',
        action: 'send',
        data: { text: text }
    }, '*');
    inputEl.value = '';
});

document.getElementById('btn-ping').addEventListener('click', function () {
    window.parent.postMessage({
        type: 'nuiCallback',
        action: 'ping',
        data: {}
    }, '*');
});

document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') {
        window.parent.postMessage({ type: 'closeUI' }, '*');
    }
});
