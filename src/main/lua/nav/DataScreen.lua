local component = require("component")
local gpu = component.gpu
local Array = require("arrayUtils")
local forEach = Array.forEach
local reactBase = require("reactBase")
local map = Array.map
local max = Array.max
local keys = Array.keys
local setText = reactBase.setText
local screenWidth, screenHeight = gpu.getResolution()

function DataScreen()
  local clearScreen
  return {
    render = function(props)
      clearScreen = function()
        gpu.fill(1, props.y, screenWidth, screenHeight - props.y, " ")
      end
      local h = screenHeight - (props.y)
      local fieldWidth = max(map(keys(props.data), function(key) return #key end))
      local entries = map(props.data, function(value, key)
        return string.rep(" ", fieldWidth - #key) .. key .. ": " .. value
      end)
      local colWidth = max(map(entries, function(entry) return #entry end)) + 2
      forEach(entries, function(entry, index)
        local currentCol = math.floor((index - 1) / h)
        local x = (colWidth * currentCol) + 1
        local y = (props.y) + ((index - 1) - (currentCol * h))
        setText(x, y, entry)
      end)
    end,
    unmount = function()
      if clearScreen ~= null then
        clearScreen()
      end
    end
  }
end

return DataScreen
