
local function lerp(a, b, t)
	return a + (b - a) * t
end

--splits a curve into 2 pieces
--DE CASTELJAU'S THEORUM
local function SplitCurve(p0, p1, mp, p2, p3)
	p0 = Vector3.new(p0.X, p0.Y, p0.Z)
	p1 = Vector3.new(p1.X, p1.Y, p1.Z)
	p2 = Vector3.new(p2.X, p2.Y, p2.Z)
	p3 = Vector3.new(p3.X, p3.Y, p3.Z)
    mp = Vector3.new(mp.X, mp.Y, mp.Z)

	local a0 = p0
	local b3 = p3
	local a1 = lerp(a0, p1, 0.5)
	local b2 = lerp(p2, b3, 0.5)
	local mv = lerp(p1, p2, 0.5)
	local a2 = lerp(a1, mv, 0.5)
	local b1 = lerp(mv, b2, 0.5)
	local a3 = lerp(a2, b1, 0.5)
	local b0 = a3

	return a0, a1, a2, a3, b0, b1, b2, b3
		-- cf,v3,v3,cf,cf,v3,v3,cf
end

--splits a curve into 2 pieces and includes midpoints rotated correctly
local function SplitRotateCurve(p0, p1, mp, p2, p3)
	local a0,a1,a2,a3,b0,b1,b2,b3 = SplitCurve(p0,p1,mp,p2,p3)

	local max = 22

	local CFrames = {}

	for i = 0.5,max/2 do
		local t = i/max*2
		local PreviousCFrame = i>0.5 and CFrames[i-0.5] or p0
		table.insert(CFrames,AxisAngleLook(PreviousCFrame-PreviousCFrame.p,module.BQp(a0,a1,a2,a3,t))+module.BQ(a0,a1,a2,a3,t))
		end
	local CurveAtMid = AxisAngleLook(CFrames[#CFrames]-CFrames[#CFrames].p,module.BQp(a0,a1,a2,a3,1))+module.BQ(a0,a1,a2,a3,1)
	for i = 0.5,max/2 do
		local t = i/max*2
		local PreviousCFrame = i>0.5 and CFrames[i-0.5+max/2] or mp
		table.insert(CFrames,AxisAngleLook(PreviousCFrame-PreviousCFrame.p,module.BQp(b0,b1,b2,b3,t))+module.BQ(b0,b1,b2,b3,t))
	end
	local CurveAtEnd = AxisAngleLook(CFrames[#CFrames]-CFrames[#CFrames].p,module.BQp(b0,b1,b2,b3,1))+module.BQ(b0,b1,b2,b3,1)
	local DifferenceMid = inverse(CurveAtMid)*mp
	local DifferenceEnd = inverse(CurveAtEnd)*p3
	local amp = CFrames[6]*CFrameInterpolate(nc,DifferenceMid,0.5)

	local bmp = CFrames[6+max/2] * CFrameInterpolate(nc,DifferenceEnd,0.5)

	return p0,a1,amp,a2,mp,mp,b1,bmp,b2,p3
		-- cf,v3,cf ,v3,cf,cf,v3,cf ,v3,cf
end


local BezierCurve = {
    ClassName = "BezierCurve";
}

BezierCurve.__index = BezierCurve


function BezierCurve.new()
    local self = setmetatable({}, BezierCurve)

    self.PointA = CFrame.new()
    self.PointB = CFrame.new()
    self.ControlPointA = CFrame.new()
    self.ControlPointB = CFrame.new()


    return self
end


local NWSpacekBezierCurve = {
    ClassName = "NWSpacekBezierCurve";
}

NWSpacekBezierCurve.__index = NWSpacekBezierCurve


function NWSpacekBezierCurve.new()
    local self = setmetatable({}, NWSpacekBezierCurve)

    self.PointA = CFrame.new()
    self.PointB = CFrame.new()
    self.ControlPointA = CFrame.new()
    self.ControlPointB = CFrame.new()
    self.RollPoint = CFrame.new()

    self.Length = 0
    self.HalfLength = 0


    return self
end


function NWSpacekBezierCurve:SetData(data)
    local pointA = data.PointA
    local pointB = data.PointB
    local controlPointA = data.ControlPointA
    local controlPointB = data.ControlPointB
    local rollPoint = data.RollPoint

    assert(typeof(pointA) == "CFrame")
    assert(typeof(pointB) == "CFrame")
    assert(typeof(controlPointA) == "CFrame")
    assert(typeof(controlPointB) == "CFrame")
    assert(typeof(rollPoint) == "CFrame")

    -- split into two curves
    local curveA, curveB = SplitRotateCurve()
    -- calculate length for both
end


function NWSpacekBezierCurve:GetCFramePosition(position)
    -- position must be [0, length]
end


return NWSpacekBezierCurve