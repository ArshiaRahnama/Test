(function () {
	'use strict';

	const resourceName = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'esx_vehicleshop';

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

	const ICONS = {
		bike: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><circle cx="5.5" cy="17" r="3.2"/><circle cx="18.5" cy="17" r="3.2"/><path d="M5.5 17 9 9h5l4 6M9 9 7.5 6h-2M12.5 9l2 4h4"/></svg>',
		suv:  '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M3 17V11.5l2-4.2A2 2 0 0 1 6.8 6.2h10.4a2 2 0 0 1 1.8 1.1l2 4.2V17"/><path d="M3 17h18"/><circle cx="7" cy="17" r="1.8"/><circle cx="17" cy="17" r="1.8"/></svg>',
		van:  '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M3 8h13l4 4v5H3z"/><path d="M3 8v9M16 8v9"/><circle cx="7.5" cy="17" r="1.8"/><circle cx="16.5" cy="17" r="1.8"/></svg>',
		car:  '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M3.5 16.5 5 11.2a2 2 0 0 1 1.9-1.4h10.2A2 2 0 0 1 19 11.2l1.5 5.3"/><path d="M3.5 16.5h17v2h-17zM6 9.8 7.5 6h9L18 9.8"/><circle cx="7.2" cy="18.3" r="1.6"/><circle cx="16.8" cy="18.3" r="1.6"/></svg>',
	};

	function iconFor(category) {
		if (category === 'motorcycles') return ICONS.bike;
		if (category === 'suvs' || category === 'offroad') return ICONS.suv;
		if (category === 'vans') return ICONS.van;
		return ICONS.car;
	}

	const state = {
		open: false,
		categories: [],
		vehicles: [],
		ownedVehicles: [],
		config: {},
		isGang: false,
		activeCategory: 'all',
		selectedModel: null,
		searchTerm: '',
	};

	const el = {};
	function cacheEls() {
		['app','closeBtn','categoryTabs','cashValue','bankValue','searchInput','vehicleList',
		 'rotateHint','autoRotateBtn','emptyState','vehicleDetails','vehicleName','vehicleCategory',
		 'statSpeed','statAccel','statBrake','statSeats','priceValue','effectivePriceValue',
		 'tradeInBlock','tradeInSelect','financeBreakdown','financeText',
		 'testDriveBtn','buyCashBtn','buyFinanceBtn','buyGangBtn',
		 'testDriveHud','testDriveTimer'].forEach(id => { el[id] = document.getElementById(id); });
	}

	function renderCategoryTabs() {
		const tabs = [{ name: 'all', label: 'همه' }].concat(
			state.categories.map(c => ({ name: c.name, label: c.label }))
		);

		el.categoryTabs.innerHTML = '';
		tabs.forEach(tab => {
			const btn = document.createElement('button');
			btn.className = 'category-tab' + (tab.name === state.activeCategory ? ' active' : '');
			btn.textContent = tab.label;
			btn.addEventListener('click', () => {
				state.activeCategory = tab.name;
				renderCategoryTabs();
				renderVehicleList();
			});
			el.categoryTabs.appendChild(btn);
		});
	}

	function categoryLabel(name) {
		const c = state.categories.find(c => c.name === name);
		return c ? c.label : name;
	}

	function renderVehicleList() {
		const term = state.searchTerm.trim().toLowerCase();

		const filtered = state.vehicles.filter(v => {
			if (state.activeCategory !== 'all' && v.category !== state.activeCategory) return false;
			if (term && !v.name.toLowerCase().includes(term)) return false;
			return true;
		});

		el.vehicleList.innerHTML = '';
		filtered.forEach(v => {
			const card = document.createElement('div');
			card.className = 'vehicle-card' + (v.model === state.selectedModel ? ' active' : '');
			card.innerHTML = `<span class="icon">${iconFor(v.category)}</span>
				<span class="info"><span class="name">${v.name}</span><span class="price">${money(v.price)}</span></span>`;
			card.addEventListener('click', () => selectVehicle(v));
			el.vehicleList.appendChild(card);
		});
	}

	function populateTradeIn() {
		el.tradeInSelect.innerHTML = '<option value="">بدون معاوضه</option>';
		state.ownedVehicles.forEach(v => {
			const opt = document.createElement('option');
			opt.value = v.plate;
			opt.textContent = `${v.name} (${v.plate})`;
			el.tradeInSelect.appendChild(opt);
		});

		const show = state.config.tradeIn && state.config.tradeIn.Enable && state.ownedVehicles.length > 0;
		el.tradeInBlock.classList.toggle('hidden', !show);
	}

	let currentVehicle = null;

	function selectVehicle(v) {
		currentVehicle = v;
		state.selectedModel = v.model;
		renderVehicleList();

		el.emptyState.classList.add('hidden');
		el.vehicleDetails.classList.remove('hidden');

		el.vehicleName.textContent = v.name;
		el.vehicleCategory.textContent = categoryLabel(v.category);

		el.buyGangBtn.classList.toggle('hidden', !state.isGang);
		el.testDriveBtn.classList.toggle('hidden', !(state.config.testDrive && state.config.testDrive.Enable));
		el.buyFinanceBtn.classList.toggle('hidden', !(state.config.financing && state.config.financing.Enable));

		postNUI('selectVehicle', { model: v.model });

		postNUI('getStats', { model: v.model }).then(stats => {
			if (!stats || currentVehicle !== v) return;
			el.statSpeed.style.width = Math.min(100, (stats.topSpeed / 260) * 100) + '%';
			el.statAccel.style.width = Math.min(100, stats.acceleration) + '%';
			el.statBrake.style.width = Math.min(100, stats.braking) + '%';
			el.statSeats.textContent = stats.seats;
		});

		refreshQuote();
	}

	function refreshQuote() {
		if (!currentVehicle) return;
		const tradeInPlate = el.tradeInSelect.value || '';

		postNUI('getQuote', { model: currentVehicle.model, tradeInPlate }).then(res => {
			if (!res || !res.quote || !currentVehicle) return;
			const q = res.quote;

			el.priceValue.textContent = money(q.price);
			el.effectivePriceValue.textContent = money(q.effectivePrice);

			el.buyCashBtn.disabled = !q.canAffordFull;
			el.buyGangBtn.disabled = !q.canAffordFull;

			if (q.financing) {
				el.financeBreakdown.classList.remove('hidden');
				el.financeText.textContent =
					`پیش‌پرداخت ${money(q.financing.downPayment)} + ${q.financing.installments} قسط ${money(q.financing.installmentAmount)} تومانی (سود ${state.config.financing.InterestPercent}%)`;
				el.buyFinanceBtn.disabled = !q.financing.canAffordDown;
			} else {
				el.financeBreakdown.classList.add('hidden');
			}
		});
	}

	function openShowroom(data) {
		state.categories    = data.categories || [];
		state.vehicles      = data.vehicles || [];
		state.ownedVehicles = data.ownedVehicles || [];
		state.config        = data.config || {};
		state.isGang         = !!data.isGang;
		state.activeCategory = 'all';
		state.selectedModel  = null;
		state.searchTerm     = '';
		currentVehicle        = null;

		el.searchInput.value = '';
		el.cashValue.textContent = money(data.cash);
		el.bankValue.textContent = money(data.bank);

		el.emptyState.classList.remove('hidden');
		el.vehicleDetails.classList.add('hidden');

		renderCategoryTabs();
		populateTradeIn();
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

	// ------------------------------------------------------------ wiring

	document.addEventListener('DOMContentLoaded', () => {
		cacheEls();

		el.closeBtn.addEventListener('click', () => { postNUI('close'); closeShowroom(); });

		el.searchInput.addEventListener('input', (e) => {
			state.searchTerm = e.target.value;
			renderVehicleList();
		});

		el.tradeInSelect.addEventListener('change', refreshQuote);

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
			postNUI('buyVehicle', {
				model: currentVehicle.model,
				paymentMethod: 'full',
				tradeInPlate: el.tradeInSelect.value || '',
				buyForGang: false,
			});
		});

		el.buyFinanceBtn.addEventListener('click', () => {
			if (!currentVehicle) return;
			postNUI('buyVehicle', {
				model: currentVehicle.model,
				paymentMethod: 'finance',
				tradeInPlate: el.tradeInSelect.value || '',
				buyForGang: false,
			});
		});

		el.buyGangBtn.addEventListener('click', () => {
			if (!currentVehicle) return;
			postNUI('buyVehicle', {
				model: currentVehicle.model,
				paymentMethod: 'full',
				tradeInPlate: el.tradeInSelect.value || '',
				buyForGang: true,
			});
		});

		document.addEventListener('keydown', (e) => {
			if (e.key === 'Escape' && state.open) {
				postNUI('close');
				closeShowroom();
			}
		});

		// drag-to-rotate: only when the drag starts outside the UI chrome
		let dragging = false;
		let lastX = 0;
		let pendingDelta = 0;
		let frameQueued = false;

		document.addEventListener('mousedown', (e) => {
			if (!state.open) return;
			if (e.target.closest('.topbar, .vehicle-rail, .bottom-panel, .rotate-hint')) return;
			dragging = true;
			lastX = e.clientX;
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
				case 'testDriveEnded':
					el.testDriveHud.classList.add('hidden');
					break;
			}
		});
	});
})();
