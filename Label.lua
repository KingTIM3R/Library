--[[
    Label Component
    Simple text display element
]]

local Label = {}
Label.__index = Label

-- Import utilities
local Theme = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Theme.lua'))()

-- Create a new label
function Label.new(tab, config)
    local self = setmetatable({}, Label)
    
    self.Tab = tab
    self.Config = config or {}
    
    -- Create label frame
    self.Frame = Instance.new("Frame")
    self.Frame.Name = config.Name or "Label"
    self.Frame.Size = UDim2.new(1, 0, 0, 30)
    self.Frame.BackgroundTransparency = 1
    self.Frame.LayoutOrder = #tab.Elements
    self.Frame.Parent = tab.ElementsContainer
    
    -- Create text label
    self.Label = Instance.new("TextLabel")
    self.Label.Name = "LabelElement"
    self.Label.Size = UDim2.new(1, 0, 1, 0)
    self.Label.BackgroundTransparency = 1
    self.Label.Font = Enum.Font.Gotham
    self.Label.Text = config.Text or "Label"
    self.Label.TextColor3 = Theme.Label.Text
    self.Label.TextSize = 14
    self.Label.TextXAlignment = config.Alignment or Enum.TextXAlignment.Left
    self.Label.TextWrapped = config.Wrap or false
    self.Label.Parent = self.Frame
    
    -- If wrap is enabled and a height is provided, use it
    if config.Wrap and config.Height then
        self.Frame.Size = UDim2.new(1, 0, 0, config.Height)
    end
    
    return self
end

-- Set label text
function Label:SetText(text)
    self.Label.Text = text
end

-- Set text color
function Label:SetColor(color)
    self.Label.TextColor3 = color
end

-- Update theme (used when accent color changes)
function Label:UpdateTheme()
    -- Labels typically don't use accent color, but could be implemented here
end

return Label
