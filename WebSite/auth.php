<?php
require __DIR__ . '/lib.php';
if (($_GET['out'] ?? '') === '1') { $_SESSION = []; session_destroy(); go('index.php'); }
if (me()) go('dashboard.php');
// ثبت‌نام عمومی وجود نداره؛ حساب‌ها فقط توسط مدیریت ساخته می‌شن و اینجا فقط می‌شه لاگین کرد.
$err = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  csrf_check();
  $phone = digits($_POST['phone'] ?? ''); $pass = $_POST['pass'] ?? '';
  if (!preg_match('/^09\d{9}$/', $phone)) $err = 'شماره موبایل باید به شکل 09xxxxxxxxx باشد.';
  else {
    $s = db()->prepare('SELECT * FROM web_accounts WHERE phone=?'); $s->execute([$phone]); $u = $s->fetch();
    if ($u && password_verify($pass, $u['pass'])) {
      $n = $_SESSION['next'] ?? ''; session_regenerate_id(true); $_SESSION['uid'] = (int)$u['id']; unset($_SESSION['next']);
      go(preg_match('/^dashboard\.php(\?[\w=&%.+\-]*)?$/', $n) ? $n : 'dashboard.php');
    }
    usleep(600000); $err = 'شماره یا رمز عبور اشتباه است.';
  }
}
?><!DOCTYPE html>
<html lang="fa" dir="rtl"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>ورود | <?= e(CFG['name']) ?></title><meta name="theme-color" content="#050505">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@400;700;900&display=swap">
<link rel="stylesheet" href="style.css"></head>
<body class="authpage">
<div class="authglow"></div>
<main class="box">
  <a href="index.php" class="logo big"><svg viewBox="0 0 64 64"><defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#ffe08a"/><stop offset="1" stop-color="#d18f00"/></linearGradient></defs><path d="M16 8v28a16 16 0 0 0 32 0V8" fill="none" stroke="url(#g)" stroke-width="11" stroke-linecap="round"/></svg><span><?= e(strtok(CFG['name'], ' ')) ?> <b><?= e(trim(strstr(CFG['name'], ' '))) ?></b></span></a>
  <h1>ورود به <span class="gt">ناحیه کاربری</span></h1>
  <p class="mut" style="margin:-10px 0 20px;font-size:.9rem">با حساب شهروندی‌ات وارد شو تا درخواست عضویت ثبت کنی و وضعیتش رو پیگیری کنی.</p>
  <?php if ($err): ?><p class="err" role="alert"><?= e($err) ?></p><?php endif; ?>
  <form method="post" autocomplete="on">
    <?= csrf_field() ?>
    <label>شماره موبایل<input name="phone" inputmode="numeric" dir="ltr" placeholder="09xxxxxxxxx" required autofocus value="<?= e($_POST['phone'] ?? '') ?>"></label>
    <label>رمز عبور<input type="password" name="pass" dir="ltr" required autocomplete="current-password"></label>
    <button class="btn pri wide">ورود</button>
  </form>
  <p class="lockinfo"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/></svg>ساخت حساب از طریق سایت امکان‌پذیر نیست؛ حساب‌ها توسط مدیریت شهر صادر می‌شن.</p>
  <p class="alt"><a href="index.php">← بازگشت به صفحه اصلی</a></p>
</main></body></html>
