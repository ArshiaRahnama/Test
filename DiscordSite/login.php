<?php
/* Login: the same username/phone and password as in the game. */
require __DIR__ . '/lib.php';
if (current_user()) go('index.php');
$err = '';
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  if (!csrf_ok((string)($_POST['csrf'] ?? ''))) { http_response_code(419); $err = 'Your session expired. Reload the page and try again.'; }
  elseif ($lu = game_login((string)($_POST['ident'] ?? ''), (string)($_POST['pass'] ?? ''), $err)) {
    session_regenerate_id(true);
    $_SESSION['login_id'] = (int)$lu['id'];
    go('index.php');
  }
}
?><!DOCTYPE html>
<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Login · <?= e(dsite_cfg('site_name')) ?></title>
<style>
:root { --bg1:#0b0d1a; --bg2:#1a1038; --acc:#5865f2; --acc2:#eb459e; --acc3:#f0b232; --txt:#eef0f8; --mut:#a9aecb; }
* { box-sizing: border-box; }
html, body { height: 100%; margin: 0; }
body { font-family: "gg sans","Noto Sans","Segoe UI",Tahoma,Arial,sans-serif; color: var(--txt); overflow: hidden;
  background: radial-gradient(1200px 800px at 10% 10%, #2a1d5e 0%, transparent 60%), radial-gradient(900px 700px at 90% 90%, #4a1640 0%, transparent 55%), linear-gradient(160deg, var(--bg1), var(--bg2));
  display: flex; align-items: center; justify-content: center; padding: 16px; }
/* moving colour blobs behind the card */
.blob { position: fixed; border-radius: 50%; filter: blur(70px); opacity: .55; z-index: 0; pointer-events: none; animation: drift 18s ease-in-out infinite alternate; }
.b1 { width: 420px; height: 420px; background: var(--acc); top: -120px; left: -100px; }
.b2 { width: 360px; height: 360px; background: var(--acc2); bottom: -120px; right: -80px; animation-duration: 22s; }
.b3 { width: 260px; height: 260px; background: var(--acc3); top: 40%; left: 60%; opacity: .25; animation-duration: 26s; }
@keyframes drift { 0% { transform: translate(0,0) scale(1); } 100% { transform: translate(60px,-40px) scale(1.12); } }
/* the glass card */
.card { position: relative; z-index: 1; width: 100%; max-width: 440px; padding: 34px 32px 28px; border-radius: 22px;
  background: linear-gradient(160deg, rgba(255,255,255,.14), rgba(255,255,255,.04)); border: 1px solid rgba(255,255,255,.14);
  backdrop-filter: blur(22px) saturate(160%); -webkit-backdrop-filter: blur(22px) saturate(160%);
  box-shadow: 0 30px 80px rgba(0,0,0,.55), inset 0 1px 0 rgba(255,255,255,.18);
  animation: rise .8s cubic-bezier(.2,.9,.25,1.15) both; }
.card::before { content: ""; position: absolute; inset: -1px; border-radius: 22px; padding: 1px; pointer-events: none;
  background: linear-gradient(120deg, var(--acc), var(--acc2), var(--acc3), var(--acc)); background-size: 300% 300%;
  -webkit-mask: linear-gradient(#000 0 0) content-box, linear-gradient(#000 0 0); -webkit-mask-composite: xor; mask-composite: exclude; opacity: .7; animation: sheen 6s linear infinite; }
@keyframes rise { from { opacity: 0; transform: translateY(26px) scale(.97); filter: blur(6px); } to { opacity: 1; transform: none; filter: none; } }
@keyframes sheen { 0% { background-position: 0% 50%; } 100% { background-position: 300% 50%; } }
.logo { width: 64px; height: 64px; margin: 0 auto 12px; border-radius: 20px; display: flex; align-items: center; justify-content: center; font-size: 30px; color: #fff;
  background: conic-gradient(from 180deg, var(--acc), var(--acc2), var(--acc3), var(--acc)); box-shadow: 0 10px 30px rgba(88,101,242,.5); animation: pulse 3.2s ease-in-out infinite; }
@keyframes pulse { 0%,100% { transform: scale(1); } 50% { transform: scale(1.06); } }
h1 { margin: 0 0 6px; font-size: 25px; text-align: center; letter-spacing: .3px; background: linear-gradient(90deg, #fff, #c9ceff); -webkit-background-clip: text; background-clip: text; color: transparent; }
p.sub { margin: 0 0 22px; text-align: center; color: var(--mut); font-size: 14px; line-height: 21px; }
label { display: block; font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: .8px; color: var(--mut); margin: 16px 0 7px; }
.field { position: relative; }
form input { width: 100%; height: 48px; padding: 0 14px; border-radius: 14px; border: 1px solid rgba(255,255,255,.12); background: rgba(10,12,28,.45); color: var(--txt); font-size: 16px; outline: none;
  transition: border-color .25s, box-shadow .25s, background .25s; }
form input:focus { border-color: var(--acc); background: rgba(10,12,28,.6); box-shadow: 0 0 0 4px rgba(88,101,242,.25), 0 0 26px rgba(88,101,242,.25); }
button { position: relative; overflow: hidden; width: 100%; height: 50px; margin-top: 24px; border: 0; border-radius: 14px; font-size: 16px; font-weight: 700; color: #fff; cursor: pointer;
  background: linear-gradient(90deg, var(--acc), var(--acc2)); background-size: 200% 100%; box-shadow: 0 12px 30px rgba(88,101,242,.45); transition: transform .15s, box-shadow .25s, background-position .6s; }
button:hover { background-position: 100% 0; box-shadow: 0 16px 38px rgba(235,69,158,.45); transform: translateY(-1px); }
button:active { transform: scale(.98); }
button::after { content: ""; position: absolute; top: 0; left: -60%; width: 40%; height: 100%; background: linear-gradient(120deg, transparent, rgba(255,255,255,.45), transparent); transform: skewX(-20deg); animation: shine 3.5s ease-in-out infinite; }
@keyframes shine { 0%,60% { left: -60%; } 100% { left: 130%; } }
.err { background: rgba(237,66,69,.14); border: 1px solid rgba(237,66,69,.45); color: #ffb3b5; border-radius: 12px; padding: 10px 12px; font-size: 14px; margin-bottom: 8px; animation: shake .45s; }
@keyframes shake { 20%,60% { transform: translateX(-6px); } 40%,80% { transform: translateX(6px); } }
.hint { margin-top: 18px; font-size: 12.5px; color: #8f96b8; line-height: 19px; text-align: center; }
@media (prefers-reduced-motion: reduce) { *, *::before, *::after { animation: none !important; } }
</style></head>
<body>
<div class="blob b1"></div><div class="blob b2"></div><div class="blob b3"></div>
<main class="card">
  <div class="logo">U</div>
  <h1><?= e(dsite_cfg('site_name')) ?></h1>
  <p class="sub">Log in with the username (or phone number) and password you use in the game.</p>
  <?php if ($err): ?><div class="err" role="alert"><?= e($err) ?></div><?php endif; ?>
  <form method="post" autocomplete="on">
    <?= csrf_field() ?>
    <label for="ident">Username or phone</label>
    <input id="ident" name="ident" dir="ltr" required autofocus autocomplete="username" value="<?= e((string)($_POST['ident'] ?? '')) ?>">
    <label for="pass">Password</label>
    <input id="pass" name="pass" type="password" dir="ltr" required autocomplete="current-password">
    <button type="submit">Log In</button>
  </form>
  <p class="hint">Your Discord account is the one you already use on the in-game phone. Accounts are created in the game only.</p>
</main>
</body></html>
