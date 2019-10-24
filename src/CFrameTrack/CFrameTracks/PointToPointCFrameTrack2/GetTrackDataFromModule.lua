
local function GetTrackDataFromModule(moduleScript)
    assert(typeof(moduleScript) == "Instance" and moduleScript:IsA("ModuleScript"))

    local data = require(moduleScript)

    -- check for points
    -- check for distance between points
    -- check for iscircuited

    local points = data.Points
    local isCircuited = data.IsCircuited
    local hashInterval = data.HashInterval

    assert(type(points) == "table")
    assert(type(isCircuited) == "boolean")
    assert(type(hashInterval) == "number")

    for index, point in pairs(points) do
        assert(typeof(point) == "CFrame", "Point " .. tostring(index) .. " is not a CFrame!")
    end


    return data
end


return GetTrackDataFromModule