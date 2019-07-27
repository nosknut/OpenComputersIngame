local fsConfig = require("fsConfig");

local wdNav = {};

function wdNav.jump(jumpConfig)
    print(jumpConfig);
    print(serialization.serialize(jumpConfig))
end

function wdNav.hasEnoughEnergy(jumpConfig)
    //TODO: Implement
    return true;
end

function wdNav.jumpSnaggsSelf(jumpConfig)
    //TODO: Implement 
    return false;
end

local wdNavFiles = "/etc/wdNav/";
local shipConfigPath = wdNavFiles + "shipConfig.txt";

function wdNav.getShipConfig()
    return fsCOnfig.getConfig(shipConfigPath);
end

function wdNav.setShipConfig()
    return fsCOnfig.setConfig(shipConfigPath);
end

wdNav.installDir = "/lib/wdNav";

function wdNav.uninstall()
    filesystem.remove(wdNav.installDir)
    filesystem.remove(shipConfigPath)
    fsConfig.uninstall()
end

return wdNav;
