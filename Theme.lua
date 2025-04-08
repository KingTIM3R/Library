--[[
    Theme Utility
    Defines colors and styling for the UI library
]]

local Theme = {
    -- Main colors
    AccentColor = Color3.fromRGB(0, 120, 255),
    
    -- Window
    Window = {
        Background = Color3.fromRGB(25, 25, 25),
    },
    
    -- Title Bar
    TitleBar = {
        Background = Color3.fromRGB(18, 18, 18),
        Text = Color3.fromRGB(255, 255, 255),
        CloseButton = Color3.fromRGB(255, 255, 255),
    },
    
    -- Tab Container
    TabContainer = {
        Background = Color3.fromRGB(20, 20, 20),
    },
    
    -- Tab Content
    TabContent = {
        Background = Color3.fromRGB(25, 25, 25),
    },
    
    -- Tab
    Tab = {
        Text = Color3.fromRGB(180, 180, 180),
        SelectedText = Color3.fromRGB(255, 255, 255),
    },
    
    -- Section
    Section = {
        Text = Color3.fromRGB(230, 230, 230),
        Separator = Color3.fromRGB(40, 40, 40),
    },
    
    -- Button
    Button = {
        PrimaryBackground = Color3.fromRGB(0, 120, 255),
        PrimaryHover = Color3.fromRGB(0, 130, 255),
        PrimaryPress = Color3.fromRGB(0, 100, 230),
        PrimaryText = Color3.fromRGB(255, 255, 255),
        
        SecondaryBackground = Color3.fromRGB(40, 40, 40),
        SecondaryHover = Color3.fromRGB(50, 50, 50),
        SecondaryPress = Color3.fromRGB(35, 35, 35),
        SecondaryText = Color3.fromRGB(230, 230, 230),
    },
    
    -- Label
    Label = {
        Text = Color3.fromRGB(230, 230, 230),
    },
    
    -- Input
    Input = {
        Background = Color3.fromRGB(35, 35, 35),
        FocusBackground = Color3.fromRGB(45, 45, 45),
        Text = Color3.fromRGB(230, 230, 230),
        PlaceholderText = Color3.fromRGB(120, 120, 120),
        Label = Color3.fromRGB(200, 200, 200),
    },
    
    -- Checkbox
    Checkbox = {
        Background = Color3.fromRGB(40, 40, 40),
        Indicator = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(230, 230, 230),
    },
    
    -- Slider
    Slider = {
        Background = Color3.fromRGB(40, 40, 40),
        Knob = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(230, 230, 230),
        ValueText = Color3.fromRGB(180, 180, 180),
    },
    
    -- Scrollbar
    ScrollBar = Color3.fromRGB(60, 60, 60),
}

-- Function to derive colors from accent color
local function updateDerivedColors()
    -- Update button primary colors
    Theme.Button.PrimaryBackground = Theme.AccentColor
    Theme.Button.PrimaryHover = Theme.AccentColor:Lerp(Color3.fromRGB(255, 255, 255), 0.1)
    Theme.Button.PrimaryPress = Theme.AccentColor:Lerp(Color3.fromRGB(0, 0, 0), 0.1)
end

-- Watch for accent color changes
local mt = getmetatable(Theme) or {}
setmetatable(Theme, mt)

mt.__newindex = function(t, k, v)
    rawset(t, k, v)
    
    -- Update derived colors when accent color changes
    if k == "AccentColor" then
        updateDerivedColors()
    end
end

-- Initialize derived colors
updateDerivedColors()

return Theme
