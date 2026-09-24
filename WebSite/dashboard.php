<?php
require __DIR__ . '/lib.php';
$u = need_login(); $db = db(); $p = $_GET['p'] ?? 'info'; $flash = '';
$admin = $u['role'] === 'admin';

function ticket_of(int $id, array $u): ?array {
  $s = db()->prepare('SELECT * FROM web_tickets WHERE id=?'); $s->execute([$id]); $t = $s->fetch();
  return ($t && ($t['user_id'] == $u['id'] || $u['role'] === 'admin')) ? $t : null;
}
function add_msg(int $tid, int $uid, string $b): void {
  db()->prepare('INSERT INTO web_msgs(ticket_id,user_id,body,created) VALUES(?,?,?,?)')->execute([$tid, $uid, mb_substr($b, 0, 2000), time()]);
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
    $p = 'settings';
    if (!password_verify($_POST['old'] ?? '', $u['pass'])) $flash = 'رمز فعلی اشتباه است.';
    elseif (strlen($_POST['new'] ?? '') < 6) $flash = 'رمز جدید حداقل ۶ کاراکتر باشد.';
    else { $db->prepare('UPDATE web_accounts SET pass=? WHERE id=?')->execute([password_hash($_POST['new'], PASSWORD_DEFAULT), $u['id']]); $flash = 'رمز عبور تغییر کرد.'; }
  }
}

$mask = substr($u['phone'], 0, 4) . '***' . substr($u['phone'], -4);
$st = ['open' => 'باز', 'answered' => 'پاسخ داده شد', 'closed' => 'بسته'];
$nav = ['info' => 'اطلاعات من', 'tickets' => 'سیستم تیکت', 'settings' => 'تنظیمات'];
?><!DOCTYPE html>
<html lang="fa" dir="rtl"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>داشبورد شهروندی | <?= e(CFG['name']) ?></title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@400;700;900&display=swap">
<link rel="stylesheet" href="style.css"></head>
<body class="dash">
<header class="top"><a href="index.php" class="logo">U <b><?= e(CFG['name']) ?></b></a>
  <span class="who"><?= e($u['fullname']) ?><?= $admin ? ' · ادمین' : '' ?></span></header>
<div class="layout">
<aside><nav>
  <?php foreach ($nav as $k => $l): ?><a href="dashboard.php?p=<?= $k ?>" class="<?= ($p === $k || ($p === 'ticket' && $k === 'tickets')) ? 'on' : '' ?>"><?= $l ?></a><?php endforeach; ?>
  <a href="index.php">صفحه اصلی</a><a href="<?= e(CFG['discord']) ?>" target="_blank" rel="noopener">دیسکورد</a><a href="auth.php?out=1">خروج</a>
</nav></aside>
<main>
<?php if ($flash): ?><p class="err" role="alert"><?= e($flash) ?></p><?php endif; ?>

<?php if ($p === 'info'): ?>
  <section class="notice"><h2>ورود به شهر <?= e(CFG['fa']) ?> در لانچر VMP</h2>
    <p>برای ورود به شهر، اطلاعات زیر را در لانچر VMP وارد کنید:</p>
    <p class="cred"><span>نام کاربری</span> <b dir="ltr"><?= e($mask) ?></b> <span>رمز عبور</span> <b>رمز عبور همین سایت</b></p></section>
  <div class="head"><h2>اطلاعات کاراکتر</h2><button class="btn" onclick="window.print()">دانلود کارت شناسایی</button></div>
  <article class="idcard">
    <div class="ch"><b><?= e(strtoupper(CFG['name'])) ?></b><span>کارت شناسایی شهروندی</span><small>CITIZEN IDENTITY CARD</small></div>
    <div class="cb"><dl>
      <dt>نام و نام خانوادگی:</dt><dd><?= e($u['fullname']) ?></dd>
      <dt>جنسیت:</dt><dd><?= e($u['gender']) ?></dd>
      <dt>سطح تجربه:</dt><dd><?= (int)$u['level'] ?></dd>
      <dt>شماره تماس:</dt><dd dir="ltr"><?= e($u['phone']) ?></dd>
      <dt>شماره حساب:</dt><dd dir="ltr"><?= e($u['acc']) ?></dd></dl>
      <div class="cid"><small>شماره شناسایی</small><b dir="ltr"><?= e($u['cid']) ?></b></div></div>
  </article>

<?php elseif ($p === 'tickets'): ?>
  <h2>سیستم تیکت</h2>
  <form method="post" class="panel"><?= csrf_field() ?><input type="hidden" name="a" value="new">
    <label>موضوع<input name="subject" maxlength="120" required></label>
    <label>توضیحات<textarea name="body" rows="4" maxlength="2000" required></textarea></label>
    <button class="btn pri">ارسال تیکت</button></form>
  <?php $q = $db->prepare('SELECT t.*,u.fullname FROM web_tickets t JOIN web_accounts u ON u.id=t.user_id ' . ($admin ? '' : 'WHERE t.user_id=? ') . 'ORDER BY t.id DESC LIMIT 100');
        $q->execute($admin ? [] : [$u['id']]); $rows = $q->fetchAll(); ?>
  <div class="list"><?php foreach ($rows as $t): ?>
    <a class="row" href="dashboard.php?p=ticket&id=<?= (int)$t['id'] ?>"><b>#<?= (int)$t['id'] ?> <?= e($t['subject']) ?></b>
      <?= $admin ? '<small>' . e($t['fullname']) . '</small>' : '' ?><span class="tag <?= e($t['status']) ?>"><?= $st[$t['status']] ?></span></a>
  <?php endforeach; if (!$rows) echo '<p class="mut">هنوز تیکتی نساخته‌ای. از فرم بالا اولین تیکتت را بفرست.</p>'; ?></div>

<?php elseif ($p === 'ticket' && ($t = ticket_of((int)($_GET['id'] ?? 0), $u))): ?>
  <h2>#<?= (int)$t['id'] ?> <?= e($t['subject']) ?> <span class="tag <?= e($t['status']) ?>"><?= $st[$t['status']] ?></span></h2>
  <?php $m = $db->prepare('SELECT m.*,u.fullname,u.role FROM web_msgs m JOIN web_accounts u ON u.id=m.user_id WHERE ticket_id=? ORDER BY m.id'); $m->execute([$t['id']]); ?>
  <div class="chat"><?php foreach ($m as $x): ?><div class="msg <?= $x['role'] === 'admin' ? 'staff' : '' ?>"><small><?= e($x['fullname']) ?> · <?= date('Y/m/d H:i', (int)$x['created']) ?></small><p><?= nl2br(e($x['body'])) ?></p></div><?php endforeach; ?></div>
  <?php if ($t['status'] !== 'closed'): ?>
  <form method="post" class="panel"><?= csrf_field() ?><input type="hidden" name="id" value="<?= (int)$t['id'] ?>">
    <textarea name="body" rows="3" maxlength="2000" required aria-label="پاسخ"></textarea>
    <button class="btn pri" name="a" value="reply">ارسال پاسخ</button>
    <button class="btn" name="a" value="close" formnovalidate>بستن تیکت</button></form>
  <?php endif; ?>

<?php elseif ($p === 'settings'): ?>
  <h2>تنظیمات</h2>
  <form method="post" class="panel"><?= csrf_field() ?><input type="hidden" name="a" value="pass">
    <label>رمز عبور فعلی<input type="password" name="old" dir="ltr" required autocomplete="current-password"></label>
    <label>رمز عبور جدید<input type="password" name="new" dir="ltr" minlength="6" required autocomplete="new-password"></label>
    <button class="btn pri">تغییر رمز عبور</button></form>
<?php else: go('dashboard.php'); endif; ?>
</main></div></body></html>
