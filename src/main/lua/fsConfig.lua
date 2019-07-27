local fsConfig = {};

function fsConfig.readConfig(path)
    file = io.open(path, "r")
    local config = file:read()
    file:close()
    return serialization.unserialize(config)
end

function fsConfig.setConfig(config, path)
    filesystem.remove(path)
    file = io.open(path, "w")
    file:write(serialization.serialize(config))
    file:close()
end

fsConfig.installDir = "/lib/fsConfig";

function fsConfig.uninstall()
    flesystem.remove(fsConfig.installDir)
end

return fsConfig;