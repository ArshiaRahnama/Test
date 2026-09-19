/* ===================================================================
   GROUND PANEL  —  round 5
   ===================================================================

   "Open the inventory while standing next to something on the floor and
   it shows up in the RIGHT panel, so you can drag it across into your
   own inventory."

   That is exactly how the trunk / stash / property panels already
   behave, so this reuses their shape rather than inventing a fourth
   interaction: the right panel is the world, the left panel is you.

   Why this is NOT wired through the existing `type` variable
   ----------------------------------------------------------
   `type` ("normal" / "trunk" / "property" / ...) also gates the hotbar:
   `PutIntoFast` and `TakeFromFast` only fire while `type === "normal"`.
   Setting `type = "ground"` to get a right panel would have silently
   killed the 1-5 hotbar for as long as anything was lying nearby. The
   ground panel is a flag alongside `type`, not a value of it.

   Why this does NOT call .droppable() on #left-inventory /
   #right-inventory
   ----------------------------------------------------------
   Those two elements already have a droppable() with the trunk / stash
   / vault / glovebox / corpse routing on it. Calling .droppable() again
   on the same element REPLACES the options — it would have deleted all
   of that. Routing is done off jQuery UI's own `dragstop` instead, and
   the existing handlers simply find no matching branch for a ground
   item, so they no-op on their own.
   =================================================================== */

var GROUND = {
    active: false,
    items: [],
    x: 0,
    y: 0,
};

document.addEventListener('mousemove', function(e) {
    GROUND.x = e.clientX;
    GROUND.y = e.clientY;
}, { passive: true });

/* ---------- render -------------------------------------------------- */

function renderGround() {
    var $c = $('#right-inventory');
    $c.html('');

    // title goes where a trunk would put its plate, so both panels read
    // the same way instead of the ground panel inventing its own header
    // under an empty, unexplained weight bar
    $('.form-inv').addClass('ground-active');
    $('#plate').text(window._U ? _U('ground_band') : 'On the ground');
    $('#weightCoffre').text('');

    if (!GROUND.items.length) {
        $c.append('<div class="ground-empty">'
                + (window._U ? _U('ground_empty') : 'Nothing nearby.') + '</div>');
        return;
    }

    $.each(GROUND.items, function(i, item) {
        if (!item) return;
        if (item.image === undefined || item.image === null) item.image = '';

        var id = 'ground-' + i;
        var inner = '<div class="item-count">' + setCount(item) + '</div>'
                  + '<div class="item-weight-tag">' + itemWeightLabel(item) + '</div>'
                  + '<div class="item-name">' + item.label + '</div>';

        $c.append('<div class="item-info"><div id="' + id + '" class="item'
                + (item.rare ? ' rare-item' : '') + '" style="background-image: url('
                + item.image + ')">' + inner + '</div></div>');

        var $el = $('#' + id);
        $el.data('item', item);
        $el.data('inventory', 'ground');
        applyRankStyle($el, item);
    });

    // pad the rest of the row so a single item doesn't sit alone in a
    // panel that looks broken
    var pad = (5 - (GROUND.items.length % 5)) % 5;
    for (var p = 0; p < pad; p++) {
        $c.append('<div class="item-info"><div class="item"></div></div>');
    }

    initItemDraggable();
}

/* ---------- messages ------------------------------------------------ */

window.addEventListener('message', function(event) {
    var a = event.data.action;

    if (a === 'setGroundItems') {
        GROUND.items = event.data.itemList || [];
        GROUND.active = true;
        renderGround();

    } else if (a === 'close:Inv') {
        GROUND.active = false;
        GROUND.items = [];
        $('#right-inventory').removeClass('ground-target');
        $('.form-inv').removeClass('ground-active');

    } else if (a === 'setSecondInventoryItems') {
        // a trunk / stash / corpse took the right panel over: the ground
        // panel must get out of the way or two systems would both think
        // they own it
        GROUND.active = false;
        GROUND.items = [];
        $('.form-inv').removeClass('ground-active');
    }
});

/* ---------- drag routing -------------------------------------------- */

function groundElementUnder(x, y) {
    var el = document.elementFromPoint(x, y);
    if (!el) return null;
    if ($(el).closest('#right-inventory').length) return 'right';
    if ($(el).closest('#left-inventory').length) return 'left';
    return null;
}

$(document).on('dragstart', '.item', function() {
    if (!GROUND.active) return;
    var inv = $(this).data('inventory');
    if (inv === 'main' || inv === 'fast') {
        $('#right-inventory').addClass('ground-target');
    }
});

$(document).on('dragstop', '.item', function() {
    $('#right-inventory').removeClass('ground-target');
    if (!GROUND.active) return;

    var item = $(this).data('item');
    if (!item) return;
    var inv = $(this).data('inventory');
    var over = groundElementUnder(GROUND.x, GROUND.y);
    if (!over) return;

    // me -> the floor
    if (over === 'right' && (inv === 'main' || inv === 'fast')) {
        disableInventory(400);
        $.post('http://esx_inventory/PutIntoGround', JSON.stringify({ item: item }));
        return;
    }

    // the floor -> me
    if (over === 'left' && inv === 'ground') {
        disableInventory(400);
        $.post('http://esx_inventory/TakeFromGround', JSON.stringify({
            dropId: item.dropId
        }));
    }
});

/* Double-click a ground item to take it, for anyone who would rather not
   drag. Same server path, so it inherits the same distance check. */
$(document).on('dblclick', '.item', function() {
    if (!GROUND.active) return;
    if ($(this).data('inventory') !== 'ground') return;
    var item = $(this).data('item');
    if (!item) return;
    disableInventory(400);
    $.post('http://esx_inventory/TakeFromGround', JSON.stringify({ dropId: item.dropId }));
});
