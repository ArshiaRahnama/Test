-- Pub by FleeX Team , https://discord.gg/87rGBxgCsa

configDuty                            = {}
configDuty.DrawDistance               = 10.0
configDuty.Locale                     = 'en'


configDuty.Zones = {
--- Police/sheriff/mt

  { -- PD 2
    Pos  = vec(628.93, -5.87, 82.78),
    Size = { x = 0.7, y = 0.7, z = 0.7 }, Color = { r = 0, g = 0, b = 255 }, Type  = 20,
    job  = {
      ["police"] = true,
      ["sheriff"] = true,
      ["mt"] = true,
      ["detective"] = true,
    }
  },

  { -- PD 3
    Pos  = vec(-56.45, -2505.81, 7.39),
    Size = { x = 0.7, y = 0.7, z = 0.7 }, Color = { r = 0, g = 0, b = 255 }, Type  = 20,
    job  = {
      ["police"] = true,
      ["sheriff"] = true,
      ["mt"] = true,
      ["detective"] = true,
    }
  },

  { -- Army
    Pos  = vec(-2354.38, 3259.08, 32.81),
    Size = { x = 0.7, y = 0.7, z = 0.7 }, Color = { r = 0, g = 0, b = 255 }, Type  = 20,
    job  = {
      ["police"] = true,
      ["sheriff"] = true,
      ["mt"] = true,
      ["detective"] = true,
    }
  },

  { -- sandy
    Pos  = vec(1830.5, 3683.59, 34.33),
    Size = { x = 0.7, y = 0.7, z = 0.7 }, Color = { r = 0, g = 0, b = 255 }, Type  = 20,
    job  = {
      ["police"] = true,
      ["sheriff"] = true,
      ["mt"] = true,
      ["detective"] = true,
    }
  },

  { -- paleto
    Pos  = vec(-437.34, 6002.07, 31.72),
    Size = { x = 0.7, y = 0.7, z = 0.7 }, Color = { r = 0, g = 0, b = 255 }, Type  = 20,
    job  = {
      ["police"] = true,
      ["sheriff"] = true,
      ["mt"] = true,
      ["detective"] = true,
    }
  },

--- Mechanic
  { -- new city
    Pos  = vec(620.93,628.05,128.97),
    Size = { x = 0.7, y = 0.7, z = 0.7 }, Color = { r = 204, g = 204, b = 0 }, Type = 20,
    job  = {
      ["mechanic"] = true,
    }
  },

--- ambulance
  { -- centeral
    Pos  = vec(1147.64,-1546.3,35.38),
    Size = { x = 0.7, y = 0.7, z = 0.7 }, Color = { r = 255, g = 0, b = 0 }, Type = 21,
    job  = {
      ["ambulance"] = true,
    }
  },

  { -- md 2
    Pos  = vec(-1855.15,-335.0,49.25),
    Size = { x = 0.7, y = 0.7, z = 0.7 }, Color = { r = 255, g = 0, b = 0 }, Type = 21,
    job  = {
      ["ambulance"] = true,
    }
  },

--- Taxi
  { -- center
    Pos  = vec(357.64,-1590.6,29.29),      
    Size = { x = 0.7, y = 0.7, z = 0.7 }, Color = { r = 204, g = 204, b = 0 }, Type = 20,
    job  = {
      ["taxi"] = true,
    }
  },

---fbi 
  { -- fbi 
    Pos  = vec(123.71, -769.7, 242.15),
    Size = { x = 0.7, y = 0.7, z = 0.7 }, Color = { r = 204, g = 204, b = 0 }, Type = 20,
    job  = {
      ["fbi"] = true,
      ["police"] = true,
      ["sheriff"] = true,
      ["mt"] = true,
      ["detective"] = true,
      ["justice"] = true,
      ["taxi"] = true,
      ["ambulance"] = true,
      ["mechanic"] = true,
    }
  },

  ---justice 
  { --  justice
    Pos  = vec(-548.54, -182.18, 38.22),
    Size = { x = 0.7, y = 0.7, z = 0.7 }, Color = { r = 204, g = 204, b = 0 }, Type = 20,
    job  = {
      ["justice"] = true,
    }
  },
  { --  justic 2
    Pos  = vec(216.94, -413.66, 47.98),
    Size = { x = 0.7, y = 0.7, z = 0.7 }, Color = { r = 204, g = 204, b = 0 }, Type = 20,
    job  = {
      ["justice"] = true,
    }
  },
}

configDuty.Blips = {
}
