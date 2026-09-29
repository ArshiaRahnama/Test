local ipls = {
    -- https://wiki.rage.mp/wiki/Interiors_and_Locations#Online_Apartments
    ['apa_v_mp_h_01_a'] = {
        label = 'Modern 1 Apartment',
        tags = {'furnished', 'apartment'},
        rooms = 1,
        doors = { x = -781.82, y = 317.9, z = 217.1, heading = 1.66 },
        images = {
            'ipl/apa_v_mp_h_01_a-1.png',
            'ipl/apa_v_mp_h_01_a-2.png',
            'ipl/apa_v_mp_h_01_a-3.png',
            'ipl/apa_v_mp_h_01_a-4.png',
            'ipl/apa_v_mp_h_01_a-5.png',
            'ipl/apa_v_mp_h_01_a-6.png',
        },
        settings = {
            Themes = {
                ['modern'] = {
                    label = 'Modern',
                    price = 10000,
                    image = 'ipl/themes/apa_v_mp_h_01_a-theme_modern.png'
                },
                ['moody'] = {
                    label = 'Moody',
                    price = 10000,
                    image = 'ipl/themes/apa_v_mp_h_01_a-theme_moody.png'
                },
                ['vibrant'] = {
                    label = 'Vibrant',
                    price = 10000,
                    image = 'ipl/themes/apa_v_mp_h_01_a-theme_vibrant.png'
                },
                ['sharp'] = {
                    label = 'Sharp',
                    price = 10000,
                    image = 'ipl/themes/apa_v_mp_h_01_a-theme_sharp.png'
                },
                ['monochrome'] = {
                    label = 'Monochrome',
                    price = 10000,
                    image = 'ipl/themes/apa_v_mp_h_01_a-theme_monochrome.png'
                },
                ['seductive'] = {
                    label = 'Seductive',
                    price = 10000,
                    image = 'ipl/themes/apa_v_mp_h_01_a-theme_seductive.png'
                },
                ['regal'] = {
                    label = 'Regal',
                    price = 10000,
                    image = 'ipl/themes/apa_v_mp_h_01_a-theme_regal.png'
                },
                ['aqua'] = {
                    label = 'Aqua',
                    price = 10000,
                    image = 'ipl/themes/apa_v_mp_h_01_a-theme_aqua.png'
                },
            },
            options = {
                Strip = { A = true, B = true, C = true },
                Booze = { A = true, B = true, C = true },
            },

            GetInteriorExport = 'GetExecApartment1Object',
        },
    },
    
    -- https://wiki.rage.mp/wiki/Interiors_and_Locations#Arcadius_Business_Centre
    ['ex_dt1_02_office_02b'] = { -- Vector3(-141.1987, -620.913, 168.8205);
        label = 'Executive Rich',
        tags = {'furnished', 'office'},
        rooms = 0,
        doors = { x = -139.17, y = -620.64, z = 168.3, heading = 96.3 },
        images = {
            'ipl/ex_dt1_02_office_02b-1.png',
            'ipl/ex_dt1_02_office_02b-2.png',
            'ipl/ex_dt1_02_office_02b-3.png',
            'ipl/ex_dt1_02_office_02b-4.png',
        },
        settings = {
            Themes = {
                ['warm'] = {
                    label = 'Warm',
                    price = 0,
                    image = ''
                },
                ['classical'] = {
                    label = 'Classical',
                    price = 0,
                    image = ''
                },
                ['vintage'] = {
                    label = 'Vintage',
                    price = 0,
                    image = ''
                },
                ['contrast'] = {
                    label = 'Contrast',
                    price = 0,
                    image = ''
                },
                ['rich'] = {
                    label = 'Rich',
                    price = 0,
                    image = ''
                },
                ['cool'] = {
                    label = 'Cool',
                    price = 0,
                    image = ''
                },
                ['ice'] = {
                    label = 'Ice',
                    price = 0,
                    image = ''
                },
                ['conservative'] = {
                    label = 'Conservative',
                    price = 0,
                    image = ''
                },
                ['polished'] = {
                    label = 'Polished',
                    price = 0,
                    image = ''
                },
            },
            options = {
                Cash = {
                    A = false, B = false, C = false,
                    D = false, E = false, F = false,
                    G = false, H = false, I = false,
                    J = false, K = false, L = false,
                    M = false, N = false, O = false,
                    P = false, Q = false, R = false,
                    S = false, T = false, U = false,
                    V = false, W = false, X = false
                },
                BoozeCigs = { A = true, B = true, C = true },
                Counterfeit = { A = true, B = true, C = true },
                DrugBags = { A = true, B = true, C = true },
                DrugStatue = { A = true, B = true, C = true },
                Electronic = { A = true, B = true, C = true },
                FurCoats = { A = true, B = true, C = true },
                Gems = { A = true, B = true, C = true },
                Guns = { A = true, B = true, C = true },
                Ivory = { A = true, B = true, C = true },
                Jewel = { A = true, B = true, C = true },
                Med = { A = true, B = true, C = true },
                Painting = { A = true, B = true, C = true },
                Pills = { A = true, B = true, C = true },
                Silver = { A = true, B = true, C = true },
            },
            Chairs = true,
            Booze = true,
            SafeLeft = false,
            SafeRight = false,

            GetInteriorExport = 'GetFinanceOffice1Object',
        },
    },
}

addIPLS(ipls)