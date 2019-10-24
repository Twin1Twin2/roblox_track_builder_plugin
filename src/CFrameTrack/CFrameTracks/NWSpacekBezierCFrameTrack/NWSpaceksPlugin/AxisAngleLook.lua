local BackCF = CFrame.new(0,0,0,-1,0,0,0,1,0,0,0,-1)
local V3Divide=CFrame.new().pointToObjectSpace
local cf = CFrame.new

return function (CFrame,Point)
    local rv=V3Divide(CFrame,Point)
    local rx,ry,rz= rv.x,rv.y,rv.z
    local m= (rx*rx+ry*ry+rz*rz)^0.5
    if rz/m<0.99999 then
		local s= ((m-rz)*m*2)^0.5
        return CFrame * cf(
	        0,0,0,
	        ry/s,-rx/s,0,(m-rz)/s
        )
    else
		return CFrame*BackCF
    end
end