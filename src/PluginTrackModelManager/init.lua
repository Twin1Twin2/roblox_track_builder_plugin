
local Selection = game:GetService("Selection")

local TrackModelData = require(script.Parent.TrackModelData.TrackModelData)
local Actions = require(script.Parent.Actions)

local PluginTrackManager = require(script.Parent.PluginTrackManager)


local PluginTrackModelManager = {
    ClassName = "PluginTrackModelManager";
}

PluginTrackModelManager.__index = PluginTrackModelManager


function PluginTrackModelManager.new()
    local self = setmetatable({}, PluginTrackModelManager)

    self.Store = nil

    self.CurrentTrackModel = nil


    return self
end


function PluginTrackModelManager:InitStore(store)
    self.Store = store
    self.Store:dispatch(Actions.SetCurrentTrackModel(nil))
end


function PluginTrackModelManager:LoadSelected()
    local selections = Selection:Get()
    local selection = selections[1]

    local trackModelData

    local success, message = pcall(function()
        trackModelData = TrackModelData.FromInstanceData(selection)
    end)

    if (success == false) then
        warn(message)
        return false
    end

    if (self.CurrentTrackModel ~= nil) then
        self:DeselectCurrent()
    end

    self.CurrentTrackModel = trackModelData
    self.Store:dispatch(Actions.SetCurrentTrackModel(trackModelData.Name))

    return true
end


function PluginTrackModelManager:DeselectCurrent()
    if (self.CurrentTrackModel == nil) then
        return
    end

    self.CurrentTrackModel:Destroy()
    self.CurrentTrackModel = nil
    self.Store:dispatch(Actions.SetCurrentTrackModel(nil))
end


function PluginTrackModelManager:BuildCurrent(rangeStart, rangeEnd)
    if (self.CurrentTrackModel == nil) then
        return
    end

    local currentTrack = PluginTrackManager:GetCurrent()
    if (currentTrack == nil) then
        return
    end

    local model = self.CurrentTrackModel:Build(currentTrack, rangeStart, rangeEnd)
    model.Parent = workspace
    Selection:Set({model})
end


return PluginTrackModelManager.new()