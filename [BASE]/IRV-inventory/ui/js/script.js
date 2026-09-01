const floatRound = (_0x47e768) => {
    return Math.round((_0x47e768 + Number.EPSILON) * 100) / 100
  }
  let loadout = { items: [] },
    sideLoadout = null,
    side,
    excludedExtras = ['key', 'mask'],
    mouseOverTooltip = false
  $('.tooltip').on('mouseenter', () => {
    mouseOverTooltip = true
  })
  $('.tooltip').on('mouseout', () => {
    mouseOverTooltip = false
  })
  let itemTemplate = $('.item-slot')[0].outerHTML,
    canDrop = false
  $('.item-slot').remove()
  let itemsPos = JSON.parse(localStorage.getItem('inventory_itemsPos')) || []
  $(document).ready(function () {
    $('.inventory.main .crafting-slot').droppable({
      drop: function (_0x386d17, _0x2d13f7) {
        let _0x48de57 = _0x2d13f7.draggable
            .parent()
            .parent()
            .parent()
            .hasClass('side')
            ? 'side'
            : 'main',
          _0xa53c8c = $(this).parent().parent().hasClass('side')
            ? 'side'
            : 'main',
          _0x4d000d =
            _0x48de57 == 'main'
              ? loadout.items[_0x2d13f7.draggable.attr('ind')]
              : sideLoadout.items[_0x2d13f7.draggable.attr('ind')]
        if ($(this).find('.item-slot').length < 1) {
          if (_0x48de57 == 'side' && _0xa53c8c == 'main') {
            $.post(
              'http://IRV-inventory/sideInventoryAction',
              JSON.stringify({
                action: 'get',
                type:
                  _0x4d000d.type == 'item_weapon' ||
                  _0x4d000d.type == 'item_money'
                    ? _0x4d000d.type
                    : 'item_standard',
                index: _0x4d000d.index,
                count: _0x4d000d.count,
              })
            )
            $(_0x2d13f7.draggable)
              .detach()
              .css({
                top: 0,
                left: 0,
              })
              .appendTo(this)
            $('.item-slot').draggable('option', 'revert', false)
          } else {
            _0x48de57 == 'main' &&
              _0xa53c8c == 'main' &&
              (_0x4d000d != undefined
                ? (_0x4d000d.type &&
                    _0x4d000d.type == 'item_weapon' &&
                    _0x4d000d.equiped &&
                    ($.post(
                      'http://IRV-inventory/unequip',
                      JSON.stringify(_0x4d000d.index)
                    ),
                    $(
                      '[forLoadout="' + _0x4d000d.eligableIndex + '"] .component'
                    ).html('')),
                  _0x4d000d.type &&
                    _0x4d000d.type == 'item_standard' &&
                    _0x4d000d.equiped &&
                    $.post(
                      'http://IRV-inventory/triggerAction',
                      JSON.stringify({
                        type: _0x4d000d.type,
                        itemIndex: _0x4d000d.index,
                        key: 'unuse',
                        data: { useIndex: _0x4d000d.eligableIndex },
                      })
                    ),
                  $(_0x2d13f7.draggable)
                    .detach()
                    .css({
                      top: 0,
                      left: 0,
                    })
                    .appendTo(this),
                  $('.item-slot').draggable('option', 'revert', false),
                  (itemsPos[_0x2d13f7.draggable.attr('ind')] = $(this).index()),
                  localStorage.setItem(
                    'inventory_itemsPos',
                    JSON.stringify(itemsPos)
                  ))
                : _0x2d13f7.draggable.parent().hasClass('component') &&
                  ((loadoutIndex = _0x2d13f7.draggable
                    .parent()
                    .attr('forLoadout')),
                  (weapon =
                    loadout.items[
                      $(
                        '.inventory.loadout .loadout[loadout="' +
                          loadoutIndex +
                          '"]'
                      )
                        .find('.item-slot')
                        .attr('ind')
                    ]),
                  !_0x2d13f7.draggable
                    .parent()
                    .attr('componentName')
                    .includes('tint')
                    ? $.post(
                        'http://IRV-inventory/attachment',
                        JSON.stringify({
                          weaponIndex: weapon.index,
                          component: _0x2d13f7.draggable
                            .parent()
                            .attr('componentName'),
                        })
                      )
                    : $.post(
                        'http://IRV-inventory/unequipTint',
                        JSON.stringify(weapon.index)
                      ),
                  $('.item-slot').draggable('option', 'revert', false),
                  $(_0x2d13f7.draggable)
                    .detach()
                    .css({
                      top: 0,
                      left: 0,
                    })
                    .appendTo(this)))
          }
        } else {
          if (_0x4d000d.type == 'item_ammo') {
            let _0x308340 = loadout.items[$(this).find('.item-slot').attr('ind')]
            _0x308340.type == 'item_weapon' &&
              $.post(
                'http://IRV-inventory/useWeaponAmmo',
                JSON.stringify({
                  itemIndex: _0x4d000d.index,
                  weaponIndex: _0x308340.index,
                })
              )
          }
          _0x48de57 == 'side' &&
            _0xa53c8c == 'main' &&
            ($.post(
              'http://IRV-inventory/sideInventoryAction',
              JSON.stringify({
                action: 'get',
                type:
                  _0x4d000d.type == 'item_weapon' ||
                  _0x4d000d.type == 'item_money'
                    ? _0x4d000d.type
                    : 'item_standard',
                index: _0x4d000d.index,
                count: _0x4d000d.count,
              })
            ),
            $('.item-slot').draggable('option', 'revert', false),
            $(_0x2d13f7.draggable).remove())
        }
      },
    })
    $('.inventory.loadout .crafting-slot').droppable({
      drop: function (_0x4a89dc, _0x1b2c8b) {
        let _0x57730a = _0x1b2c8b.draggable
            .parent()
            .parent()
            .parent()
            .hasClass('side')
            ? 'side'
            : 'main',
          _0x5043e = $(this).parent().parent().hasClass('side') ? 'side' : 'main',
          _0x595260 =
            _0x57730a == 'main'
              ? loadout.items[_0x1b2c8b.draggable.attr('ind')]
              : sideLoadout.items[_0x1b2c8b.draggable.attr('ind')]
        if (!_0x595260) {
          return
        }
        let _0x115d1c = $(this).attr('loadout')
        if (_0x595260.type == 'item_weapon') {
          if (_0x595260.eligableIndex == _0x115d1c) {
            $(this).find('.item-slot').length > 0 &&
              $(this).find('.item-slot').detach()
            $(_0x1b2c8b.draggable)
              .detach()
              .css({
                top: 0,
                left: 0,
              })
              .appendTo(this)
            $('.item-slot').draggable('option', 'revert', false)
            $.post(
              'http://IRV-inventory/equip',
              JSON.stringify({
                weaponIndex: _0x595260.index,
                equipIndex: _0x115d1c,
              })
            )
          }
        } else {
          if (
            _0x595260.type == 'item_attachment' &&
            $(this).hasClass('component')
          ) {
            if (
              $(this).find('.item-slot').length < 1 &&
              $(this).attr('slot').split('|').includes(_0x595260.name)
            ) {
              $(_0x1b2c8b.draggable)
                .detach()
                .css({
                  top: 0,
                  left: 0,
                })
                .appendTo(this)
              $('.item-slot').draggable('option', 'revert', false)
              var _0x30deff =
                loadout.items[
                  $('[loadout="' + $(this).attr('forloadout') + '"]')
                    .find('.item-slot')
                    .attr('ind')
                ]
              $.post(
                'http://IRV-inventory/attachment',
                JSON.stringify({
                  weaponIndex: _0x30deff.index,
                  component: _0x595260.name,
                })
              )
            }
          } else {
            if (
              _0x595260.type == 'item_tint' &&
              $(this).hasClass('component') &&
              $(this).attr('slot') == 'tint'
            ) {
              $(this).find('.item-slot').length > 0 &&
                $(this).find('.item-slot').detach()
              $(_0x1b2c8b.draggable)
                .detach()
                .css({
                  top: 0,
                  left: 0,
                })
                .appendTo(this)
              $('.item-slot').draggable('option', 'revert', false)
              var _0x30deff =
                loadout.items[
                  $('[loadout="' + $(this).attr('forloadout') + '"]')
                    .find('.item-slot')
                    .attr('ind')
                ]
              $.post(
                'http://IRV-inventory/equipTint',
                JSON.stringify({
                  weaponIndex: _0x30deff.index,
                  tint: _0x595260.name,
                })
              )
            } else {
              if (_0x595260.type == 'item_ammo') {
                var _0x30deff =
                  loadout.items[$(this).find('.item-slot').attr('ind')]
                if (!_0x30deff) {
                  var _0x52221d = $(this).attr('forLoadout')
                  _0x30deff =
                    loadout.items[
                      $('[loadout="' + _0x52221d + '"]')
                        .find('.item-slot')
                        .attr('ind')
                    ]
                }
                _0x595260.name == _0x30deff?.ammo &&
                  $.post(
                    'http://IRV-inventory/useWeaponAmmo',
                    JSON.stringify({
                      itemIndex: _0x595260.index,
                      weaponIndex: _0x30deff.index,
                    })
                  )
              } else {
                _0x595260.type == 'item_standard' &&
                  _0x595260.eligableIndex == _0x115d1c &&
                    ($(this).find('.item-slot').length > 0 &&
                      $(this).find('.item-slot').detach(),
                    $(_0x1b2c8b.draggable)
                      .detach()
                      .css({
                        top: 0,
                        left: 0,
                      })
                      .appendTo(this),
                    $('.item-slot').draggable('option', 'revert', false),
                    $.post(
                      'http://IRV-inventory/triggerAction',
                      JSON.stringify({
                        type: _0x595260.type,
                        itemIndex: _0x595260.index,
                        key: 'use',
                        data: { useIndex: _0x595260.eligableIndex },
                      })
                    ))
              }
            }
          }
        }
      },
    })
    $('.inventory-box').droppable({
      over: function () {
        canDrop = false
      },
      out: function () {
        canDrop = true
      },
    })
    $('.droparea').droppable({
      drop: function (_0x2c06ed, _0x5145d5) {
        if (sideLoadout) {
          return
        }
        if (canDrop) {
          let _0x286266 = loadout.items[_0x5145d5.draggable.attr('ind')],
            _0x4ba8d3 = {
              type:
                _0x286266.type == 'item_weapon'
                  ? _0x286266.type
                  : 'item_standard',
            }
          if (!_0x286266) {
            return
          }
          _0x286266.type == 'item_weapon'
            ? (_0x4ba8d3.index = _0x286266.index)
            : ((_0x4ba8d3.index = _0x286266.index),
              (_0x4ba8d3.count = _0x286266.count))
          $.post('http://IRV-inventory/drop', JSON.stringify(_0x4ba8d3))
        }
      },
    })
    window.addEventListener('message', function (_0x2d7718) {
      if (_0x2d7718.data.action == 'open') {
        $('.inventory-body').show()
        toggleMenu('hide')
        if (_0x2d7718.data.type == 'normal') {
          $('.inventory.loadout').show()
          newLoadout = _0x2d7718.data.loadout
          sideLoadout = null
          side = null
          loadItems(newLoadout)
          $('.inventory.side').hide()
        }
        if (_0x2d7718.data.type == 'side') {
          $('.inventory.loadout').hide()
          newLoadout = _0x2d7718.data.loadout
          sideLoadout = _0x2d7718.data.side.loadout
          side = _0x2d7718.data.side
          loadItems(newLoadout)
          loadSide(_0x2d7718.data.side)
        }
      }
      if (_0x2d7718.data.action == 'updateInventory') {
        newLoadout = _0x2d7718.data.loadout
        _0x2d7718.data.side && (sideLoadout = _0x2d7718.data.side.loadout)
        loadItems(newLoadout)
        _0x2d7718.data.side && loadSide(_0x2d7718.data.side)
      }
      if (_0x2d7718.data.action == 'removeItem') {
        var _0x384ad0 = _0x2d7718.data.data.type,
          _0x42a7db = _0x2d7718.data.data.index,
          _0x4273f9 = loadout.items.findIndex(
            (_0x28a4fc) => _0x28a4fc.index == _0x42a7db
          ),
          _0xabc71b = loadout.items[_0x4273f9]
        delete itemsPos[_0x4273f9]
        localStorage.setItem('inventory_itemsPos', JSON.stringify(itemsPos))
      }
      _0x2d7718.data.action == 'close' && $('.inventory-body').hide()
    })
  })
  function loadSide(_0x56a119) {
    $('.inventory.side').fadeIn()
    $('.inventory.side .label').html(_0x56a119.label)
    $('.inventory.side .weight').html(
      '<span class="bagWeight">' + floatRound(sideLoadout.weight) + '</span>'
    )
    $('.inventory.side .weightHolder').removeClass('gelov')
    sideLoadout.reduction &&
      ($('.inventory.side .weightHolder').addClass('gelov'),
      $('.inventory.side .weight').append(
        '<span class="reducedWeight">' +
          (floatRound(
            sideLoadout.weight -
              sideLoadout.weight * (sideLoadout.reduction / 100)
          ) > sideLoadout.initial
            ? floatRound(
                sideLoadout.weight -
                  sideLoadout.weight * (sideLoadout.reduction / 100)
              )
            : sideLoadout.initial) +
          ' .VOL</span>'
      ))
    $('.inventory.side .maxWeight').html(
      '/' +
        (sideLoadout.maxWeight > 0
          ? sideLoadout.maxWeight + ' .VOL'
          : '<span class="infiniteSign">\u221E</span>')
    )
    $('.inventory.side .crafting-panel.regular-table').html('')
    sideLoadout.slot == 0 &&
      (sideLoadout.items.length > 29
        ? (sideLoadout.slot =
            sideLoadout.items.length +
            Math.abs(Math.round((sideLoadout.items.length % 6) - 6)))
        : (sideLoadout.slot = 30))
    for (let _0x50bbee = 0; _0x50bbee < sideLoadout.slot; _0x50bbee++) {
      $('<div class="crafting-panel crafting-slot sideSlot"></div>').appendTo(
        '.inventory.side .crafting-panel.regular-table'
      )
    }
    if (side.type == 'player' && sideLoadout.money) {
      var _0x39818d = {
        count: sideLoadout.money,
        type: 'item_money',
        name: 'money',
        label: 'Cash',
        weight: 0,
      }
      sideLoadout.items.splice(0, 0, _0x39818d)
    }
    sideLoadout.items.forEach((_0x229746, _0x170c32) => {
      let _0x492712 = $('.inventory.side .crafting-slot:empty').eq(0)
      _0x492712.html(itemTemplate)
      _0x492712.find('.item-slot').attr('ind', _0x170c32)
      if (Object.keys(_0x229746.extras || {}).length > 0) {
        _0x492712
          .find('.item-slot')
          .append('<div class="slot-description"></div>')
        for (var _0x59ca31 in _0x229746.extras) {
          if (!_0x229746.extras.hasOwnProperty(_0x59ca31)) {
            continue
          }
          if (excludedExtras.includes(_0x59ca31)) {
            continue
          }
          var _0x3608e0 = _0x229746.extras[_0x59ca31]
          if (_0x3608e0 && _0x59ca31) {
            _0x492712
              .find('.slot-description')
              .append(
                '<div class="infoRow"><b>' +
                  _0x59ca31 +
                  ':</b>\t<span>' +
                  _0x3608e0 +
                  '</span></div>'
              )
          }
        }
      }
      if (side.type == 'player' && sideLoadout && _0x229746.equiped) {
        _0x492712.find('.item-slot').addClass('equiped')
      }
      if (side.type == 'player' && _0x229746.extras?.lock) {
        _0x492712
          .find('.item-slot')
          .addClass(side?.key != _0x229746.extras?.lock ? 'locked' : 'unlocked')
      }
      if (_0x229746.type == 'item_weapon') {
        _0x492712.find('.slot-name').text('' + _0x229746.label)
        _0x492712
          .find('.slot-info')
          .html(
            floatRound(_0x229746.weight) +
              ' VOL ' +
              (_0x229746.count > 0
                ? '<span class="bulletIcon"></span> ' + _0x229746.count
                : '')
          )
      } else {
        _0x492712
          .find('.slot-name')
          .text(
            _0x229746.canstack
              ? _0x229746.count + 'x ' + _0x229746.label
              : _0x229746.label
          )
        if (_0x229746.type == 'item_money') {
          _0x492712
            .find('.slot-info')
            .text(
              '$' +
                _0x229746.count.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')
            )
        } else {
          _0x229746.weight > 0 &&
            _0x492712
              .find('.slot-info')
              .text(floatRound(_0x229746.count * _0x229746.weight) + ' VOL')
        }
      }
      _0x492712
        .find('img')
        .attr('src', 'images/' + _0x229746.name.toLowerCase() + '.png')
    })
    $('.inventory.side .crafting-slot').droppable({
      drop: function (_0x247527, _0x36f80a) {
        let _0x19b248 = _0x36f80a.draggable
            .parent()
            .parent()
            .parent()
            .hasClass('side')
            ? 'side'
            : 'main',
          _0x5c747c = $(this).parent().parent().hasClass('side')
            ? 'side'
            : 'main',
          _0x2a212a =
            _0x19b248 == 'main'
              ? loadout.items[_0x36f80a.draggable.attr('ind')]
              : sideLoadout.items[_0x36f80a.draggable.attr('ind')]
        if (_0x2a212a != undefined) {
          if (_0x19b248 == 'main' && _0x5c747c == 'side') {
            $.post(
              'http://IRV-inventory/sideInventoryAction',
              JSON.stringify({
                action: 'put',
                type:
                  _0x2a212a.type == 'item_weapon' ||
                  _0x2a212a.type == 'item_money'
                    ? _0x2a212a.type
                    : 'item_standard',
                index: _0x2a212a.index,
                count: _0x2a212a.count,
              })
            )
          } else {
            if (_0x19b248 == 'side' && _0x5c747c == 'side') {
            }
          }
          $('.item-slot').draggable('option', 'revert', false)
          $(_0x36f80a.draggable).remove()
        }
      },
    })
    listenEvents()
  }
  function loadItems(_0x2d47dd) {
    var _0x5d408f =
      _0x2d47dd.items.filter((_0xc3cbe7) => _0xc3cbe7.type == 'item_standard')
        .length -
      loadout.items.filter((_0x40e9ff) => _0x40e9ff.type != 'item_weapon').length
    loadout.items.length == 0 && (_0x5d408f = 0)
    if (_0x5d408f > 0) {
      var _0x5acf9d = loadout.items.findIndex(
          (_0x5de14f) => _0x5de14f.type == 'item_weapon'
        ),
        _0x4e6d62 = []
      itemsPos.forEach((_0x1d7a5f, _0x12a245) => {
        _0x12a245 >= _0x5acf9d
          ? (_0x4e6d62[_0x12a245 + _0x5d408f] = _0x1d7a5f)
          : (_0x4e6d62[_0x12a245] = _0x1d7a5f)
      })
      itemsPos = _0x4e6d62
    }
    loadout = _0x2d47dd
    $('.inventory.main .weight').html('' + floatRound(loadout.weight))
    $('.inventory.main .maxWeight').html(loadout.maxWeight + ' .VOL')
    $('.crafting-slot').html('')
    $('.component').html('')
    $('.crafting-slot[action="money"]').html(
      loadout.money.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')
    )
    loadout.items.forEach((_0x4a5a9f, _0x3a8d55) => {
      let _0x119f7b
      !_0x4a5a9f.equiped || sideLoadout
        ? itemsPos[_0x3a8d55]
          ? ((_0x119f7b = $('.inventory.main .crafting-slot').eq(
              itemsPos[_0x3a8d55]
            )),
            _0x119f7b.find('.item-slot').html() &&
              (_0x119f7b = $('.inventory.main .crafting-slot:empty').eq(0)))
          : (_0x119f7b = $('.inventory.main .crafting-slot:empty').eq(0))
        : ((_0x119f7b = $(
            '.inventory.loadout [loadout="' + _0x4a5a9f.equiped + '"]'
          )),
          _0x4a5a9f.components &&
            _0x4a5a9f.components.forEach((_0x44cbc6, _0x26a35) => {
              $(
                '.component[forloadout="' +
                  _0x4a5a9f.equiped +
                  '"][slot*="' +
                  _0x44cbc6 +
                  '"]'
              ).html(itemTemplate)
              $(
                '.component[forloadout="' +
                  _0x4a5a9f.equiped +
                  '"][slot*="' +
                  _0x44cbc6 +
                  '"]'
              ).attr('componentName', _0x44cbc6)
              $(
                '.component[forloadout="' +
                  _0x4a5a9f.equiped +
                  '"][slot*="' +
                  _0x44cbc6 +
                  '"]'
              )
                .find('img')
                .attr('src', 'images/' + _0x44cbc6 + '.png')
            }),
          _0x4a5a9f.tint &&
            ($(
              '.component[forloadout="' + _0x4a5a9f.equiped + '"][slot="tint"]'
            ).html(itemTemplate),
            $(
              '.component[forloadout="' + _0x4a5a9f.equiped + '"][slot="tint"]'
            ).attr('componentName', _0x4a5a9f.tint),
            $('.component[forloadout="' + _0x4a5a9f.equiped + '"][slot="tint"]')
              .find('img')
              .attr('src', 'images/' + _0x4a5a9f.tint + '.png')))
      _0x119f7b.html(itemTemplate)
      _0x119f7b.find('.item-slot').attr('ind', _0x3a8d55)
      if (Object.keys(_0x4a5a9f.extras || {}).length > 0) {
        _0x119f7b
          .find('.item-slot')
          .append('<div class="slot-description"></div>')
        for (var _0xfcf23f in _0x4a5a9f.extras) {
          if (!_0x4a5a9f.extras.hasOwnProperty(_0xfcf23f)) {
            continue
          }
          if (excludedExtras.includes(_0xfcf23f)) {
            continue
          }
          var _0x2da3db = _0x4a5a9f.extras[_0xfcf23f]
          if (_0x2da3db && _0xfcf23f) {
            _0x119f7b
              .find('.slot-description')
              .append(
                '<div class="infoRow"><b>' +
                  _0xfcf23f +
                  ':</b>\t<span>' +
                  _0x2da3db +
                  '</span></div>'
              )
          }
        }
      }
      if (sideLoadout && _0x4a5a9f.equiped) {
        _0x119f7b.find('.item-slot').addClass('equiped')
      }
      if (_0x4a5a9f.extras?.lock) {
        _0x119f7b
          .find('.item-slot')
          .addClass(side?.key != _0x4a5a9f.extras?.lock ? 'locked' : 'unlocked')
      }
      _0x4a5a9f.type == 'item_weapon'
        ? (_0x119f7b.find('.slot-name').text('' + _0x4a5a9f.label),
          _0x119f7b
            .find('.slot-info')
            .html(
              floatRound(_0x4a5a9f.weight) +
                ' VOL ' +
                (_0x4a5a9f.count > 0
                  ? '<span class="bulletIcon"></span> ' + _0x4a5a9f.count
                  : '')
            ))
        : (_0x119f7b
            .find('.slot-name')
            .text(
              _0x4a5a9f.canstack
                ? _0x4a5a9f.count + 'x ' + _0x4a5a9f.label
                : _0x4a5a9f.label
            ),
          _0x4a5a9f.weight > 0 &&
            _0x119f7b
              .find('.slot-info')
              .text(floatRound(_0x4a5a9f.count * _0x4a5a9f.weight) + ' VOL'))
      _0x119f7b
        .find('img')
        .attr('src', 'images/' + _0x4a5a9f.name.toLowerCase() + '.png')
    })
    listenEvents()
  }
  var oldMouseStart = $.ui.draggable.prototype['_mouseStart']
  $.ui.draggable.prototype['_mouseStart'] = function (
    _0x5d6b84,
    _0x1522e6,
    _0x2d1744
  ) {
    this['_trigger']('beforeStart', _0x5d6b84, this['_uiHash']())
    oldMouseStart.apply(this, [_0x5d6b84, _0x1522e6, _0x2d1744])
  }
  let pointerX, pointerY
  document.onmousemove = function (_0xb52322) {
    pointerX = _0xb52322.pageX
    pointerY = _0xb52322.pageY
  }
  function listenEvents() {
    $('.item-slot').draggable({
      scroll: false,
      beforeStart: function (_0x29d100) {
        var _0x389f20 = _0x29d100.target
        $(this).css('position', 'absolute')
        $(this).css('z-index', 100000000000000000000)
        let _0x5cc87b = $(this).css('top'),
          _0x51562f = $(this).css('left')
        $(this).css('top', pointerY - 50)
        $(this).css('left', pointerX - 50)
        if ($(_0x389f20).parent().index() > 23) {
        }
      },
      start: function (_0x46338f, _0x2cc5fd) {
        $('.item-slot').draggable('option', 'revert', true)
      },
      stop: function () {
        $(this).css({
          top: 'inherit',
          left: 'inherit',
          'z-index': 'inherit',
        })
        $(this).css('position', 'relative')
      },
    })
    $('.item-slot').mousedown(function (_0x1864df) {
      if (_0x1864df.which == 3) {
        $('.contextmenu .customOptions').html('')
        $('.menu-option').show()
        var _0x4d402d = $(this).attr('ind')
        $('.contextmenu').attr('context', _0x4d402d)
        let _0x2ae41f = $(this).parent().parent().parent().hasClass('side')
          ? 'side'
          : 'main'
        $('.contextmenu').attr('source', _0x2ae41f)
        $('.contextmenu input[type="number"]').val(1)
        let _0x1ce054 =
          _0x2ae41f == 'main'
            ? loadout.items[$(this).attr('ind')]
            : sideLoadout.items[$(this).attr('ind')]
        if (!_0x1ce054) {
          return
        }
        if (sideLoadout) {
          $('.menu-option').hide()
          if (_0x1ce054.type != 'item_weapon') {
            var _0x71c811
            $(this).parent().parent().parent().hasClass('main')
              ? (_0x71c811 = $(
                  '<li class="menu-option" action="put">Put <input type="number" id="put" min="1" max="' +
                    _0x1ce054.count +
                    '" minlength="1" maxlength="' +
                    _0x1ce054.count +
                    '" value="1" /></li>'
                ))
              : (_0x71c811 = $(
                  '<li class="menu-option" action="get">Take <input type="number" id="get" min="1" max="' +
                    _0x1ce054.count +
                    '" minlength="1" maxlength="' +
                    _0x1ce054.count +
                    '" value="1" /></li>'
                ))
            _0x71c811.appendTo($('.contextmenu .customOptions'))
            _0x71c811.click((_0x3d141b) => {
              handleMenus(_0x3d141b)
            })
          } else {
            $(this).click()
          }
          if (
            _0x2ae41f == 'side' &&
            sideLoadout.destroyStash != null &&
            loadout.job?.grade >= sideLoadout.destroyStash
          ) {
            var _0x2c9c21 = $(
              '<li class="menu-option" action="destroy">Destroy</li>'
            )
            _0x2c9c21.appendTo($('.contextmenu .customOptions'))
            _0x2c9c21.click((_0x8948da) => {
              handleMenus(_0x8948da)
            })
          }
        } else {
          _0x1ce054.type == 'item_weapon'
            ? (maxValue = 1)
            : (maxValue = _0x1ce054.count)
          $('.contextmenu input[type="number"]').attr('max', maxValue)
          $('.contextmenu input[type="number"]').attr('min', 1)
          !_0x1ce054.usable && $('.menu-option.use').hide()
          $.post(
            'http://IRV-inventory/getActions',
            JSON.stringify({
              name: _0x1ce054.name,
              type: _0x1ce054.type,
            }),
            (_0xb1f307) => {
              if (_0xb1f307 && _0xb1f307.length > 0) {
                _0xb1f307.forEach((_0x16de22) => {
                  var _0x1c3c2f = $(
                    '<li class="menu-option" action="' +
                      _0x16de22.key +
                      '">' +
                      _0x16de22.label +
                      ' ' +
                      (_0x16de22.data
                        ? '<input type="' +
                          _0x16de22.data.type +
                          '" id="' +
                          _0x16de22.data.key +
                          '" min="' +
                          _0x16de22.data.min +
                          '" max="' +
                          _0x16de22.data.max +
                          '" minlength="' +
                          _0x16de22.data.min +
                          '" maxlength="' +
                          _0x16de22.data.max +
                          '" />'
                        : '') +
                      '</li>'
                  )
                  _0x1c3c2f.appendTo($('.contextmenu .customOptions'))
                  _0x1c3c2f.click((_0x2645f2) => {
                    handleMenus(_0x2645f2)
                  })
                  _0x16de22.data &&
                    (_0x1c3c2f.find('input').val(_0x16de22.data.min),
                    _0x1c3c2f.on('keydown', (_0x531ce6) => {
                      handleNumberInput(_0x531ce6)
                    }))
                })
              }
            }
          )
        }
        _0x1864df.preventDefault()
        const _0x222d8c = {
          left: _0x1864df.pageX,
          top: _0x1864df.pageY,
        }
        return setPosition(_0x222d8c), $('.menu-option.drop input').focus(), false
      }
    })
    $('.item-slot').on('mouseenter', (_0x5f4dc6) => {
      if ($(_0x5f4dc6.currentTarget).html()) {
        if (!$(_0x5f4dc6.currentTarget).hasClass('ui-draggable-dragging')) {
          $('.tooltip').fadeIn()
          if ($(_0x5f4dc6.currentTarget).find('.slot-description').html() != '') {
            $('.tooltip').html(
              $(_0x5f4dc6.currentTarget).find('.slot-description').clone()
            )
          }
          $('.tooltip').css('top', _0x5f4dc6.pageY + 10)
          $('.tooltip').css('left', _0x5f4dc6.pageX + 10)
        } else {
          $('.tooltip').html('')
        }
      }
    })
    $('.item-slot').on('mousemove', (_0x2ac543) => {
      if ($(_0x2ac543.currentTarget).html()) {
        if (!$(_0x2ac543.currentTarget).hasClass('ui-draggable-dragging')) {
          if ($(_0x2ac543.currentTarget).find('.slot-description').html() != '') {
            if (!$('.tooltip').html()) {
              $('.tooltip').html(
                $(_0x2ac543.currentTarget).find('.slot-description').clone()
              )
            }
          }
          $('.tooltip').css('top', _0x2ac543.pageY + 10)
          $('.tooltip').css('left', _0x2ac543.pageX + 10)
        } else {
          $('.tooltip').html('')
        }
      }
    })
    $('.item-slot').on('mouseleave', () => {
      $('.tooltip').html('')
    })
  }
  $('.inventory.loadout [action="money"]').mousedown(function (_0x379dae) {
    if (_0x379dae.which == 3) {
      $('.contextmenu .customOptions').html('')
      $('.menu-option').show()
      $('.contextmenu').attr('context', -5)
      $('.contextmenu input[type="number"]').val(1000)
      maxValue = loadout.money
      $('.contextmenu input[type="number"]').attr('max', maxValue)
      $('.contextmenu input[type="number"]').attr('min', 1000)
      $('.contextmenu input[type="number"]').attr('step', 1000)
      $('.menu-option.use').hide()
      $('.menu-option.drop').hide()
      _0x379dae.preventDefault()
      const _0x57a2e1 = {
        left: _0x379dae.pageX,
        top: _0x379dae.pageY,
      }
      return setPosition(_0x57a2e1), $('.menu-option.drop input').focus(), false
    }
  })
  document.onkeydown = function (_0x2a817e) {
    ;(_0x2a817e.code === 'KeyI' || _0x2a817e.code === 'Escape') &&
      ($.post('http://IRV-inventory/close', true), $('.inventory-body').hide())
  }
  const menu = document.querySelector('.contextmenu'),
    menuOption = document.querySelector('.menu-option')
  let menuVisible = false
  const toggleMenu = (_0xcd0568) => {
      menu.style.display = _0xcd0568 === 'show' ? 'block' : 'none'
      menuVisible = _0xcd0568 === 'show' ? true : false
      if (_0xcd0568 != 'show') {
        $('.giveMenu').remove()
      }
    },
    setPosition = ({ top: _0x43ca04, left: _0x3d93b4 }) => {
      menu.style.left = _0x3d93b4 + 'px'
      menu.style.top = _0x43ca04 + 'px'
      toggleMenu('show')
      $('.contextmenu .menu-option:visible').length < 1
        ? toggleMenu('hide')
        : toggleMenu('show')
    }
  window.addEventListener('click', (_0x3e6c66) => {
    if (_0x3e6c66.target.nodeName == 'INPUT') {
      return
    }
    if (menuVisible) {
      toggleMenu('hide')
    }
    $('.giveMenu').remove()
  })
  const handleMenus = (_0x2af5f2) => {
    if (_0x2af5f2.target.nodeName == 'INPUT') {
      return
    }
    var _0x110f7d = $(_0x2af5f2.target).parent().parent().attr('context'),
      _0x3527fc = $(_0x2af5f2.target).parent().parent().attr('source'),
      _0x3ed677 =
        _0x3527fc == 'main'
          ? loadout.items[_0x110f7d]
          : sideLoadout.items[_0x110f7d],
      _0x19adc0 = $(_0x2af5f2.target)
    toggleMenu('hide')
    if (!_0x19adc0.attr('action')) {
      return
    }
    if (
      $(_0x2af5f2.target).find('input') &&
      $(_0x2af5f2.target).find('input').val() == ''
    ) {
      return
    }
    switch (_0x19adc0.attr('action')) {
      case 'use':
        $.post(
          'http://IRV-inventory/use',
          JSON.stringify({
            index: _0x3ed677.index,
            name: _0x3ed677.name,
          })
        )
        break
      case 'drop':
        $.post(
          'http://IRV-inventory/drop',
          JSON.stringify({
            type:
              _0x3ed677.type == 'item_weapon' ? _0x3ed677.type : 'item_standard',
            index: _0x3ed677.index,
            count: parseInt($(_0x2af5f2.target).find('input').val()),
          })
        )
        break
      case 'put':
        $.post(
          'http://IRV-inventory/sideInventoryAction',
          JSON.stringify({
            action: 'put',
            type:
              _0x3ed677.type == 'item_weapon' || _0x3ed677.type == 'item_money'
                ? _0x3ed677.type
                : 'item_standard',
            index: _0x3ed677.index,
            count: parseInt($(_0x2af5f2.target).find('input').val()),
          })
        )
        break
      case 'get':
        $.post(
          'http://IRV-inventory/sideInventoryAction',
          JSON.stringify({
            action: 'get',
            type:
              _0x3ed677.type == 'item_weapon' || _0x3ed677.type == 'item_money'
                ? _0x3ed677.type
                : 'item_standard',
            index: _0x3ed677.index,
            count: parseInt($(_0x2af5f2.target).find('input').val()),
          })
        )
        break
      case 'give':
        $.post('http://IRV-inventory/GetNearPlayers', {}, (_0x117fc1) => {
          if (_0x117fc1.length > 0) {
            let _0x32ebdb = $('.contextmenu').clone()
            _0x32ebdb.addClass('giveMenu')
            _0x32ebdb.find('.menu-options').eq(0).remove()
            _0x32ebdb.find('.menu-options').html('')
            _0x32ebdb.appendTo($('body'))
            _0x117fc1.forEach((_0x3995bd) => {
              $(
                '<li class="menu-option" onclick="giveItem(\'' +
                  _0x110f7d +
                  "', '" +
                  parseInt($(_0x2af5f2.target).find('input').val()) +
                  "', '" +
                  _0x3995bd.id +
                  '\')">' +
                  _0x3995bd.label +
                  '</li>'
              ).appendTo(_0x32ebdb.find('.menu-options'))
            })
            _0x32ebdb.show()
          }
        })
        break
      case 'destroy':
        $.post(
          'http://IRV-inventory/destroyStash',
          JSON.stringify({
            type:
              _0x3ed677.type == 'item_weapon' || _0x3ed677.type == 'item_money'
                ? _0x3ed677.type
                : 'item_standard',
            index: _0x3ed677.index,
          })
        )
        break
      default:
        var _0x490762 = {}
        ;(_0x490762[$(_0x2af5f2.target).find('input').attr('id')] = $(
          _0x2af5f2.target
        )
          .find('input')
          .val()),
          $.post(
            'http://IRV-inventory/triggerAction',
            JSON.stringify({
              type: _0x3ed677.type,
              itemIndex: _0x3ed677.index,
              key: _0x19adc0.attr('action'),
              data: _0x490762,
            })
          )
        break
    }
  }
  $('.menu-option').click((_0x163309) => {
    handleMenus(_0x163309)
  })
  const giveItem = (_0x47207b = -5, _0x1aa9e9, _0x17b91e) => {
      var _0x41c0fa = loadout.items[_0x47207b]
      let _0x3dba38 = {
        target: parseInt(_0x17b91e),
        count: parseInt(_0x1aa9e9),
        index: _0x41c0fa ? parseInt(_0x41c0fa.index) : 143,
      }
      _0x41c0fa != undefined
        ? _0x41c0fa.type == 'item_weapon'
          ? (_0x3dba38.type = 'item_weapon')
          : (_0x3dba38.type = 'item_standard')
        : (_0x3dba38.type = 'item_money')
      $.post('http://IRV-inventory/give', JSON.stringify(_0x3dba38))
      $('.giveMenu').remove()
    },
    handleNumberInput = (_0x39fc85) => {
      if (_0x39fc85.key == '.') {
        return (
          _0x39fc85.stopPropagation(),
          _0x39fc85.preventDefault(),
          (_0x39fc85.returnValue = false),
          (_0x39fc85.cancelBubble = true),
          false
        )
      }
      var _0x33c29e = parseInt($(_0x39fc85.target).val()),
        _0x11609a = parseInt($(_0x39fc85.target).attr('max'))
      if (isNaN(_0x33c29e) && $(_0x39fc85.target).val() != '') {
        $(_0x39fc85.target).val(1)
        return
      }
      _0x33c29e > _0x11609a && $(_0x39fc85.target).val(_0x11609a)
      _0x33c29e < 1 && $(_0x39fc85.target).val(1)
    }
  $('.contextmenu input[type="number"]').on('keydown', (_0x38198b) => {
    handleNumberInput(_0x38198b)
  })
  