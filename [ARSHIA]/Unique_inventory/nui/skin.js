/* UNIQUE Inventory — visual layer only.
   Never calls the backend and never touches app.js state. Everything is
   wrapped in try/catch so a failure here can never break the inventory. */
(function () {
  'use strict'

  // Cosmetic rarity (the database has no rarity field): weapons = epic,
  // ammo/armor/weapon-class filter = rare, high-count currency = legendary,
  // consumables = uncommon, everything else = common.
  function rarityOf(el) {
    var type = el.getAttribute('data-item-type') || ''
    var key = (el.getAttribute('data-item-key') || '').toLowerCase()
    var f = ((el.querySelector('.typeFilter') || {}).textContent || '').trim()
    if (type === 'item_weapon' || key.indexOf('weapon_') === 0) return 'epic'
    if (/black_money|gold|diamond|bitcoin/.test(key)) return 'legendary'
    if (/armor|armour|ammo|kevlar/.test(key) || f === 'arma') return 'rare'
    if (f === 'food' || f === 'soda') return 'uncommon'
    return 'common'
  }

  function decorate(root) {
    try {
      var list = (root || document).querySelectorAll('.item-player:not([data-r])')
      for (var i = 0; i < list.length; i++) list[i].setAttribute('data-r', rarityOf(list[i]))
      var rows = (root || document).querySelectorAll('.itens-identity')
      for (var j = 0; j < rows.length; j++) {
        if (!rows[j].classList.contains('admin') && !rows[j].textContent.trim()) rows[j].style.display = 'none'
      }
    } catch (e) {}
  }

  function boot() {
    var main = document.getElementById('menu-principal')
    if (!main) return

    // Rarity: decorate every item the inventory renders (pocket, trunk, shop).
    try {
      new MutationObserver(function () {
        decorate(main)
      }).observe(main, { childList: true, subtree: true })
      decorate(main)
    } catch (e) {}

    // Empty-detail placeholder, visible whenever the item detail panel is hidden.
    try {
      var stage = document.querySelector('.background-color')
      var desc = document.querySelector('.descricao-menu')
      if (stage && desc) {
        var ph = document.createElement('div')
        ph.id = 'detail-placeholder'
        ph.innerHTML = '<i></i><span>Hover an item to see its details</span>'
        stage.appendChild(ph)
        var sync = function () {
          ph.style.display = getComputedStyle(desc).display === 'none' ? 'flex' : 'none'
        }
        new MutationObserver(sync).observe(desc, { attributes: true, attributeFilter: ['style'] })
        sync()
      }
    } catch (e) {}
  }

  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', boot)
  else boot()
})()
