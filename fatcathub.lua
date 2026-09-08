local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local http_request = request or http_request or (syn and syn.request) or (http and http.request)

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
end)

-- 1. BẢNG CẤU HÌNH (Lưu trạng thái bật/tắt biến)
local Config = {
    AutoFarm = false,
    FarmMode = "Level",
    SelectedWeapon = "Melee",
    AutoQuest = true,
    FastAttack = true,
    AutoBuso = true,
    TweenSpeed = 300,
    AutoCakePrince = false,
    AutoDoughKing = false,
    AutoBones = false,
    
    AutoStackMob = false,
    BringMobDist = 250,
    DisableMobCollision = false,
    
    SelectedStyle = "Godhuman",
    AutoBuyStyle = false,
    SelectedShopItem = "Random Fruit",
    
    AutoRejoin = true,
    AutoHopLowServer = false,
    
    ESPPlayer = false,
    ESPFruit = false,
    ESPChest = false,
    ESPBoss = false,
    SelectedStat = "Melee",
    AutoStats = false,
    StatPoints = 1,
    
    AutoRandomFruit = false,
    AutoStoreFruit = false,
    SelectedRaid = "Flame",
    AutoBuyChip = false,
    AutoStartRaid = false,
    AutoRaid = false,
    
    SelectedIsland = "Starter Island",
    SelectedPlayer = "",
    AutoKillTarget = false,
    
    AutoRaceV4 = false,
    AutoPullLever = false,
    AutoTempleTeleport = false,
    AutoTrial = false,
    
    AutoSeaEvent = false,
    AutoKillSeaBeast = false,
    AutoKillTerrorShark = false,
    BoatSpeed = 100,
    
    WhiteScreen = false,
    AntiAFK = true,
    
    WebhookURL = "",
    WebhookOnLevel = false,
    WebhookOnFruit = false
}

-- 2. KHỞI TẠO CỬA SỔ UI (FLUENT)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Blox Fruits Premium Hub",
    SubTitle = "v2.5 Full Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- 3. KHỞI TẠO 12 TAB CHÍNH
local TabDefinitions = {
    {"Info", "Info", "info"},
    {"Farm", "Farm Level", "sword"},
    {"StackFarming", "Stack Farming", "layers"},
    {"ItemShop", "Item & Shop", "package"},
    {"ServerHopFarm", "Server Hop", "server"},
    {"ESPStats", "ESP & Stats", "eye"},
    {"FruitRaid", "Fruits & Raid", "apple"},
    {"TeleportPvP", "Teleport & PvP", "map-pin"},
    {"Race", "Race V4", "shield"},
    {"SeaEvent", "Sea Events", "waves"},
    {"Setting", "Settings", "settings"},
    {"DiscordWebhook", "Discord Webhook", "message-circle"}
}

local Tabs = {}
for _, tabData in ipairs(TabDefinitions) do
    Tabs[tabData[1]] = Window:AddTab({ Title = tabData[2], Icon = tabData[3] })
end

-- ====================================================================
-- 4. VÍ DỤ MẪU: HƯỚNG DẪN CÁCH THÊM GIAO DIỆN VÀO CÁC TAB
-- ====================================================================

-- [MẪU 1: VÍ DỤ CÔNG TẮC BẬT/TẮT (TOGGLE)]
Tabs.Farm:AddSection("Ví Dụ Công Tắc")
local ExampleToggle = Tabs.Farm:AddToggle("ExampleToggle", { 
    Title = "Tên Công Tắc Mẫu", 
    Default = Config.AutoFarm 
})
ExampleToggle:OnChanged(function(Value)
    Config.AutoFarm = Value
    -- <-- VIẾT CODE XỬ LÝ TRỰC TIẾP TẠI ĐÂY KHI BẬT/TẮT CÔNG TẮC
end)

-- [MẪU 2: VÍ DỤ NÚT BẤM (BUTTON)]
Tabs.Farm:AddSection("Ví Dụ Nút Bấm")
Tabs.Farm:AddButton({
    Title = "Tên Nút Bấm Mẫu",
    Callback = function()
        -- <-- VIẾT CODE CHẠY 1 LẦN TẠI ĐÂY KHI BẤM NÚT
    end
})

-- ====================================================================
-- BẠN CÓ THỂ THÊM THÊM CODE VÀO CÁC TAB THEO MẪU DƯỚI ĐÂY:
-- Tabs.StackFarming:AddToggle(...)
-- Tabs.ItemShop:AddButton(...)
-- Tabs.ServerHopFarm:AddDropdown(...)
-- Tabs.ESPStats:...
-- Tabs.FruitRaid:...
-- Tabs.TeleportPvP:...
-- Tabs.Race:...
-- Tabs.SeaEvent:...
-- Tabs.DiscordWebhook:...
-- ====================================================================

-- 5. CẤU HÌNH TAB SETTING (LƯU VÀ TẢI CẤU HÌNH)
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:BuildInterfaceSection(Tabs.Setting)
SaveManager:BuildConfigSection(Tabs.Setting)

-- 6. KHUNG VÒNG LẶP CHẠY NGẦM (BACKGROUND LOOP)
task.spawn(function()
    while task.wait(0.1) do
        if Config.AutoFarm then
            pcall(function()
                -- <-- VIẾT CODE CHẠY LIÊN TỤC KHI BẬT CÁC CHỨC NĂNG CHẠY NGẦM TẠI ĐÂY
            end)
        end
    end
end)

Window:SelectTab(1)
Fluent:Notify({
    Title = "Blox Fruits Premium Hub",
    Content = "Khung script đã sẵn sàng để thêm chức năng!",
    Duration = 5
})
