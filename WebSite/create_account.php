<?php
// ساخت حساب از ترمینال (فقط CLI). مثال:
//   php create_account.php 09123456789 "رمز-قوی" "Arshia Rahnama" admin
//   php create_account.php 09120000000 "رمز-قوی" "Ali Rezaei" user f
if (PHP_SAPI !== 'cli') { http_response_code(404); exit; }
require __DIR__ . '/lib.php';
[, $phone, $pass, $name] = $argv + [null, null, null, null];
$role = $argv[4] ?? 'user'; $gender = $argv[5] ?? 'm';
$phone = digits((string)$phone);
if (!preg_match('/^09\d{9}$/', $phone) || strlen((string)$pass) < 6 || mb_strlen((string)$name) < 3) {
  fwrite(STDERR, "استفاده: php create_account.php 09xxxxxxxxx رمز(حداقل ۶) \"نام کامل\" [admin|user] [m|f]\n"); exit(1);
}
$s = db()->prepare('SELECT 1 FROM web_accounts WHERE phone=?'); $s->execute([$phone]);
if ($s->fetch()) { fwrite(STDERR, "این شماره قبلاً حساب دارد.\n"); exit(1); }
$id = make_account($phone, $pass, $name, $gender, $role);
echo "حساب ساخته شد: #$id  $phone  ($role)\n";
