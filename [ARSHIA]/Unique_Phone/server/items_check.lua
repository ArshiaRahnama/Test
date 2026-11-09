local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1
L0_1 = {}
L1_1 = "qb-inventory"
L2_1 = "ps-inventory"
L3_1 = "lj-inventory"
L4_1 = "qs-inventory"
L5_1 = "origen_inventory"
L6_1 = "codem-inventory"
L7_1 = "tgiann-inventory"
L8_1 = "core_inventory"
L0_1[1] = L1_1
L0_1[2] = L2_1
L0_1[3] = L3_1
L0_1[4] = L4_1
L0_1[5] = L5_1
L0_1[6] = L6_1
L0_1[7] = L7_1
L0_1[8] = L8_1
L1_1 = {}
L1_1.airpods = "airpods.png"
L1_1.slate_buds = "slate_buds.png"
L1_1.esim = "esim.png"
L1_1.sim_card = "sim_card.png"
function L2_1()
  local L0_2, L1_2
  L0_2 = type
  L1_2 = Config
  L1_2 = L1_2.InventoryImages
  L0_2 = L0_2(L1_2)
  if "table" == L0_2 then
    L0_2 = Config
    L0_2 = L0_2.InventoryImages
    if L0_2 then
      goto lbl_13
    end
  end
  L0_2 = {}
  ::lbl_13::
  return L0_2
end
function L3_1(A0_2)
  local L1_2, L2_2
  L1_2 = GetResourceState
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = "started" == L1_2 or "starting" == L1_2
  return L2_2
end
function L4_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L0_2 = L2_1
  L0_2 = L0_2()
  L1_2 = type
  L2_2 = L0_2.folder
  L1_2 = L1_2(L2_2)
  if "string" == L1_2 then
    L1_2 = L0_2.folder
    if "" ~= L1_2 then
      L1_2 = L0_2.folder
      L2_2 = L1_2
      L1_2 = L1_2.gsub
      L3_2 = "^/+"
      L4_2 = ""
      L1_2 = L1_2(L2_2, L3_2, L4_2)
      L2_2 = L1_2
      L1_2 = L1_2.gsub
      L3_2 = "/+$"
      L4_2 = ""
      L1_2 = L1_2(L2_2, L3_2, L4_2)
      if L1_2 then
        goto lbl_23
      end
    end
  end
  L1_2 = "html/images"
  ::lbl_23::
  L2_2 = type
  L3_2 = L0_2.resource
  L2_2 = L2_2(L3_2)
  if "string" == L2_2 then
    L2_2 = L0_2.resource
    if "" ~= L2_2 then
      L2_2 = L0_2.resource
      L3_2 = L1_2
      return L2_2, L3_2
    end
  end
  L2_2 = ipairs
  L3_2 = L0_1
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L3_1
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    if L8_2 then
      L8_2 = L7_2
      L9_2 = L1_2
      return L8_2, L9_2
    end
  end
  L2_2 = nil
  L3_2 = L1_2
  return L2_2, L3_2
end
function L5_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L0_2 = {}
  L1_2 = {}
  function L2_2(A0_3)
    local L1_3, L2_3
    L1_3 = type
    L2_3 = A0_3
    L1_3 = L1_3(L2_3)
    if "string" == L1_3 and "" ~= A0_3 then
      L1_3 = L1_2
      L1_3 = L1_3[A0_3]
      if not L1_3 then
        L1_3 = L1_2
        L1_3[A0_3] = true
        L1_3 = L0_2
        L1_3 = #L1_3
        L2_3 = L1_3 + 1
        L1_3 = L0_2
        L1_3[L2_3] = A0_3
      end
    end
  end
  L3_2 = {}
  L4_2 = pairs
  L5_2 = Config
  L5_2 = L5_2.Devices
  if not L5_2 then
    L5_2 = {}
  end
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = type
    L11_2 = L9_2
    L10_2 = L10_2(L11_2)
    if "table" == L10_2 then
      L10_2 = L9_2.legacy
      if L10_2 then
        goto lbl_29
      end
    end
    L10_2 = #L3_2
    L10_2 = L10_2 + 1
    L3_2[L10_2] = L8_2
    ::lbl_29::
  end
  L4_2 = table
  L4_2 = L4_2.sort
  L5_2 = L3_2
  L4_2(L5_2)
  L4_2 = ipairs
  L5_2 = L3_2
  L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2)
  for L8_2, L9_2 in L4_2, L5_2, L6_2, L7_2 do
    L10_2 = L2_2
    L11_2 = L9_2
    L10_2(L11_2)
  end
  L4_2 = L2_2
  L5_2 = Config
  L5_2 = L5_2.EarbudsItem
  L4_2(L5_2)
  L4_2 = type
  L5_2 = Config
  L5_2 = L5_2.SlateBuds
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = L2_2
    L5_2 = Config
    L5_2 = L5_2.SlateBuds
    L5_2 = L5_2.item
    L4_2(L5_2)
  end
  L4_2 = type
  L5_2 = Config
  L5_2 = L5_2.Sim
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = L2_2
    L5_2 = Config
    L5_2 = L5_2.Sim
    L5_2 = L5_2.item
    L4_2(L5_2)
  end
  L4_2 = type
  L5_2 = Config
  L5_2 = L5_2.PhysicalSim
  L4_2 = L4_2(L5_2)
  if "table" == L4_2 then
    L4_2 = Config
    L4_2 = L4_2.PhysicalSim
    L4_2 = L4_2.enabled
    if L4_2 then
      L4_2 = L2_2
      L5_2 = Config
      L5_2 = L5_2.PhysicalSim
      L5_2 = L5_2.item
      L4_2(L5_2)
    end
  end
  L4_2 = L2_2
  L5_2 = Config
  L5_2 = L5_2.PhoneItem
  L4_2(L5_2)
  return L0_2
end
function L6_1(A0_2)
  local L1_2, L2_2
  L1_2 = L1_1
  L1_2 = L1_2[A0_2]
  if not L1_2 then
    L1_2 = A0_2
    L2_2 = ".png"
    L1_2 = L1_2 .. L2_2
  end
  return L1_2
end
function L7_1()
  local L0_2, L1_2, L2_2, L3_2
  L0_2 = FW
  L0_2 = L0_2.name
  if "qb" == L0_2 then
    L0_2 = FW
    L0_2 = L0_2.GetCore
    if L0_2 then
      L0_2 = FW
      L0_2 = L0_2.GetCore
      L0_2 = L0_2()
    end
    L1_2 = type
    L2_2 = L0_2
    L1_2 = L1_2(L2_2)
    if "table" == L1_2 then
      L1_2 = type
      L2_2 = L0_2.Shared
      L1_2 = L1_2(L2_2)
      if "table" == L1_2 then
        L1_2 = type
        L2_2 = L0_2.Shared
        L2_2 = L2_2.Items
        L1_2 = L1_2(L2_2)
        if "table" == L1_2 then
          L1_2 = L0_2.Shared
          L1_2 = L1_2.Items
          return L1_2
        end
      end
    end
    L1_2 = nil
    return L1_2
  end
  L0_2 = FW
  L0_2 = L0_2.name
  if "qbx" == L0_2 then
    L0_2 = pcall
    function L1_2()
      local L0_3, L1_3
      L0_3 = exports
      L0_3 = L0_3.qbx_core
      L1_3 = L0_3
      L0_3 = L0_3.GetItems
      return L0_3(L1_3)
    end
    L0_2, L1_2 = L0_2(L1_2)
    if L0_2 then
      L2_2 = type
      L3_2 = L1_2
      L2_2 = L2_2(L3_2)
      if "table" == L2_2 then
        return L1_2
      end
    end
  end
  L0_2 = nil
  return L0_2
end
function L8_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2
  L0_2 = {}
  function L1_2(A0_3, A1_3)
    local L2_3, L3_3, L4_3
    L2_3 = L0_2
    L2_3 = #L2_3
    L3_3 = L2_3 + 1
    L2_3 = L0_2
    L4_3 = {}
    L4_3.level = A0_3
    L4_3.msg = A1_3
    L2_3[L3_3] = L4_3
  end
  L2_2 = FW
  L2_2 = L2_2.name
  if "qb" ~= L2_2 then
    L2_2 = FW
    L2_2 = L2_2.name
    if "qbx" ~= L2_2 then
      L2_2 = L1_2
      L3_2 = "info"
      L4_2 = "framework %s: the items live in the inventory / framework (nothing to check here; see inventory_items.lua and ITENS_OX_INVENTORY.md)"
      L5_2 = L4_2
      L4_2 = L4_2.format
      L6_2 = tostring
      L7_2 = FW
      L7_2 = L7_2.name
      L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2 = L6_2(L7_2)
      L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2 = L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2)
      L2_2(L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2)
      return L0_2
    end
  end
  L2_2 = FW
  L2_2 = L2_2.InventoryName
  L2_2 = L2_2()
  if "ox_inventory" == L2_2 then
    L2_2 = L1_2
    L3_2 = "info"
    L4_2 = "ox_inventory is in use: the items come from ox_inventory/data/items.lua (copy inventory_items.lua there) and the images are served by Unique_Phone itself; nothing to copy"
    L2_2(L3_2, L4_2)
    return L0_2
  end
  L2_2 = L7_1
  L2_2 = L2_2()
  if not L2_2 then
    L3_2 = L1_2
    L4_2 = "warn"
    L5_2 = "could not read the shared items list of the framework (qb-core Shared.Items); add the items of installation/qb-core_items.lua by hand"
    L3_2(L4_2, L5_2)
    return L0_2
  end
  L3_2 = L4_1
  L3_2, L4_2 = L3_2()
  L5_2 = L2_1
  L5_2 = L5_2()
  L5_2 = L5_2.autoCopy
  L5_2 = false ~= L5_2
  L6_2 = L5_1
  L6_2 = L6_2()
  L7_2 = {}
  L8_2 = {}
  L9_2 = 0
  L10_2 = ipairs
  L11_2 = L6_2
  L10_2, L11_2, L12_2, L13_2 = L10_2(L11_2)
  for L14_2, L15_2 in L10_2, L11_2, L12_2, L13_2 do
    L16_2 = L2_2[L15_2]
    L17_2 = type
    L18_2 = L16_2
    L17_2 = L17_2(L18_2)
    if "table" ~= L17_2 then
      L17_2 = #L7_2
      L17_2 = L17_2 + 1
      L7_2[L17_2] = L15_2
    else
      L17_2 = true
      L18_2 = L16_2.useable
      if false == L18_2 then
        L17_2 = false
        L18_2 = L1_2
        L19_2 = "warn"
        L20_2 = "item %s has useable = false in qb-core/shared/items.lua: the inventory never 'uses' it, so it cannot open the phone (set useable = true)"
        L21_2 = L20_2
        L20_2 = L20_2.format
        L22_2 = L15_2
        L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2 = L20_2(L21_2, L22_2)
        L18_2(L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2)
      end
      L18_2 = type
      L19_2 = L16_2.image
      L18_2 = L18_2(L19_2)
      if "string" == L18_2 then
        L18_2 = L16_2.image
        if L18_2 then
          goto lbl_94
        end
      end
      L18_2 = ""
      ::lbl_94::
      if "" == L18_2 then
        L17_2 = false
        L19_2 = L1_2
        L20_2 = "warn"
        L21_2 = "item %s has no image in qb-core/shared/items.lua: set image = '%s' and copy Unique_Phone/inventory_images/%s into %s/%s/"
        L22_2 = L21_2
        L21_2 = L21_2.format
        L23_2 = L15_2
        L24_2 = L6_1
        L25_2 = L15_2
        L24_2 = L24_2(L25_2)
        L25_2 = L6_1
        L26_2 = L15_2
        L25_2 = L25_2(L26_2)
        L26_2 = L3_2 or L26_2
        if not L3_2 then
          L26_2 = "qb-inventory"
        end
        L27_2 = L4_2
        L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2 = L21_2(L22_2, L23_2, L24_2, L25_2, L26_2, L27_2)
        L19_2(L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2)
      else
        L20_2 = L18_2
        L19_2 = L18_2.find
        L21_2 = "^%a+://"
        L19_2 = L19_2(L20_2, L21_2)
        if L19_2 then
          L17_2 = false
          L19_2 = L1_2
          L20_2 = "warn"
          L21_2 = "item %s: image = '%s'. qb-inventory and its forks build the icon path themselves (images/<file name>) and show a blank slot for an address. Set image = '%s' in qb-core/shared/items.lua and copy Unique_Phone/inventory_images/%s into %s/%s/ (the phone copies it for you on the next start once the image is a file name)"
          L22_2 = L21_2
          L21_2 = L21_2.format
          L23_2 = L15_2
          L24_2 = L18_2
          L25_2 = L6_1
          L26_2 = L15_2
          L25_2 = L25_2(L26_2)
          L26_2 = L6_1
          L27_2 = L15_2
          L26_2 = L26_2(L27_2)
          L27_2 = L3_2 or L27_2
          if not L3_2 then
            L27_2 = "qb-inventory"
          end
          L28_2 = L4_2
          L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2 = L21_2(L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2)
          L19_2(L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2)
        elseif L3_2 then
          L19_2 = LoadResourceFile
          L20_2 = L3_2
          L21_2 = L4_2
          L22_2 = "/"
          L23_2 = L18_2
          L21_2 = L21_2 .. L22_2 .. L23_2
          L19_2 = L19_2(L20_2, L21_2)
          if not L19_2 or "" == L19_2 then
            L20_2 = GetCurrentResourceName
            L20_2 = L20_2()
            L21_2 = LoadResourceFile
            L22_2 = L20_2
            L23_2 = "inventory_images/"
            L24_2 = L6_1
            L25_2 = L15_2
            L24_2 = L24_2(L25_2)
            L23_2 = L23_2 .. L24_2
            L21_2 = L21_2(L22_2, L23_2)
            if not L21_2 or "" == L21_2 then
              L22_2 = L6_1
              L23_2 = L15_2
              L22_2 = L22_2(L23_2)
              if L18_2 ~= L22_2 then
                L22_2 = LoadResourceFile
                L23_2 = L20_2
                L24_2 = "inventory_images/"
                L25_2 = L18_2
                L24_2 = L24_2 .. L25_2
                L22_2 = L22_2(L23_2, L24_2)
                L21_2 = L22_2
              end
            end
            if L21_2 and "" ~= L21_2 and L5_2 then
              L22_2 = pcall
              L23_2 = SaveResourceFile
              L24_2 = L3_2
              L25_2 = L4_2
              L26_2 = "/"
              L27_2 = L18_2
              L25_2 = L25_2 .. L26_2 .. L27_2
              L26_2 = L21_2
              L27_2 = -1
              L22_2 = L22_2(L23_2, L24_2, L25_2, L26_2, L27_2)
              L23_2 = L22_2 or L23_2
              if L22_2 then
                L23_2 = LoadResourceFile
                L24_2 = L3_2
                L25_2 = L4_2
                L26_2 = "/"
                L27_2 = L18_2
                L25_2 = L25_2 .. L26_2 .. L27_2
                L23_2 = L23_2(L24_2, L25_2)
              end
              if L23_2 and "" ~= L23_2 then
                L24_2 = #L8_2
                L24_2 = L24_2 + 1
                L8_2[L24_2] = L18_2
              else
                L17_2 = false
                L24_2 = L1_2
                L25_2 = "warn"
                L26_2 = "item %s: %s/%s/%s is missing and could not be written there (folder missing or read-only): copy Unique_Phone/inventory_images/%s by hand"
                L27_2 = L26_2
                L26_2 = L26_2.format
                L28_2 = L15_2
                L29_2 = L3_2
                L30_2 = L4_2
                L31_2 = L18_2
                L32_2 = L6_1
                L33_2 = L15_2
                L32_2, L33_2 = L32_2(L33_2)
                L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2 = L26_2(L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2)
                L24_2(L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2)
              end
            elseif L21_2 and "" ~= L21_2 then
              L17_2 = false
              L22_2 = L1_2
              L23_2 = "warn"
              L24_2 = "item %s: %s/%s/%s is missing: copy Unique_Phone/inventory_images/%s there (or set Config.InventoryImages.autoCopy = true)"
              L25_2 = L24_2
              L24_2 = L24_2.format
              L26_2 = L15_2
              L27_2 = L3_2
              L28_2 = L4_2
              L29_2 = L18_2
              L30_2 = L6_1
              L31_2 = L15_2
              L30_2, L31_2, L32_2, L33_2 = L30_2(L31_2)
              L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2 = L24_2(L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2)
              L22_2(L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2)
            else
              L17_2 = false
              L22_2 = L1_2
              L23_2 = "warn"
              L24_2 = "item %s: %s/%s/%s is missing and Unique_Phone has no inventory_images/%s to copy: pick one of the PNGs in Unique_Phone/inventory_images/ as the item image"
              L25_2 = L24_2
              L24_2 = L24_2.format
              L26_2 = L15_2
              L27_2 = L3_2
              L28_2 = L4_2
              L29_2 = L18_2
              L30_2 = L18_2
              L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2 = L24_2(L25_2, L26_2, L27_2, L28_2, L29_2, L30_2)
              L22_2(L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2)
            end
          end
        end
      end
      if L17_2 then
        L9_2 = L9_2 + 1
      end
    end
  end
  L10_2 = #L7_2
  if L10_2 > 0 then
    L10_2 = L1_2
    L11_2 = "warn"
    L12_2 = "%d phone item(s) are not in qb-core/shared/items.lua: %s. Paste the entries of Unique_Phone/installation/qb-core_items.lua into that file and restart qb-core (or the server)."
    L13_2 = L12_2
    L12_2 = L12_2.format
    L14_2 = #L7_2
    L15_2 = table
    L15_2 = L15_2.concat
    L16_2 = L7_2
    L17_2 = ", "
    L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2 = L15_2(L16_2, L17_2)
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2)
    L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2)
  end
  L10_2 = #L8_2
  if L10_2 > 0 then
    L10_2 = L1_2
    L11_2 = "ok"
    L12_2 = "copied %d item image(s) into %s/%s/ from Unique_Phone/inventory_images/: %s. Run `restart %s` once so it serves them."
    L13_2 = L12_2
    L12_2 = L12_2.format
    L14_2 = #L8_2
    L15_2 = L3_2
    L16_2 = L4_2
    L17_2 = table
    L17_2 = L17_2.concat
    L18_2 = L8_2
    L19_2 = ", "
    L17_2 = L17_2(L18_2, L19_2)
    L18_2 = L3_2
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2 = L12_2(L13_2, L14_2, L15_2, L16_2, L17_2, L18_2)
    L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2)
  end
  if not L3_2 then
    L10_2 = L1_2
    L11_2 = "info"
    L12_2 = "no qb-style inventory resource detected ("
    L13_2 = table
    L13_2 = L13_2.concat
    L14_2 = L0_1
    L15_2 = ", "
    L13_2 = L13_2(L14_2, L15_2)
    L14_2 = "): the item images were not checked. Set Config.InventoryImages.resource to the name of your inventory resource."
    L12_2 = L12_2 .. L13_2 .. L14_2
    L10_2(L11_2, L12_2)
  end
  L10_2 = #L7_2
  if 0 == L10_2 then
    L10_2 = #L0_2
    if 0 == L10_2 then
      L10_2 = L1_2
      L11_2 = "ok"
      L12_2 = "all %d phone items exist in qb-core/shared/items.lua with their images in %s/%s/"
      L13_2 = L12_2
      L12_2 = L12_2.format
      L14_2 = #L6_2
      L15_2 = L3_2 or L15_2
      if not L3_2 then
        L15_2 = "?"
      end
      L16_2 = L4_2
      L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2 = L12_2(L13_2, L14_2, L15_2, L16_2)
      L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2)
  end
  elseif L9_2 > 0 then
    L10_2 = #L7_2
    if not (L10_2 > 0) then
      L10_2 = #L8_2
      if not (L10_2 > 0) then
        goto lbl_346
      end
    end
    L10_2 = L1_2
    L11_2 = "info"
    L12_2 = "%d of %d phone items are complete"
    L13_2 = L12_2
    L12_2 = L12_2.format
    L14_2 = L9_2
    L15_2 = #L6_2
    L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2 = L12_2(L13_2, L14_2, L15_2)
    L10_2(L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2, L24_2, L25_2, L26_2, L27_2, L28_2, L29_2, L30_2, L31_2, L32_2, L33_2)
  end
  ::lbl_346::
  return L0_2
end
CheckInventoryItems = L8_1
L8_1 = {}
L8_1.ok = "^2"
L8_1.info = "^5"
L8_1.warn = "^3"
function L9_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = ipairs
  L3_2 = A0_2
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = print
    L9_2 = "%s[unique_phone]^0 items: %s"
    L10_2 = L9_2
    L9_2 = L9_2.format
    L12_2 = L7_2.level
    L11_2 = L8_1
    L11_2 = L11_2[L12_2]
    if not L11_2 then
      L11_2 = "^0"
    end
    L12_2 = L7_2.msg
    L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2, L11_2, L12_2)
    L8_2(L9_2, L10_2, L11_2, L12_2)
  end
  if A1_2 and A1_2 > 0 then
    L2_2 = FW
    L2_2 = L2_2.Notify
    if L2_2 then
      L2_2 = 0
      L3_2 = ipairs
      L4_2 = A0_2
      L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
      for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
        L9_2 = L8_2.level
        if "warn" == L9_2 then
          L2_2 = L2_2 + 1
        end
      end
      L3_2 = FW
      L3_2 = L3_2.Notify
      L4_2 = A1_2
      if 0 == L2_2 then
        L5_2 = "Itens do telem\195\179vel: tudo certo (ver consola do servidor)."
        if L5_2 then
          goto lbl_53
        end
      end
      L5_2 = "Itens do telem\195\179vel: %d aviso(s), ver consola do servidor."
      L6_2 = L5_2
      L5_2 = L5_2.format
      L7_2 = L2_2
      L5_2 = L5_2(L6_2, L7_2)
      ::lbl_53::
      if 0 == L2_2 then
        L6_2 = "success"
        if L6_2 then
          goto lbl_59
        end
      end
      L6_2 = "error"
      ::lbl_59::
      L3_2(L4_2, L5_2, L6_2)
    end
  end
end
L10_1 = CreateThread
function L11_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L0_2 = 0
  while true do
    L1_2 = FW
    L1_2 = L1_2.ready
    if L1_2 then
      break
    end
    L1_2 = 600
    if not (L0_2 < L1_2) then
      break
    end
    L1_2 = Wait
    L2_2 = 1000
    L1_2(L2_2)
    L0_2 = L0_2 + 1
  end
  L1_2 = FW
  L1_2 = L1_2.ready
  if not L1_2 then
    return
  end
  L1_2 = Wait
  L2_2 = 8000
  L1_2(L2_2)
  L1_2 = FW
  L1_2 = L1_2.name
  if "qb" ~= L1_2 then
    L1_2 = FW
    L1_2 = L1_2.name
    if "qbx" ~= L1_2 then
      return
    end
  end
  L1_2 = FW
  L1_2 = L1_2.InventoryName
  L1_2 = L1_2()
  if "ox_inventory" == L1_2 then
    return
  end
  L1_2 = pcall
  L2_2 = CheckInventoryItems
  L1_2, L2_2 = L1_2(L2_2)
  if L1_2 then
    L3_2 = L9_1
    L4_2 = L2_2
    L3_2(L4_2)
  else
    L3_2 = print
    L4_2 = "^3[unique_phone]^0 items: the item check failed: %s"
    L5_2 = L4_2
    L4_2 = L4_2.format
    L6_2 = tostring
    L7_2 = L2_2
    L6_2, L7_2 = L6_2(L7_2)
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2)
    L3_2(L4_2, L5_2, L6_2, L7_2)
  end
end
L10_1(L11_1)
L10_1 = FW
L10_1 = L10_1.AddCommand
L11_1 = "phoneitems"
L12_1 = "Verificar os itens do telem\195\179vel no invent\195\161rio (admin)"
L13_1 = {}
function L14_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = pcall
  L2_2 = CheckInventoryItems
  L1_2, L2_2 = L1_2(L2_2)
  if L1_2 then
    L3_2 = L9_1
    L4_2 = L2_2
    L5_2 = A0_2
    L3_2(L4_2, L5_2)
  else
    L3_2 = print
    L4_2 = "^3[unique_phone]^0 items: the item check failed: %s"
    L5_2 = L4_2
    L4_2 = L4_2.format
    L6_2 = tostring
    L7_2 = L2_2
    L6_2, L7_2 = L6_2(L7_2)
    L4_2, L5_2, L6_2, L7_2 = L4_2(L5_2, L6_2, L7_2)
    L3_2(L4_2, L5_2, L6_2, L7_2)
  end
end
L15_1 = "admin"
L10_1(L11_1, L12_1, L13_1, L14_1, L15_1)
