--- Initializes the plugin
--

local root = script.Parent

local RoactRodux = require(root.RoactRodux)
local Roact = require(root.Roact)
local Rodux = require(root.Rodux)

local Reducer = require(script.Reducer)
local App = require(script.Components.App)
local PluginTrackManager = require(script.PluginTrackManager)
local PluginTrackModelManager = require(script.PluginTrackModelManager)

-- temp?
local toolbar = plugin:CreateToolbar("Track Builder Plugin GUI")
local togglePluginButton = toolbar:CreateButton("ON/OFF", "", "")

local info = DockWidgetPluginGuiInfo.new(
    Enum.InitialDockState.Float,
    false,
    false,
    0,
    0
)

local guiRoot = plugin:createDockWidgetPluginGui("TagEditor", info)
    guiRoot.Name = "Track Builder Plugin GUI"
    guiRoot.Title = "Track Builder Plugin GUI"
    guiRoot.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

togglePluginButton:SetActive(guiRoot.Enabled)


local store = Rodux.Store.new(Reducer)

PluginTrackManager:InitStore(store)
PluginTrackModelManager:InitStore(store)

local app = Roact.createElement(
    RoactRodux.StoreProvider,
    {
        store = store
    },
    {
        App = Roact.createElement(
            App,
            {}
        )
    }
)

Roact.mount(app, guiRoot, "Roblox Track Ride Framework GUI")


togglePluginButton.Click:Connect(function()
    guiRoot.Enabled = not guiRoot.Enabled
    togglePluginButton:SetActive(guiRoot.Enabled)
end)


print("Track Builder Plugin GUI Loaded!")