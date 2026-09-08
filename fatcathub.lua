local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    HumanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
end)

-- ====================================================================
-- 1. BẢNG CẤU HÌNH & HỆ THỐNG TỰ ĐỘNG LƯU/TẢI THEO TÊN NGUỜI CHƠI
-- ====================================================================
-- Tên file tự động lấy theo Username của tài khoản đang chơi
local ConfigFileName = "BloxFruits_" .. LocalPlayer.Name .. "_Config.json"

local DefaultConfig = {
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
    SelectedDropdown = "Lựa chọn 1",
    InputText = ""
}

local Config = {}
for k, v in pairs(DefaultConfig) do
    Config[k] = v
end

local function SaveConfig()
    pcall(function()
        if writefile then
            writefile(ConfigFileName, HttpService:JSONEncode(Config))
        end
    end)
end

local function LoadConfig()
    pcall(function()
        if isfile and isfile(ConfigFileName) and readfile then
            local decoded = HttpService:JSONDecode(readfile(ConfigFileName))
            if type(decoded) == "table" then
                for k, v in pairs(decoded) do
                    if Config[k] ~= nil then
                        Config[k] = v
                    end
                end
            end
        end
    end)
end

-- Tải cấu hình tài khoản ngay khi thực thi script
LoadConfig()

-- ====================================================================
-- 2. KHỞI TẠO CỬA SỔ UI (FLUENT)
-- ====================================================================
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
-- 4. BỘ MẪU CÁC THÀNH PHẦN GIAO DIỆN (FLUENT COMPONENTS)
-- ====================================================================

-- [1. PARAGRAPH]
Tabs.Farm:AddParagraph({
    Title = "Hướng Dẫn Sử Dụng",
    Content = "Đây là khung chứa văn bản thông báo hoặc hướng dẫn.\nDùng \\n để xuống dòng."
})

-- [2. TOGGLE]
Tabs.Farm:AddSection("Cấu Hình Công Tắc")
local ExampleToggle = Tabs.Farm:AddToggle("ExampleToggle", { 
    Title = "Tên Công Tắc (Toggle)", 
    Description = "Mô tả ngắn gọn chức năng ở đây",
    Default = Config.AutoFarm 
})
ExampleToggle:OnChanged(function(Value)
    Config.AutoFarm = Value
    SaveConfig()
    
    if Value then
        task.spawn(function()
            while Config.AutoFarm do
                pcall(function()
                    -- Code chạy ngầm ở đây
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
        -- Logic thực thi ở đây
    end
})

-- [4. DROPDOWN]
Tabs.Farm:AddSection("Cấu Hình Menu Chọn")
local ExampleDropdown = Tabs.Farm:AddDropdown("ExampleDropdown", {
    Title = "Danh Sách Chọn (Dropdown)",
    Values = {"Lựa chọn 1", "Lựa chọn 2", "Lựa chọn 3", "Lựa chọn 4", "Lựa chọn 5"},
    Default = Config.SelectedDropdown,
    Multi = false,
    Callback = function(Value)
        Config.SelectedDropdown = Value
        SaveConfig()
    end
})

-- [5. SLIDER]
Tabs.Farm:AddSection("Cấu Hình Thanh Trượt")
local ExampleSlider = Tabs.Farm:AddSlider("ExampleSlider", {
    Title = "Thanh Trượt Giá Trị (Slider)",
    Description = "Kéo để thay đổi giá trị số",
    Default = Config.TweenSpeed,
    Min = 100,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        Config.TweenSpeed = Value
        SaveConfig()
    end
})

-- [6. INPUT]
Tabs.Farm:AddSection("Cấu Hình Ô Nhập Text")
local ExampleInput = Tabs.Farm:AddInput("ExampleInput", {
    Title = "Ô Nhập Liệu (Input)",
    Default = Config.InputText,
    Placeholder = "Nhập văn bản vào đây...",
    Numeric = false,
    Finished = true,
    Callback = function(Value)
        Config.InputText = Value
        SaveConfig()
    end
})

-- [7. COLORPICKER]
Tabs.Farm:AddSection("Cấu Hình Chọn Màu")
local ExampleColorpicker = Tabs.Farm:AddColorpicker("ExampleColorpicker", {
    Title = "Bảng Chọn Màu (Colorpicker)",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Value)
        -- Value kiểu Color3
    end
})

-- ====================================================================
-- 5. CẤU HÌNH TAB SETTING (THEME, TRONG SUỐT, PHÍM TẮT & NÚT RESET)
-- ====================================================================

-- Khởi tạo cài đặt Giao diện (Theme, Transparency, Keybind)
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()

-- Tự động tạo phần Theme, Transparency và Phím tắt
InterfaceManager:BuildInterfaceSection(Tabs.Setting)

-- Phần quản lý Config tự động theo tên tài khoản
Tabs.Setting:AddSection("Quản Lý Cấu Hình (" .. LocalPlayer.Name .. ")")

Tabs.Setting:AddButton({
    Title = "Đặt Lại Cấu Hình Mặc Định",
    Description = "Khôi phục toàn bộ cài đặt chức năng về mặc định",
    Callback = function()
        for k, v in pairs(DefaultConfig) do
            Config[k] = v
        end
        
        SaveConfig()
        
        ExampleToggle:SetValue(Config.AutoFarm)
        ExampleDropdown:SetValue(Config.SelectedDropdown)
        ExampleSlider:SetValue(Config.TweenSpeed)
        ExampleInput:SetValue(Config.InputText)
        
        Fluent:Notify({
            Title = "Cấu Hình",
            Content = "Đã đặt lại cấu hình về mặc định!",
            Duration = 3
        })
    end
})

Window:SelectTab(1)
Fluent:Notify({
    Title = "Blox Fruits Premium Hub",
    Content = "Đã tải cấu hình tài khoản " .. LocalPlayer.Name .. "!",
    Duration = 5
})
