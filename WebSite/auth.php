<?php
require __DIR__ . '/lib.php';
if (($_GET['out'] ?? '') === '1') {
  if (!empty($_SESSION['dev'])) { try { db()->prepare('DELETE FROM web_devices WHERE token_hash=?')->execute([hash('sha256', $_SESSION['dev'])]); } catch (Throwable $e) {} }
  $_SESSION = []; session_destroy(); go('index.php');
}
if (me()) go('dashboard.php');
// حساب فقط داخل بازی ساخته می‌شه. ورود: ۱) شماره/نام کاربری + رمز  ۲) کد ۶ رقمی دستور /getcode داخل بازی
$err = ''; $mode = ($_GET['m'] ?? $_POST['mode'] ?? 'pw') === 'code' ? 'code' : 'pw';
$pre = $_SESSION['pre'] ?? null;   // مرحله‌ی دوم: کد Authenticator

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  csrf_check();
  if (isset($_POST['totp']) && $pre && time() < $pre['exp']) {                       // مرحله‌ی تایید دو مرحله‌ای
    $q = db()->prepare('SELECT * FROM login_users WHERE id=?'); $q->execute([$pre['lid']]); $lu = $q->fetch();
    $row = $lu ? totp_row($pre['uid']) : null;
    if (rate_full('totp:' . $pre['lid'], 6, 600)) $err = 'تعداد تلاش‌ها بیش از حد مجاز است؛ لطفاً چند دقیقه بعد دوباره تلاش کنید.';
    elseif ($row && totp_check($row['secret'], $_POST['totp'])) { login_finish($lu); go('dashboard.php'); }
    else { rate_hit('totp:' . $pre['lid'], 600); $err = 'کد Authenticator نادرست است.'; }
  } elseif (!empty($_POST['website'])) { $err = 'درخواست نامعتبر.'; }                // honeypot
  else {
    $u = null;
    if ($mode === 'code') {
      $ip = $_SERVER['REMOTE_ADDR'] ?? '0';
      if (rate_full("code-ip:$ip", 10, 600)) $err = 'تعداد تلاش‌ها بیش از حد مجاز است؛ لطفاً چند دقیقه بعد دوباره تلاش کنید.';
      elseif (!($u = code_consume($_POST['code'] ?? ''))) { rate_hit("code-ip:$ip", 600); $err = 'کد نادرست است یا منقضی شده است. لطفاً در بازی دوباره دستور /getcode را وارد کنید.'; }
    } else $u = game_login($_POST['ident'] ?? '', $_POST['pass'] ?? '', $err);
    if ($u) {
      $g = game_profile($u); $uid = sync_web_account($u, display_name($u, $g));
      if (totp_enabled($uid)) { $_SESSION['pre'] = ['lid' => (int)$u['id'], 'uid' => $uid, 'exp' => time() + 300]; $pre = $_SESSION['pre']; }
      else { $n = $_SESSION['next'] ?? ''; login_finish($u); unset($_SESSION['next']); go(preg_match('/^(dashboard|shop|gallery)\.php(\?[\w=&%.+\-]*)?$/', $n) ? $n : 'dashboard.php'); }
    }
  }
}
$needTotp = $pre && time() < $pre['exp'];
?><!DOCTYPE html>
<html lang="fa" dir="rtl"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>ورود | <?= e(CFG['name']) ?></title><meta name="theme-color" content="#050505">
<link rel="preload" href="fonts/Vazirmatn.woff2" as="font" type="font/woff2" crossorigin>
<link rel="stylesheet" href="<?=asset('style.css')?>"></head>
<body class="authpage">
<div class="authglow"></div>
<main class="box">
  <a href="index.php" class="logo big"><svg viewBox="0 0 64 64"><defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#ffe08a"/><stop offset="1" stop-color="#d18f00"/></linearGradient></defs><path d="M16 8v28a16 16 0 0 0 32 0V8" fill="none" stroke="url(#g)" stroke-width="11" stroke-linecap="round"/></svg><span><?= e(strtok(CFG['name'], ' ')) ?> <b><?= e(trim(strstr(CFG['name'], ' '))) ?></b></span></a>
  <h1>ورود به <span class="gt"><?= e(CFG['name']) ?></span></h1>
  <?php if ($err): ?><p class="err" role="alert"><?= e($err) ?></p><?php endif; ?>

  <?php if ($needTotp): ?>
  <p class="mut" style="margin:-8px 0 16px;font-size:.9rem">کد ۶ رقمی برنامه‌ی Authenticator را وارد کنید.</p>
  <form method="post"><?= csrf_field() ?>
    <label>کد تایید<input name="totp" dir="ltr" inputmode="numeric" maxlength="6" autocomplete="one-time-code" required autofocus style="letter-spacing:.5em;text-align:center;font-size:1.3rem"></label>
    <button class="btn pri wide">تایید و ورود</button>
  </form>
  <?php else: ?>
  <p class="mut" style="margin:-8px 0 16px;font-size:.9rem">برای ورود به داشبورد، روش ورود را انتخاب کنید.</p>
  <div class="seg" style="display:flex;margin-bottom:18px"><button type="button" class="<?= $mode === 'pw' ? 'on' : '' ?>" style="flex:1" onclick="location='auth.php?m=pw'">شماره و رمز عبور</button><button type="button" class="<?= $mode === 'code' ? 'on' : '' ?>" style="flex:1" onclick="location='auth.php?m=code'">کد یکبارمصرف</button></div>
  <form method="post" autocomplete="on"><?= csrf_field() ?><input type="hidden" name="mode" value="<?= $mode ?>">
    <input name="website" tabindex="-1" autocomplete="off" style="position:absolute;left:-9999px" aria-hidden="true">
    <?php if ($mode === 'code'): ?>
    <p class="lockinfo" style="margin:0 0 14px">در چت بازی دستور <b dir="ltr" style="color:var(--gold)">/getcode</b> را وارد کنید و کد ۶ رقمی دریافتی را در این قسمت وارد نمایید. کد ۳ دقیقه اعتبار دارد.</p>
    <label>کد یکبارمصرف<input name="code" dir="ltr" inputmode="numeric" maxlength="6" placeholder="------" required autofocus autocomplete="one-time-code" style="letter-spacing:.5em;text-align:center;font-size:1.3rem"></label>
    <?php else: ?>
    <label>شماره تلفن یا نام کاربری<input name="ident" dir="ltr" placeholder="09123456789" required autofocus autocomplete="username" value="<?= e($_POST['ident'] ?? '') ?>"></label>
    <label>رمز عبور<span class="pwrap"><input type="password" name="pass" id="pw" dir="ltr" required autocomplete="current-password"><button type="button" id="pwt" class="pwt" aria-label="نمایش رمز"><svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M2 12s3.6-7 10-7 10 7 10 7-3.6 7-10 7S2 12 2 12Z"/><circle cx="12" cy="12" r="3"/></svg></button></span></label>
    <?php endif; ?>
    <button class="btn pri wide">ورود</button>
  </form>
  <p class="lockinfo"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/></svg>حساب کاربری فقط از داخل بازی ساخته می‌شود. در صورت فراموشی رمز عبور، گزینه‌ی «فراموشی رمز عبور» را در بازی انتخاب کنید.</p>
  <?php endif; ?>
  <p class="alt"><a href="index.php">← بازگشت به سایت</a></p>
</main>
<script>(()=>{const i=document.getElementById("pw"),b=document.getElementById("pwt");if(i&&b)b.onclick=()=>{const h=i.type==="password";i.type=h?"text":"password";b.setAttribute("aria-label",h?"پنهان کردن رمز":"نمایش رمز")}})()</script>
</body></html>
