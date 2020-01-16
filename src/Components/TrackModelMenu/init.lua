
local root = script.Parent.Parent
local Actions = require(root.Actions)

local PluginTrackModelManager = require(root.PluginTrackModelManager)

local Components = root.Components
local MenuButton = require(Components.MenuButton)

local pluginRoot = root.Parent
local Roact = require(pluginRoot.Roact)
local RoactRodux = require(pluginRoot.RoactRodux)

local cE = Roact.createElement

local TrackModelMenu = Roact.Component:extend("TrackModelMenu")


function TrackModelMenu:render()
    local props = self.props

    local trackModelName = props.currentTrackModelState.trackModelName or "[NONE]"

    return cE(
        "Frame",
        {
            -- props
            Size = props.Size;
            BackgroundTransparency = 1;
        },
        {
            -- children
            UIListLayout = cE(
                "UIListLayout",
                {
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    -- hack :(
                    [Roact.Ref] = function(rbx)
                        if rbx then
                            spawn(function()
                                wait()
                                wait()
                                rbx:ApplyLayout()
                            end)
                        end
                    end;
                }
            );

            CurrentTrackModelLabel = cE(
                "TextLabel",
                {
                    Size = UDim2.new(1, 0, 0, 36);
                    Text = trackModelName;

                    Font = Enum.Font.SourceSans;
                    TextColor3 = props.TextColor3 or Color3.fromRGB(204, 204, 204);
                    TextSize = 24;

                    BackgroundColor3 = Color3.fromRGB(50, 50, 50);
                    BorderSizePixel = 0;
                }
            );

            SelectTrackModelButton = cE(
                MenuButton,
                {
                    Text = "Select Track Model";
                    onClick = function()
                        props.openSelectInstanceMenu(
                            "Select Track Model",
                            function(instance)
                                local success = PluginTrackModelManager:LoadSelected()

                                if (success == false) then
                                    return false, "Could not load Track Model!"
                                end

                                return true
                            end
                        )
                    end;
                }
            );

            BuildTrackModelButton = cE(
                MenuButton,
                {
                    Text = "Build Current";
                    onClick = function()
                        PluginTrackModelManager:BuildCurrent(
                            props.trackModelBuildRangeState.Start,
                            props.trackModelBuildRangeState.End
                        )
                    end;
                }
            );

            BuildRange = cE(
                "Frame",
                {
                    -- props
                    Size = UDim2.new(1, 0, 0, 36);
                },
                {
                    -- children
                    RangeStart = cE(
                        "TextBox",
                        {
                            -- props
                            Size = UDim2.new(0.5, 0, 1, 0);
                            Text = tostring(props.trackModelBuildRangeState.Start);

                            Font = Enum.Font.SourceSans;
                            TextColor3 = props.TextColor3 or Color3.fromRGB(204, 204, 204);
                            TextSize = 24;

                            BackgroundColor3 = Color3.fromRGB(50, 50, 50);
                            BorderSizePixel = 0;

                            [Roact.Event.FocusLost] = function(rbx, enterPressed, inputThatCausedFocus)
                                local input = tonumber(rbx.Text)
                                if (enterPressed == true and input ~= nil) then
                                    props.setBuildRange(input)
                                else
                                    rbx.Text = tostring(props.trackModelBuildRangeState.Start)
                                end
                            end,
                        }
                    ),
                    -- children
                    RangeEnd = cE(
                        "TextBox",
                        {
                            -- props
                            Size = UDim2.new(0.5, -16, 1, 0);
                            Position = UDim2.new(0.5, 0, 0, 0);
                            Text = tostring(props.trackModelBuildRangeState.End);

                            Font = Enum.Font.SourceSans;
                            TextColor3 = props.TextColor3 or Color3.fromRGB(204, 204, 204);
                            TextSize = 24;

                            BackgroundColor3 = Color3.fromRGB(50, 50, 50);
                            BorderSizePixel = 0;

                            [Roact.Event.FocusLost] = function(rbx, enterPressed, inputThatCausedFocus)
                                local input = tonumber(rbx.Text)
                                if (enterPressed == true and input ~= nil) then
                                    props.setBuildRange(nil, input)
                                else
                                    rbx.Text = tostring(props.trackModelBuildRangeState.End)
                                end
                            end,
                        }
                    ),

                    SetRangeEndToTrackEndButton = cE(
                        "ImageButton",
                        {
                            Size = UDim2.new(16, 0, 1, 0);
                            Position = UDim2.new(1, -16, 0, 0);

                            BackgroundColor3 = Color3.fromRGB(50, 50, 50);
                            BorderSizePixel = 0;

                            Image = "rbxasset://textures/ui/AvatarContextMenu_Arrow.png";

                            [Roact.Event.MouseButton1Click] = function()
                                props.setBuildRange(nil, props.currentTrackState.trackLength)
                            end;
                        }
                    )
                }
            )
        }
    )
end


local function mapStateToProps(state, props)
    return {
        currentTrackState = state.CurrentTrack,
        currentTrackModelState = state.CurrentTrackModel,
        trackModelBuildRangeState = state.TrackModelBuildRange
    }
end


local function mapDispatchToProps(dispatch)
    return {
        openSelectInstanceMenu = function(menuName, onInstanceSelected)
            dispatch(Actions.OpenSelectInstanceMenu(menuName, onInstanceSelected))
        end,
        closeSelectInstanceMenu = function()
            dispatch(Actions.CloseSelectInstanceMenu())
        end,
        setBuildRange = function(rangeStart, rangeEnd)
            dispatch(Actions.SetBuildRange(rangeStart, rangeEnd))
        end,
    }
end

TrackModelMenu = RoactRodux.connect(
    mapStateToProps,
    mapDispatchToProps
)(TrackModelMenu)


return TrackModelMenu