-- Script for a Roblox part that displays a message when touched
local part = script.Parent

local function onTouch(otherPart)
    local humanoid = otherPart.Parent:FindFirstChild("Humanoid")
    if humanoid then
        local message = Instance.new("Message")
        message.Text = "انا احبك"
        message.Parent = workspace
        wait(2)
        message:Destroy()
    end
end

part.Touched:Connect(onTouch)

-- Alternative version using TextLabel on a ScreenGui
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.Text = "انا احبك"
textLabel.TextSize = 50
textLabel.TextColor3 = Color3.new(1, 0, 0)
textLabel.BackgroundTransparency = 1
textLabel.Parent = gui

-- Simple chat command version
game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        if message:lower() == "احبك" then
            game:GetService("Chat"):Chat(player.Character.Head, "انا احبك ايضا", Enum.ChatColor.Red)
        end
    end)
end)

اختر أي من هذه السكربتات التي تناسب احتياجاتك في Roblox. الأول يعمل عند لمس جزء، الثاني يعرض نصًا على الشاشة، والثالث يستجيب لأمر في الدردشة.