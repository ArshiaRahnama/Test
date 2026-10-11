<?php
require __DIR__ . '/lib.php';
if (($_GET['out'] ?? '') === '1') { $_SESSION = []; session_destroy(); go('index.php'); }
if (me()) go('dashboard.php');
// حساب فقط داخل بازی (Unique_Login) ساخته می‌شه؛ اینجا با همون نام کاربری/شماره و رمزِ بازی وارد می‌شی.
$err = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  csrf_check();
  if ($u = game_login($_POST['ident'] ?? '', $_POST['pass'] ?? '', $err)) {
    $n = $_SESSION['next'] ?? ''; session_regenerate_id(true);
    $_SESSION['uid'] = sync_web_account($u, display_name($u, game_profile($u))); $_SESSION['lid'] = (int)$u['id']; unset($_SESSION['next']);
    go(preg_match('/^dashboard\.php(\?[\w=&%.+\-]*)?$/', $n) ? $n : 'dashboard.php');
  }
}
?><!DOCTYPE html>
<html lang="fa" dir="rtl"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>ورود | <?= e(CFG['name']) ?></title><meta name="theme-color" content="#050505">
<link rel="stylesheet" href="style.css"></head>
<body class="authpage">
<div class="authglow"></div>
<main class="box">
  <a href="index.php" class="logo big"><svg viewBox="0 0 64 64"><defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#ffe08a"/><stop offset="1" stop-color="#d18f00"/></linearGradient></defs><path d="M16 8v28a16 16 0 0 0 32 0V8" fill="none" stroke="url(#g)" stroke-width="11" stroke-linecap="round"/></svg><span><?= e(strtok(CFG['name'], ' ')) ?> <b><?= e(trim(strstr(CFG['name'], ' '))) ?></b></span></a>
  <h1>ورود به <span class="gt">ناحیه کاربری</span></h1>
  <p class="mut" style="margin:-10px 0 20px;font-size:.9rem">با همون نام کاربری (یا شماره) و رمزی که داخل بازی می‌زنی وارد شو؛ اطلاعات کاراکترت اینجا نشون داده می‌شه.</p>
  <?php if ($err): ?><p class="err" role="alert"><?= e($err) ?></p><?php endif; ?>
  <form method="post" autocomplete="on">
    <?= csrf_field() ?>
    <label>نام کاربری یا شماره موبایل<input name="ident" dir="ltr" placeholder="Arshia_Mtz یا 09xxxxxxxxx" required autofocus autocomplete="username" value="<?= e($_POST['ident'] ?? '') ?>"></label>
    <label>رمز عبور<input type="password" name="pass" dir="ltr" required autocomplete="current-password"></label>
    <button class="btn pri wide">ورود</button>
  </form>
  <p class="lockinfo"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/></svg>حساب فقط داخل بازی ساخته می‌شه. رمزت رو فراموش کردی؟ داخل بازی «فراموشی رمز عبور» رو بزن.</p>
  <p class="alt"><a href="index.php">← بازگشت به صفحه اصلی</a></p>
</main></body></html>
