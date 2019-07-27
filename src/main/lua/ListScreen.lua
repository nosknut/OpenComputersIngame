local component = require("component")
local gpu = component.gpu
local Array = require("arrayUtils")
local map = Array.map
local max = Array.max
local forEach = Array.forEach
local reactBase = require("reactBase")
local Button = reactBase.Button
local createElement = reactBase.createElement
local setText = reactBase.setText
local screenWidth, screenHeight = gpu.getResolution()

function ListScreen()
  local buttons = {}
  local clearScreen
  return {
    render = function(props)
      clearScreen = function()
        gpu.fill(1, props.y, screenWidth, screenHeight - props.y, " ")
      end
      local h = screenHeight - (props.y + 2)
      local colWidth = max(map(props.items, function(item) return #item end))
      if colWidth == null then
        colWidth=0
      else
        colWidth=colWidth+2
      end
      setText(1, props.y, "Showing " .. #props.items .. " entries")
      forEach(props.items, function(item, index)
        local currentCol = math.floor((index - 1) / h)
        local x = (colWidth * currentCol) + 1
        local y = (props.y + 2) + ((index - 1) - (currentCol * h))
        if buttons[item] == null then
          buttons[item] = createElement(Button)
        end
        buttons[item].render({
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
    end,
    unmount = function()
      if clearScreen ~= null then
        clearScreen()
      end
      forEach(buttons, function(button) button.unmount() end)
    end
  }
end

return ListScreen
