local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local flying = false
local flySpeed = 50

local function fly()
    flying = true
    humanoid.PlatformStand = true
    while flying and humanoid and humanoid.Parent do
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            local vel = root.Velocity
            vel = Vector3.new(vel.X, flySpeed, vel.Z)
            root.Velocity = vel
        end
        game:GetService("RunService").Heartbeat:Wait()
    end
    humanoid.PlatformStand = false
end

local function stopFlying()
    flying = false
    humanoid.PlatformStand = false
end

local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Text = "طيران (F)"
flyButton.Size = UDim2.new(0, 100, 0, 50)
flyButton.Position = UDim2.new(0, 10, 0.5, -25)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
flyButton.Parent = player.PlayerGui:WaitForChild("CoreGui")

local stopButton = Instance.new("TextButton")
stopButton.Name = "StopButton"
stopButton.Text = "إيقاف (S)"
stopButton.Size = UDim2.new(0, 100, 0, 50)
stopButton.Position = UDim2.new(0, 120, 0.5, -25)
stopButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
stopButton.Parent = player.PlayerGui:WaitForChild("CoreGui")

flyButton.MouseButton1Click:Connect(fly)
stopButton.MouseButton1Click:Connect(stopFlying)

local function onInput(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.F and not gameProcessed then
        fly()
    elseif input.KeyCode == Enum.KeyCode.S and not gameProcessed then
        stopFlying()
    end
end

game:GetService("UserInputService").InputBegan:Connect(onInput)

character:WaitForChild("Humanoid").Died:Connect(function()
    flying = false
    flyButton:Destroy()
    stopButton:Destroy()
end)