--- PointToPointCFrameTrack3
-- Uses TrackDataHasher

local CFrameTrack = require(script.Parent.Parent.CFrameTrack)
local TrackDataHasher = require(script.Parent.Parent.TrackDataHasher)

local GetTrackDataFromModule = require(script.GetTrackDataFromModule)
local GetTrackDataFromModel = require(script.GetTrackDataFromModel)


local PointToPointCFrameTrack2 = {
    ClassName = "PointToPointCFrameTrack2";
}

PointToPointCFrameTrack2.__index = PointToPointCFrameTrack2
setmetatable(PointToPointCFrameTrack2, CFrameTrack)


function PointToPointCFrameTrack2.new(data)
    assert(type(data) == "table")

    local self = setmetatable(CFrameTrack.new(), PointToPointCFrameTrack2)

    self.Hasher = nil

    self.IsCircuited = false
    self.CircuitRemainder = 0
    self.LengthWithoutCircuitRemainder = 0

    self:SetData(data)


    return self
end


--- Creates a new PointToPointCFrameTrack2, but using instance data
--
function PointToPointCFrameTrack2.FromInstanceData(instanceData)
    assert(typeof(instanceData) == "Instance")

    local data

    -- modulescript
    if (instanceData:IsA("ModuleScript") == true) then
        data = GetTrackDataFromModule(instanceData)
    else    -- model
        data = GetTrackDataFromModel(instanceData)
    end


    local newTrack = PointToPointCFrameTrack2.new(data)

    return newTrack
end


function PointToPointCFrameTrack2:Destroy()
    self.Hasher:Destroy()
    self.Hasher = nil

    CFrameTrack.Destroy(self)
    setmetatable(self, nil)
end


function PointToPointCFrameTrack2:SetData(data)
    local points = data.Points
    local isCircuited = data.IsCircuited
    local hashInterval = data.HashInterval

    assert(type(points) == "table" and #points > 0)

    if (isCircuited == nil) then
        isCircuited = self.IsCircuited
    end

    hashInterval = hashInterval or 10
    assert(type(hashInterval) == "number" and hashInterval > 0)

    local function getLengthFunction(p1, p2)
        return (p1.Position - p2.Position).Magnitude
    end

    local hasher = TrackDataHasher.new(
        points,
        getLengthFunction,
        hashInterval
    )

    local length = hasher.Length
    local circuitRemainder = 0
    local lengthWithoutCircuitRemainder = length

    if (isCircuited == true) then
        circuitRemainder = getLengthFunction(points[#points], points[1])
        length = length + circuitRemainder
    end

    self.Hasher = hasher
    self.Length = length
    self.CircuitRemainder = circuitRemainder
    self.LengthWithoutCircuitRemainder = lengthWithoutCircuitRemainder
    self.IsCircuited = isCircuited
end


function PointToPointCFrameTrack2:GetCFramePosition(position)
    local hasher = self.Hasher
    local circuited = self.IsCircuited
    local lengthWithoutCircuitRemainder = self.LengthWithoutCircuitRemainder

    if (circuited == true) then -- clamp position to track length
        position = (position % self.Length)
    end

    if (circuited == true and position >= lengthWithoutCircuitRemainder) then
        local points = hasher.TrackData
        local p1 = points[#points]
        local p2 = points[1]
        local lerpValue = (position - lengthWithoutCircuitRemainder) / self.CircuitRemainder

        return p1:Lerp(p2, lerpValue)
    end

    local p1, p2, difference = hasher:GetData(position)

    if (p1 == nil) then -- position is <= 0
        return p2 * CFrame.new(0, 0, -difference)
    elseif (p2 == nil) then -- position is >= trackLength
        return p1 * CFrame.new(0, 0, -difference)
    else
        local lerpValue = 0
        local magnitude = hasher.GetLengthFunction(p1, p2)

        if (magnitude ~= 0) then
            lerpValue = difference / hasher.GetLengthFunction(p1, p2)
        end

        return p1:Lerp(p2, lerpValue)
    end
end


return PointToPointCFrameTrack2