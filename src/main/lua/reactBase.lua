local component = require("component")
local event = require("event")
local gpu = component.gpu
local Array = require("arrayUtils")
local forEach = Array.forEach

local reactBase = {}

function reactBase.createElement(element)
  local state = {}
  local cachedProps = {}
  local renders = 0
  local instance = element()
  if instance.initialState ~= nul then
    state = instance.initialState
  end
  local setState
  local function render()
    renders = renders + 1
    instance.render(cachedProps, state, setState)
  end

  setState = function(newState)
    forEach(newState, function(value, key)
      state[key] = value
    end)
    instance.unmount(cachedProps)
    render()
  end

  return {
    render = function(props)
      if props ~= null then
        cachedProps = props
      end
      if renders ~= 0 then
        instance.unmount(cachedProps)
      end
      render()
    end,
    unmount = function()
      instance.unmount(cachedProps)
    end
  }
end

function reactBase.setText(x, y, text, color)
  local foreground = gpu.getForeground()
  if color ~= null then
    gpu.setForeground(color)
  end
  gpu.set(x, y, text)
  if text ~= null then
    gpu.setForeground(foreground)
  end
end

function reactBase.Button()
  local unmount
  return {
    render = function(props)
      local x = props.x
      local y = props.y
      local w = props.w
      local h = props.h
      local color = props.color
      local onClick = props.onClick
      local text = props.text
      local textColor = props.textColor
      local eventId = event.listen('touch', function(_, _, touchX, touchY)
        if touchX >= x and touchX < (x + w) and touchY >= y and touchY < (y + h) then
          onClick()
        end
      end)
      unmount = function()
        if eventId ~= null then
          event.cancel(eventId)
        end
        gpu.fill(x, y, w, h, " ")
      end
      local centerX = x + (w / 2)
      local centerY = y + (h / 2)
      local background = gpu.getBackground()
      gpu.setBackground(color)
      gpu.fill(x, y, w, h, " ")
      if text ~= null then
        reactBase.setText(centerX - (#text / 2), centerY, text, textColor)
      end
      gpu.setBackground(background)
    end,
    unmount = function()
      if unmount ~= null then
        unmount()
      end
    end
  }
end

return reactBase
