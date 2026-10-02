<?php
require __DIR__ . '/lib.php';
if (!FEATURES['shop']) go('dashboard.php');
$u = need_login(); $uid = (int)$u['id']; $db = db();

/* --- اکشن‌ها --- */
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  csrf_check(); $a = $_POST['a'] ?? '';
  if ($a === 'fav') {   // ajax
    $id = (int)($_POST['id'] ?? 0); header('Content-Type: application/json');
    $q = $db->prepare('SELECT 1 FROM web_favs WHERE user_id=? AND item_id=?'); $q->execute([$uid, $id]);
    if ($q->fetchColumn()) { $db->prepare('DELETE FROM web_favs WHERE user_id=? AND item_id=?')->execute([$uid, $id]); echo json_encode(['fav' => false]); }
    else { $db->prepare('INSERT INTO web_favs(user_id,item_id) VALUES(?,?)')->execute([$uid, $id]); echo json_encode(['fav' => true]); }
    exit;
  }
  if ($a === 'buy') {
    [$okb, $msg] = shop_buy($u, (int)($_POST['id'] ?? 0), (string)($_POST['method'] ?? ''));
    $_SESSION['sflash'] = [$okb, $msg]; go('shop.php?' . http_build_query(array_intersect_key($_GET, array_flip(['cat', 'sub', 'q', 'sort', 'fav']))));
  }
}
$flash = $_SESSION['sflash'] ?? null; unset($_SESSION['sflash']);

$cat = isset(SHOP_CATS[$_GET['cat'] ?? '']) ? $_GET['cat'] : ''; $sub = ($cat && isset(SHOP_CATS[$cat]['subs'][$_GET['sub'] ?? ''])) ? $_GET['sub'] : '';
$q = trim((string)($_GET['q'] ?? '')); $sort = in_array($_GET['sort'] ?? '', ['dear', 'cheap', 'new'], true) ? $_GET['sort'] : 'dear'; $favOnly = ($_GET['fav'] ?? '') === '1';
$items = shop_items($cat, $sub, $q, $sort, $uid); if ($favOnly) $items = array_values(array_filter($items, fn($i) => (int)$i['fav'] > 0));
$w = wallet_get($uid); [$bank, $tc] = game_money($u);
$counts = []; foreach ($db->query('SELECT cat,COUNT(*) c FROM web_shop_items WHERE active=1 GROUP BY cat')->fetchAll() as $r) $counts[$r['cat']] = (int)$r['c'];
$qs = fn(array $o) => 'shop.php?' . http_build_query(array_filter(array_merge(['cat' => $cat, 'sub' => $sub, 'q' => $q, 'sort' => $sort === 'dear' ? '' : $sort, 'fav' => $favOnly ? '1' : ''], $o), fn($v) => $v !== '' && $v !== null));
$ICON = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6"><path d="M6 7h12l1 13H5L6 7Z"/><path d="M9 7a3 3 0 0 1 6 0"/></svg>';
?><!DOCTYPE html>
<html lang="fa" dir="rtl"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>فروشگاه | <?= e(CFG['name']) ?></title><meta name="theme-color" content="#050505"><link rel="stylesheet" href="style.css"></head>
<body class="shop">
<div class="shtop"><div class="shwrap">
  <a href="index.php" class="logo"><b>فروشگاه</b><small class="mut"><?= e(CFG['fa']) ?></small></a>
  <details class="dd"><summary class="btn">دسته‌بندی‌ها ▾</summary><div class="ddm"><?php foreach (SHOP_CATS as $k => $c): ?><div><a href="<?= e($qs(['cat' => $k, 'sub' => ''])) ?>"><b><?= e($c['label']) ?></b></a><?php foreach ($c['subs'] as $sk => $sl): ?><a href="<?= e($qs(['cat' => $k, 'sub' => $sk])) ?>"><?= e($sl) ?></a><?php endforeach; ?></div><?php endforeach; ?></div></details>
  <form method="get" class="shsearch"><input name="q" value="<?= e($q) ?>" placeholder="جستجو در فروشگاه..."><?php if ($cat): ?><input type="hidden" name="cat" value="<?= e($cat) ?>"><?php endif; ?></form>
  <details class="dd"><summary class="btn bal"><span dir="ltr">$<?= toman($bank) ?></span> · <span><?= toman($w['tokens']) ?> توکن</span> ▾</summary><div class="ddm bm">
    <p><span>توکن</span><b><?= toman($w['tokens']) ?></b></p><p><span>پول بازی (بانک)</span><b dir="ltr">$<?= toman($bank) ?></b></p><p><span>TC</span><b><?= toman($tc) ?></b></p><p><span>کیف پول</span><b><?= toman($w['toman']) ?> تومان</b></p>
    <a class="btn pri" href="dashboard.php?p=wallet">شارژ کیف پول</a></div></details>
  <a class="btn" href="dashboard.php"><?= e($u['fullname']) ?></a>
</div></div>

<div class="shwrap shbody">
  <main>
    <?php if ($flash): ?><p class="<?= $flash[0] ? 'ok-msg' : 'err' ?>" role="status"><?= e($flash[1]) ?></p><?php endif; ?>
    <div class="shbar"><h2 style="margin:0"><?= e($cat ? SHOP_CATS[$cat]['label'] . ($sub ? ' · ' . SHOP_CATS[$cat]['subs'][$sub] : '') : ($favOnly ? 'علاقه‌مندی‌ها' : 'همه‌ی آیتم‌ها')) ?> <small class="mut"><?= count($items) ?> آیتم</small></h2>
      <div class="row-actions"><a class="btn <?= $favOnly ? 'gold' : '' ?>" href="<?= e($qs(['fav' => $favOnly ? '' : '1'])) ?>">♥ علاقه‌مندی‌ها</a>
        <select onchange="location=this.value" style="width:auto"><?php foreach (['dear' => 'گران‌ترین', 'cheap' => 'ارزان‌ترین', 'new' => 'جدیدترین'] as $k => $l): ?><option value="<?= e($qs(['sort' => $k === 'dear' ? '' : $k])) ?>" <?= $sort === $k ? 'selected' : '' ?>><?= $l ?></option><?php endforeach; ?></select></div></div>
    <div class="pgrid">
    <?php foreach ($items as $i): ?>
      <article class="pcard">
        <button class="favb <?= $i['fav'] ? 'on' : '' ?>" data-id="<?= (int)$i['id'] ?>" aria-label="علاقه‌مندی">♥</button>
        <div class="pimg"><?= $i['image'] ? '<img loading="lazy" src="' . e($i['image']) . '" alt="">' : $ICON ?></div>
        <small dir="ltr" class="mut"><?= e($i['code']) ?></small><h3><?= e($i['name']) ?></h3>
        <div class="prices"><?php if ((int)$i['price_money']): ?><span class="pr g" dir="ltr">$<?= toman((int)$i['price_money']) ?></span><?php endif; if ((int)$i['price_token']): ?><span class="pr t"><?= (int)$i['price_token'] ?> توکن</span><?php endif; if ((int)$i['price_tc']): ?><span class="pr c"><?= (int)$i['price_tc'] ?> TC</span><?php endif; ?></div>
        <button class="btn pri buy" data-item='<?= e(json_encode(['id' => (int)$i['id'], 'name' => $i['name'], 'm' => (int)$i['price_money'], 't' => (int)$i['price_token'], 'c' => (int)$i['price_tc']], JSON_UNESCAPED_UNICODE)) ?>'>خرید</button>
      </article>
    <?php endforeach; if (!$items) echo '<div class="empty2" style="grid-column:1/-1">آیتمی پیدا نشد.</div>'; ?>
    </div>
  </main>
  <aside class="shside"><a class="<?= !$cat ? 'on' : '' ?>" href="shop.php">همه‌ی دسته‌ها</a>
    <?php foreach (SHOP_CATS as $k => $c): ?><a class="<?= $cat === $k && !$sub ? 'on' : '' ?>" href="<?= e($qs(['cat' => $k, 'sub' => ''])) ?>"><?= e($c['label']) ?> <small><?= (int)($counts[$k] ?? 0) ?></small></a>
      <?php if ($cat === $k): foreach ($c['subs'] as $sk => $sl): ?><a class="sub <?= $sub === $sk ? 'on' : '' ?>" href="<?= e($qs(['cat' => $k, 'sub' => $sk])) ?>"><?= e($sl) ?></a><?php endforeach; endif; endforeach; ?></aside>
</div>

<dialog id="bdlg"><form method="post"><?= csrf_field() ?><input type="hidden" name="a" value="buy"><input type="hidden" name="id" id="bid">
  <h3 id="bname"></h3><p class="mut">روش پرداخت را انتخاب کنید:</p><div id="bopts"></div>
  <p class="hint">پرداخت با پول بازی و TC فقط زمانی ممکن است که در بازی آفلاین باشید. آیتم پس از خرید در بازی تحویل داده می‌شود.</p>
  <div class="row-actions"><button class="btn pri">تایید خرید</button><button class="btn" type="button" onclick="bdlg.close()">انصراف</button></div></form></dialog>
<script>
const CSRF=<?= json_encode(csrf()) ?>, bdlg=document.getElementById('bdlg'), fmt=n=>Number(n).toLocaleString('en');
document.querySelectorAll('.favb').forEach(b=>b.onclick=async()=>{const f=new FormData();f.append('a','fav');f.append('id',b.dataset.id);f.append('csrf',CSRF);
  const r=await fetch('shop.php',{method:'POST',body:f});if(r.ok){const d=await r.json();b.classList.toggle('on',d.fav)}});
document.querySelectorAll('.buy').forEach(b=>b.onclick=()=>{const d=JSON.parse(b.dataset.item);document.getElementById('bid').value=d.id;document.getElementById('bname').textContent=d.name;
  const o=[];if(d.m)o.push(['money','$'+fmt(d.m)+' پول بازی']);if(d.t)o.push(['token',d.t+' توکن']);if(d.c)o.push(['tc',d.c+' TC']);
  document.getElementById('bopts').innerHTML=o.map((x,i)=>`<label class="opt"><input type="radio" name="method" value="${x[0]}" ${i?'':'checked'}> ${x[1]}</label>`).join('');bdlg.showModal()});
</script>
</body></html>
