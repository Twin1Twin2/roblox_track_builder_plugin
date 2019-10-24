
local GetCFrameFromInstance = require(script.Parent.GetCFrameFromInstance)


local function GetCFrameFromObject(object)
    local objectTypeOf = typeof(object)

    if (objectTypeOf == "CFrame") then
        return object
    elseif (objectTypeOf == "Vector3") then
        return CFrame.new(object)
    elseif (objectTypeOf == "Instance") then
        return GetCFrameFromInstance(object)
    end

    return nil
end


return GetCFrameFromObject