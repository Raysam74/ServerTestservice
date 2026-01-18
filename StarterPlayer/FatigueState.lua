local state = {}
state.isBreathing = false
state.isFainted = false
state.chain = 0

function state.triggerBreathing()
    state.isBreathing = true
    state.chain = state.chain + 1
end

function state.recover()
    state.isBreathing = false
end

function state.shouldFaint()
    return state.chain >= 5
end

function state.reset()
    state.chain = 0
    state.isFainted = false
end

return state
