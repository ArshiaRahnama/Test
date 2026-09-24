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

  // بازه‌ای که یک بازیکن «آنلاین» حساب می‌شه (برحسب ثانیه) بر اساس آخرین last_seen ثبت‌شده در دیتابیس
  'online_window' => 300,

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
  if (!$my) {
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
      'staff' => $q('SELECT name,role FROM demo_staff ORDER BY id'),
    ];
  }

  // ----- دیتای واقعی سرور -----
  $win = (int)CFG['online_window'];
  $top = [];
  $top['سطح'] = array_map(fn($r) => [trim($r['firstname'] . ' ' . $r['lastname']) ?: $r['identifier'], 'Level ' . (int)$r['level']],
    $p->query("SELECT firstname,lastname,identifier,level FROM users ORDER BY level DESC LIMIT 8")->fetchAll());
  $top['ساعت بازی'] = array_map(fn($r) => [trim($r['firstname'] . ' ' . $r['lastname']) ?: $r['identifier'], number_format(intdiv((int)$r['playtime'], 60)) . ' ساعت'],
    $p->query("SELECT firstname,lastname,identifier,playtime FROM users ORDER BY playtime DESC LIMIT 8")->fetchAll());

  $gangs = array_map(fn($r) => [$r['name'], 'Level ' . (int)$r['level'], $r['disband'] ? 0 : 1],
    $p->query("SELECT name,level,disband FROM gangs WHERE name<>'nogang' ORDER BY level DESC LIMIT 8")->fetchAll());

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

  $roles = CFG['roles'];
  $staff = array_map(function ($r) use ($roles) {
    $name = trim($r['firstname'] . ' ' . $r['lastname']) ?: $r['identifier'];
    $role = $roles[$r['group']] ?? $r['group'];
    return [$name, $role];
  }, $p->query("SELECT firstname,lastname,identifier,`group` FROM users WHERE `group` NOT IN ('user','') ORDER BY level DESC LIMIT 8")->fetchAll());

  return [
    'citizens' => (int)$p->query('SELECT COUNT(*) FROM users')->fetchColumn(),
    'staffCount' => (int)$p->query("SELECT COUNT(*) FROM users WHERE `group` NOT IN ('user','')")->fetchColumn(),
    'gangCount' => (int)$p->query("SELECT COUNT(*) FROM gangs WHERE name<>'nogang'")->fetchColumn(),
    'top' => $top, 'gangs' => $gangs, 'depts' => $depts, 'staff' => $staff,
  ];
}

function e($s): string { return htmlspecialchars((string)$s, ENT_QUOTES, 'UTF-8'); }
function go(string $u): never { header("Location: $u"); exit; }
function csrf(): string { return $_SESSION['csrf'] ??= bin2hex(random_bytes(16)); }
function csrf_field(): string { return '<input type="hidden" name="csrf" value="' . csrf() . '">'; }
function csrf_check(): void { if (!hash_equals($_SESSION['csrf'] ?? '', $_POST['csrf'] ?? '')) { http_response_code(419); exit('نشست منقضی شده؛ صفحه را دوباره بارگذاری کن.'); } }
function me(): ?array {
  if (empty($_SESSION['uid'])) return null;
  $s = db()->prepare('SELECT * FROM web_accounts WHERE id=?'); $s->execute([$_SESSION['uid']]);
  return $s->fetch() ?: null;
}
function need_login(): array {
  if ($u = me()) return $u;
  $_SESSION['next'] = basename($_SERVER['SCRIPT_NAME']) . ($_SERVER['QUERY_STRING'] ? '?' . $_SERVER['QUERY_STRING'] : '');
  go('auth.php');
}
function digits(string $s): string { return preg_replace('/\D/', '', strtr($s, ['۰'=>'0','۱'=>'1','۲'=>'2','۳'=>'3','۴'=>'4','۵'=>'5','۶'=>'6','۷'=>'7','۸'=>'8','۹'=>'9'])); }
/** ساخت حساب — فقط از داشبورد ادمین یا اسکریپت create_account.php صدا زده می‌شه؛ ثبت‌نام عمومی وجود نداره. */
function make_account(string $phone, string $pass, string $name, string $gender = 'm', string $role = 'user'): int {
  $db = db(); $acc = random_int(100, 999) . '-' . random_int(100, 999);
  $db->prepare('INSERT INTO web_accounts(phone,pass,fullname,gender,acc,cid,role,created) VALUES(?,?,?,?,?,?,?,?)')
     ->execute([$phone, password_hash($pass, PASSWORD_DEFAULT), $name, $gender === 'f' ? 'مونث' : 'مذکر', $acc, '', $role === 'admin' ? 'admin' : 'user', time()]);
  $id = (int)$db->lastInsertId();
  $db->prepare('UPDATE web_accounts SET cid=? WHERE id=?')->execute([str_pad((string)$id, 8, '0', STR_PAD_LEFT), $id]);
  return $id;
}
/** فهرست اهداف قابل‌درخواست: گنگ‌های باز + همه‌ی ارگان‌ها */
function apply_targets(): array {
  $st = site_stats(); $o = ['gang' => [], 'org' => []];
  foreach ($st['gangs'] as $g) if ($g[2]) $o['gang'][] = $g[0];
  foreach (CFG['depts'] as $d) $o['org'][$d['group']][] = $d['label'];
  return $o;
}
