--[[
    Window Component
    Main container for the UI elements
    
    Features:
    - Draggable
    - Title bar with close button
    - Tab system
]]

local Window = {}
Window.__index = Window

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Import components
local Tab

-- Import utilities
local Theme = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Theme.lua'))()
local Tween = loadstring(game:HttpGet('https://raw.githubusercontent.com/KingTIM3R/Library/refs/heads/main/Tween.lua'))()

-- Initialize after requiring to avoid circular dependencies
function Window.initialize()
    Tab = require(script.Parent.Tab)
end

-- Create a new window
function Window.new(library, config)
    local self = setmetatable({}, Window)
    
    -- Initialize if not already done
    if not Tab then
        Window.initialize()
    end
    
    self.Library = library
    self.Config = config
    self.ScreenGui = library.ScreenGui
    self.Tabs = {}
    self.CurrentTab = nil
    
    -- Create window frame
    self.Frame = Instance.new("Frame")
    self.Frame.Name = "Window"
    self.Frame.Size = UDim2.new(0, config.Width, 0, config.Height)
    self.Frame.Position = UDim2.new(0.5, -config.Width/2, 0.5, -config.Height/2)
    self.Frame.BackgroundColor3 = Theme.Window.Background
    self.Frame.BorderSizePixel = 0
    self.Frame.ClipsDescendants = true
    self.Frame.Parent = self.ScreenGui
    
    -- Add drop shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = 0
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.6
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    Shadow.Parent = self.Frame
    
    -- Create title bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundColor3 = Theme.TitleBar.Background
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.Frame
    
    -- Create title text
    self.Title = Instance.new("TextLabel")
    self.Title.Name = "Title"
    self.Title.Size = UDim2.new(1, -60, 1, 0)
    self.Title.Position = UDim2.new(0, 10, 0, 0)
    self.Title.BackgroundTransparency = 1
    self.Title.Font = Enum.Font.Gotham
    self.Title.Text = config.Title
    self.Title.TextColor3 = Theme.TitleBar.Text
    self.Title.TextSize = 14
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.TitleBar
    
    -- Create close button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    self.CloseButton.Position = UDim2.new(1, -30, 0, 0)
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.Font = Enum.Font.Gotham
    self.CloseButton.Text = "✕"
    self.CloseButton.TextColor3 = Theme.TitleBar.CloseButton
    self.CloseButton.TextSize = 18
    self.CloseButton.Parent = self.TitleBar
    
    -- Create tab container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(0, 120, 1, -30)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 30)
    self.TabContainer.BackgroundColor3 = Theme.TabContainer.Background
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Parent = self.Frame
    
    -- Create tab buttons container
    self.TabButtonsContainer = Instance.new("ScrollingFrame")
    self.TabButtonsContainer.Name = "TabButtonsContainer"
    self.TabButtonsContainer.Size = UDim2.new(1, 0, 1, 0)
    self.TabButtonsContainer.BackgroundTransparency = 1
    self.TabButtonsContainer.BorderSizePixel = 0
    self.TabButtonsContainer.ScrollBarThickness = 0
    self.TabButtonsContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    self.TabButtonsContainer.Parent = self.TabContainer
    
    -- Create tab content container
    self.TabContentContainer = Instance.new("Frame")
    self.TabContentContainer.Name = "TabContentContainer"
    self.TabContentContainer.Size = UDim2.new(1, -120, 1, -30)
    self.TabContentContainer.Position = UDim2.new(0, 120, 0, 30)
    self.TabContentContainer.BackgroundColor3 = Theme.TabContent.Background
    self.TabContentContainer.BorderSizePixel = 0
    self.TabContentContainer.Parent = self.Frame
    
    -- Setup dragging
    self:SetupDragging()
    
    -- Connect close button
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
    
    return self
end

-- Setup dragging functionality
function Window:SetupDragging()
    local isDragging = false
    local dragInput
    local dragStart
    local startPos
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = true
            dragStart = input.Position
            startPos = self.Frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and isDragging then
            local delta = input.Position - dragStart
            self.Frame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Create a new tab
function Window:AddTab(name, icon)
    local newTab = Tab.new(self, {
        Name = name,
        Icon = icon
    })
    
    table.insert(self.Tabs, newTab)
    
    -- If this is the first tab, select it automatically
    if #self.Tabs == 1 then
        self:SelectTab(newTab)
    end
    
    return newTab
end

-- Select a tab
function Window:SelectTab(tab)
    -- Hide current tab if it exists
    if self.CurrentTab then
        self.CurrentTab:Hide()
    end
    
    -- Show the new tab
    tab:Show()
    self.CurrentTab = tab
end

-- Close the window
function Window:Close()
    -- Animate closing
    Tween.new(self.Frame, {
        Size = UDim2.new(0, self.Config.Width, 0, 0),
        Position = UDim2.new(0.5, -self.Config.Width/2, 0.5, 0)
    }, 0.2, function()
        self.Frame:Destroy()
    end)
    
    -- Remove from library's windows list
    for i, window in ipairs(self.Library.Windows) do
        if window == self then
            table.remove(self.Library.Windows, i)
            break
        end
    end
end

-- Update theme (used when accent color changes)
function Window:UpdateTheme()
    -- Update any elements that use accent color
    for _, tab in ipairs(self.Tabs) do
        tab:UpdateTheme()
    end
end

return Window
