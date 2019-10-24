--

local RailModelData = require(script.Parent.RailModelData)


local PhysicsRailModelData = {
    ClassName = "PhysicsRailModelData";
}

PhysicsRailModelData.__index = PhysicsRailModelData
setmetatable(PhysicsRailModelData, RailModelData)


function PhysicsRailModelData.new()
    local self = setmetatable(RailModelData.new(), PhysicsRailModelData)


    return self
end


function PhysicsRailModelData:Build(startCFrame, endCFrame, speed)
    local basePart = RailModelData.Build(self, startCFrame, endCFrame)

    -- do physical property stuff?

    -- do physics stuff
    local basePartCFrame = basePart.CFrame
    local axis = self.Axis
    local moveVelocity = Vector3.new(0, 0, -speed)
    local newVelocity
    local axisModifier

    if (self.IsAxisNegative == false) then
        axisModifier = 1
    else
        axisModifier = -1
    end

    if (axis == "X") then
        -- right vector?
        newVelocity = (axisModifier * basePartCFrame.RightVector) * moveVelocity
    elseif (axis == "Y") then
        -- up vector
        newVelocity = (axisModifier * basePartCFrame.UpVector) * moveVelocity
    elseif (axis == "Z") then
        -- look vector?
        newVelocity = (axisModifier * -basePartCFrame.LookVector) * moveVelocity
    end

    basePart.Velocity = newVelocity

    return basePart
end


return PhysicsRailModelData