

local function varHack(callback, blocks, speed)
    if speed == nil or (speed < 2) then speed = 20 end
    if blocks == nil or (blocks < 1 or blocks > 15) then blocks = 5 end
    DebugPrint("VarHack called with " .. blocks .. " blocks and " .. speed .. " speed")
    SendNUI("GameLauncher", callback, {
        game = "NumberPuzzle",
        gameName = "NumberPuzzle",
        gameDescription = "Test your skills with VarHack! Solve the number puzzle by matching blocks within the time limit. Adjust the number of blocks and game speed for a personalized challenge!",
        gameTime = 15,
        triggerEvent = 'var-callback',
        maxAnswersIncorrect = 2,
        amountOfAnswers = blocks,
        timeForNumberDisplay = 3,
    }, true)
end
exports("VarHack", varHack)
