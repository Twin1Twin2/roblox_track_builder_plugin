
local function GetCFramePositionFromObject(object)
    if (object == nil) then
        return nil, "Object is nil!"
    elseif (typeof(object) == "CFrame") then
        return object
    elseif (typeof(object) ~= "Instance") then
        return nil, "Object is not an Instance!"
    elseif (object:IsA("CFrameValue") == true) then
        return object.Value
    elseif (object:IsA("BasePart") == true) then
        return object.CFrame
    end
    return nil, "Object is an invalid type"
end


local function GetTrackDataFromModel(instance)
    assert(typeof(instance) == "Instance")

    local pointsData = instance:FindFirstChild("Points")
    local isCircuitedValue = instance:FindFirstChild("IsCircuited")
    local hashIntervalValue = instance:FindFirstChild("HashInterval")

    assert(pointsData)
    assert(isCircuitedValue)

    local points = {}
    local missingPoints = {}

    for index = 1, #pointsData:GetChildren(), 1 do
        local point = pointsData:FindFirstChild(tostring(index))
        local cframe, message = GetCFramePositionFromObject(point)
        if (cframe ~= nil) then
            table.insert(points, index, cframe)
        else
            missingPoints[index] = message
        end
    end

    if (#missingPoints > 0) then
        warn("Missing Points!")

        for i, warnMessage in pairs(missingPoints) do
            warn("    " .. tostring(i) .. " " .. warnMessage)
        end

        error()
    end

    local hashInterval = 10

    if (hashIntervalValue ~= nil) then
        assert(hashIntervalValue:IsA("ValueBase"))
        hashInterval = hashIntervalValue.Value
        assert(type(hashInterval) == "number")
    end

    local data = {
        Points = points;
        IsCircuited = isCircuitedValue.Value;
        HashInterval = hashInterval;
    }


    return data
end


return GetTrackDataFromModel