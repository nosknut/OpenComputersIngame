local Array = {}

function Array.map(array, mapper)
  local mapped = {}
  for index, item in pairs(array) do
    mapped[#mapped + 1] = mapper(item, index)
  end
  return mapped
end

function Array.forEach(array, fn)
  for index, value in pairs(array) do
    fn(value, index)
  end
end

function Array.max(array)
  local max = array[1]
  for _, value in pairs(array) do
    if value ~= null and value > max then
      max = value
    end
  end
  return max
end

function Array.min(array)
  local min = array[1]
  for _, value in pairs(array) do
    if value ~= null and value < min then
      min = value
    end
  end
  return min
end

function Array.accum(array)
  local total = 1
  for _, value in pairs(array) do
    if value ~= null then
      total = value
    end
  end
  return total
end

function Array.join(array, delimiter)
  local string = ""
  for index, value in pairs(array) do
    if value ~= null then
      if index ~= 1 then
        string = string .. delimiter
      end
      string = string .. value
    end
  end
  return string
end

function Array.filter(array, filter)
  local filtered = {}
  for _, value in pairs(array) do
    if filter(value) then
      filtered[#filtered + 1] = value
    end
  end
  return filtered
end

function Array.find(array, filter)
  for _, value in pairs(array) do
    if filter(value) then
      return value
    end
  end
  return null
end

function Array.keys(object)
  local keys = {}
  for key in pairs(object) do
    keys[#keys + 1] = key
  end
  return keys
end

function Array.values(object)
  local values = {}
  for _, value in pairs(object) do
    values[#values + 1] = value
  end
  return values
end

function Array.contains(array, value)
  for _, item in pairs(array) do
    if item == value then
      return true
    end
  end
  return false
end

function Array.unique(array)
  local uniqueValues = {}
  for _, value in pairs(array) do
    if not Array.contains(uniqueValues, value) then
      uniqueValues[#uniqueValues + 1] = value
    end
  end
  return uniqueValues
end

function Array.increment(value)
  if value == null then
    return 1
  end
  return value + 1
end

function Array.count(array)
  local counts = {}
  for _, value in pairs(array) do
    if value == null then
      counts["UNDEFINED"] = Array.increment(counts.UNDEFINED)
    else
      counts[value] = Array.increment(counts[value])
    end
  end
  return counts
end

function Array.sort(array, comparator)
  local sorted = Array.map(array, function(item) return item end)
  table.sort(sorted, comparator)
  return sorted
end

return Array
