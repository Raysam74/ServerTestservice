local playersState = {}

local function onExhausted(player)
    playersState[player] = playersState[player] or {count = 0}
    playersState[player].count = playersState[player].count + 1
end

local function shouldFaint(player)
    if not playersState[player] then return false end
    return playersState[player].count >= 5
end

local function resetPlayer(player)
    playersState[player] = {count = 0}
end

return {
    onExhausted = onExhausted,
    shouldFaint = shouldFaint,
    resetPlayer = resetPlayer
}
