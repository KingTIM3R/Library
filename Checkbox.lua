--[[
    Checkbox Component
    Boolean toggle element
]]

local Checkbox = {}
Checkbox.__index = Checkbox

-- Services
local TweenService = game:GetService("TweenService")

-- Import utilities
local Theme = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Theme.lua'))()
local Tween = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Tween.lua'))()

-- Create a new checkbox
function Checkbox.new(tab, config)
    local self = setmetatable({}, Checkbox)
    
    self.Tab = tab
    self.Config = config or {}
    self.Value = config.Default or false
    
    -- Create checkbox frame
    self.Frame = Instance.new("Frame")
    self.Frame.Name = config.Name or "Checkbox"
    self.Frame.Size = UDim2.new(1, 0, 0, 36)
    self.Frame.BackgroundTransparency = 1
    self.Frame.LayoutOrder = #tab.Elements
    self.Frame.Parent = tab.ElementsContainer
    
    -- Create label
    self.Label = Instance.new("TextLabel")
    self.Label.Name = "Label"
    self.Label.Size = UDim2.new(1, -50, 1, 0)
    self.Label.Position = UDim2.new(0, 0, 0, 0)
    self.Label.BackgroundTransparency = 1
    self.Label.Font = Enum.Font.Gotham
    self.Label.Text = config.Text or "Checkbox"
    self.Label.TextColor3 = Theme.Checkbox.Text
    self.Label.TextSize = 14
    self.Label.TextXAlignment = Enum.TextXAlignment.Left
    self.Label.Parent = self.Frame
    
    -- Create checkbox container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Container"
    self.Container.Size = UDim2.new(0, 36, 0, 20)
    self.Container.Position = UDim2.new(1, -36, 0.5, -10)
    self.Container.BackgroundColor3 = Theme.Checkbox.Background
    self.Container.BorderSizePixel = 0
    self.Container.Parent = self.Frame
    
    -- Create toggle indicator
    self.Indicator = Instance.new("Frame")
    self.Indicator.Name = "Indicator"
    self.Indicator.Size = UDim2.new(0, 16, 0, 16)
    self.Indicator.Position = UDim2.new(0, 2, 0.5, -8)
    self.Indicator.BackgroundColor3 = Theme.Checkbox.Indicator
    self.Indicator.BorderSizePixel = 0
    self.Indicator.Parent = self.Container
    
    -- Create hitbox
    self.Hitbox = Instance.new("TextButton")
    self.Hitbox.Name = "Hitbox"
    self.Hitbox.Size = UDim2.new(1, 0, 1, 0)
    self.Hitbox.BackgroundTransparency = 1
    self.Hitbox.Text = ""
    self.Hitbox.Parent = self.Container
    
    -- Set initial state
    if self.Value then
        self.Indicator.Position = UDim2.new(0, 18, 0.5, -8)
        self.Container.BackgroundColor3 = Theme.AccentColor
    end
    
    -- Connect toggle event
    self.Hitbox.MouseButton1Click:Connect(function()
        self:Toggle()
        
        if config.Callback and type(config.Callback) == "function" then
            config.Callback(self.Value)
        end
    end)
    
    return self
end

-- Toggle the checkbox
function Checkbox:Toggle()
    self.Value = not self.Value
    
    if self.Value then
        -- Animate to checked state
        Tween.new(self.Indicator, {Position = UDim2.new(0, 18, 0.5, -8)}, 0.2)
        Tween.new(self.Container, {BackgroundColor3 = Theme.AccentColor}, 0.2)
    else
        -- Animate to unchecked state
        Tween.new(self.Indicator, {Position = UDim2.new(0, 2, 0.5, -8)}, 0.2)
        Tween.new(self.Container, {BackgroundColor3 = Theme.Checkbox.Background}, 0.2)
    end
end

-- Set the value directly
function Checkbox:SetValue(value)
    if value ~= self.Value then
        self:Toggle()
    end
end

-- Get current value
function Checkbox:GetValue()
    return self.Value
end

-- Set callback function
function Checkbox:SetCallback(callback)
    if type(callback) == "function" then
        -- Disconnect previous connection if it exists
        if self.ClickConnection then
            self.ClickConnection:Disconnect()
        end
        
        -- Connect new callback
        self.ClickConnection = self.Hitbox.MouseButton1Click:Connect(function()
            callback(self.Value)
        end)
    end
end

-- Update theme (used when accent color changes)
function Checkbox:UpdateTheme()
    if self.Value then
        self.Container.BackgroundColor3 = Theme.AccentColor
    end
end

return Checkbox
