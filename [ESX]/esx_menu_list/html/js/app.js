/*
 * esx_menu_list UI - Sunset look, self-contained.
 *
 * Sunset's version is an obfuscated Vue 2 app that loads Vue from cdn.sunrp.ir and
 * icons from Google Fonts. This one reproduces the same layout/behaviour with plain
 * DOM code, so nothing external is needed.
 *
 * Data contract (unchanged, what esx_society / Unique_ALLGangs already send):
 *   rows[i].cols = [ avatarHtml, name, rank, actions ]      (4 columns)
 *   rows[i].cols = [ name, rank, extra ]                    (3 columns, no avatar)
 *   actions: '{{label|value}} {{label|value}}'  -> icon buttons; 'DISABLE' -> none
 *   rows[i].data is handed back to Lua on submit.
 *
 * Table mode ('list2', Sunset's sun-list): same payload shape, but head/rows are drawn
 * as a table (orange header, striped rows):
 *   head = { 'TS', 'Date', 'Content' },  rows[i].cols = { a, b, c }
 *   A cell is shown as plain text (so log lines containing < > are shown literally),
 *   unless it contains a {{label|value}} marker: then it becomes real <button>s.
 *
 * Differences vs the old Unique UI:
 *   - cell content is sanitized (old one used {{{content}}} = raw HTML injection)
 *   - closing one menu no longer hides the whole screen while another is open
 *   - ESC with no focused menu no longer throws
 *   - rows without action buttons (gang member list) are clickable
 */
(function () {
	'use strict';

	var RES = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'esx_menu_list';

	var PLACEHOLDER_AVATAR = 'data:image/svg+xml;utf8,' + encodeURIComponent(
		'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><rect width="100" height="100" fill="#4b0fd6"/>' +
		'<circle cx="50" cy="38" r="18" fill="#ffffff" fill-opacity=".85"/>' +
		'<path d="M14 92c4-24 20-34 36-34s32 10 36 34z" fill="#ffffff" fill-opacity=".85"/></svg>');

	// Material "edit" / "swap_horiz" / "person_remove" (what Sunset shows for Promote / Swap / anything else)
	var ICONS = {
		edit: '<svg viewBox="0 0 24 24"><path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04a1 1 0 0 0 0-1.41l-2.34-2.34a1 1 0 0 0-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/></svg>',
		swap: '<svg viewBox="0 0 24 24"><path d="M6.99 11 3 15l3.99 4v-3H14v-2H6.99v-3zM21 9l-3.99-4v3H10v2h7.01v3L21 9z"/></svg>',
		remove: '<svg viewBox="0 0 24 24"><path d="M14 8c0-2.21-1.79-4-4-4S6 5.79 6 8s1.79 4 4 4 4-1.79 4-4zm3 6v2h6v-2h-6zM2 18v2h16v-2c0-2.66-5.33-4-8-4s-8 1.34-8 4z"/></svg>'
	};

	var SAFE_TAGS = { img: 1, svg: 1, path: 1, circle: 1, line: 1, polyline: 1, polygon: 1, rect: 1, g: 1, span: 1, b: 1, i: 1, br: 1 };
	var SAFE_ATTRS = {
		width: 1, height: 1, viewbox: 1, fill: 1, stroke: 1, 'stroke-width': 1, 'stroke-linecap': 1,
		'stroke-linejoin': 1, d: 1, cx: 1, cy: 1, r: 1, x: 1, y: 1, x1: 1, y1: 1, x2: 1, y2: 1,
		points: 1, rx: 1, ry: 1, xmlns: 1, 'class': 1, alt: 1
	};
	var SAFE_SRC = /^(https?:\/\/|nui:\/\/|data:image\/(png|jpe?g|gif|webp);base64,)/i;

	var opened = {};      // opened[namespace][name] = menu data
	var focus = [];       // stack of {namespace, name}; last = visible one
	var search = {};      // search text per menu key
	var rowData = {};     // rowData[key] = [row.data, ...]

	// ---------- helpers ----------

	function keyOf(ns, name) { return ns + '_' + name; }

	function post(endpoint, body) {
		try {
			return fetch('https://' + RES + '/' + endpoint, {
				method: 'POST',
				headers: { 'Content-Type': 'application/json; charset=UTF-8' },
				body: JSON.stringify(body)
			}).catch(function () {});
		} catch (e) { /* ignore */ }
	}

	function getFocused() { return focus[focus.length - 1]; }

	// Copies only allow-listed elements/attributes out of an inert <template>. Anything
	// else (script, style, iframe, on* handlers, javascript: urls ...) is dropped.
	function sanitizeInto(parent, html) {
		var tpl = document.createElement('template');
		tpl.innerHTML = html;

		(function walk(src, dst) {
			var nodes = src.childNodes;
			for (var i = 0; i < nodes.length; i++) {
				var n = nodes[i];
				if (n.nodeType === 3) {
					dst.appendChild(document.createTextNode(n.nodeValue));
				} else if (n.nodeType === 1) {
					var tag = n.localName.toLowerCase();
					if (!SAFE_TAGS[tag]) continue;
					var el = document.createElementNS(n.namespaceURI, n.localName);
					var ok = true;
					for (var a = 0; a < n.attributes.length; a++) {
						var attr = n.attributes[a], an = attr.name.toLowerCase();
						if (an === 'src' && tag === 'img') {
							if (SAFE_SRC.test(attr.value.trim())) el.setAttribute('src', attr.value.trim());
							else ok = false;
						} else if (SAFE_ATTRS[an]) {
							el.setAttribute(attr.name, attr.value);
						}
					}
					if (!ok) continue;
					walk(n, el);
					dst.appendChild(el);
				}
			}
		})(tpl.content, parent);
	}

	function textOf(value) {
		if (value === null || value === undefined) return '';
		return String(value).replace(/<[^>]*>/g, '').replace(/\{\{([\s\S]*?)\|[\s\S]*?\}\}/g, '$1').trim();
	}

	function firstImageSrc(html) {
		var holder = document.createElement('div');
		sanitizeInto(holder, String(html));
		var img = holder.querySelector('img');
		return img ? img.getAttribute('src') : null;
	}

	function iconFor(label) {
		if (label === 'Promote') return ICONS.edit;
		if (label === 'Swap') return ICONS.swap;
		return ICONS.remove;
	}

	// Builds the action icons. Returns the number of buttons created.
	function buildActions(container, raw, index, ns, name) {
		raw = String(raw === null || raw === undefined ? '' : raw);
		if (raw === 'DISABLE') return 0; // esx_society: "no actions for this employee"

		var regex = /\{\{([\s\S]*?)\|([\s\S]*?)\}\}/g;
		var last = 0, count = 0, m;

		while ((m = regex.exec(raw)) !== null) {
			if (m.index > last) sanitizeInto(container, raw.slice(last, m.index));

			var btn = document.createElement('span');
			btn.className = 'icons';
			btn.setAttribute('data-id', String(index));
			btn.setAttribute('data-namespace', ns);
			btn.setAttribute('data-name', name);
			btn.setAttribute('data-value', m[2]);
			btn.setAttribute('title', textOf(m[1]));

			if (m[1].indexOf('<') === -1) {
				btn.innerHTML = iconFor(m[1].trim()); // our own constant markup
			} else {
				sanitizeInto(btn, m[1]);              // caller supplied svg
			}
			container.appendChild(btn);
			count++;
			last = regex.lastIndex;
		}
		if (last < raw.length) sanitizeInto(container, raw.slice(last));
		return count;
	}

	// ---------- table mode ('list2') ----------

	function fillCell(td, value, index, ns, name) {
		var str = String(value === null || value === undefined ? '' : value);
		var regex = /\{\{([\s\S]*?)\|([\s\S]*?)\}\}/g;

		if (str.search(/\{\{[\s\S]*?\|[\s\S]*?\}\}/) === -1) {
			td.textContent = str; // plain text: shown literally, never parsed as HTML
			return;
		}

		var last = 0, m;
		while ((m = regex.exec(str)) !== null) {
			if (m.index > last) sanitizeInto(td, str.slice(last, m.index));
			var btn = document.createElement('button');
			btn.type = 'button';
			btn.setAttribute('data-id', String(index));
			btn.setAttribute('data-namespace', ns);
			btn.setAttribute('data-name', name);
			btn.setAttribute('data-value', m[2]);
			sanitizeInto(btn, m[1]);
			if (!btn.textContent && !btn.firstChild) btn.textContent = m[2];
			td.appendChild(btn);
			last = regex.lastIndex;
		}
		if (last < str.length) sanitizeInto(td, str.slice(last));
	}

	function buildTable(ns, name, menuData) {
		var key = keyOf(ns, name);
		var head = Array.isArray(menuData.head) ? menuData.head : [];
		var rows = Array.isArray(menuData.rows) ? menuData.rows : [];
		rowData[key] = [];

		var menu = document.createElement('div');
		menu.id = 'menu_' + key;
		menu.className = 'menu menu-table';

		var table = document.createElement('table');
		var thead = document.createElement('thead');
		var headRow = document.createElement('tr');
		head.forEach(function (h) {
			var td = document.createElement('td');
			td.textContent = String(h === null || h === undefined ? '' : h);
			headRow.appendChild(td);
		});
		thead.appendChild(headRow);
		table.appendChild(thead);

		var tbody = document.createElement('tbody');
		rows.forEach(function (row, i) {
			var cols = row && Array.isArray(row.cols) ? row.cols : [];
			rowData[key].push(row ? row.data : undefined);
			var tr = document.createElement('tr');
			cols.forEach(function (col) {
				var td = document.createElement('td');
				fillCell(td, col, i, ns, name);
				tr.appendChild(td);
			});
			tbody.appendChild(tr);
		});
		table.appendChild(tbody);
		menu.appendChild(table);

		table.addEventListener('click', function (ev) {
			var t = ev.target;
			var btn = t.closest ? t.closest('button[data-namespace]') : null;
			if (btn && table.contains(btn)) {
				submit(btn.getAttribute('data-namespace'), btn.getAttribute('data-name'), {
					data: rowData[key][parseInt(btn.getAttribute('data-id'), 10)],
					value: btn.getAttribute('data-value')
				});
			}
		});

		return menu;
	}

	// ---------- rendering ----------

	function buildMenu(ns, name, menuData) {
		if (menuData._mode === 'table') return buildTable(ns, name, menuData);
		var key = keyOf(ns, name);
		var rows = Array.isArray(menuData.rows) ? menuData.rows : [];
		rowData[key] = [];

		var menu = document.createElement('div');
		menu.id = 'menu_' + key;
		menu.className = 'menu';

		var input = document.createElement('input');
		input.type = 'text';
		input.className = 'search';
		input.placeholder = 'Search';
		input.value = search[key] || '';
		menu.appendChild(input);

		var list = document.createElement('div');
		list.className = 'data';
		list.id = 'data';
		menu.appendChild(list);

		var cards = [];

		rows.forEach(function (row, i) {
			var cols = Array.isArray(row.cols) ? row.cols : [];
			rowData[key].push(row.data);

			var hasAvatarCol = cols.length >= 4 || (cols.length === 3 && /<img/i.test(String(cols[0])));
			var avatarSrc = null, nameText, rankText, actionsRaw;

			if (cols.length >= 4) {
				avatarSrc = firstImageSrc(cols[0]);
				nameText = textOf(cols[1]); rankText = textOf(cols[2]); actionsRaw = cols[3];
			} else if (hasAvatarCol) {
				avatarSrc = firstImageSrc(cols[0]);
				nameText = textOf(cols[1]); rankText = textOf(cols[2]); actionsRaw = '';
			} else {
				// 3 columns without avatar: [name, rank, extra] (gang member list)
				nameText = textOf(cols[0]); rankText = textOf(cols[1]); actionsRaw = '';
				if (cols[2] !== undefined) rankText = rankText + (rankText && textOf(cols[2]) ? ' - ' : '') + textOf(cols[2]);
			}

			// Sunset hides rows that are missing name / rank / actions; here only truly empty rows are skipped
			if (!nameText && !rankText) return;

			var card = document.createElement('div');
			card.className = 'row';
			card.setAttribute('data-search', (nameText + ' ' + rankText).toLowerCase());

			var img = document.createElement('img');
			img.alt = '';
			img.src = avatarSrc || PLACEHOLDER_AVATAR;
			img.addEventListener('error', function () {
				if (img.src !== PLACEHOLDER_AVATAR) img.src = PLACEHOLDER_AVATAR; // Sunset used an external discord image here
			});
			card.appendChild(img);

			var nameEl = document.createElement('div');
			nameEl.className = 'name';
			nameEl.textContent = nameText;
			card.appendChild(nameEl);

			var rankEl = document.createElement('div');
			rankEl.className = 'rank';
			rankEl.textContent = rankText;
			card.appendChild(rankEl);

			var actionsEl = document.createElement('div');
			actionsEl.className = 'actions';
			var buttons = buildActions(actionsEl, actionsRaw, i, ns, name);
			card.appendChild(actionsEl);

			if (buttons === 0 && actionsRaw !== 'DISABLE') {
				card.className += ' clickable';
				card.setAttribute('data-id', String(i));
			}

			list.appendChild(card);
			cards.push(card);
		});

		if (cards.length === 0) {
			var empty = document.createElement('div');
			empty.className = 'empty';
			empty.textContent = '-';
			list.appendChild(empty);
		}

		function applyFilter() {
			var term = (input.value || '').toLowerCase();
			search[key] = input.value;
			cards.forEach(function (c) {
				c.style.display = c.getAttribute('data-search').indexOf(term) === -1 ? 'none' : '';
			});
		}
		input.addEventListener('input', applyFilter);
		applyFilter();

		list.addEventListener('click', function (ev) {
			var t = ev.target;
			var btn = t.closest ? t.closest('.icons') : null;
			if (btn && list.contains(btn)) {
				submit(btn.getAttribute('data-namespace'), btn.getAttribute('data-name'), {
					data: rowData[key][parseInt(btn.getAttribute('data-id'), 10)],
					value: btn.getAttribute('data-value')
				});
				return;
			}
			var card = t.closest ? t.closest('.row.clickable') : null;
			if (card && list.contains(card)) {
				submit(ns, name, { data: rowData[key][parseInt(card.getAttribute('data-id'), 10)], value: undefined });
			}
		});

		return menu;
	}

	function render() {
		var container = document.getElementById('menus');
		container.innerHTML = '';

		var focused = getFocused();
		var body = document.getElementById('macbook');

		if (!focused || !opened[focused.namespace] || !opened[focused.namespace][focused.name]) {
			body.style.display = 'none';
			return;
		}

		var shown = opened[focused.namespace][focused.name];
		container.appendChild(buildMenu(focused.namespace, focused.name, shown));
		body.className = shown._mode === 'table' ? 'table-mode' : '';
		body.style.display = 'block';
	}

	// ---------- public api (same names as before) ----------

	window.ESX_MENU = {
		ResourceName: RES,
		opened: opened,
		focus: focus,

		open: function (namespace, name, data, mode) {
			if (typeof opened[namespace] === 'undefined') opened[namespace] = {};
			if (typeof opened[namespace][name] !== 'undefined') ESX_MENU.close(namespace, name);

			data = data || {};
			data._namespace = namespace;
			data._name = name;
			data._mode = mode === 'table' ? 'table' : 'cards';
			opened[namespace][name] = data;
			focus.push({ namespace: namespace, name: name });
			render();
		},

		close: function (namespace, name) {
			if (opened[namespace]) delete opened[namespace][name];
			delete search[keyOf(namespace, name)];
			delete rowData[keyOf(namespace, name)];
			for (var i = 0; i < focus.length; i++) {
				if (focus[i].namespace === namespace && focus[i].name === name) { focus.splice(i, 1); break; }
			}
			render(); // hides everything only when nothing is left
		},

		getFocused: getFocused
	};

	function submit(namespace, name, d) {
		post('menu_submit', { _namespace: namespace, _name: name, data: d.data, value: d.value });
	}

	function cancel(namespace, name) {
		post('menu_cancel', { _namespace: namespace, _name: name });
	}

	window.addEventListener('message', function (event) {
		var d = event.data;
		if (!d) return;
		if (d.action === 'openMenu') ESX_MENU.open(d.namespace, d.name, d.data, d.mode);
		else if (d.action === 'closeMenu') ESX_MENU.close(d.namespace, d.name);
	});

	document.addEventListener('keyup', function (e) {
		if (e.which === 27 || e.key === 'Escape') {
			var f = getFocused();
			if (f) cancel(f.namespace, f.name);
		}
	});
})();
