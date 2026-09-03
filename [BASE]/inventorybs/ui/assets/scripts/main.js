var clickableDivs = []
var inventory = null

function ManageClotheSlot(part) {
    $.post('https://inventorybs/ManageClotheSlot', JSON.stringify({
        part : part
    })); 
}

function previewItem(name, label, count, type, usable, removable) {
    var e = window.event || e; 
    var left  = e.pageX + "px";
    var top  = e.clientY  + "px";
    var image = `./assets/img/items/${name}.png`
    if (type === "weapon") {
        image = `./assets/img/weapons/${name.toUpperCase()}.png`
    }
    $('#item-manage-actions-inventory').html(`<div class="inventory__modal--container">
    <div class="inventory__modal--title_container">
        <div class="inventory__modal--title">
            <img src="${image}" alt="">
            <span>${label.replace("_appo_", "'")}</span>
        </div>
        <span>x${count.toLocaleString('pl-PL')}</span>
    </div>
    <div class="inventory__modal--items">
        <div class="inventory__modal--icon nohide" ${(usable == "1") ? '' : 'onclick="hideAllElements(); useItem(' + "'" + name + "'" + ');'}">
            <img class="nohide" src="./assets/img/actions/${(usable === "true") ? 'white' : 'black'}/bi_arrow-down-square.svg" alt="">
        </div>
        <div class="inventory__modal--icon ${(removable == "1") ? ' ' : ''}nohide" id="" onclick="showCount('give', '${name}', '${label}', ${count}, '${type}');">
            <img class="nohide" src="./assets/img/actions/${(removable == "1") ? 'white' : 'black'}/user.svg" alt="">
        </div>
        <div class="inventory__modal--icon ${(removable == "1") ? ' ' : ''}nohide" onclick="showCount('drop', '${name}', '${label}', ${count}, '${type}');">
            <img class="nohide" src="./assets/img/actions/${(removable == "1") ? 'white' : 'black'}/arrow.svg" alt="">
        </div>
    </div>
</div>`);
    var div = document.getElementById('item-manage-actions-inventory');
    div.style.opacity = 100;
    div.style.left = left;
    div.style.top = top;
}

function showCount(type, item, label, count, itemtype) {
        var e = window.event || e; 

        var left  = e.pageX + "px";
        var top  = e.clientY  + "px";
        var image = `./assets/img/items/${item}.png`
        if (itemtype === "weapon") {
            image = `./assets/img/weapons/${item.toUpperCase()}.png`
        } else if (itemtype === "account") {
            image = `./assets/img/accounts/${item}.png`
        }

        $('#item-manage-count-inventory').html(`<div class="inventory__modal--container">
        <div class="inventory__modal--title_container">
            <div class="inventory__modal--title">
                <img src="${image}" alt="">
                <span>${label.replace("_appo_", "'")}</span>
            </div>
            <span>x${count}</span>
        </div>
        <div class="inventory__modal--items">
            <div class="inventory__modal--items_wrapper">
                <div class="inventory__modal--btn nohide" id="item-manage-count-inventory-more" onclick="$('#inventory-items-count').val(parseInt($('#inventory-items-count').val()) + 1).trigger('change')">
                    +
                </div>
                <input type="number" class="nohide writable" id="inventory-items-count" min="0" max="999" value="1" placeholder="1"></input>
                <div class="inventory__modal--btn nohide" id="item-manage-count-inventory-less" onclick="$('#inventory-items-count').val(parseInt($('#inventory-items-count').val()) - 1).trigger('change')">
                    -
                </div>
            </div>
            <div class="inventory__modal--item_btn nohide" onclick="ManageInventoryAction('${type}', '${item}', 'inventory', '${itemtype}', 1)">Confirm</div>
        </div>
    </div>
    </div>`)

        var div = document.getElementById('item-manage-count-inventory');
        var div1 = document.getElementById('item-manage-actions-inventory');
        if (div1 && div1.style && div1.style.left && div1.style.top && div1.style.left !== 0 && div1.style.top !== 0) {
            left = div1.style.left
            top = div1.style.top
        }
        div.style.opacity = 100;
        div.style.left = left;
        div.style.top = top;
        hideElement('item-manage-actions-inventory')
}

function ManageInventoryAction(type, item, inputid, itemtype, vault) {
    var count = parseInt($('#' + inputid + '-items-count').val())
    $.post('https://inventorybs/' + type, JSON.stringify({
        item : item,
        count: count,
        type: itemtype,
        vault: vault
    })); 
}

function hideElement(id) {
    var div = document.getElementById(id);
    div.style.opacity = 0;
    div.style.left = 0;
    div.style.top = 0;
}

function closeInventory() {
    $.post('https://inventorybs/close'); 
}

function hideAllElements() {
    hideElement('item-manage-actions-inventory')
    hideElement('item-manage-count-inventory')
    hideElement('item-manage-count-vault')
}

function showVaultCount(type, item, label, count, itemtype, inventory) {
    if (type !== 'none') {
        if (itemtype == "item" || itemtype == "account") {

            var e = window.event || e; 
        
            var left  = e.pageX + "px";
            var top  = e.clientY  + "px";
            var image = `./assets/img/items/${item}.png`
            if (itemtype === "weapon") {
                image = `./assets/img/weapons/${item.toUpperCase()}.png`
            } else if (itemtype === "account") {
                image = `./assets/img/accounts/${item}.png`
            }
        
            $('#item-manage-count-vault').html(`<div class="inventory__modal--container">
            <div class="inventory__modal--title_container">
                <div class="inventory__modal--title">
                    <img src="${image}" onerror="this.onerror=null; this.src='./assets/img/items/carton.png'" alt="">
                    <span>${label.replace("_appo_", "'")}</span>
                </div>
                <span>x${count}</span>
            </div>
            <div class="inventory__modal--items">
                <div class="inventory__modal--items_wrapper">
                    <div class="inventory__modal--btn nohide" id="item-manage-count-vault-more" onclick="$('#vault-items-count').val(parseInt($('#vault-items-count').val()) + 1).trigger('change')">
                        +
                    </div>
                    <input type="number" class="nohide writable" id="vault-items-count" min="0" max="999" value="1" placeholder="1"></input>
                    <div class="inventory__modal--btn nohide" id="item-manage-count-vault-less" onclick="$('#vault-items-count').val(parseInt($('#vault-items-count').val()) - 1).trigger('change')">
                        -
                    </div>
                </div>
                <div class="inventory__modal--item_btn nohide" onclick="ManageInventoryAction('${type}', '${item}', 'vault', '${itemtype}', '${inventory}')">Confirm</div>
            </div>
        </div>
        </div>`)
        
            var div = document.getElementById('item-manage-count-vault');
            div.style.opacity = 100;
            div.style.left = left;
            div.style.top = top;
        } else {
            ManageInventoryAction(type, item, 'vault', itemtype, inventory)
        }
    } else {
            var e = window.event || e; 
        
            var left  = e.pageX + "px";
            var top  = e.clientY  + "px";
            var image = `./assets/img/items/${item}.png`
            if (itemtype === "weapon") {
                image = `./assets/img/weapons/${item.toUpperCase()}.png`
            }
        
            $('#item-manage-count-vault').html(`
        <div class="inventory__modal--container">
            <div class="inventory__modal--title_container">
                <div class="inventory__modal--title">
                    <img src="${image}" onerror="this.onerror=null; this.src='./assets/img/items/carton.png'" alt="">
                    <span>${label.replace("_appo_", "'")}</span>
                </div>
                <span>x${count}</span>
            </div>
        </div>`)
        
            var div = document.getElementById('item-manage-count-vault');
            div.style.opacity = 100;
            div.style.left = left;
            div.style.top = top;
    }
}

function useItem(item) {
    $.post('https://inventorybs/use', JSON.stringify({
        item : item,
    })); 
}

function sendRequestToLoadCategory(type, enabledtype) {
    $.post('https://inventorybs/load', JSON.stringify({
        type : type,
        filter : enabledtype
    })); 
}

function resetSortList(type, enabledtype) {
    $(`#${type}__sort-category`).html(`<div class="menu__sort--item${(enabledtype === "all") ? ' active' : ''}" id="${type}__sort-all" onclick="sendRequestToLoadCategory('${type}', 'all')">
    <img src="./assets/img/ep_menu.svg" alt="">
</div>
<div class="menu__sort--item${(enabledtype === "weapons") ? ' active' : ''}" id="${type}__sort-weapons" onclick="sendRequestToLoadCategory('${type}', 'weapons')">
    <img src="./assets/img/submachine-gun-svgrepo-com.svg" alt="">
</div>
<div class="menu__sort--item${(enabledtype === "clothes") ? ' active' : ''}" id="${type}__sort-clothes" onclick="sendRequestToLoadCategory('${type}', 'clothes')">
    <img src="./assets/img/black.svg" alt="">
</div>
<div class="menu__sort--item${(enabledtype === "keys") ? ' active' : ''}" id="${type}__sort-keys" onclick="sendRequestToLoadCategory('${type}', 'keys')">
    <img src="./assets/img/fluent_key-20-filled.svg" alt="">
</div>
<div class="menu__sort--item${(enabledtype === "items") ? ' active' : ''}" id="${type}__sort-items" onclick="sendRequestToLoadCategory('${type}', 'items')">
    <img src="./assets/img/ion_fast-food.svg" alt="">
</div>
<div class="menu__sort--item${(enabledtype === "medics") ? ' active' : ''}" id="${type}__sort-medics" onclick="sendRequestToLoadCategory('${type}', 'medics')">
    <img src="./assets/img/medical-icon_health-services.svg" alt="">
</div>
<div class="menu__sort--item${(enabledtype === "accounts") ? ' active' : ''}" id="${type}__sort-accounts" onclick="sendRequestToLoadCategory('${type}', 'accounts')">
    <img src="./assets/img/fa-solid_money-bill-wave-alt.svg" alt="">
</div>`)
}

function OpenPlayerInventory(data) {
    var invitemlist = $('#inventory-itemlist')
    invitemlist.html("")
    $.each(data.rows, function(key, value) {
        var item = `
          <div class="menu__list-item" id="myinventory__${value.itemType}-${key}" draggable="true" onclick="previewItem('${value.name}', '${value.label.replace("'", "_appo_")}', ${value.count}, '${value.itemType}', '${value.usable}', '${value.canRemove}')">
            <img src="${value.image}" onerror="this.onerror=null; this.src='./assets/img/items/carton.png'">
            <span>${value.label}</span>
          </div>
        `;
        invitemlist.append(item);
      
        $('#myinventory__' + value.itemType + '-' + key)
          .data('item', value.name)
          .data('inventory', { name: 'my' })
          .data('type', value.itemType)
          .data('label', value.label)
          .data('count', value.count)
          .data('canRemove', value.canRemove.toString())
          .draggable({
            helper: 'clone',
            appendTo: 'body',
            zIndex: 99999,
            revert: 'invalid',
          });
    });
    PopulateFastItems(data.fastItems)
    for (let i = 0; i < (Math.ceil(((data.rowsCount > 0) ? data.rowsCount : 16) / 16) * 16) - ((data.rowsCount > 0) ? data.rowsCount : 0); i++) {
        invitemlist.append(`<div class="menu__list-item"></div>`)
    } 

    $('#clothe-pack').droppable({
        drop: function(event, ui) {
            if (ui.draggable.data("type") == "clothe") {
                $.post('https://inventorybs/setClothe', JSON.stringify({
                item : ui.draggable.data("item")
            })); 
            }
        }
    })
    resetSortList("my", data.selectedCategory)
    inventory.setMaxCapacity(data.maxCapacity);
    inventory.setMinCapacity(data.itemsCount);
    var div = document.getElementById('item-manage-count-inventory');
    div.style.opacity = 0;
    div = document.getElementById('item-manage-actions-inventory');
    div.style.opacity = 0;
    div = document.getElementById('inventory');
    div.style.opacity = 100;
    $('#inventory').fadeIn(250);

}

function PopulateFastItems(data) {
      $('#fastmenu__items').html(`
      <div class="fastmenu__item" id="fast__item-1"></div>
      <div class="fastmenu__item" id="fast__item-2"></div>
      <div class="fastmenu__item" id="fast__item-3"></div>
      <div class="fastmenu__item" id="fast__item-4"></div>
      <div class="fastmenu__item" id="fast__item-5"></div>
    `);
    
    $.each(data, function(k, value) {
      let image;
      switch (value.type) {
        case 'item':
          image = `./assets/img/items/${value.name}.png`;
          break;
        case 'item':
          image = `./assets/img/accounts/${value.name}.png`;
          break;
        case 'weapon':
          image = `./assets/img/weapons/${value.name.toUpperCase()}.png`;
          break;
        case 'clothe':
          image = "./assets/img/items/shirt.png";
          break;
      }
      if ((typeof value.icon) == "string") {
        image = value.icon;
      }
      const key = value.place;
      const $item = $(`#fast__item-${key}`);
      $item.html(`
        <img src="${image}" onerror="this.onerror=null; this.src='./assets/img/items/carton.png'">
        <span>${value.label}</span>
      `);
      $item.data('item', value.name);
      $item.data('inventory', { name: 'my' });
      $item.data('fast', true);
      $item.data('type', 'clothe');
      $item.draggable({
        helper: 'clone',
        appendTo: 'body',
        zIndex: 99999,
        start: function(event, ui) {
          const _key = key;
          $.post('https://inventorybs/removeFast', JSON.stringify({
            place: _key,
          }));
        },
      });
    });
    for (let i = 1; i <= 5; i++) {
        $(`#fast__item-${i}`).droppable({
          drop: function(event, ui) {
            if (!ui.draggable.data('inventory') || ui.draggable.data('inventory').name == 'other') return;
            $.post('https://inventorybs/setFast', JSON.stringify({
              item: ui.draggable.data('item'),
              type: ui.draggable.data('type'),
              label: ui.draggable.data('label'),
              place: i,
            }));
          }
        });
    }
}

function OpenOtherInventory(data) {
    var vaultitemlist = $('#vault-itemlist')
    vaultitemlist.html("")
    $.each(data.rows, function(key, value) {
        var label = value.label.replace("'", "_appo_");
        var item = `
          <div class="menu__list-item" id="otherinventory__${value.itemType}-${key}" draggable="true" onclick="showVaultCount('none', '${value.name}', '${label}', ${value.count}, '${value.itemType}', ${data.vault.type})">
            <img src="${value.image}" onerror="this.onerror=null; this.src='./assets/img/items/carton.png'">
            <span>${value.label}</span>
          </div>
        `;
        vaultitemlist.append(item);
      
        $('#otherinventory__' + value.itemType + '-' + key)
          .data('item', value.name)
          .data('inventory', { name: 'other' })
          .data('type', value.itemType)
          .data('label', value.label)
          .data('count', value.count)
          .data('canRemove', value.canRemove.toString())
          .draggable({
            helper: 'clone',
            appendTo: 'body',
            zIndex: 99999,
            revert: 'invalid',
          });
    });
    for (let i = 0; i < (Math.ceil(((data.rowsCount > 0) ? data.rowsCount : 16) / 16) * 16) - ((data.rowsCount > 0) ? data.rowsCount : 0); i++) {
        vaultitemlist.append(`<div class="menu__list-item"></div>`)
    } 
    vaultitemlist.droppable({
        drop: function(event, ui) {
            if (!ui.draggable.data("inventory") || ui.draggable.data("inventory").name !== "my" || ui.draggable.data("fast")) return;
            showVaultCount('putInVault', ui.draggable.data("item"), ui.draggable.data("label"), ui.draggable.data("count"), ui.draggable.data("type"), data.vault.type)
        }
    })
    $('#inventory-itemlist').droppable({
        drop: function(event, ui) {
            if (!ui.draggable.data("inventory") || ui.draggable.data("inventory").name == "my" || ui.draggable.data("fast")) return;
            showVaultCount('getFromVault', ui.draggable.data("item"), ui.draggable.data("label"), ui.draggable.data("count"), ui.draggable.data("type"), data.vault.type)
        }
    })
    resetSortList("other", data.selectedCategory)
    $('#menu__title--vault').html(data.title)
    inventory.setOtherMaxCapacity(data.maxCapacity);
    inventory.setOtherMinCapacity(data.itemsCount);
    var div = document.getElementById('item-manage-count-vault');
    div.style.opacity = 0;
    div = document.getElementById('inventory');
    div.style.opacity = 100;
    $('#inventory').fadeIn(250);
}

$(document).ready(function(){
    var maxCapacity = 0
    var inventoryData = {
        hover: false,
        Count: false,
        MyMinCapacity: 0,
        MyMaxCapacity: maxCapacity,
        OtherMinCapacity: 0,
        OtherMaxCapacity: maxCapacity,
    }
    inventory = new Vue({
        el: '#inventory',
        data() {
            return inventoryData
        },
        methods: {
            setMaxCapacity(count) {
              this.MyMaxCapacity = count
              $('#inventory-weight-bar').css("width", (this.MyMinCapacity * 328) / this.MyMaxCapacity);
            },
            setMinCapacity(count) {
              this.MyMinCapacity = count
              $('#inventory-weight-bar').css("width", (this.MyMinCapacity * 328) / this.MyMaxCapacity);
            },
            setOtherMaxCapacity(count) {
                if (count == -1) {
                    this.OtherMaxCapacity = "Illimité"
                    $('#vault-weight-bar').css("width", 0);  
                } else {
                    this.OtherMaxCapacity = count
                    $('#vault-weight-bar').css("width", (this.OtherMinCapacity * 328) / this.OtherMaxCapacity);  
                }   
            },
            setOtherMinCapacity(count) {
                if (this.OtherMaxCapacity == "Illimité") {
                    this.OtherMinCapacity = count
                    $('#vault-weight-bar').css("width", 0);  
                } else {
                    this.OtherMinCapacity = count
                    $('#vault-weight-bar').css("width", (this.OtherMinCapacity * 328) / this.OtherMaxCapacity);       
                }  
            },
        }
    })
    $('#inventory-search-input').keyup(function(){
        var value = $('#inventory-search-input').val()
        $.post('https://inventorybs/search', JSON.stringify({
            value : value,
            type : "inventory"
        }));
    });
    $('#vault-search-input').keyup(function(){
        var value = $('#vault-search-input').val()
        $.post('https://inventorybs/search', JSON.stringify({
            value : value,
            type : "vault"
        })); 
    });
    $(document).keyup(function(e) {
        if (e.key === "Escape") { 
            closeInventory()
       }
   });
    window.addEventListener('mousedown', e => {
        const clickedEl = e.target;
        if ((clickedEl !== null && !(clickedEl.classList.contains("nohide")))) {
            hideAllElements()
        }
      });
    window.addEventListener('message', function(e) {
        var data = e.data
        switch (data.action) {
            case "populateInventory": 
                OpenPlayerInventory(data)
                break;
            case "populateVault": 
                OpenOtherInventory(data)
                break;
            case "close":
                const value = `<div class="menu__list-item"></div>
                <div class="menu__list-item"></div>
                <div class="menu__list-item"></div>
                <div class="menu__list-item"></div>
                <div class="menu__list-item"></div>
                <div class="menu__list-item"></div>
                <div class="menu__list-item"></div>
                <div class="menu__list-item"></div>
                <div class="menu__list-item"></div>
                <div class="menu__list-item"></div>
                <div class="menu__list-item"></div>
                <div class="menu__list-item"></div>
                <div class="menu__list-item"></div>
                <div class="menu__list-item"></div>
                <div class="menu__list-item"></div>
                <div class="menu__list-item"></div>
                <div class="menu__list-item"></div>
                <div class="menu__list-item"></div>
                <div class="menu__list-item"></div>
                <div class="menu__list-item"></div>`
                $('#inventory-itemlist').html(value)
                $('#vault-itemlist').html(value)
                $('#menu__title--vault').html("Coffre")
                inventory.setOtherMaxCapacity(150);
                inventory.setOtherMinCapacity(0);
                resetSortList("other", "none")
                //$('#inventory').css("opacity", 0);
                $('#inventory').fadeOut(250);
                break;
            case "setOpacity":
                $('#' + data.element).css("opacity", data.opacity);
                break;
        }
    })
})
