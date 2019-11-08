local component = require("component")
local gpu = component.gpu
local Array = require("/etc/com/nosk/lib/fs")
local Gui = require("/etc/com/nosk/lib/Gui.lua")
local _, screenHeight = gpu.getResolution()

function ListScreen(props)
    local buttons = {}

    local function generateButtons()
        local h = screenHeight - (props.y + 2)
        local colWidth = Array.max(Array.map(props.items, function(item) return #item end))
        if colWidth == null then
            colWidth = 0
        else
            colWidth = colWidth + 2
        end
        buttons = Array.map(props.items, function(item, index)
            local currentCol = math.floor((index - 1) / h)
            local x = (colWidth * currentCol) + 1
            local y = (props.y + 2) + ((index - 1) - (currentCol * h))
            return Gui.Button({
                x = x,
                y = y,
                w = colWidth,
                h = 1,
                color = ifOr((index + currentCol) % 2 == 0, 0x1a1f26, 0x00630a),
                onClick = function()
                    props.onClick(item)
                end,
                text = item,
                textColor = 0xdbdbdb,
                hoverColor = 0x000000,
            })
        end)
    end

    generateButtons()

    return {
        draw = function()
            Gui.setText(1, props.y, "Showing " .. #props.items .. " entries")
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

return ListScreen
