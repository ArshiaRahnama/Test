local L0_1, L1_1, L2_1, L3_1
L0_1 = 10
L1_1 = BaseCallback
L2_1 = "yellowPages:getPosts"
function L3_1(A0_2, A1_2, A2_2, A3_2)
  local L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  if not A2_2 then
    A2_2 = 0
  end
  L4_2 = {}
  L5_2 = {}
  if A3_2 then
    L6_2 = A3_2.search
    if L6_2 then
      L6_2 = #L5_2
      L6_2 = L6_2 + 1
      L5_2[L6_2] = "(title LIKE ? OR description LIKE ?)"
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L7_2 = "%"
      L8_2 = A3_2.search
      L9_2 = "%"
      L7_2 = L7_2 .. L8_2 .. L9_2
      L4_2[L6_2] = L7_2
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L7_2 = "%"
      L8_2 = A3_2.search
      L9_2 = "%"
      L7_2 = L7_2 .. L8_2 .. L9_2
      L4_2[L6_2] = L7_2
      L6_2 = A3_2.from
      if not L6_2 then
        L6_2 = #L5_2
        L6_2 = L6_2 + 1
        L5_2[L6_2] = "OR phone_number LIKE ?"
        L6_2 = #L4_2
        L6_2 = L6_2 + 1
        L7_2 = "%"
        L8_2 = A3_2.search
        L9_2 = "%"
        L7_2 = L7_2 .. L8_2 .. L9_2
        L4_2[L6_2] = L7_2
      end
    end
  end
  if A3_2 then
    L6_2 = A3_2.from
    if L6_2 then
      L6_2 = #L5_2
      L6_2 = L6_2 + 1
      L7_2 = #L5_2
      if L7_2 > 0 then
        L7_2 = "AND "
        if L7_2 then
          goto lbl_63
        end
      end
      L7_2 = ""
      ::lbl_63::
      L8_2 = "phone_number = ?"
      L7_2 = L7_2 .. L8_2
      L5_2[L6_2] = L7_2
      L6_2 = #L4_2
      L6_2 = L6_2 + 1
      L7_2 = A3_2.from
      L4_2[L6_2] = L7_2
    end
  end
  L6_2 = [[
        SELECT
            id,
            phone_number AS `number`,
            title,
            description,
            attachment,
            price,
            `timestamp`
        FROM
            phone_yellow_pages_posts
        {WHERE}
        ORDER BY
            `timestamp` DESC
        LIMIT ?, ?
    ]]
  L8_2 = L6_2
  L7_2 = L6_2.gsub
  L9_2 = "{WHERE}"
  L10_2 = #L5_2
  if L10_2 > 0 then
    L10_2 = "WHERE "
    L11_2 = table
    L11_2 = L11_2.concat
    L12_2 = L5_2
    L13_2 = " "
    L11_2 = L11_2(L12_2, L13_2)
    L10_2 = L10_2 .. L11_2
    if L10_2 then
      goto lbl_87
    end
  end
  L10_2 = ""
  ::lbl_87::
  L7_2 = L7_2(L8_2, L9_2, L10_2)
  L6_2 = L7_2
  L7_2 = #L4_2
  L7_2 = L7_2 + 1
  L8_2 = A2_2 or L8_2
  if not A2_2 then
    L8_2 = 0
  end
  L9_2 = L0_1
  L8_2 = L8_2 * L9_2
  L4_2[L7_2] = L8_2
  L7_2 = #L4_2
  L7_2 = L7_2 + 1
  L8_2 = L0_1
  L4_2[L7_2] = L8_2
  L7_2 = MySQL
  L7_2 = L7_2.query
  L7_2 = L7_2.await
  L8_2 = L6_2
  L9_2 = L4_2
  return L7_2(L8_2, L9_2)
end
L1_1(L2_1, L3_1)
L1_1 = BaseCallback
L2_1 = "yellowPages:createPost"
function L3_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = A2_2
  if L3_2 then
    L3_2 = L3_2.title
  end
  if L3_2 then
    L3_2 = A2_2
    if L3_2 then
      L3_2 = L3_2.description
    end
    if L3_2 then
      L3_2 = ContainsBlacklistedWord
      L4_2 = A0_2
      L5_2 = "Pages"
      L6_2 = A2_2.title
      L3_2 = L3_2(L4_2, L5_2, L6_2)
      if not L3_2 then
        L3_2 = ContainsBlacklistedWord
        L4_2 = A0_2
        L5_2 = "Pages"
        L6_2 = A2_2.description
        L3_2 = L3_2(L4_2, L5_2, L6_2)
        if not L3_2 then
          goto lbl_29
        end
      end
    end
  end
  L3_2 = false
  do return L3_2 end
  ::lbl_29::
  L3_2 = MySQL
  L3_2 = L3_2.insert
  L3_2 = L3_2.await
  L4_2 = "INSERT INTO phone_yellow_pages_posts (phone_number, title, description, attachment, price) VALUES (@number, @title, @description, @attachment, @price)"
  L5_2 = {}
  L5_2["@number"] = A1_2
  L6_2 = A2_2.title
  L5_2["@title"] = L6_2
  L6_2 = A2_2.description
  L5_2["@description"] = L6_2
  L6_2 = A2_2.attachment
  L5_2["@attachment"] = L6_2
  L6_2 = tonumber
  L7_2 = A2_2.price
  L6_2 = L6_2(L7_2)
  L5_2["@price"] = L6_2
  L3_2 = L3_2(L4_2, L5_2)
  if not L3_2 then
    L4_2 = false
    return L4_2
  end
  A2_2.id = L3_2
  A2_2.number = A1_2
  L4_2 = TriggerClientEvent
  L5_2 = "phone:yellowPages:newPost"
  L6_2 = -1
  L7_2 = A2_2
  L4_2(L5_2, L6_2, L7_2)
  L4_2 = TriggerEvent
  L5_2 = "lb-phone:pages:newPost"
  L6_2 = A2_2
  L4_2(L5_2, L6_2)
  L4_2 = Log
  L5_2 = "YellowPages"
  L6_2 = A0_2
  L7_2 = "info"
  L8_2 = L
  L9_2 = "BACKEND.LOGS.YELLOWPAGES_NEW_TITLE"
  L8_2 = L8_2(L9_2)
  L9_2 = L
  L10_2 = "BACKEND.LOGS.YELLOWPAGES_NEW_DESCRIPTION"
  L11_2 = {}
  L12_2 = A2_2.title
  L11_2.title = L12_2
  L12_2 = A2_2.description
  L11_2.description = L12_2
  L12_2 = A2_2.attachment
  if not L12_2 then
    L12_2 = ""
  end
  L11_2.attachment = L12_2
  L12_2 = A2_2.id
  L11_2.id = L12_2
  L9_2, L10_2, L11_2, L12_2 = L9_2(L10_2, L11_2)
  L4_2(L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  return L3_2
end
L1_1(L2_1, L3_1)
L1_1 = BaseCallback
L2_1 = "yellowPages:deletePost"
function L3_1(A0_2, A1_2, A2_2)
  local L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2
  L3_2 = IsAdmin
  L4_2 = A0_2
  L3_2 = L3_2(L4_2)
  L4_2 = MySQL
  L4_2 = L4_2.update
  L4_2 = L4_2.await
  L5_2 = "DELETE FROM phone_yellow_pages_posts WHERE id = @id"
  if L3_2 then
    L6_2 = ""
    if L6_2 then
      goto lbl_14
    end
  end
  L6_2 = " AND phone_number = @number"
  ::lbl_14::
  L5_2 = L5_2 .. L6_2
  L6_2 = {}
  L6_2["@id"] = A2_2
  L6_2["@number"] = A1_2
  L4_2 = L4_2(L5_2, L6_2)
  L4_2 = L4_2 > 0
  if L4_2 then
    L5_2 = Log
    L6_2 = "YellowPages"
    L7_2 = A0_2
    L8_2 = "error"
    L9_2 = L
    L10_2 = "BACKEND.LOGS.YELLOWPAGES_DELETED"
    L9_2 = L9_2(L10_2)
    L10_2 = "**ID**: %s"
    L11_2 = L10_2
    L10_2 = L10_2.format
    L12_2 = A2_2
    L10_2, L11_2, L12_2 = L10_2(L11_2, L12_2)
    L5_2(L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2)
  end
  L5_2 = true
  return L5_2
end
L1_1(L2_1, L3_1)
