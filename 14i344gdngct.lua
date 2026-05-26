# Lua Script for Roblox Flight Script with GUI (F to Toggle, H to Hide)

-- Flight Script with GUI
local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlightGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 50)
frame.Position = UDim2.new(0.5, -100, 0.1, 0)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 0
frame.Parent = screenGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.Text = "Flight: OFF (Press F)"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.BackgroundTransparency = 1
label.Font = Enum.Font.SourceSansBold
label.TextSize = 18
label.Parent = frame

-- Flight Variables
local flying = false
local flySpeed = 50
local flyDebounce = false

-- Hide Function
local function hideCharacter()
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
        elseif part:IsA("Accessory") then
            part.Handle.Transparency = 1
        end
    end
end

-- Show Function
local function showCharacter()
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = 0
        elseif part:IsA("Accessory") then
            part.Handle.Transparency = 0
        end
    end
end

-- Flight Function
local function toggleFlight()
    if flyDebounce then return end
    flyDebounce = true
    
    flying = not flying
    
    if flying then
        label.Text = "Flight: ON (Press F)"
        humanoid.PlatformStand = true
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.P = 10000
        bodyVelocity.Name = "FlightVelocity"
        bodyVelocity.Parent = humanoidRootPart
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.P = 10000
        bodyGyro.D = 500
        bodyGyro.Name = "FlightGyro"
        bodyGyro.Parent = humanoidRootPart
        
        humanoid:ChangeState(Enum.HumanoidStateType.Flying)
    else
        label.Text = "Flight: OFF (Press F)"
        humanoid.PlatformStand = false
        
        local velocity = humanoidRootPart:FindFirstChild("FlightVelocity")
        if velocity then velocity:Destroy() end
        
        local gyro = humanoidRootPart:FindFirstChild("FlightGyro")
        if gyro then gyro:Destroy() end
        
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
    
    wait(0.2)
    flyDebounce = false
end

-- Input Handling
local userInputService = game:GetService("UserInputService")
local hideDebounce = false

userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        toggleFlight()
    elseif input.KeyCode == Enum.KeyCode.H then
        if hideDebounce then return end
        hideDebounce = true
        
        if character:FindFirstChildOfClass("Humanoid").RootPart.Transparency == 0 then
            hideCharacter()
        else
            showCharacter()
        end
        
        wait(0.5)
        hideDebounce = false
    end
end)

-- Flight Control
game:GetService("RunService").Stepped:Connect(function()
    if flying and humanoidRootPart:FindFirstChild("FlightVelocity") then
        local camera = workspace.CurrentCamera
        local rootCFrame = humanoidRootPart.CFrame
        
        -- Get movement direction from camera
        local forward = camera.CFrame.LookVector
        local right = camera.CFrame.RightVector
        local up = Vector3.new(0, 1, 0)
        
        local direction = Vector3.new(0, 0, 0)
        
        if userInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + forward
        end
        if userInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - forward
        end
        if userInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - right
        end
        if userInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + right
        end
        if userInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + up
        end
        if userInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            direction = direction - up
        end
        
        -- Normalize direction if moving in any direction
        if direction.Magnitude > 0 then
            direction = direction.Unit * flySpeed
        end
        
        -- Apply movement
        humanoidRootPart.FlightVelocity.Velocity = direction
        humanoidRootPart.FlightGyro.CFrame = camera.CFrame
    end
end)

-- Clean up on character reset
character:WaitForChild("Humanoid").Died:Connect(function()
    flying = false
    screenGui:Destroy()
end)