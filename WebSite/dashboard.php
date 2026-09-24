<?php
require __DIR__ . '/lib.php';
$u = need_login(); $db = db(); $p = $_GET['p'] ?? 'home'; $flash = ''; $ok = '';
$admin = $u['role'] === 'admin';
if (!$admin && in_array($p, ['review', 'users'], true)) $p = 'home';

const APP_ST = ['pending' => 'در انتظار بررسی', 'accepted' => 'پذیرفته شد', 'rejected' => 'رد شد', 'cancelled' => 'لغو شده'];
function ticket_of(int $id, array $u): ?array {
  $s = db()->prepare('SELECT * FROM web_tickets WHERE id=?'); $s->execute([$id]); $t = $s->fetch();
  return ($t && ($t['user_id'] == $u['id'] || $u['role'] === 'admin')) ? $t : null;
}
function add_msg(int $tid, int $uid, string $b): void {
  db()->prepare('INSERT INTO web_msgs(ticket_id,user_id,body,created) VALUES(?,?,?,?)')->execute([$tid, $uid, mb_substr($b, 0, 2000), time()]);
}
function org_group(string $label): string {
  foreach (CFG['depts'] as $d) if ($d['label'] === $label) return CFG['org_groups'][$d['group']]['label'];
  return '';
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  csrf_check(); $a = $_POST['a'] ?? '';
  if ($a === 'new') {
    $s = trim($_POST['subject'] ?? ''); $b = trim($_POST['body'] ?? '');
    if ($s === '' || $b === '' || mb_strlen($s) > 120) { $flash = 'موضوع و متن را کامل بنویس.'; $p = 'tickets'; }
    else {
      $db->prepare('INSERT INTO web_tickets(user_id,subject,status,created) VALUES(?,?,?,?)')->execute([$u['id'], $s, 'open', time()]);
      $id = (int)$db->lastInsertId(); add_msg($id, $u['id'], $b); go("dashboard.php?p=ticket&id=$id");
    }
  } elseif ($a === 'reply' || $a === 'close') {
    $id = (int)($_POST['id'] ?? 0); $t = ticket_of($id, $u);
    if ($t) {
      if ($a === 'close') $db->prepare("UPDATE web_tickets SET status='closed' WHERE id=?")->execute([$id]);
      elseif (trim($_POST['body'] ?? '') !== '' && $t['status'] !== 'closed') {
        add_msg($id, $u['id'], trim($_POST['body']));
        $db->prepare('UPDATE web_tickets SET status=? WHERE id=?')->execute([$admin && $t['user_id'] != $u['id'] ? 'answered' : 'open', $id]);
      }
      go("dashboard.php?p=ticket&id=$id");
    }
  } elseif ($a === 'pass') {
    $p = 'settings'; $lq = $db->prepare('SELECT password,password_salt FROM login_users WHERE id=?'); $lq->execute([$u['lid']]); $lr = $lq->fetch(); $nw = $_POST['new'] ?? '';
    if (rate_full('pw-' . $u['lid'], 5, 900)) $flash = 'تلاش‌های زیاد؛ ۱۵ دقیقه بعد دوباره امتحان کن.';
    elseif (!$lr || !hash_equals((string)$lr['password'], game_hash($_POST['old'] ?? '', (string)$lr['password_salt']))) { rate_hit('pw-' . $u['lid'], 900); $flash = 'رمز فعلی اشتباه است.'; }
    elseif (strlen($nw) < 6 || !preg_match('/\d/', $nw) || !preg_match('/[A-Za-z]/', $nw)) $flash = 'رمز جدید حداقل ۶ کاراکتر و شامل یک حرف انگلیسی و یک عدد باشد.';
    else { $salt = bin2hex(random_bytes(16)); $db->prepare('UPDATE login_users SET password=?,password_salt=? WHERE id=?')->execute([game_hash($nw, $salt), $salt, $u['lid']]); $ok = 'رمز عبور تغییر کرد؛ از این به بعد داخل بازی هم با همین رمز وارد می‌شی.'; }

  } elseif ($a === 'apply') {                                     // ثبت درخواست عضویت
    $p = 'apply'; [$kind, $target] = array_pad(explode(':', $_POST['target'] ?? '', 2), 2, '');
    $T = apply_targets(); $valid = $kind === 'gang' ? in_array($target, $T['gang'], true)
      : ($kind === 'org' && in_array($target, array_merge(...array_values($T['org'])), true));
    $f = ['bg' => trim($_POST['bg'] ?? ''), 'why' => trim($_POST['why'] ?? ''), 'exp' => trim($_POST['exp'] ?? ''), 'hours' => trim($_POST['hours'] ?? '')];
    $pend = $db->prepare("SELECT COUNT(*) FROM web_apps WHERE user_id=? AND status='pending'"); $pend->execute([$u['id']]);
    $dup = $db->prepare("SELECT COUNT(*) FROM web_apps WHERE user_id=? AND kind=? AND target=? AND status='pending'"); $dup->execute([$u['id'], $kind, $target]);
    $cool = $db->prepare("SELECT COUNT(*) FROM web_apps WHERE user_id=? AND kind=? AND target=? AND status='rejected' AND updated>?"); $cool->execute([$u['id'], $kind, $target, time() - 86400]);
    if (!$valid) $flash = 'مقصد انتخاب‌شده معتبر نیست یا عضوگیری‌اش بسته است.';
    elseif (mb_strlen($f['bg']) < 30 || mb_strlen($f['why']) < 20) $flash = 'پیش‌زمینه‌ی کاراکتر (حداقل ۳۰ حرف) و دلیل درخواست (حداقل ۲۰ حرف) رو کامل بنویس.';
    elseif (array_sum(array_map('mb_strlen', $f)) > 4000) $flash = 'متن درخواست خیلی طولانیه.';
    elseif ((int)$dup->fetchColumn() > 0) $flash = 'برای این مورد یه درخواست در انتظار بررسی داری.';
    elseif ((int)$pend->fetchColumn() >= 3) $flash = 'حداکثر ۳ درخواست هم‌زمان در انتظار بررسی می‌تونی داشته باشی.';
    elseif ((int)$cool->fetchColumn() > 0) $flash = 'درخواستت برای این مورد به‌تازگی رد شده؛ ۲۴ ساعت بعد دوباره تلاش کن.';
    else {
      $db->prepare("INSERT INTO web_apps(user_id,kind,target,body,status,note,created,updated) VALUES(?,?,?,?,'pending','',?,?)")
         ->execute([$u['id'], $kind, $target, json_encode($f, JSON_UNESCAPED_UNICODE), time(), time()]);
      go('dashboard.php?p=apps&done=1');
    }
  } elseif ($a === 'cancel_app') {
    $db->prepare("UPDATE web_apps SET status='cancelled',updated=? WHERE id=? AND user_id=? AND status='pending'")->execute([time(), (int)($_POST['id'] ?? 0), $u['id']]);
    go('dashboard.php?p=apps');
  } elseif ($a === 'decide' && $admin) {                          // تصمیم مدیر
    $st = ($_POST['d'] ?? '') === 'accept' ? 'accepted' : 'rejected';
    $db->prepare("UPDATE web_apps SET status=?,note=?,updated=? WHERE id=? AND status='pending'")->execute([$st, mb_substr(trim($_POST['note'] ?? ''), 0, 500), time(), (int)($_POST['id'] ?? 0)]);
    go('dashboard.php?p=review');
  }
}
if (($_GET['done'] ?? '') === '1' && $p === 'apps') $ok = 'درخواستت ثبت شد؛ نتیجه‌ی بررسی همین‌جا نمایش داده می‌شه.';

$mask = preg_match('/^09\d{9}$/', $u['phone']) ? substr($u['phone'], 0, 4) . '***' . substr($u['phone'], -4) : '—';
function job_label(string $j): string { foreach (CFG['depts'] as $d) if ($d['job'] === $j) return $d['label']; return $j === 'unemployed' ? 'بیکار' : $j; }
function ago(int $t): string { $s = max(0, time() - $t); return $s < 90 ? 'همین الان' : ($s < 3600 ? intdiv($s, 60) . ' دقیقه پیش' : ($s < 172800 ? intdiv($s, 3600) . ' ساعت پیش' : intdiv($s, 86400) . ' روز پیش')); }
const AUDIT = ['login_success' => 'ورود موفق به سرور', 'login_fail' => 'تلاش ناموفق برای ورود', 'register' => 'ساخت حساب', 'password_reset' => 'بازیابی رمز', 'password_change' => 'تغییر رمز از داخل بازی', 'new_device' => 'ورود از دستگاه جدید', 'logout_all' => 'خروج از همه‌ی دستگاه‌ها', 'security_hold' => 'قفل امنیتی فعال شد', 'security_hold_cleared' => 'قفل امنیتی باز شد'];
$st = ['open' => 'باز', 'answered' => 'پاسخ داده شد', 'closed' => 'بسته'];
$cnt = fn($sql, $args = []) => (function () use ($db, $sql, $args) { $s = $db->prepare($sql); $s->execute($args); return (int)$s->fetchColumn(); })();
$myPend = $cnt("SELECT COUNT(*) FROM web_apps WHERE user_id=? AND status='pending'", [$u['id']]);
$revPend = $admin ? $cnt("SELECT COUNT(*) FROM web_apps WHERE status='pending'") : 0;
$I = [ // آیکون‌ها
 'home' => '<path d="M3 11 12 3l9 8v9a1 1 0 0 1-1 1h-5v-6H9v6H4a1 1 0 0 1-1-1v-9Z"/>',
 'info' => '<rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="9" cy="11" r="2"/><path d="M14 10h4M14 14h4M6 16c.5-1.5 1.5-2 3-2s2.500.5 3 2"/>',
 'apply' => '<path d="M12 5v14M5 12h14"/>', 'apps' => '<path d="M9 5h10M9 12h10M9 19h10M4 5h.01M4 12h.01M4 19h.01"/>',
 'review' => '<path d="M9 12l2 2 4-4"/><rect x="4" y="3" width="16" height="18" rx="2"/>',
 'users' => '<circle cx="9" cy="8" r="3.500"/><path d="M2 20a7 7 0 0 1 14 0M17 11a3 3 0 1 0 0-6M22 20a6 6 0 0 0-4-5.600"/>',
 'tickets' => '<path d="M21 11.500a8.400 8.400 0 0 1-8.400 8.400 8.600 8.600 0 0 1-3.800-.9L3 20l1-5.600a8.400 8.400 0 0 1-.9-3.900A8.400 8.400 0 0 1 11.500 2 8.600 8.600 0 0 1 21 11.500Z"/>',
 'settings' => '<circle cx="12" cy="12" r="3"/><path d="M19.400 15a1.700 1.700 0 0 0 .3 1.800l.1.1a2 2 0 1 1-2.800 2.800l-.1-.1a1.700 1.700 0 0 0-1.800-.3 1.700 1.700 0 0 0-1 1.500V21a2 2 0 1 1-4 0v-.1a1.700 1.700 0 0 0-1.100-1.500 1.700 1.700 0 0 0-1.800.3l-.1.1a2 2 0 1 1-2.800-2.800l.1-.1a1.700 1.700 0 0 0 .3-1.800 1.700 1.700 0 0 0-1.500-1H3a2 2 0 1 1 0-4h.1a1.700 1.700 0 0 0 1.500-1.100 1.700 1.700 0 0 0-.3-1.800l-.1-.1a2 2 0 1 1 2.800-2.800l.1.1a1.700 1.700 0 0 0 1.800.3H9a1.700 1.700 0 0 0 1-1.500V3a2 2 0 1 1 4 0v.1a1.700 1.700 0 0 0 1 1.500 1.700 1.700 0 0 0 1.800-.3l.1-.1a2 2 0 1 1 2.800 2.800l-.1.1a1.700 1.700 0 0 0-.3 1.800V9a1.700 1.700 0 0 0 1.500 1H21a2 2 0 1 1 0 4h-.1a1.700 1.700 0 0 0-1.500 1Z"/>',
];
$nav = ['home' => 'نمای کلی', 'info' => 'کارت شهروندی', 'apply' => 'ثبت درخواست عضویت', 'apps' => 'درخواست‌های من', 'tickets' => 'پشتیبانی (تیکت)', 'settings' => 'تنظیمات'];
$adm = ['review' => 'بررسی درخواست‌ها', 'users' => 'حساب‌های بازی'];
$ico = fn($k) => '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' . $I[$k] . '</svg>';
function app_card(array $x, bool $review = false, bool $mine = true): void {
  $b = json_decode($x['body'], true) ?: []; $g = $x['kind'] === 'org' ? org_group($x['target']) : 'گنگ'; ?>
  <div class="app <?= e($x['status']) ?>">
    <div class="ahead"><h3><?= e($x['target']) ?><small><?= e($g) ?><?= $review ? ' · ' . e($x['fullname'] ?? '') : '' ?></small></h3>
      <span class="tag <?= e($x['status']) ?>"><?= APP_ST[$x['status']] ?? '' ?></span></div>
    <small class="mut"><?= date('Y/m/d H:i', (int)$x['created']) ?></small>
    <details <?= $review && $x['status'] === 'pending' ? 'open' : '' ?>><summary>مشاهده‌ی متن درخواست</summary>
      <div class="qa"><div><b>پیش‌زمینه‌ی کاراکتر</b><p><?= e($b['bg'] ?? '') ?></p></div><div><b>دلیل درخواست</b><p><?= e($b['why'] ?? '') ?></p></div>
        <?php if (!empty($b['exp'])): ?><div><b>سوابق</b><p><?= e($b['exp']) ?></p></div><?php endif; ?>
        <?php if (!empty($b['hours'])): ?><div><b>ساعت فعالیت روزانه</b><p><?= e($b['hours']) ?></p></div><?php endif; ?></div></details>
    <?php if ($x['note'] !== '' && $x['note'] !== null): ?><div class="reply"><small>پاسخ مدیریت</small><?= nl2br(e($x['note'])) ?></div><?php endif; ?>
    <?php if ($x['status'] === 'pending' && $review): ?>
      <form method="post" class="row-actions"><?= csrf_field() ?><input type="hidden" name="a" value="decide"><input type="hidden" name="id" value="<?= (int)$x['id'] ?>">
        <label style="flex:1;min-width:200px;margin:0"><input name="note" maxlength="500" placeholder="توضیح برای کاربر (اختیاری)"></label>
        <button class="btn ok" name="d" value="accept">پذیرش</button><button class="btn no" name="d" value="reject">رد</button></form>
    <?php elseif ($x['status'] === 'pending' && $mine): ?>
      <form method="post" class="row-actions" onsubmit="return confirm('درخواست لغو بشه؟')"><?= csrf_field() ?><input type="hidden" name="a" value="cancel_app"><input type="hidden" name="id" value="<?= (int)$x['id'] ?>"><button class="btn no">لغو درخواست</button></form>
    <?php endif; ?>
  </div><?php
}
?><!DOCTYPE html>
<html lang="fa" dir="rtl"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>داشبورد شهروندی | <?= e(CFG['name']) ?></title><meta name="theme-color" content="#050505">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@400;700;900&display=swap">
<link rel="stylesheet" href="style.css"></head>
<body class="dash">
<div class="dtop"><a href="index.php" class="logo"><svg viewBox="0 0 64 64"><defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#ffe08a"/><stop offset="1" stop-color="#d18f00"/></linearGradient></defs><path d="M16 8v28a16 16 0 0 0 32 0V8" fill="none" stroke="url(#g)" stroke-width="11" stroke-linecap="round"/></svg><span><?= e(strtok(CFG['name'], ' ')) ?> <b><?= e(trim(strstr(CFG['name'], ' '))) ?></b></span></a>
  <a class="btn" href="index.php">صفحه اصلی</a><a class="btn" href="auth.php?out=1">خروج</a></div>
<div class="dlayout">
<aside class="side">
  <div class="ucard"><div class="av"><?= e(mb_substr($u['fullname'], 0, 1)) ?></div><b dir="ltr"><?= e($u['fullname']) ?></b><small dir="ltr">@<?= e($u['username']) ?></small><span class="rolebadge"><?= e($u['rank'] ?: 'شهروند') ?></span></div>
  <div class="dnav">
    <?php foreach ($nav as $k => $l): ?><a href="dashboard.php?p=<?= $k ?>" class="<?= ($p === $k || ($p === 'ticket' && $k === 'tickets')) ? 'on' : '' ?>"><?= $ico($k) ?><?= $l ?><?= $k === 'apps' && $myPend ? '<span class="cnt">' . $myPend . '</span>' : '' ?></a><?php endforeach; ?>
    <?php if ($admin): ?><hr><?php foreach ($adm as $k => $l): ?><a href="dashboard.php?p=<?= $k ?>" class="<?= $p === $k ? 'on' : '' ?>"><?= $ico($k) ?><?= $l ?><?= $k === 'review' && $revPend ? '<span class="cnt">' . $revPend . '</span>' : '' ?></a><?php endforeach; endif; ?>
  </div>
</aside>
<main class="dmain">
<?php if ($flash): ?><p class="err" role="alert"><?= e($flash) ?></p><?php endif; ?>
<?php if ($ok): ?><p class="ok-msg" role="status"><?= e($ok) ?></p><?php endif; ?>

<?php if ($p === 'home'):
  $tot = $cnt('SELECT COUNT(*) FROM web_apps WHERE user_id=?', [$u['id']]); $acc = $cnt("SELECT COUNT(*) FROM web_apps WHERE user_id=? AND status='accepted'", [$u['id']]);
  $tk = $cnt("SELECT COUNT(*) FROM web_tickets WHERE user_id=? AND status<>'closed'", [$u['id']]);
  $last = $db->prepare('SELECT * FROM web_apps WHERE user_id=? ORDER BY id DESC LIMIT 3'); $last->execute([$u['id']]); ?>
  <?php $g = $u['game']; $lv = (int)$u['level']; $act = [];
    try { $aq = $db->prepare('SELECT action,created_at FROM login_audit WHERE username=? ORDER BY created_at DESC LIMIT 5'); $aq->execute([$u['username']]); $act = $aq->fetchAll(); } catch (Throwable $e) {} ?>
  <section class="pro">
    <div class="pro-av <?= $u['online'] ? 'on' : '' ?>"><span><?= e(mb_substr($u['fullname'], 0, 1)) ?></span></div>
    <div class="pro-body">
      <small class="mut">خوش اومدی</small>
      <h2 class="gt" dir="ltr"><?= e($u['fullname']) ?></h2>
      <div class="chips"><span>@<?= e($u['username']) ?></span>
        <?php if ($u['rank']): ?><span class="gold"><?= e($u['rank']) ?></span><?php endif; ?>
        <?php if ($g): ?><span><?= e(job_label((string)$g['job'])) ?></span><?php if ($g['gang'] && $g['gang'] !== 'none'): ?><span><?= e($g['gang']) ?></span><?php endif; ?><?php endif; ?>
        <span class="<?= $u['online'] ? 'live' : '' ?>"><?= $u['online'] ? 'آنلاین در شهر' : 'آفلاین' ?></span></div>
      <?php if ($g): ?><div class="xp"><i style="width:<?= min(100, (int)round($lv / max(50, $lv) * 100)) ?>%"></i></div><small class="mut" dir="ltr">Level <?= $lv ?> · XP <?= number_format((int)$g['xp']) ?></small><?php endif; ?>
    </div>
  </section>
  <?php if ($g): ?>
  <div class="tiles">
    <div><span>پول نقد</span><b dir="ltr">$<?= number_format((int)$g['money']) ?></b></div>
    <div><span>موجودی بانک</span><b dir="ltr">$<?= number_format((int)$g['bank']) ?></b></div>
    <div><span>ساعت بازی</span><b><?= number_format(intdiv((int)$g['timePlay'], 3600)) ?></b></div>
    <div><span>آخرین حضور</span><b><?= $u['online'] ? 'الان' : ($u['seen'] ? ago($u['seen']) : '—') ?></b></div>
  </div>
  <?php else: ?><div class="dcardx"><h3>هنوز کاراکتری به این حساب وصل نیست</h3><p class="mut">بعد از اولین ورود به سرور با همین حساب، اطلاعات کاراکترت (پول، سطح، شغل، گنگ) اینجا نمایش داده می‌شه.</p></div><?php endif; ?>
  <div class="kpis"><div class="kpi"><b><?= $tot ?></b><span>کل درخواست‌ها</span></div><div class="kpi"><b><?= $myPend ?></b><span>در انتظار بررسی</span></div><div class="kpi"><b><?= $acc ?></b><span>پذیرفته‌شده</span></div><div class="kpi"><b><?= $tk ?></b><span>تیکت باز</span></div></div>
  <?php if ($admin && $revPend): ?><div class="dcardx" style="border-color:#ffc10755"><h3>🔔 <?= $revPend ?> درخواست منتظر بررسی توئه</h3><a class="btn gold" href="dashboard.php?p=review">رفتن به بررسی درخواست‌ها</a></div><?php endif; ?>
  <div class="dcardx"><h3>شروع سریع</h3><div class="row-actions"><a class="btn pri" href="dashboard.php?p=apply">ثبت درخواست عضویت</a><a class="btn" href="join.php">دیدن گنگ‌ها و ارگان‌ها</a><a class="btn" href="dashboard.php?p=info">کارت شهروندی</a></div></div>
  <?php if ($act): ?><div class="dcardx"><h3>آخرین فعالیت‌های حساب</h3><ul class="acts"><?php foreach ($act as $x): ?><li class="<?= in_array($x['action'], ['login_fail', 'security_hold'], true) ? 'bad' : '' ?>"><span><?= e(AUDIT[$x['action']] ?? $x['action']) ?></span><small><?= e(ago((int)strtotime((string)$x['created_at']))) ?></small></li><?php endforeach; ?></ul></div><?php endif; ?>
  <h3 style="margin:26px 0 12px">آخرین درخواست‌ها</h3>
  <?php $n = 0; foreach ($last as $x) { app_card($x); $n++; } if (!$n) echo '<div class="empty2">هنوز درخواستی ثبت نکردی. از «ثبت درخواست عضویت» شروع کن.</div>'; ?>

<?php elseif ($p === 'info'): ?>
  <h2>کارت شهروندی</h2><p class="lead">اطلاعات حساب و کاراکتر تو.</p>
  <section class="notice"><h2>ورود به شهر <?= e(CFG['fa']) ?> در لانچر VMP</h2>
    <p>برای ورود به شهر، اطلاعات زیر را در لانچر VMP وارد کنید:</p>
    <p class="cred"><span>نام کاربری</span> <b dir="ltr"><?= e($u['username']) ?></b> <span>رمز عبور</span> <b>همون رمزی که موقع ساخت حساب داخل بازی گذاشتی</b></p></section>
  <div class="head"><h2>اطلاعات کاراکتر</h2><button class="btn" onclick="window.print()">دانلود کارت شناسایی</button></div>
  <article class="idcard">
    <div class="ch"><b><?= e(strtoupper(CFG['name'])) ?></b><span>کارت شناسایی شهروندی</span><small>CITIZEN IDENTITY CARD</small></div>
    <div class="cb"><dl>
      <dt>نام و نام خانوادگی:</dt><dd><?= e($u['fullname']) ?></dd>
      <dt>جنسیت:</dt><dd><?= e($u['gender']) ?></dd>
      <dt>سطح تجربه:</dt><dd><?= (int)$u['level'] ?></dd>
      <dt>شماره تماس:</dt><dd dir="ltr"><?= e($mask) ?></dd>
      <dt>شماره حساب:</dt><dd dir="ltr"><?= e(($u['game']['iban'] ?? '') ?: $u['acc']) ?></dd></dl>
      <div class="cid"><small>شماره شناسایی</small><b dir="ltr"><?= e($u['game'] ? str_pad((string)(int)$u['game']['account_num'], 8, '0', STR_PAD_LEFT) : $u['cid']) ?></b></div></div>
  </article>

<?php elseif ($p === 'apply'): $T = apply_targets(); $sel = ($_POST['target'] ?? '') ?: (($_GET['kind'] ?? '') . ':' . ($_GET['target'] ?? '')); ?>
  <h2>ثبت درخواست عضویت</h2><p class="lead">فرم رو با دقت پر کن؛ مدیریت درخواستت رو بررسی می‌کنه و نتیجه تو همین داشبورد نمایش داده می‌شه.</p>
  <form method="post" class="dcardx"><?= csrf_field() ?><input type="hidden" name="a" value="apply">
    <div class="fgrid">
      <label class="full">می‌خوای به کجا بپیوندی؟
        <select name="target" required>
          <?php if ($T['gang']): ?><optgroup label="گنگ‌ها (عضوگیری باز)"><?php foreach ($T['gang'] as $g): ?><option value="gang:<?= e($g) ?>" <?= $sel === "gang:$g" ? 'selected' : '' ?>><?= e($g) ?></option><?php endforeach; ?></optgroup><?php endif; ?>
          <?php foreach ($T['org'] as $gk => $ls): ?><optgroup label="<?= e(CFG['org_groups'][$gk]['label']) ?>"><?php foreach ($ls as $l): ?><option value="org:<?= e($l) ?>" <?= $sel === "org:$l" ? 'selected' : '' ?>><?= e($l) ?></option><?php endforeach; ?></optgroup><?php endforeach; ?>
        </select></label>
      <label class="full">پیش‌زمینه‌ی کاراکتر<textarea name="bg" required minlength="30" maxlength="1500" placeholder="داستان و شخصیت کاراکترت رو مختصر بنویس..."><?= e($_POST['bg'] ?? '') ?></textarea><span class="hint">حداقل ۳۰ حرف</span></label>
      <label class="full">چرا می‌خوای عضو این مجموعه بشی؟<textarea name="why" required minlength="20" maxlength="1500"><?= e($_POST['why'] ?? '') ?></textarea><span class="hint">حداقل ۲۰ حرف</span></label>
      <label>سوابق رول‌پلی (اختیاری)<input name="exp" maxlength="300" value="<?= e($_POST['exp'] ?? '') ?>" placeholder="مثلاً: ۳ ماه پلیس در سرور X"></label>
      <label>ساعت فعالیت روزانه<select name="hours"><?php foreach (['کمتر از ۲ ساعت', '۲ تا ۴ ساعت', '۴ تا ۶ ساعت', 'بیشتر از ۶ ساعت'] as $h): ?><option <?= ($_POST['hours'] ?? '') === $h ? 'selected' : '' ?>><?= $h ?></option><?php endforeach; ?></select></label>
    </div>
    <button class="btn pri">ارسال درخواست</button>
    <span class="hint" style="display:inline-block;margin-inline-start:12px">هر نفر حداکثر ۳ درخواست هم‌زمان می‌تونه داشته باشه.</span>
  </form>

<?php elseif ($p === 'apps'): ?>
  <h2>درخواست‌های من</h2><p class="lead">وضعیت همه‌ی درخواست‌هایی که ثبت کردی.</p>
  <?php $q = $db->prepare('SELECT * FROM web_apps WHERE user_id=? ORDER BY id DESC LIMIT 100'); $q->execute([$u['id']]); $n = 0;
  foreach ($q as $x) { app_card($x); $n++; }
  if (!$n) echo '<div class="empty2">هنوز درخواستی ثبت نکردی.<br><br><a class="btn pri" href="dashboard.php?p=apply">ثبت اولین درخواست</a></div>'; ?>

<?php elseif ($p === 'review' && $admin): $f = ($_GET['s'] ?? 'pending') === 'all' ? 'all' : 'pending'; ?>
  <h2>بررسی درخواست‌ها</h2><p class="lead">درخواست‌های عضویت گنگ‌ها و ارگان‌ها.</p>
  <div class="seg"><button class="<?= $f === 'pending' ? 'on' : '' ?>" onclick="location='dashboard.php?p=review'">در انتظار (<?= $revPend ?>)</button><button class="<?= $f === 'all' ? 'on' : '' ?>" onclick="location='dashboard.php?p=review&s=all'">همه</button></div>
  <?php $q = $db->query('SELECT a.*,u.fullname FROM web_apps a JOIN web_accounts u ON u.id=a.user_id ' . ($f === 'pending' ? "WHERE a.status='pending' " : '') . 'ORDER BY a.id DESC LIMIT 100'); $n = 0;
  foreach ($q as $x) { app_card($x, true, false); $n++; }
  if (!$n) echo '<div class="empty2">درخواستی برای نمایش نیست 🎉</div>'; ?>

<?php elseif ($p === 'users' && $admin): $qs = trim($_GET['q'] ?? ''); $lk = '%' . addcslashes($qs, '%_\\') . '%'; ?>
  <h2>حساب‌های بازی</h2><p class="lead">فهرست حساب‌های Unique_Login و کاراکتر وصل‌شده به هرکدوم. حساب فقط داخل بازی ساخته می‌شه.</p>
  <form class="dcardx" method="get" style="display:flex;gap:10px;flex-wrap:wrap"><input type="hidden" name="p" value="users"><input name="q" value="<?= e($qs) ?>" placeholder="جستجوی نام کاربری یا اسم کاراکتر" style="flex:1;min-width:200px"><button class="btn pri">جستجو</button></form>
  <div class="dcardx" style="overflow-x:auto"><table class="utable"><tr><th>نام کاربری</th><th>کاراکتر</th><th>رنک</th><th>موبایل</th><th>وضعیت</th><th>ساخت</th></tr>
  <?php try { $uq = $db->prepare('SELECT l.username,l.phone,l.security_hold,l.created_at,c.playerName,c.permission_level FROM login_users l LEFT JOIN users c ON c.identifier=l.device_license ' . ($qs !== '' ? 'WHERE l.username LIKE ? OR c.playerName LIKE ? ' : '') . 'ORDER BY l.id DESC LIMIT 200'); $uq->execute($qs !== '' ? [$lk, $lk] : []); $rows = $uq->fetchAll();
    } catch (Throwable $e) { $uq = $db->prepare('SELECT username,phone,security_hold,created_at FROM login_users ' . ($qs !== '' ? 'WHERE username LIKE ? ' : '') . 'ORDER BY id DESC LIMIT 200'); $uq->execute($qs !== '' ? [$lk] : []); $rows = $uq->fetchAll(); }
  foreach ($rows as $x): $pl = (int)($x['permission_level'] ?? 0); ?>
    <tr><td dir="ltr"><?= e($x['username']) ?></td><td dir="ltr"><?= e($x['playerName'] ?? '—') ?></td><td><?= $pl >= (int)CFG['team_min_perm'] ? '<span class="rolebadge" style="margin:0">' . e(rank_label($pl)) . '</span>' : ($pl > 0 ? 'Staff' : 'شهروند') ?></td>
      <td dir="ltr"><?= $x['phone'] ? e('0' . substr($x['phone'], 0, 3) . '***' . substr($x['phone'], -4)) : '—' ?></td><td><?= (int)$x['security_hold'] ? '<span class="tag rejected">قفل امنیتی</span>' : 'عادی' ?></td><td><?= e(date('Y/m/d', (int)strtotime((string)$x['created_at']))) ?></td></tr>
  <?php endforeach; if (!$rows) echo '<tr><td colspan="6" class="mut">حسابی پیدا نشد.</td></tr>'; ?></table></div>

<?php elseif ($p === 'tickets'): ?>
  <h2>پشتیبانی (تیکت)</h2><p class="lead">برای سوال یا مشکل، از اینجا تیکت بفرست.</p>
  <form method="post" class="dcardx"><?= csrf_field() ?><input type="hidden" name="a" value="new">
    <label>موضوع<input name="subject" maxlength="120" required></label>
    <label>توضیحات<textarea name="body" rows="4" maxlength="2000" required></textarea></label>
    <button class="btn pri">ارسال تیکت</button></form>
  <?php $q = $db->prepare('SELECT t.*,u.fullname FROM web_tickets t JOIN web_accounts u ON u.id=t.user_id ' . ($admin ? '' : 'WHERE t.user_id=? ') . 'ORDER BY t.id DESC LIMIT 100');
        $q->execute($admin ? [] : [$u['id']]); $rows = $q->fetchAll(); ?>
  <div class="list"><?php foreach ($rows as $t): ?>
    <a class="row" href="dashboard.php?p=ticket&id=<?= (int)$t['id'] ?>"><b>#<?= (int)$t['id'] ?> <?= e($t['subject']) ?></b>
      <?= $admin ? '<small>' . e($t['fullname']) . '</small>' : '' ?><span class="tag <?= e($t['status']) ?>"><?= $st[$t['status']] ?></span></a>
  <?php endforeach; if (!$rows) echo '<p class="mut">هنوز تیکتی نساخته‌ای.</p>'; ?></div>

<?php elseif ($p === 'ticket' && ($t = ticket_of((int)($_GET['id'] ?? 0), $u))): ?>
  <h2>#<?= (int)$t['id'] ?> <?= e($t['subject']) ?> <span class="tag <?= e($t['status']) ?>"><?= $st[$t['status']] ?></span></h2>
  <?php $m = $db->prepare('SELECT m.*,u.fullname,u.role FROM web_msgs m JOIN web_accounts u ON u.id=m.user_id WHERE ticket_id=? ORDER BY m.id'); $m->execute([$t['id']]); ?>
  <div class="chat"><?php foreach ($m as $x): ?><div class="msg <?= $x['role'] === 'admin' ? 'staff' : '' ?>"><small><?= e($x['fullname']) ?> · <?= date('Y/m/d H:i', (int)$x['created']) ?></small><p><?= nl2br(e($x['body'])) ?></p></div><?php endforeach; ?></div>
  <?php if ($t['status'] !== 'closed'): ?>
  <form method="post" class="dcardx"><?= csrf_field() ?><input type="hidden" name="id" value="<?= (int)$t['id'] ?>">
    <textarea name="body" rows="3" maxlength="2000" required aria-label="پاسخ"></textarea>
    <div class="row-actions" style="margin-top:10px"><button class="btn pri" name="a" value="reply">ارسال پاسخ</button><button class="btn" name="a" value="close" formnovalidate>بستن تیکت</button></div></form>
  <?php endif; ?>

<?php elseif ($p === 'settings'): ?>
  <h2>تنظیمات</h2><p class="lead">رمز حساب بازی و سایت یکیه؛ اینجا عوضش کنی، داخل بازی هم همون معتبره.</p>
  <form method="post" class="dcardx" style="max-width:480px"><?= csrf_field() ?><input type="hidden" name="a" value="pass"><h3>تغییر رمز عبور</h3>
    <label>رمز عبور فعلی<input type="password" name="old" dir="ltr" required autocomplete="current-password"></label>
    <label>رمز عبور جدید<input type="password" name="new" dir="ltr" minlength="6" required autocomplete="new-password"></label><p class="hint">حداقل ۶ کاراکتر، شامل حداقل یک حرف انگلیسی و یک عدد.</p>
    <button class="btn pri">تغییر رمز عبور</button></form>
<?php else: go('dashboard.php'); endif; ?>
</main></div></body></html>
