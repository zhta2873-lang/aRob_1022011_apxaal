-- Script for Freeze Fruit in Roblox
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local freezeCooldown = false
local freezeDuration = 5

local function freezeTarget(target)
    if target and target:FindFirstChild("Humanoid") and target:FindFirstChild("HumanoidRootPart") then
        local humanoid = target.Humanoid
        local rootPart = target.HumanoidRootPart
        
        -- Freeze effect
        local icePart = Instance.new("Part")
        icePart.Size = Vector3.new(4, 4, 4)
        icePart.Transparency = 0.5
        icePart.BrickColor = BrickColor.new("Light blue")
        icePart.Material = Enum.Material.Ice
        icePart.Anchored = true
        icePart.CanCollide = false
        icePart.CFrame = rootPart.CFrame
        icePart.Parent = workspace
        
        -- Freeze the target
        humanoid.WalkSpeed = 0
        humanoid.JumpPower = 0
        
        -- Add ice effect to target
        local iceAttachment = Instance.new("Attachment", rootPart)
        local iceParticle = Instance.new("ParticleEmitter", iceAttachment)
        iceParticle.Texture = "rbxassetid://243664672"
        iceParticle.LightEmission = 1
        iceParticle.Color = ColorSequence.new(Color3.fromRGB(150, 150, 255))
        iceParticle.Size = NumberSequence.new(0.5)
        iceParticle.Acceleration = Vector3.new(0, -5, 0)
        iceParticle.Lifetime = NumberRange.new(1)
        iceParticle.Speed = NumberRange.new(2)
        iceParticle.EmissionDirection = Enum.NormalId.Top
        iceParticle.Rate = 50
        
        Debris:AddItem(icePart, freezeDuration)
        Debris:AddItem(iceAttachment, freezeDuration)
        
        -- Unfreeze after duration
        wait(freezeDuration)
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end
end

local function onActivate()
    if freezeCooldown then return end
    freezeCooldown = true
    
    -- Find nearest player
    local nearestPlayer = nil
    local shortestDistance = 30
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if otherRoot then
                local distance = (rootPart.Position - otherRoot.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPlayer = otherPlayer.Character
                end
            end
        end
    end
    
    if nearestPlayer then
        freezeTarget(nearestPlayer)
    end
    
    -- Cooldown
    wait(10)
    freezeCooldown = false
end

-- Bind to key press (change "R" to desired key)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.R then
        onActivate()
    end
end)