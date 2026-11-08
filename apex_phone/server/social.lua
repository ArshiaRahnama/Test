local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1, L58_1, L59_1
function L0_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT username FROM apex_phone_social_accounts WHERE app = ? AND owner = ?"
  L4_2 = {}
  L5_2 = A1_2
  L6_2 = GetCid
  L7_2 = A0_2
  L6_2, L7_2 = L6_2(L7_2)
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = L2_2 or L3_2
  if L2_2 then
    L3_2 = L2_2.username
  end
  return L3_2
end
function L1_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT owner, username FROM apex_phone_social_accounts WHERE app = ? AND username = ?"
  L4_2 = {}
  L5_2 = A0_2
  L6_2 = A1_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  return L2_2(L3_2, L4_2)
end
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = MySQL
  L2_2 = L2_2.scalar
  L2_2 = L2_2.await
  L3_2 = "SELECT id FROM apex_phone_social_accounts WHERE app = ? AND username = ? LIMIT 1"
  L4_2 = {}
  L5_2 = A0_2
  L6_2 = A1_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L2_2 = L2_2(L3_2, L4_2)
  L2_2 = nil ~= L2_2
  return L2_2
end
function L3_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  if nil == A2_2 then
    L3_2 = true
    return L3_2
  end
  if nil ~= A1_2 then
    L3_2 = tostring
    L4_2 = A2_2
    L3_2 = L3_2(L4_2)
    L4_2 = L3_2
    L3_2 = L3_2.lower
    L3_2 = L3_2(L4_2)
    L4_2 = tostring
    L5_2 = A1_2
    L4_2 = L4_2(L5_2)
    L5_2 = L4_2
    L4_2 = L4_2.lower
    L4_2 = L4_2(L5_2)
    if L3_2 == L4_2 then
      L3_2 = true
      return L3_2
    end
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT private FROM apex_phone_social_accounts WHERE app = ? AND username = ?"
  L5_2 = {}
  L6_2 = A0_2
  L7_2 = A2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = tonumber
    L5_2 = L3_2.private
    L4_2 = L4_2(L5_2)
    if not L4_2 then
      L4_2 = 0
    end
    if 0 ~= L4_2 then
      goto lbl_43
    end
  end
  L4_2 = true
  do return L4_2 end
  ::lbl_43::
  if nil == A1_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT follower FROM apex_phone_follows WHERE app = ? AND follower = ? AND followed = ?"
  L6_2 = {}
  L7_2 = A0_2
  L8_2 = A1_2
  L9_2 = A2_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L4_2 = L4_2(L5_2, L6_2)
  L4_2 = nil ~= L4_2
  return L4_2
end
function L4_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = A0_2 or L1_2
  if nil == A0_2 or "" == A0_2 or not A0_2 then
    L1_2 = "apex_phone_posts."
  end
  L2_2 = " AND (%sauthor = ? OR NOT EXISTS (SELECT 1 FROM apex_phone_social_accounts ac WHERE ac.app = %sapp AND ac.username = %sauthor AND ac.private = 1"
  L3_2 = " AND NOT EXISTS (SELECT 1 FROM apex_phone_follows fw WHERE fw.app = ac.app AND fw.follower = ? AND fw.followed = ac.username)))"
  L2_2 = L2_2 .. L3_2
  L3_2 = L2_2
  L2_2 = L2_2.format
  L4_2 = L1_2
  L5_2 = L1_2
  L6_2 = L1_2
  return L2_2(L3_2, L4_2, L5_2, L6_2)
end
function L5_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = A0_2 or L1_2
  if "string" ~= L1_2 or "" == A0_2 or not A0_2 then
    L1_2 = "apex_phone_stories."
  end
  L2_2 = " AND NOT EXISTS (SELECT 1 FROM apex_phone_social_accounts ac WHERE ac.app = %sapp AND ac.username = %sauthor"
  L3_2 = " AND ac.private = 1 AND ac.owner <> ?"
  L4_2 = " AND NOT EXISTS (SELECT 1 FROM apex_phone_follows fw JOIN apex_phone_social_accounts mm ON mm.app = ac.app AND mm.username = fw.follower"
  L5_2 = " WHERE fw.app = ac.app AND fw.followed = ac.username AND mm.owner = ?))"
  L2_2 = L2_2 .. L3_2 .. L4_2 .. L5_2
  L3_2 = L2_2
  L2_2 = L2_2.format
  L4_2 = L1_2
  L5_2 = L1_2
  return L2_2(L3_2, L4_2, L5_2)
end
function L6_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L3_2 = {}
  L4_2 = {}
  L5_2 = {}
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = A1_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    if nil ~= L12_2 then
      L13_2 = tostring
      L14_2 = L12_2
      L13_2 = L13_2(L14_2)
      L14_2 = L13_2
      L13_2 = L13_2.lower
      L13_2 = L13_2(L14_2)
      L14_2 = L4_2[L13_2]
      if not L14_2 then
        L4_2[L13_2] = true
        L14_2 = #L5_2
        L14_2 = L14_2 + 1
        L15_2 = tostring
        L16_2 = L12_2
        L15_2 = L15_2(L16_2)
        L5_2[L14_2] = L15_2
        L14_2 = #L6_2
        L14_2 = L14_2 + 1
        L6_2[L14_2] = "?"
      end
    end
  end
  L7_2 = #L5_2
  if 0 == L7_2 then
    return L3_2
  end
  L7_2 = {}
  L8_2 = A0_2
  L7_2[1] = L8_2
  L8_2 = ipairs
  L9_2 = L5_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = #L7_2
    L14_2 = L14_2 + 1
    L7_2[L14_2] = L13_2
  end
  L8_2 = ipairs
  L9_2 = MySQL
  L9_2 = L9_2.query
  L9_2 = L9_2.await
  L10_2 = "SELECT "
  L11_2 = A2_2
  L12_2 = " FROM apex_phone_social_accounts WHERE app = ? AND username IN ("
  L13_2 = table
  L13_2 = L13_2.concat
  L14_2 = L6_2
  L15_2 = ","
  L13_2 = L13_2(L14_2, L15_2)
  L14_2 = ")"
  L10_2 = L10_2 .. L11_2 .. L12_2 .. L13_2 .. L14_2
  L11_2 = L7_2
  L9_2 = L9_2(L10_2, L11_2)
  if not L9_2 then
    L9_2 = {}
  end
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = tostring
    L15_2 = L13_2.username
    L14_2 = L14_2(L15_2)
    L15_2 = L14_2
    L14_2 = L14_2.lower
    L14_2 = L14_2(L15_2)
    L3_2[L14_2] = L13_2
  end
  return L3_2
end
function L7_1(A0_2, A1_2)
  local L2_2, L3_2
  if nil ~= A1_2 then
    L2_2 = tostring
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
    L3_2 = L2_2
    L2_2 = L2_2.lower
    L2_2 = L2_2(L3_2)
    L2_2 = A0_2[L2_2]
    if L2_2 then
      goto lbl_12
    end
  end
  L2_2 = nil
  ::lbl_12::
  return L2_2
end
L8_1 = 48000
L9_1 = 4096
L10_1 = "{a}id, {a}app, {a}author, {a}content, {a}reply_to, {a}repost_of, {a}created, "
L11_1 = "IF(CHAR_LENGTH({a}image) <= "
L12_1 = L9_1
L13_1 = ", {a}image, NULL) AS image, CHAR_LENGTH({a}image) AS image_len"
L10_1 = L10_1 .. L11_1 .. L12_1 .. L13_1
L12_1 = L10_1
L11_1 = L10_1.gsub
L13_1 = "{a}"
L14_1 = ""
L11_1 = L11_1(L12_1, L13_1, L14_1)
L13_1 = L10_1
L12_1 = L10_1.gsub
L14_1 = "{a}"
L15_1 = "p."
L12_1 = L12_1(L13_1, L14_1, L15_1)
function L13_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2.image_len
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = 0
  end
  A0_2.image_len = nil
  L2_2 = A0_2.image
  if nil == L2_2 then
    L2_2 = L9_1
    if L1_2 > L2_2 then
      A0_2.imageLen = L1_2
      L2_2 = L8_1
      A0_2.chunk = L2_2
    end
  end
  L2_2 = A0_2.image
  if L2_2 then
    L2_2 = tonumber
    L3_2 = A0_2.image
    L2_2 = L2_2(L3_2)
    if L2_2 then
      L2_2 = tonumber
      L3_2 = A0_2.image
      L2_2 = L2_2(L3_2)
      A0_2.image = L2_2
    end
  end
end
function L14_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2
  L3_2 = #A1_2
  if 0 == L3_2 then
    return A1_2
  end
  L3_2 = {}
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = A1_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = #L3_2
    L11_2 = L11_2 + 1
    L12_2 = L10_2.id
    L3_2[L11_2] = L12_2
    L11_2 = L10_2.id
    L4_2[L11_2] = L10_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "SELECT post_id, username FROM apex_phone_likes WHERE post_id IN ("
  L7_2 = table
  L7_2 = L7_2.concat
  L8_2 = L3_2
  L9_2 = ","
  L7_2 = L7_2(L8_2, L9_2)
  L8_2 = ")"
  L6_2 = L6_2 .. L7_2 .. L8_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = {}
  end
  L6_2 = MySQL
  L6_2 = L6_2.query
  L6_2 = L6_2.await
  L7_2 = "SELECT post_id, COUNT(*) AS n FROM apex_phone_comments WHERE post_id IN ("
  L8_2 = table
  L8_2 = L8_2.concat
  L9_2 = L3_2
  L10_2 = ","
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = ") GROUP BY post_id"
  L7_2 = L7_2 .. L8_2 .. L9_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = {}
  end
  L7_2 = MySQL
  L7_2 = L7_2.query
  L7_2 = L7_2.await
  L8_2 = "SELECT repost_of, COUNT(*) AS n FROM apex_phone_posts WHERE repost_of IN ("
  L9_2 = table
  L9_2 = L9_2.concat
  L10_2 = L3_2
  L11_2 = ","
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = ") GROUP BY repost_of"
  L8_2 = L8_2 .. L9_2 .. L10_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = {}
  end
  L8_2 = ipairs
  L9_2 = A1_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L13_2.likes = 0
    L13_2.liked = false
    L13_2.comments = 0
    L13_2.reposts = 0
    L13_2.saved = false
  end
  L8_2 = ipairs
  L9_2 = L5_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L13_2.post_id
    L14_2 = L4_2[L14_2]
    if L14_2 then
      L15_2 = L14_2.likes
      L15_2 = L15_2 + 1
      L14_2.likes = L15_2
      L15_2 = L13_2.username
      if L15_2 == A2_2 then
        L14_2.liked = true
      end
    end
  end
  if A2_2 then
    L8_2 = MySQL
    L8_2 = L8_2.query
    L8_2 = L8_2.await
    L9_2 = "SELECT post_id FROM apex_phone_saves WHERE app = ? AND username = ? AND post_id IN ("
    L10_2 = table
    L10_2 = L10_2.concat
    L11_2 = L3_2
    L12_2 = ","
    L10_2 = L10_2(L11_2, L12_2)
    L11_2 = ")"
    L9_2 = L9_2 .. L10_2 .. L11_2
    L10_2 = {}
    L11_2 = A0_2
    L12_2 = A2_2
    L10_2[1] = L11_2
    L10_2[2] = L12_2
    L8_2 = L8_2(L9_2, L10_2)
    if not L8_2 then
      L8_2 = {}
    end
    L9_2 = ipairs
    L10_2 = L8_2
    L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
    for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
      L15_2 = L14_2.post_id
      L15_2 = L4_2[L15_2]
      if L15_2 then
        L15_2.saved = true
      end
    end
  end
  L8_2 = ipairs
  L9_2 = L6_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L13_2.post_id
    L14_2 = L4_2[L14_2]
    if L14_2 then
      L15_2 = L13_2.n
      L14_2.comments = L15_2
    end
  end
  L8_2 = MySQL
  L8_2 = L8_2.query
  L8_2 = L8_2.await
  L9_2 = "SELECT reply_to, COUNT(*) AS n FROM apex_phone_posts WHERE reply_to IN ("
  L10_2 = table
  L10_2 = L10_2.concat
  L11_2 = L3_2
  L12_2 = ","
  L10_2 = L10_2(L11_2, L12_2)
  L11_2 = ") GROUP BY reply_to"
  L9_2 = L9_2 .. L10_2 .. L11_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = {}
  end
  L9_2 = ipairs
  L10_2 = L8_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = L14_2.reply_to
    L15_2 = L4_2[L15_2]
    if L15_2 then
      L16_2 = L15_2.comments
      if not L16_2 then
        L16_2 = 0
      end
      L17_2 = tonumber
      L18_2 = L14_2.n
      L17_2 = L17_2(L18_2)
      if not L17_2 then
        L17_2 = 0
      end
      L16_2 = L16_2 + L17_2
      L15_2.comments = L16_2
    end
  end
  L9_2 = ipairs
  L10_2 = L7_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = L14_2.repost_of
    L15_2 = L4_2[L15_2]
    if L15_2 then
      L16_2 = L14_2.n
      L15_2.reposts = L16_2
    end
  end
  L9_2 = {}
  L10_2 = {}
  L11_2 = ipairs
  L12_2 = A1_2
  L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
  for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
    L17_2 = math
    L17_2 = L17_2.tointeger
    L18_2 = tonumber
    L19_2 = L16_2.repost_of
    L18_2 = L18_2(L19_2)
    if not L18_2 then
      L18_2 = 0
    end
    L17_2 = L17_2(L18_2)
    if L17_2 and L17_2 > 0 then
      L18_2 = #L9_2
      L18_2 = L18_2 + 1
      L9_2[L18_2] = L17_2
    end
  end
  L11_2 = #L9_2
  if L11_2 > 0 then
    L11_2 = ipairs
    L12_2 = MySQL
    L12_2 = L12_2.query
    L12_2 = L12_2.await
    L13_2 = "SELECT "
    L14_2 = L11_1
    L15_2 = " FROM apex_phone_posts WHERE id IN ("
    L16_2 = table
    L16_2 = L16_2.concat
    L17_2 = L9_2
    L18_2 = ","
    L16_2 = L16_2(L17_2, L18_2)
    L17_2 = ")"
    L13_2 = L13_2 .. L14_2 .. L15_2 .. L16_2 .. L17_2
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      L12_2 = {}
    end
    L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
    for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
      L17_2 = L16_2.id
      L10_2[L17_2] = L16_2
    end
  end
  L11_2 = {}
  L12_2 = ipairs
  L13_2 = A1_2
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
  for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
    L18_2 = #L11_2
    L18_2 = L18_2 + 1
    L19_2 = L17_2.author
    L11_2[L18_2] = L19_2
  end
  L12_2 = pairs
  L13_2 = L10_2
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
  for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
    L18_2 = #L11_2
    L18_2 = L18_2 + 1
    L19_2 = L17_2.author
    L11_2[L18_2] = L19_2
  end
  L12_2 = L6_1
  L13_2 = A0_2
  L14_2 = L11_2
  L15_2 = "username, avatar, avatar_url, private"
  L12_2 = L12_2(L13_2, L14_2, L15_2)
  L13_2 = {}
  L14_2 = {}
  L15_2 = pairs
  L16_2 = L10_2
  L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
  for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
    L21_2 = L7_1
    L22_2 = L12_2
    L23_2 = L20_2.author
    L21_2 = L21_2(L22_2, L23_2)
    L22_2 = nil ~= A2_2
    if L21_2 then
      L23_2 = tonumber
      L24_2 = L21_2.private
      L23_2 = L23_2(L24_2)
      if not L23_2 then
        L23_2 = 0
      end
      if 1 == L23_2 and not L22_2 then
        L23_2 = tostring
        L24_2 = L20_2.author
        L23_2 = L23_2(L24_2)
        L24_2 = L23_2
        L23_2 = L23_2.lower
        L23_2 = L23_2(L24_2)
        L13_2[L23_2] = true
        L24_2 = #L14_2
        L24_2 = L24_2 + 1
        L25_2 = tostring
        L26_2 = L20_2.author
        L25_2 = L25_2(L26_2)
        L14_2[L24_2] = L25_2
      end
    end
  end
  if A2_2 then
    L15_2 = #L14_2
    if L15_2 > 0 then
      L15_2 = {}
      L16_2 = {}
      L17_2 = A0_2
      L18_2 = A2_2
      L16_2[1] = L17_2
      L16_2[2] = L18_2
      L17_2 = ipairs
      L18_2 = L14_2
      L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
      for L21_2, L22_2 in L17_2, L18_2, L19_2, L20_2 do
        L15_2[L21_2] = "?"
        L23_2 = #L16_2
        L23_2 = L23_2 + 1
        L16_2[L23_2] = L22_2
      end
      L17_2 = ipairs
      L18_2 = MySQL
      L18_2 = L18_2.query
      L18_2 = L18_2.await
      L19_2 = "SELECT followed FROM apex_phone_follows WHERE app = ? AND follower = ? AND followed IN ("
      L20_2 = table
      L20_2 = L20_2.concat
      L21_2 = L15_2
      L22_2 = ","
      L20_2 = L20_2(L21_2, L22_2)
      L21_2 = ")"
      L19_2 = L19_2 .. L20_2 .. L21_2
      L20_2 = L16_2
      L18_2 = L18_2(L19_2, L20_2)
      if not L18_2 then
        L18_2 = {}
      end
      L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
      for L21_2, L22_2 in L17_2, L18_2, L19_2, L20_2 do
        L23_2 = tostring
        L24_2 = L22_2.followed
        L23_2 = L23_2(L24_2)
        L24_2 = L23_2
        L23_2 = L23_2.lower
        L23_2 = L23_2(L24_2)
        L13_2[L23_2] = nil
      end
    end
  end
  L14_2 = pairs
  L15_2 = L10_2
  L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
  for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
    L20_2 = L7_1
    L21_2 = L12_2
    L22_2 = L19_2.author
    L20_2 = L20_2(L21_2, L22_2)
    if L20_2 then
      L21_2 = L20_2.avatar
      if L21_2 then
        goto lbl_417
      end
    end
    L21_2 = 1
    ::lbl_417::
    L19_2.avatar = L21_2
    L21_2 = L13_1
    L22_2 = L19_2
    L21_2(L22_2)
  end
  L14_2 = ipairs
  L15_2 = A1_2
  L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
  for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
    L20_2 = L7_1
    L21_2 = L12_2
    L22_2 = L19_2.author
    L20_2 = L20_2(L21_2, L22_2)
    if L20_2 then
      L21_2 = L20_2.avatar
      if L21_2 then
        goto lbl_438
      end
    end
    L21_2 = 1
    ::lbl_438::
    L22_2 = tonumber
    L23_2 = L21_2
    L22_2 = L22_2(L23_2)
    if not L22_2 then
      L22_2 = L21_2
    end
    L19_2.avatar = L22_2
    if L20_2 then
      L22_2 = L20_2.avatar_url
      if L22_2 then
        goto lbl_451
      end
    end
    L22_2 = nil
    ::lbl_451::
    L19_2.avatarUrl = L22_2
    L22_2 = L13_1
    L23_2 = L19_2
    L22_2(L23_2)
    L22_2 = L19_2.repost_of
    if L22_2 then
      L22_2 = math
      L22_2 = L22_2.tointeger
      L23_2 = tonumber
      L24_2 = L19_2.repost_of
      L23_2 = L23_2(L24_2)
      if not L23_2 then
        L23_2 = 0
      end
      L22_2 = L22_2(L23_2)
      if not L22_2 then
        L22_2 = 0
      end
      L22_2 = L10_2[L22_2]
      if L22_2 then
        L23_2 = L22_2.author
        if nil ~= L23_2 then
          L23_2 = tostring
          L24_2 = L22_2.author
          L23_2 = L23_2(L24_2)
          L24_2 = L23_2
          L23_2 = L23_2.lower
          L23_2 = L23_2(L24_2)
          L23_2 = L13_2[L23_2]
          if L23_2 then
            goto lbl_485
          end
        end
        L19_2.original = L22_2
      end
    end
    ::lbl_485::
  end
  return A1_2
end
L15_1 = RPC
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 0
  end
  L2_2 = L2_2(L3_2)
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = A1_2.i
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 1
  end
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 1
  end
  if not L2_2 or L2_2 < 1 or L3_2 < 1 or L3_2 > 64 then
    L4_2 = {}
    L4_2.error = "badchunk"
    return L4_2
  end
  L4_2 = GetCid
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = ""
  end
  L5_2 = MySQL
  L5_2 = L5_2.single
  L5_2 = L5_2.await
  L6_2 = [[
SELECT CHAR_LENGTH(p.image) AS len, SUBSTRING(p.image, ?, ?) AS part
        FROM apex_phone_posts p LEFT JOIN apex_phone_social_accounts a ON a.app = p.app AND a.username = p.author
        WHERE p.id = ? AND (a.id IS NULL OR a.private = 0 OR a.owner = ?
            OR EXISTS (SELECT 1 FROM apex_phone_follows fw JOIN apex_phone_social_accounts mm ON mm.app = p.app AND mm.username = fw.follower
                        WHERE fw.app = p.app AND fw.followed = p.author AND mm.owner = ?))]]
  L7_2 = {}
  L8_2 = L3_2 - 1
  L9_2 = L8_1
  L8_2 = L8_2 * L9_2
  L8_2 = L8_2 + 1
  L9_2 = L8_1
  L10_2 = L2_2
  L11_2 = L4_2
  L12_2 = L4_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L7_2[5] = L12_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L6_2 = {}
    L6_2.error = "notfound"
    return L6_2
  end
  L6_2 = math
  L6_2 = L6_2.tointeger
  L7_2 = tonumber
  L8_2 = L5_2.len
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 0
  end
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  if L6_2 <= 0 then
    L7_2 = {}
    L7_2.i = L3_2
    L7_2.total = 0
    L7_2.len = 0
    L7_2.data = ""
    return L7_2
  end
  L7_2 = {}
  L7_2.i = L3_2
  L8_2 = math
  L8_2 = L8_2.ceil
  L9_2 = L8_1
  L9_2 = L6_2 / L9_2
  L8_2 = L8_2(L9_2)
  L7_2.total = L8_2
  L7_2.len = L6_2
  L8_2 = L5_2.part
  if not L8_2 then
    L8_2 = ""
  end
  L7_2.data = L8_2
  return L7_2
end
L15_1["social.post.media"] = L16_1
L15_1 = RPC
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT id, app, username, bio, avatar, created, name, website, private, avatar_url FROM apex_phone_social_accounts WHERE app = ? AND owner = ?"
  L4_2 = {}
  L5_2 = A1_2.app
  L6_2 = GetCid
  L7_2 = A0_2
  L6_2, L7_2 = L6_2(L7_2)
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  return L2_2(L3_2, L4_2)
end
L15_1["social.profile"] = L16_1
L15_1 = RPC
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = tostring
  L3_2 = A1_2.username
  if not L3_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.lower
  L2_2 = L2_2(L3_2)
  L4_2 = L2_2
  L3_2 = L2_2.match
  L5_2 = "^[a-z0-9_%.]+$"
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L3_2 = #L2_2
    if not (L3_2 < 3) then
      L3_2 = #L2_2
      if not (L3_2 > 16) then
        goto lbl_24
      end
    end
  end
  L3_2 = {}
  L3_2.error = "invalid"
  do return L3_2 end
  ::lbl_24::
  L3_2 = L2_1
  L4_2 = A1_2.app
  L5_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L3_2 = {}
    L3_2.error = "taken"
    return L3_2
  end
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT id FROM apex_phone_social_accounts WHERE app = ? AND owner = ?"
  L6_2 = {}
  L7_2 = A1_2.app
  L8_2 = L3_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L4_2 = {}
    L4_2.error = "exists"
    return L4_2
  end
  L4_2 = Now
  L4_2 = L4_2()
  L5_2 = MySQL
  L5_2 = L5_2.insert
  L5_2 = L5_2.await
  L6_2 = "INSERT INTO apex_phone_social_accounts (app, owner, username, bio, avatar, created) VALUES (?, ?, ?, ?, ?, ?)"
  L7_2 = {}
  L8_2 = A1_2.app
  L9_2 = L3_2
  L10_2 = L2_2
  L11_2 = tostring
  L12_2 = A1_2.bio
  if not L12_2 then
    L12_2 = ""
  end
  L11_2 = L11_2(L12_2)
  L12_2 = L11_2
  L11_2 = L11_2.sub
  L13_2 = 1
  L14_2 = 160
  L11_2 = L11_2(L12_2, L13_2, L14_2)
  L12_2 = tostring
  L13_2 = A1_2.avatar
  if not L13_2 then
    L13_2 = 1
  end
  L12_2 = L12_2(L13_2)
  L13_2 = L4_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L7_2[5] = L12_2
  L7_2[6] = L13_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = {}
  L6_2.id = L5_2
  L7_2 = A1_2.app
  L6_2.app = L7_2
  L6_2.username = L2_2
  L7_2 = A1_2.bio
  if not L7_2 then
    L7_2 = ""
  end
  L6_2.bio = L7_2
  L7_2 = tonumber
  L8_2 = A1_2.avatar
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 1
  end
  L6_2.avatar = L7_2
  L6_2.created = L4_2
  return L6_2
end
L15_1["social.createProfile"] = L16_1
L15_1 = RPC
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT id, app, username, bio, avatar, created, name, website, private, avatar_url FROM apex_phone_social_accounts WHERE app = ? AND owner = ?"
  L4_2 = {}
  L5_2 = A1_2.app
  L6_2 = GetCid
  L7_2 = A0_2
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2 = L6_2(L7_2)
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L4_2[5] = L9_2
  L4_2[6] = L10_2
  L4_2[7] = L11_2
  L4_2[8] = L12_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noprofile"
    return L3_2
  end
  L3_2 = A1_2.bio
  if nil ~= L3_2 then
    L3_2 = tostring
    L4_2 = A1_2.bio
    L3_2 = L3_2(L4_2)
    L4_2 = L3_2
    L3_2 = L3_2.sub
    L5_2 = 1
    L6_2 = 160
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    L2_2.bio = L3_2
  end
  L3_2 = A1_2.avatar
  if nil ~= L3_2 then
    L3_2 = tostring
    L4_2 = A1_2.avatar
    L3_2 = L3_2(L4_2)
    L2_2.avatar = L3_2
  end
  L3_2 = A1_2.name
  if nil ~= L3_2 then
    L3_2 = tostring
    L4_2 = A1_2.name
    L3_2 = L3_2(L4_2)
    L4_2 = L3_2
    L3_2 = L3_2.sub
    L5_2 = 1
    L6_2 = 40
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    L2_2.name = L3_2
  end
  L3_2 = A1_2.website
  if nil ~= L3_2 then
    L3_2 = tostring
    L4_2 = A1_2.website
    L3_2 = L3_2(L4_2)
    L4_2 = L3_2
    L3_2 = L3_2.sub
    L5_2 = 1
    L6_2 = 90
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    L2_2.website = L3_2
  end
  L3_2 = A1_2.private
  if nil ~= L3_2 then
    L3_2 = A1_2.private
    if L3_2 then
      L3_2 = 1
      if L3_2 then
        goto lbl_69
      end
    end
    L3_2 = 0
    ::lbl_69::
    L2_2.private = L3_2
  end
  L3_2 = A1_2.avatarUrl
  if nil ~= L3_2 then
    L3_2 = tostring
    L4_2 = A1_2.avatarUrl
    L3_2 = L3_2(L4_2)
    if "" == L3_2 then
      L2_2.avatar_url = nil
    else
      L4_2 = #L3_2
      L5_2 = 20000
      if L4_2 > L5_2 then
        L4_2 = {}
        L4_2.error = "toolarge"
        return L4_2
      else
        L2_2.avatar_url = L3_2
      end
    end
  end
  L3_2 = A1_2.username
  if nil ~= L3_2 then
    L3_2 = tostring
    L4_2 = A1_2.username
    L3_2 = L3_2(L4_2)
    L4_2 = L3_2
    L3_2 = L3_2.lower
    L3_2 = L3_2(L4_2)
    L4_2 = L2_2.username
    if L3_2 ~= L4_2 then
      L5_2 = L3_2
      L4_2 = L3_2.match
      L6_2 = "^[a-z0-9_%.]+$"
      L4_2 = L4_2(L5_2, L6_2)
      if L4_2 then
        L4_2 = #L3_2
        if not (L4_2 < 3) then
          L4_2 = #L3_2
          if not (L4_2 > 16) then
            goto lbl_116
          end
        end
      end
      L4_2 = {}
      L4_2.error = "invalid"
      do return L4_2 end
      ::lbl_116::
      L4_2 = L2_1
      L5_2 = A1_2.app
      L6_2 = L3_2
      L4_2 = L4_2(L5_2, L6_2)
      if L4_2 then
        L4_2 = {}
        L4_2.error = "taken"
        return L4_2
      end
      L4_2 = L2_2.username
      L5_2 = MySQL
      L5_2 = L5_2.update
      L5_2 = L5_2.await
      L6_2 = "UPDATE apex_phone_social_accounts SET username = ? WHERE id = ?"
      L7_2 = {}
      L8_2 = L3_2
      L9_2 = L2_2.id
      L7_2[1] = L8_2
      L7_2[2] = L9_2
      L5_2(L6_2, L7_2)
      L5_2 = MySQL
      L5_2 = L5_2.update
      L6_2 = "UPDATE apex_phone_posts SET author = ? WHERE app = ? AND author = ?"
      L7_2 = {}
      L8_2 = L3_2
      L9_2 = A1_2.app
      L10_2 = L4_2
      L7_2[1] = L8_2
      L7_2[2] = L9_2
      L7_2[3] = L10_2
      L5_2(L6_2, L7_2)
      L5_2 = MySQL
      L5_2 = L5_2.update
      L6_2 = "UPDATE apex_phone_stories SET author = ? WHERE app = ? AND author = ?"
      L7_2 = {}
      L8_2 = L3_2
      L9_2 = A1_2.app
      L10_2 = L4_2
      L7_2[1] = L8_2
      L7_2[2] = L9_2
      L7_2[3] = L10_2
      L5_2(L6_2, L7_2)
      L5_2 = MySQL
      L5_2 = L5_2.update
      L6_2 = "UPDATE apex_phone_follows SET follower = ? WHERE app = ? AND follower = ?"
      L7_2 = {}
      L8_2 = L3_2
      L9_2 = A1_2.app
      L10_2 = L4_2
      L7_2[1] = L8_2
      L7_2[2] = L9_2
      L7_2[3] = L10_2
      L5_2(L6_2, L7_2)
      L5_2 = MySQL
      L5_2 = L5_2.update
      L6_2 = "UPDATE apex_phone_follows SET followed = ? WHERE app = ? AND followed = ?"
      L7_2 = {}
      L8_2 = L3_2
      L9_2 = A1_2.app
      L10_2 = L4_2
      L7_2[1] = L8_2
      L7_2[2] = L9_2
      L7_2[3] = L10_2
      L5_2(L6_2, L7_2)
      L5_2 = MySQL
      L5_2 = L5_2.update
      L6_2 = "UPDATE apex_phone_saves SET username = ? WHERE app = ? AND username = ?"
      L7_2 = {}
      L8_2 = L3_2
      L9_2 = A1_2.app
      L10_2 = L4_2
      L7_2[1] = L8_2
      L7_2[2] = L9_2
      L7_2[3] = L10_2
      L5_2(L6_2, L7_2)
      L5_2 = MySQL
      L5_2 = L5_2.update
      L6_2 = "UPDATE apex_phone_comments SET username = ? WHERE username = ?"
      L7_2 = {}
      L8_2 = L3_2
      L9_2 = L4_2
      L7_2[1] = L8_2
      L7_2[2] = L9_2
      L5_2(L6_2, L7_2)
      L5_2 = MySQL
      L5_2 = L5_2.update
      L6_2 = "UPDATE apex_phone_close_friends SET owner = ? WHERE app = ? AND owner = ?"
      L7_2 = {}
      L8_2 = L3_2
      L9_2 = A1_2.app
      L10_2 = L4_2
      L7_2[1] = L8_2
      L7_2[2] = L9_2
      L7_2[3] = L10_2
      L5_2(L6_2, L7_2)
      L5_2 = MySQL
      L5_2 = L5_2.update
      L6_2 = "UPDATE apex_phone_close_friends SET friend = ? WHERE app = ? AND friend = ?"
      L7_2 = {}
      L8_2 = L3_2
      L9_2 = A1_2.app
      L10_2 = L4_2
      L7_2[1] = L8_2
      L7_2[2] = L9_2
      L7_2[3] = L10_2
      L5_2(L6_2, L7_2)
      L5_2 = MySQL
      L5_2 = L5_2.update
      L6_2 = "UPDATE apex_phone_story_views SET username = ? WHERE username = ?"
      L7_2 = {}
      L8_2 = L3_2
      L9_2 = L4_2
      L7_2[1] = L8_2
      L7_2[2] = L9_2
      L5_2(L6_2, L7_2)
      L5_2 = MySQL
      L5_2 = L5_2.update
      L6_2 = "UPDATE apex_phone_story_answers SET username = ? WHERE username = ?"
      L7_2 = {}
      L8_2 = L3_2
      L9_2 = L4_2
      L7_2[1] = L8_2
      L7_2[2] = L9_2
      L5_2(L6_2, L7_2)
      L5_2 = MySQL
      L5_2 = L5_2.update
      L6_2 = "UPDATE apex_phone_instants SET author = ? WHERE app = ? AND author = ?"
      L7_2 = {}
      L8_2 = L3_2
      L9_2 = A1_2.app
      L10_2 = L4_2
      L7_2[1] = L8_2
      L7_2[2] = L9_2
      L7_2[3] = L10_2
      L5_2(L6_2, L7_2)
      L5_2 = MySQL
      L5_2 = L5_2.update
      L6_2 = [[
UPDATE apex_phone_instant_views v JOIN apex_phone_instants i ON i.id = v.instant_id
                SET v.username = ? WHERE v.username = ? AND i.app = ?]]
      L7_2 = {}
      L8_2 = L3_2
      L9_2 = L4_2
      L10_2 = A1_2.app
      L7_2[1] = L8_2
      L7_2[2] = L9_2
      L7_2[3] = L10_2
      L5_2(L6_2, L7_2)
      L2_2.username = L3_2
    end
  end
  L3_2 = MySQL
  L3_2 = L3_2.update
  L4_2 = "UPDATE apex_phone_social_accounts SET bio = ?, avatar = ?, name = ?, website = ?, private = ?, avatar_url = ? WHERE id = ?"
  L5_2 = {}
  L6_2 = L2_2.bio
  L7_2 = L2_2.avatar
  L8_2 = L2_2.name
  L9_2 = L2_2.website
  L10_2 = L2_2.private
  if not L10_2 then
    L10_2 = 0
  end
  L11_2 = L2_2.avatar_url
  L12_2 = L2_2.id
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L5_2[5] = L10_2
  L5_2[6] = L11_2
  L5_2[7] = L12_2
  L3_2(L4_2, L5_2)
  L3_2 = tonumber
  L4_2 = L2_2.avatar
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = L2_2.avatar
  end
  L2_2.avatar = L3_2
  L3_2 = tonumber
  L4_2 = L2_2.private
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 0
  end
  L3_2 = 1 == L3_2
  L2_2.private = L3_2
  return L2_2
end
L15_1["social.updateProfile"] = L16_1
L15_1 = RPC
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2
  L2_2 = A1_2.app
  L3_2 = L0_1
  L4_2 = A0_2
  L5_2 = A1_2.app
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = tonumber
  L5_2 = A1_2.before
  L4_2 = L4_2(L5_2)
  L5_2 = math
  L5_2 = L5_2.floor
  L6_2 = tonumber
  L7_2 = A1_2.limit
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 60
  end
  L5_2 = L5_2(L6_2)
  if L5_2 < 5 then
    L5_2 = 5
  elseif L5_2 > 60 then
    L5_2 = 60
  end
  if L4_2 then
    L6_2 = " AND created < ?"
    if L6_2 then
      goto lbl_31
    end
  end
  L6_2 = ""
  ::lbl_31::
  L7_2 = L4_1
  L7_2 = L7_2()
  L8_2 = {}
  L9_2 = L3_2 or L9_2
  if not L3_2 then
    L9_2 = ""
  end
  L10_2 = L3_2 or L10_2
  if not L3_2 then
    L10_2 = ""
  end
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L9_2 = nil
  L10_2 = A1_2.mode
  if "home" == L10_2 and L3_2 then
    L10_2 = MySQL
    L10_2 = L10_2.query
    L10_2 = L10_2.await
    L11_2 = "SELECT followed FROM apex_phone_follows WHERE app = ? AND follower = ?"
    L12_2 = {}
    L13_2 = L2_2
    L14_2 = L3_2
    L12_2[1] = L13_2
    L12_2[2] = L14_2
    L10_2 = L10_2(L11_2, L12_2)
    if not L10_2 then
      L10_2 = {}
    end
    L11_2 = {}
    L12_2 = L3_2
    L11_2[1] = L12_2
    L12_2 = ipairs
    L13_2 = L10_2
    L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
    for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
      L18_2 = #L11_2
      L18_2 = L18_2 + 1
      L19_2 = L17_2.followed
      L11_2[L18_2] = L19_2
    end
    L12_2 = #L10_2
    if 0 == L12_2 then
      L12_2 = {}
      L13_2 = L2_2
      L12_2[1] = L13_2
      if L4_2 then
        L13_2 = #L12_2
        L13_2 = L13_2 + 1
        L12_2[L13_2] = L4_2
      end
      L13_2 = #L12_2
      L13_2 = L13_2 + 1
      L14_2 = L8_2[1]
      L12_2[L13_2] = L14_2
      L13_2 = #L12_2
      L13_2 = L13_2 + 1
      L14_2 = L8_2[2]
      L12_2[L13_2] = L14_2
      L13_2 = MySQL
      L13_2 = L13_2.query
      L13_2 = L13_2.await
      L14_2 = "SELECT "
      L15_2 = L11_1
      L16_2 = " FROM apex_phone_posts WHERE app = ? AND reply_to IS NULL"
      L17_2 = L6_2
      L18_2 = L7_2
      L19_2 = " ORDER BY created DESC LIMIT "
      L20_2 = L5_2
      L14_2 = L14_2 .. L15_2 .. L16_2 .. L17_2 .. L18_2 .. L19_2 .. L20_2
      L15_2 = L12_2
      L13_2 = L13_2(L14_2, L15_2)
      L9_2 = L13_2
    else
      L12_2 = {}
      L13_2 = 1
      L14_2 = #L11_2
      L15_2 = 1
      for L16_2 = L13_2, L14_2, L15_2 do
        L12_2[L16_2] = "?"
      end
      L13_2 = {}
      L14_2 = L2_2
      L13_2[1] = L14_2
      L14_2 = ipairs
      L15_2 = L11_2
      L14_2, L15_2, L16_2, L17_2 = L14_2(L15_2)
      for L18_2, L19_2 in L14_2, L15_2, L16_2, L17_2 do
        L20_2 = #L13_2
        L20_2 = L20_2 + 1
        L13_2[L20_2] = L19_2
      end
      if L4_2 then
        L14_2 = #L13_2
        L14_2 = L14_2 + 1
        L13_2[L14_2] = L4_2
      end
      L14_2 = MySQL
      L14_2 = L14_2.query
      L14_2 = L14_2.await
      L15_2 = "SELECT "
      L16_2 = L11_1
      L17_2 = " FROM apex_phone_posts WHERE app = ? AND reply_to IS NULL AND author IN ("
      L18_2 = table
      L18_2 = L18_2.concat
      L19_2 = L12_2
      L20_2 = ","
      L18_2 = L18_2(L19_2, L20_2)
      L19_2 = ")"
      L20_2 = L6_2
      L21_2 = " ORDER BY created DESC LIMIT "
      L22_2 = L5_2
      L15_2 = L15_2 .. L16_2 .. L17_2 .. L18_2 .. L19_2 .. L20_2 .. L21_2 .. L22_2
      L16_2 = L13_2
      L14_2 = L14_2(L15_2, L16_2)
      L9_2 = L14_2
    end
  else
    L10_2 = A1_2.mode
    if "user" == L10_2 then
      L10_2 = tostring
      L11_2 = A1_2.ref
      if not L11_2 then
        L11_2 = ""
      end
      L10_2 = L10_2(L11_2)
      L11_2 = L3_1
      L12_2 = L2_2
      L13_2 = L3_2
      L14_2 = L10_2
      L11_2 = L11_2(L12_2, L13_2, L14_2)
      if not L11_2 then
        L11_2 = {}
        return L11_2
      end
      L11_2 = {}
      L12_2 = L2_2
      L13_2 = L10_2
      L11_2[1] = L12_2
      L11_2[2] = L13_2
      if L4_2 then
        L12_2 = #L11_2
        L12_2 = L12_2 + 1
        L11_2[L12_2] = L4_2
      end
      L12_2 = MySQL
      L12_2 = L12_2.query
      L12_2 = L12_2.await
      L13_2 = "SELECT "
      L14_2 = L11_1
      L15_2 = " FROM apex_phone_posts WHERE app = ? AND reply_to IS NULL AND author = ?"
      L16_2 = L6_2
      L17_2 = " ORDER BY created DESC LIMIT "
      L18_2 = L5_2
      L13_2 = L13_2 .. L14_2 .. L15_2 .. L16_2 .. L17_2 .. L18_2
      L14_2 = L11_2
      L12_2 = L12_2(L13_2, L14_2)
      L9_2 = L12_2
    else
      L10_2 = A1_2.mode
      if "hashtag" == L10_2 then
        L10_2 = {}
        L11_2 = L2_2
        L12_2 = "%#"
        L13_2 = tostring
        L14_2 = A1_2.ref
        if not L14_2 then
          L14_2 = ""
        end
        L13_2 = L13_2(L14_2)
        L14_2 = "%"
        L12_2 = L12_2 .. L13_2 .. L14_2
        L10_2[1] = L11_2
        L10_2[2] = L12_2
        if L4_2 then
          L11_2 = #L10_2
          L11_2 = L11_2 + 1
          L10_2[L11_2] = L4_2
        end
        L11_2 = #L10_2
        L11_2 = L11_2 + 1
        L12_2 = L8_2[1]
        L10_2[L11_2] = L12_2
        L11_2 = #L10_2
        L11_2 = L11_2 + 1
        L12_2 = L8_2[2]
        L10_2[L11_2] = L12_2
        L11_2 = MySQL
        L11_2 = L11_2.query
        L11_2 = L11_2.await
        L12_2 = "SELECT "
        L13_2 = L11_1
        L14_2 = " FROM apex_phone_posts WHERE app = ? AND reply_to IS NULL AND content LIKE ?"
        L15_2 = L6_2
        L16_2 = L7_2
        L17_2 = " ORDER BY created DESC LIMIT "
        L18_2 = L5_2
        L12_2 = L12_2 .. L13_2 .. L14_2 .. L15_2 .. L16_2 .. L17_2 .. L18_2
        L13_2 = L10_2
        L11_2 = L11_2(L12_2, L13_2)
        L9_2 = L11_2
      else
        L10_2 = {}
        L11_2 = L2_2
        L10_2[1] = L11_2
        if L4_2 then
          L11_2 = #L10_2
          L11_2 = L11_2 + 1
          L10_2[L11_2] = L4_2
        end
        L11_2 = #L10_2
        L11_2 = L11_2 + 1
        L12_2 = L8_2[1]
        L10_2[L11_2] = L12_2
        L11_2 = #L10_2
        L11_2 = L11_2 + 1
        L12_2 = L8_2[2]
        L10_2[L11_2] = L12_2
        L11_2 = MySQL
        L11_2 = L11_2.query
        L11_2 = L11_2.await
        L12_2 = "SELECT "
        L13_2 = L11_1
        L14_2 = " FROM apex_phone_posts WHERE app = ? AND reply_to IS NULL"
        L15_2 = L6_2
        L16_2 = L7_2
        L17_2 = " ORDER BY created DESC LIMIT "
        L18_2 = L5_2
        L12_2 = L12_2 .. L13_2 .. L14_2 .. L15_2 .. L16_2 .. L17_2 .. L18_2
        L13_2 = L10_2
        L11_2 = L11_2(L12_2, L13_2)
        L9_2 = L11_2
      end
    end
  end
  L10_2 = L14_1
  L11_2 = L2_2
  L12_2 = L9_2 or L12_2
  if not L9_2 then
    L12_2 = {}
  end
  L13_2 = L3_2
  return L10_2(L11_2, L12_2, L13_2)
end
L15_1["social.feed"] = L16_1
L15_1 = RPC
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT author FROM apex_phone_posts WHERE id = ?"
  L5_2 = {}
  L6_2 = A1_2.postId
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L3_1
    L5_2 = A1_2.app
    L6_2 = L2_2
    L7_2 = L3_2.author
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    if not L4_2 then
      L4_2 = {}
      return L4_2
    end
  end
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "SELECT "
  L6_2 = L11_1
  L7_2 = " FROM apex_phone_posts WHERE app = ? AND reply_to = ? ORDER BY created ASC LIMIT 100"
  L5_2 = L5_2 .. L6_2 .. L7_2
  L6_2 = {}
  L7_2 = A1_2.app
  L8_2 = A1_2.postId
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L5_2 = L14_1
  L6_2 = A1_2.app
  L7_2 = L4_2
  L8_2 = L2_2
  return L5_2(L6_2, L7_2, L8_2)
end
L15_1["social.replies"] = L16_1
function L15_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = tostring
  L3_2 = A0_2 or L3_2
  if not A0_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = utf8
  L3_2 = L3_2.len
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = {}
    L5_2 = L2_2
    L4_2 = L2_2.gmatch
    L6_2 = utf8
    L6_2 = L6_2.charpattern
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2)
    for L8_2 in L4_2, L5_2, L6_2, L7_2 do
      L9_2 = utf8
      L9_2 = L9_2.len
      L10_2 = L8_2
      L9_2 = L9_2(L10_2)
      if L9_2 then
        L9_2 = #L3_2
        L9_2 = L9_2 + 1
        L3_2[L9_2] = L8_2
      end
    end
    L4_2 = table
    L4_2 = L4_2.concat
    L5_2 = L3_2
    L4_2 = L4_2(L5_2)
    L2_2 = L4_2
  end
  L3_2 = utf8
  L3_2 = L3_2.len
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 0
  end
  if A1_2 < L3_2 then
    L5_2 = L2_2
    L4_2 = L2_2.sub
    L6_2 = 1
    L7_2 = utf8
    L7_2 = L7_2.offset
    L8_2 = L2_2
    L9_2 = A1_2 + 1
    L7_2 = L7_2(L8_2, L9_2)
    L7_2 = L7_2 - 1
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L2_2 = L4_2
  end
  return L2_2
end
function L16_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = {}
  L3_2 = utf8
  L3_2 = L3_2.codes
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    if L8_2 <= A1_2 then
      L9_2 = #L2_2
      L9_2 = L9_2 + 1
      L10_2 = utf8
      L10_2 = L10_2.char
      L11_2 = L8_2
      L10_2 = L10_2(L11_2)
      L2_2[L9_2] = L10_2
    end
  end
  L3_2 = table
  L3_2 = L3_2.concat
  L4_2 = L2_2
  return L3_2(L4_2)
end
L17_1 = false
function L18_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L1_2 = "INSERT INTO apex_phone_posts (app, author, content, image, reply_to, repost_of, created) VALUES (?, ?, ?, ?, ?, ?, ?)"
  L2_2 = pcall
  L3_2 = MySQL
  L3_2 = L3_2.insert
  L3_2 = L3_2.await
  L4_2 = L1_2
  L5_2 = A0_2
  L2_2, L3_2 = L2_2(L3_2, L4_2, L5_2)
  if L2_2 then
    return L3_2
  end
  L4_2 = tostring
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  L6_2 = L4_2
  L5_2 = L4_2.find
  L7_2 = "Incorrect string value"
  L8_2 = 1
  L9_2 = true
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  if not L5_2 then
    L5_2 = error
    L6_2 = L4_2
    L7_2 = 0
    L5_2(L6_2, L7_2)
  end
  L5_2 = ipairs
  L6_2 = {}
  L7_2 = 65535
  L8_2 = 255
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = {}
    L12_2 = A0_2[1]
    L13_2 = A0_2[2]
    L14_2 = L16_1
    L15_2 = A0_2[3]
    L16_2 = L10_2
    L14_2 = L14_2(L15_2, L16_2)
    L15_2 = A0_2[4]
    L16_2 = A0_2[5]
    L17_2 = A0_2[6]
    L18_2 = A0_2[7]
    L11_2[1] = L12_2
    L11_2[2] = L13_2
    L11_2[3] = L14_2
    L11_2[4] = L15_2
    L11_2[5] = L16_2
    L11_2[6] = L17_2
    L11_2[7] = L18_2
    L12_2 = pcall
    L13_2 = MySQL
    L13_2 = L13_2.insert
    L13_2 = L13_2.await
    L14_2 = L1_2
    L15_2 = L11_2
    L12_2, L13_2 = L12_2(L13_2, L14_2, L15_2)
    if L12_2 then
      L14_2 = L17_1
      if not L14_2 then
        L14_2 = true
        L17_1 = L14_2
        L14_2 = print
        L15_2 = "^3[unique_phone]^0 apex_phone_posts is not utf8mb4: posts are saved without emojis/special characters. Fix it while the server is empty:"
        L14_2(L15_2)
        L14_2 = print
        L15_2 = "^3[unique_phone]^0   ALTER TABLE `apex_phone_posts` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
        L14_2(L15_2)
      end
      return L13_2
    end
  end
  L5_2 = error
  L6_2 = L4_2
  L7_2 = 0
  L5_2(L6_2, L7_2)
end
L19_1 = 48000
function L20_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = tostring
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L3_2 = L1_2
  L2_2 = L1_2.match
  L4_2 = "^%d+$"
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L2_2 = #L1_2
    if L2_2 <= 12 then
      L2_2 = L1_2
      L3_2 = true
      return L2_2, L3_2
    end
  end
  L2_2 = #L1_2
  L3_2 = L19_1
  if L2_2 > L3_2 then
    L2_2 = nil
    L3_2 = false
    L4_2 = "toolarge"
    return L2_2, L3_2, L4_2
  end
  L2_2 = CleanPhotoUrl
  if L2_2 then
    L2_2 = CleanPhotoUrl
    L3_2 = L1_2
    L4_2 = false
    return L2_2(L3_2, L4_2)
  end
  L3_2 = L1_2
  L2_2 = L1_2.match
  L4_2 = "^data:([%w]+/[%w%.%+%-]+);base64,"
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L3_2 = {}
    L3_2["image/jpeg"] = true
    L3_2["image/jpg"] = true
    L3_2["image/png"] = true
    L3_2["image/webp"] = true
    L3_2["image/gif"] = true
    L4_2 = L3_2[L2_2]
    L4_2 = L1_2 or L4_2
    if not L4_2 or not L1_2 then
      L4_2 = nil
    end
    L5_2 = L3_2[L2_2]
    L5_2 = true == L5_2
    return L4_2, L5_2
  end
  L3_2 = #L1_2
  L4_2 = 512
  if L3_2 <= L4_2 then
    L4_2 = L1_2
    L3_2 = L1_2.match
    L5_2 = "^https?://"
    L3_2 = L3_2(L4_2, L5_2)
    if L3_2 then
      L4_2 = L1_2
      L3_2 = L1_2.find
      L5_2 = "[%s\"'<>\\]"
      L3_2 = L3_2(L4_2, L5_2)
      if not L3_2 then
        L3_2 = L1_2
        L4_2 = true
        return L3_2, L4_2
      end
    end
  end
  L3_2 = nil
  L4_2 = false
  return L3_2, L4_2
end
L21_1 = RPC
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noprofile"
    return L3_2
  end
  L3_2 = Now
  L3_2 = L3_2()
  L4_2 = nil
  L5_2 = math
  L5_2 = L5_2.tointeger
  L6_2 = tonumber
  L7_2 = A1_2.photoId
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  if L5_2 > 0 then
    L6_2 = GetCid
    L7_2 = A0_2
    L6_2 = L6_2(L7_2)
    if not L6_2 then
      L7_2 = {}
      L7_2.error = "noplayer"
      return L7_2
    end
    L7_2 = pcall
    L8_2 = MySQL
    L8_2 = L8_2.single
    L8_2 = L8_2.await
    L9_2 = "SELECT url, seed, video FROM apex_phone_photos WHERE id = ? AND owner = ?"
    L10_2 = {}
    L11_2 = L5_2
    L12_2 = L6_2
    L10_2[1] = L11_2
    L10_2[2] = L12_2
    L7_2, L8_2 = L7_2(L8_2, L9_2, L10_2)
    if not L7_2 then
      L9_2 = {}
      L9_2.error = "db"
      return L9_2
    end
    if not L8_2 then
      L9_2 = {}
      L9_2.error = "photo"
      return L9_2
    end
    L9_2 = tonumber
    L10_2 = L8_2.video
    L9_2 = L9_2(L10_2)
    if not L9_2 then
      L9_2 = 0
    end
    if 1 == L9_2 then
      L9_2 = {}
      L9_2.error = "video"
      return L9_2
    end
    L9_2 = type
    L10_2 = L8_2.url
    L9_2 = L9_2(L10_2)
    if "string" == L9_2 then
      L9_2 = L8_2.url
      if "" ~= L9_2 then
        L4_2 = L8_2.url
    end
    else
      L9_2 = tonumber
      L10_2 = L8_2.seed
      L9_2 = L9_2(L10_2)
      if L9_2 then
        L9_2 = tostring
        L10_2 = math
        L10_2 = L10_2.tointeger
        L11_2 = tonumber
        L12_2 = L8_2.seed
        L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L11_2(L12_2)
        L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
        if not L10_2 then
          L10_2 = L8_2.seed
        end
        L9_2 = L9_2(L10_2)
        L4_2 = L9_2
      end
    end
  else
    L6_2 = A1_2.image
    if nil ~= L6_2 then
      L6_2 = A1_2.image
      if false ~= L6_2 then
        L6_2 = A1_2.image
        if "" ~= L6_2 then
          L6_2 = L20_1
          L7_2 = A1_2.image
          L6_2, L7_2, L8_2 = L6_2(L7_2)
          if not L7_2 then
            L9_2 = {}
            L10_2 = L8_2 or L10_2
            if not L8_2 then
              L10_2 = "badimage"
            end
            L9_2.error = L10_2
            return L9_2
          end
          L4_2 = L6_2
        end
      end
    end
  end
  L6_2 = math
  L6_2 = L6_2.tointeger
  L7_2 = tonumber
  L8_2 = A1_2.replyTo
  L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L7_2(L8_2)
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  L7_2 = math
  L7_2 = L7_2.tointeger
  L8_2 = tonumber
  L9_2 = A1_2.repostOf
  L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2 = L8_2(L9_2)
  L7_2 = L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2)
  L8_2 = L15_1
  L9_2 = A1_2.content
  L10_2 = 1000
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = L18_1
  L10_2 = {}
  L11_2 = A1_2.app
  L12_2 = L2_2
  L13_2 = L8_2
  L14_2 = L4_2
  L15_2 = L6_2
  L16_2 = L7_2
  L17_2 = L3_2
  L10_2[1] = L11_2
  L10_2[2] = L12_2
  L10_2[3] = L13_2
  L10_2[4] = L14_2
  L10_2[5] = L15_2
  L10_2[6] = L16_2
  L10_2[7] = L17_2
  L9_2 = L9_2(L10_2)
  if L6_2 then
    L10_2 = pcall
    function L11_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
      L0_3 = MySQL
      L0_3 = L0_3.single
      L0_3 = L0_3.await
      L1_3 = "SELECT author FROM apex_phone_posts WHERE id = ?"
      L2_3 = {}
      L3_3 = L6_2
      L2_3[1] = L3_3
      L0_3 = L0_3(L1_3, L2_3)
      if L0_3 then
        L1_3 = L0_3.author
        L2_3 = L2_2
        if L1_3 ~= L2_3 then
          L1_3 = L1_1
          L2_3 = A1_2.app
          L3_3 = L0_3.author
          L1_3 = L1_3(L2_3, L3_3)
          if L1_3 then
            L2_3 = NotifyCitizen
            L3_3 = L1_3.owner
            L4_3 = A1_2.app
            L5_3 = "@"
            L6_3 = L2_2
            L7_3 = " respondeu"
            L5_3 = L5_3 .. L6_3 .. L7_3
            L6_3 = L15_1
            L7_3 = L8_2
            L8_3 = 80
            L6_3 = L6_3(L7_3, L8_3)
            L7_3 = {}
            L7_3.sys = "t"
            L2_3(L3_3, L4_3, L5_3, L6_3, L7_3)
          end
        end
      end
    end
    L10_2(L11_2)
  end
  L10_2 = {}
  L10_2.id = L9_2
  L11_2 = A1_2.app
  L10_2.app = L11_2
  L10_2.author = L2_2
  L10_2.content = L8_2
  L10_2.image = L4_2
  if L4_2 then
    L11_2 = #L4_2
    if L11_2 then
      goto lbl_169
    end
  end
  L11_2 = 0
  ::lbl_169::
  L10_2.image_len = L11_2
  L10_2.reply_to = L6_2
  L10_2.repost_of = L7_2
  L10_2.created = L3_2
  L11_2 = L10_2.image
  if nil ~= L11_2 then
    L11_2 = L10_2.image
    L11_2 = #L11_2
    L12_2 = L9_1
    if L11_2 > L12_2 then
      L10_2.image = nil
    end
  end
  L11_2 = L13_1
  L12_2 = L10_2
  L11_2(L12_2)
  return L10_2
end
L21_1["social.post"] = L22_1
L21_1 = RPC
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noprofile"
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM apex_phone_posts WHERE id = ? AND app = ? AND author = ?"
  L5_2 = {}
  L6_2 = A1_2.postId
  L7_2 = A1_2.app
  L8_2 = L2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2(L4_2, L5_2)
  L3_2 = {}
  L3_2.ok = true
  return L3_2
end
L21_1["social.deletePost"] = L22_1
L21_1 = RPC
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noprofile"
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT post_id FROM apex_phone_likes WHERE post_id = ? AND username = ?"
  L5_2 = {}
  L6_2 = A1_2.postId
  L7_2 = L2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = MySQL
    L4_2 = L4_2.query
    L4_2 = L4_2.await
    L5_2 = "DELETE FROM apex_phone_likes WHERE post_id = ? AND username = ?"
    L6_2 = {}
    L7_2 = A1_2.postId
    L8_2 = L2_2
    L6_2[1] = L7_2
    L6_2[2] = L8_2
    L4_2(L5_2, L6_2)
    L4_2 = {}
    L4_2.liked = false
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.insert
  L4_2 = L4_2.await
  L5_2 = "INSERT IGNORE INTO apex_phone_likes (post_id, username) VALUES (?, ?)"
  L6_2 = {}
  L7_2 = A1_2.postId
  L8_2 = L2_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2(L5_2, L6_2)
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT author FROM apex_phone_posts WHERE id = ?"
  L6_2 = {}
  L7_2 = A1_2.postId
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = L4_2.author
    if L5_2 ~= L2_2 then
      L5_2 = L1_1
      L6_2 = A1_2.app
      L7_2 = L4_2.author
      L5_2 = L5_2(L6_2, L7_2)
      if L5_2 then
        L6_2 = NotifyCitizen
        L7_2 = L5_2.owner
        L8_2 = A1_2.app
        L9_2 = "@"
        L10_2 = L2_2
        L9_2 = L9_2 .. L10_2
        L10_2 = "gostou da tua publica\195\167\195\163o"
        L11_2 = {}
        L11_2.sys = "m"
        L6_2(L7_2, L8_2, L9_2, L10_2, L11_2)
      end
    end
  end
  L5_2 = {}
  L5_2.liked = true
  return L5_2
end
L21_1["social.like"] = L22_1
L21_1 = RPC
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noprofile"
    return L3_2
  end
  L3_2 = Now
  L3_2 = L3_2()
  L4_2 = tonumber
  L5_2 = A1_2.parent
  L4_2 = L4_2(L5_2)
  if L4_2 then
    L5_2 = MySQL
    L5_2 = L5_2.single
    L5_2 = L5_2.await
    L6_2 = "SELECT id, parent FROM apex_phone_comments WHERE id = ?"
    L7_2 = {}
    L8_2 = L4_2
    L7_2[1] = L8_2
    L5_2 = L5_2(L6_2, L7_2)
    if L5_2 then
      L6_2 = tonumber
      L7_2 = L5_2.parent
      L6_2 = L6_2(L7_2)
      if L6_2 then
        goto lbl_38
        L4_2 = L6_2 or L4_2
      end
      L6_2 = L5_2.id
      if L6_2 then
        goto lbl_38
        L4_2 = L6_2 or L4_2
      end
    end
    L4_2 = nil
  end
  ::lbl_38::
  L5_2 = L15_1
  L6_2 = A1_2.content
  L7_2 = 300
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = MySQL
  L6_2 = L6_2.insert
  L6_2 = L6_2.await
  L7_2 = "INSERT INTO apex_phone_comments (post_id, username, content, created, parent) VALUES (?, ?, ?, ?, ?)"
  L8_2 = {}
  L9_2 = A1_2.postId
  L10_2 = L2_2
  L11_2 = L5_2
  L12_2 = L3_2
  L13_2 = L4_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L8_2[5] = L13_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = pcall
  function L8_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3
    L0_3 = MySQL
    L0_3 = L0_3.single
    L0_3 = L0_3.await
    L1_3 = "SELECT author FROM apex_phone_posts WHERE id = ?"
    L2_3 = {}
    L3_3 = A1_2.postId
    L2_3[1] = L3_3
    L0_3 = L0_3(L1_3, L2_3)
    if L0_3 then
      L1_3 = L0_3.author
      L2_3 = L2_2
      if L1_3 ~= L2_3 then
        L1_3 = L1_1
        L2_3 = A1_2.app
        L3_3 = L0_3.author
        L1_3 = L1_3(L2_3, L3_3)
        if L1_3 then
          L2_3 = NotifyCitizen
          L3_3 = L1_3.owner
          L4_3 = A1_2.app
          L5_3 = "@"
          L6_3 = L2_2
          L7_3 = " comentou"
          L5_3 = L5_3 .. L6_3 .. L7_3
          L6_3 = L15_1
          L7_3 = L5_2
          L8_3 = 80
          L6_3 = L6_3(L7_3, L8_3)
          L7_3 = {}
          L7_3.sys = "t"
          L2_3(L3_3, L4_3, L5_3, L6_3, L7_3)
        end
      end
    end
  end
  L7_2(L8_2)
  L7_2 = {}
  L7_2.id = L6_2
  L8_2 = A1_2.postId
  L7_2.post_id = L8_2
  L7_2.username = L2_2
  L7_2.content = L5_2
  L7_2.created = L3_2
  L7_2.parent = L4_2
  return L7_2
end
L21_1["social.comment"] = L22_1
L21_1 = RPC
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT author FROM apex_phone_posts WHERE id = ?"
  L5_2 = {}
  L6_2 = A1_2.postId
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L3_1
    L5_2 = A1_2.app
    L6_2 = L2_2
    L7_2 = L3_2.author
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    if not L4_2 then
      L4_2 = {}
      return L4_2
    end
  end
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "SELECT c.*, a.avatar, a.avatar_url AS avatarUrl, a.name AS fullname FROM apex_phone_comments c LEFT JOIN apex_phone_social_accounts a ON a.app = ? AND a.username = c.username WHERE c.post_id = ? ORDER BY c.created ASC LIMIT 200"
  L6_2 = {}
  L7_2 = A1_2.app
  L8_2 = A1_2.postId
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L5_2 = #L4_2
  if 0 == L5_2 then
    return L4_2
  end
  L5_2 = {}
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L4_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = #L5_2
    L13_2 = L13_2 + 1
    L14_2 = L12_2.id
    L5_2[L13_2] = L14_2
    L13_2 = L12_2.id
    L6_2[L13_2] = L12_2
    L13_2 = tonumber
    L14_2 = L12_2.avatar
    L13_2 = L13_2(L14_2)
    if not L13_2 then
      L13_2 = L12_2.avatar
    end
    L12_2.avatar = L13_2
    L12_2.likes = 0
    L12_2.liked = false
    L13_2 = tonumber
    L14_2 = L12_2.parent
    L13_2 = L13_2(L14_2)
    if not L13_2 then
      L13_2 = nil
    end
    L12_2.parent = L13_2
  end
  L7_2 = MySQL
  L7_2 = L7_2.query
  L7_2 = L7_2.await
  L8_2 = "SELECT comment_id, username FROM apex_phone_comment_likes WHERE comment_id IN ("
  L9_2 = table
  L9_2 = L9_2.concat
  L10_2 = L5_2
  L11_2 = ","
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = ")"
  L8_2 = L8_2 .. L9_2 .. L10_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = {}
  end
  L8_2 = ipairs
  L9_2 = L7_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L13_2.comment_id
    L14_2 = L6_2[L14_2]
    if L14_2 then
      L15_2 = L14_2.likes
      L15_2 = L15_2 + 1
      L14_2.likes = L15_2
      L15_2 = L13_2.username
      if L15_2 == L2_2 then
        L14_2.liked = true
      end
    end
  end
  L8_2 = L3_2 or L8_2
  if L3_2 then
    L8_2 = L3_2.author
  end
  L9_2 = ipairs
  L10_2 = L4_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = nil ~= L2_2
    L14_2.canDelete = L15_2
  end
  L9_2 = {}
  L10_2 = ipairs
  L11_2 = L4_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = L15_2.avatarUrl
    if nil ~= L16_2 then
      L16_2 = tostring
      L17_2 = L15_2.username
      L16_2 = L16_2(L17_2)
      L17_2 = L16_2
      L16_2 = L16_2.lower
      L16_2 = L16_2(L17_2)
      L17_2 = L9_2[L16_2]
      if L17_2 then
        L15_2.avatarUrl = nil
      else
        L9_2[L16_2] = true
      end
    end
  end
  return L4_2
end
L21_1["social.comments"] = L22_1
L21_1 = RPC
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noprofile"
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT username FROM apex_phone_comment_likes WHERE comment_id = ? AND username = ?"
  L5_2 = {}
  L6_2 = A1_2.id
  L7_2 = L2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = MySQL
    L4_2 = L4_2.query
    L4_2 = L4_2.await
    L5_2 = "DELETE FROM apex_phone_comment_likes WHERE comment_id = ? AND username = ?"
    L6_2 = {}
    L7_2 = A1_2.id
    L8_2 = L2_2
    L6_2[1] = L7_2
    L6_2[2] = L8_2
    L4_2(L5_2, L6_2)
    L4_2 = {}
    L4_2.liked = false
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.insert
  L4_2 = L4_2.await
  L5_2 = "INSERT IGNORE INTO apex_phone_comment_likes (comment_id, username) VALUES (?, ?)"
  L6_2 = {}
  L7_2 = A1_2.id
  L8_2 = L2_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2(L5_2, L6_2)
  L4_2 = {}
  L4_2.liked = true
  return L4_2
end
L21_1["social.comment.like"] = L22_1
L21_1 = RPC
function L22_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noprofile"
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT post_id, username FROM apex_phone_comments WHERE id = ?"
  L5_2 = {}
  L6_2 = A1_2.id
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "gone"
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT author FROM apex_phone_posts WHERE id = ?"
  L6_2 = {}
  L7_2 = L3_2.post_id
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = L3_2.username
  if L5_2 ~= L2_2 then
    if L4_2 then
      L5_2 = L4_2.author
      if L5_2 == L2_2 then
        goto lbl_47
      end
    end
    L5_2 = {}
    L5_2.error = "forbidden"
    return L5_2
  end
  ::lbl_47::
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "DELETE FROM apex_phone_comments WHERE id = ? OR parent = ?"
  L7_2 = {}
  L8_2 = A1_2.id
  L9_2 = A1_2.id
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2(L6_2, L7_2)
  L5_2 = MySQL
  L5_2 = L5_2.query
  L6_2 = "DELETE FROM apex_phone_comment_likes WHERE comment_id = ?"
  L7_2 = {}
  L8_2 = A1_2.id
  L7_2[1] = L8_2
  L5_2(L6_2, L7_2)
  L5_2 = {}
  L5_2.ok = true
  return L5_2
end
L21_1["social.comment.delete"] = L22_1
function L21_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L3_2 = #A1_2
  if 0 == L3_2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = L6_1
  L4_2 = A0_2
  L5_2 = A1_2
  L6_2 = "username, name, bio, avatar, avatar_url"
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = {}
  if nil ~= A2_2 then
    L5_2 = {}
    L6_2 = {}
    L7_2 = A0_2
    L8_2 = A2_2
    L6_2[1] = L7_2
    L6_2[2] = L8_2
    L7_2 = ipairs
    L8_2 = A1_2
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      L5_2[L11_2] = "?"
      L13_2 = #L6_2
      L13_2 = L13_2 + 1
      L6_2[L13_2] = L12_2
    end
    L7_2 = ipairs
    L8_2 = MySQL
    L8_2 = L8_2.query
    L8_2 = L8_2.await
    L9_2 = "SELECT followed FROM apex_phone_follows WHERE app = ? AND follower = ? AND followed IN ("
    L10_2 = table
    L10_2 = L10_2.concat
    L11_2 = L5_2
    L12_2 = ","
    L10_2 = L10_2(L11_2, L12_2)
    L11_2 = ")"
    L9_2 = L9_2 .. L10_2 .. L11_2
    L10_2 = L6_2
    L8_2 = L8_2(L9_2, L10_2)
    if not L8_2 then
      L8_2 = {}
    end
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      L13_2 = tostring
      L14_2 = L12_2.followed
      L13_2 = L13_2(L14_2)
      L14_2 = L13_2
      L13_2 = L13_2.lower
      L13_2 = L13_2(L14_2)
      L4_2[L13_2] = true
    end
  end
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = A1_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L7_1
    L13_2 = L3_2
    L14_2 = L11_2
    L12_2 = L12_2(L13_2, L14_2)
    L13_2 = #L5_2
    L13_2 = L13_2 + 1
    L14_2 = {}
    L14_2.username = L11_2
    if L12_2 then
      L15_2 = L12_2.name
      if L15_2 then
        goto lbl_86
      end
    end
    L15_2 = nil
    ::lbl_86::
    L14_2.name = L15_2
    if L12_2 then
      L15_2 = L12_2.bio
      if L15_2 then
        goto lbl_93
      end
    end
    L15_2 = nil
    ::lbl_93::
    L14_2.bio = L15_2
    if L12_2 then
      L15_2 = tonumber
      L16_2 = L12_2.avatar
      L15_2 = L15_2(L16_2)
      if L15_2 then
        goto lbl_105
      end
      L15_2 = L12_2.avatar
      if L15_2 then
        goto lbl_105
      end
    end
    L15_2 = 1
    ::lbl_105::
    L14_2.avatar = L15_2
    if L12_2 then
      L15_2 = L12_2.avatar_url
      if L15_2 then
        goto lbl_112
      end
    end
    L15_2 = nil
    ::lbl_112::
    L14_2.avatarUrl = L15_2
    L15_2 = nil ~= A2_2
    L14_2.isFollowing = L15_2
    L15_2 = L11_2 == A2_2
    L14_2.me = L15_2
    L5_2[L13_2] = L14_2
  end
  return L5_2
end
L22_1 = RPC
function L23_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT author FROM apex_phone_posts WHERE id = ?"
  L5_2 = {}
  L6_2 = A1_2.postId
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L3_1
    L5_2 = A1_2.app
    L6_2 = L2_2
    L7_2 = L3_2.author
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    if not L4_2 then
      L4_2 = {}
      return L4_2
    end
  end
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "SELECT username FROM apex_phone_likes WHERE post_id = ? ORDER BY username ASC LIMIT 200"
  L6_2 = {}
  L7_2 = A1_2.postId
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L4_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = #L5_2
    L12_2 = L12_2 + 1
    L13_2 = L11_2.username
    L5_2[L12_2] = L13_2
  end
  L6_2 = L21_1
  L7_2 = A1_2.app
  L8_2 = L5_2
  L9_2 = L2_2
  return L6_2(L7_2, L8_2, L9_2)
end
L22_1["social.likers"] = L23_1
L22_1 = RPC
function L23_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = L3_1
  L4_2 = A1_2.app
  L5_2 = L2_2
  L6_2 = tostring
  L7_2 = A1_2.username
  if not L7_2 then
    L7_2 = ""
  end
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L6_2(L7_2)
  L3_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
  if not L3_2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = A1_2.mode
  if "following" == L3_2 then
    L3_2 = "followed"
    if L3_2 then
      goto lbl_27
    end
  end
  L3_2 = "follower"
  ::lbl_27::
  L4_2 = A1_2.mode
  if "following" == L4_2 then
    L4_2 = "follower"
    if L4_2 then
      goto lbl_34
    end
  end
  L4_2 = "followed"
  ::lbl_34::
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "SELECT %s AS u FROM apex_phone_follows WHERE app = ? AND %s = ? LIMIT 300"
  L7_2 = L6_2
  L6_2 = L6_2.format
  L8_2 = L3_2
  L9_2 = L4_2
  L6_2 = L6_2(L7_2, L8_2, L9_2)
  L7_2 = {}
  L8_2 = A1_2.app
  L9_2 = A1_2.username
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
  end
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L5_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = #L6_2
    L13_2 = L13_2 + 1
    L14_2 = L12_2.u
    L6_2[L13_2] = L14_2
  end
  L7_2 = L21_1
  L8_2 = A1_2.app
  L9_2 = L6_2
  L10_2 = L0_1
  L11_2 = A0_2
  L12_2 = A1_2.app
  L10_2, L11_2, L12_2, L13_2, L14_2 = L10_2(L11_2, L12_2)
  return L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
end
L22_1["social.followers"] = L23_1
L22_1 = RPC
function L23_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noprofile"
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT post_id FROM apex_phone_saves WHERE app = ? AND username = ? AND post_id = ?"
  L5_2 = {}
  L6_2 = A1_2.app
  L7_2 = L2_2
  L8_2 = A1_2.postId
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = MySQL
    L4_2 = L4_2.query
    L4_2 = L4_2.await
    L5_2 = "DELETE FROM apex_phone_saves WHERE app = ? AND username = ? AND post_id = ?"
    L6_2 = {}
    L7_2 = A1_2.app
    L8_2 = L2_2
    L9_2 = A1_2.postId
    L6_2[1] = L7_2
    L6_2[2] = L8_2
    L6_2[3] = L9_2
    L4_2(L5_2, L6_2)
    L4_2 = {}
    L4_2.saved = false
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.insert
  L4_2 = L4_2.await
  L5_2 = "INSERT IGNORE INTO apex_phone_saves (app, username, post_id, created) VALUES (?, ?, ?, ?)"
  L6_2 = {}
  L7_2 = A1_2.app
  L8_2 = L2_2
  L9_2 = A1_2.postId
  L10_2 = Now
  L10_2 = L10_2()
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L4_2(L5_2, L6_2)
  L4_2 = {}
  L4_2.saved = true
  return L4_2
end
L22_1["social.save"] = L23_1
L22_1 = RPC
function L23_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "SELECT "
  L5_2 = L12_1
  L6_2 = " FROM apex_phone_saves s JOIN apex_phone_posts p ON p.id = s.post_id WHERE s.app = ? AND s.username = ?"
  L7_2 = L4_1
  L8_2 = "p."
  L7_2 = L7_2(L8_2)
  L8_2 = " ORDER BY s.created DESC LIMIT 100"
  L4_2 = L4_2 .. L5_2 .. L6_2 .. L7_2 .. L8_2
  L5_2 = {}
  L6_2 = A1_2.app
  L7_2 = L2_2
  L8_2 = L2_2
  L9_2 = L2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = {}
  end
  L4_2 = L14_1
  L5_2 = A1_2.app
  L6_2 = L3_2
  L7_2 = L2_2
  return L4_2(L5_2, L6_2, L7_2)
end
L22_1["social.saves"] = L23_1
function L22_1()
  local L0_2, L1_2, L2_2
  L0_2 = tonumber
  L1_2 = Config
  L1_2 = L1_2.Social
  if not L1_2 then
    L1_2 = {}
  end
  L1_2 = L1_2.storyHours
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = 24
  end
  if L0_2 <= 0 then
    L0_2 = 24
  end
  L1_2 = math
  L1_2 = L1_2.floor
  L2_2 = L0_2 * 3600000
  return L1_2(L2_2)
end
function L23_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L0_2 = Now
  L0_2 = L0_2()
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = "SELECT id FROM apex_phone_stories WHERE expires <= ?"
  L3_2 = {}
  L4_2 = L0_2
  L3_2[1] = L4_2
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = #L1_2
  if 0 == L2_2 then
    return
  end
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = #L2_2
    L9_2 = L9_2 + 1
    L10_2 = L8_2.id
    L2_2[L9_2] = L10_2
  end
  L3_2 = table
  L3_2 = L3_2.concat
  L4_2 = L2_2
  L5_2 = ","
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "DELETE FROM apex_phone_story_views WHERE story_id IN ("
  L6_2 = L3_2
  L7_2 = ")"
  L5_2 = L5_2 .. L6_2 .. L7_2
  L4_2(L5_2)
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "DELETE FROM apex_phone_story_answers WHERE story_id IN ("
  L6_2 = L3_2
  L7_2 = ")"
  L5_2 = L5_2 .. L6_2 .. L7_2
  L4_2(L5_2)
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "DELETE FROM apex_phone_stories WHERE id IN ("
  L6_2 = L3_2
  L7_2 = ")"
  L5_2 = L5_2 .. L6_2 .. L7_2
  L4_2(L5_2)
end
L24_1 = CreateThread
function L25_1()
  local L0_2, L1_2
  while true do
    L0_2 = Wait
    L1_2 = 600000
    L0_2(L1_2)
    L0_2 = pcall
    L1_2 = L23_1
    L0_2(L1_2)
  end
end
L24_1(L25_1)
L24_1 = RPC
function L25_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L0_2 = Config
  L0_2 = L0_2.Stories
  if not L0_2 then
    L0_2 = {}
  end
  L1_2 = L0_2.locations
  if L1_2 then
    L2_2 = #L1_2
    if 0 ~= L2_2 then
      goto lbl_33
    end
  end
  L2_2 = {}
  L1_2 = L2_2
  L2_2 = ipairs
  L3_2 = Config
  L3_2 = L3_2.POI
  if not L3_2 then
    L3_2 = {}
  end
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = #L1_2
    L8_2 = L8_2 + 1
    L9_2 = L7_2.name
    L1_2[L8_2] = L9_2
  end
  ::lbl_33::
  L2_2 = {}
  L3_2 = {}
  L4_2 = "#833AB4"
  L5_2 = "#FD1D1D"
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L4_2 = {}
  L5_2 = "#FF9F0A"
  L6_2 = "#FF375F"
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L5_2 = {}
  L6_2 = "#30D158"
  L7_2 = "#0B6E4F"
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L6_2 = {}
  L7_2 = "#0A84FF"
  L8_2 = "#5E5CE6"
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L7_2 = {}
  L8_2 = "#BF5AF2"
  L9_2 = "#FF375F"
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L8_2 = {}
  L9_2 = "#00C7BE"
  L10_2 = "#0A84FF"
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L2_2[5] = L7_2
  L2_2[6] = L8_2
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L0_2.music
  if not L5_2 then
    L5_2 = {}
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L9_2.vid
    if L10_2 then
      L10_2 = #L3_2
      L10_2 = L10_2 + 1
      L11_2 = {}
      L12_2 = L9_2.id
      if not L12_2 then
        L12_2 = "yt:"
        L13_2 = L9_2.vid
        L12_2 = L12_2 .. L13_2
      end
      L11_2.id = L12_2
      L12_2 = L9_2.vid
      L11_2.vid = L12_2
      L12_2 = L9_2.title
      L11_2.title = L12_2
      L12_2 = L9_2.artist
      L11_2.artist = L12_2
      L12_2 = tonumber
      L13_2 = L9_2.dur
      L12_2 = L12_2(L13_2)
      if not L12_2 then
        L12_2 = 180
      end
      L11_2.dur = L12_2
      L12_2 = L9_2.art
      if not L12_2 then
        L12_2 = L8_2 - 1
        L13_2 = #L2_2
        L12_2 = L12_2 % L13_2
        L12_2 = L12_2 + 1
        L12_2 = L2_2[L12_2]
      end
      L11_2.art = L12_2
      L3_2[L10_2] = L11_2
    end
  end
  L4_2 = #L3_2
  if 0 == L4_2 then
    L4_2 = ipairs
    L5_2 = Config
    L5_2 = L5_2.Music
    if not L5_2 then
      L5_2 = {}
    end
    L5_2 = L5_2.Library
    if not L5_2 then
      L5_2 = {}
    end
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = #L3_2
      L10_2 = L10_2 + 1
      L11_2 = {}
      L12_2 = "yt:"
      L13_2 = L9_2.vid
      L12_2 = L12_2 .. L13_2
      L11_2.id = L12_2
      L12_2 = L9_2.vid
      L11_2.vid = L12_2
      L12_2 = L9_2.t
      L11_2.title = L12_2
      L12_2 = L9_2.a
      L11_2.artist = L12_2
      L12_2 = tonumber
      L13_2 = L9_2.len
      L12_2 = L12_2(L13_2)
      if not L12_2 then
        L12_2 = 180
      end
      L11_2.dur = L12_2
      L12_2 = L8_2 - 1
      L13_2 = #L2_2
      L12_2 = L12_2 % L13_2
      L12_2 = L12_2 + 1
      L12_2 = L2_2[L12_2]
      L11_2.art = L12_2
      L3_2[L10_2] = L11_2
    end
  end
  L4_2 = {}
  L5_2 = tonumber
  L6_2 = L0_2.duration
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 5
  end
  L4_2.duration = L5_2
  L5_2 = tonumber
  L6_2 = L0_2.maxLayers
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 24
  end
  L4_2.maxLayers = L5_2
  L5_2 = L0_2.closeFriends
  L5_2 = false ~= L5_2
  L4_2.closeFriends = L5_2
  L5_2 = L0_2.backgrounds
  if not L5_2 then
    L5_2 = {}
  end
  L4_2.backgrounds = L5_2
  L4_2.locations = L1_2
  L4_2.music = L3_2
  return L4_2
end
L24_1["social.stories.config"] = L25_1
L24_1 = RPC
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "SELECT friend FROM apex_phone_close_friends WHERE app = ? AND owner = ?"
  L5_2 = {}
  L6_2 = A1_2.app
  L7_2 = L2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = {}
  end
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L3_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = #L4_2
    L11_2 = L11_2 + 1
    L12_2 = L10_2.friend
    L4_2[L11_2] = L12_2
  end
  return L4_2
end
L24_1["social.closefriends"] = L25_1
L24_1 = RPC
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noprofile"
    return L3_2
  end
  L3_2 = tostring
  L4_2 = A1_2.target
  if not L4_2 then
    L4_2 = ""
  end
  L3_2 = L3_2(L4_2)
  if "" == L3_2 or L3_2 == L2_2 then
    L4_2 = {}
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT friend FROM apex_phone_close_friends WHERE app = ? AND owner = ? AND friend = ?"
  L6_2 = {}
  L7_2 = A1_2.app
  L8_2 = L2_2
  L9_2 = L3_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = MySQL
    L5_2 = L5_2.query
    L5_2 = L5_2.await
    L6_2 = "DELETE FROM apex_phone_close_friends WHERE app = ? AND owner = ? AND friend = ?"
    L7_2 = {}
    L8_2 = A1_2.app
    L9_2 = L2_2
    L10_2 = L3_2
    L7_2[1] = L8_2
    L7_2[2] = L9_2
    L7_2[3] = L10_2
    L5_2(L6_2, L7_2)
    L5_2 = {}
    L5_2.on = false
    return L5_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.insert
  L5_2 = L5_2.await
  L6_2 = "INSERT IGNORE INTO apex_phone_close_friends (app, owner, friend) VALUES (?, ?, ?)"
  L7_2 = {}
  L8_2 = A1_2.app
  L9_2 = L2_2
  L10_2 = L3_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L5_2(L6_2, L7_2)
  L5_2 = {}
  L5_2.on = true
  return L5_2
end
L24_1["social.closefriends.toggle"] = L25_1
L24_1 = RPC
function L25_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = pcall
  L4_2 = L23_1
  L3_2(L4_2)
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = ""
  end
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = [[
SELECT id, app, author, loc, created, expires,
        bg, duration, close_friends, (image IS NOT NULL) AS has_media
        FROM apex_phone_stories WHERE app = ? AND expires > ?]]
  L6_2 = L5_1
  L7_2 = "apex_phone_stories."
  L6_2 = L6_2(L7_2)
  L7_2 = " ORDER BY created DESC LIMIT 300"
  L5_2 = L5_2 .. L6_2 .. L7_2
  L6_2 = {}
  L7_2 = A1_2.app
  L8_2 = Now
  L8_2 = L8_2()
  L9_2 = L3_2
  L10_2 = L3_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L5_2 = #L4_2
  if 0 == L5_2 then
    L5_2 = {}
    return L5_2
  end
  L5_2 = 1
  L6_2 = math
  L6_2 = L6_2.floor
  L7_2 = #L4_2
  L7_2 = L7_2 / 2
  L6_2 = L6_2(L7_2)
  L7_2 = 1
  for L8_2 = L5_2, L6_2, L7_2 do
    L9_2 = #L4_2
    L9_2 = L9_2 - L8_2
    L9_2 = L9_2 + 1
    L10_2 = #L4_2
    L10_2 = L10_2 - L8_2
    L10_2 = L10_2 + 1
    L10_2 = L4_2[L10_2]
    L11_2 = L4_2[L8_2]
    L4_2[L9_2] = L11_2
    L4_2[L8_2] = L10_2
  end
  L5_2 = {}
  L6_2 = MySQL
  L6_2 = L6_2.query
  L6_2 = L6_2.await
  L7_2 = "SELECT owner FROM apex_phone_close_friends WHERE app = ? AND friend = ?"
  L8_2 = {}
  L9_2 = A1_2.app
  L10_2 = L2_2 or L10_2
  if not L2_2 then
    L10_2 = ""
  end
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = {}
  end
  L7_2 = ipairs
  L8_2 = L6_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = L12_2.owner
    L5_2[L13_2] = true
  end
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L4_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = tonumber
    L14_2 = L12_2.close_friends
    L13_2 = L13_2(L14_2)
    if not L13_2 then
      L13_2 = 0
    end
    L13_2 = 1 == L13_2
    if L13_2 then
      L14_2 = L12_2.author
      if L14_2 ~= L2_2 then
        L14_2 = L12_2.author
        L14_2 = L5_2[L14_2]
        if not L14_2 then
          goto lbl_122
        end
      end
    end
    L14_2 = #L6_2
    L14_2 = L14_2 + 1
    L6_2[L14_2] = L12_2
    ::lbl_122::
  end
  L4_2 = L6_2
  L7_2 = #L4_2
  if 0 == L7_2 then
    L7_2 = {}
    return L7_2
  end
  L7_2 = {}
  L8_2 = ipairs
  L9_2 = L4_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = #L7_2
    L14_2 = L14_2 + 1
    L15_2 = L13_2.id
    L7_2[L14_2] = L15_2
  end
  L8_2 = {}
  if L2_2 then
    L9_2 = MySQL
    L9_2 = L9_2.query
    L9_2 = L9_2.await
    L10_2 = "SELECT story_id FROM apex_phone_story_views WHERE username = ? AND story_id IN ("
    L11_2 = table
    L11_2 = L11_2.concat
    L12_2 = L7_2
    L13_2 = ","
    L11_2 = L11_2(L12_2, L13_2)
    L12_2 = ")"
    L10_2 = L10_2 .. L11_2 .. L12_2
    L11_2 = {}
    L12_2 = L2_2
    L11_2[1] = L12_2
    L9_2 = L9_2(L10_2, L11_2)
    if not L9_2 then
      L9_2 = {}
    end
    L10_2 = ipairs
    L11_2 = L9_2
    L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
    for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
      L16_2 = L15_2.story_id
      L8_2[L16_2] = true
    end
  end
  L9_2 = {}
  L10_2 = ipairs
  L11_2 = L4_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = #L9_2
    L16_2 = L16_2 + 1
    L17_2 = L15_2.author
    L9_2[L16_2] = L17_2
  end
  L10_2 = L6_1
  L11_2 = A1_2.app
  L12_2 = L9_2
  L13_2 = "username, name, avatar, avatar_url"
  L10_2 = L10_2(L11_2, L12_2, L13_2)
  L11_2 = {}
  L12_2 = {}
  L13_2 = ipairs
  L14_2 = L4_2
  L13_2, L14_2, L15_2, L16_2 = L13_2(L14_2)
  for L17_2, L18_2 in L13_2, L14_2, L15_2, L16_2 do
    L19_2 = L18_2.id
    L19_2 = L8_2[L19_2]
    L19_2 = true == L19_2
    L18_2.seen = L19_2
    L19_2 = tonumber
    L20_2 = L18_2.expires
    L19_2 = L19_2(L20_2)
    L18_2.expires = L19_2
    L19_2 = tonumber
    L20_2 = L18_2.duration
    L19_2 = L19_2(L20_2)
    if not L19_2 then
      L19_2 = 5
    end
    L18_2.duration = L19_2
    L19_2 = tonumber
    L20_2 = L18_2.close_friends
    L19_2 = L19_2(L20_2)
    if not L19_2 then
      L19_2 = 0
    end
    L19_2 = 1 == L19_2
    L18_2.closeFriends = L19_2
    L19_2 = tonumber
    L20_2 = L18_2.has_media
    L19_2 = L19_2(L20_2)
    if not L19_2 then
      L19_2 = 0
    end
    L19_2 = 1 == L19_2
    L18_2.hasMedia = L19_2
    L18_2.close_friends = nil
    L18_2.has_media = nil
    L19_2 = L18_2.author
    L19_2 = L11_2[L19_2]
    if not L19_2 then
      L20_2 = L7_1
      L21_2 = L10_2
      L22_2 = L18_2.author
      L20_2 = L20_2(L21_2, L22_2)
      L21_2 = {}
      L22_2 = L18_2.author
      L21_2.author = L22_2
      if L20_2 then
        L22_2 = L20_2.name
        if L22_2 then
          goto lbl_266
        end
      end
      L22_2 = nil
      ::lbl_266::
      L21_2.name = L22_2
      if L20_2 then
        L22_2 = tonumber
        L23_2 = L20_2.avatar
        L22_2 = L22_2(L23_2)
        if L22_2 then
          goto lbl_278
        end
        L22_2 = L20_2.avatar
        if L22_2 then
          goto lbl_278
        end
      end
      L22_2 = 1
      ::lbl_278::
      L21_2.avatar = L22_2
      if L20_2 then
        L22_2 = L20_2.avatar_url
        if L22_2 then
          goto lbl_285
        end
      end
      L22_2 = nil
      ::lbl_285::
      L21_2.avatarUrl = L22_2
      L22_2 = {}
      L21_2.items = L22_2
      L21_2.allSeen = true
      L22_2 = L18_2.author
      L22_2 = L22_2 == L2_2
      L21_2.mine = L22_2
      L19_2 = L21_2
      L21_2 = L18_2.author
      L11_2[L21_2] = L19_2
      L21_2 = #L12_2
      L21_2 = L21_2 + 1
      L12_2[L21_2] = L19_2
    end
    L20_2 = L19_2.items
    L21_2 = L19_2.items
    L21_2 = #L21_2
    L21_2 = L21_2 + 1
    L20_2[L21_2] = L18_2
    L20_2 = L18_2.seen
    if not L20_2 then
      L19_2.allSeen = false
    end
  end
  L13_2 = table
  L13_2 = L13_2.sort
  L14_2 = L12_2
  function L15_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3
    L2_3 = A0_3.mine
    L3_3 = A1_3.mine
    if L2_3 ~= L3_3 then
      L2_3 = A0_3.mine
      return L2_3
    end
    L2_3 = A0_3.allSeen
    L3_3 = A1_3.allSeen
    if L2_3 ~= L3_3 then
      L2_3 = A1_3.allSeen
      return L2_3
    end
    L2_3 = A0_3.items
    L3_3 = A0_3.items
    L3_3 = #L3_3
    L2_3 = L2_3[L3_3]
    L2_3 = L2_3.created
    if not L2_3 then
      L2_3 = 0
    end
    L3_3 = A1_3.items
    L4_3 = A1_3.items
    L4_3 = #L4_3
    L3_3 = L3_3[L4_3]
    L3_3 = L3_3.created
    if not L3_3 then
      L3_3 = 0
    end
    L2_3 = L2_3 > L3_3
    return L2_3
  end
  L13_2(L14_2, L15_2)
  return L12_2
end
L24_1["social.stories"] = L25_1
L24_1 = 48000
function L25_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  if not A2_2 then
    L3_2 = false
    return L3_2
  end
  L3_2 = tonumber
  L4_2 = A2_2.close_friends
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 0
  end
  if 0 == L3_2 then
    L3_2 = true
    return L3_2
  end
  L3_2 = L0_1
  L4_2 = A0_2
  L5_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = A2_2.author
  if L4_2 == L3_2 then
    L4_2 = true
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT friend FROM apex_phone_close_friends WHERE app = ? AND owner = ? AND friend = ?"
  L6_2 = {}
  L7_2 = A1_2
  L8_2 = A2_2.author
  L9_2 = L3_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L4_2 = L4_2(L5_2, L6_2)
  L4_2 = nil ~= L4_2
  return L4_2
end
L26_1 = RPC
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = ""
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = [[
SELECT id, app, author, layers, bg, duration, loc, text, tx, ty, tsize, tcolor, created, close_friends,
        CHAR_LENGTH(image) AS image_len, CHAR_LENGTH(draw) AS draw_len
        FROM apex_phone_stories WHERE id = ? AND expires > ?]]
  L5_2 = L5_1
  L6_2 = "apex_phone_stories."
  L5_2 = L5_2(L6_2)
  L4_2 = L4_2 .. L5_2
  L5_2 = {}
  L6_2 = A1_2.id
  L7_2 = Now
  L7_2 = L7_2()
  L8_2 = L2_2
  L9_2 = L2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = L25_1
  L5_2 = A0_2
  L6_2 = L3_2.app
  if not L6_2 then
    L6_2 = A1_2.app
  end
  L7_2 = L3_2
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  if not L4_2 then
    L4_2 = nil
    return L4_2
  end
  L4_2 = L3_2.layers
  if L4_2 then
    L4_2 = pcall
    L5_2 = json
    L5_2 = L5_2.decode
    L6_2 = L3_2.layers
    L4_2, L5_2 = L4_2(L5_2, L6_2)
    if L4_2 then
      L6_2 = type
      L7_2 = L5_2
      L6_2 = L6_2(L7_2)
      if "table" == L6_2 then
        L6_2 = #L5_2
        if L6_2 > 0 and L5_2 then
          goto lbl_61
          L6_2 = L5_2 or L6_2
        end
      end
    end
    L6_2 = nil
    ::lbl_61::
    L3_2.layers = L6_2
  end
  L4_2 = tonumber
  L5_2 = L3_2.duration
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 5
  end
  L3_2.duration = L4_2
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = tonumber
  L6_2 = L3_2.image_len
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L3_2.imageLen = L4_2
  L4_2 = math
  L4_2 = L4_2.tointeger
  L5_2 = tonumber
  L6_2 = L3_2.draw_len
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L3_2.drawLen = L4_2
  L4_2 = L24_1
  L3_2.chunk = L4_2
  L3_2.image_len = nil
  L3_2.draw_len = nil
  L3_2.close_friends = nil
  L4_2 = L0_1
  L5_2 = A0_2
  L6_2 = L3_2.app
  if not L6_2 then
    L6_2 = A1_2.app
  end
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "SELECT layer, username, choice, answer FROM apex_phone_story_answers WHERE story_id = ?"
  L7_2 = {}
  L8_2 = L3_2.id
  L7_2[1] = L8_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
  end
  L6_2 = #L5_2
  if L6_2 > 0 then
    L6_2 = {}
    L7_2 = {}
    L8_2 = ipairs
    L9_2 = L5_2
    L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
    for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
      L14_2 = tostring
      L15_2 = L13_2.layer
      L14_2 = L14_2(L15_2)
      L15_2 = L6_2[L14_2]
      if not L15_2 then
        L16_2 = {}
        L16_2.a = 0
        L16_2.b = 0
        L16_2.n = 0
        L15_2 = L16_2
        L6_2[L14_2] = L15_2
      end
      L16_2 = L15_2.n
      L16_2 = L16_2 + 1
      L15_2.n = L16_2
      L16_2 = tonumber
      L17_2 = L13_2.choice
      L16_2 = L16_2(L17_2)
      if 0 == L16_2 then
        L16_2 = L15_2.a
        L16_2 = L16_2 + 1
        L15_2.a = L16_2
      else
        L16_2 = tonumber
        L17_2 = L13_2.choice
        L16_2 = L16_2(L17_2)
        if 1 == L16_2 then
          L16_2 = L15_2.b
          L16_2 = L16_2 + 1
          L15_2.b = L16_2
        end
      end
      if L4_2 then
        L16_2 = L13_2.username
        if L16_2 == L4_2 then
          L16_2 = {}
          L17_2 = L13_2.choice
          if L17_2 then
            L17_2 = math
            L17_2 = L17_2.tointeger
            L18_2 = tonumber
            L19_2 = L13_2.choice
            L18_2, L19_2 = L18_2(L19_2)
            L17_2 = L17_2(L18_2, L19_2)
            if L17_2 then
              goto lbl_186
            end
          end
          L17_2 = nil
          ::lbl_186::
          L16_2.choice = L17_2
          L17_2 = L13_2.answer
          L16_2.answer = L17_2
          L7_2[L14_2] = L16_2
        end
      end
    end
    L3_2.polls = L6_2
    L3_2.myAnswers = L7_2
  end
  return L3_2
end
L26_1["social.story.get"] = L27_1
L26_1 = RPC
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noprofile"
    return L3_2
  end
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L3_2 = L3_2(L4_2)
  if not L3_2 or L3_2 < 1 then
    L4_2 = {}
    L4_2.error = "invalid"
    return L4_2
  end
  L4_2 = tostring
  L5_2 = A1_2.layer
  if not L5_2 then
    L5_2 = ""
  end
  L4_2 = L4_2(L5_2)
  L5_2 = L4_2
  L4_2 = L4_2.sub
  L6_2 = 1
  L7_2 = 16
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  if "" == L4_2 then
    L5_2 = {}
    L5_2.error = "invalid"
    return L5_2
  end
  L5_2 = GetCid
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = ""
  end
  L6_2 = MySQL
  L6_2 = L6_2.single
  L6_2 = L6_2.await
  L7_2 = "SELECT id, app, author, close_friends FROM apex_phone_stories WHERE id = ? AND expires > ?"
  L8_2 = L5_1
  L9_2 = "apex_phone_stories."
  L8_2 = L8_2(L9_2)
  L7_2 = L7_2 .. L8_2
  L8_2 = {}
  L9_2 = L3_2
  L10_2 = Now
  L10_2 = L10_2()
  L11_2 = L5_2
  L12_2 = L5_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L7_2 = {}
    L7_2.error = "gone"
    return L7_2
  end
  L7_2 = L25_1
  L8_2 = A0_2
  L9_2 = L6_2.app
  L10_2 = L6_2
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  if not L7_2 then
    L7_2 = {}
    L7_2.error = "forbidden"
    return L7_2
  end
  L7_2 = L6_2.author
  if L7_2 == L2_2 then
    L7_2 = {}
    L7_2.error = "own"
    return L7_2
  end
  L7_2 = A1_2.choice
  if nil ~= L7_2 then
    L7_2 = math
    L7_2 = L7_2.max
    L8_2 = 0
    L9_2 = math
    L9_2 = L9_2.min
    L10_2 = 1
    L11_2 = math
    L11_2 = L11_2.floor
    L12_2 = tonumber
    L13_2 = A1_2.choice
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      L12_2 = 0
    end
    L11_2 = L11_2(L12_2)
    L9_2 = L9_2(L10_2, L11_2)
    L7_2 = L7_2(L8_2, L9_2)
    if L7_2 then
      goto lbl_114
    end
  end
  L7_2 = nil
  ::lbl_114::
  L8_2 = type
  L9_2 = A1_2.answer
  L8_2 = L8_2(L9_2)
  if "string" == L8_2 then
    L8_2 = A1_2.answer
    L9_2 = L8_2
    L8_2 = L8_2.gsub
    L10_2 = "%c"
    L11_2 = " "
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    L9_2 = L8_2
    L8_2 = L8_2.sub
    L10_2 = 1
    L11_2 = 200
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    if L8_2 then
      goto lbl_131
    end
  end
  L8_2 = nil
  ::lbl_131::
  if "" == L8_2 then
    L8_2 = nil
  end
  if nil == L7_2 and not L8_2 then
    L9_2 = {}
    L9_2.error = "empty"
    return L9_2
  end
  L9_2 = MySQL
  L9_2 = L9_2.query
  L9_2 = L9_2.await
  L10_2 = [[
INSERT INTO apex_phone_story_answers (story_id, layer, username, choice, answer, created)
        VALUES (?, ?, ?, ?, ?, ?)
        ON DUPLICATE KEY UPDATE choice = VALUES(choice), answer = VALUES(answer), created = VALUES(created)]]
  L11_2 = {}
  L12_2 = L3_2
  L13_2 = L4_2
  L14_2 = L2_2
  L15_2 = L7_2
  L16_2 = L8_2
  L17_2 = Now
  L17_2 = L17_2()
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L11_2[5] = L16_2
  L11_2[6] = L17_2
  L9_2(L10_2, L11_2)
  if L8_2 then
    L9_2 = L1_1
    L10_2 = L6_2.app
    L11_2 = L6_2.author
    L9_2 = L9_2(L10_2, L11_2)
    if L9_2 then
      L10_2 = NotifyCitizen
      L11_2 = L9_2.owner
      L12_2 = L6_2.app
      L13_2 = "@"
      L14_2 = L2_2
      L15_2 = " respondeu-te"
      L13_2 = L13_2 .. L14_2 .. L15_2
      L14_2 = L8_2
      L15_2 = {}
      L15_2.sys = "t"
      L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
    end
  end
  L9_2 = {}
  L9_2.ok = true
  return L9_2
end
L26_1["social.story.answer"] = L27_1
L26_1 = RPC
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT author FROM apex_phone_stories WHERE id = ?"
  L5_2 = {}
  L6_2 = A1_2.id
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L3_2.author
    if L4_2 == L2_2 then
      goto lbl_27
    end
  end
  L4_2 = {}
  do return L4_2 end
  ::lbl_27::
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "SELECT layer, username, choice, answer, created FROM apex_phone_story_answers WHERE story_id = ? ORDER BY created DESC LIMIT 200"
  L6_2 = {}
  L7_2 = A1_2.id
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L5_2 = {}
  L6_2 = ipairs
  L7_2 = L4_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = #L5_2
    L12_2 = L12_2 + 1
    L13_2 = {}
    L14_2 = L11_2.layer
    L13_2.layer = L14_2
    L14_2 = L11_2.username
    L13_2.username = L14_2
    L14_2 = L11_2.choice
    if L14_2 then
      L14_2 = math
      L14_2 = L14_2.tointeger
      L15_2 = tonumber
      L16_2 = L11_2.choice
      L15_2, L16_2 = L15_2(L16_2)
      L14_2 = L14_2(L15_2, L16_2)
      if L14_2 then
        goto lbl_67
      end
    end
    L14_2 = nil
    ::lbl_67::
    L13_2.choice = L14_2
    L14_2 = L11_2.answer
    L13_2.answer = L14_2
    L14_2 = tonumber
    L15_2 = L11_2.created
    L14_2 = L14_2(L15_2)
    L13_2.created = L14_2
    L5_2[L12_2] = L13_2
  end
  return L5_2
end
L26_1["social.story.answers"] = L27_1
L26_1 = RPC
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 0
  end
  L2_2 = L2_2(L3_2)
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = A1_2.i
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 1
  end
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 1
  end
  L4_2 = A1_2.which
  if "draw" == L4_2 then
    L4_2 = "draw"
    if L4_2 then
      goto lbl_29
    end
  end
  L4_2 = "image"
  ::lbl_29::
  if not L2_2 or L2_2 < 1 or L3_2 < 1 or L3_2 > 64 then
    L5_2 = {}
    L5_2.error = "badchunk"
    return L5_2
  end
  L5_2 = GetCid
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = ""
  end
  L6_2 = MySQL
  L6_2 = L6_2.single
  L6_2 = L6_2.await
  L7_2 = "SELECT app, author, close_friends FROM apex_phone_stories WHERE id = ? AND expires > ?"
  L8_2 = L5_1
  L9_2 = "apex_phone_stories."
  L8_2 = L8_2(L9_2)
  L7_2 = L7_2 .. L8_2
  L8_2 = {}
  L9_2 = L2_2
  L10_2 = Now
  L10_2 = L10_2()
  L11_2 = L5_2
  L12_2 = L5_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L7_2 = {}
    L7_2.error = "notfound"
    return L7_2
  end
  L7_2 = L25_1
  L8_2 = A0_2
  L9_2 = L6_2.app
  L10_2 = L6_2
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  if not L7_2 then
    L7_2 = {}
    L7_2.error = "forbidden"
    return L7_2
  end
  L7_2 = MySQL
  L7_2 = L7_2.single
  L7_2 = L7_2.await
  L8_2 = "SELECT CHAR_LENGTH(`%s`) AS len, SUBSTRING(`%s`, ?, ?) AS part FROM apex_phone_stories WHERE id = ?"
  L9_2 = L8_2
  L8_2 = L8_2.format
  L10_2 = L4_2
  L11_2 = L4_2
  L8_2 = L8_2(L9_2, L10_2, L11_2)
  L9_2 = {}
  L10_2 = L3_2 - 1
  L11_2 = L24_1
  L10_2 = L10_2 * L11_2
  L10_2 = L10_2 + 1
  L11_2 = L24_1
  L12_2 = L2_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L7_2 = L7_2(L8_2, L9_2)
  if not L7_2 then
    L8_2 = {}
    L8_2.error = "notfound"
    return L8_2
  end
  L8_2 = math
  L8_2 = L8_2.tointeger
  L9_2 = tonumber
  L10_2 = L7_2.len
  L9_2 = L9_2(L10_2)
  if not L9_2 then
    L9_2 = 0
  end
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 0
  end
  if L8_2 <= 0 then
    L9_2 = {}
    L9_2.i = L3_2
    L9_2.total = 0
    L9_2.len = 0
    L9_2.data = ""
    return L9_2
  end
  L9_2 = {}
  L9_2.i = L3_2
  L10_2 = math
  L10_2 = L10_2.ceil
  L11_2 = L24_1
  L11_2 = L8_2 / L11_2
  L10_2 = L10_2(L11_2)
  L9_2.total = L10_2
  L9_2.len = L8_2
  L10_2 = L7_2.part
  if not L10_2 then
    L10_2 = ""
  end
  L9_2.data = L10_2
  return L9_2
end
L26_1["social.story.media"] = L27_1
L26_1 = RPC
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noprofile"
    return L3_2
  end
  L3_2 = math
  L3_2 = L3_2.tointeger
  L4_2 = tonumber
  L5_2 = A1_2.id
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L3_2 = L3_2(L4_2)
  L4_2 = A1_2.which
  if "draw" == L4_2 then
    L4_2 = "draw"
    if L4_2 then
      goto lbl_27
    end
  end
  L4_2 = "image"
  ::lbl_27::
  L5_2 = tostring
  L6_2 = A1_2.data
  if not L6_2 then
    L6_2 = ""
  end
  L5_2 = L5_2(L6_2)
  if L3_2 and not (L3_2 < 1) then
    L6_2 = #L5_2
    L7_2 = L24_1
    L7_2 = L7_2 + 64
    if not (L6_2 > L7_2) then
      goto lbl_47
    end
  end
  L6_2 = {}
  L6_2.error = "badchunk"
  do return L6_2 end
  ::lbl_47::
  L6_2 = MySQL
  L6_2 = L6_2.single
  L6_2 = L6_2.await
  L7_2 = "SELECT author FROM apex_phone_stories WHERE id = ?"
  L8_2 = {}
  L9_2 = L3_2
  L8_2[1] = L9_2
  L6_2 = L6_2(L7_2, L8_2)
  if L6_2 then
    L7_2 = L6_2.author
    if L7_2 == L2_2 then
      goto lbl_65
    end
  end
  L7_2 = {}
  L7_2.error = "forbidden"
  do return L7_2 end
  ::lbl_65::
  L7_2 = tonumber
  L8_2 = A1_2.i
  L7_2 = L7_2(L8_2)
  if 1 == L7_2 then
    L7_2 = MySQL
    L7_2 = L7_2.update
    L7_2 = L7_2.await
    L8_2 = "UPDATE apex_phone_stories SET `%s` = ? WHERE id = ?"
    L9_2 = L8_2
    L8_2 = L8_2.format
    L10_2 = L4_2
    L8_2 = L8_2(L9_2, L10_2)
    L9_2 = {}
    L10_2 = L5_2
    L11_2 = L3_2
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L7_2(L8_2, L9_2)
  else
    L7_2 = MySQL
    L7_2 = L7_2.update
    L7_2 = L7_2.await
    L8_2 = "UPDATE apex_phone_stories SET `%s` = CONCAT(COALESCE(`%s`, \"\"), ?) WHERE id = ?"
    L9_2 = L8_2
    L8_2 = L8_2.format
    L10_2 = L4_2
    L11_2 = L4_2
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    L9_2 = {}
    L10_2 = L5_2
    L11_2 = L3_2
    L9_2[1] = L10_2
    L9_2[2] = L11_2
    L7_2(L8_2, L9_2)
  end
  L7_2 = MySQL
  L7_2 = L7_2.scalar
  L7_2 = L7_2.await
  L8_2 = "SELECT CHAR_LENGTH(`%s`) FROM apex_phone_stories WHERE id = ?"
  L9_2 = L8_2
  L8_2 = L8_2.format
  L10_2 = L4_2
  L8_2 = L8_2(L9_2, L10_2)
  L9_2 = {}
  L10_2 = L3_2
  L9_2[1] = L10_2
  L7_2 = L7_2(L8_2, L9_2)
  if not L7_2 then
    L7_2 = 0
  end
  L8_2 = 300000
  if L7_2 > L8_2 then
    L8_2 = MySQL
    L8_2 = L8_2.update
    L8_2 = L8_2.await
    L9_2 = "UPDATE apex_phone_stories SET `%s` = NULL WHERE id = ?"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = L4_2
    L9_2 = L9_2(L10_2, L11_2)
    L10_2 = {}
    L11_2 = L3_2
    L10_2[1] = L11_2
    L8_2(L9_2, L10_2)
    L8_2 = {}
    L8_2.error = "toolarge"
    return L8_2
  end
  L8_2 = {}
  L8_2.ok = true
  L8_2.len = L7_2
  return L8_2
end
L26_1["social.story.upload"] = L27_1
L26_1 = {}
L26_1.text = true
L26_1.emoji = true
L26_1.location = true
L26_1.hashtag = true
L26_1.mention = true
L26_1.time = true
L26_1.date = true
L26_1.music = true
L26_1.poll = true
L26_1.question = true
L27_1 = {}
L27_1.normal = true
L27_1.bold = true
L27_1.modern = true
L27_1.classic = true
L27_1.type = true
L27_1.neon = true
L27_1.script = true
L27_1.wide = true
L28_1 = {}
L28_1.left = true
L28_1.center = true
L28_1.right = true
function L29_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2
  L4_2 = tonumber
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 or L4_2 ~= L4_2 then
    return A3_2
  end
  if A1_2 > L4_2 then
    return A1_2
  elseif A2_2 < L4_2 then
    return A2_2
  end
  return L4_2
end
function L30_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 then
    L1_2 = nil
    return L1_2
  end
  L2_2 = A0_2
  L1_2 = A0_2.match
  L3_2 = "^#%x%x%x%x%x%x$"
  return L1_2(L2_2, L3_2)
end
function L31_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "string" ~= L3_2 then
    L3_2 = nil
    return L3_2
  end
  if A2_2 then
    L4_2 = A0_2
    L3_2 = A0_2.gsub
    L5_2 = "[%z\001-\t\v-\031\127]"
    L6_2 = ""
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    if L3_2 then
      goto lbl_21
      A0_2 = L3_2 or A0_2
    end
  end
  L4_2 = A0_2
  L3_2 = A0_2.gsub
  L5_2 = "%c"
  L6_2 = ""
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  A0_2 = L3_2
  ::lbl_21::
  L4_2 = A0_2
  L3_2 = A0_2.sub
  L5_2 = 1
  L6_2 = A1_2
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  A0_2 = L3_2
  if "" == A0_2 then
    L3_2 = nil
    return L3_2
  end
  return A0_2
end
function L32_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = {}
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "table" ~= L3_2 then
    return L2_2
  end
  L3_2 = ipairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = type
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if "table" == L9_2 then
      L10_2 = L8_2.type
      L9_2 = L26_1
      L9_2 = L9_2[L10_2]
      if L9_2 then
        L9_2 = {}
        L10_2 = L31_1
        L11_2 = L8_2.id
        L12_2 = 12
        L10_2 = L10_2(L11_2, L12_2)
        if not L10_2 then
          L10_2 = "l"
          L11_2 = #L2_2
          L11_2 = L11_2 + 1
          L10_2 = L10_2 .. L11_2
        end
        L9_2.id = L10_2
        L10_2 = L8_2.type
        L9_2.type = L10_2
        L10_2 = L29_1
        L11_2 = L8_2.x
        L12_2 = 0
        L13_2 = 1
        L14_2 = 0.5
        L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
        L9_2.x = L10_2
        L10_2 = L29_1
        L11_2 = L8_2.y
        L12_2 = 0
        L13_2 = 1
        L14_2 = 0.5
        L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
        L9_2.y = L10_2
        L10_2 = L29_1
        L11_2 = L8_2.scale
        L12_2 = 0.2
        L13_2 = 4
        L14_2 = 1
        L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
        L9_2.scale = L10_2
        L10_2 = L29_1
        L11_2 = L8_2.rot
        L12_2 = -360
        L13_2 = 360
        L14_2 = 0
        L10_2 = L10_2(L11_2, L12_2, L13_2, L14_2)
        L9_2.rot = L10_2
        L10_2 = L8_2.type
        L10_2 = "text" == L10_2
        L11_2 = L31_1
        L12_2 = L8_2.text
        if L10_2 then
          L13_2 = 200
          if L13_2 then
            goto lbl_80
          end
        end
        L13_2 = 48
        ::lbl_80::
        L14_2 = L10_2
        L11_2 = L11_2(L12_2, L13_2, L14_2)
        L9_2.text = L11_2
        L12_2 = L8_2.font
        L11_2 = L27_1
        L11_2 = L11_2[L12_2]
        if L11_2 then
          L11_2 = L8_2.font
          L9_2.font = L11_2
        end
        L12_2 = L8_2.align
        L11_2 = L28_1
        L11_2 = L11_2[L12_2]
        if L11_2 then
          L11_2 = L8_2.align
          L9_2.align = L11_2
        end
        L11_2 = L30_1
        L12_2 = L8_2.color
        L11_2 = L11_2(L12_2)
        L9_2.color = L11_2
        L11_2 = L30_1
        L12_2 = L8_2.bg
        L11_2 = L11_2(L12_2)
        L9_2.bg = L11_2
        L11_2 = L8_2.bgA
        if nil ~= L11_2 then
          L11_2 = L29_1
          L12_2 = L8_2.bgA
          L13_2 = 0
          L14_2 = 1
          L15_2 = 1
          L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2)
          L9_2.bgA = L11_2
        end
        L11_2 = L8_2.size
        if nil ~= L11_2 then
          L11_2 = math
          L11_2 = L11_2.floor
          L12_2 = L29_1
          L13_2 = L8_2.size
          L14_2 = 8
          L15_2 = 120
          L16_2 = 30
          L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L12_2(L13_2, L14_2, L15_2, L16_2)
          L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
          L9_2.size = L11_2
        end
        L11_2 = L8_2.style
        if nil ~= L11_2 then
          L11_2 = math
          L11_2 = L11_2.floor
          L12_2 = L29_1
          L13_2 = L8_2.style
          L14_2 = 1
          L15_2 = 3
          L16_2 = 2
          L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L12_2(L13_2, L14_2, L15_2, L16_2)
          L11_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
          L9_2.style = L11_2
        end
        L11_2 = type
        L12_2 = L8_2.data
        L11_2 = L11_2(L12_2)
        if "table" == L11_2 then
          L11_2 = L8_2.data
          if L11_2 then
            goto lbl_150
          end
        end
        L11_2 = nil
        ::lbl_150::
        L12_2 = L8_2.type
        if "music" == L12_2 and L11_2 then
          L12_2 = type
          L13_2 = L11_2.art
          L12_2 = L12_2(L13_2)
          if "table" == L12_2 then
            L12_2 = L11_2.art
            if L12_2 then
              goto lbl_165
            end
          end
          L12_2 = {}
          ::lbl_165::
          L13_2 = {}
          L14_2 = L31_1
          L15_2 = L11_2.id
          L16_2 = 48
          L14_2 = L14_2(L15_2, L16_2)
          L13_2.id = L14_2
          L14_2 = L31_1
          L15_2 = L11_2.vid
          L16_2 = 24
          L14_2 = L14_2(L15_2, L16_2)
          L13_2.vid = L14_2
          L14_2 = L31_1
          L15_2 = L11_2.title
          L16_2 = 80
          L14_2 = L14_2(L15_2, L16_2)
          if not L14_2 then
            L14_2 = "Musica"
          end
          L13_2.title = L14_2
          L14_2 = L31_1
          L15_2 = L11_2.artist
          L16_2 = 80
          L14_2 = L14_2(L15_2, L16_2)
          L13_2.artist = L14_2
          L14_2 = {}
          L15_2 = L30_1
          L16_2 = L12_2[1]
          L15_2 = L15_2(L16_2)
          if not L15_2 then
            L15_2 = "#833AB4"
          end
          L16_2 = L30_1
          L17_2 = L12_2[2]
          L16_2 = L16_2(L17_2)
          if not L16_2 then
            L16_2 = "#FD1D1D"
          end
          L14_2[1] = L15_2
          L14_2[2] = L16_2
          L13_2.art = L14_2
          L14_2 = math
          L14_2 = L14_2.floor
          L15_2 = L29_1
          L16_2 = L11_2.start
          L17_2 = 0
          L18_2 = 36000
          L19_2 = 0
          L15_2, L16_2, L17_2, L18_2, L19_2 = L15_2(L16_2, L17_2, L18_2, L19_2)
          L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
          L13_2.start = L14_2
          L14_2 = math
          L14_2 = L14_2.floor
          L15_2 = L29_1
          L16_2 = L11_2.len
          L17_2 = 1
          L18_2 = 60
          L19_2 = 15
          L15_2, L16_2, L17_2, L18_2, L19_2 = L15_2(L16_2, L17_2, L18_2, L19_2)
          L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
          L13_2.len = L14_2
          L9_2.data = L13_2
        else
          L12_2 = L8_2.type
          if "poll" ~= L12_2 then
            L12_2 = L8_2.type
          end
          if "question" == L12_2 and L11_2 then
            L12_2 = {}
            L13_2 = L31_1
            L14_2 = L11_2.q
            L15_2 = 120
            L13_2 = L13_2(L14_2, L15_2)
            if not L13_2 then
              L13_2 = "Pergunta"
            end
            L12_2.q = L13_2
            L13_2 = L31_1
            L14_2 = L11_2.a
            L15_2 = 40
            L13_2 = L13_2(L14_2, L15_2)
            L12_2.a = L13_2
            L13_2 = L31_1
            L14_2 = L11_2.b
            L15_2 = 40
            L13_2 = L13_2(L14_2, L15_2)
            L12_2.b = L13_2
            L9_2.data = L12_2
          end
        end
        L12_2 = #L2_2
        L12_2 = L12_2 + 1
        L2_2[L12_2] = L9_2
        L12_2 = #L2_2
        if A1_2 <= L12_2 then
          break
        end
      end
    end
  end
  return L2_2
end
L33_1 = RPC
function L34_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noprofile"
    return L3_2
  end
  L3_2 = Config
  L3_2 = L3_2.Stories
  if not L3_2 then
    L3_2 = {}
  end
  L4_2 = tonumber
  L5_2 = L3_2.maxLayers
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 24
  end
  L5_2 = type
  L6_2 = A1_2.layers
  L5_2 = L5_2(L6_2)
  if "table" == L5_2 then
    L5_2 = A1_2.layers
    L5_2 = #L5_2
    if L4_2 < L5_2 then
      L5_2 = {}
      L5_2.error = "toolayers"
      return L5_2
    end
  end
  L5_2 = L32_1
  L6_2 = A1_2.layers
  L7_2 = L4_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = A1_2.image
  if not L6_2 then
    L6_2 = A1_2.bg
    if not L6_2 then
      L6_2 = #L5_2
      if 0 == L6_2 then
        L6_2 = A1_2.hasMedia
        if not L6_2 then
          L6_2 = {}
          L6_2.error = "empty"
          return L6_2
        end
      end
    end
  end
  L6_2 = MySQL
  L6_2 = L6_2.scalar
  L6_2 = L6_2.await
  L7_2 = "SELECT COUNT(*) FROM apex_phone_stories WHERE app = ? AND author = ? AND expires > ?"
  L8_2 = {}
  L9_2 = A1_2.app
  L10_2 = L2_2
  L11_2 = Now
  L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2 = L11_2()
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L8_2[4] = L12_2
  L8_2[5] = L13_2
  L8_2[6] = L14_2
  L8_2[7] = L15_2
  L8_2[8] = L16_2
  L8_2[9] = L17_2
  L8_2[10] = L18_2
  L8_2[11] = L19_2
  L8_2[12] = L20_2
  L8_2[13] = L21_2
  L8_2[14] = L22_2
  L8_2[15] = L23_2
  L8_2[16] = L24_2
  L8_2[17] = L25_2
  L8_2[18] = L26_2
  L8_2[19] = L27_2
  L8_2[20] = L28_2
  L8_2[21] = L29_2
  L8_2[22] = L30_2
  L8_2[23] = L31_2
  L8_2[24] = L32_2
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = 0
  end
  L7_2 = tonumber
  L8_2 = L3_2.maxPerUser
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 20
  end
  if L6_2 >= L7_2 then
    L7_2 = {}
    L7_2.error = "toomany"
    return L7_2
  end
  L7_2 = nil
  L8_2 = ipairs
  L9_2 = L5_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L13_2.type
    if "text" == L14_2 and not L7_2 then
      L7_2 = L13_2
    end
  end
  L8_2 = Now
  L8_2 = L8_2()
  L9_2 = MySQL
  L9_2 = L9_2.insert
  L9_2 = L9_2.await
  L10_2 = [[
INSERT INTO apex_phone_stories
        (app, author, image, text, tx, ty, tsize, tcolor, loc, created, expires, layers, bg, draw, duration, close_friends)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)]]
  L11_2 = {}
  L12_2 = A1_2.app
  L13_2 = L2_2
  L14_2 = type
  L15_2 = A1_2.image
  L14_2 = L14_2(L15_2)
  if "number" == L14_2 then
    L14_2 = tostring
    L15_2 = A1_2.image
    L14_2 = L14_2(L15_2)
    if L14_2 then
      goto lbl_118
    end
  end
  L14_2 = nil
  ::lbl_118::
  if L7_2 then
    L15_2 = tostring
    L16_2 = L7_2.text
    if not L16_2 then
      L16_2 = ""
    end
    L15_2 = L15_2(L16_2)
    L16_2 = L15_2
    L15_2 = L15_2.sub
    L17_2 = 1
    L18_2 = 160
    L15_2 = L15_2(L16_2, L17_2, L18_2)
    if L15_2 then
      goto lbl_145
    end
  end
  L15_2 = A1_2.text
  if L15_2 then
    L15_2 = tostring
    L16_2 = A1_2.text
    L15_2 = L15_2(L16_2)
    L16_2 = L15_2
    L15_2 = L15_2.sub
    L17_2 = 1
    L18_2 = 160
    L15_2 = L15_2(L16_2, L17_2, L18_2)
    if L15_2 then
      goto lbl_145
    end
  end
  L15_2 = nil
  ::lbl_145::
  L16_2 = tonumber
  L17_2 = L7_2 or L17_2
  if L7_2 then
    L17_2 = L7_2.x
  end
  L16_2 = L16_2(L17_2)
  if not L16_2 then
    L16_2 = tonumber
    L17_2 = A1_2.tx
    L16_2 = L16_2(L17_2)
    if not L16_2 then
      L16_2 = 0.5
    end
  end
  L17_2 = tonumber
  L18_2 = L7_2 or L18_2
  if L7_2 then
    L18_2 = L7_2.y
  end
  L17_2 = L17_2(L18_2)
  if not L17_2 then
    L17_2 = tonumber
    L18_2 = A1_2.ty
    L17_2 = L17_2(L18_2)
    if not L17_2 then
      L17_2 = 0.5
    end
  end
  L18_2 = math
  L18_2 = L18_2.floor
  L19_2 = tonumber
  L20_2 = L7_2 or L20_2
  if L7_2 then
    L20_2 = L7_2.size
  end
  L19_2 = L19_2(L20_2)
  if not L19_2 then
    L19_2 = tonumber
    L20_2 = A1_2.tsize
    L19_2 = L19_2(L20_2)
    if not L19_2 then
      L19_2 = 28
    end
  end
  L18_2 = L18_2(L19_2)
  if L7_2 then
    L19_2 = L7_2.color
    if L19_2 then
      L19_2 = tostring
      L20_2 = L7_2.color
      L19_2 = L19_2(L20_2)
      L20_2 = L19_2
      L19_2 = L19_2.sub
      L21_2 = 1
      L22_2 = 10
      L19_2 = L19_2(L20_2, L21_2, L22_2)
      if L19_2 then
        goto lbl_214
      end
    end
  end
  L19_2 = A1_2.tcolor
  if L19_2 then
    L19_2 = tostring
    L20_2 = A1_2.tcolor
    L19_2 = L19_2(L20_2)
    L20_2 = L19_2
    L19_2 = L19_2.sub
    L21_2 = 1
    L22_2 = 10
    L19_2 = L19_2(L20_2, L21_2, L22_2)
    if L19_2 then
      goto lbl_214
    end
  end
  L19_2 = "#FFFFFF"
  ::lbl_214::
  L20_2 = A1_2.loc
  if L20_2 then
    L20_2 = tostring
    L21_2 = A1_2.loc
    L20_2 = L20_2(L21_2)
    L21_2 = L20_2
    L20_2 = L20_2.sub
    L22_2 = 1
    L23_2 = 40
    L20_2 = L20_2(L21_2, L22_2, L23_2)
    if L20_2 then
      goto lbl_227
    end
  end
  L20_2 = nil
  ::lbl_227::
  L21_2 = L8_2
  L22_2 = L22_1
  L22_2 = L22_2()
  L22_2 = L8_2 + L22_2
  L23_2 = #L5_2
  if L23_2 > 0 then
    L23_2 = json
    L23_2 = L23_2.encode
    L24_2 = L5_2
    L23_2 = L23_2(L24_2)
    if L23_2 then
      goto lbl_242
    end
  end
  L23_2 = nil
  ::lbl_242::
  L24_2 = A1_2.bg
  if L24_2 then
    L24_2 = tostring
    L25_2 = A1_2.bg
    L24_2 = L24_2(L25_2)
    L25_2 = L24_2
    L24_2 = L24_2.sub
    L26_2 = 1
    L27_2 = 20
    L24_2 = L24_2(L25_2, L26_2, L27_2)
    if L24_2 then
      goto lbl_255
    end
  end
  L24_2 = nil
  ::lbl_255::
  L25_2 = nil
  L26_2 = math
  L26_2 = L26_2.max
  L27_2 = 3
  L28_2 = math
  L28_2 = L28_2.min
  L29_2 = 15
  L30_2 = math
  L30_2 = L30_2.floor
  L31_2 = tonumber
  L32_2 = A1_2.duration
  L31_2 = L31_2(L32_2)
  if not L31_2 then
    L31_2 = tonumber
    L32_2 = L3_2.duration
    L31_2 = L31_2(L32_2)
    if not L31_2 then
      L31_2 = 5
    end
  end
  L30_2 = L30_2(L31_2)
  L28_2 = L28_2(L29_2, L30_2)
  L26_2 = L26_2(L27_2, L28_2)
  L27_2 = A1_2.closeFriends
  if L27_2 then
    L27_2 = 1
    if L27_2 then
      goto lbl_285
    end
  end
  L27_2 = 0
  ::lbl_285::
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L11_2[5] = L16_2
  L11_2[6] = L17_2
  L11_2[7] = L18_2
  L11_2[8] = L19_2
  L11_2[9] = L20_2
  L11_2[10] = L21_2
  L11_2[11] = L22_2
  L11_2[12] = L23_2
  L11_2[13] = L24_2
  L11_2[14] = L25_2
  L11_2[15] = L26_2
  L11_2[16] = L27_2
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = ipairs
  L11_2 = L5_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = L15_2.type
    if "mention" == L16_2 then
      L16_2 = L15_2.text
      if L16_2 then
        L16_2 = tostring
        L17_2 = L15_2.text
        L16_2 = L16_2(L17_2)
        L17_2 = L16_2
        L16_2 = L16_2.gsub
        L18_2 = "^@"
        L19_2 = ""
        L16_2 = L16_2(L17_2, L18_2, L19_2)
        L17_2 = L1_1
        L18_2 = A1_2.app
        L19_2 = L16_2
        L17_2 = L17_2(L18_2, L19_2)
        if L17_2 then
          L18_2 = L17_2.username
          if L18_2 ~= L2_2 then
            L18_2 = NotifyCitizen
            L19_2 = L17_2.owner
            L20_2 = A1_2.app
            L21_2 = "@"
            L22_2 = L2_2
            L23_2 = " mencionou-te"
            L21_2 = L21_2 .. L22_2 .. L23_2
            L22_2 = "Apareces numa story."
            L23_2 = {}
            L23_2.sys = true
            L18_2(L19_2, L20_2, L21_2, L22_2, L23_2)
          end
        end
      end
    end
  end
  L10_2 = {}
  L10_2.ok = true
  L10_2.id = L9_2
  return L10_2
end
L33_1["social.story.add"] = L34_1
L33_1 = RPC
function L34_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noprofile"
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT author FROM apex_phone_stories WHERE id = ?"
  L5_2 = {}
  L6_2 = A1_2.id
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "gone"
    return L4_2
  end
  L4_2 = L3_2.author
  if L4_2 == L2_2 then
    L4_2 = {}
    L4_2.ok = true
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.insert
  L4_2 = L4_2.await
  L5_2 = "INSERT IGNORE INTO apex_phone_story_views (story_id, username, liked, created) VALUES (?, ?, 0, ?)"
  L6_2 = {}
  L7_2 = A1_2.id
  L8_2 = L2_2
  L9_2 = Now
  L9_2 = L9_2()
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L4_2(L5_2, L6_2)
  L4_2 = A1_2.liked
  if nil ~= L4_2 then
    L4_2 = MySQL
    L4_2 = L4_2.update
    L5_2 = "UPDATE apex_phone_story_views SET liked = ? WHERE story_id = ? AND username = ?"
    L6_2 = {}
    L7_2 = A1_2.liked
    if L7_2 then
      L7_2 = 1
      if L7_2 then
        goto lbl_60
      end
    end
    L7_2 = 0
    ::lbl_60::
    L8_2 = A1_2.id
    L9_2 = L2_2
    L6_2[1] = L7_2
    L6_2[2] = L8_2
    L6_2[3] = L9_2
    L4_2(L5_2, L6_2)
  end
  L4_2 = {}
  L4_2.ok = true
  return L4_2
end
L33_1["social.story.view"] = L34_1
L33_1 = RPC
function L34_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noprofile"
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT author FROM apex_phone_stories WHERE id = ?"
  L5_2 = {}
  L6_2 = A1_2.id
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L3_2.author
    if L4_2 == L2_2 then
      goto lbl_29
    end
  end
  L4_2 = {}
  L4_2.error = "forbidden"
  do return L4_2 end
  ::lbl_29::
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "DELETE FROM apex_phone_story_views WHERE story_id = ?"
  L6_2 = {}
  L7_2 = A1_2.id
  L6_2[1] = L7_2
  L4_2(L5_2, L6_2)
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "DELETE FROM apex_phone_story_answers WHERE story_id = ?"
  L6_2 = {}
  L7_2 = A1_2.id
  L6_2[1] = L7_2
  L4_2(L5_2, L6_2)
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "DELETE FROM apex_phone_stories WHERE id = ?"
  L6_2 = {}
  L7_2 = A1_2.id
  L6_2[1] = L7_2
  L4_2(L5_2, L6_2)
  L4_2 = {}
  L4_2.ok = true
  return L4_2
end
L33_1["social.story.delete"] = L34_1
L33_1 = RPC
function L34_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT author FROM apex_phone_stories WHERE id = ?"
  L5_2 = {}
  L6_2 = A1_2.id
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L3_2.author
    if L4_2 == L2_2 then
      goto lbl_27
    end
  end
  L4_2 = {}
  do return L4_2 end
  ::lbl_27::
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "SELECT username, liked FROM apex_phone_story_views WHERE story_id = ? ORDER BY created DESC LIMIT 200"
  L6_2 = {}
  L7_2 = A1_2.id
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L5_2 = {}
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L4_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = #L5_2
    L13_2 = L13_2 + 1
    L14_2 = L12_2.username
    L5_2[L13_2] = L14_2
    L13_2 = L12_2.username
    L14_2 = tonumber
    L15_2 = L12_2.liked
    L14_2 = L14_2(L15_2)
    if not L14_2 then
      L14_2 = 0
    end
    L14_2 = 1 == L14_2
    L6_2[L13_2] = L14_2
  end
  L7_2 = L21_1
  L8_2 = A1_2.app
  L9_2 = L5_2
  L10_2 = L2_2
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L8_2 = ipairs
  L9_2 = L7_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L13_2.username
    L14_2 = L6_2[L14_2]
    L14_2 = true == L14_2
    L13_2.liked = L14_2
  end
  return L7_2
end
L33_1["social.story.viewers"] = L34_1
L33_1 = 48000
function L34_1()
  local L0_2, L1_2
  L0_2 = Config
  L0_2 = L0_2.Instants
  if not L0_2 then
    L0_2 = {}
  end
  L0_2 = L0_2.enabled
  L0_2 = false ~= L0_2
  return L0_2
end
function L35_1()
  local L0_2, L1_2, L2_2
  L0_2 = tonumber
  L1_2 = Config
  L1_2 = L1_2.Instants
  if not L1_2 then
    L1_2 = {}
  end
  L1_2 = L1_2.hours
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = 24
  end
  if L0_2 <= 0 then
    L0_2 = 24
  end
  L1_2 = math
  L1_2 = L1_2.floor
  L2_2 = L0_2 * 3600000
  return L1_2(L2_2)
end
function L36_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = MySQL
  L0_2 = L0_2.query
  L0_2 = L0_2.await
  L1_2 = "SELECT id FROM apex_phone_instants WHERE expires < ? LIMIT 500"
  L2_2 = {}
  L3_2 = Now
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = L3_2()
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L2_2[4] = L6_2
  L2_2[5] = L7_2
  L2_2[6] = L8_2
  L2_2[7] = L9_2
  L0_2 = L0_2(L1_2, L2_2)
  if not L0_2 then
    L0_2 = {}
  end
  L1_2 = #L0_2
  if 0 == L1_2 then
    return
  end
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = L0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = #L1_2
    L8_2 = L8_2 + 1
    L9_2 = L7_2.id
    L1_2[L8_2] = L9_2
  end
  L2_2 = table
  L2_2 = L2_2.concat
  L3_2 = L1_2
  L4_2 = ","
  L2_2 = L2_2(L3_2, L4_2)
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM apex_phone_instant_views WHERE instant_id IN ("
  L5_2 = L2_2
  L6_2 = ")"
  L4_2 = L4_2 .. L5_2 .. L6_2
  L3_2(L4_2)
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM apex_phone_instants WHERE id IN ("
  L5_2 = L2_2
  L6_2 = ")"
  L4_2 = L4_2 .. L5_2 .. L6_2
  L3_2(L4_2)
end
L37_1 = CreateThread
function L38_1()
  local L0_2, L1_2
  while true do
    L0_2 = Wait
    L1_2 = 600000
    L0_2(L1_2)
    L0_2 = pcall
    L1_2 = L36_1
    L0_2(L1_2)
  end
end
L37_1(L38_1)
function L37_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  if not A1_2 or not A2_2 then
    L4_2 = false
    return L4_2
  end
  if A2_2 == A1_2 then
    L4_2 = true
    return L4_2
  end
  if "mutuals" == A3_2 then
    L4_2 = MySQL
    L4_2 = L4_2.single
    L4_2 = L4_2.await
    L5_2 = "SELECT 1 AS ok FROM apex_phone_follows WHERE app = ? AND follower = ? AND followed = ?"
    L6_2 = {}
    L7_2 = A0_2
    L8_2 = A1_2
    L9_2 = A2_2
    L6_2[1] = L7_2
    L6_2[2] = L8_2
    L6_2[3] = L9_2
    L4_2 = L4_2(L5_2, L6_2)
    if not L4_2 then
      L5_2 = false
      return L5_2
    end
    L5_2 = MySQL
    L5_2 = L5_2.single
    L5_2 = L5_2.await
    L6_2 = "SELECT 1 AS ok FROM apex_phone_follows WHERE app = ? AND follower = ? AND followed = ?"
    L7_2 = {}
    L8_2 = A0_2
    L9_2 = A2_2
    L10_2 = A1_2
    L7_2[1] = L8_2
    L7_2[2] = L9_2
    L7_2[3] = L10_2
    L5_2 = L5_2(L6_2, L7_2)
    L6_2 = nil ~= L5_2
    return L6_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.single
  L4_2 = L4_2.await
  L5_2 = "SELECT friend FROM apex_phone_close_friends WHERE app = ? AND owner = ? AND friend = ?"
  L6_2 = {}
  L7_2 = A0_2
  L8_2 = A2_2
  L9_2 = A1_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L4_2 = L4_2(L5_2, L6_2)
  L4_2 = nil ~= L4_2
  return L4_2
end
L38_1 = RPC
function L39_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = L34_1
  L2_2 = L2_2()
  if not L2_2 then
    L2_2 = {}
    L3_2 = {}
    L2_2.inbox = L3_2
    L3_2 = {}
    L2_2.mine = L3_2
    L2_2.off = true
    return L2_2
  end
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L4_2 = {}
    L3_2.inbox = L4_2
    L4_2 = {}
    L3_2.mine = L4_2
    return L3_2
  end
  L3_2 = Now
  L3_2 = L3_2()
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = [[
        SELECT i.id, i.author, i.created, i.expires, i.audience, i.text, i.ty, i.tsize,
               CHAR_LENGTH(i.image) AS image_len, a.avatar, a.owner
          FROM apex_phone_instants i
          LEFT JOIN apex_phone_social_accounts a ON a.app = i.app AND a.username = i.author
         WHERE i.app = ? AND i.expires > ? AND i.ready = 1 AND i.author <> ?
           AND NOT EXISTS (SELECT 1 FROM apex_phone_instant_views v WHERE v.instant_id = i.id AND v.username = ?)
           AND (
                (i.audience = 'close' AND EXISTS (
                    SELECT 1 FROM apex_phone_close_friends c
                     WHERE c.app = i.app AND c.owner = i.author AND c.friend = ?))
             OR (i.audience = 'mutuals'
                 AND EXISTS (SELECT 1 FROM apex_phone_follows f1 WHERE f1.app = i.app AND f1.follower = ?  AND f1.followed = i.author)
                 AND EXISTS (SELECT 1 FROM apex_phone_follows f2 WHERE f2.app = i.app AND f2.follower = i.author AND f2.followed = ?))
           )
         ORDER BY i.created ASC LIMIT 30]]
  L6_2 = {}
  L7_2 = A1_2.app
  L8_2 = L3_2
  L9_2 = L2_2
  L10_2 = L2_2
  L11_2 = L2_2
  L12_2 = L2_2
  L13_2 = L2_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L6_2[5] = L11_2
  L6_2[6] = L12_2
  L6_2[7] = L13_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = [[
        SELECT i.id, i.created, i.expires, i.audience, i.text, CHAR_LENGTH(i.image) AS image_len,
               (SELECT COUNT(*) FROM apex_phone_instant_views v WHERE v.instant_id = i.id) AS views
          FROM apex_phone_instants i
         WHERE i.app = ? AND i.author = ? AND i.expires > ? AND i.ready = 1
         ORDER BY i.created DESC LIMIT 10]]
  L7_2 = {}
  L8_2 = A1_2.app
  L9_2 = L2_2
  L10_2 = L3_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
  end
  function L6_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3
    L2_3 = {}
    L3_3 = ipairs
    L4_3 = A0_3
    L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
    for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
      L9_3 = false
      if not A1_3 then
        L10_3 = L8_3.owner
        if L10_3 then
          L10_3 = FW
          L10_3 = L10_3.GetPlayerByCid
          L11_3 = L8_3.owner
          L10_3 = L10_3(L11_3)
          L9_3 = nil ~= L10_3
        end
      end
      L10_3 = #L2_3
      L10_3 = L10_3 + 1
      L11_3 = {}
      L12_3 = L8_3.id
      L11_3.id = L12_3
      if A1_3 then
        L12_3 = L2_2
        if L12_3 then
          goto lbl_34
        end
      end
      L12_3 = L8_3.author
      ::lbl_34::
      L11_3.author = L12_3
      L12_3 = L9_3 or L12_3
      if not L9_3 then
        L12_3 = nil
      end
      L11_3.online = L12_3
      L12_3 = tonumber
      L13_3 = L8_3.created
      L12_3 = L12_3(L13_3)
      L11_3.created = L12_3
      L12_3 = tonumber
      L13_3 = L8_3.expires
      L12_3 = L12_3(L13_3)
      L11_3.expires = L12_3
      L12_3 = L8_3.audience
      L11_3.audience = L12_3
      L12_3 = L8_3.text
      L11_3.text = L12_3
      L12_3 = tonumber
      L13_3 = L8_3.ty
      L12_3 = L12_3(L13_3)
      if not L12_3 then
        L12_3 = 0.8
      end
      L11_3.ty = L12_3
      L12_3 = math
      L12_3 = L12_3.tointeger
      L13_3 = tonumber
      L14_3 = L8_3.tsize
      L13_3 = L13_3(L14_3)
      if not L13_3 then
        L13_3 = 30
      end
      L12_3 = L12_3(L13_3)
      if not L12_3 then
        L12_3 = 30
      end
      L11_3.tsize = L12_3
      L12_3 = math
      L12_3 = L12_3.tointeger
      L13_3 = tonumber
      L14_3 = L8_3.image_len
      L13_3 = L13_3(L14_3)
      if not L13_3 then
        L13_3 = 0
      end
      L12_3 = L12_3(L13_3)
      if not L12_3 then
        L12_3 = 0
      end
      L11_3.imageLen = L12_3
      L12_3 = L8_3.avatar
      if L12_3 then
        L12_3 = tonumber
        L13_3 = L8_3.avatar
        L12_3 = L12_3(L13_3)
        if L12_3 then
          goto lbl_96
        end
        L12_3 = L8_3.avatar
        if L12_3 then
          goto lbl_96
        end
      end
      L12_3 = 1
      ::lbl_96::
      L11_3.avatar = L12_3
      if A1_3 then
        L12_3 = math
        L12_3 = L12_3.tointeger
        L13_3 = tonumber
        L14_3 = L8_3.views
        L13_3 = L13_3(L14_3)
        if not L13_3 then
          L13_3 = 0
        end
        L12_3 = L12_3(L13_3)
        if L12_3 then
          goto lbl_114
        end
        L12_3 = 0
        if L12_3 then
          goto lbl_114
        end
      end
      L12_3 = nil
      ::lbl_114::
      L11_3.views = L12_3
      L12_3 = A1_3 or L12_3
      if not A1_3 then
        L12_3 = nil
      end
      L11_3.mine = L12_3
      L2_3[L10_3] = L11_3
    end
    return L2_3
  end
  L7_2 = {}
  L8_2 = L6_2
  L9_2 = L4_2
  L10_2 = false
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.inbox = L8_2
  L8_2 = L6_2
  L9_2 = L5_2
  L10_2 = true
  L8_2 = L8_2(L9_2, L10_2)
  L7_2.mine = L8_2
  L8_2 = L33_1
  L7_2.chunk = L8_2
  return L7_2
end
L38_1["social.instant.list"] = L39_1
L38_1 = RPC
function L39_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L2_2 = L34_1
  L2_2 = L2_2()
  if not L2_2 then
    L2_2 = {}
    L2_2.error = "off"
    return L2_2
  end
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noprofile"
    return L3_2
  end
  L3_2 = Config
  L3_2 = L3_2.Instants
  if not L3_2 then
    L3_2 = {}
  end
  L4_2 = A1_2.audience
  if "mutuals" == L4_2 then
    L4_2 = "mutuals"
    if L4_2 then
      goto lbl_32
    end
  end
  L4_2 = "close"
  ::lbl_32::
  L5_2 = MySQL
  L5_2 = L5_2.scalar
  L5_2 = L5_2.await
  L6_2 = "SELECT COUNT(*) FROM apex_phone_instants WHERE app = ? AND author = ? AND expires > ?"
  L7_2 = {}
  L8_2 = A1_2.app
  L9_2 = L2_2
  L10_2 = Now
  L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L10_2()
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L7_2[5] = L12_2
  L7_2[6] = L13_2
  L7_2[7] = L14_2
  L7_2[8] = L15_2
  L7_2[9] = L16_2
  L7_2[10] = L17_2
  L7_2[11] = L18_2
  L7_2[12] = L19_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = 0
  end
  L6_2 = tonumber
  L7_2 = L3_2.maxPerUser
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 10
  end
  if L5_2 >= L6_2 then
    L6_2 = {}
    L6_2.error = "toomany"
    return L6_2
  end
  L6_2 = Now
  L6_2 = L6_2()
  L7_2 = MySQL
  L7_2 = L7_2.insert
  L7_2 = L7_2.await
  L8_2 = [[
INSERT INTO apex_phone_instants
        (app, author, image, text, ty, tsize, audience, ready, created, expires)
        VALUES (?, ?, NULL, ?, ?, ?, ?, 0, ?, ?)]]
  L9_2 = {}
  L10_2 = A1_2.app
  L11_2 = L2_2
  L12_2 = L31_1
  L13_2 = A1_2.text
  L14_2 = math
  L14_2 = L14_2.floor
  L15_2 = tonumber
  L16_2 = L3_2.maxText
  L15_2 = L15_2(L16_2)
  if not L15_2 then
    L15_2 = 120
  end
  L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L14_2(L15_2)
  L12_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
  L13_2 = L29_1
  L14_2 = A1_2.ty
  L15_2 = 0.05
  L16_2 = 0.95
  L17_2 = 0.8
  L13_2 = L13_2(L14_2, L15_2, L16_2, L17_2)
  L14_2 = math
  L14_2 = L14_2.floor
  L15_2 = L29_1
  L16_2 = A1_2.tsize
  L17_2 = 18
  L18_2 = 48
  L19_2 = 30
  L15_2, L16_2, L17_2, L18_2, L19_2 = L15_2(L16_2, L17_2, L18_2, L19_2)
  L14_2 = L14_2(L15_2, L16_2, L17_2, L18_2, L19_2)
  L15_2 = L4_2
  L16_2 = L6_2
  L17_2 = L35_1
  L17_2 = L17_2()
  L17_2 = L6_2 + L17_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L9_2[5] = L14_2
  L9_2[6] = L15_2
  L9_2[7] = L16_2
  L9_2[8] = L17_2
  L7_2 = L7_2(L8_2, L9_2)
  if not L7_2 then
    L8_2 = {}
    L8_2.error = "internal"
    return L8_2
  end
  L8_2 = {}
  L8_2.ok = true
  L8_2.id = L7_2
  L9_2 = L33_1
  L8_2.chunk = L9_2
  return L8_2
end
L38_1["social.instant.add"] = L39_1
function L38_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = math
  L1_2 = L1_2.tointeger
  L2_2 = tonumber
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 0
  end
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  if not A0_2 or A0_2 < 1 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = MySQL
  L1_2 = L1_2.single
  L1_2 = L1_2.await
  L2_2 = "SELECT id, app, author, audience, ready, expires, CHAR_LENGTH(image) AS len FROM apex_phone_instants WHERE id = ?"
  L3_2 = {}
  L4_2 = A0_2
  L3_2[1] = L4_2
  return L1_2(L2_2, L3_2)
end
L39_1 = RPC
function L40_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = tostring
  L3_2 = A1_2.data
  if not L3_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = L38_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = #L2_2
    L5_2 = L33_1
    L5_2 = L5_2 + 64
    if not (L4_2 > L5_2) then
      goto lbl_22
    end
  end
  L4_2 = {}
  L4_2.error = "badchunk"
  do return L4_2 end
  ::lbl_22::
  L4_2 = L3_2.id
  L5_2 = L0_1
  L6_2 = A0_2
  L7_2 = L3_2.app
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L6_2 = {}
    L6_2.error = "noprofile"
    return L6_2
  end
  L6_2 = L3_2.author
  if L6_2 ~= L5_2 then
    L6_2 = {}
    L6_2.error = "forbidden"
    return L6_2
  end
  L6_2 = tonumber
  L7_2 = L3_2.ready
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  if 1 == L6_2 then
    L6_2 = {}
    L6_2.error = "sent"
    return L6_2
  end
  L6_2 = tonumber
  L7_2 = A1_2.i
  L6_2 = L6_2(L7_2)
  if 1 == L6_2 then
    L6_2 = MySQL
    L6_2 = L6_2.update
    L6_2 = L6_2.await
    L7_2 = "UPDATE apex_phone_instants SET image = ? WHERE id = ?"
    L8_2 = {}
    L9_2 = L2_2
    L10_2 = L4_2
    L8_2[1] = L9_2
    L8_2[2] = L10_2
    L6_2(L7_2, L8_2)
  else
    L6_2 = MySQL
    L6_2 = L6_2.update
    L6_2 = L6_2.await
    L7_2 = "UPDATE apex_phone_instants SET image = CONCAT(COALESCE(image, \"\"), ?) WHERE id = ?"
    L8_2 = {}
    L9_2 = L2_2
    L10_2 = L4_2
    L8_2[1] = L9_2
    L8_2[2] = L10_2
    L6_2(L7_2, L8_2)
  end
  L6_2 = MySQL
  L6_2 = L6_2.scalar
  L6_2 = L6_2.await
  L7_2 = "SELECT CHAR_LENGTH(image) FROM apex_phone_instants WHERE id = ?"
  L8_2 = {}
  L9_2 = L4_2
  L8_2[1] = L9_2
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L6_2 = 0
  end
  L7_2 = 300000
  if L6_2 > L7_2 then
    L7_2 = MySQL
    L7_2 = L7_2.query
    L7_2 = L7_2.await
    L8_2 = "DELETE FROM apex_phone_instants WHERE id = ?"
    L9_2 = {}
    L10_2 = L4_2
    L9_2[1] = L10_2
    L7_2(L8_2, L9_2)
    L7_2 = {}
    L7_2.error = "toolarge"
    return L7_2
  end
  L7_2 = {}
  L7_2.ok = true
  L7_2.len = L6_2
  return L7_2
end
L39_1["social.instant.upload"] = L40_1
L39_1 = RPC
function L40_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2
  L2_2 = L38_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "invalid"
    return L3_2
  end
  L3_2 = L2_2.id
  L4_2 = L2_2.app
  L5_2 = L0_1
  L6_2 = A0_2
  L7_2 = L4_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L6_2 = {}
    L6_2.error = "noprofile"
    return L6_2
  end
  L6_2 = L2_2.author
  if L6_2 ~= L5_2 then
    L6_2 = {}
    L6_2.error = "forbidden"
    return L6_2
  end
  L6_2 = tonumber
  L7_2 = L2_2.ready
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  if 1 == L6_2 then
    L6_2 = {}
    L6_2.ok = true
    return L6_2
  end
  L6_2 = tonumber
  L7_2 = L2_2.len
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  if L6_2 < 100 then
    L6_2 = MySQL
    L6_2 = L6_2.query
    L6_2 = L6_2.await
    L7_2 = "DELETE FROM apex_phone_instants WHERE id = ?"
    L8_2 = {}
    L9_2 = L3_2
    L8_2[1] = L9_2
    L6_2(L7_2, L8_2)
    L6_2 = {}
    L6_2.error = "empty"
    return L6_2
  end
  L6_2 = MySQL
  L6_2 = L6_2.update
  L6_2 = L6_2.await
  L7_2 = "UPDATE apex_phone_instants SET ready = 1 WHERE id = ?"
  L8_2 = {}
  L9_2 = L3_2
  L8_2[1] = L9_2
  L6_2(L7_2, L8_2)
  L6_2 = Config
  L6_2 = L6_2.Instants
  if not L6_2 then
    L6_2 = {}
  end
  L6_2 = L6_2.notify
  if false ~= L6_2 then
    L6_2 = nil
    L7_2 = L2_2.audience
    if "mutuals" == L7_2 then
      L7_2 = MySQL
      L7_2 = L7_2.query
      L7_2 = L7_2.await
      L8_2 = [[
                SELECT a.owner FROM apex_phone_follows f1
                  JOIN apex_phone_follows f2 ON f2.app = f1.app AND f2.follower = f1.followed AND f2.followed = f1.follower
                  JOIN apex_phone_social_accounts a ON a.app = f1.app AND a.username = f1.followed
                 WHERE f1.app = ? AND f1.follower = ? LIMIT 60]]
      L9_2 = {}
      L10_2 = L4_2
      L11_2 = L5_2
      L9_2[1] = L10_2
      L9_2[2] = L11_2
      L7_2 = L7_2(L8_2, L9_2)
      L6_2 = L7_2
    else
      L7_2 = MySQL
      L7_2 = L7_2.query
      L7_2 = L7_2.await
      L8_2 = [[
                SELECT a.owner FROM apex_phone_close_friends c
                  JOIN apex_phone_social_accounts a ON a.app = c.app AND a.username = c.friend
                 WHERE c.app = ? AND c.owner = ? LIMIT 60]]
      L9_2 = {}
      L10_2 = L4_2
      L11_2 = L5_2
      L9_2[1] = L10_2
      L9_2[2] = L11_2
      L7_2 = L7_2(L8_2, L9_2)
      L6_2 = L7_2
    end
    L7_2 = ipairs
    L8_2 = L6_2 or L8_2
    if not L6_2 then
      L8_2 = {}
    end
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      L13_2 = L12_2.owner
      if L13_2 then
        L13_2 = NotifyCitizen
        L14_2 = L12_2.owner
        L15_2 = L4_2
        L16_2 = "@"
        L17_2 = L5_2
        L18_2 = " enviou um Instant"
        L16_2 = L16_2 .. L17_2 .. L18_2
        L17_2 = "V\195\170 antes de desaparecer: s\195\179 podes ver uma vez."
        L18_2 = {}
        L18_2.sys = true
        L13_2(L14_2, L15_2, L16_2, L17_2, L18_2)
      end
    end
  end
  L6_2 = {}
  L6_2.ok = true
  return L6_2
end
L39_1["social.instant.ready"] = L40_1
L39_1 = RPC
function L40_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = math
  L2_2 = L2_2.tointeger
  L3_2 = tonumber
  L4_2 = A1_2.i
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 1
  end
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = 1
  end
  if L2_2 < 1 or L2_2 > 64 then
    L3_2 = {}
    L3_2.error = "badchunk"
    return L3_2
  end
  L3_2 = L38_1
  L4_2 = A1_2.id
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = tonumber
    L5_2 = L3_2.ready
    L4_2 = L4_2(L5_2)
    if not L4_2 then
      L4_2 = 0
    end
    if 1 == L4_2 then
      L4_2 = tonumber
      L5_2 = L3_2.expires
      L4_2 = L4_2(L5_2)
      if not L4_2 then
        L4_2 = 0
      end
      L5_2 = Now
      L5_2 = L5_2()
      if not (L4_2 <= L5_2) then
        goto lbl_48
      end
    end
  end
  L4_2 = {}
  L4_2.error = "notfound"
  do return L4_2 end
  ::lbl_48::
  L4_2 = L3_2.id
  L5_2 = L0_1
  L6_2 = A0_2
  L7_2 = L3_2.app
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = L37_1
  L7_2 = L3_2.app
  L8_2 = L5_2
  L9_2 = L3_2.author
  L10_2 = L3_2.audience
  L6_2 = L6_2(L7_2, L8_2, L9_2, L10_2)
  if not L6_2 then
    L6_2 = {}
    L6_2.error = "forbidden"
    return L6_2
  end
  L6_2 = L3_2.author
  if L6_2 ~= L5_2 then
    L6_2 = MySQL
    L6_2 = L6_2.single
    L6_2 = L6_2.await
    L7_2 = "SELECT created FROM apex_phone_instant_views WHERE instant_id = ? AND username = ?"
    L8_2 = {}
    L9_2 = L4_2
    L10_2 = L5_2
    L8_2[1] = L9_2
    L8_2[2] = L10_2
    L6_2 = L6_2(L7_2, L8_2)
    if not L6_2 then
      L7_2 = MySQL
      L7_2 = L7_2.insert
      L7_2 = L7_2.await
      L8_2 = "INSERT IGNORE INTO apex_phone_instant_views (instant_id, username, created) VALUES (?, ?, ?)"
      L9_2 = {}
      L10_2 = L4_2
      L11_2 = L5_2
      L12_2 = Now
      L12_2 = L12_2()
      L9_2[1] = L10_2
      L9_2[2] = L11_2
      L9_2[3] = L12_2
      L7_2(L8_2, L9_2)
    else
      L7_2 = Now
      L7_2 = L7_2()
      L8_2 = tonumber
      L9_2 = L6_2.created
      L8_2 = L8_2(L9_2)
      if not L8_2 then
        L8_2 = 0
      end
      L7_2 = L7_2 - L8_2
      L8_2 = 90000
      if L7_2 > L8_2 then
        L7_2 = {}
        L7_2.error = "burned"
        return L7_2
      end
    end
  end
  L6_2 = MySQL
  L6_2 = L6_2.single
  L6_2 = L6_2.await
  L7_2 = "SELECT CHAR_LENGTH(image) AS len, SUBSTRING(image, ?, ?) AS part FROM apex_phone_instants WHERE id = ?"
  L8_2 = {}
  L9_2 = L2_2 - 1
  L10_2 = L33_1
  L9_2 = L9_2 * L10_2
  L9_2 = L9_2 + 1
  L10_2 = L33_1
  L11_2 = L4_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L8_2[3] = L11_2
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L7_2 = {}
    L7_2.error = "notfound"
    return L7_2
  end
  L7_2 = math
  L7_2 = L7_2.tointeger
  L8_2 = tonumber
  L9_2 = L6_2.len
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 0
  end
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 0
  end
  if L7_2 <= 0 then
    L8_2 = {}
    L8_2.i = L2_2
    L8_2.total = 0
    L8_2.len = 0
    L8_2.data = ""
    return L8_2
  end
  L8_2 = {}
  L8_2.i = L2_2
  L9_2 = math
  L9_2 = L9_2.ceil
  L10_2 = L33_1
  L10_2 = L7_2 / L10_2
  L9_2 = L9_2(L10_2)
  L8_2.total = L9_2
  L8_2.len = L7_2
  L9_2 = L6_2.part
  if not L9_2 then
    L9_2 = ""
  end
  L8_2.data = L9_2
  return L8_2
end
L39_1["social.instant.media"] = L40_1
L39_1 = RPC
function L40_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L38_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "gone"
    return L3_2
  end
  L3_2 = tonumber
  L4_2 = L2_2.expires
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 0
  end
  L4_2 = Now
  L4_2 = L4_2()
  if L3_2 <= L4_2 then
    L3_2 = {}
    L3_2.error = "gone"
    return L3_2
  end
  L3_2 = L2_2.id
  L4_2 = L0_1
  L5_2 = A0_2
  L6_2 = L2_2.app
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L5_2 = {}
    L5_2.error = "noprofile"
    return L5_2
  end
  L5_2 = L2_2.author
  if L5_2 == L4_2 then
    L5_2 = {}
    L5_2.ok = true
    L5_2.own = true
    return L5_2
  end
  L5_2 = L37_1
  L6_2 = L2_2.app
  L7_2 = L4_2
  L8_2 = L2_2.author
  L9_2 = L2_2.audience
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  if not L5_2 then
    L5_2 = {}
    L5_2.error = "forbidden"
    return L5_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.insert
  L5_2 = L5_2.await
  L6_2 = "INSERT IGNORE INTO apex_phone_instant_views (instant_id, username, created) VALUES (?, ?, ?)"
  L7_2 = {}
  L8_2 = L3_2
  L9_2 = L4_2
  L10_2 = Now
  L10_2 = L10_2()
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L5_2(L6_2, L7_2)
  L5_2 = {}
  L5_2.ok = true
  return L5_2
end
L39_1["social.instant.view"] = L40_1
L39_1 = RPC
function L40_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L2_2 = L38_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "gone"
    return L3_2
  end
  L3_2 = tonumber
  L4_2 = L2_2.expires
  L3_2 = L3_2(L4_2)
  if not L3_2 then
    L3_2 = 0
  end
  L4_2 = Now
  L4_2 = L4_2()
  if L3_2 <= L4_2 then
    L3_2 = {}
    L3_2.error = "gone"
    return L3_2
  end
  L3_2 = L0_1
  L4_2 = A0_2
  L5_2 = L2_2.app
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = {}
    L4_2.error = "noprofile"
    return L4_2
  end
  L4_2 = L2_2.author
  if L4_2 == L3_2 then
    L4_2 = {}
    L4_2.error = "own"
    return L4_2
  end
  L4_2 = L37_1
  L5_2 = L2_2.app
  L6_2 = L3_2
  L7_2 = L2_2.author
  L8_2 = L2_2.audience
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  if not L4_2 then
    L4_2 = {}
    L4_2.error = "forbidden"
    return L4_2
  end
  L4_2 = {}
  L4_2["\240\159\152\130"] = true
  L4_2["\226\157\164\239\184\143"] = true
  L4_2["\240\159\152\174"] = true
  L4_2["\240\159\145\143"] = true
  L4_2["\240\159\148\165"] = true
  L4_2["\240\159\152\141"] = true
  L4_2["\240\159\152\162"] = true
  L4_2["\240\159\145\141"] = true
  L5_2 = tostring
  L6_2 = A1_2.emoji
  if not L6_2 then
    L6_2 = ""
  end
  L5_2 = L5_2(L6_2)
  L6_2 = L4_2[L5_2]
  if not L6_2 then
    L6_2 = {}
    L6_2.error = "badreaction"
    return L6_2
  end
  L6_2 = MySQL
  L6_2 = L6_2.single
  L6_2 = L6_2.await
  L7_2 = "SELECT instant_id FROM apex_phone_instant_views WHERE instant_id = ? AND username = ?"
  L8_2 = {}
  L9_2 = L2_2.id
  L10_2 = L3_2
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L6_2 = L6_2(L7_2, L8_2)
  if not L6_2 then
    L7_2 = {}
    L7_2.error = "notseen"
    return L7_2
  end
  L7_2 = MySQL
  L7_2 = L7_2.update
  L7_2 = L7_2.await
  L8_2 = "UPDATE apex_phone_instant_views SET reaction = ? WHERE instant_id = ? AND username = ?"
  L9_2 = {}
  L10_2 = L5_2
  L11_2 = L2_2.id
  L12_2 = L3_2
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L7_2(L8_2, L9_2)
  L7_2 = L1_1
  L8_2 = L2_2.app
  L9_2 = L2_2.author
  L7_2 = L7_2(L8_2, L9_2)
  if L7_2 then
    L8_2 = NotifyCitizen
    L9_2 = L7_2.owner
    L10_2 = L2_2.app
    L11_2 = "@"
    L12_2 = L3_2
    L13_2 = " reagiu ao teu Instant"
    L11_2 = L11_2 .. L12_2 .. L13_2
    L12_2 = L5_2
    L13_2 = {}
    L13_2.sys = "t"
    L8_2(L9_2, L10_2, L11_2, L12_2, L13_2)
  end
  L8_2 = {}
  L8_2.ok = true
  L8_2.emoji = L5_2
  return L8_2
end
L39_1["social.instant.react"] = L40_1
L39_1 = RPC
function L40_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = L38_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "forbidden"
    return L3_2
  end
  L3_2 = L0_1
  L4_2 = A0_2
  L5_2 = L2_2.app
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L2_2.author
    if L4_2 == L3_2 then
      goto lbl_23
    end
  end
  L4_2 = {}
  L4_2.error = "forbidden"
  do return L4_2 end
  ::lbl_23::
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "DELETE FROM apex_phone_instant_views WHERE instant_id = ?"
  L6_2 = {}
  L7_2 = L2_2.id
  L6_2[1] = L7_2
  L4_2(L5_2, L6_2)
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "DELETE FROM apex_phone_instants WHERE id = ?"
  L6_2 = {}
  L7_2 = L2_2.id
  L6_2[1] = L7_2
  L4_2(L5_2, L6_2)
  L4_2 = {}
  L4_2.ok = true
  return L4_2
end
L39_1["social.instant.delete"] = L40_1
L39_1 = RPC
function L40_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = L38_1
  L3_2 = A1_2.id
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = L0_1
  L4_2 = A0_2
  L5_2 = L2_2.app
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = L2_2.author
    if L4_2 == L3_2 then
      goto lbl_21
    end
  end
  L4_2 = {}
  do return L4_2 end
  ::lbl_21::
  L4_2 = MySQL
  L4_2 = L4_2.query
  L4_2 = L4_2.await
  L5_2 = "SELECT username, reaction FROM apex_phone_instant_views WHERE instant_id = ? ORDER BY created DESC LIMIT 200"
  L6_2 = {}
  L7_2 = L2_2.id
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
  end
  L5_2 = {}
  L6_2 = {}
  L7_2 = ipairs
  L8_2 = L4_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = #L5_2
    L13_2 = L13_2 + 1
    L14_2 = L12_2.username
    L5_2[L13_2] = L14_2
    L13_2 = L12_2.username
    L14_2 = L12_2.reaction
    L6_2[L13_2] = L14_2
  end
  L7_2 = L21_1
  L8_2 = L2_2.app
  L9_2 = L5_2
  L10_2 = L3_2
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L8_2 = ipairs
  L9_2 = L7_2
  L8_2, L9_2, L10_2, L11_2 = L8_2(L9_2)
  for L12_2, L13_2 in L8_2, L9_2, L10_2, L11_2 do
    L14_2 = L13_2.username
    L14_2 = L6_2[L14_2]
    L13_2.reaction = L14_2
  end
  return L7_2
end
L39_1["social.instant.viewers"] = L40_1
L39_1 = RPC
function L40_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.error = "noprofile"
    return L3_2
  end
  L3_2 = A1_2.target
  if L2_2 == L3_2 then
    L3_2 = {}
    L3_2.following = false
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.single
  L3_2 = L3_2.await
  L4_2 = "SELECT follower FROM apex_phone_follows WHERE app = ? AND follower = ? AND followed = ?"
  L5_2 = {}
  L6_2 = A1_2.app
  L7_2 = L2_2
  L8_2 = A1_2.target
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2 = L3_2(L4_2, L5_2)
  if L3_2 then
    L4_2 = MySQL
    L4_2 = L4_2.query
    L4_2 = L4_2.await
    L5_2 = "DELETE FROM apex_phone_follows WHERE app = ? AND follower = ? AND followed = ?"
    L6_2 = {}
    L7_2 = A1_2.app
    L8_2 = L2_2
    L9_2 = A1_2.target
    L6_2[1] = L7_2
    L6_2[2] = L8_2
    L6_2[3] = L9_2
    L4_2(L5_2, L6_2)
    L4_2 = {}
    L4_2.following = false
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.insert
  L4_2 = L4_2.await
  L5_2 = "INSERT IGNORE INTO apex_phone_follows (app, follower, followed) VALUES (?, ?, ?)"
  L6_2 = {}
  L7_2 = A1_2.app
  L8_2 = L2_2
  L9_2 = A1_2.target
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L4_2(L5_2, L6_2)
  L4_2 = L1_1
  L5_2 = A1_2.app
  L6_2 = A1_2.target
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = NotifyCitizen
    L6_2 = L4_2.owner
    L7_2 = A1_2.app
    L8_2 = "@"
    L9_2 = L2_2
    L8_2 = L8_2 .. L9_2
    L9_2 = "come\195\167ou a seguir-te"
    L10_2 = {}
    L10_2.sys = "m"
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
  end
  L5_2 = {}
  L5_2.following = true
  return L5_2
end
L39_1["social.follow"] = L40_1
L39_1 = RPC
function L40_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT username, name, bio, website, avatar, avatar_url, private, created FROM apex_phone_social_accounts WHERE app = ? AND username = ?"
  L4_2 = {}
  L5_2 = A1_2.app
  L6_2 = tostring
  L7_2 = A1_2.username
  if not L7_2 then
    L7_2 = ""
  end
  L6_2, L7_2, L8_2, L9_2, L10_2 = L6_2(L7_2)
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L4_2[5] = L9_2
  L4_2[6] = L10_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = L0_1
  L4_2 = A0_2
  L5_2 = A1_2.app
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = {}
  L5_2 = L2_2.username
  L4_2.username = L5_2
  L5_2 = L2_2.name
  L4_2.name = L5_2
  L5_2 = L2_2.bio
  L4_2.bio = L5_2
  L5_2 = L2_2.website
  L4_2.website = L5_2
  L5_2 = tonumber
  L6_2 = L2_2.avatar
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = L2_2.avatar
  end
  L4_2.avatar = L5_2
  L5_2 = L2_2.avatar_url
  L4_2.avatarUrl = L5_2
  L5_2 = L2_2.avatar_url
  L4_2.avatar_url = L5_2
  L5_2 = tonumber
  L6_2 = L2_2.private
  L5_2 = L5_2(L6_2)
  if not L5_2 then
    L5_2 = 0
  end
  L5_2 = 1 == L5_2
  L4_2.private = L5_2
  L5_2 = L2_2.created
  L4_2.created = L5_2
  L5_2 = MySQL
  L5_2 = L5_2.scalar
  L5_2 = L5_2.await
  L6_2 = "SELECT COUNT(*) FROM apex_phone_follows WHERE app = ? AND followed = ?"
  L7_2 = {}
  L8_2 = A1_2.app
  L9_2 = L2_2.username
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = 0
  end
  L4_2.followers = L5_2
  L5_2 = MySQL
  L5_2 = L5_2.scalar
  L5_2 = L5_2.await
  L6_2 = "SELECT COUNT(*) FROM apex_phone_follows WHERE app = ? AND follower = ?"
  L7_2 = {}
  L8_2 = A1_2.app
  L9_2 = L2_2.username
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = 0
  end
  L4_2.following = L5_2
  L5_2 = MySQL
  L5_2 = L5_2.scalar
  L5_2 = L5_2.await
  L6_2 = "SELECT COUNT(*) FROM apex_phone_posts WHERE app = ? AND author = ? AND reply_to IS NULL"
  L7_2 = {}
  L8_2 = A1_2.app
  L9_2 = L2_2.username
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = 0
  end
  L4_2.posts = L5_2
  L5_2 = nil ~= L3_2
  L4_2.isFollowing = L5_2
  L5_2 = L2_2.username
  L5_2 = L3_2 == L5_2
  L4_2.me = L5_2
  return L4_2
end
L39_1["social.user"] = L40_1
L39_1 = RPC
function L40_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = "%"
  L3_2 = tostring
  L4_2 = A1_2.q
  if not L4_2 then
    L4_2 = ""
  end
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.lower
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.gsub
  L5_2 = "^#"
  L6_2 = ""
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = "%"
  L2_2 = L2_2 .. L3_2 .. L4_2
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "SELECT username, name, bio, avatar, avatar_url AS avatarUrl FROM apex_phone_social_accounts WHERE app = ? AND (LOWER(username) LIKE ? OR LOWER(name) LIKE ?) ORDER BY username ASC LIMIT 12"
  L5_2 = {}
  L6_2 = A1_2.app
  L7_2 = L2_2
  L8_2 = L2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = {}
  end
  return L3_2
end
L39_1["social.search"] = L40_1
L39_1 = RPC
function L40_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = L0_1
  L3_2 = A0_2
  L4_2 = A1_2.app
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L3_2 = {}
    return L3_2
  end
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "SELECT l.username, p.created FROM apex_phone_likes l JOIN apex_phone_posts p ON p.id = l.post_id WHERE p.app = ? AND p.author = ? AND l.username <> ? ORDER BY p.created DESC LIMIT 30"
  L7_2 = {}
  L8_2 = A1_2.app
  L9_2 = L2_2
  L10_2 = L2_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = #L3_2
    L10_2 = L10_2 + 1
    L11_2 = {}
    L11_2.type = "like"
    L12_2 = L9_2.username
    L11_2.username = L12_2
    L12_2 = L9_2.created
    L11_2.created = L12_2
    L3_2[L10_2] = L11_2
  end
  L4_2 = ipairs
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "SELECT c.username, c.content, c.created FROM apex_phone_comments c JOIN apex_phone_posts p ON p.id = c.post_id WHERE p.app = ? AND p.author = ? AND c.username <> ? ORDER BY c.created DESC LIMIT 30"
  L7_2 = {}
  L8_2 = A1_2.app
  L9_2 = L2_2
  L10_2 = L2_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = #L3_2
    L10_2 = L10_2 + 1
    L11_2 = {}
    L11_2.type = "comment"
    L12_2 = L9_2.username
    L11_2.username = L12_2
    L12_2 = L9_2.content
    L11_2.content = L12_2
    L12_2 = L9_2.created
    L11_2.created = L12_2
    L3_2[L10_2] = L11_2
  end
  L4_2 = ipairs
  L5_2 = MySQL
  L5_2 = L5_2.query
  L5_2 = L5_2.await
  L6_2 = "SELECT follower FROM apex_phone_follows WHERE app = ? AND followed = ? LIMIT 30"
  L7_2 = {}
  L8_2 = A1_2.app
  L9_2 = L2_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = {}
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = #L3_2
    L10_2 = L10_2 + 1
    L11_2 = {}
    L11_2.type = "follow"
    L12_2 = L9_2.follower
    L11_2.username = L12_2
    L12_2 = Now
    L12_2 = L12_2()
    L12_2 = L12_2 - 3600000
    L11_2.created = L12_2
    L3_2[L10_2] = L11_2
  end
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L3_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = #L4_2
    L11_2 = L11_2 + 1
    L12_2 = L10_2.username
    L4_2[L11_2] = L12_2
  end
  L5_2 = L6_1
  L6_2 = A1_2.app
  L7_2 = L4_2
  L8_2 = "username, avatar"
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  L6_2 = ipairs
  L7_2 = L3_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
    L12_2 = L7_1
    L13_2 = L5_2
    L14_2 = L11_2.username
    L12_2 = L12_2(L13_2, L14_2)
    if L12_2 then
      L13_2 = tonumber
      L14_2 = L12_2.avatar
      L13_2 = L13_2(L14_2)
      if L13_2 then
        goto lbl_150
      end
      L13_2 = L12_2.avatar
      if L13_2 then
        goto lbl_150
      end
    end
    L13_2 = 1
    ::lbl_150::
    L11_2.avatar = L13_2
  end
  L6_2 = table
  L6_2 = L6_2.sort
  L7_2 = L3_2
  function L8_2(A0_3, A1_3)
    local L2_3, L3_3
    L2_3 = A0_3.created
    if not L2_3 then
      L2_3 = 0
    end
    L3_3 = A1_3.created
    if not L3_3 then
      L3_3 = 0
    end
    L2_3 = L2_3 > L3_3
    return L2_3
  end
  L6_2(L7_2, L8_2)
  return L3_2
end
L39_1["social.notifications"] = L40_1
L39_1 = {}
L40_1 = "sombra"
L41_1 = "corvo"
L42_1 = "anon"
L43_1 = "fantasma"
L44_1 = "lobo"
L45_1 = "raven"
L46_1 = "eco"
L47_1 = "neon"
L48_1 = "cinza"
L49_1 = "zero"
L39_1[1] = L40_1
L39_1[2] = L41_1
L39_1[3] = L42_1
L39_1[4] = L43_1
L39_1[5] = L44_1
L39_1[6] = L45_1
L39_1[7] = L46_1
L39_1[8] = L47_1
L39_1[9] = L48_1
L39_1[10] = L49_1
L40_1 = {}
function L41_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = L40_1
  L2_2 = L2_2[L1_2]
  if L2_2 then
    L2_2 = L40_1
    L2_2 = L2_2[L1_2]
    return L2_2
  end
  L2_2 = MySQL
  L2_2 = L2_2.single
  L2_2 = L2_2.await
  L3_2 = "SELECT username FROM apex_phone_darkchat_members WHERE citizenid = ? LIMIT 1"
  L4_2 = {}
  L5_2 = L1_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 then
    L3_2 = L2_2.username
    if L3_2 then
      goto lbl_38
    end
  end
  L3_2 = math
  L3_2 = L3_2.random
  L4_2 = L39_1
  L4_2 = #L4_2
  L3_2 = L3_2(L4_2)
  L4_2 = L39_1
  L3_2 = L4_2[L3_2]
  L4_2 = math
  L4_2 = L4_2.random
  L5_2 = 100
  L6_2 = 999
  L4_2 = L4_2(L5_2, L6_2)
  L3_2 = L3_2 .. L4_2
  ::lbl_38::
  L4_2 = L40_1
  L4_2[L1_2] = L3_2
  return L3_2
end
L42_1 = RPC
function L43_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = {}
  L2_2 = L41_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L1_2.username = L2_2
  return L1_2
end
L42_1["darkchat.identity"] = L43_1
L42_1 = RPC
function L43_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = math
  L2_2 = L2_2.random
  L3_2 = L39_1
  L3_2 = #L3_2
  L2_2 = L2_2(L3_2)
  L3_2 = L39_1
  L2_2 = L3_2[L2_2]
  L3_2 = math
  L3_2 = L3_2.random
  L4_2 = 100
  L5_2 = 999
  L3_2 = L3_2(L4_2, L5_2)
  L2_2 = L2_2 .. L3_2
  L3_2 = L40_1
  L3_2[L1_2] = L2_2
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM apex_phone_darkchat_members WHERE citizenid = ?"
  L5_2 = {}
  L6_2 = L1_2
  L5_2[1] = L6_2
  L3_2(L4_2, L5_2)
  L3_2 = MySQL
  L3_2 = L3_2.insert
  L3_2 = L3_2.await
  L4_2 = "INSERT IGNORE INTO apex_phone_darkchat_members (citizenid, room, username) VALUES (?, \"geral\", ?)"
  L5_2 = {}
  L6_2 = L1_2
  L7_2 = L2_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2(L4_2, L5_2)
  L3_2 = {}
  L3_2.username = L2_2
  return L3_2
end
L42_1["darkchat.newIdentity"] = L43_1
L42_1 = RPC
function L43_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = GetCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT room FROM apex_phone_darkchat_members WHERE citizenid = ?"
  L4_2 = {}
  L5_2 = L1_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = #L2_2
  if 0 == L3_2 then
    L3_2 = MySQL
    L3_2 = L3_2.insert
    L3_2 = L3_2.await
    L4_2 = "INSERT IGNORE INTO apex_phone_darkchat_members (citizenid, room, username) VALUES (?, \"geral\", ?)"
    L5_2 = {}
    L6_2 = L1_2
    L7_2 = L41_1
    L8_2 = A0_2
    L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L7_2(L8_2)
    L5_2[1] = L6_2
    L5_2[2] = L7_2
    L5_2[3] = L8_2
    L5_2[4] = L9_2
    L5_2[5] = L10_2
    L5_2[6] = L11_2
    L5_2[7] = L12_2
    L5_2[8] = L13_2
    L5_2[9] = L14_2
    L3_2(L4_2, L5_2)
    L3_2 = {}
    L4_2 = {}
    L4_2.room = "geral"
    L3_2[1] = L4_2
    L2_2 = L3_2
  end
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = MySQL
    L10_2 = L10_2.single
    L10_2 = L10_2.await
    L11_2 = [[
SELECT username, content, IF(image IS NULL, NULL, 1) AS image, created,
            (SELECT COUNT(*) FROM apex_phone_darkchat WHERE room = ?) AS n
            FROM apex_phone_darkchat WHERE room = ? ORDER BY created DESC LIMIT 1]]
    L12_2 = {}
    L13_2 = L9_2.room
    L14_2 = L9_2.room
    L12_2[1] = L13_2
    L12_2[2] = L14_2
    L10_2 = L10_2(L11_2, L12_2)
    L11_2 = 0
    if L10_2 then
      L12_2 = tonumber
      L13_2 = L10_2.n
      L12_2 = L12_2(L13_2)
      L11_2 = L12_2 or L11_2
      if not L12_2 then
        L11_2 = 0
      end
      L10_2.n = nil
    end
    L12_2 = #L3_2
    L12_2 = L12_2 + 1
    L13_2 = {}
    L14_2 = L9_2.room
    L13_2.room = L14_2
    L13_2.count = L11_2
    L13_2.last = L10_2
    L3_2[L12_2] = L13_2
  end
  return L3_2
end
L42_1["darkchat.rooms"] = L43_1
function L42_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = tostring
  L2_2 = A0_2 or L2_2
  if not A0_2 then
    L2_2 = ""
  end
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.lower
  L1_2 = L1_2(L2_2)
  L2_2 = L1_2
  L1_2 = L1_2.gsub
  L3_2 = "[^a-z0-9_%-]"
  L4_2 = ""
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  L3_2 = L1_2
  L2_2 = L1_2.sub
  L4_2 = 1
  L5_2 = 40
  return L2_2(L3_2, L4_2, L5_2)
end
function L43_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  if not A0_2 or "" == A1_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = MySQL
  L2_2 = L2_2.scalar
  L2_2 = L2_2.await
  L3_2 = "SELECT 1 FROM apex_phone_darkchat_members WHERE citizenid = ? AND room = ? LIMIT 1"
  L4_2 = {}
  L5_2 = A0_2
  L6_2 = A1_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L2_2 = L2_2(L3_2, L4_2)
  L2_2 = nil ~= L2_2
  return L2_2
end
L44_1 = {}
L44_1[0] = true
L44_1[1] = true
L44_1[5] = true
L44_1[15] = true
L44_1[30] = true
L44_1[60] = true
L45_1 = 360
L44_1[L45_1] = true
L45_1 = 1440
L44_1[L45_1] = true
L45_1 = RPC
function L46_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L42_1
  L3_2 = A1_2.room
  L2_2 = L2_2(L3_2)
  L3_2 = GetCid
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "" == L2_2 or not L3_2 then
    L4_2 = {}
    L4_2.ok = false
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.insert
  L4_2 = L4_2.await
  L5_2 = "INSERT IGNORE INTO apex_phone_darkchat_members (citizenid, room, username) VALUES (?, ?, ?)"
  L6_2 = {}
  L7_2 = L3_2
  L8_2 = L2_2
  L9_2 = L41_1
  L10_2 = A0_2
  L9_2, L10_2 = L9_2(L10_2)
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L4_2(L5_2, L6_2)
  L4_2 = {}
  L4_2.ok = true
  L4_2.room = L2_2
  return L4_2
end
L45_1["darkchat.join"] = L46_1
L45_1 = RPC
function L46_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "DELETE FROM apex_phone_darkchat_members WHERE citizenid = ? AND room = ?"
  L4_2 = {}
  L5_2 = GetCid
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  L6_2 = tostring
  L7_2 = A1_2.room
  if not L7_2 then
    L7_2 = ""
  end
  L6_2 = L6_2(L7_2)
  L7_2 = L6_2
  L6_2 = L6_2.sub
  L8_2 = 1
  L9_2 = 40
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2)
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L4_2[4] = L8_2
  L4_2[5] = L9_2
  L2_2(L3_2, L4_2)
  L2_2 = {}
  L2_2.ok = true
  return L2_2
end
L45_1["darkchat.leave"] = L46_1
L45_1 = RPC
function L46_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L2_2 = L42_1
  L3_2 = A1_2.room
  L2_2 = L2_2(L3_2)
  L3_2 = L43_1
  L4_2 = GetCid
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L5_2 = L2_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = {}
    L3_2.error = "forbidden"
    return L3_2
  end
  L3_2 = MySQL
  L3_2 = L3_2.query
  L3_2 = L3_2.await
  L4_2 = "SELECT * FROM apex_phone_darkchat WHERE room = ? AND (ttl = 0 OR created + ttl * 60000 > ?) ORDER BY created DESC, id DESC LIMIT 200"
  L5_2 = {}
  L6_2 = L2_2
  L7_2 = Now
  L7_2, L8_2, L9_2, L10_2, L11_2 = L7_2()
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  L5_2[5] = L10_2
  L5_2[6] = L11_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L3_2 = {}
  end
  L4_2 = {}
  L5_2 = #L3_2
  L6_2 = 1
  L7_2 = -1
  for L8_2 = L5_2, L6_2, L7_2 do
    L9_2 = L3_2[L8_2]
    L10_2 = L9_2.image
    if L10_2 then
      L10_2 = tonumber
      L11_2 = L9_2.image
      L10_2 = L10_2(L11_2)
      if L10_2 then
        L10_2 = tonumber
        L11_2 = L9_2.image
        L10_2 = L10_2(L11_2)
        L9_2.image = L10_2
      end
    end
    L10_2 = #L4_2
    L10_2 = L10_2 + 1
    L4_2[L10_2] = L9_2
  end
  return L4_2
end
L45_1["darkchat.messages"] = L46_1
L45_1 = RPC
function L46_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2
  L2_2 = GetCid
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = L42_1
  L4_2 = A1_2.room
  L3_2 = L3_2(L4_2)
  L4_2 = L43_1
  L5_2 = L2_2
  L6_2 = L3_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = {}
    L4_2.error = "forbidden"
    return L4_2
  end
  L4_2 = L41_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L5_2 = Now
  L5_2 = L5_2()
  L6_2 = tonumber
  L7_2 = A1_2.ttl
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  L7_2 = L44_1
  L7_2 = L7_2[L6_2]
  if not L7_2 then
    L7_2 = {}
    L7_2.error = "ttl"
    return L7_2
  end
  L7_2 = math
  L7_2 = L7_2.tointeger
  L8_2 = L6_2
  L7_2 = L7_2(L8_2)
  L6_2 = L7_2 or L6_2
  if not L7_2 then
    L6_2 = 0
  end
  L7_2 = tostring
  L8_2 = A1_2.content
  if not L8_2 then
    L8_2 = ""
  end
  L7_2 = L7_2(L8_2)
  L8_2 = L7_2
  L7_2 = L7_2.sub
  L9_2 = 1
  L10_2 = 1000
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L8_2 = nil
  L9_2 = A1_2.image
  if nil ~= L9_2 then
    L9_2 = A1_2.image
    if false ~= L9_2 then
      L9_2 = A1_2.image
      if "" ~= L9_2 then
        L9_2 = tostring
        L10_2 = A1_2.image
        L9_2 = L9_2(L10_2)
        L8_2 = L9_2
        L9_2 = #L8_2
        L10_2 = tonumber
        L11_2 = Config
        L11_2 = L11_2.PhotoMaxBytes
        L10_2 = L10_2(L11_2)
        if not L10_2 then
          L10_2 = 260000
        end
        if L9_2 > L10_2 then
          L9_2 = {}
          L9_2.error = "toolarge"
          return L9_2
        end
      end
    end
  end
  if "" == L7_2 and not L8_2 then
    L9_2 = {}
    L9_2.error = "empty"
    return L9_2
  end
  L9_2 = MySQL
  L9_2 = L9_2.insert
  L9_2 = L9_2.await
  L10_2 = "INSERT INTO apex_phone_darkchat (room, username, content, image, ttl, created) VALUES (?, ?, ?, ?, ?, ?)"
  L11_2 = {}
  L12_2 = L3_2
  L13_2 = L4_2
  L14_2 = L7_2
  L15_2 = L8_2
  L16_2 = L6_2
  L17_2 = L5_2
  L11_2[1] = L12_2
  L11_2[2] = L13_2
  L11_2[3] = L14_2
  L11_2[4] = L15_2
  L11_2[5] = L16_2
  L11_2[6] = L17_2
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = {}
  L10_2.id = L9_2
  L10_2.room = L3_2
  L10_2.username = L4_2
  L10_2.content = L7_2
  if L8_2 then
    L11_2 = tonumber
    L12_2 = L8_2
    L11_2 = L11_2(L12_2)
    if L11_2 or L8_2 then
      goto lbl_119
      L11_2 = L8_2 or L11_2
    end
  end
  L11_2 = nil
  ::lbl_119::
  L10_2.image = L11_2
  L10_2.ttl = L6_2
  L10_2.created = L5_2
  L11_2 = OnlineCidIndex
  if L11_2 then
    L11_2 = OnlineCidIndex
    L11_2 = L11_2()
    if L11_2 then
      goto lbl_130
    end
  end
  L11_2 = nil
  ::lbl_130::
  L12_2 = ipairs
  L13_2 = MySQL
  L13_2 = L13_2.query
  L13_2 = L13_2.await
  L14_2 = "SELECT citizenid FROM apex_phone_darkchat_members WHERE room = ? AND citizenid <> ?"
  L15_2 = {}
  L16_2 = L3_2
  L17_2 = L2_2
  L15_2[1] = L16_2
  L15_2[2] = L17_2
  L13_2 = L13_2(L14_2, L15_2)
  if not L13_2 then
    L13_2 = {}
  end
  L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
  for L16_2, L17_2 in L12_2, L13_2, L14_2, L15_2 do
    if L11_2 then
      L18_2 = L17_2.citizenid
      L18_2 = L11_2[L18_2]
      L19_2 = false
      L20_2 = nil
      if L18_2 then
        L21_2 = FW
        L21_2 = L21_2.GetCidPhone
        L22_2 = L18_2
        L21_2, L22_2 = L21_2(L22_2)
        L20_2 = L22_2
        L19_2 = L21_2
      end
      if L19_2 then
        L21_2 = L17_2.citizenid
        if L20_2 == L21_2 then
          L21_2 = Push
          L22_2 = L18_2
          L23_2 = "darkchat"
          L24_2 = L10_2
          L21_2(L22_2, L23_2, L24_2)
        end
      end
    else
      L18_2 = FW
      L18_2 = L18_2.GetPlayerByCid
      L19_2 = L17_2.citizenid
      L18_2 = L18_2(L19_2)
      if L18_2 then
        L19_2 = Push
        L20_2 = L18_2.src
        L21_2 = "darkchat"
        L22_2 = L10_2
        L19_2(L20_2, L21_2, L22_2)
      end
    end
  end
  if L6_2 > 0 then
    L12_2 = SetTimeout
    L13_2 = L6_2 * 60000
    function L14_2()
      local L0_3, L1_3, L2_3, L3_3
      L0_3 = MySQL
      L0_3 = L0_3.query
      L1_3 = "DELETE FROM apex_phone_darkchat WHERE id = ?"
      L2_3 = {}
      L3_3 = L9_2
      L2_3[1] = L3_3
      L0_3(L1_3, L2_3)
    end
    L12_2(L13_2, L14_2)
  end
  return L10_2
end
L45_1["darkchat.send"] = L46_1
L45_1 = CreateThread
function L46_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L0_2 = {}
  L1_2 = {}
  L2_2 = "apex_phone_posts"
  L3_2 = "ax_repost_of"
  L4_2 = {}
  L5_2 = "repost_of"
  L4_2[1] = L5_2
  L1_2[1] = L2_2
  L1_2[2] = L3_2
  L1_2[3] = L4_2
  L2_2 = {}
  L3_2 = "apex_phone_posts"
  L4_2 = "ax_reply"
  L5_2 = {}
  L6_2 = "app"
  L7_2 = "reply_to"
  L8_2 = "created"
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L2_2[1] = L3_2
  L2_2[2] = L4_2
  L2_2[3] = L5_2
  L3_2 = {}
  L4_2 = "apex_phone_follows"
  L5_2 = "ax_followed"
  L6_2 = {}
  L7_2 = "app"
  L8_2 = "followed"
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L3_2[1] = L4_2
  L3_2[2] = L5_2
  L3_2[3] = L6_2
  L4_2 = {}
  L5_2 = "apex_phone_close_friends"
  L6_2 = "ax_friend"
  L7_2 = {}
  L8_2 = "app"
  L9_2 = "friend"
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L4_2[3] = L7_2
  L5_2 = {}
  L6_2 = "apex_phone_darkchat"
  L7_2 = "ax_ttl"
  L8_2 = {}
  L9_2 = "ttl"
  L10_2 = "created"
  L8_2[1] = L9_2
  L8_2[2] = L10_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L0_2[1] = L1_2
  L0_2[2] = L2_2
  L0_2[3] = L3_2
  L0_2[4] = L4_2
  L0_2[5] = L5_2
  L1_2 = 1
  L2_2 = 30
  L3_2 = 1
  for L4_2 = L1_2, L2_2, L3_2 do
    L5_2 = MySQL
    L5_2 = L5_2.scalar
    L5_2 = L5_2.await
    L6_2 = [[
SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE()
            AND TABLE_NAME IN ('apex_phone_posts', 'apex_phone_follows', 'apex_phone_close_friends', 'apex_phone_darkchat')]]
    L5_2 = L5_2(L6_2)
    if not L5_2 then
      L5_2 = 0
    end
    L6_2 = tonumber
    L7_2 = L5_2
    L6_2 = L6_2(L7_2)
    if not L6_2 then
      L6_2 = 0
    end
    if L6_2 >= 4 then
      break
    end
    L6_2 = Wait
    L7_2 = 2000
    L6_2(L7_2)
  end
  L1_2 = ipairs
  L2_2 = L0_2
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = pcall
    function L8_2()
      local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3
      L0_3 = MySQL
      L0_3 = L0_3.query
      L0_3 = L0_3.await
      L1_3 = [[
SELECT INDEX_NAME AS idx, SEQ_IN_INDEX AS seq, COLUMN_NAME AS col FROM information_schema.STATISTICS
                WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? ORDER BY INDEX_NAME, SEQ_IN_INDEX]]
      L2_3 = {}
      L3_3 = L6_2
      L3_3 = L3_3[1]
      L2_3[1] = L3_3
      L0_3 = L0_3(L1_3, L2_3)
      if not L0_3 then
        L0_3 = {}
      end
      L1_3 = {}
      L2_3 = ipairs
      L3_3 = L0_3
      L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3)
      for L6_3, L7_3 in L2_3, L3_3, L4_3, L5_3 do
        L8_3 = tostring
        L9_3 = L7_3.idx
        L8_3 = L8_3(L9_3)
        L9_3 = L1_3[L8_3]
        if not L9_3 then
          L9_3 = {}
        end
        L1_3[L8_3] = L9_3
        L9_3 = L1_3[L8_3]
        L10_3 = math
        L10_3 = L10_3.tointeger
        L11_3 = tonumber
        L12_3 = L7_3.seq
        L11_3 = L11_3(L12_3)
        if not L11_3 then
          L11_3 = 0
        end
        L10_3 = L10_3(L11_3)
        if not L10_3 then
          L10_3 = 0
        end
        L11_3 = tostring
        L12_3 = L7_3.col
        L11_3 = L11_3(L12_3)
        L12_3 = L11_3
        L11_3 = L11_3.lower
        L11_3 = L11_3(L12_3)
        L9_3[L10_3] = L11_3
      end
      L2_3 = pairs
      L3_3 = L1_3
      L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3)
      for L6_3, L7_3 in L2_3, L3_3, L4_3, L5_3 do
        L8_3 = L6_2
        L8_3 = L8_3[2]
        if L6_3 == L8_3 then
          return
        end
        L8_3 = true
        L9_3 = ipairs
        L10_3 = L6_2
        L10_3 = L10_3[3]
        L9_3, L10_3, L11_3, L12_3 = L9_3(L10_3)
        for L13_3, L14_3 in L9_3, L10_3, L11_3, L12_3 do
          L15_3 = L7_3[L13_3]
          if L15_3 ~= L14_3 then
            L8_3 = false
            break
          end
        end
        if L8_3 then
          return
        end
      end
      L2_3 = {}
      L3_3 = ipairs
      L4_3 = L6_2
      L4_3 = L4_3[3]
      L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3)
      for L7_3, L8_3 in L3_3, L4_3, L5_3, L6_3 do
        L9_3 = "`"
        L10_3 = L8_3
        L11_3 = "`"
        L9_3 = L9_3 .. L10_3 .. L11_3
        L2_3[L7_3] = L9_3
      end
      L3_3 = MySQL
      L3_3 = L3_3.query
      L3_3 = L3_3.await
      L4_3 = "ALTER TABLE `%s` ADD KEY `%s` (%s)"
      L5_3 = L4_3
      L4_3 = L4_3.format
      L6_3 = L6_2
      L6_3 = L6_3[1]
      L7_3 = L6_2
      L7_3 = L7_3[2]
      L8_3 = table
      L8_3 = L8_3.concat
      L9_3 = L2_3
      L10_3 = ", "
      L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3 = L8_3(L9_3, L10_3)
      L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3 = L4_3(L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3)
      L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3)
      L3_3 = print
      L4_3 = "^2[unique_phone]^0 index created: %s.%s"
      L5_3 = L4_3
      L4_3 = L4_3.format
      L6_3 = L6_2
      L6_3 = L6_3[1]
      L7_3 = L6_2
      L7_3 = L7_3[2]
      L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3 = L4_3(L5_3, L6_3, L7_3)
      L3_3(L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3, L13_3, L14_3, L15_3)
    end
    L7_2, L8_2 = L7_2(L8_2)
    if not L7_2 then
      L9_2 = print
      L10_2 = "^3[unique_phone]^0 could not create index %s.%s (%s)"
      L11_2 = L10_2
      L10_2 = L10_2.format
      L12_2 = L6_2[1]
      L13_2 = L6_2[2]
      L14_2 = tostring
      L15_2 = L8_2
      L14_2, L15_2 = L14_2(L15_2)
      L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
      L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    end
  end
end
L45_1(L46_1)
L45_1 = {}
L45_1.instashot = true
L45_1.twix = true
L45_1.reels = true
function L46_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = L45_1
    L1_2 = L1_2[A0_2]
    if L1_2 then
      goto lbl_12
    end
  end
  L1_2 = false
  do return L1_2 end
  ::lbl_12::
  L1_2 = Config
  L1_2 = L1_2.Social
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = true
    return L2_2
  end
  L2_2 = L1_2[A0_2]
  L2_2 = false ~= L2_2
  return L2_2
end
function L47_1()
  local L0_2, L1_2, L2_2
  L0_2 = Config
  L0_2 = L0_2.Social
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  L1_2 = "table" ~= L1_2
  return L1_2
end
L48_1 = {}
L49_1 = {}
L50_1 = pairs
L51_1 = RPC
L50_1, L51_1, L52_1, L53_1 = L50_1(L51_1)
for L54_1, L55_1 in L50_1, L51_1, L52_1, L53_1 do
  L57_1 = L54_1
  L56_1 = L54_1.sub
  L58_1 = 1
  L59_1 = 7
  L56_1 = L56_1(L57_1, L58_1, L59_1)
  if "social." == L56_1 then
    L48_1[L54_1] = L55_1
  else
    L57_1 = L54_1
    L56_1 = L54_1.sub
    L58_1 = 1
    L59_1 = 9
    L56_1 = L56_1(L57_1, L58_1, L59_1)
    if "darkchat." == L56_1 then
      L49_1[L54_1] = L55_1
    end
  end
end
L50_1 = pairs
L51_1 = L48_1
L50_1, L51_1, L52_1, L53_1 = L50_1(L51_1)
for L54_1, L55_1 in L50_1, L51_1, L52_1, L53_1 do
  L56_1 = RPC
  function L57_1(A0_2, A1_2)
    local L2_2, L3_2, L4_2
    L2_2 = type
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
    if "table" == L2_2 then
      L2_2 = A1_2.app
      if nil ~= L2_2 then
        L2_2 = L46_1
        L3_2 = A1_2.app
        L2_2 = L2_2(L3_2)
        if not L2_2 then
          L2_2 = {}
          L2_2.error = "off"
          return L2_2
        end
      end
    end
    L2_2 = L55_1
    L3_2 = A0_2
    L4_2 = A1_2
    return L2_2(L3_2, L4_2)
  end
  L56_1[L54_1] = L57_1
end
L50_1 = pairs
L51_1 = L49_1
L50_1, L51_1, L52_1, L53_1 = L50_1(L51_1)
for L54_1, L55_1 in L50_1, L51_1, L52_1, L53_1 do
  L56_1 = RPC
  function L57_1(A0_2, A1_2)
    local L2_2, L3_2, L4_2
    L2_2 = L47_1
    L2_2 = L2_2()
    if not L2_2 then
      L2_2 = {}
      L2_2.error = "off"
      return L2_2
    end
    L2_2 = L55_1
    L3_2 = A0_2
    L4_2 = A1_2
    return L2_2(L3_2, L4_2)
  end
  L56_1[L54_1] = L57_1
end
L50_1 = RPC
L50_1 = L50_1["social.createProfile"]
if L50_1 then
  L51_1 = RPC
  function L52_1(A0_2, A1_2)
    local L2_2, L3_2, L4_2
    L2_2 = type
    L3_2 = A1_2
    L2_2 = L2_2(L3_2)
    if "table" == L2_2 then
      L2_2 = L46_1
      L3_2 = A1_2.app
      L2_2 = L2_2(L3_2)
      if L2_2 then
        goto lbl_15
      end
    end
    L2_2 = {}
    L2_2.error = "off"
    do return L2_2 end
    ::lbl_15::
    L2_2 = L50_1
    L3_2 = A0_2
    L4_2 = A1_2
    return L2_2(L3_2, L4_2)
  end
  L51_1["social.createProfile"] = L52_1
end
L48_1 = CreateThread
function L49_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  while true do
    L0_2 = Wait
    L1_2 = 300000
    L0_2(L1_2)
    L0_2 = MySQL
    L0_2 = L0_2.query
    L1_2 = "DELETE FROM apex_phone_darkchat WHERE ttl > 0 AND created + ttl * 60000 < ?"
    L2_2 = {}
    L3_2 = Now
    L3_2, L4_2 = L3_2()
    L2_2[1] = L3_2
    L2_2[2] = L4_2
    L0_2(L1_2, L2_2)
    L0_2 = Config
    L0_2 = L0_2.DarkChatTTL
    if not L0_2 then
      L0_2 = 0
    end
    if L0_2 > 0 then
      L0_2 = MySQL
      L0_2 = L0_2.query
      L1_2 = "DELETE FROM apex_phone_darkchat WHERE created < ?"
      L2_2 = {}
      L3_2 = Now
      L3_2 = L3_2()
      L4_2 = Config
      L4_2 = L4_2.DarkChatTTL
      L4_2 = L4_2 * 60000
      L3_2 = L3_2 - L4_2
      L2_2[1] = L3_2
      L0_2(L1_2, L2_2)
    end
  end
end
L48_1(L49_1)
