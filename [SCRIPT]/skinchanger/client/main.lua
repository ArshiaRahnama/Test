-- skinchanger
-- Feature set matches the "sun" skinchanger (face features, eye colour, all head/body
-- overlays, watches, bracelets, loadStuff / loadClothes2 / loadSkin2 / onSkinChange ...)
-- but has NO dependency on suncore / sunset_* resources.

ESX = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

------------------------------------------------------------------
--                        Components
------------------------------------------------------------------
-- row(label, name, defaultValue, min, zoomOffset, camOffset [, extra])
local function row(label, name, value, min, zoomOffset, camOffset, extra)
  local c = {
    label      = _U(label),
    name       = name,
    value      = value,
    min        = min,
    zoomOffset = zoomOffset,
    camOffset  = camOffset,
  }
  if extra then
    for k, v in pairs(extra) do c[k] = v end
  end
  return c
end

local Components = {
  row('sex',                   'sex',            0,   0,   0.6,  0.65),
  row('mom',                   'face_1',         0,   0,   0.6,  0.65),
  row('dad',                   'face_2',         0,   0,   0.6,  0.65),
  row('resemblance',           'face_3',         0,   0,   0.6,  0.65),
  row('skin',                  'skin',           0,   0,   0.6,  0.65),
  row('hair_1',                'hair_1',         0,   0,   0.6,  0.65),
  row('hair_2',                'hair_2',         0,   0,   0.6,  0.65, { textureof = 'hair_1' }),
  row('hair_color_1',          'hair_color_1',   0,   0,   0.6,  0.65),
  row('hair_color_2',          'hair_color_2',   0,   0,   0.6,  0.65),
  row('tshirt_1',              'tshirt_1',       0,   0,   0.75, 0.15),
  row('tshirt_2',              'tshirt_2',       0,   0,   0.75, 0.15, { textureof = 'tshirt_1' }),
  row('torso_1',               'torso_1',        0,   0,   0.75, 0.15),
  row('torso_2',               'torso_2',        0,   0,   0.75, 0.15, { textureof = 'torso_1' }),
  row('decals_1',              'decals_1',       0,   0,   0.75, 0.15),
  row('decals_2',              'decals_2',       0,   0,   0.75, 0.15, { textureof = 'decals_1' }),
  row('arms',                  'arms',           0,   0,   0.75, 0.15),
  row('arms_2',                'arms_2',         0,   0,   0.75, 0.15),
  row('pants_1',               'pants_1',        0,   0,   0.8, -0.5),
  row('pants_2',               'pants_2',        0,   0,   0.8, -0.5,  { textureof = 'pants_1' }),
  row('shoes_1',               'shoes_1',        0,   0,   0.8, -0.8),
  row('shoes_2',               'shoes_2',        0,   0,   0.8, -0.8,  { textureof = 'shoes_1' }),
  row('mask_1',                'mask_1',         0,   0,   0.6,  0.65),
  row('mask_2',                'mask_2',         0,   0,   0.6,  0.65, { textureof = 'mask_1' }),
  row('bproof_1',              'bproof_1',       0,   0,   0.75, 0.15),
  row('bproof_2',              'bproof_2',       0,   0,   0.75, 0.15, { textureof = 'bproof_1' }),
  row('chain_1',               'chain_1',        0,   0,   0.6,  0.65),
  row('chain_2',               'chain_2',        0,   0,   0.6,  0.65, { textureof = 'chain_1' }),
  -- NOTE: esx_skin reads the live prop index for the component that has componentId = 0
  row('helmet_1',              'helmet_1',      -1,  -1,   0.6,  0.65, { componentId = 0 }),
  row('helmet_2',              'helmet_2',       0,   0,   0.6,  0.65, { textureof = 'helmet_1' }),
  row('glasses_1',             'glasses_1',     -1,  -1,   0.6,  0.65),
  row('glasses_2',             'glasses_2',      0,   0,   0.6,  0.65, { textureof = 'glasses_1' }),
  row('watches_1',             'watches_1',     -1,  -1,   0.75, 0.15),
  row('watches_2',             'watches_2',      0,   0,   0.75, 0.15, { textureof = 'watches_1' }),
  row('bracelets_1',           'bracelets_1',   -1,  -1,   0.75, 0.15),
  row('bracelets_2',           'bracelets_2',    0,   0,   0.75, 0.15, { textureof = 'bracelets_1' }),
  row('bag',                   'bags_1',         0,   0,   0.75, 0.15),
  row('bag_color',             'bags_2',         0,   0,   0.75, 0.15, { textureof = 'bags_1' }),
  row('eye_color',             'eye_color',      0,   0,   0.4,  0.65),
  row('eye_squint',            'eye_squint',     0, -10,   0.7,  0.65),
  row('eyebrow_size',          'eyebrows_2',     0,   0,   0.4,  0.65),
  row('eyebrow_type',          'eyebrows_1',     0,   0,   0.4,  0.65),
  row('eyebrow_color_1',       'eyebrows_3',     0,   0,   0.4,  0.65),
  row('eyebrow_color_2',       'eyebrows_4',     0,   0,   0.4,  0.65),
  row('eyebrow_height',        'eyebrows_5',     0, -10,   0.7,  0.65),
  row('eyebrow_depth',         'eyebrows_6',     0, -10,   0.7,  0.65),
  row('makeup_type',           'makeup_1',       0,   0,   0.4,  0.65),
  row('makeup_thickness',      'makeup_2',       0,   0,   0.4,  0.65),
  row('makeup_color_1',        'makeup_3',       0,   0,   0.4,  0.65),
  row('makeup_color_2',        'makeup_4',       0,   0,   0.4,  0.65),
  row('lipstick_type',         'lipstick_1',     0,   0,   0.4,  0.65),
  row('lipstick_thickness',    'lipstick_2',     0,   0,   0.4,  0.65),
  row('lipstick_color_1',      'lipstick_3',     0,   0,   0.4,  0.65),
  row('lipstick_color_2',      'lipstick_4',     0,   0,   0.4,  0.65),
  row('ear_accessories',       'ears_1',        -1,  -1,   0.4,  0.65),
  row('ear_accessories_color', 'ears_2',         0,   0,   0.4,  0.65, { textureof = 'ears_1' }),
  row('chest_hair',            'chest_1',        0,   0,   0.75, 0.15),
  row('chest_hair_1',          'chest_2',        0,   0,   0.75, 0.15),
  row('chest_color',           'chest_3',        0,   0,   0.75, 0.15),
  row('bodyb',                 'bodyb_1',        0,   0,   0.75, 0.15),
  row('bodyb_size',            'bodyb_2',        0,   0,   0.75, 0.15),
  row('bodyb_extra',           'bodyb_3',       -1,  -1,   0.7,  0.15),
  row('bodyb_extra_thickness', 'bodyb_4',        0,   0,   0.7,  0.15),
  row('wrinkles',              'age_1',          0,   0,   0.4,  0.65),
  row('wrinkle_thickness',     'age_2',          0,   0,   0.4,  0.65),
  row('blemishes',             'blemishes_1',    0,   0,   0.4,  0.65),
  row('blemishes_size',        'blemishes_2',    0,   0,   0.4,  0.65),
  row('blush',                 'blush_1',        0,   0,   0.4,  0.65),
  row('blush_1',               'blush_2',        0,   0,   0.4,  0.65),
  row('blush_color',           'blush_3',        0,   0,   0.4,  0.65),
  row('complexion',            'complexion_1',   0,   0,   0.4,  0.65),
  row('complexion_1',          'complexion_2',   0,   0,   0.4,  0.65),
  row('sun',                   'sun_1',          0,   0,   0.4,  0.65),
  row('sun_1',                 'sun_2',          0,   0,   0.4,  0.65),
  row('freckles',              'moles_1',        0,   0,   0.4,  0.65),
  row('freckles_1',            'moles_2',        0,   0,   0.4,  0.65),
  row('beard_type',            'beard_1',        0,   0,   0.4,  0.65),
  row('beard_size',            'beard_2',        0,   0,   0.4,  0.65),
  row('beard_color_1',         'beard_3',        0,   0,   0.4,  0.65),
  row('beard_color_2',         'beard_4',        0,   0,   0.4,  0.65),
  row('nose_1',                'nose_1',         0, -10,   0.8,  0.65),
  row('nose_2',                'nose_2',         0, -10,   0.8,  0.65),
  row('nose_3',                'nose_3',         0, -10,   0.8,  0.65),
  row('nose_4',                'nose_4',         0, -10,   0.8,  0.65),
  row('nose_5',                'nose_5',         0, -10,   0.8,  0.65),
  row('nose_6',                'nose_6',         0, -10,   0.8,  0.65),
  row('cheeks_1',              'cheeks_1',       0, -10,   0.7,  0.65),
  row('cheeks_2',              'cheeks_2',       0, -10,   0.7,  0.65),
  row('cheeks_3',              'cheeks_3',       0, -10,   0.7,  0.65),
  row('lip_fullness',          'lip_thickness',  0, -10,   0.7,  0.65),
  row('jaw_bone_width',        'jaw_1',          0, -10,   0.7,  0.65),
  row('jaw_bone_length',       'jaw_2',          0, -10,   0.7,  0.65),
  row('chin_height',           'chin_1',         0, -10,   0.7,  0.65),
  row('chin_length',           'chin_2',         0, -10,   0.7,  0.65),
  row('chin_width',            'chin_3',         0, -10,   0.7,  0.65),
  row('chin_hole',             'chin_4',         0, -10,   0.7,  0.65),
  row('neck_thickness',        'neck_thickness', 0, -10,   0.7,  0.65),
}

local Defaults = {}
for i = 1, #Components, 1 do
  Defaults[Components[i].name] = Components[i].value
end

-- Keys that loadClothes / loadStuff are allowed to overwrite (everything that is clothing/props).
local ClothingKeys = {}
for _, k in ipairs({
  'tshirt_1', 'tshirt_2', 'torso_1', 'torso_2', 'decals_1', 'decals_2', 'arms', 'arms_2',
  'pants_1', 'pants_2', 'shoes_1', 'shoes_2', 'mask_1', 'mask_2', 'bproof_1', 'bproof_2',
  'chain_1', 'chain_2', 'helmet_1', 'helmet_2', 'glasses_1', 'glasses_2',
  'watches_1', 'watches_2', 'bracelets_1', 'bracelets_2', 'bags_1', 'bags_2',
  'ears_1', 'ears_2',
}) do ClothingKeys[k] = true end

-- Keys that make up the face/body (used by loadSkin2).
local FaceKeys = {}
for i = 1, #Components, 1 do
  local name = Components[i].name
  if not ClothingKeys[name] then FaceKeys[name] = true end
end

local LastSex     = -1
local LoadSkin    = nil
local LoadClothes = nil
local Character   = {}

for name, value in pairs(Defaults) do
  Character[name] = value
end

-- numeric accessor: never hands nil / a string to a native
local function N(key)
  local v = tonumber(Character[key])
  if v == nil then v = Defaults[key] or 0 end
  return v
end

------------------------------------------------------------------
--                        Helpers
------------------------------------------------------------------
local function modelNameForSex(sex)
  if sex == 0 then return 'mp_m_freemode_01' end
  return 'mp_f_freemode_01'
end

-- Female hair remap (same table skincreator uses for its preview).
local function ResolveHair(hair, sex)
  if sex == 1 and Config.FemaleHairRemap then
    if     hair == 0  then return 39
    elseif hair == 1  then return 40
    elseif hair == 2  then return 41
    elseif hair == 3  then return 42
    elseif hair == 38 then return 2
    elseif hair == 39 then return 1
    elseif hair == 40 then return 0
    elseif hair >= 24 then return hair + 1
    end
  end
  return hair
end

local function overlayIndex(v)
  if v < 0 then return 255 end
  return v
end

local function drawMax(ped, componentId)
  return math.max(GetNumberOfPedDrawableVariations(ped, componentId) - 1, 0)
end

local function texMax(ped, componentId, drawable)
  return math.max(GetNumberOfPedTextureVariations(ped, componentId, drawable) - 1, 0)
end

local function propMax(ped, propId)
  return GetNumberOfPedPropDrawableVariations(ped, propId) - 1
end

local function propTexMax(ped, propId, drawable)
  if drawable < 0 then return 0 end
  return math.max(GetNumberOfPedPropTextureVariations(ped, propId, drawable) - 1, 0)
end

local function setProp(ped, propId, drawable, texture)
  if drawable < 0 then
    ClearPedProp(ped, propId)
  else
    SetPedPropIndex(ped, propId, drawable, texture, true)
  end
end

------------------------------------------------------------------
--                        Model
------------------------------------------------------------------
function LoadDefaultModel(loadMale, cb)
  local characterModel = GetHashKey(modelNameForSex(loadMale and 0 or 1))

  RequestModel(characterModel)

  Citizen.CreateThread(function()
    local timeout = GetGameTimer() + 15000

    while not HasModelLoaded(characterModel) and GetGameTimer() < timeout do
      RequestModel(characterModel)
      Citizen.Wait(0)
    end

    if HasModelLoaded(characterModel) and IsModelInCdimage(characterModel) and IsModelValid(characterModel) then
      SetPlayerModel(PlayerId(), characterModel)
      -- the ped handle changes with the model: always re-fetch it
      SetPedDefaultComponentVariation(PlayerPedId())
    end

    SetModelAsNoLongerNeeded(characterModel)

    if cb ~= nil then
      cb()
    end

    TriggerEvent('skinchanger:modelLoaded')
  end)
end

-- true when the ped is not (yet) the freemode model this sex needs
local function needsModel(sex)
  return sex ~= LastSex or GetEntityModel(PlayerPedId()) ~= GetHashKey(modelNameForSex(sex))
end

------------------------------------------------------------------
--                        Max values
------------------------------------------------------------------
function GetMaxVals()
  local ped = PlayerPedId()

  local data = {
    sex            = 1,
    face_1         = 45,
    face_2         = 45,
    face_3         = 10,
    skin           = 45,
    nose_1         = 10,
    nose_2         = 10,
    nose_3         = 10,
    nose_4         = 10,
    nose_5         = 10,
    nose_6         = 10,
    cheeks_1       = 10,
    cheeks_2       = 10,
    cheeks_3       = 10,
    lip_thickness  = 10,
    jaw_1          = 10,
    jaw_2          = 10,
    chin_1         = 10,
    chin_2         = 10,
    chin_3         = 10,
    chin_4         = 10,
    neck_thickness = 10,
    age_1          = GetNumHeadOverlayValues(3) - 1,
    age_2          = 10,
    beard_1        = GetNumHeadOverlayValues(1) - 1,
    beard_2        = 10,
    beard_3        = GetNumHairColors() - 1,
    beard_4        = GetNumHairColors() - 1,
    hair_1         = drawMax(ped, 2),
    hair_2         = texMax(ped, 2, ResolveHair(N('hair_1'), N('sex'))),
    hair_color_1   = GetNumHairColors() - 1,
    hair_color_2   = GetNumHairColors() - 1,
    eye_color      = 31,
    eye_squint     = 10,
    eyebrows_1     = GetNumHeadOverlayValues(2) - 1,
    eyebrows_2     = 10,
    eyebrows_3     = GetNumHairColors() - 1,
    eyebrows_4     = GetNumHairColors() - 1,
    eyebrows_5     = 10,
    eyebrows_6     = 10,
    makeup_1       = GetNumHeadOverlayValues(4) - 1,
    makeup_2       = 10,
    makeup_3       = GetNumHairColors() - 1,
    makeup_4       = GetNumHairColors() - 1,
    lipstick_1     = GetNumHeadOverlayValues(8) - 1,
    lipstick_2     = 10,
    lipstick_3     = GetNumHairColors() - 1,
    lipstick_4     = GetNumHairColors() - 1,
    blemishes_1    = GetNumHeadOverlayValues(0) - 1,
    blemishes_2    = 10,
    blush_1        = GetNumHeadOverlayValues(5) - 1,
    blush_2        = 10,
    blush_3        = GetNumHairColors() - 1,
    complexion_1   = GetNumHeadOverlayValues(6) - 1,
    complexion_2   = 10,
    sun_1          = GetNumHeadOverlayValues(7) - 1,
    sun_2          = 10,
    moles_1        = GetNumHeadOverlayValues(9) - 1,
    moles_2        = 10,
    chest_1        = GetNumHeadOverlayValues(10) - 1,
    chest_2        = 10,
    chest_3        = GetNumHairColors() - 1,
    bodyb_1        = GetNumHeadOverlayValues(11) - 1,
    bodyb_2        = 10,
    bodyb_3        = GetNumHeadOverlayValues(12) - 1,
    bodyb_4        = 10,
    ears_1         = propMax(ped, 2),
    ears_2         = propTexMax(ped, 2, N('ears_1')),
    tshirt_1       = drawMax(ped, 8),
    tshirt_2       = texMax(ped, 8, N('tshirt_1')),
    torso_1        = drawMax(ped, 11),
    torso_2        = texMax(ped, 11, N('torso_1')),
    decals_1       = drawMax(ped, 10),
    decals_2       = texMax(ped, 10, N('decals_1')),
    arms           = drawMax(ped, 3),
    arms_2         = 10,
    pants_1        = drawMax(ped, 4),
    pants_2        = texMax(ped, 4, N('pants_1')),
    shoes_1        = drawMax(ped, 6),
    shoes_2        = texMax(ped, 6, N('shoes_1')),
    mask_1         = drawMax(ped, 1),
    mask_2         = texMax(ped, 1, N('mask_1')),
    bproof_1       = drawMax(ped, 9),
    bproof_2       = texMax(ped, 9, N('bproof_1')),
    chain_1        = drawMax(ped, 7),
    chain_2        = texMax(ped, 7, N('chain_1')),
    bags_1         = drawMax(ped, 5),
    bags_2         = texMax(ped, 5, N('bags_1')),
    helmet_1       = propMax(ped, 0),
    helmet_2       = propTexMax(ped, 0, N('helmet_1')),
    glasses_1      = propMax(ped, 1),
    glasses_2      = propTexMax(ped, 1, N('glasses_1')),
    watches_1      = propMax(ped, 6),
    watches_2      = propTexMax(ped, 6, N('watches_1')),
    bracelets_1    = propMax(ped, 7),
    bracelets_2    = propTexMax(ped, 7, N('bracelets_1')),
  }

  return data
end

------------------------------------------------------------------
--                        Apply
------------------------------------------------------------------
-- head overlays: id, index key, opacity key, [colour type, colour keys]
local Overlays = {
  { id = 3,  idx = 'age_1',        op = 'age_2' },
  { id = 0,  idx = 'blemishes_1',  op = 'blemishes_2' },
  { id = 1,  idx = 'beard_1',      op = 'beard_2',      ct = 1, c1 = 'beard_3',    c2 = 'beard_4' },
  { id = 2,  idx = 'eyebrows_1',   op = 'eyebrows_2',   ct = 1, c1 = 'eyebrows_3', c2 = 'eyebrows_4' },
  { id = 4,  idx = 'makeup_1',     op = 'makeup_2',     ct = 1, c1 = 'makeup_3',   c2 = 'makeup_4' },
  { id = 8,  idx = 'lipstick_1',   op = 'lipstick_2',   ct = 1, c1 = 'lipstick_3', c2 = 'lipstick_4' },
  { id = 5,  idx = 'blush_1',      op = 'blush_2',      ct = 2, c1 = 'blush_3' },
  { id = 6,  idx = 'complexion_1', op = 'complexion_2' },
  { id = 7,  idx = 'sun_1',        op = 'sun_2' },
  { id = 9,  idx = 'moles_1',      op = 'moles_2' },
  { id = 10, idx = 'chest_1',      op = 'chest_2',      ct = 1, c1 = 'chest_3' },
  { id = 11, idx = 'bodyb_1',      op = 'bodyb_2' },
  { id = 12, idx = 'bodyb_3',      op = 'bodyb_4' },
}

-- face features: GTA feature index -> skin key
local FaceFeatures = {
  [0]  = 'nose_1',  [1]  = 'nose_2',  [2]  = 'nose_3',  [3]  = 'nose_4',  [4] = 'nose_5',  [5] = 'nose_6',
  [6]  = 'eyebrows_5', [7] = 'eyebrows_6',
  [8]  = 'cheeks_1', [9] = 'cheeks_2', [10] = 'cheeks_3',
  [11] = 'eye_squint', [12] = 'lip_thickness',
  [13] = 'jaw_1',   [14] = 'jaw_2',
  [15] = 'chin_1',  [16] = 'chin_2',  [17] = 'chin_3',  [18] = 'chin_4',
  [19] = 'neck_thickness',
}

-- clothing slots: componentId, drawable key, texture key
local ClothSlots = {
  { 8,  'tshirt_1', 'tshirt_2' },
  { 11, 'torso_1',  'torso_2' },
  { 3,  'arms',     'arms_2' },
  { 10, 'decals_1', 'decals_2' },
  { 4,  'pants_1',  'pants_2' },
  { 6,  'shoes_1',  'shoes_2' },
  { 1,  'mask_1',   'mask_2' },
  { 9,  'bproof_1', 'bproof_2' },
  { 7,  'chain_1',  'chain_2' },
  { 5,  'bags_1',   'bags_2' },
}

-- props: propId, drawable key, texture key
local PropSlots = {
  { 0, 'helmet_1',    'helmet_2' },
  { 1, 'glasses_1',   'glasses_2' },
  { 2, 'ears_1',      'ears_2' },
  { 6, 'watches_1',   'watches_2' },
  { 7, 'bracelets_1', 'bracelets_2' },
}

local applying = false -- guard: no recursion through onSkinChange

function ApplySkin(skin, clothes)
  local ped = PlayerPedId()

  if skin ~= nil then
    for k, v in pairs(skin) do
      Character[k] = v
    end
  end

  if clothes ~= nil then
    for k, v in pairs(clothes) do
      if ClothingKeys[k] then
        Character[k] = v
      end
    end
  end

  local sex = N('sex')

  -- face
  local face3 = N('face_3') * 0.1
  SetPedHeadBlendData(ped, N('face_1'), N('face_2'), 0, N('skin'), N('skin'), N('skin'), face3, face3, 0.0, true)

  for featureId, key in pairs(FaceFeatures) do
    SetPedFaceFeature(ped, featureId, (N(key) / 10) + 0.0)
  end

  SetPedHairColor(ped, N('hair_color_1'), N('hair_color_2'))
  SetPedEyeColor(ped, N('eye_color'))

  -- overlays
  for _, o in ipairs(Overlays) do
    SetPedHeadOverlay(ped, o.id, overlayIndex(N(o.idx)), (N(o.op) / 10) + 0.0)

    if o.ct then
      SetPedHeadOverlayColor(ped, o.id, o.ct, N(o.c1), o.c2 and N(o.c2) or 0)
    end
  end

  -- hair
  SetPedComponentVariation(ped, 2, ResolveHair(N('hair_1'), sex), N('hair_2'), 2)

  -- clothing
  for _, slot in ipairs(ClothSlots) do
    SetPedComponentVariation(ped, slot[1], N(slot[2]), N(slot[3]), 2)
  end

  -- props
  for _, slot in ipairs(PropSlots) do
    setProp(ped, slot[1], N(slot[2]), N(slot[3]))
  end

  if not applying then
    applying = true
    TriggerEvent('onSkinChange')
    applying = false
  end
end

------------------------------------------------------------------
--                        Events
------------------------------------------------------------------
AddEventHandler('skinchanger:loadDefaultModel', function(loadMale, cb)
  LoadDefaultModel(loadMale, cb)
end)

AddEventHandler('skinchanger:getData', function(cb)
  local components = json.decode(json.encode(Components))

  for i = 1, #components, 1 do
    local v = Character[components[i].name]
    if v ~= nil then
      components[i].value = v
    end
  end

  cb(components, GetMaxVals())
end)

AddEventHandler('skinchanger:change', function(key, val)
  Character[key] = val

  if key == 'sex' then
    TriggerEvent('skinchanger:loadSkin', Character)
  else
    ApplySkin(Character)
  end
end)

AddEventHandler('skinchanger:getSkin', function(cb)
  cb(Character)
end)

AddEventHandler('skinchanger:modelLoaded', function()
  ClearPedProp(PlayerPedId(), 0)

  if LoadSkin ~= nil then
    local skin = LoadSkin
    LoadSkin = nil
    ApplySkin(skin)
  end

  if LoadClothes ~= nil then
    local pending = LoadClothes
    LoadClothes = nil
    ApplySkin(pending.playerSkin, pending.clothesSkin)
  end
end)

RegisterNetEvent('skinchanger:loadSkin')
AddEventHandler('skinchanger:loadSkin', function(skin, cb)
  skin = skin or {}

  -- keys missing from this skin fall back to defaults, so values of the previous
  -- character (or of an old skin saved before a feature existed) never leak through
  for name, default in pairs(Defaults) do
    if skin[name] == nil then
      Character[name] = default
    end
  end

  local sex = tonumber(skin['sex']) or 0
  skin['sex'] = sex

  if needsModel(sex) then
    LoadSkin = skin
    LoadDefaultModel(sex == 0, cb)
  else
    ApplySkin(skin)

    if cb ~= nil then
      cb()
    end
  end

  LastSex = sex
end)

local function loadClothesInternal(playerSkin, clothesSkin)
  playerSkin = playerSkin or {}
  local sex = tonumber(playerSkin['sex']) or N('sex')

  if needsModel(sex) then
    LoadClothes = {
      playerSkin  = playerSkin,
      clothesSkin = clothesSkin
    }
    LoadDefaultModel(sex == 0)
  else
    ApplySkin(playerSkin, clothesSkin)
  end

  LastSex = sex
end

RegisterNetEvent('skinchanger:loadClothes')
AddEventHandler('skinchanger:loadClothes', function(playerSkin, clothesSkin)
  TriggerEvent('skinchanger:clothechange')
  loadClothesInternal(playerSkin, clothesSkin)
end)

RegisterNetEvent('skinchanger:loadClothes2')
AddEventHandler('skinchanger:loadClothes2', function(playerSkin, clothesSkin)
  TriggerEvent('skinchanger:clothechange')
  loadClothesInternal(playerSkin, clothesSkin)
end)

-- apply only some keys on top of the current skin
-- setSkin = true  -> the keys also become part of the stored skin (permanent)
RegisterNetEvent('skinchanger:loadStuff')
AddEventHandler('skinchanger:loadStuff', function(data, setSkin)
  if type(data) ~= 'table' then return end

  TriggerEvent('skinchanger:getSkin', function(skin)
    if setSkin then
      for k, v in pairs(data) do
        skin[k] = v
      end
    end

    TriggerEvent('skinchanger:loadClothes', skin, data)
  end)
end)

-- apply only the face/body part of _skin on top of the current skin
-- fill = true -> keys missing from _skin are reset to defaults first
RegisterNetEvent('skinchanger:loadSkin2')
AddEventHandler('skinchanger:loadSkin2', function(_skin, fill)
  if type(_skin) ~= 'table' then return end

  TriggerEvent('skinchanger:getSkin', function(skin)
    if fill then
      for name, default in pairs(Defaults) do
        if FaceKeys[name] and _skin[name] == nil then
          skin[name] = default
        end
      end
    end

    for k, v in pairs(_skin) do
      if FaceKeys[k] then
        skin[k] = v
      end
    end

    TriggerEvent('skinchanger:loadClothes', skin)
  end)
end)

-- kept for compatibility with scripts written for the sun version
-- (skincreator fires it while the creator is open). Nothing to disable here.
AddEventHandler('skinchanger:disableAC', function(state)
end)

------------------------------------------------------------------
--                        Exports
------------------------------------------------------------------
exports('getSkin', function()
  return Character
end)

exports('getSex', function()
  return Character['sex']
end)

-- reload the saved skin from the database (also repairs a non-freemode ped)
exports('loadPedAndClothe', function()
  if ESX == nil then return end

  ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(lastSkin)
    if lastSkin == nil then return end

    TriggerEvent('skinchanger:loadSkin', lastSkin, function()
      TriggerEvent('esx:restoreLoadout')
    end)
  end)
end)
