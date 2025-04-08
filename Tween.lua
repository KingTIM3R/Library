--[[
    Tween Utility
    Helper for creating smooth animations
]]

local TweenService = game:GetService("TweenService")

local Tween = {}

-- Default tween info
local DEFAULT_TWEEN_INFO = TweenInfo.new(
    0.2,                -- Time
    Enum.EasingStyle.Quad, -- EasingStyle
    Enum.EasingDirection.Out -- EasingDirection
)

-- Create a new tween
function Tween.new(instance, properties, duration, callback, easingStyle, easingDirection)
    -- Validate parameters
    assert(typeof(instance) == "Instance", "Instance expected for first argument")
    assert(typeof(properties) == "table", "Table expected for properties")
    
    -- Default duration if not provided
    duration = duration or 0.2
    
    -- Create tween info
    local tweenInfo = TweenInfo.new(
        duration,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    
    -- Create and start the tween
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    
    -- Connect callback if provided
    if callback and type(callback) == "function" then
        tween.Completed:Connect(function()
            callback()
        end)
    end
    
    return tween
end

return Tween
