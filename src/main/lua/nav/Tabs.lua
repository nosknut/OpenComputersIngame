local component = require("component")
local gpu = component.gpu
local Array = require("/etc/com/nosk/lib/fs")
local Gui = require("/etc/com/nosk/lib/Gui.lua")
local Button = Gui.Button
local screenWidth = gpu.getResolution()

function ifOr(expression, ifTrue, ifFalse)
    return expression and ifTrue or ifFalse
end

function Tabs(props)
    local buttons = {}

    local function generateButtons()
        local tabWidth = math.floor(screenWidth / #props.tabs)
        local remainingWidth = screenWidth - (tabWidth * #props.tabs)
        buttons = Array.map(props.tabs, function(tab, index)
            return Button({
                x = (index * tabWidth) - tabWidth + 1,
                y = props.y,
                w = index == #props.tabs and tabWidth + remainingWidth or tabWidth,
                h = 3,
                color = ifOr(tab.label == props.selected, 0x000000, ifOr(index % 2 == ifOr(props.offsetColor, 1, 0), 0x484A20, 0x55555)),
                onClick = tab.onClick,
                text = tab.label,
                textColor = 0xFFFFFF,
                hoverColor = 0x000000,
            })
        end)
    end

    generateButtons()

    return {
        draw = function()
            Array.forEach(buttons, function(button)
                button.draw();
            end)
        end,
        click = function(x, y)
            Array.forEach(buttons, function(button)
                button.click(x, y);
            end)
        end,
        setProps = function(newProps)
            Array.forEach(newProps, function(value, key)
                props[key] = value;
            end);
            generateButtons();
        end,
    }
end

return Tabs
