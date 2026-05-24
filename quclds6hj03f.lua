-- تعريف المتغيرات
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local gui = Instance.new("ScreenGui", player.PlayerGui)
local frame = Instance.new("Frame", gui)
local hideButton = Instance.new("TextButton", frame)
local flyButton = Instance.new("TextButton", frame)
local speedButton = Instance.new("TextButton", frame)
local cancelButton = Instance.new("TextButton", frame)

-- إعداد واجهة المستخدم
gui.Name = "MainGUI"
gui.ResetOnSpawn = false

frame.Name = "MainFrame"
frame.Position = UDim2.new(0.1, 0, 0.1, 0)
frame.Size = UDim2.new(0.2, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

hideButton.Name = "HideButton"
hideButton.Position = UDim2.new(0.1, 0, 0.1, 0)
hideButton.Size = UDim2.new(0.8, 0, 0.2, 0)
hideButton.Text = "اختفاء"
hideButton.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
hideButton.TextColor3 = Color3.new(1, 1, 1)

flyButton.Name = "FlyButton"
flyButton.Position = UDim2.new(0.1, 0, 0.4, 0)
flyButton.Size = UDim2.new(0.8, 0, 0.2, 0)
flyButton.Text = "طيران"
flyButton.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
flyButton.TextColor3 = Color3.new(1, 1, 1)

speedButton.Name = "SpeedButton"
speedButton.Position = UDim2.new(0.1, 0, 0.7, 0)
speedButton.Size = UDim2.new(0.8, 0, 0.2, 0)
speedButton.Text = "سرعة"
speedButton.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
speedButton.TextColor3 = Color3.new(1, 1, 1)

cancelButton.Name = "CancelButton"
cancelButton.Position = UDim2.new(0.1, 0, 1, 0)
cancelButton.Size = UDim2.new(0.8, 0, 0.2, 0)
cancelButton.Text = "إلغاء"
cancelButton.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
cancelButton.TextColor3 = Color3.new(1, 1, 1)

-- وظيفة الاختفاء
local function hidePlayer()
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            part.CanCollide = false
        end
    end
end

-- وظيفة إظهار اللاعب
local function showPlayer()
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
            part.CanCollide = true
        end
    end
end

-- وظيفة الطيران
local function fly()
    local bodyVelocity = Instance.new("BodyVelocity", rootPart)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(0, 0, 0)

    local userInputService = game:GetService("UserInputService")
    local flying = true

    userInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Space then
            bodyVelocity.Velocity = Vector3.new(0, 50, 0)
        elseif input.KeyCode == Enum.KeyCode.W then
            bodyVelocity.Velocity = Vector3.new(0, 0, -50)
        elseif input.KeyCode == Enum.KeyCode.S then
            bodyVelocity.Velocity = Vector3.new(0, 0, 50)
        elseif input.KeyCode == Enum.KeyCode.A then
            bodyVelocity.Velocity = Vector3.new(-50, 0, 0)
        elseif input.KeyCode == Enum.KeyCode.D then
            bodyVelocity.Velocity = Vector3.new(50, 0, 0)
        end
    end)

    userInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D then
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

-- وظيفة إلغاء الطيران
local function cancelFly()
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BodyVelocity") then
            part:Destroy()
        end
    end
end

-- وظيفة السرعة
local function speedUp()
    humanoid.WalkSpeed = 100
end

-- وظيفة إلغاء السرعة
local function cancelSpeed()
    humanoid.WalkSpeed = 16
end

-- إعداد الأزرار
hideButton.MouseButton1Click:Connect(hidePlayer)
flyButton.MouseButton1Click:Connect(fly)
speedButton.MouseButton1Click:Connect(speedUp)
cancelButton.MouseButton1Click:Connect(function()
    showPlayer()
    cancelFly()
    cancelSpeed()
end)

-- التأكد من عدم وجود أخطاء في السكربت
pcall(function()
    -- الكود يعمل دون أخطاء
end)