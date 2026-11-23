--[[
    Apex Scriptz - apex_clothing
    Apex Clothing Studio: an in-game clothing texture designer.
    Live ped stage with orbit camera, full wardrobe browser, a
    layer-based 1024px canvas editor (brush, text, shapes, fills,
    patterns, images), instant DUI live preview on the ped, AI
    texture generation, project saving/sharing, and one-click
    export to a live retexture resource or a portable package.

    Compatible with ESX Legacy, QBCore, and QBox (standalone
    fallback included). No database required - projects, the
    gallery and share codes persist to plain JSON in data/.
]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author      'Apex Scriptz'
description 'In-game clothing texture designer (canvas editor, live preview, AI, export)'
version     '2.1.6'

-- Locales are listed ONE BY ONE on purpose (no 'build/locales/*.lua'
-- glob): a glob loads every file twice when the explicit entries are
-- present, and escrow treats patterns literally - a globbed language
-- can end up locked and unfixable for whoever buys the script.
shared_scripts {
    'shared/config.lua',
    'shared/framework.lua',
    'shared/utils.lua',
    'shared/access.lua',
    'build/locales/en.lua',      -- base language + fallback for all others
    'build/locales/pt.lua',      -- Português (PT)
    'build/locales/pt-br.lua',   -- Português (BR)
    'build/locales/es.lua',      -- Español
    'build/locales/fr.lua',      -- Français
    'build/locales/de.lua',      -- Deutsch
    'build/locales/it.lua',      -- Italiano
    'build/locales/ja.lua',      -- 日本語
    'build/locales/tr.lua',      -- Türkçe
}

client_scripts {
    'build/client/apex_lib.lua',
    'build/client/main.lua',
    'build/client/stage.lua',
    'build/client/wardrobe.lua',
    'build/client/preview.lua',
    'build/client/livetex.lua',      -- real-time "Live on Server" retextures
    'build/client/exports.lua',
}

server_scripts {
    'build/server/apex_lib.lua',
    'build/server/main.lua',
    'build/server/templates.lua',
    'build/server/packs.lua',        -- model-pack start-up check (ensure lines, 2 GiB cliff)
    'build/server/projects.lua',     -- includes the zero-setup file store (no oxmysql)
    'build/server/ai.lua',
    'build/server/export.lua',
}

ui_page 'build/html/index.html'

files {
    'build/html/index.html',
    'build/html/dui.html',
    'build/html/css/*.css',
    'build/html/js/*.js',
    -- Self-hosted three.js, Font Awesome and the web fonts. If this
    -- line is missing the NUI serves 404s for all of them and the
    -- studio opens with no icons and a dead 3D viewer.
    'build/html/vendor/**/*',
    -- Guaranteed template catalog the NUI fetches directly (works
    -- even if server-side folder scanning is unavailable).
    'templates.json',
    -- 3D viewer templates (.glb/.png) are NOT listed here on purpose.
    -- Since 2.1.5 tools/convert.js writes them into separate MODEL PACK
    -- resources (apex_clothing_models, _models2...) that you `ensure`
    -- next to this one. A resource whose files{} pass 2 GiB gets a
    -- corrupt resource.rpf and every client CRASHES (vfs-core.dll) the
    -- moment the studio opens. 2.1.5 still globbed stream/models/** for
    -- older installs, and a 3.9 GB stream/models/ on one server did
    -- exactly that - so from 2.1.6 nothing under stream/models/ can
    -- reach files{} any more. An older install whose models still sit
    -- there runs tools/convert.js once: it moves them into packs
    -- (nothing is re-converted) and rewrites templates.json. Until
    -- then the server console says so on every start.
    'stream/models/models.json',
    -- ShopPedApparel metas for clothes you drop in stream/ (see
    -- stream/README.md). The .ydd/.ytd/.ymt auto-stream from the
    -- stream/ folder; only the shop .meta needs listing + a
    -- data_file line below.
    'stream/**/*.meta',
}

-- ─── Streamed clothing templates ────────────────────────────
-- Put your addon clothing in stream/ so it appears on the ped and
-- becomes selectable/editable in the studio. For EACH pack, add a
-- line pointing at its ShopPedApparel meta, e.g.:
--
--   data_file 'SHOP_PED_APPAREL_META_FILE' 'stream/mp_m_freemode_01_apex_templates.meta'
--
-- Leave these commented until you actually add a meta, otherwise
-- the resource logs a missing-file warning on start.

-- Projects/gallery persist to plain JSON files (data/) - no oxmysql,
-- no SQL import, works out of the box on any server / OS.
dependencies {
    '/server:5104',
}

provide 'apex_clothing'

-- ===========================================================================
-- ESCROWED BUILD
-- Only what you are meant to edit stays readable: this manifest, the README,
-- shared/config.lua, shared/framework.lua, shared/access.lua, every locale,
-- build/client/apex_lib.lua (the notification bridge: toast, chat or your
-- own notify system), the tools/ converters (they run on your PC), templates/,
-- stream/, data/, exports/, the catalog (templates.json) and the third-party
-- libraries under build/html/vendor/. The build itself (build/client,
-- build/server, shared/utils.lua and the NUI) is protected by FiveM escrow.
-- ===========================================================================
escrow_ignore {
    'LICENSE',
    'README.md',
    'build/client/apex_lib.lua',
    'build/html/vendor/fontawesome/css/all.min.css',
    'build/html/vendor/fontawesome/webfonts/fa-brands-400.ttf',
    'build/html/vendor/fontawesome/webfonts/fa-brands-400.woff2',
    'build/html/vendor/fontawesome/webfonts/fa-regular-400.ttf',
    'build/html/vendor/fontawesome/webfonts/fa-regular-400.woff2',
    'build/html/vendor/fontawesome/webfonts/fa-solid-900.ttf',
    'build/html/vendor/fontawesome/webfonts/fa-solid-900.woff2',
    'build/html/vendor/fontawesome/webfonts/fa-v4compatibility.ttf',
    'build/html/vendor/fontawesome/webfonts/fa-v4compatibility.woff2',
    'build/html/vendor/fonts/files/v16_Fh4uPib9Iyv2ucM6pGQMWimMp004La2Cfw.woff2',
    'build/html/vendor/fonts/files/v16_JTUSjIg69CK48gW7PXoo9Wdhyzbi.woff2',
    'build/html/vendor/fonts/files/v16_JTUSjIg69CK48gW7PXoo9Wlhyw.woff2',
    'build/html/vendor/fonts/files/v18_1cXxaUPXBpj2rGoU7C9WhnGFucE.woff2',
    'build/html/vendor/fonts/files/v18_1cXxaUPXBpj2rGoU7C9WiHGF.woff2',
    'build/html/vendor/fonts/files/v20_UcC73FwrK3iLTeHuS_nVMrMxCp50SjIa0ZL7SUc.woff2',
    'build/html/vendor/fonts/files/v20_UcC73FwrK3iLTeHuS_nVMrMxCp50SjIa1ZL7.woff2',
    'build/html/vendor/fonts/files/v20_UcC73FwrK3iLTeHuS_nVMrMxCp50SjIa1pL7SUc.woff2',
    'build/html/vendor/fonts/files/v20_UcC73FwrK3iLTeHuS_nVMrMxCp50SjIa25L7SUc.woff2',
    'build/html/vendor/fonts/files/v20_UcC73FwrK3iLTeHuS_nVMrMxCp50SjIa2JL7SUc.woff2',
    'build/html/vendor/fonts/files/v20_UcC73FwrK3iLTeHuS_nVMrMxCp50SjIa2ZL7SUc.woff2',
    'build/html/vendor/fonts/files/v20_UcC73FwrK3iLTeHuS_nVMrMxCp50SjIa2pL7SUc.woff2',
    'build/html/vendor/fonts/files/v23_FwZY7-Qmy14u9lezJ-6D6MmTpA.woff2',
    'build/html/vendor/fonts/files/v23_FwZY7-Qmy14u9lezJ-6H6Mk.woff2',
    'build/html/vendor/fonts/files/v23_FwZY7-Qmy14u9lezJ-6I6MmTpA.woff2',
    'build/html/vendor/fonts/files/v23_FwZY7-Qmy14u9lezJ-6J6MmTpA.woff2',
    'build/html/vendor/fonts/files/v23_FwZY7-Qmy14u9lezJ-6K6MmTpA.woff2',
    'build/html/vendor/fonts/files/v23_HTxqL289NzCGg4MzN6KJ7eW6CYKF_i7y.woff2',
    'build/html/vendor/fonts/files/v23_HTxqL289NzCGg4MzN6KJ7eW6CYyF_g.woff2',
    'build/html/vendor/fonts/files/v23_LYjYdG7kmE0gV69VVPPdFl06VN_JHIS01zO0vg.woff2',
    'build/html/vendor/fonts/files/v23_LYjYdG7kmE0gV69VVPPdFl06VN_JHIS11zM.woff2',
    'build/html/vendor/fonts/files/v23_LYjYdG7kmE0gV69VVPPdFl06VN_JHIS71zO0vg.woff2',
    'build/html/vendor/fonts/files/v24_tDbv2o-flEEny0FZhsfKu5WU4zr3E_BX0PnT8RD8yKwBNntkaToggR7BYRbKPx3cwhsk.woff2',
    'build/html/vendor/fonts/files/v24_tDbv2o-flEEny0FZhsfKu5WU4zr3E_BX0PnT8RD8yKwBNntkaToggR7BYRbKPx7cwhsk.woff2',
    'build/html/vendor/fonts/files/v24_tDbv2o-flEEny0FZhsfKu5WU4zr3E_BX0PnT8RD8yKwBNntkaToggR7BYRbKPxDcwg.woff2',
    'build/html/vendor/fonts/files/v24_tDbv2o-flEEny0FZhsfKu5WU4zr3E_BX0PnT8RD8yKwBNntkaToggR7BYRbKPxPcwhsk.woff2',
    'build/html/vendor/fonts/files/v24_tDbv2o-flEEny0FZhsfKu5WU4zr3E_BX0PnT8RD8yKwBNntkaToggR7BYRbKPxTcwhsk.woff2',
    'build/html/vendor/fonts/files/v24_tDbv2o-flEEny0FZhsfKu5WU4zr3E_BX0PnT8RD8yKwBNntkaToggR7BYRbKPx_cwhsk.woff2',
    'build/html/vendor/fonts/files/v27_1Ptgg87LROyAm3K8-C8QSw.woff2',
    'build/html/vendor/fonts/files/v27_1Ptgg87LROyAm3K9-C8QSw.woff2',
    'build/html/vendor/fonts/files/v27_1Ptgg87LROyAm3Kz-C8.woff2',
    'build/html/vendor/fonts/files/v31_JTUSjIg1_i6t8kCHKm459W1hyzbi.woff2',
    'build/html/vendor/fonts/files/v31_JTUSjIg1_i6t8kCHKm459WRhyzbi.woff2',
    'build/html/vendor/fonts/files/v31_JTUSjIg1_i6t8kCHKm459WZhyzbi.woff2',
    'build/html/vendor/fonts/files/v31_JTUSjIg1_i6t8kCHKm459Wdhyzbi.woff2',
    'build/html/vendor/fonts/files/v31_JTUSjIg1_i6t8kCHKm459Wlhyw.woff2',
    'build/html/vendor/fonts/files/v31_ieVo2ZhZI2eCN5jzbjEETS9weq8-_d6T_POl0fRJeyVVpcBA5XxxKA.woff2',
    'build/html/vendor/fonts/files/v31_ieVo2ZhZI2eCN5jzbjEETS9weq8-_d6T_POl0fRJeyVVpcBB5XxxKA.woff2',
    'build/html/vendor/fonts/files/v31_ieVo2ZhZI2eCN5jzbjEETS9weq8-_d6T_POl0fRJeyVVpcBC5XxxKA.woff2',
    'build/html/vendor/fonts/files/v31_ieVo2ZhZI2eCN5jzbjEETS9weq8-_d6T_POl0fRJeyVVpcBD5XxxKA.woff2',
    'build/html/vendor/fonts/files/v31_ieVo2ZhZI2eCN5jzbjEETS9weq8-_d6T_POl0fRJeyVVpcBK5XxxKA.woff2',
    'build/html/vendor/fonts/files/v31_ieVo2ZhZI2eCN5jzbjEETS9weq8-_d6T_POl0fRJeyVVpcBN5XxxKA.woff2',
    'build/html/vendor/fonts/files/v31_ieVo2ZhZI2eCN5jzbjEETS9weq8-_d6T_POl0fRJeyVVpcBO5Xw.woff2',
    'build/html/vendor/fonts/files/v32_neILzCirqoswsqX9zo-mM5Ez.woff2',
    'build/html/vendor/fonts/files/v32_neILzCirqoswsqX9zo2mM5Ez.woff2',
    'build/html/vendor/fonts/files/v32_neILzCirqoswsqX9zoKmMw.woff2',
    'build/html/vendor/fonts/files/v32_neILzCirqoswsqX9zoamM5Ez.woff2',
    'build/html/vendor/fonts/files/v32_neILzCirqoswsqX9zoymM5Ez.woff2',
    'build/html/vendor/fonts/files/v57_TK3IWkUHHAIjg75cFRf3bXL8LICs1_Fv40pKlN4NNSeSASz7FmlSHYjedg.woff2',
    'build/html/vendor/fonts/files/v57_TK3IWkUHHAIjg75cFRf3bXL8LICs1_Fv40pKlN4NNSeSASz7FmlWHYg.woff2',
    'build/html/vendor/fonts/files/v57_TK3IWkUHHAIjg75cFRf3bXL8LICs1_Fv40pKlN4NNSeSASz7FmlYHYjedg.woff2',
    'build/html/vendor/fonts/files/v57_TK3IWkUHHAIjg75cFRf3bXL8LICs1_Fv40pKlN4NNSeSASz7FmlZHYjedg.woff2',
    'build/html/vendor/fonts/files/v57_TK3IWkUHHAIjg75cFRf3bXL8LICs1_Fv40pKlN4NNSeSASz7FmlbHYjedg.woff2',
    'build/html/vendor/fonts/fonts.css',
    'build/html/vendor/three/GLTFLoader.js',
    'build/html/vendor/three/OrbitControls.js',
    'build/html/vendor/three/three.min.js',
    'build/locales/de.lua',
    'build/locales/en.lua',
    'build/locales/es.lua',
    'build/locales/fr.lua',
    'build/locales/it.lua',
    'build/locales/ja.lua',
    'build/locales/pt-br.lua',
    'build/locales/pt.lua',
    'build/locales/tr.lua',
    'data/.keep',
    'data/state/.keep',
    'exports/.keep',
    'exports/downloads/.keep',
    'fxmanifest.lua',
    'shared/access.lua',
    'shared/config.lua',
    'shared/framework.lua',
    'stream/.keep',
    'stream/README.md',
    'stream/models/.keep',
    'stream/models/models.json',
    'templates.json',
    'templates/.keep',
    'templates/README.md',
    'templates/female/.keep',
    'templates/male/.keep',
    'tools/README.md',
    'tools/YTD_README.md',
    'tools/convert.bat',
    'tools/convert.js',
    'tools/convert.sh',
    'tools/ensure_node.bat',
    'tools/get_node.ps1',
    'tools/make_ytd.bat',
    'tools/make_ytd.js',
    'tools/make_ytd.sh',
    'tools/packs.js',
    'tools/rage.js',
    'tools/sources.txt',
    'tools/ytd_in/.keep',
    'tools/ytd_out/.keep',
}

