local L0_1, L1_1, L2_1
L0_1 = BaseCallback
L1_1 = "music:createPlaylist"
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = MySQL
  L3_2 = L3_2.insert
  L3_2 = L3_2.await
  L4_2 = "INSERT INTO phone_music_playlists (`name`, phone_number) VALUES (?, ?)"
  L5_2 = {}
  L6_2 = A2_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.update
  L4_2 = L4_2.await
  L5_2 = "INSERT INTO phone_music_saved_playlists (playlist_id, phone_number) VALUES (?, ?)"
  L6_2 = {}
  L7_2 = L3_2
  L8_2 = A1_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2(L5_2, L6_2)
  return L3_2
end
L0_1(L1_1, L2_1)
L0_1 = BaseCallback
L1_1 = "music:editPlaylist"
function L2_1(A0_2, A1_2, A2_2, A3_2, A4_2)
  local L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "UPDATE phone_music_playlists SET `name` = ?, cover = ? WHERE id = ? AND phone_number = ?"
  L7_2 = {}
  L8_2 = A3_2
  L9_2 = A4_2
  L10_2 = A2_2
  L11_2 = A1_2
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L7_2[3] = L10_2
  L7_2[4] = L11_2
  L5_2 = L5_2(L6_2, L7_2)
  L5_2 = L5_2 > 0
  return L5_2
end
L0_1(L1_1, L2_1)
L0_1 = BaseCallback
L1_1 = "music:getPlaylists"
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = [[
        SELECT s.song_id, p.id, p.`name`, p.cover, p.phone_number
        FROM phone_music_playlists p
        LEFT JOIN phone_music_saved_playlists p2 ON p2.playlist_id = p.id
        LEFT JOIN phone_music_songs s ON s.playlist_id = p.id

        WHERE p2.phone_number = ?

        ORDER BY p.`name` ASC
    ]]
  L4_2 = {}
  L5_2 = A1_2
  L4_2[1] = L5_2
  return L2_2(L3_2, L4_2)
end
L0_1(L1_1, L2_1)
L0_1 = BaseCallback
L1_1 = "music:deletePlaylist"
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM phone_music_playlists WHERE id = ? AND phone_number = ?"
  L5_2 = {}
  L6_2 = A2_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = L3_2 > 0
  return L3_2
end
L0_1(L1_1, L2_1)
L0_1 = BaseCallback
L1_1 = "music:savePlaylist"
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "INSERT INTO phone_music_saved_playlists (playlist_id, phone_number) VALUES (?, ?) ON DUPLICATE KEY UPDATE phone_number = phone_number"
  L5_2 = {}
  L6_2 = A2_2
  L7_2 = A1_2
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L3_2 = L3_2(L4_2, L5_2)
  L3_2 = L3_2 > 0
  return L3_2
end
L0_1(L1_1, L2_1)
L0_1 = BaseCallback
L1_1 = "music:addSong"
function L2_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2
  L4_2 = MySQL
  L4_2 = L4_2.scalar
  L4_2 = L4_2.await
  L5_2 = "SELECT 1 FROM phone_music_playlists WHERE id = ? AND phone_number = ?"
  L6_2 = {}
  L7_2 = A2_2
  L8_2 = A1_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.update
  L4_2 = L4_2.await
  L5_2 = "INSERT INTO phone_music_songs (playlist_id, song_id) VALUES (?, ?) ON DUPLICATE KEY UPDATE song_id = song_id"
  L6_2 = {}
  L7_2 = A2_2
  L8_2 = A3_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  L4_2 = L4_2 > 0
  return L4_2
end
L0_1(L1_1, L2_1)
L0_1 = BaseCallback
L1_1 = "music:removeSong"
function L2_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2
  L4_2 = MySQL
  L4_2 = L4_2.scalar
  L4_2 = L4_2.await
  L5_2 = "SELECT 1 FROM phone_music_playlists WHERE id = ? AND phone_number = ?"
  L6_2 = {}
  L7_2 = A2_2
  L8_2 = A1_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  if not L4_2 then
    L4_2 = false
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.update
  L4_2 = L4_2.await
  L5_2 = "DELETE FROM phone_music_songs WHERE playlist_id = ? AND song_id = ?"
  L6_2 = {}
  L7_2 = A2_2
  L8_2 = A3_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2 = L4_2(L5_2, L6_2)
  L4_2 = L4_2 > 0
  return L4_2
end
L0_1(L1_1, L2_1)
