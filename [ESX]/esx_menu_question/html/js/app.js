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
		'<div id="menu_{{_namespace}}_{{_name}}" class="aconfirm{{#align}} align-{{align}}{{/align}}">' +
			'<div class="aconfirm-glow"></div>' +
			'<div class="aconfirm-head">' +
				'<div class="aconfirm-ic"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="9.5"/><path d="M9.3 9a2.7 2.7 0 1 1 3.6 2.5c-.7.3-1.4.9-1.4 1.8v.2"/><circle cx="11.5" cy="16.6" r="0.7" fill="currentColor" stroke="none"/></svg></div>' +
				'<div class="aconfirm-title">{{{title}}}</div>' +
			'</div>' +
			'{{#question}}<div class="aconfirm-q">{{question}}</div>{{/question}}' +
			'<div class="aconfirm-opts">' +
				'{{#elements}}' +
					'<div class="menu-item aconfirm-opt{{#selected}} selected{{/selected}}">{{{label}}}</div>' +
				'{{/elements}}' +
			'</div>' +
			'<div class="aconfirm-foot"><span class="aconfirm-hint"><span class="kbd">&#8596;</span> Entekhab</span><span class="aconfirm-hint"><span class="kbd">Enter</span> Taid</span></div>' +
		'</div>'
	;

	window.ESX_MENU       = {};
	ESX_MENU.ResourceName = 'esx_menu_question';
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
				data.elements[i].type = 'question';
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

		ESX_MENU.render();
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

		ESX_MENU.render();

	};

	ESX_MENU.render = function() {

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

						default : break;
					}

					if (i == ESX_MENU.pos[namespace][name]) {
						element.selected = true;
					}
				}

				let menu = $(Mustache.render(MenuTpl, view))[0];
				$(menu).hide();
				menuContainer.appendChild(menu);
			}
		}

		if (typeof focused != 'undefined') {
			$('#menu_' + focused.namespace + '_' + focused.name).show();
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

					case 'LEFT': {

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

					case 'RIGHT' : {

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

					case 'TOP' : {

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
										elem.value--;
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

					case 'DOWN' : {

						let focused = ESX_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu = ESX_MENU.opened[focused.namespace][focused.name];
							let pos  = ESX_MENU.pos[focused.namespace][focused.name];
							let elem = menu.elements[pos];

							switch(elem.type) {
								case 'default': break;

								case 'slider': {
									if (typeof elem.options != 'undefined' && elem.value < elem.options.length - 1) {
										elem.value++;
										ESX_MENU.change(focused.namespace, focused.name, elem);
									}

									if (typeof elem.max != 'undefined' && elem.value < elem.max) {
										elem.value++;
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
