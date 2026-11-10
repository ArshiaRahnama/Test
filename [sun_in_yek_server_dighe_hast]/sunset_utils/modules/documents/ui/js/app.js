(function () {
    'use strict';

    var state = {
        resource: 'Documents',
        translate: {},
        logo: '',
        header: 'Department of Justice',
        subheader: 'Official Legal Document',
        watermark: 'DEPARTMENT OF JUSTICE',
        mode: 'idle',
        creating: false,
        doc: emptyDoc(),
        useBlocks: false,
        me: { name: '', identifier: '' },
        canPublish: false,
        isJustice: false,
        isPublicTemplate: false,
        sourcePublic: false,
    };

    var ICONS = {
        save:   '<svg viewBox="0 0 24 24"><path d="M5 12l4 4L19 6"/></svg>',
        exit:   '<svg viewBox="0 0 24 24"><path d="M6 6l12 12M18 6L6 18"/></svg>',
        addSig: '<svg viewBox="0 0 24 24"><path d="M16 4l4 4-9 9H7v-4l9-9z"/><path d="M14 6l4 4"/></svg>',
        image:  '<svg viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="9" cy="11" r="2"/><path d="M21 17l-5-5-8 8"/></svg>',
        back:   '<svg viewBox="0 0 24 24"><polyline points="15 18 9 12 15 6"/></svg>',
        seal:   '<svg viewBox="0 0 24 24"><circle cx="12" cy="9" r="6"/><path d="M9.5 13.5L8 22l4-2 4 2-1.5-8.5"/></svg>',
    };

    var MENU_ICONS = {
        create: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="12" y1="12" x2="12" y2="18"/><line x1="9" y1="15" x2="15" y2="15"/></svg>',
        folder: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 7a2 2 0 0 1 2-2h4l2 2h8a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V7z"/></svg>',
        'add-file': '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="12" y1="11" x2="12" y2="17"/><line x1="9" y1="14" x2="15" y2="14"/></svg>',
        archive: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="4" rx="1"/><path d="M5 8v11a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V8"/><line x1="10" y1="13" x2="14" y2="13"/></svg>',
        back: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"/></svg>',
        product: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="3" width="16" height="18" rx="2"/><line x1="8" y1="8" x2="16" y2="8"/><line x1="8" y1="12" x2="16" y2="12"/><line x1="8" y1="16" x2="13" y2="16"/></svg>',
        edit: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M16 4l4 4-12 12H4v-4z"/><path d="M14 6l4 4"/></svg>',
        delete: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6M14 11v6"/><path d="M9 6V4a2 2 0 0 1 2-2h2a2 2 0 0 1 2 2v2"/></svg>',
        close: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><line x1="8" y1="12" x2="16" y2="12"/></svg>',
        document: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="8" y1="13" x2="16" y2="13"/><line x1="8" y1="17" x2="14" y2="17"/></svg>',
        'document-closed': '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><circle cx="12" cy="15" r="2"/><path d="M10 13.5V12a2 2 0 0 1 4 0v1.5"/></svg>',
        copy: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="11" height="11" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>',
        give: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="6" cy="12" r="3"/><circle cx="18" cy="6" r="3"/><circle cx="18" cy="18" r="3"/><line x1="8.6" y1="10.6" x2="15.4" y2="7.4"/><line x1="8.6" y1="13.4" x2="15.4" y2="16.6"/></svg>',
        file: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>',
        human: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="4"/><path d="M4 21v-1a6 6 0 0 1 6-6h4a6 6 0 0 1 6 6v1"/></svg>',
        loading: '<div class="menu-item-spinner"></div>',
        arrow: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"/></svg>',
        'archive-vault': '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 5h18l-1 4H4z"/><path d="M5 9v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V9"/><circle cx="12" cy="14" r="2.5"/><line x1="12" y1="11" x2="12" y2="13"/></svg>',
        shield: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2l8 4v6c0 5-4 9-8 10-4-1-8-5-8-10V6z"/><path d="M9 12l2 2 4-4"/></svg>',
        'shield-x': '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2l8 4v6c0 5-4 9-8 10-4-1-8-5-8-10V6z"/><line x1="9" y1="9" x2="15" y2="15"/><line x1="15" y1="9" x2="9" y2="15"/></svg>',
        'user-add': '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="9" cy="8" r="4"/><path d="M2 21v-1a6 6 0 0 1 6-6h2"/><line x1="18" y1="9" x2="18" y2="17"/><line x1="14" y1="13" x2="22" y2="13"/></svg>',
        'page-prev': '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 6 15 12 9 18"/></svg>',
        'page-next': '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 6 9 12 15 18"/></svg>',
        public: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><path d="M3 12h18"/><path d="M12 3a14 14 0 0 1 0 18a14 14 0 0 1 0-18z"/></svg>',
        void: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="9"/><line x1="6" y1="6" x2="18" y2="18"/></svg>',
    };

    var BLOCK_ICONS = {
        header:    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M6 4v16M18 4v16M6 12h12"/></svg>',
        text:      '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><line x1="4" y1="6" x2="20" y2="6"/><line x1="4" y1="12" x2="20" y2="12"/><line x1="4" y1="18" x2="14" y2="18"/></svg>',
        input:     '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="9" width="18" height="6" rx="2"/><line x1="6" y1="12" x2="11" y2="12"/></svg>',
        textarea:  '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="2"/><line x1="6" y1="9" x2="18" y2="9"/><line x1="6" y1="13" x2="18" y2="13"/><line x1="6" y1="17" x2="12" y2="17"/></svg>',
        date:      '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="16" rx="2"/><line x1="3" y1="10" x2="21" y2="10"/><line x1="8" y1="3" x2="8" y2="7"/><line x1="16" y1="3" x2="16" y2="7"/></svg>',
        twocol:    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="6" width="8" height="12" rx="1.5"/><rect x="13" y="6" width="8" height="12" rx="1.5"/></svg>',
        image:     '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="9" cy="11" r="2"/><path d="M21 17l-5-5-8 8"/></svg>',
        checkbox:  '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="4" width="16" height="16" rx="3"/><polyline points="8 12 11 15 16 9"/></svg>',
        divider:   '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><line x1="4" y1="12" x2="20" y2="12"/></svg>',
        signature: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 18s3-2 7-2 6 4 11 0"/><path d="M3 21h18"/></svg>',
        seal:      '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="9" r="6"/><path d="M9.5 13.5L8 22l4-2 4 2-1.5-8.5"/><path d="M12 6.5l1 2 2 .2-1.5 1.4.4 2-1.9-1-1.9 1 .4-2L9 8.7l2-.2z"/></svg>',
        move:      '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="18 15 12 9 6 15"/></svg>',
        moveDown:  '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>',
        duplicate: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="11" height="11" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/></svg>',
        trash:     '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/></svg>',
        lock:      '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="5" y="11" width="14" height="9" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/></svg>',
        check:     '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="5 12 10 17 19 8"/></svg>',
        upload:    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>',
        pen:       '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 18s3-2 7-2 6 4 11 0"/><path d="M3 21h18"/></svg>',
    };

    var BLOCK_TYPES = {
        header:   { label: 'سرتیتر', desc: 'تیتر یک بخش جدید', icon: BLOCK_ICONS.header,   defaults: { label: 'سرتیتر بخش' } },
        text:     { label: 'متن', desc: 'پاراگراف متن آزاد', icon: BLOCK_ICONS.text,     defaults: { value: '' } },
        input:    { label: 'فیلد متنی', desc: 'یک خط ورودی', icon: BLOCK_ICONS.input,    defaults: { label: 'برچسب فیلد', value: '' } },
        textarea: { label: 'متن چندخطی', desc: 'چند خط ورودی', icon: BLOCK_ICONS.textarea, defaults: { label: 'برچسب فیلد', value: '' } },
        date:     { label: 'تاریخ', desc: 'فیلد تاریخ', icon: BLOCK_ICONS.date,     defaults: { label: 'تاریخ', value: '' } },
        twocol:   { label: 'دو ستونه', desc: 'دو فیلد کنار هم', icon: BLOCK_ICONS.twocol,   defaults: { leftLabel: 'فیلد اول', leftValue: '', rightLabel: 'فیلد دوم', rightValue: '' } },
        image:    { label: 'تصویر', desc: 'افزودن عکس داخل سند', icon: BLOCK_ICONS.image,    defaults: { value: '' } },
        checkbox: { label: 'چک‌باکس', desc: 'تأیید یا انتخاب', icon: BLOCK_ICONS.checkbox, defaults: { label: 'تأیید می‌کنم', value: false } },
        divider:  { label: 'خط جداکننده', desc: 'یک خط افقی', icon: BLOCK_ICONS.divider,  defaults: { style: 'solid' } },
        signature:{ label: 'امضای داخلی', desc: 'محل امضای رسمی', icon: BLOCK_ICONS.signature, defaults: { label: 'امضا', value: '', info: '', identifier: '' } },
        seal:     { label: 'مهر رسمی', desc: 'مهر رسمی دادگستری', icon: BLOCK_ICONS.seal, defaults: {} },
    };

    function emptyDoc() {
        return {
            id: null, name: '', name_creator: '', date: '', title: '', text: '',
            blocks: [], images: [], signatures: [], job: '', isopen: 1,
            templateType: 'formal', voided: false, justiceSeal: null,
        };
    }

    function $(id) { return document.getElementById(id); }
    function tr(key, fallback) { return state.translate[key] || fallback || ''; }

    function setRoot(active) {
        var root = document.querySelector('.app-root');
        if (active) root.classList.add('is-active');
        else root.classList.remove('is-active');
    }
    function setMenu(active) {
        var root = $('menuRoot');
        if (active) root.classList.add('is-active');
        else root.classList.remove('is-active');
    }

    function toast(message, kind) {
        var t = $('toast');
        t.textContent = message;
        t.className = 'doj-toast is-visible' + (kind ? ' is-' + kind : '');
        setTimeout(function () { t.className = 'doj-toast'; }, 2400);
    }

    function fetchPost(endpoint, payload) {
        try {
            window.parent.postMessage({ type: 'nuiCallback', action: endpoint, data: payload || {} }, '*');
        } catch (e) {}
    }

    function escape(text) {
        var d = document.createElement('div');
        d.textContent = text == null ? '' : String(text);
        return d.innerHTML;
    }

    function sanitizeImageUrl(url) {
        if (url == null) return '';
        var s = ('' + url).trim();
        if (/^https?:\/\/[^\s]+$/i.test(s)) return s;
        return '';
    }

    function hexToRgb(hex) {
        hex = ('' + (hex || '')).replace('#', '');
        if (hex.length === 3) hex = hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2];
        var n = parseInt(hex, 16);
        if (isNaN(n)) return { r: 212, g: 175, b: 55 };
        return { r: (n >> 16) & 255, g: (n >> 8) & 255, b: n & 255 };
    }
    function toHex(v) { return ('0' + Math.max(0, Math.min(255, Math.round(v))).toString(16)).slice(-2); }
    function lighten(hex, amt) { var c = hexToRgb(hex); return '#' + toHex(c.r + (255 - c.r) * amt) + toHex(c.g + (255 - c.g) * amt) + toHex(c.b + (255 - c.b) * amt); }
    function darken(hex, amt) { var c = hexToRgb(hex); return '#' + toHex(c.r * (1 - amt)) + toHex(c.g * (1 - amt)) + toHex(c.b * (1 - amt)); }

    function applyAccent(hex) {
        if (!hex) return;
        var c = hexToRgb(hex);
        var root = document.documentElement;
        root.style.setProperty('--doj-accent', hex);
        root.style.setProperty('--doj-accent-rgb', c.r + ', ' + c.g + ', ' + c.b);
        root.style.setProperty('--doj-accent-strong', lighten(hex, 0.25));
        root.style.setProperty('--doj-accent-deep', darken(hex, 0.45));
    }
    function applyAccent2(hex) {
        if (!hex) return;
        var c = hexToRgb(hex);
        var root = document.documentElement;
        root.style.setProperty('--doj-accent2', hex);
        root.style.setProperty('--doj-accent2-rgb', c.r + ', ' + c.g + ', ' + c.b);
    }
    function applyDocColors(docCfg, fallback) {
        if (!docCfg && !fallback) return;
        var primary = (docCfg && docCfg.colorPrimary) || (docCfg && docCfg.color) || fallback;
        var secondary = (docCfg && docCfg.color) || fallback || primary;
        if (primary) applyAccent(primary);
        if (secondary) applyAccent2(secondary);
    }
    function loadCachedColors() {
        try {
            var s = localStorage.getItem('sunMenuSettings');
            if (s) {
                var p = JSON.parse(s);
                applyDocColors(p.documents, p.default);
            }
        } catch (e) {}
    }
    function onMenuSettings(settings) {
        if (!settings) return;
        try {
            var cur = {};
            var s = localStorage.getItem('sunMenuSettings');
            if (s) cur = JSON.parse(s);
            for (var k in settings) cur[k] = settings[k];
            localStorage.setItem('sunMenuSettings', JSON.stringify(cur));
        } catch (e) {}
        applyDocColors(settings.documents, settings.default);
    }

    function closeUI() {
        fetchPost('close', {});
        setRoot(false);
        state.mode = 'idle';
        state.doc = emptyDoc();
        state.useBlocks = false;
        state.sourcePublic = false;
        state.isPublicTemplate = false;
    }

    function isViewMode() { return state.mode === 'view'; }
    function isCreatingModel() { return state.mode === 'createModel'; }
    function isEditingModel() { return state.mode === 'editModel'; }
    function isCreatingDocument() { return state.mode === 'createDocument'; }
    function isEditingDocument() { return state.mode === 'editDocument'; }
    function isModel() { return isCreatingModel() || isEditingModel(); }
    function isDocument() { return isCreatingDocument() || isEditingDocument(); }
    function isTemplateEdit() { return isModel(); }
    function isFilling() { return isDocument(); }

    function canSealCurrentDoc() {
        return state.isJustice && (state.mode === 'editDocument' || state.mode === 'view') && state.doc.id;
    }

    function renderActions() {
        var nav = $('actions');
        nav.innerHTML = '';

        if (isViewMode()) {
            if (canSealCurrentDoc()) nav.appendChild(actionBtn('seal', ICONS.seal, tr('TR_JUSTICE_SEAL', 'مهر تأیید'), onApplyJusticeSeal));
            nav.appendChild(actionBtn('default', ICONS.back, tr('TR_EDITOR_BACK', 'بازگشت'), onEditorBack));
            nav.appendChild(actionBtn('exit', ICONS.exit, tr('TR_EXIT', 'خروج'), closeUI));
            return;
        }

        nav.appendChild(actionBtn('save', ICONS.save, tr('TR_SAVE', 'ذخیره'), onSave));
        nav.appendChild(actionBtn('default', ICONS.addSig, tr('TR_ADD', 'افزودن امضا'), onAddSignature));
        if (canSealCurrentDoc()) nav.appendChild(actionBtn('seal', ICONS.seal, tr('TR_JUSTICE_SEAL', 'مهر تأیید'), onApplyJusticeSeal));
        nav.appendChild(actionBtn('default', ICONS.back, tr('TR_EDITOR_BACK', 'بازگشت'), onEditorBack));
        nav.appendChild(actionBtn('exit', ICONS.exit, tr('TR_CANCEL', 'لغو'), onRequestExit));
    }

    function onApplyJusticeSeal() {
        if (!state.doc.id) { toast(tr('TR_JUSTICE_SEAL_NEED_SAVE', 'ابتدا سند را ذخیره کنید'), 'error'); return; }
        if (state.doc.justiceSeal && state.doc.justiceSeal.approver) { toast(tr('TR_JUSTICE_SEAL_DONE', 'قبلاً مهر خورده'), 'error'); return; }
        var date = formatDate(new Date());
        state.doc.justiceSeal = { approver: state.me.name, date: date };
        fetchPost('applyJusticeSeal', { id: state.doc.id, date: date });
        renderJusticeSeal();
        toast(tr('TR_JUSTICE_SEAL_APPLIED', 'مهر تأیید ثبت شد'), 'success');
    }

    function renderJusticeSeal() {
        var seal = $('justiceSeal');
        if (state.doc.justiceSeal && state.doc.justiceSeal.approver) {
            $('justiceSealApprover').textContent = state.doc.justiceSeal.approver || '';
            $('justiceSealDate').textContent = state.doc.justiceSeal.date || '';
            seal.classList.add('is-active');
        } else {
            seal.classList.remove('is-active');
        }
    }

    function actionBtn(variant, iconSvg, label, handler) {
        var btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'doj-action-btn';
        btn.setAttribute('data-variant', variant);
        btn.innerHTML = iconSvg + '<span class="doj-action-tooltip">' + escape(label) + '</span>';
        btn.addEventListener('click', handler);
        return btn;
    }

    function onEditorBack() {
        setRoot(false);
        fetchPost('editorBack', {});
    }

    function renderPaper() {
        $('paperEyebrow').textContent = state.subheader || 'Official Legal Document';
        $('paperOrg').textContent = state.header || 'Department of Justice';
        $('paperWatermark').textContent = (state.watermark || 'DOJ').slice(0, 3).toUpperCase();
        var paperEagle = $('paperEagle');
        if (paperEagle && state.logo) paperEagle.src = state.logo;

        var paper = $('paper');
        paper.setAttribute('data-template-type', state.doc.templateType || 'formal');

        var d = $('docDate'), t = $('docTitle'), b = $('docBody'), bt = $('blankTitle');
        d.value = state.doc.date || '';
        t.value = state.doc.title || '';
        b.value = state.doc.text || '';
        bt.value = state.doc.title || '';

        var disabled = isViewMode();
        d.disabled = disabled; t.disabled = disabled; b.disabled = disabled; bt.disabled = disabled;

        var pubBar = $('publishBar');
        if (isTemplateEdit() && state.canPublish) {
            pubBar.classList.add('is-active');
            $('publishToggle').classList.toggle('is-on', !!state.isPublicTemplate);
        } else {
            pubBar.classList.remove('is-active');
        }

        var stamp = $('voidStamp');
        if (state.doc.voided) {
            stamp.textContent = tr('TR_VOID_STAMP', 'باطل شد');
            stamp.classList.add('is-active');
        } else {
            stamp.classList.remove('is-active');
        }

        renderJusticeSeal();

        var blocksEl = $('userBlocks'), legacyEl = $('legacyBody'), addEl = $('addBlockWrapper');
        if (state.useBlocks) {
            blocksEl.classList.add('is-active');
            legacyEl.classList.add('is-hidden');
            renderBlocks();
        } else {
            blocksEl.classList.remove('is-active');
            legacyEl.classList.remove('is-hidden');
            blocksEl.innerHTML = '';
        }

        if (isTemplateEdit()) addEl.classList.add('is-active');
        else addEl.classList.remove('is-active');

        renderAttachments();
        renderSignatures();
    }

    function renderAttachments() {
        var box = $('attachments');
        box.innerHTML = '';
        var imgs = state.doc.images || [];
        for (var i = 0; i < imgs.length; i++) {
            var card = document.createElement('div');
            card.className = 'doj-attach-card';
            var img = document.createElement('img');
            img.src = sanitizeImageUrl(imgs[i]); img.alt = '';
            img.onerror = function () { this.style.opacity = '0.3'; };
            card.appendChild(img);
            if (!isViewMode()) {
                var rm = document.createElement('button');
                rm.type = 'button'; rm.className = 'doj-attach-remove'; rm.innerHTML = '&times;';
                rm.setAttribute('data-index', String(i));
                rm.addEventListener('click', onRemoveAttachment);
                card.appendChild(rm);
            }
            box.appendChild(card);
        }
    }

    function mySignatureCount() {
        var n = 0, i;
        var sigs = state.doc.signatures || [];
        for (i = 0; i < sigs.length; i++) {
            if (sigs[i].identifier && sigs[i].identifier === state.me.identifier) n++;
        }
        var blocks = state.doc.blocks || [];
        for (i = 0; i < blocks.length; i++) {
            if (blocks[i].type === 'signature' && blocks[i].identifier && blocks[i].identifier === state.me.identifier) n++;
        }
        return n;
    }

    function renderSignatures() {
        var grid = $('signatures');
        grid.innerHTML = '';
        var sigs = state.doc.signatures || [];
        for (var i = 0; i < sigs.length; i++) {
            grid.appendChild(buildSignatureCard(sigs[i], i));
        }
    }

    function buildSignatureCard(sig, index) {
        var card = document.createElement('div');
        card.className = 'doj-sig-card';

        var script = document.createElement('div');
        script.className = 'doj-sig-script';
        script.textContent = sig.asign || '';
        card.appendChild(script);

        var info = document.createElement('div');
        info.className = 'doj-sig-info';
        info.textContent = sig.info || '';
        card.appendChild(info);

        if (!isViewMode() && sig.identifier && sig.identifier === state.me.identifier) {
            var rm = document.createElement('button');
            rm.type = 'button';
            rm.className = 'doj-sig-remove';
            rm.textContent = tr('TR_SIG_REMOVE_OWN', 'حذف امضای من');
            rm.addEventListener('click', function () {
                state.doc.signatures.splice(index, 1);
                renderSignatures();
            });
            card.appendChild(rm);
        }

        return card;
    }

    function onAddSignature() {
        if (isViewMode()) return;
        if (mySignatureCount() >= 1) {
            toast(tr('TR_SIG_ALREADY', 'شما قبلاً امضا کرده‌اید'), 'error');
            return;
        }
        var me = state.me || {};
        if (!me.name) { toast('اطلاعات پیدا نشد', 'error'); return; }
        state.doc.signatures = state.doc.signatures || [];
        state.doc.signatures.push({ asign: me.name, info: buildSignerInfo(me), identifier: me.identifier });
        renderSignatures();
    }

    function buildSignerInfo(data) {
        if (!data.job) return '';
        var label = data.job.label || '';
        var grade = data.job.grade_label || '';
        var now = new Date();
        var stamp = formatDate(now) + ' | ' + pad(now.getHours()) + ':' + pad(now.getMinutes());
        return label + (grade ? ' | ' + grade : '') + ' | ' + stamp;
    }

    function genBlockId() { return 'b_' + Math.random().toString(36).substr(2, 9); }
    function findBlockIndex(id) {
        var blocks = state.doc.blocks || [];
        for (var i = 0; i < blocks.length; i++) if (blocks[i].id === id) return i;
        return -1;
    }
    function createBlock(type) {
        var spec = BLOCK_TYPES[type];
        if (!spec) return null;
        var block = { id: genBlockId(), type: type, locked: false };
        var defaults = spec.defaults || {};
        for (var key in defaults) if (defaults.hasOwnProperty(key)) block[key] = defaults[key];
        return block;
    }
    function addBlock(type) {
        if (!isTemplateEdit()) return;
        var block = createBlock(type);
        if (!block) return;
        state.doc.blocks = state.doc.blocks || [];
        state.doc.blocks.push(block);
        renderBlocks();
    }
    function deleteBlock(id) { var i = findBlockIndex(id); if (i === -1) return; state.doc.blocks.splice(i, 1); renderBlocks(); }
    function moveBlock(id, dir) {
        var i = findBlockIndex(id); if (i === -1) return;
        var j = i + dir; if (j < 0 || j >= state.doc.blocks.length) return;
        var tmp = state.doc.blocks[i]; state.doc.blocks[i] = state.doc.blocks[j]; state.doc.blocks[j] = tmp;
        renderBlocks();
    }
    function duplicateBlock(id) {
        var i = findBlockIndex(id); if (i === -1) return;
        var copy = JSON.parse(JSON.stringify(state.doc.blocks[i]));
        copy.id = genBlockId();
        state.doc.blocks.splice(i + 1, 0, copy);
        renderBlocks();
    }
    function toggleLock(id) { var i = findBlockIndex(id); if (i === -1) return; state.doc.blocks[i].locked = !state.doc.blocks[i].locked; renderBlocks(); }

    function renderBlocks() {
        var container = $('userBlocks');
        container.innerHTML = '';
        var blocks = state.doc.blocks || [];
        for (var i = 0; i < blocks.length; i++) container.appendChild(buildBlock(blocks[i]));
    }

    function valueEditable(block) {
        if (isViewMode()) return false;
        if (isTemplateEdit()) return !!block.locked;
        if (isFilling()) return !block.locked;
        return false;
    }

    function buildBlock(block) {
        var wrap = document.createElement('div');
        wrap.className = 'paper-block';
        wrap.setAttribute('data-block-id', block.id);
        wrap.setAttribute('data-type', block.type);

        if (isTemplateEdit()) wrap.classList.add('is-template-edit');
        else if (isFilling()) wrap.classList.add('is-filling');
        else wrap.classList.add('is-view');
        if (block.locked) wrap.classList.add('is-locked');

        if (isTemplateEdit()) {
            var typeLabel = document.createElement('span');
            typeLabel.className = 'paper-block-type';
            var name = (BLOCK_TYPES[block.type] && BLOCK_TYPES[block.type].label) || block.type;
            if (block.locked) name = tr('TR_BLOCK_LOCKED_BADGE', 'نقل قول') + ' • ' + name;
            typeLabel.textContent = name;
            wrap.appendChild(typeLabel);
            wrap.appendChild(buildBlockControls(block.id, block.locked));
        }

        var content = document.createElement('div');
        content.className = 'paper-block-content';
        switch (block.type) {
            case 'header':    renderHeaderBlock(content, block); break;
            case 'text':      renderTextBlock(content, block); break;
            case 'input':     renderInputBlock(content, block); break;
            case 'textarea':  renderTextareaBlock(content, block); break;
            case 'date':      renderDateBlock(content, block); break;
            case 'twocol':    renderTwocolBlock(content, block); break;
            case 'image':     renderImageBlock(content, block); break;
            case 'checkbox':  renderCheckboxBlock(content, block); break;
            case 'divider':   renderDividerBlock(content, block); break;
            case 'signature': renderSignatureBlock(content, block); break;
            case 'seal':      renderSealBlock(content, block); break;
        }
        wrap.appendChild(content);
        return wrap;
    }

    function officialSealSvg() {
        var src = state.logo || 'img/doj-seal.png';
        return '<img class="doj-seal-svg" src="' + escape(src) + '" alt="Seal" />';
    }

    function renderSealBlock(container, block) {
        var wrap = document.createElement('div');
        wrap.className = 'paper-block-seal';
        wrap.innerHTML = officialSealSvg() +
            '<div class="paper-block-seal-caption">' + escape(tr('TR_SEAL_CAPTION', 'مهر رسمی دادگستری')) + '</div>';
        container.appendChild(wrap);
    }

    function buildBlockControls(id, locked) {
        var controls = document.createElement('div');
        controls.className = 'paper-block-controls';
        var actions = [
            { action: 'up',        icon: BLOCK_ICONS.move,      title: 'بالا' },
            { action: 'down',      icon: BLOCK_ICONS.moveDown,  title: 'پایین' },
            { action: 'lock',      icon: BLOCK_ICONS.lock,      title: tr('TR_BLOCK_LOCK', 'نقل قول'), active: locked },
            { action: 'duplicate', icon: BLOCK_ICONS.duplicate, title: 'کپی' },
            { action: 'delete',    icon: BLOCK_ICONS.trash,     title: 'حذف' },
        ];
        for (var i = 0; i < actions.length; i++) {
            var act = actions[i];
            var btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'paper-block-control-btn' + (act.active ? ' is-active' : '');
            btn.setAttribute('data-action', act.action);
            btn.setAttribute('title', act.title);
            btn.innerHTML = act.icon;
            btn.addEventListener('click', handleBlockControl);
            controls.appendChild(btn);
        }
        return controls;
    }

    function handleBlockControl(e) {
        e.preventDefault(); e.stopPropagation();
        var btn = e.currentTarget;
        var action = btn.getAttribute('data-action');
        var wrap = btn.closest('.paper-block');
        if (!wrap) return;
        var id = wrap.getAttribute('data-block-id');
        if (action === 'up') moveBlock(id, -1);
        else if (action === 'down') moveBlock(id, 1);
        else if (action === 'lock') toggleLock(id);
        else if (action === 'duplicate') duplicateBlock(id);
        else if (action === 'delete') deleteBlock(id);
    }

    function bindInputUpdate(el, block, key) {
        el.addEventListener('input', function (e) { block[key] = e.target.value; });
    }
    function autoGrow(el) {
        function grow() { el.style.height = 'auto'; el.style.height = (el.scrollHeight + 4) + 'px'; }
        el.addEventListener('input', grow);
        setTimeout(grow, 0);
    }

    function renderHeaderBlock(container, block) {
        if (isTemplateEdit()) {
            var input = document.createElement('input');
            input.type = 'text'; input.className = 'paper-block-header-input';
            input.value = block.label || ''; input.placeholder = 'سرتیتر بخش'; input.dir = 'rtl';
            bindInputUpdate(input, block, 'label');
            container.appendChild(input);
        } else {
            var h = document.createElement('div');
            h.className = 'paper-block-header-text';
            h.textContent = block.label || '';
            container.appendChild(h);
        }
    }

    function renderTextBlock(container, block) {
        if (isViewMode() || (isFilling() && block.locked)) {
            var v = document.createElement('div');
            v.className = 'paper-block-text-view';
            v.textContent = block.value || '';
            container.appendChild(v);
            return;
        }
        var ta = document.createElement('textarea');
        ta.className = 'paper-block-text-area';
        ta.value = block.value || '';
        ta.placeholder = 'متن آزاد را اینجا وارد کنید...';
        ta.dir = 'rtl';
        bindInputUpdate(ta, block, 'value');
        autoGrow(ta);
        container.appendChild(ta);
    }

    function addLabel(container, block, labelKey) {
        if (isTemplateEdit()) {
            var input = document.createElement('input');
            input.type = 'text'; input.className = 'paper-block-label-input';
            input.value = block[labelKey] || ''; input.placeholder = 'برچسب فیلد'; input.dir = 'rtl';
            bindInputUpdate(input, block, labelKey);
            container.appendChild(input);
        } else {
            var lbl = document.createElement('div');
            lbl.className = 'paper-block-label';
            lbl.textContent = block[labelKey] || '';
            container.appendChild(lbl);
        }
    }

    function staticValueView(container, value) {
        var v = document.createElement('div');
        v.className = 'paper-block-static-value';
        v.textContent = value || '';
        container.appendChild(v);
    }

    function renderInputBlock(container, block) {
        addLabel(container, block, 'label');
        if (isViewMode() || (isFilling() && block.locked)) {
            staticValueView(container, block.value);
            return;
        }
        var input = document.createElement('input');
        input.type = 'text';
        input.className = 'paper-block-value-input';
        input.dir = 'rtl';
        if (isFilling()) {
            input.value = block.value || '';
            input.placeholder = block.placeholder || 'متن را وارد کنید';
            bindInputUpdate(input, block, 'value');
        } else if (isTemplateEdit() && block.locked) {
            input.value = block.value || '';
            input.placeholder = 'متن ثابت (نقل قول)...';
            bindInputUpdate(input, block, 'value');
        } else {
            input.className += ' is-preview';
            input.value = block.placeholder || '';
            input.placeholder = 'متن پیش‌نمایش (راهنما برای پُرکننده)...';
            bindInputUpdate(input, block, 'placeholder');
        }
        container.appendChild(input);
    }

    function renderTextareaBlock(container, block) {
        addLabel(container, block, 'label');
        if (isViewMode() || (isFilling() && block.locked)) {
            staticValueView(container, block.value);
            return;
        }
        var ta = document.createElement('textarea');
        ta.className = 'paper-block-value-textarea';
        ta.dir = 'rtl';
        if (isFilling()) {
            ta.value = block.value || '';
            ta.placeholder = block.placeholder || 'توضیحات';
            bindInputUpdate(ta, block, 'value');
        } else if (isTemplateEdit() && block.locked) {
            ta.value = block.value || '';
            ta.placeholder = 'متن ثابت (نقل قول)...';
            bindInputUpdate(ta, block, 'value');
        } else {
            ta.className += ' is-preview';
            ta.value = block.placeholder || '';
            ta.placeholder = 'متن پیش‌نمایش (راهنما برای پُرکننده)...';
            bindInputUpdate(ta, block, 'placeholder');
        }
        container.appendChild(ta);
        autoGrow(ta);
    }

    function renderDateBlock(container, block) {
        addLabel(container, block, 'label');
        if (isViewMode() || (isFilling() && block.locked)) {
            staticValueView(container, block.value || '--/--/----');
            return;
        }
        var input = document.createElement('input');
        input.type = 'text';
        input.className = 'paper-block-value-input';
        input.style.cursor = 'pointer';
        input.dir = 'rtl';
        if (isFilling()) {
            input.value = block.value || '';
            input.placeholder = block.placeholder || '--/--/----';
            attachDatePicker(input, function (v) { block.value = v; });
        } else if (isTemplateEdit() && block.locked) {
            input.value = block.value || '';
            input.placeholder = '--/--/----';
            attachDatePicker(input, function (v) { block.value = v; });
        } else {
            input.className += ' is-preview';
            input.value = block.placeholder || '';
            input.placeholder = 'تاریخ پیش‌نمایش...';
            attachDatePicker(input, function (v) { block.placeholder = v; });
        }
        container.appendChild(input);
    }

    function renderTwocolBlock(container, block) {
        var row = document.createElement('div');
        row.className = 'paper-block-twocol';
        var left = document.createElement('div'); left.className = 'paper-block-twocol-side';
        renderTwocolSide(left, block, 'leftLabel', 'leftValue', 'leftPlaceholder');
        var right = document.createElement('div'); right.className = 'paper-block-twocol-side';
        renderTwocolSide(right, block, 'rightLabel', 'rightValue', 'rightPlaceholder');
        row.appendChild(right); row.appendChild(left);
        container.appendChild(row);
    }

    function renderTwocolSide(container, block, labelKey, valueKey, phKey) {
        addLabel(container, block, labelKey);
        if (isViewMode() || (isFilling() && block.locked)) {
            staticValueView(container, block[valueKey]);
            return;
        }
        var val = document.createElement('input');
        val.type = 'text';
        val.className = 'paper-block-value-input';
        val.dir = 'rtl';
        if (isFilling()) {
            val.value = block[valueKey] || '';
            val.placeholder = block[phKey] || '';
            bindInputUpdate(val, block, valueKey);
        } else if (isTemplateEdit() && block.locked) {
            val.value = block[valueKey] || '';
            val.placeholder = 'متن ثابت...';
            bindInputUpdate(val, block, valueKey);
        } else {
            val.className += ' is-preview';
            val.value = block[phKey] || '';
            val.placeholder = 'پیش‌نمایش...';
            bindInputUpdate(val, block, phKey);
        }
        container.appendChild(val);
    }

    function renderImageBlock(container, block) {
        var frame = document.createElement('div');
        frame.className = 'paper-block-image-frame';
        var safeSrc = sanitizeImageUrl(block.value);
        if (safeSrc) {
            var img = document.createElement('img');
            img.src = safeSrc; img.alt = '';
            img.onerror = function () { this.style.opacity = '0.3'; };
            frame.appendChild(img);
        } else if (!isViewMode()) {
            var ph = document.createElement('div');
            ph.className = 'paper-block-image-placeholder';
            ph.innerHTML = BLOCK_ICONS.upload + '<div class="paper-block-image-placeholder-text">آدرس عکس را در پایین قرار دهید</div>';
            frame.appendChild(ph);
        }
        container.appendChild(frame);

        var canEditImg = !isViewMode() && (isTemplateEdit() ? true : !block.locked);
        if (canEditImg) {
            var url = document.createElement('input');
            url.type = 'text'; url.className = 'paper-block-image-url';
            url.value = block.value || ''; url.placeholder = 'https://...';
            url.addEventListener('input', function (e) { block.value = e.target.value; });
            url.addEventListener('change', function () { renderBlocks(); });
            container.appendChild(url);
        }
    }

    function renderCheckboxBlock(container, block) {
        var row = document.createElement('div');
        row.className = 'paper-block-checkbox-row';
        var box = document.createElement('div');
        box.className = 'paper-block-checkbox-box' + (block.value ? ' is-checked' : '');
        box.innerHTML = BLOCK_ICONS.check;

        var canToggle = (isTemplateEdit() && block.locked) || (isFilling() && !block.locked);
        if (canToggle) {
            box.addEventListener('click', function () {
                block.value = !block.value;
                box.classList.toggle('is-checked');
            });
        }
        row.appendChild(box);

        if (isTemplateEdit()) {
            var lbl = document.createElement('input');
            lbl.type = 'text'; lbl.className = 'paper-block-checkbox-label-input';
            lbl.value = block.label || ''; lbl.placeholder = 'متن چک‌باکس'; lbl.dir = 'rtl';
            bindInputUpdate(lbl, block, 'label');
            row.appendChild(lbl);
        } else {
            var lblDiv = document.createElement('div');
            lblDiv.className = 'paper-block-checkbox-label';
            lblDiv.textContent = block.label || '';
            row.appendChild(lblDiv);
        }
        container.appendChild(row);
    }

    function renderDividerBlock(container, block) {
        var line = document.createElement('div');
        line.className = 'paper-block-divider';
        line.setAttribute('data-style', block.style || 'solid');
        container.appendChild(line);
        if (isTemplateEdit()) {
            var ctrl = document.createElement('div');
            ctrl.className = 'paper-block-divider-controls';
            var styles = [
                { id: 'solid', name: 'ساده' }, { id: 'dashed', name: 'نقطه‌چین' },
                { id: 'double', name: 'دو خطی' }, { id: 'thick', name: 'ضخیم' },
            ];
            styles.forEach(function (s) {
                var btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'paper-block-divider-style-btn' + ((block.style || 'solid') === s.id ? ' is-active' : '');
                btn.textContent = s.name;
                btn.addEventListener('click', function () { block.style = s.id; renderBlocks(); });
                ctrl.appendChild(btn);
            });
            container.appendChild(ctrl);
        }
    }

    function renderSignatureBlock(container, block) {
        var box = document.createElement('div');
        box.className = 'paper-block-sig-inline';

        if (isTemplateEdit()) {
            var line = document.createElement('div');
            line.className = 'paper-block-sig-line is-empty';
            box.appendChild(line);
            var inp = document.createElement('input');
            inp.type = 'text'; inp.className = 'paper-block-label-input paper-block-sig-label-input';
            inp.value = block.label || ''; inp.placeholder = 'برچسب امضا (مثلاً: امضای متهم)'; inp.dir = 'rtl';
            inp.style.textAlign = 'center';
            bindInputUpdate(inp, block, 'label');
            box.appendChild(inp);
            container.appendChild(box);
            return;
        }

        if (block.value) {
            var script = document.createElement('div');
            script.className = 'doj-sig-script';
            script.textContent = block.value;
            box.appendChild(script);

            var info = document.createElement('div');
            info.className = 'doj-sig-info';
            info.textContent = block.info || '';
            box.appendChild(info);

            if (block.label) {
                var lbl = document.createElement('div');
                lbl.className = 'paper-block-sig-caption';
                lbl.textContent = block.label;
                box.appendChild(lbl);
            }

            if (isFilling() && block.identifier && block.identifier === state.me.identifier) {
                var rm = document.createElement('button');
                rm.type = 'button';
                rm.className = 'doj-sig-remove';
                rm.textContent = tr('TR_SIG_REMOVE_OWN', 'حذف امضای من');
                rm.addEventListener('click', function () {
                    block.value = ''; block.info = ''; block.identifier = '';
                    renderBlocks();
                });
                box.appendChild(rm);
            }
        } else {
            var emptyLine = document.createElement('div');
            emptyLine.className = 'paper-block-sig-line is-empty';
            box.appendChild(emptyLine);

            var capt = document.createElement('div');
            capt.className = 'paper-block-sig-caption';
            capt.textContent = block.label || '';
            box.appendChild(capt);

            if (isFilling() && !block.locked) {
                var signBtn = document.createElement('button');
                signBtn.type = 'button';
                signBtn.className = 'paper-block-sign-btn';
                signBtn.innerHTML = BLOCK_ICONS.pen + '<span>' + escape(tr('TR_SIG_SIGN', 'امضا کردن')) + '</span>';
                signBtn.addEventListener('click', function () { signInternal(block); });
                box.appendChild(signBtn);
            }
        }
        container.appendChild(box);
    }

    function signInternal(block) {
        if (mySignatureCount() >= 1) {
            toast(tr('TR_SIG_ALREADY', 'شما قبلاً امضا کرده‌اید'), 'error');
            return;
        }
        var me = state.me || {};
        if (!me.name) { toast('اطلاعات پیدا نشد', 'error'); return; }
        block.value = me.name;
        block.info = buildSignerInfo(me);
        block.identifier = me.identifier;
        renderBlocks();
    }

    function openBlockPicker() { if (!isTemplateEdit()) return; renderBlockPickerGrid(); $('blockPickerOverlay').classList.add('is-active'); }
    function closeBlockPicker() { $('blockPickerOverlay').classList.remove('is-active'); }
    function openTemplateChooser() { $('templateChooserOverlay').classList.add('is-active'); }
    function closeTemplateChooser() { $('templateChooserOverlay').classList.remove('is-active'); }

    function cancelTemplateChooser() {
        closeTemplateChooser();
        setRoot(false);
        state.mode = 'idle';
        state.doc = emptyDoc();
        fetchPost('editorBack', {});
    }

    function startCreateModel(templateType) {
        closeTemplateChooser();
        state.doc = emptyDoc();
        state.doc.templateType = templateType || 'formal';
        state.doc.date = formatDate(new Date());
        state.mode = 'createModel';
        state.creating = true;
        state.useBlocks = true;
        state.isPublicTemplate = false;
        renderActions();
        renderPaper();
        setRoot(true);
    }
    function onTemplateTypePick(e) { startCreateModel(e.currentTarget.getAttribute('data-type')); }

    function renderBlockPickerGrid() {
        var grid = $('blockPickerGrid');
        grid.innerHTML = '';
        var keys = ['header', 'text', 'input', 'textarea', 'date', 'twocol', 'image', 'checkbox', 'divider', 'signature', 'seal'];
        for (var i = 0; i < keys.length; i++) {
            var spec = BLOCK_TYPES[keys[i]];
            var item = document.createElement('button');
            item.type = 'button'; item.className = 'block-picker-item';
            item.setAttribute('data-type', keys[i]);
            item.innerHTML = '<div class="block-picker-item-icon">' + spec.icon + '</div>' +
                '<div class="block-picker-item-label">' + escape(spec.label) + '</div>' +
                '<div class="block-picker-item-desc">' + escape(spec.desc) + '</div>';
            item.addEventListener('click', onBlockPick);
            grid.appendChild(item);
        }
    }
    function onBlockPick(e) { addBlock(e.currentTarget.getAttribute('data-type')); closeBlockPicker(); }

    function onRemoveAttachment(e) {
        if (isViewMode()) return;
        var idx = parseInt(e.currentTarget.getAttribute('data-index'), 10);
        if (isNaN(idx)) return;
        state.doc.images.splice(idx, 1);
        renderAttachments();
    }
    function onOpenImageModal() { if (isViewMode()) return; $('imageUrl').value = ''; $('overlay').classList.add('is-active'); setTimeout(function () { $('imageUrl').focus(); }, 50); }
    function onCloseImageModal() { $('overlay').classList.remove('is-active'); }
    function onConfirmImage() {
        var url = sanitizeImageUrl($('imageUrl').value);
        if (!url) { toast('آدرس نامعتبر است؛ فقط http/https مجاز است', 'error'); return; }
        state.doc.images = state.doc.images || [];
        state.doc.images.push(url);
        renderAttachments();
        onCloseImageModal();
    }

    function pad(n) { return n < 10 ? '0' + n : String(n); }

    function jDiv(a, b) { return ~~(a / b); }
    function jMod(a, b) { return a - ~~(a / b) * b; }
    function jalCal(jy) {
        var breaks = [-61, 9, 38, 199, 426, 686, 756, 818, 1111, 1181, 1210, 1635, 2060, 2097, 2192, 2262, 2324, 2394, 2456, 3178];
        var bl = breaks.length, gy = jy + 621, leapJ = -14, jp = breaks[0], jm, jump, leap, n, i;
        for (i = 1; i < bl; i += 1) {
            jm = breaks[i]; jump = jm - jp;
            if (jy < jm) break;
            leapJ = leapJ + jDiv(jump, 33) * 8 + jDiv(jMod(jump, 33), 4);
            jp = jm;
        }
        n = jy - jp;
        leapJ = leapJ + jDiv(n, 33) * 8 + jDiv(jMod(n, 33) + 3, 4);
        if (jMod(jump, 33) === 4 && jump - n === 4) leapJ += 1;
        var leapG = jDiv(gy, 4) - jDiv((jDiv(gy, 100) + 1) * 3, 4) - 150;
        var march = 20 + leapJ - leapG;
        if (jump - n < 6) n = n - jump + jDiv(jump + 4, 33) * 33;
        leap = jMod(jMod(n + 1, 33) - 1, 4);
        if (leap === -1) leap = 4;
        return { leap: leap, gy: gy, march: march };
    }
    function jG2d(gy, gm, gd) {
        var d = jDiv((gy + jDiv(gm - 8, 6) + 100100) * 1461, 4) + jDiv(153 * jMod(gm + 9, 12) + 2, 5) + gd - 34840408;
        d = d - jDiv(jDiv(gy + 100100 + jDiv(gm - 8, 6), 100) * 3, 4) + 752;
        return d;
    }
    function jD2g(jdn) {
        var j = 4 * jdn + 139361631;
        j = j + jDiv(jDiv(4 * jdn + 183187720, 146097) * 3, 4) * 4 - 3908;
        var i = jDiv(jMod(j, 1461), 4) * 5 + 308;
        var gd = jDiv(jMod(i, 153), 5) + 1;
        var gm = jMod(jDiv(i, 153), 12) + 1;
        var gy = jDiv(j, 1461) - 100100 + jDiv(8 - gm, 6);
        return { gy: gy, gm: gm, gd: gd };
    }
    function jJ2d(jy, jm, jd) { var r = jalCal(jy); return jG2d(r.gy, 3, r.march) + (jm - 1) * 31 - jDiv(jm, 7) * (jm - 7) + jd - 1; }
    function jD2j(jdn) {
        var gy = jD2g(jdn).gy, jy = gy - 621, r = jalCal(jy), jdn1f = jG2d(gy, 3, r.march), jd, jm, k;
        k = jdn - jdn1f;
        if (k >= 0) {
            if (k <= 185) { jm = 1 + jDiv(k, 31); jd = jMod(k, 31) + 1; return { jy: jy, jm: jm, jd: jd }; }
            else { k -= 186; }
        } else { jy -= 1; k += 179; if (r.leap === 1) k += 1; }
        jm = 7 + jDiv(k, 30); jd = jMod(k, 30) + 1;
        return { jy: jy, jm: jm, jd: jd };
    }
    function toJalaali(gy, gm, gd) { return jD2j(jG2d(gy, gm, gd)); }
    function toGregorian(jy, jm, jd) { return jD2g(jJ2d(jy, jm, jd)); }
    function isLeapJalaali(jy) { return jalCal(jy).leap === 0; }
    function jalaaliMonthLength(jy, jm) { if (jm <= 6) return 31; if (jm <= 11) return 30; return isLeapJalaali(jy) ? 30 : 29; }

    function formatDate(d) {
        var j = toJalaali(d.getFullYear(), d.getMonth() + 1, d.getDate());
        return j.jy + '/' + pad(j.jm) + '/' + pad(j.jd);
    }

    var J_MONTHS = ['فروردین', 'اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور', 'مهر', 'آبان', 'آذر', 'دی', 'بهمن', 'اسفند'];
    var J_WEEKDAYS = ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'];
    var calTarget = null;
    var calView = { jy: 1403, jm: 1 };

    function parseDateValue(v) {
        if (!v) return null;
        var m = ('' + v).match(/(\d{3,4})\s*\/\s*(\d{1,2})\s*\/\s*(\d{1,2})/);
        if (!m) return null;
        var jy = parseInt(m[1], 10), jm = parseInt(m[2], 10), jd = parseInt(m[3], 10);
        if (jm < 1 || jm > 12 || jd < 1 || jd > 31) return null;
        return { jy: jy, jm: jm, jd: jd };
    }

    function jalaaliToday() {
        var now = new Date();
        return toJalaali(now.getFullYear(), now.getMonth() + 1, now.getDate());
    }

    function openCalendar(input, onPick) {
        calTarget = { input: input, onPick: onPick };
        var parsed = parseDateValue(input.value);
        if (parsed) { calView = { jy: parsed.jy, jm: parsed.jm }; }
        else { var t = jalaaliToday(); calView = { jy: t.jy, jm: t.jm }; }
        renderCalendar();
        $('calendarOverlay').classList.add('is-active');
    }
    function closeCalendar() { $('calendarOverlay').classList.remove('is-active'); calTarget = null; }

    function renderCalendar() {
        $('calTitle').textContent = J_MONTHS[calView.jm - 1] + ' ' + calView.jy;

        var wd = $('calWeekdays');
        wd.innerHTML = '';
        for (var w = 0; w < 7; w++) {
            var cell = document.createElement('div');
            cell.className = 'doj-cal-weekday';
            cell.textContent = J_WEEKDAYS[w];
            wd.appendChild(cell);
        }

        var grid = $('calGrid');
        grid.innerHTML = '';
        var g = toGregorian(calView.jy, calView.jm, 1);
        var firstDow = (new Date(g.gy, g.gm - 1, g.gd).getDay() + 1) % 7;
        var daysInMonth = jalaaliMonthLength(calView.jy, calView.jm);
        var selected = parseDateValue(calTarget && calTarget.input ? calTarget.input.value : '');
        var today = jalaaliToday();

        for (var b = 0; b < firstDow; b++) {
            var blank = document.createElement('div');
            blank.className = 'doj-cal-day is-blank';
            grid.appendChild(blank);
        }
        for (var d = 1; d <= daysInMonth; d++) {
            (function (day) {
                var cell = document.createElement('button');
                cell.type = 'button';
                cell.className = 'doj-cal-day';
                cell.textContent = String(day);
                if (selected && selected.jy === calView.jy && selected.jm === calView.jm && selected.jd === day) {
                    cell.className += ' is-selected';
                }
                if (today.jy === calView.jy && today.jm === calView.jm && today.jd === day) {
                    cell.className += ' is-today';
                }
                cell.addEventListener('click', function () { pickCalendarDate(day); });
                grid.appendChild(cell);
            })(d);
        }
    }

    function pickCalendarDate(day) {
        if (!calTarget) return;
        var value = calView.jy + '/' + pad(calView.jm) + '/' + pad(day);
        if (calTarget.input) calTarget.input.value = value;
        if (calTarget.onPick) calTarget.onPick(value);
        closeCalendar();
    }

    function calShiftMonth(dir) {
        var m = calView.jm + dir, y = calView.jy;
        if (m < 1) { m = 12; y--; }
        else if (m > 12) { m = 1; y++; }
        calView = { jy: y, jm: m };
        renderCalendar();
    }

    function calPickToday() {
        var t = jalaaliToday();
        calView = { jy: t.jy, jm: t.jm };
        pickCalendarDate(t.jd);
    }

    function calClearTarget() {
        if (!calTarget) return;
        if (calTarget.input) calTarget.input.value = '';
        if (calTarget.onPick) calTarget.onPick('');
        closeCalendar();
    }

    function attachDatePicker(input, onPick) {
        input.readOnly = true;
        input.classList.add('doj-datelike');
        input.addEventListener('click', function () {
            if (isViewMode()) return;
            openCalendar(input, onPick);
        });
    }

    function onRequestExit() { $('exitOverlay').classList.add('is-active'); }
    function onConfirmExit() { $('exitOverlay').classList.remove('is-active'); closeUI(); }
    function onCancelExit() { $('exitOverlay').classList.remove('is-active'); }

    function syncFromInputs() {
        state.doc.date = $('docDate').value;
        state.doc.title = (state.doc.templateType === 'blank') ? $('blankTitle').value : $('docTitle').value;
        if (!state.useBlocks) state.doc.text = $('docBody').value;
    }

    function onSave() {
        syncFromInputs();
        if (!state.doc.title || !state.doc.title.trim()) { toast('عنوان را وارد کنید', 'error'); return; }

        var docToSave = JSON.parse(JSON.stringify(state.doc));
        if (state.useBlocks) {
            docToSave.text = JSON.stringify({
                type: state.doc.templateType || 'formal',
                blocks: state.doc.blocks || [],
                public: state.isPublicTemplate || false,
                voided: state.doc.voided || false,
                justiceSeal: state.doc.justiceSeal || null,
            });
        }
        delete docToSave.blocks; delete docToSave.templateType; delete docToSave.voided; delete docToSave.justiceSeal;

        var payload = { creating: state.creating, infos_document: docToSave };

        if (isModel()) {
            payload.isPublic = state.isPublicTemplate || false;
            fetchPost('saveModel', payload);
        } else if (state.creating && state.sourcePublic) {
            fetchPost('savePublicDocument', payload);
        } else {
            fetchPost('saveDocument', payload);
        }

        toast(tr('TR_SAVE', 'ذخیره شد'), 'success');
        setRoot(false);
        fetchPost('editorSaved', {});
        state.mode = 'idle';
    }

    function tryParseDocContent(text) {
        if (!text) return null;
        try {
            var parsed = JSON.parse(text);
            if (Object.prototype.toString.call(parsed) === '[object Array]') {
                if (parsed.length === 0) return { type: 'formal', blocks: [], voided: false, public: false, justiceSeal: null };
                if (parsed[0] && typeof parsed[0] === 'object' && parsed[0].type) return { type: 'formal', blocks: parsed, voided: false, public: false, justiceSeal: null };
            }
            if (parsed && typeof parsed === 'object' && Object.prototype.toString.call(parsed.blocks) === '[object Array]') {
                return { type: parsed.type || 'formal', blocks: parsed.blocks, voided: !!parsed.voided, public: !!parsed.public, justiceSeal: parsed.justiceSeal || null };
            }
        } catch (e) {}
        return null;
    }

    function applyDocFromMessage(payload, mode, creating) {
        var d = payload.infos_document || {};
        if (typeof d.images === 'string') { try { d.images = JSON.parse(d.images); } catch (e) { d.images = []; } }
        if (typeof d.signatures === 'string') { try { d.signatures = JSON.parse(d.signatures); } catch (e) { d.signatures = []; } }

        state.me = payload.me || state.me;
        state.canPublish = !!payload.canPublish;
        state.isJustice = !!payload.isJustice;
        state.sourcePublic = !!payload.sourcePublic;

        var rawText = d.text || d.scope || '';
        var parsed = tryParseDocContent(rawText);

        state.doc = {
            id: d.id || null,
            name: d.name || '',
            name_creator: d.name_creator || '',
            date: d.date || '',
            title: d.title || '',
            text: parsed ? '' : rawText,
            blocks: parsed ? parsed.blocks : [],
            images: d.images || [],
            signatures: d.signatures || [],
            job: d.job || '',
            isopen: d.isopen == null ? 1 : d.isopen,
            templateType: parsed ? parsed.type : 'formal',
            voided: parsed ? parsed.voided : false,
            justiceSeal: parsed ? parsed.justiceSeal : null,
        };
        state.isPublicTemplate = parsed ? parsed.public : false;

        state.mode = mode;
        state.creating = !!creating;

        if (mode === 'createModel' || mode === 'editModel') {
            state.useBlocks = true;
            if (!parsed && rawText) state.doc.blocks = [{ id: genBlockId(), type: 'text', value: rawText, locked: false }];
        } else {
            state.useBlocks = parsed !== null;
        }

        renderActions();
        renderPaper();
        setRoot(true);
    }

    function handleConfig(data) {
        if (data.translate) state.translate = data.translate;
        if (data.NameResource) state.resource = data.NameResource;
        if (data.logo) {
            state.logo = data.logo;
            var menuEmblem = $('menuEmblemImg');
            if (menuEmblem) menuEmblem.src = data.logo;
            var sidebarEmblem = $('sidebarEmblemImg');
            if (sidebarEmblem) sidebarEmblem.src = data.logo;
        }
        if (data.header) state.header = data.header;
        if (data.subheader) state.subheader = data.subheader;
        if (data.watermark) { state.watermark = data.watermark; $('watermarkText').textContent = data.watermark; }
        if (data.translate && data.translate.TR_SEARCH_PLACEHOLDER) $('menuSearchInput').setAttribute('placeholder', data.translate.TR_SEARCH_PLACEHOLDER);
        if (data.translate && data.translate.TR_PUBLISH_LABEL) $('publishLabel').textContent = data.translate.TR_PUBLISH_LABEL;
        if (data.translate && data.translate.TR_PUBLISH_HINT) $('publishHint').textContent = data.translate.TR_PUBLISH_HINT;
        if (data.menuSettings) onMenuSettings(data.menuSettings);
    }

    function renderMenu(payload) {
        $('menuTitle').textContent = payload.title || '';
        $('menuSubtitle').textContent = payload.subtitle || '';

        var searchEl = $('menuSearchBox'), searchInput = $('menuSearchInput');
        if (payload.showSearch) {
            searchEl.classList.add('is-active');
            if (payload.searchPlaceholder) searchInput.setAttribute('placeholder', payload.searchPlaceholder);
        } else {
            searchEl.classList.remove('is-active');
            searchInput.value = '';
        }

        var listEl = $('menuItems'), emptyEl = $('menuEmpty');
        listEl.innerHTML = '';
        var items = payload.items || [];
        for (var i = 0; i < items.length; i++) listEl.appendChild(buildMenuItem(items[i]));

        if (items.length === 0) {
            emptyEl.textContent = payload.emptyText || 'موردی یافت نشد';
            emptyEl.classList.add('is-active');
        } else {
            emptyEl.classList.remove('is-active');
        }
        setMenu(true);
    }

    function buildMenuItem(item) {
        var li = document.createElement('li');
        li.className = 'menu-item';
        li.setAttribute('data-variant', item.variant || 'default');
        li.setAttribute('data-id', String(item.id));
        var iconHtml = MENU_ICONS[item.icon] || MENU_ICONS.document;
        var arrowHtml = (item.variant === 'loading') ? '' : '<span class="menu-item-arrow">' + MENU_ICONS.arrow + '</span>';
        var badgeHtml = item.badge ? '<span class="menu-item-badge">' + escape(item.badge) + '</span>' : '';
        li.innerHTML = '<div class="menu-item-icon">' + iconHtml + '</div>' +
            '<div class="menu-item-body">' +
                '<div class="menu-item-title">' + escape(item.text) + '</div>' +
                (item.text2 ? '<div class="menu-item-subtitle">' + escape(item.text2) + '</div>' : '') +
            '</div>' + badgeHtml + arrowHtml;
        if (item.variant !== 'loading') {
            li.addEventListener('click', function () {
                fetchPost('menuSelect', { id: parseInt(li.getAttribute('data-id'), 10) });
            });
        }
        return li;
    }

    function hideMenu() { setMenu(false); $('menuItems').innerHTML = ''; $('menuSearchInput').value = ''; }
    function onMenuClose() { fetchPost('menuClose', {}); hideMenu(); }

    var searchTimer = null;
    function onSearchInput(e) {
        if (searchTimer) clearTimeout(searchTimer);
        var query = e.target.value;
        searchTimer = setTimeout(function () { fetchPost('menuSearch', { query: query }); }, 220);
    }

    function openGiveModal(payload) {
        $('giveTitle').textContent = payload.title || 'اشتراک سند';
        $('giveLabel').textContent = payload.label || '';
        $('giveInput').value = '';
        $('giveInput').setAttribute('placeholder', payload.placeholder || '');
        $('giveConfirm').textContent = payload.confirm || 'اشتراک';
        $('giveCancel').textContent = payload.cancel || 'لغو';
        $('giveOverlay').classList.add('is-active');
        setTimeout(function () { $('giveInput').focus(); }, 60);
    }
    function closeGiveModal() { $('giveOverlay').classList.remove('is-active'); }
    function confirmGive() {
        var value = $('giveInput').value.trim();
        if (!value) { toast('شناسه یا اسم را وارد کنید', 'error'); return; }
        closeGiveModal();
        fetchPost('giveSubmit', { value: value });
    }

    function openBlacklistAddModal() {
        $('blacklistPlayerId').value = ''; $('blacklistReason').value = '';
        $('blacklistAddOverlay').classList.add('is-active');
        setTimeout(function () { $('blacklistPlayerId').focus(); }, 60);
    }
    function closeBlacklistAddModal() { $('blacklistAddOverlay').classList.remove('is-active'); }
    function confirmBlacklistAdd() {
        var target = $('blacklistPlayerId').value.trim();
        var reason = $('blacklistReason').value.trim();
        if (!target) { toast('شناسه یا استیم هکس را وارد کنید', 'error'); return; }
        if (!reason) { toast('دلیل را وارد کنید', 'error'); return; }
        fetchPost('blacklistAddPlayer', { target: target, reason: reason });
        closeBlacklistAddModal();
        toast('در حال پردازش...', 'success');
    }

    var confirmToken = null;
    function openConfirm(message, token) {
        confirmToken = token;
        $('confirmMessage').textContent = message || 'آیا مطمئن هستید؟';
        $('confirmOverlay').classList.add('is-active');
    }
    function closeConfirm() { $('confirmOverlay').classList.remove('is-active'); }
    function confirmYes() { var t = confirmToken; confirmToken = null; closeConfirm(); fetchPost('confirmResult', { token: t, ok: true }); }
    function confirmNo() { var t = confirmToken; confirmToken = null; closeConfirm(); fetchPost('confirmResult', { token: t, ok: false }); }

    function togglePublish() {
        state.isPublicTemplate = !state.isPublicTemplate;
        $('publishToggle').classList.toggle('is-on', state.isPublicTemplate);
    }

    function dispatch(data) {
        data = data || {};
        if (data.config) { handleConfig(data); return; }
        if (data.action === 'setMenuSettings') { onMenuSettings(data.settings); return; }
        if (data.action === 'showMenu') { renderMenu(data); return; }
        if (data.action === 'hideMenu') { hideMenu(); return; }
        if (data.action === 'openBlacklistAdd') { openBlacklistAddModal(); return; }
        if (data.action === 'promptGive') { openGiveModal(data); return; }
        if (data.action === 'confirm') { openConfirm(data.message, data.token); return; }
        if (data.openTemplateChooser) {
            state.mode = 'idle';
            state.doc = emptyDoc();
            state.me = data.me || state.me;
            state.canPublish = !!data.canPublish;
            state.isJustice = !!data.isJustice;
            setRoot(true);
            openTemplateChooser();
            return;
        }
        if (data.openCreateModel) { startCreateModel(data.templateType || 'formal'); return; }
        if (data.openCreateDocument) { applyDocFromMessage(data, 'createDocument', true); return; }
        if (data.openEditModel) { applyDocFromMessage(data, 'editModel', false); return; }
        if (data.openEditDocument) { applyDocFromMessage(data, 'editDocument', false); return; }
        if (data.openViewDocument) { applyDocFromMessage(data, 'view', false); return; }
        if (data.action === 'close') { closeUI(); return; }
    }

    function onMessage(event) {
        var m = event.data || {};
        if (m.type === 'initData') {
            var d = m.data || {};
            if (d.config) handleConfig(d.config);
            if (d.msg) dispatch(d.msg);
            return;
        }
        if (m.type === 'updateData') { dispatch(m.data || {}); return; }
        dispatch(m);
    }

    function bindUI() {
        loadCachedColors();

        $('modalClose').addEventListener('click', onCloseImageModal);
        $('modalCancel').addEventListener('click', onCloseImageModal);
        $('modalConfirm').addEventListener('click', onConfirmImage);
        $('exitCancel').addEventListener('click', onCancelExit);
        $('exitConfirm').addEventListener('click', onConfirmExit);

        $('menuCloseBtn').addEventListener('click', onMenuClose);
        $('menuSearchInput').addEventListener('input', onSearchInput);

        $('addBlockBtn').addEventListener('click', openBlockPicker);
        $('blockPickerClose').addEventListener('click', closeBlockPicker);

        $('templateChooserClose').addEventListener('click', cancelTemplateChooser);
        var chooserItems = document.querySelectorAll('.template-chooser-item');
        for (var i = 0; i < chooserItems.length; i++) chooserItems[i].addEventListener('click', onTemplateTypePick);

        $('blacklistAddClose').addEventListener('click', closeBlacklistAddModal);
        $('blacklistAddCancel').addEventListener('click', closeBlacklistAddModal);
        $('blacklistAddConfirm').addEventListener('click', confirmBlacklistAdd);

        $('giveClose').addEventListener('click', closeGiveModal);
        $('giveCancel').addEventListener('click', closeGiveModal);
        $('giveConfirm').addEventListener('click', confirmGive);
        $('giveInput').addEventListener('keydown', function (e) { if (e.key === 'Enter') { e.preventDefault(); confirmGive(); } else if (e.key === 'Escape') closeGiveModal(); });

        $('confirmYes').addEventListener('click', confirmYes);
        $('confirmNo').addEventListener('click', confirmNo);

        $('publishToggle').addEventListener('click', togglePublish);

        $('blacklistPlayerId').addEventListener('keydown', function (e) { if (e.key === 'Enter') { e.preventDefault(); $('blacklistReason').focus(); } });
        $('blacklistReason').addEventListener('keydown', function (e) { if (e.key === 'Enter' && (e.ctrlKey || e.metaKey)) { e.preventDefault(); confirmBlacklistAdd(); } });

        $('blankTitle').addEventListener('input', function (e) { state.doc.title = e.target.value; });

        $('docDate').addEventListener('click', function () {
            if (isViewMode()) return;
            openCalendar($('docDate'), function (v) { state.doc.date = v; });
        });
        $('calPrev').addEventListener('click', function () { calShiftMonth(-1); });
        $('calNext').addEventListener('click', function () { calShiftMonth(1); });
        $('calToday').addEventListener('click', calPickToday);
        $('calClear').addEventListener('click', calClearTarget);

        $('imageUrl').addEventListener('keydown', function (e) {
            if (e.key === 'Enter') { e.preventDefault(); onConfirmImage(); }
            else if (e.key === 'Escape') onCloseImageModal();
        });

        document.addEventListener('keydown', function (e) {
            if (e.key !== 'Escape') return;
            if ($('calendarOverlay').classList.contains('is-active')) { closeCalendar(); return; }
            if ($('confirmOverlay').classList.contains('is-active')) { confirmNo(); return; }
            if ($('giveOverlay').classList.contains('is-active')) { closeGiveModal(); return; }
            if ($('overlay').classList.contains('is-active')) { onCloseImageModal(); return; }
            if ($('blockPickerOverlay').classList.contains('is-active')) { closeBlockPicker(); return; }
            if ($('blacklistAddOverlay').classList.contains('is-active')) { closeBlacklistAddModal(); return; }
            if ($('templateChooserOverlay').classList.contains('is-active')) { cancelTemplateChooser(); return; }
            if ($('exitOverlay').classList.contains('is-active')) { onCancelExit(); return; }
            if ($('menuRoot').classList.contains('is-active')) { onMenuClose(); return; }
            if (document.querySelector('.app-root.is-active')) {
                if (isViewMode()) closeUI(); else onRequestExit();
            }
        });
    }

    window.addEventListener('message', onMessage);
    document.addEventListener('DOMContentLoaded', bindUI);
})();
