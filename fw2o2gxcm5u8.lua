local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local flying = false
local flySpeed = 50

local function fly()
    if not flying then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    rootPart.Velocity = Vector3.new(0, flySpeed, 0)
    rootPart.AssemblyLinearVelocity = Vector3.new(0, flySpeed, 0)
    
    game:GetService("RunService").Heartbeat:Wait()
    fly()
end

local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Text = "طيران"
flyButton.Size = UDim2.new(0, 100, 0, 50)
flyButton.Position = UDim2.new(0.5, -50, 0.8, 0)
flyButton.Parent = player.PlayerGui:WaitForChild("CoreGui")

local stopButton = Instance.new("TextButton")
stopButton.Name = "StopButton"
stopButton.Text = "إيقاف"
stopButton.Size = UDim2.new(0, 100, 0, 50)
stopButton.Position = UDim2.new(0.5, -50, 0.9, 0)
stopButton.Parent = player.PlayerGui:WaitForChild("CoreGui")

flyButton.MouseButton1Click:Connect(function()
    flying = true
    humanoid.PlatformStand = true
    fly()
end)

stopButton.MouseButton1Click:Connect(function()
    flying = false
    humanoid.PlatformStand = false
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.Velocity = Vector3.new(0, 0, 0)
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
end)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
end)