--- GUI Main
--

local root = script.Parent.Parent
local Actions = require(root.Actions)

local componentsRoot = root.Components
local SelectInstanceMenu = require(componentsRoot.SelectInstanceMenu)
local TrackMenu = require(componentsRoot.TrackMenu)
local TrackModelMenu = require(componentsRoot.TrackModelMenu)


local pluginRoot = root.Parent
local Roact = require(pluginRoot.Roact)
-- local Rodux = require(root.Rodux)
local RoactRodux = require(pluginRoot.RoactRodux)

local cE = Roact.createElement

local function App(props)
    local children = {
        Main = cE(
            "Frame",
            {
                Size = UDim2.new(1, 0, 1, 0);
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
                TrackMenu = cE(
                    TrackMenu,
                    {
                        -- props
                        Size = UDim2.new(1, 0, 0.5, 0);
                    }
                ),
                TrackModelMenu = cE(
                    TrackModelMenu,
                    {
                        -- props
                        Size = UDim2.new(1, 0, 0.5, 0);
                    }
                )
            }
        )
    }

    local selectInstanceMenuState = props.selectInstanceMenuState
    local isSelectInstanceMenuOpen = selectInstanceMenuState.isOpen
    if (isSelectInstanceMenuOpen == true) then
        children.SelectInstanceMenu = cE(
            SelectInstanceMenu,
            {
                -- props
                Size = UDim2.new(0, 200, 0, 100);

                closeMenu = props.closeSelectInstanceMenu;
                menuName = selectInstanceMenuState.menuName;
                onInstanceSelected = selectInstanceMenuState.onInstanceSelected;
            }
        )
    end

    return cE(
        "Frame",
        {
            -- props
            Size = UDim2.new(1, 0, 1, 0);
        },
        children
    )
end


local function mapStateToProps(state, props)
    return {
        selectInstanceMenuState = state.SelectInstanceMenu,
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

App = RoactRodux.connect(
    mapStateToProps,
    mapDispatchToProps
)(App)


return App