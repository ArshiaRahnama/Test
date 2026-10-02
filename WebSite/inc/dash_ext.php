<?php
/* صفحه‌ها و اکشن‌های جدید داشبورد: کیف پول، لاگ‌ها، تیکت، تنظیمات، مدیریت فروشگاه/گالری */
const DASH_EXT_PAGES = ['wallet', 'logs', 'tickets', 'settings', 'shopadm', 'galadm', 'srvlogs'];
const GATEWAY = ['url' => '', 'merchant' => ''];   // درگاه بانکی خودت رو اینجا وصل کن (gateway_start)

/** شروع پرداخت تومانی: اگه درگاه تنظیم نشده null برمی‌گردونه و درخواست «در انتظار» می‌مونه تا ادمین تایید کنه. */
function gateway_start(int $topupId, int $amount): ?string { return null; }

function dash_ext_post(array $u, bool $admin, string &$flash, string &$ok, string &$p): void {
  $a = (string)($_POST['a'] ?? ''); $db = db(); $uid = (int)$u['id'];
  // اکشن‌های بخش‌های خاموش اجرا نمی‌شن
  $need = ['topup' => 'wallet', 'conv_toman_token' => 'wallet', 'conv_token_money' => 'wallet', 'conv_money_token' => 'wallet', 'topup_credit' => 'wallet', 'gal_upload' => 'gallery', 'galadm_decide' => 'gallery',
           'shopadm_save' => 'shop', 'shopadm_toggle' => 'shop', 'shopadm_del' => 'shop'];
  if (isset($need[$a]) && !FEATURES[$need[$a]]) return;
  switch ($a) {
    case 'topup': {
      $amt = (int)digits((string)($_POST['amount'] ?? '0')); $p = 'wallet';
      if ($amt < 10000 || $amt > 50000000) { $flash = 'مبلغ شارژ باید بین ۱۰,۰۰۰ تا ۵۰,۰۰۰,۰۰۰ تومان باشد.'; break; }
      $db->prepare('INSERT INTO web_topups(user_id,amount,status,created) VALUES(?,?,?,?)')->execute([$uid, $amt, 'pending', time()]);
      $id = (int)$db->lastInsertId(); if ($url = gateway_start($id, $amt)) go($url);
      $ok = 'درخواست شارژ ثبت شد؛ پس از تایید پرداخت، موجودی اضافه خواهد شد.'; break;
    }
    case 'conv_toman_token': {
      $n = max(1, (int)($_POST['n'] ?? 1)); $p = 'wallet'; $_GET['t'] = 'convert';
      if (wallet_add($uid, 'toman', -$n * EXT['toman_per_token'], 'conv', "تبدیل به $n توکن")) { wallet_add($uid, 'tokens', $n, 'conv', 'از کیف پول'); $ok = "$n توکن به حساب شما اضافه شد."; }
      else $flash = 'موجودی کیف پول کافی نیست.'; break;
    }
    case 'conv_token_money': {
      $n = max(1, (int)($_POST['n'] ?? 1)); $p = 'wallet'; $_GET['t'] = 'convert';
      if (!$u['game'] || $u['online']) { $flash = 'برای تبدیل به پول بازی، باید در بازی آفلاین باشید.'; break; }
      if (!wallet_add($uid, 'tokens', -$n, 'conv', "تبدیل به پول بازی")) { $flash = 'موجودی توکن کافی نیست.'; break; }
      if (game_adjust($u, 'bank', $n * EXT['token_to_money'])) { $db->prepare('INSERT INTO web_tx(user_id,kind,detail,amount,created) VALUES(?,?,?,?,?)')->execute([$uid, 'conv', 'پول بازی', $n * EXT['token_to_money'], time()]); $ok = number_format($n * EXT['token_to_money']) . '$ به بانک بازی‌ات اضافه شد.'; }
      else { wallet_add($uid, 'tokens', $n, 'refund', 'برگشت تبدیل ناموفق'); $flash = 'تبدیل انجام نشد و توکن شما بازگردانده شد.'; } break;
    }
    case 'conv_money_token': {
      $n = max(1, (int)($_POST['n'] ?? 1)); $p = 'wallet'; $_GET['t'] = 'convert';
      if (!$u['game'] || $u['online']) { $flash = 'برای تبدیل پول بازی، باید در بازی آفلاین باشید.'; break; }
      if (!game_adjust($u, 'bank', -$n * EXT['money_per_token'])) { $flash = 'موجودی بانک بازی کافی نیست.'; break; }
      wallet_add($uid, 'tokens', $n, 'conv', 'از پول بازی'); $ok = "$n توکن به حساب شما اضافه شد."; break;
    }
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
      else $flash = 'برای غیرفعال‌سازی، کد فعلی را وارد کنید Authenticator را وارد کنید.'; break;
    }
    case 'dev_revoke': {
      $p = 'settings'; $_GET['t'] = 'devices'; $db->prepare('DELETE FROM web_devices WHERE id=? AND user_id=? AND token_hash<>?')->execute([(int)($_POST['id'] ?? 0), $uid, hash('sha256', (string)($_SESSION['dev'] ?? ''))]); $ok = 'دستگاه از حساب خارج شد.'; break;
    }
    case 'dev_revoke_all': {
      $p = 'settings'; $_GET['t'] = 'devices'; $db->prepare('DELETE FROM web_devices WHERE user_id=? AND token_hash<>?')->execute([$uid, hash('sha256', (string)($_SESSION['dev'] ?? ''))]); $ok = 'خروج از همه‌ی دستگاه‌های دیگر انجام شد.'; break;
    }
    case 'gal_upload': {
      $p = 'gallery'; [$okf, $msg] = gallery_save($uid, $_FILES['file'] ?? [], (string)($_POST['caption'] ?? '')); $_SESSION['gflash'] = [$okf, $msg]; go('gallery.php'); break;
    }
    case 'shopadm_save': {
      if (!$admin) break; $p = 'shopadm';
      $cat = (string)($_POST['cat'] ?? ''); $name = trim((string)($_POST['name'] ?? ''));
      if (!isset(SHOP_CATS[$cat]) || $name === '') { $flash = 'انتخاب دسته و وارد کردن نام آیتم الزامی است.'; break; }
      $img = trim((string)($_POST['image'] ?? '')); if ($img !== '' && !preg_match('#^(https?://|/)[^\s"\'<>]+$#', $img)) $img = '';
      $sub = (string)($_POST['sub'] ?? ''); if (!isset(SHOP_CATS[$cat]['subs'][$sub])) $sub = '';
      $db->prepare('INSERT INTO web_shop_items(cat,sub,name,code,image,price_money,price_token,price_tc,active,created) VALUES(?,?,?,?,?,?,?,?,1,?)')
         ->execute([$cat, $sub, mb_substr($name, 0, 120), mb_substr(trim((string)($_POST['code'] ?? '')), 0, 120), $img, max(0, (int)digits((string)($_POST['pm'] ?? '0'))), max(0, (int)($_POST['pt'] ?? 0)), max(0, (int)($_POST['ptc'] ?? 0)), time()]);
      $ok = 'آیتم اضافه شد.'; break;
    }
    case 'shopadm_toggle': { if ($admin) { $p = 'shopadm'; $db->prepare('UPDATE web_shop_items SET active=1-active WHERE id=?')->execute([(int)($_POST['id'] ?? 0)]); } break; }
    case 'shopadm_del':    { if ($admin) { $p = 'shopadm'; $db->prepare('DELETE FROM web_shop_items WHERE id=?')->execute([(int)($_POST['id'] ?? 0)]); $ok = 'حذف شد.'; } break; }
    case 'topup_credit': {
      if (!$admin) break; $p = 'shopadm'; $id = (int)($_POST['id'] ?? 0);
      $q = $db->prepare("SELECT * FROM web_topups WHERE id=? AND status='pending'"); $q->execute([$id]); $t = $q->fetch();
      if ($t) { $db->prepare("UPDATE web_topups SET status=? WHERE id=?")->execute([($_POST['d'] ?? '') === 'ok' ? 'paid' : 'rejected', $id]);
        if (($_POST['d'] ?? '') === 'ok') { wallet_add((int)$t['user_id'], 'toman', (int)$t['amount'], 'topup', 'شارژ #' . $id); notify((int)$t['user_id'], 'کیف پول شما ' . toman((int)$t['amount']) . ' تومان شارژ شد.', 'dashboard.php?p=wallet'); } $ok = 'ثبت شد.'; }
      break;
    }
    case 'galadm_decide': {
      if (!$admin) break; $p = 'galadm'; $id = (int)($_POST['id'] ?? 0); $d = (string)($_POST['d'] ?? '');
      $q = $db->prepare('SELECT * FROM web_gallery WHERE id=?'); $q->execute([$id]); $g = $q->fetch(); if (!$g) break;
      if ($d === 'approve') { $db->prepare("UPDATE web_gallery SET status='approved' WHERE id=?")->execute([$id]); notify((int)$g['user_id'], 'پست گالری شما تایید و منتشر شد.', 'gallery.php'); }
      elseif ($d === 'reject') { $db->prepare("UPDATE web_gallery SET status='rejected',note=? WHERE id=?")->execute([mb_substr(trim((string)($_POST['note'] ?? '')), 0, 200), $id]); notify((int)$g['user_id'], 'پست گالری شما رد شد.', 'dashboard.php?p=galadm'); }
      elseif ($d === 'pin') $db->prepare('UPDATE web_gallery SET pinned=1-pinned WHERE id=?')->execute([$id]);
      elseif ($d === 'delete') { @unlink(__DIR__ . '/../uploads/' . basename((string)$g['file'])); $db->prepare('DELETE FROM web_gallery WHERE id=?')->execute([$id]); $db->prepare('DELETE FROM web_likes WHERE post_id=?')->execute([$id]); }
      $ok = 'انجام شد.'; break;
    }
    case 'punish_add': {
      if (!$admin) break; $p = 'srvlogs'; $kind = in_array($_POST['kind'] ?? '', ['warn', 'mute', 'jail', 'ban'], true) ? $_POST['kind'] : 'warn';
      $q = $db->prepare('SELECT a.id FROM web_accounts a JOIN login_users l ON l.id=a.login_id WHERE l.username=?'); $q->execute([trim((string)($_POST['username'] ?? ''))]); $tid = (int)$q->fetchColumn();
      if (!$tid) { $flash = 'کاربری با این نام کاربری پیدا نشد (کاربر باید حداقل یک‌بار وارد سایت شده باشد).'; break; }
      $db->prepare('INSERT INTO web_punish(user_id,kind,reason,by_name,created) VALUES(?,?,?,?,?)')->execute([$tid, $kind, mb_substr(trim((string)($_POST['reason'] ?? '')), 0, 250), $u['fullname'], time()]);
      notify($tid, 'یک مورد جدید در سوابق پانیشمنت شما ثبت شد.', 'dashboard.php?p=logs&t=punish'); $ok = 'ثبت شد.'; break;
    }
  }
}

function ext_nav_icons(): array {
  return [
    'wallet' => '<rect x="3" y="6" width="18" height="14" rx="2"/><path d="M3 10h18M16 15h2"/>',
    'shop' => '<path d="M6 7h12l1 13H5L6 7Z"/><path d="M9 7a3 3 0 0 1 6 0"/>',
    'gallery' => '<rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="9" cy="11" r="2"/><path d="m21 16-5-5-8 8"/>',
    'srvlogs' => '<path d="M4 19.500A2.500 2.500 0 0 1 6.500 17H20"/><path d="M6.500 2H20v20H6.500A2.500 2.500 0 0 1 4 19.500v-15A2.500 2.500 0 0 1 6.500 2Z"/>',
    'shopadm' => '<path d="M3 9l1-5h16l1 5M5 9v11h14V9"/>',
    'galadm' => '<path d="M9 12l2 2 4-4"/><rect x="3" y="4" width="18" height="16" rx="2"/>',
  ];
}

function dash_tabs(string $base, array $tabs, string $cur): void {
  echo '<div class="seg">'; foreach ($tabs as $k => $l) echo '<button class="' . ($cur === $k ? 'on' : '') . '" onclick="location=\'dashboard.php?p=' . e($base) . '&t=' . e($k) . '\'">' . e($l) . '</button>'; echo '</div>';
}

function dash_ext_page(string $p, array $u, bool $admin): void {
  $db = db(); $uid = (int)$u['id']; $t = (string)($_GET['t'] ?? '');
  if (in_array($p, ['shopadm', 'galadm', 'srvlogs'], true) && !$admin) { echo '<div class="empty2">شما به این بخش دسترسی ندارید.</div>'; return; }

  /* ===== کیف پول ===== */
  if ($p === 'wallet') {
    $w = wallet_get($uid); [$bank, $tc] = game_money($u); $t = $t === 'convert' ? 'convert' : ($t === 'tx' ? 'tx' : 'bal'); ?>
    <h2>کیف پول</h2><p class="lead">شارژ کیف پول، تبدیل به توکن و مصرف موجودی در یک صفحه.</p>
    <div class="kpis">
      <div class="kpi"><b dir="ltr"><?= toman($w['toman']) ?></b><span>کیف پول (تومان)</span></div>
      <div class="kpi"><b><?= toman($w['tokens']) ?></b><span>توکن</span></div>
      <div class="kpi"><b dir="ltr"><?= toman($tc) ?></b><span>تایم کوین (TC)</span></div>
      <div class="kpi"><b dir="ltr">$<?= toman($bank) ?></b><span>پول بازی (بانک)</span></div>
    </div>
    <?php dash_tabs('wallet', ['bal' => 'موجودی و شارژ', 'convert' => 'تبدیل‌ها', 'tx' => 'تراکنش‌ها'], $t);
    if ($t === 'bal'): ?>
      <form method="post" class="dcardx" style="max-width:520px"><?= csrf_field() ?><input type="hidden" name="a" value="topup">
        <h3>افزایش موجودی</h3><p class="mut" style="margin-bottom:10px">مبلغ شارژ به کیف پول تومانی اضافه می‌شود. مبلغ شارژشده غیرقابل بازگشت است.</p>
        <label>مبلغ (تومان)<input name="amount" dir="ltr" inputmode="numeric" value="50000" required></label>
        <div class="row-actions" style="margin-bottom:12px"><?php foreach ([50000, 100000, 200000, 500000] as $x): ?><button type="button" class="btn" onclick="this.form.amount.value=<?= $x ?>"><?= toman($x) ?></button><?php endforeach; ?></div>
        <button class="btn pri">شارژ کیف پول</button></form>
      <?php $q = $db->prepare('SELECT * FROM web_topups WHERE user_id=? ORDER BY id DESC LIMIT 10'); $q->execute([$uid]); $tp = $q->fetchAll(); if ($tp): ?>
      <div class="dcardx"><h3>آخرین درخواست‌های شارژ</h3><table class="utable"><tr><th>#</th><th>مبلغ</th><th>وضعیت</th><th>تاریخ</th></tr>
      <?php foreach ($tp as $x): ?><tr><td><?= (int)$x['id'] ?></td><td><?= toman((int)$x['amount']) ?> تومان</td><td><span class="tag <?= $x['status'] === 'paid' ? 'accepted' : ($x['status'] === 'rejected' ? 'rejected' : 'pending') ?>"><?= ['paid' => 'پرداخت‌شده', 'rejected' => 'رد شد', 'pending' => 'در انتظار'][$x['status']] ?? e($x['status']) ?></span></td><td><?= date('Y/m/d H:i', (int)$x['created']) ?></td></tr><?php endforeach; ?></table></div><?php endif;
    elseif ($t === 'convert'): ?>
      <div class="cgrid">
        <form method="post" class="dcardx"><?= csrf_field() ?><input type="hidden" name="a" value="conv_toman_token"><h3>کیف پول ← توکن</h3><p class="mut">هر توکن = <?= toman(EXT['toman_per_token']) ?> تومان</p>
          <label>تعداد توکن<input type="number" name="n" min="1" max="1000" value="1" required></label><button class="btn pri">تبدیل</button></form>
        <form method="post" class="dcardx"><?= csrf_field() ?><input type="hidden" name="a" value="conv_token_money"><h3>توکن ← پول بازی</h3><p class="mut">هر توکن = $<?= toman(EXT['token_to_money']) ?> · نیازمند آفلاین بودن در بازی</p>
          <label>تعداد توکن<input type="number" name="n" min="1" max="1000" value="1" required></label><button class="btn pri">تبدیل</button></form>
        <form method="post" class="dcardx"><?= csrf_field() ?><input type="hidden" name="a" value="conv_money_token"><h3>پول بازی ← توکن</h3><p class="mut">$<?= toman(EXT['money_per_token']) ?> = ۱ توکن · نیازمند آفلاین بودن در بازی</p>
          <label>تعداد توکن<input type="number" name="n" min="1" max="1000" value="1" required></label><button class="btn pri">تبدیل</button></form>
      </div>
      <p class="hint">پول بازی و تایم‌کوین فقط زمانی تغییر می‌کنند که در بازی آفلاین باشید؛ در غیر این صورت سرور بازی هنگام ذخیره‌سازی مقدار آن‌ها را بازنویسی می‌کند.</p>
    <?php else: $q = $db->prepare('SELECT * FROM web_tx WHERE user_id=? ORDER BY id DESC LIMIT 60'); $q->execute([$uid]); $tx = $q->fetchAll(); ?>
      <div class="dcardx" style="overflow-x:auto"><table class="utable"><tr><th>نوع</th><th>شرح</th><th>مقدار</th><th>تاریخ</th></tr>
      <?php $K = ['topup' => 'شارژ', 'conv' => 'تبدیل', 'buy' => 'خرید', 'refund' => 'بازگشت']; foreach ($tx as $x): ?><tr><td><?= e($K[$x['kind']] ?? $x['kind']) ?></td><td><?= e($x['detail']) ?></td><td dir="ltr"><?= (int)$x['amount'] > 0 ? '+' : '' ?><?= toman((int)$x['amount']) ?></td><td><?= date('Y/m/d H:i', (int)$x['created']) ?></td></tr><?php endforeach; if (!$tx) echo '<tr><td colspan="4" class="mut">تراکنشی ثبت نشده.</td></tr>'; ?></table></div>
    <?php endif; return; }

  /* ===== لاگ‌ها ===== */
  if ($p === 'logs') {
    $t = in_array($t, ['play', 'buy', 'job', 'punish'], true) ? $t : 'play'; ?>
    <h2>لاگ‌ها</h2><p class="lead">سوابق حساب و کاراکتر شما.</p>
    <?php dash_tabs('logs', ['play' => 'سوابق بازی', 'buy' => 'تاریخچه خرید', 'job' => 'سوابق شغل', 'punish' => 'سوابق پانیشمنت'], $t);
    if ($t === 'play'): $rows = user_play_sessions((string)$u['username']); $A = AUDIT; ?>
      <div class="dcardx"><ul class="acts" style="margin:0"><?php foreach ($rows as $r): ?><li class="<?= $r['action'] === 'login_fail' ? 'bad' : '' ?>"><span><?= e($A[$r['action']] ?? $r['action']) ?></span><small><?= e(date('Y/m/d H:i', (int)strtotime((string)$r['created_at']))) ?></small></li><?php endforeach; if (!$rows) echo '<p class="mut">سابقه‌ای ثبت نشده.</p>'; ?></ul>
      <?php if ($u['game']): ?><p class="hint" style="margin-top:12px">مجموع ساعت بازی: <?= e(playdur((int)$u['game']['timePlay'])) ?></p><?php endif; ?></div>
    <?php elseif ($t === 'buy'): $rows = user_orders($uid); $M = ['money' => 'پول بازی', 'token' => 'توکن', 'tc' => 'تایم کوین']; ?>
      <div class="dcardx" style="overflow-x:auto"><table class="utable"><tr><th>آیتم</th><th>پرداخت</th><th>مبلغ</th><th>وضعیت</th><th>تاریخ</th></tr>
      <?php foreach ($rows as $r): ?><tr><td><?= e($r['item_name']) ?></td><td><?= e($M[$r['method']] ?? $r['method']) ?></td><td dir="ltr"><?= toman((int)$r['price']) ?></td><td><span class="tag <?= $r['status'] === 'delivered' ? 'accepted' : 'pending' ?>"><?= $r['status'] === 'delivered' ? 'تحویل شد' : 'در انتظار تحویل' ?></span></td><td><?= date('Y/m/d H:i', (int)$r['created']) ?></td></tr><?php endforeach; if (!$rows) echo '<tr><td colspan="5" class="mut">هنوز خریدی انجام نشده است.</td></tr>'; ?></table></div>
    <?php elseif ($t === 'job'): $rows = user_duty($u['game']); ?>
      <div class="dcardx" style="overflow-x:auto"><table class="utable"><tr><th>ارگان</th><th>شروع</th><th>پایان</th></tr>
      <?php foreach ($rows as $r): $st = $r['start_time'] ?? ($r['clock_in'] ?? ($r['created_at'] ?? '')); $en = $r['end_time'] ?? ($r['clock_out'] ?? ''); ?><tr><td><?= e(job_label((string)($r['job_name'] ?? ''))) ?></td><td><?= e((string)$st) ?></td><td><?= e((string)$en) ?: '—' ?></td></tr><?php endforeach; if (!$rows) echo '<tr><td colspan="3" class="mut">سابقه‌ی شغلی ثبت نشده.</td></tr>'; ?></table></div>
    <?php else: $rows = user_punish($uid); $K = ['warn' => 'اخطار', 'mute' => 'سکوت', 'jail' => 'زندان ادمینی', 'ban' => 'بن']; ?>
      <div class="dcardx"><ul class="acts" style="margin:0"><?php foreach ($rows as $r): ?><li class="bad"><span><?= e($K[$r['kind']] ?? $r['kind']) ?> — <?= e($r['reason']) ?></span><small><?= e($r['by_name']) ?> · <?= date('Y/m/d', (int)$r['created']) ?></small></li><?php endforeach; if (!$rows) echo '<p class="mut">سابقه‌ی پانیشمنتی ثبت نشده است.</p>'; ?></ul></div>
    <?php endif; return; }

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

  /* ===== مدیریت فروشگاه ===== */
  if ($p === 'shopadm') { ?>
    <h2>مدیریت فروشگاه</h2><p class="lead">افزودن آیتم و تایید شارژهای تومانی.</p>
    <form method="post" class="dcardx"><?= csrf_field() ?><input type="hidden" name="a" value="shopadm_save"><h3>آیتم جدید</h3>
      <div class="fgrid"><label>دسته<select name="cat"><?php foreach (SHOP_CATS as $k => $c): ?><option value="<?= $k ?>"><?= e($c['label']) ?></option><?php endforeach; ?></select></label>
      <label>زیردسته (کلید: male/female/tc/sport/…)<input name="sub" dir="ltr" placeholder="male"></label>
      <label>نام<input name="name" required></label><label>کد/اسپاون<input name="code" dir="ltr" placeholder="torso_m_450_17"></label>
      <label class="full">آدرس تصویر (اختیاری)<input name="image" dir="ltr" placeholder="https://..."></label>
      <label>قیمت پول بازی ($)<input name="pm" dir="ltr" value="0"></label><label>قیمت توکن<input name="pt" type="number" min="0" value="0"></label><label>قیمت TC<input name="ptc" type="number" min="0" value="0"></label></div>
      <button class="btn pri">افزودن</button></form>
    <?php $q = $db->query("SELECT t.*,a.fullname FROM web_topups t JOIN web_accounts a ON a.id=t.user_id WHERE t.status='pending' ORDER BY t.id DESC LIMIT 50"); $tp = $q->fetchAll(); ?>
    <div class="dcardx"><h3>شارژهای در انتظار (<?= count($tp) ?>)</h3><?php foreach ($tp as $x): ?><form method="post" class="row-actions" style="margin-bottom:8px"><?= csrf_field() ?><input type="hidden" name="a" value="topup_credit"><input type="hidden" name="id" value="<?= (int)$x['id'] ?>"><span style="flex:1">#<?= (int)$x['id'] ?> · <?= e($x['fullname']) ?> · <?= toman((int)$x['amount']) ?> تومان</span><button class="btn ok" name="d" value="ok">تایید پرداخت</button><button class="btn no" name="d" value="no">رد</button></form><?php endforeach; if (!$tp) echo '<p class="mut">موردی نیست.</p>'; ?></div>
    <div class="dcardx" style="overflow-x:auto"><h3>آیتم‌ها</h3><table class="utable"><tr><th>نام</th><th>دسته</th><th>$</th><th>توکن</th><th>TC</th><th></th></tr>
    <?php foreach ($db->query('SELECT * FROM web_shop_items ORDER BY id DESC LIMIT 200') as $i): ?><tr style="<?= $i['active'] ? '' : 'opacity:.5' ?>"><td><?= e($i['name']) ?></td><td><?= e(SHOP_CATS[$i['cat']]['label'] ?? $i['cat']) ?></td><td><?= toman((int)$i['price_money']) ?></td><td><?= (int)$i['price_token'] ?></td><td><?= (int)$i['price_tc'] ?></td>
      <td><form method="post" class="row-actions"><?= csrf_field() ?><input type="hidden" name="id" value="<?= (int)$i['id'] ?>"><button class="btn" name="a" value="shopadm_toggle"><?= $i['active'] ? 'مخفی' : 'نمایش' ?></button><button class="btn no" name="a" value="shopadm_del" onclick="return confirm('حذف شود؟')">حذف</button></form></td></tr><?php endforeach; ?></table></div>
    <?php return; }

  /* ===== مدیریت گالری ===== */
  if ($p === 'galadm') {
    $s = ($_GET['s'] ?? 'pending') === 'all' ? 'all' : 'pending';
    $rows = $db->query('SELECT g.*,a.fullname FROM web_gallery g JOIN web_accounts a ON a.id=g.user_id ' . ($s === 'pending' ? "WHERE g.status='pending' " : '') . 'ORDER BY g.id DESC LIMIT 60')->fetchAll(); ?>
    <h2>بررسی گالری</h2><p class="lead">تایید یا رد پست‌های ارسالی شهروندان.</p>
    <div class="seg"><button class="<?= $s === 'pending' ? 'on' : '' ?>" onclick="location='dashboard.php?p=galadm'">در انتظار</button><button class="<?= $s === 'all' ? 'on' : '' ?>" onclick="location='dashboard.php?p=galadm&s=all'">همه</button></div>
    <div class="cgrid"><?php foreach ($rows as $g): ?><div class="dcardx"><?= $g['kind'] === 'video' ? '<video src="uploads/' . e($g['file']) . '" controls preload="metadata" style="width:100%;border-radius:10px"></video>' : '<img src="uploads/' . e($g['file']) . '" alt="" style="width:100%;border-radius:10px">' ?>
      <p style="margin:8px 0"><b><?= e($g['fullname']) ?></b> <span class="tag <?= e($g['status']) ?>"><?= ['pending' => 'در انتظار', 'approved' => 'تایید شد', 'rejected' => 'رد شد'][$g['status']] ?? '' ?></span></p><p class="mut"><?= e($g['caption']) ?></p>
      <form method="post" class="row-actions"><?= csrf_field() ?><input type="hidden" name="a" value="galadm_decide"><input type="hidden" name="id" value="<?= (int)$g['id'] ?>"><input name="note" placeholder="دلیل رد (اختیاری)" style="flex:1;min-width:120px">
        <button class="btn ok" name="d" value="approve">تایید</button><button class="btn no" name="d" value="reject">رد</button><button class="btn" name="d" value="pin"><?= $g['pinned'] ? 'برداشتن برگزیده' : 'برگزیده' ?></button><button class="btn no" name="d" value="delete" onclick="return confirm('حذف شود؟')">حذف</button></form></div>
    <?php endforeach; if (!$rows) echo '<div class="empty2">موردی برای بررسی وجود ندارد.</div>'; ?></div>
    <?php return; }

  /* ===== لاگ سرور (ادمین) + ثبت پانیشمنت ===== */
  if ($p === 'srvlogs') {
    $lc = trim($_GET['c'] ?? ''); $lj = trim($_GET['j'] ?? ''); $lq = trim($_GET['q'] ?? ''); $logs = admin_logs($lc, $lj, $lq, 80); ?>
    <h2>لاگ‌های سرور</h2><p class="lead">لاگ‌های ثبت‌شده توسط ریسورس <code>logs</code> و ثبت پانیشمنت.</p>
    <form method="post" class="dcardx"><?= csrf_field() ?><input type="hidden" name="a" value="punish_add"><h3>ثبت پانیشمنت</h3>
      <div class="fgrid"><label>نام کاربری بازیکن<input name="username" dir="ltr" required></label><label>نوع<select name="kind"><option value="warn">اخطار</option><option value="mute">سکوت</option><option value="jail">زندان ادمینی</option><option value="ban">بن</option></select></label><label class="full">دلیل<input name="reason" maxlength="250" required></label></div><button class="btn pri">ثبت</button></form>
    <form method="get" class="dcardx" style="display:flex;gap:10px;flex-wrap:wrap"><input type="hidden" name="p" value="srvlogs">
      <select name="c" style="width:auto"><option value="">همه‌ی دسته‌ها</option><?php foreach (admin_log_categories() as $cat): ?><option value="<?= e($cat) ?>" <?= $lc === $cat ? 'selected' : '' ?>><?= e($cat) ?></option><?php endforeach; ?></select>
      <input name="q" value="<?= e($lq) ?>" placeholder="جستجو" style="flex:1;min-width:200px"><button class="btn pri">فیلتر</button></form>
    <div class="list"><?php foreach ($logs as $lg): ?><div class="row"><b><?= e($lg['title'] ?: $lg['category']) ?></b><small><?= e($lg['category']) ?><?= $lg['player_name'] ? ' · ' . e($lg['player_name']) : '' ?> · <?= e($lg['created_at']) ?></small><span class="mut" style="flex-basis:100%"><?= e(mb_substr((string)$lg['message'], 0, 200)) ?></span></div>
    <?php endforeach; if (!$logs) echo '<p class="mut">لاگی پیدا نشد.</p>'; ?></div>
    <?php return; }
}
