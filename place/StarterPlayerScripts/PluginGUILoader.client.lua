--- Loads the GUI from the plugin in Play Mode
-- Mainly for testing/designing purposes

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local pluginModel = ReplicatedStorage:FindFirstChild("Roblox-Track-Builder-Plugin")

local Roact = require(pluginModel.Roact)
local cE = Roact.createElement

local App = require(pluginModel.PluginMain.Components.App)

local LocalPlayer = Players.LocalPlayer

local app = cE(
    "ScreenGui",
    {},
    {
        RootFrame = cE(
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

                PaddedFrame = cE(
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
                                Text = "Roblox Track Builder Plugin",
                                TextColor3 = Color3.fromRGB(225, 225, 225),
                                TextSize = 8,
                                BackgroundTransparency = 1,
                            }
                        ),

                        PluginWindow = cE(
                            "Frame",
                            {
                                Size = UDim2.new(1, 0, 1, -20),
                                Position = UDim2.new(0, 0, 0, 20),
                            },
                            {
                                App = cE(
                                    App,
                                    {}
                                ),
                            }
                        ),
                    }
                )
            }
        )
    }
)


Roact.mount(app, LocalPlayer.PlayerGui, "Roblox-Track-Builder-Plugin-GUI")