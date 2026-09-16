-- ================================================================= --
--  INVENTORY SLOT LAYER  (feature #1 grid + #2 stack limit + #15)
-- ================================================================= --
--
--  ── Why it's a LAYER and not a rewrite ──
--  `self.inventory` is a name-keyed list ({name, count, label, ...}).
--  Something like 40+ call sites across this pack read it directly
--  (esx_inventory, esx_jobs, Unique_*, shops, drug scripts...), and
--  every one of them assumes "one entry per item name, .count is the
--  TOTAL the player owns". Turning that list into a slot-indexed array
--  would silently break all of them - a shop checking
--  getInventoryItem('bread').count would suddenly see one stack of 50
--  instead of the 120 the player really has, and sell them 70 more.
--
--  So the totals stay exactly where they are and stay authoritative.
--  This adds a SECOND structure, `self.invSlots`, which is purely a
--  *placement map*: which stack sits in which grid cell. After any
--  mutation of the real inventory, reconcile() re-derives the map from
--  the totals. Moving/splitting a slot only rearranges the map and
--  never changes a total - which means the whole grid feature has zero
--  dupe surface by construction.
--
--  invSlots shape:  { [slotNumber] = { name = 'bread', count = 12 } }
--  slotNumber is 1..Config.InventorySlots, plus the reserved backpack
--  band (#15) above that.
-- ================================================================= --

Config = Config or {}
Config.InventorySlots     = Config.InventorySlots     or 50  -- normal grid cells
Config.DefaultStackLimit  = Config.DefaultStackLimit  or 50  -- per-slot cap when the item has none
Config.BackpackSlotStart  = Config.BackpackSlotStart  or 101 -- #15: dedicated backpack band
Config.BackpackSlotCount  = Config.BackpackSlotCount  or 0   -- set live from Config.BackpackSlots below

-- #15 — how many extra dedicated slots each backpack grants. These live
-- in their own band (101+) so they are visually and logically separate
-- from the 50 normal cells, and they vanish (contents spill back into
-- the normal grid, or drop if there's no room) when the pack comes off.
Config.BackpackSlots = Config.BackpackSlots or {
    ['backpack']        = 6,
    ['backpack_medium'] = 12,
    ['backpack_large']  = 20,
}

--- Per-slot stack cap for an item.
--- `items.limit` is already a column in this schema; -1/0/nil there just
--- means "unset", so fall back to the global default rather than making
--- the item unstackable or infinitely stackable by accident.
function ESX_StackLimit(name)
    local item = ESX.Items and ESX.Items[name]
    local lim = item and tonumber(item.limit)
    if lim and lim > 0 then return lim end
    return Config.DefaultStackLimit
end

--- Attach the slot layer to a player object. Called once from
--- CreatePlayer (server/classes/player.lua).
--- `saved` is the decoded `users.invslots` JSON, or nil for a player who
--- has never had a slot map (everyone, the first time this ships).
function InitInventorySlots(self, saved)
    self.invSlots = {}
    self.backpackSlotCount = 0

    ----------------------------------------------------------------
    -- helpers
    ----------------------------------------------------------------
    local function totalOwned(name)
        local total = 0
        for i = 1, #self.inventory do
            local e = self.inventory[i]
            if e.name == name and (tonumber(e.count) or 0) > 0 then
                total = total + e.count
            end
        end
        return total
    end

    local function isNormalSlot(slot)
        return slot >= 1 and slot <= Config.InventorySlots
    end

    local function isBackpackSlot(slot)
        return slot >= Config.BackpackSlotStart
           and slot < (Config.BackpackSlotStart + self.backpackSlotCount)
    end

    self.isValidSlot = function(slot)
        slot = tonumber(slot)
        if not slot or slot ~= math.floor(slot) then return false end
        return isNormalSlot(slot) or isBackpackSlot(slot)
    end

    local function firstFreeSlot()
        -- normal grid first, backpack band only once it's full - so a
        -- player never "loses" items into the pack band they then take off
        for s = 1, Config.InventorySlots do
            if not self.invSlots[s] then return s end
        end
        for s = Config.BackpackSlotStart, Config.BackpackSlotStart + self.backpackSlotCount - 1 do
            if not self.invSlots[s] then return s end
        end
        return nil
    end

    ----------------------------------------------------------------
    -- reconcile: make the placement map agree with the real totals
    --
    -- Runs after every add/remove. Deliberately conservative: it never
    -- re-shuffles a slot that is already correct, so a player's manual
    -- arrangement survives picking things up and putting them down.
    ----------------------------------------------------------------
    self.reconcileSlots = function()
        local names = {}
        for i = 1, #self.inventory do
            local e = self.inventory[i]
            if (tonumber(e.count) or 0) > 0 then names[e.name] = true end
        end

        -- 1. drop placements for items the player no longer has at all,
        --    and for slots that became invalid (backpack removed)
        for slot, entry in pairs(self.invSlots) do
            if not names[entry.name] or not self.isValidSlot(slot) then
                self.invSlots[slot] = nil
            end
        end

        -- 2. per item, make the sum of its placed stacks equal the total
        for name in pairs(names) do
            local target = totalOwned(name)
            local limit = ESX_StackLimit(name)

            local placed, slotsOf = 0, {}
            for slot, entry in pairs(self.invSlots) do
                if entry.name == name then
                    slotsOf[#slotsOf + 1] = slot
                    placed = placed + entry.count
                end
            end
            table.sort(slotsOf)

            if placed > target then
                -- items were consumed/removed: drain from the LAST stacks
                local excess = placed - target
                for i = #slotsOf, 1, -1 do
                    if excess <= 0 then break end
                    local slot = slotsOf[i]
                    local take = math.min(excess, self.invSlots[slot].count)
                    self.invSlots[slot].count = self.invSlots[slot].count - take
                    excess = excess - take
                    if self.invSlots[slot].count <= 0 then self.invSlots[slot] = nil end
                end
            elseif placed < target then
                -- items were added: top up existing stacks to their limit
                -- first (so picking up 3 bread merges into the 47 you had),
                -- then spill into new slots
                local remaining = target - placed
                for _, slot in ipairs(slotsOf) do
                    if remaining <= 0 then break end
                    local room = limit - self.invSlots[slot].count
                    if room > 0 then
                        local put = math.min(room, remaining)
                        self.invSlots[slot].count = self.invSlots[slot].count + put
                        remaining = remaining - put
                    end
                end
                while remaining > 0 do
                    local slot = firstFreeSlot()
                    if not slot then
                        -- No cell left. The item still EXISTS (the total is
                        -- untouched) - it's just unplaced, and shows in the
                        -- "overflow" strip in the UI until a cell frees up.
                        -- Deliberately not deleted: silently destroying a
                        -- player's items to satisfy a UI constraint is the
                        -- worst possible failure mode here.
                        break
                    end
                    local put = math.min(limit, remaining)
                    self.invSlots[slot] = { name = name, count = put }
                    remaining = remaining - put
                end
            end
        end
    end

    ----------------------------------------------------------------
    -- restore a saved map, then reconcile it against reality
    ----------------------------------------------------------------
    if type(saved) == 'table' then
        for k, v in pairs(saved) do
            local slot = tonumber(k)
            if slot and type(v) == 'table' and type(v.name) == 'string' then
                local c = tonumber(v.count) or 0
                if c > 0 then
                    self.invSlots[slot] = { name = v.name, count = c }
                end
            end
        end
    end

    ----------------------------------------------------------------
    -- #15 backpack band sizing
    ----------------------------------------------------------------
    self.setBackpackSlots = function(backpackName)
        self.backpackSlotCount = (backpackName and Config.BackpackSlots[backpackName]) or 0
        -- anything sitting in a band cell that no longer exists gets
        -- re-placed by reconcile below (into the normal grid, or left
        -- unplaced if the grid is full - never deleted)
        self.reconcileSlots()
        return self.backpackSlotCount
    end

    ----------------------------------------------------------------
    -- #1 move / #2 split - the only two mutators the client can reach
    --
    -- Both are pure rearrangements. Neither can create or destroy a
    -- single unit: every path either swaps two entries or moves N units
    -- from one entry to another, with N bounded by what's in the source.
    ----------------------------------------------------------------
    self.moveSlot = function(from, to)
        from, to = tonumber(from), tonumber(to)
        if not from or not to or from == to then return false end
        if not self.isValidSlot(from) or not self.isValidSlot(to) then return false end

        local src = self.invSlots[from]
        if not src then return false end

        local dst = self.invSlots[to]

        if not dst then
            self.invSlots[to] = src
            self.invSlots[from] = nil
            return true
        end

        if dst.name == src.name then
            -- merge up to the stack limit, leave the remainder behind
            local limit = ESX_StackLimit(src.name)
            local room = limit - dst.count
            if room <= 0 then
                -- both full: a swap is the useful behaviour here
                self.invSlots[to], self.invSlots[from] = src, dst
                return true
            end
            local moved = math.min(room, src.count)
            dst.count = dst.count + moved
            src.count = src.count - moved
            if src.count <= 0 then self.invSlots[from] = nil end
            return true
        end

        -- different items: swap
        self.invSlots[to], self.invSlots[from] = src, dst
        return true
    end

    self.splitSlot = function(from, to, count)
        from, to, count = tonumber(from), tonumber(to), tonumber(count)
        if not from or not to or not count then return false end
        if count <= 0 or count ~= math.floor(count) then return false end
        if from == to then return false end
        if not self.isValidSlot(from) or not self.isValidSlot(to) then return false end

        local src = self.invSlots[from]
        if not src or src.count <= count then return false end -- splitting the whole stack is just a move

        local dst = self.invSlots[to]
        local limit = ESX_StackLimit(src.name)

        if dst then
            if dst.name ~= src.name then return false end
            local room = limit - dst.count
            if room <= 0 then return false end
            count = math.min(count, room)
            dst.count = dst.count + count
        else
            count = math.min(count, limit)
            self.invSlots[to] = { name = src.name, count = count }
        end

        src.count = src.count - count
        if src.count <= 0 then self.invSlots[from] = nil end
        return true
    end

    ----------------------------------------------------------------
    -- serialization for the client / for the DB
    ----------------------------------------------------------------
    self.getSlots = function()
        local out = {}
        for slot, entry in pairs(self.invSlots) do
            out[tostring(slot)] = { name = entry.name, count = entry.count }
        end
        return out
    end

    --- What the player owns but that has no cell (grid full). The UI
    --- shows these in a separate strip so nothing is ever invisible.
    self.getUnplaced = function()
        local placed = {}
        for _, entry in pairs(self.invSlots) do
            placed[entry.name] = (placed[entry.name] or 0) + entry.count
        end
        local out = {}
        for i = 1, #self.inventory do
            local e = self.inventory[i]
            local c = tonumber(e.count) or 0
            if c > 0 then
                local diff = c - (placed[e.name] or 0)
                if diff > 0 then
                    out[#out + 1] = { name = e.name, count = diff }
                    placed[e.name] = (placed[e.name] or 0) + diff
                end
            end
        end
        return out
    end

    self.reconcileSlots()
end
