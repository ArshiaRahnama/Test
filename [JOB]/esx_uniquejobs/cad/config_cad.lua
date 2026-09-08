

DuckMdt = {}

DuckMdt.Command = 'cad'

DuckMdt.PoliceJob = 'police'

DuckMdt.OnDutyCheck = false

DuckMdt.CheckRank = false

DuckMdt.MinRank = 1

-- Amozesh (Training) tab -- fill this with your department's actual
-- training material/SOPs, one line per entry. Rendered as-is (basic
-- HTML like <b> works, no markdown) in the "Amozesh" tab of /cad.
DuckMdt.TrainingMaterial = {
    '<b>=== AMOZESH-E MENU /doj ===</b> (marshal, judge, cia, cid, fbi, doa)',
    '',
    '1) Sabeghe-ye Kayfari (Background Check) -- ID ya esm vared konid, tamam-e dastgiri/etteham/jarime-ye pardakht-nashode-ye an shakhs miad.',
    '2) Jostoju-ye Shomare Telephone -- ba vared kardan-e yek shomare-ye 10 raghami, saheb-e an ra peida mikonad.',
    '3) Parvande-ha (Cases) -- sakht-e parvande-ye jadid, jostoju bar asas-e mozanne, filter bar asas-e vaziat. Dakhel-e har parvande: massol shodan, taghire ahamiyat, taghire vaziat, sabt-e yaddasht/madrak, ezafe kardan-e etteham, erja be departman-e digar, Timeline-e Parvande, Zamanbandi Jalase-ye Dadgah, Zanjire-ye Negahdari-ye Madarek.',
    '4) Ghanoon-name (Codebook) -- moroor-e ghavanin; faghat judge mitavanad virayesh/hazf/ezafe konad.',
    '5) Afsaran-e Online DOJ -- list-e hamkaran-e DOJ ke alan online hastand.',
    '6) Baz Kardan CAD (MDT) -- mianbor-e mostaghim be hamin panel.',
    '7) Taghvim-e Dadgah (Court Docket) -- list-e jalasat-e dadgah; faghat judge mitavanad hokm-e nahaee (Guilty / Not Guilty / Plea Deal) sabt konad -- ba sabt-e hokm parvande khodkar baste mishavad.',
    '8) Dashboard-e Amari -- jarayem-e por-tekrar, rond-e dastgiri-ha, faal-tarin afsaran.',
    '9) Barresi Amalkard Afsar -- profile-e yek afsar: tedad-e dastgiri/etteham, rotbe, sabeghe-ye IA.',
    '10) Hokm-ha (Warrants) -- faghat marshal/judge -- darkhast ya barresi-ye hokm-e bazdasht.',
    '11) Amaliyat-e Vizhe (FBI/CIA) -- faghat fbi/cia -- nezarat, otagh-e bazjuyi, shenood, tracker.',
    '12) Sabt-e Madrak Dar Parvande -- faghat cid -- mianbor baraye ezafe kardan-e madrak be yek parvande-ye baz.',
    '13) Sabt-e Zabti / Sabeghe-ye Zabti-ha / Modiriyat-e Khabarchin -- faghat doa.',
    '',
    '<b>=== AMOZESH-E MENU /law ===</b> (police, sheriff, mt)',
    '',
    '1) Jostoju Dar Ghanoon-name -- jostoju-ye sari bar asas-e code ya onvan.',
    '2) Daste-bandi-haye Ghanoon (Ranandegi / Amval / Khoshoonat / Mavad-e Mokhader / Salah / Sayer) -- entekhab-e yek ghanoon + dadan-e ID bazikon = jarime khodkar sader mishavad.',
    '3) Baz Kardan CAD (MDT) -- mianbor-e mostaghim be hamin panel.',
    '4) Sabt-e Tavaghof (Traffic Stop) -- Sabt-e Tavaghof-e Jadid (dalil + pelak-e ekhtiari ke khodkar BOLO check mishavad + natije: Ekhtar/Jarime/Bazresi/Ershad Be Dastgiri), Barresi Pelak (BOLO) baraye check-e tanha, BOLO-haye Active baraye didan-e kol-e list, Tarikhche-ye Tavaghof-ha.',
    '',
    '<b>=== NOKAT-E MOHEM ===</b>',
    '- Ghabl az har eghdam (bazdasht, jarime, tavaghof), hoviyat-e khodetan ra be onvan-e afsar-e ghanoon elam konid.',
    '- Har taghiiri dar yek parvande (Status, Priority, Charge, Evidence, Docket) khodkar dar Timeline-e hamun parvande sabt mishavad -- niazi nist jaye digar ham yaddasht bezanid.',
}

DuckMdt.BlockNuiDevTool = true

DuckMdt.LogUsingNuiDevTool = true

DuckMdt.AnnouneAdminUsingNuiDevTool = true

DuckMdt.AnnouneText = 'Some One Wants to use tablet without permission ! id : '

DuckMdt.AnnouncePerm = 1
