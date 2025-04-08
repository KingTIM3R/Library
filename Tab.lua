--[[
    Tab Component
    Container for organizing UI elements in tabs
]]

local Tab = {}
Tab.__index = Tab

-- Services
local TweenService = game:GetService("TweenService")

-- Import utilities
local Theme = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Theme.lua'))()
local Tween = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Tween.lua'))()

-- Import components (for creating elements)
local Button, Label, Input, Checkbox, Slider

-- Initialize after requiring to avoid circular dependencies
function Tab.initialize()

local Button = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Button.lua'))()
local Label = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Label.lua'))()
local Input = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Input.lua'))()
local Checkbox = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Checkbox.lua'))()
local Slider = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Slider.lua'))()

end

-- Create a new tab
function Tab.new(window, config)
    local self = setmetatable({}, Tab)
    
    -- Initialize if not already done
    if not Button then
        Tab.initialize()
    end
    
    self.Window = window
    self.Config = config
    self.Elements = {}
    self.Visible = false
    
    -- Create tab button
    self.Button = Instance.new("TextButton")
    self.Button.Name = config.Name .. "Button"
    self.Button.Size = UDim2.new(1, 0, 0, 36)
    self.Button.Position = UDim2.new(0, 0, 0, (#window.Tabs * 36))
    self.Button.BackgroundTransparency = 1
    self.Button.Font = Enum.Font.Gotham
    self.Button.Text = "  " .. config.Name
    self.Button.TextColor3 = Theme.Tab.Text
    self.Button.TextSize = 14
    self.Button.TextXAlignment = Enum.TextXAlignment.Left
    self.Button.Parent = window.TabButtonsContainer
    
    -- Add tab selection indicator
    self.SelectionIndicator = Instance.new("Frame")
    self.SelectionIndicator.Name = "SelectionIndicator"
    self.SelectionIndicator.Size = UDim2.new(0, 2, 1, 0)
    self.SelectionIndicator.Position = UDim2.new(0, 0, 0, 0)
    self.SelectionIndicator.BackgroundColor3 = Theme.AccentColor
    self.SelectionIndicator.BorderSizePixel = 0
    self.SelectionIndicator.Visible = false
    self.SelectionIndicator.Parent = self.Button
    
    -- Add icon if provided
    if config.Icon then
        local tabIcon = Instance.new("ImageLabel")
        tabIcon.Name = "Icon"
        tabIcon.Size = UDim2.new(0, 16, 0, 16)
        tabIcon.Position = UDim2.new(0, 10, 0.5, -8)
        tabIcon.BackgroundTransparency = 1
        tabIcon.Image = config.Icon
        tabIcon.Parent = self.Button
        
        -- Adjust text position
        self.Button.Text = "      " .. config.Name
    end
    
    -- Create content frame for tab
    self.ContentFrame = Instance.new("ScrollingFrame")
    self.ContentFrame.Name = config.Name .. "Content"
    self.ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.ScrollBarThickness = 4
    self.ContentFrame.ScrollBarImageColor3 = Theme.ScrollBar
    self.ContentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    self.ContentFrame.Visible = false
    self.ContentFrame.Parent = window.TabContentContainer
    
    -- Create container for elements
    self.ElementsContainer = Instance.new("Frame")
    self.ElementsContainer.Name = "ElementsContainer"
    self.ElementsContainer.Size = UDim2.new(1, -20, 1, 0)
    self.ElementsContainer.Position = UDim2.new(0, 10, 0, 0)
    self.ElementsContainer.BackgroundTransparency = 1
    self.ElementsContainer.Parent = self.ContentFrame
    
    -- Auto-size the elements container
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Name = "UIListLayout"
    uiListLayout.Padding = UDim.new(0, 8)
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.Parent = self.ElementsContainer
    
    -- Auto-update canvas size
    uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Connect tab button click
    self.Button.MouseButton1Click:Connect(function()
        self.Window:SelectTab(self)
    end)
    
    -- Hover effects
    self.Button.MouseEnter:Connect(function()
        if not self.Visible then
            Tween.new(self.Button, {BackgroundTransparency = 0.9}, 0.2)
        end
    end)
    
    self.Button.MouseLeave:Connect(function()
        if not self.Visible then
            Tween.new(self.Button, {BackgroundTransparency = 1}, 0.2)
        end
    end)
    
    return self
end

-- Show tab
function Tab:Show()
    -- Hide all tabs
    for _, tab in ipairs(self.Window.Tabs) do
        if tab ~= self then
            tab.ContentFrame.Visible = false
            tab.SelectionIndicator.Visible = false
            Tween.new(tab.Button, {
                BackgroundTransparency = 1,
                TextColor3 = Theme.Tab.Text
            }, 0.2)
        end
    end
    
    -- Show this tab
    self.ContentFrame.Visible = true
    self.SelectionIndicator.Visible = true
    Tween.new(self.Button, {
        BackgroundTransparency = 0.8,
        TextColor3 = Theme.Tab.SelectedText
    }, 0.2)
    
    self.Visible = true
end

-- Hide tab
function Tab:Hide()
    self.ContentFrame.Visible = false
    self.SelectionIndicator.Visible = false
    Tween.new(self.Button, {
        BackgroundTransparency = 1,
        TextColor3 = Theme.Tab.Text
    }, 0.2)
    
    self.Visible = false
end

-- Create a section 
function Tab:AddSection(title)
    local sectionFrame = Instance.new("Frame")
    sectionFrame.Name = title .. "Section"
    sectionFrame.Size = UDim2.new(1, 0, 0, 35)
    sectionFrame.BackgroundTransparency = 1
    sectionFrame.LayoutOrder = #self.Elements
    sectionFrame.Parent = self.ElementsContainer
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "Title"
    sectionTitle.Size = UDim2.new(1, 0, 0, 30)
    sectionTitle.Position = UDim2.new(0, 0, 0, 0)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Font = Enum.Font.GothamSemibold
    sectionTitle.Text = title
    sectionTitle.TextColor3 = Theme.Section.Text
    sectionTitle.TextSize = 14
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Parent = sectionFrame
    
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.Position = UDim2.new(0, 0, 0, 30)
    separator.BackgroundColor3 = Theme.Section.Separator
    separator.BorderSizePixel = 0
    separator.Parent = sectionFrame
    
    table.insert(self.Elements, sectionFrame)
    return sectionFrame
end

-- Create a button
function Tab:AddButton(config)
    local newButton = Button.new(self, config)
    table.insert(self.Elements, newButton)
    return newButton
end

-- Create a label
function Tab:AddLabel(config)
    local newLabel = Label.new(self, config)
    table.insert(self.Elements, newLabel)
    return newLabel
end

-- Create an input field
function Tab:AddInput(config)
    local newInput = Input.new(self, config)
    table.insert(self.Elements, newInput)
    return newInput
end

-- Create a checkbox/toggle
function Tab:AddCheckbox(config)
    local newCheckbox = Checkbox.new(self, config)
    table.insert(self.Elements, newCheckbox)
    return newCheckbox
end

-- Create a slider
function Tab:AddSlider(config)
    local newSlider = Slider.new(self, config)
    table.insert(self.Elements, newSlider)
    return newSlider
end

-- Update theme (used when accent color changes)
function Tab:UpdateTheme()
    self.SelectionIndicator.BackgroundColor3 = Theme.AccentColor
    
    -- Update all elements
    for _, element in ipairs(self.Elements) do
        if element.UpdateTheme then
            element:UpdateTheme()
        end
    end
end

return Tab
