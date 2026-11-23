(function () {
    'use strict';

    // ------------------------------------------------------------------ icons (24x24, stroke based)
    var ICONS = {
        user:     '<circle cx="12" cy="8" r="3.6"/><path d="M5 20c.8-3.6 3.6-5.4 7-5.4s6.2 1.8 7 5.4"/>',
        users:    '<circle cx="9" cy="8.5" r="3.2"/><path d="M3 19.5c.7-3.2 3-4.8 6-4.8s5.3 1.6 6 4.8"/><path d="M16 5.6a3.2 3.2 0 010 5.8M18 14.9c1.7.6 2.7 2 3 4.6"/>',
        heart:    '<path d="M12 20s-7.5-4.6-7.5-10A4.2 4.2 0 0112 7.6 4.2 4.2 0 0119.5 10c0 5.4-7.5 10-7.5 10z"/>',
        shield:   '<path d="M12 3l7 2.8v5.4c0 4.4-3 8-7 9.8-4-1.8-7-5.4-7-9.8V5.8z"/>',
        car:      '<path d="M4 15.5V12l1.7-4.6A2 2 0 017.6 6h8.8a2 2 0 011.9 1.4L20 12v3.5"/><path d="M3 15.5h18V18H3z"/><circle cx="7.5" cy="18" r="1.4"/><circle cx="16.5" cy="18" r="1.4"/>',
        plus:     '<path d="M12 5v14M5 12h14"/>',
        minus:    '<path d="M5 12h14"/>',
        wrench:   '<path d="M14.5 6.2a4 4 0 005.3 5.3l-9.6 9.6a2.1 2.1 0 01-3-3z"/><path d="M14.5 6.2l3-3 3 3-3 3"/>',
        trash:    '<path d="M4.5 7h15M10 7V4.5h4V7M6.5 7l.8 12.5h9.4L17.5 7M10 11v5M14 11v5"/>',
        sparkle:  '<path d="M12 3l1.8 5.2L19 10l-5.2 1.8L12 17l-1.8-5.2L5 10l5.2-1.8z"/><path d="M19 17l.7 1.8 1.8.7-1.8.7L19 22l-.7-1.8-1.8-.7 1.8-.7z"/>',
        gun:      '<path d="M3 9h12.5l2.2 2H21v3h-4.5l-1 3.5h-3.2L13 14H8.2L7 17H4l1.2-5H3z"/>',
        box:      '<path d="M3.5 7.5L12 3l8.5 4.5v9L12 21l-8.5-4.5z"/><path d="M3.5 7.5L12 12l8.5-4.5M12 12v9"/>',
        pin:      '<path d="M12 21s-6.5-5.7-6.5-11a6.5 6.5 0 0113 0c0 5.3-6.5 11-6.5 11z"/><circle cx="12" cy="10" r="2.4"/>',
        ped:      '<circle cx="12" cy="5.5" r="2.5"/><path d="M12 8.5v6M12 10.5l-4.5 3M12 10.5l4.5 3M12 14.5l-3.2 6M12 14.5l3.2 6"/>',
        shirt:    '<path d="M8.5 4L3.5 7l2 4 2-1v10h9V10l2 1 2-4-5-3a3.6 3.6 0 01-7 0z"/>',
        globe:    '<circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3c2.6 2.6 3.8 5.6 3.8 9s-1.2 6.4-3.8 9c-2.6-2.6-3.8-5.6-3.8-9S9.4 5.6 12 3z"/>',
        door:     '<path d="M14 4.5H7a1.5 1.5 0 00-1.5 1.5v12A1.5 1.5 0 007 19.5h7M10.5 12H21M18 9l3 3-3 3"/>',
        clock:    '<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3.2 2"/>',
        flag:     '<path d="M6 21V4M6 5h11l-2 3.5L17 12H6"/>',
        refresh:  '<path d="M20 11a8 8 0 00-14.3-4.3M4 5v3.7h3.7M4 13a8 8 0 0014.3 4.3M20 19v-3.7h-3.7"/>',
        bolt:     '<path d="M13 3L5.5 13.5H11L10 21l7.5-10.5H12z"/>',
        compass:  '<circle cx="12" cy="12" r="9"/><path d="M15.8 8.2l-2.2 5.4-5.4 2.2 2.2-5.4z"/>',
        walk:     '<circle cx="13" cy="4.8" r="2"/><path d="M12 8.5l-2 4.5 3 2.5V21M12 8.5l3.5 3 2.5.5M10 13l-3 1.5"/>',
        info:     '<circle cx="12" cy="12" r="9"/><path d="M12 11v5.5M12 7.6v.1"/>',
        star:     '<path d="M12 3.5l2.6 5.4 5.9.8-4.3 4.1 1 5.9L12 16.9l-5.2 2.8 1-5.9-4.3-4.1 5.9-.8z"/>',
        eraser:   '<path d="M14 4.5l5.5 5.5L10 19.5H6l-2.5-2.5zM8 11l5.5 5.5M10 19.5h9"/>',
        gauge:    '<path d="M4.5 17a8 8 0 1115 0M12 13l3.5-3.5"/>',
        eye:      '<path d="M2.5 12S6 5.5 12 5.5 21.5 12 21.5 12 18 18.5 12 18.5 2.5 12 2.5 12z"/><circle cx="12" cy="12" r="2.8"/>',
        eyeoff:   '<path d="M3 3l18 18"/><path d="M10.6 6a8 8 0 011.4-.5C18 5.5 21.5 12 21.5 12a14 14 0 01-2.4 3.1M6.4 7.5A13 13 0 002.5 12S6 18.5 12 18.5a8.6 8.6 0 004-1"/>',
        run:      '<circle cx="14" cy="4.8" r="2"/><path d="M11 9l-2.5 3.5 3 2L9.5 20M11 9l4.5 1.5 2.5 3M8.5 12.5L5 12"/>',
        jump:     '<path d="M12 20V6M6.5 11.5L12 6l5.5 5.5"/><path d="M7 20h10"/>',
        sun:      '<circle cx="12" cy="12" r="3.8"/><path d="M12 3v2.2M12 18.8V21M3 12h2.2M18.8 12H21M5.6 5.6l1.6 1.6M16.8 16.8l1.6 1.6M18.4 5.6l-1.6 1.6M7.2 16.8l-1.6 1.6"/>',
        cloud:    '<path d="M7 18.5h10a3.8 3.8 0 00.6-7.5A5.5 5.5 0 007 9.4 4.6 4.6 0 007 18.5z"/>',
        rain:     '<path d="M7 14.5h10a3.4 3.4 0 00.5-6.8A5.2 5.2 0 007 6.6 4 4 0 007 14.5z"/><path d="M8.5 17.5l-1 2.5M12.5 17.5l-1 2.5M16.5 17.5l-1 2.5"/>',
        moon:     '<path d="M20 14.5A8 8 0 019.5 4a8 8 0 1010.5 10.5z"/>',
        palette:  '<path d="M12 3.5a8.5 8.5 0 000 17c1.5 0 2-1 1.5-2.2-.6-1.4.3-2.6 1.7-2.6H17a3.5 3.5 0 003.5-3.5C20.5 7 16.8 3.5 12 3.5z"/><circle cx="8" cy="11" r="1"/><circle cx="11" cy="7.5" r="1"/><circle cx="15.5" cy="8.5" r="1"/>',
        lock:     '<rect x="5.5" y="10.5" width="13" height="9.5" rx="2"/><path d="M8.5 10.5V8a3.5 3.5 0 017 0v2.5"/>',
        key:      '<circle cx="8" cy="15" r="3.5"/><path d="M10.5 12.5L19 4M16 7l2.5 2.5M14 9l2 2"/>',
        power:    '<path d="M12 3.5v8M7.3 6.4a7.5 7.5 0 109.4 0"/>',
        bulb:     '<path d="M9.5 17.5h5M10 20.5h4M12 3.5a5.5 5.5 0 00-3.3 9.9c.5.4.8 1 .8 1.6v.5h5v-.5c0-.6.3-1.2.8-1.6A5.5 5.5 0 0012 3.5z"/>',
        save:     '<path d="M5 4.5h11l3.5 3.5v11.5H5z"/><path d="M8 4.5v5h7v-5M8 19.5v-6h8v6"/>',
        crosshair:'<circle cx="12" cy="12" r="6.5"/><path d="M12 3v4M12 17v4M3 12h4M17 12h4"/>',
        infinity: '<path d="M7.5 8.5c-2.2 0-3.7 1.5-3.7 3.5s1.5 3.5 3.7 3.5c3.8 0 5-7 9-7 2.2 0 3.7 1.5 3.7 3.5s-1.5 3.5-3.7 3.5c-4 0-5.2-7-9-7z"/>',
        bookmark: '<path d="M7 4h10v16l-5-3.5L7 20z"/>',
        tire:     '<circle cx="12" cy="12" r="8.5"/><circle cx="12" cy="12" r="3.2"/><path d="M12 3.5v5.3M12 15.2v5.3M3.5 12h5.3M15.2 12h5.3"/>',
        dice:     '<rect x="4.5" y="4.5" width="15" height="15" rx="3"/><circle cx="9" cy="9" r="1"/><circle cx="15" cy="15" r="1"/><circle cx="12" cy="12" r="1"/>',
        history:  '<path d="M4 12a8 8 0 108-8 8 8 0 00-5.7 2.4L4 8.5"/><path d="M4 4v4.5h4.5M12 8v4.5l3 1.5"/>',
        paint:    '<path d="M5 5.5h11v5H5z"/><path d="M16 8h3v5.5h-8V16"/><path d="M9.5 16h3v4.5h-3z"/>',
        search:   '<circle cx="11" cy="11" r="6.5"/><path d="M16 16l4.5 4.5"/>',
        file:     '<path d="M6 3.5h8l4 4V20.5H6z"/><path d="M14 3.5v4h4M9 12h6M9 15.5h6"/>',
        cart:     '<path d="M3.5 4.5h2.4l2 10.5h9.6l2-7.5H7"/><circle cx="10" cy="19" r="1.4"/><circle cx="17" cy="19" r="1.4"/>',
        edit:     '<path d="M4.5 19.5l1-4.2L16.8 4a1.8 1.8 0 012.5 0l.7.7a1.8 1.8 0 010 2.5L8.7 18.5z"/><path d="M14.5 6.5l3 3"/>',
        check:    '<path d="M5 12.5l4.5 4.5L19 7.5"/>',
        close:    '<path d="M6 6l12 12M18 6L6 18"/>',
        send:     '<path d="M21 3L10.5 13.5M21 3l-6.5 18-4-7.5L3 9.5z"/>',
        crown:    '<path d="M4 8l4 4 4-6 4 6 4-4-1.5 10h-13z"/>'
    };

    function icon(name, cls) {
        var body = ICONS[name] || ICONS.star;
        return '<svg viewBox="0 0 24 24"' + (cls ? ' class="' + cls + '"' : '') + '>' + body + '</svg>';
    }

    // ------------------------------------------------------------------ helpers
    var resName = 'ScriptPack';
    try {
        if (typeof window.GetParentResourceName === 'function') resName = window.GetParentResourceName();
    } catch (e) { /* keep the default */ }

    function post(name, data) {
        return window.fetch('https://' + resName + '/' + name, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify(data || {})
        }).then(function (r) { return r.json(); }).catch(function () { return null; });
    }

    function $(id) { return document.getElementById(id); }
    function esc(s) {
        return String(s == null ? '' : s).replace(/[&<>"']/g, function (c) {
            return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
        });
    }

    var MAX_ROWS = 150;   // rows drawn at once (a ped list has 600+ entries - the search narrows it)

    var el = {
        app: $('app'), panel: $('panel'), title: $('title'), subtitle: $('subtitle'), headIcon: $('head-icon'),
        tabs: $('tabs'), searchWrap: $('search-wrap'), search: $('search'), list: $('list'),
        preview: $('preview'), previewImg: $('preview-img'), previewName: $('preview-name'),
        prompt: $('prompt'), promptTitle: $('prompt-title'), promptInput: $('prompt-input'), promptFields: $('prompt-fields'),
        back: $('btn-back'), footBack: $('foot-back'),
        stats: $('stats'), barHealth: $('bar-health'), barArmor: $('bar-armor'), statHealth: $('stat-health'), statArmor: $('stat-armor'),
        footPin: $('foot-pin'), footSearch: $('foot-search'),
        banner: $('banner'), bannerText: $('banner-text'), bannerFrom: $('banner-from'), count: $('count'),
        toast: $('toast'), badge: $('badge'), badgeText: $('badge-text'), badgeSub: $('badge-sub')
    };

    var state = {
        open: false,
        model: null,
        tab: 0,
        rows: [],       // rendered rows: [{item, el}]
        sel: -1,
        query: '',
        prompting: null,
        toastTimer: null,
        fetchToken: 0,
        searchMode: false,   // "search everything" (key /) instead of a tab
        searchTab: null,
        bannerTimer: null,
        countTimers: []
    };

    // ------------------------------------------------------------------ screens
    // A "screen" is a model without tabs: { screen: true, title, subtitle, items, back, ns, searchable }
    // (the world manager, the shop ...). Lua keeps the navigation stack, the UI only shows what it is sent.
    function normalize(model) {
        if (model && model.screen && !model.tabs) {
            model.tabs = [{ id: 'screen', label: '', icon: 'star', items: model.items || [], searchable: !!model.searchable, empty: model.empty }];
        }
        return model;
    }

    function applyHeader(model) {
        el.title.textContent = model.title || 'World menu';
        el.subtitle.textContent = model.subtitle || '';
        el.headIcon.innerHTML = icon(model.icon || 'globe');
        el.back.classList.toggle('hidden', !model.back);
        el.footBack.classList.toggle('hidden', !model.back);
        el.tabs.classList.toggle('hidden', !!model.screen);
        el.stats.classList.toggle('hidden', !model.stats);
        el.footSearch.classList.toggle('hidden', !!model.screen);
        if (model.stats) applyStats(model.stats);
    }

    function applyStats(st) {
        if (!st) return;
        var hp = Math.max(0, Math.min(100, Number(st.health) || 0));
        var ar = Math.max(0, Math.min(100, Number(st.armor) || 0));
        el.barHealth.style.width = hp + '%';
        el.barArmor.style.width = ar + '%';
        el.statHealth.textContent = String(hp);
        el.statArmor.textContent = String(ar);
    }

    // ------------------------------------------------------------------ rendering
    function currentTab() {
        if (state.searchMode && state.searchTab) return state.searchTab;
        return state.model && state.model.tabs[state.tab];
    }

    function renderTabs() {
        if (state.model.screen) { el.tabs.innerHTML = ''; return; }
        var html = '';
        state.model.tabs.forEach(function (t, i) {
            html += '<button class="tab' + (i === state.tab && !state.searchMode ? ' active' : '') + '" data-i="' + i + '">' +
                icon(t.icon) + '<span>' + esc(t.label) + '</span></button>';
        });
        if (state.searchMode) html += '<button class="tab active" data-i="-1">' + icon('search') + '<span>Search</span></button>';
        el.tabs.innerHTML = html;
        var active = el.tabs.querySelector('.tab.active');
        if (active && active.scrollIntoView) active.scrollIntoView({ block: 'nearest', inline: 'nearest' });
    }

    function matches(item, q) {
        if (!q) return true;
        q = q.toLowerCase();
        return String(item.label || '').toLowerCase().indexOf(q) !== -1 ||
            String(item.value == null ? '' : item.value).toLowerCase().indexOf(q) !== -1 ||
            String(item.desc || '').toLowerCase().indexOf(q) !== -1;
    }

    function buildRows() {
        var tab = currentTab();
        var items = (tab && tab.items) || [];
        var out = [];
        var shown = 0;
        var hidden = 0;
        var pendingSection = null;

        items.forEach(function (it) {
            if (it.section) { pendingSection = it; return; }
            if (!matches(it, state.query)) return;
            if (shown >= MAX_ROWS) { hidden++; return; }
            if (pendingSection) { out.push({ section: pendingSection.section }); pendingSection = null; }
            out.push({ item: it });
            shown++;
        });
        if (hidden > 0) out.push({ note: hidden + ' more - type to search' });
        return out;
    }

    function renderList(keepSel) {
        var prevKey = null;
        if (keepSel && state.sel >= 0 && state.rows[state.sel]) {
            var it = state.rows[state.sel].item;
            prevKey = it ? (it.id + '|' + it.value) : null;
        }

        var tab = currentTab();
        var rows = buildRows();
        var html = '';
        rows.forEach(function (r, i) {
            if (r.section) {
                html += '<li class="section">' + esc(r.section) + '</li>';
            } else if (r.note) {
                html += '<li class="empty">' + esc(r.note) + '</li>';
            } else {
                var it = r.item;
                var cls = 'item' + (it.disabled ? ' off' : '') + (it.danger ? ' danger' : '');
                var swatch = /^#[0-9a-fA-F]{6}$/.test(it.swatch || '') ? it.swatch : null;
                var right = '';
                if (it.toggle !== undefined) {
                    right = '<span class="switch' + (it.toggle ? ' on' : '') + '"><i></i></span>';
                } else if (it.tag) {
                    right = '<span class="item-tag' + (it.tagOk ? ' ok' : '') + '">' + esc(it.tag) + '</span>';
                }
                html += '<li class="' + cls + '" data-r="' + i + '">' +
                    (swatch
                        ? '<div class="item-ico swatch" style="background:' + swatch + '"></div>'
                        : '<div class="item-ico">' + icon(it.icon || 'star') + '</div>') +
                    '<div class="item-text"><div class="item-title">' + esc(it.label) + (it.pinned ? '<svg viewBox="0 0 24 24" class="item-pin">' + ICONS.star + '</svg>' : '') + '</div>' +
                    (it.desc ? '<div class="item-desc">' + esc(it.desc) + '</div>' : '') + '</div>' +
                    right + '</li>';
            }
        });

        if (!rows.some(function (r) { return r.item; }) && !rows.some(function (r) { return r.note; })) {
            html = '<li class="empty">' + esc((tab && tab.empty) || 'Nothing here') + '</li>';
        }

        el.list.innerHTML = html;
        state.rows = rows;

        // selection: keep the same item when possible, otherwise the first usable one
        var sel = -1;
        if (prevKey) {
            rows.forEach(function (r, i) { if (sel === -1 && r.item && (r.item.id + '|' + r.item.value) === prevKey) sel = i; });
        }
        if (sel === -1) sel = nextSelectable(-1, 1);
        setSel(sel);

        // search box only on tabs that ask for it
        var searchable = !!(tab && tab.searchable);
        el.searchWrap.classList.toggle('hidden', !searchable);
        // preview pane + wider panel for tabs whose items carry a picture
        var hasPreview = !!(tab && tab.preview);
        el.preview.classList.toggle('hidden', !hasPreview);
        el.panel.classList.toggle('wide', hasPreview);
    }

    function nextSelectable(from, dir) {
        var n = state.rows.length;
        if (!n) return -1;
        var i = from;
        for (var k = 0; k < n; k++) {
            i += dir;
            if (i < 0) i = n - 1;
            if (i >= n) i = 0;
            var r = state.rows[i];
            if (r && r.item && !r.item.disabled) return i;
        }
        return -1;
    }

    function setSel(i) {
        var prev = el.list.querySelector('.item.sel');
        if (prev) prev.classList.remove('sel');
        state.sel = i;
        var selItem = (i >= 0 && state.rows[i]) ? state.rows[i].item : null;
        $('foot-del').classList.toggle('hidden', !(selItem && selItem.alt));
        el.footPin.classList.toggle('hidden', !(selItem && selItem.pinnable));
        if (el.footPin.firstChild && selItem && selItem.pinnable) {
            el.footPin.lastChild.textContent = selItem.pinned ? ' unpin' : ' pin';
        }
        if (i < 0) { updatePreview(null); return; }
        var node = el.list.querySelector('.item[data-r="' + i + '"]');
        if (node) {
            node.classList.add('sel');
            if (node.scrollIntoView) node.scrollIntoView({ block: 'nearest' });
        }
        updatePreview(state.rows[i] && state.rows[i].item);
    }

    function updatePreview(item) {
        var tab = currentTab();
        if (!tab || !tab.preview || !item || !item.preview) {
            el.previewImg.style.backgroundImage = '';
            el.previewName.textContent = '';
            return;
        }
        el.previewImg.style.backgroundImage = 'url("' + String(item.preview).replace(/"/g, '%22') + '")';
        el.previewName.textContent = item.value || item.label;
    }

    function setTab(i, fetchFirst) {
        if (!state.model) return;
        var n = state.model.tabs.length;
        state.tab = ((i % n) + n) % n;
        state.searchMode = false;
        state.searchTab = null;
        state.query = '';
        el.search.value = '';
        cancelPrompt();
        renderTabs();
        renderList(false);

        var tab = currentTab();
        if (tab && tab.dynamic) loadDynamic(tab);
        if (tab && tab.searchable) setTimeout(function () { el.search.focus(); }, 0);
    }

    function loadDynamic(tab) {
        var token = ++state.fetchToken;
        tab.items = [];
        tab.empty = 'Loading...';
        renderList(false);
        post('cw_fetch', { what: tab.dynamic }).then(function (res) {
            if (token !== state.fetchToken || currentTab() !== tab) return;
            tab.items = (res && res.items) || [];
            tab.empty = (res && res.empty) || tab.emptyText || 'Nothing here';
            renderList(false);
        });
    }

    // ------------------------------------------------------------------ prompt (typed input)
    // item.prompt = { title, placeholder }            -> one input, the value is a string
    // item.prompt = { title, fields: [{placeholder}] } -> several inputs, the value is an array of strings
    function promptInputs() { return el.promptFields.querySelectorAll('input.pi'); }

    function openPrompt(item) {
        state.prompting = item;
        el.promptTitle.textContent = item.prompt.title || item.label;
        var fields = item.prompt.fields && item.prompt.fields.length ? item.prompt.fields : [{ placeholder: item.prompt.placeholder || '' }];
        // keep the first input (stable id), rebuild the rest
        var extra = el.promptFields.querySelectorAll('input.pi:not(#prompt-input)');
        for (var i = 0; i < extra.length; i++) extra[i].remove();
        el.promptInput.value = '';
        el.promptInput.placeholder = fields[0].placeholder || '';
        for (var k = 1; k < fields.length; k++) {
            var inp = document.createElement('input');
            inp.type = 'text';
            inp.className = 'pi';
            inp.autocomplete = 'off';
            inp.spellcheck = false;
            inp.placeholder = fields[k].placeholder || '';
            inp.addEventListener('keydown', onPromptKey);
            el.promptFields.appendChild(inp);
        }
        el.prompt.classList.remove('hidden');
        setTimeout(function () { el.promptInput.focus(); }, 0);
    }

    function cancelPrompt() {
        state.prompting = null;
        el.prompt.classList.add('hidden');
        el.promptInput.value = '';
        var extra = el.promptFields.querySelectorAll('input.pi:not(#prompt-input)');
        for (var i = 0; i < extra.length; i++) extra[i].remove();
        if (currentTab() && currentTab().searchable) el.search.focus();
        else if (document.activeElement && document.activeElement.blur) document.activeElement.blur();
    }

    function onPromptKey(e) {
        if (e.key !== 'Enter') return;
        e.preventDefault();
        var inputs = promptInputs();
        var index = Array.prototype.indexOf.call(inputs, e.target);
        if (index < inputs.length - 1) { inputs[index + 1].focus(); return; }   // next field
        var values = [];
        for (var i = 0; i < inputs.length; i++) {
            var v = inputs[i].value.trim();
            if (!v) { inputs[i].focus(); return; }   // every field is required
            values.push(v);
        }
        var item = state.prompting;
        el.prompt.classList.add('hidden');
        state.prompting = null;
        activate(item, inputs.length === 1 ? values[0] : values);
    }

    // ------------------------------------------------------------------ actions
    function everyTabItem(fn) {
        var tabs = (state.model && state.model.tabs) || [];
        tabs.forEach(function (t) { (t.items || []).forEach(fn); });
        if (state.searchTab) state.searchTab.items.forEach(fn);
    }

    function handleReply(res, item) {
        if (!res) return;
        if (res.stats) applyStats(res.stats);
        if (res.toast) showToast(res.toast, !!res.error);
        if (res.pin) {
            everyTabItem(function (it) {
                if (it.id === res.pin.id && String(it.value) === String(res.pin.value)) it.pinned = !!res.pin.pinned;
            });
            renderList(true);
        }
        if (res.tabItems) {
            (state.model.tabs || []).forEach(function (t) {
                if (Array.isArray(res.tabItems[t.id])) t.items = res.tabItems[t.id];
            });
            if (state.searchMode) state.searchTab = buildSearchTab();
            renderList(true);
        }
        if (res.close) { closeLocal(); return; }
        if (res.screen) { applyScreen(res.screen, true); return; }
        if (res.refresh && currentTab()) {
            if (currentTab().dynamic) loadDynamic(currentTab());
        }
        if (Array.isArray(res.items) && currentTab()) {
            currentTab().items = res.items;
            renderList(true);
        }
        if (res.toggle !== undefined && item) { item.toggle = !!res.toggle; renderList(true); }
        if (res.tag !== undefined && item) { item.tag = res.tag; item.tagOk = !!res.tagOk; renderList(true); }
    }

    function activate(item, typed) {
        if (!item || item.disabled) return;
        if (item.prompt && typed === undefined) { openPrompt(item); return; }
        var payload = {
            id: item.id,
            value: typed !== undefined ? typed : item.value,
            tab: currentTab() && currentTab().id,
            ns: state.model && state.model.ns
        };
        post('cw_action', payload).then(function (res) { handleReply(res, item); });
    }

    function goBack() {
        post('cw_back', { ns: state.model && state.model.ns }).then(function (res) { handleReply(res, null); });
    }

    // "/" searches the items of every tab at once (the lists that are fetched from Lua are not part of it)
    function buildSearchTab() {
        var items = [];
        state.model.tabs.forEach(function (t) {
            if (t.dynamic || !t.items) return;
            t.items.forEach(function (it) {
                if (it.section || it.disabled) return;
                var copy = {};
                Object.keys(it).forEach(function (k) { copy[k] = it[k]; });
                copy.desc = (it.desc ? it.desc + '  -  ' : '') + t.label;
                items.push(copy);
            });
        });
        return { id: '__all', label: 'Search', icon: 'search', items: items, searchable: true, preview: false, empty: 'Nothing found' };
    }

    function enterSearch() {
        if (!state.model || state.model.screen) return;
        cancelPrompt();
        state.searchMode = true;
        state.searchTab = buildSearchTab();
        state.query = '';
        el.search.value = '';
        renderTabs();
        renderList(false);
        setTimeout(function () { el.search.focus(); }, 0);
    }

    function exitSearch() {
        state.searchMode = false;
        state.searchTab = null;
        setTab(state.tab);
    }

    function applyScreen(model, keepSel) {
        state.model = normalize(model);
        state.tab = 0;
        if (!keepSel) { state.query = ''; el.search.value = ''; }
        cancelPrompt();
        applyHeader(model);
        applyAccent(model.accent);
        renderTabs();
        renderList(!!keepSel);
        var tab = currentTab();
        if (tab && tab.searchable && !keepSel) setTimeout(function () { el.search.focus(); }, 0);
    }

    function showToast(text, error) {
        el.toast.textContent = text;
        el.toast.classList.toggle('error', !!error);
        el.toast.classList.remove('hidden');
        clearTimeout(state.toastTimer);
        state.toastTimer = setTimeout(function () { el.toast.classList.add('hidden'); }, 2600);
    }

    // ------------------------------------------------------------------ host announcement + countdown
    function showBanner(text, from) {
        el.bannerText.textContent = String(text || '').slice(0, 120);
        el.bannerFrom.textContent = from ? String(from).slice(0, 40) : '';
        el.banner.classList.remove('hidden');
        clearTimeout(state.bannerTimer);
        state.bannerTimer = setTimeout(function () { el.banner.classList.add('hidden'); }, 7000);
    }

    function startCountdown(seconds) {
        seconds = Math.floor(Number(seconds));
        if (!(seconds >= 3 && seconds <= 10)) return;
        state.countTimers.forEach(clearTimeout);
        state.countTimers = [];
        var step = function (n) {
            el.count.classList.remove('hidden', 'go');
            el.count.textContent = String(n);
            // restart the CSS animation for every number
            el.count.style.animation = 'none';
            void el.count.offsetWidth;
            el.count.style.animation = '';
        };
        for (var i = 0; i < seconds; i++) {
            (function (n, delay) { state.countTimers.push(setTimeout(function () { step(n); }, delay)); })(seconds - i, i * 1000);
        }
        state.countTimers.push(setTimeout(function () {
            el.count.classList.remove('hidden');
            el.count.classList.add('go');
            el.count.textContent = 'GO!';
            el.count.style.animation = 'none'; void el.count.offsetWidth; el.count.style.animation = '';
        }, seconds * 1000));
        state.countTimers.push(setTimeout(function () { el.count.classList.add('hidden'); }, seconds * 1000 + 1200));
    }

    // ------------------------------------------------------------------ open / close
    function applyAccent(color) {
        if (!color) return;
        document.documentElement.style.setProperty('--accent', color);
        var m = /^#?([0-9a-f]{6})$/i.exec(color);
        if (m) {
            var n = parseInt(m[1], 16);
            document.documentElement.style.setProperty('--accent-soft', 'rgba(' + (n >> 16) + ',' + ((n >> 8) & 255) + ',' + (n & 255) + ',.16)');
        }
    }

    function openMenu(model) {
        state.model = normalize(model);
        state.open = true;
        applyAccent(model.accent);
        applyHeader(model);
        el.app.classList.remove('hidden');
        el.toast.classList.add('hidden');
        setTab(model.tab || 0);
    }

    function closeLocal() {
        state.open = false;
        state.fetchToken++;
        cancelPrompt();
        el.app.classList.add('hidden');
        // the shell page (html/index.html) stops sending mouse input to this frame
        try { window.parent.postMessage({ cwShell: 'closed' }, '*'); } catch (e) { /* ignore */ }
    }

    function requestClose() {
        closeLocal();
        post('cw_close', {});
    }

    // ------------------------------------------------------------------ events
    el.tabs.addEventListener('click', function (e) {
        var b = e.target.closest ? e.target.closest('.tab') : null;
        if (b && b.getAttribute('data-i') !== '-1') setTab(parseInt(b.getAttribute('data-i'), 10));
    });

    el.list.addEventListener('click', function (e) {
        var li = e.target.closest ? e.target.closest('.item') : null;
        if (!li) return;
        var i = parseInt(li.getAttribute('data-r'), 10);
        var r = state.rows[i];
        if (!r || !r.item || r.item.disabled) return;
        setSel(i);
        activate(r.item);
    });

    $('btn-close').addEventListener('click', requestClose);

    el.search.addEventListener('input', function () {
        state.query = el.search.value;
        renderList(false);
    });

    el.promptInput.addEventListener('keydown', onPromptKey);
    el.back.addEventListener('click', goBack);

    document.addEventListener('keydown', function (e) {
        if (!state.open) return;
        // the prompt input handles its own Enter; the same keydown must not also run the selected row
        if (e.target && e.target.classList && e.target.classList.contains('pi') && e.key !== 'Escape') return;

        if (e.key === 'Escape') {
            e.preventDefault();
            if (state.prompting) { cancelPrompt(); return; }
            if (el.search.value) { el.search.value = ''; state.query = ''; renderList(false); return; }
            if (state.searchMode) { exitSearch(); return; }
            requestClose();
            return;
        }
        if (state.prompting) return;   // typing in the prompt

        var typing = e.target && (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA');

        // "/" = search everything, F = pin / unpin the selected row to the Quick tab
        if (!typing && e.key === '/') { e.preventDefault(); enterSearch(); return; }
        if (!typing && (e.key === 'f' || e.key === 'F')) {
            var row = state.rows[state.sel];
            if (row && row.item && row.item.pinnable) {
                e.preventDefault();
                post('cw_pin', { id: row.item.id, value: row.item.value, label: row.item.label, icon: row.item.icon, ns: state.model.ns }).then(function (res) { handleReply(res, null); });
            }
            return;
        }

        // Backspace goes one screen back (manager / shop screens), unless a text box has the focus
        if (e.key === 'Backspace' && !(e.target && (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA'))) {
            if (state.model && state.model.back) { e.preventDefault(); goBack(); }
            return;
        }

        // 1-9 jump to a tab (not while typing in the search box)
        if (/^[1-9]$/.test(e.key) && !(e.target && (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA'))) {
            var wanted = parseInt(e.key, 10) - 1;
            if (state.model && !state.model.screen && wanted < state.model.tabs.length) { e.preventDefault(); setTab(wanted); }
            return;
        }

        switch (e.key) {
            case 'ArrowDown': e.preventDefault(); setSel(nextSelectable(state.sel, 1)); break;
            case 'ArrowUp':   e.preventDefault(); setSel(nextSelectable(state.sel, -1)); break;
            case 'ArrowRight': e.preventDefault(); if (!state.model.screen) setTab(state.tab + 1); break;
            case 'ArrowLeft':
                if (document.activeElement === el.search && el.search.selectionStart > 0) break;   // moving the caret
                e.preventDefault(); if (!state.model.screen) setTab(state.tab - 1); break;
            case 'Delete':
                if (state.sel >= 0 && state.rows[state.sel] && state.rows[state.sel].item && state.rows[state.sel].item.alt) {
                    e.preventDefault();
                    var base = state.rows[state.sel].item;
                    activate({ id: base.alt, value: base.value, label: base.label });
                }
                break;
            case 'Enter':
                e.preventDefault();
                if (state.sel >= 0 && state.rows[state.sel]) activate(state.rows[state.sel].item);
                break;
            case 'Tab':
                e.preventDefault(); if (!state.model.screen) setTab(state.tab + (e.shiftKey ? -1 : 1)); break;
        }
    });

    // ------------------------------------------------------------------ messages from Lua (relayed by html/index.html)
    window.addEventListener('message', function (event) {
        var d = event.data;
        if (!d || d.cw !== true) return;

        switch (d.action) {
            case 'open':  openMenu(d.model || { tabs: [] }); break;
            case 'close': closeLocal(); break;
            case 'screen': if (state.open) applyScreen(d.model || { screen: true, items: [] }, true); break;
            case 'toast': showToast(d.text, d.error); break;
            case 'announce': showBanner(d.text, d.from); break;
            case 'countdown': startCountdown(d.seconds); break;
            case 'badge':
                if (d.show) {
                    el.badgeText.textContent = d.text || '';
                    el.badgeSub.textContent = d.sub || '';
                    if (d.accent) applyAccent(d.accent);
                    el.badge.classList.remove('hidden');
                } else {
                    el.badge.classList.add('hidden');
                }
                break;
        }
    });

    // exposed for tests
    window.__cw = { state: state, ICONS: ICONS };
})();
