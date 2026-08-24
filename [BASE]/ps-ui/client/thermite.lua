local correctBlocksBasedOnGrid = {
    [5] = 10,
    [6] = 14,
    [7] = 18,
    [8] = 20,
    [9] = 24,
    [10] = 28,
}

local function thermite(cb, time, gridsize, wrong, correctBlocks)

    if time == nil then time = 10 end
    if gridsize == nil then gridsize = 6 end
    if wrong == nil then wrong = 3 end

    local correctBlockCount = correctBlocks or correctBlocksBasedOnGrid[gridsize]
    DebugPrint("Thermite called with " .. correctBlockCount .. " correct blocks and " .. time .. " time")
    SendNUI("GameLauncher", cb, {
        game = "MemoryGame",
        gameName = "Memory Game",
        gameDescription = "Test your memory with Thermite! Match blocks on a grid before time runs out. Adjust grid size and incorrect answers for added challenge!",
        amountOfAnswers = correctBlockCount,
        gameTime = time,
        maxAnswersIncorrect = wrong,
        displayInitialAnswersFor = 3,
        gridSize = gridsize,
    }, true)
end
exports("Thermite", thermite)