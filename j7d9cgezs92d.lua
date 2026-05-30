local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local function attack()
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://YOUR_ATTACK_ANIMATION_ID"
    local track = humanoid:LoadAnimation(anim)
    track:Play()
    -- Add damage logic here
end

local function useSkill(skillId)
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. skillId
    local track = humanoid:LoadAnimation(anim)
    track:Play()
    -- Add skill effect logic here
end

local function levelUp()
    humanoid.MaxHealth = humanoid.MaxHealth + 10
    humanoid.Health = humanoid.MaxHealth
    -- Add other level up logic here
end

local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.E then
        attack()
    elseif input.KeyCode == Enum.KeyCode.R then
        useSkill("YOUR_SKILL_ANIMATION_ID")
    elseif input.KeyCode == Enum.KeyCode.U then
        levelUp()
    end
end

game:GetService("UserInputService").InputBegan:Connect(onInputBegan)