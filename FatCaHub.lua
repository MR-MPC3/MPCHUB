-- ====================================================================
-- 1. DỊCH VỤ HỆ THỐNG ROBLOX (ROBLOX SERVICES)
-- ====================================================================
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")
local CollectionService = game:GetService("CollectionService")
local PathfindingService = game:GetService("PathfindingService")
local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ProximityPromptService = game:GetService("ProximityPromptService")
local Lighting = game:GetService("Lighting")

local ParentGui = (gethui and gethui()) or CoreGui

-- ====================================================================
-- 2. KIỂM TRA MAP & SEA CHECK 
-- ====================================================================
local MAP_SEAS = {
    [85211729168715] = 1,  -- Sea 1
    [79091703265657] = 2,  -- Sea 2
    [100117331123089] = 3   -- Sea 3
}

local currentSea = MAP_SEAS[game.PlaceId]
if not currentSea then
    Players.LocalPlayer:Kick("PlaceId không hợp lệ!")
    return
end

local Sea1 = currentSea == 1
local Sea2 = currentSea == 2
local Sea3 = currentSea == 3

-- ====================================================================
-- 3. QUẢN LÝ NHÂN VẬT & MÁY CHỦ (PLAYER & CHARACTER)
-- ====================================================================
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
end)

-- ====================================================================
-- 4. REMOTES & THƯ MỤC BLOX FRUITS
-- ====================================================================
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
local CommF = Remotes and Remotes:WaitForChild("CommF_", 10)
local CommE = Remotes and Remotes:WaitForChild("CommE", 10)

local EnemiesFolder = Workspace:WaitForChild("Enemies", 10)
local NPCsFolder = Workspace:WaitForChild("NPCs", 10)
local MapFolder = Workspace:WaitForChild("Map", 10)
local SeaBeastsFolder = Workspace:FindFirstChild("SeaBeasts")
local BoatsFolder = Workspace:FindFirstChild("Boats")

-- ====================================================================
-- 5. KHỞI TẠO FRAMEWORK FLUENT UI & TABS
-- ====================================================================
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mr-PMC/FluentUI/refs/heads/master/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mr-PMC/FluentUI/refs/heads/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mr-PMC/FluentUI/refs/heads/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fat Cat Hub",
    SubTitle = "v2.5 Full Edition | Sea " .. tostring(currentSea),
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 320),
    Acrylic = true,
})

local TabDefinitions = {
    {"Info", "Info", "info"},
    {"Farm", "Farm", "sword"},
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
-- 6. CÁC HÀM HỖ TRỢ CÁC CHỨC NĂNG TRONG BUILD UI
-- ====================================================================
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
end)

-- ====================================================================
-- 7. XÂY DỰNG GIAO DIỆN CHỨC NĂNG (BUILD UI ELEMENTS)
-- ====================================================================
local function BuildUI()
    -- [1. PARAGRAPH]
    Tabs.Farm:AddParagraph({
        Title = "Hướng Dẫn Sử Dụng",
        Content = "Đang hoạt động tại: Sea " .. tostring(currentSea) .. "\nChọn các chức năng bên dưới để bắt đầu Farm."
    })

    -- [2. TOGGLE]
    Tabs.Farm:AddSection("Cấu Hình Công Tắc")
    local ExampleToggle = Tabs.Farm:AddToggle("ExampleToggle", { 
        Title = "Tên Công Tắc (Toggle)", 
        Description = "Mô tả ngắn gọn chức năng ở đây",
        Default = false 
    })
    ExampleToggle:OnChanged(function(Value)
        if Value then
            task.spawn(function()
                while Fluent.Options.ExampleToggle and Fluent.Options.ExampleToggle.Value do
                    pcall(function()
                        -- Logic loop chạy ngầm
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end)

    -- [3. BUTTON]
    Tabs.Farm:AddSection("Cấu Hình Nút Bấm")
    Tabs.Farm:AddButton({
        Title = "Tên Nút Bấm (Button)",
        Description = "Bấm vào để kích hoạt hành động 1 lần",
        Callback = function()
            -- Logic xử lý
        end
    })

    -- [4. DROPDOWN]
    Tabs.Farm:AddSection("Cấu Hình Menu Chọn")
    Tabs.Farm:AddDropdown("ExampleDropdown", {
        Title = "Danh Sách Chọn (Dropdown)",
        Values = {"Lựa chọn 1", "Lựa chọn 2", "Lựa chọn 3", "Lựa chọn 4", "Lựa chọn 5"},
        Default = "Lựa chọn 1",
        Multi = false,
        Callback = function(Value)
            -- Logic xử lý
        end
    })

    -- [5. SLIDER]
    Tabs.Farm:AddSection("Cấu Hình Thanh Trượt")
    Tabs.Farm:AddSlider("ExampleSlider", {
        Title = "Thanh Trượt Giá Trị (Slider)",
        Description = "Kéo để thay đổi giá trị số",
        Default = 300,
        Min = 100,
        Max = 500,
        Rounding = 0,
        Callback = function(Value)
            -- Logic xử lý
        end
    })

    -- [6. INPUT]
    Tabs.Farm:AddSection("Cấu Hình Ô Nhập Text")
    Tabs.Farm:AddInput("ExampleInput", {
        Title = "Ô Nhập Liệu (Input)",
        Default = "",
        Placeholder = "Nhập văn bản vào đây...",
        Numeric = false,
        Finished = true,
        Callback = function(Value)
            -- Logic xử lý
        end
    })

    -- [7. COLORPICKER]
    Tabs.Farm:AddSection("Cấu Hình Chọn Màu")
    Tabs.Farm:AddColorpicker("ExampleColorpicker", {
        Title = "Bảng Chọn Màu (Colorpicker)",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(Value)
            -- Value dạng Color3
        end
    })
end

-- 8. QUẢN LÝ CẤU HÌNH & TỰ ĐỘNG LƯU (SAVE MANAGER & CONFIG)
local function SetupConfigManager()
    local DEFAULT_CONFIG = "BloxFruit_" .. LocalPlayer.Name
    local autoSaveActive = true

    -- Cấu hình Thư viện Save
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:SetFolder("FatCatHub")
    InterfaceManager:SetFolder("FatCatHub")

    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})

    -- Tạo giao diện Setting hệ thống
    InterfaceManager:BuildInterfaceSection(Tabs.Setting)

    -- Nút Reset Config
    Tabs.Setting:AddSection("Đặt Lại Cấu Hình")
    Tabs.Setting:AddButton({
        Title = "Reset Config",
        Description = "Xóa file cấu hình đã lưu. Vui lòng re-execute lại script để về mặc định.",
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
                Content = "Đã xóa file Config! Vui lòng re-execute lại Script để áp dụng mặc định.",
                Duration = 5
            })
        end
    })

    -- Load Config đã lưu khi mở Hub
    pcall(function()
        SaveManager:Load(DEFAULT_CONFIG)
    end)

    -- Debounce Auto-Save
    local saveThread = nil
    local function RequestAutoSave()
        if not autoSaveActive then return end
        if saveThread then task.cancel(saveThread) end
        
        saveThread = task.delay(0.5, function()
            pcall(function()
                SaveManager:Save(DEFAULT_CONFIG)
            end)
        end)
    end

    -- Đăng ký lắng nghe sự thay đổi của tất cả UI elements
    task.defer(function()
        for _, option in pairs(Fluent.Options) do
            if type(option) == "table" and typeof(option.OnChanged) == "function" then
                option:OnChanged(function()
                    RequestAutoSave()
                end)
            end
        end
    end)
end

-- ====================================================================
-- 8. THỰC THI KHỞI CHẠY HỆ THỐNG
-- ====================================================================
BuildUI()

SetupConfigManager()

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fat Cat Hub",
    Content = "Fat Cat Hub - Tải Xong",
    Duration = 5
})
