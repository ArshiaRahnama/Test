<?php
require __DIR__ . '/lib.php';
$u = need_login();

// BUG FIX: صفحه فقط یه‌بار موقع لود سرور-ساید رندر می‌شه، برای همین اگه بازیکن بعد از
// باز موندن تب آفلاین بشه (یا کل سرور بازی کرش کنه)، بج «آنلاین/آخرین حضور» بدون رفرش
// دستی صفحه هیچ‌وقت خودش به‌روز نمی‌شد. این یه اندپوینت سبک JSON اضافه می‌کنه که جاوااسکریپت
// پایین صفحه هر ۲۰ ثانیه صداش می‌زنه و فقط همین دوتا مقدار رو، بدون رفرش کامل، آپدیت می‌کنه.
if (($_GET['ajax'] ?? '') === 'status') {
  header('Content-Type: application/json; charset=utf-8');
  echo json_encode(['online' => (bool)$u['online'], 'seenText' => $u['online'] ? 'الان' : ($u['seenSecsAgo'] !== null ? ago_secs($u['seenSecsAgo']) : '—')], JSON_UNESCAPED_UNICODE);
  exit;
}

$db = db(); $p = $_GET['p'] ?? 'home'; $flash = ''; $ok = '';
$admin = $u['role'] === 'admin';

// گنگ/ارگان کاراکترِ همین کاربر + رتبه‌ش + این‌که رتبه‌ش «باس» حساب می‌شه یا نه (bossaction گنگ / perm_employee_management ارگان)
$myGang = ($u['game'] && !empty($u['game']['gang']) && !in_array($u['game']['gang'], ['none', 'nogang'], true)) ? (string)$u['game']['gang'] : null;
$myOrg  = ($u['game'] && !empty($u['game']['job']) && $u['game']['job'] !== 'unemployed') ? (string)$u['game']['job'] : null;
$gangGrades = $myGang ? gang_grades_of($myGang) : [];
$myGangGrade = null; foreach ($gangGrades as $gr) if ((int)$gr['grade'] === (int)($u['game']['gang_grade'] ?? -1)) { $myGangGrade = $gr; break; }
$isGangBoss = (bool)($myGangGrade['access']['bossaction'] ?? false);
$jobGrades = $myOrg ? job_grades_of($myOrg) : [];
$myJobGrade = null; foreach ($jobGrades as $gr) if ((int)$gr['grade'] === (int)($u['game']['job_grade'] ?? -1)) { $myJobGrade = $gr; break; }
$isOrgBoss = (bool)($myJobGrade['perm_employee_management'] ?? false);
$myOrgGroup = $myOrg ? dept_group($myOrg) : null;
$isLawOrg = in_array($myOrgGroup, ['doj', 'law'], true);   // فقط این گروه‌ها به پرونده‌های DOJ/Law دسترسی دارن

if (!$admin && in_array($p, ['review', 'users', 'logs', 'growth'], true)) $p = 'home';
if (!$myGang && $p === 'gang') $p = 'home';
if (!$myOrg && $p === 'org') $p = 'home';

const APP_ST = ['pending' => 'در انتظار بررسی', 'accepted' => 'پذیرفته شد', 'rejected' => 'رد شد', 'cancelled' => 'لغو شده'];
function ticket_of(int $id, array $u): ?array {
  $s = db()->prepare('SELECT * FROM web_tickets WHERE id=?'); $s->execute([$id]); $t = $s->fetch();
  if (!$t) return null;
  if ($t['user_id'] == $u['id'] || $u['role'] === 'admin') return $t;
  // باسِ گنگ همه‌ی تیکت‌های همون گنگ رو می‌بینه؛ باسِ ارگان همه‌ی تیکت‌های همون ارگان رو
  global $isGangBoss, $myGang, $isOrgBoss, $myOrg;
  if (!empty($t['gang']) && $isGangBoss && $t['gang'] === $myGang) return $t;
  if (!empty($t['org_job']) && $isOrgBoss && $t['org_job'] === $myOrg) return $t;
  return null;
}
function add_msg(int $tid, int $uid, string $b): void {
  db()->prepare('INSERT INTO web_msgs(ticket_id,user_id,body,created) VALUES(?,?,?,?)')->execute([$tid, $uid, mb_substr($b, 0, 2000), time()]);
}
function org_group(string $label): string {
  foreach (CFG['depts'] as $d) if ($d['label'] === $label) return CFG['org_groups'][$d['group']]['label'];
  return '';
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  csrf_check(); $a = $_POST['a'] ?? '';
  if ($a === 'new') {
    $s = trim($_POST['subject'] ?? ''); $b = trim($_POST['body'] ?? '');
    // scope: ''=تیکت پشتیبانی معمولی، 'gang'=تیکت داخلی گنگ (فقط باسِ همون گنگ می‌بینه)، 'org'=تیکت داخلی ارگان
    $scope = $_POST['scope'] ?? '';
    $gangCol = ($scope === 'gang' && $myGang) ? $myGang : null;
    $orgCol  = ($scope === 'org' && $myOrg) ? $myOrg : null;
    $backP = $gangCol ? 'gang' : ($orgCol ? 'org' : 'tickets');
    if ($s === '' || $b === '' || mb_strlen($s) > 120) { $flash = 'موضوع و متن را کامل بنویس.'; $p = $backP; }
    else {
      $db->prepare('INSERT INTO web_tickets(user_id,subject,status,created,gang,org_job) VALUES(?,?,?,?,?,?)')->execute([$u['id'], $s, 'open', time(), $gangCol, $orgCol]);
      $id = (int)$db->lastInsertId(); add_msg($id, $u['id'], $b); go("dashboard.php?p=ticket&id=$id");
    }
  } elseif ($a === 'reply' || $a === 'close') {
    $id = (int)($_POST['id'] ?? 0); $t = ticket_of($id, $u);
    if ($t) {
      if ($a === 'close') $db->prepare("UPDATE web_tickets SET status='closed' WHERE id=?")->execute([$id]);
      elseif (trim($_POST['body'] ?? '') !== '' && $t['status'] !== 'closed') {
        add_msg($id, $u['id'], trim($_POST['body']));
        $isStaffReply = ($admin || $isGangBoss || $isOrgBoss) && $t['user_id'] != $u['id'];
        $db->prepare('UPDATE web_tickets SET status=? WHERE id=?')->execute([$isStaffReply ? 'answered' : 'open', $id]);
      }
      go("dashboard.php?p=ticket&id=$id");
    }
  } elseif ($a === 'gset' && $isGangBoss) {                      // باسِ گنگ رتبه‌ی یه عضو رو تغییر می‌ده
    $ident = (string)($_POST['ident'] ?? ''); $grade = (int)($_POST['grade'] ?? -1);
    $myIdent = (string)($u['game']['identifier'] ?? ''); $target = null;
    foreach (gang_members($myGang) as $m) if ((string)$m['identifier'] === $ident) { $target = $m; break; }
    $validGrade = null; foreach ($gangGrades as $gr) if ((int)$gr['grade'] === $grade) { $validGrade = $gr; break; }
    $p = 'gang'; $_GET['t'] = 'members';
    if (!$target || $ident === $myIdent) $flash = 'این عمل روی این کاربر مجاز نیست.';
    elseif (!$validGrade || $grade > (int)$myGangGrade['grade']) $flash = 'رتبه‌ی انتخابی نامعتبره یا از رتبه‌ی خودت بالاتره.';
    elseif ((int)$target['gang_grade'] >= (int)$myGangGrade['grade']) $flash = 'نمی‌تونی روی هم‌رتبه یا بالادستِ خودت این کارو انجام بدی.';
    else {
      $db->prepare('UPDATE users SET gang_grade=? WHERE identifier=? AND gang=?')->execute([$grade, $ident, $myGang]); $ok = 'رتبه‌ی عضو گنگ به‌روزرسانی شد.';
      $tName = pname($target); audit_log('gang', $myGang, 'تغییر رتبه', $u['fullname'], $tName, "رتبه‌ی جدید: " . ($validGrade['label'] ?: $validGrade['name']));
      if ($accId = web_account_id_of_identifier($ident)) notify($accId, "رتبه‌ی تو تو گنگ به «" . ($validGrade['label'] ?: $validGrade['name']) . "» تغییر کرد.", 'dashboard.php?p=gang');
    }
  } elseif ($a === 'gkick' && $isGangBoss) {                      // باسِ گنگ یه عضو رو اخراج می‌کنه
    $ident = (string)($_POST['ident'] ?? ''); $myIdent = (string)($u['game']['identifier'] ?? ''); $target = null;
    foreach (gang_members($myGang) as $m) if ((string)$m['identifier'] === $ident) { $target = $m; break; }
    $p = 'gang'; $_GET['t'] = 'members';
    if (!$target || $ident === $myIdent) $flash = 'این عمل روی این کاربر مجاز نیست.';
    elseif ((int)$target['gang_grade'] >= (int)$myGangGrade['grade']) $flash = 'نمی‌تونی هم‌رتبه یا بالادستِ خودت رو اخراج کنی.';
    else {
      $db->prepare("UPDATE users SET gang='nogang', gang_grade=0 WHERE identifier=? AND gang=?")->execute([$ident, $myGang]); $ok = 'عضو از گنگ اخراج شد.';
      $tName = pname($target); audit_log('gang', $myGang, 'اخراج عضو', $u['fullname'], $tName);
      if ($accId = web_account_id_of_identifier($ident)) notify($accId, 'از گنگ اخراج شدی.', 'dashboard.php');
    }
  } elseif ($a === 'gally' && $isGangBoss) {                      // باسِ گنگ درخواست اتحاد رو قبول/رد می‌کنه
    $id = (int)($_POST['id'] ?? 0); $act = ($_POST['act'] ?? '') === 'accept' ? 'active' : 'declined';
    $p = 'gang'; $_GET['t'] = 'territory';
    $al = null; foreach (gang_alliances_of($myGang) as $a2) if ((int)$a2['id'] === $id) { $al = $a2; break; }
    // فقط طرفِ گیرنده‌ی درخواست (gang_b) اجازه‌ی قبول/رد داره، نه طرفی که خودش درخواست داده (gang_a)
    if (!$al || $al['status'] !== 'pending' || $al['gang_b'] !== $myGang) $flash = 'این درخواست اتحاد یافت نشد یا قابل تغییر نیست.';
    elseif ($act === 'declined') { $db->prepare('DELETE FROM gang_alliances WHERE id=?')->execute([$id]); $ok = 'درخواست اتحاد رد شد.'; audit_log('gang', $myGang, 'رد اتحاد', $u['fullname'], gang_label($al['gang_a'])); }
    else { $db->prepare("UPDATE gang_alliances SET status='active' WHERE id=?")->execute([$id]); $ok = 'اتحاد فعال شد.'; audit_log('gang', $myGang, 'تایید اتحاد', $u['fullname'], gang_label($al['gang_a'])); }
  } elseif ($a === 'gwar' && $isGangBoss) {                        // باسِ گنگ رسماً با یه گنگ دیگه اعلام خصومت می‌کنه (یک‌طرفه، بدون نیاز به تایید طرف مقابل)
    $target = trim((string)($_POST['target'] ?? '')); $p = 'gang'; $_GET['t'] = 'territory';
    $validTarget = null; foreach (other_gangs($myGang) as $og) if ($og['name'] === $target) { $validTarget = $og; break; }
    if (!$validTarget) $flash = 'گنگِ هدف پیدا نشد.';
    else { $db->prepare("INSERT INTO web_gang_wars(gang_a,gang_b,declared_by_name,status,created) VALUES(?,?,?,'active',?)")->execute([$myGang, $target, $u['fullname'], time()]); $ok = 'خصومت با «' . ($validTarget['label'] ?: $target) . '» اعلام شد.'; audit_log('gang', $myGang, 'اعلام خصومت', $u['fullname'], $validTarget['label'] ?: $target); }
  } elseif ($a === 'gwarend' && $isGangBoss) {                     // باسِ هرکدوم از دو طرف می‌تونه خصومت رو پایان بده
    $id = (int)($_POST['id'] ?? 0); $p = 'gang'; $_GET['t'] = 'territory';
    $w = null; foreach (gang_wars_of($myGang) as $ww) if ((int)$ww['id'] === $id) { $w = $ww; break; }
    if (!$w) $flash = 'این خصومت یافت نشد یا قبلاً پایان یافته.';
    else { $db->prepare("UPDATE web_gang_wars SET status='ended' WHERE id=?")->execute([$id]); $ok = 'خصومت پایان یافت.'; $other = $w['gang_a'] === $myGang ? $w['gang_b'] : $w['gang_a']; audit_log('gang', $myGang, 'پایان خصومت', $u['fullname'], gang_label($other)); }
  } elseif ($a === 'gapp' && $isGangBoss) {                        // باسِ گنگ درخواست عضویتِ ثبت‌شده روی سایت رو قبول/رد می‌کنه
    $id = (int)($_POST['id'] ?? 0); $dec = ($_POST['dec'] ?? '') === 'accept' ? 'accepted' : 'rejected';
    $p = 'gang'; $_GET['t'] = 'home'; $gLabel = gang_row($myGang)['label'] ?? $myGang;
    $q = $db->prepare("SELECT * FROM web_apps WHERE id=? AND kind='gang' AND target=? AND status='pending'"); $q->execute([$id, $gLabel]); $app = $q->fetch();
    if (!$app) $flash = 'این درخواست یافت نشد یا قبلاً بررسی شده.';
    elseif ($dec === 'rejected') {
      $db->prepare("UPDATE web_apps SET status='rejected',note='رد توسط باس گنگ',updated=? WHERE id=?")->execute([time(), $id]); $ok = 'درخواست رد شد.';
      notify((int)$app['user_id'], "درخواست عضویتت در گنگ «$gLabel» رد شد.", 'dashboard.php?p=apps');
    } else {
      $ident = game_identifier_of_account((int)$app['user_id']);
      if (!$ident) $flash = 'کاراکتر بازیِ این کاربر پیدا نشد؛ شاید هنوز حساب سایتش به بازی وصل نشده.';
      else {
        $db->prepare('UPDATE users SET gang=?, gang_grade=0 WHERE identifier=?')->execute([$myGang, $ident]);
        $db->prepare("UPDATE web_apps SET status='accepted',note='تایید توسط باس گنگ',updated=? WHERE id=?")->execute([time(), $id]);
        $ok = 'عضو جدید به گنگ اضافه شد.';
        audit_log('gang', $myGang, 'تایید عضویت', $u['fullname'], $app['fullname'] ?? '');
        notify((int)$app['user_id'], "درخواست عضویتت در گنگ «$gLabel» تایید شد. خوش اومدی!", 'dashboard.php?p=gang');
      }
    }
  } elseif ($a === 'oset' && $isOrgBoss) {                        // باسِ ارگان رتبه‌ی یه کارمند رو تغییر می‌ده
    $ident = (string)($_POST['ident'] ?? ''); $grade = (int)($_POST['grade'] ?? -1);
    $myIdent = (string)($u['game']['identifier'] ?? ''); $target = null;
    foreach (job_members($myOrg) as $m) if ((string)$m['identifier'] === $ident) { $target = $m; break; }
    $validGrade = null; foreach ($jobGrades as $gr) if ((int)$gr['grade'] === $grade) { $validGrade = $gr; break; }
    $p = 'org'; $_GET['t'] = 'members';
    if (!$target || $ident === $myIdent) $flash = 'این عمل روی این کاربر مجاز نیست.';
    elseif (!$validGrade || $grade > (int)$myJobGrade['grade']) $flash = 'رتبه‌ی انتخابی نامعتبره یا از رتبه‌ی خودت بالاتره.';
    elseif ((int)$target['job_grade'] >= (int)$myJobGrade['grade']) $flash = 'نمی‌تونی روی هم‌رتبه یا بالادستِ خودت این کارو انجام بدی.';
    else {
      $db->prepare('UPDATE users SET job_grade=? WHERE identifier=? AND job=?')->execute([$grade, $ident, $myOrg]); $ok = 'رتبه‌ی کارمند به‌روزرسانی شد.';
      $tName = pname($target); audit_log('org', $myOrg, 'تغییر رتبه', $u['fullname'], $tName, "رتبه‌ی جدید: " . ($validGrade['label'] ?: $validGrade['name']));
      if ($accId = web_account_id_of_identifier($ident)) notify($accId, "رتبه‌ی تو تو ارگان به «" . ($validGrade['label'] ?: $validGrade['name']) . "» تغییر کرد.", 'dashboard.php?p=org');
    }
  } elseif ($a === 'ofire' && $isOrgBoss) {                       // باسِ ارگان یه کارمند رو اخراج می‌کنه
    $ident = (string)($_POST['ident'] ?? ''); $myIdent = (string)($u['game']['identifier'] ?? ''); $target = null;
    foreach (job_members($myOrg) as $m) if ((string)$m['identifier'] === $ident) { $target = $m; break; }
    $p = 'org'; $_GET['t'] = 'members';
    if (!$target || $ident === $myIdent) $flash = 'این عمل روی این کاربر مجاز نیست.';
    elseif ((int)$target['job_grade'] >= (int)$myJobGrade['grade']) $flash = 'نمی‌تونی هم‌رتبه یا بالادستِ خودت رو اخراج کنی.';
    else {
      $db->prepare("UPDATE users SET job='unemployed', job_grade=0 WHERE identifier=? AND job=?")->execute([$ident, $myOrg]); $ok = 'کارمند از ارگان اخراج شد.';
      $tName = pname($target); audit_log('org', $myOrg, 'اخراج کارمند', $u['fullname'], $tName);
      if ($accId = web_account_id_of_identifier($ident)) notify($accId, 'از ارگان اخراج شدی.', 'dashboard.php');
    }
  } elseif ($a === 'oapp' && $isOrgBoss) {                        // باسِ ارگان درخواست عضویتِ ثبت‌شده روی سایت رو قبول/رد می‌کنه
    $id = (int)($_POST['id'] ?? 0); $dec = ($_POST['dec'] ?? '') === 'accept' ? 'accepted' : 'rejected';
    $p = 'org'; $_GET['t'] = 'home'; $jLabel = job_row($myOrg)['label'] ?? job_label($myOrg);
    $q = $db->prepare("SELECT * FROM web_apps WHERE id=? AND kind='org' AND target=? AND status='pending'"); $q->execute([$id, $jLabel]); $app = $q->fetch();
    if (!$app) $flash = 'این درخواست یافت نشد یا قبلاً بررسی شده.';
    elseif ($dec === 'rejected') {
      $db->prepare("UPDATE web_apps SET status='rejected',note='رد توسط باس ارگان',updated=? WHERE id=?")->execute([time(), $id]); $ok = 'درخواست رد شد.';
      notify((int)$app['user_id'], "درخواست عضویتت در ارگان «$jLabel» رد شد.", 'dashboard.php?p=apps');
    } else {
      $ident = game_identifier_of_account((int)$app['user_id']);
      if (!$ident) $flash = 'کاراکتر بازیِ این کاربر پیدا نشد؛ شاید هنوز حساب سایتش به بازی وصل نشده.';
      else {
        $db->prepare('UPDATE users SET job=?, job_grade=0 WHERE identifier=?')->execute([$myOrg, $ident]);
        $db->prepare("UPDATE web_apps SET status='accepted',note='تایید توسط باس ارگان',updated=? WHERE id=?")->execute([time(), $id]);
        $ok = 'کارمند جدید به ارگان اضافه شد.';
        audit_log('org', $myOrg, 'تایید عضویت', $u['fullname'], $app['fullname'] ?? '');
        notify((int)$app['user_id'], "درخواست عضویتت در ارگان «$jLabel» تایید شد. خوش اومدی!", 'dashboard.php?p=org');
      }
    }
  } elseif ($a === 'news_post' && $myOrg === 'weazel' && $isOrgBoss) {   // باسِ Weazel یه خبر تو گالریِ سایت منتشر می‌کنه
    $title = trim((string)($_POST['title'] ?? '')); $body = trim((string)($_POST['body'] ?? '')); $img = trim((string)($_POST['image_url'] ?? ''));
    $p = 'org'; $_GET['t'] = 'news';
    if ($title === '' || $body === '' || mb_strlen($title) > 120) $flash = 'عنوان و متن خبر رو کامل بنویس.';
    else { $db->prepare('INSERT INTO web_news(author_account_id,author_name,title,body,image_url,pinned,created) VALUES(?,?,?,?,?,0,?)')->execute([$u['id'], $u['fullname'], $title, $body, $img !== '' ? $img : null, time()]); $ok = 'خبر منتشر شد و تو گالری نمایش داده می‌شه.'; }
  } elseif ($a === 'news_del' && $admin) {                          // فقط ادمین سایت می‌تونه یه خبر رو حذف کنه
    $id = (int)($_POST['id'] ?? 0); $db->prepare('DELETE FROM web_news WHERE id=?')->execute([$id]); $ok = 'خبر حذف شد.'; $p = 'org';
  } elseif ($a === 'pass') {
    $p = 'settings'; $lq = $db->prepare('SELECT password,password_salt FROM login_users WHERE id=?'); $lq->execute([$u['lid']]); $lr = $lq->fetch(); $nw = $_POST['new'] ?? '';
    if (rate_full('pw-' . $u['lid'], 5, 900)) $flash = 'تلاش‌های زیاد؛ ۱۵ دقیقه بعد دوباره امتحان کن.';
    elseif (!$lr || !hash_equals((string)$lr['password'], game_hash($_POST['old'] ?? '', (string)$lr['password_salt']))) { rate_hit('pw-' . $u['lid'], 900); $flash = 'رمز فعلی اشتباه است.'; }
    elseif (strlen($nw) < 6 || !preg_match('/\d/', $nw) || !preg_match('/[A-Za-z]/', $nw)) $flash = 'رمز جدید حداقل ۶ کاراکتر و شامل یک حرف انگلیسی و یک عدد باشد.';
    else { $salt = bin2hex(random_bytes(16)); $db->prepare('UPDATE login_users SET password=?,password_salt=? WHERE id=?')->execute([game_hash($nw, $salt), $salt, $u['lid']]); $ok = 'رمز عبور تغییر کرد؛ از این به بعد داخل بازی هم با همین رمز وارد می‌شی.'; }

  } elseif ($a === 'apply') {                                     // ثبت درخواست عضویت
    $p = 'apply'; [$kind, $target] = array_pad(explode(':', $_POST['target'] ?? '', 2), 2, '');
    $T = apply_targets(); $valid = $kind === 'gang' ? in_array($target, $T['gang'], true)
      : ($kind === 'org' && in_array($target, array_merge(...array_values($T['org'])), true));
    $f = ['bg' => trim($_POST['bg'] ?? ''), 'why' => trim($_POST['why'] ?? ''), 'exp' => trim($_POST['exp'] ?? ''), 'hours' => trim($_POST['hours'] ?? '')];
    $pend = $db->prepare("SELECT COUNT(*) FROM web_apps WHERE user_id=? AND status='pending'"); $pend->execute([$u['id']]);
    $dup = $db->prepare("SELECT COUNT(*) FROM web_apps WHERE user_id=? AND kind=? AND target=? AND status='pending'"); $dup->execute([$u['id'], $kind, $target]);
    $cool = $db->prepare("SELECT COUNT(*) FROM web_apps WHERE user_id=? AND kind=? AND target=? AND status='rejected' AND updated>?"); $cool->execute([$u['id'], $kind, $target, time() - 86400]);
    if (!$valid) $flash = 'مقصد انتخاب‌شده معتبر نیست یا عضوگیری‌اش بسته است.';
    elseif (mb_strlen($f['bg']) < 30 || mb_strlen($f['why']) < 20) $flash = 'پیش‌زمینه‌ی کاراکتر (حداقل ۳۰ حرف) و دلیل درخواست (حداقل ۲۰ حرف) رو کامل بنویس.';
    elseif (array_sum(array_map('mb_strlen', $f)) > 4000) $flash = 'متن درخواست خیلی طولانیه.';
    elseif ((int)$dup->fetchColumn() > 0) $flash = 'برای این مورد یه درخواست در انتظار بررسی داری.';
    elseif ((int)$pend->fetchColumn() >= 3) $flash = 'حداکثر ۳ درخواست هم‌زمان در انتظار بررسی می‌تونی داشته باشی.';
    elseif ((int)$cool->fetchColumn() > 0) $flash = 'درخواستت برای این مورد به‌تازگی رد شده؛ ۲۴ ساعت بعد دوباره تلاش کن.';
    else {
      $db->prepare("INSERT INTO web_apps(user_id,kind,target,body,status,note,created,updated) VALUES(?,?,?,?,'pending','',?,?)")
         ->execute([$u['id'], $kind, $target, json_encode($f, JSON_UNESCAPED_UNICODE), time(), time()]);
      go('dashboard.php?p=apps&done=1');
    }
  } elseif ($a === 'cancel_app') {
    $db->prepare("UPDATE web_apps SET status='cancelled',updated=? WHERE id=? AND user_id=? AND status='pending'")->execute([time(), (int)($_POST['id'] ?? 0), $u['id']]);
    go('dashboard.php?p=apps');
  } elseif ($a === 'decide' && $admin) {                          // تصمیم مدیر
    $st = ($_POST['d'] ?? '') === 'accept' ? 'accepted' : 'rejected';
    $db->prepare("UPDATE web_apps SET status=?,note=?,updated=? WHERE id=? AND status='pending'")->execute([$st, mb_substr(trim($_POST['note'] ?? ''), 0, 500), time(), (int)($_POST['id'] ?? 0)]);
    go('dashboard.php?p=review');
  }
}
if (($_GET['done'] ?? '') === '1' && $p === 'apps') $ok = 'درخواستت ثبت شد؛ نتیجه‌ی بررسی همین‌جا نمایش داده می‌شه.';

$mask = preg_match('/^09\d{9}$/', $u['phone']) ? substr($u['phone'], 0, 4) . '***' . substr($u['phone'], -4) : '—';
function job_label(string $j): string { foreach (CFG['depts'] as $d) if ($d['job'] === $j) return $d['label']; return $j === 'unemployed' ? 'بیکار' : $j; }
function ago(int $t): string { $s = max(0, time() - $t); return $s < 90 ? 'همین الان' : ($s < 3600 ? intdiv($s, 60) . ' دقیقه پیش' : ($s < 172800 ? intdiv($s, 3600) . ' ساعت پیش' : intdiv($s, 86400) . ' روز پیش')); }
// BUG FIX: تایل «ساعت بازی» فقط یه عدد خام (مثلاً «52») نشون می‌داد بدون واحد و بدون تناسب با اندازه‌ی مقدار.
// این تابع timePlay (ثانیه) رو مثل ago() بالا، متناسب با اندازه‌ش به دقیقه/ساعت/روز (+ ساعت باقی‌مونده) نمایش می‌ده.
// BUG FIX: نسخه‌ی «ago» که به‌جای یه timestamp، مستقیم تعداد ثانیه‌ی سپری‌شده (که خودِ
// MySQL حساب کرده، نه PHP) می‌گیره — همون چیزی که me() الان توی seenSecsAgo برمی‌گردونه.
function ago_secs(int $s): string { $s = max(0, $s); return $s < 90 ? 'همین الان' : ($s < 3600 ? intdiv($s, 60) . ' دقیقه پیش' : ($s < 172800 ? intdiv($s, 3600) . ' ساعت پیش' : intdiv($s, 86400) . ' روز پیش')); }
function playdur(int $sec): string {
  $sec = max(0, $sec);
  if ($sec < 3600) return number_format(intdiv($sec, 60)) . ' دقیقه';
  if ($sec < 86400) return number_format(intdiv($sec, 3600)) . ' ساعت';
  $d = intdiv($sec, 86400); $h = intdiv($sec % 86400, 3600);
  return number_format($d) . ' روز' . ($h > 0 ? ' و ' . $h . ' ساعت' : '');
}
const AUDIT = ['login_success' => 'ورود موفق به سرور', 'login_fail' => 'تلاش ناموفق برای ورود', 'register' => 'ساخت حساب', 'password_reset' => 'بازیابی رمز', 'password_change' => 'تغییر رمز از داخل بازی', 'new_device' => 'ورود از دستگاه جدید', 'logout_all' => 'خروج از همه‌ی دستگاه‌ها', 'security_hold' => 'قفل امنیتی فعال شد', 'security_hold_cleared' => 'قفل امنیتی باز شد'];
$st = ['open' => 'باز', 'answered' => 'پاسخ داده شد', 'closed' => 'بسته'];
$cnt = fn($sql, $args = []) => (function () use ($db, $sql, $args) { $s = $db->prepare($sql); $s->execute($args); return (int)$s->fetchColumn(); })();
$myPend = $cnt("SELECT COUNT(*) FROM web_apps WHERE user_id=? AND status='pending'", [$u['id']]);
$revPend = $admin ? $cnt("SELECT COUNT(*) FROM web_apps WHERE status='pending'") : 0;
$I = [ // آیکون‌ها
 'home' => '<path d="M3 11 12 3l9 8v9a1 1 0 0 1-1 1h-5v-6H9v6H4a1 1 0 0 1-1-1v-9Z"/>',
 'info' => '<rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="9" cy="11" r="2"/><path d="M14 10h4M14 14h4M6 16c.5-1.5 1.5-2 3-2s2.500.5 3 2"/>',
 'apply' => '<path d="M12 5v14M5 12h14"/>', 'apps' => '<path d="M9 5h10M9 12h10M9 19h10M4 5h.01M4 12h.01M4 19h.01"/>',
 'review' => '<path d="M9 12l2 2 4-4"/><rect x="4" y="3" width="16" height="18" rx="2"/>',
 'users' => '<circle cx="9" cy="8" r="3.500"/><path d="M2 20a7 7 0 0 1 14 0M17 11a3 3 0 1 0 0-6M22 20a6 6 0 0 0-4-5.600"/>',
 'tickets' => '<path d="M21 11.500a8.400 8.400 0 0 1-8.400 8.400 8.600 8.600 0 0 1-3.800-.9L3 20l1-5.600a8.400 8.400 0 0 1-.9-3.900A8.400 8.400 0 0 1 11.500 2 8.600 8.600 0 0 1 21 11.500Z"/>',
 'settings' => '<circle cx="12" cy="12" r="3"/><path d="M19.400 15a1.700 1.700 0 0 0 .3 1.800l.1.1a2 2 0 1 1-2.800 2.800l-.1-.1a1.700 1.700 0 0 0-1.800-.3 1.700 1.700 0 0 0-1 1.500V21a2 2 0 1 1-4 0v-.1a1.700 1.700 0 0 0-1.100-1.500 1.700 1.700 0 0 0-1.800.3l-.1.1a2 2 0 1 1-2.800-2.800l.1-.1a1.700 1.700 0 0 0 .3-1.800 1.700 1.700 0 0 0-1.500-1H3a2 2 0 1 1 0-4h.1a1.700 1.700 0 0 0 1.500-1.100 1.700 1.700 0 0 0-.3-1.800l-.1-.1a2 2 0 1 1 2.800-2.800l.1.1a1.700 1.700 0 0 0 1.800.3H9a1.700 1.700 0 0 0 1-1.500V3a2 2 0 1 1 4 0v.1a1.700 1.700 0 0 0 1 1.500 1.700 1.700 0 0 0 1.800-.3l.1-.1a2 2 0 1 1 2.800 2.800l-.1.1a1.700 1.700 0 0 0-.3 1.800V9a1.700 1.700 0 0 0 1.500 1H21a2 2 0 1 1 0 4h-.1a1.700 1.700 0 0 0-1.500 1Z"/>',
 'gang' => '<path d="M17 11a3 3 0 1 0 0-6 3 3 0 0 0 0 6ZM7 11a3 3 0 1 0 0-6 3 3 0 0 0 0 6Z"/><path d="M2 20a5 5 0 0 1 5-5c2 0 3.700 1.100 4.500 2.700M22 20a5 5 0 0 0-5-5c-2 0-3.700 1.100-4.500 2.700"/>',
 'org' => '<path d="M4 21V8l8-5 8 5v13"/><path d="M9 21v-7h6v7M4 21h16"/>',
 'notif' => '<path d="M18 8a6 6 0 1 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.730 21a2 2 0 0 1-3.460 0"/>',
 'logs' => '<path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2Z"/>',
 'growth' => '<path d="M3 3v18h18"/><path d="M18.7 8 12 14.7 8.7 11.4 3 17"/>',
];
$unreadCount = unread_notif_count($u['id']);
$nav = ['home' => 'نمای کلی', 'info' => 'کارت شهروندی'];
if ($myGang) $nav['gang'] = 'پنل گنگ من' . ($isGangBoss ? ' (باس)' : '');
if ($myOrg) $nav['org'] = 'پنل ارگان من' . ($isOrgBoss ? ' (باس)' : '');
$nav += ['apply' => 'ثبت درخواست عضویت', 'apps' => 'درخواست‌های من', 'tickets' => 'پشتیبانی (تیکت)', 'notif' => 'اعلان‌ها' . ($unreadCount ? " ($unreadCount)" : ''), 'settings' => 'تنظیمات'];
$adm = ['review' => 'بررسی درخواست‌ها', 'users' => 'حساب‌های بازی', 'logs' => 'لاگ‌های سرور', 'growth' => 'رشد سایت'];
$ico = fn($k) => '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">' . $I[$k] . '</svg>';
function app_card(array $x, bool $review = false, bool $mine = true): void {
  $b = json_decode($x['body'], true) ?: []; $g = $x['kind'] === 'org' ? org_group($x['target']) : 'گنگ'; ?>
  <div class="app <?= e($x['status']) ?>">
    <div class="ahead"><h3><?= e($x['target']) ?><small><?= e($g) ?><?= $review ? ' · ' . e($x['fullname'] ?? '') : '' ?></small></h3>
      <span class="tag <?= e($x['status']) ?>"><?= APP_ST[$x['status']] ?? '' ?></span></div>
    <small class="mut"><?= date('Y/m/d H:i', (int)$x['created']) ?></small>
    <details <?= $review && $x['status'] === 'pending' ? 'open' : '' ?>><summary>مشاهده‌ی متن درخواست</summary>
      <div class="qa"><div><b>پیش‌زمینه‌ی کاراکتر</b><p><?= e($b['bg'] ?? '') ?></p></div><div><b>دلیل درخواست</b><p><?= e($b['why'] ?? '') ?></p></div>
        <?php if (!empty($b['exp'])): ?><div><b>سوابق</b><p><?= e($b['exp']) ?></p></div><?php endif; ?>
        <?php if (!empty($b['hours'])): ?><div><b>ساعت فعالیت روزانه</b><p><?= e($b['hours']) ?></p></div><?php endif; ?></div></details>
    <?php if ($x['note'] !== '' && $x['note'] !== null): ?><div class="reply"><small>پاسخ مدیریت</small><?= nl2br(e($x['note'])) ?></div><?php endif; ?>
    <?php if ($x['status'] === 'pending' && $review): ?>
      <form method="post" class="row-actions"><?= csrf_field() ?><input type="hidden" name="a" value="decide"><input type="hidden" name="id" value="<?= (int)$x['id'] ?>">
        <label style="flex:1;min-width:200px;margin:0"><input name="note" maxlength="500" placeholder="توضیح برای کاربر (اختیاری)"></label>
        <button class="btn ok" name="d" value="accept">پذیرش</button><button class="btn no" name="d" value="reject">رد</button></form>
    <?php elseif ($x['status'] === 'pending' && $mine): ?>
      <form method="post" class="row-actions" onsubmit="return confirm('درخواست لغو بشه؟')"><?= csrf_field() ?><input type="hidden" name="a" value="cancel_app"><input type="hidden" name="id" value="<?= (int)$x['id'] ?>"><button class="btn no">لغو درخواست</button></form>
    <?php endif; ?>
  </div><?php
}
?><!DOCTYPE html>
<html lang="fa" dir="rtl"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>داشبورد شهروندی | <?= e(CFG['name']) ?></title><meta name="theme-color" content="#050505">
<link rel="stylesheet" href="style.css"></head>
<body class="dash">
<div class="dtop"><a href="index.php" class="logo"><svg viewBox="0 0 64 64"><defs><linearGradient id="g" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#ffe08a"/><stop offset="1" stop-color="#d18f00"/></linearGradient></defs><path d="M16 8v28a16 16 0 0 0 32 0V8" fill="none" stroke="url(#g)" stroke-width="11" stroke-linecap="round"/></svg><span><?= e(strtok(CFG['name'], ' ')) ?> <b><?= e(trim(strstr(CFG['name'], ' '))) ?></b></span></a>
  <a class="btn" href="index.php">صفحه اصلی</a><a class="btn" href="auth.php?out=1">خروج</a></div>
<div class="dlayout">
<aside class="side">
  <div class="ucard"><div class="av"><?= e(mb_substr($u['fullname'], 0, 1)) ?></div><b dir="ltr"><?= e($u['fullname']) ?></b><small dir="ltr">@<?= e($u['username']) ?></small><span class="rolebadge"><?= e($u['rank'] ?: 'شهروند') ?></span></div>
  <div class="dnav">
    <?php foreach ($nav as $k => $l): ?><a href="dashboard.php?p=<?= $k ?>" class="<?= ($p === $k || ($p === 'ticket' && $k === 'tickets')) ? 'on' : '' ?>"><?= $ico($k) ?><?= $l ?><?= $k === 'apps' && $myPend ? '<span class="cnt">' . $myPend . '</span>' : '' ?></a><?php endforeach; ?>
    <?php if ($admin): ?><hr><?php foreach ($adm as $k => $l): ?><a href="dashboard.php?p=<?= $k ?>" class="<?= $p === $k ? 'on' : '' ?>"><?= $ico($k) ?><?= $l ?><?= $k === 'review' && $revPend ? '<span class="cnt">' . $revPend . '</span>' : '' ?></a><?php endforeach; endif; ?>
  </div>
</aside>
<main class="dmain">
<?php if ($flash): ?><p class="err" role="alert"><?= e($flash) ?></p><?php endif; ?>
<?php if ($ok): ?><p class="ok-msg" role="status"><?= e($ok) ?></p><?php endif; ?>

<?php if ($p === 'home'):
  $tot = $cnt('SELECT COUNT(*) FROM web_apps WHERE user_id=?', [$u['id']]); $acc = $cnt("SELECT COUNT(*) FROM web_apps WHERE user_id=? AND status='accepted'", [$u['id']]);
  $tk = $cnt("SELECT COUNT(*) FROM web_tickets WHERE user_id=? AND status<>'closed'", [$u['id']]);
  $last = $db->prepare('SELECT * FROM web_apps WHERE user_id=? ORDER BY id DESC LIMIT 3'); $last->execute([$u['id']]); ?>
  <?php $g = $u['game']; $lv = (int)$u['level']; $act = [];
    try { $aq = $db->prepare('SELECT action,created_at FROM login_audit WHERE username=? ORDER BY created_at DESC LIMIT 5'); $aq->execute([$u['username']]); $act = $aq->fetchAll(); } catch (Throwable $e) {} ?>
  <section class="pro">
    <div class="pro-av <?= $u['online'] ? 'on' : '' ?>" id="proAv"><span><?= e(mb_substr($u['fullname'], 0, 1)) ?></span></div>
    <div class="pro-body">
      <small class="mut">خوش اومدی</small>
      <h2 class="gt" dir="ltr"><?= e($u['fullname']) ?></h2>
      <div class="chips"><span>@<?= e($u['username']) ?></span>
        <?php // BUG FIX: این بج فقط برای کادر/ادمین‌ها پر می‌شه — چون $u['rank'] برای بازیکن‌های عادی
        // (permission_level == 0) توی me() از قبل null هست، کاربر عادی اصلاً این بج رو نمی‌بینه. ?>
        <?php if ($u['rank']): ?><span class="gold">Rank Admin: <?= e($u['rank']) ?></span><?php endif; ?>
        <?php if ($g): ?>
          <span>Job: <?= e(job_label((string)$g['job'])) ?> - <?= e(job_grade_label((string)$g['job'], (int)$g['job_grade'])) ?> (<?= (int)$g['job_grade'] ?>)</span>
          <?php if ($g['gang'] && $g['gang'] !== 'none' && $g['gang'] !== 'nogang'): ?><span>Gang: <?= e(gang_label((string)$g['gang'])) ?></span><?php endif; ?>
        <?php endif; ?>
        <span class="<?= $u['online'] ? 'live' : '' ?>" id="onlineBadge"><?= $u['online'] ? 'آنلاین در شهر' : 'آفلاین' ?></span></div>
      <?php if ($g): ?><div class="xp"><i style="width:<?= min(100, (int)round($lv / max(50, $lv) * 100)) ?>%"></i></div><small class="mut" dir="ltr">Level <?= $lv ?> · XP <?= number_format((int)$g['xp']) ?></small><?php endif; ?>
    </div>
  </section>
  <?php if ($g): ?>
  <div class="tiles">
    <div><span>پول نقد</span><b dir="ltr">$<?= number_format((int)$g['money']) ?></b></div>
    <div><span>موجودی بانک</span><b dir="ltr">$<?= number_format((int)$g['bank']) ?></b></div>
    <div><span>ساعت بازی</span><b><?= playdur((int)$g['timePlay']) ?></b></div>
    <div><span>آخرین حضور</span><b id="seenText"><?= $u['online'] ? 'الان' : ($u['seenSecsAgo'] !== null ? ago_secs($u['seenSecsAgo']) : '—') ?></b></div>
  </div>
  <script>
  // BUG FIX: هر ۲۰ ثانیه وضعیت آنلاین/آخرین حضور رو از سرور می‌گیره و بدون رفرش کامل صفحه
  // آپدیت می‌کنه — اگه بازیکن قطع بشه یا کل سرور بازی کرش کنه، تب باز بدون این هیچ‌وقت
  // خودش به‌روز نمی‌شد و همیشه همون وضعیت لحظه‌ی لود صفحه رو نشون می‌داد.
  function pollOnlineStatus(){
    fetch('dashboard.php?ajax=status', {cache:'no-store'}).then(r=>r.json()).then(d=>{
      const badge=document.getElementById('onlineBadge'), av=document.getElementById('proAv'), seen=document.getElementById('seenText');
      if(badge){ badge.textContent = d.online ? 'آنلاین در شهر' : 'آفلاین'; badge.className = d.online ? 'live' : ''; }
      if(av){ av.classList.toggle('on', !!d.online); }
      if(seen){ seen.textContent = d.seenText; }
    }).catch(()=>{});
  }
  setInterval(pollOnlineStatus, 20000);
  </script>
  <?php else: ?><div class="dcardx"><h3>هنوز کاراکتری به این حساب وصل نیست</h3><p class="mut">بعد از اولین ورود به سرور با همین حساب، اطلاعات کاراکترت (پول، سطح، شغل، گنگ) اینجا نمایش داده می‌شه.</p></div><?php endif; ?>
  <div class="kpis"><div class="kpi"><b><?= $tot ?></b><span>کل درخواست‌ها</span></div><div class="kpi"><b><?= $myPend ?></b><span>در انتظار بررسی</span></div><div class="kpi"><b><?= $acc ?></b><span>پذیرفته‌شده</span></div><div class="kpi"><b><?= $tk ?></b><span>تیکت باز</span></div></div>
  <?php if ($admin && $revPend): ?><div class="dcardx" style="border-color:#ffc10755"><h3>🔔 <?= $revPend ?> درخواست منتظر بررسی توئه</h3><a class="btn gold" href="dashboard.php?p=review">رفتن به بررسی درخواست‌ها</a></div><?php endif; ?>
  <div class="dcardx"><h3>شروع سریع</h3><div class="row-actions"><a class="btn pri" href="dashboard.php?p=apply">ثبت درخواست عضویت</a><a class="btn" href="join.php">دیدن گنگ‌ها و ارگان‌ها</a><a class="btn" href="dashboard.php?p=info">کارت شهروندی</a></div></div>
  <?php if ($act): ?><div class="dcardx"><h3>آخرین فعالیت‌های حساب</h3><ul class="acts"><?php foreach ($act as $x): ?><li class="<?= in_array($x['action'], ['login_fail', 'security_hold'], true) ? 'bad' : '' ?>"><span><?= e(AUDIT[$x['action']] ?? $x['action']) ?></span><small><?= e(ago((int)strtotime((string)$x['created_at']))) ?></small></li><?php endforeach; ?></ul></div><?php endif; ?>
  <h3 style="margin:26px 0 12px">آخرین درخواست‌ها</h3>
  <?php $n = 0; foreach ($last as $x) { app_card($x); $n++; } if (!$n) echo '<div class="empty2">هنوز درخواستی ثبت نکردی. از «ثبت درخواست عضویت» شروع کن.</div>'; ?>

<?php elseif ($p === 'info'): ?>
  <h2>کارت شهروندی</h2><p class="lead">اطلاعات حساب و کاراکتر تو.</p>
  <section class="notice"><h2>ورود به شهر <?= e(CFG['fa']) ?> در لانچر VMP</h2>
    <p>برای ورود به شهر، اطلاعات زیر را در لانچر VMP وارد کنید:</p>
    <p class="cred"><span>نام کاربری</span> <b dir="ltr"><?= e($u['username']) ?></b> <span>رمز عبور</span> <b>همون رمزی که موقع ساخت حساب داخل بازی گذاشتی</b></p></section>
  <div class="head"><h2>اطلاعات کاراکتر</h2><button class="btn" onclick="window.print()">دانلود کارت شناسایی</button></div>
  <article class="idcard">
    <div class="ch"><b><?= e(strtoupper(CFG['name'])) ?></b><span>کارت شناسایی شهروندی</span><small>CITIZEN IDENTITY CARD</small></div>
    <div class="cb"><dl>
      <dt>نام و نام خانوادگی:</dt><dd><?= e($u['fullname']) ?></dd>
      <dt>جنسیت:</dt><dd><?= e($u['gender']) ?></dd>
      <dt>سطح تجربه:</dt><dd><?= (int)$u['level'] ?></dd>
      <dt>شماره تماس:</dt><dd dir="ltr"><?= e($mask) ?></dd>
      <dt>شماره حساب:</dt><dd dir="ltr"><?= e(($u['game']['iban'] ?? '') ?: $u['acc']) ?></dd></dl>
      <div class="cid"><small>شماره شناسایی</small><b dir="ltr"><?= e($u['game'] ? str_pad((string)(int)$u['game']['account_num'], 8, '0', STR_PAD_LEFT) : $u['cid']) ?></b></div></div>
  </article>

<?php elseif ($p === 'gang'):
  $gRow = gang_row($myGang); $members = gang_members($myGang); $terrTitle = gang_territory_title($myGang);
  $gApps = $isGangBoss ? apps_pending_for('gang', $gRow['label'] ?? $myGang) : [];
  $gt = $_GET['t'] ?? 'home'; $gt = in_array($gt, ['members', 'tickets', 'territory', 'leaderboard', 'audit'], true) ? $gt : 'home'; ?>
  <h2>پنل گنگ من — <?= e($gRow['label'] ?? $myGang) ?></h2>
  <p class="lead">رتبه‌ی تو: <b><?= e(($myGangGrade['label'] ?? '') ?: ($myGangGrade['name'] ?? '—')) ?></b><?= $isGangBoss ? ' · <span class="rolebadge">دسترسی باس (Boss Action)</span>' : '' ?><?= $terrTitle ? ' · <span class="rolebadge">' . e($terrTitle) . '</span>' : '' ?></p>
  <div class="tiles">
    <div><span>سطح گنگ</span><b><?= (int)($gRow['level'] ?? 0) ?></b></div>
    <div><span>XP گنگ</span><b><?= number_format((int)($gRow['xp'] ?? 0)) ?></b></div>
    <div><span>تعداد اعضا</span><b><?= count($members) ?></b></div>
    <div><span>وضعیت</span><b><?= (int)($gRow['disband'] ?? 0) ? 'منحل شده' : 'فعال' ?></b></div>
  </div>
  <div class="seg">
    <button class="<?= $gt === 'home' ? 'on' : '' ?>" onclick="location='dashboard.php?p=gang'">نمای کلی<?= $gApps ? ' (' . count($gApps) . ')' : '' ?></button>
    <button class="<?= $gt === 'members' ? 'on' : '' ?>" onclick="location='dashboard.php?p=gang&t=members'">اعضا (<?= count($members) ?>)</button>
    <button class="<?= $gt === 'territory' ? 'on' : '' ?>" onclick="location='dashboard.php?p=gang&t=territory'">قلمرو و اتحادها</button>
    <button class="<?= $gt === 'leaderboard' ? 'on' : '' ?>" onclick="location='dashboard.php?p=gang&t=leaderboard'">لیدربورد گنگ‌ها</button>
    <button class="<?= $gt === 'tickets' ? 'on' : '' ?>" onclick="location='dashboard.php?p=gang&t=tickets'">تیکت‌های گنگ</button>
    <button class="<?= $gt === 'audit' ? 'on' : '' ?>" onclick="location='dashboard.php?p=gang&t=audit'">لاگ اقدامات باس</button>
  </div>

  <?php if ($gt === 'home'): ?>
    <?php if ($gRow && !empty($gRow['logo']) && str_starts_with((string)$gRow['logo'], 'http')): ?>
      <div class="dcardx" style="text-align:center"><img src="<?= e($gRow['logo']) ?>" alt="" style="max-height:160px;border-radius:14px"></div>
    <?php endif; ?>

    <?php if ($isGangBoss && $gApps): ?>
      <h3>درخواست‌های عضویت در انتظار (<?= count($gApps) ?>)</h3>
      <div class="list"><?php foreach ($gApps as $ap): ?>
        <div class="row"><b><?= e($ap['fullname']) ?></b><small><?= e(mb_substr($ap['body'], 0, 80)) ?></small>
          <span style="display:inline-flex;gap:6px">
            <form method="post"><?= csrf_field() ?><input type="hidden" name="a" value="gapp"><input type="hidden" name="id" value="<?= (int)$ap['id'] ?>"><input type="hidden" name="dec" value="accept"><button class="btn" style="padding:6px 12px">قبول</button></form>
            <form method="post"><?= csrf_field() ?><input type="hidden" name="a" value="gapp"><input type="hidden" name="id" value="<?= (int)$ap['id'] ?>"><input type="hidden" name="dec" value="reject"><button class="btn no" style="padding:6px 12px">رد</button></form>
          </span>
        </div>
      <?php endforeach; ?></div>
    <?php endif; ?>

    <h3>اعضای برتر</h3>
    <div class="list"><?php foreach (array_slice($members, 0, 5) as $m): $mg = (int)$m['gang_grade']; $lbl = (string)$mg;
      foreach ($gangGrades as $gr) if ((int)$gr['grade'] === $mg) { $lbl = ($gr['label'] ?: $gr['name']) ?: $lbl; break; } ?>
      <div class="row"><b><?= e(pname($m)) ?></b><span class="mut"><?= e($lbl) ?></span></div>
    <?php endforeach; if (!$members) echo '<p class="mut">عضوی پیدا نشد.</p>'; ?></div>

    <h3>قلمرو</h3>
    <?php $zones = territory_state(); $mineCount = count(array_filter($zones, fn($z) => $z['owner'] === $myGang)); ?>
    <p class="mut"><?= $mineCount ?> از <?= count($zones) ?> منطقه در تصرف این گنگه — <a href="dashboard.php?p=gang&t=territory">مشاهده‌ی کامل</a></p>

    <h3>آخرین تیکت‌های گنگ</h3>
    <?php $q = $db->prepare('SELECT * FROM web_tickets WHERE gang=? ORDER BY id DESC LIMIT 3'); $q->execute([$myGang]); $recentT = $q->fetchAll(); ?>
    <div class="list"><?php foreach ($recentT as $t): ?>
      <a class="row" href="dashboard.php?p=ticket&id=<?= (int)$t['id'] ?>"><b>#<?= (int)$t['id'] ?> <?= e($t['subject']) ?></b><span class="tag <?= e($t['status']) ?>"><?= $st[$t['status']] ?></span></a>
    <?php endforeach; if (!$recentT) echo '<p class="mut">هنوز تیکتی ثبت نشده.</p>'; ?></div>

  <?php elseif ($gt === 'members'): ?>
    <?php if ($isGangBoss): ?><p class="mut" style="margin-bottom:10px">عضوگیریِ اعضای جدید فقط از داخل بازی (منوی باس‌اکشن) انجام می‌شه؛ از اینجا فقط می‌تونی رتبه‌ی اعضای فعلی رو مدیریت کنی یا اخراج کنی.</p><?php endif; ?>
    <div class="dcardx" style="overflow-x:auto"><table class="utable"><tr><th>کاراکتر</th><th>رتبه</th><?= $isGangBoss ? '<th>عملیات</th>' : '' ?></tr>
    <?php foreach ($members as $m): $mg = (int)$m['gang_grade']; $lbl = (string)$mg;
      foreach ($gangGrades as $gr) if ((int)$gr['grade'] === $mg) { $lbl = ($gr['label'] ?: $gr['name']) ?: $lbl; break; }
      $isSelf = (string)$m['identifier'] === (string)($u['game']['identifier'] ?? '');
      $canAct = $isGangBoss && !$isSelf && $mg < (int)$myGangGrade['grade'];
      $canUp = $canAct && $mg + 1 <= (int)$myGangGrade['grade'] && in_array($mg + 1, array_column($gangGrades, 'grade'), true);
      $canDown = $canAct && $mg - 1 >= 0 && in_array($mg - 1, array_column($gangGrades, 'grade'), true); ?>
      <tr><td><?= e(pname($m)) ?></td><td><?= e($lbl) ?> (<?= $mg ?>)</td>
      <?php if ($isGangBoss): ?><td>
        <?php if ($canAct): ?>
          <span style="display:inline-flex;gap:6px;align-items:center;flex-wrap:wrap">
          <?php if ($canUp): ?><form method="post" style="display:inline"><?= csrf_field() ?><input type="hidden" name="a" value="gset"><input type="hidden" name="ident" value="<?= e($m['identifier']) ?>"><input type="hidden" name="grade" value="<?= $mg + 1 ?>"><button class="btn" style="padding:6px 10px" title="ارتقا یک رتبه">▲ رنک‌آپ</button></form><?php endif; ?>
          <?php if ($canDown): ?><form method="post" style="display:inline"><?= csrf_field() ?><input type="hidden" name="a" value="gset"><input type="hidden" name="ident" value="<?= e($m['identifier']) ?>"><input type="hidden" name="grade" value="<?= $mg - 1 ?>"><button class="btn" style="padding:6px 10px" title="تنزل یک رتبه">▼ رنک‌دون</button></form><?php endif; ?>
          <form method="post" style="display:inline-flex;gap:6px;align-items:center;margin:0"><?= csrf_field() ?><input type="hidden" name="a" value="gset"><input type="hidden" name="ident" value="<?= e($m['identifier']) ?>">
            <select name="grade" style="width:auto;margin:0"><?php foreach ($gangGrades as $gr): if ((int)$gr['grade'] > (int)$myGangGrade['grade']) continue; ?><option value="<?= (int)$gr['grade'] ?>" <?= $mg === (int)$gr['grade'] ? 'selected' : '' ?>><?= e(($gr['label'] ?: $gr['name']) ?: (string)$gr['grade']) ?></option><?php endforeach; ?></select>
            <button class="btn" style="padding:6px 12px;margin:0">ثبت رتبه</button></form>
          <form method="post" onsubmit="return confirm('این عضو از گنگ اخراج بشه؟')" style="display:inline"><?= csrf_field() ?><input type="hidden" name="a" value="gkick"><input type="hidden" name="ident" value="<?= e($m['identifier']) ?>"><button class="btn no" style="padding:6px 12px">اخراج</button></form>
          </span>
        <?php else: ?><span class="mut">—</span><?php endif; ?>
      </td><?php endif; ?></tr>
    <?php endforeach; if (!$members) echo '<tr><td colspan="3" class="mut">عضوی پیدا نشد.</td></tr>'; ?></table></div>

  <?php elseif ($gt === 'territory'):
    $zones = territory_state(); $mine = array_filter($zones, fn($z) => $z['owner'] === $myGang);
    $allies = gang_alliances_of($myGang); ?>
    <div class="tiles">
      <div><span>مناطق تحت تصرف</span><b><?= count($mine) ?> / <?= count($zones) ?></b></div>
      <div><span>درآمد دوره‌ای این مناطق</span><b><?= number_format(array_sum(array_map(fn($z) => ['0', 1500, 3000, 6000][$z['tier']] ?? 0, $mine))) ?>$</b></div>
    </div>
    <div class="dcardx" style="overflow-x:auto"><table class="utable"><tr><th>منطقه</th><th>تیر</th><th>گنگ مالک</th><th>از تاریخ</th></tr>
    <?php foreach ($zones as $z): ?>
      <tr<?= $z['owner'] === $myGang ? ' style="color:var(--gold,#e6b800)"' : '' ?>>
        <td><?= e($z['label']) ?></td><td><?= (int)$z['tier'] ?></td>
        <td><?= $z['owner'] ? e(gang_label($z['owner'])) : '<span class="mut">آزاد</span>' ?></td>
        <td><?= $z['captured_at'] ? e(date('Y/m/d H:i', $z['captured_at'])) : '—' ?></td>
      </tr>
    <?php endforeach; ?></table></div>

    <h3 style="margin-top:22px">اتحادها</h3>
    <div class="list"><?php foreach ($allies as $al):
      $other = $al['gang_a'] === $myGang ? $al['gang_b'] : $al['gang_a'];
      $incoming = $al['status'] === 'pending' && $al['gang_b'] === $myGang; ?>
      <div class="row"><b><?= e(gang_label($other)) ?></b>
        <span class="tag <?= $al['status'] === 'active' ? 'answered' : 'open' ?>"><?= $al['status'] === 'active' ? 'فعال' : ($incoming ? 'درخواست دریافتی' : 'در انتظار تایید طرف مقابل') ?></span>
        <?php if ($incoming && $isGangBoss): ?>
          <span style="display:inline-flex;gap:6px">
            <form method="post"><?= csrf_field() ?><input type="hidden" name="a" value="gally"><input type="hidden" name="id" value="<?= (int)$al['id'] ?>"><input type="hidden" name="act" value="accept"><button class="btn" style="padding:6px 12px">قبول</button></form>
            <form method="post"><?= csrf_field() ?><input type="hidden" name="a" value="gally"><input type="hidden" name="id" value="<?= (int)$al['id'] ?>"><input type="hidden" name="act" value="decline"><button class="btn no" style="padding:6px 12px">رد</button></form>
          </span>
        <?php endif; ?>
      </div>
    <?php endforeach; if (!$allies) echo '<p class="mut">هیچ اتحادی ثبت نشده. درخواست اتحاد از داخل بازی (ادمین گنگ) ثبت می‌شه.</p>'; ?></div>

    <h3 style="margin-top:22px">خصومت‌ها</h3>
    <?php $wars = gang_wars_of($myGang); ?>
    <div class="list"><?php foreach ($wars as $w): $other = $w['gang_a'] === $myGang ? $w['gang_b'] : $w['gang_a']; ?>
      <div class="row"><b><?= e(gang_label($other)) ?></b><span class="tag open">در جنگ</span>
        <?php if ($isGangBoss): ?><form method="post"><?= csrf_field() ?><input type="hidden" name="a" value="gwarend"><input type="hidden" name="id" value="<?= (int)$w['id'] ?>"><button class="btn" style="padding:6px 12px">پایان خصومت</button></form><?php endif; ?>
      </div>
    <?php endforeach; if (!$wars) echo '<p class="mut">این گنگ با هیچ گنگی در خصومت نیست.</p>'; ?></div>
    <?php if ($isGangBoss): ?>
      <form method="post" class="dcardx" style="display:flex;gap:8px;flex-wrap:wrap;align-items:end;margin-top:10px"><?= csrf_field() ?><input type="hidden" name="a" value="gwar">
        <label style="flex:1;min-width:180px">اعلام خصومت با
          <select name="target" required><option value="">— انتخاب گنگ —</option><?php foreach (other_gangs($myGang) as $og): ?><option value="<?= e($og['name']) ?>"><?= e($og['label'] ?: $og['name']) ?></option><?php endforeach; ?></select>
        </label>
        <button class="btn no" style="margin-bottom:4px" onclick="return confirm('مطمئنی؟ این یه اعلام خصومتِ رسمیه.')">اعلام خصومت</button>
      </form>
    <?php endif; ?>

  <?php elseif ($gt === 'leaderboard'): ?>
    <div class="dcardx" style="overflow-x:auto"><table class="utable"><tr><th>#</th><th>گنگ</th><th>سطح</th><th>XP</th><th>اعضا</th><th>قلمرو</th></tr>
    <?php foreach (gang_leaderboard(15) as $i => $gl): ?>
      <tr<?= $gl['name'] === $myGang ? ' style="color:var(--gold,#e6b800)"' : '' ?>><td><?= $i + 1 ?></td><td><?= e($gl['label'] ?: $gl['name']) ?></td><td><?= (int)$gl['level'] ?></td><td><?= number_format((int)$gl['xp']) ?></td><td><?= (int)$gl['member_count'] ?></td><td><?= (int)$gl['territory_count'] ?></td></tr>
    <?php endforeach; ?></table></div>

  <?php elseif ($gt === 'audit'): $auditRows = audit_of('gang', $myGang, 40); ?>
    <div class="list"><?php foreach ($auditRows as $ad): ?>
      <div class="row"><b><?= e($ad['action']) ?></b><small><?= e($ad['actor_name']) ?><?= $ad['target_name'] ? ' → ' . e($ad['target_name']) : '' ?><?= $ad['detail'] ? ' (' . e($ad['detail']) . ')' : '' ?></small><span class="mut"><?= date('Y/m/d H:i', (int)$ad['created']) ?></span></div>
    <?php endforeach; if (!$auditRows) echo '<p class="mut">هنوز اقدامی ثبت نشده.</p>'; ?></div>

  <?php elseif ($gt === 'tickets'): ?>
    <form method="post" class="dcardx"><?= csrf_field() ?><input type="hidden" name="a" value="new"><input type="hidden" name="scope" value="gang">
      <label>موضوع<input name="subject" maxlength="120" required></label>
      <label>توضیحات<textarea name="body" rows="4" maxlength="2000" required></textarea></label>
      <button class="btn pri">ارسال تیکت گنگ</button></form>
    <?php $q = $db->prepare('SELECT t.*,u.fullname FROM web_tickets t JOIN web_accounts u ON u.id=t.user_id WHERE t.gang=? ' . ($isGangBoss ? '' : 'AND t.user_id=? ') . 'ORDER BY t.id DESC LIMIT 100');
      $q->execute($isGangBoss ? [$myGang] : [$myGang, $u['id']]); $rows = $q->fetchAll(); ?>
    <div class="list"><?php foreach ($rows as $t): ?>
      <a class="row" href="dashboard.php?p=ticket&id=<?= (int)$t['id'] ?>"><b>#<?= (int)$t['id'] ?> <?= e($t['subject']) ?></b><small><?= e($t['fullname']) ?></small><span class="tag <?= e($t['status']) ?>"><?= $st[$t['status']] ?></span></a>
    <?php endforeach; if (!$rows) echo '<p class="mut">هنوز تیکتی برای گنگ ثبت نشده.</p>'; ?></div>
  <?php endif; ?>

<?php elseif ($p === 'org'):
  $jRow = job_row($myOrg); $members = job_members($myOrg);
  $oApps = $isOrgBoss ? apps_pending_for('org', $jRow['label'] ?? job_label($myOrg)) : [];
  $ot = $_GET['t'] ?? 'home';
  $isDoa = $myOrg === 'doa'; $isWeazel = $myOrg === 'weazel';
  $validOrgTabs = array_merge(['members', 'tickets', 'duty', 'audit'], $isLawOrg ? ['cases', 'more'] : [], $isDoa ? ['doa'] : [], $isWeazel ? ['news'] : []);
  $ot = in_array($ot, $validOrgTabs, true) ? $ot : 'home'; ?>
  <h2>پنل ارگان من — <?= e($jRow['label'] ?? job_label($myOrg)) ?></h2>
  <p class="lead">رتبه‌ی تو: <b><?= e(($myJobGrade['label'] ?? '') ?: ($myJobGrade['name'] ?? '—')) ?></b><?= $isOrgBoss ? ' · <span class="rolebadge">دسترسی باس (مدیریت کارمندان)</span>' : '' ?></p>
  <div class="tiles">
    <div><span>تعداد کارمندان</span><b><?= count($members) ?></b></div>
    <div><span>عضوگیری</span><b><?= (int)($jRow['whitelisted'] ?? 0) ? 'وایت‌لیست' : 'آزاد' ?></b></div>
    <?php if ($isLawOrg): ?><div><span>بازداشتی‌های ثبت‌شده</span><b><?= number_format(dept_booking_count($myOrg)) ?></b></div><?php endif; ?>
  </div>
  <div class="seg">
    <button class="<?= $ot === 'home' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org'">نمای کلی<?= $oApps ? ' (' . count($oApps) . ')' : '' ?></button>
    <button class="<?= $ot === 'members' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=members'">کارمندان (<?= count($members) ?>)</button>
    <?php if ($isLawOrg): ?><button class="<?= $ot === 'cases' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=cases'">پرونده‌های DOJ/Law</button><?php endif; ?>
    <?php if ($isLawOrg): ?><button class="<?= $ot === 'more' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=more'">افسری (رتبه‌بندی/K9/دادگاه)</button><?php endif; ?>
    <?php if ($isDoa): ?><button class="<?= $ot === 'doa' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=doa'">توقیف و خبرچین</button><?php endif; ?>
    <?php if ($isWeazel): ?><button class="<?= $ot === 'news' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=news'">انتشار خبر</button><?php endif; ?>
    <button class="<?= $ot === 'duty' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=duty'">لاگ حضور</button>
    <button class="<?= $ot === 'tickets' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=tickets'">تیکت‌های ارگان</button>
    <button class="<?= $ot === 'audit' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=audit'">لاگ اقدامات باس</button>
  </div>

  <?php if ($ot === 'home'): ?>
    <?php if ($isOrgBoss && $oApps): ?>
      <h3>درخواست‌های عضویت در انتظار (<?= count($oApps) ?>)</h3>
      <div class="list"><?php foreach ($oApps as $ap): ?>
        <div class="row"><b><?= e($ap['fullname']) ?></b><small><?= e(mb_substr($ap['body'], 0, 80)) ?></small>
          <span style="display:inline-flex;gap:6px">
            <form method="post"><?= csrf_field() ?><input type="hidden" name="a" value="oapp"><input type="hidden" name="id" value="<?= (int)$ap['id'] ?>"><input type="hidden" name="dec" value="accept"><button class="btn" style="padding:6px 12px">قبول</button></form>
            <form method="post"><?= csrf_field() ?><input type="hidden" name="a" value="oapp"><input type="hidden" name="id" value="<?= (int)$ap['id'] ?>"><input type="hidden" name="dec" value="reject"><button class="btn no" style="padding:6px 12px">رد</button></form>
          </span>
        </div>
      <?php endforeach; ?></div>
    <?php endif; ?>

    <h3>کارمندان برتر</h3>
    <div class="list"><?php foreach (array_slice($members, 0, 5) as $m): $mg = (int)$m['job_grade']; $lbl = (string)$mg;
      foreach ($jobGrades as $gr) if ((int)$gr['grade'] === $mg) { $lbl = ($gr['label'] ?: $gr['name']) ?: $lbl; break; } ?>
      <div class="row"><b><?= e(pname($m)) ?></b><span class="mut"><?= e($lbl) ?></span></div>
    <?php endforeach; if (!$members) echo '<p class="mut">کارمندی پیدا نشد.</p>'; ?></div>

    <?php if ($isLawOrg): $openCases = array_filter(dept_cases_of($myOrg), fn($c) => !in_array($c['status'], ['closed', 'dismissed'], true)); ?>
      <h3>پرونده‌های باز</h3>
      <p class="mut"><?= count($openCases) ?> پرونده‌ی باز مرتبط با این ارگان — <a href="dashboard.php?p=org&t=cases">مشاهده‌ی کامل</a></p>
    <?php endif; ?>

    <h3>آخرین تیکت‌های ارگان</h3>
    <?php $q = $db->prepare('SELECT * FROM web_tickets WHERE org_job=? ORDER BY id DESC LIMIT 3'); $q->execute([$myOrg]); $recentO = $q->fetchAll(); ?>
    <div class="list"><?php foreach ($recentO as $t): ?>
      <a class="row" href="dashboard.php?p=ticket&id=<?= (int)$t['id'] ?>"><b>#<?= (int)$t['id'] ?> <?= e($t['subject']) ?></b><span class="tag <?= e($t['status']) ?>"><?= $st[$t['status']] ?></span></a>
    <?php endforeach; if (!$recentO) echo '<p class="mut">هنوز تیکتی ثبت نشده.</p>'; ?></div>

  <?php elseif ($ot === 'members'): ?>
    <div class="dcardx" style="overflow-x:auto"><table class="utable"><tr><th>کاراکتر</th><th>رتبه</th><?= $isOrgBoss ? '<th>عملیات</th>' : '' ?></tr>
    <?php foreach ($members as $m): $mg = (int)$m['job_grade']; $lbl = (string)$mg;
      foreach ($jobGrades as $gr) if ((int)$gr['grade'] === $mg) { $lbl = ($gr['label'] ?: $gr['name']) ?: $lbl; break; }
      $isSelf = (string)$m['identifier'] === (string)($u['game']['identifier'] ?? '');
      $canAct = $isOrgBoss && !$isSelf && $mg < (int)$myJobGrade['grade']; ?>
      <tr><td><?= e(pname($m)) ?></td><td><?= e($lbl) ?> (<?= $mg ?>)</td>
      <?php if ($isOrgBoss): ?><td>
        <?php if ($canAct): ?>
          <form method="post" style="display:inline-flex;gap:6px;align-items:center;margin:0"><?= csrf_field() ?><input type="hidden" name="a" value="oset"><input type="hidden" name="ident" value="<?= e($m['identifier']) ?>">
            <select name="grade" style="width:auto;margin:0"><?php foreach ($jobGrades as $gr): if ((int)$gr['grade'] > (int)$myJobGrade['grade']) continue; ?><option value="<?= (int)$gr['grade'] ?>" <?= $mg === (int)$gr['grade'] ? 'selected' : '' ?>><?= e(($gr['label'] ?: $gr['name']) ?: (string)$gr['grade']) ?></option><?php endforeach; ?></select>
            <button class="btn" style="padding:6px 12px;margin:0">ثبت</button></form>
          <form method="post" onsubmit="return confirm('این کارمند اخراج بشه؟')" style="display:inline"><?= csrf_field() ?><input type="hidden" name="a" value="ofire"><input type="hidden" name="ident" value="<?= e($m['identifier']) ?>"><button class="btn no" style="padding:6px 12px;margin-inline-start:6px">اخراج</button></form>
        <?php else: ?><span class="mut">—</span><?php endif; ?>
      </td><?php endif; ?></tr>
    <?php endforeach; if (!$members) echo '<tr><td colspan="3" class="mut">کارمندی پیدا نشد.</td></tr>'; ?></table></div>

  <?php elseif ($ot === 'cases' && $isLawOrg):
    $isIaOrg = in_array($myOrg, ['cia', 'fbi'], true);
    $cc = $_GET['cc'] ?? 'referred'; $ccTabs = $isIaOrg ? ['referred', 'crime', 'bookings', 'ia'] : ['referred', 'crime', 'bookings']; $cc = in_array($cc, $ccTabs, true) ? $cc : 'referred'; ?>
    <div class="seg">
      <button class="<?= $cc === 'referred' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=cases&cc=referred'">پرونده‌های ارجاعی</button>
      <button class="<?= $cc === 'crime' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=cases&cc=crime'">تحقیقات صحنه‌جرم</button>
      <button class="<?= $cc === 'bookings' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=cases&cc=bookings'">رپ‌شیت / بازداشتی‌ها</button>
      <?php if ($isIaOrg): ?><button class="<?= $cc === 'ia' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=cases&cc=ia'">بازرسی داخلی (IA)</button><?php endif; ?>
    </div>

    <?php if ($cc === 'referred'): $cases = dept_cases_of($myOrg);
      $statusFa = ['open' => 'باز', 'investigating' => 'در حال بررسی', 'trial' => 'در دادگاه', 'closed' => 'بسته‌شده', 'dismissed' => 'رد شده'];
      $prioFa = ['low' => 'کم', 'medium' => 'متوسط', 'high' => 'بالا']; ?>
      <div class="list"><?php foreach ($cases as $c): $charges = dept_case_charges((int)$c['id']); ?>
        <details class="dcardx" style="margin-bottom:10px">
          <summary style="cursor:pointer;display:flex;flex-wrap:wrap;gap:10px;align-items:center">
            <b>#<?= (int)$c['id'] ?> <?= e($c['title']) ?></b>
            <span class="tag <?= $c['status'] === 'closed' || $c['status'] === 'dismissed' ? 'closed' : ($c['status'] === 'trial' ? 'answered' : 'open') ?>"><?= $statusFa[$c['status']] ?? e($c['status']) ?></span>
            <span class="mut">اولویت: <?= $prioFa[$c['priority']] ?? e($c['priority']) ?></span>
            <?php if ($c['referred_to'] && $c['referred_to'] !== $myOrg): ?><span class="mut">ارجاع به: <?= e(job_label($c['referred_to'])) ?></span><?php endif; ?>
          </summary>
          <p class="mut" style="margin-top:10px">افسر مسئول: <?= e($c['lead_officer_name']) ?> · ثبت‌شده توسط <?= e(job_label($c['opened_by_job'])) ?></p>
          <?php if ($charges): ?><p><b>اتهامات:</b></p><ul><?php foreach ($charges as $ch): ?><li><?= e($ch['law_code']) ?> — <?= e($ch['law_title']) ?> (جزای نقدی: <?= number_format((int)$ch['fine']) ?>$, حبس: <?= (int)$ch['jail_minutes'] ?> دقیقه)</li><?php endforeach; ?></ul><?php endif; ?>
        </details>
      <?php endforeach; if (!$cases) echo '<p class="mut">پرونده‌ای برای این ارگان ثبت نشده.</p>'; ?></div>

    <?php elseif ($cc === 'crime'): $ccases = crime_cases_of($myOrg);
      $csFa = ['open' => 'باز', 'cold' => 'سرد شده', 'referred_judge' => 'ارجاع به قاضی', 'referred_cia' => 'ارجاع به CIA', 'referred_fbi' => 'ارجاع به FBI', 'closed' => 'بسته‌شده'];
      $warFa = ['none' => 'ندارد', 'requested' => 'درخواست‌شده', 'approved' => 'تاییدشده', 'denied' => 'ردشده']; ?>
      <div class="list"><?php foreach ($ccases as $c): $ev = crime_case_evidence((int)$c['id']); $notes = crime_case_notes((int)$c['id']); ?>
        <details class="dcardx" style="margin-bottom:10px">
          <summary style="cursor:pointer;display:flex;flex-wrap:wrap;gap:10px;align-items:center">
            <b>#<?= (int)$c['id'] ?> سرقت از <?= e($c['rob_name']) ?></b>
            <span class="tag <?= $c['status'] === 'closed' ? 'closed' : ($c['status'] === 'cold' ? 'open' : 'answered') ?>"><?= $csFa[$c['status']] ?? e($c['status']) ?></span>
            <span class="mut">حکم بازداشت: <?= $warFa[$c['warrant_status']] ?? e($c['warrant_status']) ?></span>
          </summary>
          <p class="mut" style="margin-top:10px">مشکوک اصلی: <?= e($c['suspect_name'] ?: 'شناسایی‌نشده') ?><?= $c['closed_by_name'] ? ' · بسته‌شده توسط ' . e($c['closed_by_name']) : '' ?></p>
          <?php if ($ev): ?><p><b>شواهد:</b></p><ul><?php foreach ($ev as $e2): ?><li>[<?= e($e2['type']) ?>] <?= e($e2['content']) ?><?= $e2['plate'] ? ' — پلاک: ' . e($e2['plate']) : '' ?> <span class="mut">(ثبت توسط <?= e($e2['found_by_name']) ?>)</span></li><?php endforeach; ?></ul><?php endif; ?>
          <?php if ($notes): ?><p><b>یادداشت‌های تحقیق:</b></p><ul><?php foreach ($notes as $n): ?><li><?= e($n['note']) ?> <span class="mut">— <?= e($n['author_name']) ?></span></li><?php endforeach; ?></ul><?php endif; ?>
        </details>
      <?php endforeach; if (!$ccases) echo '<p class="mut">پرونده‌ی تحقیقاتی‌ای برای این ارگان پیدا نشد.</p>'; ?></div>

    <?php elseif ($cc === 'bookings'): $books = dept_bookings_of($myOrg); ?>
      <div class="dcardx" style="overflow-x:auto"><table class="utable"><tr><th>مشکوک</th><th>اتهامات</th><th>جزای نقدی</th><th>حبس (دقیقه)</th><th>بازداشت‌کننده</th><th>تاریخ</th></tr>
      <?php foreach ($books as $b): ?>
        <tr><td><?= e($b['suspect_name']) ?></td><td><?= e($b['charges']) ?></td><td><?= number_format((int)$b['fine']) ?>$</td><td><?= (int)$b['jail_minutes'] ?></td><td><?= e($b['booked_by_name']) ?></td><td><?= e($b['created_at']) ?></td></tr>
      <?php endforeach; if (!$books) echo '<tr><td colspan="6" class="mut">بازداشتی‌ای ثبت نشده.</td></tr>'; ?></table></div>

    <?php elseif ($cc === 'ia' && $isIaOrg): $iaR = ia_reports_all();
      $iaStFa = ['open' => 'باز', 'reviewing' => 'در حال بررسی', 'cleared' => 'تبرئه‌شده', 'disciplined' => 'انضباطی اعمال‌شده'];
      $iaCatFa = ['shooting' => 'تیراندازی', 'wrongful_arrest' => 'بازداشت غیرقانونی', 'excessive_force' => 'استفاده‌ی بیش‌ازحد از زور', 'booking_abuse' => 'سوءاستفاده در بازداشت', 'other' => 'سایر']; ?>
      <div class="list"><?php foreach ($iaR as $r): ?>
        <details class="dcardx" style="margin-bottom:10px">
          <summary style="cursor:pointer;display:flex;flex-wrap:wrap;gap:10px;align-items:center">
            <b>#<?= (int)$r['id'] ?> <?= e($r['target_name']) ?> (<?= e(job_label((string)$r['target_job'])) ?>)</b>
            <span class="tag <?= $r['status'] === 'disciplined' ? 'closed' : ($r['status'] === 'cleared' ? 'answered' : 'open') ?>"><?= $iaStFa[$r['status']] ?? e($r['status']) ?></span>
            <span class="mut"><?= $iaCatFa[$r['category']] ?? e($r['category']) ?></span>
          </summary>
          <p style="margin-top:10px"><?= e($r['description']) ?></p>
          <p class="mut">ثبت‌شده توسط <?= e($r['filed_by_name']) ?><?= $r['reviewed_by_name'] ? ' · بازبینی توسط ' . e($r['reviewed_by_name']) : '' ?></p>
          <?php if ($r['verdict']): ?><p><b>رأی نهایی:</b> <?= e($r['verdict']) ?></p><?php endif; ?>
        </details>
      <?php endforeach; if (!$iaR) echo '<p class="mut">گزارش بازرسیِ داخلی‌ای ثبت نشده.</p>'; ?></div>
    <?php endif; ?>

  <?php elseif ($ot === 'more' && $isLawOrg):
    $isK9Org = in_array($myOrg, ['police', 'sheriff'], true); $isJudge = $myOrg === 'judge';
    $mc = $_GET['mc'] ?? 'perf'; $mcTabs = array_merge(['perf', 'mugshots'], $isJudge ? ['docket'] : [], ['traffic'], $isK9Org ? ['k9'] : []); $mc = in_array($mc, $mcTabs, true) ? $mc : 'perf'; ?>
    <div class="seg">
      <button class="<?= $mc === 'perf' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=more&mc=perf'">رتبه‌بندی افسرها</button>
      <button class="<?= $mc === 'mugshots' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=more&mc=mugshots'">دیوار مچ‌شات</button>
      <?php if ($isJudge): ?><button class="<?= $mc === 'docket' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=more&mc=docket'">تقویم دادگاه</button><?php endif; ?>
      <button class="<?= $mc === 'traffic' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=more&mc=traffic'">توقف‌های ترافیکی</button>
      <?php if ($isK9Org): ?><button class="<?= $mc === 'k9' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=more&mc=k9'">سگ‌های K9</button><?php endif; ?>
    </div>

    <?php if ($mc === 'perf'): ?>
      <div class="dcardx" style="overflow-x:auto"><table class="utable"><tr><th>افسر</th><th>بازداشت</th><th>توقف ترافیکی</th><th>امتیاز</th></tr>
      <?php foreach (officer_leaderboard($myOrg, 15) as $o): ?><tr><td><?= e(pname($o)) ?></td><td><?= (int)$o['bookings'] ?></td><td><?= (int)$o['stops'] ?></td><td><b><?= (int)$o['score'] ?></b></td></tr><?php endforeach; ?></table></div>

    <?php elseif ($mc === 'mugshots'): ?>
      <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(140px,1fr));gap:12px">
        <?php foreach (mugshots_all(24) as $ms): ?>
          <div class="dcardx" style="text-align:center;padding:10px"><img src="<?= e($ms['photo_url']) ?>" alt="" style="width:100%;aspect-ratio:1;object-fit:cover;border-radius:10px"><p style="margin:6px 0 0;font-size:.85em"><?= e($ms['name']) ?></p></div>
        <?php endforeach; if (!mugshots_all(1)) echo '<p class="mut">مچ‌شاتی ثبت نشده.</p>'; ?>
      </div>

    <?php elseif ($mc === 'docket' && $isJudge): $verdictFa = ['guilty' => 'مقصر', 'not_guilty' => 'بی‌گناه', 'plea_deal' => 'توافق اتهام']; $dstFa = ['scheduled' => 'زمان‌بندی‌شده', 'held' => 'برگزار شد', 'rescheduled' => 'زمان‌بندی مجدد', 'cancelled' => 'لغو شد']; ?>
      <div class="list"><?php foreach (court_docket(30) as $d): ?>
        <div class="row"><b><?= e($d['case_title']) ?></b><small><?= date('Y/m/d H:i', (int)$d['scheduled_at']) ?></small>
          <span class="tag <?= $d['status'] === 'held' ? 'answered' : ($d['status'] === 'cancelled' ? 'closed' : 'open') ?>"><?= $dstFa[$d['status']] ?? e($d['status']) ?></span>
          <?php if ($d['verdict']): ?><span class="mut">رأی: <?= $verdictFa[$d['verdict']] ?? e($d['verdict']) ?></span><?php endif; ?>
        </div>
      <?php endforeach; if (!court_docket(1)) echo '<p class="mut">جلسه‌ای ثبت نشده.</p>'; ?></div>

    <?php elseif ($mc === 'traffic'): ?>
      <div class="dcardx" style="overflow-x:auto"><table class="utable"><tr><th>شهروند</th><th>دلیل</th><th>نتیجه</th><th>افسر</th><th>تاریخ</th></tr>
      <?php $outFa = ['warning' => 'اخطار', 'citation' => 'جریمه', 'search' => 'بازرسی', 'escalated' => 'تشدید شد'];
      foreach (traffic_stops_of($myOrg, 30) as $ts): ?><tr><td><?= e($ts['citizen_name']) ?></td><td><?= e($ts['reason']) ?></td><td><?= $outFa[$ts['outcome']] ?? e($ts['outcome']) ?></td><td><?= e($ts['officer_name']) ?></td><td><?= date('Y/m/d', (int)$ts['timestamp']) ?></td></tr>
      <?php endforeach; if (!traffic_stops_of($myOrg, 1)) echo '<tr><td colspan="5" class="mut">توقفی ثبت نشده.</td></tr>'; ?></table></div>

    <?php elseif ($mc === 'k9' && $isK9Org): ?>
      <div class="list"><?php foreach (k9_list() as $dog): $dd = $dog['parsed']; ?>
        <div class="row"><b><?= e($dd['name'] ?? 'K9 #' . $dog['id']) ?></b><span class="mut"><?= e($dd['breed'] ?? '') ?></span></div>
      <?php endforeach; if (!k9_list()) echo '<p class="mut">سگی ثبت نشده.</p>'; ?></div>
    <?php endif; ?>

  <?php elseif ($ot === 'doa' && $isDoa): $dc = $_GET['dc'] ?? 'seizures'; $dc = in_array($dc, ['seizures', 'informants'], true) ? $dc : 'seizures'; ?>
    <div class="seg">
      <button class="<?= $dc === 'seizures' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=doa&dc=seizures'">توقیفی‌ها</button>
      <button class="<?= $dc === 'informants' ? 'on' : '' ?>" onclick="location='dashboard.php?p=org&t=doa&dc=informants'">خبرچین‌ها</button>
    </div>
    <?php if ($dc === 'seizures'): ?>
      <div class="dcardx" style="overflow-x:auto"><table class="utable"><tr><th>کالا</th><th>مقدار</th><th>ارزش تخمینی</th><th>افسر</th><th>تاریخ</th></tr>
      <?php foreach (doa_seizures(30) as $sz): ?><tr><td><?= e($sz['item_label']) ?></td><td><?= (int)$sz['quantity'] ?></td><td><?= number_format((int)$sz['est_value']) ?>$</td><td><?= e($sz['officer_name']) ?></td><td><?= date('Y/m/d', (int)$sz['timestamp']) ?></td></tr>
      <?php endforeach; if (!doa_seizures(1)) echo '<tr><td colspan="5" class="mut">توقیفی‌ای ثبت نشده.</td></tr>'; ?></table></div>
    <?php else: ?>
      <div class="list"><?php foreach (doa_informants() as $inf): ?>
        <div class="row"><b><?= e($inf['codename']) ?></b><small>ثبت‌شده توسط <?= e($inf['registered_by']) ?></small><span class="mut"><?= (int)$inf['tip_count'] ?> سرنخ · <?= number_format((int)$inf['total_paid']) ?>$ پرداختی</span></div>
      <?php endforeach; if (!doa_informants()) echo '<p class="mut">خبرچینی ثبت نشده.</p>'; ?></div>
    <?php endif; ?>

  <?php elseif ($ot === 'news' && $isWeazel): ?>
    <?php if ($isOrgBoss): ?>
      <form method="post" class="dcardx"><?= csrf_field() ?><input type="hidden" name="a" value="news_post">
        <label>عنوان خبر<input name="title" maxlength="120" required></label>
        <label>لینک عکس (اختیاری)<input name="image_url" type="url" placeholder="https://..."></label>
        <label>متن خبر<textarea name="body" rows="5" maxlength="4000" required></textarea></label>
        <button class="btn pri">انتشار در گالریِ سایت</button></form>
    <?php endif; ?>
    <div class="list"><?php foreach (news_list(20) as $n): ?>
      <div class="row"><b><?= e($n['title']) ?></b><small><?= e($n['author_name']) ?> · <?= date('Y/m/d', (int)$n['created']) ?></small>
        <?php if ($admin): ?><form method="post" onsubmit="return confirm('این خبر حذف بشه؟')"><?= csrf_field() ?><input type="hidden" name="a" value="news_del"><input type="hidden" name="id" value="<?= (int)$n['id'] ?>"><button class="btn no" style="padding:6px 12px">حذف</button></form><?php endif; ?>
      </div>
    <?php endforeach; if (!news_list(1)) echo '<p class="mut">هنوز خبری منتشر نشده.</p>'; ?></div>

  <?php elseif ($ot === 'duty'): ?>
    <div class="dcardx" style="overflow-x:auto"><table class="utable"><tr><th>کاراکتر</th><th>رتبه</th><th>مدت (دقیقه)</th><th>تاریخ</th></tr>
    <?php foreach (duty_recent($myOrg, 30) as $dl): ?><tr><td><?= e($dl['ic_name']) ?></td><td><?= e($dl['job_grade']) ?></td><td><?= round((int)$dl['total_time'] / 60) ?></td><td><?= e($dl['date']) ?></td></tr><?php endforeach; if (!duty_recent($myOrg, 1)) echo '<tr><td colspan="4" class="mut">لاگ حضوری ثبت نشده.</td></tr>'; ?></table></div>

  <?php elseif ($ot === 'audit'): $orgAudit = audit_of('org', $myOrg, 40); ?>
    <div class="list"><?php foreach ($orgAudit as $ad): ?>
      <div class="row"><b><?= e($ad['action']) ?></b><small><?= e($ad['actor_name']) ?><?= $ad['target_name'] ? ' → ' . e($ad['target_name']) : '' ?><?= $ad['detail'] ? ' (' . e($ad['detail']) . ')' : '' ?></small><span class="mut"><?= date('Y/m/d H:i', (int)$ad['created']) ?></span></div>
    <?php endforeach; if (!$orgAudit) echo '<p class="mut">هنوز اقدامی ثبت نشده.</p>'; ?></div>

  <?php elseif ($ot === 'tickets'): ?>
    <form method="post" class="dcardx"><?= csrf_field() ?><input type="hidden" name="a" value="new"><input type="hidden" name="scope" value="org">
      <label>موضوع<input name="subject" maxlength="120" required></label>
      <label>توضیحات<textarea name="body" rows="4" maxlength="2000" required></textarea></label>
      <button class="btn pri">ارسال تیکت ارگان</button></form>
    <?php $q = $db->prepare('SELECT t.*,u.fullname FROM web_tickets t JOIN web_accounts u ON u.id=t.user_id WHERE t.org_job=? ' . ($isOrgBoss ? '' : 'AND t.user_id=? ') . 'ORDER BY t.id DESC LIMIT 100');
      $q->execute($isOrgBoss ? [$myOrg] : [$myOrg, $u['id']]); $rows = $q->fetchAll(); ?>
    <div class="list"><?php foreach ($rows as $t): ?>
      <a class="row" href="dashboard.php?p=ticket&id=<?= (int)$t['id'] ?>"><b>#<?= (int)$t['id'] ?> <?= e($t['subject']) ?></b><small><?= e($t['fullname']) ?></small><span class="tag <?= e($t['status']) ?>"><?= $st[$t['status']] ?></span></a>
    <?php endforeach; if (!$rows) echo '<p class="mut">هنوز تیکتی برای ارگان ثبت نشده.</p>'; ?></div>
  <?php endif; ?>

<?php elseif ($p === 'apply'): $T = apply_targets(); $sel = ($_POST['target'] ?? '') ?: (($_GET['kind'] ?? '') . ':' . ($_GET['target'] ?? '')); ?>
  <h2>ثبت درخواست عضویت</h2><p class="lead">فرم رو با دقت پر کن؛ مدیریت درخواستت رو بررسی می‌کنه و نتیجه تو همین داشبورد نمایش داده می‌شه.</p>
  <form method="post" class="dcardx"><?= csrf_field() ?><input type="hidden" name="a" value="apply">
    <div class="fgrid">
      <label class="full">می‌خوای به کجا بپیوندی؟
        <select name="target" required>
          <?php if ($T['gang']): ?><optgroup label="گنگ‌ها (عضوگیری باز)"><?php foreach ($T['gang'] as $g): ?><option value="gang:<?= e($g) ?>" <?= $sel === "gang:$g" ? 'selected' : '' ?>><?= e($g) ?></option><?php endforeach; ?></optgroup><?php endif; ?>
          <?php foreach ($T['org'] as $gk => $ls): ?><optgroup label="<?= e(CFG['org_groups'][$gk]['label']) ?>"><?php foreach ($ls as $l): ?><option value="org:<?= e($l) ?>" <?= $sel === "org:$l" ? 'selected' : '' ?>><?= e($l) ?></option><?php endforeach; ?></optgroup><?php endforeach; ?>
        </select></label>
      <label class="full">پیش‌زمینه‌ی کاراکتر<textarea name="bg" required minlength="30" maxlength="1500" placeholder="داستان و شخصیت کاراکترت رو مختصر بنویس..."><?= e($_POST['bg'] ?? '') ?></textarea><span class="hint">حداقل ۳۰ حرف</span></label>
      <label class="full">چرا می‌خوای عضو این مجموعه بشی؟<textarea name="why" required minlength="20" maxlength="1500"><?= e($_POST['why'] ?? '') ?></textarea><span class="hint">حداقل ۲۰ حرف</span></label>
      <label>سوابق رول‌پلی (اختیاری)<input name="exp" maxlength="300" value="<?= e($_POST['exp'] ?? '') ?>" placeholder="مثلاً: ۳ ماه پلیس در سرور X"></label>
      <label>ساعت فعالیت روزانه<select name="hours"><?php foreach (['کمتر از ۲ ساعت', '۲ تا ۴ ساعت', '۴ تا ۶ ساعت', 'بیشتر از ۶ ساعت'] as $h): ?><option <?= ($_POST['hours'] ?? '') === $h ? 'selected' : '' ?>><?= $h ?></option><?php endforeach; ?></select></label>
    </div>
    <button class="btn pri">ارسال درخواست</button>
    <span class="hint" style="display:inline-block;margin-inline-start:12px">هر نفر حداکثر ۳ درخواست هم‌زمان می‌تونه داشته باشه.</span>
  </form>

<?php elseif ($p === 'apps'): ?>
  <h2>درخواست‌های من</h2><p class="lead">وضعیت همه‌ی درخواست‌هایی که ثبت کردی.</p>
  <?php $q = $db->prepare('SELECT * FROM web_apps WHERE user_id=? ORDER BY id DESC LIMIT 100'); $q->execute([$u['id']]); $n = 0;
  foreach ($q as $x) { app_card($x); $n++; }
  if (!$n) echo '<div class="empty2">هنوز درخواستی ثبت نکردی.<br><br><a class="btn pri" href="dashboard.php?p=apply">ثبت اولین درخواست</a></div>'; ?>

<?php elseif ($p === 'review' && $admin): $f = ($_GET['s'] ?? 'pending') === 'all' ? 'all' : 'pending'; ?>
  <h2>بررسی درخواست‌ها</h2><p class="lead">درخواست‌های عضویت گنگ‌ها و ارگان‌ها.</p>
  <div class="seg"><button class="<?= $f === 'pending' ? 'on' : '' ?>" onclick="location='dashboard.php?p=review'">در انتظار (<?= $revPend ?>)</button><button class="<?= $f === 'all' ? 'on' : '' ?>" onclick="location='dashboard.php?p=review&s=all'">همه</button></div>
  <?php $q = $db->query('SELECT a.*,u.fullname FROM web_apps a JOIN web_accounts u ON u.id=a.user_id ' . ($f === 'pending' ? "WHERE a.status='pending' " : '') . 'ORDER BY a.id DESC LIMIT 100'); $n = 0;
  foreach ($q as $x) { app_card($x, true, false); $n++; }
  if (!$n) echo '<div class="empty2">درخواستی برای نمایش نیست 🎉</div>'; ?>

<?php elseif ($p === 'users' && $admin): $qs = trim($_GET['q'] ?? ''); $lk = '%' . addcslashes($qs, '%_\\') . '%'; ?>
  <h2>حساب‌های بازی</h2><p class="lead">فهرست حساب‌های Unique_Login و کاراکتر وصل‌شده به هرکدوم. حساب فقط داخل بازی ساخته می‌شه.</p>
  <form class="dcardx" method="get" style="display:flex;gap:10px;flex-wrap:wrap"><input type="hidden" name="p" value="users"><input name="q" value="<?= e($qs) ?>" placeholder="جستجوی نام کاربری یا اسم کاراکتر" style="flex:1;min-width:200px"><button class="btn pri">جستجو</button></form>
  <div class="dcardx" style="overflow-x:auto"><table class="utable"><tr><th>نام کاربری</th><th>کاراکتر</th><th>رنک</th><th>موبایل</th><th>وضعیت</th><th>ساخت</th></tr>
  <?php try { $uq = $db->prepare('SELECT l.username,l.phone,l.security_hold,l.created_at,c.playerName,c.permission_level FROM login_users l LEFT JOIN users c ON c.identifier=l.device_license ' . ($qs !== '' ? 'WHERE l.username LIKE ? OR c.playerName LIKE ? ' : '') . 'ORDER BY l.id DESC LIMIT 200'); $uq->execute($qs !== '' ? [$lk, $lk] : []); $rows = $uq->fetchAll();
    } catch (Throwable $e) { $uq = $db->prepare('SELECT username,phone,security_hold,created_at FROM login_users ' . ($qs !== '' ? 'WHERE username LIKE ? ' : '') . 'ORDER BY id DESC LIMIT 200'); $uq->execute($qs !== '' ? [$lk] : []); $rows = $uq->fetchAll(); }
  foreach ($rows as $x): $pl = (int)($x['permission_level'] ?? 0); ?>
    <tr><td dir="ltr"><?= e($x['username']) ?></td><td dir="ltr"><?= e($x['playerName'] ?? '—') ?></td><td><?= $pl >= (int)CFG['team_min_perm'] ? '<span class="rolebadge" style="margin:0">' . e(rank_label($pl)) . '</span>' : ($pl > 0 ? 'Staff' : 'شهروند') ?></td>
      <td dir="ltr"><?= $x['phone'] ? e('0' . substr($x['phone'], 0, 3) . '***' . substr($x['phone'], -4)) : '—' ?></td><td><?= (int)$x['security_hold'] ? '<span class="tag rejected">قفل امنیتی</span>' : 'عادی' ?></td><td><?= e(date('Y/m/d', (int)strtotime((string)$x['created_at']))) ?></td></tr>
  <?php endforeach; if (!$rows) echo '<tr><td colspan="6" class="mut">حسابی پیدا نشد.</td></tr>'; ?></table></div>

<?php elseif ($p === 'logs' && $admin): $lc = trim($_GET['c'] ?? ''); $lj = trim($_GET['j'] ?? ''); $lq = trim($_GET['q'] ?? ''); $logs = admin_logs($lc, $lj, $lq, 80); ?>
  <h2>لاگ‌های سرور</h2><p class="lead">همه‌ی لاگ‌های ثبت‌شده توسط ریسورس <code>logs</code> (جدول <code>unique_logpanel</code>)، در یک‌جا.</p>
  <form method="get" class="dcardx" style="display:flex;gap:10px;flex-wrap:wrap"><input type="hidden" name="p" value="logs">
    <select name="c" style="width:auto"><option value="">همه‌ی دسته‌ها</option><?php foreach (admin_log_categories() as $cat): ?><option value="<?= e($cat) ?>" <?= $lc === $cat ? 'selected' : '' ?>><?= e($cat) ?></option><?php endforeach; ?></select>
    <select name="j" style="width:auto"><option value="">همه‌ی ارگان‌ها</option><?php foreach (admin_log_jobs() as $jb): ?><option value="<?= e($jb) ?>" <?= $lj === $jb ? 'selected' : '' ?>><?= e(job_label($jb)) ?></option><?php endforeach; ?></select>
    <input name="q" value="<?= e($lq) ?>" placeholder="جستجو در عنوان/متن/نام بازیکن" style="flex:1;min-width:200px">
    <button class="btn pri">فیلتر</button>
  </form>
  <div class="list"><?php foreach ($logs as $lg): ?>
    <div class="row"><b><?= $lg['pinned'] ? '📌 ' : '' ?><?= e($lg['title'] ?: $lg['category']) ?></b>
      <small><?= e($lg['category']) ?><?= $lg['job'] ? ' · ' . e(job_label($lg['job'])) : '' ?><?= $lg['player_name'] ? ' · ' . e($lg['player_name']) : '' ?> · <?= e($lg['created_at']) ?></small>
      <span class="mut" style="flex-basis:100%;margin-top:4px"><?= e(mb_substr((string)$lg['message'], 0, 200)) ?></span>
    </div>
  <?php endforeach; if (!$logs) echo '<p class="mut">لاگی با این فیلتر پیدا نشد.</p>'; ?></div>

<?php elseif ($p === 'growth' && $admin): $gs = growth_series(14); ?>
  <h2>رشد سایت</h2><p class="lead">تعداد حساب/تیکت/درخواستِ جدید در ۱۴ روز اخیر.</p>
  <div class="dcardx" style="overflow-x:auto"><table class="utable"><tr><th>تاریخ</th><th>حساب جدید</th><th>تیکت جدید</th><th>درخواست جدید</th></tr>
  <?php foreach ($gs as $row): ?><tr><td><?= e($row['day']) ?></td><td><?= (int)$row['users'] ?></td><td><?= (int)$row['tickets'] ?></td><td><?= (int)$row['apps'] ?></td></tr><?php endforeach; ?>
  </table></div>

<?php elseif ($p === 'notif'): mark_notifs_read($u['id']); $notifs = notifications_for($u['id'], 30); ?>
  <h2>اعلان‌ها</h2>
  <div class="list"><?php foreach ($notifs as $n): ?>
    <a class="row" href="<?= e($n['link'] ?: 'dashboard.php') ?>"><b><?= e($n['message']) ?></b><small><?= date('Y/m/d H:i', (int)$n['created']) ?></small></a>
  <?php endforeach; if (!$notifs) echo '<p class="mut">اعلانی نداری.</p>'; ?></div>

<?php elseif ($p === 'tickets'): ?>
  <h2>پشتیبانی (تیکت)</h2><p class="lead">برای سوال یا مشکل، از اینجا تیکت بفرست.</p>
  <form method="post" class="dcardx"><?= csrf_field() ?><input type="hidden" name="a" value="new">
    <label>موضوع<input name="subject" maxlength="120" required></label>
    <label>توضیحات<textarea name="body" rows="4" maxlength="2000" required></textarea></label>
    <button class="btn pri">ارسال تیکت</button></form>
  <?php $q = $db->prepare('SELECT t.*,u.fullname FROM web_tickets t JOIN web_accounts u ON u.id=t.user_id ' . ($admin ? '' : 'WHERE t.user_id=? ') . 'ORDER BY t.id DESC LIMIT 100');
        $q->execute($admin ? [] : [$u['id']]); $rows = $q->fetchAll(); ?>
  <div class="list"><?php foreach ($rows as $t): ?>
    <a class="row" href="dashboard.php?p=ticket&id=<?= (int)$t['id'] ?>"><b>#<?= (int)$t['id'] ?> <?= e($t['subject']) ?></b>
      <?= $admin ? '<small>' . e($t['fullname']) . '</small>' : '' ?><span class="tag <?= e($t['status']) ?>"><?= $st[$t['status']] ?></span></a>
  <?php endforeach; if (!$rows) echo '<p class="mut">هنوز تیکتی نساخته‌ای.</p>'; ?></div>

<?php elseif ($p === 'ticket' && ($t = ticket_of((int)($_GET['id'] ?? 0), $u))): ?>
  <h2>#<?= (int)$t['id'] ?> <?= e($t['subject']) ?> <span class="tag <?= e($t['status']) ?>"><?= $st[$t['status']] ?></span></h2>
  <?php $m = $db->prepare('SELECT m.*,u.fullname,u.role FROM web_msgs m JOIN web_accounts u ON u.id=m.user_id WHERE ticket_id=? ORDER BY m.id'); $m->execute([$t['id']]); ?>
  <div class="chat"><?php foreach ($m as $x): ?><div class="msg <?= $x['role'] === 'admin' ? 'staff' : '' ?>"><small><?= e($x['fullname']) ?> · <?= date('Y/m/d H:i', (int)$x['created']) ?></small><p><?= nl2br(e($x['body'])) ?></p></div><?php endforeach; ?></div>
  <?php if ($t['status'] !== 'closed'): ?>
  <form method="post" class="dcardx"><?= csrf_field() ?><input type="hidden" name="id" value="<?= (int)$t['id'] ?>">
    <textarea name="body" rows="3" maxlength="2000" required aria-label="پاسخ"></textarea>
    <div class="row-actions" style="margin-top:10px"><button class="btn pri" name="a" value="reply">ارسال پاسخ</button><button class="btn" name="a" value="close" formnovalidate>بستن تیکت</button></div></form>
  <?php endif; ?>

<?php elseif ($p === 'settings'): ?>
  <h2>تنظیمات</h2><p class="lead">رمز حساب بازی و سایت یکیه؛ اینجا عوضش کنی، داخل بازی هم همون معتبره.</p>
  <form method="post" class="dcardx" style="max-width:480px"><?= csrf_field() ?><input type="hidden" name="a" value="pass"><h3>تغییر رمز عبور</h3>
    <label>رمز عبور فعلی<input type="password" name="old" dir="ltr" required autocomplete="current-password"></label>
    <label>رمز عبور جدید<input type="password" name="new" dir="ltr" minlength="6" required autocomplete="new-password"></label><p class="hint">حداقل ۶ کاراکتر، شامل حداقل یک حرف انگلیسی و یک عدد.</p>
    <button class="btn pri">تغییر رمز عبور</button></form>
<?php else: go('dashboard.php'); endif; ?>
</main></div></body></html>
