
local CROSSBAR_WIDTH = 14.6

local function GetCFrameWithoutVerticalAngle(cframe)
    local x, y, z, _, _, m02, m10, m11, _, _, _, m22 = cframe:components()
    local heading = math.atan2(m02, m22)
    local bank = math.atan2(m10, m11)

    return CFrame.new(x, y, z)
        * CFrame.Angles(0, heading, 0)
        * CFrame.Angles(0, 0, bank)
end


local function BuildCrossbar(cframe, colors, parent)    -- crossbar?
    local bent = Instance.new("Part",workspace)
        bent.Name = "Bent"
        bent.Anchored = true
        bent.CanCollide = false
        bent.Size = Vector3.new(18, 2, 0.6) --normally 18.8
        bent.Material=Enum.Material.Wood
        bent.Color = colors.Support
        bent.TopSurface = Enum.SurfaceType.Smooth
        bent.BottomSurface = Enum.SurfaceType.Smooth
        -- bentcf1 = bent.CFrame * CFrame.new(4,0,0)
        -- bentcf2 = bent.CFrame * CFrame.new(-4,0,0)

    local crossbarCFrame = GetCFrameWithoutVerticalAngle(cframe)
        * CFrame.new(0, -2.4, 0)

    bent.CFrame = crossbarCFrame
    bent.Parent = parent

    return crossbarCFrame
end

-- it's not moving circular
-- move within a square
local function BuildSecondCrossbar(cframe, colors, parent)    -- crossbar?
    -- when angle is 0
        -- offset X = 0, Y = -2, Z = 0
    -- when angle is 90
        -- offset X = (width - 2) / 2, Y = -(4 + 2), Z = 0
    -- when angle is 180
        -- offset X = 0, Y -

    local _cframe = GetCFrameWithoutVerticalAngle(cframe)
    local _, _, _, _, _, _, m10, m11, _, _, _, _ = _cframe:components()

    local maxX = -((14.6) / 2)
    local angle = math.atan2(m10, m11)
    -- local sinValue = math.abs(math.sin(angle))
    -- local ySinValue = sinValue

    if (angle < 0) then
        maxX = -maxX
    end

    local ySinValue = math.abs(math.sin(angle))
    if (m11 < 0) then
        ySinValue = 1 + (1 - ySinValue) * 2
    end

    local xValue = maxX * (1 - math.abs(math.cos(angle)))
    local yValue = -((4 * ySinValue) + 2.4)


    local pos = cframe.Position + Vector3.new(0, yValue, 0)
    local crossbarCFrame = CFrame.new(pos, pos + _cframe.LookVector)
        * CFrame.new(xValue, 0, 0)

    local bent = Instance.new("Part", workspace)
        bent.Name = "SecondBent"
        bent.Anchored = true
        bent.CanCollide = false
        bent.Size = Vector3.new(14.6, 2, 0.6) --normally 18.8
        bent.Material=Enum.Material.Wood
        bent.Color = colors.Support
        bent.TopSurface = Enum.SurfaceType.Smooth
        bent.BottomSurface = Enum.SurfaceType.Smooth
        -- bentcf1 = bent.CFrame * CFrame.new(4,0,0)
        -- bentcf2 = bent.CFrame * CFrame.new(-4,0,0)

    bent.CFrame = crossbarCFrame
    bent.Parent = parent

    return crossbarCFrame
end


local function BuildCrossbars(cframe, colors, parent)
    local _cframe = GetCFrameWithoutVerticalAngle(cframe)
    local _, _, _, _, _, _, m10, m11, _, _, _, _ = _cframe:components()
    local angle = math.atan2(m10, m11)

    local crossbarCFrame = BuildCrossbar(_cframe, colors, parent)

    if (math.abs(angle) > math.rad(5) or m11 < 0) then
        crossbarCFrame = BuildSecondCrossbar(_cframe, colors, parent)
    end

    return crossbarCFrame
end


local function BuildVerticalSupportBeam(cframe, collisions, colors, parent)
    local startPosition = cframe.Position

    -- draw ray
    local ray = Ray.new(startPosition, Vector3.new(0, -2000, 0))
    local hit, hitPosition, _ =
        workspace:FindPartOnRayWithWhitelist(ray, collisions, true)

    if (hit == nil) then
        return 0
    end

    local height = math.abs(startPosition.Y - hitPosition.Y)

    -- build beam
    local supportBeam = Instance.new("Part")
        supportBeam.Name = "SupportBeam"
        supportBeam.CanCollide = true
        supportBeam.Anchored = true
        supportBeam.Size = Vector3.new(0.6, height, 0.6)
        supportBeam.Material = Enum.Material.Wood
        supportBeam.Color = colors.Support
        supportBeam.TopSurface = Enum.SurfaceType.Smooth
        supportBeam.BottomSurface = Enum.SurfaceType.Smooth

        local supportPosition = startPosition + Vector3.new(0, -height / 2, 0)
        supportBeam.CFrame = CFrame.new(supportPosition, supportPosition + cframe.LookVector)
        supportBeam.Parent = parent

    -- build footer
    local footer = Instance.new("Part")
        footer.Name = "Footer"
        footer.CanCollide = true
        footer.Anchored = true
        footer.Size = Vector3.new(2, 1, 2)
        footer.Material = Enum.Material.Concrete
        footer.TopSurface = Enum.SurfaceType.Smooth
        footer.BottomSurface = Enum.SurfaceType.Smooth

        footer.CFrame = CFrame.new(hitPosition)
        footer.Parent = parent

    Instance.new("CylinderMesh", footer)


    return height
end


local function BuildHorizontalInsideBeam(cframe, colors, parent)
    local beam = Instance.new("Part")
        beam.Size = Vector3.new(14.6, 1, 0.4)
        beam.Anchored = true
        beam.CanCollide = false
        beam.Material = Enum.Material.Wood
        beam.Color = colors.Support
        beam.TopSurface = Enum.SurfaceType.Smooth
        beam.BottomSurface = Enum.SurfaceType.Smooth
        beam.Name = "HorizontalInsideBeam1"

    local beam2 = beam:Clone()
        beam2.Name = "HorizontalInsideBeam2"

    beam.CFrame = cframe * CFrame.new(0, 0, 0.5)
    beam2.CFrame = cframe * CFrame.new(0, 0, -0.5)

    beam.Parent = parent
    beam2.Parent = parent
end


local function BuildHorizontalInsideBeams(crossbarCFrame, supportHeight, colors, parent)
    local position = crossbarCFrame.Position
    local maxHeight = position.Y
    local heightIncrement = 14

    local startHeight = maxHeight - supportHeight

    local function GetHeightCFrame(height)
        local pos = Vector3.new(position.X, height, position.Z)
        return CFrame.new(pos, pos + crossbarCFrame.LookVector)
    end

    local modStartHeight = startHeight % heightIncrement
    local currentHeight = (modStartHeight > 2.5) and startHeight
        or (startHeight - modStartHeight + heightIncrement)

    while (maxHeight - currentHeight > 2) do
        BuildHorizontalInsideBeam(GetHeightCFrame(currentHeight), colors, parent)
        currentHeight = currentHeight + heightIncrement
    end
end


local function BuildInsideCrossbeam(topCFrame, bottomCFrame, colors, parent)
    local beam = Instance.new("Part")
        beam.Anchored = true
        beam.CanCollide = false
        beam.Material = Enum.Material.Wood
        beam.Color = colors.Support
        beam.TopSurface = Enum.SurfaceType.Smooth
        beam.BottomSurface = Enum.SurfaceType.Smooth
        beam.Name = "InsideCrossbeam2"

    local midCFrame = topCFrame:Lerp(bottomCFrame, 0.5)

    local beam2 = beam:Clone()
        beam2.Name = "InsideCrossbeam2"

    local beam1Start = topCFrame * CFrame.new(7, 0, 0)
    local beam1End = bottomCFrame * CFrame.new(-7, 0, 0)
    local beam1Length = (beam1Start.Position - beam1End.Position).Magnitude
    beam.Size = Vector3.new(0.4, 1, beam1Length)
    beam.CFrame = CFrame.new(midCFrame.Position, beam1Start.Position)

    local beam2Start = topCFrame * CFrame.new(-7, 0, 0)
    local beam2End = bottomCFrame * CFrame.new(7, 0, 0)
    local beam2Length = (beam2Start.Position - beam2End.Position).Magnitude
    beam2.Size = Vector3.new(0.4, 1, beam2Length)
    beam2.CFrame = CFrame.new(midCFrame.Position, beam2Start.Position)

    beam.Parent = parent
    beam2.Parent = parent
end


local function BuildInsideCrossbeams(crossbarCFrame, supportHeight, colors, parent)
    local position = crossbarCFrame.Position
    local maxHeight = position.Y
    local heightIncrement = 14  -- const for now

    local function GetHeightCFrame(height)
        local pos = Vector3.new(position.X, height, position.Z)
        return CFrame.new(pos, pos + crossbarCFrame.LookVector)
    end

    local startHeight = maxHeight - supportHeight
    local modStartHeight = startHeight % heightIncrement

    local lastHeight = startHeight
    local currentHeight = (modStartHeight < 0.01) and startHeight
        or (startHeight - modStartHeight + heightIncrement)

    while (lastHeight < maxHeight) do
        local _currentHeight = currentHeight
        if (currentHeight > maxHeight) then
            _currentHeight = maxHeight
        end

        if (_currentHeight - lastHeight > 9.5) then
            BuildInsideCrossbeam(
                GetHeightCFrame(lastHeight),
                GetHeightCFrame(_currentHeight),
                colors,
                parent
            )
        end

        lastHeight = currentHeight
        currentHeight = currentHeight + heightIncrement
    end
end


local function BuildSupport(cframe, collisions, colors)
    local model = Instance.new("Model")

    local levelCrossbarCFrame = BuildCrossbars(cframe, colors, model)

    local leftSupportTopCFrame = levelCrossbarCFrame * CFrame.new(7, 0, 0)
    local leftHeight = BuildVerticalSupportBeam(
        leftSupportTopCFrame,
        collisions,
        colors,
        model
    )

    local rightSupportTopCFrame = levelCrossbarCFrame * CFrame.new(-7, 0, 0)
    local rightHeight = BuildVerticalSupportBeam(
        rightSupportTopCFrame,
        collisions,
        colors,
        model
    )
    BuildHorizontalInsideBeams(levelCrossbarCFrame, math.min(leftHeight, rightHeight), colors, model)
    BuildInsideCrossbeams(levelCrossbarCFrame, math.min(leftHeight, rightHeight), colors, model)

    local supportData = {
        LevelCrossbarCFrame = levelCrossbarCFrame;
        -- left vertical support beam data
        LeftMainSupportHeight = leftHeight;
        LeftMainSupportTopCFrame = leftSupportTopCFrame;

        -- right vertical support beam data
        RightMainSupportHeight = rightHeight;
        RightMainSupportTopCFrame = rightSupportTopCFrame;
    }

    return model, supportData
end




local function BuildHorizontalOutsideBeam(startCFrame, endCFrame, colors, parent)
    local beam = Instance.new("Part")
        beam.Anchored = true
        beam.CanCollide = false
        beam.Material = Enum.Material.Wood
        beam.Color = colors.Support
        beam.TopSurface = Enum.SurfaceType.Smooth
        beam.BottomSurface = Enum.SurfaceType.Smooth
        beam.Name = "HorizontalOutsideBeam"

    local startPosition = startCFrame.Position
    local endPosition = endCFrame.Position
    local midPosition = startPosition:Lerp(endPosition, 0.5)

    local beam1Length = (startPosition - endPosition).Magnitude
    beam.Size = Vector3.new(0.4, 1, beam1Length)
    beam.CFrame = CFrame.new(midPosition, startCFrame.Position)

    beam.Parent = parent
end


local function GetYPositionCFrameFunction(cframe)
    local position = cframe.Position
    return function(y)
        local pos = Vector3.new(position.X, y, position.Z)
        return CFrame.new(pos, pos + cframe.LookVector)
    end
end


local function GetIncrementStartHeight(height, increment, padding)
    padding = padding or 0.1

    local modStartHeight = height % increment
    return (modStartHeight > padding) and height
        or (height - modStartHeight + increment)
end


local function BuildHorizontalOutsideBeams(startCFrame, startHeight, endCFrame, endHeight, colors, parent)
    local maxStartHeight = startCFrame.Position.Y + 1.2
    local getStartYPositionCFrame = GetYPositionCFrameFunction(startCFrame)

    local maxEndHeight = endCFrame.Position.Y + 1.2
    local getEndYPositionCFrame = GetYPositionCFrameFunction(endCFrame)

    local heightIncrement = 14

    local buildStartHeight
        = math.min(GetIncrementStartHeight(startCFrame.Position.Y - startHeight, heightIncrement, 2.5),
            GetIncrementStartHeight(endCFrame.Position.Y - endHeight, heightIncrement, 2.5))

    local startCurrentHeight = buildStartHeight
    local endCurrentHeight = buildStartHeight

    while (maxStartHeight - startCurrentHeight > 0
        and maxEndHeight - endCurrentHeight > 0) do

        BuildHorizontalOutsideBeam(
            getStartYPositionCFrame(startCurrentHeight),
            getEndYPositionCFrame(endCurrentHeight),
            colors,
            parent
        )

        startCurrentHeight = startCurrentHeight + heightIncrement
        endCurrentHeight = endCurrentHeight + heightIncrement
    end
end


local function BuildBrace(startSupportData, endSupportData, colors)
    local model = Instance.new("Model")

    BuildHorizontalOutsideBeams(    -- left
        startSupportData.LeftMainSupportTopCFrame,
        startSupportData.LeftMainSupportHeight,
        endSupportData.LeftMainSupportTopCFrame,
        endSupportData.LeftMainSupportHeight,
        colors,
        model
    )

    BuildHorizontalOutsideBeams(    -- right
        startSupportData.RightMainSupportTopCFrame,
        startSupportData.RightMainSupportHeight,
        endSupportData.RightMainSupportTopCFrame,
        endSupportData.RightMainSupportHeight,
        colors,
        model
    )

    return model
end


local function GenerateWoodenSupports(cframeTrack, startPosition, endPosition, interval, floorCollision)
    assert(startPosition < endPosition)
    interval = interval or 20

    local model = Instance.new("Model")
    model.Name = "WoodenSupports"

    local index = 1
    local colors = {
        Support = Color3.fromRGB(124, 92, 70);
    }
    local collisions = {
        workspace:FindFirstChild("Baseplate")
    }

    local function GenerateSupport(cframe)
        local supportModel, supportData = BuildSupport(cframe, collisions, colors)
        supportModel.Name = tostring(index)
        supportModel.Parent = model

        return supportData
    end

    local function GenerateBrace(startSupportData, endSupportData)
        local braceModel = BuildBrace(startSupportData, endSupportData, colors)
        braceModel.Name = tostring(index)
        braceModel.Parent = model
    end

    local lastPosition = startPosition
    local lastCFrame = cframeTrack:GetCFramePosition(lastPosition)

    --- Get CFrame that is within
    -- return CFrame, double
    local function GetTrackCFrameXZMagnitudeFromCFrame(cframe, position)
        local cframeVector2 = Vector2.new(cframe.Position.X, cframe.Position.Z)
        local currentCFrame
        local currentPosition = position + interval
        local numLoops = 0

        repeat
            currentPosition = currentPosition + 0.1
            currentCFrame = cframeTrack:GetCFramePosition(currentPosition)
            numLoops = numLoops + 1
        until ((Vector2.new(currentCFrame.Position.X, currentCFrame.Position.Z)
            - cframeVector2).Magnitude or numLoops >= 250)

        return currentCFrame, currentPosition
    end

    local startSupportData
    local lastSupportData

    while (lastPosition <= endPosition) do
        local currentCFrame, currentPosition
            = GetTrackCFrameXZMagnitudeFromCFrame(lastCFrame, lastPosition)

        local currentSupportData = GenerateSupport(lastCFrame)
        if (lastSupportData ~= nil) then
            GenerateBrace(lastSupportData, currentSupportData)
        else
            startSupportData = currentSupportData
        end

        lastCFrame = currentCFrame
        lastPosition = currentPosition
        lastSupportData = currentSupportData
        index = index + 1
    end

    if (lastPosition ~= endPosition) then
        GenerateBrace(lastSupportData, startSupportData)
    end


    return model
end


return GenerateWoodenSupports