
local Utilities = script.Parent.Utilities

local GetCFrameFromObject = require(Utilities.GetCFrameFromObject)
local GetLookVectorCFrame = require(Utilities.GetLookVectorCFrame)


local MINIMUM_ZERO_ANGLE = 0.99995

local function IsCFrameStraightAhead(cf1, cf2)
    local lvDot = cf1.LookVector:Dot(cf2.LookVector)
    local posDot = cf1.LookVector:Dot((cf2.Position - cf1.Position).Unit)
    local rotDot = cf1.RightVector:Dot(cf2.RightVector)

    return lvDot > MINIMUM_ZERO_ANGLE and posDot > MINIMUM_ZERO_ANGLE and rotDot > MINIMUM_ZERO_ANGLE
end


local RailModelData = {
    ClassName = "RailModelData";
}

RailModelData.__index = RailModelData


function RailModelData.new(data, name)
    local self = setmetatable({}, RailModelData)

    self.Name = name or "DEFAULT_RAIL_NAME"

    self.BasePart = nil
    self.Offset = Vector3.new()
    self.Axis = "X"
    self.Rotation = Vector3.new(0, -math.pi / 2, 0)
    self.UseLookVector = false
    self.UseZOrientation = true

    self.IsOptimized = false

    if (data ~= nil) then
        self:SetData(data)
    end

    return self
end


function RailModelData.FromInstanceData(instanceData, name)
    assert(typeof(instanceData) == "Instance")

    name = name or instanceData.Name

    local basePart = instanceData:FindFirstChild("BasePart")
    local offsetValue = instanceData:FindFirstChild("Offset")
    local axisValue = instanceData:FindFirstChild("Axis")
    local rotationValue = instanceData:FindFirstChild("Rotation")
    local useLookVectorValue = instanceData:FindFirstChild("UseLookVector")
    local useZOrientationValue = instanceData:FindFirstChild("UseZOrientation")
    local isOptimizedValue = instanceData:FindFirstChild("IsOptmized")

    local offset
    local axis
    local rotation = Vector3.new()
    local useLookVector = false
    local useZOrientation = true
    local isOptimized = false

    assert(basePart, "BasePart not given!")

    local basePartPosition = basePart.Position

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
        assert(IsCFrameStraightAhead(startOffset, endOffset))

        local midOffset = CFrame.new(startOffset.Position:Lerp(endOffset.Position, 0.5), endOffset.Position)

        offset = midOffset:PointToObjectSpace(basePartPosition)

        -- get rotation
        if (rotationValue == nil) then
            local midCFrame = startOffset:Lerp(endOffset, 0.5)
            local x, y, z = midCFrame:ToObjectSpace(basePart.CFrame):ToEulerAnglesXYZ()
            rotation = Vector3.new(x, y, z)
        end
    end

    assert(offset, "Unable to convert Offset to a Vector3 value!")

    assert(axisValue and axisValue:IsA("StringValue"), "Axis is not a string value!")
    axis = axisValue.Value

    if (rotationValue ~= nil) then
        assert(rotationValue:IsA("Vector3Value"))
        rotation = rotationValue.Value

        if (rotationValue:FindFirstChild("IS_DEGREES")) then
            rotation = Vector3.new(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
        end
    end

    if (useLookVectorValue ~= nil) then
        assert(useLookVectorValue:IsA("BoolValue"), "UseLookVector is not a boolean value!")
        useLookVector = useLookVectorValue.Value
    end

    if (useZOrientationValue ~= nil) then
        assert(useZOrientationValue:IsA("BoolValue"), "UseLookVector is not a boolean value!")
        useZOrientation = useZOrientationValue.Value
    end

    if (isOptimizedValue ~= nil) then
        assert(isOptimizedValue:IsA("BoolValue"), "IsOptimized is not a boolean value!")
        isOptimized = isOptimizedValue.Value
    end

    return RailModelData.new({
        BasePart = basePart;
        Offset = offset;
        Axis = axis;
        Rotation = rotation;
        UseLookVector = useLookVector;
        UseZOrientation = useZOrientation;
        IsOptimized = isOptimized;
    }, name)
end


function RailModelData:SetData(data)
    local basePart = data.BasePart
    local offset = data.Offset
    local axis = data.Axis
    local rotation = data.Rotation
    local useLookVector = data.UseLookVector
    local useZOrientation = data.UseZOrientation
    local isOptimized = data.IsOptimized

    assert(typeof(basePart) == "Instance" and basePart:IsA("BasePart"))
    assert(typeof(offset) == "Vector3")
    assert(type(axis) == "string")
    assert(typeof(rotation) == "Vector3")
    assert(type(useLookVector) == "boolean")
    assert(type(useZOrientation) == "boolean")
    assert(type(isOptimized) == "boolean")

    self.BasePart = basePart
    self.Offset = offset
    self.Axis = axis
    self.Rotation = rotation
    self.UseLookVector = useLookVector
    self.UseZOrientation = useZOrientation
    self.IsOptimized = isOptimized
end


local function GetZAngleOfCFrame(cframe)
    local _, _, z = cframe:ToOrientation()

    return z
end


function RailModelData:Build(startCFrame, endCFrame, colorData)
    local basePart = self.BasePart:Clone()
    local offsetCFrame = CFrame.new(self.Offset)
    local rotation = self.Rotation
    local axis = self.Axis

    local buildStartCFrame = startCFrame
    local buildEndCFrame = endCFrame

    if (self.UseLookVector == true) then
        buildStartCFrame = GetLookVectorCFrame(startCFrame)
        buildEndCFrame = GetLookVectorCFrame(endCFrame)
    end

    local startPosition = (buildStartCFrame * offsetCFrame).Position
    local endPosition = (buildEndCFrame * offsetCFrame).Position
    local distance = (startPosition - endPosition).Magnitude
    local newCFrame = CFrame.new(startPosition:Lerp(endPosition, 0.5), endPosition)

    if (self.UseZOrientation == true) then
        local startZAngle = GetZAngleOfCFrame(startCFrame)
        local endZAngle = GetZAngleOfCFrame(endCFrame)

        local zRotation = (startZAngle + endZAngle) / 2
        newCFrame = newCFrame * CFrame.Angles(0, 0, zRotation)
    end

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
    basePart.CFrame = newCFrame * CFrame.Angles(rotation.X, rotation.Y, rotation.Z)


    return basePart
end


function RailModelData:_BuildModelsFromTrack(cframeTrack, startPosition, endPosition, positionInterval, startOffset)
    assert(startPosition < endPosition)

    local currentPosition = startPosition + startOffset

    local model = Instance.new("Model")
    model.Name = self.Name

    local index = 1

    local function BuildModel(p1, p2)
        local startCFrame = cframeTrack:GetCFramePosition(p1)
        local endCFrame = cframeTrack:GetCFramePosition(p2)

        local railBasePart = self:Build(startCFrame, endCFrame)
        railBasePart.Name = tostring(index)
        railBasePart.Parent = model

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


function RailModelData:_BuildModelsFromTrackOptimized(cframeTrack, startPosition, endPosition, positionInterval, startOffset)
    assert(startPosition < endPosition)

    local currentPosition = startPosition + startOffset

    local model = Instance.new("Model")
    model.Name = self.Name

    local isInStraightSection = false
    local lastPosition = currentPosition
    local lastCFrame = cframeTrack:GetCFramePosition(lastPosition)
    local lastUsedCFrame = lastCFrame

    local index = 1

    local function BuildModel(startCFrame, endCFrame)
        local railBasePart = self:Build(startCFrame, endCFrame)
        railBasePart.Name = tostring(index)
        railBasePart.Parent = model

        index = index + 1

        lastUsedCFrame = endCFrame
    end

    currentPosition = currentPosition + positionInterval

    while (currentPosition <= endPosition) do
        local currentCFrame = cframeTrack:GetCFramePosition(currentPosition)

        if (isInStraightSection == true) then
            local isStraightAhead = IsCFrameStraightAhead(lastUsedCFrame, currentCFrame)

            if (isStraightAhead == false) then
                BuildModel(lastUsedCFrame, currentCFrame)
                isInStraightSection = false
            end
        end

        if (isInStraightSection == false) then
            local isStraightAhead = IsCFrameStraightAhead(lastCFrame, currentCFrame)

            if (isStraightAhead == false) then
                BuildModel(lastCFrame, currentCFrame)
            else
                isInStraightSection = true
            end
        end

        lastCFrame = currentCFrame
        lastPosition = currentPosition
        currentPosition = currentPosition + positionInterval
    end

    if (isInStraightSection == true or lastPosition ~= endPosition) then
        local currentCFrame = cframeTrack:GetCFramePosition(endPosition)
        BuildModel(lastUsedCFrame, currentCFrame)
    end


    return model
end


function RailModelData:BuildModelsFromTrack(cframeTrack, startPosition, endPosition, positionInterval, startOffset)
    assert(startPosition < endPosition)

    if (self.IsOptimized == true) then
        return self:_BuildModelsFromTrackOptimized(cframeTrack, startPosition, endPosition, positionInterval, startOffset)
    else
        return self:_BuildModelsFromTrack(cframeTrack, startPosition, endPosition, positionInterval, startOffset)
    end
end


return RailModelData