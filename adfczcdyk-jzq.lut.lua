
---...




local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

local SCRIPT_URL = "https://raw.githubusercontent.com/czcasdfwdk/dyk-jzq-czc/main/dykjzqjzq2-czc.lua"

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LoaderGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

local container = Instance.new("Frame")
container.Size = UDim2.new(0, 400, 0, 30)
container.Position = UDim2.new(0.5, -200, 0, 20)
container.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
container.BackgroundTransparency = 0.3
container.BorderSizePixel = 0
container.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = container

local progressBg = Instance.new("Frame")
progressBg.Size = UDim2.new(0.96, 0, 0.6, 0)
progressBg.Position = UDim2.new(0.02, 0, 0.2, 0)
progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
progressBg.BackgroundTransparency = 0.5
progressBg.BorderSizePixel = 0
progressBg.Parent = container

local progressBgCorner = Instance.new("UICorner")
progressBgCorner.CornerRadius = UDim.new(0, 10)
progressBgCorner.Parent = progressBg

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundTransparency = 0
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBg

local progressFillCorner = Instance.new("UICorner")
progressFillCorner.CornerRadius = UDim.new(0, 10)
progressFillCorner.Parent = progressFill

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 0))
})
gradient.Rotation = 90
gradient.Parent = progressFill

local function updateProgress(progress)
    local percent = math.floor(progress * 100)
    progressFill.Size = UDim2.new(progress, 0, 1, 0)
end

local function loadScriptWithProgress(url)
    updateProgress(0.1)
    task.wait(0.05)
    updateProgress(0.3)
    task.wait(0.05)
    
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    
    updateProgress(0.7)
    task.wait(0.05)
    
    if success and response and #response > 10 then
        local func, err = loadstring(response)
        updateProgress(0.9)
        task.wait(0.05)
        
        if func then
            updateProgress(1)
            task.wait(0.2)
            
            local scaleDown = TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0)
            })
            scaleDown:Play()
            task.wait(0.3)
            screenGui:Destroy()
            pcall(func)
            return true
        end
    end
    
    progressFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    gradient.Enabled = false
    return false
end

task.spawn(function()
    task.wait(0.3)
    loadScriptWithProgress(SCRIPT_URL)
end)
