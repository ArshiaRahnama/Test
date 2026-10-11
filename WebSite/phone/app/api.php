<?php
declare(strict_types=1);
/*
 * Web phone API — the Discord app on the website.
 *
 * Reads and writes the SAME phone_discord_* tables the in-game phone uses, so a
 * message sent from the website shows up in the game and the other way round.
 * Only a subset of the in-game endpoints is implemented (the rest return false and the
 * UI shows them as unavailable). Every rule below mirrors the in-game server code, and
 * where the in-game code uses roles / staff permissions the web is deliberately stricter:
 * when in doubt it refuses.
 */
require __DIR__ . '/../../lib.php';

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store');
header('X-Content-Type-Options: nosniff');

// Keep in sync with Config.DiscordExt.AutoMod.GlobalWords in Unique_Phone/config.lua.
const WEB_GLOBAL_WORDS = [];
const WEB_MSG_MAX = 1000;          // characters, same as the in-game server
const WEB_DM_MAX = 500;
const WEB_SEND_COOLDOWN_MS = 700;  // per session
const WEB_XP_BASE = 100;           // Config.DiscordExt.XP.BaseToLevel / Step
const WEB_XP_STEP = 50;

function web_out($v): never { echo json_encode($v, JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE); exit; }

function web_db(): PDO { return db(); }
function web_q(string $sql, array $args = []): array {
    $s = web_db()->prepare($sql);
    $s->execute($args);
    return $s->fetchAll();
}
function web_one(string $sql, array $args = []): ?array {
    $r = web_q($sql, $args);
    return $r[0] ?? null;
}
function web_in(array $values): array {
    // "?,?,?" + the values, for IN (...) lists
    return [implode(',', array_fill(0, count($values), '?')), array_values($values)];
}
function web_bool($v): bool { return $v === 1 || $v === '1' || $v === true || $v === 't'; }
function web_now(): int { return time(); }
function web_clip(string $s, int $chars): string { return mb_substr($s, 0, $chars, 'UTF-8'); }

// ---------------------------------------------------------------- auth
$me = me();
if (!$me) { http_response_code(401); web_out(['error' => 'AUTH']); }
if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') { http_response_code(405); web_out(['error' => 'METHOD']); }
$token = $_SESSION['csrf'] ?? '';
$sent = $_SERVER['HTTP_X_CSRF'] ?? '';
if ($token === '' || !hash_equals($token, $sent)) { http_response_code(419); web_out(['error' => 'CSRF']); }

$ep = preg_replace('/[^A-Za-z]/', '', (string)($_GET['ep'] ?? ''));
$in = json_decode((string)file_get_contents('php://input'), true);
if (!is_array($in)) $in = [];

$ident = game_identifier_of_account((int)$me['id']);
if (!$ident) web_out(false);   // no character linked to this website account

// ---------------------------------------------------------------- phone account
function web_account(string $ident): ?array {
    return web_one('SELECT mailbox, logged_in FROM phone_discord_accounts WHERE identifier = ?', [$ident]);
}
$acc = web_account($ident);
$loggedIn = $acc !== null && web_bool($acc['logged_in']);

// Everything except the status check needs an account that is logged in in-game.
if ($ep !== 'GetDiscordAccountStatus' && !$loggedIn) web_out(false);

// ---------------------------------------------------------------- helpers
function web_profile(string $ident): array {
    $p = web_one('SELECT * FROM phone_discord_profiles WHERE identifier = ?', [$ident]);
    if ($p) return $p;
    $now = web_now();
    $disc = str_pad((string)random_int(0, 9999), 4, '0', STR_PAD_LEFT);
    web_db()->prepare('INSERT INTO phone_discord_profiles (identifier, discriminator, created_at, updated_at) VALUES (?, ?, ?, ?)')
        ->execute([$ident, $disc, $now, $now]);
    return web_one('SELECT * FROM phone_discord_profiles WHERE identifier = ?', [$ident]) ?? [];
}

function web_name(string $ident): string {
    $u = web_one('SELECT firstname, lastname FROM users WHERE identifier = ?', [$ident]);
    if ($u) {
        $n = trim(($u['firstname'] ?? '') . ' ' . ($u['lastname'] ?? ''));
        if ($n !== '') return $n;
    }
    return 'Player';
}

/** identifiers that are connected right now (users.last_seen within the online window, computed by MySQL) */
function web_online(array $idents): array {
    $out = [];
    if (!$idents) return $out;
    [$ph, $args] = web_in($idents);
    try {
        $win = (int)CFG['online_window'];
        foreach (web_q("SELECT identifier, TIMESTAMPDIFF(SECOND, last_seen, NOW()) AS ago FROM users WHERE identifier IN ($ph)", $args) as $r) {
            if ($r['ago'] !== null && (int)$r['ago'] < $win) $out[$r['identifier']] = true;
        }
    } catch (Throwable $e) { /* demo database (sqlite) has no last_seen: everyone shows offline */ }
    return $out;
}

function web_server(int $sid): ?array {
    return web_one('SELECT * FROM phone_discord_servers WHERE id = ?', [$sid]);
}
function web_member(string $ident, int $sid): ?array {
    return web_one('SELECT * FROM phone_discord_members WHERE server_id = ? AND identifier = ?', [$sid, $ident]);
}
function web_is_owner(string $ident, array $server): bool { return ($server['owner_identifier'] ?? '') === $ident; }
function web_is_admin(string $ident, int $sid): bool {
    $s = web_server($sid);
    if (!$s) return false;
    if (web_is_owner($ident, $s)) return true;
    $m = web_member($ident, $sid);
    return $m !== null && web_bool($m['is_admin']);
}
function web_channel(int $cid): ?array {
    return web_one('SELECT id, server_id, name, kind, is_locked, topic, position, is_verified FROM phone_discord_channels WHERE id = ?', [$cid]);
}
function web_default_role(int $sid): ?array {
    return web_one('SELECT id, perms FROM phone_discord_roles WHERE server_id = ? AND is_default = 1 ORDER BY id ASC LIMIT 1', [$sid]);
}
function web_perm_list(?string $json): array {
    $t = json_decode((string)$json, true);
    return is_array($t) ? $t : [];
}
/** Does @everyone get $perm in this channel? (channel overrides applied, allow-overrides for @everyone ignored => stricter) */
function web_everyone_can(array $ch, int $sid, string $perm): bool {
    $def = web_default_role($sid);
    if (!$def) return false;
    $base = web_perm_list($def['perms']);
    $has = isset($base[$perm]) ? $base[$perm] === true : false;
    $ov = web_one('SELECT allow, deny FROM phone_discord_channel_perms WHERE channel_id = ? AND role_id = ?', [(int)$ch['id'], (int)$def['id']]);
    if ($ov) {
        $deny = web_perm_list($ov['deny']);
        if (in_array($perm, $deny, true)) return false;
    }
    return $has;
}
/** Can this player post in $ch? Returns null when allowed, otherwise the error code. */
function web_send_block(string $ident, array $ch): ?string {
    $sid = (int)$ch['server_id'];
    $admin = web_is_admin($ident, $sid);
    if (!web_member($ident, $sid)) return 'NO_PERMISSION';
    if (!$admin) {
        $t = web_one('SELECT until_at FROM phone_discord_timeouts WHERE server_id = ? AND identifier = ?', [$sid, $ident]);
        if ($t && (int)$t['until_at'] > web_now()) return 'TIMEOUT';
        if (web_bool($ch['is_locked'])) return 'LOCKED';
        if (($ch['kind'] ?? 'text') === 'stage') return 'STAGE';
        if (!web_everyone_can($ch, $sid, 'send')) return 'NO_PERMISSION';
    }
    return null;
}
function web_can_view(array $ch, int $sid): bool { return web_everyone_can($ch, $sid, 'view'); }

/** The same normalisation as the in-game auto-mod: lower case, zero-width / tatweel / harakat removed, Arabic ي ك ى folded. */
function web_norm(string $s): string {
    $s = preg_replace('/[\x{200B}\x{200C}\x{200D}\x{200E}\x{200F}\x{0640}\x{064B}-\x{0652}]/u', '', $s) ?? $s;
    $s = strtr($s, ["\u{064A}" => "\u{06CC}", "\u{0649}" => "\u{06CC}", "\u{0643}" => "\u{06A9}"]);
    return mb_strtolower($s, 'UTF-8');
}
function web_automod_hit(int $sid, string $text): bool {
    $t = web_norm($text);
    $words = WEB_GLOBAL_WORDS;
    foreach (web_q('SELECT word FROM phone_discord_automod WHERE server_id = ?', [$sid]) as $r) $words[] = $r['word'];
    foreach ($words as $w) {
        $w = web_norm((string)$w);
        if ($w === '') continue;
        if (preg_match('/^[a-z0-9_\-]+$/', $w)) {
            if (preg_match('/(?<![a-z0-9_])' . preg_quote($w, '/') . '(?![a-z0-9_])/', $t)) return true;
        } elseif (mb_strpos($t, $w, 0, 'UTF-8') !== false) return true;
    }
    return false;
}

function web_level(int $xp): int {
    $lvl = 0; $rem = $xp;
    while ($lvl < 500 && $rem >= WEB_XP_BASE + WEB_XP_STEP * $lvl) { $rem -= WEB_XP_BASE + WEB_XP_STEP * $lvl; $lvl++; }
    return $lvl;
}

// ---------------------------------------------------------------- endpoints
switch ($ep) {

case 'GetDiscordAccountStatus':
    web_out([
        'hasAccount' => $acc !== null,
        'loggedIn' => $loggedIn,
        'mailbox' => $acc['mailbox'] ?? null,
        'siteUrl' => null,
    ]);

case 'GetDiscordMyProfile': {
    $p = web_profile($ident);
    $count = web_one('SELECT COUNT(*) AS c FROM phone_discord_members WHERE identifier = ?', [$ident]);
    web_out([
        'uid' => (int)($p['uid'] ?? 0), 'discriminator' => $p['discriminator'] ?? '0000', 'bio' => $p['bio'] ?? '',
        'status' => $p['status'] ?? 'online', 'customStatus' => $p['custom_status'] ?? '', 'bannerColor' => $p['banner_color'] ?? '#5865F2',
        'verified' => web_bool($p['verified'] ?? 0), 'avatar' => $p['avatar_url'] ?? null,
        'showPhone' => web_bool($p['show_phone'] ?? 1), 'showJob' => web_bool($p['show_job'] ?? 1),
        'serverCount' => (int)($count['c'] ?? 0), 'displayName' => web_name($ident), 'isStaff' => false,
    ]);
}

case 'GetDiscordServers': {
    $rows = web_q('SELECT s.id, s.name, s.icon_text, s.icon_color, s.icon_url, s.invite_code, s.owner_identifier, s.is_public, s.is_verified, m.is_admin
                   FROM phone_discord_servers s INNER JOIN phone_discord_members m ON m.server_id = s.id
                   WHERE m.identifier = ? ORDER BY s.id ASC', [$ident]);
    $out = [];
    foreach ($rows as $r) {
        $out[] = [
            'id' => (int)$r['id'], 'name' => $r['name'], 'icon_text' => $r['icon_text'], 'icon_color' => $r['icon_color'], 'iconUrl' => $r['icon_url'],
            'invite_code' => $r['invite_code'], 'isOwner' => ($r['owner_identifier'] === $ident), 'isAdmin' => web_bool($r['is_admin']),
            'isPublic' => web_bool($r['is_public']), 'isVerified' => web_bool($r['is_verified']),
        ];
    }
    web_out($out);
}

case 'GetDiscordChannels': {
    $sid = (int)($in['serverId'] ?? 0);
    if (!$sid || !web_member($ident, $sid)) web_out(false);
    $out = [];
    foreach (web_q('SELECT id, name, position, is_verified, is_locked, kind, topic FROM phone_discord_channels WHERE server_id = ? ORDER BY position ASC, id ASC', [$sid]) as $c) {
        if (!web_can_view($c, $sid)) continue;
        $out[] = [
            'id' => (int)$c['id'], 'name' => $c['name'], 'position' => (int)$c['position'], 'isVerified' => web_bool($c['is_verified']),
            'isLocked' => web_bool($c['is_locked']), 'kind' => $c['kind'] ?? 'text', 'topic' => $c['topic'],
            'canSend' => web_send_block($ident, $c) === null,
        ];
    }
    web_out($out);
}

case 'GetDiscordMembers': {
    $sid = (int)($in['serverId'] ?? 0);
    if (!$sid || !web_member($ident, $sid)) web_out(false);
    $server = web_server($sid);
    $rows = web_q('SELECT m.id, m.identifier, m.nickname, m.is_admin, p.status, p.custom_status, p.verified
                   FROM phone_discord_members m LEFT JOIN phone_discord_profiles p ON p.identifier = m.identifier
                   WHERE m.server_id = ? ORDER BY m.nickname ASC', [$sid]);
    $online = web_online(array_column($rows, 'identifier'));
    $out = [];
    foreach ($rows as $r) {
        $status = $r['status'] ?: 'online';
        $isOnline = isset($online[$r['identifier']]) && $status !== 'invisible';
        $out[] = [
            'id' => (int)$r['id'], 'nickname' => $r['nickname'], 'isOwner' => $r['identifier'] === ($server['owner_identifier'] ?? ''),
            'isAdmin' => web_bool($r['is_admin']), 'isVerified' => web_bool($r['verified']), 'isOnline' => $isOnline,
            'status' => $isOnline ? $status : 'offline', 'customStatus' => $isOnline ? ($r['custom_status'] ?: null) : null,
            'activity' => null,
        ];
    }
    web_out($out);
}

case 'GetDiscordMessages': {
    $cid = (int)($in['channelId'] ?? 0);
    $ch = web_channel($cid);
    if (!$ch || !web_member($ident, (int)$ch['server_id']) || !web_can_view($ch, (int)$ch['server_id'])) web_out(false);
    $rows = web_q('SELECT * FROM (SELECT id, identifier, author_name, message, created_at, edited_at, is_pinned, is_announcement, reply_to_id, role_mentions
                   FROM phone_discord_messages WHERE channel_id = ? ORDER BY id DESC LIMIT 200) AS recent ORDER BY id ASC', [$cid]);
    if (!$rows) web_out([]);
    [$ph, $args] = web_in(array_column($rows, 'id'));
    $reactions = [];
    foreach (web_q("SELECT message_id, identifier, emoji FROM phone_discord_reactions WHERE message_id IN ($ph)", $args) as $r) {
        $mid = (int)$r['message_id'];
        $reactions[$mid][$r['emoji']] ??= ['emoji' => $r['emoji'], 'count' => 0, 'reacted' => false];
        $reactions[$mid][$r['emoji']]['count']++;
        if ($r['identifier'] === $ident) $reactions[$mid][$r['emoji']]['reacted'] = true;
    }
    $replyIds = array_values(array_unique(array_filter(array_column($rows, 'reply_to_id'), fn($v) => $v !== null)));
    $previews = [];
    if ($replyIds) {
        [$rph, $rargs] = web_in($replyIds);
        foreach (web_q("SELECT id, author_name, message FROM phone_discord_messages WHERE id IN ($rph)", $rargs) as $r) {
            $previews[(int)$r['id']] = ['author_name' => $r['author_name'], 'message' => web_clip((string)$r['message'], 80)];
        }
    }
    $nicks = []; $verified = []; $memberIds = [];
    foreach (web_q('SELECT m.id, m.identifier, m.nickname, p.verified FROM phone_discord_members m LEFT JOIN phone_discord_profiles p ON p.identifier = m.identifier WHERE m.server_id = ?', [(int)$ch['server_id']]) as $m) {
        $nicks[$m['identifier']] = $m['nickname']; $verified[$m['identifier']] = web_bool($m['verified']); $memberIds[$m['identifier']] = (int)$m['id'];
    }
    $out = [];
    foreach ($rows as $r) {
        $mid = (int)$r['id'];
        $author = $r['identifier'];
        $name = (!empty($nicks[$author])) ? $nicks[$author] : $r['author_name'];
        $rm = [];
        if (is_string($r['role_mentions']) && $r['role_mentions'] !== '') {
            foreach (explode(',', $r['role_mentions']) as $x) if (preg_match('/^-?\d+$/', $x)) $rm[] = (int)$x;
        }
        $out[] = [
            'id' => $mid, 'author_name' => $name, 'message' => $r['message'], 'created_at' => (int)$r['created_at'],
            'edited_at' => $r['edited_at'] !== null ? (int)$r['edited_at'] : null, 'is_pinned' => web_bool($r['is_pinned']),
            'isAnnouncement' => web_bool($r['is_announcement']), 'isMine' => $author === $ident,
            'authorMemberId' => $memberIds[$author] ?? null, 'authorVerified' => $verified[$author] ?? false,
            'reactions' => array_values($reactions[$mid] ?? []), 'roleMentions' => $rm,
            'replyPreview' => $r['reply_to_id'] !== null ? ($previews[(int)$r['reply_to_id']] ?? null) : null,
        ];
    }
    web_out($out);
}

case 'SendDiscordMessage': {
    $cid = (int)($in['channelId'] ?? 0);
    $text = isset($in['message']) && is_string($in['message']) ? trim(web_clip($in['message'], WEB_MSG_MAX)) : '';
    if ($text === '') web_out(false);
    $ch = web_channel($cid);
    if (!$ch) web_out(false);
    $sid = (int)$ch['server_id'];
    $block = web_send_block($ident, $ch);
    if ($block !== null) web_out(['error' => $block]);
    if (!web_can_view($ch, $sid)) web_out(false);
    if (web_automod_hit($sid, $text)) web_out(['error' => 'AUTOMOD']);
    // one message per 700 ms per session
    $ms = (int)(microtime(true) * 1000);
    if (isset($_SESSION['dc_last']) && $ms - (int)$_SESSION['dc_last'] < WEB_SEND_COOLDOWN_MS) web_out(['error' => 'COOLDOWN']);
    $_SESSION['dc_last'] = $ms;

    $replyTo = isset($in['replyToId']) && is_numeric($in['replyToId']) ? (int)$in['replyToId'] : null;
    if ($replyTo !== null && !web_one('SELECT id FROM phone_discord_messages WHERE id = ? AND channel_id = ?', [$replyTo, $cid])) $replyTo = null;
    $now = web_now();
    $name = web_name($ident);
    $nick = web_member($ident, $sid)['nickname'] ?? '';
    if ($nick !== '') $name = $nick;
    web_db()->prepare('INSERT INTO phone_discord_messages (channel_id, identifier, author_name, message, created_at, reply_to_id) VALUES (?, ?, ?, ?, ?, ?)')
        ->execute([$cid, $ident, $name, $text, $now, $replyTo]);
    $id = (int)web_db()->lastInsertId();
    web_out(['id' => $id, 'created_at' => $now]);
}

case 'ToggleDiscordReaction': {
    $mid = (int)($in['messageId'] ?? 0);
    $emoji = isset($in['emoji']) && is_string($in['emoji']) ? $in['emoji'] : '';
    // emoji only: no letters/digits outside keycaps, no spaces, reasonably short
    if ($emoji === '' || strlen($emoji) > 32 || preg_match('/[A-Za-z\s]/', $emoji)) web_out(false);
    $msg = web_one('SELECT id, channel_id FROM phone_discord_messages WHERE id = ?', [$mid]);
    if (!$msg) web_out(false);
    $ch = web_channel((int)$msg['channel_id']);
    if (!$ch || !web_member($ident, (int)$ch['server_id']) || !web_can_view($ch, (int)$ch['server_id']) || !web_everyone_can($ch, (int)$ch['server_id'], 'react')) web_out(false);
    $have = web_one('SELECT id FROM phone_discord_reactions WHERE message_id = ? AND identifier = ? AND emoji = ?', [$mid, $ident, $emoji]);
    if ($have) web_db()->prepare('DELETE FROM phone_discord_reactions WHERE id = ?')->execute([(int)$have['id']]);
    else web_db()->prepare('INSERT INTO phone_discord_reactions (message_id, identifier, emoji, created_at) VALUES (?, ?, ?, ?)')->execute([$mid, $ident, $emoji, web_now()]);
    web_out(true);
}

case 'GetDiscordPublicServers':
case 'DiscordExt_GetDiscover': {
    $q = trim((string)($in['query'] ?? ''));
    $cat = (string)($in['category'] ?? '');
    $cats = ['gaming', 'roleplay', 'gangs', 'jobs', 'community', 'other'];
    $where = 's.is_public = 1';
    $args = [];
    if (in_array($cat, $cats, true)) { $where .= ' AND s.category = ?'; $args[] = $cat; }
    if (mb_strlen($q, 'UTF-8') >= 2) {
        $like = '%' . strtr(mb_strtolower(web_clip($q, 40), 'UTF-8'), ['!' => '!!', '%' => '!%', '_' => '!_']) . '%';
        $where .= " AND (LOWER(s.name) LIKE ? ESCAPE '!' OR LOWER(s.description) LIKE ? ESCAPE '!')";
        $args[] = $like; $args[] = $like;
    }
    $rows = web_q("SELECT s.id, s.name, s.icon_text, s.icon_color, s.icon_url, s.description, s.category, s.is_verified, s.is_featured, s.vanity,
                          (SELECT COUNT(*) FROM phone_discord_members m WHERE m.server_id = s.id) AS memberCount
                   FROM phone_discord_servers s WHERE $where ORDER BY s.is_featured DESC, memberCount DESC, s.id ASC LIMIT 60", $args);
    if (!$rows) web_out([]);
    $ids = array_map(fn($r) => (int)$r['id'], $rows);
    [$ph, $pargs] = web_in($ids);
    $mine = [];
    foreach (web_q('SELECT server_id FROM phone_discord_members WHERE identifier = ?', [$ident]) as $m) $mine[(int)$m['server_id']] = true;
    $online = [];
    foreach (web_q("SELECT server_id, identifier FROM phone_discord_members WHERE server_id IN ($ph)", $pargs) as $m) $memberOf[] = $m;
    $allIdents = array_column($memberOf ?? [], 'identifier');
    $on = web_online($allIdents);
    foreach (($memberOf ?? []) as $m) if (isset($on[$m['identifier']])) $online[(int)$m['server_id']] = ($online[(int)$m['server_id']] ?? 0) + 1;
    $out = [];
    foreach ($rows as $r) {
        $id = (int)$r['id'];
        $out[] = [
            'id' => $id, 'name' => $r['name'], 'icon_text' => $r['icon_text'], 'icon_color' => $r['icon_color'], 'icon_url' => $r['icon_url'],
            'description' => $r['description'], 'category' => $r['category'], 'vanity' => $r['vanity'],
            'isVerified' => web_bool($r['is_verified']), 'isFeatured' => web_bool($r['is_featured']),
            'memberCount' => (int)$r['memberCount'], 'onlineCount' => $online[$id] ?? 0, 'isMember' => isset($mine[$id]),
        ];
    }
    web_out($out);
}

case 'DiscordExt_GetServerInfo': {
    $sid = (int)($in['serverId'] ?? 0);
    if (!$sid || !web_member($ident, $sid)) web_out(false);
    $s = web_server($sid);
    $count = (int)(web_one('SELECT COUNT(*) AS c FROM phone_discord_boosts WHERE server_id = ? AND expires_at > ?', [$sid, web_now()])['c'] ?? 0);
    web_out([
        'serverId' => $sid, 'kind' => ($s['kind'] ?? null) ?: null, 'theme' => $s['theme_color'] ?? null,
        'canModerate' => false, 'canConfigure' => false, 'isOwner' => web_is_owner($ident, $s),
        'boostCount' => $count, 'myBoosts' => 0, 'maxBoosts' => 2, 'boostLevel' => 0, 'emojiSlots' => 0, 'levels' => [],
        'customEmojis' => [], 'emojiImages' => [], 'isFeatured' => web_bool($s['is_featured'] ?? 0), 'vipUntil' => $s['vip_until'] ?? null,
        'description' => $s['description'] ?? null, 'vanity' => $s['vanity'] ?? null, 'iconUrl' => $s['icon_url'] ?? null,
        'perms' => [], 'roles' => [], 'myRoleIds' => [], 'welcome' => ['require' => false],
        'discover' => ['category' => $s['category'] ?? 'community', 'isPublic' => web_bool($s['is_public'] ?? 0)],
        'showWelcome' => false, 'mustAccept' => false,
    ]);
}

case 'DiscordExt_GetMemberMeta': {
    $sid = (int)($in['serverId'] ?? 0);
    if (!$sid || !web_member($ident, $sid)) web_out(false);
    $s = web_server($sid);
    $rows = web_q('SELECT m.id, m.identifier, p.uid, p.avatar_url FROM phone_discord_members m LEFT JOIN phone_discord_profiles p ON p.identifier = m.identifier WHERE m.server_id = ?', [$sid]);
    $xp = [];
    foreach (web_q('SELECT identifier, xp FROM phone_discord_xp WHERE server_id = ?', [$sid]) as $x) $xp[$x['identifier']] = (int)$x['xp'];
    $meta = [];
    foreach ($rows as $r) {
        $badges = [];
        if (($s['owner_identifier'] ?? '') === $r['identifier']) $badges[] = 'founder';
        $meta[(string)$r['id']] = [
            'uid' => $r['uid'] !== null ? (int)$r['uid'] : null, 'avatar' => $r['avatar_url'] ?? null,
            'level' => web_level($xp[$r['identifier']] ?? 0), 'badges' => $badges, 'color' => null, 'roles' => [], 'act' => null,
        ];
    }
    web_out(['meta' => (object)$meta, 'defs' => ['founder' => ['icon' => '👑', 'label' => 'Server founder']]]);
}

case 'DiscordExt_GetAutoMod':
    web_out(['words' => [], 'max' => 40]);

case 'DiscordExt_GetUnread':
case 'DiscordExt_GetFolders':
    web_out([]);

case 'DiscordExt_GetMutes':
    web_out(['channels' => [], 'servers' => []]);

case 'DiscordExt_SetUnread':
case 'SendDiscordTyping':
case 'Discord_Close':
    web_out(true);

case 'DiscordExt_EnterChannel': {
    $cid = (int)($in['channelId'] ?? 0);
    $ch = web_channel($cid);
    if (!$ch || !web_member($ident, (int)$ch['server_id'])) web_out(false);
    $prev = web_one('SELECT last_id FROM phone_discord_seen WHERE identifier = ? AND channel_id = ?', [$ident, $cid]);
    $maxId = (int)(web_one('SELECT COALESCE(MAX(id), 0) AS m FROM phone_discord_messages WHERE channel_id = ?', [$cid])['m'] ?? 0);
    if ($prev) web_db()->prepare('UPDATE phone_discord_seen SET last_id = ? WHERE identifier = ? AND channel_id = ?')->execute([$maxId, $ident, $cid]);
    else web_db()->prepare('INSERT INTO phone_discord_seen (identifier, channel_id, last_id) VALUES (?, ?, ?)')->execute([$ident, $cid, $maxId]);
    web_out(['lastSeen' => $prev ? (int)$prev['last_id'] : null]);
}

// ---------------------------------------------------------------- friends & direct messages
case 'DiscordExt_GetSocial': {
    $rows = web_q('SELECT user_low, user_high, requester, status FROM phone_discord_friends WHERE user_low = ? OR user_high = ?', [$ident, $ident]);
    $friendIds = []; $incoming = []; $outgoing = [];
    foreach ($rows as $f) {
        $other = $f['user_low'] === $ident ? $f['user_high'] : $f['user_low'];
        if ($f['status'] === 'accepted') $friendIds[] = $other;
        elseif ($f['requester'] === $ident) $outgoing[] = $other;
        else $incoming[] = $other;
    }
    $blocked = array_column(web_q('SELECT blocked FROM phone_discord_blocks WHERE blocker = ?', [$ident]), 'blocked');
    $dmRows = web_q('SELECT d.id, d.user_low, d.user_high, d.last_at FROM phone_discord_dms d WHERE (d.user_low = ? OR d.user_high = ?) AND d.last_at > 0 ORDER BY d.last_at DESC LIMIT 60', [$ident, $ident]);
    $all = array_values(array_unique(array_merge($friendIds, $incoming, $outgoing, $blocked, array_map(fn($d) => $d['user_low'] === $ident ? $d['user_high'] : $d['user_low'], $dmRows))));
    $cards = web_cards($all);
    $pick = fn(array $ids) => array_values(array_filter(array_map(fn($i) => $cards[$i] ?? null, $ids)));
    $dms = []; $dmUnread = 0;
    foreach ($dmRows as $d) {
        $other = $d['user_low'] === $ident ? $d['user_high'] : $d['user_low'];
        $last = web_one('SELECT identifier, message FROM phone_discord_dm_messages WHERE dm_id = ? ORDER BY id DESC LIMIT 1', [(int)$d['id']]);
        $seen = web_one('SELECT last_id FROM phone_discord_dm_seen WHERE identifier = ? AND dm_id = ?', [$ident, (int)$d['id']]);
        $unread = (int)(web_one('SELECT COUNT(*) AS c FROM phone_discord_dm_messages WHERE dm_id = ? AND identifier <> ? AND id > ?',
                  [(int)$d['id'], $ident, $seen ? (int)$seen['last_id'] : 0])['c'] ?? 0);
        $dmUnread += $unread;
        $dms[] = [
            'id' => (int)$d['id'], 'user' => $cards[$other] ?? null,
            'lastMessage' => $last ? web_clip((string)$last['message'], 60) : '', 'lastMine' => ($last['identifier'] ?? '') === $ident,
            'lastAt' => (int)$d['last_at'], 'unread' => $unread, 'canSend' => in_array($other, $friendIds, true) && !in_array($other, $blocked, true),
        ];
    }
    $p = web_profile($ident);
    web_out([
        'me' => ['uid' => (int)($p['uid'] ?? 0), 'avatar' => $p['avatar_url'] ?? null, 'discriminator' => $p['discriminator'] ?? '0000'],
        'friends' => $pick($friendIds), 'incoming' => $pick($incoming), 'outgoing' => $pick($outgoing), 'blocked' => $pick($blocked),
        'dms' => array_values(array_filter($dms, fn($d) => $d['user'] !== null)), 'dmUnread' => $dmUnread,
    ]);
}

case 'DiscordExt_OpenDM': {
    $other = web_ident_of_uid((int)($in['uid'] ?? 0));
    if (!$other || !web_can_talk($ident, $other)) web_out(['error' => 'NOT_FRIENDS']);
    [$low, $high] = $ident < $other ? [$ident, $other] : [$other, $ident];
    $d = web_one('SELECT id FROM phone_discord_dms WHERE user_low = ? AND user_high = ?', [$low, $high]);
    if ($d) $dmId = (int)$d['id'];
    else {
        web_db()->prepare('INSERT INTO phone_discord_dms (user_low, user_high, created_at, last_at) VALUES (?, ?, ?, 0)')->execute([$low, $high, web_now()]);
        $dmId = (int)web_db()->lastInsertId();
    }
    web_out(['dmId' => $dmId, 'user' => web_cards([$other])[$other] ?? null]);
}

case 'DiscordExt_GetDMMessages': {
    $dm = web_dm_for($ident, (int)($in['dmId'] ?? 0));
    if (!$dm) web_out(false);
    $other = $dm['other'];
    $before = isset($in['beforeId']) && is_numeric($in['beforeId']) ? (int)$in['beforeId'] : null;
    $size = 50;
    $rows = $before
        ? web_q('SELECT * FROM (SELECT id, identifier, author_name, message, created_at, edited_at FROM phone_discord_dm_messages WHERE dm_id = ? AND id < ? ORDER BY id DESC LIMIT ' . $size . ') AS page ORDER BY id ASC', [$dm['id'], $before])
        : web_q('SELECT * FROM (SELECT id, identifier, author_name, message, created_at, edited_at FROM phone_discord_dm_messages WHERE dm_id = ? ORDER BY id DESC LIMIT ' . $size . ') AS page ORDER BY id ASC', [$dm['id']]);
    $list = array_map(fn($m) => [
        'id' => (int)$m['id'], 'author_name' => $m['author_name'], 'message' => $m['message'], 'created_at' => (int)$m['created_at'],
        'edited_at' => $m['edited_at'] !== null ? (int)$m['edited_at'] : null, 'isMine' => $m['identifier'] === $ident,
    ], $rows);
    $lastSeen = null;
    if (!$before) {
        $seen = web_one('SELECT last_id FROM phone_discord_dm_seen WHERE identifier = ? AND dm_id = ?', [$ident, $dm['id']]);
        $lastSeen = $seen ? (int)$seen['last_id'] : null;
        $maxId = (int)(web_one('SELECT COALESCE(MAX(id), 0) AS m FROM phone_discord_dm_messages WHERE dm_id = ?', [$dm['id']])['m'] ?? 0);
        if ($seen) web_db()->prepare('UPDATE phone_discord_dm_seen SET last_id = ? WHERE identifier = ? AND dm_id = ?')->execute([$maxId, $ident, $dm['id']]);
        else web_db()->prepare('INSERT INTO phone_discord_dm_seen (identifier, dm_id, last_id) VALUES (?, ?, ?)')->execute([$ident, $dm['id'], $maxId]);
    }
    web_out(['messages' => $list, 'hasMore' => count($rows) >= $size, 'lastSeen' => $lastSeen,
             'user' => web_cards([$other])[$other] ?? null, 'canSend' => web_can_talk($ident, $other)]);
}

case 'DiscordExt_SendDM': {
    $dm = web_dm_for($ident, (int)($in['dmId'] ?? 0));
    if (!$dm) web_out(false);
    if (!web_can_talk($ident, $dm['other'])) web_out(['error' => 'NOT_FRIENDS']);
    $text = isset($in['text']) && is_string($in['text']) ? trim(web_clip($in['text'], WEB_DM_MAX)) : '';
    if ($text === '') web_out(false);
    if (web_automod_hit(0, $text)) web_out(['error' => 'AUTOMOD']);
    $ms = (int)(microtime(true) * 1000);
    if (isset($_SESSION['dc_dm_last']) && $ms - (int)$_SESSION['dc_dm_last'] < WEB_SEND_COOLDOWN_MS) web_out(['error' => 'COOLDOWN']);
    $_SESSION['dc_dm_last'] = $ms;
    $now = web_now();
    $name = web_name($ident);
    web_db()->prepare('INSERT INTO phone_discord_dm_messages (dm_id, identifier, author_name, message, created_at) VALUES (?, ?, ?, ?, ?)')
        ->execute([$dm['id'], $ident, $name, $text, $now]);
    $id = (int)web_db()->lastInsertId();
    web_db()->prepare('UPDATE phone_discord_dms SET last_at = ? WHERE id = ?')->execute([$now, $dm['id']]);
    $seen = web_one('SELECT last_id FROM phone_discord_dm_seen WHERE identifier = ? AND dm_id = ?', [$ident, $dm['id']]);
    if ($seen) web_db()->prepare('UPDATE phone_discord_dm_seen SET last_id = ? WHERE identifier = ? AND dm_id = ?')->execute([$id, $ident, $dm['id']]);
    else web_db()->prepare('INSERT INTO phone_discord_dm_seen (identifier, dm_id, last_id) VALUES (?, ?, ?)')->execute([$ident, $dm['id'], $id]);
    web_out(['ok' => true, 'id' => $id, 'created_at' => $now, 'message' => $text]);
}

case 'DiscordExt_RespondFriend': {
    $other = web_ident_of_uid((int)($in['uid'] ?? 0));
    if (!$other) web_out(false);
    [$low, $high] = $ident < $other ? [$ident, $other] : [$other, $ident];
    $row = web_one('SELECT * FROM phone_discord_friends WHERE user_low = ? AND user_high = ?', [$low, $high]);
    if (!$row || $row['status'] !== 'pending' || $row['requester'] === $ident) web_out(false);
    if (($in['accept'] ?? false) === true) {
        if (web_is_blocked_either($ident, $other)) web_out(false);
        web_db()->prepare("UPDATE phone_discord_friends SET status = 'accepted' WHERE id = ?")->execute([(int)$row['id']]);
    } else {
        web_db()->prepare('DELETE FROM phone_discord_friends WHERE id = ?')->execute([(int)$row['id']]);
    }
    web_out(true);
}

case 'DiscordExt_RemoveFriend':
case 'DiscordExt_BlockUser': {
    $other = web_ident_of_uid((int)($in['uid'] ?? 0));
    if (!$other || $other === $ident) web_out(false);
    [$low, $high] = $ident < $other ? [$ident, $other] : [$other, $ident];
    web_db()->prepare('DELETE FROM phone_discord_friends WHERE user_low = ? AND user_high = ?')->execute([$low, $high]);
    if ($ep === 'DiscordExt_BlockUser' && !web_one('SELECT 1 AS x FROM phone_discord_blocks WHERE blocker = ? AND blocked = ?', [$ident, $other])) {
        web_db()->prepare('INSERT INTO phone_discord_blocks (blocker, blocked, created_at) VALUES (?, ?, ?)')->execute([$ident, $other, web_now()]);
    }
    web_out(true);
}

case 'DiscordExt_UnblockUser': {
    $other = web_ident_of_uid((int)($in['uid'] ?? 0));
    if (!$other) web_out(false);
    web_db()->prepare('DELETE FROM phone_discord_blocks WHERE blocker = ? AND blocked = ?')->execute([$ident, $other]);
    web_out(true);
}

case 'DiscordExt_AddFriendByUid': {
    $other = web_ident_of_uid((int)($in['uid'] ?? 0));
    if (!$other || $other === $ident) web_out(['error' => 'NOT_FOUND']);
    if (!web_account($other)) web_out(['error' => 'NOT_FOUND']);
    if (web_is_blocked_either($ident, $other)) web_out(['error' => 'NOT_FOUND']);
    [$low, $high] = $ident < $other ? [$ident, $other] : [$other, $ident];
    $row = web_one('SELECT * FROM phone_discord_friends WHERE user_low = ? AND user_high = ?', [$low, $high]);
    if ($row) {
        if ($row['status'] === 'accepted') web_out(['error' => 'ALREADY']);
        if ($row['requester'] === $ident) web_out(['error' => 'PENDING']);
        web_db()->prepare("UPDATE phone_discord_friends SET status = 'accepted' WHERE id = ?")->execute([(int)$row['id']]);
        web_out(['ok' => true, 'status' => 'accepted']);
    }
    web_db()->prepare("INSERT INTO phone_discord_friends (user_low, user_high, requester, status, created_at) VALUES (?, ?, ?, 'pending', ?)")
        ->execute([$low, $high, $ident, web_now()]);
    web_out(['ok' => true, 'status' => 'sent']);
}

case 'GetDiscordPinnedMessages':
    web_out([]);

default:
    web_out(false);
}

// ---------------------------------------------------------------- friends/DM helpers (declared after the switch on purpose: used above)
function web_ident_of_uid(int $uid): ?string {
    if ($uid <= 0) return null;
    $r = web_one('SELECT identifier FROM phone_discord_profiles WHERE uid = ?', [$uid]);
    return $r['identifier'] ?? null;
}
function web_is_blocked_either(string $a, string $b): bool {
    return (bool)web_one('SELECT 1 AS x FROM phone_discord_blocks WHERE (blocker = ? AND blocked = ?) OR (blocker = ? AND blocked = ?)', [$a, $b, $b, $a]);
}
function web_can_talk(string $a, string $b): bool {
    if (web_is_blocked_either($a, $b)) return false;
    [$low, $high] = $a < $b ? [$a, $b] : [$b, $a];
    $f = web_one('SELECT status FROM phone_discord_friends WHERE user_low = ? AND user_high = ?', [$low, $high]);
    return $f !== null && $f['status'] === 'accepted';
}
function web_dm_for(string $ident, int $dmId): ?array {
    if ($dmId <= 0) return null;
    $d = web_one('SELECT * FROM phone_discord_dms WHERE id = ? AND (user_low = ? OR user_high = ?)', [$dmId, $ident, $ident]);
    if (!$d) return null;
    $d['other'] = $d['user_low'] === $ident ? $d['user_high'] : $d['user_low'];
    return $d;
}
/** card for a list of identifiers: uid, name, discriminator, avatar, status */
function web_cards(array $idents): array {
    $out = [];
    $idents = array_values(array_unique(array_filter($idents)));
    if (!$idents) return $out;
    [$ph, $args] = web_in($idents);
    $profiles = [];
    foreach (web_q("SELECT identifier, uid, discriminator, status, custom_status, avatar_url FROM phone_discord_profiles WHERE identifier IN ($ph)", $args) as $p) $profiles[$p['identifier']] = $p;
    $names = [];
    foreach (web_q("SELECT identifier, firstname, lastname FROM users WHERE identifier IN ($ph)", $args) as $u) {
        $names[$u['identifier']] = trim(($u['firstname'] ?? '') . ' ' . ($u['lastname'] ?? '')) ?: 'Player';
    }
    $online = web_online($idents);
    foreach ($idents as $id) {
        $p = $profiles[$id] ?? null;
        $status = ($p['status'] ?? 'online');
        $isOn = isset($online[$id]) && $status !== 'invisible';
        $out[$id] = [
            'uid' => $p ? (int)$p['uid'] : null, 'name' => $names[$id] ?? 'Player', 'discriminator' => $p['discriminator'] ?? '0000',
            'avatar' => $p['avatar_url'] ?? null, 'status' => $isOn ? $status : 'offline',
            'customStatus' => $isOn ? (($p['custom_status'] ?? '') ?: null) : null, 'activity' => null,
        ];
    }
    return $out;
}
