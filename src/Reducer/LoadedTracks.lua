return function(state, action)
    state = state or {}

    if (action.type == "SetLoadedTracks") then
        return action.loadedTracks
    end

    return state
end