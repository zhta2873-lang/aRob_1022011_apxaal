# سكربت Roblox كامل لنظام حركة اللاعب مع قدرات خاصة

سأقدم لك سكربت متكامل لنظام حركة متقدم للاعب في Roblox مع إضافة قدرات خاصة مثل القفز المزدوج والاندفاع والانزلاق. السكربت كامل وجاهز للاستخدام مباشرة.

--[[
    نظام حركة متقدم للاعب في Roblox
    المميزات:
    1. حركة أساسية (مشي، جري، قفز)
    2. قفز مزدوج
    3. اندفاع (Dash) في اتجاه الحركة
    4. انزلاق على الأسطح المائلة
    5. تأثيرات بصرية للقدرات
    6. إدارة الستامينا (طاقة اللاعب)
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- إنشاء مجلد للقيم إذا لم يكن موجودًا
local function setupPlayerValues(player)
    local folder = player:FindFirstChild("PlayerValues")
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "PlayerValues"
        folder.Parent = player
        
        -- قيم اللاعب
        local stamina = Instance.new("NumberValue")
        stamina.Name = "Stamina"
        stamina.Value = 100
        stamina.Parent = folder
        
        local maxStamina = Instance.new("NumberValue")
        maxStamina.Name = "MaxStamina"
        maxStamina.Value = 100
        maxStamina.Parent = folder
        
        local canDoubleJump = Instance.new("BoolValue")
        canDoubleJump.Name = "CanDoubleJump"
        canDoubleJump.Value = true
        canDoubleJump.Parent = folder
        
        local isDashing = Instance.new("BoolValue")
        isDashing.Name = "IsDashing"
        isDashing.Value = false
        isDashing.Parent = folder
        
        local isSliding = Instance.new("BoolValue")
        isSliding.Name = "IsSliding"
        isSliding.Value = false
        isSliding.Parent = folder
    end
end

-- تأثيرات بصرية للاندفاع
local function createDashEffects(character)
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- تأثير الجسيمات
    local particles = Instance.new("ParticleEmitter")
    particles.Texture = "rbxassetid://243098098"
    particles.LightEmission = 1
    particles.Color = ColorSequence.new(Color3.fromRGB(0, 162, 255))
    particles.Size = NumberSequence.new(0.5)
    particles.Lifetime = NumberRange.new(0.5)
    particles.Rate = 50
    particles.Speed = NumberRange.new(5)
    particles.Parent = humanoidRootPart
    
    -- توهج
    local glow = Instance.new("SurfaceGui")
    glow.Face = Enum.NormalId.Front
    glow.Parent = humanoidRootPart
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    frame.BackgroundTransparency = 0.7
    frame.Parent = glow
    
    game.Debris:AddItem(particles, 0.5)
    game.Debris:AddItem(glow, 0.5)
end

-- نظام الحركة الأساسي
local function setupCharacterMovement(character, player)
    local humanoid = character:WaitForChild("Humanoid")
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- إعدادات الحركة
    local walkSpeed = 16
    local runSpeed = 24
    local jumpPower = 50
    
    humanoid.WalkSpeed = walkSpeed
    humanoid.JumpPower = jumpPower
    
    -- متغيرات الحركة
    local isRunning = false
    local hasDoubleJumped = false
    local dashCooldown = false
    local slideCooldown = false
    
    -- اتصالات الأحداث
    local connections = {}
    
    -- تحديث الستامينا
    local function updateStamina()
        local stamina = player.PlayerValues.Stamina
        local maxStamina = player.PlayerValues.MaxStamina
        
        if isRunning and humanoid.MoveDirection.Magnitude > 0 then
            stamina.Value = math.max(0, stamina.Value - 0.5)
        else
            stamina.Value = math.min(maxStamina.Value, stamina.Value + 0.3)
        end
        
        -- تعديل سرعة الجري بناء على الستامينا
        if stamina.Value <= 0 then
            humanoid.WalkSpeed = walkSpeed
            isRunning = false
        end
    end
    
    -- التحقق من وجود أرض تحت اللاعب
    local function isOnGround()
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {character}
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        
        local raycastResult = workspace:Raycast(
            humanoidRootPart.Position,
            Vector3.new(0, -3, 0),
            raycastParams
        )
        
        return raycastResult ~= nil
    end
    
    -- القفز المزدوج
    local function doubleJump()
        if player.PlayerValues.CanDoubleJump.Value and not isOnGround() and not hasDoubleJumped then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            humanoidRootPart.Velocity = Vector3.new(
                humanoidRootPart.Velocity.X,
                humanoid.JumpPower,
                humanoidRootPart.Velocity.Z
            )
            hasDoubleJumped = true
            
            -- تأثير بسيط للقفز المزدوج
            local effect = Instance.new("Part")
            effect.Size = Vector3.new(2, 0.2, 2)
            effect.Anchored = true
            effect.CanCollide = false
            effect.Transparency = 0.5
            effect.Color = Color3.fromRGB(255, 255, 0)
            effect.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -2, 0)
            effect.Parent = workspace
            game.Debris:AddItem(effect, 0.5)
        end
    end
    
    -- الاندفاع
    local function dash()
        if dashCooldown or player.PlayerValues.Stamina.Value < 20 then return end
        
        dashCooldown = true
        player.PlayerValues.IsDashing.Value = true
        player.PlayerValues.Stamina.Value = player.PlayerValues.Stamina.Value - 20
        
        local dashDirection = humanoid.MoveDirection
        if dashDirection.Magnitude == 0 then
            dashDirection = humanoidRootPart.CFrame.LookVector
        end
        
        -- تطبيق قوة الاندفاع
        humanoidRootPart.Velocity = dashDirection * 100 + Vector3.new(0, 10, 0)
        createDashEffects(character)
        
        -- إعادة تعيين حالة الاندفاع بعد 0.3 ثانية
        task.delay(0.3, function()
            player.PlayerValues.IsDashing.Value = false
        end)
        
        -- إعادة تعيين وقت التبريد بعد 1 ثانية
        task.delay(1, function()
            dashCooldown = false
        end)
    end
    
    -- الانزلاق
    local function slide()
        if slideCooldown or not isOnGround() or player.PlayerValues.Stamina.Value < 15 then return end
        
        slideCooldown = true
        player.PlayerValues.IsSliding.Value = true
        player.PlayerValues.Stamina.Value = player.PlayerValues.Stamina.Value - 15
        
        local slideDirection = humanoid.MoveDirection
        if slideDirection.Magnitude == 0 then
            slideDirection = humanoidRootPart.CFrame.LookVector
        end
        
        -- تغيير وضعية اللاعب للانزلاق
        humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
        
        -- تطبيق قوة الانزلاق
        humanoidRootPart.Velocity = slideDirection * 50 + Vector3.new(0, -5, 0)
        
        -- تأثير الانزلاق
        local slideEffect = Instance.new("Part")
        slideEffect.Size = Vector3.new(2, 0.1, 2)
        slideEffect.Anchored = true
        slideEffect.CanCollide = false
        slideEffect.Transparency = 0.7
        slideEffect.Color = Color3.fromRGB(255, 165, 0)
        slideEffect.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -2, 0)
        slideEffect.Parent = workspace
        game.Debris:AddItem(slideEffect, 0.5)
        
        -- إعادة تعيين حالة الانزلاق بعد 0.5 ثانية
        task.delay(0.5, function()
            player.PlayerValues.IsSliding.Value = false
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end)
        
        -- إعادة تعيين وقت التبريد بعد 1.5 ثانية
        task.delay(1.5, function()
            slideCooldown = false
        end)
    end
    
    -- معالجة مدخلات اللاعب
    local function handleInput(input, gameProcessed)
        if gameProcessed then return end
        
        -- الجري (Shift)
        if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.UserInputState == Enum.UserInputState.Begin then
                    if player.PlayerValues.Stamina.Value > 0 then
                        isRunning = true
                        humanoid.WalkSpeed = runSpeed
                    end
                elseif input.UserInputState == Enum.UserInputState.End then
                    isRunning = false
                    humanoid.WalkSpeed = walkSpeed
                end
            end
        end
        
        -- القفز المزدوج (مسافة)
        if input.KeyCode == Enum.KeyCode.Space then
            if input.UserInputState == Enum.UserInputState.Begin then
                doubleJump()
            end
        end
        
        -- الاندفاع (E)
        if input.KeyCode == Enum.KeyCode.E then
            if input.UserInputState == Enum.UserInputState.Begin then
                dash()
            end
        end
        
        -- الانزلاق (Q)
        if input.KeyCode == Enum.KeyCode.Q then
            if input.UserInputState == Enum.UserInputState.Begin then
                slide()
            end
        end
    end
    
    -- إعادة تعيين القفز المزدوج عند لمس الأرض
    local function onStateChanged(oldState, newState)
        if newState == Enum.HumanoidStateType.Landed then
            hasDoubleJumped = false
        end
    end
    
    -- إعداد الاتصالات
    table.insert(connections, UserInputService.InputBegan:Connect(handleInput))
    table.insert(connections, UserInputService.InputEnded:Connect(handleInput))
    table.insert(connections, humanoid.StateChanged:Connect(onStateChanged))
    
    -- تحديث الحركة في كل إطار
    local heartbeatConnection
    heartbeatConnection = RunService.Heartbeat:Connect(function(dt)
        updateStamina()
        
        -- إلغاء الجاذبية أثناء الانزلاق
        if player.PlayerValues.IsSliding.Value then
            humanoidRootPart.Velocity = Vector3.new(
                humanoidRootPart.Velocity.X,
                math.max(-10, humanoidRootPart.Velocity.Y),
                humanoidRootPart.Velocity.Z
            )
        end
    end)
    table.insert(connections, heartbeatConnection)
    
    -- تنظيف الاتصالات عند موت اللاعب
    local function onCharacterRemoving()
        for _, connection in ipairs(connections) do
            connection:Disconnect()
        end
        heartbeatConnection:Disconnect()
    end
    
    character.AncestryChanged:Connect(function(_, parent)
        if not parent then
            onCharacterRemoving()
        end
    end)
end

-- معالجة دخول اللاعب
local function onPlayerAdded(player)
    setupPlayerValues(player)
    
    player.CharacterAdded:Connect(function(character)
        setupCharacterMovement(character, player)
    end)
    
    if player.Character then
        setupCharacterMovement(player.Character, player)
    end
end

-- معالجة خروج اللاعب
local function onPlayerRemoving(player)
    -- أي تنظيف إضافي يمكن إضافته هنا
end

-- إعداد اتصالات اللاعبين
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- معالجة اللاعبين الموجودين بالفعل
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

-- إنشاء واجهة مستخدم بسيطة لعرض الستامينا
local function createStaminaUI(player)
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "StaminaUI"
    screenGui.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.2, 0, 0.03, 0)
    frame.Position = UDim2.new(0.4, 0, 0.95, 0)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(20, 20, 20)
    frame.Parent = screenGui
    
    local staminaBar = Instance.new("Frame")
    staminaBar.Name = "StaminaBar"
    staminaBar.Size = UDim2.new(1, 0, 1, 0)
    staminaBar.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    staminaBar.BorderSizePixel = 0
    staminaBar.Parent = frame
    
    local staminaText = Instance.new("TextLabel")
    staminaText.Size = UDim2.new(1, 0, 1, 0)
    staminaText.BackgroundTransparency = 1
    staminaText.Text = "STAMINA"
    staminaText.TextColor3 = Color3.fromRGB(255, 255, 255)
    staminaText.Font = Enum.Font.SourceSansBold
    staminaText.TextSize = 14
    staminaText.Parent = frame
    
    -- تحديث شريط الستامينا
    local function updateStaminaBar()
        local stamina = player.PlayerValues.Stamina.Value
        local maxStamina = player.PlayerValues.MaxStamina.Value
        
        staminaBar.Size = UDim2.new(stamina / maxStamina, 0, 1, 0)
        
        -- تغيير لون الشريط بناء على كمية الستامينا
        if stamina < 30 then
            staminaBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        elseif stamina < 60 then
            staminaBar.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        else
            staminaBar.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        end
    end
    
    player.PlayerValues.Stamina.Changed:Connect(updateStaminaBar)
    updateStaminaBar() -- التحديث الأولي
end

-- إنشاء واجهة المستخدم للاعبين الجدد
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        createStaminaUI(player)
    end)
    
    if player.Character then
        createStaminaUI(player)
    end
end)

-- إنشاء واجهة المستخدم للاعبين الموجودين
for _, player in ipairs(Players:GetPlayers()) do
    if player.Character then
        createStaminaUI(player)
    end
end

print("نظام الحركة المتقدم قد تم تحميله بنجاح!")

## شرح موجز للسكربت:

1. **إعداد قيم اللاعب**: ينشئ مجلدًا يحتوي على قيم الستامينا والقدرات الخاصة.

2. **نظام الحركة الأساسي**: يتيح المشي والجري والقفز مع إعدادات سرعة مخصصة.

3. **القدرات الخاصة**:
   - **القفز المزدوج**: يسمح للاعب بالقفز مرة أخرى في الهواء.
   - **الاندفاع (Dash)**: يندفع اللاعب بسرعة في اتجاه الحركة.
   - **الانزلاق**: ينزلق اللاعب على الأرض مع تقليل الجاذبية.

4. **نظام الستامينا**: يستهلك الجري والقدرات الخاصة من طاقة اللاعب التي تتجدد بمرور الوقت.

5. **التأثيرات البصرية**: تأثيرات جسيمات وتوهج للقدرات الخاصة.

6. **واجهة المستخدم**: شريط الستامينا الذي يعرض طاقة اللاعب المتبقية.

السكربت جاهز للاستخدام مباشرة في Roblox Studio وسيعمل فور نسخه ولصقه في Script داخل أي جزء من اللعبة.