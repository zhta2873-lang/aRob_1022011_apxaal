local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StartEvent = ReplicatedStorage:FindFirstChild("StartEvent") or Instance.new("RemoteEvent")
StartEvent.Name = "StartEvent"
StartEvent.Parent = ReplicatedStorage

local function onStart(player)
    print(player.Name .. " started the game!")
end

StartEvent.OnServerEvent:Connect(onStart)

local function onPlayerAdded(player)
    local bindableEvent = Instance.new("BindableEvent")
    bindableEvent.Event:Connect(function()
        StartEvent:FireClient(player)
    end)
    player:WaitForChild("PlayerGui"):WaitForChild("StarterGui"):WaitForChild("StartButton").MouseButton1Click:Connect(function()
        bindableEvent:Fire()
    end)
end

Players.PlayerAdded:Connect(onPlayerAdded)