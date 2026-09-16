var type = "normal";
var disabled = false;
var idcard = null;
var idcardType = null;
var idcardOpen = false;
var inventoryVisible = false;

let totalSlots = 50;

const maxWeightBarValue = 28.2;

function filterInventoryItems(query) {
    query = (query || '').trim().toLowerCase();

    $("#left-inventory .item-info").each(function() {
        var itemEl = $(this).find('.item');
        var itemData = itemEl.data('item');

        if (!itemData || !query) {
            $(this).removeClass('search-hidden');
            return;
        }

        var label = (itemData.label || itemData.name || '').toLowerCase();
        if (label.indexOf(query) === -1) {
            $(this).addClass('search-hidden');
        } else {
            $(this).removeClass('search-hidden');
        }
    });
}

$(document).on('input', '#itemSearch', function() {
    filterInventoryItems($(this).val());
});

// ██████╗  █████╗ ███╗   ██╗██╗  ██╗
// (rank/quality glow - mirrors Config.ItemRanks, see config/config.lua)

function applyRankStyle($el, item) {
    if (!item) return;
    var rank = item.rank || 'common';
    var colors = RANK_COLORS[rank] || RANK_COLORS.common;
    RANK_ORDER.forEach(function(r) { $el.removeClass('rank-' + r); });
    $el.addClass('rank-' + rank);
    if (rank === 'common') {
        $el.css('box-shadow', 'none');
        $el.css('border-color', '');
    } else {
        $el.css('border-color', colors.border);
        $el.css('box-shadow', '0 0 0.5vw 0.08vw ' + colors.glow);
    }
    var tint = clotheColorFilter(item);
    $el.css('filter', tint || '');
}

function itemWeightLabel(item) {
    if (!item || !item.weight || item.weight <= 0) return '';
    var count = (item.type === 'item_weapon') ? 1 : (item.count || 1);
    var total = item.weight * count;
    return total.toFixed(1) + 'kg';
}

// Dynamic clothing icon tint: real 3D palette swatches aren't available to
// a flat 2D NUI icon, so this approximates "icon reflects the actual color
// picked" with a CSS hue-rotate derived from the item's stored texture
// (color variant) index - same variant always renders the same tint.
function clotheColorFilter(item) {
    if (!item || item.type !== 'item_vetement' || !item.value) return '';
    var textureKey = item.name + '_2';
    var textureId = item.value[textureKey];
    if (textureId === undefined || textureId === null) return '';
    var hue = (Number(textureId) * 37) % 360; // 37 spreads small indices apart nicely
    return 'hue-rotate(' + hue + 'deg) saturate(1.4)';
}

function itemNewBadge(item) {
    return (item && item.isNew) ? '<div class="item-new-badge">' + (window.NEW_BADGE_TEXT || 'NEW') + '</div>' : '';
}

// ██╗    ██╗███████╗██╗ ██████╗ ██╗  ██╗████████╗    ██████╗  █████╗ ██████╗
// weight bar goes from the normal color to a warning/danger red the closer
// the player is to their max carry weight.
function updateWeightBarColor($bar, weight, maxWeight) {
    var ratio = maxWeight > 0 ? (weight / maxWeight) : 0;
    $bar.removeClass('weight-warn weight-danger');
    if (ratio >= 0.9) {
        $bar.addClass('weight-danger');
    } else if (ratio >= 0.75) {
        $bar.addClass('weight-warn');
    }
}

// ███████╗ ██████╗ ██████╗ ████████╗
// Auto-sort: reorders the .item-info nodes already in #left-inventory
// in-place, based on the .item element's stored `item` data. Empty slots
// (no item data) always sink to the bottom, same as the server already
// pads the grid with empty slots.
var currentSort = { key: null, dir: 1 };

function categoryOf(item) {
    if (!item) return 'zzz';
    if (item.type === 'item_weapon') return '1_weapon';
    if (item.type === 'item_vetement') return '2_clothes';
    if (item.type === 'item_account' || item.type === 'item_money') return '3_account';
    if (item.type === 'item_idcard' || item.type === 'item_phone') return '4_misc';
    return '5_item';
}

function rankWeight(item) {
    if (!item) return -1;
    var idx = RANK_ORDER.indexOf(item.rank || 'common');
    return idx === -1 ? 0 : idx;
}

function sortInventory(key) {
    if (currentSort.key === key) {
        currentSort.dir *= -1;
    } else {
        currentSort.key = key;
        currentSort.dir = 1;
    }

    var $container = $('#left-inventory');
    var $slots = $container.find('.item-info').get();

    $slots.sort(function(a, b) {
        var itemA = $(a).find('.item').data('item');
        var itemB = $(b).find('.item').data('item');

        // empty slots always sink to the bottom regardless of direction
        if (!itemA && !itemB) return 0;
        if (!itemA) return 1;
        if (!itemB) return -1;

        var va, vb;
        if (key === 'weight') {
            va = (itemA.weight || 0) * (itemA.count || 1);
            vb = (itemB.weight || 0) * (itemB.count || 1);
        } else if (key === 'name') {
            va = (itemA.label || itemA.name || '').toLowerCase();
            vb = (itemB.label || itemB.name || '').toLowerCase();
        } else if (key === 'rank') {
            va = rankWeight(itemA);
            vb = rankWeight(itemB);
        } else if (key === 'category') {
            va = categoryOf(itemA);
            vb = categoryOf(itemB);
        }

        if (va < vb) return -1 * currentSort.dir;
        if (va > vb) return 1 * currentSort.dir;
        return 0;
    });

    $.each($slots, function(_, el) {
        $container.append(el);
    });
}

$(document).on('click', '.sort-btn', function() {
    $('.sort-btn').removeClass('active');
    $(this).addClass('active');
    sortInventory($(this).data('sort'));
});

function initItemDraggable() {
    $('.item').draggable({
        helper: 'clone',
        appendTo: 'body',
        zIndex: 99999,
        revert: 'invalid',
        start: function(event, ui) {
            if (disabled) {
                return false;
            }
            if ($(this).hasClass('locked')) {
                return false;
            }
            itemData = $(this).data("item");

            if (itemData !== undefined) { 
                $(this).css('background-image', 'none');
                $("#drop").addClass("disabled");
                $("#give").addClass("disabled");
                $("#rename").addClass("disabled");
                $("#use").addClass("disabled");
            }
        },
        stop: function() {
            itemData = $(this).data("item");

            if (itemData !== undefined) { 
                image = itemData.image;
                $(this).css('background-image', 'url(' + image + ')');
                // $(this).css('background-image', itemData.image);
                $("#drop").removeClass("disabled");
                $("#use").removeClass("disabled");
                $("#rename").removeClass("disabled");
                $("#give").removeClass("disabled");
            }

        }
    });
}

window.addEventListener("message", function(event) {
    const weightBar = $('#weightBar')
    const weightText = $('#weight');
    const hudCss = $('#hudSetting')
    const weightCoffre = $('#weightCoffre');
    const weightBarCoffre = $('#weightBarCoffre')
    const textCoffre = $('#plate')

    if (event.data.action == "open:Inv") {

        // ██╗███╗   ██╗██╗   ██╗███████╗███╗   ██╗████████╗ ██████╗ ██████╗ ██╗   ██╗
        // ██║████╗  ██║██║   ██║██╔════╝████╗  ██║╚══██╔══╝██╔═══██╗██╔══██╗╚██╗ ██╔╝
        // ██║██╔██╗ ██║██║   ██║█████╗  ██╔██╗ ██║   ██║   ██║   ██║██████╔╝ ╚████╔╝ 
        // ██║██║╚██╗██║╚██╗ ██╔╝██╔══╝  ██║╚██╗██║   ██║   ██║   ██║██╔══██╗  ╚██╔╝  
        // ██║██║ ╚████║ ╚████╔╝ ███████╗██║ ╚████║   ██║   ╚██████╔╝██║  ██║   ██║   
        // ╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝   
                                                                                   
        type = event.data.type

        disabled = false;
        $(".form-inv").css('display', 'block');
        // rAF so the browser registers the display change before the
        // transition class flips - without this the fade+scale doesn't
        // animate on the very first open.
        requestAnimationFrame(function() {
            requestAnimationFrame(function() {
                $(".form-inv").addClass('visible');
            });
        });
        inventoryVisible = true;

        if (event.data.lootAnim) {
            $(".inventory").addClass('loot-opening');
            setTimeout(function() { $(".inventory").removeClass('loot-opening'); }, 550);
        }

        if (type == "normal" && event.data.playerName) {
            $("#translateInventory").text(event.data.playerName + ' [' + event.data.serverId + ']');
        }
    } else if (event.data.action == "close:Inv") {

        $("#dialog").dialog("close");

        $(".form-inv").removeClass('visible');
        setTimeout(function() { $(".form-inv").css('display', 'none'); }, 180);
        inventoryVisible = false;

        $(".item").remove();
        $(".menu").hide();
        $("#itemSearch").val('');

        
        weightBarCoffre.css("width", 0 + "vw");     
        weightCoffre.text('');
        textCoffre.text('');


    } else if (event.data.action == "Inv:WeightBarText") {
        

        let maxBarValue = (maxWeightBarValue * event.data.weight) / event.data.maxWeight; 
        weightBar.css("width", maxBarValue + "vw");     
        weightText.text(event.data.text); 
        updateWeightBarColor(weightBar, event.data.weight, event.data.maxWeight);

    } else if (event.data.action == "setItems") {
        
        inventorySetup(event.data.itemList, event.data.fastItems, event.data.crMenu, event.data.itemTrunk);

        maxWeight = event.data.maxWeight
        totalWeight = event.data.weight
        let maxBarValue = maxWeightBarValue / maxWeight * totalWeight//Math.floor(fillPercentage);
        weightBar.css("width", maxBarValue + "vw");     
        weightText.text(event.data.text);
        updateWeightBarColor(weightBar, totalWeight, maxWeight);

        $('.info_ui').attr('data-html', 'true').attr('title', _U('help_interfaces')
        ).tooltip({

            classes: {
                'ui-tooltip': 'custom-tooltip' // Classe CSS personnalisée pour l'info-bulle
            }
        });

        
        initItemDraggable();
        filterInventoryItems($('#itemSearch').val());

    } else if (event.data.action == "setSecondInventoryItems") {

        secondInventorySetup(event.data.itemList);

    } else if (event.data.action == "updateSlot") {

        // ███████╗██╗      ██████╗ ████████╗    
        // ██╔════╝██║     ██╔═══██╗╚══██╔══╝    
        // ███████╗██║     ██║   ██║   ██║       
        // ╚════██║██║     ██║   ██║   ██║       
        // ███████║███████╗╚██████╔╝   ██║       
        // ╚══════╝╚══════╝ ╚═════╝    ╚═╝       
                                      
        updateSlot(event.data.fastItems, event.data.crMenu);
    

    } else if (event.data.action == "InvNotify") {

        // ███╗   ██╗ ██████╗ ████████╗██╗███████╗
        // ████╗  ██║██╔═══██╗╚══██╔══╝██║██╔════╝
        // ██╔██╗ ██║██║   ██║   ██║   ██║█████╗  
        // ██║╚██╗██║██║   ██║   ██║   ██║██╔══╝  
        // ██║ ╚████║╚██████╔╝   ██║   ██║██║     
        // ╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚═╝╚═╝     
                                       
        msg = format(event.data.message);
        NotifyDefault(msg, event.data.timeout)

    } else if (event.data.action == "ItemNotify") {

        NotifyItem(event.data.message, event.data.icon, event.data.count)

    } else if (event.data.action == "InvHud") {

        // ██╗  ██╗██╗   ██╗██████╗ 
        // ██║  ██║██║   ██║██╔══██╗
        // ███████║██║   ██║██║  ██║
        // ██╔══██║██║   ██║██║  ██║
        // ██║  ██║╚██████╔╝██████╔╝
        // ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
                         
        if (config.activeHud) {

            HealthIndicator.animate(event.data.hp / 100);
            ArmorIndicator.animate(event.data.armor / 100);
            HungerIndicator.animate(event.data.hunger / 100);
            ThirstIndicator.animate(event.data.thirst / 100);
        } else {

            hudCss.css("display","none");     

        }
    } else if (event.data.action == "open:Input") {

        // ██╗███╗   ██╗██████╗ ██╗   ██╗████████╗
        // ██║████╗  ██║██╔══██╗██║   ██║╚══██╔══╝
        // ██║██╔██╗ ██║██████╔╝██║   ██║   ██║   
        // ██║██║╚██╗██║██╔═══╝ ██║   ██║   ██║   
        // ██║██║ ╚████║██║     ╚██████╔╝   ██║   
        // ╚═╝╚═╝  ╚═══╝╚═╝      ╚═════╝    ╚═╝   
                                       
        $(".title").text(event.data.title);
        $("#textArea").val("");
        $("#keyboard-input").show();
        setTimeout(()=>{
            $("#textArea").focus();
        },10);
        
    } else if (event.data.action == "close:Input") {

        $.post("http://esx_inventory/cancel", JSON.stringify({}));
        document.getElementById("textArea").value = "";
        $("#keyboard-input").hide();

    } else if (event.data.action == "open:MenuIdCard") {

        // ███╗   ███╗███████╗███╗   ██╗██╗   ██╗    ██╗██████╗      ██████╗ █████╗ ██████╗ ██████╗ 
        // ████╗ ████║██╔════╝████╗  ██║██║   ██║    ██║██╔══██╗    ██╔════╝██╔══██╗██╔══██╗██╔══██╗
        // ██╔████╔██║█████╗  ██╔██╗ ██║██║   ██║    ██║██║  ██║    ██║     ███████║██████╔╝██║  ██║
        // ██║╚██╔╝██║██╔══╝  ██║╚██╗██║██║   ██║    ██║██║  ██║    ██║     ██╔══██║██╔══██╗██║  ██║
        // ██║ ╚═╝ ██║███████╗██║ ╚████║╚██████╔╝    ██║██████╔╝    ╚██████╗██║  ██║██║  ██║██████╔╝
        // ╚═╝     ╚═╝╚══════╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝╚═════╝      ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ 
                                                                                         
        idcard = event.data.info
        idcardType = event.data.type
        $(".menu").show();
      
    } else if (event.data.action == "close:MenuIdCard") {

        $(".menu").hide();

    } else if (event.data.action == "open:idCard") {

        // ██╗██████╗      ██████╗ █████╗ ██████╗ ██████╗ 
        // ██║██╔══██╗    ██╔════╝██╔══██╗██╔══██╗██╔══██╗
        // ██║██║  ██║    ██║     ███████║██████╔╝██║  ██║
        // ██║██║  ██║    ██║     ██╔══██║██╔══██╗██║  ██║
        // ██║██████╔╝    ╚██████╗██║  ██║██║  ██║██████╔╝
        // ╚═╝╚═════╝      ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ 
                                               

        idcardOpen = true;
        var userData    = event.data.information;
        var sex         = event.data.sex;
        var title       = event.data.title;
        var mugshot     = event.data.image;
        var icon        = event.data.icon;
        var color         = event.data.color;
    
        $('#type').text(title);
        $('#name').text(userData.firstname + ' ' + userData.lastname);
        $('#dob').text(userData.dateofbirth);
        $('#height').text(userData.height + ' cm' );
        $('#sex').text(sex);
        $('#icon').attr('src', icon);
        $('#picture').attr('src', mugshot || 'assets/icons/picture.png');
        $('#signature').text( userData.lastname);

        // $('#id-card-setting').css('border-top', '0.154vw solid ' + color);*
        var style = document.createElement('style');
        style.innerHTML = '.idcard-container:after { border-bottom: 0.154vw solid ' + color + '; }';
        document.head.appendChild(style);

        $('#picture-box-setting').css('border', '0.104vw solid ' + color);
        $("#right-inventory").html("");
        $('#id-card').show();
    } else if (event.data.action == "close:idCard") {
        $('#id-card').hide();
        idcardOpen = false;


    } else if (event.data.action == "trunk:WeightBarText") {


        let maxBarValue = maxWeightBarValue * event.data.weightTrunk / event.data.maxWeightTrunk//Math.floor(fillPercentage);
        
        weightBarCoffre.css("width", maxBarValue + "vw");     
        weightCoffre.text(event.data.textTrunk);
        textCoffre.text(event.data.plate);
        updateWeightBarColor(weightBarCoffre, event.data.weightTrunk, event.data.maxWeightTrunk);

    }
});

// ██╗     ███████╗███████╗████████╗    ██╗███╗   ██╗██╗   ██╗
// ██║     ██╔════╝██╔════╝╚══██╔══╝    ██║████╗  ██║██║   ██║
// ██║     █████╗  █████╗     ██║       ██║██╔██╗ ██║██║   ██║
// ██║     ██╔══╝  ██╔══╝     ██║       ██║██║╚██╗██║╚██╗ ██╔╝
// ███████╗███████╗██║        ██║       ██║██║ ╚████║ ╚████╔╝ 
// ╚══════╝╚══════╝╚═╝        ╚═╝       ╚═╝╚═╝  ╚═══╝  ╚═══╝  
                                                       


function inventorySetup(items, fastItems, crMenu, itemTrunk) {
    $("#left-inventory").html("");
    if (itemTrunk == 'no') {
        $("#right-inventory").html("");
    }


    if (Array.isArray(items)) {
      let itemsCount = items.length;
      
      $.each(items, function(index, item) {
        count = setCount(item);
        
        if (item.image == undefined) {
          item.image = '';
        }
      
        $("#left-inventory").append('<div class="item-info"><div id="item-' + index + '" class="item' + (item.rare ? ' rare-item' : '') + '" style="background-image: url(' + item.image + ')">' + itemNewBadge(item) + '<div class="item-count">' + count + '</div><div class="item-weight-tag">' + itemWeightLabel(item) + '</div><div class="item-name">' + item.label + '</div></div><div class="item-name-bg"></div></div>');
      
        $('#item-' + index).data('item', item);
        $('#item-' + index).data('inventory', 'main');
        applyRankStyle($('#item-' + index), item);
      });
      
      for (let i = 0; i < totalSlots - itemsCount; i++) {
        let currentIndex = itemsCount + i;
        $("#left-inventory").append('<div class="item-info"><div id="item-' + currentIndex + '" class="item"></div><div class="item-name-bg"></div></div>');
      }
      if (idcardOpen == false) {
        if (itemTrunk == 'no') {

            for (let i = 0; i < totalSlots; i++) {
                $("#right-inventory").append('<div class="item-info"><div id="item-' + i + '" class="item"></div><div class="item-name-bg"></div></div>');
            }
        }
      }
      
    } else {
      // Gérer le cas où items n'est pas un tableau
    //   console.error("items n'est pas un tableau");
    }
    
        $(".middle-bottom-slots").html("");
        if (crMenu == 'item') {
            $("#drop");
            var i;
            image = ''

            for (i = 1; i < 6; i++) {
                $(".middle-bottom-slots").append(
                    '<div class="middle-slot-box" id"itemDescr-' + i + '">'+
                        // '<div class="slot-count"> ' + i + '</div>'+
                        '<img class="slot-count" src="assets/icons/' + i + '_key.png" alt="">'+
                        // '<div class="slot-name"></div>'+
                        '<div id="itemFast-' + i + '" class="item" style = "background-image: url(' + image + ')">' +
                        '</div >'+
                    // '<div class="item-name-bg"></div>'+
                    '</div>'
                );
            }


            $.each(fastItems, function(index, item) {
                count = setCount(item);
                if (item.image == undefined ) {
                    item.image = ''
                }
                $('#itemFast-' + item.slot).html('<div class="slot-name">' + item.label + '</div>');
                // $('#itemFast-' + item.slot).html('<div class="slot-name">' + item.label + '</div> <div class="item-name-bg"></div>');
                $('#itemFast-' + item.slot).css("background-image", 'url(' + item.image + ')');
                $('#itemFast-' + item.slot).toggleClass('rare-item', !!item.rare);
                $('#itemFast-' + item.slot).data('item', item);
                $('#itemFast-' + item.slot).data('inventory', "fast");
                applyRankStyle($('#itemFast-' + item.slot), item);
            });
        }


    if (crMenu == 'clothe') {
        $("#drop");
    }
    makeDraggables()
    if (crMenu == 'item') {
        $("#drop");
    }
}

// ██████╗ ██╗ ██████╗ ██╗  ██╗████████╗    ██╗███╗   ██╗██╗   ██╗
// ██╔══██╗██║██╔════╝ ██║  ██║╚══██╔══╝    ██║████╗  ██║██║   ██║
// ██████╔╝██║██║  ███╗███████║   ██║       ██║██╔██╗ ██║██║   ██║
// ██╔══██╗██║██║   ██║██╔══██║   ██║       ██║██║╚██╗██║╚██╗ ██╔╝
// ██║  ██║██║╚██████╔╝██║  ██║   ██║       ██║██║ ╚████║ ╚████╔╝ 
// ╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝       ╚═╝╚═╝  ╚═══╝  ╚═══╝  
                                                               

function secondInventorySetup(items) {
    $("#right-inventory").html("");


    if (Array.isArray(items)) {
        let itemsCount = items.length;
        
        $.each(items, function(index, item) {
          count = setCount(item);
          
          if (item.image == undefined) {
            item.image = '';
          }
        
          $("#right-inventory").append('<div class="item-info"><div id="itemOther-' + index + '" class="item' + (item.locked ? ' locked' : '') + (item.rare ? ' rare-item' : '') + '" style = "background-image: url(' + item.image + ')">' + (item.locked ? '<i class="fas fa-lock lock-icon"></i>' : '') + itemNewBadge(item) + '<div class="item-count">' + count + '</div><div class="item-weight-tag">' + itemWeightLabel(item) + '</div><div class="item-name">' + item.label + '</div></div><div class="item-name-bg"></div></div>');

          $('#itemOther-' + index).data('item', item);
          $('#itemOther-' + index).data('inventory', "second");
          applyRankStyle($('#itemOther-' + index), item);
        });
        
        for (let i = 0; i < totalSlots - itemsCount; i++) {
            let currentIndex = itemsCount + i;
            $("#right-inventory").append('<div class="item-info"><div id="itemOther-' + currentIndex + '" class="item"></div><div class="item-name-bg"></div></div>');
        }

        initItemDraggable();

      } else {
        // Gérer le cas où items n'est pas un tableau
        // console.error("items n'est pas un tableau");
      }


}

// ███████╗██╗      ██████╗ ████████╗    
// ██╔════╝██║     ██╔═══██╗╚══██╔══╝    
// ███████╗██║     ██║   ██║   ██║       
// ╚════██║██║     ██║   ██║   ██║       
// ███████║███████╗╚██████╔╝   ██║       
// ╚══════╝╚══════╝ ╚═════╝    ╚═╝       
                                      

function updateSlot(fastItems, crMenu) {
    $(".middle-bottom-slots").html("");
    if (crMenu == 'item') {
        $("#drop");
        var i;
        image = ''

        for (i = 1; i < 6; i++) {
            $(".middle-bottom-slots").append(
                '<div class="middle-slot-box" id"itemDescr-' + i + '">'+
                    '<img class="slot-count" src="assets/icons/' + i + '_key.png" alt="">'+

                    // '<div class="slot-count">' + i + '</div>'+
                    // '<div class="slot-name"></div>'+
                    '<div id="itemFast-' + i + '" class="item" style = "background-image: url(' + image + ')">' +
                    '</div >'+
                // '<div class="item-name-bg"></div>'+
                '</div>'
            );
        }


        $.each(fastItems, function(index, item) {
            count = setCount(item);
            if (item.image == undefined ) {
                item.image = ''
            }
            $('#itemFast-' + item.slot).html('<div class="slot-name">' + item.label + '</div>');
            // $('#itemFast-' + item.slot).html('<div class="slot-name">' + item.label + '</div> <div class="item-name-bg"></div>');
            $('#itemFast-' + item.slot).css("background-image", 'url(' + item.image + ')');
            $('#itemFast-' + item.slot).toggleClass('rare-item', !!item.rare);
            $('#itemFast-' + item.slot).data('item', item);
            $('#itemFast-' + item.slot).data('inventory', "fast");
            applyRankStyle($('#itemFast-' + item.slot), item);
        });
    }

    if (crMenu == 'clothe') {
        $("#drop");
    }
    makeDraggables()
    if (crMenu == 'item') {
        $("#drop");
    }
}

function makeDraggables() {
    $('#itemFast-1').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "normal" && (itemInventory === "main" || itemInventory === "fast")) {
                disableInventory(500);
                $.post("http://esx_inventory/PutIntoFast", JSON.stringify({
                    item: itemData,
                    slot: 1
                }));
            }
        }
    });
    $('#itemFast-2').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "normal" && (itemInventory === "main" || itemInventory === "fast")) {
                disableInventory(500);
                $.post("http://esx_inventory/PutIntoFast", JSON.stringify({
                    item: itemData,
                    slot: 2
                }));
            }
        }
    });
    $('#itemFast-3').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "normal" && (itemInventory === "main" || itemInventory === "fast")) {
                disableInventory(500);
                $.post("http://esx_inventory/PutIntoFast", JSON.stringify({
                    item: itemData,
                    slot: 3
                }));
            }
        }
    });
    $('#itemFast-4').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "normal" && (itemInventory === "main" || itemInventory === "fast")) {
                disableInventory(500);
                $.post("http://esx_inventory/PutIntoFast", JSON.stringify({
                    item: itemData,
                    slot: 4
                }));
            }
        }
    });
    $('#itemFast-5').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "normal" && (itemInventory === "main" || itemInventory === "fast")) {
                disableInventory(500);
                $.post("http://esx_inventory/PutIntoFast", JSON.stringify({
                    item: itemData,
                    slot: 5
                }));
            }
        }
    });
}



$(function() {

    $('#button\\.raccourci-1').click(function() {
        $.post('http://esx_inventory/category', JSON.stringify({
            type: 'all'
        }));
    });

    $('#button\\.raccourci-2').click(function() {
        $.post('http://esx_inventory/category', JSON.stringify({
            type: 'item'
        }));
    });

    $('#button\\.raccourci-3').click(function() {
        $.post('http://esx_inventory/category', JSON.stringify({
            type: 'weapon'
        }));
    });

    $('#button\\.raccourci-4').click(function() {
        $.post('http://esx_inventory/category', JSON.stringify({
            type: 'clothes'
        }));
    });
    
})



// ██████╗ ██╗   ██╗████████╗████████╗ ██████╗ ███╗   ██╗
// ██╔══██╗██║   ██║╚══██╔══╝╚══██╔══╝██╔═══██╗████╗  ██║
// ██████╔╝██║   ██║   ██║      ██║   ██║   ██║██╔██╗ ██║
// ██╔══██╗██║   ██║   ██║      ██║   ██║   ██║██║╚██╗██║
// ██████╔╝╚██████╔╝   ██║      ██║   ╚██████╔╝██║ ╚████║
// ╚═════╝  ╚═════╝    ╚═╝      ╚═╝    ╚═════╝ ╚═╝  ╚═══╝
                                                      

function disableInventory(ms) {
    disabled = true;

    setInterval(function() {
        disabled = false;
    }, ms);
}

$(document).ready(function() {

    $(document).keydown(function(event) {
        if (event.which === 9 || event.which === 27) { // 9 = TAB, 27 = Escape (FIX: requested - Esc used to do nothing at all here)
            // While the keyboard text-input popup is up, let its own Escape
            // handler further down (on #textArea's keyup) just cancel that
            // input instead of also closing the whole inventory underneath it.
            if (event.which === 27 && $("#keyboard-input").is(":visible")) {
                return;
            }
            // Vérifier si l'inventaire est ouvert
            if (inventoryVisible) {
                $("#dialog").dialog("close");
        
                $(".form-inv").removeClass('visible');
                setTimeout(function() { $(".form-inv").css('display', 'none'); }, 180);
                inventoryVisible = false;
                $.post("http://esx_inventory/close",JSON.stringify())

                $(".item").remove();
                $(".menu").hide();
        
                const weightCoffre = $('#weightCoffre');
                const weightBarCoffre = $('#weightBarCoffre')
                const textCoffre = $('#plate')

                weightBarCoffre.css("width", 0 + "vw");     
                weightCoffre.text('');
                textCoffre.text('');
                
            }
        }
    });

    $('.middle-clothes-part-left .item-box').off().click(function(){
        $.post("http://esx_inventory/removeClothes",JSON.stringify({component:$(this).attr('id')}))
    })
    $('.middle-clothes-part-right .item-box2').off().click(function(){
        $.post("http://esx_inventory/removeClothes",JSON.stringify({component:$(this).attr('id')}))
    })



    $('#useItem').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            if (idcardOpen) {
                $('#id-card').hide();
            }
            itemData = ui.draggable.data("item");
            if (itemData.usable) {
                $.post("http://esx_inventory/useItem", JSON.stringify({
                    item: itemData,
                    // number: parseInt($("#count").val())
                }));
            }
        }
    });

    $('#giveItem').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            $.post("http://esx_inventory/giveItem", JSON.stringify({
                item: itemData,
                // number: parseInt($("#count").val())
            }));
        }
    });

    $('#renameItem').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            $.post("http://esx_inventory/renameItem", JSON.stringify({
                item: itemData,
                // number: parseInt($("#count").val())
            }));
        }
    });

    $('#deleteItem').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            $.post("http://esx_inventory/deleteItem", JSON.stringify({
                item: itemData,
                // number: parseInt($("#count").val())
            }));
        }
    });

    $('#dropItem').droppable({
        hoverClass: 'hoverControl',
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            $.post("http://esx_inventory/dropItem", JSON.stringify({
                item: itemData,
            }));
        }
    });

    
    
    $('#left-inventory').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "trunk" && itemInventory === "second") {
                disableInventory(500);
                $.post("http://esx_inventory/TakeFromTrunk", JSON.stringify({
                    item: itemData,
                    // number: parseInt($("#count").val())
                }));
            } else if (type === "property" && itemInventory === "second") {
                disableInventory(500);
                $.post("http://esx_inventory/TakeFromProperty", JSON.stringify({
                    item: itemData,
                    // number: parseInt($("#count").val())
                }));
            } else if (type === "normal" && itemInventory === "fast") {
                disableInventory(500);
                $.post("http://esx_inventory/TakeFromFast", JSON.stringify({
                    item: itemData
                }));
            } else if (type === "vault" && itemInventory === "second") {
                disableInventory(500);
                $.post("http://esx_inventory/TakeFromVault", JSON.stringify({
                    item: itemData,
                    // number: parseInt($("#count").val())
                }));
            } else if (type === "glovebox" && itemInventory === "second") {
                disableInventory(500);
                $.post("http://esx_inventory/TakeFromGlovebox", JSON.stringify({
                    item: itemData,
                }));
            } else if (type === "corpse" && itemInventory === "second") {
                disableInventory(500);
                $.post("http://esx_inventory/TakeFromCorpse", JSON.stringify({
                    item: itemData,
                }));
            } else if (type === "player" && itemInventory === "second") {
                disableInventory(500);
                $.post("http://esx_inventory/TakeFromPlayer", JSON.stringify({
                    item: itemData,
                    // number: parseInt($("#count").val())
                }));
            }
        }
    });

    $('#right-inventory').droppable({
        drop: function(event, ui) {
            itemData = ui.draggable.data("item");
            itemInventory = ui.draggable.data("inventory");

            if (type === "trunk" && itemInventory === "main") {
                disableInventory(500);
                $.post("http://esx_inventory/PutIntoTrunk", JSON.stringify({
                    item: itemData,
                }));
            } else if (type === "property" && itemInventory === "main") {
                disableInventory(500);
                $.post("http://esx_inventory/PutIntoProperty", JSON.stringify({
                    item: itemData,
                }));





            } else if (type === "vault" && itemInventory === "main") {
                disableInventory(500);
                $.post("http://esx_inventory/PutIntoVault", JSON.stringify({
                    item: itemData,
                    // number: parseInt($("#count").val())
                }));
            } else if (type === "glovebox" && itemInventory === "main") {
                disableInventory(500);
                $.post("http://esx_inventory/PutIntoGlovebox", JSON.stringify({
                    item: itemData,
                }));
            } else if (type === "player" && itemInventory === "main") {
                disableInventory(500);
                $.post("http://esx_inventory/PutIntoPlayer", JSON.stringify({
                    item: itemData,
                }));
            }
        }
    });



    document.getElementById("textArea").addEventListener("keyup", function(event) {
        event.preventDefault();
        if (event.keyCode === 13 && $("#keyboard-input").is(":visible") && $("#textArea").is(":focus")) {
        $.post("http://esx_inventory/send", JSON.stringify({"text": document.getElementById("textArea").value.trim()}));
        document.getElementById("textArea").value = "";
        $("#keyboard-input").hide();
        }
        if (event.keyCode === 27 && $("#keyboard-input").is(":visible") && $("#textArea").is(":focus")) {
        $.post("http://esx_inventory/cancel", JSON.stringify({}));
        document.getElementById("textArea").value = "";
        $("#keyboard-input").hide();
        }
    });
    
    $('#button\\.valider').click(function() {
        $.post("http://esx_inventory/send", JSON.stringify({"text": document.getElementById("textArea").value.trim()}));
        document.getElementById("textArea").value = "";
        $("#keyboard-input").hide();
    });

    $('#button\\.showButton').click(function(){
        $.post("http://esx_inventory/giveCard", JSON.stringify({
            info: idcard,
            type: idcardType
        }));
        $(".menu").hide();
    });
    $('#button\\.chooseButton').click(function(){

        $.post("http://esx_inventory/lookCard", JSON.stringify({
            info: idcard,
            type: idcardType
        }));
        $(".menu").hide();
    });

    $('#button\\.closeIdCard').click(function(){
        $('#id-card').hide();
        idcardOpen = false
        for (let i = 0; i < totalSlots; i++) {
            $("#right-inventory").append('<div class="item-info"><div id="item-' + i + '" class="item"></div><div class="item-name-bg"></div></div>');
        }
    });
});





  


$.widget('ui.dialog', $.ui.dialog, {
    options: {
        // Determine if clicking outside the dialog shall close it
        clickOutside: false,
        // Element (id or class) that triggers the dialog opening 
        clickOutsideTrigger: ''
    },
    open: function() {
        var clickOutsideTriggerEl = $(this.options.clickOutsideTrigger),
            that = this;
        if (this.options.clickOutside) {
            // Add document wide click handler for the current dialog namespace
            $(document).on('click.ui.dialogClickOutside' + that.eventNamespace, function(event) {
                var $target = $(event.target);
                if ($target.closest($(clickOutsideTriggerEl)).length === 0 &&
                    $target.closest($(that.uiDialog)).length === 0) {
                    that.close();
                }
            });
        }
        // Invoke parent open method
        this._super();
    },
    close: function() {
        // Remove document wide click handler for the current dialog
        $(document).off('click.ui.dialogClickOutside' + this.eventNamespace);
        // Invoke parent close method 
        this._super();
    },
});








// ███╗   ██╗ ██████╗ ████████╗██╗███████╗██╗ ██████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗
// ████╗  ██║██╔═══██╗╚══██╔══╝██║██╔════╝██║██╔════╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║
// ██╔██╗ ██║██║   ██║   ██║   ██║█████╗  ██║██║     ███████║   ██║   ██║██║   ██║██╔██╗ ██║
// ██║╚██╗██║██║   ██║   ██║   ██║██╔══╝  ██║██║     ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║
// ██║ ╚████║╚██████╔╝   ██║   ██║██║     ██║╚██████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║
// ╚═╝  ╚═══╝ ╚═════╝    ╚═╝   ╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
                                                                                         

var currentNotification = null;

function NotifyDefault( message, timeout) {
    var count = 1;
    
    if (currentNotification == 1) {
        return;
    }
    if (currentNotification == undefined) {
        currentNotification = 1;
    }

    $(".notification").prepend(`        
        <div class="notify-without-icon" id="notifydef-${count}">
            <div class="content-notify-without-icon">
                <div class="notify-without-icon-text">
                    <span>${message}</span>
                </div>
            </div>
            <div class="progress-bar-notifi-without-icon"></div>
        </div>
    `);

    var notificationEl = $(`#notifydef-${count}`);
    
    var progressEl = notificationEl.find(`.progress-bar-notifi-without-icon`);
    var startTime = Date.now();
    
    var interval = setInterval(function() {
        var elapsedTime = Date.now() - startTime;
        var percentage = elapsedTime / timeout * 100;

        if (percentage >= 100) {
            clearInterval(interval);
			setTimeout(() => {
				notificationEl.addClass("hidden");
			}, 150);

			setTimeout(() => {
				notificationEl.remove()
                currentNotification = null;

			}, 600);
        } else {
            progressEl.css("width", `${percentage}%`);
        }
    }, 10);

    count++;
}


function NotifyItem(message, icon, number) {
    var count = 1;

    if (icon == undefined ) {
        icon = ''
    }

    $(".iconNotif").prepend(`
        <div class="notify-with-icon" id="notify-${count}"">
            <div class="content-notify-with-icon">
            <img src="${icon}" alt="">

            </div>
            <div class="notify-with-icon-text">
                <span>${message}</span>
            </div>
            <div class="notify-with-icon-count">
                <span>${number}</span>
            </div>
        </div>
    `);

    var notificationEl = $(`#notify-${count}`);
    // var progressEl = notificationEl.find(`.progress-bar-notifi-with-icon`);
    var startTime = Date.now();

    var interval = setInterval(function() {
        var elapsedTime = Date.now() - startTime;
        var percentage = elapsedTime / 3000 * 100;

        if (percentage >= 100) {
            clearInterval(interval);
			setTimeout(() => {
				notificationEl.addClass("hidden");
			}, 150);

			setTimeout(() => {
				notificationEl.remove()
			}, 600);
        } else {
            // progressEl.css("width", `${percentage}%`);
        }
    }, 10);

    count++;
}


// TEXT NOTIFIACTION



function isDefined(param) {
    return typeof param !== "undefined" && param !== null;
}

function format(text) {
    var everColoring = false;
    var currentColor = "";
    var finalText = "";
    for (var i = 0; i < text.length; i++) {
        if(text[i] === "~"){
            var INFO = '';
            i++;
            while (text[i] != "~") {
                INFO += text[i];
                i++;
            }
            if (isDefined(config_text_color[INFO])){
                currentColor = config_text_color[INFO];
                if (!everColoring) {
                    finalText += "<span style=\"color: " + currentColor + "\">";
                    everColoring = true;
                } else {
                    finalText += "</span><span style=\"color: " + currentColor + "\">";
                }
            } else if(isDefined(config_text_fonts[INFO])){
                currentColor = config_text_fonts[INFO];
                if (!everColoring) {
                    finalText += "<span style=\"" + currentColor + "\">";
                    everColoring = true;
                } else {
                    finalText += "</span><span style=\"" + currentColor + "\">";
                }
            } else if(isDefined(Keys[INFO])){
                finalText += "<span class=\"key\">" + Keys[INFO] + "</span>";
            }

        } else {
            finalText += text[i];
        }
    }
    if (everColoring) {
        finalText += "</span>";
    }
    return finalText;
}

function GTA_PICTURE(id) {
    if (isDefined(Picture[id])) {
        return "assets/images/" + Picture[id];
    } else {
        return false;
    }
}



// FUNCTION INVENTORY

// FORMAT ACCOUNT FOR ALL ITEM

function setCount(item) {
    count = item.count

    if (item.limit > 0) {
        count = item.count
    }

    if (item.type === "item_weapon") {
        count = 1;
    }
    if (item.type === "item_idcard") {
        count = "";
        // if (count == 0) {
        //     count = "";
        // } else {
        //     count = '<img src="img/bullet.png" class="ammoIcon"> ' + item.ammo;
        // }
    }

    if (item.type === "item_account" || item.type === "item_money") {
        count = formatMoney(item.count);
    }

    return count;
}

// FORMAT ACCOUT 

function formatMoney(n, c, d, t) {
    var c = isNaN(c = Math.abs(c)) ? 2 : c,
        d = d == undefined ? "." : d,
        t = t == undefined ? "," : t,
        s = n < 0 ? "-" : "",
        i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))),
        j = (j = i.length) > 3 ? j % 3 : 0;

    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t);
};

// CLIQUE DROIT (legacy quick-use on right click, kept for anyone relying
// on the old single-click-use flow; the new context menu below is the
// primary right-click interaction and takes over the actual click via
// contextmenu preventDefault, so this mousedown handler no longer fires
// for items - only non-item targets, if any, ever reach it.)

$(document).mousedown(function(event) {

    if (event.which != 3) return

    itemData = $(event.target).data("item");

    if (itemData == undefined || itemData.usable == undefined) {
        return;
    }

});


// ██████╗ ██╗ ██████╗ ██╗  ██╗████████╗    ███╗   ███╗███████╗███╗   ██╗██╗   ██╗
// Right-click context menu: Use / Give / Drop / Inspect

var contextMenuItemEl = null;

$(document).on('contextmenu', '.item', function(e) {
    var itemData = $(this).data('item');
    if (!itemData) return; // empty slot - let the browser default (nothing) happen
    e.preventDefault();

    contextMenuItemEl = $(this);

    var droppable = !(itemData.type === 'item_vetement' || itemData.type === 'item_idcard' || itemData.type === 'item_phone');

    $('#itemContextMenu .context-item[data-action="use"]').toggle(!!itemData.usable);
    $('#itemContextMenu .context-item[data-action="give"]').toggle(itemData.type !== 'item_idcard');
    $('#itemContextMenu .context-item[data-action="drop"]').toggle(droppable);
    $('#itemContextMenu .context-item[data-action="scan"]').toggle(itemData.type === 'item_weapon');

    var $menu = $('#itemContextMenu');
    var x = e.pageX, y = e.pageY;
    var menuW = 160, menuH = 160;
    if (x + menuW > window.innerWidth) x -= menuW;
    if (y + menuH > window.innerHeight) y -= menuH;

    $menu.css({ left: x + 'px', top: y + 'px' }).addClass('visible');
});

$(document).on('click', function(e) {
    if (!$(e.target).closest('#itemContextMenu').length) {
        $('#itemContextMenu').removeClass('visible');
    }
});

$(document).on('click', '#itemContextMenu .context-item', function() {
    if (!contextMenuItemEl) return;
    var itemData = contextMenuItemEl.data('item');
    var action = $(this).data('action');

    if (itemData) {
        if (action === 'use') {
            $.post("http://esx_inventory/useItem", JSON.stringify({ item: itemData }));
        } else if (action === 'give') {
            $.post("http://esx_inventory/giveItem", JSON.stringify({ item: itemData }));
        } else if (action === 'drop') {
            $.post("http://esx_inventory/dropItem", JSON.stringify({ item: itemData }));
        } else if (action === 'scan') {
            $.post("http://esx_inventory/scanWeapon", JSON.stringify({ item: itemData }));
        } else if (action === 'inspect') {
            openInspect(itemData);
        }
    }

    $('#itemContextMenu').removeClass('visible');
});

// ██╗███╗   ██╗███████╗██████╗ ███████╗ ██████╗████████╗
// Inspect modal

function openInspect(itemData) {
    $('#itemInspectImage').attr('src', itemData.image || '');
    $('#itemInspectLabel').text(itemData.label || itemData.name || '');

    var rank = itemData.rank || 'common';
    $('#itemInspectRank').text(rank.charAt(0).toUpperCase() + rank.slice(1));
    RANK_ORDER.forEach(function(r) { $('#itemInspectRank').removeClass('rank-text-' + r); });
    $('#itemInspectRank').addClass('rank-text-' + rank);

    var count = (itemData.type === 'item_weapon') ? 1 : (itemData.count || 1);
    $('#itemInspectCount').text(count);

    var totalWeight = itemData.weight ? (itemData.weight * count).toFixed(1) + 'kg' : '—';
    $('#itemInspectWeight').text(totalWeight);

    $('#itemInspect').addClass('visible');
}

$(document).on('click', '#itemInspectClose', function() {
    $('#itemInspect').removeClass('visible');
});
$(document).on('click', '#itemInspect', function(e) {
    if (e.target.id === 'itemInspect') {
        $('#itemInspect').removeClass('visible');
    }
});

// ██████╗ ██████╗     ██████╗ ██████╗ ███████╗██╗   ██╗██╗███████╗██╗    ██╗
// Lightweight "3D-ish" hover preview: since item icons are flat 2D images
// (not real 3D models), a real rotating 3D render isn't possible here -
// this gives a tilt/parallax feel driven by cursor position instead, which
// is the honest equivalent achievable with a 2D icon.
$(document).on('mousemove', '.item', function(e) {
    var itemData = $(this).data('item');
    if (!itemData || $(this).hasClass('locked')) return;

    var rect = this.getBoundingClientRect();
    var px = (e.clientX - rect.left) / rect.width;   // 0..1
    var py = (e.clientY - rect.top) / rect.height;   // 0..1
    var rotateY = (px - 0.5) * 22;  // deg
    var rotateX = (0.5 - py) * 22;  // deg

    $(this).css('transform', 'perspective(400px) scale(1.12) rotateX(' + rotateX + 'deg) rotateY(' + rotateY + 'deg)');
    $(this).css('z-index', 50);
});

$(document).on('mouseleave', '.item', function() {
    $(this).css('transform', '');
    $(this).css('z-index', '');
});



// ██╗  ██╗██╗   ██╗██████╗ 
// ██║  ██║██║   ██║██╔══██╗
// ███████║██║   ██║██║  ██║
// ██╔══██║██║   ██║██║  ██║
// ██║  ██║╚██████╔╝██████╔╝
// ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ 
                         

if (config.activeHud) {
    $(document).ready(function () {
        HealthIndicator = new ProgressBar.Circle("#HealthIndicator", {
        color: config.colorHud,
        trailColor: "rgb(80, 80, 80)",
        strokeWidth: 10,
        trailWidth: 10,
        duration: 2000,
        easing: "easeInOut",
        });
    
        ArmorIndicator = new ProgressBar.Circle("#ArmorIndicator", {
        color: config.colorHud,
        trailColor: "rgb(80, 80, 80)",
        strokeWidth: 10,
        trailWidth: 10,
        duration: 2000,
        easing: "easeInOut",
        });
    
        HungerIndicator = new ProgressBar.Circle("#HungerIndicator", {
        color: config.colorHud,
        trailColor: "rgb(80, 80, 80)",
        strokeWidth: 10,
        trailWidth: 10,
        duration: 2000,
        easing: "easeInOut",
        });
    
        ThirstIndicator = new ProgressBar.Circle("#ThirstIndicator", {
        color: config.colorHud,
        trailColor: "rgb(80, 80, 80)",
        strokeWidth: 10,
        trailWidth: 10,
        duration: 2000,
        easing: "easeInOut",
        });
    
    });
}
