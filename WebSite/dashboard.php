<?php
require __DIR__ . '/lib.php';
$u = need_login();

// وضعیت آنلاین/آخرین حضور؛ صفحه‌ی نمای کلی هر ۲۰ ثانیه از این اندپوینت می‌خونه.
if (($_GET['ajax'] ?? '') === 'status') {
  header('Content-Type: application/json; charset=utf-8');
  echo json_encode(['online' => (bool)$u['online'], 'seenText' => $u['online'] ? 'الان' : ($u['seenSecsAgo'] !== null ? ago_secs($u['seenSecsAgo']) : '—')], JSON_UNESCAPED_UNICODE);
  exit;
}

require_once __DIR__ . '/inc/dash_ext.php';
$db = db(); $p = $_GET['p'] ?? 'home'; $flash = ''; $ok = '';
$admin = $u['role'] === 'admin';
if (!$admin && $p === 'srvlogs') $p = 'home';

function ticket_of(int $id, array $u): ?array {
  $s = db()->prepare('SELECT * FROM web_tickets WHERE id=?'); $s->execute([$id]); $t = $s->fetch();
  return ($t && ($t['user_id'] == $u['id'] || $u['role'] === 'admin')) ? $t : null;
}
function add_msg(int $tid, int $uid, string $b): void {
  db()->prepare('INSERT INTO web_msgs(ticket_id,user_id,body,created) VALUES(?,?,?,?)')->execute([$tid, $uid, mb_substr($b, 0, 2000), time()]);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  csrf_check(); $a = $_POST['a'] ?? '';
  dash_ext_post($u, $admin, $flash, $ok, $p);
  if ($a === 'new') {
    $s = trim($_POST['subject'] ?? ''); $b = trim($_POST['body'] ?? '');
    if ($s === '' || $b === '' || mb_strlen($s) > 120) { $flash = 'موضوع و متن را کامل بنویس.'; $p = 'tickets'; }
    else {
      $cat = (string)($_POST['category'] ?? 'support'); $cat = isset(TICKET_CATS[$cat]) ? $cat : 'support';
      $db->prepare('INSERT INTO web_tickets(user_id,subject,status,created,category) VALUES(?,?,?,?,?)')->execute([$u['id'], $s, 'open', time(), $cat]);
      $id = (int)$db->lastInsertId(); add_msg($id, $u['id'], $b); go("dashboard.php?p=ticket&id=$id");
    }
  } elseif ($a === 'reply' || $a === 'close') {
    $id = (int)($_POST['id'] ?? 0); $t = ticket_of($id, $u);
    if ($t) {
      if ($a === 'close') $db->prepare("UPDATE web_tickets SET status='closed' WHERE id=?")->execute([$id]);
      elseif (trim($_POST['body'] ?? '') !== '' && $t['status'] !== 'closed') {
        add_msg($id, $u['id'], trim($_POST['body']));
        $isStaffReply = $admin && $t['user_id'] != $u['id'];
        $db->prepare('UPDATE web_tickets SET status=? WHERE id=?')->execute([$isStaffReply ? 'answered' : 'open', $id]);
      }
      go("dashboard.php?p=ticket&id=$id");
    }
  } elseif ($a === 'pass') {
    $p = 'settings'; $lq = $db->prepare('SELECT password,password_salt FROM login_users WHERE id=?'); $lq->execute([$u['lid']]); $lr = $lq->fetch(); $nw = $_POST['new'] ?? '';
    if (rate_full('pw-' . $u['lid'], 5, 900)) $flash = 'تلاش‌های زیاد؛ ۱۵ دقیقه بعد دوباره امتحان کن.';
    elseif (!$lr || !hash_equals((string)$lr['password'], game_hash($_POST['old'] ?? '', (string)$lr['password_salt']))) { rate_hit('pw-' . $u['lid'], 900); $flash = 'رمز فعلی اشتباه است.'; }
    elseif (strlen($nw) < 6 || !preg_match('/\d/', $nw) || !preg_match('/[A-Za-z]/', $nw)) $flash = 'رمز جدید حداقل ۶ کاراکتر و شامل یک حرف انگلیسی و یک عدد باشد.';
    else { $salt = bin2hex(random_bytes(16)); $db->prepare('UPDATE login_users SET password=?,password_salt=? WHERE id=?')->execute([game_hash($nw, $salt), $salt, $u['lid']]); $ok = 'رمز عبور تغییر کرد؛ از این به بعد داخل بازی هم با همین رمز وارد می‌شی.'; }
  }
}

$mask = preg_match('/^09\d{9}$/', $u['phone']) ? substr($u['phone'], 0, 4) . '***' . substr($u['phone'], -4) : '—';
function job_label(string $j): string { foreach (CFG['depts'] as $d) if ($d['job'] === $j) return $d['label']; return $j === 'unemployed' ? 'بیکار' : $j; }
// فرمت مشترک «چند وقت پیش» — هم ago() (از روی timestamp) و هم ago_secs() (از روی ثانیه‌ی
// آماده، مثلاً seenSecsAgo که خودِ MySQL حساب می‌کنه) از همین یکی استفاده می‌کنن تا منطق دوبار نگه‌داری نشه.
function _ago_fmt(int $s): string { $s = max(0, $s); return $s < 90 ? 'همین الان' : ($s < 3600 ? intdiv($s, 60) . ' دقیقه پیش' : ($s < 172800 ? intdiv($s, 3600) . ' ساعت پیش' : intdiv($s, 86400) . ' روز پیش')); }
function ago(int $t): string { return _ago_fmt(time() - $t); }
function ago_secs(int $s): string { return _ago_fmt($s); }
function playdur(int $sec): string {
  $sec = max(0, $sec);
  if ($sec < 3600) return number_format(intdiv($sec, 60)) . ' دقیقه';
  if ($sec < 86400) return number_format(intdiv($sec, 3600)) . ' ساعت';
  $d = intdiv($sec, 86400); $h = intdiv($sec % 86400, 3600);
  return number_format($d) . ' روز' . ($h > 0 ? ' و ' . $h . ' ساعت' : '');
}
const AUDIT = ['login_success' => 'ورود موفق به سرور', 'login_fail' => 'تلاش ناموفق برای ورود', 'register' => 'ساخت حساب', 'password_reset' => 'بازیابی رمز', 'password_change' => 'تغییر رمز از داخل بازی', 'new_device' => 'ورود از دستگاه جدید', 'logout_all' => 'خروج از همه‌ی دستگاه‌ها', 'security_hold' => 'قفل امنیتی فعال شد', 'security_hold_cleared' => 'قفل امنیتی باز شد'];
$st = ['open' => 'باز', 'answered' => 'پاسخ داده شد', 'closed' => 'بسته'];
$cnt = fn($sql, $args = []) => (function () use ($db, $sql, $args) { $s = $db->prepare($sql); $s->execute($args); return (int)$s->fetchColumn(); })();
$I = [ // آیکون‌ها
 'home' => '<path d="M3 11 12 3l9 8v9a1 1 0 0 1-1 1h-5v-6H9v6H4a1 1 0 0 1-1-1v-9Z"/>',
 'info' => '<rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="9" cy="11" r="2"/><path d="M14 10h4M14 14h4M6 16c.5-1.5 1.5-2 3-2s2.500.5 3 2"/>',
 'tickets' => '<path d="M21 11.500a8.400 8.400 0 0 1-8.400 8.400 8.600 8.600 0 0 1-3.800-.9L3 20l1-5.600a8.400 8.400 0 0 1-.9-3.900A8.400 8.400 0 0 1 11.500 2 8.600 8.600 0 0 1 21 11.500Z"/>',
 'settings' => '<circle cx="12" cy="12" r="3"/><path d="M19.400 15a1.700 1.700 0 0 0 .3 1.800l.1.1a2 2 0 1 1-2.800 2.800l-.1-.1a1.700 1.700 0 0 0-1.800-.3 1.700 1.700 0 0 0-1 1.500V21a2 2 0 1 1-4 0v-.1a1.700 1.700 0 0 0-1.100-1.500 1.700 1.700 0 0 0-1.800.3l-.1.1a2 2 0 1 1-2.800-2.800l.1-.1a1.700 1.700 0 0 0 .3-1.800 1.700 1.700 0 0 0-1.500-1H3a2 2 0 1 1 0-4h.1a1.700 1.700 0 0 0 1.500-1.100 1.700 1.700 0 0 0-.3-1.800l-.1-.1a2 2 0 1 1 2.800-2.800l.1.1a1.700 1.700 0 0 0 1.800.3H9a1.700 1.700 0 0 0 1-1.500V3a2 2 0 1 1 4 0v.1a1.700 1.700 0 0 0 1 1.500 1.700 1.700 0 0 0 1.800-.3l.1-.1a2 2 0 1 1 2.800 2.800l-.1.1a1.700 1.700 0 0 0-.3 1.800V9a1.700 1.700 0 0 0 1.500 1H21a2 2 0 1 1 0 4h-.1a1.700 1.700 0 0 0-1.500 1Z"/>',
];
$I += ext_nav_icons();
$nav = ['home' => 'نمای کلی', 'info' => 'کارت شهروندی', 'tickets' => 'پشتیبانی (تیکت)', 'settings' => 'تنظیمات'];
$adm = ['srvlogs' => 'لاگ‌های سرور'];
$ico = fn($k) => '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' . $I[$k] . '</svg>';
?><!DOCTYPE html>
<html lang="fa" dir="rtl"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>داشبورد شهروندی | <?= e(CFG['name']) ?></title><meta name="theme-color" content="#050505">
<link rel="stylesheet" href="style.css"></head>
<body class="dash">
<div class="dtop"><a href="index.php" class="logo"><svg viewBox="0 0 64 64"><defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#ffe08a"/><stop offset="1" stop-color="#d18f00"/></linearGradient></defs><path d="M16 8v28a16 16 0 0 0 32 0V8" fill="none" stroke="url(#g)" stroke-width="11" stroke-linecap="round"/></svg><span><?= e(strtok(CFG['name'], ' ')) ?> <b><?= e(trim(strstr(CFG['name'], ' '))) ?></b></span></a>
  <a class="btn" href="index.php">صفحه اصلی</a><a class="btn" href="auth.php?out=1">خروج</a></div>
<div class="dlayout">
<aside class="side">
  <div class="ucard"><div class="av"><?= e(mb_substr($u['fullname'], 0, 1)) ?></div><b dir="ltr"><?= e($u['fullname']) ?></b><small dir="ltr">@<?= e($u['username']) ?></small><span class="rolebadge"><?= e($u['rank'] ?: 'شهروند') ?></span></div>
  <div class="dnav">
    <?php foreach ($nav as $k => $l): ?><a href="dashboard.php?p=<?= $k ?>" class="<?= ($p === $k || ($p === 'ticket' && $k === 'tickets')) ? 'on' : '' ?>"><?= $ico($k) ?><?= $l ?></a><?php endforeach; ?>
    <?php if ($admin): ?><hr><?php foreach ($adm as $k => $l): ?><a href="dashboard.php?p=<?= $k ?>" class="<?= $p === $k ? 'on' : '' ?>"><?= $ico($k) ?><?= $l ?></a><?php endforeach; endif; ?>
  </div>
</aside>
<main class="dmain">
<?php if ($flash): ?><p class="err" role="alert"><?= e($flash) ?></p><?php endif; ?>
<?php if ($ok): ?><p class="ok-msg" role="status"><?= e($ok) ?></p><?php endif; ?>

<?php if ($p === 'home'):
  $tk = $cnt("SELECT COUNT(*) FROM web_tickets WHERE user_id=? AND status<>'closed'", [$u['id']]); ?>
  <?php $g = $u['game']; $lv = (int)$u['level']; $act = [];
    try { $aq = $db->prepare('SELECT action,created_at FROM login_audit WHERE username=? ORDER BY created_at DESC LIMIT 5'); $aq->execute([$u['username']]); $act = $aq->fetchAll(); } catch (Throwable $e) {} ?>
  <section class="pro">
    <div class="pro-av <?= $u['online'] ? 'on' : '' ?>" id="proAv"><span><?= e(mb_substr($u['fullname'], 0, 1)) ?></span></div>
    <div class="pro-body">
      <small class="mut">خوش اومدی</small>
      <h2 class="gt" dir="ltr"><?= e($u['fullname']) ?></h2>
      <div class="chips"><span>@<?= e($u['username']) ?></span>
        <?php // BUG FIX: این بج فقط برای کادر/ادمین‌ها پر می‌شه — چون $u['rank'] برای بازیکن‌های عادی
        // (permission_level == 0) توی me() از قبل null هست، کاربر عادی اصلاً این بج رو نمی‌بینه. ?>
        <?php if ($u['rank']): ?><span class="gold">Rank Admin: <?= e($u['rank']) ?></span><?php endif; ?>
        <?php if ($g): ?>
          <span>Job: <?= e(job_label((string)$g['job'])) ?> - <?= e(job_grade_label((string)$g['job'], (int)$g['job_grade'])) ?> (<?= (int)$g['job_grade'] ?>)</span>
          <?php if ($g['gang'] && $g['gang'] !== 'none' && $g['gang'] !== 'nogang'): ?><span>Gang: <?= e(gang_label((string)$g['gang'])) ?></span><?php endif; ?>
        <?php endif; ?>
        <span class="<?= $u['online'] ? 'live' : '' ?>" id="onlineBadge"><?= $u['online'] ? 'آنلاین در شهر' : 'آفلاین' ?></span></div>
      <?php if ($g): ?><div class="xp"><i style="width:<?= min(100, (int)round($lv / max(50, $lv) * 100)) ?>%"></i></div><small class="mut" dir="ltr">Level <?= $lv ?> · XP <?= number_format((int)$g['xp']) ?></small><?php endif; ?>
    </div>
  </section>
  <?php if ($g): ?>
  <div class="tiles">
    <div><span>پول نقد</span><b dir="ltr">$<?= number_format((int)$g['money']) ?></b></div>
    <div><span>موجودی بانک</span><b dir="ltr">$<?= number_format((int)$g['bank']) ?></b></div>
    <div><span>ساعت بازی</span><b><?= playdur((int)$g['timePlay']) ?></b></div>
    <div><span>آخرین حضور</span><b id="seenText"><?= $u['online'] ? 'الان' : ($u['seenSecsAgo'] !== null ? ago_secs($u['seenSecsAgo']) : '—') ?></b></div>
  </div>
  <script>
  // BUG FIX: هر ۲۰ ثانیه وضعیت آنلاین/آخرین حضور رو از سرور می‌گیره و بدون رفرش کامل صفحه
  // آپدیت می‌کنه — اگه بازیکن قطع بشه یا کل سرور بازی کرش کنه، تب باز بدون این هیچ‌وقت
  // خودش به‌روز نمی‌شد و همیشه همون وضعیت لحظه‌ی لود صفحه رو نشون می‌داد.
  function pollOnlineStatus(){
    fetch('dashboard.php?ajax=status', {cache:'no-store'}).then(r=>r.json()).then(d=>{
      const badge=document.getElementById('onlineBadge'), av=document.getElementById('proAv'), seen=document.getElementById('seenText');
      if(badge){ badge.textContent = d.online ? 'آنلاین در شهر' : 'آفلاین'; badge.className = d.online ? 'live' : ''; }
      if(av){ av.classList.toggle('on', !!d.online); }
      if(seen){ seen.textContent = d.seenText; }
    }).catch(()=>{});
  }
  setInterval(pollOnlineStatus, 20000);
  </script>
  <?php else: ?><div class="dcardx"><h3>هنوز کاراکتری به این حساب وصل نیست</h3><p class="mut">بعد از اولین ورود به سرور با همین حساب، اطلاعات کاراکترت (پول، سطح، شغل، گنگ) اینجا نمایش داده می‌شه.</p></div><?php endif; ?>
  <div class="kpis"><div class="kpi"><b><?= $tk ?></b><span>تیکت باز</span></div></div>
  <div class="dcardx"><h3>شروع سریع</h3><div class="row-actions"><a class="btn pri" href="dashboard.php?p=info">کارت شهروندی</a><a class="btn" href="dashboard.php?p=tickets">پشتیبانی (تیکت)</a></div></div>
  <?php if ($act): ?><div class="dcardx"><h3>آخرین فعالیت‌های حساب</h3><ul class="acts"><?php foreach ($act as $x): ?><li class="<?= in_array($x['action'], ['login_fail', 'security_hold'], true) ? 'bad' : '' ?>"><span><?= e(AUDIT[$x['action']] ?? $x['action']) ?></span><small><?= e(ago((int)strtotime((string)$x['created_at']))) ?></small></li><?php endforeach; ?></ul></div><?php endif; ?>

<?php elseif ($p === 'info'): ?>
  <h2>کارت شهروندی</h2><p class="lead">اطلاعات حساب و کاراکتر تو.</p>
  <section class="notice"><h2>ورود به شهر <?= e(CFG['fa']) ?> در لانچر VMP</h2>
    <p>برای ورود به شهر، اطلاعات زیر را در لانچر VMP وارد کنید:</p>
    <p class="cred"><span>نام کاربری</span> <b dir="ltr"><?= e($u['username']) ?></b> <span>رمز عبور</span> <b>همون رمزی که موقع ساخت حساب داخل بازی گذاشتی</b></p></section>
  <div class="head"><h2>اطلاعات کاراکتر</h2><button class="btn" id="dlcard-btn" type="button">دانلود کارت شناسایی (تصویر)</button></div>
  <article class="idcard" id="idcard-capture">
    <div class="ch"><b><?= e(strtoupper(CFG['name'])) ?></b><span>کارت شناسایی شهروندی</span><small>CITIZEN IDENTITY CARD</small></div>
    <div class="cb"><dl>
      <dt>نام و نام خانوادگی:</dt><dd><?= e($u['fullname']) ?></dd>
      <dt>جنسیت:</dt><dd><?= e($u['gender']) ?></dd>
      <dt>سطح تجربه:</dt><dd><?= (int)$u['level'] ?></dd>
      <dt>شماره تماس:</dt><dd dir="ltr"><?= e($mask) ?></dd>
      <dt>شماره حساب:</dt><dd dir="ltr"><?= e(($u['game']['iban'] ?? '') ?: $u['acc']) ?></dd></dl>
      <div class="cid"><small>شماره شناسایی</small><b dir="ltr"><?= e($u['game'] ? str_pad((string)(int)$u['game']['account_num'], 8, '0', STR_PAD_LEFT) : $u['cid']) ?></b></div></div>
  </article>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
  <script>
  (function(){
    var btn = document.getElementById('dlcard-btn'), card = document.getElementById('idcard-capture');
    if (!btn || !card) return;
    btn.addEventListener('click', function(){
      if (typeof html2canvas !== 'function') { window.print(); return; }
      var old = btn.textContent; btn.textContent = 'در حال آماده‌سازی...'; btn.disabled = true;
      html2canvas(card, {backgroundColor: '#0a0906', scale: 2}).then(function(canvas){
        var a = document.createElement('a');
        a.download = 'citizen-card.png';
        a.href = canvas.toDataURL('image/png');
        a.click();
      }).catch(function(){ window.print(); }).finally(function(){ btn.textContent = old; btn.disabled = false; });
    });
  })();
  </script>

<?php elseif ($p === 'ticket' && ($t = ticket_of((int)($_GET['id'] ?? 0), $u))): ?>
  <h2>#<?= (int)$t['id'] ?> <?= e($t['subject']) ?> <span class="tag <?= e($t['status']) ?>"><?= $st[$t['status']] ?></span></h2>
  <?php $m = $db->prepare('SELECT m.*,u.fullname,u.role FROM web_msgs m JOIN web_accounts u ON u.id=m.user_id WHERE ticket_id=? ORDER BY m.id'); $m->execute([$t['id']]); ?>
  <div class="chat"><?php foreach ($m as $x): ?><div class="msg <?= $x['role'] === 'admin' ? 'staff' : '' ?>"><small><?= e($x['fullname']) ?> · <?= date('Y/m/d H:i', (int)$x['created']) ?></small><p><?= nl2br(e($x['body'])) ?></p></div><?php endforeach; ?></div>
  <?php if ($t['status'] !== 'closed'): ?>
  <form method="post" class="dcardx"><?= csrf_field() ?><input type="hidden" name="id" value="<?= (int)$t['id'] ?>">
    <textarea name="body" rows="3" maxlength="2000" required aria-label="پاسخ"></textarea>
    <div class="row-actions" style="margin-top:10px"><button class="btn pri" name="a" value="reply">ارسال پاسخ</button><button class="btn" name="a" value="close" formnovalidate>بستن تیکت</button></div></form>
  <?php endif; ?>

<?php elseif (in_array($p, DASH_EXT_PAGES, true)): dash_ext_page($p, $u, $admin); ?>
<?php else: go('dashboard.php'); endif; ?>
</main></div></body></html>
