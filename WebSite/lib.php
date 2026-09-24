<?php
declare(strict_types=1);
/* ===== تنظیمات ===== */
const CFG = [
  'name' => 'Unique RP', 'fa' => 'یونیک',
  'discord' => 'https://discord.gg/rwBHcCqzJB',

  // 'mysql' سایت رو به دیتابیس واقعی سرور (ESX/essentialmode) وصل می‌کنه.
  // اگه اتصال برقرار نشه، سایت خودکار روی دیتای دمو (sqlite) فال‌بک می‌کنه و از کار نمی‌افته.
  'driver' => 'mysql',
  'mysql' => [
    'host' => '127.0.0.1',        // آی‌پی/هاست دیتابیس سرورت
    'db'   => 'essentialmode',    // اسم دیتابیس ESX (طبق دامپ ریپو همینه؛ اگه فرق داره عوضش کن)
    'user' => 'root',             // یوزر دیتابیس
    'pass' => '',                 // پسورد دیتابیس
    'port' => 3306,
  ],

  // کد اتصال سرور (join code) روی cfx.re — مثلاً از لینک cfx.re/join/xxxxx همون xxxxx رو بذار.
  // اگه پر بشه، تعداد آنلاین واقعی سرور بالای هدر نمایش داده می‌شه.
  'cfxcode' => '',

  // بازه‌ای که یک بازیکن «آنلاین» حساب می‌شه (برحسب ثانیه) بر اساس آخرین last_seen ثبت‌شده در دیتابیس.
  // این عدد باید از Config.LastSeen.HeartbeatSeconds توی Unique_Login بزرگ‌تر باشه (وگرنه بازیکن‌های
  // واقعاً آنلاین بین دو تا heartbeat لحظه‌ای «آفلاین» نشون داده می‌شن)، ولی زیاد بزرگش هم نکن — هرچی
  // بزرگ‌تر باشه، بعد از قطع واقعی/کرش سرور بازی، بیشتر طول می‌کشه تا سایت واقعاً «آفلاین» نشونش بده.
  'online_window' => 150,

  // گروه‌بندی ارگان‌ها (سه دسته‌ی اصلی شهر)
  'org_groups' => [
    'doj'  => ['label' => 'Department Of Justice', 'fa' => 'وزارت دادگستری'],
    'law'  => ['label' => 'Law Enforcement',       'fa' => 'نیروی انتظامی'],
    'svc'  => ['label' => 'Organ Services',        'fa' => 'ارگان‌های خدماتی'],
  ],
  // ارگان‌ها: 'job' باید دقیقاً با ستون job جدول users (و جدول jobs) سرورت یکی باشه؛ فقط 'label' نمایشی‌ه.
  'depts' => [
    ['group' => 'doj', 'job' => 'cid',       'label' => 'CID'],
    ['group' => 'doj', 'job' => 'cia',       'label' => 'CIA'],
    ['group' => 'doj', 'job' => 'marshal',   'label' => 'Marshal'],
    ['group' => 'doj', 'job' => 'fbi',       'label' => 'FBI'],
    ['group' => 'doj', 'job' => 'judge',     'label' => 'Judge'],
    ['group' => 'doj', 'job' => 'doa',       'label' => 'DOA'],
    ['group' => 'law', 'job' => 'police',    'label' => 'Police'],
    ['group' => 'law', 'job' => 'sheriff',   'label' => 'Sheriff'],
    ['group' => 'law', 'job' => 'mt',        'label' => 'MT'],
    ['group' => 'svc', 'job' => 'taxi',      'label' => 'Taxi'],
    ['group' => 'svc', 'job' => 'mechanic',  'label' => 'Mechanic'],
    ['group' => 'svc', 'job' => 'ambulance', 'label' => 'Medic'],
    ['group' => 'svc', 'job' => 'weazel',    'label' => 'Weazel'],
  ],

  // نگاشت مقدار ستون group به عنوان فارسی نمایشی
  'roles' => ['superadmin' => 'مدیر ارشد', 'admin' => 'ادمین', 'moderator' => 'مدیر', 'mod' => 'مدیر', 'gm' => 'گیم مستر', 'owner' => 'مالک'],
  // رنک‌هایی که توی صفحه‌ی کادر نمایش داده می‌شن (permission_level جدول users؛ همون اسم‌های Config_Shared.Rank در Unique_AdminPanel).
  // سطحِ بین دو رنک به رنکِ پایین‌تر گرد می‌شه. هر کس با permission_level کمتر از team_min_perm توی صفحه‌ی کادر نمیاد.
  'team_min_perm' => 9,
  // حداقل permission_level برای دسترسی مدیریتی داشبورد (بررسی درخواست‌ها، تیکت‌ها، لیست حساب‌ها)
  'dash_admin_perm' => 9,
  'perm_ranks' => [9 => 'Moderator', 10 => 'Supervisor', 11 => 'Administrator', 16 => 'Manager', 17 => 'Owner', 100 => 'Developer'],
  // هر رنک یه بخش جدا توی صفحه‌ی کادر (از بالا به پایین)
  'perm_tiers' => [
    ['min' => 100, 'key' => 'dev',  'fa' => 'Developer',     'desc' => 'توسعه و زیرساخت شهر',            'color' => '#b48cff'],
    ['min' => 17,  'key' => 'own',  'fa' => 'Owner',         'desc' => 'مالکیت و تصمیم‌گیری نهایی',       'color' => '#ff6b6b'],
    ['min' => 16,  'key' => 'mgr',  'fa' => 'Manager',       'desc' => 'مدیریت کل تیم و سرور',           'color' => '#ff9f43'],
    ['min' => 11,  'key' => 'adm',  'fa' => 'Administrator', 'desc' => 'اداره‌ی امور اجرایی و ادمین‌ها', 'color' => '#ffc107'],
    ['min' => 10,  'key' => 'sup',  'fa' => 'Supervisor',    'desc' => 'نظارت بر عملکرد کادر',           'color' => '#7dd3fc'],
    ['min' => 9,   'key' => 'mod',  'fa' => 'Moderator',     'desc' => 'رسیدگی به گزارش‌ها و تخلفات',    'color' => '#3ddc84'],
  ],
];

session_set_cookie_params(['httponly' => true, 'samesite' => 'Lax']);
session_start();

/* ===== اتصال دیتابیس با فال‌بک امن ===== */
function db(): PDO {
  static $p = null; if ($p) return $p;
  if (CFG['driver'] === 'mysql') {
    try {
      $c = CFG['mysql'];
      $p = new PDO("mysql:host={$c['host']};port={$c['port']};dbname={$c['db']};charset=utf8mb4", $c['user'], $c['pass'], [
        PDO::ATTR_TIMEOUT => 3,
      ]);
      $p->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
      $p->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
      $GLOBALS['__live_db'] = true;
      site_install($p, true);
      return $p;
    } catch (Throwable $e) {
      // اتصال به سرور اصلی ناموفق بود؛ می‌ریم سراغ دیتای دمو تا سایت هیچ‌وقت خراب نشه
      error_log('[UniqueRP] mysql connect failed, falling back to demo db: ' . $e->getMessage());
    }
  }
  $d = __DIR__ . '/data';
  if (!is_dir($d)) { mkdir($d, 0750, true); file_put_contents("$d/.htaccess", "Require all denied\nDeny from all\n"); }
  $p = new PDO('sqlite:' . $d . '/unique.sqlite');
  $p->exec('PRAGMA foreign_keys=ON');
  $p->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  $p->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
  $GLOBALS['__live_db'] = false;
  site_install($p, false);
  return $p;
}

/** آیا الان واقعاً به دیتابیس سرور وصلیم یا داریم دمو نشون می‌دیم؟ */
function is_live(): bool { db(); return $GLOBALS['__live_db'] ?? false; }

/* ===== جداول اختصاصیِ خود وب‌سایت (لاگین سایت، تیکت‌ها) ===== */
function site_install(PDO $p, bool $my): void {
  $pk = $my ? 'INT AUTO_INCREMENT PRIMARY KEY' : 'INTEGER PRIMARY KEY AUTOINCREMENT';
  $t = $my ? 'VARCHAR(190)' : 'TEXT';
  $tail = $my ? ' ENGINE=InnoDB DEFAULT CHARSET=utf8mb4' : '';
  // جداول سایت با پیشوند web_ ساخته می‌شن تا با جداول اصلی سرور (users, gangs, ...) قاطی نشن
  $p->exec("CREATE TABLE IF NOT EXISTS web_accounts(id $pk, phone $t NOT NULL UNIQUE, pass $t NOT NULL, fullname $t NOT NULL, gender $t NOT NULL, level INT NOT NULL DEFAULT 1, acc $t NOT NULL, cid $t NOT NULL, role $t NOT NULL DEFAULT 'user', created INT NOT NULL)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS web_tickets(id $pk, user_id INT NOT NULL, subject $t NOT NULL, status $t NOT NULL, created INT NOT NULL)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS web_msgs(id $pk, ticket_id INT NOT NULL, user_id INT NOT NULL, body TEXT NOT NULL, created INT NOT NULL)$tail");
  // درخواست‌های عضویت (گنگ / ارگان) که از داشبورد ثبت می‌شن
  $p->exec("CREATE TABLE IF NOT EXISTS web_apps(id $pk, user_id INT NOT NULL, kind $t NOT NULL, target $t NOT NULL, body TEXT NOT NULL, status $t NOT NULL, note TEXT, created INT NOT NULL, updated INT NOT NULL)$tail");
  // اتصال پروفایلِ سایت به حساب بازی (login_users.id)
  try { $p->exec('ALTER TABLE web_accounts ADD COLUMN login_id INT NULL'); } catch (Throwable $e) { /* ستون از قبل هست */ }
  $p->exec("CREATE TABLE IF NOT EXISTS web_rate(k $t NOT NULL PRIMARY KEY, cnt INT NOT NULL, ws INT NOT NULL)$tail");
  if (!$my) {
    // در سرور واقعی این جدول رو ریسورس Unique_Login (sql/install.sql) می‌سازه؛ اینجا فقط برای حالت دمو خالی ساخته می‌شه (هیچ حساب پیش‌فرضی وجود نداره)
    $p->exec("CREATE TABLE IF NOT EXISTS login_users(id $pk, username TEXT NOT NULL UNIQUE, password TEXT NOT NULL, password_salt TEXT NOT NULL DEFAULT '', phone TEXT UNIQUE, license TEXT NOT NULL UNIQUE, device_license TEXT, security_hold INT NOT NULL DEFAULT 0, created_at TEXT DEFAULT CURRENT_TIMESTAMP)");
    // این‌ها فقط برای حالت دمو (وقتی به دیتابیس واقعی سرور وصل نیستیم) لازمن
    $p->exec("CREATE TABLE IF NOT EXISTS demo_top(id $pk, cat $t NOT NULL, name $t NOT NULL, val $t NOT NULL)");
    $p->exec("CREATE TABLE IF NOT EXISTS demo_gangs(id $pk, name $t NOT NULL, lvl INT NOT NULL, open INT NOT NULL)");
    $p->exec("CREATE TABLE IF NOT EXISTS demo_depts(id $pk, name $t NOT NULL, online INT NOT NULL, total INT NOT NULL, duty INT NOT NULL)");
    $p->exec("CREATE TABLE IF NOT EXISTS demo_staff(id $pk, name $t NOT NULL, role $t NOT NULL)");
    if ((int)$p->query('SELECT COUNT(*) FROM demo_staff')->fetchColumn() > 0) return;
    $ins = fn($sql, $rows) => array_map(fn($r) => $p->prepare($sql)->execute($r), $rows);
    $ins('INSERT INTO demo_top(cat,name,val) VALUES(?,?,?)', [
      ['سطح','Surena Gh','Level 50'],['سطح','Richard Miller','Level 50'],['سطح','Kenshin Himura','Level 50'],['سطح','Amir Mn','Level 50'],['سطح','Nima Ahmadi','Level 50'],
      ['ساعت بازی','Reza Neo','412 ساعت'],['ساعت بازی','Homy Baba','390 ساعت'],['ساعت بازی','Mahla Majidi','356 ساعت'],['ساعت بازی','Yousef Azimi','331 ساعت'],['ساعت بازی','Moon Child','320 ساعت']]);
    $ins('INSERT INTO demo_gangs(name,lvl,open) VALUES(?,?,?)', [['Ballas',19,1],['North_Kids',20,1],['SAVAGE',20,0],['Khalifa',21,1],['GroveStreet',26,0],['Vision',18,0]]);
    $ins('INSERT INTO demo_depts(name,online,total,duty) VALUES(?,?,?,?)', [['Police Department',5,83,1],['Medical Center',3,84,1],['Mechanic Central',2,25,1],['Taxi Department',0,48,0]]);
    $ins('INSERT INTO demo_staff(name,role) VALUES(?,?)', [['Mohammad','Game Master'],['Ahmad','Game Master'],['Hamid','Game Master'],['Payam','Manager']]);
  }
}

/* ===== آمار سایت: در حالت live از جداول واقعی سرور می‌خونه، وگرنه از دمو ===== */
function site_stats(): array {
  $p = db();
  if (!is_live()) {
    $q = fn($s) => $p->query($s)->fetchAll(PDO::FETCH_NUM);
    $top = [];
    foreach ($q('SELECT cat,name,val FROM demo_top ORDER BY id') as [$c, $n, $v]) $top[$c][] = [$n, $v];
    return [
      'citizens' => (int)$p->query('SELECT COUNT(*) FROM web_accounts')->fetchColumn(),
      'staffCount' => (int)$p->query('SELECT COUNT(*) FROM demo_staff')->fetchColumn(),
      'gangCount' => (int)$p->query('SELECT COUNT(*) FROM demo_gangs')->fetchColumn(),
      'top' => $top,
      'gangs' => array_map(fn($r) => [$r[0], 'Level ' . $r[1], (int)$r[2]], $q('SELECT name,lvl,open FROM demo_gangs ORDER BY id')),
      'depts' => array_map(function ($d) {   // اعداد دمو: ثابت و بر پایه‌ی اسم ارگان
        $h = crc32($d['label']); $tot = 12 + $h % 70; $on = $h % 6;
        return [$d['label'], $on, $tot, $on > 0 ? 1 : 0, $d['group']];
      }, CFG['depts']),
      'staff' => array_map(function ($r) { $perm = ['Manager' => 16, 'Game Master' => 9][$r[1]] ?? 9; return [$r[0], rank_label($perm), $perm, (int)(crc32($r[0]) % 2)]; }, $q('SELECT name,role FROM demo_staff ORDER BY id')),
    ];
  }

  // ----- دیتای واقعی سرور -----
  $win = (int)CFG['online_window'];
  $top = [];
  // اسمِ داخل‌بازی = playerName؛ سطح واقعی = `rank` (+ xp)؛ ساعت بازی = timePlay (ثانیه) — همون‌هایی که Unique_LevelQuest و esx_idoverhead می‌نویسن.
  $top = ['سطح' => [], 'ساعت بازی' => []];
  $cols = 'playerName,name,firstname,lastname,`rank`,xp,timePlay';
  foreach ($p->query("SELECT $cols FROM users ORDER BY `rank` DESC, xp DESC LIMIT 40")->fetchAll() as $r)
    if (($n = pname($r)) !== '' && count($top['سطح']) < 8) $top['سطح'][] = [$n, 'Level ' . max(1, (int)$r['rank'])];
  foreach ($p->query("SELECT $cols FROM users ORDER BY timePlay DESC LIMIT 40")->fetchAll() as $r)
    if (($n = pname($r)) !== '' && count($top['ساعت بازی']) < 8) $top['ساعت بازی'][] = [$n, number_format(intdiv((int)$r['timePlay'], 3600)) . ' ساعت'];

  try { $gr = $p->query("SELECT name,label,level,disband FROM gangs WHERE name<>'nogang' ORDER BY level DESC LIMIT 8")->fetchAll(); }
  catch (Throwable $e) { $gr = $p->query("SELECT name,name AS label,level,disband FROM gangs WHERE name<>'nogang' ORDER BY level DESC LIMIT 8")->fetchAll(); }
  $gangs = array_map(fn($r) => [trim((string)$r['label']) ?: $r['name'], 'Level ' . (int)$r['level'], $r['disband'] ? 0 : 1], $gr);

  $depts = []; $jobs = array_column(CFG['depts'], 'job'); $by = [];
  if ($jobs) {
    $in = implode(',', array_fill(0, count($jobs), '?'));
    $s = $p->prepare("SELECT job, COUNT(*) total, SUM(CASE WHEN last_seen >= (NOW() - INTERVAL {$win} SECOND) THEN 1 ELSE 0 END) online FROM users WHERE job IN ($in) GROUP BY job");
    $s->execute($jobs);
    foreach ($s->fetchAll() as $r) $by[$r['job']] = $r;
  }
  foreach (CFG['depts'] as $d) {
    $r = $by[$d['job']] ?? []; $on = (int)($r['online'] ?? 0);
    $depts[] = [$d['label'], $on, (int)($r['total'] ?? 0), $on > 0 ? 1 : 0, $d['group']];
  }

  // کادر: هر کسی که permission_level بالای صفر داره (همون ستونی که essentialmode و پنل ادمین می‌خونن)
  // اسمِ داخل‌بازی (playerName، مثل Arshia_Mtz)؛ اگه خالی بود name و بعد اسم و فامیل. هرگز identifier/license نمایش داده نمی‌شه.
  $staff = [];
  $sq = $p->prepare("SELECT playerName,name,firstname,lastname,permission_level, (last_seen >= (NOW() - INTERVAL {$win} SECOND)) AS online FROM users WHERE permission_level >= ? ORDER BY permission_level DESC, `rank` DESC LIMIT 120");
  $sq->execute([(int)CFG['team_min_perm']]);
  foreach ($sq->fetchAll() as $r) {
    $nm = pname($r);
    if ($nm === '') continue;
    $perm = (int)$r['permission_level'];
    $staff[] = [$nm, rank_label($perm), $perm, (int)$r['online']];
  }

  return [
    'citizens' => (int)$p->query('SELECT COUNT(*) FROM users')->fetchColumn(),
    'staffCount' => count($staff),
    'gangCount' => (int)$p->query("SELECT COUNT(*) FROM gangs WHERE name<>'nogang'")->fetchColumn(),
    'top' => $top, 'gangs' => $gangs, 'depts' => $depts, 'staff' => $staff,
  ];
}

function e($s): string { return htmlspecialchars((string)$s, ENT_QUOTES, 'UTF-8'); }
function go(string $u): never { header("Location: $u"); exit; }
function csrf(): string { return $_SESSION['csrf'] ??= bin2hex(random_bytes(16)); }
function csrf_field(): string { return '<input type="hidden" name="csrf" value="' . csrf() . '">'; }
function csrf_check(): void { $t = $_SESSION['csrf'] ?? ''; if ($t === '' || !hash_equals($t, (string)($_POST['csrf'] ?? ''))) { http_response_code(419); exit('نشست منقضی شده؛ صفحه را دوباره بارگذاری کن.'); } }
/* ===== ورود یکپارچه با حساب بازی (Unique_Login) ===== */
function game_hash(string $pw, string $salt): string { return hash('sha256', $pw . $salt); }   // همون SHA2(CONCAT(password, salt), 256) ریسورس
/** شماره‌ی موبایل ایرانی => فرم ۱۰ رقمی بدون صفر (مثل داخل بازی)؛ نامعتبر => null */
function phone10(string $raw): ?string {
  $d = digits($raw);
  if (str_starts_with($d, '98') && strlen($d) === 12) $d = substr($d, 2);
  if (str_starts_with($d, '0')) $d = substr($d, 1);
  return preg_match('/^9\d{9}$/', $d) ? $d : null;
}
/** شمارنده‌ی نرخ: rate_full = آیا سقف پر شده؟ (فقط می‌خونه) — rate_hit = یک بار می‌شمره */
function rate_full(string $key, int $max, int $win): bool {
  $s = db()->prepare('SELECT cnt,ws FROM web_rate WHERE k=?'); $s->execute([sha1($key)]); $r = $s->fetch();
  return $r && time() - (int)$r['ws'] < $win && (int)$r['cnt'] >= $max;
}
function rate_hit(string $key, int $win): void {
  $db = db(); $k = sha1($key); $now = time();
  $s = $db->prepare('SELECT ws FROM web_rate WHERE k=?'); $s->execute([$k]); $r = $s->fetch();
  if (!$r || $now - (int)$r['ws'] >= $win) { $db->prepare('DELETE FROM web_rate WHERE k=?')->execute([$k]); $db->prepare('INSERT INTO web_rate(k,cnt,ws) VALUES(?,1,?)')->execute([$k, $now]); }
  else $db->prepare('UPDATE web_rate SET cnt=cnt+1 WHERE k=?')->execute([$k]);
}
/** ورود با نام کاربری یا شماره‌ی حساب بازی. موفق => ردیف login_users؛ ناموفق => null و پیام در $err */
function game_login(string $ident, string $pass, ?string &$err = null): ?array {
  $ip = $_SERVER['REMOTE_ADDR'] ?? '0'; $ident = trim($ident);
  if ($ident === '' || $pass === '') { $err = 'نام کاربری و رمز عبور را وارد کن.'; return null; }
  if (rate_full('lf-user:' . strtolower($ident), 5, 900) || rate_full("lf-ip:$ip", 20, 900)) { $err = 'به‌خاطر تلاش‌های ناموفق زیاد، ورود موقتاً قفل شده؛ ۱۵ دقیقه بعد دوباره امتحان کن.'; return null; }
  $db = db(); $u = null;
  try {
    $q = $db->prepare('SELECT * FROM login_users WHERE username=? LIMIT 1'); $q->execute([$ident]); $u = $q->fetch() ?: null;
    if (!$u && ($ph = phone10($ident))) { $q = $db->prepare('SELECT * FROM login_users WHERE phone=? LIMIT 1'); $q->execute([$ph]); $u = $q->fetch() ?: null; }
  } catch (Throwable $e) { error_log('[UniqueRP] login_users lookup failed: ' . $e->getMessage()); $err = 'ورود موقتاً در دسترس نیست.'; return null; }
  if (!$u || !hash_equals((string)$u['password'], game_hash($pass, (string)$u['password_salt']))) {
    rate_hit('lf-user:' . strtolower($ident), 900); rate_hit("lf-ip:$ip", 900); usleep(500000);
    $err = 'نام کاربری/شماره یا رمز عبور اشتباه است. (حساب فقط داخل بازی ساخته می‌شه.)'; return null;
  }
  if ((int)$u['security_hold'] === 1) { $err = 'این حساب به‌خاطر فعالیت مشکوک قفل امنیتی داره؛ داخل بازی از «فراموشی رمز عبور» استفاده کن.'; return null; }
  return $u;
}
/** پروفایل کاراکتر از جدول users (وصل‌شده با device_license = license واقعی فایواِم). بدون کاراکتر => null */
function game_profile(array $lu): ?array {
  if (empty($lu['device_license'])) return null;
  try {
    // BUG FIX: «آنلاین/آخرین حضور» رو با TIMESTAMPDIFF خودِ MySQL می‌سنجیم، نه با
    // strtotime()+time() سمت PHP — چون last_seen با NOW()ِ MySQL نوشته می‌شه؛ اگه ساعت
    // سرور PHP با ساعت سرور MySQL یکی نباشه (خیلی رایجه، مخصوصاً روی هاست/داکر جدا)،
    // مقایسه‌ی سمت PHP می‌تونست بازیکن رو دقیقه‌ها (یا حتی بعد از قطع/کرش کامل سرور بازی)
    // اشتباهاً «آنلاین» نشون بده. این‌جوری همه‌چی رو خودِ MySQL، با ساعت خودش، حساب می‌کنه —
    // دقیقاً همون روشی که site_stats() برای دپارتمان‌ها و کادر مدیریت همیشه استفاده می‌کرده.
    $q = db()->prepare('SELECT playerName,name,firstname,lastname,sex,`rank`,xp,permission_level,job,job_grade,gang,gang_grade,money,bank,timePlay,last_seen,TIMESTAMPDIFF(SECOND,last_seen,NOW()) AS seen_secs_ago,account_num,iban FROM users WHERE identifier=? OR license=? LIMIT 1');
    $q->execute([$lu['device_license'], $lu['device_license']]); return $q->fetch() ?: null;
  } catch (Throwable $e) { return null; }
}
/** پروفایل سایت (web_accounts) رو به حساب بازی وصل می‌کنه؛ اگه نبود می‌سازه. تیکت/درخواست‌های قدیمی با همون شماره حفظ می‌شن. */
function sync_web_account(array $lu, string $display): int {
  $db = db(); $ph = $lu['phone'] ? '0' . $lu['phone'] : 'lu' . $lu['id'];
  $q = $db->prepare('SELECT id FROM web_accounts WHERE login_id=?'); $q->execute([$lu['id']]); $id = (int)$q->fetchColumn();
  if (!$id) { $q = $db->prepare('SELECT id FROM web_accounts WHERE phone=? AND login_id IS NULL'); $q->execute([$ph]); $id = (int)$q->fetchColumn();
    if ($id) $db->prepare('UPDATE web_accounts SET login_id=? WHERE id=?')->execute([$lu['id'], $id]); }
  if (!$id) {
    $db->prepare('INSERT INTO web_accounts(phone,pass,fullname,gender,acc,cid,role,created,login_id) VALUES(?,?,?,?,?,?,?,?,?)')
       ->execute([$ph, password_hash(bin2hex(random_bytes(16)), PASSWORD_DEFAULT), $display, 'مذکر', random_int(100, 999) . '-' . random_int(100, 999), '', 'user', time(), $lu['id']]);
    $id = (int)$db->lastInsertId();
    $db->prepare('UPDATE web_accounts SET cid=? WHERE id=?')->execute([str_pad((string)$id, 8, '0', STR_PAD_LEFT), $id]);
  }
  return $id;
}
function display_name(array $lu, ?array $g): string {
  if ($g && ($n = pname($g)) !== '') return $n;
  return (string)$lu['username'];
}
function me(): ?array {
  static $cache = null; if ($cache !== null) return $cache ?: null;
  if (empty($_SESSION['uid']) || empty($_SESSION['lid'])) return null;
  $db = db();
  $q = $db->prepare('SELECT * FROM login_users WHERE id=?'); $q->execute([$_SESSION['lid']]); $lu = $q->fetch();
  $q = $db->prepare('SELECT * FROM web_accounts WHERE id=? AND login_id=?'); $q->execute([$_SESSION['uid'], $_SESSION['lid']]); $w = $q->fetch();
  if (!$lu || !$w || (int)$lu['security_hold'] === 1) { $cache = false; return null; }
  $g = game_profile($lu); $perm = $g ? (int)$g['permission_level'] : 0;
  $role = $perm >= (int)CFG['dash_admin_perm'] ? 'admin' : 'user';
  $name = display_name($lu, $g); $gender = $g && $g['sex'] === 'f' ? 'مونث' : 'مذکر';
  if ($w['role'] !== $role || $w['fullname'] !== $name || $w['gender'] !== $gender)
    $db->prepare('UPDATE web_accounts SET role=?,fullname=?,gender=? WHERE id=?')->execute([$role, $name, $gender, $w['id']]);
  $win = (int)CFG['online_window'];
  $secsAgo = ($g && $g['last_seen'] && $g['seen_secs_ago'] !== null) ? max(0, (int)$g['seen_secs_ago']) : null;
  $seen = $g && $g['last_seen'] ? strtotime((string)$g['last_seen']) : 0; // فقط برای نمایش/سازگاری قدیمی؛ برای آنلاین‌بودن دیگه استفاده نمی‌شه
  return $cache = array_merge($w, ['role' => $role, 'fullname' => $name, 'gender' => $gender, 'username' => $lu['username'], 'lid' => (int)$lu['id'], 'perm' => $perm,
    'rank' => $perm >= (int)CFG['team_min_perm'] ? rank_label($perm) : ($perm > 0 ? 'Staff' : null), 'game' => $g, 'online' => $secsAgo !== null && $secsAgo < $win,
    'seen' => $seen, 'seenSecsAgo' => $secsAgo,
    'level' => $g ? max(1, (int)$g['rank']) : 1]);
}
function need_login(): array {
  if ($u = me()) return $u;
  $_SESSION['next'] = basename($_SERVER['SCRIPT_NAME']) . ($_SERVER['QUERY_STRING'] ? '?' . $_SERVER['QUERY_STRING'] : '');
  go('auth.php');
}
function digits(string $s): string { return preg_replace('/\D/', '', strtr($s, ['۰'=>'0','۱'=>'1','۲'=>'2','۳'=>'3','۴'=>'4','۵'=>'5','۶'=>'6','۷'=>'7','۸'=>'8','۹'=>'9'])); }
/** فهرست اهداف قابل‌درخواست: گنگ‌های باز + همه‌ی ارگان‌ها */
function apply_targets(): array {
  $st = site_stats(); $o = ['gang' => [], 'org' => []];
  foreach ($st['gangs'] as $g) if ($g[2]) $o['gang'][] = $g[0];
  foreach (CFG['depts'] as $d) $o['org'][$d['group']][] = $d['label'];
  return $o;
}

/** اسم داخل‌بازی: playerName، بعد name، بعد اسم+فامیل. خالی => '' (هرگز license/identifier نمایش داده نمی‌شه) */
function pname(array $r): string {
  return trim((string)($r['playerName'] ?? '')) ?: trim((string)($r['name'] ?? '')) ?: trim(trim((string)($r['firstname'] ?? '')) . ' ' . trim((string)($r['lastname'] ?? '')));
}

/** لیبل درجه‌ی شغلی (job_grades.label)؛ مثلاً job='judge', grade=1 => 'Judge Officer 1'. اگه پیدا نشه، خودِ عدد درجه برمی‌گرده. */
function job_grade_label(string $job, int $grade): string {
  static $cache = [];
  $key = $job . '#' . $grade;
  if (array_key_exists($key, $cache)) return $cache[$key];
  try {
    $q = db()->prepare('SELECT label FROM job_grades WHERE job_name=? AND grade=? LIMIT 1');
    $q->execute([$job, $grade]);
    $label = (string)($q->fetchColumn() ?: '');
  } catch (Throwable $e) { $label = ''; }
  return $cache[$key] = ($label !== '' ? $label : (string)$grade);
}
/** لیبل نمایشی گنگ (gangs.label)؛ اگه پیدا نشه یا 'nogang' باشه، خودِ مقدار خام برمی‌گرده. */
function gang_label(string $gang): string {
  static $cache = [];
  if ($gang === '' || $gang === 'none' || $gang === 'nogang') return '';
  if (array_key_exists($gang, $cache)) return $cache[$gang];
  try {
    $q = db()->prepare('SELECT label FROM gangs WHERE name=? LIMIT 1');
    $q->execute([$gang]);
    $label = (string)($q->fetchColumn() ?: '');
  } catch (Throwable $e) { $label = ''; }
  return $cache[$gang] = ($label !== '' ? $label : $gang);
}

/* ===== رنک و دسته‌ی کادر بر اساس permission_level ===== */
function rank_label(int $perm): string {
  $best = ''; foreach (CFG['perm_ranks'] as $lv => $name) if ($lv <= $perm) $best = $name;
  return $best ?: 'Staff';
}
function tier_of(int $perm): array {
  foreach (CFG['perm_tiers'] as $t) if ($perm >= $t['min']) return $t;
  $all = CFG['perm_tiers']; return end($all);
}
