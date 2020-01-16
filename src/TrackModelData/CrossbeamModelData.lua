
local Utilities = script.Parent.Utilities

local GetCFrameFromObject = require(Utilities.GetCFrameFromObject)
local GetMidZOrientation = require(Utilities.GetMidZOrientation)


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
    self.Axis = "Z"

    if (data ~= nil) then
        self:SetData(data)
    end


    return self
end


local function GetNegativeFromBool(value)
    if (value == true) then
        return -1
    end
    return 1
end


local function GetCFrameFromAxis(axis, value)
    if (axis == "X") then
        return CFrame.new(value, 0, 0)
    elseif (axis == "Y") then
        return CFrame.new(0, value, 0)
    elseif (axis == "Z") then
        return CFrame.new(0, 0, value)
    end
end


local function GetOffsetFromBasePartEnd(basePart, offsetCFrame, axis, isNegative)
    -- get from offsets
    local basePartCFrame = basePart.CFrame
    local hsize = (basePart.Size[axis] / 2) * GetNegativeFromBool(isNegative)

    local cframe = basePartCFrame * GetCFrameFromAxis(axis, hsize) -- get where the position of the start/end; need axis
    return offsetCFrame:PointToObjectSpace(cframe.Position)
end


function CrossbeamModelData.FromInstanceData(instanceData, name)
    assert(typeof(instanceData) == "Instance")

    name = name or instanceData.Name

    local basePart = instanceData:FindFirstChild("BasePart")
    assert(basePart, "Child \"BasePart\" not found!")

    local axisValue = instanceData:FindFirstChild("Axis")
    assert(axisValue and axisValue:IsA("StringValue"), "Axis is not a StringValue!")
    local axis = axisValue.Value

    local startOffsetValue = instanceData:FindFirstChild("StartOffset")
    local endOffsetValue = instanceData:FindFirstChild("EndOffset")

    local function GetOffsetFromObject(offsetValue)
        if (offsetValue == nil) then
            return
        elseif (offsetValue:IsA("Vector3Value")) then   -- offset from vector3value
            return offsetValue.Value
        elseif (offsetValue:IsA("CFrameValue")) then
            return offsetValue.Value.CFrame
        elseif (offsetValue:IsA("Model") or offsetValue:IsA("Folder")) then  -- two offsets
            -- get cframes
            local startCFrame = GetCFrameFromObject(offsetValue:FindFirstChild("Start"))
            local offsetCFrame = GetCFrameFromObject(offsetValue:FindFirstChild("Offset"))

            assert(startCFrame)
            assert(offsetCFrame)

            return startCFrame:PointToObjectSpace(offsetCFrame.Position)
        end
    end

    local startOffset = GetOffsetFromObject(startOffsetValue)
    local endOffset = GetOffsetFromObject(endOffsetValue)

    local offsetsValue = instanceData:FindFirstChild("Offsets")
    if (offsetsValue ~= nil) then
        if (offsetsValue:IsA("ObjectValue")) then
            offsetsValue = offsetsValue.Value
            assert(offsetsValue)
        end

        if (startOffsetValue == nil) then
            local offsetStartCFrame = GetCFrameFromObject(offsetsValue:FindFirstChild("StartCFrame"))
            startOffset = GetOffsetFromBasePartEnd(basePart, offsetStartCFrame, axis, true)
        end
        if (endOffsetValue == nil) then
            local offsetEndCFrame = GetCFrameFromObject(offsetsValue:FindFirstChild("EndCFrame"))
            endOffset = GetOffsetFromBasePartEnd(basePart, offsetEndCFrame, axis, false)
        end
    end

    assert(startOffset, "Unable to get StartOffset!")
    assert(endOffset, "Unable to get EndOffset!")

    local rotation = Vector3.new()
    local rotationValue = instanceData:FindFirstChild("Rotation")
    if (rotationValue ~= nil) then
        assert(rotationValue:IsA("Vector3Value"))
        rotation = rotationValue.Value

        if (rotationValue:FindFirstChild("IS_DEGREES")) then
            rotation = Vector3.new(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
        end
    end

    return CrossbeamModelData.new({
        BasePart = basePart;
        StartOffset = startOffset;
        EndOffset = endOffset;
        Rotation = rotation;
        Axis = axis;
    }, name)
end


function CrossbeamModelData:Destroy()
    self.BasePart = nil

    setmetatable(self, nil)
end


function CrossbeamModelData:SetData(data)
    local basePart = data.BasePart
    local startOffset = data.StartOffset
    local endOffset = data.EndOffset
    local rotation = data.Rotation
    local axis = data.Axis

    assert(typeof(basePart) == "Instance" and basePart:IsA("BasePart"))
    assert(typeof(startOffset) == "Vector3")
    assert(typeof(endOffset) == "Vector3")
    assert(typeof(rotation) == "Vector3")
    assert(type(axis) == "string")

    self.BasePart = basePart
    self.StartOffset = startOffset
    self.EndOffset = endOffset
    self.Rotation = rotation
    self.Axis = axis
end


function CrossbeamModelData:Build(startCFrame, endCFrame)
    local axis = self.Axis

    local basePart = self.BasePart:Clone()
    local startOffsetCFrame = CFrame.new(self.StartOffset)
    local endOffsetCFrame = CFrame.new(self.EndOffset)

    local newStartCFrame = startCFrame * startOffsetCFrame
    local newEndCFrame = endCFrame * endOffsetCFrame
    local distance = (newStartCFrame.Position - newEndCFrame.Position).Magnitude

    -- local newCFrame = newEndCFrame:Lerp(newStartCFrame, 0.5) * self.MiddleOffset
    -- local newCFrame = CFrame.new(startPosition:lerp(endPosition, 0.5), endPosition)

    local newPosition = newStartCFrame.Position:Lerp(newEndCFrame.Position, 0.5)
    local newCFrame = CFrame.new(newPosition, newEndCFrame.Position)

    -- local startZAngle = GetZAngleOfCFrame(startCFrame)
    -- local endZAngle = GetZAngleOfCFrame(endCFrame)

    -- local zRotation = (startZAngle + endZAngle) / 2
    local zRotation = GetMidZOrientation(startCFrame, endCFrame, newCFrame)

    newCFrame = newCFrame * CFrame.fromOrientation(0, 0, zRotation) --* CFrame.Angles(-math.pi / 2, 0, 0)

    -- temp
    local basePartSize = basePart.Size
    local size

    if (axis == "X") then
        size = Vector3.new(distance, basePartSize.Y, basePartSize.Z)
    elseif (axis == "Y") then
        size = Vector3.new(basePartSize.X, distance, basePartSize.Z)
    elseif (axis == "Z") then
        size = Vector3.new(basePartSize.X, basePartSize.Y, distance)
    end

    basePart.Size = size
    basePart.CFrame = newCFrame


    return basePart
end


function CrossbeamModelData:BuildModelsFromTrack(cframeTrack, startPosition, endPosition, positionInterval, startOffset)
    assert(startPosition < endPosition)

    local currentPosition = startPosition + startOffset

    local model = Instance.new("Model")
    model.Name = self.Name

    local index = 1

    local function BuildModel(p1, p2)
        local startCFrame = cframeTrack:GetCFramePosition(p1)
        local endCFrame = cframeTrack:GetCFramePosition(p2)

        local crossbeamBasePart = self:Build(startCFrame, endCFrame)
        crossbeamBasePart.Name = tostring(index)
        crossbeamBasePart.Parent = model

        index = index + 1
    end

    local lastPosition = currentPosition
    currentPosition = currentPosition + positionInterval

    while (currentPosition <= endPosition) do
        BuildModel(lastPosition, currentPosition)

        lastPosition = currentPosition
        currentPosition = currentPosition + positionInterval
    end

    if (lastPosition ~= endPosition) then
        BuildModel(lastPosition, endPosition)
    end

    return model
end


return CrossbeamModelData