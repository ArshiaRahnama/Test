(function () {
    var state = {
        doors: [],
        picking: false,
        pickCount: 0,
        outlinedCount: 0,
        selectedId: null,
        draft: null,
        search: '',
        sortBy: 'dist',
        confirmDelete: false,
        jsonText: '',
        jsonDirty: false
    };

    var toastTimer = null;
    var confirmTimer = null;

    function send(action, data) {
        window.parent.postMessage({ type: 'nuiCallback', action: action, data: data || {} }, '*');
    }

    function esc(s) {
        s = String(s == null ? '' : s);
        return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
    }

    function ltr(s) { return '<bdi dir="ltr">' + esc(s) + '</bdi>'; }

    function el(tag, cls) {
        var n = document.createElement(tag);
        if (cls) n.className = cls;
        return n;
    }

    function trim(s) { return String(s == null ? '' : s).replace(/^\s+|\s+$/g, ''); }

    function toast(msg) {
        var t = document.getElementById('toast');
        t.textContent = msg;
        t.className = 'toast';
        if (toastTimer) clearTimeout(toastTimer);
        toastTimer = setTimeout(function () { t.className = 'toast hidden'; }, 2600);
    }

    function copyText(text, label) {
        var active = document.activeElement;
        var ok = false;
        try {
            var ta = document.createElement('textarea');
            ta.value = text;
            ta.setAttribute('readonly', '');
            ta.style.position = 'fixed';
            ta.style.top = '-2000px';
            ta.style.opacity = '0';
            document.body.appendChild(ta);
            ta.focus();
            ta.select();
            ta.setSelectionRange(0, text.length);
            ok = document.execCommand('copy');
            document.body.removeChild(ta);
        } catch (e) {
            ok = false;
        }
        if (!ok && navigator.clipboard && navigator.clipboard.writeText) {
            try { navigator.clipboard.writeText(text); ok = true; } catch (e2) { ok = false; }
        }
        if (active && active.focus) { try { active.focus(); } catch (e3) {} }
        toast(ok ? (label + ' کپی شد') : 'کپی انجام نشد');
    }

    function permsToJson(list) {
        var parts = [];
        for (var i = 0; i < list.length; i++) {
            parts.push('"' + String(list[i].name).replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '":' + list[i].grade);
        }
        return '{' + parts.join(',') + '}';
    }

    function parsePermJson(text) {
        var t = trim(text);
        if (!t) return { err: 'چیزی وارد نشده است' };
        var obj;
        try {
            obj = JSON.parse(t);
        } catch (err) {
            return { err: 'JSON نامعتبر است' };
        }
        if (!obj || typeof obj !== 'object' || Object.prototype.toString.call(obj) === '[object Array]') {
            return { err: 'باید یک آبجکت باشد، مثل {"police":0}' };
        }
        var out = [];
        var skipped = 0;
        for (var k in obj) {
            if (!Object.prototype.hasOwnProperty.call(obj, k)) continue;
            var name = trim(k);
            var g = Math.floor(Number(obj[k]));
            if (!name || name.length > 40 || isNaN(g)) { skipped++; continue; }
            if (g < 0) g = 0;
            out.push({ name: name, grade: g });
        }
        if (out.length === 0) return { err: 'هیچ دسترسی معتبری پیدا نشد' };
        return { list: out, skipped: skipped };
    }

    function findDoor(id) {
        for (var i = 0; i < state.doors.length; i++) {
            if (state.doors[i].id === id) return state.doors[i];
        }
        return null;
    }

    function makeDraft(d) {
        var perms = [];
        for (var i = 0; i < (d.authorized || []).length; i++) {
            perms.push({ name: d.authorized[i].name, grade: d.authorized[i].grade });
        }
        return {
            id: d.id,
            locked2: !!d.locked2,
            holdOpen: !!d.holdOpen,
            autoLock: !!d.autoLock,
            autoLockTime: Number(d.autoLockTime) || 10,
            maxDistance: Number(d.maxDistance) || 1.5,
            authorized: perms
        };
    }

    function selectDoor(id) {
        var d = findDoor(id);
        if (!d) return;
        state.selectedId = id;
        state.draft = makeDraft(d);
        state.confirmDelete = false;
        state.jsonText = '';
        state.jsonDirty = false;
        render();
    }

    function visibleDoors() {
        var q = state.search.toLowerCase();
        var out = [];
        for (var i = 0; i < state.doors.length; i++) {
            var d = state.doors[i];
            if (q) {
                var hay = String(d.id);
                for (var j = 0; j < (d.authorized || []).length; j++) {
                    hay += ' ' + d.authorized[j].name;
                }
                if (hay.toLowerCase().indexOf(q) === -1) continue;
            }
            out.push(d);
        }
        out.sort(function (a, b) {
            if (state.sortBy === 'id') return a.id - b.id;
            return a.distance - b.distance;
        });
        return out;
    }

    function permsText(d) {
        var list = d.authorized || [];
        if (d.isfree) return 'بدون محدودیت';
        if (list.length === 0) return 'هیچ دسترسی‌ای ثبت نشده';
        var parts = [];
        for (var i = 0; i < list.length; i++) {
            parts.push('<b>' + esc(list[i].name) + '</b> ' + ltr('≥ ' + list[i].grade));
        }
        return parts.join(' · ');
    }

    function doorCard(d) {
        var card = el('div', 'door' + (d.id === state.selectedId ? ' sel' : ''));
        card.onclick = function (e) {
            if (e.target && e.target.getAttribute && e.target.getAttribute('data-act')) return;
            selectDoor(d.id);
        };

        var top = el('div', 'door-top');

        var idWrap = el('div', 'door-id');
        idWrap.innerHTML = '<span class="id-badge">' + ltr(d.id) + '</span>' +
            '<span class="' + (d.locked2 ? 'chip locked' : 'chip open') + '">' + (d.locked2 ? 'قفل هنگام شروع' : 'باز هنگام شروع') + '</span>' +
            (d.autoLock ? '<span class="chip auto">قفل خودکار ' + ltr(d.autoLockTime + 's') + '</span>' : '') +
            (d.holdOpen ? '<span class="chip">باز نگه‌داشته می‌شود</span>' : '') +
            (d.isfree ? '<span class="chip free">آزاد</span>' : '');
        top.appendChild(idWrap);

        var side = el('div', 'door-side');

        var acts = el('div', 'door-acts');

        var tp = el('button', 'btn ghost');
        tp.textContent = 'تلپورت';
        tp.setAttribute('data-act', '1');
        tp.onclick = function () { send('teleport', { id: d.id }); toast('به در ' + d.id + ' منتقل شدی'); };
        acts.appendChild(tp);

        var ol = el('button', 'btn ' + (d.outlined ? 'on' : 'ghost'));
        ol.textContent = d.outlined ? 'هایلایت ✓' : 'هایلایت';
        ol.setAttribute('data-act', '1');
        ol.onclick = function () { send('outline', { id: d.id }); };
        acts.appendChild(ol);

        side.appendChild(acts);

        var meta = el('div');
        meta.innerHTML = '<span class="door-dist">' + ltr(d.distance + ' m') + '</span>' +
            '<span class="door-count">' + ltr(d.doorCount) + ' لنگه</span>';
        side.appendChild(meta);

        top.appendChild(side);
        card.appendChild(top);

        var perms = el('div', 'door-perms');
        perms.innerHTML = permsText(d);
        perms.title = perms.textContent;
        card.appendChild(perms);

        return card;
    }

    function renderList() {
        var host = document.getElementById('list');
        var keepScroll = host.parentNode ? host.parentNode.scrollTop : 0;
        host.innerHTML = '';
        var list = visibleDoors();
        if (list.length === 0) {
            var e = el('div', 'empty');
            e.textContent = state.doors.length === 0 ? 'هیچ دری ثبت نشده است.' : 'دری با این جستجو پیدا نشد.';
            host.appendChild(e);
            return;
        }
        for (var i = 0; i < list.length; i++) host.appendChild(doorCard(list[i]));
        if (host.parentNode) host.parentNode.scrollTop = keepScroll;
    }

    function toggleRow(label, value, onChange) {
        var r = el('div', 'row');
        var l = el('span', 'row-label');
        l.textContent = label;
        r.appendChild(l);
        var t = el('div', 'toggle' + (value ? ' on' : ''));
        t.innerHTML = '<i></i>';
        t.onclick = function () { onChange(!value); };
        r.appendChild(t);
        return r;
    }

    function numRow(label, value, step, onChange) {
        var r = el('div', 'row');
        var l = el('span', 'row-label');
        l.textContent = label;
        r.appendChild(l);
        var i = el('input', 'num');
        i.type = 'number';
        i.min = '0';
        i.step = step;
        i.value = value;
        i.onchange = function () { onChange(i.value); };
        r.appendChild(i);
        return r;
    }

    function renderEditor() {
        var host = document.getElementById('editCol');
        host.innerHTML = '';

        if (!state.draft) {
            var e = el('div', 'empty');
            e.textContent = 'یک در را از لیست انتخاب کن.';
            host.appendChild(e);
            return;
        }

        var d = state.draft;
        var full = findDoor(d.id);

        var t = el('div', 'sec-title');
        t.innerHTML = 'تنظیمات در ' + ltr(d.id);
        host.appendChild(t);

        host.appendChild(toggleRow('قفل هنگام شروع', d.locked2, function (v) { d.locked2 = v; renderEditor(); }));
        host.appendChild(toggleRow('باز نگه‌داشتن', d.holdOpen, function (v) { d.holdOpen = v; renderEditor(); }));
        host.appendChild(toggleRow('قفل خودکار', d.autoLock, function (v) { d.autoLock = v; renderEditor(); }));

        if (d.autoLock) {
            host.appendChild(numRow('زمان قفل خودکار (ثانیه)', d.autoLockTime, '1', function (v) {
                d.autoLockTime = Math.max(1, Math.floor(Number(v) || 1));
                renderEditor();
            }));
        }

        host.appendChild(numRow('حداکثر فاصله (متر)', d.maxDistance, '0.1', function (v) {
            var n = Number(v) || 0;
            if (n < 0.5) n = 0.5;
            if (n > 20) n = 20;
            d.maxDistance = Math.round(n * 10) / 10;
            renderEditor();
        }));

        var ph = el('div', 'sec-head');
        ph.style.marginTop = '16px';
        var pt = el('div', 'sec-title');
        pt.textContent = 'دسترسی‌ها (شغل یا گنگ)';
        ph.appendChild(pt);

        var pacts = el('div', 'sec-acts');
        var copyPerm = el('button', 'mini-btn');
        copyPerm.textContent = 'کپی';
        copyPerm.onclick = function () { copyText(permsToJson(d.authorized), 'دسترسی‌ها'); };
        pacts.appendChild(copyPerm);
        ph.appendChild(pacts);
        host.appendChild(ph);

        if (d.authorized.length === 0) {
            var pe = el('div', 'hint');
            pe.textContent = 'لیست خالی است؛ فقط ادمین‌ها می‌توانند این در را باز کنند.';
            host.appendChild(pe);
        }

        for (var i = 0; i < d.authorized.length; i++) {
            (function (idx) {
                var p = d.authorized[idx];
                var row = el('div', 'perm-row');
                var nm = el('span', 'perm-name');
                nm.textContent = p.name;
                row.appendChild(nm);
                var gr = el('span', 'perm-grade');
                gr.innerHTML = ltr('grade ≥ ' + p.grade);
                row.appendChild(gr);
                var del = el('button', 'perm-del');
                del.textContent = '✕';
                del.onclick = function () {
                    d.authorized.splice(idx, 1);
                    state.jsonDirty = false;
                    renderEditor();
                };
                row.appendChild(del);
                host.appendChild(row);
            })(i);
        }

        var add = el('div', 'perm-add');
        var nameIn = el('input', 'search');
        nameIn.type = 'text';
        nameIn.placeholder = 'نام شغل یا گنگ';
        add.appendChild(nameIn);
        var gradeIn = el('input', 'num');
        gradeIn.type = 'number';
        gradeIn.min = '0';
        gradeIn.value = '0';
        add.appendChild(gradeIn);
        var addBtn = el('button', 'btn good small');
        addBtn.textContent = 'افزودن';
        var doAdd = function () {
            var nm = trim(nameIn.value);
            if (!nm) { toast('نام شغل یا گنگ را وارد کن'); return; }
            if (nm.length > 40) { toast('نام بیش از حد طولانی است'); return; }
            var g = Math.floor(Number(gradeIn.value) || 0);
            if (g < 0) { toast('گرید نمی‌تواند منفی باشد'); return; }
            state.jsonDirty = false;
            for (var k = 0; k < d.authorized.length; k++) {
                if (d.authorized[k].name === nm) { d.authorized[k].grade = g; renderEditor(); return; }
            }
            d.authorized.push({ name: nm, grade: g });
            renderEditor();
        };
        addBtn.onclick = doAdd;
        nameIn.addEventListener('keydown', function (e) { if (e.key === 'Enter') doAdd(); });
        gradeIn.addEventListener('keydown', function (e) { if (e.key === 'Enter') doAdd(); });
        add.appendChild(addBtn);
        host.appendChild(add);

        renderJsonBox(host, d);
        renderCoords(host, full);
        renderFoot(host, d);
    }

    function renderJsonBox(host, d) {
        if (!state.jsonDirty) state.jsonText = permsToJson(d.authorized);

        var jh = el('div', 'sec-head');
        jh.style.marginTop = '16px';
        var jt = el('div', 'sec-title');
        jt.textContent = 'ست کردن با JSON';
        jh.appendChild(jt);
        var jacts = el('div', 'sec-acts');
        var reset = el('button', 'mini-btn');
        reset.textContent = 'بازنشانی';
        reset.onclick = function () {
            state.jsonDirty = false;
            state.jsonText = permsToJson(d.authorized);
            renderEditor();
        };
        jacts.appendChild(reset);
        jh.appendChild(jacts);
        host.appendChild(jh);

        var ta = el('textarea', 'json-box');
        ta.value = state.jsonText;
        ta.spellcheck = false;
        ta.placeholder = '{"ambulance":0,"offambulance":0,"fbi":0,"offfbi":0}';
        ta.addEventListener('input', function () {
            state.jsonText = ta.value;
            state.jsonDirty = true;
        });
        host.appendChild(ta);

        var ja = el('div', 'json-acts');
        var apply = el('button', 'btn good small');
        apply.textContent = 'ست کردن';
        apply.onclick = function () {
            var res = parsePermJson(state.jsonText);
            if (res.err) { toast(res.err); return; }
            d.authorized = res.list;
            state.jsonDirty = false;
            renderEditor();
            toast(res.list.length + ' دسترسی ست شد · برای ثبت، ذخیره را بزن');
        };
        ja.appendChild(apply);
        host.appendChild(ja);

        var hint = el('div', 'hint');
        hint.textContent = 'کلید = نام شغل یا گنگ، مقدار = حداقل گرید. با «ست کردن» کل لیست بالا جایگزین می‌شود و تا زدن «ذخیره» چیزی روی سرور ثبت نمی‌شود.';
        host.appendChild(hint);
    }

    function renderCoords(host, full) {
        if (!full) return;
        var co = el('div', 'coords');
        var txt = el('div', 'coords-text');
        txt.innerHTML = 'مختصات: ' + ltr(full.coords) + '<br>وضعیت فعلی: ' + (full.locked ? 'قفل' : 'باز');
        co.appendChild(txt);
        var cb = el('button', 'mini-btn');
        cb.textContent = 'کپی';
        cb.onclick = function () { copyText(full.coords, 'مختصات'); };
        co.appendChild(cb);
        host.appendChild(co);
    }

    function renderFoot(host, d) {
        var foot = el('div', 'edit-foot');
        var save = el('button', 'btn primary');
        save.textContent = 'ذخیره';
        save.onclick = function () {
            send('save', {
                id: d.id,
                holdOpen: d.holdOpen,
                autoLock: d.autoLock,
                autoLockTime: d.autoLockTime,
                maxDistance: d.maxDistance,
                locked2: d.locked2,
                authorized: d.authorized
            });
            toast('ذخیره شد');
        };
        foot.appendChild(save);

        var del = el('button', 'btn danger');
        if (state.confirmDelete) {
            del.textContent = 'مطمئنی؟ حذف کن';
            del.onclick = function () {
                state.confirmDelete = false;
                state.selectedId = null;
                state.draft = null;
                send('delete', { id: d.id });
                toast('در حذف شد');
            };
        } else {
            del.textContent = 'حذف در';
            del.onclick = function () {
                state.confirmDelete = true;
                renderEditor();
                if (confirmTimer) clearTimeout(confirmTimer);
                confirmTimer = setTimeout(function () {
                    if (state.confirmDelete) { state.confirmDelete = false; renderEditor(); }
                }, 4000);
            };
        }
        foot.appendChild(del);
        host.appendChild(foot);
    }

    function renderHead() {
        document.getElementById('subtitle').textContent =
            state.doors.length + ' در ثبت‌شده · مرتب‌شده بر اساس ' + (state.sortBy === 'id' ? 'شناسه' : 'فاصله');
        document.getElementById('pickCount').textContent = state.pickCount;
        document.getElementById('pickWrap').className = 'pick-wrap' + (state.picking ? ' on' : '');
        document.getElementById('sortBtn').textContent = 'مرتب‌سازی: ' + (state.sortBy === 'id' ? 'شناسه' : 'فاصله');

        var gun = document.getElementById('gunBtn');
        gun.textContent = state.picking ? 'توقف حالت انتخاب' : 'حالت انتخاب با اسلحه';
        gun.className = 'btn ' + (state.picking ? 'on' : 'ghost');

        var addBtn = document.getElementById('addBtn');
        addBtn.className = 'btn primary' + (state.pickCount === 0 ? ' disabled' : '');
        addBtn.textContent = state.pickCount > 0 ? ('ثبت ' + state.pickCount + ' در انتخاب‌شده') : 'ثبت درهای انتخاب‌شده';

        document.getElementById('clearPickBtn').className = 'btn ghost' + (state.pickCount === 0 ? ' disabled' : '');

        var co = document.getElementById('clearOutlineBtn');
        co.className = 'btn ghost' + (state.outlinedCount === 0 ? ' disabled' : '');
        co.textContent = state.outlinedCount > 0
            ? ('پاک کردن ' + state.outlinedCount + ' هایلایت')
            : 'پاک کردن هایلایت‌ها';
    }

    function render() {
        renderHead();
        renderList();
        renderEditor();
    }

    function applyData(p) {
        state.doors = p.doors || [];
        state.picking = !!p.picking;
        state.pickCount = Number(p.pickCount) || 0;
        state.outlinedCount = Number(p.outlinedCount) || 0;
        if (state.selectedId !== null && !findDoor(state.selectedId)) {
            state.selectedId = null;
            state.draft = null;
        }
        document.getElementById('overlay').className = 'overlay';
        render();
    }

    function handleUpdate(p) {
        if (!p) return;
        if (p.type === 'notify') { toast(p.message); return; }
        if (p.type === 'data') { applyData(p.data || {}); return; }
        if (p.type === 'pick') {
            state.picking = !!p.picking;
            state.pickCount = Number(p.pickCount) || 0;
            renderHead();
            return;
        }
    }

    window.addEventListener('message', function (e) {
        var m = e.data;
        if (!m) return;
        if (m.type === 'initData') applyData(m.data || {});
        else if (m.type === 'updateData') handleUpdate(m.data || {});
    });

    document.addEventListener('DOMContentLoaded', function () {
        document.getElementById('closeBtn').onclick = function () { send('close', {}); };

        document.getElementById('search').addEventListener('input', function (e) {
            state.search = trim(e.target.value);
            renderList();
        });

        document.getElementById('sortBtn').onclick = function () {
            state.sortBy = state.sortBy === 'dist' ? 'id' : 'dist';
            renderHead();
            renderList();
        };

        document.getElementById('gunBtn').onclick = function () {
            send('togglePick', {});
        };

        document.getElementById('addBtn').onclick = function () {
            if (state.pickCount === 0) { toast('اول با اسلحه چند در را انتخاب کن'); return; }
            send('addDoors', {});
        };

        document.getElementById('clearPickBtn').onclick = function () {
            if (state.pickCount === 0) return;
            send('clearPick', {});
        };

        document.getElementById('clearOutlineBtn').onclick = function () {
            if (state.outlinedCount === 0) return;
            send('clearOutlines', {});
        };

        document.addEventListener('keydown', function (e) {
            if (e.key === 'Escape' || e.keyCode === 27) send('close', {});
        });
    });
})();
