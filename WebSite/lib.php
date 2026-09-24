<?php
declare(strict_types=1);
/* ===== تنظیمات ===== */
const CFG = [
  'name' => 'Unique RP', 'fa' => 'یونیک',
  'discord' => 'https://discord.gg/rwBHcCqzJB',
  'driver' => 'sqlite',                       // 'sqlite' (بدون نیاز به تنظیم) یا 'mysql'
  'mysql' => ['host' => '127.0.0.1', 'db' => 'unique_web', 'user' => 'root', 'pass' => ''],
];

session_set_cookie_params(['httponly' => true, 'samesite' => 'Lax']);
session_start();

function db(): PDO {
  static $p = null; if ($p) return $p;
  $my = CFG['driver'] === 'mysql';
  if ($my) {
    $c = CFG['mysql'];
    $x = new PDO("mysql:host={$c['host']};charset=utf8mb4", $c['user'], $c['pass']);
    $x->exec("CREATE DATABASE IF NOT EXISTS `{$c['db']}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
    $p = new PDO("mysql:host={$c['host']};dbname={$c['db']};charset=utf8mb4", $c['user'], $c['pass']);
  } else {
    $d = __DIR__ . '/data';
    if (!is_dir($d)) { mkdir($d, 0750, true); file_put_contents("$d/.htaccess", "Require all denied\nDeny from all\n"); }
    $p = new PDO('sqlite:' . $d . '/unique.sqlite');
    $p->exec('PRAGMA foreign_keys=ON');
  }
  $p->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
  $p->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
  install($p, $my);
  return $p;
}

function install(PDO $p, bool $my): void {
  $pk = $my ? 'INT AUTO_INCREMENT PRIMARY KEY' : 'INTEGER PRIMARY KEY AUTOINCREMENT';
  $t = $my ? 'VARCHAR(190)' : 'TEXT';
  $tail = $my ? ' ENGINE=InnoDB DEFAULT CHARSET=utf8mb4' : '';
  $p->exec("CREATE TABLE IF NOT EXISTS users(id $pk, phone $t NOT NULL UNIQUE, pass $t NOT NULL, fullname $t NOT NULL, gender $t NOT NULL, level INT NOT NULL DEFAULT 1, acc $t NOT NULL, cid $t NOT NULL, role $t NOT NULL DEFAULT 'user', created INT NOT NULL)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS tickets(id $pk, user_id INT NOT NULL, subject $t NOT NULL, status $t NOT NULL, created INT NOT NULL)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS msgs(id $pk, ticket_id INT NOT NULL, user_id INT NOT NULL, body TEXT NOT NULL, created INT NOT NULL)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS top(id $pk, cat $t NOT NULL, name $t NOT NULL, val $t NOT NULL)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS gangs(id $pk, name $t NOT NULL, lvl INT NOT NULL, open INT NOT NULL)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS depts(id $pk, name $t NOT NULL, online INT NOT NULL, total INT NOT NULL, duty INT NOT NULL)$tail");
  $p->exec("CREATE TABLE IF NOT EXISTS staff(id $pk, name $t NOT NULL, role $t NOT NULL)$tail");
  if ((int)$p->query('SELECT COUNT(*) FROM staff')->fetchColumn() > 0) return;
  $ins = fn($sql, $rows) => array_map(fn($r) => $p->prepare($sql)->execute($r), $rows);
  $ins('INSERT INTO top(cat,name,val) VALUES(?,?,?)', [
    ['لول','Surena Gh','Level 50'],['لول','Richard Miller','Level 50'],['لول','Kenshin Himura','Level 50'],['لول','Amir Mn','Level 50'],['لول','Nima Ahmadi','Level 50'],
    ['تایم پلی','Reza Neo','412 ساعت'],['تایم پلی','Homy Baba','390 ساعت'],['تایم پلی','Mahla Majidi','356 ساعت'],['تایم پلی','Yousef Azimi','331 ساعت'],['تایم پلی','Moon Child','320 ساعت'],
    ['استریمر','Javad Malek','58 ساعت پخش'],['استریمر','Hadeir Marshall','51 ساعت پخش'],['استریمر','Delarose Lumi','44 ساعت پخش'],['استریمر','Kourosh Prime','39 ساعت پخش'],['استریمر','General Amir','30 ساعت پخش']]);
  $ins('INSERT INTO gangs(name,lvl,open) VALUES(?,?,?)', [['Ballas',19,1],['North_Kids',20,1],['SAVAGE',20,0],['Khalifa',21,1],['GroveStreet',26,0],['Vision',18,0]]);
  $ins('INSERT INTO depts(name,online,total,duty) VALUES(?,?,?,?)', [['Police Department',5,83,1],['Sheriff Department',1,57,1],['Special Forces',1,44,1],['Medical Center',3,84,1],['Mechanic Central',2,25,1],['Justice',0,28,0],['Taxi Department',0,48,0],['Weazel News',0,7,0]]);
  $ins('INSERT INTO staff(name,role) VALUES(?,?)', [['Mohammad','Game Master'],['Ahmad','Game Master'],['Hamid','Game Master'],['Payam','Game Master'],['Mehrdad','Manager'],['Maxmat','Manager']]);
}

function e($s): string { return htmlspecialchars((string)$s, ENT_QUOTES, 'UTF-8'); }
function go(string $u): never { header("Location: $u"); exit; }
function csrf(): string { return $_SESSION['csrf'] ??= bin2hex(random_bytes(16)); }
function csrf_field(): string { return '<input type="hidden" name="csrf" value="' . csrf() . '">'; }
function csrf_check(): void { if (!hash_equals($_SESSION['csrf'] ?? '', $_POST['csrf'] ?? '')) { http_response_code(419); exit('نشست منقضی شده؛ صفحه را دوباره بارگذاری کن.'); } }
function me(): ?array {
  if (empty($_SESSION['uid'])) return null;
  $s = db()->prepare('SELECT * FROM users WHERE id=?'); $s->execute([$_SESSION['uid']]);
  return $s->fetch() ?: null;
}
function need_login(): array { return me() ?? go('auth.php'); }
