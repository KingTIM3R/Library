--[[
    Slider Component
    Numeric value selector
]]

local Slider = {}
Slider.__index = Slider

-- Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Import utilities
local Theme = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Theme.lua'))()
local Tween = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Tween.lua'))()

-- Create a new slider
function Slider.new(tab, config)
    local self = setmetatable({}, Slider)
    
    self.Tab = tab
    self.Config = config or {}
    
    -- Default configuration
    self.Min = config.Min or 0
    self.Max = config.Max or 100
    self.Value = config.Default or self.Min
    self.Decimals = config.Decimals or 0
    
    -- Validate initial value
    self.Value = math.max(self.Min, math.min(self.Max, self.Value))
    
    -- Create slider frame
    self.Frame = Instance.new("Frame")
    self.Frame.Name = config.Name or "Slider"
    self.Frame.Size = UDim2.new(1, 0, 0, 56)
    self.Frame.BackgroundTransparency = 1
    self.Frame.LayoutOrder = #tab.Elements
    self.Frame.Parent = tab.ElementsContainer
    
    -- Create label
    if config.Title then
        self.Label = Instance.new("TextLabel")
        self.Label.Name = "Label"
        self.Label.Size = UDim2.new(1, -50, 0, 20)
        self.Label.BackgroundTransparency = 1
        self.Label.Font = Enum.Font.Gotham
        self.Label.Text = config.Title
        self.Label.TextColor3 = Theme.Slider.Text
        self.Label.TextSize = 14
        self.Label.TextXAlignment = Enum.TextXAlignment.Left
        self.Label.Parent = self.Frame
        
        -- Create value display
        self.ValueLabel = Instance.new("TextLabel")
        self.ValueLabel.Name = "Value"
        self.ValueLabel.Size = UDim2.new(0, 50, 0, 20)
        self.ValueLabel.Position = UDim2.new(1, -50, 0, 0)
        self.ValueLabel.BackgroundTransparency = 1
        self.ValueLabel.Font = Enum.Font.Gotham
        self.ValueLabel.Text = tostring(self.Value)
        self.ValueLabel.TextColor3 = Theme.Slider.ValueText
        self.ValueLabel.TextSize = 14
        self.ValueLabel.Parent = self.Frame
    end
    
    -- Create slider container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Container"
    self.Container.Size = UDim2.new(1, 0, 0, 36)
    self.Container.Position = UDim2.new(0, 0, 0, config.Title and 20 or 0)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = self.Frame
    
    -- Create slider background
    self.Background = Instance.new("Frame")
    self.Background.Name = "Background"
    self.Background.Size = UDim2.new(1, 0, 0, 8)
    self.Background.Position = UDim2.new(0, 0, 0.5, -4)
    self.Background.BackgroundColor3 = Theme.Slider.Background
    self.Background.BorderSizePixel = 0
    self.Background.Parent = self.Container
    
    -- Create slider fill
    self.Fill = Instance.new("Frame")
    self.Fill.Name = "Fill"
    self.Fill.Size = UDim2.new(self:GetFillPercent(), 0, 1, 0)
    self.Fill.BackgroundColor3 = Theme.AccentColor
    self.Fill.BorderSizePixel = 0
    self.Fill.Parent = self.Background
    
    -- Create slider knob
    self.Knob = Instance.new("Frame")
    self.Knob.Name = "Knob"
    self.Knob.Size = UDim2.new(0, 16, 0, 16)
    self.Knob.Position = UDim2.new(self:GetFillPercent(), -8, 0.5, -8)
    self.Knob.BackgroundColor3 = Theme.Slider.Knob
    self.Knob.BorderSizePixel = 0
    self.Knob.ZIndex = 2
    self.Knob.Parent = self.Background
    
    -- Create hitbox
    self.Hitbox = Instance.new("TextButton")
    self.Hitbox.Name = "Hitbox"
    self.Hitbox.Size = UDim2.new(1, 0, 1, 20)
    self.Hitbox.Position = UDim2.new(0, 0, 0, -10)
    self.Hitbox.BackgroundTransparency = 1
    self.Hitbox.Text = ""
    self.Hitbox.Parent = self.Background
    
    -- Setup slider behavior
    self:SetupSlider()
    
    -- Update value display
    self:UpdateValueLabel()
    
    return self
end

-- Setup slider interaction
function Slider:SetupSlider()
    local isDragging = false
    
    self.Hitbox.MouseButton1Down:Connect(function()
        isDragging = true
        self:UpdateFromMousePosition(UserInputService:GetMouseLocation())
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if isDragging and self.Config.Callback then
                self.Config.Callback(self.Value)
            end
            isDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
            self:UpdateFromMousePosition(UserInputService:GetMouseLocation())
        end
    end)
end

-- Update slider from mouse position
function Slider:UpdateFromMousePosition(mousePos)
    local sliderPos = self.Background.AbsolutePosition
    local sliderSize = self.Background.AbsoluteSize
    
    local relativeX = math.clamp(mousePos.X - sliderPos.X, 0, sliderSize.X)
    local percent = relativeX / sliderSize.X
    
    self:SetValue(self.Min + (self.Max - self.Min) * percent)
end

-- Get fill percentage based on value
function Slider:GetFillPercent()
    return (self.Value - self.Min) / (self.Max - self.Min)
end

-- Set slider value
function Slider:SetValue(value)
    -- Clamp and round value
    value = math.max(self.Min, math.min(self.Max, value))
    if self.Decimals == 0 then
        value = math.floor(value + 0.5)
    else
        local mult = 10 ^ self.Decimals
        value = math.floor(value * mult + 0.5) / mult
    end
    
    self.Value = value
    
    -- Update visuals
    local percent = self:GetFillPercent()
    self.Fill.Size = UDim2.new(percent, 0, 1, 0)
    self.Knob.Position = UDim2.new(percent, -8, 0.5, -8)
    
    -- Update display
    self:UpdateValueLabel()
end

-- Update value label
function Slider:UpdateValueLabel()
    if self.ValueLabel then
        if self.Decimals == 0 then
            self.ValueLabel.Text = tostring(math.floor(self.Value))
        else
            -- Format with decimals
            local fmt = "%." .. self.Decimals .. "f"
            self.ValueLabel.Text = string.format(fmt, self.Value)
        end
    end
end

-- Get current value
function Slider:GetValue()
    return self.Value
end

-- Set callback function
function Slider:SetCallback(callback)
    self.Config.Callback = callback
end

-- Update theme (used when accent color changes)
function Slider:UpdateTheme()
    self.Fill.BackgroundColor3 = Theme.AccentColor
end

return Slider
