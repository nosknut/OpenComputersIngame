os.execute("rm /etc/com/nosk/install.lua" .. path .. "/" .. file)
os.execute("wget https://raw.githubusercontent.com/nosknut/OpenComputersIngame/master/src/main/lua/install.lua /etc/com/nosk/install.lua")
os.execute("/etc/com/nosk/install.lua")
