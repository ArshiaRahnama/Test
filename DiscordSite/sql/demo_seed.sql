-- DEMO DATA for testing only (fake players). Do not import this into the real game database.
-- Logins: arshia / pw-arshia (owner), sam / pw-sam (member), eve / pw-eve (not in the server)
INSERT INTO login_users (username, password, password_salt, license, device_license, security_hold) VALUES
 ('arshia', SHA2(CONCAT('pw-arshia','salt-a'),256), 'salt-a', 'lic:a', 'lic:a', 0),
 ('sam',    SHA2(CONCAT('pw-sam','salt-b'),256),    'salt-b', 'lic:b', 'lic:b', 0),
 ('eve',    SHA2(CONCAT('pw-eve','salt-c'),256),    'salt-c', 'lic:c', 'lic:c', 0);
INSERT INTO users (identifier, license, firstname, lastname, last_seen) VALUES
 ('steam:a','lic:a','Arshia','Mtz',NULL), ('steam:b','lic:b','Sam','Carter',NULL), ('steam:c','lic:c','Eve','Stranger',NULL);
INSERT INTO phone_discord_accounts (identifier, mailbox, verified_at, logged_in, created_at) VALUES
 ('steam:a','arshia',0,1,0), ('steam:b','sam',0,1,0), ('steam:c','eve',0,0,0);
INSERT INTO phone_discord_profiles (identifier, discriminator, created_at, updated_at) VALUES
 ('steam:a','1049',0,0), ('steam:b','1049',0,0), ('steam:c','1049',0,0);
INSERT INTO phone_discord_servers (id,name,icon_text,icon_color,invite_code,owner_identifier,is_public,is_verified,category,description,created_at) VALUES
 (1,'Narges RolePlay','NR','#5865F2','KX93PQ','steam:a',1,1,'roleplay','The home of the community.',0),
 (2,'Private Club','PC','#ED4245','ZZ1QWE','steam:b',0,0,'community','Friends only.',0);
INSERT INTO phone_discord_members (server_id,identifier,nickname,joined_at,is_admin) VALUES
 (1,'steam:a','Arshia Mtz',0,1), (1,'steam:b','Sam Carter',0,0), (2,'steam:b','Sam Carter',0,1);
INSERT INTO phone_discord_channels (id,server_id,name,position,is_locked,kind,topic,created_at) VALUES
 (10,1,'announcements',0,1,'text','Official news',0), (11,1,'general',1,0,'text','Chat about anything',0),
 (12,1,'mayor-stage',2,0,'stage',NULL,0), (20,2,'lounge',0,0,'text',NULL,0);
INSERT INTO phone_discord_roles (id,server_id,name,position,perms,is_default) VALUES
 (100,1,'@everyone',0,'{"view":true,"send":true,"react":true}',1), (101,2,'@everyone',0,'{"view":true,"send":true,"react":true}',1);
INSERT INTO phone_discord_messages (id,channel_id,identifier,author_name,message,created_at) VALUES
 (1,11,'steam:b','Sam Carter','Morning! Patrol at 9.',1000),
 (2,11,'steam:a','Arshia Mtz','On my way **now**',1010),
 (3,10,'steam:a','Arshia Mtz','Server maintenance tonight',1020);
INSERT INTO phone_discord_reactions (message_id,identifier,emoji,created_at) VALUES (1,'steam:a','👍',1);
INSERT INTO phone_discord_friends (user_low,user_high,requester,status,created_at) VALUES ('steam:a','steam:b','steam:b','accepted',0);
INSERT INTO phone_discord_dms (id,user_low,user_high,created_at,last_at) VALUES (5,'steam:a','steam:b',0,2000);
INSERT INTO phone_discord_dm_messages (dm_id,identifier,author_name,message,created_at) VALUES (5,'steam:b','Sam Carter','see you at the station',2000);
