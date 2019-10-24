
local CFrameTracks = script.Parent.CFrameTracks

local PointToPointCFrameTrack = require(CFrameTracks:FindFirstChild("PointToPointCFrameTrack"))
local PointToPointCFrameTrack2 = require(CFrameTracks:FindFirstChild("PointToPointCFrameTrack2"))
-- local NWSpacekBezierCFrameTrack = require(CFrameTracks:FindFirstChild("NWSpacekBezierCFrameTrack"))

local GetCFramesFromPoints = require(script.Parent.GetCFramesFromPoints)

local TRACKS = {
    PointToPoint = PointToPointCFrameTrack;
    PointToPoint2 = PointToPointCFrameTrack2;
    -- SpacekBezier = NWSpacekBezierCFrameTrack;
}


local function CreateCFrameTrackFromInstanceData(instanceData, name)
    assert(typeof(instanceData) == "Instance")

    local typeValue = instanceData:FindFirstChild("TrackClass")
    local newTrack

    if (typeValue ~= nil) then
        local trackClassName = typeValue.Value
        local trackClass = TRACKS[trackClassName]
        assert(trackClass)

        newTrack = trackClass.FromInstanceData(instanceData)
    else    -- assume just points data and not circuited
        newTrack = PointToPointCFrameTrack2.new({
            Points = GetCFramesFromPoints(instanceData)
        })
    end

    newTrack.Name = name or instanceData.Name


    return newTrack
end


return CreateCFrameTrackFromInstanceData