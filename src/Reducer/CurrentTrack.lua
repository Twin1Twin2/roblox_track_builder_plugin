return function(state, action)
    state = state or {
        trackUID = nil;
        trackName = "";
        trackLength = 0;
    }

    if (action.type == "SetCurrentTrack") then
        return {
            trackUID = action.trackUID;
            trackName = action.trackName;
            trackLength = action.trackLength or 0;
        }
    end

    return state
end