<?php
/* صفحه‌ها و اکشن‌های داشبورد: تیکت، تنظیمات (امنیت و دستگاه‌ها) و لاگ سرور (ادمین) */
const DASH_EXT_PAGES = ['tickets', 'settings', 'srvlogs'];

function dash_ext_post(array $u, bool $admin, string &$flash, string &$ok, string &$p): void {
  $a = (string)($_POST['a'] ?? ''); $db = db(); $uid = (int)$u['id'];
  switch ($a) {
    case 'totp_start': {
      $p = 'settings'; $_GET['t'] = 'security'; $sec = b32enc(random_bytes(10));
      $db->prepare('DELETE FROM web_totp WHERE user_id=?')->execute([$uid]); $db->prepare('INSERT INTO web_totp(user_id,secret,enabled) VALUES(?,?,0)')->execute([$uid, $sec]); break;
    }
    case 'totp_enable': {
      $p = 'settings'; $_GET['t'] = 'security'; $r = totp_row($uid);
      if ($r && totp_check($r['secret'], (string)($_POST['code'] ?? ''))) { $db->prepare('UPDATE web_totp SET enabled=1 WHERE user_id=?')->execute([$uid]); $ok = 'تایید دو مرحله‌ای فعال شد.'; }
      else $flash = 'کد نادرست است؛ لطفاً کد جدید برنامه‌ی Authenticator را وارد کنید.'; break;
    }
    case 'totp_disable': {
      $p = 'settings'; $_GET['t'] = 'security'; $r = totp_row($uid);
      if ($r && totp_check($r['secret'], (string)($_POST['code'] ?? ''))) { $db->prepare('DELETE FROM web_totp WHERE user_id=?')->execute([$uid]); $ok = 'تایید دو مرحله‌ای غیرفعال شد.'; }
      else $flash = 'کد نادرست است؛ لطفاً کد فعلی برنامه‌ی Authenticator را وارد کنید.'; break;
    }
    case 'dev_revoke': {
      $p = 'settings'; $_GET['t'] = 'devices'; $db->prepare('DELETE FROM web_devices WHERE id=? AND user_id=? AND token_hash<>?')->execute([(int)($_POST['id'] ?? 0), $uid, hash('sha256', (string)($_SESSION['dev'] ?? ''))]); $ok = 'دستگاه از حساب خارج شد.'; break;
    }
    case 'dev_revoke_all': {
      $p = 'settings'; $_GET['t'] = 'devices'; $db->prepare('DELETE FROM web_devices WHERE user_id=? AND token_hash<>?')->execute([$uid, hash('sha256', (string)($_SESSION['dev'] ?? ''))]); $ok = 'خروج از همه‌ی دستگاه‌های دیگر انجام شد.'; break;
    }
  }
}

function ext_nav_icons(): array {
  return [
    'srvlogs' => '<path d="M4 19.500A2.500 2.500 0 0 1 6.500 17H20"/><path d="M6.500 2H20v20H6.500A2.500 2.500 0 0 1 4 19.500v-15A2.500 2.500 0 0 1 6.500 2Z"/>',
  ];
}

function dash_tabs(string $base, array $tabs, string $cur): void {
  echo '<div class="seg">'; foreach ($tabs as $k => $l) echo '<button class="' . ($cur === $k ? 'on' : '') . '" onclick="location=\'dashboard.php?p=' . e($base) . '&t=' . e($k) . '\'">' . e($l) . '</button>'; echo '</div>';
}

function dash_ext_page(string $p, array $u, bool $admin): void {
  $db = db(); $uid = (int)$u['id']; $t = (string)($_GET['t'] ?? '');
  if ($p === 'srvlogs' && !$admin) { echo '<div class="empty2">شما به این بخش دسترسی ندارید.</div>'; return; }

  /* ===== تیکت ===== */
  if ($p === 'tickets') {
    global $st; $s = ($_GET['s'] ?? 'open') === 'closed' ? 'closed' : 'open';
    $q = $db->prepare('SELECT t.*,u.fullname,(SELECT COUNT(*) FROM web_msgs m WHERE m.ticket_id=t.id) AS steps FROM web_tickets t JOIN web_accounts u ON u.id=t.user_id ' . ($admin ? '' : 'WHERE t.user_id=? ') . 'ORDER BY t.id DESC LIMIT 200');
    $q->execute($admin ? [] : [$uid]); $all = $q->fetchAll(); $cO = 0; $cC = 0; foreach ($all as $r) { if ($r['status'] === 'closed') $cC++; else $cO++; }
    $rows = array_values(array_filter($all, fn($r) => ($r['status'] === 'closed') === ($s === 'closed'))); ?>
    <div class="head"><div><h2>سیستم تیکت</h2><p class="lead" style="margin:0">برای ثبت سوال یا مشکل، تیکت ارسال کنید.</p></div><button class="btn pri" onclick="document.getElementById('newtk').toggleAttribute('hidden')">+ تیکت جدید</button></div>
    <form method="post" class="dcardx" id="newtk" hidden><?= csrf_field() ?><input type="hidden" name="a" value="new">
      <div class="fgrid"><label>دسته‌بندی<select name="category"><?php foreach (TICKET_CATS as $k => $l): ?><option value="<?= e($k) ?>"><?= e($l) ?></option><?php endforeach; ?></select></label>
      <label>موضوع<input name="subject" maxlength="120" required></label></div>
      <label>توضیحات<textarea name="body" rows="4" maxlength="2000" required></textarea></label><button class="btn pri">ارسال تیکت</button></form>
    <form method="get" class="dcardx" style="display:flex;gap:10px"><input type="hidden" name="p" value="tickets"><input name="tq" value="<?= e($_GET['tq'] ?? '') ?>" placeholder="شماره تیکت را وارد کنید..."><button class="btn">جستجو</button></form>
    <?php if (($tq = (int)digits((string)($_GET['tq'] ?? ''))) > 0) { $rows = array_values(array_filter($all, fn($r) => (int)$r['id'] === $tq)); } ?>
    <div class="seg"><button class="<?= $s === 'open' ? 'on' : '' ?>" onclick="location='dashboard.php?p=tickets&s=open'">باز (<?= $cO ?>)</button><button class="<?= $s === 'closed' ? 'on' : '' ?>" onclick="location='dashboard.php?p=tickets&s=closed'">بسته (<?= $cC ?>)</button></div>
    <div class="list tklist"><?php foreach ($rows as $r): ?>
      <a class="row tkrow st-<?= e($r['status']) ?>" href="dashboard.php?p=ticket&id=<?= (int)$r['id'] ?>"><b><?= e($r['subject']) ?></b>
        <span class="tag"><?= e(TICKET_CATS[$r['category'] ?? ''] ?? 'پشتیبانی عمومی') ?></span><?= $admin ? '<small>' . e($r['fullname']) . '</small>' : '' ?>
        <span class="tag <?= e($r['status']) ?>"><?= e($st[$r['status']]) ?></span><span class="tag open">مرحله <?= (int)$r['steps'] ?></span><span class="tkid">#<?= (int)$r['id'] ?></span></a>
    <?php endforeach; if (!$rows) echo '<p class="mut">تیکتی در این بخش نیست.</p>'; ?></div>
    <?php return; }

  /* ===== تنظیمات ===== */
  if ($p === 'settings') {
    $t = in_array($t, ['account', 'security', 'devices', 'links'], true) ? $t : 'account'; ?>
    <h2>تنظیمات</h2><p class="lead">مدیریت حساب، امنیت و دستگاه‌ها.</p>
    <?php dash_tabs('settings', ['account' => 'حساب', 'security' => 'امنیت', 'devices' => 'دستگاه‌ها', 'links' => 'اتصال‌ها'], $t);
    if ($t === 'account'): ?>
      <div class="dcardx"><h3>اطلاعات حساب</h3><dl><dt>نام کاربری</dt><dd dir="ltr"><?= e($u['username']) ?></dd><dt>نام کاراکتر</dt><dd dir="ltr"><?= e($u['fullname']) ?></dd><dt>شماره تلفن</dt><dd dir="ltr"><?= e($mask = preg_match('/^09\d{9}$/', $u['phone']) ? substr($u['phone'], 0, 4) . '***' . substr($u['phone'], -4) : '—') ?> <span class="tag">غیرقابل تغییر</span></dd></dl></div>
    <?php elseif ($t === 'security'): $r = totp_row($uid); $on = $r && (int)$r['enabled'] === 1; ?>
      <div class="dcardx"><h3>ورود دو مرحله‌ای (Authenticator)</h3>
      <p class="mut">با فعال‌سازی این گزینه، یک لایه امنیتی اضافه روی حساب شما قرار می‌گیرد. برای استفاده به یک اپلیکیشن Authenticator (پیشنهاد ما: Microsoft Authenticator) نیاز دارید. ورودهای جدید به حساب سایت نیازمند کد Authenticator خواهند بود.</p>
      <?php if ($on): ?><p class="ok-msg" style="margin-top:12px">فعال است</p>
        <form method="post" class="row-actions"><?= csrf_field() ?><input type="hidden" name="a" value="totp_disable"><label style="margin:0">برای غیرفعال‌سازی، کد فعلی را وارد کنید<input name="code" dir="ltr" inputmode="numeric" maxlength="6" required></label><button class="btn no">غیرفعال‌سازی</button></form>
      <?php elseif ($r): $uri = 'otpauth://totp/' . rawurlencode(CFG['name'] . ':' . $u['username']) . '?secret=' . $r['secret'] . '&issuer=' . rawurlencode(CFG['name']); ?>
        <div class="dcardx" style="margin-top:14px"><p>این کلید را در اپلیکیشن Authenticator اضافه کنید (اسکن QR یا ورود دستی):</p>
          <div id="qr" style="background:#fff;padding:10px;display:inline-block;border-radius:10px;margin:10px 0"></div>
          <p><b dir="ltr" style="color:var(--gold);letter-spacing:.12em"><?= e(trim(chunk_split($r['secret'], 4, ' '))) ?></b></p>
          <form method="post" class="row-actions"><?= csrf_field() ?><input type="hidden" name="a" value="totp_enable"><label style="margin:0">کد ۶ رقمی<input name="code" dir="ltr" inputmode="numeric" maxlength="6" required></label><button class="btn pri">فعال‌سازی</button></form></div>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script><script>if(window.QRCode)new QRCode(document.getElementById('qr'),{text:<?= json_encode($uri) ?>,width:168,height:168});</script>
      <?php else: ?><form method="post" style="margin-top:14px"><?= csrf_field() ?><input type="hidden" name="a" value="totp_start"><button class="btn pri">فعال‌سازی</button></form><?php endif; ?></div>
      <form method="post" class="dcardx" style="max-width:480px"><?= csrf_field() ?><input type="hidden" name="a" value="pass"><h3>تغییر رمز عبور</h3>
        <p class="mut">رمز عبور سایت همان رمز ورود به شهر در لانچر VMP است و نام کاربری، شماره موبایل ثبت‌شده‌ی حساب شما است.</p>
        <label>رمز عبور فعلی<input type="password" name="old" dir="ltr" required autocomplete="current-password"></label>
        <label>رمز عبور جدید<input type="password" name="new" dir="ltr" minlength="6" required autocomplete="new-password"></label><p class="hint">حداقل ۶ کاراکتر، شامل حداقل یک حرف انگلیسی و یک عدد.</p>
        <button class="btn pri">تغییر رمز عبور</button></form>
    <?php elseif ($t === 'devices'): $q = $db->prepare('SELECT * FROM web_devices WHERE user_id=? ORDER BY last DESC LIMIT 30'); $q->execute([$uid]); $cur = hash('sha256', (string)($_SESSION['dev'] ?? '')); ?>
      <div class="dcardx"><h3>دستگاه‌های وارد‌شده</h3><div class="list">
      <?php foreach ($q as $d): ?><div class="row"><b><?= e(ua_label((string)$d['ua'])) ?><?= hash_equals($cur, (string)$d['token_hash']) ? ' <span class="tag accepted">این دستگاه</span>' : '' ?></b><small dir="ltr"><?= e($d['ip']) ?></small><small><?= e(ago((int)$d['last'])) ?></small>
        <?php if (!hash_equals($cur, (string)$d['token_hash'])): ?><form method="post" style="margin-inline-start:auto"><?= csrf_field() ?><input type="hidden" name="a" value="dev_revoke"><input type="hidden" name="id" value="<?= (int)$d['id'] ?>"><button class="btn no" style="padding:4px 14px">خروج</button></form><?php endif; ?></div><?php endforeach; ?></div>
      <form method="post" style="margin-top:14px" onsubmit="return confirm('از همه‌ی دستگاه‌های دیگر خارج می‌شوید؟')"><?= csrf_field() ?><input type="hidden" name="a" value="dev_revoke_all"><button class="btn no">خروج از همه‌ی دستگاه‌های دیگر</button></form></div>
    <?php else: ?>
      <div class="dcardx"><h3>اتصال‌ها</h3><dl><dt>لانچر VMP</dt><dd>متصل · نام کاربری <b dir="ltr"><?= e($u['username']) ?></b></dd><dt>کاراکتر</dt><dd><?= $u['game'] ? 'متصل · ' . e($u['fullname']) : 'هنوز وصل نیست' ?></dd><dt>دیسکورد</dt><dd><a href="<?= e(CFG['discord']) ?>" target="_blank" rel="noopener" style="color:var(--gold)">ورود به سرور دیسکورد</a></dd></dl></div>
    <?php endif; return; }

  /* ===== لاگ سرور (ادمین) + ثبت پانیشمنت ===== */
  if ($p === 'srvlogs') {
    $lc = trim($_GET['c'] ?? ''); $lj = trim($_GET['j'] ?? ''); $lq = trim($_GET['q'] ?? ''); $logs = admin_logs($lc, $lj, $lq, 80); ?>
    <h2>لاگ‌های سرور</h2><p class="lead">لاگ‌های ثبت‌شده در سرور.</p>
    <form method="get" class="dcardx" style="display:flex;gap:10px;flex-wrap:wrap"><input type="hidden" name="p" value="srvlogs">
      <select name="c" style="width:auto"><option value="">همه‌ی دسته‌ها</option><?php foreach (admin_log_categories() as $cat): ?><option value="<?= e($cat) ?>" <?= $lc === $cat ? 'selected' : '' ?>><?= e($cat) ?></option><?php endforeach; ?></select>
      <input name="q" value="<?= e($lq) ?>" placeholder="جستجو" style="flex:1;min-width:200px"><button class="btn pri">فیلتر</button></form>
    <div class="list"><?php foreach ($logs as $lg): ?><div class="row"><b><?= e($lg['title'] ?: $lg['category']) ?></b><small><?= e($lg['category']) ?><?= $lg['player_name'] ? ' · ' . e($lg['player_name']) : '' ?> · <?= e($lg['created_at']) ?></small><span class="mut" style="flex-basis:100%"><?= e(mb_substr((string)$lg['message'], 0, 200)) ?></span></div>
    <?php endforeach; if (!$logs) echo '<p class="mut">لاگی پیدا نشد.</p>'; ?></div>
    <?php return; }
}
