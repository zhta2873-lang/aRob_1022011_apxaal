-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "Hack Menu by جمال"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 24
Title.Parent = MainFrame

local WallHackButton = Instance.new("TextButton")
WallHackButton.Size = UDim2.new(0, 250, 0, 40)
WallHackButton.Position = UDim2.new(0.08, 0, 0.2, 0)
WallHackButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
WallHackButton.Text = "Wall Hack"
WallHackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
WallHackButton.Font = Enum.Font.SourceSansBold
WallHackButton.TextSize = 20
WallHackButton.Parent = MainFrame

local SpeedButton = Instance.new("TextButton")
SpeedButton.Size = UDim2.new(0, 250, 0, 40)
SpeedButton.Position = UDim2.new(0.08, 0, 0.35, 0)
SpeedButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
SpeedButton.Text = "Speed Boost"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.Font = Enum.Font.SourceSansBold
SpeedButton.TextSize = 20
SpeedButton.Parent = MainFrame

local InvisibilityButton = Instance.new("TextButton")
InvisibilityButton.Size = UDim2.new(0, 250, 0, 40)
InVisibilityButton.Position = UDim2.new(0.08, 0, 0.5, 0)
InvisibilityButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
InvisibilityButton.Text = "Invisibility"
InvisibilityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
InvisibilityButton.Font = Enum.Font.SourceSansBold
InvisibilityButton.TextSize = 20
InvisibilityButton.Parent = MainFrame

local DisableAllButton = Instance.new("TextButton")
DisableAllButton.Size = UDim2.new(0, 250, 0, 40)
DisableAllButton.Position = UDim2.new(0.08, 0, 0.65, 0)
DisableAllButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
DisableAllButton.Text = "Disable All"
DisableAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DisableAllButton.Font = Enum.Font.SourceSansBold
DisableAllButton.TextSize = 20
DisableAllButton.Parent = MainFrame

local ToggleGUIButton = Instance.new("TextButton")
ToggleGUIButton.Size = UDim2.new(0, 250, 0, 40)
ToggleGUIButton.Position = UDim2.new(0.08, 0, 0.8, 0)
ToggleGUIButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
ToggleGUIButton.Text = "Toggle GUI"
ToggleGUIButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleGUIButton.Font = Enum.Font.SourceSansBold
ToggleGUIButton.TextSize = 20
ToggleGUIButton.Parent = MainFrame

local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 60, 0, 60)
Logo.Position = UDim2.new(0.17, 0, 0.88, 0)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://YOUR_IMAGE_ID"
Logo.Parent = MainFrame

-- Variables
local WallHackEnabled = false
local SpeedEnabled = false
local InvisibilityEnabled = false
local GUIEnabled = true

-- Wall Hack Function
WallHackButton.MouseButton1Click:Connect(function()
    WallHackEnabled = not WallHackEnabled
    if WallHackEnabled then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "BasePlate" then
                part.LocalTransparencyModifier = 0.5
            end
        end
    else
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "BasePlate" then
                part.LocalTransparencyModifier = 0
            end
        end
    end
end)

-- Speed Boost Function
SpeedButton.MouseButton1Click:Connect(function()
    SpeedEnabled = not SpeedEnabled
    if SpeedEnabled then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Invisibility Function
InvisibilityButton.MouseButton1Click:Connect(function()
    InvisibilityEnabled = not InvisibilityEnabled
    if InvisibilityEnabled then
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 1
            end
        end
    else
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
end)

-- Disable All Function
DisableAllButton.MouseButton1Click:Connect(function()
    WallHackEnabled = false
    SpeedEnabled = false
    InvisibilityEnabled = false
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "BasePlate" then
            part.LocalTransparencyModifier = 0
        end
    end
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.LocalTransparencyModifier = 0
        end
    end
end)

-- Toggle GUI Function
ToggleGUIButton.MouseButton1Click:Connect(function()
    GUIEnabled = not GUIEnabled
    MainFrame.Visible = GUIEnabled
end)

-- Credits
local Credits = Instance.new("TextLabel")
Credits.Size = UDim2.new(0, 300, 0, 20)
Credits.Position = UDim2.new(0, 0, 0.93, 0)
Credits.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Credits.Text = "Made by جمال"
Credits.TextColor3 = Color3.fromRGB(255, 255, 255)
Credits.Font = Enum.Font.SourceSansBold
Credits.TextSize = 18
Credits.Parent = MainFrame