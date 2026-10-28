local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = GetEquippedPhoneNumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = GetLoggedInAccount
  L3_2 = L1_2
  L4_2 = "Twitter"
  return L2_2(L3_2, L4_2)
end
function L1_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2
  L4_2 = BaseCallback
  L5_2 = "birdy:"
  L6_2 = A0_2
  L5_2 = L5_2 .. L6_2
  function L6_2(A0_3, A1_3, ...)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L2_3 = GetLoggedInAccount
    L3_3 = A1_3
    L4_3 = "Twitter"
    L2_3 = L2_3(L3_3, L4_3)
    if not L2_3 then
      L3_3 = A2_2
      return L3_3
    end
    L3_3 = A1_2
    L4_3 = A0_3
    L5_3 = A1_3
    L6_3 = L2_3
    L7_3 = ...
    return L3_3(L4_3, L5_3, L6_3, L7_3)
  end
  L7_2 = A2_2
  L8_2 = A3_2
  L4_2(L5_2, L6_2, L7_2, L8_2)
end
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "SELECT phone_number FROM phone_logged_in_accounts WHERE username = ? AND app = 'Twitter' AND `active` = 1"
  L5_2 = {}
  L6_2 = A0_2
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  A1_2.app = "Twitter"
  L4_2 = 1
  L5_2 = #L3_2
  L6_2 = 1
  for L7_2 = L4_2, L5_2, L6_2 do
    L8_2 = L3_2[L7_2]
    L8_2 = L8_2.phone_number
    if L8_2 ~= A2_2 then
      L9_2 = SendNotification
      L10_2 = L8_2
      L11_2 = A1_2
      L9_2(L10_2, L11_2)
    end
  end
end
function L3_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L3_2 = A0_2
  L2_2 = A0_2.lower
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT `display_name`, `bio`, `profile_image`, `profile_header`, `verified`, `follower_count`, `following_count`, `date_joined`, private FROM `phone_twitter_accounts` WHERE `username`=?"
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = false
  L4_2 = false
  L5_2 = false
  L6_2 = false
  L7_2 = nil
  L8_2 = A1_2 or L8_2
  if A1_2 then
    L8_2 = GetLoggedInAccount
    L9_2 = A1_2
    L10_2 = "Twitter"
    L8_2 = L8_2(L9_2, L10_2)
  end
  if L8_2 then
    L9_2 = MySQL
    L9_2 = L9_2.scalar
    L9_2 = L9_2.await
    L10_2 = "SELECT `followed` FROM `phone_twitter_follows` WHERE `follower` = ? AND `followed` = ?"
    L11_2 = {}
    L12_2 = L8_2
    L13_2 = A0_2
    L11_2[1] = L12_2
    L11_2[2] = L13_2
    L9_2 = L9_2(L10_2, L11_2)
    L3_2 = nil ~= L9_2
    L9_2 = MySQL
    L9_2 = L9_2.scalar
    L9_2 = L9_2.await
    L10_2 = "SELECT `followed` FROM `phone_twitter_follows` WHERE `follower` = ? AND `followed` = ?"
    L11_2 = {}
    L12_2 = A0_2
    L13_2 = L8_2
    L11_2[1] = L12_2
    L11_2[2] = L13_2
    L9_2 = L9_2(L10_2, L11_2)
    L4_2 = nil ~= L9_2
    L9_2 = MySQL
    L9_2 = L9_2.scalar
    L9_2 = L9_2.await
    L10_2 = "SELECT `notifications` FROM `phone_twitter_follows` WHERE `follower` = ? AND `followed` = ?"
    L11_2 = {}
    L12_2 = L8_2
    L13_2 = A0_2
    L11_2[1] = L12_2
    L11_2[2] = L13_2
    L9_2 = L9_2(L10_2, L11_2)
    L5_2 = true == L9_2
    L9_2 = MySQL
    L9_2 = L9_2.scalar
    L9_2 = L9_2.await
    L10_2 = "SELECT TRUE FROM phone_twitter_follow_requests WHERE requester = ? AND requestee = ?"
    L11_2 = {}
    L12_2 = L8_2
    L13_2 = A0_2
    L11_2[1] = L12_2
    L11_2[2] = L13_2
    L9_2 = L9_2(L10_2, L11_2)
    L6_2 = nil ~= L9_2
    L9_2 = MySQL
    L9_2 = L9_2.scalar
    L9_2 = L9_2.await
    L10_2 = "SELECT pinned_tweet FROM phone_twitter_accounts WHERE username = ?"
    L11_2 = {}
    L12_2 = A0_2
    L11_2[1] = L12_2
    L9_2 = L9_2(L10_2, L11_2)
    L7_2 = L9_2
    if L7_2 then
      L9_2 = GetTweet
      L10_2 = L7_2
      L11_2 = L8_2
      L9_2 = L9_2(L10_2, L11_2)
      L7_2 = L9_2
    end
  end
  L9_2 = {}
  L10_2 = L2_2.display_name
  L9_2.name = L10_2
  L9_2.username = A0_2
  L10_2 = L2_2.follower_count
  L9_2.followers = L10_2
  L10_2 = L2_2.following_count
  L9_2.following = L10_2
  L10_2 = L2_2.date_joined
  L9_2.date_joined = L10_2
  L10_2 = L2_2.bio
  L9_2.bio = L10_2
  L10_2 = L2_2.verified
  L9_2.verified = L10_2
  L10_2 = L2_2.private
  L9_2.private = L10_2
  L10_2 = L2_2.profile_image
  L9_2.profile_picture = L10_2
  L10_2 = L2_2.profile_header
  L9_2.header = L10_2
  L9_2.isFollowing = L3_2
  L9_2.isFollowingYou = L4_2
  L9_2.notificationsEnabled = L5_2
  L9_2.pinnedTweet = L7_2
  L9_2.requested = L6_2
  return L9_2
end
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = {}
  L2_2 = MySQL
  L2_2 = L2_2.Sync
  L2_2 = L2_2.fetchAll
  L3_2 = "SELECT phone_number FROM phone_logged_in_accounts WHERE username = ? AND app = 'Twitter' AND `active` = 1"
  L4_2 = {}
  L5_2 = A0_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = 1
  L4_2 = #L2_2
  L5_2 = 1
  for L6_2 = L3_2, L4_2, L5_2 do
    L7_2 = L2_2[L6_2]
    L7_2 = L7_2.phone_number
    L8_2 = GetSourceFromNumber
    L9_2 = L2_2[L6_2]
    L9_2 = L9_2.phone_number
    L8_2 = L8_2(L9_2)
    L1_2[L7_2] = L8_2
  end
  return L1_2
end
L5_1 = {}
L5_1.like = "BACKEND.TWITTER.LIKE"
L5_1.retweet = "BACKEND.TWITTER.RETWEET"
L5_1.reply = "BACKEND.TWITTER.REPLY"
L5_1.follow = "BACKEND.TWITTER.FOLLOW"
L5_1.tweet = "BACKEND.TWITTER.TWEET"
function L6_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  if A0_2 == A1_2 then
    return
  end
  L4_2 = L5_1
  L4_2 = L4_2[A2_2]
  if not L4_2 then
    return
  end
  if "like" == A2_2 or "retweet" == A2_2 or "follow" == A2_2 then
    L5_2 = MySQL
    L5_2 = L5_2.Sync
    L5_2 = L5_2.fetchScalar
    L6_2 = "SELECT TRUE FROM phone_twitter_notifications WHERE username=@username AND `from`=@from AND `type`=@type"
    if "follow" ~= A2_2 then
      L7_2 = " AND tweet_id=@tweet_id"
      if L7_2 then
        goto lbl_25
      end
    end
    L7_2 = ""
    ::lbl_25::
    L6_2 = L6_2 .. L7_2
    L7_2 = {}
    L7_2["@username"] = A0_2
    L7_2["@from"] = A1_2
    L7_2["@type"] = A2_2
    L7_2["@tweet_id"] = A3_2
    L5_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      return
    end
  end
  L5_2 = MySQL
  L5_2 = L5_2.Sync
  L5_2 = L5_2.fetchAll
  L6_2 = "SELECT display_name, private FROM phone_twitter_accounts WHERE username=@username"
  L7_2 = {}
  L7_2["@username"] = A1_2
  L5_2 = L5_2(L6_2, L7_2)
  L5_2 = L5_2[1]
  if L5_2 then
    L6_2 = L5_2.private
    if not L6_2 or "reply" ~= A2_2 then
      goto lbl_53
    end
  end
  do return end
  ::lbl_53::
  L6_2 = L
  L7_2 = L4_2
  L8_2 = {}
  L9_2 = L5_2.display_name
  L8_2.displayName = L9_2
  L8_2.username = A1_2
  L6_2 = L6_2(L7_2, L8_2)
  L4_2 = L6_2
  L6_2 = MySQL
  L6_2 = L6_2.Async
  L6_2 = L6_2.execute
  L7_2 = "INSERT INTO phone_twitter_notifications (id, username, `from`, `type`, tweet_id) VALUES (@id, @username, @from, @type, @tweetId)"
  L8_2 = {}
  L9_2 = GenerateId
  L10_2 = "phone_twitter_notifications"
  L11_2 = "id"
  L9_2 = L9_2(L10_2, L11_2)
  L8_2["@id"] = L9_2
  L8_2["@username"] = A0_2
  L8_2["@from"] = A1_2
  L8_2["@type"] = A2_2
  L8_2["@tweetId"] = A3_2
  L6_2(L7_2, L8_2)
  L6_2 = nil
  L7_2 = nil
  if "follow" ~= A2_2 then
    L8_2 = MySQL
    L8_2 = L8_2.Sync
    L8_2 = L8_2.fetchAll
    L9_2 = "SELECT content, attachments FROM phone_twitter_tweets WHERE id=@tweetId"
    L10_2 = {}
    L10_2["@tweetId"] = A3_2
    L8_2 = L8_2(L9_2, L10_2)
    if L8_2 then
      L9_2 = L8_2[1]
      L7_2 = L9_2.content
      L9_2 = L8_2[1]
      L9_2 = L9_2.attachments
      L6_2 = L9_2 or L6_2
      if L9_2 then
        L9_2 = json
        L9_2 = L9_2.decode
        L10_2 = L8_2[1]
        L10_2 = L10_2.attachments
        L9_2 = L9_2(L10_2)
        L6_2 = L9_2
      end
    end
  end
  L8_2 = L4_1
  L9_2 = A0_2
  L8_2 = L8_2(L9_2)
  L9_2 = pairs
  L10_2 = L8_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = SendNotification
    L16_2 = L13_2
    L17_2 = {}
    L17_2.app = "Twitter"
    L17_2.title = L4_2
    L17_2.content = L7_2
    L18_2 = L6_2
    if L18_2 then
      L18_2 = L18_2[1]
    end
    L17_2.thumbnail = L18_2
    L15_2(L16_2, L17_2)
  end
end
L7_1 = RegisterLegacyCallback
L8_1 = "birdy:getNotifications"
function L9_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = L0_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = A1_2
    L5_2 = {}
    L6_2 = {}
    L5_2.notifications = L6_2
    L5_2.requests = 0
    return L4_2(L5_2)
  end
  L4_2 = MySQL
  L4_2 = L4_2.Sync
  L4_2 = L4_2.fetchAll
  L5_2 = [[
        SELECT
            -- notification data
            n.`from`, n.`type`, n.tweet_id,
            -- tweet data
            t.username, t.content, t.attachments, t.reply_to, t.like_count,
            t.reply_count, t.retweet_count, t.`timestamp`,

            (
                SELECT TRUE FROM phone_twitter_likes l
                WHERE l.tweet_id=t.id AND l.username=@username
            ) AS liked,
            (
                SELECT TRUE FROM phone_twitter_retweets r
                WHERE r.tweet_id=t.id AND r.username=@username
            ) AS retweeted,

            -- account data
            a.display_name AS `name`, a.profile_image AS profile_picture, a.verified,
            (
                CASE WHEN t.reply_to IS NULL THEN NULL ELSE (SELECT username FROM phone_twitter_tweets WHERE id=t.reply_to LIMIT 1) END
            ) AS replyToAuthor

        FROM phone_twitter_notifications n

        LEFT JOIN phone_twitter_tweets t
            ON n.tweet_id = t.id

        JOIN phone_twitter_accounts a
            ON a.username = n.from

        WHERE n.username=@username

        ORDER BY n.`timestamp` DESC

        LIMIT @page, @perPage
    ]]
  L6_2 = {}
  L7_2 = A2_2 * 15
  L6_2["@page"] = L7_2
  L6_2["@perPage"] = 15
  L6_2["@username"] = L3_2
  L4_2 = L4_2(L5_2, L6_2)
  if A2_2 > 0 then
    L5_2 = A1_2
    L6_2 = {}
    L6_2.notifications = L4_2
    return L5_2(L6_2)
  end
  L5_2 = A1_2
  L6_2 = {}
  L6_2.notifications = L4_2
  L7_2 = MySQL
  L7_2 = L7_2.Sync
  L7_2 = L7_2.fetchScalar
  L8_2 = "SELECT COUNT(1) FROM phone_twitter_follow_requests WHERE requestee=@username"
  L9_2 = {}
  L9_2["@username"] = L3_2
  L7_2 = L7_2(L8_2, L9_2)
  L6_2.requests = L7_2
  L5_2(L6_2)
end
L7_1(L8_1, L9_1)
L7_1 = RegisterLegacyCallback
L8_1 = "birdy:createAccount"
function L9_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L5_2 = GetEquippedPhoneNumber
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L6_2 = A1_2
    L7_2 = false
    return L6_2(L7_2)
  end
  L7_2 = A3_2
  L6_2 = A3_2.lower
  L6_2 = L6_2(L7_2)
  A3_2 = L6_2
  L6_2 = IsUsernameValid
  L7_2 = A3_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = A1_2
    L7_2 = {}
    L7_2.success = false
    L7_2.error = "USERNAME_NOT_ALLOWED"
    return L6_2(L7_2)
  end
  L6_2 = MySQL
  L6_2 = L6_2.Sync
  L6_2 = L6_2.fetchScalar
  L7_2 = "SELECT TRUE FROM phone_twitter_accounts WHERE username=@username"
  L8_2 = {}
  L8_2["@username"] = A3_2
  L6_2 = L6_2(L7_2, L8_2)
  if L6_2 then
    L7_2 = A1_2
    L8_2 = {}
    L8_2.success = false
    L8_2.error = "USERNAME_TAKEN"
    return L7_2(L8_2)
  end
  L7_2 = MySQL
  L7_2 = L7_2.Sync
  L7_2 = L7_2.execute
  L8_2 = "INSERT INTO phone_twitter_accounts (display_name, username, `password`, phone_number) VALUES (@displayName, @username, @password, @phonenumber)"
  L9_2 = {}
  L9_2["@displayName"] = A2_2
  L9_2["@username"] = A3_2
  L10_2 = GetPasswordHash
  L11_2 = A4_2
  L10_2 = L10_2(L11_2)
  L9_2["@password"] = L10_2
  L9_2["@phonenumber"] = L5_2
  L7_2(L8_2, L9_2)
  L7_2 = AddLoggedInAccount
  L8_2 = L5_2
  L9_2 = "Twitter"
  L10_2 = A3_2
  L7_2(L8_2, L9_2, L10_2)
  L7_2 = A1_2
  L8_2 = {}
  L8_2.success = true
  L7_2(L8_2)
  L7_2 = Config
  L7_2 = L7_2.AutoFollow
  L7_2 = L7_2.Enabled
  if L7_2 then
    L7_2 = Config
    L7_2 = L7_2.AutoFollow
    L7_2 = L7_2.Birdy
    L7_2 = L7_2.Enabled
    if L7_2 then
      L7_2 = Config
      L7_2 = L7_2.AutoFollow
      L7_2 = L7_2.Birdy
      L7_2 = L7_2.Accounts
      L8_2 = 1
      L9_2 = #L7_2
      L10_2 = 1
      for L11_2 = L8_2, L9_2, L10_2 do
        L12_2 = MySQL
        L12_2 = L12_2.update
        L12_2 = L12_2.await
        L13_2 = "INSERT INTO phone_twitter_follows (followed, follower) VALUES (?, ?)"
        L14_2 = {}
        L15_2 = L7_2[L11_2]
        L16_2 = A3_2
        L14_2[1] = L15_2
        L14_2[2] = L16_2
        L12_2(L13_2, L14_2)
      end
    end
  end
end
L10_1 = {}
L10_1.preventSpam = true
L10_1.rateLimit = 4
L7_1(L8_1, L9_1, L10_1)
L7_1 = L1_1
L8_1 = "changePassword"
function L9_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L5_2 = Config
  L5_2 = L5_2.ChangePassword
  L5_2 = L5_2.Birdy
  if not L5_2 then
    L5_2 = infoprint
    L6_2 = "warning"
    L7_2 = "%s tried to change password on Birdy, but it's not enabled in the config."
    L8_2 = L7_2
    L7_2 = L7_2.format
    L9_2 = A0_2
    L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L7_2(L8_2, L9_2)
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
    L5_2 = false
    return L5_2
  end
  if A3_2 ~= A4_2 then
    L5_2 = #A4_2
    if not (L5_2 < 3) then
      goto lbl_25
    end
  end
  L5_2 = debugprint
  L6_2 = "same password / too short"
  L5_2(L6_2)
  L5_2 = false
  do return L5_2 end
  ::lbl_25::
  L5_2 = MySQL
  L5_2 = L5_2.scalar
  L5_2 = L5_2.await
  L6_2 = "SELECT password FROM phone_twitter_accounts WHERE username = ?"
  L7_2 = {}
  L8_2 = A2_2
  L7_2[1] = L8_2
  L5_2 = L5_2(L6_2, L7_2)
  if L5_2 then
    L6_2 = VerifyPasswordHash
    L7_2 = A3_2
    L8_2 = L5_2
    L6_2 = L6_2(L7_2, L8_2)
    if L6_2 then
      goto lbl_44
    end
  end
  L6_2 = false
  do return L6_2 end
  ::lbl_44::
  L6_2 = MySQL
  L6_2 = L6_2.update
  L6_2 = L6_2.await
  L7_2 = "UPDATE phone_twitter_accounts SET password = ? WHERE username = ?"
  L8_2 = {}
  L9_2 = GetPasswordHash
  L10_2 = A4_2
  L9_2 = L9_2(L10_2)
  L10_2 = A2_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L6_2 = L6_2(L7_2, L8_2)
  L6_2 = L6_2 > 0
  if not L6_2 then
    L7_2 = false
    return L7_2
  end
  L7_2 = L2_1
  L8_2 = A2_2
  L9_2 = {}
  L10_2 = L
  L11_2 = "BACKEND.MISC.LOGGED_OUT_PASSWORD.TITLE"
  L10_2 = L10_2(L11_2)
  L9_2.title = L10_2
  L10_2 = L
  L11_2 = "BACKEND.MISC.LOGGED_OUT_PASSWORD.DESCRIPTION"
  L10_2 = L10_2(L11_2)
  L9_2.content = L10_2
  L10_2 = A1_2
  L7_2(L8_2, L9_2, L10_2)
  L7_2 = MySQL
  L7_2 = L7_2.update
  L7_2 = L7_2.await
  L8_2 = "DELETE FROM phone_logged_in_accounts WHERE username = ? AND app = 'Twitter' AND phone_number != ?"
  L9_2 = {}
  L10_2 = A2_2
  L11_2 = A1_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L7_2(L8_2, L9_2)
  L7_2 = ClearActiveAccountsCache
  L8_2 = "Twitter"
  L9_2 = A2_2
  L10_2 = A1_2
  L7_2(L8_2, L9_2, L10_2)
  L7_2 = Log
  L8_2 = "Birdy"
  L9_2 = A0_2
  L10_2 = "info"
  L11_2 = L
  L12_2 = "BACKEND.LOGS.CHANGED_PASSWORD.TITLE"
  L11_2 = L11_2(L12_2)
  L12_2 = L
  L13_2 = "BACKEND.LOGS.CHANGED_PASSWORD.DESCRIPTION"
  L14_2 = {}
  L14_2.number = A1_2
  L14_2.username = A2_2
  L14_2.app = "Birdy"
  L12_2, L13_2, L14_2 = L12_2(L13_2, L14_2)
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  L7_2 = TriggerClientEvent
  L8_2 = "phone:logoutFromApp"
  L9_2 = -1
  L10_2 = {}
  L10_2.username = A2_2
  L10_2.app = "twitter"
  L10_2.reason = "password"
  L10_2.number = A1_2
  L7_2(L8_2, L9_2, L10_2)
  L7_2 = true
  return L7_2
end
L10_1 = false
L7_1(L8_1, L9_1, L10_1)
L7_1 = L1_1
L8_1 = "deleteAccount"
function L9_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L4_2 = Config
  L4_2 = L4_2.DeleteAccount
  L4_2 = L4_2.Birdy
  if not L4_2 then
    L4_2 = infoprint
    L5_2 = "warning"
    L6_2 = "%s tried to delete their account on Birdy, but it's not enabled in the config."
    L7_2 = L6_2
    L6_2 = L6_2.format
    L8_2 = A0_2
    L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2 = L6_2(L7_2, L8_2)
    L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
    L4_2 = false
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.scalar
  L4_2 = L4_2.await
  L5_2 = "SELECT password FROM phone_twitter_accounts WHERE username = ?"
  L6_2 = {}
  L7_2 = A2_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = VerifyPasswordHash
    L6_2 = A3_2
    L7_2 = L4_2
    L5_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      goto lbl_34
    end
  end
  L5_2 = false
  do return L5_2 end
  ::lbl_34::
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "DELETE FROM phone_twitter_accounts WHERE username = ?"
  L7_2 = {}
  L8_2 = A2_2
  L7_2[1] = L8_2
  L5_2 = L5_2(L6_2, L7_2)
  L5_2 = L5_2 > 0
  if not L5_2 then
    L6_2 = false
    return L6_2
  end
  L6_2 = L2_1
  L7_2 = A2_2
  L8_2 = {}
  L9_2 = L
  L10_2 = "BACKEND.MISC.DELETED_NOTIFICATION.TITLE"
  L9_2 = L9_2(L10_2)
  L8_2.title = L9_2
  L9_2 = L
  L10_2 = "BACKEND.MISC.DELETED_NOTIFICATION.DESCRIPTION"
  L9_2 = L9_2(L10_2)
  L8_2.content = L9_2
  L6_2(L7_2, L8_2)
  L6_2 = MySQL
  L6_2 = L6_2.update
  L6_2 = L6_2.await
  L7_2 = "DELETE FROM phone_logged_in_accounts WHERE username = ? AND app = 'Twitter'"
  L8_2 = {}
  L9_2 = A2_2
  L8_2[1] = L9_2
  L6_2(L7_2, L8_2)
  L6_2 = ClearActiveAccountsCache
  L7_2 = "Twitter"
  L8_2 = A2_2
  L6_2(L7_2, L8_2)
  L6_2 = Log
  L7_2 = "Birdy"
  L8_2 = A0_2
  L9_2 = "info"
  L10_2 = L
  L11_2 = "BACKEND.LOGS.DELETED_ACCOUNT.TITLE"
  L10_2 = L10_2(L11_2)
  L11_2 = L
  L12_2 = "BACKEND.LOGS.DELETED_ACCOUNT.DESCRIPTION"
  L13_2 = {}
  L13_2.number = A1_2
  L13_2.username = A2_2
  L13_2.app = "Birdy"
  L11_2, L12_2, L13_2 = L11_2(L12_2, L13_2)
  L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  L6_2 = TriggerClientEvent
  L7_2 = "phone:logoutFromApp"
  L8_2 = -1
  L9_2 = {}
  L9_2.username = A2_2
  L9_2.app = "twitter"
  L9_2.reason = "deleted"
  L6_2(L7_2, L8_2, L9_2)
  L6_2 = true
  return L6_2
end
L10_1 = false
L7_1(L8_1, L9_1, L10_1)
L7_1 = BaseCallback
L8_1 = "birdy:login"
function L9_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2
  L5_2 = A2_2
  L4_2 = A2_2.lower
  L4_2 = L4_2(L5_2)
  A2_2 = L4_2
  L4_2 = MySQL
  L4_2 = L4_2.scalar
  L4_2 = L4_2.await
  L5_2 = "SELECT `password` FROM phone_twitter_accounts WHERE username = ?"
  L6_2 = {}
  L7_2 = A2_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = {}
    L5_2.success = false
    L5_2.error = "INVALID_ACCOUNT"
    return L5_2
  else
    L5_2 = VerifyPasswordHash
    L6_2 = A3_2
    L7_2 = L4_2
    L5_2 = L5_2(L6_2, L7_2)
    if not L5_2 then
      L5_2 = {}
      L5_2.success = false
      L5_2.error = "INVALID_PASSWORD"
      return L5_2
    else
      L5_2 = AddLoggedInAccount
      L6_2 = A1_2
      L7_2 = "Twitter"
      L8_2 = A2_2
      L5_2(L6_2, L7_2, L8_2)
      L5_2 = L3_1
      L6_2 = A2_2
      L5_2 = L5_2(L6_2)
      if not L5_2 then
        L6_2 = {}
        L6_2.success = false
        L6_2.error = "INVALID_ACCOUNT"
        return L6_2
      end
      L6_2 = {}
      L6_2.success = true
      L6_2.data = L5_2
      return L6_2
    end
  end
end
L7_1(L8_1, L9_1)
L7_1 = L1_1
L8_1 = "isLoggedIn"
function L9_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2
  L3_2 = L3_1
  L4_2 = A2_2
  return L3_2(L4_2)
end
L10_1 = false
L7_1(L8_1, L9_1, L10_1)
L7_1 = L1_1
L8_1 = "getProfile"
function L9_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2
  L4_2 = L3_1
  L5_2 = A3_2
  L6_2 = A1_2
  return L4_2(L5_2, L6_2)
end
L10_1 = false
L7_1(L8_1, L9_1, L10_1)
L7_1 = RegisterLegacyCallback
L8_1 = "birdy:pinPost"
function L9_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L3_2 = L0_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = A1_2
    L5_2 = false
    return L4_2(L5_2)
  end
  if A2_2 then
    L4_2 = MySQL
    L4_2 = L4_2.scalar
    L4_2 = L4_2.await
    L5_2 = "SELECT TRUE FROM phone_twitter_tweets WHERE id = ? AND username = ?"
    L6_2 = {}
    L7_2 = A2_2
    L8_2 = L3_2
    L6_2[1] = L7_2
    L6_2[2] = L8_2
    L4_2 = L4_2(L5_2, L6_2)
    if not L4_2 then
      L5_2 = infoprint
      L6_2 = "warning"
      L7_2 = "%s (%s) tried to pin a post on birdy that they didn't make."
      L8_2 = L7_2
      L7_2 = L7_2.format
      L9_2 = L3_2
      L10_2 = A0_2
      L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2, L9_2, L10_2)
      L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
      L5_2 = A1_2
      L6_2 = false
      return L5_2(L6_2)
    end
  end
  L4_2 = MySQL
  L4_2 = L4_2.Async
  L4_2 = L4_2.execute
  L5_2 = "UPDATE phone_twitter_accounts SET pinned_tweet=@tweetId WHERE username=@username"
  L6_2 = {}
  L7_2 = A2_2 or L7_2
  if not A2_2 or not A2_2 then
    L7_2 = nil
  end
  L6_2["@tweetId"] = L7_2
  L6_2["@username"] = L3_2
  function L7_2()
    local L0_3, L1_3
    L0_3 = A1_2
    L1_3 = true
    L0_3(L1_3)
  end
  L4_2(L5_2, L6_2, L7_2)
end
L7_1(L8_1, L9_1)
L7_1 = RegisterLegacyCallback
L8_1 = "birdy:signOut"
function L9_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = GetEquippedPhoneNumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = A1_2
    L4_2 = false
    return L3_2(L4_2)
  end
  L3_2 = GetLoggedInAccount
  L4_2 = L2_2
  L5_2 = "Twitter"
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = A1_2
    L5_2 = false
    return L4_2(L5_2)
  end
  L4_2 = RemoveLoggedInAccount
  L5_2 = L2_2
  L6_2 = "Twitter"
  L7_2 = L3_2
  L4_2(L5_2, L6_2, L7_2)
  L4_2 = A1_2
  L5_2 = true
  L4_2(L5_2)
end
L7_1(L8_1, L9_1)
L7_1 = RegisterLegacyCallback
L8_1 = "birdy:updateProfile"
function L9_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = L0_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = A1_2
    L5_2 = false
    return L4_2(L5_2)
  end
  L4_2 = A2_2.name
  L5_2 = A2_2.bio
  L6_2 = A2_2.profile_picture
  L7_2 = A2_2.header
  L8_2 = A2_2.private
  L9_2 = MySQL
  L9_2 = L9_2.Async
  L9_2 = L9_2.execute
  L10_2 = "UPDATE phone_twitter_accounts SET display_name=@displayName, bio=@bio, profile_image=@profilePicture, profile_header=@header, private=@private WHERE username=@username"
  L11_2 = {}
  L11_2["@username"] = L3_2
  L11_2["@displayName"] = L4_2
  L11_2["@bio"] = L5_2
  L11_2["@profilePicture"] = L6_2
  L11_2["@header"] = L7_2
  L11_2["@private"] = L8_2
  function L12_2()
    local L0_3, L1_3
    L0_3 = A1_2
    L1_3 = true
    L0_3(L1_3)
  end
  L9_2(L10_2, L11_2, L12_2)
end
L7_1(L8_1, L9_1)
function L7_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  if A3_2 then
    L5_2 = #A3_2
    if L5_2 then
      goto lbl_7
    end
  end
  L5_2 = 0
  ::lbl_7::
  L6_2 = "**Username**: "
  L7_2 = A1_2
  L8_2 = [[

**Content**: ]]
  L9_2 = A2_2 or L9_2
  if not A2_2 then
    L9_2 = ""
  end
  L6_2 = L6_2 .. L7_2 .. L8_2 .. L9_2
  if A3_2 then
    L7_2 = L6_2
    L8_2 = [[

**Attachments**:]]
    L7_2 = L7_2 .. L8_2
    L6_2 = L7_2
    L7_2 = 1
    L8_2 = L5_2
    L9_2 = 1
    for L10_2 = L7_2, L8_2, L9_2 do
      L11_2 = L6_2
      L12_2 = [[

[Attachment %s](%s)]]
      L13_2 = L12_2
      L12_2 = L12_2.format
      L14_2 = L10_2
      L15_2 = A3_2[L10_2]
      L12_2 = L12_2(L13_2, L14_2, L15_2)
      L11_2 = L11_2 .. L12_2
      L6_2 = L11_2
    end
  end
  L7_2 = L6_2
  L8_2 = [[

**ID**: ]]
  L9_2 = A0_2
  L7_2 = L7_2 .. L8_2 .. L9_2
  L6_2 = L7_2
  L7_2 = Log
  L8_2 = "Birdy"
  L9_2 = A4_2
  L10_2 = "info"
  L11_2 = "New post"
  L12_2 = L6_2
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
end
function L8_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L4_2 = Config
  L4_2 = L4_2.Post
  L4_2 = L4_2.Birdy
  if L4_2 and not A3_2 then
    L4_2 = BIRDY_WEBHOOK
    if L4_2 then
      L4_2 = BIRDY_WEBHOOK
      L5_2 = L4_2
      L4_2 = L4_2.sub
      L6_2 = -14
      L4_2 = L4_2(L5_2, L6_2)
      if "/api/webhooks/" ~= L4_2 then
        goto lbl_18
      end
    end
  end
  do return end
  ::lbl_18::
  L4_2 = MySQL
  L4_2 = L4_2.scalar
  L4_2 = L4_2.await
  L5_2 = "SELECT profile_image FROM phone_twitter_accounts WHERE username = ?"
  L6_2 = {}
  L7_2 = A0_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = PerformHttpRequest
  L6_2 = BIRDY_WEBHOOK
  function L7_2()
    local L0_3, L1_3
  end
  L8_2 = "POST"
  L9_2 = json
  L9_2 = L9_2.encode
  L10_2 = {}
  L11_2 = Config
  L11_2 = L11_2.Post
  L11_2 = L11_2.Accounts
  if L11_2 then
    L11_2 = L11_2.Birdy
  end
  if L11_2 then
    L11_2 = L11_2.Username
  end
  if not L11_2 then
    L11_2 = "Birdy"
  end
  L10_2.username = L11_2
  L11_2 = Config
  L11_2 = L11_2.Post
  L11_2 = L11_2.Accounts
  if L11_2 then
    L11_2 = L11_2.Birdy
  end
  if L11_2 then
    L11_2 = L11_2.Avatar
  end
  if not L11_2 then
    L11_2 = "https://loaf-scripts.com/fivem/lb-phone/icons/Birdy.png"
  end
  L10_2.avatar_url = L11_2
  L11_2 = {}
  L12_2 = {}
  L13_2 = L
  L14_2 = "APPS.TWITTER.NEW_POST"
  L13_2 = L13_2(L14_2)
  L12_2.title = L13_2
  if A1_2 then
    L13_2 = #A1_2
    if L13_2 > 0 and A1_2 then
      goto lbl_77
      L13_2 = A1_2 or L13_2
    end
  end
  L13_2 = nil
  ::lbl_77::
  L12_2.description = L13_2
  L12_2.color = 1942002
  L13_2 = GetTimestampISO
  L13_2 = L13_2()
  L12_2.timestamp = L13_2
  L13_2 = {}
  L14_2 = "@"
  L15_2 = A0_2
  L14_2 = L14_2 .. L15_2
  L13_2.name = L14_2
  L14_2 = L4_2 or L14_2
  if not L4_2 then
    L14_2 = "https://cdn.discordapp.com/embed/avatars/5.png"
  end
  L13_2.icon_url = L14_2
  L12_2.author = L13_2
  if A2_2 then
    L13_2 = #A2_2
    if L13_2 > 0 then
      L13_2 = {}
      L14_2 = A2_2[1]
      L13_2.url = L14_2
      if L13_2 then
        goto lbl_105
      end
    end
  end
  L13_2 = nil
  ::lbl_105::
  L12_2.image = L13_2
  L13_2 = {}
  L13_2.text = "Arshia Phone"
  L13_2.icon_url = "https://docs.lbscripts.com/images/icons/icon.png"
  L12_2.footer = L13_2
  L11_2[1] = L12_2
  L10_2.embeds = L11_2
  L9_2 = L9_2(L10_2)
  L10_2 = {}
  L10_2["Content-Type"] = "application/json"
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
end
function L9_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  if not A1_2 then
    A1_2 = ""
  end
  L6_2 = assert
  L7_2 = type
  L8_2 = A0_2
  L7_2 = L7_2(L8_2)
  L7_2 = "string" == L7_2
  L8_2 = "PostBirdy: Expected string for argument 1 (username), got "
  L9_2 = type
  L10_2 = A0_2
  L9_2 = L9_2(L10_2)
  L8_2 = L8_2 .. L9_2
  L6_2(L7_2, L8_2)
  L6_2 = assert
  L7_2 = type
  L8_2 = A1_2
  L7_2 = L7_2(L8_2)
  L7_2 = "string" == L7_2
  L8_2 = "PostBirdy: Expected string/nil for argument 2 (content), got "
  L9_2 = type
  L10_2 = A1_2
  L9_2 = L9_2(L10_2)
  L8_2 = L8_2 .. L9_2
  L6_2(L7_2, L8_2)
  L6_2 = GenerateId
  L7_2 = "phone_twitter_tweets"
  L8_2 = "id"
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = {}
  L8_2 = L6_2
  L9_2 = A0_2
  L10_2 = A1_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L8_2 = "INSERT INTO phone_twitter_tweets (id, username, content"
  if A2_2 then
    L9_2 = type
    L10_2 = A2_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L9_2 = table
      L9_2 = L9_2.type
      L10_2 = A2_2
      L9_2 = L9_2(L10_2)
      if "array" == L9_2 then
        L9_2 = #A2_2
        if L9_2 > 0 then
          L9_2 = L8_2
          L10_2 = ", attachments"
          L9_2 = L9_2 .. L10_2
          L8_2 = L9_2
          L9_2 = #L7_2
          L9_2 = L9_2 + 1
          L10_2 = json
          L10_2 = L10_2.encode
          L11_2 = A2_2
          L10_2 = L10_2(L11_2)
          L7_2[L9_2] = L10_2
      end
    end
    else
      L9_2 = error
      L10_2 = "PostBirdy: Expected table/nil for argument 3 (attachments), got "
      L11_2 = type
      L12_2 = A2_2
      L11_2 = L11_2(L12_2)
      L10_2 = L10_2 .. L11_2
      L9_2(L10_2)
    end
  else
    L10_2 = A1_2
    L9_2 = A1_2.gsub
    L11_2 = " "
    L12_2 = ""
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    L9_2 = #L9_2
    if 0 == L9_2 then
      L9_2 = debugprint
      L10_2 = "PostBirdy: No content & no attachments"
      L9_2(L10_2)
      L9_2 = false
      return L9_2
    end
  end
  if A3_2 then
    L9_2 = type
    L10_2 = A3_2
    L9_2 = L9_2(L10_2)
    if "string" == L9_2 then
      L9_2 = L8_2
      L10_2 = ", reply_to"
      L9_2 = L9_2 .. L10_2
      L8_2 = L9_2
      L9_2 = #L7_2
      L9_2 = L9_2 + 1
      L7_2[L9_2] = A3_2
    else
      L9_2 = error
      L10_2 = "PostBirdy: Expected string/nil for argument 4 (replyTo), got "
      L11_2 = type
      L12_2 = A3_2
      L11_2 = L11_2(L12_2)
      L10_2 = L10_2 .. L11_2
      L9_2(L10_2)
    end
  end
  L9_2 = L8_2
  L10_2 = ") VALUES ("
  L11_2 = "?, "
  L12_2 = L11_2
  L11_2 = L11_2.rep
  L13_2 = #L7_2
  L11_2 = L11_2(L12_2, L13_2)
  L12_2 = L11_2
  L11_2 = L11_2.sub
  L13_2 = 1
  L14_2 = -3
  L11_2 = L11_2(L12_2, L13_2, L14_2)
  L12_2 = ")"
  L9_2 = L9_2 .. L10_2 .. L11_2 .. L12_2
  L8_2 = L9_2
  L9_2 = MySQL
  L9_2 = L9_2.update
  L9_2 = L9_2.await
  L10_2 = L8_2
  L11_2 = L7_2
  L9_2 = L9_2(L10_2, L11_2)
  if 0 == L9_2 then
    L9_2 = false
    return L9_2
  end
  L9_2 = MySQL
  L9_2 = L9_2.single
  L9_2 = L9_2.await
  L10_2 = "SELECT display_name, profile_image, verified, private FROM phone_twitter_accounts WHERE username = ?"
  L11_2 = {}
  L12_2 = A0_2
  L11_2[1] = L12_2
  L9_2 = L9_2(L10_2, L11_2)
  if not L9_2 then
    L9_2 = {}
    L9_2.display_name = A0_2
  end
  if A3_2 then
    L10_2 = MySQL
    L10_2 = L10_2.update
    L11_2 = "UPDATE phone_twitter_tweets SET reply_count = reply_count + 1 WHERE id = ?"
    L12_2 = {}
    L13_2 = A3_2
    L12_2[1] = L13_2
    L10_2(L11_2, L12_2)
    L10_2 = TriggerClientEvent
    L11_2 = "phone:twitter:updateTweetData"
    L12_2 = -1
    L13_2 = A3_2
    L14_2 = "replies"
    L15_2 = true
    L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
    L10_2 = MySQL
    L10_2 = L10_2.scalar
    L11_2 = "SELECT username FROM phone_twitter_tweets WHERE id = ?"
    L12_2 = {}
    L13_2 = A3_2
    L12_2[1] = L13_2
    function L13_2(A0_3)
      local L1_3, L2_3, L3_3, L4_3, L5_3
      if A0_3 then
        L1_3 = L6_1
        L2_3 = A0_3
        L3_3 = A0_2
        L4_3 = "reply"
        L5_3 = L6_2
        L1_3(L2_3, L3_3, L4_3, L5_3)
      end
    end
    L10_2(L11_2, L12_2, L13_2)
  end
  L10_2 = MySQL
  L10_2 = L10_2.query
  L11_2 = "SELECT follower FROM phone_twitter_follows WHERE followed = ? AND notifications=1"
  L12_2 = {}
  L13_2 = A0_2
  L12_2[1] = L13_2
  function L13_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3
    L1_3 = 1
    L2_3 = #A0_3
    L3_3 = 1
    for L4_3 = L1_3, L2_3, L3_3 do
      L5_3 = L6_1
      L6_3 = A0_3[L4_3]
      L6_3 = L6_3.follower
      L7_3 = A0_2
      L8_3 = "tweet"
      L9_3 = L6_2
      L5_3(L6_3, L7_3, L8_3, L9_3)
    end
  end
  L10_2(L11_2, L12_2, L13_2)
  L10_2 = TrackSocialMediaPost
  L11_2 = "birdy"
  L12_2 = A2_2
  L10_2(L11_2, L12_2)
  if A5_2 then
    L10_2 = L7_1
    L11_2 = L6_2
    L12_2 = A0_2
    L13_2 = A1_2
    L14_2 = A2_2
    L15_2 = A5_2
    L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
  end
  L10_2 = L9_2.private
  if not L10_2 then
    L10_2 = L8_1
    L11_2 = A0_2
    L12_2 = A1_2
    L13_2 = A2_2
    L14_2 = A3_2
    L10_2(L11_2, L12_2, L13_2, L14_2)
    L10_2 = Config
    L10_2 = L10_2.BirdyNotifications
    if L10_2 then
      L10_2 = Config
      L10_2 = L10_2.BirdyNotifications
      if "all" == L10_2 then
        L10_2 = "all"
        if L10_2 then
          goto lbl_221
        end
      end
      L10_2 = "online"
      ::lbl_221::
      L11_2 = NotifyEveryone
      L12_2 = L10_2
      L13_2 = {}
      L13_2.app = "Twitter"
      L14_2 = L
      L15_2 = "BACKEND.TWITTER.TWEET"
      L16_2 = {}
      L16_2.username = A0_2
      L14_2 = L14_2(L15_2, L16_2)
      L13_2.title = L14_2
      L13_2.content = A1_2
      L14_2 = A2_2
      if L14_2 then
        L14_2 = L14_2[1]
      end
      L13_2.thumbnail = L14_2
      L11_2(L12_2, L13_2)
    end
    L10_2 = Config
    L10_2 = L10_2.BirdyTrending
    L10_2 = L10_2.Enabled
    if L10_2 then
      L10_2 = type
      L11_2 = A4_2
      L10_2 = L10_2(L11_2)
      if "table" == L10_2 then
        L10_2 = table
        L10_2 = L10_2.type
        L11_2 = A4_2
        L10_2 = L10_2(L11_2)
        if "array" == L10_2 then
          L10_2 = #A4_2
          if L10_2 > 0 then
            L10_2 = MySQL
            L10_2 = L10_2.update
            L11_2 = [[
                INSERT INTO
                    phone_twitter_hashtags (hashtag, amount)
                VALUES
            ]]
            L12_2 = "(?, 1), "
            L13_2 = L12_2
            L12_2 = L12_2.rep
            L14_2 = #A4_2
            L12_2 = L12_2(L13_2, L14_2)
            L13_2 = L12_2
            L12_2 = L12_2.sub
            L14_2 = 1
            L15_2 = -3
            L12_2 = L12_2(L13_2, L14_2, L15_2)
            L13_2 = [[
                ON DUPLICATE KEY UPDATE amount = amount + 1
            ]]
            L11_2 = L11_2 .. L12_2 .. L13_2
            L12_2 = A4_2
            L10_2(L11_2, L12_2)
          end
        end
      end
    end
    L10_2 = {}
    L10_2.id = L6_2
    L10_2.username = A0_2
    L10_2.content = A1_2
    L10_2.attachments = A2_2
    L10_2.like_count = 0
    L10_2.reply_count = 0
    L10_2.retweet_count = 0
    L10_2.reply_to = A3_2
    L11_2 = os
    L11_2 = L11_2.time
    L11_2 = L11_2()
    L11_2 = L11_2 * 1000
    L10_2.timestamp = L11_2
    L10_2.liked = false
    L10_2.retweeted = false
    L11_2 = L9_2.display_name
    L10_2.display_name = L11_2
    L11_2 = L9_2.profile_image
    L10_2.profile_image = L11_2
    L11_2 = L9_2.verified
    L10_2.verified = L11_2
    if A3_2 then
      L11_2 = MySQL
      L11_2 = L11_2.scalar
      L11_2 = L11_2.await
      L12_2 = "SELECT username FROM phone_twitter_tweets WHERE id = ?"
      L13_2 = {}
      L14_2 = A3_2
      L13_2[1] = L14_2
      L11_2 = L11_2(L12_2, L13_2)
      L10_2.replyToAuthor = L11_2
    end
    L11_2 = TriggerClientEvent
    L12_2 = "phone:twitter:newtweet"
    L13_2 = -1
    L14_2 = L10_2
    L11_2(L12_2, L13_2, L14_2)
    L11_2 = TriggerEvent
    L12_2 = "lb-phone:birdy:newPost"
    L13_2 = L10_2
    L11_2(L12_2, L13_2)
  end
  L10_2 = true
  L11_2 = L6_2
  return L10_2, L11_2
end
L10_1 = exports
L11_1 = "PostBirdy"
L12_1 = L9_1
L10_1(L11_1, L12_1)
L10_1 = L1_1
L11_1 = "sendPost"
function L12_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2)
  local L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L7_2 = ContainsBlacklistedWord
  L8_2 = A0_2
  L9_2 = "Birdy"
  L10_2 = A3_2
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  if L7_2 then
    L7_2 = false
    return L7_2
  end
  L7_2 = L9_1
  L8_2 = A2_2
  L9_2 = A3_2
  L10_2 = A4_2
  L11_2 = A5_2
  L12_2 = A6_2
  L13_2 = A0_2
  L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2)
  return L7_2
end
L13_1 = nil
L14_1 = {}
L14_1.preventSpam = true
L14_1.rateLimit = 15
L10_1(L11_1, L12_1, L13_1, L14_1)
L10_1 = RegisterCallback
L11_1 = "birdy:getRecentHashtags"
function L12_1(A0_2)
  local L1_2, L2_2
  L1_2 = Config
  L1_2 = L1_2.BirdyTrending
  L1_2 = L1_2.Enabled
  if L1_2 then
    L1_2 = MySQL
    L1_2 = L1_2.query
    L1_2 = L1_2.await
    L2_2 = "SELECT hashtag, amount AS uses FROM phone_twitter_hashtags ORDER BY amount DESC LIMIT 5"
    return L1_2(L2_2)
  end
  L1_2 = {}
  return L1_2
end
L10_1(L11_1, L12_1)
L10_1 = RegisterLegacyCallback
L11_1 = "birdy:deletePost"
function L12_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L3_2 = L0_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = A1_2
    L5_2 = false
    return L4_2(L5_2)
  end
  L4_2 = MySQL
  L4_2 = L4_2.Sync
  L4_2 = L4_2.fetchScalar
  L5_2 = "SELECT reply_to FROM phone_twitter_tweets WHERE id=@id"
  L6_2 = {}
  L6_2["@id"] = A2_2
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = IsAdmin
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = MySQL
    L5_2 = L5_2.Sync
    L5_2 = L5_2.fetchScalar
    L6_2 = "SELECT TRUE FROM phone_twitter_tweets WHERE id=@id AND username=@username"
    L7_2 = {}
    L7_2["@id"] = A2_2
    L7_2["@username"] = L3_2
    L5_2 = L5_2(L6_2, L7_2)
  end
  if not L5_2 then
    L6_2 = A1_2
    L7_2 = false
    return L6_2(L7_2)
  end
  L6_2 = {}
  L6_2["@id"] = A2_2
  L7_2 = MySQL
  L7_2 = L7_2.Sync
  L7_2 = L7_2.execute
  L8_2 = "DELETE FROM phone_twitter_likes WHERE tweet_id=@id"
  L9_2 = L6_2
  L7_2(L8_2, L9_2)
  L7_2 = MySQL
  L7_2 = L7_2.Sync
  L7_2 = L7_2.execute
  L8_2 = "DELETE FROM phone_twitter_retweets WHERE tweet_id=@id"
  L9_2 = L6_2
  L7_2(L8_2, L9_2)
  L7_2 = MySQL
  L7_2 = L7_2.Sync
  L7_2 = L7_2.execute
  L8_2 = "DELETE FROM phone_twitter_notifications WHERE tweet_id=@id"
  L9_2 = L6_2
  L7_2(L8_2, L9_2)
  L7_2 = MySQL
  L7_2 = L7_2.Sync
  L7_2 = L7_2.execute
  L8_2 = "DELETE FROM phone_twitter_tweets WHERE id=@id"
  L9_2 = L6_2
  L7_2 = L7_2(L8_2, L9_2)
  L7_2 = L7_2 > 0
  L8_2 = A1_2
  L9_2 = L7_2
  L8_2(L9_2)
  if not L7_2 then
    return
  end
  if L4_2 then
    L8_2 = MySQL
    L8_2 = L8_2.Sync
    L8_2 = L8_2.fetchScalar
    L9_2 = "SELECT COUNT(id) FROM phone_twitter_tweets WHERE reply_to=@replyTo"
    L10_2 = {}
    L10_2["@replyTo"] = L4_2
    L8_2 = L8_2(L9_2, L10_2)
    L9_2 = MySQL
    L9_2 = L9_2.Sync
    L9_2 = L9_2.execute
    L10_2 = "UPDATE phone_twitter_tweets SET reply_count=@count WHERE id=@replyTo"
    L11_2 = {}
    L11_2["@replyTo"] = L4_2
    L11_2["@count"] = L8_2
    L9_2(L10_2, L11_2)
    L9_2 = TriggerClientEvent
    L10_2 = "phone:twitter:updateTweetData"
    L11_2 = -1
    L12_2 = L4_2
    L13_2 = "replies"
    L14_2 = false
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
  end
  L8_2 = Log
  L9_2 = "Birdy"
  L10_2 = A0_2
  L11_2 = "info"
  L12_2 = "Post deleted"
  L13_2 = "**ID**: "
  L14_2 = A2_2
  L13_2 = L13_2 .. L14_2
  L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
end
L10_1(L11_1, L12_1)
L10_1 = RegisterLegacyCallback
L11_1 = "birdy:getRandomPromoted"
function L12_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L0_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = A1_2
    L4_2 = false
    return L3_2(L4_2)
  end
  L3_2 = MySQL
  L3_2 = L3_2.Sync
  L3_2 = L3_2.fetchScalar
  L4_2 = "SELECT tweet_id FROM phone_twitter_promoted WHERE promotions > 0 ORDER BY RAND() LIMIT 1"
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = A1_2
    L5_2 = false
    return L4_2(L5_2)
  end
  L4_2 = MySQL
  L4_2 = L4_2.Async
  L4_2 = L4_2.execute
  L5_2 = "UPDATE phone_twitter_promoted SET promotions = promotions - 1, views = views + 1 WHERE tweet_id = @tweetId"
  L6_2 = {}
  L6_2["@tweetId"] = L3_2
  L4_2(L5_2, L6_2)
  L4_2 = A1_2
  L5_2 = GetTweet
  L6_2 = L3_2
  L5_2, L6_2 = L5_2(L6_2)
  L4_2(L5_2, L6_2)
end
L10_1(L11_1, L12_1)
L10_1 = RegisterLegacyCallback
L11_1 = "birdy:promotePost"
function L12_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = Config
  L3_2 = L3_2.PromoteBirdy
  if L3_2 then
    L3_2 = L3_2.Enabled
  end
  if L3_2 then
    L3_2 = RemoveMoney
    if L3_2 then
      goto lbl_15
    end
  end
  L3_2 = A1_2
  L4_2 = false
  do return L3_2(L4_2) end
  ::lbl_15::
  L3_2 = RemoveMoney
  L4_2 = A0_2
  L5_2 = Config
  L5_2 = L5_2.PromoteBirdy
  L5_2 = L5_2.Cost
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = A1_2
    L4_2 = false
    return L3_2(L4_2)
  end
  L3_2 = MySQL
  L3_2 = L3_2.Async
  L3_2 = L3_2.execute
  L4_2 = [[
        INSERT INTO phone_twitter_promoted (tweet_id, promotions, views) VALUES (@tweetId, @promotions, 0)
            ON DUPLICATE KEY UPDATE promotions = promotions + @promotions
    ]]
  L5_2 = {}
  L5_2["@tweetId"] = A2_2
  L6_2 = Config
  L6_2 = L6_2.PromoteBirdy
  L6_2 = L6_2.Views
  L5_2["@promotions"] = L6_2
  L3_2(L4_2, L5_2)
  L3_2 = A1_2
  L4_2 = true
  L3_2(L4_2)
end
L10_1(L11_1, L12_1)
L10_1 = RegisterLegacyCallback
L11_1 = "birdy:searchAccounts"
function L12_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = MySQL
  L3_2 = L3_2.Async
  L3_2 = L3_2.fetchAll
  L4_2 = [[
        SELECT display_name, username, profile_image, verified, private
        FROM phone_twitter_accounts
        WHERE
            username LIKE CONCAT(@search, "%")
            OR
            display_name LIKE CONCAT("%", @search, "%")
    ]]
  L5_2 = {}
  L5_2["@search"] = A2_2
  L6_2 = A1_2
  L3_2(L4_2, L5_2, L6_2)
end
L10_1(L11_1, L12_1)
L10_1 = RegisterLegacyCallback
L11_1 = "birdy:searchTweets"
function L12_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2
  L4_2 = L0_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = A1_2
    L6_2 = false
    return L5_2(L6_2)
  end
  L5_2 = MySQL
  L5_2 = L5_2.Async
  L5_2 = L5_2.fetchAll
  L6_2 = [[
        SELECT
            DISTINCT t.id, t.username, t.content, t.attachments,
            t.like_count, t.reply_count, t.retweet_count, t.reply_to,
            t.`timestamp`,

            (
                CASE WHEN t.reply_to IS NULL THEN NULL ELSE (SELECT username FROM phone_twitter_tweets WHERE id=t.reply_to LIMIT 1) END
            ) AS replyToAuthor,

            a.display_name, a.username, a.profile_image, a.verified,

            (
                SELECT TRUE FROM phone_twitter_likes l
                WHERE l.tweet_id=t.id AND l.username=@loggedInAs
            ) AS liked,
            (
                SELECT TRUE FROM phone_twitter_retweets r
                WHERE r.tweet_id=t.id AND r.username=@loggedInAs
            ) AS retweeted

        FROM phone_twitter_tweets t
            LEFT JOIN phone_twitter_accounts a ON a.username=t.username
        WHERE
            t.content LIKE CONCAT("%", @search, "%")

        ORDER BY t.`timestamp` DESC

        LIMIT
            @page, @perPage
    ]]
  L7_2 = {}
  L7_2["@search"] = A2_2
  L7_2["@loggedInAs"] = L4_2
  L8_2 = A3_2 * 10
  L7_2["@page"] = L8_2
  L7_2["@perPage"] = 10
  L8_2 = A1_2
  L5_2(L6_2, L7_2, L8_2)
end
L10_1(L11_1, L12_1)
L10_1 = RegisterLegacyCallback
L11_1 = "birdy:getData"
function L12_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L5_2 = L0_1
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L6_2 = A1_2
    L7_2 = false
    return L6_2(L7_2)
  end
  L6_2 = "phone_twitter_likes"
  L7_2 = "tweet_id"
  L8_2 = "username"
  if "following" == A2_2 or "followers" == A2_2 then
    L6_2 = "phone_twitter_follows"
    if "following" == A2_2 then
      L7_2 = "follower"
      L8_2 = "followed"
    else
      L7_2 = "followed"
      L8_2 = "follower"
    end
  elseif "retweeters" == A2_2 then
    L6_2 = "phone_twitter_retweets"
    L7_2 = "tweet_id"
    L8_2 = "username"
  end
  L9_2 = MySQL
  L9_2 = L9_2.Async
  L9_2 = L9_2.fetchAll
  L10_2 = [[
        SELECT
            a.display_name AS `name`,
            a.username,
            a.profile_image AS profile_picture,
            a.bio,
            a.verified,

        (
            SELECT CASE WHEN f.followed IS NULL THEN FALSE ELSE TRUE END
                FROM phone_twitter_follows f
                WHERE f.follower=@loggedInAs AND a.username=f.followed
        ) AS isFollowing,

        (
            SELECT CASE WHEN f.follower IS NULL THEN FALSE ELSE TRUE END
                FROM phone_twitter_follows f
                WHERE f.follower=a.username AND f.followed=@loggedInAs
        ) AS isFollowingYou

        FROM
            %s w
        JOIN
            phone_twitter_accounts a ON a.username=w.%s
        WHERE
            w.%s=@whereValue

        ORDER BY
            a.username DESC

        LIMIT
            @page, @perPage
    ]]
  L11_2 = L10_2
  L10_2 = L10_2.format
  L12_2 = L6_2
  L13_2 = L8_2
  L14_2 = L7_2
  L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
  L11_2 = {}
  L11_2["@loggedInAs"] = L5_2
  L11_2["@whereValue"] = A3_2
  L12_2 = A4_2 * 20
  L11_2["@page"] = L12_2
  L11_2["@perPage"] = 20
  L12_2 = A1_2
  L9_2(L10_2, L11_2, L12_2)
end
L10_1(L11_1, L12_1)
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if not A0_2 then
    return
  end
  L2_2 = MySQL
  L2_2 = L2_2.Sync
  L2_2 = L2_2.fetchAll
  L3_2 = [[
        SELECT
            DISTINCT t.id, t.username, t.content, t.attachments,
            t.like_count, t.reply_count, t.retweet_count, t.reply_to,
            t.`timestamp`,

            (
                CASE WHEN t.reply_to IS NULL THEN NULL ELSE (SELECT username FROM phone_twitter_tweets WHERE id=t.reply_to LIMIT 1) END
            ) AS replyToAuthor,

            a.display_name, a.username, a.profile_image, a.verified,

            (
                SELECT TRUE FROM phone_twitter_likes l
                WHERE l.tweet_id=t.id AND l.username=@loggedInAs
            ) AS liked,
            (
                SELECT TRUE FROM phone_twitter_retweets r
                WHERE r.tweet_id=t.id AND r.username=@loggedInAs
            ) AS retweeted

        FROM phone_twitter_tweets t

        INNER JOIN phone_twitter_accounts a
            ON a.username=t.username

        WHERE t.id=@tweetId AND (a.private=0 OR a.username=@loggedInAs OR (
            SELECT TRUE FROM phone_twitter_follows f
            WHERE f.follower=@loggedInAs AND f.followed=a.username
        ))
    ]]
  L4_2 = {}
  L4_2["@tweetId"] = A0_2
  L4_2["@loggedInAs"] = A1_2
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L2_2 = L2_2[1]
  end
  return L2_2
end
GetTweet = L10_1
L10_1 = exports
L11_1 = "GetTweet"
function L12_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = assert
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L3_2 = "string" == L3_2
  L4_2 = "Expected string for argument 1, got "
  L5_2 = type
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  L4_2 = L4_2 .. L5_2
  L2_2(L3_2, L4_2)
  L2_2 = infoprint
  L3_2 = "warning"
  L4_2 = "GetTweet is deprecated, use GetBirdyPost instead"
  L2_2(L3_2, L4_2)
  L2_2 = MySQL
  L2_2 = L2_2.Async
  L2_2 = L2_2.fetchAll
  L3_2 = [[
        SELECT
            DISTINCT t.id, t.username, t.content, t.attachments,
            t.like_count, t.reply_count, t.retweet_count, t.reply_to,
            t.`timestamp`,
            a.display_name, a.username, a.profile_image, a.verified
        FROM (phone_twitter_tweets t, phone_twitter_accounts a)
        WHERE t.id=@tweetId AND t.username=a.username
    ]]
  L4_2 = {}
  L4_2["@tweetId"] = A0_2
  L5_2 = A1_2
  L2_2(L3_2, L4_2, L5_2)
end
L10_1(L11_1, L12_1)
L10_1 = exports
L11_1 = "GetBirdyPost"
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = MySQL
  L1_2 = L1_2.single
  L1_2 = L1_2.await
  L2_2 = [[
        SELECT
            t.id,
            t.username,
            t.content,
            t.attachments,
            t.like_count AS likes,
            t.reply_count AS replies,
            t.retweet_count AS reposts,
            t.reply_to AS replyTo,
            t.`timestamp`,
            a.display_name AS displayName,
            a.profile_image AS avatar,
            a.verified
        FROM
            phone_twitter_tweets t
            LEFT JOIN phone_twitter_accounts a ON a.username = t.username
        WHERE
            t.id = ?
    ]]
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  L1_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L2_2 = L1_2.attachments
    if L2_2 then
      L2_2 = json
      L2_2 = L2_2.decode
      L3_2 = L1_2.attachments
      L2_2 = L2_2(L3_2)
      if L2_2 then
        goto lbl_22
      end
    end
    L2_2 = nil
    ::lbl_22::
    L1_2.attachments = L2_2
  end
  return L1_2
end
L10_1(L11_1, L12_1)
L10_1 = RegisterLegacyCallback
L11_1 = "birdy:getPost"
function L12_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = L0_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = A1_2
    L5_2 = false
    return L4_2(L5_2)
  end
  L4_2 = A1_2
  L5_2 = GetTweet
  L6_2 = A2_2
  L7_2 = L3_2
  L5_2, L6_2, L7_2 = L5_2(L6_2, L7_2)
  L4_2(L5_2, L6_2, L7_2)
end
L10_1(L11_1, L12_1)
L10_1 = RegisterLegacyCallback
L11_1 = "birdy:getPosts"
function L12_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L4_2 = L0_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = A1_2
    L6_2 = {}
    return L5_2(L6_2)
  end
  L5_2 = ""
  L6_2 = ""
  L7_2 = "`timestamp` DESC"
  L8_2 = false
  L9_2 = ""
  L10_2 = ""
  if not A2_2 then
    L5_2 = "t.reply_to IS NULL"
    L8_2 = true
  else
    L11_2 = A2_2.type
    if "following" == L11_2 then
      L11_2 = "t.reply_to IS NULL"
      L12_2 = " AND f.follower=@loggedInAs"
      L13_2 = " AND f.followed=t.username"
      L11_2 = L11_2 .. L12_2 .. L13_2
      L5_2 = L11_2
      L6_2 = "JOIN phone_twitter_follows f"
      L10_2 = "JOIN phone_twitter_follows f ON f.follower=@loggedInAs AND r.username=f.followed"
      L8_2 = true
    else
      L11_2 = A2_2.type
      if "replyTo" == L11_2 then
        L5_2 = "t.reply_to=@replyTo"
        L7_2 = "t.like_count DESC, t.timestamp DESC"
      else
        L11_2 = A2_2.type
        if "user" == L11_2 then
          L11_2 = "t.username=@username"
          L12_2 = " AND t.reply_to IS NULL"
          L11_2 = L11_2 .. L12_2
          L5_2 = L11_2
          L9_2 = " AND r.username=@username"
          L8_2 = true
        else
          L11_2 = A2_2.type
          if "media" == L11_2 then
            L11_2 = "t.username=@username"
            L12_2 = " AND t.attachments IS NOT NULL"
            L11_2 = L11_2 .. L12_2
            L5_2 = L11_2
          else
            L11_2 = A2_2.type
            if "replies" == L11_2 then
              L11_2 = "t.username=@username"
              L12_2 = " AND t.reply_to IS NOT NULL"
              L11_2 = L11_2 .. L12_2
              L5_2 = L11_2
            else
              L11_2 = A2_2.type
              if "liked" == L11_2 then
                L11_2 = "l.username=@username"
                L12_2 = " AND t.id=l.tweet_id"
                L11_2 = L11_2 .. L12_2
                L5_2 = L11_2
                L6_2 = "JOIN phone_twitter_likes l"
                L7_2 = "l.timestamp DESC"
              end
            end
          end
        end
      end
    end
  end
  L11_2 = [[
        SELECT
            (
                CASE WHEN t.reply_to IS NULL THEN NULL ELSE (SELECT username FROM phone_twitter_tweets WHERE id=t.reply_to LIMIT 1) END
            ) AS replyToAuthor,

            t.id, t.username, t.content, t.attachments,
            t.like_count, t.reply_count, t.retweet_count, t.reply_to,
            t.`timestamp`,

            a.display_name, a.profile_image, a.verified, a.private,

            (
                SELECT TRUE FROM phone_twitter_likes l2
                WHERE l2.tweet_id=t.id AND l2.username=@loggedInAs
            ) AS liked,
            (
                SELECT TRUE FROM phone_twitter_retweets r2
                WHERE r2.tweet_id=t.id AND r2.username=@loggedInAs
            ) AS retweeted,

            NULL AS tweet_timestamp, NULL AS retweeted_by_display_name, NULL AS retweeted_by_username
        FROM phone_twitter_tweets t

        INNER JOIN phone_twitter_accounts a
            ON a.username=t.username

        %s
        WHERE (a.private=0 OR a.username=@loggedInAs OR (
            SELECT TRUE FROM phone_twitter_follows f
            WHERE f.follower=@loggedInAs AND f.followed=a.username
        )) AND %s
    ]]
  L12_2 = L11_2
  L11_2 = L11_2.format
  L13_2 = L6_2
  L14_2 = L5_2
  L11_2 = L11_2(L12_2, L13_2, L14_2)
  if L8_2 then
    L12_2 = L11_2
    L13_2 = [[
            UNION ALL
            SELECT
                (
                    CASE WHEN t.reply_to IS NULL THEN NULL ELSE (SELECT username FROM phone_twitter_tweets WHERE id=t.reply_to LIMIT 1) END
                ) AS replyToAuthor,

                t.id, t.username, t.content, t.attachments,
                t.like_count, t.reply_count, t.retweet_count, t.reply_to,
                r.timestamp,

                a.display_name, a.profile_image, a.verified, a.private,

                (
                    SELECT TRUE FROM phone_twitter_likes l2
                    WHERE l2.tweet_id=t.id AND l2.username=@loggedInAs
                ) AS liked,
                (
                    SELECT TRUE FROM phone_twitter_retweets r2
                    WHERE r2.tweet_id=t.id AND r2.username=@loggedInAs
                ) AS retweeted,

                t.`timestamp` AS tweet_timestamp,
                (
                    SELECT display_name FROM phone_twitter_accounts a2
                    WHERE r.username=a2.username
                ) AS retweeted_by_display_name,
                r.username AS retweeted_by_username

            FROM phone_twitter_tweets t

            INNER JOIN phone_twitter_accounts a
                ON a.username=t.username

            JOIN phone_twitter_retweets r ON r.tweet_id=t.id
            %s
            WHERE (a.private=0 OR a.username=@loggedInAs OR (
                SELECT TRUE FROM phone_twitter_follows f
                WHERE f.follower=@loggedInAs AND f.followed=a.username
            )) %s
        ]]
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = L10_2
    L16_2 = L9_2
    L13_2 = L13_2(L14_2, L15_2, L16_2)
    L12_2 = L12_2 .. L13_2
    L11_2 = L12_2
  end
  L12_2 = L11_2
  L13_2 = [[
ORDER BY %s

]]
  L14_2 = L13_2
  L13_2 = L13_2.format
  L15_2 = L7_2
  L13_2 = L13_2(L14_2, L15_2)
  L12_2 = L12_2 .. L13_2
  L11_2 = L12_2
  L12_2 = L11_2
  L13_2 = "LIMIT @page, @perPage"
  L12_2 = L12_2 .. L13_2
  L11_2 = L12_2
  L12_2 = MySQL
  L12_2 = L12_2.Async
  L12_2 = L12_2.fetchAll
  L13_2 = L11_2
  L14_2 = {}
  L15_2 = A3_2 * 10
  L14_2["@page"] = L15_2
  L14_2.perPage = 10
  L15_2 = A2_2
  if L15_2 then
    L15_2 = L15_2.username
  end
  L14_2["@username"] = L15_2
  L15_2 = A2_2
  if L15_2 then
    L15_2 = L15_2.tweet_id
  end
  L14_2["@replyTo"] = L15_2
  L14_2["@loggedInAs"] = L4_2
  L15_2 = A1_2
  L12_2(L13_2, L14_2, L15_2)
end
L10_1(L11_1, L12_1)
L10_1 = {}
L11_1 = {}
L11_1.table = "phone_twitter_likes"
L11_1.column1 = "username"
L11_1.column2 = "tweet_id"
L10_1.like = L11_1
L11_1 = {}
L11_1.table = "phone_twitter_retweets"
L11_1.column1 = "username"
L11_1.column2 = "tweet_id"
L10_1.retweet = L11_1
L11_1 = RegisterLegacyCallback
L12_1 = "birdy:toggleInteraction"
function L13_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  if "like" ~= A2_2 and "retweet" ~= A2_2 then
    return
  end
  L5_2 = L0_1
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L6_2 = A1_2
    L7_2 = not A4_2
    return L6_2(L7_2)
  end
  function L6_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    if 0 == A0_3 then
      L1_3 = A1_2
      L2_3 = A4_2
      L2_3 = not L2_3
      return L1_3(L2_3)
    else
      L1_3 = A1_2
      L2_3 = A4_2
      L1_3(L2_3)
    end
    L1_3 = TriggerClientEvent
    L2_3 = "phone:twitter:updateTweetData"
    L3_3 = -1
    L4_3 = A3_2
    L5_3 = A2_2
    if "like" == L5_3 then
      L5_3 = "likes"
      if L5_3 then
        goto lbl_23
      end
    end
    L5_3 = "retweets"
    ::lbl_23::
    L6_3 = A4_2
    L6_3 = true == L6_3
    L1_3(L2_3, L3_3, L4_3, L5_3, L6_3)
    L1_3 = A4_2
    if L1_3 then
      L1_3 = MySQL
      L1_3 = L1_3.Sync
      L1_3 = L1_3.fetchScalar
      L2_3 = "SELECT username FROM phone_twitter_tweets WHERE id=@tweetId"
      L3_3 = {}
      L4_3 = A3_2
      L3_3["@tweetId"] = L4_3
      L1_3 = L1_3(L2_3, L3_3)
      L2_3 = L6_1
      L3_3 = L1_3
      L4_3 = L5_2
      L5_3 = A2_2
      L6_3 = A3_2
      L2_3(L3_3, L4_3, L5_3, L6_3)
    end
  end
  L7_2 = L10_1
  L7_2 = L7_2[A2_2]
  L7_2 = L7_2.table
  L8_2 = L10_1
  L8_2 = L8_2[A2_2]
  L8_2 = L8_2.column1
  L9_2 = L10_1
  L9_2 = L9_2[A2_2]
  L9_2 = L9_2.column2
  if A4_2 then
    L10_2 = MySQL
    L10_2 = L10_2.Async
    L10_2 = L10_2.execute
    L11_2 = "INSERT IGNORE INTO %s (%s, %s) VALUES (@loggedInAs, @tweetId)"
    L12_2 = L11_2
    L11_2 = L11_2.format
    L13_2 = L7_2
    L14_2 = L8_2
    L15_2 = L9_2
    L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2)
    L12_2 = {}
    L12_2["@loggedInAs"] = L5_2
    L12_2["@tweetId"] = A3_2
    L13_2 = L6_2
    L10_2(L11_2, L12_2, L13_2)
  else
    L10_2 = MySQL
    L10_2 = L10_2.Async
    L10_2 = L10_2.execute
    L11_2 = "DELETE FROM %s WHERE %s=@loggedInAs AND %s=@tweetId"
    L12_2 = L11_2
    L11_2 = L11_2.format
    L13_2 = L7_2
    L14_2 = L8_2
    L15_2 = L9_2
    L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2)
    L12_2 = {}
    L12_2["@loggedInAs"] = L5_2
    L12_2["@tweetId"] = A3_2
    L13_2 = L6_2
    L10_2(L11_2, L12_2, L13_2)
  end
end
L14_1 = {}
L14_1.preventSpam = true
L14_1.rateLimit = 30
L11_1(L12_1, L13_1, L14_1)
L11_1 = RegisterLegacyCallback
L12_1 = "birdy:toggleNotifications"
function L13_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2
  L4_2 = L0_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = A1_2
    L6_2 = not A3_2
    return L5_2(L6_2)
  end
  L5_2 = MySQL
  L5_2 = L5_2.Async
  L5_2 = L5_2.execute
  L6_2 = "UPDATE phone_twitter_follows SET notifications=@enabled WHERE follower=@loggedInAs AND followed=@username "
  L7_2 = {}
  L7_2["@enabled"] = A3_2
  L7_2["@loggedInAs"] = L4_2
  L7_2["@username"] = A2_2
  function L8_2(A0_3)
    local L1_3, L2_3
    if A0_3 > 0 then
      L1_3 = A1_2
      L2_3 = A3_2
      L1_3(L2_3)
    else
      L1_3 = A1_2
      L2_3 = A3_2
      L2_3 = not L2_3
      L1_3(L2_3)
    end
  end
  L5_2(L6_2, L7_2, L8_2)
end
L11_1(L12_1, L13_1)
L11_1 = RegisterLegacyCallback
L12_1 = "birdy:toggleFollow"
function L13_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L4_2 = L0_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 or A2_2 == L4_2 then
    L5_2 = A1_2
    L6_2 = not A3_2
    return L5_2(L6_2)
  end
  L5_2 = {}
  L5_2["@loggedInAs"] = L4_2
  L5_2["@username"] = A2_2
  L6_2 = MySQL
  L6_2 = L6_2.Sync
  L6_2 = L6_2.fetchScalar
  L7_2 = "SELECT private FROM phone_twitter_accounts WHERE username=@username"
  L8_2 = L5_2
  L6_2 = L6_2(L7_2, L8_2)
  if L6_2 then
    if A3_2 then
      L7_2 = MySQL
      L7_2 = L7_2.Async
      L7_2 = L7_2.execute
      L8_2 = "INSERT IGNORE INTO phone_twitter_follow_requests (requester, requestee) VALUES (@loggedInAs, @username)"
      L9_2 = L5_2
      function L10_2(A0_3)
        local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3
        L1_3 = A1_2
        L2_3 = A3_2
        L1_3(L2_3)
        if 0 == A0_3 then
          return
        end
        L1_3 = L4_1
        L2_3 = A2_2
        L1_3 = L1_3(L2_3)
        L2_3 = pairs
        L3_3 = L1_3
        L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3)
        for L6_3, L7_3 in L2_3, L3_3, L4_3, L5_3 do
          L8_3 = SendNotification
          L9_3 = L6_3
          L10_3 = {}
          L10_3.app = "Twitter"
          L11_3 = L
          L12_3 = "BACKEND.TWITTER.NEW_FOLLOW_REQUEST"
          L13_3 = {}
          L14_3 = L4_2
          L13_3.username = L14_3
          L11_3 = L11_3(L12_3, L13_3)
          L10_3.content = L11_3
          L8_3(L9_3, L10_3)
        end
      end
      L7_2(L8_2, L9_2, L10_2)
      return
    end
    L7_2 = MySQL
    L7_2 = L7_2.Async
    L7_2 = L7_2.execute
    L8_2 = "DELETE FROM phone_twitter_follow_requests WHERE requester=@loggedInAs AND requestee=@username"
    L9_2 = L5_2
    L7_2(L8_2, L9_2)
  end
  L7_2 = "INSERT IGNORE INTO phone_twitter_follows (followed, follower) VALUES (@username, @loggedInAs)"
  if not A3_2 then
    L7_2 = "DELETE FROM phone_twitter_follows WHERE followed=@username AND follower=@loggedInAs"
  end
  L8_2 = MySQL
  L8_2 = L8_2.Async
  L8_2 = L8_2.execute
  L9_2 = L7_2
  L10_2 = L5_2
  function L11_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    if 0 == A0_3 then
      L1_3 = A1_2
      L2_3 = A3_2
      L2_3 = not L2_3
      return L1_3(L2_3)
    end
    L1_3 = TriggerClientEvent
    L2_3 = "phone:twitter:updateProfileData"
    L3_3 = -1
    L4_3 = A2_2
    L5_3 = "followers"
    L6_3 = A3_2
    L6_3 = true == L6_3
    L1_3(L2_3, L3_3, L4_3, L5_3, L6_3)
    L1_3 = TriggerClientEvent
    L2_3 = "phone:twitter:updateProfileData"
    L3_3 = -1
    L4_3 = L4_2
    L5_3 = "following"
    L6_3 = A3_2
    L6_3 = true == L6_3
    L1_3(L2_3, L3_3, L4_3, L5_3, L6_3)
    L1_3 = A3_2
    if L1_3 then
      L1_3 = L6_1
      L2_3 = A2_2
      L3_3 = L4_2
      L4_3 = "follow"
      L1_3(L2_3, L3_3, L4_3)
    end
    L1_3 = A1_2
    L2_3 = A3_2
    L1_3(L2_3)
  end
  L8_2(L9_2, L10_2, L11_2)
end
L14_1 = {}
L14_1.preventSpam = true
L14_1.rateLimit = 30
L11_1(L12_1, L13_1, L14_1)
L11_1 = RegisterLegacyCallback
L12_1 = "birdy:getFollowRequests"
function L13_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = L0_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = A1_2
    L5_2 = {}
    return L4_2(L5_2)
  end
  L4_2 = MySQL
  L4_2 = L4_2.Async
  L4_2 = L4_2.fetchAll
  L5_2 = [[
        SELECT a.username, a.display_name AS `name`, a.profile_image AS profile_picture, a.verified,
            (
                SELECT CASE WHEN f.follower IS NULL THEN FALSE ELSE TRUE END
                    FROM phone_twitter_follows f
                    WHERE f.follower=a.username AND f.followed=@loggedInAs
            ) AS isFollowingYou

        FROM phone_twitter_follow_requests r

        INNER JOIN phone_twitter_accounts a
            ON a.username=r.requester

        WHERE r.requestee=@loggedInAs

        ORDER BY r.`timestamp` DESC

        LIMIT @page, @perPage
    ]]
  L6_2 = {}
  L6_2["@loggedInAs"] = L3_2
  L7_2 = A2_2 or L7_2
  if not A2_2 then
    L7_2 = 0
  end
  L7_2 = L7_2 * 15
  L6_2["@page"] = L7_2
  L6_2["@perPage"] = 15
  L7_2 = A1_2
  L4_2(L5_2, L6_2, L7_2)
end
L11_1(L12_1, L13_1)
L11_1 = RegisterLegacyCallback
L12_1 = "birdy:handleFollowRequest"
function L13_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L4_2 = L0_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = A1_2
    L6_2 = false
    return L5_2(L6_2)
  end
  L5_2 = {}
  L5_2["@loggedInAs"] = L4_2
  L5_2["@username"] = A2_2
  L6_2 = MySQL
  L6_2 = L6_2.Sync
  L6_2 = L6_2.execute
  L7_2 = "DELETE FROM phone_twitter_follow_requests WHERE requestee=@loggedInAs AND requester=@username"
  L8_2 = L5_2
  L6_2 = L6_2(L7_2, L8_2)
  if 0 == L6_2 then
    L7_2 = A1_2
    L8_2 = false
    return L7_2(L8_2)
  end
  if not A3_2 then
    L7_2 = A1_2
    L8_2 = true
    return L7_2(L8_2)
  end
  L7_2 = MySQL
  L7_2 = L7_2.Sync
  L7_2 = L7_2.execute
  L8_2 = "INSERT IGNORE INTO phone_twitter_follows (follower, followed) VALUES (@username, @loggedInAs)"
  L9_2 = L5_2
  L7_2(L8_2, L9_2)
  L7_2 = TriggerClientEvent
  L8_2 = "phone:twitter:updateProfileData"
  L9_2 = -1
  L10_2 = L4_2
  L11_2 = "followers"
  L12_2 = true
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L7_2 = TriggerClientEvent
  L8_2 = "phone:twitter:updateProfileData"
  L9_2 = -1
  L10_2 = A2_2
  L11_2 = "following"
  L12_2 = true
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2)
  L7_2 = L6_1
  L8_2 = L4_2
  L9_2 = A2_2
  L10_2 = "follow"
  L7_2(L8_2, L9_2, L10_2)
  L7_2 = L4_1
  L8_2 = A2_2
  L7_2 = L7_2(L8_2)
  L8_2 = pairs
  L9_2 = L7_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = SendNotification
    L15_2 = L12_2
    L16_2 = {}
    L16_2.app = "Twitter"
    L17_2 = L
    L18_2 = "BACKEND.TWITTER.FOLLOW_REQUEST_ACCEPTED_DESCRIPTION"
    L19_2 = {}
    L19_2.username = L4_2
    L17_2 = L17_2(L18_2, L19_2)
    L16_2.content = L17_2
    L14_2(L15_2, L16_2)
  end
  L8_2 = A1_2
  L9_2 = true
  L8_2(L9_2)
end
L11_1(L12_1, L13_1)
L11_1 = L1_1
L12_1 = "sendMessage"
function L13_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2)
  local L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L6_2 = ContainsBlacklistedWord
  L7_2 = A0_2
  L8_2 = "Birdy"
  L9_2 = A4_2
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  if L6_2 then
    L6_2 = false
    return L6_2
  end
  L6_2 = MySQL
  L6_2 = L6_2.update
  L6_2 = L6_2.await
  L7_2 = [[
        INSERT INTO phone_twitter_messages (id, sender, recipient, content, attachments)
        VALUES (@id, @sender, @recipient, @content, @attachments)
    ]]
  L8_2 = {}
  L9_2 = GenerateId
  L10_2 = "phone_twitter_messages"
  L11_2 = "id"
  L9_2 = L9_2(L10_2, L11_2)
  L8_2["@id"] = L9_2
  L8_2["@sender"] = A2_2
  L8_2["@recipient"] = A3_2
  L8_2["@content"] = A4_2
  L9_2 = A5_2 or L9_2
  if A5_2 then
    L9_2 = json
    L9_2 = L9_2.encode
    L10_2 = A5_2
    L9_2 = L9_2(L10_2)
  end
  L8_2["@attachments"] = L9_2
  L6_2 = L6_2(L7_2, L8_2)
  if 0 == L6_2 then
    L6_2 = false
    return L6_2
  end
  L6_2 = L4_1
  L7_2 = A3_2
  L6_2 = L6_2(L7_2)
  L7_2 = pairs
  L8_2 = L6_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    if L12_2 then
      L13_2 = TriggerClientEvent
      L14_2 = "phone:twitter:newMessage"
      L15_2 = L12_2
      L16_2 = {}
      L16_2.sender = A2_2
      L16_2.recipient = A3_2
      L16_2.content = A4_2
      L16_2.attachments = A5_2
      L17_2 = os
      L17_2 = L17_2.time
      L17_2 = L17_2()
      L17_2 = L17_2 * 1000
      L16_2.timestamp = L17_2
      L13_2(L14_2, L15_2, L16_2)
    end
  end
  L7_2 = L3_1
  L8_2 = A2_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L8_2 = true
    return L8_2
  end
  L8_2 = pairs
  L9_2 = L6_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = SendNotification
    L15_2 = L12_2
    L16_2 = {}
    L16_2.source = L13_2
    L16_2.app = "Twitter"
    L17_2 = L7_2.name
    L16_2.title = L17_2
    L16_2.content = A4_2
    L17_2 = A5_2
    if L17_2 then
      L17_2 = L17_2[1]
    end
    L16_2.thumbnail = L17_2
    L17_2 = L7_2.profile_picture
    L16_2.avatar = L17_2
    L16_2.showAvatar = true
    L14_2(L15_2, L16_2)
  end
  L8_2 = true
  return L8_2
end
L14_1 = nil
L15_1 = {}
L15_1.preventSpam = true
L15_1.rateLimit = 15
L11_1(L12_1, L13_1, L14_1, L15_1)
L11_1 = RegisterLegacyCallback
L12_1 = "birdy:getMessages"
function L13_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2
  L4_2 = L0_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = A1_2
    L6_2 = {}
    return L5_2(L6_2)
  end
  L5_2 = MySQL
  L5_2 = L5_2.Async
  L5_2 = L5_2.fetchAll
  L6_2 = [[
        SELECT
            sender, recipient, content, attachments, `timestamp`

        FROM phone_twitter_messages

        WHERE (sender=@loggedInAs AND recipient=@username) OR (sender=@username AND recipient=@loggedInAs)

        ORDER BY `timestamp` DESC

        LIMIT @page, @perPage
    ]]
  L7_2 = {}
  L7_2["@loggedInAs"] = L4_2
  L7_2["@username"] = A2_2
  L8_2 = A3_2 * 25
  L7_2["@page"] = L8_2
  L7_2["@perPage"] = 25
  L8_2 = A1_2
  L5_2(L6_2, L7_2, L8_2)
end
L11_1(L12_1, L13_1)
L11_1 = RegisterLegacyCallback
L12_1 = "birdy:getRecentMessages"
function L13_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = L0_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L4_2 = A1_2
    L5_2 = {}
    return L4_2(L5_2)
  end
  L4_2 = MySQL
  L4_2 = L4_2.Async
  L4_2 = L4_2.fetchAll
  L5_2 = [[
        SELECT
            m.content, m.attachments, m.sender, f_m.username, m.`timestamp`,

            a.display_name AS `name`, a.profile_image AS profile_picture, a.verified

        FROM phone_twitter_messages m

        JOIN ((
            SELECT (
                CASE WHEN recipient!=@loggedInAs THEN recipient ELSE sender END
            ) AS username, MAX(`timestamp`) AS `timestamp`

            FROM phone_twitter_messages

            WHERE sender=@loggedInAs OR recipient=@loggedInAs

            GROUP BY username
        ) f_m)
        ON m.`timestamp`=f_m.`timestamp`

        INNER JOIN phone_twitter_accounts a
            ON a.username=f_m.username

        WHERE m.sender=@loggedInAs OR m.recipient=@loggedInAs

        GROUP BY f_m.username

        ORDER BY m.`timestamp` DESC

        LIMIT @page, @perPage
    ]]
  L6_2 = {}
  L6_2["@loggedInAs"] = L3_2
  L7_2 = A2_2 or L7_2
  if not A2_2 then
    L7_2 = 0
  end
  L7_2 = L7_2 * 15
  L6_2["@page"] = L7_2
  L6_2["@perPage"] = 15
  L7_2 = A1_2
  L4_2(L5_2, L6_2, L7_2)
end
L11_1(L12_1, L13_1)
L11_1 = CreateThread
function L12_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = Config
  L0_2 = L0_2.BirdyTrending
  L0_2 = L0_2.Enabled
  if not L0_2 then
    return
  end
  while true do
    L0_2 = DatabaseCheckerFinished
    if L0_2 then
      break
    end
    L0_2 = Wait
    L1_2 = 500
    L0_2(L1_2)
  end
  while true do
    L0_2 = MySQL
    L0_2 = L0_2.Async
    L0_2 = L0_2.execute
    L1_2 = "DELETE FROM phone_twitter_hashtags WHERE last_used < DATE_SUB(NOW(), INTERVAL %s HOUR)"
    L2_2 = L1_2
    L1_2 = L1_2.format
    L3_2 = tostring
    L4_2 = Config
    L4_2 = L4_2.BirdyTrending
    L4_2 = L4_2.Reset
    if not L4_2 then
      L4_2 = 24
    end
    L3_2, L4_2 = L3_2(L4_2)
    L1_2 = L1_2(L2_2, L3_2, L4_2)
    L2_2 = {}
    L0_2(L1_2, L2_2)
    L0_2 = Wait
    L1_2 = 3600000
    L0_2(L1_2)
  end
end
L11_1(L12_1)
