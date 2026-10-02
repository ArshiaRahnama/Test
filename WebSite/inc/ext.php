<?php
/* ماژول توسعه‌ی سایت: کیف پول، فروشگاه، گالری، تایید دو مرحله‌ای، کد یکبارمصرف، کپچا، دستگاه‌ها */

/* ===== کلیدهای فعال/غیرفعال‌سازی بخش‌ها =====
   فعلاً خاموش‌اند تا بعداً به‌صورت آپدیت بیان. برای روشن کردن هر بخش، مقدارش رو true کن. */
const FEATURES = [
  'join'    => false,   // صفحه‌ی «عضوگیری و دپارتمان»
  'gallery' => false,   // گالری (عمومی + بررسی ادمین)
  'wallet'  => false,   // کیف پول و تبدیل‌ها (+ شارژهای مدیریت فروشگاه)
  'shop'    => false,   // فروشگاه (+ مدیریت فروشگاه)
  'logs'    => false,   // لاگ‌های کاربر (سوابق بازی/خرید/شغل/پانیشمنت)
  'captcha' => false,   // «من ربات نیستم» در صفحه‌ی ورود
  // --- بخش‌های داشبورد ---
  'review'   => false,  // بررسی درخواست‌ها (ادمین)
  'users'    => false,  // حساب‌های بازی (ادمین)
  'growth'   => false,  // رشد سایت (ادمین)
  'apps'     => false,  // درخواست‌های من
  'notif'    => false,  // اعلان‌ها
  'apply'    => false,  // ثبت درخواست عضویت
  'org'      => false,  // پنل ارگان من
  'gang'     => false,  // پنل گنگ من
  'billing'  => false,  // صورت‌حساب من
  'garage'   => false,  // گاراژ من
  'citizens' => false,  // جستجوی شهروندان
  'property' => false,  // املاک من
];

const SHOP_CATS = [
  'vehicle'   => ['label' => 'وسایل نقلیه', 'subs' => ['tc' => 'فقط تی سی', 'tctoken' => 'تی سی یا توکن', 'special' => 'اختصاصی', 'sea' => 'دریایی', 'hatch' => 'هاچ بک', 'moto' => 'موتورسیکلت', 'offroad' => 'آفرود', 'sport' => 'اسپرت', 'classic' => 'اسپرت کلاسیک', 'super' => 'سوپر', 'van' => 'ون', 'coupe' => 'کوپه', 'muscle' => 'عضلانی', 'compact' => 'شاسی کوتاه', 'suv' => 'شاسی‌بلند', 'plane' => 'هواپیما', 'heli' => 'بالگرد']],
  'pet'       => ['label' => 'حیوان خانگی', 'subs' => []],
  'clothes'   => ['label' => 'لباس', 'subs' => ['male' => 'مردانه', 'female' => 'زنانه']],
  'character' => ['label' => 'کرکتر', 'subs' => ['male' => 'مردانه', 'female' => 'زنانه']],
  'gang'      => ['label' => 'اقلام گنگ', 'subs' => []],
  'glasses'   => ['label' => 'عینک', 'subs' => ['male' => 'مردانه', 'female' => 'زنانه']],
  'special'   => ['label' => 'وسایل ویژه', 'subs' => []],
  'weapon'    => ['label' => 'ماکت سلاح', 'subs' => []],
  'simcard'   => ['label' => 'سیمکارت', 'subs' => []],
];
const TICKET_CATS = ['support' => 'پشتیبانی عمومی', 'report' => 'گزارش بازیکن', 'review' => 'تجدیدنظر / بازبینی', 'shop' => 'فروشگاه و کیف پول', 'bug' => 'باگ', 'other' => 'سایر'];
const GAL_RULES = ['فقط تصاویر و ویدیوهای مربوط به شهر ارسال کنید.', 'عکس‌ها باید ادیت شده باشند و حداقل کیفیت لازم را داشته باشند.', 'تصاویری که با هدف کل‌کل، کری‌خوانی یا تحقیر بازیکنان و گنگ‌های دیگر ارسال شوند تایید نمی‌شوند.', 'محتوای خارج از عرف، توهین‌آمیز یا دارای اطلاعات شخصی رد می‌شود.', 'هر ارسال ابتدا توسط تیم مدیریت بررسی و سپس منتشر می‌شود.', 'پست‌هایی که لایک زیادی بگیرند خودکار به بخش برگزیده‌ها می‌روند.'];

/* ---------- جداول ---------- */
function ext_install(PDO $p, bool $my): void {
  $pk = $my ? 'INT AUTO_INCREMENT PRIMARY KEY' : 'INTEGER PRIMARY KEY AUTOINCREMENT';
  $t = $my ? 'VARCHAR(190)' : 'TEXT'; $tail = $my ? ' ENGINE=InnoDB DEFAULT CHARSET=utf8mb4' : '';
  $p->exec("CREATE TABLE IF NOT EXISTS web_wallet(user_id INT NOT NULL PRIMARY KEY, toman BIGINT NOT NULL DEFAULT 0, tokens INT NOT NULL DEFAULT 0)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS web_tx(id $pk, user_id INT NOT NULL, kind $t NOT NULL, detail $t, amount BIGINT NOT NULL DEFAULT 0, created INT NOT NULL)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS web_shop_items(id $pk, cat $t NOT NULL, sub $t, name $t NOT NULL, code $t, image TEXT, price_money BIGINT NOT NULL DEFAULT 0, price_token INT NOT NULL DEFAULT 0, price_tc INT NOT NULL DEFAULT 0, active INT NOT NULL DEFAULT 1, created INT NOT NULL)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS web_orders(id $pk, user_id INT NOT NULL, item_id INT NOT NULL, item_name $t NOT NULL, item_code $t, method $t NOT NULL, price BIGINT NOT NULL, status $t NOT NULL DEFAULT 'pending', created INT NOT NULL, delivered INT NULL)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS web_favs(user_id INT NOT NULL, item_id INT NOT NULL, PRIMARY KEY(user_id,item_id))$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS web_topups(id $pk, user_id INT NOT NULL, amount BIGINT NOT NULL, status $t NOT NULL DEFAULT 'pending', ref $t, created INT NOT NULL)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS web_gallery(id $pk, user_id INT NOT NULL, kind $t NOT NULL, file $t NOT NULL, caption $t, status $t NOT NULL DEFAULT 'pending', pinned INT NOT NULL DEFAULT 0, note $t, created INT NOT NULL)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS web_likes(user_id INT NOT NULL, post_id INT NOT NULL, PRIMARY KEY(user_id,post_id))$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS web_totp(user_id INT NOT NULL PRIMARY KEY, secret $t NOT NULL, enabled INT NOT NULL DEFAULT 0)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS web_devices(id $pk, user_id INT NOT NULL, token_hash $t NOT NULL, ua $t, ip $t, created INT NOT NULL, last INT NOT NULL)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS web_login_codes(code_hash $t NOT NULL PRIMARY KEY, login_id INT NOT NULL, expires INT NOT NULL)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS web_punish(id $pk, user_id INT NOT NULL, kind $t NOT NULL, reason $t, by_name $t, created INT NOT NULL)$tail");
  try { $p->exec("ALTER TABLE web_tickets ADD COLUMN category $t NULL"); } catch (Throwable $e) {}
}

/* ---------- کیف پول ---------- */
function wallet_get(int $uid): array {
  $db = db(); $q = $db->prepare('SELECT toman,tokens FROM web_wallet WHERE user_id=?'); $q->execute([$uid]); $r = $q->fetch();
  if (!$r) { $db->prepare('INSERT INTO web_wallet(user_id,toman,tokens) VALUES(?,0,0)')->execute([$uid]); $r = ['toman' => 0, 'tokens' => 0]; }
  return ['toman' => (int)$r['toman'], 'tokens' => (int)$r['tokens']];
}
/** تغییر اتمیک موجودی؛ اگه موجودی کافی نباشه false. */
function wallet_add(int $uid, string $field, int $delta, string $kind, string $detail = ''): bool {
  if (!in_array($field, ['toman', 'tokens'], true)) return false;
  wallet_get($uid); $db = db();
  $s = $db->prepare("UPDATE web_wallet SET $field=$field+? WHERE user_id=?" . ($delta < 0 ? " AND $field>=?" : ''));
  $s->execute($delta < 0 ? [$delta, $uid, -$delta] : [$delta, $uid]);
  if (!$s->rowCount()) return false;
  $db->prepare('INSERT INTO web_tx(user_id,kind,detail,amount,created) VALUES(?,?,?,?,?)')->execute([$uid, $kind, $detail, $delta, time()]);
  return true;
}
function game_money(array $u): array {   // [bank, timecoin]
  $g = $u['game']; if (!$g) return [0, 0];
  $tc = 0; try { $q = db()->prepare('SELECT `' . preg_replace('/\W/', '', EXT['tc_column']) . '` FROM users WHERE identifier=?'); $q->execute([$g['identifier']]); $tc = (int)$q->fetchColumn(); } catch (Throwable $e) {}
  return [(int)$g['bank'], $tc];
}
/** تغییر پول بازی/تایم‌کوین فقط وقتی بازیکن آفلاینه (وگرنه سرور بازی موقع سیو روش می‌نویسه). */
function game_adjust(array $u, string $col, int $delta): bool {
  if (!$u['game'] || $u['online']) return false;
  $col = $col === 'tc' ? preg_replace('/\W/', '', EXT['tc_column']) : 'bank';
  try {
    $s = db()->prepare("UPDATE users SET `$col`=`$col`+? WHERE identifier=?" . ($delta < 0 ? " AND `$col`>=?" : ''));
    $s->execute($delta < 0 ? [$delta, $u['game']['identifier'], -$delta] : [$delta, $u['game']['identifier']]);
    return $s->rowCount() > 0;
  } catch (Throwable $e) { return false; }
}
const EXT = ['tc_column' => 'timecoin', 'toman_per_token' => 50000, 'token_to_money' => 500000, 'money_per_token' => 2000000, 'gal_featured_likes' => 5];
function toman(int $n): string { return number_format($n); }

/* ---------- TOTP (Authenticator) ---------- */
function b32enc(string $b): string { $a = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'; $bits = ''; foreach (str_split($b) as $c) $bits .= str_pad(decbin(ord($c)), 8, '0', STR_PAD_LEFT); $o = ''; foreach (str_split($bits, 5) as $ch) $o .= $a[bindec(str_pad($ch, 5, '0'))]; return $o; }
function b32dec(string $s): string { $a = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'; $bits = ''; foreach (str_split(strtoupper($s)) as $c) { $i = strpos($a, $c); if ($i !== false) $bits .= str_pad(decbin($i), 5, '0', STR_PAD_LEFT); } $o = ''; foreach (str_split($bits, 8) as $by) if (strlen($by) === 8) $o .= chr(bindec($by)); return $o; }
function totp_at(string $secret, int $ts): string {
  $h = hash_hmac('sha1', pack('N*', 0, intdiv($ts, 30)), b32dec($secret), true); $o = ord($h[19]) & 15;
  $v = ((ord($h[$o]) & 0x7f) << 24) | (ord($h[$o + 1]) << 16) | (ord($h[$o + 2]) << 8) | ord($h[$o + 3]);
  return str_pad((string)($v % 1000000), 6, '0', STR_PAD_LEFT);
}
function totp_check(string $secret, string $code): bool {
  $code = preg_replace('/\D/', '', $code); if (strlen($code) !== 6) return false;
  foreach ([-1, 0, 1] as $w) if (hash_equals(totp_at($secret, time() + $w * 30), $code)) return true;
  return false;
}
function totp_row(int $uid): ?array { $q = db()->prepare('SELECT * FROM web_totp WHERE user_id=?'); $q->execute([$uid]); return $q->fetch() ?: null; }
function totp_enabled(int $uid): bool { $r = totp_row($uid); return $r && (int)$r['enabled'] === 1; }

/* ---------- کد یکبارمصرف /getcode ---------- */
function code_issue(int $loginId): string {
  $db = db(); $db->prepare('DELETE FROM web_login_codes WHERE expires<? OR login_id=?')->execute([time(), $loginId]);
  $code = str_pad((string)random_int(0, 999999), 6, '0', STR_PAD_LEFT);
  $db->prepare('INSERT INTO web_login_codes(code_hash,login_id,expires) VALUES(?,?,?)')->execute([hash('sha256', $code), $loginId, time() + 180]);
  return $code;
}
function code_consume(string $code): ?array {
  $code = preg_replace('/\D/', '', $code); if (strlen($code) !== 6) return null;
  $db = db(); $h = hash('sha256', $code);
  $q = $db->prepare('SELECT login_id FROM web_login_codes WHERE code_hash=? AND expires>=?'); $q->execute([$h, time()]); $lid = $q->fetchColumn();
  if (!$lid) return null;
  $db->prepare('DELETE FROM web_login_codes WHERE code_hash=?')->execute([$h]);
  $q = $db->prepare('SELECT * FROM login_users WHERE id=?'); $q->execute([$lid]); $u = $q->fetch();
  return $u && (int)$u['security_hold'] !== 1 ? $u : null;
}

/* ---------- کپچا (داخلی؛ بدون سرویس خارجی) ---------- */
function captcha_new(): string { $a = random_int(2, 9); $b = random_int(2, 9); $_SESSION['cap'] = [$a + $b, time()]; return "$a + $b"; }
function captcha_ok(string $ans): bool {
  if (!FEATURES['captcha']) return true;
  $c = $_SESSION['cap'] ?? null; unset($_SESSION['cap']);
  return $c && time() - $c[1] >= 2 && time() - $c[1] < 600 && (int)digits($ans) === (int)$c[0];
}

/* ---------- دستگاه‌ها و پایان ورود ---------- */
function dev_register(int $uid): void {
  $tok = bin2hex(random_bytes(16)); $_SESSION['dev'] = $tok; $now = time();
  db()->prepare('INSERT INTO web_devices(user_id,token_hash,ua,ip,created,last) VALUES(?,?,?,?,?,?)')->execute([$uid, hash('sha256', $tok), mb_substr((string)($_SERVER['HTTP_USER_AGENT'] ?? ''), 0, 180), $_SERVER['REMOTE_ADDR'] ?? '', $now, $now]);
}
function dev_valid(): bool {
  if (empty($_SESSION['dev'])) return true;   // نشست‌های قدیمی
  try { $q = db()->prepare('SELECT id,last FROM web_devices WHERE token_hash=?'); $q->execute([hash('sha256', $_SESSION['dev'])]); $r = $q->fetch();
    if ($r && time() - (int)$r['last'] > 300) db()->prepare('UPDATE web_devices SET last=? WHERE id=?')->execute([time(), $r['id']]);
    return (bool)$r; } catch (Throwable $e) { return true; }
}
function login_finish(array $lu): void {
  session_regenerate_id(true);
  $g = game_profile($lu); $uid = sync_web_account($lu, display_name($lu, $g));
  $_SESSION['uid'] = $uid; $_SESSION['lid'] = (int)$lu['id']; unset($_SESSION['pre']);
  dev_register($uid);
}
function ua_label(string $ua): string {
  $b = preg_match('/Edg/i', $ua) ? 'Edge' : (preg_match('/OPR|Opera/i', $ua) ? 'Opera' : (preg_match('/Chrome/i', $ua) ? 'Chrome' : (preg_match('/Firefox/i', $ua) ? 'Firefox' : (preg_match('/Safari/i', $ua) ? 'Safari' : 'مرورگر'))));
  $o = preg_match('/Windows/i', $ua) ? 'Windows' : (preg_match('/Android/i', $ua) ? 'Android' : (preg_match('/iPhone|iPad/i', $ua) ? 'iOS' : (preg_match('/Mac/i', $ua) ? 'macOS' : (preg_match('/Linux/i', $ua) ? 'Linux' : ''))));
  return trim("$b $o");
}

/* ---------- فروشگاه ---------- */
function shop_items(string $cat, string $sub, string $q, string $sort, int $uid): array {
  $w = ['active=1']; $a = [];
  if ($cat !== '') { $w[] = 'cat=?'; $a[] = $cat; }
  if ($sub !== '') { $w[] = 'sub=?'; $a[] = $sub; }
  if ($q !== '') { $w[] = '(name LIKE ? OR code LIKE ?)'; $l = '%' . addcslashes($q, '%_\\') . '%'; array_push($a, $l, $l); }
  $ord = ['cheap' => 'price_money ASC, id DESC', 'new' => 'id DESC', 'dear' => 'price_money DESC, id DESC'][$sort] ?? 'price_money DESC, id DESC';
  $s = db()->prepare('SELECT i.*, (SELECT COUNT(*) FROM web_favs f WHERE f.item_id=i.id AND f.user_id=' . (int)$uid . ') AS fav FROM web_shop_items i WHERE ' . implode(' AND ', $w) . " ORDER BY $ord LIMIT 200");
  $s->execute($a); return $s->fetchAll();
}
/** خرید: method = money|token|tc. خروجی [ok, پیام] */
function shop_buy(array $u, int $itemId, string $method): array {
  $db = db(); $q = $db->prepare('SELECT * FROM web_shop_items WHERE id=? AND active=1'); $q->execute([$itemId]); $it = $q->fetch();
  if (!$it) return [false, 'این آیتم موجود نیست.'];
  $price = (int)$it['price_' . ($method === 'money' ? 'money' : ($method === 'tc' ? 'tc' : 'token'))];
  if (!in_array($method, ['money', 'token', 'tc'], true) || $price <= 0) return [false, 'این روش پرداخت برای این آیتم فعال نیست.'];
  if (!$u['game']) return [false, 'برای خرید، ابتدا باید حداقل یک‌بار وارد بازی شده باشید.'];
  $uid = (int)$u['id'];
  if ($method === 'token') { if (!wallet_add($uid, 'tokens', -$price, 'buy', $it['name'])) return [false, 'موجودی توکن کافی نیست.']; }
  else {
    if ($u['online']) return [false, 'برای پرداخت با پول بازی یا تایم‌کوین، باید در بازی آفلاین باشید.'];
    if (!game_adjust($u, $method, -$price)) return [false, 'موجودی کافی نیست.'];
    $db->prepare('INSERT INTO web_tx(user_id,kind,detail,amount,created) VALUES(?,?,?,?,?)')->execute([$uid, 'buy', $it['name'] . " ($method)", -$price, time()]);
  }
  $db->prepare('INSERT INTO web_orders(user_id,item_id,item_name,item_code,method,price,status,created) VALUES(?,?,?,?,?,?,?,?)')->execute([$uid, $it['id'], $it['name'], $it['code'], $method, $price, 'pending', time()]);
  return [true, 'خرید با موفقیت انجام شد؛ آیتم به‌زودی در بازی تحویل داده می‌شود.'];
}

/* ---------- گالری ---------- */
function gallery_save(int $uid, array $f, string $caption): array {
  if (empty($f['tmp_name']) || $f['error'] !== UPLOAD_ERR_OK) return [false, 'فایلی ارسال نشد.'];
  $mime = function_exists('finfo_open') ? finfo_file(finfo_open(FILEINFO_MIME_TYPE), $f['tmp_name']) : mime_content_type($f['tmp_name']);
  $img = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp']; $vid = ['video/mp4' => 'mp4', 'video/webm' => 'webm'];
  if (isset($img[$mime])) { $kind = 'photo'; $ext = $img[$mime]; $max = 8 << 20; }
  elseif (isset($vid[$mime])) { $kind = 'video'; $ext = $vid[$mime]; $max = 60 << 20; }
  else return [false, 'فرمت مجاز نیست (JPG/PNG/WEBP یا MP4/WEBM).'];
  if ($f['size'] > $max) return [false, 'حجم فایل بیش از حد مجاز است (عکس ۸MB، ویدیو ۶۰MB).'];
  $q = db()->prepare("SELECT COUNT(*) FROM web_gallery WHERE user_id=? AND status='pending'"); $q->execute([$uid]);
  if ((int)$q->fetchColumn() >= 5) return [false, 'حداکثر ۵ پست در انتظار بررسی مجاز است.'];
  $dir = __DIR__ . '/../uploads'; if (!is_dir($dir)) { mkdir($dir, 0755, true); file_put_contents("$dir/.htaccess", "php_flag engine off\nRemoveHandler .php\n<FilesMatch \"\\.(php|phtml|phar)$\">\nRequire all denied\n</FilesMatch>\nOptions -Indexes\n"); }
  $name = bin2hex(random_bytes(12)) . ".$ext";
  if (!move_uploaded_file($f['tmp_name'], "$dir/$name")) return [false, 'ذخیره‌سازی فایل ناموفق بود.'];
  db()->prepare('INSERT INTO web_gallery(user_id,kind,file,caption,status,created) VALUES(?,?,?,?,?,?)')->execute([$uid, $kind, $name, mb_substr(trim($caption), 0, 140), 'pending', time()]);
  return [true, 'ارسال شد؛ پس از تایید مدیریت منتشر خواهد شد.'];
}
function gallery_list(string $kind, string $sort, int $uid, bool $featured = false, int $limit = 60): array {
  $w = ["g.status='approved'"]; $a = [];
  if ($kind === 'photo' || $kind === 'video') { $w[] = 'g.kind=?'; $a[] = $kind; }
  if ($featured) { $w[] = '(g.pinned=1 OR (SELECT COUNT(*) FROM web_likes l WHERE l.post_id=g.id)>=' . (int)EXT['gal_featured_likes'] . ')'; }
  $ord = $sort === 'top' || $featured ? 'likes DESC, g.id DESC' : 'g.id DESC';
  $s = db()->prepare('SELECT g.*, a.fullname, (SELECT COUNT(*) FROM web_likes l WHERE l.post_id=g.id) AS likes, (SELECT COUNT(*) FROM web_likes l WHERE l.post_id=g.id AND l.user_id=' . (int)$uid . ') AS liked FROM web_gallery g JOIN web_accounts a ON a.id=g.user_id WHERE ' . implode(' AND ', $w) . " ORDER BY $ord LIMIT $limit");
  $s->execute($a); return $s->fetchAll();
}

/* ---------- لاگ‌های کاربر ---------- */
function user_play_sessions(string $username, int $n = 40): array {
  try { $q = db()->prepare("SELECT action,created_at FROM login_audit WHERE username=? AND action IN ('login_success','new_device','login_fail') ORDER BY created_at DESC LIMIT $n"); $q->execute([$username]); return $q->fetchAll(); } catch (Throwable $e) { return []; }
}
function user_orders(int $uid, int $n = 60): array { $q = db()->prepare("SELECT * FROM web_orders WHERE user_id=? ORDER BY id DESC LIMIT $n"); $q->execute([$uid]); return $q->fetchAll(); }
function user_duty(?array $g, int $n = 40): array { if (!$g) return []; try { $q = db()->prepare("SELECT * FROM duty_logs WHERE steamhex=? ORDER BY id DESC LIMIT $n"); $q->execute([$g['identifier']]); return $q->fetchAll(); } catch (Throwable $e) { return []; } }
function user_punish(int $uid, int $n = 40): array { $q = db()->prepare("SELECT * FROM web_punish WHERE user_id=? ORDER BY id DESC LIMIT $n"); $q->execute([$uid]); return $q->fetchAll(); }
