

local function GetCFrameFromInstance(instance)
    if (typeof(instance) ~= "Instance") then
        return nil
    end

    if (instance:IsA("CFrameValue")) then
        return instance.Value
    elseif (instance:IsA("Vector3Value")) then
        return CFrame.new(instance.Value)
    elseif (instance:IsA("BasePart")) then
        return instance.CFrame
    elseif (instance:IsA("ObjectValue")) then
        return GetCFrameFromInstance(instance.Value)
    end

    return nil
end


return GetCFrameFromInstance