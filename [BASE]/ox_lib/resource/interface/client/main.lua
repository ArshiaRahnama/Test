--[[
    https://github.com/overextended/ox_lib

    This file is licensed under LGPL-3.0 or higher <https://www.gnu.org/licenses/lgpl-3.0.en.html>

    Copyright © 2025 Linden <https://github.com/thelindat>
]]

---@alias IconProp 'fas' | 'far' | 'fal' | 'fat' | 'fad' | 'fab' | 'fak' | 'fass'

local keepInput = IsNuiFocusKeepingInput()

function lib.setNuiFocus(allowInput, disableCursor)
    keepInput = IsNuiFocusKeepingInput()
    SetNuiFocus(true, not disableCursor)
    SetNuiFocusKeepInput(allowInput)
    LocalPlayer.state.nui = true
end

function lib.resetNuiFocus()
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(keepInput)
    LocalPlayer.state.nui = nil
end
