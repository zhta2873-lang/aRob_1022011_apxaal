--[[
    Teleport Saver Pro - Professional Save & Teleport System
    Version: 1.0.0
    Compatible: PC, Mobile, Tablet
    Features: Draggable Logo, Smooth Teleport, Modern GUI
--]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Variables
local SavedPosition = nil
local GUI = nil
local Logo = nil
local isDragging = false
local dragStart = nil
local dragStartPos = nil

-- Settings
local GUI_SIZE = UDim2.new(0, 380, 0, 480)
local LOGO_SIZE = UDim2.new(0, 55, 0, 55)
local BLUR_AMOUNT = 10

-- Sound IDs (optional, remove if not wanted)
local SOUNDS = {
    Click = "rbxassetid://9120387311",
    Save = "rbxassetid://9120385191",
    Teleport = "rbxassetid://9120389631"
}

-- Notification System
local function ShowNotification(Title, Message, Duration)
    local Notif = Instance.new("ScreenGui")
    Notif.Name = "Notification"
    Notif.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Notif.Parent = Player.PlayerGui
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 320, 0, 75)
    Frame.Position = UDim2.new(0.5, -160, 0, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.BackgroundTransparency = 0.15
    Frame.BorderSizePixel = 0
    Frame.ClipsDescendants = true
    Frame.Parent = Notif
    
    -- Corner
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Frame
    
    -- Gradient
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
    }
    Gradient.Parent = Frame
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 30)
    TitleLabel.Position = UDim2.new(0, 10, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothomBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Frame
    
    -- Message
    local MsgLabel = Instance.new("TextLabel")
    MsgLabel.Size = UDim2.new(1, -20, 0, 30)
    MsgLabel.Position = UDim2.new(0, 10, 0, 38)
    MsgLabel.BackgroundTransparency = 1
    MsgLabel.Text = Message
    MsgLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    MsgLabel.TextSize = 13
    MsgLabel.Font = Enum.Font.Gotham
    MsgLabel.TextXAlignment = Enum.TextXAlignment.Left
    MsgLabel.Parent = Frame
    
    -- Icon Line
    local IconLine = Instance.new("Frame")
    IconLine.Size = UDim2.new(0, 4, 1, -10)
    IconLine.Position = UDim2.new(0, 0, 0, 5)
    IconLine.BackgroundColor3 = Title == "✓ Success" and Color3.fromRGB(76, 175, 80) 
        or Title == "⚠ Warning" and Color3.fromRGB(255, 193, 7)
        or Color3.fromRGB(33, 150, 243)
    IconLine.BorderSizePixel = 0
    IconLine.Parent = Frame
    
    -- Animation
    local TweenIn = TweenService:Create(Frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -160, 0, 20)
    })
    TweenIn:Play()
    
    -- Auto remove
    task.wait(Duration or 3)
    local TweenOut = TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -160, 0, -100)
    })
    TweenOut:Play()
    TweenOut.Completed:Connect(function()
        Notif:Destroy()
    end)
end

-- Play Sound
local function PlaySound(SoundId)
    if not SoundId then return end
    local Sound = Instance.new("Sound")
    Sound.SoundId = SoundId
    Sound.Volume = 0.5
    Sound.Parent = game:GetService("SoundService")
    Sound:Play()
    task.delay(2, function() Sound:Destroy() end)
end

-- Create GUI
local function CreateGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TeleportSaverPro"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = Player.PlayerGui
    
    -- Main Blur Background
    local BlurBg = Instance.new("Frame")
    BlurBg.Size = UDim2.new(1, 0, 1, 0)
    BlurBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BlurBg.BackgroundTransparency = 0.65
    BlurBg.BorderSizePixel = 0
    BlurBg.Visible = false
    BlurBg.Parent = ScreenGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = GUI_SIZE
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -240)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BackgroundTransparency = 0.08
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui
    
    -- Corner Radius
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 20)
    Corner.Parent = MainFrame
    
    -- Blur Effect
    local Blur = Instance.new("BlurEffect")
    Blur.Size = BLUR_AMOUNT
    Blur.Parent = MainFrame
    
    -- Shadow
    local Shadow = Instance.new("Frame")
    Shadow.Size = UDim2.new(1, 0, 1, 0)
    Shadow.Position = UDim2.new(0, 0, 0, 0)
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 0.85
    Shadow.BorderSizePixel = 0
    Shadow.ZIndex = -1
    Shadow.Parent = MainFrame
    
    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(0, 20)
    ShadowCorner.Parent = Shadow
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 70)
    Header.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Header.BackgroundTransparency = 0.1
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 20)
    HeaderCorner.Parent = Header
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "✨ Teleport Saver Pro"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 22
    Title.Font = Enum.Font.GothomBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    -- Subtitle
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Size = UDim2.new(1, -60, 0, 25)
    Subtitle.Position = UDim2.new(0, 20, 0, 42)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Text = "Save your position anywhere"
    Subtitle.TextColor3 = Color3.fromRGB(150, 150, 155)
    Subtitle.TextSize = 12
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = Header
    
    -- Close Button (X)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 40, 0, 40)
    CloseBtn.Position = UDim2.new(1, -50, 0, 15)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    CloseBtn.BackgroundTransparency = 0.5
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 20
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 12)
    CloseCorner.Parent = CloseBtn
    
    -- Divider Line
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(0.9, 0, 0, 1)
    Divider.Position = UDim2.new(0.05, 0, 0, 70)
    Divider.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    Divider.BorderSizePixel = 0
    Divider.Parent = MainFrame
    
    -- Content Frame
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -40, 1, -110)
    Content.Position = UDim2.new(0, 20, 0, 85)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame
    
    -- Save Button (Red)
    local SaveBtn = Instance.new("TextButton")
    SaveBtn.Size = UDim2.new(0, 320, 0, 75)
    SaveBtn.Position = UDim2.new(0.5, -160, 0, 0)
    SaveBtn.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
    SaveBtn.BackgroundTransparency = 0.15
    SaveBtn.BorderSizePixel = 0
    SaveBtn.Text = ""
    SaveBtn.Parent = Content
    
    local SaveCorner = Instance.new("UICorner")
    SaveCorner.CornerRadius = UDim.new(0, 16)
    SaveCorner.Parent = SaveBtn
    
    local SaveIcon = Instance.new("TextLabel")
    SaveIcon.Size = UDim2.new(0, 40, 1, 0)
    SaveIcon.Position = UDim2.new(0, 15, 0, 0)
    SaveIcon.BackgroundTransparency = 1
    SaveIcon.Text = "💾"
    SaveIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    SaveIcon.TextSize = 28
    SaveIcon.Font = Enum.Font.GothamBold
    SaveIcon.Parent = SaveBtn
    
    local SaveTitle = Instance.new("TextLabel")
    SaveTitle.Size = UDim2.new(1, -70, 0, 30)
    SaveTitle.Position = UDim2.new(0, 65, 0, 15)
    SaveTitle.BackgroundTransparency = 1
    SaveTitle.Text = "Save Position"
    SaveTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SaveTitle.TextSize = 18
    SaveTitle.Font = Enum.Font.GothomBold
    SaveTitle.TextXAlignment = Enum.TextXAlignment.Left
    SaveTitle.Parent = SaveBtn
    
    local SaveDesc = Instance.new("TextLabel")
    SaveDesc.Size = UDim2.new(1, -70, 0, 20)
    SaveDesc.Position = UDim2.new(0, 65, 0, 45)
    SaveDesc.BackgroundTransparency = 1
    SaveDesc.Text = "Store your current location"
    SaveDesc.TextColor3 = Color3.fromRGB(255, 200, 200)
    SaveDesc.TextSize = 12
    SaveDesc.Font = Enum.Font.Gotham
    SaveDesc.TextXAlignment = Enum.TextXAlignment.Left
    SaveDesc.Parent = SaveBtn
    
    -- Teleport Button (Green)
    local TeleportBtn = Instance.new("TextButton")
    TeleportBtn.Size = UDim2.new(0, 320, 0, 75)
    TeleportBtn.Position = UDim2.new(0.5, -160, 0, 95)
    TeleportBtn.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
    TeleportBtn.BackgroundTransparency = 0.15
    TeleportBtn.BorderSizePixel = 0
    TeleportBtn.Text = ""
    TeleportBtn.Parent = Content
    
    local TeleportCorner = Instance.new("UICorner")
    TeleportCorner.CornerRadius = UDim.new(0, 16)
    TeleportCorner.Parent = TeleportBtn
    
    local TeleportIcon = Instance.new("TextLabel")
    TeleportIcon.Size = UDim2.new(0, 40, 1, 0)
    TeleportIcon.Position = UDim2.new(0, 15, 0, 0)
    TeleportIcon.BackgroundTransparency = 1
    TeleportIcon.Text = "🚀"
    TeleportIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportIcon.TextSize = 28
    TeleportIcon.Font = Enum.Font.GothamBold
    TeleportIcon.Parent = TeleportBtn
    
    local TeleportTitle = Instance.new("TextLabel")
    TeleportTitle.Size = UDim2.new(1, -70, 0, 30)
    TeleportTitle.Position = UDim2.new(0, 65, 0, 15)
    TeleportTitle.BackgroundTransparency = 1
    TeleportTitle.Text = "Teleport Back"
    TeleportTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportTitle.TextSize = 18
    TeleportTitle.Font = Enum.Font.GothomBold
    TeleportTitle.TextXAlignment = Enum.TextXAlignment.Left
    TeleportTitle.Parent = TeleportBtn
    
    local TeleportDesc = Instance.new("TextLabel")
    TeleportDesc.Size = UDim2.new(1, -70, 0, 20)
    TeleportDesc.Position = UDim2.new(0, 65, 0, 45)
    TeleportDesc.BackgroundTransparency = 1
    TeleportDesc.Text = "Return to saved location"
    TeleportDesc.TextColor3 = Color3.fromRGB(200, 255, 200)
    TeleportDesc.TextSize = 12
    TeleportDesc.Font = Enum.Font.Gotham
    TeleportDesc.TextXAlignment = Enum.TextXAlignment.Left
    TeleportDesc.Parent = TeleportBtn
    
    -- Clear Button (Blue)
    local ClearBtn = Instance.new("TextButton")
    ClearBtn.Size = UDim2.new(0, 320, 0, 75)
    ClearBtn.Position = UDim2.new(0.5, -160, 0, 190)
    ClearBtn.BackgroundColor3 = Color3.fromRGB(0, 123, 255)
    ClearBtn.BackgroundTransparency = 0.15
    ClearBtn.BorderSizePixel = 0
    ClearBtn.Text = ""
    ClearBtn.Parent = Content
    
    local ClearCorner = Instance.new("UICorner")
    ClearCorner.CornerRadius = UDim.new(0, 16)
    ClearCorner.Parent = ClearBtn
    
    local ClearIcon = Instance.new("TextLabel")
    ClearIcon.Size = UDim2.new(0, 40, 1, 0)
    ClearIcon.Position = UDim2.new(0, 15, 0, 0)
    ClearIcon.BackgroundTransparency = 1
    ClearIcon.Text = "🗑️"
    ClearIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    ClearIcon.TextSize = 28
    ClearIcon.Font = Enum.Font.GothamBold
    ClearIcon.Parent = ClearBtn
    
    local ClearTitle = Instance.new("TextLabel")
    ClearTitle.Size = UDim2.new(1, -70, 0, 30)
    ClearTitle.Position = UDim2.new(0, 65, 0, 15)
    ClearTitle.BackgroundTransparency = 1
    ClearTitle.Text = "Clear Position"
    ClearTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ClearTitle.TextSize = 18
    ClearTitle.Font = Enum.Font.GothomBold
    ClearTitle.TextXAlignment = Enum.TextXAlignment.Left
    ClearTitle.Parent = ClearBtn
    
    local ClearDesc = Instance.new("TextLabel")
    ClearDesc.Size = UDim2.new(1, -70, 0, 20)
    ClearDesc.Position = UDim2.new(0, 65, 0, 45)
    ClearDesc.BackgroundTransparency = 1
    ClearDesc.Text = "Delete saved position"
    ClearDesc.TextColor3 = Color3.fromRGB(200, 200, 255)
    ClearDesc.TextSize = 12
    ClearDesc.Font = Enum.Font.Gotham
    ClearDesc.TextXAlignment = Enum.TextXAlignment.Left
    ClearDesc.Parent = ClearBtn
    
    -- Footer
    local Footer = Instance.new("Frame")
    Footer.Size = UDim2.new(1, 0, 0, 40)
    Footer.Position = UDim2.new(0, 0, 1, -40)
    Footer.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Footer.BackgroundTransparency = 0.1
    Footer.BorderSizePixel = 0
    Footer.Parent = MainFrame
    
    local FooterCorner = Instance.new("UICorner")
    FooterCorner.CornerRadius = UDim.new(0, 20)
    FooterCorner.Parent = Footer
    
    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 1, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "● No position saved"
    StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 155)
    StatusLabel.TextSize = 11
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = Footer
    
    return ScreenGui, MainFrame, BlurBg, StatusLabel, SaveBtn, TeleportBtn, ClearBtn, CloseBtn
end

-- Create Draggable Logo
local function CreateLogo()
    local LogoGui = Instance.new("ScreenGui")
    LogoGui.Name = "TeleportSaverLogo"
    LogoGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    LogoGui.Parent = Player.PlayerGui
    
    local LogoBtn = Instance.new("ImageButton")
    LogoBtn.Size = LOGO_SIZE
    LogoBtn.Position = UDim2.new(0, 20, 0.9, -30)
    LogoBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    LogoBtn.BackgroundTransparency = 0.1
    LogoBtn.BorderSizePixel = 0
    LogoBtn.Image = "rbxassetid://3926305904" -- Default logo, replace with your own
    LogoBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)
    LogoBtn.ScaleType = Enum.ScaleType.Fit
    LogoBtn.Parent = LogoGui
    
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(1, 0)
    LogoCorner.Parent = LogoBtn
    
    -- Shadow
    local LogoShadow = Instance.new("Frame")
    LogoShadow.Size = UDim2.new(1, 8, 1, 8)
    LogoShadow.Position = UDim2.new(0, -4, 0, -4)
    LogoShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    LogoShadow.BackgroundTransparency = 0.7
    LogoShadow.BorderSizePixel = 0
    LogoShadow.ZIndex = -1
    LogoShadow.Parent = LogoBtn
    
    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(1, 0)
    ShadowCorner.Parent = LogoShadow
    
    -- Inner content
    local LogoText = Instance.new("TextLabel")
    LogoText.Size = UDim2.new(1, 0, 1, 0)
    LogoText.BackgroundTransparency = 1
    LogoText.Text = "📍"
    LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogoText.TextSize = 28
    LogoText.Font = Enum.Font.GothamBold
    LogoText.Parent = LogoBtn
    
    return LogoGui, LogoBtn
end

-- Make object draggable (Mobile & PC)
local function MakeDraggable(Object, ParentGui)
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
    local function Update(input)
        local delta = input.Position - dragStart
        local newX = startPos.X.Offset + delta.X
        local newY = startPos.Y.Offset + delta.Y
        
        -- Keep within screen bounds
        local maxX = ParentGui.AbsoluteSize.X - Object.AbsoluteSize.X
        local maxY = ParentGui.AbsoluteSize.Y - Object.AbsoluteSize.Y
        
        newX = math.clamp(newX, 0, maxX)
        newY = math.clamp(newY, 0, maxY)
        
        Object.Position = UDim2.new(0, newX, 0, newY)
    end
    
    Object.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Object.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            Update(input)
        end
    end)
end

-- Main Execution
local success, err = pcall(function()
    -- Create GUI elements
    local ScreenGui, MainFrame, BlurBg, StatusLabel, SaveBtn, TeleportBtn, ClearBtn, CloseBtn = CreateGUI()
    local LogoGui, LogoBtn = CreateLogo()
    
    -- Make logo draggable
    MakeDraggable(LogoBtn, LogoGui)
    
    -- Update status function
    local function UpdateStatus()
        if SavedPosition then
            local pos = SavedPosition.Position
            StatusLabel.Text = string.format("✓ Saved at: %.0f, %.0f, %.0f", pos.X, pos.Y, pos.Z)
            StatusLabel.TextColor3 = Color3.fromRGB(76, 175, 80)
        else
            StatusLabel.Text = "● No position saved"
            StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 155)
        end
    end
    
    -- Animation functions
    local function AnimateButton(Button)
        local OriginalSize = Button.Size
        local TweenIn = TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(OriginalSize.X.Scale, OriginalSize.X.Offset, OriginalSize.Y.Scale, OriginalSize.Y.Offset + 5)
        })
        local TweenOut = TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = OriginalSize
        })
        TweenIn:Play()
        task.wait(0.1)
        TweenOut:Play()
    end
    
    -- Show GUI function
    local function ShowGUI()
        BlurBg.Visible = true
        MainFrame.Visible = true
        LogoBtn.Visible = false
        
        local TweenShow = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0.5, -190, 0.5, -240)
        })
        TweenShow:Play()
        
        local BlurTween = TweenService:Create(BlurBg, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.65
        })
        BlurTween:Play()
    end
    
    -- Hide GUI function
    local function HideGUI()
        local TweenHide = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -190, 0.5, -200)
        })
        TweenHide:Play()
        
        local BlurTween = TweenService:Create(BlurBg, TweenInfo.new(0.2), {
            BackgroundTransparency = 1
        })
        BlurTween:Play()
        
        task.wait(0.2)
        BlurBg.Visible = false
        MainFrame.Visible = false
        LogoBtn.Visible = true
    end
    
    -- Save Position
    SaveBtn.MouseButton1Click:Connect(function()
        AnimateButton(SaveBtn)
        PlaySound(SOUNDS.Save)
        
        local character = Player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            SavedPosition = character.HumanoidRootPart.CFrame
            UpdateStatus()
            ShowNotification("✓ Success", "Position saved successfully!", 2)
        else
            ShowNotification("⚠ Error", "Could not find character", 2)
        end
    end)
    
    -- Teleport Back
    TeleportBtn.MouseButton1Click:Connect(function()
        AnimateButton(TeleportBtn)
        
        if SavedPosition then
            local character = Player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                -- Smooth teleport using tween to avoid detection
                local hrp = character.HumanoidRootPart
                local TweenTeleport = TweenService:Create(hrp, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    CFrame = SavedPosition
                })
                TweenTeleport:Play()
                PlaySound(SOUNDS.Teleport)
                ShowNotification("✓ Success", "Teleported to saved position!", 2)
            else
                ShowNotification("⚠ Error", "Character not found", 2)
            end
        else
            ShowNotification("⚠ Warning", "No saved position found!", 2)
        end
    end)
    
    -- Clear Position
    ClearBtn.MouseButton1Click:Connect(function()
        AnimateButton(ClearBtn)
        PlaySound(SOUNDS.Click)
        
        SavedPosition = nil
        UpdateStatus()
        ShowNotification("✓ Success", "Saved position cleared!", 2)
    end)
    
    -- Close Button
    CloseBtn.MouseButton1Click:Connect(function()
        PlaySound(SOUNDS.Click)
        HideGUI()
    end)
    
    -- Logo Button (Show GUI)
    LogoBtn.MouseButton1Click:Connect(function()
        PlaySound(SOUNDS.Click)
        ShowGUI()
    end)
    
    -- Touch support for mobile
    for _, btn in pairs({SaveBtn, TeleportBtn, ClearBtn, CloseBtn, LogoBtn}) do
        btn.TouchTap:Connect(function()
            btn.MouseButton1Click:Fire()
        end)
    end
    
    -- Initial status update
    UpdateStatus()
    
    -- Auto show GUI on first load
    task.wait(0.5)
    ShowGUI()
    
    -- Clean up on player leave
    Player.CharacterAdded:Connect(function()
        -- Don't auto teleport, just keep position saved
        UpdateStatus()
    end)
end)

if not success then
    warn("Error loading Teleport Saver Pro: ", err)
end