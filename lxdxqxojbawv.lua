-- Script for Flight Toggle in Roblox

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local flying = false
local flightSpeed = 50

-- Function to enable flight
local function enableFlight()
    flying = true
    humanoid.PlatformStand = true
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    bodyVelocity.P = 1000
    bodyVelocity.Name = "FlightVelocity"
    bodyVelocity.Parent = character:FindFirstChild("HumanoidRootPart")
    
    while flying and character and character:FindFirstChild("HumanoidRootPart") do
        local rootPart = character.HumanoidRootPart
        local camera = workspace.CurrentCamera
        
        -- Get movement direction from input
        local forward = camera.CFrame.LookVector
        local right = camera.CFrame.RightVector
        local up = Vector3.new(0, 1, 0)
        
        local direction = Vector3.new(0, 0, 0)
        
        if player:GetFocusedTextBox() == nil then
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                direction = direction + forward
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                direction = direction - forward
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                direction = direction + right
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                direction = direction - right
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + up
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                direction = direction - up
            end
        end
        
        -- Normalize and apply speed
        if direction.Magnitude > 0 then
            direction = direction.Unit * flightSpeed
        end
        
        -- Apply velocity
        if rootPart:FindFirstChild("FlightVelocity") then
            rootPart.FlightVelocity.Velocity = direction
        end
        
        game:GetService("RunService").Heartbeat:Wait()
    end
    
    -- Clean up when flight is disabled
    if character and character:FindFirstChild("HumanoidRootPart") then
        local rootPart = character.HumanoidRootPart
        if rootPart:FindFirstChild("FlightVelocity") then
            rootPart.FlightVelocity:Destroy()
        end
        humanoid.PlatformStand = false
    end
end

-- Function to disable flight
local function disableFlight()
    flying = false
    if character and character:FindFirstChild("HumanoidRootPart") then
        local rootPart = character.HumanoidRootPart
        if rootPart:FindFirstChild("FlightVelocity") then
            rootPart.FlightVelocity:Destroy()
        end
        humanoid.PlatformStand = false
    end
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local flightButton = Instance.new("TextButton")
flightButton.Name = "FlightButton"
flightButton.Size = UDim2.new(0, 100, 0, 50)
flightButton.Position = UDim2.new(0.8, 0, 0.7, 0)
flightButton.Text = "Flight ON"
flightButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
flightButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flightButton.Font = Enum.Font.SourceSansBold
flightButton.TextSize = 18
flightButton.Parent = screenGui

-- Toggle flight on button click
flightButton.MouseButton1Click:Connect(function()
    if not flying then
        enableFlight()
        flightButton.Text = "Flight OFF"
        flightButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    else
        disableFlight()
        flightButton.Text = "Flight ON"
        flightButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    end
end)

-- Disable flight when character dies
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    disableFlight()
    flightButton.Text = "Flight ON"
    flightButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
end)