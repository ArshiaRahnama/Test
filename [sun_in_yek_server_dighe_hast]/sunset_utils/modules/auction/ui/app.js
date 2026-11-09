(function () {
    var state = {
        bundle: null,
        tab: 'bid',
        countdown: 0,
        ticker: null,
        adminSelected: null,
        bidEditorKey: null,
        itemsDraft: {},
        bulkKey: null,
        confirmKey: null,
        filterText: {},
        addingConfig: false
    };

    var confirmTimer = null;

    var REASONS = {
        noAuction: 'در حال حاضر مزایده‌ای فعال نیست.',
        noGang: 'شما عضو هیچ گنگی نیستید.',
        blacklist: 'گنگ شما اجازه‌ی شرکت در این مزایده را ندارد.',
        notAllowed: 'گنگ شما در محدوده‌ی مجازِ این مزایده نیست.',
        notBoss: 'فقط باسِ گنگ می‌تواند پیشنهاد ثبت کند.'
    };

    function send(action, data) {
        window.parent.postMessage({ type: 'nuiCallback', action: action, data: data || {} }, '*');
    }

    function esc(s) {
        s = String(s == null ? '' : s);
        return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    function fmt(n) {
        n = Math.floor(Number(n) || 0);
        var neg = n < 0;
        var s = String(Math.abs(n));
        var out = '';
        var c = 0;
        for (var i = s.length - 1; i >= 0; i--) {
            out = s.charAt(i) + out;
            c++;
            if (c % 3 === 0 && i > 0) out = ',' + out;
        }
        return (neg ? '-' : '') + out;
    }

    function mmss(sec) {
        sec = Math.max(0, Math.floor(sec || 0));
        var m = Math.floor(sec / 60);
        var s = sec % 60;
        return (m < 10 ? '0' : '') + m + ':' + (s < 10 ? '0' : '') + s;
    }

    function ltr(s) { return '<bdi dir="ltr">' + esc(s) + '</bdi>'; }
    function money(n) { return '<bdi dir="ltr">' + fmt(n) + '$</bdi>'; }

    function contains(arr, v) {
        if (!arr) return false;
        for (var i = 0; i < arr.length; i++) { if (arr[i] === v) return true; }
        return false;
    }

    function toArr(v) {
        var out = [];
        if (!v) return out;
        if (Object.prototype.toString.call(v) === '[object Array]') {
            for (var i = 0; i < v.length; i++) out.push(String(v[i]));
        } else if (typeof v === 'object') {
            for (var k in v) { if (Object.prototype.hasOwnProperty.call(v, k)) out.push(String(v[k])); }
        } else {
            out.push(String(v));
        }
        return out;
    }

    function parseGangList(text) {
        var out = [];
        var seen = {};
        var parts = String(text || '').split(/[\r\n,]+/);
        for (var i = 0; i < parts.length; i++) {
            var s = parts[i].replace(/--.*$/, '');
            s = s.replace(/^[\s'"\[\]{}]+/, '').replace(/[\s'"\[\]{}]+$/, '');
            if (!s) continue;
            if (seen['#' + s]) continue;
            seen['#' + s] = true;
            out.push(s);
        }
        return out;
    }

    function findCfg(arr, name) {
        if (!arr) return null;
        for (var i = 0; i < arr.length; i++) { if (arr[i].name === name) return arr[i]; }
        return null;
    }

    function el(tag, cls) {
        var d = document.createElement(tag);
        if (cls) d.className = cls;
        return d;
    }

    /* ---------- countdown ---------- */
    function setCountdown(sec) {
        state.countdown = Math.max(0, Math.floor(sec || 0));
        updateTimer();
    }

    function updateTimer() {
        var t = document.getElementById('timer');
        if (state.bundle && state.bundle.active) {
            t.textContent = mmss(state.countdown);
            t.className = 'timer' + (state.countdown <= 30 ? ' urgent' : '');
        } else {
            t.textContent = '--:--';
            t.className = 'timer';
        }
    }

    function startTicker() {
        if (state.ticker) return;
        var ticks = 0;
        state.ticker = setInterval(function () {
            if (state.bundle && state.bundle.active && state.countdown > 0) {
                state.countdown--;
                updateTimer();
                if (state.countdown === 0) { send('refresh'); }
            }
            ticks++;
            if (ticks % 3 === 0 && state.bundle && state.tab === 'bid' && state.bidEditorKey === null) {
                send('refresh');
            }
        }, 1000);
    }

    /* ---------- toast ---------- */
    var toastTimer = null;
    function notify(msg) {
        var t = document.getElementById('toast');
        t.textContent = msg;
        t.className = 'toast show';
        if (toastTimer) clearTimeout(toastTimer);
        toastTimer = setTimeout(function () { t.className = 'toast hidden'; }, 2800);
    }

    /* ---------- render root ---------- */
    function pickDefaultTab(b) {
        if (b.gang) return 'bid';
        if (b.isAdmin) return 'admin';
        return 'bid';
    }

    function render() {
        var b = state.bundle;
        if (!b) return;

        var tabBid = document.getElementById('tabBid');
        var tabAdmin = document.getElementById('tabAdmin');
        tabBid.style.display = b.gang ? '' : 'none';
        tabAdmin.style.display = b.isAdmin ? '' : 'none';

        if (state.tab === 'bid' && !b.gang) state.tab = b.isAdmin ? 'admin' : 'bid';
        if (state.tab === 'admin' && !b.isAdmin) state.tab = 'bid';

        tabBid.className = 'tab' + (state.tab === 'bid' ? ' active' : '');
        tabAdmin.className = 'tab' + (state.tab === 'admin' ? ' active' : '');

        var subtitle = document.getElementById('subtitle');
        if (b.active) subtitle.innerHTML = 'مزایده‌ی فعال: ' + ltr(b.active.label);
        else subtitle.textContent = 'هیچ مزایده‌ای فعال نیست';

        document.getElementById('bidView').className = 'view' + (state.tab === 'bid' ? '' : ' hidden');
        document.getElementById('adminView').className = 'view' + (state.tab === 'admin' ? '' : ' hidden');

        if (state.tab === 'bid') renderBid();
        else renderAdmin();
    }

    /* ---------- bid view ---------- */
    function reasonText(e) {
        if (e.reason === 'level') return 'برای شرکت، لِوِلِ گنگ باید حداقل ' + (e.need || 0) + ' باشد.';
        return REASONS[e.reason] || 'امکان شرکت در مزایده وجود ندارد.';
    }

    function emptyState(title, sub) {
        var d = el('div', 'empty');
        d.innerHTML = '<div class="empty-title">' + esc(title) + '</div>' + (sub ? '<div class="empty-sub">' + esc(sub) + '</div>' : '');
        return d;
    }

    function kv(label, valHtml) {
        var d = el('div', 'kv');
        d.innerHTML = '<span class="k">' + label + '</span><span class="v">' + valHtml + '</span>';
        return d;
    }

    function renderBid() {
        var b = state.bundle;
        var root = document.getElementById('bidView');
        root.innerHTML = '';

        if (!b.active) {
            root.appendChild(emptyState('در حال حاضر مزایده‌ای فعال نیست', 'منتظر بمانید تا ادمین مزایده‌ای را آغاز کند.'));
            return;
        }

        var top = el('div', 'bid-top');
        if (b.gang) {
            var c1 = el('div', 'chip');
            c1.innerHTML = 'موجودی لاکر گنگ: ' + money(b.gang.money);
            top.appendChild(c1);
            var c2 = el('div', 'chip muted');
            c2.innerHTML = 'گنگ: ' + ltr(b.gang.name);
            top.appendChild(c2);
        }
        root.appendChild(top);

        if (b.eligible && !b.eligible.ok && !b.anyOpen) {
            var banner = el('div', 'banner');
            banner.innerHTML = '<span class="banner-ico">⚠</span><span>' + esc(reasonText(b.eligible)) + '</span>';
            root.appendChild(banner);
        }

        var grid = el('div', 'grid');
        b.active.items.forEach(function (it) { grid.appendChild(itemCard(it, !!it.canBid, b)); });
        root.appendChild(grid);
    }

    function itemCard(it, eligible, b) {
        var card = el('div', 'card' + (it.mine ? ' mine' : ''));
        var editing = eligible && state.bidEditorKey === it.key;

        var line = el('div', 'card-line');

        var reserved = toArr(it.reserved);
        var head = el('div', 'card-head');
        var tags = '';
        if (it.mine) tags += '<span class="mine-tag">پیشنهاد شما</span>';
        if (reserved.length > 0) {
            if (it.canBid) {
                tags += '<span class="lock-tag own">ویژه‌ی تمدید شما</span>';
            } else {
                tags += '<span class="lock-tag">رزرو ' + ltr(reserved.join(' , ')) + '</span>';
            }
        }
        head.innerHTML = '<span class="item-label">' + ltr(it.label) + '</span>' + tags;
        line.appendChild(head);

        var rows = el('div', 'card-rows');
        rows.appendChild(kv('بالاترین پیشنهاد', it.currentBid > 0 ? money(it.currentBid) : '<span class="muted">—</span>'));
        rows.appendChild(kv('گنگ پیشتاز', it.currentGang ? ltr(it.currentGang) : '<span class="muted">—</span>'));
        rows.appendChild(kv('حداقل پیشنهاد بعدی', money(it.minNextBid)));
        line.appendChild(rows);

        var act = el('div', 'card-act');
        if (eligible && !editing) {
            var btn = el('button', 'btn primary');
            btn.textContent = 'ثبت پیشنهاد';
            btn.onclick = function () { state.bidEditorKey = it.key; renderBid(); };
            act.appendChild(btn);
        }
        line.appendChild(act);
        card.appendChild(line);

        if (editing) {
            card.appendChild(bidEditor(it, b));
        }
        return card;
    }

    function bidEditor(it, b) {
        var wrap = el('div', 'editor');
        var hint = el('div', 'hint');
        hint.innerHTML = 'حداقل: ' + money(it.minNextBid) + ' · موجودی لاکر: ' + money(b.gang ? b.gang.money : 0);
        wrap.appendChild(hint);

        var inp = el('input', 'num');
        inp.type = 'number';
        inp.value = it.minNextBid;
        inp.min = it.minNextBid;
        wrap.appendChild(inp);

        var actions = el('div', 'editor-actions');
        var ok = el('button', 'btn primary');
        ok.textContent = 'ثبت پیشنهاد';
        function submit() {
            var amount = Math.floor(Number(inp.value) || 0);
            if (amount < it.minNextBid) { notify('حداقل پیشنهاد ' + fmt(it.minNextBid) + '$ است'); return; }
            if (b.gang && amount > b.gang.money) { notify('موجودی لاکر گنگ کافی نیست'); return; }
            send('submitBid', { configName: state.bundle.active.configName, key: it.key, amount: amount });
            state.bidEditorKey = null;
        }
        ok.onclick = submit;
        var cancel = el('button', 'btn ghost');
        cancel.textContent = 'انصراف';
        cancel.onclick = function () { state.bidEditorKey = null; renderBid(); };
        actions.appendChild(ok);
        actions.appendChild(cancel);
        wrap.appendChild(actions);

        inp.addEventListener('keydown', function (e) { if (e.key === 'Enter') submit(); });
        setTimeout(function () { try { inp.focus(); inp.select(); } catch (err) {} }, 30);
        return wrap;
    }

    /* ---------- admin view ---------- */
    function renderAdmin() {
        var b = state.bundle;
        var ad = b.admin;
        var root = document.getElementById('adminView');
        root.innerHTML = '';

        if (!ad) { root.appendChild(emptyState('دسترسی مدیریت وجود ندارد', '')); return; }

        if (!state.adminSelected || !findCfg(ad.configs, state.adminSelected)) {
            state.adminSelected = (ad.configs[0] && ad.configs[0].name) || null;
        }

        var sel = el('div', 'cfg-tabs');
        ad.configs.forEach(function (c) {
            var t = el('button', 'cfg-tab' + (c.name === state.adminSelected ? ' active' : ''));
            t.innerHTML = ltr(c.label) + (c.name === ad.activeName ? '<span class="live-dot"></span>' : '') + (c.edited ? '<span class="edit-dot" title="ویرایش‌شده"></span>' : '');
            t.onclick = function () {
                state.adminSelected = c.name;
                state.bulkKey = null;
                state.confirmKey = null;
                renderAdmin();
            };
            sel.appendChild(t);
        });

        var addTab = el('button', 'cfg-tab add-tab' + (state.addingConfig ? ' active' : ''));
        addTab.textContent = state.addingConfig ? 'بستن' : '+ عنوان جدید';
        addTab.onclick = function () {
            state.addingConfig = !state.addingConfig;
            state.confirmKey = null;
            renderAdmin();
        };
        sel.appendChild(addTab);
        root.appendChild(sel);

        if (state.addingConfig) {
            var addBox = el('div', 'admin-box add-box');
            var ab = el('div', 'settings-row');

            var af = el('div', 'field grow-field');
            var al = el('label');
            al.textContent = 'عنوان مزایده‌ی جدید';
            af.appendChild(al);
            var ai = el('input', 'search');
            ai.type = 'text';
            ai.placeholder = 'مثلا Mechanic Shop';
            af.appendChild(ai);
            ab.appendChild(af);

            var ok = el('button', 'btn primary');
            ok.textContent = 'ساختن';
            var submitAdd = function () {
                var v = String(ai.value || '').replace(/^\s+|\s+$/g, '');
                if (!v) { notify('عنوان را وارد کنید'); return; }
                state.addingConfig = false;
                send('adminConfigAdd', { label: v });
            };
            ok.onclick = submitAdd;
            ai.addEventListener('keydown', function (e) { if (e.key === 'Enter') submitAdd(); });
            ab.appendChild(ok);

            addBox.appendChild(ab);
            var ah = el('div', 'hint');
            ah.textContent = 'مزایده‌ی جدید بدون آیتم و با لیست‌های خالی ساخته می‌شود · شناسه خودکار گرفته می‌شود · لیست خالی یعنی همه‌ی گنگ‌ها مجازند';
            addBox.appendChild(ah);
            root.appendChild(addBox);

            setTimeout(function () { try { ai.focus(); } catch (err) {} }, 30);
        }

        var cfg = findCfg(ad.configs, state.adminSelected);
        if (!cfg) return;

        root.appendChild(adminControl(cfg, ad));
        root.appendChild(adminItems(cfg, ad));
        root.appendChild(adminLists(cfg));
    }

    function adminControl(cfg, ad) {
        var box = el('div', 'admin-box');
        var isActive = ad.activeName === cfg.name;
        var anyActive = !!ad.activeName;

        var bar = el('div', 'ctrl-bar');

        var head = el('div', 'ctrl-head');
        var hTitle = el('div', 'box-title');
        hTitle.textContent = 'کنترل مزایده';
        head.appendChild(hTitle);
        var info = el('div', 'ctrl-info');
        if (anyActive) info.innerHTML = 'فعال: <b>' + ltr(ad.activeName) + '</b>';
        else info.textContent = 'هیچ مزایده‌ای فعال نیست';
        head.appendChild(info);
        bar.appendChild(head);

        var actions = el('div', 'ctrl-actions');

        var field = el('div', 'field');
        var lbl = el('label');
        lbl.textContent = 'مدت (دقیقه)';
        field.appendChild(lbl);
        var min = el('input', 'num mini');
        min.type = 'number';
        min.value = 10;
        min.min = 1;
        field.appendChild(min);
        actions.appendChild(field);

        var startBtn = el('button', 'btn primary' + (anyActive ? ' disabled' : ''));
        startBtn.textContent = 'شروع';
        startBtn.onclick = function () {
            if (anyActive) return;
            var m = Math.floor(Number(min.value) || 0);
            if (m <= 0) { notify('مدت را وارد کنید'); return; }
            send('adminStart', { configName: cfg.name, minutes: m });
        };
        actions.appendChild(startBtn);

        var stopBtn = el('button', 'btn ghost' + (isActive ? '' : ' disabled'));
        stopBtn.textContent = 'توقف';
        stopBtn.onclick = function () { if (isActive) send('adminStop', { configName: cfg.name }); };
        actions.appendChild(stopBtn);

        var finBtn = el('button', 'btn danger' + (isActive ? '' : ' disabled'));
        finBtn.textContent = 'پایان و پرداخت';
        finBtn.onclick = function () { if (isActive) send('adminFinish', { configName: cfg.name }); };
        actions.appendChild(finBtn);

        bar.appendChild(actions);
        box.appendChild(bar);

        var setRow = el('div', 'settings-row');

        var nameField = el('div', 'field grow-field');
        var nameLbl = el('label');
        nameLbl.textContent = 'عنوان';
        nameField.appendChild(nameLbl);
        var nameInp = el('input', 'search set-title');
        nameInp.type = 'text';
        nameInp.value = cfg.label;
        nameInp.disabled = isActive;
        nameField.appendChild(nameInp);
        setRow.appendChild(nameField);

        var lvlField = el('div', 'field');
        var lvlLbl = el('label');
        lvlLbl.textContent = 'حداقل لِوِل';
        lvlField.appendChild(lvlLbl);
        var lvlInp = el('input', 'num mini');
        lvlInp.type = 'number';
        lvlInp.min = 0;
        lvlInp.value = cfg.gangLevel || 0;
        lvlInp.disabled = isActive;
        lvlField.appendChild(lvlInp);
        setRow.appendChild(lvlField);

        var extField = el('div', 'field');
        var extLbl = el('label');
        extLbl.textContent = 'تایمر اضافه';
        extField.appendChild(extLbl);
        var extInp = el('input', 'num mini');
        extInp.type = 'number';
        extInp.min = 0;
        extInp.value = (cfg.extendTime === undefined || cfg.extendTime === null) ? 2 : cfg.extendTime;
        extInp.disabled = isActive;
        extField.appendChild(extInp);
        setRow.appendChild(extField);

        var idField = el('div', 'field');
        var idLbl = el('label');
        idLbl.textContent = 'شناسه (ID)';
        idField.appendChild(idLbl);
        var idInp = el('input', 'num mini id-input');
        idInp.type = 'number';
        idInp.min = 1;
        idInp.value = cfg.id;
        idInp.disabled = isActive;
        idField.appendChild(idInp);
        setRow.appendChild(idField);

        var setSave = el('button', 'btn primary' + (isActive ? ' disabled' : ''));
        setSave.textContent = 'ذخیره تنظیمات';
        setSave.onclick = function () {
            if (isActive) { notify('تا وقتی مزایده در حال اجراست تنظیمات قابل تغییر نیست'); return; }
            var title = String(nameInp.value || '').replace(/^\s+|\s+$/g, '');
            if (!title) { notify('عنوان نمی‌تواند خالی باشد'); return; }
            var idv = Math.floor(Number(idInp.value) || 0);
            if (idv < 1) { notify('شناسه باید عددی بزرگ‌تر از صفر باشد'); return; }
            var lv = Math.floor(Number(lvlInp.value) || 0);
            if (lv < 0) { notify('لِوِل نمی‌تواند منفی باشد'); return; }
            var et = Math.floor(Number(extInp.value) || 0);
            if (et < 0) { notify('تایمر اضافه نمی‌تواند منفی باشد'); return; }
            send('adminConfigSave', {
                configName: cfg.name,
                patch: { label: title, id: idv, gangLevel: lv, extendTime: et }
            });
        };
        setRow.appendChild(setSave);

        if (cfg.isExtra) {
            var delKey = 'delcfg|' + cfg.name;
            var delBtn = el('button', 'btn danger' + (isActive ? ' disabled' : ''));
            if (state.confirmKey === delKey) {
                delBtn.textContent = 'مطمئنی؟ حذف کن';
                delBtn.onclick = function () {
                    state.confirmKey = null;
                    state.adminSelected = null;
                    send('adminConfigRemove', { configName: cfg.name });
                };
            } else {
                delBtn.textContent = 'حذف مزایده';
                delBtn.onclick = function () {
                    if (isActive) { notify('اول مزایده را متوقف کنید'); return; }
                    state.confirmKey = delKey;
                    renderAdmin();
                    if (confirmTimer) clearTimeout(confirmTimer);
                    confirmTimer = setTimeout(function () {
                        if (state.confirmKey === delKey) { state.confirmKey = null; renderAdmin(); }
                    }, 4000);
                };
            }
            setRow.appendChild(delBtn);
        }

        box.appendChild(setRow);

        if (isActive && state.bundle.active && state.bundle.active.configName === cfg.name) {
            var table = el('div', 'bids-table');
            state.bundle.active.items.forEach(function (it) {
                var r = el('div', 'bid-row');
                r.innerHTML = '<span>' + ltr(it.label) + '</span>' +
                    '<span>' + (it.currentBid > 0 ? money(it.currentBid) : '—') + '</span>' +
                    '<span class="muted">' + (it.currentGang ? ltr(it.currentGang) : '—') + '</span>';
                table.appendChild(r);
            });
            box.appendChild(table);
        }
        return box;
    }

    function draftFor(cfg) {
        if (!state.itemsDraft[cfg.name]) {
            var d = [];
            (cfg.items || []).forEach(function (it) {
                d.push({ label: it.label, min: it.min, gang: toArr(it.gang).join(' , ') });
            });
            state.itemsDraft[cfg.name] = d;
        }
        return state.itemsDraft[cfg.name];
    }

    function adminItems(cfg, ad) {
        var box = el('div', 'admin-box');
        var locked = (ad.activeName === cfg.name);

        var hd = el('div', 'box-title row-between');
        var left = el('span');
        left.innerHTML = 'آیتم‌های مزایده <span class="count">' + (cfg.items || []).length + '</span>' +
            (cfg.setupEdited ? '<span class="edit-dot" title="ویرایش‌شده"></span>' : '');
        hd.appendChild(left);

        if (!locked) {
            var addBtn = el('button', 'btn ghost small');
            addBtn.textContent = '+ افزودن آیتم';
            addBtn.onclick = function () {
                draftFor(cfg).push({ label: '', min: 10000000, gang: '' });
                renderAdmin();
            };
            hd.appendChild(addBtn);
        }
        box.appendChild(hd);

        if (locked) {
            var warn = el('div', 'ctrl-info');
            warn.textContent = 'تا وقتی این مزایده در حال اجراست، شناسه و آیتم‌ها قابل ویرایش نیستند. اول آن را متوقف یا تمام کنید.';
            box.appendChild(warn);
            var ro = el('div', 'bids-table');
            (cfg.items || []).forEach(function (it) {
                var r = el('div', 'bid-row');
                r.innerHTML = '<span>' + ltr(it.label) + '</span>' +
                    '<span class="muted">حداقل: ' + money(it.min) + '</span><span></span>';
                ro.appendChild(r);
            });
            box.appendChild(ro);
            return box;
        }

        var draft = draftFor(cfg);
        var wrap = el('div', 'items-editor');

        if (draft.length === 0) {
            var e0 = el('div', 'muted tiny');
            e0.textContent = 'هیچ آیتمی تعریف نشده است.';
            wrap.appendChild(e0);
        }

        if (draft.length > 0) {
            var ih = el('div', 'items-head');
            var ih1 = el('span', 'it-name');
            ih1.textContent = 'نام آیتم';
            var ih2 = el('span', 'it-gang');
            ih2.textContent = 'رزرو برای گنگ (خالی = آزاد)';
            var ih3 = el('span', 'it-min');
            ih3.textContent = 'حداقل قیمت';
            var ih4 = el('span', 'it-act');
            ih.appendChild(ih1);
            ih.appendChild(ih2);
            ih.appendChild(ih3);
            ih.appendChild(ih4);
            wrap.appendChild(ih);
        }

        draft.forEach(function (row, idx) {
            var r = el('div', 'item-row');

            var i1 = el('input', 'search it-name');
            i1.type = 'text';
            i1.value = row.label;
            i1.placeholder = 'Ahangari 5';
            i1.addEventListener('input', function () { row.label = i1.value; });
            r.appendChild(i1);

            var i3 = el('input', 'search it-gang' + (row.gang ? ' locked' : ''));
            i3.type = 'text';
            i3.value = row.gang || '';
            i3.placeholder = 'خالی بگذارید تا آزاد باشد';
            i3.addEventListener('input', function () {
                row.gang = i3.value;
                i3.className = 'search it-gang' + (String(i3.value || '').replace(/^\s+|\s+$/g, '') ? ' locked' : '');
            });
            r.appendChild(i3);

            var i2 = el('input', 'num it-min');
            i2.type = 'number';
            i2.min = 1;
            i2.value = row.min;
            i2.addEventListener('input', function () { row.min = Math.floor(Number(i2.value) || 0); });
            r.appendChild(i2);

            var del = el('button', 'btn danger small it-act');
            del.textContent = 'حذف';
            del.onclick = function () { draft.splice(idx, 1); renderAdmin(); };
            r.appendChild(del);

            wrap.appendChild(r);
        });
        box.appendChild(wrap);

        var actions = el('div', 'items-actions');

        var hint = el('div', 'hint');
        hint.textContent = 'تغییرات تا زدن ذخیره اعمال نمی‌شود · ذخیره، پیشنهادهای ثبت‌شده را پاک می‌کند';
        actions.appendChild(hint);
        var save = el('button', 'btn primary');
        save.textContent = 'ذخیره آیتم‌ها';
        save.onclick = function () {
            var out = [];
            for (var i = 0; i < draft.length; i++) {
                var lb = String(draft[i].label || '').replace(/^\s+|\s+$/g, '');
                var mn = Math.floor(Number(draft[i].min) || 0);
                if (!lb) { notify('نام آیتم ردیف ' + (i + 1) + ' خالی است'); return; }
                if (mn < 1) { notify('حداقل قیمت ' + lb + ' باید بزرگ‌تر از صفر باشد'); return; }
                out.push({ label: lb, min: mn, gang: String(draft[i].gang || '') });
            }
            if (out.length === 0) { notify('حداقل یک آیتم لازم است'); return; }
            state.itemsDraft[cfg.name] = null;
            send('adminConfigSave', { configName: cfg.name, patch: { items: out } });
        };
        var undo = el('button', 'btn ghost');
        undo.textContent = 'لغو تغییرات';
        undo.onclick = function () { state.itemsDraft[cfg.name] = null; renderAdmin(); };
        actions.appendChild(undo);
        actions.appendChild(save);
        box.appendChild(actions);

        return box;
    }

    function bulkBox(cfg, which) {
        var wrap = el('div', 'bulk');

        var hint = el('div', 'hint');
        hint.textContent = 'لیست را بچسبانید — هر خط یک گنگ. کوتیشن، کاما، براکت و کامنت خودکار حذف می‌شود.';
        wrap.appendChild(hint);

        var ta = el('textarea', 'bulk-area');
        ta.placeholder = "'Amazon',\n'Apachea',\n'EndLess',";
        wrap.appendChild(ta);

        var count = el('div', 'muted tiny bulk-count');
        count.textContent = '0 گنگ شناسایی شد';
        wrap.appendChild(count);

        ta.addEventListener('input', function () {
            count.textContent = parseGangList(ta.value).length + ' گنگ شناسایی شد';
        });

        var acts = el('div', 'editor-actions');
        var ok = el('button', 'btn primary');
        ok.textContent = 'افزودن به لیست';
        ok.onclick = function () {
            var list = parseGangList(ta.value);
            if (list.length === 0) { notify('هیچ اسمی پیدا نشد'); return; }
            state.bulkKey = null;
            send('adminBulkAddGangs', { configName: cfg.name, which: which, text: ta.value });
        };
        acts.appendChild(ok);
        var cancel = el('button', 'btn ghost');
        cancel.textContent = 'انصراف';
        cancel.onclick = function () { state.bulkKey = null; renderAdmin(); };
        acts.appendChild(cancel);
        wrap.appendChild(acts);

        setTimeout(function () { try { ta.focus(); } catch (err) {} }, 30);
        return wrap;
    }

    function adminLists(cfg) {
        var box = el('div', 'admin-box');
        var hd = el('div', 'box-title row-between');
        var span = el('span');
        span.textContent = 'مدیریت لیست‌ها — لِوِل لازم: ' + (cfg.gangLevel || 0);
        hd.appendChild(span);
        var reset = el('button', 'btn ghost small');
        reset.textContent = 'بازگردانی به کانفیگ';
        reset.onclick = function () {
            state.itemsDraft[cfg.name] = null;
            state.bulkKey = null;
            state.confirmKey = null;
            send('adminResetLists', { configName: cfg.name });
        };
        hd.appendChild(reset);
        box.appendChild(hd);

        var cols = el('div', 'list-cols');
        cols.appendChild(listColumn(cfg, 'allow', 'وایت‌لیست (مجاز)', cfg.allow));
        cols.appendChild(listColumn(cfg, 'black', 'بلک‌لیست (مسدود)', cfg.black));
        box.appendChild(cols);
        return box;
    }

    function listColumn(cfg, which, title, gangs) {
        gangs = gangs || [];
        var col = el('div', 'list-col ' + which);

        var bulkKey = cfg.name + '|' + which;

        var h = el('div', 'col-title row-between');
        var hs = el('span');
        hs.innerHTML = title + ' <span class="count">' + gangs.length + '</span>';
        h.appendChild(hs);

        var tools = el('div', 'col-tools');
        var bulkBtn = el('button', 'btn ghost small');
        bulkBtn.textContent = (state.bulkKey === bulkKey) ? 'بستن' : 'افزودن گروهی';
        bulkBtn.onclick = function () {
            state.bulkKey = (state.bulkKey === bulkKey) ? null : bulkKey;
            state.confirmKey = null;
            renderAdmin();
        };
        tools.appendChild(bulkBtn);

        var clearBtn = el('button', 'btn danger small');
        if (state.confirmKey === bulkKey) {
            clearBtn.textContent = 'مطمئنی؟ پاک کن';
            clearBtn.onclick = function () {
                state.confirmKey = null;
                send('adminClearList', { configName: cfg.name, which: which });
            };
        } else {
            clearBtn.textContent = 'پاک کردن همه';
            clearBtn.onclick = function () {
                if (gangs.length === 0) { notify('این لیست از قبل خالی است'); return; }
                state.confirmKey = bulkKey;
                renderAdmin();
                if (confirmTimer) clearTimeout(confirmTimer);
                confirmTimer = setTimeout(function () {
                    if (state.confirmKey === bulkKey) { state.confirmKey = null; renderAdmin(); }
                }, 4000);
            };
        }
        tools.appendChild(clearBtn);
        h.appendChild(tools);
        col.appendChild(h);

        if (state.bulkKey === bulkKey) {
            col.appendChild(bulkBox(cfg, which));
        }

        var filterInp = null;
        if (gangs.length > 0) {
            filterInp = el('input', 'search filter-input');
            filterInp.type = 'text';
            filterInp.placeholder = 'جستجوی گنگ برای فیلتر...';
            filterInp.value = state.filterText[bulkKey] || '';
            col.appendChild(filterInp);
        }

        var chips = el('div', 'chips');
        var chipRefs = [];

        if (gangs.length === 0) {
            var e0 = el('div', 'muted tiny');
            e0.textContent = 'خالی';
            chips.appendChild(e0);
        }
        gangs.forEach(function (g) {
            var c = el('span', 'gchip');
            c.innerHTML = ltr(g);
            var x = el('button', 'gx');
            x.textContent = '✕';
            x.onclick = function () { send('adminRemoveGang', { configName: cfg.name, which: which, gang: g }); };
            c.appendChild(x);
            chips.appendChild(c);
            chipRefs.push({ node: c, key: String(g).toLowerCase() });
        });

        var noHit = el('div', 'muted tiny hidden');
        noHit.textContent = 'گنگی با این نام در لیست نیست';
        chips.appendChild(noHit);
        col.appendChild(chips);

        if (filterInp) {
            var applyFilter = function () {
                var q = (filterInp.value || '').toLowerCase().replace(/^\s+|\s+$/g, '');
                state.filterText[bulkKey] = filterInp.value;
                var shown = 0;
                for (var i = 0; i < chipRefs.length; i++) {
                    var hit = (q === '' || chipRefs[i].key.indexOf(q) !== -1);
                    chipRefs[i].node.style.display = hit ? '' : 'none';
                    if (hit) shown++;
                }
                noHit.className = (shown === 0) ? 'muted tiny' : 'muted tiny hidden';
            };
            filterInp.addEventListener('input', applyFilter);
            applyFilter();
        }

        var picker = el('div', 'picker');
        var inp = el('input', 'search');
        inp.type = 'text';
        inp.placeholder = 'جستجوی گنگ برای افزودن...';
        picker.appendChild(inp);
        var results = el('div', 'results hidden');
        picker.appendChild(results);

        function renderResults() {
            var q = (inp.value || '').toLowerCase().replace(/^\s+|\s+$/g, '');
            results.innerHTML = '';
            if (q.length < 1) { results.className = 'results hidden'; return; }
            var all = (state.bundle.admin && state.bundle.admin.gangsAll) || [];
            var shown = 0;
            for (var i = 0; i < all.length && shown < 8; i++) {
                var g = all[i];
                if (g.toLowerCase().indexOf(q) === -1) continue;
                if (contains(gangs, g)) continue;
                shown++;
                (function (gg) {
                    var r = el('button', 'result');
                    r.innerHTML = ltr(gg);
                    r.onclick = function () { send('adminAddGang', { configName: cfg.name, which: which, gang: gg }); inp.value = ''; renderResults(); };
                    results.appendChild(r);
                })(g);
            }
            if (shown === 0) {
                var raw = (inp.value || '').replace(/^\s+|\s+$/g, '');
                var parsed = parseGangList(raw);
                var add = el('button', 'result add-free');
                if (parsed.length > 1) {
                    add.innerHTML = 'افزودن ' + parsed.length + ' گنگ از متن واردشده';
                    add.onclick = function () {
                        send('adminBulkAddGangs', { configName: cfg.name, which: which, text: raw });
                        inp.value = '';
                        renderResults();
                    };
                } else {
                    var one = parsed.length === 1 ? parsed[0] : raw;
                    add.innerHTML = 'افزودن «' + ltr(one) + '»';
                    add.onclick = function () {
                        if (!one) return;
                        send('adminAddGang', { configName: cfg.name, which: which, gang: one });
                        inp.value = '';
                        renderResults();
                    };
                }
                results.appendChild(add);
            }
            results.className = 'results';
        }
        inp.addEventListener('input', renderResults);
        col.appendChild(picker);
        return col;
    }

    /* ---------- apply data ---------- */
    function applyBundle(b) {
        state.bundle = b || {};
        state.tab = pickDefaultTab(state.bundle);
        state.adminSelected = null;
        state.bidEditorKey = null;
        document.getElementById('overlay').className = 'overlay';
        setCountdown(state.bundle.active ? state.bundle.active.remaining : 0);
        startTicker();
        render();
    }

    function applyState(p) {
        if (!state.bundle) return;
        state.bundle.activeName = p.activeName;
        state.bundle.active = p.active;
        if (p.eligible !== undefined) state.bundle.eligible = p.eligible;
        if (p.gangMoney !== undefined && state.bundle.gang) state.bundle.gang.money = p.gangMoney;
        if (p.admin !== undefined) state.bundle.admin = p.admin;
        setCountdown(p.active ? p.active.remaining : 0);
        render();
    }

    function handleUpdate(p) {
        if (!p) return;
        if (p.type === 'tick') {
            if (state.bundle && state.bundle.active) setCountdown(p.remaining);
            return;
        }
        if (p.type === 'notify') { notify(p.message); return; }
        if (p.type === 'bundle') {
            var keepTab = state.tab, keepSel = state.adminSelected;
            applyBundle(p.data || {});
            if (keepTab) state.tab = keepTab;
            state.adminSelected = keepSel;
            render();
            return;
        }
        if (p.type === 'state') { applyState(p); return; }
    }

    /* ---------- wiring ---------- */
    window.addEventListener('message', function (e) {
        var m = e.data;
        if (!m) return;
        if (m.type === 'initData') applyBundle(m.data || {});
        else if (m.type === 'updateData') handleUpdate(m.data || {});
    });

    document.addEventListener('DOMContentLoaded', function () {
        document.getElementById('tabBid').onclick = function () { state.tab = 'bid'; render(); };
        document.getElementById('tabAdmin').onclick = function () { state.tab = 'admin'; render(); };
        document.getElementById('closeBtn').onclick = function () { send('close', {}); };
        document.getElementById('overlay').addEventListener('mousedown', function (e) {
            if (e.target === document.getElementById('overlay')) send('close', {});
        });
        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' || e.keyCode === 27) {
                if (state.bidEditorKey !== null) { state.bidEditorKey = null; renderBid(); }
                else send('close', {});
            }
        });
    });
})();
