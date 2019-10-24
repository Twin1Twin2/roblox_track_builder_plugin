
local Selection = game:GetService("Selection")

local root = script.Parent.Parent.Parent

local Roact = require(root.Roact)
local cE = Roact.createElement

local SelectInstanceMenu = Roact.Component:extend("SelectInstanceMenu")


function SelectInstanceMenu:init()
    self:updateSelectedInstanceName()
end


function SelectInstanceMenu:updateSelectedInstanceName()
    local selectedInstanceName = "[NOTHING]"
    local selections = Selection:Get()
    local hasSelected = false

    if (#selections > 0) then
        selectedInstanceName = selections[1].Name
        hasSelected = true
    end

    self:setState({
        selectedInstanceName = selectedInstanceName;
        hasSelected = hasSelected;
    })
end


function SelectInstanceMenu:didMount()
    self.onSelectionChangedConnection = Selection.SelectionChanged:Connect(function()
        self:updateSelectedInstanceName()
    end)
end


function SelectInstanceMenu:willUnmount()
    self.onSelectionChangedConnection:Disconnect()
end


function SelectInstanceMenu:render()
    local props = self.props
    local menuName = props.menuName
    local closeMenu = props.closeMenu     -- closes this menu
    local onInstanceSelected = props.onInstanceSelected

    local selectedInstanceName = self.state.selectedInstanceName
    local hasSelected = self.state.hasSelected

    return cE(
        "Frame",
        {
            -- props
            Size = props.Size;
            Position = props.Position;

            BackgroundColor3 = Color3.fromRGB(37, 37, 37);
            BorderSizePixel = 0;
        },
        {
            MenuName = cE(
                "TextLabel",
                {
                    Size = UDim2.new(0, 200, 0, 12);
                    Position = UDim2.new(0, 0, 0, 0);
                    Text = menuName;

                    Font = Enum.Font.SourceSans;
                    TextColor3 = Color3.fromRGB(204, 204, 204);
                    TextSize = 12;

                    BackgroundColor3 = Color3.fromRGB(37, 37, 37);
                    BorderSizePixel = 0;
                }
            );
            SelectedInstanceNameLabel = cE(
                "TextLabel",
                {
                    Size = UDim2.new(0, 200, 0, 38);
                    Position = UDim2.new(0, 0, 0, 12);
                    Text = selectedInstanceName;

                    Font = Enum.Font.SourceSans;
                    TextColor3 = Color3.fromRGB(204, 204, 204);
                    TextSize = 16;

                    BackgroundColor3 = Color3.fromRGB(37, 37, 37);
                    BorderSizePixel = 0;
                }
            );
            AcceptSelectionButton = cE(
                "TextButton",
                {
                    Text = "Select";
                    Size = UDim2.new(0, 100, 0, 50);
                    Position = UDim2.new(0, 0, 0, 50);
                    TextColor3 = hasSelected == true and Color3.fromRGB(204, 204, 204) or Color3.fromRGB(127, 127, 127);

                    Font = Enum.Font.SourceSans;
                    TextSize = 24;

                    BackgroundColor3 = Color3.fromRGB(37, 37, 37);
                    BorderSizePixel = 0;

                    [Roact.Event.MouseButton1Click] = function()
                        -- pass selected instance to function
                        -- function returns true, close self
                        -- else, show error, don't close
                        local selections = Selection:Get()
                        if (#selections == 0) then
                            return
                        end

                        local selection = selections[1]
                        local isValid, message = onInstanceSelected(selection)

                        if (isValid == true) then
                            closeMenu()
                        else
                            warn(message)
                        end
                    end;
                }
            );
            CancelButton = cE(
                "TextButton",
                {
                    Text = "Cancel";
                    Size = UDim2.new(0, 100, 0, 50);
                    Position = UDim2.new(0, 100, 0, 50);

                    Font = Enum.Font.SourceSans;
                    TextColor3 = Color3.fromRGB(204, 204, 204);
                    TextSize = 24;

                    BackgroundColor3 = Color3.fromRGB(37, 37, 37);
                    BorderSizePixel = 0;

                    [Roact.Event.MouseButton1Click] = function()
                        -- close this panel
                        closeMenu()
                    end;
                }
            );
        }
    )
end


return SelectInstanceMenu