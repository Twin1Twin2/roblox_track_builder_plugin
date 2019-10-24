local module = {}

--BEZIER CUBIC
function module.BQ(p0,p1,p2,p3,t)
	return p0*(1-t)^3+t*p1*3*(1-t)^2+3*p2*(1-t)*t^2+p3*t^3
end

--BEZIER CUBIC PRIME
function module.BQp(p0,p1,p2,p3,t)
	return 3*(p1-p0)*(1-t)^2+6*t*(p2-p1)*(1-t)+3*(p3-p2)*t^2
end
--BEZIER CUBIC DOUBLE PRIME
function module.BQpp(p0,p1,p2,p3,t)
	return 6*(1-t)*(p2-2*p1+p0)+6*t*(p3-2*p2+p1)
	--return p2*(6-18*t)+p0*(6-6*t)+6*p3*t+p1*(-12+18*t)
end

--BEZIER QUADRATIC
function module.B2(p0,p1,p2,t)
	return p0*(1-t)^2+2*p1*t*(1-t)+p2*t^2
end

--BEZIER QUADRATIC PRIME
function module.B2p(p0,p1,p2,t)
	return 2*(1-t)*(p1-p0)+2*t*(p2-p1)
end

--BEZIER QUADRATIC DOUBLE PRIME
function module.B2pp(p0,p1,p2,t)
	return 2*(p2-2*p1+p0)
end

local sqrt=math.sqrt
local acos=math.acos
local sin=math.sin
local cos=math.cos
local abs=math.abs
local max=math.max
local atan2 = math.atan2
local v3=Vector3.new
local n3=v3()
local Dot=v3().Dot
local Cross=v3().Cross
local Lerp = v3().Lerp
local cf=CFrame.new
local nc=cf()
local components=cf().components
local inverse=cf().inverse
local fromAxisAngle=CFrame.fromAxisAngle

--lerps between two cframes
function AxisAngleInterpolate(c0,c1,t)--CFrame0,CFrame1,Tween
 local _,_,_,xx,yx,zx,xy,yy,zy,xz,yz,zz=components(inverse(c0)*c1)
 local r=acos((xx+yy+zz-1)/2)*t
 local c=r==r and r~=0 and c0*fromAxisAngle(v3(yz-zy,zx-xz,xy-yx),r)+(c1.p-c0.p)*t or c0+(c1.p-c0.p)*t
 if c.lookVector.x==c.lookVector.x then return c else return c0 end
end

--lerps between two cframes
local CFrameInterpolate = require(script.Parent.CFrameInterpolate)

--looks at a vector3 from a cframe
local AxisAngleLook = require(script.Parent.AxisAngleLook)

--SLERP --I've never found out what theta is supposed to do
function module.slerp(u0,u1,t)
	return sin((1-t)*theta)*u0 + sin(t*theta*u1)/sin(theta)
end

--creates arrows for the CFrame at its point
local function makeAxis(cf,m)
	local x,y,z,xx,yx,zx,xy,yy,zy,xz,yz,zz = components(cf)
	local pos = cf.p
	local N = v3(yx,yy,yz)
	local B = v3(xx,xy,xz)
	local T = v3(zx,zy,zz)
	local p = Instance.new("Part",m)
	local s = Instance.new("SpecialMesh",p)
	s.MeshType = "Cylinder"
	p.Anchored = true
	p.Size = Vector3.new(1,0.2,0.2)
	p.CFrame = CFrame.new(pos+T/2,pos+T)*CFrame.Angles(0,math.pi/2,0)
	p.BrickColor = BrickColor.Blue()
	local q=p:Clone()
	q.Parent = m
	q.CFrame = CFrame.new(pos+N/2,pos+N)*CFrame.Angles(0,math.pi/2,0)
	q.BrickColor = BrickColor.Green()
	local r = q:Clone()
	r.Parent = m
	r.CFrame = CFrame.new(pos+B/2,pos+B)*CFrame.Angles(0,math.pi/2,0)
	r.BrickColor = BrickColor.Red()
end

--finds the local frame of a bezier curve at point t
function module.CubicCurveCFrame(p0,p1,p2,p3,t)
	local pos = module.BQ(p0,p1,p2,p3,t)
	local T = -module.BQp(p0,p1,p2,p3,t).unit
	local n = module.BQpp(p0,p1,p2,p3,t).unit
	local B = T:Cross(n).unit
	local N = -B:Cross(T).unit
	return CFrame.new(pos.x,pos.y,pos.z,B.x,N.x,T.x,B.y,N.y,T.y,B.z,N.z,T.z)
end

--lerps between two values. 1, 2, or 3 dimensions allowed.
local function interpolate(p0,p1,t)
	return (p1-p0)*t+p0
end

--splits a curve into 2 pieces
--DE CASTELJAU'S THEORUM
function module.Split(p0,p1,mp,p2,p3)
	p0 = v3(p0.X,p0.Y,p0.Z)
	p1 = v3(p1.X,p1.Y,p1.Z)
	p2 = v3(p2.X,p2.Y,p2.Z)
	p3 = v3(p3.X,p3.Y,p3.Z)
	mp = v3(mp.X,mp.Y,mp.Z)
	local a0 = p0
	local b3 = p3
	local a1 = interpolate(a0,p1,0.5)
	local b2 = interpolate(p2,b3,0.5)
	local mv = interpolate(p1,p2,0.5)
	local a2 = interpolate(a1,mv,0.5)
	local b1 = interpolate(mv,b2,0.5)
	local a3 = interpolate(a2,b1,0.5)
	local b0 = a3

	return a0,a1,a2,a3,b0,b1,b2,b3
		-- cf,v3,v3,cf,cf,v3,v3,cf
end

--splits a curve into 2 pieces and includes midpoints rotated correctly
function module.SplitRotate(p0,p1,mp,p2,p3)
	local a0,a1,a2,a3,b0,b1,b2,b3 = module.Split(p0,p1,mp,p2,p3)

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

	local bmp = CFrames[6+max/2]*CFrameInterpolate(nc,DifferenceEnd,0.5)

	return p0,a1,amp,a2,mp,mp,b1,bmp,b2,p3
		-- cf,v3,cf ,v3,cf,cf,v3,cf ,v3,cf
end

--will combine 2 curves into 1
function module.Combine(a0,a1,_,a3,_,_,b2,b3)
	local p1 = interpolate(v3(a0.X,a0.Y,a0.Z),v3(a1.X,a1.Y,a1.Z),2)
	local p2 = interpolate(v3(b3.X,b3.Y,b3.Z),v3(b2.X,b2.Y,b2.Z),2)
	return a0,p1,module.ReconfigureMid(a0,p1,a3,p2,b3),p2,b3
end


--when changing the control points/endpoints, use this to put the midpoint where it should be
function module.ReconfigureMid(p0,p1,mp,p2,p3)
	p1 = v3(p1.X,p1.Y,p1.Z)
	p2 = v3(p2.X,p2.Y,p2.Z)
	return AxisAngleLook(mp-mp.p,module.BQp(p0.p,p1,p2,p3.p,0.5))+module.BQ(p0.p,p1,p2,p3.p,0.5)
end

--when you have a curve that is out of alignment
function module.Reconfigure(p0,p1,mp,p2,p3)
	local a1 = v3(p1.X,p1.Y,p1.Z)
	local a2 = v3(p2.X,p2.Y,p2.Z)
	p0 = AxisAngleLook(p0,a1)
	mp = module.ReconfigureMid(p0,a1,mp,a2,p3)
	p3 = AxisAngleLook(p3,p3.p*2-a2)
	return p0,p1,mp,p2,p3
end


--use this for the preview curve
function module.UpdatePreview(p0,p1,mp,p2,p3,parts)
	local max = 0
	if type(parts) == "userdata" then
		parts = parts:GetChildren()
	end
	max = #parts
	--MAX BETTER BE EVEN OR THERE'LL BE HELL TO PAY
	--local m = Instance.new("Model",workspace)

	local a0,a1,a2,a3,b0,b1,b2,b3 = module.Split(p0,p1,mp,p2,p3)

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
	for i = 0.5,max/2 do
		local t = i/max*2
		parts[i+0.5].CFrame = CFrames[i+0.5]*CFrameInterpolate(nc,DifferenceMid,t)
	end
	for i = 0.5,max/2 do
		local t = i/max*2
		parts[i+0.5+max/2].CFrame = CFrames[i+0.5+max/2]*CFrameInterpolate(nc,DifferenceEnd,t)
	end
end

function module.CreateCompiledCurve(p0,p1,p2,p3,PartLength,PartOffset)

	local CFrames = {}

	--local a0,a1,a2,a3,b0,b1,b2,b3 = module.Split(p0,p1,mp,p2,p3)
	local granularity = math.floor(((p0.p-p1).magnitude+(p1-p2).magnitude+(p2-p3.p).magnitude)*5+0.5)*2
	local aPoints = {p0}
	local aDistances = {0}
	--local bPoints = {mp}
	--local bDistances = {0}
	for i = 1, granularity do
		local t = i/granularity
		local aCFrame = AxisAngleLook(aPoints[i]-aPoints[i].p,module.BQp(p0.p,p1,p2,p3.p,t))+module.BQ(p0.p,p1,p2,p3.p,t)
		--local aCFrame = AxisAngleLook(aPoints[i]-aPoints[i].p,module.BQp(a0,a1,a2,a3,t))+module.BQ(a0,a1,a2,a3,t)
		--local bCFrame = AxisAngleLook(bPoints[i]-bPoints[i].p,module.BQp(b0,b1,b2,b3,t))+module.BQ(b0,b1,b2,b3,t)
		table.insert(aPoints,aCFrame)
		--table.insert(bPoints,bCFrame)
		table.insert(aDistances,aDistances[i]+(aCFrame.p-aPoints[i].p).magnitude)
		--table.insert(bDistances,bDistances[i]+(bCFrame.p-bPoints[i].p).magnitude)
	end
	local aDistance = aDistances[#aDistances]
	--local bDistance = bDistances[#bDistances]

	--local DifferenceMid = inverse(aPoints[#aPoints])*mp
	--local DifferenceEnd = inverse(bPoints[#bPoints])*p3
	local DifferenceEnd = inverse(aPoints[#aPoints])*p3

	local offset = PartOffset-PartLength/2
	local LastPartChecked = 1
	while offset+PartLength < aDistance do
		offset = offset+PartLength
		for i = LastPartChecked, #aDistances-1 do
			if aDistances[i]<=offset and aDistances[i+1]>=offset then
				LastPartChecked = i
				break
			end
		end
		local t = (offset-aDistances[LastPartChecked])/(aDistances[LastPartChecked+1]-aDistances[LastPartChecked])
		local OverallAlpha = interpolate((LastPartChecked-1)/granularity,LastPartChecked/granularity,t)
		table.insert(CFrames,(AxisAngleLook(aPoints[LastPartChecked]-aPoints[LastPartChecked].p,module.BQp(p0.p,p1,p2,p3.p,OverallAlpha))+module.BQ(p0.p,p1,p2,p3.p,OverallAlpha))*CFrameInterpolate(nc,DifferenceEnd,OverallAlpha))
	end

	return offset-aDistance+PartLength/2,CFrames
end

function module.CompileCurve(p0,p1,mp,p2,p3,PartLength,PartOffset)
	local a0,a1,amp,a2,a3,b0,b1,bmp,b2,b3 = module.SplitRotate(p0,p1,mp,p2,p3)
	local offset,CFrames = module.CreateCompiledCurve(a0,a1,a2,a3,PartLength,PartOffset)
	local offset2,CFrames2 = module.CreateCompiledCurve(b0,b1,b2,b3,PartLength,offset)
	for i = 1, #CFrames2 do
		table.insert(CFrames,CFrames2[i])
	end
	return offset2,CFrames
end

return module
