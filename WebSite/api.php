<?php
// API مخصوص اسکریپت‌های داخل بازی (FiveM/VMP). درخواست باید هدر X-Api-Key داشته باشد (CFG['api_key']).
//   POST api.php?a=issue_code    {username}  یا {identifier}      => {"ok":true,"code":"123456"}   (برای دستور /getcode)
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
http_response_code(400); echo json_encode(['ok' => false, 'error' => 'bad_request']);
