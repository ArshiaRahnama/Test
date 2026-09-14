

local function Maze(callback, speed)
    if speed == nil then speed = 10 end
    DebugPrint("Maze called with " .. speed .. " speed")
    SendNUI("GameLauncher", callback, {
        game = "NumberMaze",
        gameName = "NumberMaze",
        gameDescription = "Test your skills in the Number Maze! Race against the clock to find the correct sequence and beat the challenge. Can you solve it before time runs out?",
        gameTime = speed,
        triggerEvent = 'maze-callback',
        maxAnswersIncorrect = 2,
    }, true)
end
exports("Maze", Maze)