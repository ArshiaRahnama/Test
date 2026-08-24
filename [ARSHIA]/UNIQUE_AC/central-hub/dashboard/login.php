<?php
declare(strict_types=1);
require_once __DIR__ . '/../lib/db.php';

session_start();
$error = null;

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST') {
    if (!hub_rate_limit('login:' . hub_client_ip(), 5, 60)) {
        $error = 'Too many attempts — wait a minute and try again.';
    } else {
        $password = (string)($_POST['password'] ?? '');
        if (hash_equals(HUB_ADMIN_PASSWORD, $password)) {
            $_SESSION['hub_admin'] = true;
            header('Location: index.html');
            exit;
        }
        $error = 'Wrong password.';
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>UNIQUE_AC Hub — Login</title>
<link rel="stylesheet" href="style.css">
</head>
<body class="login-body">
  <form class="login-card" method="post">
    <h1>UNIQUE<span>_AC</span> Hub</h1>
    <p class="sub">Multi-server dashboard</p>
    <?php if ($error): ?><div class="msg error"><?= htmlspecialchars($error) ?></div><?php endif; ?>
    <input type="password" name="password" placeholder="Dashboard password" autofocus required>
    <button type="submit">Sign in</button>
  </form>
</body>
</html>
