(function () {
	'use strict';

	const resourceName = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'esx_heli';

	function postNUI(name, data) {
		return fetch(`https://${resourceName}/${name}`, {
			method: 'POST',
			headers: { 'Content-Type': 'application/json; charset=UTF-8' },
			body: JSON.stringify(data || {})
		}).then(r => r.json()).catch(() => null);
	}

	function money(n) {
		n = Math.max(0, Math.round(n || 0));
		return '$' + n.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
	}

	const ICON = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M2 6h9M6 2v6"/><ellipse cx="12" cy="15" rx="8" ry="3"/><path d="M12 12V8M9 18l-2 3M15 18l2 3"/></svg>';

	const state = { open: false, vehicles: [], config: {}, cash: 0, bank: 0, selectedModel: null, searchTerm: '' };
	const el = {};
	let currentVehicle = null;

	function cacheEls() {
		['app','closeBtn','shopTitle','cashValue','bankValue','searchInput','vehicleList',
		 'autoRotateBtn','emptyState','vehicleDetails','vehicleName',
		 'statSpeed','statSeats','priceValue','testDriveBtn','buyCashBtn',
		 'testDriveHud','testDriveTimer'].forEach(id => { el[id] = document.getElementById(id); });
	}

	function renderVehicleList() {
		const term = state.searchTerm.trim().toLowerCase();
		const filtered = state.vehicles.filter(v => !term || v.label.toLowerCase().includes(term));

		el.vehicleList.innerHTML = '';
		filtered.forEach(v => {
			const card = document.createElement('div');
			card.className = 'vehicle-card' + (v.model === state.selectedModel ? ' active' : '');
			card.innerHTML = `<span class="icon">${ICON}</span>
				<span class="info"><span class="name">${v.label}</span><span class="price">${money(v.price)}</span></span>`;
			card.addEventListener('click', () => selectVehicle(v));
			el.vehicleList.appendChild(card);
		});
	}

	function selectVehicle(v) {
		currentVehicle = v;
		state.selectedModel = v.model;
		renderVehicleList();

		el.emptyState.classList.add('hidden');
		el.vehicleDetails.classList.remove('hidden');
		el.vehicleName.textContent = v.label;
		el.priceValue.textContent = money(v.price);
		el.testDriveBtn.classList.toggle('hidden', !(state.config.testDrive && state.config.testDrive.Enable));

		const affordable = (state.cash + state.bank) >= v.price;
		el.buyCashBtn.disabled = !affordable;

		postNUI('selectVehicle', { model: v.model });
		postNUI('getStats', { model: v.model }).then(stats => {
			if (!stats || currentVehicle !== v) return;
			el.statSpeed.style.width = Math.min(100, (stats.topSpeed / 220) * 100) + '%';
			el.statSeats.textContent = stats.seats;
		});
	}

	function openShowroom(data) {
		state.vehicles     = data.vehicles || [];
		state.config        = data.config || {};
		state.cash           = data.cash || 0;
		state.bank            = data.bank || 0;
		state.selectedModel   = null;
		state.searchTerm      = '';
		currentVehicle          = null;

		if (data.shopTitle) el.shopTitle.textContent = data.shopTitle;
		el.searchInput.value = '';
		el.cashValue.textContent = money(state.cash);
		el.bankValue.textContent = money(state.bank);

		el.emptyState.classList.remove('hidden');
		el.vehicleDetails.classList.add('hidden');

		renderVehicleList();

		el.app.classList.remove('hidden');
		el.testDriveHud.classList.add('hidden');
		state.open = true;
	}

	function reopenShowroom() {
		el.app.classList.remove('hidden');
		el.testDriveHud.classList.add('hidden');
		state.open = true;
	}

	function closeShowroom() {
		el.app.classList.add('hidden');
		state.open = false;
	}

	document.addEventListener('DOMContentLoaded', () => {
		cacheEls();

		el.closeBtn.addEventListener('click', () => { postNUI('close'); closeShowroom(); });
		el.searchInput.addEventListener('input', (e) => { state.searchTerm = e.target.value; renderVehicleList(); });

		el.autoRotateBtn.addEventListener('click', () => {
			const enabled = el.autoRotateBtn.textContent.includes('روشن');
			el.autoRotateBtn.textContent = 'چرخش خودکار: ' + (enabled ? 'خاموش' : 'روشن');
			postNUI('toggleAutoRotate', { enabled: !enabled });
		});

		el.testDriveBtn.addEventListener('click', () => {
			postNUI('startTestDrive', { model: currentVehicle && currentVehicle.model });
		});

		el.buyCashBtn.addEventListener('click', () => {
			if (!currentVehicle) return;
			postNUI('buyVehicle', { model: currentVehicle.model });
		});

		document.addEventListener('keydown', (e) => {
			if (e.key === 'Escape' && state.open) { postNUI('close'); closeShowroom(); }
		});

		let dragging = false, lastX = 0, pendingDelta = 0, frameQueued = false;
		document.addEventListener('mousedown', (e) => {
			if (!state.open) return;
			if (e.target.closest('.topbar, .vehicle-rail, .bottom-panel, .rotate-hint')) return;
			dragging = true; lastX = e.clientX;
		});
		document.addEventListener('mousemove', (e) => {
			if (!dragging) return;
			pendingDelta += (e.clientX - lastX) * 0.15;
			lastX = e.clientX;
			if (!frameQueued) {
				frameQueued = true;
				requestAnimationFrame(() => {
					if (pendingDelta !== 0) postNUI('rotateCamera', { delta: pendingDelta });
					pendingDelta = 0;
					frameQueued = false;
				});
			}
		});
		document.addEventListener('mouseup', () => { dragging = false; });

		window.addEventListener('message', (event) => {
			const d = event.data || {};
			switch (d.action) {
				case 'open': openShowroom(d); break;
				case 'reopen': reopenShowroom(); break;
				case 'close': closeShowroom(); break;
				case 'testDriveTick': {
					el.testDriveHud.classList.remove('hidden');
					const m = Math.floor(d.timeLeft / 60).toString().padStart(2, '0');
					const s = (d.timeLeft % 60).toString().padStart(2, '0');
					el.testDriveTimer.textContent = `${m}:${s}`;
					break;
				}
				case 'testDriveEnded': el.testDriveHud.classList.add('hidden'); break;
			}
		});
	});
})();
