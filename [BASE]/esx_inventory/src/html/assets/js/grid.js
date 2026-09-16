/* ===================================================================
   GRID  —  #1 slot drag & drop, #2 stack limit, #3 drag-to-ground,
            #5 note badge, #15 backpack band, #23 movement animation
   ===================================================================

   Renders into the SAME #left-inventory container and the SAME
   `.item-info > .item` markup the rest of the NUI already keys off, so
   search, sort, the context menu, the inspect modal, the rank glow and
   the hotbar droppables all keep working untouched. The only structural
   addition is `data-slot` on each cell, which is what makes a cell a
   real grid position instead of a list index.

   Standard items live in the grid. Weapons / clothing / accounts / ID
   cards do NOT — they live in separate server-side stores (loadout,
   lc_clothes, accounts) with no slot concept, so they are appended
   after the grid as non-droppable cells. Pretending otherwise would
   mean inventing a slot map for data the server can't persist one for.
   =================================================================== */

var GRID = {
    data: null,
    extras: [],        // non-standard items, captured from the legacy setItems
    lastCounts: {},    // slot -> count, used to animate only what changed
};

/* ---------- helpers ------------------------------------------------ */

function gridStackText(entry) {
    if (!entry) return '';
    if (entry.count === undefined || entry.count === null) return '';
    // #2: show the cap when the stack is full, so "why won't it merge"
    // has a visible answer instead of being silent.
    if (entry.stackLimit && entry.count >= entry.stackLimit) {
        return entry.count + '<span class="stack-full">/' + entry.stackLimit + '</span>';
    }
    return entry.count;
}

function gridSlotKey(entry) {
    if (!entry) return null;
    if (entry.type === 'item_weapon' && entry.serial) return 'weapon:' + entry.serial;
    if (entry.type === 'item_vetement' && entry.id) return 'clothe:' + entry.id;
    if (entry.name) return 'item:' + entry.name;
    return null;
}

function gridCellHtml(id, entry, slot, extraClass) {
    var cls = 'item' + (entry && entry.rare ? ' rare-item' : '') + (extraClass ? ' ' + extraClass : '');
    var bg = (entry && entry.image) ? entry.image : '';

    var inner = '';
    if (entry) {
        inner += itemNewBadge(entry);
        // #5: a small dog-ear marks an item that carries a description,
        // so a note isn't invisible until you happen to inspect it.
        if (entry.note) inner += '<div class="item-note-flag" title="' + $('<div>').text(entry.note).html() + '"><i class="fas fa-sticky-note"></i></div>';
        inner += '<div class="item-count">' + gridStackText(entry) + '</div>';
        inner += '<div class="item-weight-tag">' + itemWeightLabel(entry) + '</div>';
        inner += '<div class="item-name">' + entry.label + '</div>';
    }

    return '<div class="item-info"' + (slot !== null && slot !== undefined ? ' data-slot="' + slot + '"' : '') + '>'
         + '<div id="' + id + '" class="' + cls + '" style="background-image: url(' + bg + ')">' + inner + '</div>'
         + '<div class="item-name-bg"></div>'
         + '</div>';
}

/* ---------- render ------------------------------------------------- */

function renderGrid() {
    if (!GRID.data) return;

    var d = GRID.data;
    var $c = $('#left-inventory');
    $c.html('');

    var normal = d.normalSlots || 50;
    var bpStart = d.backpackStart || 101;
    var bpCount = d.backpackCount || 0;

    // --- normal band -------------------------------------------------
    for (var s = 1; s <= normal; s++) {
        var entry = d.slots[String(s)] || null;
        $c.append(gridCellHtml('gslot-' + s, entry, s));
    }

    // --- #15 backpack band -------------------------------------------
    if (bpCount > 0) {
        $c.append('<div class="grid-band-label"><i class="fas fa-suitcase-rolling"></i> '
                + (window._U ? _U('backpack_band') : 'Backpack') + '</div>');
        for (var b = 0; b < bpCount; b++) {
            var slot = bpStart + b;
            $c.append(gridCellHtml('gslot-' + slot, d.slots[String(slot)] || null, slot, 'backpack-slot'));
        }
    }

    // --- non-slot stores (weapons / clothes / accounts / cards) -------
    if (GRID.extras.length) {
        $c.append('<div class="grid-band-label"><i class="fas fa-layer-group"></i> '
                + (window._U ? _U('other_band') : 'Equipment') + '</div>');
        $.each(GRID.extras, function(i, item) {
            $c.append(gridCellHtml('gextra-' + i, item, null, 'no-slot'));
        });
    }

    // --- overflow: owned but with nowhere to sit ----------------------
    // Never hidden. If the grid is full the items still exist server-side
    // and the player has to be able to see that, or a full inventory
    // looks exactly like item loss.
    if (d.unplaced && d.unplaced.length) {
        $c.append('<div class="grid-band-label overflow"><i class="fas fa-triangle-exclamation"></i> '
                + (window._U ? _U('overflow_band') : 'No free slot') + '</div>');
        $.each(d.unplaced, function(i, item) {
            $c.append(gridCellHtml('goverflow-' + i, item, null, 'no-slot overflow-item'));
        });
    }

    // --- bind data ----------------------------------------------------
    for (var s2 = 1; s2 <= normal; s2++) bindCell('gslot-' + s2, d.slots[String(s2)], s2);
    for (var b2 = 0; b2 < bpCount; b2++) {
        var sl = bpStart + b2;
        bindCell('gslot-' + sl, d.slots[String(sl)], sl);
    }
    $.each(GRID.extras, function(i, item) { bindCell('gextra-' + i, item, null); });
    $.each(d.unplaced || [], function(i, item) { bindCell('goverflow-' + i, item, null); });

    // weight bar
    if (d.maxWeight > 0) {
        var $bar = $('#weightBar');
        $bar.css('width', (28.2 / d.maxWeight * d.weight) + 'vw');
        $('#weight').text(d.weight.toFixed(1) + ' / ' + d.maxWeight + 'KG');
        updateWeightBarColor($bar, d.weight, d.maxWeight);
    }

    initItemDraggable();
    initGridDroppables();
    filterInventoryItems($('#itemSearch').val());
    animateChanges();
}

function bindCell(id, entry, slot) {
    var $el = $('#' + id);
    if (!entry) return;
    entry.slot = slot;
    entry.slotKey = gridSlotKey(entry);
    $el.data('item', entry);
    $el.data('inventory', 'main');
    applyRankStyle($el, entry);
}

/* ---------- #23 movement animation --------------------------------- */
// Deliberately cheap: a short scale/fade pulse on cells whose contents
// actually changed since the last render. A full FLIP animation would
// need stable element identity across a full re-render, which fights the
// "server is the only source of truth, always redraw" model this grid is
// built on - and a wrong-but-smooth animation is worse than an honest
// pulse, because it implies a move the server may have rejected.
function animateChanges() {
    if (!GRID.data) return;
    var next = {};
    var d = GRID.data;

    $('#left-inventory .item-info[data-slot]').each(function() {
        var slot = $(this).data('slot');
        var entry = d.slots[String(slot)];
        var sig = entry ? (entry.name + ':' + entry.count) : '';
        next[slot] = sig;

        if (GRID.lastCounts[slot] !== undefined && GRID.lastCounts[slot] !== sig) {
            var $item = $(this).find('.item');
            $item.removeClass('slot-changed');
            // force reflow so the class re-triggers on a repeat change
            void $item[0].offsetWidth;
            $item.addClass('slot-changed');
        }
    });

    GRID.lastCounts = next;
}

/* ---------- #1/#2/#3 drag targets ---------------------------------- */

var gridDragShift = false;
$(document).on('keydown keyup', function(e) { gridDragShift = !!e.shiftKey; });

function initGridDroppables() {
    $('#left-inventory .item-info[data-slot]').droppable({
        greedy: true,          // a cell inside the container must win over
                               // #left-inventory's own droppable, otherwise
                               // every in-grid drag also fires TakeFromFast
        hoverClass: 'slot-hover',
        tolerance: 'pointer',
        drop: function(event, ui) {
            var to = $(this).data('slot');
            var item = ui.draggable.data('item');
            if (!item) return;

            // Dragging a hotbar entry onto the grid is an unbind, not a
            // move - leave that to the existing TakeFromFast handler.
            if (ui.draggable.data('inventory') === 'fast') return;

            var from = item.slot;
            if (from === undefined || from === null) return; // non-slot store
            if (from === to) return;

            if (gridDragShift || event.shiftKey) {
                $.post('http://esx_inventory/grid:split', JSON.stringify({ from: from, to: to }));
            } else {
                $.post('http://esx_inventory/grid:move', JSON.stringify({ from: from, to: to }));
            }
        }
    });
}

// #3 — released outside the inventory window entirely => throw it on the
// ground. Checked against the panel's real bounding box rather than a
// dedicated drop zone, so there is nothing to aim at: anywhere outside
// works, which is what players expect from this gesture.
$(document).on('mouseup', function(e) {
    if (!window.__gridDragging) return;
    var item = window.__gridDragging;
    window.__gridDragging = null;

    if (item.slot === undefined || item.slot === null) return;

    var panel = document.querySelector('.form-inv .inventory');
    if (!panel) return;
    var r = panel.getBoundingClientRect();
    var inside = e.clientX >= r.left && e.clientX <= r.right
              && e.clientY >= r.top  && e.clientY <= r.bottom;
    if (inside) return;

    // also ignore drops onto the action buttons / centre panel, which
    // have their own meanings (use / give / rename / delete / drop)
    if ($(e.target).closest('.center-part, .middle-slot-box, .top-buttons-center-part').length) return;

    $.post('http://esx_inventory/grid:dropToGround', JSON.stringify({
        slot: item.slot,
        all: !(gridDragShift || e.shiftKey)   // shift => ask for a quantity
    }));
});

// record what's being dragged so the mouseup above knows
$(document).on('dragstart mousedown', '.item', function() {
    var d = $(this).data('item');
    if (d) window.__gridDragging = d;
});

/* ---------- message hooks ------------------------------------------ */

window.addEventListener('message', function(event) {
    var a = event.data.action;

    if (a === 'grid:set') {
        GRID.data = event.data.grid;
        renderGrid();

    } else if (a === 'setItems') {
        // Capture only the stores the grid does NOT own. The legacy
        // handler in inventory.js still runs and still paints the list;
        // renderGrid() runs after and replaces #left-inventory, so the
        // grid wins whenever it has data.
        var list = event.data.itemList || [];
        GRID.extras = [];
        for (var i = 0; i < list.length; i++) {
            if (list[i].type !== 'item_standard') GRID.extras.push(list[i]);
        }
        if (GRID.data) renderGrid();

    } else if (a === 'close:Inv') {
        GRID.lastCounts = {};
        window.__gridDragging = null;

    } else if (a === 'open:History') {
        renderHistory(event.data.history);
    }
});

/* ---------- #7 / #8 custody panel ----------------------------------- */

function renderHistory(h) {
    if (!h) return;

    var rows = '';
    if (!h.entries || !h.entries.length) {
        rows = '<div class="hist-empty">' + (window._U ? _U('hist_empty') : 'No recorded history for this serial.') + '</div>';
    } else {
        for (var i = 0; i < h.entries.length; i++) {
            var e = h.entries[i];
            rows += '<div class="hist-row">'
                  + '<span class="hist-when">' + (e.created_at || '') + '</span>'
                  + '<span class="hist-via via-' + (e.via || 'unknown') + '">' + (e.via || '?') + '</span>'
                  + '<span class="hist-who">' + (e.from_name || '—') + ' <i class="fas fa-arrow-right"></i> ' + (e.to_name || '—') + '</span>'
                  + '</div>';
        }
    }

    var banner = '';
    if (h.stolen && h.stolen.status === 'stolen') {
        banner = '<div class="hist-stolen"><i class="fas fa-triangle-exclamation"></i> '
               + (window._U ? _U('hist_stolen') : 'REPORTED STOLEN')
               + ' — ' + (h.stolen.reported_name || '?')
               + (h.stolen.note ? ' (' + $('<div>').text(h.stolen.note).html() + ')' : '')
               + '</div>';
    }

    $('#weaponHistory .hist-serial').text('#' + h.serial);
    $('#weaponHistory .hist-body').html(banner + rows);
    $('#weaponHistory').addClass('visible');
}

$(document).on('click', '#weaponHistoryClose, #weaponHistory', function(e) {
    if (e.target.id === 'weaponHistory' || e.target.id === 'weaponHistoryClose') {
        $('#weaponHistory').removeClass('visible');
    }
});

/* ---------- extra context-menu actions ------------------------------ */
// Appended to the existing menu rather than replacing it, so the
// original Use/Give/Drop/Scan/Inspect wiring in inventory.js is
// untouched.

$(document).on('contextmenu', '.item', function() {
    var d = $(this).data('item');
    if (!d) return;
    $('#ctxNoteItem').toggle(!!d.slotKey);
    $('#ctxHistoryItem').toggle(d.type === 'item_weapon' && !!d.serial);
    $('#ctxStolenItem').toggle(d.type === 'item_weapon' && !!d.serial);
});

$(document).on('click', '#itemContextMenu .context-item', function() {
    var action = $(this).data('action');
    if (action !== 'note' && action !== 'history' && action !== 'stolen') return;

    var $src = (typeof contextMenuItemEl !== 'undefined') ? contextMenuItemEl : null;
    if (!$src) return;
    var d = $src.data('item');
    if (!d) return;

    if (action === 'note') {
        $.post('http://esx_inventory/grid:editNote', JSON.stringify({ slotKey: d.slotKey }));
    } else if (action === 'history') {
        $.post('http://esx_inventory/grid:weaponHistory', JSON.stringify({ serial: d.serial }));
    } else if (action === 'stolen') {
        $.post('http://esx_inventory/grid:reportStolen', JSON.stringify({ serial: d.serial, name: d.name }));
    }
    $('#itemContextMenu').removeClass('visible');
});

/* ---------- #14 backpack search panel ------------------------------- */
// Read-only on purpose. Letting an officer pull items straight out of
// this panel would be a second, parallel transfer path that bypasses
// every check in lgd:putToPlayer - the existing /fouiller flow is the
// one audited route for actually taking something, and it should stay
// the only one.

window.addEventListener('message', function(event) {
    if (event.data.action !== 'open:BagSearch') return;

    var items = event.data.items || [];
    var html = '';

    if (!items.length) {
        html = '<div class="hist-empty">' + (event.data.empty || 'The backpack is empty.') + '</div>';
    } else {
        html = '<div class="bag-grid">';
        for (var i = 0; i < items.length; i++) {
            var it = items[i];
            html += '<div class="bag-cell">'
                  + '<div class="bag-icon" style="background-image:url(' + (it.image || '') + ')"></div>'
                  + '<div class="bag-count">' + it.count + '</div>'
                  + '<div class="bag-label">' + $('<div>').text(it.label || it.name).html() + '</div>'
                  + '</div>';
        }
        html += '</div>';
    }

    $('#bagSearchLabel').text(event.data.label || '');
    $('#bagSearch .bag-body').html(html);
    $('#bagSearch').addClass('visible');
});

function closeBagSearch() {
    $('#bagSearch').removeClass('visible');
    $.post('http://esx_inventory/closeBagSearch', JSON.stringify({}));
}

$(document).on('click', '#bagSearchClose', closeBagSearch);
$(document).on('click', '#bagSearch', function(e) {
    if (e.target.id === 'bagSearch') closeBagSearch();
});
$(document).on('keydown', function(e) {
    if (e.which === 27 && $('#bagSearch').hasClass('visible')) closeBagSearch();
});
