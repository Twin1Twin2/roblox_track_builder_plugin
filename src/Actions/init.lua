-- Actions

local Actions = {
    OpenSelectInstanceMenu = function(menuName, onInstanceSelected)
        return {
            type = "OpenSelectInstanceMenu",
            menuName = menuName,
            onInstanceSelected = onInstanceSelected
        }
    end,
    CloseSelectInstanceMenu = function()
        return {
            type = "CloseSelectInstanceMenu"
        }
    end,
    SetCurrentTrack = function(trackUID, trackName, trackLength)
        return {
            type = "SetCurrentTrack",
            trackUID = trackUID,
            trackName = trackName,
            trackLength = trackLength or 0,
        }
    end,
    SetLoadedTracks = function(loadedTracks)
        return {
            type = "SetLoadedTracks",
            loadedTracks = loadedTracks,
        }
    end,
    SetCurrentTrackModel = function(trackModelName)
        return {
            type = "SetCurrentTrackModel",
            trackModelName = trackModelName,
        }
    end,
    SetBuildRange = function(rangeStart, rangeEnd)
        return {
            type = "SetBuildRange",
            rangeStart = rangeStart;
            rangeEnd = rangeEnd;
        }
    end
}


return Actions