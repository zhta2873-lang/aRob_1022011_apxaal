-- تعريف المتغيرات
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- إنشاء واجهة المستخدم
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "ControlPanel"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0.2, 0, 0.3, 0)
frame.Position = UDim2.new(0.05, 0, 0.05, 0)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Text = "لوحة التحكم"
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14

local hideButton = Instance.new("TextButton", frame)
hideButton.Text = "اختفاء اللاعب"
hideButton.Size = UDim2.new(0.8, 0, 0.2, 0)
hideButton.Position = UDim2.new(0.1, 0, 0.15, 0)
hideButton.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
hideButton.TextColor3 = Color3.new(1, 1, 1)
hideButton.Font = Enum.Font.SourceSansBold
hideButton.TextSize = 14

local flyButton = Instance.new("TextButton", frame)
flyButton.Text = "الطيران"
flyButton.Size = UDim2.new(0.8, 0, 0.2, 0)
flyButton.Position = UDim2.new(0.1, 0, 0.4, 0)
flyButton.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.Font = Enum.Font.SourceSansBold
flyButton.TextSize = 14

local speedButton = Instance.new("TextButton", frame)
speedButton.Text = "زيادة السرعة"
speedButton.Size = UDim2.new(0.8, 0, 0.2, 0)
speedButton.Position = UDim2.new(0.1, 0, 0.65, 0)
speedButton.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
speedButton.TextColor3 = Color3.new(1, 1, 1)
speedButton.Font = Enum.Font.SourceSansBold
speedButton.TextSize = 14

-- متغيرات التحكم
local isHidden = false
local isFlying = false
local isSpeedBoosted = false

-- وظيفة الاختفاء
hideButton.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    if isHidden then
        character.HumanoidRootPart.Transparency = 1
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
        hideButton.Text = "إظهار اللاعب"
    else
        character.HumanoidRootPart.Transparency = 0
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
        hideButton.Text = "اختفاء اللاعب"
    end
end)

-- وظيفة الطيران
flyButton.MouseButton1Click:Connect(function()
    isFlying = not isFlying
    if isFlying then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        flyButton.Text = "إيقاف الطيران"
    else
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        flyButton.Text = "الطيران"
    end
end)

-- وظيفة زيادة السرعة
speedButton.MouseButton1Click:Connect(function()
    isSpeedBoosted = not isSpeedBoosted
    if isSpeedBoosted then
        humanoid.WalkSpeed = 50
        speedButton.Text = "إلغاء السرعة"
    else
        humanoid.WalkSpeed = 16
        speedButton.Text = "زيادة السرعة"
    end
end)

-- تحديث الطيران
runService.Heartbeat:Connect(function()
    if isFlying then
        local moveDirection = Vector3.new(0, 0, 0)
        if userInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + Vector3.new(0, 0, -1)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection + Vector3.new(0, 0, 1)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection + Vector3.new(-1, 0, 0)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + Vector3.new(1, 0, 0)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection + Vector3.new(0, -1, 0)
        end
        rootPart.Velocity = moveDirection.Unit * 50
    end
end)

-- تعطيل الطيران عند الموت
humanoid.Died:Connect(function()
    isFlying = false
    flyButton.Text = "الطيران"
end)

-- تعطيل جميع الميزات عند ترك اللعبة
player:GetPropertyChangedSignal("Character"):Connect(function()
    isHidden = false
    isFlying = false
    isSpeedBoosted = false
    hideButton.Text = "اختفاء اللاعب"
    flyButton.Text = "الطيران"
    speedButton.Text = "زيادة السرعة"
end)