-- UNIQUE_AC Central Hub — SQLite schema
-- Run once: sqlite3 hub.db < schema.sql

CREATE TABLE IF NOT EXISTS license_keys (
    key_value    TEXT PRIMARY KEY,
    owner_name   TEXT NOT NULL,
    note         TEXT DEFAULT '',
    max_servers  INTEGER NOT NULL DEFAULT 1,
    expires_at   INTEGER,              -- unix timestamp, NULL = never expires
    active       INTEGER NOT NULL DEFAULT 1,
    created_at   INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS servers (
    id                 INTEGER PRIMARY KEY AUTOINCREMENT,
    license_key        TEXT NOT NULL,
    server_name        TEXT NOT NULL DEFAULT 'Unnamed Server',
    version            TEXT DEFAULT '',
    player_count       INTEGER DEFAULT 0,
    max_players        INTEGER DEFAULT 0,
    quarantine_count   INTEGER DEFAULT 0,
    appeal_count       INTEGER DEFAULT 0,
    ban_count_total    INTEGER DEFAULT 0,
    avg_frame_drift_ms INTEGER DEFAULT 0,
    uptime_seconds     INTEGER DEFAULT 0,
    resource_count     INTEGER DEFAULT 0,
    last_heartbeat_at  INTEGER DEFAULT 0,
    last_status        TEXT NOT NULL DEFAULT 'online',
    created_at         INTEGER NOT NULL,
    UNIQUE(license_key, server_name)
);

CREATE TABLE IF NOT EXISTS urgent_events (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    license_key  TEXT NOT NULL,
    server_name  TEXT NOT NULL DEFAULT 'Unnamed Server',
    kind         TEXT NOT NULL,        -- e.g. 'quarantine', 'offline_recovered'
    message      TEXT NOT NULL,
    created_at   INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS rate_limits (
    bucket_key   TEXT PRIMARY KEY,
    window_start INTEGER NOT NULL,
    request_count INTEGER NOT NULL DEFAULT 0
);

-- Cross-Server Threat Intel: opt-in. A ban on one server (under the same license
-- family) gets shared here so other servers using the same key can flag the same
-- person early. Deliberately scoped to servers sharing ONE license — this is not a
-- public cross-operator ban database.
CREATE TABLE IF NOT EXISTS shared_bans (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    license_key  TEXT NOT NULL,
    identifier   TEXT NOT NULL,
    reason       TEXT NOT NULL DEFAULT '',
    source_server TEXT NOT NULL DEFAULT '',
    created_at   INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_shared_bans_license ON shared_bans(license_key, identifier);

-- Exploit Heatmap: detection coordinates (no player identity) reported by servers,
-- aggregated to spot map exploit hotspots shared across servers.
CREATE TABLE IF NOT EXISTS heatmap_points (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    license_key  TEXT NOT NULL,
    reason       TEXT NOT NULL DEFAULT '',
    x            REAL NOT NULL,
    y            REAL NOT NULL,
    created_at   INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS idx_heatmap_created ON heatmap_points(created_at);

CREATE INDEX IF NOT EXISTS idx_servers_license ON servers(license_key);
CREATE INDEX IF NOT EXISTS idx_urgent_created ON urgent_events(created_at);
