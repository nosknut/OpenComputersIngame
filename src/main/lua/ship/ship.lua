local fs = require("../lib/fs");

local ship = {};

function ship.jump(jumpConfig)
  print(jumpConfig);
  print(serialization.serialize(jumpConfig))
end

function ship.hasEnoughEnergy(jumpConfig)
  -- TODO: Implement
  return true;
end

function ship.jumpSnaggsSelf(jumpConfig)
  -- TODO: Implement
  return false;
end

local shipFiles = "/etc/ship/";
local shipConfigPath = shipFiles + "shipConfig.txt";

function ship.getShipConfig()
  return fs.getFile(shipConfigPath);
end

function ship.setShipConfig()
  return fs.setFile(shipConfigPath);
end


return ship;
