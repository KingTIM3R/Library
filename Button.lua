--[[
    Button Component
    Standard interactive button element
]]

local Button = {}
Button.__index = Button

-- Services
local TweenService = game:GetService("TweenService")

-- Import utilities
local Theme = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Theme.lua'))()
local Tween = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Tween.lua'))()

-- Create a new button
function Button.new(tab, config)
    local self = setmetatable({}, Button)
    
    self.Tab = tab
    self.Config = config or {}
    
    -- Create button frame
    self.Frame = Instance.new("Frame")
    self.Frame.Name = config.Name or "Button"
    self.Frame.Size = UDim2.new(1, 0, 0, 36)
    self.Frame.BackgroundTransparency = 1
    self.Frame.LayoutOrder = #tab.Elements
    self.Frame.Parent = tab.ElementsContainer
    
    -- Create the actual button
    self.Button = Instance.new("TextButton")
    self.Button.Name = "ButtonElement"
    self.Button.Size = UDim2.new(1, 0, 1, 0)
    self.Button.BackgroundColor3 = config.Primary and Theme.Button.PrimaryBackground or Theme.Button.SecondaryBackground
    self.Button.BorderSizePixel = 0
    self.Button.Font = Enum.Font.Gotham
    self.Button.Text = config.Text or "Button"
    self.Button.TextColor3 = config.Primary and Theme.Button.PrimaryText or Theme.Button.SecondaryText
    self.Button.TextSize = 14
    self.Button.Parent = self.Frame
    
    -- Add icon if provided
    if config.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Name = "Icon"
        icon.Size = UDim2.new(0, 16, 0, 16)
        icon.Position = UDim2.new(0, 10, 0.5, -8)
        icon.BackgroundTransparency = 1
        icon.Image = config.Icon
        icon.Parent = self.Button
        
        -- Adjust text position
        self.Button.Text = "      " .. self.Button.Text
    end
    
    -- Button effects
    self.Button.MouseEnter:Connect(function()
        local targetColor = config.Primary and Theme.Button.PrimaryHover or Theme.Button.SecondaryHover
        Tween.new(self.Button, {BackgroundColor3 = targetColor}, 0.2)
    end)
    
    self.Button.MouseLeave:Connect(function()
        local targetColor = config.Primary and Theme.Button.PrimaryBackground or Theme.Button.SecondaryBackground
        Tween.new(self.Button, {BackgroundColor3 = targetColor}, 0.2)
    end)
    
    self.Button.MouseButton1Down:Connect(function()
        local targetColor = config.Primary and Theme.Button.PrimaryPress or Theme.Button.SecondaryPress
        Tween.new(self.Button, {BackgroundColor3 = targetColor}, 0.1)
    end)
    
    self.Button.MouseButton1Up:Connect(function()
        local targetColor = config.Primary and Theme.Button.PrimaryHover or Theme.Button.SecondaryHover
        Tween.new(self.Button, {BackgroundColor3 = targetColor}, 0.1)
    end)
    
    -- Connect callback
    if config.Callback and type(config.Callback) == "function" then
        self.Button.MouseButton1Click:Connect(function()
            config.Callback()
        end)
    end
    
    return self
end

-- Set button text
function Button:SetText(text)
    self.Button.Text = text
end

-- Set button callback
function Button:SetCallback(callback)
    if type(callback) == "function" then
        -- Disconnect previous connection if it exists
        if self.ClickConnection then
            self.ClickConnection:Disconnect()
        end
        
        -- Connect new callback
        self.ClickConnection = self.Button.MouseButton1Click:Connect(callback)
    end
end

-- Update theme (used when accent color changes)
function Button:UpdateTheme()
    if self.Config.Primary then
        self.Button.BackgroundColor3 = Theme.Button.PrimaryBackground
        self.Button.TextColor3 = Theme.Button.PrimaryText
    end
end

return Button
