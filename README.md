
# Roblox Track Builder Plugin

A plugin for making tracks (mainly for roller coasters).

## How to use

### 1. Setup and Select Track:

#### a. Setup Track

##### Format

- IsCircuited : *BoolValue*
    - If true, will treat the two end points as the start and end of the track.
        - Extends the length using these points
    - If false,
        - Any value over will be plus the first/last point
- TrackClass : *StringValue*
    - Specifies the class used to make the track
        - *See TrackClasses for more info*
- Points : *Model/Folder/Instance*
    - Contains ordered points

##### TrackClasses
- PointToPoint
    - Every point is treated as a certain distance away from the other
        - Simple and was quick to get CFrame
- PointToPoint2
    - More accurate/better version of PointToPoint
    - TrackLength is determined by adding the distance/magnitude between each point
        - Supports differing distances
        - Uses a hash to get CFrame
            - Faster (untested) than travering through and finding the point in real time
- SpacekPluginSpline (Not implemented)
    - Use the spline generated by Spacek's coaster plugin

##### Quick Ordered Points Track
- If lazy, just use a Model whose children are all of the points you want for the class.
    - Track will use `TrackClass = "PointToPoint2"`
    - Track will default to `IsCiruited = false`

#### c. Select Track
- Click the `Select Track Model` Button
- Select the Track Model using Studio's Select tool or from the Explorer
- Click `Select`
- If Success, the Window should close and the currently selected track model should be the name of that model


### 2. Setup and Select Track Model

#### a. Create Track Model

##### InstanceData Format

###### Rails
- Axis : StringValue
- Offset : [ObjectValue, CFrameValue, Vector3Value]
    - ObjectValue
        - If Object referenced contains "StartCFrame" and "EndCFrame", determines the Offset as if the given BasePart between those points
- PositionInterval : NumberValue
- PositionStartOffset : NumberValue
- UseZOrientation : BoolValue
    - If true,
    - If false,
- IsOptimized : BoolValue
    - If true, will reduce parts on straight sections
- BasePart : BasePart

###### Ties
- Offset : [ObjectValue, CFrameValue, Vector3Value]
    - ObjectValue
        - Determines the Offset as if the given Model is offset from that CFrame
- PositionInterval : NumberValue
- PositionStartOffset : NumberValue
- Model : Model

###### Crossbeams
- StartOffset : [ObjectValue, CFrameValue, Vector3Value]
- EndOffset : [ObjectValue, CFrameValue, Vector3Value]
- Offsets : ObjectValue
    - *Optional*
    - ObjectValue
        - If Object referenced contains "StartCFrame" and "EndCFrame", determines the Offset as if the given BasePart between those points
- PositionInterval : NumberValue
- PositionStartOffset : NumberValue
- Model : Model

#### b. Select Track Model
- Click the `Select Track Model` Button
- Select the Track Model using Studio's Select tool or from the Explorer
- Click `Select`
- If Success, the Window should close and the currently selected track model should be the name of that model

### 3. Set Build Range

- Element with numbers
- Button on far right sets the End range to the end position of the track

### 4. Build!
- Click the `Build Current` Button. If all goes well, it should work.
