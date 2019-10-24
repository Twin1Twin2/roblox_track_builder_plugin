
local CFrameTrack = require(script.Parent.Parent.CFrameTrack)

local NWSpacekBezierCurve = require(script.NWSpacekBezierCurve)
local GetTrackDataFromModel = require(script.GetTrackDataFromModel)


local NWSpacekBezierCFrameTrack = {
    ClassName = "NWSpacekBezierCFrameTrack";
}

NWSpacekBezierCFrameTrack.__index = NWSpacekBezierCFrameTrack
setmetatable(NWSpacekBezierCFrameTrack, CFrameTrack)


function NWSpacekBezierCFrameTrack.new(data)
    local self = setmetatable(CFrameTrack.new(), NWSpacekBezierCFrameTrack)

    self.Curves = {}

    self.IsCircuited = false

    self:SetData(data)


    return self
end


function NWSpacekBezierCFrameTrack.FromInstanceData(instance)
    assert(typeof(instance) == "Instance")

    local data = GetTrackDataFromModel(instance)

    return NWSpacekBezierCFrameTrack.new(data)
end


function NWSpacekBezierCFrameTrack:SetData(data)
    local curveData = data.Curves

    local length = 0
    local bezierCurves = {}

    for _, cData in ipairs(curveData) do
        local newBCurve = NWSpacekBezierCurve.new(cData)
        length = length + newBCurve.Length

        table.insert(bezierCurves, newBCurve)
    end

    self.Curves = bezierCurves
    self.Length = length
end


function NWSpacekBezierCFrameTrack:GetCFramePosition(position)
    error("Not Implemented!")
end


return NWSpacekBezierCFrameTrack