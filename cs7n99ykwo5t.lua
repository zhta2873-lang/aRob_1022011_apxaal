هذا هو سكربت Lua كامل لـ Roblox:

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local function onJump()
    print(player.Name .. " قام بالقفز!")
end

humanoid.Jumping:Connect(onJump)

local part = Instance.new("Part")
part.Parent = workspace
part.Size = Vector3.new(4, 1, 4)
part.Position = Vector3.new(0, 10, 0)
part.Anchored = true
part.BrickColor = BrickColor.new("Bright blue")

local clickDetector = Instance.new("ClickDetector")
clickDetector.Parent = part

local function onPartClicked(playerWhoClicked)
    part.BrickColor = BrickColor.random()
    print(playerWhoClicked.Name .. " قام بالنقر على الجزء!")
end

clickDetector.MouseClick:Connect(onPartClicked)

player.Chatted:Connect(function(message)
    if message:lower() == "hello" then
        print("مرحباً " .. player.Name .. "!")
    end
end)