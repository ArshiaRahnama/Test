(function () {
  'use strict';

  var state = {
    isAdmin: false,
    categories: [], priorities: [], statuses: [],
    tickets: [],
    current: null,       // full detail of the open ticket
    filterStatus: 'all',
    filterMine: false,
  };

  var $ = function (id) { return document.getElementById(id); };

  // ----------------------------------------------------------- NUI bridge --
  function post(action, data) {
    return fetch('https://Unique_AdminPanel/' + action, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify(data || {}),
    }).then(function (r) { return r.json(); }).catch(function () { return { r: false }; });
  }

  window.addEventListener('message', function (event) {
    var data = event.data || {};
    if (!data._uniqueTicket) return;

    if (data.uticket === 'open') {
      state.isAdmin = !!data.admin;
      $('app').classList.remove('hidden');
      $('adminTabs').classList.toggle('hidden', !state.isAdmin);
      $('fromReportBox').classList.toggle('hidden', !state.isAdmin);
      loadConfig().then(refreshList);
    } else if (data.uticket === 'close') {
      $('app').classList.add('hidden');
      closeAllModals();
    } else if (data.uticket === 'live') {
      if (state.current && state.current.ticket.id === data.id) {
        applyDetail(data.detail);
      }
      refreshList();
    }
  });

  document.addEventListener('keydown', function (e) {
    if (e.key !== 'Escape') return;
    if (!$('modalBackdrop').classList.contains('hidden')) { closeAllModals(); return; }
    post('exit');
    $('app').classList.add('hidden');
  });

  // --------------------------------------------------------------- config --
  function loadConfig() {
    return post('config').then(function (res) {
      state.categories = res.categories || [];
      state.priorities = res.priorities || [];
      state.statuses = res.statuses || [];

      var catSel = $('newCategory');
      catSel.innerHTML = state.categories.map(function (c) {
        return '<option value="' + c.id + '">' + c.icon + ' ' + c.label + '</option>';
      }).join('');

      var statusSel = $('statusSelect');
      statusSel.innerHTML = state.statuses.map(function (s) {
        return '<option value="' + s.id + '">' + s.label + '</option>';
      }).join('');
    });
  }

  function statusLabel(id) {
    var s = state.statuses.filter(function (x) { return x.id === id; })[0];
    return s ? s.label : id;
  }
  function categoryLabel(id) {
    var c = state.categories.filter(function (x) { return x.id === id; })[0];
    return c ? (c.icon + ' ' + c.label) : id;
  }

  // ------------------------------------------------------------ list load --
  function refreshList() {
    var call = state.isAdmin
      ? post('getAll', { status: state.filterStatus, mine: state.filterMine })
      : post('getMine');

    call.then(function (res) {
      state.tickets = (res && res.data) || [];
      renderList();
    });
  }

  function renderList() {
    var host = $('ticketList');
    if (!state.tickets.length) {
      host.innerHTML = '<div class="pick-empty">تیکتی وجود ندارد.</div>';
      return;
    }
    host.innerHTML = state.tickets.map(function (t) {
      var active = state.current && state.current.ticket.id === t.id ? ' active' : '';
      return (
        '<div class="ticket-card status-' + t.status + active + '" data-id="' + t.id + '">' +
          '<div class="tc-top">' +
            '<span class="tc-title">#' + t.id + ' - ' + escapeHtml(t.title) + '</span>' +
            '<span class="status-dot"></span>' +
          '</div>' +
          '<div class="tc-meta"><span>' + categoryLabel(t.category) + '</span><span>' + escapeHtml(t.creator.name || '') + '</span></div>' +
        '</div>'
      );
    }).join('');

    Array.prototype.forEach.call(host.querySelectorAll('.ticket-card'), function (el) {
      el.addEventListener('click', function () { openTicket(parseInt(el.dataset.id, 10)); });
    });
  }

  $('adminTabs').addEventListener('click', function (e) {
    var btn = e.target.closest('.tab');
    if (!btn) return;
    Array.prototype.forEach.call($('adminTabs').querySelectorAll('.tab'), function (b) { b.classList.remove('active'); });
    btn.classList.add('active');
    if (btn.dataset.mine) {
      state.filterMine = true; state.filterStatus = 'all';
    } else {
      state.filterMine = false; state.filterStatus = btn.dataset.status;
    }
    refreshList();
  });

  // ---------------------------------------------------------------- open --
  function openTicket(id) {
    post('getDetail', { id: id }).then(function (res) {
      if (!res || !res.r) return;
      applyDetail(res);
      $('emptyState').classList.add('hidden');
      $('ticketView').classList.remove('hidden');
      renderList();
    });
  }

  function applyDetail(detail) {
    state.current = detail;
    var t = detail.ticket;

    $('dTitle').textContent = '#' + t.id + ' - ' + t.title;
    $('dStatus').textContent = statusLabel(t.status);
    $('dStatus').className = 'badge st-' + t.status;
    $('dCategory').textContent = categoryLabel(t.category);
    $('dCreator').textContent = t.creator.name || '-';
    $('dId').textContent = t.sourceReportId ? ('از گزارش #' + t.sourceReportId) : '';

    $('adminControls').classList.toggle('hidden', !state.isAdmin);
    $('statusSelect').value = t.status;

    $('participantChips').innerHTML = (detail.participants || []).map(function (p) {
      return '<span class="chip">' + escapeHtml(p.name || p.identifier) + '</span>';
    }).join('') || '<span class="chip">—</span>';

    $('adminChips').innerHTML = (detail.admins || []).map(function (a) {
      return '<span class="chip admin-chip">🛡️ ' + escapeHtml(a.name || a.identifier) + '</span>';
    }).join('') || '<span class="chip">—</span>';

    renderThread(detail.messages || []);
  }

  function renderThread(messages) {
    var host = $('thread');
    host.innerHTML = messages.map(function (m) {
      if (m.is_system) {
        return '<div class="msg system">' + escapeHtml(m.message) + '</div>';
      }
      var cls = m.is_admin ? 'from-admin' : 'from-player';
      return (
        '<div class="msg ' + cls + '">' +
          '<div class="m-meta">' + escapeHtml(m.name || '') + (m.is_admin ? ' 🛡️' : '') + '</div>' +
          escapeHtml(m.message) +
        '</div>'
      );
    }).join('');
    host.scrollTop = host.scrollHeight;
  }

  $('statusSelect').addEventListener('change', function () {
    if (!state.current) return;
    post('setStatus', { id: state.current.ticket.id, status: this.value });
  });

  $('replyForm').addEventListener('submit', function (e) {
    e.preventDefault();
    var input = $('replyInput');
    var text = input.value.trim();
    if (!text || !state.current) return;
    post('sendMessage', { id: state.current.ticket.id, text: text }).then(function (res) {
      if (res && res.r) input.value = '';
    });
  });

  // ------------------------------------------------------------ new ticket --
  $('btnNew').addEventListener('click', function () { openModal('modalNew'); });
  $('btnSubmitNew').addEventListener('click', function () {
    var title = $('newTitle').value.trim();
    var message = $('newMessage').value.trim();
    if (!title || !message) return toast('عنوان و توضیحات را کامل کنید.');
    post('create', { title: title, category: $('newCategory').value, message: message }).then(function (res) {
      if (res && res.r) {
        $('newTitle').value = ''; $('newMessage').value = '';
        closeAllModals();
        refreshList();
        toast('تیکت #' + res.id + ' ثبت شد.');
      } else {
        toast((res && res.msg) || 'خطا در ثبت تیکت.');
      }
    });
  });

  // ------------------------------------------------------- from a report --
  $('btnFromReport').addEventListener('click', function () {
    openModal('modalFromReport');
    post('listOpenReports').then(function (res) {
      var host = $('reportList');
      var list = (res && res.data) || [];
      if (!list.length) { host.innerHTML = '<div class="pick-empty">هیچ گزارش بازی وجود ندارد.</div>'; return; }
      host.innerHTML = list.map(function (r) {
        return (
          '<div class="pick-row">' +
            '<div><div>#' + r.id + ' - ' + escapeHtml(r.category || '-') + '</div>' +
            '<div class="pr-sub">' + escapeHtml(r.owner) + ' - ' + escapeHtml((r.detail || '').slice(0, 60)) + '</div></div>' +
            '<button class="btn btn-sm btn-accent" data-report="' + r.id + '">ساخت تیکت</button>' +
          '</div>'
        );
      }).join('');
      Array.prototype.forEach.call(host.querySelectorAll('[data-report]'), function (btn) {
        btn.addEventListener('click', function () {
          post('createFromReport', { reportId: btn.dataset.report }).then(function (res2) {
            if (res2 && res2.r) {
              closeAllModals(); refreshList(); openTicket(res2.id);
              toast('تیکت #' + res2.id + ' از گزارش ساخته شد.');
            } else {
              toast((res2 && res2.msg) || 'خطا.');
            }
          });
        });
      });
    });
  });

  // ------------------------------------------------------------- players --
  $('btnManagePlayers').addEventListener('click', function () {
    openModal('modalPlayers');
    $('playerSearch').value = '';
    $('playerResults').innerHTML = '';
    renderCurrentParticipants();
  });

  var searchDebounce = null;
  $('playerSearch').addEventListener('input', function () {
    clearTimeout(searchDebounce);
    var q = this.value.trim();
    searchDebounce = setTimeout(function () {
      if (q.length < 2) { $('playerResults').innerHTML = ''; return; }
      post('searchPlayer', { query: q }).then(function (res) {
        var list = (res && res.data) || [];
        var host = $('playerResults');
        if (!list.length) { host.innerHTML = '<div class="pick-empty">نتیجه‌ای نبود.</div>'; return; }
        host.innerHTML = list.map(function (p) {
          return (
            '<div class="pick-row">' +
              '<div>' + escapeHtml(p.name) + (p.online ? ' 🟢' : '') + '</div>' +
              '<button class="btn btn-sm btn-accent" data-add-player="' + p.identifier + '" data-name="' + escapeHtml(p.name) + '">افزودن</button>' +
            '</div>'
          );
        }).join('');
        Array.prototype.forEach.call(host.querySelectorAll('[data-add-player]'), function (btn) {
          btn.addEventListener('click', function () {
            post('addParticipant', { id: state.current.ticket.id, identifier: btn.dataset.addPlayer, name: btn.dataset.name })
              .then(function () { renderCurrentParticipants(); });
          });
        });
      });
    }, 300);
  });

  function renderCurrentParticipants() {
    var host = $('playerCurrent');
    var list = (state.current && state.current.participants) || [];
    if (!list.length) { host.innerHTML = '<div class="pick-empty">هنوز بازیکنی اضافه نشده.</div>'; return; }
    host.innerHTML = list.map(function (p) {
      return (
        '<div class="pick-row">' +
          '<div>' + escapeHtml(p.name || p.identifier) + ' <span class="pr-sub">(' + p.role + ')</span></div>' +
          (p.role !== 'creator' ? '<button class="btn btn-sm btn-danger" data-remove-player="' + p.identifier + '">حذف</button>' : '') +
        '</div>'
      );
    }).join('');
    Array.prototype.forEach.call(host.querySelectorAll('[data-remove-player]'), function (btn) {
      btn.addEventListener('click', function () {
        post('removeParticipant', { id: state.current.ticket.id, identifier: btn.dataset.removePlayer })
          .then(function () { renderCurrentParticipants(); });
      });
    });
  }

  // -------------------------------------------------------------- admins --
  $('btnManageAdmins').addEventListener('click', function () {
    openModal('modalAdmins');
    post('getOnlineAdmins').then(function (res) {
      var list = (res && res.data) || [];
      var host = $('adminOnlineList');
      if (!list.length) { host.innerHTML = '<div class="pick-empty">ادمین آنلاینی نیست.</div>'; return; }
      host.innerHTML = list.map(function (a) {
        return (
          '<div class="pick-row">' +
            '<div>' + escapeHtml(a.name) + '</div>' +
            '<button class="btn btn-sm btn-accent" data-add-admin="' + a.identifier + '" data-name="' + escapeHtml(a.name) + '">افزودن به تیکت</button>' +
          '</div>'
        );
      }).join('');
      Array.prototype.forEach.call(host.querySelectorAll('[data-add-admin]'), function (btn) {
        btn.addEventListener('click', function () {
          post('assignAdmin', { id: state.current.ticket.id, identifier: btn.dataset.addAdmin, name: btn.dataset.name })
            .then(function () { renderCurrentAdmins(); });
        });
      });
    });
    renderCurrentAdmins();
  });

  function renderCurrentAdmins() {
    var host = $('adminCurrent');
    var list = (state.current && state.current.admins) || [];
    if (!list.length) { host.innerHTML = '<div class="pick-empty">هنوز ادمینی مسئول این تیکت نیست.</div>'; return; }
    host.innerHTML = list.map(function (a) {
      return (
        '<div class="pick-row">' +
          '<div>🛡️ ' + escapeHtml(a.name || a.identifier) + '</div>' +
          '<button class="btn btn-sm btn-danger" data-remove-admin="' + a.identifier + '">حذف</button>' +
        '</div>'
      );
    }).join('');
    Array.prototype.forEach.call(host.querySelectorAll('[data-remove-admin]'), function (btn) {
      btn.addEventListener('click', function () {
        post('unassignAdmin', { id: state.current.ticket.id, identifier: btn.dataset.removeAdmin })
          .then(function () { renderCurrentAdmins(); });
      });
    });
  }

  // -------------------------------------------------------------- modals --
  function openModal(id) {
    $('modalBackdrop').classList.remove('hidden');
    Array.prototype.forEach.call(document.querySelectorAll('.modal'), function (m) { m.classList.add('hidden'); });
    $(id).classList.remove('hidden');
  }
  function closeAllModals() {
    $('modalBackdrop').classList.add('hidden');
    Array.prototype.forEach.call(document.querySelectorAll('.modal'), function (m) { m.classList.add('hidden'); });
  }
  $('modalBackdrop').addEventListener('click', function (e) { if (e.target === this) closeAllModals(); });
  Array.prototype.forEach.call(document.querySelectorAll('[data-close]'), function (btn) {
    btn.addEventListener('click', closeAllModals);
  });

  // --------------------------------------------------------------- toast --
  function toast(msg) {
    var el = document.createElement('div');
    el.className = 'toast';
    el.textContent = msg;
    $('toastHost').appendChild(el);
    setTimeout(function () { el.remove(); }, 4000);
  }

  function escapeHtml(s) {
    return String(s == null ? '' : s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }
})();
