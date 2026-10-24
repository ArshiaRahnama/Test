// Holding purchase page. Talks to Lua through Unique_ALLGangs callbacks.
(function(){
  var RES = 'Unique_ALLGangs';
  var state = { list: [], rules: null };

  function post(name, data){ return fetch('https://'+RES+'/'+name, {method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify(data||{})}).then(function(r){return r.json();}).catch(function(){return null;}); }
  function esc(s){ return String(s==null?'':s).replace(/[&<>"']/g, function(c){return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c];}); }
  function fmt(n){ return Number(n||0).toLocaleString('en-US'); }
  function days(ts){ var d = Math.floor((ts - Date.now()/1000)/86400); return d<0?0:d; }
  function hours(ts){ var h = Math.floor((ts - Date.now()/1000)/3600); return h<0?0:h; }
  function toast(msg){ var t=document.getElementById('toast'); t.textContent=msg; t.style.display='block'; clearTimeout(t._h); t._h=setTimeout(function(){t.style.display='none';},3000); }

  function card(h){
    var status, cls = '';
    if (h.open && h.window) { status = '<span class="badge gold">هفته‌ی آخر - درخواست باز</span>'; cls = 'is-window'; }
    else if (h.open)        { status = '<span class="badge gold">مزایده‌ی آزاد</span>'; cls = 'is-free'; }
    else if (h.owner)       { status = '<span class="badge">مالک: '+esc(h.owner)+'</span>'; }
    else                    { status = '<span class="badge green">آزاد</span>'; cls = 'is-free'; }

    var lines = '';
    if (h.owner) lines += '<div class="row"><span>قیمت خرید</span><span>$'+fmt(h.price)+'</span></div>'
                        + '<div class="row"><span>مهلت مالکیت</span><span>'+days(h.expires)+' روز</span></div>';
    if (h.open) lines += '<div class="row"><span>زمان باقی‌مانده</span><span>'+hours(h.endsAt)+' ساعت</span></div>';
    if (h.top)  lines += '<div class="row"><span>بالاترین پیشنهاد</span><span>'+esc(h.top.gang)+' - $'+fmt(h.top.amount)+'</span></div>';
    if (!h.open && h.owner && h.lockUntil) lines += '<div class="row"><span>درخواست‌ها از</span><span>'+days(h.lockUntil)+' روز دیگر</span></div>';

    var biz = (h.businesses||[]).map(function(b){ return '<span class="chip">'+esc(b)+'</span>'; }).join('');

    var action = '';
    if (h.open) {
      var min = h.minBid || 0;
      action = '<div class="bid"><input type="number" min="'+min+'" value="'+min+'" data-key="'+esc(h.key)+'" class="amount" /><button class="btn bid-btn" data-key="'+esc(h.key)+'">'+(h.window?'ثبت درخواست':'ثبت پیشنهاد')+'</button></div>'
              + '<div class="row"><span>حداقل</span><span>$'+fmt(min)+'</span></div>';
    }

    return '<article class="card '+cls+'"><h2>'+esc(h.label)+' '+status+'</h2>'+lines+
           '<div class="biz">'+biz+'</div>'+action+'</article>';
  }

  function render(){
    var box = document.getElementById('holdings');
    box.innerHTML = state.list.map(card).join('');
  }

  function show(tab){
    document.querySelectorAll('.tab').forEach(function(b){ b.classList.toggle('is-active', b.dataset.tab===tab); });
    document.getElementById('holdings').classList.toggle('hidden', tab!=='holdings');
    document.getElementById('rules').classList.toggle('hidden', tab!=='rules');
  }

  window.addEventListener('message', function(event){
    var d = event.data || {};
    if (d.type === 'open') {
      state.list = d.list || [];
      document.getElementById('me-gang').textContent = d.gang ? ('گنگ شما: '+d.gang) : 'گنگ شما';
      document.getElementById('app').classList.remove('hidden');
      show('holdings'); render();
    }
    if (d.type === 'close') {
      document.getElementById('app').classList.add('hidden');
    }
    if (d.type === 'refresh') { state.list = d.list || []; render(); }
  });

  document.addEventListener('click', function(e){
    var t = e.target;
    if (t.classList && t.classList.contains('tab')) show(t.dataset.tab);
    if (t.id === 'close') post('holding_close');
    if (t.classList && t.classList.contains('bid-btn')) {
      var key = t.dataset.key;
      var input = document.querySelector('input.amount[data-key="'+key+'"]');
      var amount = parseInt(input.value, 10);
      if (!amount) return toast('مبلغ معتبر وارد کنید.');
      post('holding_bid', {key: key, amount: amount}).then(function(res){
        toast(res && res.msg ? res.msg : 'خطا');
        if (res && res.list) { state.list = res.list; render(); }
      });
    }
  });
  document.addEventListener('keyup', function(e){ if (e.key === 'Escape') post('holding_close'); });
  var toastEl = document.createElement('div'); toastEl.id='toast'; toastEl.className='toast'; document.body.appendChild(toastEl);
})();
