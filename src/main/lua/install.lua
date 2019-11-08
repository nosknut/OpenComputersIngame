local computer = require("computer")

function getFile(file, path, name)
  local installFile = path .. "/" .. (name ~= null and name or file)
  os.execute("rm " .. installFile)
  os.execute("wget https://raw.githubusercontent.com/nosknut/OpenComputersIngame/master/src/main/lua/" .. file .. " " .. installFile)
end

getFile("DataScreen.lua", "/lib")
getFile("ListScreen.lua", "/lib")
getFile("Tabs.lua", "/lib")
getFile("Array.lua", "/lib")
getFile("reactBase.lua", "/lib")
getFile("Nav.lua", "", "autorun.lua")

computer.shutdown(true)
