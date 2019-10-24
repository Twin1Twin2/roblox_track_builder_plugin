--- Root Frame for the non-widget plugin GUI
--

local root = script.Parent.Parent
local Roact = require(root.Roact)

local function RootFrame(props)
    local name = props.appName
    local children = props[Roact.Children]

   return Roact.createElement(
        "Frame",
        {
            Size = UDim2.new(0, 384, 0, 256);
            Position = UDim2.new(0, 0, 0, 20);
            BackgroundColor3 = Color3.fromRGB(37, 37, 37);
            BorderColor3 = Color3.fromRGB(0, 0, 0);
        },
        {
            UIPadding = Roact.createElement(
                "UIPadding",
                {
                    PaddingLeft = UDim.new(0, 4),
                    PaddingRight = UDim.new(0, 4),
                    PaddingTop = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 4),
                }
            ),

            PaddedFrame = Roact.createElement(
                "Frame",
                {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                },
                {
                    PluginName = Roact.createElement(
                        "TextLabel",
                        {
                            Size = UDim2.new(1, 0, 0, 16),
                            Position = UDim2.new(0, 0, 0, 0),
                            Text = name,
                            TextColor3 = Color3.fromRGB(225, 225, 225),
                            TextSize = 8,
                            BackgroundTransparency = 1,
                        }
                    ),

                    PluginWindow = Roact.createElement(
                        "Frame",
                        {
                            Size = UDim2.new(1, 0, 1, -20),
                            Position = UDim2.new(0, 0, 0, 20),
                        },
                        children
                    ),
                }
            )
        }
    )
end


return RootFrame