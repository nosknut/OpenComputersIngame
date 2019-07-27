local component = require("component")
local gpu = component.gpu
local Array = require("arrayUtils")
local forEach = Array.forEach
local reactBase = require("reactBase")
local Button = reactBase.Button
local createElement = reactBase.createElement
local screenWidth = gpu.getResolution()

function ifOr(expression, ifTrue, ifFalse)
  return expression and ifTrue or ifFalse
end

function Tabs()
  local buttons = {}
  local unmount
  return {
    render = function(props)
      local tabWidth = math.floor(screenWidth / #props.tabs)
      local remainingWidth = screenWidth - (tabWidth * #props.tabs)
      forEach(props.tabs, function(tab, index)
        if buttons[tab.label] == null then
          buttons[tab.label] = createElement(Button)
        end
        buttons[tab.label].render({
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
    end,
    unmount = function()
      forEach(buttons, function(button) button.unmount() end)
    end
  }
end

return Tabs
