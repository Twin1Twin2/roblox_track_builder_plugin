
local Utilities = script.Parent.Utilities

local GetCFrameFromObject = require(Utilities.GetCFrameFromObject)
local GetLookVectorCFrame = require(Utilities.GetLookVectorCFrame)


local TieModelData = {
    ClassName = "TieModelData";
}

TieModelData.__index = TieModelData


function TieModelData.new(data, name)
    local self = setmetatable({}, TieModelData)

    self.Name = name or "DEFAULT_TIE_NAME"

    self.Model = nil
    self.Offset = CFrame.new()

    self.UseLookVector = false


    if (data ~= nil) then
        self:SetData(data)
    end

    return self
end


function TieModelData.FromInstanceData(instanceData, name)
    assert(typeof(instanceData) == "Instance")

    name = name or instanceData.Name

    local model = instanceData:FindFirstChild("Model")
    local offsetValue = instanceData:FindFirstChild("Offset")
    local useLookVectorValue = instanceData:FindFirstChild("UseLookVector")

    assert(model and model:IsA("Model"), "Model must be a Model!")
    assert(model.PrimaryPart ~= nil, "Model must have it's PrimaryPart set!")

    -- convert offset to a cframe value
    local offset = GetCFrameFromObject(offsetValue)

    assert(offset, "Unable to get offset")

    if (instanceData:FindFirstChild("CALC_OFFSET_FROM_MODEL")) then
        -- calculate offset from primarypart
        local modelCFrame = model:GetPrimaryPartCFrame()
        offset = offset:ToObjectSpace(modelCFrame)
    end

    local useLookVector = false

    if (useLookVectorValue ~= nil) then
        assert(useLookVectorValue:IsA("BoolValue"), "Use2 is not a boolean value!")
        useLookVector = useLookVectorValue.Value
    end


    return TieModelData.new({
        Model = model;
        Offset = offset;
        UseLookVector = useLookVector;
    }, name)
end


function TieModelData:SetData(data)
    local model = data.Model
    local offset = data.Offset
    local useLookVector = data.UseLookVector

    assert(typeof(model) == "Instance" and model:IsA("Model"), "Model must be a Model!")
    assert(model.PrimaryPart ~= nil, "Model must have it's PrimaryPart set!")

    assert(typeof(offset) == "CFrame")

    self.Model = model
    self.Offset = offset
    self.UseLookVector = useLookVector
end


function TieModelData:Build(cframe, colorData)
    local tieModel = self.Model:Clone()
    local offset = self.Offset

    if (self.UseLookVector == true) then
        cframe = GetLookVectorCFrame(cframe)
    end

    local newCFrame = cframe:ToWorldSpace(offset)
    tieModel:SetPrimaryPartCFrame(newCFrame)

    return tieModel
end


function TieModelData:BuildModelsFromTrack(cframeTrack, startPosition, endPosition, interval, startOffset)
    assert(startPosition < endPosition)
    assert(interval > 0)

    local currentPosition = startPosition + startOffset

    local model = Instance.new("Model")
    model.Name = self.Name

    local index = 1

    local function BuildModel(p)
        local cframe = cframeTrack:GetCFramePosition(p)

        local tieModel = self:Build(cframe)
        tieModel.Name = tostring(index)
        tieModel.Parent = model

        index = index + 1
    end

    while (currentPosition <= endPosition) do
        BuildModel(currentPosition)

        currentPosition = currentPosition + interval
    end

    return model
end


return TieModelData