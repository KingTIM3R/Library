--[[
    Input Component
    Text input field
]]

local Input = {}
Input.__index = Input

-- Services
local UserInputService = game:GetService("UserInputService")

-- Import utilities
local Theme = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Theme.lua'))()
local Tween = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Tween.lua'))()

-- Create a new input field
function Input.new(tab, config)
    local self = setmetatable({}, Input)
    
    self.Tab = tab
    self.Config = config or {}
    
    -- Create input frame
    self.Frame = Instance.new("Frame")
    self.Frame.Name = config.Name or "Input"
    self.Frame.Size = UDim2.new(1, 0, 0, 60)
    self.Frame.BackgroundTransparency = 1
    self.Frame.LayoutOrder = #tab.Elements
    self.Frame.Parent = tab.ElementsContainer
    
    -- Create label
    if config.Title then
        self.Label = Instance.new("TextLabel")
        self.Label.Name = "Label"
        self.Label.Size = UDim2.new(1, 0, 0, 20)
        self.Label.BackgroundTransparency = 1
        self.Label.Font = Enum.Font.Gotham
        self.Label.Text = config.Title
        self.Label.TextColor3 = Theme.Input.Label
        self.Label.TextSize = 14
        self.Label.TextXAlignment = Enum.TextXAlignment.Left
        self.Label.Parent = self.Frame
    end
    
    -- Create input container
    self.Container = Instance.new("Frame")
    self.Container.Name = "Container"
    self.Container.Size = UDim2.new(1, 0, 0, 36)
    self.Container.Position = UDim2.new(0, 0, 0, config.Title and 24 or 0)
    self.Container.BackgroundColor3 = Theme.Input.Background
    self.Container.BorderSizePixel = 0
    self.Container.Parent = self.Frame
    
    -- Create input box
    self.Input = Instance.new("TextBox")
    self.Input.Name = "InputElement"
    self.Input.Size = UDim2.new(1, -20, 1, 0)
    self.Input.Position = UDim2.new(0, 10, 0, 0)
    self.Input.BackgroundTransparency = 1
    self.Input.Font = Enum.Font.Gotham
    self.Input.PlaceholderText = config.PlaceholderText or "Enter text..."
    self.Input.PlaceholderColor3 = Theme.Input.PlaceholderText
    self.Input.Text = config.DefaultText or ""
    self.Input.TextColor3 = Theme.Input.Text
    self.Input.TextSize = 14
    self.Input.TextXAlignment = Enum.TextXAlignment.Left
    self.Input.ClearTextOnFocus = config.ClearOnFocus ~= nil and config.ClearOnFocus or false
    self.Input.Parent = self.Container
    
    -- Input focus effects
    self.Input.Focused:Connect(function()
        Tween.new(self.Container, {BackgroundColor3 = Theme.Input.FocusBackground}, 0.2)
    end)
    
    self.Input.FocusLost:Connect(function(enterPressed)
        Tween.new(self.Container, {BackgroundColor3 = Theme.Input.Background}, 0.2)
        
        if enterPressed and config.Callback and type(config.Callback) == "function" then
            config.Callback(self.Input.Text)
        end
    end)
    
    return self
end

-- Get current text
function Input:GetText()
    return self.Input.Text
end

-- Set text
function Input:SetText(text)
    self.Input.Text = text
end

-- Clear text
function Input:Clear()
    self.Input.Text = ""
end

-- Set callback function
function Input:SetCallback(callback)
    if type(callback) == "function" then
        -- Disconnect previous connection if it exists
        if self.FocusLostConnection then
            self.FocusLostConnection:Disconnect()
        end
        
        -- Connect new callback
        self.FocusLostConnection = self.Input.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                callback(self.Input.Text)
            end
        end)
    end
end

-- Update theme (used when accent color changes)
function Input:UpdateTheme()
    -- Inputs typically don't use accent color, but could be implemented here
end

return Input
