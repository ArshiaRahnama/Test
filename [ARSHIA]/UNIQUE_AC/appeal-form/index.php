<?php
declare(strict_types=1);

// ============================================================================
//  UNIQUE_AC — Ban Appeal Form (standalone, hosted separately from FiveM)
//  Developed by Arshia (arshiahub.ir)
//
//  This is a single PHP file, NOT part of the FiveM resource. Upload it to
//  your own web hosting (e.g. arshiahub.ir/appeal) and fill in the database
//  credentials below — it talks to the SAME MySQL database your FiveM server
//  uses, reading/writing the `uniqueac_banlist` and `uniqueac_appeals` tables.
//
//  Why a separate PHP file instead of the FiveM resource serving this itself:
//  FXServer only allows one active SetHttpHandler at a time server-wide, and
//  hijacking it risks silently breaking txAdmin or other resources that rely
//  on it. A normal PHP page on your existing web hosting avoids that entirely.
// ============================================================================

// ---- Fill these in ----
$DB_HOST = "127.0.0.1";
$DB_NAME = "your_database_name";
$DB_USER = "your_database_user";
$DB_PASS = "your_database_password";
// ------------------------

$error = null;
$notice = null;
$banInfo = null;
$step = "lookup"; // "lookup" -> "appeal" -> "done"

function db(): PDO {
    global $DB_HOST, $DB_NAME, $DB_USER, $DB_PASS;
    static $pdo = null;
    if ($pdo === null) {
        $pdo = new PDO(
            "mysql:host={$DB_HOST};dbname={$DB_NAME};charset=utf8mb4",
            $DB_USER,
            $DB_PASS,
            [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION, PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC]
        );
    }
    return $pdo;
}

function cleanIdentifier(string $raw): string {
    $raw = trim($raw);
    // Accept either a bare license hash or a full "license:xxxx" identifier.
    if (preg_match('/^[a-f0-9]{40}$/i', $raw)) {
        return "license:" . strtolower($raw);
    }
    return $raw;
}

try {
    if (($_SERVER["REQUEST_METHOD"] ?? "GET") === "POST" && isset($_POST["action"])) {

        if ($_POST["action"] === "lookup") {
            $identifier = cleanIdentifier((string)($_POST["identifier"] ?? ""));
            if ($identifier === "") {
                $error = "Please enter your license identifier.";
            } else {
                $stmt = db()->prepare("SELECT BANID, PLAYER_NAME, REASON FROM uniqueac_banlist WHERE LICENSE = :id ORDER BY id DESC LIMIT 1");
                $stmt->execute([":id" => $identifier]);
                $ban = $stmt->fetch();

                if (!$ban) {
                    $error = "No active ban found for that identifier.";
                } else {
                    $pending = db()->prepare("SELECT id FROM uniqueac_appeals WHERE ban_id = :bid AND status = 'pending' LIMIT 1");
                    $pending->execute([":bid" => $ban["BANID"]]);
                    if ($pending->fetch()) {
                        $notice = "You already have a pending appeal for this ban. Please wait for staff to review it.";
                        $step = "done";
                    } else {
                        $banInfo = $ban;
                        $banInfo["identifier"] = $identifier;
                        $step = "appeal";
                    }
                }
            }
        }

        if ($_POST["action"] === "submit") {
            $identifier = cleanIdentifier((string)($_POST["identifier"] ?? ""));
            $banId = (int)($_POST["ban_id"] ?? 0);
            $message = trim((string)($_POST["message"] ?? ""));
            $playerName = trim((string)($_POST["player_name"] ?? ""));

            if ($identifier === "" || $banId <= 0) {
                $error = "Something went wrong — please start over.";
            } elseif (mb_strlen($message) < 20) {
                $error = "Please write a bit more detail in your appeal (at least 20 characters).";
                $banInfo = ["BANID" => $banId, "identifier" => $identifier, "PLAYER_NAME" => $playerName];
                $step = "appeal";
            } elseif (mb_strlen($message) > 2000) {
                $error = "Your appeal is too long — please keep it under 2000 characters.";
                $banInfo = ["BANID" => $banId, "identifier" => $identifier, "PLAYER_NAME" => $playerName];
                $step = "appeal";
            } else {
                $pending = db()->prepare("SELECT id FROM uniqueac_appeals WHERE ban_id = :bid AND status = 'pending' LIMIT 1");
                $pending->execute([":bid" => $banId]);
                if ($pending->fetch()) {
                    $notice = "You already have a pending appeal for this ban.";
                    $step = "done";
                } else {
                    $ins = db()->prepare("INSERT INTO uniqueac_appeals (identifier, player_name, ban_id, message) VALUES (:id, :name, :bid, :msg)");
                    $ins->execute([":id" => $identifier, ":name" => $playerName ?: null, ":bid" => $banId, ":msg" => $message]);
                    $notice = "Your appeal has been submitted. Staff will review it soon.";
                    $step = "done";
                }
            }
        }
    }
} catch (Throwable $e) {
    $error = "A technical error occurred. Please try again later.";
    // Don't leak $e->getMessage() to visitors — check your server logs instead.
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>UNIQUE_AC — Ban Appeal</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@600;700&family=Inter:wght@400;600;800&display=swap');
  :root { --bg:#07090A; --panel:#0d1110; --line:rgba(255,255,255,.10); --accent:#38D6C0; --accent-2:#F5A623; --danger:#E4483A; --text:#EAF1EF; --muted:#7C8A90; }
  * { box-sizing: border-box; }
  body { margin:0; min-height:100vh; display:flex; align-items:center; justify-content:center; padding:24px; background:radial-gradient(circle at 15% 10%, rgba(56,214,196,.10), transparent 30%), radial-gradient(circle at 90% 90%, rgba(245,166,35,.07), transparent 34%), #050706; color:var(--text); font-family:Inter,system-ui,sans-serif; }
  .card { width:100%; max-width:520px; border:1px solid var(--line); border-radius:4px; background:var(--panel); padding:32px; }
  h1 { font:700 22px Inter,sans-serif; margin:0 0 6px; }
  h1 span { color:var(--accent); }
  .sub { color:var(--muted); font-size:13px; margin:0 0 24px; }
  label { display:block; font:700 11px "IBM Plex Mono",monospace; text-transform:uppercase; letter-spacing:.08em; color:var(--muted); margin-bottom:8px; }
  input, textarea { width:100%; padding:12px 14px; border:1px solid var(--line); border-radius:4px; background:rgba(255,255,255,.04); color:var(--text); font:14px Inter,sans-serif; margin-bottom:18px; }
  textarea { min-height:140px; resize:vertical; }
  button { width:100%; padding:14px; border:0; border-radius:4px; background:var(--accent); color:#0A0D0C; font:800 13px "IBM Plex Mono",monospace; text-transform:uppercase; letter-spacing:.05em; cursor:pointer; }
  button:hover { opacity:.9; }
  .msg { padding:12px 14px; border-radius:4px; font-size:13px; margin-bottom:18px; }
  .msg.error { background:rgba(228,72,58,.12); border:1px solid rgba(228,72,58,.35); color:#ff9a8f; }
  .msg.notice { background:rgba(89,201,122,.12); border:1px solid rgba(89,201,122,.35); color:#9be6b3; }
  .ban-reason { padding:14px; border:1px solid var(--line); border-radius:4px; background:rgba(255,255,255,.03); margin-bottom:20px; font-size:13px; }
  .ban-reason b { color:var(--accent-2); }
  .footer { text-align:center; margin-top:22px; color:var(--muted); font:700 10px "IBM Plex Mono",monospace; letter-spacing:.08em; }
</style>
</head>
<body>
  <div class="card">
    <h1>UNIQUE<span>_AC</span> — Ban Appeal</h1>
    <p class="sub">Look up your ban with your license identifier, then submit your appeal for staff review.</p>

    <?php if ($error): ?><div class="msg error"><?= htmlspecialchars($error) ?></div><?php endif; ?>
    <?php if ($notice): ?><div class="msg notice"><?= htmlspecialchars($notice) ?></div><?php endif; ?>

    <?php if ($step === "lookup"): ?>
      <form method="post">
        <input type="hidden" name="action" value="lookup">
        <label>License identifier</label>
        <input type="text" name="identifier" placeholder="license:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" required>
        <button type="submit">Find my ban</button>
      </form>

    <?php elseif ($step === "appeal" && $banInfo): ?>
      <div class="ban-reason">
        <b>Reason on file:</b> <?= htmlspecialchars($banInfo["REASON"] ?? "Not specified") ?>
      </div>
      <form method="post">
        <input type="hidden" name="action" value="submit">
        <input type="hidden" name="identifier" value="<?= htmlspecialchars($banInfo["identifier"]) ?>">
        <input type="hidden" name="ban_id" value="<?= (int)$banInfo["BANID"] ?>">
        <label>Your in-game name</label>
        <input type="text" name="player_name" value="<?= htmlspecialchars($banInfo["PLAYER_NAME"] ?? "") ?>" maxlength="128">
        <label>Why should this ban be reconsidered?</label>
        <textarea name="message" maxlength="2000" placeholder="Explain your side clearly and honestly. Vague or hostile appeals are less likely to be reviewed favorably." required></textarea>
        <button type="submit">Submit appeal</button>
      </form>

    <?php else: ?>
      <p>You can close this page now.</p>
    <?php endif; ?>

    <div class="footer">UNIQUE_AC &nbsp;·&nbsp; arshiahub.ir</div>
  </div>
</body>
</html>
