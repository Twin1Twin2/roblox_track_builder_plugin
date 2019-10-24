--- Groups one or more Rail, Tie, and/or Crossbeam Model data to be built as one interval
--

local RailModelData = require(script.Parent.RailModelData)
local TieModelData = require(script.Parent.TieModelData)
local CrossbeamModelData = require(script.Parent.CrossbeamModelData)


local TrackModelData = {
    ClassName = "TrackModelData";
}

TrackModelData.__index = TrackModelData


function TrackModelData.new(name)
    local self = setmetatable({}, TrackModelData)

    self.Name = name or "DEFAULT_TRACK_NAME"

    self.RailModels = {}
    self.TieModels = {}
    self.CrossbeamModels = {}


    return self
end


function TrackModelData.FromInstanceData(instanceData, name)
    assert(typeof(instanceData) == "Instance")

    local railModels = instanceData:FindFirstChild("Rails")
    local tieModels = instanceData:FindFirstChild("Ties")
    local crossbeamModels = instanceData:FindFirstChild("Crossbeams")

    assert(railModels)
    assert(tieModels)
    assert(crossbeamModels)

    name = name or instanceData.Name

    local newTrackModelData = TrackModelData.new(name)

    local function GetIntervalData(instanceData)
        local positionIntervalValue = instanceData:FindFirstChild("PositionInterval")
        local startOffsetValue = instanceData:FindFirstChild("PositionStartOffset")

        assert(positionIntervalValue)

        local positionInterval = positionIntervalValue.Value
        local startOffset = 0

        if (startOffsetValue ~= nil) then
            startOffset = startOffsetValue.Value
        end

        return positionInterval, startOffset
    end

    for _, railModel in pairs(railModels:GetChildren()) do
        local positionInterval, startOffset = GetIntervalData(railModel)
        local railModelData = RailModelData.FromInstanceData(railModel)

        newTrackModelData:AddRailModel(railModelData, positionInterval, startOffset)
    end

    for _, tieModel in pairs(tieModels:GetChildren()) do
        local positionInterval, startOffset = GetIntervalData(tieModel)
        local tieModelData = TieModelData.FromInstanceData(tieModel)

        newTrackModelData:AddTieModel(tieModelData, positionInterval, startOffset)
    end

    -- for _, crossbeamModel in pairs(crossbeamModels:GetChildren()) do
    --     local positionInterval, startOffset = GetIntervalData(crossbeamModel)
    --     local crossbeamModelData = CrossbeamModelData.FromInstanceData(crossbeamModel)

    --     newTrackModelData:AddCrossbeamModel(crossbeamModelData, positionInterval, startOffset)
    -- end


    return newTrackModelData
end


function TrackModelData:Destroy()
    for _, railModel in pairs(self.RailModels) do

    end

    for _, tieModel in pairs(self.TieModels) do

    end

    for _, crossbeamModel in pairs(self.CrossbeamModels) do

    end

    self.RailModels = nil
    self.TieModels = nil
    self.CrossbeamModels = nil

    setmetatable(self, nil)
end


local function CreateModelIntervalData(modelData, positionInterval, startOffset)
    return {
        ModelData = modelData;
        PositionInterval = positionInterval;
        StartOffset = startOffset;
    }
end


function TrackModelData:AddRailModel(railModel, positionInterval, startOffset)
    startOffset = startOffset or 0

    assert(railModel)
    assert(type(positionInterval) == "number")
    assert(type(startOffset) == "number")

    -- create rail model if an instance?

    local intervalData = CreateModelIntervalData(railModel, positionInterval, startOffset)
    table.insert(self.RailModels, intervalData)
end


function TrackModelData:AddTieModel(tieModel, positionInterval, startOffset)
    startOffset = startOffset or 0

    assert(tieModel)
    assert(type(positionInterval) == "number")
    assert(type(startOffset) == "number")

    local intervalData = CreateModelIntervalData(tieModel, positionInterval, startOffset)
    table.insert(self.TieModels, intervalData)
end


function TrackModelData:AddCrossbeamModel(crossbeamModel, positionInterval, startOffset)
    startOffset = startOffset or 0

    assert(crossbeamModel)
    assert(type(positionInterval) == "number")
    assert(type(startOffset) == "number")

    local intervalData = CreateModelIntervalData(crossbeamModel, positionInterval, startOffset)
    table.insert(self.CrossbeamModels, intervalData)
end


function TrackModelData:Build(cframeTrack, startPosition, endPosition)
    local model = Instance.new("Model")
    model.Name = self.Name .. "BuiltTrack"

    local function BuildModelsFromIntervalData(modelIntervalDataTable)
        for _, modelIntervalData in pairs(modelIntervalDataTable) do
            local modelData = modelIntervalData.ModelData
            local positionInterval = modelIntervalData.PositionInterval
            local startOffset = modelIntervalData.StartOffset

            local builtModels = modelData:BuildModelsFromTrack(cframeTrack, startPosition, endPosition, positionInterval, startOffset)
            builtModels.Parent = model
        end
    end

    BuildModelsFromIntervalData(self.RailModels)
    BuildModelsFromIntervalData(self.TieModels)
    BuildModelsFromIntervalData(self.CrossbeamModels)


    return model
end


return TrackModelData