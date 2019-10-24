repeat
	wait()
until script.Parent.Parent.Parent.script.Value~=nil

mouse= require(script.Parent.Parent.Parent.script.Value.plugclass):getmouse()
deb = true
ba = script.Parent.Configuration

curtrack=nil
prevtrack=nil

used=false
stepused=false

prevHandRailUsed=false

prevCatWalkRUsed=false
prevCatWalkLUsed=false
prevCatWalkBUsed=false

prevTriSptRUsed=false
prevTriSptLUsed=false
prevTriSptBUsed=false

Baseplate=game.Workspace.Baseplate -- Name of your Baseplate goes here

--

function clickedf(mouse)
	clicked=mouse.Target
		if clicked~=nil then
			if clicked.Name=="Track" then
				curtrack=clicked
				color=ba.supportcolor.Value
				SupportSeg=Instance.new("Model",workspace)
				SupportSeg.Name="SupportSegment"

				btype=ba.type
				catwalksval=ba.catwalks.Value
				cccval=ba.collisions.Value
--				stepsptBval=false
--				stepsptLval=false
--				stepsptRval=false
--				trisptBval=false
--				trisptLval=false
--				trisptRval=false
				if ba.supportstyle.Value=="Step Left" then
					stepsptBval=false
					stepsptLval=true
					stepsptRval=false
					trisptBval=false
					trisptLval=false
					trisptRval=false
				elseif ba.supportstyle.Value=="Step Right" then
					stepsptBval=false
					stepsptLval=false
					stepsptRval=true
					trisptBval=false
					trisptLval=false
					trisptRval=false
				elseif ba.supportstyle.Value=="Step Both" then
					stepsptBval=true
					stepsptLval=false
					stepsptRval=false
					trisptBval=false
					trisptLval=false
					trisptRval=false
				elseif ba.supportstyle.Value=="Normal" then
					stepsptBval=false
					stepsptLval=false
					stepsptRval=false
					trisptBval=false
					trisptLval=false
					trisptRval=false
				elseif ba.supportstyle.Value=="Tri Left" then
					stepsptBval=false
					stepsptLval=false
					stepsptRval=false
					trisptBval=false
					trisptLval=true
					trisptRval=false	
				elseif ba.supportstyle.Value=="Tri Right" then
					stepsptBval=false
					stepsptLval=false
					stepsptRval=false
					trisptBval=false
					trisptLval=false
					trisptRval=true
				elseif ba.supportstyle.Value=="Tri Both" then
					stepsptBval=false
					stepsptLval=false
					stepsptRval=false
					trisptBval=true
					trisptLval=false
					trisptRval=false
				else
					error("An error has occurred, if the error persists please contact lrogerorrit",0)
				end
				

				tb=Instance.new("Part",SupportSeg)
				tb.Anchored=true
				tb.CanCollide=false
				tb.CFrame=curtrack.CFrame
				local x, y, z, _, _, m02, m10, m11, m12, _, _, m22 = tb.CFrame:components()
				local heading = math.atan2(m02, m22)
				local attitude = math.asin(-m12)
				local bank = math.atan2(m10, m11)
				
				tb.CFrame = CFrame.new(x, y, z) * CFrame.Angles(0, heading, 0)
				tb.CFrame = tb.CFrame * CFrame.Angles(0,0,bank)
				
				if bank>=.1 then
					btype.Value="Left"
				elseif bank<=-.1 then
					btype.Value="Right"
				elseif bank<.1 and bank>-.1 then
					btype.Value="Both"
				end
				
				curtrack=tb
				
--------
--BENT--
--------
				bent=Instance.new("Part",workspace)
 				bent.Name="bent"
 				bent.Anchored=true
 				bent.CanCollide=false
 				bent.Parent=SupportSeg
 				bent.Size=Vector3.new(18,2,.6) --normally 18.8
 				bent.CFrame=curtrack.CFrame*CFrame.new(0,-2.4,0)
 				hbcfif=bent.CFrame*CFrame.new(1,0,0)
 				hbcfbh=bent.CFrame*CFrame.new(-1,0,0)
 				hbcfifp=Vector3.new(hbcfif.X,hbcfif.Y,hbcfif.Z)
 				hbcfbhp=Vector3.new(hbcfbh.X,hbcfbh.Y,hbcfbh.Z)
 				bent.CFrame=CFrame.new(hbcfifp:lerp(hbcfbhp,.5),hbcfbhp)*CFrame.Angles(0,math.rad(-90),0)
--[[if btype.Value~="Both" then
 to=bent.CFrame:vectorToObjectSpace(Vector3.new(0,1,0))
 bent.CFrame=bent.CFrame*CFrame.new(Vector3.new(),to*Vector3.new(1,0,1))
bent.CFrame=bent.CFrame*CFrame.Angles(0,math.rad(-90),0)
end]]
 				bent.Material=Enum.Material.Wood
 				bent.BrickColor=color
 				bent.TopSurface=Enum.SurfaceType.Smooth
 				bent.BottomSurface=Enum.SurfaceType.Smooth
				bentcf1=bent.CFrame*CFrame.new(4,0,0)
				bentcf2=bent.CFrame*CFrame.new(-4,0,0)

-----------
--FOOTERS--
-----------
				f1=Instance.new("Part",workspace)
				 f1.Name="f1"
				 f1.CanCollide=false
				 f1.Anchored=true
				 f1.Size=Vector3.new(2,1,2)
				 f1.Parent=SupportSeg
				 f1.CFrame=bent.CFrame*CFrame.new(7,0,0)
				 f1.Position=Vector3.new(f1.Position.X,Baseplate.Position.Y+1,f1.Position.Z)
				 f1.Rotation=Vector3.new(0,0,0)
				 f1.Material=Enum.Material.Concrete
				 f1.TopSurface=Enum.SurfaceType.Smooth
				 f1.BottomSurface=Enum.SurfaceType.Smooth
				 m=Instance.new("CylinderMesh",f1)
				f2=Instance.new("Part",workspace)
				 f2.Name="f2"
				 f2.CanCollide=false
				 f2.Anchored=true
				 f2.Size=Vector3.new(2,1,2)
				 f2.Parent=SupportSeg
				 f2.CFrame=bent.CFrame*CFrame.new(-7,0,0)
				 f2.Position=Vector3.new(f2.Position.X,Baseplate.Position.Y+1,f2.Position.Z)
				 f2.Rotation=Vector3.new(0,0,0)
				 f2.Material=Enum.Material.Concrete
				 f2.TopSurface=Enum.SurfaceType.Smooth
				 f2.BottomSurface=Enum.SurfaceType.Smooth
				 m=Instance.new("CylinderMesh",f2)
				fm=Instance.new("Part",workspace)
				 fm.Name="fm"
				 fm.CanCollide=false
				 fm.Anchored=true
				 fm.Parent=SupportSeg
				 fm.Size=Vector3.new(1,1,1)
				 fm.Transparency=1
				 fm.CFrame=CFrame.new(f1.Position:lerp(f2.Position,.5),f2.Position)
				 fm.Material=Enum.Material.Concrete
				 fm.TopSurface=Enum.SurfaceType.Smooth
				 fm.BottomSurface=Enum.SurfaceType.Smooth
				 m=Instance.new("CylinderMesh",fm)
				f1.Rotation=Vector3.new(0,fm.Rotation.Y,0)
				f2.Rotation=Vector3.new(0,fm.Rotation.Y,0)
				
----------------------
--FOOTER POSITIONING--
----------------------
				if btype.Value=="None" or "Both" then
					f1.CFrame=fm.CFrame*CFrame.new(0,0,7)
					f2.CFrame=fm.CFrame*CFrame.new(0,0,-7)
				end
				if btype.Value=="Left" then
					bfpcfl=bent.CFrame*CFrame.new(7,0,0)
					bfpposl=Vector3.new(bfpcfl.X,bfpcfl.Y,bfpcfl.Z)
					f1.Position=Vector3.new(bfpposl.X,f2.Position.Y,bfpposl.Z)
					f2.CFrame=f1.CFrame*CFrame.new(0,0,-14)
				end
				if btype.Value=="Right" then
					bfpcfr=bent.CFrame*CFrame.new(-7,0,0)
					bfpposr=Vector3.new(bfpcfr.X,bfpcfr.Y,bfpcfr.Z)
					f2.Position=Vector3.new(bfpposr.X,f1.Position.Y,bfpposr.Z)
					f1.CFrame=f2.CFrame*CFrame.new(0,0,14)
				end

--------------
--MAIN BEAMS--
--------------
				ms1bcf1=bent.CFrame*CFrame.new(8,0,0)
				ms2bcf2=bent.CFrame*CFrame.new(-8,0,0)
				ms1=Instance.new("Part",workspace)
				 ms1.Name="ms1"
				 ms1.CanCollide=false
				 ms1.Anchored=true
				 ms1.Parent=SupportSeg
				 ms1.Size=Vector3.new(.6,(ms1bcf1.Y-f1.Position.Y),.6)
				 ms1.CFrame=f1.CFrame:lerp(ms1bcf1,.5)
				 ms1.CFrame=CFrame.new(f1.Position.X,ms1.Position.Y,f1.Position.Z)
				 ms1.Material=Enum.Material.Wood
				 ms1.BrickColor=color
				 ms1.TopSurface=Enum.SurfaceType.Smooth
				 ms1.BottomSurface=Enum.SurfaceType.Smooth
				ms2=Instance.new("Part",workspace)
				 ms2.Name="ms2"
				 ms2.CanCollide=false
				 ms2.Anchored=true
				 ms2.Parent=SupportSeg
				 ms2.Size=Vector3.new(.6,(ms2bcf2.Y-f2.Position.Y),.6)
				 ms2.CFrame=f2.CFrame:lerp(ms2bcf2,.5)
				 ms2.CFrame=CFrame.new(f2.Position.X,ms2.Position.Y,f2.Position.Z)
				 ms2.Material=Enum.Material.Wood
				 ms2.BrickColor=color
				 ms2.TopSurface=Enum.SurfaceType.Smooth
				 ms2.BottomSurface=Enum.SurfaceType.Smooth
				
--BentFix
--[[
ms1t=ms1.CFrame*CFrame.new(0,ms1.Size.Y/2,0)
ms2t=ms2.CFrame*CFrame.new(0,ms2.Size.Y/2,0)
ms1p=Vector3.new(ms1t.X,ms1t.Y,ms1t.Z)
ms2p=Vector3.new(ms2t.X,ms2t.Y,ms2t.Z)
 bent.CFrame=CFrame.new(ms1p:lerp(ms2p,.5),ms2p)
]]--

------------------
--FINDING HEIGHT--
------------------
				if used==false then
					countup=math.floor((curtrack.Position.Y-5-f1.Position.Y)/14)
					pcountup=nil
				end
				if used==true then
					pcountup=countup
					countup=math.floor((curtrack.Position.Y-5-f1.Position.Y)/14)
				end

----------------
--STEP FOOTERS--
----------------

				if math.floor((curtrack.Position.Y-5-f1.Position.Y)/14)>1 then
					if stepsptBval==true or stepsptLval==true then
						stpf2=SupportSeg.f2:Clone()
						stpf2.Name="stpf2"
						stpf2.Parent=SupportSeg
						stpf2.CFrame=f2.CFrame*CFrame.new(0,0,-14.6)
					end
					if stepsptBval==true or stepsptRval==true then
						stpf1=SupportSeg.f1:Clone()
						stpf1.Name="stpf1"
						stpf1.Parent=SupportSeg
						stpf1.CFrame=f1.CFrame*CFrame.new(0,0,14.6)
					end
				end

----------------------
--STEP MAIN SUPPORTS--
----------------------
				if countup>1 then
					if stepsptBval==true or stepsptLval==true then
						stpms2=SupportSeg.ms2:Clone()
						stpms2.Name="stpms2"
						stpms2.Parent=SupportSeg
						stpms2.Size=Vector3.new(stpms2.Size.X,(countup-1)*14+.6,stpms2.Size.Z)
						stpms2.CFrame=stpf2.CFrame*CFrame.new(0,(countup-1)*7+.2,0)
					end
					if stepsptBval==true or stepsptRval==true then
						stpms1=SupportSeg.ms1:Clone()
						stpms1.Name="stpms1"
						stpms1.Parent=SupportSeg
						stpms1.Size=Vector3.new(stpms1.Size.X,(countup-1)*14+.6,stpms1.Size.Z)
						stpms1.CFrame=stpf1.CFrame*CFrame.new(0,(countup-1)*7+.2,0)
					end
				end


-------------------------
--STRAIGHT INSIDE BEAMS--
-------------------------
			for i=1,countup do
				 s1=Instance.new("Part",workspace)
				 s1.Name="tieA" .. i
				 s1.Anchored=true
				 s1.CanCollide=false
				 s1.Parent=SupportSeg
				 s1.Size=Vector3.new(.4,1,14.6)
					if stepsptBval==true and countup>=2 and i<=countup-1 then
						s1.Size=Vector3.new(.4,1,43.8)
					elseif countup>=2 and i<=countup-1 then
						if stepsptLval==true or stepsptRval==true then
							s1.Size=Vector3.new(.4,1,29.2)
						end
					end
				 s1.CFrame=curtrack.CFrame
				 s1.CFrame=CFrame.new(f1.Position:Lerp(f2.Position,.5),f2.Position)
					if stepsptLval==true and i<=countup-1 then
						s1.CFrame=s1.CFrame*CFrame.new(0,0,-7.3)
					elseif stepsptRval==true and i<=countup-1 then
						s1.CFrame=s1.CFrame*CFrame.new(0,0,7.3)
					end		
				 s1.Position=Vector3.new(s1.Position.X,f1.Position.Y+14*i,s1.Position.Z)
				 s1.Material=Enum.Material.Wood
				 s1.BrickColor=color
				 s1.TopSurface=Enum.SurfaceType.Smooth
				 s1.BottomSurface=Enum.SurfaceType.Smooth
				 s1.CFrame=s1.CFrame*CFrame.new(.5,0,0)
				s2=Instance.new("Part",workspace)
				 s2.Name="tieB" .. i
				 s2.Anchored=true
				 s2.CanCollide=false
				 s2.Parent=SupportSeg
				 s2.Size=Vector3.new(.4,1,14.6)
					if stepsptBval==true and countup>=2 and i<=countup-1 then
						s2.Size=Vector3.new(.4,1,43.8)
					elseif countup>=2 and i<=countup-1 then
						if stepsptLval==true or stepsptRval==true then
							s2.Size=Vector3.new(.4,1,29.2)
						end
					end
				 s2.CFrame=curtrack.CFrame
				 s2.CFrame=CFrame.new(f1.Position:Lerp(f2.Position,.5),f2.Position)
					if stepsptLval==true and i<=countup-1 then
						s2.CFrame=s2.CFrame*CFrame.new(0,0,-7.3)
					elseif stepsptRval==true and i<=countup-1 then
						s2.CFrame=s2.CFrame*CFrame.new(0,0,7.3)
					end		
				 s2.Position=Vector3.new(s2.Position.X,f2.Position.Y+14*i,s2.Position.Z)
				 s2.Material=Enum.Material.Wood
				 s2.BrickColor=color
				 s2.TopSurface=Enum.SurfaceType.Smooth
				 s2.BottomSurface=Enum.SurfaceType.Smooth
				 s2.CFrame=s2.CFrame*CFrame.new(-.5,0,0)
				end
				
-------------------------
--CROSSBEAM POSITIONING--
-------------------------
				if used==false then
					cbcur1=Vector3.new(f1.Position.X,f1.Position.Y+14,f1.Position.Z)
					cbcur2=Vector3.new(f2.Position.X,f2.Position.Y+14,f2.Position.Z)
					cbprev1=nil
					cbprev2=nil
				end
				if used==true then
					cbprev1=cbcur1
					cbprev2=cbcur2
					cbcur1=Vector3.new(f1.Position.X,f1.Position.Y+14,f1.Position.Z)
					cbcur2=Vector3.new(f2.Position.X,f2.Position.Y+14,f2.Position.Z)
				end
				if used==true then
					if countup<pcountup then
						cu=countup
					else
						cu=pcountup
					end

----------------------
--OUTSIDE CROSSBEAMS--
----------------------
					for i=1,cu do
						cb1=Instance.new("Part",workspace)
	 					cb1.Parent=SupportSeg
	 					cb1.Anchored=true
	 					cb1.CanCollide=false
	 					cb1.Name="CrossBeamA"..i 
 						cb1.Material=Enum.Material.Wood
					 	cb1.BrickColor=color
	 					cb1.TopSurface=Enum.SurfaceType.Smooth
	 					cb1.BottomSurface=Enum.SurfaceType.Smooth
	 					cb1.CFrame=CFrame.new(cbcur1:lerp(cbprev1,.5),cbprev1)
	 					cb1.Size=Vector3.new(.4,1,(cbcur1-cbprev1).magnitude)
	 					cb1.Position=Vector3.new(cb1.Position.X,cb1.Position.Y+14*(i-1),cb1.Position.Z)
	 					cb1.CFrame=cb1.CFrame*CFrame.new(-.5,0,0)
	
						cb2=Instance.new("Part",workspace)
 						cb2.Parent=SupportSeg
						cb2.Anchored=true
						cb2.CanCollide=false
						cb2.Name="CrossBeamB"..i 
 						cb2.Material=Enum.Material.Wood
 						cb2.BrickColor=color
 						cb2.TopSurface=Enum.SurfaceType.Smooth
 						cb2.BottomSurface=Enum.SurfaceType.Smooth
	 					cb2.CFrame=CFrame.new(cbcur2:lerp(cbprev2,.5),cbprev2)
 						cb2.Size=Vector3.new(.4,1,(cbcur2-cbprev2).magnitude)
 						cb2.Position=Vector3.new(cb2.Position.X,cb2.Position.Y+14*(i-1),cb2.Position.Z)
 						cb2.CFrame=cb2.CFrame*CFrame.new(.5,0,0)
					end

------------------------------
--STEP CROSSBEAM POSITIONING--
------------------------------
					if stepsptBval==true or stepsptLval==true or stepsptRval==true then
						if countup>1 then
							if stepused==false then
								if stepsptBval==true or stepsptRval==true then
									stpcbcur1=Vector3.new(stpf1.Position.X,stpf1.Position.Y+14,stpf1.Position.Z)
								end
								if stepsptBval==true or stepsptLval==true then
									stpcbcur2=Vector3.new(stpf2.Position.X,stpf2.Position.Y+14,stpf2.Position.Z)
								end
								stpcbprev1=nil
								stpcbprev2=nil
								
								stepused=true
								stepfirst=true
							elseif stepused==true then --edit it should be an end
								stepfirst=false
							if stepsptBval==true or stepsptRval==true then
									stpcbprev1=stpcbcur1
									stpcbcur1=Vector3.new(stpf1.Position.X,stpf1.Position.Y+14,stpf1.Position.Z)
							end
							if stepsptBval==true or stepsptLval==true then
									stpcbprev2=stpcbcur2
									stpcbcur2=Vector3.new(stpf2.Position.X,stpf2.Position.Y+14,stpf2.Position.Z)
								end
							end
							if stepused==true then
								if countup<pcountup then
									cu=countup
								else
									cu=pcountup
								end
							end
						end
					end

					if stepsptBval==false and stepsptLval==false and stepsptRval==false then
						stepused=false
					end

---------------------------
--STEP OUTSIDE CROSSBEAMS--
---------------------------
					if stepsptBval==true or stepsptLval==true or stepsptRval==true then
						if countup>1 and stepused==true and stepfirst==false  then
							for i=1,cu-1 do
								if stepsptRval==true or stepsptBval==true then
									if stpcbprev1~=nil then
									cb1=Instance.new("Part",workspace)
									cb1.Parent=SupportSeg
									cb1.Anchored=true
									cb1.CanCollide=false
									cb1.Name="CrossBeamA"..i 
									cb1.Material=Enum.Material.Wood
									cb1.BrickColor=color
									cb1.TopSurface=Enum.SurfaceType.Smooth
									cb1.BottomSurface=Enum.SurfaceType.Smooth
									
									cb1.CFrame=CFrame.new(stpcbcur1:lerp(stpcbprev1,.5),stpcbprev1)
									cb1.Size=Vector3.new(.4,1,(stpcbcur1-stpcbprev1).magnitude)
									cb1.Position=Vector3.new(cb1.Position.X,cb1.Position.Y+14*(i-1),cb1.Position.Z)
									cb1.CFrame=cb1.CFrame*CFrame.new(-.5,0,0)
								end
								end
	
								if stepsptLval==true or stepsptBval==true then
									if stpcbprev2~=nil then
									cb2=Instance.new("Part",workspace)
									cb2.Parent=SupportSeg
									cb2.Anchored=true
									cb2.CanCollide=false
									cb2.Name="CrossBeamB"..i 
									cb2.Material=Enum.Material.Wood
									cb2.BrickColor=color
									cb2.TopSurface=Enum.SurfaceType.Smooth
									cb2.BottomSurface=Enum.SurfaceType.Smooth
									
									cb2.CFrame=CFrame.new(stpcbcur2:lerp(stpcbprev2,.5),stpcbprev2)
									cb2.Size=Vector3.new(.4,1,(stpcbcur2-stpcbprev2).magnitude)
									cb2.Position=Vector3.new(cb2.Position.X,cb2.Position.Y+14*(i-1),cb2.Position.Z)
									cb2.CFrame=cb2.CFrame*CFrame.new(.5,0,0)
								end end
							end
						end
					end
				end
					
				

---------------------
--INSIDE CROSSBEAMS--
---------------------
				for i=1,countup do
					icb=Instance.new("Part",workspace)
 					icb.Parent=SupportSeg
 					icb.Anchored=true
 					icb.CanCollide=false
 					icb.Name="ICrossBeam"..i 
 					icb.Material=Enum.Material.Wood
					icb.BrickColor=color
 					icb.TopSurface=Enum.SurfaceType.Smooth
 					icb.BottomSurface=Enum.SurfaceType.Smooth
					halpy=Vector3.new(f2.Position.X,f2.Position.Y+14,f2.Position.Z)
				 	icb.CFrame=CFrame.new(f1.Position:lerp(halpy,.5),halpy)
					icb.Size=Vector3.new(.6,1,(f1.Position-halpy).magnitude)
					icb.Position=Vector3.new(icb.Position.X,icb.Position.Y+14*(i-1),icb.Position.Z)
				end

--------------------------
--STEP INSIDE CROSSBEAMS--
--------------------------
				if countup>1 then
					if stepsptLval==true or stepsptBval==true then
						for i=1,countup do
							icb=Instance.new("Part",workspace)
							icb.Parent=SupportSeg
							icb.Anchored=true
 							icb.CanCollide=false
							icb.Name="ICrossBeam"..i 
							icb.Material=Enum.Material.Wood
							icb.BrickColor=color
							icb.TopSurface=Enum.SurfaceType.Smooth
							icb.BottomSurface=Enum.SurfaceType.Smooth
							halpy=Vector3.new(f2.Position.X,f2.Position.Y+14,f2.Position.Z)
 							icb.CFrame=CFrame.new(stpf2.Position:lerp(halpy,.5),halpy)
						 	icb.Size=Vector3.new(.6,1,(stpf2.Position-halpy).magnitude)
							icb.Position=Vector3.new(icb.Position.X,icb.Position.Y+14*(i-1),icb.Position.Z)
							if i==countup then
								icb.Size=Vector3.new(.6,.6,(stpf2.Position-halpy).magnitude)
							end
						end
					end
					if stepsptRval==true or stepsptBval==true then
						for i=1,countup do
							icb=Instance.new("Part",workspace)
 							icb.Parent=SupportSeg
 							icb.Anchored=true
 							icb.CanCollide=false
							icb.Name="ICrossBeam"..i 
							icb.Material=Enum.Material.Wood
							icb.BrickColor=color
							icb.TopSurface=Enum.SurfaceType.Smooth
							icb.BottomSurface=Enum.SurfaceType.Smooth
							halpy=Vector3.new(f1.Position.X,f1.Position.Y+14,f1.Position.Z)
 							icb.CFrame=CFrame.new(stpf1.Position:lerp(halpy,.5),halpy)
 							icb.Size=Vector3.new(.6,1,(stpf1.Position-halpy).magnitude)
							icb.Position=Vector3.new(icb.Position.X,icb.Position.Y+14*(i-1),icb.Position.Z)
							if i==countup then
								icb.Size=Vector3.new(.6,.6,(stpf1.Position-halpy).magnitude)
							end
						end
					end
				end

---------------
--SECOND BENT--
---------------
				sbent=Instance.new("Part",workspace)
 				sbent.Name="sbent"
				sbent.Anchored=true
 				sbent.CanCollide=false
 				sbent.Parent=SupportSeg
 				sbent.Size=Vector3.new(14.6, 2, 0.6) --normally 18.8
 				sbent.Material=Enum.Material.Wood
 				sbent.BrickColor=color
				 sbent.TopSurface=Enum.SurfaceType.Smooth
				 sbent.BottomSurface=Enum.SurfaceType.Smooth
				if btype.Value=="Right" or btype.Value=="Both" then
					rpossb1=Vector3.new(ms1.Position.X,bentcf1.Y,ms1.Position.Z)
					rpossb2=Vector3.new(ms2.Position.X,bentcf1.Y,ms2.Position.Z)
					sbent.CFrame=CFrame.new(rpossb1:lerp(rpossb2,.5),rpossb2)*CFrame.Angles(0,math.rad(90),0)
 					ms1.Size=Vector3.new(.6,(sbent.Position.Y-f1.Position.Y),.6)
 					ms1.CFrame=f1.CFrame:lerp(sbent.CFrame,.5)
 					ms1.CFrame=CFrame.new(f1.Position.X,ms1.Position.Y,f1.Position.Z)
				end
				if btype.Value=="Left" then
					lpossb1=Vector3.new(ms1.Position.X,bentcf2.Y,ms1.Position.Z)
					lpossb2=Vector3.new(ms2.Position.X,bentcf2.Y,ms2.Position.Z)
					sbent.CFrame=CFrame.new(lpossb1:lerp(lpossb2,.5),lpossb2)*CFrame.Angles(0,math.rad(90),0)
 					ms2.Size=Vector3.new(.6,(sbent.Position.Y-f2.Position.Y),.6)
 					ms2.CFrame=f2.CFrame:lerp(sbent.CFrame,.5)
 					ms2.CFrame=CFrame.new(f2.Position.X,ms2.Position.Y,f2.Position.Z)
				end

-----------------------
--CATWALK POSITIONING--
-----------------------
				if used==false then
					cwlh=sbent.CFrame*CFrame.new(5.5,1,0)
					cl1=Instance.new("Part",SupportSeg)
					cl1.Anchored=true
					cl1.CFrame=cwlh
					cwlc=Vector3.new(cwlh.X,cwlh.Y,cwlh.Z)
					cwrh=sbent.CFrame*CFrame.new(-5.5,1,0)
					cwrc=Vector3.new(cwrh.X,cwrh.Y,cwrh.Z)
					ms1.Rotation=cl1.Rotation
					ms2.Rotation=cl1.Rotation
				end
				if used==true then
					cwlp=cwlc
					cwrp=cwrc
					cwlh=sbent.CFrame*CFrame.new(5.5,1,0)
					cl1=Instance.new("Part",SupportSeg)
					cl1.Anchored=true
					cl1.CFrame=cwlh
					cwlc=Vector3.new(cwlh.X,cwlh.Y,cwlh.Z)
					cwrh=sbent.CFrame*CFrame.new(-5.5,1,0)
					cwrc=Vector3.new(cwrh.X,cwrh.Y,cwrh.Z)
					ms1.Rotation=cl1.Rotation
					ms2.Rotation=cl1.Rotation
				end

------------------
--Handrail Bases--
------------------
				hrb1=Instance.new("Part",SupportSeg)
				hrb1.Name="hrb1"
				hrb1.BrickColor=color
				hrb1.Anchored=true
				hrb1.Size=Vector3.new(.6,3,.6)
				hrb1.Material=Enum.Material.Wood
				hrb1.CFrame=ms1.CFrame*CFrame.new(0,((ms1.Size.Y/2)+1.5),0)
				hrb2=Instance.new("Part",SupportSeg)
				hrb2.Name="hrb2"
				hrb2.BrickColor=color
				hrb2.Anchored=true
				hrb2.Size=Vector3.new(.6,3,.6)
				hrb2.Material=Enum.Material.Wood
				hrb2.CFrame=ms2.CFrame*CFrame.new(0,((ms2.Size.Y/2)+1.5),0)
				if btype.Value=="Right" then
					hrb1.CFrame=hrb1.CFrame*CFrame.new(0,1,0)
					hrb1.Rotation=cl1.Rotation
					hrb2.Rotation=cl1.Rotation
				end
				if btype.Value=="Left" then
					hrb2.CFrame=hrb2.CFrame*CFrame.new(0,1,0)
					hrb1.Rotation=cl1.Rotation
					hrb2.Rotation=cl1.Rotation
				end
				if btype.Value=="Both" then
					hrb1.CFrame=hrb1.CFrame*CFrame.new(0,1,0)
					hrb2.CFrame=hrb2.CFrame*CFrame.new(0,1,0)
					hrb1.Rotation=cl1.Rotation
					hrb2.Rotation=cl1.Rotation
				end

------------------------
--HANDRAIL POSITIONING--
------------------------
				if used==false then
					hrrh=hrb1.CFrame*CFrame.new(0,1.7,0)
					hrrc=Vector3.new(hrrh.X,hrrh.Y,hrrh.Z)
					hrlh=hrb2.CFrame*CFrame.new(0,1.7,0)
					hrlc=Vector3.new(hrlh.X,hrlh.Y,hrlh.Z)
				elseif used==true then
					hrrp=hrrc
					hrlp=hrlc
					hrrh=hrb1.CFrame*CFrame.new(0,1.7,0)
					hrrc=Vector3.new(hrrh.X,hrrh.Y,hrrh.Z)
					hrlh=hrb2.CFrame*CFrame.new(0,1.7,0)
					hrlc=Vector3.new(hrlh.X,hrlh.Y,hrlh.Z)
					end
			
------------
--RAILINGS--
------------
				if used==true then
					if prevHandRailUsed==true then
						hrl=Instance.new("Part",workspace)
						hrl.Parent=SupportSeg
						hrl.Anchored=true
						hrl.CanCollide=false
						hrl.Name="HRL"
						hrl.Material=Enum.Material.Wood
						hrl.BrickColor=color
						hrl.TopSurface=Enum.SurfaceType.Smooth
						hrl.BottomSurface=Enum.SurfaceType.Smooth
						hrl.CFrame=CFrame.new(hrlc:lerp(hrlp,.5),hrlp)
						hrl.Size=Vector3.new(.6,.4,(hrlc-hrlp).magnitude)
						hrl.CanCollide=true
					end
					if prevHandRailUsed==true then
						hrr=Instance.new("Part",workspace)
						hrr.Parent=SupportSeg
						hrr.Anchored=true
						hrr.CanCollide=false
						hrr.Name="HRR"
						hrr.Material=Enum.Material.Wood
						hrr.BrickColor=color
						hrr.TopSurface=Enum.SurfaceType.Smooth
						hrr.BottomSurface=Enum.SurfaceType.Smooth
						hrr.CFrame=CFrame.new(hrrc:lerp(hrrp,.5),hrrp)
						hrr.Size=Vector3.new(.6,.4,(hrrc-hrrp).magnitude)
						hrr.CanCollide=true
					end
				end
				if catwalksval==true then
					prevHandRailUsed=true
				else
					prevHandRailUsed=false
				end
------------
--CATWALKS--
------------
				if used==true then
					if prevCatWalkLUsed==true or prevCatWalkBUsed==true then
						cwl=Instance.new("Part",workspace)
						cwl.Parent=SupportSeg
						cwl.Anchored=true
						cwl.CanCollide=false
						cwl.Name="CWL"
						cwl.Material=Enum.Material.Wood
						cwl.BrickColor=color
						cwl.TopSurface=Enum.SurfaceType.Smooth
						cwl.BottomSurface=Enum.SurfaceType.Smooth
						cwl.CFrame=CFrame.new(cwlc:lerp(cwlp,.5),cwlp)
						cwl.Size=Vector3.new(2.6,.2,(cwlc-cwlp).magnitude)
						cwl.CanCollide=cccval
					end
					if prevCatWalkRUsed==true or prevCatWalkBUsed==true then
						cwr=Instance.new("Part",workspace)
						cwr.Parent=SupportSeg
						cwr.Anchored=true
						cwr.CanCollide=false
						cwr.Name="CWR"
						cwr.Material=Enum.Material.Wood
						cwr.BrickColor=color
						cwr.TopSurface=Enum.SurfaceType.Smooth
						cwr.BottomSurface=Enum.SurfaceType.Smooth
						cwr.CFrame=CFrame.new(cwrc:lerp(cwrp,.5),cwrp)
						cwr.Size=Vector3.new(2.6,.2,(cwrc-cwrp).magnitude)
						cwr.CanCollide=cccval
					elseif SupportSeg:FindFirstChild("CWR")==true then
						cwr:Destroy()
					end
				end
				if btype.Value=="Right" and catwalksval==true then
					prevCatWalkRUsed=true
				else
					prevCatWalkRUsed=false
				end
				if btype.Value=="Left" and catwalksval==true then
					prevCatWalkLUsed=true
				else
					prevCatWalkLUsed=false
				end
				if btype.Value=="Both" and catwalksval==true then
					prevCatWalkBUsed=true
				else
					prevCatWalkBUsed=false
				end
----------------
--TRI SUPPORTS--
----------------
				
				if countup~=0 then
-------------------
--LeftTriSupports--
-------------------
					if prevTriSptBUsed==false and prevTriSptLUsed==false and prevTriSptRUsed==false then
						curlefttricrosscframes={}
						prevlefttricrosscframes={}
					end
					if trisptLval==true or trisptBval==true then
						f3=Instance.new("Part",SupportSeg)
						f3.Name="f3"
						f3.CanCollide=false
						f3.Anchored=true
						f3.Material=Enum.Material.Concrete
						f3.Size=Vector3.new(2,1,2)
						f3.CFrame=f2.CFrame*CFrame.new(0,0,(0-((curtrack.Position.Y-f2.Position.Y)/5)))
						m=Instance.new("CylinderMesh",f3)
						if btype.Value~="Left" then
							heightf3b=bent.CFrame*CFrame.new(-7,0,0)
						else
							heightf3b=sbent.CFrame*CFrame.new(7,0,0)	
						end
						f3b=Instance.new("Part",SupportSeg)
						f3b.Name="f3b"
						f3b.CanCollide=false
						f3b.Anchored=true
						f3b.BrickColor=color
						f3b.Material=Enum.Material.Wood
						f3b.TopSurface=Enum.SurfaceType.Smooth
						f3b.BottomSurface=Enum.SurfaceType.Smooth
						f3b.Size=Vector3.new(.6,.6,(heightf3b.p-f3.Position).magnitude)
						f3b.CFrame=CFrame.new(f3.Position:Lerp(heightf3b.p,.5),heightf3b.p)
						if countup>=1 then
							for i=1,countup do
								ticbL1=Instance.new("Part",SupportSeg)
								ticbL1.Anchored=true
								ticbL1.CanCollide=false
								ticbL1.Name="ticbLA"..i
								ticbL1.BrickColor=color
								ticbL1.Material=Enum.Material.Wood
								ticbL1.TopSurface=Enum.SurfaceType.Smooth
								ticbL1.BottomSurface=Enum.SurfaceType.Smooth
								ticbL1.Size=Vector3.new(1,1,1)
								ticbL1.CFrame=f2.CFrame*CFrame.new(0,14*i,0)
								ticbL1CF1=ticbL1.CFrame
								ticbL1CF2=f3.CFrame*CFrame.new(0,14*i,0)
								local ray = Ray.new(ticbL1CF2.p, (ticbL1.CFrame.p - ticbL1CF2.p).unit * 999)
								local part, position = workspace:FindPartOnRay(ray, nil, false, true)
								local distance = (ticbL1.CFrame.p - position).magnitude
								ticbL1.Size = Vector3.new(0.4, 1, distance-.3)
								ticbL1.CFrame = CFrame.new(ticbL1CF1.p, position) * CFrame.new(0, 0, -distance/2)*CFrame.new(.5,0,0)
								
								table.insert(curlefttricrosscframes,i,ticbL1.CFrame*CFrame.new(-.5,0,-(ticbL1.Size.Z/2)-.2))
								
								ticbL2=ticbL1:Clone()
								ticbL2.Parent=SupportSeg
								ticbL2.CFrame=ticbL2.CFrame*CFrame.new(-1,0,0)
								ticbL2.Name="ticbLB"..i
							end

							if prevTriSptBUsed==true or prevTriSptLUsed==true then
								if #curlefttricrosscframes~=0 and #prevlefttricrosscframes~=0 then
									if #curlefttricrosscframes>=#prevlefttricrosscframes then
										for i=1,#prevlefttricrosscframes do
											f3cb=Instance.new("Part",SupportSeg)
											f3cb.Anchored=true
											f3cb.CanCollide=false
											f3cb.Name="f3cb"..i
											f3cb.Material=Enum.Material.Wood			
											f3cb.BrickColor=color
											f3cb.TopSurface=Enum.SurfaceType.Smooth
											f3cb.BottomSurface=Enum.SurfaceType.Smooth
											f3cb.Size=Vector3.new(.4,1,(curlefttricrosscframes[i].p-prevlefttricrosscframes[i].p).magnitude)
											f3cb.CFrame=CFrame.new(curlefttricrosscframes[i].p:Lerp(prevlefttricrosscframes[i].p,.5),prevlefttricrosscframes[i].p)
										end
									elseif #prevlefttricrosscframes>=#curlefttricrosscframes then
										for i=1,#curlefttricrosscframes do
											f3cb=Instance.new("Part",SupportSeg)
											f3cb.Anchored=true
											f3cb.CanCollide=false
											f3cb.Name="f3cb"..i
											f3cb.Material=Enum.Material.Wood
											f3cb.BrickColor=color
											f3cb.TopSurface=Enum.SurfaceType.Smooth
											f3cb.BottomSurface=Enum.SurfaceType.Smooth
											f3cb.Size=Vector3.new(.4,1,(curlefttricrosscframes[i].p-prevlefttricrosscframes[i].p).magnitude)
											f3cb.CFrame=CFrame.new(curlefttricrosscframes[i].p:Lerp(prevlefttricrosscframes[i].p,.5),prevlefttricrosscframes[i].p)
										end
									end
								end
							end
							prevlefttricrosscframes={}
							for i=1,#curlefttricrosscframes do
								table.insert(prevlefttricrosscframes,i,curlefttricrosscframes[i])
							end
							curlefttricrosscframes={}
						end
					end
--------------------
--RightTriSupports--
--------------------
					if prevTriSptBUsed==false and prevTriSptLUsed==false and prevTriSptRUsed==false then
						currighttricrosscframes={}
						prevrighttricrosscframes={}
					end
					if trisptRval==true or trisptBval==true then
						f4=Instance.new("Part",SupportSeg)
						f4.Name="f4"
						f4.CanCollide=false
						f4.Anchored=true
						f4.Material=Enum.Material.Concrete
						f4.Size=Vector3.new(2,1,2)
						f4.CFrame=f1.CFrame*CFrame.new(0,0,((curtrack.Position.Y-f1.Position.Y)/5))
						m=Instance.new("CylinderMesh",f4)
						if btype.Value~="Right" then
							heightf4b=bent.CFrame*CFrame.new(7,0,0)
						else
							heightf4b=sbent.CFrame*CFrame.new(-7,0,0)	
						end
						f4b=Instance.new("Part",SupportSeg)
						f4b.Name="f4b"
						f4b.CanCollide=false
						f4b.Anchored=true
						f4b.BrickColor=color
						f4b.Material=Enum.Material.Wood
						f4b.TopSurface=Enum.SurfaceType.Smooth
						f4b.BottomSurface=Enum.SurfaceType.Smooth
						f4b.Size=Vector3.new(.6,.6,(heightf4b.p-f4.Position).magnitude)
						f4b.CFrame=CFrame.new(f4.Position:Lerp(heightf4b.p,.5),heightf4b.p)
						if countup>=1 then
							for i=1,countup do
								ticbR1=Instance.new("Part",SupportSeg)
								ticbR1.Anchored=true
								ticbR1.CanCollide=false
								ticbR1.Name="ticbRA"..i
								ticbR1.BrickColor=color
								ticbR1.Material=Enum.Material.Wood
								ticbR1.TopSurface=Enum.SurfaceType.Smooth
								ticbR1.BottomSurface=Enum.SurfaceType.Smooth
								ticbR1.Size=Vector3.new(1,1,1)
								ticbR1.CFrame=f1.CFrame*CFrame.new(0,14*i,0)
								ticbR1CF1=ticbR1.CFrame
								ticbR1CF2=f4.CFrame*CFrame.new(0,14*i,0)
								local ray = Ray.new(ticbR1CF2.p, (ticbR1.CFrame.p - ticbR1CF2.p).unit * 999)
								local part, position = workspace:FindPartOnRay(ray, nil, false, true)
								local distance = (ticbR1.CFrame.p - position).magnitude
								ticbR1.Size = Vector3.new(0.4, 1, distance-.3)
								ticbR1.CFrame = CFrame.new(ticbR1CF1.p, position) * CFrame.new(0, 0, -distance/2)*CFrame.new(.5,0,0)
								
								table.insert(currighttricrosscframes,ticbR1.CFrame*CFrame.new(-.5,0,-(ticbR1.Size.Z/2)-.2))
								
								ticbR2=ticbR1:Clone()
								ticbR2.Parent=SupportSeg
								ticbR2.CFrame=ticbR2.CFrame*CFrame.new(-1,0,0)
								ticbR2.Name="ticbRB"..i
							end

							if prevTriSptBUsed==true or prevTriSptRUsed==true then
								if #currighttricrosscframes~=0 and #prevrighttricrosscframes~=0 then
									if #currighttricrosscframes>=#prevrighttricrosscframes then
										for i=1,#prevrighttricrosscframes do
											f4cb=Instance.new("Part",SupportSeg)
											f4cb.Anchored=true
											f4cb.CanCollide=false
											f4cb.Name="f4cb"..i
											f4cb.Material=Enum.Material.Wood
											f4cb.BrickColor=color
											f4cb.TopSurface=Enum.SurfaceType.Smooth
											f4cb.BottomSurface=Enum.SurfaceType.Smooth
											f4cb.Size=Vector3.new(.4,1,(currighttricrosscframes[i].p-prevrighttricrosscframes[i].p).magnitude)
											f4cb.CFrame=CFrame.new(currighttricrosscframes[i].p:Lerp(prevrighttricrosscframes[i].p,.5),prevrighttricrosscframes[i].p)
										end
									elseif #prevrighttricrosscframes>=#currighttricrosscframes then
												
										for i=1,#currighttricrosscframes do
											f4cb=Instance.new("Part",SupportSeg)
											f4cb.Anchored=true
											f4cb.CanCollide=false
											f4cb.Name="f4cb"..i
											f4cb.Material=Enum.Material.Wood
											f4cb.BrickColor=color
											f4cb.TopSurface=Enum.SurfaceType.Smooth
											f4cb.BottomSurface=Enum.SurfaceType.Smooth
											f4cb.Size=Vector3.new(.4,1,(currighttricrosscframes[i].p-prevrighttricrosscframes[i].p).magnitude)
											f4cb.CFrame=CFrame.new(currighttricrosscframes[i].p:Lerp(prevrighttricrosscframes[i].p,.5),prevrighttricrosscframes[i].p)
										end
									end
								end
							end
							prevrighttricrosscframes={}
							for i=1,#currighttricrosscframes do
								table.insert(prevrighttricrosscframes,i,currighttricrosscframes[i])
							end
							currighttricrosscframes={}
						end
					end
				end

				if trisptRval==true then
					prevTriSptRUsed=true
				else				
					prevTriSptRUsed=false
				end
				if trisptLval==true then
					prevTriSptLUsed=true
				else
					prevTriSptLUsed=false
				end					
				if trisptBval==true then
					prevTriSptBUsed=true
				else
					prevTriSptBUsed=false
				end
---------------
--NO CATWALKS--
---------------
				ctwlksval=ba.catwalks.Value
				if ctwlksval==false then
					hrb1etg=SupportSeg:FindFirstChild("hrb1")
					if hrb1etg~=nil then 
						hrb1etg:Destroy()
					end				
					hrb2etg=SupportSeg:FindFirstChild("hrb2")
					if hrb2etg~=nil then 
						hrb2etg:Destroy()
					end
					HRRetg=SupportSeg:FindFirstChild("HRR")
					if HRRetg~=nil then 
						HRRetg:Destroy()
					end
					HRLetg=SupportSeg:FindFirstChild("HRL")
					if HRLetg~=nil then 
						HRLetg:Destroy()
					end			
					CWRetg=SupportSeg:FindFirstChild("CWR")
					if CWRetg~=nil then 
						CWRetg:Destroy()
					end
					CWLetg=SupportSeg:FindFirstChild("CWL")
					if CWLetg~=nil then 
						CWLetg:Destroy()
					end				
				end
				if SupportSeg:FindFirstChild("CWL")~=nil and btype.Value=="Right" then
					SupportSeg.CWL:Destroy()
				elseif SupportSeg:FindFirstChild("CWR")~=nil and btype.Value=="Left" then
					SupportSeg.CWR:Destroy()
				end
				if SupportSeg:FindFirstChild("sbent")~=nil and btype.Value=="None" then
					SupportSeg.sbent:Destroy()
				end
-------------
--LEFTOVERS--
-------------
			if btype.Value=="Both" then
				sbent:Destroy()
			end
			fm:Destroy()
			cl1:Destroy()
			tb:Destroy()
			prevtrack=curtrack
			curtrack=nil
			used=true
	game.ChangeHistoryService:SetWaypoint("Added Coaster Support")
		end
	
	end
end
ba.Active:GetPropertyChangedSignal("Value"):Connect(function()
	if ba.Active.Value==false then
		curtrack=nil
		prevtrack=nil
		used=false
		stepused=false
		countup=0
		prevHandRailUsed=false
		prevCatWalkRUsed=false
		prevCatWalkLUsed=false
		prevCatWalkBUsed=false
		prevTriSptRUsed=false
		prevTriSptLUsed=false
		prevTriSptBUsed=false
	end
end)


mouse.Button1Down:connect(function() if ba.Active.Value==true then clickedf(mouse) end end)

