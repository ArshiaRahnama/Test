# Unique Discord — standalone website

A separate website (not part of the game's website) that shows the **same Discord app** as the in-game phone,
on any browser and phone. Players log in with the username/phone and password they use in the game and see their
own servers, channels, messages, friends and direct messages. Messages sent here show up in the game and the other way round,
because both read and write the same `phone_discord_*` tables.

## Requirements
- PHP 8.1+ with `pdo_mysql` (`pdo_sqlite` only for local tests). `mbstring` is optional.
- The game database (the one with `login_users`, `users` and the `phone_discord_*` tables).
- HTTPS in production (login cookies are `Secure` when the site is served over HTTPS).

## Install
1. Copy this folder to the web root of a site/subdomain (e.g. `discord.yourserver.com`).
2. Edit `config.php`:
   - `mysql.db`, `mysql.user`, `mysql.pass` — the game database.
   - `site_name` — the name shown on the login page and the tab.
3. Make sure the game database has the Discord tables: run the SQL files of the phone in order:
   `discord.sql`, `discord_v7.sql`, `discord_v8.sql`, `discord_v11.sql`, `discord_v12.sql`, `discord_v13.sql`.
4. Open the site, log in with a character that already has a Discord account on the in-game phone
   (the phone account must be logged in once in the game; the website shows a message otherwise).

`dsite_rate` (login rate limit) is created by the site automatically. The site does not create any game tables.

## Connecting to your server database
1. Open `config.php` and set the game database under `mysql`: `host`, `port`, `db`, `user`, `pass`.
   You can also set them with environment variables (`DSITE_DB_HOST`, `DSITE_DB_NAME`, `DSITE_DB_USER`, `DSITE_DB_PASS`).
2. Check the connection from the server:  `php tools/check_db.php`
   It shows the connection result, lists missing tables and counts login accounts.
3. If the website runs on another machine, MySQL must accept connections from it (bind address and the user's host).
   Use a dedicated MySQL user with rights only on the game database.

## Database files (the sql/ folder)
- `site_schema.sql` — the two tables the website creates itself (`dsite_rate`, `dsite_presence`). **Safe for your real database.**
- `test_database_dump.sql` — a complete test database (game-like tables + the phone tables + fake demo players). **Use only on an empty test database, never on the real game database.** Import with:
      mysql -u root -p essentialmode_test < sql/test_database_dump.sql
- `demo_seed.sql` and `game_tables_minimal.sql` — the parts used to build that test database.

The phone tables come from the game's own files (`Unique_Phone/sql/*.sql`). The test dump was checked on MariaDB 10.11 with the website smoke test (login, servers, members, messages, send, live messages, Discover, leaderboard, presence).

## Setting or resetting a password from the server
    php tools/set_password.php <username or phone> <new password>
The new password (10+ characters) works in the game and on the website. Needs the password_salt column (the tool tells you if it is missing).

## Creating a website login
There is no default account. Create one for an existing character, once, from the command line:

    php tools/create_login.php <username> <password> <character identifier>

The password must be at least 10 characters. The login then works on this website and in the game.

## Files
- `index.php` — the app shell (needs login).
- `login.php`, `logout.php` — login with game credentials, rate-limited (5 failures / 15 min).
- `api.php` — the data API the app calls. Every request checks the login again and the CSRF token.
- `lib.php` — database, session, login helpers. `config.php` — settings.
- `app/` — the phone's Discord UI (the same files the game uses), plus `web-shim.js` (routes the UI to `api.php`)
  and `web.css` (full-screen layout, phone drawer).

## What works on the website (45 of the 105 endpoints the in-game app uses)
- Chat: servers you are in, channels (locked, stage and view permissions respected), last 200 messages, **live updates**
  (new messages arrive about every 2.5 s), send, reply, edit and delete your own messages, pin/unpin (owner/admin), pinned list, search.
- Reactions (any real emoji), member list with online state, profile + status/custom status/bio, member meta (level, founder),
  leaderboard, server card, nickname per server, unread "seen" tracking.
- Join a public server, join with an invite code / discord.gg link / vanity name, leave a server (not your own).
- Discover: search and categories.
- Friends: send by `name #1234` or uid, accept, decline, remove, block, unblock.
- Direct messages: open, history, send, edit and delete your own, unread.
- Sending is checked the same way the game checks it: membership, timeout, locked and stage channels,
  @everyone send permission, auto-mod words, message length (1000), a short cooldown per session.

## Added on the website in this update
- Moderation (owner and admins only, stricter than in the game): kick, promote / demote admins (owner only), timeout, warn, clear warnings, member moderation info.
- Channels: create (up to 50), rename and set topic, bulk delete (up to 50 messages), star a message.
- Roles (owner / admins): list, create (up to 40), edit name / colour / hoist / mentionable / permissions, delete, assign or remove from a member, reorder. Only the owner can grant "administrator".

- Server settings (owner / admins): theme colour, welcome screen and rules (including "accept rules before chatting"), description, vanity name, server icon (https image link only).
- Invites: create (with the same uses and expiry choices as the game, up to 20 active), list, revoke.

- Bans (owner / admins): ban a member with a reason (removes them and blocks every way back in), list bans, unban. Banned people cannot join through a public link or an invite.
- Audit log (owner / admins): successful admin actions made on the website are recorded with the same labels as the game.
- Appeals: a member appeals a timeout or a warning (10 to 500 characters); staff accept (lifts the timeout or removes the warning) or decline.

- Messages: edit history of an edited message (anyone in the server can read it).
- Staff notes (owner / admins): add, read, delete your own (owner can delete any). Members never see them.
- Channel templates: built-in (briefing, event, stage) and saved ones (up to 10); create a channel from one; save a channel as a template; delete a saved one.
- Channel order (owner / admins): the full list of channels in a new order.
- Health report (owner / admins): messages per channel, per day and per hour (last 7 days), new members.
- Mutual friends count on a profile.
- Profile look: avatar effect and profile banner (https image link).
- Announcements: mark a channel as announcement, list announcement channels of public servers, follow one into your server, unfollow, list follows.

- Message requests: someone who shares a server with you (and is not blocked) can send a request; you accept or decline it. Until you accept you cannot reply, and the sender can send up to 3 messages. Up to 5 pending requests per sender. Accepting lets you talk without being friends.
- Super reactions: one per person per message, shown separately. The same emoji again removes it; another emoji replaces it.

- Folders (your own, same as the phone): create (up to 20), rename, recolour, delete, put a server into a folder (or out of it).
- Gallery: the https photos from your phone gallery, to use as an avatar, banner or server icon.
- Image emoji (owner / admins): add a named emoji from an https link, remove it. The number of slots comes from boosts, the same as the game.

- Channel permissions (owner / admins): see the permissions of every role in a channel, set allow and deny per role (deny wins), and make a channel private (only the chosen roles can see it).

- Settings: avatar (https link), role icon, server tags (up to 4 from the list), Discover category and listing, auto-mod words, unicode emoji (within slots), stage channels, accepting the server rules.

## Not on the website, on purpose
- Voice of any kind: no calls, no speaking, no stage speakers. Stage channels are chat channels only (in the game too).
- Boost and VIP purchases (they spend in-game money; the website does not move money).
- Creating and deleting a server from the website (use the phone).
- Phone-only parts: voice and video, the login-code screen (the website uses your game login instead), in-game notifications and the phone frame.

## Notifications and login
- Mentions, direct messages and replies each have their own sound, and a banner slides in for new messages. The "Catch up" pill shows unread messages per server.
- The login page is animated (moving colour, glass card). It uses the same game login.

## Creators only (optional switch)
When the game's staff panel turns on "Only creators can create servers and channels", the website also refuses to create channels, stage channels and channels from templates for people who are not on the creators list. Staff in the game panel manage the list; the website reads the same tables.

## Not yet on the website
- Message reports: any member can report a message (one report per person per message, 20 seconds between reports). The website's report queue shows the reports of the servers you own or manage; dismiss, delete the message, or delete and warn the author. In the game the queue belongs to platform staff; on the website it is per server (owner and admins). This difference is deliberate.
- Mute: mute or unmute a channel or a whole server for yourself.
- Still not on the website: stickers and GIF packs (need a decision about the image source), and server templates (the in-game template format must be ported first).
Roles and channel permission overrides, server settings (theme, icon, welcome/rules, Discover category),
invites management, moderation (timeouts, warns, reports, staff panel), boosts and VIP, emoji and image emoji uploads,
templates, folders, mute settings, stage speakers, create/delete server and channel, gallery picker, share-to-channel,
login-code flow, gang/job official servers management. Use the in-game phone for these until they are added.

## Presence
- In the game: shown as online, like the in-game phone.
- Only on the website (open within the last 60 s): shown as online with a 📱 icon and "Using the website" under the name,
  in member lists and friend cards. Invisible users stay offline.
- Closed the website: after 60 s they show offline again.
- The in-game phone does not see website-only presence (it only knows about in-game players).

## Limits (by design)
- Server settings, roles, invites, emoji uploads, boosts and voice are **not** on the website; use the in-game phone for those.
- Roles are not evaluated on the website. Where the game would allow a message through a role, the website is stricter
  (it allows a send only when @everyone is allowed). Admins and the owner can always send.
- The global auto-mod word list is in `api.php` (`WEB_GLOBAL_WORDS`) and must be kept equal to `Config.DiscordExt.AutoMod.GlobalWords`.
- "Online" uses `users.last_seen` (MySQL `TIMESTAMPDIFF`); on other databases everyone shows offline.

## Security notes
- Use a database user that can only read/write the game tables it needs.
- Passwords are checked with the same SHA-256(password + salt) as the game. Do not expose the `login_users` table.
- All API calls need the session cookie **and** the `X-CSRF` header. Hostile search, category and ID values are parameterised.
