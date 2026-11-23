local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1, L11_1, L12_1, L13_1, L14_1, L15_1
L0_1 = Store
if not L0_1 then
  L0_1 = {}
end
Store = L0_1
L0_1 = Store
L0_1.Ready = false
L0_1 = GetCurrentResourceName
L0_1 = L0_1()
L1_1 = "data/index.json"
L2_1 = {}
L2_1.nextId = 1
L3_1 = {}
L2_1.projects = L3_1
L3_1 = {}
L2_1.shares = L3_1
function L3_1()
  local L0_2, L1_2
end
function L4_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2, L5_2
  L0_2 = json
  L0_2 = L0_2.encode
  L1_2 = L2_1
  L0_2 = L0_2(L1_2)
  L1_2 = SaveResourceFile
  L2_2 = L0_1
  L3_2 = L1_1
  L4_2 = L0_2
  L5_2 = #L0_2
  L1_2(L2_2, L3_2, L4_2, L5_2)
end
function L5_1()
  local L0_2, L1_2
  L0_2 = os
  L0_2 = L0_2.date
  L1_2 = "!%Y-%m-%dT%H:%M:%SZ"
  return L0_2(L1_2)
end
L6_1 = CreateThread
function L7_1()
  local L0_2, L1_2, L2_2, L3_2, L4_2
  L0_2 = L3_1
  L0_2()
  L0_2 = LoadResourceFile
  L1_2 = L0_1
  L2_2 = L1_1
  L0_2 = L0_2(L1_2, L2_2)
  if L0_2 and "" ~= L0_2 then
    L1_2 = pcall
    L2_2 = json
    L2_2 = L2_2.decode
    L3_2 = L0_2
    L1_2, L2_2 = L1_2(L2_2, L3_2)
    if L1_2 then
      L3_2 = type
      L4_2 = L2_2
      L3_2 = L3_2(L4_2)
      if "table" == L3_2 then
        L3_2 = L2_2.nextId
        if not L3_2 then
          L3_2 = 1
        end
        L2_1.nextId = L3_2
        L3_2 = L2_2.projects
        if not L3_2 then
          L3_2 = {}
        end
        L2_1.projects = L3_2
        L3_2 = L2_2.shares
        if not L3_2 then
          L3_2 = {}
        end
        L2_1.shares = L3_2
      end
    end
  end
  L1_2 = Store
  L1_2.Ready = true
  L1_2 = Utils
  L1_2 = L1_2.Log
  L2_2 = "file store ready - %d project(s)"
  L3_2 = L2_2
  L2_2 = L2_2.format
  L4_2 = L2_1.projects
  L4_2 = #L4_2
  L2_2, L3_2, L4_2 = L2_2(L3_2, L4_2)
  L1_2(L2_2, L3_2, L4_2)
end
L6_1(L7_1)
function L6_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = ipairs
  L2_2 = L2_1.projects
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
function L7_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = type
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if "string" ~= L1_2 or "" == A0_2 then
    L1_2 = nil
    return L1_2
  end
  L1_2 = pcall
  L2_2 = json
  L2_2 = L2_2.decode
  L3_2 = A0_2
  L1_2, L2_2 = L1_2(L2_2, L3_2)
  if L1_2 then
    L3_2 = type
    L4_2 = L2_2
    L3_2 = L3_2(L4_2)
    if "table" == L3_2 then
      return L2_2
    end
  end
  L3_2 = nil
  return L3_2
end
function L8_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = {}
  L3_2 = A0_2.id
  L2_2.id = L3_2
  L3_2 = A0_2.name
  L2_2.name = L3_2
  L3_2 = A0_2.ped_model
  L2_2.ped_model = L3_2
  L3_2 = L7_1
  L4_2 = A0_2.context
  L3_2 = L3_2(L4_2)
  L2_2.context = L3_2
  L3_2 = A0_2.thumb
  L2_2.thumb = L3_2
  L3_2 = A0_2.share_code
  L2_2.share_code = L3_2
  L3_2 = A0_2.updated_at
  L2_2.updated_at = L3_2
  L3_2 = A0_2.public
  if L3_2 then
    L3_2 = true
    if L3_2 then
      goto lbl_26
    end
  end
  L3_2 = false
  ::lbl_26::
  L2_2.public = L3_2
  if A1_2 then
    L3_2 = A0_2.owner_name
    L2_2.owner_name = L3_2
  end
  return L2_2
end
L9_1 = Store
function L10_1(A0_2)
  local L1_2, L2_2
  L1_2 = L6_1
  L2_2 = A0_2
  return L1_2(L2_2)
end
L9_1.Get = L10_1
L9_1 = Store
function L10_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = LoadResourceFile
  L2_2 = L0_1
  L3_2 = "data/state/%d.txt"
  L4_2 = L3_2
  L3_2 = L3_2.format
  L5_2 = A0_2
  L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
  L1_2 = L1_2(L2_2, L3_2, L4_2, L5_2)
  if not L1_2 then
    L1_2 = ""
  end
  return L1_2
end
L9_1.LoadState = L10_1
L9_1 = Store
function L10_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  if not A0_2 then
    L2_2 = false
    return L2_2
  end
  L2_2 = A0_2.owner
  if L2_2 == A1_2 then
    L2_2 = true
    return L2_2
  end
  L2_2 = A0_2.public
  if L2_2 then
    L2_2 = true
    return L2_2
  end
  L2_2 = ipairs
  L3_2 = L2_1.shares
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.project_id
    L9_2 = A0_2.id
    if L8_2 == L9_2 then
      L8_2 = L7_2.identifier
      if L8_2 == A1_2 then
        L8_2 = true
        return L8_2
      end
    end
  end
  L2_2 = false
  return L2_2
end
L9_1.CanRead = L10_1
L9_1 = Store
function L10_1(A0_2, A1_2, A2_2, A3_2, A4_2, A5_2, A6_2, A7_2)
  local L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L8_2 = L3_1
  L8_2()
  L8_2 = nil
  if A2_2 then
    L9_2 = L6_1
    L10_2 = A2_2
    L9_2 = L9_2(L10_2)
    if L9_2 then
      L10_2 = L9_2.owner
      if L10_2 == A0_2 then
        L8_2 = L9_2
      end
    end
  end
  if not L8_2 then
    L9_2 = {}
    L10_2 = L2_1.nextId
    L9_2.id = L10_2
    L9_2.owner = A0_2
    L10_2 = A1_2 or L10_2
    if not A1_2 then
      L10_2 = ""
    end
    L9_2.owner_name = L10_2
    L9_2.public = false
    L8_2 = L9_2
    L9_2 = L2_1.nextId
    L9_2 = L9_2 + 1
    L2_1.nextId = L9_2
    L9_2 = L2_1.projects
    L10_2 = L2_1.projects
    L10_2 = #L10_2
    L10_2 = L10_2 + 1
    L9_2[L10_2] = L8_2
  end
  L8_2.name = A3_2
  L8_2.ped_model = A4_2
  L8_2.context = A5_2
  L8_2.thumb = A7_2
  L9_2 = L5_1
  L9_2 = L9_2()
  L8_2.updated_at = L9_2
  L9_2 = SaveResourceFile
  L10_2 = L0_1
  L11_2 = "data/state/%d.txt"
  L12_2 = L11_2
  L11_2 = L11_2.format
  L13_2 = L8_2.id
  L11_2 = L11_2(L12_2, L13_2)
  L12_2 = A6_2
  L13_2 = #A6_2
  L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
  if not L9_2 then
    L9_2 = nil
    return L9_2
  end
  L9_2 = L4_1
  L9_2()
  L9_2 = L8_2.id
  return L9_2
end
L9_1.Save = L10_1
function L9_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2
  L2_2 = tostring
  L3_2 = A0_2.updated_at
  L2_2 = L2_2(L3_2)
  L3_2 = tostring
  L4_2 = A1_2.updated_at
  L3_2 = L3_2(L4_2)
  L2_2 = L2_2 > L3_2
  return L2_2
end
L10_1 = Store
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = L2_1.projects
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.owner
    if L8_2 == A0_2 then
      L8_2 = #L1_2
      L8_2 = L8_2 + 1
      L9_2 = L8_1
      L10_2 = L7_2
      L11_2 = false
      L9_2 = L9_2(L10_2, L11_2)
      L1_2[L8_2] = L9_2
    end
  end
  L2_2 = table
  L2_2 = L2_2.sort
  L3_2 = L1_2
  L4_2 = L9_1
  L2_2(L3_2, L4_2)
  return L1_2
end
L10_1.ListMine = L11_1
L10_1 = Store
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = L2_1.shares
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.identifier
    if L8_2 == A0_2 then
      L8_2 = L7_2.project_id
      L1_2[L8_2] = true
    end
  end
  L2_2 = {}
  L3_2 = ipairs
  L4_2 = L2_1.projects
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.id
    L9_2 = L1_2[L9_2]
    if L9_2 then
      L9_2 = L8_2.owner
      if L9_2 ~= A0_2 then
        L9_2 = #L2_2
        L9_2 = L9_2 + 1
        L10_2 = L8_1
        L11_2 = L8_2
        L12_2 = true
        L10_2 = L10_2(L11_2, L12_2)
        L2_2[L9_2] = L10_2
      end
    end
  end
  L3_2 = table
  L3_2 = L3_2.sort
  L4_2 = L2_2
  L5_2 = L9_1
  L3_2(L4_2, L5_2)
  return L2_2
end
L10_1.ListShared = L11_1
L10_1 = Store
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L1_2 = {}
  L2_2 = ipairs
  L3_2 = L2_1.projects
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.public
    if L8_2 then
      L8_2 = #L1_2
      L8_2 = L8_2 + 1
      L9_2 = L8_1
      L10_2 = L7_2
      L11_2 = true
      L9_2 = L9_2(L10_2, L11_2)
      L1_2[L8_2] = L9_2
    end
  end
  L2_2 = table
  L2_2 = L2_2.sort
  L3_2 = L1_2
  L4_2 = L9_1
  L2_2(L3_2, L4_2)
  if not A0_2 then
    A0_2 = 60
  end
  while true do
    L2_2 = #L1_2
    if not (A0_2 < L2_2) then
      break
    end
    L2_2 = table
    L2_2 = L2_2.remove
    L3_2 = L1_2
    L2_2(L3_2)
  end
  return L1_2
end
L10_1.ListPublic = L11_1
L10_1 = Store
function L11_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2
  L2_2 = ipairs
  L3_2 = L2_1.projects
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L7_2.id
    if L8_2 == A0_2 then
      L8_2 = L7_2.owner
      if L8_2 == A1_2 then
        L8_2 = table
        L8_2 = L8_2.remove
        L9_2 = L2_1.projects
        L10_2 = L6_2
        L8_2(L9_2, L10_2)
        L8_2 = L2_1.shares
        L8_2 = #L8_2
        L9_2 = 1
        L10_2 = -1
        for L11_2 = L8_2, L9_2, L10_2 do
          L12_2 = L2_1.shares
          L12_2 = L12_2[L11_2]
          L12_2 = L12_2.project_id
          if L12_2 == A0_2 then
            L12_2 = table
            L12_2 = L12_2.remove
            L13_2 = L2_1.shares
            L14_2 = L11_2
            L12_2(L13_2, L14_2)
          end
        end
        L8_2 = pcall
        function L9_2()
          local L0_3, L1_3, L2_3, L3_3, L4_3
          L0_3 = SaveResourceFile
          L1_3 = L0_1
          L2_3 = "data/state/%d.txt"
          L3_3 = L2_3
          L2_3 = L2_3.format
          L4_3 = A0_2
          L2_3 = L2_3(L3_3, L4_3)
          L3_3 = ""
          L4_3 = 0
          L0_3(L1_3, L2_3, L3_3, L4_3)
        end
        L8_2(L9_2)
        L8_2 = L4_1
        L8_2()
        L8_2 = true
        return L8_2
      end
    end
  end
  L2_2 = false
  return L2_2
end
L10_1.Delete = L11_1
L10_1 = Store
function L11_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2
  L3_2 = L6_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = L3_2.owner
    if L4_2 == A1_2 then
      goto lbl_11
    end
  end
  L4_2 = false
  do return L4_2 end
  ::lbl_11::
  L3_2.name = A2_2
  L4_2 = L5_1
  L4_2 = L4_2()
  L3_2.updated_at = L4_2
  L4_2 = L4_1
  L4_2()
  L4_2 = true
  return L4_2
end
L10_1.Rename = L11_1
L10_1 = Store
function L11_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2
  L3_2 = L6_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if L3_2 then
    L4_2 = L3_2.owner
    if L4_2 == A1_2 then
      goto lbl_11
    end
  end
  L4_2 = false
  do return L4_2 end
  ::lbl_11::
  if A2_2 then
    L4_2 = true
    if L4_2 then
      goto lbl_17
    end
  end
  L4_2 = false
  ::lbl_17::
  L3_2.public = L4_2
  L4_2 = L4_1
  L4_2()
  L4_2 = true
  return L4_2
end
L10_1.SetPublic = L11_1
L10_1 = Store
function L11_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2
  L2_2 = L6_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L3_2 = L2_2.owner
    if L3_2 == A1_2 then
      goto lbl_11
    end
  end
  L3_2 = nil
  do return L3_2 end
  ::lbl_11::
  L3_2 = L2_2.share_code
  if L3_2 then
    L3_2 = L2_2.share_code
    if "" ~= L3_2 then
      L3_2 = L2_2.share_code
      return L3_2
    end
  end
  L3_2 = 1
  L4_2 = 6
  L5_2 = 1
  for L6_2 = L3_2, L4_2, L5_2 do
    L7_2 = Utils
    L7_2 = L7_2.RandomCode
    L8_2 = 8
    L7_2 = L7_2(L8_2)
    L8_2 = false
    L9_2 = ipairs
    L10_2 = L2_1.projects
    L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2)
    for L13_2, L14_2 in L9_2, L10_2, L11_2, L12_2 do
      L15_2 = L14_2.share_code
      if L15_2 == L7_2 then
        L8_2 = true
        break
      end
    end
    if not L8_2 then
      L2_2.share_code = L7_2
      L9_2 = L4_1
      L9_2()
      return L7_2
    end
  end
  L3_2 = nil
  return L3_2
end
L10_1.SetShareCode = L11_1
L10_1 = Store
function L11_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  L1_2 = ipairs
  L2_2 = L2_1.projects
  L1_2, L2_2, L3_2, L4_2 = L1_2(L2_2)
  for L5_2, L6_2 in L1_2, L2_2, L3_2, L4_2 do
    L7_2 = L6_2.share_code
    if L7_2 == A0_2 then
      return L6_2
    end
  end
  L1_2 = nil
  return L1_2
end
L10_1.FindByCode = L11_1
L10_1 = Store
function L11_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L3_2 = ipairs
  L4_2 = L2_1.shares
  L3_2, L4_2, L5_2, L6_2 = L3_2(L4_2)
  for L7_2, L8_2 in L3_2, L4_2, L5_2, L6_2 do
    L9_2 = L8_2.project_id
    if L9_2 == A0_2 then
      L9_2 = L8_2.identifier
      if L9_2 == A1_2 then
        return
      end
    end
  end
  L3_2 = L2_1.shares
  L4_2 = L2_1.shares
  L4_2 = #L4_2
  L4_2 = L4_2 + 1
  L5_2 = {}
  L5_2.project_id = A0_2
  L5_2.identifier = A1_2
  L6_2 = A2_2 or L6_2
  if not A2_2 then
    L6_2 = ""
  end
  L5_2.shared_by = L6_2
  L3_2[L4_2] = L5_2
  L3_2 = L4_1
  L3_2()
end
L10_1.AddShare = L11_1
L10_1 = 33554432
L11_1 = 1048576
function L12_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2
  L1_2 = Bridge
  L1_2 = L1_2.GetIdentifier
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  if not L1_2 or "" == L1_2 then
    L2_2 = Utils
    L2_2 = L2_2.Warn
    L3_2 = "could not resolve an identifier for player %d"
    L4_2 = L3_2
    L3_2 = L3_2.format
    L5_2 = A0_2
    L3_2, L4_2, L5_2 = L3_2(L4_2, L5_2)
    L2_2(L3_2, L4_2, L5_2)
    L2_2 = nil
    return L2_2
  end
  return L1_2
end
L13_1 = Apex
L13_1 = L13_1.OnLarge
L14_1 = "project_save"
function L15_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2
  function L3_2(A0_3)
    local L1_3, L2_3, L3_3, L4_3, L5_3, L6_3, L7_3
    if A0_3 then
      L1_3 = print
      L2_3 = "^3[apex_clothing]^7 project save failed: %s"
      L3_3 = L2_3
      L2_3 = L2_3.format
      L4_3 = A0_3
      L2_3, L3_3, L4_3, L5_3, L6_3, L7_3 = L2_3(L3_3, L4_3)
      L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3)
    end
    L1_3 = TriggerClientEvent
    L2_3 = "apex_clothing:projectSaved"
    L3_3 = A0_2
    L4_3 = false
    L5_3 = nil
    L6_3 = nil
    L7_3 = A0_3
    L1_3(L2_3, L3_3, L4_3, L5_3, L6_3, L7_3)
  end
  L4_2 = Store
  L4_2 = L4_2.Ready
  if not L4_2 then
    L4_2 = L3_2
    L5_2 = "#save_err_db"
    return L4_2(L5_2)
  end
  L4_2 = L12_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = L3_2
    L6_2 = "#save_err_identity"
    return L5_2(L6_2)
  end
  L5_2 = pcall
  L6_2 = json
  L6_2 = L6_2.decode
  L7_2 = A2_2
  L5_2, L6_2 = L5_2(L6_2, L7_2)
  if L5_2 then
    L7_2 = type
    L8_2 = L6_2
    L7_2 = L7_2(L8_2)
    if "table" == L7_2 then
      goto lbl_35
    end
  end
  L7_2 = L3_2
  L8_2 = "#save_err_payload"
  do return L7_2(L8_2) end
  ::lbl_35::
  L7_2 = type
  L8_2 = L6_2.meta
  L7_2 = L7_2(L8_2)
  if "table" == L7_2 then
    L7_2 = L6_2.meta
    if L7_2 then
      goto lbl_44
    end
  end
  L7_2 = L6_2
  ::lbl_44::
  L8_2 = Utils
  L8_2 = L8_2.Trim
  L9_2 = tostring
  L10_2 = L7_2.name
  if not L10_2 then
    L10_2 = ""
  end
  L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L9_2(L10_2)
  L8_2 = L8_2(L9_2, L10_2, L11_2, L12_2, L13_2, L14_2, L15_2, L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  if "" ~= L8_2 then
    L9_2 = #L8_2
    if not (L9_2 > 80) then
      goto lbl_62
    end
  end
  L9_2 = L3_2
  L10_2 = "#save_err_name"
  do return L9_2(L10_2) end
  ::lbl_62::
  L9_2 = L6_2.state
  L10_2 = type
  L11_2 = L9_2
  L10_2 = L10_2(L11_2)
  if "string" ~= L10_2 or "" == L9_2 then
    L10_2 = L3_2
    L11_2 = "#save_err_empty"
    return L10_2(L11_2)
  end
  L10_2 = #L9_2
  L11_2 = L10_1
  if L10_2 > L11_2 then
    L10_2 = L3_2
    L11_2 = "#save_err_big"
    return L10_2(L11_2)
  end
  L10_2 = L6_2.thumb
  L11_2 = type
  L12_2 = L10_2
  L11_2 = L11_2(L12_2)
  if "string" == L11_2 then
    L11_2 = #L10_2
    L12_2 = L11_1
    if not (L11_2 > L12_2) then
      goto lbl_93
    end
  end
  L10_2 = nil
  ::lbl_93::
  L11_2 = L7_2.context
  if not L11_2 then
    L11_2 = L6_2.wardrobe
  end
  L12_2 = type
  L13_2 = L11_2
  L12_2 = L12_2(L13_2)
  if "table" == L12_2 then
    L12_2 = json
    L12_2 = L12_2.encode
    L13_2 = L11_2
    L12_2 = L12_2(L13_2)
    if L12_2 then
      goto lbl_109
    end
  end
  L12_2 = nil
  ::lbl_109::
  L13_2 = type
  L14_2 = L11_2
  L13_2 = L13_2(L14_2)
  if "table" == L13_2 then
    L13_2 = L11_2.model
    if L13_2 then
      goto lbl_127
    end
  end
  L13_2 = Config
  L13_2 = L13_2.pedModels
  if L13_2 then
    L13_2 = Config
    L13_2 = L13_2.pedModels
    L13_2 = L13_2[1]
    if L13_2 then
      goto lbl_127
    end
  end
  L13_2 = "mp_m_freemode_01"
  ::lbl_127::
  L14_2 = tonumber
  L15_2 = L7_2.id
  L14_2 = L14_2(L15_2)
  L15_2 = Store
  L15_2 = L15_2.Save
  L16_2 = L4_2
  L17_2 = Bridge
  L17_2 = L17_2.GetCharName
  L18_2 = A0_2
  L17_2 = L17_2(L18_2)
  if not L17_2 then
    L17_2 = ""
  end
  L18_2 = L14_2
  L19_2 = L8_2
  L20_2 = L13_2
  L21_2 = L12_2
  L22_2 = L9_2
  L23_2 = L10_2
  L15_2 = L15_2(L16_2, L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
  if L15_2 then
    L16_2 = Utils
    L16_2 = L16_2.Log
    L17_2 = "project %d saved by %s"
    L18_2 = L17_2
    L17_2 = L17_2.format
    L19_2 = L15_2
    L20_2 = L4_2
    L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2 = L17_2(L18_2, L19_2, L20_2)
    L16_2(L17_2, L18_2, L19_2, L20_2, L21_2, L22_2, L23_2)
    L16_2 = TriggerClientEvent
    L17_2 = "apex_clothing:projectSaved"
    L18_2 = A0_2
    L19_2 = true
    L20_2 = L15_2
    L21_2 = L8_2
    L16_2(L17_2, L18_2, L19_2, L20_2, L21_2)
  else
    L16_2 = L3_2
    L17_2 = "#save_err_db"
    L16_2(L17_2)
  end
end
L13_1(L14_1, L15_1)
L13_1 = Apex
L13_1 = L13_1.RegisterCallback
L14_1 = "project:list"
function L15_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2
  L2_2 = L12_1
  L3_2 = A0_2
  L2_2 = L2_2(L3_2)
  if L2_2 then
    L3_2 = Store
    L3_2 = L3_2.Ready
    if L3_2 then
      goto lbl_21
    end
  end
  L3_2 = A1_2
  L4_2 = {}
  L5_2 = {}
  L4_2.mine = L5_2
  L5_2 = {}
  L4_2.shared = L5_2
  do return L3_2(L4_2) end
  ::lbl_21::
  L3_2 = A1_2
  L4_2 = {}
  L5_2 = Store
  L5_2 = L5_2.ListMine
  L6_2 = L2_2
  L5_2 = L5_2(L6_2)
  L4_2.mine = L5_2
  L5_2 = Store
  L5_2 = L5_2.ListShared
  L6_2 = L2_2
  L5_2 = L5_2(L6_2)
  L4_2.shared = L5_2
  L3_2(L4_2)
end
L13_1(L14_1, L15_1)
L13_1 = Apex
L13_1 = L13_1.RegisterCallback
L14_1 = "project:gallery"
function L15_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2
  L2_2 = Store
  L2_2 = L2_2.Ready
  if not L2_2 then
    L2_2 = A1_2
    L3_2 = {}
    L4_2 = {}
    L3_2.items = L4_2
    return L2_2(L3_2)
  end
  L2_2 = A1_2
  L3_2 = {}
  L4_2 = Store
  L4_2 = L4_2.ListPublic
  L5_2 = 60
  L4_2 = L4_2(L5_2)
  L3_2.items = L4_2
  L2_2(L3_2)
end
L13_1(L14_1, L15_1)
L13_1 = Apex
L13_1 = L13_1.RegisterCallback
L14_1 = "project:load"
function L15_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L3_2 = tonumber
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  A2_2 = L3_2
  L3_2 = L12_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if A2_2 and L3_2 then
    L4_2 = Store
    L4_2 = L4_2.Ready
    if L4_2 then
      goto lbl_20
    end
  end
  L4_2 = A1_2
  L5_2 = false
  do return L4_2(L5_2) end
  ::lbl_20::
  L4_2 = Store
  L4_2 = L4_2.Get
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  L5_2 = Store
  L5_2 = L5_2.CanRead
  L6_2 = L4_2
  L7_2 = L3_2
  L5_2 = L5_2(L6_2, L7_2)
  if not L5_2 then
    L5_2 = A1_2
    L6_2 = false
    return L5_2(L6_2)
  end
  L5_2 = L4_2.context
  if L5_2 then
    function L5_2()
      local L0_3, L1_3, L2_3
      L0_3 = pcall
      L1_3 = json
      L1_3 = L1_3.decode
      L2_3 = L4_2.context
      L0_3, L1_3 = L0_3(L1_3, L2_3)
      L2_3 = L1_3 or L2_3
      if not L0_3 or not L1_3 then
        L2_3 = nil
      end
      return L2_3
    end
    L5_2 = L5_2()
    if L5_2 then
      goto lbl_43
    end
  end
  L5_2 = nil
  ::lbl_43::
  L6_2 = Apex
  L6_2 = L6_2.SendLarge
  L7_2 = "project_load"
  L8_2 = json
  L8_2 = L8_2.encode
  L9_2 = {}
  L10_2 = {}
  L11_2 = L4_2.id
  L10_2.id = L11_2
  L11_2 = L4_2.name
  L10_2.name = L11_2
  L10_2.context = L5_2
  L11_2 = L4_2.owner
  L11_2 = L11_2 == L3_2
  L10_2.owner = L11_2
  L11_2 = L4_2.owner_name
  L10_2.ownerName = L11_2
  L9_2.meta = L10_2
  L10_2 = Store
  L10_2 = L10_2.LoadState
  L11_2 = L4_2.id
  L10_2 = L10_2(L11_2)
  L9_2.state = L10_2
  L9_2.wardrobe = L5_2
  L8_2 = L8_2(L9_2)
  L9_2 = A0_2
  L6_2(L7_2, L8_2, L9_2)
  L6_2 = A1_2
  L7_2 = true
  L6_2(L7_2)
end
L13_1(L14_1, L15_1)
L13_1 = Apex
L13_1 = L13_1.RegisterCallback
L14_1 = "project:delete"
function L15_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = tonumber
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  A2_2 = L3_2
  L3_2 = L12_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not A2_2 or not L3_2 then
    L4_2 = A1_2
    L5_2 = false
    return L4_2(L5_2)
  end
  L4_2 = A1_2
  L5_2 = Store
  L5_2 = L5_2.Delete
  L6_2 = A2_2
  L7_2 = L3_2
  L5_2, L6_2, L7_2 = L5_2(L6_2, L7_2)
  L4_2(L5_2, L6_2, L7_2)
end
L13_1(L14_1, L15_1)
L13_1 = Apex
L13_1 = L13_1.RegisterCallback
L14_1 = "project:rename"
function L15_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L4_2 = tonumber
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  A2_2 = L4_2
  L4_2 = L12_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  L5_2 = Utils
  L5_2 = L5_2.Trim
  L6_2 = tostring
  L7_2 = A3_2 or L7_2
  if not A3_2 then
    L7_2 = ""
  end
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2)
  L5_2 = L5_2(L6_2, L7_2, L8_2, L9_2)
  A3_2 = L5_2
  if A2_2 and L4_2 and "" ~= A3_2 then
    L5_2 = #A3_2
    if not (L5_2 > 80) then
      goto lbl_30
    end
  end
  L5_2 = A1_2
  L6_2 = false
  do return L5_2(L6_2) end
  ::lbl_30::
  L5_2 = A1_2
  L6_2 = Store
  L6_2 = L6_2.Rename
  L7_2 = A2_2
  L8_2 = L4_2
  L9_2 = A3_2
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2)
  L5_2(L6_2, L7_2, L8_2, L9_2)
end
L13_1(L14_1, L15_1)
L13_1 = Apex
L13_1 = L13_1.RegisterCallback
L14_1 = "project:publish"
function L15_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2
  L4_2 = tonumber
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  A2_2 = L4_2
  L4_2 = L12_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not A2_2 or not L4_2 then
    L5_2 = A1_2
    L6_2 = false
    return L5_2(L6_2)
  end
  L5_2 = A1_2
  L6_2 = Store
  L6_2 = L6_2.SetPublic
  L7_2 = A2_2
  L8_2 = L4_2
  if A3_2 then
    L9_2 = true
    if L9_2 then
      goto lbl_27
    end
  end
  L9_2 = false
  ::lbl_27::
  L6_2, L7_2, L8_2, L9_2 = L6_2(L7_2, L8_2, L9_2)
  L5_2(L6_2, L7_2, L8_2, L9_2)
end
L13_1(L14_1, L15_1)
L13_1 = Apex
L13_1 = L13_1.RegisterCallback
L14_1 = "project:shareCode"
function L15_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2
  L3_2 = tonumber
  L4_2 = A2_2
  L3_2 = L3_2(L4_2)
  A2_2 = L3_2
  L3_2 = L12_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  if not A2_2 or not L3_2 then
    L4_2 = A1_2
    L5_2 = false
    return L4_2(L5_2)
  end
  L4_2 = Store
  L4_2 = L4_2.SetShareCode
  L5_2 = A2_2
  L6_2 = L3_2
  L4_2 = L4_2(L5_2, L6_2)
  if L4_2 then
    L5_2 = A1_2
    L6_2 = true
    L7_2 = L4_2
    return L5_2(L6_2, L7_2)
  end
  L5_2 = A1_2
  L6_2 = false
  L5_2(L6_2)
end
L13_1(L14_1, L15_1)
L13_1 = Apex
L13_1 = L13_1.RegisterCallback
L14_1 = "project:importCode"
function L15_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2
  L3_2 = L12_1
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = Utils
  L4_2 = L4_2.Trim
  L5_2 = tostring
  L6_2 = A2_2 or L6_2
  if not A2_2 then
    L6_2 = ""
  end
  L5_2, L6_2, L7_2, L8_2 = L5_2(L6_2)
  L4_2 = L4_2(L5_2, L6_2, L7_2, L8_2)
  L5_2 = L4_2
  L4_2 = L4_2.upper
  L4_2 = L4_2(L5_2)
  A2_2 = L4_2
  if L3_2 and "" ~= A2_2 then
    L4_2 = #A2_2
    if not (L4_2 > 12) then
      goto lbl_27
    end
  end
  L4_2 = A1_2
  L5_2 = false
  L6_2 = "#import_not_found"
  do return L4_2(L5_2, L6_2) end
  ::lbl_27::
  L4_2 = Store
  L4_2 = L4_2.FindByCode
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  if not L4_2 then
    L5_2 = A1_2
    L6_2 = false
    L7_2 = "#import_not_found"
    return L5_2(L6_2, L7_2)
  end
  L5_2 = L4_2.owner
  if L5_2 == L3_2 then
    L5_2 = A1_2
    L6_2 = false
    L7_2 = "#import_own"
    return L5_2(L6_2, L7_2)
  end
  L5_2 = Store
  L5_2 = L5_2.AddShare
  L6_2 = L4_2.id
  L7_2 = L3_2
  L8_2 = L4_2.owner_name
  if not L8_2 then
    L8_2 = ""
  end
  L5_2(L6_2, L7_2, L8_2)
  L5_2 = A1_2
  L6_2 = true
  L5_2(L6_2)
end
L13_1(L14_1, L15_1)
L13_1 = Apex
L13_1 = L13_1.RegisterCallback
L14_1 = "project:sharePlayer"
function L15_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2
  L4_2 = tonumber
  L5_2 = A2_2
  L4_2 = L4_2(L5_2)
  A2_2 = L4_2
  L4_2 = tonumber
  L5_2 = A3_2
  L4_2 = L4_2(L5_2)
  A3_2 = L4_2
  L4_2 = L12_1
  L5_2 = A0_2
  L4_2 = L4_2(L5_2)
  if not (A2_2 and A3_2) or not L4_2 then
    L5_2 = A1_2
    L6_2 = false
    L7_2 = "#share_no_player"
    return L5_2(L6_2, L7_2)
  end
  L5_2 = Store
  L5_2 = L5_2.Get
  L6_2 = A2_2
  L5_2 = L5_2(L6_2)
  if L5_2 then
    L6_2 = L5_2.owner
    if L6_2 == L4_2 then
      goto lbl_37
    end
  end
  L6_2 = A1_2
  L7_2 = false
  L8_2 = "#share_no_player"
  do return L6_2(L7_2, L8_2) end
  ::lbl_37::
  L6_2 = GetPlayerName
  L7_2 = A3_2
  L6_2 = L6_2(L7_2)
  if not L6_2 then
    L6_2 = A1_2
    L7_2 = false
    L8_2 = "#share_no_player"
    return L6_2(L7_2, L8_2)
  end
  L6_2 = Bridge
  L6_2 = L6_2.GetIdentifier
  L7_2 = A3_2
  L6_2 = L6_2(L7_2)
  if not L6_2 or L6_2 == L4_2 then
    L7_2 = A1_2
    L8_2 = false
    L9_2 = "#share_no_player"
    return L7_2(L8_2, L9_2)
  end
  L7_2 = Store
  L7_2 = L7_2.AddShare
  L8_2 = A2_2
  L9_2 = L6_2
  L10_2 = Bridge
  L10_2 = L10_2.GetCharName
  L11_2 = A0_2
  L10_2 = L10_2(L11_2)
  if not L10_2 then
    L10_2 = ""
  end
  L7_2(L8_2, L9_2, L10_2)
  L7_2 = TriggerClientEvent
  L8_2 = "apex_clothing:projectShared"
  L9_2 = A3_2
  L10_2 = Bridge
  L10_2 = L10_2.GetCharName
  L11_2 = A0_2
  L10_2 = L10_2(L11_2)
  if not L10_2 then
    L10_2 = "Someone"
  end
  L7_2(L8_2, L9_2, L10_2)
  L7_2 = A1_2
  L8_2 = true
  L7_2(L8_2)
end
L13_1(L14_1, L15_1)
