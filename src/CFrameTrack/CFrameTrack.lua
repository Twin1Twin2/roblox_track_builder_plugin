---


local CFrameTrack = {
    ClassName = "CFrameTrack";
}

CFrameTrack.__index = CFrameTrack


function CFrameTrack.new(name)
    local self = setmetatable({}, CFrameTrack)

    self.Name = name or "DEFAULT_TRACK_NAME"
    self.Length = 0


    return self
end


function CFrameTrack.FromInstanceData()
    error("FromInstanceData not implemented!")
end


function CFrameTrack:Destroy()
    setmetatable(self, nil)
end


function CFrameTrack:GetCFramePosition(position)
    return CFrame.new()
end


return CFrameTrack