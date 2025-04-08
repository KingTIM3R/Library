--[[
    SystemUI Library
    A clean, system-like UI library for Roblox
    
    Inspired by the visual aesthetic of Rayfield
    Created for legitimate UI development in Roblox experiences
    
    Features:
    - Draggable windows with title bar
    - Tab system for organization
    - Various UI elements (buttons, inputs, sliders, etc.)
    - Dark theme with customizable accent colors
    - Clean, professional appearance
]]

local SystemUI = {}
SystemUI.__index = SystemUI

-- Services
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Import components
local Window = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Window.lua'))()
local Button = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Button.lua'))()
local Label = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Label.lua'))()
local Input = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Input.lua'))()
local Checkbox = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Checkbox.lua'))()
local Slider = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Slider.lua'))()
local Tab = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Tab.lua'))()

-- Import utilities
local Theme = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Theme.lua'))()

-- Library configuration
local LIBRARY_CONFIG = {
    Version = "1.0.0",
}

-- Initialize the library
function SystemUI.new(config)
    local self = setmetatable({}, SystemUI)
    
    -- Default configuration
    self.Config = {
        Title = config.Title or "SystemUI",
        AccentColor = config.AccentColor or Color3.fromRGB(0, 120, 255),
        Width = config.Width or 550,
        Height = config.Height or 350,
        Parent = config.Parent or Players.LocalPlayer:WaitForChild("PlayerGui"),
    }
    
    -- Set theme
    Theme.AccentColor = self.Config.AccentColor
    
    -- Create main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "SystemUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = self.Config.Parent
    
    -- Components storage
    self.Windows = {}
    
    return self
end

-- Create a new window
function SystemUI:CreateWindow(title)
    local newWindow = Window.new(self, {
        Title = title or self.Config.Title,
        Width = self.Config.Width,
        Height = self.Config.Height
    })
    
    table.insert(self.Windows, newWindow)
    return newWindow
end

-- Set accent color for the entire UI
function SystemUI:SetAccentColor(color)
    assert(typeof(color) == "Color3", "Accent color must be a Color3 value")
    
    self.Config.AccentColor = color
    Theme.AccentColor = color
    
    -- Update all windows with the new accent color
    for _, window in ipairs(self.Windows) do
        window:UpdateTheme()
    end
end

-- Destroy the UI
function SystemUI:Destroy()
    self.ScreenGui:Destroy()
    self.Windows = {}
end

return SystemUI
