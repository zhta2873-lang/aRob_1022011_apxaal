-- Script for Roblox - Imposter Button with Arabic labels
local button = script.Parent

local function onButtonClick(playerWhoClicked)
    -- Check if the player is the impostor (you can modify this condition)
    if playerWhoClicked.Team.Name == "Impostor" then
        -- Turn off all lights in the game
        local lighting = game:GetService("Lighting")
        lighting.Ambient = Color3.new(0, 0, 0)
        lighting.Brightness = 0
        lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        
        -- Turn off all lights in workspaces
        for _, light in ipairs(workspace:GetDescendants()) do
            if light:IsA("Light") then
                light.Enabled = false
            end
        end
        
        -- Display message in Arabic
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "تم تشغيل الزر",
            Text = "تم إطفاء الأنوار من قبل المحتال!",
            Duration = 5
        })
    else
        -- Display message for non-impostors in Arabic
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "خطأ",
            Text = "فقط المحتال يمكنه استخدام هذا الزر!",
            Duration = 5
        })
    end
end

button.Activated:Connect(onButtonClick)

-- Arabic button labels
button.SurfaceGui.TextLabel.Text = "زر المحتال"
button.SurfaceGui.TextLabel.TextScaled = true