--- Manages tracks loaded in this plugin
--

local Selection = game:GetService("Selection")

local CreateTrackFromInstanceData = require(script.Parent.CFrameTrack.CreateCFrameTrackFromInstanceData)
local Actions = require(script.Parent.Actions)

local GenerateWoodenSupports = require(script.Parent.GenerateWoodenSupports)


local PluginTrackManager = {
    ClassName = "PluginTrackManager";
}

PluginTrackManager.__index = PluginTrackManager


function PluginTrackManager.new()
    local self = setmetatable({}, PluginTrackManager)

    self.Store = nil

    self.CurrentTrack = nil -- int; current select track
    self.Tracks = {}        -- list of tracks


    return self
end


function PluginTrackManager:InitStore(store)
    self.Store = store

    self.Store:dispatch(Actions.SetCurrentTrack(nil, ""))
    self.Store:dispatch(Actions.SetLoadedTracks({}))
end


function PluginTrackManager:GetCurrent()
    if (self.CurrentTrack == nil) then
        return nil
    end

    return self.Tracks[self.CurrentTrack]
end


function PluginTrackManager:UpdateLoadedTracks()
    local loadedTracks = {}

    for trackUID, cframeTrack in ipairs(self.Tracks) do
        loadedTracks[trackUID] = cframeTrack.Name
    end

    self.Store:dispatch(Actions.SetLoadedTracks(loadedTracks))
end


function PluginTrackManager:SetCurrentTrack(trackUID)
    local trackName

    if (trackUID ~= nil) then
        local cframeTrack = self.Tracks[trackUID]
        assert(cframeTrack, "Unable to get track with TrackUID " .. tostring(trackUID))

        trackName = cframeTrack.Name
    end

    self.CurrentTrack = trackUID
    self.Store:dispatch(Actions.SetCurrentTrack(trackUID, trackName))
end


--- Loads a track and adds it
--
function PluginTrackManager:LoadSelectedTrack()
    local selections = Selection:Get()
    local selection = selections[1]

    local cframeTrack

    local success, message = pcall(function()
        cframeTrack = CreateTrackFromInstanceData(selection)
    end)

    if (success == false) then
        warn(message)
        return false
    end

    table.insert(self.Tracks, cframeTrack)
    self:UpdateLoadedTracks()

    local trackUID = #self.Tracks
    self:SetCurrentTrack(trackUID)

    return true
end


function PluginTrackManager:DeselectCurrentTrack()
    if (self.CurrentTrack == nil) then
        return
    end

    self:SetCurrentTrack()
end


function PluginTrackManager:UnloadTrack(trackUID)
    local cframeTrack = self.Tracks[trackUID]

    if (cframeTrack == nil) then
        return
    end

    cframeTrack:Destroy()
    table.remove(self.Tracks, trackUID)
    self:UpdateLoadedTracks()
end


function PluginTrackManager:GenerateWoodenSupports()
    local currentTrack = self:GetCurrent()
    if (currentTrack == nil) then
        return
    end

    local model = GenerateWoodenSupports(currentTrack, 0, currentTrack.Length)
    model.Parent = workspace
    Selection:Set({model})
end


return PluginTrackManager.new()