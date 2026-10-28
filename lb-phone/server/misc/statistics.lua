local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1, L6_1, L7_1, L8_1, L9_1, L10_1
L0_1 = GetResourceMetadata
L1_1 = GetCurrentResourceName
L1_1 = L1_1()
L2_1 = "version"
L3_1 = 0
L0_1 = L0_1(L1_1, L2_1, L3_1)
if not L0_1 then
  L0_1 = "0.0.0"
end
L1_1 = GetResourceMetadata
L2_1 = GetCurrentResourceName
L2_1 = L2_1()
L3_1 = "ui_page"
L4_1 = 0
L1_1 = L1_1(L2_1, L3_1, L4_1)
L1_1 = "ui/dist/index.html" ~= L1_1
L2_1 = 25
L3_1 = {}
L4_1 = "webm"
L5_1 = "mp4"
L6_1 = "mov"
L3_1[1] = L4_1
L3_1[2] = L5_1
L3_1[3] = L6_1
L4_1 = {}
L5_1 = 0
L6_1 = nil
L8_1 = L0_1
L7_1 = L0_1.match
L9_1 = "^%d+%.%d+%.%d+$"
L7_1 = L7_1(L8_1, L9_1)
if not L7_1 then
  L0_1 = "0.0.0"
end
function L7_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2
  if not A0_2 then
    L1_2 = L5_1
    L2_2 = L2_1
    if L1_2 < L2_2 then
      goto lbl_10
    end
  end
  L1_2 = L5_1
  ::lbl_10::
  if 0 == L1_2 then
    return
  end
  L1_2 = L6_1
  if not L1_2 then
    L1_2 = GetConvar
    L2_2 = "web_baseUrl"
    L3_2 = ""
    L1_2 = L1_2(L2_2, L3_2)
    if "" == L1_2 then
      return
    end
    L2_2 = #L1_2
    L4_2 = L1_2
    L3_2 = L1_2.reverse
    L3_2 = L3_2(L4_2)
    L4_2 = L3_2
    L3_2 = L3_2.find
    L5_2 = "-"
    L3_2 = L3_2(L4_2, L5_2)
    if not L3_2 then
      L3_2 = #L1_2
      L3_2 = L3_2 + 1
    end
    L2_2 = L2_2 - L3_2
    L2_2 = L2_2 + 1
    L3_2 = string
    L3_2 = L3_2.sub
    L4_2 = L1_2
    L5_2 = L2_2 + 1
    L6_2 = #L1_2
    L7_2 = ".users.cfx.re"
    L7_2 = #L7_2
    L6_2 = L6_2 - L7_2
    L3_2 = L3_2(L4_2, L5_2, L6_2)
    L6_1 = L3_2
  end
  L1_2 = json
  L1_2 = L1_2.encode
  L2_2 = {}
  L3_2 = L6_1
  L2_2.serverId = L3_2
  L3_2 = L0_1
  L2_2.version = L3_2
  L3_2 = L4_1
  L2_2.events = L3_2
  L1_2 = L1_2(L2_2)
  L2_2 = 0
  L5_1 = L2_2
  L2_2 = {}
  L4_1 = L2_2
  L2_2 = PerformHttpRequest
  L3_2 = "https://track.lbscripts.com/"
  function L4_2()
    local L0_3, L1_3
  end
  L5_2 = "POST"
  L6_2 = L1_2
  L7_2 = {}
  L7_2["Content-Type"] = "application/json"
  L2_2(L3_2, L4_2, L5_2, L6_2, L7_2)
end
function L8_1(A0_2)
  local L1_2, L2_2, L3_2
  L1_2 = L1_1
  if L1_2 then
    return
  end
  L1_2 = L5_1
  L1_2 = L1_2 + 1
  L5_1 = L1_2
  L2_2 = L5_1
  L1_2 = L4_1
  L3_2 = {}
  L3_2.event = A0_2
  L1_2[L2_2] = L3_2
  L1_2 = L7_1
  L1_2()
end
TrackSimpleEvent = L8_1
function L8_1(A0_2, A1_2)
  local L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L2_2 = L1_1
  if L2_2 then
    return
  end
  L2_2 = 0
  L3_2 = 0
  if A1_2 then
    L4_2 = 1
    L5_2 = #A1_2
    L6_2 = 1
    for L7_2 = L4_2, L5_2, L6_2 do
      L8_2 = A1_2[L7_2]
      L10_2 = L8_2
      L9_2 = L8_2.match
      L11_2 = "%.([^.]+)$"
      L9_2 = L9_2(L10_2, L11_2)
      if not L9_2 then
        L9_2 = "webp"
      end
      L10_2 = table
      L10_2 = L10_2.contains
      L11_2 = L3_1
      L12_2 = L9_2
      L10_2 = L10_2(L11_2, L12_2)
      if L10_2 then
        L3_2 = L3_2 + 1
      else
        L2_2 = L2_2 + 1
      end
    end
  end
  L4_2 = L5_1
  L4_2 = L4_2 + 1
  L5_1 = L4_2
  L5_2 = L5_1
  L4_2 = L4_1
  L6_2 = {}
  L6_2.event = "social_media_post"
  L6_2.app = A0_2
  L6_2.amountVideos = L3_2
  L6_2.amountPhotos = L2_2
  L4_2[L5_2] = L6_2
  L4_2 = L7_1
  L4_2()
end
TrackSocialMediaPost = L8_1
L8_1 = AddEventHandler
L9_1 = "txAdmin:events:scheduledRestart"
function L10_1(A0_2)
  local L1_2, L2_2
  L1_2 = A0_2.secondsRemaining
  if 60 == L1_2 then
    L1_2 = L7_1
    L2_2 = true
    L1_2(L2_2)
  end
end
L8_1(L9_1, L10_1)
L8_1 = AddEventHandler
L9_1 = "txAdmin:events:serverShuttingDown"
function L10_1()
  local L0_2, L1_2
  L0_2 = L7_1
  L1_2 = true
  L0_2(L1_2)
end
L8_1(L9_1, L10_1)
L8_1 = AddEventHandler
L9_1 = "onResourceStop"
function L10_1(A0_2)
  local L1_2, L2_2
  L1_2 = GetCurrentResourceName
  L1_2 = L1_2()
  if A0_2 == L1_2 then
    L1_2 = L7_1
    L2_2 = true
    L1_2(L2_2)
  end
end
L8_1(L9_1, L10_1)
