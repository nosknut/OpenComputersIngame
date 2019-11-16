local term = require("term")
local component = require("component")
local stargate = component.stargate
local opticalScan = stargate.opticalScan
local gravimetricScan = stargate.gravimetricScan
local subspaceScan = stargate.subspaceScan
local readSensorBuffer = stargate.bufferRead
local event = require("event")
local Array = require("arrayUtils")
local map = Array.map
local unique = Array.unique
local filter = Array.filter
local sort = Array.sort
local find = Array.find
local reactBase = require("reactBase")
local ListScreen = require("ListScreen")
local DataScreen = require("DataScreen")
local Tabs = require("Tabs")
local createElement = reactBase.createElement
local computer = require("computer")

local ObjectType = {
  CLUSTERS = { key = "CLUSTERS", label = "Clusters" },
  GALAXIES = { key = "GALAXIES", label = "Galaxies" },
  SYSTEMS = { key = "SYSTEMS", label = "Systems" },
  PLANETS = { key = "PLANETS", label = "Planets" },
  OBJECTS = { key = "OBJECTS", label = "Objects" },
}

local ScanType = {
  SUBSPACE = { key = "SUBSPACE", label = "Subspace" },
  GRAVIMETRIC = { key = "GRAVIMETRIC", label = "Gravimetric" },
  OPTICAL = { key = "OPTICAL", label = "Optical" },
}

function systemOf(designation)
  if designation == null then
    return null
  end
  return designation:sub(1, 3)
end

function Page()
  local scanTypeTabsElement = createElement(Tabs)
  local objectTabsElement = createElement(Tabs)
  local screenElement = createElement(ListScreen)
  local dataScreenElement = createElement(DataScreen)
  print("Version 0.1")
  gravimetricScan()
  return {
    initialState = {
      objectType = ObjectType.CLUSTERS,
      scanType = ScanType.SUBSPACE,
      filters = {}
    },
    render = function(_, state, setState)
      local sensorBuffer = readSensorBuffer(stargate.entriesInBuffer())
      scanTypeTabsElement.render({
        y = 1,
        selected = state.scanType.label,
        tabs = map({
          ScanType.SUBSPACE,
          ScanType.GRAVIMETRIC,
          ScanType.OPTICAL,
        }, function(type) return {
          label = type.label,
          onClick = function()
            if type == ScanType.SUBSPACE then
              subspaceScan()
            elseif type == ScanType.GRAVIMETRIC then
              gravimetricScan()
            elseif type == ScanType.OPTICAL then
              opticalScan()
            end
            setState({ scanType = type })
          end
        }
        end)
      })
      objectTabsElement.render({
        y = 4,
        offsetColor = true,
        selected = state.objectType.label,
        tabs = map({
          ObjectType.CLUSTERS,
          ObjectType.GALAXIES,
          ObjectType.SYSTEMS,
          ObjectType.OBJECTS,
        }, function(type)
          local filter = state.filters[type.key]
          local hasFilter = filter ~= null
          return {
            label = hasFilter and filter or type.label,
            onClick = function()
              setState({
                objectType = type,
                filters = {}
              })
            end
          }
        end)
      })
      if state.filters[ObjectType.OBJECTS.key] == null then
        dataScreenElement.unmount()
        screenElement.render({
          y = 8,
          items = sort(unique(map(filter(sensorBuffer, function(entry)
            local function matches(type, value)
              if value == null then
                return false
              end
              local filter = state.filters[type.key]
              if filter ~= null then
                return filter == value:sub(1, #filter)
              end
              return true
            end

            return (matches(ObjectType.CLUSTERS, entry.cluster)
                    and matches(ObjectType.GALAXIES, entry.galaxy)
                    and matches(ObjectType.SYSTEMS, systemOf(entry.designation))
                    and matches(ObjectType.OBJECTS, entry.designation))
          end), function(entry)
            if state.objectType == ObjectType.CLUSTERS then
              return entry.cluster
            elseif state.objectType == ObjectType.GALAXIES then
              return entry.galaxy
            elseif state.objectType == ObjectType.SYSTEMS then
              return systemOf(entry.designation)
            elseif state.objectType == ObjectType.OBJECTS then
              return entry.designation
            end
          end))),
          onClick = function(item)
            local newFilters = state.filters
            newFilters[state.objectType.key] = item
            local function nextType()
              if state.objectType == ObjectType.CLUSTERS then
                return ObjectType.GALAXIES
              elseif state.objectType == ObjectType.GALAXIES then
                return ObjectType.SYSTEMS
              elseif state.objectType == ObjectType.SYSTEMS then
                return ObjectType.OBJECTS
              else
                return state.objectType
              end
            end

            setState({
              objectType = nextType(),
              filters = newFilters
            })
          end
        })
      else
        screenElement.unmount()
        dataScreenElement.render({
          y = 8,
          data = find(sensorBuffer, function(element)
            return state.filters[ObjectType.OBJECTS.key] == element.designation
          end)
        })
      end
    end,
    unmount = function()
      objectTabsElement.unmount()
      scanTypeTabsElement.unmount()
      screenElement.unmount()
      dataScreenElement.unmount()
    end
  }
end

function renderPage()
  local eventId
  eventId = event.listen("key_down", function(_, _, code)
    if code == 18 then
      computer.shutdown(true)
    end
    if code == 21 then
      term.clear()
      os.execute("/home/update")
    end
  end)
  term.clear()
  local element = createElement(Page)
  element.render()
  while event.pull(nil, "interrupted") == nil do
  end
  element.unmount()
  event.cancel(eventId)
end

function main()
  renderPage()
end

main()
