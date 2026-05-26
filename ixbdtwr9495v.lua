-- Script for a Roblox NPC that follows players with an on/off button
local NPC = script.Parent
local Button = script.Parent:WaitForChild("Button") -- افترض وجود زر في النموذج
local Humanoid = NPC:WaitForChild("Humanoid")
local RootPart = NPC:WaitForChild("HumanoidRootPart")

local isActive = false
local targetPlayer = nil
local followDistance = 10

-- جعل النص بالعربية
Button.Text = "تشغيل/إطفاء البوت"

-- وظيفة اتباع اللاعب
local function followTarget()
    while isActive and targetPlayer and Humanoid.Health > 0 do
        local targetCharacter = targetPlayer.Character
        if targetCharacter then
            local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local distance = (RootPart.Position - targetRoot.Position).Magnitude
                if distance > followDistance then
                    Humanoid:MoveTo(targetRoot.Position)
                end
            end
        end
        wait(0.1)
    end
end

-- وظيفة البحث عن أقرب لاعب
local function findNearestPlayer()
    local players = game:GetService("Players"):GetPlayers()
    local closestDistance = math.huge
    local closestPlayer = nil
    
    for _, player in ipairs(players) do
        if player ~= targetPlayer and player.Character then
            local character = player.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                local distance = (RootPart.Position - humanoidRootPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer
end

-- تفعيل/إلغاء تفعيل البوت
Button.MouseButton1Click:Connect(function()
    isActive = not isActive
    
    if isActive then
        targetPlayer = findNearestPlayer()
        if targetPlayer then
            followTarget()
        end
    else
        Humanoid:MoveTo(RootPart.Position) -- يتوقف عن الحركة
    end
end)

-- إعادة تعيين الهدف عند مغادرة اللاعب
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == targetPlayer then
        targetPlayer = findNearestPlayer()
    end
end)

-- متابعة اللاعبين الجدد
game:GetService("Players").PlayerAdded:Connect(function(player)
    if not targetPlayer then
        targetPlayer = player
        if isActive then
            followTarget()
        end
    end
end)