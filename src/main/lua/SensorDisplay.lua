local component = require("component")
local stargate = component.stargate
local opticalScan = stargate.opticalScan
local gravimetricScan = stargate.gravimetricScan
local subspaceScan = stargate.subspaceScan
local readSensorBuffer = stargate.readSensorBuffer
local serialization = require("serialization")
local event = require("event")
local gpu = component.gpu
local Array = require("arrayUtils")
local map = Array.map
local unique = Array.unique
local filter = Array.filter
local increment = Array.increment
local count = Array.count
local min = Array.min
local max = Array.max
local accum = Array.accum
local values = Array.values
local keys = Array.keys
local join = Array.join
local forEach = Array.forEach
local contains = Array.contains


function readFile(path)
  local file = io.open(path, "r")
  local entries = file:read()
  file:close()
  return serialization.unserialize(entries)
end

function writeFile(path, value)
  local file = io.open(path, "w")
  file:write(serialization.serialize(value))
  file:close()
end

function printCount(counts)
  for k, e in pairs(counts) do
    print(k .. ": " .. e)
  end
end

function uniqueFields(objects)
  local fields = {}
  for _, object in pairs(objects) do
    for key in pairs(object) do
      fields[#fields + 1] = key
    end
  end
  return unique(fields)
end

function printProps(entries)
  print("Properties")
  print(join(uniqueFields(entries), ", "))
end

function printClusters(entries)
  print("Clusters:")
  printCount(count(map(entries, function(entry) return entry.cluster end)))
end

function printGalaxies(entries)
  print("Galaxies:")
  printCount(count(map(entries, function(entry) return entry.galaxy end)))
end

function printSystems(entries)
  print("Systems:")
  local systems = count(map(entries, function(entry) return entry.designation:sub(1, 4) end))
  printCount(systems)
  print("Found " .. #entries .. " objects in " .. #keys(systems) .. " systems")
end

function printTypes(entries)
  print("Types:")
  printCount(count(map(entries, function(entry) return entry.type end)))
end

function printClasses(entries)
  print("Claasses:")
  printCount(count(map(entries, function(entry) return entry.class end)))
end

function printEverything(entries)
  print("Found " .. #entries .. " objects:")
  printProps(entries)
  printClusters(entries)
  printGalaxies(entries)
  printClusters(entries)
  printGalaxies(entries)
  printTypes(entries)
  printClasses(entries)
  printSystems(entries)
  print(join(unique(map(entries, function(v) return v.designation:sub(1, 2) end)), ", "))
end
