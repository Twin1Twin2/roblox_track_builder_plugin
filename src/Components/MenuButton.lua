
local root = script.Parent.Parent
local pluginRoot = root.Parent
local Roact = require(pluginRoot.Roact)

local cE = Roact.createElement


local function MenuButton(props)
    return cE(
        "TextButton",
        {
            --
            Size = props.Size or UDim2.new(1, 0, 0, 36);
            Position = props.Position or UDim2.new(0, 0, 0, 0);
            Text = props.Text;

            Font = Enum.Font.SourceSans;
            TextColor3 = props.TextColor3 or Color3.fromRGB(204, 204, 204);
            TextSize = 24;

            BackgroundColor3 = Color3.fromRGB(37, 37, 37);
            BorderSizePixel = 0;

            [Roact.Event.MouseButton1Click] = props.onClick;
        }
    )
end


return MenuButton