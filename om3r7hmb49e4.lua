local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local enabled = false

local function moveToTarget(target)
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid and target then
        humanoid:MoveTo(target.Position)
    end
end

local function onButtonClick()
    enabled = not enabled
    if enabled then
        print("تم تشغيل الايمبوت")
    else
        print("تم اطفاء الايمبوت")
    end
end

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 120, 0, 40)
button.Position = UDim2.new(0.5, -60, 0.5, -20)
button.Text = "تشغيل/اطفاء الايمبوت"
button.Parent = player.PlayerGui:WaitForChild("ScreenGui")

button.MouseButton1Click:Connect(onButtonClick)

mouse.Button1Down:Connect(function()
    if enabled and mouse.Target then
        moveToTarget(mouse.Target)
    end
end)