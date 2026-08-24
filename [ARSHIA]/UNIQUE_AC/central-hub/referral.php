<?php
declare(strict_types=1);
require_once __DIR__ . '/lib/db.php';

// Owner name is passed as a query param by whoever shares their link, e.g.
// referral.php?ref=Arshia — purely informational display, not tracked/stored
// anywhere (no cookies, no DB writes) to keep this page privacy-simple.
$ref = trim((string)($_GET['ref'] ?? ''));
$ref = $ref !== '' ? mb_substr(preg_replace('/[^\p{L}\p{N}_\- ]/u', '', $ref), 0, 40) : '';
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><?= htmlspecialchars(HUB_BRAND_NAME) ?> — Referral</title>
<link rel="stylesheet" href="dashboard/style.css">
<style>
  body { display: flex; align-items: center; justify-content: center; padding: 24px; }
  .page { max-width: 480px; text-align: center; padding: 36px; border: 1px solid var(--line); border-radius: 4px; background: var(--panel); }
  h1 { font-size: 24px; margin-bottom: 6px; } h1 span { color: var(--accent); }
  .ref-note { display: inline-block; margin: 14px 0 20px; padding: 8px 16px; border: 1px solid rgba(56,214,196,.35); border-radius: 999px; background: rgba(56,214,196,.08); color: var(--accent); font: 800 11px var(--font-mono); }
  p { color: var(--muted); font-size: 14px; line-height: 1.7; margin-bottom: 24px; }
  .cta { display: inline-block; padding: 15px 30px; background: var(--accent); color: #0A0D0C; text-decoration: none; border-radius: 4px; font: 800 12px var(--font-mono); text-transform: uppercase; letter-spacing: .05em; }
  .share-box { margin-top: 26px; padding: 14px; border: 1px dashed var(--line); border-radius: 4px; font-size: 11px; color: var(--muted); word-break: break-all; }
</style>
</head>
<body>
  <div class="page">
    <h1>UNIQUE<span>_AC</span></h1>
    <?php if ($ref !== ''): ?>
      <div class="ref-note">Referred by <?= htmlspecialchars($ref) ?></div>
    <?php endif; ?>
    <p>Security operations for FiveM roleplay servers — real-time anti-cheat, an admin panel built for actual moderation work, and a multi-server dashboard when you grow.</p>
    <a class="cta" href="<?= htmlspecialchars(HUB_BRAND_URL) ?>">Get UNIQUE_AC →</a>

    <div class="share-box">
      Already using UNIQUE_AC? Share your own link with other server owners:<br>
      <?= htmlspecialchars((HUB_BRAND_URL ?: '') . '/central-hub/referral.php?ref=YourName') ?>
    </div>
  </div>
</body>
</html>
