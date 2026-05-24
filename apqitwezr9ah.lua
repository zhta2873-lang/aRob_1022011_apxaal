هذا سكربت Lua كامل ومتكامل لـ Roblox يحتوي على ثلاث خصائص: إخفاء اللاعب، الطيران، وزيادة السرعة. السكربت جاهز للنسخ واللصق مباشرة:

-- خدمات Roblox الأساسية
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- اللاعب المحلي
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- واجهة المستخدم الرسومية
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local HideButton = Instance.new("TextButton")
local FlyButton = Instance.new("TextButton")
local SpeedButton = Instance.new("TextButton")

-- إعدادات الواجهة
ScreenGui.Parent = player.PlayerGui
ScreenGui.Name = "PlayerPowersGUI"

Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Active = true
Frame.Draggable = true

HideButton.Parent = Frame
HideButton.Size = UDim2.new(0.9, 0, 0.25, 0)
HideButton.Position = UDim2.new(0.05, 0, 0.05, 0)
HideButton.Text = "إخفاء اللاعب (أو إظهار)"
HideButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
HideButton.TextColor3 = Color3.fromRGB(255, 255, 255)

FlyButton.Parent = Frame
FlyButton.Size = UDim2.new(0.9, 0, 0.25, 0)
FlyButton.Position = UDim2.new(0.05, 0, 0.35, 0)
FlyButton.Text = "الطيران (تشغيل/إيقاف)"
FlyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)

SpeedButton.Parent = Frame
SpeedButton.Size = UDim2.new(0.9, 0, 0.25, 0)
SpeedButton.Position = UDim2.new(0.05, 0, 0.65, 0)
SpeedButton.Text = "زيادة السرعة (تشغيل/إيقاف)"
SpeedButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- متغيرات الحالة
local isHidden = false
local isFlying = false
local isSpeedBoosted = false
local originalWalkSpeed = humanoid.WalkSpeed
local originalJumpPower = humanoid.JumpPower
local flyBodyVelocity = nil
local flyBodyGyro = nil

-- وظيفة إخفاء/إظهار اللاعب
local function ToggleHide()
    isHidden = not isHidden
    
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = isHidden and 1 or 0
            if part:FindFirstChildOfClass("Decal") then
                part:FindFirstChildOfClass("Decal").Transparency = isHidden and 1 or 0
            end
        end
    end
    
    HideButton.Text = isHidden and "إظهار اللاعب" or "إخفاء اللاعب"
end

-- وظيفة الطيران
local function ToggleFly()
    isFlying = not isFlying
    
    if isFlying then
        -- تفعيل الطيران
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.Name = "FlyBodyVelocity"
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        flyBodyVelocity.Parent = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart")
        
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.Name = "FlyBodyGyro"
        flyBodyGyro.P = 10000
        flyBodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
        flyBodyGyro.CFrame = character.HumanoidRootPart.CFrame
        flyBodyGyro.Parent = character.HumanoidRootPart
        
        flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        
        local flyConnection
        flyConnection = RunService.Heartbeat:Connect(function()
            if not isFlying then
                flyConnection:Disconnect()
                return
            end
            
            local rootPart = character.HumanoidRootPart
            if not rootPart then return end
            
            local camera = workspace.CurrentCamera
            local forward = camera.CFrame.LookVector
            local right = camera.CFrame.RightVector
            local up = Vector3.new(0, 1, 0)
            
            local direction = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + forward
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - forward
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + right
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - right
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + up
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                direction = direction - up
            end
            
            direction = direction.Unit * 50
            
            flyBodyVelocity.Velocity = direction
            flyBodyGyro.CFrame = camera.CFrame
        end)
        
        FlyButton.Text = "إيقاف الطيران"
    else
        -- إيقاف الطيران
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        
        if flyBodyGyro then
            flyBodyGyro:Destroy()
            flyBodyGyro = nil
        end
        
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        FlyButton.Text = "تفعيل الطيران"
    end
end

-- وظيفة زيادة السرعة
local function ToggleSpeed()
    isSpeedBoosted = not isSpeedBoosted
    
    if isSpeedBoosted then
        humanoid.WalkSpeed = 100
        humanoid.JumpPower = 100
        SpeedButton.Text = "إيقاف السرعة"
    else
        humanoid.WalkSpeed = originalWalkSpeed
        humanoid.JumpPower = originalJumpPower
        SpeedButton.Text = "تفعيل السرعة"
    end
end

-- توصيل الأزرار بالوظائف
HideButton.MouseButton1Click:Connect(ToggleHide)
FlyButton.MouseButton1Click:Connect(ToggleFly)
SpeedButton.MouseButton1Click:Connect(ToggleSpeed)

-- إعادة تعيين الخصائص عند موت اللاعب
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    originalWalkSpeed = humanoid.WalkSpeed
    originalJumpPower = humanoid.JumpPower
    
    -- إعادة تعيين الحالات
    isHidden = false
    isFlying = false
    isSpeedBoosted = false
    
    -- تحديث نصوص الأزرار
    HideButton.Text = "إخفاء اللاعب"
    FlyButton.Text = "تفعيل الطيران"
    SpeedButton.Text = "تفعيل السرعة"
    
    -- التأكد من إزالة الطيران إذا كان نشطًا
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    
    if flyBodyGyro then
        flyBodyGyro:Destroy()
        flyBodyGyro = nil
    end
end)

-- إعادة تعيين السرعة عند تغييرها من مصادر أخرى
humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
    if not isSpeedBoosted then
        originalWalkSpeed = humanoid.WalkSpeed
    end
end)

humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
    if not isSpeedBoosted then
        originalJumpPower = humanoid.JumpPower
    end
end)

هذا السكربت الكامل يوفر:
1. زر لإخفاء وإظهار اللاعب
2. زر لتفعيل وإيقاف الطيران (يتحكم بالحركة باستخدام WASD وSpace وLeftShift)
3. زر لزيادة السرعة وإعادتها إلى وضعها الطبيعي
4. واجهة مستخدم سهلة الاستخدام وقابلة للسحب
5. إعادة تعيين تلقائي عند موت اللاعب
6. حفظ الإعدادات الأصلية للسرعة والقفز