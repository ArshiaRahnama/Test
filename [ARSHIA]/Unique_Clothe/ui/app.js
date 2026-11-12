// Item pictures are optional: drop PNGs in ui/items/clothes/<category>/<item_name>.png
// (e.g. ui/items/clothes/tshirt/tshirt_m_12_0.png). Missing pictures fall back to the category icon.
const RESOURCE = (typeof GetParentResourceName === 'function') ? GetParentResourceName() : 'Unique_clothe';
const imageServer = '/ui/items';

document.addEventListener('dragstart', (e) => e.preventDefault());
document.addEventListener('drop', (e) => e.preventDefault());
document.addEventListener('dragover', (e) => e.preventDefault());
document.addEventListener('contextmenu', (e) => e.preventDefault());

let categories = [];
let currentCategory = null;
let items = [];
let selectedItem = null;
let selectedColor = null;
let colorVariants = [];
let cart = [];
let isCartOpen = false;

const categoryLabels = {
    'tshirt': 'تی‌شرت',
    'torso': 'لباس',
    'pants': 'شلوار',
    'shoes': 'کفش',
    'mask': 'ماسک',
    'bproof': 'جلیقه',
    'chain': 'گردنبند',
    'helmet': 'کلاه',
    'glasses': 'عینک',
    'watches': 'ساعت',
    'bracelets': 'دستبند',
    'bag': 'کیف',
    'ears': 'گوشواره',
    'arms': 'دستکش'
};

const allClothingCategories = [
    'tshirt', 'torso', 'pants', 'shoes', 'mask',
    'bproof', 'chain', 'helmet', 'glasses', 'watches',
    'bracelets', 'bag', 'ears', 'arms'
];

let checkoutPending = false;

window.addEventListener('message', function(event) {
    const data = event.data;

    if (data.display) {
        showShop(data.category);
    }

    if (data.hide) {
        document.getElementById('app').classList.add('hidden');
        resetState();
    }

    if (data.loadClothe) {
        renderItems(data.loadClothe.data, data.loadClothe.type);
    }

    if (data.loadColor) {
        renderColors(data.loadColor);
    }

    if (data.notification) {
        showNotification(data.notification.message, data.notification.type);
        handleCheckoutResult(data.notification.type === 'success' || data.notification.type === 'info', data.purchasedItems);
    }
});

function showNotification(message, type = 'info') {
    const container = document.getElementById('notificationContainer');
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    notification.textContent = message;
    container.appendChild(notification);

    setTimeout(() => {
        notification.classList.add('fade-out');
        setTimeout(() => {
            notification.remove();
        }, 300);
    }, 3000);
}

function handleCheckoutResult(success, purchasedItems) {
    if (!checkoutPending) return;
    checkoutPending = false;

    if (checkoutTimeout) {
        clearTimeout(checkoutTimeout);
        checkoutTimeout = null;
    }

    const checkoutBtn = document.getElementById('checkoutBtn');
    checkoutBtn.innerHTML = 'تکمیل خرید';

    if (success) {
        if (purchasedItems) {
            cart = cart.filter(item => !purchasedItems[item.name]);
        } else {
            cart = [];
        }
        updateCartUI();
        renderCartItems();
        updateAddToCartButton();
        if (cart.length === 0) {
            toggleCart();
            checkoutBtn.disabled = true;
        } else {
            checkoutBtn.disabled = false;
        }
    } else {
        checkoutBtn.disabled = false;
    }
}

document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        if (isCartOpen) {
            toggleCart();
        } else {
            closeShop();
        }
    }
    if (e.key === 'ArrowLeft') {
        rotatePlayer(-1);
    }
    if (e.key === 'ArrowRight') {
        rotatePlayer(1);
    }
});

function showShop(categoryList) {
    categories = categoryList;
    cart = [];
    clothingStates = {};
    document.getElementById('app').classList.remove('hidden');
    renderCategories();
    renderClothingToolbar();
    clearItems();
    hideColorsPanel();
    updateCartUI();
}

function closeShop() {
    document.getElementById('app').classList.add('hidden');
    fetch(`https://${RESOURCE}/close`, {
        method: 'POST',
        body: JSON.stringify({})
    });
    resetState();
}

function resetState() {
    currentCategory = null;
    items = [];
    selectedItem = null;
    selectedColor = null;
    colorVariants = [];
    cart = [];
    isCartOpen = false;
    isSettingsOpen = false;
    clothingStates = {};
    categorySelectedItems = {};
    document.getElementById('settingsPanel').classList.add('hidden');
    document.getElementById('settingsOverlay').classList.add('hidden');
}

let globalTooltip = null;

function showGlobalTooltip(text, element) {
    if (!globalTooltip) {
        globalTooltip = document.createElement('div');
        globalTooltip.className = 'global-tooltip';
        document.body.appendChild(globalTooltip);
    }
    globalTooltip.textContent = text;
    globalTooltip.style.display = 'block';

    const rect = element.getBoundingClientRect();
    globalTooltip.style.top = (rect.top + rect.height / 2) + 'px';
    globalTooltip.style.right = (window.innerWidth - rect.left + 10) + 'px';
    globalTooltip.style.left = 'auto';
}

function hideGlobalTooltip() {
    if (globalTooltip) {
        globalTooltip.style.display = 'none';
    }
}

let btnTooltip = null;

function showBtnTooltip(text, element) {
    if (!btnTooltip) {
        btnTooltip = document.createElement('div');
        btnTooltip.className = 'btn-tooltip-fixed';
        document.body.appendChild(btnTooltip);
    }
    btnTooltip.textContent = text;
    btnTooltip.style.display = 'block';

    const rect = element.getBoundingClientRect();
    btnTooltip.style.top = (rect.bottom + 8) + 'px';
    btnTooltip.style.left = (rect.left + rect.width / 2) + 'px';
}

function hideBtnTooltip() {
    if (btnTooltip) {
        btnTooltip.style.display = 'none';
    }
}

function renderCategories() {
    const container = document.getElementById('categoriesList');
    container.innerHTML = '';

    categories.forEach((cat, index) => {
        const div = document.createElement('div');
        div.className = 'category-item fade-in';
        div.style.animationDelay = `${index * 0.04}s`;
        div.dataset.name = cat.name;

        const iconSrc = `/ui/icons/${cat.name}.svg`;
        const label = categoryLabels[cat.name] || cat.label || cat.name;

        div.innerHTML = `
            <img class="category-icon" src="${iconSrc}" alt="${cat.name}" onerror="this.style.display='none'">
        `;

        div.onmouseenter = () => showGlobalTooltip(label, div);
        div.onmouseleave = () => hideGlobalTooltip();
        div.onclick = () => selectCategory(cat.name, div);
        container.appendChild(div);
    });
}

function renderClothingToolbar() {
    const container = document.getElementById('clothingToolbarGlobal');
    container.innerHTML = '';

    allClothingCategories.forEach(catName => {
        clothingStates[catName] = true;

        const btn = document.createElement('button');
        btn.className = 'clothing-toggle on';
        btn.dataset.category = catName;

        const iconSrc = `/ui/icons/${catName}.svg`;
        const label = categoryLabels[catName] || catName;

        btn.innerHTML = `
            <img src="${iconSrc}" alt="${catName}" onerror="this.style.display='none'">
            <span class="toggle-tooltip">درآوردن ${label}</span>
        `;

        btn.onclick = () => toggleClothing(catName, btn);
        container.appendChild(btn);
    });
}

function toggleClothing(categoryName, element) {
    const isOn = clothingStates[categoryName];
    const label = categoryLabels[categoryName] || categoryName;
    const tooltip = element.querySelector('.toggle-tooltip');

    if (isOn) {
        clothingStates[categoryName] = false;
        element.classList.remove('on');
        element.classList.add('off');
        if (tooltip) tooltip.textContent = `پوشیدن ${label}`;
        fetch(`https://${RESOURCE}/undress`, {
            method: 'POST',
            body: JSON.stringify({ category: categoryName })
        });
    } else {
        clothingStates[categoryName] = true;
        element.classList.remove('off');
        element.classList.add('on');
        if (tooltip) tooltip.textContent = `درآوردن ${label}`;
        fetch(`https://${RESOURCE}/restoreClothing`, {
            method: 'POST',
            body: JSON.stringify({ category: categoryName })
        });
    }
}

function selectCategory(name, element) {
    document.querySelectorAll('.category-item').forEach(el => el.classList.remove('active'));
    element.classList.add('active');

    currentCategory = name;
    document.getElementById('currentCategory').textContent = categoryLabels[name] || name;

    const emptyState = document.getElementById('emptyState');
    if (emptyState) emptyState.style.display = 'none';

    document.getElementById('itemsGrid').innerHTML = '<div class="loading-spinner"></div>';

    fetch(`https://${RESOURCE}/loadClothe`, {
        method: 'POST',
        body: JSON.stringify({ name: name })
    });

    clearSelection();
    hideColorsPanel();
}

function renderItems(itemList, type) {
    items = itemList;
    currentCategory = type;
    document.getElementById('searchInput').value = '';
    renderFilteredItems(itemList, type);

    const savedItem = categorySelectedItems[type];
    if (savedItem) {
        setTimeout(() => {
            const card = document.querySelector(`.item-card[data-id="${savedItem.id}"]`);
            if (card) {
                selectItem(savedItem, card);
                card.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }, 50);
    }
}

function renderFilteredItems(itemList, type) {
    const container = document.getElementById('itemsGrid');

    if (!container) return;

    container.innerHTML = '';

    if (!itemList || itemList.length === 0) {
        container.innerHTML = '<div class="empty-state">آیتمی یافت نشد</div>';
        document.getElementById('itemsCount').textContent = '0';
        return;
    }

    document.getElementById('itemsCount').textContent = itemList.length;

    itemList.forEach((item, index) => {
        const card = document.createElement('div');
        card.className = 'item-card fade-in';
        card.dataset.id = item.id;

        const imgSrc = item.img || `${imageServer}/clothes/${type}/${item.name}.png`;
        const fallbackIcon = `/ui/icons/${type}.svg`;

        card.innerHTML = `
            ${item.prime ? '<div class="prime-badge">PRIME</div>' : ''}
            <img class="item-image" src="${imgSrc}" alt="${item.label || item.name}" onerror="this.onerror=null; this.src='${fallbackIcon}'; this.classList.add('fallback-icon');">
            <div class="item-info">
                <div class="item-name">${item.label || item.name}</div>
                <div class="item-price">$${formatNumber(item.price)}</div>
            </div>
        `;

        card.onclick = () => selectItem(item, card);
        container.appendChild(card);
    });
}

function searchItems(query) {
    if (!items || items.length === 0) return;

    const searchTerm = query.toLowerCase().trim();

    if (searchTerm === '') {
        renderFilteredItems(items, currentCategory);
        return;
    }

    const filtered = items.filter(item => {
        const name = (item.label || item.name || '').toLowerCase();
        return name.includes(searchTerm);
    });

    renderFilteredItems(filtered, currentCategory);
}

function selectItem(item, element) {
    document.querySelectorAll('.item-card').forEach(el => el.classList.remove('selected'));
    element.classList.add('selected');

    selectedItem = item;
    selectedColor = item;

    categorySelectedItems[currentCategory] = item;

    document.getElementById('selectedName').textContent = item.label || item.name;
    document.getElementById('selectedPrice').textContent = '$' + formatNumber(item.price);

    updateAddToCartButton();

    fetch(`https://${RESOURCE}/preview`, {
        method: 'POST',
        body: JSON.stringify({ num: item.num })
    });

    fetch(`https://${RESOURCE}/loadColor`, {
        method: 'POST',
        body: JSON.stringify(item.id)
    });
}

function renderColors(colors) {
    colorVariants = colors;
    const container = document.getElementById('colorsGrid');
    const panel = document.getElementById('colorsPanel');

    container.innerHTML = '';

    if (!colors || colors.length === 0) {
        hideColorsPanel();
        return;
    }

    showColorsPanel();

    colors.reverse().forEach((color, index) => {
        const div = document.createElement('div');
        div.className = 'color-card fade-in' + (selectedColor && selectedColor.name === color.name ? ' active' : '');

        const imgSrc = color.img || `${imageServer}/clothes/${currentCategory}/${color.name}.png`;
        const fallbackIcon = `/ui/icons/${currentCategory}.svg`;

        div.innerHTML = `
            <img class="color-image" src="${imgSrc}" alt="رنگ ${index + 1}" onerror="this.onerror=null; this.src='${fallbackIcon}'; this.classList.add('fallback-icon');">
            <div class="color-info">
                <div class="color-price">$${formatNumber(color.price)}</div>
            </div>
        `;

        div.onclick = () => selectColor(color, div);
        container.appendChild(div);
    });
}

function showColorsPanel() {
    document.getElementById('colorsPanel').classList.remove('hidden');
}

function hideColorsPanel() {
    document.getElementById('colorsPanel').classList.add('hidden');
}

function selectColor(color, element) {
    document.querySelectorAll('.color-card').forEach(el => el.classList.remove('active'));
    element.classList.add('active');

    selectedColor = color;

    document.getElementById('selectedPrice').textContent = '$' + formatNumber(color.price);

    updateAddToCartButton();

    fetch(`https://${RESOURCE}/preview`, {
        method: 'POST',
        body: JSON.stringify({ num: color.num })
    });
}

function addToCart() {
    if (!selectedColor) return;

    const btn = document.getElementById('addToCartBtn');
    const existingIndex = cart.findIndex(item => item.id === selectedColor.id && item.name === selectedColor.name);

    if (existingIndex === -1) {
        const cartItem = {
            ...selectedColor,
            category: currentCategory,
            img: selectedColor.img || `${imageServer}/clothes/${currentCategory}/${selectedColor.name}.png`
        };
        cart.push(cartItem);

        btn.classList.add('added');
        btn.textContent = 'اضافه شد ✓';

        const cartFloating = document.getElementById('cartFloating');
        cartFloating.classList.add('item-added');
        setTimeout(() => {
            cartFloating.classList.remove('item-added');
        }, 700);

        setTimeout(() => {
            btn.classList.remove('added');
            updateAddToCartButton();
        }, 1000);
    } else {
        toggleCart();
    }

    updateCartUI();
    if (isCartOpen) {
        renderCartItems();
    }
}

function updateAddToCartButton() {
    const btn = document.getElementById('addToCartBtn');
    if (!selectedColor) {
        btn.disabled = true;
        btn.classList.remove('in-cart');
        btn.textContent = 'افزودن به سبد';
        btn.onclick = addToCart;
        return;
    }

    const existingIndex = cart.findIndex(item => item.id === selectedColor.id && item.name === selectedColor.name);

    if (existingIndex !== -1) {
        btn.disabled = false;
        btn.classList.add('in-cart');
        btn.textContent = 'مشاهده سبد خرید';
        btn.onclick = toggleCart;
    } else {
        btn.disabled = false;
        btn.classList.remove('in-cart');
        btn.textContent = 'افزودن به سبد';
        btn.onclick = addToCart;
    }
}

function removeFromCart(index) {
    cart.splice(index, 1);
    updateCartUI();
    renderCartItems();
    updateAddToCartButton();
}

function clearCart() {
    if (cart.length === 0) return;
    cart = [];
    updateCartUI();
    renderCartItems();
    updateAddToCartButton();
    showNotification('سبد خرید خالی شد', 'info');
}

function updateCartUI() {
    const badge = document.getElementById('cartBadge');
    const checkoutBtn = document.getElementById('checkoutBtn');
    const tryoutBtn = document.getElementById('tryoutBtn');
    const clearCartBtn = document.getElementById('clearCartBtn');

    badge.textContent = cart.length;

    if (cart.length > 0) {
        badge.classList.add('has-items');
        checkoutBtn.disabled = false;
        tryoutBtn.disabled = false;
        if (clearCartBtn) clearCartBtn.disabled = false;
    } else {
        badge.classList.remove('has-items');
        checkoutBtn.disabled = true;
        tryoutBtn.disabled = true;
        if (clearCartBtn) clearCartBtn.disabled = true;
    }

    const total = cart.reduce((sum, item) => sum + (item.price || 0), 0);
    document.getElementById('cartTotal').textContent = '$' + formatNumber(total);
}

function toggleCart() {
    isCartOpen = !isCartOpen;
    const cartPanel = document.getElementById('cartPanel');
    const cartFloating = document.getElementById('cartFloating');

    if (isCartOpen) {
        cartPanel.classList.remove('hidden');
        cartFloating.classList.add('hidden');
        renderCartItems();
    } else {
        cartPanel.classList.add('hidden');
        cartFloating.classList.remove('hidden');
    }
}

function renderCartItems() {
    const container = document.getElementById('cartItems');

    if (cart.length === 0) {
        container.innerHTML = '<div class="cart-empty">سبد خرید خالی است</div>';
        return;
    }

    container.innerHTML = '';

    cart.forEach((item, index) => {
        const div = document.createElement('div');
        div.className = 'cart-item fade-in';
        div.style.animationDelay = `${index * 0.05}s`;

        const fallbackIcon = `/ui/icons/${item.category}.svg`;

        div.innerHTML = `
            <img class="cart-item-img" src="${item.img}" alt="${item.label || item.name}" onerror="this.onerror=null; this.src='${fallbackIcon}'; this.classList.add('fallback-icon');">
            <div class="cart-item-info">
                <div class="cart-item-name">${item.label || item.name}</div>
                <div class="cart-item-price">$${formatNumber(item.price)}</div>
            </div>
            <button class="cart-item-remove" onclick="removeFromCart(${index})">✕</button>
        `;

        container.appendChild(div);
    });
}

function tryoutCart() {
    if (cart.length === 0) return;

    toggleCart();

    fetch(`https://${RESOURCE}/tryout`, {
        method: 'POST',
        body: JSON.stringify(cart)
    });
}

let checkoutTimeout = null;

function checkout() {
    if (cart.length === 0) return;
    if (checkoutPending) return;

    const checkoutBtn = document.getElementById('checkoutBtn');
    checkoutBtn.disabled = true;
    checkoutBtn.innerHTML = '<div class="loading-spinner small"></div>';
    checkoutPending = true;

    if (checkoutTimeout) clearTimeout(checkoutTimeout);
    checkoutTimeout = setTimeout(() => {
        if (checkoutPending) {
            checkoutPending = false;
            checkoutBtn.innerHTML = 'تکمیل خرید';
            checkoutBtn.disabled = false;
        }
    }, 3000);

    fetch(`https://${RESOURCE}/buy`, {
        method: 'POST',
        body: JSON.stringify(cart)
    });
}

function rotatePlayer(direction) {
    fetch(`https://${RESOURCE}/rotation`, {
        method: 'POST',
        body: JSON.stringify(direction)
    });
}

function resetCamera() {
    fetch(`https://${RESOURCE}/resetCamera`, {
        method: 'POST',
        body: JSON.stringify({})
    });
}

function clearItems() {
    document.getElementById('itemsGrid').innerHTML = '<div class="empty-state" id="emptyState">یک دسته‌بندی انتخاب کنید</div>';
    document.getElementById('itemsCount').textContent = '0';
    document.getElementById('currentCategory').innerHTML = '<span class="select-arrow">→</span> انتخاب کنید';
}

function clearSelection() {
    selectedItem = null;
    selectedColor = null;
    colorVariants = [];

    document.getElementById('selectedName').textContent = '-';
    document.getElementById('selectedPrice').textContent = '-';
    document.getElementById('addToCartBtn').disabled = true;
}

function formatNumber(num) {
    if (!num && num !== 0) return '0';
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

let isSettingsOpen = false;
let clothingStates = {};
let categorySelectedItems = {};

function toggleSettings() {
    isSettingsOpen = !isSettingsOpen;
    const panel = document.getElementById('settingsPanel');
    const overlay = document.getElementById('settingsOverlay');

    if (isSettingsOpen) {
        panel.classList.remove('hidden');
        overlay.classList.remove('hidden');
    } else {
        panel.classList.add('hidden');
        overlay.classList.add('hidden');
    }
}

function setAllGridColumns(cols) {
    const itemsGrid = document.getElementById('itemsGrid');
    const colorsGrid = document.getElementById('colorsGrid');

    itemsGrid.classList.remove('cols-1', 'cols-2', 'cols-3', 'cols-4');
    itemsGrid.classList.add('cols-' + cols);

    colorsGrid.classList.remove('cols-1', 'cols-2', 'cols-3', 'cols-4');
    colorsGrid.classList.add('cols-' + cols);

    document.querySelectorAll('.settings-grid-btn').forEach(btn => {
        btn.classList.remove('active');
        if (btn.dataset.cols == cols) {
            btn.classList.add('active');
        }
    });

    localStorage.setItem('shopGridCols', cols);
}

function loadSavedGridSettings() {
    const savedCols = localStorage.getItem('shopGridCols');

    if (savedCols) {
        setAllGridColumns(parseInt(savedCols));
    }
}

document.addEventListener('DOMContentLoaded', loadSavedGridSettings);
