--[[-------------------------------------------------------------------------
  Gizmo / DataView utilities (deobfuscated)

  This file does 3 main things:
    1) Builds a small "dataView" helper around FiveM's blob_pack/blob_unpack API
       - Supports typed Get*/Set* for numeric types and strings
       - Supports fixed-length string/int reads & writes (GetFixed*/SetFixed*)

    2) Provides matrix helpers used by the gizmo editor:
       - makeEntityMatrix(entity) -> returns a dataView buffer containing a 4x4 float matrix
       - applyEntityMatrix(entity, matrixView) -> reads that buffer, normalizes axis vectors,
         and applies it back via SetEntityMatrix

    3) Registers key mappings for gizmo select/translate/rotate.

  NOTE:
    - This snippet has no NUI callbacks and no server/network events.
    - It is synchronous (no Citizen threads here).
---------------------------------------------------------------------------]]

-- These look like gizmo state variables used elsewhere in the resource.
-- They are declared here in the original snippet, even if not used in this excerpt.
local isGizmoActive = false
local gizmoOperation = "translate" -- e.g. "translate" (and likely "rotate"/"scale" elsewhere)
local gizmoIsSnapped = false
local gizmoSelection = nil

--[[-------------------------------------------------------------------------
  dataView (blob-backed DataView-like helper)

  Backing storage uses:
    - string.blob(size) to allocate
    - blob:blob_pack(offset, fmt, value)
    - blob:blob_unpack(offset, fmt)

  Offsets:
    - Internally uses 1-based offsets (offset = 1 + byteOffset)
    - Public API takes byte offsets like 0, 4, 8, ...
---------------------------------------------------------------------------]]
local dataView = {
  -- Endianness prefixes for blob_pack/blob_unpack format strings
  EndBig = ">",
  EndLittle = "<",

  Types = {
    Int8    = { code = "i1" },
    Uint8   = { code = "I1" },
    Int16   = { code = "i2" },
    Uint16  = { code = "I2" },
    Int32   = { code = "i4" },
    Uint32  = { code = "I4" },
    Int64   = { code = "i8" },
    Uint64  = { code = "I8" },

    Float32 = { code = "f", size = 4 },
    Float64 = { code = "d", size = 8 },

    LuaInt  = { code = "j" },
    UluaInt = { code = "J" },
    LuaNum  = { code = "n" },

    -- "z" typically means a zero-terminated string in Lua pack formats.
    -- Size = -1 => variable length
    String  = { code = "z", size = -1 },
  },

  -- Fixed-length read/write helpers (caller supplies the length)
  FixedTypes = {
    String = { code = "c" }, -- fixed-length char[] ("cN")
    Int    = { code = "i" },
    Uint   = { code = "I" },
  },
}

dataView.__index = dataView

-- Choose endian prefix; defaults to little if nil/false (matches original)
local function endianPrefix(isBigEndian)
  return isBigEndian and dataView.EndBig or dataView.EndLittle
end

-- Low-level pack/write that can optionally grow the underlying buffer
local function writePacked(self, byteOffset1Based, value, format)
  local newBlob = self.blob:blob_pack(byteOffset1Based, format, value)

  -- Subviews cannot grow; dataviews can (if cangrow=true)
  if not self.cangrow and newBlob ~= self.blob then
    return false
  end

  self.blob = newBlob
  self.length = newBlob:len()
  return true
end

-- Allocate a new blob buffer
function dataView.ArrayBuffer(byteLength)
  return setmetatable({
    blob = string.blob(byteLength),
    length = byteLength,
    offset = 1,     -- internal 1-based base offset
    cangrow = true, -- root views can grow
  }, dataView)
end

-- Wrap an existing blob
function dataView.Wrap(blob)
  return setmetatable({
    blob = blob,
    length = blob:len(),
    offset = 1,
    cangrow = true,
  }, dataView)
end

-- Accessors
function dataView:Buffer()      return self.blob end
function dataView:ByteLength()  return self.length end
function dataView:ByteOffset()  return self.offset end

-- Create a non-growing subview of the same blob
function dataView:SubView(byteOffset, byteLength)
  local length = byteLength or self.length
  return setmetatable({
    blob = self.blob,
    length = length,
    offset = 1 + byteOffset,
    cangrow = false, -- IMPORTANT: subviews cannot grow (matches original)
  }, dataView)
end

-- Allow calling dataView(size) as a shorthand for dataView.ArrayBuffer(size)
setmetatable(dataView, {
  __call = function(_, byteLength)
    return dataView.ArrayBuffer(byteLength)
  end
})

--[[-------------------------------------------------------------------------
  Auto-generate Get<Type>/Set<Type> for dataView.Types
---------------------------------------------------------------------------]]
for typeName, typeInfo in pairs(dataView.Types) do
  -- Cache/validate type sizes where applicable (preserves original checks)
  if typeInfo.size == nil then
    typeInfo.size = string.packsize(typeInfo.code)
  elseif typeInfo.size >= 0 then
    local packSize = string.packsize(typeInfo.code)
    if packSize ~= typeInfo.size then
      error(("Pack size of %s (%d) does not match cached length: (%d)")
        :format(typeName, packSize, typeInfo.size))
      return nil
    end
  end

  local getName = "Get" .. typeName
  local setName = "Set" .. typeName

  -- Read typed value at byte offset
  dataView[getName] = function(self, byteOffset, isBigEndian)
    if byteOffset == nil then byteOffset = 0 end
    if byteOffset < 0 then return nil end

    local absoluteOffset = self.offset + byteOffset
    local fmt = endianPrefix(isBigEndian) .. typeInfo.code
    local value = self.blob:blob_unpack(absoluteOffset, fmt)
    return value
  end

  -- Write typed value at byte offset (may grow unless it's a subview)
  dataView[setName] = function(self, byteOffset, value, isBigEndian)
    if byteOffset >= 0 and value ~= nil then
      local absoluteOffset = self.offset + byteOffset

      -- Determine how many bytes we need for boundary checks on non-growing views
      local size = typeInfo.size
      if size < 0 then
        -- Variable-size (e.g., string): use blob length if available
        local vlen = value:len()
        size = vlen or typeInfo.size
      end

      if not self.cangrow then
        local endPos = absoluteOffset + (size - 1)
        if endPos > self.length then
          error("cannot grow subview")
          return self
        end
      end

      local fmt = endianPrefix(isBigEndian) .. typeInfo.code
      local ok = writePacked(self, absoluteOffset, value, fmt)
      if not ok then
        error("cannot grow dataview")
      end
    end
    return self
  end
end

--[[-------------------------------------------------------------------------
  Auto-generate GetFixed<Type>/SetFixed<Type> for dataView.FixedTypes
  These treat size as caller-provided length (A2_2 in original).
---------------------------------------------------------------------------]]
for typeName, typeInfo in pairs(dataView.FixedTypes) do
  typeInfo.size = -1 -- fixed types are variable based on caller provided length

  local getName = "GetFixed" .. typeName
  local setName = "SetFixed" .. typeName

  dataView[getName] = function(self, byteOffset, length, isBigEndian)
    if byteOffset >= 0 then
      local absoluteOffset = self.offset + byteOffset
      local endPos = absoluteOffset + (length - 1)
      if endPos <= self.length then
        local fmt = endianPrefix(isBigEndian) .. "c" .. tostring(length)
        local value = self.blob:blob_unpack(absoluteOffset, fmt)
        return value
      end
    end
    return nil
  end

  dataView[setName] = function(self, byteOffset, length, value, isBigEndian)
    if byteOffset >= 0 and value ~= nil then
      local absoluteOffset = self.offset + byteOffset

      if not self.cangrow then
        local endPos = absoluteOffset + (length - 1)
        if endPos > self.length then
          error("cannot grow subview")
          return self
        end
      end

      local fmt = endianPrefix(isBigEndian) .. "c" .. tostring(length)
      local ok = writePacked(self, absoluteOffset, value, fmt)
      if not ok then
        error("cannot grow dataview")
      end
    end
    return self
  end
end

--[[-------------------------------------------------------------------------
  normalizeVector3(x, y, z)
  Returns a unit vector, or (0,0,0) if length is 0.
---------------------------------------------------------------------------]]
local function normalizeVector3(x, y, z)
  local len = math.sqrt(x * x + y * y + z * z)
  if len == 0 then
    return 0, 0, 0
  end
  return x / len, y / len, z / len
end

--[[-------------------------------------------------------------------------
  makeEntityMatrix(entity) -> dataView buffer

  Reads entity basis vectors + position from GetEntityMatrix(entity) and packs
  them into a 4x4 float matrix layout:

    [  v2.x  v2.y  v2.z  0 ]
    [  v1.x  v1.y  v1.z  0 ]
    [  v3.x  v3.y  v3.z  0 ]
    [  pos.x pos.y pos.z 1 ]

  Offsets written (Float32): 0..60 step 4 (16 floats)

  IMPORTANT:
    - The original allocates ArrayBuffer(60) even though it writes up to offset 60.
      This is preserved exactly to avoid behavior changes in this environment.
---------------------------------------------------------------------------]]
function makeEntityMatrix(entity)
  local v1, v2, v3, pos = GetEntityMatrix(entity)

  local matrixView = dataView.ArrayBuffer(60)

  matrixView:SetFloat32(0,  v2[1])
  matrixView:SetFloat32(4,  v2[2])
  matrixView:SetFloat32(8,  v2[3])
  matrixView:SetFloat32(12, 0)

  matrixView:SetFloat32(16, v1[1])
  matrixView:SetFloat32(20, v1[2])
  matrixView:SetFloat32(24, v1[3])
  matrixView:SetFloat32(28, 0)

  matrixView:SetFloat32(32, v3[1])
  matrixView:SetFloat32(36, v3[2])
  matrixView:SetFloat32(40, v3[3])
  matrixView:SetFloat32(44, 0)

  matrixView:SetFloat32(48, pos[1])
  matrixView:SetFloat32(52, pos[2])
  matrixView:SetFloat32(56, pos[3])
  matrixView:SetFloat32(60, 1)

  return matrixView
end

--[[-------------------------------------------------------------------------
  applyEntityMatrix(entity, matrixView)

  Reads the matrix buffer produced by makeEntityMatrix(), normalizes the axis
  vectors (to remove scaling), and applies it using SetEntityMatrix.

  SetEntityMatrix signature in FiveM:
    SetEntityMatrix(entity,
      rightX, rightY, rightZ,
      forwardX, forwardY, forwardZ,
      upX, upY, upZ,
      posX, posY, posZ
    )
---------------------------------------------------------------------------]]
function applyEntityMatrix(entity, matrixView)
  -- Read basis vectors + position from the packed matrix
  local rightX  = matrixView:GetFloat32(16)
  local rightY  = matrixView:GetFloat32(20)
  local rightZ  = matrixView:GetFloat32(24)

  local forwardX = matrixView:GetFloat32(0)
  local forwardY = matrixView:GetFloat32(4)
  local forwardZ = matrixView:GetFloat32(8)

  local upX     = matrixView:GetFloat32(32)
  local upY     = matrixView:GetFloat32(36)
  local upZ     = matrixView:GetFloat32(40)

  local posX    = matrixView:GetFloat32(48)
  local posY    = matrixView:GetFloat32(52)
  local posZ    = matrixView:GetFloat32(56)

  -- Normalize axes (preserves original behavior)
  rightX, rightY, rightZ = normalizeVector3(rightX, rightY, rightZ)
  forwardX, forwardY, forwardZ = normalizeVector3(forwardX, forwardY, forwardZ)
  upX, upY, upZ = normalizeVector3(upX, upY, upZ)

  SetEntityMatrix(
    entity,
    rightX, rightY, rightZ,
    forwardX, forwardY, forwardZ,
    upX, upY, upZ,
    posX, posY, posZ
  )
end

--[[-------------------------------------------------------------------------
  Key mappings (gizmo)
---------------------------------------------------------------------------]]

-- Select with mouse left
RegisterKeyMapping(
  "+gizmoSelect",
  TRANSLATE("control.gizmo:select"),
  "MOUSE_BUTTON",
  "MOUSE_LEFT"
)

-- Translation mode toggle
RegisterKeyMapping(
  "+gizmoTranslation",
  TRANSLATE("control.gizmo:translation"),
  "keyboard",
  Config.FurnitureControls.GIZMO_TRANSLATION.control
)

-- Rotation mode toggle
RegisterKeyMapping(
  "+gizmoRotation",
  TRANSLATE("control.gizmo:rotation"),
  "keyboard",
  Config.FurnitureControls.GIZMO_ROTATION.control
)