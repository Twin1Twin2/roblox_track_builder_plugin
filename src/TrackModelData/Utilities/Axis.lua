
local VALID_AXIS_NAMES = {
    ["X"] = true;
    ["-X"] = true;
    ["Y"] = true;
    ["-Y"] = true;
    ["Z"] = true;
    ["-Z"] = true;
}


local Axis = {}

function Axis.IsAxis(axis)
    assert(type(axis) == "string")

    return VALID_AXIS_NAMES[axis]
end


function Axis.GetAxisFromCFrame(cframe, axis)

end


function Axis.GetAxisFromVector3()

end


return Axis