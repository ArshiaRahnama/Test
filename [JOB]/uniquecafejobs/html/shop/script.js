const RESOURCE = 'uniquecafejobs';

const panel = document.getElementById('panel');
const itemsGrid = document.getElementById('itemsGrid');
const basketList = document.getElementById('basketList');
const totalsCount = document.getElementById('totalsCount');
const totalsAmt = document.getElementById('totalsAmt');
const checkoutBtn = document.getElementById('checkoutBtn');
const exitBtn = document.getElementById('exitBtn');

let catalog = { drinks: [], desserts: [] };
let iconBase = 'nui://ox_inventory/web/images/';
let activeTab = 'drinks';
let cart = {}; // value -> { item, qty }

function money(n) { return '$' + Number(n).toLocaleString(); }

function renderTabs() {
  document.querySelectorAll('.tab').forEach(t => {
    t.classList.toggle('active', t.dataset.tab === activeTab);
  });
}

function renderItems() {
  itemsGrid.innerHTML = '';
  const list = catalog[activeTab] || [];
  for (const item of list) {
    const card = document.createElement('div');
    card.className = 'item-card';
    card.innerHTML = `
      <img class="item-img" src="${iconBase}${item.value}.png" onerror="this.style.visibility='hidden'">
      <div class="item-name">${item.title}</div>
      <div class="item-price-row">
        <span class="price-pill">${money(item.price)}</span>
        <button class="add-btn">+</button>
      </div>`;
    card.querySelector('.add-btn').addEventListener('click', () => addToCart(item));
    itemsGrid.appendChild(card);
  }
}

function addToCart(item) {
  if (!cart[item.value]) cart[item.value] = { item, qty: 0 };
  cart[item.value].qty += 1;
  renderCart();
}

function removeFromCart(value) {
  if (!cart[value]) return;
  cart[value].qty -= 1;
  if (cart[value].qty <= 0) delete cart[value];
  renderCart();
}

function renderCart() {
  const entries = Object.values(cart);
  basketList.innerHTML = '';

  if (entries.length === 0) {
    basketList.innerHTML = '<div class="basket-empty">Cart is empty</div>';
  }

  let total = 0;
  let count = 0;

  for (const { item, qty } of entries) {
    total += item.price * qty;
    count += qty;

    const row = document.createElement('div');
    row.className = 'basket-row';
    row.innerHTML = `
      <span>${item.title}</span>
      <span class="qty">${qty}x</span>
      <span class="p">${money(item.price * qty)}</span>
      <span class="rm">✕</span>`;
    row.querySelector('.rm').addEventListener('click', () => removeFromCart(item.value));
    basketList.appendChild(row);
  }

  totalsCount.textContent = `${count} item${count === 1 ? '' : 's'}`;
  totalsAmt.textContent = money(total);
  checkoutBtn.disabled = count === 0;
}

document.querySelectorAll('.tab').forEach(t => {
  t.addEventListener('click', () => {
    activeTab = t.dataset.tab;
    renderTabs();
    renderItems();
  });
});

function closeShop() {
  panel.classList.remove('open');
  cart = {};
  renderCart();
  fetch(`https://${RESOURCE}/shopClose`, {
    method: 'POST', headers: { 'Content-Type': 'application/json' }, body: '{}'
  });
}

exitBtn.addEventListener('click', closeShop);

document.addEventListener('keyup', (e) => {
  if (e.key === 'Escape' && panel.classList.contains('open')) closeShop();
});

checkoutBtn.addEventListener('click', () => {
  const cartPayload = Object.values(cart).map(({ item, qty }) => ({ value: item.value, qty }));
  if (cartPayload.length === 0) return;

  checkoutBtn.disabled = true;
  fetch(`https://${RESOURCE}/shopCheckout`, {
    method: 'POST', headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ cart: cartPayload })
  });
});

window.addEventListener('message', (event) => {
  const data = event.data;
  if (!data) return;

  if (data.open) {
    catalog.drinks = data.drinks || [];
    catalog.desserts = data.desserts || [];
    iconBase = data.iconBase || iconBase;
    activeTab = data.defaultTab || 'drinks';
    cart = {};
    renderTabs();
    renderItems();
    renderCart();
    panel.classList.add('open');
  }

  if (data.result) {
    if (data.success) {
      cart = {};
      renderCart();
      closeShop();
    } else {
      checkoutBtn.disabled = false;
    }
  }
});
