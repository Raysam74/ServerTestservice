local stamina = 100
local maxStamina = 100
local running = false
local exhausted = false
local exhaustionCount = 0

local walkSpeed = 10
local runSpeed = 18
local exhaustedSpeed = 6

local blurLevel = 0

local function updateStamina(dt)
    if running and not exhausted then
        stamina = stamina - (30 * dt)
    else
        stamina = stamina + (12 * dt)
    end

    if stamina < 0 then stamina = 0 end
    if stamina > maxStamina then stamina = maxStamina end

    if stamina == 0 and not exhausted then
        exhausted = true
        exhaustionCount = exhaustionCount + 1
        blurLevel = 18
    end

    if exhausted then
        stamina = stamina + (6 * dt)
        if stamina >= 40 then
            exhausted = false
            blurLevel = 0
        end
    end
end

return {
    updateStamina = updateStamina
}

