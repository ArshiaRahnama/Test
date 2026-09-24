<?php
require __DIR__ . '/lib.php';
if (($_GET['out'] ?? '') === '1') { $_SESSION = []; session_destroy(); go('index.php'); }
if (me()) go('dashboard.php');
$err = ''; $mode = ($_GET['m'] ?? '') === 'reg' ? 'reg' : 'login';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  csrf_check();
  $phone = preg_replace('/\D/', '', strtr($_POST['phone'] ?? '', ['۰'=>'0','۱'=>'1','۲'=>'2','۳'=>'3','۴'=>'4','۵'=>'5','۶'=>'6','۷'=>'7','۸'=>'8','۹'=>'9']));
  $pass = $_POST['pass'] ?? '';
  $db = db();
  if (!preg_match('/^09\d{9}$/', $phone)) $err = 'شماره موبایل باید به شکل 09xxxxxxxxx باشد.';
  elseif (($_POST['a'] ?? '') === 'reg') {
    $mode = 'reg'; $name = trim($_POST['fullname'] ?? ''); $g = ($_POST['gender'] ?? '') === 'f' ? 'مونث' : 'مذکر';
    if (mb_strlen($name) < 3 || mb_strlen($name) > 40) $err = 'نام و نام خانوادگی باید بین ۳ تا ۴۰ حرف باشد.';
    elseif (strlen($pass) < 6) $err = 'رمز عبور حداقل ۶ کاراکتر باشد.';
    else {
      $s = $db->prepare('SELECT 1 FROM users WHERE phone=?'); $s->execute([$phone]);
      if ($s->fetch()) $err = 'این شماره قبلاً ثبت‌نام کرده است.';
      else {
        $first = (int)$db->query('SELECT COUNT(*) FROM users')->fetchColumn() === 0;   // اولین کاربر = ادمین
        $acc = random_int(100, 999) . '-' . random_int(100, 999);
        $db->prepare('INSERT INTO users(phone,pass,fullname,gender,acc,cid,role,created) VALUES(?,?,?,?,?,?,?,?)')
           ->execute([$phone, password_hash($pass, PASSWORD_DEFAULT), $name, $g, $acc, '', $first ? 'admin' : 'user', time()]);
        $id = (int)$db->lastInsertId();
        $db->prepare('UPDATE users SET cid=? WHERE id=?')->execute([str_pad((string)$id, 8, '0', STR_PAD_LEFT), $id]);
        session_regenerate_id(true); $_SESSION['uid'] = $id; go('dashboard.php');
      }
    }
  } else {
    $s = $db->prepare('SELECT * FROM users WHERE phone=?'); $s->execute([$phone]); $u = $s->fetch();
    if ($u && password_verify($pass, $u['pass'])) { session_regenerate_id(true); $_SESSION['uid'] = (int)$u['id']; go('dashboard.php'); }
    usleep(600000); $err = 'شماره یا رمز عبور اشتباه است.';
  }
}
?><!DOCTYPE html>
<html lang="fa" dir="rtl"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>ورود | <?= e(CFG['name']) ?></title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Vazirmatn:wght@400;700;900&display=swap">
<link rel="stylesheet" href="style.css"></head>
<body class="authpage"><main class="box">
  <a href="index.php" class="logo big">U <b><?= e(CFG['name']) ?></b></a>
  <h1><?= $mode === 'reg' ? 'ساخت حساب شهروندی' : 'ورود به ناحیه کاربری' ?></h1>
  <?php if ($err): ?><p class="err" role="alert"><?= e($err) ?></p><?php endif; ?>
  <form method="post" autocomplete="on">
    <?= csrf_field() ?><input type="hidden" name="a" value="<?= $mode ?>">
    <?php if ($mode === 'reg'): ?>
      <label>نام و نام خانوادگی کاراکتر<input name="fullname" required maxlength="40" value="<?= e($_POST['fullname'] ?? '') ?>"></label>
      <label>جنسیت<select name="gender"><option value="m">مذکر</option><option value="f">مونث</option></select></label>
    <?php endif; ?>
    <label>شماره موبایل<input name="phone" inputmode="numeric" dir="ltr" placeholder="09xxxxxxxxx" required value="<?= e($_POST['phone'] ?? '') ?>"></label>
    <label>رمز عبور<input type="password" name="pass" dir="ltr" required minlength="6" autocomplete="<?= $mode === 'reg' ? 'new-password' : 'current-password' ?>"></label>
    <button class="btn pri wide"><?= $mode === 'reg' ? 'ثبت‌نام' : 'ورود' ?></button>
  </form>
  <p class="alt"><?= $mode === 'reg' ? '<a href="auth.php">حساب داری؟ وارد شو</a>' : '<a href="auth.php?m=reg">حساب نداری؟ ثبت‌نام کن</a>' ?></p>
</main></body></html>
