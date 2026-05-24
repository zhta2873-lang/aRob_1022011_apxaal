local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundTransparency = 0.5
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.Parent = gui

local button1 = Instance.new("TextButton")
button1.Size = UDim2.new(0.8, 0, 0.2, 0)
button1.Position = UDim2.new(0.1, 0, 0.1, 0)
button1.Text = "اختفاء"
button1.Parent = frame

local button2 = Instance.new("TextButton")
button2.Size = UDim2.new(0.8, 0, 0.2, 0)
button2.Position = UDim2.new(0.1, 0, 0.4, 0)
button2.Text = "طيران"
button2.Parent = frame

local button3 = Instance.new("TextButton")
button3.Size = UDim2.new(0.8, 0, 0.2, 0)
button3.Position = UDim2.new(0.1, 0, 0.7, 0)
button3.Text = "سرعة"
button3.Parent = frame

local flying = false
local speed = false
local originalWalkspeed = humanoid.WalkSpeed

button1.MouseButton1Click:Connect(function()
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = part.Transparency == 1 and 0 or 1
        end
    end
end)

button2.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        humanoid:ChangeState(Enum.HumanoidStateType.Flying)
    else
        humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    end
end)

button3.MouseButton1Click:Connect(function()
    speed = not speed
    if speed then
        humanoid.WalkSpeed = 100
    else
        humanoid.WalkSpeed = originalWalkspeed
    end
end)