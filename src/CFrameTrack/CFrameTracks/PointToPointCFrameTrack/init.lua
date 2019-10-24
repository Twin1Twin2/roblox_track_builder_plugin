--- PointToPointCFrameTrack
--

local CFrameTrack = require(script.Parent.Parent.CFrameTrack)

local GetTrackDataFromModule = require(script.GetTrackDataFromModule)
local GetTrackDataFromModel = require(script.GetTrackDataFromModel)


local function GetVerticalAngleOfCFrame(cframe)
    local lookVector = cframe.LookVector

    return -math.atan2(lookVector.Y, Vector2.new(lookVector.X, lookVector.Z).Magnitude)
end


local PointToPointCFrameTrack = {
    ClassName = "PointToPointCFrameTrack";
}

PointToPointCFrameTrack.__index = PointToPointCFrameTrack
setmetatable(PointToPointCFrameTrack, CFrameTrack)


function PointToPointCFrameTrack.new(data)
    local self = setmetatable(CFrameTrack.new(), PointToPointCFrameTrack)

    self.Points = {}

    self.DistanceBetweenPoints = 1

    self.IsCircuited = false
    self.CircuitRemainder = 0
    self.LengthWithoutCircuitRemainder = 0

    if (type(data) == "table") then
        self:SetData(data)
    end


    return self
end


--- Creates a new PointToPointCFrameTrack, but using instance data
--
function PointToPointCFrameTrack.FromInstanceData(instanceData)
    assert(typeof(instanceData) == "Instance")

    local data

    -- modulescript
    if (instanceData:IsA("ModuleScript") == true) then
        data = GetTrackDataFromModule(instanceData)
    else    -- model
        data = GetTrackDataFromModel(instanceData)
    end


    local newTrack = PointToPointCFrameTrack.new(data)

    return newTrack
end


function PointToPointCFrameTrack:Destroy()
    self.Points = nil

    CFrameTrack.Destroy(self)
    setmetatable(self, nil)
end


function PointToPointCFrameTrack:SetData(data)
    local points = data.Points
    local distanceBetweenPoints = data.DistanceBetweenPoints
    local isCircuited = data.IsCircuited

    assert(type(points) == "table")
    assert(type(distanceBetweenPoints) == "number" and distanceBetweenPoints > 0)

    if (isCircuited == nil) then
        isCircuited = self.IsCircuited
    end

    local numPoints = #points
    local length = ((numPoints - 1) * distanceBetweenPoints)
    local lengthWithoutCircuitRemainder = length
    local circuitRemainder = 0

    assert(numPoints > 0)

    if (isCircuited == true) then
        circuitRemainder = (points[numPoints].Position - points[1].Position).Magnitude
        length = length + circuitRemainder
    end

    self.Points = points
    self.DistanceBetweenPoints = distanceBetweenPoints
    self.Length = length
    self.CircuitRemainder = circuitRemainder
    self.LengthWithoutCircuitRemainder = lengthWithoutCircuitRemainder
    self.IsCircuited = isCircuited
end


function PointToPointCFrameTrack:GetCFramePosition(position)
    local trackLength = self.Length
    local points = self.Points
    local numPoints = #points
    local isCircuited = self.IsCircuited

    if (isCircuited == false) then
        if (position >= trackLength) then
            local difference = position - trackLength
            local cf = points[numPoints]
            return cf * CFrame.new(0, 0, -difference)
        elseif (position <= 0) then
            local cf = points[1]
            return cf * CFrame.new(0, 0, -position)
        end
    end

    local circuitRemainder = self.CircuitRemainder
    local lengthWithoutCircuitRemainder = self.LengthWithoutCircuitRemainder

    local p1, p2
    local lerpValue

    position = position % trackLength

    if (isCircuited == true and position >= lengthWithoutCircuitRemainder) then
        if (circuitRemainder == 0) then
            return points[numPoints]
        else
            p1 = points[numPoints]
            p2 = points[1]
            lerpValue = (position - lengthWithoutCircuitRemainder) / circuitRemainder
        end
    else
        local distanceBetweenPoints = self.DistanceBetweenPoints
        local pIndex = math.floor(position / distanceBetweenPoints) + 1
        p1 = points[pIndex]
        p2 = points[pIndex + 1]
        lerpValue = (position % distanceBetweenPoints) / distanceBetweenPoints
    end

    return p1:Lerp(p2, lerpValue)
end


return PointToPointCFrameTrack