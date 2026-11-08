local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1
L0_1 = "CREATE TABLE IF NOT EXISTS `apex_phone_findmy` (`owner` VARCHAR(64) NOT NULL, `target` VARCHAR(64) NOT NULL, `kind` VARCHAR(8) NOT NULL DEFAULT 'share', `created` BIGINT NOT NULL, PRIMARY KEY (`owner`,`target`,`kind`), KEY `target` (`target`,`kind`))"
L1_1 = CreateThread
function L2_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = pcall
  function L1_2()
    local L0_3, L1_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = L0_1
    L0_3(L1_3)
  end
  L0_2, L1_2 = L0_2(L1_2)
  if not L0_2 then
    L2_2 = print
    L3_2 = "^1[unique_phone]^0 apex_phone_findmy: %s"
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = tostring
    L6_2 = L1_2
    L5_2, L6_2 = L5_2(L6_2)
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
    L2_2(L3_2, L4_2, L5_2, L6_2)
    return
  end
  L2_2 = MigrateTable
  if L2_2 then
    L2_2 = pcall
    L3_2 = MigrateTable
    L4_2 = L0_1
    L2_2(L3_2, L4_2)
  end
end
L1_1(L2_1)
L1_1 = 40
L2_1 = {}
function L3_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L1_2 = L2_1
  L1_2 = L1_2[A0_2]
  if L1_2 then
    L2_2 = GetGameTimer
    L2_2 = L2_2()
    L3_2 = L1_2.at
    L2_2 = L2_2 - L3_2
    L3_2 = 20000
    if L2_2 < L3_2 then
      L2_2 = L1_2.rows
      return L2_2
    end
  end
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT owner, target, kind, created FROM apex_phone_findmy WHERE owner = ? OR target = ?"
  L4_2 = {}
  L5_2 = A0_2
  L6_2 = A0_2
  L4_2[1] = L5_2
  L4_2[2] = L6_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = L2_1
  L4_2 = {}
  L4_2.rows = L2_2
  L5_2 = GetGameTimer
  L5_2 = L5_2()
  L4_2.at = L5_2
  L3_2[A0_2] = L4_2
  return L2_2
end
function L4_1(...)
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = ipairs
  L1_2 = {}
  L2_2, L3_2, L4_2, L5_2, L6_2 = ...
  L1_2[1] = L2_2
  L1_2[2] = L3_2
  L1_2[3] = L4_2
  L1_2[4] = L5_2
  L1_2[5] = L6_2
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
    if L5_2 then
      L6_2 = L2_1
      L6_2[L5_2] = nil
    end
  end
end
function L5_1(A0_2)
  local L1_2, L2_2, L3_2
  if not A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = pcall
  function L2_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3
    L0_3 = GetPlayerPed
    L1_3 = A0_2
    L0_3 = L0_3(L1_3)
    if not L0_3 or 0 == L0_3 then
      L1_3 = nil
      return L1_3
    end
    L1_3 = GetEntityCoords
    L2_3 = L0_3
    L1_3 = L1_3(L2_3)
    L2_3 = {}
    L3_3 = math
    L3_3 = L3_3.floor
    L4_3 = L1_3.x
    L4_3 = L4_3 * 10
    L4_3 = L4_3 + 0.5
    L3_3 = L3_3(L4_3)
    L3_3 = L3_3 / 10
    L2_3.x = L3_3
    L3_3 = math
    L3_3 = L3_3.floor
    L4_3 = L1_3.y
    L4_3 = L4_3 * 10
    L4_3 = L4_3 + 0.5
    L3_3 = L3_3(L4_3)
    L3_3 = L3_3 / 10
    L2_3.y = L3_3
    L3_3 = math
    L3_3 = L3_3.floor
    L4_3 = L1_3.z
    L4_3 = L4_3 * 10
    L4_3 = L4_3 + 0.5
    L3_3 = L3_3(L4_3)
    L3_3 = L3_3 / 10
    L2_3.z = L3_3
    return L2_3
  end
  L1_2, L2_2 = L1_2(L2_2)
  L3_2 = L2_2 or L3_2
  if not L1_2 or not L2_2 then
    L3_2 = nil
  end
  return L3_2
end
function L6_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = FW
  L1_2 = L1_2.GetPlayerByCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = L1_2.firstname
    if not L2_2 then
      L2_2 = ""
    end
    L3_2 = " "
    L4_2 = L1_2.lastname
    if not L4_2 then
      L4_2 = ""
    end
    L2_2 = L2_2 .. L3_2 .. L4_2
    L3_2 = L2_2
    L2_2 = L2_2.gsub
    L4_2 = "^%s+"
    L5_2 = ""
    L2_2 = L2_2(L3_2, L4_2, L5_2)
    L3_2 = L2_2
    L2_2 = L2_2.gsub
    L4_2 = "%s+$"
    L5_2 = ""
    return L2_2(L3_2, L4_2, L5_2)
  end
  L2_2 = pcall
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3
    L0_3 = MySQL
    L0_3 = L0_3.single
    L0_3 = L0_3.await
    L1_3 = "SELECT charinfo FROM players WHERE citizenid = ?"
    L2_3 = {}
    L3_3 = A0_2
    L2_3[1] = L3_3
    return L0_3(L1_3, L2_3)
  end
  L2_2, L3_2 = L2_2(L3_2)
  if L2_2 and L3_2 then
    L4_2 = type
    L5_2 = L3_2.charinfo
    L4_2 = L4_2(L5_2)
    if "string" == L4_2 then
      L4_2 = pcall
      L5_2 = json
      L5_2 = L5_2.decode
      L6_2 = L3_2.charinfo
      L4_2, L5_2 = L4_2(L5_2, L6_2)
      if L4_2 then
        L6_2 = type
        L7_2 = L5_2
        L6_2 = L6_2(L7_2)
        if "table" == L6_2 then
          L6_2 = L5_2.firstname
          if not L6_2 then
            L6_2 = ""
          end
          L7_2 = " "
          L8_2 = L5_2.lastname
          if not L8_2 then
            L8_2 = ""
          end
          L6_2 = L6_2 .. L7_2 .. L8_2
          L7_2 = L6_2
          L6_2 = L6_2.gsub
          L8_2 = "^%s+"
          L9_2 = ""
          L6_2 = L6_2(L7_2, L8_2, L9_2)
          L7_2 = L6_2
          L6_2 = L6_2.gsub
          L8_2 = "%s+$"
          L9_2 = ""
          L6_2 = L6_2(L7_2, L8_2, L9_2)
          if "" ~= L6_2 then
            return L6_2
          end
        end
      end
    end
  end
  L4_2 = MySQL
  L4_2 = L4_2.scalar
  L4_2 = L4_2.await
  L5_2 = "SELECT username FROM apex_phone_accounts WHERE citizenid = ?"
  L6_2 = {}
  L7_2 = A0_2
  L6_2[1] = L7_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 and "" ~= L4_2 then
    L5_2 = "@"
    L6_2 = tostring
    L7_2 = L4_2
    L6_2 = L6_2(L7_2)
    L5_2 = L5_2 .. L6_2
    if L5_2 then
      goto lbl_92
    end
  end
  L5_2 = "Sem nome"
  ::lbl_92::
  return L5_2
end
function L7_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = {}
  L2_2 = GetNumberByCitizenId
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L1_2.number = L2_2
  L2_2 = L6_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L1_2.name = L2_2
  return L1_2
end
function L8_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = nil
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "noplayer"
    return L3_2, L4_2
  end
  L3_2 = tostring
  L4_2 = A1_2.number
  if not L4_2 then
    L4_2 = ""
  end
  L3_2 = L3_2(L4_2)
  L4_2 = L3_2
  L3_2 = L3_2.sub
  L5_2 = 1
  L6_2 = 20
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = GetCitizenIdByNumber
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = nil
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "target"
    return L5_2, L6_2
  end
  L5_2 = L2_2.cid
  if L4_2 == L5_2 then
    L5_2 = nil
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "self"
    return L5_2, L6_2
  end
  L5_2 = L2_2
  L6_2 = nil
  L7_2 = L4_2
  return L5_2, L6_2, L7_2
end
function L9_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = FW
  L1_2 = L1_2.GetPlayerByCid
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L2_2 = Push
    L3_2 = L1_2.src
    L4_2 = "findmy:changed"
    L5_2 = {}
    L2_2(L3_2, L4_2, L5_2)
  end
end
L10_1 = RPC
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2
  L1_2 = FW
  L1_2 = L1_2.GetPlayer
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L2_2 = {}
    L2_2.error = "noplayer"
    return L2_2
  end
  L2_2 = L1_2.cid
  L3_2 = L3_1
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L4_2 = false
  L5_2 = {}
  L6_2 = {}
  L7_2 = {}
  L8_2 = {}
  L9_2 = {}
  L10_2 = ipairs
  L11_2 = L3_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = L15_2.owner
    if L16_2 == L2_2 then
      L16_2 = L15_2.kind
      if "share" == L16_2 then
        L16_2 = L15_2.target
        L9_2[L16_2] = true
      end
    end
  end
  L10_2 = ipairs
  L11_2 = L3_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = L15_2.kind
    if "pause" == L16_2 then
      L16_2 = L15_2.owner
      if L16_2 == L2_2 then
        L4_2 = true
    end
    else
      L16_2 = L15_2.kind
      if "share" == L16_2 then
        L16_2 = L15_2.owner
        if L16_2 == L2_2 then
          L16_2 = L7_1
          L17_2 = L15_2.target
          L16_2 = L16_2(L17_2)
          L16_2.mutual = false
          L17_2 = #L5_2
          L17_2 = L17_2 + 1
          L5_2[L17_2] = L16_2
      end
      else
        L16_2 = L15_2.kind
        if "share" == L16_2 then
          L16_2 = L15_2.target
          if L16_2 == L2_2 then
            L16_2 = L7_1
            L17_2 = L15_2.owner
            L16_2 = L16_2(L17_2)
            L17_2 = FW
            L17_2 = L17_2.GetPlayerByCid
            L18_2 = L15_2.owner
            L17_2 = L17_2(L18_2)
            L18_2 = false
            if L17_2 then
              L19_2 = L3_1
              L20_2 = L15_2.owner
              L19_2 = L19_2(L20_2)
              L20_2 = ipairs
              L21_2 = L19_2
              L20_2, L21_2, L22_2, L23_2 = L20_2(L21_2)
              for L24_2, L25_2 in L20_2, L21_2, L22_2, L23_2 do
                L26_2 = L25_2.owner
                L27_2 = L15_2.owner
                if L26_2 == L27_2 then
                  L26_2 = L25_2.kind
                  if "pause" == L26_2 then
                    L18_2 = true
                    break
                  end
                end
              end
            end
            if L17_2 and not L18_2 then
              L19_2 = L5_1
              L20_2 = L17_2.src
              L19_2 = L19_2(L20_2)
              if L19_2 then
                goto lbl_113
              end
            end
            L19_2 = nil
            ::lbl_113::
            L20_2 = nil ~= L17_2
            L16_2.online = L20_2
            L16_2.paused = L18_2
            if L19_2 then
              L20_2 = L19_2.x
              L16_2.x = L20_2
              L20_2 = L19_2.y
              L16_2.y = L20_2
              L20_2 = L19_2.z
              L16_2.z = L20_2
              L20_2 = Now
              L20_2 = L20_2()
              L16_2.updated = L20_2
            end
            L20_2 = L15_2.owner
            L20_2 = L9_2[L20_2]
            L20_2 = true == L20_2
            L16_2.sharing = L20_2
            L20_2 = L16_2.sharing
            L16_2.mutual = L20_2
            L20_2 = #L6_2
            L20_2 = L20_2 + 1
            L6_2[L20_2] = L16_2
        end
        else
          L16_2 = L15_2.kind
          if "req" == L16_2 then
            L16_2 = L15_2.target
            if L16_2 == L2_2 then
              L16_2 = L7_1
              L17_2 = L15_2.owner
              L16_2 = L16_2(L17_2)
              L17_2 = L15_2.created
              L16_2.created = L17_2
              L17_2 = #L7_2
              L17_2 = L17_2 + 1
              L7_2[L17_2] = L16_2
          end
          else
            L16_2 = L15_2.kind
            if "req" == L16_2 then
              L16_2 = L15_2.owner
              if L16_2 == L2_2 then
                L16_2 = #L8_2
                L16_2 = L16_2 + 1
                L17_2 = L7_1
                L18_2 = L15_2.target
                L17_2 = L17_2(L18_2)
                L8_2[L16_2] = L17_2
              end
            end
          end
        end
      end
    end
  end
  L10_2 = ipairs
  L11_2 = L5_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = ipairs
    L17_2 = L6_2
    L16_2, L17_2, L18_2, L19_2 = L16_2(L17_2)
    for L20_2, L21_2 in L16_2, L17_2, L18_2, L19_2 do
      L22_2 = L21_2.number
      L23_2 = L15_2.number
      if L22_2 == L23_2 then
        L15_2.mutual = true
      end
    end
  end
  L10_2 = {}
  L11_2 = L5_1
  L12_2 = A0_2
  L11_2 = L11_2(L12_2)
  L10_2.me = L11_2
  L10_2.paused = L4_2
  L10_2.people = L6_2
  L10_2.sharing = L5_2
  L10_2.requests = L7_2
  L10_2.requested = L8_2
  return L10_2
end
L10_1["findmy.list"] = L11_1
function L10_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = MySQL
  L3_2 = L3_2.scalar
  L3_2 = L3_2.await
  L4_2 = "SELECT COUNT(*) FROM apex_phone_findmy WHERE owner = ? AND kind = 'share'"
  L5_2 = {}
  L6_2 = A0_2.cid
  L5_2[1] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  L4_2 = tonumber
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L4_2 = 0
  end
  L5_2 = L1_1
  if L4_2 >= L5_2 then
    L4_2 = {}
    L4_2.ok = false
    L4_2.error = "limit"
    return L4_2
  end
  L4_2 = MySQL
  L4_2 = L4_2.update
  L4_2 = L4_2.await
  L5_2 = "INSERT IGNORE INTO apex_phone_findmy (owner, target, kind, created) VALUES (?, ?, 'share', ?)"
  L6_2 = {}
  L7_2 = A0_2.cid
  L8_2 = A1_2
  L9_2 = Now
  L9_2, L10_2, L11_2, L12_2 = L9_2()
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L6_2[3] = L9_2
  L6_2[4] = L10_2
  L6_2[5] = L11_2
  L6_2[6] = L12_2
  L4_2(L5_2, L6_2)
  L4_2 = MySQL
  L4_2 = L4_2.update
  L4_2 = L4_2.await
  L5_2 = "DELETE FROM apex_phone_findmy WHERE owner = ? AND target = ? AND kind = 'req'"
  L6_2 = {}
  L7_2 = A1_2
  L8_2 = A0_2.cid
  L6_2[1] = L7_2
  L6_2[2] = L8_2
  L4_2(L5_2, L6_2)
  L4_2 = L4_1
  L5_2 = A0_2.cid
  L6_2 = A1_2
  L4_2(L5_2, L6_2)
  L4_2 = A0_2.firstname
  if not L4_2 then
    L4_2 = ""
  end
  L5_2 = " "
  L6_2 = A0_2.lastname
  if not L6_2 then
    L6_2 = ""
  end
  L4_2 = L4_2 .. L5_2 .. L6_2
  L5_2 = L4_2
  L4_2 = L4_2.gsub
  L6_2 = "%s+$"
  L7_2 = ""
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L5_2 = NotifyCitizen
  L6_2 = A1_2
  L7_2 = "findmy"
  L8_2 = "Localiza\195\167\195\163o partilhada"
  L9_2 = "%s come\195\167ou a partilhar a localiza\195\167\195\163o contigo."
  L10_2 = L9_2
  L9_2 = L9_2.format
  L11_2 = L4_2
  L9_2 = L9_2(L10_2, L11_2)
  L10_2 = {}
  L11_2 = GetPlayerNumber
  L12_2 = A2_2
  L11_2 = L11_2(L12_2)
  L10_2.number = L11_2
  L10_2.kind = "share"
  L5_2(L6_2, L7_2, L8_2, L9_2, L10_2)
  L5_2 = L9_1
  L6_2 = A1_2
  L5_2(L6_2)
  L5_2 = {}
  L5_2.ok = true
  return L5_2
end
L11_1 = RPC
function L12_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L8_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  if L3_2 then
    return L3_2
  end
  L5_2 = A1_2.on
  if false == L5_2 then
    L5_2 = MySQL
    L5_2 = L5_2.update
    L5_2 = L5_2.await
    L6_2 = "DELETE FROM apex_phone_findmy WHERE owner = ? AND target = ? AND kind = 'share'"
    L7_2 = {}
    L8_2 = L2_2.cid
    L9_2 = L4_2
    L7_2[1] = L8_2
    L7_2[2] = L9_2
    L5_2(L6_2, L7_2)
    L5_2 = L4_1
    L6_2 = L2_2.cid
    L7_2 = L4_2
    L5_2(L6_2, L7_2)
    L5_2 = L9_1
    L6_2 = L4_2
    L5_2(L6_2)
    L5_2 = {}
    L5_2.ok = true
    return L5_2
  end
  L5_2 = L10_1
  L6_2 = L2_2
  L7_2 = L4_2
  L8_2 = A0_2
  return L5_2(L6_2, L7_2, L8_2)
end
L11_1["findmy.share"] = L12_1
L11_1 = RPC
function L12_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2
  L2_2 = L8_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  if L3_2 then
    return L3_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.scalar
  L5_2 = L5_2.await
  L6_2 = "SELECT COUNT(*) FROM apex_phone_findmy WHERE owner = ? AND target = ? AND kind = 'share'"
  L7_2 = {}
  L8_2 = L4_2
  L9_2 = L2_2.cid
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = tonumber
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  if L6_2 > 0 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "already"
    return L6_2
  end
  L6_2 = MySQL
  L6_2 = L6_2.scalar
  L6_2 = L6_2.await
  L7_2 = "SELECT COUNT(*) FROM apex_phone_findmy WHERE owner = ? AND kind = 'req'"
  L8_2 = {}
  L9_2 = L2_2.cid
  L8_2[1] = L9_2
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = tonumber
  L8_2 = L6_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = 0
  end
  L8_2 = L1_1
  if L7_2 >= L8_2 then
    L7_2 = {}
    L7_2.ok = false
    L7_2.error = "limit"
    return L7_2
  end
  L7_2 = MySQL
  L7_2 = L7_2.update
  L7_2 = L7_2.await
  L8_2 = "INSERT IGNORE INTO apex_phone_findmy (owner, target, kind, created) VALUES (?, ?, 'req', ?)"
  L9_2 = {}
  L10_2 = L2_2.cid
  L11_2 = L4_2
  L12_2 = Now
  L12_2, L13_2, L14_2, L15_2, L16_2 = L12_2()
  L9_2[1] = L10_2
  L9_2[2] = L11_2
  L9_2[3] = L12_2
  L9_2[4] = L13_2
  L9_2[5] = L14_2
  L9_2[6] = L15_2
  L9_2[7] = L16_2
  L7_2 = L7_2(L8_2, L9_2)
  L8_2 = L4_1
  L9_2 = L2_2.cid
  L10_2 = L4_2
  L8_2(L9_2, L10_2)
  L8_2 = tonumber
  L9_2 = L7_2
  L8_2 = L8_2(L9_2)
  if not L8_2 then
    L8_2 = 0
  end
  if L8_2 > 0 then
    L8_2 = L2_2.firstname
    if not L8_2 then
      L8_2 = ""
    end
    L9_2 = " "
    L10_2 = L2_2.lastname
    if not L10_2 then
      L10_2 = ""
    end
    L8_2 = L8_2 .. L9_2 .. L10_2
    L9_2 = L8_2
    L8_2 = L8_2.gsub
    L10_2 = "%s+$"
    L11_2 = ""
    L8_2 = L8_2(L9_2, L10_2, L11_2)
    L9_2 = NotifyCitizen
    L10_2 = L4_2
    L11_2 = "findmy"
    L12_2 = "Pedido de localiza\195\167\195\163o"
    L13_2 = "%s quer ver a tua localiza\195\167\195\163o. Abre a app Encontrar para responder."
    L14_2 = L13_2
    L13_2 = L13_2.format
    L15_2 = L8_2
    L13_2 = L13_2(L14_2, L15_2)
    L14_2 = {}
    L15_2 = GetPlayerNumber
    L16_2 = A0_2
    L15_2 = L15_2(L16_2)
    L14_2.number = L15_2
    L14_2.kind = "req"
    L9_2(L10_2, L11_2, L12_2, L13_2, L14_2)
    L9_2 = L9_1
    L10_2 = L4_2
    L9_2(L10_2)
  end
  L8_2 = {}
  L8_2.ok = true
  return L8_2
end
L11_1["findmy.request"] = L12_1
L11_1 = RPC
function L12_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L2_2 = L8_1
  L3_2 = A0_2
  L4_2 = A1_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  if L3_2 then
    return L3_2
  end
  L5_2 = MySQL
  L5_2 = L5_2.update
  L5_2 = L5_2.await
  L6_2 = "DELETE FROM apex_phone_findmy WHERE owner = ? AND target = ? AND kind = 'req'"
  L7_2 = {}
  L8_2 = L4_2
  L9_2 = L2_2.cid
  L7_2[1] = L8_2
  L7_2[2] = L9_2
  L5_2 = L5_2(L6_2, L7_2)
  L6_2 = L4_1
  L7_2 = L2_2.cid
  L8_2 = L4_2
  L6_2(L7_2, L8_2)
  L6_2 = tonumber
  L7_2 = L5_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = 0
  end
  if 0 == L6_2 then
    L6_2 = {}
    L6_2.ok = false
    L6_2.error = "invalid"
    return L6_2
  end
  L6_2 = A1_2.accept
  if true == L6_2 then
    L6_2 = L10_1
    L7_2 = L2_2
    L8_2 = L4_2
    L9_2 = A0_2
    return L6_2(L7_2, L8_2, L9_2)
  end
  L6_2 = L9_1
  L7_2 = L4_2
  L6_2(L7_2)
  L6_2 = {}
  L6_2.ok = true
  return L6_2
end
L11_1["findmy.respond"] = L12_1
L11_1 = RPC
function L12_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = FW
  L2_2 = L2_2.GetPlayer
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L3_2 = {}
    L3_2.ok = false
    L3_2.error = "noplayer"
    return L3_2
  end
  L3_2 = A1_2.on
  if true == L3_2 then
    L3_2 = MySQL
    L3_2 = L3_2.update
    L3_2 = L3_2.await
    L4_2 = "INSERT IGNORE INTO apex_phone_findmy (owner, target, kind, created) VALUES (?, '*', 'pause', ?)"
    L5_2 = {}
    L6_2 = L2_2.cid
    L7_2 = Now
    L7_2, L8_2, L9_2, L10_2 = L7_2()
    L5_2[1] = L6_2
    L5_2[2] = L7_2
    L5_2[3] = L8_2
    L5_2[4] = L9_2
    L5_2[5] = L10_2
    L3_2(L4_2, L5_2)
  else
    L3_2 = MySQL
    L3_2 = L3_2.update
    L3_2 = L3_2.await
    L4_2 = "DELETE FROM apex_phone_findmy WHERE owner = ? AND kind = 'pause'"
    L5_2 = {}
    L6_2 = L2_2.cid
    L5_2[1] = L6_2
    L3_2(L4_2, L5_2)
  end
  L3_2 = L4_1
  L4_2 = L2_2.cid
  L3_2(L4_2)
  L3_2 = ipairs
  L4_2 = L3_1
  L5_2 = L2_2.cid
  L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L4_2(L5_2)
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.owner
    L10_2 = L2_2.cid
    if L9_2 == L10_2 then
      L9_2 = L8_2.kind
      if "share" == L9_2 then
        L9_2 = L9_1
        L10_2 = L8_2.target
        L9_2(L10_2)
      end
    end
  end
  L3_2 = {}
  L3_2.ok = true
  L4_2 = A1_2.on
  L4_2 = true == L4_2
  L3_2.paused = L4_2
  return L3_2
end
L11_1["findmy.pause"] = L12_1
