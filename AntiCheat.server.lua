--test

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local DataStoreService = game:GetService("DataStoreService")

local Config = require(script:WaitForChild("Config"))
local Permissions = require(script:WaitForChild("Permissions"))

local BanStore = DataStoreService:GetDataStore("PermanentBans")

local Warnings = {}
local PlayerData = {}
local SlideZones = {}

for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and obj.Name == Config.SLIDE_ZONE_NAME then
        table.insert(SlideZones, obj)
    end
end

local function IsInSlideZone(character)
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    for _, zone in pairs(SlideZones) do
        if (root.Position - zone.Position).Magnitude <= zone.Size.Magnitude / 2 then
            return true
        end
    end
    return false
end

local function WarnPlayer(player, reason)
    Warnings[player.UserId] = (Warnings[player.UserId] or 0) + 1

    if Warnings[player.UserId] >= Config.MAX_WARNINGS then
        pcall(function()
            BanStore:SetAsync(player.UserId, true)
        end)
        player:Kick("Ban définitif\nRaison : "..reason)
    end
end

Players.PlayerAdded:Connect(function(player)
    local banned = false
    pcall(function()
        banned = BanStore:GetAsync(player.UserId)
    end)

    if banned then
        player:Kick("Vous êtes banni définitivement.")
        return
    end

    player.CharacterAdded:Connect(function(character)
        local root = character:WaitForChild("HumanoidRootPart")
        PlayerData[player] = {
            LastPosition = root.Position,
            LastCheck = tick()
        }
    end)
end)

local function CheckPlayer(player)
    if not player.Character then return end
    if Permissions:IsStaff(player) then return end

    local humanoid = player.Character:FindFirstChild("Humanoid")
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end

    local data = PlayerData[player]
    if not data then return end

    local now = tick()
    if now - data.LastCheck < Config.CHECK_INTERVAL then return end

    local delta = root.Position - data.LastPosition
    local horizontalSpeed = Vector3.new(delta.X, 0, delta.Z).Magnitude / (now - data.Last
