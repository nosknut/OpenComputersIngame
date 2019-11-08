local computer = require("computer")

function getFile(file, path)
  local installFile = (path == null and "/etc/com/nosk/" or path) .. file
  os.execute("rm " .. installFile)
  os.execute("wget https://raw.githubusercontent.com/nosknut/OpenComputersIngame/master/src/main/lua/" .. file .. " " .. installFile)
end

getFile("lib/Array.lua")
getFile("lib/fs.lua")
getFile("lib/Gui.lua")
getFile("nav/DataScreen.lua")
getFile("nav/ListScreen.lua")
getFile("nav/Nav.lua")
getFile("nav/Tabs.lua")
getFile("ship/Ship.lua")
getFile("autorun.lua", "/")

computer.shutdown(true)
