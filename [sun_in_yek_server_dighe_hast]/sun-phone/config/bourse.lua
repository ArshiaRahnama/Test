-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

-- ============================================================================
-- BOURSE (stock market) CONFIG — everything about the market lives here.
--
-- HOW PRICES MOVE (read this so you know "chi be chie"):
--   • Every stock has a START price (its anchor / fair value, below).
--   • Each tick the price is pulled toward a "fair target" and given a small
--     random wobble, then HARD-CLAMPED so it can never be manipulated:
--        fair target  = start, shifted by the auction house's live supply
--                       (more units listed → cheaper, fewer → pricier) but
--                       only by at most ± SupplyInfluence.  If the auction DB
--                       is EMPTY (your test case) the target is simply `start`,
--                       so the price just wobbles gently around `start`.
--        new price    = price + (target-price)*MeanReversion + random*Volatility
--        per-tick cap = price can move at most ± MaxTickMovePct in one tick
--        hard bounds  = price ALWAYS stays in [start*MinMult , start*MaxMult]
--   The bounds + per-tick cap + capped supply influence are what stop anyone
--   pumping or dumping the market — no one can run a price away.
--
--   Volatility ↑  = bigger swings  = more profit AND more loss (your "sod/zian").
--   Fee        ↑  = more skimmed off every buy & sell.
-- ============================================================================

-- Standalone global (NOT Config.Bourse) so it can't be wiped by config.lua's
-- `Config = {}` regardless of which config file loads first.
ConfigBourse = {
    -- How often (seconds) prices recompute / a new chart candle is added.
    TickSeconds   = 60,
    -- Chart history points kept per stock (TickSeconds * this = chart span).
    HistoryPoints = 90,

    -- Brokerage fee (%) charged on BOTH buy and sell.
    Fee = 1.0,

    -- ----- Price dynamics (all bounded → un-manipulable) -----
    Volatility      = 0.015, -- max random move per tick (0.015 = ±1.5%)
    MeanReversion   = 0.20,  -- 0..1, how hard price is pulled to its fair target
    MaxTickMovePct  = 0.05,  -- hard cap on movement in ONE tick (±5%)
    MinMult         = 0.50,  -- price can NEVER go below start * this
    MaxMult         = 2.00,  -- price can NEVER go above start * this
    SupplyInfluence = 0.25,  -- max the live auction supply can shift target (±25%)
    SupplyReference = 200,   -- auction units that count as "normal" supply

    -- ----- The stocks -----
    -- start = the anchor / starting price for that item. Optional per-stock
    -- overrides: minMult, maxMult, vol (otherwise the globals above apply).
    -- This list IS the market — add/remove/retune freely.
    Stocks = {
        { item = 'sc',                 start = 10000 },
        { item = 'iron',               start = 12500 },
        { item = 'aluminum',           start = 3000  },
        { item = 'gold',               start = 20000 },
        { item = 'diamond',            start = 5000  },
        { item = 'iron_piece',         start = 625   },
        { item = 'alum_oxide',         start = 600   },
        { item = 'gold_piece',         start = 1000  },
        { item = 'ajor',               start = 1     },
        { item = 'jewels',             start = 1000  },
        { item = 'alive_chicken',      start = 800   },
        { item = 'slaughtered_chicken',start = 1000  },
        { item = 'packaged_chicken',   start = 250   },
        { item = 'wool',               start = 100   },
        { item = 'fabric',             start = 600   },
        { item = 'clothe',             start = 2100  },
        { item = 'petrol',             start = 500   },
        { item = 'petrol_raffin',      start = 400   },
        { item = 'essence',            start = 300   },
        { item = 'wood',               start = 150   },
        { item = 'cutted_wood',        start = 200   },
        { item = 'packaged_plank',     start = 1400  },
        { item = 'cannabis',           start = 500   },
        { item = 'marijuana',          start = 265   },
        { item = 'extra_marijuana',    start = 2250  },
        { item = 'coca',               start = 400   },
        { item = 'cocaine',            start = 2000  },
        { item = 'crack',              start = 1250  },
        { item = 'extra_crack',        start = 2500  },
        { item = 'poppy',              start = 300   },
        { item = 'opium',              start = 550   },
        { item = 'heroine',            start = 4000  },
        { item = 'extra_heroine',      start = 3500  },
        { item = 'ephedra',            start = 500   },
        { item = 'ephedrine',          start = 550   },
        { item = 'meth',               start = 5000  },
        { item = 'extra_meth',         start = 5000  },
        { item = 'mushroom',           start = 100   },
        { item = 'mahi_sardine',       start = 435   },
        { item = 'mahi_sangsar',       start = 560   },
        { item = 'mahi_ordak',         start = 570   },
        { item = 'mahi_ghezel',        start = 585   },
        { item = 'mahi_hamoor',        start = 600   },
        { item = 'mahi_sorkhoo',       start = 610   },
        { item = 'mahi_salmon',        start = 625   },
        { item = 'mahi_shooride',      start = 640   },
        { item = 'mahi_tilapia',       start = 660   },
        { item = 'mahi_sefid',         start = 680   },
        { item = 'mahi_shir',          start = 700   },
        { item = 'mahi_meygoo',        start = 720   },
        { item = 'jolbak',             start = 100   },
        { item = 'mahi_fugu',          start = 20000 },
        { item = 'mahi_alidaeii',      start = 30000 },
        { item = 'husky_body',         start = 20000 },
        { item = 'retriever_body',     start = 20000 },
        { item = 'rottweiler_body',    start = 20000 },
        { item = 'shepherd_body',      start = 20000 },
        { item = 'panther_body',       start = 50000 },
        { item = 'boar_body',          start = 15000 },
        { item = 'deer_body',          start = 10000 },
        { item = 'pig_body',           start = 20000 },
        { item = 'rabbit_body',        start = 15000 },
        { item = 'pigeon_body',        start = 15000 },
        { item = 'husky_skin',         start = 20000 },
        { item = 'retriever_skin',     start = 20000 },
        { item = 'rottweiler_skin',    start = 20000 },
        { item = 'shepherd_skin',      start = 20000 },
        { item = 'panther_skin',       start = 50000 },
        { item = 'pig_skin',           start = 10000 },
        { item = 'deer_skin',          start = 5000  },
        { item = 'boar_skin',          start = 7500  },
        { item = 'boar_meat',          start = 5000  },
        { item = 'deer_meat',          start = 3000  },
        { item = 'pig_meat',           start = 3000  },
        { item = 'rabbit_meat',        start = 15000 },
        { item = 'pigeon_meat',        start = 15000 },
        { item = 'seed_coca',          start = 100   },
        { item = 'seed_ephedra',       start = 100   },
        { item = 'seed_cannabis',      start = 100   },
        { item = 'seed_poppy',         start = 100   },
        { item = 'seed_apple',         start = 100   },
        { item = 'seed_orange',        start = 100   },
        { item = 'seed_corn',          start = 100   },
        { item = 'seed_wheat',         start = 100   },
        { item = 'seed_grape',         start = 100   },
        { item = 'seed_rice',          start = 100   },
        { item = 'seed_mushroom',      start = 100   },
        { item = 'seed_caffee',        start = 100   },
        { item = 'wheat_pack',         start = 150   },
        { item = 'grape_pack',         start = 150   },
        { item = 'corn_pack',          start = 150   },
        { item = 'apple_pack',         start = 150   },
        { item = 'orange_pack',        start = 150   },
        { item = 'rice_pack',          start = 150   },
        { item = 'caffee_pack',        start = 150   },
    },
}
