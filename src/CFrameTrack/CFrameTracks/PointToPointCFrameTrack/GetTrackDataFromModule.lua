
local function GetTrackDataFromModule(moduleScript)
    assert(typeof(moduleScript) == "Instance" and moduleScript:IsA("ModuleScript"))

    local data = require(moduleScript)

    -- check for points
    -- check for distance between points
    -- check for iscircuited

    local points = data.Points
    local distanceBetweenPoints = data.DistanceBetweenPoints
    local isCircuited = data.IsCircuited

    assert(type(points) == "table")
    assert(type(distanceBetweenPoints) == "number" and distanceBetweenPoints > 0)
    assert(type(isCircuited) == "boolean")

    for index, point in pairs(points) do
        assert(typeof(point) == "CFrame", "Point " .. tostring(index) .. " is not a CFrame!")
    end


    return data
end


return GetTrackDataFromModule