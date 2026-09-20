TableFilters = []
ItensFiltrados = []
resetarFilter = false
inchest = false
tipoSecondInventory = null
nomeDoBau = null
nomeTrunckChest = null
nomeHouse = null
tudo = false
metade = false
click = false
update = false
craftUpdate = false
var formatter = new Intl.NumberFormat(config.lang, {
    style: 'currency',
    currency: config.currency,
    minimumFractionDigits: 2,
    maximumFractionDigits: 2,
  }),
  caftItens = [
    {
      item: 'nada',
      quantidade: 0,
    },
    {
      item: 'nada',
      quantidade: 0,
    },
    {
      item: 'nada',
      quantidade: 0,
    },
    {
      item: 'nada',
      quantidade: 0,
    },
    {
      item: 'nada',
      quantidade: 0,
    },
    {
      item: 'nada',
      quantidade: 0,
    },
    {
      item: 'nada',
      quantidade: 0,
    },
    {
      item: 'nada',
      quantidade: 0,
    },
    {
      item: 'nada',
      quantidade: 0,
    },
  ]
$(document).ready(function () {
  window.addEventListener('message', function (_0x5e66dc) {
    tipoSecondInventory = _0x5e66dc.data.secondAction
    _0x5e66dc.data.url && (ip = _0x5e66dc.data.url)
    switch (_0x5e66dc.data.action) {
      case 'openInventory':
        $('#menu-principal').fadeIn(),
          (craftUpdate = false),
          (update = false),
          _0x550473(),
          _0x5d5272(),
          _0x4ac9c1(),
          (nomeDoBau = null)
        break
      case 'updateInventory':
        ;(update = true), _0x5d5272(), _0x550473(), _0x4ac9c1()
        break
      case 'closeInventory':
        $('#menu-principal').fadeOut(),
          restFilter(),
          $('.filter-menu').css('left', '23vw'),
          $('.identity-inicial').css('left', '0'),
          $('#box-menu-item').css('right', '0'),
          $('.right-menu').css('right', '-14vw'),
          $('.top-menu').css('top', '0'),
          $('#box-menu-item-chest').css('left', '0'),
          $('.right-menu').fadeOut(),
          $('#box-menu-item').fadeOut(),
          $('.identity-inicial').fadeOut(),
          $('.filter-menu').fadeOut(),
          $('.top-menu').fadeOut(),
          $('#box-menu-item-chest').fadeOut(),
          $('.craft').fadeOut(),
          $('.margin-bottom-escolha').css('left', '8.8vw'),
          $('.escolha-menu').css('opacity', '0.3'),
          $('.escolha-menu.personagem').css('opacity', '1')
        break
    }
  })
  function _0x550473() {
    tipoSecondInventory === undefined || tipoSecondInventory === null
      ? (inchest = false)
      : (inchest = true)
    if (inchest === true) {
      tipoSecondInventory != null &&
        tipoSecondInventory != undefined &&
        ($('.box-action').css('opacity', '0'),
        $('.inventory-title-menu').hide(),
        $('.person-menu-inventory').hide(),
        $('.chest-title-menu').show(),
        $('.person-menu-chest').show(),
        $('.box-circle-mochila').css('opacity', '0'),
        _0x255577(tipoSecondInventory))
    } else {
      inchest === false &&
        ($('.box-action').css('opacity', '1'),
        $('.inventory-title-menu').show(),
        $('.person-menu-inventory').show(),
        $('.chest-title-menu').hide(),
        $('.person-menu-chest').hide(),
        $('.box-circle-mochila').css('opacity', '1'))
    }
  }
  function _0x1b6d4e(_0x459a56) {
    return _0x459a56.toLocaleString('pt-BR')
  }
  function _0x255577(_0x5692f1) {
    if (_0x5692f1 === 'jaemuso') {
      $('.box-action').css('opacity', '1')
      $('.box-circle-mochila').css('opacity', '1')
      $('.left-menu-chest').css('opacity', '0')
      $('.name-car').html('Em uso')
      $('#box-menu-item-chest').html('')
      $('#box-menu-item-chest').append(
        '\n                <div class="in-use"> \n                    Alguém já está usando este inventário!\n                    <img src="' +
          ip +
          '/lock.png">\n                </div>\n            '
      )
      return
    }
    if (_0x5692f1 === 'carroDeNpc') {
      $('.box-action').css('opacity', '1')
      $('.box-circle-mochila').css('opacity', '1')
      $('.left-menu-chest').css('opacity', '0')
      $('.name-car').html('Não registrado')
      $('#box-menu-item-chest').html('')
      $('#box-menu-item-chest').append(
        '\n                <div class="in-use"> \n                    Esse carro não está nos registros\n                    <img src="' +
          ip +
          '/lock.png" style="right: 11.6vw">\n                </div>\n            '
      )
      return
    }
    if (_0x5692f1 === 'carroTrancado') {
      $('.box-action').css('opacity', '1')
      $('.box-circle-mochila').css('opacity', '1')
      $('.left-menu-chest').css('opacity', '0')
      $('.name-car').html('Trancado')
      $('#box-menu-item-chest').html('')
      $('#box-menu-item-chest').append(
        '\n                <div class="in-use"> \n                    Esse carro está trancado\n                    <img src="' +
          ip +
          '/lock.png" style="right: 9vw">\n                </div>\n            '
      )
      return
    }
    $.post(
      'http://Unique_inventory/requestItemSecondInventory',
      JSON.stringify({ tipo: _0x5692f1 }),
      (_0x24ece6) => {
        $('.name-car').html(_0x5692f1)
        $('#box-menu-item-chest').html('')
        if (_0x24ece6.chest === false) {
          const _0x54fd78 = _0x24ece6.itemTable.sort((_0xf573bc, _0x53d970) =>
            _0xf573bc.name > _0x53d970.name ? 1 : -1
          )
          $('.left-menu-chest').css('opacity', '0')
          $('#box-menu-item-chest')
            .empty()
            .append(
              '\n                ' +
                _0x54fd78
                  .map(
                    (_0x316333) =>
                      '      \n                    <div class="slotChest">\n                        <div class="item-player venda" data-item-price="' +
                      _0x316333.price +
                      '" data-item-amount="' +
                      _0x316333.count +
                      '" data-item-type="' +
                      _0x316333.type +
                      '" data-item-index="' +
                      _0x316333.index +
                      '" data-item-peso="' +
                      _0x316333.peso +
                      '" data-item-key="' +
                      _0x316333.name +
                      '" data-item-name="' +
                      _0x316333.label +
                      '" data-item-desc="' +
                      _0x316333.descricao +
                      '" data-item-funcao="' +
                      _0x316333.funcao +
                      '" data-weapon-dano="' +
                      _0x316333.dano +
                      '" data-weapon-cadencia="' +
                      _0x316333.cadencia +
                      '" data-weapon-precisao="' +
                      _0x316333.precisao +
                      '" data-weapon-recoil="' +
                      _0x316333.recoil +
                      '" style="background-image: url(\'' +
                      ip +
                      '/' +
                      _0x316333.name +
                      '.png\');">\n                                <div class="top-item">\n                                    <div class="amount">R$: ' +
                      _0x316333.price +
                      '</div>\n                                    <div class="peso">' +
                      _0x316333.peso.toFixed(1) +
                      'kg</div>\n                                </div>\n                                <div class="bottom-item">\n                                    <div class="name-item">' +
                      _0x316333.label +
                      '\n                                    <div class="typeFilter">' +
                      _0x316333.filter +
                      '</div>\n                                </div>\n                            </div>\n                        </div>\n                    </div>\n                    '
                  )
                  .join('') +
                '\n                '
            )
          for (let _0x44d62d = 0; _0x44d62d < 50; _0x44d62d++) {
            $('#box-menu-item-chest').append(
              '\n                        <div class="slotChest venda">\n    \n                        </div>\n                    '
            )
          }
          getHover()
          getDrag()
        } else {
          if (_0x24ece6.chest === true) {
            $('.left-menu-chest').css('opacity', '1')
            nomeDoBau = _0x5692f1
            $('#box-menu-item-chest').html('')
            for (let _0x4de65f = 0; _0x4de65f < _0x24ece6.slots; _0x4de65f++) {
              $('#box-menu-item-chest').append(
                '\n                        <div class="slotChest chest" data-temItem="false" data-slotNovo="' +
                  _0x4de65f +
                  '">\n                        </div>\n                    '
              )
            }
            for (i = 0; i < _0x24ece6.slots; i++) {
              if (_0x24ece6.tableChest[i]) {
                var _0x286660 = _0x24ece6.tableChest[i],
                  _0x5bc40d = $('.slotChest')
                _0x5bc40d &&
                  $('.slotChest').each(function () {
                    var _0x2951ca = $(this).attr('data-slotNovo')
                    if (Number(i) === Number(_0x2951ca)) {
                      const _0x121a04 =
                        '\n                                    <div class="item-player chest"  data-item-antigo="' +
                        i +
                        '" data-item-amount="' +
                        _0x286660.count +
                        '" data-item-type="' +
                        _0x286660.type +
                        '" data-item-index="' +
                        _0x286660.index +
                        '" data-item-peso="' +
                        _0x286660.peso +
                        '" data-item-key="' +
                        _0x286660.name +
                        '" data-item-name="' +
                        _0x286660.label +
                        '" data-item-desc="' +
                        _0x286660.descricao +
                        '" data-item-funcao="' +
                        _0x286660.funcao +
                        '" data-weapon-dano="' +
                        _0x286660.dano +
                        '" data-weapon-cadencia="' +
                        _0x286660.cadencia +
                        '" data-weapon-precisao="' +
                        _0x286660.precisao +
                        '" data-weapon-recoil="' +
                        _0x286660.recoil +
                        '" style="background-image: url(\'' +
                        ip +
                        '/' +
                        _0x286660.name +
                        '.png\');">\n                                        <div class="top-item">\n                                            <div class="amount">' +
                        _0x286660.count +
                        'x</div>\n                                            <div class="peso">' +
                        (_0x286660.peso * _0x286660.count).toFixed(1) +
                        'kg</div>\n                                        </div>\n                                        <div class="bottom-item">\n                                            <div class="name-item">' +
                        _0x286660.label +
                        '\n                                            <div class="typeFilter">' +
                        _0x286660.filter +
                        '</div>\n                                        </div>\n                                        </div>\n                                    </div>\n                                    '
                      $(this).attr('data-temItem', 'true')
                      $(this).append(_0x121a04)
                    }
                  })
              }
            }
          } else {
            if (_0x24ece6.chest === 'TrunckChest') {
              $('.left-menu-chest').css('opacity', '1')
              nomeTrunckChest = _0x24ece6.nameCar
              $('#box-menu-item-chest').html('')
              $('.name-car').html(nomeTrunckChest)
              for (
                let _0x59804a = 0;
                _0x59804a < _0x24ece6.slots;
                _0x59804a++
              ) {
                $('#box-menu-item-chest').append(
                  '\n                        <div class="slotChest trunckchest" data-temItem="false" data-slotNovo="' +
                    _0x59804a +
                    '">\n                        </div>\n                    '
                )
              }
              for (i = 0; i < _0x24ece6.slots; i++) {
                if (_0x24ece6.tableChest[i]) {
                  var _0x286660 = _0x24ece6.tableChest[i],
                    _0x5bc40d = $('.slotChest')
                  _0x5bc40d &&
                    $('.slotChest').each(function () {
                      var _0x4dcf7a = $(this).attr('data-slotNovo')
                      if (Number(i) === Number(_0x4dcf7a)) {
                        const _0x2112dc =
                          '\n                                    <div class="item-player trunckChest"  data-item-antigo="' +
                          i +
                          '" data-item-amount="' +
                          _0x286660.count +
                          '" data-item-type="' +
                          _0x286660.type +
                          '" data-item-index="' +
                          _0x286660.index +
                          '" data-item-peso="' +
                          _0x286660.peso +
                          '" data-item-key="' +
                          _0x286660.name +
                          '" data-item-name="' +
                          _0x286660.label +
                          '" data-item-desc="' +
                          _0x286660.descricao +
                          '" data-item-funcao="' +
                          _0x286660.funcao +
                          '" data-weapon-dano="' +
                          _0x286660.dano +
                          '" data-weapon-cadencia="' +
                          _0x286660.cadencia +
                          '" data-weapon-precisao="' +
                          _0x286660.precisao +
                          '" data-weapon-recoil="' +
                          _0x286660.recoil +
                          '" style="background-image: url(\'' +
                          ip +
                          '/' +
                          _0x286660.name +
                          '.png\');">\n                                        <div class="top-item">\n                                            <div class="amount">' +
                          _0x286660.count +
                          'x</div>\n                                            <div class="peso">' +
                          (_0x286660.peso * _0x286660.count).toFixed(1) +
                          'kg</div>\n                                        </div>\n                                        <div class="bottom-item">\n                                            <div class="name-item">' +
                          _0x286660.label +
                          '\n                                            <div class="typeFilter">' +
                          _0x286660.filter +
                          '</div>\n                                        </div>\n                                        </div>\n                                    </div>\n                                    '
                        $(this).attr('data-temItem', 'true')
                        $(this).append(_0x2112dc)
                      }
                    })
                }
              }
            } else {
              if (_0x24ece6.chest === 'house') {
                $('.left-menu-chest').css('opacity', '1')
                nomeHouse = _0x24ece6.nameHouse
                $('#box-menu-item-chest').html('')
                $('.name-car').html(nomeHouse)
                for (
                  let _0x19a5f2 = 0;
                  _0x19a5f2 < _0x24ece6.slots;
                  _0x19a5f2++
                ) {
                  $('#box-menu-item-chest').append(
                    '\n                        <div class="slotChest house" data-temItem="false" data-slotNovo="' +
                      _0x19a5f2 +
                      '"></div>\n                    '
                  )
                }
                for (i = 0; i < _0x24ece6.slots; i++) {
                  if (_0x24ece6.tableChest[i]) {
                    var _0x286660 = _0x24ece6.tableChest[i],
                      _0x5bc40d = $('.slotChest')
                    _0x5bc40d &&
                      $('.slotChest').each(function () {
                        var _0x1ab04d = $(this).attr('data-slotNovo')
                        if (Number(i) === Number(_0x1ab04d)) {
                          const _0x48fd16 =
                            '\n                                    <div class="item-player house"  data-item-antigo="' +
                            i +
                            '" data-item-amount="' +
                            _0x286660.count +
                            '" data-item-type="' +
                            _0x286660.type +
                            '" data-item-index="' +
                            _0x286660.index +
                            '" data-item-peso="' +
                            _0x286660.peso +
                            '" data-item-key="' +
                            _0x286660.name +
                            '" data-item-name="' +
                            _0x286660.label +
                            '" data-item-desc="' +
                            _0x286660.descricao +
                            '" data-item-funcao="' +
                            _0x286660.funcao +
                            '" data-weapon-dano="' +
                            _0x286660.dano +
                            '" data-weapon-cadencia="' +
                            _0x286660.cadencia +
                            '" data-weapon-precisao="' +
                            _0x286660.precisao +
                            '" data-weapon-recoil="' +
                            _0x286660.recoil +
                            '" style="background-image: url(\'' +
                            ip +
                            '/' +
                            _0x286660.name +
                            '.png\');">\n                                        <div class="top-item">\n                                            <div class="amount">' +
                            _0x286660.count +
                            'x</div>\n                                            <div class="peso">' +
                            (_0x286660.peso * _0x286660.count).toFixed(1) +
                            'kg</div>\n                                        </div>\n                                        <div class="bottom-item">\n                                            <div class="name-item">' +
                            _0x286660.label +
                            '\n                                            <div class="typeFilter">' +
                            _0x286660.filter +
                            '</div>\n                                        </div>\n                                        </div>\n                                    </div>\n                                    '
                          $(this).attr('data-temItem', 'true')
                          $(this).append(_0x48fd16)
                        }
                      })
                  }
                }
              }
            }
          }
        }
        updatePesoChest(_0x24ece6.tamanhoMyInv, _0x24ece6.tamanhoChest)
        getHover()
        getDrag()
      }
    )
    getHover()
    getDrag()
  }
  function _0x5d5272() {
    $.post(
      'http://Unique_inventory/requsetIdentity',
      JSON.stringify({}),
      (_0x56c24c) => {
        $('.identidade-js')
          .empty()
          .html(
            '\n            \n                <div class="title-identity">\n                    <img src="app/dedao.png">\n                </div>\n                <div class="itens-identity">\n                    <div class="primeiro-identity primeiro">' +
              config.nome +
              '</div>\n                    <div class="primeiro-identity segundo">' +
              _0x56c24c.nome +
              ' ' +
              _0x56c24c.sobrenome +
              '</div>\n                </div>\n                <div class="itens-identity">\n                    <div class="primeiro-identity primeiro">' +
              config.passaporte +
              '</div>\n                    <div class="primeiro-identity segundo">' +
              _0x56c24c.id +
              ' </div>\n                </div>\n                <div class="itens-identity">\n                    <div class="primeiro-identity primeiro">' +
              config.telefone +
              '</div>\n                    <div class="primeiro-identity segundo">' +
              _0x56c24c.telefone +
              '</div>\n                </div>\n                <div class="itens-identity">\n                    <div class="primeiro-identity primeiro">' +
              config.profissao +
              '</div>\n                    <div class="primeiro-identity segundo">' +
              _0x56c24c.emprego +
              '</div>\n                </div>\n                <div class="itens-identity">\n                    <div class="primeiro-identity primeiro">' +
              config.registro +
              '</div>\n                    <div class="primeiro-identity segundo">' +
              _0x56c24c.registro +
              '</div>\n                </div>\n                <div class="itens-identity">\n                    <div class="primeiro-identity primeiro">' +
              config.idade +
              '</div>\n                    <div class="primeiro-identity segundo">' +
              _0x56c24c.idade +
              '</div>\n                </div>\n                <div class="itens-identity"> '
          )
        if (_0x56c24c.admin === true) {
          $('.itens-identity.admin').show()
        } else {
          _0x56c24c.admin === false && $('.itens-identity.admin').hide()
        }
        $('.money').html(
          '\n                <div class="carteira-box">\n                    <div class="title-carteira">Cash Amount</div>\n                    <div class="saldinho saldo-carteira" data-count="' +
            _0x56c24c.carteira +
            '"> ' +
            formatter.format(_0x56c24c.carteira) +
            '</div>\n                </div>\n                <div class="banco-box">\n                    <div class="title-banco">Bank Amount</div>\n                    <div class="saldinho saldo-banco" data-count="' +
            _0x56c24c.banco +
            '"> ' +
            formatter.format(_0x56c24c.banco) +
            '</div>\n                </div>\n            '
        )
        update === false &&
          $('.saldinho').each(function () {
            var _0x30cf2b = $(this),
              _0xafcf32 = _0x30cf2b.attr('data-count')
            $({ countNum: _0x30cf2b.text() }).animate(
              { countNum: _0xafcf32 },
              {
                duration: 2000,
                easing: 'linear',
                step: function () {
                  _0x30cf2b.text(
                    '' + formatter.format(Math.floor(this.countNum))
                  )
                },
                complete: function () {
                  _0x30cf2b.text('' + formatter.format(this.countNum))
                },
              }
            )
          })
      }
    )
  }
  function _0x4ac9c1() {
    $.post(
      'http://Unique_inventory/requestItens',
      JSON.stringify({}),
      (_0x17f90f) => {
        $('#box-menu-item').html('')
        unidadesDesc = _0x17f90f.un
        numero = 0
        for (let _0x13608f = 0; _0x13608f < _0x17f90f.slot; _0x13608f++) {
          _0x13608f <= 4
            ? $('#box-menu-item').append(
                '\n                        <div class="slot" data-temItem="false" data-slotNovo="' +
                  _0x13608f +
                  '">\n                            </div>\n                        </div>\n                    '
              )
            : $('#box-menu-item').append(
                '\n                        <div class="slot" data-temItem="false" data-slotNovo="' +
                  _0x13608f +
                  '">\n                        </div>\n                    '
              )
        }
        for (i = 0; i < _0x17f90f.slot2; i++) {
          if (_0x17f90f.inventario[i]) {
            var _0x498f3d = _0x17f90f.inventario[i],
              _0x449466 = $('.slot')
            _0x449466 &&
              $('.slot').each(function () {
                var _0x36bfc2 = $(this).attr('data-slotNovo')
                if (Number(i) === Number(_0x36bfc2)) {
                  if (_0x36bfc2 <= 4) {
                    console.log(ip + '' + _0x498f3d.name + '.png');
                    
                    const _0x36f94d =
                      '\n                                    <div class="item-player inventory"  data-item-antigo="' +
                      i +
                      '" data-item-amount="' +
                      _0x498f3d.count +
                      '" data-item-type="' +
                      _0x498f3d.type +
                      '" data-item-index="' +
                      _0x498f3d.index +
                      '" data-item-peso="' +
                      _0x498f3d.peso +
                      '" data-item-key="' +
                      _0x498f3d.name +
                      '" data-item-name="' +
                      _0x498f3d.label +
                      '" data-item-desc="' +
                      _0x498f3d.descricao +
                      '" data-item-funcao="' +
                      _0x498f3d.funcao +
                      '" data-weapon-dano="' +
                      _0x498f3d.dano +
                      '" data-weapon-cadencia="' +
                      _0x498f3d.cadencia +
                      '" data-weapon-precisao="' +
                      _0x498f3d.precisao +
                      '" data-weapon-recoil="' +
                      _0x498f3d.recoil +
                      '" style="background-image: url(\'' +
                      ip +
                      '/' +
                      _0x498f3d.name +
                      '.png\');">\n                                        <div class="top-item">\n                                            <div class="amount">' +
                      _0x498f3d.count +
                      'x</div>\n                                            <div class="peso">' +
                      (_0x498f3d.peso * _0x498f3d.count).toFixed(1) +
                      'kg</div>\n                                        </div>\n                                        <div class="bottom-item">\n                                            <div class="name-item">' +
                      _0x498f3d.label +
                      '\n                                                <div class="typeFilter">' +
                      _0x498f3d.filter +
                      '</div>\n                                            </div>\n                                        </div>\n                                        <div>\n                                             ' +
                      
                      '\n                                        </div>\n                                    </div>\n                                    '
                    $(this).attr('data-temItem', 'true')
                    $(this).empty().append(_0x36f94d)
                  } else {
                    const _0x550b7e =
                      '\n                                    <div class="item-player inventory"  data-item-antigo="' +
                      i +
                      '" data-item-amount="' +
                      _0x498f3d.count +
                      '" data-item-type="' +
                      _0x498f3d.type +
                      '" data-item-index="' +
                      _0x498f3d.index +
                      '" data-item-peso="' +
                      _0x498f3d.peso +
                      '" data-item-key="' +
                      _0x498f3d.name +
                      '" data-item-name="' +
                      _0x498f3d.label +
                      '" data-item-desc="' +
                      _0x498f3d.descricao +
                      '" data-item-funcao="' +
                      _0x498f3d.funcao +
                      '" data-weapon-dano="' +
                      _0x498f3d.dano +
                      '" data-weapon-cadencia="' +
                      _0x498f3d.cadencia +
                      '" data-weapon-precisao="' +
                      _0x498f3d.precisao +
                      '" data-weapon-recoil="' +
                      _0x498f3d.recoil +
                      '" style="background-image: url(\'' +
                      ip +
                      '/' +
                      _0x498f3d.name +
                      '.png\');">\n                                        <div class="top-item">\n                                            <div class="amount">' +
                      _0x498f3d.count +
                      'x</div>\n                                            <div class="peso">' +
                      (_0x498f3d.peso * _0x498f3d.count).toFixed(1) +
                      'kg</div>\n                                        </div>\n                                        <div class="bottom-item">\n                                            <div class="name-item">' +
                      _0x498f3d.label +
                      '\n                                            <div class="typeFilter">' +
                      _0x498f3d.filter +
                      '</div>\n                                        </div>\n                                        </div>\n                                    </div>\n                                    '
                    $(this).attr('data-temItem', 'true')
                    $(this).empty().append(_0x550b7e)
                  }
                }
              })
          }
        }
        // for (a = 0; a < _0x17f90f.slotsComrpavel; a++) {
        //   $('#box-menu-item').append(
        //     '\n                    <div class="slotVenda">\n                        <div class="price">Kharid Slot Be Gheymat <br> <b>$' +
        //       _0x17f90f.slotPrice +
        //       '</b></div>\n                        <div class="button-slot-buy">Buy</div>\n                    </div>   \n                '
        //   )
        // }
        $('.button-slot-buy')
          .unbind()
          .click(function () {
            $.post(
              'http://Unique_inventory/buySlot',
              JSON.stringify({}),
              function (_0x431ac5) {}
            )
            var _0x141fb1 = new Audio('vendido.ogg')
            _0x141fb1.volume = 1
            _0x141fb1.play()
          })
        var _0x2dddef = Number(_0x17f90f.atualPeso),
          _0x1d4b70 = Number(_0x17f90f.maximoPeso),
          _0x432c05 = Number(_0x1d4b70) - Number(_0x2dddef),
          _0x54f465 = _0x2dddef / _0x1d4b70.toFixed(1)
        $('.peso-texto').html(_0x2dddef.toFixed(1) + '/' + _0x1d4b70.toFixed(1))
        $('.peso-sobrando').html(_0x432c05.toFixed(1) + ' free space')
        updatePeso(_0x54f465, _0x1d4b70)
        getHover()
        getDrag()
        craftUpdate === false &&
          ($('#box-menu-item').fadeIn(),
          $('.identity-inicial').fadeIn(),
          $('.filter-menu').fadeIn(),
          $('.right-menu').fadeIn(),
          $('.top-menu').fadeIn(),
          $('#box-menu-item-chest').fadeIn(),
          $('.right-menu').css('right', '0vw'),
          $('.filter-menu').css('left', '39vw'),
          $('.identity-inicial').css('left', '10vw'),
          $('#box-menu-item').css('right', '16.5vw'),
          $('.top-menu').css('top', '1.4vw'),
          $('#box-menu-item-chest').css('left', '5vw'),
          $('.all-loading').hide())
      }
    )
  }
  document.onkeyup = function (_0x5b6cc9) {
    _0x5b6cc9.which == 27 &&
      $.post(
        'http://Unique_inventory/closeInventory',
        JSON.stringify({}),
        function (_0x1dc1fb) {}
      )
  }
})
function verificarItem() {
  craftUpdate = true
  $('.result-craft').html('')
  $.post(
    'http://Unique_inventory/updateCraft',
    JSON.stringify({ tabela: caftItens })
  )
  $.post(
    'http://Unique_inventory/getResultCraft',
    JSON.stringify({}),
    (_0x362b88) => {
      _0x362b88.resultado &&
        _0x362b88.quantidade &&
        ($('.result-craft').html(
          '\n                <div class="result-item-player" data-index-craft="' +
            _0x362b88.index +
            '" data-item-craft=\'' +
            _0x362b88.resultado +
            "' data-amount-craft='" +
            _0x362b88.quantidade +
            "' style=\"background-image: url('" +
            ip +
            '/' +
            _0x362b88.resultado +
            '.png\')">\n                    <div class="amount-craft">' +
            _0x362b88.quantidade +
            '</div>\n                    <div class="name-craft">' +
            _0x362b88.resultado +
            '</div>\n                </div>\n            '
        ),
        $('.result-craft').css('opacity', '1'))
      updateDragCraft()
    }
  )
}
function restFilter() {
  $('.filtro-button').css('filter', 'invert(0%)')
  TableFilters = []
  resetarFilter = true
  $('.filtro-button').attr('click', 'false')
  filterItens()
  document.getElementById('barra-pesquisa').value = ''
}
function getDrag() {
  $('.slotChest').droppable({
    hoverClass: 'hoverControl2',
    drop: function (_0x4b9315, _0x513672) {
      if (_0x513672.draggable.hasClass('chest')) {
        var _0x896661 = $(this).attr('data-slotNovo'),
          _0x188d24 = _0x513672.draggable.data('item-antigo'),
          _0x1d6e47 = _0x513672.draggable.data('item-key')
        if (_0x896661 != _0x188d24 && _0x1d6e47 && nomeDoBau != null) {
          var _0x2fd6f0 = document.getElementById('quantidade').value
          if (metade === true && tudo === false) {
            var _0x2fd6f0 = Number(_0x513672.draggable.data('item-amount')) / 2
          } else {
            if (tudo === true && metade === false) {
              var _0x2fd6f0 = Number(_0x513672.draggable.data('item-amount'))
            }
          }
          if (_0x2fd6f0 < 1) {
            var _0x2fd6f0 = 1
          }
          var _0x2fd6f0 = parseInt(_0x2fd6f0)
          if (Number(_0x2fd6f0) > 0) {
            $.post(
              'http://Unique_inventory/moverItemChest',
              JSON.stringify({
                item: _0x1d6e47,
                oldSlot: _0x188d24,
                newSlot: _0x896661,
                amount: parseInt(_0x2fd6f0),
                chest: nomeDoBau,
              })
            )
            var _0x35a197 = new Audio('slot.ogg')
            _0x35a197.volume = 1
            _0x35a197.play()
          }
        }
      }
      if (_0x513672.draggable.hasClass('trunckChest')) {
        var _0x896661 = $(this).attr('data-slotNovo'),
          _0x188d24 = _0x513672.draggable.data('item-antigo'),
          _0x1d6e47 = _0x513672.draggable.data('item-key')
        if (_0x896661 != _0x188d24 && _0x1d6e47 && nomeTrunckChest != null) {
          var _0x2fd6f0 = document.getElementById('quantidade').value
          if (metade === true && tudo === false) {
            var _0x2fd6f0 = Number(_0x513672.draggable.data('item-amount')) / 2
          } else {
            if (tudo === true && metade === false) {
              var _0x2fd6f0 = Number(_0x513672.draggable.data('item-amount'))
            }
          }
          if (_0x2fd6f0 < 1) {
            var _0x2fd6f0 = 1
          }
          var _0x2fd6f0 = parseInt(_0x2fd6f0)
          if (Number(_0x2fd6f0) > 0) {
            $.post(
              'http://Unique_inventory/moverItemTrunckChest',
              JSON.stringify({
                item: _0x1d6e47,
                oldSlot: _0x188d24,
                newSlot: _0x896661,
                amount: parseInt(_0x2fd6f0),
                trunck: nomeTrunckChest,
              })
            )
            var _0x35a197 = new Audio('slot.ogg')
            _0x35a197.volume = 1
            _0x35a197.play()
          }
        }
      } else {
        if (_0x513672.draggable.hasClass('house')) {
          var _0x896661 = $(this).attr('data-slotNovo'),
            _0x188d24 = _0x513672.draggable.data('item-antigo'),
            _0x1d6e47 = _0x513672.draggable.data('item-key')
          if (_0x896661 != _0x188d24 && _0x1d6e47 && nomeHouse != null) {
            var _0x2fd6f0 = document.getElementById('quantidade').value
            if (metade === true && tudo === false) {
              var _0x2fd6f0 =
                Number(_0x513672.draggable.data('item-amount')) / 2
            } else {
              if (tudo === true && metade === false) {
                var _0x2fd6f0 = Number(_0x513672.draggable.data('item-amount'))
              }
            }
            if (_0x2fd6f0 < 1) {
              var _0x2fd6f0 = 1
            }
            var _0x2fd6f0 = parseInt(_0x2fd6f0)
            if (Number(_0x2fd6f0) > 0) {
              $.post(
                'http://Unique_inventory/moverItemHouse',
                JSON.stringify({
                  item: _0x1d6e47,
                  oldSlot: _0x188d24,
                  newSlot: _0x896661,
                  amount: parseInt(_0x2fd6f0),
                  trunck: nomeHouse,
                })
              )
              var _0x35a197 = new Audio('slot.ogg')
              _0x35a197.volume = 1
              _0x35a197.play()
            }
          }
        } else {
          if (_0x513672.draggable.hasClass('inventory')) {
            if ($(this).hasClass('chest')) {
              var _0x896661 = $(this).attr('data-slotNovo'),
                _0x188d24 = _0x513672.draggable.data('item-antigo'),
                _0x1d6e47 = _0x513672.draggable.data('item-key')
              if (_0x896661 != _0x188d24 && _0x1d6e47 && nomeDoBau != null) {
                var _0x2fd6f0 = document.getElementById('quantidade').value
                if (metade === true && tudo === false) {
                  var _0x2fd6f0 =
                    Number(_0x513672.draggable.data('item-amount')) / 2
                } else {
                  if (tudo === true && metade === false) {
                    var _0x2fd6f0 = Number(
                      _0x513672.draggable.data('item-amount')
                    )
                  }
                }
                if (_0x2fd6f0 < 1) {
                  var _0x2fd6f0 = 1
                }
                var _0x2fd6f0 = parseInt(_0x2fd6f0)
                if (Number(_0x2fd6f0) > 0) {
                  $.post(
                    'http://Unique_inventory/colocarItemInventory',
                    JSON.stringify({
                      item: _0x1d6e47,
                      oldSlot: _0x188d24,
                      newSlot: _0x896661,
                      amount: parseInt(_0x2fd6f0),
                      chest: nomeDoBau,
                    })
                  )
                  var _0x35a197 = new Audio('slot.ogg')
                  _0x35a197.volume = 1
                  _0x35a197.play()
                }
              }
            } else {
              if ($(this).hasClass('venda')) {
                var _0x188d24 = _0x513672.draggable.data('item-antigo'),
                  _0x1d6e47 = _0x513672.draggable.data('item-key')
                if (_0x1d6e47 && _0x188d24) {
                  var _0x2fd6f0 = document.getElementById('quantidade').value
                  if (metade === true && tudo === false) {
                    var _0x2fd6f0 =
                      Number(_0x513672.draggable.data('item-amount')) / 2
                  } else {
                    if (tudo === true && metade === false) {
                      var _0x2fd6f0 = Number(
                        _0x513672.draggable.data('item-amount')
                      )
                    }
                  }
                  if (_0x2fd6f0 < 1) {
                    var _0x2fd6f0 = 1
                  }
                  if (Number(_0x2fd6f0) > 0) {
                    $.post(
                      'http://Unique_inventory/venderItem',
                      JSON.stringify({
                        item: _0x1d6e47,
                        slot: _0x188d24,
                        amount: parseInt(_0x2fd6f0),
                      })
                    )
                    var _0x35a197 = new Audio('slot.ogg')
                    _0x35a197.volume = 1
                    _0x35a197.play()
                  }
                }
              } else {
                if ($(this).hasClass('trunckchest')) {
                  var _0x896661 = $(this).attr('data-slotNovo'),
                    _0x188d24 = _0x513672.draggable.data('item-antigo'),
                    _0x1d6e47 = _0x513672.draggable.data('item-key')
                  if (
                    _0x896661 != _0x188d24 &&
                    _0x1d6e47 &&
                    nomeTrunckChest != null
                  ) {
                    var _0x2fd6f0 = document.getElementById('quantidade').value
                    if (metade === true && tudo === false) {
                      var _0x2fd6f0 =
                        Number(_0x513672.draggable.data('item-amount')) / 2
                    } else {
                      if (tudo === true && metade === false) {
                        var _0x2fd6f0 = Number(
                          _0x513672.draggable.data('item-amount')
                        )
                      }
                    }
                    if (_0x2fd6f0 < 1) {
                      var _0x2fd6f0 = 1
                    }
                    var _0x2fd6f0 = parseInt(_0x2fd6f0)
                    if (Number(_0x2fd6f0) > 0) {
                      $.post(
                        'http://Unique_inventory/colocarItemTrunkInventory',
                        JSON.stringify({
                          item: _0x1d6e47,
                          oldSlot: _0x188d24,
                          newSlot: _0x896661,
                          amount: parseInt(_0x2fd6f0),
                          chest: nomeTrunckChest,
                        })
                      )
                      var _0x35a197 = new Audio('slot.ogg')
                      _0x35a197.volume = 1
                      _0x35a197.play()
                    }
                  }
                } else {
                  if ($(this).hasClass('house')) {
                    var _0x896661 = $(this).attr('data-slotNovo'),
                      _0x188d24 = _0x513672.draggable.data('item-antigo'),
                      _0x1d6e47 = _0x513672.draggable.data('item-key')
                    if (
                      _0x896661 != _0x188d24 &&
                      _0x1d6e47 &&
                      nomeHouse != null
                    ) {
                      var _0x2fd6f0 =
                        document.getElementById('quantidade').value
                      if (metade === true && tudo === false) {
                        var _0x2fd6f0 =
                          Number(_0x513672.draggable.data('item-amount')) / 2
                      } else {
                        if (tudo === true && metade === false) {
                          var _0x2fd6f0 = Number(
                            _0x513672.draggable.data('item-amount')
                          )
                        }
                      }
                      if (_0x2fd6f0 < 1) {
                        var _0x2fd6f0 = 1
                      }
                      var _0x2fd6f0 = parseInt(_0x2fd6f0)
                      if (Number(_0x2fd6f0) > 0) {
                        $.post(
                          'http://Unique_inventory/colocarItemHouse',
                          JSON.stringify({
                            item: _0x1d6e47,
                            oldSlot: _0x188d24,
                            newSlot: _0x896661,
                            amount: parseInt(_0x2fd6f0),
                            chest: nomeHouse,
                          })
                        )
                        var _0x35a197 = new Audio('slot.ogg')
                        _0x35a197.volume = 1
                        _0x35a197.play()
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    },
  })
  $('.slot').droppable({
    hoverClass: 'hoverControl2',
    drop: function (_0x397c41, _0x4427d0) {
      if (_0x4427d0.draggable.hasClass('inventory')) {
        var _0x54ff57 = $(this).attr('data-slotNovo'),
          _0x241c9d = _0x4427d0.draggable.data('item-antigo')
        if (_0x54ff57 && _0x54ff57 != _0x241c9d) {
          var _0x40ebe8 = _0x4427d0.draggable.data('item-key')
          if ((_0x40ebe8 && _0x241c9d) || (_0x40ebe8 && _0x241c9d === 0)) {
            var _0x3e2039 = document.getElementById('quantidade').value
            if (metade === true && tudo === false) {
              var _0x3e2039 =
                Number(_0x4427d0.draggable.data('item-amount')) / 2
            } else {
              if (tudo === true && metade === false) {
                var _0x3e2039 = Number(_0x4427d0.draggable.data('item-amount'))
              }
            }
            if (_0x3e2039 < 1) {
              var _0x3e2039 = 1
            }
            var _0x3e2039 = parseInt(_0x3e2039)
            if (Number(_0x3e2039) > 0) {
              $.post(
                'http://Unique_inventory/moverItem',
                JSON.stringify({
                  item: _0x40ebe8,
                  oldSlot: _0x241c9d,
                  newSlot: _0x54ff57,
                  amount: parseInt(_0x3e2039),
                })
              )
              var _0x31371a = new Audio('slot.ogg')
              _0x31371a.volume = 1
              _0x31371a.play()
              restFilter()
            }
          }
        }
      } else {
        if (_0x4427d0.draggable.hasClass('chest')) {
          var _0x3f436c = $(this).attr('data-slotNovo'),
            _0x241c9d = _0x4427d0.draggable.data('item-antigo')
          if (_0x3f436c) {
            var _0x40ebe8 = _0x4427d0.draggable.data('item-key')
            if (_0x40ebe8 && nomeDoBau != null) {
              var _0x3e2039 = document.getElementById('quantidade').value
              if (metade === true && tudo === false) {
                var _0x3e2039 =
                  Number(_0x4427d0.draggable.data('item-amount')) / 2
              } else {
                if (tudo === true && metade === false) {
                  var _0x3e2039 = Number(
                    _0x4427d0.draggable.data('item-amount')
                  )
                }
              }
              if (_0x3e2039 < 1) {
                var _0x3e2039 = 1
              }
              var _0x3e2039 = parseInt(_0x3e2039)
              if (Number(_0x3e2039) > 0) {
                $.post(
                  'http://Unique_inventory/retirarItemChest',
                  JSON.stringify({
                    item: _0x40ebe8,
                    oldSlot: _0x241c9d,
                    newSlot: _0x3f436c,
                    amount: parseInt(_0x3e2039),
                    chest: nomeDoBau,
                  })
                )
                var _0x31371a = new Audio('slot.ogg')
                _0x31371a.volume = 1
                _0x31371a.play()
              }
            }
          }
        } else {
          if (_0x4427d0.draggable.hasClass('trunckChest')) {
            var _0x3f436c = $(this).attr('data-slotNovo'),
              _0x241c9d = _0x4427d0.draggable.data('item-antigo')
            if (_0x3f436c) {
              var _0x40ebe8 = _0x4427d0.draggable.data('item-key')
              if (_0x40ebe8 && nomeTrunckChest != null) {
                var _0x3e2039 = document.getElementById('quantidade').value
                if (metade === true && tudo === false) {
                  var _0x3e2039 =
                    Number(_0x4427d0.draggable.data('item-amount')) / 2
                } else {
                  if (tudo === true && metade === false) {
                    var _0x3e2039 = Number(
                      _0x4427d0.draggable.data('item-amount')
                    )
                  }
                }
                if (_0x3e2039 < 1) {
                  var _0x3e2039 = 1
                }
                var _0x3e2039 = parseInt(_0x3e2039)
                if (Number(_0x3e2039) > 0) {
                  $.post(
                    'http://Unique_inventory/retirarItemTrunk',
                    JSON.stringify({
                      item: _0x40ebe8,
                      oldSlot: _0x241c9d,
                      newSlot: _0x3f436c,
                      amount: parseInt(_0x3e2039),
                      chest: nomeTrunckChest,
                    })
                  )
                  var _0x31371a = new Audio('slot.ogg')
                  _0x31371a.volume = 1
                  _0x31371a.play()
                }
              }
            }
          } else {
            if (_0x4427d0.draggable.hasClass('house')) {
              var _0x3f436c = $(this).attr('data-slotNovo'),
                _0x241c9d = _0x4427d0.draggable.data('item-antigo')
              if (_0x3f436c) {
                var _0x40ebe8 = _0x4427d0.draggable.data('item-key')
                if (_0x40ebe8 && nomeHouse != null) {
                  var _0x3e2039 = document.getElementById('quantidade').value
                  if (metade === true && tudo === false) {
                    var _0x3e2039 =
                      Number(_0x4427d0.draggable.data('item-amount')) / 2
                  } else {
                    if (tudo === true && metade === false) {
                      var _0x3e2039 = Number(
                        _0x4427d0.draggable.data('item-amount')
                      )
                    }
                  }
                  if (_0x3e2039 < 1) {
                    var _0x3e2039 = 1
                  }
                  var _0x3e2039 = parseInt(_0x3e2039)
                  if (Number(_0x3e2039) > 0) {
                    $.post(
                      'http://Unique_inventory/retirarItemHouse',
                      JSON.stringify({
                        item: _0x40ebe8,
                        oldSlot: _0x241c9d,
                        newSlot: _0x3f436c,
                        amount: parseInt(_0x3e2039),
                        chest: nomeHouse,
                      })
                    )
                    var _0x31371a = new Audio('slot.ogg')
                    _0x31371a.volume = 1
                    _0x31371a.play()
                  }
                }
              }
            }
          }
        }
      }
      var _0x3c6470 = _0x4427d0.draggable.attr('data-item-price')
      if (_0x3c6470) {
        var _0x40ebe8 = _0x4427d0.draggable.data('item-key'),
          _0x3e2039 = document.getElementById('quantidade').value,
          _0x54ff57 = $(this).attr('data-slotNovo')
        if (parseInt(_0x3e2039) > 0) {
          var _0x3e2039 = parseInt(_0x3e2039)
          $.post(
            'http://Unique_inventory/buyItem',
            JSON.stringify({
              item: _0x40ebe8,
              preco: _0x3c6470,
              newSlot: _0x54ff57,
              amount: _0x3e2039,
            })
          )
          var _0x31371a = new Audio('slot.ogg')
          _0x31371a.volume = 1
          _0x31371a.play()
        }
      }
      var _0x8e4ddb = _0x4427d0.draggable.data('item-craft'),
        _0x265795 = _0x4427d0.draggable.data('index-craft'),
        _0x1321b9 = _0x4427d0.draggable.data('amount-craft'),
        _0x54ff57 = $(this).attr('data-slotNovo')
      _0x8e4ddb &&
        _0x1321b9 &&
        ($.post(
          'http://Unique_inventory/resgatarItem',
          JSON.stringify({
            slot: _0x54ff57,
            quantidade: _0x1321b9,
            item: _0x8e4ddb,
            index: _0x265795,
          })
        ),
        (caftItens = [
          {
            item: 'nada',
            quantidade: 0,
          },
          {
            item: 'nada',
            quantidade: 0,
          },
          {
            item: 'nada',
            quantidade: 0,
          },
          {
            item: 'nada',
            quantidade: 0,
          },
          {
            item: 'nada',
            quantidade: 0,
          },
          {
            item: 'nada',
            quantidade: 0,
          },
          {
            item: 'nada',
            quantidade: 0,
          },
          {
            item: 'nada',
            quantidade: 0,
          },
          {
            item: 'nada',
            quantidade: 0,
          },
        ]),
        $('.slot-craft').attr('hasItem', 'false'),
        $('.slot-craft').css('background-image', ''),
        $('.slot-craft').html(''),
        verificarItem())
    },
  })
  $('.slot-craft').droppable({
    hoverClass: 'hoverControl3',
    drop: function (_0x256a54, _0x4d8004) {
      if ($(this).attr('hasItem') != 'true') {
        var _0x1d1731 = _0x4d8004.draggable.data('item-index'),
          _0x585a43 = _0x4d8004.draggable.data('item-index'),
          _0x5efc8c = $(this)
        if (_0x1d1731 != undefined) {
          var _0x412a09 = document.getElementById('quantidade').value,
            _0x46905d = parseInt(_0x4d8004.draggable.data('item-amount'))
          if (metade === true && tudo === false) {
            var _0x412a09 =
              parseInt(_0x4d8004.draggable.data('item-amount')) / 2
          } else {
            if (tudo === true && metade === false) {
              var _0x412a09 = parseInt(_0x4d8004.draggable.data('item-amount'))
            }
          }
          if (_0x412a09 < 1) {
            var _0x412a09 = 1
          }
          var _0x412a09 = parseInt(_0x412a09)
          if (parseInt(_0x412a09) <= parseInt(_0x46905d) && _0x412a09 > 0) {
            var _0x412a09 = parseInt(_0x412a09)
            _0x5efc8c.html(
              '\n                                <div class="amount-craft">' +
                _0x412a09 +
                'x</div>\n                                <div class="name-craft">' +
                _0x1d1731 +
                '</div>\n                            '
            )
            _0x5efc8c.css('opacity', '1')
            var _0x4afc10 = new Audio('slot.ogg')
            _0x4afc10.volume = 1
            _0x4afc10.play()
            _0x5efc8c.attr('hasItem', 'true')
            _0x5efc8c.css(
              'background-image',
              "url('" + ip + '/' + _0x1d1731 + ".png')"
            )
            var _0x565864 = _0x5efc8c.attr('class').split(' ')[1],
              _0x540988 = _0x4d8004.draggable.data('item-antigo')
            caftItens[parseInt(_0x565864)].item = _0x1d1731
            caftItens[parseInt(_0x565864)].quantidade = parseInt(_0x412a09)
            $.post(
              'http://Unique_inventory/craftItemRemove',
              JSON.stringify({
                item: _0x585a43,
                oldSlot: _0x540988,
                amount: parseInt(_0x412a09),
              })
            )
            verificarItem()
          }
        }
      }
    },
  })
  $('.slot-craft')
    .unbind()
    .dblclick(function () {
      $(this).attr('hasItem', 'false')
      $(this).css('background-image', '')
      $(this).html('')
      var _0x3d134d = $(this),
        _0x21d0bc = _0x3d134d.attr('class').split(' ')[1],
        _0xdcff21 = caftItens[Number(_0x21d0bc)].item,
        _0x5c8bce = caftItens[Number(_0x21d0bc)].quantidade
      $.post(
        'http://Unique_inventory/craftItemDbClick',
        JSON.stringify({
          item: _0xdcff21,
          amount: parseInt(_0x5c8bce),
        })
      )
      caftItens[Number(_0x21d0bc)].item = 'nada'
      caftItens[Number(_0x21d0bc)].quantidade = 0
      $('.slot-craft').css('opacity', '0.6')
      verificarItem()
    })
  $('.item-player').draggable({
    helper: 'clone',
    appendTo: '#menu-principal',
    zIndex: 99999,
    revert: 'invalid',
    opacity: 1,
    start: function (_0x4ad267, _0x1f9535) {
      $(this).children().children('img').hide()
      let _0x7c58cc = $(this)
      _0x7c58cc.addClass('active')
      $('.desc-normal').show()
    },
    stop: function () {
      $(this).children().children('img').show()
      let _0x42b9bb = $(this)
      _0x42b9bb.removeClass('active')
    },
  })
  $('.action').droppable({
    hoverClass: 'actionDropp',
    drop: function (_0xf984f1, _0x4aba03) {
      if ($(this).hasClass('usar')) {
        var _0xa5758 = _0x4aba03.draggable.data('item-type'),
          _0x17c58c = _0x4aba03.draggable.data('item-key'),
          _0x51395b = _0x4aba03.draggable.data('item-antigo'),
          _0x2f20e3 = document.getElementById('quantidade').value
        if (metade === true && tudo === false) {
          var _0x2f20e3 = Number(_0x4aba03.draggable.data('item-amount')) / 2
        } else {
          if (tudo === true && metade === false) {
            var _0x2f20e3 = Number(_0x4aba03.draggable.data('item-amount'))
          }
        }
        if (_0x2f20e3 < 1) {
          var _0x2f20e3 = 1
        }
        var _0x2f20e3 = parseInt(_0x2f20e3)
        $.post(
          'http://Unique_inventory/usarItem',
          JSON.stringify({
            item: _0x17c58c,
            amount: parseInt(_0x2f20e3),
            type: _0xa5758,
            slot: _0x51395b,
          })
        )
      } else {
        if ($(this).hasClass('enviar')) {
          var _0x17c58c = _0x4aba03.draggable.data('item-key'),
            _0x2f20e3 = document.getElementById('quantidade').value,
            _0x51395b = _0x4aba03.draggable.data('item-antigo')
          if (metade === true && tudo === false) {
            var _0x2f20e3 = Number(_0x4aba03.draggable.data('item-amount')) / 2
          } else {
            if (tudo === true && metade === false) {
              var _0x2f20e3 = Number(_0x4aba03.draggable.data('item-amount'))
            }
          }
          if (_0x2f20e3 < 1) {
            var _0x2f20e3 = 1
          }
          var _0x2f20e3 = parseInt(_0x2f20e3)
          _0x2f20e3 > 0 &&
            $.post(
              'http://Unique_inventory/enviarItem',
              JSON.stringify({
                item: _0x17c58c,
                amount: parseInt(_0x2f20e3),
                slot: _0x51395b,
              })
            )
        } else {
          if ($(this).hasClass('dropar')) {
            var _0x17c58c = _0x4aba03.draggable.data('item-key'),
              _0x2f20e3 = document.getElementById('quantidade').value,
              _0x51395b = _0x4aba03.draggable.data('item-antigo')
            if (metade === true && tudo === false) {
              var _0x2f20e3 =
                Number(_0x4aba03.draggable.data('item-amount')) / 2
            } else {
              if (tudo === true && metade === false) {
                var _0x2f20e3 = Number(_0x4aba03.draggable.data('item-amount'))
              }
            }
            if (_0x2f20e3 < 1) {
              var _0x2f20e3 = 1
            }
            var _0x2f20e3 = parseInt(_0x2f20e3)
            _0x2f20e3 > 0 &&
              $.post(
                'http://Unique_inventory/droparItem',
                JSON.stringify({
                  item: _0x17c58c,
                  amount: parseInt(_0x2f20e3),
                  slot: _0x51395b,
                })
              )
          }
        }
      }
    },
  })
}
$('.dividendo')
  .unbind()
  .click(function () {
    if (click === false) {
      $('.closeDividendo').empty()
      $('.dividendo').removeClass('active')
      $('.closeDividendo').removeClass()
      $(this).addClass('active')
      $(this).append(
        '\n            <div class="closeDividendo">\n                <img src="' +
          ip +
          '/close.png">\n            </div>\n        '
      )
      var _0x543357 = document.querySelector('#quantidade')
      _0x543357.disabled = true
      $('#quantidade').css('opacity', '0.5')
      document.getElementById('quantidade').value = '\uD83D\uDD12'
      if ($(this).hasClass('metade-item')) {
        tudo = false
        metade = true
      } else {
        $(this).hasClass('todos-itens') && ((tudo = true), (metade = false))
      }
    }
    updateCloseBind()
  })
function updateCloseBind() {
  $('.closeDividendo').click(function () {
    click = true
    $('.closeDividendo').empty()
    $('.dividendo').removeClass('active')
    $('.closeDividendo').removeClass()
    tudo = false
    metade = false
    var _0xe35087 = document.querySelector('#quantidade')
    _0xe35087.disabled = false
    $('#quantidade').css('opacity', '1')
    document.getElementById('quantidade').value = ''
    setTimeout(() => {
      click = false
    }, 300)
  })
}
$('.escolha-menu')
  .unbind()
  .click(function () {
    $('.escolha-menu').css('opacity', '0.3')
    $(this).hasClass('identidade') &&
      ($('.weapon-box').fadeOut(),
      $('.margin-bottom-escolha').css('left', '18.8vw'),
      $(this).css('opacity', '1'),
      $('.identity-inicial').slideUp(),
      $('.escolha-menu.personagem').html('UNIQUE'),
      $('.hud').fadeOut(),
      setTimeout(() => {
        $('.craft').slideDown()
        $('.filter-menu').slideDown()
      }, 300))
    $(this).hasClass('personagem') &&
      ($('.weapon-box').fadeOut(),
      $('.margin-bottom-escolha').css('left', '8.8vw'),
      $(this).css('opacity', '1'),
      $('.craft').slideUp(),
      $('.escolha-menu.personagem').html('UNIQUE'),
      setTimeout(() => {
        $('.identity-inicial').slideDown()
        $('.hud').fadeIn()
        $('.filter-menu').slideDown()
      }, 300))
  })
function updateDragCraft() {
  $('.result-item-player').draggable({
    helper: 'clone',
    appendTo: '#menu-principal',
    zIndex: 99999,
    revert: 'invalid',
    opacity: 1,
    start: function (_0x123e73, _0x384234) {
      $(this).children().children('img').hide()
      let _0x20e664 = $(this)
      _0x20e664.addClass('active')
    },
    stop: function () {
      $(this).children().children('img').show()
      let _0x1e5658 = $(this)
      _0x1e5658.removeClass('active')
    },
  })
}
function getHover() {
  $('.item-player').hover(
    function () {
      if ($(this).hasClass('venda')) {
        var _0x4aaa8c = $(this).data('item-price')
        $(this).append(
          '\n                <div class="principal-price">\n                    <div class="hover-price">\n                        <span>' +
            _0x4aaa8c +
            ',00</span>\n                    </div>\n                </div>\n            '
        )
      }
      $('#box-menu-item').css('height', '29vw')
      $('.desc-normal').hide()
      $('.desc-weapon').hide()
      $('.descricao-menu').show()
      var _0x5a7c0e = $(this).data('item-name'),
        _0x12314a = $(this).data('item-peso'),
        _0x2ddf63 = $(this).data('item-index'),
        _0xb8ab4c = $(this).data('item-type'),
        _0x5935b2 = $(this).data('item-desc'),
        _0x4f0255 = $(this).data('item-funcao'),
        _0x47b11b = unidadesDesc
      $('.item-name-desc').html(_0x5a7c0e)
      $('.bloco-image').css(
        'background-image',
        'url("' + ip + '/' + _0x2ddf63 + '.png")'
      )
      if (
        _0xb8ab4c === 'usar' ||
        _0x5935b2 ===
          'Arma utilizada para prática de atividades legais e ilegais'
      ) {
        $('.desc-normal').show()
        $('.primeira-descricao').html(_0x5935b2)
        $('.peso-descricao span').html(
          _0x12314a +
            'kg Per Unit (' +
            _0x47b11b +
            'un = ' +
            Number(_0x12314a) * _0x47b11b +
            'kg)'
        )
        _0x4f0255 === false
          ? ($('.funcao-descricao').hide(),
            $('.peso-descricao').css('top', '1.3vw'))
          : ($('.peso-descricao').css('top', '0vw'),
            $('.funcao-descricao').show(),
            $('.funcao-descricao').html('<b>Função: </b> ' + _0x4f0255))
      } else {
        if (_0xb8ab4c === 'equipar') {
          var _0x256e07 = $(this).data('weapon-recoil'),
            _0x2360f2 = $(this).data('weapon-dano'),
            _0x30164c = $(this).data('weapon-cadencia'),
            _0x2429bf = $(this).data('weapon-precisao')
          _0x30164c && $('.frontbar.cadencia').width(_0x30164c + '%')
          _0x2360f2 && $('.frontbar.dano').width(_0x2360f2 + '%')
          _0x256e07 && $('.frontbar.recuo').width(_0x256e07 + '%')
          _0x2429bf && $('.frontbar.precisao').width(_0x2429bf + '%')
          $('.desc-weapon').show()
        }
      }
    },
    function () {
      $('#box-menu-item').css('height', '33vw')
      $('.descricao-menu').hide()
      $('.principal-price').empty()
    }
  )
}
circulo = new ProgressBar.Circle(circle, {
  strokeWidth: 10,
  easing: 'easeInOut',
  duration: 1400,
  color: '#ffffff',
  trailColor: '#8080802c',
  trailWidth: 8.5,
})
circulochest = new ProgressBar.Circle(circleChest, {
  strokeWidth: 10,
  easing: 'easeInOut',
  duration: 1400,
  color: '#ffffff',
  trailColor: '#8080802c',
  trailWidth: 8.5,
})
function updatePesoChest(_0x2dd103, _0x33b2c9) {
  var _0xe3cd7b = _0x2dd103 / _0x33b2c9,
    _0x5cbb22 = _0x33b2c9 - _0x2dd103
  circulochest.animate(_0xe3cd7b.toFixed(1))
  $('.peso-sobrando-chest').html(_0x5cbb22.toFixed(1) + 'free space')
  $('.peso-texto-chest').html(_0x2dd103.toFixed(1) + '/' + _0x33b2c9.toFixed(1))
}
function updatePeso(_0x327bdb, _0x5621a6) {
  $('.circle-mochila').css('background', 'rgba(133, 133, 133, 0.356)')
  $('.circle-mochila').css('box-shadow', '')
  circulo.animate(_0x327bdb)
  if (_0x5621a6 === 90) {
    $('.circle-mochila').css('background', 'white')
    $('.circle-mochila').css('box-shadow', '0px 0px 7px 1px #ffffffb0')
  } else {
    if (_0x5621a6 === 75) {
      $('.circle-mochila.1').css('background', 'white')
      $('.circle-mochila.2').css('background', 'white')
      $('.circle-mochila.1').css('box-shadow', '0px 0px 7px 1px #ffffffb0')
      $('.circle-mochila.2').css('box-shadow', '0px 0px 7px 1px #ffffffb0')
    } else {
      if (_0x5621a6 === 51) {
        $('.circle-mochila.1').css('background', 'white')
        $('.circle-mochila.1').css('box-shadow', '0px 0px 7px 1px #ffffffb0')
      } else {
        _0x5621a6 === 6 &&
          ($('.circle-mochila').css('background', 'rgba(133, 133, 133, 0.356)'),
          $('.circle-mochila').css('box-shadow', ''))
      }
    }
  }
}
function filterItens() {
  if (resetarFilter == true) {
    $('.item-player').show()
  } else {
    $('.item-player').css('display', 'none')
    for (i = 0; i < TableFilters.length; i++) {
      var _0x56a08d = TableFilters[i],
        _0x65a797 = $('.typeFilter')
        
        for (a = 0; a < _0x65a797.length; a++) {
         
        if (_0x65a797[a].textContent === _0x56a08d) {
          for (b = 0; b < _0x65a797.length; b++) {
            var _0x5de664 = document.getElementsByClassName('item-player')[b],
              _0x2eb7b6 = _0x5de664.querySelector('.typeFilter')
            _0x2eb7b6.textContent === _0x65a797[a].textContent &&
              (_0x5de664.style.display = 'block')
          }
        }
      }
    }
  }
}
$('.clear-filter').click(function () {
  restFilter()
  var _0x1861c3 = new Audio('slot.ogg')
  _0x1861c3.volume = 1
  _0x1861c3.play()
})
$('.filtro-button').click(function () {
  $('.filtro-button').css('filter', 'invert(0%)')
  $(this).css('filter', 'invert(100%)')
  $(this).attr('click', 'true')
  TableFilters = []
  TableFilters.push($(this).attr('class').split(' ')[1])
  resetarFilter = false
  filterItens()
  document.getElementById('barra-pesquisa').value = ''
  var _0x315e1e = new Audio('slot.ogg')
  _0x315e1e.volume = 1
  _0x315e1e.play()
})
function pesquisar() {
  $('.filtro-button').css('filter', 'invert(0%)')
  TableFilters = []
  resetarFilter = true
  $('.filtro-button').attr('click', 'false')
  filterItens()
  var _0xbca74d,
    _0x26d4c7,
    _0x5a9af5,
    _0x240b2a,
    _0x2aa7e3,
    _0x10e425,
    _0x50d663
  _0xbca74d = document.getElementById('barra-pesquisa')
  _0x26d4c7 = _0xbca74d.value.toUpperCase()
  _0x5a9af5 = document.getElementById('box-menu-item')
  _0x240b2a = _0x5a9af5.getElementsByClassName('item-player')
  for (_0x10e425 = 0; _0x10e425 < _0x240b2a.length; _0x10e425++) {
    _0x2aa7e3 = _0x240b2a[_0x10e425].getElementsByClassName('name-item')[0]
    _0x50d663 = _0x2aa7e3.textContent || _0x2aa7e3.innerText
    _0x50d663.toUpperCase().indexOf(_0x26d4c7) > -1
      ? (_0x240b2a[_0x10e425].style.display = '')
      : (_0x240b2a[_0x10e425].style.display = 'none')
  }
}
$('#barra-pesquisa').hover(
  function () {
    $('.toltip-pesquisa').show()
  },
  function () {
    $('.toltip-pesquisa').hide()
  }
)
