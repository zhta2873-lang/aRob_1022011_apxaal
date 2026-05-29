إليك سكربت Lua لروبلكس:

-- جزء الخدمة
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- إنشاء RemoteEvent للاتصال بين الخادم والعميل
local ChatEvent = Instance.new("RemoteEvent")
ChatEvent.Name = "ChatEvent"
ChatEvent.Parent = ReplicatedStorage

-- وظيفة عند انضمام لاعب
local function onPlayerAdded(player)
    print(player.Name .. " انضم إلى اللعبة!")
    
    -- إنشاء مجلد للاعب
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    -- إضافة نقاط للاعب
    local points = Instance.new("IntValue")
    points.Name = "Points"
    points.Value = 0
    points.Parent = leaderstats
    
    -- إرسال رسالة ترحيب
    player.Chatted:Connect(function(message)
        print(player.Name .. " يقول: " .. message)
        ChatEvent:FireAllClients(player.Name .. ": " .. message)
    end)
end

-- وظيفة عند مغادرة لاعب
local function onPlayerRemoving(player)
    print(player.Name .. " غادر اللعبة!")
end

-- ربط الأحداث
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- جزء العميل
local function onChatMessage(message)
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = message,
        Color = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSansBold,
        FontSize = Enum.FontSize.Size18
    })
end

ChatEvent.OnClientEvent:Connect(onChatMessage)

-- وظيفة لزيادة النقاط
local function addPoints(player, amount)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local points = leaderstats:FindFirstChild("Points")
        if points then
            points.Value = points.Value + amount
        end
    end
end

-- مثال لاستدعاء الوظيفة
game.Players.PlayerAdded:Connect(function(player)
    wait(5)
    addPoints(player, 10)
    print("تم إضافة 10 نقاط لـ " .. player.Name)
end)

ملاحظة: هذا السكربت يحتوي على جزئين (الخادم والعميل) ويعمل على:
1. إدارة دخول وخروج اللاعبين
2. نظام محادثة بسيط
3. نظام نقاط أساسي
4. إرسال رسائل بين الخادم والعميل