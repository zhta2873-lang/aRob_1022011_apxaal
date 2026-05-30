-- Script لإنشاء عملة في Roblox (Lua)
-- ضعه في ServerScriptService

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local CoinsDataStore = DataStoreService:GetDataStore("PlayerCoins")

game.Players.PlayerAdded:Connect(function(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local coins = Instance.new("IntValue")
    coins.Name = "Coins"
    coins.Value = 0
    coins.Parent = leaderstats
    
    -- تحميل البيانات المحفوظة
    local success, err = pcall(function()
        local savedCoins = CoinsDataStore:GetAsync(player.UserId)
        if savedCoins then
            coins.Value = savedCoins
        end
    end)
    
    if not success then
        warn("Failed to load coins for " .. player.Name .. ": " .. err)
    end
end)

game.Players.PlayerRemoving:Connect(function(player)
    local coins = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Coins")
    if coins then
        local success, err = pcall(function()
            CoinsDataStore:SetAsync(player.UserId, coins.Value)
        end)
        
        if not success then
            warn("Failed to save coins for " .. player.Name .. ": " .. err)
        end
    end
end)

-- جزء لإضافة عملات للاعب عند لمس جزء معين
local function onPartTouched(otherPart)
    local player = game.Players:GetPlayerFromCharacter(otherPart.Parent)
    if player then
        local coins = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Coins")
        if coins then
            coins.Value = coins.Value + 1
        end
    end
end

-- إنشاء جزء في اللعبة يعطي عملات عند لمسه
local coinPart = Instance.new("Part")
coinPart.Name = "CoinGiver"
coinPart.Size = Vector3.new(4, 1, 4)
coinPart.Position = Vector3.new(0, 5, 0)
coinPart.Anchored = true
coinPart.CanCollide = true
coinPart.BrickColor = BrickColor.new("Bright yellow")
coinPart.Parent = workspace

local touchConnection = coinPart.Touched:Connect(onPartTouched)

-- لمنع إعطاء عملات متعددة بسرعة
local debounce = false
coinPart.Touched:Connect(function(otherPart)
    if debounce then return end
    debounce = true
    
    onPartTouched(otherPart)
    
    wait(1) -- تأخير 1 ثانية قبل السماح بإعطاء عملة أخرى
    debounce = false
end)