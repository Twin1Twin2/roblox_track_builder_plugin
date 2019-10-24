
local root = script.Parent.Parent
local Actions = require(root.Actions)
local PluginTrackManager = require(root.PluginTrackManager)

local Components = root.Components
local MenuButton = require(Components.MenuButton)


local pluginRoot = root.Parent
local Roact = require(pluginRoot.Roact)
local RoactRodux = require(pluginRoot.RoactRodux)

local cE = Roact.createElement


local CurrentTrackMenu = Roact.Component:extend("CurrentTrackMenu")

function CurrentTrackMenu:init()
    self:setState({
        isOpen = false;
    })
end

function CurrentTrackMenu:render()
    local props = self.props

    local currentTrackName = "[NONE]"

    if (props.trackName ~= nil) then
        currentTrackName = props.trackName
    end

    local children = {}
    local height = 0

    for trackUID, trackName in pairs(props.loadedTracks) do
        children["LoadedTrack" .. tostring(trackUID)] = cE(
            "TextButton",
            {
                Text = trackName;
                Size = UDim2.new(1, 0, 0, 36);
                Position = UDim2.new(0, 0, 0, height);

                Font = Enum.Font.SourceSans;
                TextColor3 = Color3.fromRGB(204, 204, 204);
                TextSize = 24;

                BackgroundColor3 = Color3.fromRGB(50, 50, 50);
                BorderSizePixel = 0;

                [Roact.Event.MouseButton1Click] = function()
                    self:setState({
                        isOpen = false;
                    })

                    PluginTrackManager:SetCurrentTrack(trackUID)
                end;
            },
            {
                -- children
                TrackOptions = cE(
                    "ImageButton",
                    {
                        Size = UDim2.new(0, 36, 0, 36);
                        Position = UDim2.new(1, 0, 0.5, 0);
                        AnchorPoint = Vector2.new(1, 0.5);
                        Image = "rbxasset://textures/StudioToolbox/SearchOptions.png";

                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;

                        [Roact.Event.MouseButton1Click] = function()
                            -- pull up track edit menu
                            print("")
                        end;
                    }
                )
            }
        )

        height = height + 36
    end

    return cE(
        "TextButton",
        {
            -- props
            Size = props.Size;
            Position = props.Position or UDim2.new();

            Text = currentTrackName;

            BackgroundColor3 = Color3.fromRGB(50, 50, 50);
            BorderSizePixel = 0;

            Font = Enum.Font.SourceSans;
            TextColor3 = Color3.fromRGB(204, 204, 204);
            TextSize = 24;
            ZIndex = props.ZIndex or 0;

            [Roact.Event.MouseButton1Click] = function()
                self:setState({
                    isOpen = not self.state.isOpen;
                })
            end;
        },
        {
            -- children
            LoadedTracksMenu = cE(
                "Frame",    -- use a portal
                {
                    Size = UDim2.new(1, 0, 0, height);
                    Position = UDim2.new(0, 0, 0, 36);
                    Visible = self.state.isOpen;

                    BackgroundColor3 = Color3.fromRGB(50, 50, 50);
                    BorderSizePixel = 0;
                },
                children
            );

            Arrow = cE(
                "ImageLabel",
                {
                    Size = UDim2.new(0, 36, 0, 36);
                    Position = UDim2.new(1, 0, 0.5, 0);
                    AnchorPoint = Vector2.new(1, 0.5);
                    Image = "rbxasset://textures/StudioToolbox/ArrowDownIconWhite.png";
                    BackgroundTransparency = 1;
                }
            )
        }
    )
end


local TrackMenu = Roact.Component:extend("TrackMenu")


function TrackMenu:render()
    local props = self.props
    local currentTrackState = props.currentTrackState

    local currentTrackLabelText
    if (currentTrackState.trackUID ~= nil) then
        currentTrackLabelText = currentTrackState.trackName
    end

    local trackSelectedTextColor =
        currentTrackState.trackUID ~= nil and Color3.fromRGB(204, 204, 204)
            or Color3.fromRGB(127, 127, 127)

    return cE(
        "Frame",
        {
            Size = props.Size;
            BackgroundTransparency = 1;
        },
        {
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

            CurrentTrackMenu = cE(
                CurrentTrackMenu,
                {
                    Size = UDim2.new(1, 0, 0, 32);
                    Position = UDim2.new(0, 0, 0, 0);
                    trackName = currentTrackLabelText;
                    loadedTracks = props.loadedTracks;

                    ZIndex = 5;

                    LayoutOrder = 4;
                }
            );
            --
            SelectTrackButton = cE(
                MenuButton,
                {
                    -- props
                    Text = "Select Track";
                    -- Position = UDim2.new(0, 0, 0, 36*5);

                    ZIndex = 1;
                    LayoutOrder = 2;

                    onClick = function()
                        print("Opening Menu!")
                        props.openSelectInstanceMenu(
                            "Select Track",
                            function()
                                local success = PluginTrackManager:LoadSelectedTrack()

                                if (success == false) then
                                    return false, "Could not load track!"
                                end

                                return true
                            end
                        )
                    end;
                }
            ),
            DeselectCurrentTrackButton = cE(
                MenuButton,
                {
                    -- props
                    Text = "Deselect Track";
                    -- Position = UDim2.new(0, 0, 0, 36*6);

                    TextColor3 = trackSelectedTextColor;

                    ZIndex = 1;
                    LayoutOrder = 3;

                    onClick = function()
                        print("Deselecting Track!")
                        PluginTrackManager:DeselectCurrentTrack()
                    end;
                }
            ),
            GenerateWoodenSupportsButton = cE(
                MenuButton,
                {
                    -- props
                    Text = "Generate Wooden Supports";
                    -- Position = UDim2.new(0, 0, 0, 36*6);

                    TextColor3 = trackSelectedTextColor;

                    ZIndex = 1;
                    LayoutOrder = 3;

                    onClick = function()
                        print("Generating Supports")
                        PluginTrackManager:GenerateWoodenSupports()
                    end;
                }
            )
            --
        }
    )
end


local function mapStateToProps(state, props)
    return {
        currentTrackState = state.CurrentTrack,
        loadedTracks = state.LoadedTracks,
    }
end


local function mapDispatchToProps(dispatch)
    return {
        openSelectInstanceMenu = function(menuName, onInstanceSelected)
            dispatch(Actions.OpenSelectInstanceMenu(menuName, onInstanceSelected))
        end,
        closeSelectInstanceMenu = function()
            dispatch(Actions.CloseSelectInstanceMenu())
        end
    }
end

TrackMenu = RoactRodux.connect(
    mapStateToProps,
    mapDispatchToProps
)(TrackMenu)


return TrackMenu