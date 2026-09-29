--[[-------------------------------------------------------------------------
  IPL Settings Loader (deobfuscated)

  This module wraps bob74_ipl interior exports and applies "themes" + "options"
  from your AvailableIPLS config.

  What it does:
    - Validates the IPL key exists in AvailableIPLS
    - Gets the bob74_ipl interior export function (AvailableIPLS[iplKey].settings.GetInteriorExport)
    - Clears current style, applies the selected theme
    - Iterates configured options and enables/disables sets (including Swag groups if present)
    - Applies a few special toggles: Chairs, Booze, SafeLeft, SafeRight
    - Refreshes the interior at the configured door coords
    - Executes an optional callback when finished (synchronous)

  NOTE:
    - No server/network events here.
    - No NUI callbacks here.
    - Callback A3_2 is synchronous (just a function invoked at the end).
---------------------------------------------------------------------------]]

local IPL = {}

--[[-------------------------------------------------------------------------
  Apply settings to an interior.

  @param iplKey        string  - Key into AvailableIPLS table
  @param themeName     string  - Theme key used by bob74_ipl's Style.Theme[themeName]
  @param enabledConfig table?  - Previously selected options to enable (per category)
                                Example shape:
                                  {
                                    Chairs = true,
                                    Booze = true,
                                    SafeLeft = true,
                                    SafeRight = false,
                                    ["Plants"] = { "optionA", "optionB" }, -- etc
                                  }
  @param onApplied     function? - Optional callback executed after RefreshInterior()
---------------------------------------------------------------------------]]
function IPL.LoadSettings(iplKey, themeName, enabledConfig, onApplied)
  local iplEntry = AvailableIPLS[iplKey]
  if not iplEntry then
    return false
  end

  local iplSettings = iplEntry.settings

  -- bob74_ipl export lookup:
  -- exports.bob74_ipl[iplSettings.GetInteriorExport]() -> interior object/table
  local interior = exports.bob74_ipl[iplSettings.GetInteriorExport]()

  -- Reset style then set theme
  interior.Style.Clear()
  interior.Style.Set(interior.Style.Theme[themeName], true, false)

  -- Apply option categories (if defined in settings)
  if iplSettings.options then
    for categoryName, categoryOptions in pairs(iplSettings.options) do
      -- For each category we build:
      --   disableList: everything in this category (used to disable Swag at end)
      --   enableList: items that should be enabled (from enabledConfig)
      local disableList = {}
      local enableList = {}

      -- Special handling: if bob74_ipl provides interior.Swag[categoryName]
      -- then we treat the category as Swag-able group.
      if interior.Swag and interior.Swag[categoryName] then
        -- Build disableList = all swag items in that category
        for _, swagItem in pairs(interior.Swag[categoryName]) do
          disableList[categoryName] = disableList[categoryName] or {}
          table.insert(disableList[categoryName], swagItem)
        end
      else
        -- Non-swag categories are expected to be tables like:
        -- interior[categoryName][optionKey] = someSet
        if interior[categoryName] then
          for optionKey, _ in pairs(categoryOptions) do
            local matched = false

            -- If enabledConfig specifies selected option keys for this category,
            -- we move them into enableList.
            if enabledConfig and enabledConfig[categoryName] then
              for _, selectedKey in ipairs(enabledConfig[categoryName]) do
                if optionKey == selectedKey then
                  matched = true
                  table.insert(enableList, interior[categoryName][optionKey])
                  break
                end
              end
            end

            -- Everything else goes into disableList (default-off set list)
            if not matched then
              disableList[categoryName] = disableList[categoryName] or {}
              table.insert(disableList[categoryName], interior[categoryName][optionKey])
            end
          end
        end
      end

      -- If enabledConfig explicitly has this category, apply enabling logic:
      if enabledConfig and enabledConfig[categoryName] ~= nil then
        -- If Swag exists, enable swag items by key and remove them from disableList.
        if interior.Swag then
          for _, selectedKey in ipairs(enabledConfig[categoryName]) do
            -- Only enable keys that exist in settings.options[categoryName]
            if iplSettings.options[categoryName][selectedKey] ~= nil then
              table.insert(enableList, interior.Swag[categoryName][selectedKey])

              -- Remove enabled item from disableList[categoryName]
              local list = disableList[categoryName]
              if list then
                for i = #list, 1, -1 do
                  if list[i] == interior.Swag[categoryName][selectedKey] then
                    table.remove(list, i)
                  end
                end
              end
            end
          end

          interior.Swag.Enable(enableList, true)
        else
          -- Non-swag: if the category supports Enable(list, bool) then call it.
          if interior[categoryName] and interior[categoryName].Enable then
            interior[categoryName].Enable(enableList, true)
          end
        end
      end

      -- Always disable remaining Swag items for this category (matches original)
      if interior.Swag then
        interior.Swag.Enable(disableList[categoryName], false)
      end
    end
  end

  --[[-----------------------------------------------------------------------
    Special toggles configured per interior settings
  -------------------------------------------------------------------------]]

  -- Chairs toggle
  if iplSettings.Chairs ~= nil then
    if enabledConfig and enabledConfig.Chairs then
      interior.Chairs.Set(interior.Chairs.on)
    else
      interior.Chairs.Set(interior.Chairs.off)
    end
  end

  -- Booze toggle (only if .on/.off exist on the interior export)
  if iplSettings.Booze ~= nil then
    if enabledConfig and enabledConfig.Booze then
      if interior.Booze.on ~= nil then
        interior.Booze.Set(interior.Booze.on)
      end
    else
      if interior.Booze.off ~= nil then
        interior.Booze.Set(interior.Booze.off)
      end
    end
  end

  -- Safe door toggles
  if iplSettings.SafeLeft ~= nil then
    if enabledConfig and enabledConfig.SafeLeft then
      interior.Safe.Open("left", true)
    else
      interior.Safe.Close("left", false)
    end
  end

  if iplSettings.SafeRight ~= nil then
    if enabledConfig and enabledConfig.SafeRight then
      interior.Safe.Open("right", true)
    else
      interior.Safe.Close("right", false)
    end
  end

  -- Refresh the interior at configured door coords (forces changes to apply)
  local doors = AvailableIPLS[iplKey].doors
  local interiorId = GetInteriorAtCoords(doors.x, doors.y, doors.z)
  RefreshInterior(interiorId)

  -- [SYNC CALLBACK] called after refresh
  if onApplied then
    onApplied()
  end

  -- Original didn’t return a value on success; keep that behavior (nil).
end

--[[-------------------------------------------------------------------------
  Reset the interior to default bob74_ipl settings for this IPL key
---------------------------------------------------------------------------]]
function IPL.UnloadSettings(iplKey)
  local iplEntry = AvailableIPLS[iplKey]
  if not iplEntry then
    return false
  end

  local interior = exports.bob74_ipl[iplEntry.settings.GetInteriorExport]()
  interior.LoadDefault()
end

-- Export global (matches original)
_G.IPL = IPL