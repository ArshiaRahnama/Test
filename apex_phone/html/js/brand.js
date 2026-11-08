/* ============================================================================================
   UNIQUE MOBILE - branding layer for the Unique RP server.
   Loaded LAST (after main.js). It never touches the phone's code: it only rewrites the TEXT that reaches the screen,
   including text the i18n layer writes later (MutationObserver, run synchronously before the next paint).

     * the app names become the names of the real apps they imitate (WhatsApp, Instagram, ...)
     * "Apex" -> "Unique"  ("Apex Mobile" -> "Unique Mobile")
     * the mail domain apex.ls -> arshiahub.ir

   To change a name, edit the tables below (nothing else in the phone needs to change).
   ============================================================================================ */
(function () {
  'use strict';

  /* names that are unique enough to be replaced anywhere in a sentence */
  var WORDS = [
    [/\bZapp\b/g,       'WhatsApp'],
    [/\bInstashot\b/g,  'Instagram'],
    [/\bTweeter\b/g,    'Twitter'],
    [/\bFaceCall\b/g,   'FaceTime'],
    [/\bApex Mobile\b/g, 'Unique Mobile'],
    [/\bApex(?=[A-Z0-9])/g, 'Unique'],   /* ApexNet -> UniqueNet, Apex5G ... */
    [/\bApex\b/g,       'Unique'],
    [/\bapex\.ls\b/g,   'arshiahub.ir']
  ];
  /* ordinary English words that are ALSO app names: replaced only when they are the WHOLE text of a label */
  var EXACT = { 'Match': 'Tinder', 'Eats': 'Uber Eats' };

  var QUICK = /Zapp|Instashot|Tweeter|FaceCall|Apex|apex\.ls|^\s*(?:Match|Eats)\s*$/;
  var ATTRS = ['title', 'placeholder', 'aria-label', 'alt'];
  var SKIP = { SCRIPT: 1, STYLE: 1, TEXTAREA: 1, INPUT: 1, NOSCRIPT: 1 };

  function fix(s) {
    if (!s || !QUICK.test(s)) return s;
    var t = s.trim();
    if (Object.prototype.hasOwnProperty.call(EXACT, t)) return s.replace(t, EXACT[t]);
    for (var i = 0; i < WORDS.length; i++) s = s.replace(WORDS[i][0], WORDS[i][1]);
    return s;
  }

  function editable(el) {
    for (; el && el.nodeType === 1; el = el.parentNode) {
      if (SKIP[el.tagName]) return true;
      if (el.isContentEditable) return true;
    }
    return false;
  }

  function fixText(n) {
    var v = n.nodeValue, w = fix(v);
    if (w !== v && !editable(n.parentNode)) n.nodeValue = w;
  }

  function fixAttrs(el) {
    for (var i = 0; i < ATTRS.length; i++) {
      var v = el.getAttribute && el.getAttribute(ATTRS[i]);
      if (v) { var w = fix(v); if (w !== v) el.setAttribute(ATTRS[i], w); }
    }
  }

  function walk(root) {
    if (!root) return;
    if (root.nodeType === 3) { fixText(root); return; }
    if (root.nodeType !== 1) return;
    if (SKIP[root.tagName]) return;
    fixAttrs(root);
    var tw = document.createTreeWalker(root, NodeFilter.SHOW_TEXT | NodeFilter.SHOW_ELEMENT, null);
    var n;
    while ((n = tw.nextNode())) {
      if (n.nodeType === 3) fixText(n);
      else if (n.nodeType === 1 && !SKIP[n.tagName]) fixAttrs(n);
    }
  }

  function start() {
    try { walk(document.body); } catch (e) {}
    var mo = new MutationObserver(function (recs) {
      for (var i = 0; i < recs.length; i++) {
        var r = recs[i];
        try {
          if (r.type === 'characterData') fixText(r.target);
          else if (r.type === 'attributes') fixAttrs(r.target);
          else for (var j = 0; j < r.addedNodes.length; j++) walk(r.addedNodes[j]);
        } catch (e) {}
      }
    });
    mo.observe(document.body, { subtree: true, childList: true, characterData: true, attributes: true, attributeFilter: ATTRS });
    document.title = fix(document.title);
  }

  if (document.body) start(); else document.addEventListener('DOMContentLoaded', start);
  window.UniqueBrand = { fix: fix, words: WORDS, exact: EXACT };
})();
