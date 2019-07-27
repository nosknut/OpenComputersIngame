function getFile(file, path)
  os.execute("rm " .. path .. "/" .. file)
  os.execute("wget https://raw.githubusercontent.com/nosknut/OpenComputersIngame/master/src/main/lua/" .. file .. " " .. path .. "/" .. file)
end

getFile("installAutoNav.lua", ".")
os.execute("installAutoNav")
