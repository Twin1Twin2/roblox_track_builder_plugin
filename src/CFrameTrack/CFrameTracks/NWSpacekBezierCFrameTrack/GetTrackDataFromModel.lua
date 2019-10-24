
local function IsBasePart(instance)
    return typeof(instance) == "Instance" and instance:IsA("BasePart")
end


local function GetTrackDataFromModel(instance)
    assert(typeof(instance) == "Instance")

    local layoutData = instance

    assert(layoutData)

    -- get number of curves from the endpoints
    local numCurves = 0

    for _, child in pairs(layoutData:GetChildren()) do
        local childName = child.Name
        if (child:IsA("BasePart") == true and childName:find("Endpoint")) then
            local endPointNumber = tonumber(childName:sub(9))
            assert(endPointNumber)

            if (endPointNumber > numCurves) then
                numCurves = endPointNumber
            end
        end
    end

    assert(numCurves > 0)

    local curveData = {}

    -- get curve data
    for currentNumber = 1, numCurves - 1, 1 do
        local previousNumber = currentNumber - 1

        local pointA = layoutData:FindFirstChild("EndPoint" .. previousNumber)
        local pointB = layoutData:FindFirstChild("EndPoint" .. currentNumber)
        local controlPointA = layoutData:FindFirstChild("ControlPointA" .. currentNumber)
        local controlPointB = layoutData:FindFirstChild("ControlPointB" .. currentNumber)
        local rollPoint = layoutData:FindFirstChild("RollPoint" .. currentNumber)

        assert(IsBasePart(pointA), "EndPoint" .. previousNumber .. " not found!")
        assert(IsBasePart(pointB), "EndPoint" .. currentNumber .. " not found!")
        assert(IsBasePart(controlPointA), "ControlPointA" .. currentNumber .. " not found!")
        assert(IsBasePart(controlPointB), "ControlPointB" .. currentNumber .. " not found!")
        assert(IsBasePart(rollPoint), "RollPoint" .. currentNumber .. " not found!")

        local data = {
            PointA = pointA.CFrame;
            PointB = pointB.CFrame;
            ControlPointA = controlPointA.CFrame;
            ControlPointB = controlPointB.CFrame;
            RollPoint = rollPoint.CFrame;
        }

        table.insert(curveData, data)
    end


    return {
        Curves = curveData;
    }
end


return GetTrackDataFromModel