local serialization = require("serialization")

local fs = {}

function fs.getFile(path)
    file = io.open(path, "r")
    local value = file:read()
    file:close()
    return serialization.unserialize(value)
end

function fs.setFile(value, path)
    filesystem.remove(path)
    file = io.open(path, "w")
    file:write(serialization.serialize(value))
    file:close()
end

return fs;
