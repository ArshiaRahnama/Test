local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1
L0_1 = "phonewipe"
L1_1 = {}
L1_1.apex_phone_admin = true
L1_1.apex_phone_admin_log = true
L2_1 = {}
function L3_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = ConsoleText
  if L3_2 then
    L3_2 = ConsoleText
    L4_2 = A1_2
    L3_2 = L3_2(L4_2)
    if L3_2 then
      goto lbl_10
    end
  end
  L3_2 = A1_2
  ::lbl_10::
  if 0 == A0_2 then
    L4_2 = print
    L5_2 = "^3[apex_phone wipe]^0 "
    L6_2 = L3_2
    L5_2 = L5_2 .. L6_2
    L4_2(L5_2)
    return
  end
  L4_2 = print
  L5_2 = "[apex_phone wipe] %s: %s"
  L6_2 = L5_2
  L5_2 = L5_2.format
  L7_2 = GetPlayerName
  L8_2 = A0_2
  L7_2 = L7_2(L8_2)
  if not L7_2 then
    L7_2 = A0_2
  end
  L8_2 = L3_2
  L5_2, L6_2, L7_2, L8_2, L9_2 = L5_2(L6_2, L7_2, L8_2)
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
  L4_2 = TriggerClientEvent
  L5_2 = "apex_phone:client:wipeSay"
  L6_2 = A0_2
  L7_2 = A1_2
  if "error" == A2_2 then
    L8_2 = "error"
    if L8_2 then
      goto lbl_40
    end
  end
  L8_2 = "primary"
  ::lbl_40::
  L9_2 = true
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
end
function L4_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L1_2 = "string" == L1_2
  return L1_2
end
function L5_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L0_2 = MySQL
  L0_2 = L0_2.query
  L0_2 = L0_2.await
  L1_2 = [[
SELECT table_name AS t, table_rows AS n FROM information_schema.tables
        WHERE table_schema = DATABASE() AND table_name LIKE 'apex\_phone\_%' ORDER BY table_name]]
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = {}
  end
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = L0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.t
    if not L8_2 then
      L8_2 = L7_2.TABLE_NAME
      if not L8_2 then
        L8_2 = L7_2.table_name
      end
    end
    L9_2 = L4_1
    L10_2 = L8_2
    L9_2 = L9_2(L10_2)
    if L9_2 then
      L9_2 = #L1_2
      L9_2 = L9_2 + 1
      L10_2 = {}
      L10_2.name = L8_2
      L11_2 = tonumber
      L12_2 = L7_2.n
      if not L12_2 then
        L12_2 = L7_2.TABLE_ROWS
      end
      L11_2 = L11_2(L12_2)
      if not L11_2 then
        L11_2 = 0
      end
      L10_2.rows = L11_2
      L1_2[L9_2] = L10_2
    end
  end
  return L1_2
end
function L6_1()
  local L0_2, L1_2
  L0_2 = os
  L0_2 = L0_2.date
  L1_2 = "%Y%m%d_%H%M"
  return L0_2(L1_2)
end
function L7_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = 0
  L3_2 = ipairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.name
    L10_2 = L9_2
    L9_2 = L9_2.gsub
    L11_2 = "^apex_phone_"
    L12_2 = ""
    L9_2 = L9_2(L10_2, L11_2, L12_2)
    L10_2 = "zbak_apexphone_%s_%s"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = A1_2
    L13_2 = L9_2
    L10_2 = L10_2(L11_2, L12_2, L13_2)
    L11_2 = L10_2
    L10_2 = L10_2.sub
    L12_2 = 1
    L13_2 = 64
    L10_2 = L10_2(L11_2, L12_2, L13_2)
    L11_2 = MySQL
    L11_2 = L11_2.query
    L11_2 = L11_2.await
    L12_2 = "DROP TABLE IF EXISTS `%s`"
    L13_2 = L12_2
    L12_2 = L12_2.format
    L14_2 = L10_2
    L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2, L14_2)
    L11_2(L12_2, L13_2, L14_2, L15_2)
    L11_2 = MySQL
    L11_2 = L11_2.query
    L11_2 = L11_2.await
    L12_2 = "CREATE TABLE `%s` LIKE `%s`"
    L13_2 = L12_2
    L12_2 = L12_2.format
    L14_2 = L10_2
    L15_2 = L8_2.name
    L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2, L14_2, L15_2)
    L11_2(L12_2, L13_2, L14_2, L15_2)
    L11_2 = MySQL
    L11_2 = L11_2.query
    L11_2 = L11_2.await
    L12_2 = "INSERT INTO `%s` SELECT * FROM `%s`"
    L13_2 = L12_2
    L12_2 = L12_2.format
    L14_2 = L10_2
    L15_2 = L8_2.name
    L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2, L14_2, L15_2)
    L11_2(L12_2, L13_2, L14_2, L15_2)
    L2_2 = L2_2 + 1
  end
  return L2_2
end
function L8_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L5_1
  L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L5_2()
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    if not A1_2 then
      L11_2 = L9_2.name
      L10_2 = L1_1
      L10_2 = L10_2[L11_2]
      if L10_2 then
        goto lbl_19
      end
    end
    L10_2 = #L3_2
    L10_2 = L10_2 + 1
    L3_2[L10_2] = L9_2
    ::lbl_19::
  end
  L4_2 = #L3_2
  if 0 == L4_2 then
    L4_2 = L3_1
    L5_2 = A0_2
    L6_2 = "N\195\163o h\195\161 tabelas do telem\195\179vel para apagar."
    L4_2(L5_2, L6_2)
    return
  end
  L4_2 = L6_1
  L4_2 = L4_2()
  if A2_2 then
    L5_2 = L3_1
    L6_2 = A0_2
    L7_2 = "A fazer c\195\179pia de %d tabelas (zbak_apexphone_%s_*)..."
    L8_2 = L7_2
    L7_2 = L7_2.format
    L9_2 = #L3_2
    L10_2 = L4_2
    L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L7_2(L8_2, L9_2, L10_2)
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    L5_2 = pcall
    L6_2 = L7_1
    L7_2 = L3_2
    L8_2 = L4_2
    L5_2, L6_2 = L5_2(L6_2, L7_2, L8_2)
    if not L5_2 then
      L7_2 = L3_1
      L8_2 = A0_2
      L9_2 = "A c\195\179pia falhou, NADA foi apagado: %s"
      L10_2 = L9_2
      L9_2 = L9_2.format
      L11_2 = tostring
      L12_2 = L6_2
      L11_2, L12_2, L13_2, L14_2, L15_2 = L11_2(L12_2)
      L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
      L10_2 = "error"
      L7_2(L8_2, L9_2, L10_2)
      return
    end
  end
  L5_2 = 0
  L6_2 = {}
  L7_2 = pcall
  function L8_2()
    local L0_3, L1_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "SET FOREIGN_KEY_CHECKS = 0"
    L0_3(L1_3)
  end
  L7_2(L8_2)
  L7_2 = ipairs
  L8_2 = L3_2
  L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
  for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
    L13_2 = pcall
    function L14_2()
      local L0_3, L1_3, L2_3, L3_3
      L0_3 = MySQL
      L0_3 = L0_3.query
      L0_3 = L0_3.await
      L1_3 = "TRUNCATE TABLE `%s`"
      L2_3 = L1_3
      L1_3 = L1_3.format
      L3_3 = L12_2.name
      L1_3, L2_3, L3_3 = L1_3(L2_3, L3_3)
      L0_3(L1_3, L2_3, L3_3)
    end
    L13_2 = L13_2(L14_2)
    if not L13_2 then
      L14_2 = pcall
      function L15_2()
        local L0_3, L1_3, L2_3, L3_3
        L0_3 = MySQL
        L0_3 = L0_3.query
        L0_3 = L0_3.await
        L1_3 = "DELETE FROM `%s`"
        L2_3 = L1_3
        L1_3 = L1_3.format
        L3_3 = L12_2.name
        L1_3, L2_3, L3_3 = L1_3(L2_3, L3_3)
        L0_3(L1_3, L2_3, L3_3)
      end
      L14_2 = L14_2(L15_2)
      L13_2 = L14_2
    end
    if L13_2 then
      L5_2 = L5_2 + 1
    else
      L14_2 = #L6_2
      L14_2 = L14_2 + 1
      L15_2 = L12_2.name
      L6_2[L14_2] = L15_2
    end
  end
  L7_2 = pcall
  function L8_2()
    local L0_3, L1_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = "SET FOREIGN_KEY_CHECKS = 1"
    L0_3(L1_3)
  end
  L7_2(L8_2)
  L7_2 = type
  L8_2 = Accounts
  L7_2 = L7_2(L8_2)
  if "table" == L7_2 then
    L7_2 = pairs
    L8_2 = Accounts
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2 in L7_2, L8_2, L9_2, L10_2 do
      L12_2 = Accounts
      L12_2[L11_2] = nil
    end
  end
  L7_2 = InvalidateOnlineIndex
  if L7_2 then
    L7_2 = InvalidateOnlineIndex
    L7_2()
  end
  if A1_2 then
    L7_2 = type
    L8_2 = AdminStore
    L7_2 = L7_2(L8_2)
    if "table" == L7_2 then
      L7_2 = type
      L8_2 = AdminStore
      L8_2 = L8_2.data
      L7_2 = L7_2(L8_2)
      if "table" == L7_2 then
        L7_2 = pairs
        L8_2 = AdminStore
        L8_2 = L8_2.data
        L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
        for L11_2 in L7_2, L8_2, L9_2, L10_2 do
          L12_2 = AdminStore
          L12_2 = L12_2.data
          L12_2[L11_2] = nil
        end
      end
    end
  end
  L7_2 = L3_1
  L8_2 = A0_2
  if A1_2 then
    L9_2 = "Base de dados do telem\195\179vel apagada: %d tabelas (incluindo o painel admin)."
    if L9_2 then
      goto lbl_147
    end
  end
  L9_2 = "Base de dados do telem\195\179vel apagada: %d tabelas (defini\195\167\195\181es do painel admin mantidas)."
  ::lbl_147::
  L10_2 = L9_2
  L9_2 = L9_2.format
  L11_2 = L5_2
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L9_2(L10_2, L11_2)
  L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  L7_2 = #L6_2
  if L7_2 > 0 then
    L7_2 = L3_1
    L8_2 = A0_2
    L9_2 = "Falharam: %s"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = table
    L11_2 = L11_2.concat
    L12_2 = L6_2
    L13_2 = ", "
    L11_2, L12_2, L13_2, L14_2, L15_2 = L11_2(L12_2, L13_2)
    L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
    L10_2 = "error"
    L7_2(L8_2, L9_2, L10_2)
  end
  if A2_2 then
    L7_2 = L3_1
    L8_2 = A0_2
    L9_2 = "C\195\179pia guardada nas tabelas zbak_apexphone_%s_* (/%s backups)."
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = L4_2
    L12_2 = L0_1
    L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L9_2(L10_2, L11_2, L12_2)
    L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
  end
  L7_2 = L3_1
  L8_2 = A0_2
  L9_2 = "Agora: restart apex_phone. Os jogadores voltam a configurar o telem\195\179vel quando o abrirem."
  L7_2(L8_2, L9_2)
  if not A1_2 then
    L7_2 = AdminStore
    if L7_2 then
      L7_2 = AdminStore
      L7_2 = L7_2.Log
      if L7_2 then
        L7_2 = AdminStore
        L7_2 = L7_2.Log
        L8_2 = A0_2
        L9_2 = "phone.wipe"
        L10_2 = "%d tabelas apagadas%s"
        L11_2 = L10_2
        L10_2 = L10_2.format
        L12_2 = L5_2
        if A2_2 then
          L13_2 = " \194\183 c\195\179pia "
          L14_2 = L4_2
          L13_2 = L13_2 .. L14_2
          if L13_2 then
            goto lbl_204
          end
        end
        L13_2 = " \194\183 sem c\195\179pia"
        ::lbl_204::
        L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L10_2(L11_2, L12_2, L13_2)
        L7_2(L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2)
      end
    end
  end
end
function L9_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L1_2 = MySQL
  L1_2 = L1_2.query
  L1_2 = L1_2.await
  L2_2 = [[
SELECT table_name AS t FROM information_schema.tables WHERE table_schema = DATABASE()
        AND table_name LIKE 'zbak\_apexphone\_%' ORDER BY table_name]]
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L1_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.t
    if not L9_2 then
      L9_2 = L8_2.TABLE_NAME
    end
    L10_2 = L9_2 or L10_2
    if L9_2 then
      L11_2 = L9_2
      L10_2 = L9_2.match
      L12_2 = "^zbak_apexphone_(%d+_%d+)_"
      L10_2 = L10_2(L11_2, L12_2)
    end
    if L10_2 then
      L11_2 = L2_2[L10_2]
      if not L11_2 then
        L11_2 = 0
      end
      L11_2 = L11_2 + 1
      L2_2[L10_2] = L11_2
    end
  end
  L3_2 = false
  L4_2 = pairs
  L5_2 = L2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L3_2 = true
    L10_2 = L3_1
    L11_2 = A0_2
    L12_2 = "c\195\179pia %s: %d tabelas"
    L13_2 = L12_2
    L12_2 = L12_2.format
    L14_2 = L8_2
    L15_2 = L9_2
    L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2, L14_2, L15_2)
    L10_2(L11_2, L12_2, L13_2, L14_2, L15_2)
  end
  if not L3_2 then
    L4_2 = L3_1
    L5_2 = A0_2
    L6_2 = "N\195\163o h\195\161 c\195\179pias."
    L4_2(L5_2, L6_2)
  end
end
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  if A1_2 then
    L3_2 = A1_2
    L2_2 = A1_2.match
    L4_2 = "^%d+_%d+$"
    L2_2 = L2_2(L3_2, L4_2)
    if L2_2 then
      goto lbl_17
    end
  end
  L2_2 = L3_1
  L3_2 = A0_2
  L4_2 = "Uso: /%s dropbackup <AAAAMMDD_HHMM>"
  L5_2 = L4_2
  L4_2 = L4_2.format
  L6_2 = L0_1
  L4_2 = L4_2(L5_2, L6_2)
  L5_2 = "error"
  L2_2(L3_2, L4_2, L5_2)
  do return end
  ::lbl_17::
  L2_2 = MySQL
  L2_2 = L2_2.query
  L2_2 = L2_2.await
  L3_2 = "SELECT table_name AS t FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name LIKE ?"
  L4_2 = {}
  L5_2 = "zbak\\_apexphone\\_"
  L6_2 = A1_2
  L7_2 = "\\_%"
  L5_2 = L5_2 .. L6_2 .. L7_2
  L4_2[1] = L5_2
  L2_2 = L2_2(L3_2, L4_2)
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = 0
  L4_2 = ipairs
  L5_2 = L2_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L9_2.t
    if not L10_2 then
      L10_2 = L9_2.TABLE_NAME
    end
    L11_2 = L4_1
    L12_2 = L10_2
    L11_2 = L11_2(L12_2)
    if L11_2 then
      L12_2 = L10_2
      L11_2 = L10_2.sub
      L13_2 = 1
      L14_2 = 15
      L11_2 = L11_2(L12_2, L13_2, L14_2)
      if "zbak_apexphone_" == L11_2 then
        L11_2 = MySQL
        L11_2 = L11_2.query
        L11_2 = L11_2.await
        L12_2 = "DROP TABLE `%s`"
        L13_2 = L12_2
        L12_2 = L12_2.format
        L14_2 = L10_2
        L12_2, L13_2, L14_2 = L12_2(L13_2, L14_2)
        L11_2(L12_2, L13_2, L14_2)
        L3_2 = L3_2 + 1
      end
    end
  end
  L4_2 = L3_1
  L5_2 = A0_2
  L6_2 = "C\195\179pia %s apagada (%d tabelas)."
  L7_2 = L6_2
  L6_2 = L6_2.format
  L8_2 = A1_2
  L9_2 = L3_2
  L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2 = L6_2(L7_2, L8_2, L9_2)
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2)
end
L11_1 = RegisterCommand
L12_1 = L0_1
function L13_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  if 0 ~= A0_2 then
    L2_2 = IsPhoneAdmin
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if not L2_2 then
      return
    end
  end
  L2_2 = tostring
  L3_2 = A1_2[1]
  if not L3_2 then
    L3_2 = ""
  end
  L2_2 = L2_2(L3_2)
  L3_2 = L2_2
  L2_2 = L2_2.lower
  L2_2 = L2_2(L3_2)
  L3_2 = CreateThread
  function L4_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L0_3 = pcall
    function L1_3()
      local L0_4, L1_4, L2_4, L3_4, L4_4, L5_4, L6_4, L7_4, L8_4, L9_4, L10_4, L11_4
      L0_4 = L2_2
      if "backups" == L0_4 then
        L0_4 = L9_1
        L1_4 = A0_2
        L0_4(L1_4)
        return
      end
      L0_4 = L2_2
      if "dropbackup" == L0_4 then
        L0_4 = L10_1
        L1_4 = A0_2
        L2_4 = A1_2
        L2_4 = L2_4[2]
        L0_4(L1_4, L2_4)
        return
      end
      L0_4 = L2_2
      if "confirm" == L0_4 then
        L1_4 = A0_2
        L0_4 = L2_1
        L0_4 = L0_4[L1_4]
        if L0_4 then
          L1_4 = GetGameTimer
          L1_4 = L1_4()
          L2_4 = L0_4.untilT
          if not (L1_4 > L2_4) then
            goto lbl_39
          end
        end
        L1_4 = L3_1
        L2_4 = A0_2
        L3_4 = "Sem pedido v\195\161lido: escreve primeiro /%s."
        L4_4 = L3_4
        L3_4 = L3_4.format
        L5_4 = L0_1
        L3_4 = L3_4(L4_4, L5_4)
        L4_4 = "error"
        L1_4(L2_4, L3_4, L4_4)
        do return end
        ::lbl_39::
        L1_4 = tostring
        L2_4 = A1_2
        L2_4 = L2_4[2]
        if not L2_4 then
          L2_4 = ""
        end
        L1_4 = L1_4(L2_4)
        L2_4 = L0_4.code
        if L1_4 ~= L2_4 then
          L1_4 = L3_1
          L2_4 = A0_2
          L3_4 = "C\195\179digo errado. Nada foi apagado."
          L4_4 = "error"
          L1_4(L2_4, L3_4, L4_4)
          return
        end
        L2_4 = A0_2
        L1_4 = L2_1
        L1_4[L2_4] = nil
        L1_4 = {}
        L2_4 = 3
        L3_4 = A1_2
        L3_4 = #L3_4
        L4_4 = 1
        for L5_4 = L2_4, L3_4, L4_4 do
          L6_4 = tostring
          L7_4 = A1_2
          L7_4 = L7_4[L5_4]
          L6_4 = L6_4(L7_4)
          L7_4 = L6_4
          L6_4 = L6_4.lower
          L6_4 = L6_4(L7_4)
          L1_4[L6_4] = true
        end
        L2_4 = L8_1
        L3_4 = A0_2
        L4_4 = L1_4.all
        L4_4 = true == L4_4
        L5_4 = L1_4.nobackup
        L5_4 = not L5_4
        L2_4(L3_4, L4_4, L5_4)
        return
      end
      L0_4 = {}
      L1_4 = 1
      L2_4 = A1_2
      L2_4 = #L2_4
      L3_4 = 1
      for L4_4 = L1_4, L2_4, L3_4 do
        L5_4 = tostring
        L6_4 = A1_2
        L6_4 = L6_4[L4_4]
        L5_4 = L5_4(L6_4)
        L6_4 = L5_4
        L5_4 = L5_4.lower
        L5_4 = L5_4(L6_4)
        L0_4[L5_4] = true
      end
      L1_4 = A0_2
      if 0 ~= L1_4 then
        L1_4 = L5_1
        L1_4 = L1_4()
        L2_4 = 0
        L3_4 = 0
        L4_4 = ipairs
        L5_4 = L1_4
        L4_4, L5_4, L6_4, L7_4 = L4_4(L5_4)
        for L8_4, L9_4 in L4_4, L5_4, L6_4, L7_4 do
          L10_4 = L0_4.all
          if not L10_4 then
            L11_4 = L9_4.name
            L10_4 = L1_1
            L10_4 = L10_4[L11_4]
            if L10_4 then
              goto lbl_123
            end
          end
          L10_4 = L9_4.rows
          L2_4 = L2_4 + L10_4
          L3_4 = L3_4 + 1
          ::lbl_123::
        end
        L4_4 = tostring
        L5_4 = math
        L5_4 = L5_4.random
        L6_4 = 1000
        L7_4 = 9999
        L5_4, L6_4, L7_4, L8_4, L9_4, L10_4, L11_4 = L5_4(L6_4, L7_4)
        L4_4 = L4_4(L5_4, L6_4, L7_4, L8_4, L9_4, L10_4, L11_4)
        L6_4 = A0_2
        L5_4 = L2_1
        L7_4 = {}
        L7_4.code = L4_4
        L8_4 = GetGameTimer
        L8_4 = L8_4()
        L8_4 = L8_4 + 60000
        L7_4.untilT = L8_4
        L5_4[L6_4] = L7_4
        L5_4 = TriggerClientEvent
        L6_4 = "apex_phone:client:wipeAsk"
        L7_4 = A0_2
        L8_4 = {}
        L8_4.code = L4_4
        L8_4.tables = L3_4
        L8_4.rows = L2_4
        L9_4 = L0_4.all
        L9_4 = true == L9_4
        L8_4.all = L9_4
        L9_4 = L0_4.nobackup
        L9_4 = not L9_4
        L8_4.backup = L9_4
        L5_4(L6_4, L7_4, L8_4)
        return
      end
      L1_4 = L5_1
      L1_4 = L1_4()
      L2_4 = 0
      L3_4 = 0
      L4_4 = ipairs
      L5_4 = L1_4
      L4_4, L5_4, L6_4, L7_4 = L4_4(L5_4)
      for L8_4, L9_4 in L4_4, L5_4, L6_4, L7_4 do
        L11_4 = L9_4.name
        L10_4 = L1_1
        L10_4 = L10_4[L11_4]
        if not L10_4 then
          L10_4 = L9_4.rows
          L2_4 = L2_4 + L10_4
          L3_4 = L3_4 + 1
        end
      end
      L4_4 = tostring
      L5_4 = math
      L5_4 = L5_4.random
      L6_4 = 1000
      L7_4 = 9999
      L5_4, L6_4, L7_4, L8_4, L9_4, L10_4, L11_4 = L5_4(L6_4, L7_4)
      L4_4 = L4_4(L5_4, L6_4, L7_4, L8_4, L9_4, L10_4, L11_4)
      L6_4 = A0_2
      L5_4 = L2_1
      L7_4 = {}
      L7_4.code = L4_4
      L8_4 = GetGameTimer
      L8_4 = L8_4()
      L8_4 = L8_4 + 60000
      L7_4.untilT = L8_4
      L5_4[L6_4] = L7_4
      L5_4 = L3_1
      L6_4 = A0_2
      L7_4 = "ATEN\195\135\195\131O: isto apaga TODA a base de dados do telem\195\179vel: %d tabelas, cerca de %d linhas (contas, n\195\186meros, mensagens, fotos, redes sociais, faturas, apps de trabalho...)."
      L8_4 = L7_4
      L7_4 = L7_4.format
      L9_4 = L3_4
      L10_4 = L2_4
      L7_4 = L7_4(L8_4, L9_4, L10_4)
      L8_4 = "error"
      L5_4(L6_4, L7_4, L8_4)
      L5_4 = L3_1
      L6_4 = A0_2
      L7_4 = "Para confirmar (60 s): /%s confirm %s   \194\183   + all = apaga tamb\195\169m o painel admin   \194\183   + nobackup = sem c\195\179pia"
      L8_4 = L7_4
      L7_4 = L7_4.format
      L9_4 = L0_1
      L10_4 = L4_4
      L7_4, L8_4, L9_4, L10_4, L11_4 = L7_4(L8_4, L9_4, L10_4)
      L5_4(L6_4, L7_4, L8_4, L9_4, L10_4, L11_4)
    end
    L0_3, L1_3 = L0_3(L1_3)
    if not L0_3 then
      L2_3 = L3_1
      L3_3 = A0_2
      L4_3 = "Erro: %s"
      L5_3 = L4_3
      L4_3 = L4_3.format
      L6_3 = tostring
      L7_3 = L1_3
      L6_3, L7_3 = L6_3(L7_3)
      L4_3 = L4_3(L5_3, L6_3, L7_3)
      L5_3 = "error"
      L2_3(L3_3, L4_3, L5_3)
    end
  end
  L3_2(L4_2)
end
L14_1 = false
L11_1(L12_1, L13_1, L14_1)
L11_1 = RegisterNetEvent
L12_1 = "apex_phone:server:wipeConfirm"
function L13_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = source
  L4_2 = IsPhoneAdmin
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    return
  end
  L4_2 = L2_1
  L4_2 = L4_2[L3_2]
  if L4_2 then
    L5_2 = GetGameTimer
    L5_2 = L5_2()
    L6_2 = L4_2.untilT
    if not (L5_2 > L6_2) then
      L5_2 = tostring
      L6_2 = A0_2
      L5_2 = L5_2(L6_2)
      L6_2 = L4_2.code
      if L5_2 == L6_2 then
        goto lbl_29
      end
    end
  end
  L5_2 = L3_1
  L6_2 = L3_2
  L7_2 = "Pedido expirado. Escreve /phonewipe outra vez."
  L8_2 = "error"
  L5_2(L6_2, L7_2, L8_2)
  do return end
  ::lbl_29::
  L5_2 = L2_1
  L5_2[L3_2] = nil
  L5_2 = CreateThread
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L0_3 = pcall
    L1_3 = L8_1
    L2_3 = L3_2
    L3_3 = A1_2
    L3_3 = true == L3_3
    L4_3 = A2_2
    L4_3 = false ~= L4_3
    L0_3, L1_3 = L0_3(L1_3, L2_3, L3_3, L4_3)
    if not L0_3 then
      L2_3 = L3_1
      L3_3 = L3_2
      L4_3 = "Erro: %s"
      L5_3 = L4_3
      L4_3 = L4_3.format
      L6_3 = tostring
      L7_3 = L1_3
      L6_3, L7_3 = L6_3(L7_3)
      L4_3 = L4_3(L5_3, L6_3, L7_3)
      L5_3 = "error"
      L2_3(L3_3, L4_3, L5_3)
    end
  end
  L5_2(L6_2)
end
L11_1(L12_1, L13_1)
L11_1 = AddEventHandler
L12_1 = "playerDropped"
function L13_1()
  local L0_2, L1_2
  L1_2 = source
  L0_2 = L2_1
  L0_2[L1_2] = nil
end
L11_1(L12_1, L13_1)
