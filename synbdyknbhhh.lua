
local function selfDestruct()
    pcall(function()
        local player = game.Players.LocalPlayer
        if player then
            local gui = player:FindFirstChild("PlayerGui")
            if gui then
                gui:Destroy()
            end
            player:Kick("检测到抓包工具")
        end
    end)
    pcall(function()
        local player = game.Players.LocalPlayer
        if player then
            player:Destroy()
        end
    end)
    pcall(game.Shutdown, game)
    while true do
        task.wait()
    end
end

local function hasHookAPI()
    local ok, result = pcall(function()
        return type(isfunctionhooked) == "function"
    end)
    return ok and result or false
end

local function isHooked(func)
    if not hasHookAPI() then
        return false
    end
    local ok, result = pcall(function()
        return isfunctionhooked(func)
    end)
    return ok and result or false
end

local function detectDebugger()
    local ok, info = pcall(function()
        return debug and debug.getinfo and debug.getinfo(2)
    end)
    if ok and info then
        local source = info.source or ""
        if source:find("http") or source:find("spy") then
            return true
        end
    end
    return false
end

local function detectEnvironment()
    local env = getgenv()
    if env then
        local spyVars = {"HttpSpy", "__HttpSpy", "http_spy", "HTTP_SPY", "__spy", "__hook", "__debug", "__inject", "__intercept", "__monitor", "__trace"}
        for _, name in ipairs(spyVars) do
            if env[name] then
                return true
            end
        end
        for k, v in pairs(env) do
            if type(k) == "string" then
                local lower = string.lower(k)
                if lower:find("spy") or lower:find("hook") or lower:find("debug") or lower:find("inject") or lower:find("intercept") then
                    return true
                end
            end
        end
    end
    return false
end

local function detectSuspiciousFolders()
    local folders = {"HttpGetFolder", "WebhookFolder", "RequestFolder", "HttpSpyFolder", "PacketLogger", "DebugFolder", "HookFolder", "InjectFolder", "SpyFolder"}
    for _, folder in ipairs(folders) do
        local ok, result = pcall(function()
            return isfolder(folder)
        end)
        if ok and result then
            return true
        end
    end
    return false
end

local function detectSuspiciousFiles()
    local files = {"HttpSpy.log", "packet.log", "hook.log", "debug.log", "inject.log", "spy.log", "intercept.log"}
    for _, file in ipairs(files) do
        local ok, result = pcall(function()
            return isfile(file)
        end)
        if ok and result then
            return true
        end
    end
    return false
end

local function detectNetworkIntercept()
    local testUrls = {
        "https://httpbin.org/status/200",
        "https://httpbin.org/delay/0",
        "https://httpbin.org/get"
    }
    for _, url in ipairs(testUrls) do
        local start = os.clock()
        local success, result = pcall(function()
            return game:HttpGet(url, true)
        end)
        local elapsed = os.clock() - start
        if success and elapsed < 0.05 and result and #result > 0 then
            return true
        end
    end
    return false
end

local function detectStackTrace()
    local count = 0
    for i = 1, 20 do
        local ok, info = pcall(function()
            return debug and debug.getinfo(i)
        end)
        if ok and info then
            count = count + 1
        end
    end
    if count > 10 then
        return true
    end
    return false
end

local function detectMemoryTampering()
    local testTable = {a = 1, b = 2, c = 3}
    local testString = tostring(testTable)
    if not testString:match("table: 0x") then
        return true
    end
    local testType = type(testTable)
    if testType ~= "table" then
        return true
    end
    return false
end

local function detectExecutionTrace()
    local ok, result = pcall(function()
        return debug and debug.traceback and debug.traceback("", 1)
    end)
    if ok and result and #result > 500 then
        return true
    end
    return false
end

local function detectClosureTampering()
    local testFunc = function()
        return "test"
    end
    local ok, result = pcall(function()
        return debug and debug.getupvalue and debug.getupvalue(testFunc, 1)
    end)
    if ok and result then
        return true
    end
    return false
end

if not hasHookAPI() then
    selfDestruct()
    return
end

local testFunc = function() return "a" end
pcall(function()
    hookfunction(testFunc, function() return "b" end)
end)

if not isHooked(testFunc) then
    selfDestruct()
    return
end

pcall(restorefunction, testFunc)

local coreFuncs = {game.HttpGet, game.HttpPost, tostring, setclipboard, print, warn, error, pcall, xpcall, spawn, task.wait, task.spawn}
for _, f in ipairs(coreFuncs) do
    if isHooked(f) then
        selfDestruct()
        return
    end
end

local req = request or http_request or (syn and syn.request)
if req and isHooked(req) then
    selfDestruct()
    return
end

if detectDebugger() then
    selfDestruct()
    return
end

if detectEnvironment() then
    selfDestruct()
    return
end

if detectSuspiciousFolders() then
    selfDestruct()
    return
end

if detectSuspiciousFiles() then
    selfDestruct()
    return
end

if detectNetworkIntercept() then
    selfDestruct()
    return
end

if detectStackTrace() then
    selfDestruct()
    return
end

if detectMemoryTampering() then
    selfDestruct()
    return
end

if detectExecutionTrace() then
    selfDestruct()
    return
end

if detectClosureTampering() then
    selfDestruct()
    return
end

for _, name in pairs({"rconsoleprint", "rconsolewarn", "rconsoleinfo", "rconsoleerr", "rconsoletitle", "clonefunction", "getrenv", "getgenv", "getfenv", "setfenv", "getupvalue", "setupvalue", "getlocal", "setlocal", "getinfo", "getregistry", "getmetatable", "setmetatable"}) do
    pcall(function()
        getgenv()[name] = nil
    end)
end

local startTime = os.clock()
spawn(function()
    while task.wait(0.3) do
        if os.clock() - startTime > 30 then
            break
        end
        pcall(function()
            if isHooked(game.HttpGet) or isHooked(game.HttpPost) then
                selfDestruct()
            end
            local r = request or http_request
            if r and isHooked(r) then
                selfDestruct()
            end
            if isHooked(tostring) or isHooked(setclipboard) then
                selfDestruct()
            end
            if isfolder("HttpGetFolder") or isfolder("WebhookFolder") or isfolder("RequestFolder") or isfolder("HttpSpyFolder") then
                selfDestruct()
            end
            if isfile("HttpSpy.log") or isfile("packet.log") then
                selfDestruct()
            end
            if detectEnvironment() then
                selfDestruct()
            end
            if detectStackTrace() then
                selfDestruct()
            end
            if detectMemoryTampering() then
                selfDestruct()
            end
        end)
    end
end)
