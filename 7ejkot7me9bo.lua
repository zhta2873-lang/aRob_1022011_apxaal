-- Starter Player Scripts
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local function onCharacterAdded(newCharacter)
    character = newCharacter
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid.Died:Connect(function()
        print("Player died!")
    end)
end

player.CharacterAdded:Connect(onCharacterAdded)

-- Example tool functionality
local tool = Instance.new("Tool")
tool.Name = "ExampleTool"
tool.RequiresHandle = false
tool.Parent = player.Backpack

tool.Activated:Connect(function()
    print("Tool activated!")
    local part = Instance.new("Part")
    part.Size = Vector3.new(1, 1, 1)
    part.Position = character.HumanoidRootPart.Position + character.HumanoidRootPart.CFrame.LookVector * 5
    part.Anchored = true
    part.Parent = workspace
    task.wait(3)
    part:Destroy()
end)

-- Remote event example
local remoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")

remoteEvent.OnClientEvent:Connect(function(message)
    print("Received message from server:", message)
end)

-- Basic GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local textButton = Instance.new("TextButton")
textButton.Size = UDim2.new(0, 200, 0, 50)
textButton.Position = UDim2.new(0.5, -100, 0.5, -25)
textButton.Text = "Click Me!"
textButton.Parent = screenGui

textButton.MouseButton1Click:Connect(function()
    print("Button clicked!")
    remoteEvent:FireServer("Button pressed by " .. player.Name)
end)