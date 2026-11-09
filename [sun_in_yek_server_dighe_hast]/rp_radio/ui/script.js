let frequencies = {};
let editingFreq = null;
let deleteFreq = null;

// Listen for NUI messages
window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.action === 'open') {
        frequencies = data.frequencies || {};
        openUI();
    } else if (data.action === 'close') {
        closeUI();
    }
});

// Keyboard listener for ESC
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        if (!document.getElementById('deleteModal').classList.contains('hidden')) {
            closeDeleteModal();
        } else if (!document.getElementById('editModal').classList.contains('hidden')) {
            closeEditModal();
        } else if (!document.getElementById('app').classList.contains('hidden')) {
            closeUI();
        }
    }
});

function openUI() {
    document.getElementById('app').classList.remove('hidden');
    renderFrequencies();
}

function closeUI() {
    document.getElementById('app').classList.add('hidden');
    closeEditModal();
    closeDeleteModal();
    fetch('https://rp_radio/close', { method: 'POST', body: JSON.stringify({}) });
}

function renderFrequencies() {
    const list = document.getElementById('freqList');
    const searchTerm = document.getElementById('searchInput').value.toLowerCase();

    // Convert to array and sort
    const freqArray = Object.entries(frequencies)
        .map(([freq, access]) => ({
            freq: freq,
            access: access ? Object.keys(access).join(', ') : 'Public'
        }))
        .filter(item =>
            item.freq.toString().includes(searchTerm) ||
            item.access.toLowerCase().includes(searchTerm)
        )
        .sort((a, b) => parseInt(a.freq) - parseInt(b.freq));

    if (freqArray.length === 0) {
        list.innerHTML = `
            <div class="empty-state">
                <p>${searchTerm ? 'No frequencies found' : 'No frequencies configured'}</p>
            </div>
        `;
        return;
    }

    list.innerHTML = freqArray.map(item => `
        <div class="freq-item" onclick="openEditModal('${item.freq}')">
            <span class="freq-number">${item.freq}</span>
            <span class="freq-access">${item.access}</span>
            <button class="delete-btn" onclick="event.stopPropagation(); openDeleteModal('${item.freq}')" title="Delete">
                &#128465;
            </button>
        </div>
    `).join('');
}

function filterFrequencies() {
    renderFrequencies();
}

function openAddModal() {
    editingFreq = null;
    document.getElementById('modalTitle').textContent = 'Add Frequency';
    document.getElementById('freqInput').value = '';
    document.getElementById('freqInput').disabled = false;
    document.getElementById('accessInput').value = '';
    document.getElementById('editModal').classList.remove('hidden');
    document.getElementById('freqInput').focus();
}

function openEditModal(freq) {
    editingFreq = freq;
    document.getElementById('modalTitle').textContent = 'Edit Frequency';
    document.getElementById('freqInput').value = freq;
    document.getElementById('freqInput').disabled = true;

    const access = frequencies[freq];
    const accessStr = access ? Object.keys(access).join('-') : '';
    document.getElementById('accessInput').value = accessStr;

    document.getElementById('editModal').classList.remove('hidden');
    document.getElementById('accessInput').focus();
}

function closeEditModal() {
    document.getElementById('editModal').classList.add('hidden');
    editingFreq = null;
}

function saveFrequency() {
    const freqInput = document.getElementById('freqInput');
    const accessInput = document.getElementById('accessInput');

    const freq = freqInput.value.trim();
    const accessStr = accessInput.value.trim();

    if (!freq || isNaN(parseInt(freq))) {
        freqInput.style.borderColor = '#e74c3c';
        setTimeout(() => freqInput.style.borderColor = '', 1000);
        return;
    }

    let access = null;
    if (accessStr && accessStr !== '0') {
        access = {};
        accessStr.split('-').forEach(job => {
            const trimmed = job.trim();
            if (trimmed) {
                access[trimmed] = true;
            }
        });
        if (Object.keys(access).length === 0) {
            access = null;
        }
    }

    // Update local state
    if (access) {
        frequencies[freq] = access;
    } else {
        delete frequencies[freq];
    }

    // Send to client
    fetch('https://rp_radio/setFreq', {
        method: 'POST',
        body: JSON.stringify({ freq: freq, access: access })
    });

    closeEditModal();
    renderFrequencies();
}

function openDeleteModal(freq) {
    deleteFreq = freq;
    document.getElementById('deleteFreqNum').textContent = freq;
    document.getElementById('deleteModal').classList.remove('hidden');
}

function closeDeleteModal() {
    document.getElementById('deleteModal').classList.add('hidden');
    deleteFreq = null;
}

function confirmDelete() {
    if (deleteFreq) {
        // Remove from local state
        delete frequencies[deleteFreq];

        // Send to client (null access = delete)
        fetch('https://rp_radio/setFreq', {
            method: 'POST',
            body: JSON.stringify({ freq: deleteFreq, access: null })
        });

        closeDeleteModal();
        renderFrequencies();
    }
}
