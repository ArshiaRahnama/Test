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
require __DIR__ . '/lib.php';

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
const WEB_INVITE_USES = [0, 1, 5, 10, 25, 100];
const WEB_INVITE_MINUTES = [0, 60, 1440, 10080];
const WEB_INVITE_MAX_ACTIVE = 20;
const WEB_AVATAR_EFFECTS = ['none', 'ring', 'glow', 'pulse', 'rainbow'];
const WEB_BOOST_LEVELS = [['boosts' => 10, 'slots' => 15], ['boosts' => 5, 'slots' => 8], ['boosts' => 2, 'slots' => 3]];
const WEB_EMOJI_BASE_SLOTS = 0;
const WEB_SITE_TAGS = ['roleplay', 'gaming', 'gangs', 'jobs', 'police', 'medical', 'racing', 'events', 'community', 'chill'];
const WEB_DISCOVER_CATS = ['gaming', 'roleplay', 'gangs', 'jobs', 'community', 'other'];
const WEB_CHANNEL_PERM_KEYS = ['view', 'send', 'react', 'pin', 'manage_messages'];
const WEB_AUDIT_LABELS = [
    'KickDiscordMember' => 'kick member', 'ToggleDiscordAdmin' => 'toggle admin', 'DiscordExt_Timeout' => 'timeout member',
    'DiscordExt_Warn' => 'warn member', 'DiscordExt_ClearWarns' => 'clear warnings', 'DiscordExt_CreateRole' => 'create role',
    'DiscordExt_UpdateRole' => 'edit role', 'DiscordExt_DeleteRole' => 'delete role', 'DiscordExt_SetMemberRole' => 'change member role',
    'DiscordExt_SetTheme' => 'change theme', 'DiscordExt_SetWelcome' => 'edit welcome & rules', 'DiscordExt_SetVanity' => 'set vanity',
    'DiscordExt_SetServerIcon' => 'set server icon', 'DiscordExt_CreateInvite' => 'create invite', 'DiscordExt_RevokeInvite' => 'revoke invite',
    'CreateDiscordChannel' => 'create channel', 'DiscordExt_SetChannelInfo' => 'edit channel', 'DiscordExt_BulkDelete' => 'bulk delete',
    'DiscordExt_ToggleFeatured' => 'star / unstar message', 'DiscordExt_BanMember' => 'ban member', 'DiscordExt_UnbanMember' => 'unban member',
    'DiscordExt_ResolveAppeal' => 'resolve appeal', 'DiscordExt_AddStaffNote' => 'staff note added',
    'DiscordExt_SetChannelOrder' => 'reorder channels', 'DiscordExt_SetAnnouncementChannel' => 'announcement mode',
    'DiscordExt_FollowChannel' => 'follow channel', 'DiscordExt_UnfollowChannel' => 'unfollow channel',
    'DiscordExt_CreateChannelFromTemplate' => 'create channel', 'DiscordExt_SaveChannelTemplate' => 'save channel template',
    'DiscordExt_DeleteChannelTemplate' => 'delete channel template', 'DiscordExt_DeleteStaffNote' => 'staff note deleted',
    'DiscordExt_StaffResolveReport' => 'report resolved',
    'DiscordExt_SetInvitesPaused' => 'pause or resume invites',
];
const WEB_PERM_KEYS = ['view', 'send', 'react', 'mention_roles', 'pin', 'manage_messages', 'speak', 'manage_channels',
                       'manage_roles', 'manage_server', 'kick', 'moderate', 'administrator'];
const WEB_SITE_WINDOW = 60;        // seconds without a request before the website counts as offline
const WEB_PHONE_ICON = "\u{1F4F1}"; // 📱

function web_out($v): never {
    // audit log: a successful admin action is recorded (the same rule as the game)
    $a = $GLOBALS['WEB_AUDIT'] ?? null;
    if ($a && $a['server'] && (($v === true) || (is_array($v) && !isset($v['error']) && ($v['ok'] ?? true) !== false))) {
        web_ensure_audit_table();
        try {
            web_db()->prepare('INSERT INTO phone_discord_server_audit (server_id, actor_identifier, actor_name, action, target, created_at) VALUES (?, ?, ?, ?, ?, ?)')
                ->execute([$a['server'], $a['ident'], $a['name'], $a['label'], web_clip((string)$a['target'], 160), time()]);
        } catch (Throwable $e) {}
    }
    echo json_encode($v, JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE); exit;
}

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
/** the table is created by the game (sql/discord_v18.sql); this only makes the site work on a fresh test copy */
function web_ensure_audit_table(): void {
    try {
        web_db()->exec('CREATE TABLE IF NOT EXISTS phone_discord_server_audit (id INTEGER PRIMARY KEY AUTOINCREMENT, server_id INT, actor_identifier TEXT, actor_name TEXT, action TEXT, target TEXT, created_at INT)');
    } catch (Throwable $e) {}
}
function web_audit_server(array $in): int {
    if (!empty($in['serverId'])) return (int)$in['serverId'];
    if (!empty($in['messageId'])) { $r = web_one('SELECT c.server_id FROM phone_discord_messages m JOIN phone_discord_channels c ON c.id = m.channel_id WHERE m.id = ?', [(int)$in['messageId']]); return (int)($r['server_id'] ?? 0); }
    if (!empty($in['channelId'])) { $r = web_one('SELECT server_id FROM phone_discord_channels WHERE id = ?', [(int)$in['channelId']]); return (int)($r['server_id'] ?? 0); }
    if (!empty($in['inviteId'])) { $r = web_one('SELECT server_id FROM phone_discord_invites WHERE id = ?', [(int)$in['inviteId']]); return (int)($r['server_id'] ?? 0); }
    return 0;
}
function web_audit_target(array $in): string {
    if (!empty($in['memberId'])) { $r = web_one('SELECT nickname FROM phone_discord_members WHERE id = ?', [(int)$in['memberId']]); return (string)($r['nickname'] ?? ('member #' . (int)$in['memberId'])); }
    if (!empty($in['roleId'])) { $r = web_one('SELECT name FROM phone_discord_roles WHERE id = ?', [(int)$in['roleId']]); return (string)($r['name'] ?? ('role #' . (int)$in['roleId'])); }
    if (!empty($in['identifier'])) return (string)$in['identifier'];
    if (!empty($in['messageId'])) return 'message #' . (int)$in['messageId'];
    if (!empty($in['channelId'])) return 'channel #' . (int)$in['channelId'];
    if (isset($in['name'])) return (string)$in['name'];
    return '';
}
function web_clip(string $s, int $chars): string {
    if (function_exists('mb_substr')) return mb_substr($s, 0, $chars, 'UTF-8');
    preg_match('/^.{0,' . max(0, $chars) . '}/us', $s, $m);
    return $m[0] ?? '';
}
function web_strlen(string $s): int {
    if (function_exists('mb_strlen')) return mb_strlen($s, 'UTF-8');
    return (int)preg_match_all('/./us', $s);
}
function web_lower(string $s): string {
    if (function_exists('mb_strtolower')) return mb_strtolower($s, 'UTF-8');
    return strtolower($s);
}
function web_contains(string $hay, string $needle): bool {
    if (function_exists('mb_strpos')) return mb_strpos($hay, $needle, 0, 'UTF-8') !== false;
    return strpos($hay, $needle) !== false;
}

// ---------------------------------------------------------------- auth
$me = current_user();
if (!$me) { http_response_code(401); web_out(['error' => 'AUTH']); }
if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') { http_response_code(405); web_out(['error' => 'METHOD']); }
if (!csrf_ok((string)($_SERVER['HTTP_X_CSRF'] ?? ''))) { http_response_code(419); web_out(['error' => 'CSRF']); }

$ep = preg_replace('/[^A-Za-z_]/', '', (string)($_GET['ep'] ?? ''));
$in = json_decode((string)file_get_contents('php://input'), true);
if (!is_array($in)) $in = [];
$epKey = preg_replace('/^DiscordExt_/', 'DiscordExt_', $ep);
if (isset(WEB_AUDIT_LABELS[$ep])) {
    $GLOBALS['WEB_AUDIT'] = ['label' => WEB_AUDIT_LABELS[$ep], 'server' => web_audit_server($in), 'target' => web_audit_target($in)];
}

$ident = $me['identifier'];
web_touch($ident);
if (isset($GLOBALS['WEB_AUDIT'])) { $GLOBALS['WEB_AUDIT']['ident'] = $ident; $GLOBALS['WEB_AUDIT']['name'] = web_name($ident); }

// ---------------------------------------------------------------- phone account
function web_account(string $ident): ?array {
    return web_one('SELECT mailbox, logged_in FROM phone_discord_accounts WHERE identifier = ?', [$ident]);
}
$acc = web_account($ident);
$loggedIn = $acc !== null && web_bool($acc['logged_in']);

// Everything except the status check needs an account that is logged in in-game.
if ($ep !== 'GetDiscordAccountStatus' && !$loggedIn) web_out(false);


/** remember that this player has the website open (throttled to one write per 20 s) */
function web_touch(string $ident): void {
    $now = time();
    $r = web_one('SELECT last_seen FROM dsite_presence WHERE identifier = ?', [$ident]);
    if ($r && $now - (int)$r['last_seen'] < 20) return;
    if ($r) web_db()->prepare('UPDATE dsite_presence SET last_seen = ? WHERE identifier = ?')->execute([$now, $ident]);
    else web_db()->prepare('INSERT INTO dsite_presence (identifier, last_seen) VALUES (?, ?)')->execute([$ident, $now]);
}
/** identifiers that have the website open right now */
function web_site_online(array $idents): array {
    $out = [];
    if (!$idents) return $out;
    [$ph, $args] = web_in($idents);
    foreach (web_q("SELECT identifier, last_seen FROM dsite_presence WHERE identifier IN ($ph)", $args) as $r) {
        if (time() - (int)$r['last_seen'] < WEB_SITE_WINDOW) $out[$r['identifier']] = true;
    }
    return $out;
}
/**
 * Presence as shown to others:
 *  - in the game            -> online, no icon (the game shows its own status)
 *  - only on the website    -> online with the 📱 icon
 *  - neither                -> offline
 * Returns [isOnline, platform ('game'|'web'|null), activity text or null]
 */
function web_presence(string $ident, string $status, array $gameOn, array $siteOn): array {
    if ($status === 'invisible') return [false, null, null];
    if (isset($gameOn[$ident])) return [true, 'game', null];
    if (isset($siteOn[$ident])) return [true, 'web', WEB_PHONE_ICON . ' Using the website'];
    return [false, null, null];
}

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
        $win = (int)dsite_cfg('online_window');
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
        if (!web_everyone_can($ch, $sid, 'send')) return 'NO_PERMISSION';
    }
    return null;
}
function web_can_view(array $ch, int $sid): bool { return web_everyone_can($ch, $sid, 'view'); }

/** The same normalisation as the in-game auto-mod: lower case, zero-width / tatweel / harakat removed, Arabic ي ك ى folded. */
function web_norm(string $s): string {
    $s = preg_replace('/[\x{200B}\x{200C}\x{200D}\x{200E}\x{200F}\x{0640}\x{064B}-\x{0652}]/u', '', $s) ?? $s;
    $s = strtr($s, ["\u{064A}" => "\u{06CC}", "\u{0649}" => "\u{06CC}", "\u{0643}" => "\u{06A9}"]);
    return web_lower($s);
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
        } elseif (web_contains($t, $w)) return true;
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
    foreach (web_q('SELECT id, server_id, name, position, is_verified, is_locked, kind, topic FROM phone_discord_channels WHERE server_id = ? ORDER BY position ASC, id ASC', [$sid]) as $c) {
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
    $idents = array_column($rows, 'identifier');
    $gameOn = web_online($idents);
    $siteOn = web_site_online($idents);
    $out = [];
    foreach ($rows as $r) {
        $status = $r['status'] ?: 'online';
        [$isOnline, $platform, $activity] = web_presence($r['identifier'], $status, $gameOn, $siteOn);
        $out[] = [
            'id' => (int)$r['id'], 'nickname' => $r['nickname'], 'isOwner' => $r['identifier'] === ($server['owner_identifier'] ?? ''),
            'isAdmin' => web_bool($r['is_admin']), 'isVerified' => web_bool($r['verified']), 'isOnline' => $isOnline,
            'status' => $isOnline ? $status : 'offline', 'customStatus' => $isOnline ? ($r['custom_status'] ?: null) : null,
            'activity' => $activity, 'platform' => $platform,
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
    foreach (web_q("SELECT message_id, identifier, emoji, is_super FROM phone_discord_reactions WHERE message_id IN ($ph)", $args) as $r) {
        $mid = (int)$r['message_id'];
        $sup = web_bool($r['is_super'] ?? 0);
        $key = $r['emoji'] . ($sup ? '#super' : '');
        $reactions[$mid][$key] ??= ['emoji' => $r['emoji'], 'count' => 0, 'reacted' => false, 'super' => $sup];
        $reactions[$mid][$key]['count']++;
        if ($r['identifier'] === $ident) $reactions[$mid][$key]['reacted'] = true;
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
    $cool = (int)dsite_cfg('send_cooldown_ms');
    if (isset($_SESSION['dc_last']) && $ms - (int)$_SESSION['dc_last'] < $cool) web_out(['error' => 'COOLDOWN']);
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
    $have = web_one('SELECT id FROM phone_discord_reactions WHERE message_id = ? AND identifier = ? AND emoji = ? AND is_super = 0', [$mid, $ident, $emoji]);
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
    if (web_strlen($q) >= 2) {
        $like = '%' . strtr(web_lower(web_clip($q, 40)), ['!' => '!!', '%' => '!%', '_' => '!_']) . '%';
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
        'boostCount' => $count, 'myBoosts' => 0, 'maxBoosts' => 2, 'boostLevel' => 0, 'emojiSlots' => web_emoji_slots($sid), 'levels' => [],
        'customEmojis' => [], 'emojiImages' => web_emoji_images($sid), 'isFeatured' => web_bool($s['is_featured'] ?? 0), 'vipUntil' => $s['vip_until'] ?? null,
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
    $rows = web_q('SELECT m.id, m.identifier, p.uid, p.avatar_url, p.banner_url, p.avatar_effect, p.handle FROM phone_discord_members m LEFT JOIN phone_discord_profiles p ON p.identifier = m.identifier WHERE m.server_id = ?', [$sid]);
    $roleOf = [];
    foreach (web_q('SELECT mr.identifier, r.name, r.color FROM phone_discord_member_roles mr JOIN phone_discord_roles r ON r.id = mr.role_id WHERE mr.server_id = ? AND r.is_default = 0 ORDER BY r.position DESC, r.id ASC', [$sid]) as $rr) $roleOf[$rr['identifier']][] = ['name' => $rr['name'], 'color' => $rr['color']];
    $xp = [];
    foreach (web_q('SELECT identifier, xp FROM phone_discord_xp WHERE server_id = ?', [$sid]) as $x) $xp[$x['identifier']] = (int)$x['xp'];
    $meta = [];
    foreach ($rows as $r) {
        $badges = [];
        if (($s['owner_identifier'] ?? '') === $r['identifier']) $badges[] = 'founder';
        $meta[(string)$r['id']] = [
            'uid' => $r['uid'] !== null ? (int)$r['uid'] : null, 'avatar' => $r['avatar_url'] ?? null,
            'level' => web_level($xp[$r['identifier']] ?? 0), 'badges' => $badges, 'color' => ($roleOf[$r['identifier']][0]['color'] ?? null), 'roles' => ($roleOf[$r['identifier']] ?? []), 'act' => null,
            'banner' => $r['banner_url'] ?? null, 'effect' => $r['avatar_effect'] ?? null, 'handle' => $r['handle'] ?? null,
        ];
    }
    web_out(['meta' => (object)$meta, 'defs' => ['founder' => ['icon' => '👑', 'label' => 'Server founder']]]);
}

case 'DiscordExt_GetAutoMod':
    web_out(['words' => [], 'max' => 40]);

case 'DiscordExt_GetUnread':
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
    if (!$other || web_is_blocked_either($ident, $other)) web_out(['error' => 'NOT_FRIENDS']);
    [$low, $high] = $ident < $other ? [$ident, $other] : [$other, $ident];
    $d = web_one('SELECT id, request_state FROM phone_discord_dms WHERE user_low = ? AND user_high = ?', [$low, $high]);
    if ($d) web_out(['dmId' => (int)$d['id'], 'user' => web_cards([$other])[$other] ?? null, 'requestState' => $d['request_state']]);
    if (!web_can_talk($ident, $other)) {
        // not friends: a message request, allowed when you share a server
        if (!web_shares_server($ident, $other)) web_out(['error' => 'NOT_FRIENDS']);
        if (!web_dms_open_to($ident, $other)) web_out(['error' => 'DMS_CLOSED']);
        $pending = (int)(web_one("SELECT COUNT(*) AS c FROM phone_discord_dms WHERE request_state = 'pending' AND requested_by = ?", [$ident])['c'] ?? 0);
        if ($pending >= 5) web_out(['error' => 'TOO_MANY_REQUESTS']);
        web_db()->prepare("INSERT INTO phone_discord_dms (user_low, user_high, created_at, last_at, request_state, requested_by) VALUES (?, ?, ?, 0, 'pending', ?)")
            ->execute([$low, $high, web_now(), $ident]);
        web_out(['dmId' => (int)web_db()->lastInsertId(), 'user' => web_cards([$other])[$other] ?? null, 'requestState' => 'pending']);
    }
    web_db()->prepare('INSERT INTO phone_discord_dms (user_low, user_high, created_at, last_at) VALUES (?, ?, ?, 0)')->execute([$low, $high, web_now()]);
    web_out(['dmId' => (int)web_db()->lastInsertId(), 'user' => web_cards([$other])[$other] ?? null]);
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
             'user' => web_cards([$other])[$other] ?? null, 'canSend' => web_dm_talkable($dm, $ident) || (($dm['request_state'] ?? null) === 'pending' && $dm['requested_by'] === $ident),
             'requestState' => $dm['request_state'] ?? null, 'requestedByMe' => ($dm['requested_by'] ?? null) === $ident]);
}

case 'DiscordExt_SendDM': {
    $dm = web_dm_for($ident, (int)($in['dmId'] ?? 0));
    if (!$dm) web_out(false);
    if (!web_dm_talkable($dm, $ident) && ($dm['request_state'] ?? null) !== 'pending') web_out(['error' => 'NOT_FRIENDS']);
    if (($dm['request_state'] ?? null) === 'pending' && !web_can_talk($ident, $dm['other'])) {
        if ($dm['requested_by'] !== $ident) web_out(['error' => 'NEEDS_ACCEPT']);
        $sent = (int)(web_one('SELECT COUNT(*) AS c FROM phone_discord_dm_messages WHERE dm_id = ? AND identifier = ?', [(int)$dm['id'], $ident])['c'] ?? 0);
        if ($sent >= 3) web_out(['error' => 'WAIT_FOR_ACCEPT']);
    }
    $text = isset($in['text']) && is_string($in['text']) ? trim(web_clip($in['text'], WEB_DM_MAX)) : '';
    if ($text === '') web_out(false);
    if (web_automod_hit(0, $text)) web_out(['error' => 'AUTOMOD']);
    $ms = (int)(microtime(true) * 1000);
    if (isset($_SESSION['dc_dm_last']) && $ms - (int)$_SESSION['dc_dm_last'] < (int)dsite_cfg('send_cooldown_ms')) web_out(['error' => 'COOLDOWN']);
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

// ---------------------------------------------------------------- batch 2: edit / delete / pin / search / join / leave / profile / live
case 'EditDiscordMessage': {
    $mid = (int)($in['messageId'] ?? 0);
    $text = isset($in['message']) && is_string($in['message']) ? trim(web_clip($in['message'], WEB_MSG_MAX)) : '';
    $m = web_one('SELECT id, channel_id, identifier, is_announcement FROM phone_discord_messages WHERE id = ?', [$mid]);
    if (!$m || $text === '' || $m['identifier'] !== $ident || web_bool($m['is_announcement'])) web_out(false);
    $ch = web_channel((int)$m['channel_id']);
    if (!$ch || !web_member($ident, (int)$ch['server_id'])) web_out(false);
    if (web_automod_hit((int)$ch['server_id'], $text)) web_out(false);
    web_db()->prepare('UPDATE phone_discord_messages SET message = ?, edited_at = ? WHERE id = ?')->execute([$text, web_now(), $mid]);
    web_out(true);
}

case 'DeleteDiscordMessage': {
    $mid = (int)($in['messageId'] ?? 0);
    $m = web_one('SELECT id, channel_id, identifier FROM phone_discord_messages WHERE id = ?', [$mid]);
    if (!$m) web_out(false);
    $ch = web_channel((int)$m['channel_id']);
    if (!$ch) web_out(false);
    $sid = (int)$ch['server_id'];
    if (!web_member($ident, $sid)) web_out(false);
    if ($m['identifier'] !== $ident && !web_is_admin($ident, $sid)) web_out(false);
    web_db()->prepare('DELETE FROM phone_discord_reactions WHERE message_id = ?')->execute([$mid]);
    web_db()->prepare('DELETE FROM phone_discord_messages WHERE id = ?')->execute([$mid]);
    web_out(true);
}

case 'TogglePinDiscordMessage': {
    $mid = (int)($in['messageId'] ?? 0);
    $m = web_one('SELECT id, channel_id, is_pinned FROM phone_discord_messages WHERE id = ?', [$mid]);
    if (!$m) web_out(false);
    $ch = web_channel((int)$m['channel_id']);
    if (!$ch || !web_is_admin($ident, (int)$ch['server_id'])) web_out(false);
    web_db()->prepare('UPDATE phone_discord_messages SET is_pinned = ? WHERE id = ?')->execute([web_bool($m['is_pinned']) ? 0 : 1, $mid]);
    web_out(true);
}

case 'GetDiscordPinnedMessages': {
    $cid = (int)($in['channelId'] ?? 0);
    $ch = web_channel($cid);
    if (!$ch || !web_member($ident, (int)$ch['server_id'])) web_out(false);
    web_out(web_q('SELECT id, author_name, message, created_at FROM phone_discord_messages WHERE channel_id = ? AND is_pinned = 1 ORDER BY id DESC', [$cid]));
}

case 'DiscordExt_Search': {
    $sid = (int)($in['serverId'] ?? 0);
    $cid = (int)($in['channelId'] ?? 0);
    if (!$sid || !web_member($ident, $sid)) web_out(false);
    $q = trim(web_clip((string)($in['query'] ?? ''), 40));
    if (web_strlen($q) < 2) web_out([]);
    $like = '%' . strtr(web_lower($q), ['!' => '!!', '%' => '!%', '_' => '!_']) . '%';
    $viewable = [];
    foreach (web_q('SELECT id, name, kind, is_locked FROM phone_discord_channels WHERE server_id = ?', [$sid]) as $c) {
        if (web_can_view($c, $sid)) $viewable[(int)$c['id']] = $c['name'];
    }
    if (!$viewable) web_out([]);
    if ($cid > 0 && !isset($viewable[$cid])) web_out([]);
    $ids = $cid > 0 ? [$cid] : array_keys($viewable);
    [$ph, $args] = web_in($ids);
    $rows = web_q("SELECT m.id, m.channel_id, m.author_name, m.message, m.created_at FROM phone_discord_messages m
                   WHERE m.channel_id IN ($ph) AND LOWER(m.message) LIKE ? ESCAPE '!' ORDER BY m.id DESC LIMIT 40", array_merge($args, [$like]));
    web_out(array_map(fn($r) => [
        'id' => (int)$r['id'], 'channel_id' => (int)$r['channel_id'], 'channel_name' => $viewable[(int)$r['channel_id']] ?? '',
        'author_name' => $r['author_name'], 'message' => web_clip((string)$r['message'], 160), 'created_at' => (int)$r['created_at'],
    ], $rows));
}

case 'JoinDiscordPublicServer': {
    $sid = (int)($in['serverId'] ?? 0);
    $s = web_server($sid);
    if (!$s || !web_bool($s['is_public'])) web_out(false);
    if (web_one('SELECT 1 AS x FROM phone_discord_server_bans WHERE server_id = ? AND identifier = ?', [$sid, $ident])) web_out(['error' => 'BANNED']);
    if (web_member($ident, $sid)) web_out(['error' => 'ALREADY_MEMBER']);
    if (web_invites_paused($sid, $ident)) web_out(['error' => 'INVITES_PAUSED']);
    web_join($ident, $s);
    web_out(web_server_card_for_join($ident, $s));
}

case 'JoinDiscordServer': {
    $code = strtoupper(preg_replace('/\s+/', '', (string)($in['inviteCode'] ?? '')));
    $raw = trim((string)($in['inviteCode'] ?? ''));
    $raw = preg_replace('#^https?://#i', '', $raw);
    $raw = preg_replace('#^(www\.)?(discord\.gg/|discord\.com/invite/)#i', '', $raw);
    $raw = preg_replace('#[/?\#].*$#', '', $raw);
    if ($raw === '') web_out(false);
    $s = web_one('SELECT * FROM phone_discord_servers WHERE invite_code = ?', [strtoupper($raw)]);
    $viaInvite = null;
    if (!$s) {
        $inv = web_one('SELECT * FROM phone_discord_invites WHERE code = ?', [strtoupper($raw)]);
        if ($inv) {
            if ($inv['expires_at'] !== null && web_now() >= (int)$inv['expires_at']) web_out(['error' => 'EXPIRED']);
            if ((int)$inv['max_uses'] > 0 && (int)$inv['uses'] >= (int)$inv['max_uses']) web_out(['error' => 'FULL']);
            $s = web_server((int)$inv['server_id']);
            $viaInvite = (int)$inv['id'];
        } else {
            $s = web_one('SELECT * FROM phone_discord_servers WHERE vanity = ?', [strtolower($raw)]);
        }
    }
    if (!$s) web_out(['error' => 'NOT_FOUND']);
    if (web_one('SELECT 1 AS x FROM phone_discord_server_bans WHERE server_id = ? AND identifier = ?', [(int)$s['id'], $ident])) web_out(['error' => 'BANNED']);
    if (web_invites_paused((int)$s['id'], $ident)) web_out(['error' => 'INVITES_PAUSED']);
    if (web_member($ident, (int)$s['id'])) web_out(['error' => 'ALREADY_MEMBER']);
    web_join($ident, $s);
    if ($viaInvite) web_db()->prepare('UPDATE phone_discord_invites SET uses = uses + 1 WHERE id = ?')->execute([$viaInvite]);
    web_out(web_server_card_for_join($ident, $s));
}

case 'LeaveDiscordServer': {
    $sid = (int)($in['serverId'] ?? 0);
    $s = web_server($sid);
    if (!$s || !web_member($ident, $sid) || web_is_owner($ident, $s) || ($s['kind'] ?? null)) web_out(false);
    web_db()->prepare('DELETE FROM phone_discord_members WHERE server_id = ? AND identifier = ?')->execute([$sid, $ident]);
    web_db()->prepare('DELETE FROM phone_discord_member_roles WHERE server_id = ? AND identifier = ?')->execute([$sid, $ident]);
    web_out(true);
}

case 'DiscordExt_SetNickname': {
    $sid = (int)($in['serverId'] ?? 0);
    $m = web_member($ident, $sid);
    if (!$m) web_out(false);
    $nick = trim(preg_replace('/[\x00-\x1F]/', ' ', (string)($in['nickname'] ?? '')));
    $nick = web_clip($nick, 32);
    if ($nick === '') $nick = web_name($ident);
    web_db()->prepare('UPDATE phone_discord_members SET nickname = ? WHERE id = ?')->execute([$nick, (int)$m['id']]);
    web_out(['ok' => true, 'nickname' => $nick]);
}

case 'DiscordExt_MarkSeen': {
    $cid = (int)($in['channelId'] ?? 0);
    $ch = web_channel($cid);
    if (!$ch || !web_member($ident, (int)$ch['server_id'])) web_out(false);
    $maxId = (int)(web_one('SELECT COALESCE(MAX(id), 0) AS m FROM phone_discord_messages WHERE channel_id = ?', [$cid])['m'] ?? 0);
    if (web_one('SELECT 1 AS x FROM phone_discord_seen WHERE identifier = ? AND channel_id = ?', [$ident, $cid])) web_db()->prepare('UPDATE phone_discord_seen SET last_id = ? WHERE identifier = ? AND channel_id = ?')->execute([$maxId, $ident, $cid]);
    else web_db()->prepare('INSERT INTO phone_discord_seen (identifier, channel_id, last_id) VALUES (?, ?, ?)')->execute([$ident, $cid, $maxId]);
    web_out(true);
}

case 'GetDiscordDiscover':
    web_out(web_discover((string)($in['query'] ?? ''), (string)($in['category'] ?? ''), $ident));

case 'DiscordExt_GetMyDiscord': {
    $p = web_profile($ident);
    web_out(['uid' => (int)($p['uid'] ?? 0), 'avatar' => $p['avatar_url'] ?? null, 'banner' => $p['banner_url'] ?? null, 'effect' => $p['avatar_effect'] ?? null, 'handle' => $p['handle'] ?? null, 'discriminator' => $p['discriminator'] ?? '0000', 'name' => web_name($ident)]);
}

case 'UpdateDiscordMyProfile': {
    $p = web_profile($ident);
    $status = in_array($in['status'] ?? '', ['online', 'idle', 'dnd', 'invisible'], true) ? $in['status'] : ($p['status'] ?? 'online');
    $custom = web_clip(trim((string)($in['customStatus'] ?? '')), 60);
    $bio = web_clip(trim((string)($in['bio'] ?? '')), 190);
    $banner = (isset($in['bannerColor']) && preg_match('/^#[0-9a-fA-F]{6}$/', (string)$in['bannerColor'])) ? $in['bannerColor'] : ($p['banner_color'] ?? '#5865F2');
    web_db()->prepare('UPDATE phone_discord_profiles SET status = ?, custom_status = ?, bio = ?, banner_color = ?, show_phone = ?, show_job = ?, updated_at = ? WHERE identifier = ?')
        ->execute([$status, $custom, $bio, $banner, !empty($in['showPhone']) ? 1 : 0, !empty($in['showJob']) ? 1 : 0, web_now(), $ident]);
    $p = web_profile($ident);
    web_out(['uid' => (int)$p['uid'], 'discriminator' => $p['discriminator'], 'bio' => $p['bio'], 'status' => $p['status'], 'customStatus' => $p['custom_status'],
             'bannerColor' => $p['banner_color'], 'verified' => web_bool($p['verified']), 'avatar' => $p['avatar_url'], 'showPhone' => web_bool($p['show_phone']), 'showJob' => web_bool($p['show_job'])]);
}

case 'DiscordExt_GetServerCard': {
    $sid = (int)($in['serverId'] ?? 0);
    $s = web_server($sid);
    if (!$s) web_out(false);
    $isMember = web_member($ident, $sid) !== null;
    if (!$isMember && !web_bool($s['is_public']) && !web_bool($s['is_featured'])) web_out(false);
    $members = web_q('SELECT identifier FROM phone_discord_members WHERE server_id = ?', [$sid]);
    $online = web_online(array_column($members, 'identifier'));
    web_out([
        'id' => (int)$s['id'], 'name' => $s['name'], 'icon_text' => $s['icon_text'], 'icon_color' => $s['icon_color'], 'description' => $s['description'],
        'theme' => $s['theme_color'], 'memberCount' => count($members), 'onlineCount' => count($online), 'boostLevel' => 0,
        'isVerified' => web_bool($s['is_verified']), 'isFeatured' => web_bool($s['is_featured']), 'isMember' => $isMember,
        'isOwner' => web_is_owner($ident, $s), 'canLeave' => $isMember && !web_is_owner($ident, $s) && !($s['kind'] ?? null),
        'kind' => ($s['kind'] ?? null) ?: null, 'vanity' => $s['vanity'], 'isPublic' => web_bool($s['is_public']), 'createdAt' => (int)($s['created_at'] ?? 0),
    ]);
}

case 'DiscordExt_GetLeaderboard': {
    $sid = (int)($in['serverId'] ?? 0);
    if (!$sid || !web_member($ident, $sid)) web_out(false);
    $rows = web_q('SELECT x.identifier, x.xp, x.messages, m.nickname FROM phone_discord_xp x
                   JOIN phone_discord_members m ON m.server_id = x.server_id AND m.identifier = x.identifier
                   WHERE x.server_id = ? ORDER BY x.xp DESC LIMIT 15', [$sid]);
    $list = []; $rank = 0;
    foreach ($rows as $i => $r) {
        $list[] = ['rank' => $i + 1, 'name' => $r['nickname'], 'xp' => (int)$r['xp'], 'messages' => (int)$r['messages'], 'level' => web_level((int)$r['xp']), 'mine' => $r['identifier'] === $ident];
    }
    $me = web_one('SELECT xp, messages FROM phone_discord_xp WHERE server_id = ? AND identifier = ?', [$sid, $ident]) ?? ['xp' => 0, 'messages' => 0];
    $xp = (int)$me['xp'];
    $above = web_one('SELECT COUNT(*) AS c FROM phone_discord_xp WHERE server_id = ? AND xp > ?', [$sid, $xp]);
    $lvl = web_level($xp);
    $base = $xp;
    for ($l = 0; $l < $lvl; $l++) $base -= WEB_XP_BASE + WEB_XP_STEP * $l;
    web_out(['list' => $list, 'me' => ['xp' => $xp, 'messages' => (int)$me['messages'], 'level' => $lvl, 'into' => $base, 'need' => WEB_XP_BASE + WEB_XP_STEP * $lvl, 'rank' => (int)($above['c'] ?? 0) + 1]]);
}

case 'DiscordExt_EditDM': {
    $mid = (int)($in['messageId'] ?? 0);
    $text = isset($in['text']) && is_string($in['text']) ? trim(web_clip($in['text'], WEB_DM_MAX)) : '';
    $m = web_one('SELECT id, dm_id, identifier FROM phone_discord_dm_messages WHERE id = ?', [$mid]);
    if (!$m || $m['identifier'] !== $ident || $text === '') web_out(false);
    $dm = web_dm_for($ident, (int)$m['dm_id']);
    if (!$dm || !web_can_talk($ident, $dm['other']) || web_automod_hit(0, $text)) web_out(false);
    $t = web_now();
    web_db()->prepare('UPDATE phone_discord_dm_messages SET message = ?, edited_at = ? WHERE id = ?')->execute([$text, $t, $mid]);
    web_out(['ok' => true, 'message' => $text, 'edited_at' => $t]);
}

case 'DiscordExt_DeleteDM': {
    $mid = (int)($in['messageId'] ?? 0);
    $m = web_one('SELECT id, dm_id, identifier FROM phone_discord_dm_messages WHERE id = ?', [$mid]);
    if (!$m || $m['identifier'] !== $ident || !web_dm_for($ident, (int)$m['dm_id'])) web_out(false);
    web_db()->prepare('DELETE FROM phone_discord_dm_messages WHERE id = ?')->execute([$mid]);
    web_out(true);
}

case 'DiscordExt_MarkDMSeen': {
    $dm = web_dm_for($ident, (int)($in['dmId'] ?? 0));
    if (!$dm) web_out(false);
    $maxId = (int)(web_one('SELECT COALESCE(MAX(id), 0) AS m FROM phone_discord_dm_messages WHERE dm_id = ?', [$dm['id']])['m'] ?? 0);
    if (web_one('SELECT 1 AS x FROM phone_discord_dm_seen WHERE identifier = ? AND dm_id = ?', [$ident, $dm['id']])) web_db()->prepare('UPDATE phone_discord_dm_seen SET last_id = ? WHERE identifier = ? AND dm_id = ?')->execute([$maxId, $ident, $dm['id']]);
    else web_db()->prepare('INSERT INTO phone_discord_dm_seen (identifier, dm_id, last_id) VALUES (?, ?, ?)')->execute([$ident, $dm['id'], $maxId]);
    web_out(true);
}

case 'DiscordExt_AddFriendByTag': {
    if (!preg_match('/^(.+?)\s*#\s*(\d{4})$/u', trim((string)($in['tag'] ?? '')), $m)) web_out(['error' => 'BAD_TAG']);
    $name = web_lower(preg_replace('/\s+/', '', $m[1]));
    $target = null;
    foreach (web_q('SELECT p.identifier, p.discriminator FROM phone_discord_profiles p WHERE p.discriminator = ?', [$m[2]]) as $cand) {
        if (web_lower(preg_replace('/\s+/', '', web_name($cand['identifier']))) === $name && web_account($cand['identifier'])) { $target = $cand['identifier']; break; }
    }
    if (!$target) web_out(['error' => 'NOT_FOUND']);
    $p = web_profile($target);
    $uid = (int)$p['uid'];
    // same rules as the game: request, or accept when they already asked us
    if ($target === $ident) web_out(['error' => 'SELF']);
    [$low, $high] = $ident < $target ? [$ident, $target] : [$target, $ident];
    $row = web_one('SELECT * FROM phone_discord_friends WHERE user_low = ? AND user_high = ?', [$low, $high]);
    if ($row) {
        if ($row['status'] === 'accepted') web_out(['error' => 'ALREADY']);
        if ($row['requester'] === $ident) web_out(['error' => 'PENDING']);
        web_db()->prepare("UPDATE phone_discord_friends SET status = 'accepted' WHERE id = ?")->execute([(int)$row['id']]);
        web_out(['ok' => true, 'status' => 'accepted', 'uid' => $uid]);
    }
    web_db()->prepare("INSERT INTO phone_discord_friends (user_low, user_high, requester, status, created_at) VALUES (?, ?, ?, 'pending', ?)")->execute([$low, $high, $ident, web_now()]);
    web_out(['ok' => true, 'status' => 'sent', 'uid' => $uid]);
}

case 'GetDiscordNewMessages': {
    // live chat on the website: messages after the id the page already has
    $cid = (int)($in['channelId'] ?? 0);
    $after = (int)($in['afterId'] ?? 0);
    $ch = web_channel($cid);
    if (!$ch || !web_member($ident, (int)$ch['server_id']) || !web_can_view($ch, (int)$ch['server_id'])) web_out(false);
    $rows = web_q('SELECT id, identifier, author_name, message, created_at, edited_at, is_announcement, reply_to_id FROM phone_discord_messages WHERE channel_id = ? AND id > ? ORDER BY id ASC LIMIT 50', [$cid, $after]);
    $nicks = []; $verified = []; $memberIds = [];
    foreach (web_q('SELECT m.id, m.identifier, m.nickname, p.verified FROM phone_discord_members m LEFT JOIN phone_discord_profiles p ON p.identifier = m.identifier WHERE m.server_id = ?', [(int)$ch['server_id']]) as $m) {
        $nicks[$m['identifier']] = $m['nickname']; $verified[$m['identifier']] = web_bool($m['verified']); $memberIds[$m['identifier']] = (int)$m['id'];
    }
    $out = [];
    foreach ($rows as $r) {
        $a = $r['identifier'];
        $out[] = ['id' => (int)$r['id'], 'serverId' => (int)$ch['server_id'], 'channelId' => $cid, 'author_name' => !empty($nicks[$a]) ? $nicks[$a] : $r['author_name'],
                  'message' => $r['message'], 'created_at' => (int)$r['created_at'], 'edited_at' => $r['edited_at'] !== null ? (int)$r['edited_at'] : null,
                  'isAnnouncement' => web_bool($r['is_announcement']), 'isMine' => $a === $ident, 'authorMemberId' => $memberIds[$a] ?? null,
                  'authorVerified' => $verified[$a] ?? false, 'reactions' => [], 'roleMentions' => []];
    }
    web_out($out);
}

// ---------------------------------------------------------------- moderation & channels (owner / admins; stricter than the game)
case 'KickDiscordMember':
case 'DiscordExt_Timeout':
case 'DiscordExt_Warn':
case 'DiscordExt_ClearWarns':
case 'DiscordExt_GetMemberMod':
case 'ToggleDiscordAdmin':
case 'CreateDiscordChannel':
case 'DiscordExt_SetChannelInfo':
case 'DiscordExt_BulkDelete':
case 'DiscordExt_ToggleFeatured': {
    web_mod_action($ep, $ident, $in);
}

// ---------------------------------------------------------------- roles (owner / admins; administrator only for the owner)
case 'DiscordExt_GetRoles':
case 'DiscordExt_CreateRole':
case 'DiscordExt_UpdateRole':
case 'DiscordExt_DeleteRole':
case 'DiscordExt_SetMemberRole':
case 'DiscordExt_MoveRole': {
    web_role_action($ep, $ident, $in);
}

// ---------------------------------------------------------------- server settings & invites (owner / admins)
case 'DiscordExt_SetTheme':
case 'DiscordExt_SetWelcome':
case 'DiscordExt_SetVanity':
case 'DiscordExt_SetServerIcon':
case 'DiscordExt_CreateInvite':
case 'DiscordExt_ListInvites':
case 'DiscordExt_RevokeInvite': {
    web_settings_action($ep, $ident, $in);
}

// ---------------------------------------------------------------- bans, audit log, appeals
case 'DiscordExt_GetServerBans':
case 'DiscordExt_BanMember':
case 'DiscordExt_UnbanMember':
case 'DiscordExt_GetServerAudit': {
    $sid = (int)($in['serverId'] ?? 0);
    $server = $sid ? web_server($sid) : null;
    if (!$server || !(web_is_owner($ident, $server) || web_is_admin($ident, $sid))) web_out(false);
    if ($ep === 'DiscordExt_GetServerBans') {
        $out = [];
        foreach (web_q('SELECT identifier, name, reason, banned_by, created_at FROM phone_discord_server_bans WHERE server_id = ? ORDER BY created_at DESC LIMIT 100', [$sid]) as $b) {
            $out[] = ['identifier' => $b['identifier'], 'name' => $b['name'], 'reason' => $b['reason'], 'by' => $b['banned_by'], 'at' => (int)$b['created_at']];
        }
        web_out($out);
    }
    if ($ep === 'DiscordExt_UnbanMember') {
        web_db()->prepare('DELETE FROM phone_discord_server_bans WHERE server_id = ? AND identifier = ?')->execute([$sid, (string)($in['identifier'] ?? '')]);
        web_out(['ok' => true]);
    }
    if ($ep === 'DiscordExt_BanMember') {
        $m = web_one('SELECT id, identifier, nickname FROM phone_discord_members WHERE id = ? AND server_id = ?', [(int)($in['memberId'] ?? 0), $sid]);
        if (!$m || $m['identifier'] === $ident || $m['identifier'] === ($server['owner_identifier'] ?? '')) web_out(['error' => 'NOT_ALLOWED']);
        $target = web_one('SELECT is_admin FROM phone_discord_members WHERE id = ?', [(int)$m['id']]);
        if (web_bool($target['is_admin'] ?? 0) && !web_is_owner($ident, $server)) web_out(['error' => 'NOT_ALLOWED']);
        $reason = web_clip(preg_replace('/[\x00-\x1F]/', ' ', trim((string)($in['reason'] ?? ''))), 160);
        web_db()->prepare('DELETE FROM phone_discord_server_bans WHERE server_id = ? AND identifier = ?')->execute([$sid, $m['identifier']]);
        web_db()->prepare('INSERT INTO phone_discord_server_bans (server_id, identifier, name, reason, banned_by, created_at) VALUES (?, ?, ?, ?, ?, ?)')
            ->execute([$sid, $m['identifier'], web_clip((string)$m['nickname'], 60), $reason, web_name($ident), web_now()]);
        web_db()->prepare('DELETE FROM phone_discord_members WHERE id = ?')->execute([(int)$m['id']]);
        web_db()->prepare('DELETE FROM phone_discord_member_roles WHERE server_id = ? AND identifier = ?')->execute([$sid, $m['identifier']]);
        web_out(['ok' => true]);
    }
    // GetServerAudit
    web_ensure_audit_table();
    $out = [];
    foreach (web_q('SELECT actor_name, action, target, created_at FROM phone_discord_server_audit WHERE server_id = ? ORDER BY id DESC LIMIT 100', [$sid]) as $r) {
        $out[] = ['actor' => $r['actor_name'], 'action' => $r['action'], 'target' => $r['target'], 'at' => (int)$r['created_at']];
    }
    web_out($out);
}

case 'DiscordExt_GetMyPunishments': {
    $sid = (int)($in['serverId'] ?? 0);
    if (!$sid || !web_member($ident, $sid)) web_out(false);
    $warns = web_q('SELECT id, reason, created_at FROM phone_discord_warns WHERE server_id = ? AND identifier = ? ORDER BY id DESC LIMIT 20', [$sid, $ident]);
    $t = web_one('SELECT until_at FROM phone_discord_timeouts WHERE server_id = ? AND identifier = ?', [$sid, $ident]);
    $pend = web_q("SELECT kind, ref_id FROM phone_discord_appeals WHERE server_id = ? AND identifier = ? AND status = 'pending'", [$sid, $ident]);
    web_out([
        'timeoutUntil' => ($t && (int)$t['until_at'] > web_now()) ? (int)$t['until_at'] : null,
        'warns' => array_map(fn($w) => ['id' => (int)$w['id'], 'reason' => $w['reason'], 'createdAt' => (int)$w['created_at']], $warns),
        'pending' => array_map(fn($p) => ['kind' => $p['kind'], 'ref_id' => (int)$p['ref_id']], $pend),
    ]);
}

case 'DiscordExt_SubmitAppeal': {
    $sid = (int)($in['serverId'] ?? 0);
    if (!$sid || !web_member($ident, $sid)) web_out(false);
    $kind = (string)($in['kind'] ?? '');
    if ($kind !== 'timeout' && $kind !== 'warn') web_out(['error' => 'BAD_KIND']);
    $text = web_clip(trim((string)($in['text'] ?? '')), 500);
    if (web_strlen($text) < 10) web_out(['error' => 'TOO_SHORT']);
    $ref = 0;
    if ($kind === 'timeout') {
        $t = web_one('SELECT until_at FROM phone_discord_timeouts WHERE server_id = ? AND identifier = ?', [$sid, $ident]);
        if (!$t || (int)$t['until_at'] <= web_now()) web_out(['error' => 'NO_PUNISHMENT']);
    } else {
        $ref = (int)($in['warnId'] ?? 0);
        if (!web_one('SELECT id FROM phone_discord_warns WHERE id = ? AND server_id = ? AND identifier = ?', [$ref, $sid, $ident])) web_out(['error' => 'NO_PUNISHMENT']);
    }
    if (web_one("SELECT id FROM phone_discord_appeals WHERE server_id = ? AND identifier = ? AND kind = ? AND ref_id = ? AND status = 'pending'", [$sid, $ident, $kind, $ref])) web_out(['error' => 'ALREADY_PENDING']);
    web_db()->prepare("INSERT INTO phone_discord_appeals (server_id, identifier, kind, ref_id, text, status, created_at) VALUES (?, ?, ?, ?, ?, 'pending', ?)")
        ->execute([$sid, $ident, $kind, $ref, $text, web_now()]);
    web_out(['ok' => true]);
}

case 'DiscordExt_GetAppeals': {
    $sid = (int)($in['serverId'] ?? 0);
    $server = $sid ? web_server($sid) : null;
    if (!$server || !(web_is_owner($ident, $server) || web_is_admin($ident, $sid))) web_out(false);
    $out = [];
    foreach (web_q("SELECT a.id, a.identifier, a.kind, a.ref_id, a.text, a.created_at, m.nickname FROM phone_discord_appeals a LEFT JOIN phone_discord_members m ON m.server_id = a.server_id AND m.identifier = a.identifier WHERE a.server_id = ? AND a.status = 'pending' ORDER BY a.id ASC LIMIT 100", [$sid]) as $a) {
        if ($a['kind'] === 'timeout') { $r = web_one('SELECT reason FROM phone_discord_timeouts WHERE server_id = ? AND identifier = ?', [$sid, $a['identifier']]); }
        else { $r = web_one('SELECT reason FROM phone_discord_warns WHERE id = ?', [(int)$a['ref_id']]); }
        $out[] = ['id' => (int)$a['id'], 'name' => $a['nickname'] ?? 'Member', 'kind' => $a['kind'], 'text' => $a['text'], 'reason' => $r['reason'] ?? '', 'createdAt' => (int)$a['created_at']];
    }
    web_out($out);
}

case 'DiscordExt_ResolveAppeal': {
    $a = web_one('SELECT * FROM phone_discord_appeals WHERE id = ?', [(int)($in['appealId'] ?? 0)]);
    if (!$a || $a['status'] !== 'pending') web_out(false);
    $server = web_server((int)$a['server_id']);
    if (!$server || !(web_is_owner($ident, $server) || web_is_admin($ident, (int)$a['server_id']))) web_out(false);
    $accept = ($in['accept'] ?? false) === true;
    if ($accept) {
        if ($a['kind'] === 'timeout') web_db()->prepare('DELETE FROM phone_discord_timeouts WHERE server_id = ? AND identifier = ?')->execute([(int)$a['server_id'], $a['identifier']]);
        else web_db()->prepare('DELETE FROM phone_discord_warns WHERE id = ?')->execute([(int)$a['ref_id']]);
    }
    web_db()->prepare("UPDATE phone_discord_appeals SET status = ?, handled_by = ?, handled_at = ? WHERE id = ?")
        ->execute([$accept ? 'accepted' : 'denied', web_name($ident), web_now(), (int)$a['id']]);
    web_out(['ok' => true]);
}

// ---------------------------------------------------------------- newer features (edit history, staff notes, templates, health, follows, profile look)
case 'DiscordExt_GetEditHistory':
case 'DiscordExt_GetStaffNotes':
case 'DiscordExt_AddStaffNote':
case 'DiscordExt_DeleteStaffNote':
case 'DiscordExt_GetChannelTemplates':
case 'DiscordExt_CreateChannelFromTemplate':
case 'DiscordExt_SaveChannelTemplate':
case 'DiscordExt_DeleteChannelTemplate':
case 'DiscordExt_GetHealth':
case 'DiscordExt_GetMutualFriends':
case 'DiscordExt_SetChannelOrder':
case 'DiscordExt_SetAvatarEffect':
case 'DiscordExt_SetBanner':
case 'DiscordExt_SetAnnouncementChannel':
case 'DiscordExt_GetAnnouncementChannels':
case 'DiscordExt_FollowChannel':
case 'DiscordExt_UnfollowChannel':
case 'DiscordExt_GetFollows': {
    web_content_action($ep, $ident, $in);
}

case 'GetMessageRequests':
case 'DiscordExt_GetMessageRequests': {
    $out = [];
    foreach (web_q("SELECT id, requested_by, last_at FROM phone_discord_dms WHERE request_state = 'pending' AND requested_by <> ? AND (user_low = ? OR user_high = ?) ORDER BY last_at DESC LIMIT 50", [$ident, $ident, $ident]) as $d) {
        $first = web_one('SELECT message FROM phone_discord_dm_messages WHERE dm_id = ? ORDER BY id DESC LIMIT 1', [(int)$d['id']]);
        $out[] = ['dmId' => (int)$d['id'], 'user' => web_cards([$d['requested_by']])[$d['requested_by']] ?? null,
                  'lastMessage' => $first ? web_clip((string)$first['message'], 80) : '', 'at' => (int)$d['last_at']];
    }
    web_out($out);
}
case 'DiscordExt_AcceptRequest':
case 'DiscordExt_DeclineRequest': {
    $dm = web_dm_for($ident, (int)($in['dmId'] ?? 0));
    if (!$dm || $dm['request_state'] !== 'pending' || $dm['requested_by'] === $ident) web_out(false);
    if ($ep === 'DiscordExt_AcceptRequest') {
        web_db()->prepare("UPDATE phone_discord_dms SET request_state = 'accepted' WHERE id = ?")->execute([(int)$dm['id']]);
    } else {
        web_db()->prepare('DELETE FROM phone_discord_dm_messages WHERE dm_id = ?')->execute([(int)$dm['id']]);
        web_db()->prepare('DELETE FROM phone_discord_dm_seen WHERE dm_id = ?')->execute([(int)$dm['id']]);
        web_db()->prepare('DELETE FROM phone_discord_dms WHERE id = ?')->execute([(int)$dm['id']]);
    }
    web_out(['ok' => true]);
}

// ---------------------------------------------------------------- super reactions
case 'DiscordExt_SuperReact': {
    $mid = (int)($in['messageId'] ?? 0);
    $emoji = (string)($in['emoji'] ?? '');
    $m = web_one('SELECT m.id, c.server_id FROM phone_discord_messages m JOIN phone_discord_channels c ON c.id = m.channel_id WHERE m.id = ?', [$mid]);
    if (!$m || !web_member($ident, (int)$m['server_id']) || $emoji === '' || strlen($emoji) > 32 || preg_match('/[A-Za-z\s]/', $emoji)) web_out(false);
    $mine = web_one('SELECT id, emoji FROM phone_discord_reactions WHERE message_id = ? AND identifier = ? AND is_super = 1', [$mid, $ident]);
    if ($mine) {
        web_db()->prepare('DELETE FROM phone_discord_reactions WHERE id = ?')->execute([(int)$mine['id']]);
        if ($mine['emoji'] === $emoji) web_out(['ok' => true, 'removed' => true]);
    }
    web_db()->prepare('INSERT INTO phone_discord_reactions (message_id, identifier, emoji, created_at, is_super) VALUES (?, ?, ?, ?, 1)')->execute([$mid, $ident, $emoji, web_now()]);
    web_out(['ok' => true, 'super' => true]);
}

// ---------------------------------------------------------------- folders, gallery, image emoji
case 'DiscordExt_GetFolders':
case 'DiscordExt_CreateFolder':
case 'DiscordExt_EditFolder':
case 'DiscordExt_DeleteFolder':
case 'DiscordExt_MoveToFolder':
    web_folder_action($ep, $ident, $in);
case 'DiscordExt_GetGalleryImages':
    web_gallery_action($ep, $ident, $in);
case 'DiscordExt_AddImageEmoji':
case 'DiscordExt_RemoveImageEmoji':
    web_image_emoji_action($ep, $ident, $in);

// ---------------------------------------------------------------- channel permissions and private channels
case 'DiscordExt_GetChannelPerms':
case 'DiscordExt_SetChannelPerm':
case 'DiscordExt_SetChannelPrivate':
    web_channel_perm_action($ep, $ident, $in);

// ---------------------------------------------------------------- the remaining simple settings and aliases
case 'DiscordExt_SetAvatar': {
    $url = trim((string)($in['url'] ?? ''));
    if ($url !== '' && !web_media_url_ok($url)) web_out(['error' => 'BAD_URL']);
    web_db()->prepare('UPDATE phone_discord_profiles SET avatar_url = ? WHERE identifier = ?')->execute([$url !== '' ? $url : null, $ident]);
    web_out(['ok' => true, 'avatar' => $url !== '' ? $url : null]);
}
case 'DiscordExt_SetRoleIcon':
case 'DiscordExt_SetServerTags':
case 'DiscordExt_SetDiscoverCategory':
case 'DiscordExt_AddAutoModWord':
case 'DiscordExt_RemoveAutoModWord':
case 'DiscordExt_AddEmoji':
case 'DiscordExt_RemoveEmoji':
case 'DiscordExt_CreateStageChannel':
case 'DiscordExt_AcceptRules': {
    web_setting_action($ep, $ident, $in);
}

// ---------------------------------------------------------------- message reports and the report queue
case 'DiscordExt_Report': {
    $mid = (int)($in['messageId'] ?? 0);
    $m = web_one('SELECT m.id, m.channel_id, m.identifier, m.author_name, m.message, c.server_id FROM phone_discord_messages m JOIN phone_discord_channels c ON c.id = m.channel_id WHERE m.id = ?', [$mid]);
    if (!$m || !web_member($ident, (int)$m['server_id'])) web_out(false);
    if ($m['identifier'] === $ident) web_out(['error' => 'SELF']);
    $last = (int)($_SESSION['dc_report_last'] ?? 0);
    if (time() - $last < 20) web_out(['error' => 'COOLDOWN']);
    if (web_one('SELECT id FROM phone_discord_reports WHERE message_id = ? AND reporter_identifier = ?', [$mid, $ident])) web_out(['error' => 'DUP']);
    $reason = web_clip(trim((string)($in['reason'] ?? '')), 150);
    web_db()->prepare("INSERT INTO phone_discord_reports (server_id, channel_id, message_id, message_text, author_identifier, author_name, reporter_identifier, reporter_name, reason, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending', ?)")
        ->execute([(int)$m['server_id'], (int)$m['channel_id'], $mid, web_clip((string)$m['message'], 400), $m['identifier'], $m['author_name'], $ident, web_name($ident), $reason, web_now()]);
    $_SESSION['dc_report_last'] = time();
    web_out(['ok' => true]);
}
case 'DiscordExt_StaffReports': {
    // the queue on the website is per server: owners and admins see the reports of their own servers
    $status = (string)($in['status'] ?? 'pending');
    if (!in_array($status, ['pending', 'dismissed', 'removed'], true)) $status = 'pending';
    $mine = [];
    foreach (web_q('SELECT id FROM phone_discord_servers') as $sv) {
        if (web_is_staff_of($ident, (int)$sv['id'])) $mine[] = (int)$sv['id'];
    }
    $rows = [];
    if ($mine) {
        [$ph, $args] = web_in($mine);
        $rows = web_q("SELECT r.id, r.message_id, r.message_text, r.author_name, r.reporter_name, r.reason, r.status, r.created_at, r.handled_by, s.name AS server_name, c.name AS channel_name
                       FROM phone_discord_reports r LEFT JOIN phone_discord_servers s ON s.id = r.server_id LEFT JOIN phone_discord_channels c ON c.id = r.channel_id
                       WHERE r.status = ? AND r.server_id IN ($ph) ORDER BY r.id DESC LIMIT 100", array_merge([$status], $args));
        $pending = (int)(web_one("SELECT COUNT(*) AS c FROM phone_discord_reports WHERE status = 'pending' AND server_id IN ($ph)", $args)['c'] ?? 0);
    } else { $pending = 0; }
    web_out(['reports' => array_map(fn($r) => array_merge($r, ['id' => (int)$r['id'], 'message_id' => (int)$r['message_id'], 'created_at' => (int)$r['created_at']]), $rows), 'pending' => $pending]);
}
case 'DiscordExt_StaffResolveReport': {
    $r = web_one('SELECT * FROM phone_discord_reports WHERE id = ?', [(int)($in['reportId'] ?? 0)]);
    $action = (string)($in['action'] ?? '');
    if (!$r || $r['status'] !== 'pending' || !web_is_staff_of($ident, (int)$r['server_id'])) web_out(false);
    if (!in_array($action, ['dismiss', 'delete', 'delete_warn'], true)) web_out(false);
    $by = web_name($ident); $t = web_now();
    if ($action === 'dismiss') {
        web_db()->prepare("UPDATE phone_discord_reports SET status = 'dismissed', handled_by = ?, handled_at = ? WHERE message_id = ? AND status = 'pending'")->execute([$by, $t, (int)$r['message_id']]);
    } else {
        web_db()->prepare('DELETE FROM phone_discord_reactions WHERE message_id = ?')->execute([(int)$r['message_id']]);
        web_db()->prepare('DELETE FROM phone_discord_messages WHERE id = ?')->execute([(int)$r['message_id']]);
        web_db()->prepare("UPDATE phone_discord_reports SET status = 'removed', handled_by = ?, handled_at = ? WHERE message_id = ? AND status = 'pending'")->execute([$by, $t, (int)$r['message_id']]);
        if ($action === 'delete_warn') {
            web_db()->prepare('INSERT INTO phone_discord_warns (server_id, identifier, reason, by_name, created_at) VALUES (?, ?, ?, ?, ?)')
                ->execute([(int)$r['server_id'], $r['author_identifier'], 'Reported message removed', $by, $t]);
        }
    }
    web_out(true);
}

// ---------------------------------------------------------------- mute (chat only; no voice or speakers)
case 'DiscordExt_SetMute': {
    $kind = (string)($in['kind'] ?? '');
    $target = (int)($in['targetId'] ?? 0);
    if (!in_array($kind, ['channel', 'server'], true) || !$target) web_out(false);
    if ($kind === 'channel') {
        $ch = web_channel($target);
        if (!$ch || !web_member($ident, (int)$ch['server_id'])) web_out(false);
    } else {
        if (!web_member($ident, $target)) web_out(false);
    }
    web_db()->prepare('DELETE FROM phone_discord_mutes WHERE identifier = ? AND kind = ? AND target_id = ?')->execute([$ident, $kind, $target]);
    if (($in['on'] ?? false) === true) web_db()->prepare('INSERT INTO phone_discord_mutes (identifier, kind, target_id) VALUES (?, ?, ?)')->execute([$ident, $kind, $target]);
    web_out(true);
}

// ---------------------------------------------------------------- channel categories (same rules as the game, v45)
case 'DiscordExt_GetCategories':
case 'DiscordExt_CreateCategory':
case 'DiscordExt_DeleteCategory':
case 'DiscordExt_SetChannelCategory': {
    $sid = (int)($in['serverId'] ?? 0);
    if (!$sid || !web_member($ident, $sid)) web_out($ep === 'DiscordExt_GetCategories' ? ['categories' => [], 'channels' => (object)[]] : false);
    if ($ep === 'DiscordExt_GetCategories') {
        $cats = array_map(fn($c) => ['id' => (int)$c['id'], 'name' => $c['name'], 'position' => (int)$c['position']],
            web_q('SELECT id, name, position FROM phone_discord_categories WHERE server_id = ? ORDER BY position, id', [$sid]));
        $map = (object)[];
        foreach (web_q('SELECT id, category_id FROM phone_discord_channels WHERE server_id = ? AND category_id IS NOT NULL', [$sid]) as $r) $map->{(string)$r['id']} = (int)$r['category_id'];
        web_out(['categories' => $cats, 'channels' => $map]);
    }
    if (!web_is_staff($ident, $sid)) web_out(['error' => 'NO_PERMISSION']);
    if ($ep === 'DiscordExt_CreateCategory') {
        if (!web_can_create($ident)) web_out(['error' => 'NOT_CREATOR']);
        $name = web_clip(trim(preg_replace('/[\x00-\x1F]/', '', (string)($in['name'] ?? ''))), 30);
        if ($name === '') web_out(['error' => 'BAD_NAME']);
        $n = (int)(web_one('SELECT COUNT(*) AS c FROM phone_discord_categories WHERE server_id = ?', [$sid])['c'] ?? 0);
        if ($n >= 10) web_out(['error' => 'LIMIT']);
        if (web_one('SELECT id FROM phone_discord_categories WHERE server_id = ? AND LOWER(name) = LOWER(?)', [$sid, $name])) web_out(['error' => 'TAKEN']);
        web_db()->prepare('INSERT INTO phone_discord_categories (server_id, name, position, created_at) VALUES (?, ?, ?, ?)')->execute([$sid, $name, $n, web_now()]);
        web_out(['ok' => true, 'id' => (int)web_db()->lastInsertId(), 'name' => $name]);
    }
    if ($ep === 'DiscordExt_DeleteCategory') {
        $cid = (int)($in['categoryId'] ?? 0);
        if (!web_one('SELECT id FROM phone_discord_categories WHERE id = ? AND server_id = ?', [$cid, $sid])) web_out(false);
        web_db()->prepare('UPDATE phone_discord_channels SET category_id = NULL WHERE server_id = ? AND category_id = ?')->execute([$sid, $cid]);
        web_db()->prepare('DELETE FROM phone_discord_categories WHERE id = ?')->execute([$cid]);
        web_out(['ok' => true]);
    }
    $chId = (int)($in['channelId'] ?? 0); $cid = (int)($in['categoryId'] ?? 0);
    if (!web_one('SELECT id FROM phone_discord_channels WHERE id = ? AND server_id = ?', [$chId, $sid])) web_out(false);
    if ($cid !== 0 && !web_one('SELECT id FROM phone_discord_categories WHERE id = ? AND server_id = ?', [$cid, $sid])) web_out(false);
    web_db()->prepare('UPDATE phone_discord_channels SET category_id = ? WHERE id = ?')->execute([$cid !== 0 ? $cid : null, $chId]);
    web_out(['ok' => true]);
}

// ---------------------------------------------------------------- the ID you choose (3-20 chars: a-z 0-9 _ .) and mutual servers
case 'DiscordExt_SetHandle': {
    $h = strtolower(trim((string)($in['handle'] ?? '')));
    if (!preg_match('/^[a-z0-9_.]{3,20}$/', $h)) web_out(['error' => 'BAD_HANDLE']);
    web_profile($ident);
    if (web_one('SELECT identifier FROM phone_discord_profiles WHERE handle = ? AND identifier <> ?', [$h, $ident])) web_out(['error' => 'TAKEN']);
    web_db()->prepare('UPDATE phone_discord_profiles SET handle = ? WHERE identifier = ?')->execute([$h, $ident]);
    web_out(['ok' => true, 'handle' => $h]);
}
case 'DiscordExt_GetMutualServers': {
    $other = web_one('SELECT identifier FROM phone_discord_profiles WHERE uid = ?', [(int)($in['uid'] ?? 0)]);
    if (!$other || $other['identifier'] === $ident) web_out([]);
    web_out(array_map(fn($r) => ['id' => (int)$r['id'], 'name' => $r['name']],
        web_q('SELECT s.id, s.name FROM phone_discord_servers s JOIN phone_discord_members a ON a.server_id = s.id AND a.identifier = ? JOIN phone_discord_members b ON b.server_id = s.id AND b.identifier = ? ORDER BY s.name LIMIT 50', [$ident, $other['identifier']])));
}

// ---------------------------------------------------------------- Security Actions: Pause Invites (owner / admins; 24 hours)
case 'DiscordExt_GetSecurity':
case 'DiscordExt_SetInvitesPaused': {
    $sid = (int)($in['serverId'] ?? 0);
    if (!$sid || !web_server($sid) || !web_is_staff_of($ident, $sid)) web_out($ep === 'DiscordExt_GetSecurity' ? false : ['error' => 'NO_PERMISSION']);
    if ($ep === 'DiscordExt_GetSecurity') {
        $r = web_one('SELECT invites_paused_until AS u FROM phone_discord_servers WHERE id = ?', [$sid]);
        $u = (int)($r['u'] ?? 0);
        web_out(['invitesPausedUntil' => $u > web_now() ? $u : null, 'now' => web_now()]);
    }
    $until = (($in['on'] ?? false) === true) ? web_now() + 86400 : null;
    web_db()->prepare('UPDATE phone_discord_servers SET invites_paused_until = ? WHERE id = ?')->execute([$until, $sid]);
    web_out(['ok' => true, 'invitesPausedUntil' => $until]);
}

// ---------------------------------------------------------------- Privacy Settings: allow direct messages from server members
case 'DiscordExt_GetPrivacy':
case 'DiscordExt_SetPrivacy': {
    $sid = (int)($in['serverId'] ?? 0);
    if (!$sid || !web_member($ident, $sid)) web_out($ep === 'DiscordExt_GetPrivacy' ? false : ['error' => 'NOT_MEMBER']);
    if ($ep === 'DiscordExt_GetPrivacy') {
        $r = web_one('SELECT allow_dms FROM phone_discord_dm_privacy WHERE identifier = ? AND server_id = ?', [$ident, $sid]);
        web_out(['allowDms' => !$r || (int)$r['allow_dms'] !== 0]);
    }
    $allow = (($in['allowDms'] ?? false) === true) ? 1 : 0;
    web_db()->prepare('DELETE FROM phone_discord_dm_privacy WHERE identifier = ? AND server_id = ?')->execute([$ident, $sid]);
    web_db()->prepare('INSERT INTO phone_discord_dm_privacy (identifier, server_id, allow_dms) VALUES (?, ?, ?)')->execute([$ident, $sid, $allow]);
    web_out(['ok' => true, 'allowDms' => $allow === 1]);
}

default:
    web_out(false);
}


function web_join(string $ident, array $s): void {
    $sid = (int)$s['id'];
    web_db()->prepare('INSERT INTO phone_discord_members (server_id, identifier, nickname, joined_at, is_admin) VALUES (?, ?, ?, ?, 0)')
        ->execute([$sid, $ident, web_name($ident), web_now()]);
}
function web_server_card_for_join(string $ident, array $s): array {
    return ['id' => (int)$s['id'], 'name' => $s['name'], 'icon_text' => $s['icon_text'], 'icon_color' => $s['icon_color'],
            'invite_code' => $s['invite_code'], 'isOwner' => web_is_owner($ident, $s), 'isVerified' => web_bool($s['is_verified'] ?? 0)];
}
function web_discover(string $query, string $category, string $ident): array {
    $q = trim($query);
    $cats = ['gaming', 'roleplay', 'gangs', 'jobs', 'community', 'other'];
    $where = 's.is_public = 1'; $args = [];
    if (in_array($category, $cats, true)) { $where .= ' AND s.category = ?'; $args[] = $category; }
    if (web_strlen($q) >= 2) {
        $like = '%' . strtr(web_lower(web_clip($q, 40)), ['!' => '!!', '%' => '!%', '_' => '!_']) . '%';
        $where .= " AND (LOWER(s.name) LIKE ? ESCAPE '!' OR LOWER(s.description) LIKE ? ESCAPE '!')";
        $args[] = $like; $args[] = $like;
    }
    $rows = web_q("SELECT s.id, s.name, s.icon_text, s.icon_color, s.icon_url, s.description, s.category, s.is_verified, s.is_featured, s.vanity,
                          (SELECT COUNT(*) FROM phone_discord_members m WHERE m.server_id = s.id) AS memberCount
                   FROM phone_discord_servers s WHERE $where ORDER BY s.is_featured DESC, memberCount DESC, s.id ASC LIMIT 60", $args);
    if (!$rows) return [];
    $mine = [];
    foreach (web_q('SELECT server_id FROM phone_discord_members WHERE identifier = ?', [$ident]) as $m) $mine[(int)$m['server_id']] = true;
    $ids = array_map(fn($r) => (int)$r['id'], $rows);
    [$ph, $pa] = web_in($ids);
    $all = web_q("SELECT server_id, identifier FROM phone_discord_members WHERE server_id IN ($ph)", $pa);
    $on = web_online(array_column($all, 'identifier'));
    $online = [];
    foreach ($all as $m) if (isset($on[$m['identifier']])) $online[(int)$m['server_id']] = ($online[(int)$m['server_id']] ?? 0) + 1;
    $out = [];
    foreach ($rows as $r) {
        $id = (int)$r['id'];
        $out[] = ['id' => $id, 'name' => $r['name'], 'icon_text' => $r['icon_text'], 'icon_color' => $r['icon_color'], 'icon_url' => $r['icon_url'],
                  'description' => $r['description'], 'category' => $r['category'], 'vanity' => $r['vanity'], 'isVerified' => web_bool($r['is_verified']),
                  'isFeatured' => web_bool($r['is_featured']), 'memberCount' => (int)$r['memberCount'], 'onlineCount' => $online[$id] ?? 0, 'isMember' => isset($mine[$id])];
    }
    return $out;
}


/**
 * Moderation and channel actions for the website. Only the owner and admins may act (the game also lets
 * roles with the right permission act; the website is stricter). Protections: nobody moderates the owner,
 * admins cannot moderate other admins, only the owner promotes or demotes admins.
 */
function web_mod_action(string $ep, string $ident, array $in): void {
    $sid = (int)($in['serverId'] ?? 0);
    // some actions only send a message or channel id: find the server from it
    if (!$sid && isset($in['messageId'])) {
        $r = web_one('SELECT c.server_id FROM phone_discord_messages m JOIN phone_discord_channels c ON c.id = m.channel_id WHERE m.id = ?', [(int)$in['messageId']]);
        $sid = (int)($r['server_id'] ?? 0);
    }
    if (!$sid && isset($in['channelId'])) {
        $r = web_one('SELECT server_id FROM phone_discord_channels WHERE id = ?', [(int)$in['channelId']]);
        $sid = (int)($r['server_id'] ?? 0);
    }
    $server = $sid ? web_server($sid) : null;
    $isOwner = $server !== null && web_is_owner($ident, $server);
    $isAdmin = $sid ? web_is_admin($ident, $sid) : false;
    $target = null;
    if (isset($in['memberId'])) {
        $target = web_one('SELECT * FROM phone_discord_members WHERE id = ? AND server_id = ?', [(int)$in['memberId'], $sid]);
        if (!$target) web_out(false);
        if ($target['identifier'] === ($server['owner_identifier'] ?? '')) web_out(['error' => 'NOT_ALLOWED']);
        if (web_bool($target['is_admin']) && !$isOwner && $target['identifier'] !== $ident) web_out(['error' => 'NOT_ALLOWED']);
    }
    if (!$isAdmin && !$isOwner) web_out(false);

    switch ($ep) {
    case 'KickDiscordMember':
        if (!$target) web_out(false);
        web_db()->prepare('DELETE FROM phone_discord_members WHERE id = ?')->execute([(int)$target['id']]);
        web_db()->prepare('DELETE FROM phone_discord_member_roles WHERE server_id = ? AND identifier = ?')->execute([$sid, $target['identifier']]);
        web_out(true);
    case 'ToggleDiscordAdmin':
        if (!$isOwner || !$target) web_out(false);
        web_db()->prepare('UPDATE phone_discord_members SET is_admin = ? WHERE id = ?')->execute([web_bool($target['is_admin']) ? 0 : 1, (int)$target['id']]);
        web_out(true);
    case 'DiscordExt_Timeout': {
        if (!$target) web_out(false);
        $min = max(1, min(10080, (int)($in['minutes'] ?? 0)));
        $reason = web_clip(trim((string)($in['reason'] ?? '')), 150);
        web_db()->prepare('DELETE FROM phone_discord_timeouts WHERE server_id = ? AND identifier = ?')->execute([$sid, $target['identifier']]);
        web_db()->prepare('INSERT INTO phone_discord_timeouts (server_id, identifier, until_at, reason, by_name) VALUES (?, ?, ?, ?, ?)')
            ->execute([$sid, $target['identifier'], web_now() + $min * 60, $reason, web_name($ident)]);
        web_out(true);
    }
    case 'DiscordExt_Warn': {
        if (!$target) web_out(false);
        $reason = web_clip(trim((string)($in['reason'] ?? '')), 150);
        web_db()->prepare('INSERT INTO phone_discord_warns (server_id, identifier, reason, by_name, created_at) VALUES (?, ?, ?, ?, ?)')
            ->execute([$sid, $target['identifier'], $reason, web_name($ident), web_now()]);
        web_out(true);
    }
    case 'DiscordExt_ClearWarns':
        if (!$target) web_out(false);
        web_db()->prepare('DELETE FROM phone_discord_warns WHERE server_id = ? AND identifier = ?')->execute([$sid, $target['identifier']]);
        web_out(true);
    case 'DiscordExt_GetMemberMod': {
        if (!$target) web_out(false);
        $warns = web_q('SELECT reason, by_name, created_at FROM phone_discord_warns WHERE server_id = ? AND identifier = ? ORDER BY id DESC LIMIT 30', [$sid, $target['identifier']]);
        $t = web_one('SELECT until_at FROM phone_discord_timeouts WHERE server_id = ? AND identifier = ?', [$sid, $target['identifier']]);
        web_out([
            'nickname' => $target['nickname'], 'warnCount' => count($warns),
            'warns' => array_map(fn($w) => ['reason' => $w['reason'], 'by_name' => $w['by_name'], 'created_at' => (int)$w['created_at']], $warns),
            'timeoutUntil' => ($t && (int)$t['until_at'] > web_now()) ? (int)$t['until_at'] : null,
            'minutes' => [5, 60, 1440],
        ]);
    }
    case 'CreateDiscordChannel': {
        if (!web_can_create($ident)) web_out(['error' => 'NOT_CREATOR']);
        $name = strtolower(preg_replace('/\s+/', '-', trim(web_clip((string)($in['channelName'] ?? ''), 30))));
        if ($name === '' || !$isAdmin && !$isOwner) web_out(false);
        $count = (int)(web_one('SELECT COUNT(*) AS c FROM phone_discord_channels WHERE server_id = ?', [$sid])['c'] ?? 0);
        if ($count >= 50) web_out(['error' => 'LIMIT']);
        web_db()->prepare('INSERT INTO phone_discord_channels (server_id, name, position, created_at) VALUES (?, ?, ?, ?)')->execute([$sid, $name, $count, web_now()]);
        web_out(['ok' => true, 'id' => (int)web_db()->lastInsertId(), 'name' => $name]);
    }
    case 'DiscordExt_SetChannelInfo': {
        $ch = web_channel((int)($in['channelId'] ?? 0));
        if (!$ch || (int)$ch['server_id'] !== $sid) web_out(false);
        $name = strtolower(preg_replace('/\s+/', '-', trim(web_clip((string)($in['name'] ?? ''), 30))));
        if ($name === '') web_out(false);
        $topic = web_clip(trim((string)($in['topic'] ?? '')), 200);
        web_db()->prepare('UPDATE phone_discord_channels SET name = ?, topic = ? WHERE id = ?')->execute([$name, $topic !== '' ? $topic : null, (int)$ch['id']]);
        web_out(['ok' => true, 'name' => $name]);
    }
    case 'DiscordExt_BulkDelete': {
        $ch = web_channel((int)($in['channelId'] ?? 0));
        $ids = array_values(array_filter(array_map('intval', (array)($in['ids'] ?? [])), fn($v) => $v > 0));
        if (!$ch || !$ids || count($ids) > 50) web_out(false);
        $sid2 = (int)$ch['server_id'];
        if (!web_is_admin($ident, $sid2)) web_out(false);
        [$ph, $args] = web_in($ids);
        $rows = web_q("SELECT id FROM phone_discord_messages WHERE channel_id = ? AND id IN ($ph)", array_merge([(int)$ch['id']], $args));
        $done = [];
        foreach ($rows as $r) {
            web_db()->prepare('DELETE FROM phone_discord_reactions WHERE message_id = ?')->execute([(int)$r['id']]);
            web_db()->prepare('DELETE FROM phone_discord_messages WHERE id = ?')->execute([(int)$r['id']]);
            $done[] = (int)$r['id'];
        }
        web_out(['ok' => true, 'count' => count($done), 'ids' => $done]);
    }
    case 'DiscordExt_ToggleFeatured': {
        $m = web_one('SELECT m.id, m.is_featured, c.server_id FROM phone_discord_messages m JOIN phone_discord_channels c ON c.id = m.channel_id WHERE m.id = ?', [(int)($in['messageId'] ?? 0)]);
        if (!$m || !web_is_admin($ident, (int)$m['server_id'])) web_out(false);
        $on = !web_bool($m['is_featured']);
        web_db()->prepare('UPDATE phone_discord_messages SET is_featured = ? WHERE id = ?')->execute([$on ? 1 : 0, (int)$m['id']]);
        web_out(['ok' => true, 'featured' => $on]);
    }
    }
    web_out(false);
}



function web_perms_of(?string $json): array {
    $t = json_decode((string)$json, true);
    $out = [];
    if (is_array($t)) foreach (WEB_PERM_KEYS as $k) if (($t[$k] ?? false) === true) $out[$k] = true;
    return $out;
}
function web_color_ok($c): bool { return $c === null || $c === '' || (is_string($c) && preg_match('/^#[0-9a-fA-F]{6}$/', $c) === 1); }

function web_role_action(string $ep, string $ident, array $in): void {
    $sid = (int)($in['serverId'] ?? 0);
    $server = $sid ? web_server($sid) : null;
    if (!$server) web_out(false);
    $isOwner = web_is_owner($ident, $server);
    if (!$isOwner && !web_is_admin($ident, $sid)) web_out(false);
    $roles = web_q('SELECT * FROM phone_discord_roles WHERE server_id = ? ORDER BY position ASC, id ASC', [$sid]);

    if ($ep === 'DiscordExt_GetRoles') {
        $list = [];
        foreach ($roles as $r) {
            $list[] = ['id' => (int)$r['id'], 'name' => $r['name'], 'color' => $r['color'], 'position' => (int)$r['position'],
                       'mentionable' => web_bool($r['mentionable']), 'hoist' => web_bool($r['hoist']), 'isDefault' => web_bool($r['is_default']),
                       'perms' => web_perms_of($r['perms']), 'editable' => !web_bool($r['is_default']), 'icon' => $r['icon'] ?? null];
        }
        usort($list, fn($a, $b) => ($b['isDefault'] <=> $a['isDefault']) ?: ($b['position'] <=> $a['position']) ?: ($a['id'] <=> $b['id']));
        $members = []; $byIdent = [];
        foreach (web_q('SELECT id, identifier, nickname FROM phone_discord_members WHERE server_id = ? ORDER BY nickname', [$sid]) as $m) {
            $members[] = ['id' => (int)$m['id'], 'nickname' => $m['nickname']];
            $byIdent[$m['identifier']] = (int)$m['id'];
        }
        $assign = [];
        foreach (web_q('SELECT role_id, identifier FROM phone_discord_member_roles WHERE server_id = ?', [$sid]) as $a) {
            if (isset($byIdent[$a['identifier']])) $assign[(string)$a['role_id']][] = $byIdent[$a['identifier']];
        }
        $permList = array_map(fn($k) => ['key' => $k, 'label' => ucfirst(str_replace('_', ' ', $k))], WEB_PERM_KEYS);
        web_out(['roles' => $list, 'members' => $members, 'assign' => (object)$assign, 'permList' => $permList,
                 'canGrantAdmin' => $isOwner, 'isFull' => $isOwner]);
    }

    if ($ep === 'DiscordExt_CreateRole') {
        $name = web_clip(trim((string)($in['name'] ?? '')), 32);
        $color = $in['color'] ?? '';
        if ($name === '' || strtolower($name) === 'everyone' || strtolower($name) === '@everyone' || !web_color_ok($color)) web_out(false);
        if (count($roles) >= 40) web_out(['error' => 'LIMIT']);
        $pos = 1;
        foreach ($roles as $r) $pos = max($pos, (int)$r['position'] + 1);
        web_db()->prepare('INSERT INTO phone_discord_roles (server_id, name, color, position, perms, mentionable, is_default, hoist) VALUES (?, ?, ?, ?, ?, 0, 0, 0)')
            ->execute([$sid, $name, $color !== '' ? $color : null, $pos, '{}']);
        web_out(['ok' => true, 'id' => (int)web_db()->lastInsertId()]);
    }

    $roleId = (int)($in['roleId'] ?? 0);
    $role = null;
    foreach ($roles as $r) if ((int)$r['id'] === $roleId) $role = $r;
    if (!$role) web_out(false);

    if ($ep === 'DiscordExt_UpdateRole') {
        if (web_bool($role['is_default'])) web_out(false);
        $data = is_array($in['data'] ?? null) ? $in['data'] : [];
        $name = $role['name']; $color = $role['color']; $mention = web_bool($role['mentionable']); $hoist = web_bool($role['hoist']);
        if (isset($data['name'])) {
            $name = web_clip(trim((string)$data['name']), 32);
            if ($name === '' || strtolower($name) === 'everyone' || strtolower($name) === '@everyone') web_out(false);
        }
        if (array_key_exists('color', $data)) {
            if (!web_color_ok($data['color'])) web_out(false);
            $color = $data['color'] !== '' ? $data['color'] : null;
        }
        if (array_key_exists('mentionable', $data)) $mention = $data['mentionable'] === true;
        if (array_key_exists('hoist', $data)) $hoist = $data['hoist'] === true;
        $perms = web_perms_of($role['perms']);
        if (is_array($data['perms'] ?? null)) {
            foreach (WEB_PERM_KEYS as $k) {
                if (!array_key_exists($k, $data['perms'])) continue;
                if ($k === 'administrator' && !$isOwner) continue;   // only the owner grants administrator
                if ($data['perms'][$k] === true) $perms[$k] = true; else unset($perms[$k]);
            }
        }
        web_db()->prepare('UPDATE phone_discord_roles SET name = ?, color = ?, mentionable = ?, hoist = ?, perms = ? WHERE id = ?')
            ->execute([$name, $color, $mention ? 1 : 0, $hoist ? 1 : 0, json_encode((object)$perms), $roleId]);
        web_out(['ok' => true]);
    }

    if ($ep === 'DiscordExt_DeleteRole') {
        if (web_bool($role['is_default'])) web_out(false);
        web_db()->prepare('DELETE FROM phone_discord_member_roles WHERE role_id = ?')->execute([$roleId]);
        web_db()->prepare('DELETE FROM phone_discord_channel_perms WHERE role_id = ?')->execute([$roleId]);
        web_db()->prepare('DELETE FROM phone_discord_roles WHERE id = ?')->execute([$roleId]);
        web_out(true);
    }

    if ($ep === 'DiscordExt_SetMemberRole') {
        if (web_bool($role['is_default'])) web_out(false);
        if (!$isOwner && isset(web_perms_of($role['perms'])['administrator'])) web_out(['error' => 'NOT_ALLOWED']);
        $m = web_one('SELECT id, identifier FROM phone_discord_members WHERE id = ? AND server_id = ?', [(int)($in['memberId'] ?? 0), $sid]);
        if (!$m || $m['identifier'] === ($server['owner_identifier'] ?? '')) web_out(false);
        if (($in['on'] ?? false) === true) {
            if (!web_one('SELECT 1 AS x FROM phone_discord_member_roles WHERE role_id = ? AND identifier = ?', [$roleId, $m['identifier']])) {
                web_db()->prepare('INSERT INTO phone_discord_member_roles (server_id, identifier, role_id) VALUES (?, ?, ?)')->execute([$sid, $m['identifier'], $roleId]);
            }
        } else {
            web_db()->prepare('DELETE FROM phone_discord_member_roles WHERE role_id = ? AND identifier = ?')->execute([$roleId, $m['identifier']]);
        }
        web_out(true);
    }

    if ($ep === 'DiscordExt_MoveRole') {
        if (web_bool($role['is_default'])) web_out(false);
        $dir = ($in['dir'] ?? 0) > 0 ? 1 : -1;
        $ordered = array_values(array_filter($roles, fn($r) => !web_bool($r['is_default'])));
        $idx = null;
        foreach ($ordered as $i => $r) if ((int)$r['id'] === $roleId) $idx = $i;
        $j = $idx + $dir;
        if ($idx === null || $j < 0 || $j >= count($ordered)) web_out(false);
        $a = $ordered[$idx]; $b = $ordered[$j];
        web_db()->prepare('UPDATE phone_discord_roles SET position = ? WHERE id = ?')->execute([(int)$b['position'], (int)$a['id']]);
        web_db()->prepare('UPDATE phone_discord_roles SET position = ? WHERE id = ?')->execute([(int)$a['position'], (int)$b['id']]);
        web_out(true);
    }
    web_out(false);
}



/** https image links only, no private addresses (the same rule the game uses for avatars and icons) */
function web_media_url_ok(string $url): bool {
    if (strlen($url) < 12 || strlen($url) > 400) return false;
    if (!preg_match('#^https://([A-Za-z0-9.-]+)(/[A-Za-z0-9\-._~:/?\#\[\]@!$&()*+,;=%]*)?$#', $url, $m)) return false;
    $host = strtolower($m[1]);
    if (strpos($host, '.') === false || preg_match('/^\d+\.\d+\.\d+\.\d+$/', $host) || $host === 'localhost') return false;
    return true;
}

function web_settings_action(string $ep, string $ident, array $in): void {
    $sid = (int)($in['serverId'] ?? 0);
    $server = $sid ? web_server($sid) : null;
    if (!$server) web_out(false);
    if (!web_is_owner($ident, $server) && !web_is_admin($ident, $sid)) web_out(false);

    switch ($ep) {
    case 'DiscordExt_SetTheme': {
        $c = $in['color'] ?? '';
        if (!web_color_ok($c)) web_out(false);
        web_db()->prepare('UPDATE phone_discord_servers SET theme_color = ? WHERE id = ?')->execute([$c !== '' ? $c : null, $sid]);
        web_out(true);
    }
    case 'DiscordExt_SetWelcome': {
        $title = web_clip(trim((string)($in['title'] ?? '')), 60);
        $text = web_clip(trim((string)($in['text'] ?? '')), 300);
        $rules = web_clip(trim((string)($in['rules'] ?? '')), 1000);
        $desc = web_clip(trim((string)($in['description'] ?? '')), 200);
        $require = ($in['require'] ?? false) === true;
        $since = $require ? web_now() : null;
        web_db()->prepare('UPDATE phone_discord_servers SET welcome_title = ?, welcome_text = ?, rules_text = ?, description = ?, require_rules = ?, rules_since = ? WHERE id = ?')
            ->execute([$title !== '' ? $title : null, $text !== '' ? $text : null, $rules !== '' ? $rules : null, $desc !== '' ? $desc : null, $require ? 1 : 0, $since, $sid]);
        web_out(true);
    }
    case 'DiscordExt_SetVanity': {
        $code = strtolower(trim((string)($in['code'] ?? '')));
        if ($code === '') {
            web_db()->prepare('UPDATE phone_discord_servers SET vanity = NULL WHERE id = ?')->execute([$sid]);
            web_out(['ok' => true, 'vanity' => null]);
        }
        if (!preg_match('/^[a-z0-9-]{3,24}$/', $code) || $code[0] === '-' || substr($code, -1) === '-') web_out(['error' => 'BAD_FORMAT']);
        if (web_one('SELECT id FROM phone_discord_servers WHERE vanity = ? AND id <> ?', [$code, $sid])) web_out(['error' => 'TAKEN']);
        web_db()->prepare('UPDATE phone_discord_servers SET vanity = ? WHERE id = ?')->execute([$code, $sid]);
        web_out(['ok' => true, 'vanity' => $code]);
    }
    case 'DiscordExt_SetServerIcon': {
        $url = trim((string)($in['url'] ?? ''));
        if ($url !== '' && !web_media_url_ok($url)) web_out(['error' => 'BAD_URL']);
        web_db()->prepare('UPDATE phone_discord_servers SET icon_url = ? WHERE id = ?')->execute([$url !== '' ? $url : null, $sid]);
        web_out(['ok' => true]);
    }
    case 'DiscordExt_CreateInvite': {
        $uses = (int)($in['maxUses'] ?? -1); $mins = (int)($in['expireMinutes'] ?? -1);
        if (!in_array($uses, WEB_INVITE_USES, true) || !in_array($mins, WEB_INVITE_MINUTES, true)) web_out(false);
        $active = (int)(web_one('SELECT COUNT(*) AS c FROM phone_discord_invites WHERE server_id = ? AND (expires_at IS NULL OR expires_at > ?) AND (max_uses = 0 OR uses < max_uses)', [$sid, web_now()])['c'] ?? 0);
        if ($active >= WEB_INVITE_MAX_ACTIVE) web_out(['error' => 'LIMIT']);
        $code = strtoupper(bin2hex(random_bytes(4)));
        web_db()->prepare('INSERT INTO phone_discord_invites (server_id, code, max_uses, uses, expires_at, created_by, created_at) VALUES (?, ?, ?, 0, ?, ?, ?)')
            ->execute([$sid, $code, $uses, $mins > 0 ? web_now() + $mins * 60 : null, web_name($ident), web_now()]);
        web_out(['ok' => true, 'code' => $code]);
    }
    case 'DiscordExt_ListInvites': {
        $rows = web_q('SELECT id, code, max_uses, uses, expires_at, created_by FROM phone_discord_invites WHERE server_id = ? ORDER BY id DESC LIMIT 50', [$sid]);
        web_out([
            'main' => $server['invite_code'] ?? null,
            'invites' => array_map(fn($r) => ['id' => (int)$r['id'], 'code' => $r['code'], 'max_uses' => (int)$r['max_uses'], 'uses' => (int)$r['uses'],
                                              'expires_at' => $r['expires_at'] !== null ? (int)$r['expires_at'] : null, 'created_by' => $r['created_by']], $rows),
            'vanity' => $server['vanity'] ?? null, 'vanityEligible' => false,
            'maxUses' => WEB_INVITE_USES, 'expireMinutes' => WEB_INVITE_MINUTES, 'now' => web_now(),
        ]);
    }
    case 'DiscordExt_RevokeInvite': {
        $id = (int)($in['inviteId'] ?? 0);
        if (!web_one('SELECT id FROM phone_discord_invites WHERE id = ? AND server_id = ?', [$id, $sid])) web_out(false);
        web_db()->prepare('DELETE FROM phone_discord_invites WHERE id = ?')->execute([$id]);
        web_out(true);
    }
    }
    web_out(false);
}


function web_is_staff(string $ident, int $sid): bool {
    $server = web_server($sid);
    if (!$server) return false;
    return web_is_owner($ident, $server) || web_is_admin($ident, $sid);
}

function web_content_action(string $ep, string $ident, array $in): void {
    $sid = (int)($in['serverId'] ?? 0);
    // resolve the server from a message / channel / member / note id when the call does not send it
    if (!$sid && isset($in['channelId'])) { $r = web_one('SELECT server_id FROM phone_discord_channels WHERE id = ?', [(int)$in['channelId']]); $sid = (int)($r['server_id'] ?? 0); }
    if (!$sid && isset($in['channelId'])) { $sid = (int)(web_one('SELECT server_id FROM phone_discord_channels WHERE id = ?', [(int)$in['channelId']])['server_id'] ?? 0); }
    if (!$sid && isset($in['messageId'])) { $r = web_one('SELECT c.server_id FROM phone_discord_messages m JOIN phone_discord_channels c ON c.id = m.channel_id WHERE m.id = ?', [(int)$in['messageId']]); $sid = (int)($r['server_id'] ?? 0); }
    if (!$sid && isset($in['noteId'])) { $r = web_one('SELECT server_id FROM phone_discord_staff_notes WHERE id = ?', [(int)$in['noteId']]); $sid = (int)($r['server_id'] ?? 0); }
    if (!$sid && isset($in['templateId'])) { $r = web_one('SELECT server_id FROM phone_discord_channel_templates WHERE id = ?', [(int)$in['templateId']]); $sid = (int)($r['server_id'] ?? 0); }

    switch ($ep) {
    case 'DiscordExt_GetEditHistory': {
        $m = web_one('SELECT m.id, m.message, m.edited_at, c.server_id FROM phone_discord_messages m JOIN phone_discord_channels c ON c.id = m.channel_id WHERE m.id = ?', [(int)($in['messageId'] ?? 0)]);
        if (!$m || !web_member($ident, (int)$m['server_id'])) web_out(false);
        $versions = array_map(fn($e) => ['text' => $e['old_text'], 'at' => (int)$e['created_at']],
            web_q('SELECT old_text, created_at FROM phone_discord_message_edits WHERE message_id = ? ORDER BY id ASC LIMIT 20', [(int)$m['id']]));
        web_out(['current' => $m['message'], 'editedAt' => $m['edited_at'] !== null ? (int)$m['edited_at'] : null, 'versions' => $versions]);
    }
    case 'DiscordExt_GetStaffNotes': {
        if (!web_is_staff($ident, $sid)) web_out(false);
        $m = web_one('SELECT identifier FROM phone_discord_members WHERE id = ? AND server_id = ?', [(int)($in['memberId'] ?? 0), $sid]);
        if (!$m) web_out(false);
        web_out(array_map(fn($n) => ['id' => (int)$n['id'], 'author' => $n['author_name'], 'text' => $n['text'], 'createdAt' => (int)$n['created_at'], 'mine' => $n['author_identifier'] === $ident],
            web_q('SELECT id, author_identifier, author_name, text, created_at FROM phone_discord_staff_notes WHERE server_id = ? AND target_identifier = ? ORDER BY id DESC LIMIT 50', [$sid, $m['identifier']])));
    }
    case 'DiscordExt_AddStaffNote': {
        if (!web_is_staff($ident, $sid)) web_out(false);
        $m = web_one('SELECT identifier FROM phone_discord_members WHERE id = ? AND server_id = ?', [(int)($in['memberId'] ?? 0), $sid]);
        $text = web_clip(trim((string)($in['text'] ?? '')), 500);
        if (!$m || web_strlen($text) < 2) web_out(false);
        web_db()->prepare('INSERT INTO phone_discord_staff_notes (server_id, target_identifier, author_identifier, author_name, text, created_at) VALUES (?, ?, ?, ?, ?, ?)')
            ->execute([$sid, $m['identifier'], $ident, web_name($ident), $text, web_now()]);
        web_out(['ok' => true]);
    }
    case 'DiscordExt_DeleteStaffNote': {
        $n = web_one('SELECT id, server_id, author_identifier FROM phone_discord_staff_notes WHERE id = ?', [(int)($in['noteId'] ?? 0)]);
        if (!$n || !web_is_staff($ident, (int)$n['server_id'])) web_out(false);
        $server = web_server((int)$n['server_id']);
        if ($n['author_identifier'] !== $ident && !web_is_owner($ident, $server)) web_out(false);
        web_db()->prepare('DELETE FROM phone_discord_staff_notes WHERE id = ?')->execute([(int)$n['id']]);
        web_out(['ok' => true]);
    }
    case 'DiscordExt_GetChannelTemplates': {
        if (!web_is_staff($ident, $sid)) web_out(false);
        $out = [
            ['key' => 'briefing', 'label' => 'Briefing (read-only)', 'kind' => 'text', 'locked' => true, 'custom' => false],
            ['key' => 'event', 'label' => 'Event chat', 'kind' => 'text', 'locked' => false, 'custom' => false],
            ['key' => 'stage', 'label' => 'Stage event', 'kind' => 'stage', 'locked' => false, 'custom' => false],
        ];
        foreach (web_q('SELECT id, name, kind, is_locked FROM phone_discord_channel_templates WHERE server_id = ? ORDER BY id', [$sid]) as $t) {
            $out[] = ['key' => 'c' . $t['id'], 'label' => $t['name'] . ' (saved)', 'kind' => $t['kind'], 'locked' => web_bool($t['is_locked']), 'custom' => true, 'templateId' => (int)$t['id']];
        }
        web_out($out);
    }
    case 'DiscordExt_CreateChannelFromTemplate': {
        if (!web_is_staff($ident, $sid)) web_out(false);
        if (!web_can_create($ident)) web_out(['error' => 'NOT_CREATOR']);
        $key = (string)($in['key'] ?? '');
        $builtin = ['briefing' => ['briefing', 'Official briefings', 'text', 1], 'event' => ['event', 'Event chat', 'text', 0], 'stage' => ['stage', 'Event chat (text only)', 'stage', 0]];
        if (isset($builtin[$key])) { [$name, $topic, $kind, $locked] = $builtin[$key]; }
        elseif (preg_match('/^c(\d+)$/', $key, $m)) {
            $t = web_one('SELECT name, topic, kind, is_locked FROM phone_discord_channel_templates WHERE id = ? AND server_id = ?', [(int)$m[1], $sid]);
            if (!$t) web_out(['error' => 'BAD_TEMPLATE']);
            [$name, $topic, $kind, $locked] = [$t['name'], $t['topic'], $t['kind'], web_bool($t['is_locked']) ? 1 : 0];
        } else web_out(['error' => 'BAD_TEMPLATE']);
        $chName = strtolower(preg_replace('/\s+/', '-', trim(web_clip((string)($in['name'] ?? ''), 30)))) ?: $name;
        $count = (int)(web_one('SELECT COUNT(*) AS c FROM phone_discord_channels WHERE server_id = ?', [$sid])['c'] ?? 0);
        if ($count >= 50) web_out(['error' => 'LIMIT']);
        web_db()->prepare('INSERT INTO phone_discord_channels (server_id, name, position, created_at, is_locked, kind, topic) VALUES (?, ?, ?, ?, ?, ?, ?)')
            ->execute([$sid, $chName, $count, web_now(), (int)$locked, $kind, $topic]);
        web_out(['ok' => true, 'id' => (int)web_db()->lastInsertId(), 'name' => $chName]);
    }
    case 'DiscordExt_SaveChannelTemplate': {
        $ch = web_channel((int)($in['channelId'] ?? 0));
        if (!$ch || !web_is_staff($ident, (int)$ch['server_id'])) web_out(false);
        $n = (int)(web_one('SELECT COUNT(*) AS c FROM phone_discord_channel_templates WHERE server_id = ?', [(int)$ch['server_id']])['c'] ?? 0);
        if ($n >= 10) web_out(['error' => 'LIMIT']);
        web_db()->prepare('INSERT INTO phone_discord_channel_templates (server_id, name, topic, kind, is_locked, created_by, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)')
            ->execute([(int)$ch['server_id'], web_clip((string)$ch['name'], 40), $ch['topic'], $ch['kind'] ?? 'text', web_bool($ch['is_locked']) ? 1 : 0, $ident, web_now()]);
        web_out(['ok' => true, 'id' => (int)web_db()->lastInsertId()]);
    }
    case 'DiscordExt_DeleteChannelTemplate': {
        $t = web_one('SELECT id, server_id FROM phone_discord_channel_templates WHERE id = ?', [(int)($in['templateId'] ?? 0)]);
        if (!$t || !web_is_staff($ident, (int)$t['server_id'])) web_out(false);
        web_db()->prepare('DELETE FROM phone_discord_channel_templates WHERE id = ?')->execute([(int)$t['id']]);
        web_out(['ok' => true]);
    }
    case 'DiscordExt_GetHealth': {
        if (!web_is_staff($ident, $sid)) web_out(false);
        $now = web_now(); $since = $now - 7 * 86400;
        $channels = []; $total = 0;
        foreach (web_q('SELECT c.id, c.name, COUNT(m.id) AS cnt FROM phone_discord_channels c LEFT JOIN phone_discord_messages m ON m.channel_id = c.id AND m.created_at >= ? WHERE c.server_id = ? GROUP BY c.id, c.name ORDER BY cnt DESC, c.position ASC', [$since, $sid]) as $c) {
            $channels[] = ['id' => (int)$c['id'], 'name' => $c['name'], 'count' => (int)$c['cnt']]; $total += (int)$c['cnt'];
        }
        $hours = array_fill(0, 24, 0); $days = array_fill(0, 7, 0);
        foreach (web_q('SELECT m.created_at FROM phone_discord_messages m JOIN phone_discord_channels c ON c.id = m.channel_id WHERE c.server_id = ? AND m.created_at >= ? LIMIT 20000', [$sid, $since]) as $r) {
            $t = (int)$r['created_at'];
            $hours[(int)date('G', $t)]++;
            $idx = 7 - intdiv($now - $t, 86400);
            if ($idx >= 1 && $idx <= 7) $days[$idx - 1]++;
        }
        $members = (int)(web_one('SELECT COUNT(*) AS c FROM phone_discord_members WHERE server_id = ?', [$sid])['c'] ?? 0);
        $newMembers = (int)(web_one('SELECT COUNT(*) AS c FROM phone_discord_members WHERE server_id = ? AND joined_at >= ?', [$sid, $since])['c'] ?? 0);
        web_out(['channels' => $channels, 'hours' => $hours, 'days' => $days, 'totalMessages' => $total, 'totalMembers' => $members, 'newMembers' => $newMembers, 'windowDays' => 7]);
    }
    case 'DiscordExt_GetMutualFriends': {
        $other = web_one('SELECT identifier FROM phone_discord_profiles WHERE uid = ?', [(int)($in['uid'] ?? 0)]);
        if (!$other || $other['identifier'] === $ident) web_out(['count' => 0]);
        $friendsOf = function (string $id): array {
            $set = [];
            foreach (web_q("SELECT user_low, user_high FROM phone_discord_friends WHERE status = 'accepted' AND (user_low = ? OR user_high = ?)", [$id, $id]) as $f) {
                $set[$f['user_low'] === $id ? $f['user_high'] : $f['user_low']] = true;
            }
            return $set;
        };
        $mine = $friendsOf($ident); $theirs = $friendsOf($other['identifier']);
        web_out(['count' => count(array_intersect_key($mine, $theirs))]);
    }
    case 'DiscordExt_SetChannelOrder': {
        if (!web_is_staff($ident, $sid)) web_out(false);
        $current = web_q('SELECT id FROM phone_discord_channels WHERE server_id = ?', [$sid]);
        $known = array_map(fn($r) => (int)$r['id'], $current);
        $ids = array_map('intval', (array)($in['ids'] ?? []));
        if (count($ids) !== count($known) || array_diff($ids, $known) || count(array_unique($ids)) !== count($ids)) web_out(['error' => 'BAD_LIST']);
        foreach ($ids as $pos => $id) web_db()->prepare('UPDATE phone_discord_channels SET position = ? WHERE id = ?')->execute([$pos, $id]);
        web_out(['ok' => true]);
    }
    case 'DiscordExt_SetAvatarEffect': {
        $eff = (string)($in['effect'] ?? '');
        if (!in_array($eff, WEB_AVATAR_EFFECTS, true)) web_out(['error' => 'BAD_EFFECT']);
        web_db()->prepare('UPDATE phone_discord_profiles SET avatar_effect = ? WHERE identifier = ?')->execute([$eff !== 'none' ? $eff : null, $ident]);
        web_out(['ok' => true, 'effect' => $eff]);
    }
    case 'DiscordExt_SetBanner': {
        $url = trim((string)($in['url'] ?? ''));
        if ($url !== '' && !web_media_url_ok($url)) web_out(['error' => 'BAD_URL']);
        web_db()->prepare('UPDATE phone_discord_profiles SET banner_url = ? WHERE identifier = ?')->execute([$url !== '' ? $url : null, $ident]);
        web_out(['ok' => true, 'banner' => $url !== '' ? $url : null]);
    }
    case 'DiscordExt_SetAnnouncementChannel': {
        $ch = web_channel((int)($in['channelId'] ?? 0));
        if (!$ch || !web_is_staff($ident, (int)$ch['server_id'])) web_out(false);
        web_db()->prepare('UPDATE phone_discord_channels SET is_announcement = ? WHERE id = ?')->execute([($in['on'] ?? false) === true ? 1 : 0, (int)$ch['id']]);
        web_out(['ok' => true]);
    }
    case 'DiscordExt_GetAnnouncementChannels': {
        $out = [];
        foreach (web_q('SELECT c.id, c.name, s.id AS server_id, s.name AS server_name FROM phone_discord_channels c JOIN phone_discord_servers s ON s.id = c.server_id WHERE c.is_announcement = 1 AND s.is_public = 1 ORDER BY s.name, c.position') as $r) {
            $out[] = ['id' => (int)$r['id'], 'name' => $r['name'], 'serverId' => (int)$r['server_id'], 'serverName' => $r['server_name']];
        }
        web_out($out);
    }
    case 'DiscordExt_FollowChannel': {
        $target = web_channel((int)($in['targetChannelId'] ?? 0));
        $src = web_channel((int)($in['sourceChannelId'] ?? 0));
        if (!$target || !$src) web_out(false);
        if ((int)$src['server_id'] === (int)$target['server_id']) web_out(['error' => 'SAME_SERVER']);
        $annRow = web_one('SELECT is_announcement FROM phone_discord_channels WHERE id = ?', [(int)$src['id']]);
        if (!web_bool($annRow['is_announcement'] ?? 0)) web_out(['error' => 'NOT_ANNOUNCEMENT']);
        $srvSrc = web_server((int)$src['server_id']);
        if (!$srvSrc || !web_bool($srvSrc['is_public'])) web_out(['error' => 'NOT_PUBLIC']);
        if (!web_is_staff($ident, (int)$target['server_id'])) web_out(false);
        web_db()->prepare('DELETE FROM phone_discord_follows WHERE target_channel_id = ?')->execute([(int)$target['id']]);
        web_db()->prepare('INSERT INTO phone_discord_follows (source_channel_id, target_channel_id, created_by, created_at) VALUES (?, ?, ?, ?)')
            ->execute([(int)$src['id'], (int)$target['id'], $ident, web_now()]);
        web_out(['ok' => true]);
    }
    case 'DiscordExt_UnfollowChannel': {
        $target = web_channel((int)($in['targetChannelId'] ?? 0));
        if (!$target || !web_is_staff($ident, (int)$target['server_id'])) web_out(false);
        web_db()->prepare('DELETE FROM phone_discord_follows WHERE target_channel_id = ?')->execute([(int)$target['id']]);
        web_out(['ok' => true]);
    }
    case 'DiscordExt_GetFollows': {
        if (!web_is_staff($ident, $sid)) web_out(false);
        $out = [];
        foreach (web_q('SELECT f.target_channel_id, t.name AS target_name, sc.name AS source_name, s.name AS source_server FROM phone_discord_follows f JOIN phone_discord_channels t ON t.id = f.target_channel_id JOIN phone_discord_channels sc ON sc.id = f.source_channel_id JOIN phone_discord_servers s ON s.id = sc.server_id WHERE t.server_id = ?', [$sid]) as $r) {
            $out[] = ['targetChannelId' => (int)$r['target_channel_id'], 'targetName' => $r['target_name'], 'sourceName' => $r['source_name'], 'sourceServer' => $r['source_server']];
        }
        web_out($out);
    }
    }
    web_out(false);
}


function web_emoji_slots(int $sid): int {
    $n = (int)(web_one('SELECT COUNT(*) AS c FROM phone_discord_boosts WHERE server_id = ? AND expires_at > ?', [$sid, web_now()])['c'] ?? 0);
    foreach (WEB_BOOST_LEVELS as $lvl) if ($n >= $lvl['boosts']) return $lvl['slots'];
    return WEB_EMOJI_BASE_SLOTS;
}
function web_emoji_images(int $sid): array {
    return array_map(fn($e) => ['name' => $e['name'], 'url' => $e['url']],
        web_q('SELECT name, url FROM phone_discord_custom_emoji WHERE server_id = ? ORDER BY id', [$sid]));
}

function web_folders_state(string $ident): array {
    $folders = []; $byId = [];
    foreach (web_q('SELECT id, name, color FROM phone_discord_folders WHERE identifier = ? ORDER BY id', [$ident]) as $f) {
        $f['id'] = (int)$f['id']; $f['servers'] = []; $folders[] = $f; $byId[$f['id']] = count($folders) - 1;
    }
    foreach (web_q('SELECT server_id, folder_id FROM phone_discord_folder_items WHERE identifier = ?', [$ident]) as $it) {
        $k = $byId[(int)$it['folder_id']] ?? null;
        if ($k !== null) $folders[$k]['servers'][] = (int)$it['server_id'];
    }
    return $folders;
}

function web_gallery_action(string $ep, string $ident, array $in): void {
    if ($ep === 'DiscordExt_GetGalleryImages') {
        $urls = [];
        foreach (web_q('SELECT image_url FROM phone_gallery WHERE identifier = ? ORDER BY id DESC LIMIT 40', [$ident]) as $r) {
            if (web_media_url_ok((string)$r['image_url'])) $urls[] = $r['image_url'];
        }
        web_out($urls);
    }
    web_out(false);
}

function web_folder_action(string $ep, string $ident, array $in): void {
    switch ($ep) {
    case 'DiscordExt_GetFolders':
        web_out(web_folders_state($ident));
    case 'DiscordExt_CreateFolder': {
        $name = web_clip(trim((string)($in['name'] ?? 'Folder')), 24);
        $color = (string)($in['color'] ?? '#5865F2');
        if ($name === '' || !preg_match('/^#[0-9a-fA-F]{6}$/', $color)) web_out(false);
        if ((int)(web_one('SELECT COUNT(*) AS c FROM phone_discord_folders WHERE identifier = ?', [$ident])['c'] ?? 0) >= 20) web_out(false);
        web_db()->prepare('INSERT INTO phone_discord_folders (identifier, name, color) VALUES (?, ?, ?)')->execute([$ident, $name, $color]);
        web_out(web_folders_state($ident));
    }
    case 'DiscordExt_EditFolder': {
        $f = web_one('SELECT id FROM phone_discord_folders WHERE id = ? AND identifier = ?', [(int)($in['folderId'] ?? 0), $ident]);
        if (!$f) web_out(false);
        $name = web_clip(trim((string)($in['name'] ?? '')), 24);
        $color = (string)($in['color'] ?? '');
        if ($name === '' || !preg_match('/^#[0-9a-fA-F]{6}$/', $color)) web_out(false);
        web_db()->prepare('UPDATE phone_discord_folders SET name = ?, color = ? WHERE id = ?')->execute([$name, $color, (int)$f['id']]);
        web_out(web_folders_state($ident));
    }
    case 'DiscordExt_DeleteFolder': {
        $f = web_one('SELECT id FROM phone_discord_folders WHERE id = ? AND identifier = ?', [(int)($in['folderId'] ?? 0), $ident]);
        if (!$f) web_out(false);
        web_db()->prepare('DELETE FROM phone_discord_folder_items WHERE folder_id = ?')->execute([(int)$f['id']]);
        web_db()->prepare('DELETE FROM phone_discord_folders WHERE id = ?')->execute([(int)$f['id']]);
        web_out(web_folders_state($ident));
    }
    case 'DiscordExt_MoveToFolder': {
        $sid = (int)($in['serverId'] ?? 0);
        if (!$sid || !web_member($ident, $sid)) web_out(false);
        $fid = (int)($in['folderId'] ?? 0);
        if ($fid === 0) {
            web_db()->prepare('DELETE FROM phone_discord_folder_items WHERE identifier = ? AND server_id = ?')->execute([$ident, $sid]);
        } else {
            if (!web_one('SELECT id FROM phone_discord_folders WHERE id = ? AND identifier = ?', [$fid, $ident])) web_out(false);
            web_db()->prepare('DELETE FROM phone_discord_folder_items WHERE identifier = ? AND server_id = ?')->execute([$ident, $sid]);
            web_db()->prepare('INSERT INTO phone_discord_folder_items (identifier, server_id, folder_id) VALUES (?, ?, ?)')->execute([$ident, $sid, $fid]);
        }
        web_out(web_folders_state($ident));
    }
    }
    web_out(false);
}

/** owner / managers add or remove image emoji; slots come from boosts, same as the game */
function web_image_emoji_action(string $ep, string $ident, array $in): void {
    $sid = (int)($in['serverId'] ?? 0);
    $server = $sid ? web_server($sid) : null;
    if (!$server || !(web_is_owner($ident, $server) || web_is_admin($ident, $sid))) web_out(false);
    if ($ep === 'DiscordExt_RemoveImageEmoji') {
        web_db()->prepare('DELETE FROM phone_discord_custom_emoji WHERE server_id = ? AND name = ?')->execute([$sid, (string)($in['name'] ?? '')]);
        web_out(true);
    }
    $name = strtolower(trim((string)($in['name'] ?? '')));
    $url = trim((string)($in['url'] ?? ''));
    if (!preg_match('/^[a-z0-9_]{2,12}$/', $name)) web_out(['error' => 'BAD_NAME']);
    if (!web_media_url_ok($url)) web_out(['error' => 'BAD_URL']);
    $used = (int)(web_one('SELECT COUNT(*) AS c FROM phone_discord_custom_emoji WHERE server_id = ?', [$sid])['c'] ?? 0)
          + (int)(web_one('SELECT COUNT(*) AS c FROM phone_discord_emojis WHERE server_id = ?', [$sid])['c'] ?? 0);
    if ($used >= web_emoji_slots($sid)) web_out(['error' => 'NO_SLOTS']);
    if (web_one('SELECT id FROM phone_discord_custom_emoji WHERE server_id = ? AND name = ?', [$sid, $name])) web_out(['error' => 'TAKEN']);
    web_db()->prepare('INSERT INTO phone_discord_custom_emoji (server_id, name, url, created_by, created_at) VALUES (?, ?, ?, ?, ?)')
        ->execute([$sid, $name, $url, $ident, web_now()]);
    web_out(['ok' => true]);
}


/** per-channel permissions: the owner and admins edit them (the game also lets manage_roles holders) */
function web_channel_perm_action(string $ep, string $ident, array $in): void {
    $sid = (int)($in['serverId'] ?? 0);
    $server = $sid ? web_server($sid) : null;
    if (!$server || !(web_is_owner($ident, $server) || web_is_admin($ident, $sid))) web_out(false);
    $ch = web_channel((int)($in['channelId'] ?? 0));
    if (!$ch || (int)$ch['server_id'] !== $sid) web_out(false);

    if ($ep === 'DiscordExt_GetChannelPerms') {
        $roles = [];
        foreach (web_q('SELECT id, name, color, position, is_default FROM phone_discord_roles WHERE server_id = ? ORDER BY is_default DESC, position DESC, id ASC', [$sid]) as $r) {
            $roles[] = ['id' => (int)$r['id'], 'name' => $r['name'], 'color' => $r['color'], 'isDefault' => web_bool($r['is_default']), 'position' => (int)$r['position']];
        }
        $overrides = (object)[];
        foreach (web_q('SELECT role_id, allow, deny FROM phone_discord_channel_perms WHERE channel_id = ?', [(int)$ch['id']]) as $o) {
            $overrides->{(string)$o['role_id']} = ['allow' => array_values(array_intersect(WEB_CHANNEL_PERM_KEYS, (array)json_decode((string)$o['allow'], true))),
                                                   'deny' => array_values(array_intersect(WEB_CHANNEL_PERM_KEYS, (array)json_decode((string)$o['deny'], true)))];
        }
        web_out(['channel' => ['id' => (int)$ch['id'], 'name' => $ch['name'], 'kind' => $ch['kind'] ?? 'text'], 'roles' => $roles, 'overrides' => $overrides,
                 'permList' => array_map(fn($k) => ['key' => $k, 'label' => ucfirst(str_replace('_', ' ', $k))], WEB_CHANNEL_PERM_KEYS)]);
    }
    if ($ep === 'DiscordExt_SetChannelPerm') {
        $roleId = (int)($in['roleId'] ?? 0);
        if (!web_one('SELECT id FROM phone_discord_roles WHERE id = ? AND server_id = ?', [$roleId, $sid])) web_out(false);
        $deny = array_values(array_unique(array_filter((array)($in['deny'] ?? []), fn($k) => in_array($k, WEB_CHANNEL_PERM_KEYS, true))));
        $allow = array_values(array_unique(array_filter((array)($in['allow'] ?? []), fn($k) => in_array($k, WEB_CHANNEL_PERM_KEYS, true) && !in_array($k, $deny, true))));
        if (!$allow && !$deny) {
            web_db()->prepare('DELETE FROM phone_discord_channel_perms WHERE channel_id = ? AND role_id = ?')->execute([(int)$ch['id'], $roleId]);
        } else {
            web_db()->prepare('DELETE FROM phone_discord_channel_perms WHERE channel_id = ? AND role_id = ?')->execute([(int)$ch['id'], $roleId]);
            web_db()->prepare('INSERT INTO phone_discord_channel_perms (channel_id, role_id, allow, deny) VALUES (?, ?, ?, ?)')
                ->execute([(int)$ch['id'], $roleId, json_encode($allow), json_encode($deny)]);
        }
        web_out(true);
    }
    // SetChannelPrivate: @everyone cannot view; the chosen roles can
    $everyone = web_one('SELECT id FROM phone_discord_roles WHERE server_id = ? AND is_default = 1 ORDER BY id LIMIT 1', [$sid]);
    if (!$everyone) web_out(false);
    $ev = web_one('SELECT allow, deny FROM phone_discord_channel_perms WHERE channel_id = ? AND role_id = ?', [(int)$ch['id'], (int)$everyone['id']]);
    $evAllow = $ev ? array_values(array_filter((array)json_decode((string)$ev['allow'], true), fn($k) => $k !== 'view')) : [];
    $evDeny = $ev ? array_values(array_filter((array)json_decode((string)$ev['deny'], true), fn($k) => $k !== 'view')) : [];
    if (($in['on'] ?? false) === true) $evDeny[] = 'view';
    web_db()->prepare('DELETE FROM phone_discord_channel_perms WHERE channel_id = ? AND role_id = ?')->execute([(int)$ch['id'], (int)$everyone['id']]);
    if ($evAllow || $evDeny) web_db()->prepare('INSERT INTO phone_discord_channel_perms (channel_id, role_id, allow, deny) VALUES (?, ?, ?, ?)')
        ->execute([(int)$ch['id'], (int)$everyone['id'], json_encode($evAllow), json_encode($evDeny)]);
    if (($in['on'] ?? false) === true && is_array($in['roleIds'] ?? null)) {
        foreach ($in['roleIds'] as $rid) {
            $rid = (int)$rid;
            if ($rid === (int)$everyone['id'] || !web_one('SELECT id FROM phone_discord_roles WHERE id = ? AND server_id = ?', [$rid, $sid])) continue;
            $row = web_one('SELECT allow, deny FROM phone_discord_channel_perms WHERE channel_id = ? AND role_id = ?', [(int)$ch['id'], $rid]);
            $al = $row ? array_values(array_unique(array_merge((array)json_decode((string)$row['allow'], true), ['view']))) : ['view'];
            $dn = $row ? array_values(array_filter((array)json_decode((string)$row['deny'], true), fn($k) => $k !== 'view')) : [];
            web_db()->prepare('DELETE FROM phone_discord_channel_perms WHERE channel_id = ? AND role_id = ?')->execute([(int)$ch['id'], $rid]);
            web_db()->prepare('INSERT INTO phone_discord_channel_perms (channel_id, role_id, allow, deny) VALUES (?, ?, ?, ?)')->execute([(int)$ch['id'], $rid, json_encode($al), json_encode($dn)]);
        }
    }
    web_out(['ok' => true]);
}



function web_setting_action(string $ep, string $ident, array $in): void {
    $sid = (int)($in['serverId'] ?? 0);
    $server = $sid ? web_server($sid) : null;
    if ($ep === 'DiscordExt_AcceptRules') {
        if (!$server || !web_member($ident, $sid)) web_out(false);
        web_db()->prepare('DELETE FROM phone_discord_rules_accept WHERE server_id = ? AND identifier = ?')->execute([$sid, $ident]);
        web_db()->prepare('INSERT INTO phone_discord_rules_accept (server_id, identifier, accepted_at) VALUES (?, ?, ?)')->execute([$sid, $ident, web_now()]);
        web_out(['ok' => true]);
    }
    if (!$server) web_out(false);
    $owner = web_is_owner($ident, $server);
    if (!$owner && !web_is_admin($ident, $sid)) web_out(false);

    switch ($ep) {
    case 'DiscordExt_SetRoleIcon': {
        $roleId = (int)($in['roleId'] ?? 0);
        if (!web_one('SELECT id FROM phone_discord_roles WHERE id = ? AND server_id = ?', [$roleId, $sid])) web_out(false);
        $icon = trim((string)($in['icon'] ?? ''));
        if ($icon !== '' && (strlen($icon) > 16 || preg_match('/[A-Za-z0-9\s]/', $icon))) web_out(['error' => 'BAD_ICON']);
        web_db()->prepare('UPDATE phone_discord_roles SET icon = ? WHERE id = ?')->execute([$icon !== '' ? $icon : null, $roleId]);
        web_out(['ok' => true]);
    }
    case 'DiscordExt_SetServerTags': {
        if (!$owner && !web_is_admin($ident, $sid)) web_out(false);
        $out = []; $seen = [];
        foreach (explode(',', strtolower((string)($in['tags'] ?? ''))) as $w) {
            $t = trim($w);
            if ($t === '') continue;
            if (!in_array($t, WEB_SITE_TAGS, true)) web_out(['error' => 'BAD_TAG']);
            if (!isset($seen[$t])) { $seen[$t] = true; $out[] = $t; }
        }
        if (count($out) > 4) web_out(['error' => 'TOO_MANY']);
        $tags = implode(',', $out);
        web_db()->prepare('UPDATE phone_discord_servers SET tags = ? WHERE id = ?')->execute([$tags !== '' ? $tags : null, $sid]);
        web_out(['ok' => true, 'tags' => $tags !== '' ? $tags : null]);
    }
    case 'DiscordExt_SetDiscoverCategory': {
        $cat = (string)($in['category'] ?? '');
        if (!in_array($cat, WEB_DISCOVER_CATS, true)) web_out(['error' => 'BAD_CATEGORY']);
        if (!$owner && !web_is_admin($ident, $sid)) web_out(false);
        web_db()->prepare('UPDATE phone_discord_servers SET category = ?, is_public = ? WHERE id = ?')->execute([$cat, ($in['isPublic'] ?? false) === true ? 1 : 0, $sid]);
        web_out(['ok' => true]);
    }
    case 'DiscordExt_AddAutoModWord':
    case 'DiscordExt_RemoveAutoModWord': {
        $word = strtolower(trim(web_clip((string)($in['word'] ?? ''), 40)));
        if ($word === '') web_out(false);
        if ($ep === 'DiscordExt_RemoveAutoModWord') {
            web_db()->prepare('DELETE FROM phone_discord_automod WHERE server_id = ? AND word = ?')->execute([$sid, $word]);
            web_out(['ok' => true]);
        }
        if ((int)(web_one('SELECT COUNT(*) AS c FROM phone_discord_automod WHERE server_id = ?', [$sid])['c'] ?? 0) >= 40) web_out(['error' => 'LIMIT']);
        if (web_one('SELECT id FROM phone_discord_automod WHERE server_id = ? AND word = ?', [$sid, $word])) web_out(['error' => 'TAKEN']);
        web_db()->prepare('INSERT INTO phone_discord_automod (server_id, word) VALUES (?, ?)')->execute([$sid, $word]);
        web_out(['ok' => true]);
    }
    case 'DiscordExt_AddEmoji':
    case 'DiscordExt_RemoveEmoji': {
        $emoji = trim((string)($in['emoji'] ?? ''));
        if ($ep === 'DiscordExt_RemoveEmoji') {
            web_db()->prepare('DELETE FROM phone_discord_emojis WHERE server_id = ? AND emoji = ?')->execute([$sid, $emoji]);
            web_out(['ok' => true]);
        }
        if ($emoji === '' || strlen($emoji) > 32 || preg_match('/[A-Za-z\s]/', $emoji)) web_out(['error' => 'BAD_EMOJI']);
        $used = (int)(web_one('SELECT COUNT(*) AS c FROM phone_discord_emojis WHERE server_id = ?', [$sid])['c'] ?? 0)
              + (int)(web_one('SELECT COUNT(*) AS c FROM phone_discord_custom_emoji WHERE server_id = ?', [$sid])['c'] ?? 0);
        if ($used >= web_emoji_slots($sid)) web_out(['error' => 'NO_SLOTS']);
        if (web_one('SELECT id FROM phone_discord_emojis WHERE server_id = ? AND emoji = ?', [$sid, $emoji])) web_out(['error' => 'TAKEN']);
        web_db()->prepare('INSERT INTO phone_discord_emojis (server_id, emoji) VALUES (?, ?)')->execute([$sid, $emoji]);
        web_out(['ok' => true]);
    }
    case 'DiscordExt_CreateStageChannel': {
        if (!web_can_create($ident)) web_out(['error' => 'NOT_CREATOR']);
        $name = strtolower(preg_replace('/\s+/', '-', trim(web_clip((string)($in['channelName'] ?? ''), 30))));
        if ($name === '') web_out(false);
        $count = (int)(web_one('SELECT COUNT(*) AS c FROM phone_discord_channels WHERE server_id = ?', [$sid])['c'] ?? 0);
        if ($count >= 50) web_out(['error' => 'LIMIT']);
        web_db()->prepare("INSERT INTO phone_discord_channels (server_id, name, position, created_at, kind) VALUES (?, ?, ?, ?, 'stage')")->execute([$sid, $name, $count, web_now()]);
        web_out(['ok' => true, 'id' => (int)web_db()->lastInsertId(), 'name' => $name]);
    }
    }
    web_out(false);
}


/** owner or admin of this server (the website's report queue is per server) */
function web_is_staff_of(string $ident, int $sid): bool {
    $server = web_server($sid);
    return $server !== null && (web_is_owner($ident, $server) || web_is_admin($ident, $sid));
}


/** the same switch and creators list the game uses (phone_discord_settings / phone_discord_creators) */
function web_can_create(string $ident): bool {
    $row = web_one("SELECT v FROM phone_discord_settings WHERE k = 'creation_restricted'", []);
    $restricted = $row ? ($row['v'] === '1') : false;
    if (!$restricted) return true;
    return (bool)web_one('SELECT identifier FROM phone_discord_creators WHERE identifier = ?', [$ident]);
}


/** Pause Invites (Security Actions): true while the server pauses invites and this person is not inside yet */
function web_invites_paused(int $sid, string $ident): bool {
    $r = web_one('SELECT invites_paused_until AS u FROM phone_discord_servers WHERE id = ?', [$sid]);
    $u = (int)($r['u'] ?? 0);
    return $u > web_now() && !web_member($ident, $sid);
}


/** Privacy Settings: can this person open a message request to $other? Needs one shared server where $other still allows DMs */
function web_dms_open_to(string $ident, string $other): bool {
    $rows = web_q('SELECT COALESCE(p.allow_dms, 1) AS allow_dms FROM phone_discord_members m1 JOIN phone_discord_members m2 ON m1.server_id = m2.server_id LEFT JOIN phone_discord_dm_privacy p ON p.server_id = m1.server_id AND p.identifier = ? WHERE m1.identifier = ? AND m2.identifier = ?', [$other, $ident, $other]);
    if (!$rows) return true;
    foreach ($rows as $r) if ((int)$r['allow_dms'] !== 0) return true;
    return false;
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
/** a DM is talkable when you are friends, or when its message request was accepted */
function web_dm_talkable(array $dm, string $ident): bool {
    $other = $dm['other'];
    if (web_is_blocked_either($ident, $other)) return false;
    if (web_can_talk($ident, $other)) return true;
    return ($dm['request_state'] ?? null) === 'accepted';
}
function web_shares_server(string $a, string $b): bool {
    return (bool)web_one('SELECT 1 AS x FROM phone_discord_members m1 JOIN phone_discord_members m2 ON m1.server_id = m2.server_id WHERE m1.identifier = ? AND m2.identifier = ? LIMIT 1', [$a, $b]);
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
    $gameOn = web_online($idents);
    $siteOn = web_site_online($idents);
    foreach ($idents as $id) {
        $p = $profiles[$id] ?? null;
        $status = ($p['status'] ?? 'online');
        [$isOn, $platform, $activity] = web_presence($id, $status, $gameOn, $siteOn);
        $out[$id] = [
            'uid' => $p ? (int)$p['uid'] : null, 'name' => $names[$id] ?? 'Player', 'discriminator' => $p['discriminator'] ?? '0000',
            'avatar' => $p['avatar_url'] ?? null, 'status' => $isOn ? $status : 'offline',
            'customStatus' => $isOn ? (($p['custom_status'] ?? '') ?: null) : null, 'activity' => $activity, 'platform' => $platform,
        ];
    }
    return $out;
}
