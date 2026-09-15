
--CORE EVIDENCE 2.0

local Keys = {
	-- UPDATE V7: fixed -- this table (copied from a widely-shared community list) had
	-- ESC mapped to the wrong control ID (322), which is why ESC wasn't closing the
	-- report. Verified against the official FiveM control reference: ESC is control
	-- 200 (INPUT_FRONTEND_PAUSE_ALTERNATE).
	["ESC"] = 200, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}


local shots = {}
local blood = {}

local update = true
local last = 0
local time = 0
local open = false
local analyzing = false
local analyzingDone = false

-- UPDATE V3: split into two flags so either source can suppress bullet evidence
-- independently -- manualIgnore is set by evidence:unmarkedBullets / the
-- SetIgnoreBullets export (other resources), zoneIgnore is set automatically by the
-- Config.NoEvidenceZones check below (shooting ranges etc).
local manualIgnore = false
local zoneIgnore = false

local job = ""
local grade = 0

local evidence = {}

Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(0)
        end

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end

        job = ESX.GetPlayerData().job.name
        grade = ESX.GetPlayerData().job.grade
    end
)

RegisterNetEvent("esx:setJob")
AddEventHandler(
    "esx:setJob",
    function(j)
        job = j.name
        grade = j.grade
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1)

            local playerid = PlayerId()
            local playerPed = GetPlayerPed(-1)

            -- UPDATE V6 — the V5 fix used a native (IsFlashlightOn) that doesn't
            -- actually exist in FiveM, causing a hard script error. Replaced with a
            -- solid, well-documented check instead: WEAPON_FLASHLIGHT's beam is lit by
            -- holding the aim control (control 25, INPUT_AIM) -- the same button an
            -- officer holds in your screenshot -- so checking that control directly is
            -- both correct and guaranteed to exist.
            local flashlightActive =
                GetSelectedPedWeapon(playerPed) == GetHashKey("WEAPON_FLASHLIGHT") and IsControlPressed(0, 25)

            if not flashlightActive then
                update = true
                Citizen.Wait(500)
            else
                if update then
                        ESX.TriggerServerCallback(
                            "evidence:getData",
                            function(ans)
                                shots = ans.shots
                                blood = ans.blood
                                time = ans.time
                            end
                        )
                        update = false
                    end

                    for t, s in pairs(blood) do
                        if GetDistanceBetweenCoords(s.coords, GetEntityCoords(playerPed)) < 30 then
                            DrawMarker(
                                1,
                                s.coords[1],
                                s.coords[2],
                                s.coords[3] - 0.9,
                                0.0,
                                0.0,
                                0.0,
                                0,
                                0.0,
                                0.0,
                                0.2,
                                0.2,
                                0.2,
                                255,
                                41,
                                41,
                                100,
                                false,
                                true,
                                2,
                                false,
                                false,
                                false,
                                false
                            )
                        end

                        if GetDistanceBetweenCoords(s.coords, GetEntityCoords(playerPed)) < 5 then
                            DrawText3D(s.coords[1], s.coords[2], s.coords[3] - 0.5, Config.Text["blood_hologram"])

                            local passed = time - s.created

                            if passed > 300 and passed < 600 then
                                DrawText3D(
                                    s.coords[1],
                                    s.coords[2],
                                    s.coords[3] - 0.57,
                                    Config.Text["blood_after_5_minutes"]
                                )
                            elseif passed > 600 then
                                DrawText3D(
                                    s.coords[1],
                                    s.coords[2],
                                    s.coords[3] - 0.57,
                                    Config.Text["blood_after_10_minutes"]
                                )
                            else
                                DrawText3D(
                                    s.coords[1],
                                    s.coords[2],
                                    s.coords[3] - 0.57,
                                    Config.Text["blood_after_0_minutes"]
                                )
                            end
                        end

                        if GetDistanceBetweenCoords(s.coords, GetEntityCoords(playerPed)) < 1 then
                            if job == Config.JobRequired and grade >= Config.JobGradeRequired then
                                DrawText3D(
                                    s.coords[1],
                                    s.coords[2],
                                    s.coords[3] - 0.65,
                                    Config.Text["pick_up_evidence_text"]
                                )
                                if IsControlJustReleased(0, Keys[Config.PickupEvidenceKey]) then
                                    if #evidence < 3 then
                                        local dict, anim =
                                            "weapons@first_person@aim_rng@generic@projectile@sticky_bomb@",
                                            "plant_floor"
                                        ESX.Streaming.RequestAnimDict(dict)
                                        TaskPlayAnim(
                                            playerPed,
                                            dict,
                                            anim,
                                            8.0,
                                            1.0,
                                            1000,
                                            16,
                                            0.0,
                                            false,
                                            false,
                                            false
                                        )
                                        Citizen.Wait(1000)
                                        blood[t] = nil
                                        evidence[#evidence + 1] = {type = "blood", evidence = s.reportInfo}
                                        TriggerServerEvent("evidence:removeBlood", t)
                                        SendTextMessage(
                                            string.gsub(Config.Text["evidence_colleted"], "{number}", #evidence)
                                        )
                                        PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                                    else
                                        SendTextMessage(Config.Text["no_more_space"])
                                    end
                                end
                            else
                                DrawText3D(s.coords[1], s.coords[2], s.coords[3] - 0.65, Config.Text["remove_evidence"])
                                if IsControlJustReleased(0, Keys[Config.PickupEvidenceKey]) then
                                    if (time - s.created) > Config.TimeBeforeCrimsCanDestory then
                                        local dict, anim =
                                            "weapons@first_person@aim_rng@generic@projectile@sticky_bomb@",
                                            "plant_floor"
                                        ESX.Streaming.RequestAnimDict(dict)
                                        TaskPlayAnim(
                                            playerPed,
                                            dict,
                                            anim,
                                            8.0,
                                            1.0,
                                            1000,
                                            16,
                                            0.0,
                                            false,
                                            false,
                                            false
                                        )
                                        Citizen.Wait(1000)
                                        blood[t] = nil

                                        TriggerServerEvent("evidence:removeBlood", t)
                                        SendTextMessage(Config.Text["evidence_removed"])
                                        PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                                    else
                                        SendTextMessage(Config.Text["cooldown_before_pickup"])
                                    end
                                end
                            end
                        end
                    end

                    for t, s in pairs(shots) do
                        if GetDistanceBetweenCoords(s.coords, GetEntityCoords(playerPed)) < 30 then
                            DrawMarker(
                                3,
                                s.coords[1],
                                s.coords[2],
                                s.coords[3] - 0.9,
                                0.0,
                                0.0,
                                0.0,
                                0,
                                0.0,
                                0.0,
                                0.15,
                                0.15,
                                0.2,
                                66,
                                135,
                                245,
                                100,
                                false,
                                true,
                                2,
                                false,
                                false,
                                false,
                                false
                            )
                        end

                        if GetDistanceBetweenCoords(s.coords, GetEntityCoords(playerPed)) < 5 then
                            DrawText3D(
                                s.coords[1],
                                s.coords[2],
                                s.coords[3] - 0.5,
                                string.gsub(Config.Text["shell_hologram"], "{guncategory}", s.bullet)
                            )

                            local passed = time - s.created

                            if passed > 300 and passed < 600 then
                                DrawText3D(
                                    s.coords[1],
                                    s.coords[2],
                                    s.coords[3] - 0.57,
                                    Config.Text["shell_after_5_minutes"]
                                )
                            elseif passed > 600 then
                                DrawText3D(
                                    s.coords[1],
                                    s.coords[2],
                                    s.coords[3] - 0.57,
                                    Config.Text["shell_after_10_minutes"]
                                )
                            else
                                DrawText3D(
                                    s.coords[1],
                                    s.coords[2],
                                    s.coords[3] - 0.57,
                                    Config.Text["shell_after_0_minutes"]
                                )
                            end
                        end

                        if GetDistanceBetweenCoords(s.coords, GetEntityCoords(playerPed)) < 1 then
                            if job == Config.JobRequired and grade >= Config.JobGradeRequired then
                                DrawText3D(
                                    s.coords[1],
                                    s.coords[2],
                                    s.coords[3] - 0.65,
                                    Config.Text["pick_up_evidence_text"]
                                )
                                if IsControlJustReleased(0, Keys[Config.PickupEvidenceKey]) then
                                    if #evidence < 3 then
                                        local dict, anim =
                                            "weapons@first_person@aim_rng@generic@projectile@sticky_bomb@",
                                            "plant_floor"
                                        ESX.Streaming.RequestAnimDict(dict)
                                        TaskPlayAnim(
                                            playerPed,
                                            dict,
                                            anim,
                                            8.0,
                                            1.0,
                                            1000,
                                            16,
                                            0.0,
                                            false,
                                            false,
                                            false
                                        )
                                        Citizen.Wait(1000)
                                        shots[t] = nil
                                        evidence[#evidence + 1] = {type = "bullet", evidence = s.reportInfo}
                                        TriggerServerEvent("evidence:removeShot", t)
                                        SendTextMessage(
                                            string.gsub(Config.Text["evidence_colleted"], "{number}", #evidence)
                                        )
                                        PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                                    else
                                        SendTextMessage(Config.Text["no_more_space"])
                                    end
                                end
                            else
                                DrawText3D(s.coords[1], s.coords[2], s.coords[3] - 0.65, Config.Text["remove_evidence"])
                                if IsControlJustReleased(0, Keys[Config.PickupEvidenceKey]) then
                                    if (time - s.created) > Config.TimeBeforeCrimsCanDestory then
                                        local dict, anim =
                                            "weapons@first_person@aim_rng@generic@projectile@sticky_bomb@",
                                            "plant_floor"
                                        ESX.Streaming.RequestAnimDict(dict)
                                        TaskPlayAnim(
                                            playerPed,
                                            dict,
                                            anim,
                                            8.0,
                                            1.0,
                                            1000,
                                            16,
                                            0.0,
                                            false,
                                            false,
                                            false
                                        )
                                        Citizen.Wait(1000)
                                        shots[t] = nil

                                        TriggerServerEvent("evidence:removeShot", t)
                                        SendTextMessage(Config.Text["evidence_removed"])
                                        PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                                    else
                                        SendTextMessage(Config.Text["cooldown_before_pickup"])
                                    end
                                end
                            end
                        end
                    end
            end
        end
    end
)

-- UPDATE V3: the archive and analysis desk used to be a hand-rolled "check distance
-- every tick + IsControlJustReleased(0, 38)" loop with the old ESX.UI.Menu for the
-- archive list. Replaced with ox_target zones (set up once, not every frame) and an
-- ox_lib context menu, matching how the rest of this server (see
-- [SCRIPT]/ScriptPack) does location interactions and menus.

function StartAnalysis()
    if analyzing or analyzingDone then
        return
    end

    if #evidence == 0 then
        SendTextMessage(Config.Text["no_evidence_to_analyze"])
        return
    end

    Citizen.CreateThread(
        function()
            SendTextMessage(Config.Text["evidence_being_analyzed"])
            analyzing = true
            Citizen.Wait(Config.TimeToAnalyze)
            analyzing = false
            analyzingDone = true
            SendTextMessage(Config.Text["read_evidence_report"])
        end
    )
end

function GenerateReport()
    if analyzing or not analyzingDone then
        return
    end

    local ped = GetPlayerPed(-1)
    local encoded = json.encode(evidence)

    ESX.TriggerServerCallback(
        "evidence:submitReport",
        function(caseInfo)
            SendNUIMessage(
                {
                    type = "showReport",
                    evidence = encoded,
                    caseNumber = caseInfo and caseInfo.id,
                    analyzedBy = caseInfo and caseInfo.analyzed_by,
                    createdAt = caseInfo and caseInfo.created_at
                }
            )

            if Config.PlayClipboardAnimation then
                TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
            end

            open = true
            analyzingDone = false
            evidence = {}
        end,
        encoded
    )
end

function OpenArchiveEntry(entry)
    lib.registerContext(
        {
            id = "evidence_archive_entry",
            title = Config.Text["report_list"] .. entry.id,
            menu = "evidence_archive",
            options = {
                {
                    title = Config.Text["view"],
                    icon = "eye",
                    onSelect = function()
                        SendNUIMessage(
                            {
                                type = "showReport",
                                evidence = entry.data,
                                caseNumber = entry.id,
                                analyzedBy = entry.analyzed_by,
                                createdAt = entry.created_at
                            }
                        )
                        open = true
                    end
                },
                {
                    title = Config.Text["delete"],
                    icon = "trash",
                    onSelect = function()
                        TriggerServerEvent("evidence:deleteEvidenceFromStorage", entry.id)
                        SendTextMessage(Config.Text["evidence_deleted_from_archive"])
                    end
                }
            }
        }
    )
    lib.showContext("evidence_archive_entry")
end

function OpenArchive()
    ESX.TriggerServerCallback(
        "evidence:getStorageData",
        function(data)
            local options = {}

            for _, v in ipairs(data) do
                local desc = Config.Text["analyzed_by"] .. ": " .. tostring(v.analyzed_by or "?")
                if v.created_at then
                    desc = desc .. "  •  " .. tostring(v.created_at)
                end

                table.insert(
                    options,
                    {
                        title = Config.Text["report_list"] .. v.id,
                        description = desc,
                        icon = "folder-open",
                        onSelect = function()
                            OpenArchiveEntry(v)
                        end
                    }
                )
            end

            if #options == 0 then
                table.insert(options, {title = "—", disabled = true})
            end

            lib.registerContext(
                {
                    id = "evidence_archive",
                    title = Config.Text["evidence_archive"],
                    options = options
                }
            )
            lib.showContext("evidence_archive")
        end
    )
end

Citizen.CreateThread(
    function()
        exports.ox_target:addBoxZone(
            {
                coords = Config.EvidenceAlanysisLocation,
                size = vector3(1.6, 1.6, 2.0),
                rotation = 0.0,
                debug = false,
                options = {
                    {
                        label = Config.Text["analyze_evidence"],
                        icon = "fa-solid fa-magnifying-glass",
                        distance = 2.0,
                        canInteract = function()
                            return job == Config.JobRequired and grade >= Config.JobGradeRequired and
                                not analyzing and
                                not analyzingDone
                        end,
                        onSelect = StartAnalysis
                    },
                    {
                        label = Config.Text["read_evidence_report"],
                        icon = "fa-solid fa-file-shield",
                        distance = 2.0,
                        canInteract = function()
                            return job == Config.JobRequired and grade >= Config.JobGradeRequired and analyzingDone
                        end,
                        onSelect = GenerateReport
                    }
                }
            }
        )

        exports.ox_target:addBoxZone(
            {
                coords = Config.EvidenceStorageLocation,
                size = vector3(1.6, 1.6, 2.0),
                rotation = 0.0,
                debug = false,
                options = {
                    {
                        label = Config.Text["open_evidence_archive"],
                        icon = "fa-solid fa-box-archive",
                        distance = 2.0,
                        canInteract = function()
                            return job == Config.JobRequired and grade >= Config.JobGradeRequired
                        end,
                        onSelect = OpenArchive
                    }
                }
            }
        )
    end
)

-- UPDATE V3: lets the on-screen × button (html/script.js -> CloseReport()) close the
-- report game-side too, same as pressing BACKSPACE/ESC.
RegisterNUICallback(
    "closeReport",
    function(data, cb)
        open = false
        ClearPedTasks(GetPlayerPed(-1))
        cb("ok")
    end
)

-- Closing the report: BACKSPACE (as before) AND now ESC too, with ESC's default
-- pause-menu suppressed for the single frame the report is open so it doesn't pop
-- the pause menu underneath the report.
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)

            if open then
                DisableControlAction(0, Keys[Config.CloseReportKeyAlt], true)

                if
                    IsControlJustReleased(0, Keys[Config.CloseReportKey]) or
                        IsControlJustReleased(0, Keys[Config.CloseReportKeyAlt])
                 then
                    SendNUIMessage({type = "close"})
                    ClearPedTasks(GetPlayerPed(-1))
                    open = false
                end
            else
                Citizen.Wait(400)
            end
        end
    end
)

-- Tracks who was last in the driver/passenger seat a vehicle the officer is trying to
-- enter, for the uvlight fingerprint check (unchanged logic, just no longer nested
-- inside the old per-tick archive/analysis loop).
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(50)

            local ped = GetPlayerPed(-1)
            local veh = GetVehiclePedIsTryingToEnter(ped)

            if veh ~= 0 then
                local seat = GetSeatPedIsTryingToEnter(ped)
                local lastped = GetLastPedInVehicleSeat(veh, seat)
                local gloves = GetPedDrawableVariation(PlayerPedId(), 3)

                if gloves > 15 and gloves ~= 112 and gloves ~= 113 and gloves ~= 114 then
                    last = 0
                else
                    last = lastped
                end
            end
        end
    end
)

RegisterNetEvent("evidence:addFingerPrint")
AddEventHandler(
    "evidence:addFingerPrint",
    function(report)
        Citizen.CreateThread(
            function()
                SendTextMessage(Config.Text["analyzing_car"])

                local dict, anim = "anim@heists@prison_heiststation@cop_reactions", "cop_b_idle"
                ESX.Streaming.RequestAnimDict(dict)
                TaskPlayAnim(GetPlayerPed(-1), dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)

                Citizen.Wait(Config.TimeToFindFingerprints)

                if #evidence < 3 then
                    evidence[#evidence + 1] = {type = "fingerprint", evidence = report}

                    SendTextMessage(string.gsub(Config.Text["evidence_colleted"], "{number}", #evidence))
                    PlaySoundFrontend(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
                else
                    SendTextMessage(Config.Text["no_more_space"])
                end
            end
        )
    end
)

-- UPDATE V3: this event existed before but nothing ever triggered it -- now actually
-- wired up, plus a matching client export so a local script can flip it directly
-- without round-tripping through the server.
RegisterNetEvent("evidence:unmarkedBullets")
AddEventHandler(
    "evidence:unmarkedBullets",
    function(value)
        manualIgnore = value
    end
)

exports(
    "SetIgnoreBullets",
    function(value)
        manualIgnore = value
    end
)

-- UPDATE V3: automatically suppresses bullet evidence near Config.NoEvidenceZones
-- (shooting ranges, firing academies) -- checked once a second, not every tick.
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000)

            local coords = GetEntityCoords(GetPlayerPed(-1))
            local inZone = false

            for _, zone in ipairs(Config.NoEvidenceZones) do
                if #(coords - zone.coords) <= zone.radius then
                    inZone = true
                    break
                end
            end

            zoneIgnore = inZone
        end
    end
)

RegisterNetEvent("evidence:SendTextMessage")
AddEventHandler(
    "evidence:SendTextMessage",
    function(msg)
        SendTextMessage(msg)
    end
)

RegisterNetEvent("evidence:checkForFingerprints")
AddEventHandler("evidence:checkForFingerprints",
    function()
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            TriggerServerEvent("evidence:LastInCar", NetworkGetNetworkIdFromEntity(last))
        else
            SendTextMessage(Config.Text["not_in_vehicle"])
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5000)
            if Config.RainRemovesEvidence then
                if GetRainLevel() > 0.3 then
                    TriggerServerEvent("evidence:removeEverything")
                    Citizen.Wait(10000)
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(10)

            local ped = GetPlayerPed(-1)
            local coords = GetEntityCoords(ped)

            if IsShockingEventInSphere(102, 235.497, 2894.511, 43.339, 999999.0) then
                if HasEntityBeenDamagedByAnyPed(ped) then
                    ClearEntityLastDamageEntity(ped)

                    if Config.ShowBloodSplatsOnGround then
                        local stain =
                            CreateObject(
                            GetHashKey("p_bloodsplat_s"),
                            coords[1],
                            coords[2],
                            coords[3] - 2.0,
                            true,
                            true,
                            false
                        )

                        PlaceObjectOnGroundProperly(stain)
                        local stainCoords = GetEntityCoords(stain)
                        SetEntityCoords(stain, stainCoords[1], stainCoords[2], stainCoords[3] - 0.25)
                        SetEntityAsMissionEntity(stain, true, true)
                        SetEntityRotation(stain, -90.0, 0.0, 0.0, 2, false)
                        FreezeEntityPosition(stain, true)
                    end

                    TriggerServerEvent("evidence:saveBlood", coords, GetInteriorFromEntity(ped))
                    Citizen.Wait(2000)
                end
            end

            if IsPedShooting(ped) and not (manualIgnore or zoneIgnore) then
                TriggerServerEvent(
                    "evidence:saveShot",
                    coords,
                    getWeaponName(GetSelectedPedWeapon(ped)),
                    GetInteriorFromEntity(ped)
                )
            end
        end
    end
)

-- UPDATE V4: /evidencetest support. Blood/shell markers ONLY render while the
-- flashlight is equipped AND the aim control is held (control 25 -- see the top of
-- this file) -- that's the core detection mechanic, not a bug -- so the instructions
-- here tell the tester to equip it and hold aim.
-- UPDATE V6 — /evidencecoords: stand wherever you want the analysis desk / archive
-- to actually be (e.g. inside your FBI HQ) and run this to print the exact
-- vector3(...) for Config.EvidenceAlanysisLocation / EvidenceStorageLocation to
-- chat, ready to copy-paste. Gated behind Config.Debug like the other test tools.
if Config.Debug then
    RegisterCommand(
        "evidencecoords",
        function()
            local coords = GetEntityCoords(GetPlayerPed(-1))
            local line =
                string.format("vector3(%.2f, %.2f, %.2f)", coords.x, coords.y, coords.z)

            TriggerEvent(
                "chat:addMessage",
                {
                    args = {"[EVIDENCE TEST]", "Your current coords: " .. line}
                }
            )
        end,
        false
    )
end

RegisterNetEvent("evidence:spawnTestEvidence")
AddEventHandler(
    "evidence:spawnTestEvidence",
    function()
        local ped = GetPlayerPed(-1)
        local coords = GetEntityCoords(ped)
        local interior = GetInteriorFromEntity(ped)

        TriggerServerEvent("evidence:saveBlood", coords, interior)
        TriggerServerEvent("evidence:saveShot", coords, Config.Text["pistol_category"], interior)

        update = true -- forces the next flashlight-aim tick to pull the fresh evidence from the server

        TriggerEvent(
            "chat:addMessage",
            {
                args = {
                    "[EVIDENCE TEST]",
                    "Equip a flashlight (weapon wheel) and hold aim -- markers only show while aiming it. Walk within 1m and press E to pick up, then go to the analysis desk, press E to analyze, wait, press E again to read the report, then check the archive."
                }
            }
        )
    end
)

function getWeaponName(hash)
    local ped = GetPlayerPed(-1)

    if GetWeapontypeGroup(hash) == -957766203 then
        return Config.Text["submachine_category"]
    end
    if GetWeapontypeGroup(hash) == 416676503 then
        return Config.Text["pistol_category"]
    end
    if GetWeapontypeGroup(hash) == 860033945 then
        return Config.Text["shotgun_category"]
    end
    if GetWeapontypeGroup(hash) == 970310034 then
        return Config.Text["assault_category"]
    end
    if GetWeapontypeGroup(hash) == 1159398588 then
        return Config.Text["lightmachine_category"]
    end
    if GetWeapontypeGroup(hash) == -1212426201 then
        return Config.Text["sniper_category"]
    end
    if GetWeapontypeGroup(hash) == -1569042529 then
        return Config.Text["heavy_category"]
    end

    return Config.Text["unknown_category"] or "Unknown Weapon"
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = ((1 / dist) * 2) * (1 / GetGameplayCamFov()) * 100

    if onScreen then
        SetTextColour(255, 255, 255, 255)
        SetTextScale(0.0 * scale, 0.35 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextCentre(true)

        SetTextDropshadow(1, 1, 1, 1, 255)

        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55 * scale, 4)
        local width = EndTextCommandGetWidth(4)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
    end
end


