-- Narges Discord site: tables the WEBSITE creates itself (safe to run more than once).
-- The game's own tables (login_users, users, phone_discord_*) must already exist:
--   * login_users, users  -> created by the game (do not change them)
--   * phone_discord_*     -> created by Unique_Phone/sql/discord.sql, discord_v7, v8, v11, v12, v13
CREATE TABLE IF NOT EXISTS dsite_rate (
  k VARCHAR(190) NOT NULL PRIMARY KEY,
  cnt INT NOT NULL,
  ws INT NOT NULL
) DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS dsite_presence (
  identifier VARCHAR(60) NOT NULL PRIMARY KEY,
  last_seen INT NOT NULL
) DEFAULT CHARSET=utf8mb4;
