local component = require("component")
local gpu = component.gpu
local Array = require("/etc/com/nosk/lib/Array.lua")

local Gui = {}

function Gui.setText(x, y, text, color)
    local foreground = gpu.getForeground()
    if color ~= null then
        gpu.setForeground(color)
    end
    gpu.set(x, y, text)
    if text ~= null then
        gpu.setForeground(foreground)
    end
end

function Gui.Button(props)
    return {
        draw = function()
            local x = props.x
            local y = props.y
            local w = props.w
            local h = props.h
            local color = props.color
            local text = props.text
            local textColor = props.textColor
            local centerX = x + (w / 2)
            local centerY = y + (h / 2)
            local background = gpu.getBackground()
            gpu.setBackground(color)
            gpu.fill(x, y, w, h, " ")
            if text ~= null then
                Gui.setText(centerX - (#text / 2), centerY, text, textColor)
            end
            gpu.setBackground(background)
        end,
        setProps = function(newProps)
            Array.forEach(newProps, function(value, key)
                props[key] = value;
            end);
        end,
        click = function(touchX, touchY)
            local x = props.x
            local y = props.y
            local w = props.w
            local h = props.h
            if touchX >= x and touchX < (x + w) and touchY >= y and touchY < (y + h) then
                props.onClick()
            end
        end
    }
end

return Gui
