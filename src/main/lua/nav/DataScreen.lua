local component = require("component")
local gpu = component.gpu
local Array = require("/etc/com/nosk/lib/fs")
local Gui = require("/etc/com/nosk/lib/Gui.lua")
local map = Array.map
local max = Array.max
local forEach = Array.forEach
local keys = Array.keys
local _, screenHeight = gpu.getResolution()

function DataScreen(props)
    local entries = {}

    local function generateEntries()
        local h = screenHeight - (props.y)
        local fieldWidth = max(map(keys(props.data), function(key) return #key end))
        local entries = map(props.data, function(value, key)
            return string.rep(" ", fieldWidth - #key) .. key .. ": " .. value
        end)
        local colWidth = max(map(entries, function(entry) return #entry end)) + 2
        entries = map(entries, function(entry, index)
            local currentCol = math.floor((index - 1) / h)
            local x = (colWidth * currentCol) + 1
            local y = (props.y) + ((index - 1) - (currentCol * h))
            return {
                x = x,
                y = y,
                text = entry,
            }
        end)
    end

    generateEntries()

    return {
        draw = function()
            forEach(entries, function(entry)
                Gui.setText(entry.x, entry.y, entry.text)
            end)
        end,
        setProps = function(newProps)
            forEach(newProps, function(value, key)
                props[key] = value;
            end);
            generateEntries()
        end,
    }
end

return DataScreen
