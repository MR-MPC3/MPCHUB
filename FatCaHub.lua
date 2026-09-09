local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

-- ====================================================================
-- 0. KIỂM TRA MAP (SEA CHECK)
-- ====================================================================
local MAP_SEAS = {
    [2753915549] = 1,       [85211729168715] = 1, -- Sea 1
    [4442272183] = 2,       [79091703265657] = 2, -- Sea 2
    [7449423635] = 3,       [100117331123089] = 3 -- Sea 3
}

local currentSea = MAP_SEAS[game.PlaceId]
if not currentSea then
    LocalPlayer:Kick("PlaceId không hợp lệ!")
    return
end

local Sea1 = currentSea == 1
local Sea2 = currentSea == 2
local Sea3 = currentSea == 3

-- ====================================================================
-- KHỞI TẠO NHÂN VẬT & HELPER FUNCTIONS
-- ====================================================================
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    Humanoid = newChar:WaitForChild("Humanoid")
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Hàm dịch chuyển Tween
local function TweenTo(targetCFrame, speed)
    if not HumanoidRootPart then return end
    speed = speed or 300
    local distance = (HumanoidRootPart.Position - targetCFrame.Position).Magnitude
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

-- Hàm Trang Bị Vũ Khí
local function EquipWeapon(weaponType)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return end
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == weaponType or tool.Name:lower():find(weaponType:lower())) then
            Humanoid:EquipTool(tool)
            break
        end
    end
end

-- ====================================================================
-- 1. KHỞI TẠO CỬA SỔ UI (FLUENT) & ADDONS
-- ====================================================================
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mr-PMC/FluentUI/refs/heads/master/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mr-PMC/FluentUI/refs/heads/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mr-PMC/FluentUI/refs/heads/master/Addons/InterfaceManager.lua"))()

SaveManager:SetFolder("FatCatHub")
InterfaceManager:SetFolder("FatCatHub")

local Window = Fluent:CreateWindow({
    Title = "Fat Cat Hub",
    SubTitle = "v2.5 Official Edition | Sea " .. tostring(currentSea),
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local TabDefinitions = {
    {"Info", "Thông Tin", "info"},
    {"Farm", "Tự Động Farm", "sword"},
    {"ItemShop", "Cửa Hàng", "package"},
    {"ServerHopFarm", "Server & Teleport", "server"},
    {"ESPStats", "Stats & ESP", "eye"},
    {"FruitRaid", "Trái & Raid", "apple"},
    {"Setting", "Cài Đặt", "settings"}
}

local Tabs = {}
for _, tabData in ipairs(TabDefinitions) do
    Tabs[tabData[1]] = Window:AddTab({ Title = tabData[2], Icon = tabData[3] })
end

-- ====================================================================
-- XÂY DỰNG CÁC CHỨC NĂNG CHÍNH THỨC
-- ====================================================================
local function BuildUI()
    -------------------------------------------------------------------
    -- TAB 1: THÔNG TIN (INFO)
    -------------------------------------------------------------------
    local DataFolder = LocalPlayer:WaitForChild("Data")
    local LevelVal = DataFolder:WaitForChild("Level")
    local BeliVal = DataFolder:WaitForChild("Beli")
    local FragVal = DataFolder:WaitForChild("Fragments")

    local InfoParagraph = Tabs.Info:AddParagraph({
        Title = "Thông Tin Người Chơi",
        Content = string.format("Tên: %s\nCap: Sea %d\nCấp độ: %d\nBeli: $%s\nFragments: %s", 
            LocalPlayer.DisplayName, currentSea, LevelVal.Value, tostring(BeliVal.Value), tostring(FragVal.Value))
    })

    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                InfoParagraph:SetDesc(string.format("Tên: %s\nCap: Sea %d\nCấp độ: %d\nBeli: $%s\nFragments: %s", 
                    LocalPlayer.DisplayName, currentSea, LevelVal.Value, tostring(BeliVal.Value), tostring(FragVal.Value)))
            end)
        end
    end)

    -------------------------------------------------------------------
    -- TAB 2: TỰ ĐỘNG FARM (FARM)
    -------------------------------------------------------------------
    Tabs.Farm:AddSection("Cấu Hình Farm")

    local WeaponDropdown = Tabs.Farm:AddDropdown("SelectWeapon", {
        Title = "Chọn Loại Vũ Khí",
        Values = {"Melee", "Sword", "Blox Fruit"},
        Default = "Melee",
        Multi = false
    })

    local AutoFarmToggle = Tabs.Farm:AddToggle("AutoFarmLevel", {
        Title = "Auto Farm Level",
        Description = "Tự động nhận nhiệm vụ và đánh quái theo cấp độ",
        Default = false
    })

    AutoFarmToggle:OnChanged(function(Value)
        if Value then
            task.spawn(function()
                while Fluent.Options.AutoFarmLevel and Fluent.Options.AutoFarmLevel.Value do
                    pcall(function()
                        EquipWeapon(Fluent.Options.SelectWeapon.Value or "Melee")
                        -- [Logic Nhận Quest & Đánh Quái Theo Sea Tại Đây]
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end)

    local FastAttackToggle = Tabs.Farm:AddToggle("FastAttack", {
        Title = "Fast Attack (Đánh Nhanh)",
        Description = "Tăng tốc độ đánh cận chiến/kiếm",
        Default = true
    })

    FastAttackToggle:OnChanged(function(Value)
        if Value then
            task.spawn(function()
                while Fluent.Options.FastAttack and Fluent.Options.FastAttack.Value do
                    pcall(function()
                        local VirtualInputManager = game:GetService("VirtualInputManager")
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    end)
                    task.wait(0.05)
                end
            end)
        end
    end)

    -------------------------------------------------------------------
    -- TAB 3: ESP & AUTO CỘNG ĐIỂM (STATS & ESP)
    -------------------------------------------------------------------
    Tabs.ESPStats:AddSection("Tự Động Cộng Điểm")

    local StatPointsInput = Tabs.ESPStats:AddInput("StatPoints", {
        Title = "Số Điểm Cộng Mỗi Lần",
        Default = "1",
        Numeric = true,
        Finished = true
    })

    local AutoStatsMelee = Tabs.ESPStats:AddToggle("AutoStatMelee", { Title = "Auto Cộng Melee", Default = false })
    local AutoStatsDefense = Tabs.ESPStats:AddToggle("AutoStatDefense", { Title = "Auto Cộng Defense", Default = false })
    local AutoStatsSword = Tabs.ESPStats:AddToggle("AutoStatSword", { Title = "Auto Cộng Sword", Default = false })
    local AutoStatsFruit = Tabs.ESPStats:AddToggle("AutoStatFruit", { Title = "Auto Cộng Blox Fruit", Default = false })

    local function AddStat(statName)
        local points = tonumber(Fluent.Options.StatPoints.Value) or 1
        ReplicatedStorage.Remotes.CommF_:InvokeServer("AddPoint", statName, points)
    end

    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                if Fluent.Options.AutoStatMelee and Fluent.Options.AutoStatMelee.Value then AddStat("Melee") end
                if Fluent.Options.AutoStatDefense and Fluent.Options.AutoStatDefense.Value then AddStat("Defense") end
                if Fluent.Options.AutoStatSword and Fluent.Options.AutoStatSword.Value then AddStat("Sword") end
                if Fluent.Options.AutoStatFruit and Fluent.Options.AutoStatFruit.Value then AddStat("Demon Fruit") end
            end)
        end
    end)

    -------------------------------------------------------------------
    -- TAB 4: TRÁI ÁC QUỶ & RAID (FRUIT & RAID)
    -------------------------------------------------------------------
    Tabs.FruitRaid:AddSection("Quản Lý Trái Ác Quỷ")

    Tabs.FruitRaid:AddButton({
        Title = "Mua Trái Ngẫu Nhiên (Random Fruit)",
        Description = "Sử dụng Beli để quay Trái Ác Quỷ",
        Callback = function()
            local res = ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
            Fluent:Notify({ Title = "Thông Báo", Content = tostring(res), Duration = 5 })
        end
    })

    Tabs.FruitRaid:AddButton({
        Title = "Cất Toàn Bộ Trái Vào Rương",
        Description = "Tự động Store toàn bộ Trái Ác Quỷ trong Balo",
        Callback = function()
            for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
                if item:IsA("Tool") and item.Name:find("Fruit") then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", item.Name, item)
                end
            end
        end
    })

    -------------------------------------------------------------------
    -- TAB 5: CỬA HÀNG (ITEM & SHOP)
    -------------------------------------------------------------------
    Tabs.ItemShop:AddSection("Mua Võ (Fighting Styles)")

    local FightingStyles = {
        {"Black Leg (150k Beli)", "BuyBlackLeg"},
        {"Electro (500k Beli)", "BuyElectro"},
        {"Fishman Karate (750k Beli)", "BuyFishmanKarate"},
        {"Dragon Claw (1.5k Frags)", "BlackbeardReward", "DragonClaw", "1"},
        {"Superhuman (3M Beli)", "BuySuperhuman"}
    }

    for _, style in ipairs(FightingStyles) do
        Tabs.ItemShop:AddButton({
            Title = "Mua " .. style[1],
            Callback = function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(style, 2))
            end
        })
    end

    -------------------------------------------------------------------
    -- TAB 6: SERVER & DỊCH CHUYỂN (SERVER & TELEPORT)
    -------------------------------------------------------------------
    Tabs.ServerHopFarm:AddSection("Chức Năng Server")

    Tabs.ServerHopFarm:AddButton({
        Title = "Rejoin Server",
        Description = "Vào lại Server hiện tại",
        Callback = function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    })

    Tabs.ServerHopFarm:AddButton({
        Title = "Server Hop (Đổi Server)",
        Description = "Tìm và chuyển sang Server khác",
        Callback = function()
            local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
            for _, s in ipairs(Servers.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                    break
                end
            end
        end
    })

    -------------------------------------------------------------------
    -- TAB 7: CÀI ĐẶT & CONFIG (SETTINGS)
    -------------------------------------------------------------------
    local DEFAULT_CONFIG = "BloxFruit_" .. LocalPlayer.Name
    local autoSaveActive = true

    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})

    InterfaceManager:BuildInterfaceSection(Tabs.Setting)

    Tabs.Setting:AddSection("Quản Lý Cấu Hình")
    Tabs.Setting:AddButton({
        Title = "Reset Config Mặc Định",
        Description = "Xóa file cấu hình đã lưu",
        Callback = function()
            autoSaveActive = false
            pcall(function()
                local filePath = "FatCatHub/settings/" .. DEFAULT_CONFIG .. ".json"
                if isfile and isfile(filePath) then
                    delfile(filePath)
                end
            end)
            Fluent:Notify({
                Title = "Fat Cat Hub",
                Content = "Đã xóa file Config! Vui lòng Re-execute lại Script.",
                Duration = 5
            })
        end
    })

    pcall(function() SaveManager:Load(DEFAULT_CONFIG) end)

    task.spawn(function()
        while task.wait(3) do
            if autoSaveActive then
                pcall(function() SaveManager:Save(DEFAULT_CONFIG) end)
            end
        end
    end)
end
BuildUI()
Window:SelectTab(1)
Fluent:Notify({
    Title = "Fat Cat Hub",
    Content = "Đã tải thành công giao diện v2.5!",
    Duration = 4
})
