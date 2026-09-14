

local function scrambler(callback, type, time, mirrored)
    if type == nil then type = "alphabet" end
    if time == nil then time = 10 end
    if mirrored == nil then mirrored = 0 end
    DebugPrint("Scrambler called with " .. type .. " type and " .. time .. " time")
    SendNUI("GameLauncher", callback, {
        game = "Scramber",
        gameName = "Scrambler",
        gameDescription = "Challenge your brain with the Scrambler game! Depending on your choice, you'll either unscramble letters or numbers, with an option for mirrored text. Can you solve the puzzles before time runs out?",
        amountOfAnswers = 4,
        gameTime = time,
        sets = type,
        changeBoardAfter = 1,
    }, true)
end
exports("Scrambler", scrambler)