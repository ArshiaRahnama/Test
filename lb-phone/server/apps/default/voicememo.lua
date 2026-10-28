local L0_1, L1_1, L2_1, L3_1
L0_1 = BaseCallback
L1_1 = "voiceMemo:saveRecording"
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = A2_2.src
  if L3_2 then
    L3_2 = A2_2.duration
    if L3_2 then
      goto lbl_11
    end
  end
  L3_2 = debugprint
  L4_2 = "VoiceMemo: no src/duration, not saving"
  L3_2(L4_2)
  do return end
  ::lbl_11::
  L3_2 = MySQL
  L3_2 = L3_2.insert
  L3_2 = L3_2.await
  L4_2 = "INSERT INTO phone_voice_memos_recordings (phone_number, file_name, file_url, file_length) VALUES (?, ?, ?, ?)"
  L5_2 = {}
  L6_2 = A1_2
  L7_2 = A2_2.title
  if not L7_2 then
    L7_2 = "Unknown"
  end
  L8_2 = A2_2.src
  L9_2 = A2_2.duration
  L5_2[1] = L6_2
  L5_2[2] = L7_2
  L5_2[3] = L8_2
  L5_2[4] = L9_2
  return L3_2(L4_2, L5_2)
end
L0_1(L1_1, L2_1)
L0_1 = BaseCallback
L1_1 = "voiceMemo:getMemos"
function L2_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT id, file_name AS `title`, file_url AS `src`, file_length AS `duration`, created_at AS `timestamp` FROM phone_voice_memos_recordings WHERE phone_number = ? ORDER BY created_at DESC"
  L4_2 = {}
  L5_2 = A1_2
  L4_2[1] = L5_2
  return L2_2(L3_2, L4_2)
end
L3_1 = {}
L0_1(L1_1, L2_1, L3_1)
L0_1 = BaseCallback
L1_1 = "voiceMemo:deleteMemo"
function L2_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = MySQL
  L3_2 = L3_2.update
  L3_2 = L3_2.await
  L4_2 = "DELETE FROM phone_voice_memos_recordings WHERE id = ? AND phone_number = ?"
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
L1_1 = "renameMemo"
function L2_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L4_2 = MySQL
  L4_2 = L4_2.update
  L4_2 = L4_2.await
  L5_2 = "UPDATE phone_voice_memos_recordings SET file_name = ? WHERE id = ? AND phone_number = ?"
  L6_2 = {}
  L7_2 = A3_2
  L8_2 = A2_2
  L9_2 = A1_2
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L4_2 = L4_2(L5_2, L6_2)
  L4_2 = L4_2 > 0
  return L4_2
end
L0_1(L1_1, L2_1)
