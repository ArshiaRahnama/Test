-- ONLY for an empty test database. Do NOT run this on the real game database:
-- the game already has these tables with more columns.
CREATE TABLE IF NOT EXISTS login_users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(64) NOT NULL UNIQUE,
  password VARCHAR(64) NOT NULL,
  password_salt VARCHAR(64) NOT NULL DEFAULT '',
  phone VARCHAR(20) NULL,
  license VARCHAR(80) NULL,
  device_license VARCHAR(80) NULL,
  security_hold TINYINT NOT NULL DEFAULT 0
) DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS users (
  identifier VARCHAR(60) NOT NULL PRIMARY KEY,
  license VARCHAR(80) NULL,
  firstname VARCHAR(50) NULL,
  lastname VARCHAR(50) NULL,
  last_seen DATETIME NULL
) DEFAULT CHARSET=utf8mb4;
