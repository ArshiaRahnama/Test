<?php $ACTIVE='gallery'; require __DIR__."/lib.php"; if (!FEATURES['gallery']) go('index.php');
$me = me(); $uid = $me ? (int)$me['id'] : 0; $admin = $me && $me['role'] === 'admin';
// لایک (ajax)
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['a'] ?? '') === 'like') {
  header('Content-Type: application/json'); if (!$me) { http_response_code(401); exit('{}'); } csrf_check();
  $id = (int)($_POST['id'] ?? 0); $db = db();
  $q = $db->prepare("SELECT 1 FROM web_gallery WHERE id=? AND status='approved'"); $q->execute([$id]); if (!$q->fetchColumn()) exit('{}');
  $q = $db->prepare('SELECT 1 FROM web_likes WHERE user_id=? AND post_id=?'); $q->execute([$uid, $id]);
  if ($q->fetchColumn()) { $db->prepare('DELETE FROM web_likes WHERE user_id=? AND post_id=?')->execute([$uid, $id]); $liked = false; } else { $db->prepare('INSERT INTO web_likes(user_id,post_id) VALUES(?,?)')->execute([$uid, $id]); $liked = true; }
  $q = $db->prepare('SELECT COUNT(*) FROM web_likes WHERE post_id=?'); $q->execute([$id]); exit(json_encode(['liked' => $liked, 'n' => (int)$q->fetchColumn()]));
}
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['a'] ?? '') === 'gal_upload') {
  if (!$me) go('auth.php'); csrf_check();
  $_SESSION['gflash'] = !empty($_POST['agree']) ? gallery_save($uid, $_FILES['file'] ?? [], (string)($_POST['caption'] ?? '')) : [false, 'پذیرفتن قوانین الزامی است.']; go('gallery.php');
}
?>
<!DOCTYPE html>
<html lang="fa" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>گالری | یونیک رول پلی</title>
<meta name="description" content="لحظه‌های ثبت‌شده توسط شهروندان شهر یونیک؛ عکس‌های شهر، خودروها، گنگ‌ها و رویدادها.">
<meta name="theme-color" content="#050505">
<link rel="canonical" href="https://example.com/gallery.php">
<meta property="og:url" content="https://example.com/gallery.php">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'%3E%3Cpath d='M16 8v28a16 16 0 0 0 32 0V8' fill='none' stroke='%23ffc107' stroke-width='11' stroke-linecap='round'/%3E%3C/svg%3E">
<link rel="stylesheet" href="style.css">
</head>
<body>
<?php
require __DIR__.'/inc/head-nav.php';
$gf = $_SESSION['gflash'] ?? null; unset($_SESSION['gflash']);
$tab = ($_GET['tab'] ?? '') === 'featured' ? 'featured' : 'all'; $kind = in_array($_GET['k'] ?? '', ['photo', 'video'], true) ? $_GET['k'] : ''; $sort = ($_GET['s'] ?? '') === 'top' ? 'top' : 'new';
$posts = gallery_list($kind, $sort, $uid, $tab === 'featured'); $feat = $tab === 'all' && !$kind ? gallery_list('', 'top', $uid, true, 10) : [];
$total = (int)db()->query("SELECT COUNT(*) FROM web_gallery WHERE status='approved'")->fetchColumn();
$card = function (array $g) use ($me) { ob_start(); ?>
  <figure class="gp" data-id="<?= (int)$g['id'] ?>" data-kind="<?= e($g['kind']) ?>" data-src="uploads/<?= e($g['file']) ?>" data-cap="<?= e($g['caption']) ?>" data-by="<?= e($g['fullname']) ?>">
    <?php if ($g['kind'] === 'video'): ?><video src="uploads/<?= e($g['file']) ?>#t=0.1" preload="metadata" muted></video><span class="play">▶</span><?php else: ?><img loading="lazy" src="uploads/<?= e($g['file']) ?>" alt="<?= e($g['caption']) ?>"><?php endif; ?>
    <figcaption><span class="by"><?= e($g['fullname']) ?></span><button class="lk <?= $g['liked'] ? 'on' : '' ?>" aria-label="لایک"><b><?= (int)$g['likes'] ?></b> ♥</button></figcaption></figure>
<?php return ob_get_clean(); };
?>
<main>
<section class="pagehero"><div class="wrap">
  <h1>گالری <span class="gt">شهر</span></h1><p class="sub">بهترین عکس‌ها و ویدیوهای شهر که توسط شهروندان ثبت شده است؛ منتخب رأی و لایک کاربران.</p>
  <div class="row-actions" style="justify-content:center;margin-top:18px"><span class="tag open"><?= $total ?> پست منتشرشده</span>
    <?php if ($me): ?><button class="btn pri" onclick="document.getElementById('upl').showModal()">ارسال عکس یا ویدیو</button><?php else: ?><a class="btn pri" href="auth.php">ورود برای ارسال</a><?php endif; ?></div>
</div></section>
<section style="padding-top:10px"><div class="wrap">
  <?php if ($gf): ?><p class="<?= $gf[0] ? 'ok-msg' : 'err' ?>" role="status"><?= e($gf[1]) ?></p><?php endif; ?>
  <div class="seg" style="flex-wrap:wrap">
    <button class="<?= $tab === 'all' ? 'on' : '' ?>" onclick="location='gallery.php'">گالری</button><button class="<?= $tab === 'featured' ? 'on' : '' ?>" onclick="location='gallery.php?tab=featured'">برگزیده‌ها</button>
    <?php if ($tab === 'all'): foreach (['' => 'همه', 'photo' => 'عکس‌ها', 'video' => 'ویدیوها'] as $k => $l): ?><button class="<?= $kind === $k ? 'on' : '' ?>" onclick="location='gallery.php?k=<?= $k ?>&s=<?= $sort ?>'"><?= $l ?></button><?php endforeach; ?>
    <select onchange="location=this.value" style="width:auto"><option value="gallery.php?k=<?= e($kind) ?>&s=new" <?= $sort === 'new' ? 'selected' : '' ?>>جدیدترین</option><option value="gallery.php?k=<?= e($kind) ?>&s=top" <?= $sort === 'top' ? 'selected' : '' ?>>پرلایک‌ترین</option></select><?php endif; ?></div>
  <?php if ($feat): ?><h3 style="margin:18px 0 8px">⭐ برگزیده‌ها</h3><div class="gfeat"><?php foreach ($feat as $g) echo $card($g); ?></div><?php endif; ?>
  <div class="ggrid"><?php foreach ($posts as $g) echo $card($g); if (!$posts) echo '<div class="empty2" style="grid-column:1/-1">هنوز پستی منتشر نشده است.</div>'; ?></div>
</div></section>
</main>

<dialog id="upl"><form method="post" enctype="multipart/form-data"><?= csrf_field() ?><input type="hidden" name="a" value="gal_upload">
  <h3>ارسال به گالری</h3><ul class="rules"><?php foreach (GAL_RULES as $r): ?><li><?= e($r) ?></li><?php endforeach; ?></ul>
  <label>فایل (عکس تا ۸MB، ویدیو تا ۶۰MB)<input type="file" name="file" accept="image/jpeg,image/png,image/webp,video/mp4,video/webm" required></label>
  <label>توضیح (اختیاری)<input name="caption" maxlength="140"></label>
  <label class="opt"><input type="checkbox" name="agree" value="1" required> قوانین را مطالعه کرده و می‌پذیرم</label>
  <div class="row-actions"><button class="btn pri">ادامه و ارسال</button><button type="button" class="btn" onclick="upl.close()">انصراف</button></div></form></dialog>
<dialog id="lb"><button class="btn" onclick="lb.close()" style="position:absolute;top:10px;inset-inline-start:10px;z-index:2">✕</button><div id="lbm"></div><p id="lbc" style="padding:10px 14px"></p></dialog>
<script>
const CSRF=<?= json_encode(csrf()) ?>, LOGGED=<?= $me ? 'true' : 'false' ?>;
document.querySelectorAll('.gp').forEach(f=>{
  f.querySelector('.lk').onclick=async e=>{e.stopPropagation();if(!LOGGED){location='auth.php';return}
    const d=new FormData();d.append('a','like');d.append('id',f.dataset.id);d.append('csrf',CSRF);const r=await fetch('gallery.php',{method:'POST',body:d});if(!r.ok)return;const j=await r.json();
    if(j.n===undefined)return;document.querySelectorAll('.gp[data-id="'+f.dataset.id+'"]').forEach(x=>{x.querySelector('.lk b').textContent=j.n;x.querySelector('.lk').classList.toggle('on',j.liked)})};
  f.onclick=()=>{const m=document.getElementById('lbm');m.innerHTML='';const el=document.createElement(f.dataset.kind==='video'?'video':'img');el.src=f.dataset.src;if(el.tagName==='VIDEO'){el.controls=true;el.autoplay=true}m.appendChild(el);
    document.getElementById('lbc').textContent=f.dataset.by+(f.dataset.cap?' — '+f.dataset.cap:'');lb.showModal()}});
lb.addEventListener('close',()=>document.getElementById('lbm').innerHTML='');
</script>
<?php require __DIR__.'/inc/foot.php'; ?>
</body>
</html>
