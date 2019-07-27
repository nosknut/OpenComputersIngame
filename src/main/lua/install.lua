function getFile(path)
    local token = "AD3YJDDKCP6TXCAOI3NACK25HSAUO"
    os.execute("wget https://raw.githubusercontent.com/nosknut/OpenComputers/master/" .. path .. "?token=" .. token .. "/lib")
end

print("Downloading fsConfig ...")
getFile("Core/fsConfig.lua") 
print("Downloading wdNav ...")
getFile("Core/wdNav.lua")