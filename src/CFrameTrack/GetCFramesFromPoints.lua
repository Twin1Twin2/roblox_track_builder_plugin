
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


local function GetCFramesFromPoints(pointsData)
    assert(typeof(pointsData) == "Instance")

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

    return points
end


return GetCFramesFromPoints