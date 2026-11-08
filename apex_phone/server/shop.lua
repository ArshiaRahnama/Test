local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1, L16_1, L17_1, L18_1, L19_1, L20_1, L21_1, L22_1, L23_1, L24_1, L25_1, L26_1, L27_1, L28_1, L29_1, L30_1, L31_1, L32_1, L33_1, L34_1, L35_1, L36_1, L37_1, L38_1, L39_1, L40_1, L41_1, L42_1, L43_1, L44_1, L45_1, L46_1, L47_1, L48_1, L49_1, L50_1, L51_1, L52_1, L53_1, L54_1, L55_1, L56_1, L57_1, L58_1, L59_1, L60_1, L61_1, L62_1, L63_1, L64_1
L0_1 = GetCurrentResourceName
L0_1 = L0_1()
L1_1 = nil
L2_1 = {}
L3_1 = {}
L2_1.byItem = L3_1
L3_1 = {}
L2_1.items = L3_1
L3_1 = {}
L2_1.off = L3_1
L3_1 = {}
L4_1 = 0
L5_1 = {}
L6_1 = {}
L7_1 = {}
L8_1 = 30
L9_1 = 40
L10_1 = 8
L11_1 = 12
L12_1 = 100000000
L13_1 = {}
L13_1.busy = "Espera um momento, a compra anterior ainda est\195\161 a ser processada."
L13_1.cooldown = "Calma: espera um segundo antes de voltares a comprar."
L13_1.ratelimit = "Fizeste demasiadas compras seguidas. Tenta daqui a pouco."
L13_1.unknown_item = "Este produto n\195\163o existe nesta loja."
L13_1.off_sale = "Este produto n\195\163o est\195\161 \195\160 venda de momento."
L13_1.unavailable = "Este produto ainda n\195\163o est\195\161 dispon\195\173vel."
L13_1.bad_account = "Este m\195\169todo de pagamento n\195\163o \195\169 aceite aqui."
L13_1.too_far = "Est\195\161s demasiado longe do vendedor."
L13_1.no_player = "O teu personagem ainda n\195\163o carregou."
L13_1.no_framework = "A loja n\195\163o est\195\161 ligada a nenhum framework."
L13_1.no_money_bank = "Saldo insuficiente no banco."
L13_1.no_money_cash = "N\195\163o tens dinheiro suficiente contigo."
L13_1.no_space = "N\195\163o tens espa\195\167o no invent\195\161rio para isto."
L13_1.payment_failed = "O pagamento falhou. N\195\163o te foi cobrado nada."
L13_1.give_refunded = "N\195\163o foi poss\195\173vel entregar o produto. O dinheiro foi devolvido."
L13_1.give_lost = "N\195\163o foi poss\195\173vel entregar o produto nem devolver o dinheiro. Fala com um administrador."
L13_1.disabled = "A loja est\195\161 fechada de momento."
L13_1.server = "Ocorreu um erro no servidor. Tenta outra vez."
L13_1.ok = "Compraste %s por %s."
function L14_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = Config
  L1_2 = L1_2.Debug
  if not L1_2 then
    return
  end
  L1_2 = pcall
  L2_2 = string
  L2_2 = L2_2.format
  L3_2 = A0_2
  L4_2, L5_2, L6_2, L7_2 = ...
  L1_2, L2_2 = L1_2(L2_2, L3_2, L4_2, L5_2, L6_2, L7_2)
  L3_2 = print
  L4_2 = "^5[unique_phone]^0 shop: %s"
  L5_2 = L4_2
  L4_2 = L4_2.format
  L6_2 = L2_2 or L6_2
  if not L1_2 or not L2_2 then
    L6_2 = tostring
    L7_2 = A0_2
    L6_2 = L6_2(L7_2)
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2)
  L3_2(L4_2, L5_2, L6_2, L7_2)
end
function L15_1(A0_2)
  local L1_2, L2_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = "vector4" == L1_2 or "vector3" == L1_2 or "vector2" == L1_2
  return L2_2
end
function L16_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = L15_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L1_2 = {}
    L2_2 = A0_2.x
    L2_2 = L2_2 + 0.0
    L1_2.x = L2_2
    L2_2 = A0_2.y
    L2_2 = L2_2 + 0.0
    L1_2.y = L2_2
    L2_2 = A0_2.z
    if not L2_2 then
      L2_2 = 0.0
    end
    L2_2 = L2_2 + 0.0
    L1_2.z = L2_2
    L2_2 = type
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if "vector4" == L2_2 then
      L2_2 = A0_2.w
      if L2_2 then
        goto lbl_32
      end
    end
    L2_2 = 0.0
    ::lbl_32::
    L2_2 = L2_2 + 0.0
    L1_2.w = L2_2
    return L1_2
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    return A0_2
  end
  L1_2 = {}
  L2_2 = pairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L16_1
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    L1_2[L6_2] = L8_2
  end
  return L1_2
end
L17_1 = "\226\128\175"
L18_1 = "\194\160"
function L19_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L1_2 = tonumber
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2 or A0_2
  if not L1_2 then
    A0_2 = 0
  end
  L1_2 = A0_2 < 0
  L2_2 = math
  L2_2 = L2_2.abs
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  A0_2 = L2_2
  L2_2 = math
  L2_2 = L2_2.floor
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  L3_2 = tostring
  L4_2 = L2_2
  L3_2 = L3_2(L4_2)
  L4_2 = {}
  L5_2 = #L3_2
  L5_2 = L5_2 % 3
  if L5_2 > 0 then
    L6_2 = #L4_2
    L6_2 = L6_2 + 1
    L8_2 = L3_2
    L7_2 = L3_2.sub
    L9_2 = 1
    L10_2 = L5_2
    L7_2 = L7_2(L8_2, L9_2, L10_2)
    L4_2[L6_2] = L7_2
  end
  L6_2 = L5_2 + 1
  L7_2 = #L3_2
  L8_2 = 3
  for L9_2 = L6_2, L7_2, L8_2 do
    L10_2 = #L4_2
    L10_2 = L10_2 + 1
    L12_2 = L3_2
    L11_2 = L3_2.sub
    L13_2 = L9_2
    L14_2 = L9_2 + 2
    L11_2 = L11_2(L12_2, L13_2, L14_2)
    L4_2[L10_2] = L11_2
  end
  L6_2 = table
  L6_2 = L6_2.concat
  L7_2 = L4_2
  L8_2 = L17_1
  L6_2 = L6_2(L7_2, L8_2)
  L7_2 = math
  L7_2 = L7_2.floor
  L8_2 = A0_2 - L2_2
  L8_2 = L8_2 * 100
  L8_2 = L8_2 + 0.5
  L7_2 = L7_2(L8_2)
  if L7_2 > 0 then
    L8_2 = L6_2
    L9_2 = ",%02d"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L11_2 = L7_2
    L9_2 = L9_2(L10_2, L11_2)
    L8_2 = L8_2 .. L9_2
    L6_2 = L8_2
  end
  L8_2 = L1_1
  if L8_2 then
    L8_2 = L1_1.currency
    if L8_2 then
      goto lbl_84
    end
  end
  L8_2 = {}
  ::lbl_84::
  L9_2 = FormatMoney
  if L9_2 then
    L9_2 = FormatMoney
    if L1_2 then
      L10_2 = -1
      if L10_2 then
        goto lbl_94
      end
    end
    L10_2 = 1
    ::lbl_94::
    L11_2 = L7_2 / 100
    L11_2 = L2_2 + L11_2
    L10_2 = L10_2 * L11_2
    L11_2 = L8_2.symbol
    L12_2 = L8_2.position
    return L9_2(L10_2, L11_2, L12_2)
  end
  L9_2 = L8_2.symbol
  if not L9_2 then
    L9_2 = Config
    L9_2 = L9_2.Currency
    if L9_2 then
      L9_2 = Config
      L9_2 = L9_2.Currency
      L9_2 = L9_2.symbol
      if L9_2 then
        goto lbl_117
      end
    end
    L9_2 = "$"
  end
  ::lbl_117::
  L10_2 = L8_2.position
  if "before" == L10_2 then
    L10_2 = L9_2
    L11_2 = L6_2
    L10_2 = L10_2 .. L11_2
    if L10_2 then
      goto lbl_130
      L6_2 = L10_2 or L6_2
    end
  end
  L10_2 = L6_2
  L11_2 = L18_1
  L12_2 = L9_2
  L10_2 = L10_2 .. L11_2 .. L12_2
  L6_2 = L10_2
  ::lbl_130::
  if L1_2 then
    L10_2 = "-"
    L11_2 = L6_2
    L10_2 = L10_2 .. L11_2
    if L10_2 then
      goto lbl_138
    end
  end
  L10_2 = L6_2
  ::lbl_138::
  return L10_2
end
function L20_1(A0_2)
  local L1_2, L2_2, L3_2
  if nil == A0_2 or "" == A0_2 then
    L1_2 = "grid"
    return L1_2
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = #A0_2
    if not (L1_2 > 32) then
      L2_2 = A0_2
      L1_2 = A0_2.match
      L3_2 = "^[%w_%-]+$"
      L1_2 = L1_2(L2_2, L3_2)
      if L1_2 then
        goto lbl_22
      end
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_22::
  return A0_2
end
L21_1 = {}
L21_1.phone = true
L21_1.fold = true
L21_1.buds = true
L21_1.card = true
function L22_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = nil
  L2_2 = "Valor inv\195\161lido em %s."
  L3_2 = L2_2
  L2_2 = L2_2.format
  L4_2 = A0_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  return L1_2, L2_2, L3_2, L4_2
end
function L23_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2
  if nil == A0_2 then
    A0_2 = ""
  end
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "number" == L3_2 then
    L3_2 = tostring
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    A0_2 = L3_2
  end
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "string" ~= L3_2 then
    L3_2 = nil
    return L3_2
  end
  L4_2 = A0_2
  L3_2 = A0_2.gsub
  L5_2 = "%c"
  L6_2 = " "
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L3_2
  L3_2 = L3_2.gsub
  L5_2 = "^%s+"
  L6_2 = ""
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L3_2
  L3_2 = L3_2.gsub
  L5_2 = "%s+$"
  L6_2 = ""
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  A0_2 = L3_2
  L3_2 = utf8
  L3_2 = L3_2.len
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if L3_2 and not (A1_2 < L3_2) then
    L4_2 = A2_2 or L4_2
    if not A2_2 then
      L4_2 = 0
    end
    if not (L3_2 < L4_2) then
      goto lbl_48
    end
  end
  L4_2 = nil
  do return L4_2 end
  ::lbl_48::
  return A0_2
end
function L24_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  A0_2 = L3_2
  if not A0_2 or A0_2 ~= A0_2 or A1_2 > A0_2 or A2_2 < A0_2 then
    L3_2 = nil
    return L3_2
  end
  L3_2 = A0_2 + 0.0
  return L3_2
end
function L25_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2
  L3_2 = tonumber
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  A0_2 = L3_2
  if A0_2 and A0_2 == A0_2 then
    L3_2 = math
    L3_2 = L3_2.floor
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    if not (A0_2 ~= L3_2 or A1_2 > A0_2 or A2_2 < A0_2) then
      goto lbl_21
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_21::
  L3_2 = math
  L3_2 = L3_2.floor
  L4_2 = A0_2
  return L3_2(L4_2)
end
function L26_1(A0_2)
  local L1_2
  if true == A0_2 or false == A0_2 then
    return A0_2
  end
  L1_2 = nil
  return L1_2
end
function L27_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L2_2 = #A0_2
    if not (L2_2 < 1) then
      L2_2 = #A0_2
      L3_2 = A1_2 or L3_2
      if not A1_2 then
        L3_2 = 32
      end
      if not (L2_2 > L3_2) then
        L3_2 = A0_2
        L2_2 = A0_2.match
        L4_2 = "^[%w_%-]+$"
        L2_2 = L2_2(L3_2, L4_2)
        if L2_2 then
          goto lbl_22
        end
      end
    end
  end
  L2_2 = nil
  do return L2_2 end
  ::lbl_22::
  return A0_2
end
function L28_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = #A0_2
    if not (L1_2 < 1) then
      L1_2 = #A0_2
      if not (L1_2 > 64) then
        L2_2 = A0_2
        L1_2 = A0_2.match
        L3_2 = "^[%w_%-]+$"
        L1_2 = L1_2(L2_2, L3_2)
        if L1_2 then
          goto lbl_19
        end
      end
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_19::
  return A0_2
end
function L29_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = #A0_2
    if not (L1_2 < 1) then
      L1_2 = #A0_2
      if not (L1_2 > 48) then
        L2_2 = A0_2
        L1_2 = A0_2.match
        L3_2 = "^[%w_]+$"
        L1_2 = L1_2(L2_2, L3_2)
        if L1_2 then
          goto lbl_19
        end
      end
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_19::
  return A0_2
end
function L30_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L2_2 = A0_2
    L1_2 = A0_2.match
    L3_2 = "^#%x%x%x%x%x%x$"
    L1_2 = L1_2(L2_2, L3_2)
    if L1_2 then
      goto lbl_13
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_13::
  L2_2 = A0_2
  L1_2 = A0_2.upper
  return L1_2(L2_2)
end
function L31_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = false
    return L1_2
  end
  L1_2 = 0
  L2_2 = pairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L7_2 = type
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if "number" ~= L7_2 then
      L7_2 = false
      return L7_2
    end
    L1_2 = L1_2 + 1
  end
  L2_2 = #A0_2
  L2_2 = L1_2 == L2_2
  return L2_2
end
function L32_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L3_2 = type
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if "table" == L3_2 then
    L3_2 = next
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    if nil == L3_2 then
      goto lbl_20
    end
    L3_2 = L31_1
    L4_2 = A0_2
    L3_2 = L3_2(L4_2)
    if not L3_2 then
      goto lbl_20
    end
  end
  L3_2 = L22_1
  L4_2 = A2_2
  do return L3_2(L4_2) end
  ::lbl_20::
  L3_2 = {}
  L4_2 = pairs
  L5_2 = A1_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = A0_2[L8_2]
    if nil ~= L10_2 then
      L10_2 = L9_2
      L11_2 = A0_2[L8_2]
      L10_2 = L10_2(L11_2)
      if nil == L10_2 then
        L11_2 = L22_1
        L12_2 = A2_2
        L13_2 = "."
        L14_2 = L8_2
        L12_2 = L12_2 .. L13_2 .. L14_2
        L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
        return L11_2, L12_2, L13_2, L14_2
      end
      L3_2[L8_2] = L10_2
    end
  end
  return L3_2
end
L33_1 = {}
function L34_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L23_1
  L2_2 = A0_2
  L3_2 = 4
  L4_2 = 1
  return L1_2(L2_2, L3_2, L4_2)
end
L33_1.symbol = L34_1
function L34_1(A0_2)
  local L1_2
  L1_2 = A0_2 or L1_2
  if "before" ~= A0_2 and "after" ~= A0_2 or not A0_2 then
    L1_2 = nil
  end
  return L1_2
end
L33_1.position = L34_1
L34_1 = {}
L34_1.enabled = L26_1
function L35_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L25_1
  L2_2 = A0_2
  L3_2 = 1
  L4_2 = 1000
  return L1_2(L2_2, L3_2, L4_2)
end
L34_1.sprite = L35_1
function L35_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L25_1
  L2_2 = A0_2
  L3_2 = 1
  L4_2 = 1000
  return L1_2(L2_2, L3_2, L4_2)
end
L34_1.spriteModern = L35_1
function L35_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L25_1
  L2_2 = A0_2
  L3_2 = 0
  L4_2 = 99999
  return L1_2(L2_2, L3_2, L4_2)
end
L34_1.modernBuild = L35_1
function L35_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L25_1
  L2_2 = A0_2
  L3_2 = 0
  L4_2 = 85
  return L1_2(L2_2, L3_2, L4_2)
end
L34_1.color = L35_1
function L35_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L24_1
  L2_2 = A0_2
  L3_2 = 0.2
  L4_2 = 3.0
  return L1_2(L2_2, L3_2, L4_2)
end
L34_1.scale = L35_1
function L35_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L23_1
  L2_2 = A0_2
  L3_2 = 40
  L4_2 = 0
  return L1_2(L2_2, L3_2, L4_2)
end
L34_1.label = L35_1
L35_1 = {}
function L36_1(A0_2)
  local L1_2
  L1_2 = A0_2 or L1_2
  if "auto" ~= A0_2 and "target" ~= A0_2 and "key" ~= A0_2 or not A0_2 then
    L1_2 = nil
  end
  return L1_2
end
L35_1.mode = L36_1
function L36_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L24_1
  L2_2 = A0_2
  L3_2 = 0.5
  L4_2 = 10.0
  return L1_2(L2_2, L3_2, L4_2)
end
L35_1.distance = L36_1
function L36_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L25_1
  L2_2 = A0_2
  L3_2 = 0
  L4_2 = 400
  return L1_2(L2_2, L3_2, L4_2)
end
L35_1.key = L36_1
function L36_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L23_1
  L2_2 = A0_2
  L3_2 = 8
  L4_2 = 1
  return L1_2(L2_2, L3_2, L4_2)
end
L35_1.keyLabel = L36_1
function L36_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = #A0_2
    if L1_2 <= 64 then
      L2_2 = A0_2
      L1_2 = A0_2.match
      L3_2 = "^fa[%w%- ]+$"
      L1_2 = L1_2(L2_2, L3_2)
      if L1_2 and A0_2 then
        goto lbl_17
        L1_2 = A0_2 or L1_2
      end
    end
  end
  L1_2 = nil
  ::lbl_17::
  return L1_2
end
L35_1.icon = L36_1
function L36_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L23_1
  L2_2 = A0_2
  L3_2 = 40
  L4_2 = 0
  return L1_2(L2_2, L3_2, L4_2)
end
L35_1.label = L36_1
L36_1 = {}
L36_1.enabled = L26_1
function L37_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L24_1
  L2_2 = A0_2
  L3_2 = 0.3
  L4_2 = 10.0
  return L1_2(L2_2, L3_2, L4_2)
end
L36_1.distance = L37_1
function L37_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L24_1
  L2_2 = A0_2
  L3_2 = -2.0
  L4_2 = 4.0
  return L1_2(L2_2, L3_2, L4_2)
end
L36_1.height = L37_1
function L37_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L24_1
  L2_2 = A0_2
  L3_2 = -3.0
  L4_2 = 3.0
  return L1_2(L2_2, L3_2, L4_2)
end
L36_1.shift = L37_1
function L37_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L24_1
  L2_2 = A0_2
  L3_2 = 10.0
  L4_2 = 120.0
  return L1_2(L2_2, L3_2, L4_2)
end
L36_1.fov = L37_1
function L37_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L25_1
  L2_2 = A0_2
  L3_2 = 0
  L4_2 = 5000
  return L1_2(L2_2, L3_2, L4_2)
end
L36_1.ease = L37_1
function L37_1(A0_2)
  local L1_2, L2_2, L3_2
  if "" == A0_2 then
    L1_2 = ""
    return L1_2
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = #A0_2
    if not (L1_2 > 64) then
      L2_2 = A0_2
      L1_2 = A0_2.match
      L3_2 = "^[%w_]+$"
      L1_2 = L1_2(L2_2, L3_2)
      if L1_2 then
        goto lbl_20
      end
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_20::
  return A0_2
end
L38_1 = {}
L38_1.model = L29_1
L38_1.scenario = L37_1
function L39_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L24_1
  L2_2 = A0_2
  L3_2 = 10.0
  L4_2 = 500.0
  return L1_2(L2_2, L3_2, L4_2)
end
L38_1.spawnDistance = L39_1
L38_1.snapToPavement = L26_1
function L39_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L24_1
  L2_2 = A0_2
  L3_2 = 0.0
  L4_2 = 50.0
  return L1_2(L2_2, L3_2, L4_2)
end
L38_1.snapMax = L39_1
function L39_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = L22_1
    L2_2 = "payment"
    return L1_2(L2_2)
  end
  L1_2 = {}
  L2_2 = A0_2.accounts
  if nil ~= L2_2 then
    L2_2 = L31_1
    L3_2 = A0_2.accounts
    L2_2 = L2_2(L3_2)
    if L2_2 then
      L2_2 = A0_2.accounts
      L2_2 = #L2_2
      if not (L2_2 < 1) then
        L2_2 = A0_2.accounts
        L2_2 = #L2_2
        if not (L2_2 > 2) then
          goto lbl_32
        end
      end
    end
    L2_2 = L22_1
    L3_2 = "payment.accounts"
    do return L2_2(L3_2) end
    ::lbl_32::
    L2_2 = {}
    L3_2 = {}
    L4_2 = ipairs
    L5_2 = A0_2.accounts
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      if "bank" == L9_2 or "cash" == L9_2 then
        L10_2 = L2_2[L9_2]
        if not L10_2 then
          goto lbl_51
        end
      end
      L10_2 = L22_1
      L11_2 = "payment.accounts"
      L10_2, L11_2 = L10_2(L11_2)
      do return L10_2, L11_2 end
      ::lbl_51::
      L2_2[L9_2] = true
      L10_2 = #L3_2
      L10_2 = L10_2 + 1
      L3_2[L10_2] = L9_2
    end
    L1_2.accounts = L3_2
  end
  L2_2 = A0_2.default
  if nil ~= L2_2 then
    L2_2 = A0_2.default
    if "bank" ~= L2_2 then
      L2_2 = A0_2.default
      if "cash" ~= L2_2 then
        L2_2 = L22_1
        L3_2 = "payment.default"
        return L2_2(L3_2)
      end
    end
    L2_2 = A0_2.default
    L1_2.default = L2_2
  end
  L2_2 = L1_2.accounts
  if not L2_2 then
    L2_2 = L1_1
    if L2_2 then
      L2_2 = L1_1.payment
      if L2_2 then
        L2_2 = L1_1.payment
        L2_2 = L2_2.accounts
        if L2_2 then
          goto lbl_93
        end
      end
    end
    L2_2 = {}
    L3_2 = "bank"
    L4_2 = "cash"
    L2_2[1] = L3_2
    L2_2[2] = L4_2
  end
  ::lbl_93::
  L3_2 = L1_2.default
  if L3_2 then
    L3_2 = false
    L4_2 = ipairs
    L5_2 = L2_2
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = L1_2.default
      if L9_2 == L10_2 then
        L3_2 = true
      end
    end
    if not L3_2 then
      L4_2 = nil
      L5_2 = "A conta por omiss\195\163o tem de estar nas contas aceites."
      return L4_2, L5_2
    end
  end
  return L1_2
end
function L40_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = L15_1
    L3_2 = A0_2
    L2_2 = L2_2(L3_2)
    if not L2_2 then
      L2_2 = L22_1
      L3_2 = A1_2
      return L2_2(L3_2)
    end
  end
  L2_2 = L24_1
  L3_2 = A0_2.x
  L4_2 = -20000
  L5_2 = 20000
  L2_2 = L2_2(L3_2, L4_2, L5_2)
  L3_2 = L24_1
  L4_2 = A0_2.y
  L5_2 = -20000
  L6_2 = 20000
  L3_2 = L3_2(L4_2, L5_2, L6_2)
  L4_2 = L24_1
  L5_2 = A0_2.z
  L6_2 = -1000
  L7_2 = 3000
  L4_2 = L4_2(L5_2, L6_2, L7_2)
  L5_2 = L24_1
  L6_2 = A0_2.w
  if nil == L6_2 then
    L6_2 = 0.0
    if L6_2 then
      goto lbl_38
    end
  end
  L6_2 = A0_2.w
  ::lbl_38::
  L7_2 = -360
  L8_2 = 360
  L5_2 = L5_2(L6_2, L7_2, L8_2)
  if not (L2_2 and L3_2 and L4_2) or not L5_2 then
    L6_2 = L22_1
    L7_2 = A1_2
    return L6_2(L7_2)
  end
  L6_2 = {}
  L6_2.x = L2_2
  L6_2.y = L3_2
  L6_2.z = L4_2
  L6_2.w = L5_2
  return L6_2
end
function L41_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L1_2 = L31_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = L22_1
    L2_2 = "shops"
    return L1_2(L2_2)
  end
  L1_2 = #A0_2
  L2_2 = L8_1
  if L1_2 > L2_2 then
    L1_2 = nil
    L2_2 = "H\195\161 lojas a mais (m\195\161ximo %d)."
    L3_2 = L2_2
    L2_2 = L2_2.format
    L4_2 = L8_1
    L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L2_2(L3_2, L4_2)
    return L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  end
  L1_2 = {}
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = "shops["
    L10_2 = L7_2
    L11_2 = "]"
    L9_2 = L9_2 .. L10_2 .. L11_2
    L10_2 = type
    L11_2 = L8_2
    L10_2 = L10_2(L11_2)
    if "table" ~= L10_2 then
      L10_2 = L22_1
      L11_2 = L9_2
      L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L10_2(L11_2)
      return L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
    end
    L10_2 = L27_1
    L11_2 = L8_2.id
    L12_2 = 32
    L10_2 = L10_2(L11_2, L12_2)
    if not L10_2 then
      L11_2 = L22_1
      L12_2 = L9_2
      L13_2 = ".id"
      L12_2 = L12_2 .. L13_2
      L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L11_2(L12_2)
      return L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
    end
    L11_2 = L2_2[L10_2]
    if L11_2 then
      L11_2 = nil
      L12_2 = "ID repetido: %s."
      L13_2 = L12_2
      L12_2 = L12_2.format
      L14_2 = L10_2
      L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L12_2(L13_2, L14_2)
      return L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
    end
    L2_2[L10_2] = true
    L11_2 = L23_1
    L12_2 = L8_2.label
    L13_2 = 64
    L14_2 = 1
    L11_2 = L11_2(L12_2, L13_2, L14_2)
    if not L11_2 then
      L12_2 = L22_1
      L13_2 = L9_2
      L14_2 = ".label"
      L13_2 = L13_2 .. L14_2
      L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L12_2(L13_2)
      return L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
    end
    L12_2 = L40_1
    L13_2 = L8_2.coords
    L14_2 = L9_2
    L15_2 = ".coords"
    L14_2 = L14_2 .. L15_2
    L12_2, L13_2 = L12_2(L13_2, L14_2)
    if not L12_2 then
      L14_2 = nil
      L15_2 = L13_2
      return L14_2, L15_2
    end
    L14_2 = type
    L15_2 = L8_2.vendor
    L14_2 = L14_2(L15_2)
    if "table" == L14_2 then
      L14_2 = L8_2.vendor
      if L14_2 then
        goto lbl_97
      end
    end
    L14_2 = {}
    ::lbl_97::
    L15_2 = {}
    L16_2 = L23_1
    L17_2 = L14_2.name
    L18_2 = 32
    L19_2 = 1
    L16_2 = L16_2(L17_2, L18_2, L19_2)
    L15_2.name = L16_2
    L16_2 = L23_1
    L17_2 = L14_2.role
    L18_2 = 32
    L19_2 = 0
    L16_2 = L16_2(L17_2, L18_2, L19_2)
    L15_2.role = L16_2
    L16_2 = L23_1
    L17_2 = L14_2.greeting
    L18_2 = 240
    L19_2 = 0
    L16_2 = L16_2(L17_2, L18_2, L19_2)
    L15_2.greeting = L16_2
    L16_2 = L15_2.name
    if not L16_2 then
      L16_2 = L22_1
      L17_2 = L9_2
      L18_2 = ".vendor.name"
      L17_2 = L17_2 .. L18_2
      L16_2, L17_2, L18_2, L19_2, L20_2 = L16_2(L17_2)
      return L16_2, L17_2, L18_2, L19_2, L20_2
    end
    L16_2 = L15_2.role
    if not L16_2 then
      L16_2 = L22_1
      L17_2 = L9_2
      L18_2 = ".vendor.role"
      L17_2 = L17_2 .. L18_2
      L16_2, L17_2, L18_2, L19_2, L20_2 = L16_2(L17_2)
      return L16_2, L17_2, L18_2, L19_2, L20_2
    end
    L16_2 = L15_2.greeting
    if not L16_2 then
      L16_2 = L22_1
      L17_2 = L9_2
      L18_2 = ".vendor.greeting"
      L17_2 = L17_2 .. L18_2
      L16_2, L17_2, L18_2, L19_2, L20_2 = L16_2(L17_2)
      return L16_2, L17_2, L18_2, L19_2, L20_2
    end
    L16_2 = {}
    L16_2.id = L10_2
    L16_2.label = L11_2
    L16_2.coords = L12_2
    L16_2.vendor = L15_2
    L17_2 = L8_2.ped
    if nil ~= L17_2 then
      L17_2 = type
      L18_2 = L8_2.ped
      L17_2 = L17_2(L18_2)
      if "table" ~= L17_2 then
        L17_2 = L22_1
        L18_2 = L9_2
        L19_2 = ".ped"
        L18_2 = L18_2 .. L19_2
        L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
        return L17_2, L18_2, L19_2, L20_2
      end
      L17_2 = {}
      L18_2 = L8_2.ped
      L18_2 = L18_2.model
      if nil ~= L18_2 then
        L18_2 = L8_2.ped
        L18_2 = L18_2.model
        if "" ~= L18_2 then
          L18_2 = L29_1
          L19_2 = L8_2.ped
          L19_2 = L19_2.model
          L18_2 = L18_2(L19_2)
          L17_2.model = L18_2
          L18_2 = L17_2.model
          if not L18_2 then
            L18_2 = L22_1
            L19_2 = L9_2
            L20_2 = ".ped.model"
            L19_2 = L19_2 .. L20_2
            L18_2, L19_2, L20_2 = L18_2(L19_2)
            return L18_2, L19_2, L20_2
          end
        end
      end
      L18_2 = L8_2.ped
      L18_2 = L18_2.scenario
      if nil ~= L18_2 then
        L18_2 = L37_1
        L19_2 = L8_2.ped
        L19_2 = L19_2.scenario
        L18_2 = L18_2(L19_2)
        L17_2.scenario = L18_2
        L18_2 = L17_2.scenario
        if not L18_2 then
          L18_2 = L22_1
          L19_2 = L9_2
          L20_2 = ".ped.scenario"
          L19_2 = L19_2 .. L20_2
          L18_2, L19_2, L20_2 = L18_2(L19_2)
          return L18_2, L19_2, L20_2
        end
      end
      L18_2 = L8_2.ped
      L18_2 = L18_2.snapToPavement
      if nil ~= L18_2 then
        L18_2 = L8_2.ped
        L18_2 = L18_2.snapToPavement
        L18_2 = true == L18_2
        L17_2.snapToPavement = L18_2
      end
      L18_2 = next
      L19_2 = L17_2
      L18_2 = L18_2(L19_2)
      if L18_2 then
        L16_2.ped = L17_2
      end
    end
    L17_2 = L8_2.blip
    if nil ~= L17_2 then
      L17_2 = L8_2.blip
      if true ~= L17_2 then
        L17_2 = L8_2.blip
        if false ~= L17_2 then
          L17_2 = L22_1
          L18_2 = L9_2
          L19_2 = ".blip"
          L18_2 = L18_2 .. L19_2
          L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
          return L17_2, L18_2, L19_2, L20_2
        end
      end
      L17_2 = L8_2.blip
      L16_2.blip = L17_2
    end
    L17_2 = L8_2.blipLabel
    if nil ~= L17_2 then
      L17_2 = L23_1
      L18_2 = L8_2.blipLabel
      L19_2 = 40
      L20_2 = 0
      L17_2 = L17_2(L18_2, L19_2, L20_2)
      L16_2.blipLabel = L17_2
      L17_2 = L16_2.blipLabel
      if not L17_2 then
        L17_2 = L22_1
        L18_2 = L9_2
        L19_2 = ".blipLabel"
        L18_2 = L18_2 .. L19_2
        L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
        return L17_2, L18_2, L19_2, L20_2
      end
    end
    L17_2 = #L1_2
    L17_2 = L17_2 + 1
    L1_2[L17_2] = L16_2
  end
  return L1_2
end
function L42_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L1_2 = L31_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if L1_2 then
    L1_2 = #A0_2
    if not (L1_2 < 1) then
      goto lbl_13
    end
  end
  L1_2 = L22_1
  L2_2 = "categories"
  do return L1_2(L2_2) end
  ::lbl_13::
  L1_2 = #A0_2
  L2_2 = L11_1
  if L1_2 > L2_2 then
    L1_2 = nil
    L2_2 = "H\195\161 categorias a mais (m\195\161ximo %d)."
    L3_2 = L2_2
    L2_2 = L2_2.format
    L4_2 = L11_1
    L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L2_2(L3_2, L4_2)
    return L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  end
  L1_2 = {}
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = A0_2
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = "categories["
    L10_2 = L7_2
    L11_2 = "]"
    L9_2 = L9_2 .. L10_2 .. L11_2
    L10_2 = type
    L11_2 = L8_2
    L10_2 = L10_2(L11_2)
    if "table" ~= L10_2 then
      L10_2 = L22_1
      L11_2 = L9_2
      L10_2, L11_2, L12_2, L13_2, L14_2, L15_2 = L10_2(L11_2)
      return L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
    end
    L10_2 = L27_1
    L11_2 = L8_2.id
    L12_2 = 24
    L10_2 = L10_2(L11_2, L12_2)
    if not L10_2 then
      L11_2 = L22_1
      L12_2 = L9_2
      L13_2 = ".id"
      L12_2 = L12_2 .. L13_2
      L11_2, L12_2, L13_2, L14_2, L15_2 = L11_2(L12_2)
      return L11_2, L12_2, L13_2, L14_2, L15_2
    end
    L11_2 = L2_2[L10_2]
    if L11_2 then
      L11_2 = nil
      L12_2 = "ID repetido: %s."
      L13_2 = L12_2
      L12_2 = L12_2.format
      L14_2 = L10_2
      L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2, L14_2)
      return L11_2, L12_2, L13_2, L14_2, L15_2
    end
    L2_2[L10_2] = true
    L11_2 = L23_1
    L12_2 = L8_2.label
    L13_2 = 32
    L14_2 = 1
    L11_2 = L11_2(L12_2, L13_2, L14_2)
    if not L11_2 then
      L12_2 = L22_1
      L13_2 = L9_2
      L14_2 = ".label"
      L13_2 = L13_2 .. L14_2
      L12_2, L13_2, L14_2, L15_2 = L12_2(L13_2)
      return L12_2, L13_2, L14_2, L15_2
    end
    L12_2 = L20_1
    L13_2 = L8_2.icon
    L12_2 = L12_2(L13_2)
    if not L12_2 then
      L13_2 = L22_1
      L14_2 = L9_2
      L15_2 = ".icon"
      L14_2 = L14_2 .. L15_2
      L13_2, L14_2, L15_2 = L13_2(L14_2)
      return L13_2, L14_2, L15_2
    end
    L13_2 = #L1_2
    L13_2 = L13_2 + 1
    L14_2 = {}
    L14_2.id = L10_2
    L14_2.label = L11_2
    L14_2.icon = L12_2
    L1_2[L13_2] = L14_2
  end
  return L1_2
end
function L43_1(A0_2)
  local L1_2, L2_2, L3_2
  if nil == A0_2 or "" == A0_2 then
    L1_2 = ""
    return L1_2
  end
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = #A0_2
    L2_2 = 300
    if not (L1_2 > L2_2) then
      L2_2 = A0_2
      L1_2 = A0_2.find
      L3_2 = "[%s\"'<>\\]"
      L1_2 = L1_2(L2_2, L3_2)
      if not L1_2 then
        goto lbl_23
      end
    end
  end
  L1_2 = nil
  do return L1_2 end
  ::lbl_23::
  L2_2 = A0_2
  L1_2 = A0_2.match
  L3_2 = "^nui://[%w_%-]+/[%w_%-/%.]+%.[%a]+$"
  L1_2 = L1_2(L2_2, L3_2)
  if not L1_2 then
    L2_2 = A0_2
    L1_2 = A0_2.match
    L3_2 = "^https://[%w%.%-]+/"
    L1_2 = L1_2(L2_2, L3_2)
    if not L1_2 then
      goto lbl_34
    end
  end
  do return A0_2 end
  ::lbl_34::
  L1_2 = nil
  return L1_2
end
function L44_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  if nil == A0_2 then
    L2_2 = {}
    L2_2.kind = "phone"
    return L2_2
  end
  L2_2 = type
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if "table" ~= L2_2 then
    L2_2 = L22_1
    L3_2 = A1_2
    return L2_2(L3_2)
  end
  L2_2 = A0_2.kind
  if nil == L2_2 then
    L2_2 = "phone"
    if L2_2 then
      goto lbl_23
    end
  end
  L2_2 = A0_2.kind
  ::lbl_23::
  L3_2 = L21_1
  L3_2 = L3_2[L2_2]
  if not L3_2 then
    L3_2 = L22_1
    L4_2 = A1_2
    L5_2 = ".kind"
    L4_2 = L4_2 .. L5_2
    return L3_2(L4_2)
  end
  L3_2 = {}
  L3_2.kind = L2_2
  L4_2 = A0_2.yaw
  if nil ~= L4_2 then
    L4_2 = L24_1
    L5_2 = A0_2.yaw
    L6_2 = -7.0
    L7_2 = 7.0
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L3_2.yaw = L4_2
    L4_2 = L3_2.yaw
    if not L4_2 then
      L4_2 = L22_1
      L5_2 = A1_2
      L6_2 = ".yaw"
      L5_2 = L5_2 .. L6_2
      return L4_2(L5_2)
    end
  end
  L4_2 = A0_2.pitch
  if nil ~= L4_2 then
    L4_2 = L24_1
    L5_2 = A0_2.pitch
    L6_2 = -1.5
    L7_2 = 1.5
    L4_2 = L4_2(L5_2, L6_2, L7_2)
    L3_2.pitch = L4_2
    L4_2 = L3_2.pitch
    if not L4_2 then
      L4_2 = L22_1
      L5_2 = A1_2
      L6_2 = ".pitch"
      L5_2 = L5_2 .. L6_2
      return L4_2(L5_2)
    end
  end
  L4_2 = A0_2.hide
  if nil ~= L4_2 then
    L4_2 = L31_1
    L5_2 = A0_2.hide
    L4_2 = L4_2(L5_2)
    if L4_2 then
      L4_2 = A0_2.hide
      L4_2 = #L4_2
      if not (L4_2 > 6) then
        goto lbl_90
      end
    end
    L4_2 = L22_1
    L5_2 = A1_2
    L6_2 = ".hide"
    L5_2 = L5_2 .. L6_2
    do return L4_2(L5_2) end
    ::lbl_90::
    L4_2 = {}
    L3_2.hide = L4_2
    L4_2 = ipairs
    L5_2 = A0_2.hide
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
    for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
      L10_2 = type
      L11_2 = L9_2
      L10_2 = L10_2(L11_2)
      if "string" == L10_2 then
        L10_2 = #L9_2
        if not (L10_2 < 1) then
          L10_2 = #L9_2
          if not (L10_2 > 80) then
            goto lbl_114
          end
        end
      end
      L10_2 = L22_1
      L11_2 = A1_2
      L12_2 = ".hide"
      L11_2 = L11_2 .. L12_2
      L10_2, L11_2, L12_2 = L10_2(L11_2)
      do return L10_2, L11_2, L12_2 end
      ::lbl_114::
      L10_2 = L3_2.hide
      L11_2 = L3_2.hide
      L11_2 = #L11_2
      L11_2 = L11_2 + 1
      L10_2[L11_2] = L9_2
    end
  end
  L4_2 = A0_2.mark
  if nil ~= L4_2 then
    L4_2 = type
    L5_2 = A0_2.mark
    L4_2 = L4_2(L5_2)
    if "table" == L4_2 then
      L4_2 = A0_2.mark
      L4_2 = L4_2.kind
      if "pear" == L4_2 then
        goto lbl_145
      end
      L4_2 = A0_2.mark
      L4_2 = L4_2.kind
      if "text" == L4_2 then
        goto lbl_145
      end
    end
    L4_2 = L22_1
    L5_2 = A1_2
    L6_2 = ".mark"
    L5_2 = L5_2 .. L6_2
    do return L4_2(L5_2) end
    ::lbl_145::
    L4_2 = {}
    L5_2 = A0_2.mark
    L5_2 = L5_2.kind
    L4_2.kind = L5_2
    L3_2.mark = L4_2
    L4_2 = A0_2.mark
    L4_2 = L4_2.text
    if nil ~= L4_2 then
      L4_2 = L3_2.mark
      L5_2 = L23_1
      L6_2 = A0_2.mark
      L6_2 = L6_2.text
      L7_2 = 16
      L8_2 = 1
      L5_2 = L5_2(L6_2, L7_2, L8_2)
      L4_2.text = L5_2
      L4_2 = L3_2.mark
      L4_2 = L4_2.text
      if not L4_2 then
        L4_2 = L22_1
        L5_2 = A1_2
        L6_2 = ".mark.text"
        L5_2 = L5_2 .. L6_2
        return L4_2(L5_2)
      end
    end
  end
  L4_2 = A0_2.revision
  if nil ~= L4_2 then
    L4_2 = type
    L5_2 = A0_2.revision
    L4_2 = L4_2(L5_2)
    if "string" == L4_2 then
      L4_2 = A0_2.revision
      L4_2 = #L4_2
      if not (L4_2 > 64) then
        L4_2 = A0_2.revision
        L5_2 = L4_2
        L4_2 = L4_2.match
        L6_2 = "^[%w_%-%.]+$"
        L4_2 = L4_2(L5_2, L6_2)
        if L4_2 then
          goto lbl_197
        end
      end
    end
    L4_2 = L22_1
    L5_2 = A1_2
    L6_2 = ".revision"
    L5_2 = L5_2 .. L6_2
    do return L4_2(L5_2) end
    ::lbl_197::
    L4_2 = A0_2.revision
    L3_2.revision = L4_2
  end
  return L3_2
end
function L45_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2
  L2_2 = L31_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if not L2_2 then
    L2_2 = L22_1
    L3_2 = "products"
    return L2_2(L3_2)
  end
  L2_2 = #A0_2
  L3_2 = L9_1
  if L2_2 > L3_2 then
    L2_2 = nil
    L3_2 = "H\195\161 produtos a mais (m\195\161ximo %d)."
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = L9_1
    L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L3_2(L4_2, L5_2)
    return L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2
  end
  L2_2 = {}
  L3_2 = {}
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = A0_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = "products["
    L12_2 = L9_2
    L13_2 = "]"
    L11_2 = L11_2 .. L12_2 .. L13_2
    L12_2 = type
    L13_2 = L10_2
    L12_2 = L12_2(L13_2)
    if "table" ~= L12_2 then
      L12_2 = L22_1
      L13_2 = L11_2
      L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L12_2(L13_2)
      return L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2
    end
    L12_2 = L27_1
    L13_2 = L10_2.id
    L14_2 = 32
    L12_2 = L12_2(L13_2, L14_2)
    if not L12_2 then
      L13_2 = L22_1
      L14_2 = L11_2
      L15_2 = ".id"
      L14_2 = L14_2 .. L15_2
      L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L13_2(L14_2)
      return L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2
    end
    L13_2 = L3_2[L12_2]
    if L13_2 then
      L13_2 = nil
      L14_2 = "ID repetido: %s."
      L15_2 = L14_2
      L14_2 = L14_2.format
      L16_2 = L12_2
      L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L14_2(L15_2, L16_2)
      return L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2
    end
    L3_2[L12_2] = true
    L13_2 = "products."
    L14_2 = L12_2
    L13_2 = L13_2 .. L14_2
    L11_2 = L13_2
    L13_2 = L25_1
    L14_2 = L10_2.price
    L15_2 = 1
    L16_2 = L12_1
    L13_2 = L13_2(L14_2, L15_2, L16_2)
    if not L13_2 then
      L14_2 = nil
      L15_2 = "Pre\195\167o inv\195\161lido em %s (1 a 100 000 000)."
      L16_2 = L15_2
      L15_2 = L15_2.format
      L17_2 = L11_2
      L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L15_2(L16_2, L17_2)
      return L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2
    end
    L14_2 = {}
    L14_2.id = L12_2
    L14_2.price = L13_2
    L15_2 = L23_1
    L16_2 = L10_2.name
    L17_2 = 48
    L18_2 = 1
    L15_2 = L15_2(L16_2, L17_2, L18_2)
    L14_2.name = L15_2
    L15_2 = L23_1
    L16_2 = L10_2.brand
    L17_2 = 24
    L18_2 = 0
    L15_2 = L15_2(L16_2, L17_2, L18_2)
    L14_2.brand = L15_2
    L15_2 = L23_1
    L16_2 = L10_2.os
    L17_2 = 24
    L18_2 = 0
    L15_2 = L15_2(L16_2, L17_2, L18_2)
    L14_2.os = L15_2
    L15_2 = L23_1
    L16_2 = L10_2.tagline
    L17_2 = 140
    L18_2 = 0
    L15_2 = L15_2(L16_2, L17_2, L18_2)
    L14_2.tagline = L15_2
    L15_2 = L23_1
    L16_2 = L10_2.badge
    L17_2 = 16
    L18_2 = 0
    L15_2 = L15_2(L16_2, L17_2, L18_2)
    L14_2.badge = L15_2
    L15_2 = L23_1
    L16_2 = L10_2.usage
    L17_2 = 240
    L18_2 = 0
    L15_2 = L15_2(L16_2, L17_2, L18_2)
    L14_2.usage = L15_2
    L15_2 = L10_2.enabled
    L15_2 = false ~= L15_2
    L14_2.enabled = L15_2
    L15_2 = ipairs
    L16_2 = {}
    L17_2 = "name"
    L18_2 = "brand"
    L19_2 = "os"
    L20_2 = "tagline"
    L21_2 = "badge"
    L22_2 = "usage"
    L16_2[1] = L17_2
    L16_2[2] = L18_2
    L16_2[3] = L19_2
    L16_2[4] = L20_2
    L16_2[5] = L21_2
    L16_2[6] = L22_2
    L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
    for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
      L21_2 = L14_2[L20_2]
      if nil == L21_2 then
        L21_2 = L22_1
        L22_2 = L11_2
        L23_2 = "."
        L24_2 = L20_2
        L22_2 = L22_2 .. L23_2 .. L24_2
        L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L21_2(L22_2)
        return L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2
      end
    end
    L15_2 = L10_2.enabled
    if nil ~= L15_2 then
      L15_2 = L10_2.enabled
      if true ~= L15_2 then
        L15_2 = L10_2.enabled
        if false ~= L15_2 then
          L15_2 = L22_1
          L16_2 = L11_2
          L17_2 = ".enabled"
          L16_2 = L16_2 .. L17_2
          L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L15_2(L16_2)
          return L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2
        end
      end
    end
    L15_2 = {}
    L14_2.categories = L15_2
    L15_2 = L10_2.categories
    if nil ~= L15_2 then
      L15_2 = L31_1
      L16_2 = L10_2.categories
      L15_2 = L15_2(L16_2)
      if L15_2 then
        L15_2 = L10_2.categories
        L15_2 = #L15_2
        L16_2 = L11_1
        if not (L15_2 > L16_2) then
          goto lbl_190
        end
      end
      L15_2 = L22_1
      L16_2 = L11_2
      L17_2 = ".categories"
      L16_2 = L16_2 .. L17_2
      L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L15_2(L16_2)
      do return L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 end
      ::lbl_190::
      L15_2 = ipairs
      L16_2 = L10_2.categories
      L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
      for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
        L21_2 = type
        L22_2 = L20_2
        L21_2 = L21_2(L22_2)
        if "string" ~= L21_2 then
          L21_2 = L22_1
          L22_2 = L11_2
          L23_2 = ".categories"
          L22_2 = L22_2 .. L23_2
          L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L21_2(L22_2)
          return L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2
        end
        L21_2 = A1_2[L20_2]
        if L21_2 then
          L21_2 = L14_2.categories
          L22_2 = L14_2.categories
          L22_2 = #L22_2
          L22_2 = L22_2 + 1
          L21_2[L22_2] = L20_2
        end
      end
    end
    L15_2 = {}
    L14_2.features = L15_2
    L15_2 = L10_2.features
    if nil ~= L15_2 then
      L15_2 = L31_1
      L16_2 = L10_2.features
      L15_2 = L15_2(L16_2)
      if L15_2 then
        L15_2 = L10_2.features
        L15_2 = #L15_2
        if not (L15_2 > 8) then
          goto lbl_238
        end
      end
      L15_2 = L22_1
      L16_2 = L11_2
      L17_2 = ".features"
      L16_2 = L16_2 .. L17_2
      L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L15_2(L16_2)
      do return L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 end
      ::lbl_238::
      L15_2 = ipairs
      L16_2 = L10_2.features
      L15_2, L16_2, L17_2, L18_2 = L15_2(L16_2)
      for L19_2, L20_2 in L15_2, L16_2, L17_2, L18_2 do
        L21_2 = L23_1
        L22_2 = L20_2
        L23_2 = 120
        L24_2 = 1
        L21_2 = L21_2(L22_2, L23_2, L24_2)
        if not L21_2 then
          L22_2 = L22_1
          L23_2 = L11_2
          L24_2 = ".features"
          L23_2 = L23_2 .. L24_2
          L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L22_2(L23_2)
          return L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2
        end
        L22_2 = L14_2.features
        L23_2 = L14_2.features
        L23_2 = #L23_2
        L23_2 = L23_2 + 1
        L22_2[L23_2] = L21_2
      end
    end
    L15_2 = {}
    L14_2.specs = L15_2
    L15_2 = L10_2.specs
    if nil ~= L15_2 then
      L15_2 = type
      L16_2 = L10_2.specs
      L15_2 = L15_2(L16_2)
      if "table" ~= L15_2 then
        L15_2 = L22_1
        L16_2 = L11_2
        L17_2 = ".specs"
        L16_2 = L16_2 .. L17_2
        L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L15_2(L16_2)
        return L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2
      end
      L15_2 = 0
      L16_2 = pairs
      L17_2 = L10_2.specs
      L16_2, L17_2, L18_2, L19_2 = L16_2(L17_2)
      for L20_2, L21_2 in L16_2, L17_2, L18_2, L19_2 do
        L15_2 = L15_2 + 1
        if not (L15_2 > 8) then
          L22_2 = type
          L23_2 = L20_2
          L22_2 = L22_2(L23_2)
          if "string" == L22_2 then
            L22_2 = #L20_2
            if not (L22_2 > 16) then
              L23_2 = L20_2
              L22_2 = L20_2.match
              L24_2 = "^[%a_]+$"
              L22_2 = L22_2(L23_2, L24_2)
              if L22_2 then
                goto lbl_309
              end
            end
          end
        end
        L22_2 = L22_1
        L23_2 = L11_2
        L24_2 = ".specs"
        L23_2 = L23_2 .. L24_2
        L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L22_2(L23_2)
        do return L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 end
        ::lbl_309::
        L22_2 = L23_1
        L23_2 = L21_2
        L24_2 = 24
        L25_2 = 0
        L22_2 = L22_2(L23_2, L24_2, L25_2)
        if not L22_2 then
          L23_2 = L22_1
          L24_2 = L11_2
          L25_2 = ".specs."
          L26_2 = L20_2
          L24_2 = L24_2 .. L25_2 .. L26_2
          L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L23_2(L24_2)
          return L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2
        end
        if "" ~= L22_2 then
          L23_2 = L14_2.specs
          L23_2[L20_2] = L22_2
        end
      end
    end
    L15_2 = L44_1
    L16_2 = L10_2.viewer
    L17_2 = L11_2
    L18_2 = ".viewer"
    L17_2 = L17_2 .. L18_2
    L15_2, L16_2 = L15_2(L16_2, L17_2)
    if not L15_2 then
      L17_2 = nil
      L18_2 = L16_2
      return L17_2, L18_2
    end
    L14_2.viewer = L15_2
    L17_2 = L31_1
    L18_2 = L10_2.variants
    L17_2 = L17_2(L18_2)
    if L17_2 then
      L17_2 = L10_2.variants
      L17_2 = #L17_2
      if not (L17_2 < 1) then
        goto lbl_357
      end
    end
    L17_2 = L22_1
    L18_2 = L11_2
    L19_2 = ".variants"
    L18_2 = L18_2 .. L19_2
    L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L17_2(L18_2)
    do return L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 end
    ::lbl_357::
    L17_2 = L10_2.variants
    L17_2 = #L17_2
    L18_2 = L10_1
    if L17_2 > L18_2 then
      L17_2 = nil
      L18_2 = "H\195\161 variantes a mais em %s (m\195\161ximo %d)."
      L19_2 = L18_2
      L18_2 = L18_2.format
      L20_2 = L12_2
      L21_2 = L10_1
      L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L18_2(L19_2, L20_2, L21_2)
      return L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2
    end
    L17_2 = {}
    L14_2.variants = L17_2
    L17_2 = ipairs
    L18_2 = L10_2.variants
    L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
    for L21_2, L22_2 in L17_2, L18_2, L19_2, L20_2 do
      L23_2 = L11_2
      L24_2 = ".variants["
      L25_2 = L21_2
      L26_2 = "]"
      L23_2 = L23_2 .. L24_2 .. L25_2 .. L26_2
      L24_2 = type
      L25_2 = L22_2
      L24_2 = L24_2(L25_2)
      if "table" ~= L24_2 then
        L24_2 = L22_1
        L25_2 = L23_2
        L24_2, L25_2, L26_2, L27_2, L28_2, L29_2 = L24_2(L25_2)
        return L24_2, L25_2, L26_2, L27_2, L28_2, L29_2
      end
      L24_2 = L28_1
      L25_2 = L22_2.item
      L24_2 = L24_2(L25_2)
      if not L24_2 then
        L25_2 = nil
        L26_2 = "Nome de item inv\195\161lido em %s."
        L27_2 = L26_2
        L26_2 = L26_2.format
        L28_2 = L23_2
        L26_2, L27_2, L28_2, L29_2 = L26_2(L27_2, L28_2)
        return L25_2, L26_2, L27_2, L28_2, L29_2
      end
      L25_2 = L4_2[L24_2]
      if L25_2 then
        L25_2 = nil
        L26_2 = "Item repetido: %s."
        L27_2 = L26_2
        L26_2 = L26_2.format
        L28_2 = L24_2
        L26_2, L27_2, L28_2, L29_2 = L26_2(L27_2, L28_2)
        return L25_2, L26_2, L27_2, L28_2, L29_2
      end
      L4_2[L24_2] = true
      L25_2 = {}
      L25_2.item = L24_2
      L26_2 = L23_1
      L27_2 = L22_2.color
      L28_2 = 32
      L29_2 = 1
      L26_2 = L26_2(L27_2, L28_2, L29_2)
      L25_2.color = L26_2
      L26_2 = L30_1
      L27_2 = L22_2.swatch
      L26_2 = L26_2(L27_2)
      L25_2.swatch = L26_2
      L26_2 = L22_2.enabled
      L26_2 = false ~= L26_2
      L25_2.enabled = L26_2
      L26_2 = L25_2.color
      if not L26_2 then
        L26_2 = L22_1
        L27_2 = L23_2
        L28_2 = ".color"
        L27_2 = L27_2 .. L28_2
        L26_2, L27_2, L28_2, L29_2 = L26_2(L27_2)
        return L26_2, L27_2, L28_2, L29_2
      end
      L26_2 = L25_2.swatch
      if not L26_2 then
        L26_2 = L22_1
        L27_2 = L23_2
        L28_2 = ".swatch"
        L27_2 = L27_2 .. L28_2
        L26_2, L27_2, L28_2, L29_2 = L26_2(L27_2)
        return L26_2, L27_2, L28_2, L29_2
      end
      L26_2 = L22_2.enabled
      if nil ~= L26_2 then
        L26_2 = L22_2.enabled
        if true ~= L26_2 then
          L26_2 = L22_2.enabled
          if false ~= L26_2 then
            L26_2 = L22_1
            L27_2 = L23_2
            L28_2 = ".enabled"
            L27_2 = L27_2 .. L28_2
            L26_2, L27_2, L28_2, L29_2 = L26_2(L27_2)
            return L26_2, L27_2, L28_2, L29_2
          end
        end
      end
      L26_2 = L22_2.price
      if nil ~= L26_2 then
        L26_2 = L22_2.price
        if "" ~= L26_2 then
          L26_2 = L22_2.price
          if false ~= L26_2 then
            L26_2 = L25_1
            L27_2 = L22_2.price
            L28_2 = 1
            L29_2 = L12_1
            L26_2 = L26_2(L27_2, L28_2, L29_2)
            L25_2.price = L26_2
            L26_2 = L25_2.price
            if not L26_2 then
              L26_2 = nil
              L27_2 = "Pre\195\167o inv\195\161lido em %s (1 a 100 000 000)."
              L28_2 = L27_2
              L27_2 = L27_2.format
              L29_2 = L23_2
              L27_2, L28_2, L29_2 = L27_2(L28_2, L29_2)
              return L26_2, L27_2, L28_2, L29_2
            end
          end
        end
      end
      L26_2 = L22_2.model
      if nil ~= L26_2 then
        L26_2 = L22_2.model
        if "" ~= L26_2 then
          L26_2 = type
          L27_2 = L22_2.model
          L26_2 = L26_2(L27_2)
          if "string" == L26_2 then
            L26_2 = L22_2.model
            L26_2 = #L26_2
            if not (L26_2 > 64) then
              L26_2 = L22_2.model
              L27_2 = L26_2
              L26_2 = L26_2.match
              L28_2 = "^[%w_%-]+%.glb$"
              L26_2 = L26_2(L27_2, L28_2)
              if L26_2 then
                goto lbl_514
              end
            end
          end
          L26_2 = L22_1
          L27_2 = L23_2
          L28_2 = ".model"
          L27_2 = L27_2 .. L28_2
          L26_2, L27_2, L28_2, L29_2 = L26_2(L27_2)
          do return L26_2, L27_2, L28_2, L29_2 end
          ::lbl_514::
          L26_2 = L22_2.model
          L25_2.model = L26_2
        end
      end
      L26_2 = L22_2.image
      if nil ~= L26_2 then
        L26_2 = L22_2.image
        if "" ~= L26_2 then
          L26_2 = L43_1
          L27_2 = L22_2.image
          L26_2 = L26_2(L27_2)
          L25_2.image = L26_2
          L26_2 = L25_2.image
          if not L26_2 then
            L26_2 = L22_1
            L27_2 = L23_2
            L28_2 = ".image"
            L27_2 = L27_2 .. L28_2
            L26_2, L27_2, L28_2, L29_2 = L26_2(L27_2)
            return L26_2, L27_2, L28_2, L29_2
          end
        end
      end
      L26_2 = L14_2.variants
      L27_2 = L14_2.variants
      L27_2 = #L27_2
      L27_2 = L27_2 + 1
      L26_2[L27_2] = L25_2
    end
    L17_2 = #L2_2
    L17_2 = L17_2 + 1
    L2_2[L17_2] = L14_2
  end
  return L2_2
end
function L46_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "table" ~= L1_2 then
    L1_2 = nil
    L2_2 = "Dados da loja inv\195\161lidos."
    return L1_2, L2_2
  end
  L1_2 = {}
  L2_2 = nil
  L3_2 = A0_2.enabled
  if nil ~= L3_2 then
    L3_2 = L26_1
    L4_2 = A0_2.enabled
    L3_2 = L3_2(L4_2)
    L1_2.enabled = L3_2
    L3_2 = L1_2.enabled
    if nil == L3_2 then
      L3_2 = L22_1
      L4_2 = "enabled"
      return L3_2(L4_2)
    end
  end
  L3_2 = A0_2.hidePlayer
  if nil ~= L3_2 then
    L3_2 = L26_1
    L4_2 = A0_2.hidePlayer
    L3_2 = L3_2(L4_2)
    L1_2.hidePlayer = L3_2
    L3_2 = L1_2.hidePlayer
    if nil == L3_2 then
      L3_2 = L22_1
      L4_2 = "hidePlayer"
      return L3_2(L4_2)
    end
  end
  L3_2 = A0_2.closeDistance
  if nil ~= L3_2 then
    L3_2 = L24_1
    L4_2 = A0_2.closeDistance
    L5_2 = 1.0
    L6_2 = 50.0
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    L1_2.closeDistance = L3_2
    L3_2 = L1_2.closeDistance
    if not L3_2 then
      L3_2 = L22_1
      L4_2 = "closeDistance"
      return L3_2(L4_2)
    end
  end
  L3_2 = A0_2.serverDistance
  if nil ~= L3_2 then
    L3_2 = L24_1
    L4_2 = A0_2.serverDistance
    L5_2 = 1.0
    L6_2 = 200.0
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    L1_2.serverDistance = L3_2
    L3_2 = L1_2.serverDistance
    if not L3_2 then
      L3_2 = L22_1
      L4_2 = "serverDistance"
      return L3_2(L4_2)
    end
  end
  L3_2 = {}
  L4_2 = L33_1
  L3_2.currency = L4_2
  L4_2 = L34_1
  L3_2.blip = L4_2
  L4_2 = L35_1
  L3_2.interaction = L4_2
  L4_2 = L36_1
  L3_2.camera = L4_2
  L4_2 = L38_1
  L3_2.ped = L4_2
  L4_2 = pairs
  L5_2 = L3_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = A0_2[L8_2]
    if nil ~= L10_2 then
      L10_2 = L32_1
      L11_2 = A0_2[L8_2]
      L12_2 = L9_2
      L13_2 = L8_2
      L10_2, L11_2 = L10_2(L11_2, L12_2, L13_2)
      L2_2 = L11_2
      L1_2[L8_2] = L10_2
      L10_2 = L1_2[L8_2]
      if not L10_2 then
        L10_2 = nil
        L11_2 = L2_2
        return L10_2, L11_2
      end
    end
  end
  L4_2 = A0_2.payment
  if nil ~= L4_2 then
    L4_2 = L39_1
    L5_2 = A0_2.payment
    L4_2, L5_2 = L4_2(L5_2)
    L2_2 = L5_2
    L1_2.payment = L4_2
    L4_2 = L1_2.payment
    if not L4_2 then
      L4_2 = nil
      L5_2 = L2_2
      return L4_2, L5_2
    end
  end
  L4_2 = A0_2.shops
  if nil ~= L4_2 then
    L4_2 = L41_1
    L5_2 = A0_2.shops
    L4_2, L5_2 = L4_2(L5_2)
    L2_2 = L5_2
    L1_2.shops = L4_2
    L4_2 = L1_2.shops
    if not L4_2 then
      L4_2 = nil
      L5_2 = L2_2
      return L4_2, L5_2
    end
  end
  L4_2 = A0_2.categories
  if nil ~= L4_2 then
    L4_2 = L42_1
    L5_2 = A0_2.categories
    L4_2, L5_2 = L4_2(L5_2)
    L2_2 = L5_2
    L1_2.categories = L4_2
    L4_2 = L1_2.categories
    if not L4_2 then
      L4_2 = nil
      L5_2 = L2_2
      return L4_2, L5_2
    end
  end
  L4_2 = A0_2.products
  if nil ~= L4_2 then
    L4_2 = L1_2.categories
    if not L4_2 then
      L4_2 = L1_1
      if L4_2 then
        L4_2 = L1_1.categories
        if L4_2 then
          goto lbl_172
        end
      end
      L4_2 = Config
      L4_2 = L4_2.Shop
      if L4_2 then
        L4_2 = Config
        L4_2 = L4_2.Shop
        L4_2 = L4_2.categories
        if L4_2 then
          goto lbl_172
        end
      end
      L4_2 = {}
    end
    ::lbl_172::
    L5_2 = {}
    L6_2 = ipairs
    L7_2 = L4_2
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
    for L10_2, L11_2 in L6_2, L7_2, L8_2, L9_2 do
      L12_2 = type
      L13_2 = L11_2
      L12_2 = L12_2(L13_2)
      if "table" == L12_2 then
        L12_2 = L11_2.id
        if L12_2 then
          L12_2 = L11_2.id
          L5_2[L12_2] = true
        end
      end
    end
    L6_2 = L45_1
    L7_2 = A0_2.products
    L8_2 = L5_2
    L6_2, L7_2 = L6_2(L7_2, L8_2)
    L2_2 = L7_2
    L1_2.products = L6_2
    L6_2 = L1_2.products
    if not L6_2 then
      L6_2 = nil
      L7_2 = L2_2
      return L6_2, L7_2
    end
  end
  return L1_2
end
ShopSanitize = L46_1
L46_1 = {}
L47_1 = "enabled"
L48_1 = "currency"
L49_1 = "payment"
L50_1 = "blip"
L51_1 = "interaction"
L52_1 = "closeDistance"
L53_1 = "serverDistance"
L54_1 = "camera"
L55_1 = "hidePlayer"
L56_1 = "ped"
L57_1 = "shops"
L58_1 = "categories"
L59_1 = "products"
L46_1[1] = L47_1
L46_1[2] = L48_1
L46_1[3] = L49_1
L46_1[4] = L50_1
L46_1[5] = L51_1
L46_1[6] = L52_1
L46_1[7] = L53_1
L46_1[8] = L54_1
L46_1[9] = L55_1
L46_1[10] = L56_1
L46_1[11] = L57_1
L46_1[12] = L58_1
L46_1[13] = L59_1
L47_1 = {}
L47_1.currency = true
L47_1.payment = true
L47_1.blip = true
L47_1.interaction = true
L47_1.camera = true
L47_1.ped = true
function L48_1()
  local L0_2, L1_2
  L0_2 = L16_1
  L1_2 = Config
  L1_2 = L1_2.Shop
  if not L1_2 then
    L1_2 = {}
  end
  L0_2 = L0_2(L1_2)
  L1_2 = L0_2.enabled
  if nil == L1_2 then
    L0_2.enabled = true
  end
  return L0_2
end
ShopDefaults = L48_1
function L48_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2
  L0_2 = ShopDefaults
  L0_2 = L0_2()
  L1_2 = AdminStore
  if L1_2 then
    L1_2 = AdminStore
    L1_2 = L1_2.Get
    L2_2 = "shop"
    L1_2 = L1_2(L2_2)
    if L1_2 then
      goto lbl_13
    end
  end
  L1_2 = nil
  ::lbl_13::
  L2_2 = type
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  if "table" == L2_2 then
    L2_2 = ShopSanitize
    L3_2 = L1_2
    L2_2, L3_2 = L2_2(L3_2)
    if not L2_2 then
      L4_2 = ShopBridge
      L4_2 = L4_2.warn
      L5_2 = "the shop saved in the panel is invalid (%s): using config.lua"
      L6_2 = L5_2
      L5_2 = L5_2.format
      L7_2 = tostring
      L8_2 = L3_2
      L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L7_2(L8_2)
      L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
      L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
    else
      L4_2 = ipairs
      L5_2 = L46_1
      L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
      for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
        L10_2 = L2_2[L9_2]
        if nil ~= L10_2 then
          L11_2 = L47_1
          L11_2 = L11_2[L9_2]
          if L11_2 then
            L11_2 = type
            L12_2 = L0_2[L9_2]
            L11_2 = L11_2(L12_2)
            if "table" == L11_2 then
              L11_2 = type
              L12_2 = L10_2
              L11_2 = L11_2(L12_2)
              if "table" == L11_2 then
                L11_2 = pairs
                L12_2 = L10_2
                L11_2, L12_2, L13_2, L14_2 = L11_2(L12_2)
                for L15_2, L16_2 in L11_2, L12_2, L13_2, L14_2 do
                  L17_2 = L0_2[L9_2]
                  L18_2 = L16_1
                  L19_2 = L16_2
                  L18_2 = L18_2(L19_2)
                  L17_2[L15_2] = L18_2
                end
            end
          end
          else
            L11_2 = L16_1
            L12_2 = L10_2
            L11_2 = L11_2(L12_2)
            L0_2[L9_2] = L11_2
          end
        end
      end
    end
  end
  L2_2 = L0_2.payment
  if not L2_2 then
    L2_2 = {}
  end
  L0_2.payment = L2_2
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L0_2.payment
  L4_2 = L4_2.accounts
  if not L4_2 then
    L4_2 = {}
    L5_2 = "bank"
    L6_2 = "cash"
    L4_2[1] = L5_2
    L4_2[2] = L6_2
  end
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    if "bank" == L8_2 or "cash" == L8_2 then
      L9_2 = #L2_2
      L9_2 = L9_2 + 1
      L2_2[L9_2] = L8_2
    else
      L9_2 = ShopBridge
      L9_2 = L9_2.warnOnce
      L10_2 = "acc:"
      L11_2 = tostring
      L12_2 = L8_2
      L11_2 = L11_2(L12_2)
      L10_2 = L10_2 .. L11_2
      L11_2 = "Config.Shop.payment.accounts: unknown account \"%s\" (use bank or cash)"
      L12_2 = L11_2
      L11_2 = L11_2.format
      L13_2 = tostring
      L14_2 = L8_2
      L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L13_2(L14_2)
      L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2 = L11_2(L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
      L9_2(L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2)
    end
  end
  L3_2 = #L2_2
  if 0 == L3_2 then
    L3_2 = {}
    L4_2 = "bank"
    L3_2[1] = L4_2
    L2_2 = L3_2
  end
  L3_2 = L0_2.payment
  L3_2.accounts = L2_2
  L3_2 = L0_2.payment
  L3_2 = L3_2.default
  L4_2 = false
  L5_2 = ipairs
  L6_2 = L2_2
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    if L10_2 == L3_2 then
      L4_2 = true
    end
  end
  L5_2 = L0_2.payment
  L6_2 = L3_2 or L6_2
  if not L4_2 or not L3_2 then
    L6_2 = L2_2[1]
  end
  L5_2.default = L6_2
  L5_2 = L0_2.shops
  if not L5_2 then
    L5_2 = {}
  end
  L6_2 = L0_2.categories
  if not L6_2 then
    L6_2 = {}
  end
  L7_2 = L0_2.products
  if not L7_2 then
    L7_2 = {}
  end
  L0_2.products = L7_2
  L0_2.categories = L6_2
  L0_2.shops = L5_2
  L5_2 = ipairs
  L6_2 = L0_2.shops
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L10_2.coords
    if L11_2 then
      L11_2 = L16_1
      L12_2 = L10_2.coords
      L11_2 = L11_2(L12_2)
      if L11_2 then
        goto lbl_181
      end
    end
    L11_2 = nil
    ::lbl_181::
    L10_2.coords = L11_2
  end
  return L0_2
end
function L49_1()
  local L0_2, L1_2
  L0_2 = L1_1
  if not L0_2 then
    L0_2 = L48_1
    L0_2 = L0_2()
    L1_1 = L0_2
  end
  L0_2 = L16_1
  L1_2 = L1_1
  return L0_2(L1_2)
end
ShopEffective = L49_1
function L49_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L0_2 = {}
  L1_2 = {}
  L2_2 = {}
  L2_1.off = L2_2
  L2_1.items = L1_2
  L2_1.byItem = L0_2
  L0_2 = ipairs
  L1_2 = L1_1.products
  if not L1_2 then
    L1_2 = {}
  end
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
    L6_2 = math
    L6_2 = L6_2.floor
    L7_2 = tonumber
    L8_2 = L5_2.price
    L7_2 = L7_2(L8_2)
    if not L7_2 then
      L7_2 = 0
    end
    L6_2 = L6_2(L7_2)
    L7_2 = ipairs
    L8_2 = L5_2.variants
    if not L8_2 then
      L8_2 = {}
    end
    L7_2, L8_2, L9_2, L10_2 = L7_2(L8_2)
    for L11_2, L12_2 in L7_2, L8_2, L9_2, L10_2 do
      L13_2 = L12_2.item
      L14_2 = type
      L15_2 = L13_2
      L14_2 = L14_2(L15_2)
      if "string" ~= L14_2 or "" == L13_2 then
        L14_2 = ShopBridge
        L14_2 = L14_2.warn
        L15_2 = "product %s has a variant without an item"
        L16_2 = L15_2
        L15_2 = L15_2.format
        L17_2 = tostring
        L18_2 = L5_2.id
        L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2)
        L15_2, L16_2, L17_2, L18_2, L19_2, L20_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
        L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
      else
        L14_2 = L2_1.byItem
        L14_2 = L14_2[L13_2]
        if not L14_2 then
          L14_2 = L2_1.off
          L14_2 = L14_2[L13_2]
          if not L14_2 then
            goto lbl_72
          end
        end
        L14_2 = ShopBridge
        L14_2 = L14_2.warnOnce
        L15_2 = "dup:"
        L16_2 = L13_2
        L15_2 = L15_2 .. L16_2
        L16_2 = "item %s appears in two products: only the first is kept"
        L17_2 = L16_2
        L16_2 = L16_2.format
        L18_2 = L13_2
        L16_2, L17_2, L18_2, L19_2, L20_2 = L16_2(L17_2, L18_2)
        L14_2(L15_2, L16_2, L17_2, L18_2, L19_2, L20_2)
        goto lbl_119
        ::lbl_72::
        L14_2 = L5_2.enabled
        if false ~= L14_2 then
          L14_2 = L12_2.enabled
          if false ~= L14_2 then
            goto lbl_81
          end
        end
        L14_2 = L2_1.off
        L14_2[L13_2] = true
        goto lbl_119
        ::lbl_81::
        L14_2 = math
        L14_2 = L14_2.floor
        L15_2 = tonumber
        L16_2 = L12_2.price
        L15_2 = L15_2(L16_2)
        if not L15_2 then
          L15_2 = L6_2
        end
        L14_2 = L14_2(L15_2)
        if L14_2 <= 0 then
          L15_2 = ShopBridge
          L15_2 = L15_2.warnOnce
          L16_2 = "price:"
          L17_2 = L13_2
          L16_2 = L16_2 .. L17_2
          L17_2 = "product %s / %s has no valid price: not for sale"
          L18_2 = L17_2
          L17_2 = L17_2.format
          L19_2 = tostring
          L20_2 = L5_2.id
          L19_2 = L19_2(L20_2)
          L20_2 = L13_2
          L17_2, L18_2, L19_2, L20_2 = L17_2(L18_2, L19_2, L20_2)
          L15_2(L16_2, L17_2, L18_2, L19_2, L20_2)
        else
          L15_2 = L2_1.byItem
          L16_2 = {}
          L16_2.product = L5_2
          L16_2.variant = L12_2
          L16_2.price = L14_2
          L15_2[L13_2] = L16_2
          L15_2 = L2_1.items
          L16_2 = L2_1.items
          L16_2 = #L16_2
          L16_2 = L16_2 + 1
          L15_2[L16_2] = L13_2
        end
      end
      ::lbl_119::
    end
  end
  L0_2 = {}
  L5_1 = L0_2
  L0_2 = ipairs
  L1_2 = L1_1.payment
  L1_2 = L1_2.accounts
  L0_2, L1_2, L2_2, L3_2 = L0_2(L1_2)
  for L4_2, L5_2 in L0_2, L1_2, L2_2, L3_2 do
    L6_2 = L5_1
    L6_2[L5_2] = true
  end
end
function L50_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  if not A0_2 then
    L1_2 = next
    L2_2 = L3_1
    L1_2 = L1_2(L2_2)
    if L1_2 then
      L1_2 = GetGameTimer
      L1_2 = L1_2()
      L2_2 = L4_1
      L1_2 = L1_2 - L2_2
      L2_2 = 60000
      if L1_2 < L2_2 then
        return
      end
    end
  end
  L1_2 = ShopBridge
  L1_2 = L1_2.Ready
  L1_2 = L1_2()
  if not L1_2 then
    return
  end
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = L2_1.items
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = ShopBridge
    L8_2 = L8_2.ItemExists
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    L9_2 = L3_1
    L9_2[L7_2] = L8_2
    if not L8_2 then
      L9_2 = #L1_2
      L9_2 = L9_2 + 1
      L1_2[L9_2] = L7_2
    end
  end
  L2_2 = GetGameTimer
  L2_2 = L2_2()
  L4_1 = L2_2
  L2_2 = #L1_2
  if L2_2 > 0 then
    L2_2 = ShopBridge
    L2_2 = L2_2.warnOnce
    L3_2 = "missing:"
    L4_2 = table
    L4_2 = L4_2.concat
    L5_2 = L1_2
    L6_2 = ","
    L4_2 = L4_2(L5_2, L6_2)
    L3_2 = L3_2 .. L4_2
    L4_2 = "items the inventory does not know (shown as \"Coming soon\"): %s"
    L5_2 = L4_2
    L4_2 = L4_2.format
    L6_2 = table
    L6_2 = L6_2.concat
    L7_2 = L1_2
    L8_2 = ", "
    L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2)
    L4_2, L5_2, L6_2, L7_2, L8_2, L9_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2)
    L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2)
  end
  return L1_2
end
function L51_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = {}
  L2_2.rev = A1_2
  L3_2 = A0_2.enabled
  L3_2 = false ~= L3_2
  L2_2.enabled = L3_2
  L3_2 = A0_2.currency
  if not L3_2 then
    L3_2 = {}
    L4_2 = Config
    L4_2 = L4_2.Currency
    if L4_2 then
      L4_2 = Config
      L4_2 = L4_2.Currency
      L4_2 = L4_2.symbol
      if L4_2 then
        goto lbl_25
      end
    end
    L4_2 = "$"
    ::lbl_25::
    L3_2.symbol = L4_2
    L4_2 = Config
    L4_2 = L4_2.Currency
    if L4_2 then
      L4_2 = Config
      L4_2 = L4_2.Currency
      L4_2 = L4_2.position
      if L4_2 then
        goto lbl_36
      end
    end
    L4_2 = "before"
    ::lbl_36::
    L3_2.position = L4_2
  end
  L2_2.currency = L3_2
  L3_2 = A0_2.imagePath
  if not L3_2 then
    L3_2 = "nui://apex_phone/inventory_images/%s.png"
  end
  L2_2.imagePath = L3_2
  L3_2 = {}
  L4_2 = A0_2.payment
  L4_2 = L4_2.accounts
  L3_2.accounts = L4_2
  L4_2 = A0_2.payment
  L4_2 = L4_2.default
  L3_2.default = L4_2
  L2_2.payment = L3_2
  L3_2 = A0_2.blip
  if not L3_2 then
    L3_2 = {}
  end
  L2_2.blip = L3_2
  L3_2 = A0_2.interaction
  if not L3_2 then
    L3_2 = {}
  end
  L2_2.interaction = L3_2
  L3_2 = A0_2.closeDistance
  if not L3_2 then
    L3_2 = 6.0
  end
  L2_2.closeDistance = L3_2
  L3_2 = A0_2.camera
  if not L3_2 then
    L3_2 = {}
  end
  L2_2.camera = L3_2
  L3_2 = A0_2.hidePlayer
  L3_2 = false ~= L3_2
  L2_2.hidePlayer = L3_2
  L3_2 = A0_2.ped
  if not L3_2 then
    L3_2 = {}
  end
  L2_2.ped = L3_2
  L3_2 = A0_2.shops
  L2_2.shops = L3_2
  L3_2 = A0_2.categories
  L2_2.categories = L3_2
  L3_2 = A0_2.products
  L2_2.products = L3_2
  return L2_2
end
function L52_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = L48_1
  L0_2 = L0_2()
  L1_1 = L0_2
  L0_2 = L49_1
  L0_2()
  L0_2 = GlobalState
  L0_2 = L0_2["apex_phone:shop"]
  L1_2 = type
  L2_2 = L0_2
  L1_2 = L1_2(L2_2)
  if "table" == L1_2 then
    L1_2 = tonumber
    L2_2 = L0_2.rev
    L1_2 = L1_2(L2_2)
    if L1_2 then
      goto lbl_19
    end
  end
  L1_2 = 0
  ::lbl_19::
  L1_2 = L1_2 + 1
  L2_2 = GlobalState
  L3_2 = L51_1
  L4_2 = L1_1
  L5_2 = L1_2
  L3_2 = L3_2(L4_2, L5_2)
  L2_2["apex_phone:shop"] = L3_2
  L2_2 = L14_1
  L3_2 = "published rev %d: %d shops, %d products, %d items for sale"
  L4_2 = L1_2
  L5_2 = L1_1.shops
  L5_2 = #L5_2
  L6_2 = L1_1.products
  L6_2 = #L6_2
  L7_2 = L2_1.items
  L7_2 = #L7_2
  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
  L2_2 = CreateThread
  function L3_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3
    L0_3 = 1
    L1_3 = 30
    L2_3 = 1
    for L3_3 = L0_3, L1_3, L2_3 do
      L4_3 = ShopBridge
      L4_3 = L4_3.Ready
      L4_3 = L4_3()
      if L4_3 then
        break
      end
      L4_3 = Wait
      L5_3 = 1000
      L4_3(L5_3)
    end
    L0_3 = Wait
    L1_3 = 1500
    L0_3(L1_3)
    L0_3 = L50_1
    L1_3 = true
    L0_3(L1_3)
  end
  L2_2(L3_2)
end
function L53_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = ipairs
  L2_2 = L1_1.shops
  if not L2_2 then
    L2_2 = {}
  end
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.id
    if L7_2 == A0_2 then
      return L6_2
    end
  end
  L1_2 = nil
  return L1_2
end
function L54_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  L2_2 = L6_1
  L2_2 = L2_2[A0_2]
  if L2_2 then
    L2_2 = true
    return L2_2
  end
  L2_2 = L53_1
  L3_2 = A1_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L3_2 = L2_2.coords
    if L3_2 then
      goto lbl_17
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_17::
  L3_2 = GetPlayerPed
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not L3_2 or 0 == L3_2 then
    L4_2 = ShopBridge
    L4_2 = L4_2.warnOnce
    L5_2 = "nopos"
    L6_2 = "no player position on the server (OneSync disabled?): the distance to the shop is not checked"
    L4_2(L5_2, L6_2)
    L4_2 = true
    return L4_2
  end
  L4_2 = GetEntityCoords
  L5_2 = L3_2
  L4_2 = L4_2(L5_2)
  L5_2 = L4_2.x
  if 0.0 == L5_2 then
    L5_2 = L4_2.y
    if 0.0 == L5_2 then
      L5_2 = L4_2.z
      if 0.0 == L5_2 then
        L5_2 = true
        return L5_2
      end
    end
  end
  L5_2 = L2_2.coords
  L6_2 = L4_2.x
  L7_2 = L5_2.x
  L6_2 = L6_2 - L7_2
  L7_2 = L4_2.y
  L8_2 = L5_2.y
  L7_2 = L7_2 - L8_2
  L8_2 = L4_2.z
  L9_2 = L5_2.z
  L8_2 = L8_2 - L9_2
  L9_2 = L6_2 * L6_2
  L10_2 = L7_2 * L7_2
  L9_2 = L9_2 + L10_2
  L10_2 = L8_2 * L8_2
  L9_2 = L9_2 + L10_2
  L10_2 = L1_1.serverDistance
  if not L10_2 then
    L10_2 = 10.0
  end
  L10_2 = L10_2 ^ 2
  L9_2 = L9_2 <= L10_2
  return L9_2
end
function L55_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L1_2 = {}
  L2_2 = pairs
  L3_2 = L5_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2 in L2_2, L3_2, L4_2, L5_2 do
    L7_2 = ShopBridge
    L7_2 = L7_2.GetBalance
    L8_2 = A0_2
    L9_2 = L6_2
    L7_2 = L7_2(L8_2, L9_2)
    L1_2[L6_2] = L7_2
  end
  return L1_2
end
function L56_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L1_2 = L50_1
  L2_2 = false
  L1_2(L2_2)
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = L2_1.items
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L3_1
    L8_2 = L8_2[L7_2]
    L8_2 = true == L8_2
    L1_2[L7_2] = L8_2
  end
  L2_2 = {}
  L3_2 = L55_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L2_2.wallet = L3_2
  L3_2 = ShopBridge
  L3_2 = L3_2.CountItems
  L4_2 = A0_2
  L5_2 = L2_1.items
  L3_2 = L3_2(L4_2, L5_2)
  L2_2.owned = L3_2
  L2_2.available = L1_2
  L3_2 = ShopBridge
  L3_2 = L3_2.name
  L3_2 = nil ~= L3_2
  L2_2.framework = L3_2
  return L2_2
end
function L57_1(A0_2, ...)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = L13_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L1_2 = L13_1.server
  end
  L2_2 = select
  L3_2 = "#"
  L4_2 = ...
  L2_2 = L2_2(L3_2, L4_2)
  if L2_2 > 0 then
    L3_2 = L1_2
    L2_2 = L1_2.format
    L4_2 = ...
    L2_2 = L2_2(L3_2, L4_2)
    L1_2 = L2_2
  end
  L2_2 = {}
  L2_2.ok = false
  L2_2.error = A0_2
  L2_2.message = L1_2
  return L2_2
end
L58_1 = [[
CREATE TABLE IF NOT EXISTS `apex_phone_shop_sales` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `at` BIGINT NOT NULL,
  `cid` VARCHAR(64) NULL,
  `name` VARCHAR(100) NULL,
  `item` VARCHAR(64) NOT NULL,
  `product` VARCHAR(32) NULL,
  `label` VARCHAR(120) NULL,
  `price` BIGINT NOT NULL,
  `account` VARCHAR(12) NULL,
  `shop` VARCHAR(32) NULL,
  PRIMARY KEY (`id`), KEY `at` (`at`), KEY `item` (`item`)
)]]
L59_1 = false
L60_1 = CreateThread
function L61_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2
  L0_2 = pcall
  function L1_2()
    local L0_3, L1_3
    L0_3 = MySQL
    L0_3 = L0_3.query
    L0_3 = L0_3.await
    L1_3 = L58_1
    L0_3(L1_3)
  end
  L0_2, L1_2 = L0_2(L1_2)
  if L0_2 then
    L2_2 = true
    L59_1 = L2_2
  else
    L2_2 = print
    L3_2 = "^1[unique_phone]^0 shop: sales table: %s"
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = tostring
    L6_2 = L1_2
    L5_2, L6_2 = L5_2(L6_2)
    L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2, L5_2, L6_2)
    L2_2(L3_2, L4_2, L5_2, L6_2)
  end
end
L60_1(L61_1)
function L60_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2)
  local L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2
  L7_2 = nil
  L8_2 = pcall
  function L9_2()
    local L0_3, L1_3
    L0_3 = GetCid
    if L0_3 then
      L0_3 = GetCid
      L1_3 = A0_2
      L0_3 = L0_3(L1_3)
      if L0_3 then
        goto lbl_10
      end
    end
    L0_3 = nil
    ::lbl_10::
    L7_2 = L0_3
  end
  L8_2(L9_2)
  if not L7_2 then
    L8_2 = ShopBridge
    L8_2 = L8_2.Identifier
    L9_2 = A0_2
    L8_2 = L8_2(L9_2)
    L7_2 = L8_2
  end
  L8_2 = ShopBridge
  L8_2 = L8_2.CharName
  L9_2 = A0_2
  L8_2 = L8_2(L9_2)
  L9_2 = CreateThread
  function L10_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3
    L0_3 = pcall
    function L1_3()
      local L0_4, L1_4, L2_4, L3_4, L4_4, L5_4, L6_4, L7_4, L8_4, L9_4, L10_4, L11_4, L12_4, L13_4, L14_4
      L0_4 = MySQL
      L0_4 = L0_4.insert
      L0_4 = L0_4.await
      L1_4 = "INSERT INTO apex_phone_shop_sales (at, cid, name, item, product, label, price, account, shop) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
      L2_4 = {}
      L3_4 = os
      L3_4 = L3_4.time
      L3_4 = L3_4()
      L3_4 = L3_4 * 1000
      L4_4 = L7_2
      if L4_4 then
        L4_4 = tostring
        L5_4 = L7_2
        L4_4 = L4_4(L5_4)
        L5_4 = L4_4
        L4_4 = L4_4.sub
        L6_4 = 1
        L7_4 = 64
        L4_4 = L4_4(L5_4, L6_4, L7_4)
        if L4_4 then
          goto lbl_25
        end
      end
      L4_4 = nil
      ::lbl_25::
      L5_4 = tostring
      L6_4 = L8_2
      L5_4 = L5_4(L6_4)
      L6_4 = L5_4
      L5_4 = L5_4.sub
      L7_4 = 1
      L8_4 = 100
      L5_4 = L5_4(L6_4, L7_4, L8_4)
      L6_4 = A2_2
      L7_4 = tostring
      L8_4 = A1_2.product
      L8_4 = L8_4.id
      if not L8_4 then
        L8_4 = ""
      end
      L7_4 = L7_4(L8_4)
      L8_4 = L7_4
      L7_4 = L7_4.sub
      L9_4 = 1
      L10_4 = 32
      L7_4 = L7_4(L8_4, L9_4, L10_4)
      L8_4 = tostring
      L9_4 = A6_2
      L8_4 = L8_4(L9_4)
      L9_4 = L8_4
      L8_4 = L8_4.sub
      L10_4 = 1
      L11_4 = 120
      L8_4 = L8_4(L9_4, L10_4, L11_4)
      L9_4 = A3_2
      L10_4 = A4_2
      L11_4 = tostring
      L12_4 = A5_2
      if not L12_4 then
        L12_4 = ""
      end
      L11_4 = L11_4(L12_4)
      L12_4 = L11_4
      L11_4 = L11_4.sub
      L13_4 = 1
      L14_4 = 32
      L11_4, L12_4, L13_4, L14_4 = L11_4(L12_4, L13_4, L14_4)
      L2_4[1] = L3_4
      L2_4[2] = L4_4
      L2_4[3] = L5_4
      L2_4[4] = L6_4
      L2_4[5] = L7_4
      L2_4[6] = L8_4
      L2_4[7] = L9_4
      L2_4[8] = L10_4
      L2_4[9] = L11_4
      L2_4[10] = L12_4
      L2_4[11] = L13_4
      L2_4[12] = L14_4
      L0_4(L1_4, L2_4)
    end
    L0_3, L1_3 = L0_3(L1_3)
    if not L0_3 then
      L2_3 = print
      L3_3 = "^1[unique_phone]^0 shop: sale not recorded: %s"
      L4_3 = L3_3
      L3_3 = L3_3.format
      L5_3 = tostring
      L6_3 = L1_3
      L5_3, L6_3 = L5_3(L6_3)
      L3_3, L4_3, L5_3, L6_3 = L3_3(L4_3, L5_3, L6_3)
      L2_3(L3_3, L4_3, L5_3, L6_3)
    end
  end
  L9_2(L10_2)
  L9_2 = AdminStore
  if L9_2 then
    L9_2 = AdminStore
    L9_2 = L9_2.Get
    L10_2 = "webhooks"
    L9_2 = L9_2(L10_2)
  end
  L10_2 = type
  L11_2 = L9_2
  L10_2 = L10_2(L11_2)
  if "table" == L10_2 then
    L10_2 = L9_2.shop
    if L10_2 then
      goto lbl_35
    end
  end
  L10_2 = nil
  ::lbl_35::
  if L10_2 and "" ~= L10_2 then
    L11_2 = ValidWebhookUrl
    if L11_2 then
      L11_2 = ValidWebhookUrl
      L12_2 = L10_2
      L11_2 = L11_2(L12_2)
      if L11_2 then
        L11_2 = L53_1
        L12_2 = A5_2
        L11_2 = L11_2(L12_2)
        L12_2 = PostWebhook
        L13_2 = L10_2
        L14_2 = {}
        L15_2 = {}
        L16_2 = WebhookEmbed
        L17_2 = {}
        L17_2.title = "Loja de telem\195\179veis \194\183 venda"
        L17_2.description = A6_2
        L17_2.color = "#1F5EFF"
        L18_2 = {}
        L19_2 = {}
        L19_2.name = "Jogador"
        L20_2 = "%s (%d)"
        L21_2 = L20_2
        L20_2 = L20_2.format
        L22_2 = L8_2
        L23_2 = A0_2
        L20_2 = L20_2(L21_2, L22_2, L23_2)
        L19_2.value = L20_2
        L19_2.inline = true
        L20_2 = {}
        L20_2.name = "Pre\195\167o"
        L21_2 = L19_1
        L22_2 = A3_2
        L21_2 = L21_2(L22_2)
        L20_2.value = L21_2
        L20_2.inline = true
        L21_2 = {}
        L21_2.name = "Conta"
        if "bank" == A4_2 then
          L22_2 = "Banco"
          if L22_2 then
            goto lbl_91
          end
        end
        L22_2 = "Dinheiro"
        ::lbl_91::
        L21_2.value = L22_2
        L21_2.inline = true
        L22_2 = {}
        L22_2.name = "Item"
        L22_2.value = A2_2
        L22_2.inline = true
        L23_2 = {}
        L23_2.name = "Loja"
        if L11_2 then
          L24_2 = L11_2.label
          if L24_2 then
            goto lbl_116
          end
        end
        L24_2 = L6_1
        L24_2 = L24_2[A0_2]
        if L24_2 then
          L24_2 = "Painel admin (teste)"
          if L24_2 then
            goto lbl_116
          end
        end
        L24_2 = tostring
        L25_2 = A5_2
        L24_2 = L24_2(L25_2)
        ::lbl_116::
        L23_2.value = L24_2
        L23_2.inline = true
        L18_2[1] = L19_2
        L18_2[2] = L20_2
        L18_2[3] = L21_2
        L18_2[4] = L22_2
        L18_2[5] = L23_2
        L17_2.fields = L18_2
        if L7_2 then
          L18_2 = tostring
          L19_2 = L7_2
          L18_2 = L18_2(L19_2)
          if L18_2 then
            goto lbl_128
          end
        end
        L18_2 = nil
        ::lbl_128::
        L17_2.footer = L18_2
        L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2 = L16_2(L17_2)
        L15_2[1] = L16_2
        L15_2[2] = L17_2
        L15_2[3] = L18_2
        L15_2[4] = L19_2
        L15_2[5] = L20_2
        L15_2[6] = L21_2
        L15_2[7] = L22_2
        L15_2[8] = L23_2
        L15_2[9] = L24_2
        L15_2[10] = L25_2
        L14_2.embeds = L15_2
        L12_2(L13_2, L14_2)
      end
    end
  end
end
function L61_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2
  L0_2 = {}
  L0_2.salesTotal = 0
  L0_2.salesCount = 0
  L1_2 = {}
  L1_2.count = 0
  L1_2.total = 0
  L0_2.today = L1_2
  L1_2 = {}
  L0_2.top = L1_2
  L1_2 = {}
  L0_2.recent = L1_2
  L1_2 = L59_1
  if not L1_2 then
    return L0_2
  end
  L1_2 = os
  L1_2 = L1_2.date
  L2_2 = "*t"
  L1_2 = L1_2(L2_2)
  L2_2 = 0
  L3_2 = 0
  L1_2.sec = 0
  L1_2.min = L3_2
  L1_2.hour = L2_2
  L2_2 = os
  L2_2 = L2_2.time
  L3_2 = L1_2
  L2_2 = L2_2(L3_2)
  L2_2 = L2_2 * 1000
  L3_2 = {}
  L4_2 = ipairs
  L5_2 = L1_1
  if L5_2 then
    L5_2 = L1_1.products
    if L5_2 then
      goto lbl_46
    end
  end
  L5_2 = {}
  ::lbl_46::
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = ipairs
    L11_2 = L9_2.variants
    if not L11_2 then
      L11_2 = {}
    end
    L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
    for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
      L16_2 = L15_2.item
      L17_2 = "%s \194\183 %s"
      L18_2 = L17_2
      L17_2 = L17_2.format
      L19_2 = L9_2.name
      if not L19_2 then
        L19_2 = L15_2.item
      end
      L20_2 = L15_2.color
      if not L20_2 then
        L20_2 = ""
      end
      L17_2 = L17_2(L18_2, L19_2, L20_2)
      L3_2[L16_2] = L17_2
    end
  end
  L4_2 = {}
  L5_2 = ipairs
  L6_2 = L1_1
  if L6_2 then
    L6_2 = L1_1.shops
    if L6_2 then
      goto lbl_86
    end
  end
  L6_2 = {}
  ::lbl_86::
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  for L9_2, L10_2 in L5_2, L6_2, L7_2, L8_2 do
    L11_2 = L10_2.id
    L12_2 = L10_2.label
    L4_2[L11_2] = L12_2
  end
  L5_2 = pcall
  function L6_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3, L8_3, L9_3, L10_3, L11_3, L12_3
    L0_3 = MySQL
    L0_3 = L0_3.single
    L0_3 = L0_3.await
    L1_3 = "SELECT COUNT(*) AS c, COALESCE(SUM(price), 0) AS t FROM apex_phone_shop_sales"
    L0_3 = L0_3(L1_3)
    if not L0_3 then
      L0_3 = {}
    end
    L1_3 = tonumber
    L2_3 = L0_3.c
    L1_3 = L1_3(L2_3)
    if not L1_3 then
      L1_3 = 0
    end
    L2_3 = tonumber
    L3_3 = L0_3.t
    L2_3 = L2_3(L3_3)
    if not L2_3 then
      L2_3 = 0
    end
    L0_2.salesTotal = L2_3
    L0_2.salesCount = L1_3
    L1_3 = MySQL
    L1_3 = L1_3.single
    L1_3 = L1_3.await
    L2_3 = "SELECT COUNT(*) AS c, COALESCE(SUM(price), 0) AS t FROM apex_phone_shop_sales WHERE at >= ?"
    L3_3 = {}
    L4_3 = L2_2
    L3_3[1] = L4_3
    L1_3 = L1_3(L2_3, L3_3)
    if not L1_3 then
      L1_3 = {}
    end
    L2_3 = {}
    L3_3 = tonumber
    L4_3 = L1_3.c
    L3_3 = L3_3(L4_3)
    if not L3_3 then
      L3_3 = 0
    end
    L2_3.count = L3_3
    L3_3 = tonumber
    L4_3 = L1_3.t
    L3_3 = L3_3(L4_3)
    if not L3_3 then
      L3_3 = 0
    end
    L2_3.total = L3_3
    L0_2.today = L2_3
    L2_3 = ipairs
    L3_3 = MySQL
    L3_3 = L3_3.query
    L3_3 = L3_3.await
    L4_3 = "SELECT item, MAX(label) AS label, COUNT(*) AS c, COALESCE(SUM(price), 0) AS t FROM apex_phone_shop_sales GROUP BY item ORDER BY c DESC, t DESC LIMIT 8"
    L3_3 = L3_3(L4_3)
    if not L3_3 then
      L3_3 = {}
    end
    L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3)
    for L6_3, L7_3 in L2_3, L3_3, L4_3, L5_3 do
      L8_3 = L0_2.top
      L9_3 = L0_2.top
      L9_3 = #L9_3
      L9_3 = L9_3 + 1
      L10_3 = {}
      L11_3 = L7_3.item
      L10_3.item = L11_3
      L12_3 = L7_3.item
      L11_3 = L3_2
      L11_3 = L11_3[L12_3]
      if not L11_3 then
        L11_3 = L7_3.label
        if not L11_3 then
          L11_3 = L7_3.item
        end
      end
      L10_3.label = L11_3
      L11_3 = tonumber
      L12_3 = L7_3.c
      L11_3 = L11_3(L12_3)
      if not L11_3 then
        L11_3 = 0
      end
      L10_3.count = L11_3
      L11_3 = tonumber
      L12_3 = L7_3.t
      L11_3 = L11_3(L12_3)
      if not L11_3 then
        L11_3 = 0
      end
      L10_3.total = L11_3
      L8_3[L9_3] = L10_3
    end
    L2_3 = ipairs
    L3_3 = MySQL
    L3_3 = L3_3.query
    L3_3 = L3_3.await
    L4_3 = "SELECT at, name, item, label, price, account, shop FROM apex_phone_shop_sales ORDER BY id DESC LIMIT 15"
    L3_3 = L3_3(L4_3)
    if not L3_3 then
      L3_3 = {}
    end
    L2_3, L3_3, L4_3, L5_3 = L2_3(L3_3)
    for L6_3, L7_3 in L2_3, L3_3, L4_3, L5_3 do
      L8_3 = L0_2.recent
      L9_3 = L0_2.recent
      L9_3 = #L9_3
      L9_3 = L9_3 + 1
      L10_3 = {}
      L11_3 = tonumber
      L12_3 = L7_3.at
      L11_3 = L11_3(L12_3)
      if not L11_3 then
        L11_3 = 0
      end
      L10_3.at = L11_3
      L11_3 = L7_3.name
      L10_3.name = L11_3
      L11_3 = L7_3.item
      L10_3.item = L11_3
      L11_3 = L7_3.label
      if not L11_3 then
        L12_3 = L7_3.item
        L11_3 = L3_2
        L11_3 = L11_3[L12_3]
        if not L11_3 then
          L11_3 = L7_3.item
        end
      end
      L10_3.label = L11_3
      L11_3 = tonumber
      L12_3 = L7_3.price
      L11_3 = L11_3(L12_3)
      if not L11_3 then
        L11_3 = 0
      end
      L10_3.price = L11_3
      L11_3 = L7_3.account
      L10_3.account = L11_3
      L12_3 = L7_3.shop
      L11_3 = L4_2
      L11_3 = L11_3[L12_3]
      if not L11_3 then
        L11_3 = L7_3.shop
      end
      L10_3.shop = L11_3
      L8_3[L9_3] = L10_3
    end
  end
  L5_2(L6_2)
  return L0_2
end
ShopStats = L61_1
L61_1 = OVRPC
function L62_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L7_1
  L2_2 = L2_2[A0_2]
  if not L2_2 then
    L2_2 = {}
  end
  L3_2 = L7_1
  L3_2[A0_2] = L2_2
  L3_2 = GetGameTimer
  L3_2 = L3_2()
  L4_2 = L2_2.stateAt
  if L4_2 then
    L4_2 = L2_2.stateAt
    L4_2 = L3_2 - L4_2
    L5_2 = 250
    if L4_2 < L5_2 then
      L4_2 = L57_1
      L5_2 = "ratelimit"
      return L4_2(L5_2)
    end
  end
  L2_2.stateAt = L3_2
  L4_2 = L1_1
  if not L4_2 then
    L4_2 = L48_1
    L4_2 = L4_2()
    L1_1 = L4_2
    L4_2 = L49_1
    L4_2()
  end
  L4_2 = L1_1.enabled
  if false == L4_2 then
    L4_2 = L6_1
    L4_2 = L4_2[A0_2]
    if not L4_2 then
      L4_2 = L57_1
      L5_2 = "disabled"
      return L4_2(L5_2)
    end
  end
  L4_2 = ShopBridge
  L4_2 = L4_2.Ready
  L4_2 = L4_2()
  if not L4_2 then
    L4_2 = {}
    L4_2.ok = true
    L5_2 = {}
    L6_2 = {}
    L5_2.wallet = L6_2
    L6_2 = {}
    L5_2.owned = L6_2
    L6_2 = {}
    L5_2.available = L6_2
    L5_2.framework = false
    L4_2.state = L5_2
    return L4_2
  end
  L4_2 = {}
  L4_2.ok = true
  L5_2 = L56_1
  L6_2 = A0_2
  L5_2 = L5_2(L6_2)
  L4_2.state = L5_2
  return L4_2
end
L61_1["shop.state"] = L62_1
L61_1 = OVRPC
function L62_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  L2_2 = type
  L3_2 = A1_2.item
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L2_2 = A1_2.item
    if L2_2 then
      goto lbl_10
    end
  end
  L2_2 = ""
  ::lbl_10::
  L3_2 = type
  L4_2 = A1_2.account
  L3_2 = L3_2(L4_2)
  if "string" == L3_2 then
    L3_2 = A1_2.account
    if L3_2 then
      goto lbl_19
    end
  end
  L3_2 = ""
  ::lbl_19::
  L4_2 = type
  L5_2 = A1_2.shop
  L4_2 = L4_2(L5_2)
  if "string" == L4_2 then
    L4_2 = A1_2.shop
    if L4_2 then
      goto lbl_28
    end
  end
  L4_2 = ""
  ::lbl_28::
  L5_2 = L7_1
  L5_2 = L5_2[A0_2]
  if not L5_2 then
    L5_2 = {}
    L6_2 = {}
    L5_2.window = L6_2
  end
  L6_2 = L7_1
  L6_2[A0_2] = L5_2
  L6_2 = L5_2.window
  if not L6_2 then
    L6_2 = {}
  end
  L5_2.window = L6_2
  L6_2 = GetGameTimer
  L6_2 = L6_2()
  L7_2 = L1_1
  if L7_2 then
    L7_2 = L1_1.rateLimit
    if L7_2 then
      goto lbl_55
    end
  end
  L7_2 = {}
  ::lbl_55::
  L8_2 = L5_2.busy
  if L8_2 then
    L8_2 = L57_1
    L9_2 = "busy"
    return L8_2(L9_2)
  end
  L8_2 = L5_2.last
  if L8_2 then
    L8_2 = L5_2.last
    L8_2 = L6_2 - L8_2
    L9_2 = L7_2.cooldownMs
    if not L9_2 then
      L9_2 = 1500
    end
    if L8_2 < L9_2 then
      L8_2 = L57_1
      L9_2 = "cooldown"
      return L8_2(L9_2)
    end
  end
  L8_2 = {}
  L9_2 = ipairs
  L10_2 = L5_2.window
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
  for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
    L15_2 = L6_2 - L14_2
    L16_2 = 60000
    if L15_2 < L16_2 then
      L15_2 = #L8_2
      L15_2 = L15_2 + 1
      L8_2[L15_2] = L14_2
    end
  end
  L5_2.window = L8_2
  L9_2 = #L8_2
  L10_2 = L7_2.perMinute
  if not L10_2 then
    L10_2 = 8
  end
  if L9_2 >= L10_2 then
    L9_2 = L57_1
    L10_2 = "ratelimit"
    return L9_2(L10_2)
  end
  L9_2 = L1_1
  if not L9_2 then
    L9_2 = L57_1
    L10_2 = "server"
    return L9_2(L10_2)
  end
  L9_2 = L1_1.enabled
  if false == L9_2 then
    L9_2 = L57_1
    L10_2 = "disabled"
    return L9_2(L10_2)
  end
  L9_2 = ShopBridge
  L9_2 = L9_2.Ready
  L9_2 = L9_2()
  if not L9_2 then
    L9_2 = L57_1
    L10_2 = "no_framework"
    return L9_2(L10_2)
  end
  L9_2 = L2_1.byItem
  L9_2 = L9_2[L2_2]
  if not L9_2 then
    L10_2 = L57_1
    L11_2 = L2_1.off
    L11_2 = L11_2[L2_2]
    if L11_2 then
      L11_2 = "off_sale"
      if L11_2 then
        goto lbl_144
      end
    end
    L11_2 = "unknown_item"
    ::lbl_144::
    return L10_2(L11_2)
  end
  L10_2 = L5_1
  L10_2 = L10_2[L3_2]
  if not L10_2 then
    L10_2 = L57_1
    L11_2 = "bad_account"
    return L10_2(L11_2)
  end
  L10_2 = L54_1
  L11_2 = A0_2
  L12_2 = L4_2
  L10_2 = L10_2(L11_2, L12_2)
  if not L10_2 then
    L10_2 = L57_1
    L11_2 = "too_far"
    return L10_2(L11_2)
  end
  L10_2 = ShopBridge
  L10_2 = L10_2.HasPlayer
  L11_2 = A0_2
  L10_2 = L10_2(L11_2)
  if not L10_2 then
    L10_2 = L57_1
    L11_2 = "no_player"
    return L10_2(L11_2)
  end
  L10_2 = L3_1
  L11_2 = ShopBridge
  L11_2 = L11_2.ItemExists
  L12_2 = L2_2
  L11_2 = L11_2(L12_2)
  L10_2[L2_2] = L11_2
  L10_2 = L3_1
  L10_2 = L10_2[L2_2]
  if not L10_2 then
    L10_2 = L57_1
    L11_2 = "unavailable"
    return L10_2(L11_2)
  end
  L10_2 = L9_2.price
  L11_2 = ShopBridge
  L11_2 = L11_2.GetBalance
  L12_2 = A0_2
  L13_2 = L3_2
  L11_2 = L11_2(L12_2, L13_2)
  if not L11_2 then
    L12_2 = L57_1
    L13_2 = "no_player"
    return L12_2(L13_2)
  end
  if L10_2 > L11_2 then
    L12_2 = L57_1
    if "bank" == L3_2 then
      L13_2 = "no_money_bank"
      if L13_2 then
        goto lbl_209
      end
    end
    L13_2 = "no_money_cash"
    ::lbl_209::
    return L12_2(L13_2)
  end
  L12_2 = ShopBridge
  L12_2 = L12_2.CanCarry
  L13_2 = A0_2
  L14_2 = L2_2
  L15_2 = 1
  L12_2 = L12_2(L13_2, L14_2, L15_2)
  if not L12_2 then
    L12_2 = L57_1
    L13_2 = "no_space"
    return L12_2(L13_2)
  end
  L5_2.busy = true
  L12_2 = "%s \194\183 %s"
  L13_2 = L12_2
  L12_2 = L12_2.format
  L14_2 = L9_2.product
  L14_2 = L14_2.name
  if not L14_2 then
    L14_2 = L2_2
  end
  L15_2 = L9_2.variant
  L15_2 = L15_2.color
  if not L15_2 then
    L15_2 = ""
  end
  L12_2 = L12_2(L13_2, L14_2, L15_2)
  L13_2 = pcall
  function L14_2()
    local L0_3, L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    L0_3 = ShopBridge
    L0_3 = L0_3.RemoveMoney
    L1_3 = A0_2
    L2_3 = L3_2
    L3_3 = L10_2
    L4_3 = "apex_phone: loja %s"
    L5_3 = L4_3
    L4_3 = L4_3.format
    L6_3 = L2_2
    L4_3, L5_3, L6_3, L7_3 = L4_3(L5_3, L6_3)
    L0_3 = L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3)
    if not L0_3 then
      L0_3 = L57_1
      L1_3 = "payment_failed"
      return L0_3(L1_3)
    end
    L0_3 = ShopBridge
    L0_3 = L0_3.AddItem
    L1_3 = A0_2
    L2_3 = L2_2
    L3_3 = 1
    L0_3 = L0_3(L1_3, L2_3, L3_3)
    if not L0_3 then
      L0_3 = ShopBridge
      L0_3 = L0_3.AddMoney
      L1_3 = A0_2
      L2_3 = L3_2
      L3_3 = L10_2
      L4_3 = "apex_phone: reembolso %s"
      L5_3 = L4_3
      L4_3 = L4_3.format
      L6_3 = L2_2
      L4_3, L5_3, L6_3, L7_3 = L4_3(L5_3, L6_3)
      L0_3 = L0_3(L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3)
      L1_3 = ShopBridge
      L1_3 = L1_3.warn
      L2_3 = "delivery failed: %s (%d) %s \194\183 refund %s"
      L3_3 = L2_3
      L2_3 = L2_3.format
      L4_3 = ShopBridge
      L4_3 = L4_3.CharName
      L5_3 = A0_2
      L4_3 = L4_3(L5_3)
      L5_3 = A0_2
      L6_3 = L2_2
      if L0_3 then
        L7_3 = "done"
        if L7_3 then
          goto lbl_51
        end
      end
      L7_3 = "FAILED"
      ::lbl_51::
      L2_3, L3_3, L4_3, L5_3, L6_3, L7_3 = L2_3(L3_3, L4_3, L5_3, L6_3, L7_3)
      L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3)
      L1_3 = L57_1
      if L0_3 then
        L2_3 = "give_refunded"
        if L2_3 then
          goto lbl_60
        end
      end
      L2_3 = "give_lost"
      ::lbl_60::
      return L1_3(L2_3)
    end
    L0_3 = {}
    L0_3.ok = true
    return L0_3
  end
  L13_2, L14_2 = L13_2(L14_2)
  L5_2.busy = false
  if not L13_2 then
    L15_2 = ShopBridge
    L15_2 = L15_2.warn
    L16_2 = "error purchasing %s by %d: %s"
    L17_2 = L16_2
    L16_2 = L16_2.format
    L18_2 = L2_2
    L19_2 = A0_2
    L20_2 = tostring
    L21_2 = L14_2
    L20_2, L21_2, L22_2, L23_2 = L20_2(L21_2)
    L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
    L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
    L15_2 = L57_1
    L16_2 = "server"
    return L15_2(L16_2)
  end
  L15_2 = L14_2.ok
  if not L15_2 then
    return L14_2
  end
  L15_2 = GetGameTimer
  L15_2 = L15_2()
  L5_2.last = L15_2
  L15_2 = L5_2.window
  L16_2 = L5_2.window
  L16_2 = #L16_2
  L16_2 = L16_2 + 1
  L17_2 = L5_2.last
  L15_2[L16_2] = L17_2
  L15_2 = print
  L16_2 = "^2[unique_phone]^0 shop: purchase: %s (%d, %s) \194\183 %s \194\183 %s \194\183 %s"
  L17_2 = L16_2
  L16_2 = L16_2.format
  L18_2 = ShopBridge
  L18_2 = L18_2.CharName
  L19_2 = A0_2
  L18_2 = L18_2(L19_2)
  L19_2 = A0_2
  L20_2 = tostring
  L21_2 = ShopBridge
  L21_2 = L21_2.Identifier
  L22_2 = A0_2
  L21_2, L22_2, L23_2 = L21_2(L22_2)
  L20_2 = L20_2(L21_2, L22_2, L23_2)
  L21_2 = L2_2
  L22_2 = L19_1
  L23_2 = L10_2
  L22_2 = L22_2(L23_2)
  L23_2 = L3_2
  L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  L15_2 = L60_1
  L16_2 = A0_2
  L17_2 = L9_2
  L18_2 = L2_2
  L19_2 = L10_2
  L20_2 = L3_2
  L21_2 = L6_1
  L21_2 = L21_2[A0_2]
  if L21_2 and "" == L4_2 then
    L21_2 = "admin"
    if L21_2 then
      goto lbl_309
    end
  end
  L21_2 = L4_2
  ::lbl_309::
  L22_2 = L12_2
  L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2)
  L15_2 = L13_1.ok
  L16_2 = L15_2
  L15_2 = L15_2.format
  L17_2 = L12_2
  L18_2 = L19_1
  L19_2 = L10_2
  L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L18_2(L19_2)
  L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  L16_2 = ShopBridge
  L16_2 = L16_2.Notify
  L17_2 = A0_2
  L18_2 = L15_2
  L19_2 = "success"
  L16_2(L17_2, L18_2, L19_2)
  L16_2 = {}
  L16_2.ok = true
  L16_2.item = L2_2
  L16_2.label = L12_2
  L16_2.price = L10_2
  L16_2.account = L3_2
  L16_2.message = L15_2
  L17_2 = L56_1
  L18_2 = A0_2
  L17_2 = L17_2(L18_2)
  L16_2.state = L17_2
  return L16_2
end
L61_1["shop.buy"] = L62_1
L61_1 = OVRPC
function L62_1(A0_2)
  local L1_2, L2_2, L3_2
  if A0_2 <= 0 then
    L1_2 = {}
    L1_2.ok = false
    L1_2.error = "console"
    return L1_2
  end
  L1_2 = L6_1
  L1_2[A0_2] = true
  L1_2 = TriggerClientEvent
  L2_2 = "apex_phone:client:shopAdminOpen"
  L3_2 = A0_2
  L1_2(L2_2, L3_2)
  L1_2 = {}
  L1_2.ok = true
  return L1_2
end
L61_1["admin.shop.open"] = L62_1
L61_1 = OVRPC
function L62_1()
  local L0_2, L1_2, L2_2
  L0_2 = ShopBridge
  L0_2 = L0_2.Ready
  L0_2 = L0_2()
  if not L0_2 then
    L0_2 = {}
    L0_2.ok = false
    L0_2.error = "no_framework"
    L1_2 = L13_1.no_framework
    L0_2.message = L1_2
    return L0_2
  end
  L0_2 = L50_1
  L1_2 = true
  L0_2 = L0_2(L1_2)
  if not L0_2 then
    L0_2 = {}
  end
  L1_2 = {}
  L1_2.ok = true
  L1_2.missing = L0_2
  L2_2 = L2_1.items
  L2_2 = #L2_2
  L1_2.total = L2_2
  return L1_2
end
L61_1["admin.shop.recheck"] = L62_1
L61_1 = OVRPC
function L62_1()
  local L0_2, L1_2
  L0_2 = ShopStats
  L0_2 = L0_2()
  L0_2.ok = true
  return L0_2
end
L61_1["admin.shop.stats"] = L62_1
L61_1 = RegisterNetEvent
L62_1 = "apex_phone:server:shopClosed"
function L63_1()
  local L0_2, L1_2
  L1_2 = source
  L0_2 = L6_1
  L0_2[L1_2] = nil
end
L61_1(L62_1, L63_1)
L61_1 = AddEventHandler
L62_1 = "playerDropped"
function L63_1()
  local L0_2, L1_2
  L1_2 = source
  L0_2 = L7_1
  L0_2[L1_2] = nil
  L1_2 = source
  L0_2 = L6_1
  L0_2[L1_2] = nil
end
L61_1(L62_1, L63_1)
L61_1 = AdminStore
if L61_1 then
  L61_1 = AdminStore
  L61_1 = L61_1.OnChange
  if L61_1 then
    L61_1 = AdminStore
    L61_1 = L61_1.OnChange
    L62_1 = "shop"
    function L63_1()
      local L0_2, L1_2
      L0_2 = L52_1
      L0_2()
    end
    L61_1(L62_1, L63_1)
end
else
  L61_1 = L52_1
  L61_1()
end
L61_1 = RegisterCommand
L62_1 = "phoneshop_items"
function L63_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2
  if 0 ~= A0_2 then
    return
  end
  L1_2 = L50_1
  L2_2 = true
  L1_2 = L1_2(L2_2)
  if not L1_2 then
    L1_2 = {}
  end
  L2_2 = print
  L3_2 = "[unique_phone] shop: %d items in the catalog, %d missing from the inventory%s"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = L2_1.items
  L5_2 = #L5_2
  L6_2 = #L1_2
  L7_2 = #L1_2
  if L7_2 > 0 then
    L7_2 = ": "
    L8_2 = table
    L8_2 = L8_2.concat
    L9_2 = L1_2
    L10_2 = ", "
    L8_2 = L8_2(L9_2, L10_2)
    L7_2 = L7_2 .. L8_2
    if L7_2 then
      goto lbl_30
    end
  end
  L7_2 = ""
  ::lbl_30::
  L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2 = L3_2(L4_2, L5_2, L6_2, L7_2)
  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2)
end
L64_1 = true
L61_1(L62_1, L63_1, L64_1)
L61_1 = AddEventHandler
L62_1 = "onResourceStop"
function L63_1(A0_2)
  local L1_2, L2_2
  L1_2 = L0_1
  if A0_2 ~= L1_2 then
    return
  end
  L1_2 = {}
  L2_2 = {}
  L6_1 = L2_2
  L7_1 = L1_2
end
L61_1(L62_1, L63_1)
