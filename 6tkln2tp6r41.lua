local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local ImpulsePart = Instance.new("Part")
ImpulsePart.Size = Vector3.new(10, 1, 10)
ImpulsePart.Position = Vector3.new(0, 5, 0)
ImpulsePart.Anchored = true
ImpulsePart.Transparency = 1
ImpulsePart.CanCollide = false
ImpulsePart.Parent = Workspace

local ImpulseForce = Instance.new("BodyVelocity")
ImpulseForce.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
ImpulseForce.Velocity = Vector3.new(0, 100, 0)
ImpulseForce.Parent = ImpulsePart

local ImpulseActive = false

local function ApplyImpulse()
    for _, player in pairs(Players:GetPlayers()) do
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local rootPart = character.HumanoidRootPart
            rootPart.Velocity = Vector3.new(0, 100, 0)
        end
    end
end

local function ToggleImpulse()
    ImpulseActive = not ImpulseActive
    if ImpulseActive then
        ApplyImpulse()
    end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 200, 0, 50)
Button.Position = UDim2.new(0.5, -100, 0.5, -25)
Button.Text = "Toggle Impulse"
Button.Parent = ScreenGui

Button.MouseButton1Click:Connect(ToggleImpulse)