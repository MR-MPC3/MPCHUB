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

-- 1. BẢNG CẤU HÌNH (Lưu trạng thái biến)
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
-- 4. BỘ MẪU CÁC THÀNH PHẦN GIAO DIỆN (FLUENT COMPONENTS)
-- ====================================================================

-- [1. MẪU ĐOẠN VĂN BẢN (PARAGRAPH)]
Tabs.Farm:AddParagraph({
    Title = "Hướng Dẫn Sử Dụng",
    Content = "Đây là khung chứa văn bản thông báo hoặc hướng dẫn.\nDùng \\n để xuống dòng."
})

-- [2. MẪU CÔNG TẮC BẬT/TẮT LỒNG VÒNG LẶP (TOGGLE)]
Tabs.Farm:AddSection("Cấu Hình Công Tắc")
local ExampleToggle = Tabs.Farm:AddToggle("ExampleToggle", { 
    Title = "Tên Công Tắc (Toggle)", 
    Description = "Mô tả ngắn gọn chức năng ở đây",
    Default = Config.AutoFarm 
})
ExampleToggle:OnChanged(function(Value)
    Config.AutoFarm = Value
    
    if Value then
        task.spawn(function()
            while Config.AutoFarm do
                pcall(function()
                    -- Viết code chạy ngầm liên tục khi bật nút ở đây
                end)
                task.wait(0.1)
            end
        end)
    end
end)

-- [3. MẪU NÚT BẤM (BUTTON)]
Tabs.Farm:AddSection("Cấu Hình Nút Bấm")
Tabs.Farm:AddButton({
    Title = "Tên Nút Bấm (Button)",
    Description = "Bấm vào để kích hoạt hành động 1 lần",
    Callback = function()
        -- Viết logic thực thi 1 lần ở đây
    end
})

-- [4. MẪU DANH SÁCH CHỌN (DROPDOWN)]
Tabs.Farm:AddSection("Cấu Hình Menu Chọn")
local ExampleDropdown = Tabs.Farm:AddDropdown("ExampleDropdown", {
    Title = "Danh Sách Chọn (Dropdown)",
    Values = {"Lựa chọn 1", "Lựa chọn 2", "Lựa chọn 3","Lựa chọn 4","Lựa chọn 5","Lựa chọn 6","Lựa chọn 7","Lựa chọn 8","Lựa chọn 9","Lựa chọn 10","Lựa chọn 11","Lựa chọn 12"},
    Default = "Lựa chọn 1",
    Multi = false,
    Callback = function(Value)
        -- Viết logic xử lý giá trị được chọn ở đây
    end
})

-- [5. MẪU THANH TRƯỢT SỐ (SLIDER)]
Tabs.Farm:AddSection("Cấu Hình Thanh Trượt")
local ExampleSlider = Tabs.Farm:AddSlider("ExampleSlider", {
    Title = "Thanh Trượt Giá Trị (Slider)",
    Description = "Kéo để thay đổi giá trị số",
    Default = 300,
    Min = 100,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        Config.TweenSpeed = Value
        -- Viết logic cập nhật thông số ở đây
    end
})

-- [6. MẪU Ô NHẬP LIỆU (INPUT)]
Tabs.Farm:AddSection("Cấu Hình Ô Nhập Text")
local ExampleInput = Tabs.Farm:AddInput("ExampleInput", {
    Title = "Ô Nhập Liệu (Input)",
    Default = "",
    Placeholder = "Nhập văn bản vào đây...",
    Numeric = false,
    Finished = true,
    Callback = function(Value)
        -- Viết logic nhận dữ liệu chữ/số ở đây
    end
})

-- [7. MẪU BẢNG CHỌN MÀU (COLORPICKER)]
Tabs.Farm:AddSection("Cấu Hình Chọn Màu")
local ExampleColorpicker = Tabs.Farm:AddColorpicker("ExampleColorpicker", {
    Title = "Bảng Chọn Màu (Colorpicker)",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(Value)
        -- Value trả về kiểu Color3 (RGB)
    end
})

-- ====================================================================
-- 5. CẤU HÌNH TAB SETTING (LƯU VÀ TẢI CẤU HÌNH)
-- ====================================================================
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
InterfaceManager:BuildInterfaceSection(Tabs.Setting)
SaveManager:BuildConfigSection(Tabs.Setting)

Window:SelectTab(1)
Fluent:Notify({
    Title = "Blox Fruits Premium Hub",
    Content = "Khung script đã sẵn sàng!",
    Duration = 5
})
