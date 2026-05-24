local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Torso = Character:WaitForChild("Torso")
local Noclip = false
local CanNoclip = true

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.5, -100, 0, 10)
Frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Text = "Noclip Script"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Title.Parent = Frame

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 20)
Status.Position = UDim2.new(0, 0, 0, 30)
Status.Text = "Status: Off"
Status.TextColor3 = Color3.new(1, 1, 1)
Status.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Status.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, 0, 0, 20)
ToggleButton.Position = UDim2.new(0, 0, 0, 60)
ToggleButton.Text = "Toggle Noclip (X)"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
ToggleButton.Parent = Frame

local function EnableNoclip()
    Noclip = true
    Status.Text = "Status: On"
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function DisableNoclip()
    Noclip = false
    Status.Text = "Status: Off"
    for _, part in pairs(Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    if CanNoclip then
        if Noclip then
            DisableNoclip()
        else
            EnableNoclip()
        end
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        if CanNoclip then
            if Noclip then
                DisableNoclip()
            else
                EnableNoclip()
            end
        end
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if Noclip and Humanoid and Torso then
        Humanoid:ChangeState(11)
    end
end)

local AntiDetection = Instance.new("Folder", Character)
AntiDetection.Name = "AntiDetection"

local FakeScript = Instance.new("Script", AntiDetection)
FakeScript.Name = "NoclipScript"
FakeScript.Disabled = true

local FakeLocalScript = Instance.new("LocalScript", AntiDetection)
FakeLocalScript.Name = "NoclipLocalScript"
FakeLocalScript.Disabled = true

local FakeModuleScript = Instance.new("ModuleScript", AntiDetection)
FakeModuleScript.Name = "NoclipModule"
FakeModuleScript.Disabled = true

local function AntiCheatProtection()
    while true do
        if CanNoclip then
            local success, message = pcall(function()
                -- Simulate anti-cheat detection
                if not Noclip then
                    error("Anti-Cheat Detected")
                end
            end)
            if not success then
                CanNoclip = false
                DisableNoclip()
                Status.Text = "Status: Detected"
                Frame.BackgroundColor3 = Color3.new(1, 0, 0)
                Title.Text = "Noclip Script (Detected)"
                ToggleButton.Text = "Disabled"
                ToggleButton.BackgroundColor3 = Color3.new(1, 0, 0)
                break
            end
        end
        wait(1)
    end
end

spawn(AntiCheatProtection)