-- server.lua (clean)

-- NOTE: fonctions custom attendues dans ton codebase :
-- BaseCallback, GetSourceFromNumber, ContainsBlacklistedWord, SendNotification,
-- GetContact, FormatNumber, L (localisation), Log, debugprint

--==============================--
-- Helpers SQL / Messages
--==============================--

--- Récupère l'ID d'un canal DM (non groupe) entre deux numéros, sinon nil.
---@param a string -- phone_number A
---@param b string -- phone_number B
---@return number? channelId
local function getDirectChannelId(a, b)
  return MySQL.scalar.await([[
      SELECT c.id
      FROM phone_message_channels c
      WHERE c.is_group = 0
        AND EXISTS (SELECT 1 FROM phone_message_members m WHERE m.channel_id = c.id AND m.phone_number = ?)
        AND EXISTS (SELECT 1 FROM phone_message_members m WHERE m.channel_id = c.id AND m.phone_number = ?)
  ]], { a, b })
end

--- Crée un canal DM (non groupe) entre deux numéros, retourne son id.
---@param a string
---@param b string
---@return number channelId
local function createDirectChannel(a, b)
  local channelId = MySQL.insert.await("INSERT INTO phone_message_channels (is_group) VALUES (0)")
  if not channelId then return nil end
  MySQL.update.await(
      "INSERT INTO phone_message_members (channel_id, phone_number) VALUES (?, ?), (?, ?)",
      { channelId, a, channelId, b }
  )
  return channelId
end

--- Notifie les 2 membres d’un nouveau canal DM (côté client).
local function notifyNewDirectChannel(channelId, meNumber, otherNumber, lastMessage)
  local meSrc    = GetSourceFromNumber(meNumber)
  local otherSrc = GetSourceFromNumber(otherNumber)
  local ts = os.time() * 1000

  if meSrc then
      TriggerClientEvent("phone:messages:newChannel", meSrc, {
          id = channelId,
          lastMessage = lastMessage,
          timestamp = ts,
          number = otherNumber,
          isGroup = false,
          unread = false
      })
  end

  if otherSrc then
      TriggerClientEvent("phone:messages:newChannel", otherSrc, {
          id = channelId,
          lastMessage = lastMessage,
          timestamp = ts,
          number = meNumber,
          isGroup = false,
          unread = true
      })
  end
end

--- Push un message dans la table messages.
---@return number? messageId
local function insertMessage(channelId, sender, content, attachmentsJson)
  return MySQL.insert.await(
      "INSERT INTO phone_message_messages (channel_id, sender, content, attachments) VALUES (@channelId, @sender, @content, @attachments)",
      { ["@channelId"] = channelId, ["@sender"] = sender, ["@content"] = content, ["@attachments"] = attachmentsJson }
  )
end

--- Met à jour les compteurs et l’aperçu de conversation.
local function bumpChannelState(channelId, sender, contentOrAttachmentLabel)
  local preview = string.sub(contentOrAttachmentLabel or "Attachment", 1, 50)

  MySQL.update.await("UPDATE phone_message_channels SET last_message = ? WHERE id = ?", { preview, channelId })
  MySQL.update.await("UPDATE phone_message_members SET unread = unread + 1 WHERE channel_id = ? AND phone_number != ?", { channelId, sender })
  MySQL.update.await("UPDATE phone_message_members SET deleted = 0 WHERE channel_id = ?", { channelId })
end

--- Diffuse le message aux membres (clients) et envoie une notification (si pas d’appel manqué).
local function fanoutMessage(channelId, messageId, senderNumber, content, attachmentsJson)
  local rows = MySQL.query.await(
      "SELECT phone_number FROM phone_message_members WHERE channel_id = ? AND phone_number != ?",
      { channelId, senderNumber }
  )
  if not rows then return end

  for _, r in ipairs(rows) do
      local targetNumber = r.phone_number
      if targetNumber ~= senderNumber then
          local targetSrc = GetSourceFromNumber(targetNumber)
          if targetSrc then
              TriggerClientEvent("phone:messages:newMessage", targetSrc, channelId, messageId, senderNumber, content, attachmentsJson)
          end

          -- Pas de notif pour le tag d’appel manqué
          if content ~= "<!CALL-NO-ANSWER!>" then
              local contact = GetContact(targetNumber, senderNumber)
              SendNotification(targetNumber, {
                  app = "Messages",
                  title = (contact and contact.name) or senderNumber,
                  content = content,
                  thumbnail = (function()
                      if attachmentsJson then
                          local ok, decoded = pcall(json.decode, attachmentsJson)
                          if ok and decoded and decoded[1] then
                              return decoded[1]
                          end
                      end
                      return nil
                  end)(),
                  avatar = contact and contact.avatar or nil,
                  showAvatar = true,
              })
          end
      end
  end
end

--==============================--
-- API principale : SendMessage
--==============================--

--- Envoie un message texte/avec pièces jointes, crée le canal si besoin.
--- @param from string            -- numéro émetteur
--- @param to string|nil          -- numéro destinataire (nil si groupId fourni)
--- @param message string|nil     -- contenu texte
--- @param attachments table|string|nil -- table d’urls ou json
--- @param cb function|nil        -- callback (successId|false)
--- @param channelId number|nil   -- canal existant (DM ou groupe)
--- @return table|nil { channelId, messageId }
local function SendMessage(from, to, message, attachments, cb, channelId)
  -- validations minimales
  if (not channelId and not to) or not from then return end

  -- message/attachements : au moins un des deux
  local hasMessage = (type(message) == "string" and message ~= "")
  local hasAttach  = (type(attachments) == "table" and #attachments > 0) or (type(attachments) == "string" and attachments ~= "")

  if not hasMessage and not hasAttach then
      debugprint("No message or attachments provided")
      return
  end

  -- nettoyer les champs vides
  if not hasMessage then message = nil end
  if not hasAttach then
      if attachments then
          if type(attachments) == "table" and #attachments == 0 then
              attachments = nil
          end
      end
      if not attachments then
          debugprint("No attachments provided")
      end
  end

  -- DM : résoudre/créer le canal
  if not channelId then
      channelId = getDirectChannelId(from, to)
  end

  local fromSrc = GetSourceFromNumber(from)

  if not channelId then
      channelId = createDirectChannel(from, to)
      if not channelId then
          if cb then cb(false) end
          return
      end
      notifyNewDirectChannel(channelId, from, to, message)
  end

  -- Log serveur (custom)
  if fromSrc then
      Log("Messages", fromSrc, "info",
          L("BACKEND.LOGS.MESSAGE_TITLE"),
          L("BACKEND.LOGS.NEW_MESSAGE", {
              sender = FormatNumber(from),
              recipient = FormatNumber(to),
              message = message or "Attachment",
          })
      )
  end

  -- attachments -> json si table
  if type(attachments) == "table" then
      attachments = json.encode(attachments)
  end

  local msgId = insertMessage(channelId, from, message, attachments)
  if not msgId then
      if cb then cb(false) end
      return
  end

  bumpChannelState(channelId, from, message or "Attachment")
  fanoutMessage(channelId, msgId, from, message or "", attachments)

  if cb then cb(channelId) end

  -- event serveur pour intégrations
  TriggerEvent("lb-phone:messages:messageSent", {
      channelId = channelId,
      messageId = msgId,
      sender = from,
      recipient = to,
      message = message,
      attachments = attachments
  })

  return { channelId = channelId, messageId = msgId }
end

-- export propre
exports("SendMessage", SendMessage)

--==============================--
-- Exports utilitaires
--==============================--

--- Envoie un message système "paiement envoyé" (arrondi).
exports("SentMoney", function(from, to, amount)
  assert(type(from) == "string", ("Expected string for argument 1, got %s"):format(type(from)))
  assert(type(to) == "string",   ("Expected string for argument 2, got %s"):format(type(to)))
  assert(type(amount) == "number", ("Expected number for argument 3, got %s"):format(type(amount)))

  local rounded = math.floor(amount + 0.5)
  local tag = ("<!SENT-PAYMENT-%d!>"):format(rounded)
  SendMessage(from, to, tag)
end)

--- Envoie la position sous forme de tag
exports("SendCoords", function(from, to, vec2)
  assert(type(from) == "string", ("Expected string for argument 1, got %s"):format(type(from)))
  assert(type(to) == "string",   ("Expected string for argument 2, got %s"):format(type(to)))
  assert(type(vec2) == "vector2", ("Expected vector2 for argument 3, got %s"):format(type(vec2)))
  local tag = ("<!SENT-LOCATION-X=%sY=%s!>"):format(vec2.x, vec2.y)
  SendMessage(from, to, tag)
end)

--==============================--
-- Callbacks
--==============================--

-- sendMessage (filtre anti-insultes/blacklist custom)
BaseCallback("messages:sendMessage", function(src, from, to, content, attachments, channelId)
  if ContainsBlacklistedWord(src, "Messages", content) then
      return false
  end
  return SendMessage(from, to, content, attachments, nil, channelId)
end)

-- createGroup
BaseCallback("messages:createGroup", function(src, ownerNumber, members, firstMessage, attachments)
  local channelId = MySQL.insert.await("INSERT INTO phone_message_channels (is_group) VALUES (1)")
  if not channelId then return false end

  -- propriétaire
  MySQL.update.await("INSERT INTO phone_message_members (channel_id, phone_number, is_owner) VALUES (?, ?, 1)", { channelId, ownerNumber })

  -- membres
  local memberPayload = { { number = ownerNumber, isOwner = true } }
  for _, num in ipairs(members) do
      MySQL.update.await("INSERT INTO phone_message_members (channel_id, phone_number, is_owner) VALUES (?, ?, 0)", { channelId, num })
      memberPayload[#memberPayload + 1] = { number = num, isOwner = false }
  end

  local ts = os.time() * 1000
  local channelDTO = {
      id = channelId,
      lastMessage = firstMessage,
      timestamp = ts,
      name = nil,
      isGroup = true,
      members = memberPayload,
      unread = false
  }

  -- push à tous les membres connectés
  for _, num in ipairs(members) do
      local tSrc = GetSourceFromNumber(num)
      if tSrc then
          TriggerClientEvent("phone:messages:newChannel", tSrc, channelDTO)
      end
  end
  TriggerClientEvent("phone:messages:newChannel", src, channelDTO)

  -- enregistre le premier message dans le groupe
  return SendMessage(ownerNumber, nil, firstMessage, attachments, nil, channelId)
end)

-- renameGroup
BaseCallback("messages:renameGroup", function(src, channelId, newName)
  local affected = MySQL.update.await(
      "UPDATE phone_message_channels SET `name` = ? WHERE id = ? AND is_group = 1",
      { newName, channelId }
  )
  local ok = affected > 0
  if ok then
      TriggerClientEvent("phone:messages:renameGroup", -1, channelId, newName)
  end
  return ok
end)

-- getRecentMessages
BaseCallback("messages:getRecentMessages", function(src, myNumber)
  return MySQL.query.await([[
      SELECT
          channel.id AS channel_id,
          channel.is_group,
          channel.`name`,
          channel.last_message,
          channel.last_message_timestamp,
          channel_member.phone_number,
          channel_member.is_owner,
          channel_member.unread,
          channel_member.deleted
      FROM phone_message_members target_member
      INNER JOIN phone_message_channels channel
          ON channel.id = target_member.channel_id
      INNER JOIN phone_message_members channel_member
          ON channel_member.channel_id = channel.id
      WHERE target_member.phone_number = ?
      ORDER BY channel.last_message_timestamp DESC
  ]], { myNumber })
end)

-- getMessages (pagination 25)
BaseCallback("messages:getMessages", function(src, myNumber, channelId, page)
  return MySQL.query.await([[
      SELECT id, sender, content, attachments, `timestamp`
      FROM phone_message_messages
      WHERE channel_id = ?
        AND EXISTS (SELECT 1 FROM phone_message_members m WHERE m.channel_id = ? AND m.phone_number = ?)
      ORDER BY `timestamp` DESC
      LIMIT ?, ?
  ]], { channelId, channelId, myNumber, page * 25, 25 })
end)

-- deleteMessage
BaseCallback("messages:deleteMessage", function(src, myNumber, messageId, channelId)
  if not Config.DeleteMessages then return false end

  local lastId = MySQL.scalar.await("SELECT MAX(id) FROM phone_message_messages WHERE channel_id = ?", { channelId })
  local deletingLast = (lastId == messageId)

  local affected = MySQL.update.await(
      "DELETE FROM phone_message_messages WHERE id = ? AND sender = ? AND channel_id = ?",
      { messageId, myNumber, channelId }
  )
  local ok = affected > 0

  if ok and deletingLast then
      MySQL.update.await(
          "UPDATE phone_message_channels SET last_message = ? WHERE id = ?",
          { L("APPS.MESSAGES.MESSAGE_DELETED"), channelId }
      )
  end

  if ok then
      TriggerClientEvent("phone:messages:messageDeleted", -1, channelId, messageId, deletingLast)
  end
  return ok
end)

-- addMember
BaseCallback("messages:addMember", function(src, myNumber, channelId, newNumber)
  local affected = MySQL.update.await(
      "INSERT IGNORE INTO phone_message_members (channel_id, phone_number) VALUES (?, ?)",
      { channelId, newNumber }
  )
  local ok = affected > 0
  local newSrc = GetSourceFromNumber(newNumber)

  if not ok then return false end

  TriggerClientEvent("phone:messages:memberAdded", -1, channelId, newNumber)

  if not newSrc then return true end

  local members = MySQL.Sync.fetchAll(
      "SELECT phone_number AS `number`, is_owner AS isOwner FROM phone_message_members WHERE channel_id = ?",
      { channelId }
  )
  local ch = MySQL.single.await(
      "SELECT `name`, last_message, last_message_timestamp FROM phone_message_channels WHERE id = ?",
      { channelId }
  )

  if members and #members > 0 and ch then
      TriggerClientEvent("phone:messages:newChannel", newSrc, {
          id = channelId,
          lastMessage = ch.last_message,
          timestamp = ch.last_message_timestamp,
          name = ch.name,
          isGroup = true,
          members = members,
          unread = false
      })
  end
  return true
end)

-- removeMember
BaseCallback("messages:removeMember", function(src, myNumber, channelId, targetNumber)
  local isOwner = MySQL.scalar.await(
      "SELECT is_owner FROM phone_message_members WHERE channel_id = ? AND phone_number = ?",
      { channelId, myNumber }
  )
  if not isOwner then return false end

  local affected = MySQL.update.await(
      "DELETE FROM phone_message_members WHERE channel_id = ? AND phone_number = ?",
      { channelId, targetNumber }
  )
  local ok = affected > 0

  if ok then
      TriggerClientEvent("phone:messages:memberRemoved", -1, channelId, targetNumber)
  end
  return ok
end)

-- leaveGroup
BaseCallback("messages:leaveGroup", function(src, myNumber, channelId)
  local iAmOwner = MySQL.scalar.await(
      "SELECT is_owner FROM phone_message_members WHERE channel_id = ? AND phone_number = ?",
      { channelId, myNumber }
  )

  if iAmOwner then
      -- transférer la propriété à un autre membre
      MySQL.update.await([[
          UPDATE phone_message_members m
          SET is_owner = TRUE
          WHERE m.channel_id = ?
            AND m.phone_number != ?
          LIMIT 1
      ]], { channelId, myNumber })

      local newOwner = MySQL.scalar.await(
          "SELECT phone_number FROM phone_message_members WHERE channel_id = ? AND is_owner = TRUE",
          { channelId }
      )
      TriggerClientEvent("phone:messages:ownerChanged", -1, channelId, newOwner)
  end

  local ok = (MySQL.update.await(
      "DELETE FROM phone_message_members WHERE channel_id = ? AND phone_number = ?",
      { channelId, myNumber }
  ) > 0)

  local empty = (MySQL.scalar.await(
      "SELECT COUNT(1) FROM phone_message_members WHERE channel_id = ?",
      { channelId }
  ) == 0)

  if ok then
      TriggerClientEvent("phone:messages:memberRemoved", -1, channelId, myNumber)
  end

  if empty then
      MySQL.update.await("DELETE FROM phone_message_channels WHERE id = ?", { channelId })
      debugprint(("Deleted group %s due to it being empty"):format(channelId))
  end

  return ok
end)

-- markRead
BaseCallback("messages:markRead", function(src, myNumber, channelId)
  MySQL.update.await(
      "UPDATE phone_message_members SET unread = 0 WHERE channel_id = ? AND phone_number = ?",
      { channelId, myNumber }
  )
  return true
end)

-- deleteConversations (soft-delete côté membre)
BaseCallback("messages:deleteConversations", function(src, myNumber, channelIds)
  if type(channelIds) ~= "table" then
      debugprint(("expected table, got %s"):format(type(channelIds)))
      return false
  end
  MySQL.update.await(
      "UPDATE phone_message_members SET deleted = 1 WHERE channel_id IN (?) AND phone_number = ?",
      { channelIds, myNumber }
  )
  return true
end)
