هذا هو السكربت الكامل بلغة Lua لإنشاء "بلوكس فروت" في روبلوكس:

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local Fruit = {}
Fruit.__index = Fruit

function Fruit.new(name, rarity, modelPath)
    local self = setmetatable({}, Fruit)
    self.Name = name
    self.Rarity = rarity
    self.Model = modelPath and ServerStorage:FindFirstChild(modelPath) or nil
    return self
end

function Fruit:CloneModel()
    if self.Model then
        return self.Model:Clone()
    end
    return nil
end

local FruitSystem = {}
FruitSystem.__index = FruitSystem

function FruitSystem.new()
    local self = setmetatable({}, FruitSystem)
    self.Fruits = {}
    return self
end

function FruitSystem:AddFruit(fruit)
    table.insert(self.Fruits, fruit)
end

function FruitSystem:GetRandomFruit()
    if #self.Fruits == 0 then return nil end
    return self.Fruits[math.random(1, #self.Fruits)]
end

local fruitSystem = FruitSystem.new()

-- إنشاء بعض الفواكه الافتراضية
fruitSystem:AddFruit(Fruit.new("Bomb Fruit", "Rare", "BombFruitModel"))
fruitSystem:AddFruit(Fruit.new("Ice Fruit", "Uncommon", "IceFruitModel"))
fruitSystem:AddFruit(Fruit.new("Flame Fruit", "Legendary", "FlameFruitModel"))
fruitSystem:AddFruit(Fruit.new("Spin Fruit", "Common", "SpinFruitModel"))
fruitSystem:AddFruit(Fruit.new("Dark Fruit", "Mythical", "DarkFruitModel"))

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        
        humanoid.Died:Connect(function()
            local fruit = fruitSystem:GetRandomFruit()
            if fruit then
                local fruitModel = fruit:CloneModel()
                if fruitModel then
                    fruitModel.Parent = workspace
                    fruitModel:SetPrimaryPartCFrame(character:GetPivot())
                    
                    local touchConnection
                    touchConnection = fruitModel.Touched:Connect(function(hit)
                        local touchedPlayer = game.Players:GetPlayerFromCharacter(hit.Parent)
                        if touchedPlayer then
                            -- يمكنك هنا إضافة تأثيرات الفاكهة على اللاعب
                            fruitModel:Destroy()
                            touchConnection:Disconnect()
                        end
                    end)
                end
            end
        end)
    end)
end

Players.PlayerAdded:Connect(onPlayerAdded)