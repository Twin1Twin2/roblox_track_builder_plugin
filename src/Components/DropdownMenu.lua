
local root = script.Parent.Parent.Parent

local Roact = require(root.Roact)


local DropdownMenuItem = function(props)
    return Roact.createElement(
        "Frame",
        {
            Size = UDim2.new(1, 0, 0, 36);
        },
        {
            SelectButton = Roact.createElement(
                "TextButton",
                {
                    Size = UDim2.new(1, -36, 1, 0);
                    Text = "Dropdown Menu Item";
                    TextColor3 = Color3.fromRGB(204, 204, 204);
                    TextSize = 24;
                }
            );
            OptionButton = Roact.createElement(
                "ImageButton",
                {
                    Size = UDim2.new(0, 36, 0, 36);
                    Position = UDim2.new(1, 0, 0.5, 0);
                    AnchorPoint = UDim.new(1, 0.5);
                    Image = "rbxasset://textures/StudioToolbox/SearchOptions.png";
                }
            );
        }
    )
end


local DropdownMenu = Roact.Component:extend("DropdownMenu")

function DropdownMenu:render()
    local props = self.props
    local children = {}

    -- create children
    for _, option in pairs(props.Options) do
        children[option] = Roact.createElement(
            DropdownMenuItem,
            {},
            {}
        )
    end

    return Roact.createElement(
        "TextButton",
        {
            -- props
            Size = props.Size;
            TextColor3 = Color3.fromRGB(204, 204, 204);
            TextSize = 24;
        },
        {
            -- children
            DropdownSubMenu = Roact.createElement(
                "ScrollingFrame",
                {
                    Visible = self.props.IsOpen;
                },
                children
            );

            Arrow = Roact.createElement(
                "ImageLabel",
                {
                    Size = UDim2.new(0, 36, 0, 36);
                    Position = UDim2.new(1, 0, 0.5, 0);
                    AnchorPoint = UDim.new(1, 0.5);
                    Image = "rbxasset://textures/StudioToolbox/ArrowDownIconWhite.png";
                }
            )
        }
    )
end


return DropdownMenu