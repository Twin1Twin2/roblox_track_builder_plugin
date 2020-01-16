-- Goal: Get a way to Lerp the ZOrientation between two CFrames
--      in a way that it's similar to :Lerp()


local MATH_PI_2 = math.pi * 2

local function GetZAngleOfCFrame(cframe)
    local _, _, z = cframe:ToOrientation()
    return z
end


local function GetRotationCFrame(cframe)
    local p = -cframe.Position
    return cframe * CFrame.new(p.X, p.Y, p.Z)
end

--[[
- what is the cframe angles z rotation to return startLookCFrame back to startCFrame

- what is the cframe angles z rotation to return endLookCFrame back to endCFrame

- turn it into a 2D problem
    - i'm trying to get the rotation around the Z-Axis of the midCFrame
        - 0 is the current rotation
    - use two of the direction axises
--]]

local function swingTwist(cf, direction)
    local axis, theta = cf:ToAxisAngle()
    -- convert to quaternion
    local w, v = math.cos(theta/2),  math.sin(theta/2)*axis

    -- (v . d)*d, plug into CFrame quaternion constructor with w it will solve rest for us
	local proj = v:Dot(direction)*direction
    local twist = CFrame.new(0, 0, 0, proj.x, proj.y, proj.z, w)

    -- cf = swing * twist, thus...
	local swing = cf * twist:Inverse()

	return swing, twist
end


local function twistAngle(cf, direction)
    local axis, theta = cf:ToAxisAngle()
    local w, v = math.cos(theta/2), math.sin(theta/2)*axis
	local proj = v:Dot(direction) * direction
    local twist = CFrame.new(0, 0, 0, proj.x, proj.y, proj.z, w)
    local nAxis, nTheta = twist:ToAxisAngle()
    return math.sign(v:Dot(direction))*select(2, twist:ToAxisAngle())
end


local function GetMidZOrientation2(startCFrame, endCFrame, midCFrame)
    local axis = midCFrame.LookVector
    local axisSign = math.sign(axis.Y)
    local midCFrameAngle = midCFrame - midCFrame.Position

    local startCFrameAngle = startCFrame - startCFrame.Position
    local startTwistAngle = twistAngle(startCFrameAngle:Inverse() * midCFrameAngle, startCFrameAngle:VectorToObjectSpace(axis)) * axisSign

    local endCFrameAngle = endCFrame - endCFrame.Position
    local endTwistAngle = twistAngle(midCFrameAngle:Inverse() * endCFrameAngle, endCFrameAngle:VectorToObjectSpace(axis)) * axisSign

    return (startTwistAngle + endTwistAngle) * 0.5

    -- axis = startCFrameAngle:VectorToObjectSpace(axis)
    -- return twistAngle(startCFrame:Inverse() * endCFrame, axis) / 2 --* axisSign
end


local function GetMidZOrientation(startCFrame, endCFrame, midCFrame)
    local startZAngle = GetZAngleOfCFrame(startCFrame) + MATH_PI_2
    local endZAngle = GetZAngleOfCFrame(endCFrame) + MATH_PI_2

    return ((startZAngle + endZAngle) / 2) - MATH_PI_2
end

-- applied: cframe * CFrame.Angles(0, 0, zRotation)

return GetMidZOrientation2