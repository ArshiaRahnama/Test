<?php
// API مخصوص اسکریپت‌های داخل بازی (FiveM/VMP). همه‌ی درخواست‌ها باید هدر X-Api-Key داشته باشن (CFG['api_key']).
//   POST api.php?a=issue_code    {username}  یا {identifier}      => {"ok":true,"code":"123456"}   (برای دستور /getcode)
//   GET  api.php?a=pending                                       => سفارش‌های تحویل‌نشده
//   POST api.php?a=delivered     {id}                            => علامت‌گذاری سفارش به‌عنوان تحویل‌شده
require __DIR__ . '/lib.php';
header('Content-Type: application/json; charset=utf-8');
$key = (string)CFG['api_key']; $sent = (string)($_SERVER['HTTP_X_API_KEY'] ?? '');
if ($key === '' || strlen($key) < 24 || !hash_equals($key, $sent)) { http_response_code(403); exit(json_encode(['ok' => false, 'error' => 'forbidden'])); }
$a = $_GET['a'] ?? ''; $db = db();
if ($a === 'issue_code' && $_SERVER['REQUEST_METHOD'] === 'POST') {
  $un = trim((string)($_POST['username'] ?? '')); $id = trim((string)($_POST['identifier'] ?? ''));
  if ($un !== '') { $q = $db->prepare('SELECT id FROM login_users WHERE username=?'); $q->execute([$un]); }
  else { $q = $db->prepare('SELECT id FROM login_users WHERE device_license=?'); $q->execute([$id]); }
  $lid = (int)$q->fetchColumn();
  if (!$lid) exit(json_encode(['ok' => false, 'error' => 'no_account']));
  exit(json_encode(['ok' => true, 'code' => code_issue($lid)]));
}
if ($a === 'pending') {
  $rows = $db->query("SELECT o.id,o.item_name,o.item_code,o.method,o.created,a.login_id,lu.device_license AS identifier FROM web_orders o JOIN web_accounts a ON a.id=o.user_id LEFT JOIN login_users lu ON lu.id=a.login_id WHERE o.status='pending' ORDER BY o.id LIMIT 100")->fetchAll();
  exit(json_encode(['ok' => true, 'orders' => $rows], JSON_UNESCAPED_UNICODE));
}
if ($a === 'delivered' && $_SERVER['REQUEST_METHOD'] === 'POST') {
  $s = $db->prepare("UPDATE web_orders SET status='delivered',delivered=? WHERE id=? AND status='pending'"); $s->execute([time(), (int)($_POST['id'] ?? 0)]);
  exit(json_encode(['ok' => $s->rowCount() > 0]));
}
http_response_code(400); echo json_encode(['ok' => false, 'error' => 'bad_request']);
