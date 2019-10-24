
local Utilities = script.Parent.Utilities

local GetCFrameFromObject = require(Utilities.GetCFrameFromObject)


local CrossbeamModelData = {
    ClassName = "CrossbeamModelData";
}

CrossbeamModelData.__index = CrossbeamModelData


function CrossbeamModelData.new(data, name)
    local self = setmetatable({}, CrossbeamModelData)

    self.Name = name or "DEFAULT_CROSSBEAM_NAME"

    self.BasePart = nil
    self.StartOffset = Vector3.new()
    self.EndOffset = Vector3.new()


    return self
end


function CrossbeamModelData.FromInstanceData(instanceData, name)
    error("Not Implemented Yet")

    assert(typeof(instanceData) == "Instance")

    name = name or instanceData.Name

    local basePart = instanceData:FindFirstChild("BasePart")
    local startOffsetValue = instanceData:FindFirstChild("StartOffset")
    local endOffsetValue = instanceData:FindFirstChild("EndOffset")

    assert(basePart, "BasePart not given!")

    local basePartPosition = basePart.Position

    local offset

    if (offsetValue:IsA("ObjectValue")) then
        offsetValue = offsetValue.Value
    end
    -- convert offset to a vector3

    if (offsetValue:IsA("Vector3Value")) then   -- offset from vector3value
        offset = offsetValue.Value
    elseif (offsetValue:IsA("BasePart")) then   -- offset from basepart
        local offsetCFrame = GetCFrameFromObject(offsetValue)
        offset = offsetCFrame:PointToObjectSpace(basePartPosition)
    elseif (offsetValue:IsA("Model") or offsetValue:IsA("Folder")) then  -- two offsets
        -- get cframes
        local startOffset = GetCFrameFromObject(offsetValue:FindFirstChild("StartCFrame"))
        local endOffset = GetCFrameFromObject(offsetValue:FindFirstChild("EndCFrame"))

        assert(startOffset)
        assert(endOffset)

        local midOffset = CFrame.new(startOffset.Position:Lerp(endOffset.Position, 0.5), endOffset.Position)

        offset = midOffset:PointToObjectSpace(basePartPosition)
    end

    assert(offset, "Unable to convert Offset to a Vector3 value!")


    return CrossbeamModelData.new({
        BasePart = basePart;
        StartOffset = startOffset;
        EndOffset = endOffset;
        MiddleOffset = midOffset;
    }, name)
end


function CrossbeamModelData:SetData(data)
    local basePart = data.BasePart

    assert(typeof(basePart) == "Instance" and basePart:IsA("BasePart"))

    self.BasePart = basePart
end


function CrossbeamModelData:Build(startCFrame, endCFrame)
    local basePart = self.BasePart:Clone()
    local startOffsetCFrame = CFrame.new(self.StartOffset)
    local endOffsetCFrame = CFrame.new(self.EndOffset)

    local basePartSize = basePart.Size
    local width = basePartSize.Y
    local height = basePartSize.Z


    local newStartCFrame = startCFrame * startOffsetCFrame
    local newEndCFrame = endCFrame * endOffsetCFrame
    local distance = (newStartCFrame.Position - newEndCFrame.Position).Magnitude

    local newCFrame = newEndCFrame:Lerp(newStartCFrame, 0.5) * self.MiddleOffset
    -- local newCFrame = CFrame.new(startPosition:lerp(endPosition, 0.5), endPosition)

    -- temp
    basePart.Size = Vector3.new(distance, width, height)
    basePart.CFrame = newCFrame


    return basePart
end


function CrossbeamModelData:BuildModelsFromTrack(cframeTrack, startPosition, endPosition, interval, startOffset)
    local model = Instance.new("Model")
    model.Name = self.Name


    return model
end


return CrossbeamModelData