radioConfig = {
    Controls = {
        Activator = {
            Name = "INPUT_CELLPHONE_CANCEL",
            Key = 177,
        },
        Secondary = {
            Name = "INPUT_SPRINT",
            Key = 21,
            Enabled = false,
        },
        Toggle = {
            Name = "INPUT_CONTEXT",
            Key = 51,
        },
        Increase = {
            Name = "INPUT_CELLPHONE_RIGHT",
            Key = 175,
            Pressed = false,
        },
        Decrease = {
            Name = "INPUT_CELLPHONE_LEFT",
            Key = 174,
            Pressed = false,
        },
        Input = {
            Name = "INPUT_FRONTEND_ACCEPT",
            Key = 201,
            Pressed = false,
        },
        Broadcast = {
            Name = "INPUT_INTERACTION_MENU",
            Key = 244,
        },
        ToggleClicks = {
            Name = "INPUT_SELECT_WEAPON",
            Key = 37,
        }
    },
    Frequency = {
        Private = {
        [1] = true,
        [2] = true,
        [3] = true,
        [4] = true,
        [5] = true,
        [6] = true,
        [7] = true,
        [8] = true,
        [9] = true,
        [10] = true,
        [11] = true,
        [12] = true,
        [13] = true,
        [14] = true,
        [15] = true,
        [16] = true,
        [17] = true,
        [18] = true,
        [19] = true,
        [20] = true
        },
        Current = 1,
        CurrentIndex = 1,
        Min = 1,
        Max = 1000,
        List = {},
        Access = {},
    },
    AllowRadioWhenClosed = true
}

SI = {
    PrivateFrequency = {
        ["police"] = {901,900},
        ["sheriff"] = {902,900},
        ["mt"] = {903,900},
        ["fbi"] = {904,900},
        ["cid"] = {909,900},
        ["cia"] = {910,900},
        ["marshal"] = {911,900},
        ["judge"] = {912,900},
        ["doa"] = {913,900},

        ["ambulance"] = {905},
        ["mechanic"] = {906},
        ["taxi"] = {907},
        ["weazel"] = {908},

    }
}

for k,v in pairs(SI.PrivateFrequency) do
    for _,v2 in pairs(v) do
        radioConfig.Frequency.Private[v2] = true
    end
end