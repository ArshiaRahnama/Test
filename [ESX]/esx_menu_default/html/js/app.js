

(function(){
	// ---- safe HTML for title/label (Mustache prints these raw with {{{ }}}) ----
	// Keeps what callers really use (<span style="color:rgb(..)">, <b>, <i>, <br>, <img src=https/nui/data>)
	// and drops scripts, event handlers, iframes, javascript: urls and unsafe css.
	var SAFE_TAGS  = { span: 1, b: 1, i: 1, u: 1, strong: 1, em: 1, br: 1, small: 1, font: 1, img: 1 };
	var DROP_TAGS  = { script: 1, style: 1, iframe: 1, object: 1, embed: 1, link: 1, meta: 1, template: 1, noscript: 1, svg: 1, math: 1 };
	var SAFE_PROPS = { 'color': 1, 'background-color': 1, 'font-weight': 1, 'font-style': 1, 'font-size': 1, 'text-decoration': 1, 'opacity': 1 };
	var SAFE_VALUE = /^[#a-z0-9 .,%()\-]+$/i;
	var SAFE_SRC   = /^(https?:\/\/|nui:\/\/|data:image\/(png|jpe?g|gif|webp);base64,)/i;

	function cleanStyle(style) {
		var out = [];
		String(style).split(';').forEach(function (decl) {
			var i = decl.indexOf(':');
			if (i < 1) return;
			var prop = decl.slice(0, i).trim().toLowerCase();
			var val  = decl.slice(i + 1).trim();
			if (SAFE_PROPS[prop] && SAFE_VALUE.test(val) && !/url|expression|javascript|import/i.test(val)) {
				out.push(prop + ':' + val);
			}
		});
		return out.join(';');
	}

	function cleanWalk(src, dst) {
		var nodes = src.childNodes;
		for (var i = 0; i < nodes.length; i++) {
			var n = nodes[i];
			if (n.nodeType === 3) {
				dst.appendChild(document.createTextNode(n.nodeValue));
			} else if (n.nodeType === 1) {
				var tag = n.localName.toLowerCase();
				if (DROP_TAGS[tag]) continue;                  // dangerous: drop with content
				if (!SAFE_TAGS[tag]) { cleanWalk(n, dst); continue; } // unknown wrapper: keep its text
				var el = document.createElement(tag);
				var ok = true;
				for (var a = 0; a < n.attributes.length; a++) {
					var an = n.attributes[a].name.toLowerCase(), av = n.attributes[a].value;
					if (an === 'style') { var s = cleanStyle(av); if (s) el.setAttribute('style', s); }
					else if (an === 'src' && tag === 'img') { if (SAFE_SRC.test(av.trim())) el.setAttribute('src', av.trim()); else ok = false; }
					else if ((an === 'width' || an === 'height') && /^\d{1,4}$/.test(av)) el.setAttribute(an, av);
					else if (an === 'color' && tag === 'font' && SAFE_VALUE.test(av)) el.setAttribute('color', av);
				}
				if (!ok) continue;
				cleanWalk(n, el);
				dst.appendChild(el);
			}
		}
	}

	function cleanHtml(html) {
		if (html === null || typeof html === 'undefined') return '';
		var tpl = document.createElement('template');
		tpl.innerHTML = String(html);
		var out = document.createElement('div');
		cleanWalk(tpl.content, out);
		return out.innerHTML;
	}

	function stripTags(html) {
		return String(html === null || typeof html === 'undefined' ? '' : html).replace(/<[^>]*>/g, ' ');
	}

	function scrollSelected(namespace, name) {
		var found = $('#menu_' + namespace + '_' + name).find('.menu-item.selected');
		if (found.length > 0 && found[0].scrollIntoView) found[0].scrollIntoView();
	}

	let MenuTpl =
		'<div id="menu_{{_namespace}}_{{_name}}" class="amenu{{#align}} align-{{align}}{{/align}}">' +
			'<div class="amenu-glow"></div>' +
			'<div class="amenu-head">' +
				'<div class="amenu-ic"><svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1.5"/><rect x="14" y="3" width="7" height="7" rx="1.5"/><rect x="14" y="14" width="7" height="7" rx="1.5"/><rect x="3" y="14" width="7" height="7" rx="1.5"/></svg></div>' +
				'<div class="amenu-title">{{{title}}}</div>' +
			'</div>' +
			'<div class="amenu-rule"></div>' +
			'<div class="amenu-list">' +
				'{{#elements}}' +
				'<div class="menu-item amenu-item{{#selected}} selected{{/selected}}">' +
					'<div class="amenu-iic">{{{iconSvg}}}</div>' +
					'<div class="amenu-label">{{{label}}}{{#isSlider}} <span class="amenu-slider">&#8249;&nbsp;{{{sliderLabel}}}&nbsp;&#8250;</span>{{/isSlider}}</div>' +
					'<div class="amenu-chev">&#8250;</div>' +
				'</div>' +
				'{{/elements}}' +
			'</div>' +
		'</div>'
	;

	var ICONS = {
		cuff: '<path d="M9 17H7A5 5 0 0 1 7 7h2"/><path d="M15 7h2a5 5 0 1 1 0 10h-2"/><line x1="8" y1="12" x2="16" y2="12"/>',
		uncuff: '<path d="M18.84 12.25l1.72-1.71a4 4 0 0 0-5.66-5.66l-1.71 1.72"/><path d="M5.17 11.75l-1.71 1.71a4 4 0 0 0 5.66 5.66l1.71-1.72"/><line x1="8" y1="2" x2="8" y2="5"/><line x1="2" y1="8" x2="5" y2="8"/><line x1="16" y1="19" x2="16" y2="22"/><line x1="19" y1="16" x2="22" y2="16"/>',
		drag: '<path d="M5 9l-3 3 3 3"/><path d="M9 5l3-3 3 3"/><path d="M15 19l-3 3-3-3"/><path d="M19 9l3 3-3 3"/><line x1="2" y1="12" x2="22" y2="12"/><line x1="12" y1="2" x2="12" y2="22"/>',
		carin: '<path d="M12 3v14"/><path d="M6 11l6 6 6-6"/><path d="M5 21h14"/>',
		carout: '<path d="M12 21V7"/><path d="M6 13l6-6 6 6"/><path d="M5 3h14"/>',
		car: '<path d="M5 11l1.5-4.2A2 2 0 0 1 8.4 5.5h7.2a2 2 0 0 1 1.9 1.3L19 11"/><path d="M4 11h16a1 1 0 0 1 1 1v4a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1v-4a1 1 0 0 1 1-1z"/><circle cx="7.5" cy="16.5" r="1.4"/><circle cx="16.5" cy="16.5" r="1.4"/>',
		search: '<circle cx="11" cy="11" r="7"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>',
		boss: '<rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/>',
		duty: '<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="M9 12l2 2 4-4"/>',
		money: '<circle cx="12" cy="12" r="9"/><path d="M14.5 9.5a2.5 2.5 0 0 0-2.5-1.5c-1.4 0-2.5.8-2.5 2s1.1 2 2.5 2 2.5.8 2.5 2-1.1 2-2.5 2a2.5 2.5 0 0 1-2.5-1.5"/><line x1="12" y1="6" x2="12" y2="8"/><line x1="12" y1="16" x2="12" y2="18"/>',
		cloth: '<path d="M16 4l4 2-2 4-2-1v11H8V9L6 10 4 6l4-2 1 1a3 3 0 0 0 6 0z"/>',
		locker: '<rect x="4" y="3" width="16" height="18" rx="2"/><line x1="12" y1="8" x2="12" y2="11"/>',
		gun: '<path d="M21 7H5L3 9v3h2l2-2h3l3 4h2l2-4h4z"/><line x1="7" y1="12" x2="7" y2="15"/>',
		key: '<circle cx="7.5" cy="15.5" r="3.5"/><path d="M10 13l8-8"/><path d="M15 6l2 2"/><path d="M18 3l2 2"/>',
		heli: '<line x1="3" y1="5" x2="21" y2="5"/><line x1="12" y1="5" x2="12" y2="9"/><path d="M7 12h8a3 3 0 0 1 3 3v2H9l-4-3a2 2 0 0 1-1-2v-2z"/><line x1="18" y1="17" x2="22" y2="17"/>',
		def: '<circle cx="12" cy="12" r="9"/><circle cx="12" cy="12" r="2.6" fill="currentColor" stroke="none"/>'
	};

	function svg(inner) { return '<svg viewBox="0 0 24 24">' + inner + '</svg>'; }

	function iconFor(hint) {
		var h = (hint || '').toLowerCase();
		if (h.indexOf('uncuff') > -1 || h.indexOf('un cuff') > -1) return ICONS.uncuff;
		if (h.indexOf('cuff') > -1 || h.indexOf('handcuff') > -1) return ICONS.cuff;
		if (h.indexOf('drag') > -1) return ICONS.drag;
		if ((h.indexOf('out') > -1) && (h.indexOf('vehic') > -1 || h.indexOf('mashin') > -1 || h.indexOf('car') > -1)) return ICONS.carout;
		if ((h.indexOf('put') > -1 || h.indexOf('savar') > -1) && (h.indexOf('vehic') > -1 || h.indexOf('mashin') > -1 || h.indexOf('car') > -1)) return ICONS.carin;
		if (h.indexOf('search') > -1 || h.indexOf('gasht') > -1 || h.indexOf('jib') > -1 || h.indexOf('dast tu') > -1) return ICONS.search;
		if (h.indexOf('cloth') > -1 || h.indexOf('lebas') > -1 || h.indexOf('komod') > -1 || h.indexOf('wear') > -1 || h.indexOf('skin') > -1) return ICONS.cloth;
		if (h.indexOf('boss') > -1 || h.indexOf('modir') > -1 || h.indexOf('manage') > -1 || h.indexOf('aaza') > -1) return ICONS.boss;
		if (h.indexOf('weapon') > -1 || h.indexOf('aslah') > -1 || h.indexOf('gun') > -1 || h.indexOf('armory') > -1) return ICONS.gun;
		if (h.indexOf('money') > -1 || h.indexOf('ghabz') > -1 || h.indexOf('bill') > -1 || h.indexOf('kharid') > -1 || h.indexOf('pelak') > -1 || h.indexOf('mablagh') > -1) return ICONS.money;
		if (h.indexOf('key') > -1 || h.indexOf('lock') > -1 || h.indexOf('pick') > -1) return ICONS.key;
		if (h.indexOf('heli') > -1) return ICONS.heli;
		if (h.indexOf('garage') > -1 || h.indexOf('spawn') > -1 || h.indexOf('vehic') > -1 || h.indexOf('mashin') > -1 || h.indexOf('car') > -1 || h.indexOf('parking') > -1) return ICONS.car;
		if (h.indexOf('anbar') > -1 || h.indexOf('locker') > -1 || h.indexOf('stock') > -1 || h.indexOf('inventory') > -1) return ICONS.locker;
		if (h.indexOf('item') > -1) return ICONS.money;
		if (h.indexOf('duty') > -1 || h.indexOf('service') > -1 || h.indexOf('khedmat') > -1) return ICONS.duty;
		return ICONS.def;
	}
	
	window.ESX_MENU       = {};
	ESX_MENU.ResourceName = 'esx_menu_default';
	ESX_MENU.opened       = {};
	ESX_MENU.focus        = [];
	ESX_MENU.pos          = {};

	ESX_MENU.open = function(namespace, name, data) {

		data = data || {};
		if (!Array.isArray(data.elements)) data.elements = [];

		if (typeof ESX_MENU.opened[namespace] == 'undefined') {
			ESX_MENU.opened[namespace] = {};
		}

		if (typeof ESX_MENU.opened[namespace][name] != 'undefined') {
			ESX_MENU.close(namespace, name);
		}

		if (typeof ESX_MENU.pos[namespace] == 'undefined') {
			ESX_MENU.pos[namespace] = {};
		}

		for (let i=0; i<data.elements.length; i++) {
			if (typeof data.elements[i].type == 'undefined') {
				data.elements[i].type = 'default';
			}
		}

		data._index     = ESX_MENU.focus.length;
		data._namespace = namespace;
		data._name      = name;

		for (let i=0; i<data.elements.length; i++) {
			data.elements[i]._namespace = namespace;
			data.elements[i]._name      = name;
		}

		ESX_MENU.opened[namespace][name] = data;
		ESX_MENU.pos   [namespace][name] = 0;

		for (let i=0; i<data.elements.length; i++) {
			if (data.elements[i].selected) {
				ESX_MENU.pos[namespace][name] = i;
			} else {
				data.elements[i].selected = false;
			}
		}

		ESX_MENU.focus.push({
			namespace: namespace,
			name     : name
		});
		
		ESX_MENU.render(true);
		scrollSelected(namespace, name);
	};

	ESX_MENU.close = function(namespace, name) {
		if (ESX_MENU.opened[namespace]) delete ESX_MENU.opened[namespace][name];
		for (let i=0; i<ESX_MENU.focus.length; i++) {
			if (ESX_MENU.focus[i].namespace == namespace && ESX_MENU.focus[i].name == name) {
				ESX_MENU.focus.splice(i, 1);
				break;
			}
		}
		ESX_MENU.render(false);
	};

	ESX_MENU.render = function(fade = false) {

		let menuContainer       = document.getElementById('menus');
		let focused             = ESX_MENU.getFocused();
		menuContainer.innerHTML = '';


		$(menuContainer).hide();


		for (let namespace in ESX_MENU.opened) {
			for (let name in ESX_MENU.opened[namespace]) {

				let menuData = ESX_MENU.opened[namespace][name];
				let view     = JSON.parse(JSON.stringify(menuData));
				view.title = cleanHtml(view.title);

				for (let i=0; i<menuData.elements.length; i++) {
					let element = view.elements[i];
					element.label = cleanHtml(element.label);
					switch (element.type) {
						case 'default' : break;
						case 'slider' : {
							element.isSlider    = true;
							element.sliderLabel = cleanHtml((typeof element.options == 'undefined') ? element.value : element.options[element.value]);
							break;
						}
						case 'html' :
							{
								break;
							}
						default : break;
					}

					element.iconSvg = svg(iconFor(stripTags(menuData.elements[i].label) + ' ' + (element.value != null ? element.value : '')));

					if (i == ESX_MENU.pos[namespace][name]) {
						element.selected = true;
					}
				}

				let menu = $(Mustache.render(MenuTpl, view))[0];
				$(menu).hide();
				menuContainer.appendChild(menu);
			}
		}
		if(fade == false){
			if (typeof focused != 'undefined') {
				$('#menu_' + focused.namespace + '_' + focused.name).show();
			}
		}else{
			if (typeof focused != 'undefined') {
				if(focused.name == 'skin'){
					$('#menu_' + focused.namespace + '_' + focused.name).show();
				}else{
					$('#menu_' + focused.namespace + '_' + focused.name).fadeIn();
				}
			}
		}

		$(menuContainer).show();

	};

	ESX_MENU.submit = function(namespace, name, data) {
		$.post('http://' + ESX_MENU.ResourceName + '/menu_submit', JSON.stringify({
			_namespace: namespace,
			_name     : name,
			current   : data,
			elements  : ESX_MENU.opened[namespace][name].elements
		}));
	};

	ESX_MENU.cancel = function(namespace, name) {
		$.post('http://' + ESX_MENU.ResourceName + '/menu_cancel', JSON.stringify({
			_namespace: namespace,
			_name     : name
		}));
	};

	ESX_MENU.change = function(namespace, name, data) {
		$.post('http://' + ESX_MENU.ResourceName + '/menu_change', JSON.stringify({
			_namespace: namespace,
			_name     : name,
			current   : data,
			elements  : ESX_MENU.opened[namespace][name].elements
		}));
	};

	ESX_MENU.getFocused = function() {
		return ESX_MENU.focus[ESX_MENU.focus.length - 1];
	};

	window.onData = (data) => {

		switch (data.action) {

			case 'openMenu': {
				ESX_MENU.open(data.namespace, data.name, data.data);
				break;
			}

			case 'closeMenu': {
				ESX_MENU.close(data.namespace, data.name);
				break;
			}

			case 'controlPressed': {

				{
					let f = ESX_MENU.getFocused();
					let m = f && ESX_MENU.opened[f.namespace] ? ESX_MENU.opened[f.namespace][f.name] : null;
					if ((!f || !m || m.elements.length === 0) && data.control !== 'BACKSPACE') break;
				}

				switch (data.control) {

					case 'ENTER': {
						let focused = ESX_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu    = ESX_MENU.opened[focused.namespace][focused.name];
							let pos     = ESX_MENU.pos[focused.namespace][focused.name];
							let elem    = menu.elements[pos];

							if (menu.elements.length > 0) {
								ESX_MENU.submit(focused.namespace, focused.name, elem);
							}
						}

						break;
					}

					case 'BACKSPACE': {
						let focused = ESX_MENU.getFocused();

						if (typeof focused != 'undefined') {
							ESX_MENU.cancel(focused.namespace, focused.name);
						}

						break;
					}

					case 'TOP': {

						let focused = ESX_MENU.getFocused();

						if (typeof focused != 'undefined') {

							let menu = ESX_MENU.opened[focused.namespace][focused.name];
							let pos  = ESX_MENU.pos[focused.namespace][focused.name];

							if (pos > 0) {
								ESX_MENU.pos[focused.namespace][focused.name]--;
							} else {
								ESX_MENU.pos[focused.namespace][focused.name] = menu.elements.length - 1;
							}

							let elem = menu.elements[ESX_MENU.pos[focused.namespace][focused.name]];

							for (let i=0; i<menu.elements.length; i++) {
								if (i == ESX_MENU.pos[focused.namespace][focused.name]) {
									menu.elements[i].selected = true;
								} else {
									menu.elements[i].selected = false;
								}
							}

							ESX_MENU.change(focused.namespace, focused.name, elem);
							ESX_MENU.render();

							scrollSelected(focused.namespace, focused.name);
						}

						break;

					}

					case 'DOWN' : {

						let focused = ESX_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu   = ESX_MENU.opened[focused.namespace][focused.name];
							let pos    = ESX_MENU.pos[focused.namespace][focused.name];
							let length = menu.elements.length;

							if (pos < length - 1) {
								ESX_MENU.pos[focused.namespace][focused.name]++;
							} else {
								ESX_MENU.pos[focused.namespace][focused.name] = 0;
							}

							let elem = menu.elements[ESX_MENU.pos[focused.namespace][focused.name]];

							for (let i=0; i<menu.elements.length; i++) {
								if (i == ESX_MENU.pos[focused.namespace][focused.name]) {
									menu.elements[i].selected = true;
								} else {
									menu.elements[i].selected = false;
								}
							}

							ESX_MENU.change(focused.namespace, focused.name, elem);
							ESX_MENU.render();

							scrollSelected(focused.namespace, focused.name);
						}

						break;
					}

					case 'LEFT' : {

						let focused = ESX_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu = ESX_MENU.opened[focused.namespace][focused.name];
							let pos  = ESX_MENU.pos[focused.namespace][focused.name];
							let elem = menu.elements[pos];

							switch(elem.type) {
								case 'default': break;

								case 'slider': {
									let min = (typeof elem.min == 'undefined') ? 0 : elem.min;
								
									if (elem.value > min) {
										let scriptClotheMin = (typeof elem.scriptClotheMin == 'undefined') ? -1 : elem.scriptClotheMin;
										let scriptClotheMax = (typeof elem.scriptClotheMax == 'undefined') ? -1 : elem.scriptClotheMax;
										if(scriptClotheMin != -1 && scriptClotheMax != -1 && elem.value == scriptClotheMax){
											elem.value = scriptClotheMin;
										}
										else{
											elem.value--;
										}
										ESX_MENU.change(focused.namespace, focused.name, elem);
									}

									ESX_MENU.render();
									break;
								}

								default: break;
							}

							scrollSelected(focused.namespace, focused.name);
						}

						break;
					}

					case 'RIGHT' : {

						let focused = ESX_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu = ESX_MENU.opened[focused.namespace][focused.name];
							let pos  = ESX_MENU.pos[focused.namespace][focused.name];
							let elem = menu.elements[pos];

							switch(elem.type) {
								case 'default': break;

								case 'slider': {
									let scriptClotheMin = (typeof elem.scriptClotheMin == 'undefined') ? -1 : elem.scriptClotheMin;
									let scriptClotheMax = (typeof elem.scriptClotheMax == 'undefined') ? -1 : elem.scriptClotheMax;
									if (typeof elem.options != 'undefined' && elem.value < elem.options.length - 1) {
										if(scriptClotheMin != -1 && scriptClotheMax != -1 && elem.value == scriptClotheMin)
										{
											elem.value = scriptClotheMax;
										}
										else
										{
											elem.value++;
										}
										ESX_MENU.change(focused.namespace, focused.name, elem);
									}

									if (typeof elem.max != 'undefined' && elem.value < elem.max) {
										if(scriptClotheMin != -1 && scriptClotheMax != -1 && elem.value == scriptClotheMin)
										{
											elem.value = scriptClotheMax;
										}
										else
										{
											elem.value++;
										}
										ESX_MENU.change(focused.namespace, focused.name, elem);
									}

									ESX_MENU.render();
									break;
								}

								default: break;
							}

							scrollSelected(focused.namespace, focused.name);
						}

						break;
					}

					default : break;

				}

				break;
			}

		}

	};
	window.addEventListener('message', (event) => {
		if (event.data) onData(event.data);
	});
})();