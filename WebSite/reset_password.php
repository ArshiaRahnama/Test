<?php
// فقط از ترمینال سرور (CLI): تعیین رمز جدید برای یک حساب بازی وقتی دسترسی‌ات رو از دست دادی.
//   php reset_password.php Arshia_Mtz "رمز-جدید1"
// رمز به همون قالب Unique_Login (SHA2 با salt تصادفی) ذخیره می‌شه، قفل امنیتی برداشته می‌شه و ورود خودکار دستگاه‌های قبلی لغو می‌شه.
// رمزی از قبل وجود نداره و ما چیزی رو «برنمی‌گردونیم»؛ فقط خودت یه رمز جدید می‌ذاری.
if (PHP_SAPI !== 'cli') { http_response_code(404); exit; }
require __DIR__ . '/lib.php';
[, $user, $pass] = $argv + [null, null, null];
if (!$user || strlen((string)$pass) < 6 || !preg_match('/\d/', $pass) || !preg_match('/[A-Za-z]/', $pass)) {
  fwrite(STDERR, "استفاده: php reset_password.php <username یا 09xxxxxxxxx> <رمز جدید: حداقل ۶ کاراکتر، حرف و عدد>\n"); exit(1);
}
$db = db(); $q = $db->prepare('SELECT id,username FROM login_users WHERE username=? OR phone=?'); $q->execute([$user, phone10($user) ?? '-']); $r = $q->fetch();
if (!$r) { fwrite(STDERR, "حسابی پیدا نشد.\n"); exit(1); }
$salt = bin2hex(random_bytes(16));
$db->prepare('UPDATE login_users SET password=?, password_salt=?, security_hold=0, device_license=NULL WHERE id=?')->execute([game_hash($pass, $salt), $salt, $r['id']]);
echo "رمز حساب {$r['username']} عوض شد. با همین نام کاربری و رمز جدید هم داخل بازی هم اینجا وارد شو.\n";
