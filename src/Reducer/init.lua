-- Reducer

local SelectInstanceMenu = require(script.SelectInstanceMenu)
local CurrentTrack = require(script.CurrentTrack)
local LoadedTracks = require(script.LoadedTracks)


local function CurrentTrackModel(state, action) -- temp
    state = state or {
        trackModelName = nil;
    }

    if (action.type == "SetCurrentTrackModel") then
        return {
            trackModelName = action.trackModelName
        }
    end

    return state
end


local function TrackModelBuildRange(state, action)  -- temp?
    state = state or {
        Start = 0;
        End = 0;
    }

    if (action.type == "SetBuildRange") then
        return {
            Start = action.rangeStart or state.Start;
            End = action.rangeEnd or state.End;
        }
    end


    return state
end


return function(state, action)
    state = state or {}

    return {
        CurrentTrack = CurrentTrack(state.CurrentTrack, action);
        LoadedTracks = LoadedTracks(state.LoadedTracks, action);
        SelectInstanceMenu = SelectInstanceMenu(state.SelectInstanceMenu, action);

        CurrentTrackModel = CurrentTrackModel(state.CurrentTrackModel, action); -- temp
        TrackModelBuildRange = TrackModelBuildRange(state.TrackModelBuildRange, action);
    }
end