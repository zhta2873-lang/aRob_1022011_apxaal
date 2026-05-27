"`lua
-- RedFox Fly Script for Roblox
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local UserInputService = game:GetService("UserInputService")

local flying = false
local flySpeed = 50
local keysPressed = {}

-- Toggle flight on/off
local function toggleFlight()
    flying = not flying
    
    if flying then
        -- Create body velocity for flight
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyBV"
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = Character:FindFirstChild("HumanoidRootPart")
        
        -- Create gyro for control
        local bg = Instance.new("BodyGyro")
        bg.Name = "FlyBG"
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 10000
        bg.D = 100
        bg.Parent = Character:FindFirstChild("HumanoidRootPart")
    else
        -- Remove flight parts
        if Character:FindFirstChild("HumanoidRootPart") then
            local bv = Character.HumanoidRootPart:FindFirstChild("FlyBV")
            local bg = Character.HumanoidRootPart:FindFirstChild("FlyBG")
            
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
    end
end

-- Handle key presses
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        toggleFlight()
    end
    
    if flying then
        keysPressed[input.KeyCode] = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    keysPressed[input.KeyCode] = nil
end)

-- Flight movement
game:GetService("RunService").Heartbeat:Connect(function()
    if flying and Character:FindFirstChild("HumanoidRootPart") then
        local root = Character.HumanoidRootPart
        local bv = root:FindFirstChild("FlyBV")
        local bg = root:FindFirstChild("FlyBG")
        
        if bv and bg then
            -- Get camera direction
            local cam = workspace.CurrentCamera
            local camCF = cam.CFrame
            local direction = Vector3.new()
            
            -- Movement directions
            if keysPressed[Enum.KeyCode.W] then
                direction = direction + (camCF.LookVector * flySpeed)
            end
            if keysPressed[Enum.KeyCode.S] then
                direction = direction - (camCF.LookVector * flySpeed)
            end
            if keysPressed[Enum.KeyCode.A] then
                direction = direction - (camCF.RightVector * flySpeed)
            end
            if keysPressed[Enum.KeyCode.D] then
                direction = direction + (camCF.RightVector * flySpeed)
            end
            if keysPressed[Enum.KeyCode.Space] then
                direction = direction + Vector3.new(0, flySpeed, 0)
            end
            if keysPressed[Enum.KeyCode.LeftShift] then
                direction = direction + Vector3.new(0, -flySpeed, 0)
            end
            
            -- Apply movement
            bv.Velocity = direction
            
            -- Apply rotation
            bg.CFrame = camCF
        end
    end
end)

-- Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "RedFox Fly",
    Text = "Press F to toggle flight mode",
    Duration = 5
})
"`