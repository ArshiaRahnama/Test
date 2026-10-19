// Auction House UI. Talks to Lua with ids only; the server checks everything.
(function () {
  var RES = 'Unique_ALLGangs';
  var state = { tab: 'shop', shop: null, canSell: false, sItems: [], mItems: [], sellItems: [], search: '' };

  var ICON = {
    crown: '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M3 8l4.5 4L12 5l4.5 7L21 8l-2 11H5L3 8Z"/></svg>',
    coin: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round"><circle cx="12" cy="12" r="9"/><path d="M14.5 9a2.6 2.6 0 0 0-2.5-1.5c-1.5 0-2.5.8-2.5 2s1 1.7 2.5 2 2.5.8 2.5 2-1 2-2.5 2A2.7 2.7 0 0 1 9.5 14.5M12 6v1.5M12 16.5V18"/></svg>',
    trash: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18M8 6V4h8v2M19 6l-1 14H6L5 6M10 11v6M14 11v6"/></svg>'
  };
  var NOIMG = 'data:image/svg+xml;utf8,' + encodeURIComponent('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 96 96"><rect x="14" y="30" width="68" height="36" rx="8" fill="none" stroke="#8f6f12" stroke-width="3" stroke-dasharray="6 5"/><path d="M34 48h28" stroke="#8f6f12" stroke-width="3" stroke-linecap="round"/></svg>');

  function pretty(item) {
    var l = item.label || item.name;
    if (/^WEAPON_/i.test(l)) {
      l = l.replace(/^WEAPON_/i, '').replace(/_/g, ' ').toLowerCase().replace(/\b\w/g, function (c) { return c.toUpperCase(); });
    }
    return l;
  }
  function isWeapon(name) { return /^WEAPON_/i.test(name || ''); }

  function post(name, data) {
    return $.post('https://' + RES + '/' + name, JSON.stringify(data || {}));
  }

  function toast(text, kind) {
    var $t = $('<div></div>').addClass(kind || '').text(text);
    $('#toast').append($t);
    setTimeout(function () { $t.fadeOut(300, function () { $t.remove(); }); }, 3200);
  }

  function list() { return state.tab === 'mine' ? state.mItems : state.sItems; }

  function setCounts() {
    $('#cnt-shop, #st-shop').text(state.sItems.length);
    $('#cnt-mine, #st-mine').text(state.mItems.length);
    $('#ah-sub').text(state.shop ? (state.shop.label + (state.shop.owner ? ' - ' + state.shop.owner : '')) : 'No gun shop here');
    $('#btn-sell').toggleClass('hidden', !state.canSell);
  }

  function card(item, mine) {
    var $c = $('<article class="ah-card"></article>')
      .attr('data-id', item.id).toggleClass('is-mine', !!mine);
    if (mine) $c.append($('<span class="ah-tag"></span>').append($('<span class="ic"></span>').html(ICON.crown), document.createTextNode('Yours')));
    $c.append($('<span class="ah-price"></span>').text('$' + Number(item.price).toLocaleString()));
    var $img = $('<img class="ah-img" />').attr('src', './img/' + item.name + '.png');
    $img.on('error', function () { $(this).off('error').attr('src', NOIMG).css('opacity', .55); });
    $c.append($img);
    $c.append($('<div class="ah-name"></div>').text(pretty(item)));
    $c.append($('<div class="ah-qty"></div>').text('x' + Number(item.amount).toLocaleString()));
    if (mine) {
      $c.append($('<button class="ah-btn remove"></button>').append($('<span class="ic"></span>').html(ICON.trash), $('<span></span>').text('Remove')));
    } else {
      $c.append($('<button class="ah-btn buy"></button>').append($('<span class="ic"></span>').html(ICON.coin), $('<span></span>').text('Buy')));
    }
    return $c;
  }

  function render() {
    var q = $.trim(state.search).toLowerCase();
    var items = list().filter(function (i) {
      return !q || pretty(i).toLowerCase().indexOf(q) !== -1;
    });
    var $grid = $('#grid').empty();
    items.forEach(function (i, idx) {
      var $c = card(i, !!i.mine);
      $c.css('animation-delay', (idx * 25) + 'ms');
      $grid.append($c);
    });
    $('.ah-tab').removeClass('is-active').filter('[data-tab="' + state.tab + '"]').addClass('is-active');
    var empty = items.length === 0;
    $('#empty').toggleClass('hidden', !empty);
    $('#empty-text').text(
      !state.shop ? 'Stand at a gun shop with an owner to use the auction house.' :
      state.tab === 'mine' ? "You haven't listed anything here." :
      'Nothing for sale right now.'
    );
    setCounts();
  }

  function open(on) {
    $('#ah').toggleClass('hidden', !on);
    if (!on) $('#sell-modal').addClass('hidden');
  }

  window.addEventListener('message', function (event) {
    var d = event.data || {};
    if (d.ui === 'openui') open(true);
    if (d.ui === 'closeui') open(false);
    if (d.shop === 'refresh') {
      state.sItems = d.sItems || [];
      state.mItems = d.mItems || [];
      state.shop = d.shop_info || state.shop;
      if (d.shopInfo) state.shop = d.shopInfo;
      state.canSell = !!d.canSell;
      render();
    }
    if (d.shop === 'sellitems') {
      state.sellItems = d.items || [];
      var $sel = $('#sell-item').empty();
      state.sellItems.forEach(function (it, idx) {
        $sel.append($('<option></option>').val(idx).text(pretty(it) + '  (x' + it.amount + ')'));
      });
    }
  });

  $(function () {
    $('.ah-tab').on('click', function () { state.tab = $(this).data('tab'); render(); });
    $('#search').on('input', function () { state.search = this.value; render(); });
    $('#btn-close').on('click', function () { post('CloseUi'); });

    $('#btn-sell').on('click', function () {
      $('#sell-amount').val(1); $('#sell-price').val(100); $('#sell-discord').prop('checked', false);
      $('#sell-modal').removeClass('hidden');
      $('#sell-item').trigger('change');
    });
    $('#sell-item').on('change', function () {
      var it = state.sellItems[$(this).val()];
      var weapon = it && isWeapon(it.name);
      $('#sell-amount').prop('disabled', !!weapon).val(weapon ? it.amount : 1);
    });
    $('#sell-cancel').on('click', function () { $('#sell-modal').addClass('hidden'); });
    $('#sell-confirm').on('click', function () {
      var it = state.sellItems[$('#sell-item').val()];
      if (!it) return toast('Choose an item to list.', 'bad');
      var amount = parseInt($('#sell-amount').val(), 10);
      var price = parseInt($('#sell-price').val(), 10);
      if (!(amount > 0)) return toast('Amount must be at least 1.', 'bad');
      if (!(price > 0)) return toast('Price must be at least $1.', 'bad');
      if (amount > it.amount) return toast('You only have ' + it.amount + '.', 'bad');
      post('AddItemToShop', { item: it.name, amount: amount, price: price, discord: $('#sell-discord').is(':checked') });
      $('#sell-modal').addClass('hidden');
    });

    $('#grid').on('click', '.ah-btn.buy', function () {
      var $c = $(this).closest('.ah-card').addClass('is-busy');
      post('BuyItemFromShop', { id: $c.data('id') });
    });
    $('#grid').on('click', '.ah-btn.remove', function () {
      var $c = $(this).closest('.ah-card').addClass('is-busy');
      post('RemoveItemFromShop', { id: $c.data('id') });
    });

    $(document).on('keyup', function (e) {
      if (e.key === 'Escape') {
        if (!$('#sell-modal').hasClass('hidden')) $('#sell-modal').addClass('hidden');
        else post('CloseUi');
      }
    });
    open(false);
  });
})();
