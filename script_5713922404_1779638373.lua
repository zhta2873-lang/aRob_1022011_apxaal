local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local WallHackEnabled = false
local InvisibilityEnabled = false
local PlayerESPEnabled = false

local function WallHack()
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 1 then
            part.LocalTransparencyModifier = WallHackEnabled and 0.5 or 0
        end
    end
end

local function Invisibility()
    for _, part in pairs(Player.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.LocalTransparencyModifier = InvisibilityEnabled and 1 or 0
        end
    end
end

local function PlayerESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= Player then
            local character = player.Character
            if character then
                local head = character:FindFirstChild("Head")
                if head then
                    local line = head:FindFirstChild("ESPLine")
                    if not line then
                        line = Instance.new("LineHandleAdornment")
                        line.Name = "ESPLine"
                        line.Adornee = head
                        line.Length = 10
                        line.Thickness = 2
                        line.ZIndex = 10
                        line.Transparency = 0.5
                        line.Color3 = Color3.new(1, 0, 0)
                        line.Parent = head
                    end
                    line.Visible = PlayerESPEnabled
                end
            end
        end
    end
end

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H then
        WallHackEnabled = not WallHackEnabled
        WallHack()
    elseif input.KeyCode == Enum.KeyCode.I then
        InvisibilityEnabled = not InvisibilityEnabled
        Invisibility()
    elseif input.KeyCode == Enum.KeyCode.E then
        PlayerESPEnabled = not PlayerESPEnabled
        PlayerESP()
    end
end)

RunService.RenderStepped:Connect(function()
    if PlayerESPEnabled then
        PlayerESP()
    end
end)