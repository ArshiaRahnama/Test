(function () {
	'use strict';

	var RES = 'sun-jail';

	var LIST = [];      // suggestion-haye job-e jary {label, time}
	var VISIBLE = [];
	var JOB = '';
	var PENDING = null; // {reason, time}

	var PINS = loadPins();

	function loadPins() {
		try {
			var raw = localStorage.getItem('sun_jail_pins');
			if (!raw) return {};
			var obj = JSON.parse(raw);
			return (obj && typeof obj === 'object') ? obj : {};
		} catch (e) { return {}; }
	}

	function savePins() {
		try { localStorage.setItem('sun_jail_pins', JSON.stringify(PINS)); } catch (e) {}
	}

	function pinsFor(job) {
		if (!PINS[job]) PINS[job] = [];
		return PINS[job];
	}

	function isPinned(label) {
		return pinsFor(JOB).indexOf(label) >= 0;
	}

	function togglePin(label) {
		var arr = pinsFor(JOB);
		var idx = arr.indexOf(label);
		if (idx >= 0) arr.splice(idx, 1);
		else arr.push(label);
		savePins();
		render(searchEl.value);
	}

	var wrap     = document.getElementById('ghabz');
	var listEl   = document.getElementById('ghabz-list');
	var searchEl = document.getElementById('ghabz-search');
	var fReason  = document.getElementById('f-reason');
	var fTime    = document.getElementById('f-time');
	var fSend    = document.getElementById('f-send');
	var confirmEl   = document.getElementById('ghabz-confirm');
	var confirmBody = document.getElementById('confirm-body');

	function post(name, data) {
		return fetch('https://' + RES + '/' + name, {
			method: 'POST',
			headers: { 'Content-Type': 'application/json; charset=UTF-8' },
			body: JSON.stringify(data || {})
		}).catch(function () {});
	}

	function setAcc(c) {
		if (c) document.documentElement.style.setProperty('--acc', c);
	}

	function render(filter) {
		var q = (filter || '').toLowerCase();
		var pins = pinsFor(JOB);
		var pinned = [], rest = [];

		for (var i = 0; i < LIST.length; i++) {
			var s = LIST[i];
			if (q && ('' + s.label).toLowerCase().indexOf(q) === -1) continue;
			if (pins.indexOf(s.label) >= 0) pinned.push(s);
			else rest.push(s);
		}
		VISIBLE = pinned.concat(rest);

		listEl.innerHTML = '';
		if (VISIBLE.length === 0) {
			var empty = document.createElement('div');
			empty.className = 'ghabz-empty';
			empty.textContent = 'نتیجه‌ای یافت نشد...';
			listEl.appendChild(empty);
			return;
		}

		for (var j = 0; j < VISIBLE.length; j++) {
			(function (s) {
				var item = document.createElement('div');
				item.className = 'ghabz-item';

				var pin = document.createElement('span');
				pin.className = 'ghabz-pin' + (isPinned(s.label) ? ' on' : '');
				pin.innerHTML = '&#9733;';
				pin.addEventListener('click', function (ev) {
					ev.stopPropagation();
					togglePin(s.label);
				});

				var lbl = document.createElement('div');
				lbl.className = 'lbl';
				lbl.textContent = s.label;

				var amt = document.createElement('div');
				amt.className = 'amt';
				amt.textContent = s.time + ' Min';

				item.appendChild(pin);
				item.appendChild(lbl);
				item.appendChild(amt);

				item.addEventListener('click', function () {
					fill(s.label, s.time);
				});

				listEl.appendChild(item);
			})(VISIBLE[j]);
		}
	}

	function fill(reason, time) {
		fReason.value = reason;
		fTime.value = time;
		fReason.focus();
	}

	function askConfirm() {
		var reason = (fReason.value || '').trim();
		var time = parseInt(fTime.value, 10);
		if (!reason) { fReason.focus(); return; }
		if (!time || time <= 0) { fTime.focus(); return; }
		PENDING = { reason: reason, time: time };
		confirmBody.innerHTML = '<b>' + escapeHtml(reason) + '</b><br><b>' + time + ' Min</b>';
		confirmEl.classList.add('show');
	}

	function confirmYes() {
		confirmEl.classList.remove('show');
		if (!PENDING) return;
		var p = PENDING;
		PENDING = null;
		close();
		post('jailPick', { reason: p.reason, time: p.time });
	}

	function confirmNo() {
		PENDING = null;
		confirmEl.classList.remove('show');
	}

	function escapeHtml(t) {
		return ('' + t).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
	}

	function open(data) {
		LIST = data.list || [];
		JOB = data.job || '';
		setAcc(data.color);
		searchEl.value = '';
		fReason.value = '';
		fTime.value = '';
		PENDING = null;
		confirmEl.classList.remove('show');
		render('');
		wrap.classList.add('show');
		setTimeout(function () { searchEl.focus(); }, 50);
	}

	function close() {
		confirmEl.classList.remove('show');
		wrap.classList.remove('show');
	}

	searchEl.addEventListener('input', function () {
		render(searchEl.value);
	});

	searchEl.addEventListener('keydown', function (e) {
		if (e.key === 'Enter' && VISIBLE.length > 0) {
			fill(VISIBLE[0].label, VISIBLE[0].time);
		}
	});

	fReason.addEventListener('input', function () {
		var cleaned = fReason.value.replace(/[^\x00-\x7F]/g, '');
		if (cleaned !== fReason.value) fReason.value = cleaned;
	});

	fTime.addEventListener('input', function () {
		fTime.value = fTime.value.replace(/\D/g, '');
	});

	fSend.addEventListener('click', askConfirm);
	document.getElementById('c-yes').addEventListener('click', confirmYes);
	document.getElementById('c-no').addEventListener('click', confirmNo);

	document.addEventListener('keydown', function (e) {
		if (e.key === 'Escape') {
			if (confirmEl.classList.contains('show')) {
				confirmNo();
			} else {
				close();
				post('jailClose', {});
			}
		}
	});

	window.addEventListener('message', function (e) {
		var data = e.data || {};
		if (data.action === 'open') {
			open(data);
		} else if (data.action === 'close') {
			close();
		} else if (data.action === 'setColor') {
			setAcc(data.color);
		}
	});
})();
